import os
import sys

if sys.platform == "win32":
    DATABASE = "./database/MyDay.db"
    DOWNLOADPATH = "../bili"
elif sys.platform == "linux":
    DATABASE = "./database/MyDay.db"
    DOWNLOADPATH = "../bili"
