import pymssql  
import os


def DelFile(f):
  if os.path.exists(f):
     try:
       printMessage("deleting " + f)
       #os.chmod(f, 0o777)
       os.unlink(f)
     except:
       print("Error encountered")
       print("OS error: {0}".format(err))
       raise # re-raise exception if a different error occurred


def printMessage(s):
  print("--------------------------------------------------------")
  print("   ", s)
  print("--------------------------------------------------------")

# Connect to the database
def GetConnectionString():
   file = open("./connectionstring.txt", "r")
   s = file.read().replace("\n","")
   d = dict(item.split(":") for item in s.split(","))
   return d

# Connect to the database
connectionString = GetConnectionString()
conn = pymssql.connect(host=connectionString["host"], user=connectionString["user"],
        password=connectionString["password"], database=connectionString["database"])

cursor = conn.cursor()  

printMessage('delete from dbo.cpu_data')
cursor.execute('delete from dbo.cpu_data')

printMessage('delete from dbo.disk_io_data')
cursor.execute('delete from dbo.disk_io_data')

printMessage('delete from dbo.free_mem_data')
cursor.execute('delete from dbo.free_mem_data')

printMessage('delete from dbo.network_data')
cursor.execute('delete from dbo.network_data')

printMessage('delete from dbo.top_data')
cursor.execute('delete from dbo.top_data')

printMessage('Removing cpuData.txt, diskioData.txt, freeMemData.txt, networkData.txt, logData.txt, topData.txt')
DelFile("/data/perfmon/cpuData.txt")
DelFile("diskioData.txt")
DelFile("freeMemData.txt")
DelFile("networkData.txt")
DelFile("logData.txt")
DelFile("topData.txt")

conn.commit()
cursor.close()
conn.close()
