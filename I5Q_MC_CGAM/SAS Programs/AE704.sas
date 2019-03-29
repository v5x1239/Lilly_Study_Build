/*
Eli Lilly and Company (required) - DSS
CODE NAME (required)              : AE704.sas
PROJECT NAME (required)           : I5Q-MC-CGAL
DESCRIPTION (required)            : Confirm the Infection Follow-Up Form is completed for the necessary terms per the PT list provided
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
data AE704 (KEEP=SUBJID AEGRIPID AETERM AEDECOD);
	set clntrial.ae_dump;
	if upcase (AEDECOD) in 
	("ACUTE SINUSITIS",
"ACUTE TONSILLITIS",
"ADENOIDITIS",
"CELLULITIS LARYNGEAL",
"CELLULITIS PHARYNGEAL",
"CHRONIC SINUSITIS",
"CHRONIC TONSILLITIS",
"CROUP INFECTIOUS",
"EPIGLOTTITIS",
"EPIGLOTTITIS OBSTRUCTIVE",
"LARYNGITIS",
"LARYNGOTRACHEITIS OBSTRUCTIVE",
"NASAL ABSCESS",
"NASAL VESTIBULITIS",
"NASOPHARYNGITIS",
"PERITONSILLAR ABSCESS",
"PERITONSILLITIS",
"PHARYNGEAL ABSCESS",
"PHARYNGITIS",
"PHARYNGOLARYNGEAL ABSCESS",
"PHARYNGOTONSILLITIS",
"PSEUDOCROUP",
"RHINITIS",
"RHINOLARYNGITIS",
"RHINOTRACHEITIS",
"SINOBRONCHITIS",
"SINUSITIS",
"THORNWALDT DISEASE",
"TONSILLITIS",
"TRACHEITIS",
"TRACHEITIS OBSTRUCTIVE",
"TRACHEOBRONCHITIS",
"TRACHEOSTOMY INFECTION",
"UPPER AERODIGESTIVE TRACT INFECTION",
"UPPER RESPIRATORY TRACT INFECTION",
"ACUTE SINUSITIS",
"ACUTE TONSILLITIS",
"ADENOIDITIS",
"CELLULITIS LARYNGEAL",
"CELLULITIS PHARYNGEAL",
"CHRONIC SINUSITIS",
"CHRONIC TONSILLITIS",
"CROUP INFECTIOUS",
"EPIGLOTTITIS",
"EPIGLOTTITIS OBSTRUCTIVE",
"FUNGAL RHINITIS",
"FUNGAL TRACHEITIS",
"LARYNGITIS",
"LARYNGITIS FUNGAL",
"LARYNGOTRACHEITIS OBSTRUCTIVE",
"NASAL ABSCESS",
"NASAL CANDIDIASIS",
"NASAL VESTIBULITIS",
"NASOPHARYNGITIS",
"ORO-PHARYNGEAL ASPERGILLOSIS",
"OROPHARYNGEAL CANDIDIASIS",
"OROPHARYNGITIS FUNGAL",
"PERITONSILLAR ABSCESS",
"PERITONSILLITIS",
"PHARYNGEAL ABSCESS",
"PHARYNGEAL CHLAMYDIA INFECTION",
"PHARYNGITIS",
"PHARYNGITIS MYCOPLASMAL",
"PHARYNGOCONJUNCTIVAL FEVER OF CHILDREN",
"PHARYNGOLARYNGEAL ABSCESS",
"PHARYNGOTONSILLITIS",
"PSEUDOCROUP",
"RHINITIS",
"RHINOLARYNGITIS",
"RHINOTRACHEITIS",
"SINOBRONCHITIS",
"SINUSITIS",
"SINUSITIS ASPERGILLUS",
"SINUSITIS FUNGAL",
"THORNWALDT DISEASE",
"TONSILLITIS",
"TONSILLITIS FUNGAL",
"TRACHEITIS",
"TRACHEITIS OBSTRUCTIVE",
"TRACHEOBRONCHITIS",
"TRACHEOBRONCHITIS MYCOPLASMAL",
"UPPER AERODIGESTIVE TRACT INFECTION",
"UPPER RESPIRATORY FUNGAL INFECTION",
"UPPER RESPIRATORY TRACT INFECTION",
"UPPER RESPIRATORY TRACT INFECTION HELMINTHIC");
if datepart(MERGE_DATETIME) > input("&date",Date9.);

run;


/*Print AE704*/ * Replace AA001 with report name;
ods csv file=&irfilcsv trantab=ascii;
  title1 "Confirm the Infection Follow-Up Form is completed";
	title2 "for the necessary terms per the PT list provided";
  proc print data=AE704 noobs WIDTH=min; 
    var _all_;
  run;
ods csv close;

/*Create output for no observations*/
data _null_;
file print;
if 0 then set AE704 nobs=NUM; 
if NUM=0 then do;
        put /// @21 "There are no records found";
        end;
stop;
run;
