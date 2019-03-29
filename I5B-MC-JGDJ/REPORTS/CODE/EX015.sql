select y.*,SITEMNEMONIC
from
(select x.*,
CASE
            WHEN EXSTDAT =
                    LAG (EXENDAT, 1)
                       OVER (PARTITION BY subjid, EXENDAT ORDER BY EXSTDAT)
            THEN
               'Start Date is not same as End Date of previous entry'
            ELSE
               ''
         END
            AS Flag
from
(SELECT MERGE_DATETIME,SUBJID,BlockID,Page,
to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT,
 decode(EXSTTIMHR,null,null,decode(EXSTTIMMI,null,null,lpad(replace(EXSTTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXSTTIMMI,'-99', '00'),2,'0'))) as EXSTTIM, 
to_date(lpad(replace(EXENDATMO,'-99', '01'),2,'0')||lpad(replace(EXENDATDD,'-99', '01'),2,'0')|| EXENDATYY,'MMDDYYYY')   as EXENDAT,
decode(EXENTIMHR,null,null,decode(EXENTIMMI,null,null,lpad(replace(EXENTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXENTIMMI,'-99', '00'),2,'0'))) as EXENTIM,
exspid
from I5B_MC_JGDJ.EX1001b_ALL
where page in ('EX1001_LF1','EX1001_LF2')) x)y left join 
(select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on Y.SUBJID=b.SUBJID




where flag is not null