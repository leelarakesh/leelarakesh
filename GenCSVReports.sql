CREATE OR REPLACE PACKAGE BODY pkgMigGenCSVReports
AS

PROCEDURE dbg(p_msg VARCHAR2) IS
  l_msg VARCHAR2(32767);
BEGIN
  l_msg := 'pkgMigGenCSVReports==>' || p_msg;
 --leelar for user specific enabling debug
        If instr( p_msg,'ORA-' ) <> 0 and instr( p_msg,'ORA-0000' ) = 0 then
          DEBUG.PR_DEBUG('UT' ,dbms_utility.format_error_backtrace);
          DEBUG.PR_DEBUG('UT' ,dbms_utility.format_call_stack);
          DBMS_OUTPUT.PUT_LINE('format_error_backtrace--> '||dbms_utility.format_error_backtrace);
          DBMS_OUTPUT.PUT_LINE('format_call_stack-->'||dbms_utility.format_call_stack);
        End If;
        IF instr( p_msg,'#>' ) <> 0 THEN
            DBMS_OUTPUT.PUT_LINE(p_msg);
        END IF;
        --leelar for user specific enabling debug  
  DEBUG.PR_DEBUG('UT' ,L_MSG);
END dbg;

-- Prototype for hidden procedures.
PROCEDURE generate_all (p_dir        IN  VARCHAR2,
                        p_file       IN  VARCHAR2,
                        p_query      IN  VARCHAR2,
                        p_refcursor  IN OUT SYS_REFCURSOR);

PROCEDURE put (p_file  IN  UTL_FILE.file_type,
               p_text  IN  VARCHAR2);

PROCEDURE new_line (p_file  IN  UTL_FILE.file_type);



-- Stub to generate a CSV from a query.
PROCEDURE generate (p_dir        IN  VARCHAR2,
                    p_file       IN  VARCHAR2,
                    p_query      IN  VARCHAR2,
                    p_sep        IN VARCHAR2
				   ) 
AS
  l_cursor  SYS_REFCURSOR;
BEGIN
  
  dbg('Inside Generate Procedure :: Start');
  g_out_type := 'F';
  g_sep:=p_sep;
  generate_all (p_dir        => p_dir,
                p_file       => p_file,
                p_query      => p_query,
                p_refcursor  => l_cursor
			   );
  dbg('Generate Procedure :: End');
END generate;


-- Stub to generate a CVS from a REF CURSOR.
PROCEDURE generate_rc (p_dir        IN  VARCHAR2,
                       p_file       IN  VARCHAR2,
                       p_refcursor  IN OUT SYS_REFCURSOR,
                       p_sep        IN VARCHAR2
					  ) 
AS
BEGIN
  g_out_type := 'F';
  g_sep:=p_sep;
  generate_all (p_dir        => p_dir,
                p_file       => p_file,
                p_query      => NULL,
                p_refcursor  => p_refcursor
			   );
END generate_rc;


-- Stub to output a CSV from a query.
PROCEDURE output (p_query  IN  VARCHAR2) AS
  l_cursor  SYS_REFCURSOR;
BEGIN
  g_out_type := 'D';
  generate_all (p_dir        => NULL,
                p_file       => NULL,
                p_query      => p_query,
                p_refcursor  => l_cursor
			   );
END output;


-- Stub to output a CVS from a REF CURSOR.
PROCEDURE output_rc (p_refcursor  IN OUT SYS_REFCURSOR) AS
BEGIN
  g_out_type := 'D';

  generate_all (p_dir        => NULL,
                p_file       => NULL,
                p_query      => NULL,
                p_refcursor  => p_refcursor
			   );
END output_rc;


-- Do the actual work.
PROCEDURE generate_all (p_dir        IN  VARCHAR2,
                        p_file       IN  VARCHAR2,
                        p_query      IN  VARCHAR2,
                        p_refcursor  IN OUT  SYS_REFCURSOR
					   ) 
