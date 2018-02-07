SELECT DISTINCT
       b.object_name ref_name, b.object_id ref_id, b.status ref_status
  FROM sys.DBA_OBJECTS a,
       sys.DBA_OBJECTS b,
       (    SELECT object_id, referenced_object_id
              FROM (SELECT object_id, referenced_object_id
                      FROM public_dependency
                     WHERE referenced_object_id <> object_id) pd
        START WITH object_id = 95334
        CONNECT BY PRIOR referenced_object_id = object_id) c
 WHERE     a.object_id = c.object_id
       AND b.object_id = c.referenced_object_id
       AND a.owner IN ('KYC')
       AND b.owner IN ('KYC')
       AND a.object_name <> 'DUAL'
       AND b.object_name <> 'DUAL'
       AND b.object_type = 'MATERIALIZED VIEW'
       
       
  /* Formatted on 07/02/2018 17:23:06 (QP5 v5.269.14213.34746) */

CREATE OR REPLACE PACKAGE KYC.OBJREF

AS

   TYPE OBJREF_record IS RECORD

   (

      object_name   VARCHAR2 (128),

      ref_name      VARCHAR2 (128),

      ref_status    VARCHAR2 (7)

   );


   TYPE OBJREF_table IS TABLE OF OBJREF_record;


   FUNCTION get_OBJREF 

      RETURN OBJREF_table

      PIPELINED;

END;

/


CREATE OR REPLACE PACKAGE BODY KYC.OBJREF

AS

   FUNCTION get_OBJREF 

      RETURN OBJREF_table

      PIPELINED

   IS

      rec             OBJREF_record;

   BEGIN

      FOR objects_rec IN (SELECT OBJECT_NAME, OBJECT_ID

                            FROM sys.DBA_OBJECTS

                           WHERE OWNER = 'KYC')

      LOOP

         FOR details_rec

            IN (SELECT DISTINCT

                       b.object_name ref_name,

                       b.object_id ref_id,

                       b.status ref_status

                  FROM sys.DBA_OBJECTS a,

                       sys.DBA_OBJECTS b,

                       (    SELECT object_id, referenced_object_id

                              FROM (SELECT object_id, referenced_object_id

                                      FROM public_dependency

                                     WHERE referenced_object_id <> object_id) pd

                        START WITH object_id = objects_rec.Object_id

                        CONNECT BY PRIOR referenced_object_id = object_id) c

                 WHERE     a.object_id = c.object_id

                       AND b.object_id = c.referenced_object_id

                       AND a.owner = 'KYC'

                       AND b.owner = 'KYC'

                       AND a.object_name <> 'DUAL'

                       AND b.object_name <> 'DUAL'

                       AND b.object_type = 'MATERIALIZED VIEW')

         LOOP

            SELECT objects_rec.Object_Name,

                   details_rec.Ref_Name,

                   details_rec.Ref_Status

              INTO rec

              FROM DUAL;


            PIPE ROW (rec);

         END LOOP;

      END LOOP;


      RETURN;

   END get_OBJREF;

END;

/
