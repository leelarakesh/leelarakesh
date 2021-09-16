#!/user/bin/env bash
export RUNENV="BDR"
start_time="$(date -u +%s.%N)"
logtime="$(date -u +%d%h%y_%T)"
echo "excute Initialize_Environment_Parameters"
source G_Initialize_Environment_Parameters.sh
logfile=""$spoolloc"/"$RUNENV"_Config_Test_"$logtime""$ext""
echo "===============<><><><><><><><><><><><><><><><><><><><><><><><><><><>===================="
echo "===============<><><><><><><><><><>_Config_Test_<><><><><><><><><><><><><><><><>===================="
echo "===============<><><><><><><><><><><><><><><><><><><><><><><><><><><>===================="
echo "spoolloc="$spoolloc""
echo "login_STAGE="$login_STAGE""
echo "login_LOB="$login_LOB""
echo "login_LOB="$login_SP""
echo "login_LOB="$login_SMS""
echo "login_LOB="$login_ROA""
echo "fxtblloc="$fxtblloc""
echo "statsloc="$statsloc""
echo "dmtblloc="$dmtblloc""
echo "loc="$loc""
echo "syndeploy="$syndeploy""
echo "trnsf_loc="$trnsf_loc""
echo "premig_loc="$premig_loc""
echo "mig_loc="$mig_loc""
echo "misc_loc="$misc_loc""
echo "constraints_loc="$constraints_loc""
echo "migspoolloc="$migspoolloc""
echo "g1g2_loc="$g1g2_loc""
echo "pretrnsf_loc="$pretrnsf_loc""
echo "ControlLoc="$ControlLoc""
echo "dedupe_loc="$dedupe_loc""
echo "dayzero_loc="$dayzero_loc""
echo "cdscloc="$cdscloc""
echo "ext="$ext""
echo "DedupeValue="$DedupeValue""

echo "===============<><><><><><><><><><><><><><><><><><><><><><><><><><><>===================="
echo "Started execution at:::"$(date)"::logtime::"$logtime"" |& tee -a "$logfile"
prog_start_time="$(date -u +%s.%N)"
echo "#################Check Locations####################=========================================="|& tee -a "$logfile"
if [ -d "$spoolloc" ]; then
  echo ">>>spoolloc exists "$spoolloc"" |& tee -a "$logfile"
else 
  echo "$$$ spoolloc doesnt exists "$spoolloc"" |& tee -a "$logfile"
fi

if [ -d "$fxtblloc" ]; then
  echo ">>>fxtblloc exists "$fxtblloc"" |& tee -a "$logfile"
else 
  echo "$$$ fxtblloc doesnt exists "$fxtblloc"" |& tee -a "$logfile"
fi
if [ -d "$statsloc" ]; then
  echo ">>>statsloc exists "$statsloc"" |& tee -a "$logfile"
else 
  echo "$$$ statsloc doesnt exists "$statsloc"" |& tee -a "$logfile"
fi
if [ -d "$loc" ]; then
  echo ">>>loc exists "$loc"" |& tee -a "$logfile"
else 
  echo "$$$ loc doesnt exists "$loc"" |& tee -a "$logfile"
fi
if [ -d "$dmtblloc" ]; then
  echo ">>>dmtblloc exists "$dmtblloc"" |& tee -a "$logfile"
else 
  echo "$$$ dmtblloc doesnt exists "$dmtblloc"" |& tee -a "$logfile"
fi
if [ -d "$syndeploy" ]; then
  echo ">>>syndeploy exists "$syndeploy"" |& tee -a "$logfile"
else 
  echo "$$$ syndeploy doesnt exists "$syndeploy"" |& tee -a "$logfile"
fi
if [ -d "$trnsf_loc" ]; then
  echo ">>>trnsf_loc exists "$trnsf_loc"" |& tee -a "$logfile"
else 
  echo "$$$ trnsf_loc doesnt exists "$trnsf_loc"" |& tee -a "$logfile"
fi
if [ -d "$premig_loc" ]; then
  echo ">>>premig_loc exists "$premig_loc"" |& tee -a "$logfile"
else 
  echo "$$$ premig_loc doesnt exists "$premig_loc"" |& tee -a "$logfile"
fi
if [ -d "$mig_loc" ]; then
  echo ">>>mig_loc exists "$mig_loc"" |& tee -a "$logfile"
else 
  echo "$$$ mig_loc doesnt exists "$mig_loc"" |& tee -a "$logfile"
fi
if [ -d "$misc_loc" ]; then
  echo ">>>misc_loc exists "$misc_loc"" |& tee -a "$logfile"
else 
  echo "$$$ misc_loc doesnt exists "$misc_loc"" |& tee -a "$logfile"
fi
if [ -d "$constraints_loc" ]; then
  echo ">>>constraints_loc exists "$constraints_loc"" |& tee -a "$logfile"
else 
  echo "$$$ constraints_loc doesnt exists "$constraints_loc"" |& tee -a "$logfile"
fi
if [ -d "$migspoolloc" ]; then
  echo ">>>migspoolloc exists "$migspoolloc"" |& tee -a "$logfile"
