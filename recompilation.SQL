SET SERVEROUTPUT ON SIZE 1000000
DECLARE
inp varchar(10);
SLN NUMBER:=0;
count_p_invalid NUMBER:=0;
count_F_invalid NUMBER:=0;
count_pk_invalid NUMBER:=0;
count_pk_bd_invalid NUMBER:=0;
count_S_invalid NUMBER:=0;
cout NUMBER:=0;
BEGIN
   SELECT count(1) 
  into cout
  FROM   user_objects
  WHERE  object_type IN ('PACKAGE', 'PACKAGE BODY','FUNCTION','PROCEDURE','SYNONYM')
   AND    status != 'VALID'
	;--and OWNER =USER;
  	--and OWNER <>'SYS';

  	  FOR cur_rec IN (SELECT USER as "owner",
                         object_name,
                         object_type,
                         DECODE(object_type, 'FUNCTION', 2,
                                             'PROCEDURE', 3,
                                             'PACKAGE', 5,
											 'SYNONYM',1,
                                             4 ) AS recompile_order
                  FROM   user_objects
                  WHERE  object_type IN ('PACKAGE', 'PACKAGE BODY','FUNCTION','PROCEDURE','SYNONYM')
                  AND    status != 'VALID'
                  --AND OWNER =USER
                   --AND object_name='AP_BA_ALERT_HISTORY'
                  --and OWNER <>'SYS'
                  ORDER BY 4)
  LOOP
    BEGIN
      
      IF cur_rec.object_type = 'PACKAGE' THEN
      BEGIN
        count_pk_invalid :=count_pk_invalid +1;
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' "' ||  cur_rec.object_name || '" COMPILE';
      END;
      ElSIF cur_rec.object_type = 'PACKAGE BODY' THEN
        BEGIN
         count_pk_bd_invalid :=count_pk_bd_invalid +1;
       EXECUTE IMMEDIATE 'ALTER PACKAGE "' ||  cur_rec.object_name || '" COMPILE BODY';
        END;
      ElSIF cur_rec.object_type = 'FUNCTION' THEN
         BEGIN
          count_f_invalid :=count_f_invalid +1;
          EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' "' ||  cur_rec.object_name || '" COMPILE';
         END;
      ElSIF cur_rec.object_type = 'PROCEDURE' THEN
        BEGIN
           count_p_invalid :=count_p_invalid +1;
            EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' "' ||  cur_rec.object_name || '" COMPILE';
         END;
		ElSE
        BEGIN
           count_S_invalid :=count_S_invalid +1;
            EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || ' "' ||  cur_rec.object_name || '" COMPILE';
         END;
      END IF;

  EXCEPTION
      WHEN OTHERS THEN
      
      if ((count_p_invalid+count_F_invalid+count_pk_invalid+count_pk_bd_invalid+count_S_invalid)=cout) then
      	   DBMS_OUTPUT.put_line('Completed compilation for USER:'||USER);
      	   DBMS_OUTPUT.put_line('	');
           DBMS_OUTPUT.put_line('Completed compilation of '||': '||count_p_invalid ||':'||' PROCEDURES');
           DBMS_OUTPUT.put_line('Completed compilation of '||': '||count_F_invalid ||':'|| ' FUNCTIONS');
           DBMS_OUTPUT.put_line('Completed compilation of '||': '||count_pk_invalid ||':'|| ' PACKAGES');
           DBMS_OUTPUT.put_line('Completed compilation of '||': '||count_pk_bd_invalid ||':'|| ' PACKAGE BODYS');
		   DBMS_OUTPUT.put_line('Completed compilation of '||': '||count_S_invalid ||':'|| ' SYNONYM');
           DBMS_OUTPUT.put_line('Total No of Invalid objects '||': '||cout);
           DBMS_OUTPUT.put_line('	');
      end if;
 /* 
  EXCEPTION
      WHEN OTHERS THEN
      DBMS_OUTPUT.put_line(cur_rec.object_type || ' : ' || cur_rec.owner ||  ' : ' || cur_rec.object_name);
      */
    END;
       
  END LOOP;
 BEGIN
 beGIN
count_p_invalid :=0;
count_F_invalid :=0;
count_pk_invalid :=0;
count_pk_bd_invalid :=0;
 select sum(decode(object_type, 'PACKAGE', 1, 0)) as PKG,
        sum(decode(object_type, 'PACKAGE BODY', 1, 0)) as PKGBD,
        sum(decode(object_type, 'FUNCTION', 1, 0)) as FUNC,
        sum(decode(object_type, 'PROCEDURE', 1, 0)) as PROC,
		sum(decode(object_type, 'SYNONYM', 1, 0)) as SYN
   INTO count_pk_invalid,
        count_pk_bd_invalid,
        count_F_invalid,
        count_p_invalid,
		count_s_invalid
   FROM user_objects
  WHERE object_type IN ('PACKAGE', 'PACKAGE BODY', 'FUNCTION', 'PROCEDURE','SYNONYM')
    AND status != 'VALID'
    ;--and OWNER = USER;
    --and OWNER <> 'SYS';
  
  END;
  		DBMS_OUTPUT.put_line('---------------------After recompilation----------------------');
  		DBMS_OUTPUT.put_line('No of Invalid '||':'|| ' PROCEDURES'||':'|| count_p_invalid );
        DBMS_OUTPUT.put_line('No of Invalid '||':'|| ' FUNCTIONS' ||': '|| count_F_invalid );
        DBMS_OUTPUT.put_line('No of Invalid '||':'|| ' PACKAGES' ||': '|| count_pk_invalid );
        DBMS_OUTPUT.put_line('No of Invalid '||':'|| ' PACKAGE BODYS'||': '|| count_pk_bd_invalid );
		DBMS_OUTPUT.put_line('No of Invalid '||':'|| ' SYNONYM'||': '|| count_s_invalid );
        DBMS_OUTPUT.put_line('Total No of Invalid objects '||': '||(count_p_invalid+count_F_invalid+count_pk_invalid+count_pk_bd_invalid+count_s_invalid));        
        DBMS_OUTPUT.put_line('	');
        DBMS_OUTPUT.put_line('---------------------Invalid Objects----------------------');
        

    	  FOR cur_recd IN (SELECT USER "owner",
                         object_name,
                         object_type,
                         DECODE(object_type, 'FUNCTION', 1,
                                             'PROCEDURE', 2,
                                             'PACKAGE', 3,
                                             'SYNONYM', 5,
                                             4 ) AS recompile_order
                  FROM   user_objects
                  WHERE object_type IN ('PACKAGE', 'PACKAGE BODY', 'FUNCTION', 'PROCEDURE','SYNONYM')
                  AND status != 'VALID'
                  --and OWNER = USER
                  --and OWNER <> 'SYS'
                  ORDER BY 1,4)
        LOOP
          BEGIN	
          		   		sln:=sln+1;
               DBMS_OUTPUT.put_line(sln||' > '||rpad(cur_recd.object_type,18,' ')||':::'||LOWER(USER)||'.'||cur_recd.object_name);
                         END;
        END LOOP;

        
END;

     EXCEPTION
      WHEN OTHERS THEN
      RAISE;
      END;
/
