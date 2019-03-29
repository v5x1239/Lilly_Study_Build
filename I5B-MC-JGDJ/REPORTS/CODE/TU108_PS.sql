select distinct

a.merge_datetime,
b.SITEMNEMONIC,
a.SUBJID,
a.TUMIDENT_NEW,
a.TULNKID_NEW,
a.TUDAT,
a.TRSPID,
a.TRDAT,
a.BLOCKID,
a.RSSPID,
a.RSDAT,
a.Flag

from

(select distinct

c.*,
d.RSSPID, 
d.RSDAT,
d.BLOCKID,
case
    when c.TRSPID != d.RSSPID then 'Flag1'
    else ''
end as Flag
from  (select a.*,b.TRSPID,b.TRDAT, b.TRLNKID from   (select distinct 

SUBJID,
merge_datetime, 
TUMIDENT_NEW, 
TULNKID_NEW, 
TO_DATE (LPAD (REPLACE (TUDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDATDD, '-99', '01'), 2, '0')
|| TUDATYY,'MMDDYYYY') AS TUDAT 

from I5B_MC_JGDJ.TU1001A_All) a

left join

(select distinct

SUBJID,
TRSPID,
TRLNKID, 
TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0')
|| TRDATYY,'MMDDYYYY') AS TRDAT

from I5B_MC_JGDJ.TU1001B_All) b

on a.SUBJID = b.SUBJID and a.TULNKID_NEW = b.TRLNKID) c


left join

(select * from (select distinct 

SUBJID,
case
    when to_Number(BLOCKRPT) is null then BLOCKID
    else to_char(VISITNUM)
end as BLOCKID,
RSSPID,
RSDAT

from 

(select a.*,b.VISITNUM
 from (select c.*, d.NTRGRESP from (select a.*,b.TRGRESP from (select distinct

SUBJID,
BLOCKID,
BLOCKRPT,
RSSPID,
TO_DATE (LPAD (REPLACE (RSDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (RSDATDD, '-99', '01'), 2, '0')
|| RSDATYY,'MMDDYYYY') AS RSDAT

from I5B_MC_JGDJ.RS1001_All
where RSPERF is not null) a

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
TRGRESP

from I5B_MC_JGDJ.RS1001_All
where TRGRESP is not null) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID) c

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
NTRGRESP

from I5B_MC_JGDJ.RS1001_All
where NTRGRESP is not null) d

on c.SUBJID = d.SUBJID and c.BLOCKID = d.BLOCKID) a

left join

(select distinct

SUBJID,
BLOCKID,
BLOCKRPT,
VISITNUM

from I5B_MC_JGDJ.SV1001_All) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID and NVL(a.BLOCKRPT,0) = NVL(b.BLOCKRPT,0)))
where RSDAT is not null) d
on c.SUBJID = d.SUBJID and c.TRDAT = d.RSDAT 

Union All

select distinct

c.*,
d.RSSPID, 
d.RSDAT,
d.BLOCKID,
case
    when c.TRDAT != d.RSDAT then 'Flag2'
    else ''
end as Flag
from  (select a.*,b.TRSPID,b.TRDAT, b.TRLNKID from   (select distinct 

SUBJID,
merge_datetime, 
TUMIDENT_NEW, 
TULNKID_NEW, 
TO_DATE (LPAD (REPLACE (TUDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDATDD, '-99', '01'), 2, '0')
|| TUDATYY,'MMDDYYYY') AS TUDAT 

from I5B_MC_JGDJ.TU1001A_All) a

left join

(select distinct

SUBJID,
TRSPID,
TRLNKID, 
TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0')
|| TRDATYY,'MMDDYYYY') AS TRDAT

from I5B_MC_JGDJ.TU1001B_All) b

on a.SUBJID = b.SUBJID and a.TULNKID_NEW = b.TRLNKID) c


left join

(select * from (select distinct 

SUBJID,
case
    when to_Number(BLOCKRPT) is null then BLOCKID
    else to_char(VISITNUM)
end as BLOCKID,
RSSPID,
RSDAT

from 

(select a.*,b.VISITNUM
 from (select c.*, d.NTRGRESP from (select a.*,b.TRGRESP from (select distinct

SUBJID,
BLOCKID,
BLOCKRPT,
RSSPID,
TO_DATE (LPAD (REPLACE (RSDATMO, '-99', '01'), 2, '0')
|| LPAD (REPLACE (RSDATDD, '-99', '01'), 2, '0')
|| RSDATYY,'MMDDYYYY') AS RSDAT

from I5B_MC_JGDJ.RS1001_All
where RSPERF is not null) a

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
TRGRESP

from I5B_MC_JGDJ.RS1001_All
where TRGRESP is not null) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID) c

left join

(select distinct
SUBJID,
BLOCKID,
RSSPID,
NTRGRESP

from I5B_MC_JGDJ.RS1001_All
where NTRGRESP is not null) d

on c.SUBJID = d.SUBJID and c.BLOCKID = d.BLOCKID) a

left join

(select distinct

SUBJID,
BLOCKID,
BLOCKRPT,
VISITNUM

from I5B_MC_JGDJ.SV1001_All) b

on a.SUBJID = b.SUBJID and a.BLOCKID = b.BLOCKID and NVL(a.BLOCKRPT,0) = NVL(b.BLOCKRPT,0)))
where RSDAT is not null) d
on c.SUBJID = d.SUBJID and c.TRSPID = d.RSSPID)a


left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID