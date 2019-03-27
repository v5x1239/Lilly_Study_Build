/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : HO503.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Ensure AE referenced as reason for hospitalization has onset date < discharge date and end dates > admission date.
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
proc sort data= clntrial.HO2001_D  out=HO;
	by SUBJID HOSPID HOSTDAT HOENDAT;
run;

data ho1;
	set ho;
	by SUBJID HOSPID HOSTDAT HOENDAT;
	prev_st = lag (HOSTDAT);
	prev_en = lag (HOENDAT);
	if first.SUBJID then do;
		prev_st=.;
		prev_en=.;
	end;	
run;
proc sql;
	create table HO503  as
	select distinct a.SUBJID,a.blockid, a.page, HOSPID, HOSTDAT, HOONGO, HOENDAT, REASHCS, AEGRPID_RELREC, HOCAT, AETERM, AESTDAT, 
	case
	when not missing (HOSTDAT) and not missing (AESTDAT) and AESTDAT gt HOSTDAT then 'Adverse event start date is greater than Hospitalization event start date'
	else '' end as flag 
	from clntrial.HO2001_D a left join clntrial.AE_DUMP b
	on a.subjid=b.subjid and a.AEGRPID_RELREC=b.AEGRPID
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.) and not missing (HOSPID)
	order by SUBJID;
quit;



/*Print HO503*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure AE referenced as reason for hospitalization has onset";
title2 "date < discharge date and end dates > admission date.";


  proc print data=HO503 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set HO503 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




