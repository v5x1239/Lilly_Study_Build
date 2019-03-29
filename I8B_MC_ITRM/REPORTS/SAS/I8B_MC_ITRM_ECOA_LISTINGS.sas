/********************************* Pre-compile standard macros ********************************/

options mautosource sasautos = ("\\dub-filer-02\sas_icr_dm_eu\library\prod\global_macro\macros");

%initialise_log;				/* Clears log screen and prints sysver, syshostname, sysuserid, start_date and start_time */

/*************************************** Start of Header ***************************************
/*
Company (required) -              : Lilly
CODE NAME (required)              : l02191268_ECOA_LISTINGS.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Program ECOA MDVP checks.
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

%set_up_options;	/* Initialises pre-defined environment options and populate the &eu_us. parameter */

options nofmterr;

/* Study context parameters */
%let sponsor_name 		= Lilly;					        	/* Sponsor name 		- (optional) 									*/
%let output_description	= ECOA_LISTINGS;					/* Output descruiption 	- (optional) 									*/
%let icon_code 			= l02191268;								/* Icon study code 					 									*/
%let study_path 		= \\IX1LECFS02.rf.lilly.com\icon.grp\DS_END\219268_I8B-MC-ITRM;			/* Icon root path 					 									*/
%let exec_env 			= dev; 								    	/* Execution environment - program/log/output location 	- dev/prod 		*/
%let data_env 			= current; 									/* Data environment 	 - source data location 		- test/current 	*/

/* Source/Target data location */
*libname raw "&study_path.\2_dmraw\&data_env" access=readonly inencoding=any;

/* Output location parameters */
%let output_location 	= &study_path\Listings\Output;			/* Output file location, if applicable 	*/
%let output_file_name 	= I8B_MC_ITRM_ECOA_LISTINGS;		/* Output file name, if applicable 		*/

/* Log output parameters */
%let write_log_to_file 	= YES;												/* Set to YES when log should be spooled to output file. */
%let log_folder 		= &study_path\Listings\Logs;		/* Location for log file */
%let output_log_name 	= &output_file_name;					/* Log file name */

%let ecoa=&study_path.\ECOA;

/************************** End of environment/input/output programming *************************/

/***************************** Start of study-specific programming ******************************/

/*libname clntrial oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=I8B_MC_ITRM;*/

libname ecoa "&ecoa." access=readonly;

/*DIAB_eCOA_URI_Recon1_PREP*/

data BG2001(keep=SUBJECT SITECODE ECOASTDT ECOAENDT LBCAT LBTPTREF BGCONC BGCONC1 BGCONC2 BGCONCU
							   BGCONCU1 BGCONCU2 BGDAT BGDAT1 BGDAT2 BGTIM BGTIM1 BGTIM2 BGDATE BGTIME);
set ecoa.BG2001;
BGDATE = COALESCEC(BGDAT, BGDAT1, BGDAT2);
BGTIME = COALESCEC(BGTIM, BGTIM1, BGTIM2);
proc sort; by SUBJECT BGDATE BGTIME; run;

/*DIAB_eCOA_URI_Recon1a*/

data BG2001_1;
set BG2001;
where LBTPTREF is not null and BGCONC in (.,0.00) and BGCONC1 in (.,0.00) and BGCONC2 in (.,0.00);
run;

data DIAB_eCOA_URI_Recon1a(drop=BGDATE BGTIME);
retain SUBJECT SITECODE ECOASTDT ECOAENDT LBCAT LBTPTREF BGCONC BGCONC1 BGCONC2 BGCONCU
	   BGCONCU1 BGCONCU2 BGDAT BGDAT1 BGDAT2 BGTIM BGTIM1 BGTIM2;
set BG2001_1;
run;

/*DIAB_eCOA_URI_Recon1b*/

data bg2001a(keep = SUBJECT BGDATE LBTPTREF_MORNING);
set bg2001;
where LBTPTREF = 'MORNING MEAL' and BGDATE is not null;
rename LBTPTREF = LBTPTREF_MORNING;
run;

data bg2001b(keep = SUBJECT BGDATE LBTPTREF_MIDDAY);
set bg2001;
where LBTPTREF = 'MIDDAY MEAL' and BGDATE is not null;
rename LBTPTREF = LBTPTREF_MIDDAY;
run;

data bg2001c(keep = SUBJECT BGDATE LBTPTREF_EVENING);
set bg2001;
where LBTPTREF = 'EVENING MEAL' and BGDATE is not null;
rename LBTPTREF = LBTPTREF_EVENING;
run;

data BG2001_2;
merge BG2001(in=a) BG2001a BG2001b BG2001c;
by SUBJECT BGDATE;
if a;
run;

data BG2001_2a;
set BG2001_2;
where BGDATE is not null and (LBTPTREF_MORNING is null or LBTPTREF_MIDDAY is null or LBTPTREF_EVENING is null);
drop LBTPTREF_MORNING LBTPTREF_MIDDAY LBTPTREF_EVENING;
run;

data DIAB_eCOA_URI_Recon1b(drop=BGDATE BGTIME);
retain SUBJECT SITECODE ECOASTDT ECOAENDT LBCAT LBTPTREF BGCONC BGCONC1 BGCONC2 BGCONCU
	   BGCONCU1 BGCONCU2 BGDAT BGDAT1 BGDAT2 BGTIM BGTIM1 BGTIM2;
set BG2001_2a;
run;

/*DIAB_eCOA_URI_Recon2_PREP*/

data ML3001(keep=SUBJECT SITECODE ECOAENDT MLCAT MLDOSE_CARB MLDOSE_CARBU MLSTDAT MLSTTIM);
set ecoa.ML3001;
proc sort; by SUBJECT MLSTDAT MLSTTIM; run;

/*DIAB_eCOA_URI_Recon2a*/

data DIAB_eCOA_URI_Recon2a;
retain SUBJECT SITECODE ECOAENDT MLCAT MLDOSE_CARB MLDOSE_CARBU MLSTDAT MLSTTIM;
set ML3001;
where MLCAT is not null and MLDOSE_CARB in (.,0.00);
run;

/*DIAB_eCOA_URI_Recon2b*/

data ML3001a(keep = SUBJECT MLSTDAT MLCAT_MORNING);
set ML3001;
where MLCAT = 'MORNING MEAL';
rename MLCAT = MLCAT_MORNING;
run;

data ML3001b(keep = SUBJECT MLSTDAT MLCAT_MIDDAY);
set ML3001;
where MLCAT = 'MIDDAY MEAL';
rename MLCAT = MLCAT_MIDDAY;
run;

data ML3001c(keep = SUBJECT MLSTDAT MLCAT_EVENING);
set ML3001;
where MLCAT = 'EVENING MEAL';
rename MLCAT = MLCAT_EVENING;
run;

data ML3001_2;
merge ML3001(in=a) ML3001a ML3001b ML3001c;
by SUBJECT MLSTDAT;
if a;
run;

data DIAB_eCOA_URI_Recon2b;
retain SUBJECT SITECODE ECOAENDT MLCAT MLDOSE_CARB MLDOSE_CARBU MLSTDAT MLSTTIM;
set ML3001_2;
where MLSTDAT is not null and (MLCAT_MORNING is null or MLCAT_MIDDAY is null or MLCAT_EVENING is null);
drop MLCAT_MORNING MLCAT_MIDDAY MLCAT_EVENING;
run;

/*DIAB_eCOA_URI_Recon3_PREP*/

data EX1001(keep=SUBJECT SITECODE ECOAENDT EXDOSE EXDOSEU EXSTDAT EXSTTIM EXCAT EXSCAT EXTPT);
set ecoa.EX1001;
proc sort; by SUBJECT EXSTDAT EXSTTIM; run; 

/*DIAB_eCOA_URI_Recon3a*/

data DIAB_eCOA_URI_Recon3a;
retain SUBJECT SITECODE ECOAENDT EXDOSE EXDOSEU EXSTDAT EXSTTIM EXCAT EXSCAT EXTPT;
set EX1001;
where EXTPT is not null and EXDOSE in (.,0.00);
run;

/*DIAB_eCOA_URI_Recon3b*/

data EX1001a(keep = SUBJECT EXSTDAT EXTPT_MORNING);
set EX1001;
where EXTPT = 'MORNING MEAL';
rename EXTPT = EXTPT_MORNING;
run;

data EX1001b(keep = SUBJECT EXSTDAT EXTPT_MIDDAY);
set EX1001;
where EXTPT = 'MIDDAY MEAL';
rename EXTPT = EXTPT_MIDDAY;
run;

data EX1001c(keep = SUBJECT EXSTDAT EXTPT_EVENING);
set EX1001;
where EXTPT = 'EVENING MEAL';
rename EXTPT = EXTPT_EVENING;
run;

data EX1001_2;
merge EX1001(in=a) EX1001a EX1001b EX1001c;
by SUBJECT EXSTDAT;
if a;
run;

data DIAB_eCOA_URI_Recon3b;
retain SUBJECT SITECODE ECOAENDT EXDOSE EXDOSEU EXSTDAT EXSTTIM EXCAT EXSCAT EXTPT;
set EX1001_2;
where EXSTDAT is not null and (EXTPT_MORNING is null or EXTPT_MIDDAY is null or EXTPT_EVENING is null);
drop EXTPT_MORNING EXTPT_MIDDAY EXTPT_EVENING;
run;

/*DIAB_eCOA_URI_Recon4*/

data DIAB_eCOA_URI_Recon4(keep=SUBJECT SITECODE ECOAENDT HYOCCUR HYPOSTDAT HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU HYPOTRTPRV HYCONTRT HYPOEVAL HYTERM HYPRESP HYPOCPH); 
retain SUBJECT SITECODE ECOAENDT HYOCCUR HYPOSTDAT HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU HYPOTRTPRV HYCONTRT HYPOEVAL HYTERM HYPRESP HYPOCPH;
set ecoa.HYPO1001;
where upcase(HYCONTRT) = 'YES';
run;

/*DIAB_eCOA_URI_Recon5*/

data DIAB_eCOA_URI_Recon5(keep=SUBJECT SITECODE VISIT VISITNUM ECOASTDT ECOAENDT ECOAASMDT HYOCCUR HYPOSTDAT
							   HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU BGCONCSTAT HYPOOUT_A HYPOOUT_B 
							   HYPOOUT_C HYPOOUT_D HYPOOUT_E HYPOOUT_F HYPOOUT_G HYPOACNOTH_B HYCONTRT HYPOTRT_A
							   HYPOTRT_B HYPOTRT_C HYPOTRT_D HYPOTRT_E HYPOTRTPRV HYPOSER HYPOEVAL CESPID HYTERM
							   HYOBJ FACAT HYPRESP HYPOCPH HYPOCPSH CECAT CESCAT);
retain SUBJECT SITECODE VISIT VISITNUM ECOASTDT ECOAENDT ECOAASMDT HYOCCUR HYPOSTDAT
							   HYPOSTTIM HYPORES1 HYPORES3 HYPORES14 BGCONC_DURING_CE BGCONC_DURING_CEU BGCONCSTAT HYPOOUT_A HYPOOUT_B 
							   HYPOOUT_C HYPOOUT_D HYPOOUT_E HYPOOUT_F HYPOOUT_G HYPOACNOTH_B HYCONTRT HYPOTRT_A
							   HYPOTRT_B HYPOTRT_C HYPOTRT_D HYPOTRT_E HYPOTRTPRV HYPOSER HYPOEVAL CESPID HYTERM
							   HYOBJ FACAT HYPRESP HYPOCPH HYPOCPSH CECAT CESCAT;
set ecoa.HYPO1001;
run;

/****************************** End of study-specific programming ******************************/

/********************************* Start of output programming *********************************/

%initialise;		/* Sets up environment for excel output */

/* List datasets to be output to xls file */
%excel_add_tab (DIAB_eCOA_URI_Recon1a, "Exception based report to identify missing BGCONC from BG1001", "");
%excel_add_tab (DIAB_eCOA_URI_Recon1b, "Exception based report to identify missing Meals from BG1001", "");
%excel_add_tab (DIAB_eCOA_URI_Recon2a, "Exception based report to identify missing MLDOSE_CARB from ML3001", "");
%excel_add_tab (DIAB_eCOA_URI_Recon2b, "Exception based report to identify missing Meals from ML3001", "");
%excel_add_tab (DIAB_eCOA_URI_Recon3a, "Exception based report to identify missing EXDOSE from EX1001", "");
%excel_add_tab (DIAB_eCOA_URI_Recon3b, "Exception based report to identify missing Meals from EX1001", "");
%excel_add_tab (DIAB_eCOA_URI_Recon4, "Exception based report to identify where HYCONTRT = YES", "");
%excel_add_tab (DIAB_eCOA_URI_Recon5, "Dump of HYPO panel", "");


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
