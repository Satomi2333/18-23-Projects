# -*- coding: utf-8 -*-

"""
Module implementing MainWindow.
"""
import os
import json
import time
import sqlite3
from PyQt5.Qt import *
from PyQt5.QtCore import pyqtSlot
from PyQt5.QtWidgets import *
from PyQt5.QtSql import QSqlDatabase, QSqlTableModel, QSqlQuery
from PyQt5.QtGui import *

from Ui_UI_Main import *
from Ui_showPhoto import *

myDictExif = {}
myDictOcr = {}
DNDict = {}

class MainWindow(QMainWindow):
    """
    Class documentation goes here.
    """
    databasePath = '.\\photoIndex.db'
    photoPath1 = r'.\\'
    shortPath1 = '1\\'
    photoPath2 = r'.\\'
    shortPath2 = '2\\'
    rootPath = '.'
    path1List = []
    path2List = []
    cursor = None
    conn = None
    comboxList1 = ['','完全匹配', '表达式']
    comboxList2 = ['','phpto', 'video', 'GIFph']
    comboxList3 = ['', 'tiny small', 'small', 'tiny middle', 'middle', 'large', 'super large']
    comboxList4 = ['', 'panoramas', 'super panoramas', 'square']
    comboxList5 = ['', 'creationTime', 'modificationTime', 'accessTime']
    comboxList6 = ['之前','之后']
    comboxList7 = ['','laptop', 'book', 'refrigerator', 'tvmonitor', 'person', 'wine_glass', 'bed', 'teddy_bear', 'chair', 'cat', 'backpack', 'pottedplant', 'broccoli', 'sports_ball', 'bench', 'keyboard', 'bird', 'car', 'bus', 'truck', 'aeroplane', 'scissors', 'dog', 'vase', 'tie', 'clock', 'remote', 'umbrella', 'handbag', 'toothbrush', 'spoon', 'cell_phone', 'diningtable', 'pizza', 'boat', 'bottle', 'cup', 'bowl', 'mouse', 'hair_drier', 'microwave', 'surfboard', 'cake', 'stop_sign', 'horse', 'kite', 'sheep', 'frisbee', 'suitcase', 'sofa', 'donut', 'tennis_racket', 'baseball_bat', 'oven', 'motorbike', 'knife', 'giraffe', 'cow', 'toilet', 'bicycle', 'carrot', 'banana', 'fork', 'bear', 'train', 'baseball glove', 'apple', 'traffic_light', 'sandwich', 'orange', 'skateboard', 'parking_meter', 'skis', 'fire_hydrant', 'zebra']
    comboxList7Temp = ['name','path','laptop', 'book', 'refrigerator', 'tvmonitor', 'person', 'wine_glass', 'bed', 'teddy_bear', 'chair', 'cat', 'backpack', 'pottedplant', 'broccoli', 'sports_ball', 'bench', 'keyboard', 'bird', 'car', 'bus', 'truck', 'aeroplane', 'scissors', 'dog', 'vase', 'tie', 'clock', 'remote', 'umbrella', 'handbag', 'toothbrush', 'spoon', 'cell_phone', 'diningtable', 'pizza', 'boat', 'bottle', 'cup', 'bowl', 'mouse', 'hair_drier', 'microwave', 'surfboard', 'cake', 'stop_sign', 'horse', 'kite', 'sheep', 'frisbee', 'suitcase', 'sofa', 'donut', 'tennis_racket', 'baseball_bat', 'oven', 'motorbike', 'knife', 'giraffe', 'cow', 'toilet', 'bicycle', 'carrot', 'banana', 'fork', 'bear', 'train', 'baseball glove', 'apple', 'traffic_light', 'sandwich', 'orange', 'skateboard', 'parking_meter', 'skis', 'fire_hydrant', 'zebra']
    comboxList8 = ['name', 'type', 'suffix', 'path', 'height', 'weight','creationTime', 'modificationTime', 'accessTime', 'GPSInfoPlace', 'cameraMaker', 'cameraModel']
    comboxList8Temp = ['name', 'type', 'suffix', 'path', 'ocr', 'height', 'weight','size_type','widthHeight_type','creationTime', 'modificationTime', 'accessTime', 'GPSInfoPlace', 'cameraMaker', 'cameraModel']
    comboxList9 = ['升序', '降序']
    comboxList10 = ['','大于', '小于']
    exeString = ''
    exeStringWhereTemp = ''
    exeStringOrderByTemp = ''
    resultAll = []
    resultAllcount = 0
    resultAllLeft = 0
    resultAllRight = 0
    pageConAble = False
    pageNow = 0
    pageAll = 0
    resultNow = [] #是一个列表字典嵌套，len一般小于等于5，同来保存当前显示的0~5张图的所有信息，resultNow[0]['path']这么用
    resultNowString = [] #是将resultNow中字典的内容转换成字符串后保存的地方
    m_flag=False #用于拖动窗口，此处不初始化的话，需要进入窗口之后先点击一下空白处，而不能直接点下拉框
    redoAndUndo = []
    redoAndUndoCurrentIndex = -1
    
    def __init__(self, parent=None):
        """
        Constructor
        
        @param parent reference to the parent widget
        @type QWidget
        """
        super(MainWindow, self).__init__(parent)
        self.ui=Ui_MainWindow()        #创建UI对象
        self.ui.setupUi(self)      #构造UI界面
        #self.setWindowOpacity(0.9) # 设置窗口透明度
        self.setProperty('canMove', True)
        self.setAttribute(QtCore.Qt.WA_TranslucentBackground) # 设置窗口背景透明
        self.setWindowFlag(QtCore.Qt.FramelessWindowHint) # 隐藏边框
        self.ui.label_15.setText('by Water - v0.6')
        self.ui.pushButton_icon.setIcon(QIcon('./icons/shui.png'))
        self.ui.pushButton_zxh.setIcon(QIcon('./icons/zuixiaohua.png'))
        self.ui.pushButton_zdh.setIcon(QIcon('./icons/zuidahua.png'))
        self.ui.pushButton_close.setIcon(QIcon('./icons/guanbi.png'))
        self.ui.pushButton_cx.setIcon(QIcon('./icons/chexiao.png'))
        self.ui.pushButton_cx.clicked.connect(self.chexiao)
        self.ui.pushButton_cx.setEnabled(False)
        self.ui.pushButton_cz.setIcon(QIcon('./icons/chongzuo.png'))
        self.ui.pushButton_cz.clicked.connect(self.chongzuo)
        self.ui.pushButton_cz.setEnabled(False)
