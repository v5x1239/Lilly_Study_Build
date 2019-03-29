select distinct

a.merge_datetime,
b.SITEMNEMONIC,
a.SUBJID,
a.TUMIDENT_TARGET,
a.TRLNKID_TU2F1,
a.TUDAT,
a.TRSPID_TU2F1,
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
    when c.TRSPID_TU2F1 != d.RSSPID then 'Flag1'
    else ''
end as Flag
from  (select a.*,b.TRSPID_TU2F1,b.TRDAT, TRLNKID_TU2F1 from   (select distinct 

SUBJID,
merge_datetime, 
TUMIDENT_TARGET, 
TULNKID_TARGET, 
TO_DATE (LPAD (REPLACE (TUDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDAT_TU2F1, '-99', '01'), 2, '0')
|| TUDATYY_TU2F1,'MMDDYYYY') AS TUDAT 

from I5B_MC_JGDJ.TU2001A_All) a

left join

(select distinct

SUBJID,
TRSPID_TU2F1,
TRLNKID_TU2F1, 
TO_DATE (LPAD (REPLACE (TRDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD_TU2F1, '-99', '01'), 2, '0')
|| TRDATYY_TU2F1,'MMDDYYYY') AS TRDAT

from I5B_MC_JGDJ.TU2001B_All) b

on a.SUBJID = b.SUBJID and a.TULNKID_TARGET = b.TRLNKID_TU2F1) c


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

select z.*
from
(select distinct

c.*,
d.RSSPID, 
d.RSDAT,
d.BLOCKID,
case
    when c.TRDAT != d.RSDAT then 'Flag2'
    else ''
end as Flag
from  (select a.*,b.TRSPID_TU2F1,b.TRDAT, TRLNKID_TU2F1 from   (select distinct 

SUBJID,
merge_datetime, 
TUMIDENT_TARGET, 
TULNKID_TARGET, 
TO_DATE (LPAD (REPLACE (TUDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TUDAT_TU2F1, '-99', '01'), 2, '0')
|| TUDATYY_TU2F1,'MMDDYYYY') AS TUDAT 

from I5B_MC_JGDJ.TU2001A_All) a

left join

(select distinct

SUBJID,
TRSPID_TU2F1,
TRLNKID_TU2F1, 
TO_DATE (LPAD (REPLACE (TRDATMO_TU2F1, '-99', '01'), 2, '0')
|| LPAD (REPLACE (TRDATDD_TU2F1, '-99', '01'), 2, '0')
|| TRDATYY_TU2F1,'MMDDYYYY') AS TRDAT

from I5B_MC_JGDJ.TU2001B_All
where TRSPID_TU2F1 != '1') b

on a.SUBJID = b.SUBJID and a.TULNKID_TARGET = b.TRLNKID_TU2F1) c


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
on c.SUBJID = d.SUBJID and c.TRSPID_TU2F1 = d.RSSPID) z
where flag is not null)a


left join (select dm.SUBJECT_ID,SUBJID,SEX,st.SITEMNEMONIC
                      from I5B_MC_JGDJ.inf_subject sb, I5B_MC_JGDJ.inf_site_update st, I5B_MC_JGDJ.DM1001_all dm
                      where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id) b
on a.SUBJID=b.SUBJID