from darknet import *
import os
import json


photoPath1 = '.\\'
photoPath2 = '.\\'

outPutFile = r'.\testdn.txt'

path1List = os.listdir(photoPath1)
path2List = os.listdir(photoPath2)


myDict = {}
with open(outPutFile,'r',encoding = 'utf-8') as f:
	content = f.read()
myDict = json.loads(content)

for myPhoto in path1List:
	if (myPhoto.endswith('.JPG') or myPhoto.endswith('.PNG')):
		#if not myDict.get('.\\' + myPhoto):
			try:
				result = performDetect(imagePath=photoPath1+myPhoto, thresh= 0.25, configPath = "yolov3.cfg", weightPath = "yolov3.weights", metaPath= "./cfg/coco.data", showImage= False , makeImageOnly = False, initOnly= False)
			except:
				result = []
			myDict['.\\' + myPhoto] = result
			print(myPhoto)

for myPhoto in path2List:
	if (myPhoto.endswith('.JPG') or myPhoto.endswith('.PNG')):
		#if not myDict.get('.\\' + myPhoto):
			try:
				result = performDetect(imagePath=photoPath1+myPhoto, thresh= 0.25, configPath = "yolov3.cfg", weightPath = "yolov3.weights", metaPath= "./cfg/coco.data", showImage= False , makeImageOnly = False, initOnly= False)
			except:
				result = []
			myDict['1\\' + myPhoto] = result
			print(myPhoto)

jsonTest = json.dumps(myDict)
with open(outPutFile,'w',encoding = 'utf-8') as outPut:
	outPut.write(jsonTest)

