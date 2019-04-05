rem		
rem 	Usage : sqlplus <trialuser>/<password>@<database> @updateFormSection_formrefname.sql
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET COLSEP "|"
SET ARRAYSIZE 5
SET LINESIZE 500
SET PAGESIZE 0


-- Update the Spool file name with a name to indicate the changed form

SPOOL updateFormSection__RITM1578746.xml

select '<?xml version="1.0"?>'||CHR(13)||CHR(13)||
       '<METADATA xmlns="PhaseForward-MedML-Inform4">'||CHR(13)||CHR(13)
       from dual;

-- Update the  p.pagerefname, s.sectionrefname with the appropriate form and section refnames
-- For Central Designer trials, sectionrefname and pagerefname are identical unless section is explicitly defined
-- If there are multiple existing studyversions, separate update tags will be generated automatically for all


--Copy and Paste the below Select statement for multiple RWRs. One select statement for each section



select 
	'<UPDATE_FORM_SECTION'||chr(13)||						
	' FORM_REFNAME="'||p.pagerefname||'"'||chr(13)||
	' FORM_REVISION="'||p.pagerevisionnumber||'"'||chr(13)|| 
	' SECTION_REFNAME="'||s.sectionrefname||'"'||chr(13)||
	' SECTION_REVISION="'||s.sectionrevisionnumber||'"/>'||chr(13)
from pf_page p, pf_section s
where p.pagerefname='CM1001_C3LF2'
  and s.sectionrefname='igCM1001_C3F2_S2'
  and s.sectionrevisionnumber= (select max(s2.sectionrevisionnumber) from pf_section s2 where s.sectionid=s2.sectionid)
  and p.pagerevisionnumber IN (select distinct ps.pagerevisionnumber from 	pf_pagesection ps,
       										pf_section s2
       										where s2.sectionrefname = s.sectionrefname
                                                and ps.sectionrevisionnumber = s2.sectionrevisionnumber);
                                                

select 
	'<UPDATE_FORM_SECTION'||chr(13)||						
	' FORM_REFNAME="'||p.pagerefname||'"'||chr(13)||
	' FORM_REVISION="'||p.pagerevisionnumber||'"'||chr(13)|| 
	' SECTION_REFNAME="'||s.sectionrefname||'"'||chr(13)||
	' SECTION_REVISION="'||s.sectionrevisionnumber||'"/>'||chr(13)
from pf_page p, pf_section s
where p.pagerefname='CM1001_LF2'
  and s.sectionrefname='igCM1001_F2_S2'
  and s.sectionrevisionnumber= (select max(s2.sectionrevisionnumber) from pf_section s2 where s.sectionid=s2.sectionid)
  and p.pagerevisionnumber IN (select distinct ps.pagerevisionnumber from 	pf_pagesection ps,
       										pf_section s2
       										where s2.sectionrefname = s.sectionrefname
                                                and ps.sectionrevisionnumber = s2.sectionrevisionnumber);


                                                
select CHR(13)||CHR(13)||'</METADATA>'||CHR(13) from dual;  




      
SPOOL OFF

SET ECHO ON
SET FEEDBACK ON
SET HEADING ON
SET ARRAYSIZE 15

exit