AS

  l_cursor    PLS_INTEGER;
  l_rows      PLS_INTEGER;
  l_col_cnt   PLS_INTEGER;
  l_desc_tab  DBMS_SQL.desc_tab;
  l_buffer    VARCHAR2(32767);
  l_is_str    BOOLEAN;

  l_file      UTL_FILE.file_type;
  
BEGIN
  
  dbg('Inside Generate_All Procedure :: Start');
  dbg('p_query1 :: '||p_query);
  IF p_query IS NOT NULL THEN
    l_cursor := DBMS_SQL.open_cursor;
    DBMS_SQL.parse(l_cursor, p_query, DBMS_SQL.native);
  ELSIF p_refcursor%ISOPEN THEN
     l_cursor := DBMS_SQL.to_cursor_number(p_refcursor);
  ELSE
    RAISE_APPLICATION_ERROR(-20000, 'You must specify a query or a REF CURSOR.');
  END IF;

  DBMS_SQL.describe_columns (l_cursor, l_col_cnt, l_desc_tab);

  dbg('l_col_cnt :: '||l_col_cnt);
  FOR i IN 1 .. l_col_cnt LOOP
    DBMS_SQL.define_column(l_cursor, i, l_buffer, 32767 );
  END LOOP;

  IF p_query IS NOT NULL THEN
    l_rows := DBMS_SQL.execute(l_cursor);
  END IF;

  dbg('l_rows :: '||p_dir);
  dbg('l_rows :: '||p_file);
  IF g_out_type = 'F' THEN
    l_file := UTL_FILE.fopen(p_dir, p_file, 'w', 32767);
  END IF;

  --dbg('l_file :: '||l_file);
  -- Output the column names.
  if g_col_header_on='Y' then 
    FOR i IN 1 .. l_col_cnt LOOP
      IF i > 1 THEN
        put(l_file, g_sep);
      END IF;
      put(l_file, l_desc_tab(i).col_name);
    END LOOP;
      new_line(l_file);
  end if;


  -- Output the data.
  LOOP
    EXIT WHEN DBMS_SQL.fetch_rows(l_cursor) = 0;

	--dbg('Going to generate file-l_cursor-l_file->'||l_cursor);
    FOR i IN 1 .. l_col_cnt LOOP
      IF i > 1 THEN
        put(l_file, g_sep);
      END IF;

      -- Check if this is a string column.
      l_is_str := FALSE;
      IF l_desc_tab(i).col_type IN (DBMS_TYPES.typecode_varchar,
                                    DBMS_TYPES.typecode_varchar2,
                                    DBMS_TYPES.typecode_char,
                                    DBMS_TYPES.typecode_clob,
                                    DBMS_TYPES.typecode_nvarchar2,
                                    DBMS_TYPES.typecode_nchar,
                                    DBMS_TYPES.typecode_nclob) THEN
        l_is_str := TRUE;
      END IF;

      DBMS_SQL.COLUMN_VALUE(l_cursor, i, l_buffer);
	--dbg('Going to generate file-l_cursor-l_file->'||l_buffer);

      -- Optionally add quotes for strings.
      IF g_add_quotes AND l_is_str  THEN
        put(l_file, g_quote_char);
        put(l_file, l_buffer);
        put(l_file, g_quote_char);
      ELSE
        put(l_file, l_buffer);
      END IF;
    END LOOP;
    new_line(l_file);
  END LOOP;

  IF UTL_FILE.is_open(l_file) THEN
    UTL_FILE.fclose(l_file);
  END IF;
  DBMS_SQL.close_cursor(l_cursor);

  dbg('Generate_All Procedure :: End');

EXCEPTION
  WHEN OTHERS THEN
    IF UTL_FILE.is_open(l_file) THEN
      UTL_FILE.fclose(l_file);
    END IF;
    IF DBMS_SQL.is_open(l_cursor) THEN
      DBMS_SQL.close_cursor(l_cursor);
    END IF;
    dbg('ERROR: ' || DBMS_UTILITY.format_error_backtrace);
    RAISE;
END generate_all;


