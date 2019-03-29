/*
|| File: DisplayOverride.sql
||
|| Purpose: To Spool the Query Count listing 
||
|| MODIFICATION HISTORY

|| Person            Date               Comments
|| ---------         ---------          ---------------------------------
|| Hetvi Sanghvi     13/05/2013
|| Venkata S G	     09/05/2014
|| Anisha Kukreja	 02/12/2016			v1.2 of the report sql
*/

set echo off;
set feedback off;
set heading  off;
set linesize 300;
set pagesize 0;
set termout off;
set verify off;
set trimspool on;
spool off

spool display_overrides.csv

select '"Trial","Rights Group","Rights Group View","Item Group","Description","Item RefName","Itemset RefName","Form Mnemonic"' from dual;
        
SELECT '"'||V.STUDYNAME||'","'|| DISPOVER.RIGHTS_GROUP||'","'|| DISPOVER.DISP_OVER||'","'|| DISPOVER.ITEM_GROUP||'","'|| DISPOVER.DESCRIPTION||'","'|| DISPOVER.ITEMREFNAME||'", "'|| DISPOVER.ITEMSETREFNAME||'", "'|| DISPOVER.FRMNAME||'"' 
FROM  
(   
SELECT RGT.*, 
        TD.DESCRIPTION,
        GRP1.GROUPNAME AS ITEM_GROUP, 
        GRP1.GROUPTYPENAME AS GRPTYPENAME1,
        GRP1.GROUPID ,
        IGI.ITEMID ,
        IGI.ITEMREFNAME,
        IGI.Itemsetrefname,
        pfr.frmname
        FROM
       (
        SELECT GRP.GROUPID, 
                GRP.GROUPNAME AS RIGHTS_GROUP, 
                GRP.GROUPTYPENAME, 
                RIG.ITEMGROUPID, 
                DECODE(RIG.DISPLAYOVERRIDETYPE,1,'READ-ONLY',2,'EDITABLE',3,'HIDDEN',RIG.DISPLAYOVERRIDETYPE) AS DISP_OVER 
            FROM PF_GROUP GRP, PF_RIGHTSGROUPITEMGROUPS RIG
            WHERE GRP.GROUPID = RIG.RIGHTSGROUPID
            and RIG.itemgrouplistrevisionnumber=
            ( SELECT MAX(PRG1.ITEMGROUPLISTREVISIONNUMBER) FROM PF_RIGHTSGROUPITEMGROUPS PRG1
              WHERE  RIG.ITEMGROUPID=PRG1.ITEMGROUPID
              AND RIG.RIGHTSGROUPID=PRG1.RIGHTSGROUPID 
            )
            AND  RIG.DISPLAYOVERRIDETYPE<>0
        ) RGT
    LEFT OUTER JOIN
        PF_GROUP GRP1 
        ON GRP1.GROUPID = RGT.ITEMGROUPID
    LEFT OUTER JOIN
            (
        select igi1.itemgroupid Groupitemid,
        case  when itr.itemid is not null then itr.itemid else pfitem.itemid end as itemid,
        case  when itr.itemid is not null then  itr.itemrefname else  pfitem.itemrefname end as itemrefname,
        case  when itr.itemid is not null then  pfitem.itemrefname else  null end as itemsetrefname
        from 
        (
          select * from PF_ITEMGROUPitems igi
                WHERE IGi.ITEMLISTREVISIONNUMBER = 
                        (SELECT MAX(IG1.ITEMLISTREVISIONNUMBER) 
                            FROM PF_ITEMGROUPITEMS IG1 
                            WHERE IG1.ITEMID = IGi.ITEMID
                        )
                and  not exists (
                select 1 from pf_itemgroup pg,PF_ITEMGROUPitems igi2
                where igi.itemid=igi2.itemid
                and pg.childitemid=igi2.itemid
                and pg.groupitemid in  ( select itemid from PF_ITEMGROUPitems igi3 where igi2.itemgroupid=igi3.itemgroupid
                 and igi3.ITEMLISTREVISIONNUMBER = 
                        (SELECT MAX(IG1.ITEMLISTREVISIONNUMBER) 
                            FROM PF_ITEMGROUPITEMS IG1 
                            WHERE IG1.ITEMID = IGi3.ITEMID
                        ) )
                and igi.itemgroupid=igi2.itemgroupid
                )
                           ) igi1
          left outer join pf_itemgroup ig
          on  igi1.itemid=ig.groupitemid
          left outer join ( select * from pf_item itm1 where ITM1.ITEMREVISIONNUMBER = 
                    (
                    SELECT MAX(ITM2.ITEMREVISIONNUMBER) 
                        FROM PF_ITEM ITM2 
                        WHERE ITM1.ITEMID = ITM2.ITEMID
                    )) pfitem
          on pfitem.itemid=igi1.itemid
          left outer join rt_item_revs itr
          on itr.itemid=ig.childitemid
          and itr.currentrev=1
            ) IGI
        ON IGI.GROUPITEMID = GRP1.GROUPID
      LEFT OUTER JOIN 
        (
            SELECT MAX(CASE WHEN ATTRIBUTENAME = 'GroupName' THEN STRVALUE END)         ROLENAME,
               MAX(CASE WHEN ATTRIBUTENAME = 'GroupDescription' THEN STRVALUE END)   DESCRIPTION,
               TYPENAME
            FROM DCV_THINGDATA 
            GROUP BY THINGID, TYPENAME
        )TD 
        ON TD.TYPENAME = GRP1.GROUPTYPENAME 
        AND TD.ROLENAME = GRP1.GROUPNAME  
  left outer join
    (
      select   pfitem.itemid itemid,pfp.pagemnemonic frmno from pf_page pfp 
      left outer join pf_pagesection pfpgsec on
      pfp.pageid = pfpgsec.pageid and
      pfp.pagerevisionnumber =  pfpgsec.pagerevisionnumber 
      left outer join pf_section pfsec on
      pfpgsec.sectionid = pfsec.sectionid and
      pfpgsec.sectionrevisionnumber=pfsec.sectionrevisionnumber 
      left outer join  pf_sectionitem pfscit on
      pfscit.sectionid = pfsec.sectionid and 
      pfscit.sectionrevisionnumber = pfsec.sectionrevisionnumber 
      left outer join pf_item pfitem
      on pfitem.itemid=pfscit.itemid 
      and pfitem.itemrevisionnumber= pfscit.itemrevisionnumber
      union all
     select    pfi.childitemid itemid,pfp.pagemnemonic frmno from pf_page pfp 
      left outer join pf_pagesection pfpgsec on
      pfp.pageid = pfpgsec.pageid and
      pfp.pagerevisionnumber =  pfpgsec.pagerevisionnumber 
      left outer join pf_section pfsec on
      pfpgsec.sectionid = pfsec.sectionid and
      pfpgsec.sectionrevisionnumber=pfsec.sectionrevisionnumber 
      left outer join  pf_sectionitem pfscit on
      pfscit.sectionid = pfsec.sectionid and 
      pfscit.sectionrevisionnumber = pfsec.sectionrevisionnumber 
      left outer join  pf_item   pfitem
      on pfitem.itemid=pfscit.itemid 
      and pfitem.itemrevisionnumber= pfscit.itemrevisionnumber
      join pf_itemgroup pfi
      on pfi.groupitemid=pfitem.itemid
      and pfi.groupitemrevisionnumber=pfitem.itemrevisionnumber) frmmemonic
    on frmmemonic.ITEMID =IGI.ITEMID 
    join 
    (select resourceid, resourcestring frmname from pf_resourcedata
     where languageid=2
    ) pfr
    on pfr.resourceid= frmmemonic.frmno
)DISPOVER, 
PF_VOLUME V 
WHERE V.STUDYNAME NOT LIKE '%InForm%'
order by Rights_Group, Item_Group, Frmname, Itemsetrefname , itemrefname;

/

spool off

exit;