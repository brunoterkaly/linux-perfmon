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
# Loop through the text file
fn = './topData.txt'
if not os.path.exists(fn):
   exit()

with open(fn) as f:
   for row in f:
       data = (row.strip().split("|"))
       print(data)
       #exit()

  
       status = ''
       if data[9] == 'D':
          status = 'stuck_sleep'
       elif data[9] == 'R':
          status = 'running'
       elif data[9] == 'S':
          status = 'sleeping'
       elif data[9] == 'T':
          status = 'stopped_or_traced'
       elif data[9] == 'Z':
          status = 'zombie'


       sql = "insert into top_data(" \
       "hostname,timestamp,pid," \
       "process_user,priority,nice," \
       "virt_mem,res_mem,shared_mem," \
       "process_status,cum_core_cpu,cpu_percent," \
       "cpu_time,command_line)" \
       "values(" \
       "'{0}','{1}',{2}," \
       "'{3}',{4},{5}," \
       "{6},{7},{8}," \
       "'{9}',{10},{11}," \
       "'{12}','{13}')".format( \
       data[0],data[1],data[2], \
       data[3],data[4],data[5], \
       data[6],data[7],data[8], \
       status,data[10],data[11], \
       data[12],data[13]);

       #print(sql) 
       cursor.execute(sql)
       
# Display inserted data
cursor.execute('select * from dbo.top_data')  
row = cursor.fetchone()  
while row:  
   print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
   row = cursor.fetchone() 

conn.commit()
cursor.close()
conn.close()

