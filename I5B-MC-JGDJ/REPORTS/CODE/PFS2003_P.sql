Select a.*,b.DSPROGTYP,b.DSSTDAT,
  case
          when  (PFS2DAT is not null and DSSTDAT is not null and PFS2DAT < DSSTDAT)
          then 'Assessment Date must be >=the treatment disposition date'
           else ''
       end as flag
  from
  (select a.*,b.SITEMNEMONIC
  from
  (select merge_datetime, SUBJID,PFS2ASMT,page,
    TO_DATE (LPAD (REPLACE (PFS2DATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (PFS2DATDD, '-99', '01'), 2, '0')|| PFS2DATYY,'MMDDYYYY') AS PFS2DAT
    from I5B_MC_JGDJ.PFS21001_ALL where page = 'PFS21001_DS1001_F1') a
     left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                       from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                       where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on a.SUBJID=b.SUBJID)a  left join (select subjid,DSPROGTYP,
    TO_DATE (LPAD (REPLACE (DSSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (DSSTDATDD, '-99', '01'), 2, '0')|| DSSTDATYY,'MMDDYYYY') AS DSSTDAT
    from I5B_MC_JGDJ.DS1001_ALL where page = 'DS1001_F2') b
    on a.subjid = b.subjid