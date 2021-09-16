-- Displays a list of sessions running for the current database along with the command to kill each one
-- Syntax: @sessions [%user% | 'all']
set lines 150
set pages 10000
column kill_command format a50
column osuser       format a15
column username     format a15
select username, osuser,sid, serial#, status
      ,to_char(logon_time, 'DD-Mon-RR HH24:MI') logon_time
      ,'alter system kill session ''' || to_char(sid) || ', ' || to_char(serial#) || ''' immediate;' kill_command
      ,program
from   v$session
where (upper(username) like upper('%&&1%')
   or  upper('&&1') = 'ALL')
order by 
       username
      ,logon_time
/
clear col
