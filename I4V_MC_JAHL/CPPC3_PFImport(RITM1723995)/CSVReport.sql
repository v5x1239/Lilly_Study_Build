/* Name 		: 	CSVReport.sql			                                */
/* Date 		: 	02-Aug-2018			                                */
/* Author 		:	Pandiarajan Pandidurai 			                */
/* Description  	:       This script will return the subject details in which the specified form is locked or frozen and also the form level comment entered  			        */
/*  Usage               :       Sqlplus <trialuid>/<trialpid>@<oracle_instance> @CSVReport.sql     */

SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMSPOOL ON
SET LINESIZE 32767
SET COLSEP ,

SPOOL CSVReport.csv

SELECT 'Site#','Patient#','Visit RefName','Form RefName','Form State' FROM DUAL;

select * from(
select distinct 
s.sitename "Site#",
pt.PATIENTNUMBERSTR "Patient#",
c.chapterrefname as "Visit RefName",
p.pagerefname as "Form RefName",
decode(sv.frozenstate,1,decode(sv.lockedstate,1,'Locked/Frozen',0,'Frozen',''),0,decode(sv.lockedstate,1,'Locked','')) "Form State"
from PF_SUBJECTVECHAPTERPAGE sv,
PF_SUBJECTVECHAPTER sq,
PF_PATIENTNUMBER pt,
PF_SITE s,
pf_patient pn,
pf_chapter c,
pf_page p
where sv.pageid in (select pageid from pf_page where pagerefname = 'CIV1001_LF1')
and (sv.frozenstate = 1 or sv.lockedstate = 1)
and pt.patientid = sq.SUBJECTKEYID
and pn.patientid = sq.SUBJECTKEYID
and pn.siteid = s.siteid
AND pt.PATIENTREVISIONNUMBER = (SELECT MAX(PATIENTREVISIONNUMBER) FROM PF_PATIENTNUMBER pt2 WHERE pt2.PATIENTID=pt.PATIENTID)
and sv.subjectchapterid = sq.subjectchapterid
and c.chapterid = sq.chapterid
and p.pageid = sv.pageid
and pt.PATIENTNUMBERSTR not like 'SCR%'
union
select distinct 
s.sitename "Site#",
pt.PATIENTNUMBERSTR "Patient#",
c.chapterrefname as "Visit RefName",
p.pagerefname as "Form RefName",
case sv1.HASCOMMENTSSTATE 
when 1 then 'Form Level Comment Entered'
end "Form State"
from 
PF_SUBJECTVECHAPTER sq,
PF_PATIENTNUMBER pt,
PF_SUBJECTVECHAPTERPAGE sv1,
PF_SITE s,
pf_patient pn,
pf_chapter c,
pf_page p
where sv1.pageid in (select pageid from pf_page where pagerefname = 'CIV1001_LF1')
and sv1.HASCOMMENTSSTATE =1
and sv1.notdonestate = 1
and pt.patientid = sq.SUBJECTKEYID
and pn.patientid = sq.SUBJECTKEYID
and pn.siteid = s.siteid
AND pt.PATIENTREVISIONNUMBER = (SELECT MAX(PATIENTREVISIONNUMBER) FROM PF_PATIENTNUMBER pt2 WHERE pt2.PATIENTID=pt.PATIENTID)
and sv1.SUBJECTCHAPTERID = sq.subjectchapterid
and c.chapterid = sq.chapterid
and p.pageid = sv1.pageid
and pt.PATIENTNUMBERSTR not like 'SCR%'
union
select distinct s.sitename "Site#", 
pt.patientnumberstr "Patient#", 
c.chapterrefname as "Visit RefName", 
p.pagerefname as "Form RefName", 
'Item Level Comment Entered'
from pf_comment co, pf_itemcontext ic, pf_patientnumber pt, pf_chapter c, pf_page p, pf_patient ps, pf_site s, pf_controldata cd
where co.contextid = ic.contextid
and ic.subjectkeyid = pt.patientid
and ic.chapterid = c.chapterid
and ic.pageid = p.pageid
and pt.PATIENTNUMBERSTR not like 'SCR%'
AND pt.PATIENTREVISIONNUMBER = (SELECT MAX(PATIENTREVISIONNUMBER) FROM PF_PATIENTNUMBER pt2 WHERE pt2.PATIENTID=pt.PATIENTID)
and co.commenttype = 1
and pt.patientid = ps.patientid
and ps.siteid = s.siteid
and cd.contextid = ic.contextid
and cd.strvalue in (select strvalue from pf_element where strvalue like '%Element')
and ic.pageid in (select pageid from pf_page where pagerefname = 'CIV1001_LF1')
and cd.auditorder = (select max(auditorder) from pf_controldata itc where itc.contextid = cd.contextid)
and ic.itemid in (select distinct itemid from pf_item where itemrefname in ('WFRULETRIG_CIV1001_LF1'))
);

SPOOL OFF
EXIT;
