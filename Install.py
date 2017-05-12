import subprocess
from shutil import copyfile
import sys
import time
import datetime


def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")

def installPyMsSql():
    try:
       # Now install pymssql
       printMessage("Install pymssql") 
       commands = [ \
          ['apt-get', '--assume-yes', 'update' ], \
          ['apt-get', '--assume-yes', 'install', 'freetds-dev', 'freetds-bin'], \
          ['apt-get', '--assume-yes', 'install', 'python-dev', 'python-pip'], \
          ['pip', 'install', 'pymssql'], \
       ]
       """
       for i in range(len(commands)):
          for j in range(len(commands[i])):
             print(commands[i][j])
          print()
       """
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
       process.terminate()

    except KeyboardInterrupt:
       pass
    return

def installIfStat():
    try:
      # Update first
       command = ['apt-get', 'update']
       process = subprocess.Popen(command, stdout=subprocess.PIPE)
       while True:
          s = process.stdout.readline().decode('utf-8')
          s = s.replace("\n","")
          if not s:
             break
          print(s)
       # Now install sysstat
       printMessage("Install ifstat") 
       command = ['apt-get', '--assume-yes', 'install','ifstat']
       process = subprocess.Popen(command, stdout=subprocess.PIPE)
       while True:
          s = process.stdout.readline().decode('utf-8')
          s = s.replace("\n","")
          if not s:
             break
          print(s)
    except KeyboardInterrupt:
       pass
    return


def installIoStat():
    try:
      # Update first
       command = ['apt-get', 'update']
       process = subprocess.Popen(command, stdout=subprocess.PIPE)
       while True:
          s = process.stdout.readline().decode('utf-8')
          s = s.replace("\n","")
          if not s:
             break
          print(s)
       # Now install sysstat
       printMessage("Install iostat") 
       command = ['apt-get', '--assume-yes', 'install','sysstat']
       process = subprocess.Popen(command, stdout=subprocess.PIPE)
       while True:
          s = process.stdout.readline().decode('utf-8')
          s = s.replace("\n","")
          if not s:
             break
          print(s)
    except KeyboardInterrupt:
       pass
    return




print("Installing Python on Ubuntu")
installIoStat()
installIfStat()
installPyMsSql()






