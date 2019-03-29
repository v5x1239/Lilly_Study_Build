/*
 CHECK NUMBER/DVS REF ID: PFS2004
 BREIF DESCRIPTION:Ensure a new treatment has been started after initial progression
 HEADER: See Code Header in TFS
 #TFS#
 */
 
SELECT DISTINCT a.*, st.SITEMNEMONIC, '<prot>' AS STUDY
  FROM (SELECT DISTINCT greatest(a.merge_datetime, b.merge_datetime) as merge_datetime,
                        a.subject_id,
                        a.subjid,
                        a.page,
                        a.start_date,
                        b.DSSTDAT
          FROM    (SELECT merge_datetime,
                          subject_id,
                          subjid,
                          page,
                          REVIEWADMIN.CREATE_ISODATE (IRADSTDATDD,
                                                      IRADSTDATMO,
                                                      IRADSTDATYY)
                             AS start_date
                     FROM <prot>.irad3001b_all
                    WHERE page = 'IRAD3001_LF2' AND IRADSTDATYY IS NOT NULL
                   UNION ALL
                   (SELECT merge_datetime,
                           subject_id,
                           subjid,
                           page,
                           REVIEWADMIN.CREATE_ISODATE (SGDATDD,
                                                       SGDATMO,
                                                       SGDATYY)
                              AS start_date
                      FROM <prot>.sg1001b_all
                     WHERE page = 'SG1001_LF2' AND SGDATYY IS NOT NULL)
                   UNION ALL
                   (SELECT merge_datetime,
                           subject_id,
                           subjid,
                           page,
                           REVIEWADMIN.CREATE_ISODATE (SYSTSTDATDD,
                                                       SYSTSTDATMO,
                                                       SYSTSTDATYY)
                              AS start_date
                      FROM <prot>.syst3001b_all
                     WHERE page = 'SYST3001_LF2' AND SYSTSTDATYY IS NOT NULL)) a
               JOIN
                  (SELECT merge_datetime,
                          subjid,
                          REVIEWADMIN.CREATE_ISODATE (DSSTDATDD,
                                                      DSSTDATMO,
                                                      DSSTDATYY)
                             AS DSSTDAT
                     FROM <prot>.ds1001_all
                    WHERE page = 'DS1001_F2' AND DSSTDATYY IS NOT NULL) b
               ON a.subjid = b.subjid AND a.start_date < b.DSSTDAT) a,
       <prot>.inf_subject sb,
       <prot>.inf_site_update st
 WHERE a.subject_id = sb.subject_id AND sb.SITEGUID = st.CT_RECID