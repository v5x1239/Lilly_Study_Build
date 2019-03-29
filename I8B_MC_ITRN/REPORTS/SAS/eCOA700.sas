/*************************************** Start of Header ****************************************
Company (required) -              : Lilly
CODE NAME (required)              : eCOA700.sas
PROJECT NAME (required)           : I8B-MC-ITRN
DESCRIPTION (required)            : If SAE for Hypoglycaemia exists in Inform, a corresponding Cognitive Impairment/Severe Episode for Hypoglycemic Event should be indicated in eCOA.
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

/*eCOA700*/
/*If SAE for Hypoglycaemia exists in Inform, a corresponding Cognitive Impairment/Severe Episode for Hypoglycemic Event should be indicated in eCOA.*/


/**/
/*proc sql;*/
/*create table eCOA700 as*/
/*select o.SITEMNEMONIC label 'SITE', a.SUBJID, AEGRPID, AETERM, AEDECOD, */
/*AESPID, AESTDAT, AEONGO, AEENDAT, AESER, SUBJECT, ECOAASMDT, HYPOSTDT, HYPOTRTPRV, HYPOSER, HYPOEVAL, FLAG */
/*from ( (select a.*, subject, ECOAASMDT, HYPOSTDT, HYPOTRTPRV, HYPOSER, HYPOEVAL, 'No records in Hypo1001_ecoa with HYPOSER = YES' as FLAG */
/*from (select distinct a.subjid, a.subject_id, a.aegrpid, a.aeterm, a.aedecod, b.aespid, */
/*input(catx("-",b.AESTDATMO,b.AESTDATDD,b.AESTDATYY),mmddyy10.) as AESTDAT format date9., b.aeongo, */
/*input(catx("-",b.AEENDATMO,b.AEENDATDD,b.AEENDATYY),mmddyy10.) as AEENDAT format date9., b.aeser */
/*from cluwe.ae3001a a, cluwe.ae3001b b where a.subjid = b.subjid */
/*and a.aegrpid = b.aegrpid and b. aeser = 'Y' and aedecod = 'Hypoglycaemia') a left join*/
/*(select distinct SUBJID, SUBJECT, input(catx("-",substr(ECOAASMDT,6,2),substr(ECOAASMDT,9,2),substr(ECOAASMDT,1,4)),mmddyy10.) as ECOAASMDT format date9., */
/*input(catx("-",HYPOSTDATMO,HYPOSTDATDD,HYPOSTDATYY),mmddyy10.) as HYPOSTDT format date9., HYPOTRTPRV, HYPOSER, HYPOEVAL */
/*from CLUWE.hypo1001_ecoa where hyposer = 'YES' and HYPOEVAL = 'INVESTIGATOR') b on a.subjid = b.subjid and a.aestdat = b.hypostdt where b.subject is null*/
/*union all*/
/*(select a.*, subject, ECOAASMDT, HYPOSTDT, HYPOTRTPRV, HYPOSER, HYPOEVAL, 'No records in Hypo1001_ecoa with matching HYPOSTDT' as FLAG */
/*from (select distinct a.subjid, a.subject_id, a.aegrpid, a.aeterm, a.aedecod, b.aespid, */
/*input(catx("-",b.AESTDATMO,b.AESTDATDD,b.AESTDATYY),mmddyy10.) as AESTDAT format date9., b.aeongo, */
/*input(catx("-",b.AEENDATMO,b.AEENDATDD,b.AEENDATYY),mmddyy10.) as AEENDAT format date9., b.aeser */
/*from cluwe.ae3001a a, cluwe.ae3001b b where a.subjid = b.subjid */
/*and a.aegrpid = b.aegrpid and b. aeser = 'Y' and aedecod = 'Hypoglycaemia') a left join*/
/*(select distinct SUBJID, SUBJECT, input(catx("-",substr(ECOAASMDT,6,2),substr(ECOAASMDT,9,2),substr(ECOAASMDT,1,4)),mmddyy10.) as ECOAASMDT format date9., */
/*input(catx("-",HYPOSTDATMO,HYPOSTDATDD,HYPOSTDATYY),mmddyy10.) as HYPOSTDT format date9., HYPOTRTPRV, HYPOSER, HYPOEVAL */
/*from CLUWE.hypo1001_ecoa) b on a.subjid = b.subjid and a.aestdat = b.hypostdt where b.subjid is null)) a LEFT JOIN */
/*(SELECT sb.subject_id, st.SITEMNEMONIC*/
/*FROM CLUWE.inf_subject sb,*/
/*CLUWE.inf_site_update st*/
/*WHERE sb.SITEGUID = st.CT_RECID) o*/
/*ON a.SUBJECT_ID = o.subject_id); quit;*/

proc sql;
create table eCOA700 as
select SITEMNEMONIC label 'SITE', a.SUBJID, AEGRPID, AETERM, AEDECOD, 
AESPID, AESTDAT, AEONGO, AEENDAT, AESER 
from (select a.*
from (select distinct st.SITEMNEMONIC, a.subjid, a.subject_id, a.aegrpid, a.aeterm, a.aedecod, b.aespid, 
input(catx("-",b.AESTDATMO,b.AESTDATDD,b.AESTDATYY),mmddyy10.) as AESTDAT format date9., b.aeongo, 
input(catx("-",b.AEENDATMO,b.AEENDATDD,b.AEENDATYY),mmddyy10.) as AEENDAT format date9., b.aeser 
from cluwe.ae3001a a, cluwe.ae3001b b, CLUWE.inf_subject sb,
CLUWE.inf_site_update st where a.subjid = b.subjid and a.aegrpid = b.aegrpid and b. aeser = 'Y' and aedecod = 'Hypoglycaemia'
and a.subject_id = sb.subject_id and sb.siteguid = st.ct_recid) a 
left join
(select distinct SUBJID, SUBJECT, input(catx("-",substr(ECOAASMDT,6,2),substr(ECOAASMDT,9,2),substr(ECOAASMDT,1,4)),mmddyy10.) as ECOAASMDT format date9., 
input(catx("-",HYPOSTDATMO,HYPOSTDATDD,HYPOSTDATYY),mmddyy10.) as HYPOSTDT format date9., HYPOTRTPRV, HYPOSER, HYPOEVAL 
from CLUWE.hypo1001_ecoa where hyposer = 'YES' and HYPOEVAL = 'INVESTIGATOR') b on a.subjid = b.subjid and a.aestdat = b.hypostdt where b.subject is null)
left join
(select distinct SUBJID, SUBJECT, input(catx("-",substr(ECOAASMDT,6,2),substr(ECOAASMDT,9,2),substr(ECOAASMDT,1,4)),mmddyy10.) as ECOAASMDT format date9., 
input(catx("-",HYPOSTDATMO,HYPOSTDATDD,HYPOSTDATYY),mmddyy10.) as HYPOSTDT format date9., HYPOTRTPRV, HYPOSER, HYPOEVAL 
from CLUWE.hypo1001_ecoa) c on a.subjid = c.subjid and a.aestdat = c.hypostdt where c.subjid is null; quit;

ods csv file=&irfilcsv trantab=ascii;
  title1 "eCOA700";
  title2 "If SAE for Hypoglycaemia exists in Inform, a corresponding Cognitive Impairment/Severe Episode for Hypoglycemic Event should be indicated in eCOA.";

proc print data=eCOA700 noobs label WIDTH=min;
    var _all_;
  run;

ods csv close;

data _null_;
file print;
if 0 then set eCOA700 nobs=NUM;
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;

