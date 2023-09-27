import datetime
import hashlib
import json
import os
import random
import sqlite3
import subprocess

import arrow
import ffmpeg
import requests
from flask import g, Flask, request, session, send_from_directory

from DATABASE import *

# if __name__ == '__main__:':
app = Flask(__name__)

SHORTEST_RECORD_TIME = 20
SHORTEST_RECORD_CLOSE_TIME = 20

def make_dicts(cursor, row):
    return dict((cursor.description[idx][0], value)
                for idx, value in enumerate(row))


def query_db(query, args=(), one=False, commit=False):
    cur = get_db().execute(query, args)
    rv = cur.fetchall()
    if commit:
        get_db().commit()
    cur.close()
    return (rv[0] if rv else None) if one else rv


def get_db():
    db = getattr(g, '_database', None)
    if db is None:
        db = g._database = sqlite3.connect(DATABASE)
    # db.row_factory = sqlite3.Row
    db.row_factory = make_dicts
    return db


@app.teardown_appcontext
def close_connection(exception):
    db = getattr(g, '_database', None)
    if db is not None:
        db.close()


def tempStack():
    # g 生命周期是跟应用上下文的生命周期相同 所以不用了 改用session
    stack = getattr(g, '_halfRecordStack', None)
    if stack is None:
        print("新建栈")
        stack = g._halfRecordStack = []
    return stack


@app.route('/record/allFromDay', methods=["POST"])
def getAllRecordFromSpecifyDaySortedByTodo():
    body = request.json
    start = body['start']
    end = body['end']
    d = {"success": 1, "description": "got all records", "contents": {}}
    records = query_db(
        'select * from records where (datetime(startTime) between datetime(?) and datetime(?)) or (datetime(endTime) between datetime(?) and datetime(?))',
        (start, end, start, end))
    todoRecordDict = {}
    if records is not None:
        for record in records:
            if todoRecordDict.get(record['belongsTodo']) is not None:
                todoRecordDict.get(record['belongsTodo']).append(record)
            else:
                todoRecordDict[record['belongsTodo']] = [record]
        d["contents"] = todoRecordDict
        return d
    else:
        return {"success": -1, "description": "no matched todo"}


@app.route('/record/all')
def getAllRecord():
    # cur = get_db().cursor()
    d = {"success": 1, "description": "got all records", "contents": {}}
    for record in query_db('select * from records'):
        # print(record['id'], record['value'], record['source'])
        d["contents"][record['id']] = record
    return d


@app.route('/record/single/<recordId>')
# /record/single/todoid?by=todo
# /record/single/todosubid?by=sub
# /record/single/recordid
def getSingleRecord(recordId):
    byWhat = request.args.get("by")
    if byWhat == 'todo':
        record = query_db('select * from records where belongsTodo = ?', [recordId])
    elif byWhat == 'sub':
        record = query_db('select * from records where belongsTodoSub = ?', [recordId])
    else:
        record = query_db('select * from records where id = ?', [recordId], one=True)
    if record is None:
        return {"success": -1, "description": "No Record"}
    else:
        return {"success": 1, "description": "got Record(s)", "content": record}


@app.route('/record/add', methods=["POST"])
def addRecord():
    record = request.json
    try:
        query_db(
            # "insert into records values ('?', '?', '?', '?', '?', '?', ?, '?', '?')"
            "insert into records values (?, ?, ?, ?, ?, ?, ?, ?, ?)",
            (record["id"], record["belongsTodo"], record["belongsTodoSub"], record["recordTime"],
             record["startTime"], record["endTime"], record["value"],
             record["source"], record["note"]), commit=True)
    except sqlite3.IntegrityError as e:
        # print(e)
        return {"success": -1, "description": "UNIQUE constraint failed"}
    except Exception as e:
        print(e)
        return {"success": -2, "description": "unknown error occurred"}

    return {"success": 1, "description": "insert success"}


@app.route('/record/delete', methods=['POST'])
# 不建议使用了
def deleteRecord():
    recordId = request.json["id"]
    try:
        query_db('DELETE FROM records WHERE id = ?', [recordId], commit=True)
    except Exception as e:
        print(e)
        return {"success": -1, "description": "unknown error occurred"}

    return {"success": 1, "description": "delete success"}


@app.route('/record/todelete/add', methods=['POST'])
def addToDeleteRecord():
    recordId = request.json["id"]
    try:
        query_db('DELETE FROM records WHERE id = ?', [recordId])
        query_db("insert into toDelete values (?)", (recordId,), commit=True)
    except Exception as e:
        print(e)
        return {"success": -1, "description": "unknown error occurred"}

    return {"success": 1, "description": "delete record success"}


