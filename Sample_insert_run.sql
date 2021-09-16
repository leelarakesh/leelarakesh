
--Consolidated Error Log Report
Insert into DM_QUERRYREPORTTBL (TASK,SUBTASK,MODULE,QUERYID,QUERY_TEXT1,QUERY_TEXT2,QUERY_TEXT3,RECORDCOUNT,FILENAME,DBDIRECTORY,ENABLED,FILEGENERATED,STATUS,DBSERVDATE,START_TIME,END_TIME,TOTAL_TIME,ERRORDESC,COLUMNHEADER,SEPARATOR,QUOTECHAR) 
values ('PREMIG','Consolidated Pre Migration Errors Report','ALL',3,
q'[Select  
     MIGRATIONFILETYPE,
     FIELDNAME,
     ERRORCODE,
     COUNT(*),
    (SELECT ErrorMessage FROM DM_ERRORMSGTBL e WHERE e.errorcode=m.errorcode)  	
  From dm_migrationerrorlogtbl m
  GROUP BY MIGRATIONFILETYPE,FIELDNAME,ERRORCODE ORDER BY MIGRATIONFILETYPE]'
,null,null,null,'ConsolidatedPreMigErrorsReport.csv','HDEV_UKTR_MT_OUT_ARCH',null,null,null,null,null,null,null,null,'Y',',','"');


Begin
	pkgGlobal.pr_Init (ipModuleId => 'FMGUKTR',ipUserId => '45013915');	
	Global.pr_Init (pm_branch => '000', pm_user => '45013915');
	
	Dbms_Output.Put_Line('Parallel Execution Begin');
	
	pkgMigGenCSVReports.SpCSVReportExport_wrap(ipTask   		=>	'ALL', 		    			---Task id(e.g.. 'ALL',PRETRNF,'TRNF','PREMIG','MIG','CPM' for Related Party)
                                               ipKeyString		=>	'KY'||To_Char(Sysdate,'DDMONYYYY HH24:MI:SS'),     	---Any value(e.g.. DDMONYYYY||Task 18JUL2019TRANSFER)
											   ipAppdate    	=>	Sysdate,          			---Give Sysdate,
								               ipModuleid		=>  'FMGUKTR',   				---In which Module it should execute either in FMGUKTR or AGYUKTR
								               ipparllelflag	=>  1,							---If Parallel execution required then provide 1 else 0
								               ipMainkeystring	=>  Null						---Optional, This will generated during parallel query
						                      );
											  
	Dbms_Output.Put_Line('Parallel Execution End');
Exception
	When Others Then
	Dbms_Output.Put_Line(Sqlerrm);
	Dbms_Output.Put_Line('Inside When Others Exception : ' || Dbms_Utility.Format_Error_Backtrace);
	
End;
/

Set Serveroutput On
Begin
	pkgGlobal.pr_Init (ipModuleId => 'FMGUKTR',ipUserId => '45013915');	
	Global.pr_Init (pm_branch => '000', pm_user => '45013915');
	
	Dbms_Output.Put_Line('Parallel Execution Begin');
	
	pkgMigGenCSVReports.SpCSVReportExport_wrap(ipTask   		=>	'PRETRANSFORMATION_MIGREP', 		    			---Task id(e.g.. 'ALL',PRETRNF,'TRNF','PREMIG','MIG','CPM' for Related Party)
                                               ipKeyString		=>	'KY'||To_Char(Sysdate,'DDMONYYYY HH24:MI:SS'),     	---Any value(e.g.. DDMONYYYY||Task 18JUL2019TRANSFER)
											   ipAppdate    	=>	Sysdate,          			---Give Sysdate,
								               ipModuleid		=>  'FMGUKTR',   				---In which Module it should execute either in FMGUKTR or AGYUKTR
								               ipparllelflag	=>  1,							---If Parallel execution required then provide 1 else 0
								               ipMainkeystring	=>  Null						---Optional, This will generated during parallel query
						                      );
											  
	Dbms_Output.Put_Line('Parallel Execution End');
Exception
	When Others Then
	Dbms_Output.Put_Line(Sqlerrm);
	Dbms_Output.Put_Line('Inside When Others Exception : ' || Dbms_Utility.Format_Error_Backtrace);
	
End;
/

Set Serveroutput On
Begin
	pkgGlobal.pr_Init (ipModuleId => 'FMGUKTR',ipUserId => '45013915');	
	Global.pr_Init (pm_branch => '000', pm_user => '45013915');
	
	Dbms_Output.Put_Line('Parallel Execution Begin');
	
	pkgMigGenCSVReports.SpCSVReportExport_wrap(ipTask   		=>	'POSTTRANSFORMATION_MIGREP', 		    			---Task id(e.g.. 'ALL',PRETRNF,'TRNF','PREMIG','MIG','CPM' for Related Party)
                                               ipKeyString		=>	'KY'||To_Char(Sysdate,'DDMONYYYY HH24:MI:SS'),     	---Any value(e.g.. DDMONYYYY||Task 18JUL2019TRANSFER)
											   ipAppdate    	=>	Sysdate,          			---Give Sysdate,
								               ipModuleid		=>  'FMGUKTR',   				---In which Module it should execute either in FMGUKTR or AGYUKTR
								               ipparllelflag	=>  1,							---If Parallel execution required then provide 1 else 0
								               ipMainkeystring	=>  Null						---Optional, This will generated during parallel query
						                      );
											  
	Dbms_Output.Put_Line('Parallel Execution End');
Exception
	When Others Then
	Dbms_Output.Put_Line(Sqlerrm);
	Dbms_Output.Put_Line('Inside When Others Exception : ' || Dbms_Utility.Format_Error_Backtrace);
	
End;
/

Set Serveroutput On
Begin
	pkgGlobal.pr_Init (ipModuleId => 'FMGUKTR',ipUserId => '45013915');	
	Global.pr_Init (pm_branch => '000', pm_user => '45013915');
	
	Dbms_Output.Put_Line('Parallel Execution Begin');
	
	pkgMigGenCSVReports.SpCSVReportExport_wrap(ipTask   		=>	'POSTMIGRATION_MIGREP', 		    			---Task id(e.g.. 'ALL',PRETRNF,'TRNF','PREMIG','MIG','CPM' for Related Party)
                                               ipKeyString		=>	'KY'||To_Char(Sysdate,'DDMONYYYY HH24:MI:SS'),     	---Any value(e.g.. DDMONYYYY||Task 18JUL2019TRANSFER)
											   ipAppdate    	=>	Sysdate,          			---Give Sysdate,
								               ipModuleid		=>  'FMGUKTR',   				---In which Module it should execute either in FMGUKTR or AGYUKTR
								               ipparllelflag	=>  1,							---If Parallel execution required then provide 1 else 0
								               ipMainkeystring	=>  Null						---Optional, This will generated during parallel query
						                      );
											  
	Dbms_Output.Put_Line('Parallel Execution End');
Exception
	When Others Then
	Dbms_Output.Put_Line(Sqlerrm);
	Dbms_Output.Put_Line('Inside When Others Exception : ' || Dbms_Utility.Format_Error_Backtrace);
	
End;
/
