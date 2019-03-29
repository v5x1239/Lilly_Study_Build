select MERGE_DATETIME,SITEMNEMONIC,x.SUBJID,BlockID,Page,EXSTDAT,DSSTDAT
from
(SELECT distinct A.* ,DSSTDAT
FROM
(SELECT MERGE_DATETIME,SUBJID,BlockID, NVL(BLOCKRPT,0) as BLOCKRPT,  Page,
to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT
from I5B_MC_JGDJ.EX1001b_ALL) A
INNER JOIN 
(SELECT SUBJID,BlockID, NVL(BLOCKRPT,0) as BLOCKRPT,
to_date(lpad(replace(DSSTDATMO,'-99', '07'),2,'0') ||lpad(replace(DSSTDATDD,'-99', '15'),2,'0') || DSSTDATYY,'MMDDYYYY')    AS DSSTDAT
from I5B_MC_JGDJ.DS1001_ALL) B
ON A.SUBJID=B.SUBJID and A.BlockID=B.BlockID and a.BLOCKRPT = b.BLOCKRPT and EXSTDAT < DSSTDAT) x left join 
(select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on x.SUBJID=b.SUBJID