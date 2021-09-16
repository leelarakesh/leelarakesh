-- Displays all Product Involvement Parties from PROD_INVLMT for all Products, or a specific Product or Plan.
-- Sytnax: @pin ['all'|PRD_ID|PROD_SHT_NAM|PLN_ID]
break on cmpny_cd on prd_id on sd on ed
prompt Product Involvement
select pin.cmpny_cd
      ,pin.prd_id
      ,pin.sd
      ,decode(pin.ed, av.high_date, 'HIGH', pin.ed) ed
      ,pin.typ
      ,pin.pty_id
      ,pty.mlng_nam
from   app_values av
      ,pty
      ,prod_invlmt pin
where  pty.id = pin.pty_id
and    pin.prd_id in (select pnm2.prd_id
                      from   prod_nam pnm2
                      where  to_char(pnm2.prd_id) = '&&1'
                         or  upper(pnm2.prod_sht_nam) = upper('&&1')
                         or  upper('&&1') = 'ALL'
                      union all
                      select pln.prd_id
                      from   plan pln
                      where  to_char(pln.id) = '&&1')
order by
       pin.prd_id
      ,pin.ed
      ,pin.sd
/
clear breaks
