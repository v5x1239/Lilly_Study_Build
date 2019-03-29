--  File        : Import_WFRULETRIG.sql                                                 
--  Date        : 02-Aug-2018			 		                        
--  Author      : Pandiarajan Pandidurai                                       

--  Description : This script will spool the xml file which can be imported to the InForm with the help of PFImport tool. It will accept an argument which is item refname in which PFImport should happen. The Item should be present in a form which is present only in one visit like CIV1001_LF1 form. Note: Before use this sql please ensure that the <Item_Value> and <Item_Refname> parameters has been updated as per the study requirements.                   		         

--  Usage       : Sqlplus <trialuid>/<trialpid>@<oracle_instance> @Import_WFRULETRIG.sql
 

Set Term Off

CREATE OR REPLACE FUNCTION Get_FormRefname(i_itemrefname IN varchar2)
   RETURN varchar2
IS
    i_return VARCHAR2(32000);      
BEGIN
      
select distinct substr(refname,1,instr(refname,'.',1,1)-1) into i_return from pf_path where refname like '%'||'.'||i_itemrefname;
    RETURN i_return;
END;
/

CREATE OR REPLACE FUNCTION Get_VisitRefname(p_pagerefname IN varchar2)
   RETURN varchar2
IS
    i_return VARCHAR2(32000);      
BEGIN
      
select distinct chapterrefname into i_return from pf_chapter where chapterid = (select distinct chapterid from pf_vechapterpage where pageid = (select distinct pageid from pf_page where pagerefname = p_pagerefname)); 
    RETURN i_return;
END;
/

CREATE OR REPLACE FUNCTION Get_Path(i_itemrefname IN varchar2)
   RETURN varchar2
IS
    i_return VARCHAR2(32000);      
BEGIN
      
select distinct substr(refname,instr(refname,'.',1,1)+1,(instr(refname,'.',1,2)-instr(refname,'.',1,1)-1))||'.0.'||substr(refname,instr(refname,'.',1,2)+1) into i_return from pf_path where refname like '%'||'.'||i_itemrefname;
    RETURN i_return;
END;
/

CREATE OR REPLACE FUNCTION Check_Data(c_controlrefname IN varchar2,p_patientid number)
   RETURN varchar2
IS
    i_return VARCHAR2(32000);
	i_count number;
BEGIN

select count(distinct to_Char(cd.numvalue)||cd.strvalue) into i_count
from pf_controldata cd, pf_itemcontext ic, pf_patientnumber pn, pf_itemdata id
where cd.contextid = ic.contextid
and ic.subjectkeyid = pn.patientid
and id.contextid = cd.contextid
and id.auditorder = cd.auditorder
and id.entereddate = (select max(entereddate) from pf_itemcontext t where t.contextid = id.contextid) 
and cd.auditorder = (select max(temp.auditorder) from pf_controldata temp where temp.contextid = cd.contextid) 
and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = pn.patientid)
and cd.controlid = (select distinct controlid from pf_control where controlrefname = c_controlrefname)
and pn.patientid = p_patientid;

If i_count = 1 Then
     
	select distinct to_Char(cd.numvalue)||cd.strvalue into i_return
	from pf_controldata cd, pf_itemcontext ic, pf_patientnumber pn, pf_itemdata id
	where cd.contextid = ic.contextid
	and ic.subjectkeyid = pn.patientid
	and id.contextid = cd.contextid
	and id.auditorder = cd.auditorder
	and id.entereddate = (select max(entereddate) from pf_itemcontext t where t.contextid = id.contextid) 
	and cd.auditorder = (select max(temp.auditorder) from pf_controldata temp where temp.contextid = cd.contextid) 
	and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = pn.patientid)
	and cd.controlid = (select distinct controlid from pf_control where controlrefname = c_controlrefname)
	and pn.patientid = p_patientid;
End If;
    RETURN i_return;
END;
/

CREATE OR REPLACE FUNCTION Check_Data1(c_controlrefname IN varchar2,p_patientid number)
   RETURN varchar2
IS
    i_return VARCHAR2(32000);      
BEGIN
      
select Count(*) into i_return
from pf_controldata cd, pf_itemcontext ic, pf_patientnumber pn
where cd.contextid = ic.contextid
and ic.subjectkeyid = pn.patientid 
and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = pn.patientid)
and cd.controlid in (select controlid from pf_control where controlrefname = c_controlrefname)
and pn.patientid = p_patientid;
    RETURN i_return;
END;
/

CREATE OR REPLACE FUNCTION Get_Status(i_itemrefname IN varchar2,i_patientid IN NUMBER)
   RETURN NUMBER
IS
    i_return VARCHAR2(32000);
	i_return1 NUMBER;
	i_status NUMBER;
	i_count NUMBER;
	i_lockfreeze VARCHAR2(32000);
