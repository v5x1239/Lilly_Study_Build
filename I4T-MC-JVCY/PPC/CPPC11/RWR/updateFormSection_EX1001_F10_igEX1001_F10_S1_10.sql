rem		
rem 	Usage : sqlplus <trialuser>/<password>@<database> @updateFormSection_section_refname_1.sql
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET COLSEP "|"
SET ARRAYSIZE 5
SET LINESIZE 500
SET PAGESIZE 0


-- Update the Spool file name with a name to indicate the changed form

SPOOL updateFormSection_EX1001_F10_igEX1001_F10_S1_10.xml

select '<?xml version="1.0"?><MEDMLDATA xmlns="PhaseForward-MedML-Inform4">' from dual;

-- Update the  p.pagerefname, s.sectionrefname with the appropriate form and section refnames
-- For Central Designer trials, sectionrefname and pagerefname are identical unless section is explicitly defined
-- Update the  h.editiondescription with the studyversion description to be updated
-- If there are multiple existing studyversions, separate SQL and XML files should be generated for each editiondescription

select 
	'<UPDATE_FORM_SECTION'||chr(13)||						
	' FORM_REFNAME="'||p.pagerefname||'"'||chr(13)||
	' FORM_REVISION="'||p.pagerevisionnumber||'"'||chr(13)|| 
	' SECTION_REFNAME="'||s.sectionrefname||'"'||chr(13)||
	' SECTION_REVISION="'||s.sectionrevisionnumber||'"/>'||chr(13)
from pf_page p, pf_section s
where p.pagerefname='EX1001_F10'
  and s.sectionrefname='igEX1001_F10_S1'
  and s.sectionrevisionnumber= (select max(s2.sectionrevisionnumber) from pf_section s2 where s.sectionid=s2.sectionid)
  and p.pagerevisionnumber = (select distinct p2.pagerevisionnumber from 	pf_page p2,
										pf_vechapterpage e,
       										pf_page f,
       										pf_VeChapter g,
       										pf_volumeedition h    where p.pageid=p2.pageid
				  and p2.pageid=e.pageid
   				  and p2.pagerevisionnumber = e.pagerevisionnumber
   				  and e.chapterid=g.chapterid
   				  and e.chapterrevisionnumber=g.chapterrevisionnumber
   				  and g.volumeeditionid=h.volumeeditionid
				  and h.editiondescription = 'I4T_MC_JVCY 4.0.41')
/
      
select '</MEDMLDATA>' from dual;    
      
SPOOL OFF

SET ECHO ON
SET FEEDBACK ON
SET HEADING ON
SET ARRAYSIZE 15

exit