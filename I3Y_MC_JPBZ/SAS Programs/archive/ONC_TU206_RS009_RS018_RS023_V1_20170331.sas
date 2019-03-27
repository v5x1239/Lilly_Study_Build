/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : ONC_TU206_RS009_RS018_RS023_V1.sas
PROJECT NAME (required)           : I3Y-MC-JPBZ
DESCRIPTION (required)            : Summary of tumor and response data to ensure that data entered on the CRF aligns with the RECIST 1.1 response criteria. 
				    Version 1 of the report aligns with the initial study build template tumor and response forms including the following items:  
				    RSDAT, OVRLRESP_NRP, LDIAM, SAXIS.  
SPECIFICATIONS (required)         : ONC_TU206_RS009_RS018_RS023_V1 Specifications 08Mar2017
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : TU1001a, TU1001b, RS1001, TU2001a, TU2001b, TU1003a, TU1003b, DS1001
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Deenadayalan     Original version of the code

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

proc sql;
create table site as
select distinct st.SITEMNEMONIC, SUBJID
from clntrial.inf_sub sb, clntrial.inf_site st, clntrial.DM1001 dm
where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id
order by SUBJID;
quit;

proc sql;
create table rs1001 as
select SUBJID, BLOCKID, BLOCKRPT, PAGE, PAGERPT, RSPERF, RSSPID, OVRLRNRP, TRGRESP, NTRGRESP, RSCATORA, RSCATREC, OVRLRESP, 
case when not missing (RSDAT) then datepart(RSDAT) else . end as RSDAT format date9.
from clntrial.rs1001;
quit;

proc sql;
	create table TU1001 as
	select x.*,RSPERF,RSDAT,OVRLRESP,OVRLRNRP,RSSPID,RSCATORA,RSCATREC from
	(select distinct a.SUBJID,a.BLOCKID,a.BLOCKRPT,a.PAGE,a.PAGERPT,a.TUCATREC,a.TULNKINW as TULNKID_NEW,case when not missing (TUDAT) then datepart(a.TUDAT) else . end as TUDAT format date9.,a.TULOC,
a.TULOCOTH,a.TUMETHOD as TRMETHOD,a.TUMTHODO as TRMTHODO,a.TUMIDENT,b.TRSPID,b.TRSTRESC,b.LDIAM,b.LDIAMU,b.SAXIS,b.SAXISU,b.TUMSTATE as TUMSTATE_NEW,b.TRLNKID
from clntrial.TU1001a a left join clntrial.TU1001b b 
on A.SUBJID = B.SUBJID and A.PAGE = B.PAGE and A.PAGERPT = B.PAGERPT )x 
left join (select * from RS1001 where not missing (RSSPID) and RSCATREC='RECIST 1.1') c
	on x.SUBJID=c.SUBJID and 
	x.TUDAT=c.RSDAT
	and x.TRSPID=c.RSSPID;
quit;
proc sql;
	create table TU2001 as
	select x.*,RSPERF,RSDAT,OVRLRESP,OVRLRNRP,RSSPID,RSCATORA,TRGRESP,RSCATREC from
	(select distinct a.SUBJID,a.BLOCKID,a.BLOCKRPT,a.PAGE,a.PAGERPT,a.TUCATREC,a.TULNKITG as TULNKID_TARGET,case when not missing (TUDAT) then datepart(a.TUDAT) else . end as TUDAT format date9.,
a.TULOC,a.TULOCOTH,a.TUMIDENT,b.TRSPID,case when not missing (TRDAT) then datepart(b.TRDAT) else . end as TRDAT format date9.,b.TRMETHOD,b.TRMTHODO,b.TRPERF,b.TUMSTATE as TUMSTATE_TARGET,
b.TRSTRESC,b.LDIAM,b.LDIAMU,b.SAXIS,b.SAXISU,b.TRLNKID,
case 
when TRSTRESC='TOO SMALL TO MEASURE' then 5
else LDIAM end as LDIAM_
from clntrial.TU2001a a left join clntrial.TU2001b b
on A.SUBJID = B.SUBJID and A.PAGE = B.PAGE and A.PAGERPT = B.PAGERPT)x 
left join (select * from RS1001 where not missing (RSSPID) and RSCATREC='RECIST 1.1') c
	on x.SUBJID=c.SUBJID and 
	x.TRDAT=c.RSDAT
	and x.TRSPID=c.RSSPID;
