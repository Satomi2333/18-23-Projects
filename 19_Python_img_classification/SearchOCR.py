# 搜索OCR识别结果 
import os
import json
from showPhotoWindow import *

inPutFile = r'.\test.txt'

myDict = {}
with open(inPutFile,'r',encoding = 'utf-8') as f:
	content = f.read()
myDict = json.loads(content)

def splitWord(word,splitRate = 1):
	wordList = []
	wordLen = len(word)
	if wordLen == 1:
		wordList.append((word,splitRate))
		return wordList
	elif wordLen > 1:
		mid = round(wordLen/2)
		wordList.append((word[:mid],splitRate/2))
		wordList.append((word[mid:],splitRate/2))


def searchOCR(what = '中国移动'):
	tempList = []
	keyList = myDict.keys()
	for key in keyList:
		if what in myDict.get(key): # 全词匹配搜索
			tempList.append(key)
	return tempList


searchWhat = '知乎'
listShadiao = searchOCR(searchWhat)
showPhotos(listShadiao,searchWhat)
