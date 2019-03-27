/*
Company (required) -              : ICON
CODE NAME (required)              : ONC_TU219_TU318
PROJECT NAME (required)           :  
DESCRIPTION (required)            : Exceptation based report to know what tumor assessments are missing for the study by subject. 
SPECIFICATIONS (required)         : ONC_TU219_TU318 Specifications 02Mar17
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : SAS 9.4
INFRASTRUCTURE                    : 
DATA INPUT                        : inf_subject, inf_site_update, DM1001, EX1001, TU2001A, TU2001B,
								    TU3001A, TU3001B, RS1001, DS1001
OUTPUT                            : ONC_TU219_TU318
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney   Original version of the code
*/

/*SITE*/

proc sql;
create table site as
select distinct st.SITEMNEMONIC, SUBJID
from clntrial.inf_sub sb, clntrial.inf_site st, clntrial.DM1001 dm
where sb.SITEGUID=st.CT_RECID and dm.subject_id=sb.subject_id
order by SUBJID;
quit;

/*Output when there is not a record with TUDAT on or before earliest (Cycle 1) EXSTDAT for a subject.  
Error message:  Missing baseline scan. */

/*
*Exceptions*
Patient 1117 CYCLE 1 VISDAY is null*/

proc sql;
create table ex1001 as
SELECT SUBJID, MIN(EXSTDAT) as EXSTDAT
	from (Select SUBJID, case when not missing (EXSTDAT) then datepart(EXSTDAT) else . end as EXSTDAT format date9.
            FROM clntrial.EX1001
           WHERE BLOCKID = '1')
        GROUP BY SUBJID
		order by SUBJID;
quit;

proc sql;
create table TU2001 as
SELECT a.SUBJID, PAGE, a.TULNKID, a.TUDAT,
               b.TRSPID, b.TRDAT
          FROM    (SELECT SUBJID, PAGE, TULNKITG as TULNKID,
                          case when not missing (TUDAT) then datepart(TUDAT) else . end AS TUDAT format = date9.
                     FROM clntrial.TU2001A) a
               LEFT JOIN
                  (SELECT SUBJID, TRLNKID, TRSPID,
                          case when not missing (TRDAT) then datepart(TRDAT) else . end AS TRDAT format = date9.
                     FROM clntrial.TU2001B) b
               ON a.SUBJID = b.SUBJID AND a.TULNKID = b.TRLNKID;
proc sort; by subjid; run;

proc sql;
create table TU3001 as
        SELECT c.SUBJID, PAGE, c.TULNKID, c.TUDAT,
               d.TRSPID, d.TRDAT
          FROM    (SELECT SUBJID, PAGE, TULNKINT as TULNKID,
                          case when not missing (TUDAT) then datepart(TUDAT) else . end AS TUDAT format = date9.
                     FROM clntrial.TU3001A) c
               LEFT JOIN
                  (SELECT SUBJID, TRLNKID, TRSPID,
                          case when not missing (TRDAT) then datepart(TRDAT) else . end AS TRDAT format = date9.
                     FROM clntrial.TU3001B) d
               ON c.SUBJID = d.SUBJID AND c.TULNKID = d.TRLNKID;
proc sort; by subjid; run;

data tumor;
set TU2001 TU3001;
proc sort; by subjid; run;

proc sql;
create table minTUDAT as
select SUBJID, PAGE, min(TUDAT) as minTUDAT format date9.
from tumor
group by SUBJID, PAGE
order by SUBJID;
quit;

data part1(keep = Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message);
format Site $32. Subject 11. Tumor_ID $50. Assessment_Num 5. Date_of_Last_Scan date9. Date_of_Next_Scan date9. C1D1_Dose_Date date9. Error_Message $50.;
merge minTUDAT(in=a) ex1001(in=b) site;
by subjid;
if (a and b and minTUDAT > EXSTDAT) or (a and not b);
Site = SITEMNEMONIC;
Subject = SUBJID;
Tumor_ID = PAGE;
Assessment_Num = .;
Date_of_Last_Scan = .; 
Date_of_Next_Scan = .; 
C1D1_Dose_Date = EXSTDAT; 
Error_Message = "Missing baseline scan";
NonTargetOnly = "&nontargetonly.";
if upcase(NonTargetOnly) = 'Y' and substr(PAGE,1,6) = "TU2001" then delete;
run;

