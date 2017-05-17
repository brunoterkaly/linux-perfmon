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
fn = './freeMemData.txt'
if not os.path.exists(fn):
   exit()

with open(fn) as f:
   for row in f:
       data = (row.strip().split("|"))

       sql = "insert into free_mem_data(" \
       "hostname,timestamp,mem_type," \
       "total_mem,used_mem,free_mem," \
       "shared_mem,buff_cache,available" \
       ") values(" \
       "'{0}','{1}','{2}'," \
       "{3},{4},{5}," \
       "{6},{7},{8}" \
       ")".format( \
       data[0],data[1],data[2], \
       data[3],data[4],data[5], \
       0 if not data[6] else data[6], \
       0 if not data[7] else data[7], \
       0 if not data[8] else data[8] \
       );
       #print(sql)

       cursor.execute(sql)
       
# Display inserted data
cursor.execute('select * from dbo.free_mem_data')  
row = cursor.fetchone()  
while row:  
   print(str(row[0]) + " " + str(row[1]) + " " + str(row[2]))
   row = cursor.fetchone() 

conn.commit()
cursor.close()
conn.close()

