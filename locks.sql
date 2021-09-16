-- Selects locks for a specific SID, username or object from V$LOCK (excludes system locks)
-- Syntax: @locks [SID | USERNAME | OBJECT_NAME | 'all']
-- Run as APP

column username    format a15
column lmode_descr format a7
column object_name format a20
column owner       format a12
column block       format a5
column lock_info   format a50
select vl.sid
      ,vs.username
      ,vl.type
      ,case vl.lmode
         when 0 then 'none'
         when 1 then 'NULL'
         when 2 then 'ROW-S'
         when 3 then 'ROW-X'
         when 4 then 'SHARE'
         when 5 then 'S/ROW-X'
         when 6 then 'EX'
         else null
       end lmode_descr
      ,vl.lmode
      ,vl.request
      ,vl.ctime
      ,case vl.block
         when 0 then 'No'
         when 1 then 'Yes'
         else to_char(block)
       end block
      ,ao.owner || ': ' ||
       ao.object_name || ' (' ||
       ao.object_type || ')'     lock_info
from   v$lock vl
      ,v$session vs
      ,dba_objects ao
where  ao.object_id (+) = vl.id1
and    vs.sid = vl.sid
and    vl.type in ('TM', 'UL')
and   (to_char(vl.sid) = '&&1'
    or   ao.object_name like upper('&&1')
  or   vs.username like upper('&&1')
  or   upper('&&1') = 'ALL')
union all
select vl.sid
      ,vs.username
      ,vl.type
      ,case vl.lmode
         when 0 then 'none'
         when 1 then 'NULL'
         when 2 then 'ROW-S'
         when 3 then 'ROW-X'
         when 4 then 'SHARE'
         when 5 then 'S/ROW-X'
         when 6 then 'EX'
         else null
       end lmode_descr
      ,vl.lmode
      ,vl.request
      ,vl.ctime
      ,case vl.block
         when 0 then 'No'
         when 1 then 'Yes'
         else to_char(block)
       end block
      ,ao.owner || ': ' ||
       ao.object_name || ' (rowid=' ||
/*
       dbms_rowid.rowid_create (1
                               ,vs.row_wait_obj#
                               ,vs.row_wait_file#
                               ,vs.row_wait_block#
                               ,vs.row_wait_row# )  || ')' lock_info
*/
       null lock_info
from   v$lock vl
      ,v$session vs
      ,dba_objects ao
where  ao.object_id (+) = vs.row_wait_obj#
and    vs.sid = vl.sid
and    vl.type in ('TX')
and   (to_char(vl.sid) = '&&1'
  or   ao.object_name like upper('&&1')
  or   vs.username like upper('&&1')
  or   upper('&&1') = 'ALL')
order by
       1
/

clear col
