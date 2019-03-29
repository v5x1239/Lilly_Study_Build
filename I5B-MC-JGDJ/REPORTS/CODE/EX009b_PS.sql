select distinct X.merge_datetime,
Y.SITEMNEMONIC, 
X.SUBJID, 
X.BlockID,
X.EXSPID,
X.EXPDOSE,
X.EXPDOSEU,
X.WEIGHT,
X.WEIGHTU
from (select * from (select distinct c.*, (EXPDOSE-HH) as tx, (EXPDOSE+HH) as tt from  (select distinct
a.*,b.WEIGHT, b.WEIGHTU, b.wh
from (select distinct merge_datetime, SUBJID, BLOCKID, nvl(BLOCKRPT,0) as BLOCKRPT, EXSPID, EXPDOSE, EXPDOSEU, (expdose*5)/100 as hh 
from I5B_MC_JGDJ.EX1001B_all where page in ('EX1001_F3')) a left join (select distinct SUBJID, BLOCKID, nvl(BLOCKRPT,0) as BLOCKRPT, WEIGHT, WEIGHTU, (weight*20) as wh 
from I5B_MC_JGDJ.VS1001_all where page in ('VS1001_F2')) b on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID and a.BLOCKRPT = b.BLOCKRPT
where WEIGHT is not null) c)
where WH not between TX and TT) X
left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                       from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                       where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) Y
on X.SUBJID=Y.SUBJID 