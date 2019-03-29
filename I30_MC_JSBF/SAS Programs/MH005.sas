/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH005.sas
PROJECT NAME (required)           : I3O_MC_JSBF
DESCRIPTION (required)            : If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, a change of CTCAE grade must be recorded or event must become serious
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

data ae4;
set clntrial.AE4001a;
keep /*merge_datetime*/ SUBJID AETERM AEDECOD;
run;
data ae3;
*set clntrial.AE3001b;
*keep merge_datetime SUBJID AETERM AETOXGR;
*run;
data mh;
set clntrial.mh8001;
keep /*merge_datetime*/ SUBJID MHSPID MHTERM MHDECOD MHSTDAT MHONGO MHENDAT MHTOXGR;
run;
data MH005 (KEEP=/*merge_datetime*/ SUBJID AETERM AEDECOD /*AETOXGR*/ MHSPID MHTERM MHDECOD MHSTDAT MHONGO MHENDAT MHTOXGR);
	merge mh (in=a) ae4 (in=b) ;
	by SUBJID;
	if a and b;
/*	if datepart(MERGE_DATETIME) > input("&date",Date9.);*/
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print MH005*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Reported Event Term";
  title2 "If medical history disease/condition is ongoing, and identical term is recorded on AE CRF, a change of CTCAE grade must be recorded or event must become serious";

  proc print data=MH005 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH005 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
