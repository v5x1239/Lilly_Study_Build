update pf_revisionhistory 
set keyid = replace(keyid, ' 0 ', ' ' || to_char(dbuid) || ' ')
where substr(keyid, 1, 3) = '75 '
and instr(keyid, ' 0 ') = instr(keyid, ' ', 1, 2);

commit;

exit;
/
