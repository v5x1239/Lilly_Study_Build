/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS022.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Ensure "assessment number within visit" are sequential for multiple assessments performed.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Premkumar        Original version of the code


/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*Prem, use the below libame statment to call in the Clintrial raw datasets.*/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I3O_MC_JSBF;*/


/*Prem, use the _all version of the raw dataset for programming*/
proc sql;
create table RS as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, 
	a.RSPERF, a.RSDAT, a.RSSPID/*, a.TRGRESP*/
from clntrial.RS1001 a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, a.RSSPID, a.RSDAT
; 

create table TU_2 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID/*, a.TULNKID, 
	a.TRSPID, a.TRDAT, a.TUMSTATE, a.TUMSTATE_TARGET, a.TRSTRESC*/
from clntrial.TU2001a a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
	left join clntrial.TU2001b c
		on a.SUBJID=c.SUBJID
order by b.SITEMNEMONIC, a.SUBJID/*, a.TRSPID, a.TRDAT*/
; 
quit;



proc sql;
create table RS022 as 
select /*a.merge_datetime,*/ a.SITEMNEMONIC, a.SUBJID, a.RSPERF, a.RSDAT, a.RSSPID/*, 
	a.TRGRESP, b.TULNKID, b.TRSPID, b.TRDAT, b.TUMSTATE_TARGET, b.TRSTRESC*/
from RS a left join TU_2 b
on a.SITEMNEMONIC=b.SITEMNEMONIC and 
	a.SUBJID=b.SUBJID/* and 
	a.RSSPID=b.TRSPID*/
/*where strip(lowcase(b.TRGRESP)) not in('not evaluable' 'not all evaluated') and 
	(strip(lowcase(b.TUMSTATE_TARGET))~='not assessable' or 
		strip(lowcase(TRSTRESC))~='not measured')*/
order by a.SITEMNEMONIC, a.SUBJID, a.RSSPID, a.RSDAT
; quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print RS022*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Target Response";
title2 "If Target response is Not Evaluable or Not All Evaluated, ensure that one or more target tumors have a tumor state of not assessable or a result of not measured.";
  proc print data=RS022 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS022 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
