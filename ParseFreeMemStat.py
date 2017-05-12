import subprocess
from shutil import copyfile
import sys
import time
import socket
import datetime

def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")

def addToFreeMemFile(line):
  with open("freeMemData.txt", "a") as myfile:
    myfile.write(line)

def skipLines(process, lines):
    i = 0
    for line in process.stdout:
       s = line.decode('utf-8')
       i += 1
       if i == lines:
         break

def extract_line(s):
  line = s[11:22].strip() + '|' + s[23:33].strip() + '|' + s[35:45].strip() + '|' \
             + s[48:56].strip() + '|' + s[58:67].strip() + '|' + s[70:80].strip() 
  return line
  

def processMemLine(s):
  line = extract_line(s)
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + "mem" + "|" + line
  #print(line)
  addToFreeMemFile(line +  "\n")

def processSwapLine(s):
  line = extract_line(s)
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + "swap" + "|" + line
  #print(line)
  addToFreeMemFile(line +  "\n")


def GetFreeMemStat():
    try:
       while True:
           command = ['free']
           process = subprocess.Popen(command, stdout=subprocess.PIPE)
           skipLines(process,1)
           # Read free first line
           s = process.stdout.readline().decode('utf-8')
           processMemLine(s) 
           s = process.stdout.readline().decode('utf-8')
           processSwapLine(s) 
           time.sleep(.4)
           process.terminate()

    except KeyboardInterrupt:
       pass
    return

printMessage("Calling GetFreeMemStat()")
GetFreeMemStat()






