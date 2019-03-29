select a.MERGE_DATETIME,SITEMNEMONIC,a.SUBJID,a.BLOCKID,a.page,DSSCAT,DSSTDAT 
 from
 (select a.MERGE_DATETIME,a.SUBJID,a.BLOCKID,a.page,DSSCAT ,
 to_date(lpad(replace(DSSTDATMO,'-99', '07'),2,'0') ||lpad(replace(DSSTDATDD,'-99', '15'),2,'0') || DSSTDATYY,'MMDDYYYY')  as DSSTDAT from I5B_MC_JGDJ.DS1001_ALL a,
 I5B_MC_JGDJ.AE4001a_ALL b
 where DSSCAT ='STUDY DISPOSITION' and DSSTDATMO is not null and DSSTDATDD is not null and DSSTDATYY is not null and a.page in ('DS1001_F1', 'DS1001_F2','DS1001_F4') and
 a.SUBJID not in (select SUBJID from I5B_MC_JGDJ.AE4001a_ALL b where AEYN is not null)) a left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                     from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                     where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
 on a.SUBJID=b.SUBJID