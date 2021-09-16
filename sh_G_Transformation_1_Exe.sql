#!/usr/bin/env bash

start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
#export login_STAGE="GTASTGPA1/wOqEKnOsBB4L6y9N@//20079861.HDEV:2001/11.HDEV"
#export login_LOB="GTAUKTR1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
#export trnsf_loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Transformation/Execution"
#export migspoolloc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts"
#export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MDR5/MigrationSpools"
#export logtime="$(date -u +%d%h%y_%T)"
#export ext=".log"
logfile=""$spoolloc"/"$logtime"_Transformation_Exe1"$ext""

echo "Started Transformation Execution 1 at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe1"$ext"
prog_start_time="$(date -u +%s.%N)"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Exe_Start"$ext"
@$trnsf_loc/Transformation_Exe_Start.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for Transformation_Exe_Start" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe1"$ext"
prog_start_time="$(date -u +%s.%N)"
###sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_DST_Index_Exe"$ext" &
###@$trnsf_loc/Transformation_DST_Index_Exe.sql $migspoolloc
###EOF
###sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_DSTTablesGatherStats_Exe"$ext" &
###@$trnsf_loc/Transformation_DSTTablesGatherStats_Exe.sql $migspoolloc
###EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_InsertScripts_Exee"$ext" &
@$trnsf_loc/Transformation_InsertScripts_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_AdocScripts"$ext" &
@$trnsf_loc/Transformation_AdocScripts.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Pre_Maintenance_Exe"$ext" &
@$trnsf_loc/Transformation_Pre_Maintenance_Exe.sql $migspoolloc
EOF
wait
if [ -z "$tableparallel" ]
then
     echo "\$tableparallel tableparallel is empty and Table will remain parallel"
else
     echo "\$tableparallel tableparallel is non empty"
	if [ $tableparallel == "N" ]
	then
		echo " Tables will now be made non parallel"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_STG_REMOVE_TABLE_PARALLEL"$ext" &
@$trnsf_loc/STG_REMOVE_TABLE_PARALLEL.sql $migspoolloc
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Disable_Referential_Constraints"$ext"
@$constraints_loc/LOB_REMOVE_TABLE_PARALLEL.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----LOB_REMOVE_TABLE_PARALLEL-----*-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
	else 
		echo "tableparallel is $tableparallel   and Tables will remain parallel"
	fi
fi
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for DSTgatherStats, DSTIndex, InsertScripts, AdocScripts, PreMaintenance" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe1"$ext"
prog_start_time="$(date -u +%s.%N)"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Unitholder_Reference_Exe"$ext" &
@$trnsf_loc/Transformation_Unitholder_Reference_Exe.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Entities_Reference_Exe"$ext" &
@$trnsf_loc/Transformation_Entities_Reference_Exe.sql $migspoolloc
EOF
wait
echo " Echo Getting Table_wise_counts in process" |& tee -a "$logfile"
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc TRFM_1
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc TRFM_1
EOF
sqlplus "$login_SMS" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SMS]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc TRFM_1
EOF
sqlplus "$login_SP" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SP]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc TRFM_1
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for Unitholder and Entities Reference Table Loading" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe1"$ext"
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe1"$ext"
echo "Ended Transformation Execution 1 at:::"$(date)"" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe1"$ext"
rsync -av "$migspoolloc/Spool" "$spoolloc"
echo "Starting Error checking in the spools folder....." 
for file in "$migspoolloc/Spool/Transformation"/*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "completed G_Transformation_1_Exe.sh.sh.....:::"$(date)"" 
#nohup bash /gtaplocal/GTAP_MDR_INFILES/Transformation_Exe.sh &