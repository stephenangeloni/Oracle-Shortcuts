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