quit;
proc sql;
	create table measure as
	select *, sum (LDIAM_1,SAXIS_) as SUMDIAM, 'T01' as tar from  
	(select distinct SUBJID, TRDAT as TRDAT_, TRSPID, sum (LDIAM_) as LDIAM_1, sum (SAXIS) as SAXIS_
	from TU2001
	where TUCATREC='RECIST 1.1'
	group by SUBJID,TRSPID);
quit;
proc sort data=measure;
	by SUBJID TRDAT_;
run;
data baseline;
	set measure;
	by SUBJID TRDAT_;
	if first.SUBJID;
run;

Data tlxx_2;
     Set measure;
     By SUBJID TRDAT_;

     If First.SUBJID then
           seq=1;
     Else seq+1;
Run;
Proc Sort data=tlxx_2;
     BY SUBJID TRDAT_ seq;
Run;
Proc transpose data=tlxx_2 out=temp1 prefix=seqt;
     By SUBJID TRDAT_ seq;
     ID seq;
     Var SUMDIAM;
Run;

Proc Sort data=temp1;
     by SUBJID TRDAT_ seq;
Run;

DATA Temp2 (Drop=seqt: _name_ i);
     Retain SUBJID TRDAT_ seq Var1-var40;
     Array seq_var {40} Var1-var40;
     Set Temp1;
     by   SUBJID TRDAT_ seq;
     Array Old_seqt {40} seqt1-seqt40;

     Do i= 1 to 40;
           If Old_seqt[i] NE . then
                seq_var[i]=Old_seqt[i];
     End;

     Do i= 2 to 40;
           If first.SUBJID then
                seq_var[i]=.;
     End;
run;

Data small (keep=SUBJID TRDAT_ SUMDIAM);
     Set Temp2;
     SUMDIAM= Min(of var1 - var40);
Run;

proc sql;
	create table TU3001 as
	select x.*,RSPERF, RSDAT,OVRLRESP,OVRLRNRP,RSSPID,RSCATORA,NTRGRESP,RSCATREC from
	(select distinct a.SUBJID,a.BLOCKID,a.BLOCKRPT,a.PAGE,a.PAGERPT,a.TUCATREC,a.TULNKINT as TULNKID_NONTARGET, case when not missing (a.TUDAT) then datepart(TUDAT) else . end as TUDAT format date9.,
a.TULOC,a.TULOCOTH,a.TUMIDENT,b.TRSPID,case when not missing (TRDAT) then datepart(b.TRDAT) else . end as TRDAT format date9.,b.TRMETHOD,b.TRMTHODO,b.TRPERF,
b.TUMSTATE as TUMSTATE_NONTARGET,b.TRLNKID
from clntrial.TU3001a a left join clntrial.TU3001b b
on A.SUBJID = B.SUBJID and A.PAGE = B.PAGE and A.PAGERPT = B.PAGERPT)x 
left join (select * from RS1001 where not missing (RSSPID) and RSCATREC='RECIST 1.1') c
	on x.SUBJID=c.SUBJID and 
	x.TRDAT=c.RSDAT
	and x.TRSPID=c.RSSPID;
quit;
data tum;
length TULNKID $50;
	set TU1001 TU2001 TU3001;
	if not missing (TULNKID_NEW) then TULNKID=TULNKID_NEW;
	else if not missing (TULNKID_TARGET) then TULNKID=TULNKID_TARGET;
	else if not missing (TULNKID_NONTARGET) then TULNKID=TULNKID_NONTARGET;

	if not missing (TUMSTATE_NEW) then TUMSTATE=TUMSTATE_NEW;
	else if not missing (TUMSTATE_TARGET) then TUMSTATE=TUMSTATE_TARGET;
	else if not missing (TUMSTATE_NONTARGET) then TUMSTATE=TUMSTATE_NONTARGET;

	if not missing (TULNKID_NEW) then NEWTUMOR='Y';
	if TUCATREC='RECIST 1.1';

run;

