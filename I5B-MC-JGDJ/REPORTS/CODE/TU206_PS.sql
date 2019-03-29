select

A.MERGE_DATETIME,
B.SITEMNEMONIC,
A.SUBJID,
A.TUMIDENT_TARGET,
A.TuLNKID_TARGET,
A.TUDAT,
A.TULOC_TU2F1,
A.TULOCOTH_TU2F1,
A.FLAG

FROM

(select a.*,b.Flag  from(select 

MERGE_DATETIME,
SUBJID,
TUMIDENT_TARGET,
TULNKID_TARGET,
TO_DATE (LPAD (REPLACE (TUDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDAT_TU2F1, '-99', '01'), 2, '0')
|| TUDATYY_TU2F1,'MMDDYYYY') AS TUDAT,
TULOC_TU2F1,
TULOCOTH_TU2F1 from I5B_MC_JGDJ.TU2001A_All) a
 
left join
 
(select x.*,'X' as Flag  from (select SUBJID, TULOC_TU2F1 from I5B_MC_JGDJ.TU2001A_All
where TULOC_TU2F1 is not null
group by SUBJID, TULOC_TU2F1
having count(*) > 2) x) b
on a.SUBJID = b.SUBJID and a.TULOC_TU2F1 = b.TULOC_TU2F1
order by a.SUBJID ) A

left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID