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
logfile=""$spoolloc"/"$logtime"_Transformation_Exe2"$ext""
echo "Started Transformation Execution 2 at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
prog_start_time="$(date -u +%s.%N)"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Entities_Exe"$ext" &
@$trnsf_loc/Transformation_Entities_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Unitholder_Exe"$ext" &
@$trnsf_loc/Transformation_Unitholder_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Fund_Price_Exe"$ext" &
@$trnsf_loc/Transformation_Fund_Price_Exe.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for Unitholder and Entities DM table Loading" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
prog_start_time="$(date -u +%s.%N)"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_UHIDS_Exe"$ext" &
@$trnsf_loc/Transformation_UHIDS_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_UHSI_Exe"$ext" &
@$trnsf_loc/Transformation_UHSI_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Connected_Party_Exe"$ext" &
@$trnsf_loc/Transformation_Connected_Party_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Exchange_Rate_Exe"$ext" &
@$trnsf_loc/Transformation_Exchange_Rate_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_DividendDeclare_Exe"$ext" &
@$trnsf_loc/Transformation_DividendDeclare_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Dividend_Payment_Exe"$ext" &
@$trnsf_loc/Transformation_Dividend_Payment_Exe.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Transaction_Exe"$ext" &
@$trnsf_loc/Transformation_Transaction_Exe.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Tax_Classification_Exe"$ext" &
@$trnsf_loc/Transformation_Tax_Classification_Exe.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for UHIDS, UHSI, Tax_Classification, Connected_Party, Fund_Price, Exchange_Rate, DividendDeclare, Dividend_Payment, Transaction" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
prog_start_time="$(date -u +%s.%N)"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_Remaining_Exe"$ext"
@$trnsf_loc/Transformation_Remaining_Exe.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for Remaining Transformation Scripts" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
wait
if [ $DedupeValue == "Y" ]
then
prog_start_time="$(date -u +%s.%N)"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_DM_DEDUPEREFERENCETBL_Exe"$ext" &
@$dedupe_loc/DM_DEDUPEREFERENCETBL.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_UH_Exe"$ext" &
@$dedupe_loc/DM_UHMIGRATIONTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_RP_Exe"$ext" &
@$dedupe_loc/DM_CONNECTEDPARTIESTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_DivPayment_Exe"$ext" &
@$dedupe_loc/DM_FUNDDIVIDENDPAYMENTTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_OpenDistribution_Exe"$ext" &
@$dedupe_loc/DM_FUNDDIVIDENDOPENDISTRBTN_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_UHIDS_Exe"$ext" &
@$dedupe_loc/DM_IDSTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_OneLegTransfer_Exe"$ext" &
@$dedupe_loc/DM_ONELEGGEDTRANSFERHDRTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_UHSI_Exe"$ext" &
@$dedupe_loc/DM_SISETUPTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_StopCodes_Exe"$ext" &
@$dedupe_loc/DM_STOPCODES_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_TXN_Exe"$ext" &
@$dedupe_loc/DM_TXNMIGRATIONTBL_DD.sql $migspoolloc
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_UHBank_Exe"$ext" &
@$dedupe_loc/DM_UHBANKDETAILSTBL_DD.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_CRS_Exe"$ext" &
@$dedupe_loc/DM_COMPLIANCECLASSIFICATION_DD.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_FATCA_Exe"$ext" &
@$dedupe_loc/DM_FATCAMIGTBL_DD.sql $migspoolloc
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Dedupe_YC_Exe"$ext" &
@$dedupe_loc/DM_KYCDETAILSSTBL_DD.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$prog_start_time")"
echo " Total of $elapsed seconds elapsed for DeDupe Updation" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
else
   echo "DeDupe does not apply for this Run"
fi
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for Transformation (pending post Transformation)" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"Post_Transformation_CSV_Gen_Exe"$ext" &
@$trnsf_loc/Post_Transformation_CSV_Gen_Exe.sql $migspoolloc
EOF
wait
echo " Echo Getting Table_wise_counts in process" |& tee -a "$logfile"
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTTRF
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTTRF
EOF
sqlplus "$login_SMS" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SMS]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTTRF
EOF
sqlplus "$login_SP" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SP]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTTRF
EOF
wait
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"Post_Transformation_Gather_Stage_Schema_Stats_Exe"$ext" &
@$trnsf_loc/Post_Transformation_Gather_Stage_Schema_Stats_Exe.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
echo "Ended Transformation Execution 2 at:::"$(date)"" |& tee -a "$spoolloc"/"$logtime"_Transformation_Exe2"$ext"
rsync -av "$migspoolloc/Spool" "$spoolloc"
echo "Starting Error checking in the spools folder....." 
for file in "$migspoolloc/Spool/Transformation"/*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
for file in "$migspoolloc/Spool/Dedupe"/*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "completed G_Transformation_2_Exe.sh.....:::"$(date)"" 
#nohup bash /gtaplocal/GTAP_MDR_INFILES/Transformation_Exe.sh &