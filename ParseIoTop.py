import subprocess
from shutil import copyfile
import re
import sys
import time
import socket
import datetime

call_count = 1

def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")


def addToTopFile(line):
  with open("IOtopData.txt", "a") as myfile:
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

def processTopLine(s):
  global call_count
  call_count += 1
  line = extract_line(s)
  # means that there are no more PIDs to track
  #print(s.replace("\n",""))
  #print(str(len(line)))
  # print(len(line), line)

  # deleting empty cells in the beginning
  while line and not line[0]:
    line = line[1:]

  if not line:
    return True
  # print(len(line), line[3], line[5], line)
  if line[3].strip() == "0.00" and line[5].strip() == "0.00":
        return False

  line.pop(8)
  line.pop(10)
  command = " ".join(line[9:])
  line = line[:9]
  line.append(command)
  line = '|'.join(line)
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + line
  print(line)
  #exit()
  addToTopFile(line +  "\n")
  return True


def GetIoTopStat():
    try:
       while True:
           command = ['iotop', '-b', '-n1']
           process = subprocess.Popen(command, stdout=subprocess.PIPE)
           skipLinesUntilToken(process,"TID")
           while True:
              s = process.stdout.readline().decode('utf-8')
              if not processTopLine(s):
                 break
           time.sleep(.4)
           process.terminate()
    except KeyboardInterrupt:
       pass
    return

printMessage("Calling GetIoTopStat()")
GetIoTopStat()