#        self.ui.pushButton_show0.setIcon(QIcon('./icons/empty.png'))
#        self.ui.pushButton_show1.setIcon(QIcon('./icons/empty.png'))
#        self.ui.pushButton_show2.setIcon(QIcon('./icons/empty.png'))
#        self.ui.pushButton_show3.setIcon(QIcon('./icons/empty.png'))
#        self.ui.pushButton_show4.setIcon(QIcon('./icons/empty.png'))
        for i in range(0):#此处会导致所有传出参数都为最后一个temp 所以弃用了
            temp = eval("self.ui.pushButton_show{}".format(i))
            temp.setContextMenuPolicy(Qt.CustomContextMenu)
            temp.customContextMenuRequested.connect(lambda:self.showMenu(i))
        self.ui.pushButton_show0.setContextMenuPolicy(Qt.CustomContextMenu)
        self.ui.pushButton_show0.customContextMenuRequested.connect(lambda:self.showMenu(0))
        self.ui.pushButton_show1.setContextMenuPolicy(Qt.CustomContextMenu)
        self.ui.pushButton_show1.customContextMenuRequested.connect(lambda:self.showMenu(1))
        self.ui.pushButton_show2.setContextMenuPolicy(Qt.CustomContextMenu)
        self.ui.pushButton_show2.customContextMenuRequested.connect(lambda:self.showMenu(2))
        self.ui.pushButton_show3.setContextMenuPolicy(Qt.CustomContextMenu)
        self.ui.pushButton_show3.customContextMenuRequested.connect(lambda:self.showMenu(3))
        self.ui.pushButton_show4.setContextMenuPolicy(Qt.CustomContextMenu)
        self.ui.pushButton_show4.customContextMenuRequested.connect(lambda:self.showMenu(4))
        self.clearShowButton()
        self.ui.pushButton_show4.setToolTip('ToolTip test')
        self.ui.pushButton_close.installEventFilter(self)
        #self.ui.pushButton_close.clicked.connect(self.close)
        self.ui.pushButton_zxh.clicked.connect(self.showMinimized)
        #self.ui.pushButton_zdh.clicked.connect(self.showMaximized)
        self.ui.pushButton_process.released.connect(self.doIt)
        
        self.ui.textEdit.setUndoRedoEnabled(True)
        #self.ui.textEdit.redoAvailable.connect(self.textEditorChanged)
        #self.ui.textEdit.undoAvailable.connect(self.textEditorChanged)
        #self.ui.textEditor.textChanged.connect(self.textEditorChanged)
        self.ui.comboBox.addItems(self.comboxList1)
        self.ui.comboBox.currentIndexChanged.connect(lambda:self.likeComplet(1))
        self.ui.comboBox_2.addItems(self.comboxList2)
        self.ui.comboBox_3.addItems(self.comboxList1)
        self.ui.comboBox_3.currentIndexChanged.connect(lambda:self.likeComplet(3))
        self.ui.comboBox_4.addItems(self.comboxList1)
        self.ui.comboBox_4.currentIndexChanged.connect(lambda:self.likeComplet(4))
        self.ui.comboBox_5.addItems(self.comboxList10)
        self.ui.comboBox_5.currentIndexChanged.connect(lambda:self.heightWeightCom(5))
        self.ui.comboBox_6.addItems(self.comboxList10)
        self.ui.comboBox_6.currentIndexChanged.connect(lambda:self.heightWeightCom(6))
        self.ui.comboBox_7.addItems(self.comboxList3)
        self.ui.comboBox_8.addItems(self.comboxList4)
        self.ui.comboBox_9.addItems(self.comboxList5)
        self.ui.comboBox_10.addItems(self.comboxList6)
        self.ui.comboBox_11.addItems(self.comboxList1)
        self.ui.comboBox_11.currentIndexChanged.connect(lambda:self.likeComplet(11))
        self.ui.comboBox_12.addItems(self.comboxList1)
        self.ui.comboBox_12.currentIndexChanged.connect(lambda:self.likeComplet(12))
        self.ui.comboBox_13.addItems(self.comboxList1)
        self.ui.comboBox_13.currentIndexChanged.connect(lambda:self.likeComplet(13))
        self.ui.comboBox_14.addItems(self.comboxList7)
        self.ui.comboBox_14.currentIndexChanged.connect(lambda:self.heightWeightCom(9))
        self.ui.comboBox_15.addItems(self.comboxList8)
        self.ui.comboBox_15.currentTextChanged.connect(self.sortByChanged)
        self.comboBox_15Now = 8
        self.ui.comboBox_16.addItems(self.comboxList9)
        self.ui.comboBox_16.currentTextChanged.connect(self.sortByChanged)
        self.ui.dateEdit.setDate(QDate.currentDate())
        self.ui.dateEdit.setCalendarPopup(True)
        self.setStyleSheet()
        self.ui.pushButton_icon.installEventFilter(self)
        self.ui.dateEdit.dateChanged.connect(self.onDateChanged)
        self.ui.pushButton_search.released.connect(self.generateExeString)
        self.ui.pushButton_clear.released.connect(self.clearAll)
        self.clipboard = QApplication.clipboard()
        self.contextMenu = QMenu(self)
        self.ui.pushButton_show0.released.connect(lambda:self.oneClickToView(0))
        self.ui.pushButton_show1.released.connect(lambda:self.oneClickToView(1))
        self.ui.pushButton_show2.released.connect(lambda:self.oneClickToView(2))
        self.ui.pushButton_show3.released.connect(lambda:self.oneClickToView(3))
        self.ui.pushButton_show4.released.connect(lambda:self.oneClickToView(4))
        
        self.initMenu()

        #qApp.processEvents()
        #self.initDatabase()
        self.initDatabase2()
