import subprocess
from shutil import copyfile
import re
import sys
import time
import socket
import datetime

need_to_add_0 = True

def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")


def addToTopFile(line):
  with open("ioTopData.txt", "a") as myfile:
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
  global need_to_add_0
  line = extract_line(s)
  # print(len(line), line)

  # deleting empty cells in the beginning
  while line and not line[0]:
    line = line[1:]

  if not line:
    return True
  if line[3].strip() == "0.00" and line[5].strip() == "0.00":
    if not need_to_add_0:
      return False
    need_to_add_0 = False
  else:
    need_to_add_0 = True

  line.pop(8)
  line.pop(10)
  command = " ".join(line[9:])
  line = line[:9]
  line.append(command)
  line = '|'.join(line)
  currtime = (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
  line = socket.gethostname() + '|' + currtime + '|' + line
  #print(line)
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

