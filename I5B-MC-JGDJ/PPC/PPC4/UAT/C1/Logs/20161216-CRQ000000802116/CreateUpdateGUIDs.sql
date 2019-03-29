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
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{752A1436-A604-45E7-A2FC-9C982F852D20}','{752A1436-A604-45E7-A2FC-9C982F852D20}')
where
value like'%{752A1436-A604-45E7-A2FC-9C982F852D20}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{B751D588-DAFB-42AE-BCB7-DEEE3CEC1A9D}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{B751D588-DAFB-42AE-BCB7-DEEE3CEC1A9D}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{580B21BA-9B3E-4DAE-BBAC-FB202AAF3867}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{580B21BA-9B3E-4DAE-BBAC-FB202AAF3867}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{65371A79-5C34-4E49-B895-1C3302C9D0FA}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{65371A79-5C34-4E49-B895-1C3302C9D0FA}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{B9965EAF-ADE1-4F43-B014-16C4C9BE258A}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{B9965EAF-ADE1-4F43-B014-16C4C9BE258A}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{4C19EF30-8C10-4C76-A263-1508917A6484}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{4C19EF30-8C10-4C76-A263-1508917A6484}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{0AFAEE8F-4A3F-4FA6-BD40-9125E1ACD5F4}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{0AFAEE8F-4A3F-4FA6-BD40-9125E1ACD5F4}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6AC68F43-5B22-4475-B061-F6038E687180}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{6AC68F43-5B22-4475-B061-F6038E687180}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{C49752A3-FA2E-4123-A05B-6B3D74E10DD1}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{C49752A3-FA2E-4123-A05B-6B3D74E10DD1}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{D44B2409-5843-4EF0-AC81-14F9B77AD4D3}','{7AC540AE-AA03-4143-99D1-3974553F4E9B}')
where
value like'%{D44B2409-5843-4EF0-AC81-14F9B77AD4D3}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{FD6768AD-B10C-4242-BD36-508A7D1AE6FE}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{FD6768AD-B10C-4242-BD36-508A7D1AE6FE}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{B98FA6D4-D024-44C7-9CD0-A6FD341FA866}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{B98FA6D4-D024-44C7-9CD0-A6FD341FA866}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{EBDB66D0-1EAA-475F-B473-4AE1C26C4887}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{EBDB66D0-1EAA-475F-B473-4AE1C26C4887}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{C9738D3E-558E-479A-81A0-7C49FCBD53EF}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{C9738D3E-558E-479A-81A0-7C49FCBD53EF}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{8A39AB35-779D-4BB1-A480-4C814BBB1E41}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{8A39AB35-779D-4BB1-A480-4C814BBB1E41}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{581F3E16-0EEE-498F-ADA3-6BC6BAE5823C}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{581F3E16-0EEE-498F-ADA3-6BC6BAE5823C}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6949BED5-C9C7-442A-ABC8-CEC83F67B7A5}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{6949BED5-C9C7-442A-ABC8-CEC83F67B7A5}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{DE2B98BB-AB06-4F8A-9CB4-85E09DBB49A5}','{9F9487FB-5227-4E22-B4E1-2FBEB0733788}')
where
value like'%{DE2B98BB-AB06-4F8A-9CB4-85E09DBB49A5}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{083540EB-9F30-43AB-A00F-1DA8B6416496}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{083540EB-9F30-43AB-A00F-1DA8B6416496}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{FD395F4B-593A-42A7-98F0-D6A18EAF296A}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{FD395F4B-593A-42A7-98F0-D6A18EAF296A}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{3FD9BC0F-9088-4F40-8D55-DFC26109C0FE}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{3FD9BC0F-9088-4F40-8D55-DFC26109C0FE}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{97BCEF54-9854-46F1-A41D-CAF919F42DF6}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{97BCEF54-9854-46F1-A41D-CAF919F42DF6}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{A012BB98-A82A-4BA1-910D-AE413B11AD4C}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{A012BB98-A82A-4BA1-910D-AE413B11AD4C}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{1617D99A-F352-4339-AC7A-697EE38CB4D3}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{1617D99A-F352-4339-AC7A-697EE38CB4D3}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{C7FDD6D2-2CE5-4745-968C-590F4E0EF8B5}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{C7FDD6D2-2CE5-4745-968C-590F4E0EF8B5}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{A4CE8A85-DA50-4A2E-BB46-6CA7D9ADDE02}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{A4CE8A85-DA50-4A2E-BB46-6CA7D9ADDE02}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{880D0DCC-3A77-44BB-97EC-AC560F5F4B63}','{3EBCD80E-1121-4CDD-8983-BFB3DB28BF87}')
where
value like'%{880D0DCC-3A77-44BB-97EC-AC560F5F4B63}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{AA0C883F-230E-4AB9-BFA9-67D558F1ADA5}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{AA0C883F-230E-4AB9-BFA9-67D558F1ADA5}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{1C9700DC-038B-4863-B944-9BCA62D00E95}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{1C9700DC-038B-4863-B944-9BCA62D00E95}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{88BDD562-70EF-48F1-9F44-827619B5D07C}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{88BDD562-70EF-48F1-9F44-827619B5D07C}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{BB7431AB-C57D-4106-8BCC-11DC55DEB802}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{BB7431AB-C57D-4106-8BCC-11DC55DEB802}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{1C7AD6FD-81DE-4595-A619-0651D7813D58}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{1C7AD6FD-81DE-4595-A619-0651D7813D58}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{482478BD-68FE-4029-9A27-D1DA8FFD05E4}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{482478BD-68FE-4029-9A27-D1DA8FFD05E4}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{F920C4C6-CA23-4DE9-9761-DFC1F314891D}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{F920C4C6-CA23-4DE9-9761-DFC1F314891D}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{C0B79207-F4F4-4F5A-8D12-3C74525B59A2}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{C0B79207-F4F4-4F5A-8D12-3C74525B59A2}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{A886CA63-86D7-404D-93C4-EFE7C7F41020}','{DD8B4683-67CD-4DD6-B929-9CA16CF808AD}')
where
value like'%{A886CA63-86D7-404D-93C4-EFE7C7F41020}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{21F9ADDC-E023-4170-A1CD-B2D63B0703C7}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{21F9ADDC-E023-4170-A1CD-B2D63B0703C7}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{8B13D49F-3B9B-4BE5-BAB4-98F3A3BDB886}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{8B13D49F-3B9B-4BE5-BAB4-98F3A3BDB886}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{C78DAF93-B92B-49E9-AFB9-586E05714B19}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{C78DAF93-B92B-49E9-AFB9-586E05714B19}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{015F8EF8-3433-4507-84E2-AC87C24DC7DF}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{015F8EF8-3433-4507-84E2-AC87C24DC7DF}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{B42B9F2D-000F-41AF-9576-D26684B954A6}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{B42B9F2D-000F-41AF-9576-D26684B954A6}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{9F9F77DE-6E16-48A6-83EE-CAB58FAA0A59}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{9F9F77DE-6E16-48A6-83EE-CAB58FAA0A59}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{8C8A09C4-D062-4731-8E3D-BF39DB07EB1A}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{8C8A09C4-D062-4731-8E3D-BF39DB07EB1A}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{93A4BC0A-457D-4706-BCB2-04D3442E46C7}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{93A4BC0A-457D-4706-BCB2-04D3442E46C7}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{73751BF5-054A-4C62-8CC7-6AC1AAB7C762}','{B07A782F-210B-46EA-AB82-4FB3587B734F}')
where
value like'%{73751BF5-054A-4C62-8CC7-6AC1AAB7C762}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{F6FA8D4E-545C-4FD4-A835-2D076D3358CC}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{F6FA8D4E-545C-4FD4-A835-2D076D3358CC}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{FF9BEBA6-BDE3-459B-BDE8-C886B59AEC4E}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{FF9BEBA6-BDE3-459B-BDE8-C886B59AEC4E}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{94D09643-0BB6-4E57-B99C-15B8B2F676CE}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{94D09643-0BB6-4E57-B99C-15B8B2F676CE}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{B69FFF21-C2BF-4545-99B8-B0BB3BE353F8}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{B69FFF21-C2BF-4545-99B8-B0BB3BE353F8}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{5354A4AB-AE6B-493A-AC26-07B933C8DC93}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{5354A4AB-AE6B-493A-AC26-07B933C8DC93}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{DBB44423-7825-42CB-BC46-5680DB40EC76}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{DBB44423-7825-42CB-BC46-5680DB40EC76}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{6C42854C-07E5-4C36-B341-1E525F4A76AA}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{6C42854C-07E5-4C36-B341-1E525F4A76AA}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{48788DA6-6110-40FD-AB42-6346FBE0DF23}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{48788DA6-6110-40FD-AB42-6346FBE0DF23}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{E7BCCE2A-EA46-45BF-BE29-D846D205201E}','{06374C07-8E46-40A8-AA17-2049EE3D1566}')
where
value like'%{E7BCCE2A-EA46-45BF-BE29-D846D205201E}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{4DF4B1B0-167E-4D23-9639-8E37F99C58B4}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{4DF4B1B0-167E-4D23-9639-8E37F99C58B4}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{AA4C9B74-CDF4-4F24-8746-BCC365BE6A69}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{AA4C9B74-CDF4-4F24-8746-BCC365BE6A69}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{1102AEDC-5D55-4A87-9766-A048AF98EDBB}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{1102AEDC-5D55-4A87-9766-A048AF98EDBB}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{0C1A57AE-7B7B-4B56-B579-5EB8AF51013F}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{0C1A57AE-7B7B-4B56-B579-5EB8AF51013F}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{55FB9367-4F13-4424-B28F-98E8472EBB7B}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{55FB9367-4F13-4424-B28F-98E8472EBB7B}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{59250F5B-3904-4E63-92EB-8E90A660C2F8}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{59250F5B-3904-4E63-92EB-8E90A660C2F8}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{9ED2A053-277F-48E9-A8F2-B8BED8885FC8}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{9ED2A053-277F-48E9-A8F2-B8BED8885FC8}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{2A5038DB-5531-483A-A295-13A07C419941}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{2A5038DB-5531-483A-A295-13A07C419941}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_keyitem t
set t.value=replace(t.value,'{00795D30-DC2E-4638-AE04-0879AF6E8648}','{A089D701-F46C-4E6B-BBC4-DA0D66C1975C}')
where
value like'%{00795D30-DC2E-4638-AE04-0879AF6E8648}%'
and t.request_id in
(select r.request_id
from cca_request r);
update cca_request r
set r.status='COMPLETED'
where r.status='UNDELIVERABLE' and r.status_message like '%Codemap not found%';
commit;
spool off
