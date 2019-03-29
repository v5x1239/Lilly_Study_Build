/*
   Update Script for script for INF-6160 & INF-9423. 
   SQL/PLUS log in as the trial schema user, then run
   @INF-9423.sql
   Description: It updates ProjectedStartHours to pf_subjectvechapter table from metadata table (pf_vechapter)
*/

UPDATE pf_subjectvechapter
SET projectedstarthours =
  (SELECT starthours
     FROM pf_vechapter vc
    WHERE pf_subjectvechapter.chapterid = vc.chapterid
  AND vc.chapterrevisionnumber =
    (SELECT MAX(chapterrevisionnumber)
       FROM pf_vechapter vc2
      WHERE vc2.chapterid = vc.chapterid
      and vc2.volumeeditionId = (select max(stv.volumeeditionId) from PF_SiteVolumeedition stv 
      inner join pf_patient pt on stv.siteid = pt.siteid where pt.patientid = pf_subjectvechapter.subjectkeyid)
    )
  )
WHERE 
chapterid IN
  (SELECT 
  DISTINCT c.chapterid 
	FROM pf_chapter c,
	pf_vechapter vc3 
	WHERE c.chapterid = vc3.chapterid 
	AND c.chapterrevisionnumber = vc3.chapterrevisionnumber 
	AND BITAND(vc3.chapterproperties,8) = 8 
	AND c.chaptertype = 1);
	
	
COMMIT;
