/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX014.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : Start date must be after end date of previous chronologic entry with same treatment name
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
data EX014a;
	set clntrial.ex1001;
	if page in ('EX1001_F7', 'EX1001_F13', 'EX1001_F25', 'EX1001_F24', 'EX1001_F9', 'EX1001_F12');
run;

proc sql;
create table EX014 as
select *, count(*) as Count
from EX014a
group by subjid, blockid, page, EXTRT, EXSTDAT
having count(*) > 1;
quit;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Start date must be after end date of previous chronologic entry with same treatment name";
  proc print data=EX014 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX014 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
