#!/user/bin/env bash
start_time="$(date -u +%s.%N)"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/Environment"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/Pre_TransformationCheck"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/Transformation"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/Dedupe"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/Pre_Migration"
export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/Migration"
#export loc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/G1G2"
export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MINT_FILES/MDR2/MigrationSpools"
#export spoolloc="/gtaplocal/GTAP_MDR_INFILES/MINT_MIGSCRIPTS_REPO/MINT_MIGSCRIPTS/Scripts/Spool/"
export logtime="$(date -u +%d%h%y_%T)"
export stg="Migration"
export ext=".log"

echo "Started execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$spoolloc"/OracleErrors_"$stg"_"$logtime""$ext"
grep -Rinw --include=\*.log $loc -e 'ERROR at line' -e 'ORA-' -e 'SP2-' -e 'ERROR:' -e 'unknown command' -e 'at line' -C 3 |& tee -a "$spoolloc"/OracleErrors_"$stg"_"$logtime""$ext"
wait
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process" |& tee -a "$spoolloc"/OracleErrors_"$stg"_"$logtime""$ext"
echo "Ended Execution at:::"$(date)"" |& tee -a "$spoolloc"/OracleErrors_"$stg"_"$logtime""$ext"

#nohup bash /gtaplocal/GTAP_MDR_INFILES/All_Errors_Catch.sh &