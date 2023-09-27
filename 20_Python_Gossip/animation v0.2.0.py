import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation
import random
import time

import sys
sys.path.append(r'x:\work_py\3.x')
from gossip import *

'''
xNode1,yNode1,xNode2,yNode2: Node1,Node2...的xy坐标

已知所需的iter：

同步消息内容(text) synMessage ：来自 Node.shortKnownEndPointStates()
同步消息移动轨迹(x,y) xSynMessage, ySynMessage : 来自多个np.linspace(start,end,count)
节点正在做什么(text) nodesDoingWhat: 'node {name1}: {doingWhat}\n node2....'.format(Node.doingWhat()...)
节点的视图(text)node1KnownEndPointStates... : 来自 Node.printKnownEndPointStates()
    node1KnownEndPointStates这里有一个错误，本来是要使用4个变量来分别表示，但是写代码的第二天没有注意，于是使用了复合变量"node1KnownEndPointStates[0]",之后就不改了，免得牵一发动全身
'''

node1 = Node('10.0.0.1')
node2 = Node('10.0.0.2')
node3 = Node('10.0.0.3')
node4 = Node('10.0.0.4')

x1,y1 = node1.setRandomXY((-45,-30),(20,40))
x2,y2 = node2.setRandomXY((10,20),(20,40))
x3,y3 = node3.setRandomXY((-45,-30),(-40,-20))
x4,y4 = node4.setRandomXY((10,20),(-30,-10))

xNode = [x1,x2,x3,x4]
yNode = [y1,y2,y3,y4]

nodesDoingWhatStr = "node {}:{}     node {}:{}\nnode {}:{}     node {}:{}".format(str(node1),node1.doing, str(node2),node2.doing, str(node3),node3.doing, str(node4),node4.doing)
node1KnownEndPointStatesStr = [node1.printKnownEndPointStates(False),node2.printKnownEndPointStates(False),node3.printKnownEndPointStates(False),node4.printKnownEndPointStates(False)]

fig = plt.figure(tight_layout=False,figsize=(20,15),dpi=72)
ax1 = fig.add_subplot(1,1,1)
ax1.axis([-50,50,-50,50])
ax1.axis('off')
markers = '.,ov^<>12348sp*hH+xDd'

nodesDoingWhat = plt.text(-49,49,nodesDoingWhatStr,
                          fontsize=15,
                   verticalalignment='top',
                   horizontalalignment='left')

node1KnownEndPointStates = [plt.text(x1,y1,node1KnownEndPointStatesStr[0],fontsize=10,verticalalignment='top',horizontalalignment='left'),
                            plt.text(x2,y2,node1KnownEndPointStatesStr[1],fontsize=10,verticalalignment='top',horizontalalignment='left'),
                            plt.text(x3,y3,node1KnownEndPointStatesStr[2],fontsize=10,verticalalignment='top',horizontalalignment='left'),
                            plt.text(x4,y4,node1KnownEndPointStatesStr[3],fontsize=10,verticalalignment='top',horizontalalignment='left')
                           ]
synMessage = plt.text(0,0, '', fontsize=12,
                   verticalalignment='top',
                   horizontalalignment='left',
                   bbox={'boxstyle':'square','facecolor':'#ffffff',})

ax1.scatter(xNode,yNode,s=180,marker=markers[random.randint(0,len(markers)-1)]) 

synMessageStr,xSynMessage,ySynMessage,nodesDoingWhatStr,node1KnownEndPointStatesStr = node1.generateAnimation('gossip',120)
def moreAnimation(what='gossip'):
    t1,t2,t3,t4,t5 = Node.randomNode().generateAnimation(what,120)
    global synMessageStr,xSynMessage,ySynMessage,nodesDoingWhatStr,node1KnownEndPointStatesStr
    synMessageStr.extend(t1)
    xSynMessage = np.append(xSynMessage,t2)
    ySynMessage = np.append(ySynMessage,t3)
    nodesDoingWhatStr = np.concatenate((nodesDoingWhatStr,t4),axis=1)
    node1KnownEndPointStatesStr = np.concatenate((node1KnownEndPointStatesStr,t5),axis=1)
    
def update_points(num):
    synMessage.set_text(synMessageStr[num])
    synMessage.set_position((xSynMessage[num],ySynMessage[num]))
    nodesDoingWhat.set_text("node {}:{}\nnode {}:{}\nnode {}:{}\nnode {}:{}".format(str(node1),nodesDoingWhatStr[0][num], str(node2),nodesDoingWhatStr[1][num], str(node3),nodesDoingWhatStr[2][num], str(node4),nodesDoingWhatStr[3][num]))
    #nodesDoingWhat.set_text("node {}:{}     node {}:{}\nnode {}:{}     node {}:{}".format(str(node1),node1.doing, str(node2),node2.doing, str(node3),node3.doing, str(node4),node4.doing))
    if node1KnownEndPointStatesStr[0][num] != '':
        node1KnownEndPointStates[0].set_text(node1KnownEndPointStatesStr[0][num])
    if node1KnownEndPointStatesStr[1][num] != '':
        node1KnownEndPointStates[1].set_text(node1KnownEndPointStatesStr[1][num])
    if node1KnownEndPointStatesStr[2][num] != '':
        node1KnownEndPointStates[2].set_text(node1KnownEndPointStatesStr[2][num])
    if node1KnownEndPointStatesStr[3][num] != '':
        node1KnownEndPointStates[3].set_text(node1KnownEndPointStatesStr[3][num])
    
    '''node1KnownEndPointStates[0].set_text(node1KnownEndPointStatesStr[0][num])
    node1KnownEndPointStates[1].set_text(node1KnownEndPointStatesStr[1][num])
    node1KnownEndPointStates[2].set_text(node1KnownEndPointStatesStr[2][num])
    node1KnownEndPointStates[3].set_text(node1KnownEndPointStatesStr[3][num])'''
    return synMessage,nodesDoingWhat,node1KnownEndPointStates[0],node1KnownEndPointStates[1],node1KnownEndPointStates[2],node1KnownEndPointStates[3],

for i in range(10):
    if random.random() <= 0.3:
        moreAnimation('randomUpdate')
    else:
        moreAnimation('gossip')

ani = animation.FuncAnimation(fig, update_points, int(Node.frames), interval=10, blit=True)
#ani.save('d:\\testOut.gif', writer='imagemagick', fps=30)
