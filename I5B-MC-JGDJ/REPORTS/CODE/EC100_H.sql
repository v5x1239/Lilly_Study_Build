select MERGE_DATETIME,a.SUBJID,SITEMNEMONIC,blockID,PRSPID,PRTPT,PRTRT,PRSTDAT,PRRESCU,PRRESC,PRRDESC
 from
 (select MERGE_DATETIME,SUBJID,blockID,PRSPID,PRTPT,PRTRT,
 to_date(lpad(replace(PRSTDATMO,'-99', '01'),2,'0')||lpad(replace(PRSTDATDD,'-99', '01'),2,'0')|| PRSTDATYY,'MMDDYYYY') as PRSTDAT,
 PRRESCU,PRRESC,PRRDESC
 from I5B_MC_JGDJ.PR1001b_ALL
 where page='PR1001_F2') a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
 on a.SUBJID=b.SUBJID