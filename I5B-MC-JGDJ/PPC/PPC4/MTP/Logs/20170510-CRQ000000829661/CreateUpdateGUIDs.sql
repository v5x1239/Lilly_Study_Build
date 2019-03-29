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
set t.value=replace(t.value,'{600AB936-83B9-449E-8311-22F5A6ADC05D}','{DC12408D-11FE-4B12-997E-60C6C5EA13B8}')
where
value like'%{600AB936-83B9-449E-8311-22F5A6ADC05D}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6FA7CFBD-DFFF-4850-8280-A60C12CDEF5D}','{DC12408D-11FE-4B12-997E-60C6C5EA13B8}')
where
value like'%{6FA7CFBD-DFFF-4850-8280-A60C12CDEF5D}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{59C8443D-4797-4832-ADF5-645916533205}','{DC12408D-11FE-4B12-997E-60C6C5EA13B8}')
where
value like'%{59C8443D-4797-4832-ADF5-645916533205}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{3A069AB2-5491-43CF-9D4B-3F109F34BC03}','{CF2EE27D-8A15-41D8-98CA-4EE841683978}')
where
value like'%{3A069AB2-5491-43CF-9D4B-3F109F34BC03}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{84097F51-FF81-4600-834F-269E1483326F}','{CF2EE27D-8A15-41D8-98CA-4EE841683978}')
where
value like'%{84097F51-FF81-4600-834F-269E1483326F}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{F24D689B-CFEF-4B20-8262-799347CF780A}','{CF2EE27D-8A15-41D8-98CA-4EE841683978}')
where
value like'%{F24D689B-CFEF-4B20-8262-799347CF780A}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6CAFA6EB-625D-4725-9031-5C03F5E13665}','{CF2EE27D-8A15-41D8-98CA-4EE841683978}')
where
value like'%{6CAFA6EB-625D-4725-9031-5C03F5E13665}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{A0F51012-C6FA-4F9A-B9DA-3E7E0A520A27}','{50C2F910-67CF-4A61-9D6A-6E59E39EB5AE}')
where
value like'%{A0F51012-C6FA-4F9A-B9DA-3E7E0A520A27}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{D77FF74A-3FC7-4A4E-95B2-740F00F2809E}','{50C2F910-67CF-4A61-9D6A-6E59E39EB5AE}')
where
value like'%{D77FF74A-3FC7-4A4E-95B2-740F00F2809E}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{F4230E76-F157-478A-AD62-E26BC99209BB}','{50C2F910-67CF-4A61-9D6A-6E59E39EB5AE}')
where
value like'%{F4230E76-F157-478A-AD62-E26BC99209BB}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{04A6B2A1-DFB4-4667-9D9C-2EDAEAA17DA3}','{50C2F910-67CF-4A61-9D6A-6E59E39EB5AE}')
where
value like'%{04A6B2A1-DFB4-4667-9D9C-2EDAEAA17DA3}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{60C5AC12-3B2F-46B6-B7F4-52321B0828BD}','{F28E3F3F-605F-4104-AE2A-41152C6B2497}')
where
value like'%{60C5AC12-3B2F-46B6-B7F4-52321B0828BD}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{E66724BF-59CB-4730-802F-DAE27734114B}','{F28E3F3F-605F-4104-AE2A-41152C6B2497}')
where
value like'%{E66724BF-59CB-4730-802F-DAE27734114B}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{CAA04687-BB1A-4653-980B-398B9F54AFE9}','{F28E3F3F-605F-4104-AE2A-41152C6B2497}')
where
value like'%{CAA04687-BB1A-4653-980B-398B9F54AFE9}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{AF34CA18-D0F0-48A7-BE45-4C36A1260EC6}','{F28E3F3F-605F-4104-AE2A-41152C6B2497}')
where
value like'%{AF34CA18-D0F0-48A7-BE45-4C36A1260EC6}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{76CD30D8-C80F-4E12-8214-9072977A1D02}','{2942436E-03C8-4D88-B963-C1DE5B10FB9A}')
where
value like'%{76CD30D8-C80F-4E12-8214-9072977A1D02}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{908205EB-F5A3-4E14-95C2-C0FC34065EC8}','{2942436E-03C8-4D88-B963-C1DE5B10FB9A}')
where
value like'%{908205EB-F5A3-4E14-95C2-C0FC34065EC8}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{326FC23A-04DA-49E5-80AE-9CECC8EFBDBD}','{2942436E-03C8-4D88-B963-C1DE5B10FB9A}')
where
value like'%{326FC23A-04DA-49E5-80AE-9CECC8EFBDBD}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{A20C0EC7-840B-4DD7-9E46-1008928FC4CA}','{2942436E-03C8-4D88-B963-C1DE5B10FB9A}')
where
value like'%{A20C0EC7-840B-4DD7-9E46-1008928FC4CA}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}','{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}')
where
value like'%{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}','{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}')
where
value like'%{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}','{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}')
where
value like'%{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}','{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}')
where
value like'%{46D20DBD-C6D8-41B7-94AF-AB3DD0A99214}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{00C0B9F5-0638-4E2B-BE3A-318445DAF3A4}','{BFC59BB6-5894-4525-877D-12925567EAC4}')
where
value like'%{00C0B9F5-0638-4E2B-BE3A-318445DAF3A4}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{D103769E-8D31-47B8-9E25-28C6FF9D35CB}','{BFC59BB6-5894-4525-877D-12925567EAC4}')
where
value like'%{D103769E-8D31-47B8-9E25-28C6FF9D35CB}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6846920D-849C-427C-93A8-3ACD8E629864}','{BFC59BB6-5894-4525-877D-12925567EAC4}')
where
value like'%{6846920D-849C-427C-93A8-3ACD8E629864}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{2434CC46-9A61-43F2-8106-403449B1A68F}','{BFC59BB6-5894-4525-877D-12925567EAC4}')
where
value like'%{2434CC46-9A61-43F2-8106-403449B1A68F}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{607AA5FB-EF91-4E4C-B9D3-796AB0D1B5E1}','{79D94F9D-4222-457E-A7C2-1D2E158EF90E}')
where
value like'%{607AA5FB-EF91-4E4C-B9D3-796AB0D1B5E1}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{478FA1C3-F504-4EE8-BCAA-F04FDCCCB6C7}','{79D94F9D-4222-457E-A7C2-1D2E158EF90E}')
where
value like'%{478FA1C3-F504-4EE8-BCAA-F04FDCCCB6C7}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{C637CBD4-221F-4978-BF87-1BB0AFAE56F7}','{79D94F9D-4222-457E-A7C2-1D2E158EF90E}')
where
value like'%{C637CBD4-221F-4978-BF87-1BB0AFAE56F7}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{47769695-5411-4313-AB05-037533640472}','{79D94F9D-4222-457E-A7C2-1D2E158EF90E}')
where
value like'%{47769695-5411-4313-AB05-037533640472}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_request r
set r.status='COMPLETED'
where r.status='UNDELIVERABLE' and r.status_message like '%Codemap not found%';
commit;
spool off
