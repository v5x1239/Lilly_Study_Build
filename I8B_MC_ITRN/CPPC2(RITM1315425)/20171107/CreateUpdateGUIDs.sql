SET SERVEROUTPUT ON FORMAT WRAPPED
Set heading on
set pagesize 0
set linesize 2000
set term on
set trimspool on
set feedback on
set verify on
spool UpdateGUIDs.log

call tra_pkg.start_tx('Update to current mapping GUID',1);
update cca_keyitem t
set t.value=replace(t.value,'{7EE27128-BC4F-4353-B74B-C661C5CD1BAE}','{ED84E16E-1994-41C2-88C9-4424DEE39227}')
where
value like'%{7EE27128-BC4F-4353-B74B-C661C5CD1BAE}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{417A818B-209C-4EE6-B52D-42D1D470C9BB}','{ED84E16E-1994-41C2-88C9-4424DEE39227}')
where
value like'%{417A818B-209C-4EE6-B52D-42D1D470C9BB}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{0FBFD6D8-5596-4EC5-BD01-0207465D8F91}','{ED84E16E-1994-41C2-88C9-4424DEE39227}')
where
value like'%{0FBFD6D8-5596-4EC5-BD01-0207465D8F91}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{F07D00ED-07EA-45A5-8224-5A2380B85824}','{DF3A16D6-1B22-4F1C-8BB8-5583DBC93A65}')
where
value like'%{F07D00ED-07EA-45A5-8224-5A2380B85824}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{476FF826-666D-4F41-ACE1-6694F55A6038}','{DF3A16D6-1B22-4F1C-8BB8-5583DBC93A65}')
where
value like'%{476FF826-666D-4F41-ACE1-6694F55A6038}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{DC7D2849-B666-45A2-ABCD-B5B4A119A187}','{DF3A16D6-1B22-4F1C-8BB8-5583DBC93A65}')
where
value like'%{DC7D2849-B666-45A2-ABCD-B5B4A119A187}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{97390814-1C7C-48C4-BBDF-86276B0C3858}','{8F099365-5FAB-430B-A4D7-800135E7FC25}')
where
value like'%{97390814-1C7C-48C4-BBDF-86276B0C3858}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{E790513F-8FAE-4ECD-A09D-BD5AA79C2C06}','{8F099365-5FAB-430B-A4D7-800135E7FC25}')
where
value like'%{E790513F-8FAE-4ECD-A09D-BD5AA79C2C06}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{1A046E1A-0E0A-4431-B7F9-27CB17FFD33B}','{8F099365-5FAB-430B-A4D7-800135E7FC25}')
where
value like'%{1A046E1A-0E0A-4431-B7F9-27CB17FFD33B}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{4629D9B1-0D68-437F-BA0C-563C2F33EB70}','{14A95361-3CAB-49F5-A8A4-387B169DA5A1}')
where
value like'%{4629D9B1-0D68-437F-BA0C-563C2F33EB70}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{31DAA45C-A65B-406A-B3BB-27F0DBE60374}','{14A95361-3CAB-49F5-A8A4-387B169DA5A1}')
where
value like'%{31DAA45C-A65B-406A-B3BB-27F0DBE60374}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{201A1C6A-51F5-41F3-9096-28A84977C989}','{14A95361-3CAB-49F5-A8A4-387B169DA5A1}')
where
value like'%{201A1C6A-51F5-41F3-9096-28A84977C989}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{141F80F9-B74F-4C00-8D83-1E9DE588E192}','{C057C2B9-B2EC-4656-946D-3CC6EF45C365}')
where
value like'%{141F80F9-B74F-4C00-8D83-1E9DE588E192}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{82980187-B91B-4C65-BCFF-EB8518676CB4}','{C057C2B9-B2EC-4656-946D-3CC6EF45C365}')
where
value like'%{82980187-B91B-4C65-BCFF-EB8518676CB4}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{EDE4A1E8-B086-4006-A240-44CEC4DCC383}','{C057C2B9-B2EC-4656-946D-3CC6EF45C365}')
where
value like'%{EDE4A1E8-B086-4006-A240-44CEC4DCC383}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{447D135D-9DEF-4BF4-A245-2B76B1363084}','{3BDFA8FD-ABE4-48DD-8BDF-358243BF85A4}')
where
value like'%{447D135D-9DEF-4BF4-A245-2B76B1363084}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6F8FCBA6-1F0C-445B-8B1B-0AA0FE59A85F}','{3BDFA8FD-ABE4-48DD-8BDF-358243BF85A4}')
where
value like'%{6F8FCBA6-1F0C-445B-8B1B-0AA0FE59A85F}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{FCE5ACC6-80FF-4428-B5BF-BF364FB938F1}','{3BDFA8FD-ABE4-48DD-8BDF-358243BF85A4}')
where
value like'%{FCE5ACC6-80FF-4428-B5BF-BF364FB938F1}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{9A81DE41-D3EA-4BCA-AEB5-9B53BCF1F656}','{641B1341-7FEB-4F3E-9B56-4ABD9BA75561}')
where
value like'%{9A81DE41-D3EA-4BCA-AEB5-9B53BCF1F656}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{1677C2D0-7785-45E0-AC5F-308C3CEE8731}','{641B1341-7FEB-4F3E-9B56-4ABD9BA75561}')
where
value like'%{1677C2D0-7785-45E0-AC5F-308C3CEE8731}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{D8AE4889-C45F-4211-9159-42CD212CC70D}','{641B1341-7FEB-4F3E-9B56-4ABD9BA75561}')
where
value like'%{D8AE4889-C45F-4211-9159-42CD212CC70D}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{DAC6F1F6-D56E-408B-A40E-9FE8A5BD33CE}','{61FEE09A-7718-44A9-AA87-B6A4DBB37D3B}')
where
value like'%{DAC6F1F6-D56E-408B-A40E-9FE8A5BD33CE}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{72D98A75-5408-48FD-98C8-F7CE2BD37266}','{61FEE09A-7718-44A9-AA87-B6A4DBB37D3B}')
where
value like'%{72D98A75-5408-48FD-98C8-F7CE2BD37266}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{A9BFA5E3-E908-4ACE-AA82-AA84F04550DE}','{61FEE09A-7718-44A9-AA87-B6A4DBB37D3B}')
where
value like'%{A9BFA5E3-E908-4ACE-AA82-AA84F04550DE}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_request r
set r.status='COMPLETED'
where r.status='UNDELIVERABLE' and r.status_message like '%Codemap not found%';
commit;
spool off
