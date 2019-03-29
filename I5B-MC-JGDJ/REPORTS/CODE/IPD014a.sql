/*
 CHECK NUMBER/DVS REF ID: IPD014a
 BREIF DESCRIPTION:TNM Distant Metastasis A
 HEADER: See Code Header in TFS
 #TFS#
 */

SELECT distinct a.*, st.SITEMNEMONIC
  FROM (SELECT GREATEST (a.merge_datetime, b.merge_datetime)
                  AS merge_datetime,
               a.subject_id,
               a.subjid,
               a.tumident_target,
               a.tulnkid_target,
               a.tudat,
               a.tuloc_tu2f1,
               b.tnmmet,
               case when tnmmet != 'DISTANT METASTASIS M0' then 'TNMMET <> DISTANT METASTASIS M0'
               else ''
               end as flag
          FROM    (SELECT merge_datetime,
                          subject_id,
                          subjid,
                          tumident_target,
                          tulnkid_target,
                          REVIEWADMIN.CREATE_ISODATE (TUDAT_tu2f1,
                                                      TUDATMO_tu2f1,
                                                      TUDATYY_tu2f1)
                             AS tudat,
                          tuloc_tu2f1
                     FROM <prot>.TU2001A_ALL
                    WHERE tuloc_tu2f1 IN
                             ('135',
                              '455',
                              '568',
                              '569',
                              '570',
                              '571',
                              '572',
                              '645',
                              '1302')) a
               JOIN
                  (SELECT merge_datetime, subjid, tnmmet
                     FROM <prot>.ipd3001_all) b
               ON A.SUBJID = b.subjid) a,
       <prot>.inf_subject sb,
       <prot>.inf_site_update st
 WHERE a.subject_id = sb.subject_id AND sb.SITEGUID = st.CT_RECID