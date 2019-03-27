/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : SYST502.sas
PROJECT NAME (required)           : I3Y-MC-JPBX
DESCRIPTION (required)            : Ensure that prior regimens are appropriate per protocol.
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : 
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : EX1001
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

/*Add code here*/
proc sql;
	create table SYST502  as
	select distinct a.SUBJID, a.blockid, a.page, PRSPID, IRDSTDT, IRADENDAT, IRADRSRGM, 
	IRADONGO, IRADLOC, IRADLOCOTH, IRADDOSTOTU, PRCAT, PRSCAT, PRTRT_IRAD, PRPRESP,
	case
	when not missing (IRADENDAT) and not missing (VISDAT) then datepart (VISDAT) - datepart (IRADENDAT)
	else . end as diff,
	case 
	when not missing (calculated diff) and calculated diff lt 21 then 'Radiotherapy end date is less than 21 days compared to C1 date'
	else '' end as flag
	
	from clntrial.IRA3001_ a left join ( select * from clntrial.SV1001_D where BLOCKID='1') b
	on a.SUBJID=b.SUBJID
	where datepart(a.MERGE_DATETIME) > input("&date",Date9.) and not missing (PRSPID)
	order by SUBJID;
quit;




/*Print SYST502*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Ensure that prior regimens are appropriate per protocol.";



  proc print data=SYST502 noobs WIDTH=min; 
    var _all_;
  run;
  
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set SYST502 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;




