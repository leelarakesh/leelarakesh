--**Changed by        : LEELAR
--**Change Date       : 12-jUNE-2019
--**Change Reason     : Remove_Sched_Jobs
--pass job id list comma separated or complete list 
--*/

Spool "&&VAR/BackEnd/Migration/Spool/Remove_Sched_Jobs.log"

set echo on

set timing on

set serveroutput on


DECLARE

	CURSOR Cur_JOB_LIST
	IS
	WITH t1 AS (
				SELECT 
				q'[
				Test1,
                Test2
				]'	
				AS text From dual )
			,t AS(
				SELECT REPLACE(TRANSLATE(t1.text ,CHR(9)||CHR(13)||CHR(10),'$'), '$','')  AS text 
				--t1.text text
				FROM t1 )
			,t_row AS (  --to get jobids from CSV to Row
				 select regexp_substr(t.text,'[^,]+', 1, level) job_name from t
					connect by regexp_substr(t.text, '[^,]+', 1, level) is not NULL)
			select TRIM(job_name) job_name from t_row
			UNION ALL 
			SELECT job_name From user_scheduler_jobs WHERE 1=1  ---remove caluse to kill all jobs
			;

	TYPE Dm_Cur_JOB_LIST_Type IS TABLE OF Cur_JOB_LIST%ROWTYPE INDEX BY PLS_INTEGER;
	Dm_Cur_JOB_LIST_VAR 	Dm_Cur_JOB_LIST_Type;

	ttime 	Number :=dbms_utility.get_time;
	
	v_limit NUMBER := 50000;
	

	l_job_name 	 	user_scheduler_jobs.job_name%TYPE;

BEGIN

	DBMS_OUTPUT.PUT_LINE('Remove Jobs starts--'||systimestamp);   


	IF Cur_JOB_LIST%ISOPEN THEN
	CLOSE Cur_JOB_LIST;
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('Going to fetch from Cursor Cur_JOB_LIST :: Start');   
	OPEN Cur_JOB_LIST;
	LOOP
		FETCH Cur_JOB_LIST BULK COLLECT
		INTO Dm_Cur_JOB_LIST_VAR LIMIT v_limit;
		EXIT WHEN Dm_Cur_JOB_LIST_VAR.COUNT=0;
		
		DBMS_OUTPUT.PUT_LINE('Going to fetch Cur_JOB_LIST count--'||Dm_Cur_JOB_LIST_VAR.COUNT);   
		IF Dm_Cur_JOB_LIST_VAR.COUNT > 0 THEN

            for indx IN 1 .. Dm_Cur_JOB_LIST_VAR.COUNT loop
                DBMS_OUTPUT.PUT_LINE('--------------------------Cur_JOB_LIST:-->'||indx||'-job_name-'|| Dm_Cur_JOB_LIST_VAR(indx).job_name);

                   l_job_name:=Dm_Cur_JOB_LIST_VAR(indx).job_name;

                    BEGIN
                        SELECT job_name INTO l_job_name From user_scheduler_jobs WHERE job_name =l_job_name;
                    EXCEPTION WHEN OTHERS THEN 
                        l_job_name:='#';
                    END; 
					 DBMS_OUTPUT.PUT_LINE(Dm_Cur_JOB_LIST_VAR(indx).job_name||'about to stop_job--'|| l_job_name);
                    IF l_job_name<>'#' THEN
                        dbms_scheduler.stop_job(job_name => l_job_name);
                    END IF;

                    BEGIN
                        SELECT job_name INTO l_job_name From user_scheduler_jobs WHERE job_name =l_job_name;
                    EXCEPTION WHEN OTHERS THEN 
                        l_job_name:='#';
                    END; 

					 DBMS_OUTPUT.PUT_LINE(Dm_Cur_JOB_LIST_VAR(indx).job_name||'about to drop_job--'|| l_job_name);

                    IF l_job_name<>'#' THEN
                        dbms_scheduler.drop_job(job_name => l_job_name);
                    END IF;


            end loop;
		END IF;
	END LOOP;
	
	DBMS_OUTPUT.PUT_LINE('Dm_Cur_JOB_LIST_VAR :: Ends');

    dbms_output.put_line('Timelapsed---'||( (dbms_utility.get_time-ttime)/100) || ' seconds....completed at-->'||systimestamp );

EXCEPTION  
   
    WHEN OTHERS THEN
		DBMS_OUTPUT.PUT_LINE('Inside when others of UPDATE_SUTL_GTAP_UH: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
		DBMS_OUTPUT.put_line ('Exception in when others :: '||SQLERRM);
END;
/
