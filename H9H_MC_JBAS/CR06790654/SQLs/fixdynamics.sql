/* undelete forms that are deleted, started and have data or comments */
spool deletedstartedhasdatalog.txt;
select * from pf_subjectvechapterpage cp where cp.deleteddynamicformstate=1 and cp.startedstate=1 and (cp.hasdatastate=1 or cp.hascommentsstate=1 or
((cp.subjectchapterid, cp.pageid) in (
select vecp.subjectchapterid, vecp.pageid from pf_subjectvechapterpage vecp, pf_subjectvechapter vec where vecp.deleteddynamicformstate=1 
and vecp.startedstate=1 and (vecp.hasdatastate=1 or vecp.hascommentsstate=1) and (vec.subjectkeyid, vec.chapterid,vec.chapterindex,vecp.pageid,
vecp.pageindex) in (select ic.subjectkeyid, ic.chapterid, ic.chapterindex,ic.pageid, ic.pageindex from pf_itemcontext ic where ic.contextid in
(select c.contextid from pf_comment c)))));
Update pf_subjectvechapterpage cp set cp.deleteddynamicformstate=0, cp.state=(state-4096), cp.originalstate=state where deleteddynamicformstate=1 and startedstate=1 
and (hasdatastate=1 or hascommentsstate=1  or
((cp.subjectchapterid, cp.pageid) in (
select vecp.subjectchapterid, vecp.pageid from pf_subjectvechapterpage vecp, pf_subjectvechapter vec where vecp.deleteddynamicformstate=1 
and vecp.startedstate=1 and (vecp.hasdatastate=1 or vecp.hascommentsstate=1) and (vec.subjectkeyid, vec.chapterid,vec.chapterindex,vecp.pageid,
vecp.pageindex) in (select ic.subjectkeyid, ic.chapterid, ic.chapterindex,ic.pageid, ic.pageindex from pf_itemcontext ic where ic.contextid in
(select c.contextid from pf_comment c)))));
commit;
spool off;
/* undelete forms that are deleted, not started and have data or comments */
spool deletednotstartedhasdatalog.txt;
select * from pf_subjectvechapterpage cp where cp.deleteddynamicformstate=1 and cp.startedstate=0 and (cp.hasdatastate=1 or cp.hascommentsstate=1 or
((cp.subjectchapterid, cp.pageid) in (
select vecp.subjectchapterid, vecp.pageid from pf_subjectvechapterpage vecp, pf_subjectvechapter vec where vecp.deleteddynamicformstate=1 
and vecp.startedstate=1 and (vecp.hasdatastate=1 or vecp.hascommentsstate=1) and (vec.subjectkeyid, vec.chapterid,vec.chapterindex,vecp.pageid,
vecp.pageindex) in (select ic.subjectkeyid, ic.chapterid, ic.chapterindex,ic.pageid, ic.pageindex from pf_itemcontext ic where ic.contextid in
(select c.contextid from pf_comment c)))));
Update pf_subjectvechapterpage cp set cp.deleteddynamicformstate=0, cp.startedstate = 1,  cp.state=(state-4095), cp.originalstate=state where deleteddynamicformstate=1 and startedstate=0 
and (hasdatastate=1 or hascommentsstate=1  or
((cp.subjectchapterid, cp.pageid) in (
select vecp.subjectchapterid, vecp.pageid from pf_subjectvechapterpage vecp, pf_subjectvechapter vec where vecp.deleteddynamicformstate=1 
and vecp.startedstate=1 and (vecp.hasdatastate=1 or vecp.hascommentsstate=1) and (vec.subjectkeyid, vec.chapterid,vec.chapterindex,vecp.pageid,
vecp.pageindex) in (select ic.subjectkeyid, ic.chapterid, ic.chapterindex,ic.pageid, ic.pageindex from pf_itemcontext ic where ic.contextid in
(select c.contextid from pf_comment c)))));
commit;
spool off;
/* mark forms as started that are undeleted, not started and have date or comments */
spool notdeletednotstartedhasdatalog.txt;
select * from pf_subjectvechapterpage cp where cp.deleteddynamicformstate=0 and cp.startedstate=0 and (cp.hasdatastate=1 or cp.hascommentsstate=1 or
((cp.subjectchapterid, cp.pageid) in (
select vecp.subjectchapterid, vecp.pageid from pf_subjectvechapterpage vecp, pf_subjectvechapter vec where vecp.deleteddynamicformstate=1 
and vecp.startedstate=1 and (vecp.hasdatastate=1 or vecp.hascommentsstate=1) and (vec.subjectkeyid, vec.chapterid,vec.chapterindex,vecp.pageid,
vecp.pageindex) in (select ic.subjectkeyid, ic.chapterid, ic.chapterindex,ic.pageid, ic.pageindex from pf_itemcontext ic where ic.contextid in
(select c.contextid from pf_comment c)))));
Update pf_subjectvechapterpage cp set cp.startedstate=1, cp.state=(state+1), cp.originalstate=state where deleteddynamicformstate=0 and startedstate=0 
and (hasdatastate=1 or hascommentsstate=1  or
((cp.subjectchapterid, cp.pageid) in (
select vecp.subjectchapterid, vecp.pageid from pf_subjectvechapterpage vecp, pf_subjectvechapter vec where vecp.deleteddynamicformstate=1 
and vecp.startedstate=1 and (vecp.hasdatastate=1 or vecp.hascommentsstate=1) and (vec.subjectkeyid, vec.chapterid,vec.chapterindex,vecp.pageid,
vecp.pageindex) in (select ic.subjectkeyid, ic.chapterid, ic.chapterindex,ic.pageid, ic.pageindex from pf_itemcontext ic where ic.contextid in
(select c.contextid from pf_comment c)))));
commit;
spool off;