import pymssql  
import csv
import re
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

cursor.execute('delete from dbo.cpu_data')  
conn.commit()

# Loop through the text file
fn = './cpuData.txt'
if not os.path.exists(fn): 
   exit()
with open(fn) as f:
   for row in f:
       data = (row.strip().split("|"))

       sql = "insert into cpu_data(" \
       "hostname,timestamp,user_percent," \
       "nice_percent,system_percent,iowait_percent," \
       "steal_percent,idle_percent) " \
       "values(" \
       "'{0}','{1}',{2}," \
       "{3},{4},{5}," \
       "{6},{7})".format( \
       data[0],data[1],data[2], \
       data[3],data[4],data[5], \
       data[6],data[7]);
       sys.stdout.write('.')
       sys.stdout.flush()
       try:
          cursor.execute(sql)
       except:
          print(sql)
          pass

       
# Display inserted data
cursor.execute('select * from dbo.cpu_data')  
row = cursor.fetchone()  
while row:  
   #print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
   row = cursor.fetchone() 

conn.commit()
cursor.close()
conn.close()

