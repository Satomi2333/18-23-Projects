# 创建窗口并显示图片
import time
import tkinter as tk
from PIL import Image,ImageTk

def toSquare(imagePath, targetSize = 200, keepProportionally = True):
	from PIL import Image,ImageTk
	try:
		img = Image.open(imagePath)
	except:
		pass
	if not keepProportionally:
		imgOut = img.resize((targetSize,targetSize),Image.ANTIALIAS)
	else:
		w,h = img.size
		propor = w/h 
		if propor == 1:
			imgOut = img.resize((targetSize,targetSize))
		elif propor < 1:
			imgOut = img.resize((int(targetSize*w/h),targetSize))
		elif propor > 1:
			imgOut = img.resize((targetSize,int(targetSize*h/w)))
	img.close()
	imgTk = ImageTk.PhotoImage(imgOut)
	return imgTk

photoPathShort = '.\\'

def showPhotos(photoList,title = 'cat'):
	window = tk.Tk()
	window.title(title)
	window.geometry('1050x1050')
	canvas = tk.Canvas(window, bg='gray', width=1050,height=1050)
	canvas.pack()
	index = 0
	imgList = []
	for i in range(5):
		for j in range(5):
			imgPath = photoList[index]
			imgList.append(toSquare(photoPathShort+imgPath,200,True))
			canvas.create_image(j*210, i*210, anchor='nw',image=imgList[index])
			# time.sleep(0.1)
			print(imgPath)
			index += 1
	window.mainloop()