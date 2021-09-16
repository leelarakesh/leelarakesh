column machine format a20

select SID                            
--,USERNAME                       
,STATUS                         
,SCHEMANAME                     
,OSUSER                         
,MACHINE                        
,TYPE                           
,MODULE                         
,ACTION                         
,CLIENT_INFO                    
,LOGON_TIME                     
from v$session
/
