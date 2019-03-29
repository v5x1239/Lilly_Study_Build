select 
 
 a.merge_datetime,
 b.SITEMNEMONIC,
 a.SUBJID, 
 a.PRSPID,
 a.IRADSTDAT,
 a.IRADENDAT,
 a.IRADLOC,
 a.IRADLOCOTH
 
 from
 
 (select a.merge_datetime,
 a.SUBJID, 
 a.PRSPID,
 a.IRADSTDAT,
 a.IRADENDAT,
 a.IRADLOC,
 a.IRADLOCOTH from (select z.*,to_date(lpad(replace(IRADSTDATMO,'-99', '01'),2,'0')
      ||lpad(replace(IRADSTDATDD,'-99', '01'),2,'0')
      || IRADSTDATYY,'MMDDYYYY') as IRADSTDAT, case when IRADENDATMO='2' then to_date(lpad(replace(IRADENDATMO,'-99', '12'),2,'0')
      ||lpad(replace(IRADENDATDD,'-99', '28'),2,'0')
      || IRADENDATYY,'MMDDYYYY')
    else to_date(lpad(replace(IRADENDATMO,'-99', '12'),2,'0')
      ||lpad(replace(IRADENDATDD,'-99', '30'),2,'0')|| IRADENDATYY,'MMDDYYYY') end  as IRADENDAT from I5B_MC_JGDJ.IRAD3001B_all z where page='IRAD3001_LF2' and iradloc is not null) a,
      (select z.*,to_date(lpad(replace(IRADSTDATMO,'-99', '01'),2,'0')
      ||lpad(replace(IRADSTDATDD,'-99', '01'),2,'0')
      || IRADSTDATYY,'MMDDYYYY') as IRADSTDAT, case when IRADENDATMO='2' then to_date(lpad(replace(IRADENDATMO,'-99', '12'),2,'0')
      ||lpad(replace(IRADENDATDD,'-99', '28'),2,'0')
      || IRADENDATYY,'MMDDYYYY')
    else to_date(lpad(replace(IRADENDATMO,'-99', '12'),2,'0')
      ||lpad(replace(IRADENDATDD,'-99', '30'),2,'0')|| IRADENDATYY,'MMDDYYYY') end  as IRADENDAT from I5B_MC_JGDJ.IRAD3001B_all z where page='IRAD3001_LF2' and iradloc is not null) b
      where a.subjid=B.SUBJID and a.PRSPID != b.PRSPID and a.IRADLOC=b.IRADLOC and a.IRADSTDAT=b.IRADSTDAT) A
      
 
 left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) B
 on a.SUBJID=b.SUBJID