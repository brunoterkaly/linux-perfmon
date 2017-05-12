USE [master]
GO
/****** Object:  Database [perfmon]    Script Date: 5/12/2017 12:52:27 PM ******/
CREATE DATABASE [perfmon]
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [perfmon].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [perfmon] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [perfmon]
GO
/****** Object:  Table [dbo].[disk_io_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[disk_io_data](
	[hostname] [nvarchar](64) NULL,
	[timestamp] [datetime] NULL,
	[file_system] [nvarchar](64) NULL,
	[io_requests_per_sec] [real] NULL,
	[blks_read_per_sec] [real] NULL,
	[blks_written_per_sec] [real] NULL,
	[total_blks_read] [real] NULL,
	[total_blks_written] [real] NULL
)

GO
/****** Object:  View [dbo].[tx_diskio_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[tx_diskio_data] AS

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Disk IO' AS [object],
	'Requests/s' AS [counter],
	file_system AS [instance],
	io_requests_per_sec AS value

FROM
	disk_io_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Disk IO' AS [object],
	'Blocks Read/s' AS [counter],
	file_system AS [instance],
	blks_read_per_sec AS value

FROM
	disk_io_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Disk IO' AS [object],
	'Blocks Written/s' AS [counter],
	file_system AS [instance],
	blks_written_per_sec AS value

FROM
	disk_io_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Disk IO' AS [object],
	'Total Blocks Read' AS [counter],
	file_system AS [instance],
	total_blks_read AS value

FROM
	disk_io_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Disk IO' AS [object],
	'Total Blocks Written' AS [counter],
	file_system AS [instance],
	total_blks_written AS value

FROM
	disk_io_data
GO
/****** Object:  Table [dbo].[free_mem_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[free_mem_data](
	[hostname] [nvarchar](64) NULL,
	[timestamp] [datetime] NULL,
	[mem_type] [nvarchar](64) NULL,
	[total_mem] [real] NULL,
	[used_mem] [real] NULL,
	[free_mem] [real] NULL,
	[shared_mem] [real] NULL,
	[buff_cache] [real] NULL,
	[available] [real] NULL
)

GO
/****** Object:  View [dbo].[tx_mem_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[tx_mem_data] AS

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Memory' AS [object],
	'Total Memory' AS [counter],
	mem_type AS [instance],
	total_mem AS value

FROM
	free_mem_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Memory' AS [object],
	'Used Memory' AS [counter],
	mem_type AS [instance],
	used_mem AS value

FROM
	free_mem_data
	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Memory' AS [object],
	'Free Memory' AS [counter],
	mem_type AS [instance],
	free_mem AS value

FROM
	free_mem_data


UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Memory' AS [object],
	'Shared Memory' AS [counter],
	mem_type AS [instance],
	shared_mem AS value

FROM
	free_mem_data
	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Memory' AS [object],
	'Buffer Cache' AS [counter],
	mem_type AS [instance],
	buff_cache AS value

FROM
	free_mem_data
	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Memory' AS [object],
	'Available Memory' AS [counter],
	mem_type AS [instance],
	available AS value

FROM
	free_mem_data
GO
/****** Object:  Table [dbo].[cpu_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[cpu_data](
	[hostname] [nvarchar](64) NULL,
	[timestamp] [datetime] NULL,
	[user_percent] [real] NULL,
	[nice_percent] [real] NULL,
	[system_percent] [real] NULL,
	[iowait_percent] [real] NULL,
	[steal_percent] [real] NULL,
	[idle_percent] [real] NULL
)

GO
/****** Object:  View [dbo].[tx_cpu_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[tx_cpu_data] AS

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'CPU' AS [object],
	'User %' AS [counter],
	'Total CPU' AS [instance],
	user_percent AS value

FROM
	cpu_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'CPU' AS [object],
	'Nice %' AS [counter],
	'Total CPU' AS [instance],
	nice_percent AS value

FROM
	cpu_data

	UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'CPU' AS [object],
	'System %' AS [counter],
	'Total CPU' AS [instance],
	system_percent AS value

FROM
	cpu_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'CPU' AS [object],
	'IO Wait %' AS [counter],
	'Total CPU' AS [instance],
	iowait_percent AS value

FROM
	cpu_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'CPU' AS [object],
	'Steal %' AS [counter],
	'Total CPU' AS [instance],
	steal_percent AS value

FROM
	cpu_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'CPU' AS [object],
	'Idle %' AS [counter],
	'Total CPU' AS [instance],
	idle_percent AS value

FROM
	cpu_data

GO
/****** Object:  Table [dbo].[network_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[network_data](
	[hostname] [nvarchar](64) NULL,
	[timestamp] [datetime] NULL,
	[network_interface] [nvarchar](128) NULL,
	[in_or_out] [nvarchar](64) NULL,
	[kbps_value] [real] NULL
)

GO
/****** Object:  View [dbo].[tx_network_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =================================================================================
-- Create View template for Azure SQL Database and Azure SQL Data Warehouse Database
-- =================================================================================


CREATE VIEW [dbo].[tx_network_data] AS

SELECT  hostname,
		[timestamp] AS [utcdatetime],
		'Network' AS [object],
		in_or_out AS [counter],
		network_interface AS instance,
		kbps_value AS [value]

FROM
	dbo.network_data




	/*
	select * from tx_network_data
	*/