-- Alter separator from default.
PROCEDURE set_separator (p_sep  IN  VARCHAR2) AS
BEGIN
  g_sep := p_sep;
END set_separator;


-- Alter separator from default.
PROCEDURE set_quotes (p_add_quotes  IN  BOOLEAN := TRUE,
                      p_quote_char  IN  VARCHAR2 := '"') AS
BEGIN
  g_add_quotes := NVL(p_add_quotes, TRUE);
  g_quote_char := NVL(SUBSTR(p_quote_char,1,1), '"');
END set_quotes;


-- Handle put to file or screen.
PROCEDURE put (p_file  IN  UTL_FILE.file_type,
               p_text  IN  VARCHAR2) AS
BEGIN
  IF g_out_type = 'F' THEN
    UTL_FILE.put(p_file, p_text);
  ELSE
    DBMS_OUTPUT.put(p_text);
  END IF;
END put;


-- Handle newline to file or screen.
PROCEDURE new_line (p_file  IN  UTL_FILE.file_type) AS
BEGIN
  IF g_out_type = 'F' THEN
    UTL_FILE.new_line(p_file);
  ELSE
    DBMS_OUTPUT.new_line;
  END IF;
END new_line;

----Generate procedure is called from below proc 
Procedure GenerateCsvReports_Parallel(ipKeyString spresulttbl.keystring%type,
									 ipMainKeyString spresulttbl.keystring%type)
As

Cursor Cur_QuerryReportDtl 
Is
Select
    Task,
    SubTask,
    Queryid,
	FileName,
	Query_text1,
	Query_text2,
	Query_text3,
	DbDirectory,
	ColumnHeader,
	Separator,	
	QuoteChar
From PRALLEL_DM_QUERRYREPORTTBL 
Where Keystring      =   ipKeyString
 And (MainKeyString  =   ipMainKeyString Or ipMainKeyString Is Null);

Type Tbl_QuerryReportDtl_Ty Is Table Of Cur_QuerryReportDtl%ROWTYPE Index By Pls_Integer;
Tbl_QuerryReportDtl 	Tbl_QuerryReportDtl_Ty;

tQuery1     Varchar2(32000);
tQuery2     Varchar2(32000);
tCount	    Number := 0;
tsqlerrm    Varchar2(500);
tFileExists Number := 0;
v_limit     Number := 50000;
e_failure_forall Exception;
Pragma EXCEPTION_INIT (e_failure_forall, -24381);

PROCEDURE dbg(p_msg VARCHAR2) IS
  l_msg VARCHAR2(32767);
BEGIN
  l_msg := 'pkgMigGenCSVReports==>' || p_msg;
  DEBUG.PR_DEBUG('UT' ,L_MSG);
END dbg;

Begin

dbg('Inside GenerateCsvReports_Parallel Procedure :: Start');
dbg('----------ipkeystring----' || ipkeystring);
dbg('----------ipMainKeyString----' || ipMainKeyString);
dbg('----------g_col_header_on----' || g_col_header_on);
Update DM_QUERRYREPORTTBL a Set Status = 'N' where Exists (Select 1 
                                                           From PRALLEL_DM_QUERRYREPORTTBL b 
                                                           Where b.Queryid = a.Queryid
													         And b.Task = a.Task
													         And b.SubTask = a.SubTask
													      );
dbg('Successfully Updated '||SQL%ROWCOUNT||' record into DM_QUERRYREPORTTBL');
Commit;

If Cur_QuerryReportDtl%IsOpen Then
Close Cur_QuerryReportDtl;
End If;

