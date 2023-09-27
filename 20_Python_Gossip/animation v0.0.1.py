import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import matplotlib.animation as animation

fig = plt.figure(tight_layout=False,figsize=(20,15),dpi=72)
text_pt = plt.text(0,0, '''EndPointState 10.0.0.1
HeartBeatState:generation 50, version 0
ApplicationState "load-information":0, generation 50, version 0
ApplicationState "normal":sCm3vri4RIBAnrU, generation 50, version 0''', fontsize=12,
                   verticalalignment='top',
                   horizontalalignment='left',
                   bbox={'boxstyle':'square','facecolor':'#ffffff',})
text_pt2 = plt.text(15,30, 'test', fontsize=12,
                   verticalalignment='top',
                   horizontalalignment='left',
                   bbox={'boxstyle':'square','facecolor':'#ffffff',})

ax1 = fig.add_subplot(1,1,1)
ax1.axis([-50,50,-50,50])
markers = '.,ov^<>12348sp*hH+xDd\"-'

# point_ani, = plt.plot(x[0], y[0], "ro")
xStart = 0
yStart = 0
xEnd = 15
yEnd = 30
x = np.linspace(xStart,xEnd,400)
y = np.linspace(yStart,yEnd,400)

ax1.scatter((xStart),(yStart),s=150,marker='1') 
ax1.scatter((xEnd),(yEnd),s=180,marker='1') 

#point_ani, = plt.scatter((xStart,xEnd),(yStart,yEnd))

def update_points(num):
    #point_ani.set_data(x[num], y[num])
    text_pt.set_position((x[num], y[num]))
    text_pt2.set_text(num)
    return text_pt,

ani = animation.FuncAnimation(fig, update_points, np.arange(0, 400), interval=10, blit=True)
ani.save('d:\\testOut.gif', writer='imagemagick', fps=30)
