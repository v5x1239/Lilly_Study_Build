SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET COLSEP "|"
SET ARRAYSIZE 5
SET LINESIZE 500
SET PAGESIZE 0

SPOOL &1

select '<?xml version="1.0"?>'||CHR(13)||CHR(13)||
       '<METADATA xmlns="PhaseForward-MedML-Inform4">'||CHR(13)||CHR(13)
       from dual;

select unique
	'<UPDATE_FORM_SECTION'||chr(13)||						
	' FORM_REFNAME="'||p.pagerefname||'"'||chr(13)||
	' FORM_REVISION="'||p.pagerevisionnumber||'"'||chr(13)|| 
	' SECTION_REFNAME="'||s.sectionrefname||'"'||chr(13)||
	' SECTION_REVISION="'||s.sectionrevisionnumber||'"/>'||chr(13) DATA1
from pf_page p, pf_section s
where p.pagerefname=(select unique pagerefname from pf_page where pageid = (select dbuid from pf_entitymapping where lower(ENTITYID) = 'd882ce39-0f42-11d2-a419-00a0c963e0ac'))
  and s.sectionrefname=(select unique sectionrefname from PF_SECTION where sectionid =  (select dbuid from pf_entitymapping where lower(ENTITYID) = '96cae354-126c-11d2-a41c-00a0c963e0ac'))
  and s.sectionrevisionnumber= (select max(s2.sectionrevisionnumber) from pf_section s2 where s.sectionid=s2.sectionid)
  and p.pagerevisionnumber in (select distinct p2.pagerevisionnumber from 	pf_page p2,
										pf_vechapterpage e,
       										pf_page f,
       										pf_VeChapter g,
       										pf_volumeedition h    where p.pageid=p2.pageid
				  and p2.pageid=e.pageid
   				  and p2.pagerevisionnumber = e.pagerevisionnumber
   				  and e.chapterid=g.chapterid
   				  and e.chapterrevisionnumber=g.chapterrevisionnumber
   				  and g.volumeeditionid=h.volumeeditionid				  
				  )ORDER BY DATA1;

      
select CHR(13)||CHR(13)||'</METADATA>'||CHR(13) from dual;      
      
SPOOL OFF

SET ECHO ON
SET FEEDBACK ON
SET HEADING ON
SET ARRAYSIZE 15

exit