@app.route('/record/todelete/adds', methods=['POST'])
def addsToDeleteRecord():
    recordIds = request.json["ids"]
    try:
        for rid in recordIds:
            query_db('DELETE FROM records WHERE id = ?', [rid, ])
            query_db("insert into toDelete values (?)", (rid, ))
        get_db().commit()
    except Exception as e:
        print(e)
        return {"success": -1, "description": "unknown error occurred"}

    return {"success": 1, "description": "delete records success"}


@app.route('/record/todelete/all')
def getAllToDelete():
    toDeletes = query_db('select * from toDelete')
    if toDeletes is not None:
        strings = []
        for s in toDeletes:
            strings.append(s["id"])
        return {"success": 1, "description": "Got all toDelete", "contents": strings}
    else:
        return {"success": -1, "description": "No Todos", "contents": []}


@app.route('/record/source/distinct')
def getAllDistinctSource():
    source = query_db('select distinct source from records')
    temp = []
    for s in source:
        if s.get("source"):
            temp.append(s["source"])
    if source is not None:
        return {"success": 1, "description": "got all distinct source", "contents": temp}
    else:
        return {"success": 2, "description": "got all distinct source, but nothing", "contents": []}


@app.route('/record/app/distinct')
def getAllDistinctApp():
    screentimesub = query_db("select distinct belongsTodoSub from records where belongsTodo=?", ('screenTime',))
    temp = []
    for s in screentimesub:
        if s.get("belongsTodoSub"):
            temp.append(s["belongsTodoSub"])
    if screentimesub is not None:
        return {"success": 1, "description": "got all distinct app", "contents": temp}
    else:
        return {"success": 2, "description": "got all distinct app, but nothing", "contents": []}


@app.route('/todo/all')
def getAllTodo():
    stamp = request.args.get("stamp")
    if stamp == 'all':
        todos = query_db('select * from todos limit 10')
    elif stamp == 'stamp':
        todos = query_db('select uploadTime, hash, source from todos limit 10')
    else:
        return {"success": -2, "description": "unknown prams 'stamp'", "contents": []}
    if todos is not None:
        return {"success": 1, "description": "Got todos of " + stamp, "contents": todos}
    else:
        return {"success": -1, "description": "No Todos", "contents": []}


@app.route('/todo/newest')
def getNewestTodo():
    todos = query_db('select * from todos order by datetime(uploadTime) desc', one=True)
    if todos is not None:
        return {"success": 1, "description": "Got the newest todos", "contents": eval(todos["content"])}
    else:
        return {"success": -1, "description": "No Todos", "contents": []}


@app.route('/todo/push', methods=['post'])
# 1 got new one, need update
# 2 todos has been updated to db
# 3 already have the newest
# 10 Got todos from db, but uploader's might be newer. Two choices, /todo/justUp or /todo/newest
def pushTodoAndSync():
    todos = request.json
    todos["content"] = str(todos["content"])
    # md5 = hashlib.md5(json.dumps(todos["content"]).encode('utf-8')).hexdigest()
    md5 = hashlib.md5(todos["content"].encode('utf-8')).hexdigest()
    # md5 = todos["hash"]
    todosStamp = query_db('select uploadTime, hash, source from todos order by datetime(uploadTime) desc ', one=True)
    # 如果数据库空 则将上传的todos作为数据库的第一条记录
    if todosStamp is None:
        query_db('insert into todos values (?, ?, ?, ?)',
                 [todos["uploadTime"], md5, todos['source'], todos['content']],
                 commit=True)
        return {"success": 2, "description": "Your newest todos has been updated to the db", "contents": []}
    # 如果首条记录和上传的todos匹配 则这条记录即为最新的
    if md5 == todosStamp["hash"]:
        return {"success": 3, "description": "You're already have the newest todos", "contents": []}
    # 看这条记录是否存在过
    else:
        hasThisTodos = query_db('select hash from todos where hash=?', [md5])
        # 有这条记录 但不是最新
        if hasThisTodos:
            # newest = query_db('select * from todos order by uploadTime desc', one= True)
            return getNewestTodo()
        # 这条记录甚至都不存在
        else:
            return {"success": 10, "description": "Got todos from db, but your's might newer", "contents": []}


@app.route('/todo/justUp', methods=['post'])
def pushTodoOnly():
    todos = request.json
    todos["content"] = str(todos["content"])
    # md5 = hashlib.md5(json.dumps(todos["content"]).encode('utf-8')).hexdigest()
    md5 = hashlib.md5(todos["content"].encode('utf-8')).hexdigest()
    query_db('insert into todos values (?, ?, ?, ?)',
             [todos["uploadTime"], md5, todos['source'], todos['content']],
             commit=True)
    return {"success": 2, "description": "Your newest todos has been updated to the db", "contents": []}


