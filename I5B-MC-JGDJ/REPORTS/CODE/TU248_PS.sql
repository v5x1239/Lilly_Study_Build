select distinct

a.MERGE_DATETIME,
b.SITEMNEMONIC,
a.SUBJID,
a.TUMIDENT_TARGET,
a.TRLNKID_TU2F1,
a.TUDAT, 
a.TRSPID_TU2F1,
a.TRDAT,
a.FLAG

from

(select 

a.*,
b.TRSPID_TU2F1,
b.TRDAT,
b.TRLNKID_TU2F1,
case
    when TRSPID_TU2F1 = '1' and TUDAT != TRDAT then 'X'
    else ''
end as Flag

from   (select distinct 

SUBJID,
merge_datetime, 
TUMIDENT_TARGET, 
TULNKID_TARGET, 
TO_DATE (LPAD (REPLACE (TUDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDAT_TU2F1, '-99', '01'), 2, '0')
|| TUDATYY_TU2F1,'MMDDYYYY') AS TUDAT,
BLOCKID 

from I5B_MC_JGDJ.TU2001A_All) a

left join

(select distinct

SUBJID,
TRLNKID_TU2F1,
TRSPID_TU2F1, 
TO_DATE (LPAD (REPLACE (TRDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD_TU2F1, '-99', '01'), 2, '0')
|| TRDATYY_TU2F1,'MMDDYYYY') AS TRDAT, 
BLOCKID

from I5B_MC_JGDJ.TU2001B_All) b

on a.SUBJID = b.SUBJID and a.TULNKID_TARGET = b.TRLNKID_TU2F1) a


left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID