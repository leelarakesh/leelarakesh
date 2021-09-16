-- Selects waiting events from V$SESSION_WAIT for a SID or username
-- Syntax: @waits [SID | USERNAME | 'all']

column username format a15
select vw.sid
      ,vs.username
      ,vs.event
      ,vs.seconds_in_wait
      ,vs.state
from   v$session_wait vw
      ,v$session vs
where  vs.sid = vw.sid
and   (to_char(vw.sid) = '&&1'
   or  vs.username like upper('&&1')
   or  upper('&&1') = 'ALL')
order by
       vw.sid
/

clear col
