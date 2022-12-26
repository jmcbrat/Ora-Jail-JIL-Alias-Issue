--select * from sys.sys_objects;


select (s_select||s_from||s_where1/*||s_where2*/||s_where4||s_where5||s_finish) as sql_stm
  from (
  SELECT table_name,
       column_name,
       data_type,
       data_length,
       nullable
      ,'select '||chr(39)||table_name||chr(39)||' as table_name,'||chr(39)|| column_name||chr(39)||' as column_name, count('||chr(39)||column_name||chr(39)||') as cnt  ' as s_select
      ,'from '||table_name||' ' as s_from
      ,'where ('/*upper('||column_name||') in ('||chr(39)||'ADDITIONAL'||chr(39)||','||chr(39)||'.'||chr(39)||','||chr(39)||'DATE OF BIRTH'||chr(39)||','||chr(39)||'ALIAS'||chr(39)||','||chr(39)||'ALTERNATE'||chr(39)||','||chr(39)||'ADDL DOB'||chr(39)||','||chr(39)||'ADDITIONAL DOB'||chr(39)||','||chr(39)||'D.O.B.'||chr(39)||','||chr(39)||'MULTIPLE'||chr(39)||') '*/ as s_where1
      --,'   or  upper('||column_name||') in ('||chr(39)||'.'||chr(39)||','||chr(39)||'DOB'||chr(39)||','||chr(39)||'DOBS'||chr(39)||','||chr(39)||'DATE OF BIRTH'||chr(39)||','||chr(39)||'SSN'||chr(39)||','||chr(39)||'DRIVERS LIC'||chr(39)||','||chr(39)||'SOC SEC#'||chr(39)||','||chr(39)||'DRIVERS LICENSE#'||chr(39)||','||chr(39)||'SS NUMBER'||chr(39)||','||chr(39)||'DIFFERENT D.O.B.'||chr(39)||','||chr(39)||'SOCIAL SECURITY NUMBER'||chr(39)||','||chr(39)||'I.D.'||chr(39)||') ' as s_where2
	  --,'   or regexp_like('||column_name||', '||chr(39)||'[0-9]|\_|\+|\_|\!|\@|\#|\$|\%|\^|\&|\*|\\|\||\;|\<|\>|\"'||'|\:|\?|\='||chr(39)||') ' as s_where3
	  ,'   regexp_like('||column_name||', '||chr(39)||'[0-9]{3}\-[0-9]{2}\-[0-9]{4}'||chr(39)||') ' as s_where4
	  ,'   or regexp_like('||column_name||', '||chr(39)||'[0-9]{9}'||chr(39)||')) ' as s_where5
	  ,' union ' as s_finish

FROM cols
where not data_type in ('NUMBER')
  and data_length>=9 -- smallest key value
  --and rownum < 100
ORDER BY table_name, column_id
)
