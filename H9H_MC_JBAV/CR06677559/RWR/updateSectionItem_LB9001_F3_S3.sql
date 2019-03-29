rem		
rem 	Usage : sqlplus <trialuser>/<password>@<database> @updateSectionItem_LB9001_F3_S3.sql
Set echo off;
set pagesize 0;
set linesize 500;
set head off;
set feed off;
set termout off;
set verify off;
set trimspool on;
set recsep off;
set wrap off;
set spa 0;


-- Update the Spool file name with a name to indicate the changed item

spool updateSectionItem_LB9001_F3_S3.xml
					

-- Update the  i.itemrefname, s.sectionrefname with the appropriate item and section refnames
-- For Central Designer trials, sectionrefname is identical to formrefame unless section is explicitly defined
-- Update the  h.editiondescription with the studyversion description to be updated
-- If there are multiple existing studyversions, separate SQL and XML files should be generated for each editiondescription


select '<?xml version="1.0"?><MEDMLDATA xmlns="PhaseForward-MedML-Inform4">' from dual
/

select 
'<UPDATE_SECTION_ITEM'||chr(13)||						
' SECTION_REFNAME="'||s.sectionrefname||'"'||chr(13)||
' SECTION_REVISION="'||s.sectionrevisionnumber||'"'||chr(13)|| 
' ITEM_REFNAME="'||i.itemrefname||'"'||chr(13)||
' ITEM_REVISION="'||i.itemrevisionnumber||'"/>'||chr(13)
from pf_item i,
     pf_section s
where i.itemrefname='LBTEST_BE2_GLS_LB9001_F3'
and i.itemrevisionnumber = (select max(i2.itemrevisionnumber) from pf_item i2 where i.itemid=i2.itemid)
and s.sectionrefname='igLB9001_F3_S3'
and s.sectionrevisionnumber = (select distinct s2.sectionrevisionnumber from 	pf_section s2,
										pf_pagesection d, 
 										pf_vechapterpage e,
       										pf_page f,
       										pf_VeChapter g,
       										pf_volumeedition h
				where s.sectionid=s2.sectionid
                                  and s.sectionrevisionnumber=s2.sectionrevisionnumber
                                  and s.sectionid=d.sectionid
                                  and s.sectionrevisionnumber=d.sectionrevisionnumber
				  and d.pageid=e.pageid
   				  and d.pagerevisionnumber = e.pagerevisionnumber
  				  and d.pageid=f.pageid
   				  and d.pagerevisionnumber = f.pagerevisionnumber
   				  and e.chapterid=g.chapterid
   				  and e.chapterrevisionnumber=g.chapterrevisionnumber
   				  and g.volumeeditionid=h.volumeeditionid
				  and h.editiondescription = 'H9H_MC_JBAV 1.1.34')
/

select '</MEDMLDATA>' from dual
/
spool off

exit
