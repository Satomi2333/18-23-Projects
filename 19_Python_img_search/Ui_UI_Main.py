# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'X:\Work_Py\PyQt\SQLPython\UI_Main.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(774, 460)
        MainWindow.setMinimumSize(QtCore.QSize(774, 460))
        self.centralWidget = QtWidgets.QWidget(MainWindow)
        self.centralWidget.setObjectName("centralWidget")
        
        self.upWidget = QtWidgets.QWidget()
        self.upWidget.setObjectName("upWidget")
        self.leftWidget = QtWidgets.QWidget()
        self.leftWidget.setObjectName("leftWidget")
        self.rightWidget = QtWidgets.QWidget()
        self.rightWidget.setObjectName("rightWidget")
        
        self.gridLayout_main = QtWidgets.QGridLayout(self.centralWidget)
        self.gridLayout_main.setContentsMargins(0, 0, 0, 0)
        self.gridLayout_main.setSpacing(0)
        self.gridLayout_main.setObjectName("gridLayout_main")
        self.gridLayout_2 = QtWidgets.QGridLayout()
        self.gridLayout_2.setContentsMargins(5, -1, -1, -1)
        self.gridLayout_2.setObjectName("gridLayout_2")
        self.lineEdit = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit.setObjectName("lineEdit")
        self.gridLayout_2.addWidget(self.lineEdit, 0, 2, 1, 1)
        self.comboBox = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox.setObjectName("comboBox")
        self.gridLayout_2.addWidget(self.comboBox, 0, 1, 1, 1)
        self.label_5 = QtWidgets.QLabel(self.centralWidget)
        self.label_5.setAlignment(QtCore.Qt.AlignCenter)
        self.label_5.setObjectName("label_5")
        self.gridLayout_2.addWidget(self.label_5, 3, 0, 1, 1)
        self.comboBox_12 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_12.setObjectName("comboBox_12")
        self.gridLayout_2.addWidget(self.comboBox_12, 11, 1, 1, 1)
        self.comboBox_8 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_8.setObjectName("comboBox_8")
        self.gridLayout_2.addWidget(self.comboBox_8, 7, 1, 1, 2)
        self.label_8 = QtWidgets.QLabel(self.centralWidget)
        self.label_8.setAlignment(QtCore.Qt.AlignCenter)
        self.label_8.setObjectName("label_8")
        self.gridLayout_2.addWidget(self.label_8, 6, 0, 1, 1)
        self.label_12 = QtWidgets.QLabel(self.centralWidget)
        self.label_12.setAlignment(QtCore.Qt.AlignCenter)
        self.label_12.setObjectName("label_12")
        self.gridLayout_2.addWidget(self.label_12, 11, 0, 1, 1)
        self.label_13 = QtWidgets.QLabel(self.centralWidget)
        self.label_13.setAlignment(QtCore.Qt.AlignCenter)
        self.label_13.setObjectName("label_13")
        self.gridLayout_2.addWidget(self.label_13, 12, 0, 1, 1)
        self.pushButton_search = QtWidgets.QPushButton(self.centralWidget)
        self.pushButton_search.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_search.setObjectName("pushButton_search")
        self.gridLayout_2.addWidget(self.pushButton_search, 14, 2, 1, 1)
        self.lineEdit_2 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_2.setObjectName("lineEdit_2")
        self.gridLayout_2.addWidget(self.lineEdit_2, 2, 2, 1, 1)
        self.comboBox_4 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_4.setObjectName("comboBox_4")
        self.gridLayout_2.addWidget(self.comboBox_4, 3, 1, 1, 1)
        self.label_6 = QtWidgets.QLabel(self.centralWidget)
        self.label_6.setAlignment(QtCore.Qt.AlignCenter)
        self.label_6.setObjectName("label_6")
        self.gridLayout_2.addWidget(self.label_6, 4, 0, 1, 1)
        self.comboBox_3 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_3.setObjectName("comboBox_3")
        self.gridLayout_2.addWidget(self.comboBox_3, 2, 1, 1, 1)
        self.verticalLayout = QtWidgets.QVBoxLayout()
        self.verticalLayout.setObjectName("verticalLayout")
        self.dateEdit = QtWidgets.QDateEdit(self.centralWidget)
        self.dateEdit.setObjectName("dateEdit")
        self.verticalLayout.addWidget(self.dateEdit)
        self.comboBox_10 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_10.setObjectName("comboBox_10")
        self.verticalLayout.addWidget(self.comboBox_10)
        self.gridLayout_2.addLayout(self.verticalLayout, 8, 2, 1, 1)
        self.comboBox_2 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_2.setObjectName("comboBox_2")
        self.gridLayout_2.addWidget(self.comboBox_2, 1, 1, 1, 2)
        self.comboBox_9 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_9.setObjectName("comboBox_9")
        self.gridLayout_2.addWidget(self.comboBox_9, 8, 1, 1, 1)
        self.comboBox_5 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_5.setObjectName("comboBox_5")
        self.gridLayout_2.addWidget(self.comboBox_5, 4, 1, 1, 1)
        self.label_9 = QtWidgets.QLabel(self.centralWidget)
        self.label_9.setAlignment(QtCore.Qt.AlignCenter)
        self.label_9.setObjectName("label_9")
        self.gridLayout_2.addWidget(self.label_9, 7, 0, 1, 1)
        self.pushButton_clear = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_clear.sizePolicy().hasHeightForWidth())
        self.pushButton_clear.setSizePolicy(sizePolicy)
        self.pushButton_clear.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_clear.setObjectName("pushButton_clear")
        self.gridLayout_2.addWidget(self.pushButton_clear, 14, 1, 1, 1)
        self.label_14 = QtWidgets.QLabel(self.centralWidget)
        self.label_14.setAlignment(QtCore.Qt.AlignCenter)
        self.label_14.setObjectName("label_14")
        self.gridLayout_2.addWidget(self.label_14, 13, 0, 1, 1)
        self.comboBox_14 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_14.setObjectName("comboBox_14")
        self.gridLayout_2.addWidget(self.comboBox_14, 13, 1, 1, 1)
        self.comboBox_7 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_7.setObjectName("comboBox_7")
        self.gridLayout_2.addWidget(self.comboBox_7, 6, 1, 1, 2)
        self.label_10 = QtWidgets.QLabel(self.centralWidget)
        self.label_10.setAlignment(QtCore.Qt.AlignCenter)
        self.label_10.setObjectName("label_10")
        self.gridLayout_2.addWidget(self.label_10, 8, 0, 1, 1)
        self.lineEdit_4 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_4.setObjectName("lineEdit_4")
        self.gridLayout_2.addWidget(self.lineEdit_4, 4, 2, 1, 1)
        self.label_2 = QtWidgets.QLabel(self.centralWidget)
        self.label_2.setAlignment(QtCore.Qt.AlignCenter)
        self.label_2.setObjectName("label_2")
        self.gridLayout_2.addWidget(self.label_2, 0, 0, 1, 1)
        self.lineEdit_3 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_3.setObjectName("lineEdit_3")
        self.gridLayout_2.addWidget(self.lineEdit_3, 3, 2, 1, 1)
        self.label_11 = QtWidgets.QLabel(self.centralWidget)
        self.label_11.setAlignment(QtCore.Qt.AlignCenter)
        self.label_11.setObjectName("label_11")
        self.gridLayout_2.addWidget(self.label_11, 9, 0, 1, 1)
        self.label_7 = QtWidgets.QLabel(self.centralWidget)
        self.label_7.setAlignment(QtCore.Qt.AlignCenter)
        self.label_7.setObjectName("label_7")
        self.gridLayout_2.addWidget(self.label_7, 5, 0, 1, 1)
        self.label_4 = QtWidgets.QLabel(self.centralWidget)
        self.label_4.setAlignment(QtCore.Qt.AlignCenter)
        self.label_4.setObjectName("label_4")
        self.gridLayout_2.addWidget(self.label_4, 2, 0, 1, 1)
        self.label_3 = QtWidgets.QLabel(self.centralWidget)
        self.label_3.setAlignment(QtCore.Qt.AlignCenter)
        self.label_3.setObjectName("label_3")
        self.gridLayout_2.addWidget(self.label_3, 1, 0, 1, 1)
        self.comboBox_11 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_11.setObjectName("comboBox_11")
        self.gridLayout_2.addWidget(self.comboBox_11, 9, 1, 1, 1)
        self.comboBox_13 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_13.setObjectName("comboBox_13")
        self.gridLayout_2.addWidget(self.comboBox_13, 12, 1, 1, 1)
        self.comboBox_6 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_6.setObjectName("comboBox_6")
        self.gridLayout_2.addWidget(self.comboBox_6, 5, 1, 1, 1)
        self.lineEdit_5 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_5.setObjectName("lineEdit_5")
        self.gridLayout_2.addWidget(self.lineEdit_5, 5, 2, 1, 1)
        self.lineEdit_6 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_6.setObjectName("lineEdit_6")
        self.gridLayout_2.addWidget(self.lineEdit_6, 9, 2, 1, 1)
        self.lineEdit_7 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_7.setObjectName("lineEdit_7")
        self.gridLayout_2.addWidget(self.lineEdit_7, 11, 2, 1, 1)
        self.lineEdit_8 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_8.setObjectName("lineEdit_8")
        self.gridLayout_2.addWidget(self.lineEdit_8, 12, 2, 1, 1)
        self.lineEdit_9 = QtWidgets.QLineEdit(self.centralWidget)
        self.lineEdit_9.setObjectName("lineEdit_9")
        self.gridLayout_2.addWidget(self.lineEdit_9, 13, 2, 1, 1)
        self.gridLayout_2.setColumnStretch(0, 1)
        self.gridLayout_2.setColumnStretch(1, 1)
        self.gridLayout_2.setColumnStretch(2, 2)
        
        
        self.gridLayout_3 = QtWidgets.QGridLayout()
        self.gridLayout_3.setContentsMargins(10, 10, 10, 6)
        self.gridLayout_3.setObjectName("gridLayout_3")
        self.gridLayout_4 = QtWidgets.QGridLayout()
        self.gridLayout_4.setObjectName("gridLayout_4")
        self.label_17 = QtWidgets.QLabel(self.centralWidget)
        self.label_17.setObjectName("label_17")
        self.gridLayout_4.addWidget(self.label_17, 0, 0, 1, 1)
        self.pushButton_cz = QtWidgets.QPushButton(self.centralWidget)
        self.pushButton_cz.setMinimumSize(QtCore.QSize(20, 20))
        self.pushButton_cz.setText("")
        self.pushButton_cz.setObjectName("pushButton_cz")
        self.gridLayout_4.addWidget(self.pushButton_cz, 0, 3, 1, 1)
        self.pushButton_cx = QtWidgets.QPushButton(self.centralWidget)
        self.pushButton_cx.setMinimumSize(QtCore.QSize(20, 20))
        self.pushButton_cx.setText("")
        self.pushButton_cx.setObjectName("pushButton_cx")
        self.gridLayout_4.addWidget(self.pushButton_cx, 0, 2, 1, 1)
        self.pushButton_process = QtWidgets.QPushButton(self.centralWidget)
        self.pushButton_process.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_process.setObjectName("pushButton_process")
        self.gridLayout_4.addWidget(self.pushButton_process, 1, 2, 1, 2)
        self.textEdit = QtWidgets.QTextEdit(self.centralWidget)
        self.textEdit.setObjectName("textEdit")
        self.gridLayout_4.addWidget(self.textEdit, 1, 0, 1, 1)
        self.gridLayout_3.addLayout(self.gridLayout_4, 0, 0, 1, 1)
        self.verticalLayout_3 = QtWidgets.QVBoxLayout()
        self.verticalLayout_3.setObjectName("verticalLayout_3")
        self.horizontalLayout = QtWidgets.QHBoxLayout()
        self.horizontalLayout.setSpacing(20)
        self.horizontalLayout.setObjectName("horizontalLayout")
        self.label_16 = QtWidgets.QLabel(self.centralWidget)
        self.label_16.setObjectName("label_16")
        self.horizontalLayout.addWidget(self.label_16)
        self.comboBox_15 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_15.setObjectName("comboBox_15")
        self.horizontalLayout.addWidget(self.comboBox_15)
        self.comboBox_16 = QtWidgets.QComboBox(self.centralWidget)
        self.comboBox_16.setObjectName("comboBox_16")
        self.horizontalLayout.addWidget(self.comboBox_16)
        self.label_18 = QtWidgets.QLabel(self.centralWidget)
        self.label_18.setText("")
        self.label_18.setObjectName("label_18")
        self.horizontalLayout.addWidget(self.label_18)
        self.horizontalLayout.setStretch(0, 1)
        self.horizontalLayout.setStretch(1, 1)
        self.horizontalLayout.setStretch(2, 1)
        self.horizontalLayout.setStretch(3, 2)
        self.verticalLayout_3.addLayout(self.horizontalLayout)
        self.horizontalLayout_2 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_2.setSpacing(0)
        self.horizontalLayout_2.setObjectName("horizontalLayout_2")
        self.pushButton_show0 = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_show0.sizePolicy().hasHeightForWidth())
        self.pushButton_show0.setSizePolicy(sizePolicy)
        self.pushButton_show0.setMinimumSize(QtCore.QSize(100, 100))
        self.pushButton_show0.setCursor(QtGui.QCursor(QtCore.Qt.ArrowCursor))
        self.pushButton_show0.setStyleSheet("")
        self.pushButton_show0.setText("")
        self.pushButton_show0.setIconSize(QtCore.QSize(100, 100))
        self.pushButton_show0.setObjectName("pushButton_show0")
        self.horizontalLayout_2.addWidget(self.pushButton_show0)
        self.pushButton_show1 = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_show1.sizePolicy().hasHeightForWidth())
        self.pushButton_show1.setSizePolicy(sizePolicy)
        self.pushButton_show1.setMinimumSize(QtCore.QSize(100, 100))
        self.pushButton_show1.setText("")
        self.pushButton_show1.setIconSize(QtCore.QSize(100, 100))
        self.pushButton_show1.setObjectName("pushButton_show1")
        self.horizontalLayout_2.addWidget(self.pushButton_show1)
        self.pushButton_show2 = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_show2.sizePolicy().hasHeightForWidth())
        self.pushButton_show2.setSizePolicy(sizePolicy)
        self.pushButton_show2.setMinimumSize(QtCore.QSize(100, 100))
        self.pushButton_show2.setText("")
        self.pushButton_show2.setIconSize(QtCore.QSize(100, 100))
        self.pushButton_show2.setObjectName("pushButton_show2")
        self.horizontalLayout_2.addWidget(self.pushButton_show2)
        self.pushButton_show3 = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_show3.sizePolicy().hasHeightForWidth())
        self.pushButton_show3.setSizePolicy(sizePolicy)
        self.pushButton_show3.setMinimumSize(QtCore.QSize(100, 100))
        self.pushButton_show3.setText("")
        self.pushButton_show3.setIconSize(QtCore.QSize(100, 100))
        self.pushButton_show3.setObjectName("pushButton_show3")
        self.horizontalLayout_2.addWidget(self.pushButton_show3)
        self.pushButton_show4 = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_show4.sizePolicy().hasHeightForWidth())
        self.pushButton_show4.setSizePolicy(sizePolicy)
        self.pushButton_show4.setMinimumSize(QtCore.QSize(100, 100))
        self.pushButton_show4.setText("")
        self.pushButton_show4.setIconSize(QtCore.QSize(100, 100))
        self.pushButton_show4.setObjectName("pushButton_show4")
        self.horizontalLayout_2.addWidget(self.pushButton_show4)
        self.verticalLayout_3.addLayout(self.horizontalLayout_2)
        self.horizontalLayout_3 = QtWidgets.QHBoxLayout()
        self.horizontalLayout_3.setContentsMargins(60, -1, 60, -1)
        self.horizontalLayout_3.setSpacing(50)
        self.horizontalLayout_3.setObjectName("horizontalLayout_3")
        self.pushButton_firstPage = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_firstPage.sizePolicy().hasHeightForWidth())
        self.pushButton_firstPage.setSizePolicy(sizePolicy)
        self.pushButton_firstPage.setMinimumSize(QtCore.QSize(20, 20))
        self.pushButton_firstPage.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_firstPage.setObjectName("pushButton_firstPage")
        self.horizontalLayout_3.addWidget(self.pushButton_firstPage)
        self.pushButton_upPage = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_upPage.sizePolicy().hasHeightForWidth())
        self.pushButton_upPage.setSizePolicy(sizePolicy)
        self.pushButton_upPage.setMinimumSize(QtCore.QSize(20, 20))
        self.pushButton_upPage.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_upPage.setObjectName("pushButton_upPage")
        self.horizontalLayout_3.addWidget(self.pushButton_upPage)
        self.pushButton_downPage = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_downPage.sizePolicy().hasHeightForWidth())
        self.pushButton_downPage.setSizePolicy(sizePolicy)
        self.pushButton_downPage.setMinimumSize(QtCore.QSize(20, 20))
        self.pushButton_downPage.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_downPage.setObjectName("pushButton_downPage")
        self.horizontalLayout_3.addWidget(self.pushButton_downPage)
        self.pushButton_lastPage = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_lastPage.sizePolicy().hasHeightForWidth())
        self.pushButton_lastPage.setSizePolicy(sizePolicy)
        self.pushButton_lastPage.setMinimumSize(QtCore.QSize(20, 20))
        self.pushButton_lastPage.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_lastPage.setObjectName("pushButton_lastPage")
        self.horizontalLayout_3.addWidget(self.pushButton_lastPage)
        self.verticalLayout_3.addLayout(self.horizontalLayout_3)
        self.verticalLayout_3.setStretch(0, 1)
        self.verticalLayout_3.setStretch(1, 2)
        self.verticalLayout_3.setStretch(2, 1)
        self.gridLayout_3.addLayout(self.verticalLayout_3, 1, 0, 1, 2)
        self.label_15 = QtWidgets.QLabel(self.centralWidget)
        self.label_15.setAlignment(QtCore.Qt.AlignRight|QtCore.Qt.AlignTrailing|QtCore.Qt.AlignVCenter)
        self.label_15.setObjectName("label_15")
        self.gridLayout_3.addWidget(self.label_15, 3, 1, 1, 1)
        self.label_empty = QtWidgets.QLabel(self.centralWidget)
        self.label_empty.setText("")
        self.label_empty.setObjectName("label_empty")
        self.gridLayout_3.addWidget(self.label_empty, 0, 1, 1, 1)
        self.gridLayout_3.setColumnStretch(0, 2)
        self.gridLayout_3.setColumnStretch(1, 1)
        self.gridLayout_3.setRowStretch(0, 3)
        self.gridLayout_3.setRowStretch(1, 3)
        
        
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setContentsMargins(10, -1, -1, -1)
        self.gridLayout.setObjectName("gridLayout")
        self.pushButton_zdh = QtWidgets.QPushButton(self.centralWidget)
        self.pushButton_zdh.setEnabled(False)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_zdh.sizePolicy().hasHeightForWidth())
        self.pushButton_zdh.setSizePolicy(sizePolicy)
        self.pushButton_zdh.setMinimumSize(QtCore.QSize(15, 15))
        self.pushButton_zdh.setCursor(QtGui.QCursor(QtCore.Qt.BlankCursor))
        self.pushButton_zdh.setText("")
        self.pushButton_zdh.setIconSize(QtCore.QSize(25, 25))
        self.pushButton_zdh.setObjectName("pushButton_zdh")
        self.gridLayout.addWidget(self.pushButton_zdh, 0, 3, 1, 1)
        self.label = QtWidgets.QLabel(self.centralWidget)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 0, 1, 1, 1)
        self.pushButton_close = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_close.sizePolicy().hasHeightForWidth())
        self.pushButton_close.setSizePolicy(sizePolicy)
        self.pushButton_close.setMinimumSize(QtCore.QSize(15, 15))
        self.pushButton_close.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_close.setText("")
        self.pushButton_close.setIconSize(QtCore.QSize(25, 25))
        self.pushButton_close.setObjectName("pushButton_close")
        self.gridLayout.addWidget(self.pushButton_close, 0, 4, 1, 1)
        self.pushButton_zxh = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Fixed, QtWidgets.QSizePolicy.Fixed)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_zxh.sizePolicy().hasHeightForWidth())
        self.pushButton_zxh.setSizePolicy(sizePolicy)
        self.pushButton_zxh.setMinimumSize(QtCore.QSize(15, 15))
        self.pushButton_zxh.setCursor(QtGui.QCursor(QtCore.Qt.PointingHandCursor))
        self.pushButton_zxh.setText("")
        self.pushButton_zxh.setIconSize(QtCore.QSize(25, 25))
        self.pushButton_zxh.setObjectName("pushButton_zxh")
        self.gridLayout.addWidget(self.pushButton_zxh, 0, 2, 1, 1)
        self.pushButton_icon = QtWidgets.QPushButton(self.centralWidget)
        sizePolicy = QtWidgets.QSizePolicy(QtWidgets.QSizePolicy.Minimum, QtWidgets.QSizePolicy.Minimum)
        sizePolicy.setHorizontalStretch(0)
        sizePolicy.setVerticalStretch(0)
        sizePolicy.setHeightForWidth(self.pushButton_icon.sizePolicy().hasHeightForWidth())
        self.pushButton_icon.setSizePolicy(sizePolicy)
        self.pushButton_icon.setMinimumSize(QtCore.QSize(30, 30))
        self.pushButton_icon.setMaximumSize(QtCore.QSize(55, 55))
        self.pushButton_icon.setText("")
        self.pushButton_icon.setIconSize(QtCore.QSize(35, 35))
        self.pushButton_icon.setObjectName("pushButton_icon")
        self.gridLayout.addWidget(self.pushButton_icon, 0, 0, 1, 1)
        self.gridLayout.setColumnStretch(0, 1)
        self.gridLayout.setColumnStretch(1, 12)
        self.gridLayout.setColumnStretch(2, 1)
        self.gridLayout.setColumnStretch(3, 1)
        
        self.leftWidget.setLayout(self.gridLayout_2)
        self.rightWidget.setLayout(self.gridLayout_3)
        self.upWidget.setLayout(self.gridLayout)
        self.gridLayout_main.addWidget(self.rightWidget, 1, 1, 1, 1)
        self.gridLayout_main.addWidget(self.upWidget, 0, 0, 1, 2)
        self.gridLayout_main.addWidget(self.leftWidget, 1, 0, 1, 1)
        
        self.gridLayout_main.setColumnStretch(0, 1)
        self.gridLayout_main.setRowStretch(0, 1)
        MainWindow.setCentralWidget(self.centralWidget)
        self.label_5.setBuddy(self.lineEdit_3)
        self.label_8.setBuddy(self.comboBox_7)
        self.label_12.setBuddy(self.lineEdit_6)
        self.label_13.setBuddy(self.lineEdit_7)
        self.label_6.setBuddy(self.lineEdit_4)
        self.label_9.setBuddy(self.comboBox_8)
        self.label_14.setBuddy(self.comboBox_14)
        self.label_10.setBuddy(self.dateEdit)
        self.label_2.setBuddy(self.lineEdit)
        self.label_11.setBuddy(self.lineEdit_5)
        self.label_7.setBuddy(self.comboBox_6)
        self.label_4.setBuddy(self.lineEdit_2)
        self.label_3.setBuddy(self.comboBox_2)

        self.retranslateUi(MainWindow)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)
        MainWindow.setTabOrder(self.comboBox, self.lineEdit)
        MainWindow.setTabOrder(self.lineEdit, self.comboBox_2)
        MainWindow.setTabOrder(self.comboBox_2, self.comboBox_3)
        MainWindow.setTabOrder(self.comboBox_3, self.lineEdit_2)
        MainWindow.setTabOrder(self.lineEdit_2, self.comboBox_4)
        MainWindow.setTabOrder(self.comboBox_4, self.lineEdit_3)
        MainWindow.setTabOrder(self.lineEdit_3, self.comboBox_5)
        MainWindow.setTabOrder(self.comboBox_5, self.lineEdit_4)
        MainWindow.setTabOrder(self.lineEdit_4, self.comboBox_6)
        MainWindow.setTabOrder(self.comboBox_6, self.comboBox_7)
        MainWindow.setTabOrder(self.comboBox_7, self.comboBox_8)
        MainWindow.setTabOrder(self.comboBox_8, self.comboBox_9)
        MainWindow.setTabOrder(self.comboBox_9, self.dateEdit)
        MainWindow.setTabOrder(self.dateEdit, self.comboBox_10)
        MainWindow.setTabOrder(self.comboBox_10, self.comboBox_11)
        MainWindow.setTabOrder(self.comboBox_11, self.comboBox_12)
        MainWindow.setTabOrder(self.comboBox_12, self.comboBox_13)
        MainWindow.setTabOrder(self.comboBox_13, self.comboBox_14)
        MainWindow.setTabOrder(self.comboBox_14, self.pushButton_clear)
        MainWindow.setTabOrder(self.pushButton_clear, self.pushButton_search)
        MainWindow.setTabOrder(self.pushButton_search, self.pushButton_process)
        MainWindow.setTabOrder(self.pushButton_process, self.comboBox_15)
        MainWindow.setTabOrder(self.comboBox_15, self.comboBox_16)
        MainWindow.setTabOrder(self.comboBox_16, self.pushButton_firstPage)
        MainWindow.setTabOrder(self.pushButton_firstPage, self.pushButton_upPage)
        MainWindow.setTabOrder(self.pushButton_upPage, self.pushButton_downPage)
        MainWindow.setTabOrder(self.pushButton_downPage, self.pushButton_lastPage)
        MainWindow.setTabOrder(self.pushButton_lastPage, self.pushButton_show1)
        MainWindow.setTabOrder(self.pushButton_show1, self.pushButton_show2)
        MainWindow.setTabOrder(self.pushButton_show2, self.pushButton_show3)
        MainWindow.setTabOrder(self.pushButton_show3, self.pushButton_show4)
        MainWindow.setTabOrder(self.pushButton_show4, self.pushButton_cx)
        MainWindow.setTabOrder(self.pushButton_cx, self.pushButton_cz)
        MainWindow.setTabOrder(self.pushButton_cz, self.textEdit)
        MainWindow.setTabOrder(self.textEdit, self.pushButton_icon)
        MainWindow.setTabOrder(self.pushButton_icon, self.pushButton_zxh)
        MainWindow.setTabOrder(self.pushButton_zxh, self.pushButton_zdh)
        MainWindow.setTabOrder(self.pushButton_zdh, self.pushButton_close)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "MainWindow"))
        self.label_5.setText(_translate("MainWindow", "OCR"))
        self.label_8.setText(_translate("MainWindow", "尺寸类型"))
        self.label_12.setText(_translate("MainWindow", "相机厂商"))
        self.label_13.setText(_translate("MainWindow", "相机型号"))
        self.pushButton_search.setText(_translate("MainWindow", "查询"))
        self.label_6.setText(_translate("MainWindow", "宽度"))
        self.label_9.setText(_translate("MainWindow", "宽高类型"))
        self.pushButton_clear.setText(_translate("MainWindow", "清空"))
        self.label_14.setText(_translate("MainWindow", "物体"))
        self.label_10.setText(_translate("MainWindow", "时间戳"))
        self.label_2.setText(_translate("MainWindow", "名称"))
        self.label_11.setText(_translate("MainWindow", "地理位置"))
        self.label_7.setText(_translate("MainWindow", "高度"))
        self.label_4.setText(_translate("MainWindow", "后缀"))
        self.label_3.setText(_translate("MainWindow", "类型"))
        self.label_17.setText(_translate("MainWindow", "自定义查询语句"))
        self.pushButton_process.setText(_translate("MainWindow", "执行"))
        self.label_16.setText(_translate("MainWindow", "排序方式"))
        self.pushButton_firstPage.setText(_translate("MainWindow", "首页"))
        self.pushButton_upPage.setText(_translate("MainWindow", "上一页"))
        self.pushButton_downPage.setText(_translate("MainWindow", "下一页"))
        self.pushButton_lastPage.setText(_translate("MainWindow", "末页"))
        self.label_15.setText(_translate("MainWindow", "by Water"))
        self.label.setText(_translate("MainWindow", "图片查询系统"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())
