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
# Loop through the text file
fn = './ioTopData.txt'
if not os.path.exists(fn):
   exit()

with open(fn) as f:
   for row in f:
       data = (row.strip().split("|"))
       #print(data)

       sql = "insert into iotop_data(" \
             "hostname,timestamp,tid,priority," \
             "process_user,disk_read,read_unit,disk_write," \
             "write_unit,swapin,io,command)" \
             "values(" \
             "'{0}','{1}',{2},'{3}'," \
             "'{4}',{5},'{6}',{7}," \
             "'{8}',{9},{10},'{11}')".format( \
       data[0],data[1],data[2], \
       data[3],data[4],data[5], \
       data[6],data[7],data[8], \
       data[9],data[11],data[13])


       sys.stdout.write('.')
       sys.stdout.flush()
       try:
          cursor.execute(sql)
       except:
          print("ERROR")
          print(sql)
          exit()
          pass
       
# Display inserted data
cursor.execute('select * from dbo.iotop_data')  
row = cursor.fetchone()  
while row:  
   #print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
   row = cursor.fetchone() 

conn.commit()
cursor.close()
conn.close()