def checkNewestTempRecord(record):
    beijing = datetime.timezone(datetime.timedelta(hours=8))
    # 在外面申明时间 可以保持记录时间和结束时间一致
    timeTemp = datetime.datetime.now().astimezone(beijing)
    timeNowShort = timeTemp.replace(microsecond=0).isoformat()
    timeNowLong = timeTemp.isoformat()
    recordOpen = query_db( \
        'select * from halfRecord where source=? and state=? and app=? and belongsTodo=? and belongsTodoSub=? order by datetime(time) desc',
        (record['source'], "open", record['app'], record['belongsTodo'], record['belongsTodoSub']), one=True)
    if recordOpen is not None:
        recordTime = arrow.get(recordOpen['time'])
        query_db('delete from halfRecord where source=? and state=? and app=? and belongsTodo=? and belongsTodoSub=?',
                 (record['source'], "open", record['app'], record['belongsTodo'], record['belongsTodoSub']))
        if (arrow.now()-recordTime).seconds <= SHORTEST_RECORD_TIME:  #小于10秒不算开
            return {"success": 3, "description": "too short record time"}
        idTemp = "{}{}".format(timeNowLong, record['belongsTodoSub'])
        query_db('insert into records values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                 (idTemp, record['belongsTodo'], record['belongsTodoSub'], timeNowShort, recordOpen['time'],
                  record['time'], 1, record['source'], ""), commit=True)
        return {"success": 2, "description": "paired success"}
    else:
        return {"success": -1, "description": "no open record"}


def closeAllTempRecord(record, onlyme):
    if onlyme:
        records = query_db('select * from halfRecord where source=? and state=?',
                           (record['source'], "open"))
    else:
        records = query_db('select * from halfRecord where state=?',
                           ("open",))
    if len(records) == 0:
        return {"success": 3, "description": "no opened record"}
    else:
        beijing = datetime.timezone(datetime.timedelta(hours=8))
        for r in records:
            # 在里面申明时间 来作为id可以保持不同
            timeTemp = datetime.datetime.now().astimezone(beijing)
            timeNowShort = timeTemp.replace(microsecond=0).isoformat()
            timeNowLong = timeTemp.isoformat()
            idTemp = "{}{}".format(timeNowLong, r['belongsTodoSub'])
            query_db('insert into records values (?, ?, ?, ?, ?, ?, ?, ?, ?)',
                     (idTemp, r['belongsTodo'], r['belongsTodoSub'], timeNowShort, r['time'], record['time'], 1,
                      r['source'], ""))
            query_db(
                'delete from halfRecord where source=? and state=? and app=? and belongsTodo=? and belongsTodoSub=?',
                (r['source'], "open", r['app'], r['belongsTodo'], r['belongsTodoSub']))
            get_db().commit()
        return {"success": 2, "description": "paired success"}


def insertTempRecord(record):
    try:
        recordRecent = query_db(
            'select * from records where source=? and belongsTodoSub=? and belongsTodo=? order by datetime(endTime) desc',
            (record['source'], record['app'], record['belongsTodo']), one=True)
        if recordRecent is not None:
            recordTime = arrow.get(recordRecent['endTime'])
            # print(arrow.now()) # 有一个奇怪的bug会导致不同环境下的arrow获取到的时间是不准的 可能是因为wsl系统断网了 可能是因为手动同步了一下win的系统时间
            # print(recordTime)
            # print((arrow.now()-recordTime))
            # print((arrow.now()-recordTime).seconds)
            if (arrow.now()-recordTime).seconds <= SHORTEST_RECORD_CLOSE_TIME:  #小于10秒不算关
                query_db('delete from records where id=?', (recordRecent['id'],), commit=True)
                # 这里应该还需要在toDelete里面创建一个删除记录 但是懒得写了 不会有人在这10s内还能执行一次同步吧
                recordStartTime = recordRecent['startTime']
                returnDes = {"success": 2, "description": f"insert success, the latest {SHORTEST_RECORD_CLOSE_TIME}s record has been deleted"}
            else:
                recordStartTime = record['time']
                returnDes = {"success": 1, "description": "insert success"}
        else:
            recordStartTime = record['time']
            returnDes = {"success": 100, "description": "insert success, this is your first record of this app"}
        query_db('insert into halfRecord values (?, ?, ?, ?, ?, ?)',
                 (recordStartTime, record['source'], record['app'], record['state'],
                  record['belongsTodo'], record['belongsTodoSub']),
                 commit=True)
    except Exception as e:
        print(e)
        returnDes = {"success": -2, "description": "unknown error occurred"}
    return returnDes


