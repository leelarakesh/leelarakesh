options  (direct=true, bindsize=999999999, rows=100000000)
load data
  CHARACTERSET WE8ISO8859P1
  append into table GFAS_ACCOUNTMEMOSTBL 
  fields terminated by "~" 
(
 PRODUCTGROUP               "TRIM(:PRODUCTGROUP)"
,GFASACCOUNT                "TRIM(:GFASACCOUNT)"
,SEQUENCENO                 "TRIM(:SEQUENCENO)"
,MEMO                   	"TRIM(:MEMO)"
,MEMODATE                   "TRIM(:MEMODATE)"
,MEMOTIME                   "TRIM(:MEMOTIME)"
,ENTEREDUSER                "TRIM(:ENTEREDUSER)"
,RECORDNO                   TERMINATED BY WHITESPACE
)