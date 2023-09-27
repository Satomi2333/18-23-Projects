import time

generationPath = r'X:\Work_Py\CloudComputing\generation.txt'
now = time.strftime('[%Y-%m-%d %H:%M:%S]:',time.localtime())

with open(generationPath,'r+',encoding='utf-8') as f:
    a = f.readlines()
    lastTimeGeneration = int(a[-1].split(']:')[1])
    f.write('\n'+now+str(lastTimeGeneration+1))


class EndPointState():
    def __init__(self,n):
        self.name = n
        self.applicationState = dict()
        self.generation = lastTimeGeneration+1
        self.version = 0
        self.heartBeatState = {'generation':self.generation,'version':self.version}
    def __str__(self):
        return "EndPointState {}\nHeartBeatState:generation {},version {}\nApplicationState ''".format(self.name,self.heartBeatState['generation'],self.heartBeatState['version'])
    def getShortState(self):
        return (self.name,self.generation,self.version)

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
            
    def updateState(self,message):
        for key in message.keys():
            messValue = message[key]
            if self.knownEndPointStates.get(key):
                pass
            else:
                self.knownEndPointStates[key] = messValue
                
    
    def gossipDigestSynMessage(self,fromWho,toWho):
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
node2.printKnownEndPointStates()
node1.gossipDigestSynMessage(node1,node2)
node1.printKnownEndPointStates()
node2.printKnownEndPointStates()