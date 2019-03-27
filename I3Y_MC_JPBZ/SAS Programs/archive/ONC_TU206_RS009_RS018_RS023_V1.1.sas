/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : ONC_TU206_RS009_RS018_RS023_V1.sas
PROJECT NAME (required)           : I3Y-MC-JPBK
DESCRIPTION (required)            : Summary of tumor and response data to ensure that data entered on the CRF aligns with the RECIST 1.1 response criteria. 
				    Version 1 of the report aligns with the initial study build template tumor and response forms including the following items:  
			            RSDAT, OVRLRESP_NRP, LDIAM, SAXIS.  .
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : ONC_TU206_RS009_RS018_RS023_V1.sql
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code
2.0  Deenadayalan     Updated per new spec "ONC_TU206_RS009_RS018_RS023_V1_Code Development Specifications_updated 14Jun2017"
3.0  Deenadayalan     Updated as per Sponsor request

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/
data master1;
	set clntrial.TU2001_D clntrial.TU3001_D clntrial.TU1001_D;
run;

proc sql;
	create table rs as
	select g.subjid, rsspid,blockid, blockrpt,RSDAT,
	case 
		when h.subjid is not null then 'T01' 
		when h.subjid is null and u.subjid is not null then 'NT01' 
		when h.subjid is null and u.subjid is null and t.subjid is not null then 'NEW01'
	end as TULNKID, OVRLRESP, TRGRESP,NTRGRESP,OVRLRESP_NRP 
	from  clntrial.RS1001_D g 
	left join (select distinct subjid,trspid from clntrial.TU2001_D) h on g.subjid=h.subjid and g.RSSPID=h.trspid left join 
(select distinct subjid,trspid from clntrial.TU1001_D) t on g.subjid=t.subjid and g.RSSPID=t.trspid left join 
(select distinct subjid,trspid from clntrial.TU3001_D) u on g.subjid=u.subjid and g.RSSPID=u.trspid;
quit;
proc sql;
	create table master2 as
	select distinct a.*, rsspid,RSDAT,OVRLRESP,TRGRESP,NTRGRESP,OVRLRESP_NRP
	from master1 a left join rs b
	on a.subjid=b.subjid and a.TRSPID=b.rsspid and a.TULNKID=b.TULNKID
	order subjid,trspid;
quit;
proc sql;
	create table measure as
	select a.*,case when f.subjid is not null then . else SUMDIAM1 end as SUMDIAM from 
	(select *, sum (LDIAM_1,SAXIS_) as SUMDIAM1, 'T01' as TULNKID from 
	(select distinct SUBJID, TRDAT format  date9., 
	TRSPID,sum (LDIAM_) as LDIAM_1, sum (SAXIS) as SAXIS_
	from (select *,case 
when TRSTRESC='TOO SMALL TO MEASURE' then 5
else LDIAM end as LDIAM_ from clntrial.TU2001_D)
	group by SUBJID,TRSPID) where not missing (TRDAT)) a left join (select distinct subjid, trspid,TRPERF,TUMSTATE,TRSTRESC from clntrial.TU2001_D 
where upcase (TRPERF)='N' or upcase (TUMSTATE)='NOT ASSESSABLE' or upcase (TRSTRESC)='NOT MEASURED') f
on a.subjid=f.subjid and a.trspid=f.trspid
where not missing (calculated SUMDIAM);
quit;
proc sort data=measure;
	by SUBJID trspid;
run;
data baseline;
	set measure;
	by SUBJID trspid;
	if first.SUBJID;
	base_SUMDIAM=SUMDIAM;
run;

Data tlxx_2;
     Set measure;
     By SUBJID trspid;

     If First.SUBJID then
           seq=1;
     Else seq+1;
Run;
Proc Sort data=tlxx_2;
     BY SUBJID trspid seq;
Run;
Proc transpose data=tlxx_2 out=temp1 prefix=seqt;
     By SUBJID trspid seq;
     ID seq;
     Var SUMDIAM;
Run;

