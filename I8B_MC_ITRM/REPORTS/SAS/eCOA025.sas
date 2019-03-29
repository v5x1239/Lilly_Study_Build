/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA025.sas
PROJECT NAME (required)           : I8B-MC-ITRM
DESCRIPTION (required)            : Patient reported "Coma, Loss of Consciousness, Seizure or Emergency Room Visit” and then answers “SUBJECT TREATED SELF” or “SUBJECT CAPABLE OF TREATING SELF BUT RECEIVED ASSISTANCE”
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

/*eCOA025*/
/*Patient reported "Coma, Loss of Consciousness, Seizure or Emergency Room Visit” and then answers “SUBJECT TREATED SELF” or “SUBJECT CAPABLE OF TREATING SELF BUT RECEIVED ASSISTANCE”*/

proc sql;
create table eCOA025 as
select upcase(substr(&irprot.,1,11)) as STUDY label 'Study', SITECODE label 'Site', SUBJID label 'Subject ID', 
HYPOSTDAT, HYPOSTTIM, ECOASTDT, HYPOTRTPRV, HYPOSER, HYPOOUT_A, HYPOOUT_E, HYPOOUT_F, HYPOACNOTH_B  
from CLUWE.hypo1001_ecoa where HYPOTRTPRV in ('SUBJECT TREATED SELF', 'SUBJECT CAPABLE OF TREATING SELF BUT RECEIVED ASSISTANCE')
				               and (HYPOOUT_A = 'COMA' OR HYPOOUT_E = 'SEIZURE' or HYPOOUT_F = 'LOSS OF CONSCIOUSNESS' OR HYPOACNOTH_B = 'EMERGENCY ROOM VISIT'); quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA025";
  title2 "Reconcile HYPO across three different data bases (eCOA, Inform & LSS) where all systems should have the event as a serious Hypoglycemia";

proc print data=eCOA025 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA025 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
