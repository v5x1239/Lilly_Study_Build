/*soh*****************************************************************************************************
	Eli Lilly and Company		-DSS
	LOCATION/NAME			: \\statsclstr\lillyce\qa\jreview\ly900014\i8b_mc_itsi\programs\InForm eCOA Mart.sas
	PROJECT NAME			: I8B
	DESCRIPTION				: Copy and proccess CLUWE raw datasets and post to CLUWE JReview DATAMART for reconciliation
	SPECIFICATION LOCATION/NAME	:   
	VALIDATION APPROACH		: Self Review
	SOFTWARE/VERSION#		: SAS 93
	INPUT LOCATION/NAME		: \\statsclstr\lillyce\qa\ly900014\i8b_mc_itsi\prelock\data\raw\shared
							  \\statsclstr\lillyce\qa\ly900014\i8b_mc_itsi\prelock\data\raw\shared\ecoa
	OUTPUT LOCATION/NAME	: \\statsclstr\lillyce\qa\jreview\ly900014\i8b_mc_itsi\data\shared
	STUDY REFERENCE			: I8-MC-ITSI

	SPECIAL INSTRUCTIONS	:  Data must be current in CLUWE before running program
	
----------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------	
	Version History:

	Ver#	Date		Author			Code History Description
	----	-------		---------------		----------------------------------------------------------
	1.0	    			Joe Cooney			Original Version of the Report

*eoh*****************************************************************************************************/

libname Infm_IN "\\statsclstr\lillyce\qa\ly900014\i8b_mc_itsi\prelock\data\raw\shared" access=readonly;
libname eCOA_IN "\\statsclstr\lillyce\qa\ly900014\i8b_mc_itsi\prelock\data\raw\shared\ecoa" access=readonly;
libname Mart_OUT "\\statsclstr\lillyce\qa\jreview\ly900014\i8b_mc_itsi\data\shared";
libname ext oracle dbprompt=yes defer=no path=prd934 access=READONLY schema=MDF_SS_OWNER;

Option mprint mlogic nofmterr compress=yes;

** Copy all of the InForm Data to Mart;
proc copy in=Infm_IN out=Mart_OUT memtype=data; run;

** Adjust any issues with data sets;
data Mart_OUT.item(label=' '); set Mart_OUT.item; run;
data Mart_OUT.Cdms_iasci_prtcl(label=' '); set Mart_OUT.Cdms_iasci_prtcl; run;
data Mart_OUT.Cdms_iasci_site(label=' '); set Mart_OUT.Cdms_iasci_site; run;
data Mart_OUT.Cdms_iasci_site_inv(label=' '); set Mart_OUT.Cdms_iasci_site_inv; run;
data Mart_OUT.Panel(label=' '); set Mart_OUT.Panel; run;
proc datasets library=Mart_OUT; delete Cmdr_lrt_study_specific_ref_rnge Dm1001_inform; quit;

/*  eCOA Processing */
proc contents data=eCOA_IN._all_ out=eCOA_Contents noprint; run;

proc sort data=ecoa_contents; by MEMNAME NAME; run;

** Determine if Visit is on the data set;
data ecoa_dsname;
  set ecoa_contents;
  by MEMNAME NAME;
  retain vis_flag 0;
  keep MEMNAME vis_flag;
  if first.memname then vis_flag=0;
  if name="VISITNUM" then  vis_flag=1;
  if last.memname then output;
run;

*Determine the number of eCOA data sets;
data _null_;
  set ecoa_dsname  end=eof; 
  if EOF then call Symput("DS_CNT",_N_);
run;
%Put DS_CNT;

%macro transform_ecoa();
%do i=1 %to &DS_CNT;
  data _null_;
    set ecoa_dsname; 
	if _n_=&i;
    call symput(compress("DS"), Compress(MEMNAME));
    call symput(compress("FLG"), vis_flag);
  run;
  data Mart_OUT.&ds._ECOA; 
    set eCOA_IN.&ds;
  %if &FLG=1 %then %do;
  	length BLOCKID $50.;
    BLOCKID = compress(put(VISITNUM, 8.));
  %end;
  	format SUBJID z4.;
    SUBJID = input(scan(subject,2,"-"),4.);
run;
%end;
%Mend;
%transform_ecoa();

/*Header file creation*/

data HEADER(keep=SUBJECT SITECODE /*VISIT VISITNUM*/ ECOAASMDT SUBJID /*BLOCKID*/);
retain SUBJECT SITECODE /*VISIT VISITNUM*/ ECOAASMDT SUBJID /*BLOCKID*/;
format SUBJID z4. /*BLOCKID $50.*/;
set eCOA_IN.Bg2001      
/*      eCOA_IN.Cm1001*/
/*      eCOA_IN.Eq5d5l2001*/
      eCOA_IN.Ex1001
      eCOA_IN.Hypo1001
/*      eCOA_IN.Itsq2001*/
/*      eCOA_IN.Ml1001*/
/*      eCOA_IN.Ml3001*/
/*      eCOA_IN.Pde1001*/
/*      eCOA_IN.Wpai2001;*/
	  eCOA_IN.Ipm1001;
SUBJID = input(scan(subject,2,"-"),4.);
/*BLOCKID = compress(put(VISITNUM, 8.));*/
ECOAASMDT_DATE9 = input(ECOAASMDT,yymmdd10.);
    format ECOAASMDT_DATE9 date9.;
drop ECOAASMDT;
rename ECOAASMDT_DATE9 = ECOAASMDT;
if excat = "EXPOSURES RELATIVE TO MIXED MEAL TOLERANCE TEST" then delete;
proc sort nodupkey; by _all_; run;
proc sort; by SUBJID; run; 

data DS1001(keep=SUBJID discon_flag discon_visit DSSTDAT);
set Infm_IN.ds1001;
discon_flag = 'Y';
if coalesce(DSSTDATMO,DSSTDATDD,DSSTDATYY) ne '' then
DSSTDAT = mdy(DSSTDATMO,DSSTDATDD,DSSTDATYY);
format DSSTDAT date9.;
DSSCAT = 'STUDY DISPOSITION';
discon_visit = blockid;
proc sort; by SUBJID; run;

data Mart_OUT.ECOA_HEADER;
merge header(in=a) DS1001;
by SUBJID;
if a;
run;

/*End of header file creation*/

/*copy LSS dataset to MART*/

data Mart_OUT.CDMS_LSSI_SAE_DNRLMZ;
set ext.cdms_lssi_sae_dnrlmzd_vw;
where USDYID = "I8B-MC-ITSI";
run;

/*copy Meddra_Hrchy to MART*/

data mart_out.CDMS_MEDDRA_HRCHY;
set ext.CDMS_MEDDRA_HRCHY;
run;
