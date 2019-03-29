select distinct

a.MERGE_DATETIME,
b.SITEMNEMONIC, 
a.SUBJID, 
a.TULNKID_NONTARGET, 
a.TRLNKID, 
a.TRSPID,
a.TRPERF,
a.TRMETHOD,
a.TRMETHODOTH

from

((select distinct x.* from

(select a.SUBJID, a.MERGE_DATETIME, a.TULNKID_NONTARGET, b.TRLNKID, b.TRSPID, b.TRPERF, b.TRMETHOD, b.TRMETHODOTH

from

(select SUBJID, MERGE_DATETIME, TULNKID_NONTARGET from I5B_MC_JGDJ.TU3001A_All
where page in ('TU3001_F1')) a

left join

(select SUBJID, TRLNKID, TRSPID, TRPERF, TRMETHOD, TRMETHODOTH from I5B_MC_JGDJ.TU3001B_All
where page in ('TU3001_F1')) b

on a.SUBJID = b.SUBJID and a.TULNKID_NONTARGET = b.TRLNKID) x,

(select a.SUBJID, a.MERGE_DATETIME, a.TULNKID_NONTARGET, b.TRLNKID, b.TRSPID, b.TRPERF, b.TRMETHOD, b.TRMETHODOTH

from

(select SUBJID, MERGE_DATETIME, TULNKID_NONTARGET from I5B_MC_JGDJ.TU3001A_All
where page in ('TU3001_F1')) a

left join

(select SUBJID, TRLNKID, TRSPID, TRPERF, TRMETHOD, TRMETHODOTH from I5B_MC_JGDJ.TU3001B_All
where page in ('TU3001_F1')) b

on a.SUBJID = b.SUBJID and a.TULNKID_NONTARGET = b.TRLNKID) y

where x.SUBJID=y.SUBJID and x.TRSPID = y.TRSPID 
      and x.TULNKID_NONTARGET != y.TULNKID_NONTARGET and x.TRMETHOD != y.TRMETHOD)
      

Union All

(select distinct x.* from


(select a.SUBJID, a.MERGE_DATETIME, a.TULNKID_NONTARGET, b.TRLNKID, b.TRSPID, b.TRPERF, b.TRMETHOD, b.TRMETHODOTH

from

(select SUBJID, MERGE_DATETIME, TULNKID_NONTARGET from I5B_MC_JGDJ.TU3001A_All
where page in ('TU3001_F1')) a

left join

(select SUBJID, TRLNKID, TRSPID, TRPERF, TRMETHOD, TRMETHODOTH from I5B_MC_JGDJ.TU3001B_All
where page in ('TU3001_F1')) b

on a.SUBJID = b.SUBJID and a.TULNKID_NONTARGET = b.TRLNKID) x,

(select a.SUBJID, a.MERGE_DATETIME, a.TULNKID_NONTARGET, b.TRLNKID, b.TRSPID, b.TRPERF, b.TRMETHOD, b.TRMETHODOTH

from

(select SUBJID, MERGE_DATETIME, TULNKID_NONTARGET from I5B_MC_JGDJ.TU3001A_All
where page in ('TU3001_F1')) a

left join

(select SUBJID, TRLNKID, TRSPID, TRPERF, TRMETHOD, TRMETHODOTH from I5B_MC_JGDJ.TU3001B_All
where page in ('TU3001_F1')) b

on a.SUBJID = b.SUBJID and a.TULNKID_NONTARGET = b.TRLNKID) y

where x.SUBJID=y.SUBJID and x.TRSPID = y.TRSPID 
      and x.TULNKID_NONTARGET != y.TULNKID_NONTARGET and x.TRMETHODOTH != y.TRMETHODOTH)) a

left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID