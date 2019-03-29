/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
PROJECT NAME (required)           : H9H-MC-JBAS
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded
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
/*MH004*/

/*Add code here*/

proc sql;
	create table mh1 as
	select *, count(*) as Count
	from clntrial.MH8001
	group by SUBJID, MHTERM
	having count > 1;
quit;

proc sort data=mh1 (keep = SUBJID MHSPID MHTERM MHSTDAT MHENDAT);
	by SUBJID MHTERM MHSTDAT;
run;

data mh2;
	set mh1;
	by SUBJID MHTERM MHSTDAT;
	prev_en =lag(MHENDAT);
	if first.mhterm then prev_en= .;
	if MHSTDAT lt prev_en or prev_en eq . then
		flag = 'Overlapping';
run;

proc sort data= mh2;
	by SUBJID MHTERM MHSTDAT descending flag;
run;

data MH004;
	set mh2;
	by SUBJID MHTERM MHSTDAT descending flag;
	prevyy = lag(flag);
	if first.subjid then prevyy='';
	if flag ne '' or prevyy ne '';
run;

proc sort data=MH004;
	by SUBJID MHSPID MHTERM MHSTDAT;
run;

	


/*Print MH004*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "No identical terms with duplicate and overlapping dates can be recorded";
  proc print data=MH004 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set MH004 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
