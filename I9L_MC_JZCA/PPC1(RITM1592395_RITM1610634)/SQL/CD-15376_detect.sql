-- *****************************************************************
-- CD-15376.sql
-- 
-- Copyright © 2015 Oracle Corporation, All rights reserved.
-- Oracle Health Sciences Global Business Unit
-- 100 Crosby Drive, Bedford, MA 01730
--
-- Description: INC000003807607 | Lilly 
-- This workaround script detects workflow rule contexts with bug:
--    CD-15376 The Rule's primary key context and the order of rule dependencies 
--    always have to be consistent within the RuleAttachmentSet in MedML
-- It creates a script to change the key context to the next dependency that does not use
-- a repeating visit. Yeilds an error if no such dependency exists.
--
-- Author:      Mike O'Connell
--
-- Revision History
-- Date            Author             Reason for Change
-- ----------------------------------------------------------------
-- 10 DEC 2015     Mike O'Connell     Created
-- *****************************************************************

spool CD-15376_fix.sql
set serveroutput on
set feedback off


Declare

item_label  varchar2(4000);
new_ruleitemid number;
new_visit_mnemonic  varchar2(63);
new_form_mnemonic varchar2(63);
new_item_refname  varchar2(63);
output_str varchar2(4000);
rule_count number;
 
