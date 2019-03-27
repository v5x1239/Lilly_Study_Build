--Forms without data
spool INF-15385_Fix_log.txt;
select *  from pf_subjectvechapterpage where hasdatastate=0 and startedstate=0 and deleteddynamicformstate=1 and originalstate=4097 and state=4096;
update pf_subjectvechapterpage set deleteddynamicformstate=0,originalstate=1,state=0 where hasdatastate=0 and startedstate=0 and deleteddynamicformstate=1 and originalstate=4097 and state=4096;
spool off;