#        self.ani = QPropertyAnimation(self.ui.pushButton_icon)
#        self.ani.setStartValue(QSize(48, 30))
#        self.ani.setEndValue(QSize(1, 1))
#        self.ani.setDuration(3000)
#        self.ani.start()
    
    def chexiao(self):
        if len(self.redoAndUndo) and self.redoAndUndoCurrentIndex>0:
            self.redoAndUndoCurrentIndex -= 1
            self.ui.textEdit.setText(self.redoAndUndo[self.redoAndUndoCurrentIndex])
            self.ui.pushButton_cz.setEnabled(True)
        if self.redoAndUndoCurrentIndex<=0:
            self.ui.pushButton_cx.setEnabled(False)
        
    
    def chongzuo(self):
        if self.redoAndUndoCurrentIndex < len(self.redoAndUndo)-1:
            self.redoAndUndoCurrentIndex += 1
            self.ui.textEdit.setText(self.redoAndUndo[self.redoAndUndoCurrentIndex])
            self.ui.pushButton_cx.setEnabled(True)
        if self.redoAndUndoCurrentIndex == len(self.redoAndUndo)-1:
            self.ui.pushButton_cz.setEnabled(False)
    
    def updateRedoAndUndo(self, nowString):
        if self.redoAndUndoCurrentIndex == len(self.redoAndUndo)-1:
            self.redoAndUndo.append(nowString)
            self.redoAndUndoCurrentIndex += 1
        elif self.redoAndUndoCurrentIndex < len(self.redoAndUndo)-1:
            self.redoAndUndo = self.redoAndUndo[:self.redoAndUndoCurrentIndex+1]
            self.redoAndUndo.append(nowString)
            self.redoAndUndoCurrentIndex = len(self.redoAndUndo)-1
        if len(self.redoAndUndo) and self.redoAndUndoCurrentIndex>0:
            self.ui.pushButton_cx.setEnabled(True)
        if self.redoAndUndoCurrentIndex < len(self.redoAndUndo)-1:
            self.ui.pushButton_cz.setEnabled(True)
        pass
    
    def copyThisPhoto(self):
        if self.copyWhich>=0:
            try:
                tempPhoto = QPixmap(self.rootPath+self.resultNow[self.copyWhich]['path'])
                self.clipboard.setPixmap(tempPhoto)
                print('复制成功')
            except IndexError:
                print("复制失败：这里没有图片")
    
    def showThisPhotoInExplorer(self):
        if self.copyWhich>=0:
            try:
                tempPath = self.rootPath+self.resultNow[self.copyWhich]['path']
                os.system("explorer.exe /select,%s" % tempPath)  
            except IndexError:
                print("定位失败：这里没有图片")
    
    def openThisPhoto(self):
        if self.copyWhich>=0:
            try:
                tempPath = self.rootPath+self.resultNow[self.copyWhich]['path']
                os.startfile(tempPath)  
            except IndexError:
                print("打开失败：这里没有图片")
    
    def viewThisPhoto(self):
        if self.copyWhich>=0:
            try:
                tempPath = self.rootPath+self.resultNow[self.copyWhich]['path']
                showInSubWindow(tempPath)
            except IndexError:
                print("查看失败：这里没有图片")
            except Exception as e:
                print(e)
        
    def showMenu(self, index):
        #print(QCursor.pos())
        self.copyWhich = index
        self.contextMenu.exec_(QCursor.pos())
    
    def initMenu(self):
        self.copyThisPhotoMenu = self.contextMenu.addAction("复制 (至剪贴板)")
        self.copyThisPhotoMenu.triggered.connect(self.copyThisPhoto)
        self.copyWhich = -1
        self.showThisPhotoInExplorerMenu = self.contextMenu.addAction("定位 (到所在文件夹)")
        self.showThisPhotoInExplorerMenu.triggered.connect(self.showThisPhotoInExplorer)
        self.openThisPhotoMenu = self.contextMenu.addAction("打开 (使用系统默认方式)")
        self.openThisPhotoMenu.triggered.connect(self.openThisPhoto)
        self.viewThisPhotoMenu = self.contextMenu.addAction("查看 (在新建的窗口)")
        self.viewThisPhotoMenu.triggered.connect(self.viewThisPhoto)
    
    def oneClickToView(self,index): #v0.6.2 feature 1
        self.copyWhich = index
        self.openThisPhoto()
    
    def testFun(self):
        a = QPixmap('d:\\test.jpg')
        self.clipboard.setPixmap(a)
    
    def resultButtonWhichOn(self):
        pass
    
    def showResult(self):
        self.clearShowButton()
        #self.resultNow
        resultNowLen = len(self.resultNow)
        #print(resultNowLen)
        #print(self.resultNowString)
        print('loading...')
        if resultNowLen > 5:
            raise Exception('showResult函数传入参数数组长度不能超过5')
        else:
            for i in range(resultNowLen):
                realPath = self.rootPath + self.resultNow[i]['path']
