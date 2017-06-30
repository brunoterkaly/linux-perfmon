USE [master]
GO
/****** Object:  Database [perfmon]    Script Date: 5/21/2017 9:31:37 AM ******/
CREATE DATABASE [perfmon]
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [perfmon].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [perfmon] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [perfmon] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [perfmon] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [perfmon] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [perfmon] SET ARITHABORT OFF 
GO
ALTER DATABASE [perfmon] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [perfmon] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [perfmon] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [perfmon] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [perfmon] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [perfmon] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [perfmon] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [perfmon] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [perfmon] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [perfmon] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [perfmon] SET ALLOW_SNAPSHOT_ISOLATION ON 
GO
ALTER DATABASE [perfmon] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [perfmon] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [perfmon] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [perfmon] SET  MULTI_USER 
GO
ALTER DATABASE [perfmon] SET DB_CHAINING OFF 
GO
ALTER DATABASE [perfmon] SET QUERY_STORE = ON
GO
ALTER DATABASE [perfmon] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 100, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO)
GO
USE [perfmon]
GO
/****** Object:  Table [dbo].[iotop_data]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[iotop_data](
	[hostname] [nvarchar](64) NULL,
	[timestamp] [datetime] NULL,
	[tid] [real] NULL,
	[priority] [nvarchar](64) NULL,
	[process_user] [nvarchar](64) NULL,
	[disk_read] [real] NULL,
	[read_unit] [nvarchar](16) NULL,
	[disk_write] [real] NULL,
	[write_unit] [nvarchar](16) NULL,
	[swapin] [real] NULL,
	[io] [real] NULL,
	[command] [nvarchar](1024) NULL
)

GO
/****** Object:  View [dbo].[tx_ioTop_data]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[tx_ioTop_data] AS

SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Top Disk IO' AS [object],
	'Disk Read' AS [counter],
	CAST(tid AS VARCHAR(100)) AS Instance,
	CASE
		WHEN read_unit = 'K/s' THEN disk_read * 1000
		ELSE disk_read
	END AS value

FROM
	iotop_data

UNION ALL

	
SELECT
	hostname,
	[timestamp] AS [utcdatetime],
	'Top Disk IO' AS [object],
	'Disk Write' AS [counter],
	CAST(tid AS VARCHAR(100)) AS Instance,
	CASE
		WHEN write_unit = 'K/s' THEN disk_write * 1000
		ELSE disk_write

	END AS value

FROM
	iotop_data

GO
/****** Object:  Table [dbo].[disk_io_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  View [dbo].[tx_diskio_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  Table [dbo].[free_mem_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  View [dbo].[tx_mem_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  Table [dbo].[cpu_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  View [dbo].[tx_cpu_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  Table [dbo].[network_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  View [dbo].[tx_network_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  Table [dbo].[top_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  View [dbo].[tx_proc_data]    Script Date: 5/21/2017 9:31:38 AM ******/
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
	'Total Core CPU' AS [counter],
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
/****** Object:  View [dbo].[normalizeddata]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[normalizeddata] AS

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
		
UNION ALL

SELECT
	hostname,
	[utcdatetime],
	[object],
	[counter],
	[instance],
	[value]

	FROM
		tx_iotop_data


GO
/****** Object:  View [dbo].[dim_date]    Script Date: 5/21/2017 9:31:38 AM ******/
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
/****** Object:  View [dbo].[dim_counter]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[dim_counter] AS


SELECT DISTINCT object, counter, instance
	FROM normalizeddata
GO
/****** Object:  View [dbo].[dim_host]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[dim_host] AS


SELECT DISTINCT hostname
	FROM normalizeddata
GO
/****** Object:  Table [dbo].[CounterData]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterData](
	[GUID] [uniqueidentifier] NOT NULL,
	[CounterID] [int] NOT NULL,
	[RecordIndex] [int] NOT NULL,
	[CounterDateTime] [char](24) NOT NULL,
	[CounterValue] [float] NOT NULL,
	[FirstValueA] [int] NULL,
	[FirstValueB] [int] NULL,
	[SecondValueA] [int] NULL,
	[SecondValueB] [int] NULL,
	[MultiCount] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[GUID] ASC,
	[CounterID] ASC,
	[RecordIndex] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[CounterDetails]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterDetails](
	[CounterID] [int] IDENTITY(1,1) NOT NULL,
	[MachineName] [varchar](1024) NOT NULL,
	[ObjectName] [varchar](1024) NOT NULL,
	[CounterName] [varchar](1024) NOT NULL,
	[CounterType] [int] NOT NULL,
	[DefaultScale] [int] NOT NULL,
	[InstanceName] [varchar](1024) NULL,
	[InstanceIndex] [int] NULL,
	[ParentName] [varchar](1024) NULL,
	[ParentObjectID] [int] NULL,
	[TimeBaseA] [int] NULL,
	[TimeBaseB] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[CounterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[CounterMetadata]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CounterMetadata](
	[Object] [nvarchar](1024) NOT NULL,
	[Counter] [nvarchar](1024) NULL,
	[CounterType] [int] NOT NULL,
	[DefaultScale] [int] NOT NULL
)

GO
/****** Object:  Table [dbo].[DisplayToID]    Script Date: 5/21/2017 9:31:38 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DisplayToID](
	[GUID] [uniqueidentifier] NOT NULL,
	[RunID] [int] NULL,
	[DisplayString] [varchar](1024) NOT NULL,
	[LogStartTime] [char](24) NULL,
	[LogStopTime] [char](24) NULL,
	[NumberOfRecords] [int] NULL,
	[MinutesToUTC] [int] NULL,
	[TimeZoneName] [char](32) NULL,
PRIMARY KEY CLUSTERED 
(
	[GUID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
UNIQUE NONCLUSTERED 
(
	[DisplayString] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[ExpertAdvise]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ExpertAdvise](
	[AvgAvailableMemory] [float] NULL,
	[AvgTotalMemory] [float] NULL,
	[PercentUsedMemory] [float] NULL,
	[MemoryExpertAdvise] [varchar](1000) NULL,
	[AvgCPU] [float] NULL,
	[CPUExpertAdvise] [varchar](122) NULL
)

GO
/****** Object:  StoredProcedure [dbo].[GetCpuData]    Script Date: 5/21/2017 9:31:39 AM ******/
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
/****** Object:  StoredProcedure [dbo].[GetCPUExpertData]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Hugo Salcedo
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCPUExpertData]

	-- Add the parameters for the stored procedure here
	--<@Param1, sysname, @p1> <Datatype_For_Param1, , int> = <Default_Value_For_Param1, , 0>, 
	--<@Param2, sysname, @p2> <Datatype_For_Param2, , int> = <Default_Value_For_Param2, , 0>
AS
BEGIN
	/******************************************************************************************
	* Memory analysis block
	*******************************************************************************************/
	DECLARE @AvgAvailableMemory float
	DECLARE @AvgTotalMemory float
	DECLARE @PercentUsedMemory float
	DECLARE @ExpertAdvise varchar(1000)

	SELECT @AvgAvailableMemory =
			AVG([value]) / 1024000 
			FROM 
				[normalizeddata] 
			WHERE [instance] = 'mem' and  [Counter] = 'Available Memory'

	SELECT @AvgTotalMemory = 
			AVG([value]) / 1024000
			FROM 
				[normalizeddata] 
			WHERE [instance] = 'mem' and [Counter] = 'Total Memory'

	SELECT @PercentUsedMemory = (@AvgTotalMemory * @AvgAvailableMemory) /100


	SELECT 
			@ExpertAdvise =
			CASE 
				WHEN @PercentUsedMemory > 80 THEN 'The system is using ' + CAST( @PercentUsedMemory as nvarchar) + 'percent of the total available memory, this can be caused by a memory leak, please review the process report to identify the process consuming the most of the memory.'
				WHEN @PercentUsedMemory > 70 THEN 'The system is using ' + CAST( @PercentUsedMemory as nvarchar) + ' healty memory consumption, if you suspect abnormal memory consumption, please review the process report.'
				WHEN @PercentUsedMemory < 10 THEN 'The system is using ' + CAST( @PercentUsedMemory as nvarchar) + ', abnormal low memory consumption, the system is not been utilized, please review that the server is part of the cluster. '
			END

	/******************************************************************************************
	* CPU analysis block
	*******************************************************************************************/
	DECLARE @avgCPU float
	SELECT  @avgCPU = AVG([value]) FROM [dbo].[normalizeddata] where [object] = 'CPU' and [counter] = 'Idle %'
	IF OBJECT_ID('ExpertAdvise', 'U') IS NOT NULL DROP TABLE ExpertAdvise;

	SELECT
		--<Memory fields>
		@AvgAvailableMemory AS AvgAvailableMemory,
		@AvgTotalMemory AS AvgTotalMemory,
		@PercentUsedMemory AS PercentUsedMemory,
		@ExpertAdvise AS MemoryExpertAdvise,
		--<Memory fields/> 
		AVG([value]) AS AvgCPU, "CPUExpertAdvise" =
		CASE 
			WHEN @avgCPU > 80 THEN 'CPU is underutilized, this is a sign of CPU hang, likely heavy thread blocking, or simply no activity on the server.'
			WHEN @avgCPU > 70 THEN 'CPU is at healty percentage.'
			WHEN @avgCPU < 10 THEN 'Server is under a lot pressure, please review the process report to identify the process that is consuming most of the CPU'
		END
	INTO ExpertAdvise
	FROM 
		[normalizeddata] 
	WHERE [object] = 'CPU' AND [counter] = 'Idle %'

