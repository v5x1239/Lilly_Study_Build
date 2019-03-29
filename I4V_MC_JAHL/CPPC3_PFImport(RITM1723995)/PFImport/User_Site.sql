--  File        : User_Site.sql                                                 
--  Date        : 02-Aug-2018			 		                        
--  Author      : Pandiarajan Pandidurai                                      

--  Description : This script will spool the xml file with all LIVE sites to associate the user PFImport with those sites. 

--  Usage       : Sqlplus <trialuid>/<trialpid>@<oracle_instance> @User_Site.sql

SET NEWPAGE 0
SET SPACE 0
SET PAGESIZE 0
SET ECHO OFF
SET FEEDBACK OFF
SET HEADING OFF
SET TRIMSPOOL ON
SET LINESIZE 32767
SET COLSEP ,
SET SHOW OFF
SET SHOWMODE OFF
SET VERIFY OFF

Spool User_Site.xml

select '<?xml version="1.0"?>' from dual;

select CHR(10)||'<MEDMLDATA xmlns="PhaseForward-MedML-Inform4">' from dual;

select CHR(10)||'<SITEGROUP SITENAME="'||sitename||'">'||CHR(10)||'<USERREF USERNAME="PFImport1"/>'||CHR(10)||'</SITEGROUP>'||CHR(10)
from pf_site;

select CHR(10)||'</MEDMLDATA>' from dual;

exit;