import time
import random
import numpy as np

randomChar = '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM'

def updateGeneration():
    # 生成一个更新的generation
    generationPath = r'X:\Work_Py\CloudComputing\generation.txt'
    now = time.strftime('[%Y-%m-%d %H:%M:%S]:',time.localtime())
    
    with open(generationPath,'r+',encoding='utf-8') as f:
        a = f.readlines()
        lastTimeGeneration = int(a[-1].split(']:')[1])
        f.write('\n'+now+str(lastTimeGeneration+1))
    return lastTimeGeneration
lastTimeGeneration = updateGeneration()

def randomStr(length):
    # 生成一个长度为length的包含数字和字母大小写的随机字符串
    s = ''
    for i in range(length):
        s += randomChar[random.randint(0,61)]
    return s

class EndPointState():
    # 节点状态类
    def __init__(self,n):
        self.name = n
        self.generation = lastTimeGeneration+1
        self.version = 0
        self.load_information = [0,self.generation,0]
        self.normal = [randomStr(15),self.generation,0]
        # applicationState 使用了引用对象，因此不需要手动更新
        self.applicationState = {'load-information':self.load_information,'normal':self.normal}
        # heartBeatState 需要手动更新
        self.heartBeatState = {'generation':self.generation,'version':self.version}
    
    def __str__(self):
        return '''EndPointState {}
HeartBeatState:generation {}, version {}
ApplicationState "load-information":{}, generation {}, version {}
ApplicationState "normal":{}, generation {}, version {}'''.format(self.name,
                                                self.heartBeatState['generation'],self.heartBeatState['version'],
                                                self.load_information[0],self.load_information[1],self.load_information[2],
                                                self.normal[0],self.normal[1],self.normal[2])
    
    def getShortState(self):
        # 获取短些的状态，上面的str则是获取完整显示的状态
        return (self.name,self.generation,self.version)
    
    def getShortStateStr(self):
        # 获取一个生成好的字符串
        return '{}:{}:{}'.format(self.name,self.generation,self.version)
    
    def versionAdd1(self): 
        # 这是个历史遗留方法
        self.update('version',1)
        
    def update(self,who,what=-1,father=''):
        # 根据传入的参数指定状态进行更新
        # 可手动更新的有 'generation','load-information','normal',不建议手动更新'version',更新负载信息时还需传入值
        if who == 'generation':
            father.doingWhat('new generation')
            self.generation = updateGeneration()+1
            self.load_information[1] = self.generation
            self.normal[1] = self.generation
            #self.applicationState = {'load-information':self.load_information,'normal':self.normal}
            self.heartBeatState['generation'] = self.generation
        elif who == 'version':
            self.version += 1
            self.heartBeatState['version'] = self.version
        elif who == 'load-information' and (what != -1): # 更新负载会更新负载对应的版本以及总的版本
            father.doingWhat('load-information changed. {} -> {}'.format(self.load_information[0],what))
            self.load_information[0] = what
            self.load_information[2] += 1
            self.update('version',father='')
        elif who == 'normal': # 更新普通会更新普通对应的版本以及总的版本
            father.doingWhat('normalizing...')
            self.normal[0] = randomStr(15)
            self.normal[2] += 1
            self.update('version',father='')

