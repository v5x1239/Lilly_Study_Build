select distinct 

A.MERGE_DATETIME,
B.SITEMNEMONIC,
A.SUBJID,
case
    when to_Number(A.BLOCKRPT) is null then A.BLOCKID
    else to_char(A.VISITNUM)
end as BLOCKID,
A.RSPERF,
A.RSSPID

from 


(((select distinct x.* from


(select a.*,b.VISITNUM
 from (select c.*, d.NTRGRESP from (select a.*,b.TRGRESP from (select distinct

MERGE_DATETIME,
SUBJID,
BLOCKID,
BLOCKRPT,
RSPERF,
RSSPID,
TO_DATE (LPAD (REPLACE (RSDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (RSDATDD, '-99', '01'), 2, '0')
|| RSDATYY,'MMDDYYYY') AS RSDAT

from I5B_MC_JGDJ.RS1001_All
where RSPERF is not null and page in ('RS1001_F1')) a

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
TRGRESP

from I5B_MC_JGDJ.RS1001_All
where TRGRESP is not null and page in ('RS1001_F1')) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID) c

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
NTRGRESP

from I5B_MC_JGDJ.RS1001_All
where NTRGRESP is not null and page in ('RS1001_F1')) d

on c.SUBJID = d.SUBJID and c.BLOCKID = d.BLOCKID) a

left join

(select distinct

SUBJID,
BLOCKID,
BLOCKRPT,
VISITNUM

from I5B_MC_JGDJ.SV1001_All) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID and NVL(a.BLOCKRPT,0) = NVL(b.BLOCKRPT,0)
where RSDAT is not null) x,


(select a.*,b.VISITNUM
 from (select c.*, d.NTRGRESP from (select a.*,b.TRGRESP from (select distinct

MERGE_DATETIME,
SUBJID,
BLOCKID,
BLOCKRPT,
RSPERF,
RSSPID,
TO_DATE (LPAD (REPLACE (RSDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (RSDATDD, '-99', '01'), 2, '0')
|| RSDATYY,'MMDDYYYY') AS RSDAT

from I5B_MC_JGDJ.RS1001_All
where RSPERF is not null and page in ('RS1001_F1')) a

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
TRGRESP

from I5B_MC_JGDJ.RS1001_All
where TRGRESP is not null and page in ('RS1001_F1')) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID) c

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
NTRGRESP

from I5B_MC_JGDJ.RS1001_All
where NTRGRESP is not null and page in ('RS1001_F1')) d

on c.SUBJID = d.SUBJID and c.BLOCKID = d.BLOCKID) a

left join

(select distinct

SUBJID,
BLOCKID,
BLOCKRPT,
VISITNUM

from I5B_MC_JGDJ.SV1001_All) b
on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID and NVL(a.BLOCKRPT,0) = NVL(b.BLOCKRPT,0)) y

where x.SUBJID = y.SUBJID and x.RSSPID = y.RSSPID and x.BLOCKID != y.BLOCKID))
order by x.SUBJID) A

left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID