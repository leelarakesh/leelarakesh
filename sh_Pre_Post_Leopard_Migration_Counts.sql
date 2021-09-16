#!/usr/bin/env bash
start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
#MDRECS
export login_STAGE="GTASTGPA1/x3sf&*?543_yw?pp@//20097423.HDEV:2001/14.HDEV"
export login_LOB="GTAUKTR1/atWvYJf8NciNg38k@//20097423.HDEV:2001/14.HDEV"
export login_SMS="GTASMPA1/atWvYJf8NciNg38k@//20097423.HDEV:2001/14.HDEV"
export login_SP="GTASPPA1/atWvYJf8NciNg38k@//20097423.HDEV:2001/14.HDEV"
#MDR2
#export login_STAGE="GTASTGPA1/x3sf&*?543_yw?pp@//20079861.HDEV:2001/11.HDEV"
#export login_LOB="GTAUKTR1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
#export login_SMS="GTASMPA1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
#export login_SP="GTASPPA1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
export migspoolloc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts"
export dmtblloc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Adhoc_Executions/LeopardCountsDMTableBackupScripts"
export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MINT_FILES/MDR2/MigrationSpools"
export logtime="$(date -u +%d%h%y_%T)"
export ext=".log"
#export activity="PREGC"
#export activity="POSTGC"
export activity="POSTGTA"
#export ext="POSTMIG"
logfile=""$spoolloc"/Leopord_Table_Backup_Counts_"$logtime""$ext""

start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
echo "Started execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/Leopard_Table_Backup"$logtime""$ext"
prog_start_time="$(date -u +%s.%N)"
#sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"Leopard_Table_Backup"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
#@$dmtblloc/pr_backup_table_custom.prc $migspoolloc
#EOF
#wait
#sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"Leopard_Table_Backup"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
#@$dmtblloc/DM_LEOPARD_DATA_BACKUP_TABLES.sql $migspoolloc
#EOF
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/Leopard_Table_Backup"$logtime""$ext"
echo "Ended Execution at:::"$(date)"" |& tee -a "$spoolloc"/Leopard_Table_Backup"$logtime""$ext"

start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
echo "Started execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/_Leopord_Counts_"$logtime""$ext"
prog_start_time="$(date -u +%s.%N)"
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Leopord_Counts_"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
CREATE TABLE PRE_POST_LEOPARD_TABLE_COUNTS
( schema_owner    VARCHAR2(30),
  TableName 	  VARCHAR2(30),
  Counts		  NUMBER,
  activity		  VARCHAR2(30),
  timestamp		  timestamp	
);
grant all on PRE_POST_LEOPARD_TABLE_COUNTS to GTAUKTR1,GTASMPA1,GTASPPA1,GTASTGPA1;
#@$dmtblloc/SCHEMA_PRE_POST_LEOPARD_TABLE_COUNTS.sql $migspoolloc "$activity"
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Leopord_Counts_"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_PRE_POST_LEOPARD_TABLE_COUNTS.sql $migspoolloc "$activity"
EOF
sqlplus "$login_SMS" <<EOF|& tee -a "$spoolloc"/"$logtime"_Leopord_Counts_"$ext" |sed  's/^/[SMS]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_PRE_POST_LEOPARD_TABLE_COUNTS.sql $migspoolloc "$activity"
EOF
sqlplus "$login_SP" <<EOF|& tee -a "$spoolloc"/"$logtime"_Leopord_Counts_"$ext" |sed  's/^/[SP]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_PRE_POST_LEOPARD_TABLE_COUNTS.sql $migspoolloc "$activity"
EOF

end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/_Leopord_Counts_"$logtime""$ext"
echo "Ended Execution at:::"$(date)"" |& tee -a "$spoolloc"/_Leopord_Counts_"$logtime""$ext"
rsync -av "$migspoolloc/Spool" "$spoolloc"
