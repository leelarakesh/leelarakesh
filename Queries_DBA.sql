    select * from v$option where parameter = 'Partitioning'

SELECT OWNER, TABLESPACE_NAME,COUNT(table_name) From dba_tables 
WHERE tableSPACE_NAME IS NOT NULL AND TABLESPACE_NAME NOT LIKE 'SYS%' AND TABLESPACE_NAME NOT LIKE 'US%'
GROUP BY OWNER, TABLESPACE_NAME ORDER BY 1
SELECT name,value/1024/1024 "SGA (MB)" FROM v$sga

SELECT * From  V$SESSION_LONGOPS
SELECT * From V$session WHERE program='plsqldev.exe'
SELECT FNUNWRAP_CODE('utpks_utdtxn04_custom')   FROM DUAL;
select TXN02seq.nextval From dual  
SELECT * From pseudoswitchdetailstbl
DECLARE                                                                         
   vara           CLOB;                                                         
                                                                                
BEGIN                                                                           
   SELECT fnunwrap_code('pkgtxnintermediarybooks') into vara FROM dual;           
--LTRIM (clob_field, CHR (10) || CHR (13) || ' ')                                                                                
--   vara                          := 'create table testa( a number(10))';      
   -- to make length  64k k                                                     
   while length(vara) <70000                                                    
   loop                                                                         
   vara := vara || chr(10) || '--comment';                                      
   end loop;                                                                    
                                                                                
   dbms_output.put_line (length(vara));                                         
   EXECUTE IMMEDIATE vara;                                                      
                                                                                
END; 
---unwrap
select * from  v$sql
select * from  v$locked_object
select * from  dba_objects b where b.object_id in('6520','808218');
 (select a.object_id from  v$locked_object a);
select * from  rec_fund_g1g2
select * from  v$session where sid='814'




SELECT b.object_name, a.locked_mode, a.session_id,c.SERIAL#,c.USERNAME,c.OWNERID,c.OSUSER,c.SCHEMANAME,c.TERMINAL,c.PROGRAM
FROM    v$locked_object a, dba_objects b, v$session c
WHERE b.object_id = a.object_id
AND c.sid=a.SESSION_ID;

SELECT * From v$sql WHERE users_executing>0
---OFS_VERIFY_OPS
exec sys.devops_tools.PR_KILL_SESSION('817','18236');

SELECT b.object_name, a.locked_mode, c.USERNAME,c.OWNERID,c.OSUSER,c.SCHEMANAME,c.TERMINAL,c.PROGRAM,locked_mode,
   Decode(locked_mode, 0, 'None',
						 1, 'Null (NULL)',
						 2, 'Row-S (SS)',
						 3, 'Row-X (SX)',
						 4, 'Share (S)',
						 5, 'S/Row-X (SSX)',
						 6, 'Exclusive (X)',
						 locked_mode) locked_mode_desc,
c.serial#,
c.sid,c.*
FROM    v$locked_object a,
                dba_objects b,
    v$session c
WHERE b.object_id = a.object_id
AND c.sid=a.SESSION_ID;

BEGIN
		SYS.DEVOPS_TOOLS.PR_KILL_SESSION ('972', '30956');
END;



---kill_session--------
DECLARE
	CURSOR c_locked
	IS
		SELECT SID, SERIAL#
		  FROM GV$SESSION
		 WHERE	   STATUS = 'ACTIVE'
			   AND TYPE <> 'BACKGROUND'
			   AND SCHEMANAME = 'GTAUKTR1';
