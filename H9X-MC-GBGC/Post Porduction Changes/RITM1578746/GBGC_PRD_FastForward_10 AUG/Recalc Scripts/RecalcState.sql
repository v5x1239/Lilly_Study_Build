/*
**desc: recalculate the state for inform
** login as trialuid and trialpid
*/
spool recalcstate.log

Update PF_SubjectVEChapterPage set NeedsRecalcState = 1 
where 
NeedsRecalcState IS NULL and startedstate > 0 and
pageid in 
	(select distinct pageid from pf_page where pagerefname in ('CM1001_C3LF2','CM1001_LF2'))
and subjectchapterid in
	(select subjectchapterid from PF_SubjectVEChapter 
  	 where subjectkeyid in 
  	 	(select patientid from pf_patient where state > 3));

COMMIT;
spool off;
exit;
