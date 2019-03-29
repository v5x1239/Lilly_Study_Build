select distinct

a.MERGE_DATETIME,
b.SITEMNEMONIC, 
a.SUBJID,
a.TULNKID_NEW, 
a.TUMETHOD,  
a.TUMETHODOTH

from

((select distinct a.*
from
(select distinct MERGE_DATETIME, SUBJID, TUMETHOD, TULNKID_NEW, TUMETHODOTH from I5B_MC_JGDJ.TU1001A_All where page in ('TU1001_F1')) a,

(select distinct MERGE_DATETIME, SUBJID, TUMETHOD, TULNKID_NEW, TUMETHODOTH from I5B_MC_JGDJ.TU1001A_All where page in ('TU1001_F1')) b
where a.SUBJID=b.SUBJID and a.TUMETHOD != b.TUMETHOD)

Union All

(select distinct a.*
from
(select distinct MERGE_DATETIME, SUBJID, TUMETHOD, TULNKID_NEW, TUMETHODOTH from I5B_MC_JGDJ.TU1001A_All where page in ('TU1001_F1')) a,

(select distinct MERGE_DATETIME, SUBJID, TUMETHOD, TULNKID_NEW, TUMETHODOTH from I5B_MC_JGDJ.TU1001A_All where page in ('TU1001_F1')) b
where a.SUBJID=b.SUBJID and a.TUMETHODOTH != b.TUMETHODOTH))  a

left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID
order by SITEMNEMONIC, SUBJID