/*Output when the next assessment is expected (based on parameter) but not present.  */
/*		Include in calculation all projected asssessments not just the 1st missing assessment (THROUGH CURRENT DATE).  */
/*a. If a subject is missing multiple projected assessments, create multiple records in the output in date order.  */

proc sql;
create table maxTRDAT as
select * from
(select SUBJID, TULNKID, TUDAT, TRSPID, TRDAT, max(TRDAT) as maxTRDAT format date9.
from tumor 
where TRDAT is not null
group by SUBJID, TULNKID)
where TRDAT = maxTRDAT;
quit;
proc sort data=tumor; by subjid TULNKID; run;

Data Tumor_expvis;
format days 8.;
Set maxTRDAT;
CURVISDT=Today();
Format CURVISDT Date9.;

Date_of_Next_Scan=TRDAT;
weeks = "&weeks.";

if weeks ne '' then do;
	Days = input(weeks,8.) * 7;
	Do until (Date_of_Next_Scan > CURVISDT);
		Date_of_Next_Scan=Date_of_Next_Scan+days;
		TRSPID = TRSPID + 1;
		output;
		End;
end;

Format Date_of_Next_Scan Date9.;
Keep SUBJID TULNKID TRSPID TRDAT Date_of_Next_Scan;
Run;

Proc Sort;By SUBJID TULNKID TRSPID;Run;

/*b. If RS1001_OVRLRESP = PD and RS1001_SYMPDET = N, do not output as an issue.  */
/*For testing/Validaiton purposes use the following(SYMPDET not collected) b. If RS1001_OVRLRESP = PD */
/*and RS1001_OVRLRESP_NRP is null, do not output as an issue. */

data rs1001(keep=SUBJID OVRLRESP OVRLRNRP);
set clntrial.rs1001;
where OVRLRESP = 'PD' and OVRLRNRP = '';
proc sort nodupkey; by SUBJID; run;

/*If DS1001_DSDECOD = DEATH or LOST TO FOLLOW-UP and calculated ‘Date of Next Scan’ is greater than or */
/*equal to DS1001_DSSTDAT where DS1001_DSDECOD = DEATH or LOST TO FOLLOW-UP, do not output as an issue.*/

data DS1001(keep=SUBJID DSDECOD DS1001DAT);
set clntrial.DS1001;
where DSDECOD in ('DEATH', 'LOST TO FOLLOW-UP');
if DSDECOD = 'DEATH' and DTHDAT ne . then DS1001DAT = datepart(DTHDAT);
	else if DSSTDAT ne . then DS1001DAT = datepart(DSSTDAT);
		else DS1001DAT = .;
format DS1001DAT date9.;
proc sort nodupkey; by SUBJID; run;

/*Error message:  Missing post baseline scan(s)*/

data part2a;
merge Tumor_expvis(in=a) rs1001(in=b) ds1001(in=c);
by SUBJID;
if a and not b;
if DS1001DAT ne . and Date_of_Next_Scan > DS1001DAT then delete;
proc sort; by SUBJID TULNKID; run;

data part2b;
set part2a;
by SUBJID TULNKID;
if not first.TULNKID then TRDAT = .;
rename TRDAT = Date_of_Last_Scan;
run;

data part2(keep=Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message);
format Site $32. Subject 11. Tumor_ID $50. Assessment_Num 5. C1D1_Dose_Date date9. Error_Message $50.;
merge part2b(in=a) ex1001 site;
by SUBJID;
if a;
Site = SITEMNEMONIC;
Subject = SUBJID;
Tumor_ID = TULNKID;
Assessment_Num = TRSPID;
C1D1_Dose_Date = EXSTDAT; 
Error_Message = "Missing post baseline scan(s)";
run;

/*Output when there are no target tumors identified. Only output as an issue when study specific parameter “non-target disease only” = N 
  AND patient is missing from TU2001 AND patient does not have a record in the DS1001 dataset where PAGE = DS1001_LF1.*/
/*Error message:  No target tumor(s) identified.*/

data dm1001(keep=SUBJID);
set clntrial.dm1001;
proc sort nodupkey; by SUBJID; run; 

data ds1001(keep=SUBJID);
set clntrial.ds1001;
where page = 'DS1001_LF1';
proc sort nodupkey; by SUBJID; run; 

data part3a;
merge dm1001(in=a) tu2001(in=b) ds1001(in=c);
by SUBJID;
if a and not b and not c;
Tumor_ID = TULNKID;
run;