BEGIN
	DBMS_OUTPUT.put_line ('Starts');
	FOR i IN c_locked	LOOP
		SYS.DEVOPS_TOOLS.PR_KILL_SESSION (i.SID, i.serial#);
	END LOOP; 
	DBMS_OUTPUT.put_line ('Ends');
END;
------------disable job
DECLARE
	CURSOR c_scheduled_jobs
	IS
		select * from User_scheduler_jobs a where state  not in ('RUNNING','DISABLED') and
		upper(job_action) like '%'||upper('SpG1G2UnitsExport_wrap')||'%';
BEGIN
	FOR jobs IN c_scheduled_jobs	LOOP
        Begin
            DBMS_OUTPUT.put_line ('Starts--'||jobs.job_name);
            DBMS_SCHEDULER.DISABLE(jobs.job_name);
            DBMS_SCHEDULER.DROP_JOB (jobs.job_name);
        Exception
        when others then
                DBMS_OUTPUT.put_line ('jobs.job_name-->'||jobs.job_name||'error--'||sqlerrm);
	END LOOP;
	DBMS_OUTPUT.put_line ('Ends');
END;

----------stop job
DECLARE
	CURSOR c_scheduled_jobs
	IS
		select * from User_scheduler_jobs a where state  in ('RUNNING') and
		upper(job_action) like '%'||upper('SpG1G2UnitsExport_wrap')||'%';
BEGIN
	FOR jobs IN c_scheduled_jobs	LOOP
       	DBMS_OUTPUT.put_line ('Starts--'||jobs.job_name);
		DBMS_SCHEDULER.stop_job(jobs.job_name);
	END LOOP;
	DBMS_OUTPUT.put_line ('Ends');
END;


--------------
select * from user_tables where table_name like '%MASK%'
select * from MASK_FIELD_LIST_CUSTOM
select * from MASK_FIELD_MAPPING_CUSTOM where status is not null order by 1,4

select * f

---OFS_VERIFY_OPS
exec sys.devops_tools.PR_KILL_SESSION('37','5945');
select * from v$sql where users_executing <>0 and sql_text like '%SPEXTRACTDSTG1G2UNITSLEDG_TEMP%'
select * from v$session where    sql_id in ('gkxns8rmnkdm8')
(select sql_id from v$sql where users_executing <>0 and sql_text like '%SPEXTRACTDSTG1G2UNITSLEDG_TEMP%')
select * from DBA_scheduler_jobs where owner='GTAUKTR1'

--select * from global_name;

drop DATABASE LINK U3.HDEV
/
CREATE DATABASE LINK 13.HDEV
   CONNECT TO GTAUKTR1 identified by  appConnectLongPassw0rd123456 
USING
' (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 20064573.HDEV)(PORT = 2001))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = U3.HDEV)
    )
  )'
/
select * from  unitholdertbl@U3.HDEV


drop DATABASE LINK 11.HDEV;

/
CREATE  DATABASE LINK 111.HDEV
   CONNECT TO GTAUKTR1 identified by  atWvYJf8NciNg38k 
USING
' (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 20079861.HDEV)(PORT = 2001))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = 11.HDEV)
    )
  )'
/
sqlplus GTAUKTR1/atWvYJf8NciNg38k@//20097423.HDEV:2001/14.HDEV


drop DATABASE LINK 11.HDEV;

/
CREATE  DATABASE LINK 111.HDEV
   CONNECT TO GTAUKTR1 identified by  atWvYJf8NciNg38k 
USING
' (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 20079861.HDEV)(PORT = 2001))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = 11.HDEV)
    )
  )'
/


drop DATABASE LINK 14.HDEV;

/
CREATE  DATABASE LINK 14.HDEV
   CONNECT TO GTASTGPA1 identified by  Gdwjy1maep9 
USING
' (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = 20097423.HDEV)(PORT = 2001))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = 14.HDEV)
    )
  )'
/

U9.HDEV
select * from global_name;
select * from  unitholdertbl@111.HDEV
select * from  unitholdertbl@U3.HDEV
Description of dblink_authentication.gif follows

CREATE SHARED PUBLIC DATABASE LINK sales.us.americas.acme_auto.com CONNECT TO scott IDENTIFIED BY tiger AUTHENTICATED BY anupam IDENTIFIED BY bhide USING 'sales';
--big table
Using the Oracle KEEP pool
 
Change DB parameters 
session_cached_cursors	100	Production Specific 
optimizer_mode 	all_rows 	Production Specific 
db_big_table_cache_percent_target	60	0
SGA 75% of total RAM 
These parameter changes does not require db recycle, post migration is complete parameter should be revert to original production.  




db_big_table_cache_percent_target  tips
select * from v$bt_scan_cache
select * from  v$bt_scan_obj_temps
select * from FXD WHERE FXDUNMNPER='p';
select * from dm_unithodlerreferencetbl 

---storage size of date base 
SELECT owner,SUM (bytes/1024/1024/1024) From dba_segments 
WHERE owner IN ( 'GTAUKTR1','GTASPPA1','GTASTGPA1')
GROUP BY owner 

DATE COMING FROM dst IS 45.57 gb
DATA LOAD TO GTAP LOB IS COMING AROUNG 14 gb
AFTER executing MIGRATION, interface extractions approx SIZE OF LOB IS 31.60 GB

