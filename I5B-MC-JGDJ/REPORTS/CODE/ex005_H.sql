select MERGE_DATETIME,x.SUBJID,SITEMNEMONIC,BlockID,Page,EXDOSDLY,EXTRTINT,EXDOSADJTP,EXPDOSEU,EXDOSEU,EXSTDAT,EXSTTIM,EXENDAT,EXENTIM
from
(select a.*
from
(SELECT MERGE_DATETIME,SUBJID,BlockID,Page,EXDOSDLY,EXTRTINT,EXDOSADJTP,EXPDOSEU,EXDOSEU,
to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT,
 decode(EXSTTIMHR,null,null,decode(EXSTTIMMI,null,null,lpad(replace(EXSTTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXSTTIMMI,'-99', '00'),2,'0'))) as EXSTTIM, 
to_date(lpad(replace(EXENDATMO,'-99', '01'),2,'0')||lpad(replace(EXENDATDD,'-99', '01'),2,'0')|| EXENDATYY,'MMDDYYYY')   as EXENDAT,
decode(EXENTIMHR,null,null,decode(EXENTIMMI,null,null,lpad(replace(EXENTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXENTIMMI,'-99', '00'),2,'0'))) as EXENTIM,
exspid
from I5B_MC_JGDJ.EX1001b_ALL
where page in ('EX1001_LF1','EX1001_LF2')) a,(SELECT MERGE_DATETIME,SUBJID,BlockID,Page,EXDOSDLY,EXTRTINT,EXDOSADJTP,EXPDOSEU,EXDOSEU,
to_date(lpad(replace(EXSTDATMO,'-99', '01'),2,'0')||lpad(replace(EXSTDATDD,'-99', '01'),2,'0')|| EXSTDATYY,'MMDDYYYY')  as  EXSTDAT,
 decode(EXSTTIMHR,null,null,decode(EXSTTIMMI,null,null,lpad(replace(EXSTTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXSTTIMMI,'-99', '00'),2,'0'))) as EXSTTIM, 
to_date(lpad(replace(EXENDATMO,'-99', '01'),2,'0')||lpad(replace(EXENDATDD,'-99', '01'),2,'0')|| EXENDATYY,'MMDDYYYY')   as EXENDAT,
decode(EXENTIMHR,null,null,decode(EXENTIMMI,null,null,lpad(replace(EXENTIMHR,'-99', '00'),2,'0')||':'||lpad(replace(EXENTIMMI,'-99', '00'),2,'0'))) as EXENTIM,
exspid
from I5B_MC_JGDJ.EX1001b_ALL
where page in ('EX1001_LF1','EX1001_LF2')) b
where a.SUBJID=b.SUBJID and a.BlockID=b.BlockID and a.Page=b.Page and a.EXDOSDLY=b.EXDOSDLY and a.EXTRTINT=b.EXTRTINT
and a.EXDOSADJTP=b.EXDOSADJTP and a.EXPDOSEU=b.EXPDOSEU and a.EXDOSEU=b.EXDOSEU and a.EXSTDAT=b.EXSTDAT and a.EXSTTIM=b.EXSTTIM and a.EXENDAT=b.EXENDAT
and a.EXENTIM=b.EXENTIM and a.exspid!=b.exspid) x left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
                       on x.SUBJID=b.SUBJID