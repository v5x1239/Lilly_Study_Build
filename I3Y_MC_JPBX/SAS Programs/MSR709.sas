/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MSR709.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Significant patient assessment or management issues
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
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

/*Add code here*/
proc sql;
	create table MSR709 as
	select distinct a.MERGE_DATETIME, a.SUBJID, a.BLOCKID, a.visdat, a.BLOCKRPT, a.page, b.VSDAT,
	case 
	when not missing (a.visdat) and not missing (VSDAT) then datepart (VSDAT)-datepart (a.visdat)  
	else . end as Diff_vits,
	c.EGDAT,
	case 
	when not missing (a.visdat) and not missing (EGDAT) then datepart (EGDAT)-datepart (a.visdat)  
	else . end as Diff_ecg,
	d.ECGPSDT,
	case 
	when not missing (a.visdat) and not missing (ECGPSDT) then datepart (ECGPSDT)-datepart (a.visdat)  
	else . end as Diff_ecog,
	e.MDALSTD,
	case 
	when not missing (a.visdat) and not missing (MDALSTD) then datepart (MDALSTD)-datepart (a.visdat)  
	else . end as Diff_MDA,
	f.EQ5D5DT,
	case 
	when not missing (a.visdat) and not missing (EQ5D5DT) then datepart (EQ5D5DT)-datepart (a.visdat)  
	else . end as Diff_EQ5,
	g.RSDAT,
	case 
	when not missing (a.visdat) and not missing (RSDAT) then datepart (RSDAT)-datepart (a.visdat)  
	else . end as Diff_RS,
	h.SSDAT,
	case 
	when not missing (a.visdat) and not missing (SSDAT) then datepart (SSDAT)-datepart (a.visdat)  
	else . end as Diff_SS
	from (select * from clntrial.SV1001_D where blockid='801') a left join clntrial.VS1001 b
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join clntrial.EG3001 c
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join clntrial.ECOG1001 d
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join clntrial.MDALC100 e
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join clntrial.EQ5D5L10 f
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join clntrial.RS1001 g
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID left join clntrial.SS1001 h
	on a.SUBJID=b.SUBJID and a.BLOCKID=b.BLOCKID
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.)
	order by SUBJID;
quit;



/*Print MSR709*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Significant patient assessment or management issues";


  proc print data=MSR709 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MSR709 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




