import time
import random

randomChar = '0123456789qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM'

def updateGeneration():
    generationPath = r'X:\Work_Py\CloudComputing\generation.txt'
    now = time.strftime('[%Y-%m-%d %H:%M:%S]:',time.localtime())
    
    with open(generationPath,'r+',encoding='utf-8') as f:
        a = f.readlines()
        lastTimeGeneration = int(a[-1].split(']:')[1])
        f.write('\n'+now+str(lastTimeGeneration+1))
    return lastTimeGeneration
lastTimeGeneration = updateGeneration()

def randomStr(length):
    s = ''
    for i in range(length):
        s += randomChar[random.randint(0,61)]
    return s

class EndPointState():
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
        return (self.name,self.generation,self.version)
    
    def versionAdd1(self): # 这是个历史遗留方法
        self.update('version',1)
        
    def update(self,who,what=-1):
        if who == 'generation':
            self.generation = updateGeneration()+1
            self.load_information[1] = self.generation
            self.normal[1] = self.generation
            #self.applicationState = {'load-information':self.load_information,'normal':self.normal}
            self.heartBeatState['generation'] = self.generation
        elif who == 'version':
            self.version += 1
            self.heartBeatState['version'] = self.version
        elif who == 'load-information' and (what != -1): # 更新负载会更新负载对应的版本以及总的版本
            self.load_information[0] = what
            self.load_information[2] += 1
            self.update('version')
        elif who == 'normal': # 更新普通会更新普通对应的版本以及总的版本
            self.normal[0] = randomStr(15)
            self.normal[2] += 1
            self.update('version')

class Node():
    def __init__(self,name): 
        self.endPointState = EndPointState(name)
        self.knownEndPointStates = {name:self.endPointState}
    
    def __str__(self):
        return self.endPointState.name
    
    def printKnownEndPointStates(self):
        print('Node',str(self))
        for key in self.knownEndPointStates.keys():
            # print('Node',key)
            print(self.knownEndPointStates.get(key))
        print()
    
    def updateSelfStateVersion(self):
        self.endPointState.versionAdd1()
        self.knownEndPointStates[self.endPointState.name] = self.endPointState
    
    def updateEndPointState(self,who,what=-1): # 更新自己的属性后，也要顺便更新自己的视图
        self.endPointState.update(who, what)
        self.knownEndPointStates[self.endPointState.name] = self.endPointState
    
    def updateState(self,message):
        # 根据收到的节点状态视图来更新自己的视图
        # message为收到的视图 {name1:EndPointState1,name2:EndPointState2,...}
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
                    continue
                elif (localGeneration == remoteGeneration):
                    if(localVersion < remoteVersion):
                        self.knownEndPointStates[key] = messValue
            else:
                self.knownEndPointStates[key] = messValue
    
    
    def gossipDigestSynMessage(self,toWho):
        self.updateEndPointState('version') # 每次发起同步前需要更新自己的版本号
        fromWho = self
        message = self.knownEndPointStates
        print('node:{} sent a message: to {} to try to syn the states'.format(str(fromWho),str(toWho)))
        toWho.gossipDigestAckMe(fromWho,message)
    
    def gossipDigestAckMe(self,fromWho,message):
        print('node:{} received a message from {}, updated self.s states and send another message back'.format(self,fromWho))
        self.updateState(message)
        fromWho.gossipDigestAck2Mes(self.knownEndPointStates)
    
    def gossipDigestAck2Mes(self,updatedStates):
        print('node:{} received a message from ?, which have been updated\n'.format(self))
        self.updateState(updatedStates)

node1 = Node('10.0.0.1')
node2 = Node('10.0.0.2')
node1.printKnownEndPointStates()
node1.updateEndPointState('load-information',1.2)
node1.printKnownEndPointStates()
node1.updateEndPointState('generation')
node1.printKnownEndPointStates()
node1.updateEndPointState('normal')
node1.printKnownEndPointStates()
# node2.printKnownEndPointStates()
# node1.gossipDigestSynMessage(node2)
# node1.printKnownEndPointStates()
# node2.printKnownEndPointStates()
# node2.gossipDigestSynMessage(node1)
# node1.printKnownEndPointStates()
# node2.printKnownEndPointStates()