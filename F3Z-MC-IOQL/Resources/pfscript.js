
var isoName="en-US";var userName=null;var trialName="";var displayTrialName="";var baseURL,sesURLCMD,sesURL_TM
var bURL_RM_RID
var trlMngrName,resMngrName,sesMngrName,tmCmd_RenderHomeContext,tmCmd_RenderCRFFrameset,tmCmd_RenderTEFrameset
var paramSiteID,paramPatientID,paramFormSetID,sCrnStatus,sRptSite,AM,sURoot
var AnsweredQueryBit=16384
var msgCrfHistory="Show recently viewed CRFs";var msgNoCrfHistory="No recently viewed CRFs";var AdHocHelpDisplay="";var AdHocHelp="";var teViewMode=1;var msgSubjectNum="Subject #";var vemc=1171;var queryStatusIcons=new Array(7);var queryStatusIcons=new Array(7);var queryStatusTooltips=new Array(7);var navUp=new Array(3);var enrollTitle="Enrollment";var enrollShortTitle="Enroll";var crbTitle="Case Report Books";var crbShortTitle="Subjects";var adminTitle="Administration";var adminShortTitle="Admin";var NOSUBMITCHANGE="Are you sure you want to discard your changes? \n\nIf not, press Cancel to return to the form.";var FORMNOTCHANGED="The form has not been changed.";var PATIENTTRANSFER="var PATIENTTRANSFER not initialized";var winComments;var mappedValues=null;bURL_RM_RID='./pfts.dll?C=ResMgr_1&pfLang=en-US&pfR='
function Init(months,bURL,sUnused,trlMngr,resMngr,sesMngr,tmCmdRHC,tmCmdRCF,tmCmdRTF,pSID,pPID,pFSID,sCS,sRS,sUR,sConfirmPatientTransfer){var sesURL;AM=months
baseURL=bURL
trlMngrName=trlMngr;resMngrName=resMngr;sesMngrName=sesMngr
sesURL=bURL+'?'
sesURLCMD=sesURL+'C='
sesURL_TM=sesURLCMD+trlMngr+'_'
bURL_RM_RID=bURL+'?C='+resMngr+'_'+'1&pfLang=en-US&pfR='
tmCmd_RenderHomeContext=tmCmdRHC
tmCmd_RenderCRFFrameset=tmCmdRCF
tmCmd_RenderTEFrameset=tmCmdRTF
paramSiteID='&'+pSID+'='
paramPatientID='&'+pPID+'='
paramFormSetID='&'+pFSID+'='
sCrnStatus=sCS
sRptSite=sRS
sURoot=sUR
scDelete(vemc);PATIENTTRANSFER=sConfirmPatientTransfer;}
queryStatusIcons[0]="QUERY-STATUS-CANDIDATE";queryStatusIcons[1]="QUERY-STATUS-OPEN";queryStatusIcons[2]="QUERY-STATUS-ANSWERED";queryStatusIcons[3]="QUERY-STATUS-CLOSED";queryStatusIcons[4]="QUERY-STATUS-DELETED";queryStatusIcons[5]="QUERY-STATUS-SPONSORCONFLICT";queryStatusIcons[6]="QUERY-STATUS-SITECONFLICT";queryStatusTooltips[0]="Candidate";queryStatusTooltips[1]="Open";queryStatusTooltips[2]="Answered";queryStatusTooltips[3]="Closed";queryStatusTooltips[4]="Deleted";queryStatusTooltips[5]="Sponsor Conflict";queryStatusTooltips[6]="Site Conflict";CONTROLGROUP=0;RADIOGROUP=1;CHECKGROUP=2;TEXTBOX=5;DATETIME=7;TA="textarea";PW="password";TXT="text";SM="select-multiple";SO="select-one";RA="radio";CB="checkbox";HDN="hidden";FIL="file";bg=' bgcolor=#';IB=['',bg+'f0f4ff',bg+'ffffcc',bg+'ffcee6',bg+'ffffff',bg+'c8d4e0',bg+'7c98b0']
QS=['Resolved','Candidate','Opened','Answered','Closed','Deleted']
QO=[[[1,2],["Please provide missing data"]],[[7],["Original value is correct","Data Updated","Data Not Collected"]],[[3],["Response from site required"]],[[4],["Query is invalid or does not apply","Query can be addressed internally"]],[[5,6],["Response does not satisfy query"]],[[8],["Response satisfies query"]],[[9],["State chosen is acceptable"]]]
SUBMITINPROGRESS="Form submission in progress. Please wait...";ENTERINTEGER="Please enter an integer value";ENTERFLOAT="Please enter a floating point value";INVINTRANGE="Integer value is out-of-range.\n\nPlease enter a value in the range +/-2147483647.";INVSIGDIGS="A floating point value may contain only 14 significant digits.";NOSUBMITADDENTRY="You have made changes to this form.\n\nPress OK to submit the changes;\npress Cancel to return to the form.";NSAE=NOSUBMITADDENTRY;SVSC="You have made changes to the form.\n\nPress OK to submit the changes before continuing with the selected operation.\nPress Cancel to ignore the changes and continue with the operation.";REASONFORCHANGE="Please enter a reason for change.";FORMHASNODATA="No data has been entered for the form.";NOVISITDATE="A new visit could not be created.\n\nPlease ensure that at least the month and year of the visit have been entered.";NOVISITDATE2="Please ensure that at least the month\nand year of the visit have been entered.";LOADINGFORM="The form is currently being loaded.\n\nPlease wait until the form is loaded and submit again.";INCOMPLETEDATE="The date/time field is missing a required component.";INCONSISTENTDATE="The date/time field is invalid.";INVCONTEXTMENU="The form cannot be submitted.\n\nPlease refresh the entire browser window and retry.";INVHOURMSG="Hour field must be between 0 and 23.";INVHOURUNKMSG="Hour field must be between 0 and 23 or unknown ('unk').";INVMINMSG="Minute field must be between 0 and 59.";INVMINUNKMSG="Minute field must be between 0 and 59 or unknown ('unk').";INVSECMSG="Second field must be between 0 and 59.";INVSECUNKMSG="Second field must be between 0 and 59 or unknown ('unk').";INVUNKMSG="A value of 'unknown' is not allowed.";INVINTUNKMSG="Please enter an integer value or unknown ('unk').";CUNDEL="Do you really want to undelete the item row?\n\nClick OK to continue.";CDEL="Do you really want to mark the item row as deleted?\n\nClick OK to continue.";QRE="Please resolve the conflict by selecting a row in the query history table.";SEL=" selected";CHK=' checked';var fDrt,fSetDrt,fEmp,fLoad,bChgEv;var fSubmit=fDrt=fSetDrt=fEmp=fLoad=bChgEv=false;sEQ="?~=",sAMP="?~&"
var oDateErr,oTextErr,oCurrFm,oCurrFld;var oLastDate=oDateErr=oTextErr=oCurrFm=oCurrFld=null;sDateMsg=INCOMPLETEDATE
errFld=errMsg=null
sliderDown=false
slidingDivInProcess=false
divNameThatIsDown="NoDivsDown"
effect_1=null
var RPPvalues=[5,10,15,30,50,100];function UrlFromCmd(baseURL,cmd)
{return baseURL+'C='+cmd;}
function UriEscape(str){str=UnescapeTagSymbols(str);str=escape(str);return str;}
function UnescapeTagSymbols(str){str=str.replace(/&lt;/g,"<");str=str.replace(/&gt;/g,">");return str;}
function TxtErr(){if(errMsg){keyAwareAlert(errMsg);errMsg=null};if(errFld){errFld.value="";errFld.focus();errFld=null}}
function AddFm(oF){if(oCurrFm==null)oCurrFm=new Array()
if(oF!=null){oCurrFm[oCurrFm.length]=oF;DefVals(oF)}}
function DefVals(oF){if(oF!=null){var e=oF.elements,i,n,c
if(e!=null)
for(i=0,n=e.length;i<n;i++){c=e[i]
switch(c.type){case TA:case PW:case TXT:c.defaultValue=c.value;break
case SO:case SM:for(var o=c.options,j=0,m=o.length;j<m;j++)
o[j].defaultSelected=o[j].selected
break
case RA:case CB:c.defaultChecked=c.checked}}}}
function ChkDrt(oC){var o,i,n
switch(oC.type){case TA:case PW:case TXT:return oC.defaultValue!=oC.value
case SO:case SM:for(o=oC.options,i=0,n=o.length;i<n;i++)
if(o[i].selected!=o[i].defaultSelected)return true
break
case RA:case CB:return oC.defaultChecked!=oC.checked}
return false}
function DFS(s){return s?SEL:''}
function DFC(c){return c?CHK:''}
function IsFDirty(frmName){if(oCurrFm!=null)
for(var i=0,n=oCurrFm.length;i<n;i++){var oF=oCurrFm[i]
if(oF!=null&&oF.name==frmName)for(var j=0,e=oF.elements,m=e.length;j<m;j++)
if(ChkDrt(e[j]))return true}
return false}
function IsAllExceptFDirty(frmName){if(oCurrFm!=null)
for(var i=0,n=oCurrFm.length;i<n;i++){var oF=oCurrFm[i]
if(oF!=null&&oF.name!=frmName)for(var j=0,e=oF.elements,m=e.length;j<m;j++)
if(ChkDrt(e[j]))return true}
return false}
function IsDirty(){if(fSetDrt&&fDrt)return true
if(oCurrFm!=null)
for(var i=0,n=oCurrFm.length;i<n;i++){var oF=oCurrFm[i]
if(oF!=null)
for(var j=0,e=oF.elements,m=e.length;j<m;j++)
if(ChkDrt(e[j])){if(top.C.document.getElementById("SuccessAck")!=null){top.C.document.getElementById("SuccessAck").innerHTML="&nbsp;";}
return true;}}
return false}
function FC(n,f,x){for(var e=f.elements,i=ix=0,m=e.length;i<m;i++)if(e[i].name==n){if(ix==x)return e[i];else ix++}
return null}
function isInteger(n){return isNaN(n)||isNaN(parseInt(n,10))||parseInt(n,10)!=parseFloat(n)?false:true}
function isFloat(n){return isNaN(n)||isNaN(parseFloat(n))?false:true}
function IsPrec(s,n){var i=s.indexOf(".");return(i<0&&n==0)||(i>=0&&s.length-(i+1)==n)?true:false}
function TestTAFld(oTA,oC){var nLen=parseInt(oTA.aProps["ML"])
if(nLen&&(nLen<oC.value.length)){oC.value=oC.value.substr(0,nLen)
keyAwareAlert("Text limit exceeded. Value will be truncated at "+nLen+" characters.")
oTextErr=oTA
oC.focus()
return false}
return true}
function ChkSigDigs(V){var d=0,f=parseFloat(V),v=f.toString(),i,n
for(i=0,n=v.length;i<n;i++)
switch(v.charAt(i)){case"0":case"1":case"2":case"3":case"4":case"5":case"6":case"7":case"8":case"9":d++}
return d>14?false:true}
function TestNumFld(oNum,oC){var v=oC.value,aP=oNum.aProps,msg=''
if(v!=""){bInt=true
if(aP["N"]){if(!isInteger(v))msg=ENTERINTEGER
else{var n=parseInt(v);if((n<-2147483647)||(n>2147483647))msg=INVINTRANGE}}
else if(aP["F"]){if(!isFloat(v))msg=ENTERFLOAT
else if(!ChkSigDigs(v))msg=INVSIGDIGS
else bInt=false}
if(msg==""){nMinProp=nMaxProp=nPrec=0
bMin=bMax=false;nMin=nMax=0;bPrec=true
nVal=bInt?parseInt(v):parseFloat(v)
if(aP["MN"]){nMin=bInt?parseInt(aP["MN"]):parseFloat(aP["MN"])
nMinProp=parseInt(aP["PM"])
bMin=nMinProp>0}
if(aP["MX"]){nMax=bInt?parseInt(aP["MX"]):parseFloat(aP["MX"])
nMaxProp=parseInt(aP["PX"])
bMax=nMaxProp>0}
if(aP["P"]){nPrec=parseInt(aP["P"])
bPrec=IsPrec(v,nPrec)}
sMinProp=sMaxProp=""
if(nMinProp==3)sMinProp="greater than "
else if(nMinProp==4)sMinProp="greater than or equal to "
if(nMaxProp==1)sMaxProp="less than "
else if(nMaxProp==2)sMaxProp="less than or equal to "
if(bMin&&bMax&&(nMin==nMax)&&(nVal!=nMin))
msg="The value must be equal to "+nMin
else if(bMin&&(((nMinProp==3)&&(nVal<=nMin))||((nMinProp==4)&&(nVal<nMin))))
msg="The value must be "+(bMax?sMinProp+nMin+" and "+sMaxProp+nMax+".":sMinProp+nMin)
else if(bMax&&(((nMaxProp==1)&&(nVal>=nMax))||((nMaxProp==2)&&(nVal>nMax))))
msg="The value must be "+(bMin?sMinProp+nMin+" and "+sMaxProp+nMax+".":sMaxProp+nMax)
else if(!bPrec)msg="The value must contain "+nPrec+" decimal "+(nPrec==1?"place":"places")}}
if(msg!=''){errFld=oC;errMsg=msg;setTimeout(TxtErr,0);oTextErr=oNum;return false}
return true}
function PI(s){if(s.length>6){s=s.substring(7,s.length);if(s.substring(0,1)=="0")s=s.substring(1,s.length)}return parseInt(s)}
function SVT(o,i,v,t)
{var op=o.options[i];op.value=v;op.text=t;}
function BDLst(oMn,oDy,oYr,du)
{mn=oMn==null?"":new String(oMn[oMn.selectedIndex].value);dy=new String(oDy[oDy.selectedIndex].value);yr=oYr==null?"":new String(oYr[oYr.selectedIndex].value);nMn=PI(mn),nYr=PI(yr),nDy=PI(dy);if(isNaN(nDy))nDy=0;bInvYr=isNaN(nYr)||nYr==-99;if(isNaN(nMn)){nDys=31;}
else{if(nMn==2)nDys=bInvYr?29:((nYr%4==0&&nYr%400!=100)?29:28);else nDys=(nMn==9||nMn==4||nMn==6||nMn==11)?30:31;}
if(nDy>nDys)
{sMsg=nMn+'/'+nDy;if(!bInvYr)sMsg+='/'+nYr;keyAwareAlert(sMsg+' is not a valid date.');oMn.options[0].selected=oDy.options[0].selected=oYr.options[0].selected=true;oMn.fireEvent("onchange");oDy.focus();nDy=0;}
aOp=new Array(du?nDys+2:nDys+1);aOp[0]=new Option(" ",0);for(i=1;i<=nDys;i++)
aOp[i]=new Option(i+'',"!pfday!"+i);if(du)
aOp[nDys+1]=new Option(AM[0],"!pfday!-99");for(i=0;i<=(du?nDys+1:nDys);i++)
{SVT(oDy,i,aOp[i].value,aOp[i].text);if(i==nDy)oDy.options[i].selected=true;}
if(0==nDy)oDy.options[0].selected=true;if(du&&-99==nDy)oDy.options[nDys+1].selected=true;for(i=oDy.options.length;i>(du?nDys+2:nDys+1);i--)
SVT(oDy,i-1,aOp[0].value,aOp[0].text);}
function SFO(){if(oCurrFld){oCurrFld.focus();if(oCurrFld.value!=""){oCurrFld.value=""};oCurrFld.select();oCurrFld=null}clearTimeout(idTimer)}
function ASF(m,o){keyAwareAlert(m);oCurrFld=o;idTimer=setTimeout('SFO()',50)}
function CTF(oC,v){oC.value=v<10?'0'+v:v}
function LZ(v){for(var z=true,i=0,n=v.length;i<n;i++)if(v.charAt(i)!='0'){z=false;break}
return z?'0':v.replace(/^[0|\s]+/,'')}
function TstTxtTime(oC){var ty=oC.getAttribute('dtype')
if(ty){var v=oC.value,u=oC.getAttribute('unknown')==1,v,i,j
if(v=='')return
v=v.toLowerCase()
if(v=='u'||v=='un'||v=='unk'){if(!u)ASF(INVUNKMSG,oC);return}
j=LZ(v)
if(!isInteger(j)){ASF(u?INVINTUNKMSG:ENTERINTEGER,oC);return}
i=parseInt(j,10)
switch(ty){case'h':if(i<0||i>23){ASF(u?INVHOURUNKMSG:INVHOURMSG,oC);return}CTF(oC,i);break
case'm':if(i<0||i>59){ASF(u?INVMINUNKMSG:INVMINMSG,oC);return}CTF(oC,i);break
case's':if(i<0||i>59){ASF(u?INVSECUNKMSG:INVSECMSG,oC);return}CTF(oC,i)}}}
function OnDTChange(oDT,iCtrl,oF,oC){var iMn=iDy=iYr=iHr=iMin=iSec=-1,ord=oDT.aProps["O"],i,n
for(i=0,n=ord.length;i<n;i++)
switch(ord.charAt(i)){case'M':iMn=i;break
case'D':iDy=i;break
case'Y':iYr=i;break
case'h':iHr=i;break
case'm':iMin=i;break
case's':iSec=i}
if(iCtrl==iMn||iCtrl==iDy||iCtrl==iYr){var oDy=(iDy==-1)?null:FC(oDT.Name,oF,iDy)
if(oDy!=null){var oMn=(iMn==-1)?null:FC(oDT.Name,oF,iMn),oYr=(iYr==-1)?null:FC(oDT.Name,oF,iYr)
BDLst(oMn,oDy,oYr,oDT.aProps["U"]=="1")}}
TstTxtTime(oC)
bChgEv=true}
function PTMV(v){v=v.toLowerCase()
if(v=='u'||v=='un'||v=='unk')return-99
if(v.length>1&&v.charAt(0)=='0')return v.charAt(1)
return v}
function GDTV(oC){var pfx=oC.getAttribute('prefix'),v=''
if(pfx&&oC.type==TXT){v=PTMV(oC.value);if(v!='')v=pfx+v}
else v=oC[oC.selectedIndex].value
return v}
function CheckDateConsistent(oDT,oF){var ord=oDT.aProps["O"],oFld,oMn,oDy,oYr,oHr,oMin,oSec,iMn=iDy=iYr=iHr=iMin=iSec=-1,i,n,oC,v
for(i=0,n=ord.length;i<n;i++){oC=FC(oDT.Name,oF,i)
v=GDTV(oC)
if(v==''||v=='0')v=-1
else v=parseInt(v.substr(7))
switch(ord.charAt(i)){case'M':iMn=v;oMn=oC;break
case'D':iDy=v;oDy=oC;break
case'Y':iYr=v;oYr=oC;break
case'h':iHr=v;oHr=oC;break
case'm':iMin=v;oMin=oC;break
case's':iSec=v;oSec=oC}}
if(iYr<0&&(iMn>0||iDy>0||iHr>=0||iMin>=0||iSec>=0))return oYr
if(iMn<0&&(iDy>0||iHr>=0||iMin>=0||iSec>=0))return oMn
if(iDy<0&&(iHr>=0||iMin>=0||iSec>=0))return oDy
if(iHr<0&&(iMin>=0||iSec>=0))return oHr
if(iMin<0&&(iHr>=0||iSec>=0))return oMin
return null}
function IsDateReq(ord,req,i){return req.indexOf(ord.charAt(i))>=0}
function DateEmpty(oDT,oF){for(var i=0,n=oDT.aProps["O"].length;i<n;i++){oC=FC(oDT.Name,oF,i)
switch(oC.type){case SO:if(oC.selectedIndex>0)return false;break
case TXT:if(oC.value!='')return false}}
return true}
function CheckDateComplete(oDT,oF){if(oDT){var ord=oDT.aProps["O"],req=oDT.aProps["R"],bEC="1"==oDT.aProps["C"],bReq=false,bBU=false,bBL,oC,v,i,n,j,bD
if(DateEmpty(oDT,oF))return
for(bD=false,i=0,n=ord.length;i<n;i++)if(ChkDrt(FC(oDT.Name,oF,i))){bD=true;break}
if(bD){for(i=0;i<n;i++){oC=FC(oDT.Name,oF,i)
bReq=IsDateReq(ord,req,i)
v=GDTV(oC)
bBL=v==""||v=="0"
if(bReq&&bBL){oLastDate=oDT;sDateMsg=INCOMPLETEDATE;return oC}
bBU=bBU||-99==parseInt(v.substr(7))||bBL}
if(bBU&&bEC){oC=CheckDateConsistent(oDT,oF);if(oC){oLastDate=oDT;sDateMsg=INCONSISTENTDATE;return oC}}}
oDateErr=oLastDate=null}
return null}
function GSN(o){return o.getAttribute('PFOBJ')}
function IsSel(o,oF){if(o)
for(var iC=o.iCtrl,oP=o.oParent;oP!=null;iC=oP.iCtrl,oP=oP.oParent)
switch(oP.nType){case RADIOGROUP:case CHECKGROUP:{var oC=FC(oP.Name,oF,iC);if(oC&&!oC.checked)return false}}
return true}
function DatesComplete(oF,oW){for(var i=0,el=oF.elements,n=el.length,o,ob2,e;i<n;i++){e=el[i]
switch(e.type){case SO:case TXT:if(e.getAttribute('fdc')){ob2=eval('oW.'+GSN(e))
if(ob2&&IsSel(ob2,oF)){o=CheckDateComplete(ob2,oF);if(o)return o}}}}
return null}
function RunChecks(oF,oW){var o=DatesComplete(oF,oW)
if(o){oLastDate=oDateErr;oDateErr=null;o.focus();keyAwareAlert(sDateMsg);return o}
for(var el=oF.elements,i=0,n=el.length,obj,t;i<n;i++){o=el[i],t=o.type
if(t==TA||t==TXT){obj=eval('oW.'+GSN(o))
if(obj&&obj.nType==TEXTBOX){if(obj.aProps["N"]||obj.aProps["F"]){if(!TestNumFld(obj,o))return o}
else if(o.type==TA&&obj.aProps["ML"]){if(!TestTAFld(obj,o))return o}
if(oTextErr&&(obj.Name!=oTextErr.Name||o.value!=""))oTextErr=null}
else oTextErr=null}}
return null}
function FS(oW){this.oWindow=oW}
function CPFArray(aP){for(var i=0,n=aP.length;i<n;i++)this[aP[i][0]]=aP[i][1]}
function NP(P){var a=eval('new Array('+P+')'),aP=new Array(),i,n
for(i=0,n=a.length;i<n;i+=2)aP[i/2]=eval('new Array("'+a[i]+'","'+a[i+1]+'")')
return aP}
var wndCur=null
function a(C,T,nC,iC,P,oP){return new CS(nC,iC,C,T,NP(P),oP);}
function b(C,T,nC,iC,oP){return new CS(nC,iC,C,T,NP(''),oP);}
function c(C,T,P,oP){return new CS(1,0,C,T,NP(P),oP);}
function dCS(C,T,oP){switch(arguments.length){case 1:return new CS(1,0,'',C,NP(''),null);case 2:return typeof(C)=="string"?new CS(1,C,'',T,NP(''),null):new CS(1,0,'',C,NP(''),T);case 3:return new CS(1,0,C,T,NP(''),oP)}}
function CS(nCtl,iCtl,nm,typ,aP,oP){this.oParent=oP
this.Child=new Array()
this.nCtrl=nCtl
this.iCtrl=iCtl
this.oWindow=wndCur
this.Name=nm
this.nType=typ
this.aProps=new CPFArray(aP)
this.UName=null
this.nUnitNum=0
if(oP)oP.Child[oP.Child.length]=this}
function ASU(o,n,u){o.UName='!ut!'+n;o.nUnitNum=u}
function ResetCtrl(obj,oC){var t=oC.type
if(t==RA||t==CB){if(oC.checked==true)oC.checked=false}
else if(t==SO){if(oC.selectedIndex!=0){oC.selectedIndex=0;}}
else if(t==SM){for(j=0;j<oC.options.length;j++)
if(oC.options[j].selected)oC.options[j].selected=false;}
else if(t==TXT||t==TA||t==PW){if(oC.value!="")oC.value=""}
oC.blur()}
function IsChild(oCh,oPa){if(!oCh)return false
var oTest=oCh
while(oTest.oParent){if(oPa==oTest.oParent)return true
oTest=oCh.oParent
oCh=oTest}
return false}
function GetRadioOwner(oCh){if(!oCh)return null
var oTest=oCh
while(oTest.oParent){oTest=oCh.oParent
if(oTest.nType==RADIOGROUP)return oTest
oCh=oTest}
return null}
function GetTopRadio(oCh){if(!oCh)return null
var oTest=oCh,oTopRadio=null
while(oTest.oParent){oTest=oCh.oParent
if(oTest.nType==RADIOGROUP)oTopRadio=oTest
oCh=oTest}
return oTopRadio}
function GetChildOwner(oCh,oGP){if(!oCh||!oGP)return null
if(oCh.Parent==oGP)return null
var oTest=oCh
while(oTest.oParent){oTest=oCh.oParent
if(oTest.oParent&&oTest.oParent==oGP)return oTest
oCh=oTest}
return null}
function IsCommonRadio(o1,o2,oF,nIdx){if(!o1||!o2)return false
var top1=GetTopRadio(o1),top2=GetTopRadio(o2),rad1=GetRadioOwner(o1),rad2=GetRadioOwner(o2)
if((top1||top2)&&top1==top2&&rad1!=rad2)return true
if(rad1==o2||rad2==o1||top1==o2||top2==o1){var oRad=rad1==o2?o2:(top1==o2?o2:o1),oCh=rad1==o2?o1:(top1==o2?o1:o2),oFld=FC(oRad.Name,oF,nIdx),selVal=oFld.value,oRadC=GetChildOwner(oCh,oRad)
if(oRadC&&(selVal=="!pf!"+oRadC.Name))return false}else{if(!top1||!top2)return false
if(top1!=top2)return false}
var radC1=GetChildOwner(o1,rad1),radC2=GetChildOwner(o2,rad1)
if((radC1||radC2)&&radC1==radC2)return false
return true}
function PFReset(oReset,iNReset,oF){var oRet=null,i,n,oC
if(oReset==oLastDate||IsChild(oLastDate,oReset)){oLastDate=null;oDateErr=null}
else if(oLastDate)oRet=CheckDateComplete(oLastDate,oF)
if(oRet){oDateErr=oLastDate;oLastDate=null}
if(oReset.Child.length>0)
for(i=0,n=oReset.Child.length;i<n;i++)
if((iNReset==null||(iNReset!=null&&iNReset!=i))&&(oReset.Child[i].Name!=""))PFReset(oReset.Child[i],null,oF)
for(i=0,n=oReset.nCtrl;i<n;i++)
if((iNReset==null||(iNReset!=null&&iNReset!=i))&&(oReset.Name!="")){oC=FC(oReset.Name,oF,i)
if(oC!=null)ResetCtrl(oReset,oC)}
if(oReset.nUnitNum>0)
for(i=0,n=oReset.nUnitNum;i<n;i++){oC=FC(oReset.UName,oF,i)
if(oC!=null)ResetCtrl(oReset,oC)}
if(oRet){oLastDate=oDateErr;oDateErr=null;oRet.focus();keyAwareAlert(sDateMsg)}}
function PFSel(oSel,nIdx,oF,bCSel){if(top.C.document.getElementById("SuccessAck")!=null){top.C.document.getElementById("SuccessAck").innerHTML="&nbsp;";}
if(oTextErr&&oSel.Name!=oTextErr.Name)oTextErr=null
var oRet=null,bCD=oLastDate&&oSel!=oLastDate,i,n,oC,t,ch,p,bCD=bCD&&!bCSel&&!IsCommonRadio(oSel,oLastDate,oF,nIdx)
if(bCD)oRet=CheckDateComplete(oLastDate,oF)
if(oRet){oDateErr=oLastDate;oLastDate=null}
p=oSel.oParent
if(p!=null)
for(i=0,ch=p.Child,n=ch.length;i<n;i++)
if(ch[i]==oSel){PFSel(p,i,oF,true);break}
if(oSel.nType==RADIOGROUP)PFReset(oSel,nIdx,oF)
if(oSel.nCtrl>0&&oSel.nCtrl>nIdx&&oSel.Name!=""&&oSel.nType!=CONTROLGROUP){oC=FC(oSel.Name,oF,nIdx);t=oC.type
if(t==RA)oC.checked=true
else if(t==CB){if(!oC.checked&&bCSel)oC.checked=true
else if(!oC.checked&&!bCSel){if(oSel.Child.length>0)PFReset(oSel.Child[nIdx],null,oF)
return}}}
if(oSel.Child.length>0){var oChild=oSel.Child[nIdx]
if(oChild.nCtrl>0&&!bCSel&&oChild.Name!=""&&oChild.nType!=CONTROLGROUP){oC=FC(oSel.Child[nIdx].Name,oF,0),t=oC.type
if(t==RA||t==CB||t==TXT||t==TA||t==PW||t==SM||t==SO)oC.focus()}}
if(!oRet)oLastDate=oSel.nType==DATETIME&&!oDateErr?oSel:null
else{oLastDate=oDateErr;oDateErr=null;oRet.focus();keyAwareAlert(sDateMsg)}}
function OC(obj,nIdx,oC){PFSel(obj,nIdx,oC.form,false)}
function OF(obj,nIdx,oC){PFSel(obj,nIdx,oC.form,false)}
function formatErrorMsg(strText){var charX,code;var strX="";for(i=0;i<strText.length;i++){charX=strText.charAt(i);code=strText.charCodeAt(i);if(code>127){strX+="<b>"+charX+"</b>";}else{strX+=charX;}}
return strX;}
var oAsciiErrDiv;function removeMsgDiv(){if(oAsciiErrDiv!=null){oAsciiErrDiv.parentNode.removeChild(oAsciiErrDiv);oAsciiErrDiv=null;}}
function onMsgDivMouseOut(ev){if(ev.toElement&&ev.toElement.tagName.toUpperCase()!="SPAN"){removeMsgDiv();}}
function displayErrorMsg(msg,oText){var oParent,oMsgDiv;var msg="<span onmouseout=\"top.onMsgDivMouseOut(event);\" onselectstart=\"return false;\">Characters underlined are not allowed:</span><span onmouseout=\"top.onMsgDivMouseOut(event);\" onselectstart=\"return false;\">"+msg+"</span>";removeMsgDiv();oParent=oText.parentNode;while(oParent.tagName.toUpperCase()!="BODY"){oParent=oParent.parentNode;}
if(oParent.parentNode.document){oMsgDiv=oParent.parentNode.document.createElement("div");}else{oMsgDiv=window.document.createElement("div");}
oMsgDiv.id="errMsgDiv";oMsgDiv.innerHTML=msg;oParent.appendChild(oMsgDiv);oAsciiErrDiv=oMsgDiv;oText.select();oText.focus();}
function testCharSet(oTA,oTextArea){var re=/[^\u0000-\u007F]/;if(re.test(oTextArea.value)){errMsg=formatErrorMsg(oTextArea.value);displayErrorMsg(errMsg,oTextArea);oTextErr=oTA;return false;}else{return true;}}
function OB(obj,nIdx,oC){var o=FC(obj.Name,oC.form,nIdx)
switch(obj.nType){case TEXTBOX:if(obj.aProps["N"]||obj.aProps["F"]){if(!TestNumFld(obj,oC))return}
else if(o.type==TA||o.type==TXT){if(obj.aProps["ML"]&&!TestTAFld(obj,o)){return}
if(obj.aProps["CharSet"]==1){if(testCharSet(obj,oC)){removeMsgDiv();}else{keyAwareAlert("Please remove characters that are not allowed in this text control.");oC.focus();return false;}}}
if(oTextErr&&(obj.Name!=oTextErr.Name||o.value!=""))oTextErr=null
break;case DATETIME:if(!bChgEv)TstTxtTime(oC)
bChgEv=false}
oTextErr=null}
function OH(obj,nIdx,oC){if(top.C.document.getElementById("SuccessAck")!=null){top.C.document.getElementById("SuccessAck").innerHTML="&nbsp;";}
if(oTextErr&&obj.Name!=oTextErr.Name)oTextErr=null
var o=FC(obj.Name,oC.form,nIdx),t=o.type
switch(obj.nType){case TEXTBOX:if(obj.aProps["N"]||obj.aProps["F"]){if(!TestNumFld(obj,o))return}
else if(t==TA){if(obj.aProps["ML"]&&!TestTAFld(obj,o)){return;}}
break;case DATETIME:OnDTChange(obj,nIdx,oC.form,oC)}
oTextErr=null}
function OK(obj,nIdx,oC){var o=FC(obj.Name,oC.form,nIdx),t=o.type
if(t==TA)TestTAFld(obj,o)}
function SB(){}
function SB2(){fSetDrt=fDrt=true;if(top.C.document.getElementById("SuccessAck")!=null){top.C.document.getElementById("SuccessAck").innerHTML="&nbsp;";}}
function RB(){fDrt=false;oTextErr=null}
function SetFormSubmittingFlag(){fSubmit=true;}
function ResetFormSubmittingFlag(){fSubmit=false;}
function SBL(){ResetFormSubmittingFlag();fDrt=fSetDrt=false;fLoad=true;oTextErr=null;}
function SBU(){ResetFormSubmittingFlag();fDrt=fSetDrt=fLoad=false;oTextErr=oCurrFm=oCurrFld=null;}
function TB(){return IsDirty()?keyAwareConfirm(NOSUBMITCHANGE):true;}
function TSV(){return IsDirty()?keyAwareConfirm(SVSC):false;}
function TCPT(){return keyAwareConfirm(PATIENTTRANSFER);}
function dirt(){return IsDirty();}
function TS(){if(!IsDirty()){keyAwareAlert(FORMNOTCHANGED);return false;}
return TestSubmitInProgress();}
function TestSubmitInProgress(){if(fSubmit){keyAwareAlert(SUBMITINPROGRESS);return false;}
return true;}
function TRV(oF,id,edt){if(!TS())return false;var bc=false,oE=oF.elements,a=new Array(0,0,0,0,0),e;for(i=0,n=oE.length;i<n;i++){e=oE[i];if(e.name==id&&e.type==SO){bc=true;if((s=e.selectedIndex)>=0){switch(e.options[s].value.substr(3,3)){case"yea":a[0]=1;break;case"mon":a[1]=1;break;case"day":a[2]=1;break;case"hou":a[3]=1;break;case"min":a[4]=1;}}}}
if(bc&&(a[0]==0||a[1]==0)){keyAwareAlert(edt==1?NOVISITDATE2:NOVISITDATE);return false;}
return true;}
function TV(oF,rd,pd,tx,pdv,txv,id){if(TRV(oF,id,1))return ReaChg(rd,pd,tx,pdv,txv,false);return false;}
function TE(rd,pd,tx,pdv,txv){if(TS())return ReaChg(rd,pd,tx,pdv,txv,false);return false;}
function TDSB(rd,pd,tx,pdv,txv){return ReaChg(rd,pd,tx,pdv,txv,true);}
function TDFSB(rd,pd,tx,pdv,txv){var fm=FF(top.C.document,'CRFBody','crf',0);return RC(fm,rd,pd,tx,pdv,txv,true);}
function TDMFSB(rd,pd,tx,pdv,txv){if(!IsDirty()){keyAwareAlert(FORMNOTCHANGED);return false;}
else return TDFSB(rd,pd,tx,pdv,txv);}
function TCASSB(rd,pd,tx,pdv,txv){if(!IsDirty()){keyAwareAlert(FORMNOTCHANGED);return false;}
else return RC(top.C.document.getElementById("CRFBody").contentWindow.document.getElementById("DetailCRFBody").contentWindow.document.forms[0],rd,pd,tx,pdv,txv,true);}
function TCC(rd,pd,tx,pdv,txv){if(TS())return RC(top.C.Body.document.forms[0],rd,pd,tx,pdv,txv,0);return false;}
function ReaChg(rd,pd,tx,pdv,txv,bD){return RC(GDF(top.C.document,'div2',0),rd,pd,tx,pdv,txv,bD);}
function RC(oF,tdnm,pdnm,txnm,pdval,txval,bDel){var pdCtl=txtCtl=sel=null,i,n,nm,e
for(i=0,n=oF.length;i<n;i++){e=oF.elements[i],nm=e.name;if(nm==tdnm){if(e.checked)sel=e.value;}
else if(nm==pdnm)pdCtl=e;else if(nm==txnm)txtCtl=e;}
if((sel==pdval&&pdCtl.value!="")||(sel==txval&&txtCtl.value!=""))return true
if(IsDirty()||bDel)keyAwareAlert(REASONFORCHANGE)
return false}
function CI(oClr,oFm){PFReset(oClr,null,oFm)}
function TN(){if(!fLoad){keyAwareAlert(LOADINGFORM);return false}
if(fSubmit){keyAwareAlert(SUBMITINPROGRESS);return false}
if(!IsDirty()&&fEmp){keyAwareAlert(FORMHASNODATA);return false}
return true}
function CBSubmit(cbName,cbString){this.name=cbName;this.string=cbString;this.bFirst=true}
function RadioSubmit(rbName,rbChecked){this.rbName=rbName;this.rbChecked=rbChecked}
function HF(D){D.write('<FORM AUTOCOMPLETE=off NAME=PFHiddenForm id="PFHiddenForm" METHOD=post style=\"margin:0;\"><INPUT TYPE=hidden NAME=PFData></FORM>')}
function SubmitForm_4(W,oF,trg,C,A,dID){SubmitForm_S(W,trg==""?trg=oF.target:trg,SFX(W,oF)+sAMP,C,A,'',dID);}
function SubmitForm_3(W,fs,trg,C,A,dID){var s="",i,n,o;for(i=0,n=fs.length;i<n;++i){o=RunChecks(fs[i],W);if(o){o.focus();return;}
if(oTextErr){oTextErr=null;return;}
s+=SFX(W,fs[i])+sAMP;}
if(trg=="")trg=fs[0].target;SubmitForm_S(W,trg,s,C,A,'',dID);}
function SFX(oW,oF){var cb=new Array(),rb=new Array(),nIdx,pfx,v,bFirst=true,bSel,sRes="",nCB=nRG=0,el,nm,t,bF,iF,v,i,n,m;for(nIdx=0,n=oF.elements.length;nIdx<n;nIdx++){el=oF.elements[nIdx],nm=el.name,t=el.type;if(t==CB){for(i=0,bF=false;i<nCB;i++){if(cb[i].name==nm){bF=true;break;}}
if(!bF){cb[nCB]=new CBSubmit(nm,"");i=nCB++;}
if(el.checked){cb[i].string+=(bFirst?"":sAMP)+nm+sEQ+el.value;cb[i].bFirst=false;bFirst=false;}}
else if(t==RA){for(i=0,iF=-1;i<nRG;i++){if(rb[i].name==nm){iF=i;break;}}
if(iF<0){rb[nRG++]=new RadioSubmit(nm,el.checked);}
else if(!rb[iF].rbChecked){rb[iF].rbValue=el.checked;}
if(el.checked){sRes+=(bFirst?"":sAMP)+nm+sEQ+el.value;bFirst=false;}}
else if(t==TXT||t==TA||t==PW||t==HDN||t==FIL){v=el.value;if(v!=''){pfx=el.getAttribute('prefix');v=pfx?pfx+PTMV(v):v;}
sRes+=(bFirst?"":sAMP)+nm+sEQ+v;bFirst=false;}
else if(t==SO){sRes+=(bFirst?"":sAMP)+nm+sEQ+el.options[el.selectedIndex].value;bFirst=false;}
else if(t==SM){bSel=false;for(i=0,m=el.length;i<m;i++){if(el.options[i].selected){sRes+=(bFirst?"":sAMP)+nm+sEQ+el.options[i].value;bFirst=false;bSel=true;}}
if(!bSel){sRes+=(bFirst?"":sAMP)+nm+sEQ;bFirst=false;}}}
for(nIdx=0;nIdx<nCB;nIdx++){strCBG=cb[nIdx].string;if(strCBG==""){strCBG=cb[nIdx].name+sEQ;}
sRes+=(bFirst?"":sAMP)+strCBG;bFirst=false;}
for(nIdx=0;nIdx<nRG;nIdx++){if(!rb[nIdx].rbChecked){sRes+=(bFirst?"":sAMP)+rb[nIdx].rbName+sEQ;bFirst=false;}}
return sRes;}
function SubmitHiddenForm(oW,oF,sCmd,sArg,ipath){if((oW==null)||(oF==null)){keyAwareAlert(INVCONTEXTMENU);return;}
var o=RunChecks(oF,oW);if(o){o.focus();return;}
if(oTextErr){oTextErr=null;return;}
var sText=SFX(oW,oF);if(arguments.length<5){ipath='';}
SubmitForm_S(oW,oF.target,sText,sCmd,sArg,ipath);}
function SubmitForm_S(oW,targ,sText,sCmd,sArg,ipath,dID){var oHF=null;if(dID!=null)
oHF=FindHtmlControl(oW,dID,'PFHiddenForm');else
oHF=oW.document.getElementById("PFHiddenForm");if(oHF.document==undefined){if(oHF[1]){oHF=oHF[1];}}
oHF.PFData.value=sText;oHF.target=targ;oHF.action=sesURLCMD+sCmd+ipath+sArg.replace("#","%23");if(sText!="")
oHF.action+="&";SetFormSubmittingFlag();oHF.submit();}
function SC(oWnd,oSel)
{oWnd.location.href=sesURL_TM+tmCmd_RenderHomeContext+paramSiteID+oSel.options[oSel.selectedIndex].value;}
function PatSearch(patID){if(patID==msgSubjectNum||patID==""||patID=="0")return;var ampIndex=-1;var lbIndex=-1;if((ampIndex=patID.indexOf("&"))!=-1)
patID=patID.slice(0,ampIndex)+"%26"+patID.slice(ampIndex+1);if((lbIndex=patID.indexOf("#"))!=-1)
patID=patID.slice(0,lbIndex)+"%23"+patID.slice(lbIndex+1);C.location.href=sesURL_TM+"245"+"&PSearch="+escape(patID)
hlNav(top.ControlPanel.document.getElementById("navIcons").childNodes[1]);}
function GV(d,sid){var oSite=sid>0?null:d.CM.Site,oPat=d.CM.Pt,oFS=d.CM.Vt
if(sid<=0){iS=oSite.selectedIndex;site=iS<0?"0":oSite.options[iS].value}
else site=sid.toString()
if(site==""||site=="0")return
var iPat=oPat.selectedIndex
pat=iPat<0?"0":oPat.options[iPat].value
if(pat==""||pat=="0")return
var iFS=oFS.selectedIndex,fs=iFS<0?"0":oFS.options[iFS].value
aFS=fs.split('_')
if(parseInt(aFS[0])<0)C.location.href=sesURL_TM+tmCmd_RenderTEFrameset+paramPatientID+pat+paramSiteID+site
else C.location.href=sesURL_TM+tmCmd_RenderCRFFrameset+paramPatientID+pat+paramSiteID+site+paramFormSetID+aFS[0]+(aFS.length==2?'&FX='+aFS[1]:'')}
function WriteBlankImage(document,width,Height,itemArrayState,formState){var stateFound=false
for(i=0;i<itemArrayState.length;i++){if(formState&itemArrayState[i]){stateFound=true}}
if(stateFound){document.write('<td align=right><img style=\"visibility:hidden\" Width=\"17\" Height=\"17\" src=\"',bURL_RM_RID,'6C\"</img></td>')}}
function BA(w,m,p,o,a,q,fn,formState){D=w.document
if(m==0){D.write('&nbsp;');return}
D.write('<table style=\"display:inline\"><tr>')
if(m&0x01){WS(D,3,p,a,-1,fn);WA(D,'19','Enter item comment')}
else if(m&0x02){WS(D,3,p,a,-1,fn);WA(D,'18','View item comment')}
else{var stateArrayToCompare=new Array()
stateArrayToCompare[0]=0x02
WriteBlankImage(D,17,17,stateArrayToCompare,formState)}
if(m&0x04){WS(D,1,p,0,q,fn);WA(D,'39','Create item query')}
else if(m&0x08){if(formState&AnsweredQueryBit)
{WS(D,1,p,0,q,fn);WA(D,'40','View item queries')}
else{WS(D,1,p,0,q,fn);WA(D,'38','View item queries')}}
else{var stateArrayToCompare=new Array()
stateArrayToCompare[1]=0x04
stateArrayToCompare[2]=0x08
WriteBlankImage(D,17,17,stateArrayToCompare,formState)}
if(m&0x10){WS(D,2,p,0,-1,fn);WA(D,'05','View item audit history')}
else if(m&0x20){WS(D,2,p,0,-1,fn);WA(D,'04','View item audit history')}
else{var stateArrayToCompare=new Array()
stateArrayToCompare[0]=0x10
stateArrayToCompare[1]=0x20
WriteBlankImage(D,17,17,stateArrayToCompare,formState)}
if(m&0x40){WS(D,4,p,0,-1,fn);WA(D,'9F','Edit item rules')}
if(m&0x80){D.write('<td align=right>')
WC(D,o);WA(D,'A0','Reset item values')}
D.write('</tr></table>')}
function BA2(w,m,p,o,a,q,fn){D=w.document
if(m==0){D.write('&nbsp;');return}
if(m&0x02){D.write('<a href=\"javascript:E(\''+p+'\')\">');WA(D,'18','View item comment')}
if(m&0x08){WS(D,1,p,0,q,fn);WA(D,'38','View item row queries')}
if(m&0x10){D.write('<a href=\"javascript:E(\''+p+'\')\">');WA(D,'05','View item audit history')}
else if(m&0x20){D.write('<a href=\"javascript:E(\''+p+'\')\">');WA(D,'04','View item audit history')}}
tb='<table cellpadding=0 cellspacing=0>'
tb0='<table cellpadding=0 cellspacing=0 border=0>'
tb1=tb+'<tr><td>'
tb2=tb+'<tr>'
tb3='<td>'+tb+'<tr>'
tbs='<table border=0 cellpadding=0 cellspacing=0 '
et1='</td></tr></table>'
im='<td><img src='+bURL_RM_RID
im2='<img src='+bURL_RM_RID
OCTB=' onclick=\"return top.TB()\"'
OCTB2=OCTB+'>'
function Im(i){return im+i+'></td>'}
function Im2(i){return im2+i+'>'}
function Rb(s){return im+(s?'73':'74')+'></td>'}
function Rb2(s){return im2+(s?'73':'74')+'>'}
function Rb3(D,s){D.write(im,s?'73':'74','></td>')}
function Cb(s){return im+(s?'75':'76')+'></td>'}
function Cb2(s,h){return im2+(s?'75':'76')+(h&&h!=''?' id=\"item_notsv_id\" alt=\"'+h+'\" title=\"'+h+'\"':'')+'>'}
function Cb3(D,s){D.write(im,s?'75':'76','></td>')}
function TBL(p,e){return'<table border=0 cellspacing=0 cellpadding='+p+'>'+(e!=null&&e>0?(e==2?'<tr>':'<tr><td>'):'')}
function TBL2(D,p,e){D.write(TBL(p,e))}
function NELCH(D,a){D.write(tb0,'<tr>',im,'7B></td>',im,'7C width=',a,' height=2></td>',im,'7D></td></tr>')}
function NELE(D,a,b,c,d){D.write('<tr>',im,'7E height=19 width=2></td>','<td bgcolor=',a,' width=',b,' height=19 nowrap><a href=\"',c,'\"',OCTB2,'<nobr>',d,'</nobr></a></td>',im,'7F height=19 width=2></td></tr>')}
function NELCF(D,a){D.write('<tr>',im,'80></td>',im,'81 width=',a,' height=2></td>',im,'82></td></tr></table>')}
function ESL(D,w,t,c){if(c>0)D.write('<td>')
D.write(tb0,'<tr>',Im('13D'),'<td class=pdm width=',w,' nowrap><nobr>',"!unk!"==t?AM[0]:t,'</nobr></td>',Im('13F'),'</tr></table>')
if(c>0)D.write('</td>')}
function ESL2(D,w,t,u,v,c,ca){if(c!='')CP1(D,ca,c)
D.write(tb0,'<tr>',Im('13D'),'<td class=pdm width=',w,' nowrap><nobr>',"!unk!"==t?AM[0]:t,'</nobr></td>',Im('13F'));v>0?eval(u):D.write('<td>',u,'</td>');D.write('</tr></table>')
if(c!='')CP2(D,ca,c)}
function PPTA(t){var s=t.replace(/~\|~/g,'<br>')
return s.replace(/ /g,'&nbsp;')}
function NTA(D,w,h,u,t,c,a){var dcm=D;if(c!='')CP1(D,a,c)
if(u!='')D.write(tb1)
D.write('<table class=txa cellspacing=0 cellpadding=2><tr><td width=',w,' height=',h,' nowrap>',PPTA(t),'</td></tr></table>')
if(u!=''){eval(u);D.write('</td></tr></table>')}
if(c!='')CP2(D,a,c)}
function ETB(D,w,v,u,t,c,a){var dcm=D;if(c!='')CP1(D,a,c)
D.write(tb0,'<tr>',tb3,Im('140'),'<td class=txm width=',w,' nowrap><nobr>',v,'</nobr></td>',Im('140'),'</tr></table></td>')
if(u!=''){t>0?eval(u):D.write(u)}
D.write('</tr></table>')
if(c!='')CP2(D,a,c)}
function WA(D,b,a){D.write(im2,b,' alt=\"',a,'\" id=\"',b,'\" title=\"'+a+'\"></a></td>')}
function WS(D,t,p,a,q,fn){D.write('<td align=right><a href=\"javascript:',fn&&fn!=''?fn:'BTN','(',t,',\'',p,'\',',a,',',q,')\"',OCTB,' tabindex=-1>')}
function WC(D,o){D.write('<a href=\"javascript:t.CI(',o,',oF[0])\" tabindex=-1>')}
function RenderTimeDropDownList(D,c,i,F,name,scriptletID,st,en,k,p,v,u,h,tabIndex){if(i){D.write('<td>&nbsp;',c,'&nbsp;</td>');}
D.write('<td><select title=\"',h,'\" tabindex=\"',tabIndex,'\" ',!F[0]?' fdc=1':'',' PFOBJ=',scriptletID,' name=',name,' OnFocus=t.OF(',scriptletID,',0,this) OnClick=t.OC(',scriptletID,',0,this) OnChange=t.OH(',scriptletID,',0,this)>','<option',DFS(v==-1),' value=\"\">&nbsp;');for(var j=st;j<=en;j++)
D.write('<option value=\"!pf',k,'!',j,'\"',DFS(v>-1&&v==j),'>',(p?(j<10?'0'+j:j):j));if(u){D.write('<option value=\"!pf',k,'!-99\"',DFS(v==-99),'>',AM[0]);}
D.write('</select></td>');F[0]++;}
function RenderDaySelector(D,c,i,F,name,scriptletID,start,end,v,u,h,tabIndex)
{if(i){D.write('<td>&nbsp;',c,'&nbsp;</td>');}
D.write('<td><select title=\"',h,'\" tabindex=\"',tabIndex,'\" ',!F[0]?' fdc=1':'',' PFOBJ=',scriptletID,' name=',name,' OnFocus=t.OF(',scriptletID,',0,this) OnClick=t.OC(',scriptletID,',0,this) OnChange=t.OH(',scriptletID,',0,this)><option',DFS(v==-1),' value=\"\">&nbsp;');for(var j=start;j<=end;j++){D.write('<option value=\"!pfday','!',j,'\"',DFS(v>-1&&v==j),'>',j,'');}
if(u){D.write('<option value=\"!pfday!-99\"',DFS(v==-99),'>',AM[0]);}
D.write('</select></td>');F[0]++;}
function RenderMonthSelector(D,c,i,F,name,scriptletID,st,en,v,u,h,tabIndex)
{if(i){D.write('<td>&nbsp;',c,'&nbsp;</td>');}
D.write('<td><select title=\"',h,'\" tabindex=\"',tabIndex,'\" ',!F[0]?' fdc=1':'',' PFOBJ=',scriptletID,' name=',name,' OnFocus=t.OF(',scriptletID,',0,this) OnClick=t.OC(',scriptletID,',0,this) OnChange=t.OH(',scriptletID,',0,this)><option',DFS(v==-1),' value=\"\">&nbsp;');for(var j=st;j<=en;j++){D.write('<option value=\"!pfmon!',j,'\"',DFS(v>-1&&v==j),'>',AM[j],'');}
if(u){D.write('<option value=\"!pfmon!-99\"',DFS(v==-99),'>',AM[0]);}
D.write('</select></td>');F[0]++;}
function RenderYearSelector(D,c,i,F,cn,scriptletID,st,en,v,u,h,tabIndex){if(i){D.write('<td>&nbsp;',c,'&nbsp;</td>');}
D.write('<td><select title=\"',h,'\" tabindex=\"',tabIndex,'\" ',!F[0]?' fdc=1':'',' PFOBJ=',scriptletID,' name=',cn,' OnFocus=t.OF(',scriptletID,',0,this) OnClick=t.OC(',scriptletID,',0,this) OnChange=t.OH(',scriptletID,',0,this)><option',DFS(v==-1),' value=\"\">&nbsp;');for(var j=st;j<=en;j++){D.write('<option value=\"!pfyea!',j,'\"',DFS(v>-1&&v==j),'>',j,'');}
if(u){D.write('<option value=\"!pfyea!-99\"',DFS(v==-99),'>',AM[0]);}
D.write('</select></td>');F[0]++;}
function RTM(v,u){if(u&&v==-99)
return'unk';v=parseInt(v);if(v>=0)
return v<10?'0'+v:v;return'';}
tmvc="0123456789unk";function TMKP(e){if(e){ch=String.fromCharCode(e.keyCode);return tmvc.indexOf(ch.toLowerCase())!=-1;}
return false;}
function RenderTimeTextBox(D,i,F,cn,scriptletID,t,pfx,v,u,h,tabIndex){D.write(i?'<td>&nbsp;:&nbsp;</td>':'','<td><input title=\"',h,'\" tabindex=\"',tabIndex,'\" ',!F[0]?' fdc=1':'',' unknown=',u?'1':'0',' dtype=',t,' prefix=!pf',pfx,'! class=tm type=text name=',cn,' size=3 maxlength=3 OnChange=t.OH(',scriptletID,',0,this) onFocus=t.OF(',scriptletID,',0,this) onBlur=t.OB(',scriptletID,',0,this)',' onClick=t.OC(',scriptletID,',0,this) onKeyPress=\"return top.TMKP(event)\" pfobj=',scriptletID,' value=',RTM(v,u),'></td>');F[0]++;}
aTFS=['hh','mm','ss'];function RTF(aT)
{var s='';if(aT[0]||aT[1]||aT[2])
{s='[';for(var i=0,j=0;i<3;i++)
{if(aT[i])
{if(j)
s+=':';s+=aTFS[i];j++}}
s+=']';}
return s;}
function Display24HourString(D,aT,hr,k)
{D.write('<td style=vertical-align:middle nowrap>&nbsp;&nbsp;',(hr?'<i>24-hour&nbsp;clock</i>&nbsp;':''),k?RTF(aT):'','</td>');}
function RenderDateTimeControl(D,caption,captionAlignment,controlName,scriptletId,dateOrderStr,timeOrderStr,startYear,endYear,dateValueStr,timeValueStr,unknownMask,dateSeparator,displayAsText,beginningTabIndex){var i,F=new Array(),n,c;F[0]=0;var tabIndex=beginningTabIndex;D.write('<table cellspacing=0 cellpadding=2 border=0>');if((dateOrderStr=="")&&(timeOrderStr==""))
D.write('<tr><td>',(caption==''?'&nbsp;':caption),'</td></tr>');else
{if(caption!="")
{if(captionAlignment==4)
D.write('<tr><td colspan=10>',caption,'</td></tr>');D.write('<tr>');if(captionAlignment==1)
D.write('<td valign=top rowspan=2>',caption,'&nbsp;</td>');D.write('<td>',tb);}
if(dateOrderStr!="")
{D.write('<tr><td>',tb0,'<tr>');for(i=0,n=dateOrderStr.length;i<n;i++){switch(dateOrderStr.charAt(i)){case'M':RenderMonthSelector(D,dateSeparator,i,F,controlName,scriptletId,1,12,dateValueStr[i],unknownMask&2,'Enter month',tabIndex++);break;case'D':RenderDaySelector(D,dateSeparator,i,F,controlName,scriptletId,1,31,dateValueStr[i],unknownMask&4,'Enter day',tabIndex++);break;case'Y':RenderYearSelector(D,dateSeparator,i,F,controlName,scriptletId,startYear,endYear,dateValueStr[i],unknownMask&1,'Enter year',tabIndex++);break;}}
var aName="A"+controlName;var anchorRef='<td>&nbsp;<A HREF=\"#\" onClick=\"top.prePopulateCal(\''+aName+'\',this.document);return false;\" NAME=\"'+aName+'\" ID=\"'+aName+'\"><IMG src=\"./pfts.dll?C=ResMgr_1&pfLang=en-US&pfR=CalIcon\"></A></td>';D.write(anchorRef);D.write('</tr></table></td></tr>');}
if(timeOrderStr!="")
{D.write('<tr><td>',tb0,'<tr>');var aT=[false,false,false],hr=false;for(i=0,n=timeOrderStr.length;i<n;i++){switch(timeOrderStr.charAt(i)){case'h':{displayAsText?RenderTimeTextBox(D,i,F,controlName,scriptletId,'h',"hou",timeValueStr[i],unknownMask&8,'Enter hour (0-23)',tabIndex++):RenderTimeDropDownList(D,':',i,F,controlName,scriptletId,0,23,"hou",1,timeValueStr[i],unknownMask&8,'Enter hour (0-23)',tabIndex++);if(displayAsText)
aT[0]=true;hr=true;break;}
case'm':{displayAsText?RenderTimeTextBox(D,i,F,controlName,scriptletId,'m',"min",timeValueStr[i],unknownMask&16,'Enter minutes (0-59)',tabIndex++):RenderTimeDropDownList(D,':',i,F,controlName,scriptletId,0,59,"min",1,timeValueStr[i],unknownMask&16,'Enter minutes (0-59)',tabIndex++);if(displayAsText)
aT[1]=true;break;}
case's':{displayAsText?RenderTimeTextBox(D,i,F,controlName,scriptletId,'s',"sec",timeValueStr[i],unknownMask&32,'Enter seconds (0-59)',tabIndex++):RenderTimeDropDownList(D,':',i,F,controlName,scriptletId,0,59,"sec",1,timeValueStr[i],unknownMask&32,'Enter seconds (0-59)',tabIndex++);if(displayAsText)
aT[2]=true;break;}}}
Display24HourString(D,aT,hr,1);E18(D);}
if(caption!="")
{D.write('</table></td>');if(captionAlignment==3)
D.write('<td valign=top rowspan=2>&nbsp;',caption,'</td>');D.write('</tr>')
if(captionAlignment==6)
D.write('<tr><td colspan=10>',caption,'</td></tr>');}}
D.write('</table>');}
tmMsk=[8,16,32];function GTM(tm,aT){for(var i=0;i<3;i++)
if(tm&tmMsk[i])
aT[i]=true;}
function DT(D,Dt,T,a,c,r,w,s,t,tm)
{var i,n,v;if(c!="")CP1(D,a,c);D.write(tb);n=Dt.length;if(n>0){if(s=="")s="/"
D.write('<tr><td><table cellspacing=0 cellpadding=2><tr>');for(i=0;i<n;i++)
{if(n>1&&i>0)
D.write('<td>&nbsp;',s,'&nbsp;</td>');r>0?ESL(D,w,Dt[i],1):PSL(D,w,Dt[i],1);}
E18(D)}
n=T.length;if(n>0){var del='<td>&nbsp;:&nbsp;</td>';D.write('<tr><td><table cellspacing=0 cellpadding=2><tr>');if(t)
for(i=0;i<n;i++)
{if(i>0)D.write(del);D.write('<td>');v=T[i].toLowerCase()=='!unk!'?'unk':T[i];r>0?ETB(D,32,v,'',0,'',0):PTB(D,32,v,'',0,'',0);D.write('</td>');}
else
for(i=0;i<n;i++)
{if(i>0)D.write(del);r>0?ESL(D,w,T[i],1):PSL(D,w,T[i],1);}
var aT=[false,false,false];GTM(tm,aT);Display24HourString(D,aT,aT[0]);E18(D);}
D.write('</table>');if(c!="")CP2(D,a,c);}
function CP1(D,a,c){if(c!="")switch(a){case 1:D.write(tb,'<tr><td class=cpl>',c,'</td><td valign=top>');break
case 4:D.write(tb,'<tr><td class=cpt colspan=10>',c,'</td></tr><tr><td>');break
case 3:D.write(tb,'<tr><td class=cpr valign=top>');break
case 6:D.write(tb,'<tr><td>');break}}
function CP2(D,a,c){if(c!="")switch(a){case 1:case 4:D.write('</td></tr></table>');break
case 3:D.write('</td><td class=\"vrb\">&nbsp;&nbsp;',c,'</td></tr></table>');break
case 6:D.write('</td></tr><tr><td class=cpb colspan=10>',c,'</td></tr></table>');break}}
function SetTextBoxEventHandlers(D,scriptletID){D.write(' OnFocus=t.OF(',scriptletID,',0,this) OnClick=t.OC(',scriptletID,',0,this) OnChange=t.OH(',scriptletID,',0,this) OnBlur=t.OB(',scriptletID,',0,this) OnKeyPress=\"return top.OK(',scriptletID,',0,this)\">');}
function RenderTextBox(D,name,size,maxLen,value,scriptletID,a,c,t,u,extraAttrs){var dcm=D;if(c!="")
CP1(D,a,c);D.write('<input type=text name=\"',name,'\" pfobj=',scriptletID,' size=',size+1,' maxlength=',maxLen,' value=\"',value,'\" ',extraAttrs);SetTextBoxEventHandlers(D,scriptletID);if(u!='')
t>0?eval(u):D.write(u);if(c!="")
CP2(D,a,c);}
function RenderFileTextBox(D,name,size,maxLen,value,scriptletID){D.write('<input type=file name=\"',name,'\" pfobj=',scriptletID,' size=',size,' maxlength=',maxLen,' value=\"',value,'\"');SetTextBoxEventHandlers(D,scriptletID);}
function RenderPwdTextBox(D,name,size,maxLen,value,scriptletID,a,c,t,u,extraAttrs){if(c!="")
CP1(D,a,c);D.write('<input type=password name=\"',name,'\" pfobj=',scriptletID,' size=',size,' maxlength=',maxLen,' value=\"',value,'\" ',extraAttrs);SetTextBoxEventHandlers(D,scriptletID);if(u!='')
t>0?eval(u):D.write(u);if(c!="")
CP2(D,a,c);}
function RenderTextArea(D,name,rows,cols,scriptletID,a,c,value,extraAttrs){if(c!="")
CP1(D,a,c);D.write('<textarea name=\"',name,'\" pfobj=',scriptletID,' rows=',rows,' cols=',cols,' ',extraAttrs);SetTextBoxEventHandlers(D,scriptletID);D.write(value,'</textarea>');if(c!="")
CP2(D,a,c)}
function RenderTextAreaWithUnits(D,name,rows,cols,scriptletID,a,c,value,t,u,extraAttrs){var dcm=D;if(c!="")
CP1(D,a,c);T5(D);D.write('<textarea name=\"',name,'\" pfobj=',scriptletID,' rows=',rows,' cols=',cols,' ',extraAttrs);SetTextBoxEventHandlers(D,scriptletID);D.write(value,'</textarea></td>');if(u!=''){D.write('<td>');t>0?eval(u):D.write(u);D.write('</td>')}
D.write('</tr></table>');if(c!="")
CP2(D,a,c);}
function RenderControlPanelButton(doc,title,linkText,jScriptLine,target,onClick,returnFlag,paddingFlag,jScriptFlag,htmlID,extraAttrs){if((extraAttrs=="")||(jScriptFlag==0)){var link="";if(jScriptLine!=""){link='<a href=\"'+(jScriptFlag>0?'javascript:':'')+jScriptLine+'\"'
if(onClick!="")link+=' onclick=\"'+(returnFlag>0?'return top.':'top.')+onClick+'\"'
if(target!="")link+=' target=\"'+target+'\"'
link+=' id=\"'+htmlID+'\" class=\"buttonNofloat '+(paddingFlag==0?' padLeft\"':(paddingFlag==1?' padRight\"':'\"'))+' '+extraAttrs+' />'}
doc.write('<td title=\"',title,'\" >',link,'<span>',linkText,'</span></a>','</td>')}
else{if((jScriptLine.indexOf("javascript")!=-1)||(onClick.indexOf("javascript")!=-1)){RenderControlPanelButton(doc,title,linkText,jScriptLine,target,onClick,returnFlag,paddingFlag,jScriptFlag,htmlID,"");return;}
var onClickFuncName=htmlID+'_OnClick';var funcScriptStr;if(extraAttrs.indexOf("actiontype='SubmitAndNext'")!=-1)
{funcScriptStr='<script type=\"text/javascript\"> function '+onClickFuncName+'(){ '+jScriptLine+'; return false;}</script>';}
else
{var onClickFunc="";if(onClick!=""){if(returnFlag==1){onClickFunc+='if(top.'+onClick+' == false) return false; ';}
else{onClickFunc+='top.'+onClick+'; ';}}
funcScriptStr='<script type=\"text/javascript\"> function '+onClickFuncName+'(){'+onClickFunc+jScriptLine+'; return false;}</script>';}
doc.write(funcScriptStr);var htmlStr='<a href=\"javascript:{}\" onclick=\"javascript:{return '+onClickFuncName+'();}\"';if(target!="")htmlStr+=' target=\"'+target+'\"';htmlStr+=' id=\"'+htmlID+'\" class=\"buttonNofloat '+(paddingFlag==0?' padLeft\"':(paddingFlag==1?' padRight\"':'\"'))+' '+extraAttrs+' />';doc.write('<td title=\"',title,'\" >',htmlStr,'<span>',linkText,'</span></a>','</td>');}}
function CBS(D,h,t,a,s){D.write('<td title=\"',h,'\">',tbs,'align=center><tr>',a==0?'<td class=sp>&nbsp;</td>':'',Im('DD'),'<td class=',s&&s>0?'bm3':'bm2',' nowrap>',t,'</td>',Im('DF'),a==1?'<td class=sp>&nbsp;</td>':'','</tr></table></td>')}
function HB(D,h,t,p,f,k,r,id){var e="",j=(h==""?'':' title=\"'+h+'\"');var htmlid=(id==null?'':' id='+id);if(k!="")
e+=' onclick=\"'+(r>0?'return ':'')+'t.'+k+'\"';if(f!="")
e+=' target=\"'+f+'\"';D.write('<a class=\"buttonNofloat\"',j,htmlid,' href=\"',p,'\"',e,'><span>',t,'</span></a>');}
function HBS(D,h,t){D.write(tbs,'class=GB><tr>',Im('DD'),'<td nowrap class=bm',h==''?'':' title=\"'+h+'\"','><span class=GB>',t,'</span></td>',Im('DF'),'</tr></table>')}
function HBAE(D,h,t,l){D.write(tb0,'<tr>',Im('DD'),'<td class=aem nowrap><a class=ae href=',l,h==''?'':' title=\"'+h+'\"','id=add_entry_id>',t,'</a></td>',Im('DF'),'</tr></table>')}
ES=["&nbsp;","Enrolled","Randomized","Complete","Not Complete"," "]
function QV(D,C,F,Q,sc,sd,m,c1,c2,c3){D.write('<table width=100% border=0 cellpadding=2 cellspacing=1>')
QVH(D,C,sc,sd,m,c1);D.write('<tbody>');for(var i=0,n=F.length;i<n;i++){D.write('<tr',i%2?' class=dr':'','>');QVD(D,F[i],Q[i],i,m,c2,c3);D.write('</tr>')}
D.write('</tbody></table>')}
function Im2withTooltip(image,tooltip){var imgtag=im2+image;imgtag=imgtag+' alt=\"'+tooltip+'\" title=\"'+tooltip+'\">';return imgtag;}
function getQueryIconAndToolTip(enumState){var image=queryStatusIcons[enumState];var tooltip=queryStatusTooltips[enumState];var imgtag=Im2withTooltip(image,tooltip);return imgtag;}
function QVH(D,C,sc,sd,m,c1){u=sesURL_TM+c1
D.write('<thead class=\"fixedHeader\"><tr>',(m==1?'<th width=1 rowspan=1></th>':''),'<th width=60 class="ctr">Status</th>',m==1?'<th>Age</th>':PSUWithToolTip('Age','Sort by days since the query was last modified',sc,8,sd,u+C[7]),m==1?'<th>Site</th>':PSU('Site',sc,1,sd,u+C[0]),m==1?'<th>Subject</th>':PSU('Subject',sc,2,sd,u+C[1]),m==1?'<th>Visit</th>':PSU('Visit',sc,3,sd,u+C[2]),m==1?'<th>CRF</th>':PSU('CRF',sc,4,sd,u+C[3]),m==1?'<th>Issuer</th>':PSU('Issuer',sc,6,sd,u+C[5]),'<th>Description</th></tr></thead>');}
function QVD(D,oF,oQ,i,m,c2,c3){var cl=i%2?' class=dr':'',j,n
var status=oF[0];oF[0]=getQueryIconAndToolTip(status);if(oF[1]==0)
oF[1]="New";else
oF[1]=oF[1];if(status==3||status==4)
oF[1]=""
if(m==1)IC(D,oQ[0],1,0,'',0)
if(oF.length>0)
{D.write('<td nowrap class=ctr2> <a',cl,' href=javascript:VQ(',oQ[2],') onclick=\"return top.TB()\">',oF[0],'</a></td>')
for(j=1,n=oF.length;j<n;j++)D.write('<td nowrap >',oF[j],'</td>')}
var htmlid=GetHTMLIDForQuery(oQ[1]);D.write('<td colspan=8>','<a',cl,' href=javascript:VQ(',oQ[2],') id=\"',htmlid,'\" onclick=\"return top.TB()\">',oQ[1],'</a></td>')}
function IC(D,n,r,c,b,s,cl){D.write('<td',cl&&cl!=''?' class='+cl:'',(r>1?' rowspan='+r:''),(c==0?' width=1':' align=center'),(b==""?'':' bgcolor='+b),'><input type=checkbox value=1 OnClick=t.SB() name=!is!',n,DFC(s!=0),'></td>');}
function IC2(D,r,b,c){D.write('<td width=1',r>1?' rowspan='+r:'','>',Cb2(c,c?'Item source verified':'Item not source verified'),'</td>')}
function IH2(d,u,r,t,b,ds,ms){var l=u+"&pfDocID="+d+"&pfDocRevision="+r+"&pfDocType="+t+"&pfDocDisp=1&pfTimeout=1"+(b==""?"":"&pfDocLink="+b)+"&NPPg="+ds+"&NPTot="+ms+"&NPEPP=30";top.Help(l);}
function HLP(D,h,t){if(h==null||h==''){D.write(t==''?'&nbsp;':t);}
else{D.write('<a href=\"javascript:',h,'\" tabindex=-1>',t==''?'&nbsp;':t,'</a>');}}
function RenderRadioBoxWithUnits(D,N,s,I,T,extraAttrs){for(var j=0,n=I.length;j<n;j++){D.write('&nbsp;<span class=\"vrb\"><input type=radio onClick=t.SB() name=!ut!',N,' ',extraAttrs,' value=',I[j],DFC(s==j),'>',T[j],'</span>');}}
function RenderRadioUnitsForPrint(D,T,s,p){D.write('<td valign=middle nowrap',p>0?' rowspan='+p:'','>',tb2);for(var i=0,n=T.length;i<n;i++)
D.write('<td class=rbu>',Rb2(s==i),'</td><td valign=\"middle\" style=\"vertical-align:middle;\">',T[i],'</td>');D.write('</tr></table></td>');}
function RenderAnnotatedRadioUnitsForPrint(D,U){D.write('<td>&nbsp;&nbsp;</td><td valign=top nowrap>',tb2,'<tr>');for(var i=0,n=U.length;i<n;i++)
D.write('<td>&nbsp</td>',Rb(0),'<td><nobr>',U[i],'</nobr></td>');D.write('</tr></table></td>');}
function RenderPullDownWithUnits(D,N,s,I,T,extraAttrs){D.write('&nbsp;<select name=!ut!',N,' ',extraAttrs,' onChange=t.SB()><option value=0',DFS(s<=0),'>&nbsp;');for(var j=0,n=I.length;j<n;j++)
D.write('<option value=',I[j],DFS(s==j),'>',T[j]);D.write('</select>');}
function RenderPulldownUnitsForPrint2(D,w,t,p){var rs=p>0?' rowspan='+p:'';D.write('<td',rs,'>&nbsp;</td><td',rs,' valign=top nowrap>',tb0,'<tr>',Im('13D'),'<td class=pdm width=',w,' nowrap>',t,'</td>',Im('13F'),'</tr></table></td>');}
function RenderPulldownUnitsForPrint3(D,w,t,p){var rs=p>0?' rowspan='+p:''
D.write('<td',rs,'>&nbsp;</td><td',rs,' valign=top nowrap>',tb0,'<tr>',Im('13D'),'</td><td class=pdm width=',w,' nowrap>&nbsp;',t,'</td>',Im('13F'),'</tr></table></td>')}
function HD(D,N,V){for(var i=0,m=N.length;i<m;i++)D.write('<input type=hidden name=',N[i],' value=\"',V[i],'\">')}
function BL(D,n){for(var i=0;i<n;i++)D.write('<tr><td colspan=100>&nbsp;</td></tr>')}
function Bl(D){D.write('<tr><td colspan=100>&nbsp;</td></tr>')}
function FH(D,h,b){D.write('<tr><td colspan=100 class=',(b?'chl':'chd'),'>',(h.indexOf('javascript:')>=0?eval(h.substr(11)):h),'</td></tr>')}
function T(D){D.write(tb)}
function T2(D){D.write('<tr><td colspan=25>',tb)}
function T3(D){D.write(tb2)}
function T4(D){D.write(tbs,'width=100% height=100% valign=middle>')}
function T5(D){D.write(tb1)}
function T6(D){T(D);T2(D)}
function T7(D){T3(D);TD2(D)}
function T8(D){D.write('</table></td></tr>')}
function T9(D){D.write('</td></tr>');T8(D);T8(D)}
function T10(D){D.write(tbs,'valign=top><tr>')}
function T11(D){D.write(et1)}
function T12(D){D.write("<td rowspan=50>")}
function TC(D){D.write('</table>')}
function B1(D){D.write(tb1,'&nbsp;</td></tr></table>')}
function B2(D){D.write(tb1,'&nbsp;</td></tr><tr><td>')}
function InitQuerySlidingDivs(){sliderDown=false;slidingDivInProcess=false;divNameThatIsDown="NoDivsDown";}
function GetHTMLIDForQuery(queryText){var htmlid='';queryText2=queryText.toLowerCase();if(queryText2.indexOf('diastolic blood')!=-1)
{htmlid="diastolic_blood_pressure_id"
return htmlid;}
if(queryText2.indexOf('temperature is')!=-1)
{htmlid="temperature_range_id"
return htmlid;}
if(queryText2.indexOf('heart rate')!=-1)
{htmlid="query_heart_rate_id"
return htmlid;}
if(queryText2.indexOf('respiratory rate')!=-1)
{htmlid="query_respiratory_rate_id"
return htmlid;}
if(queryText2.indexOf('end date')!=-1)
{htmlid="query_enddate_startdate_id"
return htmlid;}
if(queryText2.indexOf('value is')!=-1)
{htmlid="query_notexpected_range_id"
return htmlid;}
switch(queryText)
{case'Item incomplete':htmlid='query_itemincomplete_id'
break;case'Data does not match source':htmlid='query_datadoesntmatch_id'
break;case'Missing units':htmlid='query_missingunits_id'
break;case'Original value is correct':htmlid='query_originalvaluecorrect_id'
break;case'Response does not satisfy query':htmlid='query_responsedoesntsatisfy_id'
break;default:htmlid=''
break;}
return htmlid;}
function QAC(D,u,c,I,T,p,queryType,queryDateTimeList,queryUserList,answeredQueryTextList){D.onreadystatechange=InitQuerySlidingDivs
D.write('<tr><td class=aq colspan=',c,'>')
for(var j=0,n=I.length;j<n;j++){var queryTitle='View item query'
var htmlid=''
htmlid=GetHTMLIDForQuery(T[j])
if(queryType[j]=="Open"){D.write('<div class=\"qrd\">',im2,p>0?'146':'13C',' vspace=2><a class=qry id=\"',htmlid,'\" href=\'javascript:oL.href=\"',u,I[j],'\"\' title=\"View item query\"',OCTB2,im2,'QUERY-STATUS-OPEN class=\"opn\" alt=\"Open\" title=\"Open\" id=\"QUERY-STATUS-OPEN\" />',T[j],'</a></div>')}
else{D.write('<div class=\"qrd\">',im2,p>0?'146':'13C',' vspace=2><a class=qry id=\"',htmlid,'\" style=\"color: black\" href=\'javascript:oL.href=\"',u,I[j],'\"\' title=\"View item query\"',OCTB2,im2,'QUERY-STATUS-ANSWERED class=\"opn\" alt=\"Answered\" title=\"Answered\" />',T[j],'</a><img class=\"flt\" title=\"Click for Query Details\" src=',bURL_RM_RID,'41 OnClick=jQuery(\"#d',I[j],'\").slideToggle(\"slow\",\"linear\") />','</div>')
D.write('<div id=\"d',I[j],'\" style=\"display:none;\">')
D.write('<div class=\"qryfltdiv\">')
D.write('<div class=aqh style=\"width:300px;\">')
D.write('<label class=aqh style=\"padding-top:2px;\">Query Details</label>')
D.write('</div><label class=aqhh>Date Answered:  </label></br>')
D.write('<label class=aqhi>',queryDateTimeList[j],'</label></br>')
D.write('<label class=aqhh>Answered By:  </label><br>')
D.write('<label class=aqhi>',queryUserList[j],'</label></br>')
D.write('<label class=aqhh>Answer:  </label></br>')
D.write('<label class=aqhi>',answeredQueryTextList[j],'</label></br>')
D.write('</div></div>')}}
D.write('</td>')
D.write('</tr>')}
function QA(D,u,c,I,T,p){D.write('<tr><td class=qnr colspan=',c,'>')
for(var j=0,n=I.length;j<n;j++){D.write(j>0?'<br>':'',im2,p>0?'146':'13C',' vspace=2><a class=qry href=\'javascript:oL.href=\"',u,I[j],'\"\' title=\"View item query\"',OCTB2,T[j],'</a>')}
D.write('</td></tr>')}
function QI(D,c,T,p,queryTypes){D.write('<tr><td class=qnr colspan=',c,'>')
for(var j=0,n=T.length;j<n;j++){if(queryTypes[j]=="Answered"){D.write('<div class=\"qrd\">',im2,p>0?'146':'13C','>',im2,'QUERY-STATUS-ANSWERED class=\"opn\" alt=\"Answered\" title=\"Answered\" /><Label style=\"Color:Black;text-decoration:underline\">',T[j],'</Label></div>')}
else{D.write('<div class=\"qrd\">',im2,p>0?'146':'13C','>',im2,'QUERY-STATUS-OPEN class=\"opn\" alt=\"Open\" title=\"Open\" />',T[j],'</div>')}}
D.write('</td></tr>')}
function RenderPullDownList(D,name,scriptletID,f,s,u,c,a,v,extraAttrs){if(c!=""){CP1(D,a,c);}
D.write(tb1,'<select name=',name,' ',extraAttrs,' PFOBJ=',scriptletID,' onchange=t.OH(',scriptletID,',0,this) onmousedown=t.OC(',scriptletID,',0,this)>');if(f>0){D.write('<option value=\"\"',DFS(s==0),'>&nbsp;');}
for(var i=0,m=v.length;i<m;i=i+2){D.write('<option value=\"',v[i+1],'\"',DFS(s==i/2+1),'>',v[i]);}
D.write('</select></td>',u==''?'':'<td valign=top>'+u+'</td>','</tr></table>');if(c!=""){CP2(D,a,c);}}
function RenderContextMenuPullDownList(D,n,o,f,s,u,h,c,a,V,T,extraAttrs){D.write(c!=''?'<td>'+c+'</td>':'','<td',a>0?' class=pdc':'','><select id=',n,' name=',n,' ',extraAttrs,' ',o!=""?' onChange=\"'+o+'\"':'','>');if(f>0){D.write('<option value=\"\"',DFS(s==0),'>&nbsp;');}
for(var i=0,m=V.length;i<m;i++){D.write('<option value=\"',V[i],'\"',DFS(s==i+1),'>',T[i]);}
D.write('</select></td>');}
function IR(D,g,w,h){D.write('<tr><td colspan=25 align=top nowrap>',im2,g,'width=',w,(h>0?' height='+h:''),'></td></tr>')}
function A(D,j,i,h,s){D.write('<a href=javascript:',j,'>',im2,i,(h!=""?' alt=\"'+h+'\" title=\"'+h+'\"':''),'></a>');pad(D,s)}
function A2(D,n,v){var rCode=(n==1)?"E9":"EA";var msg=(n==1)?"Navigate by visit":"Navigate by form";var tfunc=(n==1)?",t.C.vi?t.C.vi:t.C.CRFBody.MasterCRFBody.vi":",t.C.ip?t.C.ip:t.C.CRFBody.MasterCRFBody.ip";D.write(im2,rCode,' class=lnk onclick=VBN(',n,tfunc,')',' alt=\"',msg,'\" title=\"',msg,'\"',v>0?' vspace='+v:'','>');}
function A3(D,j,i,h,s){D.write('<a href=javascript:',j,'>',im2,i,h!=""?' alt=\"'+h+'\"'+' title=\"'+h+'\"':'',OCTB2,'</a>');pad(D,s)}
function A4(D,j,i,h,s){D.write('<td>');A3(D,j,i,h,s);D.write('</td>')}
function PCD(c){return'<area shape=rect coords='+(c?'21,0,41,19':'0,0,19,19')}
function PNA(D,P,H,i,t,c){D.write(PCD(c),' href=javascript:PNM(\"',P[i],'\") alt=\"Go to ',t,' Subject: ',H[i],'\" title=\"Go to ',t,' Subject: ',H[i],'\">')}
function PNN(D,t,c,id1){D.write(PCD(c),' nohref alt=\"',t,'\" title=\"',t,'\" id=\"',id1,'\">')}
function PM(D,P,H){D.write('<map name=n1>')
var f='At the first subject',l='At the last subject'
P[0]!='0'?PNA(D,P,H,0,'first',0):PNN(D,f,0,"first_id")
P[1]!='0'?PNA(D,P,H,1,'previous',1):PNN(D,f,1,"previous_id")
D.write('</map><map name=n2>')
P[2]!='0'?PNA(D,P,H,2,'next',0):PNN(D,l,0,"next_id")
P[3]!='0'?PNA(D,P,H,3,'last',1):PNN(D,l,1,"last_id")
D.write('</map>')}
function SP1(c,t,s){return c+':&nbsp;<span class=ttl2>'+t+'</span>'+(s&&s>0?'&nbsp;&nbsp;&nbsp;':'')}
function PN1(D,s,v,pni){D.write('<tr><td nowrap>',TBL(1,1),SP1('Site',s),'</td></tr><tr><td>',SP1('Subject',pni,1),SP1('Visit',v),'&nbsp;</td></tr></table></td>')}
function pad(D,s){for(var i=0;i<s;i++)D.write('&nbsp;')}
function IN(D,s,T,V,is){D.write('<td align=right nowrap>',tbs,'align=right><tr>',im,'F2 usemap=#n1></td><td><select name=pt onChange=GTP(this)>');for(var i=0,m=V.length;i<m;i++){D.write('<option value=\"',V[i],'\"',is==i?SEL:'','>',T[i]);}
D.write('</select></td>',im,'F3 usemap=#n2></td><td>&nbsp;&nbsp;</td>');}
function O(D,s){D.write(s)}
function OP(D,f,u){D.write('<a href=\'javascript:',f,'.location.href=\"',u,'\"\'>',im2,'ED id=\"order_patient_image\" alt=\"Set subject order in current site\" title=\"Set subject order in current site\" vspace=0>','</a>')}
function BH(D,ss){D.write('<body onLoad=LD() onUnLoad=UL() tabindex=-1 class=',(ss==''?'nfrm':ss),'>')}
function BE(D){D.write('</body></html>');}
function FH2(D,s,n,t,e){BH(D,'');DefineForm_3(D,n,t,e);}
function DefineForm_3(D,n,t,e){D.write('<form autocomplete=\"off\" onsubmit=\"return false;\" name=',n,t==''?'':' target='+t,' method=\"post\" style=\"margin:0;\"',e,'>');D.write('<input style=\"position:absolute; top:-5000px;\" tabindex=\"-1\" type=\"submit\" onclick=\"KeyMappingSubmitOrResetForm(\'submit\');\" />');D.write('<input style=\"position:absolute; top:-5000px;\" tabindex=\"-1\" type=\"reset\" onclick=\"KeyMappingSubmitOrResetForm(\'reset\');\"/>');D.write(tbs,'class=\"fm2\">');}
function En(D){En2(D);BE(D);}
function En2(D){Bl(D);E9(D);HF(D)}
function AC(D,l,e){D.write('<a style=\"vertical-align:middle;\" href=',l,' target=C',OCTB,' tabindex=-1>',im2,e>0?'18':'19',' id=\"',e>0?'18':'19','\"','alt=\"',e>0?'View form comment':'Enter a comment for the form','\"',' title=\"',e>0?'View form comment':'Enter a comment for the form','\"></a>')}
function AAUDIT(D,l,e){D.write('<a style=\"vertical-align:middle;\" href=',l,' target=C',OCTB,'tabindex=-1>',im2,e>0?'04':'05',' id=\"',e>0?'04':'05','\"',' alt=\"',e>0?'View form audit history':'No audit history','\"',' title=\"',e>0?'View form audit history':'No audit history','\"></a>')}
function CT1(D){D.write('<tr><td class=ttl nowrap>')}
function CT2(D,p,n){if(top.ControlPanel){top.ControlPanel.setPageTitle('Case Report Forms'+'&nbsp;-&nbsp;'+n+'/'+p+'&nbsp;&nbsp;')};D.write('</td><td class=stl2 nowrap>')}
function CT1A(D){D.write('<tr>');QLTB(D);D.write('<td class=ttl nowrap>&nbsp;')}
function HU(D,u){D.write('<a href=\"javascript:top.Help(\'',u,'\')\" tabindex=-1>')}
function D1(D,c){D.write('<td>&nbsp;',c,'&nbsp;</td>')}
function RenderRadioButton(D,c,name,value,obj,s,i,extraAttrs){D.write(tb2,c>0?'<td width=15>&nbsp;</td>':'','<td><input type=radio name=',name,' pfobj=',obj,' ',extraAttrs,' value=\"',value,'\"',DFC(s>0),' onClick=t.OC(',obj,',',i,',this)></td><td class=\"vrb\">');}
function RenderVertRadioBtn(D,name,value,obj,s,i,extraAttrs){D.write('<tr><td valign=top><input type=radio name=',name,' pfobj=',obj,' ',extraAttrs,' value=\"',value,'\"',DFC(s>0),' onClick=t.OC(',obj,',',i,',this)></td><td class=\"vrb\" colspan=25>');}
function RenderVertDeepRadioBtn(D,name,value,obj,s,i,extraAttrs){D.write('<tr><td colspan=25>',tb2,'<td valign=top><input type=radio name=',name,' pfobj=',obj,' ',extraAttrs,' value=\"',value,'\"',DFC(s>0),' onClick=t.OC(',obj,',',i,',this)></td><td class=\"vrb\">');}
function RenderCheckBox(D,c,name,value,obj,s,i,extraAttrs){D.write(tb2,c>0?'<td width=15>&nbsp;</td>':'','<td><input type=checkbox name=',name,' pfobj=',obj,' ',extraAttrs,' value=\"',value,'\"',DFC(s>0),' onClick=t.OC(',obj,',',i,',this)></td><td class=\"vrb\">');}
function RenderVertCheckBox(D,name,value,obj,s,i,extraAttrs){D.write('<tr><td valign=top><input type=checkbox name=',name,' pfobj=',obj,' ',extraAttrs,' value=\"',value,'\"',DFC(s>0),' onClick=t.OC(',obj,',',i,',this)></td><td class=\"vrb\" colspan=25>');}
function RenderVertDeepCheckBox(D,name,value,obj,s,i,extraAttrs){D.write('<tr><td class="vrb" colspan=25>',tb2,'<td valign=top><input type=checkbox name=',name,' pfobj=',obj,' ',extraAttrs,' value=\"',value,'\"',DFC(s>0),' onClick=t.OC(',obj,',',i,',this)></td><td class=\"vrb\">');}
function ERB(D,c,s){D.write(tb2,c>0?'<td width=15>&nbsp;</td>':'','<td>',im2,s>0?'73':'74',' valign=top></td><td>')}
function V2(D,s){D.write('<tr><td>',Rb2(s),'</td><td class=\"vrb\" colspan=25>')}
function VDERB(D,s){D.write('<tr><td class=\"vrb\" colspan=25>',tb1,Rb2(s),'</td><td>')}
function PRB(D,c,s){D.write(tb2,c>0?'<td width=15>&nbsp;</td>':'',Rb(s),'<td>')}
function V3(D,s){D.write('<tr>',Rb(s),'<td class=\"vrb\" colspan=25>')}
function VDPRB(D,s){D.write('<tr><td class=\"vrb\" colspan=25>',tb2,Rb(s),'<td>')}
function ECB(D,c,s){D.write(tb2,c>0?'<td width=15>&nbsp;</td>':'','<td>',Cb2(s),'</td><td>')}
function PCB(D,c,s){D.write(tb2,c>0?'<td width=15>&nbsp;</td>':'','<td>',Cb2(s),'</td><td>')}
function VECB(D,s){D.write('<tr><td>',Cb2(s),'</td><td class=\"vrb\" colspan=25>')}
function VDECB(D,s){D.write('<tr><td colspan=25>',tb1,Cb2(s),'</td><td>')}
function VPCB(D,s){D.write('<tr>',Cb(s),'<td class=\"vrb\" colspan=25>')}
function VDPCB(D,s){D.write('<tr><td class=\"vrb\" colspan=25>',tb2,Cb(s),'<td>')}
function MF(D,p){D.write('<tr><td><table class=fm border=1 bordercolor=',p>0?'#888888':'#d0dde9',' cellpadding=4 cellspacing=0>')}
function I(D,w,r,b){D.write('<td width=',w>0?w+'%':'1',r>1?' rowspan=2':'',IB[b],'>')}
function I2(D,r){D.write('<td width=1',r>1?' rowspan=2':'','>')}
function I3(D,w,c){D.write('<td',c&&c==2?' class=ms':'',' width=',w>0?w+'%':'1','>')}
function I4(D,r,n,i){D.write('<td class=in',r>1?' rowspan=2':'',i>0?' style=cursor:hand title=\"Item is required\"':'','>',n,i>0?'<sup>*</sup>':'','</td>')}
function RIBC(o){o.style.backgroundColor=o.className=='ms'?'#ffffcc':'#ffffff'}
function SIBC(o){o.style.backgroundColor='#e5f3ff'}
function I5(D,w,c,u,n){D.write('</td><td',c?c==2?' class=ms':c==3?' class=qy':'':'',' width=',w>0?w+'%':'1',u&&u!=''?' title=\"Click to edit item '+n+'\" style=cursor:hand onmouseover=top.SIBC(this) onmouseout=top.RIBC(this) onclick=E('+u+')':'','>')}
function I6(D,r){D.write('</td>');I2(D,r)}
function I7(D,rq,rs){D.write('<td width=1',rq>0?' style=cursor:hand title=\"Item is required\"':'',rs>0?' rowspan=2':'','>',rq>0?'<sup>*</sup>':'&nbsp;','</td>')}
function SN(D,c,p,n){D.write('<tr><td class=nt colspan=',c,'>',n,'</td></tr>')}
function IS1(D){D.write('<tr><td><table border=1 cellspacing=0 cellpadding=4 width=100% align=left>')}
function IS2(D){D.write('<tr><td><table class=is border=1 cellspacing=0 cellpadding=4 width=100% align=left>')}
function IS3(D,c,h){D.write('<tr><td class=hd colspan=',c,'>',h,'</td></tr>')}
function ISR(D,c,p,h,b,bf){D.write('<tr class=\"hd\"><td colspan=\"',c,'\"><table class=\"tbl3\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\"><tr><td class=\"hd\">',h,'</td>')
if(b>0){D.write('<td class=\"ae\">');if(bf!=''){HBAE(D,'Add new row to section','Add Entry','javascript:'+bf+'()');}TD(D);}
E18(D)}
function NS(D){D.write('&nbsp;')}
function NSN(D,n){while(n--)D.write('&nbsp;')}
function TB0(D){D.write(tbs,'width=100% height=100%><tr><td valign=bottom>',tbs,'align=left>')}
function TB1(D){D.write(tbs,'height=100%><tr><td valign=bottom>',tbs,'align=left>')}
function TB2(D){D.write('<td valign=bottom colspan=3 width=100%>',im2,'50 width=100% height=5></td></tr></table></td></tr></table>')}
function GCL(D,c){D.write(TBL(1,2),'<td valign=top>',c,'</td><td>&nbsp;</td><td valign=top>')}
function GCT(D,c){D.write(TBL(2,1),c,'</td></tr><tr><td>')}
function GCB(D,c){TBL2(D,2,1)}
function GCB2(D,c){D.write('</td></tr><tr><td>',c,'</td></tr></table>')}
function GCR(D){TBL2(D,1,1)}
function GCR2(D,c){D.write('</td><td>&nbsp;</td><td valign=top>',c,'</td></tr></table>')}
function GCRI(D){D.write(TBL(1,1),tb1,'&nbsp;</td></tr><tr><td valign=top>')}
function GCRI2(D,c){D.write('</td></tr></table></td><td rowspan=2>&nbsp;</td><td rowspan=2 valign=top>',c,'</td></tr></table>')}
function E1(D){D.write('</td></tr></table>')}
function E2(D){E1(D);E1(D)}
function E3(D){E1(D);E1(D);E1(D)}
function E4(D){E1(D);E1(D);E1(D);E1(D)}
function E6(D){E1(D);D.write('</td></tr>')}
function E7(D){E1(D);E1(D);D.write('</td>')}
function E8(D){E1(D);E1(D);E1(D);D.write('</td>')}
function E9(D){D.write('</table></form>')}
function E10(D){D.write('&nbsp;</td>')}
function E11(D){D.write('&nbsp;</td></tr>')}
function E12(D){D.write('</td></tr>')}
function E14(D){D.write('</td><td width=12>&nbsp;</td><td>')}
function E15(D){D.write('</tr></table></td>')}
function E16(D){D.write('</tr></table></td></tr></table></form>')}
function E17(D){D.write('</tr></table></td></tr></table>')}
function E18(D){D.write('</tr></table></td></tr>')}
function G(D){D.write('</td></tr></table></td>')}
function G1(D){D.write('</td></tr>')}
function G2(D){D.write('&nbsp;')}
function G3(D){D.write('</td></tr><tr><td>')}
function G4(D){D.write('<tr>')}
function G5(D){D.write('<tr><td>')}
function G6(D){D.write('</td><td>')}
function G7(D){D.write('</tr>')}
function G8(D){E6(D);T2(D)}
function G9(D){G(D);TD2(D)}
function J1(D){D.write('</td></tr><tr><td width=1>')}
function J2(D){D.write('<td>&nbsp;</td>')}
function J3(D){D.write('<td width=1>&nbsp;</td>')}
function J3A(D,r){D.write('<td width=1 rowspan=',r,'>&nbsp;</td>')}
function J4(D,n){D.write('<td width=1>',n,'</td>')}
function J5(D,s){D.write('<td align=center>',s,'</td>')}
function J6(D){J2(D);J2(D)}
function J7(D){G1(D);G4(D)}
function J8(D,b){D.write('<table cellspacing=1 cellpadding=4 border=0 width=100%>',arguments>1&&b>0?'<tr><td>&nbsp;</td></tr>':'')}
function J9(D,c,t){D.write('<tr><th class=rep colspan=',c,'>',t,'</th></tr>')}
function K(D,w){D.write('</td><td width=',w,'%>')}
function K2(D,r,n){D.write('<td width=1',r>1?' rowspan=2':'','>',n==''?'&nbsp;':n)}
function K3(D){T(D);G5(D);T3(D);GC2(D,0)}
function MRU(aHistory){if(top.ControlPanel&&top.ControlPanel.updateHistory){top.ControlPanel.updateHistory(aHistory);}}
function hlNav(curr){if(curr.firstChild.getAttribute("src").indexOf("docsNav")<0){var buttons=curr.parentNode.childNodes;for(var i=0;i<(buttons.length);i++){if(buttons[i].className=="cms"){buttons[i].className="cm";}}
curr.className="cms";var node=curr.childNodes[2];var title=node.textContent;if(!title)
{title=node.innerText;}
if(!title)
{title=node.text;}
setPageTitle(title);}}
function getNImg(u){var navImg="";if(u=="26020")navImg=im2+'reportingNav>';else if(u=="26891")navImg=im2+'docsNav>';else{switch(u){case"26887":navImg=im2+'enrollNav>';break;case"26888":navImg=im2+'crbNav>';break;case"26889":navImg=im2+'queriesNav>';break;case"26890":navImg=im2+'monitorNav>';break;case"26892":navImg=im2+'sigNav>';break;case"26018":navImg=im2+'DataViewerNav>';break;case"28317":navImg=im2+'adminNav>'
break;case"88888":navImg=im2+'homeNav>'
break;default:navImg=im2+'crbNav>';}}
return navImg;}
function CPI(D,h,u,t,sID){D.write('<div class=\"cm\"  id=\"',sID,'\" alt=\"',h,'\" title=\"',h,'\" onclick=\"',u,';top.hlNav(this);\" hideFocus=\"true\">');D.write('',getNImg(sID),'<br />');D.write('<a class=\"cm2\" hideFocus=\"true\" href=javascript:><nobr>',t,'</nobr></a></div>');}
function CPMB(D){D.write('<div id=\"navIcons\">')}
function CP_SubjectSearch(D){var findStr=msgSubjectNum;var docStr='<div id=\"SubjectSearch\" class=\"visibleNav\" ><input onkeydown=\"onInputKeyDown(this);\" onclick=\"clearField(this);\" onblur=\"reInitSearchField();\"; class=\"grayField\" size=10 value=\"'+findStr+'\"/><img title=\"Click here to search subject\" src=\"./pfts.dll?C=ResMgr_1&pfLang=en-US&pfR=172\" onclick=\"top.PatSearch(top.ControlPanel.document.getElementById(\'SubjectSearch\').childNodes[0].value);\"/></div>'
+'<div id=\"SubjectNav\" class=\"hiddenNav\" >Subject: <img id=\"NavPrevious\" title=\"Previous subject\" src=\"./pfts.dll?C=ResMgr_1&pfLang=en-US&pfR=FB\" onclick=\"patNavPrevious();\"/> <select onchange=\"patNavOnChange();\"></select> <img id=\"NavNext\" title=\"Next subject\" src=\"./pfts.dll?C=ResMgr_1&pfLang=en-US&pfR=FC\" onclick=\"patNavNext();\"/><img id=\"SearchMode\" title=\"Switch to search mode\" src=\"./pfts.dll?C=ResMgr_1&pfLang=en-US&pfR=172\"  onclick=\"changeToSearchMode();\"/></div>';return docStr;}
function MXB(D,u){D.write('<a class=mp href=',UrlFromCmd(u,'Navigator_MaximizeCP'),'title=\"Restore control panel\" target=\"_top\">+</a>')}
function CM1(D){D.write('<body background=',bURL_RM_RID,'07 bgcolor=#336699 onload=LD() tabindex=-1><form autocomplete=off onsubmit=\"return false\" name=CM>',tbs,'align=left height=30 width=100%>')}
function CML(D){D.write('<td>',tbs,'align=left height=100%><tr>')}
function CMR(D){D.write('<td>',tbs,'align=right height=100% class=\"padRight\"><tr>')}
function VBL(D,u,i,n){D.write(tbs,'align=center valign=top width=100%><tr><td><a href=\"javascript:top.C.location.href=\'',u,'\'\"',OCTB,' tabindex=-1>',im2,'1B alt=\"Go to Subject ',i,' (',n,') Time and Events Schedule\" title=\"Go to Subject ',i,' (',n,') Time and Events Schedule\"></a></td></tr></table>')}
function TD(D){D.write('</td>')}
function TD2(D){D.write('<td>')}
function TR(D){D.write('</td></tr><tr>')}
function TR2(D){D.write('<tr>')}
function TR3(D){D.write('</tr>')}
function SCT(D,c){D.write(tb1,c,'</td></tr><tr><td>')}
function SCB(D){D.write(tb1)}
function SCB2(D,c){D.write('</td></tr><tr><td>',c,'</td></tr></table>')}
function GC2(D,n){D.write((n>0?'<td width=15>&nbsp;</td>':''),'<td valign=top>')}
function GCSL(D,c){D.write(tb2,'<td valign=top>',c,'</td><td>&nbsp;</td><td valign=top>')}
function GCSR(D){D.write(tb1,tb1,'&nbsp;</td></tr><tr><td valign=top>')}
function GCSR2(D,c){D.write('</td></tr></table></td><td rowspan=2>&nbsp;</td><td rowspan=2 valign=top>',c,'</td></tr></table>')}
function GCST(D,c){D.write(tb1,c,'</td></tr><tr><td>')}
function GCSB(D,c){D.write('</td></tr><tr><td>',c,'</td></tr></table>')}
function BLH(D){D.write('<th width=1>&nbsp;</th>')}
function ISH(D,L,W,H,A,p,s,n,b,S,u,f){D.write('\n<script>function SC(s){',f+'.location.href=\'',u,'\'+s}</script>\n')
D.write('<tr',(p>0?IB[1]:''),'>')
if(s>0)BLH(D)
if(n>0&&S>0&&u.length>0)D.write('<th class=srt width=1 valign=top onclick=\"SC(\'\')\" title=\"Sort by row number\">#</th>')
else if(n>0)BLH(D)
for(var i=0,N=L.length;i<N;i++)
if(H[i]=='')D.write('<th valign=top',(W[i]>0?' width='+W[i]+'%':''),'>',L[i]=''?'&nbsp;':L[i],'</th>')
else D.write('<th class=srt valign=top',(W[i]>0?' width='+W[i]+'%':''),' onclick=\"SC(\'',H[i],'\')\" title=\"Sort by ',L[i].toLowerCase(),'\">',L[i]==''?'&nbsp;':L[i],A[i]==0?'':im2+(A[i]<0?'F_print_crf_id':'F_apply_pulldown_id')+' hspace=4>','</th>')
if(b>0)BLH(D)
D.write('</tr>')}
function ISH2(D,L,W,p,s,n,b){D.write('<tr',p>0?IB[1]:'','>')
if(s>0)BLH(D)
if(n>0)BLH(D)
for(var i=0,N=L.length;i<N;i++)D.write('<th',(W[i]>0?' width='+W[i]+'%':''),'>',L[i]==""?"&nbsp;":L[i],'</th>')
if(b>0)BLH(D)
D.write('</tr>')}
function QW(t,cr,s,rv,w,v,sr){return'<td'+(cr?(s?' class=h':''):'')+'>'+(sr?'<b>':'')+(rv?'<a href=\"javascript:S(\''+v+'\')\">':'')+(t==""?"&nbsp;":t)+(rv?'</a>':'')+(sr?'</b>':'')+'</td>'}
function QTH(D){D.write('<form autocomplete=off name=ht method=post><table cellspacing=1 cellpadding=4 border=0 width=100% align=left>')}
function QTR(D,aR,z){D.write('<tr>',z<2?'<th>&nbsp;</th>':'','<th>Server</th><th>Date</th><th>User</th><th>State</th><th>Reason</th></tr>');for(var i=0,n=aR.length;i<n;i++){r=aR[i];cr=r[6]>0&&r[6]<4;s=r[6]==2||r[6]==3;rv=r[6]==4;v=r[7],sr=r[6]==6;D.write('<tr',cr?' class=qr':(i%2?' class=dr':''),'>');if(z<2&&s)
D.write(z==1?'<td width=1><input type=radio name=qc value='+r[7]+'></td>':'<td width=1>'+im2+(r[6]==3?"73":"74")+'></td>');else if(z<2)
D.write('<td width=10>&nbsp;</td>');D.write(QW(r[0],cr,s,rv,v,sr),QW(r[1]+'&nbsp;'+r[2],cr,s,rv,v,sr),QW(r[3],cr,s,rv,v,sr),QW((r[8]?'Reissued:':'')+QS[rv||sr?0:r[4]+1],cr,s,rv,v,sr),QW(r[5],cr,s,rv,v,sr),'</tr>');}
D.write('<tr><td colspan=10>&nbsp;</td></tr>')}
function QueryHistoryTitle(D)
{D.write('<div class=\"hislist\"><table cellpadding=6 cellspacing=0 class=tbl style=\"width=100%\"><tr><td class=ttl>Query&nbsp;History:</td></tr></table></div>');}
function POB(D,t,f){D.write('<tr><td class=btn><input class=btn type=button onclick=do',f,'() value=',t,'></td></tr>')}
function POT(D,t,a){D.write('<form name=frm method=post target='+t+' action=\''+a+'\' OnSubmit=\"\" autocomplete=off>',tb0,'<tr><td colspan=2 class=hd nowrap>Select a subject and click the buttons to re-order in the list:</td></tr>','<tr><td class=hd2 colspan=2>Subjects:</td></tr>','<tr><td class=sel><select name=lb size=20 tabindex=0 multiple><option value=-1></option></select></td>','<td rowspan=2 class=btn>',tb0);POB(D,'First','Top');POB(D,'Up','Up');POB(D,'Down','Dwn');POB(D,'Last','Bot');D.write('</table></td></tr></table></form>');}
function ClearSession(){if(document.cookie.indexOf("cc_session=")>-1){top.PING.location=top.sRptSite+'cgi-bin/cognosisapi.dll?b_action=xts.run&m=portal/logoff.xts&h_CAM_action=logoff';setTimeout("ClearSession()",1000);}}
function CrnLO(){if(top.sCrnStatus=='0'){if(top.C.PFHeader&&top.C.PFHeader.RptHelp.style.display=="inline"&&top.C.PFcrn.cfgGet("reportHasChanged")){top.C.PFcrn.updateReportHasChanged(false);}
ClearSession();}}
function LO(b,lm,lc){var exitMsg="Are you sure you want to exit InForm?  Click OK to exit.";if(top.C.PFHeader&&top.C.PFHeader.RptHelp.style.display=="inline"&&top.C.PFcrn.cfgGet("reportHasChanged")){exitMsg="The changed report has not been saved.  "+exitMsg;}
if(keyAwareConfirm(exitMsg)){if(top.winComments){top.winComments.close();top.winComments=null;}
if(top.C.navigator.PFLinkWindow)top.C.navigator.PFLinkWindow.close();CrnLO();top.location.replace(UrlFromCmd(b,lm+'_'+lc));}
scDelete(vemc);}
function ReDirect(url){top.location.replace(url);}
function HM(b){oSelectedNav=top.ControlPanel.document.getElementById("selectedNav");if(oSelectedNav){oSelectedNav.setAttribute("id","");oSelectedNav.className="cm";}
top.C.location.href=UrlFromCmd(b,'Navigator_RenderHomeFrameset');}
function Help(u,m){if(u==''){keyAwareAlert(m&&m!=''?m:'The requested help information is unavailable.');}else{var oH=window.open(u,'HelpWindow','status=1,resizable=1,alwaysRaised=1,width=600,height=400');}}
function DEFM(D,lm,lc){D.write('<span style=\"position:relative;left:4px;top:-2px\"><a class=mp href=\"javascript:ResizeCP(1,1)\" title=\"Maximize control panel\">',im2,'133></a></span>','<a href=javascript:top.LO(baseURL,\'',lm,'\',\'',lc,'\') title=\"Log Out from InForm\">',im2,'AA></a>','<a href=\"javascript:;\" onclick=\"showHlp(1,1)\">',im2,'A7></a>','<a href=\"javascript:t.HM(B)\" title=\"Return to Home Page\">',im2,'A8></a>')}
function CPU(D,a,p,h,mc,n,lm,lc,tname,tcurl){displayTrialName=tname;trialName=tname.toLowerCase();var userTxt='<div class=userPicture><a href=\"'+a+'\" target=C title=\"Change password for user '+h+'\"><img class=up border=1 src='+(p==""?bURL_RM_RID+"6C":p)+' ></a><br /></div>';var userTxt2='<div class=userName ><a class=\"userName\" id=\"userName\" href=\"'+a+'\" target=C title=\"Change password for user '+h+'\">'+n+'</a></div>';var trialCenterTxt="";if(tcurl!="")
trialCenterTxt='<a id=\"TrialCenterIcon\" hidefocus=\"true\" href=javascript:top.ReDirect(\"'+tcurl+'\") title=\"Go to Trial Center\">'+im2+'trialcenter></a>';var logoutTxt2='<a id=\"crfHistory\" hidefocus=\"true\"  title=\"Show recently viewed CRFs\">'+im2+'history></a>'
+'<a id=\"crfHelpIcon\" hidefocus=\"true\"  title=\"Display product Help in a separate window\">'+im2+'help></a>'
+trialCenterTxt
+'<a hidefocus=\"true\" href=javascript:top.LO(BURL,\''+lm+'\',\''+lc+'\') title=\"Log Out from InForm\">'+im2+'exit></a>';D.write(userTxt,'<div id=\"nmTitle\"><div style=\"position:absolute;top:0;text-align:left;\"><span id=\"contextTitle\" style=\"white-space:nowrap;margin-left:5px;\"></span></div><div class=\"userNav\">',logoutTxt2,'</div><div class=\"subjectSearch\">',CP_SubjectSearch(D),'</div>','</div>',userTxt2);userName=h;}
function setHomePageTitle(){top.ControlPanel.setPageTitle("InForm Home");}
function setPageTitle(sTitle){switch(sTitle){case crbShortTitle:sTitle=crbTitle;break;case enrollShortTitle:sTitle=enrollTitle;break;case adminShortTitle:sTitle=adminTitle;break;}
if(top.ControlPanel&&top.ControlPanel.setPageTitle){top.ControlPanel.setPageTitle(sTitle);}
return sTitle;}
function addAdHocHelp(AHHdisplay,AHHelp){AdHocHelp=AHHelp;AdHocHelpDisplay=AHHdisplay;}
function removeAdHocHelp(){AdHocHelp="";AdHocHelpDisplay="";}
function GBC(b){switch(b){case 2:return' class=ms'
case 3:return' class=qy'}
return''}
function EI(D,b){D.write('<td',GBC(b),'>&nbsp;</td>')}
function EJ(D,b){D.write('<td',GBC(b),'>')}
function EJ2(D,b,s,strUrl,strQueryId){if(b==3){D.write('<td',GBC(b),'><a href=\'javascript:oL.href=\"',strUrl,strQueryId,'\"\'>',s,'</a></td>')}
else{D.write('<td',GBC(b),'>',s,'</td>')}}
function CreateLinkToQuery(D,b,s,strUrl,strQueryId){if(b==3){D.write(im2,'13C vspace=2>','<a class=qry title=\"View Query\" href=\'javascript:oL.href=\"',strUrl,strQueryId,'\"\'>(View)</a>')}
else{D.write(s)}}
function EK(D){EI(D,2);EI(D,2)}
function EL(D){EI(D,2);EI(D,2);EI(D,2)}
function IH(D,d,r,u,n){D.write('<td width=1',r>0?' rowspan='+r:'','>',u==''?'':'<a href=\"javascript:E('+u+')\">',d>0?'<S>':'',n,d>0?'</S>':'',u==''?'':'</a>','</td>')}
function IH3(D,d,r,b,u,n){D.write('<td width=1',r>0?' rowspan='+r:'',b>0?IB[b]:'','>',u==''?'':'<a href=\"javascript:EIS('+u+')\">',d>0?'<S>':'',n,d>0?'</S>':'',u==''?'':'</a>','</td>')}
function BC(D,r){D.write('<td width=1',r>0?' rowspan='+r:'','>')}
function NI(I,H,i){return im2+I[i]+(H[i]=='"id=\"'+I[i]+'\"'?'':' alt=\"'+H[i]+'\" id=\"'+I[i]+'\" title=\"'+H[i]+'\"')+'>'}
function NL(T,L,s,i){if(L.length==0||T.length==0)return''
var u=''
for(var j=0,n=L[i].length;j<n;j++)if(L[i][j]!=''){if(s==0)return'<a href=\"'+L[i][j]+'\" target=\"'+T[i][j]+'\">'
else u+=T[i][j]+'.location.href=\''+L[i][j]+'\';'}
return u==''?'':'<a href=\"javascript:'+u+'\">'}
function RPO(D,p,c,a){if(p<=0)return;if(a>0)
D.write('<option value=-1',(c==-1)?SEL:'','>All');for(var i=1;i<=p;i++)
D.write('<option value=',i,i==c?SEL:'','>',i);}
function RenderPageSizeOptions(D,p,c,r,values)
{if(p<=0)return;D.write('<option value=0',(c==-1?SEL:''),(c>0?' DISABLED ':''),'>&nbsp;-&nbsp;');for(var i=0;i<values.length;i++)
D.write('<option value=',values[i],(c>0?(values[i]==r?SEL:''):''),'>',values[i]);}
function PNC(D,I,H,T,L,s,p,c,a,rowsPerPage,showrpp)
{D.write('<td>',tbs,'height=100%><tr>','<td>',NL(T,L,s,0),NI(I,H,0),L[0]==''?'':'</a>','</td>','<td>',NL(T,L,s,1),NI(I,H,1),L[1]==''?'':'</a>','</td>',c<=0?'':'<td>&nbsp;Page&nbsp;</td>','<td><select name=selpage title=\"Select Page\" onchange=PageNav()>');RPO(D,p,c,a);D.write('</select></td><td>',c<=0?'&nbsp;Pages&nbsp;':'&nbsp;of&nbsp;'+p+'&nbsp;','</td>','<td>',NL(T,L,s,2),NI(I,H,2),L[2]==''?'':'</a>','</td>','<td>',NL(T,L,s,3),NI(I,H,3),L[3]==''?'':'</a>','</td>');if(showrpp)
{D.write('<td style=\"padding-left: 10px;\" >Rows:&nbsp;</td>','<td style=\"padding-right: 10px\"><select ',(p==-1)?('DISABLED '):(''),'name=selrowsperpage title=\"Select rows per page\" onchange=ChangeRows(this)>');RenderPageSizeOptions(D,p,c,rowsPerPage,RPPvalues);D.write('</select></td>');}
D.write('</tr></table></td>');}
var SgH=["Name","Meaning","Date","Type","Machine"]
function SLT(D,L){Bl(D);Bl(D)
D.write('<tr><td class=hd colspan=5>Signature Status</td></tr>','<tr><td><table border=0 width=100% cellpadding=2 cellspacing=1 align=left><tr>')
for(var i=0,N=SgH.length;i<N;i++)D.write('<th>',SgH[i]==""?"&nbsp;":SgH[i],'</th>')
D.write('</tr>')
for(var i=0,M=L.length;i<M;i++){D.write('<tr',(i%2?' class=dr':''),'>')
for(var j=0,N=L[i].length;j<N;j++)D.write('<td>',L[i][j]==''?'&nbsp;':L[i][j],'</td>')
D.write('</tr>')}
D.write('</table></td></tr>')}
function GTN(f,u){f.document.location.href=u}
function GTC(f,u){if(f){if(TB()){f.document.location.href=u}}else{keyAwareAlert("Undefined frame passed to GTC")}}
function RSA(f){return'&nbsp;&nbsp;'+im2+(f==-1?'F1':'F0')+' border=0>'}
function RSH(D,t,sc,c,d,f,u,s){D.write('<th class=rep title=\"Sort by ',t.toLowerCase(),'\"><a class=SL href=\"javascript:t.GTC(',f,',\'',u,s,'\')\">',t,'</a>',(sc==c?RSA(d):''),'</th>')}
function RCM(D,r,s){D.write('<a href=\"javascript:',r,'\"',OCTB2,Cb2(s),'</a>')}
function RFSH(D,aH,f,u){var i,n,h
D.write('<tr>')
for(i=0,n=aH.length;i<n;i++){h=aH[i]
if(h.length==1)D.write('<th class=rep>',h[0],'</th>')
else RSH(D,h[0],h[1],h[2],h[3],f,u,h[4])}
D.write('</tr>')}
function EnableHideClosedQueries(D)
{D.write('<td width=8% class=\"stl2\" nowrap style=\"padding-right:5px;\"><input type=\"checkbox\" id=\"HideClosedQueries\" checked=\"checked\" onclick=\"RefreshQueryList()\" />',"Hide Closed Queries",' </td>');}
function RCB(D,n,c){D.write('<input type=checkbox name=\"',n,'\"',DFC(c>0),' OnClick=t.SB()>')}
function RCN(D,f,i,n,d){D.write('<a href=# onclick=\"if(t.TB()){N',f,'(\'',i,'\')}else{return false}\">',d>0?'<s>'+n+'</s>':n,'</a>')}
function RSC(D,f,i,s,sv){D.write('<a class=crf href=# title=\"',GS2('CRF',s,sv),'\" onclick=\"if(t.TB()){N',f,'(\'',i,'\')}else{return false}\">',RTL(s,'N'+f,i,sv),'</a>')}
function UA(D,p,h){var a=top.frames["ControlPanel"].document.all,n,i='<a class=m href=# onclick=\"return N(\''+p+'\')\" title=\"'+h+'\" tabindex=-1>&nbsp;'+h+'</a>',b=[a("1"),a("2"),a("3"),a("4")]
for(n=0;n<4;n++)if(b[n].children.length&&b[n].children(0).title==h){b[n].innerHTML=b[0].innerHTML;b[0].innerHTML=i;return}
for(n=3;n>0;n--)b[n].innerHTML=b[n-1].innerHTML
b[0].innerHTML=i}
function GDF(W,dN,i){return GF(W.getElementById(dN),i)}
function GFF(W,i){return GF(W.document,i)}
function GF(W,i){return W!=null?W.getElementsByTagName('FORM')[i]:null}
function FF(W,f,d,i){var fw=eval("W."+f);if(fw!=null)return GFF(fw,0);else return GDF(W,'crf',0)}
function FW(W,f){var fw=eval("W."+f);if(fw!=null)return fw;else return W}
function GetForms(W,dN){dv=W.getElementById(dN);if(dv!=null)return dv.getElementsByTagName('FORM');else return W.getElementsByTagName('FORM');}
function FindHtmlControl(W,dID,cN){var dv=W.document.getElementById(dID);var allEle;if(dv!=null){allEle=dv.childNodes}
else{allEle=W.document.childNodes}
for(var i=0;i<allEle.length;i++){if(allEle.item(i,0).name==cN){return allEle.item(i,0)}}}
function oldFHC(W,dID,cN)
{var dv=W.document.getElementById(dID);var allEle;if(dv!=null){allEle=dv.getElementsByTagName("SELECT");}
else{allEle=W.document.getElementsByTagName("SELECT");}
for(var i=0;i<allEle.length;i++){if(allEle.item(i,0).name==cN){return allEle.item(i,0);}}}
function LVCB(D,N,a,V,C,T){var n=V.length;r='<span class=vs>Select visit'+(n>1?'s':'')+':&nbsp;';if(n>1){r+='<input type=checkbox name='+N+' value=0 onClick=VisitToggle(this)'+DFC(a)+'><i>All</i>&nbsp;';}
for(var i=0;i<n;i++){r+='<input type=checkbox name='+N+' value='+V[i]+' onClick=CheckAllVisit(this)'+DFC(n==1||C[i])+'>'+T[i]+'&nbsp;';}
return r+'</span>';}
function IM(i,r,c){return'<td nowrap'+(r!=null&&r>1?' rowspan='+r:'')+(c!=null&&c!=''?' class='+c:'')+'>'+im2+i+'></td>'}
function HTX(D,i,h){id='vbtxt'+i;D.getElementById(id).className=h>0?'sel':''}
function VisitSideBar(D,n,s,L,P){D.write('<div class=\"visitNav\">');if(s>0)
{D.write('<span class=\"visitPrev enabled\"><a onclick=\"if(t.TB()){if(top.C.document.getElementById(\'visitSelect\').selectedIndex - 1 >= 0) GTV(top.C.document.getElementById(\'visitSelect\').options[top.C.document.getElementById(\'visitSelect\').options.selectedIndex - 1].value)}\">',im2,'FB width=16 height=16 title=\"previous\"></a></span>');}
else
{D.write('<span class=\"visitPrev disabled\">',im2,'NAV_LEFT_DISABLED width=16 height=16 title=\"previous\"></span>');}
D.write('<span class=\"navTitle\">Visit');D.write(':</span>');if(s<n-1)
{D.write('<span class=\"visitNext enabled\"><a onclick=\"if(t.TB()){if(top.C.document.getElementById(\'visitSelect\').options.selectedIndex + 1 < top.C.document.getElementById(\'visitSelect\').options.length) GTV(top.C.document.getElementById(\'visitSelect\').options[top.C.document.getElementById(\'visitSelect\').options.selectedIndex + 1].value)}\">',im2,'FC width=16 height=16 title=\"next\"></a></span>');}
else
{D.write('<span class=\"visitNext disabled\">',im2,'NAV_RIGHT_DISABLED width=16 height=16 title=\"next\"></span>');}
D.write('</div><div class=\"visitSelectContainer\"><select id=\"visitSelect\" onchange=\"if(t.TB())GTV(this.options[this.selectedIndex].value)\">');for(i=0;i<n;i++)
{D.write('<option');if(i==s)
{D.write(' selected');}
D.write(' class=',i==n-1?'unsell':'unsel',' value=\"',L[i],'\">',P[i],'</option>')}
D.write('</select></div>');}
function TPR(n,m,r,sr){var a=new Array(),tpr,rem,i
for(j=0;j<n;j++)a[j]=1;return a}
function TAB(D,n,m,r,P,H,L,T,C,S,ID,s,sr,sv,userType)
{var h,i,j,k=0,l,cl,a=TPR(n,m,r,sr),rw=a.length;if(top.C&&top.C.document.getElementById("visitSideBar"))
{var prev="";var pInd=s-1;if(pInd>=0)prev=' onclick=\"return top.TB()\" href=\"'+(T[pInd]!=''?'':'javascript:')+L[pInd]+(T[pInd]!=''?' target='+T[pInd]:'','\"');var next="";var nInd=s+1;if(nInd<T.length)
{next=' onclick=\"return top.TB()\" href=\"'+(T[nInd]!=''?'':'javascript:')+L[nInd]+(T[nInd]!=''?' target='+T[nInd]:'','\"');nextRef=L[nInd];}
else
{nextRef="";}
D.write('<div class=\"CRFNav\">');if(s>0)
{D.write('<span class=\"formPrev enabled\"><a',prev,'>',im2,'FB width=16 height=16 title=\"previous\"></a></span>');}
else
{D.write('<span class=\"formPrev disabled\">',im2,'NAV_LEFT_DISABLED width=16 height=16 title=\"previous\"></span>');}
D.write('<span class=\"navTitle\">Forms');D.write(':</span>');if(s<n-1)
{D.write('<span class=\"formNext enabled\"><a',next,' onKeyPress=\"top.onEnter(this, event, ',D,')\">',im2,'FC width=16 height=16 title=\"next\"></a></span>');}
else
{D.write('<span class=\"formNext disabled\">',im2,'NAV_RIGHT_DISABLED width=16 height=16 title=\"next\"></span>');}
D.write('</div>');D.write('<div id=\"tabscroller\" class=\"tabbuttonbar\">',tb0);for(i=0;i<rw;i++)
{D.write('<tr>');for(j=0;j<1;j++){l=' href='+(T[k]!=''?'':'javascript:')+L[k]+(T[k]!=''?' target='+T[k]:'')+OCTB2;h=S.length>0?GS3(H[k],'CRF',S[k],sv,userType):H[k];if(k==s)
{D.write('<td><a class=\"tabbutton selected\" title=\"',h,'\"',l,im2,getTabStatusIcon(S[k],userType),' />','<span> &nbsp; &nbsp; ',P[k],'</span></a></td>');}
else
{D.write('<td><a class=\"tabbutton\" title=\"',h,'\"',l,im2,getTabStatusIcon(S[k],userType),' />','<span> &nbsp; &nbsp; ',P[k],'</span></a></td>');}
k++}
D.write('</tr>')}
D.write('</table></div>');}
else
{D.write('<div id=\"tabscroller\" class=\"tabbuttonbar\">',tb0);for(i=0;i<rw;i++)
{D.write('<tr>');for(j=0;j<1;j++){l=' href='+(T[k]!=''?'':'javascript:')+L[k]+(T[k]!=''?' target='+T[k]:'')+OCTB2;h=S.length>0?GS3(H[k],'CRF',S[k],sv,userType):H[k];if(k==s)
{D.write('<td><a title=\"',h,'\" id=\"',ID[k],'\" class=\"tabbutton selected\" ',l,'<span>',P[k],'</span></a></td>');}
else
{D.write('<td><a title=\"',h,'\" id=\"',ID[k],'\" class=\"tabbutton\" ',l,'<span>',P[k],'</span></a></td>');}
k++;}
D.write('</tr>');}
D.write('</table></div>');}}
function Render_Tab_Docwindow(Document,NumOfDocs,m,r,ListOfDocs,ListOfHelps,ListOfLinks,T,C,S,s,sr,sv,userType){var helpfordoc,i,j,k=0,linktodoc,cl;for(i=0;i<NumOfDocs;i++){j=0;linktodoc=' href='+(T[k]!=''?'':'javascript:')+ListOfLinks[k]+(T[k]!=''?' target='+T[k]:'')+OCTB2;helpfordoc=S.length>0?GS3(ListOfHelps[k],'CRF',S[k],sv,userType):ListOfHelps[k];if(k==s){Document.write('<a title=\"',helpfordoc,'\" class=\"tabbuttondoc selected\"',linktodoc,'<span>',ListOfDocs[k],'</span></a>');}
else{Document.write('<a title=\"',helpfordoc,'\" class=\"tabbuttondoc\"',linktodoc,'<span>',ListOfDocs[k],'</span></a>');}
k++;}}
function getTabStatusIcon(status,userType){if(status&32)
return'sbLock';else if(userType==2&&(status&AnsweredQueryBit)&&(status&2))
return'sbOpenAns';else if(status&2)
return'sbQuery';else if(userType==2&&status&AnsweredQueryBit)
return'sbAnsw';else if(status&128)
return'sbVerified';else if(status&16)
return'sbFroz';else if((status&1&&status&4))
return'sbMiss';else if(status&1)
return'sbComp';return'sbNotS';}
function PV(D,C,N,HL,S,S2,P,E,F,TR,sc,sf,bu,cmd,nv,sv)
{D.write('<div id=crb class=tblview><table border=0 cellpadding=4 cellspacing=1 width=100%>')
nv>0?PVH2(D,HL):PVH(D,C,HL,bu,sc,sf,cmd);D.write('<tbody>');for(var i=0,m=F.length;i<m;i++)
{D.write('<tr',i%2?' class=dr':'','>');PVTE(D,i,N,S,S2,P,E);PVP(D,i,S,P,F,TR,sv,1);D.write('</tr>')}
D.write('</tbody></table></div>')}
function PSA(f){return'&nbsp;'+im2+(f==-1?'F1':'F0')+'>'}
function PSU(t,sc,c,f,u,s){return'<th'+(s==null?'':' class='+s)+' nowrap title=\"Sort by '+t.toLowerCase()+'\"><a class=SL href='+u+' target=C>'+t+'</a>'+(sc==c?PSA(f):'')+'</th>'}
function PVH(D,C,HL,bu,sc,sf,cmd)
{var u=bu+cmd.toString(),i,n
D.write('<thead class=\"fixedHeader\">');D.write('<tr>',PSU('Site',sc,1,sf,u+C[0]),PSU('Subject',sc,2,sf,u+C[1]),'<th>Status</th>')
for(i=0,n=HL.length;i<n;i++)D.write('<th class=ctr>',HL[i],'</th>')
D.write('</tr>')
D.write('</thead>');}
function PSUWithToolTip(t,tooltip,sc,c,f,u,s)
{return'<th'+(s==null?'':' class='+s)+' nowrap title=\"'+tooltip+'\"><a class=SL href='+u+' target=C>'+t+'</a>'+(sc==c?PSA(f):'')+'</th>';}
function PVH2(D,HL)
{D.write('<thead class=\"fixedHeader\">');D.write('<tr><th>Site</th><th>Subject</th><th>Status</th>')
for(var i=0,n=HL.length;i<n;i++)D.write('<th class=ctr>',HL[i],'</th>')
D.write('</tr>')
D.write('</thead>');}
function PVTE(D,i,N,S,S2,P,E)
{D.write('<td>',S2[i],'</td>')
sp=S[i]+','+P[i]
for(j=0;j<2;j++){t=j==0?N[i]:ES[E[i]]
D.write('<td title=\"View subject time and events schedule\" nowrap><a href=\"javascript:PT(',sp,',0)\">',t,'</a></td>')}}
function GS(s,t,v,sv){if(!v)v[0]=''
switch(t){case 0:if(s&2&&s&4&&s&AnsweredQueryBit)return'98'
if(s&2&&s&4)return'97'
if(s&2&&s&AnsweredQueryBit)return'94'
if(s&2)return'93'
if(s&4&&!(s&0x200)&&s&AnsweredQueryBit)return'8D'
if(s&4&&!(s&0x200))return'8F'
if(s&1&&s&AnsweredQueryBit)return'9C'
if(s&1)return'9B'
return'8B'
case 1:v[0]='108';return s&16
case 2:v[0]='107';return sv>0?s&128:0
case 3:v[0]='109';return s&32}
v[0]='';return 0}
function GS2(n,s,sv){var t=n+'  Status:  '
if(s&2&&s&4&&s&AnsweredQueryBit)t+='Incomplete, Queries, Answered Queries'
else if(s&2&&s&1&&s&AnsweredQueryBit)t+='Data Complete,Queries,Answered Queries'
else if(s&2&&s&4)t+='Incomplete, Queries'
else if(s&2&&s&1)t+='Data Complete,Queries'
else if(s&4&&s&AnsweredQueryBit)t+='Incomplete,Answered Queries'
else if(s&1&&s&AnsweredQueryBit)t+='Data Complete,Answered Queries'
else if(s&4)t+='Incomplete'
else if(s&1)t+='Data Complete'
else{t+='Not Started';return t}
if(s&16&&s&32)t+=', Frozen, Locked'
else if(s&32)t+=', Locked'
else if(s&16)t+=', Frozen'
if(sv>0){if(s&128)t+=', Verified'
else if(s&256)t+=', Not Complete'
else t+=', Not Verified'}
return t}
function GS3(n,n2,s,sv,userType){var t=n+'\n  ['+n2+'  Status:  '
if(s&2&&s&4&&s&AnsweredQueryBit)t+='Incomplete, Queries, Answered Queries'
else if(s&2&&s&1&&s&AnsweredQueryBit)t+='Data Complete,Queries,Answered Queries'
else if(s&2&&s&4)t+='Incomplete, Queries'
else if(s&2&&s&1)t+='Data Complete,Queries'
else if(s&4&&s&AnsweredQueryBit)t+='Incomplete,Answered Queries'
else if(s&1&&s&AnsweredQueryBit)t+='Data Complete,Answered Queries'
else if(s&4)t+='Incomplete'
else if(s&1)t+='Data Complete'
else{t+='Not Started';return t+']'}
if(s&16&&s&32)t+=', Frozen, Locked'
else if(s&32)t+=', Locked'
else if(s&16)t+=', Frozen'
if(sv>0){if(s&128)t+=', Verified'
else if(s&256)t+=', Not Complete'
else t+=', Not Verified'}
return t+']'}
var FormIconUUIDPrefix=[['FS_C_'],['FS_C_F'],['FS_C_L'],['FS_C_FL'],['FS_C_V'],['FS_C_VF'],['FS_C_VL'],['FS_C_VFL'],['FS_CA_'],['FS_CA_F'],['FS_CA_L'],['FS_CA_FL'],['FS_CA_V'],['FS_CA_VF'],['FS_CA_VL'],['FS_CA_VFL'],['FS_CO_'],['FS_CO_F'],['FS_CO_L'],['FS_CO_FL'],['FS_CO_V'],['FS_CO_VF'],['FS_CO_VL'],['FS_CO_VFL'],['FS_COA_'],['FS_COA_F'],['FS_COA_L'],['FS_COA_FL'],['FS_COA_V'],['FS_COA_VF'],['FS_COA_VL'],['FS_COA_VFL'],['FS_M_'],['FS_M_F'],['FS_M_L'],['FS_M_FL'],['FS_M_V'],['FS_M_VF'],['FS_M_VL'],['FS_M_VFL'],['FS_MA_'],['FS_MA_F'],['FS_MA_L'],['FS_MA_FL'],['FS_MA_V'],['FS_MA_VF'],['FS_MA_VL'],['FS_MA_VFL'],['FS_MO_'],['FS_MO_F'],['FS_MO_L'],['FS_MO_FL'],['FS_MO_V'],['FS_MO_VF'],['FS_MO_VL'],['FS_MO_VFL'],['FS_MOA_'],['FS_MOA_F'],['FS_MOA_L'],['FS_MOA_FL'],['FS_MOA_V'],['FS_MOA_VF'],['FS_MOA_VL'],['FS_MOA_VFL'],['FS_NOTSTARTED']];function FormState_To_FormIconUUIDPrefix_Index(s)
{var si=s&(1|2|4|0x4000);if(si==0)
{si=64;}
else{switch(si){case 1:si=0;break;case(1|2):si=2;break;case(1|4):si=4;break;case(1|0x4000):si=1;break;case(1|2|4):si=6;break;case(1|2|0x4000):si=3;break;case(1|4|0x4000):si=5;break;case(1|2|4|0x4000):si=7;break;}
si=(si<<3)|((s&0x10)?1:0)|((s&0x20)?2:0)|((s&0x80)?4:0);}
return si;}
function FormStateIconUUID(s,sv)
{if(sv==0)s&=~0x80;var i=FormState_To_FormIconUUIDPrefix_Index(s);var uuid=FormIconUUIDPrefix[i]+(top.UseTrafficLights?"_T":"_B");return uuid;}
function TLI(s,i,sv){v=[0];return'<td class=tl2>'+im2+(GS(s,i,v,sv)?v[0]:'111')+'></td>'}
function RTL(s,f,l,sv)
{var v=[0];return tbs+'class=tl'+(l&&f?' onclick=javascript:'+f+'('+l+')':'')+'><tr><td class=tl>'+im2+FormStateIconUUID(s,sv)+'></td></tr></table>';}
function VTL(D,s,p,sv,teDisplayMode)
{var v=[0];if(teDisplayMode==1)
D.write(tbs,'class=tl onclick=CF(',p,')><tr><td class=tl>',im2,FormStateIconUUID(s,sv),'></td>','</table>');else
D.write('<div class=tl onclick=CF(',p,')>',im2,FormStateIconUUID(s,sv),'></div>');}
function PVP(D,i,S,P,F,TR,sv,teDisplayMode)
{var oF=F[i],oT=TR[i],sp=S[i]+','+P[i]+',',j,n,s
for(j=0,n=oF.length;j<n;j++)
{s=oT[j]
if(s!=-1)
{if(teDisplayMode==1)
{D.write('<td class=ctr title=\"',GS2('Visit',s,sv),'\" class=ctr nowrap>');VTL(D,s,sp+oF[j],sv,teDisplayMode);D.write('</td>')}
else
{D.write('" ');D.write('title=\"',GS2('Visit',s,sv),'\">');CreateStatusBox(D,s,sp+oF[j],sv);D.write('</td>')}}
else
D.write('<td>&nbsp;</td>')}}
function TEV(D,H,s,C1,C2,P,T,sv,VI,VS,SDVR,dvc,teDisplayMode)
{TimeEventsView(D,H,s,C1,C2,P,T,sv,VI,VS,SDVR,dvc,teDisplayMode);}
function TEH(D,H)
{D.write('<tr><th>Assessment</th><th>CRF</th>');for(var i=0,n=H.length;i<n;i++)
D.write('<th>',H[i],'</th>');D.write('</tr>');}
AR=['F1','','F0','']
function RGH(D,H,f,Cp)
{var i,a,n,h;D.write('<thead class=\"fixedHeader\">');if(Cp!='')
D.write('<caption>',Cp,'</caption>');D.write('<tr>');for(i=0,n=H.length;i<n;i++)
{h=H[i];a=AR[h[1]+1];if(h[0]=="X"&&h[5]==""){h[5]="ctr";}
if(h[2]!='')
D.write('<th',(h[5]==''?'':' class='+h[5]),(h[4]==''?'':' title=\"'+h[4]+'\"'),'><a class=SL id=\"'+h[6]+'\" href=',(f==''?h[2]:'javascript:'+f+'(\''+h[2]+'\')'),(h[3]==''?'':' target='+h[3]),'>',h[0],'</a>',(a==''?'':'&nbsp;'+im2+a+'>'),'</th>');else
D.write('<th ',(h[5]==''?'':' class='+h[5]),(h[4]==''?'':'title=\"'+h[4]+'\"'),' id=\"'+h[6]+'\">',h[0],'</th>');}
D.write('</tr></thead>');}
function RGI(aV,s,f,l,sv)
{return s.substr(0,4)=='CRF:'?RTL(parseInt(s.substr(4)),f,l,sv):im2+aV[5]+(aV[1]==''?'':' title=\"'+aV[1]+'\" alt=\"'+aV[1]+'\"')+'>';}
function Replace(s,t,u){var i=s.indexOf(t),r=""
if(i==-1)return s
r+=s.substring(0,i)+u
if(i+t.length<s.length)
r+=Replace(s.substring(i+t.length,s.length),t,u)
return r}
function ChkDE(s,l,t){return l==null||l==''?s:Replace(s,'<b>Data Entry:&nbsp;</b>','<a href='+l+t+'><b>Data Entry:</b></a>&nbsp;')}
SCRBEG='<~>'
SCREND='</~>'
SCRBEG_LEN=SCRBEG.length
SCREND_LEN=SCREND.length
function RunScript(d,s,lnk,trg){var i,j,e,n,t=top;var dcm=d;if(((i=s.indexOf(SCRBEG))<0)||((j=s.indexOf(SCREND))<0)){return d.write(s);return}
d.write(ChkDE(s.substring(0,i),lnk,trg))
e=s.substring(i+SCRBEG_LEN,j)
eval(e)
n=s.substring(i+SCRBEG_LEN+e.length+SCREND_LEN,s.length)
if(n!='')RunScript(d,n,lnk,trg)}
function RG(D,Cp,H,A,r,c,js,f,h,sv,ps){var i,t,l,j,m,aR,aC,s,x,is,cl,aV=new Array(10)
D.write('<table class=tv border=0 cellpadding=4 cellspacing=1>')
RGH(D,H,h,Cp);D.write('<tbody>');for(i=0;i<r;i++){aR=A[i]
D.write(i%2?'<tr class=dr>':'<tr>');for(j=0;j<c;j++){aC=aR[j]
if(aC.length>1){s=aC[0];for(is=1,m=0;m<10;m++)aV[m]=s&Math.pow(2,m)?aC[is++]:''
x=parseInt(aV[7]);if(x>0)
D.write('<td class=\"checkbx\"><input type=checkbox',(aV[9]==''?'':' onclick='+aV[9]),' name=',aV[8],' value=',(x==2?'X checked':'NO'),' /></td>')
else
{l=aV[2]
if(aV[5]!='')
t=RGI(aV,aV[5],f,l,sv);else
t=aV[6]==''?aV[0]:aV[6];if(t=='')t='&nbsp;';cl=aV[5]==''?(aV[4]==''?'':' class='+aV[4]):' class=ctr2';if(ps&&t.indexOf(SCRBEG)>=0)
{if(l!='')
{D.write('<td',cl,(aV[1]==''?'':' title=\"'+aV[1]+'\"'),'>');RunScript(D,t,js?'javascript:'+f+'('+l+')':l,aV[3]==''?'':' target='+aV[3]);D.write('</td>');}
else
{D.write('<td',cl,'>');RunScript(D,t);D.write('</td>')}}
else
{if(l!='')
D.write('<td',cl,'><a',(aV[1]==''?'':' title=\"'+aV[1]+'\"'),' href=',(js?'javascript:'+f+'('+l+')':l),(aV[3]==''?'':' target='+aV[3]),'>',t,'</a></td>');else
D.write('<td',cl,'>',t,'</td>')}}}
else D.write('<td>&nbsp;</td>')}
D.write('</tr>')}
D.write('</tbody>')
D.write('</table>')}
function QLTB(D){D.write('<td style=\"width:16px\">',im2,'7A onclick=CK() alt=\"Set/clear all check boxes\" title=\"Set/clear all check boxes\" style=cursor:hand vspace=4 id=\"7A\"></td>');}
function GE(D,i){return D.getElementById(i);}
function RFA(D,u,t,c,id){D.write(PCD(c),' href=javascript:GSVF(',u,') alt=\"Go to ',t,' form\" title=\"Go to ',t,' form\" id=',id,'>');}
function RFL(b,t){return(b==''?'top.':b+'.')+(t==''?'':t+'.')+'location.href';}
function RenderFormNavContextItem(D,b,t,fn,f,p,n,l,a){D.write('\n<script>var GSVF=function(fi,fx,ci){',RFL(b,t),'=\"',fn,'&FI=\"+fi+\'&FX=\'+fx+\'&CI=\'+ci}\n','var GSVA=function(){',RFL(b,t),'=\"',fn,'&pfViewAll=1\"}</script>\n');D.write('<map name=nf1>');var ff,lf;if(a>0){ff='At the first form',lf='At the last form';}else{ff=lf='All forms displayed';}
f!=''?RFA(D,f,'first',0,"first_id"):PNN(D,ff,0,"first_id");p!=''?RFA(D,p,'previous',1,"previous_id"):PNN(D,ff,1,"previous_id");D.write('</map><map name=nf2>');n!=''?RFA(D,n,'next',0,"next_id"):PNN(D,lf,0,"next_id");l!=''?RFA(D,l,'last',1,"last_id"):PNN(D,lf,1,"last_id");D.write('</map>\n');D.write('<td nowrap>',tb2,im,'F2 usemap=#nf1></td><td>&nbsp;</td>');RenderControlPanelButton(D,'Display all forms','All','GSVA()','','','',2,1,'allbutton_id','');D.write('<td>&nbsp;</td>',im,'F3 usemap=#nf2></td><td>&nbsp;</td></tr></table></td>');}
function GLCB(D,n,h,t,v,s){D.write('&nbsp;<input type=checkbox title=\"',h,'\" name=',n,' value=',v,s?' checked':'','><nobr>',t,'</nobr>');}
function GLO(D,s,a){D.write('Options:');GLCB(D,'GBT','Allow all qualified users access to saved listings report definition','Global Save',1,s&1);GLCB(D,'HLF','Include links that allow navigation to InForm in generated listings report','HTTP Links',2,s&2);GLCB(D,'CMT','Include comments associated with data in generated listings report','Comments',3,s&4);if(a>0)GLCB(D,'ASSOC','Include form associations in generated listings report','Associations',4,s&8);D.write('&nbsp;&nbsp;&nbsp;&nbsp;');}
function CreateTimeEventsRow(D,s,p,t,sv)
{var sHTML=CreateTimeEventsRow2(D,s,p,t,sv);D.write(sHTML);}
function CreateTimeEventsRow2(D,s,p,t,sv)
{var myStr="";for(var j=0,m=p.length;j<m;j++)
if(p[j]=="")
myStr+=('<td>&nbsp;</td>')
else{myStr+=('<td class=\"ctr nowrap');myStr+=('\" ');myStr+='title=\"'+GS2('CRF',t[j],sv)+'\">';myStr+=CreateStatusBoxHTML(t[j],s+',\''+p[j]+'\'',sv,'CRF');myStr+='</td>'}
return myStr;}
function CreateTimeEventsHeader(D,H)
{var myHTML=('<thead class=\"fixedHeader\"><tr><th style=\"white-space: nowrap;\">Assessment</th><th>CRF</th>');for(var i=0,n=H.length;i<n;i++)
myHTML+=('<th>'+H[i]+'</th>');myHTML+=('</tr></thead>');return myHTML;}
var rIconHTML=new Array;function GetStatusIcon(status,sv)
{return Im2(FormStateIconUUID(status,sv));}
function CreateStatusBox(D,status,codeString,sv)
{var myHTML=CreateStatusBoxHTML(status,codeString,sv,'CRF');D.write(myHTML)}
function CreateStatusBoxHTML(status,codeString,sv,view)
{var myHTML='<div class=\"tl\" title=\"'+GS2(view,status,sv)+'\" onclick=CF('+codeString+')>';myHTML+='<div class=\"tl0\">'+GetStatusIcon(status,sv)+'</div>';myHTML+='</div>';return(myHTML);}
function GetRollupStatusIcon(VisitMask,sv)
{return Im2(FormStateIconUUID(VisitMask,sv));}
function CreateRollupStatusBox(VisitMask,sv)
{var myHTML='<div class=rolltl title=\"'+GS2('Visit',VisitMask,sv)+'\">';myHTML+='<div class=tl0>'+GetRollupStatusIcon(VisitMask,sv)+'</div>';myHTML+='</div>';return(myHTML);}
function isFrozen(s){return s&16}
function isVerified(s,sv){return sv>0?s&128:0}
function isLocked(s){return s&32}
function isCompleted(s)
{return(s&1)&&!(s&4);}
function GetTimeEventsRollupArray(H,s,C1,C2,P,T,sv,VS,SDVR){var a=new Array;var rIcon="";var vmax=H.length,fmax=P.length;for(var i=0;i<vmax;i++)
{a[i]=[H[i]];var count=0,vCt=0,fCt=0,lCt=0,cCt=0,nSDVRequired=0;for(var j=0;j<fmax;j++)
{if(P[j][i]!="")
{var mystr=CreateStatusBoxHTML(T[j][i],s+',\''+P[j][i]+'\'',sv,'CRF');var vTxt="&nbsp;",fTxt="&nbsp;",lTxt="&nbsp;",cTxt="&nbsp;";if(isVerified(T[j][i],sv)){vTxt=Im2('107');vCt++}
if(isFrozen(T[j][i])){fTxt=Im2('107');;fCt++}
if(isLocked(T[j][i])){lTxt=Im2('107');lCt++}
if(isCompleted(T[j][i])){cTxt=Im2('107');cCt++}
a[i].push([P[j][i],mystr,C1[j],C2[j],cTxt,vTxt,fTxt,lTxt]);count++;if(SDVR[j][i]==1)nSDVRequired++;}}
if(nSDVRequired==0)nSDVRequired++;a[i][0]=[H[i],count,cCt/count*100,vCt/nSDVRequired*100,fCt/count*100,lCt/count*100];rIcon=CreateRollupStatusBox(VS[i],sv);rIconHTML[i]=rIcon;}
return a;}
function TimeEventsView(D,H,s,C1,C2,P,T,sv,VI,VS,SDVR,dvc,teDisplayMode){if(teDisplayMode==2)
{D.write(BuildV2HTML(D,H,s,C1,C2,P,T,sv,VI,VS,SDVR,dvc));var key=scGET(vemc);if(key)
{var ele=key.split('.');var teview=D.getElementById("TimeEventsView");var tetables=teview.getElementsByTagName("table");for(var i=1;i<ele.length-1;i++)
{var index=ele[i];if(index<tetables.length)
TETDVisit(tetables[index],tetables[index].firstChild.firstChild.lastChild.previousSibling.lastChild);}}}
else
{D.write(BuildV1HTML(D,H,s,C1,C2,P,T,sv,1));}}
function BuildV1HTML(D,H,s,C1,C2,P,T,sv,na)
{scDelete(vemc);var v1HTML='<table id=\"teformview\" border=0 cellpadding=4 cellspacing=1 width=100%%> ';v1HTML+=CreateTimeEventsHeader(D,H);v1HTML+=('<TBODY>');for(var i=0,n=P.length;i<n;i++)
{v1HTML+='<tr'+(i%2?'':' class=\"dr\"')+'><td>'+C1[i]+'</td><td>'+C2[i]+'</td>';v1HTML+=CreateTimeEventsRow2(D,s,P[i],T[i],sv);v1HTML+='</tr>';}
v1HTML+=('</TBODY>');v1HTML+='</table>';return v1HTML;}
function BuildV2HTML(D,H,s,C1,C2,P,T,sv,VI,VS,SDVR,dvc)
{var verifyHTML;verifyHTML=(dvc>0&&sv>0)?"<th class='verifiedHead'>Verified</th>":"";var myHTML="<div id='rollup' class='rollups'>"
+"<div id='collapserHead'><table id='tehdr' class='classHead'><thead class='fixedHeader'><tr><th class='leftEdgeHead'><img src='"+bURL_RM_RID+"171' class='endImg'/></th>"
+"<th class='riconHead'>Status</th>"
+"<th class='visitHead'>Visit/Form</th>"
+"<th class='formsHead'>Total Forms</th>"
+"<th class='completedHead'>Completed</th>"
+verifyHTML
+"<th class='frozenHead'>Frozen</th>"
+"<th class='lockedHead'>Locked</th>"
+"<th class='collapseCollHead' align='right'><span id='collapseAll' style='top:0;'><a title='Collapse all Visits'>"+Im2('16A')+"</a></span><span id='expandAll' style='top:0;'><a title='Expand all Visits'>"+Im2('16B')+"</a></span></th><th class='rightEdgeHead'><img src='"+bURL_RM_RID+"171' class='endImg'/></th></tr></thead></table>"
+"</div>";var a=GetTimeEventsRollupArray(H,s,C1,C2,P,T,sv,VS,SDVR);for(var i=0;i<a.length;i++)
{myHTML+='<div class=\"collapsable\"><table class=\"closed\" cellpadding=\"0\" cellspacing=\"0\"><tbody>';myHTML+='<tr class=\"headerRow\"  onclick=\"TETD(this.parentNode.parentNode, this.lastChild.previousSibling.lastChild)\"> <th class=\"leftEdge\"><img src=\"'+bURL_RM_RID+'168\" class=\"leftEdge\"/></th>';myHTML+='<th class=\"ricon\">'+rIconHTML[i]+'</th><th class=\"visit\">'+a[i][0][0]+'</th><th class=\"totalForms\">'+a[i][0][1];myHTML+='</th><th class=\"completed\">';if(a[i][0][2].toFixed(0)==100){myHTML+=Im2('107');}else{myHTML+=a[i][0][2].toFixed(0)+'%';}
if(dvc>0)
{myHTML+='</th><th class=\"verify\">';if(a[i][0][3].toFixed(0)==100){myHTML+=Im2('107');}else{myHTML+=a[i][0][3].toFixed(0)+'%';}}
myHTML+='</th><th class=\"frozen\">';if(a[i][0][4].toFixed(0)==100){myHTML+=Im2('107');}else{myHTML+=a[i][0][4].toFixed(0)+'%';}
myHTML+='</th><th class=\"locked\">';if(a[i][0][5].toFixed(0)==100){myHTML+=Im2('107');}else{myHTML+=a[i][0][5].toFixed(0)+'%';}
myHTML+='</th><th class=\"collapseColl\"> <img src=\"'+bURL_RM_RID+'167\" class=\"collapseImg\" title=\"Expand this visit\"/></th><th class=\"rightEdge\"><img src=\"'+bURL_RM_RID+'170\" class=\"rightEdge\"/></th></tr>';var nCols=a[i].length;for(var j=1;j<nCols;j++)
{var b=a[i][j];var param=s+',\''+b[0]+'\'';myHTML+='<tr class=\"contentRow\" style=\"display:none\"><td class=\"leftEnd\"><img src=\"'+bURL_RM_RID+'171\" class=\"endImg\"/></td><td class=\"icon\" onclick=CF('+param+')>'+b[1]+'</td><td class=\"longname\" onclick=CF('+param+')>'+b[2]+'</td><td class=\"shortname\">'+b[3]+'</td>';myHTML+='<td class=\"completedData\">'+b[4]+'</td>';if(dvc>0)
if(sv>0)
myHTML+='<td class=\"verifyData\">'+b[5]+'</td>';myHTML+='<td class=\"frozenData\">'+b[6]+'</td><td class=\"lockedData\">'+b[7]+'</td><td>&nbsp;</td><td class=\"rightEnd\"><img src=\"'+bURL_RM_RID+'171\" class=\"endImg\"/></td></tr>';}
myHTML+=('</tbody></table></div>');}
myHTML+=('</div>');return myHTML;}
function scTEST()
{document.cookie="hex=0XFEED";if(scGET("hex")=="0XFEED")
return true
else
return false;}
function scGET(key)
{var exp=new RegExp(escape(key)+"=([^;]+)");if(exp.test(document.cookie+";"))
{exp.exec(document.cookie+";");return unescape(RegExp.$1);}
return false;}
function scSET(n,v)
{if(scTEST())
{document.cookie=escape(n)+"="+escape(v)+";/";return true;}
return false;}
function scDelete(n){if(scGET(n))scSET(n,"0XFEED","years",-1);return true;}
function TETDVisit(tbl,tblimg)
{var rowVisible;var tblclass=tbl.className;var tblRows=tbl.rows;var img=tblimg;if(tblclass=="closed")rowVisible=false;else rowVisible=true;for(i=0;i<tblRows.length;i++)
{if(tblRows[i].className!="headerRow")
{tblRows[i].style.display=(rowVisible)?"none":"";}}
rowVisible=!rowVisible;if(rowVisible)
{img.setAttribute("src",bURL_RM_RID+'166');img.setAttribute("title","Collapse this visit");tbl.className="open";}
else
{img.setAttribute("src",bURL_RM_RID+'167');img.setAttribute("title","Expand this visit");tbl.className="closed";}}
var cpNavIconsLoaded=false;var cpNavTarget="";function NavToTrack(navTarget){if(cpNavIconsLoaded==false){this.cpNavTarget=navTarget;}else{document.getElementById("ControlPanel").TriggerClickOnIcon(navTarget);}}
var __ignoreKeyUp=false;var __ignoreKeyUpTimeout=200;function keyAwareAlert(message){__ignoreKeyUp=true;alert(message);if(__ignoreKeyUp==false)
{__ignoreKeyUp=true;setTimeout("__ignoreKeyUp = false",__ignoreKeyUpTimeout);}}
function keyAwareConfirm(message){__ignoreKeyUp=true;var returnVal=confirm(message);if(__ignoreKeyUp==false)
{__ignoreKeyUp=true;setTimeout("__ignoreKeyUp = false",__ignoreKeyUpTimeout);}
return returnVal;}
function SetStudyLocales(srcControlName,tgtControlName,oControl,nIdx,isOnLoad){if((tgtControlName!=null)&&(srcControlName!=null)){var oSrcControl=FC(srcControlName,oControl.form,nIdx);var oTargetControl=FC(tgtControlName,oControl.form,nIdx);var selectedValue;var tgtSelectedValue=oTargetControl.options[oTargetControl.selectedIndex].value;for(i=oTargetControl.length-1;i>-1;i--){oTargetControl.remove(i);}
if(oSrcControl.selectedIndex!=-1){selectedValue=oSrcControl.options[oSrcControl.selectedIndex].value;if(selectedValue){var oEmptyOption=document.createElement('OPTION');oTargetControl.options.add(oEmptyOption);oEmptyOption.innerHTML="";oEmptyOption.value="";for(j=0;j<top.mappedValues.length;j++){var oMappedValues=top.mappedValues[j].split(":");if(oMappedValues[0]==selectedValue){var oOption=document.createElement('OPTION');oTargetControl.options.add(oOption);oOption.innerHTML=oMappedValues[1];oOption.value=oMappedValues[1];}}
for(k=0;k<oTargetControl.length;k++){if(oTargetControl.options[k].value==tgtSelectedValue){oTargetControl.options[k].selected=true;break;}}}}
if(isOnLoad){oSrcControl.onchange=function()
{SetStudyLocales(srcControlName,tgtControlName,oControl,nIdx,false)};}}}