Proc Sort data=temp1;
     by SUBJID trspid seq;
Run;

DATA Temp2 (Drop=seqt: _name_ i);
     Retain SUBJID trspid seq Var1-var100;
     Array seq_var {100} Var1-var100;
     Set Temp1;
     by   SUBJID trspid seq;
     Array Old_seqt {100} seqt1-seqt100;

     Do i= 1 to 100;
           If Old_seqt[i] NE . then
                seq_var[i]=Old_seqt[i];
     End;

     Do i= 2 to 100;
           If first.SUBJID then
                seq_var[i]=.;
     End;
run;

Data small (keep=SUBJID trspid small TULNKID);
     Set Temp2;
     small= Min(of var1 - var40);
	 TULNKID='T01';
Run;
/*To process for "METHOD OF MEASUREMENT HAS CHANGED FROM PREVIOUS ASSESSMENT FOR THIS TUMOR"*/
proc sort data=clntrial.TU2001_D out=TU2001B_meth;
	by subjid TULNKID trspid;
run;

data TU2001B_meth;
	set TU2001B_meth;
	by subjid TULNKID trspid;
	prev=lag (TRMETHOD);
	prev_oth=lag (TRMETHODOTH);
	if first.TULNKID then do;
		prev='';
		prev_oth='';
	end;
run;
proc sort data=clntrial.TU3001_D out=TU3001B_meth;
	by subjid TULNKID trspid;
run;

data TU3001B_meth;
	set TU3001B_meth;
	by subjid TULNKID trspid;
	prev=lag (TRMETHOD);
	prev_oth=lag (TRMETHODOTH);
	if first.TULNKID then do;
		prev='';
		prev_oth='';
	end;
