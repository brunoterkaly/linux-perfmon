import subprocess
from shutil import copyfile
import sys
import socket 
import datetime

two_d_array = []
nbr_netcards = 0
rows_count = 1

def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def addToNetworkFile(line):
  with open("networkData.txt", "a") as myfile:
    myfile.write(line+"\n")

def addToLogFile(line):
  with open("logData.txt", "a") as myfile:
    myfile.write(line+"\n")

def parseHeader(s):
    global two_d_array
    global nbr_netcards
    global rows_count
    # count the first row columns (equals network cards)
    nbr_netcards = count_cols(s)
    two_d_array = [[0 for j in range(nbr_netcards*2)] for i in range(rows_count)]
    two_d_array[0][0] = s[11:28].strip() + "|kbps_in"
    two_d_array[0][1] = s[11:28].strip() + "|kbps_out"
    two_d_array[0][2] = s[31:48].strip() + "|kbps_in"
    two_d_array[0][3] = s[31:48].strip() + "|kbps_out"
    two_d_array[0][4] = s[51:68].strip() + "|kbps_in"
    two_d_array[0][5] = s[51:68].strip() + "|kbps_out"
    two_d_array[0][6] = s[71:88].strip() + "|kbps_in"
    two_d_array[0][7] = s[71:88].strip() + "|kbps_out"
    two_d_array[0][8] = s[91:108].strip() + "|kbps_in"
    two_d_array[0][9] = s[91:108].strip() + "|kbps_out"

def count_cols(s):
     s2 = s.split()
     return len(s2) - 1



def parseLine(s):
     #addToLogFile(s)
     return (s[0:8].strip() + '|' + \
     s[11:19].strip() + '|' + \
     s[20:28].strip() + '|' + \
     s[31:38].strip() + '|' + \
     s[40:48].strip() + '|' + \
     s[51:58].strip() + '|' + \
     s[60:68].strip() + '|' + \
     s[71:78].strip() + '|' + \
     s[80:88].strip() + '|' + \
     s[91:98].strip() + '|' + \
     s[100:108].strip() + '').replace("\n","")

def GetIfStat():
    global two_d_array
    global nbr_netcards
    # Get running containers
    command = ['ifstat', '-bt']
    process = subprocess.Popen(command, stdout=subprocess.PIPE)

    # header 1
    l1 = process.stdout.readline().decode('utf-8')
    parseHeader(l1)

    # header 2
    l2 = process.stdout.readline().decode('utf-8')
    parseLine(l2)

    try:
        while(True):
           s = process.stdout.readline().decode('utf-8')
           #addToLogFile(s)
           if (s.find("Time") != -1 or  s.find("HH:MM") != -1):
              #print(s)
              #print("found bad")
              continue
           #else:
              #print("found good")
           data = parseLine(s)
           data = data.split("|")
           new_row = socket.gethostname() + "|" + (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
           for j in range(0,nbr_netcards*2,2):
              new_row = socket.gethostname() + "|" + (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
              val = data[j+1]
              #if not is_number(val):
                 #print(s)
                 #print(val)
                 #exit()
              val = data[j+2]
              #if not is_number(val):
              #   print(s)
              #   print(val)
              #   exit()

              #print(data[j+1])
              new_row = new_row + "|" + two_d_array[0][j] + "|" + data[j+1]
              #print(new_row)
              addToNetworkFile(new_row)
              new_row = socket.gethostname() + "|" + (datetime.datetime.now()).strftime("%Y-%m-%d %H:%M:%S.%f")[:-3]
              new_row = new_row + "|" + two_d_array[0][j+1] + "|" + data[j+2]
              #print(new_row)
              addToNetworkFile(new_row)
    except KeyboardInterrupt:
        pass
    process.terminate()
    return

printMessage("Calling GetIfStat()")
GetIfStat()




    # print network cards
    #print("network cards = ", count_cols(s))
    # print whole row for fun
    #print(s)
    # for i in range(len(two_d_array)):
    #    for j in range(len(two_d_array[i])):
    #       print(two_d_array[i][j])
    #  Time           eth0              docker0         docker_gwbridge     br-38f536ce9fd0       veth56b7b43
    #1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
