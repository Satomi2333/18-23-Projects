import time
import datetime
import re
import os
import sqlite3
import pythoncom
from win32com.shell import shell

import sys
sys.path.append(r'x:\work_py\3.x')
import Apriori
# from win32com.shell import shellcon

databasePath = 'X:\\Work_Py\\DataMining\\Data.db'
recentPath = r'C:\Users\11063\AppData\Roaming\Microsoft\Windows\Recent\\'
recentList = os.listdir(recentPath)


# 从快捷方式中获取目标
def GetpathFromLink(lnkpath):
    if '.lnk' not in lnkpath:
        return None
    shortcut = pythoncom.CoCreateInstance(
        shell.CLSID_ShellLink, None,
        pythoncom.CLSCTX_INPROC_SERVER, shell.IID_IShellLink)
    try:
        shortcut.QueryInterface(pythoncom.IID_IPersistFile).Load(lnkpath)
    except Exception as e:
        print(lnkpath + " error: ", end='')
        print(e)
        return ''
    path = shortcut.GetPath(shell.SLGP_SHORTPATH)[0]# 此处原始元组还会获取文件的三个时间 存储在[1][0:2]
    return path

# 时间元组转为字符
def secondsToStr(seconds):
	x = time.localtime(seconds)  # 时间元组
	return time.strftime("%Y-%m-%d %X", x) # 时间元组转为字符

# 获取文件的三个时间数据
def fileCMATime(filePath):
    fileInfo = os.stat(filePath)
    cTime = secondsToStr(fileInfo.st_ctime) #这是一个以(毫)秒为单位的时间
    mTime = secondsToStr(fileInfo.st_mtime)
    aTime = secondsToStr(fileInfo.st_atime)
    return cTime, mTime, aTime

# 一个用来分割字符串中连续空格的子函数
def reSplitSpace(s):
    reList = []
    for i in re.split(r' ( )+',s): #这里的解决真漂亮
        if i not in [' ','\n','']:
            reList.append(i)
    return reList

# 通过pid来查找进程名以及目录
# 也可以用 “wmic process where processid=500 get name,executablepath,processid” 返回的结果更加结构化，只可惜看到这个的时候已经晚了
def getPid(pid):
    with os.popen('wmic process get name,executablepath,processid | findstr {}'.format(pid)) as f:
        result = f.readlines()
    if 0 == len(result):
        print(time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())+":error pid:"+pid+"：对应进程不存在（可能已经被kill了）")
        return 0,None
    reList = reSplitSpace(result[0])
    if 2 == len(reList):
        # print(time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())+":wrong pid:"+pid+"：返回结果不全")
        return 2,reList # 经过测试 一般只包含name和pid
    if 3 == len(reList):
        return 3,reList # 分别是target、name、pid
    return 0,0

# 通过pid来查找进程名以及目录及其父进程pid
def getPidAndParent(pid):
    with os.popen('wmic process get name,executablepath,processid,ParentProcessId | findstr {}'.format(pid)) as f:
        result = f.readlines()
    if 0 == len(result):
        print(time.strftime("%Y-%m-%d %H:%M:%S",time.localtime())+":error pid:"+pid+"：对应进程不存在（可能已经被kill了）")
        return 0,None
    reList = reSplitSpace(result[0])
    '''
    长度为 4 时，分别为 target，name，parentpid，pid
    长度为 3 时，分别为         name，parentpid，pid
    '''
    return (len(reList),reList)

# 遍历所有pid
def walkPids():
    with os.popen('wmic process get processid') as f:
        result = f.readlines()[2:]
    for i in result:
        if '\n' == i:
            continue
        count,list1 = getPid(i)
        if count == 2:
            # print(list1)
            continue
        elif count == 3:
            print('success :'+i,end='  ')
            print(list1)
        elif count == 0 and list1 == None:
            continue
        else:
            print('\n not 2 or 3 pid:'+i)

# 遍历所有pid（更快版本）
def runPids():
    with os.popen('wmic process get name,executablepath,processid,ParentProcessId') as f:
        result = f.readlines()[2:-2:2] # start用于去掉标题，end用于去掉最后一个换行，step用于去掉换行符
    resultList = []
    for item in result:
        result = reSplitSpace(item)
        resultList.append((len(result),result))
        print(len(result),end=',')
        print(result)
    return resultList


