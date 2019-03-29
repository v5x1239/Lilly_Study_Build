declare
	l_TabExists PLS_INTEGER;
	sqlStmt		varchar2(1000);
	
begin
	SELECT COUNT (*)
     INTO l_TabExists
     FROM user_tables
    WHERE upper(table_name) = 'INF14628_ITEMDATA';
	
	if (l_TabExists = 0) then
		sqlStmt := 'CREATE TABLE INF14628_ITEMDATA AS '
					|| 'select distinct cr.transactionid, cr.enteredreason new_enteredreason, up.contextid, up.auditorder, up.enteredreason '
					|| 'from pf_itemdata cr, pf_itemdata up '
					|| 'where cr.transactionid = up.transactionid '
					|| 'and ((cr.enteredreason like ''Create user %'' and up.enteredreason not like ''Create user %'') '
					|| '	or (trim(cr.enteredreason) like ''Update user %'' and trim(up.enteredreason) not like ''Update user %'')) '
					|| 'and 1 = 0';
		
		EXECUTE IMMEDIATE sqlStmt;
		
		sqlStmt := 'CREATE INDEX XIE1INF14628_ITEMDATA '
					|| 'ON INF14628_ITEMDATA ' 
					|| '(CONTEXTID, AUDITORDER)';
					
		EXECUTE IMMEDIATE sqlStmt;
		
		sqlStmt := 'CREATE INDEX XIE2INF14628_ITEMDATA '
					|| 'ON INF14628_ITEMDATA ' 
					|| '(TRANSACTIONID)';
					
		EXECUTE IMMEDIATE sqlStmt;
		
	end if;
			
end;
/

begin
	insert into INF14628_ITEMDATA (transactionid, new_enteredreason, contextid, auditorder, enteredreason)
		select distinct cr.transactionid, cr.enteredreason new_enteredreason, up.contextid, up.auditorder, up.enteredreason 
		from pf_itemdata cr, pf_itemdata up 
		where cr.transactionid = up.transactionid 
		and ((cr.enteredreason like 'Create user %' and up.enteredreason not like 'Create user %') 
			or (trim(cr.enteredreason) like 'Update user %' and trim(up.enteredreason) not like 'Update user %'))
		and cr.transactionid not in (select distinct transactionid from INF14628_ITEMDATA);
		
	update pf_itemdata 
	set pf_itemdata.enteredreason = (select ner.new_enteredreason 
							from INF14628_ITEMDATA ner							
							where ner.contextid = pf_itemdata.contextid 
							and ner.auditorder = pf_itemdata.auditorder
							and ner.transactionid = pf_itemdata.transactionid)
	where (enteredreason not like 'Create user %' or trim(enteredreason) not like 'Update user %')
	and exists (select ner.new_enteredreason 
							from INF14628_ITEMDATA ner							
							where ner.contextid = pf_itemdata.contextid 
							and ner.auditorder = pf_itemdata.auditorder
							and ner.transactionid = pf_itemdata.transactionid);
end;
/

commit;

exit;
/