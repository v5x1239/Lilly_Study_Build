select X.SUBJID,x.BlockID, EXTPT, EXSPID, EXSTDAT, EXSTTIM, COLLCTN_DT, 
substr(COLLCTN_TIME,1,2) as Col_HH,substr(COLLCTN_TIME,3,2) as Col_MM,
to_char( to_char(COLLCTN_TIME), 'HH24:MI:SS' ) as ss,
COLLCTN_TIME, RQSTN_NBR, PROC_CODE, CODE_DESC, LAB_RSLT
 from
 (select a.SUBJID,BlockID, EXTPT, EXSPID, EXSTDAT, EXSTTIM, COLLCTN_DT, COLLCTN_TIME, RQSTN_NBR, PROC_CODE, CODE_DESC, LAB_RSLT,col_tm,
 MIN(col_tm) OVER(PARTITION BY a.SUBJID,BlockID ORDER BY a.SUBJID,BlockID,col_tm RANGE UNBOUNDED PRECEDING) AS mi
 from
 (select  MERGE_DATETIME,SUBJID,Page,EXTPT, EXSPID,EXSTDAT,EXSTTIM,blockid
 from
 (select MERGE_DATETIME,a.SUBJID,Page,EXTPT, EXSPID,EXSTDAT,EXSTTIM,
     case 
     when a.BLOCKRPT is null and b.VISITNUM is null then ''
     when b.VISITNUM is null then a.blockid
     else to_char(b.VISITNUM)
     end as blockid
 from
 (SELECT MERGE_DATETIME,SUBJID,BlockID,Page,EXTPT, EXSPID,NVL(BLOCKRPT,0) as BLOCKRPT,
   to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT,
   decode(EXSTTIMHR,null,null,decode(EXSTTIMMI,null,null,lpad(replace(EXSTTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXSTTIMMI,'-99', '00'),2,'0'))) as EXSTTIM
   from I5B_MC_JGDJ.EX1001b_ALL
  where page ='EX1001_LF1')  a
  left join 
  (select SUBJID,VISITNUM,BLOCKID,NVL(BLOCKRPT,0) as BLOCKRPT FROM I5B_MC_JGDJ.SV1001_ALL) b
  on a.SUBJID=b.SUBJID and a.BlockID=b.BlockID and a.BLOCKRPT=b.BLOCKRPT)
  where blockid in ('1','2','3','4','5','7','9')) a
  inner join 
  (select SUBJID,visid, to_date(COLLCTN_DT) as COLLCTN_DT, COLLCTN_TIME, RQSTN_NBR, PROC_CODE, CODE_DESC, LAB_RSLT,
 to_char(COLLCTN_DT, 'HH24:MI:SS' ) as col_tm
 from
 (SELECT clrv.usdyid_unq_stdy_id_txt   usdyid,  clrv.resproj_rsrch_proj_cd_txt   resproj,  clrv.facility_fclty_cd_txt   facility,    
      clrv.sdyid_ct_cd_txt   sdyid,  clrv.invid_invstgtr_nbr   invid,  clrv.subjid_pat_nbr   subjid,    
      clrv.pat_brthdt   brthdt,   clrv.pat_sex_cd_txt  sex,  clrv.vis_nbr   visid, vis.visit_date_c as VISIT_DATE, 
      DECODE(clrv.unschdld_vis_txt,NULL,TO_NUMBER(NULL), 
      ASCII(clrv.unschdld_vis_txt) - 64)  unvisid,  clrv.lbreq_lab_rqstn_nbr_txt  rqstn_nbr,  lbacstdt_lab_cllct_dt_tmstmp  
      collctn_dt,  smple_tm_cllct_nbr collctn_time,   TO_DATE(smple_dt_rcvd_txt, 'YYYYMMDD') rcvd_dt,  
      clrv.perflbcd_prfm_lab_cd   perf_lab,   clrv.ORIG_LAB_NBR ORIG_LAB,  clrv.lab_rqstn_typ_txt  rqstn_typ,  
      clrv.LBPROC_LAB_PRCDR_CD_TXT PROC_CODE,  clrv.lbtestcd_lab_tst_cd_txt  test_cd,  cltcr.lbtest_lab_tst_cd_desc_txt CODE_DESC,  
      clrv.lab_unt_cd   unit_cd,  cltcr.lab_rslt_typ_txt   lab_rslt_typ,   clrv.lab_rslt_norm_txt  lab_rslt_nrmlzd,    
      DECODE(NVL(cltcr.lab_rslt_typ_txt, '?'), 'N', DECODE(clrv.lab_rslt_txt, 'NO TEST',NULL, 'PENDING',NULL, 'BLINDED', 'BQL', 
          'NEG', 'A', NULL,DECODE(SUBSTR(clrv.lab_rslt_txt,1,1),'<', NULL, '>', NULL,TO_CHAR(TO_NUMBER(clrv.lab_rslt_txt) 
          * cltcr.si_cnvrsn_fctr_nbr))), NULL) lab_rslt_si,    
      DECODE(NVL(cltcr.lab_rslt_typ_txt, '?'), 'N', DECODE(clrv.lab_rslt_txt, 'NO TEST',NULL, 'PENDING',NULL, 'BLINDED', 'BQL', 
          'NEG', 'A',  NULL,DECODE(SUBSTR(clrv.lab_rslt_txt,1,1),'<', NULL, '>', NULL,TO_CHAR(TO_NUMBER(clrv.lab_rslt_txt) 
          * cltcr.std_cnvntn_cnvrsn_fctr_nbr))), NULL) lab_rslt_cnvntnl,  
      clrv.lab_rslt_txt   lab_rslt   
  FROM MDF_SS_OWNER.LAB_TST_CD_REF  cltcr,   MDF_SS_OWNER.LAB_RSLT_VW  clrv, 
      (
      select trim(p.sitemnemonic) as SITEMNEMONIC, o.subjid, trim(o.blockid) as BLOCKID, o.visit_date_c 
      from 
          (
          select subject_id, subjid, blockid, 
              to_date
                  (
                      (lpad(vis.visdatyy,4,0) || lpad(vis.visdatmo,2,0) || lpad(vis.visdatdd,2,0)), 
                          'YYYYMMDD'
                  ) as VISIT_DATE, 
              to_char
                  ( 
                  to_date
                       (
                          (lpad(vis.visdatyy,4,0) || lpad(vis.visdatmo,2,0) || lpad(vis.visdatdd,2,0)), 
                              'YYYYMMDD'
                      ), 'DD-MON-YYYY' 
                  ) as VISIT_DATE_C 
          from I5B_MC_JGDJ.sv1001_all vis
          ) o left join 
          (
          select x.sitemnemonic, y.subject_id 
          from 
              (  
              select sitemnemonic, ct_recid  
              from I5B_MC_JGDJ.inf_site_all
              ) x inner join 
              ( 
              select siteguid, subject_id 
              from I5B_MC_JGDJ.inf_subject
              ) y 
                  on x.ct_recid = y.siteguid 
          ) p 
              on o.subject_id = p.subject_id
      ) vis 
  WHERE clrv.lbtestcd_lab_tst_cd_txt  = cltcr.lbtestcd_lab_tst_cd_txt(+)   
  AND clrv.lab_unt_cd = cltcr.lab_unt_cd(+)
  and trim(to_char(clrv.INVID_INVSTGTR_NBR,'9999')) = vis.sitemnemonic (+)
  and clrv.SUBJID_PAT_NBR = vis.subjid (+)
  and trim(to_char(clrv.vis_nbr,'9999')) = vis.blockid (+)
  AND clrv.usdyid_unq_stdy_id_txt = REPLACE('I5B_MC_JGDJ', '_', '-'))) b
  on a.SUBJID=b.SUBJID
  where COLLCTN_DT=EXSTDAT and PROC_CODE ='STYDRG' and code_desc='LY3012207, SERUM' ) x
  
  inner join
  
  (select distinct a.SUBJID,BlockID,
 MIN(col_tm) OVER(PARTITION BY a.SUBJID,BlockID ORDER BY a.SUBJID,BlockID,col_tm RANGE UNBOUNDED PRECEDING) AS mi
 from
 (select  MERGE_DATETIME,SUBJID,Page,EXTPT, EXSPID,EXSTDAT,EXSTTIM,blockid
 from
 (select MERGE_DATETIME,a.SUBJID,Page,EXTPT, EXSPID,EXSTDAT,EXSTTIM,
     case 
     when a.BLOCKRPT is null and b.VISITNUM is null then ''
     when b.VISITNUM is null then a.blockid
     else to_char(b.VISITNUM)
     end as blockid
 from
 (SELECT MERGE_DATETIME,SUBJID,BlockID,Page,EXTPT, EXSPID,NVL(BLOCKRPT,0) as BLOCKRPT,
   to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT,
   decode(EXSTTIMHR,null,null,decode(EXSTTIMMI,null,null,lpad(replace(EXSTTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXSTTIMMI,'-99', '00'),2,'0'))) as EXSTTIM
   from I5B_MC_JGDJ.EX1001b_ALL
  where page ='EX1001_LF1')  a
  left join 
  (select SUBJID,VISITNUM,BLOCKID,NVL(BLOCKRPT,0) as BLOCKRPT FROM I5B_MC_JGDJ.SV1001_ALL) b
  on a.SUBJID=b.SUBJID and a.BlockID=b.BlockID and a.BLOCKRPT=b.BLOCKRPT)
  where blockid in ('1','2','3','4','5','7','9')) a
  inner join 
  (select SUBJID,visid, to_date(COLLCTN_DT) as COLLCTN_DT, COLLCTN_TIME, RQSTN_NBR, PROC_CODE, CODE_DESC, LAB_RSLT,
 to_char(COLLCTN_DT, 'HH24:MI:SS' ) as col_tm
 from
 (SELECT clrv.usdyid_unq_stdy_id_txt   usdyid,  clrv.resproj_rsrch_proj_cd_txt   resproj,  clrv.facility_fclty_cd_txt   facility,    
      clrv.sdyid_ct_cd_txt   sdyid,  clrv.invid_invstgtr_nbr   invid,  clrv.subjid_pat_nbr   subjid,    
      clrv.pat_brthdt   brthdt,   clrv.pat_sex_cd_txt  sex,  clrv.vis_nbr   visid, vis.visit_date_c as VISIT_DATE, 
      DECODE(clrv.unschdld_vis_txt,NULL,TO_NUMBER(NULL), 
      ASCII(clrv.unschdld_vis_txt) - 64)  unvisid,  clrv.lbreq_lab_rqstn_nbr_txt  rqstn_nbr,  lbacstdt_lab_cllct_dt_tmstmp  
      collctn_dt,  smple_tm_cllct_nbr collctn_time,   TO_DATE(smple_dt_rcvd_txt, 'YYYYMMDD') rcvd_dt,  
      clrv.perflbcd_prfm_lab_cd   perf_lab,   clrv.ORIG_LAB_NBR ORIG_LAB,  clrv.lab_rqstn_typ_txt  rqstn_typ,  
      clrv.LBPROC_LAB_PRCDR_CD_TXT PROC_CODE,  clrv.lbtestcd_lab_tst_cd_txt  test_cd,  cltcr.lbtest_lab_tst_cd_desc_txt CODE_DESC,  
      clrv.lab_unt_cd   unit_cd,  cltcr.lab_rslt_typ_txt   lab_rslt_typ,   clrv.lab_rslt_norm_txt  lab_rslt_nrmlzd,    
      DECODE(NVL(cltcr.lab_rslt_typ_txt, '?'), 'N', DECODE(clrv.lab_rslt_txt, 'NO TEST',NULL, 'PENDING',NULL, 'BLINDED', 'BQL', 
          'NEG', 'A', NULL,DECODE(SUBSTR(clrv.lab_rslt_txt,1,1),'<', NULL, '>', NULL,TO_CHAR(TO_NUMBER(clrv.lab_rslt_txt) 
          * cltcr.si_cnvrsn_fctr_nbr))), NULL) lab_rslt_si,    
      DECODE(NVL(cltcr.lab_rslt_typ_txt, '?'), 'N', DECODE(clrv.lab_rslt_txt, 'NO TEST',NULL, 'PENDING',NULL, 'BLINDED', 'BQL', 
          'NEG', 'A',  NULL,DECODE(SUBSTR(clrv.lab_rslt_txt,1,1),'<', NULL, '>', NULL,TO_CHAR(TO_NUMBER(clrv.lab_rslt_txt) 
          * cltcr.std_cnvntn_cnvrsn_fctr_nbr))), NULL) lab_rslt_cnvntnl,  
      clrv.lab_rslt_txt   lab_rslt   
  FROM MDF_SS_OWNER.LAB_TST_CD_REF  cltcr,   MDF_SS_OWNER.LAB_RSLT_VW  clrv, 
      (
      select trim(p.sitemnemonic) as SITEMNEMONIC, o.subjid, trim(o.blockid) as BLOCKID, o.visit_date_c 
      from 
          (
          select subject_id, subjid, blockid, 
              to_date
                  (
                      (lpad(vis.visdatyy,4,0) || lpad(vis.visdatmo,2,0) || lpad(vis.visdatdd,2,0)), 
                          'YYYYMMDD'
                  ) as VISIT_DATE, 
              to_char
                  ( 
                  to_date
                      (
                          (lpad(vis.visdatyy,4,0) || lpad(vis.visdatmo,2,0) || lpad(vis.visdatdd,2,0)), 
                              'YYYYMMDD'
                      ), 'DD-MON-YYYY' 
                  ) as VISIT_DATE_C 
          from I5B_MC_JGDJ.sv1001_all vis
          ) o left join 
          (
          select x.sitemnemonic, y.subject_id 
          from 
              (  
              select sitemnemonic, ct_recid  
              from I5B_MC_JGDJ.inf_site_all
              ) x inner join 
              ( 
              select siteguid, subject_id 
              from I5B_MC_JGDJ.inf_subject
              ) y 
                  on x.ct_recid = y.siteguid 
          ) p 
              on o.subject_id = p.subject_id
      ) vis 
  WHERE clrv.lbtestcd_lab_tst_cd_txt  = cltcr.lbtestcd_lab_tst_cd_txt(+)   
  AND clrv.lab_unt_cd = cltcr.lab_unt_cd(+)
  and trim(to_char(clrv.INVID_INVSTGTR_NBR,'9999')) = vis.sitemnemonic (+)
  and clrv.SUBJID_PAT_NBR = vis.subjid (+)
  and trim(to_char(clrv.vis_nbr,'9999')) = vis.blockid (+)
  AND clrv.usdyid_unq_stdy_id_txt = REPLACE('I5B_MC_JGDJ', '_', '-'))) b
  on a.SUBJID=b.SUBJID
  where COLLCTN_DT=EXSTDAT and PROC_CODE ='STYDRG' and code_desc='LY3012207, SERUM') y
  on x.SUBJID=y.SUBJID and x.BlockID=y.BlockID and x.col_tm=y.mi