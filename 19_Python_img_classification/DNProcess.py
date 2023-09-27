import os
import json
from PIL import Image
from showPhotoWindow import *

photoPathShort = '.\\'

inPutFile = r'.\a.txt'
outPutFile = r'.\b.txt'

photoPath1 = '.\\'
photoPath2 = '.\\'

path1List = os.listdir(photoPath1)
path2List = os.listdir(photoPath2)

# 读取pythonDNtest生成的数据
myDict = {}
with open(inPutFile,'r',encoding = 'utf-8') as f:
	content = f.read()
myDict = json.loads(content)

# 提取内容和权重
keyList = myDict.keys()
outDict = {}
for key in keyList:
	value = myDict.get(key)
	for item in value:
		if not outDict.get(item[0]):
			outDict[item[0]] = {}
		outDict[item[0]][key] = item[1]

# for myPhoto in path1List:
	# if (myPhoto.endswith('.JPG') or myPhoto.endswith('.PNG') or myPhoto.endswith('.GIF')):
		# try:
			# with Image.open(photoPath1+myPhoto) as img:
				# size = img.size
		# except:
			# size = (0,0)


# 写入文件
jsonTest = json.dumps(outDict)
with open(outPutFile,'w',encoding = 'utf-8') as outPut:
	outPut.write(jsonTest)

# 微型查找模块
def searchDN(thing = 'cat',confidence = 0.75):
	tempList = []
	if outDict[thing]:
		resultDict = outDict[thing]
		keyList = resultDict.keys()
		for key in keyList:
			if resultDict.get(key) > confidence:
				tempList.append(key)
	return tempList
searchWhat = 'dog'
listCat = searchDN(searchWhat,0.98)
showPhotos(listCat,searchWhat)


#dict_keys(['laptop', 'book', 'refrigerator', 'tvmonitor', 'person', 'wine glass', 'bed', 'teddy bear', 'chair', 'cat', 'backpack', 'pottedplant', 'broccoli', 'sports ball', 'bench', 'keyboard', 'bird', 'car', 'bus', 'truck', 'aeroplane', 'scissors', 'dog', 'vase', 'tie', 'clock', 'remote', 'umbrella', 'handbag', 'toothbrush', 'spoon', 'cell phone', 'diningtable', 'pizza', 'boat', 'bottle', 'cup', 'bowl', 'mouse', 'hair drier', 'microwave', 'surfboard', 'cake', 'stop sign', 'horse', 'kite', 'sheep', 'frisbee', 'suitcase', 'sofa', 'donut', 'tennis racket', 'baseball bat', 'oven', 'motorbike', 'knife', 'giraffe', 'cow', 'toilet', 'bicycle', 'carrot', 'banana', 'fork', 'bear', 'train', 'baseball glove', 'apple', 'traffic light', 'sandwich', 'orange', 'skateboard', 'parking meter', 'skis', 'fire hydrant', 'zebra'])
