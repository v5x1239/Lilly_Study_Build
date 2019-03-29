/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : EX002.sas
PROJECT NAME (required)           : H9H-MC-JBAV
DESCRIPTION (required)            : If 'YES' is selected, then there should be at least one ENTRY collected
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
data EX002;
	set clntrial.ex1001;
	if page='EX1001_F1' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F16' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F4' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F21' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F27' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F30' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F14' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F22' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F28' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F29' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F3' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F17' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F18' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F23' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F32' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F19' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F11' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F31' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F7' and EXOCCUR = 'Y' and (EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F13' and EXOCCUR = 'Y' and (EXENDAT eq '' or EXENTIMH eq '' or EXENTIMI eq '' or EXDSAJTP eq '' or EXADJ eq '' or EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXDOSFRQ eq '' or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F25' and EXOCCUR = 'Y' and (ECSTDAT eq '' or  ECSTTIMH eq '' or ECSTTIMI eq '' or ECENDAT eq '' or ECENTIM eq '' or ECREASOC eq '' or ECDOSE eq .) then output;
	if page='EX1001_F24' and EXOCCUR = 'Y' and (ECSTDAT eq '' or  ECSTTIMH eq '' or ECSTTIMI eq '' or ECENDAT eq '' or ECENTIM eq '' or ECREASOC eq '' or ECDOSE eq .) then output;
	if page='EX1001_F2' and EXOCCUR = 'Y' and (EXENDAT eq '' or EXENTIMH eq '' or EXENTIMI eq '' or EXDOSE eq .) then output;
	if page='EX1001_F34' and EXOCCUR = 'Y' and (EXENDAT eq '' or EXENTIMH eq '' or EXENTIMI eq '' or EXDOSE eq .) then output;
	if page='EX1001_F6' and EXOCCUR = 'Y' and (EXDOSDLY eq '' or EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	if page='EX1001_F15' and EXOCCUR = 'Y' and (EXDOSDLY eq '' or EXSTDAT eq '' or EXSTTIMH eq '' or EXSTTIMI eq '' or EXDOSE eq . or EXVMTOCR eq '' ) then output; 
	/*if page='EX1001_F9' and EXOCCUR = 'Y' and */
	/*if page='EX1001_F12' and EXOCCUR = 'Y' and */
run;



/*Print AA001*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "If 'YES' is selected, then there should be at least one ENTRY collected";
  proc print data=EX002 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set EX002 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
