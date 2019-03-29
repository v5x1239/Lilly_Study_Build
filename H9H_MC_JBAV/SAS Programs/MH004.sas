/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : MH004.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : No identical terms with duplicate and overlapping dates can be recorded
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : mh8001_f1
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
data MH004a;
	set clntrial.mh8001;
	if MHSTDATDD = '-99' then std = 1;
	if MHSTDATMO = '-99' then stm = 1;
	if MHSTDATYY ne '' then sty = input (MHSTDATYY, 8.);
	if MHENDATDD = '-99' then end = 30;
	if MHENDATMO = '-99' then enm = 12;
	if MHENDATYY ne '' then eny = input (MHENDATYY, 8.);
	Stdt = mdy (stm, std, sty);
	endt = mdy (enm, end, eny);
	format stdt endt mmddyy10.;
run;
proc sort data = MH004a;
	by subjid mhdecod Stdt;
run;
data MH004b;
	set MH004a;
	by subjid mhdecod Stdt;
	if first.mhdecod and last.mhdecod then delete;
run;
data MH004 (KEEP = subjid mhdecod Stdt endt prev_edt);
	set MH004b;
	by subjid mhdecod Stdt;
	prev_edt=lag(endt);

    if first.mhdecod then do;
		prev_edt= .; 
	end;
	if Stdt lt prev_edt;
run;


/*Print AA001*/ * Replace AA001 with report name;
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
