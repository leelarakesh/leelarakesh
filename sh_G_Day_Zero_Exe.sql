#!/usr/bin/env bash
start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"

prog_start_time="$(date -u +%s.%N)"
echo "Started Day Zero Execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/"$logtime"_DayZero_Exe"$ext"

#sqlplus "$login_LOB" <<EOF |sed  's/^/[SIGEN]/' |& tee -a "$spoolloc"/"$logtime"_SIStatus"$ext" &
#@$dayzero_loc/SIStatus.sql $migspoolloc
#prompt SIStatus completed 
#EOF
#sqlplus "$login_LOB" <<EOF|sed  's/^/[DIVGEN]/' |& tee -a "$spoolloc"/"$logtime"_DIV_STUB"$ext" &
#@$dayzero_loc/DIV_STUB.sql $migspoolloc
#prompt DIV_STUB completed 
#EOF
sqlplus "$login_LOB" <<EOF|sed  's/^/[TXNC]/' |& tee -a "$spoolloc"/"$logtime"_InsertTxnComponent_Custom_J2EE"$ext" &
@$dayzero_loc/InsertTxnComponent_Custom_J2EE.sql $migspoolloc
prompt InsertTxnComponent_Custom_J2EE completed 
EOF
wait
#sqlplus "$login_LOB" <<EOF|sed  's/^/[ARC]/' |& tee -a "$spoolloc"/"$logtime"_ACCRUAL_STUB"$ext" &
#@$dayzero_loc/ACCRUAL_STUB.sql $migspoolloc
#prompt ACCRUAL_STUB completed 
#EOF
#wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for Day Zero Execution" |& tee -a "$spoolloc"/"$logtime"_DayZero_Exe"$ext"
echo "Ended Day Zero Execution at:::"$(date)"" |& tee -a "$spoolloc"/"$logtime"_DayZero_Exe"$ext"
rsync -av "$migspoolloc/Spool" "$spoolloc"
echo "Starting Error checking in the spools folder....." 
for file in "$migspoolloc/Spool/Migration"/*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "completed G_Day_Zero_Exe.sh.....:::"$(date)"" 
#$ nohup parallel_sh.sh