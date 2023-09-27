from keyFrameGet import *
import os

photoPath1 = '.\\'
photoPath2 = '.\\'

outPutFile = r'.\b.txt'

path1List = os.listdir(photoPath1)
path2List = os.listdir(photoPath2)

outPath = '.\\'

for myVideo in path1List:
	if myVideo.endswith('.MP4'):
		if not os.path.exists(outPath+myVideo.split('.')[0]):
			try:
				keyframeGet(photoPath1,myVideo,outPath)
			except:
				pass

outPath = '.\\'

for myVideo in path2List:
	if myVideo.endswith('.MP4'):
		if not os.path.exists(outPath+myVideo.split('.')[0]):
			try:
				keyframeGet(photoPath2,myVideo,outPath)
			except:
				pass

