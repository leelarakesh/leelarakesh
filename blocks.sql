-- Select blocking locks by user and object_name. Use to investigate locked sessions
set lines 132
set pages 1000
column username format a15
column machine format a15
column osuser format a15
select l.sid
      ,s.username
      ,s.machine
      ,s.program
      ,s.osuser
      ,ob.object_name
from   v$session       s
      ,v$locked_object lo
      ,all_objects     ob
      ,v$lock          l
where  s.sid         = l.sid
  and  lo.session_id = l.sid
  and  lo.object_id  = ob.object_id
  and  l.block       = 1
/
clear col
