select z.MERGE_DATETIME,SITEMNEMONIC,z.SUBJID,BlockID,Page,EXPTRTDAT,EXSTDAT
from
(select x.*,EXPTRTDAT
from 
(SELECT MERGE_DATETIME,SUBJID,BlockID,Page,
to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT,
exspid
from I5B_MC_JGDJ.EX1001b_ALL
where blockid=1 and page in ('EX1001_F2','EX1001_F1')) x
inner join 
(select a.*
from
(select SUBJID,blockid,
to_date(lpad(replace(EXPTRTDATMO,'-99', '01'),2,'0')||lpad(replace(EXPTRTDATDD,'-99', '01'),2,'0')|| EXPTRTDATYY,'MMDDYYYY') as EXPTRTDAT
from I5B_MC_JGDJ.EX1001a_ALL
where page in ('EX1001_F2','EX1001_F1')) a
where a.blockid='1' and a.EXPTRTDAT is not null) y
on x.SUBJID=y.SUBJID
where EXPTRTDAT < EXSTDAT) z left join 
(select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on z.SUBJID=b.SUBJID