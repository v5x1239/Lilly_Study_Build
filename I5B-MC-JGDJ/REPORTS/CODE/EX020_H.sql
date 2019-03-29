SELECT MERGE_DATETIME,SITEMNEMONIC,X.SUBJID,BlockID,Page,EXSTDAT,VSDAT
FROM 
(SELECT DISTINCT A.*,VSDAT
FROM
(SELECT MERGE_DATETIME,SUBJID,BlockID, NVL(BLOCKRPT,0) as BLOCKRPT,  Page,
to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT
from I5B_MC_JGDJ.EX1001b_ALL
where page in ('EX1001_F2','EX1001_F1')) A
INNER JOIN
(SELECT SUBJID,BLOCKID,NVL(BLOCKRPT,0) as BLOCKRPT,
to_date(lpad(replace(VSDATMO,'-99', '6'),2,'0')||lpad(replace(vsDATDD,'-99', '15'),2,'0')|| VSDATYY,'MMDDYYYY')    AS VSDAT
from I5B_MC_JGDJ.VS1001_ALL) B
ON A.SUBJID=B.SUBJID AND A.BlockID=B.BlockID AND A.BLOCKRPT=B.BLOCKRPT
WHERE EXSTDAT!=VSDAT) X left join 
(select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on X.SUBJID=b.SUBJID