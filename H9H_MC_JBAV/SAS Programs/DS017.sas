/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : DS017.sas
PROJECT NAME (required)           : I1R_MC_JBAV
DESCRIPTION (required)            : If status is Lost to follow-up, dates on rest of CRF must not be after the date of disposition
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CM
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code
2.0  Joe Cooney	   Updated for JBAV new panels/dates/etc

/***********************************************************************/
/*************                Setup Section               **************/
/***********************************************************************/

/*****************************DS017**************************************/

data DS017(keep=subjid DSSTDAT_ dsdecod);
format DSSTDAT_ date9.;
set clntrial.ds1001; 
where dsdecod = "LOST TO FOLLOW-UP";
if DSSTDATMO = '-99' then DSSTDATMO = "01";
if DSSTDATDD = '-99' then DSSTDATDD = "01";
DSSTDAT_=mdy(DSSTDATMO,DSSTDATDD,DSSTDATY);
label DSSTDAT_ = "Date of Disposition";
proc sort nodup; by subjid; run;

%macro gt_ds_date(dsn, page, day, month, year, date, label, date_type);

data &dsn.(keep=subjid &date.);
format &date. date9.;
set clntrial.&dsn.;
where page = "&page.";
date_type = "&date_type.";
if date_type = "OTHER" then do;
 	if &month. = '-99' then &month. = "7";
  	if &day. = '-99' then &day. = "15";
end;
	else if date_type = "START" then do;
		if &month. = '-99' then &month. = "1";
		if &day. = '-99' then &day. = "1";
	end;
		else if date_type = "END" then do;
			if &month. = '-99' then &month. = "12";
			if &day. = '-99' then do;
				if &month. = "2" then &day. = "28";
					else &day. = "30";
			end;
		end;

&date.=mdy(&month.,&day.,&year.);
label &date. = "&label.";
if &date. = . then delete;
drop date_type;
proc sort nodup; by subjid; run;

data DS017;
retain subjid DSSTDAT_ dsdecod;
merge DS017(in=a) &dsn.(in=b);
by subjid;
if a and DSSTDAT_ < &date.;
run;

%mend;

%gt_ds_date(MH8001, MH8001_F1, MHSTDATDD, MHSTDATMO, MHSTDATY, MHSTDAT_, MH Start Date, START); 

%gt_ds_date(MH8001, MH8001_F1, MHENDATDD, MHENDATMO, MHENDATY, MHENDAT, MH End Date, END); 

%gt_ds_date(IRAD2001, IRAD2001_F1, IRADSTDATDD, IRADSTDATMO, IRADSTDATY, IRADSTDAT, IRAD Start Date, START); 

%gt_ds_date(IRAD2001, IRAD2001_F1, IRADENDATDD, IRADENDATMO, IRADENDATY, IRADENDAT, IRAD End Date, END); 

%gt_ds_date(SYST2001, SYST2001_F1, SYSTSTDATDD, SYSTSTDATMO, SYSTSTDATY, SYSTSTDAT_F1, SYST_F1 Start Date, START); 

%gt_ds_date(SYST2001, SYST2001_F1, SYSTENDATDD, SYSTENDATMO, SYSTENDATY, SYSTENDAT_F1, SYST_F1 End Date, END); 

%gt_ds_date(SYST2001, SYST2001_F2, SYSTSTDATDD, SYSTSTDATMO, SYSTSTDATY, SYSTSTDAT_F2, SYST_F2 Start Date, START); 

%gt_ds_date(SYST2001, SYST2001_F2, SYSTENDATDD, SYSTENDATMO, SYSTENDATY, SYSTENDAT_F2, SYST_F2 End Date, END); 

%gt_ds_date(DS1001, DS1001_F1, DTHDATDD, DTHDATMO, DTHDATYY, DTHDAT, Date of Death, OTHER); 

%gt_ds_date(SS1001, SS1001_F1, DTHDATDD, DTHDATMO, DTHDATYY, DTHDAT_SS1001, Date of Death_SS1001, OTHER); 

/***********************************************************************/
/*************              Output Section           **************/
/***********************************************************************/

/*Print DS017*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "If Status = LTFU, then remaining dates must be LT DSSTDAT";
  proc print data=DS017 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set DS017 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
