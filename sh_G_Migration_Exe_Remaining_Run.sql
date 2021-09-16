#!/usr/bin/env bash

start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
logfile=""$spoolloc"/"$logtime"_Transformation_Post_Maintenance_Exe"$ext""

#export login_LOB="GTAUKTR1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Migration/Execution"
#export constraints_loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Environment/Misc"
#export misc_loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/BackendScripts"
#export migspoolloc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts"
#export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MDR5/MigrationSpools"
#export logtime="$(date -u +%d%h%y_%T)"
#export ext=".log"

#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Table_wise_counts"$ext" &
#@$misc_loc/Table_wise_counts.sql $migspoolloc
#EOF
#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Balance_Mismatch"$ext" &
#@$misc_loc/Balance_Mismatch.sql $migspoolloc
#EOF
#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_UnitholderFundTbl_UhBalLedgerBal_Balance_Mismatch"$ext" &
#@$misc_loc/UnitholderFundTbl_UhBalLedgerBal_Balance_Mismatch.sql $migspoolloc
#EOF
#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_UnitholderFundTbl_AgeingUnitBal_Balance_Mismatch"$ext" &
#@$misc_loc/UnitholderFundTbl_AgeingUnitBal_Balance_Mismatch.sql $migspoolloc
#EOF
#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_UPDATE_SUTL_GTAP_UH"$ext" &
#@$misc_loc/UPDATE_SUTL_GTAP_UH.sql $migspoolloc
#EOF
#wait
#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Enable_Referential_Constraints"$ext"
#@$constraints_loc/Enable_Referential_Constraints.sql $migspoolloc
#EOF
#wait

#sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_EXECUTE_G1_G2"$ext"
#@$migspoolloc/BackEnd/Mig_G1G2_Scripts/EXECUTE_G1_G2.SQL $migspoolloc
#EOF
#wait


sqlplus "$login_LOB" <<EOF|& tee -a "$logfile"
@$trnsf_loc/Transformation_Post_Maintenance_Exe.sql $migspoolloc
EOF
wait

#sqlplus "$login_LOB" <<EOF|sed  's/^/[CORE]/' |& tee -a "$spoolloc"/"$logtime"_MigG1G2_Custom"$ext"  $logfile  &
#@$migspoolloc/BackEnd/Mig_G1G2_Scripts/Execute_PkgMigG1G2_Custom.sql $migspoolloc
#EOF
#sqlplus "$login_LOB" <<EOF|sed  's/^/[REC]/' |& tee -a "$spoolloc"/"$logtime"_MIGG1G2_Rec_Custom"$ext"  $logfile  & 
#@$migspoolloc/BackEnd/Mig_G1G2_Scripts/Execute_pkgMIGG1G2_Rec_Custom.sql $migspoolloc
#EOF
#wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$logfile"
echo "Ended Migration Execution at:::"$(date)"" |& tee -a "$logfile"
rsync -av "$migspoolloc/Spool" "$spoolloc" |& tee -a "$logfile"
echo "Starting Error checking in the spools folder....." 
for file in "$migspoolloc/Spool/G1G2/"*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
for file in "$migspoolloc/Spool/Migration/"*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "completed G_Migration_Exe.sh.....:::"$(date)""
echo "Full spool error checks .....:::"$(date)""
for file in "$migspoolloc/Spool/"*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "Completed Full spool error checks .....:::"$(date)""
#nohup bash /gtaplocal/GTAP_MDR_INFILES/Migration_Exe.sh &