class Node():
    nodes = []
    frames = 0    

    def __init__(self,name): 
        self.endPointState = EndPointState(name)
        self.knownEndPointStates = {name:self.endPointState}
        self.x = 0
        self.y = 0
        self.doing = 'Node created'
        Node.nodes.append(self)
        self.index = len(Node.nodes) - 1 # 此处暂时不能处理其他节点离开的情况
    
    @staticmethod
    def randomNode():
        # 静态方法，获取一个存在的已知Node实例
        return Node.nodes[random.randint(0,len(Node.nodes)-1)]

    def randomUpdate(self):
        # 随机更新一个状态
        self.updateWhat = ['generation','normal','load-information']
        rand = random.randint(0,2)
        self.updateEndPointState(self.updateWhat[rand],int(random.random()*1000)/10)
            
    def randomOtherNode(me):
        # 随机选择一个除自己以外的其他节点
        meIndex = me.index
        if len(Node.nodes) <= 1:
            return None
        rand = meIndex
        while (rand == meIndex):
            rand = random.randint(0,len(Node.nodes)-1)
        return Node.nodes[rand]
    
    def setXY(self,x,y):
        self.x = x
        self.y = y
        return self.x,self.y
    
    def setRandomXY(self,x,y): 
        # 传入的x和y都应该是元组，表示范围的
        self.x = random.randint(*x)
        self.y = random.randint(*y)
        return self.x,self.y
    
    def doingWhat(self,what):
        self.doing = what
    
    def __str__(self):
        # 对自己str可获得自己的名字
        return self.endPointState.name

    def printKnownEndPointStates(self,printState = True):
        '''
        直接用文字输出已知节点视图
        v0.1.1更新：可选择是否输出，最终都会返回字符串
        
        '''
        strTemp = 'Node {}\n'.format(str(self))
        #print('Node',str(self))
        for key in self.knownEndPointStates.keys():
            ## print('Node',key)
            # print(self.knownEndPointStates.get(key))
            strTemp += str(self.knownEndPointStates.get(key)) + '\n'
        #print()
        if printState:
            print(strTemp)
        return strTemp
    
    def updateSelfStateVersion(self):
        self.endPointState.versionAdd1()
        self.knownEndPointStates[self.endPointState.name] = self.endPointState
    
    def updateEndPointState(self,who,what=-1): 
        # 更新自己的属性后，也要顺便更新自己的视图
        self.endPointState.update(who, what,self)
        self.knownEndPointStates[self.endPointState.name] = self.endPointState
    
    def updateState(self,message):
        # 根据收到的节点状态视图来更新自己的视图
        # message为收到的视图 {name1:EndPointState1,name2:EndPointState2,...}
        newer = [str(self),]
        for key in message.keys():
            messValue = message[key] # messValue is EndPointState
            knownStateValue = self.knownEndPointStates.get(key)
            if knownStateValue:
                localVersion = knownStateValue.version
                remoteVersion = messValue.version
                localGeneration = knownStateValue.generation
                remoteGeneration = messValue.generation
                if (localVersion == remoteVersion) and (localGeneration == remoteGeneration):
                    continue
                elif (localGeneration < remoteGeneration):
                    self.knownEndPointStates[key] = messValue
                elif (localGeneration > remoteGeneration):
                    newer.append(key)
                    continue
                elif (localGeneration == remoteGeneration):
                    if(localVersion < remoteVersion):
                        self.knownEndPointStates[key] = messValue
                    else:
                        newer.append(key)
            else:
                self.knownEndPointStates[key] = messValue
        return newer
    
    def shortKnownEndPointStates(self,longer=[]):
        shortStr = ''
        for key in self.knownEndPointStates.keys():
            # print('Node',key)
            if key in longer:
                shortStr += str(self.knownEndPointStates.get(key)) + '\n'
            else:
                shortStr += self.knownEndPointStates.get(key).getShortStateStr() + '\n'
        return shortStr
    
    def gossipDigestSynMessage(self,toWho,tsuduku=True):
        self.updateEndPointState('version') # 每次发起同步前需要更新自己的版本号
        self.doingWhat('synchronizing...')
        fromWho = self
        message = self.knownEndPointStates
        print('节点:{} 发送了一条消息给节点:{} 试图开始同步 '.format(str(fromWho),str(toWho)))
        if tsuduku:
            toWho.gossipDigestAckMe(fromWho,message)
        else:
            return self.shortKnownEndPointStates()
    
    def gossipDigestAckMe(self,fromWho,message,tsuduku=True):
        self.doingWhat('synchronizing...')
        print('节点:{} 收到了一条来自 {} 的消息, 更新了自己的视图并发回了另一条消息'.format(self,fromWho))
        newer = self.updateState(message)
        self.doingWhat('synchronize successfully')
        if tsuduku:
            fromWho.gossipDigestAck2Mes(self.knownEndPointStates)
        else:
            return self.shortKnownEndPointStates(newer)
    
    def gossipDigestAck2Mes(self,updatedStates):
        print('节点:{} 收到了一条含有更新内容的消息\n'.format(self))
        newer = self.updateState(updatedStates)
        self.doingWhat('synchronize successfully')
        return self.shortKnownEndPointStates(newer)
    
    def generateAnimation(self,what='gossip',frames=60):
        # 生成动画（所需的数组），建议frames值为 4 的倍数
        if what == 'randomUpdate':
            Node.frames += frames
            xSynMessage = np.linspace(0,0,int(frames))
            ySynMessage = np.linspace(0,0,int(frames))
            nodesDoingWhat = [[],[],[],[]]
            nodesKnownState = [[],[],[],[]]
            synMessage = []
            for i in range(int(frames / 2)):
                synMessage.append('')
                for a in range(len(Node.nodes)):
                    nodesDoingWhat[a].append('randomly update a state..')
                    nodesKnownState[a].append('')
            Node.randomNode().randomUpdate()
            for a in range(len(Node.nodes)):
                nodesKnownState[a][-1] = Node.nodes[a].printKnownEndPointStates(False)
            for i in range(int(frames / 2)):
                synMessage.append('')
                for a in range(len(Node.nodes)):
                    nodesDoingWhat[a].append(Node.nodes[a].doing)
                    nodesKnownState[a].append('')
        if what == 'create':
            pass
        if what == 'gossip':
            Node.frames += frames * 3.5
            toWho = self.randomOtherNode()
            xTemp = np.linspace(self.x,toWho.x,frames)
            yTemp = np.linspace(self.y,toWho.y,frames)
            xSynMessage = np.append(np.append(np.append(xTemp,np.flip(xTemp)),xTemp),np.linspace(0,0,int(frames/2)))
            ySynMessage = np.append(np.append(np.append(yTemp,np.flip(yTemp)),yTemp),np.linspace(0,0,int(frames/2)))
            nodesDoingWhat = [[],[],[],[]]
            nodesKnownState = [[],[],[],[]]
            synMessage = []
            shortMess = self.gossipDigestSynMessage(toWho,False)
            for i in range(len(Node.nodes)):
                nodesKnownState[i].append(Node.nodes[i].printKnownEndPointStates(False))
            for i in range(frames):
                synMessage.append(shortMess)
                for a in range(len(Node.nodes)):
                    if a == self.index:
                        nodesDoingWhat[a].append('synchronizing...')
                        nodesKnownState[a].append('')
                    else:
                        nodesDoingWhat[a].append(Node.nodes[a].doing)
                        nodesKnownState[a].append('')
                #nodesDoingWhat[toWho.index].append('synchronizing...')
            shortMess = toWho.gossipDigestAckMe(self,self.knownEndPointStates,False)
            for i in range(len(Node.nodes)):
                nodesKnownState[i][-1] = Node.nodes[i].printKnownEndPointStates(False) # 此处是替换最后一个元素，而不是append，否则会多出3个元素
            for i in range(frames):
                synMessage.append(shortMess)
                for a in range(len(Node.nodes)):
                    if (a == self.index) or (a == toWho.index):
                        nodesDoingWhat[a].append('synchronizing...')
                        nodesKnownState[a].append('')
                    else:
                        nodesDoingWhat[a].append(Node.nodes[a].doing)
                        nodesKnownState[a].append('')
            shortMess = self.gossipDigestAck2Mes(toWho.knownEndPointStates)
            for i in range(len(Node.nodes)):
                nodesKnownState[i][-1] = Node.nodes[i].printKnownEndPointStates(False)
            for i in range(frames):
                synMessage.append(shortMess)
                for a in range(len(Node.nodes)):
                    if (a == self.index):
                        nodesDoingWhat[a].append('synchronize successfully')
                        nodesKnownState[a].append('')
                    elif (a == toWho.index):
                        nodesDoingWhat[a].append('synchronizing...')
                        nodesKnownState[a].append('')
                    else:
                        nodesDoingWhat[a].append(Node.nodes[a].doing)
                        nodesKnownState[a].append('')
            for i in range(len(Node.nodes)):
                nodesKnownState[i][-1] = Node.nodes[i].printKnownEndPointStates(False)
            for i in range(int(frames/2)):
                synMessage.append('')
                for a in range(len(Node.nodes)):
                    if (a == self.index) or (a == toWho.index):
                        nodesDoingWhat[a].append('synchronize successfully')
                        nodesKnownState[a].append('')
                    else:
                        nodesDoingWhat[a].append(Node.nodes[a].doing)
                        nodesKnownState[a].append('')
        return synMessage,xSynMessage,ySynMessage,np.array(nodesDoingWhat),np.array(nodesKnownState)

def testUpdateStates():
    node1 = Node('10.0.0.1')
    node1.printKnownEndPointStates()
    node1.updateEndPointState('load-information',1.2)
    node1.printKnownEndPointStates()
    node1.updateEndPointState('generation')
    node1.printKnownEndPointStates()
    node1.updateEndPointState('normal')
    node1.printKnownEndPointStates()

def testGossip():
    node1 = Node('10.0.0.1')
    node2 = Node('10.0.0.2')
    node1.printKnownEndPointStates()
    node2.printKnownEndPointStates()
    node1.gossipDigestSynMessage(node1.randomOtherNode())
    node1.printKnownEndPointStates()
    node2.printKnownEndPointStates()
    node2.gossipDigestSynMessage(node2.randomOtherNode())
    node1.printKnownEndPointStates()
    node2.printKnownEndPointStates()

def testGenerateAnimation():
    node1 = Node('10.0.0.1')
    node2 = Node('10.0.0.2')
    node3 = Node('10.0.0.3')
    node4 = Node('10.0.0.4')
    node1.printKnownEndPointStates()
    a,b,c,d,e = node1.generateAnimation()
    node1.printKnownEndPointStates()
    return a,b,c,d,e
    
if __name__ == '__main__':
    # testUpdateStates()
    # testGossip()
    a,b,c,d,e = testGenerateAnimation()