select distinct

a.MERGE_DATETIME,
b.SITEMNEMONIC,
a.SUBJID,
a.TUMIDENT_NEW,
a.TULNKID_NEW,
a.TUDAT, 
a.TRSPID,
a.TRDAT,
a.FLAG

from

(select 

a.*,
b.TRSPID,
b.TRDAT,
case
    when TRSPID = '1' and TUDAT != TRDAT then 'X'
    else ''
end as Flag

from   (select distinct 

SUBJID,
merge_datetime, 
TUMIDENT_NEW, 
TULNKID_NEW, 
TO_DATE (LPAD (REPLACE (TUDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDATDD, '-99', '01'), 2, '0')
|| TUDATYY,'MMDDYYYY') AS TUDAT,
BLOCKID 

from I5B_MC_JGDJ.TU1001A_All) a

left join

(select distinct

SUBJID,
TRSPID, 
TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0')
|| TRDATYY,'MMDDYYYY') AS TRDAT, 
BLOCKID

from I5B_MC_JGDJ.TU1001B_All) b

on a.SUBJID = b.SUBJID) a


left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID

