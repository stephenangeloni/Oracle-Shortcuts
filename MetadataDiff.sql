--Creates a script to make OLDTABLE like NEWTABLE
select DBMS_METADATA_DIFF.COMPARE_ALTER('TABLE','OLDTABLE','NEWTABLE', 'OLDSCHEMA', 'NEWSCHEMA') from dual;

BEGIN   
  EXECUTE IMMEDIATE      
    'ALTER TABLE DB_ODS.PM1E_T_UBS_LOOKUP_COUNTRY ADD (IS_SENSITIVE  CHAR(1 CHAR))';
EXCEPTION   
  WHEN OTHERS   
  THEN      
    IF (SQLCODE = -1430)      
    THEN         
      NULL;      
    ELSE         
      RAISE;      
    END IF;
END;
