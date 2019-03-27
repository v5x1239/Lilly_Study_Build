                select  SUBJECT_ID,SUBJID,blockid,pagerpt,page,
        visitnum_DM,
        RSPERF,RSSPID,OVRLRESP,OVRLRESP_NRP,TRGRESP,RSDAT,NTRGRESP,
        DSDECOD,DSTERM_PRICOD,DTHDAT,sitemnemonic,SITECOUNTRY,
       
        case when OVR=1 then 1  end as PDcount,
      
        case when DTH=1 then 1  end as DTHcount,
        case when OVR=1 or DTH=1 then 1  end as Total
        
         from
   (select DISTINCT d.*,
      ( CASE WHEN OVRLRESP='Progressive Disease'  THEN dense_rank() over (partition by subjid ORDER BY ROWNUM) END)OVR,
      (CASE WHEN DSDECOD='DEATH' and (OVRLRESP<>'Progressive Disease' or OVRLRESP is null) THEN dense_rank() over (partition by subjid ORDER BY ROWNUM )END)DTH,1 study
      
       from
       (select distinct C.*,D.sitemnemonic,D.SITECOUNTRY
        from
        
        
        (
        SELECT COALESCE(B.SUBJECT_ID,C.SUBJECT_ID, D.SUBJECT_ID) AS SUBJECT_ID,COALESCE(B.SUBJID,C.SUBJID, D.SUBJID) AS SUBJID,COALESCE(B.blockid,C.blockid, D.blockid) AS blockid,b.pagerpt,COALESCE(c.page, d.page) as PAGE,
        ('Visit '||COALESCE(B.blockid,C.blockid, D.blockid)) visitnum_DM,
        RSPERF,RSSPID,OVRLRESP,OVRLRESP_NRP,TRGRESP,RSDAT,NTRGRESP,
        COALESCE(c.DSDECOD, d.DSDECOD) as DSDECOD, COALESCE(c.DSTERM_PRICOD, d.DSTERM_PRICOD) as DSTERM_PRICOD, COALESCE(c.DTHDAT, d.DTHDAT) as DTHDAT
        from
        
        (SELECT subject_id, SUBJID, blockid, PAGERPT,RSPERF,RSSPID,('Visit '||blockid)visitnum_DM, 
        decode(OVRLRESP,'CR','Complete Remission; Complete Response',
        'PR','Partial Remission; Partial Response','SD','Stable Disease',
        'PD','Progressive Disease',
        'NE','Not Evaluable',OVRLRESP) OVRLRESP,OVRLRESP_NRP,  decode(TRGRESP,
                'CR','Complete Remission; Complete Response',
                'PR','Partial Remission; Partial Response',
                'SD','Stable Disease',
                'PD','Progressive Disease',
                'NE','Not Evaluable',
                'NOT ASSESSED','Not Assessed',TRGRESP) TRGRESP,
                to_char( nvl2(RSDATDD,decode(RSDATDD,-99,'UNK',RSDATDD)||'-',null)||nvl2(RSDATMO,decode(RSDATMO,-
                99,'UNK',RSDATMO)||
                '-',null)||RSDATYY) AS RSDAT,
                 DECODE(NTRGRESP,'CR','Complete Remission; Complete Response',
                 'PR','Partial Remission; Partial Response',
                 'PD','Progressive Disease',
                 'Non-CR/Non-PD','Non Complete Response/Non Progressive Disease',
                'NOT ASSESSED','Not Assessed')NTRGRESP
        
                        FROM I4T_MC_JVDC.RS1001_ALL WHERE PAGE LIKE 'RS1001_F1' and OVRLRESP='PD')B
               FULL OUTER JOIN
         
        (Select subject_id, SUBJID,page, blockid, ('Visit '||blockid) visitnum, DSDECOD,DSTERM_PRICOD,
         to_char( nvl2(DTHDATDD,decode(DTHDATDD,-99,'UNK',DTHDATDD)||'-',null)||nvl2(DTHDATMO,decode(DTHDATMO,-
                99,'UNK',DTHDATMO)||
                '-',null)||DTHDATYY) AS DTHDAT,AEGRPID_RELREC
          from I4T_MC_JVDC.DS1001_ALL WHERE PAGE IN ('DS1001_F1','DS1001_F9','DS1001_F2','DS1001_F8','DS1001_F7','SS1001_DS1001_LF1') and DSDECOD='DEATH'
          )C on B.subject_id=C.subject_id AND B.BLOCKID=C.BLOCKID 
              FULL OUTER JOIN
         (Select subject_id, SUBJID,page, blockid, ('Visit '||blockid) visitnum, DSDECOD,DSTERM_PRICOD,
         to_char( nvl2(DTHDATDD,decode(DTHDATDD,-99,'UNK',DTHDATDD)||'-',null)||nvl2(DTHDATMO,decode(DTHDATMO,-
                99,'UNK',DTHDATMO)||
                '-',null)||DTHDATYY) AS DTHDAT,AEGRPID_RELREC
          from I4T_MC_JVDC.SS1001_DS1001_ALL WHERE DSDECOD='DEATH'
          )D on B.subject_id=D.subject_id    
         
      
        )C,
             (select distinct A.subject_id,B.sitemnemonic,B.SITECOUNTRY from I4T_MC_JVDC.inf_subject A,I4T_MC_JVDC.inf_site_all B
           where A.siteguid=B.ct_recid)D
           where C.subject_id=D.subject_id(+) AND (OVRLRESP='Progressive Disease' OR DSDECOD='DEATH')   ) d ) order by subjid
