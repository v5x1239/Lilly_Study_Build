select a.merge_datetime, SITEMNEMONIC,a.SUBJID,
case when b.visit is not null then b.visit
else c.visit end as visit1, EXENDAT_EX1001_F1,EXENTIM_EX1001_F1,exendttm,CMSPID,CMTRT,CMSTDAT, CMSTTIM,cmstdttm,CMENDAT,CMENTIM,cmendttm,CMONGO,EXSTDAT_EX1001_F2,EXTIME_EX1001_F2,exstdttm
from (select z.*,TO_DATE (LPAD (REPLACE (CMSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (CMSTDATDD, '-99', '01'), 2, '0')||CMSTDATYY,'MMDDYYYY') AS CMSTDAT,
to_date(lpad(replace(CMENDATMO,'-99', '12'),2,'0')||lpad(replace(CMENDATDD,'-99', '30'),2,'0')|| CMENDATYY,'MMDDYYYY') as CMENDAT,
DECODE (CMSTTIMHR,NULL, NULL,DECODE (CMSTTIMMI,NULL, NULL,LPAD (REPLACE (CMSTTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (CMSTTIMMI, '-99', '00'), 2, '0'))) 
as CMSTTIM,DECODE (CMENTIMHR,NULL, NULL,DECODE (CMENTIMMI,NULL, NULL,LPAD (REPLACE (CMENTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (CMENTIMMI, '-99', '00'), 2, '0'))) 
as CMENTIM,
TO_DATE (LPAD (REPLACE (CMSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (CMSTDATDD, '-99', '01'), 2, '0')||CMSTDATYY||
DECODE (CMSTTIMHR,NULL, NULL,DECODE (CMSTTIMMI,NULL, NULL,LPAD (REPLACE (CMSTTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (CMSTTIMMI, '-99', '00'), 2, '0'))),
'MMDDYYYY HH24:MI') as cmstdttm,
to_date(lpad(replace(CMENDATMO,'-99', '12'),2,'0')||lpad(replace(CMENDATDD,'-99', '30'),2,'0')|| CMENDATYY||
DECODE (CMENTIMHR,NULL, NULL,DECODE (CMENTIMMI,NULL, NULL,LPAD (REPLACE (CMENTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (CMENTIMMI, '-99', '00'), 2, '0'))),
'MMDDYYYY HH24:MI') as cmendttm
  from I5B_MC_JGDJ.CM1001B_ALL z where page='CM1001_LF2' ) a left join (select a.subjid, case when VISITNUM is not null then 'C'||VISITNUM else 'C'||a.blockid
  end as visit,TO_DATE (LPAD (REPLACE (EXENDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (EXENDATDD, '-99', '01'), 2, '0')|| EXENDATYY,'MMDDYYYY') AS EXENDAT_EX1001_F1,
   DECODE (EXENTIMHR,NULL, NULL,DECODE (EXENTIMMI,NULL, NULL,LPAD (REPLACE (EXENTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (EXENTIMMI, '-99', '00'), 2, '0')))
AS EXENTIM_EX1001_F1, TO_DATE (LPAD (REPLACE (EXENDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (EXENDATDD, '-99', '01'), 2, '0')|| EXENDATYY||
DECODE (EXENTIMHR,NULL, NULL,DECODE (EXENTIMMI,NULL, NULL,LPAD (REPLACE (EXENTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (EXENTIMMI, '-99', '00'), 2, '0'))),
'MMDDYYYY HH24:MI') as exendttm
from
(select * from I5B_MC_JGDJ.EX1001B_All where page='EX1001_LF1') a left join I5B_MC_JGDJ.SV1001_All b
on a.subjid=b.subjid and a.blockid=b.blockid and nvl(a.blockrpt,0)=nvl(b.blockrpt,0)) b on a.subjid=b.subjid and a.CMSTDAT=b.EXENDAT_EX1001_F1 left join
(select a.subjid, case when VISITNUM is not null then 'C'||VISITNUM else 'C'||a.blockid
  end as visit, TO_DATE (LPAD (REPLACE (EXSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (EXSTDATDD, '-99', '01'), 2, '0')|| EXSTDATYY,'MMDDYYYY')AS EXSTDAT_EX1001_F2 ,
DECODE (EXSTTIMHR,NULL, NULL,DECODE (EXSTTIMMI,NULL, NULL,LPAD (REPLACE (EXSTTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (EXSTTIMMI, '-99', '00'), 2, '0')))
AS EXTIME_EX1001_F2, TO_DATE (LPAD (REPLACE (EXSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (EXSTDATDD, '-99', '01'), 2, '0')|| EXSTDATYY||
DECODE (EXSTTIMHR,NULL, NULL,DECODE (EXSTTIMMI,NULL, NULL,LPAD (REPLACE (EXSTTIMHR, '-99', '00'), 2, '0')|| ':'|| LPAD (REPLACE (EXSTTIMMI, '-99', '00'), 2, '0'))),
'MMDDYYYY HH24:MI') as exstdttm from
(select * from I5B_MC_JGDJ.EX1001B_All where page='EX1001_F2') a left join I5B_MC_JGDJ.SV1001_All b
on a.subjid=b.subjid and a.blockid=b.blockid and nvl(a.blockrpt,0)=nvl(b.blockrpt,0)) c on a.subjid=c.subjid and a.CMENDAT=c.EXSTDAT_EX1001_F2 left join 
(SELECT sb.subject_id, st.SITEMNEMONIC
                             FROM I5B_MC_JGDJ.inf_subject sb,
                                  I5B_MC_JGDJ.inf_site_update st
                            WHERE sb.SITEGUID = st.CT_RECID) o
                   ON a.SUBJECT_ID = o.subject_id
                   where CMSTTIM is not null and CMENTIM is not null and (EXENDTTM > CMSTDTTM or EXSTDTTM < CMENDTTM)
  