import os
import json
from PIL import Image
from PIL.ExifTags import TAGS

from mapAPITest import *

outPutFile = r'.\testExif.txt'

myDict = {}
# with open(outPutFile,'r',encoding = 'utf-8') as f:
	# content = f.read()
# myDict = json.loads(content)

with open(outPutFile,'r',encoding = 'utf-8') as f:
	string = f.read()
myDict = eval(string)

def myFun(photoPath1 = '.\\',shortPath = '.\\'):
	path1List = os.listdir(photoPath1)
	for myPhoto in path1List:
		#if not myDict.get(photoPath1 + myPhoto):
		success = 0
		if myPhoto.endswith('.JPG'):
			info = {}
			exifData = {}
			try:
				with Image.open(photoPath1+myPhoto) as img:
					info = img._getexif()
				if info:
					for (tag, value) in info.items():
						decoded = TAGS.get(tag, tag)
						exifData[decoded] = value
				success = 1
				if exifData.get('GPSInfo'):
			except:
				pass
			myDict[shortPath+myPhoto] = exifData
			if success:
				myDict[shortPath+myPhoto]['size'] = img.size
				myDict[shortPath+myPhoto]['format'] = img.format
				myDict[shortPath+myPhoto]['format_description'] = img.format_description
		elif (myPhoto.endswith('.PNG') or myPhoto.endswith('.GIF')):
			info = {}
			myDict[shortPath+myPhoto] = {}
			try:
				with Image.open(photoPath1+myPhoto) as img:
					myDict[shortPath+myPhoto]['info'] = img.info
					myDict[shortPath+myPhoto]['height'] = img.height
					myDict[shortPath+myPhoto]['width'] = img.width
					myDict[shortPath+myPhoto]['size'] = img.size
					myDict[shortPath+myPhoto]['format'] = img.format
					myDict[shortPath+myPhoto]['format_description'] = img.format_description
				success = 1
			except:
				pass
		# if success:
			# print(photoPath1+myPhoto+'\t\t:done')
		# else:
			# print(photoPath1+myPhoto+'\t\t:undone')

myFun('.\\','.\\')


# 因为字典里面有bytes类型的数据，所以保存成json会报错
# 下面这个函数是用来递归遍历字典来把bytes转换成utf-8编码的字符串
# def bytesToString(dict ,pathIndex):
	# if type(dict) is dict:
		# keyList = dict.keys()
		# for key in keyList:
			# value = dict.get(key)
			# if type(value) is bytes:
				# # 不写了。。。。因为找到了一个可以解决编码问题的方法了

# jsonTest = json.dumps(myDict)
# with open(outPutFile,'w',encoding = 'utf-8') as outPut:
	# outPut.write(jsonTest)

# 因为json的方法不可用 所以要用str() + eval() 的方法来存文件

myDictStr = str(myDict)
with open(outPutFile,'w',encoding = 'utf-8') as outPut:
	print(myDictStr,file = outPut)

