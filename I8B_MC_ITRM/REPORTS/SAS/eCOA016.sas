/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA016.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Report to output Blood Gluclose readings per patient per day from visit 2 till end of study
SPECIFICATIONS (required)         :
VALIDATION TYPE (required)        : Formal validation  not required – code review
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : .txt, .xls and .xlsx
DATA INPUT                        : qa\jreview\ly900014\i8b_mc_itrm\data\shared\*.*
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

/*eCOA016*/
/*Report to output Blood Gluclose readings per patient per day from visit 2 till end of study.*/

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
	create table eCOA016 as 
		select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', sitecode label 'Site', subjid label 'Subjid', 
        visdtc label 'Visit Date',
		case when bgcount = . then 0
		else bgcount
		end as bgcount label 'Daily Blood Gluclose Reading Count',
		case when bgcount in (.,0) then 'Subject reported ZERO Blood Gluclose Readings'
		else ''
		end as ERROR_MESSAGE label 'Error Message'
		from
		(select coalesce(a.subjid, b.subjid) as subjid, coalesce(a.sitecode, b.sitecode) as sitecode, 
        coalesce(a.visdtc, b.visdtc) as visdtc format date9., bgcount
		from alldates a full join bgcount b
		on a.subjid = b.subjid and a.visdtc = b.visdtc); quit;
quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA016";
  title2 "Report to output Blood Gluclose readings per patient per day from visit 2 till end of study";

proc print data=eCOA016 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA016 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
