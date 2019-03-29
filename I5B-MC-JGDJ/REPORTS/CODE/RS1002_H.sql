select merge_datetime,SITEMNEMONIC,
 a.SUBJID,BLOCKID,RSPERF, RSSPID,OVRLRESP,OVRLRESP_NRP,RSDAT,
 TRGRESP,NTRGRESP,flag
 from
(select x.*,
case when RSPERF ='N' and RSSPID is not null and OVRLRESP is not null and OVRLRESP_NRP is not null and RSDAT is not null and TRGRESP  is  not null and NTRGRESP is not null  then 'flag'
else ''
end as flag
from
(select merge_datetime,
 SUBJID,BLOCKID,RSPERF, RSSPID,OVRLRESP,OVRLRESP_NRP,
 to_date(lpad(replace(RSDATmo,'-99', '01'),2,'0')||lpad(replace(RSDATDD,'-99', '01'),2,'0')|| RSDATyy,'MMDDYYYY') as RSDAT,
 TRGRESP,NTRGRESP
 from I5B_MC_JGDJ.rs1001_all) x) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
 from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
 where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID                     
