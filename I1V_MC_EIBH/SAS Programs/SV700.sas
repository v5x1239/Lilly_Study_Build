/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SV700.sas
PROJECT NAME (required)           : EIBH
DESCRIPTION (required)            : Ensure subject visits have been entered as expected
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IVRS
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

data ds1001 (keep=subjid sfblock);
	set clntrial.DS1001;
	if DSDECOD='SCREEN FAILURE';
	sfblock=blockid;
run;
proc sort data=ds1001;
	by subjid;
run;
proc sort data=clntrial.sv1001 (KEEP=subjid blockid) out=sv;
	by subjid;
run;

data SV700a (KEEP=subjid message);
	merge ds1001 (in=a) sv (in=b);
	by subjid;
	if a and b;
	if sfblock='1' and blockid in ('2', '3','4','5','6','7','8','9','10')
		then message='Subject is Screen failed, but subsequent visits/cycles exist';
		else if sfblock='3' and blockid in ('4','5','6','7','8','9','10')
		then message='Subject is Screen failed, but subsequent visits/cycles exist';
	if message ne '';
	
data SV700b (KEEP=subjid message dsdecod);
	set clntrial.DS1001 (where= (page ='DS1001_F4'));
	if dsdecod ne '';
	message='Subject discontinued from study treatment';
run;

data sv700c (KEEP=subjid message);
	set clntrial.sv1001;
	if VISITNUM eq . and UNVISITNUM eq . and VISITOCCUR eq '' and VISDAT eq '';
	message='Expected visit is not completed';
run;
data sv700;
	set sv700a sv700b sv700c;
run;

proc sort data=sv700;
	by subjid;
run;

	

proc sort data=SV700 noduprecs;
by subjid;
run;


/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure subject visits have been entered as expected";

  proc print data=SV700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SV700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
