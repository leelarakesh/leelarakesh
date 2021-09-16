-- Displays current SQL statements for a particular SID, user or all sessions from V$SQLTEXT
-- Syntax: @show_sql [USERNAME | SID | 'all']
column user_sid format a20
column username format a15
column sid      format 9999999
column serial#  format 9999999
column osuser   format a15
column sql_text format a50
select v.username || '(' || v.sid || ',' || v.serial# || ')' user_sid
      ,v.osuser
      ,to_char(v.logon_time, 'DD-Mon-RR HH24:MI') logon_time
      ,last_call_et
      ,vsql.rows_processed
      ,(select max(decode(vs.piece, 0, vs.sql_text, '')) ||
               max(decode(vs.piece, 1, vs.sql_text, '')) ||
               max(decode(vs.piece, 2, vs.sql_text, '')) ||
               max(decode(vs.piece, 3, vs.sql_text, '')) ||
               max(decode(vs.piece, 4, vs.sql_text, '')) ||
               max(decode(vs.piece, 5, vs.sql_text, '')) ||
               max(decode(vs.piece, 6, vs.sql_text, '')) ||
               max(decode(vs.piece, 7, vs.sql_text, '')) sql_text
        from   v$sqltext_with_newlines vs
        where  vs.address= v.sql_address
        and    vs.piece <= 7) sql_text
from   v$session v
      ,v$sql vsql
where  v.status = 'ACTIVE'
and    v.username is not null
and    vsql.address = v.sql_address
and    rawtohex(v.sql_address) != '00'
and    v.sid not in (select sys_context('USERENV', 'SID')
                     from   dual)
and   (v.username = upper('&&1')
   or  to_char(v.sid) = '&&1'
   or  upper('&&1') = 'ALL')
order by v.sid
/
clear columns


