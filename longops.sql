-- Displays information about long jobs currently running in the database, including an estimation of time to complete.
-- Syntax: @longops
column username       format a10
column message        format a80
column time_remaining format a10
column pcnt_complete  format a10
prompt Long Operations
select vsl.sid
      ,vsl.username
      ,vsl.message
      ,case
         when vsl.time_remaining < 60 then
            to_char(vsl.time_remaining) || ' secs'
         when vsl.time_remaining < 3600 then
            to_char(round(vsl.time_remaining/60, 2)) || ' mins'
         else
            to_char(round(vsl.time_remaining/3600, 2)) || ' hrs'
         end time_remaining
      ,to_char(round(vsl.sofar/vsl.totalwork*100, 2)) || '%' pcnt_complete
from   v$session_longops vsl
where  vsl.sofar != vsl.totalwork
/
