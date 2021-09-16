#!/user/bin/env bash
export repopath="/gtaplocal/GTAP_MDR_INFILES/MIG_SCRIPTS_REPO/MIG_SCRIPTS/Scripts"
export ControlLoc=""$repopath"/Sqlldr/Control_Files"
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_AGREEMENTOVERVIEWDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/GBP_FX_AGREEMENTOVERVIEWDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/GBP/AgreementOverviewData_20190602_220418.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/GBP_FX_AGREEMENTOVERVIEWDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_AGREEMENTOVERVIEWDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/EUR_FX_AGREEMENTOVERVIEWDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/EUR/AgreementOverviewData_20190602_220251.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/EUR_FX_AGREEMENTOVERVIEWDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_AGREEMENTOVERVIEWDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/PEN_FX_AGREEMENTOVERVIEWDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/PEN/AgreementOverviewData_20190602_220950.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/PEN_FX_AGREEMENTOVERVIEWDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_AGREEMENTDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/GBP_FX_AGREEMENTDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/GBP/AgreementData_20190602_220418.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/GBP_FX_AGREEMENTDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_AGREEMENTDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/EUR_FX_AGREEMENTDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/EUR/AgreementData_20190602_220251.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/EUR_FX_AGREEMENTDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_AGREEMENTDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/PEN_FX_AGREEMENTDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/PEN/AgreementData_20190602_220950.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/PEN_FX_AGREEMENTDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_UNITHOLDERDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/GBP_FX_UNITHOLDERDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/GBP/UnitholderData_20190602_220418.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/GBP_FX_UNITHOLDERDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_UNITHOLDERDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/EUR_FX_UNITHOLDERDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/EUR/UnitholderData_20190602_220251.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/EUR_FX_UNITHOLDERDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_UNITHOLDERDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/PEN_FX_UNITHOLDERDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/PEN/UnitholderData_20190602_220950.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/PEN_FX_UNITHOLDERDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_FUNDGROUPDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/GBP_FX_FUNDGROUPDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/GBP/FundGroupData_20190602_220418.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/GBP_FX_FUNDGROUPDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_FUNDGROUPDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/EUR_FX_FUNDGROUPDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/EUR/FundGroupData_20190602_220251.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/EUR_FX_FUNDGROUPDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_FUNDGROUPDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/PEN_FX_FUNDGROUPDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/PEN/FundGroupData_20190602_220950.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/PEN_FX_FUNDGROUPDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_FUNDDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/GBP_FX_FUNDDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/GBP/FundData_20190602_220418.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/GBP_FX_FUNDDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_FUNDDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/EUR_FX_FUNDDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/EUR/FundData_20190602_220251.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/EUR_FX_FUNDDATA.CSV"&
sqlldr GTASTGPA1/atWvYJficUcEt89d0@U14_MDRECS  control="$ControlLoc"'/FX_FUNDDATA.txt' log='/gtaplocal/GTAP_MDR_INFILES/MDR4/MigrationSpools/LoaderSpool/PEN_FX_FUNDDATA.log' "DATA=/gtaplocal/GTAP_MDR_INFILES/MDR4/INFILES/HDEVLeopardRebates20190613/PEN/FundData_20190602_220950.csv" "BAD=/gtaplocal/GTAP_MDR_INFILES/MDR3/BADFILE/PEN_FX_FUNDDATA.CSV"&
$ nohup parallel_sh.sh 