run;
/*end*/
proc sql;
	create table master3 as
	select distinct SDYID as STUDY,invid as SITEMNEMONIC, r.SUBJID,TRSPID,RSSPID,TULNKID,TRPERF,TRDAT,RSDAT,TULOC1 as TULOC,
	TULOCOTH,TRMETHOD,TRMETHODOTH,TUMSTATE,TRSTRESC,LDIAM,SAXIS,SUMDIAM,PCBSD,PCNSD,CRF_TRGRESP,CALC_TRGRESP,CRF_NTRGRESP,
	OVRLRESP_NRP,OVRLRESP as CRF_OVRRESP,NEWTUMOR,
	catx ('',er1_1,er1,er2,er3,er4,er5,er6,er7,er8,er9,er10,er11,er12,er13,er14,er15) as Error_Message length=4000,
	tranwrd (TULNKID, 'T', '1') as sor
		from (
	select c.*,case when LONG_DESC_TEXT is not null then LONG_DESC_TEXT else c.TULOC end as TULOC1,
		case 
			when q.subjid is not null then '|DATE OF RESPONSE ASSESSMENT DOES NOT EQUAL DATE OF TUMOR MEASUREMENT| ' 
			else '' end as er1_1,
		case 
			when c.OVRLRESP='CR' and d.subjid is not null then '|OVERALL RESPONSE = CR, HOWEVER CR CONDITIONS NOT MET| ' 
			end as er1,
		case 
			when c.OVRLRESP='PR' and e.subjid is not null then '|OVERALL RESPONSE = PR, HOWEVER PR CONDITIONS NOT MET| ' 
			else '' end as er2,
		case 
			when c.OVRLRESP='SD' and f.subjid is not null then '|OVERALL RESPONSE = SD, HOWEVER SD CONDITIONS NOT MET| ' 
			else '' end as er3, 
		case 
			when c.OVRLRESP='PD' and g.subjid is not null then '|OVERALL RESPONSE = PD, HOWEVER PD CONDITIONS NOT MET| ' 
			else '' end as er4, 
		case 
			when c.OVRLRESP='NE' and h.subjid is not null then '|OVERALL RESPONSE = NE, HOWEVER NE CONDITIONS NOT MET| '
			else '' end as er5,
		case 
			when c.OVRLRESP='CR' and i.subjid is not null then '|OVERALL RESPONSE = CR, HOWEVER SUBSEQUENT OVERALL RESPONSES = SD OR PR| ' 
			else '' end as er6, 
		case 
			when c.OVRLRESP in ('PR','CR') and j.subjid is not null then 
			'|OVERALL RESPONSE = PR OR CR, HOWEVER CONFIRMATION ASSESSMENT WITH OVERALL RESPONSE = PR OR CR IS MISSING| ' else '' 
			end as er7,
		case 
			when c.TULNKID='T01' and not missing (c.crf_TRGRESP_) and c.CALC_TRGRESP ne c.crf_TRGRESP_ then 
			'|CRF TARGET RESPONSE DOES NOT EQUAL THE CALCULATED TARGET RESPONSE| '
			else '' end as er8,
		case 
			when CRF_NTRGRESP='PD' and k.subjid is null then '|NON-TARGET RESPONSE = PD, HOWEVER NON-TARGET PD CONDITIONS NOT MET| ' 
				else '' end as er9, 
		case 
			when CRF_NTRGRESP in ('Non CR or Non PD', 'Non-CR OR Non-PD') and l.subjid is not null then 
			'|NON-TARGET RESPONSE = Non CR or Non PD, HOWEVER NON-TARGET Non CR or Non PD CONDITIONS NOT MET| ' 
			else '' end as er10, 
		case 
			when upcase (CRF_NTRGRESP) in ('NOT ASSESSED', 'NOT ALL EVALUATED') and m.subjid is null 
			then '|NON-TARGET RESPONSE = NOT ASSESSED OR NOT ALL EVALUATED, HOWEVER NON-TARGET NOT ASSESSED OR NOT ALL EVALUATED CONDITIONS NOT MET| '
			else ''	end as er11, 
		case 
			when TRPERF ne 'N' and n.subjid is not null then '|METHOD OF MEASUREMENT HAS CHANGED FROM PREVIOUS ASSESSMENT FOR THIS TUMOR| ' 
			else '' end as er12, 
		case 
			when o.subjid is not null then '|MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN| '
			else '' end as er13, 
		case 
			when p.subjid is not null then '|MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN| ' 
			else '' end as er14, 
		case 
			when c.tuloc is not null and t.rank is null then 
				'|LOCATION CODE ENTERED DOES NOT MATCH A LOCATION FROM THE CODELIST| ' 
				end as er15 
		from (
/*Main Shell*/
select x.SUBJID, x.TRSPID,RSSPID,x.TULNKID, TRPERF,TRDAT,RSDAT, TULOC,TULOCOTH, TRMETHOD,TRMETHODOTH,TUMSTATE,TRSTRESC,LDIAM,SAXIS,
	g.SUMDIAM,
	 case when base_SUMDIAM ne 0 then round(((g.SUMDIAM-base_SUMDIAM)/base_SUMDIAM)*100) else . end as PCBSD ,
			case when small ne 0 then round (((g.SUMDIAM-small)/small)*100) else . end  as PCNSD , 
				 case when upcase(TRGRESP)='NOT ALL EVALUATED' then 'NE'
				else TRGRESP end as CRF_TRGRESP_,TRGRESP as CRF_TRGRESP,
				case when x.TRSPID ne 1 and i.subjid is not null and x.TULNKID='T01' then 'NE' 
					when x.TRSPID ne 1 and TRGRESP is not null and g.SUMDIAM is null and x.TULNKID='T01' then 'NE' 
					when x.TULNKID='T01' and x.TRSPID ne 1 and base_SUMDIAM ne 0 and round (((g.SUMDIAM-base_SUMDIAM)/base_SUMDIAM)*100) <= -30 then 'PR' 
					when x.TULNKID='T01' and x.TRSPID ne 1 and small ne 0 and round (((g.SUMDIAM-small)/small)*100) >= 20 or small-g.SUMDIAM >= 5 then 'PD'
					when x.TULNKID='T01' and x.TRSPID ne 1 and ((base_SUMDIAM ne 0 and round (((g.SUMDIAM-base_SUMDIAM)/base_SUMDIAM)*100) > -30) and 
						(small ne 0 and (((g.SUMDIAM-small)/small)*100) < 20) or small-g.SUMDIAM < 5) then 'SD' 
					else '' end as CALC_TRGRESP, NTRGRESP as CRF_NTRGRESP, OVRLRESP_NRP,OVRLRESP, NEWTUMOR
	from master2 x left join (select distinct SUBJID,TRSPID,TULNKID,SUMDIAM from  measure) g
	on X.SUBJID=g.SUBJID and x.TRSPID=g.TRSPID and x.TULNKID=g.TULNKID left join 
	(select SUBJID,TULNKID,base_SUMDIAM from baseline) f
	on X.SUBJID=f.SUBJID and x.TULNKID=f.TULNKID left join (select distinct SUBJID,TRSPID,TULNKID, small from small) h
	on X.SUBJID=h.SUBJID and x.TRSPID=h.TRSPID and x.TULNKID=h.TULNKID left join 
	(select distinct subjid, trspid from clntrial.TU2001_D where upcase (TUMSTATE)='NOT ASSESSABLE' or 
upcase (trstresc)='NOT MEASURED') i
on X.SUBJID=i.SUBJID and x.TRSPID=i.TRSPID) c 
/*DATE OF RESPONSE ASSESSMENT DOES NOT EQUAL DATE OF TUMOR MEASUREMENT*/
left join (select a.subjid, trspid,'T01' as TULNKID from 
	(select subjid, trspid, min (TRDAT) as min_trdat 
		from master1 (where=(not missing (TRDAT))) group by subjid, trspid) a inner join  
	(select subjid, rsspid, RSDAT from rs) b on a.subjid=b.subjid and a.trspid=b.rsspid where min_trdat ne RSDAT) q on 
	c.SUBJID=q.subjid and c.TRSPID=q.TRSPID and c.TULNKID=q.TULNKID 

/*OVERALL RESPONSE = CR, HOWEVER CR CONDITIONS NOT MET*/
left join (select subjid, rsspid from (select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TULNKID,
	case 
	when w.subjid is not null and z.subjid is not null and OVRLRESP='CR' and TRGRESP='CR' and NTRGRESP='CR' and  
	v.TULNKID is null then 'x' 
	when w.subjid is not null and z.subjid is null and OVRLRESP='CR' and TRGRESP='CR' and upcase (NTRGRESP) ='NOT ASSESSED' and 
	v.TULNKID is null then 'x'
	when w.subjid is null and z.subjid is not null and OVRLRESP='CR' and upcase (TRGRESP)='NOT ASSESSED' and NTRGRESP ='CR' and 
	v.TULNKID is null then 'x' else '' end as flag from rs s left join clntrial.TU1001_D v 
	on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID 
	left join (select distinct subjid from clntrial.TU2001_D) w on s.SUBJID=w.subjid 
	left join (select distinct subjid from clntrial.TU3001_D) z on s.SUBJID=z.subjid) 
	where OVRLRESP='CR' and flag is null) d
on c.SUBJID=d.SUBJID and c.RSSPID=d.RSSPID

/*OVERALL RESPONSE = PR, HOWEVER PR CONDITIONS NOT MET*/
left join (select subjid, rsspid from 
	(select s.*, 
		case 
			when w.subjid is not null and z.subjid is not null and OVRLRESP='PR' and TRGRESP='CR' and upcase (NTRGRESP) in 
			('NON CR OR NON PD', 'NOT ASSESSED', 'NON-CR OR NON-PD') and  v.TULNKID is null then 'x' 
			when w.subjid is not null and z.subjid is not null and OVRLRESP='PR' and TRGRESP='PR' and upcase (NTRGRESP) in 
			('NON CR OR NON PD', 'NOT ALL EVALUATED', 'NON-CR OR NON-PD') and  v.TULNKID is null then 'x' 
			when w.subjid is not null and z.subjid is null and OVRLRESP='PR' and TRGRESP='PR' and upcase (NTRGRESP) ='NOT ASSESSED' and 
			v.TULNKID is null then 'x'
			when w.subjid is null and z.subjid is not null and OVRLRESP ne 'PR' then 'x' else '' end as flag 
	from rs  s left join clntrial.TU1001_D v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID 
	left join (select distinct subjid from clntrial.TU2001_D) w on s.SUBJID=w.subjid 
	left join (select distinct subjid from clntrial.TU3001_D) z on s.SUBJID=z.subjid )
where OVRLRESP='PR' and flag is null) e on c.SUBJID=e.SUBJID and c.RSSPID=e.RSSPID

/*OVERALL RESPONSE = SD, HOWEVER SD CONDITIONS NOT MET*/
left join (select distinct subjid, rsspid from 
		(select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TULNKID, 
		case 
		when w.subjid is not null and z.subjid is not null and OVRLRESP='SD' and (TRGRESP='SD') and 
		(upcase (NTRGRESP) in ('NON CR OR NON PD','NOT ASSESSED','CR', 'NOT ALL EVALUATED', 'NON-CR OR NON-PD')) 
		and v.TULNKID is null then 'x'
		when w.subjid is not null and z.subjid is null and OVRLRESP='SD' and TRGRESP='SD' and upcase (NTRGRESP) ='NOT ASSESSED' 
		and v.TULNKID is null then 'x' 
		when w.subjid is null and z.subjid is not null and OVRLRESP='SD' and upcase (TRGRESP)='NOT ASSESSED' and 
		upcase (NTRGRESP) in ('NON-CR OR NON-PD','NON CR OR NON PD') and v.TULNKID is null then 'x'
		else '' end as flag from rs  s left join clntrial.TU1001_D v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID 
		left join (select distinct subjid from clntrial.TU2001_D) w
		on s.SUBJID=w.subjid left join (select distinct subjid from clntrial.TU3001_D) z 
		on s.SUBJID=z.subjid) 
		where OVRLRESP='SD' and flag is null) f on c.SUBJID=f.SUBJID and c.RSSPID=f.RSSPID 

/*OVERALL RESPONSE = PD, HOWEVER PD CONDITIONS NOT MET*/
left join (select distinct subjid, rsspid from 
	(select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TULNKID,
		case 
		when OVRLRESP='PD' and (TRGRESP='PD' or NTRGRESP = 'PD' or v.TULNKID is not null or 
		(upper(OVRLRESP_NRP)='NON-RADIOLOGICAL PROGRESSION' and (TRGRESP ne 'SD' or NTRGRESP ne 'SD'))) then 'x' else '' end as flag 
	from rs  s left join clntrial.TU1001_D v on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID) 
	where OVRLRESP='PD' and flag is null) g on c.SUBJID=g.SUBJID and c.RSSPID=g.RSSPID

/*OVERALL RESPONSE = NE, HOWEVER NE CONDITIONS NOT MET*/

left join (select distinct subjid, rsspid from 
	(select s.subjid, RSSPID,OVRLRESP,TRGRESP,NTRGRESP, v.TULNKID,
	case 
		when OVRLRESP='NE' and (upper (TRGRESP) in ('NOT ALL EVALUATED', 'NE', 'NOT ASSESSED') or 
		upper (NTRGRESP) in  ('NON CR OR NON PD', 'NOT ALL EVALUATED', 'NOT ASSESSED', 'NON-CR OR NON-PD') or v.TULNKID  is null) or 
		w.subjid is not null then 'x' else '' end as flag from rs s left join clntrial.TU1001_D v 
		on s.SUBJID=v.subjid and s.RSSPID=v.TRSPID left join 
			(select subjid, trspid from (select a.subjid, a.trspid, a.TULNKID, a.TRMETHOD, b.TRMETHOD, a.TRMETHODOTH, b.TRMETHODOTH 
		from clntrial.TU2001_D a left join 
(select * from clntrial.TU2001_D where trspid=1) b  on a.subjid=b.subjid and a.TULNKID=b.TULNKID 
	where a.TRMETHOD ne b.TRMETHOD or a.TRMETHODOTH ne b.TRMETHODOTH 
union  
select a.subjid, a.trspid, a.TULNKID, a.TRMETHOD, b.TRMETHOD, a.TRMETHODOTH, b.TRMETHODOTH from clntrial.TU3001_D a 
	left join (select * from clntrial.TU3001_D where trspid=1) b 
on a.subjid=b.subjid and a.TULNKID=b.TULNKID where a.TRMETHOD ne b.TRMETHOD or a.TRMETHODOTH ne b.TRMETHODOTH)) w 
on s.SUBJID=w.subjid and s.RSSPID=w.TRSPID) where OVRLRESP='NE' and flag is null) h on c.SUBJID=h.SUBJID and c.RSSPID=h.RSSPID

/*OVERALL RESPONSE = CR, HOWEVER SUBSEQUENT OVERALL RESPONSES = SD OR PR*/
left join (select distinct a.subjid, a.rsspid from (select * from clntrial.RS1001_D where OVRLRESP='CR') a left join 
(select * from clntrial.RS1001_D where OVRLRESP in ('PR', 'SD')) b on a.subjid=b.subjid where a.rsspid < b.rsspid) 
i on c.SUBJID=i.SUBJID and c.RSSPID=i.RSSPID 

/*OVERALL RESPONSE = PR OR CR, HOWEVER CONFIRMATION ASSESSMENT WITH OVERALL RESPONSE = PR OR CR IS MISSING*/
left join (select distinct a.subjid,rs as RSSPID from (select subjid,OVRLRESP, count (*) as cn from clntrial.RS1001_D 
where OVRLRESP in ('CR', 'PR') group by subjid,OVRLRESP
having count (*) = 1) a left join (select  subjid, min(RSSPID) as rs from clntrial.RS1001_D where OVRLRESP in ('CR', 'PR') 
group by subjid ) b on a.subjid=b.subjid) j on c.SUBJID=j.SUBJID and c.RSSPID=j.RSSPID

/*NON-TARGET RESPONSE = PD, HOWEVER NON-TARGET PD CONDITIONS NOT MET */
left join (select distinct a.subjid, rsspid from clntrial.RS1001_D a left join clntrial.TU3001_D b
on a.subjid=b.subjid and a.rsspid=b.trspid where NTRGRESP='PD' and upper (TUMSTATE)='UNEQUIVOCAL PROGRESSION') k 
on c.SUBJID=k.SUBJID and c.RSSPID=k.RSSPID 

/*NON-TARGET RESPONSE = Non CR or Non PD, HOWEVER NON-TARGET Non CR or Non PD CONDITIONS NOT MET*/
left join (select distinct a.subjid, rsspid from clntrial.RS1001_D a left join clntrial.TU3001_D b
on a.subjid=b.subjid and a.rsspid=b.trspid where upper (NTRGRESP) in ('NON CR OR NON PD','NON-CR OR NON-PD')
	and TUMSTATE = 'UNEQUIVOCAL PROGRESSION') l 
on c.SUBJID=l.SUBJID and c.RSSPID=l.RSSPID 


/*NON-TARGET RESPONSE = NOT ASSESSED OR NOT ALL EVALUATED, HOWEVER NON-TARGET NOT ASSESSED OR NOT ALL EVALUATED CONDITIONS NOT MET*/
left join (select distinct a.subjid, rsspid from clntrial.RS1001_D a left join clntrial.TU3001_D b
on a.subjid=b.subjid and a.rsspid=b.trspid where upper (NTRGRESP) in ('NOT ASSESSED', 'NOT ALL EVALUATED') and 
(upcase (TUMSTATE) = 'NOT ASSESSABLE' or TRPERF='N' or TUMSTATE is null)) m 
on c.SUBJID=m.SUBJID and c.RSSPID=m.RSSPID 

/*METHOD OF MEASUREMENT HAS CHANGED FROM PREVIOUS ASSESSMENT FOR THIS TUMOR*/
left join (select distinct subjid, trspid, TULNKID from 
		(select subjid, trspid, TULNKID, TRMETHOD, TRMETHODOTH,
		case 
		when TRMETHOD in ('CT SCAN','SPIRAL CT') and not missing (prev) and prev not in ('SPIRAL CT','CT SCAN' ) then 'X' 
		when TRMETHOD  not in ('CT SCAN','SPIRAL CT') and not missing (prev) and TRMETHOD ne prev then 'X'
		when not missing (prev_oth) and TRMETHODOTH ne prev_oth then 'X' 
		else '' end as flag from TU2001B_meth 
		UNION 
		select subjid, trspid, TULNKID, TRMETHOD, TRMETHODOTH,
		case 
		when TRMETHOD in ('CT SCAN','SPIRAL CT') and not missing (prev) and prev not in ('SPIRAL CT','CT SCAN' ) then 'X' 
		when TRMETHOD  not in ('CT SCAN','SPIRAL CT') and not missing (prev) and TRMETHOD ne prev then 'X'
		when not missing (prev_oth) and TRMETHODOTH ne prev_oth then 'X'  else '' end as flag 
from TU3001B_meth) where flag is not null) n on c.SUBJID=n.SUBJID and c.TRSPID=n.TRSPID and c.TULNKID=n.TULNKID

/*MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN*/
left join (select j.*, 'T01' as TULNKID from (select a.subjid,trspid, tuloc
from clntrial.TU2001_D  a
group by a.SUBJID, trspid ,tuloc having count (tuloc) > 2 and trspid=1) j) o 
on c.SUBJID=o.SUBJID and c.trspid=o.TRSPID and c.tuloc=o.tuloc and c.TULNKID=o.TULNKID 

/*MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN*/
left join (select j.*, 'T01' as TULNKID from (select a.subjid,trspid, tulocoth from clntrial.TU2001_D a 
group by a.SUBJID, trspid ,tulocoth having 
count (tulocoth) > 2 and trspid=1 )j) p 
on c.SUBJID=p.SUBJID and c.trspid=p.TRSPID and c.tulocoth=p.tulocoth and c.TULNKID=p.TULNKID 

/*LOCATION CODE ENTERED DOES NOT MATCH A LOCATION FROM THE CODELIST*/

left join (select LONG_DESC_TEXT, RANK from clntrial.ODM_LOC where ROOT_NM='LOC') t
on input (c.TULOC, best.) = t.rank) r
left join (select distinct SDYID , invid,subjid from clntrial.IVRSTSA) q on r.subjid=q.subjid 



order by subjid, trspid;
quit;


proc sql;
	create table ONC_TU206_RS009_RS018_RS023_V1 as
	select STUDY,SITEMNEMONIC,SUBJID,TRSPID,RSSPID,TULNKID,TRPERF,datepart (TRDAT) as TRDAT format date9.,
	datepart (RSDAT) as RSDAT format date9.,
	TULOC,TULOCOTH,TRMETHOD,TRMETHODOTH,TUMSTATE,TRSTRESC,LDIAM,SAXIS,SUMDIAM,PCBSD,PCNSD,CRF_TRGRESP,CALC_TRGRESP,CRF_NTRGRESP,
	OVRLRESP_NRP,CRF_OVRRESP,NEWTUMOR,Error_Message from master3
	where subjid in (select subjid from master3 where not missing (Error_Message ))
	order by SUBJID,TRSPID,SOR,TRDAT,RSSPID;
quit;

/*Print AE015a*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Summary of tumor and response data to ensure";
  title2 "that data entered on the CRF aligns with the RECIST 1.1 ";

proc print data=ONC_TU206_RS009_RS018_RS023_V1 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set ONC_TU206_RS009_RS018_RS023_V1 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
