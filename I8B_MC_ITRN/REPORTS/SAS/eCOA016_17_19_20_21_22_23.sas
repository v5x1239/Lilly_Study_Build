/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA016_17_19_20_21_22_23.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : Summary of all readings per patient per day
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itrn\data\shared\*.*
OUTPUT                            : Excel
SPECIAL INSTRUCTIONS              : Must refresh ecoa datasets

DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

**************************************** End of Header ******************************************/

options compress=yes;

/************************* Start of environment/input/output programming ************************/

/*eCOA016_17_19_20_21_22_23*/
/*Summary of all readings per patient per day.*/

/****************** Get all eCOA BG readings. ***************************************/

/******* Flip ecoa_raw so it has bg, time, and lbtptref vertical to remove duplicates*****/

/* Begin by creating separate datasets that have BGDAT, BGDAT1 and BGDAT2 with all associated
	variables and renaming the variables so they'll stack.  Then stack them and do a sort
	on subject bgdat bgtim lbtptref to bring the assigned BGs to the end of the sort and then
	do a last.bgtim to remove all the duplicates due to assigned versus unassigned.  *******/

proc sql;
create table test_group as
select subjid format z4., sitecode, input(catx("-",substr(bgdat,6,2),substr(bgdat,9,2),substr(bgdat,1,4)),mmddyy10.) as bgdat format date9., bgconc, bgtim, lbtptref from
(select subjid, sitecode, bgdat, bgconc, bgtim, lbtptref from cluwe.bg2001_ecoa
union all
select subjid, sitecode, bgdat1 as bgdat, bgconc1 as bgconc, bgtim1 as bgtim, lbtptref from cluwe.bg2001_ecoa
union all
select subjid, sitecode, bgdat2 as bgdat, bgconc2 as bgconc, bgtim2 as bgtim, lbtptref from cluwe.bg2001_ecoa) 
where bgdat is not null order by subjid, bgdat, bgtim, lbtptref; quit;

/*  This is the final BG dataset, with no duplicates and stacked vertically.*/

data bg_nodup;
	set test_group;
		by subjid bgdat bgtim lbtptref;
		if last.bgtim;
run;

/****** Now count up bg samples by date n bg_nodup to merge with Alldates and dosecount***************/

data bgcount (rename = (bgdat = visdtc));
	set bg_nodup;
		by subjid bgdat bgtim lbtptref;		
			if first.bgdat then bgcount = 0;
			bgcount + 1;
		if last.bgdat then output;
		drop bgconc bgtim lbtptref;
run;

/*****************************************************************************************************/
/**** Get bolus dosing data and count how many are reported each day to add to bg_bolus dataset.******/
/*****************************************************************************************************/

/**********  Get bolus_raw data from bi-weekly transfer *************************************/

proc sql;
create table bolus_raw as
select subjid format z4., sitecode, 
input(catx("-",substr(exstdat,6,2),substr(exstdat,9,2),substr(exstdat,1,4)),mmddyy10.) as exstdat format date9. 
from cluwe.ex1001_ecoa 
where exstdat ne '' and excat = "STUDY TREATMENT" 
order by subjid, exstdat; quit; 

/*************** Count up how many bolus doses are recorded on each day ***************************/

data boluscount (rename = (exstdat = visdtc));
	set bolus_raw;
		by subjid exstdat;
		if first.exstdat then boluscount = 0;
		boluscount + 1;
		if last.exstdat then output;
		run;

/*****************************************************************************************************/
/**** Get basal dosing data and count how many are reported each day to add to bg_bolus dataset.******/
/*****************************************************************************************************/

/**********  Get basal_raw data from bi-weekly transfer *************************************/

proc sql;
create table basal_raw as
select subjid format z4., sitecode, 
input(catx("-",substr(cmstdat,6,2),substr(cmstdat,9,2),substr(cmstdat,1,4)),mmddyy10.) as cmstdat format date9. 
from cluwe.cm1001_ecoa 
where cmstdat ne ''
order by subjid, cmstdat; quit; 

/*************** Count up how many basal doses are recorded on each day ***************************/

data basalcount (rename = (cmstdat = visdtc));
	set basal_raw;
		by subjid cmstdat;
		if first.cmstdat then basalcount = 0;
		basalcount + 1;
		if last.cmstdat then output;
run;

/*******************************************************************************************/
/******* Add in meal counts to bgday4 *************************************************/
/*******************************************************************************************/

/**********  Get meal_raw data from bi-weekly transfer *************************************/

proc sql;
create table meal_raw as
select subjid format z4., sitecode, 
input(catx("-",substr(mlstdat,6,2),substr(mlstdat,9,2),substr(mlstdat,1,4)),mmddyy10.) as mlstdat format date9. 
from cluwe.ml3001_ecoa 
where mlstdat ne ''
order by subjid, mlstdat; quit; 

