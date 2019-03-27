SET SERVEROUTPUT ON FORMAT WRAPPED
Set heading off
set pagesize 0
set linesize 2000
set term off
set trimspool on
set trimout on
set feedback off
set verify off
Spool CreateUpdateGUIDs.sql

CREATE OR REPLACE PROCEDURE proc_get_coding_GUIDs IS

/********************************************************************
  Main Cursor, grabs the most recent revision Numbers
 ********************************************************************/
  CURSOR cu_get_coding_GUIDs IS
     select t.tdetargetid,
           t.tdetargetsetid,
           t.tdetargetsetrevisionnumber,
           d.guid,
           t.pathchapterid,
           t.PATHPAGEID,
           t.pathsectionid,
           t.pathitemsetid,
           t.pathitemid,
           t.pathcontrol1id,
           t.pathcontrol2id,
           t.pathcontrol3id,
           t.pathcontrol4id,
           t.pathcontrol5id
      from pf_tdepathtarget t, pf_dbuid d
     where t.tdetargetsetid in
           (select ts.tdetargetsetid
              from pf_tdetargetset ts
             where ts.type = 'CODINGMAP')
       and t.tdetargetsetrevisionnumber in
           (select max(ts.tdetargetsetrevisionnumber)
              from pf_tdetargetset ts
             where ts.type = 'CODINGMAP'
             and ts.tdetargetsetid=t.tdetargetsetid)
       and t.tdetargetid = d.dbuid;

  /****************************************************
    Output Files
   ****************************************************/

   --Update File

Begin
DBMS_OUTPUT.ENABLE(1000000);
dbms_output.put_line('SET SERVEROUTPUT ON FORMAT WRAPPED');
dbms_output.put_line('Set heading on');
dbms_output.put_line('set pagesize 0');
dbms_output.put_line('set linesize 2000');
dbms_output.put_line('set term on');
dbms_output.put_line('set trimspool on');
dbms_output.put_line('set feedback on');
dbms_output.put_line('set verify on');
dbms_output.put_line('spool UpdateGUIDs.log');
dbms_output.put_line(' ');

  --Write Static File Update Elements

    dbms_output.put_line('call tra_pkg.start_tx(''Update to current mapping GUID'',1);');
    
  --Start Main Loop
  for id_rec in cu_get_coding_GUIDs loop
    Declare
        CURSOR cu_get_old_coding_GUIDs IS
    select t.tdetargetsetrevisionnumber,
           d.guid,
           t.PATHPAGEID
      from pf_tdepathtarget t, pf_dbuid d
     where t.tdetargetsetid in
           (select ts.tdetargetsetid
              from pf_tdetargetset ts
             where ts.type = 'CODINGMAP')
       and t.tdetargetid = d.dbuid
       and t.tdetargetsetrevisionnumber < id_rec.tdetargetsetrevisionnumber
       and t.PATHPAGEID = id_rec.PATHPAGEID
       and nvl(t.pathchapterid,-200) = nvl(id_rec.pathchapterid,-200)
       and nvl(t.pathsectionid,-201) = nvl(id_rec.pathsectionid,-201)
       and nvl(t.pathitemsetid,-203) = nvl(id_rec.pathitemsetid,-203)
       and nvl(t.pathitemid,-204) = nvl(id_rec.pathitemid,-204)
       and nvl(t.pathcontrol1id,-205) = nvl(id_rec.pathcontrol1id,-205)
       and nvl(t.pathcontrol2id,-206) = nvl(id_rec.pathcontrol2id,-206)
       and nvl(t.pathcontrol3id,-207) = nvl(id_rec.pathcontrol3id,-207)
       and nvl(t.pathcontrol4id,-208) = nvl(id_rec.pathcontrol4id,-208)
       and nvl(t.pathcontrol5id,-209) = nvl(id_rec.pathcontrol5id,-209);
    begin
       for id_sub_rec in cu_get_old_coding_GUIDs loop
            --Write Update Statements
            dbms_output.put_line('update cca_keyitem t');
            dbms_output.put_line('set t.value=replace(t.value,'||chr(39)||id_sub_rec.guid||chr(39)||','||chr(39)||id_rec.guid||chr(39)||')');
            dbms_output.put_line('where');
            dbms_output.put_line('value like'||chr(39)||'%'||id_sub_rec.guid||'%'||chr(39));
            dbms_output.put_line('and t.request_id in');
            dbms_output.put_line('(select r.request_id');
            dbms_output.put_line('from cca_request r);');
         end loop;
         
    end;
  end loop;
 dbms_output.put_line('update cca_request r');
 dbms_output.put_line('set r.status=''COMPLETED''');
 dbms_output.put_line('where r.status=''UNDELIVERABLE'' and r.status_message like ''%Codemap not found%'';');
dbms_output.put_line('commit;');  
dbms_output.put_line('spool off');  
  --End Main Loop


end;
/
execute proc_get_coding_GUIDs();
/
spool off
exit