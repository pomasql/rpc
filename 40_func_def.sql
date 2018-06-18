/*
  Stored function attributes

*/

CREATE OR REPLACE VIEW func_def AS
  SELECT
      fa.code
    , fa.nspname
    , fa.proname
    , p.proretset AS is_set
    , p.provolatile <> 'v' AS is_ro
    , (format_type(p.prorettype, NULL) = 'record' OR t.typtype = 'c') AS is_struct
    , NULLIF(rpc.pg_type_name(CASE WHEN t.typtype = 'd' THEN t.typbasetype ELSE p.prorettype END), 'record') AS result
    , obj_description(p.oid, 'pg_proc') AS anno
    , fa.sample
  FROM func_anno fa
  JOIN pg_catalog.pg_proc p ON (p.pronamespace = to_regnamespace(fa.nspname) AND p.proname = fa.proname)
  LEFT JOIN pg_type t ON (t.oid = p.prorettype)
  ORDER BY 1
;