begin
     
  rule_count := 0;
  for keycontext in ( 
 Select 
    r.rulerefname, 
    (select rd.resourcestring from pf_chapter_cur c, pf_resourcedata_cur rd  
        where ri.chapterid = c.chapterid and rd.resourceid=c.chaptermnemonic) as visit_mnemonic,
    (select rd1.resourcestring from pf_page p, pf_resourcedata_cur rd1  where 
        p.pagerevisionnumber = (select max(p1.pagerevisionnumber) from pf_page p1 where p.pageid=p1.pageid) and 
        ri.pageid = p.pageid and rd1.resourceid=p.pagemnemonic) as form_mnemonic,
    (select i.itemrefname from pf_item i  where 
        i.itemrevisionnumber = (select max(i1.itemrevisionnumber) from pf_item i1 where i.itemid=i1.itemid) and 
        ri.itemid =i.itemid) as item_refname,
    (select rd2.resourcestring from pf_item i, pf_resourcedata_cur rd2  where 
        i.itemrevisionnumber = (select max(i1.itemrevisionnumber) from pf_item i1 where i.itemid=i1.itemid) and 
        ri.itemid =i.itemid and rd2.resourceid=i.itemlabel) as item_label,
    r.ruleid, r.rulerevisionnumber, ri.ruleitemid, ri.ruleitemrefname, ri.ruleitemrevisionnumber, 
    ri.chapterid, ri.pageid, ri.sectionid, ri.itemsetid, ri.itemid
    from pf_rules r, pf_ruleitem ri
    where 
    r.rulerevisionnumber = (select max(r1.rulerevisionnumber) from pf_rules r1 where r1.ruleid=r.ruleid) and
    r.rulescript  Like '%Step(%' and       /* Uses the Step() function */
    r.scripttype in (3,10,11) and          /* Server Calculation, workflow, or global condition */
    r.rulescript not Like '%Current(%' and /* Does not require a repeating visit key context */
    ri.ruleid = r.ruleid and 
    ri.ruleitemrevisionnumber  = (select max(ri1.ruleitemrevisionnumber) from pf_ruleitem ri1 
    where ri1.ruleid=ri.ruleid and ri1.ruleitemid = ri.ruleitemid) and 
    ri.rulesetid is null and               /* KeyContext */
    ri.applyevent = 2 and                  /* Dependency type TRIGGER */
    exists (select vec.chapterid from pf_vechapter vec where vec.chapterid = ri.chapterid and 
    BITAND(vec.chapterproperties, 4)=4 and /* Repeating visit */
    BITAND(ChapterProperties, 8)=8) and    /* Dynamic visit */
    /* Has more than one dependency. */
    (Select count(1) from pf_rules r2, pf_ruleitem ri2 where 
        r2.ruleid = r.ruleid and
        r2.rulerevisionnumber = (select max(r4.rulerevisionnumber) from pf_rules r4 where r4.ruleid=r2.ruleid) and
        ri2.ruleid = r2.ruleid and 
        ri2.ruleitemrevisionnumber  = (select max(ri3.ruleitemrevisionnumber) from pf_ruleitem ri3 where ri3.ruleid=ri2.ruleid)) > 1 
        )
    loop
    
        rule_count:= rule_count + 1;

        if rule_count = 1 then
           dbms_output.put_line('-- CD-15376 workaround ' );
        end if;

        -- Display information for problematic rule
        dbms_output.put_line('-- rule refname = ' ||  keycontext.rulerefname || ', rule context = ' || keycontext.ruleitemrefname  );
        dbms_output.put_line('-- Old Key Context: ruleitemid = ' ||  keycontext.ruleitemid || ', visit_mnemonic = ' ||          keycontext.visit_mnemonic || ', form_mnemonic = ' || keycontext.form_mnemonic || ', item_refname = ' ||  keycontext.item_refname || 
        ',  item_label = ' || keycontext.item_label);

     -- Find the first dependency that is not to a dynamic repeating visit.
       BEGIN
        select ruleitemid, 
            (select rd.resourcestring from pf_chapter_cur c, pf_resourcedata_cur rd  
                where ri.chapterid = c.chapterid and rd.resourceid=c.chaptermnemonic) as visit_mnemonic,
            (select rd1.resourcestring from pf_page p, pf_resourcedata_cur rd1  where 
                p.pagerevisionnumber = (select max(p1.pagerevisionnumber) from pf_page p1 where p.pageid=p1.pageid) and 
                ri.pageid = p.pageid and rd1.resourceid=p.pagemnemonic) as form_mnemonic,
            (select i.itemrefname from pf_item i  where 
                i.itemrevisionnumber = (select max(i1.itemrevisionnumber) from pf_item i1 where i.itemid=i1.itemid) and 
                ri.itemid =i.itemid) as item_refname 
            into new_ruleitemid, new_visit_mnemonic, new_form_mnemonic, new_item_refname  from pf_rules r, pf_ruleitem ri
            where 
            r.ruleid = keycontext.ruleid and
            ri.rulesetid = keycontext.ruleitemid and
            r.rulerevisionnumber = keycontext.rulerevisionnumber and
            ri.ruleitemrevisionnumber  = keycontext.ruleitemrevisionnumber and
            ri.ruleid = r.ruleid and 
            ri.chapterid not in (select vec.chapterid from pf_vechapter vec where BITAND(vec.chapterproperties, 4)=4) and 
            rownum=1;
            
        dbms_output.put_line('-- New key context: ruleitemid = ' || new_ruleitemid || ', visit_mnemonic = ' ||  new_visit_mnemonic || 
                      ', form_mnemonic = ' || new_form_mnemonic || ', item_refname = ' ||  new_item_refname);

        EXCEPTION
         WHEN NO_DATA_FOUND THEN
          -- This rule context does not have any dependencies not on a repeating visit.
          dbms_output.put_line('-- ERROR: This rule has only dependencies on repeating visits. ' ||
           'The dependency types must change from TRIGGER to DEPENDENCY.');
          continue;
        END;
        
        output_str := 'update pf_ruleitem ri set rulesetid = null where ' ||
            'ri.ruleid = ' || keycontext.ruleid || ' and ' ||
            'ri.ruleitemid = ' || new_ruleitemid || ' and ' ||
            'ri.ruleitemrevisionnumber = (select max(ri1.ruleitemrevisionnumber) from pf_ruleitem ri1 ' ||
            'where ri1.ruleid=ri.ruleid and ri1.ruleitemid = ri.ruleitemid);';

        dbms_output.put_line(output_str);
        
        output_str := 'update pf_ruleitem ri set rulesetid = ' || new_ruleitemid || ' where ' ||
            'ri.ruleid = ' || keycontext.ruleid || ' and ' ||
            'ri.ruleitemid <> ' || new_ruleitemid || ' and ' ||
            'ri.ruleitemrevisionnumber = (select max(ri1.ruleitemrevisionnumber) from pf_ruleitem ri1  ' ||
            'where ri1.ruleid=ri.ruleid and ri1.ruleitemid = ri.ruleitemid);';

        dbms_output.put_line(output_str);
        dbms_output.put_line('');

        commit;
  
   end loop;
   if rule_count > 0 then
      dbms_output.put_line('commit;');
      dbms_output.put_line('/');
   else
      dbms_output.put_line('-- CD-15376 workaround ' );
      dbms_output.put_line('-- No errant rules found ' );
   end if;

exception
  when others then raise;

end;
/

spool off;

exit;
