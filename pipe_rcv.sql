create or replace procedure PIPE_RCV(p_input varchar2
                                    ,p_pipename varchar2) as
   l_input     VARCHAR2(3)  := p_input;
   l_minutes   NUMBER(3,2)  := .25;
   l_seconds   NUMBER(3)    := l_minutes * 60;
   l_status    NUMBER(3);
   msg        VARCHAR2(255);
   pipe_name   VARCHAR2(30) := p_pipename;
BEGIN
  IF l_input IS NOT NULL
  THEN
    l_seconds := to_NUMBER(l_input);
  END IF;
  LOOP
    l_status := DBMS_PIPE.RECEIVE_MESSAGE(pipe_name
                                         ,l_seconds);
    IF l_status = 0
    THEN
      DBMS_PIPE.UNPACK_MESSAGE(msg);
      dbms_output.put_line(msg);
    ELSE
      EXIT;
    END IF;
  END LOOP;
END PIPE_RCV;
/

