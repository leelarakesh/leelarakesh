#!/usr/bin/env bash
#export login_STAGE="GTASTGPA1/wOqEKnOsBB4L6y9N@U11_MDR2"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MDR5"
#export logtime="$(date -u +%d%h%y_%T)"
start_time="$(date -u +%s.%N)"
export logtime="$(date -u +%d%h%y_%T)"
logloc=""$spoolloc"/Mint_Table_Loading_Logs"
#spoollogfile=""$spoolloc"/"$RUNENV"_parallel_MDR_"$logtime""$ext""

sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunTimes"$ext"
DELETE FROM DM_TIMETRACKINGTBL WHERE MIGFILETYPE ='TOL' AND TASK='TOTAL_DATA_LOADING_TIME';
COMMIT;
INSERT INTO DM_TIMETRACKINGTBL(MIGFILETYPE,TASK,APPDATE,DBSERVDATE,START_TIME,END_TIME,TOTAL_TIME)
VALUES('TOL','TOTAL_DATA_LOADING_TIME',(SELECT DATETODAY FROM SYSPARAMTBL),SYSTIMESTAMP,SYSDATE,NULL,NULL);
COMMIT;
EOF
wait
echo "Truncating FX Tables:::"|& tee -a "$spoolloc"/"$logtime"_Truncate_FX_Tables"$ext"
sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Truncate_FX_Tables"$ext"
@$fxtblloc/Truncate_Mint_Script.sql $migspoolloc
EOF
wait

#echo "started  parallel_MDR.sh at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoollogfile"
./mdr_loader_exe1.sh |& sed  's/^/[ldrexe1]/' |& tee -a ""$logloc"/mdr_loader_exe1_"$logtime".log" &
./mdr_loader_exe2.sh |& sed  's/^/[ldrexe2]/' |& tee -a ""$logloc"/mdr_loader_exe2_"$logtime".log" &
./mdr_loader_exe3.sh |& sed  's/^/[ldrexe3]/' |& tee -a ""$logloc"/mdr_loader_exe3_"$logtime".log" &
#This is for CDSC data History
./mdr_loader_exe4.sh |& sed  's/^/[ldrexe4]/' |& tee -a ""$logloc"/mdr_loader_exe4_"$logtime".log" &
#./mdr_loader_exe5.sh |& sed  's/^/[ldrexe5]/' |& tee -a ""$logloc"/mdr_loader_exe5_"$logtime".log" &
#./mdr_loader_exe6.sh |& sed  's/^/[ldrexe6]/' |& tee -a ""$logloc"/mdr_loader_exe6_"$logtime".log" &
#./mdr_loader_exe7.sh |& sed  's/^/[ldrexe7]/' |& tee -a ""$logloc"/mdr_loader_exe7_"$logtime".log" &
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for FX Loading  parallel_MDR at:::"$(date)""

#echo "FXE Purge:::"|& tee -a "$spoolloc"/"$logtime"_Truncate_FX_Tables"$ext"
#sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_DST_FXE_TO_FXEDOB"$ext"
#@$fxtblloc/DST_FXE_TO_FXEDOB.sql $migspoolloc
#EOF
#wait

sqlplus "$login_LOB" <<EOF|& tee -a "$spoolloc"/"$logtime"MLRAJEPUN_Data_Loader_Xlsx"$ext"
@$trnsf_loc/MLRAJEPUN_Data_Loader_Xlsx_Exe.sql $migspoolloc
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for MLRAJEPUN_Data_Loader_Xlsx:::"$(date)""

sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_CDSC_Data_Copy_Exe"$ext"
@$trnsf_loc/Transformation_CDSC_Data_Copy_Exe.sql $migspoolloc
EOF
wait

sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_DST_Index_Exe"$ext"
@$trnsf_loc/Transformation_Source_Index_Exe.sql $migspoolloc
EOF
wait

sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_Transformation_DSTTablesGatherStats_Exe"$ext"
@$trnsf_loc/Transformation_SourceTablesGatherStats_Exe.sql $migspoolloc
EOF
wait

sqlplus "$login_STAGE" <<EOF|& tee -a "$spoolloc"/"$logtime"_RunTimes"$ext"
UPDATE DM_TIMETRACKINGTBL SET END_TIME = SYSDATE, TOTAL_TIME = ROUND((SYSDATE-START_TIME)*1440,2)
WHERE MIGFILETYPE ='TOL'AND TASK ='TOTAL_DATA_LOADING_TIME';
COMMIT;
EOF
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process End  parallel_MDR at:::"$(date)""
# FXAA--> mdr_loader_exe1.sh
# FXAF--> mdr_loader_exe1.sh
# FXAH--> mdr_loader_exe1.sh
# FXB--> mdr_loader_exe1.sh
# FXO--> mdr_loader_exe1.sh
# FXQ--> mdr_loader_exe1.sh

# FXAS--> mdr_loader_exe2.sh
# FXF--> mdr_loader_exe2.sh
# FXPE--> mdr_loader_exe2.sh
# FXPM--> mdr_loader_exe2.sh
# FXY--> mdr_loader_exe2.sh  
# FXY_SH--> mdr_loader_exe2.sh

# FXC--> mdr_loader_exe3.sh
# FXI--> mdr_loader_exe3.sh
# FXK--> mdr_loader_exe3.sh
# FXKM--> mdr_loader_exe3.sh
# FXPW--> mdr_loader_exe3.sh

# FXD--> mdr_loader_exe4.sh
# FXX--> mdr_loader_exe4.sh
# FXP--> mdr_loader_exe4.sh
# FXDM--> mdr_loader_exe4.sh
# FXQX--> mdr_loader_exe4.sh
# FXL--> mdr_loader_exe4.sh
# OFFXREFQ02--> mdr_loader_exe4.sh
# OFFXREFK72--> mdr_loader_exe4.sh
# OFFXREFA89--> mdr_loader_exe4.sh
# OFFXREFQ43--> mdr_loader_exe4.sh

# FXDOB--> mdr_loader_exe5.sh
# FXAM--> mdr_loader_exe5.sh
# FXPN--> mdr_loader_exe5.sh
# FXPP--> mdr_loader_exe5.sh
# OFFXREFQ03--> mdr_loader_exe5.sh
# FXS--> mdr_loader_exe5.sh
# OFFXREFQ31--> mdr_loader_exe5.sh
# OFFXREFA12--> mdr_loader_exe5.sh
# OFFXREFK71--> mdr_loader_exe5.sh
# FXRCDCOUNT--> mdr_loader_exe5.sh

# FXE--> mdr_loader_exe6.sh
# FXA--> mdr_loader_exe6.sh
# FXR--> mdr_loader_exe6.sh
# FXH--> mdr_loader_exe6.sh
# FXPI--> mdr_loader_exe6.sh
# FXPX--> mdr_loader_exe6.sh
# OFFXREFB55--> mdr_loader_exe6.sh
# OFFXREFQ20--> mdr_loader_exe6.sh
# OFFXREFTYP--> mdr_loader_exe6.sh
# FXP_DANGLY--> mdr_loader_exe6.sh

# FXN--> mdr_loader_exe7.sh
# FXJ--> mdr_loader_exe7.sh
# FXPF--> mdr_loader_exe7.sh
# FXPT--> mdr_loader_exe7.sh
# FXAB--> mdr_loader_exe7.sh
# OFFXREFB25--> mdr_loader_exe7.sh
# OFFXREFA53--> mdr_loader_exe7.sh
# FXLM--> mdr_loader_exe7.sh
# OFFXREFB33--> mdr_loader_exe7.sh
# FXFS--> mdr_loader_exe7.sh
#OFFXREFJ17-->mdr_loader_exe7.sh