@app.route('/halfRecord/add', methods=['post'])
# 要么有app名称，要么有todo和sub的id
def pushTempRecord():
    # record = request.json
    # # stack = tempStack()
    # stack = session['username-halfRecordStack']
    # stack.append(record)
    # # setattr(g, '_halfRecordStack', stack)
    # # return json.dumps(tempStack())
    # return json.dumps(session['username-halfRecordStack'])
    record = request.json

    # belongsTodo 和 belongsTodoSub 是可选的，不传或者传递空都可以
    if record.get('belongsTodo'):
        if record['belongsTodo'] == "":
            record['belongsTodo'] = "screenTime"
    else:
        record['belongsTodo'] = "screenTime"
    if record.get('belongsTodoSub'):
        if record['belongsTodoSub'] == "":
            record['belongsTodoSub'] = record["app"]
    else:
        record['belongsTodoSub'] = record["app"]
    # if record.get('belongsTodo') and record['belongsTodo'] == "":
    #     # todoid = "screenTime"
    #     # todoid = ""
    #     record['belongsTodo'] = "screenTime"
    # else:
    #     # todoid = record['belongsTodo']
    #     pass
    # if record.get('belongsTodoSub') and record['belongsTodoSub'] == "":
    #     # todosubid = "screenTimeSub"
    #     # todosubid = record["app"]
    #     record['belongsTodoSub'] = record["app"]
    # else:
    #     # todosubid = record['belongsTodoSub']
    #     pass

    if record['state'] == "close":
        return checkNewestTempRecord(record)
    elif record['state'] == "shutoffme":
        return closeAllTempRecord(record, onlyme=True)
    elif record['state'] == "shutoffall":
        return closeAllTempRecord(record, onlyme=False)
    elif record['state'] == 'open':
        return insertTempRecord(record=record)
    else:
        return {"success": -3, "description": "unknown state"}
    # return {"success": 1, "description": "insert final success"}


@app.route('/halfRecord/all')
def getAllHalfRecords():
    allHalfRecord = query_db('select * from halfRecord')
    if allHalfRecord is not None:
        return {"success": 1, "description": "got all halfRecord", "content": allHalfRecord}
    else:
        return {"success": -1, "description": "no halfRecord"}
    # return json.dumps(session['username-halfRecordStack'])


@app.route('/record/debugTimeZone')
def updateRecordTime():
    for r in query_db('select `id`,recordTime from records'):
        if r["recordTime"].endswith("Z"):
            newTime = r["recordTime"]
        elif r["recordTime"].endswith("08:00"):
            newTime = r["recordTime"]
        else:
            newTime = r["recordTime"] + "Z"

        # print(r["recordTime"], "->", newTime)
        query_db('update records set recordTime=? where `id`=?',
                 (newTime, r["id"]))
    get_db().commit()


@app.route("/tools/bilidownload/add", methods=["POST"])
def addBiliToDownload():
    body = request.json
    url = body.get("url").split("\n")[0]
    source = body["source"]
    # print(body)
    # print(url)
    # print(datetime.datetime.now().astimezone(datetime.timezone(datetime.timedelta(hours=8))).isoformat())
    query_db("insert into bili values (?, ?, ?)",
             (url, datetime.datetime.now().astimezone(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),
              source),
             commit=True)

    return {"success": 1, "description": "added to download queue success"}


@app.route("/tools/bilidownload/all")
def allBiliToDownload():
    toReturn = query_db('select * from bili')
    if toReturn is not None:
        return {"success": 1, "description": "got all toDownload", "contents": toReturn}
    else:
        return {"success": 2, "description": "got no toDownload"}


@app.route("/tools/bilidownload/delete", methods=["POST"])
def deleteBiliToDownload():
    body = request.json
    query_db("delete from bili where url=?", (body['url'],))
    return {"success": 1, "description": "delete may success"}


@app.route("/tools/bilidownload/videoToMp3", methods=["POST"])
def convertVideoToMp3():
    body = request.json
    source = body["source"]
    mp3Suffix = body["musicFormat"] # mp3 wav(大) aac aiff(慢)
    videoPrefix = body["video"]
    video = videoPrefix+".mp4"
    mp3 = f"{videoPrefix}.{mp3Suffix}"
    # barkid = body.get("barkid")
    downloadPath = os.path.join(DOWNLOADPATH, source)

    # if barkid: requests.request("GET", f"https://api.day.app/{barkid}/downloader/开始下载?group={group}&icon={icon}")
    if not os.path.exists(os.path.join(downloadPath, mp3)):
        (
            ffmpeg
                .input(os.path.join(downloadPath, video))
                .output(os.path.join(downloadPath, mp3))
                .run()
        )

    if os.path.exists(os.path.join(downloadPath, mp3)):
        return send_from_directory(downloadPath, mp3)
    else:
        return {"success": -1, "description": "can't find this video"}