Open Cur_QuerryReportDtl;
Loop
	Fetch Cur_QuerryReportDtl Bulk Collect
	Into Tbl_QuerryReportDtl Limit v_limit;
    Exit When Tbl_QuerryReportDtl.Count = 0;

	dbg('Tbl_QuerryReportDtl.Count :: '||Tbl_QuerryReportDtl.Count);
	If Tbl_QuerryReportDtl.Count > 0 Then 
		For Idx In Tbl_QuerryReportDtl.First .. Tbl_QuerryReportDtl.Last Loop
			Begin 
                dbg('Idx :: '||Idx);
				dbg(				'#> - ipkeystring#'||ipkeystring ||
									'- ipMainKeyString#'||ipMainKeyString||
									'-Running for queryid#'||Tbl_QuerryReportDtl(Idx).Queryid||
									'- Task#'||Tbl_QuerryReportDtl(Idx).Task ||
									'- SubTask#'||Tbl_QuerryReportDtl(Idx).SubTask ||									
									'- FileName#'|| Tbl_QuerryReportDtl(Idx).FileName) ;
                tQuery1 :=  Tbl_QuerryReportDtl(Idx).Query_text1||' '||Tbl_QuerryReportDtl(Idx).Query_text2||' '||Tbl_QuerryReportDtl(Idx).Query_text3; 
                dbg('tQuery1 :: '||tQuery1);

                tQuery2 := 'Select Count(1) From ('||REPLACE (tQuery1,';','') ||')';

                dbg(tQuery2);

                Update DM_QUERRYREPORTTBL Set Status = 'R',
                                              RecordCount = tCount,		
                                              DBSERVDATE = SYSTIMESTAMP,
                                              Start_Time = SYSDATE,
											  ErrorDesc	=''
                Where Queryid  = Tbl_QuerryReportDtl(Idx).Queryid
                  And Task     = Tbl_QuerryReportDtl(Idx).Task
                  And SubTask  = Tbl_QuerryReportDtl(Idx).SubTask;
                dbg('Successfully Updated '||SQL%ROWCOUNT||' record For Status = R into DM_QUERRYREPORTTBL');
				COMMIT;
                Execute Immediate tQuery2 Into tCount;

                dbg('tCount :: '||tCount);
                Update DM_QUERRYREPORTTBL Set RecordCount = tCount,		
                                              Total_Time = ROUND((SYSDATE-START_TIME)*1440,2)
                Where Queryid  = Tbl_QuerryReportDtl(Idx).Queryid
                  And Task     = Tbl_QuerryReportDtl(Idx).Task
                  And SubTask  = Tbl_QuerryReportDtl(Idx).SubTask;
                dbg('Successfully Updated '||SQL%ROWCOUNT||' record For Status = R into DM_QUERRYREPORTTBL');
                Commit;

                IF Tbl_QuerryReportDtl(Idx).FileName Is Not Null Then


                        dbg('Going to call Generate Procedure');
                        --g_out_type     := 'F';
                        --g_sep          := ',';
                        --g_add_quotes   := False;
                        --g_quote_char   := '';
                        --g_col_header_on:='Y';
						g_quote_char   	:= 	Tbl_QuerryReportDtl(Idx).QuoteChar;

						g_out_type     	:= 	'F';
						IF g_quote_char IS NULL THEN 
							g_add_quotes   := False;
						ELSE
							g_add_quotes   := TRUE;
						END IF;
						g_sep          	:= 	Tbl_QuerryReportDtl(Idx).Separator;
						--g_add_quotes   	:= 	Tbl_QuerryReportDtl(Idx).AddQuotes;
						g_col_header_on	:=	Tbl_QuerryReportDtl(Idx).ColumnHeader;


                        Generate(
                                p_dir   =>  Tbl_QuerryReportDtl(Idx).DbDirectory, --File output path
                                p_file  =>  Tbl_QuerryReportDtl(Idx).FileName, 
                                p_query =>  REPLACE (tQuery1,';','') ,-- tQuery1,
                                p_sep   =>  g_sep
                                );

                        dbg('Successfully Completed Generate Procedure');		

                        Select Dbms_Lob.FileExists(BFILENAME('GTAP_EXTERNAL_DIR', Tbl_QuerryReportDtl(Idx).FileName)) Into tFileExists From Dual;
                        dbg('tFileExists :: '||tFileExists);

                        Update DM_QUERRYREPORTTBL Set Status     = 'C',
                                                      End_Time   = SYSDATE,
                                                      Total_Time = ROUND((SYSDATE-START_TIME)*1440,2)
                        Where Queryid = Tbl_QuerryReportDtl(Idx).Queryid
                          And Task    = Tbl_QuerryReportDtl(Idx).Task
                          And SubTask = Tbl_QuerryReportDtl(Idx).SubTask;					
                        dbg('Successfully Updated '||SQL%ROWCOUNT||' record For Status = C into DM_QUERRYREPORTTBL');
                        Commit; 
			    End If;
            Exception

                When Others Then
                dbg('Inside when others while calling pkgMigGenCSVReports.generate : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                tsqlerrm := Substr(sqlerrm,1,250);
                dbg(tsqlerrm);
				Begin
					Update DM_QUERRYREPORTTBL Set Status= 'A', 
												End_Time   = SYSDATE,
												Total_Time = ROUND((SYSDATE-START_TIME)*1440,2),
												ErrorDesc = substr(tsqlerrm||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE,1,250)
					Where Queryid = Tbl_QuerryReportDtl(Idx).Queryid
					  And Task    = Tbl_QuerryReportDtl(Idx).Task
					  And SubTask = Tbl_QuerryReportDtl(Idx).SubTask;
				Exception
                When Others Then					  
				dbg(tsqlerrm);
				end;
                dbg('Successfully Updated '||SQL%ROWCOUNT||' record For Status = A into DM_QUERRYREPORTTBL');
            Commit;
            End;
		End Loop;
	End If;

End Loop;
Close Cur_QuerryReportDtl;

dbg('Inside GenerateCsvReports_Parallel Procedure :: End');

Exception
    When e_failure_forall Then
	   dbg('Inside Bulk Exception when others of GenerateCsvReports_Parallel: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
       dbg (Sqlerrm);
       dbg ( 'Updated ' || Sql%RowCount || ' rows.');

       For idx In 1 .. Sql%Bulk_Exceptions.Count
       Loop
          dbg (
                'Error '  || idx ||
				' occurred on index '  || Sql%Bulk_Exceptions (idx).Error_Index ||
				' Oracle error message is  ' || Sqlerrm ( -1 * Sql%Bulk_Exceptions (idx).Error_Code));
       End Loop;

	When Others Then
		dbg('Inside when others of GenerateCsvReports_Parallel: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
		dbg ('Exception in when others of GenerateCsvReports_Parallel:: '||Sqlerrm);
End GenerateCsvReports_Parallel;

----This CSV Report Generation Starts from here
Procedure SpCSVReportExport_wrap(ipTask              dm_querryreporttbl.Task%type,
                                 ipKeyString    	 spresulttbl.keystring%type,
								 ipAppdate      	 date,
								 ipModuleid     	 MODULEPROFILETBL.MODULEID%Type,
								 ipparllelflag  	 number default 1,
								 ipMainkeystring     spresulttbl.keystring%type default null
								)
As
    Type JobRec is Record
	(
	  FundGroup 	Parallelallocationtxntbl.FundGroup%Type,
      JobNum    	User_scheduler_jobs.job_name%TYPE,
      KeyString 	SpResultTbl.Keystring%Type,
      MainKeyString 	SpResultTbl.Keystring%Type
	  );

    Type JobRecTbl is Table of JobRec Index By Binary_Integer;
    tJobs     JobRecTbl;

	tErrOccured 	Boolean := false;
    lclcount    	Integer;
    strJOB    		Varchar2(4000);
    tjobCount 		Integer;
    opJobNum    	User_scheduler_jobs.job_name%Type;
    spErrorCode 	spResultTbl.ErrorCode%Type;
    spErrorNum  	Number(10);
    spErrorProc 	spResultTbl.ProcedureName%Type;
    spErrorMsg  	spResultTbl.Description%Type;
    pkgNumProcs 	Integer;
    pkgSleep    	Integer;
	pkgKeystring 	SpResultTbl.Keystring%Type;
	tRecCount 		Number := 0;

BEGIN

    dbg('----------Main Procedure Starts SpCSVReportExport_wrap-------------');
	dbg('----------ipTask----' || ipTask);
    dbg('----------ipkeystring----' || ipkeystring);
    dbg('----------ipAppDate----' || ipAppDate);
    dbg('----------ipparllelflag----' || ipparllelflag);
    dbg('----------ipmoduleid----' || ipmoduleid);

    pkgKeystring := ipKeystring;

    dbg('Going to insert data into PRALLEL_DM_QUERRYREPORT_HISTBL');
	Insert Into PRALLEL_DM_QUERRYREPORT_HISTBL(Select * From PRALLEL_DM_QUERRYREPORTTBL);
	Commit;

	dbg('Going to delete data from PRALLEL_DM_QUERRYREPORTTBL');
	--Execute Immediate 'Truncate Table PRALLEL_DM_QUERRYREPORTTBL';
	Delete From PRALLEL_DM_QUERRYREPORTTBL;
	Commit;

    IF ipParllelFlag <> 0 THEN

        dbg('Going to insert data into AsyncProcessTbl');
        Insert Into AsyncProcessTbl(Activity, ActivityFlag)
        values ('POPULATECSVREPORTS', 'R');

        dbg('check if any other POPULATECSVREPORTS process is running');
        /* Check in Async process table */
        Select Count(*)
            Into lclcount
            From AsyncProcessTbl
        Where Activity = 'POPULATECSVREPORTS';

        dbg('lclcount :: '||lclcount);
        If lclcount > 1 Then
            spInsertResultTbl('I-WARNING',
                            '',
                            'Populate CSVReports Result Set Process already running',
                            'SpCSVReportExport_wrap',
                            ipKeystring,
                            20043
                            );
            Commit;
            Return;
        End If;

        dbg('get the no. of jobs to be submitted');
        Begin
            Select Paramvalue
            Into pkgNumProcs
            From Paramstbl
            Where Paramcode = 'PROCESSORCOUNT'
            And ParamLanguage = (Select DefaultLanguage
                                    From DefaultsTbl
                                    Where FPKey = ipModuleId);
        Exception
            When NO_DATA_FOUND Then
            pkgNumProcs := 1;
        End;
        dbg('pkgNumProcs----->' || pkgNumProcs);

        if pkgNumProcs=1 then
            pkgNumProcs:=15;
        end if;

		dbg('pkgNumProcs----->' || pkgNumProcs);

        dbg('get the sleep interval');
        Begin
            Select To_Number(PARAMVALUE)
            into pkgSleep
            from PARAMSTBL
            where PARAMCODE = 'SLEEPINTERVAL'
            And ParamLanguage = (Select DefaultLanguage
                                    From DefaultsTbl
                                    Where FPKey = ipModuleId);
        Exception
            When NO_DATA_FOUND Then
            pkgSleep := 60; /*Seconds*/
        End;
        dbg('pkgSleep----->' || pkgSleep);

        Begin
            dbg('Going to insert data into PRALLEL_DM_QUERRYREPORTTBL');
            Insert Into PRALLEL_DM_QUERRYREPORTTBL
            (groupby, Task, SubTask, Queryid, Query_text1, Query_text2, Query_text3, FileName, DbDirectory, Keystring, MainKeystring, ColumnHeader, Separator, QuoteChar)
            Select ntile(pkgNumProcs) over(Order By Queryid) As groupby,
			       Task,
				   SubTask,
			       Queryid,
                   Query_text1,
                   Query_text2,
				   Query_text3,
				   FileName,
				   DbDirectory,
                   'P-' || ntile(pkgNumProcs) over(Order By Queryid) || '-' || ipKeyString,
                   ipKeyString,
				   ColumnHeader,
				   Separator,
				   QuoteChar
                From DM_QUERRYREPORTTBL
				Where Task = Decode(ipTask,'ALL',Task,ipTask); --Pricking all the eligible records based on task

            dbg(' in others----------' || SQL%ROWCOUNT);
            tRecCount := SQL%ROWCOUNT;
            dbg('tRecCount-->'||tRecCount);
            commit;
        Exception
            When Others Then
            dbg(' in others----rolling back ------' || Sqlerrm);
            Rollback;
        End;

        --Execute Immediate 'Alter session disable parallel dml';
        dbg('ipKeyString----'||ipKeyString);
        Select Distinct GroupBy, 0 JobNum, KeyString, MainKeyString Bulk Collect
        Into tJobs
        From PRALLEL_DM_QUERRYREPORTTBL a
        Where a.mainKeystring = ipKeyString;
        dbg('tJobs.Count----'||tJobs.Count);

      If tJobs.Count > 0 Then
        SAVEPOINT PARALLELMODPORT;
        For i in tJobs.First .. tJobs.Last Loop
        pkgKeyString := tJobs(i).KeyString;

        strJOB:='';
/*		strJOB       := strJOB || q'[BEGIN 
                                      pkgMigGenCSVReports.g_out_type     := 'F';
                                      pkgMigGenCSVReports.g_sep          := ',';
                                      pkgMigGenCSVReports.g_add_quotes   := False;
                                      pkgMigGenCSVReports.g_quote_char   := '';
                                      pkgMigGenCSVReports.g_col_header_on:='Y';                            
                                    ]';
*/        strJOB       := strJOB || 'BEGIN pkgMigGenCSVReports.GenerateCsvReports_Parallel(';
          strJOB       := strJOB || '''' || tJobs(i).KeyString || '''' || ',' ;
          strJOB       := strJOB || '''' || tJobs(i).Mainkeystring || ''''  ;--- main keystring
          strJOB       := strJOB || '); End;';
          dbg('strJOB------>' || strJOB);
          dbg('----SpCSVReportExport_wrap---');


          dbg('strJOB------>' || strJOB);
          Dbg('----SpRoytrinExport_wrap---');

          spCmnSubmitJob(pkgKeyString,
                         'PARALLEL CSV REPORTS',
                         'SYSADMIN',
                         ipModuleID,
                         strJOB,
                         opjobnum,
                         spErrorCode,
                         spErrorMsg,
                         'Y');
          dbg('mmm----SpCSVReportExport_wrap--opjobnum-' || opjobnum);
          dbg('mmm----SpCSVReportExport_wrap--spErrorCode-' || spErrorCode);
          dbg('mmm----SpCSVReportExport_wrap--spErrorMsg-' || spErrorMsg);
          tJobs(i).JobNum := opjobnum;
        End Loop;
        Commit;
        Loop
          dbms_lock.sleep(pkgSleep);
          tjobCount := 0;
          For i IN tJobs.First .. tJobs.Last Loop
            Begin
              dbg('Inside Normal Loop tJobs(i).JobNum ' || tJobs(i).JobNum||'-tjobCount-'||tjobCount);

              Select 1 + tjobCount
                Into tjobCount
                From User_scheduler_jobs
               Where JOB_NAME = tJobs(i).JobNum;
            Exception
              When NO_DATA_FOUND Then
                dbg('Inside No Data Found Exception 111 ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                Begin
                  Select 1 + tjobCount
                    Into tjobCount
                    From user_scheduler_running_jobs
                   Where JOB_NAME = tJobs(i).JobNum;
                Exception
                  When NO_DATA_FOUND Then
                    dbg('Inside No Data Found Exception 222 ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                    NULL;
                  When Others Then
                    dbg('Inside When other Exception 333 ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                    tjobCount := tjobCount + 1;
                End;
              When Others Then
                dbg('Inside When other Exception 444 ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
                tjobCount := tjobCount + 1;
            End;

            dbg('Inside after Normal Loop tJobs(i).JobNum ' || tJobs(i).JobNum||'-tjobCount-'||tjobCount);
            IF tjobCount > 0 Then
              Exit;
            End IF;
          End Loop;
          Exit When tjobCount = 0;
        End Loop;
        tErrOccured := False;
        For i IN tJobs.First .. tJobs.Last Loop
          spErrorCode := '';
          spErrorMsg  := '';
          spErrorProc := '';
          BEGIN
            Select ErrorCode, Description, Errornumber
              Into spErrorCode, spErrorMsg, spErrorNum
              From SpResultTbl
             Where KeyString = tJobs(i).KeyString;
          Exception
            When Others Then
              dbg('other--' || Sqlerrm);
              spErrorCode := 'E-NOTFOUND';
          End;
          If spErrorCode <> 'I-SUCCESS' Then
            spInsertResultTbl(spErrorCode,
                              '',
                              spErrorMsg,
                              'SpCSVReportExport_wrap',
                              ipKeyString,
                              spErrorNum);
            tErrOccured := True;
            Exit When tErrOccured;
          End If;
        End Loop;
        tJobs.Delete;
      End If;

      dbg('Going to delete data from AsyncProcessTbl');
      Delete From AsyncProcessTbl Where Activity = 'POPULATECSVREPORTS';
      Delete From AsyncProcessTbl Where Activity = 'ROYTRINEXPORT';
      Commit;

      If Not tErrOccured Then

        spInsertResultTbl('I-SUCCESS',
                          '',
                          'SpCSVReportExport_wrap Successful',
                          'SpCSVReportExport_wrap',
                          ipKeyString,
                          20043
                         );

        dbg('----------Main Procedure SpCSVReportExport_wrap Ends Here-------------');
        spInsertResultTbl('I-SUCCESS',
                          '',
                          substr(sqlerrm, 1, 255),
                          'SpCSVReportExport_wrap',
                          ipKeystring,
                          20043
						 );
		End IF;
   Else
        dbg('----------Job Procedure SpCSVReportExport starts Here--------ipKeyString---'||ipKeyString||'--ipMAINKEYSTRING---'||ipMAINKEYSTRING);
		dbg('ipMAINKEYSTRING :: ' || ipMAINKEYSTRING);
		---This query is for non parallel
		Begin
			dbg('Going to insert data into PRALLEL_DM_QUERRYREPORTTBL No Parallel');
			Insert Into PRALLEL_DM_QUERRYREPORTTBL
			(groupby, Task, SubTask, Queryid, Query_text1, Query_text2, Query_text3, FileName, DbDirectory, Keystring, MainKeystring, ColumnHeader, Separator, QuoteChar)
			Select 
				Null,
				Task,
				SubTask,
				Queryid,
				Query_text1,
				Query_text2,
				Query_text3,
				FileName,
				DbDirectory,
				ipKeyString,
				ipMAINKEYSTRING,
				ColumnHeader,
				Separator, 	
				QuoteChar
			From DM_QUERRYREPORTTBL
			Where Task = Decode(ipTask,'ALL',Task,ipTask); --Pricking all the eligible records based on Task

		    dbg('No Parallel in others----------' || SQL%ROWCOUNT);
            tRecCount := SQL%ROWCOUNT;
            dbg('No Parallel tRecCount-->'||tRecCount);
            commit;
        Exception
            When Others Then
            dbg(' in others----rolling back ------' || Sqlerrm);
            Rollback;
        End;
	
			dbg('Caling GenerateCsvReports_Parallel for non parallel reports');
            GenerateCsvReports_Parallel(ipKeyString, ipMAINKEYSTRING);

        dbg('----------Job Procedure SpCSVReportExport end Here--------ipKeyString---'||ipKeyString||'--ipMAINKEYSTRING---'||ipMAINKEYSTRING);
    End if;
EXCEPTION
    When Others Then
      RollBack;
      Delete From AsyncProcessTbl
       Where Activity = 'POPULATECSVREPORTS';
      spInsertResultTbl('E-ERROR',
                        '',
                        Substr(Sqlerrm, 1, 255),
                        'SpCSVReportExport_wrap',
                        ipKeystring,
                        20043);
      Commit;
END SpCSVReportExport_wrap;

END pkgMigGenCSVReports;
/
