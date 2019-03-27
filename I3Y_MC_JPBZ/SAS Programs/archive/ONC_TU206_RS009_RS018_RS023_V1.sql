select distinct usdyid as STUDY,invid as SITEMNEMONIC, r.SUBJID,TRSPID,RSSPID,TULNKID,TRPERF,TRDAT,RSDAT,TULOC1 as TULOC,TULOCOTH,TRMETHOD,TRMETHODOTH,TUMSTATE,TRSTRESC,LDIAM,SAXIS,SUMDIAM,PCBSD,PCNSD,CRF_TRGRESP,CALC_TRGRESP,CRF_NTRGRESP,OVRLRESP_NRP,OVRLRESP as CRF_OVRRESP,NEWTUMOR,
(er1_1||''||er1||''||er2||''||er3||''||er4||''||er5||''||er6||''||er7||''||er8||''||er9||''||er10||''||er11||''||er12||''||er13||''||er14||''||er15) as Error_Message,replace (TULNKID, 'T', '1') as sor
from (select c.*,case when LONG_DESC_TEXT is not null then LONG_DESC_TEXT else c.TULOC end as TULOC1,case when q.subjid is not null then '|DATE OF RESPONSE ASSESSMENT DOES NOT EQUAL DATE OF TUMOR MEASUREMENT| ' end as er1_1,case 
when c.OVRLRESP='CR' and d.subjid is not null then '|OVERALL RESPONSE = CR, HOWEVER CR CONDITIONS NOT MET| ' end as er1, case when c.OVRLRESP='PR' and e.subjid is not null then '|OVERALL RESPONSE = PR, HOWEVER PR CONDITIONS NOT MET| ' end as er2, 
case when c.OVRLRESP='SD' and f.subjid is not null then '|OVERALL RESPONSE = SD, HOWEVER SD CONDITIONS NOT MET| ' end as er3, case 
when c.OVRLRESP='PD' and g.subjid is not null then '|OVERALL RESPONSE = PD, HOWEVER PD CONDITIONS NOT MET| '  end as er4, case when c.OVRLRESP='NE' and h.subjid is not null then '|OVERALL RESPONSE = NE, HOWEVER NE CONDITIONS NOT MET| '
end as er5, case when c.OVRLRESP='CR' and i.subjid is not null then '|OVERALL RESPONSE = CR, HOWEVER SUBSEQUENT OVERALL RESPONSES = SD OR PR| ' else '' end as er6,
case when c.OVRLRESP in ('PR','CR') and j.subjid is not null then '|OVERALL RESPONSE = PR OR CR, HOWEVER CONFIRMATION ASSESSMENT WITH OVERALL RESPONSE = PR OR CR IS MISSING| ' else '' end as er7,
case when crf_TRGRESP='PR' and CALC_TRGRESP != 'PR' then '|CRF TARGET RESPONSE DOES NOT EQUAL THE CALCULATED TARGET RESPONSE| ' when crf_TRGRESP='PD' and CALC_TRGRESP != 'PD' then '|CRF TARGET RESPONSE DOES NOT EQUAL THE CALCULATED TARGET RESPONSE| '
when crf_TRGRESP='SD' and CALC_TRGRESP != 'SD' then '|CRF TARGET RESPONSE DOES NOT EQUAL THE CALCULATED TARGET RESPONSE| ' when crf_TRGRESP='NE' and CALC_TRGRESP != 'NE' then '|CRF TARGET RESPONSE DOES NOT EQUAL THE CALCULATED TARGET RESPONSE| '
else '' end as er8, case when CRF_NTRGRESP='PD' and k.subjid is null then '|NON-TARGET RESPONSE = PD, HOWEVER NON-TARGET PD CONDITIONS NOT MET| ' else '' end as er9,
case when CRF_NTRGRESP = 'Non CR or Non PD' and l.subjid is not null then '|NON-TARGET RESPONSE = Non CR or Non PD, HOWEVER NON-TARGET Non CR or Non PD CONDITIONS NOT MET| ' else '' end as er10, 
case when UPPER (CRF_NTRGRESP) in ('NOT ASSESSED', 'NOT ALL EVALUATED') and m.subjid is null then '|NON-TARGET RESPONSE = NOT ASSESSED OR NOT ALL EVALUATED, HOWEVER NON-TARGET NOT ASSESSED OR NOT ALL EVALUATED CONDITIONS NOT MET| '
end as er11, case when n.subjid is not null then '|METHOD OF MEASUREMENT HAS CHANGED FROM PREVIOUS ASSESSMENT FOR THIS TUMOR| ' end as er12, case when o.subjid is not null then '|MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN| '
end as er13, case when p.subjid is not null then '|MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN| ' else '' end as er14, case
when c.tuloc is not null and t.rank is null then '|LOCATION CODE ENTERED DOES NOT MATCH A LOCATION FROM THE CODELIST| ' end as er15 from (select x.*,SUMDIAM, case when base_SUMDIAM != 0 then round (((SUMDIAM-base_SUMDIAM)/base_SUMDIAM)*100) end as PCBSD,
case when small != 0 then round (((SUMDIAM-small)/small)*100) else to_number ('') end  as PCNSD, replace (y.blockid, 'XX', y.BLOCKRPT) as VISITNUM, y.RSSPID , y.RSDAT, y.TRGRESP  as CRF_TRGRESP,
case when x.TRSPID != 1 and i.subjid is not null and x.TULNKID='T01' then 'NE' when x.TRSPID != 1 and y.TRGRESP is not null and SUMDIAM is null and x.TULNKID='T01' then 'NE'
when x.TRSPID != 1 and base_SUMDIAM != 0 and round (((SUMDIAM-base_SUMDIAM)/base_SUMDIAM)*100) <= -30 then 'PR' when x.TRSPID != 1 and small != 0 and round (((SUMDIAM-small)/small)*100) >= 20 or small-SUMDIAM >= 5 then 'PD'
when x.TRSPID != 1 and ((base_SUMDIAM != 0 and round (((SUMDIAM-base_SUMDIAM)/base_SUMDIAM)*100) > -30) and (small != 0 and (((SUMDIAM-small)/small)*100) < 20) or small-SUMDIAM < 5) then 'SD'
else '' end as CALC_TRGRESP, y.NTRGRESP as CRF_NTRGRESP, y.OVRLRESP, y.OVRLRESP_NRP  from (SELECT a.SUBJID,a.BLOCKID,a.BLOCKRPT,TRSPID,TULNKID_TARGET AS TULNKID,TRPERF,TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0') || TRDATYY,'MMDDYYYY')AS TRDAT,
TULOC,TULOCOTH,TRMETHOD, TRMETHODOTH, TUMSTATE_TARGET AS TUMSTATE, TRSTRESC,LDIAM,SAXIS, '' as NEWTUMOR FROM    <prot>.TU2001a_ALL a INNER JOIN <prot>.TU2001b_ALL b ON A.SUBJID = b.SUBJID AND a.TULNKID_TARGET = b.TRLNKID
UNION SELECT a.SUBJID, a.BLOCKID,a.BLOCKRPT, TRSPID,TULNKID_NONTARGET AS TULNKID, TRPERF, TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0')|| TRDATYY,'MMDDYYYY') AS TRDAT,TULOC,TULOCOTH, TRMETHOD,
TRMETHODOTH,TUMSTATE_NONTARGET AS TUMSTATE, '' AS TRSTRESC,TO_NUMBER ('') AS LDIAM, TO_NUMBER ('') AS SAXIS, '' as NEWTUMOR FROM  <prot>.TU3001a_ALL a INNER JOIN  <prot>.TU3001b_ALL b ON A.SUBJID = b.SUBJID AND a.TULNKID_NONTARGET = b.TRLNKID
UNION SELECT a.SUBJID,a.BLOCKID,a.BLOCKRPT,TRSPID,TULNKID_NEW AS TULNKID,'' AS TRPERF, TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0')|| TRDATYY,'MMDDYYYY') AS TRDAT,TULOC,TULOCOTH,TRMETHOD,
TRMETHODOTH,TUMSTATE_NEW AS TUMSTATE,TRSTRESC, LDIAM,SAXIS, 'Y' as NEWTUMOR FROM    <prot>.TU1001a_ALL a INNER JOIN <prot>.TU1001b_ALL b ON A.SUBJID = b.SUBJID AND a.TULNKID_NEW = b.TRLNKID) x left join 
(select g.subjid, rsspid,blockid, blockrpt,TO_DATE (LPAD (REPLACE (RSDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (RSDATDD, '-99', '01'), 2, '0')|| RSDATYY,'MMDDYYYY') AS RSDAT, 
case when h.subjid is not null then 'T01' when h.subjid is null and u.subjid is not null then 'NT01' when h.subjid is null and u.subjid is null and t.subjid is not null then 'NEW01'
end as TULNKID, OVRLRESP, TRGRESP,NTRGRESP,OVRLRESP_NRP from <prot>.RS1001_ALL g left join (select distinct subjid,trspid from <prot>.TU2001b_ALL) h on g.subjid=h.subjid and g.RSSPID=h.trspid left join 
(select distinct subjid,trspid from <prot>.TU1001b_ALL) t on g.subjid=t.subjid and g.RSSPID=t.trspid left join (select distinct subjid,trspid from <prot>.TU3001b_ALL) u on g.subjid=u.subjid and g.RSSPID=u.trspid) y
on X.SUBJID=y.SUBJID and x.trspid=Y.RSSPID and x.tulnkid=y.tulnkid left join (select subjid, TRSPID,'T01' as TULNKID, sum (LDIAM_3 ) as SUMDIAM from (select distinct d.*,case when f.subjid is not null then to_number ('') else LDIAM_2 
end as LDIAM_3 from (select distinct c.*,  nvl(SAXIS,0) + nvl(LDIAM_1,0) as LDIAM_2  from (select x.* , case when TRSTRESC = 'TOO SMALL TO MEASURE' then 5 else LDIAM
end as LDIAM_1 from <prot>.TU2001b_ALL x) c) d left join (select distinct subjid, trspid from <prot>.TU2001b_ALL where TRPERF='N' or TUMSTATE_TARGET='NOT ASSESSABLE' or TRSTRESC='NOT MEASURED') f on d.subjid=f.subjid and d.trspid=f.trspid order by d.subjid, d.trspid, trlnkid ) GROUP BY subjid, TRSPID) g
on X.SUBJID=g.SUBJID and x.TRSPID=g.TRSPID and x.TULNKID=g.TULNKID left join (select * from (select subjid,TRSPID, 'T01' as TULNKID,sum (LDIAM_3 ) as base_SUMDIAM from (select d.*, case when f.subjid is not null then to_number ('') else LDIAM_2 
end as LDIAM_3 from (select c.*,  nvl(SAXIS,0) + nvl(LDIAM_1,0) as LDIAM_2  from (select x.* , case when TRSTRESC = 'TOO SMALL TO MEASURE' then 5 else LDIAM
end as LDIAM_1 from <prot>.TU2001b_ALL x) c) d left join (select distinct subjid, trspid from <prot>.TU2001b_ALL where TRPERF='N' or TUMSTATE_TARGET='NOT ASSESSABLE' or TRSTRESC='NOT MEASURED') f on d.subjid=f.subjid and d.trspid=f.trspid order by d.subjid, d.trspid, trlnkid ) GROUP BY subjid, TRSPID)
where TRSPID=1) f on X.SUBJID=f.SUBJID and x.TULNKID=f.TULNKID left join (select subjid,TRSPID,TULNKID,small_sum as small  from (select subjid, TRSPID, TULNKID, SUMDIAM,
LEAST (nvl(SUMDIAM,10000),nvl(prev_sum,10000),nvl(prev_sum1,10000),nvl(prev_sum2,10000),nvl(prev_sum15,10000),nvl(prev_sum3,10000),nvl(prev_sum4,10000),nvl(prev_sum5,10000),nvl(prev_sum6,10000),
nvl(prev_sum7,10000),nvl(prev_sum8,10000),nvl(prev_sum9,10000),nvl(prev_sum10,10000),nvl(prev_sum11,10000),nvl(prev_sum12,10000),nvl(prev_sum13,10000), nvl(prev_sum14,10000),
nvl(prev_sum15,10000),nvl(prev_sum16,10000),nvl(prev_sum17,10000),nvl(prev_sum18,10000),nvl(prev_sum19,10000),nvl(prev_sum20,10000),nvl(prev_sum21,10000),nvl(prev_sum22,10000),
nvl(prev_sum23,10000),nvl(prev_sum24,10000),nvl(prev_sum25,10000),nvl(prev_sum26,10000),nvl(prev_sum27,10000),nvl(prev_sum28,10000),nvl(prev_sum29,10000),nvl(prev_sum30,10000),
nvl(prev_sum31,10000),nvl(prev_sum32,10000),nvl(prev_sum33,10000),nvl(prev_sum34,10000),nvl(prev_sum35,10000),nvl(prev_sum36,10000),nvl(prev_sum37,10000),nvl(prev_sum38,10000),
nvl(prev_sum39,10000)) as small_sum from (select o.*, LAG (SUMDIAM, 1) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum, LAG (SUMDIAM, 2) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum1, 
LAG (SUMDIAM, 3) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum2, LAG (SUMDIAM, 4) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum3, LAG (SUMDIAM, 5) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum4,
LAG (SUMDIAM, 6) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum5, LAG (SUMDIAM, 7) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum6, LAG (SUMDIAM, 8) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum7,
LAG (SUMDIAM, 9) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum8, LAG (SUMDIAM, 10) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum9, LAG (SUMDIAM, 11) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum10,
LAG (SUMDIAM, 12) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum11, LAG (SUMDIAM, 13) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum12, LAG (SUMDIAM, 14) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum13,
LAG (SUMDIAM, 15) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum14, LAG (SUMDIAM, 16) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum15,LAG (SUMDIAM, 17) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum16,
LAG (SUMDIAM, 18) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum17,LAG (SUMDIAM, 19) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum18,LAG (SUMDIAM, 20) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum19,
LAG (SUMDIAM, 21) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum20, LAG (SUMDIAM, 22) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum21, LAG (SUMDIAM, 23) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum22,
LAG (SUMDIAM, 24) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum23, LAG (SUMDIAM, 25) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum24, LAG (SUMDIAM, 26) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum25,
LAG (SUMDIAM, 27) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum26, LAG (SUMDIAM, 28) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum27, LAG (SUMDIAM, 29) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum28,
LAG (SUMDIAM, 30) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum29, LAG (SUMDIAM, 31) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum30, LAG (SUMDIAM, 32) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum31,
LAG (SUMDIAM, 33) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum32, LAG (SUMDIAM, 34) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum33, LAG (SUMDIAM, 35) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum34,
LAG (SUMDIAM, 36) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum35, LAG (SUMDIAM, 37) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum36, LAG (SUMDIAM, 38) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum37,
LAG (SUMDIAM, 39) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum38, LAG (SUMDIAM, 40) OVER (PARTITION BY subjid  ORDER BY TRSPID) as prev_sum39 
from (select subjid,TRSPID, 'T01' as TULNKID, sum (LDIAM_3 ) as SUMDIAM from (select d.*, case when f.subjid is not null then to_number ('') else LDIAM_2 
end as LDIAM_3 from (select c.*,  nvl(SAXIS,0) + nvl(LDIAM_1,0) as LDIAM_2  from (select x.* , case when TRSTRESC = 'TOO SMALL TO MEASURE' then 5 else LDIAM
end as LDIAM_1 from <prot>.TU2001b_ALL x) c) d left join (select distinct subjid, trspid from <prot>.TU2001b_ALL where TRPERF='N' or TUMSTATE_TARGET='NOT ASSESSABLE' or TRSTRESC='NOT MEASURED') f on d.subjid=f.subjid and d.trspid=f.trspid order by d.subjid, d.trspid, trlnkid ) GROUP BY subjid, TRSPID) o))
) h on X.SUBJID=h.SUBJID and x.TRSPID=h.TRSPID and x.TULNKID=h.TULNKID left join (select subjid, trspid from <prot>.TU2001b_ALL
where TUMSTATE_TARGET='NOT ASSESSABLE' or trstresc='NOT MEASURED') i on X.SUBJID=i.SUBJID and x.TRSPID=i.TRSPID) c left join (select subjid, rsspid from (select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TRLNKID,
case when w.subjid is not null and z.subjid is not null and OVRLRESP='CR' and TRGRESP='CR' and NTRGRESP='CR' and  v.TRLNKID is null then 'x' when w.subjid is not null and z.subjid is null and OVRLRESP='CR' and TRGRESP='CR' and NTRGRESP ='NOT ASSESSED' and v.TRLNKID is null then 'x'
when w.subjid is null and z.subjid is not null and OVRLRESP='CR' and TRGRESP='NOT ASSESSED' and NTRGRESP ='CR' and v.TRLNKID is null then 'x' else '' end as flag
from <prot>.RS1001_ALL s left join <prot>.TU1001b_ALL v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID left join (select distinct subjid from <prot>.TU2001b_ALL) w
on s.SUBJID=w.subjid left join (select distinct subjid from <prot>.TU3001b_ALL) z on s.SUBJID=z.subjid) where OVRLRESP='CR' and flag is null) d on c.SUBJID=d.SUBJID and c.RSSPID=d.RSSPID left join (select subjid, rsspid from (select s.*, case when w.subjid is not null and z.subjid is not null and OVRLRESP='PR' and TRGRESP='CR' and NTRGRESP in ('Non CR or Non PD', 'NOT ASSESSED')
and  v.TRLNKID is null then 'x' when w.subjid is not null and z.subjid is not null and OVRLRESP='PR' and TRGRESP='PR' and NTRGRESP in ('Non CR or Non PD', 'NOT ALL EVALUATED')
and  v.TRLNKID is null then 'x' when w.subjid is not null and z.subjid is null and OVRLRESP='PR' and TRGRESP='PR' and NTRGRESP ='NOT ASSESSED' and v.TRLNKID is null then 'x'
when w.subjid is null and z.subjid is not null and OVRLRESP != 'PR' then 'x' else '' end as flag
from <prot>.RS1001_ALL s left join <prot>.TU1001b_ALL v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID left join (select distinct subjid from <prot>.TU2001b_ALL) w
on s.SUBJID=w.subjid left join (select distinct subjid from <prot>.TU3001b_ALL) z on s.SUBJID=z.subjid )
where OVRLRESP='PR' and flag is null) e on c.SUBJID=e.SUBJID and c.RSSPID=e.RSSPID left join (select distinct subjid, rsspid from (select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TRLNKID,
case when w.subjid is not null and z.subjid is not null and OVRLRESP='SD' and (TRGRESP='SD') and (NTRGRESP in ('Non CR or Non PD','NOT ASSESSED','CR', 'NOT ALL EVALUATED')) and v.TRLNKID is null then 'x'
when w.subjid is not null and z.subjid is null and OVRLRESP='SD' and TRGRESP='SD' and NTRGRESP ='NOT ASSESSED' and v.TRLNKID is null then 'x' when w.subjid is null and z.subjid is not null and OVRLRESP='SD' and TRGRESP='NOT ASSESSED' and NTRGRESP ='Non CR or Non PD' and v.TRLNKID is null then 'x'
else '' end as flag from <prot>.RS1001_ALL s left join <prot>.TU1001b_ALL v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID left join (select distinct subjid from <prot>.TU2001b_ALL) w
on s.SUBJID=w.subjid left join (select distinct subjid from <prot>.TU3001b_ALL) z on s.SUBJID=z.subjid)
where OVRLRESP='SD' and flag is null) f on c.SUBJID=f.SUBJID and c.RSSPID=f.RSSPID left join (select subjid, rsspid from (select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TRLNKID,
case when OVRLRESP='PD' and (TRGRESP='PD' or NTRGRESP = 'PD' or v.TRLNKID is not null or (upper(ovrlresp_nrp)='NON-RADIOLOGICAL PROGRESSION' and (TRGRESP !='SD' or NTRGRESP != 'SD'))) then 'x'
else '' end as flag from <prot>.RS1001_ALL s left join <prot>.TU1001b_ALL v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID) where OVRLRESP='PD' and flag is null) g on c.SUBJID=g.SUBJID and c.RSSPID=g.RSSPID left join (select subjid, rsspid from (select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TRLNKID,
case when OVRLRESP='NE' and (upper (TRGRESP) in ('NOT ALL EVALUATED', 'NE', 'NOT ASSESSED') or NTRGRESP in  ('Non CR or Non PD', 'NOT ALL EVALUATED', 'NOT ASSESSED') or v.TRLNKID  is null) or 
w.subjid is not null then 'x' else '' end as flag from <prot>.RS1001_ALL s left join <prot>.TU1001b_ALL v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID left join (select subjid, trspid from (select a.subjid, a.trspid, a.trlnkid, a.TRMETHOD, b.TRMETHOD, a.TRMETHODOTH, b.TRMETHODOTH from <prot>.TU2001B_ALL a left join 
(select * from <prot>.TU2001B_ALL where trspid=1) b  on a.subjid=b.subjid and a.trlnkid=b.trlnkid where a.TRMETHOD != b.TRMETHOD or a.TRMETHODOTH != b.TRMETHODOTH
union  select a.subjid, a.trspid, a.trlnkid, a.TRMETHOD, b.TRMETHOD, a.TRMETHODOTH, b.TRMETHODOTH from <prot>.TU3001B_ALL a left join (select * from <prot>.TU3001B_ALL where trspid=1) b 
on a.subjid=b.subjid and a.trlnkid=b.trlnkid where a.TRMETHOD != b.TRMETHOD or a.TRMETHODOTH != b.TRMETHODOTH)) w on s.SUBJID=w.subjid and s.RSSPID=w.TRSPID)
where OVRLRESP='NE' and flag is null) h on c.SUBJID=h.SUBJID and c.RSSPID=h.RSSPID left join (select a.subjid, a.rsspid from (select * from <prot>.RS1001_ALL where OVRLRESP='CR') a left join 
(select * from <prot>.RS1001_ALL where OVRLRESP in ('PR', 'SD')) b on a.subjid=b.subjid where a.rsspid < b.rsspid) i on c.SUBJID=i.SUBJID and c.RSSPID=i.RSSPID left join (select a.subjid,rs as RSSPID from (select subjid,OVRLRESP, count (*) as cn from <prot>.RS1001_ALL where OVRLRESP in ('CR', 'PR') group by subjid,OVRLRESP
having count (*) = 1) a left join (select  subjid, min(RSSPID) as rs from <prot>.RS1001_ALL where OVRLRESP in ('CR', 'PR') group by subjid order by subjid) b
on a.subjid=b.subjid) j on c.SUBJID=j.SUBJID and c.RSSPID=j.RSSPID left join (select a.subjid, rsspid from <prot>.RS1001_ALL a left join <prot>.TU3001B_ALL b
on a.subjid=b.subjid and a.rsspid=b.trspid where NTRGRESP='PD' and TUMSTATE_NONTARGET='UNEQUIVOCAL PROGRESSION') k on c.SUBJID=k.SUBJID and c.RSSPID=k.RSSPID left join (select a.subjid, rsspid from <prot>.RS1001_ALL a left join <prot>.TU3001B_ALL b
on a.subjid=b.subjid and a.rsspid=b.trspid where NTRGRESP = 'Non CR or Non PD' and TUMSTATE_NONTARGET = 'UNEQUIVOCAL PROGRESSION') l on c.SUBJID=k.SUBJID and c.RSSPID=l.RSSPID left join (select a.subjid, rsspid from <prot>.RS1001_ALL a left join <prot>.TU3001B_ALL b
on a.subjid=b.subjid and a.rsspid=b.trspid where NTRGRESP in ('NOT ASSESSED', 'NOT ALL EVALUATED') and (upper (TUMSTATE_NONTARGET) = 'NOT ASSESSABLE' or TRPERF='N' or TUMSTATE_NONTARGET is null)) m on c.SUBJID=m.SUBJID and c.RSSPID=m.RSSPID left join (select subjid, trspid, trlnkid from (select subjid, trspid, trlnkid, TRMETHOD, TRMETHODOTH,
case when TRMETHOD in ('CT SCAN','SPIRAL CT') and LAG (TRMETHOD, 1) OVER (PARTITION BY subjid,trlnkid  ORDER BY trlnkid,trspid) not in ('SPIRAL CT','CT SCAN' ) then 'X' when TRMETHOD  not in ('CT SCAN','SPIRAL CT') and TRMETHOD != LAG (TRMETHOD, 1) OVER (PARTITION BY subjid,trlnkid  ORDER BY trlnkid,trspid) then 'X'
when TRMETHODOTH != LAG (TRMETHODOTH, 1) OVER (PARTITION BY subjid,trlnkid  ORDER BY trlnkid,trspid) then 'X' end as flag from <prot>.TU2001B_ALL UNION ALL select subjid, trspid, trlnkid, TRMETHOD, TRMETHODOTH,
case when TRMETHOD in ('CT SCAN','SPIRAL CT') and LAG (TRMETHOD, 1) OVER (PARTITION BY subjid,trlnkid  ORDER BY trlnkid,trspid) not in ('SPIRAL CT','CT SCAN' ) then 'X' when TRMETHOD  not in ('CT SCAN','SPIRAL CT') and TRMETHOD != LAG (TRMETHOD, 1) OVER (PARTITION BY subjid,trlnkid  ORDER BY trlnkid,trspid) then 'X'
when TRMETHODOTH != LAG (TRMETHODOTH, 1) OVER (PARTITION BY subjid,trlnkid  ORDER BY trlnkid,trspid) then 'X' end as flag from <prot>.TU3001B_ALL) where flag is not null) n on c.SUBJID=n.SUBJID and c.TRSPID=n.TRSPID and c.TULNKID=n.trlnkid left join (select j.*, 'T01' as TULNKID from (select a.subjid,trspid, tuloc
from <prot>.TU2001A_ALL a left join  <prot>.TU2001b_ALL b ON A.SUBJID = b.SUBJID AND a.TULNKID_TARGET = b.TRLNKID group by a.SUBJID, trspid ,tuloc having count (tuloc) > 2 and trspid=1) j ) o
on c.SUBJID=o.SUBJID and c.trspid=o.TRSPID and c.tuloc=o.tuloc and c.TULNKID=o.TULNKID left join (select j.*, 'T01' as TULNKID from (select a.subjid,trspid, tulocoth from <prot>.TU2001A_ALL a left join  <prot>.TU2001b_ALL b
ON A.SUBJID = b.SUBJID AND a.TULNKID_TARGET = b.TRLNKID group by a.SUBJID, trspid ,tulocoth having count (tulocoth) > 2 and trspid=1 )j )  p on c.SUBJID=p.SUBJID and c.trspid=p.TRSPID and c.tulocoth=p.tulocoth and c.TULNKID=p.TULNKID left join (select a.subjid, trspid,'T01' as TULNKID from (select subjid, trspid, min (TRDAT) as min_trdat from (select subjid, trspid,TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0') || TRDATYY,'MMDDYYYY')AS TRDAT
from <prot>.TU2001b_ALL union all select subjid, trspid,TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0') || TRDATYY,'MMDDYYYY')AS TRDAT
from <prot>.TU3001b_ALL union all select subjid, trspid,TO_DATE (LPAD (REPLACE (TRDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (TRDATDD, '-99', '01'), 2, '0') || TRDATYY,'MMDDYYYY')AS TRDAT
from <prot>.TU1001b_ALL) group by subjid, trspid) a left join  (select subjid, rsspid, TO_DATE (LPAD (REPLACE (RSDATMO, '-99', '01'), 2, '0')|| LPAD (REPLACE (RSDATDD, '-99', '01'), 2, '0')|| RSDATYY,'MMDDYYYY') AS RSDAT
from <prot>.RS1001_ALL) b on a.subjid=b.subjid and a.trspid=b.rsspid where min_trdat != RSDAT) q on c.SUBJID=q.subjid and c.TRSPID=q.TRSPID and c.TULNKID=q.TULNKID left join (select LONG_DESC_TEXT, RANK from MDF_SS_OWNER.ODM_CD_RPSTRY where ROOT_NM='LOC') t
on c.TULOC = t.rank) r left join (select distinct usdyid , invid,subjid from MDF_SS_OWNER.ivrs_sbjct_sts_vw where usdyid= REPLACE('<prot>','_','-')) q on r.subjid=q.subjid 
               