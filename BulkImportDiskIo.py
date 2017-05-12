import pymssql  
import csv
import os

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

fn = './diskioData.txt'
if not os.path.exists(fn):
   exit()

with open(fn) as f:
   for row in f:
       data = (row.strip().split("|"))

       sql = "insert into disk_io_data(" \
       "hostname,timestamp,file_system," \
       "io_requests_per_sec,blks_read_per_sec,blks_written_per_sec," \
       "total_blks_read,total_blks_written) values(" \
       "'{0}','{1}','{2}'," \
       "{3},{4},{5}," \
       "{6},{7})".format( \
       data[0],data[1],data[2], \
       data[3],data[4],data[5], \
       data[6],data[7]);

       cursor.execute(sql)
       


cursor.execute('select * from dbo.disk_io_data')  
row = cursor.fetchone()  
while row:  
   print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
   row = cursor.fetchone() 

conn.commit()
cursor.close()
conn.close()

