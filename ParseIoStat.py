import subprocess
from shutil import copyfile
import sys
import time
import socket
import datetime

got_header = False

def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")

def addToCpuFile(line):
  with open("cpuData.txt", "a") as myfile:
    myfile.write(line)

def addToDiskFile(line):
  with open("diskioData.txt", "a") as myfile:
    myfile.write(line)


def skipLines(process, lines):
    i = 0
    for line in process.stdout:
       s = line.decode('utf-8')
       i += 1
       if i == lines:
         break

def processCpuLine(s):
  global got_header 
  line = s[10:15].strip() + '|' + s[18:24].strip() + '|' + s[26:32].strip() + \
     '|' + s[35:39].strip() + '|' + s[43:48].strip() + '|' + s[50:55].strip() 
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + line
  addToCpuFile(line +  "\n")

def processDataLine(s):
  if not s or not s.strip():
    return False;
  line = s[0:7].strip() + '|' + s[17:23].strip() + '|' + s[26:35].strip() + '|' + \
     s[39:48].strip() + '|' + s[52:59].strip() + '|' + s[63:70].strip() 
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + line
  #print(line)
  addToDiskFile(line +  "\n")
  return True


def GetIoStat():
    try:
       while True:
           # Get running containers
           command = ['iostat']
           process = subprocess.Popen(command, stdout=subprocess.PIPE)
           #print("Calling iostat")
           skipLines(process, 3)
           # print avg cpu
           # Just read 1 line
           i = 0
           while(i < 1):
              # read header
              s = process.stdout.readline().decode('utf-8')
              processCpuLine(s)
              i += 1
           skipLines(process, 2)
           while(True):
              s = process.stdout.readline().decode('utf-8')
              if processDataLine(s) == False:
                break
           time.sleep(.4)
           process.terminate()
    except KeyboardInterrupt:
       pass
    return

printMessage("Calling GetIoStat()")
GetIoStat()
#          1         2         3         4         5         6         7         8
#0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123
#Linux 4.4.0-59-generic (mydatastore) 	04/07/2017 	_x86_64_	(2 CPU)
#
#avg-cpu:  %user   %nice %system %iowait  %steal   %idle
#           0.41    0.00    0.25    0.31    0.00   99.04
#
#Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
#fd0               0.00         0.00         0.00          4          0
#sda               2.23         6.65        21.55    1118421    3623352
#sdb               0.00         0.03         0.00       5220          0
#sdc               0.02         0.13         0.02      21341       2868






