import subprocess
from shutil import copyfile
import re
import sys
import time
import socket
import datetime

call_count = 1
last_read_good = 0

def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")


def addToTopFile(line):
  with open("topData.txt", "a") as myfile:
    myfile.write(line)

def skipLinesUntilToken(process, token):
    i = 0
    for line in process.stdout:
       s = line.decode('utf-8')
       i += 1
       if s.find(token) != -1:
         break;

def extract_line(s):
  s = re.sub('\x1b[^m]*m', '', s)
  s = re.sub(r'\x1b\[([0-9,A-Z]{1,2}(;[0-9]{1,2})?(;[0-9]{3})?)?[m|K]?', '', s)
  sep = re.compile('[\s]+')
  #addToTopFile(s)
  s = sep.split(s)
  del s[-1]
  return s

def foundNonZero(s):
  line = extract_line(s)
  if line[9].strip() == "0.0":
     return False
  else:
     return True
  
def writeLine(s):
  line = extract_line(s)
  line = '|'.join(line)
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + line
  addToTopFile(line +  "\n")


  

def GetTopStat():
    global last_read_good
    try:
       while True:
           last_read_good = 0
           command = ['top', '-b', '-n1']
           process = subprocess.Popen(command, stdout=subprocess.PIPE)
           skipLinesUntilToken(process,"PID USER")
           while True:
              s = process.stdout.readline().decode('utf-8')
              if foundNonZero(s):
                 writeLine(s)
                 continue
              else:
                 writeLine(s)
              
              # got here, because we printed 0
              # so start over by breaking out of loop
              time.sleep(.4)
              # break out of inner loop
              break
              process.terminate()
    except KeyboardInterrupt:
       pass
    return

printMessage("Calling GetTopStat()")
GetTopStat()

# FOR STATUS
#'D' = uninterruptible sleep
#'R' = running
#'S' = sleeping
#'T' = traced or stopped
#'Z' = zombie
# top - 15:25:41 up 17 days, 12:35,  2 users,  load average: 2.86, 0.89, 0.31
# Tasks: 180 total,   5 running, 175 sleeping,   0 stopped,   0 zombie
# %Cpu(s):  0.6 us,  0.3 sy,  0.0 ni, 98.8 id,  0.3 wa,  0.0 hi,  0.0 si,  0.0 st
# KiB Mem :  7134452 total,  2317752 free,  1459452 used,  3357248 buff/cache
# KiB Swap:        0 total,        0 free,        0 used.  5323476 avail Mem


# 12345678901234567890123456789012345678901234567890123456789012345678901234567890
#   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
#   61147 root      20   0   12984   1960      0 R  56.2  0.0   0:36.86 bash
#   61146 root      20   0   12984   1960      0 R  50.0  0.0   0:36.83 bash

#   sql = "insert into top_data(" \
#   "hostname,timestamp,user_percent," \
#   "nice_percent,system_percent,iowait_percent," \
#   "steal_percent,idle_percent
#   ") values(" \
#   "'{0}','{1}',{2}," \
#   "{3},{4},{5}," \
#   "{6},{7}")".format( \
#   data[0],data[1],data[2], \
#   data[3],data[4],data[5], \
#   data[6],data[7]);