data part3(keep=Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message);
format Site $32. Subject 11. Tumor_ID $50. Assessment_Num 5. Date_of_Last_Scan date9. Date_of_Next_Scan date9. C1D1_Dose_Date date9. Error_Message $50.;
merge part3a(in=a) ex1001 site;
by SUBJID;
if a;
Site = SITEMNEMONIC;
Subject = SUBJID;
Tumor_ID = '';
Assessment_Num = .;
Date_of_Last_Scan = .; 
Date_of_Next_Scan = .; 
C1D1_Dose_Date = EXSTDAT; 
Error_Message = "No target tumor(s) identified.";
NonTargetOnly = "&nontargetonly.";
if upcase(NonTargetOnly) = 'N' then output;
run;

/*Output when there are no non-target tumors identified. Only output as an issue when study specific parameter “non-target disease only” = Y 
  AND patient is missing from TU3001 AND patient does not have a record in the DS1001 dataset where PAGE = DS1001_LF1.*/
/*Error message:  No non-target tumor(s) identified.*/

data part4a;
merge dm1001(in=a) tu3001(in=b) ds1001(in=c);
by SUBJID;
if a and not b and not c;
run;

data part4(keep=Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message);
format Site $32. Subject 11. Tumor_ID $50. Assessment_Num 5. Date_of_Last_Scan date9. Date_of_Next_Scan date9. C1D1_Dose_Date date9. Error_Message $50.;
merge part4a(in=a) ex1001 site;
by SUBJID;
if a;
Site = SITEMNEMONIC;
Subject = SUBJID;
Tumor_ID = '';
Assessment_Num = .;
Date_of_Last_Scan = .; 
Date_of_Next_Scan = .; 
C1D1_Dose_Date = EXSTDAT; 
Error_Message = "No non-target tumor(s) identified.";
NonTargetOnly = "&nontargetonly.";
if upcase(NonTargetOnly) = 'Y' then output;
run;

/*Output when there is not at least 1 assessment (TRSPID) entered for every TULNKID.  */
/*Error message:  No assessment entered for this tumor id.*/

data tumor_nospid
	 tumor_spid;
set tumor;
where TULNKID ne '';
if TRSPID = . then output tumor_nospid;
else output tumor_spid;
run;

proc sort data = tumor_nospid; by SUBJID TULNKID; run;
proc sort data = tumor_spid; by SUBJID TULNKID; run;

data part5a;
merge tumor_nospid(in=a) tumor_spid(in=b);
by SUBJID TULNKID;
if a and not b;
run;

data part5(keep=Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message);
format Site $32. Subject 11. Tumor_ID $50. Assessment_Num 5. Date_of_Last_Scan date9. Date_of_Next_Scan date9. C1D1_Dose_Date date9. Error_Message $50.;
merge part5a(in=a) ex1001 site;
by SUBJID;
if a;
Site = SITEMNEMONIC;
Subject = SUBJID;
Tumor_ID = TULNKID;
Assessment_Num = TRSPID;
Date_of_Last_Scan = .; 
Date_of_Next_Scan = .; 
C1D1_Dose_Date = EXSTDAT; 
Error_Message = "No assessment entered for this tumor id.";
run;

/*Set Part 1-5 together for final output*/

data ONC_TU219_TU318_(keep = Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message);
retain Site Subject Tumor_ID Assessment_Num Date_of_Last_Scan Date_of_Next_Scan C1D1_Dose_Date Error_Message; 
set part1
    part2
    part3
    part4
    part5;
label Site = "Site"
	  Subject  = "Subject"
	  Tumor_ID = "Tumor ID"
	  Assessment_Num = "Assessment #"
	  Date_of_Last_Scan = "Date of Last Scan"
	  Date_of_Next_Scan = "Date of Next Scan"
	  C1D1_Dose_Date = "C1D1 Dose Date"
	  Error_Message = "Error Message";
run;

proc sql;
create table ONC_TU219_TU318 as
select distinct (trim(upcase(substr(a.SDYID,8,4)))) as Study format = $4. label = "Study", b.*
from clntrial.IVRSTSA a, ONC_TU219_TU318_ b
order by b.Subject, b.Tumor_ID, b.Assessment_Num;
quit;

/*Print ONC_TU219_TU318*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "ONC_TU219_TU318";
title2 "Exceptation based report to know what tumor assessments are missing for the study by subject.";
  proc print data=ONC_TU219_TU318 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set ONC_TU219_TU318 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;