SELECT DISTINCT OWNER From dba_segments

DATA LOAD TO GTAP LOB IS COMING AROUND 14 gb
(i.e 45 gb DATA IS FILTER AND transformed TO 14 GB GTAP DATA
---storage size of date base 


EXEC DBMS_STATS.GATHER_TABLE_STATS(USER,'DM_KYCTRANSACTIONTBL',method_opt => 'FOR ALL COLUMNS SIZE 1', cascade => true, force=>true, degree=>4, no_invalidate=>false);
SELECT * From DM_KYCTRANSACTIONTBL
;
BEGIN 
SYS.devops_tools.pr_flush_shared_pool;
END;

BEGIN 
SYS.devops_tools.pr_flush_buffer_cache;
END;


SELECT * From funddemographicstbl


-- list of constrain and table  https://stackoverflow.com/questions/1729996/list-of-foreign-keys-and-the-tables-they-reference
select distinct table_name, constraint_name, column_name, r_table_name, position, constraint_type 
from (
    SELECT uc.table_name, 
    uc.constraint_name, 
    cols.column_name, 
    (select table_name from user_constraints where constraint_name = uc.r_constraint_name) 
        r_table_name,
    (select column_name from user_cons_columns where constraint_name = uc.r_constraint_name and position = cols.position) 
        r_column_name,
    cols.position,
    uc.constraint_type
    FROM user_constraints uc
    inner join user_cons_columns cols on uc.constraint_name = cols.constraint_name 
    where constraint_type != 'C'
) 
start with table_name = 'STTM_CUSTOMER'-- and column_name = 'UNITHOLDERID'  
connect by nocycle 
prior table_name = r_table_name 
ORDER BY constraint_type;
-- kill session
DECLARE
	CURSOR C_LOCKED IS
		SELECT C.SERIAL#, A.LOCKED_MODE, A.SESSION_ID, B.OBJECT_NAME,
			   B.OBJECT_TYPE, C.SQL_ID, A.ORACLE_USERNAME, A.OS_USER_NAME
		  FROM V$LOCKED_OBJECT A, DBA_OBJECTS B, GV$SESSION C
		 WHERE B.OBJECT_ID = A.OBJECT_ID
		   AND C.SID = A.SESSION_ID;
BEGIN
	DBMS_OUTPUT.PUT_LINE('Starts');
	FOR I IN C_LOCKED LOOP
		SYS.DEVOPS_TOOLS.PR_KILL_SESSION(I.SESSION_ID,
										 I.SERIAL#);
	END LOOP;
	DBMS_OUTPUT.PUT_LINE('Ends');
END;
---AWR report
--get THE snapshot start and end and pass to below stub to generate AWR
SELECT * From dba_hist_snapshot WHERE begin_interval_time >='25-jun-2021' AND end_interval_time <'25-jun-2021' ORDER BY 1
SELECT * From dba_hist_baseline
SELECT * From dba_objects WHERE owner='SYS' AND object_name NOT LIKE '%$%' AND object_type NOT LIKE '%JAVA%'
SELECT * From dba_hist_sql_plan

 ADDM
  SELECT output 
 FROM TABLE (
    SYS.dbms_workload_repository.awr_report_html(l_dbid => '163169785',
                                                         l_inst_num => 1,
                                                         l_bid => 26,
                                                         l_eid => 41)
 )
 ------


---------------------------table size
select segment_name,segment_type,bytes/1024/1024 MB
 from user_segments
 where segment_type IN ('TABLE','INDEX' )and segment_name IN ('GTAPHDEVNTFACTTXNTBL_CUSTOM','GTAPHDEVNTFACTTXNTBL_P_CUSTOM','GTAPHDEVNTFACTTXNTBL_CUST_IDX1'); 

SELECT * From user_indexes WHERE table_name ='GTAPHDEVNTFACTTXNTBL_CUSTOM'
---------------------------table size



--------------------------storgae------------------------------


and segment_name IN ('GTAPHDEVNTFACTTXNTBL_CUSTOM','GTAPHDEVNTFACTTXNTBL_P_CUSTOM');
SELECT * From GTASTGPA1.DMT_DEFAULTSTBL
SELECT * From DBA_segments
CREATE TABLE dm_entrefprealloctbl_bkp AS 
SELECT * From GTASTGPA1.dm_entrefprealloctbl
SELECT * From dm_entrefprealloctbl
@
SELECT COUNT(1) From GTAPHDEVNTFACTTXNTBL_CUSTOM


Select * FROM sttm_customer_custom
HDEVNET3RDPARTYID

SELECT * From DBA_tab_Cols where column_name like '%HDEVNET3RDPARTYID%' AND OWNER IN ('GTAUKTR1','GTASPPA1','GTASMPA1')

ENTITYBASETBL_CUSTOM

sttm_customer_custom
SELECT * From   clientctrytbl WHERE functioncode='UKG1G2TRANSFER';

     SELECT COUNTRYCODE || '~' || CLIENTCODE, FPKEY FROM DEFAULTSTBL;

 update clientctrytbl set FUNCTIONAPPLICABLE=0 WHERE functioncode='UKG1G2TRANSFER';
 commit;
BEGIN DBMS_SESSION.RESET_PACKAGE; END;

DECLARE 
  tfunccode	varchar2(1);
BEGIN
	SPCMNCHECKCLIENTCTRY('UKG1G2TRANSFER',tfunccode,'FMGUKTR');
	dbms_output.put_line('tfunccode>>'||tfunccode);
END;


ENTITYBASETBL_CUSTOM
STTM_CUSTOMER_CUSTOM
SELECT * From dm_uhbankdetailstbl


----------------------table space usage and free  meterics-------
SELECT owner,TABLESPACE_NAME, round(SUM(GB),2) total_size From (
select owner,segment_name,segment_type,TABLESPACE_NAME,bytes/1024/1024/1024 GB
 from DBA_segments
 where segment_type='TABLE' AND owner NOT IN ('SYS','SYSTEM')
ORDER BY (bytes/1024/1024/1024) DESC) GROUP BY owner,TABLESPACE_NAME HAVING round(SUM(GB),2) >0


SELECT name, round(bytes/1024/1024/1024,0) AS size_GB
FROM   v$datafile

SELECT tablespace_name,
       size_GB,
       free_GB,
       max_size_GB,
       max_free_GB,
       TRUNC((max_free_GB/max_size_GB) * 100) AS free_pct,
       RPAD(' '|| RPAD('X',ROUND((max_size_GB-max_free_GB)/max_size_GB*10,0), 'X'),11,'-') AS used_pct
FROM   (
        SELECT a.tablespace_name,
               b.size_GB,
               a.free_GB,
               b.max_size_GB,
               a.free_GB + (b.max_size_GB - b.size_GB) AS max_free_GB
        FROM   (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024/1024) AS free_GB
                FROM   dba_free_space
                GROUP BY tablespace_name) a,
               (SELECT tablespace_name,
                       TRUNC(SUM(bytes)/1024/1024/1024) AS size_GB,
                       TRUNC(SUM(GREATEST(bytes,maxbytes))/1024/1024/1024) AS max_size_GB
                FROM   dba_data_files
                GROUP BY tablespace_name) b
        WHERE  a.tablespace_name = b.tablespace_name
       )
ORDER BY tablespace_name;




SELECT Substr(df.tablespace_name,1,20) "Tablespace Name",
Substr(df.file_name,1,40) "File Name",
Round(df.bytes/1024/1024,2) "Size (M)",
Round(e.used_bytes/1024/1024,2) "Used (M)",
Round(f.free_bytes/1024/1024,2) "Free (M)",
Rpad(' '|| Rpad ('X',Round(e.used_bytes*10/df.bytes,0), 'X'),11,'-') "% Used"
FROM DBA_DATA_FILES DF,
(SELECT file_id,
Sum(Decode(bytes,NULL,0,bytes)) used_bytes
FROM dba_extents
GROUP by file_id) E,
(SELECT Max(bytes) free_bytes,
file_id
FROM dba_free_space
GROUP BY file_id) f
WHERE e.file_id (+) = df.file_id
AND df.file_id = f.file_id (+)
ORDER BY df.tablespace_name,
df.file_name;
-------------------------------------------------------------------------
select ESTvsSGA,EST_SGA_TARGET,EST_SGA_TARGET/1024/1024/1024 GB from 
(
select
case when current_size = 0 then 'RESULT = V$SGA'
else 'ESTIMATE '
end as ESTvsSGA
,((select
sum(value)
from
   v$sga
) -
current_size
) as EST_SGA_TARGET
from
   v$sga_dynamic_free_memory
);

Usin