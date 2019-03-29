/*
 CHECK NUMBER/DVS REF ID: IPD014b
 BREIF DESCRIPTION:TNM Distant Metastasis B
 HEADER: See Code Header in TFS
 #TFS#
 */

SELECT distinct a.*, st.SITEMNEMONIC
  FROM (SELECT GREATEST (a.merge_datetime, b.merge_datetime)
                  AS merge_datetime,
               a.subject_id,
               a.subjid,
               a.tumident_nontarget,
               a.tulnkid_nontarget,
               a.tudat,
               a.tuloc,
               b.tnmmet,
               case when tnmmet != 'DISTANT METASTASIS M0' then 'TNMMET <> DISTANT METASTASIS M0'
               else ''
               end as flag
          FROM    (select merge_datetime,
                          subject_id,
                          subjid,
                          tumident_nontarget,
                          tulnkid_nontarget,
                          REVIEWADMIN.CREATE_ISODATE (TUDATDD,
                                                      TUDATMO,
                                                      TUDATYY)
                             AS tudat,
                          tuloc
                     FROM <prot>.TU3001A_ALL
                    WHERE tuloc IN
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