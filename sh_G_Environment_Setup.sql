#!/usr/bin/env bash
start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
#export login_STAGE="GTASTGPA1/wOqEKnOsBB4L6y9N@//20079861.HDEV:2001/11.HDEV"
#export login_LOB="GTAUKTR1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
#export migspoolloc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts"
#export fxtblloc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Transformation_Mig_Scripts/Transformation_Environment/DDL_SCRIPTS"
#export dmtblloc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Environment/Execution"
#export statsloc="/gtaplocal/GTAP_MDR_INFILES/MDR6/DMP_STATS"
#export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MDR6/MigrationSpools"
#export logtime="$(date -u +%d%h%y_%T)"
#export ext=".log"
AUTO_logfile=""$spoolloc"/"$RUNENV"_AUTO_SYN_GRANTS_"$logtime""$ext""
logfile=""$spoolloc"/Environment_Setup_"$logtime""$ext""


echo "Started execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
prog_start_time="$(date -u +%s.%N)"
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunTimes"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
TRUNCATE TABLE DM_TIMETRACKINGTBL;
CREATE TABLE DM_TIMETRACKINGTBL
(
  MIGFILETYPE 			VARCHAR2(3) NOT NULL,	
  TASK					VARCHAR2(255),
  APPDATE				DATE,
  DBSERVDATE			TIMESTAMP,
  START_TIME			DATE,
  END_TIME				DATE,
  TOTAL_TIME			VARCHAR2(100),
  TASKNUMBER            NUMBER GENERATED ALWAYS AS IDENTITY(START WITH 1 INCREMENT BY 1)
);
DELETE FROM DM_TIMETRACKINGTBL WHERE MIGFILETYPE ='TOL' AND TASK='TOTAL_ENVIRONMENT_CREATION_TIME';
COMMIT;
INSERT INTO DM_TIMETRACKINGTBL(MIGFILETYPE,TASK,APPDATE,DBSERVDATE,START_TIME,END_TIME,TOTAL_TIME)
VALUES('TOL','TOTAL_ENVIRONMENT_CREATION_TIME',(SELECT DATETODAY FROM SYSPARAMTBL),SYSTIMESTAMP,SYSDATE,NULL,NULL);
COMMIT;
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
DROP TABLE DM_TABLE_COUNTS;
CREATE TABLE DM_TABLE_COUNTS
(    schema_owner    VARCHAR2(30),
    TableName 	    VARCHAR2(30),
    Counts			NUMBER,
    activity		VARCHAR2(30),
    timestamp		timestamp	
);
grant all on DM_TABLE_COUNTS to GTAUKTR1,GTASMPA1,GTASPPA1,GTASTGPA1;
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc ENV
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc ENV
EOF
sqlplus "$login_SMS" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SMS]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc ENV
EOF
sqlplus "$login_SP" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SP]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc ENV
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext"
@$dmtblloc/recompilation.SQL $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Drop_Mint_Tables"$ext" &
@$fxtblloc/Drop_Script.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Create_Mint_Tables"$ext" &
@$fxtblloc/Create_Table.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Create_DM_Tables"$ext" &
@$dmtblloc/CombinedLOBTables.Sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunInStaging_Processes"$ext" &
@$dmtblloc/RunInStaging_Processes.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Staging_recompilation"$ext" &
@$dmtblloc/recompilation.SQL $migspoolloc
EOF
sqlplus "$login_SMS" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunInSMS_Processes"$ext" &
@$dmtblloc/RunInSMS_Processes.sql $migspoolloc
EOF
wait
echo "Started execution autosyn grants at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
./G_Auto_Syn_Grants.sh |& tee -a $AUTO_logfile & disown -h
wait
echo "completed  execution autosyn grants at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_MIGSource_Compilation"$ext" &
@$dmtblloc/MIGSource_Compilation.sql $migspoolloc
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunInLOB_Processes"$ext" &
@$dmtblloc/RunInLOB_Processes.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunTimes"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
UPDATE DM_TIMETRACKINGTBL SET END_TIME = SYSDATE, TOTAL_TIME = ROUND((SYSDATE-START_TIME)*1440,2)
WHERE MIGFILETYPE ='TOL'AND TASK ='TOTAL_ENVIRONMENT_CREATION_TIME';
COMMIT;
EOF
wait
echo "Started execution autosyn grants at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
./G_Auto_Syn_Grants.sh |& tee -a $AUTO_logfile & disown -h
wait
echo "completed  execution autosyn grants at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"

end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for FX and DM table creation" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
prog_start_time="$(date -u +%s.%N)"
imp "$login_STAGE" FILE="$statsloc"/GTASTGPA1_11_STAT.dmp TABLES=GTASTGPA1_11_STAT IGNORE=Y |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
imp "$login_LOB" FILE="$statsloc"/GTAUKTR1_11_STAT.dmp TABLES=GTAUKTR1_11_STAT IGNORE=Y |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for Table Stats Import" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
echo "Ended Execution at:::"$(date)"" |& tee -a "$spoolloc"/Environment_Setup_"$logtime""$ext"
rsync -av "$migspoolloc/Spool" "$spoolloc"
echo "Starting Error checking in the spools folder....." 
for file in "$migspoolloc/Spool/Environment"/*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "completed G_Environment_Setup.sh.....:::"$(date)"" 
#nohup bash /gtaplocal/GTAP_MDR_INFILES/Environment_Setup.sh &
