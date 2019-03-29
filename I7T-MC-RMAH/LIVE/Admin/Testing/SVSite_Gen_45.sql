/*
|| File: SVSite_Gen_45.sql
||
|| Description: Generates the SVSite XML which will associate all the 
||				Previous StudyVersion sites with the latest StudyVersion
||              This will be applicable for trials in InForm 4.5
||
||  author:	   Date:	  Comments:
|| ----------     -----------     --------------------------------------
|| Ravindran	  01/04/05	  Initial Development
|| Sethu & DSArun 01/04/06        Modified   
|| 
||
||Usage:
|| plus33 uid/pid @SVSite_Gen.sql <StudyVersion>
|| sqlplus uid/pid @SVSite_Gen.sql <StudyVersion>
*/

set echo off;
set feedback off;
set heading  off;
set linesize 300;
set pagesize 0;
set termout off;
set verify off;
set trimspool on;
spool off

spool SVSite.xml

select 
'<?xml version="1.0"?>'||chr(13)||
'<MEDMLDATA xmlns="PhaseForward-MedML-Inform4">'||chr(13)||chr(13)
From dual;

SELECT
'<STUDYVERSIONSITE'||CHR(13)||
CHR(9)||'SITEMNEMONIC="' || st.sitemnemonic||'"'||CHR(13)||
CHR(9)||'VERSIONDESCRIPTION="'|| ve.editiondescription || '"'||CHR(13)||
CHR(9)||'ACCEPTDATE="'|| TO_CHAR(SYSDATE,'MM/DD/YYYY') ||'"'||CHR(13)||
CHR(9)||'REASON='||'"'||'Study Version Site Update'||'"/>'||CHR(13)
FROM 
PF_SITE st,
PF_VOLUMEEDITION Ve
WHERE st.SITEREVISIONNUMBER = (SELECT MAX(ST1.SITEREVISIONNUMBER) FROM PF_SITE ST1 WHERE ST1.SITEID = ST.SITEID)
AND VOLUMEEDITIONID = (SELECT MAX(volumeeditionid) FROM PF_VOLUMEEDITION WHERE VOLUMEID=(SELECT MAX(v1.VOLUMEID) FROM PF_VOLUME v1))
AND Ve.VOLUMEID=(SELECT MAX(v2.VOLUMEID) FROM PF_VOLUME v2);

select
'</MEDMLDATA>'
from dual;

spool off

exit;