select distinct

A.MERGE_DATETIME,
B.SITEMNEMONIC,
A.SUBJID,
A.BLOCKID,
A.VISDAT,
A.TUMIDENT_TARGET,
A.TRLNKID_TU2F1,
A.TUDAT,
A.TRSPID_TU2F1,
A.TRDAT,
case
    when A.datdif NOT BETWEEN 0 AND 28 THEN 'X'
    ELSE ''
END AS fLAG

from

(select x.*, y.VISDAT, BLOCKID, (y.VISDAT  - x.TRDAT ) as datdif from (select a.*,b.TRSPID_TU2F1,b.TRLNKID_TU2F1, b.TRDAT  from 

(select distinct

MERGE_DATETIME,
SUBJID, 
TUMIDENT_TARGET,
TULNKID_TARGET, 
TO_DATE (LPAD (REPLACE (TUDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDAT_TU2F1, '-99', '01'), 2, '0')
|| TUDATYY_TU2F1,'MMDDYYYY') AS TUDAT

from I5B_MC_JGDJ.TU2001A_All) a

left join

(select distinct

SUBJID, 
TRSPID_TU2F1,
TRLNKID_TU2F1, 
TO_DATE (LPAD (REPLACE (TRDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD_TU2F1, '-99', '01'), 2, '0')
|| TRDATYY_TU2F1,'MMDDYYYY') AS TRDAT

from I5B_MC_JGDJ.TU2001B_All
where TRSPID_TU2F1 = '1') b

on a.SUBJID = b.SUBJID and a.TULNKID_TARGET = b.TRLNKID_TU2F1) x

left join

(select distinct

SUBJID,
BLOCKID,
TO_DATE (LPAD (REPLACE (VISDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (VISDATDD, '-99', '01'), 2, '0')
|| VISDATYY,'MMDDYYYY') AS VISDAT
 from I5B_MC_JGDJ.SV1001_All
where page in ('SV1001_F1') and BLOCKID = '1') y

on x.SUBJID = y.SUBJID) a

left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID