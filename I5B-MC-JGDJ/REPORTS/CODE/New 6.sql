SELECT SUBJID, MHSPID,MHTERM,MHDECOD,case 
 when MHSTDATYY is not null then (STDT||'/'||STMO||'/'||MHSTDATYY)
 else ''
 end AS MHSTDAT,
 case 
 when MHENDATYY is not null then (EDDT||'/'||EDMO||'/'||MHENDATYY)
 else ''
 end AS MHENDAT
 ,
 MHONGO,MHTOXGR
 FROM
 (select  SUBJID, MHSPID,MHTERM,MHDECOD,
 replace(MHSTDATMO,'-99', 'UNK') AS STMO,
 replace(MHSTDATDD,'-99', 'UNK') AS STDT,
 MHSTDATYY,
 replace(MHENDATMO,'-99', 'UNK') AS EDMO,
 replace(MHENDATDD,'-99', 'UNK') AS EDDT,
 MHENDATYY,
   MHONGO,MHTOXGR  
    from I5B_MC_JGDJ.MH8001_all
    where page = 'MH8001_LF1') X