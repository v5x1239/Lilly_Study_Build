
DROP table INF9423_SubjectVEChapter;

CREATE table INF9423_SubjectVEChapter as
  select subjectchapterid, chapterid, projectedstarthours from 
    pf_subjectvechapter
  WHERE chapterid IN
  (SELECT DISTINCT c.chapterid
     FROM pf_chapter c,
    pf_vechapter vc3
    WHERE c.chapterid = vc3.chapterid
  AND c.chapterrevisionnumber = vc3.chapterrevisionnumber
  AND BITAND(vc3.chapterproperties,8) = 8
  AND c.chaptertype = 1);


UPDATE pf_subjectvechapter
SET projectedstarthours =
  (SELECT starthours
     FROM pf_vechapter vc
    WHERE pf_subjectvechapter.chapterid = vc.chapterid
  AND vc.chapterrevisionnumber =
    (SELECT MAX(chapterrevisionnumber)
       FROM pf_vechapter vc2
      WHERE vc2.chapterid = vc.chapterid
    )
  )
WHERE chapterid IN
  (SELECT 
  DISTINCT c.chapterid 
	FROM pf_chapter c,
	pf_vechapter vc3 
	WHERE c.chapterid = vc3.chapterid 
	AND c.chapterrevisionnumber = vc3.chapterrevisionnumber 
	AND BITAND(vc3.chapterproperties,8) = 8 
	AND c.chaptertype = 1 );
	
	
COMMIT;