GO
/****** Object:  Table [dbo].[top_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[top_data](
	[hostname] [nvarchar](64) NULL,
	[timestamp] [datetime] NULL,
	[pid] [real] NULL,
	[process_user] [nvarchar](64) NULL,
	[priority] [real] NULL,
	[nice] [real] NULL,
	[virt_mem] [real] NULL,
	[res_mem] [real] NULL,
	[shared_mem] [real] NULL,
	[process_status] [nvarchar](36) NULL,
	[cum_core_cpu] [real] NULL,
	[cpu_percent] [real] NULL,
	[cpu_time] [nvarchar](16) NULL,
	[command_line] [nvarchar](256) NULL
)

GO
/****** Object:  View [dbo].[tx_proc_data]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[tx_proc_data] AS

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'Priority' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	priority AS value

FROM
	top_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'Nice' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	nice AS value

FROM
	top_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'Virtual Memory' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	virt_mem AS value

FROM
	top_data
	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'Reserved Memory' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	res_mem AS value

FROM
	top_data
	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'Shared Memory' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	shared_mem AS value

FROM
	top_data

UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'cum core cpu' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	cum_core_cpu AS value

FROM
	top_data
	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'CPU %' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	cpu_percent AS value

FROM
	top_data


/* TO RESOLVE

	
UNION ALL

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Process' AS [object],
	'CPU Time' AS [counter],
	CONCAT(pid, ' - [', command_line, '] (', process_user, ')') AS [instance],
	CAST(cpu_time AS real) AS value

FROM
	top_data

*/

GO
/****** Object:  View [dbo].[normalizeddataview]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[normalizeddataview] AS

SELECT
	hostname,
	[utcdatetime],
	[object],
	[counter],
	[instance],
	[value]

	FROM
		tx_cpu_data

UNION ALL

SELECT
	hostname,
	[utcdatetime],
	[object],
	[counter],
	[instance],
	[value]

	FROM
		tx_diskio_data
		
UNION ALL

SELECT
	hostname,
	[utcdatetime],
	[object],
	[counter],
	[instance],
	[value]

	FROM
		tx_mem_data
		
UNION ALL

SELECT
	hostname,
	[utcdatetime],
	[object],
	[counter],
	[instance],
	[value]

	FROM
		tx_network_data
		
UNION ALL

SELECT
	hostname,
	[utcdatetime],
	[object],
	[counter],
	[instance],
	[value]

	FROM
		tx_proc_data

GO
/****** Object:  Table [dbo].[normalizeddata]    Script Date: 5/12/2017 12:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[normalizeddata](
	[hostname] [nvarchar](100) NOT NULL,
	[utcdatetime] [datetime] NOT NULL,
	[object] [nvarchar](100) NOT NULL,
	[counter] [nvarchar](100) NOT NULL,
	[instance] [nvarchar](100) NOT NULL,
	[value] [real] NOT NULL
)

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [PK_normalizeddata]    Script Date: 5/12/2017 12:52:28 PM ******/
CREATE CLUSTERED INDEX [PK_normalizeddata] ON [dbo].[normalizeddata]
(
	[hostname] ASC,
	[utcdatetime] ASC,
	[object] ASC,
	[counter] ASC,
	[instance] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  View [dbo].[dim_date]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[dim_date] AS


SELECT DISTINCT 
	utcdatetime,
	DATEPART(yy, CAST(utcdatetime AS DateTime)) AS [year],
	DATEPART(qq, CAST(utcdatetime AS DateTime)) AS [quarter],
	DATEPART(mm, CAST(utcdatetime AS DateTime)) AS [month],
	DATEPART(wk, CAST(utcdatetime AS DateTime)) AS [week],
	DATEPART(dd, CAST(utcdatetime AS DateTime)) AS [day],
	DATEPART(hh, CAST(utcdatetime AS DateTime)) AS [hour],
	DATEPART(mi, CAST(utcdatetime AS DateTime)) AS [minute],
	DATEPART(ss, CAST(utcdatetime AS DateTime)) AS [second],
	DATEPART(ms, CAST(utcdatetime AS DateTime)) AS [millisecond],
	DATEPART(mcs, CAST(utcdatetime AS DateTime)) AS [microsecond]
	
	FROM normalizeddata

	
GO
/****** Object:  View [dbo].[dim_counter]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[dim_counter] AS


SELECT DISTINCT object, counter, instance
	FROM normalizeddata
GO
/****** Object:  View [dbo].[dim_host]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[dim_host] AS


SELECT DISTINCT hostname
	FROM normalizeddata
GO
ALTER TABLE [dbo].[normalizeddata] ADD  CONSTRAINT [DF_NORMALIZEDDATA_instance]  DEFAULT (N'-') FOR [instance]
GO
ALTER TABLE [dbo].[normalizeddata] ADD  CONSTRAINT [DF_NORMALIZEDDATA_value]  DEFAULT ((0)) FOR [value]
GO
/****** Object:  StoredProcedure [dbo].[GetCpuData]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCpuData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @interval int
	set @interval = 1
    -- Insert statements for procedure here
      SELECT  hostname,
        RIGHT('0000' + convert(varchar(4), datepart(year,timestamp)),4) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(month,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(day,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(hour,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(minute,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,
                avg(user_percent) ,
                avg(nice_percent) as nice_percent,
                avg(system_percent) as system_percent,
                avg(iowait_percent) as iowait_percent,
                avg(steal_percent) as steal_percent,
                avg(idle_percent) as idle_percent
       FROM CPU_DATA
       GROUP BY
            hostname,
            datepart(year,timestamp), datepart(month,timestamp),
            datepart(day,timestamp),
            datepart(hour,timestamp),datepart(minute,timestamp),
            datepart(second,timestamp) / @interval
        

        
END





GO
/****** Object:  StoredProcedure [dbo].[GetDiskIoData]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetDiskIoData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @interval int
	set @interval = 1
    -- Insert statements for procedure here
      SELECT  hostname, file_system,
        RIGHT('0000' + convert(varchar(4), datepart(year,timestamp)),4) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(month,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(day,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(hour,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(minute,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,
                avg(io_requests_per_sec) as io_requests_per_sec,
                avg(blks_read_per_sec) as blks_read_per_sec,
                avg(blks_written_per_sec) as blks_written_per_sec,
                avg(total_blks_read) as total_blks_read,
                avg(total_blks_written) as total_blks_written
       FROM disk_io_data
       GROUP BY
            hostname,
	    file_system,
            datepart(year,timestamp), datepart(month,timestamp),
            datepart(day,timestamp),
            datepart(hour,timestamp),datepart(minute,timestamp),
            datepart(second,timestamp) / @interval
        

        
END

GO
/****** Object:  StoredProcedure [dbo].[GetFreeMemData]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create PROCEDURE [dbo].[GetFreeMemData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @interval int
	set @interval = 1
    -- Insert statements for procedure here
      SELECT  hostname, mem_type,
        RIGHT('0000' + convert(varchar(4), datepart(year,timestamp)),4) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(month,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(day,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(hour,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(minute,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,
                avg(total_mem) as total_mem,
                avg(used_mem) as used_mem,
                avg(free_mem) as free_mem,
                avg(shared_mem) as shared_mem,
                avg(buff_cache) as buff_cache,
                avg(available) as available
       FROM free_mem_data
       GROUP BY
            hostname,
	    mem_type,
            datepart(year,timestamp), datepart(month,timestamp),
            datepart(day,timestamp),
            datepart(hour,timestamp),datepart(minute,timestamp),
            datepart(second,timestamp) / @interval
end
GO
/****** Object:  StoredProcedure [dbo].[GetNetworkData]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetNetworkData]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	declare @interval int
	set @interval = 1
    -- Insert statements for procedure here
      SELECT  hostname, network_interface, in_or_out,
        RIGHT('0000' + convert(varchar(4), datepart(year,timestamp)),4) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(month,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(day,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(hour,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(minute,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,
                avg(kbps_value) as kbps_value
       FROM network_data
       GROUP BY
            hostname,
	        network_interface, in_or_out,
            datepart(year,timestamp), datepart(month,timestamp),
            datepart(day,timestamp),
            datepart(hour,timestamp),datepart(minute,timestamp),
            datepart(second,timestamp) / @interval
        

        
END

GO
/****** Object:  StoredProcedure [dbo].[GetTopCpuData]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetTopCpuData]
AS
BEGIN
	DECLARE @cols NVARCHAR(MAX), @sql NVARCHAR(MAX), @colsavg NVARCHAR(MAX)
	DECLARE @result varchar(8000)
	DECLARE @new_col varchar(8000)
	DECLARE @new_col_as varchar(8000)
	DECLARE @new_col_list varchar(8000) = ''
	DECLARE @mycursor cursor 
	DECLARE @interval int
	set @interval = 1
	--Make columns out of rows
	SET @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(pid)
				FROM top_data
				ORDER BY 1
				FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)'),1,1,'')
	SET @colsavg = @cols
	--Goal: End up with columns that have avg function
	--Code to split string and add avg() function
	SET @mycursor = CURSOR FOR 
		SELECT Value FROM STRING_SPLIT(@colsavg, ',')
	open @mycursor
	FETCH NEXT FROM @mycursor INTO @new_col
	--Loop through adding columns, building a column list that has avg[PID]
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		set @new_col_as = replace(@new_col, '[', '_')
		set @new_col_as = replace(@new_col_as, ']', '')
		set @new_col_as = ' as PID' + @new_col_as
		set @new_col_list = @new_col_list + 'round(avg(' + @new_col + '),0) ' + @new_col_as
		set @new_col_list = @new_col_list + ','
		print(@new_col)
		FETCH NEXT FROM @mycursor INTO @new_col
	END 
	--Get rid of trailing comma
	set @new_col_list = left(@new_col_list, len(@new_col_list)-1)
	--Display for debugging
	print(@new_col_list)
	--create a view as temporary holding area
    SET @sql = 'create view tempview as SELECT  hostname, timestamp, ' + @cols + '
				  FROM
				(
				  SELECT hostname, timestamp, pid, cum_core_cpu
					FROM top_data
				) s
				PIVOT
				(
				  MAX(cum_core_cpu) FOR pid IN (' + @cols + ')
				) p'
	
	EXECUTE(@sql)
	--create temp table from view
	SELECT * INTO #temptbl FROM tempview
	drop view tempview
	--build select against temp table, aggregating as needed
	SET @sql = ' SELECT  hostname, ' +
        'RIGHT(''0000'' + convert(varchar(4), datepart(year,timestamp)),4) + '':'' + ' +
        'RIGHT(''00'' + convert(varchar(2), datepart(month,timestamp)),2) + '':'' + ' +
        'RIGHT(''00'' + convert(varchar(2), datepart(day,timestamp)),2) + '':'' + ' +
        'RIGHT(''00'' + convert(varchar(2), datepart(hour,timestamp)),2) + '':'' + ' +
        'RIGHT(''00'' + convert(varchar(2), datepart(minute,timestamp)),2) + '':'' + ' +
        'RIGHT(''00'' + convert(varchar(2), datepart(second,timestamp) / ' +  convert(varchar(3),@interval) + '),2) as timeslice,'
	SET @sql = @sql + @new_col_list + ' from #temptbl ' 
	SET @sql = @sql +        '  GROUP BY ' + 
            ' hostname, ' + 
            ' datepart(year,timestamp), datepart(month,timestamp), ' +
            ' datepart(day,timestamp), ' + 
            ' datepart(hour,timestamp),datepart(minute,timestamp), ' + 
            ' datepart(second,timestamp) / ' + convert(varchar(3),@interval)
	--SELECT * FROM #temptbl
	print(@sql)

	execute(@sql)
	DROP TABLE #temptbl
END


GO
/****** Object:  StoredProcedure [dbo].[UpdateNormalizedData]    Script Date: 5/12/2017 12:52:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateNormalizedData]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	TRUNCATE TABLE normalizeddata

    -- Insert statements for procedure here
	INSERT INTO normalizeddata (hostname, utcdatetime, object, counter, instance, value)
		SELECT hostname, utcdatetime, object, counter, instance, value
		FROM normalizeddataview
END

GO
USE [master]
GO
ALTER DATABASE [perfmon] SET  READ_WRITE 
GO

