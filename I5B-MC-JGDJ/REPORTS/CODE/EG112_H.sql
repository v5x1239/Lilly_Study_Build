select x.*,SITEMNEMONIC
from
(select a.*,MHSPID,MHTERM,MHDECOD,DICT_DICTVER,MHLLT,MHLLTCD
from
(select MERGE_DATETIME,SUBJID,BlockID,EGSPID,EGTPT,
to_date(lpad(replace(EGDATMO,'-99', '01'),2,'0')||lpad(replace(EGDATDD,'-99', '01'),2,'0')|| EGDATYY,'MMDDYYYY') as EGDAT,
 decode(EGTIMHR,null,null,decode(EGTIMMI,null,null,lpad(replace(EGTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EGTIMMI,'-99', '00'),2,'0'))) AS EGTIM,
EGMIEEVL,
MHNO 
from I5B_MC_JGDJ.EG3001b_ALL
where MHNO is not null AND PAGE  IN ('EG3001_LF1')) A left join 
(select SUBJID,MHSPID,MHTERM,MHDECOD,DICT_DICTVER,MHLLT,MHLLTCD from I5B_MC_JGDJ.MH8001_ALL
where MHSPID is not null
) b
on a.SUBJID=b.SUBJID and a.MHNO=b.MHSPID) x left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                      on x.SUBJID=b.SUBJID 