select distinct

a.MERGE_DATETIME,
b.SITEMNEMONIC,
a.SUBJID,
a.TULNKID_NONTARGET,
a.TRLNKID, 
a.TRSPID,
a.TRPERF,
a.TUMSTATE_NONTARGET

from

(select 

a.*,
b.TRSPID,
b.TRPERF,
b.TRLNKID,
b.TUMSTATE_NONTARGET

from   (select distinct 

SUBJID,
merge_datetime,  
TULNKID_NONTARGET

from I5B_MC_JGDJ.TU3001A_All
where page in ('TU3001_F1')) a

left join

(select distinct

SUBJID,
TRLNKID,
TRSPID,
TRPERF,  
TUMSTATE_NONTARGET

from I5B_MC_JGDJ.TU3001B_All
where page in ('TU3001_F1')) b

on a.SUBJID = b.SUBJID and a.TULNKID_NONTARGET = b.TRLNKID
where b.TRSPID = '1' and b.TUMSTATE_NONTARGET != 'PRESENT BUT NO UNEQUIVOCAL PROGRESSION') a


left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID