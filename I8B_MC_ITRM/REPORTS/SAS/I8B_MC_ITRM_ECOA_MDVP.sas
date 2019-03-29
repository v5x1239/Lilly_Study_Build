
/********************************* Pre-compile standard macros ********************************/

options mautosource sasautos = ("\\dub-filer-02\sas_icr_dm_eu\library\prod\global_macro\macros");

%initialise_log;				/* Clears log screen and prints sysver, syshostname, sysuserid, start_date and start_time */

/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : I8B-MC-ITRM_ECOA_HEADER.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Program ECOA HEADER FILE.
SPECIFICATIONS (required)         : DEV Ticket
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : \\IX1LECFS02.rf.lilly.com\icon.grp\DS_END\219268_I8B-MC-ITRM\ecoa\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code


**************************************** End of Header ******************************************/

/************************* Start of environment/input/output programming ************************/

options nofmterr;

/* Study context parameters */
%let sponsor_name 		= Lilly;					        	/* Sponsor name 		- (optional) 									*/
%let output_description	= MDVP_LISTINGS;					/* Output descruiption 	- (optional) 									*/
%let prot 				= I8B_MC_ITRM;								/* Icon study code 					 									*/
%let study_path 		= \\IX1LECFS02.rf.lilly.com\icon.grp\DS_END\219268_I8B-MC-ITRM;			/* Icon root path 					 									*/

%let ecoa=&study_path.\ECOA;

/************************** End of environment/input/output programming *************************/

/* Output location parameters */
%let output_location 	= &study_path\Listings\Output;			/* Output file location, if applicable 	*/
%let output_file_name 	= &prot._MDVP_LISTINGS;		/* Output file name, if applicable 		*/

/* Log output parameters */
%let write_log_to_file 	= YES;												/* Set to YES when log should be spooled to output file. */
%let log_folder 		= &study_path\Listings\Logs;		/* Location for log file */
%let output_log_name 	= &output_file_name;					/* Log file name */

/***************************** Start of study-specific programming ******************************/

libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;

libname ecoa "&ecoa." access=readonly;
libname output "&study_path.\listings\output";
/****************************** End of study-specific programming ******************************/

/********************************* Start of output programming *********************************/

/*Header file creation*/

data HEADER(keep=SUBJECT SITECODE VISIT VISITNUM ECOAASMDT SUBJID BLOCKID);
retain SUBJECT SITECODE VISIT VISITNUM ECOAASMDT SUBJID BLOCKID;
format SUBJID z4. BLOCKID $50.;
set ecoa.Bg2001	
	ecoa.Cm1001
	ecoa.Eq5d5l2001
	ecoa.Ex1001
	ecoa.Hypo1001
	ecoa.Itsq2001
	ecoa.Ml1001
	ecoa.Ml3001
	ecoa.Pde1001
	ecoa.Wpai2001;
SUBJID = input(scan(subject,2,"-"),4.);
BLOCKID = compress(put(VISITNUM, 8.));
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
if excat = "EXPOSURES RELATIVE TO MIXED MEAL TOLERANCE TEST" then delete;
proc sort nodupkey; by _all_; run;
proc sort; by SUBJID; run; 

data DS1001(keep=SUBJID discon_flag discon_visit DSSTDAT);
set clntrial.ds1001_all;
discon_flag = 'Y';
if coalesce(DSSTDATMO,DSSTDATDD,DSSTDATYY) ne '' then
DSSTDAT = mdy(DSSTDATMO,DSSTDATDD,DSSTDATYY);
format DSSTDAT date9.;
DSSCAT = 'STUDY DISPOSITION';
discon_visit = blockid;
proc sort; by SUBJID; run;

data header output.&prot._ECOA_HEADER;
merge header(in=a) DS1001;
by SUBJID;
if a;
run;

/*End of header file creation*/

/*eCOA001*/
/*Check site/subject numbers in eCOA datasets against inform*/

proc sort nodupkey data=header out=header001; by SUBJID sitecode; run;

proc sql;
create table svsite as
select distinct sv.SUBJID, st.SITEMNEMONIC, st.SITEMNEMONIC as sitecode length=19,
stat.stat
from clntrial.inf_subject sb, clntrial.inf_site_all st, clntrial.SV1001_all sv, clntrial.statgut_all stat
where sb.SITEGUID=st.CT_RECID and sv.subject_id=sb.subject_id and sv.subjid = stat.subjid and 
sv.blockid = stat.blockid and stat.blockid = '2' and stat.stat = '100'
order by SUBJID, SITEMNEMONIC;
quit;

data eCOA001a(keep=SUBJECT SITECODE FLAG) eCOA001b(keep=SUBJID SITEMNEMONIC FLAG);
format FLAG $200.;
merge header001(in=a) svsite(in=b);
by SUBJID sitecode;
if a and not b then do;
	FLAG = 'In Header, not in InForm';
	output eCOA001a;
end;
if b and not a then do;
	FLAG = 'In Inform, not in Header';
	output eCOA001b;
end;
run;

data eCOA001;
set eCOA001a eCOA001b;
run;

/*eCOA002*/
/*check that MMTT date is 0-4 days prior to corresponding visit*/

data ecoa_ex1001(keep=SUBJECT SITECODE VISITNUM EXCAT ECOAASMDT SUBJID BLOCKID);
format SUBJID z4. BLOCKID $50.;
set ecoa.ex1001;
where visitnum ne . and ECOAASMDT ne '' and EXCAT = 'EXPOSURES RELATIVE TO MIXED MEAL TOLERANCE TEST';
SUBJID = input(scan(subject,2,"-"),4.);
BLOCKID = compress(put(VISITNUM, 8.));
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
proc sort; by SUBJID BLOCKID; run;

data sv1001(keep=SUBJID BLOCKID VISDAT);
set clntrial.sv1001_all;
if coalesce(VISDATYY, VISDATMO, VISDATDD) ne '' then 
VISDAT = mdy(VISDATMO,VISDATDD,VISDATYY);
format VISDAT date9.;
proc sort; by SUBJID BLOCKID; run;

data eCOA002(keep=SITECODE SUBJECT VISITNUM EXCAT ECOAASMDT BLOCKID VISDAT);
retain SITECODE SUBJECT VISITNUM EXCAT ECOAASMDT BLOCKID VISDAT;
merge ecoa_ex1001(in=a) sv1001(in=b);
by SUBJID BLOCKID;
if a and b and (ECOAASMDT > VISDAT or ECOAASMDT < VISDAT -4);
run;

/*eCOA003*/
/*check that V8 MMTT is prior to randomization date*/

data eCOA003(keep=SITECODE SUBJECT VISITNUM EXCAT ECOAASMDT BLOCKID VISDAT);
retain SITECODE SUBJECT VISITNUM EXCAT ECOAASMDT BLOCKID VISDAT;
merge ecoa_ex1001(in=a) sv1001(in=b);
by SUBJID BLOCKID;
if a and b and BLOCKID = '8' and (ECOAASMDT > VISDAT or ECOAASMDT = .);
run;

/*eCOA004*/
/*check that visit dates for all datasets with visit variable match corresponding visit in Inform*/

proc sort data=header out=header004; by SUBJID BLOCKID; run;

data eCOA004(keep=SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT);
retain SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT;
merge header004(in=a) sv1001(in=b);
by SUBJID BLOCKID;
if a and b and ECOAASMDT ne VISDAT;
run;

/*eCOA005*/
/*eCOA data exists with date after V2 date in Inform if subject is continuing at V2 in Inform*/

proc sort data=header out=header005_; by SUBJID ECOAASMDT; where ECOAASMDT ne .; run;

data header005(keep=SITECODE SUBJECT SUBJID max_ECOAASMDT);
format max_ECOAASMDT date9.;
set header005_;
by subjid;
if not last.subjid then delete;
max_ECOAASMDT = ECOAASMDT;
run;

data header005_sv;
merge header005(in=a) sv1001(in=b);
by subjid;
if a and b and blockid = '2';
proc sort; by subjid blockid; run;

data statgut2(keep=SUBJID blockid stat);
set clntrial.statgut_all;
where stat = '100' and blockid = '2';
proc sort; by subjid blockid; run;

data ECOA005(keep = SITECODE SUBJECT BLOCKID STAT VISDAT max_ECOAASMDT);
retain SITECODE SUBJECT BLOCKID STAT VISDAT max_ECOAASMDT;
merge header005_sv(in=a) statgut2(in=b);
by subjid blockid;
if a and b and max_ECOAASMDT < VISDAT;
run;

/*eCOA006*/
/*eCOA data exists with date after V8 date in Inform if subject is continuing at V8 in Inform*/

data header006_sv;
merge header005(in=a) sv1001(in=b);
by subjid;
if a and b and blockid = '8';
proc sort; by subjid blockid; run;

data statgut8(keep=SUBJID blockid stat);
set clntrial.statgut_all;
where stat = '100' and blockid = '2';
proc sort; by subjid blockid; run;

data ECOA006(keep = SITECODE SUBJECT BLOCKID STAT VISDAT max_ECOAASMDT);
retain SITECODE SUBJECT BLOCKID STAT VISDAT max_ECOAASMDT;
merge header006_sv(in=a) statgut8(in=b);
by subjid blockid;
if a and b and max_ECOAASMDT > VISDAT;
run;

/*eCOA007*/
/*If subject discontinued prior to V801, no dates present in eCOA data are after subject study disposition. */

data header007_(keep=SUBJECT SUBJID max_ECOAASMDT);
set header005;
run;

data header007(drop=blockid);
merge header(in=a) header007_;
by SUBJID;
if a;
run;

data ECOA007(keep=SITECODE SUBJECT DISCON_VISIT DSSTDAT max_ECOAASMDT);
retain SITECODE SUBJECT DISCON_VISIT DSSTDAT max_ECOAASMDT;
set header007;
where (discon_visit ne '' and input(discon_visit, ?8.) < 801) and (DSSTDAT ne . and max_ECOAASMDT > DSSTDAT);
run;

/*eCOA008*/
/*If subject not discontinued at V801, no dates present in eCOA data are after V801. */

data sv1001_008;
set sv1001;
where BLOCKID = '801';
run;

data header008_;
set header007;
where input(discon_visit, ?8.) >= 801;
BLOCKID = discon_visit;
proc sort; by subjid blockid; run;

data header008;
merge header008_(in=a) sv1001_008(in=b);
by subjid;
if a and b and max_ECOAASMDT > VISDAT;
run;

data ECOA008(keep=SITECODE SUBJECT DISCON_VISIT DSSTDAT VISDAT max_ECOAASMDT);
retain SITECODE SUBJECT DISCON_VISIT DSSTDAT VISDAT max_ECOAASMDT;
set header008;
run;

/*eCOA009*/
/*No dates present in eCOA data between Informed Consent and V2 in Inform.*/

data sv1001_009;
set sv1001;
where BLOCKID = '2' and VISDAT ne .;
SV_BLOCKID = BLOCKID;
drop blockid;
run;

data ds2001(keep=SUBJID DS_BLOCKID DSSTDAT_IC);
set clntrial.ds2001_all;
if coalesce(DSSTDAT_ICMO,DSSTDAT_ICDD,DSSTDAT_ICYY) ne '' then
DSSTDAT_IC = mdy(DSSTDAT_ICMO,DSSTDAT_ICDD,DSSTDAT_ICYY);
format DSSTDAT_IC date9.;
DS_BLOCKID = BLOCKID;
if DSSTDAT_IC = . then delete;
proc sort; by subjid; run;

data header009;
merge header(in=a) sv1001_009(in=b) ds2001(in=c);
by subjid;
if a and ECOAASMDT > DSSTDAT_IC and ECOAASMDT < VISDAT;
run;

data eCOA009(keep=SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC SV_BLOCKID VISDAT);
retain SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC SV_BLOCKID VISDAT;
set header009;
run;

/*eCOA010*/
/*No dates present in eCOA data prior to Informed Consent.*/

data header010;
merge header(in=a) ds2001(in=c);
by subjid;
if a and ECOAASMDT ne . and ECOAASMDT < DSSTDAT_IC;
run;

data eCOA010(keep=SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC);
retain SITECODE SUBJECT ECOAASMDT DS_BLOCKID DSSTDAT_IC;
set header010;
run;

