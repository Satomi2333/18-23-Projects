# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'X:\Work_Py\PyQt\SQLPython\showPhoto.ui'
#
# Created by: PyQt5 UI code generator 5.13.0
#
# WARNING! All changes made in this file will be lost!


from PyQt5 import QtCore, QtGui, QtWidgets


class Ui_Dialog(object):
    photoPath = ''
    
    def setupUi(self, Dialog):
        Dialog.setObjectName("Dialog")
        #Dialog.resize(400, 300)
        #Dialog.setSizeGripEnabled(True)
        self.centralWidget = QtWidgets.QWidget(Dialog)
        self.centralWidget.setObjectName("centralWidget")
        self.gridLayout_main = QtWidgets.QGridLayout(self.centralWidget)
        self.graph = QtWidgets.QGraphicsView(Dialog)
        self.gridLayout_main.addWidget(self.graph)
        self.graph.scene = QtWidgets.QGraphicsScene() 
        item=QtWidgets.QGraphicsPixmapItem(QtGui.QPixmap(self.photoPath))
        self.graph.scene.addItem(item)
        self.graph.setScene(self.graph.scene)
        Dialog.setCentralWidget(self.centralWidget)
        #Dialog.addWidget(self.centralWidget)
        
        self.retranslateUi(Dialog)
        QtCore.QMetaObject.connectSlotsByName(Dialog)

    def retranslateUi(self, Dialog):
        _translate = QtCore.QCoreApplication.translate
        Dialog.setWindowTitle(_translate("Dialog", "Dialog"))
    
    def handle_click(self):
        #if not self.isVisible():
        self.show()

    def handle_close(self):
        self.close()

#if __name__ == "__main__":
#    import sys
#    app = QtWidgets.QApplication(sys.argv)
#    Dialog = QtWidgets.QMainWindow()
#    ui = Ui_Dialog()
#    ui.setupUi(Dialog)
#    Dialog.show()
#    sys.exit(app.exec_())

def showInSubWindow(photoPa='d:\\bg.jpg'):
    ui = Ui_Dialog()
    ui.photoPath = photoPa
    aaa = QtWidgets.QMainWindow()
    ui.setupUi(aaa)
#    ui.setupUi(QtWidgets.QWidget())
#    ui.handle_click()
    aaa.show()
