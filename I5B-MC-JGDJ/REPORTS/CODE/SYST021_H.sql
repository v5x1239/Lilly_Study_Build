select MERGE_DATETIME,z.SUBJID,SITEMNEMONIC,SYSTGRPID,CMSPID,SYSTTRT,SYSTSTDAT,z.BlockID,DSSTDAT
from
(select x.*
from
(select a.*,DSSTDAT
from
(select MERGE_DATETIME,SUBJID,SYSTGRPID,CMSPID,SYSTTRT,
TO_DATE (LPAD (REPLACE (SYSTSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (SYSTSTDATDD, '-99', '01'), 2, '0')||SYSTSTDATYY,'MMDDYYYY') AS SYSTSTDAT,
blockid
from I5B_MC_JGDJ.SYST3001b_ALL z
 where  page='SYST3001_LF2' and blockid is not null) a
 left join 
 (select SUBJID,
    TO_DATE (LPAD (REPLACE (DSSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (DSSTDATDD, '-99', '01'), 2, '0')||DSSTDATYY,'MMDDYYYY') AS DSSTDAT,
    blockid 
 from I5B_MC_JGDJ.DS1001_ALL
 where page in ('DS1001_F2','SS1001_DS1001_LF1') and blockid is not null) b
 on a.SUBJID=b.SUBJID ) x 
 where SYSTSTDAT >= DSSTDAT) Z left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on z.SUBJID=b.SUBJID