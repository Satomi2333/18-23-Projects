import time
import os
import sqlite3
import pythoncom
from win32com.shell import shell
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

# 遍历recent文件夹后，将非重复条目写入到数据库中
def insertData():
    conn = sqlite3.connect(databasePath)
    print("Opened database successfully")
    c = conn.cursor()
    recentList = os.listdir(recentPath)
    for item in recentList:
        #item = recentList[0]
        cT,mT,aT = fileCMATime(recentPath+item)
        if ".lnk" in item:
            name = item[:-4] # 用来去除文件最后的 .ink
        else:
            name = item
        # print(item)
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
    print("Close database successfully")

#insertData()