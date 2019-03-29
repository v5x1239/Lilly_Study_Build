select SITEMNEMONIC, z.* from (select distinct a.SUBJECT_ID,a.merge_datetime, a.SUBJID,a.SYSTGRPID,a.CMSPID,a.SYSTTRT,a.SYSTSTDAT,a.SYSTENDAT
from (select z.*,TO_DATE (LPAD (REPLACE (SYSTSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (SYSTSTDATDD, '-99', '01'), 2, '0')||SYSTSTDATYY,'MMDDYYYY') AS SYSTSTDAT,
TO_DATE (LPAD (REPLACE (SYSTENDATMO, '-99', '12'),2,'0')|| LPAD (REPLACE (SYSTENDATDD,'-99',DECODE (SYSTENDATMO, '2', '28', '30')),2,'0')|| SYSTENDATYY,'MMDDYYYY') AS SYSTENDAT from I5B_MC_JGDJ.SYST3001b_ALL z
where SYSTGRPID is not null and page='SYST3001_LF1') a, (select z.*,TO_DATE (LPAD (REPLACE (SYSTSTDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (SYSTSTDATDD, '-99', '01'), 2, '0')||SYSTSTDATYY,'MMDDYYYY') AS SYSTSTDAT,
TO_DATE (LPAD (REPLACE (SYSTENDATMO, '-99', '12'),2,'0')|| LPAD (REPLACE (SYSTENDATDD,'-99',DECODE (SYSTENDATMO, '2', '28', '30')),2,'0')|| SYSTENDATYY,'MMDDYYYY') AS SYSTENDAT from I5B_MC_JGDJ.SYST3001b_ALL z
where SYSTGRPID is not null and page='SYST3001_LF1') b
where a.SUBJID=b.SUBJID and a.SYSTGRPID!=b.SYSTGRPID and 
((a.SYSTSTDAT  >= b.SYSTSTDAT and a.SYSTSTDAT < b.SYSTENDAT) or (a.SYSTSTDAT  = b.SYSTSTDAT and b.SYSTENDAT is null))) z left join (SELECT sb.subject_id, st.SITEMNEMONIC
                            FROM I5B_MC_JGDJ.inf_subject sb,
                                 I5B_MC_JGDJ.inf_site_update st
                           WHERE sb.SITEGUID = st.CT_RECID) o
                  ON z.SUBJECT_ID = o.subject_id 

