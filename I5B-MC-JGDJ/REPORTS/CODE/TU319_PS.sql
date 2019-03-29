select distinct

A.MERGE_DATETIME,
B.SITEMNEMONIC,
A.SUBJID,
A.BLOCKID,
A.VISDAT,
A.TUMIDENT_NONTARGET,
A.TULNKID_NONTARGET,
A.TUDAT,
A.TRSPID,
A.TRDAT,
case
    when A.datdif NOT BETWEEN 0 AND 28 THEN 'X'
    ELSE ''
END AS fLAG

from

(select x.*, y.VISDAT, BLOCKID, (y.VISDAT  - x.TRDAT ) as datdif from (select a.*,b.TRSPID,b.TRLNKID, b.TRDAT  from 

(select distinct

MERGE_DATETIME,
SUBJID, 
TUMIDENT_NONTARGET,
TULNKID_NONTARGET, 
TO_DATE (LPAD (REPLACE (TUDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDATDD, '-99', '01'), 2, '0')
|| TUDATYY,'MMDDYYYY') AS TUDAT

from I5B_MC_JGDJ.TU3001A_All) a

left join

(select distinct

SUBJID, 
TRSPID,
TRLNKID, 
TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0')
|| TRDATYY,'MMDDYYYY') AS TRDAT

from I5B_MC_JGDJ.TU3001B_All
where TRSPID = '1') b

on a.SUBJID = b.SUBJID and a.TULNKID_NONTARGET = b.TRLNKID) x

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