END

GO
/****** Object:  StoredProcedure [dbo].[GetDiskIoData]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetDiskIoData]
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
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,file_system,
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
/****** Object:  StoredProcedure [dbo].[GetFreeMemData]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetFreeMemData]
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
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,mem_type,
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
/****** Object:  StoredProcedure [dbo].[GetIoTopReadData]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIoTopReadData]
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
	SET @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(tid)
				FROM iotop_data
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
	--Loop through adding columns, building a column list that has avg[tid]
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		set @new_col_as = replace(@new_col, '[', '_')
		set @new_col_as = replace(@new_col_as, ']', '')
		set @new_col_as = ' as tid' + @new_col_as
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
				  SELECT hostname, timestamp, tid, disk_read
					FROM iotop_data
				) s
				PIVOT
				(
				  MAX(disk_read) FOR tid IN (' + @cols + ')
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
/****** Object:  StoredProcedure [dbo].[GetIoTopWriteData]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[GetIoTopWriteData]
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
	SET @cols = STUFF((SELECT DISTINCT ',' + QUOTENAME(tid)
				FROM iotop_data
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
	--Loop through adding columns, building a column list that has avg[tid]
	WHILE (@@FETCH_STATUS = 0) 
	BEGIN 
		set @new_col_as = replace(@new_col, '[', '_')
		set @new_col_as = replace(@new_col_as, ']', '')
		set @new_col_as = ' as tid' + @new_col_as
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
				  SELECT hostname, timestamp, tid, disk_write
					FROM iotop_data
				) s
				PIVOT
				(
				  MAX(disk_write) FOR tid IN (' + @cols + ')
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
/****** Object:  StoredProcedure [dbo].[GetNetworkData]    Script Date: 5/21/2017 9:31:39 AM ******/
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
      SELECT  hostname, 
        RIGHT('0000' + convert(varchar(4), datepart(year,timestamp)),4) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(month,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(day,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(hour,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(minute,timestamp)),2) + ':' +
        RIGHT('00' + convert(varchar(2), datepart(second,timestamp) / @interval),2) as timeslice,
				network_interface, in_or_out,
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
/****** Object:  StoredProcedure [dbo].[GetTopCpuData]    Script Date: 5/21/2017 9:31:39 AM ******/
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
/****** Object:  StoredProcedure [dbo].[UpdatePerfMonTables]    Script Date: 5/21/2017 9:31:39 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdatePerfMonTables]
	
AS
BEGIN
	SET NOCOUNT ON

	TRUNCATE TABLE CounterData
	TRUNCATE TABLE CounterDetails
	TRUNCATE TABLE DisplayToID


	--Parameter Definition
	DECLARE @LogRunName varchar(1024)


	--Variable Declaration
	DECLARE @myId uniqueidentifier  
	DECLARE @runId int
	DECLARE @startTime DATETIME
	DECLARE @endTime DATETIME


	--Setup Collection Information
	SET @myId = NEWID() 

	IF @LogRunName IS NULL SET @LogRunName = CONCAT('Sample - ', @myId)

	SET @runId = COALESCE((SELECT MAX(RunID) + 1 FROM DisplayToID), 0) 

	SELECT @startTime = MIN([utcdatetime]), @endTime = MAX([utcdatetime])
		FROM normalizeddata

	INSERT INTO DisplayToID (
		 [GUID]
		,RunID
		,DisplayString
		,LogStartTime
		,LogStopTime
		,MinutesToUTC,
		TimeZoneName)
	VALUES (
		 @myId
		,@runId
		,@LogRunName
		,FORMAT(@startTime, 'yyyy-MM-dd hh:mm:ss.fff')
		,FORMAT(@endTime, 'yyyy-MM-dd hh:mm:ss.fff')
		,0  --No offset
		,'Coordinated Universal Time')


	--Setup Counter Information

	INSERT INTO CounterDetails (
		   [MachineName]
		  ,[ObjectName]
		  ,[CounterName]
		  ,[CounterType]
		  ,[DefaultScale]
		  ,[InstanceName]
		  ,[TimeBaseA]
		  ,[TimeBaseB])
		SELECT DISTINCT
			 CONCAT('\\', hostname)
			,normalizeddata.object
			,normalizeddata.counter
			,CounterType
			,DefaultScale
			,instance
			,0 --TimeBaseA
			,0 --TimeBaseB

		FROM normalizeddata LEFT OUTER JOIN CounterMetadata ON normalizeddata.object = CounterMetadata.Object
																AND normalizeddata.counter = countermetadata.counter

	--Get all dates for which there will be samples
	DECLARE @Dates TABLE (EntryNo INT IDENTITY, DateEntry CHAR(24))

	INSERT INTO @Dates (DateEntry)
		SELECT DISTINCT FORMAT(utcdatetime, 'yyyy-MM-dd hh:mm:ss.fff')
			FROM normalizeddata


	--Get normalized data with one record for each date entry - Insert into CounterData

	INSERT INTO CounterData (GUID
							,CounterId	
							,RecordIndex
							,CounterDateTime
							,CounterValue
							,FirstValueA
							,SecondValueA
							,FirstValueB
							,SecondValueB
							,MultiCount)
						
	SELECT   @myId
			,CD.CounterID
			,D.EntryNo
			,D.DateEntry
			,COALESCE(ND.value, 0)
			,COALESCE(ND.value, 0)
			,0
			,0
			,0
			,1
		 
		FROM @Dates AS D CROSS JOIN CounterDetails AS CD
					LEFT OUTER JOIN normalizeddata AS ND ON D.DateEntry = CAST(FORMAT(utcdatetime, 'yyyy-MM-dd hh:mm:ss.fff') AS CHAR(24)) 
																AND CD.ObjectName = ND.object
																AND CD.CounterName = ND.counter
																AND CD.InstanceName = ND.instance



	--Update Number of Records

	UPDATE DisplayToId
		SET NumberOfRecords = (SELECT MAX(EntryNo) FROM @Dates)
		WHERE GUID = @myId AND RunID = @runId


	END
GO
USE [master]
GO
ALTER DATABASE [perfmon] SET  READ_WRITE 
GO