#                sheetString = '''
#QPushButton{background-image: url(:{});}
#QPushButton:hover{background-image: url(:{}) -10 -10 -10 -10;}'''.format(realPath, realPath)
#                eval("tempButton = self.ui.pushButton_show{}".format(i))
#                tempButton.setStyleSheet(sheetString)
                tempButton = eval("self.ui.pushButton_show{}".format(i))
                tempButton.setIcon(QIcon(realPath))
                tempButton.setToolTip(self.resultNowString[i])
            for i in range(resultNowLen,5): #v0.6.2 bug2
                tempButton = eval("self.ui.pushButton_show{}".format(i))
                tempButton.setToolTip("")
        print('finish')
        if not self.pageConAble:
            self.pageConAble = True
            self.ui.pushButton_firstPage.clicked.connect(lambda:self.whichPage('first'))
            self.ui.pushButton_upPage.clicked.connect(lambda:self.whichPage('up'))
            self.ui.pushButton_downPage.clicked.connect(lambda:self.whichPage('down'))
            self.ui.pushButton_lastPage.clicked.connect(lambda:self.whichPage('last'))
    
    def clearShowButton(self):
        self.ui.pushButton_show0.setIcon(QIcon('./icons/shui.png'))
        self.ui.pushButton_show1.setIcon(QIcon('./icons/shui.png'))
        self.ui.pushButton_show2.setIcon(QIcon('./icons/shui.png'))
        self.ui.pushButton_show3.setIcon(QIcon('./icons/shui.png'))
        self.ui.pushButton_show4.setIcon(QIcon('./icons/shui.png'))
        pass
    
    def clearShowResult(self):
        self.resultNow = []
        self.resultNowString = []
        pass
    
    def doIt(self):
        self.exeString = self.ui.textEdit.toPlainText()
        try:
            self.cursor.execute(self.exeString)
        except Exception as e:
            QMessageBox.critical(self, "Something Wrong", e.args[0], QMessageBox.Yes)
        else:
            self.resultAll = self.cursor.fetchall()
            #print(type(self.resultAll))
            self.resultAllcount = len(self.resultAll)
            QMessageBox.information(self, '语句执行成功','共查询到'+str(self.resultAllcount)+'条结果',QMessageBox.Yes)
            self.updateRedoAndUndo(self.exeString)
            if self.resultAllcount >= 5:
                self.resultAllLeft = 0
                self.resultAllRight = 4
            elif self.resultAllcount == 0:
                self.resultAllLeft = 0
                self.resultAllRight = 0
                return
            else:
                self.resultAllLeft = 0
                self.resultAllRight = self.resultAllcount-1
            #print(str(self.resultAllLeft)+' '+str(self.resultAllRight)+' '+str(self.resultAllcount))
            #self.getResultNow() #因为whichPage会调用getResultNow()，所以这里替换掉是因为这样做可以让每次执行查询之后回到第一页，而不是保留上一次的页码数而使得可能越界v0.6.1
            self.whichPage('first')
    
    def getResultNow(self):
        self.clearShowResult()
        for j in range(self.resultAllLeft, self.resultAllRight+1):
            #print(self.resultAll)
            if self.comboBox_15Now == 7:#photoObject :path in cloumn index 1
                tempDict = {}#突然发现 如果手速够快可以当程序在这个循环的时候突然改变Now值，后面应该就会出bug
                tempString = ''
                for i in range(len(self.comboxList7Temp)):
                    keyTemp = self.comboxList7Temp[i]
                    valueTemp = self.resultAll[j][i]
                    tempDict[keyTemp] = valueTemp
                    if valueTemp is not None:
                        if not isinstance(valueTemp, str):
                            tempString += (keyTemp + ' : ' + str(valueTemp)+'\n')
                        else:
                            tempString += (keyTemp + ' : ' + valueTemp+'\n')
                self.resultNow.append(tempDict)
                self.resultNowString.append(tempString)
            elif self.comboBox_15Now == 8:#photo :path in colum index 3
                tempDict = {}
                tempString = ''
                for i in range(len(self.comboxList8Temp)):
                    keyTemp = self.comboxList8Temp[i]
                    valueTemp = self.resultAll[j][i]
                    tempDict[keyTemp] = valueTemp
                    if keyTemp == 'ocr' and (valueTemp is not None):
                        keyTemp.replace('\n','')
                        keyTemp.replace('\t','')
                        keyTemp.replace(' ','')
                        tempString += (keyTemp + ' : ' + valueTemp[:10]+'...\n')
                    elif valueTemp is not None:
                        if not isinstance(valueTemp, str):
                            tempString += (keyTemp + ' : ' + str(valueTemp)+'\n')
                        else:
                            tempString += (keyTemp + ' : ' + valueTemp+'\n')
                self.resultNow.append(tempDict)
                self.resultNowString.append(tempString)
        #print(self.resultNow)
        self.showResult()
    
    def whichPage(self, whichButton):
        a = self.resultAllcount//5
        b = self.resultAllcount%5
        if b == 0:
            self.pageAll = a
        else:
            self.pageAll = a+1
        if self.pageAll == 1 and self.resultAllRight-self.resultAllLeft+1 == self.resultAllcount: #比较万能，无论是下面的哪种写法都可以用这句
            self.pageNow = 0 #v0.6.2 bug3
            pass
        elif whichButton=='first':
            self.pageNow = 0
        elif whichButton=='last':
            self.pageNow = self.pageAll - 1
        elif whichButton=='up':
            if self.pageNow > 0:
                self.pageNow -= 1
        elif whichButton=='down':
            if self.pageNow < self.pageAll - 1:
                self.pageNow += 1
        self.resultAllLeft = self.pageNow*5
        if self.pageNow == self.pageAll - 1:
            self.resultAllRight = self.resultAllLeft+(self.resultAllcount-1)%5
        else:
            self.resultAllRight = self.resultAllLeft+4
        print(str(self.resultAllLeft)+' '+str(self.resultAllRight)+' '+str(self.resultAllcount))
        print(self.pageNow)