proc sql;
	create table test as
	select a.SUBJID,a.BLOCKID,a.BLOCKRPT,a.BLOCKID as VISITNUM,a.TRSPID,RSSPID,TULNKID,TRPERF,
	TRDAT,RSDAT, TULOC as TULOC_TEXT,TULOCOTH,
	TRMETHOD,TRMTHODO,TUMSTATE,TRSTRESC,LDIAM,SAXIS,d.SUMDIAM,
	case
	when not missing (d.SUMDIAM) and not missing (e.SUMDIAM) then round((((d.SUMDIAM-e.SUMDIAM)/e.SUMDIAM)*100))
	else . end as PCBSD ,
	case
	when not missing (d.SUMDIAM) and not missing (f.SUMDIAM) then round((((d.SUMDIAM-f.SUMDIAM)/f.SUMDIAM)*100))
	else . end as PCNSD,TRGRESP as CRF_TRGRESP,
	case
	when a.TRSPID ne 1 and TULNKID='T01' and not missing (calculated PCBSD) and calculated PCBSD le -30 then 'PR'
	when a.TRSPID ne 1 and TULNKID='T01' and not missing (calculated PCNSD) and calculated PCNSD ge 20 then 'PD'
	when a.TRSPID ne 1 and TULNKID='T01' and not missing (calculated PCBSD) and not missing ( calculated PCNSD) 
	and (calculated PCBSD gt -30 or calculated PCNSD lt 20) then 'SD'
	when a.TRSPID ne 1 and TULNKID='T01' and not missing (nd) then nd
	else '' end as CALC_TRGRESP,
	NTRGRESP as CRF_NTRGRESP,OVRLRNRP,OVRLRESP as CRF_OVRRESP,NEWTUMOR,case when not missing (DSSTDAT) then datepart(DSSTDAT) else . end as DSSTDAT format date9.,
	DSDECOD,
	case
	when not missing (TRDAT) and not missing (RSDAT) and TRDAT ne RSDAT 
	then "DATE OF RESPONSE ASSESSMENT DOES NOT EQUAL DATE OF TUMOR MEASUREMENT"
	else '' end as er1 
	from tum a left join (select * from clntrial.DS1001 where page='DS1001_LF2' and not missing (DSSTDAT) and not missing (DSDECOD)) c
	on a.SUBJID=c.SUBJID left join measure d
	on a.SUBJID=d.SUBJID and a.TRSPID=d.TRSPID and a.TULNKID=d.tar left join (select distinct * from baseline) e
	on a.SUBJID=e.SUBJID left join (select distinct * from small) f
	on a.SUBJID=f.SUBJID and TRDAT=f.TRDAT_ left join
	(select distinct SUBJID, TRSPID,
	case when trstresc='NOT MEASURED' or TUMSTATE='NOT ASSESSABLE' then 'NE OR NOT ALL EVALUATED'
	else'' end as nd
	from tum
	where not missing (calculated nd)) g
	on a.SUBJID=g.SUBJID and a.TRSPID=g.TRSPID /*left join dm h
	on a.SUBJID=h.SUBJID*/;
quit;
data er2;
length er2 er3 er4 $200;
	set test;
	
	if CRF_OVRRESP='PR' then do;
		if CRF_TRGRESP ='CR' and upcase(CRF_NTRGRESP) eq 'NON-CR/NON-PD' and NEWTUMOR ne 'Y' then er2="";
		else if CRF_TRGRESP ='PR' and upcase(CRF_NTRGRESP) eq 'NON-CR/NON-PD' and NEWTUMOR ne 'Y' then er2="";
		else if CRF_TRGRESP='CR' and upcase(CRF_NTRGRESP) eq 'NOT ASSESSED' and NEWTUMOR ne 'Y' then er2="";
		else if CRF_TRGRESP='PR' and upcase(CRF_NTRGRESP) eq 'NOT ALL EVALUATED' and NEWTUMOR ne 'Y' then er2="";
		else er2= "OVERALL RESPONSE = PR, HOWEVER PR CONDITIONS NOT MET";
	end;
	if CRF_OVRRESP='SD' then do;
		if CRF_TRGRESP ='SD' and upcase(CRF_NTRGRESP) in ( 'NON-CR/NON-PD','NOT ALL EVALUATED', '') and NEWTUMOR ne 'Y' then er3="";
		else er3= "OVERALL RESPONSE = SD, HOWEVER SD CONDITIONS NOT MET";
	end;

	if CRF_OVRRESP='PD' then do;
		if CRF_TRGRESP ='PD' or upcase(CRF_NTRGRESP) ='PD' or NEWTUMOR eq 'Y' then er4="";
		else er4= "OVERALL RESPONSE = PD, HOWEVER PD CONDITIONS NOT MET";
	end;
