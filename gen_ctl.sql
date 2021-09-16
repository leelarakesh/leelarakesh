#!/usr/bin/ksh
#######################################################################################
#                                                                                     #
# MODULE     : gen_ldr_ctl.sh                                                         #
# DESCRIPTION: Generate SQL Loader fixed format control files to allow load of data   #
#              into FAST staging area tables.                                         #
#              Also generates the 'loader list' of files to be loaded.                #
#              Also generates a SQL script to be run post-load to remove non-detail   #
#              records and perform counts.                                            #
#              Also generates a SQL script to truncate UTAS tables for test purposes. #
#                                                                                     #
# Requires LOADER_DAT_DIR  environment variable which is the directory used for       #
# holding the data files and control files.                                           #
#                                                                                     #
#######################################################################################

if [[ "${LOADER_DAT_DIR}" = "" ]]
then
   export LOADER_DAT_DIR=${PARAMSTRING}
fi

if [[ "${LOADER_DAT_DIR}" = "" ]]
then
   echo LOADER_DAT_DIR environment variable has not been set up - exiting
   exit 1
fi

TABLE_LIST=`sqlplus -s -R 3 ${USER_CONN} << xxx
whenever sqlerror exit 4
set lines 132
set pages 0
set heading off
set feedb off
set echo off
set verify off
select lower(table_name)
from   all_tables
where  table_name like 'GFAS%'
order by table_name
/
xxx`

echo Generating control files...
echo

for i in ${TABLE_LIST} 
do
  echo Processing Table ${i}...
  CTL_FILE=${LOADER_DAT_DIR}/${i}.fctl
  if [[ -a ${CTL_FILE} ]]
  then
    echo Removing old control file ${CTL_FILE}
    rm ${CTL_FILE}
  fi
  echo Generating new control file ${CTL_FILE}
  echo 
  sqlplus -s -R 3 ${USER_CONN} << xxx > ${CTL_FILE}
  whenever sqlerror exit failure rollback;
  whenever oserror exit oscode rollback;
  set serveroutput on size 1000000
  set echo off
  set verify off
  set long 2000
  set feedback off
  alter session set global_names=false;
  set heading off
  set embedded on
  set recsep off
  set pagesize 0
  set linesize 200
  set termout on
  
  declare
    w_table   varchar2(30)    := upper('${i}');
    w_rec_typ varchar2(1)     := 'v';             -- Fixed format rather than variable.
  
    cursor tab_csr is
    select column_id
          ,column_name
          ,data_type
          ,data_length
          ,data_precision
          ,data_scale
          ,nullable
    from   all_tab_columns
    where  table_name = w_table
    order by column_id;
 
    tab_rec tab_csr%ROWTYPE;
 
    w_text    varchar2(2000);
    w_int     number(12)      := 0;
  
  begin
    dbms_output.put_line('OPTIONS (DIRECT=TRUE)');
    dbms_output.put_line('LOAD DATA');
 
    dbms_output.put_line('APPEND');
    dbms_output.put_line('INTO TABLE '||w_table);
 
    if w_rec_typ = 'v' then
      dbms_output.put_line('FIELDS TERMINATED BY '','''||
                           ' OPTIONALLY ENCLOSED BY ''"''');
      dbms_output.put_line('TRAILING NULLCOLS');
    end if;
     
    for tab_rec in tab_csr
    loop
      if tab_rec.column_id = 1 then
        w_text := '(';
      else
        w_text := ',';
      end if;
      w_text := w_text||rpad(tab_rec.column_name,30,' ');
      if w_rec_typ = 'f' then
        w_int  := w_int + 1;
        w_text := w_text||' POSITION ('||to_char(w_int)||':';
        if tab_rec.data_type = 'DATE' then
          w_int  := w_int + 7;
        elsif tab_rec.data_type = 'NUMBER' then
          w_int := w_int + tab_rec.data_precision - 1;
          if tab_rec.data_scale != 0 then
            w_int := w_int + 1;
          end if;
        else
          w_int := w_int + tab_rec.data_length - 1;
        end if;
        w_text := w_text||to_char(w_int)||')';
      else
        if (tab_rec.data_type = 'VARCHAR2' and
            tab_rec.data_length > 255) then
             w_text := w_text||' char('||tab_rec.data_length||') ';
        end if;
        --
        --if (tab_rec.data_type = 'VARCHAR2' then
           w_text := w_text||'"trim(:'||tab_rec.column_name||')"';
        --end if;
      end if;
      if tab_rec.data_type = 'DATE' then
        w_text := w_text||' DATE(8) "YYYYMMDD"';
      end if;
      dbms_output.put_line(w_text);
      if  w_rec_typ = 'f'
      and tab_rec.data_type = 'DATE'
      and tab_rec.nullable = 'Y' then
        dbms_output.put_line('"decode(:'||tab_rec.column_name||
                             ',''00000000'',null'||
        /* N.B. Use RPAD because DBMS_OUTPUT appears to add spurious tabs */
                             ',rpad(''0'',8,'' ''),null'||
                             ',rpad('' '',8,'' ''),null'||
                             ',:'||tab_rec.column_name||')"');
      end if;
    end loop;
    dbms_output.put_line(')');
  end;
  /
xxx
done

echo Generating control files finished
echo

echo Generating loader list...
echo

# Re-select table list so we don't include the cross-ref tables.
# The format for each line is:
#   <table name>:<fixed or variable records>:<commit rows>:<bindsize>:<max errors>

TABLE_LIST=`sqlplus -s -R 3 ${USER_CONN} << xxx
whenever sqlerror exit 4
set lines 132
set pages 0
set heading off
set feedb off
set echo off
set verify off
select lower(table_name)
from   all_tables
where  table_name like 'FAST%'
and    table_name not like '%XREF%'
and    table_name not like 'FAST_REC%'
--and    table_name not in ('KRUFUS_TRANSACTION2','KRUFUS_CM','KRUFUS_PARTIES')
and    substr(table_name,8,3) != 'LD_'
order by table_name
/
xxx`

LOADER_LIST=${LOADER_DAT_DIR}/loader_list.txt
if [[ -a ${LOADER_LIST} ]]
then
  echo Removing old loader list file ${LOADER_LIST}
  rm ${LOADER_LIST}
fi
for i in ${TABLE_LIST}
do
  echo ${i}:f:1000:1000000:1000 >> ${LOADER_LIST}
done

echo Generating loader list finished
echo

exit 0

