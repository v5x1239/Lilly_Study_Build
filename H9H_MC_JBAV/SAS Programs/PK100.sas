/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : PK_Listings.sas
PROJECT NAME (required)           : IR1-MC-GLDI
DESCRIPTION (required)            : Missing required visits and freq
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : CIV1001_F1, SV1001_F1, SV1001_F1
OUTPUT                            : CSV
SPECIAL INSTRUCTIONS              : N/A
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
DOCUMENTATION AND REVISION HISTORY SECTION (required):

       Author &
Ver# Validator        Code History Description
---- ------------     ------------------------------------------------------------------------
1.0  Joe Cooney    Original version of the code

/***********************************************************************/
/*************              Programming Section           **************/
/***********************************************************************/

data subjects(keep=subjid);
set clntrial.dm1001;
proc sort nodupkey; by subjid; run;

data exp_visits_;
  input visit_ $ count_ $;
  datalines;
4 2
5 1
6 1
8 1
9 2
10 1
11 1
12 1
;
run;

%macro replace_carraige_returns (dset);

	%macro process_carraige_returns (var);
		&var = translate(&var, ' ', "%sysfunc(byte(13))", 
							   ' ', "%sysfunc(byte(10))",
							   ' ', "09"x, 
							   ' ', "%sysfunc(byte(9))",
							   ' ', "0A"x,
							   ' ', "08"x,
							   ' ', "0B"x,
							   ' ', "0C"x,
							   ' ', "0D"x,
							   ' ', "0E"x,
							   ' ', "0F"x);
	%mend process_carraige_returns;

	proc contents data = &dset out = pc_tmp (keep = name type
										 	 where = (type EQ 2)) noprint; 
	run;

	proc sql noprint;
		select catt('%process_carraige_returns(', strip(name), ')')
		into :process_list separated by ' '
		from pc_tmp;

		drop table pc_tmp;
	quit;

	data &dset;
		set &dset;

		&process_list;
	run;

%mend replace_carraige_returns;

%replace_carraige_returns (exp_visits_);

data exp_visits;
  format visit 6. count best12.;
set exp_visits_;
  visit = input(visit_,6.);
  count = input(count_,12.);
 drop visit_ count_;
run;

proc sql;
create table exp_visits_ as
select a.*, b.*
from subjects a, exp_visits b
order by a.subjid, b.visit;
quit;

data ds(keep=subjid visit count);
format visit 6. count best12.;
set clntrial.ds1001;
visit = input(blockid, 6.);
count = 1;
proc sort nodup; by subjid visit; run;

data ds_exp_visits;
set exp_visits_ ds;
freq = count;
proc sort nodup; by subjid visit count; run;

data pk;
set CLNTRIAL.LABRSLTA;
where LBTESTCD = "S45";
run;

proc freq data=pk noprint;
  table subjid*visid / missing nopercent norow nocol out=PK_Visit(drop=percent rename=(visid = visit));
proc sort; by subjid visit count; run;

data pk_visit_;
set pk_visit;
if count > 2 then count = 2;
count2 = count;
run;

data pk100_;
merge ds_exp_visits(in=a) pk_visit_(in=b);
by subjid visit count;
if a and not b;
/*if count2 = . then count2 = 0;*/
run;

data pk100;
merge pk100_(in=a) pk_visit_;
by subjid visit;
if a;
freq2 = freq - count2;
if freq2 ne . then count = freq2;
drop count2 freq2 freq;
run;

/*Print list of exception terms.*/
ods csv file=&irfilcsv trantab=ascii;
  title1 "Missing required visits and freq";
  proc print data=pk100 noobs WIDTH=min;
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set pk100 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
