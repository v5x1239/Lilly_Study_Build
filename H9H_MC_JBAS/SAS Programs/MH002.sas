/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH002.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : If Yes is selected, then past and/or concomitant diseases or  past surgeries need to be recorded.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : MH8001
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
/*MH002*/

/*Add code here*/

data mh1 (KEEP = SUBJID page MHYN)
	 mh2 (KEEP = SUBJID MHSPID MHTERM MHSTDAT);
	set clntrial.MH8001;
	if MHYN ne '' then output mh1;
	if MHYN eq '' then output mh2;
run;

proc sql;
	create table mh as
	select a.subjid, a.page, a.MHyn, b.mhspid, b.mhterm, b.MHSTDAT
	from mh1 as a, mh2 as b
	where a.subjid=b.subjid;
quit;

data MH002;
	set mh;
	if mhYN = 'Y' and mhterm eq '';
run;



/*Print MH002*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Yes is selected, then past and/or concomitant diseases or  past surgeries need to be recorded.";
  proc print data=MH002 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH002 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