# 遍历recent文件夹后，将非重复条目写入到数据库中
def insertData():
    conn = sqlite3.connect(databasePath)
    print("Opened database successfully")
    c = conn.cursor()
    recentList = os.listdir(recentPath)
    for item in recentList:
        #item = recentList[0]
        cT,mT,aT = fileCMATime(recentPath+item)
        pid = -1
        if ".lnk" in item:
            name = item[:-4] # 用来去除文件最后的 .ink
        else:
            name = item
        if 'ms-gamingoverlay--startuptips' in name:
            try:
                pid = re.search(r'(ProcessId=\d+)|(pid=\d+)',name).group().split('=')[1]
            except Exception as e:
                pid = -1
                print(e)
            tag,pidResult = getPidAndParent(pid)
            if tag == 0:
                target = "已失效的pid"
            elif tag == 3:
                target = 'unable locate it'
                name = pidResult[0]
            elif tag == 4:
                target = pidResult[0]
                name = pidResult[1]
        # print(item)
        else:
            target = GetpathFromLink(recentPath+item)
            if target is None:
                continue
            if target == '':
                target = "正在研究这是个什么玩意儿"
        sqlExeSearch = "select * from recent where name='{}' and modificationTime='{}'".format(name,mT)
        c.execute(sqlExeSearch)
        resultAll = c.fetchall()
        if 0 != len(resultAll):
            # print("already exist "+ name)
            continue
        
        sqlExeInsert = "insert into recent values('{}','{}','{}','{}','{}');".format(name,target,cT,mT,aT)
        #print(sqlExe)
        try:
            c.execute(sqlExeInsert)
        except sqlite3.OperationalError as e:
            print(e)
            return
    conn.commit()
    conn.close()
    print("Close database successfully\n")


TODAY = 0
YESTERDAY = -1
BEFORE_YESTERDAY = -2
WEEK_AGO = -7

# 按照需求来获取指定日期的格式化字符串
def getDateStrings(*days):
    dateStrings = []
    # endOfToday = datetime.date.today() + datetime.timedelta(days = 1)
    for day in days:
        begin = (datetime.date.today() + datetime.timedelta(days = day)).strftime("%Y-%m-%d %H:%M:%S")
        end = (datetime.date.today() + datetime.timedelta(days = day+1)).strftime("%Y-%m-%d %H:%M:%S")
        dateStrings.append((begin,end))
    return dateStrings
    
# 数据清洗 -- 垃圾列表，使用正则表达式定义的垃圾
rubbish = [(re.compile('Internet'),re.compile('正在研究这是个什么玩意儿')),
           (re.compile(r'.+'),re.compile('已失效的pid'))
           ]

# 数据清洗 -- 判断传入数据是否是‘垃圾’
def isRubbish(data): # 传入的为元组
    for trash in rubbish:
        if trash[0].match(data[0]) and trash[1].match(data[1]):
            return True
    return False

# 数据清洗 -- 将原数据传入后依次调用其他函数来删去垃圾并返回清洗完毕的数据
# 顺便支持去重
# 再顺便将其二次编码，优化Apriori
def dataClean(dataOrigin):
    dataCleaned = []
    dataCleanedDict = {} # 历史遗留变量
    dictCount = 0 # 同上
    for a in dataOrigin: # a 为单日的数据，类型为list
        dayNew = set() # 此处改为set可以顺便去重，缺点就是严重降低执行速率
        for day in a: # day 为单条数据，类型为tuple
            if not isRubbish(day):
                dayNew.add(day)
            else:
                continue
        dataCleaned.append(dayNew)
    #print(dataCleaned)
    return dataCleaned

# 数据请清洗顺便编码 在上一个函数里面修改太麻烦了 干脆直接重写一个
def dataCleanCode(dataOrigin):
    dataCleaned = []
    # dataCleanedKey = []
    dataCleanedValue = []
    count = 0
    for a in dataOrigin: # a 为单日的数据，类型为list
        dayNew = set() # 此处改为set可以顺便去重，缺点就是严重降低执行速率
        for day in a: # day 为单条数据，类型为tuple
            if not isRubbish(day):
                if day not in dataCleanedValue:
                    dataCleanedValue.append(day)
                    dayNew.add(count)
                    count += 1
                else:
                    dayNew.add(dataCleanedValue.index(day))
            else:
                continue
        dataCleaned.append(list(dayNew))
    #print(dataCleaned)
    return dataCleaned,dataCleanedValue

# 传入所需日期，将数据处理成Apriori可用的样子
def dataProcess(*days):
    dateStrings = getDateStrings(*days)
    conn = sqlite3.connect(databasePath)
    c = conn.cursor()
    dataOrigin = []
    for day in dateStrings:
        sqlExeSearch = "select name,target from recent where modificationTime>'{}' and modificationTime<'{}'".format(day[0],day[1])
        c.execute(sqlExeSearch)
        dataOrigin.append(c.fetchall())
    dataCleaned,values = dataCleanCode(dataOrigin)
    # return dataCleaned,values
    conn.commit()
    conn.close()
    L,suppData = Apriori.apriori(dataCleaned,minSupport = 3/(len(days)+3))
    rules = Apriori.generateRules(L,suppData,minConf = 0.7)
    print(rules)
    return values
    # return rules

# t,v = dataProcess(0,-1,-2,-3,-4,-5,-6,-7)
# values = dataProcess(0,-1,-2,-3,-4,-5,-6,-7)
while 1:
    insertData()
    time.sleep(60)
# walkPids()

# a = time.time()
# runPids()
# print(time.time()-a)

def test(*args):
    print(args)
    for i in args:
        print(i)
