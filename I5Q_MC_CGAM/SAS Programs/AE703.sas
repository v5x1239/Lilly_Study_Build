/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE703.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Confirm the Injection Site Recation Follow-Up Form is completed for the necessary terms per the PT list provided
SPECIFICATIONS (required)         : N/A
VALIDATION TYPE (required)        : Formal validation not required – study specific data verification report
INDEPENDENT REPLICATION (required): N/A
ORIGINAL CODE (required)          : N/A, this is the original code
COMPONENT CODE MODULES            : N/A
SOFTWARE/VERSION# (required)      : JReview 9.2.4
INFRASTRUCTURE                    : Database server-firehawk.am.lilly.com:PRD779
									SAS Server-firehawk.am.lilly.com
DATA INPUT                        : IWRS DS
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
data AE703 (KEEP=SUBJID AEGRIPID AETERM AEDECOD);
	set clntrial.ae_dump;
	if upcase (AEDECOD) in 
	("EMBOLIA CUTIS MEDICAMENTOSA",
"INJECTED LIMB MOBILITY DECREASED",
"INJECTION SITE ABSCESS",
"INJECTION SITE ABSCESS STERILE",
"INJECTION SITE ANAESTHESIA",
"INJECTION SITE ATROPHY",
"INJECTION SITE BRUISING",
"INJECTION SITE CALCIFICATION",
"INJECTION SITE CELLULITIS",
"INJECTION SITE COLDNESS",
"INJECTION SITE CYST",
"INJECTION SITE DERMATITIS",
"INJECTION SITE DISCHARGE",
"INJECTION SITE DISCOLOURATION",
"INJECTION SITE DISCOMFORT",
"INJECTION SITE DRYNESS",
"INJECTION SITE DYSAESTHESIA",
"INJECTION SITE ECZEMA",
"INJECTION SITE EROSION",
"INJECTION SITE ERYTHEMA",
"INJECTION SITE EXFOLIATION",
"INJECTION SITE EXTRAVASATION",
"INJECTION SITE FIBROSIS",
"INJECTION SITE GRANULOMA",
"INJECTION SITE HAEMATOMA",
"INJECTION SITE HAEMORRHAGE",
"INJECTION SITE HYPERAESTHESIA",
"INJECTION SITE HYPERSENSITIVITY",
"INJECTION SITE HYPERTROPHY",
"INJECTION SITE HYPOAESTHESIA",
"INJECTION SITE INDURATION",
"INJECTION SITE INFECTION",
"INJECTION SITE INFLAMMATION",
"INJECTION SITE INJURY",
"INJECTION SITE IRRITATION",
"INJECTION SITE ISCHAEMIA",
"INJECTION SITE JOINT DISCOMFORT",
"INJECTION SITE JOINT EFFUSION",
"INJECTION SITE JOINT INFECTION",
"INJECTION SITE JOINT INFLAMMATION",
"INJECTION SITE JOINT MOVEMENT IMPAIRMENT",
"INJECTION SITE JOINT PAIN",
"INJECTION SITE JOINT REDNESS",
"INJECTION SITE JOINT SWELLING",
"INJECTION SITE JOINT WARMTH",
"INJECTION SITE LACERATION",
"INJECTION SITE LYMPHADENOPATHY",
"INJECTION SITE MACULE",
"INJECTION SITE MASS",
"INJECTION SITE MOVEMENT IMPAIRMENT",
"INJECTION SITE NECROSIS",
"INJECTION SITE NERVE DAMAGE",
"INJECTION SITE NODULE",
"INJECTION SITE OEDEMA",
"INJECTION SITE PAIN",
"INJECTION SITE PALLOR",
"INJECTION SITE PAPULE",
"INJECTION SITE PARAESTHESIA",
"INJECTION SITE PHLEBITIS",
"INJECTION SITE PHOTOSENSITIVITY REACTION",
"INJECTION SITE PLAQUE",
"INJECTION SITE PRURITUS",
"INJECTION SITE PUSTULE",
"INJECTION SITE RASH",
"INJECTION SITE REACTION",
"INJECTION SITE RECALL REACTION",
"INJECTION SITE SCAB",
"INJECTION SITE SCAR",
"INJECTION SITE STREAKING",
"INJECTION SITE SWELLING",
"INJECTION SITE THROMBOSIS",
"INJECTION SITE ULCER",
"INJECTION SITE URTICARIA",
"INJECTION SITE VASCULITIS",
"INJECTION SITE VESICLES",
"INJECTION SITE WARMTH",
"MALABSORPTION FROM INJECTION SITE");
if datepart(MERGE_DATETIME) > input("&date",Date9.);

run;


/*Print AE703*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Confirm the Injection Site Recation Follow-Up Form";
	title2 "is completed for the necessary terms per the PT list provided";
  proc print data=AE703 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE703 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
