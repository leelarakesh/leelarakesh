-- Displays the query text of a specified view.
-- Syntax: @view [view_name]
-- Can be run as either an OPS$ user or the view owner.
column text format a132
set long 200000
select text
from   all_views
where  view_name = upper('&&1')
and    owner = (select table_owner
                from   user_synonyms
                group by table_owner)
and    user like 'OPS$%'
union all
select text
from   all_views
where  view_name = upper('&&1')
and    owner = user
and    user not like 'OPS$%'
/
clear col
