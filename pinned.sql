-- Shows all pinned objects in the cache for the APP schema
-- Syntax: @pinned [NAMESPACE | NAME | TYPE | 'all']
column owner      format a5
column name       format a25
column namespace  format a18
column type       format a15
column db_link    noprint
set numwidth 8

prompt Pinned Objects
select *
from   v$db_object_cache
where  owner = 'APP'
and    kept = 'YES'
and   (name      like upper('&&1')
   or  namespace like upper('&&1')
   or  type      like upper('&&1')
   or  upper('&&1') = 'ALL')
order by owner, type, name
/
clear col
set numwidth 10

