import subprocess
from shutil import copyfile
import sys
import os
import time
import socket
import datetime
import signal


def printMessage(s):
    print("--------------------------------------------------------")
    print("   ", s)
    print("--------------------------------------------------------")

def KillAll():
    printMessage("Finding running python scripts") 
    command = ['bash', './KillAll.sh']
    process = subprocess.Popen(command, stdout=subprocess.PIPE)
    while True:
        d = process.stdout.readline().decode('utf-8')
        if not d:
           break
        d = d.replace("\n","")
        print(d)
    process.terminate()


KillAll()

printMessage("Install Start importing process") 
commands = [ \
  ['python3', 'BulkImportDiskIo.py'], \
  ['python3', 'BulkImportCpu.py'], \
  ['python3', 'BulkImportNetwork.py'], \
  ['python3', 'BulkImportTop.py'], \
  ['python3', 'BulkImportIoTop.py'], \
  ['python3', 'BulkImportFreeMem.py'] \
]
printMessage("Running BulkImportDiskIo.py ...")
printMessage("Running BulkImportTop.py...")
printMessage("Running BulkImportIoTop.py...")
printMessage("Running BulkImportCpu.py ...")
printMessage("Running BulkImportNetwork.py...")
printMessage("Running BulkImportFreeMem.py ...")
for i in range(len(commands)):
  cmd = " ".join(commands[i])
  printMessage("Running...." + cmd)
  process = subprocess.Popen(commands[i], stdout=subprocess.PIPE)
  while True:
     s = process.stdout.readline().decode('utf-8')
     s = s.replace("\n","")
     if not s:
        break
     print(s)


"""
def killProcess(s):
    printMessage("Finding Running python scripts") 
    command = ['ps', 'aux']
    process = subprocess.Popen(command, stdout=subprocess.PIPE)
    while True:
        d = process.stdout.readline().decode('utf-8')
        d = d.replace("\n","")
        if not d:
           break
        myapp = d[65:].strip()
        mypid = d[9:15].strip()
        if myapp == s:
           print("myapp = ", myapp)
           print("mypid = ", mypid)
           os.kill(int(mypid), signal.SIGKILL)

#-------------------------------------------------------------


killProcess("python3 ParseIoStat.py")
"""