else 
  echo "$$$ migspoolloc doesnt exists "$migspoolloc"" |& tee -a "$logfile"
fi
if [ -d "$g1g2_loc" ]; then
  echo ">>>g1g2_loc exists "$g1g2_loc"" |& tee -a "$logfile"
else 
  echo "$$$ g1g2_loc doesnt exists "$g1g2_loc"" |& tee -a "$logfile"
fi
if [ -d "$pretrnsf_loc" ]; then
  echo ">>>pretrnsf_loc exists "$pretrnsf_loc"" |& tee -a "$logfile"
else 
  echo "$$$ pretrnsf_loc doesnt exists "$pretrnsf_loc"" |& tee -a "$logfile"
fi
if [ -d "$ControlLoc" ]; then
  echo ">>>ControlLoc exists "$ControlLoc"" |& tee -a "$logfile"
else 
  echo "$$$ ControlLoc doesnt exists "$ControlLoc"" |& tee -a "$logfile"
fi
if [ -d "$dedupe_loc" ]; then
  echo ">>>dedupe_loc exists "$dedupe_loc"" |& tee -a "$logfile"
else 
  echo "$$$ dedupe_loc doesnt exists "$dedupe_loc"" |& tee -a "$logfile"
fi
if [ -d "$dayzero_loc" ]; then
  echo ">>>dayzero_loc exists "$dayzero_loc"" |& tee -a "$logfile"
else 
  echo "$$$ dayzero_loc doesnt exists "$dayzero_loc"" |& tee -a "$logfile"
fi
if [ -d "$cdscloc" ]; then
  echo ">>>cdscloc exists "$cdscloc"" |& tee -a "$logfile"
else 
  echo "$$$ cdscloc doesnt exists "$cdscloc"" |& tee -a "$logfile"
fi
echo "#===="|& tee -a "$logfile"
if [ -d ""$loc""/"INFILES/GBP" ]; then
  echo ">****>>GBP_loc exists ""$loc""/"INFILES/GBP"" |& tee -a "$logfile"
else 
  echo "$$$ GBP_loc doesnt exists ""$loc""/"INFILES/GBP"" |& tee -a "$logfile"
fi
if [ -d ""$loc""/"INFILES/PEN" ]; then
  echo ">****>>PEN_loc exists ""$loc""/"INFILES/PEN"" |& tee -a "$logfile"
else 
  echo "$$$ PEN_loc doesnt exists ""$loc""/"INFILES/PEN"" |& tee -a "$logfile"
fi
if [ -d ""$loc""/"INFILES/EUR" ]; then
  echo ">****>>EUR_loc exists ""$loc""/"INFILES/EUR"" |& tee -a "$logfile"
else 
  echo "$$$ EUR_loc doesnt exists ""$loc""/"INFILES/EUR"" |& tee -a "$logfile"
fi
echo "#===="|& tee -a "$logfile"
echo "#===="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo "#################Check DB Logins####################=========================================="|& tee -a "$logfile"

echo ">>>Login for  login_STAGE"|& tee -a "$logfile"
sqlplus "$login_STAGE" <<EOF|& tee -a "$logfile"
select user||'/'||sys_context('userenv','instance_name')||'@'||sys_context('userenv', 'server_host')   instance_name from dual;
EOF
echo "###############################=========================================="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo ">>>Login for  login_LOB"|& tee -a "$logfile"
sqlplus "$login_LOB" <<EOF|& tee -a "$logfile"
select user||'/'||sys_context('userenv','instance_name')||'@'||sys_context('userenv', 'server_host')   instance_name from dual;
EOF
echo "###############################=========================================="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo ">>>Login for  login_SMS"|& tee -a "$logfile"
sqlplus "$login_SMS" <<EOF|& tee -a "$logfile"
select user||'/'||sys_context('userenv','instance_name')||'@'||sys_context('userenv', 'server_host')   instance_name from dual;
EOF
echo "###############################=========================================="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo ">>>Login for  login_SP"|& tee -a "$logfile"
sqlplus "$login_SP" <<EOF|& tee -a "$logfile"
select user||'/'||sys_context('userenv','instance_name')||'@'||sys_context('userenv', 'server_host')   instance_name from dual;
EOF
echo "###############################=========================================="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo ">>>Login for  login_ROA"|& tee -a "$logfile"
sqlplus "$login_ROA" <<EOF|& tee -a "$logfile"
select user||'/'||sys_context('userenv','instance_name')||'@'||sys_context('userenv', 'server_host')   instance_name from dual;
EOF
echo "###############################=========================================="|& tee -a "$logfile"
echo "###############################=========================================="|& tee -a "$logfile"
echo "==================================================================================================================================================="
end_time="$(date -u +%s.%N)"
elapsed="$(bc <<<"$end_time-$start_time")"
echo " Total of $elapsed seconds elapsed for process Ended Execution at:::"$(date)"" |& tee -a "$logfile"
#nohup bash /gtaplocal/GTAP_MDR_INFILES/BDR_Environment_Setup.sh &