@app.route("/tools/bilidownload/allMyVideo", methods=["POST"])
def getAllMyVideo():
    body = request.json
    source = body["source"]
    downloadPath = os.path.join(DOWNLOADPATH, source)
    if not os.path.isdir(downloadPath):
        return {"success": 2, "description": "got no video"}
    files = os.listdir(downloadPath)
    files.sort(key=lambda x: os.path.getmtime(os.path.join(downloadPath, x)), reverse=True)
    allVideo = []
    for f in files:
        if f.endswith("-avc.mp4"):
            allVideo.append(f[:-8])
    if len(allVideo):
        return {"success": 1, "description": "got video list", "contents": allVideo}
    else:
        return {"success": 2, "description": "got no video"}


@app.route("/tools/bilidownload/getMyVideo", methods=["POST"])
def getMyVideo():
    body = request.json
    source = body["source"]
    video = body["video"]+"-avc.mp4"
    downloadPath = os.path.join(DOWNLOADPATH, source)
    if os.path.exists(os.path.join(downloadPath, video)):
        return send_from_directory(downloadPath, video)
    else:
        return {"success": -1, "description": "can't find this video"}


@app.route("/tools/bilidownload/fetch", methods=["POST"])
def fetchBiliToDownload():
    body = request.json
    url = body.get("url").split("\n")[0]
    source = body["source"]
    barkid = body.get("barkid")
    icon = "https://www.bilibili.com/favicon.ico"
    # print(body)
    # print(url)
    # print(datetime.datetime.now().astimezone(datetime.timezone(datetime.timedelta(hours=8))).isoformat())
    query_db("insert into bili values (?, ?, ?)",
             (url, datetime.datetime.now().astimezone(datetime.timezone(datetime.timedelta(hours=8))).isoformat(),
              source),
             commit=True)

    downloadPath = os.path.join(DOWNLOADPATH, source)
    group = random.random()

    if barkid:
        with open(os.path.join(downloadPath,"barkid.conf"),"w") as f:
            f.write(barkid)

    if barkid: requests.request("GET", f"https://api.day.app/{barkid}/downloader/开始下载?group={group}&icon={icon}")

    before = set(os.listdir(downloadPath))
    os.system("you-get {} --no-caption -o {} -c cookie.sqlite".format(url, downloadPath))
    after = set(os.listdir(downloadPath))
    for i in after-before:
        fileName = i

    if barkid: requests.request("GET", f"https://api.day.app/{barkid}/{fileName}/下载完成，开始转码?group={group}&icon={icon}")

    files = os.listdir(downloadPath)
    files.sort(key=lambda x: os.path.getmtime(os.path.join(downloadPath, x)), reverse=False)
    for f in files:
        pre, suf = os.path.splitext(f)
        # pre: videoName
        # suf: .mp4 .flv ...
        # filePrefix = "{}/{}".format(downloadPath, pre)
        filePrefix = os.path.join(downloadPath, pre)
        if suf == ".flv":
            # os.system("ffmpeg -i \"{}.flv\" \"{}.mp4\"".format(filePrefix, filePrefix))
            if os.path.exists(os.path.join(filePrefix+"-avc.mp4")):
                # already converted to avc-mp4
                continue
            (
                ffmpeg
                .input("{}.flv".format(filePrefix))
                .output("{}.mp4".format(filePrefix))
                # .overwrite_output()
                .run()
            )
        elif pre.endswith("-avc"):
            continue
        elif suf == ".mp4":
            if os.path.exists(os.path.join(filePrefix+"-avc.mp4")):
                # already converted to avc-mp4
                continue
            (
                ffmpeg
                .input("{}.mp4".format(filePrefix))
                .output("{}-avc.mp4".format(filePrefix))
                .run()
            )
    if barkid: requests.request("GET", f"https://api.day.app/{barkid}/{fileName}/转码完成，（可以）开始传输?group={group}&icon={icon}")
    files = os.listdir(downloadPath)
    files.sort(key=lambda x: os.path.getmtime(os.path.join(downloadPath, x)), reverse=True)
    for f in files:
        if f.endswith(".mp4"):
            return send_from_directory(downloadPath, f)

    # return {"success": 1, "description": "added to download queue success"}


if __name__ == "__main__":
    app.run()
