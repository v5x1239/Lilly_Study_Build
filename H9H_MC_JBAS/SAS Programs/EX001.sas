/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX001.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : If "No"  is selected, then no ENTRIES should be collected.
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
data ex001;
	set clntrial.ex1001;
	if page='EX1001_F1' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F16' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F4' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F21' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F27' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F30' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F14' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F22' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F28' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F29' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F3' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F17' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F18' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F23' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F32' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F19' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F11' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F31' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F7' and EXOCCUR = 'N' and (EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F13' and EXOCCUR = 'N' and (EXENDAT ne '' or EXENTIMH ne '' or EXENTIMI ne '' or EXDSAJTP ne '' or EXADJ ne '' or EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXDOSFRQ ne '' or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F25' and EXOCCUR = 'N' and (ECSTDAT ne '' or  ECSTTIMH ne '' or ECSTTIMI ne '' or ECENDAT ne '' or ECENTIM ne '' or ECREASOC ne '' or ECDOSE ne .) then output;
	if page='EX1001_F24' and EXOCCUR = 'N' and (ECSTDAT ne '' or  ECSTTIMH ne '' or ECSTTIMI ne '' or ECENDAT ne '' or ECENTIM ne '' or ECREASOC ne '' or ECDOSE ne .) then output;
	if page='EX1001_F2' and EXOCCUR = 'N' and (EXENDAT ne '' or EXENTIMH ne '' or EXENTIMI ne '' or EXDOSE ne .) then output;
	if page='EX1001_F34' and EXOCCUR = 'N' and (EXENDAT ne '' or EXENTIMH ne '' or EXENTIMI ne '' or EXDOSE ne .) then output;
	if page='EX1001_F6' and EXOCCUR = 'N' and (EXDOSDLY ne '' or EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	if page='EX1001_F15' and EXOCCUR = 'N' and (EXDOSDLY ne '' or EXSTDAT ne '' or EXSTTIMH ne '' or EXSTTIMI ne '' or EXDOSE ne . or EXVMTOCR ne '' ) then output; 
	/*if page='EX1001_F9' and EXOCCUR = 'N' and */
	/*if page='EX1001_F12' and EXOCCUR = 'N' and */
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If "No"  is selected, then no ENTRIES should be collected.";
  proc print data=EX001 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX001 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
