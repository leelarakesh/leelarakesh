

Set SErveroutput On
Begin
	pkgGlobal.pr_Init (ipModuleId => 'FMGUKTR',ipUserId => '45013915A');	
	Global.pr_Init (pm_branch => '000', pm_user => '45013915A');
	
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

