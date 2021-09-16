set lines 220
set serveroutput on size 1000000 format wrapped



spool show_pipe.lis

begin
  pipe_rcv('X',1);


exception
  when others then
    pipe_rcv(1,'X');
end;
/

spool off




