select count(*)
from ods_extract_tables
AS OF TIMESTAMP TO_TIMESTAMP('17-JUN-2014 15:30:00','DD-MON-YYYY HH24:MI:SS')
/


--2 hours ago ....
select count(*)
from ods_extract_tables
AS OF TIMESTAMP TO_TIMESTAMP(to_char(sysdate - (2/24),'DD-MON-YYYY HH24:MI'),'DD-MON-YYYY HH24:MI')
/