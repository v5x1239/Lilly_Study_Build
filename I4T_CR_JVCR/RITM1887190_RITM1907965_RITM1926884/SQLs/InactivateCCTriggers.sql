Create table CodeTargetControls as
 /*First instance*/
select p.pageid, 
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,
       1 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[1]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[1]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[1]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[1]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath             
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)
union /*second instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       2 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[2]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[2]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[2]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[2]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                          
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid) 
union /*Third instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       3 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[3]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[3]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[3]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[3]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)                 
union /*fourth instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       4 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[4]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[4]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[4]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[4]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)
union /* Fifth instance */
select p.pageid, 
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,
       5 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[5]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[5]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[5]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[5]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                           
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)
union /*sixth instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       6 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[6]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[6]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[6]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[6]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid) 
union /*Seventh instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       7 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[7]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[7]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[7]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[7]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)                 
union /*Eighth instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       8 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[8]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[8]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[8]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[8]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)                 
union /*Ninth instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       9 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[9]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[9]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[9]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[9]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)
union /*Tenth instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       10 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[10]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[10]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[10]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[10]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid)     
union /*Eleventh instance*/
select p.pageid,
       p.pagerefname,
       t.tdetargetid,
       t.tdetargetrevisionnumber,
       t.tdetargetsetid,
       t.tdetargetsetrevisionnumber,       
       11 codetarget,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP[1]/@VERBATIMTYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() VERBATIMTYPE,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/DICTIONARY[1]/@TYPE',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() DictType,               
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[11]/@NAME',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathName,
       extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[11]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval() PathIDs,
       substr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[11]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(), instr(extract(xmltype(t.xmlnode),
               '/CODINGMAP/CODETARGET[11]/@PATH',
               'xmlns="PhaseForward-MedML-TDE"') .getstringval(),';',-1)+1) CodeTargetControl1,
               t.pathcontrol1id verbatimpath                            
  from pf_tdepathtarget t, pf_page p
 where xmltype(t.xmlnode).existsNode('/CODINGMAP/CODETARGET',
                  'xmlns="PhaseForward-MedML-TDE"') = 1 and
       t.pathpageid = p.pageid and
       p.pagerevisionnumber =
       (select max(pp.pagerevisionnumber)
          from pf_page pp
         where p.pageid = pp.pageid);   
         
/*******************************************************************************************/

Set pagesize 0
Set Heading on
set linesize 400
set trimspool on

COL ruleitemid FORMAT 9999999
COL ruleitemrevisionnumber FORMAT 999999999999999
COL ruleitemrefname FORMAT A42
COL itemrefname FORMAT A42

Spool RuleItemsToBeDeactivated.txt
         
Select ri.ruleitemid,ri.ruleitemrevisionnumber,ri.ruleitemrefname,i.itemrefname
from pf_ruleitem ri
join pf_item i on i.itemid=ri.itemid
  where ri.itemid in (
select 
  substr(pathids,instr(pathids,';',1,5)+1,instr(pathids,';',1,6)-instr(pathids,';',1,5)-1) 
  from codetargetcontrols
where pathname is not null)
  and ri.sectionid in (
select
  substr(pathids,instr(pathids,';',1,3)+1,instr(pathids,';',1,4)-instr(pathids,';',1,3)-1)
  from codetargetcontrols
where pathname is not null) 
  and ri.pageid in (
select
  substr(pathids,instr(pathids,';',1,2)+1,instr(pathids,'!',1,2)-instr(pathids,';',1,2)-1)
  from codetargetcontrols
where pathname is not null)  
	and ri.rulesetid is not null
	and i.itemrevisionnumber = (select max(ii.itemrevisionnumber)
		from pf_item ii 
			where ii.itemid=i.itemid)
	and ri.ruleitemrefname not like '%_E'
	and ri.ruleitemrefname not like '%_R'
order by ri.pageid,ri.ruleitemrefname,i.itemrefname;    

Update pf_ruleitem ri
set ri.active=0
where ri.itemid in
(
select 
  substr(pathids,instr(pathids,';',1,5)+1,instr(pathids,';',1,6)-instr(pathids,';',1,5)-1) 
  from codetargetcontrols
where pathname is not null)
  and ri.sectionid in (
select
  substr(pathids,instr(pathids,';',1,3)+1,instr(pathids,';',1,4)-instr(pathids,';',1,3)-1)
  from codetargetcontrols
where pathname is not null) 
  and ri.pageid in (
select
  substr(pathids,instr(pathids,';',1,2)+1,instr(pathids,'!',1,2)-instr(pathids,';',1,2)-1)
  from codetargetcontrols
where pathname is not null)
	and ri.ruleitemrefname not like '%_E'
	and ri.ruleitemrefname not like '%_R'
	and ri.rulesetid is not null;

commit;

Spool off

drop table CodeTargetControls;

exit
/