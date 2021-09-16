CREATE OR REPLACE PROCEDURE PIPE_PRT(i_message   VARCHAR2
                  ,i_pipe_name VARCHAR2) IS
  l_status     NUMBER;
  l_pipe_name  VARCHAR2(255);
  l_user       VARCHAR2(255);
  msg          VARCHAR2(255);
  pipe_error   EXCEPTION;
BEGIN
  l_user:=USER;
  IF i_pipe_name IS NULL
  THEN
    IF SUBSTR(l_user,1,4) = 'OPS$'
    THEN
      l_pipe_name := SUBSTR(l_user,5);
    ELSE
      l_pipe_name := l_user;
    END IF;
  ELSE
      l_pipe_name := i_pipe_name;
  END IF;
--
  DBMS_PIPE.PACK_MESSAGE(i_message);
  l_status := DBMS_PIPE.SEND_MESSAGE(l_pipe_name);
--  prt('l_pipe_name=' || l_pipe_name);
  IF l_status <> 0
  THEN
    RAISE pipe_error;
  END IF;
EXCEPTION
  WHEN pipe_error THEN
    DBMS_OUTPUT.PUT_LINE('Status error (' || l_status || ') in PIPE_PRT ' || SQLERRM);
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error in PIPE_PRT ' || SQLERRM);
END;