/*eCOA011*/
/*Output records where HYPOEVAL="INVESTIGATOR" and HYPOSER=null where HYPOSTDAT and  HYPOSTTIM are equal to record with same date/time and HYTRTPRV="SUBJECT NOT CAPABLE OF*/
/*TREATING SELF AND*/
/*REQUIRED ASSISTANCE"*/

data eCOA011a(keep=SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOEVAL);
set ecoa.hypo1001;
where HYPOEVAL="INVESTIGATOR";
proc sort; by SUBJECT HYPOSTDAT HYPOSTTIM; run;

data eCOA011b(keep=SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOTRTPRV);
set ecoa.hypo1001;
where HYPOTRTPRV="SUBJECT NOT CAPABLE OF TREATING SELF AND REQUIRED ASSISTANCE";
proc sort; by SUBJECT HYPOSTDAT HYPOSTTIM; run;

data eCOA011(keep=SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOTRTPRV HYPOEVAL);
retain SITECODE SUBJECT ECOAASMDT HYPOSTDAT HYPOSTTIM HYPOTRTPRV HYPOEVAL;
merge eCOA011a(in=a) eCOA011b(in=b);
by SUBJECT HYPOSTDAT HYPOSTTIM;
if b and not a;
run;

/*eCOA012*/
/*Output records where HYPOSER=YES and no AE record where AEDECOD="HYPOGLYCAEMIA" and AESER=Y and HYPOSTDAT=AESTDAT"*/

data ae3001a(keep=SUBJID AETERM AEDECOD AEGRPID);
set clntrial.ae3001a_all;
where upcase(AEDECOD) = 'HYPOGLYCAEMIA';
proc sort; by SUBJID AEGRPID; run;

data ae3001b(keep=SUBJID AEGRPID AESTDAT AEENDAT AEONGO AESER DATE);
set clntrial.ae3001b_all;
where aeser = 'Y';
if coalesce(AESTDATMO,AESTDATDD,AESTDATYY) ne '' then
AESTDAT = mdy(AESTDATMO,AESTDATDD,AESTDATYY);
DATE = mdy(AESTDATMO,AESTDATDD,AESTDATYY);
if coalesce(AEENDATMO,AEENDATDD,AEENDATYY) ne '' then
AEENDAT = mdy(AEENDATMO,AEENDATDD,AEENDATYY);
format AESTDAT AEENDAT DATE date9.;
proc sort; by SUBJID AEGRPID; run;

data ae3001;
merge ae3001a(in=a) ae3001b(in=b);
by subjid aegrpid;
if a and b;
proc sort; by SUBJID DATE; run;

data hypo011(keep=SITECODE SUBJECT SUBJID ECOAASMDT HYPOTRTPRV HYPOSER HYPOEVAL HYPOSTDAT DATE);
format subjid z4.;
set ecoa.hypo1001;
where HYPOSER = 'YES';
SUBJID = input(scan(subject,2,"-"),4.);
DATE = mdy(scan(HYPOSTDAT,2,'-'), scan(HYPOSTDAT,3,'-'), scan(HYPOSTDAT,1,'-'));
format DATE date9.;
proc sort; by subjid DATE; run;

data hypoae;
merge hypo011(in=a) ae3001(in=b);
by SUBJID DATE;
if a and not b;
run;

data ECOA012(keep=SITECODE SUBJECT ECOAASMDT HYPOTRTPRV HYPOSER HYPOEVAL HYPOSTDAT);
retain SITECODE SUBJECT ECOAASMDT HYPOTRTPRV HYPOSER HYPOEVAL HYPOSTDAT;
set hypoae;
run;

/*eCOA013*/
/*ITSQ should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform*/

data itsq2001(keep=SITECODE SUBJECT subjid blockid VISITNUM ECOAASMDT);
format SUBJID z4. BLOCKID $50.;
set ecoa.itsq2001;
SUBJID = input(scan(subject,2,"-"),4.);
BLOCKID = compress(put(VISITNUM, 8.));
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
proc sort; by subjid blockid; run;

data statgut13(keep=SUBJID blockid stat);
set clntrial.statgut_all;
where stat = '100';
proc sort; by subjid blockid; run;

data itsqsvstat;
merge itsq2001(in=a) sv1001(in=b) statgut13(in=c);
by subjid blockid;
if a and b and c and ECOAASMDT ne VISDAT;
run;

