declare
	l_TabExists PLS_INTEGER;
	sqlStmt		varchar2(1000);
	
begin
	SELECT COUNT (*)
     INTO l_TabExists
     FROM user_tables
    WHERE upper(table_name) = 'PF_ITEMDATA_INF14628';
	
	if (l_TabExists = 0) then
		sqlStmt := 'CREATE TABLE PF_ITEMDATA_INF14628 AS '
					|| 'select distinct cr.transactionid, cr.enteredreason new_enteredreason, up.contextid, up.auditorder, up.enteredreason '
					|| 'from pf_itemdata cr, pf_itemdata up '
					|| 'where cr.transactionid = up.transactionid '
					|| 'and ((cr.enteredreason like ''Create user %'' and up.enteredreason not like ''Create user %'') '
					|| '	or (trim(cr.enteredreason) like ''Update user %'' and trim(up.enteredreason) not like ''Update user %'')) '
					|| 'and 1 = 0';
		
		EXECUTE IMMEDIATE sqlStmt;
		
		sqlStmt := 'CREATE INDEX XIE1PF_ITEMDATA_INF14628 '
					|| 'ON PF_ITEMDATA_INF14628 ' 
					|| '(CONTEXTID, AUDITORDER)';
					
		EXECUTE IMMEDIATE sqlStmt;
		
		sqlStmt := 'CREATE INDEX XIE2PF_ITEMDATA_INF14628 '
					|| 'ON PF_ITEMDATA_INF14628 ' 
					|| '(TRANSACTIONID)';
					
		EXECUTE IMMEDIATE sqlStmt;
		
	end if;
			
end;
/

begin
	insert into pf_itemdata_inf14628 (transactionid, new_enteredreason, contextid, auditorder, enteredreason)
		select distinct cr.transactionid, cr.enteredreason new_enteredreason, up.contextid, up.auditorder, up.enteredreason 
		from pf_itemdata cr, pf_itemdata up 
		where cr.transactionid = up.transactionid 
		and ((cr.enteredreason like 'Create user %' and up.enteredreason not like 'Create user %') 
			or (trim(cr.enteredreason) like 'Update user %' and trim(up.enteredreason) not like 'Update user %'))
		and cr.transactionid not in (select distinct transactionid from pf_itemdata_inf14628);
		
	update pf_itemdata 
	set pf_itemdata.enteredreason = (select ner.new_enteredreason 
							from pf_itemdata_inf14628 ner							
							where ner.contextid = pf_itemdata.contextid 
							and ner.auditorder = pf_itemdata.auditorder
							and ner.transactionid = pf_itemdata.transactionid)
	where (enteredreason not like 'Create user %' or trim(enteredreason) not like 'Update user %')
	and exists (select ner.new_enteredreason 
							from pf_itemdata_inf14628 ner							
							where ner.contextid = pf_itemdata.contextid 
							and ner.auditorder = pf_itemdata.auditorder
							and ner.transactionid = pf_itemdata.transactionid);
end;
/

commit;

exit;
/<!-- MJCTOOLS.RedirectModule
Request URL: /sites/i3/LV/dm/_layouts/download.aspx?SourceUrl=%2Fsites%2Fi3%2FLV%2Fdm%2FStudy%20Build%2FWorkaround%5FINF%2D14628%2ESQL&Source=http%3A%2F%2Fi3docs%2Ei3global%2Enet%2Fsites%2Fi3%2FLV%2Fdm%2FStudy%2520Build%2FForms%2FAllItems%2Easpx&FldUrl=
Site: 5b5ef3e9-2dfa-4a45-ac9d-ee287aaedeb6
Site URL: http://i3docs.i3global.net
Web URL: http://i3docs.i3global.net
IGNORE_REDIRECT_ARG: IgnoreRedirect
RedirectIgnored: False
-->