/**********  Count up meals per day ********************************************************/

data meal_count (rename = (mlstdat = visdtc));
	set meal_raw;
		by subjid mlstdat;
			if first.mlstdat then mealcount=0;
			mealcount + 1;
			if last.mlstdat then output;
run;

/*******************************************************************************************/
/******* Add in hypo counts to BG_exp ******************************/
/*******************************************************************************************/

/**********  Get hypo_raw data from bi-weekly transfer *************************************/

proc sql;
create table hypo_raw as
select subjid format z4., sitecode, 
input(catx("-",substr(hypostdat,6,2),substr(hypostdat,9,2),substr(hypostdat,1,4)),mmddyy10.) as hypostdat format date9. 
from cluwe.hypo1001_ecoa 
where hypostdat ne '' and visit ne "VISIT 8"
order by subjid, hypostdat; quit; 

/**********  Count up hypos per day ********************************************************/

data hypo_count (rename = (hypostdat = visdtc));
format subjid z4.;
	set hypo_raw;
		by subjid hypostdat;
			if first.hypostdat then hypocount=0;
			hypocount + 1;
			if last.hypostdat then output;
run;

/******************************************************************************************************************/
/* now fabricate all possible days for that patient, beginning with visit 2 date and ending with last visit so far*/
/******************************************************************************************************************/

proc sql;
create table visdate as
select distinct sitecode, subjid, min(visdate) as firstdtc format date9., max(visdate) as lastdtc format date9. from
	(select subjid, st.SITEMNEMONIC as sitecode, blockid, mdy(input(VISDATMO, 8.),input(VISDATDD, 8.),input(VISDATYY, 8.)) as visdate format date9., input(blockid, 8.) as visit
	from CLUWE.SV1001 sv, CLUWE.inf_subject sb, CLUWE.inf_site_update st
	where sb.SITEGUID=st.CT_RECID and sv.subject_id=sb.subject_id and
	input(blockid, 8.) >= 2 and coalesce(VISDATMO ,VISDATDD, VISDATYY) is not null) group by subjid order by subjid; quit;

/* create table with all days for each subject*/
data alldates;
format date visdtc date9.;
	set visdate;
	by subjid;
			do date=firstdtc to lastdtc;
				visdtc = date;
				output;
			end;
run;

/********************************************************************************************************/
/**********Include count of bg by calendar date with 0 for days without BG readings*********************/
/********************************************************************************************************/

proc sql;
	create table eCOA016_17_19_20_21_22_23 as
		select *
		from
		(select upcase(substr(&irprot.,1,11)) as STUDY label 'Study' format $11.,
			    a.sitecode label 'Site', a.subjid as SUBJID format z4. label 'Subjid', 
        a.visdtc label 'Visit Date', 
		case when bgcount = . then 0
		else bgcount
		end as bgcount label 'Daily Blood Glucose Reading Count',
		case when boluscount = . then 0
		else boluscount
		end as boluscount label 'Daily Bolus Reading Count',
		case when basalcount = . then 0
		else basalcount
		end as basalcount label 'Daily Basal Reading Count',
		case when mealcount = . then 0
		else mealcount
		end as mealcount label 'Daily Meal Reading Count',
		case when hypocount = . then 0
		else hypocount
		end as hypocount label 'Daily Hypo Reading Count',
		case when bgcount is null then 'Subject reported ZERO Blood Glucose Readings'
			 when bgcount is not null and bgcount < 4 then 'Subject reported less then 4 Blood Glucose Readings'
			 else ''
			 end as eCOA017_FLAG label 'eCOA017 Flag',
		case when dsdecod is not null and coalesce(bgcount, boluscount, basalcount, mealcount, hypocount) is not null
				then 'Patient is a Visit 2 Screen Fail but has eCOA data'
			 else ''
			 end as eCOA019_FLAG label 'eCOA017 Flag'
		from alldates a 
		left join bgcount b on a.subjid = b.subjid and a.visdtc = b.visdtc
		left join boluscount c on a.subjid = c.subjid and a.visdtc = c.visdtc
		left join basalcount d on a.subjid = d.subjid and a.visdtc = d.visdtc
		left join meal_count e on a.subjid = e.subjid and a.visdtc = e.visdtc
		left join hypo_count f on a.subjid = f.subjid and a.visdtc = f.visdtc
		left join (select subjid, dsdecod from cluwe.ds1001 where blockid = '2' and dsdecod = 'SCREEN FAILURE') g
		on a.subjid = g.subjid)
		order by subjid, visdtc; quit;
quit;

/*Jreview output proccessing*/

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA016_17_19_20_21_22_23";
  title2 "Summary of all readings per patient per day";

proc print data=eCOA016_17_19_20_21_22_23 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA016_17_19_20_21_22_23 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