#下面这种写法好累人啊，未完成，放弃了，因为找到了更好写的
#        elif whichButton=='first':
#            self.resultAllLeft = 0
#            if self.resultAllcount >= 5:
#                self.resultAllRight = 4
#            elif self.resultAllcount == 0:
#                self.resultAllRight = 0
#            else:
#                self.resultAllRight = self.resultAllcount-1
#        elif whichButton=='last':
#            if b== 0:
#                self.resultAllLeft = (a-1)*5
#            else:
#                self.resultAllLeft = a*5
#            self.resultAllRight = (self.resultAllcount-1)%5
#        elif whichButton=='up':
#            if self.resultAllLeft == 0:
#                pass
#        elif whichButton=='down':
#            if self.resultAllRight - self.resultAllLeft <=4:
#                pass
#-----------------------------------------------------------到这里
        self.getResultNow()
    
    def generateExeString(self):
        #print(self.comboBox_15Now)
        if self.executeString():
            if self.chooseObject and not self.chooseObjectWrong:
                self.where = 'photoObject'
                if self.comboBox_15Now == 8:
                    self.comboBox_15Now = 7
                    self.ui.comboBox_15.clear()
                    self.ui.comboBox_15.addItem('name')
                    self.ui.comboBox_15.addItems(self.comboxList7[1:])
            else:
                self.where = 'photo'
                if self.comboBox_15Now == 7:
                    self.comboBox_15Now = 8
                    self.ui.comboBox_15.clear()
                    self.ui.comboBox_15.addItems(self.comboxList8)
            self.sortBy()
            self.exeString = '''select *
from {}
where {}
order by {}'''.format(self.where,self.exeStringWhereTemp, self.exeStringOrderByTemp)
            self.ui.textEdit.setText(self.exeString)
            self.doIt()
        else:
            print('未生成表达式')
    
    def sortByChanged(self):
        self.sortBy()
        self.exeString = '''select *
from {}
where {}
order by {}'''.format(self.where,self.exeStringWhereTemp, self.exeStringOrderByTemp)
        self.ui.textEdit.setText(self.exeString)
    
    def clearAll(self):
        a = QMessageBox.warning(self, "are you sure？", "确定要清空？", QMessageBox.Yes | QMessageBox.No)
        if a == QMessageBox.Yes:
            index = 0
            text = ''
            self.ui.lineEdit.setText(text)
            for i in range(2, 10):
                eval("self.ui.lineEdit_{}.setText('{}')".format(i, text))
            self.ui.comboBox.setCurrentIndex(index)
            for i in range(2, 10):
                eval("self.ui.comboBox_{}.setCurrentIndex({})".format(i, index))
            for i in range(11, 15):
                eval("self.ui.comboBox_{}.setCurrentIndex({})".format(i, index))
    
    def heightWeightCom(self, a):
        if 5 == a and '' == self.ui.lineEdit_4.text():
            self.ui.lineEdit_4.setText('0')
        if 6 == a and '' == self.ui.lineEdit_5.text():
            self.ui.lineEdit_5.setText('0')
        if 9 == a and '' == self.ui.lineEdit_9.text():
            self.ui.lineEdit_9.setText('0.6')
        if 9 == a and 0 == self.ui.comboBox_14.currentIndex():
            self.ui.lineEdit_9.setText('')
    
    def likeComplet(self, a):
        if 1 == a and '' == self.ui.lineEdit.text() and self.ui.comboBox.currentText() == '表达式':
            self.ui.lineEdit.setText('%%')
        if 3 == a and '' == self.ui.lineEdit_2.text() and self.ui.comboBox_3.currentText() == '表达式':
            self.ui.lineEdit_2.setText('%%')
        # v0.6.2 bug1 以上
        if 4 == a and '' == self.ui.lineEdit_3.text() and self.ui.comboBox_4.currentText() == '表达式':
            self.ui.lineEdit_3.setText('%%')
        if 11 == a and '' == self.ui.lineEdit_6.text() and self.ui.comboBox_11.currentText() == '表达式':
            self.ui.lineEdit_6.setText('%%')
        if 12 == a and '' == self.ui.lineEdit_7.text() and self.ui.comboBox_12.currentText() == '表达式':
            self.ui.lineEdit_7.setText('%%')
        if 13 == a and '' == self.ui.lineEdit_8.text() and self.ui.comboBox_13.currentText() == '表达式':
            self.ui.lineEdit_8.setText('%%')
        
    
    def sortBy(self):
        self.exeStringOrderByTemp = ''
        sortByColumn = self.ui.comboBox_15.currentText()
        isDesc = self.ui.comboBox_16.currentText()
        if isDesc == '升序':
            self.exeStringOrderByTemp = '{}'.format(sortByColumn)
        elif isDesc == '降序':
            self.exeStringOrderByTemp = '{} desc'.format(sortByColumn)
    
    def executeString(self):
        self.exeStringDictWay = {}
        self.exeStringDict = {}
        self.exeStringDict['name'] = self.ui.lineEdit.text()
        self.exeStringDictWay['nameWay'] = self.ui.comboBox.currentText()
        self.exeStringDictWay['type'] = self.ui.comboBox_2.currentText()
        self.exeStringDict['suffix'] = self.ui.lineEdit_2.text()
        self.exeStringDictWay['suffixWay'] = self.ui.comboBox_3.currentText()
        self.exeStringDict['ocr'] = self.ui.lineEdit_3.text()
        self.exeStringDictWay['ocrWay'] = self.ui.comboBox_4.currentText()
        self.exeStringDict['height'] = self.ui.lineEdit_4.text()
        self.exeStringDictWay['heightWay'] = self.ui.comboBox_5.currentText()
        self.exeStringDict['weight'] = self.ui.lineEdit_5.text()
        self.exeStringDictWay['weightWay'] = self.ui.comboBox_6.currentText()
        self.exeStringDictWay['size_type'] = self.ui.comboBox_7.currentText()
        self.exeStringDictWay['widthHeight_type'] = self.ui.comboBox_8.currentText()
        self.exeStringDictWay['timeStampWay'] = self.ui.comboBox_9.currentText()
        self.exeStringDict['timeStamp'] = self.ui.dateEdit.date().toString(Qt.ISODate)
        self.exeStringDict['timeStampBeAf'] = self.ui.comboBox_10.currentText()
        self.exeStringDict['GPSInfoPlace'] = self.ui.lineEdit_6.text()
        self.exeStringDictWay['GPSInfoPlaceWay'] = self.ui.comboBox_11.currentText()
        self.exeStringDict['cameraMaker'] = self.ui.lineEdit_7.text()
        self.exeStringDictWay['cameraMakerWay'] = self.ui.comboBox_12.currentText()
        self.exeStringDict['cameraModel'] = self.ui.lineEdit_8.text()
        self.exeStringDictWay['cameraModelWay'] = self.ui.comboBox_13.currentText()
        self.exeStringDict['object'] = self.ui.lineEdit_9.text()
        self.exeStringDictWay['objectWay'] = self.ui.comboBox_14.currentText()
        #print(self.exeStringDict.keys())
        self.count = 0
        #self.firstCome = False
        self.exeStringWhereTemp = ''
        self.chooseObject = False
        for key in self.exeStringDictWay.keys():
            value = self.exeStringDictWay.get(key)
            #print(key, end=' ')
            #print(type(self.exeStringDict.get(key.split('Way')[0])))
            if value != '':
                self.count += 1
                #print(value)
                if 1 == self.count:
                    if '完全匹配' == value:
                        self.exeStringWhereTemp += ("("+key.split('Way')[0]+" = \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                    elif '表达式' == value:
                        self.exeStringWhereTemp += ("("+key.split('Way')[0]+" like \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                    elif '大于' == value:
                        self.exeStringWhereTemp += ("("+key.split('Way')[0]+" > "+self.exeStringDict.get(key.split('Way')[0])+")")
                    elif '小于' == value:
                        self.exeStringWhereTemp += ("("+key.split('Way')[0]+" < "+self.exeStringDict.get(key.split('Way')[0])+")")
                    elif 'timeStampWay' == key:
                        if '之前' == self.exeStringDict.get('timeStampBeAf'):
                            self.exeStringWhereTemp += ("("+self.exeStringDictWay['timeStampWay']+" < \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                        if '之后' == self.exeStringDict.get('timeStampBeAf'):
                            self.exeStringWhereTemp += ("("+self.exeStringDictWay['timeStampWay']+" > \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                    elif 'type' == key or 'widthHeight_type' == key or 'size_type' == key:
                        self.exeStringWhereTemp += ("("+key+" = \'"+value+"\')")

                elif self.count > 1:
                    if '完全匹配' == value:
                        self.exeStringWhereTemp += (' and ('+key.split('Way')[0]+" = \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                    elif '表达式' == value:
                        self.exeStringWhereTemp += (' and ('+key.split('Way')[0]+" like \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                    elif '大于' == value:
                        self.exeStringWhereTemp += (" and ("+key.split('Way')[0]+" > "+self.exeStringDict.get(key.split('Way')[0])+")")
                    elif '小于' == value:
                        self.exeStringWhereTemp += (" and ("+key.split('Way')[0]+" < "+self.exeStringDict.get(key.split('Way')[0])+")")
                    elif 'timeStampWay' == key:
                        if '之前' == self.exeStringDict.get('timeStampBeAf'):
                            self.exeStringWhereTemp += (" and ("+self.exeStringDictWay['timeStampWay']+" < \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                        if '之后' == self.exeStringDict.get('timeStampBeAf'):
                            self.exeStringWhereTemp += (" and ("+self.exeStringDictWay['timeStampWay']+" > \'"+self.exeStringDict.get(key.split('Way')[0])+"\')")
                    elif 'type' == key or 'widthHeight_type' == key or 'size_type' == key:
                        self.exeStringWhereTemp += (" and ("+key+" = \'"+value+"\')")
                #print(key.split('Way')[0])
                #print(self.exeStringDict.get(key.split('Way')[0]))
            if 'objectWay' == key:
                if self.exeStringWhereTemp == '':
                    self.chooseObjectWrong = False
                else:
                    self.chooseObjectWrong = True
                if '' != self.exeStringDict['object']:
                    self.chooseObject = True
                    if '' == self.exeStringWhereTemp:
                        self.exeStringWhereTemp += ("("+value+" > "+self.exeStringDict['object'] +")")
        #print(self.count)
        #print(self.exeStringWhereTemp)
        #print(len(self.exeStringDictWay.keys()))
        if(0 == self.count):
            QMessageBox.information(self, "emmmm", "没有输入查询项", QMessageBox.Yes)
            return False
        if self.chooseObjectWrong and self.chooseObject:
            QMessageBox.information(self, "warning", "暂时只支持单独按物体查询", QMessageBox.Yes)
            return False
        return True
    
    def onDateChanged(self, data):
        pass
        #print(self.ui.dateEdit.date())
    
    def enterEvent(self,QEvent):
        #print('鼠标进入')
        self.setMouseTracking(False)#在MainWindow中不可用
    
    def leaveEvent(self,QEvent):
        #print('鼠标离开')
        self.setMouseTracking(False)
    
#    def mouseMoveEvent(self, event):#当鼠标按下拖动时触发
        #if event.buttons() == Qt.NoButton:
        #print((event.pos().x(), event.pos().y()))
#        pass
    
    def mouseDoubleClickEvent(self, event):
        print(event)
    
    def mousePressEvent(self, event):
        if event.button()==QtCore.Qt.LeftButton:
            self.m_flag=True
            self.m_Position=event.globalPos()-self.pos() #获取鼠标相对窗口的位置
            event.accept()
            #self.setCursor(QtGui.QCursor(QtCore.Qt.OpenHandCursor))  #更改鼠标图标

    def mouseMoveEvent(self, QMouseEvent):
        if QtCore.Qt.LeftButton and self.m_flag:
            self.move(QMouseEvent.globalPos()-self.m_Position)#更改窗口位置
            QMouseEvent.accept()
 
    def mouseReleaseEvent(self, QMouseEvent):
        self.m_flag=False
        #self.setCursor(QtGui.QCursor(QtCore.Qt.ArrowCursor))

    def eventFilter(self, object, event):
        if self.ui.pushButton_close == object and event.type() == QEvent.MouseButtonRelease:
            #'pushButton_close' == object.objectName()
            self.closeDatabase()
            self.close()
        #if object == self.calendarWidget:
        #print('active eventFilter')
        if event.type() == QEvent.HoverMove:
            #print(('button ', event.pos().x(), event.pos().y()))
            #print(object.objectName())
            return True
        elif event.type() == QEvent.MouseMove:
            print('点击')
            return True
            #print(('calendar', event.pos().x(), event.pos().y()))
        #return False
        return QWidget.eventFilter(self, object, event)
    
    def initDatabase2(self):
        self.conn = sqlite3.connect(self.databasePath)
        self.cursor = self.conn.cursor()
    
    def closeDatabase(self):
        self.cursor.close()
        self.conn.commit()
        self.conn.close()
    
    def initDatabase(self):
        db=''
        if not self.connectDatabase(db):
            return False
        #self.initTable()
    
    def connectDatabase(self, db):
        db = QSqlDatabase.addDatabase('QSQLITE')
        db.setDatabaseName(self.databasePath)
        if not db.open():
            print('连接数据库失败')
            return False
        else:
            return True
    
    def initTable(self):
        self.path1List = os.listdir(self.photoPath1)
        self.path2List = os.listdir(self.photoPath2)
        #ocr字典
        with open(r'X:\IPhone4s\IPhone4S\test.txt','r',encoding = 'utf-8') as f:
            content = f.read()
        self.myDictOcr = json.loads(content)
        #exif字典
        with open(r'X:\IPhone4s\IPhone4S\testExif.txt','r',encoding = 'utf-8') as f:
            s = f.read()
        global myDictExif
        myDictExif = eval(s)
        #DNdone字典
        with open(r'X:\IPhone4s\IPhone4S\DNdone.txt','r',encoding = 'utf-8') as f:
            content = f.read()
        global DNDict
        DNDict = json.loads(content)
        #self.startInsert(self.path1List, self.shortPath1, self.photoPath1)
        #self.startInsert(self.path2List, self.shortPath2, self.photoPath2)
        #self.updateGPSInfo('GPSInfoDecodeFormat', 'GPSInfoPlace')
        #self.updateGPSInfo('Make', 'cameraMaker')
        #self.updateGPSInfo('Model', 'cameraModel')
        #self.updateGPSInfo(['Make','Model'], ['cameraMaker','cameraModel'])
        #self.initPhotoObject()
    
    def initPhotoObject(self):
        '''
        从DNdone中获取数据
        '''
        self.initPhotoObjectColumn()
        query = QSqlQuery()
        keysDN = DNDict.keys()
        '''
        {
            objectName1:
                            {
                                path1 : float
                                path2 : float
                                ......
                            }
            objectName2:{......}
            ......
        }
        '''
        for objectName in keysDN:
            objectName = objectName.replace(' ','_')
            if DNDict.get(objectName):
                pathCon = DNDict.get(objectName)
            else:
                continue
            pathConKeys = pathCon.keys()
            for pa in pathConKeys:
                confidence = pathCon.get(pa)
                sqlExe = "insert into photoObject (name,path,{}) values('{}','{}',{})".format(objectName, pa.split('\\')[1], pa, confidence)
                if query.exec(sqlExe):
                    #print('success')
                    pass
                else:
                    print(pa+' '+'objectName'+' insert failed')
                    sqlExe = "update photoObject set {}={} where path='{}'".format(objectName, confidence, pa)
                    if query.exec(sqlExe):
                        print('but update success')
                        pass
                    else:
                        print(pa+' '+'objectName'+' update failed')
    
    def initPhotoObjectColumn(self):
        '''
        根据DNdone创建列
        '''
        query = QSqlQuery()
        keysDN = DNDict.keys()
        print(str(len(keysDN))+' 项')
        for key in keysDN:
            key = key.replace(' ','_')
            sqlExe = "alter table photoObject add column {} FLOAT".format(key)
            #alter table photoObject add column laptop FLOAT;
            if query.exec(sqlExe):
                #print('success')
                pass
            else:
                print(key+' failed')
    
    def updateGPSInfo(self, fromExif, whereDatabase):
        '''
        一个参数是存储在exif文件中的字典键名，一个是photo表的对应列名称
        暂时只能取出exif文件中的一级内容，写个递归就可以处理多级的问题了
        版本1：
            self.updateGPSInfo('Make', 'cameraMaker')
            self.updateGPSInfo('Model', 'cameraModel')
        只测试过版本1，版本2还未测试，毋庸置疑后者处理多个内容比执行多个前者要方便
        版本2：
            self.updateGPSInfo(['Make','Model'], ['cameraMaker','cameraModel'])
        '''
        if len(fromExif) != len(whereDatabase):
            return
        query = QSqlQuery()
        keyList = myDictExif.keys()
        for key in keyList:
            value = myDictExif.get(key)
            for e, w in zip(fromExif, whereDatabase):
                if value.get(e):
                    GPS = value[e]
                    #print(key+GPS)
                    sqlExe = "update photo set {}='{}' where path='{}'".format(w, GPS, key )
                    if query.exec(sqlExe):
                        #print('success')
                        pass
                    else:
                        print(pa+' failed')
    
    def startInsert(self, pathList, shortPath, photoPath):
        '''
        开始读取ocr数据，exif数据，以及创建数据库所需的其他数据
        '''
        query = QSqlQuery()
        #开始写入
        for name in pathList:
            #获取suffix
            suf = name.split('.')[1]
            #获取type
            if suf.upper() in ['PNG', 'JPG','HEIC', 'JPEG']:
                type = 'phpto' # 后知后觉 这个单词拼错了 于是打算不改了 让它成为特色
            elif suf.upper() in ['MOV', 'MP4']:
                type = 'video'
            elif suf.upper() == 'GIF':
                type = 'GIFph'
            else:
                continue
            #获取path
            pa = shortPath+name
            #获取ocr
            try:
                ocr = self.myDictOcr.get(pa)
            except:
                ocr = ''
            #获取 3 时间
            cT, mT, aT = self.fileCMATime(photoPath+name)
            #获取宽高以及两种尺寸type
            global myDictExif
            if myDictExif.get(pa):
                if myDictExif.get(pa).get('size'):
                    w = myDictExif.get(pa).get('size')[0]
                    h = myDictExif.get(pa).get('size')[1]
                else:
                    w = 0
                    h = 0
                if myDictExif.get(pa).get('size_type'):
                    size_type = myDictExif.get(pa).get('size_type')
                else:
                    size_type = ''
                if myDictExif.get(pa).get('widthHeight_type'):
                    widthHeight_type = myDictExif.get(pa).get('widthHeight_type')
                else:
                    widthHeight_type = ''
            else:
                w = 0
                h = 0
                size_type = ''
                widthHeight_type = ''
            sqlExe = "insert into photo values('{}','{}','{}','{}','{}',{},{},'{}','{}','{}','{}','{}')".format(name, type, suf, pa, ocr, h, w, size_type, widthHeight_type,cT, mT, aT)
            #print(str(h)+' '+str(w)+' '+size_type+' '+widthHeight_type)
            if query.exec(sqlExe):
                #print('success')
                pass
            else:
                print(pa+' failed')
    
    def fileCMATime(self, filePath):
        '''
        获取文件的三个时间数据
        '''
        fileInfo = os.stat(filePath)
        cTime = self.secondsToStr(fileInfo.st_ctime) #这是一个以(毫)秒为单位的时间
        mTime = self.secondsToStr(fileInfo.st_mtime)
        aTime = self.secondsToStr(fileInfo.st_atime)
        return cTime, mTime, aTime
        
    def secondsToStr(self, seconds):
        '''
        将以秒为单位的数据转换成字符串
        '''
        x = time.localtime(seconds)  # 时间元组
        return time.strftime("%Y-%m-%d %X", x) # 时间元组转为字符
    
    def setStyleSheet(self):
        '''
        首先，layout没有setStyleSheet的方法，QWidget有
        其次，待qt designer设计完成之后，需要修改一点代码
            因为在写的时候没有创建QWidget，再让它的布局设置为表格布局，而是直接在mainWidget上不断嵌套表格布局
            导致不能分块设置qss样式，虽然可以直接在mainWidget上设置，但是指定具体名称又很麻烦
            经实验，得到了一个后期修改方法，ui文件编译后以此法修改即可(换言之，修改会被编译覆盖)
            代码原本是
                self.gridLayout_main.addWidget(self.gridLayout, 0, 0, 1, 2) #这一句一般会在下面一点
            现在则需要先创建一个QWidget
                self.g1Widget = QtWidgets.QWidget()
                self.g1Widget.setObjectName("g1Widget")
            之后再把布局设置到这个QWidget里面
                self.g1Widget.setLayout(self.gridLayout)
            然后改成把这个QWidget添加到主布局中（之前是把布局添加到主布局中）
                self.gridLayout_main.addWidget(self.g1Widget, 0, 0, 1, 2)
            这样就可以在g1Widget上setStyleSheet了
        啊，不愧是我（叉会儿腰）
        '''
#        with open("./qss/my.qss") as f:
#            self.ui.centralWidget.setStyleSheet(f.read())
        with open("./qss/myUp.qss") as f:
            self.ui.upWidget.setStyleSheet(f.read())
        with open("./qss/myLeft.qss") as f:
            self.ui.leftWidget.setStyleSheet(f.read())
        with open("./qss/myRight.qss") as f:
            self.ui.rightWidget.setStyleSheet(f.read())
    
if __name__ =="__main__":
    import sys
    app = QApplication(sys.argv)
    aMainWindow = MainWindow()
    aMainWindow.show()
    sys.exit(app.exec_())
