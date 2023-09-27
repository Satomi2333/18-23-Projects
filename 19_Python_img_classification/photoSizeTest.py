
outPutFile = r'.\\testExif.txt'

with open(outPutFile,'r',encoding = 'utf-8') as f:
	string = f.read()
myDict = eval(string)

keys = myDict.keys()

for key in keys:
	if (a,b) = myDict.get(key).get('size'):
		# print(key)
		s = a * b
		if s <= 10000:
			myDict[key]['size_type'] = 'tiny small'
		elif s <= 40000:
			myDict[key]['size_type'] = 'small'
		elif s <= 500000:
			myDict[key]['size_type'] = 'tiny middle'
		elif s <= 1000000:
			myDict[key]['size_type'] = 'middle'
		elif s <= 4000000:
			myDict[key]['size_type'] = 'large'
		elif s > 4000000:
			myDict[key]['size_type'] = 'super large'
		
		if (a>0 and b>0):
			t = a/b
		if (t<0.33 or t>3):
			myDict[key]['widthHeight_type'] = 'panoramas'
		elif (t<0.2 or t>5):
			myDict[key]['widthHeight_type'] = 'super panoramas'
		elif t == 1:
			myDict[key]['widthHeight_type'] = 'square'
		