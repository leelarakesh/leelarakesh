#!/usr/bin/env bash

start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
#export login_LOB="GTAUKTR1/atWvYJf8NciNg38k@//20079861.HDEV:2001/11.HDEV"
#export mig_loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Migration/Execution"
#export constraints_loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/Environment/Misc"
#export misc_loc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts/BackEnd/BackendScripts"
#export migspoolloc="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts"
#export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MDR5/MigrationSpools"
#export logtime="$(date -u +%d%h%y_%T)"
#export ext=".log"
logfile=""$spoolloc"/"$logtime"_Migration_Exe"$ext""

echo "Started Migration Execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/"$logtime"_Migration_Exe"$ext"
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_Start"$ext"
@$mig_loc/Migration_Exe_Start.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_Start-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Disable_Referential_Constraints"$ext"
@$constraints_loc/Disable_Referential_Constraints.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Disable_Referential_Constraints-----*-**-**-**-**-**-**-**-**-**-**-**-**-*
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
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Disable_Referential_Constraints"$ext"
@$constraints_loc/LOB_REMOVE_TABLE_PARALLEL.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----LOB_REMOVE_TABLE_PARALLEL-----*-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
	else 
		echo "tableparallel is $tableparallel   and Tables will remain parallel"
	fi
fi
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_FundPrice"$ext" &
@$mig_loc/Migration_Exe_FundPrice.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_FundPrice-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_ExchangeRate"$ext" &
@$mig_loc/Migration_Exe_ExchangeRate.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_ExchangeRate-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_Entities"$ext" &
@$mig_loc/Migration_Exe_Entities.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_Entities-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_Unitholder"$ext" &
@$mig_loc/Migration_Exe_Unitholder.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_Unitholder-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_UHSI"$ext" &
@$mig_loc/Migration_Exe_UHSI.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_UHSI-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_UHIDS"$ext" &
@$mig_loc/Migration_Exe_UHIDS.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_UHIDS-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_Tax_Classification"$ext" &
@$mig_loc/Migration_Exe_Tax_Classification.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_Tax_Classification-----*-**-**-**-**-**-**-**-**-**-**-**-**
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_ConnectedParties"$ext" &
@$mig_loc/Migration_Exe_ConnectedParties.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_ConnectedParties-----*-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_Transaction"$ext" &
@$mig_loc/Migration_Exe_Transaction.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_Transaction-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_FundDivDeclare"$ext" &
@$mig_loc/Migration_Exe_FundDivDeclare.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_FundDivDeclare-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Migration_Exe_FundDivPayment"$ext" &
@$mig_loc/Migration_Exe_FundDivPayment.Sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Migration_Exe_FundDivPayment-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Table_wise_counts"$ext" &
@$misc_loc/Table_wise_counts.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Table_wise_counts-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Balance_Mismatch"$ext" &
@$misc_loc/Balance_Mismatch.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Balance_Mismatch-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_UnitholderFundTbl_UhBalLedgerBal_Balance_Mismatch"$ext" &
@$misc_loc/UnitholderFundTbl_UhBalLedgerBal_Balance_Mismatch.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----UnitholderFundTbl_UhBalLedgerBal_Balance_Mismatch-----*-**-**-**-**-**-**-
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_UnitholderFundTbl_AgeingUnitBal_Balance_Mismatch"$ext" &
@$misc_loc/UnitholderFundTbl_AgeingUnitBal_Balance_Mismatch.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----UnitholderFundTbl_AgeingUnitBal_Balance_Mismatch-----*-**-**-**-**-**-**-*
EOF
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_UPDATE_SUTL_GTAP_UH"$ext" &
@$misc_loc/UPDATE_SUTL_GTAP_UH.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----UPDATE_SUTL_GTAP_UH-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-**-
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Enable_Referential_Constraints"$ext"
@$constraints_loc/Enable_Referential_Constraints.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Enable_Referential_Constraints-----*-**-**-**-**-**-**-**-**-**-**-**-**-*
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Post_Migration_TxnRecon_CSV_Gen_Exe"$ext"
@$mig_loc/Post_Migration_TxnRecon_CSV_Gen_Exe.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Post_Migration_TxnRecon_CSV_Gen_Exe-----*-**-**-**-**-**-**-**-**-**-**-**
EOF
wait
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_Post_Migration_CSV_Gen_Exe"$ext"
@$mig_loc/Post_Migration_CSV_Gen_Exe.sql $migspoolloc
prompt *-**-**-**-**-**-**-**-**-**--------completed-----Post_Migration_CSV_Gen_Exe-----*-**-**-**-**-**-**-**-**-**-**-**-**-**-**
EOF
wait
echo " Echo Getting Table_wise_counts in process" |& tee -a "$logfile"
sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[LOB]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTMIG
EOF
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[STG]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTMIG
EOF
sqlplus "$login_SMS" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SMS]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTMIG
EOF
sqlplus "$login_SP" <<EOF|& tee -a "$spoolloc"/"$logtime"_RecompilationOfLobObjects"$ext" |sed  's/^/[SP]/' |& tee -a $logfile &
@$dmtblloc/SCHEMA_TABLE_COUNTS.sql $migspoolloc POSTMIG
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/"$logtime"_Migration_Exe"$ext"
echo "Ended Migration Execution at:::"$(date)"" |& tee -a "$spoolloc"/"$logtime"_Migration_Exe"$ext"
rsync -av "$migspoolloc/Spool" "$spoolloc"
echo "Starting Error checking in the spools folder....." 
for file in "$migspoolloc/Spool/Migration/"*;do  awk '/ORA-|SP2-/ && !/ORA-00955/ && !/ORA-01408/ {print FILENAME ,NR, $0}' $file; done
echo "completed G_Migration_Exe.sh.....:::"$(date)"" 
#nohup bash /gtaplocal/GTAP_MDR_INFILES/Migration_Exe.sh &