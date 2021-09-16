set lines 255
set serveroutput on size 1000000 format wrapped


col sdate new_value sysdt
select to_char(sysdate,'DD_Mon_YYYY__hh24_mi') sdate from dual
/

spool show_pipe_&sysdt..lis

exec pipe_rcv('X',1);


spool off

