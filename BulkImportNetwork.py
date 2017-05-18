import pymssql  
import csv
import os
import sys


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

fn = './networkData.txt'
if not os.path.exists(fn):
   exit()

try:

   with open(fn) as f:
      for row in f:
         data = (row.strip().split("|"))
         sql = "insert into network_data(" \
         "hostname,timestamp,network_interface," \
         "in_or_out,kbps_value) values(" \
         "'{0}','{1}','{2}','{3}'," \
         "{4})".format( \
         data[0],data[1],data[2], \
         data[3],data[4]);
         sys.stdout.write('.')
         sys.stdout.flush()
         try:
            cursor.execute(sql)
         except:
            print(sql)
            pass

except:
   print(sql)
   pass
conn.commit()
cursor.close()
conn.close()

"""
for r in data:
  print(r)
"""
"""
cursor.execute('select * from dbo.network_data')  
row = cursor.fetchone()  
while row:  
   print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
   row = cursor.fetchone() 
"""
