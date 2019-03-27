/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS700.sas
PROJECT NAME (required)           : H8A_MC_LZBE
DESCRIPTION (required)            : 
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

*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=H8A_MC_LZBE;

/*Prem, use the _all version of the raw dataset for programming*/

data dm;
	set clntrial.DM1001c;
	keep SITEMNEMONIC SUBJID;
run;
proc sort;
	by subjid;
run;
Data ds1;
	set clntrial.DS1001;
	if page eq 'DS1001_LF4';
	keep subjid DSSTDAT;
run;
proc sort;
	by subjid;
run;
Data ds2;
	set clntrial.DS1001;
	if page eq 'DS1001_LF5';
	keep subjid DSSTDAT;
run;
proc sort;
	by subjid;
run;
Data ds3;
	set clntrial.DS1001;
	if page eq 'DS1001_LF7';
	keep subjid DSSTDAT;
run;
proc sort;
	by subjid;
run;
Data ds4;
	set clntrial.DS1001;
	if page eq 'DS1001_LF8';
	keep subjid DSSTDAT;
run;
proc sort;
	by subjid;
run;
Data ds;
	set ds1 ds2 ds3 ds4;
	Disposition_Date = datepart(DSSTDAT);
	format Disposition_Date date9.;
run;
proc sort;
	by subjid;
run;
%macro dt(dsn,set,var);
data &dsn.;
length variable $20.;
	set clntrial.&set.;
	date = datepart(&var.);
	format date date9.;
	variable = "&var.";
	keep subjid date page variable;
run;
proc sort;
	by subjid;
run;
%mend;

%dt(_1_,SV1001,VISDAT);
%dt(_2_,DS2001,DSSTDAT);
%dt(_3_,DS2001,DTHDAT);
%dt(_4_,DS1001,DTHDAT);
/*%dt(_5_,MH7001,MHSTDAT);*/
/*%dt(_6_,MH7001,MHENDAT);*/
/*%dt(_7_,SU3001,SUENDAT);*/
%dt(_8_,VS1001,VSDAT);
%dt(_9_,EX1001,EXSTDAT);
%dt(_10_,EX1001,EXENDAT);
%dt(_11_,RUDF1001,RUDFPRES5DAT);
%dt(_12_,AE3001B,AESTDAT);
%dt(_13_,AE3001B,AEENDAT);
%dt(_14_,CM3001,CMSTDAT);
%dt(_15_,CM3001,CMENDAT);
/*%dt(_16_,MHPRESP1001,MHSTDAT);*/
/*%dt(_17_,MHPRESP1001,MHENDAT);*/
/*%dt(_18_,MHPRESP1001,MHDXDAT);*/
%dt(_19_,CSS4001,CSS0423A);
%dt(_20_,CSS2001,CSS0222A);
%dt(_21_,SFUQ3001,CESTDAT);
%dt(_22_,SFUQ3001,CEENDAT);
/*%dt(_23_,AJARR2001,AJAEDAT);*/
/*%dt(_24_,AJCEV2001,AJAEDAT);*/
/*%dt(_25_,AJCGS2001,AJAEDAT);*/
/*%dt(_26_,AJCIE3001,AJAEDAT);*/
/*%dt(_27_,AJCRV3001,AJAEDAT);*/
/*%dt(_28_,AJDTH2001,AJAEDAT);*/
/*%dt(_29_,AJHSPHF3001,AJAEDAT);*/
/*%dt(_30_,AJHTN2001,AJAEDAT);*/
/*%dt(_31_,AJRSSD2001,AJAEDAT);*/
/*%dt(_32_,AJSYN2001,AJAEDAT);*/
/*%dt(_33_,BR1001,BRDAT);*/
/*%dt(_34_,EPCEV2001,CEVR4DAT);*/
/*%dt(_35_,AJARR2001,EPAEDAT);*/
/*%dt(_36_,AJCEV2001,EPAEDAT);*/
/*%dt(_37_,AJCGS2001,EPAEDAT);*/
/*%dt(_38_,AJCIE3001,EPAEDAT);*/
/*%dt(_39_,AJCRV3001,EPAEDAT);*/
/*%dt(_40_,AJHSPHF3001,EPAEDAT);*/
/*%dt(_41_,AJHTN2001,EPAEDAT);*/
/*%dt(_42_,AJRSSD2001,EPAEDAT);*/
/*%dt(_43_,EPARR2001,EPAEDAT);*/
/*%dt(_44_,EPCEV2001,EPAEDAT);*/
/*%dt(_45_,EPCGS2001,EPAEDAT);*/
/*%dt(_46_,EPCIE3001,EPAEDAT);*/
/*%dt(_47_,EPCRV3001,EPAEDAT);*/
/*%dt(_48_,EPDTH2001,EPAEDAT);*/
/*%dt(_49_,EPHSPHF3001,EPAEDAT);*/
/*%dt(_50_,EPHTN2001,EPAEDAT);*/
/*%dt(_51_,EPRSSD2001,EPAEDAT);*/
/*%dt(_52_,EPSYN2001,EPAEDAT);*/
%dt(_53_,HRFA1001,HRFAASMDAT);
%dt(_54_,HRFA1001,HRFAEXPDAT);
%dt(_55_,HRFA1001,HRFAPN_STENDAT);
%dt(_56_,HRFA1001,HRFAPNENDAT);
%dt(_57_,HRFA1001,HRFAPNSTDAT);
%dt(_58_,HRFA1001,HRFATRFDAT);
%dt(_59_,LRSS1001,LRSSASMDAT);
%dt(_60_,HMPR1001,PRSTDAT);
%dt(_61_,SAE2001a,SAEASMDAT);
%dt(_62_,SAE2001a,SAEAWADAT);
%dt(_63_,Sae2001b,SAEFUASMDAT);
%dt(_64_,Sae2001b,SAEFUAWADAT);

data all;
	set _1_ _2_ _3_ _4_ /*_5_ _6_ _7_*/ _8_ _9_ _10_ _11_ _12_ _13_ _14_ _15_
	/*_16_ _17_ _18_*/ _19_ _20_ _21_ _22_ /*_23_ _24_ _25_ _26_ _27_ _28_ _29_
	_30_ _31_ _32_ _33_ _34_ _35_ _36_ _37_ _38_ _39_ _40_ _41_ _42_ _43_
	_44_ _45_ _46_ _47_ _48_ _49_ _50_ _51_ _52_*/ _53_ _54_ _55_ _56_ _57_
	_58_ _59_ _60_ _61_ _62_ _63_ _64_;
run;
proc sort;
	by subjid;
run;
data fin;
	merge ds(in = a) all dm;
	by subjid;
	if a;
run;
data DS700;
	retain /*MERGE_DATETIME*/ SITEMNEMONIC SUBJID Disposition_Date date page variable;
	set fin;
	*where datepart(MERGE_DATETIME) > input("&date", ? Date9.);
	if Disposition_Date ne . and date ne . and date gt Disposition_Date;
	keep /*MERGE_DATETIME*/ SITEMNEMONIC SUBJID Disposition_Date date page variable;
run;
	
/*Prem, keep the below code handy, this is the ouptut piece in JReview.*/

/*Print DS700*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
title1 "Disposition forms";
title2 "Dates on rest of CRF must not be after the date of disposition.";
  proc print data=DS700 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS700 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