data eCOA013(keep=SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT);
retain SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT;
set itsqsvstat;
run;

/*eCOA014*/
/*EQ5D should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform*/

data Eq5d5l2001(keep=SITECODE SUBJECT subjid blockid VISITNUM ECOAASMDT);
format SUBJID z4. BLOCKID $50.;
set ecoa.Eq5d5l2001;
SUBJID = input(scan(subject,2,"-"),4.);
BLOCKID = compress(put(VISITNUM, 8.));
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
proc sort; by subjid blockid; run;

data eq5dsvstat;
merge Eq5d5l2001(in=a) sv1001(in=b) statgut13(in=c);
by subjid blockid;
if a and b and c and ECOAASMDT ne VISDAT;
run;

data eCOA014(keep=SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT);
retain SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT;
set eq5dsvstat;
run;

/*eCOA015*/
/*WPAI should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform*/

data wpai2001(keep=SITECODE SUBJECT subjid blockid VISITNUM ECOAASMDT);
format SUBJID z4. BLOCKID $50.;
set ecoa.wpai2001;
SUBJID = input(scan(subject,2,"-"),4.);
BLOCKID = compress(put(VISITNUM, 8.));
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
proc sort; by subjid blockid; run;

data wpaisvstat;
merge wpai2001(in=a) sv1001(in=b) statgut13(in=c);
by subjid blockid;
if a and b and c and ECOAASMDT ne VISDAT;
run;

data eCOA015(keep=SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT);
retain SITECODE SUBJECT VISITNUM ECOAASMDT BLOCKID VISDAT STAT;
set wpaisvstat;
run;

/****************************** End of study-specific programming ******************************/

/********************************* Start of output programming *********************************/

%initialise;		/* Sets up environment for excel output */

/* List datasets to be output to xls file */
%excel_add_tab (ECOA001, "Check site/subject numbers in eCOA datasets against inform", "");
%excel_add_tab (ECOA002, "check that MMTT date is 0-4 days prior to corresponding visit", "");
%excel_add_tab (ECOA003, "check that V8 MMTT is prior to randomization date", "");
%excel_add_tab (ECOA004, "check that visit dates for all datasets with visit variable match corresponding visit in Inform", "");
%excel_add_tab (ECOA005, "eCOA data exists with date after V2 date in Inform if subject is continuing at V2 in Inform", "");
%excel_add_tab (ECOA006, "eCOA data exists with date after V8 date in Inform if subject is continuing at V8 in Inform", "");
%excel_add_tab (ECOA007, "If subject discontinued prior to V801, no dates present in eCOA data are after subject study disposition.", "");
%excel_add_tab (ECOA008, "If subject not discontinued at V801, no dates present in eCOA data are after V801.", "");
%excel_add_tab (ECOA009, "No dates present in eCOA data between Informed Consent and V2 in Inform.", "");
%excel_add_tab (ECOA010, "No dates present in eCOA data prior to Informed Consent.", "");
%excel_add_tab (ECOA011, "If Hypoglycemic Event indicates SUBJECT NOT CAPABLE OFTREATING SELF AND REQUIRED ASSISTANCE - investigator assessment of severity should be present.", "");
%excel_add_tab (ECOA012, "If Cognitive Impairment/Severe Episode is indicated for Hypoglycemic Event, a corresponding SAE should exist in Inform.", "");
%excel_add_tab (ECOA013, "ITSQ should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform", "");
%excel_add_tab (ECOA014, "EQ5D should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform", "");
%excel_add_tab (ECOA015, "WPAI should be present for visits 2, 8, and 18 where corresponding visits are continuing in Inform", "");

/* Output to xlsx using ODS EXCEL and the excel libname engine (using output_list data set) */

	/*%xlsx_output(help);*/ /* Run the macro with help as the parameter for complete list of options */ 

	%xlsx_output
	(			
		file_path		= &output_location,
		file_name		= &output_file_name._%sysfunc(date(),date9.)
	);

/* End writing to log and log checking */

%write_to_log(	status 		= &write_log_to_file,
			  	folder 		= &log_folder,
	        	log_name 	= &output_log_name);

%log_check(		status 		= &write_log_to_file,
				folder 		= &log_folder,
				log_name 	= &output_log_name);
