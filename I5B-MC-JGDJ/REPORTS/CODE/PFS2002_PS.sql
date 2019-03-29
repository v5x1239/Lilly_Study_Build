select distinct

a.MERGE_DATETIME,
b.SITEMNEMONIC,
a.SUBJID,
a.PFS2ASMT,
a.PFS2DAT,
a.DSPROGTYP

from

(select distinct

a.*,
b.PFS2ASMT,
b.PFS2DAT

from

(select distinct

SUBJID,
MERGE_DATETIME,
DSPROGTYP 

from I5B_MC_JGDJ.DS1001_All
where page in ('DS1001_F2')) a

left join

(select distinct

SUBJID,
PFS2ASMT,
TO_DATE (LPAD (REPLACE (PFS2DATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (PFS2DATDD, '-99', '01'), 2, '0')
|| PFS2DATYY,'MMDDYYYY') AS PFS2DAT

from I5B_MC_JGDJ.PFS21001_All
where page in ('PFS21001_DS1001_F1')) b

on a.SUBJID = b.SUBJID 
where b.PFS2ASMT = 'Y' and b.PFS2DAT is null and a.DSPROGTYP is null) a


left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID