select distinct x.*from (select distinct a.merge_datetime, a.SITEMNEMONIC, a.SUBJID, a.AEGRPID,a.AESPID,a.AETERM,a.AECTCV4,a.AEDECOD,a.AELLT, a.AELLTCD,a.AESTDAT, a.AEONGO, a.AEENDAT, a.AEOUT,
    case when a.AESTDAT = b.AESTDAT then 'Duplicates with same SUBJID'
    else 'Overlaps with same SUBJID' end as Flag  
    from (select SITEMNEMONIC,a.*,AESPID, 
    TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
    TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
    AEOUT 
    from <prot>.AE4001A_ALL a left join   <prot>.AE4001B_ALL b
    on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID LEFT JOIN
              (SELECT sb.subject_id, st.SITEMNEMONIC, SITECOUNTRY
                 FROM <prot>.inf_subject sb,<prot>.inf_site_update st
                WHERE sb.SITEGUID = st.CT_RECID) o
           ON a.subject_id = o.subject_id) a,(select SITEMNEMONIC,a.*,AESPID, 
    TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
    TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
    AEOUT 
    from <prot>.AE4001A_ALL a left join   <prot>.AE4001B_ALL b
    on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID LEFT JOIN
              (SELECT sb.subject_id, st.SITEMNEMONIC, SITECOUNTRY
                 FROM <prot>.inf_subject sb, <prot>.inf_site_update st
                WHERE sb.SITEGUID = st.CT_RECID) o
           ON a.subject_id = o.subject_id) b
          where  a.SUBJID=b.SUBJID and a.AELLT=b.AELLT and a.AEGRPID != b.AEGRPID and
          ((a.AESTDAT > b.AESTDAT and a.AESTDAT < b.AEENDAT) or a.AESTDAT = b.AESTDAT or (a.AESTDAT > b.AESTDAT and (b.AEONGO='Y' or  b.AEENDAT is null)))
    
    union all
    
    select  distinct b.merge_datetime, b.SITEMNEMONIC, b.SUBJID, b.AEGRPID,b.AESPID,b.AETERM,b.AECTCV4,b.AEDECOD,b.AELLT, b.AELLTCD,b.AESTDAT, b.AEONGO, b.AEENDAT, b.AEOUT,
    case when a.AESTDAT = b.AESTDAT then 'Duplicates with same SUBJID'
    else 'Overlaps with same SUBJID' end as Flag  
    from (select SITEMNEMONIC,a.*,AESPID, 
    TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
    TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
    AEOUT 
    from (select * from <prot>.AE4001A_ALL where AEGRPID is not null) a inner join  (select * from <prot>.AE4001B_ALL) b
    on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID LEFT JOIN
              (SELECT sb.subject_id, st.SITEMNEMONIC, SITECOUNTRY
                 FROM <prot>.inf_subject sb, <prot>.inf_site_update st
                WHERE sb.SITEGUID = st.CT_RECID) o
           ON a.subject_id = o.subject_id) a,(select SITEMNEMONIC,a.*,AESPID, 
    TO_DATE (LPAD (REPLACE (AESTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (AESTDATDD, '-99', '01'), 2, '0')|| AESTDATYY,'MMDDYYYY') AS AESTDAT, AEONGO, 
    TO_DATE (LPAD (REPLACE (AEENDATMO, '-99', '12'), 2, '0')|| LPAD (REPLACE (AEENDATDD,'-99',DECODE (AEENDATMO, '2', '28', '30')),2,'0')|| AEENDATYY,'MMDDYYYY') AS AEENDAT, 
    AEOUT 
    from (select * from <prot>.AE4001A_ALL where AEGRPID is not null) a inner join  (select * from <prot>.AE4001B_ALL) b
    on a.subjid=b.subjid and a.AEGRPID=b.AEGRPID LEFT JOIN
              (SELECT sb.subject_id, st.SITEMNEMONIC, SITECOUNTRY
                 FROM <prot>.inf_subject sb, <prot>.inf_site_update st
                WHERE  sb.SITEGUID = st.CT_RECID) o
           ON a.subject_id = o.subject_id) b
          where  a.SUBJID=b.SUBJID and a.AELLT=b.AELLT and a.AEGRPID != b.AEGRPID and
          ((a.AESTDAT > b.AESTDAT and a.AESTDAT < b.AEENDAT) or a.AESTDAT = b.AESTDAT or (a.AESTDAT > b.AESTDAT and (b.AEONGO='Y' or  b.AEENDAT is null)))) x
