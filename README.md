# Linux Perfmon

Think about a problem you are trying to solve, as I am.

## Problem to solve

I am working with a customer that is comparing cluster performance between the public cloud and on-premises.

There are two Hadoop clusters

- One cluster runs in the cloud
- One cluster runs on-premise.

There is a signficant performance difference betweem the two clusters.

**How will you figure this out?**

## Goals for the code to figure this out

#### There are some challenges:

- How do you write code that runs ANYWHERE, in any cloud or on-premise.
- How do you compare to clusters? Do you look at the memory utilization  across both clusters looking for differences?
- Are the CPUs the bottleneck? Network? Disk IO?
- Where is the performance bottleneck?

### How would tooling help find the answer?

What would you need?

- One powerful tool is Windows Perfmon, which is built for ultimate flexibility. But it doesn't support Linux.
  - One clear goal is to create an ability of Windows Perfmon to support Linux-based performance metrics.
- Can custom databases be used that help you use Linux Perfmon to do cluster-wide comparisons?

Assume Ubuntu for this proof-of-concept

This is a project about bringing the power from Windows Perfmon tool to the Linux world. Well, it is more than that. You can bring any analytic and visualization to the core tools provided here.

This example simplifies the collection of performance metrics for storage in a SQL Database. There are many options. SQL DB has the advantage of directly supporting Windows Perfmon, for example.

- Could it upload to MySQL or PostGres? Yes, with some slight tweaks. i
- You could argue it makes sense in a time series database. Yes, that would work too.

The code here simply removes all the grunt work of getting core performance metrics into a persistent datastore through a concrete example.


![](./perfmon.png)

## Established Linux performance monitoring tools

By leveraging well-known and established Linux utilities such as top, iostat (and more), we can use proven tooling in the platform in a vendor-independent manner. This means you can run these utilities in any known public cloud, as well as on premises.

The architecture is decoupled and flexible in terms of how performance metrics get captured, transformed/stored, and charted/analyzed.

## Local file system for performance metrics storage

Because the capture process stores to local text files, there is less interference and corruption of the performance metrics as data is captured.
Upload performance metrics to relational database
The uploading of the data into the cloud is done after the capture process has been halted. At that point, text files are read by Python applications, and with minimal transformations, or uploaded to a persistent store is currently SQL Server. 

## Minimize dependencies

The only lead dependency on the Linux side is Python itself. Many distributions now include Python regardless and upgrading to version 3 is simply one command.
Perfmon, Python, SQL Server, Excel to start with
The current set of tooling for the entire package include: Python, SQL Server, optionally, Excel for the visualization side. Because Windows Perfmon can take input from a relational database, integration with it as a visualizer is amazingly easy.

## Potential improvements - How to improve this code base

There are many ideas for making this a better product. One improvement could be leveraging open source charting packages like Grafana.

- https://grafana.com/

#### Power BI

There is also the potential for using Power BI, which is not an open source tool, but may make sense for some who would like to integrate cleanly with SQL Server.

#### Applying Machine Learning

There is a potential to apply machine learning techniques as well as basic analytics to performance metrics. 

- High disk saturation can lead to queuing of read/write requests.
- Memory pressure causing memory/disk virtualization issues

#### Additional Performance Metrics to track

You could find more performance indicators beyond those provided by iostat, ifstat, free, top, etc.

#### Finding a better database

Perhaps a database like OpenTSDB can be used. It is optimized for time series data.

#### Leveraging a data warehouse and cubes

Cubes can be used in both Excel and PowerBI to perform pivots and free form analaysis.

#### More efficient Uploads

Currently a PyMySQL driver is used to conduct a multitude of insert statements. A bulk import would be much more efficient.

#### Map Reduce Hadoop

There could be cases of massive data when conducting a performance profile across a huge cluster. Maybe some Map Reduce jobs or Pig code be used to analyze and process the data.

#### Build better stored procedures

Various analytics could be used in raw SQL Stored Procedures. Currently there is code that transposes columns and rows using Dynamic SQL. See GetTopData stored procedure.

### Documentation - What do all the columns mean that come from running the Linux performance tools of:
- iostat
- ifstat
- top
- free

## You can see all the code here:
https://github.com/brunoterkaly/linux-perfmon/

# Overview - How the pieces fit together

- **Installation** – run **InstallPython.sh** to get things rolling. From there, run **python3 Install.py**
- **Starting the capture** – run **StartCapture.sh**. This batch script will run a variety of other scripts:   
	- ParseFreeMemStat.py 
	- ParseIfStat.py
	- ParseIoStat.py
	- ParseTop.py 
- **Capture and save** - the Python scripts above simply execute the Linux utilities and scrape the output from the screen. . This output gets then saved into delimited text files, later to be inserted into SQL Server for analysis and charting.
	- Some screen scraping happens and this data is saved as text files:
		- cpuData.txt
		- diskioData.txt
		- freeMemData.txt
		- networkData.txt
		- topData.txt 
- **The Linux utilities** - be that each of the Python scripts calls a lower level Linux function:
	- **ParseIoStat.py**
		- command = ['iostat']
	- **ParseFreeMemStat.py**
		- command = ['free']	
	- **ParseIfStat.py**
		- command = ['ifstat', '-bt']
	- **ParseTop.py**
		- command = ['top', '-b', '-n1']
- **Stopping the capture and loading the data to a database** - after some period of time when you have completed capturing the performance metrics by running **StopCapture.py**, which will:
	- Halt the capture process
	- Read the generated text files and upload them to SQL database in the cloud
- **BulkImportCode** - There are a number of Python scripts that perform the reading of these disk-based text files, and uploading that data up into SQL Database.
	- BulkImportCpu.py
	- BulkImportDiskIo.py
	- BulkImportFreeMem.py
	- BulkImportNetwork.py
	- BulkImportTop.py  
- **Understanding the code** - a connection string is needed to connect up to your database. The name of this file that stores the connection string is called, **fakeconnectionstrings.txt**. If you need to create the database from scratch, the entire sequence of SQL commands can be found in the file, **database-creation-script.sql.**
- **The database**- there is a significant amount of transformation logic in the database today. The logic is expressed both with SQL views as well as SQL stored procedures. Ultimately,  we talking about timeseries data so it could be argued that other databases might fit better. The original developer had quick and easy access it to SQL database along with some of the logic that was used. So it became the choice database. Some of the logic includes the ability to transform rows and columns for easier charting.
- **The spreadsheet** - There is an **a** that does an import from the database, as well as generating some charts. It is still under development and has been included in this repot yet.


## Summary

The "Parse" scripts below run the Linux utilities and output text files during the capture process. These text files are then read by the "Bulk" Python scripts and uploaded to the SQL database in the cloud.

Simply put, "Use Python to run Linux utlilities, scrape performance metrics from those Linux utilities, and insert them into SQL DB."

![](./flow.png)