run;
proc sort data=er2 out=er2_;
	by SUBJID TRDAT;
	where not missing (TRDAT);
run;
data er2_ (keep=SUBJID TRDAT TRMETHOD);
	set er2_;
	by SUBJID TRDAT;
	if first.SUBJID;
run;
proc sql;
	create table er5 as
	select a.*, b.TRMETHOD as base_method from er2 a left join (select * from er2_) b
	on a.subjid=b.subjid;
quit;
data er5 (drop=base_method);
length er5 $200;
	set er5;
	if CRF_OVRRESP='NE' then do;
		if (upcase(CRF_TRGRESP) in ('NOT ALL EVALUATED','NE','NOT ASSESSED', '') and 
	upcase(CRF_NTRGRESP) in ('NON-CR/NON-PD','NOT ALL EVALUATED','NE','NOT ASSESSED', '') and NEWTUMOR ne 'Y') or 
	(not missing (TRMETHOD) and not missing (base_method) and base_method ne TRMETHOD ) then er5="";
		else er5= "OVERALL RESPONSE = NE, HOWEVER NE CONDITIONS NOT MET";
	end;
run;
proc sql;
	create table er6_1 as 
	select a.*, b.CRF_OVRRESP as CR,crseq
	from er5 a left join (select distinct subjid, min (TRSPID) as crseq, CRF_OVRRESP from er5 where CRF_OVRRESP='CR') b
	on a.subjid=b.subjid;
quit;

data er6 (drop=CR crseq);
length er6 $200;
	set er6_1;	
	if not missing (TRSPID) and not missing (crseq) and  TRSPID gt crseq and CRF_OVRRESP in ('SD', 'PR') then 
		er6="OVERALL RESPONSE = CR, HOWEVER SUBSEQUENT OVERALL RESPONSES = SD OR PR";
		else er6= "";
run;	
proc sql;
	create table er7 as
	select a.*, case
	when not missing (b.CRF_OVRRESP) and a.CRF_OVRRESP not in ('PR', 'CR') then "OVERALL RESPONSE = PR OR CR, HOWEVER CONFIRMATION ASSESSMENT WITH OVERALL RESPONSE = PR OR CR IS MISSING"
	else '' end as er7 length=200,
	case 
	when not missing (CRF_TRGRESP) and not missing (CALC_TRGRESP) and CRF_TRGRESP ne CALC_TRGRESP then 
	"CRF TARGET RESPONSE DOES NOT EQUAL THE CALCULATED TARGET RESPONSE"
	else '' end as er8
	from er6 a left join (select distinct subjid, 2 as trpid,CRF_OVRRESP from er6 where CRF_OVRRESP in ('PR', 'CR') and TRSPID=1  ) b
	on a.subjid=b.subjid and a.TRSPID=b.trpid;
quit;

proc sql;
	create table er9 as
	select m.*, n.er11,
	case
	when CRF_OVRRESP='PD' and DSDECOD='PROGRESSIVE DISEASE' and RSDAT gt DSSTDAT
	then "OVERALL RESPONSE AND REASON FOR DISCONTINUATION = PD, HOWEVER DATE OF RESPONSE IS > DATE OF DISCONTINUATION" else ''
	end as er12 from (select a.*, b.er9,
	case
	when upcase(CRF_NTRGRESP) eq 'NON-CR/NON-PD' and TUMSTATE='UNEQUIVOCAL PROGRESSION'
	then "NON-TARGET RESPONSE = NON-CR OR NON-PD, HOWEVER NON-TARGET NON-CR OR NON-PD CONDITIONS NOT MET" 
	else '' end as er10 from er7 a left join (select subjid, TRSPID, TRDAT,TULNKID, 
	"NON-TARGET RESPONSE = PD, HOWEVER NON-TARGET PD CONDITIONS NOT MET" as er9 from er7 where CRF_NTRGRESP='PD'
	and subjid not in (select subjid from er7 where compress(put(subjid,best.)||put(trdat, date9.)) in 
	(select compress(put(subjid,best.)||put(trdat, date9.)) from er7 where TUMSTATE='UNEQUIVOCAL PROGRESSION')))b
	on a.subjid=b.subjid and a.TRSPID=b.TRSPID and a.TRDAT=b.TRDAT and a.TULNKID=b.TULNKID)m
	left join (select subjid, TRSPID, TRDAT,TULNKID, 
	"NON-TARGET RESPONSE = NOT ASSESSED OR NOT ALL EVALUATED, HOWEVER NON-TARGET NOT ASSESSED OR NOT ALL EVALUATED CONDITIONS NOT MET" 
	as er11 from er7 where upcase(CRF_NTRGRESP) in ('NOT ASSESSED','NOT ALL EVALUATED')
	and subjid not in (select subjid from er7 where compress(put(subjid,best.)||put(trdat, date9.)) in 
	(select compress(put(subjid,best.)||put(trdat, date9.)) from er7 where TUMSTATE='NOT ASSESSABLE'))) n
	on m.subjid=n.subjid and m.TRSPID=n.TRSPID and m.TRDAT=n.TRDAT and m.TULNKID=n.TULNKID
	;
