select merge_datetime,SITEMNEMONIC,
 a.SUBJID,BLOCKID,RSPERF, RSSPID,OVRLRESP,OVRLRESP_NRP,RSDAT,
 TRGRESP,NTRGRESP,flag
 from
(select x.*,
case when RSPERF ='Y' and RSSPID is null and OVRLR is null and RSDAT is null and TRGRESP  is  null and NTRGRESP is null  then 'flag'
else ''
end as flag
from
(select merge_datetime,
 SUBJID,BLOCKID,RSPERF, RSSPID,OVRLRESP,OVRLRESP_NRP,
 to_date(lpad(replace(RSDATmo,'-99', '01'),2,'0')||lpad(replace(RSDATDD,'-99', '01'),2,'0')|| RSDATyy,'MMDDYYYY') as RSDAT,
 TRGRESP,NTRGRESP,coalesce(OVRLRESP,OVRLRESP_NRP) as OVRLR
 from I5B_MC_JGDJ.rs1001_all) x) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
 from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
 where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID                     
