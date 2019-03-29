/*
**desc: recalculate the state for inform
** login as trialuid and trialpid
*/
set echo OFF
spool recalcstate.log

UPDATE PF_SUBJECTVECHAPTERPAGE 
   SET NeedsRecalcState = 1
 WHERE NeedsRecalcState IS NULL
   AND startedstate = 1
   AND pageid IN (SELECT DISTINCT pageid 
                    FROM PF_PAGE 
                   WHERE pagerefname in ('DS2001_LF1','INFC2001_PR1001_F1','DS1001_LF7','CM4001_C1LF1','VS1001_C2LF1','EC1001_F1','VS1001_LF1','VS1001_LF2')
                  )
   AND subjectchapterid IN (SELECT subjectchapterid 
                              FROM PF_SUBJECTVECHAPTER 
                             WHERE subjectkeyid IN (SELECT patientid 
                                                      FROM PF_PATIENT 
                                                    WHERE state > 3
                                                   )
                            )
  AND DELETEDDYNAMICFORMSTATE <> 1
  AND bitand(STATE,8192) <> 8192;

COMMIT;
spool off;

