DECLARE
   cmd   VARCHAR2 (500);
BEGIN
   FOR table_name
      IN (SELECT OBJECT_NAME, OWNER
            FROM DBA_OBJECTS
           WHERE     OBJECT_TYPE = 'TABLE'
                 AND OWNER = 'SCHEMA'
                 AND OBJECT_NAME LIKE 'T_%')
   LOOP
      cmd :=
            'CREATE TABLE '
         || table_name.OWNER
         || '.'
         || table_name.OBJECT_NAME
         || '_V1 as (select * from '
         || table_name.OWNER
         || '.'
         || table_name.OBJECT_NAME
         || ')';
      --DBMS_OUTPUT.PUT_LINE (cmd) ;
      EXECUTE IMMEDIATE CMD;
   END LOOP;
END;
/