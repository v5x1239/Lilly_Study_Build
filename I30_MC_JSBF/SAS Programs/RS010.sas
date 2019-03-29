/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : RS010.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : Check for new Tumors and the Tumor State of the new Tumor is unaquivical then overall reponse should be Progressive Disease.
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
	a.RSPERF, a.RSDAT, a.RSSPID, a.OVRLRESP
from clntrial.RS1001 a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, a.RSSPID, a.RSDAT
; 

create table TU_1 as 
select /*a.merge_datetime,*/ b.SITEMNEMONIC, a.SUBJID, /*a.TULNKID,*/c.TRDAT, c.TRSPID /*c.TUMSTATE_NEW*/
from clntrial.TU1001a a left join clntrial.DM1001c b
on a.SUBJID=b.SUBJID
	left join clntrial.TU1001b c
		on a.SUBJID=c.SUBJID
order by b.SITEMNEMONIC, a.SUBJID, c.TRSPID, c.TRDAT
; 
quit;



proc sql;
create table RS010 as 
select /*a.merge_datetime,*/ a.SITEMNEMONIC, a.SUBJID, a.RSPERF, a.RSDAT, a.RSSPID, 
	a.OVRLRESP, /*b.TULNKID,*/ b.TRDAT, b.TRSPID/*, b.TUMSTATE_NEW*/
from RS a left join TU_1 b
on a.SITEMNEMONIC=b.SITEMNEMONIC and 
	a.SUBJID=b.SUBJID and 
	a.RSSPID=b.TRSPID
where strip(lowcase(a.OVRLRESP))~='progressive disease'/* and 
	strip(lowcase(b.TUMSTATE_NEW))='unequivocal'*/
order by a.SITEMNEMONIC, a.SUBJID, a.RSSPID, a.RSDAT
; quit;

	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print RS010*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
 title1 "Overall Response";
title2 "Check for new Tumors and the Tumor State of the new Tumor is unaquivical then overall reponse should be Progressive Disease.";

  proc print data=RS010 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set RS010 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
