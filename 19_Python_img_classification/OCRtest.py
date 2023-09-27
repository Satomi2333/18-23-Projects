import pytesseract
from PIL import Image 
import os
import json

def myOCR(string1 ,language = 'chi_sim'):
	code = ''
	try:
		photo = Image.open(string1)
		code = pytesseract.image_to_string(photo, lang=language)
	except OSError:
		pass
	return code


photoPath1 = r'.\\'
photoPath2 = r'.\\'

outPutFile = r'.\test.txt'

path1List = os.listdir(photoPath1)
path2List = os.listdir(photoPath2)

myDict = {}
with open(outPutFile,'r',encoding = 'utf-8') as f:
	content = f.read()
myDict = json.loads(content)

for myPhoto in path1List:
	if (myPhoto.endswith('.JPG') or myPhoto.endswith('.PNG')):
		if ((not myDict.get('.\\' + myPhoto)) and (not(type(myDict.get('.\\' + myPhoto)) is str))):
			result = myOCR(photoPath1+myPhoto)
			myDict['.\\' + myPhoto] = result
			print(myPhoto)

for myPhoto in path2List:
	if (myPhoto.endswith('.JPG') or myPhoto.endswith('.PNG')):
		if ((not myDict.get('.\\' + myPhoto)) and (not(type(myDict.get('.\\' + myPhoto)) is str))):
			result = myOCR(photoPath2+myPhoto)
			myDict['.\\' + myPhoto] = result
			print(myPhoto)

videoFramePath1 = '.\\'
videoFramePath2 = '.\\'

framesList1 = os.listdir(videoFramePath1)
framesList2 = os.listdir(videoFramePath2)

# for folder in framesList1:
	# pathNow = videoFramePath1 + folder + '\\'
	# photos = os.listdir(pathNow)
	# if not myDict.get('.\\' + folder + '.MP4'):
		# myDict['.\\' + folder + '.MP4'] = ''
		# for myPhoto in photos:
			# result = myOCR(pathNow + myPhoto)
			# myDict['.\\' + folder + '.MP4'] += result + '\t'
		# print(pathNow)

for folder in framesList2:
	pathNow = videoFramePath2 + folder + '\\'
	photos = os.listdir(pathNow)
	#if not os.path.exists(pathNow):
	myDict['.\\' + folder + '.MP4'] = ''
	for myPhoto in photos:
		result = myOCR(pathNow + myPhoto)
		myDict['.\\' + folder + '.MP4'] += result + '\t'
	print(pathNow)


jsonTest = json.dumps(myDict)
with open(outPutFile,'w',encoding = 'utf-8') as outPut:
	outPut.write(jsonTest)


