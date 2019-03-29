select MERGE_DATETIME,a.SUBJID,SITEMNEMONIC,SURVSTAT,SSLSTKAD,SSDAT
  from
  (select x.*
  from
  (select MERGE_DATETIME,SUBJID,SURVSTAT,
  to_date(lpad(replace(SSLSTKADMO,'-99', '01'),2,'0')||lpad(replace(SSLSTKADDD,'-99', '01'),2,'0')|| SSLSTKADYY,'MMDDYYYY') as SSLSTKAD,
  to_date(lpad(replace(SSDATMO,'-99', '01'),2,'0')||lpad(replace(SSDATDD,'-99', '01'),2,'0')|| SSDATYY,'MMDDYYYY') as SSDAT
  from I5B_MC_JGDJ.SS1001_DS1001_ALL
  where SURVSTAT='LOST TO FOLLOW-UP') x
  where SSDAT is not null and SSLSTKAD is not null and  SSDAT>SSLSTKAD) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
  on a.SUBJID=b.SUBJID