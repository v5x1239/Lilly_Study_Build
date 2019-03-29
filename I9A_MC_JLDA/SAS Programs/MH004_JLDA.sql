select x.*
 from
 (
 select a.merge_datetime,a.SITEMNEMONIC,a.SUBJID,a.MHSPID,a.MHTERM,a.MHDECOD,a.MHSTDAT,a.MHENDAT,a.MHONGO
 from
 (select a.*,b.SITEMNEMONIC
 from
 (select merge_datetime, SUBJID, MHSPID, MHTERM, MHDECOD,MHONGO,
 to_date(lpad(replace(MHSTDATMO,'-99', '01'),2,'0')||lpad(replace(MHSTDATDD,'-99', '01'),2,'0')|| MHSTDATYY,'MMDDYYYY') as MHSTDAT, 
 to_date(lpad(replace(MHENDATMO,'-99', '12'),2,'0')||lpad(replace(MHENDATDD,'-99', decode(MHENDATMO,2,28,30)),2,'0')|| MHENDATYY,'MMDDYYYY')  as  MHENDAT
 from  I9A_MC_JLDA.mh8001_all) a  left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from I9A_MC_JLDA.inf_subject sb, I9A_MC_JLDA.inf_site_update st, I9A_MC_JLDA.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                    on a.SUBJID=b.SUBJID) a,(select a.*,b.SITEMNEMONIC
 from
 (select merge_datetime, SUBJID, MHSPID, MHTERM, MHDECOD,MHONGO,
 to_date(lpad(replace(MHSTDATMO,'-99', '01'),2,'0')||lpad(replace(MHSTDATDD,'-99', '01'),2,'0')|| MHSTDATYY,'MMDDYYYY') as MHSTDAT, 
 to_date(lpad(replace(MHENDATMO,'-99', '12'),2,'0')||lpad(replace(MHENDATDD,'-99', decode(MHENDATMO,2,28,30)),2,'0')|| MHENDATYY,'MMDDYYYY')  as  MHENDAT
 from  I9A_MC_JLDA.mh8001_all) a  left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from I9A_MC_JLDA.inf_subject sb, I9A_MC_JLDA.inf_site_update st, I9A_MC_JLDA.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                    on a.SUBJID=b.SUBJID) b
                    where a.SUBJID=b.SUBJID and a.MHTERM=b.MHTERM and a.MHSPID !=b.MHSPID and 
                    ((a.MHSTDAT > b.MHSTDAT and a.MHSTDAT < b.MHENDAT) or a.MHSTDAT = b.MHSTDAT or (a.MHSTDAT > b.MHSTDAT and (b.MHONGO='Y' or  b.MHENDAT is null)))
 
 union  all   
 select b.merge_datetime,b.SITEMNEMONIC,b.SUBJID,b.MHSPID,b.MHTERM,b.MHDECOD,b.MHSTDAT,b.MHENDAT,b.MHONGO
 from
 (select a.*,b.SITEMNEMONIC
 from
 (select merge_datetime, SUBJID, MHSPID, MHTERM, MHDECOD,MHONGO,
 to_date(lpad(replace(MHSTDATMO,'-99', '01'),2,'0')||lpad(replace(MHSTDATDD,'-99', '01'),2,'0')|| MHSTDATYY,'MMDDYYYY') as MHSTDAT, 
 to_date(lpad(replace(MHENDATMO,'-99', '12'),2,'0')||lpad(replace(MHENDATDD,'-99', decode(MHENDATMO,2,28,30)),2,'0')|| MHENDATYY,'MMDDYYYY')  as  MHENDAT
 from  I9A_MC_JLDA.mh8001_all) a  left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from I9A_MC_JLDA.inf_subject sb, I9A_MC_JLDA.inf_site_update st, I9A_MC_JLDA.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                    on a.SUBJID=b.SUBJID) a,(select a.*,b.SITEMNEMONIC
 from
 (select merge_datetime, SUBJID, MHSPID, MHTERM, MHDECOD,MHONGO,
 to_date(lpad(replace(MHSTDATMO,'-99', '01'),2,'0')||lpad(replace(MHSTDATDD,'-99', '01'),2,'0')|| MHSTDATYY,'MMDDYYYY') as MHSTDAT, 
 to_date(lpad(replace(MHENDATMO,'-99', '12'),2,'0')||lpad(replace(MHENDATDD,'-99', decode(MHENDATMO,2,28,30)),2,'0')|| MHENDATYY,'MMDDYYYY')  as  MHENDAT
 from  I9A_MC_JLDA.mh8001_all) a  left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                    from I9A_MC_JLDA.inf_subject sb, I9A_MC_JLDA.inf_site_update st, I9A_MC_JLDA.DM1001_all dm
                    where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                    on a.SUBJID=b.SUBJID) b
                    where a.SUBJID=b.SUBJID and a.MHTERM=b.MHTERM and a.MHSPID !=b.MHSPID and 
                    ((a.MHSTDAT > b.MHSTDAT and a.MHSTDAT < b.MHENDAT) or a.MHSTDAT = b.MHSTDAT or (a.MHSTDAT > b.MHSTDAT and (b.MHONGO='Y' or  b.MHENDAT is null)))
                 ) x