BEGIN
    i_return1 := 0;
	 
	select distinct substr(refname,1,instr(refname,'.',1,1)-1) into i_return from pf_path where refname like '%'||'.'||i_itemrefname;
	
	select locked into i_lockfreeze from PF_BOOKSTATE where patientid = i_patientid;
	If i_lockfreeze is not null Then
		RETURN 1;
	End If;
	
	select frozen into i_lockfreeze from PF_BOOKSTATE where patientid = i_patientid;
	If i_lockfreeze is not null Then
		RETURN 1;
	End If;
	
	select count(distinct sv.subjectchapterid) into i_count from PF_SUBJECTVECHAPTERPAGE sv,PF_SUBJECTVECHAPTER sq where sv.pageid in (select distinct pageid from pf_page where pagerefname = i_return) and sv.subjectchapterid = sq.subjectchapterid and sv.lockedstate = 1 and sq.SUBJECTKEYID = i_patientid;
	
	If i_count = 1 Then
		select distinct to_number(sv.lockedstate) into i_status from PF_SUBJECTVECHAPTERPAGE sv,PF_SUBJECTVECHAPTER sq where sv.pageid in (select distinct pageid from pf_page where pagerefname = i_return) and sv.subjectchapterid = sq.subjectchapterid and sv.lockedstate = 1 and sq.SUBJECTKEYID = i_patientid;
	
		If i_status = 1 Then
			RETURN 1;
		End If;
	End If;
	
	select count(distinct sv.subjectchapterid) into i_count from PF_SUBJECTVECHAPTERPAGE sv,PF_SUBJECTVECHAPTER sq where sv.pageid in (select distinct pageid from pf_page where pagerefname = i_return) and sv.subjectchapterid = sq.subjectchapterid and sv.frozenstate = 1 and sq.SUBJECTKEYID = i_patientid; 
	
	If i_count = 1 Then	
		select distinct to_number(sv.frozenstate) into i_status from PF_SUBJECTVECHAPTERPAGE sv,PF_SUBJECTVECHAPTER sq where sv.pageid in (select distinct pageid from pf_page where pagerefname = i_return) and sv.subjectchapterid = sq.subjectchapterid and sv.frozenstate = 1 and sq.SUBJECTKEYID = i_patientid; 
	
		If i_status = 1 and i_return1 = 0 Then
			RETURN 1;
		End If;
	End If;
	
	select count(distinct sv.subjectchapterid) into i_count from PF_SUBJECTVECHAPTERPAGE sv,PF_SUBJECTVECHAPTER sq where sv.pageid in (select distinct pageid from pf_page where pagerefname = i_return) and sv.subjectchapterid = sq.subjectchapterid and sv.HASCOMMENTSSTATE =1 and sv.notdonestate = 1 and sq.SUBJECTKEYID = i_patientid; 
	
	If i_count = 1 Then	
		select distinct to_number(sv.HASCOMMENTSSTATE) into i_status from PF_SUBJECTVECHAPTERPAGE sv,PF_SUBJECTVECHAPTER sq where sv.pageid in (select distinct pageid from pf_page where pagerefname = i_return) and sv.subjectchapterid = sq.subjectchapterid and sv.HASCOMMENTSSTATE =1 and sv.notdonestate = 1 and sq.SUBJECTKEYID = i_patientid; 
	
		If i_status = 1 and i_return1 = 0 Then
			RETURN 1;
		End If;
	End If;
	
	select count(distinct cd.strvalue) into i_count from pf_controldata cd where cd.contextid = (select max(contextid) from pf_itemcontext  where itemid = (select distinct itemid from pf_item where itemrefname = i_itemrefname) and subjectkeyid = i_patientid) and cd.auditorder = (select max(auditorder) from pf_controldata cd1 where cd1.contextid = cd.contextid) and cd.strvalue in (select strvalue from pf_element where strvalue like '%Element');
	
	If i_count >= 1 Then
		RETURN 1;
	End If;
	
	RETURN 0;
END;
/

CREATE OR REPLACE FUNCTION Get_SiteID(i_patientid IN number)
   RETURN varchar2
IS
    i_return number;      
	i_return1 number;
	i_return2 varchar2(2000);
BEGIN
      
select distinct a.siteid into i_return from pf_patient a where a.patientid = i_patientid and a.patientrevisionnumber = (select max(tem1.patientrevisionnumber) from pf_patient tem1 where tem1.patientid = a.patientid);
select max(a.siterevisionnumber) into i_return1 from pf_patient a where a.patientid = i_patientid and a.patientrevisionnumber = (select max(tem1.patientrevisionnumber) from pf_patient tem1 where tem1.patientid = a.patientid);
select distinct to_char(sitemnemonic) into i_return2 from pf_site where siteid = i_return and siterevisionnumber = i_return1;
    RETURN i_return2;
END;
/

SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMSPOOL ON
SET LINESIZE 32767
SET COLSEP ,
SET SHOW OFF
SET SHOWMODE OFF
SET VERIFY OFF

Spool Import_WFRULETRIG.xml

select '<?xml version="1.0"?>' from dual;

select CHR(10)||'<CLINICALDATA>' from dual;

