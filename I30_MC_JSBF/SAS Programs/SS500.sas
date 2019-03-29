/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SS500.sas
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
	create table DS as 
	select /*a.merge_datetime,*/ a.SUBJID, 
	a.BLOCKID, a.DSDECOD
	from clntrial.DS1001 a left join clntrial.ss1001 b
	on a.SUBJID=b.SUBJID
	order by a.SUBJID; 
quit;



proc sql;
create table SS500 as 
select /*merge_datetime,*/ SUBJID, BLOCKID, DSDECOD
from DS 
where /*datepart(a.MERGE_DATETIME) > input("&date", ? Date9.) and */strip(lowcase(DSDECOD)) not in('lost to follow up', 'death','withdrawal')
order by SUBJID;
quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print SS500*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Follow up";
title2 "If a patient discontinues from study treatment for a reason other than Lost, Death or Withdrawal  they should go into short-term follow-up and then into long-term follow-up.";
  proc print data=SS500 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SS500 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