quit;
proc sort data=er9 out=er13_ ;
	by subjid TULNKID;
run;
data er13_1 (keep=subjid TULNKID TRMETHOD);
	set er13_;
	by subjid TULNKID;
	if first.TULNKID;
run;
proc sql;
	create table er13 as
	select a.*,
	case 
	when a.TRMETHOD ne b.TRMETHOD then "METHOD OF MEASUREMENT HAS CHANGED FROM PREVIOUS ASSESSMENT FOR THIS TUMOR"
	else '' end as er13
	from er9 a left join er13_1 b
	on a.subjid=b.subjid and a.TULNKID=b.TULNKID;
quit;
proc sql;
	create table er14 as
	select a.*, er14 from er13 a left join (select *, 
	"MORE THAN 2 TARGET TUMORS HAVE BEEN REPORTED IN THE SAME ORGAN" as er14 
	from (select subjid, TRSPID,TULNKID, TULOC_TEXT
	from er13
	where substr (TULNKID, 1,1)='T' and TULOC_TEXT ne 'OTHER')
	group by subjid,TRSPID,TULOC_TEXT
	having count (TULOC_TEXT) gt 2) b 
	on a.subjid=b.subjid and a.TRSPID=b.TRSPID and a.TULNKID=b.TULNKID;
quit;

proc sql;
	create table ONC_TU206_RS009_RS018_RS023_V1_ (drop=er1 er2 er3 er4 er5 er6 er7 er8 er9 er10 er11 er12 er13 er14) as
	select distinct a.*, 
	catx (", ",er1,er2,er3,er4,er5,er6,er7,er8,er9,er10,er11,er12,er13,er14,er15) as ERROR_MESSAGE format = $200. label = "ERROR MESSAGE"
	from er14 a left join (select distinct a.subjid,a.OVRLRESP, a.RSDAT,
	b.TULNKID_NEW,c.TUMSTATE_TARGET,d.TUMSTATE_NONTARGET,
	case
	when not missing (b.TULNKID_NEW) and upcase (c.TUMSTATE_TARGET)="ABSENT" and upcase (d.TUMSTATE_NONTARGET)="ABSENT"
	then ""
	else "OVERALL RESPONSE = CR, HOWEVER CR CONDITIONS NOT MET"
	end as er15
	from (select * from rs1001 where OVRLRESP='CR') a left join tu1001 b
	on a.subjid=b.subjid and a.RSSPID=b.TRSPID and 
	a.RSDAT=b.TUDAT left join tu2001 c
	on a.subjid=c.subjid and a.RSSPID=c.TRSPID and 
	a.RSDAT=c.TRDAT left join tu3001 d
	on a.subjid=d.subjid and a.RSSPID=d.TRSPID and 
	a.RSDAT=d.TRDAT) b
	on a.subjid=b.subjid and a.CRF_OVRRESP=b.OVRLRESP and a.RSDAT=b.RSDAT
	order by subjid, TRSPID, TULNKID,TRDAT;
quit;

proc sql;
create table ONC_TU206_RS009_RS018_RS023_V1 as
select distinct (trim(upcase(substr(a.SDYID,8,4)))) as Study format = $4. label = "STUDY", b.SITEMNEMONIC, c.*
from clntrial.IVRSTSA a, site b, ONC_TU206_RS009_RS018_RS023_V1_ c
where c.subjid = b.subjid
order by c.subjid, c.TRSPID, c.TULNKID, c.TRDAT;
quit;


/*Print ONC_TU206_RS009_RS018_RS023_V1*/
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