select CHR(10)||'<EDITPATIENTDATA PATIENTNUMBER="'||pn.patientnumberstr||'" SITEMNEMONIC="'||Get_SiteID(p.patientid)||'" FORMSETREFNAME="'||Get_VisitRefname(Get_FormRefname('WFRULETRIG'))||'" FORMREFNAME="'||Get_FormRefname('WFRULETRIG')||'" REASONOTHER="Updateworkflow automation">'||CHR(10)||'<DATA TAG="'||Get_Path('WFRULETRIG')||'" VALUE="'||''||'"/>'||CHR(10)||'</EDITPATIENTDATA>' from
pf_patientnumber pn, pf_patient p
where
pn.patientid = p.patientid
and p.patientrevisionnumber = (select max(tem1.patientrevisionnumber) from pf_patient tem1 where tem1.patientid = p.patientid)
and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = p.patientid)
and pn.sequencesetid = (select max(tem2.sequencesetid) from pf_patientnumber tem2 where tem2.patientid = pn.patientid)
and Check_Data('WFRULETRIG',pn.patientid) is not null
and Check_Data1('WFRULETRIG',pn.patientid) > 0
and Get_Status('WFRULETRIG',pn.patientid) = 0;


select CHR(10)||'<EDITPATIENTDATA PATIENTNUMBER="'||pn.patientnumberstr||'" SITEMNEMONIC="'||Get_SiteID(p.patientid)||'" FORMSETREFNAME="'||Get_VisitRefname(Get_FormRefname('WFRULETRIG'))||'" FORMREFNAME="'||Get_FormRefname('WFRULETRIG')||'" REASONOTHER="Updateworkflow automation">'||CHR(10)||'<DATA TAG="'||Get_Path('WFRULETRIG')||'" VALUE="'||'Y'||'"/>'||CHR(10)||'</EDITPATIENTDATA>' from
pf_patientnumber pn, pf_patient p
where
pn.patientid = p.patientid
and p.patientrevisionnumber = (select max(tem1.patientrevisionnumber) from pf_patient tem1 where tem1.patientid = p.patientid)
and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = p.patientid)
and pn.sequencesetid = (select max(tem2.sequencesetid) from pf_patientnumber tem2 where tem2.patientid = pn.patientid)
and Check_Data('WFRULETRIG',pn.patientid) is not null
and Check_Data1('WFRULETRIG',pn.patientid) > 0
and Get_Status('WFRULETRIG',pn.patientid) = 0;

select CHR(10)||'<EDITPATIENTDATA PATIENTNUMBER="'||pn.patientnumberstr||'" SITEMNEMONIC="'||Get_SiteID(p.patientid)||'" FORMSETREFNAME="'||Get_VisitRefname(Get_FormRefname('WFRULETRIG'))||'" FORMREFNAME="'||Get_FormRefname('WFRULETRIG')||'" REASONOTHER="Updateworkflow automation">'||CHR(10)||'<DATA TAG="'||Get_Path('WFRULETRIG')||'" VALUE="'||'Y'||'"/>'||CHR(10)||'</EDITPATIENTDATA>' from
pf_patientnumber pn, pf_patient p
where
pn.patientid = p.patientid
and p.patientrevisionnumber = (select max(tem1.patientrevisionnumber) from pf_patient tem1 where tem1.patientid = p.patientid)
and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = p.patientid)
and pn.sequencesetid = (select max(tem2.sequencesetid) from pf_patientnumber tem2 where tem2.patientid = pn.patientid)
and Check_Data('WFRULETRIG',pn.patientid) is null
and Check_Data1('WFRULETRIG',pn.patientid) > 0
and Get_Status('WFRULETRIG',pn.patientid) = 0;

select CHR(10)||'<PATIENTDATA PATIENTNUMBER="'||pn.patientnumberstr||'" SITEMNEMONIC="'||Get_SiteID(p.patientid)||'" FORMSETREFNAME="'||Get_VisitRefname(Get_FormRefname('WFRULETRIG'))||'" FORMREFNAME="'||Get_FormRefname('WFRULETRIG')||'">'||CHR(10)||'<DATA TAG="'||Get_Path('WFRULETRIG')||'" VALUE="'||'Y'||'"/>'||CHR(10)||'</PATIENTDATA>' from
pf_patientnumber pn, pf_patient p
where
pn.patientid = p.patientid
and p.patientrevisionnumber = (select max(tem1.patientrevisionnumber) from pf_patient tem1 where tem1.patientid = p.patientid)
and pn.patientrevisionnumber = (select max(tem.patientrevisionnumber) from pf_patientnumber tem where tem.patientid = p.patientid)
and pn.sequencesetid = (select max(tem2.sequencesetid) from pf_patientnumber tem2 where tem2.patientid = pn.patientid)
and Check_Data('WFRULETRIG',pn.patientid) is null
and Check_Data1('WFRULETRIG',pn.patientid) = 0
and Get_Status('WFRULETRIG',pn.patientid) = 0;

select CHR(10)||'</CLINICALDATA>' from dual;

drop function Get_FormRefname;
drop function Get_VisitRefname; 
drop function Get_Path;
drop function Check_Data; 
drop function Check_Data1; 
exit;