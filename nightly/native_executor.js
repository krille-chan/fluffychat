(function dartProgram(){function copyProperties(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
b[q]=a[q]}}function mixinPropertiesHard(a,b){var s=Object.keys(a)
for(var r=0;r<s.length;r++){var q=s[r]
if(!b.hasOwnProperty(q)){b[q]=a[q]}}}function mixinPropertiesEasy(a,b){Object.assign(b,a)}var z=function(){var s=function(){}
s.prototype={p:{}}
var r=new s()
if(!(Object.getPrototypeOf(r)&&Object.getPrototypeOf(r).p===s.prototype.p))return false
try{if(typeof navigator!="undefined"&&typeof navigator.userAgent=="string"&&navigator.userAgent.indexOf("Chrome/")>=0)return true
if(typeof version=="function"&&version.length==0){var q=version()
if(/^\d+\.\d+\.\d+\.\d+$/.test(q))return true}}catch(p){}return false}()
function inherit(a,b){a.prototype.constructor=a
a.prototype["$i"+a.name]=a
if(b!=null){if(z){Object.setPrototypeOf(a.prototype,b.prototype)
return}var s=Object.create(b.prototype)
copyProperties(a.prototype,s)
a.prototype=s}}function inheritMany(a,b){for(var s=0;s<b.length;s++){inherit(b[s],a)}}function mixinEasy(a,b){mixinPropertiesEasy(b.prototype,a.prototype)
a.prototype.constructor=a}function mixinHard(a,b){mixinPropertiesHard(b.prototype,a.prototype)
a.prototype.constructor=a}function lazy(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){a[b]=d()}a[c]=function(){return this[b]}
return a[b]}}function lazyFinal(a,b,c,d){var s=a
a[b]=s
a[c]=function(){if(a[b]===s){var r=d()
if(a[b]!==s){A.mN(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.j(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.mE(b)
return new s(c,this)}:function(){if(s===null)s=A.mE(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.mE(a).prototype
return s}}var x=0
function tearOffParameters(a,b,c,d,e,f,g,h,i,j){if(typeof h=="number"){h+=x}return{co:a,iS:b,iI:c,rC:d,dV:e,cs:f,fs:g,fT:h,aI:i||0,nDA:j}}function installStaticTearOff(a,b,c,d,e,f,g,h){var s=tearOffParameters(a,true,false,c,d,e,f,g,h,false)
var r=staticTearOffGetter(s)
a[b]=r}function installInstanceTearOff(a,b,c,d,e,f,g,h,i,j){c=!!c
var s=tearOffParameters(a,false,c,d,e,f,g,h,i,!!j)
var r=instanceTearOffGetter(c,s)
a[b]=r}function setOrUpdateInterceptorsByTag(a){var s=v.interceptorsByTag
if(!s){v.interceptorsByTag=a
return}copyProperties(a,s)}function setOrUpdateLeafTags(a){var s=v.leafTags
if(!s){v.leafTags=a
return}copyProperties(a,s)}function updateTypes(a){var s=v.types
var r=s.length
s.push.apply(s,a)
return r}function updateHolder(a,b){copyProperties(b,a)
return a}var hunkHelpers=function(){var s=function(a,b,c,d,e){return function(f,g,h,i){return installInstanceTearOff(f,g,a,b,c,d,[h],i,e,false)}},r=function(a,b,c,d){return function(e,f,g,h){return installStaticTearOff(e,f,a,b,c,[g],h,d)}}
return{inherit:inherit,inheritMany:inheritMany,mixin:mixinEasy,mixinHard:mixinHard,installStaticTearOff:installStaticTearOff,installInstanceTearOff:installInstanceTearOff,_instance_0u:s(0,0,null,["$0"],0),_instance_1u:s(0,1,null,["$1"],0),_instance_2u:s(0,2,null,["$2"],0),_instance_0i:s(1,0,null,["$0"],0),_instance_1i:s(1,1,null,["$1"],0),_instance_2i:s(1,2,null,["$2"],0),_static_0:r(0,null,["$0"],0),_static_1:r(1,null,["$1"],0),_static_2:r(2,null,["$2"],0),makeConstList:makeConstList,lazy:lazy,lazyFinal:lazyFinal,updateHolder:updateHolder,convertToFastObject:convertToFastObject,updateTypes:updateTypes,setOrUpdateInterceptorsByTag:setOrUpdateInterceptorsByTag,setOrUpdateLeafTags:setOrUpdateLeafTags}}()
function initializeDeferredHunk(a){x=v.types.length
a(hunkHelpers,v,w,$)}var J={
mL(a,b,c,d){return{i:a,p:b,e:c,x:d}},
ls(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.mH==null){A.un()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.h(A.nP("Return interceptor for "+A.z(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.kM
if(o==null)o=$.kM=A.lr(n)
p=q[o]}if(p!=null)return p
p=A.ut(a)
if(p!=null)return p
if(typeof a=="function")return B.du
s=Object.getPrototypeOf(a)
if(s==null)return B.cj
if(s===Object.prototype)return B.cj
if(typeof q=="function"){o=$.kM
if(o==null)o=$.kM=A.lr(n)
Object.defineProperty(q,o,{value:B.b2,enumerable:false,writable:true,configurable:true})
return B.b2}return B.b2},
nt(a,b){if(a<0||a>4294967295)throw A.h(A.ao(a,0,4294967295,"length",null))
return J.nu(new Array(a),b)},
a8(a,b){if(a<0||a>4294967295)throw A.h(A.ao(a,0,4294967295,"length",null))
return J.nu(new Array(a),b)},
hm(a,b){if(a<0)throw A.h(A.b2("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.p("t<0>"))},
cn(a,b){if(a<0)throw A.h(A.b2("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.p("t<0>"))},
nu(a,b){var s=A.j(a,b.p("t<0>"))
s.$flags=1
return s},
pP(a,b){var s=t.bP
return J.pd(s.a(a),s.a(b))},
nv(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
pQ(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.nv(r))break;++b}return b},
pR(a,b){var s,r,q
for(s=a.length;b>0;b=r){r=b-1
if(!(r<s))return A.a(a,r)
q=a.charCodeAt(r)
if(q!==32&&q!==13&&!J.nv(q))break}return b},
cQ(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.di.prototype
return J.ek.prototype}if(typeof a=="string")return J.co.prototype
if(a==null)return J.ej.prototype
if(typeof a=="boolean")return J.hn.prototype
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bG.prototype
if(typeof a=="symbol")return J.dl.prototype
if(typeof a=="bigint")return J.dk.prototype
return a}if(a instanceof A.J)return a
return J.ls(a)},
ab(a){if(typeof a=="string")return J.co.prototype
if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bG.prototype
if(typeof a=="symbol")return J.dl.prototype
if(typeof a=="bigint")return J.dk.prototype
return a}if(a instanceof A.J)return a
return J.ls(a)},
an(a){if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bG.prototype
if(typeof a=="symbol")return J.dl.prototype
if(typeof a=="bigint")return J.dk.prototype
return a}if(a instanceof A.J)return a
return J.ls(a)},
ui(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.di.prototype
return J.ek.prototype}if(a==null)return a
if(!(a instanceof A.J))return J.cH.prototype
return a},
uj(a){if(typeof a=="number")return J.dj.prototype
if(typeof a=="string")return J.co.prototype
if(a==null)return a
if(!(a instanceof A.J))return J.cH.prototype
return a},
bf(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bG.prototype
if(typeof a=="symbol")return J.dl.prototype
if(typeof a=="bigint")return J.dk.prototype
return a}if(a instanceof A.J)return a
return J.ls(a)},
bV(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.cQ(a).Y(a,b)},
d(a,b){if(typeof b==="number")if(Array.isArray(a)||A.us(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.an(a).l(a,b)},
y(a,b,c){return J.an(a).h(a,b,c)},
mW(a,b,c){return J.bf(a).h4(a,b,c)},
pa(a,b,c){return J.bf(a).h5(a,b,c)},
pb(a,b,c){return J.bf(a).h6(a,b,c)},
lJ(a,b,c){return J.bf(a).h7(a,b,c)},
pc(a){return J.bf(a).h8(a)},
mX(a,b,c){return J.bf(a).dz(a,b,c)},
Z(a,b,c){return J.bf(a).h9(a,b,c)},
aA(a){return J.bf(a).ha(a)},
B(a,b,c){return J.bf(a).cS(a,b,c)},
pd(a,b){return J.uj(a).bS(a,b)},
mY(a,b){return J.an(a).bH(a,b)},
bu(a,b,c,d){return J.an(a).ac(a,b,c,d)},
aI(a){return J.cQ(a).gL(a)},
fz(a){return J.an(a).gH(a)},
bv(a){return J.ab(a).gA(a)},
pe(a){return J.bf(a).gd_(a)},
pf(a){return J.cQ(a).gaU(a)},
lK(a){if(typeof a==="number")return a>0?1:a<0?-1:a
return J.ui(a).ger(a)},
pg(a,b,c){return J.an(a).co(a,b,c)},
mZ(a,b,c){return J.bf(a).eo(a,b,c)},
lL(a,b){return J.an(a).dG(a,b)},
lM(a,b,c){return J.an(a).bh(a,b,c)},
ph(a,b){return J.an(a).hz(a,b)},
dU(a){return J.cQ(a).D(a)},
pi(a,b){return J.an(a).hF(a,b)},
h9:function h9(){},
hn:function hn(){},
ej:function ej(){},
el:function el(){},
c0:function c0(){},
hC:function hC(){},
cH:function cH(){},
bG:function bG(){},
dk:function dk(){},
dl:function dl(){},
t:function t(a){this.$ti=a},
hl:function hl(){},
jd:function jd(a){this.$ti=a},
dV:function dV(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
dj:function dj(){},
di:function di(){},
ek:function ek(){},
co:function co(){}},A={lX:function lX(){},
pS(a){return new A.dm("Field '"+a+"' has been assigned during initialization.")},
jj(a){return new A.dm("Field '"+a+"' has not been initialized.")},
pT(a){return new A.dm("Field '"+a+"' has already been initialized.")},
bI(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
jN(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
fw(a,b,c){return a},
mI(a){var s,r
for(s=$.aP.length,r=0;r<s;++r)if(a===$.aP[r])return!0
return!1},
dB(a,b,c,d){A.dy(b,"start")
if(c!=null){A.dy(c,"end")
if(b>c)A.ax(A.ao(b,0,c,"start",null))}return new A.eV(a,b,c,d.p("eV<0>"))},
pX(a,b,c,d){if(t.gt.b(a))return new A.cg(a,b,c.p("@<0>").ak(d).p("cg<1,2>"))
return new A.bH(a,b,c.p("@<0>").ak(d).p("bH<1,2>"))},
jc(){return new A.dA("No element")},
ns(){return new A.dA("Too few elements")},
dm:function dm(a){this.a=a},
af:function af(a){this.a=a},
jM:function jM(){},
C:function C(){},
aC:function aC(){},
eV:function eV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
cq:function cq(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bH:function bH(a,b,c){this.a=a
this.b=b
this.$ti=c},
cg:function cg(a,b,c){this.a=a
this.b=b
this.$ti=c},
ep:function ep(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
b9:function b9(a,b,c){this.a=a
this.b=b
this.$ti=c},
cK:function cK(a,b,c){this.a=a
this.b=b
this.$ti=c},
f8:function f8(a,b,c){this.a=a
this.b=b
this.$ti=c},
ch:function ch(a){this.$ti=a},
dX:function dX(a){this.$ti=a},
cL:function cL(a,b){this.a=a
this.$ti=b},
f9:function f9(a,b){this.a=a
this.$ti=b},
as:function as(){},
bL:function bL(){},
dC:function dC(){},
oJ(a){var s=A.oI(a)
if(s!=null)return s
return"minified:"+a},
us(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.dX.b(a)},
z(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.dU(a)
return s},
eN(a){var s,r=$.nF
if(r==null)r=$.nF=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
qj(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
if(3>=r.length)return A.a(r,3)
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
hH(a){var s,r,q,p
if(a instanceof A.J)return A.aw(A.aQ(a),null)
s=J.cQ(a)
if(s===B.ds||s===B.dv||t.cx.b(a)){r=B.b4(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.aw(A.aQ(a),null)},
nG(a){var s,r,q
if(a==null||typeof a=="number"||A.l4(a))return J.dU(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.ar)return a.D(0)
if(a instanceof A.c7)return a.fK(!0)
s=$.p8()
for(r=0;r<1;++r){q=s[r].lS(a)
if(q!=null)return q}return"Instance of '"+A.hH(a)+"'"},
nE(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
qk(a){var s,r,q,p=A.j([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.K)(a),++r){q=a[r]
if(!A.ir(q))throw A.h(A.bS(q))
if(q<=65535)B.c.C(p,q)
else if(q<=1114111){B.c.C(p,55296+(B.a.j(q-65536,10)&1023))
B.c.C(p,56320+(q&1023))}else throw A.h(A.bS(q))}return A.nE(p)},
nH(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.ir(q))throw A.h(A.bS(q))
if(q<0)throw A.h(A.bS(q))
if(q>65535)return A.qk(a)}return A.nE(a)},
ql(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
ds(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.j(s,10)|55296)>>>0,s&1023|56320)}throw A.h(A.ao(a,0,1114111,null,null))},
dr(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
qi(a){var s=A.dr(a).getUTCFullYear()+0
return s},
qg(a){var s=A.dr(a).getUTCMonth()+1
return s},
qc(a){var s=A.dr(a).getUTCDate()+0
return s},
qd(a){var s=A.dr(a).getUTCHours()+0
return s},
qf(a){var s=A.dr(a).getUTCMinutes()+0
return s},
qh(a){var s=A.dr(a).getUTCSeconds()+0
return s},
qe(a){var s=A.dr(a).getUTCMilliseconds()+0
return s},
qb(a){var s=a.$thrownJsError
if(s==null)return null
return A.bU(s)},
nI(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.a5(a,s)
a.$thrownJsError=s
s.stack=b.D(0)}},
iy(a){throw A.h(A.bS(a))},
a(a,b){if(a==null)J.bv(a)
throw A.h(A.lh(a,b))},
lh(a,b){var s,r="index"
if(!A.ir(b))return new A.b1(!0,b,r,null)
s=A.m(J.bv(a))
if(b<0||b>=s)return A.lV(b,s,a,null,r)
return A.mi(b,r)},
u6(a,b,c){if(a<0||a>c)return A.ao(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ao(b,a,c,"end",null)
return new A.b1(!0,b,"end",null)},
bS(a){return new A.b1(!0,a,null,null)},
h(a){return A.a5(a,new Error())},
a5(a,b){var s
if(a==null)a=new A.bo()
b.dartException=a
s=A.uG
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
uG(){return J.dU(this.dartException)},
ax(a,b){throw A.a5(a,b==null?new Error():b)},
b(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.ax(A.t2(a,b,c),s)},
t2(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.j.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.eX("'"+s+"': Cannot "+o+" "+l+k+n)},
K(a){throw A.h(A.b5(a))},
bJ(a){var s,r,q,p,o,n
a=A.uB(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.j([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.jU(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
jV(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
nN(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
lY(a,b){var s=b==null,r=s?null:b.method
return new A.hr(a,r,s?null:b.receiver)},
cc(a){var s
if(a==null)return new A.jx(a)
if(a instanceof A.dY){s=a.a
return A.cb(a,s==null?A.ft(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.cb(a,a.dartException)
return A.tO(a)},
cb(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
tO(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.j(r,16)&8191)===10)switch(q){case 438:return A.cb(a,A.lY(A.z(s)+" (Error "+q+")",null))
case 445:case 5007:A.z(s)
return A.cb(a,new A.ez())}}if(a instanceof TypeError){p=$.oO()
o=$.oP()
n=$.oQ()
m=$.oR()
l=$.oU()
k=$.oV()
j=$.oT()
$.oS()
i=$.oX()
h=$.oW()
g=p.bM(s)
if(g!=null)return A.cb(a,A.lY(A.bs(s),g))
else{g=o.bM(s)
if(g!=null){g.method="call"
return A.cb(a,A.lY(A.bs(s),g))}else if(n.bM(s)!=null||m.bM(s)!=null||l.bM(s)!=null||k.bM(s)!=null||j.bM(s)!=null||m.bM(s)!=null||i.bM(s)!=null||h.bM(s)!=null){A.bs(s)
return A.cb(a,new A.ez())}}return A.cb(a,new A.i1(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.eS()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.cb(a,new A.b1(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.eS()
return a},
bU(a){var s
if(a instanceof A.dY)return a.b
if(a==null)return new A.fn(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.fn(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
iA(a){if(a==null)return J.aI(a)
if(typeof a=="object")return A.eN(a)
return J.aI(a)},
u2(a){if(typeof a=="number")return B.b.gL(a)
if(a instanceof A.il)return A.eN(a)
if(a instanceof A.c7)return a.gL(a)
return A.iA(a)},
oy(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.h(0,a[s],a[r])}return b},
ti(a,b,c,d,e,f){t.Z.a(a)
switch(A.m(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.h(A.na("Unsupported number of arguments for wrapped closure"))},
dS(a,b){var s=a.$identity
if(!!s)return s
s=A.u3(a,b)
a.$identity=s
return s},
u3(a,b){var s
switch(b){case 0:s=a.$0
break
case 1:s=a.$1
break
case 2:s=a.$2
break
case 3:s=a.$3
break
case 4:s=a.$4
break
default:s=null}if(s!=null)return s.bind(a)
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.ti)},
pq(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.hV().constructor.prototype):Object.create(new A.cS(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.n6(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.pm(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.n6(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
pm(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.h("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.pk)}throw A.h("Error in functionType of tearoff")},
pn(a,b,c,d){var s=A.n5
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
n6(a,b,c,d){if(c)return A.pp(a,b,d)
return A.pn(b.length,d,a,b)},
po(a,b,c,d){var s=A.n5,r=A.pl
switch(b?-1:a){case 0:throw A.h(new A.hU("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
pp(a,b,c){var s,r
if($.n3==null)$.n3=A.n2("interceptor")
if($.n4==null)$.n4=A.n2("receiver")
s=b.length
r=A.po(s,c,a,b)
return r},
mE(a){return A.pq(a)},
pk(a,b){return A.fr(v.typeUniverse,A.aQ(a.a),b)},
n5(a){return a.a},
pl(a){return a.b},
n2(a){var s,r,q,p=new A.cS("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.h(A.b2("Field name "+a+" not found.",null))},
lr(a){return v.getIsolateTag(a)},
wd(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
ut(a){var s,r,q,p,o,n=A.bs($.oA.$1(a)),m=$.li[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lw[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.od($.or.$2(a,n))
if(q!=null){m=$.li[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.lw[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.ly(s)
$.li[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.lw[n]=s
return s}if(p==="-"){o=A.ly(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.oE(a,s)
if(p==="*")throw A.h(A.nP(n))
if(v.leafTags[n]===true){o=A.ly(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.oE(a,s)},
oE(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.mL(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
ly(a){return J.mL(a,!1,null,!!a.$iaL)},
uv(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.ly(s)
else return J.mL(s,c,null,null)},
un(){if(!0===$.mH)return
$.mH=!0
A.uo()},
uo(){var s,r,q,p,o,n,m,l
$.li=Object.create(null)
$.lw=Object.create(null)
A.um()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.oG.$1(o)
if(n!=null){m=A.uv(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
um(){var s,r,q,p,o,n,m=B.cR()
m=A.dP(B.cS,A.dP(B.cT,A.dP(B.b5,A.dP(B.b5,A.dP(B.cU,A.dP(B.cV,A.dP(B.cW(B.b4),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.oA=new A.lt(p)
$.or=new A.lu(o)
$.oG=new A.lv(n)},
dP(a,b){return a(b)||b},
u5(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
uB(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
cP:function cP(a,b){this.a=a
this.b=b},
d4:function d4(){},
d5:function d5(a,b,c){this.a=a
this.b=b
this.$ti=c},
fe:function fe(a,b){this.a=a
this.$ti=b},
ff:function ff(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aJ:function aJ(a,b){this.a=a
this.$ti=b},
h7:function h7(){},
dh:function dh(a,b){this.a=a
this.$ti=b},
eR:function eR(){},
jU:function jU(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
ez:function ez(){},
hr:function hr(a,b,c){this.a=a
this.b=b
this.c=c},
i1:function i1(a){this.a=a},
jx:function jx(a){this.a=a},
dY:function dY(a,b){this.a=a
this.b=b},
fn:function fn(a){this.a=a
this.b=null},
ar:function ar(){},
fG:function fG(){},
fH:function fH(){},
hW:function hW(){},
hV:function hV(){},
cS:function cS(a,b){this.a=a
this.b=b},
hU:function hU(a){this.a=a},
b8:function b8(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
jn:function jn(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
cp:function cp(a,b){this.a=a
this.$ti=b},
R:function R(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
jo:function jo(a,b){this.a=a
this.$ti=b},
au:function au(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
em:function em(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
lt:function lt(a){this.a=a},
lu:function lu(a){this.a=a},
lv:function lv(a){this.a=a},
c7:function c7(){},
dK:function dK(){},
c(a){throw A.a5(A.jj(a),new Error())},
iC(a){throw A.a5(A.pT(a),new Error())},
mN(a){throw A.a5(A.pS(a),new Error())},
nU(a){var s=new A.ky(a)
return s.b=s},
ky:function ky(a){this.a=a
this.b=null},
aO(a,b,c){},
q(a){var s,r,q
if(t.iy.b(a))return a
s=J.ab(a)
r=A.E(s.gA(a),null,!1,t.z)
for(q=0;q<s.gA(a);++q)B.c.h(r,q,s.l(a,q))
return r},
q0(a){return new Float32Array(a)},
q1(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Float32Array(a,b,c)},
q2(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Int16Array(a,b,c)},
nz(a){return new Int32Array(a)},
q3(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Int32Array(a,b,c)},
nA(a){return new Int8Array(a)},
q4(a,b,c){A.aO(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
q5(a){return new Uint16Array(a)},
q6(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
q7(a){return new Uint32Array(a)},
q8(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
hw(a){return new Uint8Array(a)},
m0(a){return new Uint8Array(A.q(a))},
q9(a,b,c){A.aO(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bR(a,b,c){if(a>>>0!==a||a>=c)throw A.h(A.lh(b,a))},
bd(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.h(A.u6(a,b,c))
if(b==null)return c
return b},
cr:function cr(){},
ev:function ev(){},
im:function im(a){this.a=a},
hv:function hv(){},
ak:function ak(){},
c1:function c1(){},
aM:function aM(){},
eq:function eq(){},
er:function er(){},
es:function es(){},
et:function et(){},
eu:function eu(){},
ew:function ew(){},
ex:function ex(){},
ey:function ey(){},
cs:function cs(){},
fh:function fh(){},
fi:function fi(){},
fj:function fj(){},
fk:function fk(){},
mj(a,b){var s=b.c
return s==null?b.c=A.fp(a,"cj",[b.x]):s},
nL(a){var s=a.w
if(s===6||s===7)return A.nL(a.x)
return s===11||s===12},
qr(a){return a.as},
T(a){return A.kW(v.typeUniverse,a,!1)},
uq(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.c9(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
c9(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.c9(a1,s,a3,a4)
if(r===s)return a2
return A.o2(a1,r,!0)
case 7:s=a2.x
r=A.c9(a1,s,a3,a4)
if(r===s)return a2
return A.o1(a1,r,!0)
case 8:q=a2.y
p=A.dN(a1,q,a3,a4)
if(p===q)return a2
return A.fp(a1,a2.x,p)
case 9:o=a2.x
n=A.c9(a1,o,a3,a4)
m=a2.y
l=A.dN(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.mv(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.dN(a1,j,a3,a4)
if(i===j)return a2
return A.o3(a1,k,i)
case 11:h=a2.x
g=A.c9(a1,h,a3,a4)
f=a2.y
e=A.tL(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.o0(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.dN(a1,d,a3,a4)
o=a2.x
n=A.c9(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.mw(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.h(A.fB("Attempted to substitute unexpected RTI kind "+a0))}},
dN(a,b,c,d){var s,r,q,p,o=b.length,n=A.kZ(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.c9(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
tM(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.kZ(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.c9(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
tL(a,b,c,d){var s,r=b.a,q=A.dN(a,r,c,d),p=b.b,o=A.dN(a,p,c,d),n=b.c,m=A.tM(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.ie()
s.a=q
s.b=o
s.c=m
return s},
j(a,b){a[v.arrayRti]=b
return a},
ld(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.ul(s)
return a.$S()}return null},
up(a,b){var s
if(A.nL(b))if(a instanceof A.ar){s=A.ld(a)
if(s!=null)return s}return A.aQ(a)},
aQ(a){if(a instanceof A.J)return A.l(a)
if(Array.isArray(a))return A.am(a)
return A.mA(J.cQ(a))},
am(a){var s=a[v.arrayRti],r=t.dG
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
l(a){var s=a.$ti
return s!=null?s:A.mA(a)},
mA(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.te(a,s)},
te(a,b){var s=a instanceof A.ar?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.rL(v.typeUniverse,s.name)
b.$ccache=r
return r},
ul(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.kW(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
uk(a){return A.bT(A.l(a))},
mG(a){var s=A.ld(a)
return A.bT(s==null?A.aQ(a):s)},
mD(a){var s
if(a instanceof A.c7)return A.ua(a.$r,a.f9())
s=a instanceof A.ar?A.ld(a):null
if(s!=null)return s
if(t.aJ.b(a))return J.pf(a).a
if(Array.isArray(a))return A.am(a)
return A.aQ(a)},
bT(a){var s=a.r
return s==null?a.r=new A.il(a):s},
ua(a,b){var s,r,q=b,p=q.length
if(p===0)return t.aK
if(0>=p)return A.a(q,0)
s=A.fr(v.typeUniverse,A.mD(q[0]),"@<0>")
for(r=1;r<p;++r){if(!(r<q.length))return A.a(q,r)
s=A.o5(v.typeUniverse,s,A.mD(q[r]))}return A.fr(v.typeUniverse,s,a)},
bg(a){return A.bT(A.kW(v.typeUniverse,a,!1))},
td(a){var s=this
s.b=A.tJ(s)
return s.b(a)},
tJ(a){var s,r,q,p,o
if(a===t.K)return A.to
if(A.cR(a))return A.ts
s=a.w
if(s===6)return A.ta
if(s===1)return A.oi
if(s===7)return A.tj
r=A.tI(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.cR)){a.f="$i"+q
if(q==="r")return A.tm
if(a===t.m)return A.tl
return A.tr}}else if(s===10){p=A.u5(a.x,a.y)
o=p==null?A.oi:p
return o==null?A.ft(o):o}return A.t8},
tI(a){if(a.w===8){if(a===t.p)return A.ir
if(a===t.V||a===t.q)return A.tn
if(a===t.N)return A.tq
if(a===t.y)return A.l4}return null},
tc(a){var s=this,r=A.t7
if(A.cR(s))r=A.rU
else if(s===t.K)r=A.ft
else if(A.dT(s)){r=A.t9
if(s===t.I)r=A.rS
else if(s===t.jv)r=A.od
else if(s===t.fU)r=A.rQ
else if(s===t.jh)r=A.oc
else if(s===t.jX)r=A.rR
else if(s===t.mU)r=A.rT}else if(s===t.p)r=A.m
else if(s===t.N)r=A.bs
else if(s===t.y)r=A.ob
else if(s===t.q)r=A.mx
else if(s===t.V)r=A.ip
else if(s===t.m)r=A.br
s.a=r
return s.a(a)},
t8(a){var s=this
if(a==null)return A.dT(s)
return A.oB(v.typeUniverse,A.up(a,s),s)},
ta(a){if(a==null)return!0
return this.x.b(a)},
tr(a){var s,r=this
if(a==null)return A.dT(r)
s=r.f
if(a instanceof A.J)return!!a[s]
return!!J.cQ(a)[s]},
tm(a){var s,r=this
if(a==null)return A.dT(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.J)return!!a[s]
return!!J.cQ(a)[s]},
tl(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.J)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
oh(a){if(typeof a=="object"){if(a instanceof A.J)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
t7(a){var s=this
if(a==null){if(A.dT(s))return a}else if(s.b(a))return a
throw A.a5(A.oe(a,s),new Error())},
t9(a){var s=this
if(a==null||s.b(a))return a
throw A.a5(A.oe(a,s),new Error())},
oe(a,b){return new A.dL("TypeError: "+A.nV(a,A.aw(b,null)))},
u_(a,b,c,d){if(A.oB(v.typeUniverse,a,b))return a
throw A.a5(A.rD("The type argument '"+A.aw(a,null)+"' is not a subtype of the type variable bound '"+A.aw(b,null)+"' of type variable '"+c+"' in '"+d+"'."),new Error())},
nV(a,b){return A.iS(a)+": type '"+A.aw(A.mD(a),null)+"' is not a subtype of type '"+b+"'"},
rD(a){return new A.dL("TypeError: "+a)},
b0(a,b){return new A.dL("TypeError: "+A.nV(a,b))},
tj(a){var s=this
return s.x.b(a)||A.mj(v.typeUniverse,s).b(a)},
to(a){return a!=null},
ft(a){if(a!=null)return a
throw A.a5(A.b0(a,"Object"),new Error())},
ts(a){return!0},
rU(a){return a},
oi(a){return!1},
l4(a){return!0===a||!1===a},
ob(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a5(A.b0(a,"bool"),new Error())},
rQ(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a5(A.b0(a,"bool?"),new Error())},
ip(a){if(typeof a=="number")return a
throw A.a5(A.b0(a,"double"),new Error())},
rR(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a5(A.b0(a,"double?"),new Error())},
ir(a){return typeof a=="number"&&Math.floor(a)===a},
m(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a5(A.b0(a,"int"),new Error())},
rS(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a5(A.b0(a,"int?"),new Error())},
tn(a){return typeof a=="number"},
mx(a){if(typeof a=="number")return a
throw A.a5(A.b0(a,"num"),new Error())},
oc(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a5(A.b0(a,"num?"),new Error())},
tq(a){return typeof a=="string"},
bs(a){if(typeof a=="string")return a
throw A.a5(A.b0(a,"String"),new Error())},
od(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a5(A.b0(a,"String?"),new Error())},
br(a){if(A.oh(a))return a
throw A.a5(A.b0(a,"JSObject"),new Error())},
rT(a){if(a==null)return a
if(A.oh(a))return a
throw A.a5(A.b0(a,"JSObject?"),new Error())},
om(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.aw(a[q],b)
return s},
ty(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.om(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.aw(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
of(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.j([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)B.c.C(a4,"T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a1){m=a4.length
l=m-1-q
if(!(l>=0))return A.a(a4,l)
o=o+n+a4[l]
k=a5[q]
j=k.w
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.aw(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.aw(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.aw(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.aw(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.aw(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
aw(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.aw(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.aw(a.x,b)+">"
if(l===8){p=A.tN(a.x)
o=a.y
return o.length>0?p+("<"+A.om(o,b)+">"):p}if(l===10)return A.ty(a,b)
if(l===11)return A.of(a,b,null)
if(l===12)return A.of(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
tN(a){var s=A.oI(a)
if(s!=null)return s
return"minified:"+a},
rM(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
rL(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.kW(a,b,!1)
else if(typeof m=="number"){s=m
r=A.fq(a,5,"#")
q=A.kZ(s)
for(p=0;p<s;++p)q[p]=r
o=A.fp(a,b,q)
n[b]=o
return o}else return m},
rK(a,b){return A.o7(a.tR,b)},
rJ(a,b){return A.o7(a.eT,b)},
kW(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.o4(a,null,b,!1)
r.set(b,s)
return s},
fr(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.o4(a,b,c,!0)
q.set(c,r)
return r},
o5(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.mv(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
o4(a,b,c,d){return A.rA(A.ru(a,b,c,d))},
c8(a,b){b.a=A.tc
b.b=A.td
return b},
fq(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.bc(null,null)
s.w=b
s.as=c
r=A.c8(a,s)
a.eC.set(c,r)
return r},
o2(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.rH(a,b,r,c)
a.eC.set(r,s)
return s},
rH(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.cR(b))if(!(b===t.b||b===t.v))if(s!==6)r=s===7&&A.dT(b.x)
if(r)return b
else if(s===1)return t.b}q=new A.bc(null,null)
q.w=6
q.x=b
q.as=c
return A.c8(a,q)},
o1(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.rF(a,b,r,c)
a.eC.set(r,s)
return s},
rF(a,b,c,d){var s,r
if(d){s=b.w
if(A.cR(b)||b===t.K)return b
else if(s===1)return A.fp(a,"cj",[b])
else if(b===t.b||b===t.v)return t.gK}r=new A.bc(null,null)
r.w=7
r.x=b
r.as=c
return A.c8(a,r)},
rI(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.bc(null,null)
s.w=13
s.x=b
s.as=q
r=A.c8(a,s)
a.eC.set(q,r)
return r},
fo(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
rE(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
fp(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.fo(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.bc(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.c8(a,r)
a.eC.set(p,q)
return q},
mv(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.fo(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.bc(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.c8(a,o)
a.eC.set(q,n)
return n},
o3(a,b,c){var s,r,q="+"+(b+"("+A.fo(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.bc(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.c8(a,s)
a.eC.set(q,r)
return r},
o0(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.fo(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.fo(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.rE(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.bc(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.c8(a,p)
a.eC.set(r,o)
return o},
mw(a,b,c,d){var s,r=b.as+("<"+A.fo(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.rG(a,b,c,r,d)
a.eC.set(r,s)
return s},
rG(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.kZ(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.c9(a,b,r,0)
m=A.dN(a,c,r,0)
return A.mw(a,n,m,c!==m)}}l=new A.bc(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.c8(a,l)},
ru(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
rA(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.rw(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.nZ(a,r,l,k,!1)
else if(q===46)r=A.nZ(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.cO(a.u,a.e,k.pop()))
break
case 94:k.push(A.rI(a.u,k.pop()))
break
case 35:k.push(A.fq(a.u,5,"#"))
break
case 64:k.push(A.fq(a.u,2,"@"))
break
case 126:k.push(A.fq(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.ry(a,k)
break
case 38:A.rx(a,k)
break
case 63:p=a.u
k.push(A.o2(p,A.cO(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.o1(p,A.cO(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.rv(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.o_(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.rB(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-2)
break
case 43:n=l.indexOf("(",r)
k.push(l.substring(r,n))
k.push(-4)
k.push(a.p)
a.p=k.length
r=n+1
break
default:throw"Bad character "+q}}}m=k.pop()
return A.cO(a.u,a.e,m)},
rw(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
nZ(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.rM(s,o.x)[p]
if(n==null)A.ax('No "'+p+'" in "'+A.qr(o)+'"')
d.push(A.fr(s,o,n))}else d.push(p)
return m},
ry(a,b){var s,r=a.u,q=A.nY(a,b),p=b.pop()
if(typeof p=="string")b.push(A.fp(r,p,q))
else{s=A.cO(r,a.e,p)
switch(s.w){case 11:b.push(A.mw(r,s,q,a.n))
break
default:b.push(A.mv(r,s,q))
break}}},
rv(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.nY(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.cO(p,a.e,o)
q=new A.ie()
q.a=s
q.b=n
q.c=m
b.push(A.o0(p,r,q))
return
case-4:b.push(A.o3(p,b.pop(),s))
return
default:throw A.h(A.fB("Unexpected state under `()`: "+A.z(o)))}},
rx(a,b){var s=b.pop()
if(0===s){b.push(A.fq(a.u,1,"0&"))
return}if(1===s){b.push(A.fq(a.u,4,"1&"))
return}throw A.h(A.fB("Unexpected extended operation "+A.z(s)))},
nY(a,b){var s=b.splice(a.p)
A.o_(a.u,a.e,s)
a.p=b.pop()
return s},
cO(a,b,c){if(typeof c=="string")return A.fp(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.rz(a,b,c)}else return c},
o_(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.cO(a,b,c[s])},
rB(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.cO(a,b,c[s])},
rz(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.h(A.fB("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.h(A.fB("Bad index "+c+" for "+b.D(0)))},
oB(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.aa(a,b,null,c,null)
r.set(c,s)}return s},
aa(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.cR(d))return!0
s=b.w
if(s===4)return!0
if(A.cR(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.aa(a,c[b.x],c,d,e))return!0
q=d.w
p=t.b
if(b===p||b===t.v){if(q===7)return A.aa(a,b,c,d.x,e)
return d===p||d===t.v||q===6}if(d===t.K){if(s===7)return A.aa(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.aa(a,b.x,c,d,e))return!1
return A.aa(a,A.mj(a,b),c,d,e)}if(s===6)return A.aa(a,p,c,d,e)&&A.aa(a,b.x,c,d,e)
if(q===7){if(A.aa(a,b,c,d.x,e))return!0
return A.aa(a,b,c,A.mj(a,d),e)}if(q===6)return A.aa(a,b,c,p,e)||A.aa(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.Z)return!0
o=s===10
if(o&&d===t.lZ)return!0
if(q===12){if(b===t.dY)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.aa(a,j,c,i,e)||!A.aa(a,i,e,j,c))return!1}return A.og(a,b.x,c,d.x,e)}if(q===11){if(b===t.dY)return!0
if(p)return!1
return A.og(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.tk(a,b,c,d,e)}if(o&&q===10)return A.tp(a,b,c,d,e)
return!1},
og(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.aa(a3,a4.x,a5,a6.x,a7))return!1
s=a4.y
r=a6.y
q=s.a
p=r.a
o=q.length
n=p.length
if(o>n)return!1
m=n-o
l=s.b
k=r.b
j=l.length
i=k.length
if(o+j<n+i)return!1
for(h=0;h<o;++h){g=q[h]
if(!A.aa(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.aa(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.aa(a3,k[h],a7,g,a5))return!1}f=s.c
e=r.c
d=f.length
c=e.length
for(b=0,a=0;a<c;a+=3){a0=e[a]
for(;;){if(b>=d)return!1
a1=f[b]
b+=3
if(a0<a1)return!1
a2=f[b-2]
if(a1<a0){if(a2)return!1
continue}g=e[a+1]
if(a2&&!g)return!1
g=f[b-1]
if(!A.aa(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
tk(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.fr(a,b,r[o])
return A.oa(a,p,null,c,d.y,e)}return A.oa(a,b.y,null,c,d.y,e)},
oa(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.aa(a,b[s],d,e[s],f))return!1
return!0},
tp(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.aa(a,r[s],c,q[s],e))return!1
return!0},
dT(a){var s=a.w,r=!0
if(!(a===t.b||a===t.v))if(!A.cR(a))if(s!==6)r=s===7&&A.dT(a.x)
return r},
cR(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
o7(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
kZ(a){return a>0?new Array(a):v.typeUniverse.sEA},
bc:function bc(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
ie:function ie(){this.c=this.b=this.a=null},
il:function il(a){this.a=a},
ic:function ic(){},
dL:function dL(a){this.a=a},
ro(){var s,r,q
if(self.scheduleImmediate!=null)return A.tV()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.dS(new A.kv(s),1)).observe(r,{childList:true})
return new A.ku(s,r,q)}else if(self.setImmediate!=null)return A.tW()
return A.tX()},
rp(a){self.scheduleImmediate(A.dS(new A.kw(t.M.a(a)),0))},
rq(a){self.setImmediate(A.dS(new A.kx(t.M.a(a)),0))},
rr(a){t.M.a(a)
A.rC(0,a)},
rC(a,b){var s=new A.kS()
s.iq(a,b)
return s},
tu(a){return new A.i9(new A.ac($.a2,a.p("ac<0>")),a.p("i9<0>"))},
rX(a,b){a.$2(0,null)
b.b=!0
return b.a},
w8(a,b){A.rY(a,b)},
rW(a,b){b.ea(a)},
rV(a,b){b.eb(A.cc(a),A.bU(a))},
rY(a,b){var s,r,q=new A.l1(b),p=new A.l2(b)
if(a instanceof A.ac)a.fJ(q,p,t.z)
else{s=t.z
if(a instanceof A.ac)a.hA(q,p,s)
else{r=new A.ac($.a2,t._)
r.a=8
r.c=a
r.fJ(q,p,s)}}},
tQ(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.a2.hy(new A.lb(s),t.x,t.p,t.z)},
lO(a){var s
if(t.C.b(a)){s=a.gcE()
if(s!=null)return s}return B.ae},
tf(a,b){if($.a2===B.F)return null
return null},
tg(a,b){if($.a2!==B.F)A.tf(a,b)
if(b==null)if(t.C.b(a)){b=a.gcE()
if(b==null){A.nI(a,B.ae)
b=B.ae}}else b=B.ae
else if(t.C.b(a))A.nI(a,b)
return new A.aR(a,b)},
mp(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t._;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.qs()
b.dJ(new A.aR(new A.b1(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.fu(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.dr()
b.dc(o.a)
A.dH(b,p)
return}b.a^=2
A.is(null,null,b.b,t.M.a(new A.kE(o,b)))},
dH(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.u,r=t.F;;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.mC(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.dH(d.a,c)
q.a=l
k=l.a}p=d.a
j=p.c
q.b=n
q.c=j
if(o){i=c.c
i=(i&1)!==0||(i&15)===8}else i=!0
if(i){h=c.b.b
if(n){p=p.b===h
p=!(p||p)}else p=!1
if(p){s.a(j)
A.mC(j.a,j.b)
return}g=$.a2
if(g!==h)$.a2=h
else g=null
c=c.c
if((c&15)===8)new A.kI(q,d,n).$0()
else if(o){if((c&1)!==0)new A.kH(q,j).$0()}else if((c&2)!==0)new A.kG(d,q).$0()
if(g!=null)$.a2=g
c=q.c
if(c instanceof A.ac){p=q.a.$ti
p=p.p("cj<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.ds(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.mp(c,f,!0)
return}}f=q.a.b
e=r.a(f.c)
f.c=null
b=f.ds(e)
c=q.b
p=q.c
if(!c){f.$ti.c.a(p)
f.a=8
f.c=p}else{s.a(p)
f.a=f.a&1|16
f.c=p}d.a=f
c=f}},
tz(a,b){var s
if(t.W.b(a))return b.hy(a,t.z,t.K,t.l)
s=t.Q
if(s.b(a))return s.a(a)
throw A.h(A.lN(a,"onError",u.c))},
tw(){var s,r
for(s=$.dM;s!=null;s=$.dM){$.fv=null
r=s.b
$.dM=r
if(r==null)$.fu=null
s.a.$0()}},
tK(){$.mB=!0
try{A.tw()}finally{$.fv=null
$.mB=!1
if($.dM!=null)$.mS().$1(A.os())}},
on(a){var s=new A.ia(a),r=$.fu
if(r==null){$.dM=$.fu=s
if(!$.mB)$.mS().$1(A.os())}else $.fu=r.b=s},
tH(a){var s,r,q,p=$.dM
if(p==null){A.on(a)
$.fv=$.fu
return}s=new A.ia(a)
r=$.fv
if(r==null){s.b=p
$.dM=$.fv=s}else{q=r.b
s.b=q
$.fv=r.b=s
if(q==null)$.fu=s}},
vx(a,b){A.fw(a,"stream",t.K)
return new A.ij(b.p("ij<0>"))},
mC(a,b){A.tH(new A.l7(a,b))},
ol(a,b,c,d,e){var s,r=$.a2
if(r===c)return d.$0()
$.a2=c
s=r
try{r=d.$0()
return r}finally{$.a2=s}},
tD(a,b,c,d,e,f,g){var s,r=$.a2
if(r===c)return d.$1(e)
$.a2=c
s=r
try{r=d.$1(e)
return r}finally{$.a2=s}},
tC(a,b,c,d,e,f,g,h,i){var s,r=$.a2
if(r===c)return d.$2(e,f)
$.a2=c
s=r
try{r=d.$2(e,f)
return r}finally{$.a2=s}},
is(a,b,c,d){t.M.a(d)
if(B.F!==c){d=c.kZ(d)
d=d}A.on(d)},
kv:function kv(a){this.a=a},
ku:function ku(a,b,c){this.a=a
this.b=b
this.c=c},
kw:function kw(a){this.a=a},
kx:function kx(a){this.a=a},
kS:function kS(){},
kT:function kT(a,b){this.a=a
this.b=b},
i9:function i9(a,b){this.a=a
this.b=!1
this.$ti=b},
l1:function l1(a){this.a=a},
l2:function l2(a){this.a=a},
lb:function lb(a){this.a=a},
aR:function aR(a,b){this.a=a
this.b=b},
ib:function ib(){},
fa:function fa(a,b){this.a=a
this.$ti=b},
cM:function cM(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
ac:function ac(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
kB:function kB(a,b){this.a=a
this.b=b},
kF:function kF(a,b){this.a=a
this.b=b},
kE:function kE(a,b){this.a=a
this.b=b},
kD:function kD(a,b){this.a=a
this.b=b},
kC:function kC(a,b){this.a=a
this.b=b},
kI:function kI(a,b,c){this.a=a
this.b=b
this.c=c},
kJ:function kJ(a,b){this.a=a
this.b=b},
kK:function kK(a){this.a=a},
kH:function kH(a,b){this.a=a
this.b=b},
kG:function kG(a,b){this.a=a
this.b=b},
ia:function ia(a){this.a=a
this.b=null},
ij:function ij(a){this.$ti=a},
fs:function fs(){},
ii:function ii(){},
kQ:function kQ(a,b){this.a=a
this.b=b},
l7:function l7(a,b){this.a=a
this.b=b},
nW(a,b){var s=a[b]
return s===a?null:s},
mr(a,b,c){if(c==null)a[b]=a
else a[b]=c},
mq(){var s=Object.create(null)
A.mr(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
pU(a,b){return new A.b8(a.p("@<0>").ak(b).p("b8<1,2>"))},
lZ(a,b,c){return b.p("@<0>").ak(c).p("jm<1,2>").a(A.oy(a,new A.b8(b.p("@<0>").ak(c).p("b8<1,2>"))))},
I(a,b){return new A.b8(a.p("@<0>").ak(b).p("b8<1,2>"))},
pV(a){return new A.cN(a.p("cN<0>"))},
pW(a){return new A.cN(a.p("cN<0>"))},
mt(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
en(a,b,c){var s=A.pU(b,c)
a.bL(0,new A.jp(s,b,c))
return s},
m_(a){var s,r
if(A.mI(a))return"{...}"
s=new A.eT("")
try{r={}
B.c.C($.aP,a)
s.a+="{"
r.a=!0
a.bL(0,new A.jt(r,s))
s.a+="}"}finally{if(0>=$.aP.length)return A.a($.aP,-1)
$.aP.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
fb:function fb(){},
dI:function dI(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
fc:function fc(a,b){this.a=a
this.$ti=b},
fd:function fd(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
cN:function cN(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
ih:function ih(a){this.a=a
this.b=null},
fg:function fg(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
jp:function jp(a,b,c){this.a=a
this.b=b
this.c=c},
H:function H(){},
aj:function aj(){},
jt:function jt(a,b){this.a=a
this.b=b},
dz:function dz(){},
fm:function fm(){},
rO(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.p4()
else s=new Uint8Array(o)
for(r=0;r<o;++r){q=b+r
if(!(q<a.length))return A.a(a,q)
p=a[q]
if((p&255)!==p)p=255
s[r]=p}return s},
rN(a,b,c,d){var s=a?$.p3():$.p2()
if(s==null)return null
if(0===c&&d===b.length)return A.o6(s,b)
return A.o6(s,b.subarray(c,d))},
o6(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
rP(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
kY:function kY(){},
kX:function kX(){},
kV:function kV(){},
kU:function kU(){},
cT:function cT(){},
fM:function fM(){},
fO:function fO(){},
hs:function hs(){},
jl:function jl(){},
jk:function jk(a){this.a=a},
i2:function i2(){},
i3:function i3(a){this.a=a},
io:function io(a){this.a=a
this.b=16
this.c=0},
ur(a){var s=A.qj(a,null)
if(s!=null)return s
throw A.h(A.lS(a,null,null))},
pt(a,b){a=A.a5(a,new Error())
if(a==null)a=A.ft(a)
a.stack=b.D(0)
throw a},
E(a,b,c,d){var s,r=c?J.hm(a,d):J.nt(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
dn(a,b,c){var s,r,q=A.j([],c.p("t<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.K)(a),++r)B.c.C(q,c.a(a[r]))
if(b)return q
q.$flags=1
return q},
u(a,b){var s,r
if(Array.isArray(a))return A.j(a.slice(0),b.p("t<0>"))
s=A.j([],b.p("t<0>"))
for(r=J.fz(a);r.E();)B.c.C(s,r.gN())
return s},
nx(a,b,c){var s,r=J.hm(a,c)
for(s=0;s<a;++s)B.c.h(r,s,b.$1(s))
return r},
eU(a,b,c){var s,r,q,p,o
A.dy(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.h(A.ao(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.nH(b>0||c<o?p.slice(b,c):p)}if(t.hD.b(a))return A.qt(a,b,c)
if(r)a=J.ph(a,c)
if(b>0)a=J.lL(a,b)
s=A.u(a,t.p)
return A.nH(s)},
qt(a,b,c){var s=a.length
if(b>=s)return""
return A.ql(a,b,c==null||c>s?s:c)},
nM(a,b,c){var s=J.fz(b)
if(!s.E())return a
if(c.length===0){do a+=A.z(s.gN())
while(s.E())}else{a+=A.z(s.gN())
while(s.E())a=a+c+A.z(s.gN())}return a},
qs(){return A.bU(new Error())},
pr(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
n8(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
fN(a){if(a>=10)return""+a
return"0"+a},
iS(a){if(typeof a=="number"||A.l4(a)||a==null)return J.dU(a)
if(typeof a=="string")return JSON.stringify(a)
return A.nG(a)},
pu(a,b){A.fw(a,"error",t.K)
A.fw(b,"stackTrace",t.l)
A.pt(a,b)},
fB(a){return new A.fA(a)},
b2(a,b){return new A.b1(!1,null,b,a)},
lN(a,b,c){return new A.b1(!0,a,b,c)},
qq(a){var s=null
return new A.dx(s,s,!1,s,s,a)},
mi(a,b){return new A.dx(null,null,!0,a,b,"Value not in range")},
ao(a,b,c,d,e){return new A.dx(b,c,!0,a,d,"Invalid value")},
bn(a,b,c){if(0>a||a>c)throw A.h(A.ao(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.h(A.ao(b,a,c,"end",null))
return b}return c},
dy(a,b){if(a<0)throw A.h(A.ao(a,0,null,b,null))
return a},
lV(a,b,c,d,e){return new A.h4(b,!0,a,e,"Index out of range")},
bq(a){return new A.eX(a)},
nP(a){return new A.i0(a)},
mk(a){return new A.dA(a)},
b5(a){return new A.fK(a)},
na(a){return new A.kA(a)},
lS(a,b,c){return new A.iX(a,b,c)},
pO(a,b,c){var s,r
if(A.mI(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.j([],t.s)
B.c.C($.aP,a)
try{A.tt(a,s)}finally{if(0>=$.aP.length)return A.a($.aP,-1)
$.aP.pop()}r=A.nM(b,t.c.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
lW(a,b,c){var s,r
if(A.mI(a))return b+"..."+c
s=new A.eT(b)
B.c.C($.aP,a)
try{r=s
r.a=A.nM(r.a,a,", ")}finally{if(0>=$.aP.length)return A.a($.aP,-1)
$.aP.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
tt(a,b){var s,r,q,p,o,n,m,l=a.gH(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.E())return
s=A.z(l.gN())
B.c.C(b,s)
k+=s.length+2;++j}if(!l.E()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gN();++j
if(!l.E()){if(j<=4){B.c.C(b,A.z(p))
return}r=A.z(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gN();++j
for(;l.E();p=o,o=n){n=l.gN();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2;--j}B.c.C(b,"...")
return}}q=A.z(p)
r=A.z(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.c.C(b,m)
B.c.C(b,q)
B.c.C(b,r)},
jy(a,b,c,d){var s
if(B.E===c){s=J.aI(a)
b=J.aI(b)
return A.jN(A.bI(A.bI($.iG(),s),b))}if(B.E===d){s=J.aI(a)
b=J.aI(b)
c=J.aI(c)
return A.jN(A.bI(A.bI(A.bI($.iG(),s),b),c))}s=J.aI(a)
b=J.aI(b)
c=J.aI(c)
d=J.aI(d)
d=A.jN(A.bI(A.bI(A.bI(A.bI($.iG(),s),b),c),d))
return d},
o(a){var s,r,q=$.iG()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.K)(a),++r)q=A.bI(q,J.aI(a[r]))
return A.jN(q)},
cf:function cf(a,b,c){this.a=a
this.b=b
this.c=c},
kz:function kz(){},
W:function W(){},
fA:function fA(a){this.a=a},
bo:function bo(){},
b1:function b1(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dx:function dx(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
h4:function h4(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
eX:function eX(a){this.a=a},
i0:function i0(a){this.a=a},
dA:function dA(a){this.a=a},
fK:function fK(a){this.a=a},
hy:function hy(){},
eS:function eS(){},
kA:function kA(a){this.a=a},
iX:function iX(a,b,c){this.a=a
this.b=b
this.c=c},
e:function e(){},
al:function al(){},
J:function J(){},
ik:function ik(){},
eT:function eT(a){this.a=a},
jw:function jw(a){this.a=a},
t0(a,b,c){t.Z.a(a)
if(A.m(c)>=1)return a.$1(b)
return a.$0()},
ok(a){return a==null||A.l4(a)||typeof a=="number"||typeof a=="string"||t.jx.b(a)||t.D.b(a)||t.nn.b(a)||t.m6.b(a)||t.hM.b(a)||t.k.b(a)||t.E.b(a)||t.pk.b(a)||t.kI.b(a)||t.lo.b(a)||t.fW.b(a)},
mJ(a){if(A.ok(a))return a
return new A.lx(new A.dI(t.mp)).$1(a)},
uz(a,b){var s=new A.ac($.a2,b.p("ac<0>")),r=new A.fa(s,b.p("fa<0>"))
a.then(A.dS(new A.lz(r,b),1),A.dS(new A.lA(r),1))
return s},
oj(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
ov(a){if(A.oj(a))return a
return new A.lg(new A.dI(t.mp)).$1(a)},
lx:function lx(a){this.a=a},
lz:function lz(a,b){this.a=a
this.b=b},
lA:function lA(a){this.a=a},
lg:function lg(a){this.a=a},
fX(a){var s=new A.j0()
s.i6(a)
return s},
j0:function j0(){this.a=$
this.b=0
this.c=2147483647},
ks:function ks(){},
l_:function l_(){},
kt:function kt(){},
l0:function l0(){},
ps(a,b,c,d){var s=A.ms(),r=A.ms(),q=A.ms(),p=new Uint16Array(16),o=new Uint32Array(573),n=new Uint8Array(573)
s=new A.iP(a,c,s,r,q,p,o,n)
s.jK(b,d)
s.jd(B.aa)
return s},
n9(a,b,c,d){var s,r=b*2,q=a.length
if(!(r>=0&&r<q))return A.a(a,r)
r=a[r]
s=c*2
if(!(s>=0&&s<q))return A.a(a,s)
s=a[s]
if(r>=s)if(r===s){if(!(b>=0&&b<573))return A.a(d,b)
r=d[b]
if(!(c>=0&&c<573))return A.a(d,c)
r=r<=d[c]}else r=!1
else r=!0
return r},
ms(){return new A.kL()},
rs(a,b,c){var s,r,q,p,o,n,m,l=new Uint16Array(16)
for(s=0,r=1;r<=15;++r){s=s+c[r-1]<<1>>>0
if(!(r<16))return A.a(l,r)
l[r]=s}for(q=a.length,p=0;p<=b;++p){o=p*2
n=o+1
if(!(n<q))return A.a(a,n)
m=a[n]
if(m===0)continue
if(!(m<16))return A.a(l,m)
n=l[m]
if(!(m<16))return A.a(l,m)
l[m]=n+1
n=A.rt(n,m)
a.$flags&2&&A.b(a)
if(!(o<q))return A.a(a,o)
a[o]=n}},
rt(a,b){var s,r=0
do{s=A.aE(a,1)
r=(r|a&1)<<1>>>0
if(--b,b>0){a=s
continue}else break}while(!0)
return A.aE(r,1)},
nX(a){var s
if(a<256){if(!(a>=0))return A.a(B.aj,a)
s=B.aj[a]}else{s=256+A.aE(a,7)
if(!(s<512))return A.a(B.aj,s)
s=B.aj[s]}return s},
mu(a,b,c,d,e){return new A.kR(a,b,c,d,e)},
aE(a,b){if(a>=0)return B.a.aL(a,b)
else return B.a.aL(a,b)+B.a.R(2,(~b>>>0)+65536&65535)},
dG:function dG(a,b){this.a=a
this.b=b},
iP:function iP(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.c=null
_.e=_.d=0
_.x=_.w=_.r=_.f=$
_.y=2
_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=_.ch=_.ay=_.ax=_.at=_.as=_.Q=$
_.k1=0
_.p3=_.p2=_.p1=_.ok=_.k4=_.k3=_.k2=$
_.p4=c
_.R8=d
_.RG=e
_.rx=f
_.ry=g
_.x1=_.to=$
_.x2=h
_.bd=_.aY=_.bU=_.cn=_.bK=_.aT=_.bJ=_.y2=_.y1=_.xr=$},
b_:function b_(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
kL:function kL(){this.c=this.b=this.a=$},
kR:function kR(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
j9:function j9(a,b){var _=this
_.a=a
_.b=null
_.c=b
_.e=_.d=0},
kr:function kr(){},
fF:function fF(a,b){this.a=a
this.b=b},
ja(a,b,c,d){var s,r,q=new A.h5(b)
if(d==null)d=0
if(c==null)c=a.length-d
s=a.length
if(d+c>s)c=s-d
r=t.D.b(a)?a:new Uint8Array(A.q(a))
s=J.B(B.d.gB(r),r.byteOffset+d,c)
q.b=s
q.d=s.length
return q},
h5:function h5(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
h6:function h6(){},
nB(a,b){var s=b==null?32768:b
return new A.eA(new Uint8Array(s),a)},
eA:function eA(a,b){this.b=0
this.c=a
this.a=b},
hA:function hA(){},
n_(a,b,c){var s,r,q,p,o,n,m
if(b<1||b>9||c<1||c>9)throw A.h(new A.iI("BlurHash components must be between 1 and 9."))
s=a.aS(B.e)
r=J.cn(c,t.fg)
for(q=t.O,p=0;p<c;++p)r[p]=A.E(b,new A.bx(0,0,0),!1,q)
for(o=0;o<c;++o)for(q=o===0,n=0;n<b;++n){m=n===0&&q?1:2
if(!(o<r.length))return A.a(r,o)
B.c.h(r[o],n,A.tx(s,n,o,m))}q=A.t4(r)
if(0>=r.length)return A.a(r,0)
return new A.iH(q)},
t4(a){var s,r,q,p,o,n,m,l=a.length
if(0>=l)return A.a(a,0)
s=a[0].length
r=A.E(s*l,new A.bx(0,0,0),!1,t.O)
for(q=0,p=0;p<l;++p)for(o=0;o<s;++o,q=n){n=q+1
if(!(p<a.length))return A.a(a,p)
m=a[p]
if(!(o<m.length))return A.a(m,o)
B.c.h(r,q,m[o])}return A.t5(r,s,l)},
t5(a,b,c){var s,r,q,p,o,n,m,l,k=B.c.gho(a),j=A.dB(a,1,null,A.am(a).c).lP(0),i=A.iw(b-1+(c-1)*9,1)
if(j.length!==0){s=A.am(j)
r=Math.max(0,Math.min(82,B.b.bq(new A.b9(j,s.p("D(1)").a(A.tZ()),s.p("b9<1,D>")).lJ(0,B.cP)*166-0.5)))
q=(r+1)/166
i+=A.iw(r,1)}else{i+=A.iw(0,1)
q=1}i+=A.iw((A.mK(k.a)<<16>>>0)+(A.mK(k.b)<<8>>>0)+A.mK(k.c),4)
for(s=j.length,p=0;p<j.length;j.length===s||(0,A.K)(j),++p,i=l){o=j[p]
n=o.a/q
m=o.b/q
l=o.c/q
l=i+A.iw(B.b.bq(Math.max(0,Math.min(18,Math.pow(Math.abs(n),0.5)*J.lK(n)*9+9.5)))*19*19+B.b.bq(Math.max(0,Math.min(18,Math.pow(Math.abs(m),0.5)*J.lK(m)*9+9.5)))*19+B.b.bq(Math.max(0,Math.min(18,Math.pow(Math.abs(l),0.5)*J.lK(l)*9+9.5))),2)}return i.charCodeAt(0)==0?i:i},
tv(a){t.O.a(a)
return Math.max(Math.abs(a.a),Math.max(Math.abs(a.b),Math.abs(a.c)))},
tx(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=null,i=0,h=0,g=0
if(a.gal()>=3)for(s=a.a,s=s.gH(s),r=3.141592653589793*c,q=3.141592653589793*b;s.E();){p=s.gN()
o=p.gaZ()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gaW()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
l=d*n*Math.cos(r*o/m)
i+=l*A.lB(A.m(p.gn()))
h+=l*A.lB(A.m(p.gt()))
g+=l*A.lB(A.m(p.gu()))}else for(s=a.a,s=s.gH(s),r=3.141592653589793*c,q=3.141592653589793*b;s.E();){p=s.gN()
o=p.gaZ()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gaW()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
m=d*n*Math.cos(r*o/m)*A.lB(A.m(p.gn()))
i+=m
h+=m
g+=m}k=1/(a.gS()*a.gK())
return new A.bx(i*k,h*k,g*k)},
iH:function iH(a){this.a=a},
iI:function iI(a){this.a=a},
lB(a){var s=a/255
if(s<=0.04045)return s/12.92
return Math.pow((s+0.055)/1.055,2.4)},
mK(a){var s=B.b.G(a,0,1)
if(s<=0.0031308)return B.b.i(s*12.92*255+0.5)
return B.b.i((1.055*Math.pow(s,0.4166666666666667)-0.055)*255+0.5)},
bx:function bx(a,b,c){this.a=a
this.b=b
this.c=c},
iN:function iN(a,b){this.a=a
this.b=b},
S:function S(a){this.a=-1
this.b=a},
cU:function cU(a){this.a=a},
cV:function cV(a){this.a=a},
cW:function cW(a){this.a=a},
cX:function cX(a){this.a=a},
cY:function cY(a){this.a=a},
cZ:function cZ(a){this.a=a},
d_:function d_(a,b){this.a=a
this.b=b},
d0:function d0(a){this.a=a},
d1:function d1(a,b){this.a=a
this.b=b},
d2:function d2(a){this.a=a},
d3:function d3(a,b){this.a=a
this.b=b},
n7(a,b,c,d){var s=new A.ce(new Uint8Array(4))
s.i1(a,b,c,d)
return s},
b3:function b3(a){this.a=a},
fI:function fI(a){this.a=a},
ce:function ce(a){this.a=a},
dW:function dW(a){this.a=a},
fL:function fL(a){this.a=a},
it(a,b,c){var s
if(b===c)return a
switch(b.a){case 0:if(a===0)s=0
else{s=B.ci.l(0,c)
s.toString}return s
case 1:switch(c.a){case 0:return a===0?0:1
case 1:return a
case 2:return a*5
case 3:return a*75
case 4:return a*21845
case 5:return a*1431655765
case 6:return a*42
case 7:return a*10922
case 8:return a*715827882
case 9:case 10:case 11:return a/3}break
case 2:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.m(a),1)
case 2:return a
case 3:return a*17
case 4:return a*4369
case 5:return a*286331153
case 6:return a*8
case 7:return a*2184
case 8:return a*143165576
case 9:case 10:case 11:return a/3}break
case 3:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.m(a),6)
case 2:return B.a.j(A.m(a),4)
case 3:return a
case 4:return a*257
case 5:return a*16843009
case 6:return B.a.j(A.m(a),1)
case 7:return a*128
case 8:return a*8421504
case 9:case 10:case 11:return a/255}break
case 4:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.m(a),14)
case 2:return B.a.j(A.m(a),12)
case 3:return B.a.j(A.m(a),8)
case 4:return a
case 5:return A.m(a)<<8>>>0
case 6:return B.a.j(A.m(a),9)
case 7:return B.a.j(A.m(a),1)
case 8:return a*524296
case 9:case 10:case 11:return a/65535}break
case 5:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.m(a),30)
case 2:return B.a.j(A.m(a),28)
case 3:return B.a.j(A.m(a),24)
case 4:return B.a.j(A.m(a),16)
case 5:return a
case 6:return B.a.j(A.m(a),25)
case 7:return B.a.j(A.m(a),17)
case 8:return B.a.j(A.m(a),1)
case 9:case 10:case 11:return a/4294967295}break
case 6:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.m(a),5)
case 2:return a<=0?0:B.a.j(A.m(a),3)
case 3:return a<=0?0:A.m(a)<<1>>>0
case 4:return a<=0?0:A.m(a)*516
case 5:return a<=0?0:A.m(a)*33818640
case 6:return a
case 7:return a*258
case 8:return a*16909320
case 9:case 10:case 11:return a/127}break
case 7:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.m(a),15)
case 2:return a<=0?0:B.a.j(A.m(a),11)
case 3:return a<=0?0:B.a.j(A.m(a),7)
case 4:return a<=0?0:A.m(a)<<1>>>0
case 5:return a<=0?0:A.m(a)*131076
case 6:return B.a.j(A.m(a),8)
case 7:return a
case 8:return A.m(a)*65538
case 9:case 10:case 11:return a/32767}break
case 8:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.m(a),29)
case 2:return a<=0?0:B.a.j(A.m(a),27)
case 3:return a<=0?0:B.a.j(A.m(a),23)
case 4:return a<=0?0:B.a.j(A.m(a),16)
case 5:return a<=0?0:A.m(a)<<1>>>0
case 6:return B.a.j(A.m(a),24)
case 7:return B.a.j(A.m(a),16)
case 8:return a
case 9:case 10:case 11:return a/2147483647}break
case 9:case 10:case 11:switch(c.a){case 0:return a===0?0:1
case 1:return B.b.i(B.b.G(a,0,1)*3)
case 2:return B.b.i(B.b.G(a,0,1)*15)
case 3:return B.b.i(B.b.G(a,0,1)*255)
case 4:return B.b.i(B.b.G(a,0,1)*65535)
case 5:return B.b.i(B.b.G(a,0,1)*4294967295)
case 6:return B.b.i(a<0?B.b.G(a,-1,1)*128:B.b.G(a,-1,1)*127)
case 7:return B.b.i(a<0?B.b.G(a,-1,1)*32768:B.b.G(a,-1,1)*32767)
case 8:return B.b.i(a<0?B.b.G(a,-1,1)*2147483648:B.b.G(a,-1,1)*2147483647)
case 9:case 10:case 11:return a}break}},
at:function at(a,b){this.a=a
this.b=b},
e3:function e3(a,b){this.a=a
this.b=b},
fC:function fC(a,b){this.a=a
this.b=b},
dZ(a){var s,r=new A.by(A.I(t.N,t.P))
r.i7(a)
s=a.b
if(s!=null)r.b=new Uint8Array(A.q(s))
return r},
lP(a){var s=new A.by(A.I(t.N,t.P))
s.c9(a)
return s},
by:function by(a){this.b=null
this.a=a},
id:function id(a,b){this.a=a
this.b=b},
i(a,b,c){return new A.fP(a,b)},
fP:function fP(a,b){this.a=a
this.b=b},
aS:function aS(a){this.a=a},
j2:function j2(a){this.a=a},
ng(a){var s=new A.aK(A.I(t.p,t.r),new A.aS(A.I(t.N,t.P)))
s.hf(a)
return s},
aK:function aK(a,b){this.a=a
this.b=b},
j3:function j3(a){this.a=a},
j4:function j4(a){this.a=a},
pJ(a){var s=new Uint16Array(1)
s[0]=a
return new A.bE(s)},
nn(a,b){var s=new A.bE(new Uint16Array(b))
s.ic(a,b)
return s},
j5(a){var s=new Uint32Array(1)
s[0]=a
return new A.aT(s)},
ni(a,b){var s=new A.aT(new Uint32Array(b))
s.i9(a,b)
return s},
nj(a,b){var s,r=J.cn(b,t.i)
for(s=0;s<b;++s)r[s]=new A.aX(a.k(),a.k())
return new A.bi(r)},
nm(a,b){var s=new A.bD(new Int16Array(b))
s.ib(a,b)
return s},
nk(a,b){var s=new A.bC(new Int32Array(b))
s.ia(a,b)
return s},
nl(a,b){var s,r,q,p,o=J.cn(b,t.i)
for(s=0;s<b;++s){r=a.k()
q=$.P()
q.$flags&2&&A.b(q)
q[0]=r
r=$.a7()
if(0>=r.length)return A.a(r,0)
p=r[0]
q[0]=a.k()
o[s]=new A.aX(p,r[0])}return new A.bk(o)},
no(a,b){var s=new A.bY(new Float32Array(b))
s.ie(a,b)
return s},
nh(a,b){var s=new A.bX(new Float64Array(b))
s.i8(a,b)
return s},
ag:function ag(a,b){this.a=a
this.b=b},
a3:function a3(){},
b7:function b7(a){this.a=a},
cl:function cl(a){this.a=a},
bE:function bE(a){this.a=a},
aT:function aT(a){this.a=a},
bi:function bi(a){this.a=a},
bj:function bj(a){this.a=a},
bD:function bD(a){this.a=a},
bC:function bC(a){this.a=a},
bk:function bk(a){this.a=a},
bY:function bY(a){this.a=a},
bX:function bX(a){this.a=a},
bZ:function bZ(a){this.a=a},
cm:function cm(a){this.a=a},
ox(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(a4===B.ba)return a5.el(a3)
if(B.ch.a9(a4))return A.u7(a3,a5,a4,a7)
s=B.l4.l(0,a4)
s.toString
r=a3.gK()
q=a3.gS()
p=a5.gO()
o=A.Q(null,null,B.e,0,B.j,r,null,0,1,p,B.e,q,!1)
n=new A.lj(A.bF(a3,!1,!1),a5,o,p,s,q,r)
if(a6===B.da){m=q+r-1
for(l=q-1,k=0;k<m;++k){j=k<r?0:k-r+1
i=k<q?k:l
if((k&1)===0)for(h=j;h<=i;++h)n.$3(h,k-h,1)
else for(h=i;h>=j;--h)n.$3(h,k-h,1)}return o}if(a6===B.db){g=Math.max(q,r)
for(f=1;f<g;)f=f<<1>>>0
e=A.j([0,0],t.t)
d=f*f
for(k=0;k<d;++k){A.tb(f,k,e)
s=e[0]
if(s<q&&e[1]<r)n.$3(s,e[1],1)}return o}c=a6===B.d9
b=c?-1:1
for(a=q-1,a0=0;a0<r;++a0){if(c)b*=-1
s=b===1
a1=s?0:a
a2=s?q:0
for(h=a1;h!==a2;h+=b)n.$3(h,a0,b)}return o},
u7(a,b,c,d){var s,r,q,p,o,n,m,l,k=null,j=B.ch.l(0,c),i=j.length,h=a.gK(),g=a.gS(),f=A.Q(k,k,B.e,0,B.j,h,k,0,1,b.gO(),B.e,g,!1)
for(s=0;s<h;++s){r=j[B.a.a8(s,i)]
for(q=r.length,p=0;p<g;++p){o=a.a
n=o==null?k:o.P(p,s,k)
if(n==null)n=new A.F()
o=B.a.a8(p,i)
if(!(o<q))return A.a(r,o)
m=(r[o]-0.5)*255*d
l=b.ek(B.b.av(B.b.G(n.l(0,0)+m,0,255)),B.b.av(B.b.G(n.l(0,1)+m,0,255)),B.b.av(B.b.G(n.l(0,2)+m,0,255)))
o=f.a
if(o!=null)o.aK(p,s,l)}}return f},
tb(a,b,c){var s,r,q,p,o,n
B.c.h(c,0,0)
B.c.h(c,1,0)
for(s=b,r=1;r<a;r=r<<1>>>0){q=s>>>1&1
p=(s^q)&1
if(p===0){if(q===1){o=r-1
B.c.h(c,0,o-c[0])
B.c.h(c,1,o-c[1])}n=c[0]
c[0]=c[1]
c[1]=n}B.c.h(c,0,c[0]+r*q)
B.c.h(c,1,c[1]+r*p)
s=s>>>2}},
aB:function aB(a,b){this.a=a
this.b=b},
d6:function d6(a,b){this.a=a
this.b=b},
lj:function lj(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
n0(a){var s,r,q=new A.iL()
if(!A.n1(a))A.ax(A.n("Not a bitmap file."))
a.d+=2
s=a.k()
r=$.P()
r.$flags&2&&A.b(r)
r[0]=s
s=$.a7()
if(0>=s.length)return A.a(s,0)
a.d+=4
r[0]=a.k()
q.b=s[0]
return q},
n1(a){if(a.c-a.d<2)return!1
return A.p(a,null,0).q()===19778},
pj(a,b){var s,r,q,p,o=b==null?A.n0(a):b,n=a.d,m=a.k(),l=a.k(),k=$.P()
k.$flags&2&&A.b(k)
k[0]=l
l=$.a7()
if(0>=l.length)return A.a(l,0)
s=l[0]
k[0]=a.k()
l=l[0]
r=a.q()
q=a.q()
p=a.k()
if(p>=14)A.ax(A.n("Unsupported BMP compression type: "+p))
if(!(p<14))return A.a(B.aw,p)
p=B.aw[p]
a.k()
k[0]=a.k()
k[0]=a.k()
k=a.k()
a.k()
n=new A.bw(o,s,l,m,r,q,p,k,n)
n.eB(a,b)
return n},
ae:function ae(a,b){this.a=a
this.b=b},
iL:function iL(){this.b=$},
bw:function bw(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=h
_.ay=_.ax=_.at=_.as=$
_.ch=null
_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=$
_.fy=i},
fD:function fD(a){this.a=$
this.b=null
this.c=a},
iJ:function iJ(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
iQ:function iQ(a){this.a=$
this.b=null
this.c=a},
iK:function iK(){},
M:function M(){},
iO:function iO(){},
iR:function iR(){},
fQ:function fQ(){},
eg:function eg(a,b,c,d){var _=this
_.r=a
_.w=b
_.x=c
_.b=_.a=0
_.c=d},
d7:function d7(a,b){this.a=a
this.b=b},
ci:function ci(a,b){this.a=a
this.b=b},
fR:function fR(){var _=this
_.w=_.r=_.f=_.d=_.c=_.b=_.a=$},
nb(a,b,c,d){var s,r
switch(a.a){case 1:return new A.he(c,b)
case 2:return new A.eh(c,d==null?1:d,b)
case 3:return new A.eh(c,d==null?16:d,b)
case 4:s=d==null?32:d
r=new A.hc(c,s,b)
r.ii(b,c,s)
return r
case 5:return new A.hd(c,d==null?16:d,b)
case 6:return new A.eg(c,d==null?32:d,!1,b)
case 7:return new A.eg(c,d==null?32:d,!0,b)
default:throw A.h(A.n("Invalid compression type: "+a.D(0)))}},
b6:function b6(a,b){this.a=a
this.b=b},
bz:function bz(){},
ha:function ha(){},
py(a,b,c,d){var s,r,q,p,o,n,m,l
if(b===0){if(d!==0)throw A.h(A.n("Incomplete huffman data"))
return}s=a.d
r=a.k()
q=a.k()
a.d+=4
p=a.k()
o=!0
if(r<65537)o=q>=65537
if(o)throw A.h(A.n("Invalid huffman table size"))
a.d+=4
n=A.E(65537,0,!1,t.p)
m=J.a8(16384,t.ho)
for(l=0;l<16384;++l)m[l]=new A.fS()
A.pz(a,b-20,r,q,n)
if(p>8*(b-(a.d-s)))throw A.h(A.n("Error in header for Huffman-encoded data (invalid number of bits)."))
A.pv(n,r,q,m)
A.px(n,m,a,p,q,d,c)},
px(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k,j="Error in Huffman-encoded data (invalid code).",i=A.j([0,0],t.t),h=c.d+B.a.W(d+7,8)
for(s=b.length,r=0;c.d<h;){A.lQ(i,c)
while(q=i[1],q>=14){p=B.a.aL(i[0],q-14)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.h(i,1,q-p)
r=A.lR(o.b,e,i,c,g,r,f)}else{if(o.c==null)throw A.h(A.n(j))
for(n=0;n<o.b;++n){q=o.c
if(!(n<q.length))return A.a(q,n)
q=q[n]
if(!(q<65537))return A.a(a,q)
m=a[q]&63
for(;;){q=i[1]
if(!(q<m&&c.d<h))break
A.lQ(i,c)}if(q>=m){p=o.c
if(!(n<p.length))return A.a(p,n)
p=p[n]
if(!(p<65537))return A.a(a,p)
q-=m
if(a[p]>>>6===(B.a.aL(i[0],q)&B.a.R(1,m)-1)>>>0){B.c.h(i,1,q)
q=o.c
if(!(n<q.length))return A.a(q,n)
l=A.lR(q[n],e,i,c,g,r,f)
r=l
break}}}if(n===o.b)throw A.h(A.n(j))}}}k=8-d&7
B.c.h(i,0,B.a.j(i[0],k))
B.c.h(i,1,i[1]-k)
while(q=i[1],q>0){p=B.a.V(i[0],14-q)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.h(i,1,q-p)
r=A.lR(o.b,e,i,c,g,r,f)}else throw A.h(A.n(j))}if(r!==f)throw A.h(A.n("Error in Huffman-encoded data (decoded data are shorter than expected)."))},
lR(a,b,c,d,e,f,g){var s,r,q,p,o,n,m="Error in Huffman-encoded data (decoded data are longer than expected)."
if(a===b){if(c[1]<8)A.lQ(c,d)
B.c.h(c,1,c[1]-8)
s=B.a.aL(c[0],c[1])&255
if(f+s>g)throw A.h(A.n(m))
r=f-1
q=e.length
if(!(r>=0&&r<q))return A.a(e,r)
p=e[r]
for(r=e.$flags|0;o=s-1,s>0;s=o,f=n){n=f+1
r&2&&A.b(e)
if(!(f<q))return A.a(e,f)
e[f]=p}}else{if(f<g){e.toString
n=f+1
e.$flags&2&&A.b(e)
if(!(f<e.length))return A.a(e,f)
e[f]=a}else throw A.h(A.n(m))
f=n}return f},
pv(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i="Error in Huffman-encoded data (invalid code table entry)."
for(s=d.length,r=t.t,q=t.p;b<=c;++b){if(!(b<65537))return A.a(a,b)
p=a[b]
o=p>>>6
n=p&63
if(B.a.a0(o,n)!==0)throw A.h(A.n(i))
if(n>14){p=B.a.a2(o,n-14)
if(!(p<s))return A.a(d,p)
m=d[p]
if(m.a!==0)throw A.h(A.n(i))
p=++m.b
l=m.c
if(l!=null){m.shv(A.E(p,0,!1,q))
for(k=0;k<m.b-1;++k){p=m.c
p.toString
if(!(k<l.length))return A.a(l,k)
B.c.h(p,k,l[k])}}else m.shv(A.j([0],r))
p=m.c
p.toString
B.c.h(p,m.b-1,b)}else if(n!==0){p=14-n
j=B.a.V(o,p)
if(!(j<s))return A.a(d,j)
for(k=B.a.V(1,p);k>0;--k,++j){if(!(j<s))return A.a(d,j)
m=d[j]
if(m.a!==0||m.c!=null)throw A.h(A.n(i))
m.a=n
m.b=b}}}},
pz(a,b,c,d,e){var s,r,q,p,o,n="Error in Huffman-encoded data (unexpected end of code table data).",m="Error in Huffman-encoded data (code table is longer than expected).",l=a.d,k=A.j([0,0],t.t)
for(s=d+1;c<=d;++c){if(a.d-l>b)throw A.h(A.n(n))
r=A.nc(6,k,a)
B.c.h(e,c,r)
if(r===63){if(a.d-l>b)throw A.h(A.n(n))
q=A.nc(8,k,a)+6
if(c+q>s)throw A.h(A.n(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.h(e,c,0)}--c}else if(r>=59){q=r-59+2
if(c+q>s)throw A.h(A.n(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.h(e,c,0)}--c}}A.pw(e)},
pw(a){var s,r,q,p,o,n=A.E(59,0,!1,t.p)
for(s=0;s<65537;++s){r=a[s]
if(!(r<59))return A.a(n,r)
B.c.h(n,r,n[r]+1)}for(q=0,s=58;s>0;--s,q=p){p=q+n[s]>>>1
B.c.h(n,s,q)}for(s=0;s<65537;++s){o=a[s]
if(o>0){if(!(o<59))return A.a(n,o)
r=n[o]
B.c.h(n,o,r+1)
B.c.h(a,s,(o|r<<6)>>>0)}}},
lQ(a,b){B.c.h(a,0,(a[0]<<8|b.I())>>>0)
B.c.h(a,1,a[1]+8>>>0)},
nc(a,b,c){var s
while(s=b[1],s<a){B.c.h(b,0,(b[0]<<8|J.d(c.a,c.d++))>>>0)
B.c.h(b,1,b[1]+8>>>0)}B.c.h(b,1,s-a)
return(B.a.aL(b[0],b[1])&B.a.R(1,a)-1)>>>0},
fS:function fS(){this.b=this.a=0
this.c=null},
pA(a){var s=A.w(a,!1,null,0)
if(s.k()!==20000630)return!1
if(s.I()!==2)return!1
if((s.bu()&4294967289)>>>0!==0)return!1
return!0},
fT:function fT(a){var _=this
_.b=_.a=0
_.c=a
_.d=null
_.e=$},
nq(a,b,c){var s=new A.hb(a,A.j([],t.a_),A.I(t.N,t.iW),B.bc,b)
s.i4(a,b,c)
return s},
e_:function e_(){},
iU:function iU(a,b){this.a=a
this.b=b},
hb:function hb(a,b,c,d,e){var _=this
_.a=a
_.b=null
_.c=b
_.d=0
_.e=c
_.r=$
_.x=_.w=0
_.at=$
_.ax=d
_.ay=null
_.ch=$
_.CW=null
_.cx=0
_.cy=null
_.db=e
_.k1=_.id=_.go=_.fy=_.fx=_.fr=_.dy=_.dx=null
_.k2=$
_.k3=null},
hc:function hc(a,b,c){var _=this
_.r=null
_.w=a
_.x=b
_.y=$
_.z=null
_.b=_.a=0
_.c=c},
fl:function fl(){var _=this
_.f=_.e=_.d=_.c=_.b=_.a=$},
hd:function hd(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
he:function he(a,b){var _=this
_.r=null
_.w=a
_.b=_.a=0
_.c=b},
eh:function eh(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
iT:function iT(){this.a=null},
ne(a){var s=new Uint8Array(a*3)
return new A.e4(A.pH(a),a,null,new A.aN(s,a,3))},
pG(a){return new A.e4(a.a,a.b,a.c,A.nC(a.d))},
pH(a){var s
for(s=1;s<=8;++s)if(B.a.R(1,s)>=a)return s
return 0},
e4:function e4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
e5:function e5(){},
hf:function hf(){var _=this
_.e=_.d=_.c=_.b=_.a=$
_.f=null
_.r=80
_.w=0
_.x=-1
_.y=$},
e6:function e6(a){var _=this
_.b=_.a=0
_.e=_.c=null
_.r=a},
iY:function iY(){var _=this
_.a=null
_.e=_.d=_.c=_.b=0
_.f=null
_.r=0
_.w=null
_.y=_.x=$
_.z=null
_.Q=0
_.as=null
_.ay=_.ax=_.at=0
_.ch=null
_.dy=_.dx=_.db=_.cy=_.cx=_.CW=0},
iZ:function iZ(){var _=this
_.b=0
_.as=_.Q=_.z=null
_.ax=_.at=$
_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=_.ch=_.ay=0
_.fx=!1
_.fy=$
_.go=0
_.id=null},
j_:function j_(a,b){this.a=a
this.b=b},
nf(a){var s,r,q,p
if(a.q()!==0)return null
s=a.q()
if(s>=3)return null
if(B.dD[s]===B.be)return null
r=a.q()
q=J.cn(r,t.aw)
for(p=0;p<r;++p){J.d(a.a,a.d++)
J.d(a.a,a.d++)
J.d(a.a,a.d++);++a.d
a.q()
a.q()
q[p]=new A.h2(a.k(),a.k())}return new A.h1(r,q)},
d8:function d8(a,b){this.a=a
this.b=b},
h1:function h1(a,b){this.d=a
this.e=b},
h2:function h2(a,b){this.d=a
this.e=b},
h_:function h_(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.z=h
_.ay=_.ax=_.at=_.as=$
_.ch=null
_.fx=_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=$
_.fy=i},
j1:function j1(){this.b=this.a=null},
kq:function kq(){},
h0:function h0(){},
fJ:function fJ(a,b,c){this.e=a
this.f=b
this.r=c},
bW:function bW(){},
ck:function ck(a){this.a=a},
ea:function ea(a){this.a=a},
uA(b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2
if($.my==null){s=new Uint8Array(768)
for(r=0;r<256;++r){q=256+r
if(!(q<768))return A.a(s,q)
s[q]=r}for(r=256;r<512;++r){q=256+r
if(!(q<768))return A.a(s,q)
s[q]=255}$.my=s}for(q=b6.$flags|0,r=0;r<64;++r){p=b4[r]
o=b3[r]
q&2&&A.b(b6)
if(!(r<64))return A.a(b6,r)
b6[r]=p*o}for(n=0,r=0;r<8;++r,n+=8){p=1+n
if(!(p<64))return A.a(b6,p)
o=b6[p]
m=!1
if(o===0){l=2+n
if(!(l<64))return A.a(b6,l)
if(b6[l]===0){l=3+n
if(!(l<64))return A.a(b6,l)
if(b6[l]===0){l=4+n
if(!(l<64))return A.a(b6,l)
if(b6[l]===0){l=5+n
if(!(l<64))return A.a(b6,l)
if(b6[l]===0){l=6+n
if(!(l<64))return A.a(b6,l)
if(b6[l]===0){m=7+n
if(!(m<64))return A.a(b6,m)
m=b6[m]===0}}}}}}if(m){if(!(n<64))return A.a(b6,n)
p=B.a.j(5793*b6[n]+512,10)
k=(p&2147483647)-((p&2147483648)>>>0)
q&2&&A.b(b6)
if(!(n<64))return A.a(b6,n)
b6[n]=k
p=n+1
if(!(p<64))return A.a(b6,p)
b6[p]=k
p=n+2
if(!(p<64))return A.a(b6,p)
b6[p]=k
p=n+3
if(!(p<64))return A.a(b6,p)
b6[p]=k
p=n+4
if(!(p<64))return A.a(b6,p)
b6[p]=k
p=n+5
if(!(p<64))return A.a(b6,p)
b6[p]=k
p=n+6
if(!(p<64))return A.a(b6,p)
b6[p]=k
p=n+7
if(!(p<64))return A.a(b6,p)
b6[p]=k
continue}if(!(n<64))return A.a(b6,n)
m=B.a.j(5793*b6[n]+128,8)
j=(m&2147483647)-((m&2147483648)>>>0)
m=4+n
if(!(m<64))return A.a(b6,m)
l=B.a.j(5793*b6[m]+128,8)
i=(l&2147483647)-((l&2147483648)>>>0)
l=2+n
if(!(l<64))return A.a(b6,l)
h=b6[l]
g=6+n
if(!(g<64))return A.a(b6,g)
f=b6[g]
e=7+n
if(!(e<64))return A.a(b6,e)
d=b6[e]
c=B.a.j(2896*(o-d)+128,8)
b=(c&2147483647)-((c&2147483648)>>>0)
d=B.a.j(2896*(o+d)+128,8)
a=(d&2147483647)-((d&2147483648)>>>0)
d=3+n
if(!(d<64))return A.a(b6,d)
o=b6[d]<<4
a0=(o&2147483647)-((o&2147483648)>>>0)
o=5+n
if(!(o<64))return A.a(b6,o)
c=b6[o]<<4
a1=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(j-i+1,1)
k=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(j+i+1,1)
j=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(h*3784+f*1567+128,8)
c=(c&2147483647)-((c&2147483648)>>>0)
a2=B.a.j(h*1567-f*3784+128,8)
h=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.j(b-a1+1,1)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a3=B.a.j(b+a1+1,1)
b=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.j(a+a0+1,1)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
a4=B.a.j(a-a0+1,1)
a0=(a4&2147483647)-((a4&2147483648)>>>0)
a4=B.a.j(j-c+1,1)
a4=(a4&2147483647)-((a4&2147483648)>>>0)
c=B.a.j(j+c+1,1)
j=(c&2147483647)-((c&2147483648)>>>0)
c=B.a.j(k-h+1,1)
c=(c&2147483647)-((c&2147483648)>>>0)
a5=B.a.j(k+h+1,1)
i=(a5&2147483647)-((a5&2147483648)>>>0)
a5=B.a.j(b*2276+a3*3406+2048,12)
k=(a5&2147483647)-((a5&2147483648)>>>0)
a3=B.a.j(b*3406-a3*2276+2048,12)
b=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.j(a0*799+a2*4017+2048,12)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
a2=B.a.j(a0*4017-a2*799+2048,12)
a0=(a2&2147483647)-((a2&2147483648)>>>0)
q&2&&A.b(b6)
if(!(n<64))return A.a(b6,n)
b6[n]=j+k
if(!(e<64))return A.a(b6,e)
b6[e]=j-k
if(!(p<64))return A.a(b6,p)
b6[p]=i+a3
if(!(g<64))return A.a(b6,g)
b6[g]=i-a3
if(!(l<64))return A.a(b6,l)
b6[l]=c+a0
if(!(o<64))return A.a(b6,o)
b6[o]=c-a0
if(!(d<64))return A.a(b6,d)
b6[d]=a4+b
if(!(m<64))return A.a(b6,m)
b6[m]=a4-b}for(r=0;r<8;++r){a6=8+r
a7=16+r
a8=24+r
a9=32+r
b0=40+r
b1=48+r
b2=56+r
p=b6[a6]
if(p===0&&b6[a7]===0&&b6[a8]===0&&b6[a9]===0&&b6[b0]===0&&b6[b1]===0&&b6[b2]===0){p=B.a.j(5793*b6[r]+8192,14)
k=(p&2147483647)-((p&2147483648)>>>0)
q&2&&A.b(b6)
if(!(r<64))return A.a(b6,r)
b6[r]=k
if(!(a6<64))return A.a(b6,a6)
b6[a6]=k
if(!(a7<64))return A.a(b6,a7)
b6[a7]=k
if(!(a8<64))return A.a(b6,a8)
b6[a8]=k
if(!(a9<64))return A.a(b6,a9)
b6[a9]=k
if(!(b0<64))return A.a(b6,b0)
b6[b0]=k
if(!(b1<64))return A.a(b6,b1)
b6[b1]=k
if(!(b2<64))return A.a(b6,b2)
b6[b2]=k
continue}o=B.a.j(5793*b6[r]+2048,12)
j=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(5793*b6[a9]+2048,12)
i=(o&2147483647)-((o&2147483648)>>>0)
h=b6[a7]
f=b6[b1]
o=b6[b2]
m=B.a.j(2896*(p-o)+2048,12)
b=(m&2147483647)-((m&2147483648)>>>0)
o=B.a.j(2896*(p+o)+2048,12)
a=(o&2147483647)-((o&2147483648)>>>0)
a0=b6[a8]
a1=b6[b0]
o=B.a.j(j-i+1,1)
k=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(j+i+1,1)
j=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(h*3784+f*1567+2048,12)
p=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(h*1567-f*3784+2048,12)
h=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(b-a1+1,1)
o=(o&2147483647)-((o&2147483648)>>>0)
m=B.a.j(b+a1+1,1)
b=(m&2147483647)-((m&2147483648)>>>0)
m=B.a.j(a+a0+1,1)
m=(m&2147483647)-((m&2147483648)>>>0)
l=B.a.j(a-a0+1,1)
a0=(l&2147483647)-((l&2147483648)>>>0)
l=B.a.j(j-p+1,1)
l=(l&2147483647)-((l&2147483648)>>>0)
p=B.a.j(j+p+1,1)
j=(p&2147483647)-((p&2147483648)>>>0)
p=B.a.j(k-h+1,1)
p=(p&2147483647)-((p&2147483648)>>>0)
g=B.a.j(k+h+1,1)
i=(g&2147483647)-((g&2147483648)>>>0)
g=B.a.j(b*2276+m*3406+2048,12)
k=(g&2147483647)-((g&2147483648)>>>0)
m=B.a.j(b*3406-m*2276+2048,12)
b=(m&2147483647)-((m&2147483648)>>>0)
m=B.a.j(a0*799+o*4017+2048,12)
m=(m&2147483647)-((m&2147483648)>>>0)
o=B.a.j(a0*4017-o*799+2048,12)
a0=(o&2147483647)-((o&2147483648)>>>0)
q&2&&A.b(b6)
if(!(r<64))return A.a(b6,r)
b6[r]=j+k
if(!(b2<64))return A.a(b6,b2)
b6[b2]=j-k
b6[a6]=i+m
b6[b1]=i-m
b6[a7]=p+a0
b6[b0]=p-a0
b6[a8]=l+b
b6[a9]=l-b}for(q=$.my,p=b5.$flags|0,r=0;r<64;++r){q.toString
o=B.a.j(b6[r]+8,4)
o=384+((o&2147483647)-((o&2147483648)>>>0))
if(!(o>=0&&o<768))return A.a(q,o)
o=q[o]
p&2&&A.b(b5)
if(!(r<64))return A.a(b5,r)
b5[r]=o}},
uh(e5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2=null,e3="ifd0",e4=e5.w
if(e4.l(0,e3).a.a9(274)){s=e4.l(0,e3).gcp()
s.toString
r=s}else r=0
s=e5.d
q=s.e
q.toString
s=s.d
s.toString
p=r>=5&&r<=8
if(p)o=s
else o=q
if(p)n=q
else n=s
m=A.Q(e2,e2,B.e,0,B.j,n,e2,0,3,e2,B.e,o,!1)
m.e=A.dZ(e4)
m.gbp().l(0,e3).scp(e2)
m.c=e5.r
l=s-1
k=q-1
switch(r){case 2:j=new A.lk(m,k)
break
case 3:j=new A.ll(m,k,l)
break
case 4:j=new A.lm(m,l)
break
case 5:j=new A.ln(m)
break
case 6:j=new A.lo(m,l)
break
case 7:j=new A.lp(m,l,k)
break
case 8:j=new A.lq(m,k)
break
default:j=m.ghS()
break}e4=e5.as
i=e4.length
switch(i){case 1:if(0>=i)return A.a(e4,0)
h=e4[0]
g=h.e
f=h.f
e=h.r
for(e4=g.length,d=0;d<s;++d){c=B.a.a0(d,e)
if(!(c<e4))return A.a(g,c)
b=g[c]
for(a=0;a<q;++a){a0=B.a.a0(a,f)
if(!(a0<b.length))return A.a(b,a0)
a1=b[a0]
j.$5(a,d,a1,a1,a1)}}break
case 3:a2=e5.c
a3=a2==null||a2.d===1
if(0>=i)return A.a(e4,0)
h=e4[0]
if(1>=i)return A.a(e4,1)
a4=e4[1]
if(2>=i)return A.a(e4,2)
a5=e4[2]
a6=h.e
a7=a4.e
a8=a5.e
f=h.f
e=h.r
a9=a4.f
b0=a4.r
b1=a5.f
b2=a5.r
for(e4=a6.length,i=a7.length,a2=a8.length,d=0;d<s;++d){c=B.a.a0(d,e)
b3=B.a.a0(d,b0)
b4=B.a.a0(d,b2)
if(!(c<e4))return A.a(a6,c)
b=a6[c]
if(!(b3<i))return A.a(a7,b3)
b5=a7[b3]
if(!(b4<a2))return A.a(a8,b4)
b6=a8[b4]
for(a=0;a<q;++a){a0=B.a.a0(a,f)
b7=B.a.a0(a,a9)
b8=B.a.a0(a,b1)
if(!(a0<b.length))return A.a(b,a0)
b9=b[a0]
if(!(b7<b5.length))return A.a(b5,b7)
c0=b5[b7]
if(!(b8<b6.length))return A.a(b6,b8)
c1=b6[b8]
if(a3){a1=b9<<8>>>0
c2=c0-128
c3=c1-128
c4=B.a.j(a1+359*c3,8)
b9=B.a.G((c4&2147483647)-((c4&2147483648)>>>0),0,255)
c4=B.a.j(a1-88*c2-183*c3,8)
c0=B.a.G((c4&2147483647)-((c4&2147483648)>>>0),0,255)
c4=B.a.j(a1+454*c2,8)
c1=B.a.G((c4&2147483647)-((c4&2147483648)>>>0),0,255)}j.$5(a,d,b9,c0,c1)}}break
case 4:a2=e5.c
if(a2==null)throw A.h(A.n("Unsupported color mode (4 components)"))
a2=a2.d===0
if(0>=i)return A.a(e4,0)
h=e4[0]
if(1>=i)return A.a(e4,1)
a4=e4[1]
if(2>=i)return A.a(e4,2)
a5=e4[2]
if(3>=i)return A.a(e4,3)
c5=e4[3]
a6=h.e
a7=a4.e
a8=a5.e
c6=c5.e
f=h.f
e=h.r
a9=a4.f
b0=a4.r
b1=a5.f
b2=a5.r
c7=c5.f
c8=c5.r
for(e4=a6.length,i=a7.length,c4=a8.length,c9=c6.length,d=0;d<s;++d){c=B.a.a0(d,e)
b3=B.a.a0(d,b0)
b4=B.a.a0(d,b2)
d0=B.a.a0(d,c8)
if(!(c<e4))return A.a(a6,c)
b=a6[c]
if(!(b3<i))return A.a(a7,b3)
b5=a7[b3]
if(!(b4<c4))return A.a(a8,b4)
b6=a8[b4]
if(!(d0<c9))return A.a(c6,d0)
d1=c6[d0]
for(a=0;a<q;++a){a0=B.a.a0(a,f)
b7=B.a.a0(a,a9)
b8=B.a.a0(a,b1)
d2=B.a.a0(a,c7)
if(a2){if(!(a0<b.length))return A.a(b,a0)
d3=b[a0]
if(!(b7<b5.length))return A.a(b5,b7)
d4=b5[b7]
if(!(b8<b6.length))return A.a(b6,b8)
a1=b6[b8]
if(!(d2<d1.length))return A.a(d1,d2)
d5=d1[d2]}else{if(!(a0<b.length))return A.a(b,a0)
a1=b[a0]
if(!(b7<b5.length))return A.a(b5,b7)
c2=b5[b7]
if(!(b8<b6.length))return A.a(b6,b8)
c3=b6[b8]
if(!(d2<d1.length))return A.a(d1,d2)
d5=d1[d2]
d6=c3-128
d7=c2-128
d8=a1<<8>>>0
d9=B.a.j(d8+359*d6,8)
d3=255-B.a.G((d9&2147483647)-((d9&2147483648)>>>0),0,255)
d9=B.a.j(d8-88*d7-183*d6,8)
d4=255-B.a.G((d9&2147483647)-((d9&2147483648)>>>0),0,255)
d9=B.a.j(d8+454*d7,8)
a1=255-B.a.G((d9&2147483647)-((d9&2147483648)>>>0),0,255)}d9=B.a.j(d3*d5,8)
e0=B.a.j(d4*d5,8)
e1=B.a.j(a1*d5,8)
j.$5(a,d,(d9&2147483647)-((d9&2147483648)>>>0),(e0&2147483647)-((e0&2147483648)>>>0),(e1&2147483647)-((e1&2147483648)>>>0))}}break
default:throw A.h(A.n("Unsupported color mode"))}return m},
lk:function lk(a,b){this.a=a
this.b=b},
ll:function ll(a,b,c){this.a=a
this.b=b
this.c=c},
lm:function lm(a,b){this.a=a
this.b=b},
ln:function ln(a){this.a=a},
lo:function lo(a,b){this.a=a
this.b=b},
lp:function lp(a,b,c){this.a=a
this.b=b
this.c=c},
lq:function lq(a,b){this.a=a
this.b=b},
je:function je(){this.d=null},
c_:function c_(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.y=_.x=_.w=_.r=_.f=_.e=$},
nw(){var s=A.E(4,null,!1,t.jH),r=A.j([],t.gU),q=t.iM,p=J.hm(0,q)
q=J.hm(0,q)
return new A.jg(new A.by(A.I(t.N,t.P)),s,r,p,q,A.j([],t.an))},
jg:function jg(a,b,c,d,e,f){var _=this
_.b=_.a=$
_.r=_.e=_.d=_.c=null
_.w=a
_.x=b
_.y=c
_.z=d
_.Q=e
_.as=f},
dJ:function dJ(a){this.a=a
this.b=0},
hp:function hp(a,b){var _=this
_.e=_.d=_.c=_.b=null
_.r=_.f=0
_.x=_.w=$
_.y=a
_.z=b},
ji:function ji(){this.r=this.f=$},
hq:function hq(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=b
_.f=$
_.r=null
_.y=c
_.z=d
_.Q=e
_.as=f
_.at=g
_.ax=h
_.cx=_.CW=_.ch=_.ay=0
_.cy=$},
ho:function ho(){},
jf:function jf(a,b){this.a=a
this.b=b},
jh:function jh(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.f=_.e=null
_.w=_.r=$
_.x=e
_.y=f
_.z=g
_.Q=h
_.as=i
_.at=null
_.ax=0
_.ay=7},
dq:function dq(a,b){this.a=a
this.b=b},
eL:function eL(a,b){this.a=a
this.b=b},
eM:function eM(){},
hg:function hg(a,b,c,d,e,f,g,h,i){var _=this
_.y=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
nr(){var s=t.N
return new A.hh(A.I(s,s),A.j([],t.fi),A.j([],t.t))},
c2:function c2(a,b){this.a=a
this.b=b},
hG:function hG(){},
hh:function hh(a,b,c){var _=this
_.c=_.b=_.a=0
_.d=-1
_.r=_.f=0
_.z=_.x=_.w=null
_.Q=""
_.at=null
_.ax=a
_.CW=1
_.cy=b
_.db=c},
hD:function hD(a){var _=this
_.a=a
_.c=_.b=0
_.d=$
_.e=0},
qa(){return new A.hE()},
hF:function hF(a,b){this.a=a
this.b=b},
hE:function hE(){var _=this
_.a=null
_.c=0
_.e=$
_.f=0
_.r=!1
_.w=null},
c3:function c3(a,b){this.a=a
this.b=b},
c4:function c4(a){this.b=this.a=0
this.e=a},
jA:function jA(a){this.b=this.a=null
this.c=a},
jB:function jB(){},
hI:function hI(){this.a=null},
hJ:function hJ(){this.a=null},
bm:function bm(){},
hM:function hM(){this.a=null},
hN:function hN(){this.a=null},
hQ:function hQ(){this.a=null},
hR:function hR(){this.a=null},
eO:function eO(a){this.b=a},
hP:function hP(){},
jC:function jC(){var _=this
_.w=_.r=_.f=_.e=$},
cF:function cF(a){this.a=a
this.c=null},
nJ(a){var s=new A.hK(A.j([],t.k9),A.I(t.p,t.ok))
s.ik(a)
return s},
md(a,b,c,d){var s=a/255,r=b/255,q=c/255,p=d/255,o=r*(1-q),n=s*(1-p)
return B.b.i(B.b.G((2*s<q?2*r*s+o+n:p*q-2*(q-s)*(p-r)+o+n)*255,0,255))},
jE(a,b){if(b===0)return 0
return B.a.i(B.a.G(B.b.i(255*(1-(1-a/255)/(b/255))),0,255))},
jG(a,b){return B.a.i(B.a.G(a+b-255,0,255))},
mf(a,b){return B.a.i(B.a.G(255-(255-b)*(255-a),0,255))},
jF(a,b){if(b===255)return 255
return B.b.i(B.b.G(a/255/(1-b/255)*255,0,255))},
mg(a,b){var s=a/255,r=b/255,q=1-r
return B.b.av(255*(q*r*s+r*(1-q*(1-s))))},
mb(a,b){var s=b/255,r=a/255
if(r<0.5)return B.b.av(510*s*r)
else return B.b.av(255*(1-2*(1-s)*(1-r)))},
mh(a,b){if(b<128)return A.jE(a,2*b)
else return A.jF(a,2*(b-128))},
mc(a,b){var s
if(b<128)return A.jG(a,2*b)
else{s=2*(b-128)
return s+a>255?255:a+s}},
me(a,b){return b<128?Math.min(a,2*b):Math.max(a,2*(b-128))},
ma(a,b){return B.b.av(b+a-2*b*a/255)},
aD(a,b,c){var s,r,q
if(a==null)s=0
else{s=a.length
if(c===1){if(!(b>=0&&b<s))return A.a(a,b)
s=a[b]}else{if(!(b>=0&&b<s))return A.a(a,b)
r=a[b]
q=b+1
if(!(q<s))return A.a(a,q)
q=(r<<8|a[q])>>>8
s=q}}return s},
nK(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.I(t.p,t.dS)
for(s=c1.length,r=0;q=c1.length,r<q;c1.length===s||(0,A.K)(c1),++r){p=c1[r]
b6.h(0,p.a,p)}if(b8===8)o=1
else o=b8===16?2:-1
n=A.Q(b5,b5,B.e,0,B.j,c0,b5,0,q,b5,B.e,b9,!1)
if(o===-1)throw A.h(A.n("PSD: unsupported bit depth: "+A.z(b8)))
m=b6.l(0,0)
l=b6.l(0,1)
k=b6.l(0,2)
j=b6.l(0,-1)
i=A.j([0,0,0],t.t)
h=-o
for(s=n.a,s=s.gH(s),g=q>=5,f=q===4,e=q>=2,q=q>=4;s.E();){d=s.gN()
h+=o
switch(b7){case B.cs:d.sn(A.aD(m.c,h,o))
d.st(A.aD(l.c,h,o))
d.su(A.aD(k.c,h,o))
d.sv(q?A.aD(j.c,h,o):255)
if(d.gv()!==0){d.sn((d.gn()+d.gv()-255)*255/d.gv())
d.st((d.gt()+d.gv()-255)*255/d.gv())
d.su((d.gu()+d.gv()-255)*255/d.gv())}break
case B.cu:c=A.aD(m.c,h,o)
b=A.aD(l.c,h,o)
a=A.aD(k.c,h,o)
a0=q?A.aD(j.c,h,o):255
a1=((c*100>>>8)+16)/116
a2=(b-128)/500+a1
a3=a1-(a-128)/200
a4=Math.pow(a1,3)
a1=a4>0.008856?a4:(a1-0.13793103448275862)/7.787
a5=Math.pow(a2,3)
a2=a5>0.008856?a5:(a2-0.13793103448275862)/7.787
a6=Math.pow(a3,3)
a3=a6>0.008856?a6:(a3-0.13793103448275862)/7.787
a2=a2*95.047/100
a1=a1*100/100
a3=a3*108.883/100
a7=a2*3.240454836+a1*-1.53713885+a3*-0.498531547
a8=a2*-0.96926639+a1*1.87601093+a3*0.041556082
a9=a2*0.05564342+a1*-0.20402585+a3*1.05722516
a7=a7>0.0031308?1.055*Math.pow(a7,0.4166666666666667)-0.055:12.92*a7
a8=a8>0.0031308?1.055*Math.pow(a8,0.4166666666666667)-0.055:12.92*a8
a9=a9>0.0031308?1.055*Math.pow(a9,0.4166666666666667)-0.055:12.92*a9
b0=[B.b.av(B.b.G(a7*255,0,255)),B.b.av(B.b.G(a8*255,0,255)),B.b.av(B.b.G(a9*255,0,255))]
d.sn(b0[0])
d.st(b0[1])
d.su(b0[2])
d.sv(a0)
break
case B.cr:b1=A.aD(m.c,h,o)
a0=e?A.aD(j.c,h,o):255
d.sn(b1)
d.st(b1)
d.su(b1)
d.sv(a0)
break
case B.ct:b2=A.aD(m.c,h,o)
b3=A.aD(l.c,h,o)
a1=A.aD(k.c,h,o)
b4=A.aD(b6.l(0,f?-1:3).c,h,o)
a0=g?A.aD(j.c,h,o):255
A.ou(255-b2,255-b3,255-a1,255-b4,i)
d.sn(i[0])
d.st(i[1])
d.su(i[2])
d.sv(a0)
break
default:throw A.h(A.n("Unhandled color mode: "+A.z(b7)))}}return n},
bb:function bb(a,b){this.a=a
this.b=b},
hK:function hK(a,b){var _=this
_.b=_.a=0
_.d=_.c=null
_.e=$
_.r=_.f=null
_.w=a
_.x=$
_.y=null
_.z=b
_.as=$
_.ay=_.ax=_.at=null},
hL:function hL(){},
hO:function hO(a,b,c){var _=this
_.b=_.a=null
_.f=_.e=_.d=_.c=$
_.r=null
_.as=_.y=_.w=$
_.ay=a
_.ch=b
_.cx=null
_.cy=c},
qn(a,b){var s
switch(a){case"lsct":s=b.c-b.d
b.k()
if(s>=12){if(b.ao(4)!=="8BIM")A.ax(A.n("Invalid key in layer additional data"))
b.ao(4)}if(s>=16)b.k()
return new A.hP()
default:return new A.eO(b)}},
dt:function dt(){},
jD:function jD(){this.a=null},
hS:function hS(){},
aW:function aW(a,b,c){this.a=a
this.b=b
this.c=c},
N:function N(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dw:function dw(a,b,c){this.a=a
this.b=b
this.$ti=c},
du:function du(){var _=this
_.Q=_.z=_.y=_.f=_.d=_.b=_.a=0},
dv:function dv(a){var _=this
_.b=0
_.c=a
_.Q=_.r=_.f=0},
eP:function eP(){this.y=this.b=this.a=0},
a6(a,b){var s,r=a>>>8
if(!(r<256))return A.a(B.Y,r)
r=B.Y[r]
s=b>>>8
if(!(s<256))return A.a(B.Y,s)
return(r<<17|B.Y[s]<<16|B.Y[a&255]<<1|B.Y[b&255])>>>0},
a4:function a4(a){var _=this
_.a=a
_.b=0
_.c=!1
_.d=0
_.e=!1
_.f=0
_.r=!1},
jH:function jH(){this.b=this.a=null},
qo(a,b,c){var s=new A.jJ(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dw(r.cW(),q.cW(),t.nv)
p.C(0,s.$2(1,0))
p.C(0,s.$2(2,0))
p.C(0,s.$2(3,0))
p.C(0,s.$2(0,1))
p.C(0,s.$2(1,1))
p.C(0,s.$2(1,2))
p.C(0,s.$2(1,3))
p.C(0,s.$2(2,0))
p.C(0,s.$2(2,1))
p.C(0,s.$2(2,2))
p.C(0,s.$2(2,3))
p.C(0,s.$2(3,0))
p.C(0,s.$2(3,1))
p.C(0,s.$2(3,2))
p.C(0,s.$2(3,3))
return p},
qp(a,b,c){var s=new A.jK(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dw(r.cW(),q.cW(),t.dT)
p.C(0,s.$2(1,0))
p.C(0,s.$2(2,0))
p.C(0,s.$2(3,0))
p.C(0,s.$2(0,1))
p.C(0,s.$2(1,1))
p.C(0,s.$2(1,2))
p.C(0,s.$2(1,3))
p.C(0,s.$2(2,0))
p.C(0,s.$2(2,1))
p.C(0,s.$2(2,2))
p.C(0,s.$2(2,3))
p.C(0,s.$2(3,0))
p.C(0,s.$2(3,1))
p.C(0,s.$2(3,2))
p.C(0,s.$2(3,3))
return p},
eQ:function eQ(a,b){this.a=a
this.b=b},
jI:function jI(){},
jJ:function jJ(a,b,c){this.a=a
this.b=b
this.c=c},
jK:function jK(a,b,c){this.a=a
this.b=b
this.c=c},
eW:function eW(a){var _=this
_.b=_.a=0
_.c=a
_.Q=_.z=_.y=_.x=_.f=_.e=0
_.as=null
_.ax=0},
av:function av(a,b){this.a=a
this.b=b},
jO:function jO(){this.a=null
this.b=$},
jP:function jP(){},
jQ:function jQ(a){this.a=a
this.c=this.b=0},
hX:function hX(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.f=e},
ml(a,b,c){var s=new A.jT(b,a),r=t.I
s.e=A.E(b,null,!1,r)
s.f=A.E(b,null,!1,r)
return s},
jT:function jT(a,b){var _=this
_.a=a
_.c=b
_.d=0
_.f=_.e=null
_.r=$
_.x=_.w=null
_.y=0
_.z=2
_.as=0
_.at=null},
hY:function hY(a,b,c,d){var _=this
_.a=a
_.c=_.b=0
_.d=b
_.w=_.r=_.f=_.e=1
_.x=c
_.y=d
_.z=!1
_.Q=1
_.at=_.as=$
_.ch=_.ay=0
_.cx=_.CW=null
_.db=_.cy=$
_.dy=1
_.fx=_.fr=0
_.id=null
_.k3=_.k2=_.k1=$},
cG:function cG(a,b){this.a=a
this.b=b},
a9:function a9(a,b){this.a=a
this.b=b},
aZ:function aZ(a,b){this.a=a
this.b=b},
hZ:function hZ(a){var _=this
_.b=_.a=0
_.d=null
_.f=a},
ny(){return new A.js(new Uint8Array(4096))},
js:function js(a){var _=this
_.a=9
_.d=_.c=_.b=0
_.w=_.r=_.f=_.e=$
_.x=a
_.z=_.y=$
_.Q=null
_.as=$},
jR:function jR(){this.a=null
this.c=$},
jS:function jS(){},
mm(a,b){var s=new Int32Array(4),r=new Int32Array(4),q=new Int8Array(4),p=new Int8Array(4),o=A.E(8,null,!1,t.nX),n=A.E(4,null,!1,t.nk)
return new A.jX(a,b,new A.k2(),new A.kd(),new A.jZ(s,r),new A.kf(q,p),o,n,new Uint8Array(4))},
nS(a,b,c){if(c===0)if(a===0)return b===0?6:5
else return b===0?4:0
return c},
jX:function jX(a,b,c,d,e,f,g,h,i){var _=this
_.a=a
_.b=b
_.c=$
_.d=null
_.e=$
_.f=c
_.r=d
_.w=e
_.x=f
_.as=_.Q=_.z=_.y=0
_.ax=_.at=null
_.ch=_.ay=$
_.cx=_.CW=null
_.cy=$
_.db=g
_.dy=h
_.fr=null
_.fy=_.fx=$
_.go=null
_.id=i
_.p3=_.p2=_.p1=_.ok=_.k4=_.k3=_.k2=_.k1=$
_.R8=_.p4=null
_.x2=_.x1=_.to=_.ry=_.rx=_.RG=$
_.xr=null
_.y2=_.y1=0
_.bJ=$
_.aT=null
_.bK=$
_.bU=_.cn=null
_.aY=$},
kg:function kg(){},
nQ(a){var s=new A.eZ(a)
s.b=254
s.c=0
s.d=-8
return s},
eZ:function eZ(a){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=!1},
G(a,b,c){return B.a.aG(B.a.j(a+2*b+c+2,2),32)},
qH(a){var s,r=A.j([A.G(J.d(a.a,a.d+-33),J.d(a.a,a.d+-32),J.d(a.a,a.d+-31)),A.G(J.d(a.a,a.d+-32),J.d(a.a,a.d+-31),J.d(a.a,a.d+-30)),A.G(J.d(a.a,a.d+-31),J.d(a.a,a.d+-30),J.d(a.a,a.d+-29)),A.G(J.d(a.a,a.d+-30),J.d(a.a,a.d+-29),J.d(a.a,a.d+-28))],t.t)
for(s=0;s<4;++s)a.c8(s*32,4,r)},
qz(a){var s=J.d(a.a,a.d+-33),r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=A.p(a,null,0),m=n.d4(),l=A.G(s,r,q)
m.$flags&2&&A.b(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.d4()
m=A.G(r,q,p)
l.$flags&2&&A.b(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m
n.d+=32
m=n.d4()
l=A.G(q,p,o)
m.$flags&2&&A.b(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.d4()
m=A.G(p,o,o)
l.$flags&2&&A.b(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m},
qx(a){var s,r,q,p
for(s=4,r=0;r<4;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
s=B.a.j(s,3)
for(r=0;r<4;++r){q=a.a
p=a.d+r*32
J.bu(q,p,p+4,s)}},
mn(a,b){var s,r,q,p,o,n,m=255-J.d(a.a,a.d+-33)
for(s=0,r=0;r<b;++r){q=m+J.d(a.a,a.d+(s-1))
for(p=0;p<b;++p){o=$.aH()
n=q+J.d(a.a,a.d+(-32+p))
if(!(n>=0&&n<766))return A.a(o,n)
n=o[n]
J.y(a.a,a.d+(s+p),n)}s+=32}},
qF(a){A.mn(a,4)},
qG(a){A.mn(a,8)},
qE(a){A.mn(a,16)},
qD(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=J.d(a.a,a.d+-33),m=J.d(a.a,a.d+-32),l=J.d(a.a,a.d+-31),k=J.d(a.a,a.d+-30),j=J.d(a.a,a.d+-29)
a.h(0,96,A.G(q,p,o))
s=A.G(r,q,p)
a.h(0,97,s)
a.h(0,64,s)
s=A.G(n,r,q)
a.h(0,98,s)
a.h(0,65,s)
a.h(0,32,s)
s=A.G(m,n,r)
a.h(0,99,s)
a.h(0,66,s)
a.h(0,33,s)
a.h(0,0,s)
s=A.G(l,m,n)
a.h(0,67,s)
a.h(0,34,s)
a.h(0,1,s)
s=A.G(k,l,m)
a.h(0,35,s)
a.h(0,2,s)
a.h(0,3,A.G(j,k,l))},
qC(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.h(0,0,A.G(r,q,p))
s=A.G(q,p,o)
a.h(0,32,s)
a.h(0,1,s)
s=A.G(p,o,n)
a.h(0,64,s)
a.h(0,33,s)
a.h(0,2,s)
s=A.G(o,n,m)
a.h(0,96,s)
a.h(0,65,s)
a.h(0,34,s)
a.h(0,3,s)
s=A.G(n,m,l)
a.h(0,97,s)
a.h(0,66,s)
a.h(0,35,s)
s=A.G(m,l,k)
a.h(0,98,s)
a.h(0,67,s)
a.h(0,99,A.G(l,k,k))},
qJ(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+-33),o=J.d(a.a,a.d+-32),n=J.d(a.a,a.d+-31),m=J.d(a.a,a.d+-30),l=J.d(a.a,a.d+-29),k=B.a.aG(B.a.j(p+o+1,1),32)
a.h(0,65,k)
a.h(0,0,k)
k=B.a.aG(B.a.j(o+n+1,1),32)
a.h(0,66,k)
a.h(0,1,k)
k=B.a.aG(B.a.j(n+m+1,1),32)
a.h(0,67,k)
a.h(0,2,k)
a.h(0,3,B.a.aG(B.a.j(m+l+1,1),32))
a.h(0,96,A.G(q,r,s))
a.h(0,64,A.G(r,s,p))
k=A.G(s,p,o)
a.h(0,97,k)
a.h(0,32,k)
k=A.G(p,o,n)
a.h(0,98,k)
a.h(0,33,k)
k=A.G(o,n,m)
a.h(0,99,k)
a.h(0,34,k)
a.h(0,35,A.G(n,m,l))},
qI(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.h(0,0,B.a.aG(B.a.j(r+q+1,1),32))
s=B.a.aG(B.a.j(q+p+1,1),32)
a.h(0,64,s)
a.h(0,1,s)
s=B.a.aG(B.a.j(p+o+1,1),32)
a.h(0,65,s)
a.h(0,2,s)
s=B.a.aG(B.a.j(o+n+1,1),32)
a.h(0,66,s)
a.h(0,3,s)
a.h(0,32,A.G(r,q,p))
s=A.G(q,p,o)
a.h(0,96,s)
a.h(0,33,s)
s=A.G(p,o,n)
a.h(0,97,s)
a.h(0,34,s)
s=A.G(o,n,m)
a.h(0,98,s)
a.h(0,35,s)
a.h(0,67,A.G(n,m,l))
a.h(0,99,A.G(m,l,k))},
qA(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95)
a.h(0,0,B.a.aG(B.a.j(r+q+1,1),32))
s=B.a.aG(B.a.j(q+p+1,1),32)
a.h(0,32,s)
a.h(0,2,s)
s=B.a.aG(B.a.j(p+o+1,1),32)
a.h(0,64,s)
a.h(0,34,s)
a.h(0,1,A.G(r,q,p))
s=A.G(q,p,o)
a.h(0,33,s)
a.h(0,3,s)
s=A.G(p,o,o)
a.h(0,65,s)
a.h(0,35,s)
a.h(0,99,o)
a.h(0,98,o)
a.h(0,97,o)
a.h(0,96,o)
a.h(0,66,o)
a.h(0,67,o)},
qy(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+95),o=J.d(a.a,a.d+-33),n=J.d(a.a,a.d+-32),m=J.d(a.a,a.d+-31),l=J.d(a.a,a.d+-30),k=B.a.aG(B.a.j(s+o+1,1),32)
a.h(0,34,k)
a.h(0,0,k)
k=B.a.aG(B.a.j(r+s+1,1),32)
a.h(0,66,k)
a.h(0,32,k)
k=B.a.aG(B.a.j(q+r+1,1),32)
a.h(0,98,k)
a.h(0,64,k)
a.h(0,96,B.a.aG(B.a.j(p+q+1,1),32))
a.h(0,3,A.G(n,m,l))
a.h(0,2,A.G(o,n,m))
k=A.G(s,o,n)
a.h(0,35,k)
a.h(0,1,k)
k=A.G(r,s,o)
a.h(0,67,k)
a.h(0,33,k)
k=A.G(q,r,s)
a.h(0,99,k)
a.h(0,65,k)
a.h(0,97,A.G(p,q,r))},
qU(a){var s
for(s=0;s<16;++s)a.bs(s*32,16,a,-32)},
qS(a){var s,r,q,p,o
for(s=0,r=16;r>0;--r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.bu(p,o,o+16,q)
s+=32}},
k0(a,b){var s,r,q
for(s=0;s<16;++s){r=b.a
q=b.d+s*32
J.bu(r,q,q+16,a)}},
qK(a){var s,r
for(s=16,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))+J.d(a.a,a.d+(r-32))
A.k0(B.a.j(s,5),a)},
qM(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.k0(B.a.j(s,4),a)},
qL(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(r-32))
A.k0(B.a.j(s,4),a)},
qN(a){A.k0(128,a)},
qV(a){var s
for(s=0;s<8;++s)a.bs(s*32,8,a,-32)},
qT(a){var s,r,q,p,o
for(s=0,r=0;r<8;++r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.bu(p,o,o+8,q)
s+=32}},
k1(a,b){var s,r,q
for(s=0;s<8;++s){r=b.a
q=b.d+s*32
J.bu(r,q,q+8,a)}},
qO(a){var s,r
for(s=8,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
A.k1(B.a.j(s,4),a)},
qP(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))
A.k1(B.a.j(s,3),a)},
qQ(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.k1(B.a.j(s,3),a)},
qR(a){A.k1(128,a)},
c5(a,b,c,d,e){var s=b+c+d*32,r=J.d(a.a,a.d+s)+B.a.j(e,3)
if(!((r&-256)>>>0===0))r=r<0?0:255
a.h(0,s,r)},
k_(a,b,c,d,e){A.c5(a,0,0,b,c+d)
A.c5(a,0,1,b,c+e)
A.c5(a,0,2,b,c-e)
A.c5(a,0,3,b,c-d)},
qB(){var s,r,q,p
if(!$.nR){for(s=-255;s<=255;++s){r=$.iE()
q=255+s
p=s<0?-s:s
r.$flags&2&&A.b(r)
r[q]=p
p=$.lE()
r=B.a.j(r[q],1)
p.$flags&2&&A.b(p)
p[q]=r}for(s=-1020;s<=1020;++s){r=$.lF()
if(s<-128)q=-128
else q=s>127?127:s
r.$flags&2&&A.b(r)
r[1020+s]=q}for(s=-112;s<=112;++s){r=$.lG()
if(s<-16)q=-16
else q=s>15?15:s
r.$flags&2&&A.b(r)
r[112+s]=q}for(s=-255;s<=510;++s){r=$.aH()
if(s<0)q=0
else q=s>255?255:s
r.$flags&2&&A.b(r)
r[255+s]=q}$.nR=!0}},
jY:function jY(){},
qw(){var s,r=J.a8(3,t.D)
for(s=0;s<3;++s)r[s]=new Uint8Array(11)
return new A.eY(r)},
rd(){var s,r,q,p,o=new Uint8Array(3),n=J.a8(4,t.ac)
for(s=t.aO,r=0;r<4;++r){q=J.a8(8,s)
for(p=0;p<8;++p)q[p]=A.qw()
n[r]=q}B.d.ac(o,0,3,255)
return new A.ke(o,n)},
k2:function k2(){this.d=$},
kd:function kd(){},
kf:function kf(a,b){var _=this
_.b=_.a=!1
_.c=!0
_.d=a
_.e=b},
eY:function eY(a){this.a=a},
ke:function ke(a,b){this.a=a
this.b=b},
jZ:function jZ(a,b){var _=this
_.a=$
_.b=null
_.d=_.c=$
_.e=a
_.f=b},
bM:function bM(){var _=this
_.b=_.a=0
_.c=!1
_.d=0},
f3:function f3(){this.b=this.a=0},
i8:function i8(a,b,c){this.a=a
this.b=b
this.c=c},
f4:function f4(a,b){var _=this
_.a=a
_.b=$
_.c=b
_.e=_.d=null
_.f=$},
f5:function f5(a,b,c){this.a=a
this.b=b
this.c=c},
mo(a,b){var s,r=A.j([],t.nK),q=A.j([],t.ip),p=new Uint32Array(2),o=new A.i4(a,p)
p=o.e=J.B(B.o.gB(p),0,null)
s=a.I()
p.$flags&2&&A.b(p)
if(0>=p.length)return A.a(p,0)
p[0]=s
s=a.I()
p.$flags&2&&A.b(p)
if(1>=p.length)return A.a(p,1)
p[1]=s
s=a.I()
p.$flags&2&&A.b(p)
if(2>=p.length)return A.a(p,2)
p[2]=s
s=a.I()
p.$flags&2&&A.b(p)
if(3>=p.length)return A.a(p,3)
p[3]=s
s=a.I()
p.$flags&2&&A.b(p)
if(4>=p.length)return A.a(p,4)
p[4]=s
s=a.I()
p.$flags&2&&A.b(p)
if(5>=p.length)return A.a(p,5)
p[5]=s
s=a.I()
p.$flags&2&&A.b(p)
if(6>=p.length)return A.a(p,6)
p[6]=s
s=a.I()
p.$flags&2&&A.b(p)
if(7>=p.length)return A.a(p,7)
p[7]=s
o.b=!1
return new A.f_(o,b,r,q)},
c6(a,b){return B.a.j(a+B.a.R(1,b)-1,b)},
f_:function f_(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=null
_.w=_.r=_.f=0
_.x=null
_.Q=_.z=_.y=0
_.as=null
_.at=0
_.ax=c
_.ay=null
_.ch=d
_.CW=0
_.cx=null
_.cy=$
_.db=0
_.dx=null
_.fr=_.dy=0},
hi:function hi(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=null
_.w=_.r=_.f=0
_.x=null
_.Q=_.z=_.y=0
_.as=null
_.at=0
_.ax=c
_.ay=null
_.ch=d
_.CW=0
_.cx=null
_.cy=$
_.db=0
_.dx=null
_.fr=_.dy=0},
tR(d4,d5,d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3=J.a8(12,t.E)
for(s=0;s<12;++s)d3[s]=new Uint32Array(256)
r=d3[0]
q=d3[1]
p=d3[2]
o=d3[3]
n=d3[4]
m=d3[5]
l=d3[6]
k=d3[7]
j=d3[8]
i=d3[9]
h=d3[10]
g=d3[11]
f=d4.length
if(0>=f)return A.a(d4,0)
e=d4[0]
for(d=r.$flags|0,c=q.$flags|0,b=p.$flags|0,a=o.$flags|0,a0=n.$flags|0,a1=m.$flags|0,a2=l.$flags|0,a3=k.$flags|0,a4=j.$flags|0,a5=i.$flags|0,a6=h.$flags|0,a7=g.$flags|0,a8=0;a8<d6;++a8){a9=a8*d5
for(b0=a8>0,b1=a9-d5,b2=0;b2<d5;++b2,e=b4){b3=a9+b2
if(!(b3>=0&&b3<f))return A.a(d4,b3)
b4=d4[b3]
b5=(16711935+((b4&4278255360)>>>0)-((e&4278255360)>>>0)&4278255360|4278255360+(b4&16711935)-(e&16711935)&16711935)>>>0
if(b5!==0)if(b0){b3=b1+b2
if(!(b3>=0&&b3<f))return A.a(d4,b3)
b3=b4===d4[b3]}else b3=!1
else b3=!0
if(b3)continue
b3=b4>>>24&255
b6=r[b3]
d&2&&A.b(r)
if(!(b3<256))return A.a(r,b3)
r[b3]=b6+1
b6=b4>>>16
b3=b6&255
b7=q[b3]
c&2&&A.b(q)
if(!(b3<256))return A.a(q,b3)
q[b3]=b7+1
b7=b4>>>8&255
b3=p[b7]
b&2&&A.b(p)
if(!(b7<256))return A.a(p,b7)
p[b7]=b3+1
b3=b4&255
b8=o[b3]
a&2&&A.b(o)
if(!(b3<256))return A.a(o,b3)
o[b3]=b8+1
b8=b5>>>24&255
b3=n[b8]
a0&2&&A.b(n)
if(!(b8<256))return A.a(n,b8)
n[b8]=b3+1
b3=b5>>>16
b8=b3&255
b9=m[b8]
a1&2&&A.b(m)
if(!(b8<256))return A.a(m,b8)
m[b8]=b9+1
b9=b5>>>8&255
b8=l[b9]
a2&2&&A.b(l)
if(!(b9<256))return A.a(l,b9)
l[b9]=b8+1
b8=b5&255
c0=k[b8]
a3&2&&A.b(k)
if(!(b8<256))return A.a(k,b8)
k[b8]=c0+1
b6=b6-b7&255
c0=j[b6]
a4&2&&A.b(j)
if(!(b6<256))return A.a(j,b6)
j[b6]=c0+1
b7=b4-b7&255
c0=i[b7]
a5&2&&A.b(i)
if(!(b7<256))return A.a(i,b7)
i[b7]=c0+1
b3=b3-b9&255
c0=h[b3]
a6&2&&A.b(h)
if(!(b3<256))return A.a(h,b3)
h[b3]=c0+1
b9=b5-b9&255
c0=g[b9]
a7&2&&A.b(g)
if(!(b9<256))return A.a(g,b9)
g[b9]=c0+1}}f=h[0]
a6&2&&A.b(h)
if(0>=256)return A.a(h,0)
h[0]=f+1
f=g[0]
a7&2&&A.b(g)
if(0>=256)return A.a(g,0)
g[0]=f+1
f=m[0]
a1&2&&A.b(m)
if(0>=256)return A.a(m,0)
m[0]=f+1
f=l[0]
a2&2&&A.b(l)
if(0>=256)return A.a(l,0)
l[0]=f+1
f=k[0]
a3&2&&A.b(k)
if(0>=256)return A.a(k,0)
k[0]=f+1
f=n[0]
a0&2&&A.b(n)
if(0>=256)return A.a(n,0)
n[0]=f+1
c1=new Float64Array(12)
for(c2=0;c2<12;++c2){f=A.rZ(d3[c2])
if(!(c2<12))return A.a(c1,c2)
c1[c2]=f}f=c1[0]
d=c1[1]
c=c1[2]
c3=f+d+c+c1[3]
d=c1[4]
b=c1[5]
a=c1[6]
a0=c1[7]
c4=f+c1[8]+c+c1[9]
c=c1[10]
f=c1[11]
c5=A.oq(d5,d7)*A.oq(d6,d7)
c6=d+b+a+a0+c5*(Math.log(14)/0.6931471805599453)
a0=Math.log(24)
c7=c6<c3
c8=c7?c6:c3
c9=c4<c8
if(c9){c8=c4
c7=!1}if(d+c+a+f+c5*(a0/0.6931471805599453)<c8){c7=!0
c9=!0}if(c7&&c9){d0=g
d1=h}else if(c7){d0=k
d1=m}else if(c9){d0=i
d1=j}else{d0=o
d1=q}c2=1
for(;;){if(!(c2<256)){d2=!0
break}if(d1[c2]!==0||d0[c2]!==0){d2=!1
break}++c2}return new A.k3(c9,c7,c7&&!d2)},
oq(a,b){return B.a.j(a+B.a.R(1,b)-1,b)},
rZ(a){var s,r,q,p,o,n,m,l,k
for(s=0,r=0,q=0,p=0,o=0;o<256;++o){n=a[o]
if(n!==0){s+=n;++r
p+=n*(Math.log(n)/0.6931471805599453)
if(n>q)q=n}}if(s===0)return 0
p=s*(Math.log(s)/0.6931471805599453)-p
m=r<5
if(m){if(r<=1)return 0
if(r===2)return(99*s+p)/100}if(m)l=r===3?0.95:0.7
else l=0.627
k=l*(2*s-q)+(1-l)*p
return p<k?k:p},
k3:function k3(a,b,c){this.a=a
this.b=b
this.c=c},
u1(a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8
if(a9.length<b3||b0.length<b3||b1.length<b3||b2.length<b3)throw A.h(A.b2("computeMatches needs "+b3+" of every plane",null))
s=new Uint32Array(b3)
r=new Int32Array(b3)
q=new A.kN(b3,s,r)
q.ip(a9,b0,b1,b2,b3)
q.lj()
p=new Int32Array(b3)
o=new Int32Array(b3)
n=A.j([1,2,b4-1,b4,b4+1],t.t)
m=t.gw.a(new A.le(b3))
l=t.fT
k=A.pV(l.p("e.E"))
k.cw(0,new A.cK(n,m,l))
j=A.u(k,A.l(k).c)
B.c.ev(j)
n=A.j([],t.kN)
for(m=j.length,i=0;l=j.length,i<l;j.length===m||(0,A.K)(j),++i)n.push(new Uint16Array(b3))
for(h=b3-1,m=n.length,g=0;g<l;++g){f=j[g]
if(!(g<m))return A.a(n,g)
e=n[g]
for(k=e.$flags|0,d=e.length,c=h;c>=f;--c){if(!(c>=0))return A.a(s,c)
b=s[c]
a=c-f
if(!(a>=0&&a<b3))return A.a(s,a)
if(b===s[a]){b=c+1
if(b<b3){if(!(b<d))return A.a(e,b)
a0=e[b]+1}else a0=1
a1=b3-c
if(a0>a1)a0=a1
if(a0>4096)a0=4096
k&2&&A.b(e)
if(!(c<d))return A.a(e,c)
e[c]=a0}}}while(h>0){a1=b3-h
if(a1>4096)a1=4096
for(a2=0,a3=0,g=0;g<l;++g){if(!(g<m))return A.a(n,g)
k=n[g]
if(!(h<k.length))return A.a(k,h)
a0=k[h]
if(a0>a2){a3=j[g]
a2=a0}}if(a2<a1){a4=a1<256?a1:256
if(!(h<b3))return A.a(r,h)
g=r[h]
a5=0
for(;;){if(!(g>=0&&a5<86))break;++a5
f=h-g
if(f>1048456)break
k=g+a2
if(!(k>=0&&k<b3))return A.a(s,k)
k=s[k]
d=h+a2
if(!(d>=0&&d<b3))return A.a(s,d)
if(k===s[d]){a6=0
for(;;){if(a6<a1){k=h+a6
if(!(k<b3))return A.a(s,k)
k=s[k]
d=g+a6
if(!(d>=0&&d<b3))return A.a(s,d)
d=k===s[d]
k=d}else k=!1
if(!k)break;++a6}if(a6>a2){if(a6>=a4){a3=f
a2=a6
break}a3=f
a2=a6}}if(!(g>=0&&g<b3))return A.a(r,g)
g=r[g]}}if(!(h<b3))return A.a(p,h)
p[h]=a2
if(!(h<b3))return A.a(o,h)
o[h]=a3
k=a3>0
a7=h
for(;;){if(!(k&&a2<4096))break
a8=a7-1
d=!0
if(a8>0)if(a8>=a3){d=a8-a3
if(!(d>=0&&d<b3))return A.a(s,d)
d=s[d]
if(!(a8>=0&&a8<b3))return A.a(s,a8)
d=d!==s[a8]}if(d)break;++a2
if(!(a8>=0))return A.a(p,a8)
p[a8]=a2
if(!(a8<b3))return A.a(o,a8)
o[a8]=a3
a7=a8}h=a7-1}return new A.kb(p,o,n,j)},
uC(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a2.a,a0=a2.b,a1=a2.c
for(s=a0.length,r=0,q=0,p=0;p<a;){if(!(p>=0&&p<s))return A.a(a0,p)
o=a0[p];++r
if(o<=1){++q;++p}else p+=o}n=new Uint8Array(r)
m=new Int32Array(q)
l=r-q
k=new Int32Array(l)
j=new Int32Array(l)
i=new Int32Array(r)
for(h=a1.length,g=0,f=0,e=0,p=0;p<a;){if(!(p>=0&&p<s))return A.a(a0,p)
o=a0[p]
if(!(g<r))return A.a(i,g)
i[g]=p
if(o<=1){if(!(g<r))return A.a(n,g)
n[g]=1
d=f+1
if(!(f<q))return A.a(m,f)
m[f]=p;++p
f=d}else{if(!(e<l))return A.a(k,e)
k[e]=o
c=e+1
if(!(p<h))return A.a(a1,p)
b=a1[p]
if(!(e<l))return A.a(j,e)
j[e]=b
p+=o
e=c}++g}return new A.k4(n,m,k,j,i)},
qW(a,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i=new Float64Array(280),h=new Float64Array(256),g=new Float64Array(256),f=new Float64Array(256),e=new Float64Array(40),d=a.a,c=a.b,b=a.c
for(s=b.length,r=c.length,q=a1.length,p=a0.length,o=a2.length,n=a3.length,m=0;m<d;){if(!(m>=0&&m<r))return A.a(c,m)
l=c[m]
if(l<=1){if(!(m<q))return A.a(a1,m)
k=a1[m]
B.q.h(i,k,B.q.l(i,k)+1)
if(!(m<p))return A.a(a0,m)
k=a0[m]
B.q.h(h,k,B.q.l(h,k)+1)
if(!(m<o))return A.a(a2,m)
k=a2[m]
B.q.h(g,k,B.q.l(g,k)+1)
if(!(m<n))return A.a(a3,m)
k=a3[m]
B.q.h(f,k,B.q.l(f,k)+1);++m}else{k=A.iz(l)
if(!(k>=0&&k<280))return A.a(i,k)
j=i[k]
if(!(k<280))return A.a(i,k)
i[k]=j+1
if(!(m<s))return A.a(b,m)
j=A.iB(A.iv(a4,b[m]))
if(!(j>=0&&j<40))return A.a(e,j)
k=e[j]
if(!(j<40))return A.a(e,j)
e[j]=k+1
m+=l}}return new A.k7(A.i6(i),A.i6(h),A.i6(g),A.i6(f),A.i6(e))},
i6(a){var s,r,q,p,o,n,m,l
for(s=a.length,r=0,q=0;q<s;++q)r+=a[q]
if(r===0){p=new Float64Array(s)
B.q.ac(p,0,s,8)
return p}o=new Float64Array(s)
for(p=r+1,n=0;n<s;++n){m=a[n]
l=Math.log((m>0?m:1)/p)
if(!(n<s))return A.a(o,n)
o[n]=-(l/0.6931471805599453)}return o},
k4:function k4(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
k9:function k9(a,b,c){this.a=a
this.b=b
this.c=c},
kb:function kb(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
le:function le(a){this.a=a},
kN:function kN(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=$},
k7:function k7(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=$},
k8:function k8(a){this.a=a},
i4:function i4(a,b){var _=this
_.a=0
_.b=!0
_.c=a
_.d=b
_.e=$},
i5:function i5(a){var _=this
_.a=a
_.d=_.c=_.b=0},
k6:function k6(a,b){this.a=a
this.b=b},
uD(a,b,c,d,e,f,g,h,i,j){var s,r,q,p,o,n,m,l
for(s=j.length,r=0,q=1/0,p=null,o=0;o<3;++o){n=B.dB[o]
m=new Int32Array(s)
if(n>0)A.tP(a,b,c,d,e,f,g,n,m)
else B.z.ac(m,0,s,-1)
l=A.t6(a,b,c,d,e,f,g,h,i,n,m)
if(l<q){p=m
q=l
r=n}}p.toString
B.z.eo(j,0,p)
return r},
tP(a,a0,a1,a2,a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=B.a.V(1,a6),e=new Uint32Array(f),d=new Uint8Array(f),c=new A.l9(a2,a,a0,a1),b=new A.la(32-a6)
for(s=a3.length,r=a5.length,q=a4.length,p=0,o=0,n=0,m=0;m<s;++m)if(a3[m]!==0){if(!(p<q))return A.a(a4,p)
l=c.$1(a4[p])
k=b.$1(l)
if(k>>>0!==k||k>=f)return A.a(d,k)
if(d[k]!==0){if(k>>>0!==k||k>=f)return A.a(e,k)
j=e[k]===l}else j=!1
j=j?k:-1
a7.$flags&2&&A.b(a7)
if(!(p<a7.length))return A.a(a7,p)
a7[p]=j
if(k>>>0!==k||k>=f)return A.a(e,k)
e[k]=l
if(k>>>0!==k||k>=f)return A.a(d,k)
d[k]=1;++p;++n}else{i=o+1
if(!(o<r))return A.a(a5,o)
h=a5[o]
for(g=0;g<h;++g){l=c.$1(n+g)
k=b.$1(l)
if(k>>>0!==k||k>=f)return A.a(e,k)
e[k]=l
if(k>>>0!==k||k>=f)return A.a(d,k)
d[k]=1}n+=h
o=i}},
t6(a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=280+(b3>0?B.a.V(1,b3):0),b=t.p,a=A.E(c,0,!1,b),a0=A.E(256,0,!1,b),a1=A.E(256,0,!1,b),a2=A.E(256,0,!1,b),a3=A.E(40,0,!1,b)
for(b=a8.length,s=b0.length,r=b1.length,q=a5.length,p=a4.length,o=a6.length,n=a7.length,m=b4.length,l=a9.length,k=0,j=0,i=0;i<b;++i)if(a8[i]!==0){if(!(k<m))return A.a(b4,k)
h=b4[k]
g=k+1
if(!(k<l))return A.a(a9,k)
f=a9[k]
if(h>=0){e=280+h
if(!(e<c))return A.a(a,e)
B.c.h(a,e,a[e]+1)}else{if(!(f>=0&&f<q))return A.a(a5,f)
e=a5[f]
B.c.h(a,e,B.c.l(a,e)+1)
if(!(f<p))return A.a(a4,f)
e=a4[f]
B.c.h(a0,e,B.c.l(a0,e)+1)
if(!(f<o))return A.a(a6,f)
e=a6[f]
B.c.h(a1,e,B.c.l(a1,e)+1)
if(!(f<n))return A.a(a7,f)
e=a7[f]
B.c.h(a2,e,B.c.l(a2,e)+1)}k=g}else{if(!(j<s))return A.a(b0,j)
e=A.iz(b0[j])
if(!(e>=0&&e<c))return A.a(a,e)
B.c.h(a,e,a[e]+1)
if(!(j<r))return A.a(b1,j)
e=A.iB(A.iv(b2,b1[j]))
if(!(e>=0&&e<40))return A.a(a3,e)
B.c.h(a3,e,a3[e]+1);++j}d=A.iq(a)+A.iq(a0)+A.iq(a1)+A.iq(a2)+A.iq(a3)
for(c=[a,a0,a1,a2,a3],i=0;i<5;++i)for(b=B.c.gH(c[i]);b.E();)if(b.gN()>0)d+=4
return d},
iq(a){var s,r,q,p,o
for(s=a.length,r=0,q=0;q<s;++q)r+=a[q]
if(r===0)return 0
for(p=0,q=0;q<s;++q){o=a[q]
if(o>0)p-=o*(Math.log(o/r)/0.6931471805599453)}return p},
l9:function l9(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
la:function la(a){this.a=a},
mz(a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
for(s=a2.length,r=a1.length,q=0,p=0,o=0;o<a3;++o){if(!(o<r))return A.a(a1,o)
n=a1[o]
n=n<128?n:n-256
if(!(o<s))return A.a(a2,o)
m=a2[o]
q+=n*(m<128?m:m-256)
p+=n*n}if(p===0)return 0
l=B.a.G(B.b.av(32*q/p),-128,127)
a4.$flags&2&&A.b(a4)
if(0>=6)return A.a(a4,0)
a4[0]=0
a5.$flags&2&&A.b(a5)
if(0>=6)return A.a(a5,0)
a5[0]=0
for(k=l-2,j=l+2,i=1;k<=j;++k)if(k>=-128&&k<=127){h=k&255
h=h<128?h:h-256
if(!(i<6))return A.a(a5,i)
a5[i]=h
g=i+1
if(!(i<6))return A.a(a4,i)
a4[i]=k
i=g}B.z.ac(a6,0,i,0)
for(j=a6.$flags|0,o=0;o<a3;++o){if(!(o<r))return A.a(a1,o)
f=a1[o]
f=f<128?f:f-256
if(!(o<s))return A.a(a2,o)
k=a2[o]
for(e=0;e<i;++e){if(!(e<6))return A.a(a5,e)
d=k-B.a.j(a5[e]*f,5)&255
h=a6[e]
c=d<128?d:256-d
j&2&&A.b(a6)
if(!(e<6))return A.a(a6,e)
a6[e]=h+c}}b=a6[0]
for(a=0,e=1;e<i;++e){if(!(e<6))return A.a(a6,e)
a0=a6[e]
if(a0<b){a=a4[e]
b=a0}}return a&255},
uE(c1,c2,c3,c4,c5,c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7=B.a.R(1,c6),a8=B.a.j(c4+a7-1,c6),a9=B.a.j(c5+a7-1,c6),b0=A.j([],t.l3),b1=new Uint32Array(512),b2=new Uint32Array(512),b3=a7*a7,b4=new Uint8Array(b3),b5=new Uint8Array(b3),b6=new Uint8Array(b3),b7=new Uint8Array(b3),b8=new Int32Array(6),b9=new Int32Array(6),c0=new Int32Array(6)
for(s=c2.length,r=c1.length,q=c3.length,p=0;p<a9;++p)for(o=p*a7,n=o+a7,m=0;m<a8;++m){l=m*a7
k=l+a7
k=k<c4?k:c4
j=n<c5?n:c5
for(i=o,h=0;i<j;++i){g=i*c4
for(f=l;f<k;++f){e=g+f
if(!(e>=0&&e<s))return A.a(c2,e)
B.d.h(b4,h,c2[e])
if(!(e<r))return A.a(c1,e)
B.d.h(b5,h,c1[e])
if(!(e<q))return A.a(c3,e)
B.d.h(b6,h,c3[e]);++h}}d=A.mz(b4,b5,h,b8,b9,c0)
c=A.mz(b4,b6,h,b8,b9,c0)
for(b=c-256,a=c<128,a0=0;a0<h;++a0){if(!(a0<b3))return A.a(b6,a0)
a1=b6[a0]
a2=b4[a0]
a3=a?c:b
a2=B.a.j(a3*(a2<128?a2:a2-256),5)
if(!(a0<b3))return A.a(b7,a0)
b7[a0]=a1-a2&255}a4=A.mz(b5,b7,h,b8,b9,c0)
B.c.C(b0,new A.f0(d,c,a4))
for(b=a4-256,a=a4<128,a1=d-256,a2=d<128,a0=0;a0<h;++a0){if(!(a0<b3))return A.a(b5,a0)
a3=b5[a0]
if(!(a3<512))return A.a(b1,a3)
a5=b1[a3]
if(!(a3<512))return A.a(b1,a3)
b1[a3]=a5+1
a5=256+b6[a0]
if(!(a5<512))return A.a(b1,a5)
a3=b1[a5]
if(!(a5<512))return A.a(b1,a5)
b1[a5]=a3+1
a3=b5[a0]
a5=b4[a0]
a6=a2?d:a1
a3=a3-B.a.j(a6*(a5<128?a5:a5-256),5)&255
a5=b2[a3]
if(!(a3<512))return A.a(b2,a3)
b2[a3]=a5+1
a5=b7[a0]
a3=b5[a0]
a6=a?a4:b
a3=256+(a5-B.a.j(a6*(a3<128?a3:a3-256),5)&255)
a5=b2[a3]
if(!(a3<512))return A.a(b2,a3)
b2[a3]=a5+1}}return A.l3(b1,256,0)+A.l3(b1,256,256)-A.l3(b2,256,0)-A.l3(b2,256,256)>a8*a9*24?b0:null},
l3(a,b,c){var s,r,q,p,o
for(s=0,r=0;r<b;++r){q=c+r
if(!(q<512))return A.a(a,q)
s+=a[q]}if(s===0)return 0
for(p=0,r=0;r<b;++r){q=c+r
if(!(q<512))return A.a(a,q)
o=a[q]
if(o>0)p-=o*(Math.log(o/s)/0.6931471805599453)}return p},
tT(a,b,c,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=B.a.j(a0+B.a.R(1,a2)-1,a2)
for(s=c.$flags|0,r=a.$flags|0,q=c.length,p=b.length,o=a3.length,n=a.length,m=0;m<a1;++m)for(l=m*a0,k=0;k<a0;++k){j=l+k
i=B.a.a0(m,a2)*d+B.a.a0(k,a2)
if(!(i<o))return A.a(a3,i)
h=a3[i]
if(!(j>=0&&j<n))return A.a(a,j)
g=a[j]
i=h.a
if(!(j<p))return A.a(b,j)
f=b[j]
i=i<128?i:i-256
i=B.b.j(i*(f<128?f:f-256),5)
r&2&&A.b(a)
a[j]=g-i&255
if(!(j<q))return A.a(c,j)
i=c[j]
f=h.b
e=b[j]
f=f<128?f:f-256
f=B.b.j(f*(e<128?e:e-256),5)
e=h.c
e=e<128?e:e-256
e=B.b.j(e*(g<128?g:g-256),5)
s&2&&A.b(c)
c[j]=i-f-e&255}},
f0:function f0(a,b,c){this.a=a
this.b=b
this.c=c},
qY(a,b){return B.a.aL(a+B.a.V(1,b)-1,b)},
qX(a,b){var s,r,q,p,o,n,m,l,k,j,i=b.a,h=b.b,g=b.c
for(s=h.$flags|0,r=a.b,q=r.length,p=g.$flags|0,o=a.a,n=o.length,m=0;m<i;){if(!(m>=0&&m<n))return A.a(o,m)
l=o[m]
k=l>=3?l:1
s&2&&A.b(h)
if(!(m<h.length))return A.a(h,m)
h[m]=k
if(!(m<q))return A.a(r,m)
j=r[m]
p&2&&A.b(g)
if(!(m<g.length))return A.a(g,m)
g[m]=j
m+=k}},
ka:function ka(a){this.a=a},
kO:function kO(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ig:function ig(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.z=_.y=_.x=_.w=_.r=$},
f2(a){var s=new Float64Array(5),r=new Int32Array(5),q=new Int32Array(5),p=A.E(5,$.oY(),!1,t.k),o=new Int32Array(5),n=new Uint32Array(a),m=new Uint32Array(256),l=new Uint32Array(256),k=new Uint32Array(256)
return new A.f1(a,n,m,l,k,new Uint32Array(40),s,r,q,p,o)},
u0(a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=null,a6=a7.length
if(a6<2)return a5
s=t.cy
r=A.j([],s)
q=new Int32Array(a6)
for(p=0;p<a6;++p){o=a7[p]
if(o.gcm()===0){q[p]=0
if(r.length===0){n=A.f2(o.a)
o.cR(n)
B.c.C(r,n)}continue}for(m=-1,l=1/0,k=0;j=r.length,k<j;++k){j=r[k].hu(o)
if(!(k<r.length))return A.a(r,k)
i=j-r[k].gcm()-o.gcm()
if(i<l){l=i
m=k}}if(m>=0)h=l>160&&j<16
else h=!0
if(h){q[p]=j
n=A.f2(o.a)
o.cR(n)
B.c.C(r,n)}else{q[p]=m
if(!(m>=0&&m<j))return A.a(r,m)
o.cR(r[m])}}if(r.length<2)return a5
g=B.c.gho(a7).a
f=r.length
e=J.a8(f,t.d)
for(d=0;d<f;++d)e[d]=A.f2(g)
for(p=0;p<a6;++p){o=a7[p]
if(o.gcm()===0)q[p]=p>0?q[p-1]:0
else{for(c=0,l=1/0,k=0;k<r.length;++k){j=r[k].hu(o)
if(!(k<r.length))return A.a(r,k)
i=j-r[k].gcm()
if(i<l){l=i
c=k}}q[p]=c}j=q[p]
if(!(j>=0&&j<f))return A.a(e,j)
o.cR(e[j])}j=r.length
b=new Uint32Array(j)
for(d=0;d<a6;++d){k=q[d]
if(!(k>=0&&k<j))return A.a(b,k)
b[k]=b[k]+1}a=new Int32Array(j)
a0=A.j([],s)
for(k=0;k<r.length;++k){s=a0.length
if(!(k<j))return A.a(a,k)
a[k]=s
if(!(k<j))return A.a(b,k)
if(b[k]>0){if(!(k<f))return A.a(e,k)
B.c.C(a0,e[k])}}if(a0.length<2)return a5
for(p=0;p<a6;++p){s=q[p]
if(!(s>=0&&s<j))return A.a(a,s)
q[p]=a[s]}B.c.dA(r)
B.c.cw(r,a0)
a1=A.f2(g)
for(d=0;d<a6;++d)a7[d].cR(a1)
for(s=r.length,a2=0,d=0;j=r.length,d<j;r.length===s||(0,A.K)(r),++d)a2+=r[d].gcm()
a3=new Uint32Array(j)
for(d=0;d<a6;++d){k=q[d]
if(!(k>=0&&k<j))return A.a(a3,k)
a3[k]=a3[k]+1}for(a4=0,d=0;d<j;++d){n=a3[d]
if(n>0)a4-=n*(Math.log(n/a6)/0.6931471805599453)}a2+=a4+160
return a2<a1.gcm()?new A.k5(q,r.length,a2):a5},
l6:function l6(){},
f1:function f1(a,b,c,d,e,f,g,h,i,j,k){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=$
_.w=g
_.x=h
_.y=i
_.z=!1
_.Q=j
_.as=k},
k5:function k5(a,b,c){this.a=a
this.b=b
this.c=c},
iz(a){var s,r
if(a<=4)return 255+a
s=a-1
r=A.l5(s)
return 256+2*r+(B.a.aL(s,r-1)&1)},
oC(a){var s,r
if(a<=4)return B.cv
s=a-1
r=A.l5(s)-1
return new A.cP(r,s-B.a.V(2+(B.a.aL(s,r)&1),r))},
iv(a,b){var s,r=B.a.au(b,a),q=b-r*a
if(q<=8&&r<8){s=r*16+8-q
if(!(s>=0&&s<128))return A.a(B.ak,s)
return B.ak[s]+1}else if(q>a-8&&r<7){s=(r+1)*16+8+a-q
if(!(s>=0&&s<128))return A.a(B.ak,s)
return B.ak[s]+1}return b+120},
iB(a){var s,r=a-1
if(r<4)return r
s=A.l5(r)
return 2*s+(B.a.aL(r,s-1)&1)},
oF(a){var s,r=a-1
if(r<4)return B.cv
s=A.l5(r)-1
return new A.cP(s,r-B.a.V(2+(B.a.aL(r,s)&1),s))},
l5(a){var s
for(s=0;a>1;){a=B.a.j(a,1);++s}return s},
dQ(a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=t.p,a2=A.E(a6,0,!1,a1),a3=t.t,a4=A.j([],a3)
for(s=0;s<a6;++s){if(!(s<a5.length))return A.a(a5,s)
if(a5[s]>0)B.c.C(a4,s)}r=a4.length
if(r===0){B.c.h(a2,0,1)
return a2}if(r===1){if(0>=r)return A.a(a4,0)
B.c.h(a2,a4[0],1)
return a2}q=2*r
p=A.E(q,0,!1,a1)
o=A.E(q,-1,!1,a1)
n=A.E(q,-1,!1,a1)
for(m=1;;m*=2){for(s=0;l=a4.length,s<l;++s){a1=a4[s]
if(!(a1<a5.length))return A.a(a5,a1)
B.c.h(p,s,a5[a1])
if(!(s<q))return A.a(p,s)
if(p[s]<m)B.c.h(p,s,m)}a1=A.j(new Array(l),a3)
for(s=0;s<l;++s)a1[s]=s
B.c.ew(a1,new A.lc(p))
for(r=A.am(a1).c,k=a1.$flags|0;a1.length>1;l=h){j=B.c.dE(a1,0)
i=B.c.dE(a1,0)
h=l+1
if(!(j<q))return A.a(p,j)
g=p[j]
if(!(i<q))return A.a(p,i)
B.c.h(p,l,g+p[i])
B.c.h(o,l,j)
B.c.h(n,l,i)
g=a1.length
f=0
for(;;){if(f<g){e=a1[f]
if(!(e<q))return A.a(p,e)
e=p[e]
if(!(l<q))return A.a(p,l)
e=e<=p[l]}else e=!1
if(!e)break;++f}r.a(l)
k&1&&A.b(a1,"insert",2)
if(f>g)A.ax(A.mi(f,null))
a1.splice(f,0,l)}d=A.j([a1[0]],a3)
c=A.j([0],a3)
for(b=0;a1=d.length,a1!==0;){if(0>=a1)return A.a(d,-1)
a=d.pop()
if(0>=c.length)return A.a(c,-1)
a0=c.pop()
if(!(a>=0&&a<q))return A.a(o,a)
a1=o[a]
if(a1===-1){if(!(a<a4.length))return A.a(a4,a)
B.c.h(a2,a4[a],a0)
if(a0>b)b=a0}else{B.c.C(d,a1)
if(!(a<q))return A.a(n,a)
B.c.C(d,n[a])
a1=a0+1
B.c.C(c,a1)
B.c.C(c,a1)}}if(b<=a7)break}return a2},
fx(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=A.j([],t.t)
for(s=c.length,r=0;r<b;++r){if(!(r<s))return A.a(c,r)
if(c[r]>0)B.c.C(e,r)}s=e.length
if(s<=2)s=s===0||B.c.geg(e)<=255
else s=!1
if(s){a.T(1,1)
s=e.length
if(s===0){a.T(0,1)
a.T(0,1)
a.T(0,1)
return}a.T(s-1,1)
if(0>=e.length)return A.a(e,0)
q=e[0]
if(q<=1){a.T(0,1)
a.T(q,1)}else{a.T(1,1)
a.T(q,8)}s=e.length
if(s===2){if(1>=s)return A.a(e,1)
a.T(e[1],8)}else B.c.h(c,q,0)
return}p=A.t_(c,b)
o=A.E(19,0,!1,t.p)
for(s=p.length,n=0;n<p.length;p.length===s||(0,A.K)(p),++n){m=p[n].a
if(!(m>=0&&m<19))return A.a(o,m)
B.c.h(o,m,o[m]+1)}l=A.dQ(o,19,7)
k=A.dR(new Int32Array(A.q(l)),19)
s=l.length
r=18
for(;;){if(!(r>=4)){j=4
break}m=B.an[r]
if(!(m<s))return A.a(l,m)
if(l[m]!==0){j=r+1
break}--r}a.T(0,1)
a.T(j-4,4)
for(r=0;r<j;++r){m=B.an[r]
if(!(m<s))return A.a(l,m)
a.T(l[m],3)}a.T(0,1)
for(m=p.length,i=k.length,n=0;n<p.length;p.length===m||(0,A.K)(p),++n){h=p[n]
g=h.a
if(!(g>=0&&g<i))return A.a(k,g)
f=k[g]
if(!(g<s))return A.a(l,g)
a.T(f,l[g])
g=h.b
if(g>0)a.T(h.c,g)}s=e.length
if(s===1){if(0>=s)return A.a(e,0)
B.c.h(c,e[0],0)}},
t_(a,b){var s,r,q,p,o,n,m,l,k,j=A.j([],t.cF)
for(s=a.length,r=0;r<b;){if(!(r>=0&&r<s))return A.a(a,r)
q=a[r]
if(q===0){p=0
for(;;){o=r+p
if(o<b){if(!(o<s))return A.a(a,o)
n=a[o]===0}else n=!1
if(!n)break;++p}for(m=p;m>0;)if(m>=11){l=B.a.G(m,11,138)
B.c.C(j,new A.bP(18,7,l-11))
m-=l}else if(m>=3){l=B.a.G(m,3,10)
B.c.C(j,new A.bP(17,3,l-3))
m-=l}else{B.c.C(j,new A.bP(0,0,0));--m}r=o}else{B.c.C(j,new A.bP(q,0,0));++r
for(;;){if(r<b){if(!(r>=0&&r<s))return A.a(a,r)
n=a[r]===q}else n=!1
if(!n)break
p=0
for(;;){o=r+p
if(o<b){if(!(o>=0&&o<s))return A.a(a,o)
n=a[o]===q&&p<6}else n=!1
if(!n)break;++p}if(p>=3)B.c.C(j,new A.bP(16,2,p-3))
else for(k=0;k<p;++k)B.c.C(j,new A.bP(q,0,0))
r=o}}}return j},
dR(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=t.p,g=A.E(b,0,!1,h)
for(s=a.length,r=0,q=0;q<b;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if(p>r)r=p}if(r===0)return g
o=r+1
n=A.E(o,0,!1,h)
for(q=0;q<b;++q){if(!(q<s))return A.a(a,q)
m=a[q]
if(m>0){if(!(m<o))return A.a(n,m)
B.c.h(n,m,n[m]+1)}}B.c.h(n,0,0)
l=A.E(o,0,!1,h)
for(k=0,j=1;j<=r;++j){h=j-1
if(!(h<o))return A.a(n,h)
k=k+n[h]<<1>>>0
B.c.h(l,j,k)}for(q=0;q<b;++q){if(!(q<s))return A.a(a,q)
i=a[q]
if(i>0){if(!(i<o))return A.a(l,i)
B.c.h(g,q,A.tB(l[i],i))
B.c.h(l,i,l[i]+1)}}return g},
tB(a,b){var s,r
for(s=0,r=0;r<b;++r){s=(s<<1|a&1)>>>0
a=a>>>1}return s},
lc:function lc(a){this.a=a},
bP:function bP(a,b,c){this.a=a
this.b=b
this.c=c},
bN(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
cJ(a){if(a<0)return 0
if(a>255)return 255
return a},
kc(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
qZ(a,b,c){return 4278190080},
r_(a,b,c){return a},
r4(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return b[c]},
r5(a,b,c){var s=c+1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
r6(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
r7(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bN(A.bN(a,b[r]),s)},
r8(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return A.bN(a,b[s])},
r9(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return A.bN(a,b[c])},
ra(a,b,c){var s=c-1,r=b.length
if(!(s>=0&&s<r))return A.a(b,s)
s=b[s]
if(!(c>=0&&c<r))return A.a(b,c)
return A.bN(s,b[c])},
rb(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bN(s,b[r])},
r0(a,b,c){var s,r,q=c-1,p=b.length
if(!(q>=0&&q<p))return A.a(b,q)
q=b[q]
if(!(c>=0&&c<p))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<p))return A.a(b,r)
r=b[r]
return A.bN(A.bN(a,q),A.bN(s,r))},
r1(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return A.kc(s>>>24,a>>>24,r>>>24)+A.kc(s>>>16&255,a>>>16&255,r>>>16&255)+A.kc(s>>>8&255,a>>>8&255,r>>>8&255)+A.kc(s&255,a&255,r&255)<=0?s:a},
r2(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return(A.cJ((a>>>24)+(s>>>24)-(r>>>24))<<24|A.cJ((a>>>16&255)+(s>>>16&255)-(r>>>16&255))<<16|A.cJ((a>>>8&255)+(s>>>8&255)-(r>>>8&255))<<8|A.cJ((a&255)+(s&255)-(r&255)))>>>0},
r3(a,b,c){var s,r,q,p,o,n=b.length
if(!(c>=0&&c<n))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<n))return A.a(b,r)
r=b[r]
q=A.bN(a,s)
s=q>>>24
n=q>>>16&255
p=q>>>8&255
o=q>>>0&255
return(A.cJ(s+B.a.W(s-(r>>>24),2))<<24|A.cJ(n+B.a.W(n-(r>>>16&255),2))<<16|A.cJ(p+B.a.W(p-(r>>>8&255),2))<<8|A.cJ(o+B.a.W(o-(r&255),2)))>>>0},
cI:function cI(a,b){this.a=a
this.b=b},
i7:function i7(a){var _=this
_.a=a
_.c=_.b=0
_.d=null
_.e=0},
kh:function kh(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0
_.r=1
_.w=!1
_.x=$
_.y=!1},
mP(a){var s,r=a.length,q=new Uint8Array(r)
for(s=0;s<r;++s){if(!(s<r))return A.a(q,s)
q[s]=a.charCodeAt(s)}return q},
tS(a,b,c,d,e,f,g,h){var s,r,q=A.Y(!1,8192)
A.dO(q,g>>>1)
A.dO(q,h>>>1)
A.dO(q,f-1)
A.dO(q,e-1)
A.dO(q,B.a.G(c,0,16777215))
q.m(3)
for(s=d.length,r=0;r<d.length;d.length===s||(0,A.K)(d),++r)d[r].hI(q)
return J.B(B.d.gB(q.c),0,q.a)},
ot(a){var s,r,q,p,o,n
for(s=a.length,r=4,q=0;q<s;++q){p=a[q].b.length
o=(p&1)===1?1:0
r+=8+p+o}n=A.Y(!1,8192)
n.a5(A.mP("RIFF"))
n.J(r)
n.a5(A.mP("WEBP"))
for(s=a.length,q=0;q<a.length;a.length===s||(0,A.K)(a),++q)a[q].hI(n)
return J.B(B.d.gB(n.c),0,n.a)},
dO(a,b){a.m(b&255)
a.m(B.a.j(b,8)&255)
a.m(B.a.j(b,16)&255)},
bO:function bO(a,b){this.a=a
this.b=b},
f6:function f6(){},
hj:function hj(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=$
_.w=1
_.y=_.x=$},
lT(a){var s,r=J.cn(a,t.a6)
for(s=0;s<a;++s)r[s]=new A.fV()
return new A.e8(r,0)},
pI(){var s,r,q=J.a8(5,t.lJ)
for(s=0;s<5;++s)q[s]=A.lT(0)
r=J.a8(64,t.lq)
for(s=0;s<64;++s)r[s]=new A.fW()
return new A.e7(q,r)},
fV:function fV(){this.b=this.a=0},
fW:function fW(){this.b=this.a=0},
e8:function e8(a,b){this.a=a
this.b=b},
e7:function e7(a,b){var _=this
_.a=a
_.b=!1
_.c=0
_.e=_.d=!1
_.f=b},
e9:function e9(){var _=this
_.b=_.a=null
_.e=_.d=0},
fY:function fY(a){this.a=a
this.b=null},
dE:function dE(a,b){this.a=a
this.b=b},
dF:function dF(a,b){var _=this
_.b=_.a=0
_.c=null
_.e=_.d=!1
_.f=a
_.r=null
_.w=""
_.y=0
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
ei:function ei(a,b){var _=this
_.b=_.a=0
_.c=null
_.e=_.d=!1
_.f=a
_.r=null
_.w=""
_.y=0
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
ki:function ki(){this.b=this.a=null},
re(a){var s,r,q,p,o,n,m,l,k,j=null,i=t.g,h=0
for(;;){s=a.x
if(s===$){s=a.x=A.j([],i)
r=s}else r=s
if(!(h<s.length))break
if(!(h<r.length))return A.a(r,h)
q=r[h]
p=q.a
o=p==null
n=o?j:p.a
if(n==null)n=0
m=a.a
l=m==null
k=l?j:m.a
if(n<=(k==null?0:k)){p=o?j:p.b
if(p==null)p=0
o=l?j:m.b
p=p>(o==null?0:o)}else p=!0
if(p)throw A.h(A.n("WebP animation frames must fit the "+a.gS()+"x"+a.gK()+" canvas, but frame "+h+" is "+q.gS()+"x"+q.gK()+"."));++h}},
kk(a,b){var s
if(a==null)return 0
s=b.$1(a)
return B.a.G(B.b.av(s),0,255)},
rh(a){var s=a.c
if(s==null)return null
return s.b===B.S?s.c:A.lU(s).hi()},
rg(a){var s,r,q,p,o,n
for(s=a.gab(),r=s.length,q=0;q<s.length;s.length===r||(0,A.K)(s),++q){p=s[q]
if(!(p.gal()===2||p.gal()===4))continue
for(o=p.a,o=o.gH(o);o.E();){n=o.gN()
if(n.gv()!==n.gF())return!0}}return!1},
rf(a){var s
if(a.gbp().gee(0))return null
s=A.Y(!1,8192)
a.gbp().aV(s)
return J.B(B.d.gB(s.c),0,s.a)},
kj:function kj(){},
kl:function kl(){},
km:function km(){},
kn:function kn(){},
ko:function ko(){},
lU(a){return new A.bB(a.a,a.b,B.d.hY(a.c,0))},
fZ:function fZ(a,b){this.a=a
this.b=b},
bB:function bB(a,b,c){this.a=a
this.b=b
this.c=c},
Q(a,b,c,d,e,f,g,h,i,j,k,l,m){var s,r=new A.bl(null,null,null,a,h,e,d,0)
B.c.C(r.gab(),r)
r.c=g
if(b!=null)r.e=A.dZ(b)
s=!1
if(j==null)if(m)s=r.gM()===B.A||r.gM()===B.u||r.gM()===B.B||r.gM()===B.e||r.gM()===B.n
r.eY(l,f,c,i,s?r.iN(c,k,i):j)
return r},
h3(a,b,c,d){var s,r,q,p,o=null,n=a.e
n=n==null?o:A.dZ(n)
s=a.c
s=s==null?o:A.lU(s)
r=a.w
q=a.r
p=a.f
p=p==null?o:new A.b3(new Uint8Array(A.q(p.a)))
r=new A.bl(o,s,n,p,q,r,a.y,a.z)
r.ih(a,b,c,d)
return r},
bF(a,b,c){var s,r,q,p,o,n=null,m=a.a
m=m==null?n:m.bn(c)
s=a.e
s=s==null?n:A.dZ(s)
r=a.c
r=r==null?n:A.lU(r)
q=a.w
p=a.r
o=a.f
o=o==null?n:new A.b3(new Uint8Array(A.q(o.a)))
q=new A.bl(m,r,s,o,p,q,a.y,a.z)
q.ig(a,b,c)
return q},
fU:function fU(a,b){this.a=a
this.b=b},
bl:function bl(a,b,c,d,e,f,g,h){var _=this
_.a=a
_.b=null
_.c=b
_.d=null
_.e=c
_.f=d
_.r=e
_.w=f
_.x=$
_.y=g
_.z=h},
j8:function j8(a,b){this.a=a
this.b=b},
j7:function j7(){},
ah:function ah(){},
pK(a,b,c){return new A.d9(new Uint16Array(a*b*c),a,b,c)},
d9:function d9(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
pL(a,b,c){return new A.da(new Float32Array(a*b*c),a,b,c)},
da:function da(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
eb:function eb(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
ec:function ec(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
ed:function ed(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
ee:function ee(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
db:function db(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
dc:function dc(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
dd:function dd(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
pM(a,b,c){return new A.de(new Uint32Array(a*b*c),a,b,c)},
de:function de(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
df:function df(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
np(a,b,c){return new A.dg(new Uint8Array(a*b*c),null,a,b,c)},
dg:function dg(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
hk:function hk(a,b){this.a=a
this.b=b},
aV:function aV(){},
eB:function eB(a,b,c){this.c=a
this.a=b
this.b=c},
eC:function eC(a,b,c){this.c=a
this.a=b
this.b=c},
eD:function eD(a,b,c){this.c=a
this.a=b
this.b=c},
eE:function eE(a,b,c){this.c=a
this.a=b
this.b=c},
eF:function eF(a,b,c){this.c=a
this.a=b
this.b=c},
eG:function eG(a,b,c){this.c=a
this.a=b
this.b=c},
eH:function eH(a,b,c){this.c=a
this.a=b
this.b=c},
dp:function dp(a,b,c){this.c=a
this.a=b
this.b=c},
nC(a){return new A.aN(new Uint8Array(A.q(a.c)),a.a,a.b)},
aN:function aN(a,b,c){this.c=a
this.a=b
this.b=c},
m2(a){return new A.ct(-1,0,-a.c,a)},
ct:function ct(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m3(a){return new A.cu(-1,0,-a.c,a)},
cu:function cu(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m4(a){return new A.cv(-1,0,-a.c,a)},
cv:function cv(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m5(a){return new A.cw(-1,0,-a.c,a)},
cw:function cw(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m6(a){return new A.cx(-1,0,-a.c,a)},
cx:function cx(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m7(a){return new A.cy(-1,0,-a.c,a)},
cy:function cy(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ba(a,b,c,d,e){a.a6(b-1,c)
return new A.hB(a,b,b+d-1,c+e-1)},
hB:function hB(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
eI(a){return new A.cz(-1,0,0,-1,0,a)},
cz:function cz(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
m8(a){return new A.cA(-1,0,-a.c,a)},
cA:function cA(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
eJ(a){return new A.cB(-1,0,0,-2,0,a)},
cB:function cB(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
m9(a){return new A.cC(-1,0,-a.c,a)},
cC:function cC(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
eK(a){return new A.cD(-1,0,0,-(a.c<<2>>>0),a)},
cD:function cD(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jz(a){return new A.cE(-1,0,-a.c,a)},
cE:function cE(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
F:function F(){},
ud(a,b){switch(b.a){case 0:A.ix(a)
break
case 1:A.uf(a)
break
case 2:A.ue(a)
break}return a},
uf(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,c=a.gab().length
for(s=t.g,r=0;r<c;++r){q=a.x
if(q===$)q=a.x=A.j([],s)
if(!(r<q.length))return A.a(q,r)
p=q[r]
o=p.a
n=o==null
m=n?d:o.a
if(m==null)m=0
l=n?d:o.b
if(l==null)l=0
k=B.a.W(l,2)
o=a.a
if((o==null?d:o.gO())!=null)for(j=l-1,i=0;i<k;++i,--j)for(h=0;h<m;++h){o=p.a
g=o==null?d:o.P(h,i,d)
if(g==null)g=new A.F()
o=p.a
f=o==null?d:o.P(h,j,d)
if(f==null)f=new A.F()
e=g.gU()
g.sU(f.gU())
f.sU(e)}else for(j=l-1,i=0;i<k;++i,--j)for(h=0;h<m;++h){o=p.a
g=o==null?d:o.P(h,i,d)
if(g==null)g=new A.F()
o=p.a
f=o==null?d:o.P(h,j,d)
if(f==null)f=new A.F()
e=g.gn()
g.sn(f.gn())
f.sn(e)
e=g.gt()
g.st(f.gt())
f.st(e)
e=g.gu()
g.su(f.gu())
f.su(e)
e=g.gv()
g.sv(f.gv())
f.sv(e)}}return a},
ix(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null,b=a.gab().length
for(s=t.g,r=0;r<b;++r){q=a.x
if(q===$)q=a.x=A.j([],s)
if(!(r<q.length))return A.a(q,r)
p=q[r]
o=p.a
n=o==null
m=n?c:o.a
if(m==null)m=0
l=n?c:o.b
if(l==null)l=0
k=B.a.W(m,2)
o=a.a
if((o==null?c:o.gO())!=null)for(j=m-1,i=0;i<l;++i)for(h=j,g=0;g<k;++g,--h){o=p.a
f=o==null?c:o.P(g,i,c)
if(f==null)f=new A.F()
o=p.a
e=o==null?c:o.P(h,i,c)
if(e==null)e=new A.F()
d=f.gU()
f.sU(e.gU())
e.sU(d)}else for(j=m-1,i=0;i<l;++i)for(h=j,g=0;g<k;++g,--h){o=p.a
f=o==null?c:o.P(g,i,c)
if(f==null)f=new A.F()
o=p.a
e=o==null?c:o.P(h,i,c)
if(e==null)e=new A.F()
d=f.gn()
f.sn(e.gn())
e.sn(d)
d=f.gt()
f.st(e.gt())
e.st(d)
d=f.gu()
f.su(e.gu())
e.su(d)
d=f.gv()
f.sv(e.gv())
e.sv(d)}}return a},
ue(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null,a=a0.gab().length
for(s=t.g,r=0;r<a;++r){q=a0.x
if(q===$)q=a0.x=A.j([],s)
if(!(r<q.length))return A.a(q,r)
p=q[r]
o=p.a
n=o==null
m=n?b:o.a
if(m==null)m=0
l=n?b:o.b
if(l==null)l=0
k=B.a.W(l,2)
if((n?b:o.gO())!=null)for(j=l-1,i=m-1,h=0;h<k;++h,--j)for(g=i,f=0;f<m;++f,--g){o=p.a
e=o==null?b:o.P(f,h,b)
if(e==null)e=new A.F()
o=p.a
d=o==null?b:o.P(g,j,b)
if(d==null)d=new A.F()
c=e.gU()
e.sU(d.gU())
d.sU(c)}else for(j=l-1,i=m-1,h=0;h<k;++h,--j)for(g=i,f=0;f<m;++f,--g){o=p.a
e=o==null?b:o.P(f,h,b)
if(e==null)e=new A.F()
o=p.a
d=o==null?b:o.P(g,j,b)
if(d==null)d=new A.F()
c=e.gn()
e.sn(d.gn())
d.sn(c)
c=e.gt()
e.st(d.gt())
d.st(c)
c=e.gu()
e.su(d.gu())
d.su(c)
c=e.gv()
e.sv(d.gv())
d.sv(c)}}return a0},
iV:function iV(a,b){this.a=a
this.b=b},
n(a){return new A.j6(a)},
j6:function j6(a){this.a=a},
w(a,b,c,d){var s=J.ab(a),r=s.gA(a)
s=c==null?s.gA(a):d+c
return new A.ad(a,d,Math.min(r,s),d,b)},
p(a,b,c){var s=a.a,r=a.d,q=a.b,p=J.bv(s),o=b==null?a.c:a.d+c+b
return new A.ad(s,q,Math.min(p,o),r+c,a.e)},
ad:function ad(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
m1(a,b,c){var s=new A.hx(c,new Int32Array(256))
s.jP(b)
s.kX(a)
return s},
hx:function hx(a,b){var _=this
_.a=$
_.b=a
_.c=16
_.d=3
_.f=_.e=$
_.r=null
_.Q=_.z=_.y=_.x=_.w=$
_.as=b
_.ax=_.at=$},
Y(a,b){return new A.hz(a,new Uint8Array(b))},
hz:function hz(a,b){this.a=0
this.b=a
this.c=b},
jL:function jL(a,b){this.a=a
this.b=b},
hT:function hT(){},
aX:function aX(a,b){this.a=a
this.b=b},
ht:function ht(a,b){this.a=a
this.b=b},
jq:function jq(a){this.c=a},
jr:function jr(){},
eo:function eo(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
pY(a){var s=null,r=A.ow(a)
if(r==null)return s
return new A.hu(a,r.gS(),r.gK(),A.n_(r,4,3).a,s,s,s)},
pZ(a){var s,r,q,p,o,n,m=null,l=A.ow(a.a),k=l.gK()>l.gS()?a.b:m,j=A.u4(l,k,l.gS()>=l.gK()?a.b:m)
k=a.c
s=A.u9(k,j)
if(s==null)return m
r=new Uint8Array(A.q(s))
q=j.gS()
p=j.gK()
o=l.gK()
n=l.gS()
k=$.p7().lw(k,m)
return new A.hu(r,q,p,a.d?A.n_(j,4,3).a:m,k,o,n)},
hu:function hu(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
ju:function ju(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
kp:function kp(a,b,c){this.a=a
this.b=b
this.c=c},
f7:function f7(a,b){this.a=a
this.b=b},
mM(){var s=0,r=A.tu(t.x),q,p,o
var $async$mM=A.tQ(function(a,b){if(a===1)return A.rV(b,r)
for(;;)switch(s){case 0:$.lD().h3(new A.eo("[native implementations worker]: Starting...",null,$.mR().$1(null),B.dy))
q=A.br(v.G.self)
p=new A.lC()
if(typeof p=="function")A.ax(A.b2("Attempting to rewrap a JS function.",null))
o=function(c,d){return function(e){return c(d,e,arguments.length)}}(A.t0,p)
o[$.mQ()]=p
q.onmessage=o
return A.rW(null,r)}})
return A.rX($async$mM,r)},
op(a,b){var s,r,q
try{A.br(v.G.self).postMessage(A.mJ(A.lZ(["label",a,"data",b],t.N,t.z)))}catch(q){s=A.cc(q)
r=A.bU(q)
$.lD().hl(u.g+A.z(s)+", "+A.z(r))}},
tA(a,b,c){var s,r,q,p
a=a
if(a!=null)try{s=A.mJ(a)
if(s!=null)a=s}catch(p){a=J.dU(a)}try{A.br(v.G.self).postMessage(A.mJ(A.lZ(["label","stacktrace","origin",c,"error",a,"stacktrace",b.D(0)],t.N,t.X)))}catch(p){r=A.cc(p)
q=A.bU(p)
$.lD().hl(u.g+A.z(r)+", "+A.z(q))}},
lC:function lC(){},
q_(a){var s=B.m.lu(a,".")
if(s<0||s+1>=a.length)return a
return B.m.ez(a,s+1).toLowerCase()},
jv:function jv(a,b){this.a=a
this.b=b},
qu(a){throw A.h(A.bq("Uint64List not supported on the web."))},
pN(a,b,c){return J.lJ(a,b,c)},
qv(a,b,c){var s=a.BYTES_PER_ELEMENT
c=A.bn(b,c,B.a.au(a.byteLength,s))
return J.B(B.d.gB(a),a.byteOffset+b*s,(c-b)*s)},
nO(a,b){return J.Z(a,b,null)},
pE(a){return J.mW(a,0,null)},
pF(a){return a.m2(0,0,null)},
oI(a){return v.mangledGlobalNames[a]},
oD(a,b,c){A.u_(c,t.q,"T","max")
return Math.max(c.a(a),c.a(b))},
ug(a){var s,r,q,p,o,n=a.gA(0)
for(s=1,r=0;n>0;){q=3800>n?n:3800
n-=q
while(--q,q>=0){p=a.b
p.toString
o=a.c++
if(!(o>=0&&o<p.length))return A.a(p,o)
s+=p[o]
r+=s}s=B.a.a8(s,65521)
r=B.a.a8(r,65521)}return(r<<16|s)>>>0},
bt(a,b){var s,r,q=J.ab(a),p=q.gA(a)
b^=4294967295
for(s=0;p>=8;){r=s+1
b=B.G[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.G[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.G[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.G[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.G[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.G[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.G[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.G[(b^q.l(a,r))&255]^b>>>8
p-=8}if(p>0)do{r=s+1
b=B.G[(b^q.l(a,s))&255]^b>>>8
if(--p,p>0){s=r
continue}else break}while(!0)
return(b^4294967295)>>>0},
iw(a,b){var s,r,q,p=B.l2.gc7()
p=A.u(p,A.l(p).p("e.E"))
for(s=1,r="";s<=b;++s,r=q){q=B.b.i(B.b.a8(a/Math.pow(83,b-s),83))
if(q>=0&&q<p.length){if(!(q>=0&&q<p.length))return A.a(p,q)
q=p[q]}else q=null
q=r+A.z(q)}return r.charCodeAt(0)==0?r:r},
mF(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n,m,l
if(j==null)j=0
if(k==null)k=0
if(i==null)i=b.gS()
if(h==null)h=b.gK()
if(e==null)e=a.gS()<b.gS()?a.gS():b.gS()
if(d==null)d=a.gK()<b.gK()?a.gK():b.gK()
s=c===B.ab
if(!s&&a.gaP())a=a.ec(a.gal())
r=h/d
q=i/e
p=t.p
o=J.a8(d,p)
for(n=0;n<d;++n)o[n]=k+B.b.i(n*r)
m=J.a8(e,p)
for(l=0;l<e;++l)m[l]=j+B.b.i(l*q)
if(s)A.t3(b,a,f,g,e,d,m,o,null,B.b9)
else A.t1(b,a,f,g,e,d,m,o,c,!1,null,B.b9)
return a},
t3(a,b,c,d,e,f,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h=b.gS(),g=b.gK()
for(s=a0.length,r=a1.length,q=null,p=0;p<f;++p)for(o=d+p,n=o>=g,m=0;m<e;++m){l=c+m
if(l>=h||n)continue
if(!(m<s))return A.a(a0,m)
k=a0[m]
if(!(p<r))return A.a(a1,p)
j=a1[p]
i=a.a
q=i==null?null:i.P(k,j,q)
if(q==null)q=new A.F()
b.ca(l,o,q)}},
t1(a,b,c,d,e,f,g,h,i,j,a0,a1){var s,r,q,p,o,n,m,l,k
for(s=g.length,r=h.length,q=null,p=0;p<f;++p)for(o=d+p,n=0;n<e;++n){if(!(n<s))return A.a(g,n)
m=g[n]
if(!(p<r))return A.a(h,p)
l=h[p]
k=a.a
q=k==null?null:k.P(m,l,q)
if(q==null)q=new A.F()
A.u8(b,c+n,o,q,i,!1,a0,a1)}},
u8(a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7
if(!a8.hr(a9,b0))return a8
if(b2===B.ab||a8.gaP())if(a8.hr(a9,b0)){a8.aR(a9,b0).aj(b1)
return a8}s=b1.gai()
r=b1.gae()
q=b1.gah()
p=b1.gA(b1)<4?1:b1.ga_()
if(p===0)return a8
o=a8.aR(a9,b0)
n=o.gai()
m=o.gae()
l=o.gah()
k=o.ga_()
switch(b2.a){case 0:return a8
case 1:break
case 2:s=Math.max(n,s)
r=Math.max(m,r)
q=Math.max(l,q)
break
case 3:s=1-(1-s)*(1-n)
r=1-(1-r)*(1-m)
q=1-(1-q)*(1-l)
break
case 4:j=p*k
i=1-k
h=1-p
g=s*i+n*h
f=r*i+m*h
e=q*i+l*h
h=B.b.G(p,0.01,1)
i=p<0
d=i?0:1
c=B.b.G(s/h*d,0,0.99)
d=B.b.G(p,0.01,1)
h=i?0:1
b=B.b.G(r/d*h,0,0.99)
h=B.b.G(p,0.01,1)
i=i?0:1
a=B.b.G(q/h*i,0,0.99)
i=n*p
h=m*p
d=l*p
a0=j<s*k+i?0:1
a1=j<r*k+h?0:1
a2=j<q*k+d?0:1
s=(j+g)*(1-a0)+(i/(1-c)+g)*a0
r=(j+f)*(1-a1)+(h/(1-b)+f)*a1
q=(j+e)*(1-a2)+(d/(1-a)+e)*a2
break
case 5:s=n+s
r=m+r
q=l+q
break
case 6:s=Math.min(n,s)
r=Math.min(m,r)
q=Math.min(l,q)
break
case 7:s=n*s
r=m*r
q=l*q
break
case 8:s=s!==0?1-(1-n)/s:0
r=r!==0?1-(1-m)/r:0
q=q!==0?1-(1-l)/q:0
break
case 9:i=1-k
h=1-p
d=s*i
a3=n*h
s=2*n<k?2*s*n+d+a3:p*k-2*(k-n)*(p-s)+d+a3
d=r*i
a3=m*h
r=2*m<k?2*r*m+d+a3:p*k-2*(k-m)*(p-r)+d+a3
i=q*i
h=l*h
q=2*l<k?2*q*l+i+h:p*k-2*(k-l)*(p-q)+i+h
break
case 10:i=k===0
if(i)s=0
else{h=n/k
s=n*(p*h+2*s*(1-h))+s*(1-k)+n*(1-p)}if(i)r=0
else{h=m/k
r=m*(p*h+2*r*(1-h))+r*(1-k)+m*(1-p)}if(i)q=0
else{i=l/k
q=l*(p*i+2*q*(1-i))+q*(1-k)+l*(1-p)}break
case 11:i=2*s
h=1-k
d=1-p
a3=s*h
a4=n*d
s=i<p?i*n+a3+a4:p*k-2*(k-n)*(p-s)+a3+a4
i=2*r
a3=r*h
a4=m*d
r=i<p?i*m+a3+a4:p*k-2*(k-m)*(p-r)+a3+a4
i=2*q
h=q*h
d=l*d
q=i<p?i*l+h+d:p*k-2*(k-l)*(p-q)+h+d
break
case 12:s=Math.abs(s-n)
r=Math.abs(r-m)
q=Math.abs(q-l)
break
case 13:s=n-s
r=m-r
q=l-q
break
case 14:s=s!==0?n/s:0
r=r!==0?m/r:0
q=q!==0?l/q:0
break}a5=1-p
a6=p+k*a5
a7=a6>0?1/a6:0
o.sai((s*p+n*k*a5)*a7)
o.sae((r*p+m*k*a5)*a7)
o.sah((q*p+l*k*a5)*a7)
o.sa_(a6)
return a8},
oz(a,b,c,d,e,f,g){var s,r=B.b.G(Math.min(d,e),0,a.gS()-1),q=B.b.G(Math.min(f,g),0,a.gK()-1),p=B.b.G(Math.max(d,e),0,a.gS()-1),o=B.b.G(Math.max(f,g),0,a.gK()-1),n=a.a.bg(0,r,q,p-r+1,o-q+1)
for(s=n.a;n.E();)s.aj(c)
return a},
pB(a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=b2<16384,a5=a8>b0?b0:a8
for(s=1;s<=a5;)s=s<<1>>>0
s=s>>>1
r=s>>>1
q=A.j([0,0],t.t)
for(p=a6.length,o=s,s=r;s>=1;o=s,s=r){n=a7+b1*(b0-o)
m=b1*s
l=b1*o
k=a9*s
j=a9*o
for(i=(a8&s)>>>0!==0,h=a9*(a8-o),g=a7;g<=n;g+=l){f=g+h
for(e=g;e<=f;e+=j){d=e+k
c=e+m
b=c+k
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.e0(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.e0(a,a6[b],q)
a2=q[0]
a3=q[1]
A.e0(a0,a2,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[e]=a
a6[d]=q[1]
A.e0(a1,a3,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[c]=a
a6[b]=q[1]}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.e1(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.e1(a,a6[b],q)
a2=q[0]
a3=q[1]
A.e1(a0,a2,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[e]=a
a6[d]=q[1]
A.e1(a1,a3,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[c]=a
a6[b]=q[1]}}if(i){c=e+m
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.e0(a,a6[c],q)
a0=q[0]
a=q[1]
a6.$flags&2&&A.b(a6)
a6[c]=a}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.e1(a,a6[c],q)
a0=q[0]
a=q[1]
a6.$flags&2&&A.b(a6)
a6[c]=a}a6.$flags&2&&A.b(a6)
if(!(e>=0&&e<p))return A.a(a6,e)
a6[e]=a0}}if((b0&s)>>>0!==0){f=g+h
for(e=g;e<=f;e+=j){d=e+k
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
i=a6[e]
if(!(d>=0&&d<p))return A.a(a6,d)
A.e0(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.b(a6)
a6[d]=i}else{if(!(e>=0&&e<p))return A.a(a6,e)
i=a6[e]
if(!(d>=0&&d<p))return A.a(a6,d)
A.e1(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.b(a6)
a6[d]=i}a6.$flags&2&&A.b(a6)
if(!(e>=0&&e<p))return A.a(a6,e)
a6[e]=a0}}r=s>>>1}},
e0(a,b,c){var s,r,q,p,o=$.ap()
o.$flags&2&&A.b(o)
o[0]=a
s=$.ay()
if(0>=s.length)return A.a(s,0)
r=s[0]
o[0]=b
q=s[0]
p=r+(q&1)+B.a.j(q,1)
B.c.h(c,0,p)
B.c.h(c,1,p-q)},
e1(a,b,c){var s=a-B.a.j(b,1)&65535
B.c.h(c,1,s)
B.c.h(c,0,b+s-32768&65535)},
uc(a){var s,r,q,p,o,n,m,l,k=null,j=a.toLowerCase()
if(B.m.bo(j,".jpg")||B.m.bo(j,".jpeg")){s=new Uint8Array(64)
r=new Uint8Array(64)
q=new Float32Array(64)
p=new Float32Array(64)
o=A.E(65535,k,!1,t.T)
n=t.I
m=A.E(65535,k,!1,n)
l=A.E(64,k,!1,n)
n=A.E(64,k,!1,n)
s=new A.jh(s,r,q,p,o,m,l,n,new Int32Array(2048))
s.e=s.dd(B.cf,B.ai)
s.f=s.dd(B.bO,B.ai)
r=t.nx
s.r=r.a(s.dd(B.bq,B.bB))
s.w=r.a(s.dd(B.bG,B.bX))
s.jL()
s.jO()
s.hT(100)
return s}if(B.m.bo(j,".png"))return A.qa()
if(B.m.bo(j,".tga"))return new A.jP()
if(B.m.bo(j,".gif"))return new A.iZ()
if(B.m.bo(j,".tif")||B.m.bo(j,".tiff"))return new A.jS()
if(B.m.bo(j,".bmp"))return new A.iK()
if(B.m.bo(j,".ico"))return new A.h0()
if(B.m.bo(j,".cur"))return new A.h0()
if(B.m.bo(j,".pvr"))return new A.jI()
if(B.m.bo(j,".webp"))return new A.kj()
return k},
ub(a){var s,r,q,p,o,n,m,l,k,j,i,h=null,g=new A.ho()
if(g.bB(a))return g
s=new A.hD(A.nr())
if(s.bB(a))return s
r=new A.iY()
r.f=A.w(a,!1,h,0)
r.a=new A.e6(A.j([],t.e))
if(r.fc())return r
q=new A.ki()
if(q.bB(a))return q
p=new A.jR()
if(p.fz(A.w(a,!1,h,0))!=null)return p
if(A.nJ(a).c===943870035)return new A.jD()
if(A.pA(a))return new A.iT()
o=new A.fD(!1)
if(o.bB(a))return o
n=new A.jA(A.j([],t.s))
if(n.bB(a))return n
m=new A.jO()
l=A.w(a,!1,h,0)
k=m.a=new A.eW(B.aA)
k.c9(l)
if(k.ht())return m
j=new A.j1()
k=A.w(a,!1,h,0)
j.a=k
k=A.nf(k)
j.b=k
if(k!=null)return j
i=new A.jH()
if(i.b7(a)!=null)return i
return h},
ow(a){var s=A.ub(a)
return s==null?null:s.b9(a,null)},
u9(a,b){var s=A.uc(a)
if(s==null)return null
return s.bI(b)},
ca(a,b){return(a&65535)*b+((a>>>16)*b&65535)*65536>>>0},
ux(c8,c9,d0,d1,d2,d3,d4,d5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4=d5.a,c5=d5.b,c6=d5.c,c7=d0.length
if(c7<c4||d1.length<c4||d2.length<c4||d3.length<c4||c8.a.length<c4||c8.b.length<c4)throw A.h(A.b2("optimalCover needs "+c4+" of every array",null))
s=c4+1
r=new Float64Array(s)
B.q.ac(r,1,s,1/0)
q=new Int32Array(s)
p=new Int32Array(s)
o=c9.glv()
n=c8.a
m=c8.b
l=c8.c
k=c8.d
j=A.j([],t.n)
for(i=k.length,h=0;g=k.length,h<g;k.length===i||(0,A.K)(k),++h)j.push(c9.hj(k[h],d4))
f=1+g
for(i=o.length,g=m.length,e=n.length,d=c9.a,c=d1.length,b=d.length,a=c9.b,a0=a.length,a1=c9.c,a2=d2.length,a3=a1.length,a4=c9.d,a5=d3.length,a6=a4.length,a7=0;a7<c4;a7=b4){a8=r[a7]
if(!(a7<c))return A.a(d1,a7)
a9=d1[a7]
if(!(a9<b))return A.a(d,a9)
a9=d[a9]
if(!(a7<c7))return A.a(d0,a7)
b0=d0[a7]
if(!(b0<a0))return A.a(a,b0)
b0=a[b0]
if(!(a7<a2))return A.a(d2,a7)
b1=d2[a7]
if(!(b1<a3))return A.a(a1,b1)
b1=a1[b1]
if(!(a7<a5))return A.a(d3,a7)
b2=d3[a7]
if(!(b2<a6))return A.a(a4,b2)
b3=a8+(a9+b0+b1+a4[b2])
b4=a7+1
if(b3<r[b4]){if(!(b4<s))return A.a(r,b4)
r[b4]=b3
if(!(b4<s))return A.a(q,b4)
q[b4]=1}for(b5=0;b5<f;++b5){if(b5===0){if(!(a7<e))return A.a(n,a7)
b6=n[a7]
if(b6<3)continue
if(!(a7<g))return A.a(m,a7)
b7=m[a7]
b8=a8+c9.hj(b7,d4)}else{a9=b5-1
if(!(a9>=0&&a9<l.length))return A.a(l,a9)
b0=l[a9]
if(!(a7<b0.length))return A.a(b0,a7)
b6=b0[a7]
if(b6<3)continue
if(!(a9<k.length))return A.a(k,a9)
b7=k[a9]
if(!(a9<j.length))return A.a(j,a9)
b8=a8+j[a9]}b9=b6<16?b6:16
for(c0=3;c0<=b9;++c0){if(!(c0<i))return A.a(o,c0)
c1=b8+o[c0]
a9=a7+c0
if(!(a9<s))return A.a(r,a9)
if(c1<r[a9]){if(!(a9<s))return A.a(r,a9)
r[a9]=c1
if(!(a9<s))return A.a(q,a9)
q[a9]=c0
if(!(a9<s))return A.a(p,a9)
p[a9]=b7}}if(b6>b9){if(!(b6<i))return A.a(o,b6)
c1=b8+o[b6]
a9=a7+b6
if(!(a9<s))return A.a(r,a9)
if(c1<r[a9]){if(!(a9<s))return A.a(r,a9)
r[a9]=c1
if(!(a9<s))return A.a(q,a9)
q[a9]=b6
if(!(a9<s))return A.a(p,a9)
p[a9]=b7}}}}for(c7=c5.$flags|0,j=c6.$flags|0,c2=c4;c2>0;c2=c3){if(!(c2<s))return A.a(q,c2)
c0=q[c2]
c3=c2-c0
c7&2&&A.b(c5)
if(!(c3>=0&&c3<c5.length))return A.a(c5,c3)
c5[c3]=c0
i=p[c2]
j&2&&A.b(c6)
if(!(c3<c6.length))return A.a(c6,c3)
c6[c3]=i}},
bQ(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
o8(a,b,c){var s,r,q,p,o=(a>>>24)+(b>>>24)-(c>>>24)
if(o<0)s=0
else s=o>255?255:o
o=(a>>>16&255)+(b>>>16&255)-(c>>>16&255)
if(o<0)r=0
else r=o>255?255:o
o=(a>>>8&255)+(b>>>8&255)-(c>>>8&255)
if(o<0)q=0
else q=o>255?255:o
o=(a&255)+(b&255)-(c&255)
if(o<0)p=0
else p=o>255?255:o
return(s<<24|r<<16|q<<8|p)>>>0},
o9(a,b,c){var s,r,q,p,o=A.bQ(a,b),n=o>>>24
n+=B.a.W(n-(c>>>24),2)
if(n<0)s=0
else s=n>255?255:n
n=o>>>16&255
n+=B.a.W(n-(c>>>16&255),2)
if(n<0)r=0
else r=n>255?255:n
n=o>>>8&255
n+=B.a.W(n-(c>>>8&255),2)
if(n<0)q=0
else q=n>255?255:n
n=o&255
n+=B.a.W(n-(c&255),2)
if(n<0)p=0
else p=n>255?255:n
return(s<<24|r<<16|q<<8|p)>>>0},
l8(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
oo(a,b,c){return A.l8(a>>>24,b>>>24,c>>>24)+A.l8(a>>>16&255,b>>>16&255,c>>>16&255)+A.l8(a>>>8&255,b>>>8&255,c>>>8&255)+A.l8(a&255,b&255,c&255)<=0?a:b},
uy(a,b,c,d,e){switch(a){case 0:return 4278190080
case 1:return b
case 2:return c
case 3:return e
case 4:return d
case 5:return A.bQ(A.bQ(b,e),c)
case 6:return A.bQ(b,d)
case 7:return A.bQ(b,c)
case 8:return A.bQ(d,c)
case 9:return A.bQ(c,e)
case 10:return A.bQ(A.bQ(b,d),A.bQ(c,e))
case 11:return A.oo(c,b,d)
case 12:return A.o8(b,c,d)
default:return A.o9(b,c,d)}},
uF(b5,b6,b7,b8,b9,c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2=A.E(b8*b9,11,!1,t.p),b3=new Int32Array(14),b4=new Uint32Array(14)
for(s=b5.length,r=0;r<b9;++r)for(q=r*b8,p=r*c0,o=p+c0,n=0;n<b8;++n){m=n*c0
l=B.a.G(m+c0,0,b6)
k=B.a.G(o,0,b7)
B.z.ac(b3,0,14,0)
j=p===0?1:p
i=m===0?1:m
for(h=j;h<k;++h){g=h*b6
for(f=i;f<l;++f){e=g+f
if(!(e>=0&&e<s))return A.a(b5,e)
d=b5[e]
c=e-1
if(!(c>=0))return A.a(b5,c)
c=b5[c]
b=e-b6
if(!(b>=0&&b<s))return A.a(b5,b)
a=b5[b]
a0=b-1
if(!(a0>=0))return A.a(b5,a0)
a0=b5[a0];++b
if(!(b<s))return A.a(b5,b)
b=b5[b]
a1=((c^a0)>>>1&2139062143)+((c&a0)>>>0)
a2=((a^b)>>>1&2139062143)+((a&b)>>>0)
b4[0]=4278190080
b4[1]=c
b4[2]=a
b4[3]=b
b4[4]=a0
b=((c^b)>>>1&2139062143)+((c&b)>>>0)
b4[5]=((b^a)>>>1&2139062143)+((b&a)>>>0)
b4[6]=a1
b4[7]=((c^a)>>>1&2139062143)+((c&a)>>>0)
b4[8]=((a0^a)>>>1&2139062143)+((a0&a)>>>0)
b4[9]=a2
b4[10]=((a1^a2)>>>1&2139062143)+((a1&a2)>>>0)
b4[11]=A.oo(a,c,a0)
b4[12]=A.o8(c,a,a0)
b4[13]=A.o9(c,a,a0)
for(c=d>>>8,b=d>>>16,a=d>>>24,a3=0;a3<14;++a3){a0=b3[a3]
a4=b4[a3]
a5=a-(a4>>>24)&255
a6=a5<128?a5:256-a5
a5=b-(a4>>>16)&255
a7=a5<128?a5:256-a5
a5=c-(a4>>>8)&255
a8=a5<128?a5:256-a5
a5=d-a4&255
a4=a5<128?a5:256-a5
if(!(a3<14))return A.a(b3,a3)
b3[a3]=a0+(a6+a7+a8+a4)}}}a9=b3[0]
for(b0=0,a3=1;a3<14;++a3){b1=b3[a3]
if(b1<a9){a9=b1
b0=a3}}B.c.h(b2,q+n,b0)}return b2},
tU(a1,a2,a3,a4,a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=B.a.gl_(a9)-1
for(s=a1.length,r=b0.length,q=a5.$flags|0,p=a2.$flags|0,o=a3.$flags|0,n=a4.$flags|0,m=0;m<a7;++m){l=m*a6
k=B.a.a2(m,a0)*a8
for(j=m===0,i=0;i<a6;++i){h=l+i
if(j)if(i===0)g=4278190080
else{f=h-1
if(!(f>=0&&f<s))return A.a(a1,f)
g=a1[f]}else{f=h-a6
if(i===0){if(!(f>=0&&f<s))return A.a(a1,f)
g=a1[f]}else{e=k+B.a.a2(i,a0)
if(!(e>=0&&e<r))return A.a(b0,e)
e=b0[e]
d=h-1
if(!(d>=0&&d<s))return A.a(a1,d)
d=a1[d]
if(!(f>=0&&f<s))return A.a(a1,f)
c=a1[f]
b=f-1
if(!(b>=0))return A.a(a1,b)
b=a1[b];++f
if(!(f<s))return A.a(a1,f)
g=A.uy(e,d,c,b,a1[f])}}if(!(h>=0&&h<s))return A.a(a1,h)
a=a1[h]
q&2&&A.b(a5)
if(!(h<a5.length))return A.a(a5,h)
a5[h]=(a>>>24)-(g>>>24)&255
p&2&&A.b(a2)
if(!(h<a2.length))return A.a(a2,h)
a2[h]=(a>>>16)-(g>>>16)&255
o&2&&A.b(a3)
if(!(h<a3.length))return A.a(a3,h)
a3[h]=(a>>>8)-(g>>>8)&255
n&2&&A.b(a4)
if(!(h<a4.length))return A.a(a4,h)
a4[h]=a-g&255}}},
vl(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=b*c,i=A.E(280,0,!1,t.p)
for(s=d.length,r=0;r<s;++r){q=d[r]
if(!(q<280))return A.a(i,q)
B.c.h(i,q,i[q]+1)}p=A.dQ(i,280,15)
o=A.dR(new Int32Array(A.q(p)),280)
a.T(0,1)
A.fx(a,280,p)
a.T(1,1)
a.T(0,1)
a.T(0,1)
a.T(0,1)
a.T(1,1)
a.T(0,1)
a.T(0,1)
a.T(0,1)
a.T(1,1)
a.T(0,1)
a.T(1,1)
a.T(255,8)
a.T(1,1)
a.T(0,1)
a.T(0,1)
a.T(0,1)
for(n=o.length,m=p.length,l=0;l<j;++l){if(!(l<s))return A.a(d,l)
q=d[l]
if(!(q<n))return A.a(o,q)
k=o[q]
if(!(q<m))return A.a(p,q)
a.T(k,p[q])}},
rm(a,b,c,d,e,f){A.rj(f,a,b,c,d,e,!0,f)},
rn(a,b,c,d,e,f){A.rk(f,a,b,c,d,e,!0,f)},
rl(a,b,c,d,e,f){A.ri(f,a,b,c,d,e,!0,f)},
dD(a,b,c,d,e){var s,r,q
if(e)for(s=0;s<d;++s){r=J.d(a.a,a.d+s)
q=J.d(b.a,b.d+s)
J.y(c.a,c.d+s,r+q)}else for(s=0;s<d;++s){r=J.d(a.a,a.d+s)
q=J.d(b.a,b.d+s)
J.y(c.a,c.d+s,r-q)}},
rj(a,b,c,d,e,f,g,h){var s,r,q=null,p=e*d,o=e+f,n=A.w(a,!1,q,p),m=A.w(h,!1,q,p),l=A.p(g?m:n,q,0)
if(e===0){m.h(0,0,J.d(n.a,n.d))
A.dD(A.p(n,q,1),l,A.p(m,q,1),b-1,g)
l.d+=d
n.d+=d
m.d+=d
e=1}for(s=-d,r=b-1;e<o;){A.dD(n,A.p(l,q,s),m,1,g)
A.dD(A.p(n,q,1),l,A.p(m,q,1),r,g);++e
l.d+=d
n.d+=d
m.d+=d}},
rk(a,b,c,d,e,f,g,h){var s=null,r=e*d,q=e+f,p=A.w(a,!1,s,r),o=A.w(h,!1,s,r),n=A.p(g?o:p,s,0)
if(e===0){o.h(0,0,J.d(p.a,p.d))
A.dD(A.p(p,s,1),n,A.p(o,s,1),b-1,g)
p.d+=d
o.d+=d
e=1}else n.d-=d
while(e<q){A.dD(p,n,o,b,g);++e
n.d+=d
p.d+=d
o.d+=d}},
ri(a,b,c,d,e,f,g,a0){var s,r,q,p,o,n,m=null,l=e*d,k=e+f,j=A.w(a,!1,m,l),i=A.w(a0,!1,m,l),h=A.p(g?i:j,m,0)
if(e===0){i.h(0,0,J.d(j.a,j.d))
A.dD(A.p(j,m,1),h,A.p(i,m,1),b-1,g)
h.d+=d
j.d+=d
i.d+=d
e=1}for(s=-d;e<k;){A.dD(j,A.p(h,m,s),i,1,g)
for(r=1;r<b;++r){q=r-d
p=J.d(h.a,h.d+(r-1))+J.d(h.a,h.d+q)-J.d(h.a,h.d+(q-1))
if((p&4294967040)>>>0===0)o=p
else o=p<0?0:255
q=J.d(j.a,j.d+r)
n=g?o:-o
J.y(i.a,i.d+r,q+n)}++e
h.d+=d
j.d+=d
i.d+=d}},
tY(a){var s="ifd0",r=A.bF(a,!1,!1)
if(!a.gbp().l(0,s).a.a9(274)||a.gbp().l(0,s).gcp()===1)return r
r.e=A.dZ(a.gbp())
r.gbp().l(0,s).scp(null)
switch(a.gbp().l(0,s).gcp()){case 2:return A.ix(r)
case 3:return A.ud(r,B.dp)
case 4:return A.ix(A.iu(r,180))
case 5:return A.ix(A.iu(r,90))
case 6:return A.iu(r,90)
case 7:return A.ix(A.iu(r,-90))
case 8:return A.iu(r,-90)}return r},
u4(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=null,a0=a3==null
if(a0&&a2==null)throw A.h(A.n("Invalid size"))
a1.gaP()
if(a1.gbp().l(0,"ifd0").a.a9(274)&&a1.gbp().l(0,"ifd0").gcp()!==1)a1=A.tY(a1)
if(a2==null||a2<=0){a3.toString
a2=B.b.av(a3*(a1.gK()/a1.gS()))}if(a0||a3<=0)a3=B.b.av(a2*(a1.gS()/a1.gK()))
if(a3===a1.gS()&&a2===a1.gK())return A.bF(a1,!1,!1)
s=new Int32Array(a3)
for(a0=a1.a,r=a0==null,q=0;q<a3;++q){p=r?a:a0.a
p=B.a.au(q*(p==null?0:p),a3)
if(!(q<a3))return A.a(s,q)
s[q]=p}o=new Int32Array(a2)
for(n=0;n<a2;++n){p=r?a:a0.b
p=B.a.au(n*(p==null?0:p),a2)
if(!(n<a2))return A.a(o,n)
o[n]=p}m=a1.gab().length
for(a0=t.g,l=a,k=0;k<m;++k){j=a1.x
if(j===$)j=a1.x=A.j([],a0)
if(!(k<j.length))return A.a(j,k)
i=j[k]
h=A.h3(i,a2,!0,a3)
r=l==null
if(!r)l.aN(h)
if(r)l=h
r=i.a
if((r==null?a:r.gO())!=null)for(n=0;n<a2;++n){if(!(n<a2))return A.a(o,n)
g=o[n]
for(q=0;q<a3;++q){if(!(q<a3))return A.a(s,q)
r=s[q]
p=i.a
r=p==null?a:B.b.i(p.aR(r,g).gU())
if(r==null)r=0
p=h.a
if(p!=null)p.aK(q,n,r)}}else{f=i.aw(0,0)
for(n=0;n<a2;++n){if(!(n<a2))return A.a(o,n)
e=o[n]
for(q=0;q<a3;++q){if(!(q<a3))return A.a(s,q)
r=s[q]
p=i.a
if(p!=null)p.P(r,e,f)
r=f.gn()
p=f.gt()
d=f.gu()
c=f.gv()
b=h.a
if(b!=null)b.az(q,n,r,p,d,c)}}}}l.toString
return l},
iu(b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=null,b0=B.a.a8(b2,360)
b1.gaP()
if(B.a.a8(b0,90)===0)switch(B.a.W(b0,90)){case 1:return A.tG(b1)
case 2:return A.tE(b1)
case 3:return A.tF(b1)
default:return A.bF(b1,!1,!1)}s=b0*3.141592653589793/180
r=Math.cos(s)
q=Math.sin(s)
p=b1.gS()
o=b1.gS()
n=b1.gK()
m=b1.gK()
l=0.5*b1.gS()
k=0.5*b1.gK()
n=Math.abs(p*r)+Math.abs(n*q)
j=0.5*n
m=Math.abs(o*q)+Math.abs(m*r)
i=0.5*m
h=b1.gab().length
for(p=t.g,g=b1.f,f=a9,e=0;e<h;++e){d=b1.x
if(d===$)d=b1.x=A.j([],p)
if(!(e<d.length))return A.a(d,e)
c=d[e]
o=f==null
b=o?a9:f.dw()
if(b==null){a=B.b.i(n)
b=A.h3(b1,B.b.i(m),!0,a)}if(o)f=b
a0=c.f
if(a0==null)a0=g
if(a0!=null){o=b.a
if(o!=null)o.b5(0,a0)}for(o=b.a,o=o.gH(o);o.E();){a1=o.gN()
a2=a1.gaZ()
a3=a1.gaW()
a=a2-j
a4=a3-i
a5=l+a*r+a4*q
a6=k-a*q+a4*r
a=!1
if(a5>=0)if(a6>=0){a4=c.a
a7=a4==null
a8=a7?a9:a4.a
if(a5<(a8==null?0:a8)){a=a7?a9:a4.b
a=a6<(a==null?0:a)}}if(a)b.ca(a2,a3,c.hL(a5,a6,B.dt))}}f.toString
return f},
tG(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gab(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.K)(s),++p){o=s[p]
n=q==null
m=n?f:q.dw()
if(m==null){l=o.a
k=l==null
j=k?f:l.b
if(j==null)j=0
l=k?f:l.a
m=A.h3(o,l==null?0:l,!0,j)}if(n)q=m
n=o.a
n=n==null?f:n.b
i=(n==null?0:n)-1
h=0
for(;;){n=m.a
n=n==null?f:n.b
if(!(h<(n==null?0:n)))break
g=0
for(;;){n=m.a
n=n==null?f:n.a
if(!(g<(n==null?0:n)))break
n=o.a
n=n==null?f:n.P(h,i-g,f)
m.ca(g,h,n==null?new A.F():n);++g}++h}}q.toString
return q},
tE(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gab(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.K)(s),++p){o=s[p]
n=o.a
m=n==null
l=m?f:n.a
k=(l==null?0:l)-1
n=m?f:n.b
j=(n==null?0:n)-1
n=q==null
i=n?f:q.dw()
if(i==null)i=A.bF(o,!0,!0)
if(n)q=i
h=0
for(;;){n=i.a
n=n==null?f:n.b
if(!(h<(n==null?0:n)))break
n=j-h
g=0
for(;;){m=i.a
m=m==null?f:m.a
if(!(g<(m==null?0:m)))break
m=o.a
m=m==null?f:m.P(k-g,n,f)
i.ca(g,h,m==null?new A.F():m);++g}++h}}q.toString
return q},
tF(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gab(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.K)(s),++p){o=s[p]
n=a.a
n=n==null?f:n.a
m=(n==null?0:n)-1
n=q==null
l=n?f:q.dw()
if(l==null){k=o.a
j=k==null
i=j?f:k.b
if(i==null)i=0
k=j?f:k.a
l=A.h3(o,k==null?0:k,!0,i)}if(n)q=l
h=0
for(;;){n=l.a
n=n==null?f:n.b
if(!(h<(n==null?0:n)))break
n=m-h
g=0
for(;;){k=l.a
k=k==null?f:k.a
if(!(g<(k==null?0:k)))break
k=o.a
k=k==null?f:k.P(n,g,f)
l.ca(g,h,k==null?new A.F():k);++g}++h}}q.toString
return q},
lf(a){var s
a=(a&-a)>>>0
s=a!==0?31:32
if((a&65535)!==0)s-=16
if((a&16711935)!==0)s-=8
if((a&252645135)!==0)s-=4
if((a&858993459)!==0)s-=2
return(a&1431655765)!==0?s-1:s},
uH(a){var s
$.mU().h(0,0,a)
s=$.p6()
if(0>=s.length)return A.a(s,0)
return s[0]},
oH(a,b,c,d){return(B.a.G(a,0,255)|B.a.G(b,0,255)<<8|B.a.G(c,0,255)<<16|B.a.G(d,0,255)<<24)>>>0},
be(a,b,c){var s,r,q,p,o=b.gA(b),n=b.gM(),m=a.gO(),l=m==null?null:m.gM()
if(l==null)l=a.gM()
s=a.gA(a)
if(o===1)b.h(0,0,A.it(B.b.bq(a.gA(a)>2?a.gap():a.l(0,0)),l,n))
else if(o<=s)for(r=0;r<o;++r)b.h(0,r,A.it(a.l(0,r),l,n))
else if(s===2){q=A.it(a.l(0,0),l,n)
if(o===3){b.h(0,0,q)
b.h(0,1,q)
b.h(0,2,q)}else{c=A.it(a.l(0,1),l,n)
b.h(0,0,q)
b.h(0,1,q)
b.h(0,2,q)
b.h(0,3,c)}}else{for(r=0;r<s;++r)b.h(0,r,A.it(a.l(0,r),l,n))
p=s===1?b.l(0,0):0
for(r=s;r<o;++r)b.h(0,r,r===3?c:p)}return b},
aG(a,b,c,d,e){var s,r,q=a.gO(),p=q==null?null:q.gM()
if(p==null)p=a.gM()
q=e==null
s=q?null:e.gM()
c=s==null?c:s
if(c==null)c=a.gM()
s=q?null:e.gA(e)
d=s==null?d:s
if(d==null)d=a.gA(a)
if(b==null)b=0
if(c===p&&d===a.gA(a)){if(q)return a.X()
e.aj(a)
return e}switch(c.a){case 3:if(q)r=new A.b3(new Uint8Array(d))
else r=e
return A.be(a,r,b)
case 0:return A.be(a,q?new A.d_(d,0):e,b)
case 1:return A.be(a,q?new A.d1(d,0):e,b)
case 2:if(q){q=d<3?1:2
r=new A.d3(d,new Uint8Array(q))}else r=e
return A.be(a,r,b)
case 4:if(q)r=new A.d0(new Uint16Array(d))
else r=e
return A.be(a,r,b)
case 5:if(q)r=new A.d2(new Uint32Array(d))
else r=e
return A.be(a,r,b)
case 6:if(q)r=new A.cZ(new Int8Array(d))
else r=e
return A.be(a,r,b)
case 7:if(q)r=new A.cX(new Int16Array(d))
else r=e
return A.be(a,r,b)
case 8:if(q)r=new A.cY(new Int32Array(d))
else r=e
return A.be(a,r,b)
case 9:if(q)r=new A.cU(new Uint16Array(d))
else r=e
return A.be(a,r,b)
case 10:if(q)r=new A.cV(new Float32Array(d))
else r=e
return A.be(a,r,b)
case 11:if(q)r=new A.cW(new Float64Array(d))
else r=e
return A.be(a,r,b)}},
a_(a){return 0.299*a.gn()+0.587*a.gt()+0.114*a.gu()},
ou(a,b,c,d,e){var s=1-d/255
B.c.h(e,0,B.b.av(255*(1-a/255)*s))
B.c.h(e,1,B.b.av(255*(1-b/255)*s))
B.c.h(e,2,B.b.av(255*(1-c/255)*s))},
L(a){var s,r,q,p=$.mT()
p.$flags&2&&A.b(p)
p[0]=a
p=$.p5()
if(0>=p.length)return A.a(p,0)
s=p[0]
if(a===0)return s>>>16
if($.U==null)A.X()
r=s>>>23&511
p=$.nd.cN()
if(!(r<p.length))return A.a(p,r)
r=p[r]
if(r!==0){q=s&8388607
return r+(q+4095+(q>>>13&1)>>>13)}return A.pC(s)},
pC(a){var s,r,q=a>>>16&32768,p=(a>>>23&255)-112,o=a&8388607
if(p<=0){if(p<-10)return q
o|=8388608
s=14-p
return(q|B.a.aL(o+(B.a.V(1,s-1)-1)+(B.a.a2(o,s)&1),s))>>>0}else if(p===143)if(o===0)return q|31744
else{o=o>>>13
r=o===0?1:0
return q|o|r|31744}else{o=o+4095+(o>>>13&1)
if((o&8388608)!==0){++p
o=0}if(p>30)return q|31744
return(q|p<<10|o>>>13)>>>0}},
X(){var s,r,q,p,o,n=$.U
if(n!=null)return n
s=new Uint32Array(65536)
$.U=J.mW(B.o.gB(s),0,null)
n=new Uint16Array(512)
$.nd.b=n
for(r=0;r<256;++r){q=(r&255)-112
if(q<=0||q>=30){n[r]=0
p=(r|256)>>>0
if(!(p<512))return A.a(n,p)
n[p]=0}else{p=q<<10>>>0
n[r]=p
o=(r|256)>>>0
if(!(o<512))return A.a(n,o)
n[o]=(p|32768)>>>0}}for(r=0;r<65536;++r)s[r]=A.pD(r)
n=$.U
n.toString
return n},
pD(a){var s,r=a>>>15&1,q=a>>>10&31,p=a&1023
if(q===0)if(p===0)return r<<31>>>0
else{while((p&1024)===0){p=p<<1;--q}++q
p&=4294966271}else if(q===31){s=r<<31
if(p===0)return(s|2139095040)>>>0
else return(s|p<<13|2139095040)>>>0}return(r<<31|q+112<<23|p<<13)>>>0},
qm(a){var s="[Matrix] "+a.a,r=a.c
if(r!=null)s+="\n"+r.D(0)
switch(a.d.a){case 0:A.br(v.G.console).error("!!!CRITICAL!!! "+s)
break
case 1:A.br(v.G.console).error(s)
break
case 2:A.br(v.G.console).warn(s)
break
case 3:A.br(v.G.console).info(s)
break
case 4:A.br(v.G.console).debug(s)
break
case 5:A.br(v.G.console).log(s)
break}},
uu(){return A.mM()}},B={}
var w=[A,J,B]
var $={}
A.lX.prototype={}
J.h9.prototype={
Y(a,b){return a===b},
gL(a){return A.eN(a)},
D(a){return"Instance of '"+A.hH(a)+"'"},
gaU(a){return A.bT(A.mA(this))}}
J.hn.prototype={
D(a){return String(a)},
gL(a){return a?519018:218159},
gaU(a){return A.bT(t.y)},
$iO:1,
$iaF:1}
J.ej.prototype={
Y(a,b){return null==b},
D(a){return"null"},
gL(a){return 0},
$iO:1}
J.el.prototype={$ia0:1}
J.c0.prototype={
gL(a){return 0},
D(a){return String(a)}}
J.hC.prototype={}
J.cH.prototype={}
J.bG.prototype={
D(a){var s=a[$.oK()]
if(s==null)s=a[$.mQ()]
if(s==null)return this.i0(a)
return"JavaScript function for "+J.dU(s)},
$ibA:1}
J.dk.prototype={
gL(a){return 0},
D(a){return String(a)}}
J.dl.prototype={
gL(a){return 0},
D(a){return String(a)}}
J.t.prototype={
C(a,b){A.am(a).c.a(b)
a.$flags&1&&A.b(a,29)
a.push(b)},
dE(a,b){var s
a.$flags&1&&A.b(a,"removeAt",1)
s=a.length
if(b>=s)throw A.h(A.mi(b,null))
return a.splice(b,1)[0]},
cw(a,b){var s
A.am(a).p("e<1>").a(b)
a.$flags&1&&A.b(a,"addAll",2)
if(Array.isArray(b)){this.is(a,b)
return}for(s=J.fz(b);s.E();)a.push(s.gN())},
is(a,b){var s,r
t.dG.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.h(A.b5(a))
for(r=0;r<s;++r)a.push(b[r])},
dA(a){a.$flags&1&&A.b(a,"clear","clear")
a.length=0},
co(a,b,c){var s=A.am(a)
return new A.b9(a,s.ak(c).p("1(2)").a(b),s.p("@<1>").ak(c).p("b9<1,2>"))},
lt(a,b){var s,r=A.E(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.h(r,s,A.z(a[s]))
return r.join(b)},
hz(a,b){return A.dB(a,0,A.fw(b,"count",t.p),A.am(a).c)},
dG(a,b){return A.dB(a,b,null,A.am(a).c)},
bH(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
bh(a,b,c){if(b<0||b>a.length)throw A.h(A.ao(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.h(A.ao(c,b,a.length,"end",null))
if(b===c)return A.j([],A.am(a))
return A.j(a.slice(b,c),A.am(a))},
gho(a){if(a.length>0)return a[0]
throw A.h(A.jc())},
geg(a){var s=a.length
if(s>0)return a[s-1]
throw A.h(A.jc())},
ar(a,b,c,d,e){var s,r,q,p,o
A.am(a).p("e<1>").a(d)
a.$flags&2&&A.b(a,5)
A.bn(b,c,a.length)
s=c-b
if(s===0)return
A.dy(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.lL(d,e).ej(0,!1)
q=0}p=J.ab(r)
if(q+s>p.gA(r))throw A.h(A.ns())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.l(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.l(r,q+o)},
ac(a,b,c,d){var s
A.am(a).p("1?").a(d)
a.$flags&2&&A.b(a,"fillRange")
A.bn(b,c,a.length)
for(s=b;s<c;++s)a[s]=d},
ew(a,b){var s,r,q,p,o,n=A.am(a)
n.p("f(1,1)?").a(b)
a.$flags&2&&A.b(a,"sort")
s=a.length
if(s<2)return
if(b==null)b=J.th()
if(s===2){r=a[0]
q=a[1]
n=b.$2(r,q)
if(typeof n!=="number")return n.hN()
if(n>0){a[0]=q
a[1]=r}return}p=0
if(n.c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.dS(b,2))
if(p>0)this.kG(a,p)},
ev(a){return this.ew(a,null)},
kG(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
ck(a,b){var s
for(s=0;s<a.length;++s)if(J.bV(a[s],b))return!0
return!1},
D(a){return A.lW(a,"[","]")},
gH(a){return new J.dV(a,a.length,A.am(a).p("dV<1>"))},
gL(a){return A.eN(a)},
gA(a){return a.length},
sA(a,b){a.$flags&1&&A.b(a,"set length","change the length of")
if(b<0)throw A.h(A.ao(b,0,null,"newLength",null))
if(b>a.length)A.am(a).c.a(null)
a.length=b},
l(a,b){if(!(b>=0&&b<a.length))throw A.h(A.lh(a,b))
return a[b]},
h(a,b,c){A.am(a).c.a(c)
a.$flags&2&&A.b(a)
if(!(b>=0&&b<a.length))throw A.h(A.lh(a,b))
a[b]=c},
hF(a,b){return new A.cL(a,b.p("cL<0>"))},
$iai:1,
$iC:1,
$ie:1,
$ir:1}
J.hl.prototype={
lS(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.hH(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.jd.prototype={}
J.dV.prototype={
gN(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.K(q)
throw A.h(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iA:1}
J.dj.prototype={
bS(a,b){var s
A.mx(b)
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gef(b)
if(this.gef(a)===s)return 0
if(this.gef(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gef(a){return a===0?1/a<0:a<0},
ger(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
i(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.h(A.bq(""+a+".toInt()"))},
bc(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.h(A.bq(""+a+".ceil()"))},
bq(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.h(A.bq(""+a+".floor()"))},
av(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.h(A.bq(""+a+".round()"))},
G(a,b,c){if(this.bS(b,c)>0)throw A.h(A.bS(b))
if(this.bS(a,b)<0)return b
if(this.bS(a,c)>0)return c
return a},
dF(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.h(A.ao(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.ax(A.bq("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.m.en("0",o)},
D(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gL(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a8(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
if(b<0)return s-b
else return s+b},
au(a,b){A.mx(b)
if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.fI(a,b)},
W(a,b){return(a|0)===a?a/b|0:this.fI(a,b)},
fI(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.h(A.bq("Result of truncating division is "+A.z(s)+": "+A.z(a)+" ~/ "+b))},
V(a,b){if(b<0)throw A.h(A.bS(b))
return b>31?0:a<<b>>>0},
R(a,b){return b>31?0:a<<b>>>0},
aL(a,b){var s
if(b<0)throw A.h(A.bS(b))
if(a>0)s=this.a0(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
j(a,b){var s
if(a>0)s=this.a0(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
a2(a,b){if(0>b)throw A.h(A.bS(b))
return this.a0(a,b)},
a0(a,b){return b>31?0:a>>>b},
hV(a,b){if(b<0)throw A.h(A.bS(b))
return this.kM(a,b)},
kM(a,b){if(b>31)return 0
return a>>>b},
gaU(a){return A.bT(t.q)},
$ib4:1,
$iD:1,
$ik:1}
J.di.prototype={
ger(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
aG(a,b){var s=this.V(1,b-1)
return((a&s-1)>>>0)-((a&s)>>>0)},
gl_(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.W(q,4294967296)
s+=32}return s-Math.clz32(q)},
gaU(a){return A.bT(t.p)},
$iO:1,
$if:1}
J.ek.prototype={
gaU(a){return A.bT(t.V)},
$iO:1}
J.co.prototype={
bo(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.ez(a,r-s)},
ex(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
i_(a,b,c){return a.substring(b,A.bn(b,c,a.length))},
ez(a,b){return this.i_(a,b,null)},
hE(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(0>=o)return A.a(p,0)
if(p.charCodeAt(0)===133){s=J.pQ(p,1)
if(s===o)return""}else s=0
r=o-1
if(!(r>=0))return A.a(p,r)
q=p.charCodeAt(r)===133?J.pR(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
en(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.h(B.cX)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
lu(a,b){var s=a.length,r=b.length
if(s+r>s)s-=r
return a.lastIndexOf(b,s)},
bS(a,b){var s
A.bs(b)
if(a===b)s=0
else s=a<b?-1:1
return s},
D(a){return a},
gL(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gaU(a){return A.bT(t.N)},
gA(a){return a.length},
$iai:1,
$iO:1,
$ib4:1,
$inD:1,
$iV:1}
A.dm.prototype={
D(a){return"LateInitializationError: "+this.a}}
A.af.prototype={
gA(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s.charCodeAt(b)}}
A.jM.prototype={}
A.C.prototype={}
A.aC.prototype={
gH(a){var s=this
return new A.cq(s,s.gA(s),A.l(s).p("cq<aC.E>"))},
co(a,b,c){var s=A.l(this)
return new A.b9(this,s.ak(c).p("1(aC.E)").a(b),s.p("@<aC.E>").ak(c).p("b9<1,2>"))},
lJ(a,b){var s,r,q,p=this
A.l(p).p("aC.E(aC.E,aC.E)").a(b)
s=p.gA(p)
if(s===0)throw A.h(A.jc())
r=p.bH(0,0)
for(q=1;q<s;++q){r=b.$2(r,p.bH(0,q))
if(s!==p.gA(p))throw A.h(A.b5(p))}return r}}
A.eV.prototype={
gjm(){var s=J.bv(this.a),r=this.c
if(r==null||r>s)return s
return r},
gkO(){var s=J.bv(this.a),r=this.b
if(r>s)return s
return r},
gA(a){var s,r=J.bv(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
bH(a,b){var s=this,r=s.gkO()+b
if(b<0||r>=s.gjm())throw A.h(A.lV(b,s.gA(0),s,null,"index"))
return J.mY(s.a,r)},
dG(a,b){var s,r,q=this
A.dy(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.ch(q.$ti.p("ch<1>"))
return A.dB(q.a,s,r,q.$ti.c)},
ej(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.ab(n),l=m.gA(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=p.$ti.c
return b?J.hm(0,n):J.nt(0,n)}r=A.E(s,m.bH(n,o),b,p.$ti.c)
for(q=1;q<s;++q){B.c.h(r,q,m.bH(n,o+q))
if(m.gA(n)<l)throw A.h(A.b5(p))}return r},
lP(a){return this.ej(0,!0)}}
A.cq.prototype={
gN(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=J.ab(q),o=p.gA(q)
if(r.b!==o)throw A.h(A.b5(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.bH(q,s);++r.c
return!0},
$iA:1}
A.bH.prototype={
gH(a){var s=this.a
return new A.ep(s.gH(s),this.b,A.l(this).p("ep<1,2>"))},
gA(a){var s=this.a
return s.gA(s)}}
A.cg.prototype={$iC:1}
A.ep.prototype={
E(){var s=this,r=s.b
if(r.E()){s.a=s.c.$1(r.gN())
return!0}s.a=null
return!1},
gN(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iA:1}
A.b9.prototype={
gA(a){return J.bv(this.a)},
bH(a,b){return this.b.$1(J.mY(this.a,b))}}
A.cK.prototype={
gH(a){return new A.f8(J.fz(this.a),this.b,this.$ti.p("f8<1>"))},
co(a,b,c){var s=this.$ti
return new A.bH(this,s.ak(c).p("1(2)").a(b),s.p("@<1>").ak(c).p("bH<1,2>"))}}
A.f8.prototype={
E(){var s,r
for(s=this.a,r=this.b;s.E();)if(r.$1(s.gN()))return!0
return!1},
gN(){return this.a.gN()},
$iA:1}
A.ch.prototype={
gH(a){return B.cQ},
gA(a){return 0},
co(a,b,c){this.$ti.ak(c).p("1(2)").a(b)
return new A.ch(c.p("ch<0>"))}}
A.dX.prototype={
E(){return!1},
gN(){throw A.h(A.jc())},
$iA:1}
A.cL.prototype={
gH(a){return new A.f9(J.fz(this.a),this.$ti.p("f9<1>"))}}
A.f9.prototype={
E(){var s,r
for(s=this.a,r=this.$ti.c;s.E();)if(r.b(s.gN()))return!0
return!1},
gN(){return this.$ti.c.a(this.a.gN())},
$iA:1}
A.as.prototype={}
A.bL.prototype={
h(a,b,c){A.l(this).p("bL.E").a(c)
throw A.h(A.bq("Cannot modify an unmodifiable list"))},
ar(a,b,c,d,e){A.l(this).p("e<bL.E>").a(d)
throw A.h(A.bq("Cannot modify an unmodifiable list"))},
ba(a,b,c,d){return this.ar(0,b,c,d,0)},
ac(a,b,c,d){A.l(this).p("bL.E?").a(d)
throw A.h(A.bq("Cannot modify an unmodifiable list"))}}
A.dC.prototype={}
A.cP.prototype={$r:"+(1,2)",$s:1}
A.d4.prototype={
D(a){return A.m_(this)},
$iaU:1}
A.d5.prototype={
gA(a){return this.b.length},
gfm(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
a9(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
l(a,b){if(!this.a9(b))return null
return this.b[this.a[b]]},
bL(a,b){var s,r,q,p
this.$ti.p("~(1,2)").a(b)
s=this.gfm()
r=this.b
for(q=s.length,p=0;p<q;++p)b.$2(s[p],r[p])},
gc7(){return new A.fe(this.gfm(),this.$ti.p("fe<1>"))}}
A.fe.prototype={
gA(a){return this.a.length},
gH(a){var s=this.a
return new A.ff(s,s.length,this.$ti.p("ff<1>"))}}
A.ff.prototype={
gN(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0},
$iA:1}
A.aJ.prototype={
cI(){var s=this,r=s.$map
if(r==null){r=new A.em(s.$ti.p("em<1,2>"))
A.oy(s.a,r)
s.$map=r}return r},
a9(a){return this.cI().a9(a)},
l(a,b){return this.cI().l(0,b)},
bL(a,b){this.$ti.p("~(1,2)").a(b)
this.cI().bL(0,b)},
gc7(){var s=this.cI()
return new A.cp(s,A.l(s).p("cp<1>"))},
gA(a){return this.cI().a}}
A.h7.prototype={
Y(a,b){if(b==null)return!1
return b instanceof A.dh&&this.a.Y(0,b.a)&&A.mG(this)===A.mG(b)},
gL(a){return A.jy(this.a,A.mG(this),B.E,B.E)},
D(a){var s=B.c.lt([A.bT(this.$ti.c)],", ")
return this.a.D(0)+" with "+("<"+s+">")}}
A.dh.prototype={
$2(a,b){return this.a.$1$2(a,b,this.$ti.y[0])},
$S(){return A.uq(A.ld(this.a),this.$ti)}}
A.eR.prototype={}
A.jU.prototype={
bM(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
if(p==null)return null
s=Object.create(null)
r=q.b
if(r!==-1)s.arguments=p[r+1]
r=q.c
if(r!==-1)s.argumentsExpr=p[r+1]
r=q.d
if(r!==-1)s.expr=p[r+1]
r=q.e
if(r!==-1)s.method=p[r+1]
r=q.f
if(r!==-1)s.receiver=p[r+1]
return s}}
A.ez.prototype={
D(a){return"Null check operator used on a null value"}}
A.hr.prototype={
D(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.i1.prototype={
D(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.jx.prototype={
D(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.dY.prototype={}
A.fn.prototype={
D(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iaY:1}
A.ar.prototype={
D(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.oJ(r==null?"unknown":r)+"'"},
$ibA:1,
glZ(){return this},
$C:"$1",
$R:1,
$D:null}
A.fG.prototype={$C:"$0",$R:0}
A.fH.prototype={$C:"$2",$R:2}
A.hW.prototype={}
A.hV.prototype={
D(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.oJ(s)+"'"}}
A.cS.prototype={
Y(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.cS))return!1
return this.$_target===b.$_target&&this.a===b.a},
gL(a){return(A.iA(this.a)^A.eN(this.$_target))>>>0},
D(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.hH(this.a)+"'")}}
A.hU.prototype={
D(a){return"RuntimeError: "+this.a}}
A.b8.prototype={
gA(a){return this.a},
gc7(){return new A.cp(this,A.l(this).p("cp<1>"))},
a9(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.lo(a)},
lo(a){var s=this.d
if(s==null)return!1
return this.cZ(this.f8(s,a),a)>=0},
l(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.lp(b)},
lp(a){var s,r,q=this.d
if(q==null)return null
s=this.f8(q,a)
r=this.cZ(s,a)
if(r<0)return null
return s[r].b},
h(a,b,c){var s,r,q=this,p=A.l(q)
p.c.a(b)
p.y[1].a(c)
if(typeof b=="string"){s=q.b
q.eD(s==null?q.b=q.e_():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.eD(r==null?q.c=q.e_():r,b,c)}else q.lr(b,c)},
lr(a,b){var s,r,q,p,o=this,n=A.l(o)
n.c.a(a)
n.y[1].a(b)
s=o.d
if(s==null)s=o.d=o.e_()
r=o.dC(a)
q=s[r]
if(q==null)s[r]=[o.e0(a,b)]
else{p=o.cZ(q,a)
if(p>=0)q[p].b=b
else q.push(o.e0(a,b))}},
cA(a,b){var s=this
if(typeof b=="string")return s.fC(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.fC(s.c,b)
else return s.lq(b)},
lq(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.dC(a)
r=n[s]
q=o.cZ(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.fN(p)
if(r.length===0)delete n[s]
return p.b},
bL(a,b){var s,r,q=this
A.l(q).p("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.h(A.b5(q))
s=s.c}},
eD(a,b,c){var s,r=A.l(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.e0(b,c)
else s.b=c},
fC(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.fN(s)
delete a[b]
return s.b},
fp(){this.r=this.r+1&1073741823},
e0(a,b){var s=this,r=A.l(s),q=new A.jn(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.fp()
return q},
fN(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.fp()},
dC(a){return J.aI(a)&1073741823},
f8(a,b){return a[this.dC(b)]},
cZ(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.bV(a[r].a,b))return r
return-1},
D(a){return A.m_(this)},
e_(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$ijm:1}
A.jn.prototype={}
A.cp.prototype={
gA(a){return this.a.a},
gH(a){var s=this.a
return new A.R(s,s.r,s.e,this.$ti.p("R<1>"))}}
A.R.prototype={
gN(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.h(A.b5(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iA:1}
A.jo.prototype={
gA(a){return this.a.a},
gH(a){var s=this.a
return new A.au(s,s.r,s.e,this.$ti.p("au<1>"))}}
A.au.prototype={
gN(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.h(A.b5(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}},
$iA:1}
A.em.prototype={
dC(a){return A.u2(a)&1073741823},
cZ(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.bV(a[r].a,b))return r
return-1}}
A.lt.prototype={
$1(a){return this.a(a)},
$S:21}
A.lu.prototype={
$2(a,b){return this.a(a,b)},
$S:30}
A.lv.prototype={
$1(a){return this.a(A.bs(a))},
$S:32}
A.c7.prototype={
D(a){return this.fK(!1)},
fK(a){var s,r,q,p,o,n=this.jr(),m=this.f9(),l=(a?"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
if(!(q<m.length))return A.a(m,q)
o=m[q]
l=a?l+A.nG(o):l+A.z(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
jr(){var s,r=this.$s
while($.kP.length<=r)B.c.C($.kP,null)
s=$.kP[r]
if(s==null){s=this.iI()
B.c.h($.kP,r,s)}return s},
iI(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=t.K,j=J.cn(l,k)
for(s=0;s<l;++s)j[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
B.c.h(j,q,r[s])}}j=A.dn(j,!1,k)
j.$flags=3
return j}}
A.dK.prototype={
f9(){return[this.a,this.b]},
Y(a,b){if(b==null)return!1
return b instanceof A.dK&&this.$s===b.$s&&J.bV(this.a,b.a)&&J.bV(this.b,b.b)},
gL(a){return A.jy(this.$s,this.a,this.b,B.E)}}
A.ky.prototype={
cN(){var s=this.b
if(s===this)throw A.h(A.jj(this.a))
return s}}
A.cr.prototype={
gd_(a){return a.byteLength},
gaU(a){return B.lN},
cS(a,b,c){A.aO(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
ha(a){return this.cS(a,0,null)},
h7(a,b,c){A.aO(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
dz(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
h8(a){return this.dz(a,0,null)},
h5(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Int16Array(a,b,c)},
h9(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
h6(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Int32Array(a,b,c)},
h4(a,b,c){A.aO(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Float32Array(a,b,c)},
$iO:1,
$icr:1,
$ifE:1}
A.ev.prototype={
gB(a){if(((a.$flags|0)&2)!==0)return new A.im(a.buffer)
else return a.buffer},
jQ(a,b,c,d){var s=A.ao(b,0,c,d,null)
throw A.h(s)},
eP(a,b,c,d){if(b>>>0!==b||b>c)this.jQ(a,b,c,d)},
$ia1:1}
A.im.prototype={
gd_(a){return this.a.byteLength},
cS(a,b,c){var s=A.q9(this.a,b,c)
s.$flags=3
return s},
ha(a){return this.cS(0,0,null)},
h7(a,b,c){var s=A.q4(this.a,b,c)
s.$flags=3
return s},
dz(a,b,c){var s=A.q6(this.a,b,c)
s.$flags=3
return s},
h8(a){return this.dz(0,0,null)},
h5(a,b,c){var s=A.q2(this.a,b,c)
s.$flags=3
return s},
h9(a,b,c){var s=A.q8(this.a,b,c)
s.$flags=3
return s},
h6(a,b,c){var s=A.q3(this.a,b,c)
s.$flags=3
return s},
h4(a,b,c){var s=A.q1(this.a,b,c)
s.$flags=3
return s},
$ifE:1}
A.hv.prototype={
gaU(a){return B.lO},
$iO:1,
$iiM:1}
A.ak.prototype={
gA(a){return a.length},
fG(a,b,c,d,e){var s,r,q=a.length
this.eP(a,b,q,"start")
this.eP(a,c,q,"end")
if(b>c)throw A.h(A.ao(b,0,c,null,null))
s=c-b
if(e<0)throw A.h(A.b2(e,null))
r=d.length
if(r-e<s)throw A.h(A.mk("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iai:1,
$iaL:1}
A.c1.prototype={
l(a,b){A.bR(b,a,a.length)
return a[b]},
h(a,b,c){A.ip(c)
a.$flags&2&&A.b(a)
A.bR(b,a,a.length)
a[b]=c},
ar(a,b,c,d,e){t.id.a(d)
a.$flags&2&&A.b(a,5)
if(t.dQ.b(d)){this.fG(a,b,c,d,e)
return}this.eA(a,b,c,d,e)},
ba(a,b,c,d){return this.ar(a,b,c,d,0)},
$iC:1,
$ie:1,
$ir:1}
A.aM.prototype={
h(a,b,c){A.m(c)
a.$flags&2&&A.b(a)
A.bR(b,a,a.length)
a[b]=c},
ar(a,b,c,d,e){t.fm.a(d)
a.$flags&2&&A.b(a,5)
if(t.aj.b(d)){this.fG(a,b,c,d,e)
return}this.eA(a,b,c,d,e)},
ba(a,b,c,d){return this.ar(a,b,c,d,0)},
$iC:1,
$ie:1,
$ir:1}
A.eq.prototype={
gaU(a){return B.lP},
bh(a,b,c){return new Float32Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$iiW:1}
A.er.prototype={
gaU(a){return B.lQ},
bh(a,b,c){return new Float64Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ie2:1}
A.es.prototype={
gaU(a){return B.lR},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Int16Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ih8:1}
A.et.prototype={
gaU(a){return B.lS},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Int32Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ief:1}
A.eu.prototype={
gaU(a){return B.lT},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Int8Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ijb:1}
A.ew.prototype={
gaU(a){return B.lV},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint16Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ii_:1}
A.ex.prototype={
gaU(a){return B.lW},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint32Array(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ibp:1}
A.ey.prototype={
gaU(a){return B.lX},
gA(a){return a.length},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint8ClampedArray(a.subarray(b,A.bd(b,c,a.length)))},
$iO:1,
$ijW:1}
A.cs.prototype={
gaU(a){return B.lY},
gA(a){return a.length},
l(a,b){A.bR(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint8Array(a.subarray(b,A.bd(b,c,a.length)))},
hY(a,b){return this.bh(a,b,null)},
$iO:1,
$ics:1,
$ibK:1}
A.fh.prototype={}
A.fi.prototype={}
A.fj.prototype={}
A.fk.prototype={}
A.bc.prototype={
p(a){return A.fr(v.typeUniverse,this,a)},
ak(a){return A.o5(v.typeUniverse,this,a)}}
A.ie.prototype={}
A.il.prototype={
D(a){return A.aw(this.a,null)}}
A.ic.prototype={
D(a){return this.a}}
A.dL.prototype={$ibo:1}
A.kv.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:13}
A.ku.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:26}
A.kw.prototype={
$0(){this.a.$0()},
$S:15}
A.kx.prototype={
$0(){this.a.$0()},
$S:15}
A.kS.prototype={
iq(a,b){if(self.setTimeout!=null)self.setTimeout(A.dS(new A.kT(this,b),0),a)
else throw A.h(A.bq("`setTimeout()` not found."))}}
A.kT.prototype={
$0(){this.b.$0()},
$S:2}
A.i9.prototype={
ea(a){var s,r=this,q=r.$ti
q.p("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.eJ(a)
else{s=r.a
if(q.p("cj<1>").b(a))s.eO(a)
else s.eT(a)}},
eb(a,b){var s=this.a
if(this.b)s.dN(new A.aR(a,b))
else s.dJ(new A.aR(a,b))}}
A.l1.prototype={
$1(a){return this.a.$2(0,a)},
$S:7}
A.l2.prototype={
$2(a,b){this.a.$2(1,new A.dY(a,t.l.a(b)))},
$S:38}
A.lb.prototype={
$2(a,b){this.a(A.m(a),b)},
$S:40}
A.aR.prototype={
D(a){return A.z(this.a)},
$iW:1,
gcE(){return this.b}}
A.ib.prototype={
eb(a,b){var s=this.a
if((s.a&30)!==0)throw A.h(A.mk("Future already completed"))
s.dJ(A.tg(a,b))},
he(a){return this.eb(a,null)}}
A.fa.prototype={
ea(a){var s,r=this.$ti
r.p("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.h(A.mk("Future already completed"))
s.eJ(r.p("1/").a(a))}}
A.cM.prototype={
lx(a){if((this.c&15)!==6)return!0
return this.b.b.ei(t.nU.a(this.d),a.a,t.y,t.K)},
lm(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.W.b(q))p=l.lM(q,m,a.b,o,n,t.l)
else p=l.ei(t.Q.a(q),m,o,n)
try{o=r.$ti.p("2/").a(p)
return o}catch(s){if(t.do.b(A.cc(s))){if((r.c&1)!==0)throw A.h(A.b2("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.h(A.b2("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.ac.prototype={
hA(a,b,c){var s,r,q=this.$ti
q.ak(c).p("1/(2)").a(a)
s=$.a2
if(s===B.F){if(!t.W.b(b)&&!t.Q.b(b))throw A.h(A.lN(b,"onError",u.c))}else{c.p("@<0/>").ak(q.c).p("1(2)").a(a)
b=A.tz(b,s)}r=new A.ac(s,c.p("ac<0>"))
this.dI(new A.cM(r,3,a,b,q.p("@<1>").ak(c).p("cM<1,2>")))
return r},
fJ(a,b,c){var s,r=this.$ti
r.ak(c).p("1/(2)").a(a)
s=new A.ac($.a2,c.p("ac<0>"))
this.dI(new A.cM(s,19,a,b,r.p("@<1>").ak(c).p("cM<1,2>")))
return s},
kK(a){this.a=this.a&1|16
this.c=a},
dc(a){this.a=a.a&30|this.a&1
this.c=a.c},
dI(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.dI(a)
return}r.dc(s)}A.is(null,null,r.b,t.M.a(new A.kB(r,a)))}},
fu(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.fu(a)
return}m.dc(n)}l.a=m.ds(a)
A.is(null,null,m.b,t.M.a(new A.kF(l,m)))}},
dr(){var s=t.F.a(this.c)
this.c=null
return this.ds(s)},
ds(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
eT(a){var s,r=this
r.$ti.c.a(a)
s=r.dr()
r.a=8
r.c=a
A.dH(r,s)},
iH(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.dr()
q.dc(a)
A.dH(q,r)},
dN(a){var s=this.dr()
this.kK(a)
A.dH(this,s)},
eJ(a){var s=this.$ti
s.p("1/").a(a)
if(s.p("cj<1>").b(a)){this.eO(a)
return}this.iw(a)},
iw(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.is(null,null,s.b,t.M.a(new A.kD(s,a)))},
eO(a){A.mp(this.$ti.p("cj<1>").a(a),this,!1)
return},
dJ(a){this.a^=2
A.is(null,null,this.b,t.M.a(new A.kC(this,a)))},
$icj:1}
A.kB.prototype={
$0(){A.dH(this.a,this.b)},
$S:2}
A.kF.prototype={
$0(){A.dH(this.b,this.a.a)},
$S:2}
A.kE.prototype={
$0(){A.mp(this.a.a,this.b,!0)},
$S:2}
A.kD.prototype={
$0(){this.a.eT(this.b)},
$S:2}
A.kC.prototype={
$0(){this.a.dN(this.b)},
$S:2}
A.kI.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.lL(t.mY.a(q.d),t.z)}catch(p){s=A.cc(p)
r=A.bU(p)
if(k.c&&t.u.a(k.b.a.c).a===s){q=k.a
q.c=t.u.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.lO(q)
n=k.a
n.c=new A.aR(q,o)
q=n}q.b=!0
return}if(j instanceof A.ac&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.u.a(j.c)
q.b=!0}return}if(j instanceof A.ac){m=k.b.a
l=new A.ac(m.b,m.$ti)
j.hA(new A.kJ(l,m),new A.kK(l),t.x)
q=k.a
q.c=l
q.b=!1}},
$S:2}
A.kJ.prototype={
$1(a){this.a.iH(this.b)},
$S:13}
A.kK.prototype={
$2(a,b){A.ft(a)
t.l.a(b)
this.a.dN(new A.aR(a,b))},
$S:41}
A.kH.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.ei(o.p("2/(1)").a(p.d),m,o.p("2/"),n)}catch(l){s=A.cc(l)
r=A.bU(l)
q=s
p=r
if(p==null)p=A.lO(q)
o=this.a
o.c=new A.aR(q,p)
o.b=!0}},
$S:2}
A.kG.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.u.a(l.a.a.c)
p=l.b
if(p.a.lx(s)&&p.a.e!=null){p.c=p.a.lm(s)
p.b=!1}}catch(o){r=A.cc(o)
q=A.bU(o)
p=t.u.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.lO(p)
m=l.b
m.c=new A.aR(p,n)
p=m}p.b=!0}},
$S:2}
A.ia.prototype={}
A.ij.prototype={}
A.fs.prototype={$inT:1}
A.ii.prototype={
lN(a){var s,r,q
t.M.a(a)
try{if(B.F===$.a2){a.$0()
return}A.ol(null,null,this,a,t.x)}catch(q){s=A.cc(q)
r=A.bU(q)
A.mC(A.ft(s),t.l.a(r))}},
kZ(a){return new A.kQ(this,t.M.a(a))},
lL(a,b){b.p("0()").a(a)
if($.a2===B.F)return a.$0()
return A.ol(null,null,this,a,b)},
ei(a,b,c,d){c.p("@<0>").ak(d).p("1(2)").a(a)
d.a(b)
if($.a2===B.F)return a.$1(b)
return A.tD(null,null,this,a,b,c,d)},
lM(a,b,c,d,e,f){d.p("@<0>").ak(e).ak(f).p("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.a2===B.F)return a.$2(b,c)
return A.tC(null,null,this,a,b,c,d,e,f)},
hy(a,b,c,d){return b.p("@<0>").ak(c).ak(d).p("1(2,3)").a(a)}}
A.kQ.prototype={
$0(){return this.a.lN(this.b)},
$S:2}
A.l7.prototype={
$0(){A.pu(this.a,this.b)},
$S:2}
A.fb.prototype={
gA(a){return this.a},
gc7(){return new A.fc(this,this.$ti.p("fc<1>"))},
a9(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.iK(a)},
iK(a){var s=this.d
if(s==null)return!1
return this.cH(this.eS(s,a),a)>=0},
l(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.nW(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.nW(q,b)
return r}else return this.jB(b)},
jB(a){var s,r,q=this.d
if(q==null)return null
s=this.eS(q,a)
r=this.cH(s,a)
return r<0?null:s[r+1]},
h(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.eR(s==null?m.b=A.mq():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.eR(r==null?m.c=A.mq():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.mq()
p=A.iA(b)&1073741823
o=q[p]
if(o==null){A.mr(q,p,[b,c]);++m.a
m.e=null}else{n=m.cH(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
bL(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.p("~(1,2)").a(b)
s=m.eV()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.l(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.h(A.b5(m))}},
eV(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.E(i.a,null,!1,t.z)
s=i.b
r=0
if(s!=null){q=Object.getOwnPropertyNames(s)
p=q.length
for(o=0;o<p;++o){h[r]=q[o];++r}}n=i.c
if(n!=null){q=Object.getOwnPropertyNames(n)
p=q.length
for(o=0;o<p;++o){h[r]=+q[o];++r}}m=i.d
if(m!=null){q=Object.getOwnPropertyNames(m)
p=q.length
for(o=0;o<p;++o){l=m[q[o]]
k=l.length
for(j=0;j<k;j+=2){h[r]=l[j];++r}}}return i.e=h},
eR(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.mr(a,b,c)},
eS(a,b){return a[A.iA(b)&1073741823]}}
A.dI.prototype={
cH(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.fc.prototype={
gA(a){return this.a.a},
gH(a){var s=this.a
return new A.fd(s,s.eV(),this.$ti.p("fd<1>"))}}
A.fd.prototype={
gN(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.h(A.b5(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$iA:1}
A.cN.prototype={
gH(a){var s=this,r=new A.fg(s,s.r,A.l(s).p("fg<1>"))
r.c=s.e
return r},
gA(a){return this.a},
C(a,b){var s,r,q=this
A.l(q).c.a(b)
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.eQ(s==null?q.b=A.mt():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.eQ(r==null?q.c=A.mt():r,b)}else return q.ir(b)},
ir(a){var s,r,q,p=this
A.l(p).c.a(a)
s=p.d
if(s==null)s=p.d=A.mt()
r=p.iJ(a)
q=s[r]
if(q==null)s[r]=[p.dM(a)]
else{if(p.cH(q,a)>=0)return!1
q.push(p.dM(a))}return!0},
eQ(a,b){A.l(this).c.a(b)
if(t.nF.a(a[b])!=null)return!1
a[b]=this.dM(b)
return!0},
dM(a){var s=this,r=new A.ih(A.l(s).c.a(a))
if(s.e==null)s.e=s.f=r
else s.f=s.f.b=r;++s.a
s.r=s.r+1&1073741823
return r},
iJ(a){return J.aI(a)&1073741823},
cH(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.bV(a[r].a,b))return r
return-1}}
A.ih.prototype={}
A.fg.prototype={
gN(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.h(A.b5(q))
else if(r==null){s.d=null
return!1}else{s.d=s.$ti.p("1?").a(r.a)
s.c=r.b
return!0}},
$iA:1}
A.jp.prototype={
$2(a,b){this.a.h(0,this.b.a(a),this.c.a(b))},
$S:19}
A.H.prototype={
gH(a){return new A.cq(a,this.gA(a),A.aQ(a).p("cq<H.E>"))},
bH(a,b){return this.l(a,b)},
ck(a,b){var s,r=this.gA(a)
for(s=0;s<r;++s){if(this.l(a,s)===b)return!0
if(r!==this.gA(a))throw A.h(A.b5(a))}return!1},
hF(a,b){return new A.cL(a,b.p("cL<0>"))},
co(a,b,c){var s=A.aQ(a)
return new A.b9(a,s.ak(c).p("1(H.E)").a(b),s.p("@<H.E>").ak(c).p("b9<1,2>"))},
dG(a,b){return A.dB(a,b,null,A.aQ(a).p("H.E"))},
hz(a,b){return A.dB(a,0,A.fw(b,"count",t.p),A.aQ(a).p("H.E"))},
bh(a,b,c){var s,r=this.gA(a)
A.bn(b,c,r)
A.bn(b,c,this.gA(a))
s=A.aQ(a).p("H.E")
s=A.u(A.dB(a,b,c,s),s)
return s},
ac(a,b,c,d){var s
A.aQ(a).p("H.E?").a(d)
A.bn(b,c,this.gA(a))
for(s=b;s<c;++s)this.h(a,s,d)},
ar(a,b,c,d,e){var s,r,q,p,o
A.aQ(a).p("e<H.E>").a(d)
A.bn(b,c,this.gA(a))
s=c-b
if(s===0)return
A.dy(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.lL(d,e).ej(0,!1)
r=0}p=J.ab(q)
if(r+s>p.gA(q))throw A.h(A.ns())
if(r<b)for(o=s-1;o>=0;--o)this.h(a,b+o,p.l(q,r+o))
else for(o=0;o<s;++o)this.h(a,b+o,p.l(q,r+o))},
ba(a,b,c,d){return this.ar(a,b,c,d,0)},
eo(a,b,c){A.aQ(a).p("e<H.E>").a(c)
this.ba(a,b,b+c.length,c)},
D(a){return A.lW(a,"[","]")},
$iC:1,
$ie:1,
$ir:1}
A.aj.prototype={
bL(a,b){var s,r,q,p=A.l(this)
p.p("~(aj.K,aj.V)").a(b)
for(s=this.gc7(),s=s.gH(s),p=p.p("aj.V");s.E();){r=s.gN()
q=this.l(0,r)
b.$2(r,q==null?p.a(q):q)}},
gA(a){var s=this.gc7()
return s.gA(s)},
D(a){return A.m_(this)},
$iaU:1}
A.jt.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.z(a)
r.a=(r.a+=s)+": "
s=A.z(b)
r.a+=s},
$S:20}
A.dz.prototype={
cw(a,b){var s
A.l(this).p("e<1>").a(b)
for(s=b.gH(b);s.E();)this.C(0,s.gN())},
co(a,b,c){var s=A.l(this)
return new A.cg(this,s.ak(c).p("1(2)").a(b),s.p("@<1>").ak(c).p("cg<1,2>"))},
D(a){return A.lW(this,"{","}")},
$iC:1,
$ie:1}
A.fm.prototype={}
A.kY.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:11}
A.kX.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:11}
A.kV.prototype={
cz(a){var s,r,q=a.length,p=A.bn(0,null,q),o=new Uint8Array(p)
for(s=0;s<p;++s){if(!(s<q))return A.a(a,s)
r=a.charCodeAt(s)
if((r&4294967040)!==0)throw A.h(A.lN(a,"string","Contains invalid characters."))
if(!(s<p))return A.a(o,s)
o[s]=r}return o}}
A.kU.prototype={
cz(a){var s,r,q,p
t.L.a(a)
s=a.length
r=A.bn(0,null,s)
for(q=0;q<r;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if((p&4294967040)!==0){if(!this.a)throw A.h(A.lS("Invalid value in input: "+p,null,null))
return this.iM(a,0,r)}}return A.eU(a,0,r)},
iM(a,b,c){var s,r,q,p
t.L.a(a)
for(s=a.length,r=b,q="";r<c;++r){if(!(r<s))return A.a(a,r)
p=a[r]
q+=A.ds((p&4294967040)!==0?65533:p)}return q.charCodeAt(0)==0?q:q}}
A.cT.prototype={}
A.fM.prototype={}
A.fO.prototype={}
A.hs.prototype={
c5(a){var s
t.L.a(a)
s=B.dw.cz(a)
return s}}
A.jl.prototype={}
A.jk.prototype={}
A.i2.prototype={
l4(a,b){t.L.a(a)
return(b===!0?B.m_:B.lZ).cz(a)}}
A.i3.prototype={
cz(a){return new A.io(this.a).eW(t.L.a(a),0,null,!0)}}
A.io.prototype={
eW(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.bn(b,c,a.length)
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.rO(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.rN(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.dQ(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.rP(o)
l.b=0
throw A.h(A.lS(m,a,p+l.c))}return n},
dQ(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.W(b+c,2)
r=q.dQ(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.dQ(a,s,c,d)}return q.l8(a,b,c,d)},
l8(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.eT(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
A:for(r=k.a;;){for(;;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.ds(f)
e.a+=p
if(d===a0)break A
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.ds(h)
e.a+=p
break
case 65:p=A.ds(h)
e.a+=p;--d
break
default:p=A.ds(h)
e.a=(e.a+=p)+p
break}else{k.b=g
k.c=d-1
return""}g=0}if(d===a0)break A
o=d+1
if(!(d>=0&&d<c))return A.a(a,d)
s=a[d]}o=d+1
if(!(d>=0&&d<c))return A.a(a,d)
s=a[d]
if(s<128){for(;;){if(!(o<a0)){n=a0
break}m=o+1
if(!(o>=0&&o<c))return A.a(a,o)
s=a[o]
if(s>=128){n=m-1
o=m
break}o=m}if(n-d<20)for(l=d;l<n;++l){if(!(l<c))return A.a(a,l)
p=A.ds(a[l])
e.a+=p}else{p=A.eU(a,d,n)
e.a+=p}if(n===a0)break A
d=o}else d=o}if(a1&&g>32)if(r){c=A.ds(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.cf.prototype={
Y(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cf)if(this.a===b.a)s=this.b===b.b
return s},
gL(a){return A.jy(this.a,this.b,B.E,B.E)},
bS(a,b){var s
t.cs.a(b)
s=B.a.bS(this.a,b.a)
if(s!==0)return s
return B.a.bS(this.b,b.b)},
D(a){var s=this,r=A.pr(A.qi(s)),q=A.fN(A.qg(s)),p=A.fN(A.qc(s)),o=A.fN(A.qd(s)),n=A.fN(A.qf(s)),m=A.fN(A.qh(s)),l=A.n8(A.qe(s)),k=s.b,j=k===0?"":A.n8(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"},
$ib4:1}
A.kz.prototype={
D(a){return this.a7()}}
A.W.prototype={
gcE(){return A.qb(this)}}
A.fA.prototype={
D(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.iS(s)
return"Assertion failed"}}
A.bo.prototype={}
A.b1.prototype={
gdU(){return"Invalid argument"+(!this.a?"(s)":"")},
gdT(){return""},
D(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.z(p),n=s.gdU()+q+o
if(!s.a)return n
return n+s.gdT()+": "+A.iS(s.ged())},
ged(){return this.b}}
A.dx.prototype={
ged(){return A.oc(this.b)},
gdU(){return"RangeError"},
gdT(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.z(q):""
else if(q==null)s=": Not greater than or equal to "+A.z(r)
else if(q>r)s=": Not in inclusive range "+A.z(r)+".."+A.z(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.z(r)
return s}}
A.h4.prototype={
ged(){return A.m(this.b)},
gdU(){return"RangeError"},
gdT(){if(A.m(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gA(a){return this.f}}
A.eX.prototype={
D(a){return"Unsupported operation: "+this.a}}
A.i0.prototype={
D(a){return"UnimplementedError: "+this.a}}
A.dA.prototype={
D(a){return"Bad state: "+this.a}}
A.fK.prototype={
D(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.iS(s)+"."}}
A.hy.prototype={
D(a){return"Out of Memory"},
gcE(){return null},
$iW:1}
A.eS.prototype={
D(a){return"Stack Overflow"},
gcE(){return null},
$iW:1}
A.kA.prototype={
D(a){return"Exception: "+this.a}}
A.iX.prototype={
D(a){var s=this.a,r=""!==s?"FormatException: "+s:"FormatException",q=this.c
return q!=null?r+(" (at offset "+A.z(q)+")"):r}}
A.e.prototype={
co(a,b,c){var s=A.l(this)
return A.pX(this,s.ak(c).p("1(e.E)").a(b),s.p("e.E"),c)},
gA(a){var s,r=this.gH(this)
for(s=0;r.E();)++s
return s},
bH(a,b){var s,r
A.dy(b,"index")
s=this.gH(this)
for(r=b;s.E();){if(r===0)return s.gN();--r}throw A.h(A.lV(b,b-r,this,null,"index"))},
D(a){return A.pO(this,"(",")")}}
A.al.prototype={
gL(a){return A.J.prototype.gL.call(this,0)},
D(a){return"null"}}
A.J.prototype={$iJ:1,
Y(a,b){return this===b},
gL(a){return A.eN(this)},
D(a){return"Instance of '"+A.hH(this)+"'"},
gaU(a){return A.uk(this)},
toString(){return this.D(this)}}
A.ik.prototype={
D(a){return""},
$iaY:1}
A.eT.prototype={
gA(a){return this.a.length},
D(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.jw.prototype={
D(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.lx.prototype={
$1(a){var s,r,q,p
if(A.ok(a))return a
s=this.a
if(s.a9(a))return s.l(0,a)
if(t.av.b(a)){r={}
s.h(0,a,r)
for(s=a.gc7(),s=s.gH(s);s.E();){q=s.gN()
r[q]=this.$1(a.l(0,q))}return r}else if(t.c.b(a)){p=[]
s.h(0,a,p)
B.c.cw(p,J.pg(a,this,t.z))
return p}else return a},
$S:10}
A.lz.prototype={
$1(a){return this.a.ea(this.b.p("0/?").a(a))},
$S:7}
A.lA.prototype={
$1(a){if(a==null)return this.a.he(new A.jw(a===undefined))
return this.a.he(a)},
$S:7}
A.lg.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.oj(a))return a
s=this.a
a.toString
if(s.a9(a))return s.l(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.ax(A.ao(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.fw(!0,"isUtc",t.y)
return new A.cf(r,0,!0)}if(a instanceof RegExp)throw A.h(A.b2("structured clone of RegExp",null))
if(a instanceof Promise)return A.uz(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.I(p,p)
s.h(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.an(n),p=s.gH(n);p.E();)m.push(A.ov(p.gN()))
for(l=0;l<s.gA(n);++l){k=s.l(n,l)
if(!(l<m.length))return A.a(m,l)
j=m[l]
if(k!=null)o.h(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.h(0,a,o)
h=A.m(a.length)
for(s=J.an(i),l=0;l<h;++l)o.push(this.$1(s.l(i,l)))
return o}return a},
$S:10}
A.j0.prototype={
i6(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=a.length
for(s=0;s<f;++s){r=a[s]
if(r>g.b)g.b=r
if(r<g.c)g.c=r}r=g.b
q=B.a.V(1,r)
p=g.a=new Uint32Array(q)
for(o=1,n=0,m=2;o<=r;){for(l=o<<16,s=0;s<f;++s)if(a[s]===o){for(k=n,j=0,i=0;i<o;++i){j=(j<<1|k&1)>>>0
k=k>>>1}for(h=(l|s)>>>0,i=j;i<q;i+=m){if(!(i>=0))return A.a(p,i)
p[i]=h}++n}++o
n=n<<1>>>0
m=m<<1>>>0}}}
A.ks.prototype={}
A.l_.prototype={
la(a,b,c,d){var s,r,q,p,o,n,m=null
for(;;){s=a.c
r=a.d
r===$&&A.c("_length")
if(!(s<r))break
r=a.b
r.toString
q=a.c=s+1
p=r.length
if(!(s>=0&&s<p))return A.a(r,s)
o=r[s]
a.c=q+1
if(!(q>=0&&q<p))return A.a(r,q)
n=r[q]
if((o&8)!==8)return!1
if(B.a.a8(o*256+n,31)!==0)return!1
if((n>>>5&1)!==0){a.k()
return!1}if(m!=null)b.a5(m)
s=new A.eA(new Uint8Array(32768),B.ad)
new A.j9(a,s).jJ()
m=J.B(B.d.gB(s.c),s.c.byteOffset,s.b)
a.k()}if(m!=null)b.a5(m)
return!0}}
A.kt.prototype={}
A.l0.prototype={
hm(a,b){var s
t.L.a(a)
s=A.nB(B.a2,32768)
this.le(A.ja(a,B.ad,null,null),s,b,!1,null)
return s.cC()},
le(a,b,c,d,e){var s,r,q,p,o,n,m,l,k
b.a=B.a2
s=(B.a.G(15,0,15)-8<<4|8)>>>0
b.m(s)
r=s*256
for(q=0;p=(q|0)>>>0,B.a.a8(r+p,31)!==0;)++q
b.m(p)
o=a.c
n=A.ug(a)
a.c=o
A.ps(a,6,b,15)
p=n&255
m=n>>>24&255
l=n>>>16&255
k=n>>>8&255
if(b.a===B.a2){b.m(m)
b.m(l)
b.m(k)
b.m(p)}else{b.m(p)
b.m(k)
b.m(l)
b.m(m)}}}
A.dG.prototype={
a7(){return"_DeflateFlushMode."+this.b}}
A.iP.prototype={
jK(a,b){var s,r,q,p,o=this,n=!0
if(b>=9)if(b<=15)n=a>9
if(n)return!1
s=o.jD(a)
if(s==null)return!1
$.bh.b=s
n=new Uint16Array(1146)
o.p1=n
r=new Uint16Array(122)
o.p2=r
q=new Uint16Array(78)
o.p3=q
o.as=b
p=o.Q=B.a.R(1,b)
o.at=p-1
o.db=15
o.cy=32768
o.dx=32767
o.dy=5
o.ax=new Uint8Array(p*2)
o.ch=new Uint16Array(p)
o.CW=new Uint16Array(32768)
o.y1=16384
o.f=new Uint8Array(65536)
o.r=65536
o.bJ=16384
o.xr=49152
o.k4=a
o.w=o.x=o.ok=0
o.c=113
o.d=0
p=o.p4
p.a=n
p.c=$.p1()
p=o.R8
p.a=r
p.c=$.p0()
p=o.RG
p.a=q
p.c=$.p_()
o.bd=o.aY=0
o.bU=8
o.fi()
o.ay=2*o.Q
B.C.ac(o.CW,0,o.cy,0)
o.k2=o.fr=o.id=0
o.fx=o.k3=2
o.cx=o.go=0
return!0},
jd(a){var s,r,q,p,o=this,n=o.x
n===$&&A.c("_pending")
if(n!==0)o.dW()
n=o.a
s=n.c
n=n.d
n===$&&A.c("_length")
r=!0
if(s>=n){n=o.k2
n===$&&A.c("_lookAhead")
if(n===0)n=a!==B.aC&&o.c!==666
else n=r}else n=r
if(n){switch($.bh.cN().e){case 0:q=o.jg(a)
break
case 1:q=o.je(a)
break
case 2:q=o.jf(a)
break
default:q=-1
break}n=q===2
if(n||q===3)o.c=666
if(q===0||n)return 0
if(q===1){if(a===B.m3){o.aI(2,3)
o.cv(256,B.am)
o.hb()
n=o.bU
n===$&&A.c("_lastEOBLen")
s=o.bd
s===$&&A.c("_numValidBits")
if(1+n+10-s<9){o.aI(2,3)
o.cv(256,B.am)
o.hb()}o.bU=7}else{o.fL(0,0,!1)
if(a===B.m4){n=o.cy
n===$&&A.c("_hashSize")
s=o.CW
p=0
for(;p<n;++p){s===$&&A.c("_head")
s.$flags&2&&A.b(s)
if(!(p<s.length))return A.a(s,p)
s[p]=0}}}o.dW()}}if(a!==B.aa)return 0
return 1},
fi(){var s=this,r=s.p1
r===$&&A.c("_dynamicLengthTree")
B.C.ac(r,0,572,0)
r=s.p2
r===$&&A.c("_dynamicDistTree")
B.C.ac(r,0,60,0)
r=s.p3
r===$&&A.c("_bitLengthTree")
B.C.ac(r,0,38,0)
r=s.p1
r.$flags&2&&A.b(r)
r[512]=1
s.y2=s.cn=s.aT=s.bK=0},
e4(a,b){var s,r,q,p,o,n,m=this.ry
if(!(b>=0&&b<573))return A.a(m,b)
s=m[b]
r=b<<1>>>0
q=m.$flags|0
p=this.x2
for(;;){o=this.to
o===$&&A.c("_heapLen")
if(!(r<=o))break
if(r<o){o=r+1
if(!(o>=0&&o<573))return A.a(m,o)
o=m[o]
if(!(r>=0&&r<573))return A.a(m,r)
o=A.n9(a,o,m[r],p)}else o=!1
if(o)++r
if(!(r>=0&&r<573))return A.a(m,r)
if(A.n9(a,s,m[r],p))break
o=m[r]
q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=o
n=r<<1>>>0
b=r
r=n}q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=s},
fE(a,b){var s,r,q,p,o,n,m,l,k,j,i,h="_bitLengthTree",g=a.length
if(1>=g)return A.a(a,1)
s=a[1]
if(s===0){r=138
q=3}else{r=7
q=4}p=(b+1)*2+1
a.$flags&2&&A.b(a)
if(!(p>=0&&p<g))return A.a(a,p)
a[p]=65535
for(p=this.p3,o=0,n=-1,m=0;o<=b;s=k){++o
l=o*2+1
if(!(l<g))return A.a(a,l)
k=a[l];++m
if(m<r&&s===k)continue
else{j=3
if(m<q){p===$&&A.c(h)
l=s*2
if(!(l<78))return A.a(p,l)
i=p[l]
p.$flags&2&&A.b(p)
p[l]=i+m}else if(s!==0){if(s!==n){p===$&&A.c(h)
l=s*2
if(!(l<78))return A.a(p,l)
i=p[l]
p.$flags&2&&A.b(p)
p[l]=i+1}p===$&&A.c(h)
l=p[32]
p.$flags&2&&A.b(p)
p[32]=l+1}else if(m<=10){p===$&&A.c(h)
l=p[34]
p.$flags&2&&A.b(p)
p[34]=l+1}else{p===$&&A.c(h)
l=p[36]
p.$flags&2&&A.b(p)
p[36]=l+1}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
iz(){var s,r,q=this,p=q.p1
p===$&&A.c("_dynamicLengthTree")
s=q.p4.b
s===$&&A.c("maxCode")
q.fE(p,s)
s=q.p2
s===$&&A.c("_dynamicDistTree")
p=q.R8.b
p===$&&A.c("maxCode")
q.fE(s,p)
q.RG.dK(q)
for(p=q.p3,r=18;r>=3;--r){p===$&&A.c("_bitLengthTree")
s=B.au[r]*2+1
if(!(s<78))return A.a(p,s)
if(p[s]!==0)break}p=q.aT
p===$&&A.c("_optimalLen")
q.aT=p+(3*(r+1)+5+5+4)
return r},
kJ(a,b,c){var s,r,q,p,o=this
o.aI(a-257,5)
s=b-1
o.aI(s,5)
o.aI(c-4,4)
for(r=0;r<c;++r){q=o.p3
q===$&&A.c("_bitLengthTree")
if(!(r<19))return A.a(B.au,r)
p=B.au[r]*2+1
if(!(p<78))return A.a(q,p)
o.aI(q[p],3)}q=o.p1
q===$&&A.c("_dynamicLengthTree")
o.fF(q,a-1)
q=o.p2
q===$&&A.c("_dynamicDistTree")
o.fF(q,s)},
fF(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_bitLengthTree",d=a.length
if(1>=d)return A.a(a,1)
s=a[1]
if(s===0){r=138
q=3}else{r=7
q=4}for(p=t.L,o=0,n=-1,m=0;o<=b;s=k){++o
l=o*2+1
if(!(l<d))return A.a(a,l)
k=a[l];++m
if(m<r&&s===k)continue
else{j=3
if(m<q){l=s*2
i=l+1
do{h=f.p3
h===$&&A.c(e)
p.a(h)
if(!(l<78))return A.a(h,l)
g=h[l]
if(!(i<78))return A.a(h,i)
f.aI(g&65535,h[i]&65535)}while(--m,m!==0)}else if(s!==0){if(s!==n){l=f.p3
l===$&&A.c(e)
p.a(l)
i=s*2
if(!(i<78))return A.a(l,i)
h=l[i];++i
if(!(i<78))return A.a(l,i)
f.aI(h&65535,l[i]&65535);--m}l=f.p3
l===$&&A.c(e)
p.a(l)
f.aI(l[32]&65535,l[33]&65535)
f.aI(m-3,2)}else{l=f.p3
if(m<=10){l===$&&A.c(e)
p.a(l)
f.aI(l[34]&65535,l[35]&65535)
f.aI(m-3,3)}else{l===$&&A.c(e)
p.a(l)
f.aI(l[36]&65535,l[37]&65535)
f.aI(m-11,7)}}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
kh(a,b,c){var s,r,q=this
if(c===0)return
s=q.f
s===$&&A.c("_pendingBuffer")
r=q.x
r===$&&A.c("_pending")
B.d.ar(s,r,r+c,a,b)
q.x=q.x+c},
bl(a){var s,r=this.f
r===$&&A.c("_pendingBuffer")
s=this.x
s===$&&A.c("_pending")
this.x=s+1
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a},
cv(a,b){var s,r,q
t.L.a(b)
s=a*2
r=b.length
if(!(s<r))return A.a(b,s)
q=b[s];++s
if(!(s<r))return A.a(b,s)
this.aI(q&65535,b[s]&65535)},
aI(a,b){var s,r=this,q="_bitBuffer",p=r.bd
p===$&&A.c("_numValidBits")
s=r.aY
if(p>16-b){s===$&&A.c(q)
p=r.aY=(s|B.a.V(a,p)&65535)>>>0
r.bl(p)
r.bl(A.aE(p,8))
r.aY=A.aE(a,16-r.bd)
r.bd=r.bd+(b-16)}else{s===$&&A.c(q)
r.aY=(s|B.a.V(a,p)&65535)>>>0
r.bd=p+b}},
cP(a,b){var s,r,q,p,o,n=this,m="_dynamicLengthTree",l="_matches",k="_dynamicDistTree",j=n.f
j===$&&A.c("_pendingBuffer")
s=n.bJ
s===$&&A.c("_dbuf")
r=n.y2
r===$&&A.c("_lastLit")
r=s+r*2
s=A.aE(a,8)
j.$flags&2&&A.b(j)
if(!(r<j.length))return A.a(j,r)
j[r]=s
s=n.f
r=n.bJ
j=n.y2
r=r+j*2+1
s.$flags&2&&A.b(s)
q=s.length
if(!(r<q))return A.a(s,r)
s[r]=a
r=n.xr
r===$&&A.c("_lbuf")
r+=j
if(!(r<q))return A.a(s,r)
s[r]=b
n.y2=j+1
if(a===0){j=n.p1
j===$&&A.c(m)
s=b*2
if(!(s>=0&&s<1146))return A.a(j,s)
r=j[s]
j.$flags&2&&A.b(j)
j[s]=r+1}else{j=n.cn
j===$&&A.c(l)
n.cn=j+1
j=n.p1
j===$&&A.c(m)
if(!(b>=0&&b<256))return A.a(B.aS,b)
s=(B.aS[b]+256+1)*2
if(!(s<1146))return A.a(j,s)
r=j[s]
j.$flags&2&&A.b(j)
j[s]=r+1
r=n.p2
r===$&&A.c(k)
s=A.nX(a-1)*2
if(!(s<122))return A.a(r,s)
j=r[s]
r.$flags&2&&A.b(r)
r[s]=j+1}j=n.y2
if((j&8191)===0){s=n.k4
s===$&&A.c("_level")
s=s>2}else s=!1
if(s){p=j*8
j=n.id
j===$&&A.c("_strStart")
s=n.fr
s===$&&A.c("_blockStart")
for(r=n.p2,o=0;o<30;++o){r===$&&A.c(k)
q=o*2
if(!(q<122))return A.a(r,q)
p+=r[q]*(5+B.a4[o])}p=A.aE(p,3)
r=n.cn
r===$&&A.c(l)
q=n.y2
if(r<q/2&&p<(j-s)/2)return!0
j=q}s=n.y1
s===$&&A.c("_litBufferSize")
return j===s-1},
eU(a,b){var s,r,q,p,o,n,m,l,k=this,j=t.L
j.a(a)
j.a(b)
j=k.y2
j===$&&A.c("_lastLit")
if(j!==0){s=0
do{j=k.f
j===$&&A.c("_pendingBuffer")
r=k.bJ
r===$&&A.c("_dbuf")
r+=s*2
q=j.length
if(!(r<q))return A.a(j,r)
p=j[r];++r
if(!(r<q))return A.a(j,r)
o=p<<8&65280|j[r]&255
r=k.xr
r===$&&A.c("_lbuf")
r+=s
if(!(r<q))return A.a(j,r)
n=j[r]&255;++s
if(o===0)k.cv(n,a)
else{m=B.aS[n]
k.cv(m+256+1,a)
if(!(m<29))return A.a(B.aN,m)
l=B.aN[m]
if(l!==0)k.aI(n-B.dW[m],l);--o
m=A.nX(o)
k.cv(m,b)
if(!(m<30))return A.a(B.a4,m)
l=B.a4[m]
if(l!==0)k.aI(o-B.f2[m],l)}}while(s<k.y2)}k.cv(256,a)
if(513>=a.length)return A.a(a,513)
k.bU=a[513]},
hP(){var s,r,q,p,o,n="_dynamicLengthTree"
for(s=this.p1,r=0,q=0;r<7;){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}for(o=0;r<128;){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
o+=s[p];++r}while(r<256){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}this.y=q>A.aE(o,2)?0:1},
hb(){var s=this,r="_bitBuffer",q=s.bd
q===$&&A.c("_numValidBits")
if(q===16){q=s.aY
q===$&&A.c(r)
s.bl(q)
s.bl(A.aE(q,8))
s.bd=s.aY=0}else if(q>=8){q=s.aY
q===$&&A.c(r)
s.bl(q)
s.aY=A.aE(s.aY,8)
s.bd=s.bd-8}},
eK(){var s=this,r="_bitBuffer",q=s.bd
q===$&&A.c("_numValidBits")
if(q>8){q=s.aY
q===$&&A.c(r)
s.bl(q)
s.bl(A.aE(q,8))}else if(q>0){q=s.aY
q===$&&A.c(r)
s.bl(q)}s.bd=s.aY=0},
c1(a){var s,r,q,p,o,n=this,m=n.fr
m===$&&A.c("_blockStart")
if(m>=0)s=m
else s=-1
r=n.id
r===$&&A.c("_strStart")
m=r-m
r=n.k4
r===$&&A.c("_level")
if(r>0){if(n.y===2)n.hP()
n.p4.dK(n)
n.R8.dK(n)
q=n.iz()
r=n.aT
r===$&&A.c("_optimalLen")
p=A.aE(r+3+7,3)
r=n.bK
r===$&&A.c("_staticLen")
o=A.aE(r+3+7,3)
if(o<=p)p=o}else{o=m+5
p=o
q=0}if(m+4<=p&&s!==-1)n.fL(s,m,a)
else if(o===p){n.aI(2+(a?1:0),3)
n.eU(B.am,B.bK)}else{n.aI(4+(a?1:0),3)
m=n.p4.b
m===$&&A.c("maxCode")
s=n.R8.b
s===$&&A.c("maxCode")
n.kJ(m+1,s+1,q+1)
s=n.p1
s===$&&A.c("_dynamicLengthTree")
m=n.p2
m===$&&A.c("_dynamicDistTree")
n.eU(s,m)}n.fi()
if(a)n.eK()
n.fr=n.id
n.dW()},
jg(a){var s,r,q,p,o,n=this,m=n.r
m===$&&A.c("_pendingBufferSize")
s=m-5
s=65535>s?s:65535
for(m=a===B.aC;;){r=n.k2
r===$&&A.c("_lookAhead")
if(r<=1){n.dV()
r=n.k2
q=r===0
if(q&&m)return 0
if(q)break}q=n.id
q===$&&A.c("_strStart")
r=n.id=q+r
n.k2=0
q=n.fr
q===$&&A.c("_blockStart")
p=q+s
if(r>=p){n.k2=r-p
n.id=p
n.c1(!1)}r=n.id
q=n.fr
o=n.Q
o===$&&A.c("_windowSize")
if(r-q>=o-262)n.c1(!1)}m=a===B.aa
n.c1(m)
return m?3:1},
fL(a,b,c){var s,r=this
r.aI(c?1:0,3)
r.eK()
r.bU=8
r.bl(b)
r.bl(A.aE(b,8))
s=(~b>>>0)+65536&65535
r.bl(s)
r.bl(A.aE(s,8))
s=r.ax
s===$&&A.c("_window")
r.kh(s,a,b)},
dV(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_windowSize",f=h.a
do{s=h.ay
s===$&&A.c("_actualWindowSize")
r=h.k2
r===$&&A.c("_lookAhead")
q=h.id
q===$&&A.c("_strStart")
p=s-r-q
if(p===0&&q===0&&r===0){s=h.Q
s===$&&A.c(g)
p=s}else{s=h.Q
s===$&&A.c(g)
if(q>=s+s-262){r=h.ax
r===$&&A.c("_window")
B.d.ar(r,0,s,r,s)
s=h.k1
o=h.Q
h.k1=s-o
h.id=h.id-o
s=h.fr
s===$&&A.c("_blockStart")
h.fr=s-o
s=h.cy
s===$&&A.c("_hashSize")
r=h.CW
r===$&&A.c("_head")
q=r.length
n=r.$flags|0
m=s
l=m
do{--m
if(!(m>=0&&m<q))return A.a(r,m)
k=r[m]&65535
s=k>=o?k-o:0
n&2&&A.b(r)
r[m]=s}while(--l,l!==0)
s=h.ch
s===$&&A.c("_prev")
r=s.length
q=s.$flags|0
m=o
l=m
do{--m
if(!(m>=0&&m<r))return A.a(s,m)
k=s[m]&65535
n=k>=o?k-o:0
q&2&&A.b(s)
s[m]=n}while(--l,l!==0)
p+=o}}s=f.c
r=f.d
r===$&&A.c("_length")
if(s>=r)return
s=h.ax
s===$&&A.c("_window")
l=h.kk(s,h.id+h.k2,p)
s=h.k2=h.k2+l
if(s>=3){r=h.ax
q=h.id
n=r.length
if(q>>>0!==q||q>=n)return A.a(r,q)
j=r[q]&255
h.cx=j
i=h.dy
i===$&&A.c("_hashShift")
i=B.a.V(j,i);++q
if(!(q<n))return A.a(r,q)
q=r[q]
r=h.dx
r===$&&A.c("_hashMask")
h.cx=((i^q&255)&r)>>>0}}while(s<262&&!(f.c>=f.d))},
je(a){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_insertHash",f="_hashShift",e="_window",d="_strStart",c="_hashMask",b="_windowMask"
for(s=a===B.aC,r=$.bh.a,q=0;;){p=h.k2
p===$&&A.c("_lookAhead")
if(p<262){h.dV()
p=h.k2
if(p<262&&s)return 0
if(p===0)break}if(p>=3){p=h.cx
p===$&&A.c(g)
o=h.dy
o===$&&A.c(f)
o=B.a.V(p,o)
p=h.ax
p===$&&A.c(e)
n=h.id
n===$&&A.c(d)
m=n+2
if(!(m>=0&&m<p.length))return A.a(p,m)
m=p[m]
p=h.dx
p===$&&A.c(c)
p=((o^m&255)&p)>>>0
h.cx=p
m=h.CW
m===$&&A.c("_head")
if(!(p<m.length))return A.a(m,p)
o=m[p]
q=o&65535
l=h.ch
l===$&&A.c("_prev")
k=h.at
k===$&&A.c(b)
k=(n&k)>>>0
l.$flags&2&&A.b(l)
if(!(k>=0&&k<l.length))return A.a(l,k)
l[k]=o
m.$flags&2&&A.b(m)
m[p]=n}if(q!==0){p=h.id
p===$&&A.c(d)
o=h.Q
o===$&&A.c("_windowSize")
o=(p-q&65535)<=o-262
p=o}else p=!1
if(p){p=h.ok
p===$&&A.c("_strategy")
if(p!==2)h.fx=h.fo(q)}p=h.fx
p===$&&A.c("_matchLength")
o=h.id
if(p>=3){o===$&&A.c(d)
j=h.cP(o-h.k1,p-3)
p=h.k2
o=h.fx
p-=o
h.k2=p
n=$.bh.b
if(n===$.bh)A.ax(A.jj(r))
if(o<=n.b&&p>=3){p=h.fx=o-1
do{o=h.id=h.id+1
n=h.cx
n===$&&A.c(g)
m=h.dy
m===$&&A.c(f)
m=B.a.V(n,m)
n=h.ax
n===$&&A.c(e)
l=o+2
if(!(l>=0&&l<n.length))return A.a(n,l)
l=n[l]
n=h.dx
n===$&&A.c(c)
n=((m^l&255)&n)>>>0
h.cx=n
l=h.CW
l===$&&A.c("_head")
if(!(n<l.length))return A.a(l,n)
m=l[n]
q=m&65535
k=h.ch
k===$&&A.c("_prev")
i=h.at
i===$&&A.c(b)
i=(o&i)>>>0
k.$flags&2&&A.b(k)
if(!(i>=0&&i<k.length))return A.a(k,i)
k[i]=m
l.$flags&2&&A.b(l)
l[n]=o}while(p=h.fx=p-1,p!==0)
h.id=o+1}else{p=h.id=h.id+o
h.fx=0
o=h.ax
o===$&&A.c(e)
n=o.length
if(!(p>=0&&p<n))return A.a(o,p)
m=o[p]&255
h.cx=m
l=h.dy
l===$&&A.c(f)
l=B.a.V(m,l);++p
if(!(p<n))return A.a(o,p)
p=o[p]
o=h.dx
o===$&&A.c(c)
h.cx=((l^p&255)&o)>>>0}}else{p=h.ax
p===$&&A.c(e)
o===$&&A.c(d)
if(!(o>=0&&o<p.length))return A.a(p,o)
j=h.cP(0,p[o]&255)
h.k2=h.k2-1
h.id=h.id+1}if(j)h.c1(!1)}s=a===B.aa
h.c1(s)
return s?3:1},
jf(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_insertHash",e="_hashShift",d="_window",c="_strStart",b="_hashMask",a="_windowMask",a0="_matchAvailable"
for(s=a1===B.aC,r=$.bh.a,q=0;;){p=g.k2
p===$&&A.c("_lookAhead")
if(p<262){g.dV()
p=g.k2
if(p<262&&s)return 0
if(p===0)break}if(p>=3){p=g.cx
p===$&&A.c(f)
o=g.dy
o===$&&A.c(e)
o=B.a.V(p,o)
p=g.ax
p===$&&A.c(d)
n=g.id
n===$&&A.c(c)
m=n+2
if(!(m>=0&&m<p.length))return A.a(p,m)
m=p[m]
p=g.dx
p===$&&A.c(b)
p=((o^m&255)&p)>>>0
g.cx=p
m=g.CW
m===$&&A.c("_head")
if(!(p<m.length))return A.a(m,p)
o=m[p]
q=o&65535
l=g.ch
l===$&&A.c("_prev")
k=g.at
k===$&&A.c(a)
k=(n&k)>>>0
l.$flags&2&&A.b(l)
if(!(k>=0&&k<l.length))return A.a(l,k)
l[k]=o
m.$flags&2&&A.b(m)
m[p]=n}p=g.fx
p===$&&A.c("_matchLength")
g.k3=p
g.fy=g.k1
g.fx=2
o=!1
if(q!==0){n=$.bh.b
if(n===$.bh)A.ax(A.jj(r))
if(p<n.b){p=g.id
p===$&&A.c(c)
o=g.Q
o===$&&A.c("_windowSize")
o=(p-q&65535)<=o-262
p=o}else p=o}else p=o
o=2
if(p){p=g.ok
p===$&&A.c("_strategy")
if(p!==2){p=g.fo(q)
g.fx=p}else p=o
n=!1
if(p<=5)if(g.ok!==1){if(p===3){n=g.id
n===$&&A.c(c)
n=n-g.k1>4096}}else n=!0
if(n){g.fx=2
p=o}}else p=o
o=g.k3
if(o>=3&&p<=o){p=g.id
p===$&&A.c(c)
j=p+g.k2-3
i=g.cP(p-1-g.fy,o-3)
o=g.k2
p=g.k3
g.k2=o-(p-1)
p=g.k3=p-2
do{o=g.id=g.id+1
if(o<=j){n=g.cx
n===$&&A.c(f)
m=g.dy
m===$&&A.c(e)
m=B.a.V(n,m)
n=g.ax
n===$&&A.c(d)
l=o+2
if(!(l>=0&&l<n.length))return A.a(n,l)
l=n[l]
n=g.dx
n===$&&A.c(b)
n=((m^l&255)&n)>>>0
g.cx=n
l=g.CW
l===$&&A.c("_head")
if(!(n<l.length))return A.a(l,n)
m=l[n]
q=m&65535
k=g.ch
k===$&&A.c("_prev")
h=g.at
h===$&&A.c(a)
h=(o&h)>>>0
k.$flags&2&&A.b(k)
if(!(h>=0&&h<k.length))return A.a(k,h)
k[h]=m
l.$flags&2&&A.b(l)
l[n]=o}}while(p=g.k3=p-1,p!==0)
g.go=0
g.fx=2
g.id=o+1
if(i)g.c1(!1)}else{p=g.go
p===$&&A.c(a0)
if(p!==0){p=g.ax
p===$&&A.c(d)
o=g.id
o===$&&A.c(c);--o
if(!(o>=0&&o<p.length))return A.a(p,o)
if(g.cP(0,p[o]&255))g.c1(!1)
g.id=g.id+1
g.k2=g.k2-1}else{g.go=1
p=g.id
p===$&&A.c(c)
g.id=p+1
g.k2=g.k2-1}}}s=g.go
s===$&&A.c(a0)
if(s!==0){s=g.ax
s===$&&A.c(d)
r=g.id
r===$&&A.c(c);--r
if(!(r>=0&&r<s.length))return A.a(s,r)
g.cP(0,s[r]&255)
g.go=0}s=a1===B.aa
g.c1(s)
return s?3:1},
fo(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=$.bh.cN().d,a=c.id
a===$&&A.c("_strStart")
s=c.k3
s===$&&A.c("_prevLength")
r=c.Q
r===$&&A.c("_windowSize")
r-=262
q=a>r?a-r:0
p=$.bh.cN().c
r=c.at
r===$&&A.c("_windowMask")
o=c.id+258
n=c.ax
n===$&&A.c("_window")
m=a+s
l=m-1
k=n.length
if(!(l>=0&&l<k))return A.a(n,l)
j=n[l]
if(!(m>=0&&m<k))return A.a(n,m)
i=n[m]
if(c.k3>=$.bh.cN().a)b=b>>>2
n=c.k2
n===$&&A.c("_lookAhead")
if(p>n)p=n
h=o-258
g=s
f=a
do{A:{a=c.ax
s=a0+g
n=a.length
if(!(s>=0&&s<n))return A.a(a,s)
m=!0
if(a[s]===i){--s
if(!(s>=0))return A.a(a,s)
if(a[s]===j){if(!(a0>=0&&a0<n))return A.a(a,a0)
s=a[a0]
if(!(f>=0&&f<n))return A.a(a,f)
if(s===a[f]){e=a0+1
if(!(e<n))return A.a(a,e)
s=a[e]
m=f+1
if(!(m<n))return A.a(a,m)
m=s!==a[m]
s=m}else{s=m
e=a0}}else{s=m
e=a0}}else{s=m
e=a0}if(s)break A
f+=2;++e
do{++f
if(!(f>=0&&f<n))return A.a(a,f)
s=a[f];++e
if(!(e>=0&&e<n))return A.a(a,e)
m=!1
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
if(s===a[e]){++f
if(!(f<n))return A.a(a,f)
s=a[f];++e
if(!(e<n))return A.a(a,e)
s=s===a[e]&&f<o}else s=m}else s=m}else s=m}else s=m}else s=m}else s=m}else s=m}while(s)
d=258-(o-f)
if(d>g){c.k1=a0
if(d>=p){g=d
break}a=c.ax
s=h+d
n=s-1
m=a.length
if(!(n>=0&&n<m))return A.a(a,n)
j=a[n]
if(!(s<m))return A.a(a,s)
i=a[s]
g=d}f=h}a=c.ch
a===$&&A.c("_prev")
s=a0&r
if(!(s>=0&&s<a.length))return A.a(a,s)
a0=a[s]&65535
if(a0>q){--b
a=b!==0}else a=!1}while(a)
a=c.k2
if(g<=a)return g
return a},
kk(a,b,c){var s,r,q,p,o,n,m=this
if(c!==0){s=m.a
r=s.c
s=s.d
s===$&&A.c("_length")
s=r>=s}else s=!0
if(s)return 0
q=m.a.am(c)
p=q.gA(0)
if(p===0)return 0
o=q.a4()
n=o.length
if(p>n)p=n
B.d.ba(a,b,b+p,o)
m.e+=p
m.d=A.bt(o,m.d)
return p},
dW(){var s,r=this,q=r.x
q===$&&A.c("_pending")
s=r.f
s===$&&A.c("_pendingBuffer")
r.b.hH(s,q)
s=r.w
s===$&&A.c("_pendingOut")
r.w=s+q
q=r.x-q
r.x=q
if(q===0)r.w=0},
jD(a){switch(a){case 0:return new A.b_(0,0,0,0,0)
case 1:return new A.b_(4,4,8,4,1)
case 2:return new A.b_(4,5,16,8,1)
case 3:return new A.b_(4,6,32,32,1)
case 4:return new A.b_(4,4,16,16,2)
case 5:return new A.b_(8,16,32,32,2)
case 6:return new A.b_(8,16,128,128,2)
case 7:return new A.b_(8,32,128,256,2)
case 8:return new A.b_(32,128,258,1024,2)
case 9:return new A.b_(32,258,258,4096,2)}return null}}
A.b_.prototype={}
A.kL.prototype={
jA(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3="_optimalLen",a4=a2.a
a4===$&&A.c("dynamicTree")
s=a2.c
s===$&&A.c("staticDesc")
r=s.a
q=s.b
p=s.c
o=s.e
for(s=a5.rx,n=s.$flags|0,m=0;m<=15;++m){n&2&&A.b(s)
s[m]=0}l=a5.ry
k=a5.x1
k===$&&A.c("_heapMax")
if(!(k>=0&&k<573))return A.a(l,k)
j=l[k]*2+1
a4.$flags&2&&A.b(a4)
i=a4.length
if(!(j>=0&&j<i))return A.a(a4,j)
a4[j]=0
for(h=k+1,k=r!=null,j=q.length,g=0;h<573;++h){f=l[h]
e=f*2
d=e+1
if(!(d>=0&&d<i))return A.a(a4,d)
c=a4[d]*2+1
if(!(c<i))return A.a(a4,c)
m=a4[c]+1
if(m>o){++g
m=o}a4.$flags&2&&A.b(a4)
a4[d]=m
c=a2.b
c===$&&A.c("maxCode")
if(f>c)continue
if(!(m<16))return A.a(s,m)
c=s[m]
n&2&&A.b(s)
s[m]=c+1
if(f>=p){c=f-p
if(!(c>=0&&c<j))return A.a(q,c)
b=q[c]}else b=0
if(!(e>=0&&e<i))return A.a(a4,e)
a=a4[e]
e=a5.aT
e===$&&A.c(a3)
a5.aT=e+a*(m+b)
if(k){e=a5.bK
e===$&&A.c("_staticLen")
if(!(d<r.length))return A.a(r,d)
a5.bK=e+a*(r[d]+b)}}if(g===0)return
m=o-1
do{a0=m
for(;;){if(!(a0>=0&&a0<16))return A.a(s,a0)
k=s[a0]
if(!(k===0))break;--a0}n&2&&A.b(s)
s[a0]=k-1
k=a0+1
if(!(k<16))return A.a(s,k)
s[k]=s[k]+2
if(!(o<16))return A.a(s,o)
s[o]=s[o]-1
g-=2}while(g>0)
for(m=o;m!==0;--m){if(!(m>=0))return A.a(s,m)
f=s[m]
while(f!==0){--h
if(!(h>=0&&h<573))return A.a(l,h)
a1=l[h]
n=a2.b
n===$&&A.c("maxCode")
if(a1>n)continue
n=a1*2
k=n+1
if(!(k>=0&&k<i))return A.a(a4,k)
j=a4[k]
if(j!==m){e=a5.aT
e===$&&A.c(a3)
if(!(n>=0&&n<i))return A.a(a4,n)
a5.aT=e+(m-j)*a4[n]
a4.$flags&2&&A.b(a4)
a4[k]=m}--f}}},
dK(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.a
a0===$&&A.c("dynamicTree")
s=a.c
s===$&&A.c("staticDesc")
r=s.a
q=s.d
a1.to=0
a1.x1=573
for(s=a0.length,p=a1.ry,o=p.$flags|0,n=a1.x2,m=n.$flags|0,l=a0.$flags|0,k=0,j=-1;k<q;++k){i=k*2
if(!(i<s))return A.a(a0,i)
if(a0[i]!==0){i=++a1.to
o&2&&A.b(p)
if(!(i>=0&&i<573))return A.a(p,i)
p[i]=k
m&2&&A.b(n)
if(!(k<573))return A.a(n,k)
n[k]=0
j=k}else{++i
l&2&&A.b(a0)
if(!(i<s))return A.a(a0,i)
a0[i]=0}}for(i=r!=null;h=a1.to,h<2;){++h
a1.to=h
if(j<2){++j
g=j}else g=0
o&2&&A.b(p)
if(!(h>=0))return A.a(p,h)
p[h]=g
h=g*2
l&2&&A.b(a0)
if(!(h>=0&&h<s))return A.a(a0,h)
a0[h]=1
m&2&&A.b(n)
if(!(g>=0))return A.a(n,g)
n[g]=0
f=a1.aT
f===$&&A.c("_optimalLen")
a1.aT=f-1
if(i){f=a1.bK
f===$&&A.c("_staticLen");++h
if(!(h<r.length))return A.a(r,h)
a1.bK=f-r[h]}}a.b=j
for(k=B.a.W(h,2);k>=1;--k)a1.e4(a0,k)
g=q
do{k=p[1]
i=a1.to--
if(!(i>=0&&i<573))return A.a(p,i)
i=p[i]
o&2&&A.b(p)
p[1]=i
a1.e4(a0,1)
e=p[1]
i=--a1.x1
if(!(i>=0&&i<573))return A.a(p,i)
p[i]=k;--i
a1.x1=i
if(!(i>=0))return A.a(p,i)
p[i]=e
i=g*2
h=k*2
if(!(h>=0&&h<s))return A.a(a0,h)
f=a0[h]
d=e*2
if(!(d>=0&&d<s))return A.a(a0,d)
c=a0[d]
l&2&&A.b(a0)
if(!(i<s))return A.a(a0,i)
a0[i]=f+c
if(!(k>=0&&k<573))return A.a(n,k)
c=n[k]
if(!(e>=0&&e<573))return A.a(n,e)
f=n[e]
i=c>f?c:f
m&2&&A.b(n)
if(!(g<573))return A.a(n,g)
n[g]=i+1;++h;++d
if(!(d<s))return A.a(a0,d)
a0[d]=g
if(!(h<s))return A.a(a0,h)
a0[h]=g
b=g+1
p[1]=g
a1.e4(a0,1)
if(a1.to>=2){g=b
continue}else break}while(!0)
s=--a1.x1
o=p[1]
if(!(s>=0&&s<573))return A.a(p,s)
p[s]=o
a.jA(a1)
A.rs(a0,j,a1.rx)}}
A.kR.prototype={}
A.j9.prototype={
gbG(){var s=this.a
if(s==null)return s
s.d===$&&A.c("_length")
return s},
jJ(){var s,r,q=this
q.e=q.d=0
if(q.gbG()==null)return
for(;;){s=q.gbG()
r=s.c
s=s.d
s===$&&A.c("_length")
if(!(r<s))break
if(!q.jX())return}},
jX(){var s,r,q,p=this,o=p.gbG()
if(o!=null){s=o.c
r=o.d
r===$&&A.c("_length")
r=s>=r
s=r}else s=!0
if(s)return!1
q=p.bm(3)
switch(B.a.j(q,1)){case 0:if(p.ka()===-1)return!1
break
case 1:if(p.f0($.oM(),$.oL())===-1)return!1
break
case 2:if(p.jY()===-1)return!1
break
default:return!1}return(q&1)===0},
bm(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.e,s<a){s=o.gbG()
r=s.c
s=s.d
s===$&&A.c("_length")
if(r>=s)return-1
s=o.gbG()
r=s.b
r.toString
s=s.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
q=r[s]
s=o.d
r=o.e
o.d=(s|B.a.V(q,r))>>>0
o.e=r+8}r=o.d
p=B.a.R(1,a)
o.d=B.a.a0(r,a)
o.e=s-a
return(r&p-1)>>>0},
e6(a){var s,r,q,p,o,n,m,l=this,k=a.a
k===$&&A.c("table")
s=a.b
while(r=l.e,r<s){r=l.gbG()
q=r.c
r=r.d
r===$&&A.c("_length")
if(q>=r)return-1
r=l.gbG()
q=r.b
q.toString
r=r.c++
if(!(r>=0&&r<q.length))return A.a(q,r)
p=q[r]
r=l.d
q=l.e
l.d=(r|B.a.V(p,q))>>>0
l.e=q+8}q=l.d
o=(q&B.a.V(1,s)-1)>>>0
if(!(o<k.length))return A.a(k,o)
n=k[o]
m=n>>>16
l.d=B.a.a0(q,m)
l.e=r-m
return n&65535},
ka(){var s,r,q=this
q.e=q.d=0
s=q.bm(16)
r=q.bm(16)
if(s!==0&&s!==(r^65535)>>>0)return-1
if(s>q.gbG().gA(0))return-1
q.c.lY(q.gbG().am(s))
return 0},
jY(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.bm(5)
if(h===-1)return-1
h+=257
if(h>288)return-1
s=i.bm(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=i.bm(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=i.bm(3)
if(o===-1)return-1
n=B.au[p]
if(!(n<19))return A.a(q,n)
q[n]=o}m=A.fX(q)
n=h+s
l=new Uint8Array(n)
k=J.B(B.d.gB(l),0,h)
j=J.B(B.d.gB(l),h,s)
if(i.iO(n,m,l)===-1)return-1
return i.f0(A.fX(k),A.fX(j))},
f0(a,b){var s,r,q,p,o,n,m=this
for(s=m.c;;){r=m.e6(a)
if(r<0||r>285)return-1
if(r===256)break
if(r<256){s.m(r&255)
continue}q=r-257
if(!(q>=0&&q<29))return A.a(B.c4,q)
p=B.c4[q]
o=m.bm(B.kP[q])
n=m.e6(b)
if(n<0||n>29)return-1
if(!(n>=0&&n<30))return A.a(B.c5,n)
s.lV(B.c5[n]+m.bm(B.a4[n]),p+o)}while(s=m.e,s>=8){m.e=s-8
s=m.gbG()
p=--s.c
o=s.d
o===$&&A.c("_length")
s.c=B.a.G(p,0,o)}return 0},
iO(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=0,r=0;r<a;){q=k.e6(b)
if(q===-1)return-1
p=0
switch(q){case 16:o=k.bm(2)
if(o===-1)return-1
o+=3
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=s}break
case 17:o=k.bm(3)
if(o===-1)return-1
o+=3
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
case 18:o=k.bm(7)
if(o===-1)return-1
o+=11
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
default:if(q<0||q>15)return-1
l=r+1
c.$flags&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=q
r=l
s=q
break}}return 0}}
A.kr.prototype={
c6(a){var s
t.L.a(a)
s=A.nB(B.ad,32768)
B.cZ.la(A.ja(a,B.a2,null,null),s,!1,!1)
return s.cC()}}
A.fF.prototype={
a7(){return"ByteOrder."+this.b}}
A.h5.prototype={
gA(a){var s=this.b
return s==null?0:s.length-this.c},
hZ(a,b){var s=this.b
if(s==null)return A.ja(A.j([],t.t),B.ad,null,null)
return A.ja(s,this.a,a,b)},
I(){var s,r=this.b
r.toString
s=this.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
a4(){var s,r,q,p=this,o=p.b
if(o==null)return new Uint8Array(0)
s=p.gA(0)
r=p.c
q=o.length
if(r+s>q)s=q-r
return J.B(B.d.gB(o),p.b.byteOffset+p.c,s)}}
A.h6.prototype={
k(){var s=this,r=s.I(),q=s.I(),p=s.I(),o=s.I()
if(s.a===B.a2)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
am(a){var s=this,r=s.hZ(a,s.c)
s.c=s.c+r.gA(0)
return r}}
A.eA.prototype={
cC(){return J.B(B.d.gB(this.c),this.c.byteOffset,this.b)},
m(a){var s,r,q=this
if(q.b===q.c.length)q.jV()
s=q.c
r=q.b++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
hH(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=a.length
while(s=o.b,r=s+b,q=o.c,p=q.length,r>p)o.dl(r-p)
B.d.ba(q,s,r,a)
o.b+=b},
a5(a){return this.hH(a,null)},
lY(a){var s,r,q,p,o,n,m=this
for(;;){s=m.b
r=a.b
q=r==null
p=q?0:r.length-a.c
o=m.c
n=o.length
if(!(s+p>n))break
m.dl(s+(q?0:r.length-a.c)-n)}if(!q)B.d.ar(o,s,s+a.gA(0),r,a.c)
m.b=m.b+a.gA(0)},
lV(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
while(s=i.b,r=s+b,q=i.c,p=q.length,r>p)i.dl(r-p)
o=s-a
if(a>=b)B.d.ar(q,s,r,q,o)
else for(n=q.$flags|0,m=o;s<r;s=l,m=k){l=s+1
k=m+1
if(!(m>=0&&m<p))return A.a(q,m)
j=q[m]
n&2&&A.b(q)
if(!(s>=0))return A.a(q,s)
q[s]=j}i.b+=b},
dl(a){var s,r=this.c,q=r.length,p=q+(a==null?1:a),o=q===0?32768:q*2
if(o<p)o=p
s=new Uint8Array(o)
B.d.ba(s,0,q,r)
this.c=s},
jV(){return this.dl(null)},
gA(a){return this.b}}
A.hA.prototype={}
A.iH.prototype={}
A.iI.prototype={
D(a){return"Exception: "+this.a}}
A.bx.prototype={
D(a){return"ColorTriplet("+A.z(this.a)+", "+A.z(this.b)+", "+A.z(this.c)+")"}}
A.iN.prototype={
a7(){return"Channel."+this.b}}
A.S.prototype={
E(){var s=this.b
return++this.a<s.gA(s)},
gN(){return this.b.l(0,this.a)},
$iA:1}
A.cU.prototype={
X(){return new A.cU(new Uint16Array(A.q(this.a)))},
gM(){return B.I},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=A.L(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){return this.gn()},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=A.L(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s,r=this.a
if(r.length>1){r=r[1]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
st(a){var s,r=this.a
if(r.length>1){s=A.L(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s,r=this.a
if(r.length>2){r=r[2]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
su(a){var s,r=this.a
if(r.length>2){s=A.L(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s,r=this.a
if(r.length>3){r=r[3]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
ga_(){return this.gv()/1},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=A.L(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.cV.prototype={
X(){return new A.cV(new Float32Array(A.q(this.a)))},
gM(){return B.Q},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.b(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s=this.a,r=s.length
if(r!==0){s.$flags&2&&A.b(s)
if(0>=r)return A.a(s,0)
s[0]=a}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s=this.a
if(s.length>1){s.$flags&2&&A.b(s)
s[1]=a}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s=this.a
if(s.length>2){s.$flags&2&&A.b(s)
s[2]=a}},
gv(){var s=this.a
return s.length>3?s[3]:1},
ga_(){return this.gv()/1},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.cW.prototype={
X(){return new A.cW(new Float64Array(A.q(this.a)))},
gM(){return B.T},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.b(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s=this.a,r=s.length
if(r!==0){s.$flags&2&&A.b(s)
if(0>=r)return A.a(s,0)
s[0]=a}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s=this.a
if(s.length>1){s.$flags&2&&A.b(s)
s[1]=a}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s=this.a
if(s.length>2){s.$flags&2&&A.b(s)
s[2]=a}},
gv(){var s=this.a
return s.length>3?s[3]:1},
ga_(){return this.gv()/1},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.cX.prototype={
X(){return new A.cX(new Int16Array(A.q(this.a)))},
gM(){return B.V},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gv()/32767},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.cY.prototype={
X(){return new A.cY(new Int32Array(A.q(this.a)))},
gM(){return B.W},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s=this.a,r=s.length
if(r!==0){A.m(a)
s.$flags&2&&A.b(s)
if(0>=r)return A.a(s,0)
s[0]=a}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gv()/2147483647},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.cZ.prototype={
X(){return new A.cZ(new Int8Array(A.q(this.a)))},
gM(){return B.U},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gv()/127},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.d_.prototype={
X(){var s=this.b
s===$&&A.c("data")
return new A.d_(this.a,s)},
gM(){return B.A},
gO(){return null},
cc(a){var s
if(a<this.a){s=this.b
s===$&&A.c("data")
s=B.a.a2(s,7-a)&1}else s=0
return s},
c_(a,b){var s
if(a>=this.a)return
a=7-a
s=this.b
s===$&&A.c("data")
this.b=b!==0?(s|B.a.V(1,a))>>>0:(s&~(B.a.V(1,a)&255))>>>0},
l(a,b){return this.cc(b)},
h(a,b,c){return this.c_(b,c)},
gU(){return this.cc(0)},
gn(){return this.cc(0)},
sn(a){this.c_(0,a)},
gt(){return this.cc(1)},
st(a){this.c_(1,a)},
gu(){return this.cc(2)},
su(a){this.c_(2,a)},
gv(){return this.cc(3)},
ga_(){return this.cc(3)/1},
gap(){return A.a_(this)},
aj(a){this.ag(a.gn(),a.gt(),a.gu(),a.gv())},
ag(a,b,c,d){var s=this
s.c_(0,a)
s.c_(1,b)
s.c_(2,c)
s.c_(3,d)},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1,
gA(a){return this.a}}
A.d0.prototype={
X(){return new A.d0(new Uint16Array(A.q(this.a)))},
gM(){return B.n},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gv()/65535},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.d1.prototype={
X(){var s=this.b
s===$&&A.c("data")
return new A.d1(this.a,s)},
gM(){return B.u},
gO(){return null},
cd(a){var s
if(a<this.a){s=this.b
s===$&&A.c("data")
s=B.a.a2(s,6-(a<<1>>>0))&3}else s=0
return s},
c0(a,b){var s,r,q
if(a>=this.a)return
if(!(a>=0&&a<4))return A.a(B.bw,a)
s=B.bw[a]
r=B.b.i(b)
q=this.b
q===$&&A.c("data")
this.b=(q&s|B.a.V(r&3,6-(a<<1>>>0)))>>>0},
l(a,b){return this.cd(b)},
h(a,b,c){return this.c0(b,c)},
gU(){return this.cd(0)},
gn(){return this.cd(0)},
sn(a){this.c0(0,a)},
gt(){return this.cd(1)},
st(a){this.c0(1,a)},
gu(){return this.cd(2)},
su(a){this.c0(2,a)},
gv(){return this.cd(3)},
ga_(){return this.cd(3)/3},
gap(){return A.a_(this)},
aj(a){this.ag(a.gn(),a.gt(),a.gu(),a.gv())},
ag(a,b,c,d){var s=this
s.c0(0,a)
s.c0(1,b)
s.c0(2,c)
s.c0(3,d)},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1,
gA(a){return this.a}}
A.d2.prototype={
X(){return new A.d2(new Uint32Array(A.q(this.a)))},
gM(){return B.R},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gv()/4294967295},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.d3.prototype={
X(){return new A.d3(this.a,new Uint8Array(A.q(this.b)))},
gM(){return B.B},
gO(){return null},
ce(a){var s,r
if(a<0||a>=this.a)s=0
else{s=this.b
r=s.length
if(a<2){if(0>=r)return A.a(s,0)
s=B.a.a2(s[0],4-(a<<2>>>0))&15}else{if(1>=r)return A.a(s,1)
s=B.a.a2(s[1],4-((a&1)<<2))&15}}return s},
c3(a,b){var s,r,q,p
if(a>=this.a)return
s=B.a.G(B.b.i(b),0,15)
if(a>1){a&=1
r=1}else r=0
if(a===0){q=this.b
if(!(r<q.length))return A.a(q,r)
p=q[r]
q.$flags&2&&A.b(q)
q[r]=(p&15|s<<4)>>>0}else if(a===1){q=this.b
if(!(r<q.length))return A.a(q,r)
p=q[r]
q.$flags&2&&A.b(q)
q[r]=(p&240|s)>>>0}},
l(a,b){return this.ce(b)},
h(a,b,c){return this.c3(b,c)},
gU(){return this.ce(0)},
gn(){return this.ce(0)},
sn(a){this.c3(0,a)},
gt(){return this.ce(1)},
st(a){this.c3(1,a)},
gu(){return this.ce(2)},
su(a){this.c3(2,a)},
gv(){return this.ce(3)},
ga_(){return this.ce(3)/15},
gap(){return A.a_(this)},
aj(a){this.ag(a.gn(),a.gt(),a.gu(),a.gv())},
ag(a,b,c,d){var s=this
s.c3(0,a)
s.c3(1,b)
s.c3(2,c)
s.c3(3,d)},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1,
gA(a){return this.a}}
A.b3.prototype={
i1(a,b,c,d){var s,r=this.a
r.$flags&2&&A.b(r)
s=r.length
if(0>=s)return A.a(r,0)
r[0]=a
if(1>=s)return A.a(r,1)
r[1]=b
if(2>=s)return A.a(r,2)
r[2]=c
if(3>=s)return A.a(r,3)
r[3]=d},
X(){return new A.b3(new Uint8Array(A.q(this.a)))},
gM(){return B.e},
gA(a){return this.a.length},
gO(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gU(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gv(){var s=this.a
return s.length>3?s[3]:255},
ga_(){return this.gv()/255},
gap(){return A.a_(this)},
aj(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gv()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.S(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===this.a.length){s=b.gL(b)
r=A.u(this,A.l(this).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.fI.prototype={}
A.ce.prototype={}
A.dW.prototype={
X(){return new A.dW(this.a)},
gM(){return B.e},
gA(a){return 4},
gO(){return null},
l(a,b){var s
if(b>=0&&b<4){s=b<<3>>>0
s=B.a.a0((this.a&B.a.R(255,s))>>>0,s)}else s=0
return s},
h(a,b,c){},
aj(a){},
gU(){return this.l(0,0)},
gn(){return this.l(0,0)},
sn(a){},
gt(){return this.l(0,1)},
st(a){},
gu(){return this.l(0,2)},
su(a){},
gv(){return this.l(0,3)},
ga_(){return this.gv()/255},
gap(){return A.a_(this)},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q=this
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gA(b)===q.gA(q)){s=b.gL(b)
r=A.u(q,A.l(q).p("e.E"))
s=s===A.o(r)}return s},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
$ix:1}
A.fL.prototype={
gv(){return 255},
ga_(){return 1},
gA(a){return 3}}
A.at.prototype={
a7(){return"Format."+this.b}}
A.e3.prototype={
a7(){return"FormatType."+this.b}}
A.fC.prototype={
a7(){return"BlendMode."+this.b}}
A.by.prototype={
d6(a){var s=$.lI()
if(!s.a9(a))return"<unknown>"
return s.l(0,a).a},
D(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=new A.R(s,s.r,s.e,A.l(s).p("R<1>")),q=t.p,p=t.r,o=t.N,n=t.P,m="";r.E();){l=r.d
m+=l+"\n"
k=s.l(0,l)
for(l=k.a,l=new A.R(l,l.r,l.e,A.l(l).p("R<1>"));l.E();){j=l.d
i=k.l(0,j)
m=i==null?m+("\t"+e.d6(j)+"\n"):m+("\t"+e.d6(j)+": "+i.D(0)+"\n")}for(l=k.b.a,j=new A.R(l,l.r,l.e,A.l(l).p("R<1>"));j.E();){h=j.d
m+=h+"\n"
if(!l.a9(h))l.h(0,h,new A.aK(A.I(q,p),new A.aS(A.I(o,n))))
g=l.l(0,h)
for(h=g.a,h=new A.R(h,h.r,h.e,A.l(h).p("R<1>"));h.E();){f=h.d
i=g.l(0,f)
m=i==null?m+("\t"+e.d6(f)+"\n"):m+("\t"+e.d6(f)+": "+i.D(0)+"\n")}}}return m.charCodeAt(0)==0?m:m},
aV(a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="exif",a7="interop",a8=a9.b
a9.b=!0
a9.a1(19789)
a9.a1(42)
a9.J(8)
s=a5.a
if(s.l(0,"ifd0")==null)s.h(0,"ifd0",new A.aK(A.I(t.p,t.r),new A.aS(A.I(t.N,t.P))))
r=s.l(0,"ifd1")
q=a5.b
p=q!=null&&q.length!==0&&r!=null
if(p){r.h(0,513,A.j5(0))
r.h(0,514,A.j5(q.length))}else if(r!=null){o=r.a
o.cA(0,513)
o.cA(0,514)}n=A.j(["ifd0"],t.s)
for(o=new A.R(s,s.r,s.e,A.l(s).p("R<1>"));o.E();){m=o.d
if(m!=="ifd0")B.c.C(n,m)}o=t.N
m=t.p
l=A.I(o,m)
for(k=n.length,j=t.r,i=t.P,h=8,g=0;g<n.length;n.length===k||(0,A.K)(n),++g){f=n[g]
e=s.l(0,f)
e.toString
l.h(0,f,h)
d=e.b.a
if(d.a9(a6)){c=new Uint32Array(1)
c[0]=0
e.h(0,34665,new A.aT(c))}else e.a.cA(0,34665)
if(d.a9(a7)){c=new Uint32Array(1)
c[0]=0
e.h(0,40965,new A.aT(c))}else e.a.cA(0,40965)
if(d.a9("gps")){c=new Uint32Array(1)
c[0]=0
e.h(0,34853,new A.aT(c))}else e.a.cA(0,34853)
e=e.a
h+=2+12*e.a+4
for(e=new A.au(e,e.r,e.e,A.l(e).p("au<2>"));e.E();){c=e.d
b=c.gaH().a
if(!(b<14))return A.a(B.v,b)
a=B.v[b]*c.gA(c)
if(a>4)h+=a}for(e=new A.R(d,d.r,d.e,A.l(d).p("R<1>"));e.E();){c=e.d
if(!d.a9(c))d.h(0,c,new A.aK(A.I(m,j),new A.aS(A.I(o,i))))
b=d.l(0,c)
b.toString
l.h(0,c,h)
b=b.a
a0=2+12*b.a
for(c=new A.au(b,b.r,b.e,A.l(b).p("au<2>"));c.E();){b=c.d
a1=b.gaH().a
if(!(a1<14))return A.a(B.v,a1)
a=B.v[a1]*b.gA(b)
if(a>4)a0+=a}h+=a0}}if(p)r.l(0,513).by(h)
a2=n.length
for(k=a2-1,a3=0;a3<a2;++a3){if(!(a3<n.length))return A.a(n,a3)
f=n[a3]
a4=s.l(0,f)
e=a4.b.a
if(e.a9(a6)){d=a4.l(0,34665)
d.toString
c=l.l(0,a6)
c.toString
d.by(c)}if(e.a9(a7)){d=a4.l(0,40965)
d.toString
c=l.l(0,a7)
c.toString
d.by(c)}if(e.a9("gps")){d=a4.l(0,34853)
d.toString
c=l.l(0,"gps")
c.toString
d.by(c)}d=l.l(0,f)
d.toString
a5.fV(a9,a4,d+2+12*a4.a.a+4)
if(a3===k)a9.J(0)
else{d=a3+1
if(!(d<n.length))return A.a(n,d)
d=l.l(0,n[d])
d.toString
a9.J(d)}a5.fW(a9,a4)
for(d=new A.R(e,e.r,e.e,A.l(e).p("R<1>"));d.E();){c=d.d
if(!e.a9(c))e.h(0,c,new A.aK(A.I(m,j),new A.aS(A.I(o,i))))
b=e.l(0,c)
b.toString
c=l.l(0,c)
c.toString
a5.fV(a9,b,c+2+12*b.a.a)
a5.fW(a9,b)}}if(p)a9.a5(q)
a9.b=a8},
fV(a,b,c){var s,r,q,p,o,n,m=b.a
a.a1(m.a)
for(m=new A.R(m,m.r,m.e,A.l(m).p("R<1>"));m.E();){s=m.d
r=b.l(0,s)
r.toString
q=s===273
p=q&&r.gaH()===B.J?B.p:r.gaH()
o=q&&r.gaH()===B.J?1:r.gA(r)
a.a1(s)
a.a1(p.a)
a.J(o)
s=r.gaH().a
if(!(s<14))return A.a(B.v,s)
n=B.v[s]*r.gA(r)
if(n<=4){r.aV(a)
while(n<4){a.m(0);++n}}else{a.J(c)
c+=n}}return c},
fW(a,b){var s,r,q
for(s=b.a,s=new A.au(s,s.r,s.e,A.l(s).p("au<2>"));s.E();){r=s.d
q=r.gaH().a
if(!(q<14))return A.a(B.v,q)
if(B.v[q]*r.gA(r)>4)r.aV(a)}},
c9(c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3=this,c4="Length must be a non-negative integer: ",c5=c6.e
c6.e=!0
s=c6.d
a2=c6.q()
if(a2===18761){c6.e=!1
if(c6.q()!==42){c6.e=c5
return!1}}else if(a2===19789){c6.e=!0
if(c6.q()!==42){c6.e=c5
return!1}}else return!1
r=c6.k()
q=0
a3=c3.a
a4=t.n0
a5=c6.c
a6=t.p
a7=t.r
a8=t.N
a9=t.P
for(;;){b0=r
if(typeof b0!=="number")return b0.hN()
if(!(b0>0))break
try{b0=s
b1=r
if(typeof b0!=="number")return b0.aQ()
if(typeof b1!=="number")return A.iy(b1)
b1=b0+b1
c6.d=b1
if(a5-b1<2)break
p=new A.aK(A.I(a6,a7),new A.aS(A.I(a8,a9)))
o=c6.q()
b0=o
if(typeof b0!=="number")return b0.en()
if(b0*12>a5-c6.d)break
n=o
b0=n
if(b0<0)A.ax(A.b2(c4+A.z(b0),null))
m=A.j(new Array(b0),a4)
l=0
for(;;){b0=l
b1=n
if(typeof b0!=="number")return b0.hO()
if(typeof b1!=="number")return A.iy(b1)
if(!(b0<b1))break
J.y(m,l,c3.fw(c6,s))
b0=l
if(typeof b0!=="number")return b0.aQ()
l=b0+1}k=m
for(b0=k,b1=b0.length,b2=0;b2<b0.length;b0.length===b1||(0,A.K)(b0),++b2){j=b0[b2]
if(j.b!=null){b3=j.a
b4=j.b
b4.toString
J.y(p,b3,b4)}}a3.h(0,"ifd"+A.z(q),p)
b0=q
if(typeof b0!=="number")return b0.aQ()
q=b0+1
i=c6.k()
if(J.bV(i,r))break
else r=i}catch(b5){break}}for(b0=new A.au(a3,a3.r,a3.e,A.l(a3).p("au<2>"));b0.E();){h=b0.d
for(b1=B.cg.gc7(),b1=b1.gH(b1);b1.E();){g=b1.gN()
b3=A.m(g)
if(h.a.a9(b3))try{f=J.d(h,g).i(0)
b3=s
b4=f
if(typeof b3!=="number")return b3.aQ()
if(typeof b4!=="number")return A.iy(b4)
c6.d=b3+b4
e=new A.aK(A.I(a6,a7),new A.aS(A.I(a8,a9)))
d=c6.q()
c=d
b4=c
if(b4<0)A.ax(A.b2(c4+A.z(b4),null))
b=A.j(new Array(b4),a4)
a=0
for(;;){b3=a
b4=c
if(typeof b3!=="number")return b3.hO()
if(typeof b4!=="number")return A.iy(b4)
if(!(b3<b4))break
J.y(b,a,c3.fw(c6,s))
b3=a
if(typeof b3!=="number")return b3.aQ()
a=b3+1}a0=b
for(b3=a0,b4=b3.length,b2=0;b2<b3.length;b3.length===b4||(0,A.K)(b3),++b2){a1=b3[b2]
if(a1.b!=null){b6=a1.a
b7=a1.b
b7.toString
J.y(e,b6,b7)}}b3=h.b
b4=B.cg.l(0,g)
b4.toString
b3.a.h(0,b4,a9.a(e))}catch(b5){continue}}}c3.b=null
b8=a3.l(0,"ifd1")
if(b8!=null){a3=b8.a
a3=a3.a9(513)&&a3.a9(514)}else a3=!1
if(a3){b9=b8.l(0,513).i(0)
c0=b8.l(0,514).i(0)
a3=s
if(typeof a3!=="number")return a3.aQ()
c1=a3+b9
if(c0>0){a3=s
if(typeof a3!=="number")return A.iy(a3)
a3=c1>=a3&&c1+c0<=a5}else a3=!1
if(a3){c2=c6.d
c6.d=c1
c3.b=c6.am(c0).a4()
c6.d=c2}}c6.e=c5
return!1},
fw(a,b){var s,r,q,p,o,n,m,l=a.q(),k=a.q(),j=a.k(),i=new A.id(l,null)
if(k>=14)return i
s=B.bR[k]
r=j*B.v[k]
q=a.d
if((r>4?a.d=a.k()+b:q)+r>a.c)return i
p=a.am(r)
switch(s.a){case 0:break
case 6:i.b=new A.bj(new Int8Array(A.q(J.lJ(B.d.gB(p.a4()),0,j))))
break
case 1:i.b=new A.b7(new Uint8Array(A.q(p.am(j).a4())))
break
case 7:i.b=new A.bZ(new Uint8Array(A.q(p.am(j).a4())))
break
case 2:i.b=new A.cl(j===0?"":p.ao(j-1))
break
case 3:i.b=A.nn(p,j)
break
case 4:i.b=A.ni(p,j)
break
case 5:i.b=A.nj(p,j)
break
case 10:i.b=A.nl(p,j)
break
case 8:i.b=A.nm(p,j)
break
case 9:i.b=A.nk(p,j)
break
case 11:i.b=A.no(p,j)
break
case 12:i.b=A.nh(p,j)
break
case 13:if(j===1){o=new A.cm(0)
n=p.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=n
n=$.a7()
if(0>=n.length)return A.a(n,0)
o.a=n[0]
i.b=o}break}a.d=q+4
return i}}
A.id.prototype={}
A.fP.prototype={}
A.aS.prototype={
i7(a){a.a.bL(0,new A.j2(this))},
gee(a){var s,r=this.a
if(r.a===0)return!0
for(r=new A.au(r,r.r,r.e,A.l(r).p("au<2>"));r.E();){s=r.d
if(!(s.a.a===0&&s.b.gee(0)))return!1}return!0},
l(a,b){var s=this.a
if(!s.a9(b))s.h(0,b,new A.aK(A.I(t.p,t.r),new A.aS(A.I(t.N,t.P))))
s=s.l(0,b)
s.toString
return s}}
A.j2.prototype={
$2(a,b){var s
A.bs(a)
s=A.ng(t.P.a(b))
this.a.a.h(0,a,s)
return s},
$S:12}
A.aK.prototype={
hf(a){a.a.bL(0,new A.j3(this))
a.b.a.bL(0,new A.j4(this))},
l(a,b){var s=this.a.l(0,b)
return s},
h(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(typeof b=="string")b=B.l1.l(0,b)
if(!A.ir(b))return
if(c instanceof A.a3)k.a.h(0,b,c)
else{s=$.lI().l(0,b)
if(s!=null)switch(s.b.a){case 1:if(t.L.b(c))k.a.h(0,b,new A.b7(new Uint8Array(A.q(new Uint8Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Uint8Array(1)
q[0]=r
k.a.h(0,b,new A.b7(q))}break
case 2:break
case 3:if(t.L.b(c))k.a.h(0,b,new A.bE(new Uint16Array(A.q(new Uint16Array(A.q(c))))))
else if(typeof c=="number")k.a.h(0,b,A.pJ(B.a.i(c)))
break
case 4:if(t.L.b(c))k.a.h(0,b,new A.aT(new Uint32Array(A.q(new Uint32Array(A.q(c))))))
else if(typeof c=="number")k.a.h(0,b,A.j5(B.a.i(c)))
break
case 5:if(t.ee.b(c))k.a.h(0,b,new A.bi(A.dn(c,!0,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.h(0,b,new A.bi(A.j([new A.aX(q,c[1])],t.lf)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.cn(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.aX(l,q[1])}k.a.h(0,b,new A.bi(A.dn(o,!0,r)))}break
case 6:if(t.L.b(c))k.a.h(0,b,new A.bj(new Int8Array(A.q(new Int8Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int8Array(1)
q[0]=r
k.a.h(0,b,new A.bj(q))}break
case 7:if(t.L.b(c))k.a.h(0,b,new A.bZ(new Uint8Array(A.q(new Uint8Array(A.q(c))))))
break
case 8:if(t.L.b(c))k.a.h(0,b,new A.bD(new Int16Array(A.q(new Int16Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int16Array(1)
q[0]=r
k.a.h(0,b,new A.bD(q))}break
case 9:if(t.L.b(c))k.a.h(0,b,new A.bC(new Int32Array(A.q(new Int32Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int32Array(1)
q[0]=r
k.a.h(0,b,new A.bC(q))}break
case 10:if(t.ee.b(c))k.a.h(0,b,new A.bk(A.dn(c,!0,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.h(0,b,new A.bk(A.j([new A.aX(q,c[1])],t.lf)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.cn(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.aX(l,q[1])}k.a.h(0,b,new A.bk(A.dn(o,!0,r)))}break
case 11:if(t.H.b(c))k.a.h(0,b,new A.bY(new Float32Array(A.q(new Float32Array(A.q(c))))))
else if(typeof c=="number"){r=new Float32Array(1)
r[0]=c
k.a.h(0,b,new A.bY(r))}break
case 12:if(t.H.b(c))k.a.h(0,b,new A.bX(new Float64Array(A.q(new Float64Array(A.q(c))))))
else if(typeof c=="number"){r=new Float64Array(1)
r[0]=c
k.a.h(0,b,new A.bX(r))}break
case 13:if(typeof c=="number")k.a.h(0,b,new A.cm(B.a.i(c)))
break
case 0:break}}},
gcp(){var s=this.a.l(0,274)
return s==null?null:s.i(0)},
scp(a){this.a.cA(0,274)}}
A.j3.prototype={
$2(a,b){var s
A.m(a)
s=t.r.a(b).X()
this.a.a.h(0,a,s)
return s},
$S:22}
A.j4.prototype={
$2(a,b){var s
A.bs(a)
s=A.ng(t.P.a(b))
this.a.b.a.h(0,a,s)
return s},
$S:12}
A.ag.prototype={
a7(){return"IfdValueType."+this.b}}
A.a3.prototype={
ad(a,b){A.m(b)
return 0},
i(a){return this.ad(0,0)},
bv(){return new Uint8Array(0)},
D(a){return""},
Y(a,b){var s=this
if(b==null)return!1
return b instanceof A.a3&&s.gaH()===b.gaH()&&s.gA(s)===b.gA(b)&&s.gL(s)===b.gL(b)},
gL(a){return 0},
by(a){}}
A.b7.prototype={
X(){return new A.b7(new Uint8Array(A.q(this.a)))},
gaH(){return B.bf},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.b7){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ad(0,0)},
by(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bv(){return this.a},
aV(a){a.a5(this.a)},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.cl.prototype={
X(){return new A.cl(this.a)},
gaH(){return B.l},
gA(a){return this.a.length+1},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cl){s=this.a
r=b.a
s=s.length+1===r.length+1&&B.m.gL(s)===B.m.gL(r)}else s=!1
return s},
gL(a){return B.m.gL(this.a)},
bv(){return new Uint8Array(A.q(new A.af(this.a)))},
aV(a){a.a5(new A.af(this.a))
a.m(0)},
D(a){return this.a}}
A.bE.prototype={
ic(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.q()
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bE(new Uint16Array(A.q(this.a)))},
gaH(){return B.k},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bE){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ad(0,0)},
by(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bv(){return J.aA(B.C.gB(this.a))},
aV(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.a1(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.aT.prototype={
i9(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.aT(new Uint32Array(A.q(this.a)))},
gaH(){return B.p},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.aT){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ad(0,0)},
by(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bv(){return J.aA(B.o.gB(this.a))},
aV(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.J(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bi.prototype={
X(){return new A.bi(A.dn(this.a,!0,t.i))},
gaH(){return B.t},
gA(a){return this.a.length},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].i(0)},
i(a){return this.ad(0,0)},
Y(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bi){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.o(s)===A.o(q)}else s=!1
return s},
gL(a){return A.o(this.a)},
aV(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.K)(s),++q){p=s[q]
a.J(p.a)
a.J(p.b)}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].D(0)}else s=A.z(s)
return s}}
A.bj.prototype={
X(){return new A.bj(new Int8Array(A.q(this.a)))},
gaH(){return B.bk},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bj){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ad(0,0)},
by(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bv(){return J.aA(B.az.gB(this.a))},
aV(a){a.a5(J.B(B.az.gB(this.a),0,null))},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bD.prototype={
ib(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.q()
o=$.ap()
o.$flags&2&&A.b(o)
o[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bD(new Int16Array(A.q(this.a)))},
gaH(){return B.bl},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bD){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ad(0,0)},
by(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bv(){return J.aA(B.ay.gB(this.a))},
aV(a){var s,r,q,p=new Int16Array(1),o=J.mX(B.ay.gB(p),0,null),n=this.a,m=n.length
for(s=o.length,r=0;r<m;++r){q=n[r]
if(0>=1)return A.a(p,0)
p[0]=q
if(0>=s)return A.a(o,0)
a.a1(o[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bC.prototype={
ia(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.P()
o.$flags&2&&A.b(o)
o[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bC(new Int32Array(A.q(this.a)))},
gaH(){return B.bm},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bC){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ad(0,0)},
by(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bv(){return J.aA(B.z.gB(this.a))},
aV(a){var s,r,q,p=this.a,o=p.length
for(s=0;s<o;++s){r=p[s]
q=$.iF()
q.$flags&2&&A.b(q)
q[0]=r
r=$.lH()
if(0>=r.length)return A.a(r,0)
a.J(r[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bk.prototype={
X(){return new A.bk(A.dn(this.a,!0,t.i))},
gaH(){return B.bg},
gA(a){return this.a.length},
Y(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bk){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.o(s)===A.o(q)}else s=!1
return s},
gL(a){return A.o(this.a)},
ad(a,b){var s
A.m(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].i(0)},
i(a){return this.ad(0,0)},
aV(a){var s,r,q,p,o,n
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.K)(s),++q){p=s[q]
o=$.iF()
o.$flags&2&&A.b(o)
o[0]=p.a
n=$.lH()
if(0>=n.length)return A.a(n,0)
a.J(n[0])
o[0]=p.b
a.J(n[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].D(0)}else s=A.z(s)
return s}}
A.bY.prototype={
ie(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.P()
o.$flags&2&&A.b(o)
o[0]=p
p=$.cd()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bY(new Float32Array(A.q(this.a)))},
gaH(){return B.bh},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bY){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
bv(){return J.aA(B.a6.gB(this.a))},
aV(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.lW(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.z(s[0])}else s=A.z(s)
return s}}
A.bX.prototype={
i8(a,b){var s,r
for(s=this.a,r=0;r<b;++r)B.q.h(s,r,a.dD())},
X(){return new A.bX(new Float64Array(A.q(this.a)))},
gaH(){return B.bi},
gA(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bX){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
bv(){return J.aA(B.q.gB(this.a))},
aV(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.lX(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.z(s[0])}else s=A.z(s)
return s}}
A.bZ.prototype={
X(){return new A.bZ(new Uint8Array(A.q(this.a)))},
gaH(){return B.J},
gA(a){return this.a.length},
bv(){return this.a},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bZ){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gL(a){return A.o(this.a)},
aV(a){a.a5(this.a)},
D(a){return"<data>"}}
A.cm.prototype={
X(){return A.j5(this.a)},
gaH(){return B.bj},
gA(a){return 1},
Y(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cm)s=this.a===b.a
return s},
gL(a){return this.a},
ad(a,b){if(A.m(b)!==0)throw A.h(A.qq("Ifd tags must have exactly one entry (the offset)"))
return this.a},
i(a){return this.ad(0,0)},
by(a){this.a=a},
bv(){var s=this.a
return new Uint8Array(A.q(A.j([B.a.j(s,24),B.a.j(s,16),B.a.j(s,8),s],t.t)))},
aV(a){a.J(this.a)},
D(a){return"Ifd@"+this.a}}
A.aB.prototype={
a7(){return"DitherKernel."+this.b}}
A.d6.prototype={
a7(){return"DitherScanOrder."+this.b}}
A.lj.prototype={
$3(a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.a,a0=a.aR(a5,a6),a1=B.b.i(a0.l(0,0)),a2=B.b.i(a0.l(0,1)),a3=B.b.i(a0.l(0,2)),a4=b.b.ek(a1,a2,a3)
b.c.hR(a5,a6,a4)
s=b.d
r=a1-s.aX(a4,0)
q=a2-s.aX(a4,1)
p=a3-s.aX(a4,2)
if(r===0&&q===0&&p===0)return
s=a7===1
o=s?0:b.e.length-1
n=s?b.e.length:0
for(s=b.e,m=s.length,l=b.f,k=b.r,j=o;j!==n;j+=a7){if(!(j>=0&&j<m))return A.a(s,j)
i=s[j]
h=B.b.i(i[1])
g=B.b.i(i[2])
f=h+a5
e=!1
if(f>=0)if(f<l){f=g+a6
f=f>=0&&f<k}else f=e
else f=e
if(f){d=i[0]
i=a.a
c=i==null?null:i.P(a5+h,a6+g,null)
if(c==null)c=new A.F()
c.sn(c.gn()+r*d)
c.st(c.gt()+q*d)
c.su(c.gu()+p*d)}}},
$S:23}
A.ae.prototype={
a7(){return"BmpCompression."+this.b}}
A.iL.prototype={}
A.bw.prototype={
eB(a,b){var s,r,q,p,o,n,m,l=this,k=l.d,j=k<=40
if(j){s=l.r
s=s===B.ac||s===B.aF}else s=!0
if(s){s=l.as=a.k()
r=A.lf(s)
l.CW=r
q=B.a.a2(s,r)
s=q>0
l.cx=s?255/q:0
r=l.at=a.k()
p=A.lf(r)
l.cy=p
o=B.a.a2(r,p)
l.db=s?255/o:0
r=l.ax=a.k()
p=A.lf(r)
l.dx=p
n=B.a.a2(r,p)
l.dy=s?255/n:0
if(!j||l.r===B.aF){j=l.ay=a.k()
s=A.lf(j)
l.fr=s
m=B.a.a2(j,s)
l.fx=m>0?255/m:0}else if(l.f===16){l.ay=4278190080
l.fr=24
l.fx=1}else{l.ay=4278190080
l.fr=24
l.fx=1}}else if(l.f===16){l.as=31744
l.CW=10
l.cx=8.225806451612904
l.at=992
l.cy=5
l.db=8.225806451612904
l.ax=31
l.dx=0
l.dy=8.225806451612904
l.fx=l.fr=l.ay=0}else{l.as=16711680
l.CW=16
l.cx=1
l.at=65280
l.cy=8
l.db=1
l.ax=255
l.dx=0
l.dy=1
l.ay=4278190080
l.fr=24
l.fx=1}j=a.d
a.d=j+(k-(j-l.fy))
if(l.f<=8)l.lD(a)},
gcY(){var s=this.d
if(s!==40)if(s===124){s=this.ay
s===$&&A.c("alphaMask")
s=s===0}else s=!1
else s=!0
return s},
gK(){return Math.abs(this.c)},
lD(a){var s,r,q,p,o,n=this,m=n.z
if(m===0)m=B.a.R(1,n.f)
n.ch=new A.aN(new Uint8Array(m*3),m,3)
for(s=0;s<m;++s){r=J.d(a.a,a.d++)
q=J.d(a.a,a.d++)
p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n.ch.d7(s,p,q,r,o)}},
l9(a2,a3){var s,r,q,p,o,n,m,l,k,j=this,i="_redShift",h="_redScale",g="greenMask",f="_greenShift",e="_greenScale",d="blueMask",c="_blueShift",b="_blueScale",a="alphaMask",a0="_alphaShift",a1="_alphaScale"
t.jO.a(a3)
if(j.ch!=null){s=j.f
if(s===1){r=a2.I()
for(q=7;q>=0;--q)a3.$4(B.a.aL(r,q)&1,0,0,0)
return}else if(s===2){r=a2.I()
for(q=6;q>=0;q-=2)a3.$4(B.a.aL(r,q)&2,0,0,0)}else if(s===4){r=a2.I()
a3.$4(B.a.j(r,4)&15,0,0,0)
a3.$4(r&15,0,0,0)
return}else if(s===8){a3.$4(a2.I(),0,0,0)
return}}s=j.r
if(s===B.ac&&j.f===32){p=a2.k()
s=j.as
s===$&&A.c("redMask")
o=j.CW
o===$&&A.c(i)
o=B.a.a2((p&s)>>>0,o)
s=j.cx
s===$&&A.c(h)
n=B.b.i(o*s)
s=j.at
s===$&&A.c(g)
o=j.cy
o===$&&A.c(f)
o=B.a.a2((p&s)>>>0,o)
s=j.db
s===$&&A.c(e)
m=B.b.i(o*s)
s=j.ax
s===$&&A.c(d)
o=j.dx
o===$&&A.c(c)
o=B.a.a2((p&s)>>>0,o)
s=j.dy
s===$&&A.c(b)
l=B.b.i(o*s)
if(j.gcY())k=255
else{s=j.ay
s===$&&A.c(a)
o=j.fr
o===$&&A.c(a0)
o=B.a.a2((p&s)>>>0,o)
s=j.fx
s===$&&A.c(a1)
k=B.b.i(o*s)}return a3.$4(n,m,l,k)}else{o=j.f
if(o===32&&s===B.aE){l=a2.I()
m=a2.I()
n=a2.I()
k=a2.I()
return a3.$4(n,m,l,j.gcY()?255:k)}else if(o===24){l=a2.I()
m=a2.I()
return a3.$4(a2.I(),m,l,255)}else if(o===16){p=a2.q()
s=j.as
s===$&&A.c("redMask")
o=j.CW
o===$&&A.c(i)
o=B.a.a2((p&s)>>>0,o)
s=j.cx
s===$&&A.c(h)
n=B.b.i(o*s)
s=j.at
s===$&&A.c(g)
o=j.cy
o===$&&A.c(f)
o=B.a.a2((p&s)>>>0,o)
s=j.db
s===$&&A.c(e)
m=B.b.i(o*s)
s=j.ax
s===$&&A.c(d)
o=j.dx
o===$&&A.c(c)
o=B.a.a2((p&s)>>>0,o)
s=j.dy
s===$&&A.c(b)
l=B.b.i(o*s)
if(j.gcY())k=255
else{s=j.ay
s===$&&A.c(a)
o=j.fr
o===$&&A.c(a0)
o=B.a.a2((p&s)>>>0,o)
s=j.fx
s===$&&A.c(a1)
k=B.b.i(o*s)}return a3.$4(n,m,l,k)}else throw A.h(A.n("Unsupported bitsPerPixel ("+o+") or compression ("+s.D(0)+")."))}},
$iM:1}
A.fD.prototype={
bB(a){var s,r
if(!A.n1(A.w(a,!1,null,0))||a.length<18)return!1
s=A.w(a,!1,null,0)
s.d+=14
r=s.k()
return r>=12&&r<=124},
b7(a){var s
if(!this.bB(a))return null
s=A.w(a,!1,null,0)
this.a=s
return this.b=A.pj(s,null)},
aq(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.b
if(a0==null)return new A.bl(a,a,a,a,0,B.j,0,0)
s=b.a
s===$&&A.c("_input")
r=a0.a.b
r===$&&A.c("imageOffset")
s.d=r
q=a0.f
r=a0.b
p=B.a.W(r*q+31,32)*4
s=b.c
if(s)o=4
else if(q===1||q===4||q===8)o=1
else{n=q===32?4:3
o=n}if(s)m=B.e
else if(q===1)m=B.A
else{if(q===2)n=B.u
else if(q===4)n=B.B
else n=B.e
m=n}l=s?a:a0.ch
k=A.Q(a,a,m,0,B.j,a0.gK(),a,0,o,l,B.e,r,!1)
for(j=k.gK()-1,s=a0.c,r=1/s<0,n=s<0,s=s===0;j>=0;--j){i={}
if(!(s?r:n))h=j
else{g=k.a
g=g==null?a:g.b
h=(g==null?0:g)-1-j}g=b.a
f=g.aA(p)
g.d=g.d+(f.c-f.d)
g=k.a
e=g==null
d=e?a:g.a
if(d==null)d=0
i.a=0
c=e?a:g.P(0,h,a)
if(c==null)c=new A.F()
while(i.a<d)a0.l9(f,new A.iJ(i,b,d,a0,c))}return k},
b9(a,b){if(this.b7(a)==null)return null
return this.aq(0)}}
A.iJ.prototype={
$4(a,b,c,d){var s,r,q=this,p=q.a
if(p.a<q.c){s=q.b.c&&q.d.ch!=null
r=q.e
if(s){s=q.d
r.ag(s.ch.b1(a),s.ch.b0(a),s.ch.b_(a),s.ch.b6(a))}else r.ag(a,b,c,d)
r.E();++p.a}},
$S:24}
A.iQ.prototype={}
A.iK.prototype={
bI(c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=null,b8=A.Y(!1,8192),b9=c3.gal(),c0=c3.a,c1=c0==null?b7:c0.gO(),c2=c3.gM()
c0=c2===B.A
if(c0&&b9===1&&c1==null){c1=new A.aN(new Uint8Array(6),2,3)
c1.b4(0,0,0,0)
c1.b4(1,255,255,255)}else if(c0&&b9===2){c3=c3.l3(B.u,1,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else if(c0&&b9===3&&c1==null){c3=c3.cl(B.B,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else if(c0&&b9===4)c3=c3.cU(B.e,4)
else{c0=c2===B.u
if(c0&&b9===1&&c1==null){c3=c3.cl(B.u,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else if(c0&&b9===2){c3=c3.cl(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else if(c0&&b9===3&&c1==null){c3=c3.cl(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else if(c0&&b9===4){c3=c3.cl(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else{c0=c2===B.B
if(c0&&b9===1&&c1==null){c3=c3.cl(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gO()}else if(c0&&b9===2)c3=c3.cU(B.e,3)
else if(c0&&b9===3&&c1==null)c3=c3.cU(B.e,3)
else if(c0&&b9===4)c3=c3.cU(B.e,4)
else{c0=c2===B.e
if(c0&&b9===1&&c1==null)c3=c3.cl(B.e,!0)
else if(c0&&b9===2)c3.cU(B.e,3)
else if(c3.gb2())c3=c3.aS(B.e)
else if(c3.gaP()&&c3.gal()===4)c3=c3.ec(4)}}}c0=c3.gaO()
s=c3.a
r=c0*s.c
if(r===12)r=16
c0=r>8
q=c0?B.ac:B.aE
s=s.gbf()
p=s
if(p==null)p=0
o=B.a.W(c3.gS()*r+31,32)*4
n=o-p
m=n>0?A.E(n,255,!1,t.p):b7
l=r>=1&&r<=8?B.a.V(1,r):0
k=o*c3.gK()
j=c0?124:40
i=j+14
h=l*4
g=i+h
f=g-g
b8.a1(19778)
b8.J(k+i+h+f)
b8.J(0)
b8.J(g)
b8.J(j)
b8.J(c3.gS())
b8.J(c3.gK())
b8.a1(1)
b8.a1(r)
b8.J(q.a)
b8.J(k)
b8.J(11811)
b8.J(11811)
s=r===8
b8.J(s?255:0)
b8.J(s?255:0)
if(c0){c0=r===16
e=c0?15:255
d=c0?240:65280
c=c0?3840:16711680
b=c0?61440:4278190080
b8.J(c)
b8.J(d)
b8.J(e)
b8.J(b)
b8.J(1934772034)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(0)
b8.J(2)
b8.J(0)
b8.J(0)
b8.J(0)}c0=r===1
a=!c0
if(!a||r===2||r===4||s)if(c1!=null){a0=c1.a
if(a0>l)a0=l
for(a1=0;a1<a0;++a1){b8.m(B.b.i(c1.b_(a1)))
b8.m(B.b.i(c1.b0(a1)))
b8.m(B.b.i(c1.b1(a1)))
b8.m(0)}for(;a1<l;++a1){b8.m(0)
b8.m(0)
b8.m(0)
b8.m(0)}}else if(c0){b8.m(0)
b8.m(0)
b8.m(0)
b8.m(0)
b8.m(255)
b8.m(255)
b8.m(255)
b8.m(0)}else if(r===2)for(a1=0;a1<4;++a1){a2=a1*85
b8.m(a2)
b8.m(a2)
b8.m(a2)
b8.m(0)}else if(r===4)for(a1=0;a1<16;++a1){a2=a1*17
b8.m(a2)
b8.m(a2)
b8.m(a2)
b8.m(0)}else if(s)for(a1=0;a1<256;++a1){b8.m(a1)
b8.m(a1)
b8.m(a1)
b8.m(0)}for(a3=f;a4=a3-1,a3>0;a3=a4)b8.m(0)
if(!a||r===2||r===4||s){a5=c3.gd_(0)-p
a6=c3.gK()
for(s=m!=null,a=r===4,a7=r===2,a8=0;a8<a6;++a8){a9=c3.a
a9=a9==null?b7:a9.gB(a9)
if(a9==null)a9=B.d.gB(new Uint8Array(0))
b0=J.B(a9,a5,p)
if(c0)b8.a5(b0)
else if(a7){a0=b0.length
for(b1=0;b1<a0;++b1){b2=b0[b1]
b8.m((b2&15)<<4|b2>>>4)}}else if(a){a0=b0.length
for(b1=0;b1<a0;++b1){b2=b0[b1]
b8.m(b2>>>4<<4|b2&15)}}else b8.a5(b0)
if(s)b8.a5(m)
a5-=p}return J.B(B.d.gB(b8.c),0,b8.a)}b3=c3.gal()===4
a6=c3.gK()
b4=c3.gS()
if(r===16)for(a8=a6-1,c0=m!=null,b5=b7;a8>=0;--a8){s=c3.a
b5=s==null?b7:s.P(0,a8,b5)
if(b5==null)b5=new A.F()
for(b6=0;b6<b4;++b6){b8.m((B.b.i(b5.gt())<<4|B.b.i(b5.gu()))>>>0)
b8.m((B.b.i(b5.gv())<<4|B.b.i(b5.gn()))>>>0)
b5.E()}if(c0)b8.a5(m)}else for(a8=a6-1,c0=m!=null,b5=b7;a8>=0;--a8){s=c3.a
b5=s==null?b7:s.P(0,a8,b5)
if(b5==null)b5=new A.F()
for(b6=0;b6<b4;++b6){b8.m(A.m(b5.gu()))
b8.m(A.m(b5.gt()))
b8.m(A.m(b5.gn()))
if(b3)b8.m(A.m(b5.gv()))
b5.E()}if(c0)b8.a5(m)}return J.B(B.d.gB(b8.c),0,b8.a)}}
A.M.prototype={}
A.iO.prototype={}
A.iR.prototype={}
A.fQ.prototype={}
A.eg.prototype={
d0(){return this.w},
bw(a,b,c,d,e){throw A.h(A.n("B44 compression not yet supported."))},
cB(a,b,c){return this.bw(a,b,c,null,null)},
D(a){return A.z(this.r)+" "+this.x}}
A.d7.prototype={
a7(){return"ExrChannelType."+this.b}}
A.ci.prototype={
a7(){return"ExrChannelName."+this.b}}
A.fR.prototype={
i2(a){var s=this,r=a.d2()
s.a=r
if(r.length===0)return
r=a.k()
if(!(r<3))return A.a(B.bH,r)
s.c=B.bH[r]
a.I()
a.d+=3
s.f=a.k()
s.r=a.k()
r=s.a
if(r==="R"){s.w=!0
s.b=B.dc}else if(r==="G"){s.w=!0
s.b=B.dd}else if(r==="B"){s.w=!0
s.b=B.de}else if(r==="A"){s.w=!0
s.b=B.df}else{s.w=!1
s.b=B.dg}switch(s.c.a){case 0:s.d=4
break
case 1:s.d=2
break
case 2:s.d=4
break}}}
A.b6.prototype={
a7(){return"ExrCompressorType."+this.b}}
A.bz.prototype={
bw(a,b,c,d,e){throw A.h(A.n("Unsupported compression type"))},
cB(a,b,c){return this.bw(a,b,c,null,null)}}
A.ha.prototype={}
A.fS.prototype={
shv(a){this.c=t.T.a(a)}}
A.fT.prototype={
i3(a){var s,r,q,p,o=this,n=A.w(a,!1,null,0)
if(n.k()!==20000630)throw A.h(A.n("File is not an OpenEXR image file."))
s=o.d=n.I()
if(s!==2)throw A.h(A.n("Cannot read version "+s+" image files."))
s=o.e=n.bu()
if((s&4294967289)>>>0!==0)throw A.h(A.n("The file format version number's flag field contains unrecognized flags."))
if((s&16)===0){r=o.c
q=A.nq(r.length,(s&2)!==0,n)
if(q.w>0)B.c.C(r,q)}else for(s=o.c;;){q=A.nq(s.length,(o.e&2)!==0,n)
if(q.w<=0)break
B.c.C(s,q)}s=o.c
r=s.length
if(r===0)throw A.h(A.n("Error reading image header"))
for(p=0;p<s.length;s.length===r||(0,A.K)(s),++p)s[p].lC(n)
o.ku(n)},
ku(a){var s,r,q,p,o=this
for(s=o.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.K)(s),++q){p=s[q]
o.a=Math.max(o.a,p.w)
o.b=Math.max(o.b,p.x)
if(p.db)o.kD(p,a)
else o.kC(p,a)}},
kD(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=this.e
b5===$&&A.c("flags")
s=(b5&16)!==0
b5=b6.b
b5.toString
r=b6.CW
q=b6.ay
p=A.p(b7,b4,0)
o=b6.c
n=b6.a
m=0
l=0
for(;;){k=b6.k1
k.toString
if(!(m<k))break
j=0
for(;;){k=b6.id
k.toString
if(!(j<k))break
k=l!==0
i=0
h=0
for(;;){g=b6.go
if(!(m<g.length))return A.a(g,m)
if(!(i<g[m]))break
f=0
for(;;){g=b6.fy
if(!(j<g.length))return A.a(g,j)
if(!(f<g[j]))break
if(k)break
if(!(l>=0&&l<q.length))return A.a(q,l)
g=q[l]
if(!(h>=0&&h<g.length))return A.a(g,h)
p.d=g[h]
if(s)if(p.k()!==n)throw A.h(A.n("Invalid Image Data"))
e=p.k()
d=p.k()
p.k()
p.k()
c=p.aA(p.k())
p.d=p.d+(c.c-c.d)
g=b6.dy
g.toString
b=d*g
a=b6.dx
a.toString
g=r.bw(c,e*a,b,a,g)
a=g.length
a=Math.min(a,a)
a0=new A.ad(g,0,a,0,!1)
a1=r.a
a2=r.b
a3=o.length
a4=0
a5=0
for(;;){if(!(a5<a2&&b<this.b))break
for(a6=0;a6<a3;++a6){if(a4>=a)break
if(!(a6<o.length))return A.a(o,a6)
a7=o[a6]
g=b6.dx
g.toString
a8=e*g
for(a9=0;a9<a1;++a9,++a8){g=a7.c
g===$&&A.c("dataType")
switch(g.a){case 1:g=a0.q()
b0=$.U
b0=b0!=null?b0:A.X()
if(!(g<b0.length))return A.a(b0,g)
b1=b0[g]
break
case 2:b1=a0.q()
break
case 0:b1=a0.k()
break
default:b1=b4}g=a7.d
g===$&&A.c("dataSize")
a4+=g
g=a7.w
g===$&&A.c("isColorChannel")
if(g){g=b5.a
b2=g==null?b4:g.P(a8,b,b4)
if(b2==null)b2=new A.F()
g=a7.b
g===$&&A.c("nameType")
b2.h(0,g.a,b1)}else{g=a7.a
g===$&&A.c("name")
b0=b5.b
b3=b0!=null?b0.l(0,g):b4
if(b3!=null)b3.aa(a8,b,b1,0,0)}}}++a5;++b}++f;++h}++i}++j;++l}++m}},
kC(a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=null,a7=this.e
a7===$&&A.c("flags")
s=(a7&16)!==0
a7=a8.b
a7.toString
r=a8.CW
q=a8.ay
if(0>=q.length)return A.a(q,0)
p=q[0]
o=a8.cx
n=A.p(a9,a6,0)
for(q=p.length,m=a8.c,l=r!=null,k=0,j=0;j<q;++j){n.d=p[j]
if(s)if(n.k()!==3.141592653589793)throw A.h(A.n("Invalid Image Data"))
i=n.k()
h=$.P()
h.$flags&2&&A.b(h)
h[0]=i
i=$.a7()
if(0>=i.length)return A.a(i,0)
h[0]=n.k()
g=n.aA(i[0])
n.d=n.d+(g.c-g.d)
if(l){i=r.cB(g,0,k)
h=i.length
f=new A.ad(i,0,Math.min(h,h),0,!1)}else f=g
e=f.c-f.d
d=m.length
c=0
for(;;){if(!(c<o&&k<this.b))break
i=a8.cy
if(!(k>=0&&k<i.length))return A.a(i,k)
b=i[k]
if(b>=e)break
for(a=0;a<d;++a){if(b>=e)break
if(!(a<m.length))return A.a(m,a)
a0=m[a]
a1=a8.w
for(a2=0;a2<a1;++a2){i=a0.c
i===$&&A.c("dataType")
switch(i.a){case 1:i=f.q()
h=$.U
h=h!=null?h:A.X()
if(!(i<h.length))return A.a(h,i)
a3=h[i]
break
case 2:a3=f.q()
break
case 0:a3=f.k()
break
default:a3=a6}i=a0.d
i===$&&A.c("dataSize")
b+=i
i=a0.w
i===$&&A.c("isColorChannel")
if(i){i=a7.a
a4=i==null?a6:i.P(a2,k,a6)
if(a4==null)a4=new A.F()
i=a0.b
i===$&&A.c("nameType")
a4.h(0,i.a,a3)}else{i=a0.a
i===$&&A.c("name")
h=a7.b
a5=h!=null?h.l(0,i):a6
if(a5!=null)a5.aa(a2,k,a3,0,0)}}}++c;++k}}},
$iM:1}
A.e_.prototype={
i4(a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=null,a5="dataType",a6="dataWindow",a7=A.I(t.N,t.w)
for(s=a3.e,r=t.t,q=t.L,p=a3.c,o=B.I;;){n=b0.d2()
if(n.length===0)break
b0.d2()
m=b0.aA(b0.k())
b0.d=b0.d+(m.c-m.d)
s.h(0,n,new A.fQ())
switch(n){case"channels":for(;;){l=new A.fR()
l.i2(m)
k=l.a
k===$&&A.c("name")
if(k.length===0)break
j=l.w
j===$&&A.c("isColorChannel")
if(j){++a3.d
k=l.c
k===$&&A.c(a5)
if(k===B.aH)o=B.I
else o=k===B.aI?B.Q:B.R}else{j=l.c
j===$&&A.c(a5)
if(j===B.aH){j=a3.w
i=a3.x
a7.h(0,k,new A.d9(new Uint16Array(j*i),j,i,1))}else if(j===B.aI){j=a3.w
i=a3.x
a7.h(0,k,new A.da(new Float32Array(j*i),j,i,1))}else if(j===B.bb){j=a3.w
i=a3.x
a7.h(0,k,new A.de(new Uint32Array(j*i),j,i,1))}}B.c.C(p,l)}break
case"chromaticities":k=new Float32Array(8)
a3.at=k
j=m.k()
i=$.P()
i.$flags&2&&A.b(i)
i[0]=j
j=$.cd()
if(0>=j.length)return A.a(j,0)
k[0]=j[0]
k=a3.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.b(k)
k[1]=h
h=a3.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.b(h)
h[2]=k
k=a3.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.b(k)
k[3]=h
h=a3.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.b(h)
h[4]=k
k=a3.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.b(k)
k[5]=h
h=a3.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.b(h)
h[6]=k
k=a3.at
i[0]=m.k()
j=j[0]
k.$flags&2&&A.b(k)
k[7]=j
break
case"compression":k=J.d(m.a,m.d++)
if(!(k>=0&&k<8))return A.a(B.bS,k)
a3.ax=B.bS[k]
break
case"dataWindow":k=m.k()
j=$.P()
j.$flags&2&&A.b(j)
j[0]=k
k=$.a7()
if(0>=k.length)return A.a(k,0)
i=k[0]
j[0]=m.k()
h=k[0]
j[0]=m.k()
g=k[0]
j[0]=m.k()
k=q.a(A.j([i,h,g,k[0]],r))
a3.r=k
a3.w=k[2]-k[0]+1
a3.x=k[3]-k[1]+1
break
case"displayWindow":k=m.k()
j=$.P()
j.$flags&2&&A.b(j)
j[0]=k
k=$.a7()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
j[0]=m.k()
j[0]=m.k()
break
case"lineOrder":break
case"pixelAspectRatio":k=m.k()
j=$.P()
j.$flags&2&&A.b(j)
j[0]=k
k=$.cd()
if(0>=k.length)return A.a(k,0)
break
case"screenWindowCenter":k=m.k()
j=$.P()
j.$flags&2&&A.b(j)
j[0]=k
k=$.cd()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
break
case"screenWindowWidth":k=m.k()
j=$.P()
j.$flags&2&&A.b(j)
j[0]=k
k=$.cd()
if(0>=k.length)return A.a(k,0)
break
case"tiles":a3.dx=m.k()
a3.dy=m.k()
f=J.d(m.a,m.d++)
a3.fr=f&15
a3.fx=B.a.j(f,4)&15
break
case"type":e=m.d2()
if(e!=="deepscanline")if(e!=="deeptile")throw A.h(A.n("EXR Invalid type: "+e))
break
default:break}}s=a3.w
a3.b=A.Q(a4,a4,o,0,B.j,a3.x,a4,0,a3.d,a4,B.e,s,!1)
for(s=new A.R(a7,a7.r,a7.e,a7.$ti.p("R<1>"));s.E();){r=s.d
q=a3.b
q.toString
k=a7.l(0,r)
k.toString
q.hQ(r,k)}if(a3.db){s={}
r=a3.r
r===$&&A.c(a6)
a3.id=a3.iE(r[0],r[2],r[1],r[3])
r=a3.r
a3.k1=a3.iF(r[0],r[2],r[1],r[3])
if(a3.fr!==2)a3.k1=1
r=a3.id
r.toString
q=a3.r
a3.fy=a3.eN(r,q[0],q[2],a3.dx,a3.fx)
q=a3.k1
q.toString
r=a3.r
a3.go=a3.eN(q,r[1],r[3],a3.dy,a3.fx)
r=a3.iD()
a3.k2=r
q=a3.dx
q.toString
q=r*q
a3.k3=q
a3.CW=A.nb(a3.ax,a3,q,a3.dy)
s.a=s.b=0
q=a3.id
q.toString
r=a3.k1
r.toString
a3.ay=A.nx(q*r,new A.iU(s,a3),t.E)}else{s=a3.x
r=a3.ch=new Uint32Array(s+1)
for(q=p.length,k=a3.r,j=a3.w,d=0;d<q;++d){c=p[d]
i=c.d
i===$&&A.c("dataSize")
h=c.f
h===$&&A.c("xSampling")
b=B.a.au(i*j,h)
for(i=c.r,a=0;a<s;++a){k===$&&A.c(a6)
h=k[1]
i===$&&A.c("ySampling")
if(B.a.a8(a+h,i)===0)r[a]=r[a]+b}}for(a0=0,a=0;a<s;++a)a0=Math.max(a0,r[a])
s=A.nb(a3.ax,a3,a0,a4)
a3.CW=s
s=a3.cx=s.d0()
r=a3.ch
q=r.length
p=new Uint32Array(q)
a3.cy=p
for(--q,a1=0,a2=0;a2<=q;++a2){if(B.a.a8(a2,s)===0)a1=0
p[a2]=a1
a1+=r[a2]}s=B.a.au(a3.x+s,s)
a3.ay=A.j([new Uint32Array(s-1)],t.mD)}},
iE(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.m(r)
s=(q===0?o.di(r):o.da(r))+1
break
case 2:p=b-a+1
s=(o.fx===0?o.di(p):o.da(p))+1
break
default:throw A.h(A.n("Unknown LevelMode format."))}return s},
iF(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.m(r)
s=(q===0?o.di(r):o.da(r))+1
break
case 2:p=d-c+1
s=(o.fx===0?o.di(p):o.da(p))+1
break
default:throw A.h(A.n("Unknown LevelMode format."))}return s},
di(a){var s
for(s=0;a>1;){++s
a=B.a.j(a,1)}return s},
da(a){var s,r
for(s=0,r=0;a>1;){if((a&1)!==0)r=1;++s
a=B.a.j(a,1)}return s+r},
iD(){var s,r,q,p,o
for(s=this.c,r=s.length,q=0,p=0;p<r;++p){o=s[p].d
o===$&&A.c("dataSize")
q+=o}return q},
eN(a,b,c,d,e){var s,r,q,p,o,n,m=J.a8(a,t.p)
for(s=e===1,r=c-b+1,q=0;q<a;++q){p=B.a.R(1,q)
o=B.a.au(r,p)
if(s&&o*p<r)++o
n=Math.max(o,1)
d.toString
m[q]=B.a.au(n+d-1,d)}return m}}
A.iU.prototype={
$1(a){var s,r,q,p,o=this.b,n=o.fy,m=this.a,l=m.b
if(!(l<n.length))return A.a(n,l)
n=n[l]
s=o.go
r=m.a
if(!(r<s.length))return A.a(s,r)
s=s[r]
q=new Uint32Array(n*s)
p=l+1
m.b=p
if(p===o.id){m.b=0
m.a=r+1}return q},
$S:25}
A.hb.prototype={
lC(a){var s,r,q,p,o,n=this
if(n.db)for(s=0;s<n.ay.length;++s){r=0
for(;;){q=n.ay
if(!(s<q.length))return A.a(q,s)
q=q[s]
if(!(r<q.length))break
p=a.eh()
q.$flags&2&&A.b(q)
q[r]=p;++r}}else{q=n.ay
if(0>=q.length)return A.a(q,0)
o=q[0].length
for(s=0;s<o;++s){q=n.ay
if(0>=q.length)return A.a(q,0)
q=q[0]
p=a.eh()
q.$flags&2&&A.b(q)
if(!(s<q.length))return A.a(q,s)
q[s]=p}}}}
A.hc.prototype={
ii(a,b,c){var s,r,q,p=this,o=a.c.length,n=J.a8(o,t.nA)
for(s=0;s<o;++s)n[s]=new A.fl()
p.y=t.a3.a(n)
r=p.w
r.toString
q=B.a.W(r*p.x,2)
p.z=new Uint16Array(q)},
d0(){return this.x},
bw(a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="_channelData"
if(b0==null)b0=a5.c.w
if(b1==null)b1=a5.c.cx
s=a8+b0-1
r=a9+b1-1
q=a5.c
p=q.w
if(s>p)s=p-1
p=q.x
if(r>p)r=p-1
a5.a=s-a8+1
a5.b=r-a9+1
o=q.c
n=o.length
for(m=0,l=0;l<n;++l){k=o[l]
q=a5.y
q===$&&A.c(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
j.b=j.a=m
q=k.f
q===$&&A.c("xSampling")
i=B.a.au(a8,q)
h=B.a.au(s,q)
q=i*q<a8?0:1
q=h-i+q
j.c=q
p=k.r
p===$&&A.c("ySampling")
i=B.a.au(a9,p)
h=B.a.au(r,p)
g=i*p<a9?0:1
g=h-i+g
j.d=g
j.e=p
p=k.d
p===$&&A.c("dataSize")
p=p/2|0
j.f=p
m+=q*g*p}f=a7.q()
e=a7.q()
if(e>=8192)throw A.h(A.n("Error in header for PIZ-compressed data (invalid bitmap size)."))
d=new Uint8Array(8192)
if(f<=e){c=a7.am(e-f+1)
b=c.c-c.d
for(a=f,l=0;l<b;++l,a=a0){a0=a+1
q=J.d(c.a,c.d+l)
if(!(a<8192))return A.a(d,a)
d[a]=q}}a1=new Uint16Array(65536)
a2=a5.kH(d,a1)
A.py(a7,a7.k(),a5.z,m)
for(l=0;l<n;++l){q=a5.y
q===$&&A.c(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
a=0
for(;;){q=j.f
q===$&&A.c("size")
if(!(a<q))break
p=a5.z
p.toString
g=j.a
g===$&&A.c("start")
a3=j.c
a3===$&&A.c("nx")
a4=j.d
a4===$&&A.c("ny")
A.pB(p,g+a,a3,q,a4,a3*q,a2);++a}}q=a5.z
q.toString
a5.iu(a1,q,m)
q=a5.r
if(q==null){q=a5.w
q.toString
q=a5.r=A.Y(!1,q*a5.x+73728)}q.a=0
for(;a9<=r;++a9)for(l=0;l<n;++l){q=a5.y
q===$&&A.c(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
q=j.e
q===$&&A.c("ys")
if(B.a.a8(a9,q)!==0)continue
q=j.c
q===$&&A.c("nx")
p=j.f
p===$&&A.c("size")
a8=q*p
for(;a8>0;--a8){q=a5.r
q.toString
p=a5.z
p.toString
g=j.b
g===$&&A.c("end")
j.b=g+1
if(!(g>=0&&g<p.length))return A.a(p,g)
q.a1(p[g])}}q=a5.r
return J.B(B.d.gB(q.c),0,q.a)},
cB(a,b,c){return this.bw(a,b,c,null,null)},
iu(a,b,c){var s,r,q,p=t.L
p.a(a)
p.a(b)
for(p=b.length,s=b.$flags|0,r=0;r<c;++r){if(!(r<p))return A.a(b,r)
q=b[r]
if(!(q>=0&&q<65536))return A.a(a,q)
q=a[q]
s&2&&A.b(b)
b[r]=q}},
kH(a,b){var s,r,q,p,o,n
for(s=b.$flags|0,r=0,q=0;q<65536;++q){if(q!==0){p=q>>>3
if(!(p<8192))return A.a(a,p)
p=(a[p]&1<<(q&7))>>>0!==0}else p=!0
if(p){o=r+1
s&2&&A.b(b)
if(!(r<65536))return A.a(b,r)
b[r]=q
r=o}}for(o=r;o<65536;o=n){n=o+1
s&2&&A.b(b)
if(!(o<65536))return A.a(b,o)
b[o]=0}return r-1}}
A.fl.prototype={}
A.hd.prototype={
d0(){return this.x},
bw(a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.H.c6(a4.a4()),a3=a1.y
if(a3==null){a3=a1.w
a3.toString
a3=a1.y=A.Y(!1,a1.x*a3)}a3.a=0
s=A.j([0,0,0,0],t.t)
r=new Uint32Array(1)
q=J.B(B.o.gB(r),0,null)
if(a7==null)a7=a1.c.w
if(a8==null)a8=a1.c.cx
p=a5+a7-1
o=a6+a8-1
a3=a1.c
n=a3.w
if(p>n)p=n-1
n=a3.x
if(o>n)o=n-1
a1.a=p-a5+1
a1.b=o-a6+1
a3=a3.c
m=a3.length
for(n=q.length,l=a2.length,k=a6,j=0;k<=o;++k)for(i=0;i<m;++i){if(!(i<a3.length))return A.a(a3,i)
h=a3[i]
g=h.r
g===$&&A.c("ySampling")
if(B.a.a8(a6,g)!==0)continue
g=h.f
g===$&&A.c("xSampling")
f=B.a.au(a5,g)
e=B.a.au(p,g)
g=f*g<a5?0:1
d=e-f+g
if(0>=1)return A.a(r,0)
r[0]=0
g=h.c
g===$&&A.c("dataType")
switch(g.a){case 0:B.c.h(s,0,j)
B.c.h(s,1,s[0]+d)
B.c.h(s,2,s[1]+d)
j=s[2]+d
for(c=0;c<d;++c){g=s[0]
B.c.h(s,0,g+1)
if(!(g>=0&&g<l))return A.a(a2,g)
g=a2[g]
b=s[1]
B.c.h(s,1,b+1)
if(!(b>=0&&b<l))return A.a(a2,b)
b=a2[b]
a=s[2]
B.c.h(s,2,a+1)
if(!(a>=0&&a<l))return A.a(a2,a)
a=a2[a]
r[0]=r[0]+((g<<24|b<<16|a<<8)>>>0)
for(a0=0;a0<4;++a0){g=a1.y
g.toString
if(!(a0<n))return A.a(q,a0)
g.m(q[a0])}}break
case 1:B.c.h(s,0,j)
B.c.h(s,1,s[0]+d)
j=s[1]+d
for(c=0;c<d;++c){g=s[0]
B.c.h(s,0,g+1)
if(!(g>=0&&g<l))return A.a(a2,g)
g=a2[g]
b=s[1]
B.c.h(s,1,b+1)
if(!(b>=0&&b<l))return A.a(a2,b)
b=a2[b]
r[0]=r[0]+((g<<8|b)>>>0)
for(a0=0;a0<2;++a0){g=a1.y
g.toString
if(!(a0<n))return A.a(q,a0)
g.m(q[a0])}}break
case 2:B.c.h(s,0,j)
B.c.h(s,1,s[0]+d)
B.c.h(s,2,s[1]+d)
j=s[2]+d
for(c=0;c<d;++c){g=s[0]
B.c.h(s,0,g+1)
if(!(g>=0&&g<l))return A.a(a2,g)
g=a2[g]
b=s[1]
B.c.h(s,1,b+1)
if(!(b>=0&&b<l))return A.a(a2,b)
b=a2[b]
a=s[2]
B.c.h(s,2,a+1)
if(!(a>=0&&a<l))return A.a(a2,a)
a=a2[a]
r[0]=r[0]+((g<<24|b<<16|a<<8)>>>0)
for(a0=0;a0<4;++a0){g=a1.y
g.toString
if(!(a0<n))return A.a(q,a0)
g.m(q[a0])}}break}}a3=a1.y
return J.B(B.d.gB(a3.c),0,a3.a)},
cB(a,b,c){return this.bw(a,b,c,null,null)}}
A.he.prototype={
d0(){return 1},
bw(a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a0.c,a=A.Y(!1,(b-a0.d)*2)
if(a3==null)a3=c.c.w
if(a4==null)a4=c.c.cx
s=a1+a3-1
r=a2+a4-1
q=c.c
p=q.w
if(s>p)s=p-1
q=q.x
if(r>q)r=q-1
c.a=s-a1+1
c.b=r-a2+1
while(q=a0.d,q<b){p=a0.a
a0.d=q+1
q=J.d(p,q)
p=$.aq()
p.$flags&2&&A.b(p)
p[0]=q
q=$.az()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0){n=-o
for(;m=n-1,n>0;n=m)a.m(J.d(a0.a,a0.d++))}else for(n=o;m=n-1,n>=0;n=m)a.m(J.d(a0.a,a0.d++))}l=J.B(B.d.gB(a.c),0,a.a)
k=l.length
for(b=l.$flags|0,j=1;j<k;++j){q=l[j-1]
p=l[j]
b&2&&A.b(l)
l[j]=q+p-128}b=c.r
if(b==null||b.length!==k)b=c.r=new Uint8Array(k)
q=B.a.W(k+1,2)
for(i=0,h=0;;q=d,i=f){if(h<k){g=h+1
f=i+1
if(!(i<k))return A.a(l,i)
p=l[i]
b.$flags&2&&A.b(b)
e=b.length
if(!(h<e))return A.a(b,h)
b[h]=p}else break
if(g<k){h=g+1
d=q+1
if(!(q<k))return A.a(l,q)
q=l[q]
if(!(g<e))return A.a(b,g)
b[g]=q}else break}return b},
cB(a,b,c){return this.bw(a,b,c,null,null)},
D(a){return A.z(this.w)}}
A.eh.prototype={
d0(){return this.x},
bw(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=B.H.c6(a.a4())
if(d==null)d=f.c.w
if(a0==null)a0=f.c.cx
s=b+d-1
r=c+a0-1
q=f.c
p=q.w
if(s>p)s=p-1
q=q.x
if(r>q)r=q-1
f.a=s-b+1
f.b=r-c+1
o=e.length
for(q=e.$flags|0,n=1;n<o;++n){p=e[n-1]
m=e[n]
q&2&&A.b(e)
e[n]=p+m-128}q=f.y
if(q==null||q.length!==o)q=f.y=new Uint8Array(o)
p=B.a.W(o+1,2)
for(l=0,k=0;;p=g,l=i){if(k<o){j=k+1
i=l+1
if(!(l<o))return A.a(e,l)
m=e[l]
q.$flags&2&&A.b(q)
h=q.length
if(!(k<h))return A.a(q,k)
q[k]=m}else break
if(j<o){k=j+1
g=p+1
if(!(p<o))return A.a(e,p)
p=e[p]
if(!(j<h))return A.a(q,j)
q[j]=p}else break}return q},
cB(a,b,c){return this.bw(a,b,c,null,null)},
D(a){return A.z(this.w)}}
A.iT.prototype={
aq(a){var s=this.a
if(s==null)return null
s=s.c
if(!(a<s.length))return A.a(s,a)
return s[a].b},
b9(a,b){var s=new A.fT(A.j([],t.lv))
s.i3(a)
this.a=s
return this.aq(0)}}
A.e4.prototype={
lk(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(d===0&&e.c!=null){s=e.c
s.toString
return s}for(s=e.b,r=e.d,q=-1,p=-1,o=0;o<s;++o){n=r.b1(o)
m=r.b0(o)
l=r.b_(o)
k=r.b6(o)
if(n===a&&m===b&&l===c&&k===d)return o
j=a-n
i=b-m
h=c-l
g=d-k
f=j*j+i*i+h*h+g*g
if(p===-1){p=o
q=f}else if(f<q){p=o
q=f}}return p},
em(){var s,r,q,p,o,n,m,l=this
if(l.c==null)return l.d
s=l.d
r=s.a
q=new A.aN(new Uint8Array(r*4),r,4)
for(p=0;p<r;++p){o=s.b1(p)
n=s.b0(p)
m=s.b_(p)
q.d7(p,o,n,m,p===l.c?0:255)}return q}}
A.e5.prototype={
i5(a){var s,r,q,p,o,n,m=this
m.a=a.q()
m.b=a.q()
m.c=a.q()
m.d=a.q()
s=a.I()
m.e=(s&64)!==0
if((s&128)!==0){m.f=A.ne(B.a.R(1,(s&7)+1))
for(r=0;q=m.f,r<q.b;++r){p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n=J.d(a.a,a.d++)
q.d.b4(r,p,o,n)}}m.y=a.d-a.b}}
A.hf.prototype={}
A.e6.prototype={$iM:1}
A.iY.prototype={
b7(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.f=A.w(a,!1,null,0)
i.a=new A.e6(A.j([],t.e))
if(!i.fc())return null
try{while(p=i.f,o=p.d,o<p.c){n=p.a
p.d=o+1
s=J.d(n,o)
switch(s){case 44:r=i.fH()
if(r==null){p=i.a
return p}p=r
p.r=i.e
p.w=i.c
if(i.b!==0){if(r.f==null&&i.a.e!=null){p=i.a.e
o=p.a
n=p.b
m=p.c
p=p.d
r.f=new A.e4(o,n,m,new A.aN(new Uint8Array(A.q(p.c)),p.a,p.b))}if(r.f!=null)r.f.c=i.d}B.c.C(i.a.r,r)
break
case 33:p=i.f
q=J.d(p.a,p.d++)
if(J.bV(q,255)){p=i.f
if(p.ao(J.d(p.a,p.d++))==="NETSCAPE2.0"){l=J.d(p.a,p.d++)
k=J.d(p.a,p.d++)
if(l===3&&k===1)i.r=p.q()}else i.dt()}else if(J.bV(q,249)){p=i.f
p.toString
i.kp(p)}else i.dt()
break
case 59:p=i.a
return p
default:break}}}catch(j){}return i.a},
kp(a){var s,r,q,p=this
a.I()
s=a.I()
p.e=a.q()
p.d=a.I()
a.I()
p.c=B.a.j(s,2)&7
p.b=s&1
r=a.d8(1,0)
if(J.d(r.a,r.d)===44){++a.d
q=p.fH()
if(q==null)return
q.r=p.e
q.w=p.c
r=p.b!==0
q.x=r?p.d:-1
if(r){r=q.f
if(r==null&&p.a.e!=null){r=p.a.e
r.toString
r=q.f=A.pG(r)}if(r!=null)r.c=p.d}B.c.C(p.a.r,q)}},
aq(a){var s,r,q,p=this,o=p.f
if(o==null||p.a==null)return null
s=p.a.r
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.c("_inputPosition")
o.d=s
return p.j1(q)},
b9(a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null
if(a5.b7(a7)==null)return a6
s=a5.a.r.length
if(s===1)return a5.aq(0)
for(s=t.p,r=a6,q=r,p=0;o=a5.a.r,p<o.length;++p){a8=o[p]
n=a5.aq(p)
if(n==null)return a6
n.y=a8.r*10
if(q==null||r==null){n.r=a5.r
r=n
q=r
continue}o=n.a
m=o==null
l=m?a6:o.a
if(l==null)l=0
k=r.a
j=k==null
i=j?a6:k.a
h=!1
if(l===(i==null?0:i)){o=m?a6:o.b
if(o==null)o=0
m=j?a6:k.b
if(o===(m==null?0:m)){o=a8.a
o===$&&A.c("x")
if(o===0){o=a8.b
o===$&&A.c("y")
o=o===0&&a8.w===2}else o=h}else o=h}else o=h
if(o){q.aN(n)
r=n
continue}g=a8.f
if(!(g!=null)){o=a5.a.e
o.toString
g=o}o=j?a6:k.a
if(o==null)o=0
m=j?a6:k.b
if(m==null)m=0
f=A.Q(a6,a6,B.e,0,B.j,m,a6,0,1,g.em(),B.e,o,!1)
o=a8.w
if(o===2){o=f.a
e=o==null?a6:J.aA(o.gB(o))
if(e==null){o=f.a
o=o==null?a6:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
e=J.aA(o)}o=a8.x
m=e.length-1
if(o!==-1)B.d.ac(e,0,m,o)
else{o=a5.a.c.a
l=o.length
if(l!==0){if(0>=l)return A.a(o,0)
o=o[0]}else o=0
B.d.ac(e,0,m,o)}}else if(o!==3)if(a8.f!=null){o=r.a
d=o==null?a6:o.gO()
c=A.I(s,s)
for(o=d.a,b=0;b<o;++b)c.h(0,b,g.lk(d.b1(b),d.b0(b),d.b_(b),d.b6(b)))
o=f.a
a=o==null?a6:J.aA(o.gB(o))
if(a==null){o=f.a
o=o==null?a6:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
a=J.aA(o)}o=r.a
a0=o==null?a6:J.aA(o.gB(o))
if(a0==null){o=r.a
o=o==null?a6:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
a0=J.aA(o)}for(a1=a.length,o=a0.length,m=a.$flags|0,a2=0;a2<a1;++a2){if(!(a2<o))return A.a(a0,a2)
a3=c.l(0,a0[a2])
if(a3!=null&&a3!==-1){m&2&&A.b(a)
a[a2]=a3}}}f.y=n.y
for(o=n.a,o=o.gH(o);o.E();){a4=o.gN()
if(a4.gv()!==0){m=a4.gaZ()
l=a8.a
l===$&&A.c("x")
k=a4.gaW()
j=a8.b
j===$&&A.c("y")
f.ca(m+l,k+j,a4)}}q.aN(f)
r=f}return q},
fH(){var s,r=this.f
if(r.d>=r.c)return null
s=new A.hf()
s.i5(r);++this.f.d
this.dt()
return s},
j1(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=null
if(i.w==null){i.w=new Uint8Array(256)
i.x=new Uint8Array(4095)
i.y=new Uint8Array(4096)
i.z=new Uint32Array(4096)}s=i.Q=i.f.I()
r=B.a.V(1,s)
i.dy=r;++r
i.dx=r
i.db=r+1;++s
i.cy=s
i.cx=B.a.V(1,s)
i.ay=0
i.CW=4098
i.at=i.ax=0
s=i.w
s.toString
s.$flags&2&&A.b(s)
s[0]=0
s=i.z
s.toString
B.o.ac(s,0,4096,4098)
s=a.c
s===$&&A.c("width")
r=a.d
r===$&&A.c("height")
q=a.a
q===$&&A.c("x")
p=i.a
if(q+s<=p.a){q=a.b
q===$&&A.c("y")
q=q+r>p.b}else q=!0
if(q)return h
o=a.f
if(!(o!=null)){q=p.e
q.toString
o=q}i.as=s*r
n=A.Q(h,h,B.e,0,B.j,r,h,0,1,o.em(),B.e,s,!1)
m=new Uint8Array(s)
s=a.e
s===$&&A.c("interlaced")
if(s){s=a.b
s===$&&A.c("y")
for(r=s+r,l=0,k=0;l<4;++l)for(j=s+B.dA[l];j<r;j+=B.eZ[l],++k){if(!i.fd(m))return n
i.fO(n,j,o,m)}}else for(j=0;j<r;++j){if(!i.fd(m))return n
i.fO(n,j,o,m)}return n},
fO(a,b,c,d){var s,r,q,p=d.length
for(s=0;s<p;++s){r=d[s]
q=a.a
if(q!=null)q.aa(s,b,r,0,0)}},
fc(){var s,r,q,p,o,n=this,m=n.f.ao(6)
if(m!=="GIF87a"&&m!=="GIF89a")return!1
s=n.a
s.toString
s.a=n.f.q()
s=n.a
s.toString
s.b=n.f.q()
r=n.f.I()
s=n.a
s.toString
s.c=new A.b3(new Uint8Array(A.q(A.j([n.f.I()],t.t))));++n.f.d
if((r&128)!==0){s=n.a
s.toString
s.e=A.ne(B.a.R(1,(r&7)+1))
for(q=0;q<n.a.e.b;++q){s=n.f
p=J.d(s.a,s.d++)
s=n.f
o=J.d(s.a,s.d++)
s=n.f
r=J.d(s.a,s.d++)
n.a.e.d.b4(q,p,o,r)}}n.a.toString
return!0},
fd(a){var s=this,r=s.as
r.toString
s.as=r-a.length
if(!s.jc(a))return!1
if(s.as===0)s.dt()
return!0},
dt(){var s,r,q,p=this.f
if(p.d>=p.c)return!0
s=p.I()
for(;;){if(s!==0){p=this.f
p=p.d<p.c}else p=!1
if(!p)break
p=this.f
r=p.d+=s
if(r>=p.c)return!0
q=p.a
p.d=r+1
s=J.d(q,r)}return!0},
jc(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_stack",e="_suffix",d=g.ay
if(d>4095)return!1
s=a.length
r=0
if(d!==0){q=a.$flags|0
for(;;){if(!(d!==0&&r<s))break
p=r+1
o=g.x
o===$&&A.c(f)
d=g.ay=d-1
if(!(d>=0))return A.a(o,d)
o=o[d]
q&2&&A.b(a)
if(!(r<s))return A.a(a,r)
a[r]=o
r=p}}for(d=a.$flags|0;r<s;){n=g.ch=g.jb()
if(n==null)return!1
q=g.dx
if(n===q)return!1
o=g.dy
if(n===o){for(o=g.z,m=0;m<=4095;++m){o.toString
o.$flags&2&&A.b(o)
o[m]=4098}g.db=q+1
q=g.Q+1
g.cy=q
g.cx=B.a.V(1,q)
g.CW=4098}else{if(n<o){p=r+1
d&2&&A.b(a)
if(!(r>=0))return A.a(a,r)
a[r]=n
r=p}else{q=g.z
q.toString
if(n>>>0!==n||n>=4096)return A.a(q,n)
if(q[n]===4098){l=g.db-2
if(n===l){n=g.CW
k=g.y
k===$&&A.c(e)
j=g.x
j===$&&A.c(f)
i=g.ay++
o=g.dZ(q,n,o)
j.$flags&2&&A.b(j)
if(!(i>=0&&i<4095))return A.a(j,i)
j[i]=o
k.$flags&2&&A.b(k)
if(!(l>=0&&l<4096))return A.a(k,l)
k[l]=o}else return!1}m=0
for(;;){h=m+1
if(!(m<=4095&&n>g.dy&&n<=4095))break
q=g.x
q===$&&A.c(f)
o=g.ay++
l=g.y
l===$&&A.c(e)
if(!(n>=0&&n<4096))return A.a(l,n)
l=l[n]
q.$flags&2&&A.b(q)
if(!(o>=0&&o<4095))return A.a(q,o)
q[o]=l
n=g.z[n]
m=h}if(h>=4095||n>4095)return!1
q=g.x
q===$&&A.c(f)
o=g.ay
l=g.ay=o+1
q.$flags&2&&A.b(q)
if(!(o>=0&&o<4095))return A.a(q,o)
q[o]=n
o=l
for(;;){if(!(o!==0&&r<s))break
p=r+1
o=g.ay=o-1
if(!(o>=0&&o<4095))return A.a(q,o)
l=q[o]
d&2&&A.b(a)
if(!(r>=0&&r<s))return A.a(a,r)
a[r]=l
r=p}}q=g.CW
if(q!==4098){o=g.z
o.toString
l=g.db-2
if(!(l>=0&&l<4096))return A.a(o,l)
l=o[l]===4098
o=l}else o=!1
if(o){o=g.z
o.toString
l=g.db-2
o.$flags&2&&A.b(o)
if(!(l>=0&&l<4096))return A.a(o,l)
o[l]=q
k=g.ch
j=g.y
i=g.dy
if(k===l){j===$&&A.c(e)
q=g.dZ(o,q,i)
j.$flags&2&&A.b(j)
j[l]=q}else{j===$&&A.c(e)
k.toString
q=g.dZ(o,k,i)
j.$flags&2&&A.b(j)
j[l]=q}}q=g.ch
q.toString
g.CW=q}}return!0},
jb(){var s,r,q,p,o=this
if(o.cy>12)return null
while(s=o.ax,r=o.cy,s<r){s=o.iy()
s.toString
r=o.at
q=o.ax
o.at=(r|B.a.V(s,q))>>>0
o.ax=q+8}q=o.at
if(!(r>=0&&r<13))return A.a(B.bA,r)
p=B.bA[r]
o.at=B.a.a0(q,r)
o.ax=s-r
s=o.db
if(s<4097){++s
o.db=s
s=s>o.cx&&r<12}else s=!1
if(s){o.cx=o.cx<<1>>>0
o.cy=r+1}return q&p},
dZ(a,b,c){var s,r,q=0
for(;;){if(b>c){s=q+1
r=q<=4095
q=s}else r=!1
if(!r)break
if(b>4095)return 4098
a.toString
if(!(b>=0))return A.a(a,b)
b=a[b]}return b},
iy(){var s,r,q=this,p=q.w,o=p[0],n=p.$flags|0
if(o===0){o=q.f.I()
n&2&&A.b(p)
p[0]=o
p=q.w
o=p[0]
if(o===0)return null
B.d.ba(p,1,1+o,q.f.am(o).a4())
p=q.w
s=p[1]
p.$flags&2&&A.b(p)
p[1]=2
p[0]=p[0]-1}else{r=p[1]
n&2&&A.b(p)
p[1]=r+1
if(!(r<256))return A.a(p,r)
s=p[r]
p[0]=o-1}return s}}
A.iZ.prototype={
gfD(){return B.d8},
h1(a,b){var s,r,q,p=this
if(p.id==null){p.id=A.Y(!1,8192)
if(!a.gaP()){s=A.m1(a,256,10)
p.as=s
p.z=A.ox(a,B.aG,s,p.gfD(),1)}else p.z=a
p.Q=b
p.at=a.gS()
p.ax=a.gK()
return}if(p.ay===0){s=p.at
s===$&&A.c("_width")
r=p.ax
r===$&&A.c("_height")
p.fY(s,r)
p.fT()}s=p.z
s.toString
p.fX(s)
s=p.z
s.toString
r=p.at
r===$&&A.c("_width")
q=p.ax
q===$&&A.c("_height")
p.eE(s,r,q);++p.ay
if(!a.gaP()){s=A.m1(a,256,10)
p.as=s
p.z=A.ox(a,B.aG,s,p.gfD(),1)}else p.z=a
p.Q=b},
aN(a){return this.h1(a,null)},
dB(){var s,r,q,p,o=this
if(o.id==null)return null
if(o.ay===0){s=o.at
s===$&&A.c("_width")
r=o.ax
r===$&&A.c("_height")
o.fY(s,r)
o.fT()}s=o.z
s.toString
o.fX(s)
s=o.z
s.toString
r=o.at
r===$&&A.c("_width")
q=o.ax
q===$&&A.c("_height")
o.eE(s,r,q)
o.id.m(59)
o.as=o.z=null
o.ay=0
q=o.id
p=J.B(B.d.gB(q.c),0,q.a)
o.id=null
return p},
bI(a){var s,r,q,p=this,o=a.gab().length
if(o<=1){p.aN(a)
o=p.dB()
o.toString
return o}p.b=a.r
for(o=a.gab(),s=o.length,r=0;r<o.length;o.length===s||(0,A.K)(o),++r){q=o[r]
p.h1(q,B.a.W(q.y,10))}o=p.dB()
o.toString
return o},
eE(a,b,c){var s,r,q,p,o,n,m,l,k,j
if(!a.gaP())throw A.h(A.n("GIF can only encode palette images."))
s=a.a
r=s==null?null:s.gO()
q=r.a
p=this.id
p.m(44)
p.a1(0)
p.a1(0)
p.a1(b)
p.a1(c)
o=J.B(r.gB(r),0,null)
p.m(135)
n=r.b
if(n===3)p.a5(o)
else if(n===4)for(s=o.length,m=0,l=0;m<q;++m,l+=4){if(!(l<s))return A.a(o,l)
p.m(o[l])
k=l+1
if(!(k<s))return A.a(o,k)
p.m(o[k])
k=l+2
if(!(k<s))return A.a(o,k)
p.m(o[k])}else if(n===1||n===2)for(s=o.length,m=0,l=0;m<q;++m,l+=n){if(!(l>=0&&l<s))return A.a(o,l)
j=o[l]
p.m(j)
p.m(j)
p.m(j)}for(m=q;m<256;++m){p.m(0)
p.m(0)
p.m(0)}this.jl(a,b,c)},
jl(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d={}
e.go=e.CW=e.ch=0
e.fy=new Uint8Array(256)
e.id.m(8)
s=new Int32Array(5003)
r=new Int32Array(5003)
q=a.a
p=q.gH(q)
p.E()
e.cx=e.cy=9
e.dx=511
e.dy=256
e.db=257
e.fx=!1
e.fr=258
d.a=!1
o=new A.j_(d,p)
n=o.$0()
for(m=0,l=5003;l<65536;l*=2)++m
m=8-m
for(k=0;k<5003;++k)s[k]=-1
e.cL(e.dy)
for(j=!0;j;){i=o.$0()
for(j=!1;i!==-1;){h=(i<<12>>>0)+n
k=(B.a.V(i,m)^n)>>>0
if(!(k<5003))return A.a(s,k)
q=s[k]
if(q===h){n=r[k]
i=o.$0()
continue}else if(q>=0){g=5003-k
if(k===0)g=1
do{k-=g
if(k<0)k+=5003
if(!(k>=0&&k<5003))return A.a(s,k)
q=s[k]
if(q===h){n=r[k]
j=!0
break}}while(q>=0)
if(j)break}e.cL(n)
q=e.fr
if(q<4096){e.fr=q+1
r[k]=q
s[k]=h}else{for(k=0;k<5003;++k)s[k]=-1
q=e.dy
e.fr=q+2
e.fx=!0
e.cL(q)}f=o.$0()
n=i
i=f}}e.cL(n)
e.cL(e.db)
e.id.m(0)},
cL(a){var s,r=this,q=r.ch,p=r.CW
if(!(p>=0&&p<17))return A.a(B.c_,p)
q&=B.c_[p]
r.ch=q
if(p>0){q=(q|B.a.R(a,p))>>>0
r.ch=q}else{r.ch=a
q=a}p+=r.cx
r.CW=p
while(p>=8){r.eG(q&255)
q=B.a.j(r.ch,8)
r.ch=q
p=r.CW-=8}if(r.fr>r.dx||r.fx)if(r.fx){s=r.cy
r.cx=s
r.dx=B.a.R(1,s)-1
r.fx=!1}else{s=++r.cx
if(s===12)r.dx=4096
else r.dx=B.a.R(1,s)-1}if(a===r.db){while(p>0){r.eG(q&255)
q=B.a.j(r.ch,8)
r.ch=q
p=r.CW-=8}r.fU()}},
fU(){var s,r=this,q=r.go
if(q>0){r.id.m(q)
q=r.id
q.toString
s=r.fy
s===$&&A.c("_block")
q.hG(s,r.go)
r.go=0}},
eG(a){var s,r,q=this,p=q.fy
p===$&&A.c("_block")
s=q.go
r=s+1
q.go=r
p.$flags&2&&A.b(p)
if(!(s<256))return A.a(p,s)
p[s]=a
if(r>=254)q.fU()},
fT(){var s,r=this
r.id.m(33)
r.id.m(255)
r.id.m(11)
r.id.a5(new A.af("NETSCAPE2.0"))
s=r.id
s.toString
s.a5(A.j([3,1],t.t))
r.id.a1(r.b)
r.id.m(0)},
fX(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
h.id.m(33)
h.id.m(249)
h.id.m(4)
s=a.a
r=s==null?null:s.gO()
q=r.b
p=q-1
o=0
n=0
if(q===4||q===2){m=J.B(r.gB(r),0,null)
l=r.a
for(s=m.length,k=p,j=o;j<l;++j,k+=q){if(!(k>=0&&k<s))return A.a(m,k)
if(m[k]===0){o=j
n=1
break}}}h.id.m(n|8)
s=h.id
s.toString
i=h.Q
s.a1(i==null?80:i)
h.id.m(o)
h.id.m(0)},
fY(a,b){var s=this
s.id.a5(new A.af("GIF89a"))
s.id.a1(a)
s.id.a1(b)
s.id.m(0)
s.id.m(0)
s.id.m(0)}}
A.j_.prototype={
$0(){var s,r,q=this.a
if(q.a)return-1
s=this.b
r=A.m(s.gN().gU())
if(!s.E())q.a=!0
return r},
$S:43}
A.d8.prototype={
a7(){return"IcoType."+this.b}}
A.h1.prototype={$iM:1}
A.h2.prototype={}
A.h_.prototype={
gK(){return B.a.W(A.bw.prototype.gK.call(this),2)},
gcY(){return!(this.d===40&&this.f===32)&&A.bw.prototype.gcY.call(this)}}
A.j1.prototype={
b9(a,b){var s,r,q,p=this,o=A.w(a,!1,null,0)
p.a=o
s=p.b=A.nf(o)
if(s==null)return null
o=s.e.length
if(o===1)return p.aq(0)
for(r=null,q=0;q<p.b.e.length;++q){b=p.aq(q)
if(b==null)continue
if(r==null){b.w=B.j
r=b}else r.aN(b)}return r},
aq(b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=null,a9=this.a
if(a9!=null){s=this.b
s=s==null||b0>=s.d}else s=!0
if(s)return a8
s=this.b.e
if(!(b0<s.length))return A.a(s,b0)
r=s[b0]
s=a9.a
a9=a9.b+r.e
q=r.d
p=J.lM(s,a9,a9+q)
o=new A.hD(A.nr())
t.D.a(p)
if(o.bB(p))return o.c5(p)
n=A.Y(!1,14)
n.a1(19778)
n.J(q)
n.J(0)
n.J(0)
a9=A.w(p,!1,a8,0)
s=A.n0(A.w(J.B(B.d.gB(n.c),0,n.a),!1,a8,0))
q=a9.d
m=a9.k()
l=a9.k()
k=$.P()
k.$flags&2&&A.b(k)
k[0]=l
l=$.a7()
if(0>=l.length)return A.a(l,0)
j=l[0]
k[0]=a9.k()
l=l[0]
i=a9.q()
h=a9.q()
g=a9.k()
if(g>=14)A.ax(A.n("Unsupported BMP compression type: "+g))
if(!(g<14))return A.a(B.aw,g)
g=B.aw[g]
a9.k()
k[0]=a9.k()
k[0]=a9.k()
k=a9.k()
a9.k()
f=new A.h_(s,j,l,m,i,h,g,k,q)
f.eB(a9,s)
if(m!==40&&i!==1)return a8
e=k===0&&h<=8?40+4*B.a.R(1,h):40+4*k
s.b=e
n.a-=4
n.J(e)
d=A.w(p,!1,a8,0)
c=new A.iQ(!0)
c.a=d
c.b=f
b=c.aq(0)
if(h>=32)return b
a=32-B.a.a8(j,32)
a0=B.a.W(a===32?j:j+a,8)
for(a9=l<0,s=l===0,l=1/l<0,a1=0;a1<B.a.W(A.bw.prototype.gK.call(f),2);++a1){if(!(s?l:a9))a2=a1
else{q=b.a
q=q==null?a8:q.b
a2=(q==null?0:q)-1-a1}a3=d.aA(a0)
d.d=d.d+(a3.c-a3.d)
q=b.a
a4=q==null?a8:q.P(0,a2,a8)
if(a4==null)a4=new A.F()
for(a5=0;a5<j;){a6=J.d(a3.a,a3.d++)
a7=7
for(;;){if(!(a7>-1&&a5<j))break
if((a6&B.a.V(1,a7))>>>0!==0)a4.sv(0)
a4.E();++a5;--a7}}}return b}}
A.kq.prototype={
bI(a){var s=a.gab().length
if(s>1)return this.hn(a.gab())
else return this.hn(A.j([a],t.g))},
hn(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null
t.aL.a(a)
s=a.length
r=A.Y(!1,8192)
r.a1(0)
r.a1(1)
r.a1(s)
q=6+s*16
p=A.j([A.j([],t.t)],t.S)
for(o=a.length,n=0,m=0;m<a.length;a.length===o||(0,A.K)(a),++m){l=a[m]
k=l.a
j=k==null
i=j?g:k.a
if((i==null?0:i)<=256){i=j?g:k.b
i=(i==null?0:i)>256}else i=!0
if(i)throw A.h(A.na("ICO and CUR support only sizes until 256"))
k=j?g:k.a
r.m(k==null?0:k)
k=l.a
k=k==null?g:k.b
r.m(k==null?0:k)
r.m(0)
r.m(0)
r.a1(0)
r.a1(32)
h=new A.hE().bI(l)
k=h.length
r.J(k)
r.J(q)
q+=k;++n
B.c.C(p,h)}for(o=p.length,m=0;m<p.length;p.length===o||(0,A.K)(p),++m)r.a5(p[m])
return J.B(B.d.gB(r.c),0,r.a)}}
A.h0.prototype={}
A.fJ.prototype={}
A.bW.prototype={}
A.ck.prototype={}
A.ea.prototype={}
A.lk.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-a,b,c,d,e)},
$S:4}
A.ll.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-a,this.c-b,c,d,e)},
$S:4}
A.lm.prototype={
$5(a,b,c,d,e){return this.a.aa(a,this.b-b,c,d,e)},
$S:4}
A.ln.prototype={
$5(a,b,c,d,e){return this.a.aa(b,a,c,d,e)},
$S:4}
A.lo.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-b,a,c,d,e)},
$S:4}
A.lp.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-b,this.c-a,c,d,e)},
$S:4}
A.lq.prototype={
$5(a,b,c,d,e){return this.a.aa(b,this.b-a,c,d,e)},
$S:4}
A.je.prototype={}
A.c_.prototype={}
A.jg.prototype={
lU(a){var s,r,q,p,o,n=this,m=A.w(t.L.a(a),!0,null,0)
n.a=m
s=m.d8(2,0)
if(J.d(s.a,s.d)!==255||J.d(s.a,s.d+1)!==216)return!1
if(n.cf()!==216)return!1
r=n.cf()
q=!1
p=!1
for(;;){if(r!==217){m=n.a
m=m.d<m.c}else m=!1
if(!m)break
o=n.a.q()
if(o<2)break
m=n.a
m.d=m.d+(o-2)
switch(r){case 192:case 193:case 194:q=!0
break
case 218:p=!0
break}r=n.cf()}return q&&p},
c9(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
h.a=A.w(t.L.a(a),!0,null,0)
h.ki()
if(h.y.length!==1)throw A.h(A.n("Only single frame JPEGs supported"))
s=h.d
for(r=s.z,q=s.y,p=h.as,o=0;o<r.length;++o){n=q.l(0,r[o])
m=n.a
l=s.f
k=n.b
j=s.r
i=h.iA(s,n)
if(m===l)m=0
else m=m===1&&l===4?2:1
if(k===j)l=0
else l=k===1&&j===4?2:1
B.c.C(p,new A.fJ(i,m,l))}},
ki(){var s,r,q,p,o,n,m=this
if(m.cf()!==216)throw A.h(A.n("Start Of Image marker not found."))
s=m.cf()
for(;;){if(s!==217){r=m.a
r===$&&A.c("input")
r=r.d<r.c}else r=!1
if(!r)break
A:{if(s>=208&&s<=215||s===1){s=m.cf()
break A}r=m.a
r===$&&A.c("input")
q=r.q()
if(q<2)A.ax(A.n("Invalid Block"))
r=m.a
p=r.aA(q-2)
o=r.d=r.d+(p.c-p.d)
switch(s){case 224:case 225:case 226:case 227:case 228:case 229:case 230:case 231:case 232:case 233:case 234:case 235:case 236:case 237:case 238:case 239:case 254:m.kj(s,p)
break
case 219:m.km(p)
break
case 192:case 193:case 194:m.ko(s,p)
break
case 195:case 197:case 198:case 199:case 200:case 201:case 202:case 203:case 205:case 206:case 207:throw A.h(A.n("Unhandled frame type "+B.a.dF(s,16)))
case 196:m.kl(p)
break
case 221:m.e=p.q()
break
case 218:m.kB(p)
break
case 255:if(J.d(r.a,o)!==255)--m.a.d
break
default:n=!1
if(J.d(r.a,o+-3)===255){r=m.a
if(J.d(r.a,r.d+-2)>=192){r=m.a
r=J.d(r.a,r.d+-2)<=254}else r=n}else r=n
if(r){m.a.d-=3
break}if(s!==0)throw A.h(A.n("Unknown JPEG marker "+B.a.dF(s,16)))
break}s=m.cf()}}},
cf(){var s,r=this,q=r.a
q===$&&A.c("input")
if(q.d>=q.c)return 0
do{do{s=r.a.I()
if(s!==255){q=r.a
q=q.d<q.c}else q=!1}while(q)
q=r.a
if(q.d>=q.c)return s
do{s=r.a.I()
if(s===255){q=r.a
q=q.d<q.c}else q=!1}while(q)
if(s===0){q=r.a
q=q.d<q.c}else q=!1}while(q)
return s},
kt(a){var s
for(s=0;s<12;++s)if(J.d(a.a,a.d++)!==B.kt[s])return
this.r=new A.bB("ICC_PROFILE",B.S,a.a4())},
kn(a){if(a.k()!==1165519206)return
if(a.q()!==0)return
this.w.c9(a)},
kj(a,b){var s,r,q,p,o,n=this,m=b
if(a===224){s=m
r=!1
if(J.d(s.a,s.d)===74){s=m
if(J.d(s.a,s.d+1)===70){s=m
if(J.d(s.a,s.d+2)===73){s=m
if(J.d(s.a,s.d+3)===70){s=m
s=J.d(s.a,s.d+4)===0}else s=r}else s=r}else s=r}else s=r
if(s){s=new A.ji()
r=m
J.d(r.a,r.d+5)
r=m
J.d(r.a,r.d+6)
r=m
J.d(r.a,r.d+7)
r=m
J.d(r.a,r.d+8)
r=m
J.d(r.a,r.d+9)
r=m
J.d(r.a,r.d+10)
r=m
J.d(r.a,r.d+11)
r=m
r=J.d(r.a,r.d+12)
s.f=r
q=m
q=J.d(q.a,q.d+13)
s.r=q
n.b=s
m.d8(14+3*r*q,14)}}else if(a===225)n.kn(m)
else if(a===226)n.kt(m)
else if(a===238){s=m
r=!1
if(J.d(s.a,s.d)===65){s=m
if(J.d(s.a,s.d+1)===100){s=m
if(J.d(s.a,s.d+2)===111){s=m
if(J.d(s.a,s.d+3)===98){s=m
if(J.d(s.a,s.d+4)===101){s=m
s=J.d(s.a,s.d+5)===0}else s=r}else s=r}else s=r}else s=r}else s=r
if(s){p=new A.je()
s=m
J.d(s.a,s.d+6)
s=m
J.d(s.a,s.d+7)
s=m
J.d(s.a,s.d+8)
s=m
J.d(s.a,s.d+9)
s=m
J.d(s.a,s.d+10)
s=m
p.d=J.d(s.a,s.d+11)
n.c=p}}else if(a===254)try{m.lG()}catch(o){}},
km(a){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=this.x;q=a.d,p=q<s,p;){p=a.a
a.d=q+1
o=J.d(p,q)
n=B.a.j(o,4)
o&=15
if(o>=4)throw A.h(A.n("Invalid number of quantization tables"))
if(r[o]==null)B.c.h(r,o,new Int16Array(64))
m=r[o]
for(q=n!==0,l=0;l<64;++l){k=q?a.q():J.d(a.a,a.d++)
m.toString
p=$.iD()
if(!(l<p.length))return A.a(p,l)
p=p[l]
m.$flags&2&&A.b(m)
if(!(p<64))return A.a(m,p)
m[p]=k}}if(p)throw A.h(A.n("Bad length for DQT block"))},
ko(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
if(i.d!=null)throw A.h(A.n("Duplicate JPG frame data found."))
s=A.I(t.p,t.e7)
r=A.j([],t.t)
q=new A.hp(s,r)
q.b=a===194
q.c=b.I()
q.d=b.q()
q.e=b.q()
p=b.I()
for(o=i.x,n=0;n<p;++n){m=J.d(b.a,b.d++)
l=J.d(b.a,b.d++)
k=B.a.j(l,4)
j=J.d(b.a,b.d++)
B.c.C(r,m)
s.h(0,m,new A.c_(k&15,l&15,o,j))}q.lA()
i.d=q
B.c.C(i.y,q)},
kl(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.c,r=this.Q,q=this.z;p=a.d,p<s;){o=a.a
a.d=p+1
n=J.d(o,p)
m=new Uint8Array(16)
for(l=0,k=0;k<16;++k){p=J.d(a.a,a.d++)
if(!(k<16))return A.a(m,k)
m[k]=p
l+=m[k]}j=a.aA(l)
a.d=a.d+(j.c-j.d)
i=j.a4()
if((n&16)!==0){n-=16
h=q}else h=r
if(h.length<=n)B.c.sA(h,n+1)
B.c.h(h,n,this.jT(m,i))}},
kB(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a.I()
if(b<1||b>4)throw A.h(A.n("Invalid SOS block"))
s=c.d
s.toString
r=A.j([],t.ns)
for(q=c.z,p=c.Q,o=s.y,n=t.hQ,m=0;m<b;++m){l=J.d(a.a,a.d++)
k=J.d(a.a,a.d++)
if(!o.a9(l))throw A.h(A.n("Invalid Component in SOS block"))
j=o.l(0,l)
j.toString
i=B.a.j(k,4)&15
h=k&15
g=p.length
if(i<g){if(!(i<g))return A.a(p,i)
g=p[i]
g.toString
j.w=n.a(g)}g=q.length
if(h<g){if(!(h<g))return A.a(q,h)
g=q[h]
g.toString
j.x=n.a(g)}B.c.C(r,j)}f=a.I()
e=a.I()
d=a.I()
q=B.a.j(d,4)
p=c.a
p===$&&A.c("input")
q=new A.hq(p,s,r,c.e,f,e,q&15,d&15)
p=s.w
p===$&&A.c("mcusPerLine")
q.f=p
q.r=s.b
q.bT()},
jT(a,b){var s,r,q,p,o,n,m,l,k=A.j([],t.kv),j=16
for(;;){if(!(j>0&&a[j-1]===0))break;--j}s=t.er
B.c.C(k,new A.dJ(A.E(2,null,!1,s)))
if(0>=k.length)return A.a(k,0)
r=k[0]
for(q=b.length,p=0,o=0;o<j;){for(n=0;n<a[o];++n){if(0>=k.length)return A.a(k,-1)
r=k.pop()
m=r.b
if(!(p>=0&&p<q))return A.a(b,p)
B.c.h(r.a,m,new A.ea(b[p]))
while(m=r.b,m>0){if(0>=k.length)return A.a(k,-1)
r=k.pop()}r.b=m+1
B.c.C(k,r)
for(;k.length<=o;r=l){m=A.E(2,null,!1,s)
l=new A.dJ(m)
B.c.C(k,l)
B.c.h(r.a,r.b,new A.ck(m))}++p}++o
if(o<j){m=A.E(2,null,!1,s)
l=new A.dJ(m)
B.c.C(k,l)
B.c.h(r.a,r.b,new A.ck(m))
r=l}}if(0>=k.length)return A.a(k,0)
return k[0].a},
iA(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a1.e
a===$&&A.c("blocksPerLine")
s=a1.f
s===$&&A.c("blocksPerColumn")
r=a<<3>>>0
q=new Int32Array(64)
p=new Uint8Array(64)
o=s*8
n=A.E(o,null,!1,t.nh)
for(m=a1.c,l=a1.d,k=0,j=0;j<s;++j){i=j<<3>>>0
for(h=0;h<8;++h,k=g){g=k+1
B.c.h(n,k,new Uint8Array(r))}for(f=0;f<a;++f){if(!(l>=0&&l<4))return A.a(m,l)
e=m[l]
e.toString
d=a1.r
d===$&&A.c("blocks")
if(!(j<d.length))return A.a(d,j)
d=d[j]
if(!(f<d.length))return A.a(d,f)
A.uA(e,d[f],p,q)
c=f<<3>>>0
for(e=c+8,b=0;b<8;++b){d=i+b
if(!(d<o))return A.a(n,d)
d=n[d]
if(d!=null)B.d.ar(d,c,e,p,b<<3>>>0)}}}return n}}
A.dJ.prototype={}
A.hp.prototype={
lA(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this
for(s=a.y,r=A.l(s).p("R<1>"),q=new A.R(s,s.r,s.e,r);q.E();){p=s.l(0,q.d)
a.f=Math.max(a.f,p.a)
a.r=Math.max(a.r,p.b)}q=a.e
q.toString
a.w=B.b.bc(q/8/a.f)
q=a.d
q.toString
a.x=B.b.bc(q/8/a.r)
for(r=new A.R(s,s.r,s.e,r),q=t.n5,o=t.k,n=t.kn;r.E();){m=s.l(0,r.d)
m.toString
l=a.e
l.toString
k=m.a
j=B.b.bc(B.b.bc(l/8)*k/a.f)
l=a.d
l.toString
i=m.b
h=B.b.bc(B.b.bc(l/8)*i/a.r)
g=a.w*k
f=a.x*i
e=J.a8(f,n)
for(d=0;d<f;++d){c=J.a8(g,o)
for(b=0;b<g;++b)c[b]=new Int32Array(64)
e[d]=c}m.e=j
m.f=h
m.r=q.a(e)}}}
A.ji.prototype={}
A.hq.prototype={
bT(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a="blocksPerLine",a0=b.y,a1=a0.length,a2=b.r
a2.toString
if(a2)if(b.Q===0)s=b.at===0?b.giY():b.gj_()
else s=b.at===0?b.giP():b.giR()
else s=b.giV()
a2=a1===1
if(a2){if(0>=a1)return A.a(a0,0)
r=a0[0]
q=r.e
q===$&&A.c(a)
r=r.f
r===$&&A.c("blocksPerColumn")
p=q*r}else{r=b.f
r===$&&A.c("mcusPerLine")
q=b.b.x
q===$&&A.c("mcusPerColumn")
p=r*q}r=b.z
if(r==null||r===0)b.z=p
for(r=b.a,q=t.mX,o=0;o<p;){for(n=0;n<a1;++n){if(!(n<a0.length))return A.a(a0,n)
a0[n].y=0}b.CW=0
if(a2){if(0>=a0.length)return A.a(a0,0)
m=a0[0]
l=0
for(;;){k=b.z
k.toString
if(!(l<k))break
q.a(s)
k=m.e
k===$&&A.c(a)
j=B.a.au(o,k)
i=B.a.a8(o,k)
k=m.r
k===$&&A.c("blocks")
if(!(j>=0&&j<k.length))return A.a(k,j)
k=k[j]
if(!(i>=0&&i<k.length))return A.a(k,i)
s.$2(m,k[i]);++o;++l}}else{l=0
for(;;){k=b.z
k.toString
if(!(l<k))break
for(n=0;n<a1;++n){if(!(n<a0.length))return A.a(a0,n)
m=a0[n]
h=m.a
g=m.b
for(f=0;f<g;++f)for(e=0;e<h;++e)b.j2(m,s,o,f,e)}++o;++l}}b.ch=0
if(o>=p)break
d=J.d(r.a,r.d)
c=J.d(r.a,r.d+1)
if(d===255)if(c>=208&&c<=215)r.d+=2
else break}},
ci(){var s,r=this,q=r.ch
if(q>0){--q
r.ch=q
return B.a.aL(r.ay,q)&1}q=r.a
if(q.d>=q.c)return null
s=q.I()
r.ay=s
if(s===255)if(q.I()!==0)return null
r.ch=7
return B.a.j(r.ay,7)&1},
cK(a){var s,r,q=new A.ck(t.hQ.a(a))
while(s=this.ci(),s!=null){if(q instanceof A.ck){r=q.a
if(s>>>0!==s||s>=2)return A.a(r,s)
q=r[s]}if(q instanceof A.ea)return q.a}return null},
e7(a){var s,r
for(s=0;a>0;){r=this.ci()
if(r==null)return null
s=(s<<1|r)>>>0;--a}return s},
cO(a){var s
if(a==null)return 0
if(a===1)return this.ci()===1?1:-1
s=this.e7(a)
if(s==null)return 0
if(s>=B.a.V(1,a-1))return s
return s+B.a.R(-1,a)+1},
iW(a,b){var s,r,q,p,o,n,m,l,k=this
t.L.a(b)
s=a.w
s===$&&A.c("huffmanTableDC")
r=k.cK(s)
q=r===0?0:k.cO(r)
s=a.y
s===$&&A.c("pred")
s+=q
a.y=s
b.$flags&2&&A.b(b)
b[0]=s
for(p=1;p<64;){s=a.x
s===$&&A.c("huffmanTableAC")
o=k.cK(s)
if(o==null)break
n=o&15
m=o>>>4
if(n===0){if(m<15)break
p+=16
continue}p+=m
n=k.cO(n)
s=$.iD()
if(!(p>=0&&p<s.length))return A.a(s,p)
l=s[p]
b.$flags&2&&A.b(b)
if(!(l<64))return A.a(b,l)
b[l]=n;++p}},
iZ(a,b){var s,r,q
t.L.a(b)
s=a.w
s===$&&A.c("huffmanTableDC")
r=this.cK(s)
q=r===0?0:B.a.R(this.cO(r),this.ax)
s=a.y
s===$&&A.c("pred")
s+=q
a.y=s
b.$flags&2&&A.b(b)
b[0]=s},
j0(a,b){var s,r
t.L.a(b)
s=b[0]
r=this.ci()
r.toString
r=B.a.R(r,this.ax)
b.$flags&2&&A.b(b)
b[0]=(s|r)>>>0},
iQ(a,b){var s,r,q,p,o,n,m,l,k=this
t.L.a(b)
s=k.CW
if(s>0){k.CW=s-1
return}r=k.Q
q=k.as
for(s=k.ax;r<=q;){p=a.x
p===$&&A.c("huffmanTableAC")
p=k.cK(p)
p.toString
o=p&15
n=p>>>4
if(o===0){if(n<15){s=k.e7(n)
s.toString
k.CW=s+B.a.R(1,n)-1
break}r+=16
continue}r+=n
p=$.iD()
if(!(r>=0&&r<p.length))return A.a(p,r)
m=p[r]
p=k.cO(o)
l=B.a.R(1,s)
b.$flags&2&&A.b(b)
if(!(m<64))return A.a(b,m)
b[m]=p*l;++r}},
iS(a,b){var s,r,q,p,o,n,m,l,k,j=this
t.L.a(b)
s=j.Q
r=j.as
A:for(q=j.ax,p=0;s<=r;){o=$.iD()
if(!(s>=0&&s<o.length))return A.a(o,s)
n=o[s]
o=j.cx
switch(o){case 0:o=a.x
o===$&&A.c("huffmanTableAC")
m=j.cK(o)
if(m==null)throw A.h(A.n("Invalid progressive encoding"))
l=m&15
p=m>>>4
if(l===0)if(p<15){o=j.e7(p)
o.toString
j.CW=o+B.a.R(1,p)
j.cx=4}else{j.cx=1
p=16}else{if(l!==1)throw A.h(A.n("invalid ACn encoding"))
j.cy=j.cO(l)
j.cx=p!==0?2:3}continue A
case 1:case 2:if(!(n<64))return A.a(b,n)
k=b[n]
if(k!==0){o=j.ci()
o.toString
o=B.a.R(o,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=k+o}else{--p
if(p===0)j.cx=o===2?3:0}break
case 3:if(!(n<64))return A.a(b,n)
o=b[n]
if(o!==0){k=j.ci()
k.toString
k=B.a.R(k,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=o+k}else{o=j.cy
o===$&&A.c("successiveACNextValue")
o=B.a.R(o,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=o
j.cx=0}break
case 4:if(!(n<64))return A.a(b,n)
o=b[n]
if(o!==0){k=j.ci()
k.toString
k=B.a.R(k,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=o+k}break}++s}if(j.cx===4)if(--j.CW===0)j.cx=0},
j2(a,b,c,d,e){var s,r,q,p,o
t.mX.a(b)
s=this.f
s===$&&A.c("mcusPerLine")
r=B.a.au(c,s)*a.b+d
q=B.a.a8(c,s)*a.a+e
s=a.r
s===$&&A.c("blocks")
p=s.length
if(r>=p)return
if(!(r>=0))return A.a(s,r)
s=s[r]
o=s.length
if(q>=o)return
if(!(q>=0))return A.a(s,q)
b.$2(a,s[q])}}
A.ho.prototype={
bB(a){var s=a.length,r=!0
if(s>=2){if(0>=s)return A.a(a,0)
if(a[0]===255){if(1>=s)return A.a(a,1)
s=a[1]!==216}else s=r}else s=r
if(s)return!1
return A.nw().lU(a)},
b9(a,b){var s=A.nw()
s.c9(a)
if(s.y.length!==1)throw A.h(A.n("only single frame JPEGs supported"))
return A.uh(s)},
c5(a){return this.b9(a,null)}}
A.jf.prototype={
a7(){return"JpegChroma."+this.b}}
A.jh.prototype={
hT(a){a=B.a.i(B.a.G(a,1,100))
if(this.at===a)return
this.jN(a<50?B.b.bq(5000/a):B.a.bq(200-a*2))
this.at=a},
bI(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=A.Y(!0,8192)
b.bQ(a,216)
b.bQ(a,224)
a.a1(16)
a.m(74)
a.m(70)
a.m(73)
a.m(70)
a.m(0)
a.m(1)
a.m(1)
a.m(0)
a.a1(1)
a.a1(1)
a.m(0)
a.m(0)
b.kU(a,a0.gbp())
s=a0.c
if(s!=null){b.bQ(a,226)
r=s.hi()
q=A.j([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
a.a1(14+r.length)
a.a5(q)
a.a5(r)}b.kS(a)
s=a0.gS()
p=a0.gK()
b.bQ(a,192)
a.a1(17)
a.m(8)
a.a1(p)
a.a1(s)
a.m(3)
a.m(1)
a.m(17)
a.m(0)
a.m(2)
a.m(17)
a.m(1)
a.m(3)
a.m(17)
a.m(1)
b.kR(a)
b.bQ(a,218)
a.a1(12)
a.m(3)
a.m(1)
a.m(0)
a.m(2)
a.m(17)
a.m(3)
a.m(17)
a.m(0)
a.m(63)
a.m(0)
b.ax=0
b.ay=7
o=a0.gS()
n=a0.gK()
m=a0.f
if(m==null)m=B.d_
l=new Float32Array(64)
k=new Float32Array(64)
j=new Float32Array(64)
for(s=b.c,p=b.d,i=0,h=0,g=0,f=0;f<n;f+=8)for(e=0;e<o;e+=8){b.iG(a0,e,f,o,n,l,k,j,m)
d=b.e
c=b.r
c===$&&A.c("_yacHuffman")
i=b.e5(a,l,s,i,d,c)
c=b.f
d=b.w
d===$&&A.c("_uvacHuffman")
h=b.e5(a,k,p,h,c,d)
g=b.e5(a,j,p,g,b.f,b.w)}s=b.ay
if(s>=0){++s
b.bP(a,A.j([B.a.V(1,s)-1,s],t.t))}b.bQ(a,217)
return J.B(B.d.gB(a.c),0,a.a)},
iG(a,b,c,d,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
for(s=this.as,r=c+1,q=0;q<64;++q){p=q>>>3
o=c+p
n=b+(q&7)
if(o>=a0)o-=r+p-a0
if(n>=d)n-=n-d+1
m=a.a
l=m==null?null:m.P(n,o,null)
if(l==null)l=new A.F()
if(l.gM()!==B.e)l=l.aS(B.e)
if(l.gA(l)>3){k=l.ga_()
j=1-k
l.sn(B.b.av(l.gn()*k+a4.gn()*j))
l.st(B.b.av(l.gt()*k+a4.gt()*j))
l.su(B.b.av(l.gu()*k+a4.gu()*j))}i=B.b.i(l.gn())
h=B.b.i(l.gt())
g=B.b.i(l.gu())
if(!(i>=0&&i<2048))return A.a(s,i)
m=s[i]
f=h+256
if(!(f>=0&&f<2048))return A.a(s,f)
f=s[f]
e=g+512
if(!(e>=0&&e<2048))return A.a(s,e)
e=B.a.j(m+f+s[e],16)
a1.$flags&2&&A.b(a1)
if(!(q<64))return A.a(a1,q)
a1[q]=e-128
e=i+768
if(!(e<2048))return A.a(s,e)
e=s[e]
f=h+1024
if(!(f>=0&&f<2048))return A.a(s,f)
f=s[f]
m=g+1280
if(!(m>=0&&m<2048))return A.a(s,m)
m=B.a.j(e+f+s[m],16)
a2.$flags&2&&A.b(a2)
if(!(q<64))return A.a(a2,q)
a2[q]=m-128
m=i+1280
if(!(m<2048))return A.a(s,m)
m=s[m]
f=h+1536
if(!(f>=0&&f<2048))return A.a(s,f)
f=s[f]
e=g+1792
if(!(e>=0&&e<2048))return A.a(s,e)
e=B.a.j(m+f+s[e],16)
a3.$flags&2&&A.b(a3)
if(!(q<64))return A.a(a3,q)
a3[q]=e-128}},
bQ(a,b){a.m(255)
a.m(b&255)},
jN(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.a,r=s.$flags|0,q=0;q<64;++q){p=B.b.bq((B.iQ[q]*a+50)/100)
if(p<1)p=1
else if(p>255)p=255
o=B.a3[q]
r&2&&A.b(s)
if(!(o<64))return A.a(s,o)
s[o]=p}for(r=b.b,o=r.$flags|0,n=0;n<64;++n){m=B.b.bq((B.eK[n]*a+50)/100)
if(m<1)m=1
else if(m>255)m=255
l=B.a3[n]
o&2&&A.b(r)
if(!(l<64))return A.a(r,l)
r[l]=m}for(o=b.c,l=o.$flags|0,k=b.d,j=k.$flags|0,i=0,h=0;h<8;++h)for(g=0;g<8;++g){if(!(i>=0&&i<64))return A.a(B.a3,i)
f=B.a3[i]
if(!(f<64))return A.a(s,f)
e=s[f]
d=B.bz[h]
c=B.bz[g]
l&2&&A.b(o)
o[i]=1/(e*d*c*8)
f=r[f]
j&2&&A.b(k)
k[i]=1/(f*d*c*8);++i}},
dd(a,b){var s,r,q,p,o,n,m,l=t.L
l.a(a)
l.a(b)
l=t.t
s=A.j([A.j([],l)],t.iZ)
for(r=b.length,q=0,p=0,o=1;o<=16;++o){for(n=1;n<=a[o];++n){if(!(p>=0&&p<r))return A.a(b,p)
m=b[p]
if(s.length<=m)B.c.sA(s,m+1)
B.c.h(s,m,A.j([q,o],l));++p;++q}q*=2}return s},
jL(){var s,r,q,p,o,n,m,l,k,j,i
for(s=this.y,r=this.x,q=t.t,p=1,o=2,n=1;n<=15;++n){for(m=p;m<o;++m){l=32767+m
B.c.h(s,l,n)
B.c.h(r,l,A.j([m,n],q))}for(l=o-1,k=-l,j=-p;k<=j;++k){i=32767+k
B.c.h(s,i,n)
B.c.h(r,i,A.j([l+k,n],q))}p=p<<1>>>0
o=o<<1>>>0}},
jO(){var s,r,q
for(s=this.as,r=s.$flags|0,q=0;q<256;++q){r&2&&A.b(s)
s[q]=19595*q
s[q+256]=38470*q
s[q+512]=7471*q+32768
s[q+768]=-11059*q
s[q+1024]=-21709*q
s[q+1280]=32768*q+8421375
s[q+1536]=-27439*q
s[q+1792]=-5329*q}},
jq(d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5=t.H
d5.a(d6)
d5.a(d7)
for(d5=d6.$flags|0,s=0,r=0;r<8;++r){if(!(s<64))return A.a(d6,s)
q=d6[s]
p=s+1
if(!(p<64))return A.a(d6,p)
o=d6[p]
n=s+2
if(!(n<64))return A.a(d6,n)
m=d6[n]
l=s+3
if(!(l<64))return A.a(d6,l)
k=d6[l]
j=s+4
if(!(j<64))return A.a(d6,j)
i=d6[j]
h=s+5
if(!(h<64))return A.a(d6,h)
g=d6[h]
f=s+6
if(!(f<64))return A.a(d6,f)
e=d6[f]
d=s+7
if(!(d<64))return A.a(d6,d)
c=d6[d]
b=q+c
a=q-c
a0=o+e
a1=o-e
a2=m+g
a3=m-g
a4=k+i
a5=b+a4
a6=b-a4
a7=a0+a2
d5&2&&A.b(d6)
if(!(s<64))return A.a(d6,s)
d6[s]=a5+a7
if(!(j<64))return A.a(d6,j)
d6[j]=a5-a7
a8=(a0-a2+a6)*0.707106781
if(!(n<64))return A.a(d6,n)
d6[n]=a6+a8
if(!(f<64))return A.a(d6,f)
d6[f]=a6-a8
a5=k-i+a3
a9=a1+a
b0=(a5-a9)*0.382683433
b1=0.5411961*a5+b0
b2=1.306562965*a9+b0
b3=(a3+a1)*0.707106781
b4=a+b3
b5=a-b3
if(!(h<64))return A.a(d6,h)
d6[h]=b5+b1
if(!(l<64))return A.a(d6,l)
d6[l]=b5-b1
if(!(p<64))return A.a(d6,p)
d6[p]=b4+b2
if(!(d<64))return A.a(d6,d)
d6[d]=b4-b2
s+=8}for(s=0,r=0;r<8;++r){if(!(s<64))return A.a(d6,s)
q=d6[s]
p=s+8
if(!(p<64))return A.a(d6,p)
o=d6[p]
n=s+16
if(!(n<64))return A.a(d6,n)
m=d6[n]
l=s+24
if(!(l<64))return A.a(d6,l)
k=d6[l]
j=s+32
if(!(j<64))return A.a(d6,j)
i=d6[j]
h=s+40
if(!(h<64))return A.a(d6,h)
g=d6[h]
f=s+48
if(!(f<64))return A.a(d6,f)
e=d6[f]
d=s+56
if(!(d<64))return A.a(d6,d)
c=d6[d]
b6=q+c
b7=q-c
b8=o+e
b9=o-e
c0=m+g
c1=m-g
c2=k+i
c3=b6+c2
c4=b6-c2
c5=b8+c0
d5&2&&A.b(d6)
if(!(s<64))return A.a(d6,s)
d6[s]=c3+c5
if(!(j<64))return A.a(d6,j)
d6[j]=c3-c5
c6=(b8-c0+c4)*0.707106781
if(!(n<64))return A.a(d6,n)
d6[n]=c4+c6
if(!(f<64))return A.a(d6,f)
d6[f]=c4-c6
c3=k-i+c1
c7=b9+b7
c8=(c3-c7)*0.382683433
c9=0.5411961*c3+c8
d0=1.306562965*c7+c8
d1=(c1+b9)*0.707106781
d2=b7+d1
d3=b7-d1
if(!(h<64))return A.a(d6,h)
d6[h]=d3+c9
if(!(l<64))return A.a(d6,l)
d6[l]=d3-c9
if(!(p<64))return A.a(d6,p)
d6[p]=d2+d0
if(!(d<64))return A.a(d6,d)
d6[d]=d2-d0;++s}for(d5=this.z,r=0;r<64;++r){d4=d6[r]*d7[r]
B.c.h(d5,r,d4>0?B.b.i(d4+0.5):B.b.i(d4-0.5))}return d5},
kU(a,b){var s,r
if(b.gee(0))return
s=A.Y(!1,8192)
b.aV(s)
r=J.B(B.d.gB(s.c),0,s.a)
this.bQ(a,225)
a.a1(r.length+8)
a.J(1165519206)
a.a1(0)
a.a5(r)},
kS(a){var s,r,q
this.bQ(a,219)
a.a1(132)
a.m(0)
for(s=this.a,r=0;r<64;++r)a.m(s[r])
a.m(1)
for(s=this.b,q=0;q<64;++q)a.m(s[q])},
kR(a){var s,r,q,p,o,n,m,l
this.bQ(a,196)
a.a1(418)
a.m(0)
for(s=0;s<16;){++s
a.m(B.cf[s])}for(r=0;r<=11;++r)a.m(B.ai[r])
a.m(16)
for(q=0;q<16;){++q
a.m(B.bq[q])}for(p=0;p<=161;++p)a.m(B.bB[p])
a.m(1)
for(o=0;o<16;){++o
a.m(B.bO[o])}for(n=0;n<=11;++n)a.m(B.ai[n])
a.m(17)
for(m=0;m<16;){++m
a.m(B.bG[m])}for(l=0;l<=161;++l)a.m(B.bX[l])},
e5(a,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=t.H
b.a(a0)
b.a(a1)
t.ia.a(a3)
t.nx.a(a4)
b=a4.length
if(0>=b)return A.a(a4,0)
s=a4[0]
if(240>=b)return A.a(a4,240)
r=a4[240]
q=c.jq(a0,a1)
for(b=c.Q,p=0;p<64;++p)B.c.h(b,B.a3[p],q[p])
o=b[0]
o.toString
n=o-a2
if(n===0){if(0>=a3.length)return A.a(a3,0)
m=a3[0]
m.toString
c.bP(a,m)}else{l=32767+n
a3.toString
m=c.y
if(!(l>=0&&l<65535))return A.a(m,l)
m=m[l]
m.toString
if(!(m<a3.length))return A.a(a3,m)
m=a3[m]
m.toString
c.bP(a,m)
m=c.x[l]
m.toString
c.bP(a,m)}k=63
for(;;){if(!(k>0&&b[k]===0))break;--k}if(k===0){s.toString
c.bP(a,s)
return o}for(m=c.y,j=c.x,i=1;i<=k;){h=i
for(;;){if(!(h>=0&&h<64))return A.a(b,h)
if(!(b[h]===0&&h<=k))break;++h}g=h-i
if(g>=16){f=B.a.j(g,4)
for(e=1;e<=f;++e){r.toString
c.bP(a,r)}g&=15}d=b[h]
d.toString
l=32767+d
if(!(l>=0&&l<65535))return A.a(m,l)
d=m[l]
d.toString
d=(g<<4>>>0)+d
if(!(d<a4.length))return A.a(a4,d)
d=a4[d]
d.toString
c.bP(a,d)
d=j[l]
d.toString
c.bP(a,d)
i=h+1}if(k!==63){s.toString
c.bP(a,s)}return o},
bP(a,b){var s,r,q,p=this
t.L.a(b)
s=b.length
if(0>=s)return A.a(b,0)
r=b[0]
if(1>=s)return A.a(b,1)
q=b[1]-1
while(q>=0){if((r&B.a.V(1,q))>>>0!==0)p.ax=(p.ax|B.a.V(1,p.ay))>>>0;--q
if(--p.ay<0){s=p.ax
if(s===255){a.m(255)
a.m(0)}else a.m(s)
p.ay=7
p.ax=0}}}}
A.dq.prototype={
a7(){return"PngDisposeMode."+this.b}}
A.eL.prototype={
a7(){return"PngBlendMode."+this.b}}
A.eM.prototype={}
A.hg.prototype={}
A.c2.prototype={
a7(){return"PngFilterType."+this.b}}
A.hG.prototype={
sO(a){this.w=t.gy.a(a)},
slR(a){this.x=t.T.a(a)},
$iM:1}
A.hh.prototype={}
A.hD.prototype={
bB(a){var s,r=A.w(a,!0,null,0).am(8)
for(s=0;s<8;++s)if(J.d(r.a,r.d+s)!==B.c3[s])return!1
return!0},
b7(b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=this,b5=null,b6=A.w(b7,!0,b5,0)
b4.d=b6
s=b6.am(8)
for(r=0;r<8;++r)if(J.d(s.a,s.d+r)!==B.c3[r])return b5
for(b6=b4.a,q=b6.cy,p=t.t,o=b6.db,n=t.L,m=b6.ax;;){l=b4.d
k=l.d-l.b
j=l.k()
i=b4.d.ao(4)
switch(i){case"tEXt":l=b4.d
h=l.aA(j)
l.d=l.d+(h.c-h.d)
g=h.a4()
f=g.length
for(r=0;r<f;++r)if(g[r]===0){l=r+1
m.h(0,B.b6.c5(new Uint8Array(g.subarray(0,A.bd(0,r,f)))),B.b6.c5(new Uint8Array(g.subarray(l,A.bd(l,b5,f)))))
break}b4.d.d+=4
break
case"pHYs":l=b4.d
h=l.aA(j)
l.d=l.d+(h.c-h.d)
e=A.p(h,b5,0)
e.k()
e.k()
J.d(e.a,e.d++)
b4.d.d+=4
break
case"IHDR":l=b4.d
h=l.aA(j)
l.d=l.d+(h.c-h.d)
d=A.p(h,b5,0)
c=d.a4()
b6.a=d.k()
b6.b=d.k()
b6.c=J.d(d.a,d.d++)
b6.d=J.d(d.a,d.d++)
J.d(d.a,d.d++)
b6.f=J.d(d.a,d.d++)
b6.r=J.d(d.a,d.d++)
l=b6.d
if(!(l===0||l===2||l===3||l===4||l===6))return b5
if(b6.f!==0)return b5
switch(l){case 0:if(!B.c.ck(A.j([1,2,4,8,16],p),b6.c))return b5
break
case 2:if(!B.c.ck(A.j([8,16],p),b6.c))return b5
break
case 3:if(!B.c.ck(A.j([1,2,4,8],p),b6.c))return b5
break
case 4:if(!B.c.ck(A.j([8,16],p),b6.c))return b5
break
case 6:if(!B.c.ck(A.j([8,16],p),b6.c))return b5
break}if(b4.d.k()!==A.bt(n.a(c),A.bt(new A.af(i),0)))throw A.h(A.n("Invalid "+i+" checksum"))
break
case"PLTE":l=b4.d
h=l.aA(j)
l.d=l.d+(h.c-h.d)
b6.sO(h.a4())
if(b4.d.k()!==A.bt(n.a(n.a(b6.w)),A.bt(new A.af(i),0)))throw A.h(A.n("Invalid "+i+" checksum"))
break
case"tRNS":l=b4.d
h=l.aA(j)
l.d=l.d+(h.c-h.d)
b6.slR(h.a4())
b=b4.d.k()
l=b6.x
l.toString
if(b!==A.bt(n.a(l),A.bt(new A.af(i),0)))throw A.h(A.n("Invalid "+i+" checksum"))
break
case"IEND":b4.d.d+=4
break
case"gAMA":if(j!==4)throw A.h(A.n("Invalid gAMA chunk"))
b4.d.k()
b4.d.d+=4
break
case"IDAT":B.c.C(o,k)
l=b4.d
l.d=(l.d+=j)+4
break
case"acTL":b6.CW=b4.d.k()
b4.d.k()
b4.d.d+=4
break
case"fcTL":b4.d.k()
a=b4.d.k()
a0=b4.d.k()
a1=b4.d.k()
a2=b4.d.k()
a3=b4.d.q()
a4=b4.d.q()
l=b4.d
a5=J.d(l.a,l.d++)
l=b4.d
a6=J.d(l.a,l.d++)
if(!(a5>=0&&a5<3))return A.a(B.bp,a5)
l=B.bp[a5]
if(!(a6>=0&&a6<2))return A.a(B.bP,a6)
a7=B.bP[a6]
B.c.C(q,new A.hg(A.j([],p),a,a0,a1,a2,a3,a4,l,a7))
b4.d.d+=4
break
case"fdAT":b4.d.k()
B.c.C(B.c.geg(q).y,k)
l=b4.d
l.d=(l.d+=j-4)+4
break
case"bKGD":l=b6.d
if(l===3){l=b4.d
a8=J.d(l.a,l.d++);--j
a9=a8*3
l=b6.w
a7=l.length
if(!(a9>=0&&a9<a7))return A.a(l,a9)
b0=l[a9]
b1=a9+1
if(!(b1<a7))return A.a(l,b1)
b2=l[b1]
b1=a9+2
if(!(b1<a7))return A.a(l,b1)
b3=l[b1]
l=b6.x
if(l!=null){l=B.d.ck(l,a8)?0:255
a7=new Uint8Array(4)
a7[0]=b0
a7[1]=b2
a7[2]=b3
a7[3]=l
b6.z=new A.ce(a7)}else{l=new Uint8Array(3)
l[0]=b0
l[1]=b2
l[2]=b3
b6.z=new A.fI(l)}}else if(l===0||l===4){b4.d.q()
j-=2}else if(l===2||l===6){l=b4.d
l.q()
l.q()
l.q()
j-=24}if(j>0)b4.d.d+=j
b4.d.d+=4
break
case"iCCP":b6.Q=b4.d.d2()
l=b4.d
J.d(l.a,l.d++)
l=b6.Q
a7=b4.d
h=a7.aA(j-(l.length+2))
a7.d=a7.d+(h.c-h.d)
b6.at=h.a4()
b4.d.d+=4
break
case"cICP":l=b4.d
a7=l.d
if(j===4){b1=l.a
l.d=a7+1
J.d(b1,a7)
a7=b4.d
J.d(a7.a,a7.d++)
a7=b4.d
J.d(a7.a,a7.d++)
a7=b4.d
J.d(a7.a,a7.d++)}else l.d=a7+j
b4.d.d+=4
break
default:l=b4.d
l.d=(l.d+=j)+4
break}if(i==="IEND")break
l=b4.d
if(l.d>=l.c)return b5}return b6},
aq(c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=null,b7=null,b8=b5.a,b9=b8.a,c0=b8.b,c1=b8.cy,c2=c1.length
if(c2===0||c3===0){r=A.j([],t.bs)
c1=b8.db
q=c1.length
for(c2=t.L,p=0,o=0;o<q;++o){n=b5.d
n===$&&A.c("_input")
if(!(o<c1.length))return A.a(c1,o)
n.d=c1[o]
m=n.k()
l=b5.d.ao(4)
n=b5.d
k=n.aA(m)
n.d=n.d+(k.c-k.d)
j=k.a4()
p+=j.length
B.c.C(r,j)
if(b5.d.k()!==A.bt(c2.a(j),A.bt(new A.af(l),0)))throw A.h(A.n("Invalid "+l+" checksum"))}b7=new Uint8Array(p)
for(c1=r.length,i=0,h=0;h<r.length;r.length===c1||(0,A.K)(r),++h){j=r[h]
J.mZ(b7,i,j)
i+=j.length}}else{if(c3>=c2)throw A.h(A.n("Invalid Frame Number: "+c3))
if(!(c3<c2))return A.a(c1,c3)
g=c1[c3]
b9=g.b
c0=g.c
r=A.j([],t.bs)
for(c1=g.y,p=0,o=0;o<c1.length;++o){c2=b5.d
c2===$&&A.c("_input")
c2.d=c1[o]
m=c2.k()
c2=b5.d
c2.ao(4)
c2.d+=4
c2=b5.d
k=c2.aA(m-4)
c2.d=c2.d+(k.c-k.d)
j=k.a4()
p+=j.length
B.c.C(r,j)}b7=new Uint8Array(p)
for(c1=r.length,i=0,h=0;h<r.length;r.length===c1||(0,A.K)(r),++h){j=r[h]
J.mZ(b7,i,j)
i+=j.length}}c1=b8.d
f=1
if(!(c1===3))if(!(c1===0)){if(c1===4)c1=2
else c1=c1===6?4:3
f=c1}s=null
try{s=B.H.c6(b7)}catch(e){return b6}d=A.w(s,!0,b6,0)
b5.c=b5.b=0
c=b6
if(b8.d===3){c1=b8.w
if(c1!=null){c2=c1.length
b=c2/3|0
a=b8.x
n=a!=null
a0=n?a.length:0
a1=n?4:3
c=new A.aN(new Uint8Array(b*a1),b,a1)
for(n=a1===4,o=0,a2=0;o<b;++o,a2+=3){if(n&&o<a0){if(!(o<a.length))return A.a(a,o)
a3=a[o]}else a3=255
if(!(a2<c2))return A.a(c1,a2)
a4=c1[a2]
a5=a2+1
if(!(a5<c2))return A.a(c1,a5)
a5=c1[a5]
a6=a2+2
if(!(a6<c2))return A.a(c1,a6)
c.d7(o,a4,a5,c1[a6],a3)}}}if(b8.d===0&&b8.x!=null&&c==null&&b8.c<=8){a=b8.x
a7=a.length
c1=b8.c
b=B.a.V(1,c1)
c2=b*4
n=new Uint8Array(c2)
c=new A.aN(n,b,4)
if(c1===1)a8=255
else if(c1===2)a8=85
else{c1=c1===4?17:1
a8=c1}for(o=0;o<b;++o){a9=o*a8
c.d7(o,a9,a9,a9,255)}for(o=0;o<a7;o+=2){c1=a[o]
a4=o+1
if(!(a4<a7))return A.a(a,a4)
b0=(c1&255)<<8|a[a4]&255
if(b0<b){c1=b0*4+3
if(!(c1<c2))return A.a(n,c1)
n[c1]=0}}}c1=b8.c
if(c1===1)b1=B.A
else if(c1===2)b1=B.u
else{if(c1===4)c2=B.B
else c2=c1===16?B.n:B.e
b1=c2}c2=b8.d
if(c2===0&&b8.x!=null&&c1>8)f=4
b2=A.Q(b6,b6,b1,0,B.j,c0,b6,0,c2===2&&b8.x!=null?4:f,c,B.e,b9,!1)
b3=b8.a
b4=b8.b
b8.a=b9
b8.b=c0
b5.e=0
if(b8.r!==0){c1=c0+7>>>3
b5.cg(d,b2,0,0,8,8,b9+7>>>3,c1)
c2=b9+3
b5.cg(d,b2,4,0,8,8,c2>>>3,c1)
c1=c0+3
b5.cg(d,b2,0,4,4,8,c2>>>2,c1>>>3)
c2=b9+1
b5.cg(d,b2,2,0,4,4,c2>>>2,c1>>>2)
c1=c0+1
b5.cg(d,b2,0,2,2,4,c2>>>1,c1>>>2)
b5.cg(d,b2,1,0,2,2,b9>>>1,c1>>>1)
b5.cg(d,b2,0,1,1,2,b9,c0>>>1)}else b5.kc(d,b2)
b8.a=b3
b8.b=b4
c1=b8.at
if(c1!=null)b2.c=new A.bB(b8.Q,B.aL,c1)
b8=b8.ax
if(b8.a!==0)b2.kY(b8)
return b2},
b9(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null
if(b.b7(t.D.a(a0))==null)return a
s=b.a
r=s.cy
q=r.length
if(q===0){s=b.aq(0)
s.toString
return s}for(q=t.g,p=a,o=p,n=0;n<s.CW;++n){if(!(n<r.length))return A.a(r,n)
a1=r[n]
m=b.aq(n)
if(m==null)continue
if(o==null||p==null){o=m.ec(m.gal())
l=a1.f
o.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
p=o
continue}l=n-1
if(!(l>=0&&l<r.length))return A.a(r,l)
k=r[l]
j=m.a
i=j==null
h=i?a:j.a
if(h==null)h=0
g=p.a
f=g==null
e=f?a:g.a
if(h===(e==null?0:e)){j=i?a:j.b
if(j==null)j=0
i=f?a:g.b
j=j===(i==null?0:i)&&a1.d===0&&a1.e===0&&a1.x===B.ck}else j=!1
if(j){l=a1.f
m.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
o.aN(m)
p=m
continue}d=o.x
if(d===$)d=o.x=A.j([],q)
if(!(l<d.length))return A.a(d,l)
p=A.bF(d[l],!1,!1)
c=k.w
if(c===B.cm){l=k.d
j=k.e
i=s.z
if(i==null){i=new Uint8Array(4)
h=new A.ce(i)
i[0]=0
i[1]=0
i[2]=0
i[3]=0
i=h}A.oz(p,!1,i,l,l+k.b-1,j,j+k.c-1)}else if(c===B.cn&&n>1){l=n-2
d=o.x
if(d===$)d=o.x=A.j([],q)
if(!(l>=0&&l<d.length))return A.a(d,l)
j=k.d
i=k.e
h=k.b
g=k.c
p=A.mF(p,d[l],B.aD,g,h,j,i,g,h,j,i)}l=a1.f
p.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
l=a1.x===B.cl?B.aD:B.ab
p=A.mF(p,m,l,a,a,a1.d,a1.e,a,a,a,a)
o.aN(p)}return o},
c5(a){return this.b9(a,null)},
cg(a4,a5,a6,a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a1.a,a3=a2.d
if(a3===4)s=2
else if(a3===2)s=3
else{a3=a3===6?4:1
s=a3}r=s*a2.c
q=B.a.j(r+7,3)
p=B.a.j(r*b0+7,3)
o=A.j([null,null],t.e5)
n=A.j([0,0,0,0],t.t)
for(a2=a8>1,m=a8-a6,l=a7,k=0,j=0;k<b1;++k,l+=a9,++a1.e){a3=J.d(a4.a,a4.d++)
if(!(a3>=0&&a3<5))return A.a(B.at,a3)
i=B.at[a3]
h=a4.aA(p)
a4.d=a4.d+(h.c-h.d)
B.c.h(o,j,h.a4())
if(!(j>=0&&j<2))return A.a(o,j)
g=o[j]
j=1-j
f=o[j]
g.toString
a1.fM(i,q,g,f)
a1.c=a1.b=0
a3=g.length
e=new A.ad(g,0,Math.min(a3,a3),0,!0)
for(a3=m<=1,d=a6,c=0;c<b0;++c,d+=a8){a1.fB(e,n)
b=a5.a
b=b==null?null:b.P(d,l,null)
a1.e9(b==null?new A.F():b,n)
if(!a3||a2)for(a=0;a<a8;++a)for(b=l+a,a0=0;a0<m;++a0)a1.e9(a5.aw(d+a0,b),n)}}},
kc(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.a,a0=a.d
if(a0===4)s=2
else if(a0===2)s=3
else{a0=a0===6?4:1
s=a0}r=s*a.c
q=a.a
p=a.b
o=B.a.j(q*r+7,3)
n=B.a.j(r+7,3)
m=A.E(o,0,!1,t.p)
l=A.j([m,m],t.S)
k=A.j([0,0,0,0],t.t)
a=a2.a
j=a.gH(a)
j.E()
for(i=0,h=0;i<p;++i,h=e){a=J.d(a1.a,a1.d++)
if(!(a>=0&&a<5))return A.a(B.at,a)
g=B.at[a]
f=a1.aA(o)
a1.d=a1.d+(f.c-f.d)
B.c.h(l,h,f.a4())
if(!(h>=0&&h<2))return A.a(l,h)
e=1-h
b.fM(g,n,l[h],l[e])
b.c=b.b=0
a=l[h]
a0=a.length
d=new A.ad(a,0,Math.min(a0,a0),0,!0)
for(c=0;c<q;++c){b.fB(d,k)
b.e9(j.gN(),k)
j.E()}}},
fM(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
t.L.a(c)
t.T.a(d)
s=c.length
switch(a.a){case 0:break
case 1:for(r=J.an(c),q=b;q<s;++q){p=c.length
if(!(q<p))return A.a(c,q)
o=c[q]
n=q-b
if(!(n>=0&&n<p))return A.a(c,n)
r.h(c,q,o+c[n]&255)}break
case 2:for(r=J.an(c),p=d!=null,q=0;q<s;++q){if(p){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+m&255)}break
case 3:for(r=J.an(c),p=d!=null,q=0;q<s;++q){if(q<b)l=0
else{o=q-b
if(!(o>=0&&o<c.length))return A.a(c,o)
l=c[o]}if(p){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+B.a.j(l+m,1)&255)}break
case 4:for(r=J.an(c),p=d==null,o=!p,q=0;q<s;++q){n=q<b
if(n)l=0
else{k=q-b
if(!(k>=0&&k<c.length))return A.a(c,k)
l=c[k]}if(o){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(n||p)j=0
else{n=q-b
if(!(n>=0&&n<d.length))return A.a(d,n)
j=d[n]}i=l+m-j
h=Math.abs(i-l)
g=Math.abs(i-m)
f=Math.abs(i-j)
if(h<=g&&h<=f)e=l
else e=g<=f?m:j
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+e&255)}break}},
bz(a,b){var s,r,q,p,o,n=this
if(b===0)return 0
if(b===8)return a.I()
if(b===16)return a.q()
for(s=a.c;r=n.c,r<b;){r=a.d
if(r>=s)throw A.h(A.n("Invalid PNG data."))
q=a.a
a.d=r+1
p=J.d(q,r)
r=n.c
n.b=B.a.V(p,r)
n.c=r+8}if(b===1)o=1
else if(b===2)o=3
else{if(b===4)s=15
else s=0
o=s}s=r-b
r=B.a.a2(n.b,s)
n.c=s
return r&o},
fB(a,b){var s,r,q=this
t.L.a(b)
s=q.a
r=s.d
switch(r){case 0:B.c.h(b,0,q.bz(a,s.c))
return
case 2:B.c.h(b,0,q.bz(a,s.c))
B.c.h(b,1,q.bz(a,s.c))
B.c.h(b,2,q.bz(a,s.c))
return
case 3:B.c.h(b,0,q.bz(a,s.c))
return
case 4:B.c.h(b,0,q.bz(a,s.c))
B.c.h(b,1,q.bz(a,s.c))
return
case 6:B.c.h(b,0,q.bz(a,s.c))
B.c.h(b,1,q.bz(a,s.c))
B.c.h(b,2,q.bz(a,s.c))
B.c.h(b,3,q.bz(a,s.c))
return}throw A.h(A.n("Invalid color type: "+r+"."))},
e9(a,b){var s,r,q,p,o,n,m,l,k,j
t.L.a(b)
s=this.a
r=s.d
switch(r){case 0:r=s.x
if(r!=null&&s.c>8){s=r.length
if(0>=s)return A.a(r,0)
q=r[0]
if(1>=s)return A.a(r,1)
r=r[1]
p=b[0]
a.ag(p,p,p,p!==((q&255)<<24|r&255)>>>0?a.gF():0)
return}a.aB(b[0],0,0)
return
case 2:o=b[0]
p=b[1]
n=b[2]
s=s.x
if(s!=null){r=s.length
if(0>=r)return A.a(s,0)
q=s[0]
if(1>=r)return A.a(s,1)
m=s[1]
if(2>=r)return A.a(s,2)
l=s[2]
if(3>=r)return A.a(s,3)
k=s[3]
if(4>=r)return A.a(s,4)
j=s[4]
if(5>=r)return A.a(s,5)
s=s[5]
if(o!==((q&255)<<8|m&255)||p!==((l&255)<<8|k&255)||n!==((j&255)<<8|s&255)){a.ag(o,p,n,a.gF())
return}}a.aB(o,p,n)
return
case 3:a.sU(b[0])
return
case 4:a.aB(b[0],b[1],0)
return
case 6:a.ag(b[0],b[1],b[2],b[3])
return}throw A.h(A.n("Invalid color type: "+r+"."))}}
A.hF.prototype={
a7(){return"PngFilter."+this.b}}
A.hE.prototype={
aN(a){var s,r,q,p,o,n,m,l,k,j=this,i=8192
if(!(a.gb2()&&a.gM()!==B.n))s=a.gaO()<8&&!a.gaP()&&a.gal()>1
else s=!0
if(s)a=a.aS(B.e)
if(j.w==null){s=A.Y(!0,i)
j.w=s
s.a5(A.j([137,80,78,71,13,10,26,10],t.t))
r=A.Y(!0,i)
r.J(a.gS())
r.J(a.gK())
r.m(a.gaO())
if(a.gaP())s=3
else if(a.gal()===1)s=0
else if(a.gal()===2)s=4
else s=a.gal()===3?2:6
r.m(s)
r.m(0)
r.m(0)
r.m(0)
s=j.w
s.toString
j.bA(s,"IHDR",J.B(B.d.gB(r.c),0,r.a))
s=a.c
if(s!=null){r=A.Y(!0,i)
r.a5(new A.af(s.a))
r.m(0)
r.m(0)
r.a5(s.l2())
s=j.w
s.toString
j.bA(s,"iCCP",J.B(B.d.gB(r.c),0,r.a))}if(a.gaP()){s=j.a
if(s!=null){s=s.a
s===$&&A.c("palette")
j.fZ(s)}else{s=a.a
s=s==null?null:s.gO()
s.toString
j.fZ(s)}}if(j.r){r=A.Y(!0,i)
s=j.e
s===$&&A.c("_frames")
r.J(s)
r.J(j.c)
s=j.w
s.toString
j.bA(s,"acTL",J.B(B.d.gB(r.c),0,r.a))}}q=a.gaP()?1:a.gal()
p=a.gM()===B.n?2:1
s=a.gS()
o=a.gK()
n=a.gK()
m=new Uint8Array(s*o*q*p+n)
j.js(0,a,m)
l=B.b8.hm(t.L.a(m),null)
s=a.d
if(s!=null)for(s=new A.R(s,s.r,s.e,A.l(s).p("R<1>"));s.E();){o=s.d
n=a.d.l(0,o)
n.toString
r=new A.hz(!0,new Uint8Array(8192))
r.a5(B.b7.cz(o))
r.m(0)
r.a5(B.b7.cz(n))
o=j.w
o.toString
j.bA(o,"tEXt",J.B(B.d.gB(r.c),0,r.a))}if(j.r){r=A.Y(!0,i)
r.J(j.f)
r.J(a.gS())
r.J(a.gK())
r.J(0)
r.J(0)
r.a1(a.y)
r.a1(1000)
r.m(1)
r.m(0)
s=j.w
s.toString
j.bA(s,"fcTL",J.B(B.d.gB(r.c),0,r.a));++j.f}if(j.f<=1){s=j.w
s.toString
j.bA(s,"IDAT",l)}else{k=A.Y(!0,i)
k.J(j.f)
k.a5(l)
s=j.w
s.toString
j.bA(s,"fdAT",J.B(B.d.gB(k.c),0,k.a));++j.f}},
dB(){var s,r=this,q=r.w
if(q==null)return null
r.bA(q,"IEND",A.j([],t.t))
r.f=0
q=r.w
s=J.B(B.d.gB(q.c),0,q.a)
r.w=null
return s},
bI(a){var s,r,q,p,o,n=this,m=a.gab().length
if(m<=1){n.e=1
n.r=!1
n.aN(a)}else{m=a.gab().length
n.e=m
n.r=m>1
n.c=a.r
if(a.gaP()){s=n.a=A.m1(a,256,10)
for(m=a.gab(),r=m.length,q=0;q<m.length;m.length===r||(0,A.K)(m),++q){p=m[q]
if(p!==a){s.fn(p)
s.f7()
s.fk()
s.eX()}}}for(m=a.gab(),r=m.length,q=0;q<m.length;m.length===r||(0,A.K)(m),++q){p=m[q]
o=n.a
if(o!=null)n.aN(o.el(p))
else n.aN(p)}}m=n.dB()
m.toString
return m},
fZ(a){var s,r,q,p=this
if(a.gM()===B.e&&a.b===3&&a.a===256){s=p.w
s.toString
p.bA(s,"PLTE",J.B(a.gB(a),0,null))}else{s=a.a
r=A.Y(!0,s*3)
for(q=0;q<s;++q){r.m(B.b.i(a.b1(q)))
r.m(B.b.i(a.b0(q)))
r.m(B.b.i(a.b_(q)))}s=p.w
s.toString
p.bA(s,"PLTE",J.B(B.d.gB(r.c),0,r.a))}if(a.b===4){s=a.a
r=A.Y(!0,s)
for(q=0;q<s;++q)r.m(B.b.i(a.b6(q)))
s=p.w
s.toString
p.bA(s,"tRNS",J.B(B.d.gB(r.c),0,r.a))}},
bA(a,b,c){t.L.a(c)
a.J(c.length)
a.a5(new A.af(b))
a.a5(c)
a.J(A.bt(c,A.bt(new A.af(b),0)))},
js(a,b,c){var s,r,q=this,p=b.gaP()?B.ld:B.le,o=b.gB(0),n=b.a.gbf(),m=b.gaP()?1:b.gal(),l=B.a.j(m*b.gaO()+7,3),k=b.gaO()+7>>>3,j=p.a,i=J.bf(o),h=0,g=0,f=null,e=0
for(;;){s=b.a
s=s==null?null:s.b
if(!(e<(s==null?0:s)))break
r=i.cS(o,g,n)
g+=n
switch(j){case 1:h=q.jx(r,k,l,c,h)
break
case 2:h=q.jy(r,f,k,c,h)
break
case 3:h=q.jt(r,f,k,l,c,h)
break
case 4:h=q.jv(r,f,k,l,c,h)
break
default:h=q.ju(r,k,c,h)
break}++e
f=r}},
fS(a,b,c,d,e){var s,r,q,p;--a
for(s=b.length,r=d.$flags|0;a>=0;e=q){q=e+1
p=c+a
if(!(p<s))return A.a(b,p)
p=b[p]
r&2&&A.b(d)
if(!(e<d.length))return A.a(d,e)
d[e]=p;--a}return e},
ju(a,b,c,d){var s,r,q,p,o=d+1
c.$flags&2&&A.b(c)
s=c.length
if(!(d<s))return A.a(c,d)
c[d]=0
r=a.length
if(b===1)for(d=o,q=0;q<r;++q,d=o){o=d+1
p=a[q]
if(!(d<s))return A.a(c,d)
c[d]=p}else for(d=o,q=0;q<r;q+=b)d=this.fS(b,a,q,c,d)
return d},
jx(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=e+1
d.$flags&2&&A.b(d)
s=d.length
if(!(e<s))return A.a(d,e)
d[e]=1
for(e=j,r=0;r<c;r+=b)e=this.fS(b,a,r,d,e)
q=a.length
for(p=b-1,o=d.$flags|0,r=c;r<q;r+=b)for(n=p,m=0;m<b;++m,--n,e=j){j=e+1
l=r+n
if(!(l>=0&&l<q))return A.a(a,l)
k=a[l]
l-=c
if(!(l>=0))return A.a(a,l)
l=a[l]
o&2&&A.b(d)
if(!(e>=0&&e<s))return A.a(d,e)
d[e]=k-l&255}return e},
jy(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i=e+1
d.$flags&2&&A.b(d)
s=d.length
if(!(e<s))return A.a(d,e)
d[e]=2
r=a.length
for(q=c-1,p=d.$flags|0,o=b!=null,e=i,n=0;n<r;n+=c)for(m=q,l=0;l<c;++l,--m,e=i){if(o){k=n+m
if(!(k>=0&&k<b.length))return A.a(b,k)
j=b[k]}else j=0
i=e+1
k=n+m
if(!(k>=0&&k<r))return A.a(a,k)
k=a[k]
p&2&&A.b(d)
if(!(e>=0&&e<s))return A.a(d,e)
d[e]=k-j&255}return e},
jt(a,b,c,d,e,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=a0+1
e.$flags&2&&A.b(e)
s=e.length
if(!(a0<s))return A.a(e,a0)
e[a0]=3
r=a.length
for(q=c-1,p=e.$flags|0,o=b==null,a0=f,n=0;n<r;n+=c)for(m=q,l=0;l<c;++l,--m,a0=f){k=n+m
if(k<d)j=0
else{i=k-d
if(!(i>=0&&i<r))return A.a(a,i)
j=a[i]}if(o)h=0
else{if(!(k>=0&&k<b.length))return A.a(b,k)
h=b[k]}if(!(k>=0&&k<r))return A.a(a,k)
g=a[k]
f=a0+1
p&2&&A.b(e)
if(!(a0>=0&&a0<s))return A.a(e,a0)
e[a0]=g-(j+h>>>1)}return a0},
jW(a,b,c){var s=a+b-c,r=s>a?s-a:a-s,q=s>b?s-b:b-s,p=s>c?s-c:c-s
if(r<=q&&r<=p)return a
else if(q<=p)return b
return c},
jv(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=a3+1
a2.$flags&2&&A.b(a2)
s=a2.length
if(!(a3<s))return A.a(a2,a3)
a2[a3]=4
r=a.length
for(q=a0-1,p=a2.$flags|0,o=b==null,a3=c,n=0;n<r;n+=a0)for(m=q,l=0;l<a0;++l,--m,a3=c){k=n+m
j=k<a1
if(j)i=0
else{h=k-a1
if(!(h>=0&&h<r))return A.a(a,h)
i=a[h]}if(o)g=0
else{if(!(k>=0&&k<b.length))return A.a(b,k)
g=b[k]}if(j||o)f=0
else{j=k-a1
if(!(j>=0&&j<b.length))return A.a(b,j)
f=b[j]}if(!(k>=0&&k<r))return A.a(a,k)
e=a[k]
d=this.jW(i,g,f)
c=a3+1
p&2&&A.b(a2)
if(!(a3>=0&&a3<s))return A.a(a2,a3)
a2[a3]=e-d&255}return a3}}
A.c3.prototype={
a7(){return"PnmFormat."+this.b}}
A.c4.prototype={}
A.jA.prototype={
bB(a){var s
this.b=A.w(a,!1,null,0)
s=this.dk()
if(s==="P1"||s==="P2"||s==="P5"||s==="P3"||s==="P6")return!0
return!1},
b9(a,b){if(this.b7(a)==null)return null
return this.aq(0)},
b7(a){var s,r,q=this
q.b=A.w(a,!1,null,0)
s=q.dk()
if(s==="P1"){r=q.a=new A.c4(B.a7)
r.e=B.co}else if(s==="P2"){r=q.a=new A.c4(B.a7)
r.e=B.cp}else if(s==="P5"){r=q.a=new A.c4(B.a7)
r.e=B.aW}else if(s==="P3"){r=q.a=new A.c4(B.a7)
r.e=B.cq}else if(s==="P6"){r=q.a=new A.c4(B.a7)
r.e=B.aX}else return q.b=null
r.a=q.cM()
r=q.a
r.toString
r.b=q.cM()
r=q.a
if(r.a===0||r.b===0)return q.a=q.b=null
return r},
aq(a){var s,r,q,p,o,n=this,m=null,l=n.a
if(l==null)return m
s=l.e
if(s===B.co){s=l.a
r=A.Q(m,m,B.A,0,B.j,l.b,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.E();){q=l.gN()
if(n.dk()==="1")q.aB(1,1,1)
else q.aB(0,0,0)}return r}else if(s===B.cp||s===B.aW){p=n.cM()
if(p===0)return m
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.hq(p),0,B.j,l,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.E();){q=l.gN()
o=n.dq(n.a.e,p)
q.aB(o,o,o)}return r}else if(s===B.cq||s===B.aX){p=n.cM()
if(p===0)return m
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.hq(p),0,B.j,l,m,0,3,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.E();)l.gN().aB(n.dq(n.a.e,p),n.dq(n.a.e,p),n.dq(n.a.e,p))
return r}return m},
hq(a){if(a>255)return B.n
if(a>15)return B.e
if(a>3)return B.B
if(a>1)return B.u
return B.A},
dq(a,b){if(a===B.aW||a===B.aX)return this.b.I()
return this.cM()},
cM(){var s,r,q=this.dk()
if(J.bv(q)===0)return 0
try{s=A.ur(q)
return s}catch(r){return 0}},
dk(){var s,r,q,p,o=this.b
if(o==null)return""
s=this.c
if(s.length!==0)return B.c.dE(s,0)
r=B.m.hE(o.lF())
if(r.length===0)return""
while(B.m.ex(r,"#"))r=B.m.hE(this.b.hx(70))
o=t.no
q=A.u(new A.cK(A.j(r.split(" "),t.s),t.gS.a(new A.jB()),o),o.p("e.E"))
for(o=q.length,p=0;p<o;++p)if(B.m.ex(q[p],"#")){B.c.sA(q,p)
break}B.c.cw(s,q)
if(s.length===0)return""
return B.c.dE(s,0)}}
A.jB.prototype={
$1(a){return A.bs(a)!==""},
$S:27}
A.hI.prototype={
sln(a){t.T.a(a)},
shU(a){t.T.a(a)},
slH(a){t.T.a(a)},
slI(a){t.T.a(a)}}
A.hJ.prototype={
sbR(a){t.T.a(a)},
sbV(a){t.T.a(a)}}
A.bm.prototype={}
A.hM.prototype={
sbR(a){t.T.a(a)},
sbV(a){t.T.a(a)}}
A.hN.prototype={
sbR(a){t.T.a(a)},
sbV(a){t.T.a(a)}}
A.hQ.prototype={
sbR(a){t.T.a(a)},
sbV(a){t.T.a(a)}}
A.hR.prototype={
sbR(a){t.T.a(a)},
sbV(a){t.T.a(a)}}
A.eO.prototype={}
A.hP.prototype={}
A.jC.prototype={
ij(a){var s,r,q,p,o=this
a.q()
a.q()
a.q()
a.q()
s=B.a.W(a.c-a.d,8)
if(s>0){o.e=new Uint16Array(s)
o.f=new Uint16Array(s)
o.r=new Uint16Array(s)
o.w=new Uint16Array(s)
for(r=0;r<s;++r){q=o.e
p=a.q()
q.$flags&2&&A.b(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.f
q=a.q()
p.$flags&2&&A.b(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q
q=o.r
p=a.q()
q.$flags&2&&A.b(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.w
q=a.q()
p.$flags&2&&A.b(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q}}}}
A.cF.prototype={
hw(a,b,c,d,e,f,g){if(a.c-a.d<2)return
if(e==null)e=a.q()
switch(e){case 0:d.toString
this.kA(a,b,c,d)
break
case 1:if(f==null)f=this.kx(a,c)
d.toString
this.kz(a,b,c,d,f,g)
break
default:throw A.h(A.n("Unsupported compression: "+e))}},
lE(a,b,c,d){return this.hw(a,b,c,d,null,null,0)},
kx(a,b){var s,r,q=new Uint16Array(b)
for(s=0;s<b;++s){r=a.q()
if(!(s<b))return A.a(q,s)
q[s]=r}return q},
kA(a,b,c,d){var s,r=b*c
if(d===16)r*=2
if(r>a.c-a.d){s=new Uint8Array(r)
this.c=s
B.d.ac(s,0,r,255)
return}this.c=a.am(r).a4()},
kz(a,b,c,d,e,f){var s,r,q,p,o,n,m,l=b*c
if(d===16)l*=2
s=new Uint8Array(l)
this.c=s
r=f*c
q=e.length
if(r>=q){B.d.ac(s,0,l,255)
return}for(p=0,o=0;o<c;++o,r=n){n=r+1
if(!(r>=0&&r<q))return A.a(e,r)
m=a.aA(e[r])
a.d=a.d+(m.c-m.d)
s=this.c
s.toString
this.j7(m,s,p)
p+=b}},
j7(a,b,c){var s,r,q,p,o,n,m,l
for(s=a.c,r=b.length;q=a.d,q<s;){p=a.a
a.d=q+1
q=J.d(p,q)
p=$.aq()
p.$flags&2&&A.b(p)
p[0]=q
q=$.az()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0){o=1-o
q=a.d
if(q>=s)break
p=a.a
a.d=q+1
n=J.d(p,q)
if(c+o>r)o=r-c
for(q=b.$flags|0,m=0;m<o;++m,c=l){l=c+1
q&2&&A.b(b)
if(!(c>=0&&c<r))return A.a(b,c)
b[c]=n}}else{++o
if(c+o>r)o=r-c
o=Math.min(o,s-a.d)
for(m=0;m<o;++m,c=l){l=c+1
q=J.d(a.a,a.d++)
b.$flags&2&&A.b(b)
if(!(c>=0&&c<r))return A.a(b,c)
b[c]=q}}}}}
A.bb.prototype={
a7(){return"PsdColorMode."+this.b}}
A.hK.prototype={
ik(a){var s,r,q=this
q.as=A.w(a,!0,null,0)
q.kf()
if(q.c!==943870035)return
s=q.as.k()
q.as.am(s)
s=q.as.k()
q.at=q.as.am(s)
s=q.as.k()
q.ax=q.as.am(s)
r=q.as
q.ay=r.am(r.c-r.d)},
bT(){var s,r=this
if(r.c===943870035){s=r.as
s===$&&A.c("_input")
s=s==null}else s=!0
if(s)return!1
r.kv()
r.kw()
r.ky()
r.ay=r.ax=r.at=r.as=null
return!0},
hh(){if(!this.bT())return null
return this.lK()},
lK(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=null,a2=a0.y
if(a2!=null)return a2
a2=a0.a
a2=A.Q(a1,a1,B.e,0,B.j,a0.b,a1,0,4,a1,B.e,a2,!1)
a0.y=a2
a2.dA(0)
for(a2=a0.w,s=0;s<a2.length;++s){r=a2[s]
q=r.y
q===$&&A.c("flags")
if((q&2)!==0)continue
q=r.w
q===$&&A.c("opacity")
p=q/255
o=r.r
n=r.cx
q=r.a
q.toString
m=q
l=0
for(;;){q=r.f
q===$&&A.c("height")
if(!(l<q))break
q=r.a
q.toString
k=q+l
j=r.b
q=m>=0
i=0
for(;;){h=r.e
h===$&&A.c("width")
if(!(i<h))break
h=n.a
g=h==null?a1:h.P(i,l,a1)
if(g==null)g=new A.F()
f=B.b.i(g.gn())
e=B.b.i(g.gt())
d=B.b.i(g.gu())
c=B.b.i(g.gv())
j.toString
if(j>=0&&j<a0.a&&q&&m<a0.b){h=r.b
h.toString
b=a0.y.a
a=b==null?a1:b.P(h+i,k,a1)
if(a==null)a=new A.F()
a0.ix(B.b.i(a.gn()),B.b.i(a.gt()),B.b.i(a.gu()),B.b.i(a.gv()),f,e,d,c,o,p,a)}++i;++j}++l;++m}}a2=a0.y
a2.toString
return a2},
ix(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n=h/255*j
switch(i){case 1885434739:s=d
r=c
q=b
p=a
break
case 1852797549:s=h
r=g
q=f
p=e
break
case 1684632435:s=h
r=g
q=f
p=e
break
case 1684107883:p=Math.min(a,e)
q=Math.min(b,f)
r=Math.min(c,g)
s=h
break
case 1836411936:p=B.a.j(a*e,8)
q=B.a.j(b*f,8)
r=B.a.j(c*g,8)
s=h
break
case 1768188278:p=A.jE(a,e)
q=A.jE(b,f)
r=A.jE(c,g)
s=h
break
case 1818391150:p=A.jG(a,e)
q=A.jG(b,f)
r=A.jG(c,g)
s=h
break
case 1684751212:s=h
r=g
q=f
p=e
break
case 1818850405:p=Math.max(a,e)
q=Math.max(b,f)
r=Math.max(c,g)
s=h
break
case 1935897198:p=A.mf(a,e)
q=A.mf(b,f)
r=A.mf(c,g)
s=h
break
case 1684633120:p=A.jF(a,e)
q=A.jF(b,f)
r=A.jF(c,g)
s=h
break
case 1818518631:p=e+a>255?255:a+e
q=f+b>255?255:b+f
r=g+c>255?255:c+g
s=h
break
case 1818706796:s=h
r=g
q=f
p=e
break
case 1870030194:p=A.md(a,e,d,h)
q=A.md(b,f,d,h)
r=A.md(c,g,d,h)
s=h
break
case 1934387572:p=A.mg(a,e)
q=A.mg(b,f)
r=A.mg(c,g)
s=h
break
case 1749838196:p=A.mb(a,e)
q=A.mb(b,f)
r=A.mb(c,g)
s=h
break
case 1984719220:p=A.mh(a,e)
q=A.mh(b,f)
r=A.mh(c,g)
s=h
break
case 1816947060:p=A.mc(a,e)
q=A.mc(b,f)
r=A.mc(c,g)
s=h
break
case 1884055924:p=A.me(a,e)
q=A.me(b,f)
r=A.me(c,g)
s=h
break
case 1749903736:p=e<255-a?0:255
q=f<255-b?0:255
r=g<255-c?0:255
s=h
break
case 1684629094:p=Math.abs(e-a)
q=Math.abs(f-b)
r=Math.abs(g-c)
s=h
break
case 1936553316:p=A.ma(a,e)
q=A.ma(b,f)
r=A.ma(c,g)
s=h
break
case 1718842722:s=h
r=g
q=f
p=e
break
case 1717856630:s=h
r=g
q=f
p=e
break
case 1752524064:s=h
r=g
q=f
p=e
break
case 1935766560:s=h
r=g
q=f
p=e
break
case 1668246642:s=h
r=g
q=f
p=e
break
case 1819634976:s=h
r=g
q=f
p=e
break
default:s=h
r=g
q=f
p=e}o=1-n
k.sn(B.b.i(a*o+p*n))
k.st(B.b.i(b*o+q*n))
k.su(B.b.i(c*o+r*n))
k.sv(B.b.i(d*o+s*n))},
kf(){var s,r,q=this,p=q.as
p===$&&A.c("_input")
q.c=p.k()
p=q.as.q()
q.d=p
if(p!==1){q.c=0
return}s=q.as.am(6)
for(r=0;r<6;++r)if(J.d(s.a,s.d+r)!==0){q.c=0
return}q.e=q.as.q()
q.b=q.as.k()
q.a=q.as.k()
q.f=q.as.q()
p=q.as.q()
if(!(p<8))return A.a(B.ce,p)
q.r=B.ce[p]},
kv(){var s,r,q,p,o,n,m=this,l=m.at
l.d=l.b
for(l=m.z;s=m.at,s.d<s.c;){r=s.k()
q=m.at.q()
s=m.at
p=J.d(s.a,s.d++)
m.at.ao(p)
if((p&1)===0)++m.at.d
p=m.at.k()
s=m.at
o=s.aA(p)
n=s.d+(o.c-o.d)
s.d=n
if((p&1)===1)s.d=n+1
if(r===943868237)l.h(0,q,new A.hL())}},
kw(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.ax
h.d=h.b
s=h.k()
if((s&1)!==0)++s
r=i.ax.am(s)
h=i.w
B.c.dA(h)
if(s>0){q=r.q()
p=$.ap()
p.$flags&2&&A.b(p)
p[0]=q
q=$.ay()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0)o=-o
for(q=t.N,p=t.mi,n=t.k9,m=t.na,l=0;l<o;++l){k=new A.hO(A.I(q,p),A.j([],n),A.j([],m))
k.il(r)
B.c.C(h,k)}}for(l=0;l<h.length;++l)h[l].lB(r,i)
s=i.ax.k()
j=i.ax.am(s)
if(s>0){j.q()
j.q()
j.q()
j.q()
j.q()
j.q()
j.I()}},
ky(){var s,r,q,p,o,n,m=this,l="channels",k=m.ay
k.d=k.b
s=k.q()
if(s===1){k=m.b
r=m.e
r===$&&A.c(l)
q=k*r
p=new Uint16Array(q)
for(o=0;o<q;++o)p[o]=m.ay.q()}else p=null
m.x=t.cf.a(A.j([],t.mS))
o=0
for(;;){k=m.e
k===$&&A.c(l)
if(!(o<k))break
k=m.x
r=m.ay
r.toString
n=o===3?-1:o
n=new A.cF(n)
n.hw(r,m.a,m.b,m.f,s,p,o)
B.c.C(k,n);++o}m.y=A.nK(m.r,m.f,m.a,m.b,m.x)},
$iM:1}
A.hL.prototype={}
A.hO.prototype={
il(a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a4.k(),a3=$.P()
a3.$flags&2&&A.b(a3)
a3[0]=a2
a2=$.a7()
if(0>=a2.length)return A.a(a2,0)
a1.a=a2[0]
a3[0]=a4.k()
a1.b=a2[0]
a3[0]=a4.k()
a1.c=a2[0]
a3[0]=a4.k()
a2=a2[0]
a1.d=a2
a3=a1.b
a3.toString
a1.e=a2-a3
a3=a1.c
a2=a1.a
a2.toString
a1.f=a3-a2
a1.as=t.cf.a(A.j([],t.mS))
s=a4.q()
for(r=0;r<s;++r){a2=a4.q()
a3=$.ap()
a3.$flags&2&&A.b(a3)
a3[0]=a2
a2=$.ay()
if(0>=a2.length)return A.a(a2,0)
q=a2[0]
a4.k()
B.c.C(a1.as,new A.cF(q))}p=a4.k()
if(p!==943868237)throw A.h(A.n("Invalid PSD layer signature: "+B.a.dF(p,16)))
a1.r=a4.k()
a1.w=a4.I()
a4.I()
a1.y=a4.I()
if(a4.I()!==0)throw A.h(A.n("Invalid PSD layer data"))
o=a4.k()
n=a4.am(o)
if(o>0){o=n.k()
if(o>0){m=n.am(o)
a2=m.d
m.k()
m.k()
m.k()
m.k()
m.I()
m.I()
if(m.c-a2===20)m.d+=2
else{m.I()
m.I()
m.k()
m.k()
m.k()
m.k()}}o=n.k()
if(o>0)new A.jC().ij(n.am(o))
o=n.I()
n.ao(o)
l=4-B.a.a8(o,4)-1
if(l>0)n.d+=l
for(a2=n.c,a3=a1.ay,k=a1.cy,j=t.t,i=t.dM;n.d<a2;){p=n.k()
if(p!==943868237)throw A.h(A.n("PSD invalid signature for layer additional data: "+B.a.dF(p,16)))
h=n.ao(4)
o=n.k()
g=n.aA(o)
f=n.d+(g.c-g.d)
n.d=f
if((o&1)===1)n.d=f+1
a3.h(0,h,A.qn(h,g))
if(h==="lrFX"){e=A.p(i.a(a3.l(0,"lrFX")).b,null,0)
e.q()
d=e.q()
for(c=0;c<d;++c){e.ao(4)
b=e.ao(4)
a=e.k()
if(b==="dsdw"){a0=new A.hJ()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbR(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
e.ao(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbV(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))}else if(b==="isdw"){a0=new A.hN()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbR(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
e.ao(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbV(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))}else if(b==="oglw"){a0=new A.hQ()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbR(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
e.ao(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2)a0.sbV(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))}else if(b==="iglw"){a0=new A.hM()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbR(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
e.ao(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){J.d(e.a,e.d++)
a0.sbV(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))}}else if(b==="bevl"){a0=new A.hI()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.ao(8)
e.ao(8)
a0.sln(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
a0.shU(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){a0.slH(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
a0.slI(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))}}else if(b==="sofi"){a0=new A.hR()
B.c.C(k,a0)
a0.a=e.k()
e.ao(4)
a0.sbR(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbV(A.j([e.q(),e.q(),e.q(),e.q(),e.q()],j))}else e.d+=a}}}}},
lB(a,b){var s,r,q,p,o,n=this,m=0
for(;;){s=n.as
s===$&&A.c("channels")
if(!(m<s.length))break
s=s[m]
r=n.e
r===$&&A.c("width")
q=n.f
q===$&&A.c("height")
s.lE(a,r,q,b.f);++m}r=b.r
q=b.f
p=n.e
p===$&&A.c("width")
o=n.f
o===$&&A.c("height")
n.cx=A.nK(r,q,p,o,s)}}
A.dt.prototype={}
A.jD.prototype={
b9(a,b){var s,r,q,p=null,o=A.nJ(a)
this.a=o
s=1
if(s===1){o=o.hh()
return o}for(r=p,q=0;q<s;++q){o=this.a
b=o==null?p:o.hh()
if(b==null)continue
if(r==null){b.w=B.bd
r=b}else r.aN(b)}return r}}
A.hS.prototype={}
A.aW.prototype={
cW(){return new A.aW(this.a,this.b,this.c)},
eq(a){var s,r=this
t.h.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s},
ep(a){var s,r=this
t.h.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s}}
A.N.prototype={
cW(){var s=this
return new A.N(s.a,s.b,s.c,s.d)},
aQ(a,b){var s=this
return new A.N(s.a+b.a,s.b+b.b,s.c+b.c,s.d+b.d)},
ey(a,b){var s=this
return new A.N(s.a-b.a,s.b-b.b,s.c-b.c,s.d-b.d)},
hk(a){var s=this
return s.a*a.a+s.b*a.b+s.c*a.c+s.d*a.d},
eq(a){var s,r=this
t.R.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s
s=a.d
if(s<r.d)r.d=s},
ep(a){var s,r=this
t.R.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s
s=a.d
if(s>r.d)r.d=s}}
A.dw.prototype={
C(a,b){this.$ti.c.a(b)
this.a.eq(b)
this.b.ep(b)}}
A.du.prototype={$iM:1,
gK(){return this.b}}
A.dv.prototype={$iM:1,
gK(){return this.f}}
A.eP.prototype={$iM:1,
gK(){return this.b}}
A.a4.prototype={
scT(a){var s=this.a,r=this.b+1
s.$flags&2&&A.b(s)
if(!(r<s.length))return A.a(s,r)
s[r]=a},
bW(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.r,s)
return new A.aW(B.r[s],B.r[q>>>4&31],B.y[q&15])}else return new A.aW(B.y[q>>>7&15],B.y[q>>>3&15],B.ax[q&7])},
bY(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.r,s)
return new A.N(B.r[s],B.r[q>>>4&31],B.y[q&15],255)}else return new A.N(B.y[q>>>7&15],B.y[q>>>3&15],B.ax[q&7],B.ax[q>>>11&7])},
bX(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.r,s)
return new A.aW(B.r[s],B.r[q>>>5&31],B.r[q&31])}else return new A.aW(B.y[q>>>8&15],B.y[q>>>4&15],B.y[q&15])},
bZ(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.r,s)
return new A.N(B.r[s],B.r[q>>>5&31],B.r[q&31],255)}else return new A.N(B.y[q>>>8&15],B.y[q>>>4&15],B.y[q&15],B.ax[q>>>12&7])},
aM(){var s=this,r=s.c?1:0,q=s.d,p=s.e?1:0,o=s.f,n=s.r?1:0
return(r|(q&16383)<<1|p<<15|(o&32767)<<16|n<<31)>>>0},
aF(){var s,r=this,q=r.a,p=r.b+1
if(!(p<q.length))return A.a(q,p)
s=q[p]
r.c=(s&1)===1
r.scT(r.aM())
r.d=s>>>1&16383
r.scT(r.aM())
r.e=(s>>>15&1)===1
r.scT(r.aM())
r.f=s>>>16&32767
r.scT(r.aM())
r.r=(s>>>31&1)===1
r.scT(r.aM())}}
A.jH.prototype={
b7(a){var s,r=this,q=a.length,p=q-(q>>>1&1431655765)>>>0
p=(p&858993459)+(p>>>2&858993459)
if((p+(p>>>4)>>>0&252645135)*16843009>>>0>>>24===1){s=r.iU(a)
if(s!=null){r.a=a
return r.b=s}}s=r.j6(a)
if(s!=null){r.a=a
return r.b=s}s=r.j4(a)
if(s!=null){r.a=a
return r.b=s}return null},
j6(a){var s,r,q=A.w(a,!1,null,0)
if(q.k()!==52)return null
if(q.k()!==55727696)return null
s=A.j([0,0,0,0],t.t)
r=new A.dv(s)
q.k()
r.b=q.k()
B.c.h(s,0,q.I())
B.c.h(s,1,q.I())
B.c.h(s,2,q.I())
B.c.h(s,3,q.I())
q.k()
q.k()
r.f=q.k()
r.r=q.k()
q.k()
q.k()
q.k()
q.k()
r.Q=q.k()
return r},
j4(a){var s,r,q=A.w(a,!1,null,0)
if(q.k()!==52)return null
s=new A.du()
s.b=q.k()
s.a=q.k()
q.k()
s.d=q.k()
q.k()
s.f=q.k()
q.k()
q.k()
q.k()
s.y=q.k()
r=q.k()
s.z=r
s.Q=q.k()
if(r!==559044176)return null
return s},
iU(a){var s,r,q,p,o,n,m=null,l=a.length,k=A.w(a,!1,m,0)
if(k.k()!==0)return m
s=new A.eP()
s.b=k.k()
s.a=k.k()
k.k()
k.k()
k.k()
k.k()
k.k()
k.k()
k.k()
r=k.k()
s.y=r
if(r===559044176)return m
q=0
p=8
if(!(l===32)){o=0
for(;;){if(!(o<10)){q=1
break}n=o<<1>>>0
if((B.a.R(64,n)&l)>>>0!==0){p=B.a.R(16,o)
q=1
break}if((B.a.R(128,n)&l)>>>0!==0){p=B.a.R(16,o)
break}++o}if(o===10)return m}if((q+1)*2===4)return m
s.b=s.a=p
return s},
aq(a){var s,r,q=this,p=q.b
if(p==null||q.a==null)return null
if(p instanceof A.eP){p=p.a
s=q.b.gK()
r=q.a
r.toString
return q.dR(p,s,r)}else if(p instanceof A.du){p=q.a
p.toString
return q.j3(p)}else if(p instanceof A.dv){p=q.a
p.toString
return q.j5(p)}return null},
b9(a,b){if(this.b7(a)==null)return null
return this.aq(0)},
j3(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=a.length
if(e<52||g.b==null)return f
s=g.b
s.toString
t.fF.a(s)
r=A.w(a,!1,f,0)
r.d+=52
q=s.Q
if(q<1)q=(s.d&4096)!==0?6:1
if(q!==1)return f
p=s.a
o=s.b
if(p*o*s.f/8>e-52)return f
switch(s.d&255){case 16:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
l=J.d(r.a,r.d++)
k=J.d(r.a,r.d++)
m.sn(k&240)
m.st((k&15)<<4)
m.su(l&240)
m.sv((l&15)<<4)}return n
case 17:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
j=r.q()
i=(j&1)!==0?255:0
m.sn(j>>>8&248)
m.st(j>>>3&248)
m.su((j&62)<<2)
m.sv(i)}return n
case 18:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
m.sn(J.d(r.a,r.d++))
m.st(J.d(r.a,r.d++))
m.su(J.d(r.a,r.d++))
m.sv(J.d(r.a,r.d++))}return n
case 19:n=A.Q(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
j=r.q()
m.sn(j>>>8&248)
m.st(j>>>3&252)
m.su((j&31)<<3)}return n
case 20:n=A.Q(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
j=r.q()
m.sn((j&31)<<3)
m.st(j>>>2&248)
m.su(j>>>7&248)}return n
case 21:n=A.Q(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
m.sn(J.d(r.a,r.d++))
m.st(J.d(r.a,r.d++))
m.su(J.d(r.a,r.d++))}return n
case 22:n=A.Q(f,f,B.e,0,B.j,o,f,0,1,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();)s.gN().sn(J.d(r.a,r.d++))
return n
case 23:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gN()
i=J.d(r.a,r.d++)
h=J.d(r.a,r.d++)
m.sn(h)
m.st(h)
m.su(h)
m.sv(i)}return n
case 24:return f
case 25:return s.y===0?g.f3(p,o,r.a4()):g.dR(p,o,r.a4())}return f},
j5(a){var s,r=this.b
if(!(r instanceof A.dv))return null
s=A.w(a,!1,null,0)
s.d=(s.d+=52)+r.Q
if(r.c[0]===0)switch(r.b){case 2:return this.f3(r.r,r.f,s.a4())
case 3:return this.dR(r.r,r.f,s.a4())}return null},
f3(e4,e5,e6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4=null,d5=A.Q(d4,d4,B.e,0,B.j,e5,d4,0,3,d4,B.e,e4,!1),d6=e4/4|0,d7=d6-1,d8=J.Z(B.d.gB(e6),0,null),d9=new A.a4(d8),e0=new A.a4(J.Z(B.d.gB(e6),0,null)),e1=new A.a4(J.Z(B.d.gB(e6),0,null)),e2=new A.a4(J.Z(B.d.gB(e6),0,null)),e3=new A.a4(J.Z(B.d.gB(e6),0,null))
for(s=d8.length,r=0,q=0;r<d6;++r,q+=4)for(p=0,o=0;p<d6;++p,o+=4){d9.b=A.a6(p,r)<<1>>>0
d9.aF()
n=d9.b
if(!(n<s))return A.a(d8,n)
m=d8[n]
l=d9.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&d7)>>>0
h=(i+1&d7)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&d7)>>>0
e=(f+1&d7)>>>0
e0.b=A.a6(f,i)<<1>>>0
e0.aF()
e1.b=A.a6(e,i)<<1>>>0
e1.aF()
e2.b=A.a6(f,h)<<1>>>0
e2.aF()
e3.b=A.a6(e,h)<<1>>>0
e3.aF()
d=e0.bW()
if(!(k>=0&&k<16))return A.a(B.h,k)
c=B.h[k][0]
b=d.a
a=d.b
d=d.c
a0=e1.bW()
a1=B.h[k][1]
a2=a0.a
a3=a0.b
a0=a0.c
a4=e2.bW()
a5=B.h[k][2]
a6=a4.a
a7=a4.b
a4=a4.c
a8=e3.bW()
a9=B.h[k][3]
b0=a8.a
b1=a8.b
a8=a8.c
b2=e0.bX()
b3=B.h[k][0]
b4=b2.a
b5=b2.b
b2=b2.c
b6=e1.bX()
b7=B.h[k][1]
b8=b6.a
b9=b6.b
b6=b6.c
c0=e2.bX()
c1=B.h[k][2]
c2=c0.a
c3=c0.b
c0=c0.c
c4=e3.bX()
c5=B.h[k][3]
c6=c4.a
c7=c4.b
c4=c4.c
c8=B.bZ[l+m&3]
c9=c8[0]
d0=c8[1]
d1=B.a.j((b*c+a2*a1+a6*a5+b0*a9)*c9+(b4*b3+b8*b7+c2*c1+c6*c5)*d0,7)
d2=B.a.j((a*c+a3*a1+a7*a5+b1*a9)*c9+(b5*b3+b9*b7+c3*c1+c7*c5)*d0,7)
d3=B.a.j((d*c+a0*a1+a4*a5+a8*a9)*c9+(b2*b3+b6*b7+c0*c1+c4*c5)*d0,7)
d0=d5.a
if(d0!=null)d0.aa(g+o,n,d1,d2,d3)
m=m>>>2;++k}}}return d5},
dR(c0,c1,c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=null,b1=A.Q(b0,b0,B.e,0,B.j,c1,b0,0,4,b0,B.e,c0,!1),b2=c0/4|0,b3=b2-1,b4=J.Z(B.d.gB(c2),0,null),b5=new A.a4(b4),b6=new A.a4(J.Z(B.d.gB(c2),0,null)),b7=new A.a4(J.Z(B.d.gB(c2),0,null)),b8=new A.a4(J.Z(B.d.gB(c2),0,null)),b9=new A.a4(J.Z(B.d.gB(c2),0,null))
for(s=b4.length,r=0,q=0;r<b2;++r,q+=4)for(p=0,o=0;p<b2;++p,o+=4){b5.b=A.a6(p,r)<<1>>>0
b5.aF()
n=b5.b
if(!(n<s))return A.a(b4,n)
m=b4[n]
l=b5.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&b3)>>>0
h=(i+1&b3)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&b3)>>>0
e=(f+1&b3)>>>0
b6.b=A.a6(f,i)<<1>>>0
b6.aF()
b7.b=A.a6(e,i)<<1>>>0
b7.aF()
b8.b=A.a6(f,h)<<1>>>0
b8.aF()
b9.b=A.a6(e,h)<<1>>>0
b9.aF()
d=b6.bY()
if(!(k>=0&&k<16))return A.a(B.h,k)
c=B.h[k][0]
b=d.a
a=d.b
a0=d.c
d=d.d
a1=b7.bY()
a2=B.h[k][1]
a2=new A.N(b*c,a*c,a0*c,d*c).aQ(0,new A.N(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a1=b8.bY()
c=B.h[k][2]
c=a2.aQ(0,new A.N(a1.a*c,a1.b*c,a1.c*c,a1.d*c))
a1=b9.bY()
a2=B.h[k][3]
a3=c.aQ(0,new A.N(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a2=b6.bZ()
a1=B.h[k][0]
c=a2.a
d=a2.b
a0=a2.c
a2=a2.d
a=b7.bZ()
b=B.h[k][1]
b=new A.N(c*a1,d*a1,a0*a1,a2*a1).aQ(0,new A.N(a.a*b,a.b*b,a.c*b,a.d*b))
a=b8.bZ()
a1=B.h[k][2]
a1=b.aQ(0,new A.N(a.a*a1,a.b*a1,a.c*a1,a.d*a1))
a=b9.bZ()
b=B.h[k][3]
a4=a1.aQ(0,new A.N(a.a*b,a.b*b,a.c*b,a.d*b))
a5=B.bZ[l+m&3]
b=a3.a
a=a5[0]
a1=a4.a
a2=a5[1]
a6=B.a.j(b*a+a1*a2,7)
a7=B.a.j(a3.b*a+a4.b*a2,7)
a8=B.a.j(a3.c*a+a4.c*a2,7)
a9=B.a.j(a3.d*a5[2]+a4.d*a5[3],7)
a2=b1.a
if(a2!=null)a2.az(g+o,n,a6,a7,a8,a9)
m=m>>>2;++k}}}return b1}}
A.eQ.prototype={
a7(){return"PvrFormat."+this.b}}
A.jI.prototype={
bI(a){var s,r,q,p,o=A.Y(!1,8192)
switch(0){case 0:if(a.gal()===3){s=this.lc(a)
r=B.lj}else{s=this.ld(a)
r=B.lk}break}q=a.gK()
p=a.gS()
o.J(55727696)
o.J(0)
o.J(r.a-1)
o.J(0)
o.J(0)
o.J(0)
o.J(q)
o.J(p)
o.J(1)
o.J(1)
o.J(1)
o.J(1)
o.J(0)
o.a5(s)
return J.B(B.d.gB(o.c),0,o.a)},
lc(d0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9
if(d0.gS()!==d0.gK())throw A.h(A.n("PVRTC requires a square image."))
s=d0.gS()
if((s&s-1)>>>0!==0)throw A.h(A.n(u.b))
r=B.a.W(d0.gS(),4)
q=r-1
s=B.a.W(d0.gS()*d0.gK(),2)
p=new Uint8Array(s)
s=J.Z(B.d.gB(p),0,null)
o=new A.a4(s)
n=new A.a4(J.Z(B.d.gB(p),0,null))
m=new A.a4(J.Z(B.d.gB(p),0,null))
l=new A.a4(J.Z(B.d.gB(p),0,null))
k=new A.a4(J.Z(B.d.gB(p),0,null))
for(j=s.$flags|0,i=t.h,h=0;h<r;++h)for(g=0;g<r;++g){f=A.qo(d0,g,h)
o.b=A.a6(g,h)<<1>>>0
o.aF()
o.c=!1
e=o.aM()
d=o.b+1
j&2&&A.b(s)
if(!(d<s.length))return A.a(s,d)
s[d]=e
e=i.a(f.a)
c=e.a
if(!(c>=0&&c<256))return A.a(B.M,c)
b=B.M[c]
c=e.b
if(!(c>=0&&c<256))return A.a(B.M,c)
a=B.M[c]
e=e.c
if(!(e>=0&&e<256))return A.a(B.K,e)
o.d=(b<<9|a<<4|B.K[e])>>>0
s[d]=o.aM()
o.e=!0
s[d]=o.aM()
e=i.a(f.b)
c=e.a
if(!(c>=0&&c<256))return A.a(B.w,c)
b=B.w[c]
c=e.b
if(!(c>=0&&c<256))return A.a(B.w,c)
a=B.w[c]
e=e.c
if(!(e>=0&&e<256))return A.a(B.w,e)
o.f=(b<<10|a<<5|B.w[e])>>>0
s[d]=o.aM()
o.r=!1
s[d]=o.aM()}for(h=0,a0=0;h<r;++h,a0+=4)for(g=0,a1=0;g<r;++g,a1+=4){for(a2=0,a3=0,a4=0;a4<4;++a4){a5=(h+(a4<2?-1:0)&q)>>>0
a6=(a5+1&q)>>>0
for(i=a0+a4,a7=0;a7<4;++a7){a8=(g+(a7<2?-1:0)&q)>>>0
a9=(a8+1&q)>>>0
n.b=A.a6(a8,a5)<<1>>>0
n.aF()
m.b=A.a6(a9,a5)<<1>>>0
m.aF()
l.b=A.a6(a8,a6)<<1>>>0
l.aF()
k.b=A.a6(a9,a6)<<1>>>0
k.aF()
e=n.bW()
if(!(a2>=0&&a2<16))return A.a(B.h,a2)
d=B.h[a2][0]
c=e.a
b0=e.b
e=e.c
b1=m.bW()
b2=B.h[a2][1]
b3=b1.a
b4=b1.b
b1=b1.c
b5=l.bW()
b6=B.h[a2][2]
b7=b5.a
b8=b5.b
b5=b5.c
b9=k.bW()
c0=B.h[a2][3]
b7=c*d+b3*b2+b7*b6+b9.a*c0
b8=b0*d+b4*b2+b8*b6+b9.b*c0
c0=e*d+b1*b2+b5*b6+b9.c*c0
b9=n.bX()
b6=B.h[a2][0]
b5=b9.a
b2=b9.b
b9=b9.c
b1=m.bX()
d=B.h[a2][1]
e=b1.a
b4=b1.b
b1=b1.c
b0=l.bX()
b3=B.h[a2][2]
c=b0.a
c1=b0.b
b0=b0.c
c2=k.bX()
c3=B.h[a2][3]
c4=c2.a
c5=c2.b
c2=c2.c
c6=d0.a
c7=c6==null?null:c6.P(a1+a7,i,null)
if(c7==null)c7=new A.F()
e=b5*b6+e*d+c*b3+c4*c3-b7
c5=b2*b6+b4*d+c1*b3+c5*c3-b8
c3=b9*b6+b1*d+b0*b3+c2*c3-c0
c8=((B.b.i(c7.gn())*16-b7)*e+(B.b.i(c7.gt())*16-b8)*c5+(B.b.i(c7.gu())*16-c0)*c3)*16
c9=e*e+c5*c5+c3*c3
if(c8>3*c9)++a3
if(c8>8*c9)++a3
if(c8>13*c9)++a3
a3=(a3>>>2|a3<<30)>>>0;++a2}}o.b=A.a6(g,h)<<1>>>0
o.aF()
i=o.b
j&2&&A.b(s)
if(!(i<s.length))return A.a(s,i)
s[i]=a3}return p},
ld(c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1
if(c2.gS()!==c2.gK())throw A.h(A.n("PVRTC requires a square image."))
s=c2.gS()
if((s&s-1)>>>0!==0)throw A.h(A.n(u.b))
r=B.a.W(c2.gS(),4)
q=r-1
s=B.a.W(c2.gS()*c2.gK(),2)
p=new Uint8Array(s)
s=J.Z(B.d.gB(p),0,null)
o=new A.a4(s)
n=new A.a4(J.Z(B.d.gB(p),0,null))
m=new A.a4(J.Z(B.d.gB(p),0,null))
l=new A.a4(J.Z(B.d.gB(p),0,null))
k=new A.a4(J.Z(B.d.gB(p),0,null))
for(j=t.R,i=s.$flags|0,h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){d=A.qp(c2,e,g)
o.b=A.a6(f,h)<<1>>>0
o.aF()
o.c=!1
c=o.aM()
b=o.b+1
i&2&&A.b(s)
if(!(b<s.length))return A.a(s,b)
s[b]=c
c=j.a(d.a)
a=c.d
if(!(a>=0&&a<256))return A.a(B.av,a)
a0=B.av[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.M,a)
a2=B.M[a]
if(!(a1>=0&&a1<256))return A.a(B.M,a1)
a3=B.M[a1]
if(!(c>=0&&c<256))return A.a(B.K,c)
o.d=(a2<<9|a3<<4|B.K[c])>>>0
s[b]=o.aM()
o.e=!0
s[b]=o.aM()}else{if(!(a>=0&&a<256))return A.a(B.K,a)
a2=B.K[a]
if(!(a1>=0&&a1<256))return A.a(B.K,a1)
a3=B.K[a1]
if(!(c>=0&&c<256))return A.a(B.av,c)
o.d=(a0<<11|a2<<7|a3<<3|B.av[c])>>>0
s[b]=o.aM()
o.e=!1
s[b]=o.aM()}c=j.a(d.b)
a=c.d
if(!(a>=0&&a<256))return A.a(B.bu,a)
a0=B.bu[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.w,a)
a2=B.w[a]
if(!(a1>=0&&a1<256))return A.a(B.w,a1)
a3=B.w[a1]
if(!(c>=0&&c<256))return A.a(B.w,c)
o.f=(a2<<10|a3<<5|B.w[c])>>>0
s[b]=o.aM()
o.r=!0
s[b]=o.aM()}else{if(!(a>=0&&a<256))return A.a(B.X,a)
a2=B.X[a]
if(!(a1>=0&&a1<256))return A.a(B.X,a1)
a3=B.X[a1]
if(!(c>=0&&c<256))return A.a(B.X,c)
o.f=(a0<<12|a2<<8|a3<<4|B.X[c])>>>0
s[b]=o.aM()
o.r=!1
s[b]=o.aM()}}for(h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){for(a4=0,a5=0,a6=0;a6<4;++a6){a7=(h+(a6<2?-1:0)&q)>>>0
a8=(a7+1&q)>>>0
for(j=g+a6,a9=0;a9<4;++a9){b0=(f+(a9<2?-1:0)&q)>>>0
b1=(b0+1&q)>>>0
n.b=A.a6(b0,a7)<<1>>>0
n.aF()
m.b=A.a6(b1,a7)<<1>>>0
m.aF()
l.b=A.a6(b0,a8)<<1>>>0
l.aF()
k.b=A.a6(b1,a8)<<1>>>0
k.aF()
c=n.bY()
if(!(a4>=0&&a4<16))return A.a(B.h,a4)
b=B.h[a4][0]
a=c.a
a1=c.b
b2=c.c
c=c.d
b3=m.bY()
b4=B.h[a4][1]
b4=new A.N(a*b,a1*b,b2*b,c*b).aQ(0,new A.N(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b3=l.bY()
b=B.h[a4][2]
b=b4.aQ(0,new A.N(b3.a*b,b3.b*b,b3.c*b,b3.d*b))
b3=k.bY()
b4=B.h[a4][3]
b5=b.aQ(0,new A.N(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b4=n.bZ()
b3=B.h[a4][0]
b=b4.a
c=b4.b
b2=b4.c
b4=b4.d
a1=m.bZ()
a=B.h[a4][1]
a=new A.N(b*b3,c*b3,b2*b3,b4*b3).aQ(0,new A.N(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a1=l.bZ()
b3=B.h[a4][2]
b3=a.aQ(0,new A.N(a1.a*b3,a1.b*b3,a1.c*b3,a1.d*b3))
a1=k.bZ()
a=B.h[a4][3]
b6=b3.aQ(0,new A.N(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a=c2.a
b7=a==null?null:a.P(e+a9,j,null)
if(b7==null)b7=new A.F()
a2=A.m(b7.gn())
a3=A.m(b7.gt())
b8=A.m(b7.gu())
a0=A.m(b7.gv())
b9=b6.ey(0,b5)
c0=new A.N(a2*16,a3*16,b8*16,a0*16).ey(0,b5).hk(b9)*16
c1=b9.hk(b9)
if(c0>3*c1)++a5
if(c0>8*c1)++a5
if(c0>13*c1)++a5
a5=(a5>>>2|a5<<30)>>>0;++a4}}o.b=A.a6(f,h)<<1>>>0
o.aF()
j=o.b
i&2&&A.b(s)
if(!(j<s.length))return A.a(s,j)
s[j]=a5}return p}}
A.jJ.prototype={
$2(a,b){var s=this.a.aR(this.b+a,this.c+b)
return new A.aW(A.m(s.gn()),A.m(s.gt()),A.m(s.gu()))},
$S:28}
A.jK.prototype={
$2(a,b){var s=this.a.aR(this.b+a,this.c+b)
return new A.N(A.m(s.gn()),A.m(s.gt()),A.m(s.gu()),A.m(s.gv()))},
$S:29}
A.eW.prototype={
c9(a){var s,r,q=this
if(a.c-a.d<18)return
q.a=a.I()
q.b=a.I()
s=a.I()
if(s<12){if(!(s>=0))return A.a(B.bU,s)
r=B.bU[s]}else r=B.aA
q.c=r
a.q()
q.e=a.q()
q.f=a.I()
a.q()
a.q()
q.x=a.q()
q.y=a.q()
q.z=a.I()
q.Q=a.I()},
ht(){var s=this,r=s.z
if(r!==8&&r!==16&&r!==24&&r!==32)return!1
r=s.c
if(r===B.N||r===B.O){if(s.e>256||s.b!==1)return!1
r=s.f
if(r!==16&&r!==24&&r!==32)return!1}else if(s.b===1)return!1
return!0},
$iM:1}
A.av.prototype={
a7(){return"TgaImageType."+this.b}}
A.jO.prototype={
b9(a,b){if(this.b7(a)==null)return null
return this.aq(0)},
b7(a){var s,r,q,p,o=this
o.a=new A.eW(B.aA)
s=A.w(a,!1,null,0)
o.b=s
r=s.am(18)
o.a.c9(r)
s=o.a
if(!s.ht())return null
q=o.b
q.d+=s.a
p=s.c
if(p===B.N||p===B.O)s.as=q.am(s.e*B.a.j(s.f,3)).a4()
s=o.a
s.ax=o.b.d
return s},
aq(a){var s=this,r=s.a
if(r==null)return null
r=r.c
if(r===B.cx)return s.f2()
else if(r===B.cw||r===B.O)return s.j8()
else if(r===B.N)return s.f2()
return null},
eZ(a,b){var s,r,q,p,o,n,m,l=this,k=A.w(a,!1,null,0),j=l.a.f
if(j===16){j=l.b
j===$&&A.c("input")
s=j.q()
r=s>>>7&248
q=s>>>2&248
p=(s&31)<<3
o=(s&32768)!==0?0:255
for(n=0;n<l.a.e;++n){b.bF(n,r)
b.bE(n,q)
b.bD(n,p)
b.bC(n,o)}}else{m=j===32
for(n=0;n<l.a.e;++n){p=J.d(k.a,k.d++)
q=J.d(k.a,k.d++)
r=J.d(k.a,k.d++)
o=m?J.d(k.a,k.d++):255
b.bF(n,r)
b.bE(n,q)
b.bD(n,p)
b.bC(n,o)}}},
j8(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,c=e.a,b=c.z,a=b===16,a0=a||b===32,a1=c.x,a2=c.y,a3=a0?4:3
c=c.c
s=A.Q(d,d,B.e,0,B.j,a2,d,0,a3,d,B.e,a1,c===B.N||c===B.O)
c=s.a
if((c==null?d:c.gO())!=null){c=e.a.as
c.toString
a1=s.a
a1=a1==null?d:a1.gO()
a1.toString
e.eZ(c,a1)}r=s.gS()
q=s.gK()-1
c=b===8
p=0
for(;;){a1=e.b
a1===$&&A.c("input")
a2=a1.d
if(!(a2<a1.c&&q>=0))break
a3=a1.a
a1.d=a2+1
o=J.d(a3,a2)
n=(o&127)+1
m=0
if((o&128)!==0)if(c){a1=e.b
l=J.d(a1.a,a1.d++)
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.aK(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{a1=e.b
if(a){i=a1.q()
l=i>>>7&248
h=i>>>2&248
g=(i&31)<<3
f=(i&32768)!==0?0:255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.az(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{g=J.d(a1.a,a1.d++)
a1=e.b
h=J.d(a1.a,a1.d++)
a1=e.b
l=J.d(a1.a,a1.d++)
if(a0){a1=e.b
f=J.d(a1.a,a1.d++)}else f=255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.az(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}}else if(c)for(k=0;k<n;++k){a1=e.b
l=J.d(a1.a,a1.d++)
j=p+1
a1=s.a
if(a1!=null)a1.aK(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else if(a)for(k=0;k<n;++k){i=e.b.q()
f=(i&32768)!==0?0:255
j=p+1
a1=s.a
if(a1!=null)a1.az(p,q,i>>>7&248,i>>>2&248,(i&31)<<3,f)
a1=e.b
if(a1.d>=a1.c){p=j
break}if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else for(k=0;k<n;++k){a1=e.b
g=J.d(a1.a,a1.d++)
a1=e.b
h=J.d(a1.a,a1.d++)
a1=e.b
l=J.d(a1.a,a1.d++)
if(a0){a1=e.b
f=J.d(a1.a,a1.d++)}else f=255
j=p+1
a1=s.a
if(a1!=null)a1.az(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}if(p>=r){--q
if(q<0)break
p=0}}return s},
f2(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=d.b
b===$&&A.c("input")
s=d.a
b.d=s.ax
r=s.z
b=r===16
q=!0
if(!b)if(r!==32){p=s.c
if(p===B.N||p===B.O){p=s.f
p=p===16||p===32}else p=!1
q=p}p=s.x
o=s.y
n=q?4:3
s=s.c
m=A.Q(c,c,B.e,0,B.j,o,c,0,n,c,B.e,p,s===B.N||s===B.O)
s=d.a
p=s.c
if(p===B.N||p===B.O){s=s.as
s.toString
p=m.a
p=p==null?c:p.gO()
p.toString
d.eZ(s,p)}if(r===8)for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
j=J.d(b.a,b.d++)
b=m.a
if(b!=null)b.aK(k,l,j);++k}}else if(b)for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
i=d.b.q()
h=(i&32768)!==0?0:255
b=m.a
if(b!=null)b.az(k,l,i>>>7&248,i>>>2&248,(i&31)<<3,h);++k}}else for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
g=J.d(b.a,b.d++)
b=d.b
f=J.d(b.a,b.d++)
b=d.b
e=J.d(b.a,b.d++)
if(q){b=d.b
h=J.d(b.a,b.d++)}else h=255
b=m.a
if(b!=null)b.az(k,l,e,f,g,h);++k}}return m}}
A.jP.prototype={
bI(a){var s,r,q,p,o,n,m,l=null,k=A.Y(!0,8192),j=A.E(18,0,!1,t.p)
B.c.h(j,2,2)
B.c.h(j,12,a.gS()&255)
B.c.h(j,13,B.a.j(a.gS(),8)&255)
B.c.h(j,14,a.gK()&255)
B.c.h(j,15,B.a.j(a.gK(),8)&255)
s=a.a
s=s==null?l:s.gO()
r=s==null?l:s.b
if(r==null)r=a.gal()
B.c.h(j,16,r===3?24:32)
k.a5(j)
if(r===4)for(q=a.gK()-1;q>=0;--q){p=0
for(;;){s=a.a
o=s==null
n=o?l:s.a
if(!(p<(n==null?0:n)))break
m=o?l:s.P(p,q,l)
if(m==null)m=new A.F()
k.m(A.m(m.gu()))
k.m(A.m(m.gt()))
k.m(A.m(m.gn()))
k.m(A.m(m.gv()));++p}}else for(q=a.gK()-1;q>=0;--q){p=0
for(;;){s=a.a
o=s==null
n=o?l:s.a
if(!(p<(n==null?0:n)))break
m=o?l:s.P(p,q,l)
if(m==null)m=new A.F()
k.m(A.m(m.gu()))
k.m(A.m(m.gt()))
k.m(A.m(m.gn()));++p}}return J.B(B.d.gB(k.c),0,k.a)}}
A.jQ.prototype={
an(a){var s,r,q,p,o,n=this
if(a===0)return 0
if(n.c===0){n.c=8
n.b=n.a.I()}for(s=n.a,r=0;q=n.c,a>q;){p=B.a.V(r,q)
o=n.b
if(!(q>=0&&q<9))return A.a(B.D,q)
r=p+(o&B.D[q])
a-=q
n.c=8
n.b=J.d(s.a,s.d++)}if(a>0){if(q===0){n.c=8
n.b=s.I()}s=B.a.V(r,a)
q=n.b
p=n.c-a
q=B.a.aL(q,p)
if(!(a<9))return A.a(B.D,a)
r=s+(q&B.D[a])
n.c=p}return r}}
A.hX.prototype={
D(a){var s=this,r=s.a,q=$.lI().l(0,r)
if(q!=null)return q.a+": "+s.b.D(0)+" "+s.c
return"<"+r+">: "+s.b.D(0)+" "+s.c},
bt(){var s,r,q,p,o=this,n=o.e
if(n!=null)return n
n=o.f
n.d=o.d
s=o.c
r=o.b
if(r!==B.f){q=r.a
if(!(q<14))return A.a(B.v,q)
q=B.v[q]}else q=0
p=n.am(s*q)
switch(r.a){case 1:return o.e=new A.b7(new Uint8Array(A.q(p.am(s).a4())))
case 2:return o.e=new A.cl(s===0?"":p.ao(s-1))
case 7:return o.e=new A.b7(new Uint8Array(A.q(p.am(s).a4())))
case 3:return o.e=A.nn(p,s)
case 4:return o.e=A.ni(p,s)
case 5:return o.e=A.nj(p,s)
case 11:return o.e=A.no(p,s)
case 12:return o.e=A.nh(p,s)
case 6:return o.e=new A.bj(new Int8Array(A.q(J.lJ(B.d.gB(p.a4()),0,s))))
case 8:return o.e=A.nm(p,s)
case 9:return o.e=A.nk(p,s)
case 10:return o.e=A.nl(p,s)
case 13:case 0:return null}}}
A.jT.prototype={
l6(a,b,c,d){var s,r,q,p=this
p.r=b
p.x=p.w=0
s=B.a.W(p.a+7,8)
for(r=0,q=0;q<d;++q){p.dP(a,r,c)
r+=s}},
dP(a,b,c){var s,r,q,p,o,n,m,l,k=this
k.d=0
for(s=k.a,r=!0;c<s;){while(r){q=k.c2(10)
if(!(q<1024))return A.a(B.ar,q)
p=B.ar[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|k.b8(2))>>>0
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
n=B.a.j(p,1)
c+=B.a.j(p,4)&4095
k.aJ(4-(n&7))}else if(o===0)throw A.h(A.n("TIFFFaxDecoder0"))
else if(o===15)throw A.h(A.n("TIFFFaxDecoder1"))
else{c+=B.a.j(p,5)&2047
k.aJ(10-o)
if((p&1)===0){B.c.h(k.f,k.d++,c)
r=!1}}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}while(!r){q=k.b8(4)
if(!(q<16))return A.a(B.ah,q)
p=B.ah[q]
m=p>>>5&2047
l=!0
if(m===100){q=k.c2(9)
if(!(q<512))return A.a(B.al,q)
p=B.al[q]
o=B.a.j(p,1)&15
m=B.a.j(p,5)&2047
if(o===12){k.aJ(5)
q=k.b8(4)
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
n=B.a.j(p,1)
m=B.a.j(p,4)&4095
k.bb(a,b,c,m)
c+=m
k.aJ(4-(n&7))}else if(o===15)throw A.h(A.n("TIFFFaxDecoder2"))
else{k.bb(a,b,c,m)
c+=m
k.aJ(9-o)
if((p&1)===0){B.c.h(k.f,k.d++,c)
r=l}}}else{if(m===200){q=k.b8(2)
if(!(q<4))return A.a(B.ag,q)
p=B.ag[q]
m=p>>>5&2047
k.bb(a,b,c,m)
c+=m
k.aJ(2-(p>>>1&15))
B.c.h(k.f,k.d++,c)}else{k.bb(a,b,c,m)
c+=m
k.aJ(4-(p>>>1&15))
B.c.h(k.f,k.d++,c)}r=l}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}}B.c.h(k.f,k.d++,c)},
l7(a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
a0.r=a2
a0.z=3
a0.x=a0.w=0
s=a0.a
r=B.a.W(s+7,8)
q=A.E(2,null,!1,t.I)
a0.at=a5&1
a0.as=a5>>>2&1
if(a0.fv()!==1)throw A.h(A.n("TIFFFaxDecoder3"))
a0.dP(a1,0,a3)
for(p=r,o=1;o<a4;++o){if(a0.fv()===0){n=a0.e
a0.e=a0.f
a0.f=n
a0.y=0
m=a3
l=-1
k=!0
j=0
for(;;){m.toString
if(!(m<s))break
a0.fe(l,k,q)
i=q[0]
h=q[1]
g=a0.b8(7)
if(!(g<128))return A.a(B.ap,g)
g=B.ap[g]&255
f=g>>>3&15
e=g&7
if(f===0){if(!k){h.toString
a0.bb(a1,p,m,h-m)}a0.aJ(7-e)
m=h
l=m}else if(f===1){a0.aJ(7-e)
d=j+1
c=d+1
if(k){m+=a0.df()
B.c.h(a0.f,j,m)
b=a0.de()
a0.bb(a1,p,m,b)
m+=b
B.c.h(a0.f,d,m)}else{b=a0.de()
a0.bb(a1,p,m,b)
m+=b
B.c.h(a0.f,j,m)
m+=a0.df()
B.c.h(a0.f,d,m)}j=c
l=m}else{if(f<=8){i.toString
a=i+(f-5)
d=j+1
B.c.h(a0.f,j,a)
k=!k
if(k)a0.bb(a1,p,m,a-m)
a0.aJ(7-e)}else throw A.h(A.n("TIFFFaxDecoder4"))
m=a
j=d
l=m}}B.c.h(a0.f,j,m)
a0.d=j+1}else a0.dP(a1,p,a3)
p+=r}},
lb(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.r=a6
a4.z=4
a4.x=a4.w=0
s=a4.a
r=B.a.W(s+7,8)
q=A.E(2,null,!1,t.I)
p=a4.f
a4.d=0
a4.d=1
B.c.h(p,0,s)
B.c.h(p,a4.d++,s)
for(o=0,n=0;n<a8;++n){m=a4.e
a4.e=a4.f
a4.f=m
a4.y=0
l=a7
k=-1
j=!0
i=0
for(;;){l.toString
if(!(l<s))break
a4.fe(k,j,q)
h=q[0]
g=q[1]
f=a4.b8(7)
if(!(f<128))return A.a(B.ap,f)
f=B.ap[f]&255
e=f>>>3&15
d=f&7
if(e===0){if(!j){g.toString
a4.bb(a5,o,l,g-l)}a4.aJ(7-d)
l=g
k=l}else if(e===1){a4.aJ(7-d)
c=i+1
b=c+1
if(j){l+=a4.df()
B.c.h(m,i,l)
a=a4.de()
a4.bb(a5,o,l,a)
l+=a
B.c.h(m,c,l)}else{a=a4.de()
a4.bb(a5,o,l,a)
l+=a
B.c.h(m,i,l)
l+=a4.df()
B.c.h(m,c,l)}i=b
k=l}else if(e<=8){h.toString
a0=h+(e-5)
c=i+1
B.c.h(m,i,a0)
j=!j
if(j)a4.bb(a5,o,l,a0-l)
a4.aJ(7-d)
l=a0
i=c
k=l}else if(e===11){if(a4.b8(3)!==7)throw A.h(A.n("TIFFFaxDecoder5"))
for(a1=0,a2=!1;!a2;j=a3){while(a4.b8(1)!==1)++a1
if(a1>5){a1-=6
if(!j&&a1>0){c=i+1
B.c.h(m,i,l)
i=c}l+=a1
if(a1>0)j=!0
a3=a4.b8(1)===0
if(a3){if(!j){c=i+1
B.c.h(m,i,l)
i=c}}else if(j){c=i+1
B.c.h(m,i,l)
i=c}j=a3
a2=!0}a3=a1===5
if(a3){if(!j){c=i+1
B.c.h(m,i,l)
i=c}l+=a1}else{l+=a1
c=i+1
B.c.h(m,i,l)
a4.bb(a5,o,l,1);++l
i=c}}}else throw A.h(A.n("TIFFFaxDecoder5 "+e))}B.c.h(m,i,l)
a4.d=i+1
o+=r}},
df(){var s,r,q,p,o,n,m=this
for(s=0,r=!0;r;){q=m.c2(10)
if(!(q<1024))return A.a(B.ar,q)
p=B.ar[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|m.b8(2))>>>0
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
n=B.a.j(p,1)
s+=B.a.j(p,4)&4095
m.aJ(4-(n&7))}else if(o===0)throw A.h(A.n("TIFFFaxDecoder0"))
else if(o===15)throw A.h(A.n("TIFFFaxDecoder1"))
else{s+=B.a.j(p,5)&2047
m.aJ(10-o)
if((p&1)===0)r=!1}}return s},
de(){var s,r,q,p,o,n,m,l=this
for(s=0,r=!1;!r;){q=l.b8(4)
if(!(q<16))return A.a(B.ah,q)
p=B.ah[q]
o=p>>>5&2047
if(o===100){q=l.c2(9)
if(!(q<512))return A.a(B.al,q)
p=B.al[q]
n=B.a.j(p,1)&15
m=B.a.j(p,5)
if(n===12){l.aJ(5)
q=l.b8(4)
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
m=B.a.j(p,1)
s+=B.a.j(p,4)&4095
l.aJ(4-(m&7))}else if(n===15)throw A.h(A.n("TIFFFaxDecoder2"))
else{s+=m&2047
l.aJ(9-n)
if((p&1)===0)r=!0}}else{if(o===200){q=l.b8(2)
if(!(q<4))return A.a(B.ag,q)
p=B.ag[q]
s+=p>>>5&2047
l.aJ(2-(p>>>1&15))}else{s+=o
l.aJ(4-(p>>>1&15))}r=!0}}return s},
fv(){var s,r,q=this,p="TIFFFaxDecoder8",o=q.as
if(o===0){if(q.c2(12)!==1)throw A.h(A.n("TIFFFaxDecoder6"))}else if(o===1){o=q.w
o.toString
s=8-o
if(q.c2(s)!==0)throw A.h(A.n(p))
if(s<4)if(q.c2(8)!==0)throw A.h(A.n(p))
while(r=q.c2(8),r!==1)if(r!==0)throw A.h(A.n(p))}if(q.at===0)return 1
else return q.b8(1)},
fe(a,b,c){var s,r,q,p,o,n,m=this
t.dW.a(c)
s=m.e
r=m.d
q=m.y
p=q>0?q-1:0
p=b?(p&4294967294)>>>0:(p|1)>>>0
for(q=s.length,o=p;o<r;o+=2){if(!(o<q))return A.a(s,o)
n=s[o]
n.toString
a.toString
if(n>a){m.y=o
B.c.h(c,0,n)
break}}n=o+1
if(n<r){if(!(n<q))return A.a(s,n)
B.c.h(c,1,s[n])}},
bb(a,b,c,d){var s,r,q,p,o,n=8*b+A.m(c),m=n+d,l=B.a.j(n,3),k=n&7
if(k>0){s=B.a.V(1,7-k)
r=J.d(a.a,a.d+l)
for(;;){if(!(s>0&&n<m))break
r=(r|s)>>>0
s=s>>>1;++n}a.h(0,l,r)}l=B.a.j(n,3)
for(q=m-7;n<q;l=p){p=l+1
J.y(a.a,a.d+l,255)
n+=8}while(n<m){l=B.a.j(n,3)
q=J.d(a.a,a.d+l)
o=B.a.V(1,7-(n&7))
J.y(a.a,a.d+l,(q|o)>>>0);++n}},
c2(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.r
e===$&&A.c("data")
s=e.d
r=e.c-s-1
q=f.x
p=f.c
o=0
n=0
if(p===1){q.toString
m=J.d(e.a,s+q)
if(!(q===r)){e=q+1
s=f.r
p=s.a
s=s.d
if(e===r)o=J.d(p,s+e)
else{o=J.d(p,s+e)
e=f.r
n=J.d(e.a,e.d+(q+2))}}}else if(p===2){q.toString
m=B.a0[J.d(e.a,s+q)&255]
if(!(q===r)){e=q+1
s=f.r
p=s.a
s=s.d
if(e===r)o=B.a0[J.d(p,s+e)&255]
else{o=B.a0[J.d(p,s+e)&255]
e=f.r
n=B.a0[J.d(e.a,e.d+(q+2))&255]}}}else throw A.h(A.n("TIFFFaxDecoder7"))
e=f.w
e.toString
l=8-e
k=a-l
if(k>8){j=k-8
i=8}else{i=k
j=0}e=f.x
e.toString
e=f.x=e+1
if(!(l>=0&&l<9))return A.a(B.D,l)
h=B.a.V(m&B.D[l],k)
if(!(i>=0))return A.a(B.Z,i)
g=B.a.a2(o&B.Z[i],8-i)
if(j!==0){g=B.a.V(g,j)
if(!(j<9))return A.a(B.Z,j)
g|=B.a.a2(n&B.Z[j],8-j)
f.x=e+1
f.w=j}else if(i===8){f.w=0
f.x=e+1}else f.w=i
return(h|g)>>>0},
b8(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.r
h===$&&A.c("data")
s=h.d
r=h.c-s-1
q=i.x
p=i.c
o=0
if(p===1){q.toString
n=J.d(h.a,s+q)
if(!(q===r)){h=i.r
o=J.d(h.a,h.d+(q+1))}}else if(p===2){q.toString
n=B.a0[J.d(h.a,s+q)&255]
if(!(q===r)){h=i.r
o=B.a0[J.d(h.a,h.d+(q+1))&255]}}else throw A.h(A.n("TIFFFaxDecoder7"))
h=i.w
h.toString
m=8-h
l=a-m
k=m-a
if(k>=0){if(!(m>=0&&m<9))return A.a(B.D,m)
j=B.a.a2(n&B.D[m],k)
h+=a
i.w=h
if(h===8){i.w=0
h=i.x
h.toString
i.x=h+1}}else{if(!(m>=0&&m<9))return A.a(B.D,m)
j=B.a.V(n&B.D[m],-k)
if(!(l>=0&&l<9))return A.a(B.Z,l)
j=(j|B.a.a2(o&B.Z[l],8-l))>>>0
h=i.x
h.toString
i.x=h+1
i.w=l}return j},
aJ(a){var s,r=this,q=r.w
q.toString
s=q-a
if(s<0){q=r.x
q.toString
r.x=q-1
r.w=8+s}else r.w=s}}
A.hY.prototype={
im(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=A.p(a0,c,0),a=a0.q()
for(s=d.a,r=0;r<a;++r){q=a0.q()
p=a0.q()
o=a0.k()
if(p>13){a0.d+=4
continue}n=B.bR[p]
if(o*B.v[p]>4)m=a0.k()
else{m=a0.d
a0.d=m+4}l=new A.hX(q,n,o,m,b)
s.h(0,q,l)
if(q===256){k=l.bt()
k=k==null?c:k.i(0)
d.b=k==null?0:k}else if(q===257){k=l.bt()
k=k==null?c:k.i(0)
d.c=k==null?0:k}else if(q===262){j=l.bt()
i=j==null?c:j.i(0)
if(i==null)i=17
if(i<17){if(!(i>=0))return A.a(B.bM,i)
d.d=B.bM[i]}else d.d=B.b0}else if(q===259){k=l.bt()
k=k==null?c:k.i(0)
d.e=k==null?0:k}else if(q===258){k=l.bt()
k=k==null?c:k.i(0)
d.f=k==null?0:k}else if(q===277){k=l.bt()
k=k==null?c:k.i(0)
d.r=k==null?0:k}else if(q===317){k=l.bt()
k=k==null?c:k.i(0)
d.Q=k==null?0:k}else if(q===339){k=l.bt()
j=k==null?c:k.i(0)
if(j==null)j=0
if(!(j>=0&&j<4))return A.a(B.bQ,j)
d.x=B.bQ[j]}else if(q===320){j=l.bt()
if(j!=null){k=J.pc(B.d.gB(j.bv()))
d.id=k
d.k1=0
k=k.length/3|0
d.k2=k
d.k3=k*2}}}k=d.id
h=k!=null
if(h&&d.d===B.b1)d.r=1
if(d.b===0||d.c===0)return
if(h&&d.f===8){g=k.length
for(h=k.$flags|0,r=0;r<g;++r){f=k[r]
h&2&&A.b(k)
k[r]=f>>>8}}if(d.d===B.b_)d.z=!0
d.w=d.r
if(s.a9(324)){d.ay=d.cu(322)
d.ch=d.cu(323)
d.CW=d.dn(324)
d.cx=d.dn(325)}else{d.ay=d.dm(322,d.b)
if(!s.a9(278))d.ch=d.dm(323,d.c)
else{e=d.cu(278)
if(e===-1)d.ch=d.c
else d.ch=e}d.CW=d.dn(273)
d.cx=d.dn(279)}k=d.b
h=d.ay
d.cy=B.a.au(k+h-1,h)
h=d.c
k=d.ch
d.db=B.a.au(h+k-1,k)
d.dy=d.dm(266,1)
d.fr=d.cu(292)
d.fx=d.cu(293)
d.cu(338)
switch(d.d.a){case 0:case 1:s=d.f
if(s===1&&d.r===1)d.y=B.aZ
else if(s===4&&d.r===1)d.y=B.lt
else if(B.a.a8(s,8)===0){s=d.r
if(s===1)d.y=B.lu
else if(s===2)d.y=B.lv
else d.y=B.a8}break
case 2:if(B.a.a8(d.f,8)===0){s=d.r
if(s===3)d.y=B.cy
else if(s===4)d.y=B.lx
else d.y=B.a8}break
case 3:s=!1
if(d.r===1)if(d.id!=null){s=d.f
s=s===4||s===8||s===16}if(s)d.y=B.lw
break
case 4:if(d.f===1&&d.r===1)d.y=B.aZ
break
case 6:if(d.e===7&&d.f===8&&d.r===3)d.y=B.cy
else{if(s.a9(530)){j=s.l(0,530).bt()
d.as=j.i(0)
s=d.at=j.ad(0,1)}else s=d.at=d.as=2
k=d.as
k===$&&A.c("chromaSubH")
if(k*s===1)d.y=B.a8
else if(d.f===8&&d.r===3)d.y=B.ly}break
case 5:if(B.a.a8(d.f,8)===0)d.y=B.a8
s=d.r
if(s===4)d.w=3
else if(s===5)d.w=4
break
default:if(B.a.a8(d.f,8)===0)d.y=B.a8
break}},
c5(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.x,a1=a0===B.a1,a2=a0===B.i
a0=b.f
if(a0===1)s=B.A
else if(a0===2)s=B.u
else{if(a0===4)a0=B.B
else if(a1&&a0===16)a0=B.I
else if(a1&&a0===32)a0=B.Q
else if(a1&&a0===64)a0=B.T
else if(a2&&a0===8)a0=B.U
else if(a2&&a0===16)a0=B.V
else if(a2&&a0===32)a0=B.W
else if(a0===16)a0=B.n
else a0=a0===32?B.R:B.e
s=a0}r=b.id!=null&&b.d===B.b1
q=r?3:b.w
a0=b.b
p=A.Q(a,a,s,0,B.j,b.c,a,0,q,a,s,a0,r)
if(r){a0=p.a
a0=a0==null?a:a0.gO()
a0.toString
o=b.id
n=o.length
m=n/3|0
l=b.k1
l===$&&A.c("colorMapRed")
k=b.k2
k===$&&A.c("colorMapGreen")
j=b.k3
j===$&&A.c("colorMapBlue")
for(i=j,h=k,g=l,f=0;f<m;++f,++g,++h,++i){if(i>=n)break
if(!(g<n))return A.a(o,g)
l=o[g]
if(!(h<n))return A.a(o,h)
a0.b4(f,l,o[h],o[i])}}e=0
d=0
for(;;){a0=b.db
a0===$&&A.c("tilesY")
if(!(e<a0))break
c=0
for(;;){a0=b.cy
a0===$&&A.c("tilesX")
if(!(c<a0))break
b.j9(a3,p,c,e);++c;++d}++e}return p},
j9(b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=this,b1=null
if(b0.y===B.aZ){b0.iX(b2,b3,b4,b5)
return}p=b0.cy
p===$&&A.c("tilesX")
o=b5*p+b4
p=b0.CW
if(!(o>=0&&o<p.length))return A.a(p,o)
b2.d=p[o]
p=b0.ay
n=b4*p
m=b0.ch
l=b5*m
k=b0.cx
if(!(o<k.length))return A.a(k,o)
s=k[o]
j=p*m*b0.r
p=b0.f
m=p===16
if(m)j*=2
else if(p===32)j*=4
r=null
if(p===8||m||p===32||p===64){p=b0.e
if(p===1)r=b2
else if(p===5){r=A.w(new Uint8Array(j),!1,b1,0)
q=A.ny()
try{q.hg(A.p(b2,s,0),r.a)}catch(i){}if(b0.Q===2)for(h=0;h<b0.ch;++h){g=b0.r
p=b0.ay
f=g*(h*p+1)
e=p*g
for(;g<e;++g){p=r
m=J.d(p.a,p.d+f)
k=r
d=b0.r
d=J.d(k.a,k.d+(f-d))
J.y(p.a,p.d+f,m+d);++f}}}else if(p===32773){r=A.w(new Uint8Array(j),!1,b1,0)
b0.f1(b2,j,r.a)}else if(p===32946)r=A.w(B.H.c6(b2.d3(0,0,s)),!1,b1,0)
else if(p===8)r=A.w(B.H.c6(b2.d3(0,0,s)),!1,b1,0)
else if(p===6||p===7){b0.jS(new A.ho().c5(t.D.a(b2.d3(0,0,s))),b3,n,l,b0.ay,b0.ch)
return}else throw A.h(A.n("Unsupported Compression Type: "+p))
c=A.j([0,0,0],t.t)
for(b=l,a=0;a<b0.ch;++a,++b)for(a0=n,a1=0;a1<b0.ay;++a1,++a0){p=r
if(p.d>=p.c||a0>=b0.b||b>=b0.c)break
p=b0.r
if(p===1){p=b0.x
if(p===B.a1){p=b0.f
if(p===32){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.cd()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else if(p===64)a2=r.dD()
else if(p===16){p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a2=m[p]}else a2=0
if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aK(a0,b,a2)}}else{m=b0.f
if(m===8)if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else{p=r
a2=J.d(p.a,p.d++)}else if(m===16)if(p===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else a2=r.q()
else if(m===32)if(p===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else a2=r.k()
else a2=0
if(b0.d===B.b_){p=b3.a
a3=p==null?b1:p.gF()
a2=(a3==null?0:a3)-a2}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aK(a0,b,a2)}}}else if(p===2){p=b0.f
if(p===8){if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else{p=r
a4=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}}else if(p===16){if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else a4=r.q()
if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.q()}else if(p===32){if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else a4=r.k()
if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()}else{a4=0
a5=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aa(a0,b,a4,a5,0)}}else if(p===3){p=b0.x
if(p===B.a1){p=b0.f
if(p===32){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.cd()
if(0>=p.length)return A.a(p,0)
a6=p[0]
m[0]=r.k()
a7=p[0]
m[0]=r.k()
a8=p[0]}else{a7=0
a8=0
if(p===64)a6=r.dD()
else if(p===16){p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a6=m[p]
p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a7=m[p]
p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a8=m[p]}else a6=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aa(a0,b,a6,a7,a8)}}else{m=b0.f
if(m===8){if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else{p=r
a6=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}}else if(m===16){if(p===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.q()
if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.q()
if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.q()}else if(m===32){if(p===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.k()
if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()}else{a6=0
a7=0
a8=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aa(a0,b,a6,a7,a8)}}}else if(p>=4)if(b0.x===B.a1){p=b0.f
if(p===32){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.cd()
if(0>=p.length)return A.a(p,0)
a6=p[0]
m[0]=r.k()
a7=p[0]
m[0]=r.k()
a8=p[0]
m[0]=r.k()
a9=p[0]}else{a7=0
a8=0
a9=0
if(p===64)a6=r.dD()
else if(p===16){p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a6=m[p]
p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a7=m[p]
p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a8=m[p]
p=r.q()
m=$.U
m=m!=null?m:A.X()
if(!(p<m.length))return A.a(m,p)
a9=m[p]}else a6=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.az(a0,b,a6,a7,a8,a9)}}else{p=b3.a
a5=p==null?b1:p.gF()
if(a5==null)a5=0
p=b0.f
if(p===8){if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else{p=r
a6=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else{p=r
a9=J.d(p.a,p.d++)}if(b0.r===5)if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.aq()
m.$flags&2&&A.b(m)
m[0]=p
p=$.az()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}}else if(p===16){if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.q()
if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.q()
if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.q()
if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.q()
if(b0.r===5)if(b0.x===B.i){p=r.q()
m=$.ap()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.q()}else if(p===32){if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.k()
if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()
if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.k()
if(b0.r===5)if(b0.x===B.i){p=r.k()
m=$.P()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a7()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()}else{a6=0
a7=0
a8=0
a9=0}if(b0.d===B.cz){A.ou(a6,a7,a8,a9,c)
a6=c[0]
a7=c[1]
a8=c[2]
a9=a5}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.az(a0,b,a6,a7,a8,a9)}}}}else throw A.h(A.n("Unsupported bitsPerSample: "+p))},
jS(a,b,c,d,e,f){var s,r,q,p
for(s=0;s<f;++s)for(r=s+d,q=0;q<e;++q){p=a.a
p=p==null?null:p.P(q,s,null)
if(p==null)p=new A.F()
b.ca(q+c,r,p)}},
iX(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=null,a4=a2.cy
a4===$&&A.c("tilesX")
r=a8*a4+a7
a4=a2.CW
if(!(r>=0&&r<a4.length))return A.a(a4,r)
a5.d=a4[r]
a4=a2.ay
q=a7*a4
p=a2.ch
o=a8*p
n=a2.cx
if(!(r<n.length))return A.a(n,r)
m=n[r]
s=null
n=a2.e
if(n===32773){l=B.a.a8(a4,8)===0?B.a.W(a4,8)*p:(B.a.W(a4,8)+1)*p
s=A.w(new Uint8Array(a4*p),!1,a3,0)
a2.f1(a5,l,s.a)}else if(n===5){s=A.w(new Uint8Array(a4*p),!1,a3,0)
A.ny().hg(A.p(a5,m,0),s.a)
if(a2.Q===2)for(k=0;k<a2.c;++k){j=a2.r
i=j*(k*a2.b+1)
for(;j<a2.b*a2.r;++j){a4=s
p=J.d(a4.a,a4.d+i)
n=s
h=a2.r
h=J.d(n.a,n.d+(i-h))
J.y(a4.a,a4.d+i,p+h);++i}}}else if(n===2){s=A.w(new Uint8Array(a4*p),!1,a3,0)
try{A.ml(a2.dy,a4,p).l6(s,a5,0,a2.ch)}catch(g){}}else if(n===3){s=A.w(new Uint8Array(a4*p),!1,a3,0)
try{A.ml(a2.dy,a4,p).l7(s,a5,0,a2.ch,a2.fr)}catch(g){}}else if(n===4){s=A.w(new Uint8Array(a4*p),!1,a3,0)
try{A.ml(a2.dy,a4,p).lb(s,a5,0,a2.ch,a2.fx)}catch(g){}}else if(n===8)s=A.w(B.H.c6(a5.d3(0,0,m)),!1,a3,0)
else if(n===32946)s=A.w(B.H.c6(a5.d3(0,0,m)),!1,a3,0)
else if(n===1)s=a5
else throw A.h(A.n("Unsupported Compression Type: "+n))
f=new A.jQ(s)
e=a6.gF()
a4=a2.z
d=a4?e:0
c=a4?0:e
for(b=o,a=0;a<a2.ch;++a,++b){for(a0=q,a1=0;a1<a2.ay;++a1,++a0){a4=a6.a
p=a4==null
n=p?a3:a4.b
if(b<(n==null?0:n)){a4=p?a3:a4.a
a4=a0>=(a4==null?0:a4)}else a4=!0
if(a4)break
a4=f.an(1)
p=a6.a
if(a4===0){if(p!=null)p.aa(a0,b,d,0,0)}else if(p!=null)p.aa(a0,b,c,0,0)}f.c=0}},
f1(a,b,c){var s,r,q,p,o,n,m,l,k,j
t.L.a(c)
for(s=J.an(c),r=0,q=0;q<b;){p=r+1
o=J.d(a.a,a.d+r)
n=$.aq()
n.$flags&2&&A.b(n)
n[0]=o
o=$.az()
if(0>=o.length)return A.a(o,0)
m=o[0]
if(m>=0&&m<=127)for(o=m+1,r=p,l=0;l<o;++l,q=k,r=p){k=q+1
p=r+1
s.h(c,q,J.d(a.a,a.d+r))}else{o=m<=-1&&m>=-127
r=p+1
if(o){j=J.d(a.a,a.d+p)
for(o=-m+1,l=0;l<o;++l,q=k){k=q+1
s.h(c,q,j)}}}}},
dm(a,b){var s=this.a
if(!s.a9(a))return b
s=s.l(0,a).bt()
s=s==null?null:s.i(0)
return s==null?0:s},
cu(a){return this.dm(a,0)},
dn(a){var s,r=this.a
if(!r.a9(a))return null
s=r.l(0,a)
r=s.bt()
r.toString
return A.nx(s.c,r.gbN(r),t.p)}}
A.cG.prototype={
a7(){return"TiffFormat."+this.b}}
A.a9.prototype={
a7(){return"TiffPhotometricType."+this.b}}
A.aZ.prototype={
a7(){return"TiffImageType."+this.b}}
A.hZ.prototype={$iM:1}
A.js.prototype={
hg(a,b){var s,r,q,p,o,n,m,l,k=this,j="_bufferLength"
t.L.a(b)
k.r=b
s=J.bv(b)
k.w=0
r=t.D.a(a.a)
k.e=r
q=k.f=r.length
k.b=a.d
if(0>=q)return A.a(r,0)
if(r[0]===0){if(1>=q)return A.a(r,1)
r=r[1]===1}else r=!1
if(r)throw A.h(A.n("Invalid LZW Data"))
k.fj()
k.d=k.c=0
p=k.dY()
r=k.x
o=0
for(;;){if(!(p!==257&&k.w<s))break
if(p===256){k.fj()
p=k.dY()
k.as=0
if(p===257)break
J.y(k.r,k.w++,p)
o=p}else{q=k.Q
q.toString
if(p<q){k.fg(p)
q=k.as
q===$&&A.c(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.y(q,m,r[n])}q=k.as-1
if(!(q>=0&&q<4096))return A.a(r,q)
k.eF(o,r[q])}else{k.fg(o)
q=k.as
q===$&&A.c(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.y(q,m,r[n])}q=k.r
m=k.w++
l=k.as-1
if(!(l>=0&&l<4096))return A.a(r,l)
J.y(q,m,r[l])
l=k.as-1
if(!(l>=0&&l<4096))return A.a(r,l)
k.eF(o,r[l])}o=p}p=k.dY()}},
eF(a,b){var s,r=this,q=r.y
q===$&&A.c("_table")
s=r.Q
s.toString
q.$flags&2&&A.b(q)
if(!(s<4096))return A.a(q,s)
q[s]=b
q=r.z
q===$&&A.c("_prefix")
q.$flags&2&&A.b(q)
q[s]=a
s=r.Q=s+1
if(s===511)r.a=10
else if(s===1023)r.a=11
else if(s===2047)r.a=12},
fg(a){var s,r,q,p,o,n,m,l=this
l.as=0
s=l.x
l.as=1
r=l.y
r===$&&A.c("_table")
if(!(a<4096))return A.a(r,a)
q=r[a]
s.$flags&2&&A.b(s)
s[0]=q
q=l.z
q===$&&A.c("_prefix")
p=q[a]
for(o=1;p!==4098;o=n){n=o+1
l.as=n
if(!(p>=0&&p<4096))return A.a(r,p)
m=r[p]
if(!(o<4096))return A.a(s,o)
s[o]=m
p=q[p]}},
dY(){var s,r,q,p,o=this,n=o.b,m=o.f
m===$&&A.c("_dataLength")
if(n>=m)return 257
for(;s=o.d,r=o.a,s<r;n=p){if(n>=m)return 257
r=o.c
q=o.e
q===$&&A.c("_data")
p=n+1
o.b=p
if(!(n>=0&&n<q.length))return A.a(q,n)
o.c=(r<<8>>>0)+q[n]>>>0
o.d=s+8}n=s-r
o.d=n
n=B.a.a2(o.c,n)
r-=9
if(!(r>=0&&r<4))return A.a(B.bv,r)
return n&B.bv[r]},
fj(){var s,r,q=this
q.y=new Uint8Array(4096)
s=new Uint32Array(4096)
q.z=s
B.o.ac(s,0,4096,4098)
for(s=q.y,r=0;r<256;++r){s.$flags&2&&A.b(s)
s[r]=r}q.a=9
q.Q=258}}
A.jR.prototype={
aq(a){var s,r,q=this.a
if(q==null)return null
q=q.f
if(!(a<q.length))return A.a(q,a)
q=q[a]
s=this.c
s===$&&A.c("_input")
r=q.c5(s)
return r},
b9(a,b){var s,r,q,p=this,o=null,n=A.w(a,!1,o,0)
p.c=n
n=p.a=p.fz(n)
if(n==null)return o
s=n.f.length
r=p.aq(0)
if(r==null)return o
r.e=A.lP(A.w(a,!1,o,0))
r.w=B.bd
for(q=1;q<s;++q)r.aN(p.aq(q))
return r},
fz(a){var s,r,q,p,o,n,m,l,k,j,i=null,h=A.j([],t.fZ),g=new A.hZ(h),f=a.q()
if(f!==18761&&f!==19789)return i
if(f===19789)a.e=!0
else a.e=!1
q=a.q()
g.d=q
if(q!==42)return i
p=a.k()
o=A.p(a,i,0)
o.d=p
s=o
for(q=t.p,n=t.e8;p!==0;){r=null
try{m=new A.hY(A.I(q,n),B.b0,B.aY,B.lz)
m.im(s)
r=m
l=r
if(!(l.b!==0&&l.c!==0))break}catch(k){break}B.c.C(h,r)
l=h.length
if(l===1){if(0>=l)return A.a(h,0)
j=h[0]
g.a=j.b
if(0>=l)return A.a(h,0)
g.b=j.c}p=s.k()
if(p!==0)s.d=p}return h.length!==0?g:i}}
A.jS.prototype={
bI(a){var s,r,q,p,o,n,m,l,k,j,i,h,g="ifd0",f=A.Y(!1,8192),e=new A.by(A.I(t.N,t.P))
if(a.e!=null)e.l(0,g).hf(a.gbp().l(0,g))
if(a.gb2())a=a.aS(B.e)
if(a.gal()===1)s=1
else s=a.gaP()?3:2
r=a.gal()
q=e.l(0,g)
q.h(0,"ImageWidth",a.gS())
q.h(0,"ImageHeight",a.gK())
q.h(0,"BitsPerSample",a.gaO())
q.h(0,"SampleFormat",this.jG(a).a)
q.h(0,"SamplesPerPixel",a.gaP()?1:r)
q.h(0,"Compression",1)
q.h(0,"PhotometricInterpretation",s)
q.h(0,"RowsPerStrip",a.gK())
q.h(0,"PlanarConfiguration",1)
q.h(0,"TileWidth",a.gS())
q.h(0,"TileLength",a.gK())
q.h(0,"StripByteCounts",a.gd_(0))
q.h(0,"StripOffsets",new A.bZ(new Uint8Array(A.q(a.a4()))))
if(a.gaP()){p=a.a
o=p==null?null:p.gO()
n=o.a
p=n*3
m=new Uint16Array(p)
for(l=0,k=0;l<3;++l)for(j=0;j<n;++j,k=i){i=k+1
h=B.b.i(o.aX(j,l))
if(!(k>=0&&k<p))return A.a(m,k)
m[k]=h<<8>>>0}q.h(0,"ColorMap",m)}e.aV(f)
return J.B(B.d.gB(f.c),0,f.a)},
jG(a){var s=a.a
s=s==null?null:s.gbr()
switch((s==null?B.P:s).a){case 0:return B.aY
case 1:return B.i
case 2:return B.a1}}}
A.jX.prototype={
cX(){var s,r=this.a,q=r.bu()
if((q&1)!==0)return!1
if((q>>>1&7)>3)return!1
if((q>>>4&1)===0)return!1
this.f.d=q>>>5
if(r.bu()!==2752925)return!1
s=this.b
s.a=r.q()
s.b=r.q()
return!0},
bT(){var s,r,q,p,o=this,n=null
if(!o.jE())return n
s=o.b
r=s.a
o.d=A.Q(n,n,B.e,0,B.j,s.b,n,0,4,n,B.e,r,!1)
o.jM()
if(!o.k_())return n
r=s.w
if(r.length!==0){q=A.w(new A.af(r),!1,n,0)
r=o.d
r.toString
r.e=A.lP(q)}p=s.r
if(p!=null)o.d.c=new A.bB("",B.S,p)
return o.d},
jE(){var s,r,q,p,o=this
if(!o.cX())return!1
o.fr=A.rd()
for(s=o.dy,r=0;r<4;++r){q=new Int32Array(2)
p=new Int32Array(2)
B.c.h(s,r,new A.i8(q,p,new Int32Array(2)))}o.y=o.Q=0
s=o.b
q=s.a
o.z=q
s=s.b
o.as=s
o.at=q+15>>>4
o.ax=s+15>>>4
o.k1=0
s=o.a
q=o.f
p=q.d
p===$&&A.c("partitionLength")
p=A.nQ(s.aA(p))
o.c=p
s.d+=q.d
p.a3(1)
o.c.a3(1)
o.k9(o.x,o.fr)
o.jZ()
if(!o.k5(s))return!1
o.k7()
o.c.a3(1)
o.k6()
return!0},
k9(a,b){var s,r,q,p=this,o=p.c
o===$&&A.c("br")
o=o.a3(1)!==0
a.a=o
if(o){a.b=p.c.a3(1)!==0
if(p.c.a3(1)!==0){a.c=p.c.a3(1)!==0
for(o=a.d,s=0;s<4;++s){if(p.c.a3(1)!==0){r=p.c
q=r.a3(7)
r=r.a3(1)===1?-q:q}else r=0
o.$flags&2&&A.b(o)
o[s]=r}for(o=a.e,s=0;s<4;++s){if(p.c.a3(1)!==0){r=p.c
q=r.a3(6)
r=r.a3(1)===1?-q:q}else r=0
o.$flags&2&&A.b(o)
o[s]=r}}if(a.b)for(s=0;s<3;++s){o=b.a
r=p.c.a3(1)!==0?p.c.a3(8):255
o.$flags&2&&A.b(o)
o[s]=r}}else a.b=!1
return!0},
jZ(){var s,r,q,p=this,o=p.w,n=p.c
n===$&&A.c("br")
o.a=n.a3(1)!==0
o.b=p.c.a3(6)
o.c=p.c.a3(3)
n=p.c.a3(1)!==0
o.d=n
if(n)if(p.c.a3(1)!==0){for(n=o.e,s=0;s<4;++s)if(p.c.a3(1)!==0){r=p.c
q=r.a3(6)
r=r.a3(1)===1?-q:q
n.$flags&2&&A.b(n)
n[s]=r}for(n=o.f,s=0;s<4;++s)if(p.c.a3(1)!==0){r=p.c
q=r.a3(6)
r=r.a3(1)===1?-q:q
n.$flags&2&&A.b(n)
n[s]=r}}if(o.b===0)n=0
else n=o.a?1:2
p.aT=n
return!0},
k5(a){var s,r,q,p,o,n,m,l=a.c-a.d,k=this.c
k===$&&A.c("br")
k=B.a.R(1,k.a3(2))
this.cy=k
s=k-1
r=s*3
if(l<r)return!1
for(k=this.db,q=0,p=0;p<s;++p,r=n){o=a.d8(3,q)
n=r+((J.d(o.a,o.d)|J.d(o.a,o.d+1)<<8|J.d(o.a,o.d+2)<<16)>>>0)
if(n>l)n=l
m=new A.eZ(a.cb(n-r,r))
m.b=254
m.c=0
m.d=-8
B.c.h(k,p,m)
q+=3}B.c.h(k,s,A.nQ(a.cb(l-r,a.d-a.b+r)))
return r<l},
k7(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.c
e===$&&A.c("br")
s=e.a3(7)
r=f.c.a3(1)!==0?f.c.cD(4):0
q=f.c.a3(1)!==0?f.c.cD(4):0
p=f.c.a3(1)!==0?f.c.cD(4):0
o=f.c.a3(1)!==0?f.c.cD(4):0
n=f.c.a3(1)!==0?f.c.cD(4):0
m=f.x
for(e=f.dy,l=m.d,k=0;k<4;++k){if(m.a){j=l[k]
if(!m.c)j+=s}else{if(k>0){i=e[0]
if(!(k>=0&&k<4))return A.a(e,k)
e[k]=i
continue}j=s}h=e[k]
i=h.a
g=j+r
if(g<0)g=0
else if(g>127)g=127
g=B.aQ[g]
i.$flags&2&&A.b(i)
i[0]=g
if(j<0)g=0
else g=j>127?127:j
i[1]=B.aR[g]
g=h.b
i=j+q
if(i<0)i=0
else if(i>127)i=127
i=B.aQ[i]
g.$flags&2&&A.b(g)
g[0]=i*2
i=j+p
if(i<0)i=0
else if(i>127)i=127
g[1]=B.aR[i]*101581>>>16
if(g[1]<8)g[1]=8
i=h.c
g=j+o
if(g<0)g=0
else if(g>117)g=117
g=B.aQ[g]
i.$flags&2&&A.b(i)
i[0]=g
g=j+n
if(g<0)g=0
else if(g>127)g=127
i[1]=B.aR[g]}},
k6(){var s,r,q,p,o,n,m=this,l=m.fr
for(s=0;s<4;++s)for(r=0;r<8;++r)for(q=0;q<3;++q)for(p=0;p<11;++p){o=m.c
o===$&&A.c("br")
n=o.af(B.jS[s][r][q][p])!==0?m.c.a3(8):B.ep[s][r][q][p]
o=l.b
if(!(s<o.length))return A.a(o,s)
o=o[s]
if(!(r<o.length))return A.a(o,r)
o=o[r].a
if(!(q<o.length))return A.a(o,q)
o=o[q]
o.$flags&2&&A.b(o)
o[p]=n}o=m.c
o===$&&A.c("br")
o=o.a3(1)!==0
m.fx=o
if(o)m.fy=m.c.a3(8)},
kb(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.aT
f.toString
if(f>0){s=g.w
for(f=s.e,r=s.f,q=g.x,p=q.e,o=0;o<4;++o){if(q.a){n=p[o]
if(!q.c){m=s.b
m.toString
n+=m}}else n=s.b
for(l=0;l<=1;++l){m=g.bK
m===$&&A.c("_fStrengths")
if(!(o<m.length))return A.a(m,o)
k=m[o][l]
m=s.d
m===$&&A.c("useLfDelta")
if(m){n.toString
j=n+f[0]
if(l!==0)j+=r[0]}else j=n
j.toString
if(j<0)j=0
else if(j>63)j=63
if(j>0){m=s.c
m===$&&A.c("sharpness")
if(m>0){i=m>4?B.a.j(j,2):B.a.j(j,1)
h=9-m
if(i>h)i=h}else i=j
if(i<1)i=1
k.b=i
k.a=2*j+i
if(j>=40)m=2
else m=j>=15?1:0
k.d=m}else k.a=0
k.c=l!==0}}}},
jM(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=h.b,e=f.at
if(e!=null)h.bU=e
s=J.a8(4,t.jz)
for(e=t.by,r=0;r<4;++r)s[r]=A.j([new A.bM(),new A.bM()],e)
h.bK=t.mL.a(s)
e=h.at
e.toString
s=J.a8(e,t.ij)
for(q=0;q<e;++q){p=new Uint8Array(16)
o=new Uint8Array(8)
s[q]=new A.f5(p,o,new Uint8Array(8))}h.k2=t.f4.a(s)
h.ok=new Uint8Array(832)
e=h.at
e.toString
h.go=new Uint8Array(4*e)
p=h.p4=16*e
o=h.R8=8*e
n=h.aT
n.toString
if(!(n<3))return A.a(B.af,n)
m=B.af[n]
l=m*p
k=(m/2|0)*o
h.p1=A.w(new Uint8Array(16*p+l),!1,g,l)
p=8*o+k
h.p2=A.w(new Uint8Array(p),!1,g,k)
h.p3=A.w(new Uint8Array(p),!1,g,k)
f=f.a
h.RG=A.w(new Uint8Array(f),!1,g,0)
j=f+1>>>1
h.rx=A.w(new Uint8Array(j),!1,g,0)
h.ry=A.w(new Uint8Array(j),!1,g,0)
if(n===2)h.ch=h.ay=0
else{f=B.a.W(h.y-m,16)
h.ay=f
p=B.a.W(h.Q-m,16)
h.ch=p
if(f<0)h.ay=0
if(p<0)h.ch=0}f=B.a.W(h.as+15+m,16)
h.cx=f
p=B.a.W(h.z+15+m,16)
h.CW=p
if(p>e)h.CW=e
p=h.ax
p.toString
if(f>p)h.cx=p
i=e+1
s=J.a8(i,t.f_)
for(q=0;q<i;++q)s[q]=new A.f3()
h.k3=t.jt.a(s)
f=h.at
f.toString
s=J.a8(f,t.h2)
for(q=0;q<f;++q){e=new Int16Array(384)
s[q]=new A.f4(e,new Uint8Array(16))}h.bJ=t.as.a(s)
f=h.at
f.toString
h.k4=t.kb.a(A.E(f,g,!1,t.fA))
h.kb()
A.qB()
h.e=new A.jY()
return!0},
k_(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d="isIntra4x4"
e.y2=0
s=e.id
r=e.x
q=e.db
p=0
for(;;){o=e.cx
o.toString
if(!(p<o))break
o=e.cy
o===$&&A.c("_numPartitions")
o=(p&o-1)>>>0
if(!(o>=0&&o<8))return A.a(q,o)
n=q[o]
for(;;){p=e.y1
o=e.at
o.toString
if(!(p<o))break
o=e.k3
o===$&&A.c("_mbInfo")
m=o.length
if(0>=m)return A.a(o,0)
l=o[0]
k=1+p
if(!(k<m))return A.a(o,k)
j=o[k]
k=e.bJ
k===$&&A.c("_mbData")
if(!(p<k.length))return A.a(k,p)
i=k[p]
if(r.b){p=e.c
p===$&&A.c("br")
p=p.af(e.fr.a[0])
o=e.c
m=e.fr
e.k1=p===0?o.af(m.a[1]):2+o.af(m.a[2])}p=e.fx
p===$&&A.c("_useSkipProba")
if(p){p=e.c
p===$&&A.c("br")
o=e.fy
o===$&&A.c("_skipP")
h=p.af(o)!==0}else h=!1
e.k0()
if(!h)h=e.k8(j,n)
else{l.a=j.a=0
p=i.b
p===$&&A.c(d)
if(!p)l.b=j.b=0
i.f=i.e=0}p=e.aT
p.toString
if(p>0){p=e.k4
p===$&&A.c("_fInfo")
o=e.y1
m=e.bK
m===$&&A.c("_fStrengths")
k=e.k1
k===$&&A.c("_segment")
if(!(k<m.length))return A.a(m,k)
k=m[k]
m=i.b
m===$&&A.c(d)
B.c.h(p,o,k[m?1:0])
p=e.k4
o=e.y1
if(!(o<p.length))return A.a(p,o)
g=p[o]
g.c=g.c||!h}++e.y1}p=e.k3
p===$&&A.c("_mbInfo")
if(0>=p.length)return A.a(p,0)
p=p[0]
p.b=p.a=0
B.d.ac(s,0,4,0)
e.y1=0
e.kF()
p=e.aT
p.toString
f=!1
if(p>0){p=e.y2
o=e.ch
o===$&&A.c("_tlMbY")
if(p>=o){o=e.cx
o.toString
o=p<=o
f=o}}if(!e.jz(f))return!1
p=++e.y2}return!0},
kF(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null,a6="_dsp",a7=a4.y2,a8=a4.ok
a8===$&&A.c("_yuvBlock")
s=A.w(a8,!1,a5,40)
r=A.w(a8,!1,a5,584)
q=A.w(a8,!1,a5,600)
a8=a7>0
p=0
for(;;){o=a4.at
o.toString
if(!(p<o))break
o=a4.bJ
o===$&&A.c("_mbData")
if(!(p<o.length))return A.a(o,p)
n=o[p]
if(p>0){for(m=-1;m<16;++m){o=m*32
s.bs(o-4,4,s,o+12)}for(m=-1;m<8;++m){o=m*32
l=o-4
o+=4
r.bs(l,4,r,o)
q.bs(l,4,q,o)}}else{for(m=0;m<16;++m)J.y(s.a,s.d+(m*32-1),129)
for(m=0;m<8;++m){o=m*32-1
J.y(r.a,r.d+o,129)
J.y(q.a,q.d+o,129)}if(a8){J.y(q.a,q.d+-33,129)
J.y(r.a,r.d+-33,129)
J.y(s.a,s.d+-33,129)}}o=a4.k2
o===$&&A.c("_yuvT")
if(!(p<o.length))return A.a(o,p)
k=o[p]
j=n.a
i=n.e
if(a8){s.c8(-32,16,k.a)
r.c8(-32,8,k.b)
q.c8(-32,8,k.c)}else if(p===0){o=s.a
l=s.d+-33
J.bu(o,l,l+21,127)
l=r.a
o=r.d+-33
J.bu(l,o,o+9,127)
o=q.a
l=q.d+-33
J.bu(o,l,l+9,127)}o=n.b
o===$&&A.c("isIntra4x4")
if(o){h=A.p(s,a5,-16)
g=h.d4()
if(a8){o=a4.at
o.toString
if(p>=o-1){o=k.a[15]
l=h.a
f=h.d
J.bu(l,f,f+4,o)}else{o=a4.k2
l=p+1
if(!(l<o.length))return A.a(o,l)
h.c8(0,4,o[l].a)}}o=g.length
if(0>=o)return A.a(g,0)
e=g[0]
g.$flags&2&&A.b(g)
if(96>=o)return A.a(g,96)
g[96]=e
g[64]=e
g[32]=e
for(o=n.c,d=0;d<16;++d,i=i<<2>>>0){c=A.p(s,a5,B.cb[d])
l=o[d]
if(!(l<10))return A.a(B.bY,l)
B.bY[l].$1(c)
i.toString
l=d*16
a4.f4(i,new A.ad(j,l,Math.min(384,384),l,!1),c)}}else{o=A.nS(p,a7,n.c[0])
o.toString
if(!(o<7))return A.a(B.ca,o)
B.ca[o].$1(s)
if(i!==0)for(d=0;d<16;++d,i=i<<2>>>0){c=A.p(s,a5,B.cb[d])
i.toString
o=d*16
a4.f4(i,new A.ad(j,o,Math.min(384,384),o,!1),c)}}o=n.f
o===$&&A.c("nonZeroUV")
l=A.nS(p,a7,n.d)
l.toString
if(!(l<7))return A.a(B.aT,l)
B.aT[l].$1(r)
B.aT[l].$1(q)
l=Math.min(384,384)
b=new A.ad(j,256,l,256,!1)
if((o&255)!==0){f=a4.e
if((o&170)!==0){f===$&&A.c(a6)
f.bO(b,r)
f.bO(A.p(b,a5,16),A.p(r,a5,4))
a=A.p(b,a5,32)
a0=A.p(r,a5,128)
f.bO(a,a0)
f.bO(A.p(a,a5,16),A.p(a0,a5,4))}else{f===$&&A.c(a6)
f.hD(b,r)}}a1=new A.ad(j,320,l,320,!1)
o=o>>>8
if((o&255)!==0){l=a4.e
if((o&170)!==0){l===$&&A.c(a6)
l.bO(a1,q)
l.bO(A.p(a1,a5,16),A.p(q,a5,4))
o=A.p(a1,a5,32)
f=A.p(q,a5,128)
l.bO(o,f)
l.bO(A.p(o,a5,16),A.p(f,a5,4))}else{l===$&&A.c(a6)
l.hD(a1,q)}}o=a4.ax
o.toString
if(a7<o-1){B.d.ar(k.a,0,16,s.a4(),480)
B.d.ar(k.b,0,8,r.a4(),224)
B.d.ar(k.c,0,8,q.a4(),224)}a2=p*16
a3=p*8
for(m=0;m<16;++m){o=a4.p4
o.toString
l=a4.p1
l===$&&A.c("_cacheY")
l.bs(a2+m*o,16,s,m*32)}for(m=0;m<8;++m){o=a4.R8
o.toString
l=a4.p2
l===$&&A.c("_cacheU")
f=m*32
l.bs(a3+m*o,8,r,f)
o=a4.R8
o.toString
l=a4.p3
l===$&&A.c("_cacheV")
l.bs(a3+m*o,8,q,f)}++p}},
f4(a,b,c){var s,r,q,p,o,n,m="_dsp"
switch(a>>>30){case 3:s=this.e
s===$&&A.c(m)
s.lQ(b,c,!1)
break
case 2:this.e===$&&A.c(m)
r=J.d(b.a,b.d)+4
q=B.a.aG(B.a.j(J.d(b.a,b.d+4)*35468,16),32)
p=B.a.aG(B.a.j(J.d(b.a,b.d+4)*85627,16),32)
o=B.a.aG(B.a.j(J.d(b.a,b.d+1)*35468,16),32)
n=B.a.aG(B.a.j(J.d(b.a,b.d+1)*85627,16),32)
A.k_(c,0,r+p,n,o)
A.k_(c,1,r+q,n,o)
A.k_(c,2,r-q,n,o)
A.k_(c,3,r-p,n,o)
break
case 1:s=this.e
s===$&&A.c(m)
s.d5(b,c)
break
default:break}},
ji(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f="_dsp",e=h.p4,d=h.k4
d===$&&A.c("_fInfo")
if(!(a>=0&&a<d.length))return A.a(d,a)
d=d[a]
d.toString
s=h.p1
s===$&&A.c("_cacheY")
r=A.p(s,g,a*16)
q=d.b
p=d.a
if(p===0)return
if(h.aT===1){if(a>0){s=h.e
s===$&&A.c(f)
e.toString
s.es(r,e,p+4)}if(d.c){s=h.e
s===$&&A.c(f)
e.toString
s.hW(r,e,p)}if(b>0){s=h.e
s===$&&A.c(f)
e.toString
s.eu(r,e,p+4)}if(d.c){d=h.e
d===$&&A.c(f)
e.toString
d.hX(r,e,p)}}else{o=h.R8
s=h.p2
s===$&&A.c("_cacheU")
n=a*8
m=A.p(s,g,n)
s=h.p3
s===$&&A.c("_cacheV")
l=A.p(s,g,n)
k=d.d
if(a>0){s=h.e
s===$&&A.c(f)
e.toString
n=p+4
s.ct(r,1,e,16,n,q,k)
o.toString
s.ct(m,1,o,8,n,q,k)
s.ct(l,1,o,8,n,q,k)}if(d.c){s=h.e
s===$&&A.c(f)
e.toString
s.ll(r,e,p,q,k)
o.toString
j=A.p(m,g,4)
i=A.p(l,g,4)
s.cs(j,1,o,8,p,q,k)
s.cs(i,1,o,8,p,q,k)}if(b>0){s=h.e
s===$&&A.c(f)
e.toString
n=p+4
s.ct(r,e,1,16,n,q,k)
o.toString
s.ct(m,o,1,8,n,q,k)
s.ct(l,o,1,8,n,q,k)}if(d.c){d=h.e
d===$&&A.c(f)
e.toString
d.lT(r,e,p,q,k)
o.toString
s=4*o
j=A.p(m,g,s)
i=A.p(l,g,s)
d.cs(j,o,1,8,p,q,k)
d.cs(i,o,1,8,p,q,k)}}},
jw(){var s,r=this,q=r.ay
q===$&&A.c("_tlMbX")
s=q
for(;;){q=r.CW
q.toString
if(!(s<q))break
r.ji(s,r.y2);++s}},
jz(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.aT
a1.toString
if(!(a1<3))return A.a(B.af,a1)
s=B.af[a1]
a1=a.p4
a1.toString
r=s*a1
a1=a.R8
a1.toString
q=(s/2|0)*a1
a1=a.p1
a1===$&&A.c("_cacheY")
p=-r
o=A.p(a1,a0,p)
a1=a.p2
a1===$&&A.c("_cacheU")
n=-q
m=A.p(a1,a0,n)
a1=a.p3
a1===$&&A.c("_cacheV")
l=A.p(a1,a0,n)
k=a.y2
a1=a.cx
a1.toString
j=k*16
i=(k+1)*16
if(a2)a.jw()
if(k!==0){j-=s
a.to=A.p(o,a0,0)
a.x1=A.p(m,a0,0)
a.x2=A.p(l,a0,0)}else{a.to=A.p(a.p1,a0,0)
a.x1=A.p(a.p2,a0,0)
a.x2=A.p(a.p3,a0,0)}a1=k<a1-1
if(a1)i-=s
h=a.as
if(i>h)i=h
a.xr=null
if(a.bU!=null&&j<i){g=a.xr=a.ja(j,i-j)
if(g==null)return!1}else g=a0
f=a.Q
if(j<f){e=f-j
d=a.to
d===$&&A.c("_y")
c=d.d
b=a.p4
b.toString
d.d=c+b*e
b=a.x1
b===$&&A.c("_u")
c=b.d
d=a.R8
d.toString
d*=B.a.j(e,1)
b.d=c+d
c=a.x2
c===$&&A.c("_v")
c.d+=d
if(g!=null)g.d=g.d+a.b.a*e
j=f}if(j<i){d=a.to
d===$&&A.c("_y")
c=d.d
b=a.y
d.d=c+b
c=a.x1
c===$&&A.c("_u")
d=b>>>1
c.d=c.d+d
c=a.x2
c===$&&A.c("_v")
c.d+=d
if(g!=null)g.d+=b
a.kg(j-f,a.z-b,i-j)}if(a1){a1=a.p1
g=a.p4
g.toString
a1.bs(p,r,o,16*g)
g=a.p2
p=a.R8
p.toString
g.bs(n,q,m,8*p)
p=a.p3
g=a.R8
g.toString
p.bs(n,q,l,8*g)}return!0},
kg(a,b,c){if(b<=0||c<=0)return!1
this.jk(a,b,c)
this.jj(a,b,c)
return!0},
dL(a){var s
if((a&-4194304)>>>0===0)s=B.a.j(a,14)
else s=a<0?0:255
return s},
dv(a,b,c,d){var s=19077*a
d.h(0,0,this.dL(s+26149*c+-3644112))
d.h(0,1,this.dL(s-6419*b-13320*c+2229552))
d.h(0,2,this.dL(s+33050*b+-4527440))},
du(a7,a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=new A.kg(),a2=b5-1,a3=B.a.j(a2,1),a4=a1.$2(J.d(a9.a,a9.d),J.d(b0.a,b0.d)),a5=a1.$2(J.d(b1.a,b1.d),J.d(b2.a,b2.d)),a6=B.a.j(3*a4+a5+131074,2)
a.dv(J.d(a7.a,a7.d),a6&255,a6>>>16,b3)
b3.h(0,3,255)
s=a8!=null
if(s){a6=B.a.j(3*a5+a4+131074,2)
r=J.d(a8.a,a8.d)
b4.toString
a.dv(r,a6&255,a6>>>16,b4)
b4.h(0,3,255)}for(q=1;q<=a3;++q,a5=o,a4=p){p=a1.$2(J.d(a9.a,a9.d+q),J.d(b0.a,b0.d+q))
o=a1.$2(J.d(b1.a,b1.d+q),J.d(b2.a,b2.d+q))
n=a4+p+a5+o+524296
m=B.a.j(n+2*(p+a5),3)
l=B.a.j(n+2*(a4+o),3)
a6=B.a.j(m+a4,1)
k=B.a.j(l+p,1)
r=2*q
j=r-1
i=J.d(a7.a,a7.d+j)
h=a6&255
g=a6>>>16
f=j*4
e=A.p(b3,a0,f)
i=19077*i
d=i+26149*g+-3644112
if((d&-4194304)>>>0===0)c=B.a.j(d,14)
else c=d<0?0:255
J.y(e.a,e.d,c)
g=i-6419*h-13320*g+2229552
if((g&-4194304)>>>0===0)c=B.a.j(g,14)
else c=g<0?0:255
J.y(e.a,e.d+1,c)
i=i+33050*h+-4527440
if((i&-4194304)>>>0===0)c=B.a.j(i,14)
else c=i<0?0:255
J.y(e.a,e.d+2,c)
J.y(e.a,e.d+3,255)
i=J.d(a7.a,a7.d+r)
h=k&255
g=k>>>16
e=r*4
d=A.p(b3,a0,e)
i=19077*i
b=i+26149*g+-3644112
if((b&-4194304)>>>0===0)c=B.a.j(b,14)
else c=b<0?0:255
J.y(d.a,d.d,c)
g=i-6419*h-13320*g+2229552
if((g&-4194304)>>>0===0)c=B.a.j(g,14)
else c=g<0?0:255
J.y(d.a,d.d+1,c)
i=i+33050*h+-4527440
if((i&-4194304)>>>0===0)c=B.a.j(i,14)
else c=i<0?0:255
J.y(d.a,d.d+2,c)
J.y(d.a,d.d+3,255)
if(s){a6=B.a.j(l+a5,1)
k=B.a.j(m+o,1)
j=J.d(a8.a,a8.d+j)
i=a6&255
h=a6>>>16
b4.toString
f=A.p(b4,a0,f)
j=19077*j
g=j+26149*h+-3644112
if((g&-4194304)>>>0===0)c=B.a.j(g,14)
else c=g<0?0:255
J.y(f.a,f.d,c)
h=j-6419*i-13320*h+2229552
if((h&-4194304)>>>0===0)c=B.a.j(h,14)
else c=h<0?0:255
J.y(f.a,f.d+1,c)
j=j+33050*i+-4527440
if((j&-4194304)>>>0===0)c=B.a.j(j,14)
else c=j<0?0:255
J.y(f.a,f.d+2,c)
J.y(f.a,f.d+3,255)
r=J.d(a8.a,a8.d+r)
j=k&255
i=k>>>16
e=A.p(b4,a0,e)
r=19077*r
h=r+26149*i+-3644112
if((h&-4194304)>>>0===0)c=B.a.j(h,14)
else c=h<0?0:255
J.y(e.a,e.d,c)
i=r-6419*j-13320*i+2229552
if((i&-4194304)>>>0===0)c=B.a.j(i,14)
else c=i<0?0:255
J.y(e.a,e.d+1,c)
r=r+33050*j+-4527440
if((r&-4194304)>>>0===0)c=B.a.j(r,14)
else c=r<0?0:255
J.y(e.a,e.d+2,c)
J.y(e.a,e.d+3,255)}}if((b5&1)===0){a6=B.a.j(3*a4+a5+131074,2)
r=J.d(a7.a,a7.d+a2)
j=a2*4
i=A.p(b3,a0,j)
a.dv(r,a6&255,a6>>>16,i)
i.h(0,3,255)
if(s){a6=B.a.j(3*a5+a4+131074,2)
a2=J.d(a8.a,a8.d+a2)
b4.toString
j=A.p(b4,a0,j)
a.dv(a2,a6&255,a6>>>16,j)
j.h(0,3,255)}}},
jj(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.xr
if(j==null)return
s=A.p(j,null,0)
if(a===0){r=c-1
q=a}else{q=a-1
s.d=s.d-k.b.a
r=c}j=k.Q
p=k.as
if(j+a+c===p)r=p-j-q
for(j=k.b,o=0;o<r;++o){for(p=o+q,n=0;n<b;++n){m=J.d(s.a,s.d+n)
l=k.d.a
l=l==null?null:l.P(n,p,null);(l==null?new A.F():l).sv(m)}s.d=s.d+j.a}},
jk(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=J.B(g.d.gB(0),0,null),d=g.b.a,c=A.w(e,!1,f,a*d*4),b=g.to
b===$&&A.c("_y")
s=A.p(b,f,0)
b=g.x1
b===$&&A.c("_u")
r=A.p(b,f,0)
b=g.x2
b===$&&A.c("_v")
q=A.p(b,f,0)
p=a+a1
o=B.a.j(a0+1,1)
n=d*4
d=g.rx
d===$&&A.c("_tmpU")
m=A.p(d,f,0)
d=g.ry
d===$&&A.c("_tmpV")
l=A.p(d,f,0)
if(a===0){g.du(s,f,r,q,r,q,c,f,a0)
k=a1}else{d=g.RG
d===$&&A.c("_tmpY")
g.du(d,s,m,l,r,q,A.p(c,f,-n),c,a0)
k=a1+1}m.sB(0,r.a)
l.sB(0,q.a)
for(d=2*n,b=-n,j=a;j+=2,j<p;){m.d=r.d
l.d=q.d
i=r.d
h=g.R8
h.toString
r.d=i+h
q.d+=h
c.d+=d
h=s.d
i=g.p4
i.toString
s.d=h+2*i
g.du(A.p(s,f,-i),s,m,l,r,q,A.p(c,f,b),c,a0)}d=s.d
b=g.p4
b.toString
s.d=d+b
if(g.Q+p<g.as){d=g.RG
d===$&&A.c("_tmpY")
d.c8(0,a0,s)
g.rx.c8(0,o,r)
g.ry.c8(0,o,q);--k}else if((p&1)===0)g.du(s,f,r,q,r,q,A.p(c,f,n),f,a0)
return k},
ja(a,b){var s,r,q,p,o,n,m,l,k,j=this,i="_alphaPlane",h=j.b,g=h.a,f=h.b
if(a<0||b<=0||a+b>f)return null
if(a===0){h=g*f
j.aY=new Uint8Array(h)
s=j.bU
r=new A.kh(s,g,f)
q=s.I()
p=r.d=q&3
r.e=B.a.j(q,2)&3
r.f=B.a.j(q,4)&3
r.r=B.a.j(q,6)&3
if(r.ghs())if(p===0){if(s.c-s.d<h)r.r=1}else if(p===1){o=new A.dF(B.a9,A.j([],t.J))
o.a=g
o.b=f
h=A.j([],t.nK)
p=A.j([],t.ip)
n=new Uint32Array(2)
m=new A.i4(s,n)
n=m.e=J.B(B.o.gB(n),0,null)
l=s.I()
n.$flags&2&&A.b(n)
if(0>=n.length)return A.a(n,0)
n[0]=l
l=s.I()
n.$flags&2&&A.b(n)
if(1>=n.length)return A.a(n,1)
n[1]=l
l=s.I()
n.$flags&2&&A.b(n)
if(2>=n.length)return A.a(n,2)
n[2]=l
l=s.I()
n.$flags&2&&A.b(n)
if(3>=n.length)return A.a(n,3)
n[3]=l
l=s.I()
n.$flags&2&&A.b(n)
if(4>=n.length)return A.a(n,4)
n[4]=l
l=s.I()
n.$flags&2&&A.b(n)
if(5>=n.length)return A.a(n,5)
n[5]=l
l=s.I()
n.$flags&2&&A.b(n)
if(6>=n.length)return A.a(n,6)
n[6]=l
s=s.I()
n.$flags&2&&A.b(n)
if(7>=n.length)return A.a(n,7)
n[7]=s
m.b=!1
p=new A.hi(m,o,h,p)
p.dy=g
p.fr=f
r.x=p
p.cG(g,f,!0)
h=r.x
s=h.ch
p=s.length
if(p===1){if(0>=p)return A.a(s,0)
h=s[0].a===B.cB&&h.jR()}else h=!1
if(h){r.y=!0
h=r.x
s=h.c
k=s.a*s.b
h.db=0
s=B.a.a8(k,4)
s=new Uint8Array(k+(4-s))
h.cy=s
h.cx=J.Z(B.d.gB(s),0,null)}else{r.y=!1
r.x.eH(g)}}else r.r=1
j.cn=r}h=j.cn
if(h!=null)if(!h.w){s=j.aY
s===$&&A.c(i)
if(!h.l5(a,b,s))return null}h=j.aY
h===$&&A.c(i)
return A.w(h,!1,null,a*g)},
k8(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=a2.fr.b,a4=a2.dy,a5=a2.k1
a5===$&&A.c("_segment")
if(!(a5<4))return A.a(a4,a5)
s=a4[a5]
a5=a2.bJ
a5===$&&A.c("_mbData")
a4=a2.y1
if(!(a4<a5.length))return A.a(a5,a4)
r=a5[a4]
q=A.w(r.a,!1,null,0)
a4=a2.k3
a4===$&&A.c("_mbInfo")
if(0>=a4.length)return A.a(a4,0)
p=a4[0]
q.ly(0,q.c-q.d,0)
a4=r.b
a4===$&&A.c("isIntra4x4")
if(!a4){o=A.w(new Int16Array(16),!1,null,0)
a4=a6.b
a5=p.b
if(1>=a3.length)return A.a(a3,1)
n=a2.dX(a7,a3[1],a4+a5,s.b,0,o)
a6.b=p.b=n>0?1:0
if(n>1)a2.kP(o,q)
else{m=B.a.j(J.d(o.a,o.d)+3,3)
for(l=0;l<256;l+=16)J.y(q.a,q.d+l,m)}k=a3[0]
j=1}else{if(3>=a3.length)return A.a(a3,3)
k=a3[3]
j=0}i=a6.a&15
h=p.a&15
for(g=0,f=0;f<4;++f){e=h&1
for(d=0,c=0;c<4;++c){n=a2.dX(a7,k,e+(i&1),s.a,j,q)
e=n>j?1:0
i=i>>>1|e<<7
a4=J.d(q.a,q.d)!==0?1:0
if(n>3)a4=3
else if(n>1)a4=2
d=d<<2|a4
q.d+=16}i=i>>>4
h=h>>>1|e<<7
g=(g<<8|d)>>>0}b=h>>>4
for(a4=a3.length,a=i,a0=0,a1=0;a1<4;a1+=2){a5=4+a1
i=B.a.a0(a6.a,a5)
h=B.a.a0(p.a,a5)
for(d=0,f=0;f<2;++f){e=h&1
for(c=0;c<2;++c){if(2>=a4)return A.a(a3,2)
n=a2.dX(a7,a3[2],e+(i&1),s.c,0,q)
e=n>0?1:0
i=i>>>1|e<<3
a5=J.d(q.a,q.d)!==0?1:0
if(n>3)a5=3
else if(n>1)a5=2
d=(d<<2|a5)>>>0
q.d+=16}i=i>>>2
h=h>>>1|e<<5}a0=(a0|B.a.R(d,4*a1))>>>0
a=(a|B.a.R(i<<4>>>0,a1))>>>0
b=(b|B.a.R(h&240,a1))>>>0}a6.a=a
p.a=b
r.e=g
r.f=a0
if((a0&43690)===0)s.toString
return(g|a0)>>>0===0},
kP(a,b){var s,r,q,p,o,n,m,l,k,j,i=new Int32Array(16)
for(s=0;s<4;++s){r=12+s
q=J.d(a.a,a.d+s)+J.d(a.a,a.d+r)
p=4+s
o=8+s
n=J.d(a.a,a.d+p)+J.d(a.a,a.d+o)
m=J.d(a.a,a.d+p)-J.d(a.a,a.d+o)
l=J.d(a.a,a.d+s)-J.d(a.a,a.d+r)
if(!(s<16))return A.a(i,s)
i[s]=q+n
if(!(o<16))return A.a(i,o)
i[o]=q-n
i[p]=l+m
if(!(r<16))return A.a(i,r)
i[r]=l-m}for(k=0,s=0;s<4;++s){r=s*4
if(!(r<16))return A.a(i,r)
j=i[r]+3
p=3+r
if(!(p<16))return A.a(i,p)
p=i[p]
q=j+p
o=1+r
if(!(o<16))return A.a(i,o)
o=i[o]
r=2+r
if(!(r<16))return A.a(i,r)
r=i[r]
n=o+r
m=o-r
l=j-p
p=B.a.j(q+n,3)
J.y(b.a,b.d+k,p)
p=B.a.j(l+m,3)
J.y(b.a,b.d+(k+16),p)
p=B.a.j(q-n,3)
J.y(b.a,b.d+(k+32),p)
p=B.a.j(l-m,3)
J.y(b.a,b.d+(k+48),p)
k+=64}},
jF(a,b){var s,r,q,p,o,n,m
t.L.a(b)
if(a.af(b[3])===0)s=a.af(b[4])===0?2:3+a.af(b[5])
else if(a.af(b[6])===0)s=a.af(b[7])===0?5+a.af(159):7+2*a.af(165)+a.af(145)
else{r=a.af(b[8])
q=9+r
if(!(q<11))return A.a(b,q)
p=2*r+a.af(b[q])
if(!(p<4))return A.a(B.bx,p)
o=B.bx[p]
n=o.length
for(s=0,m=0;m<n;++m)s+=s+a.af(o[m])
s+=3+B.a.R(8,p)}return s},
dX(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j
t.ac.a(b)
t.L.a(d)
s=b.length
if(!(e<s))return A.a(b,e)
r=b[e].a
if(!(c<r.length))return A.a(r,c)
q=r[c]
for(;e<16;e=p){if(a.af(q[0])===0)return e
while(a.af(q[1])===0){r=$.mV();++e
if(!(e>=0&&e<r.length))return A.a(r,e)
r=r[e]
if(!(r<s))return A.a(b,r)
r=b[r].a
if(0>=r.length)return A.a(r,0)
q=r[0]
if(e===16)return 16}r=$.mV()
p=e+1
if(!(p>=0&&p<r.length))return A.a(r,p)
r=r[p]
if(!(r<s))return A.a(b,r)
o=b[r].a
r=o.length
if(a.af(q[2])===0){if(1>=r)return A.a(o,1)
q=o[1]
n=1}else{n=this.jF(a,q)
if(2>=r)return A.a(o,2)
q=o[2]}r=$.p9()
if(!(e>=0&&e<r.length))return A.a(r,e)
r=r[e]
m=a.b
m===$&&A.c("_range")
l=a.eL(B.a.j(m,1))
m=a.b
if(m>>>0!==m||m>=128)return A.a(B.aq,m)
k=B.aq[m]
a.b=B.c0[m]
m=a.d
m===$&&A.c("_bits")
a.d=m-k
m=l!==0?-n:n
j=d[e>0?1:0]
J.y(f.a,f.d+r,m*j)}return 16},
k0(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.y1,g=4*h,f=i.go,e=i.id,d=i.bJ
d===$&&A.c("_mbData")
if(!(h<d.length))return A.a(d,h)
s=d[h]
h=i.c
h===$&&A.c("br")
h=h.af(145)===0
s.b=h
if(!h){if(i.c.af(156)!==0)r=i.c.af(128)!==0?1:3
else r=i.c.af(163)!==0?2:0
h=s.c
h.$flags&2&&A.b(h)
h[0]=r
f.toString
B.d.ac(f,g,g+4,r)
B.d.ac(e,0,4,r)}else{q=s.c
for(p=0,o=0;o<4;++o,p=j){r=e[o]
for(n=0;n<4;++n){h=g+n
if(!(h<f.length))return A.a(f,h)
d=f[h]
if(!(d<10))return A.a(B.bT,d)
d=B.bT[d]
if(!(r>=0&&r<10))return A.a(d,r)
m=d[r]
l=i.c.af(m[0])
if(!(l<18))return A.a(B.ao,l)
k=B.ao[l]
while(k>0){d=i.c
if(!(k<9))return A.a(m,k)
d=2*k+d.af(m[k])
if(!(d>=0&&d<18))return A.a(B.ao,d)
k=B.ao[d]}r=-k
f.$flags&2&&A.b(f)
f[h]=r}j=p+4
f.toString
B.d.ar(q,p,j,f,g)
e.$flags&2&&A.b(e)
if(!(o<4))return A.a(e,o)
e[o]=r}}if(i.c.af(142)===0)h=0
else if(i.c.af(114)===0)h=2
else h=i.c.af(183)!==0?1:3
s.d=h}}
A.kg.prototype={
$2(a,b){return(a|b<<16)>>>0},
$S:16}
A.eZ.prototype={
a3(a){var s,r
for(s=0;r=a-1,a>0;a=r)s=(s|B.a.V(this.af(128),r))>>>0
return s},
cD(a){var s=this.a3(a)
return this.a3(1)===1?-s:s},
af(a){var s,r=this,q=r.b
q===$&&A.c("_range")
s=r.eL(B.a.j(q*a,8))
if(r.b<=126)r.kL()
return s},
eL(a){var s,r,q,p,o,n=this,m="_value",l=n.d
l===$&&A.c("_bits")
if(l<0){s=n.a
r=s.c
q=s.d
if(r-q>=1){p=s.I()
l=n.c
l===$&&A.c(m)
n.c=(p|l<<8)>>>0
l=n.d+8
n.d=l
o=l}else{if(q<r){l=s.I()
s=n.c
s===$&&A.c(m)
n.c=(l|s<<8)>>>0
s=n.d+8
n.d=s
l=s}else if(!n.e){s=n.c
s===$&&A.c(m)
n.c=s<<8>>>0
l+=8
n.d=l
n.e=!0}o=l}}else o=l
l=n.c
l===$&&A.c(m)
if(B.a.aL(l,o)>a){s=n.b
s===$&&A.c("_range")
r=a+1
n.b=s-r
n.c=l-B.a.V(r,o)
return 1}else{n.b=a
return 0}},
kL(){var s,r=this,q=r.b
q===$&&A.c("_range")
if(!(q>=0&&q<128))return A.a(B.aq,q)
s=B.aq[q]
r.b=B.c0[q]
q=r.d
q===$&&A.c("_bits")
r.d=q-s}}
A.jY.prototype={
eu(a,b,c){var s,r=A.p(a,null,0)
for(s=0;s<16;++s){r.d=a.d+s
if(this.fq(r,b,c))this.dg(r,b)}},
es(a,b,c){var s,r=A.p(a,null,0)
for(s=0;s<16;++s){r.d=a.d+s*b
if(this.fq(r,1,c))this.dg(r,1)}},
hX(a,b,c){var s,r,q=A.p(a,null,0)
for(s=4*b,r=3;r>0;--r){q.d+=s
this.eu(q,b,c)}},
hW(a,b,c){var s,r=A.p(a,null,0)
for(s=3;s>0;--s){r.d+=4
this.es(r,b,c)}},
lT(a,b,c,d,e){var s,r,q=A.p(a,null,0)
for(s=4*b,r=3;r>0;--r){q.d+=s
this.cs(q,b,1,16,c,d,e)}},
ll(a,b,c,d,e){var s,r=A.p(a,null,0)
for(s=3;s>0;--s){r.d+=4
this.cs(r,1,b,16,c,d,e)}},
ct(a,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=A.p(a,null,0)
for(s=-3*a0,r=-2*a0,q=-a0,p=2*a0;o=a2-1,a2>0;a2=o){if(this.fs(b,a0,a3,a4))if(this.fh(b,a0,a5))this.dg(b,a0)
else{n=J.d(b.a,b.d+s)
m=J.d(b.a,b.d+r)
l=J.d(b.a,b.d+q)
k=J.d(b.a,b.d)
j=J.d(b.a,b.d+a0)
i=J.d(b.a,b.d+p)
h=$.lF()
g=1020+m-j
if(!(g>=0&&g<2041))return A.a(h,g)
g=1020+3*(k-l)+h[g]
if(!(g>=0&&g<2041))return A.a(h,g)
f=h[g]
g=B.a.j(27*f+63,7)
e=(g&2147483647)-((g&2147483648)>>>0)
g=B.a.j(18*f+63,7)
d=(g&2147483647)-((g&2147483648)>>>0)
g=B.a.j(9*f+63,7)
c=(g&2147483647)-((g&2147483648)>>>0)
g=$.aH()
h=255+n+c
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.y(b.a,b.d+s,h)
h=$.aH()
g=255+m+d
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.y(b.a,b.d+r,g)
g=$.aH()
h=255+l+e
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.y(b.a,b.d+q,h)
h=$.aH()
g=255+k-e
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.y(b.a,b.d,g)
g=$.aH()
h=255+j-d
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.y(b.a,b.d+a0,h)
h=$.aH()
g=255+i-c
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.y(b.a,b.d+p,g)}b.d+=a1}},
cs(a,b,c,d,e,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=A.p(a,null,0)
for(s=-2*b,r=-b;q=d-1,d>0;d=q){if(this.fs(f,b,e,a0))if(this.fh(f,b,a1))this.dg(f,b)
else{p=J.d(f.a,f.d+s)
o=J.d(f.a,f.d+r)
n=J.d(f.a,f.d)
m=J.d(f.a,f.d+b)
l=3*(n-o)
k=$.lG()
j=B.a.j(l+4,3)
j=112+((j&2147483647)-((j&2147483648)>>>0))
if(!(j>=0&&j<225))return A.a(k,j)
i=k[j]
j=B.a.j(l+3,3)
j=112+((j&2147483647)-((j&2147483648)>>>0))
if(!(j>=0&&j<225))return A.a(k,j)
h=k[j]
j=B.a.j(i+1,1)
g=(j&2147483647)-((j&2147483648)>>>0)
j=$.aH()
k=255+p+g
if(!(k>=0&&k<766))return A.a(j,k)
k=j[k]
J.y(f.a,f.d+s,k)
k=$.aH()
j=255+o+h
if(!(j>=0&&j<766))return A.a(k,j)
j=k[j]
J.y(f.a,f.d+r,j)
j=$.aH()
k=255+n-i
if(!(k>=0&&k<766))return A.a(j,k)
k=j[k]
J.y(f.a,f.d,k)
k=$.aH()
j=255+m-g
if(!(j>=0&&j<766))return A.a(k,j)
j=k[j]
J.y(f.a,f.d+b,j)}f.d+=c}},
dg(a,b){var s,r,q,p=J.d(a.a,a.d+-2*b),o=-b,n=J.d(a.a,a.d+o),m=J.d(a.a,a.d),l=J.d(a.a,a.d+b),k=$.lF(),j=1020+p-l
if(!(j>=0&&j<2041))return A.a(k,j)
s=3*(m-n)+k[j]
j=$.lG()
k=112+B.a.aG(B.a.j(s+4,3),32)
if(!(k>=0&&k<225))return A.a(j,k)
r=j[k]
k=112+B.a.aG(B.a.j(s+3,3),32)
if(!(k>=0&&k<225))return A.a(j,k)
q=j[k]
k=$.aH()
j=255+n+q
if(!(j>=0&&j<766))return A.a(k,j)
a.h(0,o,k[j])
j=$.aH()
k=255+m-r
if(!(k>=0&&k<766))return A.a(j,k)
a.h(0,0,j[k])},
fh(a,b,c){var s=J.d(a.a,a.d+-2*b),r=J.d(a.a,a.d+-b),q=J.d(a.a,a.d),p=J.d(a.a,a.d+b),o=$.iE(),n=255+s-r
if(!(n>=0&&n<511))return A.a(o,n)
if(o[n]<=c){n=255+p-q
if(!(n>=0&&n<511))return A.a(o,n)
n=o[n]>c
o=n}else o=!0
return o},
fq(a,b,c){var s,r=J.d(a.a,a.d+-2*b),q=J.d(a.a,a.d+-b),p=J.d(a.a,a.d),o=J.d(a.a,a.d+b),n=$.iE(),m=255+q-p
if(!(m>=0&&m<511))return A.a(n,m)
m=n[m]
n=$.lE()
s=255+r-o
if(!(s>=0&&s<511))return A.a(n,s)
return 2*m+n[s]<=c},
fs(a,b,c,d){var s,r,q,p=J.d(a.a,a.d+-4*b),o=J.d(a.a,a.d+-3*b),n=J.d(a.a,a.d+-2*b),m=J.d(a.a,a.d+-b),l=J.d(a.a,a.d),k=J.d(a.a,a.d+b),j=J.d(a.a,a.d+2*b),i=J.d(a.a,a.d+3*b),h=$.iE(),g=255+m-l
if(!(g>=0&&g<511))return A.a(h,g)
g=h[g]
s=$.lE()
r=255+n
q=r-k
if(!(q>=0&&q<511))return A.a(s,q)
if(2*g+s[q]>c)return!1
g=255+p-o
if(!(g>=0&&g<511))return A.a(h,g)
s=!1
if(h[g]<=d){g=255+o-n
if(!(g>=0&&g<511))return A.a(h,g)
if(h[g]<=d){g=r-m
if(!(g>=0&&g<511))return A.a(h,g)
if(h[g]<=d){g=255+i-j
if(!(g>=0&&g<511))return A.a(h,g)
if(h[g]<=d){g=255+j-k
if(!(g>=0&&g<511))return A.a(h,g)
if(h[g]<=d){g=255+k-l
if(!(g>=0&&g<511))return A.a(h,g)
g=h[g]<=d
h=g}else h=s}else h=s}else h=s}else h=s}else h=s
return h},
bO(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=new Int32Array(16)
for(s=0,r=0,q=0;q<4;++q){p=s+8
o=J.d(a.a,a.d+s)+J.d(a.a,a.d+p)
n=J.d(a.a,a.d+s)-J.d(a.a,a.d+p)
p=s+4
m=B.a.j(J.d(a.a,a.d+p)*35468,16)
l=s+12
k=B.a.j(J.d(a.a,a.d+l)*85627,16)
j=(m&2147483647)-((m&2147483648)>>>0)-((k&2147483647)-((k&2147483648)>>>0))
p=B.a.j(J.d(a.a,a.d+p)*85627,16)
l=B.a.j(J.d(a.a,a.d+l)*35468,16)
i=(p&2147483647)-((p&2147483648)>>>0)+((l&2147483647)-((l&2147483648)>>>0))
h=r+1
if(!(r<16))return A.a(e,r)
e[r]=o+i
r=h+1
if(!(h<16))return A.a(e,h)
e[h]=n+j
h=r+1
if(!(r<16))return A.a(e,r)
e[r]=n-j
r=h+1
if(!(h<16))return A.a(e,h)
e[h]=o-i;++s}for(g=0,r=0,q=0;q<4;++q){if(!(r<16))return A.a(e,r)
f=e[r]+4
p=r+8
if(!(p<16))return A.a(e,p)
p=e[p]
o=f+p
n=f-p
p=r+4
if(!(p<16))return A.a(e,p)
p=e[p]
m=B.a.j(p*35468,16)
l=r+12
if(!(l<16))return A.a(e,l)
l=e[l]
k=B.a.j(l*85627,16)
j=(m&2147483647)-((m&2147483648)>>>0)-((k&2147483647)-((k&2147483648)>>>0))
p=B.a.j(p*85627,16)
l=B.a.j(l*35468,16)
i=(p&2147483647)-((p&2147483648)>>>0)+((l&2147483647)-((l&2147483648)>>>0))
A.c5(b,g,0,0,o+i)
A.c5(b,g,1,0,n+j)
A.c5(b,g,2,0,n-j)
A.c5(b,g,3,0,o-i);++r
g+=32}},
lQ(a,b,c){this.bO(a,b)
if(c)this.bO(A.p(a,null,16),A.p(b,null,4))},
d5(a,b){var s,r,q=J.d(a.a,a.d)+4
for(s=0;s<4;++s)for(r=0;r<4;++r)A.c5(b,0,r,s,q)},
hD(a,b){var s=this,r=null
if(J.d(a.a,a.d)!==0)s.d5(a,b)
if(J.d(a.a,a.d+16)!==0)s.d5(A.p(a,r,16),A.p(b,r,4))
if(J.d(a.a,a.d+32)!==0)s.d5(A.p(a,r,32),A.p(b,r,128))
if(J.d(a.a,a.d+48)!==0)s.d5(A.p(a,r,48),A.p(b,r,132))}}
A.k2.prototype={}
A.kd.prototype={}
A.kf.prototype={}
A.eY.prototype={}
A.ke.prototype={}
A.jZ.prototype={}
A.bM.prototype={}
A.f3.prototype={}
A.i8.prototype={}
A.f4.prototype={}
A.f5.prototype={}
A.f_.prototype={
cX(){var s,r,q,p,o=this,n=o.b
if(n.an(8)!==47)return!1
s=n.an(14)+1
r=n.an(14)+1
q=n.an(1)
o.dy=s
o.fr=r
p=o.c
p.f=B.aB
p.a=s
p.b=r
p.d=q!==0
if(n.an(3)!==0)return!1
return!0},
bT(){var s,r,q,p,o,n,m=this,l=null
m.f=0
if(!m.cX())return l
m.cG(m.dy,m.fr,!0)
m.eH(m.dy)
s=m.dy
m.d=A.Q(l,l,B.e,0,B.j,m.fr,l,0,4,l,B.e,s,!1)
s=m.cx
s.toString
r=m.c
q=r.a
p=r.b
if(!m.dO(s,q,p,p,m.gkd()))return l
s=r.w
if(s.length!==0){o=A.w(new A.af(s),!1,l,0)
s=m.d
s.toString
s.e=A.lP(o)}n=r.r
if(n!=null)m.d.c=new A.bB("",B.S,n)
return m.d},
eH(a){var s,r=this,q=r.c
q=q.a*q.b+a
s=new Uint32Array(q+a*16)
r.cx=s
r.cy=J.B(B.o.gB(s),0,null)
r.db=q
return!0},
kE(a){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=l.b
r=s.an(2)
q=l.CW
p=B.a.R(1,r)
if((q&p)>>>0!==0)return!1
l.CW=(q|p)>>>0
o=new A.i7(B.cA)
B.c.C(l.ch,o)
if(!(r<4))return A.a(B.c7,r)
q=B.c7[r]
o.a=q
o.b=a[0]
o.c=a[1]
switch(q.a){case 0:case 1:s=s.an(3)+2
o.e=s
o.d=l.cG(A.c6(o.b,s),A.c6(o.c,o.e),!1)
break
case 3:n=s.an(8)+1
if(n>16)m=0
else if(n>4)m=1
else{s=n>2?2:3
m=s}B.c.h(a,0,A.c6(o.b,m))
o.e=m
o.d=l.cG(n,1,!1)
l.jo(n,o)
break
case 2:break}return!0},
cG(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c)for(s=k.b,r=t.t,q=b,p=a;s.an(1)!==0;){o=A.j([p,q],r)
if(!k.kE(o))throw A.h(A.n("Invalid Transform"))
p=o[0]
q=o[1]}else{q=b
p=a}s=k.b
if(s.an(1)!==0){n=s.an(4)
if(!(n>=1&&n<=11))throw A.h(A.n("Invalid Color Cache"))}else n=0
if(!k.kr(p,q,n,c))throw A.h(A.n("Invalid Huffman Codes"))
if(n>0){s=B.a.R(1,n)
k.w=s
k.x=new A.k6(new Uint32Array(s),32-n)}else k.w=0
s=k.c
s.a=p
s.b=q
m=k.z
k.Q=A.c6(p,m)
k.y=m===0?4294967295:B.a.R(1,m)-1
if(c){k.f=0
return null}l=new Uint32Array(p*q)
if(!k.dO(l,p,q,q,null))throw A.h(A.n("Failed to decode image data."))
k.f=0
return l},
dO(b6,b7,b8,b9,c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=this,b5=506832829
t.ec.a(c0)
s=b4.f
r=B.a.au(s,b7)
q=B.a.a8(s,b7)
p=b7*b8
o=b7*b9
if(s>=o){if(c0!=null)c0.$2(b9,!1)
return!0}n=b4.fb(q,r)
m=b4.w
l=280+m
k=m>0?b4.x:null
j=b4.y
for(m=b6.length,i=b4.b,h=c0!=null,g=b6.$flags|0,f=s;f<o;){if((q&j)>>>0===0){e=b4.cJ(b4.as,b4.Q,b4.z,q,r)
d=b4.ax
if(!(e<d.length))return A.a(d,e)
n=d[e]}c=0
if(n.d){d=n.c
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=d;++f;++q
if(q>=b7){++r
if(h&&r<=b9)c0.$2(r,!0)
if(k!=null)for(d=k.a,b=k.b,a=d.$flags|0;s<f;){if(!(s>=0&&s<m))return A.a(b6,s)
a0=b6[s]
a1=B.a.a2(A.ca(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}q=c}continue}if(i.a>=32)i.cj()
if(n.e){a2=i.d1()&63
d=n.f
if(!(a2<d.length))return A.a(d,a2)
a3=d[a2]
d=a3.a
b=i.a
if(d<256){i.a=b+d
d=a3.b
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=d
a4=0}else{i.a=b+(d-256)
a4=a3.b}if(i.b)break
if(a4===0){++f;++q
if(q>=b7){++r
if(h&&r<=b9)c0.$2(r,!0)
if(k!=null)for(d=k.a,b=k.b,a=d.$flags|0;s<f;){if(!(s>=0&&s<m))return A.a(b6,s)
a0=b6[s]
a1=B.a.a2(A.ca(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}q=c}continue}}else a4=n.cq(0,i)
if(a4<256){if(n.b){d=n.c
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=(d|a4<<8)>>>0}else{a5=n.cq(1,i)
if(i.a>=32)i.cj()
a6=A.oH(n.cq(2,i),a4,a5,n.cq(3,i))
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=a6}++f;++q
if(q>=b7){++r
if(h&&r<=b9)c0.$2(r,!0)
if(k!=null)for(d=k.a,b=k.b,a=d.$flags|0;s<f;){if(!(s>=0&&s<m))return A.a(b6,s)
a0=b6[s]
a1=B.a.a2(A.ca(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}q=c}}else if(a4<280){a7=b4.dj(a4-256)
a8=n.cq(4,i)
if(i.a>=32)i.cj()
a9=b4.ft(b7,b4.dj(a8))
if(f<a9||p-f<a7)return!1
else{b0=f-a9
for(b1=0;b1<a7;++b1){d=f+b1
b=b0+b1
if(!(b>=0&&b<m))return A.a(b6,b)
b=b6[b]
g&2&&A.b(b6)
if(!(d>=0&&d<m))return A.a(b6,d)
b6[d]=b}}f+=a7
q+=a7
while(q>=b7){q-=b7;++r
if(h&&r<=b9)c0.$2(r,!0)}if((q&j)>>>0!==0){e=b4.cJ(b4.as,b4.Q,b4.z,q,r)
d=b4.ax
if(!(e<d.length))return A.a(d,e)
n=d[e]}if(k!=null)for(d=k.a,b=k.b,a=d.$flags|0;s<f;){if(!(s>=0&&s<m))return A.a(b6,s)
a0=b6[s]
a1=B.a.a2(A.ca(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}}else if(a4<l){b2=a4-280
while(s<f){k.toString
if(!(s>=0&&s<m))return A.a(b6,s)
d=b6[s]
b=k.a
a=B.a.a2(A.ca(d,b5),k.b)
b.$flags&2&&A.b(b)
if(!(a<b.length))return A.a(b,a)
b[a]=d;++s}d=k.a
b=d.length
if(!(b2<b))return A.a(d,b2)
a=d[b2]
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=a;++f;++q
if(q>=b7){++r
if(h&&r<=b9)c0.$2(r,!0)
for(a=k.b,a0=d.$flags|0;s<f;){if(!(s>=0&&s<m))return A.a(b6,s)
a1=b6[s]
b3=B.a.a2(A.ca(a1,b5),a)
a0&2&&A.b(d)
if(!(b3<b))return A.a(d,b3)
d[b3]=a1;++s}q=c}}else return!1}if(h)c0.$2(r>b9?b9:r,!1)
b4.f=f
return!0},
jR(){var s,r,q,p,o,n,m,l
if(this.w>0)return!1
for(s=this.at,r=this.ax,q=r.length,p=0;p<s;++p){if(!(p<q))return A.a(r,p)
o=r[p].a
n=o.length
if(1>=n)return A.a(o,1)
m=o[1]
l=m.a
m=m.b
if(!(m<l.length))return A.a(l,m)
if(l[m].a>0)return!1
if(2>=n)return A.a(o,2)
m=o[2]
l=m.a
m=m.b
if(!(m<l.length))return A.a(l,m)
if(l[m].a>0)return!1
if(3>=n)return A.a(o,3)
n=o[3]
m=n.a
n=n.b
if(!(n<m.length))return A.a(m,n)
if(m[n].a>0)return!1}return!0},
jp(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
if(b&&B.a.a8(a,16)!==0)return
s=g.r
r=a-s
q=g.dy
p=q*s
while(r>0){o=r>16?16:r
n=q*o
m=q*s
l=g.db
g.eI(s,o,p)
for(q=g.dx,k=g.cx,j=0;j<n;++j){q.toString
i=m+j
h=l+j
if(!(h<k.length))return A.a(k,h)
h=k[h]
q.$flags&2&&A.b(q)
if(!(i>=0&&i<q.length))return A.a(q,i)
q[i]=h>>>8&255}r-=o
q=g.dy
p+=o*q
s+=o}g.r=a},
iT(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_pixels8",d=f.f,c=B.a.au(d,a1),b=B.a.a8(d,a1),a=a1*a2,a0=a1*a3
if(d>=a0){f.dh(c)
return!0}s=f.fb(b,c)
r=f.y
q=f.b
for(;;){if(!(!q.b&&d<a0))break
if((b&r)>>>0===0){p=f.cJ(f.as,f.Q,f.z,b,c)
o=f.ax
if(!(p<o.length))return A.a(o,p)
s=o[p]}if(q.a>=32)q.cj()
n=s.cq(0,q)
if(n<256){o=f.cy
o===$&&A.c(e)
o.$flags&2&&A.b(o)
if(!(d>=0&&d<o.length))return A.a(o,d)
o[d]=n;++d;++b
if(b>=a1){++c
if(B.a.a8(c,16)===0)f.dh(c)
b=0}}else if(n<280){m=f.dj(n-256)
l=s.cq(4,q)
if(q.a>=32)q.cj()
k=f.ft(a1,f.dj(l))
if(d>=k&&a-d>=m)for(o=f.cy,j=0;j<m;++j){o===$&&A.c(e)
i=d+j
h=i-k
g=o.length
if(!(h>=0&&h<g))return A.a(o,h)
h=o[h]
o.$flags&2&&A.b(o)
if(!(i>=0&&i<g))return A.a(o,i)
o[i]=h}else{f.f=d
return!0}d+=m
b+=m
while(b>=a1){b-=a1;++c
if(B.a.a8(c,16)===0)f.dh(c)}if(d<a0&&(b&r)>>>0!==0){p=f.cJ(f.as,f.Q,f.z,b,c)
o=f.ax
if(!(p<o.length))return A.a(o,p)
s=o[p]}}else return!1}f.dh(c)
f.f=d
return!0},
dh(a){var s,r,q=this,p=q.r,o=a-p,n=q.cy
n===$&&A.c("_pixels8")
s=A.w(n,!1,null,q.c.a*p)
if(o>0){n=q.dx
n.toString
r=A.w(n,!1,null,q.dy*p)
n=q.ch
if(0>=n.length)return A.a(n,0)
n[0].l0(p,p+o,s,r)}q.r=a},
ke(a,b){var s,r,q,p,o,n,m=this,l=m.c.a,k=m.r
if(b)if(B.a.a8(a,16)!==0)return
s=a-k
if(s<=0){m.r=a
return}m.eI(k,s,l*k)
for(r=m.db,q=m.r,p=0;p<s;++p,++q)for(o=0;o<m.dy;++o,++r){l=m.cx
if(!(r>=0&&r<l.length))return A.a(l,r)
n=l[r]
l=m.d.a
if(l!=null)l.az(o,q,n>>>16&255,n>>>8&255,n&255,n>>>24&255)}m.r=a},
eI(a,b,c){var s,r=this,q=r.ch,p=q.length,o=r.c.a,n=a+b,m=r.db,l=r.cx
l.toString
B.o.ar(l,m,m+o*b,l,c)
for(;s=p-1,p>0;p=s){if(!(s>=0&&s<q.length))return A.a(q,s)
o=q[s]
l=r.cx
l.toString
o.ls(a,n,l,m,l,m)}},
kr(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1,c=null
if(a1&&e.b.an(1)!==0){s=2+e.b.an(3)
r=A.c6(a,s)
q=A.c6(b,s)
p=r*q
o=e.cG(r,q,!1)
if(o==null)return!1
e.z=s
for(n=o.length,m=o.$flags|0,l=d,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
j=o[k]>>>8&65535
m&2&&A.b(o)
o[k]=j
if(j>=l)l=j+1}if(l>1000||l>a*b){c=new Int32Array(1)
B.z.ac(c,0,1,255)
for(d=0,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
i=o[k]
if(!(i<1))return A.a(c,i)
if(c[i]===-1){h=d+1
c[i]=d
d=h}g=c[i]
m&2&&A.b(o)
o[k]=g}}else d=l}else{o=null
l=1}if(e.b.b)return!1
f=e.ks(a0,d,l,c)
if(f==null)return!1
e.as=o
e.at=d
e.ax=f
return!0},
e8(a,b,c,d,e,f){var s,r=a.a,q=a.b,p=d
do{p-=c
s=q+(b+p)
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
s.a=e
s.b=f}while(p>0)},
jU(a,b,c){var s=B.a.V(1,b-c)
while(b<15){s-=a[b]
if(s<=0)break;++b
s=s<<1>>>0}return b-c},
ff(a,b){var s=B.a.V(1,b-1)
while((a&s)>>>0!==0)s=s>>>1
return s!==0?((a&s-1)>>>0)+s:a},
eM(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.a.R(1,a6),a3=new Int32Array(16),a4=new Int32Array(16)
for(s=a7.length,r=0;r<a8;++r){if(!(r<s))return A.a(a7,r)
q=a7[r]
if(q>15)return 0
if(!(q>=0))return A.a(a3,q)
a3[q]=a3[q]+1}if(a3[0]===a8)return 0
a4[1]=0
for(p=1;p<15;p=o){q=a3[p]
if(q>B.a.R(1,p))return 0
o=p+1
a4[o]=a4[p]+q}for(q=a9!=null,r=0;r<a8;++r){if(!(r<s))return A.a(a7,r)
n=a7[r]
if(n>0)if(q){if(!(n<16))return A.a(a4,n)
m=a4[n]
if(m>=a8)return 0
a4[n]=m+1
a9.$flags&2&&A.b(a9)
if(!(m>=0&&m<a9.length))return A.a(a9,m)
a9[m]=r}else{if(!(n<16))return A.a(a4,n)
a4[n]=a4[n]+1}}if(a4[15]===1){if(q){a5.toString
if(0>=a9.length)return A.a(a9,0)
a1.e8(a5,0,1,a2,0,a9[0])}return a2}l=a2-1
for(s=a5==null,k=0,j=1,i=1,r=0,p=1,h=2;p<=a6;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
if(!(p<16))return A.a(a3,p)
i-=a3[p]
if(i<0)return 0
if(s)continue
for(g=p&255;a3[p]>0;a3[p]=a3[p]-1,r=f){f=r+1
if(!(r>=0&&r<a9.length))return A.a(a9,r)
a1.e8(a5,k,h,a2,g,a9[r])
k=a1.ff(k,p)}}for(p=a6+1,s=!s,e=a2,d=0,c=4294967295,h=2;p<=15;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
i-=a3[p]
if(i<0)return 0
for(g=p-a6&255;a3[p]>0;a3[p]=a3[p]-1){b=(k&l)>>>0
if(b!==c){if(s)d+=e
a=a1.jU(a3,p,a6)
e=B.a.V(1,a)
a2+=e
if(s){q=a5.a
m=a5.b+b
if(!(m>=0&&m<q.length))return A.a(q,m)
m=q[m]
m.a=a+a6&255
m.b=d-b}c=b}if(s){f=r+1
if(!(r>=0&&r<a9.length))return A.a(a9,r)
a0=a9[r]
a1.e8(a5,d+B.a.a0(k,a6),h,e,g,a0)
r=f}k=a1.ff(k,p)}}if(j!==2*a4[15]-1)return 0
return a2},
fQ(a,b,c,d){var s,r,q,p,o,n,m=this.eM(null,b,c,d,null)
if(m===0||a==null)return m
s=a.b
r=s.d
q=s.e
if(r+m>=q){p=new A.e9()
if(m>q)q=m
o=A.lT(q)
p.e=q
p.b=p.a=o
a.b=p
s=p}n=new Uint16Array(d)
this.eM(s.b,b,c,d,n)
return m},
kq(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.fY(new A.e9())
c.eC(128)
if(this.fQ(c,7,a,19)===0)return!1
s=this.b
if(s.an(1)!==0){r=2+s.an(2+2*s.an(3))
if(r>b)return!1}else r=b
for(q=8,p=0;p<b;r=o){o=r-1
if(r===0)break
if(s.a>=32)s.cj()
n=c.b.a
n.toString
m=n.a
n=n.b+(s.d1()&127)
if(!(n<m.length))return A.a(m,n)
l=m[n]
s.a=s.a+l.a
k=l.b
if(k<16){j=p+1
a0.$flags&2&&A.b(a0)
if(!(p>=0&&p<a0.length))return A.a(a0,p)
a0[p]=k
if(k!==0)q=k
p=j}else{i=k-16
if(!(i<3))return A.a(B.bs,i)
h=B.bs[i]
g=B.e6[i]
f=s.an(h)+g
if(p+f>b)return!1
e=k===16?q:0
for(n=a0.$flags|0;d=f-1,f>0;f=d,p=j){j=p+1
n&2&&A.b(a0)
if(!(p>=0&&p<a0.length))return A.a(a0,p)
a0[p]=e}}}return!0},
fA(a,b,c){var s,r,q,p,o,n,m,l=this.b,k=l.an(1)
B.z.ac(b,0,a,0)
if(k!==0){s=l.an(1)
r=l.an(l.an(1)===0?1:8)
b.$flags&2&&A.b(b)
q=b.length
if(!(r<q))return A.a(b,r)
b[r]=1
if(s+1===2){r=l.an(8)
if(!(r<q))return A.a(b,r)
b[r]=1}p=!0}else{o=new Int32Array(19)
n=l.an(4)+4
for(m=0;m<n;++m){if(!(m<19))return A.a(B.an,m)
s=B.an[m]
q=l.an(3)
if(!(s<19))return A.a(o,s)
o[s]=q}p=this.kq(o,a,b)}return p&&!l.b?this.fQ(c,8,b,a):0},
d9(a,b,c){var s=c.a,r=a.a
c.a=s+r
c.b=(c.b|B.a.R(a.b,b))>>>0
return r},
iB(a){var s,r,q,p,o,n,m,l,k,j,i=this
for(s=a.a,r=s.length,q=a.f,p=q.length,o=0;o<64;++o){if(!(o<p))return A.a(q,o)
n=q[o]
if(0>=r)return A.a(s,0)
m=s[0]
l=m.a
m=m.b+o
if(!(m<l.length))return A.a(l,m)
k=l[m]
m=k.b
if(m>=256){n.a=k.a+256
n.b=m}else{n.b=n.a=0
j=B.a.a0(o,i.d9(k,8,n))
if(1>=r)return A.a(s,1)
m=s[1]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a0(j,i.d9(l[m],16,n))
if(2>=r)return A.a(s,2)
m=s[2]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a0(j,i.d9(l[m],0,n))
if(3>=r)return A.a(s,3)
m=s[3]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
B.a.a0(j,i.d9(l[m],24,n))}}},
ks(a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null,a7=a9>0,a8=280+(a7?B.a.R(1,a9):0)
if(!(a9<12))return A.a(B.bC,a9)
s=B.bC[a9]
r=b2==null
if(r&&b0!==b1)return a6
q=new Int32Array(a8)
p=J.a8(b0,t.co)
for(o=0;o<b0;++o)p[o]=A.pI()
n=new A.fY(new A.e9())
n.eC(b0*s)
a5.ay=n
for(n=!r,m=0;m<b1;++m){if(n){if(!(m<b2.length))return A.a(b2,m)
l=b2[m]===-1}else l=!1
if(l)for(k=0;k<5;++k){j=B.bE[k]
if(a5.fA(k===0&&a7?j+B.a.R(1,a9):j,q,a6)===0)return a6}else{if(r)l=m
else{if(!(m<b2.length))return A.a(b2,m)
l=b2[m]}if(!(l>=0&&l<b0))return A.a(p,l)
i=p[l]
h=i.a
for(l=h.length,g=0,f=!0,e=0,k=0;k<5;++k){j=B.bE[k]
if(k===0&&a7)j+=B.a.R(1,a9)
d=a5.fA(j,q,a5.ay)
c=a5.ay.b.b
c.toString
B.c.h(h,k,c)
if(d===0)return a6
if(f&&B.is[k]===1){if(!(k<l))return A.a(h,k)
c=h[k]
b=c.a
c=c.b
if(!(c<b.length))return A.a(b,c)
f=b[c].a===0}if(!(k<l))return A.a(h,k)
c=h[k]
b=c.a
c=c.b
if(!(c<b.length))return A.a(b,c)
e+=b[c].a
c=a5.ay.b
c.d+=d
b=c.b
c.b=new A.e8(b.a,b.b+d)
if(k<=3){a=q[0]
for(a0=1;a0<j;++a0){if(!(a0<a8))return A.a(q,a0)
a1=q[a0]
if(a1>a)a=a1}g+=a}}i.b=f
i.d=!1
c=!1
if(f){if(1>=l)return A.a(h,1)
b=h[1]
a2=b.a
b=b.b
if(!(b<a2.length))return A.a(a2,b)
a3=a2[b].b
if(2>=l)return A.a(h,2)
b=h[2]
a2=b.a
b=b.b
if(!(b<a2.length))return A.a(a2,b)
a4=a2[b].b
if(3>=l)return A.a(h,3)
l=h[3]
b=l.a
l=l.b
if(!(l<b.length))return A.a(b,l)
l=(b[l].b<<24|a3<<16|a4)>>>0
i.c=l
if(e===0){c=h[0]
b=c.a
c=c.b
if(!(c<b.length))return A.a(b,c)
c=b[c].b<256}if(c){i.d=!0
b=h[0]
a2=b.a
b=b.b
if(!(b<a2.length))return A.a(a2,b)
i.c=(l|a2[b].b<<8)>>>0}l=c}else l=c
l=!l&&g<6
i.e=l
if(l)a5.iB(i)}}return p},
dj(a){var s
if(a<4)return a+1
s=B.a.j(a-2,1)
return B.a.R(2+(a&1),s)+this.b.an(s)+1},
ft(a,b){var s,r,q
if(b>120)return b-120
else{s=b-1
if(!(s>=0))return A.a(B.bF,s)
r=B.bF[s]
q=(r>>>4)*a+(8-(r&15))
return q>=1?q:1}},
jo(a,b){var s,r,q,p,o,n,m,l,k=B.a.R(1,B.a.a0(8,b.e)),j=new Uint32Array(k),i=b.d
i.toString
s=J.B(B.o.gB(i),0,null)
r=J.B(B.o.gB(j),0,null)
i=b.d
if(0>=i.length)return A.a(i,0)
i=i[0]
if(0>=k)return A.a(j,0)
j[0]=i
q=4*a
for(i=s.length,p=r.length,o=r.$flags|0,n=4;n<q;++n){if(!(n<i))return A.a(s,n)
m=s[n]
l=n-4
if(!(l<p))return A.a(r,l)
l=r[l]
o&2&&A.b(r)
if(!(n<p))return A.a(r,n)
r[n]=m+l&255}for(q=4*k;n<q;++n){o&2&&A.b(r)
if(!(n<p))return A.a(r,n)
r[n]=0}b.d=j
return!0},
cJ(a,b,c,d,e){var s
if(c===0||a==null)return 0
s=b*B.a.j(e,c)+B.a.j(d,c)
if(!(s<a.length))return A.a(a,s)
return a[s]},
fb(a,b){var s=this,r=s.cJ(s.as,s.Q,s.z,a,b),q=s.ax
if(!(r<q.length))return A.a(q,r)
return q[r]}}
A.hi.prototype={
li(a,b){return this.jp(a,b)}}
A.k3.prototype={}
A.k4.prototype={
gA(a){return this.c}}
A.k9.prototype={}
A.kb.prototype={
gA(a){return this.a}}
A.le.prototype={
$1(a){A.m(a)
return a>=1&&a<this.a},
$S:31}
A.kN.prototype={
ip(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.a,f=1
for(;;){s=B.a.R(1,f)
if(!(s<g&&f<18))break;++f}h.e!==$&&A.iC("_shift")
h.e=32-f
r=new Int32Array(s)
B.z.ac(r,0,s,-1)
h.d!==$&&A.iC("_head")
h.d=r
q=h.b
for(s=b.length,r=a.length,p=c.length,o=d.length,n=q.$flags|0,m=0;m<g;++m){if(!(m<s))return A.a(b,m)
l=b[m]
if(!(m<r))return A.a(a,m)
k=a[m]
if(!(m<p))return A.a(c,m)
j=c[m]
if(!(m<o))return A.a(d,m)
i=d[m]
n&2&&A.b(q)
if(!(m<q.length))return A.a(q,m)
q[m]=(l<<24|k<<16|j<<8|i)>>>0}},
lj(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.a
if(d<=2)return
s=e.b
r=e.c
q=e.d
q===$&&A.c("_head")
for(p=d-1,o=s.length,n=e.e,m=q.length,l=r.$flags|0,k=q.$flags|0,j=0;j<p;j=h){if(!(j<o))return A.a(s,j)
i=s[j]
h=j+1
if(!(h<o))return A.a(s,h)
g=A.ca(s[h],3332679571)
i=A.ca(i,1540483478)
n===$&&A.c("_shift")
f=B.a.hV(g+i>>>0,n)
if(!(f<m))return A.a(q,f)
i=q[f]
l&2&&A.b(r)
if(!(j<r.length))return A.a(r,j)
r[j]=i
k&2&&A.b(q)
q[f]=j}l&2&&A.b(r)
if(!(p<r.length))return A.a(r,p)
r[p]=-1}}
A.k7.prototype={
glv(){var s,r=this,q=r.f
if(q===$){s=new A.k8(r).$0()
r.f!==$&&A.mN("lengthBits")
r.f=s
q=s}return q},
hj(a,b){var s=A.iv(b,a),r=A.oF(s),q=this.e,p=A.iB(s)
if(!(p>=0&&p<q.length))return A.a(q,p)
return q[p]+r.a}}
A.k8.prototype={
$0(){var s,r,q,p,o,n=new Float64Array(4097)
for(s=this.a.a,r=s.length,q=1;q<=4096;++q){p=A.oC(q)
o=A.iz(q)
if(!(o>=0&&o<r))return A.a(s,o)
o=s[o]
if(!(q<4097))return A.a(n,q)
n[q]=o+p.a}return n},
$S:17}
A.i4.prototype={
d1(){var s,r,q,p=this.a
if(p<32){s=this.d
r=B.a.a2(s[0],p)
s=s[1]
if(!(p>=0))return A.a(B.a5,p)
q=r+((s&B.a5[p])>>>0)*(B.a5[32-p]+1)}else{s=this.d
q=p===32?s[1]:B.a.a2(s[1],p-32)}return q},
an(a){var s,r,q=this
if(!q.b&&a<25){s=q.d1()
if(!(a<33))return A.a(B.a5,a)
r=B.a5[a]
q.a+=a
q.cj()
return(s&r)>>>0}else{q.b=!0
throw A.h(A.n("Not enough data in input."))}},
cj(){var s,r,q,p=this,o=p.c,n=p.d,m=n.$flags|0,l=o.c
for(;;){if(!(p.a>=8&&o.d<l))break
s=J.d(o.a,o.d++)
r=n[0]
q=n[1]
m&2&&A.b(n)
n[0]=(r>>>8)+(q&255)*16777216
n[1]=q>>>8
n[1]=(n[1]|s*16777216)>>>0
p.a-=8}}}
A.i5.prototype={
jI(){var s=this.a,r=new Uint8Array(s.length*2)
B.d.ba(r,0,this.b,s)
this.a=r},
T(a,b){var s,r,q,p,o,n=this
while(b>0){s=n.d
r=8-s
q=b<r?b:r
p=B.a.V(1,q)
n.c=(n.c|B.a.V((a&p-1)>>>0,s))>>>0
a=B.a.aL(a,q)
b-=q
s+=q
n.d=s
if(s===8){s=n.b
p=n.a
o=p.length
if(s===o){o=new Uint8Array(o*2)
B.d.ba(o,0,s,p)
n.a=o
s=o}else s=p
p=n.b++
o=n.c
s.$flags&2&&A.b(s)
if(!(p<s.length))return A.a(s,p)
s[p]=o
n.d=n.c=0}}},
hp(){var s,r,q,p=this
if(p.d>0){if(p.b===p.a.length)p.jI()
s=p.a
r=p.b++
q=p.c
s.$flags&2&&A.b(s)
if(!(r<s.length))return A.a(s,r)
s[r]=q
p.d=p.c=0}},
cC(){var s=this.b,r=this.a
return s===r.length?r:new Uint8Array(A.q(A.qv(r,0,s)))}}
A.k6.prototype={}
A.l9.prototype={
$1(a){var s,r,q,p=this,o=p.a
if(!(a>=0&&a<o.length))return A.a(o,a)
o=o[a]
s=p.b
if(!(a<s.length))return A.a(s,a)
s=s[a]
r=p.c
if(!(a<r.length))return A.a(r,a)
r=r[a]
q=p.d
if(!(a<q.length))return A.a(q,a)
return(o<<24|s<<16|r<<8|q[a])>>>0},
$S:18}
A.la.prototype={
$1(a){return B.a.a2(A.ca(a,506832829),this.a)},
$S:18}
A.f0.prototype={}
A.ka.prototype={
lg(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=a3.gS(),a2=a3.gK()
if(a1<=0||a2<=0||a1>16383||a2>16383)throw A.h(A.n("WebP images must be between 1x1 and 16383x16383, got "+a1+"x"+a2))
s=a1*a2
r=new Uint8Array(s)
q=new Uint8Array(s)
p=new Uint8Array(s)
o=new Uint8Array(s)
n=a3.gal()===2||a3.gal()===4
m=a3.gal()===1
l=a3.gF()
k=l===255?1:255/l
for(j=k===1,i=!1,h=0,g=0;g<a2;++g)for(f=0;f<a1;++f){e=a3.a
d=e==null?null:e.P(f,g,null)
if(d==null)d=new A.F()
c=m?d.gn():d.gt()
b=m?d.gn():d.gu()
if(j){e=B.a.G(B.b.i(c),0,255)
if(!(h>=0&&h<s))return A.a(r,h)
r[h]=e
e=B.a.G(B.b.i(d.gn()),0,255)
if(!(h<s))return A.a(q,h)
q[h]=e
e=B.a.G(B.b.i(b),0,255)
if(!(h<s))return A.a(p,h)
p[h]=e
e=n?B.a.G(B.b.i(d.gv()),0,255):255
if(!(h<s))return A.a(o,h)
o[h]=e}else{e=B.a.G(B.b.av(c*k),0,255)
if(!(h>=0&&h<s))return A.a(r,h)
r[h]=e
e=B.a.G(B.b.av(d.gn()*k),0,255)
if(!(h<s))return A.a(q,h)
q[h]=e
e=B.a.G(B.b.av(b*k),0,255)
if(!(h<s))return A.a(p,h)
p[h]=e
e=n?B.a.G(B.b.av(d.gv()*k),0,255):255
if(!(h<s))return A.a(o,h)
o[h]=e}if(!(h>=0&&h<s))return A.a(o,h)
if(o[h]!==255)i=!0;++h}j=i?1:0
a=a1-1|a2-1<<14|j<<28
a0=A.Y(!1,8192)
a0.m(47)
a0.m(a&255)
a0.m(a>>>8&255)
a0.m(a>>>16&255)
a0.m(a>>>24&255)
a0.a5(this.lf(q,r,p,o,a1,a2,i))
return J.B(B.d.gB(a0.c),0,a0.a)},
lf(a4,a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a8+16-1,a=B.a.W(b,16),a0=a9+16-1,a1=B.a.W(a0,16),a2=a8*a9,a3=new Uint32Array(a2)
for(s=a7.length,r=a4.length,q=a5.length,p=a6.length,o=0;o<a2;++o){if(!(o<s))return A.a(a7,o)
n=a7[o]
if(!(o<r))return A.a(a4,o)
m=a4[o]
if(!(o<q))return A.a(a5,o)
l=a5[o]
if(!(o<p))return A.a(a6,o)
a3[o]=(n<<24|m<<16|l<<8|a6[o])>>>0}k=c.iC(a4,a5,a6,a7,a2)
if(k!=null){j=new A.i5(new Uint8Array(4096))
c.kV(j,k,a4,a5,a6,a7,a8,a9)
j.hp()
return j.cC()}i=A.tR(a3,a8,a9,4)
n=i.a
if(n){c.iv(a4,a5,a6,a2)
for(o=0;o<a2;++o){if(!(o<s))return A.a(a7,o)
m=a7[o]
if(!(o<r))return A.a(a4,o)
l=a4[o]
if(!(o<q))return A.a(a5,o)
h=a5[o]
if(!(o<p))return A.a(a6,o)
a3[o]=(m<<24|l<<16|h<<8|a6[o])>>>0}}if(i.b){g=A.uF(a3,a8,a9,a,a1,16)
A.tU(a3,a4,a5,a6,a7,a8,a9,a,16,g)}else g=null
if(i.c){f=A.uE(a4,a5,a6,a8,a9,4)
if(f!=null)A.tT(a4,a5,a6,a8,a9,4,f)}else f=null
j=new A.i5(new Uint8Array(4096))
if(n){j.T(1,1)
j.T(2,2)}if(g!=null){j.T(1,1)
j.T(0,2)
j.T(2,3)
A.vl(j,a,a1,g)}if(f!=null){e=B.a.j(b,4)
d=B.a.j(a0,4)
j.T(1,1)
j.T(1,2)
j.T(2,3)
c.kQ(j,e,d,f)}j.T(0,1)
c.cQ(j,a4,a5,a6,a7,a8,a2,!0)
j.hp()
return j.cC()},
cQ(d8,d9,e0,e1,e2,e3,e4,e5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4="green",d5=A.u1(d9,e0,e1,e2,e4,e3),d6=new Int32Array(e4),d7=new A.k9(e4,d6,new Int32Array(e4))
A.qX(d5,d7)
A.ux(d5,A.qW(d7,d9,e0,e1,e2,e3),d9,e0,e1,e2,e3,d7)
s=A.uC(d7)
r=s.a
q=s.b
p=s.c
o=s.d
n=s.e
m=p.length
l=new Int32Array(m)
k=new Int32Array(m)
for(d6=o.length,j=0;j<m;++j){l[j]=A.iz(p[j])
if(!(j<d6))return A.a(o,j)
k[j]=A.iB(A.iv(e3,o[j]))}i=q.length
h=new Int32Array(i)
g=A.uD(d9,e0,e1,e2,r,q,p,o,e3,h)
f=g>0
e=280+(f?B.a.V(1,g):0)
if(f){d8.T(1,1)
d8.T(g,4)}else d8.T(0,1)
d=e5?this.kI(d9,e0,e1,e2,r,q,l,k,n,h,e3,e4,e):null
if(e5)if(d==null)d8.T(0,1)
else{d8.T(1,1)
d8.T(d.a-2,3)
this.kT(d8,d)}f=d==null
c=f?null:d.d.b
if(c==null)c=1
b=r.length
a=new Int32Array(b)
if(!f){a0=d.d.a
a1=d.a
a2=d.b
for(f=a0.length,a3=n.length,a4=0,a5=0,a6=0;a6<b;++a6){if(!(a6<a3))return A.a(n,a6)
a7=n[a6]
while(a8=a7-a4,a8>=e3){a4+=e3;++a5}a8=B.a.a2(a5,a1)*a2+B.a.aL(a8,a1)
if(!(a8<f))return A.a(a0,a8)
a[a6]=a0[a8]}}a9=J.a8(c,t.d)
for(b0=0;b0<c;++b0)a9[b0]=A.f2(e)
for(f=d9.length,a3=e0.length,a8=e1.length,b1=e2.length,b2=0,b3=0,a6=0;a6<b;++a6){b4=a[a6]
if(!(b4>=0&&b4<c))return A.a(a9,b4)
b5=a9[b4]
if(r[a6]!==0){if(!(b2<i))return A.a(h,b2)
b6=h[b2]
b7=b2+1
b8=q[b2]
if(b6>=0)b5.h_(b6)
else{if(!(b8>=0&&b8<f))return A.a(d9,b8)
b4=d9[b8]
if(!(b8<a3))return A.a(e0,b8)
b9=e0[b8]
if(!(b8<a8))return A.a(e1,b8)
c0=e1[b8]
if(!(b8<b1))return A.a(e2,b8)
b5.h2(b4,b9,c0,e2[b8])}b2=b7}else{if(!(b3<m))return A.a(l,b3)
b5.h0(l[b3],k[b3]);++b3}}c1=A.j([],t.bm)
for(b4=t.L,b0=0;b0<c;++b0){b5=a9[b0]
b9=A.dQ(b5.b,e,15)
c0=A.dQ(b5.c,256,15)
c2=A.dQ(b5.d,256,15)
c3=A.dQ(b5.e,256,15)
c4=A.dQ(b5.f,40,15)
c5=new A.ig(e,b9,c0,c2,c3,c4)
A.fx(d8,e,b9)
A.fx(d8,256,c0)
A.fx(d8,256,c2)
A.fx(d8,256,c3)
A.fx(d8,40,c4)
c5.r=b4.a(A.dR(new Int32Array(A.q(b9)),e))
c5.w=b4.a(A.dR(new Int32Array(A.q(c0)),256))
c5.x=b4.a(A.dR(new Int32Array(A.q(c2)),256))
c5.y=b4.a(A.dR(new Int32Array(A.q(c3)),256))
c5.z=b4.a(A.dR(new Int32Array(A.q(c4)),40))
B.c.C(c1,c5)}for(b2=0,b3=0,a6=0;a6<b;++a6){b9=a[a6]
if(!(b9>=0&&b9<c1.length))return A.a(c1,b9)
c6=c1[b9]
if(r[a6]!==0){if(!(b2<i))return A.a(h,b2)
b6=h[b2]
b7=b2+1
b8=q[b2]
b9=c6.r
c0=c6.b
if(b6>=0){b9===$&&A.c(d4)
c2=280+b6
b4.a(b9)
b4.a(c0)
if(!(c2<b9.length))return A.a(b9,c2)
b9=b9[c2]
if(!(c2<c0.length))return A.a(c0,c2)
d8.T(b9,c0[c2])}else{b9===$&&A.c(d4)
if(!(b8>=0&&b8<a3))return A.a(e0,b8)
c2=e0[b8]
b4.a(b9)
b4.a(c0)
b9=B.c.l(b9,c2)
if(c2>>>0!==c2||c2>=c0.length)return A.a(c0,c2)
d8.T(b9,c0[c2])
c2=c6.w
c2===$&&A.c("red")
if(!(b8<f))return A.a(d9,b8)
c0=d9[b8]
b4.a(c2)
b9=b4.a(c6.c)
c2=B.c.l(c2,c0)
if(c0>>>0!==c0||c0>=b9.length)return A.a(b9,c0)
d8.T(c2,b9[c0])
c0=c6.x
c0===$&&A.c("blue")
if(!(b8<a8))return A.a(e1,b8)
b9=e1[b8]
b4.a(c0)
c2=b4.a(c6.d)
c0=B.c.l(c0,b9)
if(b9>>>0!==b9||b9>=c2.length)return A.a(c2,b9)
d8.T(c0,c2[b9])
b9=c6.y
b9===$&&A.c("alpha")
if(!(b8<b1))return A.a(e2,b8)
c2=e2[b8]
b4.a(b9)
c0=b4.a(c6.e)
b9=B.c.l(b9,c2)
if(c2>>>0!==c2||c2>=c0.length)return A.a(c0,c2)
d8.T(b9,c0[c2])}b2=b7}else{if(!(b3<m))return A.a(p,b3)
c7=p[b3]
if(!(b3<d6))return A.a(o,b3)
c8=o[b3];++b3
b9=c6.r
b9===$&&A.c(d4)
c0=A.iz(c7)
b4.a(b9)
c2=b4.a(c6.b)
if(!(c0>=0&&c0<b9.length))return A.a(b9,c0)
b9=b9[c0]
if(!(c0<c2.length))return A.a(c2,c0)
d8.T(b9,c2[c0])
c9=A.oC(c7)
d0=c9.a
if(d0>0)d8.T(c9.b,d0)
d1=A.iv(e3,c8)
b9=c6.z
b9===$&&A.c("dist")
c0=A.iB(d1)
b4.a(b9)
c2=b4.a(c6.f)
if(!(c0>=0&&c0<b9.length))return A.a(b9,c0)
b9=b9[c0]
if(!(c0<c2.length))return A.a(c2,c0)
d8.T(b9,c2[c0])
d2=A.oF(d1)
d3=d2.a
if(d3>0)d8.T(d2.b,d3)}}},
kI(b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=B.a.au(c6,c5)
for(s=b9.length,r=c1.length,q=c2.length,p=c3.length,o=b5.length,n=b6.length,m=b7.length,l=b8.length,k=c4.length,j=c0.length,i=t.d,h=null,g=0;g<3;++g){f=B.ek[g]
e=B.a.R(1,f)
d=B.a.j(c5+e-1,f)
c=B.a.j(b4+e-1,f)
e=d*c
if(e<2||e>2600)continue
b=J.a8(e,i)
for(a=0;a<e;++a)b[a]=A.f2(c7)
for(a0=0,a1=0,a2=0,a3=0,a4=0;a4<s;++a4){if(!(a4<p))return A.a(c3,a4)
a5=c3[a4]
while(a6=a5-a2,a6>=c5){a2+=c5;++a3}a6=B.a.a0(a3,f)*d+B.a.j(a6,f)
if(!(a6<e))return A.a(b,a6)
a7=b[a6]
if(b9[a4]!==0){if(!(a0<k))return A.a(c4,a0)
a8=c4[a0]
a9=a0+1
if(!(a0<j))return A.a(c0,a0)
b0=c0[a0]
if(a8>=0)a7.h_(a8)
else{if(!(b0>=0&&b0<o))return A.a(b5,b0)
a6=b5[b0]
if(!(b0<n))return A.a(b6,b0)
b1=b6[b0]
if(!(b0<m))return A.a(b7,b0)
b2=b7[b0]
if(!(b0<l))return A.a(b8,b0)
a7.h2(a6,b1,b2,b8[b0])}a0=a9}else{if(!(a1<r))return A.a(c1,a1)
a6=c1[a1]
if(!(a1<q))return A.a(c2,a1)
a7.h0(a6,c2[a1]);++a1}}b3=A.u0(b)
if(b3!=null)e=h==null||b3.c<h.d.c
else e=!1
if(e)h=new A.kO(f,d,c,b3)}return h},
kT(a,b){var s,r,q,p,o,n=b.b,m=n*b.c,l=new Uint8Array(m),k=new Uint8Array(m),j=new Uint8Array(m),i=new Uint8Array(m)
B.d.ac(i,0,m,255)
for(s=b.d.a,r=s.length,q=0;q<m;++q){if(!(q<r))return A.a(s,q)
p=s[q]
o=B.a.j(p,8)
if(!(q<m))return A.a(l,q)
l[q]=o&255
if(!(q<m))return A.a(k,q)
k[q]=p&255}this.cQ(a,l,k,j,i,n,m,!1)},
iC(a,b,c,d,e){var s,r,q,p,o,n,m,l,k=A.pW(t.p)
for(s=d.length,r=a.length,q=b.length,p=c.length,o=0;o<e;++o){if(!(o<s))return A.a(d,o)
n=d[o]
if(!(o<r))return A.a(a,o)
m=a[o]
if(!(o<q))return A.a(b,o)
l=b[o]
if(!(o<p))return A.a(c,o)
if(k.C(0,(n<<24|m<<16|l<<8|c[o])>>>0)&&k.a>256)return null}s=A.u(k,k.$ti.c)
B.c.ev(s)
return new Uint32Array(A.q(s))},
kV(b5,b6,b7,b8,b9,c0,c1,c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=b6.length
b5.T(1,1)
b5.T(3,2)
b5.T(b4-1,8)
s=new Uint8Array(b4)
r=new Uint8Array(b4)
q=new Uint8Array(b4)
p=new Uint8Array(b4)
for(o=0,n=0,m=0,l=0,k=0;k<b4;++k,l=i,m=f,n=g,o=h){j=b6[k]
i=j>>>24&255
h=j>>>16&255
g=j>>>8&255
f=j&255
if(!(k<b4))return A.a(s,k)
s[k]=h-o&255
if(!(k<b4))return A.a(r,k)
r[k]=g-n&255
if(!(k<b4))return A.a(q,k)
q[k]=f-m&255
if(!(k<b4))return A.a(p,k)
p[k]=i-l&255}this.cQ(b5,s,r,q,p,b4,b4,!1)
b5.T(0,1)
e=t.p
d=A.I(e,e)
for(k=0;k<b4;++k)d.h(0,b6[k],k)
if(b4>16)c=0
else if(b4>4)c=1
else{e=b4>2?2:3
c=e}b=A.qY(c1,c)
a=b*c2
a0=new Uint8Array(a)
a1=new Uint8Array(a)
if(c===0)for(e=c1*c2,a2=c0.length,a3=b7.length,a4=b8.length,a5=b9.length,k=0;k<e;++k){if(!(k<a2))return A.a(c0,k)
a6=c0[k]
if(!(k<a3))return A.a(b7,k)
a7=b7[k]
if(!(k<a4))return A.a(b8,k)
a8=b8[k]
if(!(k<a5))return A.a(b9,k)
a8=d.l(0,(a6<<24|a7<<16|a8<<8|b9[k])>>>0)
a8.toString
if(!(k<a))return A.a(a0,k)
a0[k]=a8}else{a9=B.a.a0(8,c)
for(e=c0.length,a2=b7.length,a3=b8.length,a4=b9.length,a5=B.a.R(1,c)-1,b0=0;b0<c2;++b0)for(a6=b0*c1,a7=b0*b,b1=0;b1<c1;++b1){k=a6+b1
if(!(k>=0&&k<e))return A.a(c0,k)
a8=c0[k]
if(!(k<a2))return A.a(b7,k)
b2=b7[k]
if(!(k<a3))return A.a(b8,k)
b3=b8[k]
if(!(k<a4))return A.a(b9,k)
b3=d.l(0,(a8<<24|b2<<16|b3<<8|b9[k])>>>0)
b3.toString
b2=a7+B.a.a0(b1,c)
if(!(b2<a))return A.a(a0,b2)
a8=a0[b2]
b3=B.a.R(b3,((b1&a5)>>>0)*a9)
if(!(b2<a))return A.a(a0,b2)
a0[b2]=(a8|b3)>>>0}}this.cQ(b5,a1,a0,a1,a1,b,a,!0)},
iv(a,b,c,d){var s,r,q,p,o,n,m,l
for(s=a.length,r=b.length,q=a.$flags|0,p=c.length,o=c.$flags|0,n=0;n<d;++n){if(!(n<s))return A.a(a,n)
m=a[n]
if(!(n<r))return A.a(b,n)
l=b[n]
q&2&&A.b(a)
a[n]=m-l&255
if(!(n<p))return A.a(c,n)
l=c[n]
m=b[n]
o&2&&A.b(c)
c[n]=l-m&255}},
kQ(a,b,c,d){var s,r,q,p,o,n,m,l
t.p8.a(d)
s=b*c
r=new Uint8Array(s)
q=new Uint8Array(s)
p=new Uint8Array(s)
o=new Uint8Array(s)
B.d.ac(o,0,s,255)
for(n=d.length,m=0;m<s;++m){if(!(m<n))return A.a(d,m)
l=d[m]
r[m]=l.c&255
q[m]=l.b&255
p[m]=l.a&255}this.cQ(a,r,q,p,o,b,s,!1)}}
A.kO.prototype={}
A.ig.prototype={}
A.l6.prototype={
$0(){var s,r,q=new Float64Array(4096)
for(s=1;s<4096;++s){r=Math.log(s)
if(!(s<4096))return A.a(q,s)
q[s]=r}return q},
$S:17}
A.f1.prototype={
h2(a,b,c,d){var s,r=this,q=r.b
if(!(b>=0&&b<q.length))return A.a(q,b)
s=q[b]
q.$flags&2&&A.b(q)
q[b]=s+1
if(s===0)r.c4(0,b)
q=r.c
if(!(a>=0&&a<256))return A.a(q,a)
s=q[a]
q.$flags&2&&A.b(q)
q[a]=s+1
if(s===0)r.c4(1,a)
q=r.d
if(!(c>=0&&c<256))return A.a(q,c)
s=q[c]
q.$flags&2&&A.b(q)
q[c]=s+1
if(s===0)r.c4(2,c)
q=r.e
if(!(d>=0&&d<256))return A.a(q,d)
s=q[d]
q.$flags&2&&A.b(q)
q[d]=s+1
if(s===0)r.c4(3,d)},
h_(a){var s,r=this.b,q=280+a
if(!(q>=0&&q<r.length))return A.a(r,q)
s=r[q]
r.$flags&2&&A.b(r)
r[q]=s+1
if(s===0)this.c4(0,q)},
h0(a,b){var s,r=this,q=r.b
if(!(a>=0&&a<q.length))return A.a(q,a)
s=q[a]
q.$flags&2&&A.b(q)
q[a]=s+1
if(s===0)r.c4(0,a)
q=r.f
if(!(b>=0&&b<40))return A.a(q,b)
s=q[b]
q.$flags&2&&A.b(q)
q[b]=s+1
if(s===0)r.c4(4,b)},
cR(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f
for(s=this.Q,r=this.as,q=0;q<5;++q){p=this.gcF()[q]
o=a.gcF()[q]
n=s[q]
m=r[q]
for(l=o.length,k=p.length,j=n.length,i=0;i<m;++i){if(!(i<j))return A.a(n,i)
h=n[i]
if(!(h>=0&&h<l))return A.a(o,h)
if(o[h]===0)a.c4(q,h)
g=o[h]
if(!(h<k))return A.a(p,h)
f=p[h]
o.$flags&2&&A.b(o)
o[h]=g+f}}a.z=!1},
gcm(){var s,r,q,p,o,n,m,l,k=this
k.dS()
for(s=k.y,r=k.w,q=k.x,p=0,o=0;o<5;++o){n=r[o]
m=q[o]
if(m===0)n=0
else{if(m<4096){l=$.fy()
if(!(m>=0&&m<l.length))return A.a(l,m)
l=l[m]}else l=Math.log(m)
l=(n+m*l)/0.6931471805599453
n=l}p+=n+s[o]*4}return p},
hu(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.dS()
a5.dS()
for(s=a4.x,r=a5.x,q=a4.w,p=a4.y,o=a5.Q,n=a5.as,m=0,l=0;l<5;++l){k=a4.gcF()[l]
j=a5.gcF()[l]
i=q[l]
h=p[l]
g=o[l]
f=n[l]
for(e=g.length,d=k.length,c=j.length,b=0;b<f;++b){if(!(b<e))return A.a(g,b)
a=g[b]
if(!(a>=0&&a<d))return A.a(k,a)
a0=k[a]
if(!(a<c))return A.a(j,a)
a1=j[a]
if(a0>0){if(a0<4096){a2=$.fy()
if(!(a0<a2.length))return A.a(a2,a0)
a2=a2[a0]}else a2=Math.log(a0)
i+=a0*a2}else ++h
a3=a0+a1
if(a3<4096){a2=$.fy()
if(!(a3<a2.length))return A.a(a2,a3)
a2=a2[a3]}else a2=Math.log(a3)
i-=a3*a2}e=s[l]+r[l]
if(e===0)e=0
else{if(e<4096){d=$.fy()
if(!(e>=0&&e<d.length))return A.a(d,e)
d=d[e]}else d=Math.log(e)
d=(i+e*d)/0.6931471805599453
e=d}m+=e+h*4}return m},
gcF(){var s,r=this,q=r.r
if(q===$){s=A.j([r.b,r.c,r.d,r.e,r.f],t.gF)
r.r!==$&&A.mN("_arrays")
r.r=s
q=s}return q},
c4(a,b){var s,r,q,p,o,n=this.Q
if(!(a<5))return A.a(n,a)
s=n[a]
r=this.as
q=r[a]
if(q===s.length){p=q===0?8:q*2
o=new Int32Array(p)
B.z.ba(o,0,q,s)
B.c.h(n,a,o)
s=o}s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=b
r.$flags&2&&A.b(r)
r[a]=q+1},
dS(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
if(a0.z)return
for(s=a0.w,r=s.$flags|0,q=a0.x,p=q.$flags|0,o=a0.y,n=o.$flags|0,m=a0.Q,l=a0.as,k=0;k<5;++k){j=a0.gcF()[k]
i=m[k]
h=l[k]
for(g=i.length,f=j.length,e=0,d=0,c=0;c<h;++c){if(!(c<g))return A.a(i,c)
b=i[c]
if(!(b>=0&&b<f))return A.a(j,b)
a=j[b]
if(a<4096){b=$.fy()
if(!(a<b.length))return A.a(b,a)
b=b[a]}else b=Math.log(a)
e-=a*b
d+=a}r&2&&A.b(s)
s[k]=e
p&2&&A.b(q)
q[k]=d
n&2&&A.b(o)
o[k]=h}a0.z=!0}}
A.k5.prototype={}
A.lc.prototype={
$2(a,b){var s,r,q
A.m(a)
A.m(b)
s=this.a
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
q=s[a]
if(!(b>=0&&b<r))return A.a(s,b)
return B.a.bS(q,s[b])},
$S:16}
A.bP.prototype={}
A.cI.prototype={
a7(){return"VP8LImageTransformType."+this.b}}
A.i7.prototype={
ls(a,b,c,d,e,f){var s,r,q,p,o=this,n=o.b
switch(o.a.a){case 2:o.kW(e,f,(b-a)*n)
break
case 0:o.lz(a,b,c,d,e,f)
if(b!==o.c){s=f-n
B.o.ar(e,s,s+n,c,f+(b-a-1)*n)}break
case 1:o.l1(a,b,c,d,e,f)
break
case 3:if(d===f&&o.e>0){r=b-a
q=r*A.c6(n,o.e)
p=f+r*n-q
B.o.ar(e,p,p+q,c,f)
o.hd(a,b,c,p,e,f)}else o.hd(a,b,c,d,e,f)
break}},
l0(a,b,c,d){var s,r,q,p,o,n,m=this.e,l=B.a.a0(8,m),k=this.b,j=this.d
if(l<8){s=B.a.R(1,m)-1
r=B.a.R(1,l)-1
for(q=a;q<b;++q)for(p=0,o=0;o<k;++o){if((o&s)>>>0===0){p=J.d(c.a,c.d);++c.d}m=(p&r)>>>0
if(!(m>=0&&m<j.length))return A.a(j,m)
m=j[m]
J.y(d.a,d.d,m>>>8&255);++d.d
p=B.a.j(p,l)}}else for(q=a;q<b;++q)for(o=0;o<k;++o){n=J.d(c.a,c.d);++c.d
if(!(n>=0&&n<j.length))return A.a(j,n)
m=j[n]
J.y(d.a,d.d,m>>>8&255);++d.d}},
hd(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=this.e,i=B.a.a0(8,j),h=this.b,g=this.d
if(i<8){s=B.a.R(1,j)-1
r=B.a.R(1,i)-1
for(j=e.$flags|0,q=c.length,p=a;p<b;++p)for(o=0,n=0;n<h;++n,f=l){if((n&s)>>>0===0){m=d+1
if(!(d>=0&&d<q))return A.a(c,d)
o=c[d]>>>8&255
d=m}l=f+1
k=o&r
if(!(k>=0&&k<g.length))return A.a(g,k)
k=g[k]
j&2&&A.b(e)
if(!(f>=0&&f<e.length))return A.a(e,f)
e[f]=k
o=B.a.a0(o,i)}}else for(j=c.length,q=e.$flags|0,p=a;p<b;++p)for(n=0;n<h;++n,f=l,d=m){l=f+1
g.toString
m=d+1
if(!(d>=0&&d<j))return A.a(c,d)
k=c[d]>>>8&255
if(!(k<g.length))return A.a(g,k)
k=g[k]
q&2&&A.b(e)
if(!(f>=0&&f<e.length))return A.a(e,f)
e[f]=k}},
l1(a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.b,a1=a.e,a2=B.a.R(1,a1)-1,a3=A.c6(a0,a1),a4=B.a.j(a5,a.e)*a3
for(a1=a7.length,s=a9.$flags|0,r=a5;r<a6;){q=new Uint8Array(3)
for(p=a4,o=0;o<a0;++o){if((o&a2)>>>0===0){n=a.d
m=p+1
if(!(p<n.length))return A.a(n,p)
n=n[p]
q[0]=n&255
q[1]=n>>>8&255
q[2]=n>>>16&255
p=m}n=b0+o
l=a8+o
if(!(l<a1))return A.a(a7,l)
l=a7[l]
k=l>>>8&255
j=q[0]
i=$.aq()
i.$flags&2&&A.b(i)
i[0]=j
j=$.az()
if(0>=j.length)return A.a(j,0)
h=j[0]
i[0]=k
g=j[0]
f=$.iF()
f.$flags&2&&A.b(f)
f[0]=h*g
e=$.lH()
if(0>=e.length)return A.a(e,0)
d=(l>>>16&255)+(e[0]>>>5)>>>0&255
i[0]=q[1]
h=j[0]
i[0]=k
f[0]=h*j[0]
c=e[0]
i[0]=q[2]
h=j[0]
i[0]=d
f[0]=h*j[0]
b=e[0]
s&2&&A.b(a9)
if(!(n<a9.length))return A.a(a9,n)
a9[n]=(l&4278255360|d<<16|((l&255)+(c>>>5)>>>0)+(b>>>5)>>>0&255)>>>0}b0+=a0
a8+=a0;++r
if((r&a2)>>>0===0)a4+=a3}},
cr(a,b){return(((a&4278255360)>>>0)+((b&4278255360)>>>0)&4278255360|(a&16711935)+(b&16711935)&16711935)>>>0},
lz(b1,b2,b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=4278190080,b0=a8.b
if(b1===0){s=b3.length
if(!(b4<s))return A.a(b3,b4)
r=a8.cr(b3[b4],a9)
b5.$flags&2&&A.b(b5)
q=b5.length
if(!(b6<q))return A.a(b5,b6)
b5[b6]=r
p=b4+1
o=b6+1
n=b0-1
m=b5[b6]
for(r=b5.$flags|0,l=0;l<n;++l){k=p+l
if(!(k<s))return A.a(b3,k)
m=a8.cr(b3[k],m)
k=o+l
r&2&&A.b(b5)
if(!(k<q))return A.a(b5,k)
b5[k]=m}b4+=b0
b6+=b0;++b1}s=a8.e
j=B.a.R(1,s)
i=j-1
h=A.c6(b0,s)
g=B.a.j(b1,a8.e)*h
for(s=b3.length,r=~i,q=b5.length,f=b1;f<b2;){k=b6-b0
if(!(k>=0&&k<q))return A.a(b5,k)
e=b5[k]
if(!(b4<s))return A.a(b3,b4)
k=a8.cr(b3[b4],e)
b5.$flags&2&&A.b(b5)
if(!(b6<q))return A.a(b5,b6)
b5[b6]=k
for(d=g,c=1;c<b0;c=a1,d=b){k=a8.d
b=d+1
if(!(d<k.length))return A.a(k,d)
a=k[d]>>>8&15
a0=$.rc[a]
a1=((c&r)>>>0)+j
if(a1>b0)a1=b0
a2=b4+c
k=b6+c
a3=k-b0
a4=a1-c
if(a===0)for(a5=b5.$flags|0,l=0;l<a4;++l){a6=k+l
a7=a2+l
if(!(a7>=0&&a7<s))return A.a(b3,a7)
a7=a8.cr(b3[a7],a9)
a5&2&&A.b(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=a7}else if(a===1){a5=k-1
if(!(a5>=0&&a5<q))return A.a(b5,a5)
m=b5[a5]
for(a5=b5.$flags|0,l=0;l<a4;++l){a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
m=a8.cr(b3[a6],m)
a6=k+l
a5&2&&A.b(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=m}}else for(l=0;l<a4;++l){a5=k+l
a6=a5-1
if(!(a6>=0&&a6<q))return A.a(b5,a6)
e=a0.$3(b5[a6],b5,a3+l)
a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
a6=a8.cr(b3[a6],e)
b5.$flags&2&&A.b(b5)
if(!(a5>=0&&a5<q))return A.a(b5,a5)
b5[a5]=a6}}b4+=b0
b6+=b0;++f
if((f&i)>>>0===0)g+=h}},
kW(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=a.$flags|0,q=0;q<c;++q){p=b+q
if(!(p<s))return A.a(a,p)
o=a[p]
n=o>>>8&255
r&2&&A.b(a)
a[p]=(o&4278255360|(o&16711935)+(n<<16|n)&16711935)>>>0}}}
A.kh.prototype={
ghs(){var s=this,r=s.d
if(r>1||s.e>=4||s.f>1||s.r!==0)return!1
return!0},
l5(a,b,c){var s,r,q,p,o,n,m=this
if(!m.ghs())return!1
s=m.e
if(!(s<4))return A.a(B.cc,s)
r=B.cc[s]
if(m.d===0){s=m.b
q=a*s
p=m.a
B.d.ar(c,q,q+b*s,p.a,p.d-p.b+q)}else{s=a+b
p=m.x
p===$&&A.c("_vp8l")
p.dx=c
o=p.c
if(m.y)s=p.iT(o.a,o.b,s)
else{n=p.cx
n.toString
p=p.dO(n,o.a,o.b,s,t.kX.a(p.glh()))
s=p}if(!s)return!1}if(r!=null){s=m.b
r.$6(s,m.c,s,a,b,c)}if(m.f===1)if(!m.jh(c,m.b,m.c,a,b))return!1
if(a+b>=m.c)m.w=!0
return!0},
jh(a,b,c,d,e){if(b<=0||c<=0||d<0||e<0||d+e>c)return!1
return!0}}
A.bO.prototype={
hI(a){var s,r
a.a5(A.mP(this.a))
s=this.b
r=s.length
a.J(r)
a.a5(s)
if((r&1)===1)a.m(0)}}
A.f6.prototype={
io(a,b){var s=this,r=a.I()
s.w=0
s.f=(r&1)!==0
s.r=(r&2)===0
s.x=a.d-a.b
s.y=b-16}}
A.hj.prototype={}
A.fV.prototype={}
A.fW.prototype={}
A.e8.prototype={
gA(a){return this.a.length-this.b}}
A.e7.prototype={
cq(a,b){var s,r,q,p,o,n=b.d1()&255,m=this.a
if(!(a<m.length))return A.a(m,a)
s=m[a]
r=s.a
q=s.b+n
if(!(q<r.length))return A.a(r,q)
p=r[q].a-8
if(p>0){b.a+=8
o=b.d1()
m=m[a]
s=m.a
r=m.b+n
if(!(r<s.length))return A.a(s,r)
n=n+s[r].b+((o&B.a.V(1,p)-1)>>>0)}else m=s
s=b.a
r=m.a
m=m.b+n
if(!(m>=0&&m<r.length))return A.a(r,m)
m=r[m]
b.a=s+m.a
return m.b}}
A.e9.prototype={}
A.fY.prototype={
eC(a){var s=this.b=this.a,r=A.lT(a)
s.e=a
s.b=s.a=r}}
A.dE.prototype={
a7(){return"WebPFormat."+this.b}}
A.dF.prototype={$iM:1}
A.ei.prototype={}
A.ki.prototype={
bB(a){var s=A.w(t.L.a(a),!1,null,0)
this.b=s
if(!this.fa(s))return!1
return!0},
b7(a){var s,r=this,q=null,p=A.w(t.L.a(a),!1,q,0)
r.b=p
if(!r.fa(p))return q
p=new A.ei(B.a9,A.j([],t.J))
r.a=p
s=r.b
s.toString
if(!r.fR(s,p))return q
p=r.a
switch(p.f.a){case 3:p.as=p.z.length
return p
case 2:s=r.b
s.toString
s.d=p.ay
if(!A.mo(s,p).cX())return q
p=r.a
p.as=p.z.length
return p
case 1:s=r.b
s.toString
s.d=p.ay
if(!A.mm(s,p).cX())return q
p=r.a
p.as=p.z.length
return p
case 0:throw A.h(A.n("Unknown format for WebP"))}},
aq(a){var s,r,q,p=this,o=p.b
if(o==null||p.a==null)return null
s=p.a
if(s.e){s=s.z
r=s.length
if(a>=r)return null
if(!(a<r))return A.a(s,a)
q=s[a]
s=q.y
s===$&&A.c("_frameSize")
r=q.x
r===$&&A.c("_framePosition")
return p.f_(o.cb(s,r),a)}r=s.f
if(r===B.aB)return A.mo(o.cb(s.ch,s.ay),s).bT()
else if(r===B.b3)return A.mm(o.cb(s.ch,s.ay),s).bT()
return null},
b9(a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=null
if(a1.b7(t.L.a(a3))==null)return a2
s=a1.a.e
if(!s)return a1.aq(0)
for(s=t.N,r=t.P,q=a2,p=q,o=p,n=0;m=a1.a,n<m.as;++n){m=m.z
if(!(n<m.length))return A.a(m,n)
a4=m[n]
l=a1.aq(n)
if(l==null)continue
m=a4.e
l.y=m
if(o==null||p==null){k=a1.a
j=k.a
k=k.b
i=l.gal()
h=l.a
h=h==null?a2:h.gM()
if(h==null)h=B.e
g=l.y
f=a1.a
e=f.y
d=f.c
f=f.w
if(f.length===0)f=a2
else{f=new A.af(f)
c=f.gA(0)
b=f.gA(0)
a=new A.by(A.I(s,r))
a.c9(new A.ad(f,0,Math.min(c,b),0,!1))
f=a}a0=a1.a.r
o=A.Q(d,f,h,g,B.j,k,a0==null?a2:new A.bB("",B.S,a0),e,i,a2,B.e,j,!1)
p=o}else{p=A.bF(p,!1,!1)
if(q!=null){k=q.f
k===$&&A.c("clearFrame")}else k=!1
if(k){k=q.a
j=q.b
i=q.c
h=q.d
A.oz(p,!1,$.oZ(),k,k+i-1,j,j+h-1)}}p.y=m
m=a4.r
m===$&&A.c("blendFrame")
m=m?B.aD:B.ab
A.mF(p,l,m,a2,a2,a4.a,a4.b,a2,a2,a2,a2)
if(p!==o)o.aN(p)
q=a4}return o},
f_(a,b){var s,r,q,p=null,o=A.j([],t.J),n=new A.ei(B.a9,o)
if(!this.fR(a,n))return p
s=n.f
if(s===B.a9)return p
n.as=this.a.as
if(n.e){s=o.length
if(b>=s)return p
r=o[b]
o=r.y
o===$&&A.c("_frameSize")
s=r.x
s===$&&A.c("_framePosition")
return this.f_(a.cb(o,s),b)}else{q=a.cb(n.ch,n.ay)
if(s===B.aB)return A.mo(q,n).bT()
else if(s===B.b3)return A.mm(q,n).bT()}return p},
fa(a){if(a.ao(4)!=="RIFF")return!1
a.k()
if(a.ao(4)!=="WEBP")return!1
return!0},
fR(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g
for(s=a.c,r=a.b;a.d<s;){q=a.ao(4)
p=a.k()
o=p+1>>>1<<1>>>0
n=a.d
m=n-r
switch(q){case"VP8X":if(!this.jH(a,b))return!1
break
case"VP8 ":b.ay=m
b.ch=p
b.f=B.b3
break
case"VP8L":b.ay=m
b.ch=p
b.f=B.aB
break
case"ALPH":b.toString
n=a.a
l=a.e
k=J.ab(n)
j=k.gA(n)
k=k.gA(n)
n=new A.ad(n,0,Math.min(j,k),0,l)
b.at=n
n.d=a.d
a.d+=o
break
case"ANIM":b.f=B.m2
i=a.k()
n=new Uint8Array(4)
n[0]=i>>>16&255
n[1]=i>>>8&255
n[2]=i&255
n[3]=i>>>24&255
b.c=new A.ce(n)
b.y=a.q()
break
case"ANMF":if(!this.jC(a,b,p))return!1
break
case"ICCP":b.toString
h=a.aA(p)
a.d=n+(h.c-h.d)
b.r=h.a4()
break
case"EXIF":b.toString
b.w=a.ao(p)
break
case"XMP ":b.toString
a.ao(p)
break
default:a.d=n+o
break}n=a.d
g=o-(n-r-m)
if(g>0)a.d=n+g}if(!b.d)b.d=b.at!=null
return b.f!==B.a9},
jH(a,b){var s,r,q,p,o=a.I()
if((o&192)!==0)return!1
s=B.a.j(o,4)
r=B.a.j(o,1)
if((o&1)!==0)return!1
if(a.bu()!==0)return!1
q=a.bu()
p=a.bu()
b.a=q+1
b.b=p+1
b.e=(r&1)!==0
b.d=(s&1)!==0
return!0},
jC(a,b,c){var s=new A.hj(a.bu()*2,a.bu()*2,a.bu()+1,a.bu()+1,a.bu())
s.io(a,c)
if(s.w!==0)return!1
B.c.C(b.z,s)
return!0}}
A.kj.prototype={
bI(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=a.gab().length>1
if(b)A.re(a)
s=A.rf(a)
r=A.rh(a)
q=this.f5(a)
p=q.length>1
if(!b&&s==null&&r==null&&!p)return A.ot(q)
o=r!=null
n=p||A.rg(a)
m=s!=null
l=o?32:0
n=n?16:0
k=m?8:0
j=b?2:0
i=a.gS()
h=a.gK()
g=A.Y(!1,8192)
g.m(l|n|k|j|0)
g.m(0)
g.m(0)
g.m(0)
A.dO(g,i-1)
A.dO(g,h-1)
f=A.j([new A.bO("VP8X",J.B(B.d.gB(g.c),0,g.a))],t.iu)
if(o)B.c.C(f,new A.bO("ICCP",r))
if(b){e=a.f
o=A.kk(e,new A.kl())
n=A.kk(e,new A.km())
l=A.kk(e,new A.kn())
k=A.kk(e,new A.ko())
j=a.r
g=A.Y(!1,8192)
g.J((k<<24|o<<16|n<<8|l)>>>0)
g.a1(B.a.G(j,0,65535))
B.c.C(f,new A.bO("ANIM",J.B(B.d.gB(g.c),0,g.a)))
for(o=a.gab(),n=o.length,d=0;d<o.length;o.length===n||(0,A.K)(o),++d){c=o[d]
l=c.a
k=l==null
j=k?null:l.a
if(j==null)j=0
l=k?null:l.b
if(l==null)l=0
k=c.y
B.c.C(f,new A.bO("ANMF",A.tS(!1,!0,k,c===a?q:this.f5(c),l,j,0,0)))}}else B.c.cw(f,q)
if(m)B.c.C(f,new A.bO("EXIF",s))
return A.ot(f)},
f5(a){var s=A.j([new A.bO("VP8L",new A.ka(!0).lg(a))],t.iu)
return s}}
A.kl.prototype={
$1(a){var s=a.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
$S:6}
A.km.prototype={
$1(a){return a.gt()},
$S:6}
A.kn.prototype={
$1(a){return a.gu()},
$S:6}
A.ko.prototype={
$1(a){return a.gv()},
$S:6}
A.fZ.prototype={
a7(){return"IccProfileCompression."+this.b}}
A.bB.prototype={
l2(){var s,r=this
if(r.b===B.aL)return r.c
s=B.b8.hm(t.L.a(r.c),null)
r.c=s
r.b=B.aL
return s},
hi(){var s,r=this
if(r.b===B.S)return r.c
s=B.H.c6(r.c)
r.c=s
r.b=B.S
return s}}
A.fU.prototype={
a7(){return"FrameType."+this.b}}
A.bl.prototype={
gab(){var s=this.x
return s===$?this.x=A.j([],t.g):s},
ih(a,b,c,d){var s,r,q,p=this,o=a.gM(),n=a.gal(),m=a.a
p.eY(d,b,o,n,m==null?null:m.gO())
o=a.b
if(o!=null)p.b=A.en(o,t.N,t.w)
o=a.d
if(o!=null){n=t.N
p.d=A.en(o,n,n)}B.c.C(p.gab(),p)
if(!c){s=a.gab().length
for(o=t.g,r=1;r<s;++r){q=a.x
if(q===$)q=a.x=A.j([],o)
if(!(r<q.length))return A.a(q,r)
p.aN(A.h3(q[r],b,!1,d))}}},
ig(a,b,c){var s,r,q,p,o=this,n=a.b
if(n!=null)o.b=A.en(n,t.N,t.w)
n=a.d
if(n!=null){s=t.N
o.d=A.en(n,s,s)}B.c.C(o.gab(),o)
if(!b&&a.gab().length>1){r=a.gab().length
for(n=t.g,q=1;q<r;++q){p=a.x
if(p===$)p=a.x=A.j([],n)
if(!(q<p.length))return A.a(p,q)
o.aN(A.bF(p[q],!1,!1))}}},
aN(a){var s=this
if(a==null)a=A.bF(s,!0,!0)
a.z=s.gab().length
if(s.gab().length===0||B.c.geg(s.gab())!==a)B.c.C(s.gab(),a)
return a},
dw(){return this.aN(null)},
eY(a,b,c,d,e){var s,r,q=this,p=null
switch(c.a){case 0:if(e==null){s=B.b.bc(a*d/8)
r=new A.db($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bc(a/8)
r=new A.db($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 1:if(e==null){s=B.b.bc(a*(d<<1>>>0)/8)
r=new A.dd($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bc(a/4)
r=new A.dd($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 2:if(e==null){if(d===2)s=a
else if(d===4)s=a*2
else s=d===3?B.b.bc(a*1.5):B.b.bc(a/2)
r=new A.df($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bc(a/2)
r=new A.df($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 3:if(e==null)q.a=A.np(a,b,d)
else q.a=new A.dg(new Uint8Array(a*b),e,a,b,1)
break
case 4:s=a*b
if(e==null)q.a=new A.dc(new Uint16Array(s*d),p,a,b,d)
else q.a=new A.dc(new Uint16Array(s),e,a,b,1)
break
case 5:q.a=A.pM(a,b,d)
break
case 6:q.a=new A.ee(new Int8Array(a*b*d),a,b,d)
break
case 7:q.a=new A.ec(new Int16Array(a*b*d),a,b,d)
break
case 8:q.a=new A.ed(new Int32Array(a*b*d),a,b,d)
break
case 9:q.a=A.pK(a,b,d)
break
case 10:q.a=A.pL(a,b,d)
break
case 11:q.a=new A.eb(new Float64Array(a*b*4*d),a,b,d)
break}},
D(a){var s=this
return"Image("+s.gS()+", "+s.gK()+", "+s.gM().b+", "+s.gal()+")"},
gS(){var s=this.a
s=s==null?null:s.a
return s==null?0:s},
gK(){var s=this.a
s=s==null?null:s.b
return s==null?0:s},
gM(){var s=this.a
s=s==null?null:s.gM()
return s==null?B.e:s},
gbp(){var s=this.e
return s==null?this.e=new A.by(A.I(t.N,t.P)):s},
hQ(a,b){var s=this,r=s.b;(r==null?s.b=A.I(t.N,t.w):r).h(0,a,b)
if(s.b.a===0)s.b=null},
gH(a){var s=this.a
return s.gH(s)},
gB(a){var s=this.a
s=s==null?null:s.gB(s)
if(s==null)s=B.d.gB(new Uint8Array(0))
return s},
a4(){var s=this.a
s=s==null?null:J.aA(s.gB(s))
return s==null?J.aA(this.gB(0)):s},
gd_(a){var s=this.a
s=s==null?null:J.pe(s.gB(s))
return s==null?0:s},
gal(){var s=this.a
s=s==null?null:s.gO()
s=s==null?null:s.b
if(s==null){s=this.a
s=s==null?null:s.c}return s==null?0:s},
gb2(){var s=this.a
s=s==null?null:s.gb2()
return s===!0},
gaP(){var s=this.a
return(s==null?null:s.gO())!=null},
gaO(){var s=this.a
s=s==null?null:s.gaO()
return s==null?0:s},
hr(a,b){return a>=0&&b>=0&&a<this.gS()&&b<this.gK()},
b3(a,b,c,d){var s=this.a
s=s==null?null:s.b3(a,b,c,d)
if(s==null)s=new A.b3(new Uint8Array(0))
return s},
P(a,b,c){var s=this.a
s=s==null?null:s.P(a,b,c)
return s==null?new A.F():s},
aR(a,b){return this.P(a,b,null)},
aw(a,b){if(a<0||a>=this.gS()||b<0||b>=this.gK())return new A.F()
return this.P(a,b,null)},
hL(a,b,c){switch(c.a){case 0:return this.aw(B.b.i(a),B.b.i(b))
case 1:case 3:return this.hM(a,b)
case 2:return this.hK(a,b)}},
hM(a,b){var s,r,q,p,o,n,m=this,l=B.b.i(a),k=l-(a>=0?0:1),j=k+1
l=B.b.i(b)
s=l-(b>=0?0:1)
r=s+1
l=new A.j8(a-k,b-s)
q=m.aw(k,s)
p=r>=m.gK()?q:m.aw(k,r)
o=j>=m.gS()?q:m.aw(j,s)
n=j>=m.gS()||r>=m.gK()?q:m.aw(j,r)
return m.b3(l.$4(q.gn(),o.gn(),p.gn(),n.gn()),l.$4(q.gt(),o.gt(),p.gt(),n.gt()),l.$4(q.gu(),o.gu(),p.gu(),n.gu()),l.$4(q.gv(),o.gv(),p.gv(),n.gv()))},
hK(d2,d3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6=this,c7=B.b.i(d2),c8=c7-(d2>=0?0:1),c9=c8-1,d0=c8+1,d1=c8+2
c7=B.b.i(d3)
s=c7-(d3>=0?0:1)
r=s-1
q=s+1
p=s+2
o=d2-c8
n=d3-s
c7=new A.j7()
m=c6.aw(c8,s)
l=c9<0
k=!l
j=!k||r<0?m:c6.aw(c9,r)
i=l?m:c6.aw(c8,r)
h=r<0
g=h||d0>=c6.gS()?m:c6.aw(d0,r)
f=d1>=c6.gS()||h?m:c6.aw(d1,r)
e=c7.$5(o,j.gn(),i.gn(),g.gn(),f.gn())
d=c7.$5(o,j.gt(),i.gt(),g.gt(),f.gt())
c=c7.$5(o,j.gu(),i.gu(),g.gu(),f.gu())
b=c7.$5(o,j.gv(),i.gv(),g.gv(),f.gv())
a=l?m:c6.aw(c9,s)
a0=d0>=c6.gS()?m:c6.aw(d0,s)
a1=d1>=c6.gS()?m:c6.aw(d1,s)
a2=c7.$5(o,a.gn(),m.gn(),a0.gn(),a1.gn())
a3=c7.$5(o,a.gt(),m.gt(),a0.gt(),a1.gt())
a4=c7.$5(o,a.gu(),m.gu(),a0.gu(),a1.gu())
a5=c7.$5(o,a.gv(),m.gv(),a0.gv(),a1.gv())
a6=!k||q>=c6.gK()?m:c6.aw(c9,q)
a7=q>=c6.gK()?m:c6.aw(c8,q)
a8=d0>=c6.gS()||q>=c6.gK()?m:c6.aw(d0,q)
a9=d1>=c6.gS()||q>=c6.gK()?m:c6.aw(d1,q)
b0=c7.$5(o,a6.gn(),a7.gn(),a8.gn(),a9.gn())
b1=c7.$5(o,a6.gt(),a7.gt(),a8.gt(),a9.gt())
b2=c7.$5(o,a6.gu(),a7.gu(),a8.gu(),a9.gu())
b3=c7.$5(o,a6.gv(),a7.gv(),a8.gv(),a9.gv())
b4=!k||p>=c6.gK()?m:c6.aw(c9,p)
b5=p>=c6.gK()?m:c6.aw(c8,p)
b6=d0>=c6.gS()||p>=c6.gK()?m:c6.aw(d0,p)
b7=d1>=c6.gS()||p>=c6.gK()?m:c6.aw(d1,p)
b8=c7.$5(o,b4.gn(),b5.gn(),b6.gn(),b7.gn())
b9=c7.$5(o,b4.gt(),b5.gt(),b6.gt(),b7.gt())
c0=c7.$5(o,b4.gu(),b5.gu(),b6.gu(),b7.gu())
c1=c7.$5(o,b4.gv(),b5.gv(),b6.gv(),b7.gv())
c2=c7.$5(n,e,a2,b0,b8)
c3=c7.$5(n,d,a3,b1,b9)
c4=c7.$5(n,c,a4,b2,c0)
c5=c7.$5(n,b,a5,b3,c1)
return c6.b3(B.b.i(c2),B.b.i(c3),B.b.i(c4),B.b.i(c5))},
ca(a,b,c){var s
if(t.mK.b(c))if(c.gbe().gO()!=null)if(this.gaP()){s=this.a
if(s!=null)s.aa(a,b,c.gU(),0,0)
return}s=this.a
if(s!=null)s.az(a,b,c.gn(),c.gt(),c.gu(),c.gv())},
hR(a,b,c){var s=this.a
return s==null?null:s.aK(a,b,c)},
aa(a,b,c,d,e){var s=this.a
return s==null?null:s.aa(a,b,c,d,e)},
gF(){var s=this.a
s=s==null?null:s.gF()
return s==null?0:s},
b5(a,b){var s=this.a
return s==null?null:s.b5(0,b)},
dA(a){return this.b5(0,null)},
cV(a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=this,a7=null
if(a9==null)a9=a6.gM()
if(b0==null)b0=a6.gal()
s=a8==null
if(s)a8=B.ci.l(0,a9)
r=!1
if(a9===a6.gM())if(b0===a6.gal()){if(!b1){q=a6.a
q=(q==null?a7:q.gO())==null}else q=!1
if(!q){if(b1){r=a6.a
r=(r==null?a7:r.gO())!=null}}else r=!0}if(r){p=A.bF(a6,!1,!1)
if(!s)s=p.gal()===2||p.gal()===4
else s=!1
if(s)for(s=p.gab(),r=s.length,o=0;o<s.length;s.length===r||(0,A.K)(s),++o)for(q=s[o].a,q=q.gH(q);q.E();){n=q.gN()
a8.toString
n.sv(a8)}return p}for(s=a6.gab(),r=s.length,q=t.N,m=t.p,l=a7,o=0;o<s.length;s.length===r||(0,A.K)(s),++o,l=c){k=s[o]
j=k.a
i=j==null
h=i?a7:j.a
if(h==null)h=0
j=i?a7:j.b
if(j==null)j=0
i=k.e
i=i==null?a7:A.dZ(i)
g=k.c
if(g==null)g=a7
else{f=g.a
e=g.b
g=g.c
g=new A.bB(f,e,new Uint8Array(g.subarray(0,A.bd(0,a7,g.length))))}f=k.f
f=f==null?a7:new A.b3(new Uint8Array(A.q(f.a)))
e=k.w
d=k.r
p=A.Q(f,i,a9,k.y,e,j,g,d,b0,a7,B.e,h,b1)
j=k.d
p.slO(j!=null?A.en(j,q,q):a7)
if(l!=null){l.aN(p)
c=l}else c=p
j=p.a
b=j==null?a7:j.gO()
j=p.a
j=j==null?a7:j.gO()
a=j==null?a7:j.gM()
if(a==null)a=a9
j=k.a
if(b!=null){a0=A.I(m,m)
a1=j==null?a7:j.P(0,0,a7)
if(a1==null)a1=new A.F()
for(j=p.a,j=j.gH(j),a2=a7,a3=0;j.E();){a4=j.gN()
a5=A.oH(B.b.bq(a1.gai()*255),B.b.bq(a1.gae()*255),B.b.bq(a1.gah()*255),0)
if(a0.a9(a5)){i=a0.l(0,a5)
i.toString
a4.sU(i)}else{a0.h(0,a5,a3)
a4.sU(a3)
a2=A.aG(a1,a8,a,b0,a2)
b.b4(a3,a2.gn(),a2.gt(),a2.gu());++a3}a1.E()}}else{a1=j==null?a7:j.P(0,0,a7)
if(a1==null)a1=new A.F()
for(j=p.a,j=j.gH(j);j.E();){A.aG(a1,a8,a7,a7,j.gN())
a1.E()}}}l.toString
return l},
aS(a){return this.cV(null,a,null,!1)},
ec(a){return this.cV(null,null,a,!1)},
l3(a,b,c){return this.cV(null,a,b,c)},
cl(a,b){return this.cV(null,a,null,b)},
cU(a,b){return this.cV(null,a,b,!1)},
kY(a){var s,r,q,p
t.je.a(a)
if(this.d==null){s=t.N
this.d=A.I(s,s)}for(s=new A.R(a,a.r,a.e,A.l(a).p("R<1>"));s.E();){r=s.d
q=this.d
q.toString
p=a.l(0,r)
p.toString
q.h(0,r,p)}},
iN(a,b,c){var s,r=65536
switch(b.a){case 0:return null
case 1:return null
case 2:return null
case 3:s=a===B.n?r:256
return new A.aN(new Uint8Array(s*c),s,c)
case 4:s=a===B.n?r:256
return new A.eH(new Uint16Array(s*c),s,c)
case 5:s=a===B.n?r:256
return new A.dp(new Uint32Array(s*c),s,c)
case 6:s=a===B.n?r:256
return new A.eG(new Int8Array(s*c),s,c)
case 7:s=a===B.n?r:256
return new A.eE(new Int16Array(s*c),s,c)
case 8:s=a===B.n?r:256
return new A.eF(new Int32Array(s*c),s,c)
case 9:s=a===B.n?r:256
return new A.eB(new Uint16Array(s*c),s,c)
case 10:s=a===B.n?r:256
return new A.eC(new Float32Array(s*c),s,c)
case 11:s=a===B.n?r:256
return new A.eD(new Float64Array(s*c),s,c)}},
slO(a){this.d=t.lG.a(a)}}
A.j8.prototype={
$4(a,b,c,d){var s=this.b
return a+this.a*(b-a+s*(a+d-c-b))+s*(c-a)},
$S:33}
A.j7.prototype={
$5(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
$S:34}
A.ah.prototype={
gO(){return null}}
A.d9.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Uint16Array(r.length)
else r=new Uint16Array(A.q(r))
return new A.d9(r,s.a,s.b,s.c)},
gM(){return B.I},
gbr(){return B.aK},
gB(a){return B.C.gB(this.d)},
gaO(){return 16},
gbf(){return this.a*this.c*2},
gH(a){return A.m2(this)},
bg(a,b,c,d,e){return A.ba(A.m2(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gF(){return 1},
gb2(){return!0},
b3(a,b,c,d){var s=new Uint16Array(4),r=new A.cU(s)
s[0]=A.L(a)
s[1]=A.L(b)
s[2]=A.L(c)
s[3]=A.L(d)
s=r
return s},
P(a,b,c){if(c==null||!(c instanceof A.ct)||c.d!==this)c=A.m2(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=A.L(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.L(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=A.L(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=A.L(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.L(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=A.L(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=A.L(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=A.L(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataFloat16("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.da.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Float32Array(r.length)
else r=new Float32Array(A.q(r))
return new A.da(r,s.a,s.b,s.c)},
gM(){return B.Q},
gbr(){return B.aK},
gB(a){return B.a6.gB(this.d)},
gaO(){return 32},
gH(a){return A.m3(this)},
bg(a,b,c,d,e){return A.ba(A.m3(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gF(){return 1},
gbf(){return this.a*this.c*4},
gb2(){return!0},
b3(a,b,c,d){var s=new Float32Array(4),r=new A.cV(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
P(a,b,c){if(c==null||!(c instanceof A.cu)||c.d!==this)c=A.m3(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s=this.c,r=b*this.a*s+a*s
s=this.d
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q>1){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
if(q>2){q=p+2
if(!(q<s))return A.a(o,q)
o[q]=e}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q>1){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
if(q>2){r=p+2
if(!(r<s))return A.a(o,r)
o[r]=e
if(q>3){q=p+3
if(!(q<s))return A.a(o,q)
o[q]=f}}}},
D(a){return"ImageDataFloat32("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.eb.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Float64Array(r.length)
else r=new Float64Array(A.q(r))
return new A.eb(r,s.a,s.b,s.c)},
gM(){return B.T},
gbr(){return B.aK},
gB(a){return B.q.gB(this.d)},
gA(a){return this.d.byteLength},
gaO(){return 64},
gH(a){return A.m4(this)},
bg(a,b,c,d,e){return A.ba(A.m4(this),b,c,d,e)},
gF(){return 1},
gbf(){return this.a*this.c*8},
gb2(){return!0},
b3(a,b,c,d){var s=new Float64Array(4),r=new A.cW(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
P(a,b,c){if(c==null||!(c instanceof A.cv)||c.d!==this)c=A.m4(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s=this.c,r=b*this.a*s+a*s
s=this.d
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q>1){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
if(q>2){q=p+2
if(!(q<s))return A.a(o,q)
o[q]=e}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q>1){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
if(q>2){r=p+2
if(!(r<s))return A.a(o,r)
o[r]=e
if(q>3){q=p+3
if(!(q<s))return A.a(o,q)
o[q]=f}}}},
D(a){return"ImageDataFloat64("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.ec.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Int16Array(r.length)
else r=new Int16Array(A.q(r))
return new A.ec(r,s.a,s.b,s.c)},
gM(){return B.V},
gbr(){return B.aJ},
gB(a){return B.ay.gB(this.d)},
gH(a){return A.m5(this)},
bg(a,b,c,d,e){return A.ba(A.m5(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gF(){return 32767},
gb2(){return!0},
gaO(){return 16},
gbf(){return this.a*this.c*2},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int16Array(4),n=new A.cX(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cw)||c.d!==this)c=A.m5(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=B.b.i(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=B.b.i(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=B.b.i(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataInt16("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.ed.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Int32Array(r.length)
else r=new Int32Array(A.q(r))
return new A.ed(r,s.a,s.b,s.c)},
gM(){return B.W},
gbr(){return B.aJ},
gB(a){return B.z.gB(this.d)},
gaO(){return 32},
gbf(){return this.a*this.c*4},
gH(a){return A.m6(this)},
bg(a,b,c,d,e){return A.ba(A.m6(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gF(){return 2147483647},
gb2(){return!0},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int32Array(4),n=new A.cY(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cx)||c.d!==this)c=A.m6(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=B.b.i(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=B.b.i(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=B.b.i(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataInt32("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.ee.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Int8Array(r.length)
else r=new Int8Array(A.q(r))
return new A.ee(r,s.a,s.b,s.c)},
gM(){return B.U},
gbr(){return B.aJ},
gB(a){return B.az.gB(this.d)},
gbf(){return this.a*this.c},
gH(a){return A.m7(this)},
bg(a,b,c,d,e){return A.ba(A.m7(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gF(){return 127},
gb2(){return!0},
gaO(){return 8},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int8Array(4),n=new A.cZ(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cy)||c.d!==this)c=A.m7(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=B.b.i(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=B.b.i(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=B.b.i(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataInt8("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.db.prototype={
m_(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.iC("data")
this.d=s},
bn(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.q(q))}s=r.f
s=s==null?null:s.X()
return new A.db(q,r.e,s,r.a,r.b,r.c)},
gM(){return B.A},
gbr(){return B.P},
gA(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gF(){var s=this.f
s=s==null?null:s.gF()
return s==null?1:s},
gb2(){return!1},
gB(a){var s=this.d
s===$&&A.c("data")
return B.d.gB(s)},
gaO(){return 1},
gH(a){return A.eI(this)},
bg(a,b,c,d,e){return A.ba(A.eI(this),b,c,d,e)},
b3(a,b,c,d){var s=new A.d_(4,0)
s.ag(B.b.i(a),B.b.i(b),B.b.i(c),B.b.i(d))
return s},
P(a,b,c){if(c==null||!(c instanceof A.cz)||c.f!==this)c=A.eI(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eI(r):s).a6(a,b)
r.r.aC(0,c)},
aa(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eI(r):s).a6(a,b)
r.r.aB(c,d,e)},
az(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eI(r):s).a6(a,b)
r.r.ag(c,d,e,f)},
D(a){return"ImageDataUint1("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gbf(){return this.e},
gO(){return this.f}}
A.dc.prototype={
bn(a){var s,r=this,q=r.d
if(a)q=new Uint16Array(q.length)
else q=new Uint16Array(A.q(q))
s=r.e
s=s==null?null:s.X()
return new A.dc(q,s,r.a,r.b,r.c)},
gM(){return B.n},
gbr(){return B.P},
gB(a){return B.C.gB(this.d)},
gaO(){return 16},
gF(){var s=this.e
s=s==null?null:s.gF()
return s==null?65535:s},
gbf(){return this.a*this.c*2},
gH(a){return A.m8(this)},
bg(a,b,c,d,e){return A.ba(A.m8(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gb2(){return!0},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Uint16Array(4),n=new A.d0(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cA)||c.d!==this)c=A.m8(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=B.b.i(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=B.b.i(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=B.b.i(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataUint16("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gO(){return this.e}}
A.dd.prototype={
m0(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.iC("data")
this.d=s},
bn(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.q(q))}s=r.f
s=s==null?null:s.X()
return new A.dd(q,r.e,s,r.a,r.b,r.c)},
gM(){return B.u},
gbr(){return B.P},
gaO(){return 2},
gB(a){var s=this.d
s===$&&A.c("data")
return B.d.gB(s)},
gH(a){return A.eJ(this)},
bg(a,b,c,d,e){return A.ba(A.eJ(this),b,c,d,e)},
gA(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gF(){var s=this.f
s=s==null?null:s.gF()
return s==null?3:s},
gb2(){return!1},
b3(a,b,c,d){var s=new A.d1(4,0)
s.ag(B.b.i(a),B.b.i(b),B.b.i(c),B.b.i(d))
return s},
P(a,b,c){if(c==null||!(c instanceof A.cB)||c.f!==this)c=A.eJ(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eJ(r):s).a6(a,b)
r.r.aD(0,c)},
aa(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eJ(r):s).a6(a,b)
r.r.aB(c,d,e)},
az(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eJ(r):s).a6(a,b)
r.r.ag(c,d,e,f)},
D(a){return"ImageDataUint2("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gbf(){return this.e},
gO(){return this.f}}
A.de.prototype={
bn(a){var s=this,r=s.d
if(a)r=new Uint32Array(r.length)
else r=new Uint32Array(A.q(r))
return new A.de(r,s.a,s.b,s.c)},
gM(){return B.R},
gbr(){return B.P},
gB(a){return B.o.gB(this.d)},
gbf(){return this.a*this.c*4},
gaO(){return 32},
gF(){return 4294967295},
gH(a){return A.m9(this)},
bg(a,b,c,d,e){return A.ba(A.m9(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gb2(){return!0},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Uint32Array(4),n=new A.d2(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cC)||c.d!==this)c=A.m9(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=B.b.i(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=B.b.i(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=B.b.i(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataUint32("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.df.prototype={
m1(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.iC("data")
this.d=s},
bn(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.q(q))}s=r.f
s=s==null?null:s.X()
return new A.df(q,r.e,s,r.a,r.b,r.c)},
gM(){return B.B},
gbr(){return B.P},
gB(a){var s=this.d
s===$&&A.c("data")
return B.d.gB(s)},
gH(a){return A.eK(this)},
bg(a,b,c,d,e){return A.ba(A.eK(this),b,c,d,e)},
gA(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gF(){var s=this.f
s=s==null?null:s.gF()
return s==null?15:s},
gb2(){return!1},
gaO(){return 4},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new A.d3(4,new Uint8Array(2))
o.ag(s,r,q,p)
s=o
return s},
P(a,b,c){if(c==null||!(c instanceof A.cD)||c.e!==this)c=A.eK(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eK(r):s).a6(a,b)
r.r.aE(0,c)},
aa(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eK(r):s).a6(a,b)
r.r.aB(c,d,e)},
az(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eK(r):s).a6(a,b)
r.r.ag(c,d,e,f)},
D(a){return"ImageDataUint4("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gbf(){return this.e},
gO(){return this.f}}
A.dg.prototype={
bn(a){var s,r=this,q=r.d
if(a)q=new Uint8Array(q.length)
else q=new Uint8Array(A.q(q))
s=r.e
s=s==null?null:s.X()
return new A.dg(q,s,r.a,r.b,r.c)},
gM(){return B.e},
gbr(){return B.P},
gB(a){return B.d.gB(this.d)},
gbf(){return this.a*this.c},
gaO(){return 8},
gH(a){return A.jz(this)},
bg(a,b,c,d,e){return A.ba(A.jz(this),b,c,d,e)},
gA(a){return this.d.byteLength},
gF(){var s=this.e
s=s==null?null:s.gF()
return s==null?255:s},
gb2(){return!1},
b3(a,b,c,d){var s=A.n7(B.b.i(B.b.G(a,0,255)),B.b.i(B.b.G(b,0,255)),B.b.i(B.b.G(c,0,255)),B.b.i(B.b.G(d,0,255)))
return s},
P(a,b,c){if(c==null||!(c instanceof A.cE)||c.d!==this)c=A.jz(this)
c.a6(a,b)
return c},
aR(a,b){return this.P(a,b,null)},
aK(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=B.b.i(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
az(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=B.b.i(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=B.b.i(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=B.b.i(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataUint8("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=b==null?g:A.aG(b,g,B.e,g,g),e=h.c
if(e===1){s=f==null?0:B.a.G(A.m(f.gn()),0,255)
e=h.d
B.d.ac(e,0,e.length,s)}else if(e===2){e=f==null
s=e?0:B.a.G(A.m(f.gn()),0,255)
r=e?0:B.a.G(A.m(f.gt()),0,255)
q=J.mX(B.d.gB(h.d),0,null)
B.C.ac(q,0,q.length,(r<<8|s)>>>0)}else if(e===4){e=f==null
s=e?0:B.a.G(A.m(f.gn()),0,255)
r=e?0:B.a.G(A.m(f.gt()),0,255)
p=e?0:B.a.G(A.m(f.gu()),0,255)
o=e?0:B.a.G(A.m(f.gv()),0,255)
n=J.Z(B.d.gB(h.d),0,null)
B.o.ac(n,0,n.length,(o<<24|p<<16|r<<8|s)>>>0)}else{e=f==null
s=e?0:B.a.G(A.m(f.gn()),0,255)
r=e?0:B.a.G(A.m(f.gt()),0,255)
p=e?0:B.a.G(A.m(f.gu()),0,255)
for(m=A.jz(h),e=m.d,l=e.c>0,e=e.d,k=e.$flags|0;m.E();){if(l){j=m.c
i=B.b.i(B.a.G(s,0,255))
k&2&&A.b(e)
if(!(j>=0&&j<e.length))return A.a(e,j)
e[j]=i}m.st(r)
m.su(p)}}},
gO(){return this.e}}
A.hk.prototype={
a7(){return"Interpolation."+this.b}}
A.aV.prototype={}
A.eB.prototype={
X(){return new A.eB(new Uint16Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.C.gB(this.c)},
gM(){return B.I},
gF(){return 1},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=A.L(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=A.L(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=A.L(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=A.L(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s,r
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
return r[s]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.U
s=s!=null?s:A.X()
if(!(r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.eC.prototype={
X(){return new A.eC(new Float32Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.a6.gB(this.c)},
gM(){return B.Q},
gF(){return 1},
Z(a,b,c){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c}},
b4(a,b,c,d){var s,r,q,p=this.b
a*=p
s=this.c
s.$flags&2&&A.b(s)
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
s[a]=b
if(p>1){q=a+1
if(!(q<r))return A.a(s,q)
s[q]=c
if(p>2){p=a+2
if(!(p<r))return A.a(s,p)
s[p]=d}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.eD.prototype={
X(){return new A.eD(new Float64Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.q.gB(this.c)},
gM(){return B.T},
gF(){return 1},
Z(a,b,c){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c}},
b4(a,b,c,d){var s,r,q,p=this.b
a*=p
s=this.c
s.$flags&2&&A.b(s)
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
s[a]=b
if(p>1){q=a+1
if(!(q<r))return A.a(s,q)
s[q]=c
if(p>2){p=a+2
if(!(p<r))return A.a(s,p)
s[p]=d}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.eE.prototype={
X(){return new A.eE(new Int16Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.ay.gB(this.c)},
gM(){return B.V},
gF(){return 32767},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.i(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.eF.prototype={
X(){return new A.eF(new Int32Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.z.gB(this.c)},
gM(){return B.W},
gF(){return 2147483647},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.i(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.eG.prototype={
X(){return new A.eG(new Int8Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.az.gB(this.c)},
gM(){return B.U},
gF(){return 127},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.i(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.eH.prototype={
X(){return new A.eH(new Uint16Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.C.gB(this.c)},
gM(){return B.n},
gF(){return 65535},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.i(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.dp.prototype={
X(){return new A.dp(new Uint32Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.o.gB(this.c)},
gM(){return B.R},
gF(){return 4294967295},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.i(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.aN.prototype={
X(){return A.nC(this)},
gB(a){return B.d.gB(this.c)},
gM(){return B.e},
gF(){return 255},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.i(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
d7(a,b,c,d,e){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.a.i(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.a.i(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){r=a+2
p=B.a.i(d)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>3){o=a+3
r=B.a.i(e)
if(!(o<q))return A.a(s,o)
s[o]=r}}}},
aX(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s,r
a*=this.b
s=this.c
r=s.length
if(a>=r)return 0
if(!(a>=0))return A.a(s,a)
return s[a]},
b0(a){var s,r,q=this.b
if(q<2)return 0
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+1
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
b_(a){var s,r,q=this.b
if(q<3)return 0
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+2
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
b6(a){var s,r,q=this.b
if(q<4)return 255
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+3
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
bF(a,b){return this.Z(a,0,b)},
bE(a,b){return this.Z(a,1,b)},
bD(a,b){return this.Z(a,2,b)},
bC(a,b){return this.Z(a,3,b)}}
A.ct.prototype={
X(){var s=this
return new A.ct(s.a,s.b,s.c,s.d)},
gM(){return B.I},
gA(a){return this.d.c},
gO(){return null},
gF(){return 1},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=A.L(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=A.L(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=A.L(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=A.L(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.U
r=r!=null?r:A.X()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=1
return r},
sv(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=A.L(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gai(){return this.gn()/1},
sai(a){this.sn(a)},
gae(){return this.gt()/1},
sae(a){this.st(a)},
gah(){return this.gu()/1},
sah(a){this.su(a)},
ga_(){return this.gv()/1},
sa_(a){this.sv(a)},
gap(){return A.a_(this)},
aj(a){var s=this
if(s.d.c>0){s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())}},
aB(a,b,c){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.L(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){s=p.c+1
r=A.L(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){n=p.c+2
s=A.L(c)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.L(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){s=p.c+1
r=A.L(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){s=p.c+2
r=A.L(c)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>3){n=p.c+3
s=A.L(d)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.ct){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cu.prototype={
X(){var s=this
return new A.cu(s.a,s.b,s.c,s.d)},
gA(a){return this.d.c},
gO(){return null},
gF(){return 1},
gM(){return B.Q},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=c}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=1
return r},
sv(a){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gai(){return this.gn()/1},
sai(a){this.sn(a)},
gae(){return this.gt()/1},
sae(a){this.st(a)},
gah(){return this.gu()/1},
sah(a){this.su(a)},
ga_(){return this.gv()/1},
sa_(a){this.sv(a)},
gap(){return A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.b(p)
s=p.length
if(!(o>=0&&o<s))return A.a(p,o)
p[o]=a
q=q.c
if(q>1){r=o+1
if(!(r<s))return A.a(p,r)
p[r]=b
if(q>2){q=o+2
if(!(q<s))return A.a(p,q)
p[q]=c}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.b(p)
s=p.length
if(!(o>=0&&o<s))return A.a(p,o)
p[o]=a
q=q.c
if(q>1){r=o+1
if(!(r<s))return A.a(p,r)
p[r]=b
if(q>2){r=o+2
if(!(r<s))return A.a(p,r)
p[r]=c
if(q>3){q=o+3
if(!(q<s))return A.a(p,q)
p[q]=d}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cu){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cv.prototype={
X(){var s=this
return new A.cv(s.a,s.b,s.c,s.d)},
gA(a){return this.d.c},
gO(){return null},
gF(){return 1},
gM(){return B.T},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=c}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=1
return r},
sv(a){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gai(){return this.gn()/1},
sai(a){this.sn(a)},
gae(){return this.gt()/1},
sae(a){this.st(a)},
gah(){return this.gu()/1},
sah(a){this.su(a)},
ga_(){return this.gv()/1},
sa_(a){this.sv(a)},
gap(){return A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.b(p)
s=p.length
if(!(o>=0&&o<s))return A.a(p,o)
p[o]=a
q=q.c
if(q>1){r=o+1
if(!(r<s))return A.a(p,r)
p[r]=b
if(q>2){q=o+2
if(!(q<s))return A.a(p,q)
p[q]=c}}},
ag(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.b(p)
s=p.length
if(!(o>=0&&o<s))return A.a(p,o)
p[o]=a
q=q.c
if(q>1){r=o+1
if(!(r<s))return A.a(p,r)
p[r]=b
if(q>2){r=o+2
if(!(r<s))return A.a(p,r)
p[r]=c
if(q>3){q=o+3
if(!(q<s))return A.a(p,q)
p[q]=d}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cv){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cw.prototype={
X(){var s=this
return new A.cw(s.a,s.b,s.c,s.d)},
gA(a){return this.d.c},
gO(){return null},
gF(){return 32767},
gM(){return B.V},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=32767
return r},
sv(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gai(){return this.gn()/32767},
sai(a){this.sn(a*32767)},
gae(){return this.gt()/32767},
sae(a){this.st(a*32767)},
gah(){return this.gu()/32767},
sah(a){this.su(a*32767)},
ga_(){return this.gv()/32767},
sa_(a){this.sv(a*32767)},
gap(){return A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){n=s+2
s=B.a.i(c)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){r=s+2
p=B.a.i(c)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>3){n=s+3
s=B.a.i(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cw){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cx.prototype={
X(){var s=this
return new A.cx(s.a,s.b,s.c,s.d)},
gA(a){return this.d.c},
gO(){return null},
gF(){return 2147483647},
gM(){return B.W},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=2147483647
return r},
sv(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gai(){return this.gn()/2147483647},
sai(a){this.sn(a*2147483647)},
gae(){return this.gt()/2147483647},
sae(a){this.st(a*2147483647)},
gah(){return this.gu()/2147483647},
sah(a){this.su(a*2147483647)},
ga_(){return this.gv()/2147483647},
sa_(a){this.sv(a*2147483647)},
gap(){return A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){n=s+2
s=B.a.i(c)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){r=s+2
p=B.a.i(c)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>3){n=s+3
s=B.a.i(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cx){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cy.prototype={
X(){var s=this
return new A.cy(s.a,s.b,s.c,s.d)},
gA(a){return this.d.c},
gO(){return null},
gF(){return 127},
gM(){return B.U},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=127
return r},
sv(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gai(){return this.gn()/127},
sai(a){this.sn(a*127)},
gae(){return this.gt()/127},
sae(a){this.st(a*127)},
gah(){return this.gu()/127},
sah(a){this.su(a*127)},
ga_(){return this.gv()/127},
sa_(a){this.sv(a*127)},
gap(){return A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){n=s+2
s=B.a.i(c)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){r=s+2
p=B.a.i(c)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>3){n=s+3
s=B.a.i(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cy){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.hB.prototype={
E(){var s=this,r=s.a
if(r.gaZ()+1>s.d){r.a6(s.b,r.gaW()+1)
return r.gaW()<=s.e}return r.E()},
gN(){return this.a},
$iA:1}
A.cz.prototype={
X(){var s=this
return new A.cz(s.a,s.b,s.c,s.d,s.e,s.f)},
gA(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gO(){return this.f.f},
gF(){return this.f.gF()},
gM(){return B.A},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.f
r=b*s.e
q.e=r
s=a*s.c
q.c=r+B.a.j(s,3)
q.d=s&7},
gN(){return this},
E(){var s,r=this,q=++r.a,p=r.f
if(q===p.a){r.a=0
q=++r.b
r.d=0;++r.c
r.e=r.e+p.e
return q<p.b}s=p.c
if(p.f!=null||s===1){if(++r.d>7){r.d=0;++r.c}}else{q*=s
r.d=q&7
r.c=r.e+B.a.j(q,3)}q=r.c
p=p.d
p===$&&A.c("data")
return q<p.byteLength},
e1(a){var s,r,q=this.c,p=7-(this.d+a)
if(p<0){p+=8;++q}s=this.f.d
s===$&&A.c("data")
r=s.length
if(q>=r)return 0
if(!(q>=0))return A.a(s,q)
return B.a.a2(s[q],p)&1},
bi(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.e1(a):0
else s=r.aX(this.e1(0),a)
return s},
aC(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=7-(this.d+a)
if(r<0){++s
r+=8}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.G(B.b.i(b),0,1)
if(!(r>=0&&r<8))return A.a(B.bJ,r)
n=B.bJ[r]
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bi(b)},
h(a,b,c){return this.aC(b,c)},
gU(){return this.e1(0)},
sU(a){this.aC(0,a)},
gn(){return this.bi(0)},
sn(a){this.aC(0,a)},
gt(){return this.bi(1)},
st(a){this.aC(1,a)},
gu(){return this.bi(2)},
su(a){this.aC(2,a)},
gv(){var s=this.f
return s.f==null&&s.c<4?s.gF():this.bi(3)},
sv(a){this.aC(3,a)},
gai(){return this.bi(0)/this.f.gF()},
sai(a){this.aC(0,a*this.f.gF())},
gae(){return this.bi(1)/this.f.gF()},
sae(a){this.aC(1,a*this.f.gF())},
gah(){return this.bi(2)/this.f.gF()},
sah(a){this.aC(2,a*this.f.gF())},
ga_(){return this.gv()/this.f.gF()},
sa_(a){this.aC(3,a*this.f.gF())},
gap(){return A.a_(this)},
aj(a){var s=this
s.aC(0,a.gn())
s.aC(1,a.gt())
s.aC(2,a.gu())
s.aC(3,a.gv())},
aB(a,b,c){var s=this,r=s.f.c
if(r>0){s.aC(0,a)
if(r>1){s.aC(1,b)
if(r>2)s.aC(2,c)}}},
ag(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aC(0,a)
if(r>1){s.aC(1,b)
if(r>2){s.aC(2,c)
if(r>3)s.aC(3,d)}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cz){s=A.u(p,A.l(p).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.ab(b)
if(s.gA(b)!==q)return!1
if(p.bi(0)!==s.l(b,0))return!1
if(q>1){if(p.bi(1)!==s.l(b,1))return!1
if(q>2){if(p.bi(2)!==s.l(b,2))return!1
if(q>3)if(p.bi(3)!==s.l(b,3))return!1}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.f}}
A.cA.prototype={
X(){var s=this
return new A.cA(s.a,s.b,s.c,s.d)},
gA(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gO(){return this.d.e},
gF(){return this.d.gF()},
gM(){return B.n},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bx(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aX(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bx(b)},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d,q=r.e
if(q==null)if(r.c>0){r=r.d
q=this.c
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b1(r[s])
r=s}return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this,q=r.d,p=q.e
if(p==null){p=q.c
if(p===2){q=q.d
p=r.c
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else if(p>1){q=q.d
p=r.c+1
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=0}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b0(q[s])
q=s}return q},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.i(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.i(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gu(){var s,r=this,q=r.d,p=q.e
if(p==null){p=q.c
if(p===2){q=q.d
p=r.c
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else if(p>2){q=q.d
p=r.c+2
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=0}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b_(q[s])
q=s}return q},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.i(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.i(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s,r=this,q=r.d,p=q.e
if(p==null){p=q.c
if(p===2){q=q.d
p=r.c+1
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else if(p>3){q=q.d
p=r.c+3
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=q.gF()}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b6(q[s])
q=s}return q},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.i(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.i(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gai(){return this.gn()/this.d.gF()},
sai(a){this.sn(a*this.d.gF())},
gae(){return this.gt()/this.d.gF()},
sae(a){this.st(a*this.d.gF())},
gah(){return this.gu()/this.d.gF()},
sah(a){this.su(a*this.d.gF())},
ga_(){return this.gv()/this.d.gF()},
sa_(a){this.sv(a*this.d.gF())},
gap(){return this.d.c===2?this.gn():A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){n=s+2
s=B.a.i(c)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){r=s+2
p=B.a.i(c)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>3){n=s+3
s=B.a.i(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cA){s=A.u(p,A.l(p).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.ab(b)
if(s.gA(b)!==q)return!1
if(p.bx(0)!==s.l(b,0))return!1
if(q>1){if(p.bx(1)!==s.l(b,1))return!1
if(q>2){if(p.bx(2)!==s.l(b,2))return!1
if(q>3)if(p.bx(3)!==s.l(b,3))return!1}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cB.prototype={
X(){var s=this
return new A.cB(s.a,s.b,s.c,s.d,s.e,s.f)},
gA(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gO(){return this.f.f},
gF(){return this.f.gF()},
gM(){return B.u},
ghc(){var s=this.f
return s.f!=null?2:s.c<<1>>>0},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.ghc()
r=b*p.f.e
p.e=r
q=a*s
p.c=r+B.a.j(q,3)
p.d=q&7},
gN(){return this},
E(){var s=this,r=++s.a,q=s.f
if(r===q.a){s.a=0
r=++s.b
s.d=0;++s.c
s.e=s.e+q.e
return r<q.b}if(q.f!=null||q.c===1){if((s.d+=2)>7){s.d=0;++s.c}}else{r*=s.ghc()
s.d=r&7
s.c=s.e+B.a.j(r,3)}r=s.c
q=q.d
q===$&&A.c("data")
return r<q.length},
e2(a){var s,r=this.c,q=6-(this.d+(a<<1>>>0))
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.c("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a2(s[r],q)&3},
bj(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.e2(a):0
else s=r.aX(this.e2(0),a)
return s},
aD(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=6-(this.d+(a<<1>>>0))
if(r<0){++s
r+=8}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.G(B.b.i(b),0,3)
q=B.a.j(r,1)
if(!(q<4))return A.a(B.bo,q)
n=B.bo[q]
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bj(b)},
h(a,b,c){return this.aD(b,c)},
gU(){return this.e2(0)},
sU(a){this.aD(0,a)},
gn(){return this.bj(0)},
sn(a){this.aD(0,a)},
gt(){return this.bj(1)},
st(a){this.aD(1,a)},
gu(){return this.bj(2)},
su(a){this.aD(2,a)},
gv(){var s=this.f
return s.f==null&&s.c<4?s.gF():this.bj(3)},
sv(a){this.aD(3,a)},
gai(){return this.bj(0)/this.f.gF()},
sai(a){this.aD(0,a*this.f.gF())},
gae(){return this.bj(1)/this.f.gF()},
sae(a){this.aD(1,a*this.f.gF())},
gah(){return this.bj(2)/this.f.gF()},
sah(a){this.aD(2,a*this.f.gF())},
ga_(){return this.gv()/this.f.gF()},
sa_(a){this.aD(3,a*this.f.gF())},
gap(){return A.a_(this)},
aj(a){var s=this
s.aD(0,a.gn())
s.aD(1,a.gt())
s.aD(2,a.gu())
s.aD(3,a.gv())},
aB(a,b,c){var s=this,r=s.f.c
if(r>0){s.aD(0,a)
if(r>1){s.aD(1,b)
if(r>2)s.aD(2,c)}}},
ag(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aD(0,a)
if(r>1){s.aD(1,b)
if(r>2){s.aD(2,c)
if(r>3)s.aD(3,d)}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cB){s=A.u(p,A.l(p).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.ab(b)
if(s.gA(b)!==q)return!1
if(p.bj(0)!==s.l(b,0))return!1
if(q>1){if(p.bj(1)!==s.l(b,1))return!1
if(q>2){if(p.bj(2)!==s.l(b,2))return!1
if(q>3)if(p.bj(3)!==s.l(b,3))return!1}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.f}}
A.cC.prototype={
X(){var s=this
return new A.cC(s.a,s.b,s.c,s.d)},
gA(a){return this.d.c},
gO(){return null},
gF(){return 4294967295},
gM(){return B.R},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){return this.gn()},
sU(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gv(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=4294967295
return r},
sv(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gai(){return this.gn()/4294967295},
sai(a){this.sn(a*4294967295)},
gae(){return this.gt()/4294967295},
sae(a){this.st(a*4294967295)},
gah(){return this.gu()/4294967295},
sah(a){this.su(a*4294967295)},
ga_(){return this.gv()/4294967295},
sa_(a){this.sv(a*4294967295)},
gap(){return A.a_(this)},
aj(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())},
aB(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){n=s+2
s=B.a.i(c)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){r=s+2
p=B.a.i(c)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>3){n=s+3
s=B.a.i(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cC){s=A.u(n,A.l(n).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ab(b)
r=n.d
q=r.c
if(s.gA(b)!==q)return!1
r=r.d
p=n.c
o=r.length
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,0))return!1
if(q>1){p=n.c+1
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,1))return!1
if(q>2){p=n.c+2
if(!(p>=0&&p<o))return A.a(r,p)
if(r[p]!==s.l(b,2))return!1
if(q>3){q=n.c+3
if(!(q>=0&&q<o))return A.a(r,q)
if(r[q]!==s.l(b,3))return!1}}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.cD.prototype={
X(){var s=this
return new A.cD(s.a,s.b,s.c,s.d,s.e)},
gA(a){var s=this.e,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gO(){return this.e.f},
gF(){return this.e.gF()},
gM(){return B.B},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.e
r=s.c*4
q=s.e
if(r===4)s=b*q+B.a.j(a,1)
else if(r===8)s=b*s.a+a
else{s=b*q
s=r===16?s+(a<<1>>>0):s+B.a.j(a*r,3)}p.c=s
s=a*r
p.d=r>7?s&4:s&7},
gN(){return this},
E(){var s,r,q,p=this,o=p.e
if(++p.a===o.a){p.a=0
s=++p.b
p.d=0
p.c=s*o.e
return s<o.b}r=o.c
s=o.f!=null||r===1
q=p.d
if(s){s=q+4
p.d=s
if(s>7){p.d=0;++p.c}}else{s=p.d=q+(r<<2>>>0)
while(s>7){s-=8
p.d=s;++p.c}}s=p.c
o=o.d
o===$&&A.c("data")
return s<o.length},
e3(a){var s,r=this.c,q=4-(this.d+(a<<2>>>0))
if(q<0){q+=8;++r}s=this.e.d
s===$&&A.c("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a2(s[r],q)&15},
bk(a){var s=this.e,r=s.f
if(r==null)s=s.c>a?this.e3(a):0
else s=r.aX(this.e3(0),a)
return s},
aE(a,b){var s,r,q,p,o,n,m=this.e
if(a>=m.c)return
s=this.c
r=4-(this.d+(a<<2>>>0))
if(r<0){r+=8;++s}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.G(B.b.i(b),0,15)
n=r===4?15:240
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bk(b)},
h(a,b,c){return this.aE(b,c)},
gU(){return this.e3(0)},
sU(a){this.aE(0,a)},
gn(){return this.bk(0)},
sn(a){this.aE(0,a)},
gt(){return this.bk(1)},
st(a){this.aE(1,a)},
gu(){return this.bk(2)},
su(a){this.aE(2,a)},
gv(){var s=this.e
return s.f==null&&s.c<4?s.gF():this.bk(3)},
sv(a){this.aE(3,a)},
gai(){return this.bk(0)/this.e.gF()},
sai(a){this.aE(0,a*this.e.gF())},
gae(){return this.bk(1)/this.e.gF()},
sae(a){this.aE(1,a*this.e.gF())},
gah(){return this.bk(2)/this.e.gF()},
sah(a){this.aE(2,a*this.e.gF())},
ga_(){return this.gv()/this.e.gF()},
sa_(a){this.aE(3,a*this.e.gF())},
gap(){return A.a_(this)},
aj(a){var s=this
s.aE(0,a.gn())
s.aE(1,a.gt())
s.aE(2,a.gu())
s.aE(3,a.gv())},
aB(a,b,c){var s=this,r=s.e.c
if(r>0){s.aE(0,a)
if(r>1){s.aE(1,b)
if(r>2)s.aE(2,c)}}},
ag(a,b,c,d){var s=this,r=s.e.c
if(r>0){s.aE(0,a)
if(r>1){s.aE(1,b)
if(r>2){s.aE(2,c)
if(r>3)s.aE(3,d)}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cD){s=A.u(p,A.l(p).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){q=p.e.c
s=J.ab(b)
if(s.gA(b)!==q)return!1
if(p.bk(0)!==s.l(b,0))return!1
if(q>1){if(p.bk(1)!==s.l(b,1))return!1
if(q>2){if(p.bk(2)!==s.l(b,2))return!1
if(q>3)if(p.bk(3)!==s.l(b,3))return!1}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.e}}
A.cE.prototype={
X(){var s=this
return new A.cE(s.a,s.b,s.c,s.d)},
gA(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gO(){return this.d.e},
gF(){return this.d.gF()},
gM(){return B.e},
gaZ(){return this.a},
gaW(){return this.b},
a6(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gN(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bx(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aX(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bx(b)},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(B.b.G(c,0,255))
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gU(){var s=this.d.d,r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
sU(a){var s=this.d.d,r=this.c,q=B.b.i(B.b.G(a,0,255))
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=q},
gn(){var s,r=this.d,q=r.e
if(q==null)if(r.c>0){r=r.d
q=this.c
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b1(r[s])
r=s}return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(B.b.G(a,0,255))
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this,q=r.d,p=q.e
if(p==null){p=q.c
if(p===2){q=q.d
p=r.c
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else if(p>1){q=q.d
p=r.c+1
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=0}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b0(q[s])
q=s}return q},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.i(B.b.G(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.i(B.b.G(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gu(){var s,r=this,q=r.d,p=q.e
if(p==null){p=q.c
if(p===2){q=q.d
p=r.c
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else if(p>2){q=q.d
p=r.c+2
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=0}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b_(q[s])
q=s}return q},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.i(B.b.G(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.i(B.b.G(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s,r=this,q=r.d,p=q.e
if(p==null){p=q.c
if(p===2){q=q.d
p=r.c+1
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else if(p>3){q=q.d
p=r.c+3
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=255}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b6(q[s])
q=s}return q},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.i(B.b.G(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.i(B.b.G(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gai(){return this.gn()/this.d.gF()},
sai(a){this.sn(a*this.d.gF())},
gae(){return this.gt()/this.d.gF()},
sae(a){this.st(a*this.d.gF())},
gah(){return this.gu()/this.d.gF()},
sah(a){this.su(a*this.d.gF())},
ga_(){return this.gv()/this.d.gF()},
sa_(a){this.sv(a*this.d.gF())},
gap(){return this.d.c===2?this.gn():A.a_(this)},
aj(a){var s=this
if(s.d.e!=null)s.sU(a.gU())
else{s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sv(a.gv())}},
aB(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){n=s+2
s=B.a.i(c)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
ag(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){r=s+1
p=B.a.i(b)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>2){r=s+2
p=B.a.i(c)
if(!(r<q))return A.a(o,r)
o[r]=p
if(n>3){n=s+3
s=B.a.i(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.S(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cE){s=A.u(p,A.l(p).p("e.E"))
s=A.o(s)
r=A.u(b,A.l(b).p("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.ab(b)
if(s.gA(b)!==q)return!1
if(p.bx(0)!==s.l(b,0))return!1
if(q>1){if(p.bx(1)!==s.l(b,1))return!1
if(q>2){if(p.bx(2)!==s.l(b,2))return!1
if(q>3)if(p.bx(3)!==s.l(b,3))return!1}}return!0}return!1},
gL(a){var s=A.u(this,A.l(this).p("e.E"))
return A.o(s)},
aS(a){return A.aG(this,null,a,null,null)},
$iA:1,
$ix:1,
$iv:1,
gbe(){return this.d}}
A.F.prototype={
X(){return new A.F()},
gbe(){return $.oN()},
gaZ(){return 0},
gaW(){return 0},
gA(a){return 0},
gF(){return 0},
gM(){return B.e},
gO(){return null},
l(a,b){return 0},
h(a,b,c){},
gU(){return 0},
sU(a){},
gn(){return 0},
sn(a){},
gt(){return 0},
st(a){},
gu(){return 0},
su(a){},
gv(){return 0},
sv(a){},
gai(){return 0},
sai(a){},
gae(){return 0},
sae(a){},
gah(){return 0},
sah(a){},
ga_(){return 0},
sa_(a){},
gap(){return 0},
aj(a){},
aB(a,b,c){},
ag(a,b,c,d){},
a6(a,b){},
gN(){return this},
E(){return!1},
Y(a,b){if(b==null)return!1
return b instanceof A.F},
gL(a){return 0},
gH(a){return new A.S(this)},
aS(a){return this},
$iA:1,
$ix:1,
$iv:1}
A.iV.prototype={
a7(){return"FlipDirection."+this.b}}
A.j6.prototype={
D(a){return"ImageException: "+this.a}}
A.ad.prototype={
gA(a){return this.c-this.d},
h(a,b,c){J.y(this.a,this.d+b,c)
return c},
bs(a,b,c,d){var s=this.a,r=J.an(s),q=this.d+a
if(c instanceof A.ad)r.ar(s,q,q+b,c.a,c.d+d)
else r.ar(s,q,q+b,t.L.a(c),d)},
c8(a,b,c){return this.bs(a,b,c,0)},
ly(a,b,c){var s=this.a,r=this.d+a
J.bu(s,r,r+b,c)},
dH(a,b,c){var s=this,r=c!=null?s.b+c:s.d
return A.w(s.a,s.e,a,r+b)},
aA(a){return this.dH(a,0,null)},
cb(a,b){return this.dH(a,0,b)},
d8(a,b){return this.dH(a,b,null)},
I(){return J.d(this.a,this.d++)},
am(a){var s=this.aA(a)
this.d=this.d+(s.c-s.d)
return s},
ao(a){var s,r,q,p,o,n=this
if(a==null){s=A.j([],t.t)
for(r=n.c;q=n.d,q<r;){p=n.a
n.d=q+1
o=J.d(p,q)
if(o===0)return A.eU(s,0,null)
B.c.C(s,o)}throw A.h(A.n("EOF reached without finding string terminator (length: "+A.z(a)+")"))}return A.eU(n.am(a).a4(),0,null)},
d2(){return this.ao(null)},
hx(a){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
B.c.C(n,p)
if(p===10||n.length>=a)return A.eU(n,0,null)}return A.eU(n,0,null)},
lF(){return this.hx(256)},
lG(){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
if(p===0){t.L.a(n)
return new A.io(!0).eW(n,0,null,!0)}B.c.C(n,p)}return B.cY.l4(n,!0)},
q(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255
if(s.e)return r<<8|q
return q<<8|r},
bu(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255
if(s.e)return p|q<<8|r<<16
return r|q<<8|p<<16},
k(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255
if(s.e)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
dD(){return A.uH(this.eh())},
eh(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255,n=J.d(s.a,s.d++)&255,m=J.d(s.a,s.d++)&255,l=J.d(s.a,s.d++)&255,k=J.d(s.a,s.d++)&255
if(s.e)return(B.a.R(r,56)|B.a.R(q,48)|B.a.R(p,40)|B.a.R(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.R(k,56)|B.a.R(l,48)|B.a.R(m,40)|B.a.R(n,32)|o<<24|p<<16|q<<8|r)>>>0},
d3(a,b,c){var s,r=this,q=r.a
if(t.D.b(q))return r.hC(b,c)
s=r.b+r.d+b
return J.lM(q,s,c<=0?r.c:s+c)},
hC(a,b){var s,r=this,q=b==null?r.c-r.d-a:b,p=r.a
if(t.D.b(p))return J.B(B.d.gB(p),p.byteOffset+r.d+a,q)
s=r.d+a
s=J.lM(p,s,s+q)
return new Uint8Array(A.q(s))},
a4(){return this.hC(0,null)},
d4(){var s=this.a
if(t.D.b(s))return J.Z(B.d.gB(s),s.byteOffset+this.d,null)
return J.Z(B.d.gB(this.a4()),0,null)},
sB(a,b){this.a=t.L.a(b)}}
A.hx.prototype={
gO(){var s=this.a
s===$&&A.c("palette")
return s},
kX(a){var s=this
s.fn(a)
s.f7()
s.fk()
s.eX()},
hJ(a){var s=B.b.i(a.gn()),r=B.b.i(a.gt())
return this.fl(B.b.i(a.gu()),r,s)},
ek(a,b,c){return this.fl(c,b,a)},
jP(a){var s,r,q,p,o,n,m,l=this,k=l.c=Math.max(a,4)
l.f=k-l.d
l.r=k-1
s=B.b.W(k,8)
l.w=s
l.x=s*256
l.Q=new A.dp(new Uint32Array(1024),256,4)
l.a=new A.aN(new Uint8Array(768),256,3)
l.d=3
l.e=2
s=B.b.j(k,3)
l.y=new Int32Array(s)
s=t.V
r=t.H
l.z=r.a(A.E(k*3,0,!1,s))
l.at=r.a(A.E(l.c,0,!1,s))
l.ax=r.a(A.E(l.c,0,!1,s))
B.c.h(l.z,0,0)
B.c.h(l.z,1,0)
B.c.h(l.z,2,0)
B.c.h(l.z,3,255)
B.c.h(l.z,4,255)
B.c.h(l.z,5,255)
q=1/l.c
for(p=0;o=l.d,p<o;++p){B.c.h(l.ax,p,q)
B.c.h(l.at,p,0)}for(n=o*3,p=o;p<l.c;++p,n=m){m=n+1
B.c.h(l.z,n,255*(p-l.d)/l.f)
n=m+1
B.c.h(l.z,m,255*(p-l.d)/l.f)
m=n+1
B.c.h(l.z,n,255*(p-l.d)/l.f)
B.c.h(l.ax,p,q)
B.c.h(l.at,p,0)}},
eX(){var s,r,q,p,o,n,m
for(s=0;s<this.c;++s){r=this.a
r===$&&A.c("palette")
q=this.Q
q===$&&A.c("_palette")
p=q.b
if(2<p){o=q.c
n=s*p+2
if(!(n>=0&&n<o.length))return A.a(o,n)
n=o[n]
o=n}else o=0
if(1<p){n=q.c
m=s*p+1
if(!(m>=0&&m<n.length))return A.a(n,m)
m=n[m]
n=m}else n=0
if(0<p){q=q.c
p=s*p
if(!(p>=0&&p<q.length))return A.a(q,p)
p=q[p]
q=p}else q=0
r.b4(s,Math.abs(o),Math.abs(n),Math.abs(q))}},
fl(a,b,c){var s,r,q,p,o,n,m,l,k,j,i="_palette",h=this.as
if(!(b>=0&&b<256))return A.a(h,b)
s=h[b]
r=s-1
q=this.c
h=this.Q
p=1000
o=-1
for(;;){n=s<q
if(!(n||r>=0))break
if(n){h===$&&A.c(i)
n=h.b
if(1<n){m=h.c
l=s*n+1
if(!(l>=0&&l<m.length))return A.a(m,l)
l=m[l]
m=l}else m=0
k=m-b
if(k>=p)s=q
else{if(k<0)k=-k
if(0<n){m=h.c
l=s*n
if(!(l>=0&&l<m.length))return A.a(m,l)
l=m[l]
m=l}else m=0
j=m-a
k+=j<0?-j:j
if(k<p){if(2<n){m=h.c
n=s*n+2
if(!(n>=0&&n<m.length))return A.a(m,n)
n=m[n]}else n=0
j=n-c
k+=j<0?-j:j
if(k<p){o=s
p=k}}++s}}if(r>=0){h===$&&A.c(i)
n=h.b
if(1<n){m=h.c
l=r*n+1
if(!(l>=0&&l<m.length))return A.a(m,l)
l=m[l]
m=l}else m=0
k=b-m
if(k>=p)r=-1
else{if(k<0)k=-k
if(0<n){m=h.c
l=r*n
if(!(l>=0&&l<m.length))return A.a(m,l)
l=m[l]
m=l}else m=0
j=m-a
k+=j<0?-j:j
if(k<p){if(2<n){m=h.c
n=r*n+2
if(!(n>=0&&n<m.length))return A.a(m,n)
n=m[n]}else n=0
j=n-c
k+=j<0?-j:j
if(k<p){o=r
p=k}}--r}}}return o},
f7(){var s,r,q,p,o,n,m,l=this,k="_palette"
for(s=0,r=0;s<l.c;++s){for(q=0;q<3;++q,++r){p=l.z
p===$&&A.c("_network")
if(!(r>=0&&r<p.length))return A.a(p,r)
o=B.a.G(B.b.i(0.5+p[r]),0,255)
p=l.Q
p===$&&A.c(k)
n=p.b
if(q<n){p=p.c
n=s*n+q
m=B.a.i(o)
p.$flags&2&&A.b(p)
if(!(n>=0&&n<p.length))return A.a(p,n)
p[n]=m}}p=l.Q
p===$&&A.c(k)
n=p.b
if(3<n){p=p.c
n=s*n+3
m=B.a.i(s)
p.$flags&2&&A.b(p)
if(!(n>=0&&n<p.length))return A.a(p,n)
p[n]=m}}},
fk(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.c,r=b.Q,q=b.as,p=q.$flags|0,o=0,n=0,m=0;m<s;m=g){r===$&&A.c("_palette")
l=r.b
k=1<l
if(k){j=r.c
i=m*l+1
if(!(i>=0&&i<j.length))return A.a(j,i)
h=j[i]}else h=0
for(g=m+1,f=g,e=m;f<s;++f){if(k){j=r.c
i=f*l+1
if(!(i>=0&&i<j.length))return A.a(j,i)
i=j[i]
j=i}else j=0
if(j<h){if(k){j=r.c
i=f*l+1
if(!(i>=0&&i<j.length))return A.a(j,i)
h=j[i]}else h=0
e=f}}if(m!==e){j=0<l
if(j){i=r.c
d=e*l
if(!(d>=0&&d<i.length))return A.a(i,d)
f=i[d]}else f=0
if(j){i=r.c
d=m*l
if(!(d>=0&&d<i.length))return A.a(i,d)
d=i[d]
i=d}else i=0
if(j){c=e*l
d=r.c
i=B.a.i(i)
d.$flags&2&&A.b(d)
if(!(c>=0&&c<d.length))return A.a(d,c)
d[c]=i}if(j){c=m*l
j=r.c
i=B.a.i(f)
j.$flags&2&&A.b(j)
if(!(c>=0&&c<j.length))return A.a(j,c)
j[c]=i}if(k){j=r.c
i=e*l+1
if(!(i>=0&&i<j.length))return A.a(j,i)
f=j[i]}else f=0
if(k){j=r.c
i=m*l+1
if(!(i>=0&&i<j.length))return A.a(j,i)
i=j[i]
j=i}else j=0
if(k){i=r.c
d=e*l+1
j=B.a.i(j)
i.$flags&2&&A.b(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
j=m*l+1
i=B.a.i(f)
k.$flags&2&&A.b(k)
if(!(j>=0&&j<k.length))return A.a(k,j)
k[j]=i}k=2<l
if(k){j=r.c
i=e*l+2
if(!(i>=0&&i<j.length))return A.a(j,i)
f=j[i]}else f=0
if(k){j=r.c
i=m*l+2
if(!(i>=0&&i<j.length))return A.a(j,i)
i=j[i]
j=i}else j=0
if(k){i=r.c
d=e*l+2
j=B.a.i(j)
i.$flags&2&&A.b(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
j=m*l+2
i=B.a.i(f)
k.$flags&2&&A.b(k)
if(!(j>=0&&j<k.length))return A.a(k,j)
k[j]=i}k=3<l
if(k){j=r.c
i=e*l+3
if(!(i>=0&&i<j.length))return A.a(j,i)
f=j[i]}else f=0
if(k){j=r.c
i=m*l+3
if(!(i>=0&&i<j.length))return A.a(j,i)
i=j[i]
j=i}else j=0
if(k){i=r.c
d=e*l+3
j=B.a.i(j)
i.$flags&2&&A.b(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
l=m*l+3
j=B.a.i(f)
k.$flags&2&&A.b(k)
if(!(l>=0&&l<k.length))return A.a(k,l)
k[l]=j}}if(h!==o){p&2&&A.b(q)
if(!(o>=0&&o<256))return A.a(q,o)
q[o]=n+m>>>1
for(f=o+1;f<h;++f){if(!(f<256))return A.a(q,f)
q[f]=m}n=m
o=h}}s=b.r
s.toString
r=B.a.j(n+s,1)
p&2&&A.b(q)
if(!(o>=0&&o<256))return A.a(q,o)
q[o]=r
for(g=o+1;g<256;++g)q[g]=s},
fP(a,b){var s,r,q,p
for(s=this.y,r=a*a,q=0;q<a;++q){s===$&&A.c("_radiusPower")
p=B.b.i(b*((r-q*q)*256/r))
s.$flags&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
fn(a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4="_network",a5=a3.x
a5===$&&A.c("initBiasRadius")
s=a3.b
r=30+B.a.W(s-1,3)
q=a6.gS()*a6.gK()
p=B.a.au(q,s)
o=Math.max(B.a.W(p,100),1)
if(o===0)o=1
n=B.a.j(a5,8)
if(n<=1)n=0
a3.fP(n,1024)
if(q<1509)m=a3.b=1
else if(B.a.a8(q,499)!==0)m=499
else if(B.a.a8(q,491)!==0)m=491
else m=B.a.a8(q,487)!==0?487:503
l=a6.gS()
k=a6.gK()
for(j=a5,i=1024,h=0,g=0,f=0,e=0;e<p;){a5=a6.a
d=a5==null?null:a5.P(g,f,null)
if(d==null)d=new A.F()
c=d.gn()
b=d.gt()
a=d.gu()
if(e===0){a5=a3.z
a5===$&&A.c(a4)
s=a3.e
s===$&&A.c("bgColor")
B.c.h(a5,s*3,a)
B.c.h(a3.z,a3.e*3+1,b)
B.c.h(a3.z,a3.e*3+2,c)}a0=a3.kN(a,b,c)
if(a0<0)a0=a3.iL(a,b,c)
if(a0>=a3.d){a1=i/1024
d=a0*3
a5=a3.z
a5===$&&A.c(a4)
if(!(d>=0&&d<a5.length))return A.a(a5,d)
s=a5[d]
B.c.h(a5,d,s-a1*(s-a))
s=a3.z
a5=d+1
if(!(a5<s.length))return A.a(s,a5)
a2=s[a5]
B.c.h(s,a5,a2-a1*(a2-b))
a2=a3.z
a5=d+2
if(!(a5<a2.length))return A.a(a2,a5)
s=a2[a5]
B.c.h(a2,a5,s-a1*(s-c))
if(n>0)a3.it(a1,n,a0,a,b,c)}h+=m
g+=m
while(g>l){g-=l;++f}while(h>=q){h-=q
f-=k}++e
if(B.a.a8(e,o)===0){i-=B.a.au(i,r)
j-=B.a.W(j,30)
n=B.a.j(j,8)
if(n<=1)n=0
a3.fP(n,i)}}},
it(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_network",f=c-b,e=h.d-1
if(f<e)f=e
s=c+b
r=h.c
if(s>r)s=r
q=c+1
p=c-1
o=1
for(;;){n=q<s
if(!(n||p>f))break
m=h.y
m===$&&A.c("_radiusPower")
l=o+1
if(!(o<m.length))return A.a(m,o)
k=m[o]
if(n){j=q*3
n=h.z
n===$&&A.c(g)
if(!(j>=0&&j<n.length))return A.a(n,j)
m=n[j]
B.c.h(n,j,m-k*(m-d)/262144)
m=h.z
n=j+1
if(!(n<m.length))return A.a(m,n)
i=m[n]
B.c.h(m,n,i-k*(i-a0)/262144)
i=h.z
n=j+2
if(!(n<i.length))return A.a(i,n)
m=i[n]
B.c.h(i,n,m-k*(m-a1)/262144);++q}if(p>f){j=p*3
n=h.z
n===$&&A.c(g)
if(!(j>=0&&j<n.length))return A.a(n,j)
m=n[j]
B.c.h(n,j,m-k*(m-d)/262144)
m=h.z
n=j+1
if(!(n<m.length))return A.a(m,n)
i=m[n]
B.c.h(m,n,i-k*(i-a0)/262144)
i=h.z
n=j+2
if(!(n<i.length))return A.a(i,n)
m=i[n]
B.c.h(i,n,m-k*(m-a1)/262144);--p}o=l}},
iL(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1e30
for(s=e.d,r=s*3,q=d,p=q,o=-1,n=-1;s<e.c;++s,r=l){m=e.z
m===$&&A.c("_network")
l=r+1
k=m.length
if(!(r<k))return A.a(m,r)
j=m[r]-a
if(j<0)j=-j
r=l+1
if(!(l<k))return A.a(m,l)
i=m[l]-b
if(i<0)i=-i
l=r+1
if(!(r<k))return A.a(m,r)
h=m[r]-c
if(h<0)h=-h
j=j+i+h
if(j<p){o=s
p=j}m=e.at
m===$&&A.c("_bias")
if(!(s<m.length))return A.a(m,s)
g=j-m[s]
if(g<q){n=s
q=g}m=e.ax
m===$&&A.c("_freq")
if(!(s<m.length))return A.a(m,s)
k=m[s]
B.c.h(m,s,k-0.0009765625*k)
k=e.at
if(!(s<k.length))return A.a(k,s)
m=k[s]
f=e.ax
if(!(s<f.length))return A.a(f,s)
B.c.h(k,s,m+f[s])}m=e.ax
m===$&&A.c("_freq")
if(!(o>=0&&o<m.length))return A.a(m,o)
B.c.h(m,o,m[o]+0.0009765625)
m=e.at
m===$&&A.c("_bias")
if(!(o<m.length))return A.a(m,o)
B.c.h(m,o,m[o]-1)
return n},
kN(a,b,c){var s,r,q,p,o,n,m
for(s=this.d,r=this.z,q=0,p=0;q<s;++q){r===$&&A.c("_network")
o=p+1
n=r.length
if(!(p<n))return A.a(r,p)
m=!1
if(r[p]===a){p=o+1
if(!(o<n))return A.a(r,o)
if(r[o]===b){o=p+1
if(!(p<n))return A.a(r,p)
n=r[p]===c
p=o}else n=m}else{n=m
p=o}if(n)return q}return-1}}
A.hz.prototype={
m(a){var s,r,q=this
if(q.a===q.c.length)q.jn()
s=q.c
r=q.a++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a&255},
hG(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=J.bv(a)
while(s=o.a,r=s+b,q=o.c,p=q.length,r>p)o.f6(r-p)
B.d.ba(q,s,r,a)
o.a+=b},
a5(a){return this.hG(a,null)},
a1(a){var s=this
A.m(a)
if(s.b){s.m(B.a.j(a,8)&255)
s.m(a&255)
return}s.m(a&255)
s.m(B.a.j(a,8)&255)},
J(a){var s=this
if(s.b){s.m(B.a.j(a,24)&255)
s.m(B.a.j(a,16)&255)
s.m(B.a.j(a,8)&255)
s.m(a&255)
return}s.m(a&255)
s.m(B.a.j(a,8)&255)
s.m(B.a.j(a,16)&255)
s.m(B.a.j(a,24)&255)},
lW(a){var s,r,q=this,p=new Float32Array(1)
p[0]=a
s=J.B(B.a6.gB(p),0,null)
if(q.b){if(3>=s.length)return A.a(s,3)
q.m(s[3])
q.m(s[2])
q.m(s[1])
q.m(s[0])
return}r=s.length
if(0>=r)return A.a(s,0)
q.m(s[0])
if(1>=r)return A.a(s,1)
q.m(s[1])
if(2>=r)return A.a(s,2)
q.m(s[2])
if(3>=r)return A.a(s,3)
q.m(s[3])},
lX(a){var s,r,q=this,p=new Float64Array(1)
p[0]=a
s=J.B(B.q.gB(p),0,null)
if(q.b){if(7>=s.length)return A.a(s,7)
q.m(s[7])
q.m(s[6])
q.m(s[5])
q.m(s[4])
q.m(s[3])
q.m(s[2])
q.m(s[1])
q.m(s[0])
return}r=s.length
if(0>=r)return A.a(s,0)
q.m(s[0])
if(1>=r)return A.a(s,1)
q.m(s[1])
if(2>=r)return A.a(s,2)
q.m(s[2])
if(3>=r)return A.a(s,3)
q.m(s[3])
if(4>=r)return A.a(s,4)
q.m(s[4])
if(5>=r)return A.a(s,5)
q.m(s[5])
if(6>=r)return A.a(s,6)
q.m(s[6])
if(7>=r)return A.a(s,7)
q.m(s[7])},
f6(a){var s,r,q,p
if(a!=null)s=a
else{r=this.c.length
s=r===0?8192:r*2}r=this.c
q=r.length
p=new Uint8Array(q+s)
B.d.ba(p,0,q,r)
this.c=p},
jn(){return this.f6(null)},
gA(a){return this.a}}
A.jL.prototype={
a7(){return"QuantizerType."+this.b}}
A.hT.prototype={
el(a){var s,r,q=a.gS(),p=A.Q(null,null,B.e,0,B.j,a.gK(),null,0,1,this.gO(),B.e,q,!1)
q=p.a
s=q.gH(q)
s.E()
p.z=a.z
p.w=a.w
p.y=a.y
for(q=a.a,q=q.gH(q);q.E();){r=q.gN()
s.gN().h(0,0,this.hJ(r))
s.E()}return p}}
A.aX.prototype={
i(a){var s=this.b
return s===0?0:B.a.au(this.a,s)},
Y(a,b){if(b==null)return!1
return b instanceof A.aX&&this.a===b.a&&this.b===b.b},
gL(a){return A.jy(this.a,this.b,B.E,B.E)},
D(a){return""+this.a+"/"+this.b}}
A.ht.prototype={
a7(){return"Level."+this.b}}
A.jq.prototype={
h3(a){B.c.C(this.c,a)
if(a.d.a<=3)A.qm(a)},
hl(a){return this.h3(new A.eo(a,null,$.mR().$1(null),B.dx))}}
A.jr.prototype={
$1(a){return a},
$S:35}
A.eo.prototype={}
A.hu.prototype={
hB(){var s,r=this,q=A.I(t.N,t.z)
q.h(0,"bytes",r.a)
q.h(0,"width",r.b)
q.h(0,"height",r.c)
s=r.e
if(s!=null)q.h(0,"mimeType",s)
s=r.d
if(s!=null)q.h(0,"blurhash",s)
s=r.f
if(s!=null)q.h(0,"originalHeight",s)
s=r.r
if(s!=null)q.h(0,"originalWidth",s)
return q}}
A.ju.prototype={}
A.kp.prototype={}
A.f7.prototype={
a7(){return"WebWorkerOperations."+this.b}}
A.lC.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j=t.n1.a(A.ov(A.br(a).data))
try{n=j
m=n.l(0,"label")
if(n.a9("name")){l=A.m(n.l(0,"name"))
if(!(l>=0&&l<2))return A.a(B.cd,l)
l=B.cd[l]}else l=null
s=new A.kp(m,l,n.l(0,"data"))
switch(s.b){case B.cC:n=A.en(t.av.a(s.c),t.N,t.z)
r=A.pZ(new A.ju(t.D.a(n.l(0,"bytes")),A.m(n.l(0,"maxDimension")),A.bs(n.l(0,"fileName")),A.ob(n.l(0,"calcBlurhash"))))
n=A.ip(s.a)
m=r
A.op(n,m==null?null:m.hB())
break
case B.cD:n=J.pi(t.j.a(s.c),t.p)
n=A.u(n,n.$ti.p("e.E"))
q=A.pY(new Uint8Array(A.q(n)))
n=A.ip(s.a)
q=q
A.op(n,q==null?null:q.hB())
break
default:throw A.h(new A.bo())}}catch(k){p=A.cc(k)
o=A.bU(k)
A.tA(p,o,A.ip(J.d(j,"label")))}},
$S:36}
A.jv.prototype={
lw(a,b){var s,r=A.q_(a)
this.a.l(0,r)
s=B.l3.l(0,r)
if(s!=null)return s
return null}};(function aliases(){var s=J.c0.prototype
s.i0=s.D
s=A.H.prototype
s.eA=s.ar})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._static_1,q=hunkHelpers._static_0,p=hunkHelpers.installInstanceTearOff,o=hunkHelpers._instance_2u,n=hunkHelpers.installStaticTearOff
s(J,"th","pP",37)
r(A,"tV","rp",9)
r(A,"tW","rq",9)
r(A,"tX","rr",9)
q(A,"os","tK",2)
r(A,"tZ","tv",39)
p(A.a3.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.b7.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.bE.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.aT.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.bi.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.bj.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.bD.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.bC.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.bk.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
p(A.cm.prototype,"gbN",1,0,null,["$1","$0"],["ad","i"],3,0,0)
var m
o(m=A.hq.prototype,"giV","iW",5)
o(m,"giY","iZ",5)
o(m,"gj_","j0",5)
o(m,"giP","iQ",5)
o(m,"giR","iS",5)
r(A,"uR","qH",0)
r(A,"uK","qz",0)
r(A,"uI","qx",0)
r(A,"uP","qF",0)
r(A,"uQ","qG",0)
r(A,"uO","qE",0)
r(A,"uN","qD",0)
r(A,"uM","qC",0)
r(A,"uT","qJ",0)
r(A,"uS","qI",0)
r(A,"uL","qA",0)
r(A,"uJ","qy",0)
r(A,"v3","qU",0)
r(A,"v1","qS",0)
r(A,"uU","qK",0)
r(A,"uW","qM",0)
r(A,"uV","qL",0)
r(A,"uX","qN",0)
r(A,"v4","qV",0)
r(A,"v2","qT",0)
r(A,"uY","qO",0)
r(A,"uZ","qP",0)
r(A,"v_","qQ",0)
r(A,"v0","qR",0)
o(A.f_.prototype,"gkd","ke",14)
o(A.hi.prototype,"glh","li",14)
n(A,"mO",3,null,["$3"],["qZ"],1,0)
n(A,"v5",3,null,["$3"],["r_"],1,0)
n(A,"va",3,null,["$3"],["r4"],1,0)
n(A,"vb",3,null,["$3"],["r5"],1,0)
n(A,"vc",3,null,["$3"],["r6"],1,0)
n(A,"vd",3,null,["$3"],["r7"],1,0)
n(A,"ve",3,null,["$3"],["r8"],1,0)
n(A,"vf",3,null,["$3"],["r9"],1,0)
n(A,"vg",3,null,["$3"],["ra"],1,0)
n(A,"vh",3,null,["$3"],["rb"],1,0)
n(A,"v6",3,null,["$3"],["r0"],1,0)
n(A,"v7",3,null,["$3"],["r1"],1,0)
n(A,"v8",3,null,["$3"],["r2"],1,0)
n(A,"v9",3,null,["$3"],["r3"],1,0)
p(A.bl.prototype,"ghS",0,5,null,["$5"],["aa"],4,0,0)
n(A,"uw",2,null,["$1$2","$2"],["oD",function(a,b){return A.oD(a,b,t.q)}],42,0)
n(A,"vj",6,null,["$6"],["rm"],8,0)
n(A,"vk",6,null,["$6"],["rn"],8,0)
n(A,"vi",6,null,["$6"],["rl"],8,0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.J,null)
q(A.J,[A.lX,J.h9,A.eR,J.dV,A.W,A.H,A.jM,A.e,A.cq,A.ep,A.f8,A.dX,A.f9,A.as,A.bL,A.c7,A.d4,A.ff,A.ar,A.jU,A.jx,A.dY,A.fn,A.aj,A.jn,A.R,A.au,A.ky,A.im,A.bc,A.ie,A.il,A.kS,A.i9,A.aR,A.ib,A.cM,A.ac,A.ia,A.ij,A.fs,A.fd,A.dz,A.ih,A.fg,A.fM,A.cT,A.io,A.cf,A.kz,A.hy,A.eS,A.kA,A.iX,A.al,A.ik,A.eT,A.jw,A.j0,A.ks,A.kt,A.iP,A.b_,A.kL,A.kR,A.j9,A.kr,A.h6,A.hA,A.iH,A.iI,A.bx,A.S,A.aS,A.id,A.fP,A.aK,A.a3,A.iL,A.bw,A.iO,A.iR,A.M,A.fQ,A.bz,A.fR,A.fS,A.fT,A.e_,A.fl,A.e4,A.e5,A.e6,A.h1,A.h2,A.fJ,A.bW,A.je,A.c_,A.jg,A.dJ,A.hp,A.ji,A.hq,A.eM,A.hG,A.bm,A.dt,A.jC,A.cF,A.hK,A.hL,A.hO,A.hS,A.dw,A.du,A.dv,A.eP,A.a4,A.eW,A.jQ,A.hX,A.jT,A.hY,A.hZ,A.js,A.jX,A.eZ,A.jY,A.k2,A.kd,A.kf,A.eY,A.ke,A.jZ,A.bM,A.f3,A.i8,A.f4,A.f5,A.f_,A.k3,A.k4,A.k9,A.kb,A.kN,A.k7,A.i4,A.i5,A.k6,A.f0,A.ka,A.kO,A.ig,A.f1,A.k5,A.bP,A.i7,A.kh,A.bO,A.f6,A.fV,A.fW,A.e8,A.e7,A.e9,A.fY,A.dF,A.bB,A.aV,A.hB,A.j6,A.ad,A.hT,A.hz,A.aX,A.jq,A.eo,A.hu,A.ju,A.kp,A.jv])
q(J.h9,[J.hn,J.ej,J.el,J.dk,J.dl,J.dj,J.co])
q(J.el,[J.c0,J.t,A.cr,A.ev])
q(J.c0,[J.hC,J.cH,J.bG])
r(J.hl,A.eR)
r(J.jd,J.t)
q(J.dj,[J.di,J.ek])
q(A.W,[A.dm,A.bo,A.hr,A.i1,A.hU,A.ic,A.fA,A.b1,A.eX,A.i0,A.dA,A.fK])
r(A.dC,A.H)
r(A.af,A.dC)
q(A.e,[A.C,A.bH,A.cK,A.cL,A.fe,A.cU,A.cV,A.cW,A.cX,A.cY,A.cZ,A.d_,A.d0,A.d1,A.d2,A.d3,A.b3,A.dW,A.bl,A.ah,A.ct,A.cu,A.cv,A.cw,A.cx,A.cy,A.cz,A.cA,A.cB,A.cC,A.cD,A.cE,A.F])
q(A.C,[A.aC,A.ch,A.cp,A.jo,A.fc])
q(A.aC,[A.eV,A.b9])
r(A.cg,A.bH)
r(A.dK,A.c7)
r(A.cP,A.dK)
q(A.d4,[A.d5,A.aJ])
q(A.ar,[A.h7,A.fG,A.fH,A.hW,A.lt,A.lv,A.kv,A.ku,A.l1,A.kJ,A.lx,A.lz,A.lA,A.lg,A.lj,A.iJ,A.iU,A.lk,A.ll,A.lm,A.ln,A.lo,A.lp,A.lq,A.jB,A.le,A.l9,A.la,A.kl,A.km,A.kn,A.ko,A.j8,A.j7,A.jr,A.lC])
r(A.dh,A.h7)
r(A.ez,A.bo)
q(A.hW,[A.hV,A.cS])
q(A.aj,[A.b8,A.fb])
r(A.em,A.b8)
q(A.fH,[A.lu,A.l2,A.lb,A.kK,A.jp,A.jt,A.j2,A.j3,A.j4,A.jJ,A.jK,A.kg,A.lc])
q(A.ev,[A.hv,A.ak])
q(A.ak,[A.fh,A.fj])
r(A.fi,A.fh)
r(A.c1,A.fi)
r(A.fk,A.fj)
r(A.aM,A.fk)
q(A.c1,[A.eq,A.er])
q(A.aM,[A.es,A.et,A.eu,A.ew,A.ex,A.ey,A.cs])
r(A.dL,A.ic)
q(A.fG,[A.kw,A.kx,A.kT,A.kB,A.kF,A.kE,A.kD,A.kC,A.kI,A.kH,A.kG,A.kQ,A.l7,A.kY,A.kX,A.j_,A.k8,A.l6])
r(A.fa,A.ib)
r(A.ii,A.fs)
r(A.dI,A.fb)
r(A.fm,A.dz)
r(A.cN,A.fm)
q(A.fM,[A.kV,A.kU,A.i3])
r(A.fO,A.cT)
q(A.fO,[A.hs,A.i2])
r(A.jl,A.kV)
r(A.jk,A.kU)
q(A.b1,[A.dx,A.h4])
r(A.l_,A.ks)
r(A.l0,A.kt)
q(A.kz,[A.dG,A.fF,A.iN,A.at,A.e3,A.fC,A.ag,A.aB,A.d6,A.ae,A.d7,A.ci,A.b6,A.d8,A.jf,A.dq,A.eL,A.c2,A.hF,A.c3,A.bb,A.eQ,A.av,A.cG,A.a9,A.aZ,A.cI,A.dE,A.fZ,A.fU,A.hk,A.iV,A.jL,A.ht,A.f7])
r(A.h5,A.h6)
r(A.eA,A.hA)
q(A.b3,[A.fI,A.ce])
r(A.fL,A.dW)
r(A.by,A.aS)
q(A.a3,[A.b7,A.cl,A.bE,A.aT,A.bi,A.bj,A.bD,A.bC,A.bk,A.bY,A.bX,A.bZ,A.cm])
q(A.iO,[A.fD,A.iT,A.iY,A.j1,A.ho,A.hD,A.jA,A.jD,A.jH,A.jO,A.jR,A.ki])
r(A.iQ,A.fD)
q(A.iR,[A.iK,A.iZ,A.kq,A.jh,A.hE,A.jI,A.jP,A.jS,A.kj])
r(A.ha,A.bz)
q(A.ha,[A.eg,A.hc,A.hd,A.he,A.eh])
r(A.hb,A.e_)
r(A.hf,A.e5)
r(A.h_,A.bw)
r(A.h0,A.kq)
q(A.bW,[A.ck,A.ea])
r(A.hg,A.eM)
r(A.hh,A.hG)
r(A.c4,A.M)
q(A.bm,[A.hI,A.hJ,A.hM,A.hN,A.hQ,A.hR])
q(A.dt,[A.eO,A.hP])
q(A.hS,[A.aW,A.N])
r(A.hi,A.f_)
r(A.hj,A.f6)
r(A.ei,A.dF)
q(A.ah,[A.d9,A.da,A.eb,A.ec,A.ed,A.ee,A.db,A.dc,A.dd,A.de,A.df,A.dg])
q(A.aV,[A.eB,A.eC,A.eD,A.eE,A.eF,A.eG,A.eH,A.dp,A.aN])
r(A.hx,A.hT)
s(A.dC,A.bL)
s(A.fh,A.H)
s(A.fi,A.as)
s(A.fj,A.H)
s(A.fk,A.as)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{f:"int",D:"double",k:"num",V:"String",aF:"bool",al:"Null",r:"List",J:"Object",aU:"Map",a0:"JSObject"},mangledNames:{},types:["~(ad)","f(f,bp,f)","~()","f([f])","~(f,f,k,k,k)","~(c_,r<f>)","k(x)","~(@)","~(f,f,f,f,f,bK)","~(~())","J?(J?)","@()","~(V,aK)","al(@)","~(f,aF)","al()","f(f,f)","e2()","f(f)","~(@,@)","~(J?,J?)","@(@)","~(f,a3)","~(f,f,f)","~(k,k,k,k)","bp(f)","al(~())","aF(V)","aW(f,f)","N(f,f)","@(@,V)","aF(f)","@(V)","k(k,k,k,k)","k(k,k,k,k,k)","aY?(aY?)","al(a0)","f(@,@)","al(@,aY)","D(bx)","~(f,@)","al(J,aY)","0^(0^,0^)<k>","f()"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"2;":(a,b)=>c=>c instanceof A.cP&&a.b(c.a)&&b.b(c.b)}}
A.rK(v.typeUniverse,JSON.parse('{"bG":"c0","hC":"c0","cH":"c0","vu":"cr","hn":{"aF":[],"O":[]},"ej":{"O":[]},"el":{"a0":[]},"c0":{"a0":[]},"t":{"r":["1"],"C":["1"],"a0":[],"e":["1"],"ai":["1"]},"hl":{"eR":[]},"jd":{"t":["1"],"r":["1"],"C":["1"],"a0":[],"e":["1"],"ai":["1"]},"dV":{"A":["1"]},"dj":{"D":[],"k":[],"b4":["k"]},"di":{"D":[],"f":[],"k":[],"b4":["k"],"O":[]},"ek":{"D":[],"k":[],"b4":["k"],"O":[]},"co":{"V":[],"b4":["V"],"nD":[],"ai":["@"],"O":[]},"dm":{"W":[]},"af":{"H":["f"],"bL":["f"],"r":["f"],"C":["f"],"e":["f"],"H.E":"f","bL.E":"f"},"C":{"e":["1"]},"aC":{"C":["1"],"e":["1"]},"eV":{"aC":["1"],"C":["1"],"e":["1"],"e.E":"1","aC.E":"1"},"cq":{"A":["1"]},"bH":{"e":["2"],"e.E":"2"},"cg":{"bH":["1","2"],"C":["2"],"e":["2"],"e.E":"2"},"ep":{"A":["2"]},"b9":{"aC":["2"],"C":["2"],"e":["2"],"e.E":"2","aC.E":"2"},"cK":{"e":["1"],"e.E":"1"},"f8":{"A":["1"]},"ch":{"C":["1"],"e":["1"],"e.E":"1"},"dX":{"A":["1"]},"cL":{"e":["1"],"e.E":"1"},"f9":{"A":["1"]},"dC":{"H":["1"],"bL":["1"],"r":["1"],"C":["1"],"e":["1"]},"cP":{"dK":[],"c7":[]},"d4":{"aU":["1","2"]},"d5":{"d4":["1","2"],"aU":["1","2"]},"fe":{"e":["1"],"e.E":"1"},"ff":{"A":["1"]},"aJ":{"d4":["1","2"],"aU":["1","2"]},"h7":{"ar":[],"bA":[]},"dh":{"ar":[],"bA":[]},"ez":{"bo":[],"W":[]},"hr":{"W":[]},"i1":{"W":[]},"fn":{"aY":[]},"ar":{"bA":[]},"fG":{"ar":[],"bA":[]},"fH":{"ar":[],"bA":[]},"hW":{"ar":[],"bA":[]},"hV":{"ar":[],"bA":[]},"cS":{"ar":[],"bA":[]},"hU":{"W":[]},"b8":{"aj":["1","2"],"jm":["1","2"],"aU":["1","2"],"aj.K":"1","aj.V":"2"},"cp":{"C":["1"],"e":["1"],"e.E":"1"},"R":{"A":["1"]},"jo":{"C":["1"],"e":["1"],"e.E":"1"},"au":{"A":["1"]},"em":{"b8":["1","2"],"aj":["1","2"],"jm":["1","2"],"aU":["1","2"],"aj.K":"1","aj.V":"2"},"dK":{"c7":[]},"cr":{"a0":[],"fE":[],"O":[]},"ev":{"a0":[],"a1":[]},"im":{"fE":[]},"hv":{"iM":[],"a0":[],"a1":[],"O":[]},"ak":{"aL":["1"],"a0":[],"a1":[],"ai":["1"]},"c1":{"H":["D"],"ak":["D"],"r":["D"],"aL":["D"],"C":["D"],"a0":[],"a1":[],"ai":["D"],"e":["D"],"as":["D"]},"aM":{"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"]},"eq":{"c1":[],"iW":[],"H":["D"],"ak":["D"],"r":["D"],"aL":["D"],"C":["D"],"a0":[],"a1":[],"ai":["D"],"e":["D"],"as":["D"],"O":[],"H.E":"D"},"er":{"c1":[],"e2":[],"H":["D"],"ak":["D"],"r":["D"],"aL":["D"],"C":["D"],"a0":[],"a1":[],"ai":["D"],"e":["D"],"as":["D"],"O":[],"H.E":"D"},"es":{"aM":[],"h8":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"et":{"aM":[],"ef":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"eu":{"aM":[],"jb":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"ew":{"aM":[],"i_":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"ex":{"aM":[],"bp":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"ey":{"aM":[],"jW":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"cs":{"aM":[],"bK":[],"H":["f"],"ak":["f"],"r":["f"],"aL":["f"],"C":["f"],"a0":[],"a1":[],"ai":["f"],"e":["f"],"as":["f"],"O":[],"H.E":"f"},"ic":{"W":[]},"dL":{"bo":[],"W":[]},"aR":{"W":[]},"fa":{"ib":["1"]},"ac":{"cj":["1"]},"fs":{"nT":[]},"ii":{"fs":[],"nT":[]},"fb":{"aj":["1","2"],"aU":["1","2"]},"dI":{"fb":["1","2"],"aj":["1","2"],"aU":["1","2"],"aj.K":"1","aj.V":"2"},"fc":{"C":["1"],"e":["1"],"e.E":"1"},"fd":{"A":["1"]},"cN":{"dz":["1"],"C":["1"],"e":["1"]},"fg":{"A":["1"]},"H":{"r":["1"],"C":["1"],"e":["1"]},"aj":{"aU":["1","2"]},"dz":{"C":["1"],"e":["1"]},"fm":{"dz":["1"],"C":["1"],"e":["1"]},"fO":{"cT":["V","r<f>"]},"hs":{"cT":["V","r<f>"]},"i2":{"cT":["V","r<f>"]},"cf":{"b4":["cf"]},"D":{"k":[],"b4":["k"]},"f":{"k":[],"b4":["k"]},"r":{"C":["1"],"e":["1"]},"k":{"b4":["k"]},"V":{"b4":["V"],"nD":[]},"fA":{"W":[]},"bo":{"W":[]},"b1":{"W":[]},"dx":{"W":[]},"h4":{"W":[]},"eX":{"W":[]},"i0":{"W":[]},"dA":{"W":[]},"fK":{"W":[]},"hy":{"W":[]},"eS":{"W":[]},"ik":{"aY":[]},"h5":{"h6":[]},"eA":{"hA":[]},"S":{"A":["k"]},"cU":{"x":[],"e":["k"],"e.E":"k"},"cV":{"x":[],"e":["k"],"e.E":"k"},"cW":{"x":[],"e":["k"],"e.E":"k"},"cX":{"x":[],"e":["k"],"e.E":"k"},"cY":{"x":[],"e":["k"],"e.E":"k"},"cZ":{"x":[],"e":["k"],"e.E":"k"},"d_":{"x":[],"e":["k"],"e.E":"k"},"d0":{"x":[],"e":["k"],"e.E":"k"},"d1":{"x":[],"e":["k"],"e.E":"k"},"d2":{"x":[],"e":["k"],"e.E":"k"},"d3":{"x":[],"e":["k"],"e.E":"k"},"b3":{"x":[],"e":["k"],"e.E":"k"},"fI":{"x":[],"e":["k"],"e.E":"k"},"ce":{"x":[],"e":["k"],"e.E":"k"},"dW":{"x":[],"e":["k"],"e.E":"k"},"fL":{"x":[],"e":["k"],"e.E":"k"},"by":{"aS":[]},"b7":{"a3":[]},"cl":{"a3":[]},"bE":{"a3":[]},"aT":{"a3":[]},"bi":{"a3":[]},"bj":{"a3":[]},"bD":{"a3":[]},"bC":{"a3":[]},"bk":{"a3":[]},"bY":{"a3":[]},"bX":{"a3":[]},"bZ":{"a3":[]},"cm":{"a3":[]},"bw":{"M":[]},"eg":{"bz":[]},"ha":{"bz":[]},"fT":{"M":[]},"hb":{"e_":[]},"hc":{"bz":[]},"hd":{"bz":[]},"he":{"bz":[]},"eh":{"bz":[]},"hf":{"e5":[]},"e6":{"M":[]},"h1":{"M":[]},"h_":{"bw":[],"M":[]},"ck":{"bW":[]},"ea":{"bW":[]},"hg":{"eM":[]},"hG":{"M":[]},"hh":{"M":[]},"c4":{"M":[]},"hI":{"bm":[]},"hJ":{"bm":[]},"hM":{"bm":[]},"hN":{"bm":[]},"hQ":{"bm":[]},"hR":{"bm":[]},"eO":{"dt":[]},"hP":{"dt":[]},"hK":{"M":[]},"du":{"M":[]},"dv":{"M":[]},"eP":{"M":[]},"eW":{"M":[]},"hZ":{"M":[]},"hj":{"f6":[]},"dF":{"M":[]},"ei":{"dF":[],"M":[]},"bl":{"e":["v"],"e.E":"v"},"ah":{"e":["v"]},"d9":{"ah":[],"e":["v"],"e.E":"v"},"da":{"ah":[],"e":["v"],"e.E":"v"},"eb":{"ah":[],"e":["v"],"e.E":"v"},"ec":{"ah":[],"e":["v"],"e.E":"v"},"ed":{"ah":[],"e":["v"],"e.E":"v"},"ee":{"ah":[],"e":["v"],"e.E":"v"},"db":{"ah":[],"e":["v"],"e.E":"v"},"dc":{"ah":[],"e":["v"],"e.E":"v"},"dd":{"ah":[],"e":["v"],"e.E":"v"},"de":{"ah":[],"e":["v"],"e.E":"v"},"df":{"ah":[],"e":["v"],"e.E":"v"},"dg":{"ah":[],"e":["v"],"e.E":"v"},"eB":{"aV":[]},"eC":{"aV":[]},"eD":{"aV":[]},"eE":{"aV":[]},"eF":{"aV":[]},"eG":{"aV":[]},"eH":{"aV":[]},"dp":{"aV":[]},"aN":{"aV":[]},"ct":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cu":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cv":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cw":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cx":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cy":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"hB":{"A":["v"]},"cz":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cA":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cB":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cC":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cD":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"cE":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"F":{"v":[],"x":[],"e":["k"],"A":["v"],"e.E":"k"},"hx":{"hT":[]},"iM":{"a1":[]},"jb":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"bK":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"jW":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"h8":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"i_":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"ef":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"bp":{"r":["f"],"C":["f"],"a1":[],"e":["f"]},"iW":{"r":["D"],"C":["D"],"a1":[],"e":["D"]},"e2":{"r":["D"],"C":["D"],"a1":[],"e":["D"]},"x":{"e":["k"]},"v":{"x":[],"A":["v"],"e":["k"]}}'))
A.rJ(v.typeUniverse,JSON.parse('{"C":1,"dC":1,"ak":1,"fm":1,"fM":2,"hS":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",b:"PVRTC requires a power-of-two sized image.",g:"[native implementations worker] Error responding: "}
var t=(function rtii(){var s=A.T
return{u:s("aR"),lo:s("fE"),fW:s("iM"),G:s("x"),O:s("bx"),bP:s("b4<@>"),Y:s("d5<V,f>"),cs:s("cf"),gt:s("C<@>"),C:s("W"),iW:s("fQ"),ho:s("fS"),pk:s("iW"),kI:s("e2"),Z:s("bA"),co:s("e7"),a6:s("fV"),lq:s("fW"),lJ:s("e8"),aw:s("h2"),P:s("aK"),r:s("a3"),w:s("ah"),m6:s("h8"),k:s("ef"),jx:s("jb"),id:s("e<D>"),c:s("e<@>"),fm:s("e<f>"),an:s("t<fJ>"),a_:s("t<fR>"),lv:s("t<e_>"),e:s("t<e5>"),nK:s("t<e7>"),g:s("t<bl>"),ns:s("t<c_>"),hc:s("t<r<r<r<f>>>>"),o:s("t<r<r<f>>>"),A:s("t<r<D>>"),S:s("t<r<f>>"),U:s("t<r<k>>"),fi:s("t<eM>"),mS:s("t<cF>"),na:s("t<bm>"),k9:s("t<hO>"),lf:s("t<aX>"),s:s("t<V>"),fZ:s("t<hY>"),kN:s("t<i_>"),gF:s("t<bp>"),bs:s("t<bK>"),by:s("t<bM>"),l3:s("t<f0>"),cy:s("t<f1>"),ip:s("t<i7>"),iu:s("t<bO>"),J:s("t<f6>"),cF:s("t<bP>"),n0:s("t<id>"),bm:s("t<ig>"),kv:s("t<dJ>"),n:s("t<D>"),dG:s("t<@>"),t:s("t<f>"),gU:s("t<hp?>"),iZ:s("t<r<f>?>"),mD:s("t<bp?>"),e5:s("t<bK?>"),a:s("t<k>"),B:s("t<~(ad)>"),iy:s("ai<@>"),v:s("ej"),m:s("a0"),dY:s("bG"),dX:s("aL<@>"),e7:s("c_"),n1:s("jm<@,@>"),fg:s("r<bx>"),aL:s("r<bl>"),kn:s("r<ef>"),n5:s("r<r<ef>>"),mL:s("r<r<bM>>"),f:s("r<r<f>>"),cf:s("r<cF>"),ee:s("r<aX>"),ac:s("r<eY>"),jz:s("r<bM>"),p8:s("r<f0>"),jt:s("r<f3>"),as:s("r<f4>"),f4:s("r<f5>"),H:s("r<D>"),j:s("r<@>"),L:s("r<f>"),hQ:s("r<bW?>"),nx:s("r<r<f>?>"),kb:s("r<bM?>"),a3:s("r<fl?>"),dW:s("r<f?>"),je:s("aU<V,V>"),av:s("aU<@,@>"),dQ:s("c1"),aj:s("aM"),hD:s("cs"),b:s("al"),K:s("J"),mK:s("v"),dS:s("cF"),ok:s("hL"),dM:s("eO"),mi:s("dt"),fF:s("du"),nv:s("dw<aW>"),dT:s("dw<N>"),h:s("aW"),R:s("N"),i:s("aX"),lZ:s("vw"),aK:s("+()"),l:s("aY"),N:s("V"),e8:s("hX"),aJ:s("O"),do:s("bo"),hM:s("i_"),E:s("bp"),nn:s("jW"),D:s("bK"),cx:s("cH"),aO:s("eY"),d:s("f1"),f_:s("f3"),h2:s("f4"),ij:s("f5"),no:s("cK<V>"),fT:s("cK<f>"),_:s("ac<@>"),mp:s("dI<J?,J?>"),nA:s("fl"),y:s("aF"),nU:s("aF(J)"),gS:s("aF(V)"),gw:s("aF(f)"),V:s("D"),z:s("@"),mY:s("@()"),Q:s("@(J)"),W:s("@(J,aY)"),p:s("f"),gK:s("cj<al>?"),er:s("bW?"),jH:s("h8?"),mU:s("a0?"),T:s("r<f>?"),iM:s("r<bW?>?"),ia:s("r<r<f>?>?"),gy:s("r<f?>?"),lG:s("aU<V,V>?"),X:s("J?"),jv:s("V?"),nh:s("bK?"),nX:s("eZ?"),fA:s("bM?"),nk:s("i8?"),F:s("cM<@,@>?"),nF:s("ih?"),fU:s("aF?"),jX:s("D?"),I:s("f?"),jh:s("k?"),ec:s("~(f,aF)?"),q:s("k"),x:s("~"),M:s("~()"),mX:s("~(c_,r<f>)"),kX:s("~(f,aF)"),jO:s("~(k,k,k,k)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.ds=J.h9.prototype
B.c=J.t.prototype
B.a=J.di.prototype
B.b=J.dj.prototype
B.m=J.co.prototype
B.du=J.bG.prototype
B.dv=J.el.prototype
B.a6=A.eq.prototype
B.q=A.er.prototype
B.ay=A.es.prototype
B.z=A.et.prototype
B.az=A.eu.prototype
B.C=A.ew.prototype
B.o=A.ex.prototype
B.d=A.cs.prototype
B.cj=J.hC.prototype
B.b2=J.cH.prototype
B.ab=new A.fC(0,"direct")
B.aD=new A.fC(1,"alpha")
B.aE=new A.ae(0,"none")
B.ac=new A.ae(3,"bitfields")
B.aF=new A.ae(6,"alphaBitfields")
B.ad=new A.fF(0,"littleEndian")
B.a2=new A.fF(1,"bigEndian")
B.cP=new A.dh(A.uw(),A.T("dh<D>"))
B.cQ=new A.dX(A.T("dX<0&>"))
B.b4=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.cR=function() {
  var toStringFunction = Object.prototype.toString;
  function getTag(o) {
    var s = toStringFunction.call(o);
    return s.substring(8, s.length - 1);
  }
  function getUnknownTag(object, tag) {
    if (/^HTML[A-Z].*Element$/.test(tag)) {
      var name = toStringFunction.call(object);
      if (name == "[object Object]") return null;
      return "HTMLElement";
    }
  }
  function getUnknownTagGenericBrowser(object, tag) {
    if (object instanceof HTMLElement) return "HTMLElement";
    return getUnknownTag(object, tag);
  }
  function prototypeForTag(tag) {
    if (typeof window == "undefined") return null;
    if (typeof window[tag] == "undefined") return null;
    var constructor = window[tag];
    if (typeof constructor != "function") return null;
    return constructor.prototype;
  }
  function discriminator(tag) { return null; }
  var isBrowser = typeof HTMLElement == "function";
  return {
    getTag: getTag,
    getUnknownTag: isBrowser ? getUnknownTagGenericBrowser : getUnknownTag,
    prototypeForTag: prototypeForTag,
    discriminator: discriminator };
}
B.cW=function(getTagFallback) {
  return function(hooks) {
    if (typeof navigator != "object") return hooks;
    var userAgent = navigator.userAgent;
    if (typeof userAgent != "string") return hooks;
    if (userAgent.indexOf("DumpRenderTree") >= 0) return hooks;
    if (userAgent.indexOf("Chrome") >= 0) {
      function confirm(p) {
        return typeof window == "object" && window[p] && window[p].name == p;
      }
      if (confirm("Window") && confirm("HTMLElement")) return hooks;
    }
    hooks.getTag = getTagFallback;
  };
}
B.cS=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.cV=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Firefox") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "GeoGeolocation": "Geolocation",
    "Location": "!Location",
    "WorkerMessageEvent": "MessageEvent",
    "XMLDocument": "!Document"};
  function getTagFirefox(o) {
    var tag = getTag(o);
    return quickMap[tag] || tag;
  }
  hooks.getTag = getTagFirefox;
}
B.cU=function(hooks) {
  if (typeof navigator != "object") return hooks;
  var userAgent = navigator.userAgent;
  if (typeof userAgent != "string") return hooks;
  if (userAgent.indexOf("Trident/") == -1) return hooks;
  var getTag = hooks.getTag;
  var quickMap = {
    "BeforeUnloadEvent": "Event",
    "DataTransfer": "Clipboard",
    "HTMLDDElement": "HTMLElement",
    "HTMLDTElement": "HTMLElement",
    "HTMLPhraseElement": "HTMLElement",
    "Position": "Geoposition"
  };
  function getTagIE(o) {
    var tag = getTag(o);
    var newTag = quickMap[tag];
    if (newTag) return newTag;
    if (tag == "Object") {
      if (window.DataView && (o instanceof window.DataView)) return "DataView";
    }
    return tag;
  }
  function prototypeForTagIE(tag) {
    var constructor = window[tag];
    if (constructor == null) return null;
    return constructor.prototype;
  }
  hooks.getTag = getTagIE;
  hooks.prototypeForTag = prototypeForTagIE;
}
B.cT=function(hooks) {
  var getTag = hooks.getTag;
  var prototypeForTag = hooks.prototypeForTag;
  function getTagFixed(o) {
    var tag = getTag(o);
    if (tag == "Document") {
      if (!!o.xmlVersion) return "!Document";
      return "!HTMLDocument";
    }
    return tag;
  }
  function prototypeForTagFixed(tag) {
    if (tag == "Document") return null;
    return prototypeForTag(tag);
  }
  hooks.getTag = getTagFixed;
  hooks.prototypeForTag = prototypeForTagFixed;
}
B.b5=function(hooks) { return hooks; }

B.b6=new A.hs()
B.b7=new A.jl()
B.cX=new A.hy()
B.E=new A.jM()
B.cY=new A.i2()
B.H=new A.kr()
B.F=new A.ii()
B.ae=new A.ik()
B.cZ=new A.l_()
B.b8=new A.l0()
B.b9=new A.iN(4,"luminance")
B.d_=new A.fL(4294967295)
B.ba=new A.aB(0,"none")
B.aG=new A.aB(1,"floydSteinberg")
B.d6=new A.aB(8,"bayer4x4")
B.d8=new A.d6(0,"raster")
B.d9=new A.d6(1,"serpentine")
B.da=new A.d6(2,"zigzag")
B.db=new A.d6(3,"hilbert")
B.dc=new A.ci(0,"red")
B.dd=new A.ci(1,"green")
B.de=new A.ci(2,"blue")
B.df=new A.ci(3,"alpha")
B.dg=new A.ci(4,"other")
B.bb=new A.d7(0,"uint")
B.aH=new A.d7(1,"half")
B.aI=new A.d7(2,"float")
B.bc=new A.b6(0,"none")
B.dp=new A.iV(2,"both")
B.P=new A.e3(0,"uint")
B.aJ=new A.e3(1,"int")
B.aK=new A.e3(2,"float")
B.A=new A.at(0,"uint1")
B.u=new A.at(1,"uint2")
B.Q=new A.at(10,"float32")
B.T=new A.at(11,"float64")
B.B=new A.at(2,"uint4")
B.e=new A.at(3,"uint8")
B.n=new A.at(4,"uint16")
B.R=new A.at(5,"uint32")
B.U=new A.at(6,"int8")
B.V=new A.at(7,"int16")
B.W=new A.at(8,"int32")
B.I=new A.at(9,"float16")
B.bd=new A.fU(1,"page")
B.j=new A.fU(2,"sequence")
B.S=new A.fZ(0,"none")
B.aL=new A.fZ(1,"deflate")
B.be=new A.d8(2,"cur")
B.f=new A.ag(0,"none")
B.bf=new A.ag(1,"byte")
B.bg=new A.ag(10,"sRational")
B.bh=new A.ag(11,"single")
B.bi=new A.ag(12,"double")
B.bj=new A.ag(13,"ifd")
B.l=new A.ag(2,"ascii")
B.k=new A.ag(3,"short")
B.p=new A.ag(4,"long")
B.t=new A.ag(5,"rational")
B.bk=new A.ag(6,"sByte")
B.J=new A.ag(7,"undefined")
B.bl=new A.ag(8,"sShort")
B.bm=new A.ag(9,"sLong")
B.dt=new A.hk(0,"nearest")
B.m5=new A.hk(1,"linear")
B.m6=new A.jf(0,"yuv444")
B.dw=new A.jk(!1)
B.dx=new A.ht(1,"error")
B.dy=new A.ht(3,"info")
B.K=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15],t.t)
B.af=s([0,2,8],t.t)
B.dA=s([0,4,2,1],t.t)
B.dB=s([0,8,10],t.t)
B.dq=new A.d8(0,"invalid")
B.dr=new A.d8(1,"ico")
B.dD=s([B.dq,B.dr,B.be],A.T("t<d8>"))
B.aN=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],t.t)
B.bo=s([252,243,207,63],t.t)
B.l7=new A.dq(0,"none")
B.cm=new A.dq(1,"background")
B.cn=new A.dq(2,"previous")
B.bp=s([B.l7,B.cm,B.cn],A.T("t<dq>"))
B.ag=s([292,260,226,226],t.t)
B.bq=s([0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125],t.t)
B.dW=s([0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0],t.t)
B.bs=s([2,3,7],t.t)
B.ah=s([3226,6412,200,168,38,38,134,134,100,100,100,100,68,68,68,68],t.t)
B.dZ=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],t.t)
B.e6=s([3,3,11],t.t)
B.ek=s([4,5,6],t.t)
B.bu=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7],t.t)
B.aU=s([128,128,128,128,128,128,128,128,128,128,128],t.t)
B.by=s([B.aU,B.aU,B.aU],t.S)
B.eW=s([253,136,254,255,228,219,128,128,128,128,128],t.t)
B.h2=s([189,129,242,255,227,213,255,219,128,128,128],t.t)
B.h7=s([106,126,227,252,214,209,255,255,128,128,128],t.t)
B.iK=s([B.eW,B.h2,B.h7],t.S)
B.iS=s([1,98,248,255,236,226,255,255,128,128,128],t.t)
B.ec=s([181,133,238,254,221,234,255,154,128,128,128],t.t)
B.ea=s([78,134,202,247,198,180,255,219,128,128,128],t.t)
B.jj=s([B.iS,B.ec,B.ea],t.S)
B.eR=s([1,185,249,255,243,255,128,128,128,128,128],t.t)
B.iP=s([184,150,247,255,236,224,128,128,128,128,128],t.t)
B.ke=s([77,110,216,255,236,230,128,128,128,128,128],t.t)
B.ia=s([B.eR,B.iP,B.ke],t.S)
B.ik=s([1,101,251,255,241,255,128,128,128,128,128],t.t)
B.eU=s([170,139,241,252,236,209,255,255,128,128,128],t.t)
B.it=s([37,116,196,243,228,255,255,255,128,128,128],t.t)
B.eD=s([B.ik,B.eU,B.it],t.S)
B.hl=s([1,204,254,255,245,255,128,128,128,128,128],t.t)
B.ky=s([207,160,250,255,238,128,128,128,128,128,128],t.t)
B.kx=s([102,103,231,255,211,171,128,128,128,128,128],t.t)
B.fn=s([B.hl,B.ky,B.kx],t.S)
B.eu=s([1,152,252,255,240,255,128,128,128,128,128],t.t)
B.kG=s([177,135,243,255,234,225,128,128,128,128,128],t.t)
B.i5=s([80,129,211,255,194,224,128,128,128,128,128],t.t)
B.iJ=s([B.eu,B.kG,B.i5],t.S)
B.bD=s([1,1,255,128,128,128,128,128,128,128,128],t.t)
B.ja=s([246,1,255,128,128,128,128,128,128,128,128],t.t)
B.hM=s([255,128,128,128,128,128,128,128,128,128,128],t.t)
B.kS=s([B.bD,B.ja,B.hM],t.S)
B.fg=s([B.by,B.iK,B.jj,B.ia,B.eD,B.fn,B.iJ,B.kS],t.o)
B.kg=s([198,35,237,223,193,187,162,160,145,155,62],t.t)
B.eV=s([131,45,198,221,172,176,220,157,252,221,1],t.t)
B.kf=s([68,47,146,208,149,167,221,162,255,223,128],t.t)
B.hv=s([B.kg,B.eV,B.kf],t.S)
B.jm=s([1,149,241,255,221,224,255,255,128,128,128],t.t)
B.jD=s([184,141,234,253,222,220,255,199,128,128,128],t.t)
B.hI=s([81,99,181,242,176,190,249,202,255,255,128],t.t)
B.k2=s([B.jm,B.jD,B.hI],t.S)
B.jR=s([1,129,232,253,214,197,242,196,255,255,128],t.t)
B.kv=s([99,121,210,250,201,198,255,202,128,128,128],t.t)
B.iL=s([23,91,163,242,170,187,247,210,255,255,128],t.t)
B.hQ=s([B.jR,B.kv,B.iL],t.S)
B.fF=s([1,200,246,255,234,255,128,128,128,128,128],t.t)
B.jO=s([109,178,241,255,231,245,255,255,128,128,128],t.t)
B.dV=s([44,130,201,253,205,192,255,255,128,128,128],t.t)
B.k6=s([B.fF,B.jO,B.dV],t.S)
B.en=s([1,132,239,251,219,209,255,165,128,128,128],t.t)
B.dE=s([94,136,225,251,218,190,255,255,128,128,128],t.t)
B.jT=s([22,100,174,245,186,161,255,199,128,128,128],t.t)
B.ii=s([B.en,B.dE,B.jT],t.S)
B.jC=s([1,182,249,255,232,235,128,128,128,128,128],t.t)
B.iD=s([124,143,241,255,227,234,128,128,128,128,128],t.t)
B.fZ=s([35,77,181,251,193,211,255,205,128,128,128],t.t)
B.h9=s([B.jC,B.iD,B.fZ],t.S)
B.kT=s([1,157,247,255,236,231,255,255,128,128,128],t.t)
B.ff=s([121,141,235,255,225,227,255,255,128,128,128],t.t)
B.jP=s([45,99,188,251,195,217,255,224,128,128,128],t.t)
B.eC=s([B.kT,B.ff,B.jP],t.S)
B.dF=s([1,1,251,255,213,255,128,128,128,128,128],t.t)
B.e0=s([203,1,248,255,255,128,128,128,128,128,128],t.t)
B.jE=s([137,1,177,255,224,255,128,128,128,128,128],t.t)
B.ev=s([B.dF,B.e0,B.jE],t.S)
B.jv=s([B.hv,B.k2,B.hQ,B.k6,B.ii,B.h9,B.eC,B.ev],t.o)
B.fs=s([253,9,248,251,207,208,255,192,128,128,128],t.t)
B.jb=s([175,13,224,243,193,185,249,198,255,255,128],t.t)
B.kQ=s([73,17,171,221,161,179,236,167,255,234,128],t.t)
B.j0=s([B.fs,B.jb,B.kQ],t.S)
B.jr=s([1,95,247,253,212,183,255,255,128,128,128],t.t)
B.hZ=s([239,90,244,250,211,209,255,255,128,128,128],t.t)
B.kd=s([155,77,195,248,188,195,255,255,128,128,128],t.t)
B.jB=s([B.jr,B.hZ,B.kd],t.S)
B.hn=s([1,24,239,251,218,219,255,205,128,128,128],t.t)
B.jd=s([201,51,219,255,196,186,128,128,128,128,128],t.t)
B.hY=s([69,46,190,239,201,218,255,228,128,128,128],t.t)
B.jo=s([B.hn,B.jd,B.hY],t.S)
B.h5=s([1,191,251,255,255,128,128,128,128,128,128],t.t)
B.ir=s([223,165,249,255,213,255,128,128,128,128,128],t.t)
B.iR=s([141,124,248,255,255,128,128,128,128,128,128],t.t)
B.jQ=s([B.h5,B.ir,B.iR],t.S)
B.hA=s([1,16,248,255,255,128,128,128,128,128,128],t.t)
B.fd=s([190,36,230,255,236,255,128,128,128,128,128],t.t)
B.eX=s([149,1,255,128,128,128,128,128,128,128,128],t.t)
B.eo=s([B.hA,B.fd,B.eX],t.S)
B.iN=s([1,226,255,128,128,128,128,128,128,128,128],t.t)
B.j3=s([247,192,255,128,128,128,128,128,128,128,128],t.t)
B.kc=s([240,128,255,128,128,128,128,128,128,128,128],t.t)
B.e2=s([B.iN,B.j3,B.kc],t.S)
B.k5=s([1,134,252,255,255,128,128,128,128,128,128],t.t)
B.iC=s([213,62,250,255,255,128,128,128,128,128,128],t.t)
B.kD=s([55,93,255,128,128,128,128,128,128,128,128],t.t)
B.iM=s([B.k5,B.iC,B.kD],t.S)
B.eN=s([B.j0,B.jB,B.jo,B.jQ,B.eo,B.e2,B.iM,B.by],t.o)
B.iE=s([202,24,213,235,186,191,220,160,240,175,255],t.t)
B.eT=s([126,38,182,232,169,184,228,174,255,187,128],t.t)
B.er=s([61,46,138,219,151,178,240,170,255,216,128],t.t)
B.jz=s([B.iE,B.eT,B.er],t.S)
B.i4=s([1,112,230,250,199,191,247,159,255,255,128],t.t)
B.eB=s([166,109,228,252,211,215,255,174,128,128,128],t.t)
B.im=s([39,77,162,232,172,180,245,178,255,255,128],t.t)
B.jx=s([B.i4,B.eB,B.im],t.S)
B.i6=s([1,52,220,246,198,199,249,220,255,255,128],t.t)
B.fl=s([124,74,191,243,183,193,250,221,255,255,128],t.t)
B.fY=s([24,71,130,219,154,170,243,182,255,255,128],t.t)
B.jw=s([B.i6,B.fl,B.fY],t.S)
B.fW=s([1,182,225,249,219,240,255,224,128,128,128],t.t)
B.kB=s([149,150,226,252,216,205,255,171,128,128,128],t.t)
B.kY=s([28,108,170,242,183,194,254,223,255,255,128],t.t)
B.kq=s([B.fW,B.kB,B.kY],t.S)
B.kZ=s([1,81,230,252,204,203,255,192,128,128,128],t.t)
B.jL=s([123,102,209,247,188,196,255,233,128,128,128],t.t)
B.ka=s([20,95,153,243,164,173,255,203,128,128,128],t.t)
B.jM=s([B.kZ,B.jL,B.ka],t.S)
B.hF=s([1,222,248,255,216,213,128,128,128,128,128],t.t)
B.iB=s([168,175,246,252,235,205,255,255,128,128,128],t.t)
B.h0=s([47,116,215,255,211,212,255,255,128,128,128],t.t)
B.f7=s([B.hF,B.iB,B.h0],t.S)
B.hE=s([1,121,236,253,212,214,255,255,128,128,128],t.t)
B.i7=s([141,84,213,252,201,202,255,219,128,128,128],t.t)
B.iZ=s([42,80,160,240,162,185,255,205,128,128,128],t.t)
B.hb=s([B.hE,B.i7,B.iZ],t.S)
B.kK=s([244,1,255,128,128,128,128,128,128,128,128],t.t)
B.dC=s([238,1,255,128,128,128,128,128,128,128,128],t.t)
B.j5=s([B.bD,B.kK,B.dC],t.S)
B.dT=s([B.jz,B.jx,B.jw,B.kq,B.jM,B.f7,B.hb,B.j5],t.o)
B.ep=s([B.fg,B.jv,B.eN,B.dT],t.hc)
B.bv=s([511,1023,2047,4095],t.t)
B.bw=s([63,207,243,252],t.t)
B.eK=s([17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99],t.t)
B.ai=s([0,1,2,3,4,5,6,7,8,9,10,11],t.t)
B.eZ=s([8,8,4,2],t.t)
B.dO=s([173,148,140],t.t)
B.dP=s([176,155,140,135],t.t)
B.dM=s([180,157,141,134,130],t.t)
B.e_=s([254,254,243,230,196,177,153,140,133,130,129],t.t)
B.bx=s([B.dO,B.dP,B.dM,B.e_],t.S)
B.f2=s([0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576],t.t)
B.bz=s([1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379],t.n)
B.f9=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.bA=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095],t.t)
B.aj=s([0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29],t.t)
B.bB=s([1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250],t.t)
B.ak=s([96,73,55,39,23,13,5,1,255,255,255,255,255,255,255,255,101,78,58,42,26,16,8,2,0,3,9,17,27,43,59,79,102,86,62,46,32,20,10,6,4,7,11,21,33,47,63,87,105,90,70,52,37,28,18,14,12,15,19,29,38,53,71,91,110,99,82,66,48,35,30,24,22,25,31,36,49,67,83,100,115,108,94,76,64,50,44,40,34,41,45,51,65,77,95,109,118,113,103,92,80,68,60,56,54,57,61,69,81,93,104,114,119,116,111,106,97,88,84,74,72,75,85,89,98,107,112,117],t.t)
B.v=s([0,1,1,2,4,8,1,1,2,4,8,4,8,4],t.t)
B.bC=s([2954,2956,2958,2962,2970,2986,3018,3082,3212,3468,3980,5004],t.t)
B.bE=s([280,256,256,256,40],t.t)
B.a3=s([0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63],t.t)
B.al=s([62,62,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,588,588,588,588,588,588,588,588,1680,1680,20499,22547,24595,26643,1776,1776,1808,1808,-24557,-22509,-20461,-18413,1904,1904,1936,1936,-16365,-14317,782,782,782,782,814,814,814,814,-12269,-10221,10257,10257,12305,12305,14353,14353,16403,18451,1712,1712,1744,1744,28691,30739,-32749,-30701,-28653,-26605,2061,2061,2061,2061,2061,2061,2061,2061,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,750,750,750,750,1616,1616,1648,1648,1424,1424,1456,1456,1488,1488,1520,1520,1840,1840,1872,1872,1968,1968,8209,8209,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,1552,1552,1584,1584,2000,2000,2032,2032,976,976,1008,1008,1040,1040,1072,1072,1296,1296,1328,1328,718,718,718,718,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,4113,4113,6161,6161,848,848,880,880,912,912,944,944,622,622,622,622,654,654,654,654,1104,1104,1136,1136,1168,1168,1200,1200,1232,1232,1264,1264,686,686,686,686,1360,1360,1392,1392,12,12,12,12,12,12,12,12,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390],t.t)
B.aQ=s([4,5,6,7,8,9,10,10,11,12,13,14,15,16,17,17,18,19,20,20,21,21,22,22,23,23,24,25,25,26,27,28,29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,93,95,96,98,100,101,102,104,106,108,110,112,114,116,118,122,124,126,128,130,132,134,136,138,140,143,145,148,151,154,157],t.t)
B.bF=s([24,7,23,25,40,6,39,41,22,26,38,42,56,5,55,57,21,27,54,58,37,43,72,4,71,73,20,28,53,59,70,74,36,44,88,69,75,52,60,3,87,89,19,29,86,90,35,45,68,76,85,91,51,61,104,2,103,105,18,30,102,106,34,46,84,92,67,77,101,107,50,62,120,1,119,121,83,93,17,31,100,108,66,78,118,122,33,47,117,123,49,63,99,109,82,94,0,116,124,65,79,16,32,98,110,48,115,125,81,95,64,114,126,97,111,80,113,127,96,112],t.t)
B.aR=s([4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,234,239,245,249,254,259,264,269,274,279,284],t.t)
B.bG=s([0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119],t.t)
B.aS=s([0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28],t.t)
B.bH=s([B.bb,B.aH,B.aI],A.T("t<d7>"))
B.a4=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.X=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15],t.t)
B.bJ=s([254,253,251,247,239,223,191,127],t.t)
B.am=s([12,8,140,8,76,8,204,8,44,8,172,8,108,8,236,8,28,8,156,8,92,8,220,8,60,8,188,8,124,8,252,8,2,8,130,8,66,8,194,8,34,8,162,8,98,8,226,8,18,8,146,8,82,8,210,8,50,8,178,8,114,8,242,8,10,8,138,8,74,8,202,8,42,8,170,8,106,8,234,8,26,8,154,8,90,8,218,8,58,8,186,8,122,8,250,8,6,8,134,8,70,8,198,8,38,8,166,8,102,8,230,8,22,8,150,8,86,8,214,8,54,8,182,8,118,8,246,8,14,8,142,8,78,8,206,8,46,8,174,8,110,8,238,8,30,8,158,8,94,8,222,8,62,8,190,8,126,8,254,8,1,8,129,8,65,8,193,8,33,8,161,8,97,8,225,8,17,8,145,8,81,8,209,8,49,8,177,8,113,8,241,8,9,8,137,8,73,8,201,8,41,8,169,8,105,8,233,8,25,8,153,8,89,8,217,8,57,8,185,8,121,8,249,8,5,8,133,8,69,8,197,8,37,8,165,8,101,8,229,8,21,8,149,8,85,8,213,8,53,8,181,8,117,8,245,8,13,8,141,8,77,8,205,8,45,8,173,8,109,8,237,8,29,8,157,8,93,8,221,8,61,8,189,8,125,8,253,8,19,9,275,9,147,9,403,9,83,9,339,9,211,9,467,9,51,9,307,9,179,9,435,9,115,9,371,9,243,9,499,9,11,9,267,9,139,9,395,9,75,9,331,9,203,9,459,9,43,9,299,9,171,9,427,9,107,9,363,9,235,9,491,9,27,9,283,9,155,9,411,9,91,9,347,9,219,9,475,9,59,9,315,9,187,9,443,9,123,9,379,9,251,9,507,9,7,9,263,9,135,9,391,9,71,9,327,9,199,9,455,9,39,9,295,9,167,9,423,9,103,9,359,9,231,9,487,9,23,9,279,9,151,9,407,9,87,9,343,9,215,9,471,9,55,9,311,9,183,9,439,9,119,9,375,9,247,9,503,9,15,9,271,9,143,9,399,9,79,9,335,9,207,9,463,9,47,9,303,9,175,9,431,9,111,9,367,9,239,9,495,9,31,9,287,9,159,9,415,9,95,9,351,9,223,9,479,9,63,9,319,9,191,9,447,9,127,9,383,9,255,9,511,9,0,7,64,7,32,7,96,7,16,7,80,7,48,7,112,7,8,7,72,7,40,7,104,7,24,7,88,7,56,7,120,7,4,7,68,7,36,7,100,7,20,7,84,7,52,7,116,7,3,8,131,8,67,8,195,8,35,8,163,8,99,8,227,8],t.t)
B.aT=s([A.uY(),A.uQ(),A.v4(),A.v2(),A.v_(),A.uZ(),A.v0()],t.B)
B.bK=s([0,5,16,5,8,5,24,5,4,5,20,5,12,5,28,5,2,5,18,5,10,5,26,5,6,5,22,5,14,5,30,5,1,5,17,5,9,5,25,5,5,5,21,5,13,5,29,5,3,5,19,5,11,5,27,5,7,5,23,5],t.t)
B.b_=new A.a9(0,"whiteIsZero")
B.lA=new A.a9(1,"blackIsZero")
B.lH=new A.a9(2,"rgb")
B.b1=new A.a9(3,"palette")
B.lI=new A.a9(4,"transparencyMask")
B.cz=new A.a9(5,"cmyk")
B.lJ=new A.a9(6,"yCbCr")
B.lK=new A.a9(7,"reserved7")
B.lL=new A.a9(8,"cieLab")
B.lM=new A.a9(9,"iccLab")
B.lB=new A.a9(10,"ituLab")
B.lC=new A.a9(11,"logL")
B.lD=new A.a9(12,"logLuv")
B.lE=new A.a9(13,"colorFilterArray")
B.lF=new A.a9(14,"linearRaw")
B.lG=new A.a9(15,"depth")
B.b0=new A.a9(16,"unknown")
B.bM=s([B.b_,B.lA,B.lH,B.b1,B.lI,B.cz,B.lJ,B.lK,B.lL,B.lM,B.lB,B.lC,B.lD,B.lE,B.lF,B.lG,B.b0],A.T("t<a9>"))
B.bO=s([0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0],t.t)
B.w=s([0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,31],t.t)
B.ck=new A.eL(0,"source")
B.cl=new A.eL(1,"over")
B.bP=s([B.ck,B.cl],A.T("t<eL>"))
B.ls=new A.cG(0,"invalid")
B.aY=new A.cG(1,"uint")
B.i=new A.cG(2,"int")
B.a1=new A.cG(3,"float")
B.bQ=s([B.ls,B.aY,B.i,B.a1],A.T("t<cG>"))
B.an=s([17,18,0,1,2,3,4,5,16,6,7,8,9,10,11,12,13,14,15],t.t)
B.ao=s([-0.0,1,-1,2,-2,3,4,6,-3,5,-4,-5,-6,7,-7,8,-8,-9],t.t)
B.bR=s([B.f,B.bf,B.l,B.k,B.p,B.t,B.bk,B.J,B.bl,B.bm,B.bg,B.bh,B.bi,B.bj],A.T("t<ag>"))
B.hX=s([0,1,4,8,5,2,3,6,9,12,13,10,7,11,14,15],t.t)
B.dh=new A.b6(1,"rle")
B.di=new A.b6(2,"zips")
B.dj=new A.b6(3,"zip")
B.dk=new A.b6(4,"piz")
B.dl=new A.b6(5,"pxr24")
B.dm=new A.b6(6,"b44")
B.dn=new A.b6(7,"b44a")
B.bS=s([B.bc,B.dh,B.di,B.dj,B.dk,B.dl,B.dm,B.dn],A.T("t<b6>"))
B.iV=s([231,120,48,89,115,113,120,152,112],t.t)
B.dU=s([152,179,64,126,170,118,46,70,95],t.t)
B.hW=s([175,69,143,80,85,82,72,155,103],t.t)
B.ef=s([56,58,10,171,218,189,17,13,152],t.t)
B.il=s([114,26,17,163,44,195,21,10,173],t.t)
B.iA=s([121,24,80,195,26,62,44,64,85],t.t)
B.ih=s([144,71,10,38,171,213,144,34,26],t.t)
B.jV=s([170,46,55,19,136,160,33,206,71],t.t)
B.fG=s([63,20,8,114,114,208,12,9,226],t.t)
B.hm=s([81,40,11,96,182,84,29,16,36],t.t)
B.dG=s([B.iV,B.dU,B.hW,B.ef,B.il,B.iA,B.ih,B.jV,B.fG,B.hm],t.S)
B.fc=s([134,183,89,137,98,101,106,165,148],t.t)
B.jG=s([72,187,100,130,157,111,32,75,80],t.t)
B.iH=s([66,102,167,99,74,62,40,234,128],t.t)
B.e1=s([41,53,9,178,241,141,26,8,107],t.t)
B.hh=s([74,43,26,146,73,166,49,23,157],t.t)
B.fQ=s([65,38,105,160,51,52,31,115,128],t.t)
B.fT=s([104,79,12,27,217,255,87,17,7],t.t)
B.hU=s([87,68,71,44,114,51,15,186,23],t.t)
B.jy=s([47,41,14,110,182,183,21,17,194],t.t)
B.j9=s([66,45,25,102,197,189,23,18,22],t.t)
B.kb=s([B.fc,B.jG,B.iH,B.e1,B.hh,B.fQ,B.fT,B.hU,B.jy,B.j9],t.S)
B.iU=s([88,88,147,150,42,46,45,196,205],t.t)
B.io=s([43,97,183,117,85,38,35,179,61],t.t)
B.h_=s([39,53,200,87,26,21,43,232,171],t.t)
B.hL=s([56,34,51,104,114,102,29,93,77],t.t)
B.ib=s([39,28,85,171,58,165,90,98,64],t.t)
B.fL=s([34,22,116,206,23,34,43,166,73],t.t)
B.dH=s([107,54,32,26,51,1,81,43,31],t.t)
B.jY=s([68,25,106,22,64,171,36,225,114],t.t)
B.fb=s([34,19,21,102,132,188,16,76,124],t.t)
B.kl=s([62,18,78,95,85,57,50,48,51],t.t)
B.fp=s([B.iU,B.io,B.h_,B.hL,B.ib,B.fL,B.dH,B.jY,B.fb,B.kl],t.S)
B.i8=s([193,101,35,159,215,111,89,46,111],t.t)
B.eM=s([60,148,31,172,219,228,21,18,111],t.t)
B.el=s([112,113,77,85,179,255,38,120,114],t.t)
B.kh=s([40,42,1,196,245,209,10,25,109],t.t)
B.hC=s([88,43,29,140,166,213,37,43,154],t.t)
B.fN=s([61,63,30,155,67,45,68,1,209],t.t)
B.h6=s([100,80,8,43,154,1,51,26,71],t.t)
B.e4=s([142,78,78,16,255,128,34,197,171],t.t)
B.i3=s([41,40,5,102,211,183,4,1,221],t.t)
B.fx=s([51,50,17,168,209,192,23,25,82],t.t)
B.fo=s([B.i8,B.eM,B.el,B.kh,B.hC,B.fN,B.h6,B.e4,B.i3,B.fx],t.S)
B.fX=s([138,31,36,171,27,166,38,44,229],t.t)
B.fm=s([67,87,58,169,82,115,26,59,179],t.t)
B.ji=s([63,59,90,180,59,166,93,73,154],t.t)
B.k7=s([40,40,21,116,143,209,34,39,175],t.t)
B.e9=s([47,15,16,183,34,223,49,45,183],t.t)
B.eS=s([46,17,33,183,6,98,15,32,183],t.t)
B.l0=s([57,46,22,24,128,1,54,17,37],t.t)
B.h8=s([65,32,73,115,28,128,23,128,205],t.t)
B.iG=s([40,3,9,115,51,192,18,6,223],t.t)
B.he=s([87,37,9,115,59,77,64,21,47],t.t)
B.i2=s([B.fX,B.fm,B.ji,B.k7,B.e9,B.eS,B.l0,B.h8,B.iG,B.he],t.S)
B.kJ=s([104,55,44,218,9,54,53,130,226],t.t)
B.eA=s([64,90,70,205,40,41,23,26,57],t.t)
B.jh=s([54,57,112,184,5,41,38,166,213],t.t)
B.fM=s([30,34,26,133,152,116,10,32,134],t.t)
B.j1=s([39,19,53,221,26,114,32,73,255],t.t)
B.fv=s([31,9,65,234,2,15,1,118,73],t.t)
B.i1=s([75,32,12,51,192,255,160,43,51],t.t)
B.fO=s([88,31,35,67,102,85,55,186,85],t.t)
B.hr=s([56,21,23,111,59,205,45,37,192],t.t)
B.hs=s([55,38,70,124,73,102,1,34,98],t.t)
B.kN=s([B.kJ,B.eA,B.jh,B.fM,B.j1,B.fv,B.i1,B.fO,B.hr,B.hs],t.S)
B.hq=s([125,98,42,88,104,85,117,175,82],t.t)
B.fS=s([95,84,53,89,128,100,113,101,45],t.t)
B.iu=s([75,79,123,47,51,128,81,171,1],t.t)
B.ex=s([57,17,5,71,102,57,53,41,49],t.t)
B.jc=s([38,33,13,121,57,73,26,1,85],t.t)
B.kA=s([41,10,67,138,77,110,90,47,114],t.t)
B.i_=s([115,21,2,10,102,255,166,23,6],t.t)
B.fe=s([101,29,16,10,85,128,101,196,26],t.t)
B.h4=s([57,18,10,102,102,213,34,20,43],t.t)
B.hB=s([117,20,15,36,163,128,68,1,26],t.t)
B.hT=s([B.hq,B.fS,B.iu,B.ex,B.jc,B.kA,B.i_,B.fe,B.h4,B.hB],t.S)
B.hc=s([102,61,71,37,34,53,31,243,192],t.t)
B.kw=s([69,60,71,38,73,119,28,222,37],t.t)
B.hf=s([68,45,128,34,1,47,11,245,171],t.t)
B.dL=s([62,17,19,70,146,85,55,62,70],t.t)
B.kW=s([37,43,37,154,100,163,85,160,1],t.t)
B.kr=s([63,9,92,136,28,64,32,201,85],t.t)
B.jJ=s([75,15,9,9,64,255,184,119,16],t.t)
B.fj=s([86,6,28,5,64,255,25,248,1],t.t)
B.j6=s([56,8,17,132,137,255,55,116,128],t.t)
B.es=s([58,15,20,82,135,57,26,121,40],t.t)
B.ie=s([B.hc,B.kw,B.hf,B.dL,B.kW,B.kr,B.jJ,B.fj,B.j6,B.es],t.S)
B.iy=s([164,50,31,137,154,133,25,35,218],t.t)
B.fi=s([51,103,44,131,131,123,31,6,158],t.t)
B.ko=s([86,40,64,135,148,224,45,183,128],t.t)
B.hV=s([22,26,17,131,240,154,14,1,209],t.t)
B.eP=s([45,16,21,91,64,222,7,1,197],t.t)
B.k8=s([56,21,39,155,60,138,23,102,213],t.t)
B.kM=s([83,12,13,54,192,255,68,47,28],t.t)
B.iI=s([85,26,85,85,128,128,32,146,171],t.t)
B.hN=s([18,11,7,63,144,171,4,4,246],t.t)
B.fq=s([35,27,10,146,174,171,12,26,128],t.t)
B.hG=s([B.iy,B.fi,B.ko,B.hV,B.eP,B.k8,B.kM,B.iI,B.hN,B.fq],t.S)
B.ju=s([190,80,35,99,180,80,126,54,45],t.t)
B.jU=s([85,126,47,87,176,51,41,20,32],t.t)
B.je=s([101,75,128,139,118,146,116,128,85],t.t)
B.jF=s([56,41,15,176,236,85,37,9,62],t.t)
B.et=s([71,30,17,119,118,255,17,18,138],t.t)
B.id=s([101,38,60,138,55,70,43,26,142],t.t)
B.hJ=s([146,36,19,30,171,255,97,27,20],t.t)
B.iT=s([138,45,61,62,219,1,81,188,64],t.t)
B.ki=s([32,41,20,117,151,142,20,21,163],t.t)
B.jW=s([112,19,12,61,195,128,48,4,24],t.t)
B.jn=s([B.ju,B.jU,B.je,B.jF,B.et,B.id,B.hJ,B.iT,B.ki,B.jW],t.S)
B.bT=s([B.dG,B.kb,B.fp,B.fo,B.i2,B.kN,B.hT,B.ie,B.hG,B.jn],t.o)
B.aA=new A.av(0,"none")
B.N=new A.av(1,"palette")
B.cx=new A.av(2,"rgb")
B.lm=new A.av(3,"gray")
B.ln=new A.av(4,"reserved4")
B.lo=new A.av(5,"reserved5")
B.lp=new A.av(6,"reserved6")
B.lq=new A.av(7,"reserved7")
B.lr=new A.av(8,"reserved8")
B.O=new A.av(9,"paletteRle")
B.cw=new A.av(10,"rgbRle")
B.ll=new A.av(11,"grayRle")
B.bU=s([B.aA,B.N,B.cx,B.lm,B.ln,B.lo,B.lp,B.lq,B.lr,B.O,B.cw,B.ll],A.T("t<av>"))
B.bX=s([0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250],t.t)
B.is=s([0,1,1,1,0],t.t)
B.bY=s([A.uI(),A.uP(),A.uR(),A.uK(),A.uN(),A.uT(),A.uM(),A.uS(),A.uJ(),A.uL()],t.B)
B.aP=s([8,0,8,0],t.t)
B.ey=s([5,3,5,3],t.t)
B.e7=s([3,5,3,5],t.t)
B.bn=s([0,8,0,8],t.t)
B.bt=s([4,4,4,4],t.t)
B.ej=s([4,4,0,0],t.t)
B.bZ=s([B.aP,B.ey,B.e7,B.bn,B.aP,B.bt,B.ej,B.bn],t.S)
B.c_=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535],t.t)
B.ap=s([80,88,23,71,30,30,62,62,4,4,4,4,4,4,4,4,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41],t.t)
B.iQ=s([16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99],t.t)
B.Y=s([0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845],t.t)
B.c0=s([127,127,191,127,159,191,223,127,143,159,175,191,207,223,239,127,135,143,151,159,167,175,183,191,199,207,215,223,231,239,247,127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,127],t.t)
B.aq=s([7,6,6,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],t.t)
B.L=s([28679,28679,31752,-32759,-31735,-30711,-29687,-28663,29703,29703,30727,30727,-27639,-26615,-25591,-24567],t.t)
B.ar=s([6430,6400,6400,6400,3225,3225,3225,3225,944,944,944,944,976,976,976,976,1456,1456,1456,1456,1488,1488,1488,1488,718,718,718,718,718,718,718,718,750,750,750,750,750,750,750,750,1520,1520,1520,1520,1552,1552,1552,1552,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,654,654,654,654,654,654,654,654,1072,1072,1072,1072,1104,1104,1104,1104,1136,1136,1136,1136,1168,1168,1168,1168,1200,1200,1200,1200,1232,1232,1232,1232,622,622,622,622,622,622,622,622,1008,1008,1008,1008,1040,1040,1040,1040,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,1712,1712,1712,1712,1744,1744,1744,1744,846,846,846,846,846,846,846,846,1264,1264,1264,1264,1296,1296,1296,1296,1328,1328,1328,1328,1360,1360,1360,1360,1392,1392,1392,1392,1424,1424,1424,1424,686,686,686,686,686,686,686,686,910,910,910,910,910,910,910,910,1968,1968,1968,1968,2000,2000,2000,2000,2032,2032,2032,2032,16,16,16,16,10257,10257,10257,10257,12305,12305,12305,12305,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,878,878,878,878,878,878,878,878,1904,1904,1904,1904,1936,1936,1936,1936,-18413,-18413,-16365,-16365,-14317,-14317,-10221,-10221,590,590,590,590,590,590,590,590,782,782,782,782,782,782,782,782,1584,1584,1584,1584,1616,1616,1616,1616,1648,1648,1648,1648,1680,1680,1680,1680,814,814,814,814,814,814,814,814,1776,1776,1776,1776,1808,1808,1808,1808,1840,1840,1840,1840,1872,1872,1872,1872,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,14353,14353,14353,14353,16401,16401,16401,16401,22547,22547,24595,24595,20497,20497,20497,20497,18449,18449,18449,18449,26643,26643,28691,28691,30739,30739,-32749,-32749,-30701,-30701,-28653,-28653,-26605,-26605,-24557,-24557,-22509,-22509,-20461,-20461,8207,8207,8207,8207,8207,8207,8207,8207,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232],t.t)
B.M=s([0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31],t.t)
B.js=s([0,1,2,3,6,4,5,6,6,6,6,6,6,6,6,7,0],t.t)
B.l8=new A.c2(0,"none")
B.l9=new A.c2(1,"sub")
B.la=new A.c2(2,"up")
B.lb=new A.c2(3,"average")
B.lc=new A.c2(4,"paeth")
B.at=s([B.l8,B.l9,B.la,B.lb,B.lc],A.T("t<c2>"))
B.G=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.D=s([0,1,3,7,15,31,63,127,255],t.t)
B.au=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.av=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7],t.t)
B.x=s([255,255,255,255,255,255,255,255,255,255,255],t.t)
B.a_=s([B.x,B.x,B.x],t.S)
B.hK=s([176,246,255,255,255,255,255,255,255,255,255],t.t)
B.kF=s([223,241,252,255,255,255,255,255,255,255,255],t.t)
B.f5=s([249,253,253,255,255,255,255,255,255,255,255],t.t)
B.i0=s([B.hK,B.kF,B.f5],t.S)
B.ho=s([255,244,252,255,255,255,255,255,255,255,255],t.t)
B.ha=s([234,254,254,255,255,255,255,255,255,255,255],t.t)
B.c6=s([253,255,255,255,255,255,255,255,255,255,255],t.t)
B.fh=s([B.ho,B.ha,B.c6],t.S)
B.kn=s([255,246,254,255,255,255,255,255,255,255,255],t.t)
B.j2=s([239,253,254,255,255,255,255,255,255,255,255],t.t)
B.c2=s([254,255,254,255,255,255,255,255,255,255,255],t.t)
B.jH=s([B.kn,B.j2,B.c2],t.S)
B.bL=s([255,248,254,255,255,255,255,255,255,255,255],t.t)
B.fB=s([251,255,254,255,255,255,255,255,255,255,255],t.t)
B.iz=s([B.bL,B.fB,B.x],t.S)
B.aO=s([255,253,254,255,255,255,255,255,255,255,255],t.t)
B.iw=s([251,254,254,255,255,255,255,255,255,255,255],t.t)
B.fJ=s([B.aO,B.iw,B.c2],t.S)
B.ed=s([255,254,253,255,254,255,255,255,255,255,255],t.t)
B.hk=s([250,255,254,255,254,255,255,255,255,255,255],t.t)
B.as=s([254,255,255,255,255,255,255,255,255,255,255],t.t)
B.hD=s([B.ed,B.hk,B.as],t.S)
B.h3=s([B.a_,B.i0,B.fh,B.jH,B.iz,B.fJ,B.hD,B.a_],t.o)
B.dS=s([217,255,255,255,255,255,255,255,255,255,255],t.t)
B.hH=s([225,252,241,253,255,255,254,255,255,255,255],t.t)
B.jg=s([234,250,241,250,253,255,253,254,255,255,255],t.t)
B.jX=s([B.dS,B.hH,B.jg],t.S)
B.aV=s([255,254,255,255,255,255,255,255,255,255,255],t.t)
B.f8=s([223,254,254,255,255,255,255,255,255,255,255],t.t)
B.eQ=s([238,253,254,254,255,255,255,255,255,255,255],t.t)
B.j_=s([B.aV,B.f8,B.eQ],t.S)
B.hd=s([249,254,255,255,255,255,255,255,255,255,255],t.t)
B.kk=s([B.bL,B.hd,B.x],t.S)
B.k_=s([255,253,255,255,255,255,255,255,255,255,255],t.t)
B.iv=s([247,254,255,255,255,255,255,255,255,255,255],t.t)
B.ij=s([B.k_,B.iv,B.x],t.S)
B.eL=s([252,255,255,255,255,255,255,255,255,255,255],t.t)
B.e3=s([B.aO,B.eL,B.x],t.S)
B.c8=s([255,254,254,255,255,255,255,255,255,255,255],t.t)
B.eO=s([B.c8,B.c6,B.x],t.S)
B.iY=s([255,254,253,255,255,255,255,255,255,255,255],t.t)
B.bN=s([250,255,255,255,255,255,255,255,255,255,255],t.t)
B.eJ=s([B.iY,B.bN,B.as],t.S)
B.eg=s([B.jX,B.j_,B.kk,B.ij,B.e3,B.eO,B.eJ,B.a_],t.o)
B.jp=s([186,251,250,255,255,255,255,255,255,255,255],t.t)
B.fy=s([234,251,244,254,255,255,255,255,255,255,255],t.t)
B.jI=s([251,251,243,253,254,255,254,255,255,255,255],t.t)
B.fH=s([B.jp,B.fy,B.jI],t.S)
B.fD=s([236,253,254,255,255,255,255,255,255,255,255],t.t)
B.iW=s([251,253,253,254,254,255,255,255,255,255,255],t.t)
B.ht=s([B.aO,B.fD,B.iW],t.S)
B.jt=s([254,254,254,255,255,255,255,255,255,255,255],t.t)
B.fz=s([B.c8,B.jt,B.x],t.S)
B.jN=s([254,254,255,255,255,255,255,255,255,255,255],t.t)
B.fC=s([B.aV,B.jN,B.as],t.S)
B.c9=s([B.x,B.as,B.x],t.S)
B.ee=s([B.fH,B.ht,B.fz,B.fC,B.c9,B.a_,B.a_,B.a_],t.o)
B.hi=s([248,255,255,255,255,255,255,255,255,255,255],t.t)
B.fR=s([250,254,252,254,255,255,255,255,255,255,255],t.t)
B.fw=s([248,254,249,253,255,255,255,255,255,255,255],t.t)
B.hw=s([B.hi,B.fR,B.fw],t.S)
B.eb=s([255,253,253,255,255,255,255,255,255,255,255],t.t)
B.k4=s([246,253,253,255,255,255,255,255,255,255,255],t.t)
B.fI=s([252,254,251,254,254,255,255,255,255,255,255],t.t)
B.k3=s([B.eb,B.k4,B.fI],t.S)
B.kU=s([255,254,252,255,255,255,255,255,255,255,255],t.t)
B.fu=s([248,254,253,255,255,255,255,255,255,255,255],t.t)
B.eI=s([253,255,254,254,255,255,255,255,255,255,255],t.t)
B.iF=s([B.kU,B.fu,B.eI],t.S)
B.kL=s([255,251,254,255,255,255,255,255,255,255,255],t.t)
B.i9=s([245,251,254,255,255,255,255,255,255,255,255],t.t)
B.ic=s([253,253,254,255,255,255,255,255,255,255,255],t.t)
B.f1=s([B.kL,B.i9,B.ic],t.S)
B.f3=s([255,251,253,255,255,255,255,255,255,255,255],t.t)
B.hp=s([252,253,254,255,255,255,255,255,255,255,255],t.t)
B.jA=s([B.f3,B.hp,B.aV],t.S)
B.eE=s([255,252,255,255,255,255,255,255,255,255,255],t.t)
B.kI=s([249,255,254,255,255,255,255,255,255,255,255],t.t)
B.fU=s([255,255,254,255,255,255,255,255,255,255,255],t.t)
B.dK=s([B.eE,B.kI,B.fU],t.S)
B.kX=s([255,255,253,255,255,255,255,255,255,255,255],t.t)
B.fA=s([B.kX,B.bN,B.x],t.S)
B.eH=s([B.hw,B.k3,B.iF,B.f1,B.jA,B.dK,B.fA,B.c9],t.o)
B.jS=s([B.h3,B.eg,B.ee,B.eH],t.hc)
B.cE=new A.ae(1,"rle8")
B.cJ=new A.ae(2,"rle4")
B.cK=new A.ae(4,"jpeg")
B.cL=new A.ae(5,"png")
B.cM=new A.ae(7,"reserved7")
B.cN=new A.ae(8,"reserved8")
B.cO=new A.ae(9,"reserved9")
B.cF=new A.ae(10,"reserved10")
B.cG=new A.ae(11,"cmyk")
B.cH=new A.ae(12,"cmykRle8")
B.cI=new A.ae(13,"cmykRle4")
B.aw=s([B.aE,B.cE,B.cJ,B.ac,B.cK,B.cL,B.aF,B.cM,B.cN,B.cO,B.cF,B.cG,B.cH,B.cI],A.T("t<ae>"))
B.Z=s([0,128,192,224,240,248,252,254,255],t.t)
B.c3=s([137,80,78,71,13,10,26,10],t.t)
B.a5=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535,131071,262143,524287,1048575,2097151,4194303,8388607,16777215,33554431,67108863,134217727,268435455,536870911,1073741823,2147483647,4294967295],t.t)
B.c4=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.c5=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.cA=new A.cI(0,"predictor")
B.m0=new A.cI(1,"crossColor")
B.m1=new A.cI(2,"subtractGreen")
B.cB=new A.cI(3,"colorIndexing")
B.c7=s([B.cA,B.m0,B.m1,B.cB],A.T("t<cI>"))
B.y=s([0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255],t.t)
B.kt=s([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
B.ca=s([A.uU(),A.uO(),A.v3(),A.v1(),A.uW(),A.uV(),A.uX()],t.B)
B.cb=s([0,4,8,12,128,132,136,140,256,260,264,268,384,388,392,396],t.t)
B.cc=s([null,A.vj(),A.vk(),A.vi()],A.T("t<~(f,f,f,f,f,bK)?>"))
B.cC=new A.f7(0,"shrinkImage")
B.cD=new A.f7(1,"calcImageMetadata")
B.cd=s([B.cC,B.cD],A.T("t<f7>"))
B.ax=s([0,36,72,109,145,182,218,255],t.t)
B.r=s([0,8,16,24,32,41,49,57,65,74,82,90,98,106,115,123,131,139,148,156,164,172,180,189,197,205,213,222,230,238,246,255],t.t)
B.kH=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.lf=new A.bb(0,"bitmap")
B.cr=new A.bb(1,"grayscale")
B.lg=new A.bb(2,"indexed")
B.cs=new A.bb(3,"rgb")
B.ct=new A.bb(4,"cmyk")
B.lh=new A.bb(5,"multiChannel")
B.li=new A.bb(6,"duoTone")
B.cu=new A.bb(7,"lab")
B.ce=s([B.lf,B.cr,B.lg,B.cs,B.ct,B.lh,B.li,B.cu],A.T("t<bb>"))
B.kP=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.cf=s([0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0],t.t)
B.dY=s([2,6,2,6],t.t)
B.eF=s([6,2,6,2],t.t)
B.dX=s([2,2,6,6],t.t)
B.dQ=s([1,3,3,9],t.t)
B.eh=s([4,0,12,0],t.t)
B.e5=s([3,1,9,3],t.t)
B.eY=s([8,8,0,0],t.t)
B.ei=s([4,12,0,0],t.t)
B.dN=s([16,0,0,0],t.t)
B.dJ=s([12,4,0,0],t.t)
B.eG=s([6,6,2,2],t.t)
B.e8=s([3,9,1,3],t.t)
B.dI=s([12,0,4,0],t.t)
B.f4=s([9,3,3,1],t.t)
B.h=s([B.bt,B.dY,B.aP,B.eF,B.dX,B.dQ,B.eh,B.e5,B.eY,B.ei,B.dN,B.dJ,B.eG,B.e8,B.dI,B.f4],t.S)
B.a0=s([0,-128,64,-64,32,-96,96,-32,16,-112,80,-48,48,-80,112,-16,8,-120,72,-56,40,-88,104,-24,24,-104,88,-40,56,-72,120,-8,4,-124,68,-60,36,-92,100,-28,20,-108,84,-44,52,-76,116,-12,12,-116,76,-52,44,-84,108,-20,28,-100,92,-36,60,-68,124,-4,2,-126,66,-62,34,-94,98,-30,18,-110,82,-46,50,-78,114,-14,10,-118,74,-54,42,-86,106,-22,26,-102,90,-38,58,-70,122,-6,6,-122,70,-58,38,-90,102,-26,22,-106,86,-42,54,-74,118,-10,14,-114,78,-50,46,-82,110,-18,30,-98,94,-34,62,-66,126,-2,1,-127,65,-63,33,-95,97,-31,17,-111,81,-47,49,-79,113,-15,9,-119,73,-55,41,-87,105,-23,25,-103,89,-39,57,-71,121,-7,5,-123,69,-59,37,-91,101,-27,21,-107,85,-43,53,-75,117,-11,13,-115,77,-51,45,-83,109,-19,29,-99,93,-35,61,-67,125,-3,3,-125,67,-61,35,-93,99,-29,19,-109,83,-45,51,-77,115,-13,11,-117,75,-53,43,-85,107,-21,27,-101,91,-37,59,-69,123,-5,7,-121,71,-57,39,-89,103,-25,23,-105,87,-41,55,-73,119,-9,15,-113,79,-49,47,-81,111,-17,31,-97,95,-33,63,-65,127,-1],t.t)
B.l6={ProcessingSoftware:0,SubfileType:1,OldSubfileType:2,ImageWidth:3,ImageLength:4,ImageHeight:5,BitsPerSample:6,Compression:7,PhotometricInterpretation:8,Thresholding:9,CellWidth:10,CellLength:11,FillOrder:12,DocumentName:13,ImageDescription:14,Make:15,Model:16,StripOffsets:17,Orientation:18,SamplesPerPixel:19,RowsPerStrip:20,StripByteCounts:21,MinSampleValue:22,MaxSampleValue:23,XResolution:24,YResolution:25,PlanarConfiguration:26,PageName:27,XPosition:28,YPosition:29,GrayResponseUnit:30,GrayResponseCurve:31,T4Options:32,T6Options:33,ResolutionUnit:34,PageNumber:35,ColorResponseUnit:36,TransferFunction:37,Software:38,DateTime:39,Artist:40,HostComputer:41,Predictor:42,WhitePoint:43,PrimaryChromaticities:44,ColorMap:45,HalftoneHints:46,TileWidth:47,TileLength:48,TileOffsets:49,TileByteCounts:50,BadFaxLines:51,CleanFaxData:52,ConsecutiveBadFaxLines:53,InkSet:54,InkNames:55,NumberofInks:56,DotRange:57,TargetPrinter:58,ExtraSamples:59,SampleFormat:60,SMinSampleValue:61,SMaxSampleValue:62,TransferRange:63,ClipPath:64,JPEGProc:65,JPEGInterchangeFormat:66,JPEGInterchangeFormatLength:67,YCbCrCoefficients:68,YCbCrSubSampling:69,YCbCrPositioning:70,ReferenceBlackWhite:71,ApplicationNotes:72,Rating:73,CFARepeatPatternDim:74,CFAPattern:75,BatteryLevel:76,Copyright:77,ExposureTime:78,FNumber:79,"IPTC-NAA":80,ExifOffset:81,InterColorProfile:82,ExposureProgram:83,SpectralSensitivity:84,GPSOffset:85,ISOSpeed:86,OECF:87,SensitivityType:88,RecommendedExposureIndex:89,ExifVersion:90,DateTimeOriginal:91,DateTimeDigitized:92,OffsetTime:93,OffsetTimeOriginal:94,OffsetTimeDigitized:95,ComponentsConfiguration:96,CompressedBitsPerPixel:97,ShutterSpeedValue:98,ApertureValue:99,BrightnessValue:100,ExposureBiasValue:101,MaxApertureValue:102,SubjectDistance:103,MeteringMode:104,LightSource:105,Flash:106,FocalLength:107,SubjectArea:108,MakerNote:109,UserComment:110,SubSecTime:111,SubSecTimeOriginal:112,SubSecTimeDigitized:113,XPTitle:114,XPComment:115,XPAuthor:116,XPKeywords:117,XPSubject:118,FlashPixVersion:119,ColorSpace:120,ExifImageWidth:121,ExifImageLength:122,RelatedSoundFile:123,InteroperabilityOffset:124,FlashEnergy:125,SpatialFrequencyResponse:126,FocalPlaneXResolution:127,FocalPlaneYResolution:128,FocalPlaneResolutionUnit:129,SubjectLocation:130,ExposureIndex:131,SensingMethod:132,FileSource:133,SceneType:134,CVAPattern:135,CustomRendered:136,ExposureMode:137,WhiteBalance:138,DigitalZoomRatio:139,FocalLengthIn35mmFilm:140,SceneCaptureType:141,GainControl:142,Contrast:143,Saturation:144,Sharpness:145,DeviceSettingDescription:146,SubjectDistanceRange:147,ImageUniqueID:148,CameraOwnerName:149,BodySerialNumber:150,LensSpecification:151,LensMake:152,LensModel:153,LensSerialNumber:154,Gamma:155,PrintIM:156,Padding:157,OffsetSchema:158,OwnerName:159,SerialNumber:160,InteropIndex:161,InteropVersion:162,RelatedImageFileFormat:163,RelatedImageWidth:164,RelatedImageLength:165,GPSVersionID:166,GPSLatitudeRef:167,GPSLatitude:168,GPSLongitudeRef:169,GPSLongitude:170,GPSAltitudeRef:171,GPSAltitude:172,GPSTimeStamp:173,GPSSatellites:174,GPSStatus:175,GPSMeasureMode:176,GPSDOP:177,GPSSpeedRef:178,GPSSpeed:179,GPSTrackRef:180,GPSTrack:181,GPSImgDirectionRef:182,GPSImgDirection:183,GPSMapDatum:184,GPSDestLatitudeRef:185,GPSDestLatitude:186,GPSDestLongitudeRef:187,GPSDestLongitude:188,GPSDestBearingRef:189,GPSDestBearing:190,GPSDestDistanceRef:191,GPSDestDistance:192,GPSProcessingMethod:193,GPSAreaInformation:194,GPSDate:195,GPSDifferential:196}
B.l1=new A.d5(B.l6,[11,254,255,256,257,257,258,259,262,263,264,265,266,269,270,271,272,273,274,277,278,279,280,281,282,283,284,285,286,287,290,291,292,293,296,297,300,301,305,306,315,316,317,318,319,320,321,322,323,324,325,326,327,328,332,333,334,336,337,338,339,340,341,342,343,512,513,514,529,530,531,532,700,18246,33421,33422,33423,33432,33434,33437,33723,34665,34675,34850,34852,34853,34855,34856,34864,34866,36864,36867,36868,36880,36881,36882,37121,37122,37377,37378,37379,37380,37381,37382,37383,37384,37385,37386,37396,37500,37510,37520,37521,37522,40091,40092,40093,40094,40095,40960,40961,40962,40963,40964,40965,41483,41484,41486,41487,41488,41492,41493,41495,41728,41729,41730,41985,41986,41987,41988,41989,41990,41991,41992,41993,41994,41995,41996,42016,42032,42033,42034,42035,42036,42037,42240,50341,59932,59933,65e3,65001,1,2,4096,4097,4098,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30],t.Y)
B.l5={"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,A:10,B:11,C:12,D:13,E:14,F:15,G:16,H:17,I:18,J:19,K:20,L:21,M:22,N:23,O:24,P:25,Q:26,R:27,S:28,T:29,U:30,V:31,W:32,X:33,Y:34,Z:35,a:36,b:37,c:38,d:39,e:40,f:41,g:42,h:43,i:44,j:45,k:46,l:47,m:48,n:49,o:50,p:51,q:52,r:53,s:54,t:55,u:56,v:57,w:58,x:59,y:60,z:61,"#":62,$:63,"%":64,"*":65,"+":66,",":67,"-":68,".":69,":":70,";":71,"=":72,"?":73,"@":74,"[":75,"]":76,"^":77,_:78,"{":79,"|":80,"}":81,"~":82}
B.l2=new A.d5(B.l5,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82],t.Y)
B.l3=new A.aJ(["ez","application/andrew-inset","aw","application/applixware","atom","application/atom+xml","atomcat","application/atomcat+xml","atomsvc","application/atomsvc+xml","ccxml","application/ccxml+xml","cdmia","application/cdmi-capability","cdmic","application/cdmi-container","cdmid","application/cdmi-domain","cdmio","application/cdmi-object","cdmiq","application/cdmi-queue","cu","application/cu-seeme","davmount","application/davmount+xml","dcm","application/dicom","dbk","application/docbook+xml","dssc","application/dssc+der","xdssc","application/dssc+xml","ecma","application/ecmascript","emma","application/emma+xml","epub","application/epub+zip","exi","application/exi","pfr","application/font-tdpfr","gml","application/gml+xml","gpx","application/gpx+xml","gxf","application/gxf","stk","application/hyperstudio","ink","application/inkml+xml","inkml","application/inkml+xml","ipfix","application/ipfix","jar","application/java-archive","ser","application/java-serialized-object","class","application/java-vm","json","application/json","jsonml","application/jsonml+json","lostxml","application/lost+xml","hqx","application/mac-binhex40","cpt","application/mac-compactpro","mads","application/mads+xml","webmanifest","application/manifest+json","mrc","application/marc","mrcx","application/marcxml+xml","nb","application/mathematica","ma","application/mathematica","mb","application/mathematica","mathml","application/mathml+xml","mbox","application/mbox","mscml","application/mediaservercontrol+xml","metalink","application/metalink+xml","meta4","application/metalink4+xml","mets","application/mets+xml","mods","application/mods+xml","mp21","application/mp21","m21","application/mp21","mp4s","application/mp4","doc","application/msword","dot","application/msword","mxf","application/mxf","bin","application/octet-stream","bpk","application/octet-stream","deploy","application/octet-stream","dist","application/octet-stream","distz","application/octet-stream","dms","application/octet-stream","dump","application/octet-stream","elc","application/octet-stream","lrf","application/octet-stream","mar","application/octet-stream","pkg","application/octet-stream","so","application/octet-stream","oda","application/oda","opf","application/oebps-package+xml","ogx","application/ogg","omdoc","application/omdoc+xml","onetoc","application/onenote","onepkg","application/onenote","onetmp","application/onenote","onetoc2","application/onenote","oxps","application/oxps","xer","application/patch-ops-error+xml","pdf","application/pdf","pgp","application/pgp-encrypted","asc","application/pgp-signature","sig","application/pgp-signature","prf","application/pics-rules","p10","application/pkcs10","p7m","application/pkcs7-mime","p7c","application/pkcs7-mime","p7s","application/pkcs7-signature","p8","application/pkcs8","ac","application/pkix-attr-cert","cer","application/pkix-cert","crl","application/pkix-crl","pkipath","application/pkix-pkipath","pki","application/pkixcmp","pls","application/pls+xml","ps","application/postscript","ai","application/postscript","eps","application/postscript","cww","application/prs.cww","pskcxml","application/pskc+xml","rdf","application/rdf+xml","rif","application/reginfo+xml","rnc","application/relax-ng-compact-syntax","rl","application/resource-lists+xml","rld","application/resource-lists-diff+xml","rs","application/rls-services+xml","gbr","application/rpki-ghostbusters","mft","application/rpki-manifest","roa","application/rpki-roa","rsd","application/rsd+xml","rss","application/rss+xml","rtf","application/rtf","sbml","application/sbml+xml","scq","application/scvp-cv-request","scs","application/scvp-cv-response","spq","application/scvp-vp-request","spp","application/scvp-vp-response","sdp","application/sdp","setpay","application/set-payment-initiation","setreg","application/set-registration-initiation","shf","application/shf+xml","smil","application/smil+xml","smi","application/smil+xml","rq","application/sparql-query","srx","application/sparql-results+xml","gram","application/srgs","grxml","application/srgs+xml","sru","application/sru+xml","ssdl","application/ssdl+xml","ssml","application/ssml+xml","tei","application/tei+xml","teicorpus","application/tei+xml","tfi","application/thraud+xml","tsd","application/timestamped-data","toml","application/toml","plb","application/vnd.3gpp.pic-bw-large","psb","application/vnd.3gpp.pic-bw-small","pvb","application/vnd.3gpp.pic-bw-var","tcap","application/vnd.3gpp2.tcap","pwn","application/vnd.3m.post-it-notes","aso","application/vnd.accpac.simply.aso","imp","application/vnd.accpac.simply.imp","acu","application/vnd.acucobol","atc","application/vnd.acucorp","acutc","application/vnd.acucorp","air","application/vnd.adobe.air-application-installer-package+zip","fcdt","application/vnd.adobe.formscentral.fcdt","fxp","application/vnd.adobe.fxp","fxpl","application/vnd.adobe.fxp","xdp","application/vnd.adobe.xdp+xml","xfdf","application/vnd.adobe.xfdf","ahead","application/vnd.ahead.space","azf","application/vnd.airzip.filesecure.azf","azs","application/vnd.airzip.filesecure.azs","azw","application/vnd.amazon.ebook","acc","application/vnd.americandynamics.acc","ami","application/vnd.amiga.ami","apk","application/vnd.android.package-archive","cii","application/vnd.anser-web-certificate-issue-initiation","fti","application/vnd.anser-web-funds-transfer-initiation","atx","application/vnd.antix.game-component","mpkg","application/vnd.apple.installer+xml","m3u8","application/vnd.apple.mpegurl","swi","application/vnd.aristanetworks.swi","iota","application/vnd.astraea-software.iota","aep","application/vnd.audiograph","mpm","application/vnd.blueice.multipass","bmi","application/vnd.bmi","rep","application/vnd.businessobjects","cdxml","application/vnd.chemdraw+xml","mmd","application/vnd.chipnuts.karaoke-mmd","cdy","application/vnd.cinderella","cla","application/vnd.claymore","rp9","application/vnd.cloanto.rp9","c4g","application/vnd.clonk.c4group","c4d","application/vnd.clonk.c4group","c4f","application/vnd.clonk.c4group","c4p","application/vnd.clonk.c4group","c4u","application/vnd.clonk.c4group","c11amc","application/vnd.cluetrust.cartomobile-config","c11amz","application/vnd.cluetrust.cartomobile-config-pkg","csp","application/vnd.commonspace","cdbcmsg","application/vnd.contact.cmsg","cmc","application/vnd.cosmocaller","clkx","application/vnd.crick.clicker","clkk","application/vnd.crick.clicker.keyboard","clkp","application/vnd.crick.clicker.palette","clkt","application/vnd.crick.clicker.template","clkw","application/vnd.crick.clicker.wordbank","wbs","application/vnd.criticaltools.wbs+xml","pml","application/vnd.ctc-posml","ppd","application/vnd.cups-ppd","car","application/vnd.curl.car","pcurl","application/vnd.curl.pcurl","rdz","application/vnd.data-vision.rdz","uvf","application/vnd.dece.data","uvd","application/vnd.dece.data","uvvd","application/vnd.dece.data","uvvf","application/vnd.dece.data","uvt","application/vnd.dece.ttml+xml","uvvt","application/vnd.dece.ttml+xml","uvx","application/vnd.dece.unspecified","uvvx","application/vnd.dece.unspecified","uvz","application/vnd.dece.zip","uvvz","application/vnd.dece.zip","fe_launch","application/vnd.denovo.fcselayout-link","dna","application/vnd.dna","mlp","application/vnd.dolby.mlp","dpg","application/vnd.dpgraph","dfac","application/vnd.dreamfactory","kpxx","application/vnd.ds-keypoint","ait","application/vnd.dvb.ait","svc","application/vnd.dvb.service","geo","application/vnd.dynageo","mag","application/vnd.ecowin.chart","nml","application/vnd.enliven","esf","application/vnd.epson.esf","msf","application/vnd.epson.msf","qam","application/vnd.epson.quickanime","slt","application/vnd.epson.salt","ssf","application/vnd.epson.ssf","es3","application/vnd.eszigno3+xml","et3","application/vnd.eszigno3+xml","ez2","application/vnd.ezpix-album","ez3","application/vnd.ezpix-package","fdf","application/vnd.fdf","mseed","application/vnd.fdsn.mseed","seed","application/vnd.fdsn.seed","dataless","application/vnd.fdsn.seed","gph","application/vnd.flographit","ftc","application/vnd.fluxtime.clip","fm","application/vnd.framemaker","book","application/vnd.framemaker","frame","application/vnd.framemaker","maker","application/vnd.framemaker","fnc","application/vnd.frogans.fnc","ltf","application/vnd.frogans.ltf","fsc","application/vnd.fsc.weblaunch","oas","application/vnd.fujitsu.oasys","oa2","application/vnd.fujitsu.oasys2","oa3","application/vnd.fujitsu.oasys3","fg5","application/vnd.fujitsu.oasysgp","bh2","application/vnd.fujitsu.oasysprs","ddd","application/vnd.fujixerox.ddd","xdw","application/vnd.fujixerox.docuworks","xbd","application/vnd.fujixerox.docuworks.binder","fzs","application/vnd.fuzzysheet","txd","application/vnd.genomatix.tuxedo","ggb","application/vnd.geogebra.file","ggs","application/vnd.geogebra.slides","ggt","application/vnd.geogebra.tool","gex","application/vnd.geometry-explorer","gre","application/vnd.geometry-explorer","gxt","application/vnd.geonext","g2w","application/vnd.geoplan","g3w","application/vnd.geospace","gmx","application/vnd.gmx","kml","application/vnd.google-earth.kml+xml","kmz","application/vnd.google-earth.kmz","gqf","application/vnd.grafeq","gqs","application/vnd.grafeq","gac","application/vnd.groove-account","ghf","application/vnd.groove-help","gim","application/vnd.groove-identity-message","grv","application/vnd.groove-injector","gtm","application/vnd.groove-tool-message","tpl","application/vnd.groove-tool-template","vcg","application/vnd.groove-vcard","hal","application/vnd.hal+xml","zmm","application/vnd.handheld-entertainment+xml","hbci","application/vnd.hbci","les","application/vnd.hhe.lesson-player","hpgl","application/vnd.hp-hpgl","hpid","application/vnd.hp-hpid","hps","application/vnd.hp-hps","jlt","application/vnd.hp-jlyt","pcl","application/vnd.hp-pcl","pclxl","application/vnd.hp-pclxl","sfd-hdstx","application/vnd.hydrostatix.sof-data","mpy","application/vnd.ibm.minipay","afp","application/vnd.ibm.modcap","list3820","application/vnd.ibm.modcap","listafp","application/vnd.ibm.modcap","irm","application/vnd.ibm.rights-management","sc","application/vnd.ibm.secure-container","icc","application/vnd.iccprofile","icm","application/vnd.iccprofile","igl","application/vnd.igloader","ivp","application/vnd.immervision-ivp","ivu","application/vnd.immervision-ivu","igm","application/vnd.insors.igm","xpw","application/vnd.intercon.formnet","xpx","application/vnd.intercon.formnet","i2g","application/vnd.intergeo","qbo","application/vnd.intu.qbo","qfx","application/vnd.intu.qfx","rcprofile","application/vnd.ipunplugged.rcprofile","irp","application/vnd.irepository.package+xml","xpr","application/vnd.is-xpr","fcs","application/vnd.isac.fcs","jam","application/vnd.jam","rms","application/vnd.jcp.javame.midlet-rms","jisp","application/vnd.jisp","joda","application/vnd.joost.joda-archive","ktz","application/vnd.kahootz","ktr","application/vnd.kahootz","karbon","application/vnd.kde.karbon","chrt","application/vnd.kde.kchart","kfo","application/vnd.kde.kformula","flw","application/vnd.kde.kivio","kon","application/vnd.kde.kontour","kpr","application/vnd.kde.kpresenter","kpt","application/vnd.kde.kpresenter","ksp","application/vnd.kde.kspread","kwd","application/vnd.kde.kword","kwt","application/vnd.kde.kword","htke","application/vnd.kenameaapp","kia","application/vnd.kidspiration","kne","application/vnd.kinar","knp","application/vnd.kinar","skp","application/vnd.koan","skd","application/vnd.koan","skm","application/vnd.koan","skt","application/vnd.koan","sse","application/vnd.kodak-descriptor","lasxml","application/vnd.las.las+xml","lbd","application/vnd.llamagraphics.life-balance.desktop","lbe","application/vnd.llamagraphics.life-balance.exchange+xml","123","application/vnd.lotus-1-2-3","apr","application/vnd.lotus-approach","pre","application/vnd.lotus-freelance","nsf","application/vnd.lotus-notes","org","application/vnd.lotus-organizer","scm","application/vnd.lotus-screencam","lwp","application/vnd.lotus-wordpro","portpkg","application/vnd.macports.portpkg","mcd","application/vnd.mcd","mc1","application/vnd.medcalcdata","cdkey","application/vnd.mediastation.cdkey","mwf","application/vnd.mfer","mfm","application/vnd.mfmp","flo","application/vnd.micrografx.flo","igx","application/vnd.micrografx.igx","mif","application/vnd.mif","daf","application/vnd.mobius.daf","dis","application/vnd.mobius.dis","mbk","application/vnd.mobius.mbk","mqy","application/vnd.mobius.mqy","msl","application/vnd.mobius.msl","plc","application/vnd.mobius.plc","txf","application/vnd.mobius.txf","mpn","application/vnd.mophun.application","mpc","application/vnd.mophun.certificate","xul","application/vnd.mozilla.xul+xml","cil","application/vnd.ms-artgalry","cab","application/vnd.ms-cab-compressed","xls","application/vnd.ms-excel","xla","application/vnd.ms-excel","xlc","application/vnd.ms-excel","xlm","application/vnd.ms-excel","xlt","application/vnd.ms-excel","xlw","application/vnd.ms-excel","xlam","application/vnd.ms-excel.addin.macroenabled.12","xlsb","application/vnd.ms-excel.sheet.binary.macroenabled.12","xlsm","application/vnd.ms-excel.sheet.macroenabled.12","xltm","application/vnd.ms-excel.template.macroenabled.12","eot","application/vnd.ms-fontobject","chm","application/vnd.ms-htmlhelp","ims","application/vnd.ms-ims","lrm","application/vnd.ms-lrm","thmx","application/vnd.ms-officetheme","cat","application/vnd.ms-pki.seccat","stl","application/vnd.ms-pki.stl","ppt","application/vnd.ms-powerpoint","pot","application/vnd.ms-powerpoint","pps","application/vnd.ms-powerpoint","ppam","application/vnd.ms-powerpoint.addin.macroenabled.12","pptm","application/vnd.ms-powerpoint.presentation.macroenabled.12","sldm","application/vnd.ms-powerpoint.slide.macroenabled.12","ppsm","application/vnd.ms-powerpoint.slideshow.macroenabled.12","potm","application/vnd.ms-powerpoint.template.macroenabled.12","mpp","application/vnd.ms-project","mpt","application/vnd.ms-project","docm","application/vnd.ms-word.document.macroenabled.12","dotm","application/vnd.ms-word.template.macroenabled.12","wps","application/vnd.ms-works","wcm","application/vnd.ms-works","wdb","application/vnd.ms-works","wks","application/vnd.ms-works","wpl","application/vnd.ms-wpl","xps","application/vnd.ms-xpsdocument","mseq","application/vnd.mseq","mus","application/vnd.musician","msty","application/vnd.muvee.style","taglet","application/vnd.mynfc","nlu","application/vnd.neurolanguage.nlu","ntf","application/vnd.nitf","nitf","application/vnd.nitf","nnd","application/vnd.noblenet-directory","nns","application/vnd.noblenet-sealer","nnw","application/vnd.noblenet-web","ngdat","application/vnd.nokia.n-gage.data","n-gage","application/vnd.nokia.n-gage.symbian.install","rpst","application/vnd.nokia.radio-preset","rpss","application/vnd.nokia.radio-presets","edm","application/vnd.novadigm.edm","edx","application/vnd.novadigm.edx","ext","application/vnd.novadigm.ext","odc","application/vnd.oasis.opendocument.chart","otc","application/vnd.oasis.opendocument.chart-template","odb","application/vnd.oasis.opendocument.database","odf","application/vnd.oasis.opendocument.formula","odft","application/vnd.oasis.opendocument.formula-template","odg","application/vnd.oasis.opendocument.graphics","otg","application/vnd.oasis.opendocument.graphics-template","odi","application/vnd.oasis.opendocument.image","oti","application/vnd.oasis.opendocument.image-template","odp","application/vnd.oasis.opendocument.presentation","otp","application/vnd.oasis.opendocument.presentation-template","ods","application/vnd.oasis.opendocument.spreadsheet","ots","application/vnd.oasis.opendocument.spreadsheet-template","odt","application/vnd.oasis.opendocument.text","odm","application/vnd.oasis.opendocument.text-master","ott","application/vnd.oasis.opendocument.text-template","oth","application/vnd.oasis.opendocument.text-web","xo","application/vnd.olpc-sugar","dd2","application/vnd.oma.dd2+xml","oxt","application/vnd.openofficeorg.extension","pptx","application/vnd.openxmlformats-officedocument.presentationml.presentation","sldx","application/vnd.openxmlformats-officedocument.presentationml.slide","ppsx","application/vnd.openxmlformats-officedocument.presentationml.slideshow","potx","application/vnd.openxmlformats-officedocument.presentationml.template","xlsx","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","xltx","application/vnd.openxmlformats-officedocument.spreadsheetml.template","docx","application/vnd.openxmlformats-officedocument.wordprocessingml.document","dotx","application/vnd.openxmlformats-officedocument.wordprocessingml.template","mgp","application/vnd.osgeo.mapguide.package","dp","application/vnd.osgi.dp","esa","application/vnd.osgi.subsystem","pdb","application/vnd.palm","oprc","application/vnd.palm","pqa","application/vnd.palm","paw","application/vnd.pawaafile","str","application/vnd.pg.format","ei6","application/vnd.pg.osasli","efif","application/vnd.picsel","wg","application/vnd.pmi.widget","plf","application/vnd.pocketlearn","pbd","application/vnd.powerbuilder6","box","application/vnd.previewsystems.box","mgz","application/vnd.proteus.magazine","qps","application/vnd.publishare-delta-tree","ptid","application/vnd.pvi.ptid1","qxd","application/vnd.quark.quarkxpress","qwd","application/vnd.quark.quarkxpress","qwt","application/vnd.quark.quarkxpress","qxb","application/vnd.quark.quarkxpress","qxl","application/vnd.quark.quarkxpress","qxt","application/vnd.quark.quarkxpress","bed","application/vnd.realvnc.bed","mxl","application/vnd.recordare.musicxml","musicxml","application/vnd.recordare.musicxml+xml","cryptonote","application/vnd.rig.cryptonote","cod","application/vnd.rim.cod","rm","application/vnd.rn-realmedia","rmvb","application/vnd.rn-realmedia-vbr","link66","application/vnd.route66.link66+xml","st","application/vnd.sailingtracker.track","see","application/vnd.seemail","sema","application/vnd.sema","semd","application/vnd.semd","semf","application/vnd.semf","ifm","application/vnd.shana.informed.formdata","itp","application/vnd.shana.informed.formtemplate","iif","application/vnd.shana.informed.interchange","ipk","application/vnd.shana.informed.package","twd","application/vnd.simtech-mindmapper","twds","application/vnd.simtech-mindmapper","mmf","application/vnd.smaf","teacher","application/vnd.smart.teacher","sdkm","application/vnd.solent.sdkm+xml","sdkd","application/vnd.solent.sdkm+xml","dxp","application/vnd.spotfire.dxp","sfs","application/vnd.spotfire.sfs","sdc","application/vnd.stardivision.calc","sda","application/vnd.stardivision.draw","sdd","application/vnd.stardivision.impress","smf","application/vnd.stardivision.math","sdw","application/vnd.stardivision.writer","vor","application/vnd.stardivision.writer","sgl","application/vnd.stardivision.writer-global","smzip","application/vnd.stepmania.package","sm","application/vnd.stepmania.stepchart","sxc","application/vnd.sun.xml.calc","stc","application/vnd.sun.xml.calc.template","sxd","application/vnd.sun.xml.draw","std","application/vnd.sun.xml.draw.template","sxi","application/vnd.sun.xml.impress","sti","application/vnd.sun.xml.impress.template","sxm","application/vnd.sun.xml.math","sxw","application/vnd.sun.xml.writer","sxg","application/vnd.sun.xml.writer.global","stw","application/vnd.sun.xml.writer.template","sus","application/vnd.sus-calendar","susp","application/vnd.sus-calendar","svd","application/vnd.svd","sis","application/vnd.symbian.install","sisx","application/vnd.symbian.install","xsm","application/vnd.syncml+xml","bdm","application/vnd.syncml.dm+wbxml","xdm","application/vnd.syncml.dm+xml","tao","application/vnd.tao.intent-module-archive","pcap","application/vnd.tcpdump.pcap","cap","application/vnd.tcpdump.pcap","dmp","application/vnd.tcpdump.pcap","tmo","application/vnd.tmobile-livetv","tpt","application/vnd.trid.tpt","mxs","application/vnd.triscape.mxs","tra","application/vnd.trueapp","ufd","application/vnd.ufdl","ufdl","application/vnd.ufdl","utz","application/vnd.uiq.theme","umj","application/vnd.umajin","unityweb","application/vnd.unity","uoml","application/vnd.uoml+xml","vcx","application/vnd.vcx","vsd","application/vnd.visio","vss","application/vnd.visio","vst","application/vnd.visio","vsw","application/vnd.visio","vis","application/vnd.visionary","vsf","application/vnd.vsf","wbxml","application/vnd.wap.wbxml","wmlc","application/vnd.wap.wmlc","wmlsc","application/vnd.wap.wmlscriptc","wtb","application/vnd.webturbo","nbp","application/vnd.wolfram.player","wpd","application/vnd.wordperfect","wqd","application/vnd.wqd","stf","application/vnd.wt.stf","xar","application/vnd.xara","xfdl","application/vnd.xfdl","hvd","application/vnd.yamaha.hv-dic","hvs","application/vnd.yamaha.hv-script","hvp","application/vnd.yamaha.hv-voice","osf","application/vnd.yamaha.openscoreformat","osfpvg","application/vnd.yamaha.openscoreformat.osfpvg+xml","saf","application/vnd.yamaha.smaf-audio","spf","application/vnd.yamaha.smaf-phrase","cmp","application/vnd.yellowriver-custom-menu","zir","application/vnd.zul","zirz","application/vnd.zul","zaz","application/vnd.zzazz.deck+xml","vxml","application/voicexml+xml","wasm","application/wasm","wgt","application/widget","hlp","application/winhlp","wsdl","application/wsdl+xml","wspolicy","application/wspolicy+xml","7z","application/x-7z-compressed","abw","application/x-abiword","ace","application/x-ace-compressed","dmg","application/x-apple-diskimage","aab","application/x-authorware-bin","u32","application/x-authorware-bin","vox","application/x-authorware-bin","x32","application/x-authorware-bin","aam","application/x-authorware-map","aas","application/x-authorware-seg","bcpio","application/x-bcpio","torrent","application/x-bittorrent","blb","application/x-blorb","blorb","application/x-blorb","bz","application/x-bzip","bz2","application/x-bzip2","boz","application/x-bzip2","cbr","application/x-cbr","cb7","application/x-cbr","cba","application/x-cbr","cbt","application/x-cbr","cbz","application/x-cbr","vcd","application/x-cdlink","cfs","application/x-cfs-compressed","chat","application/x-chat","pgn","application/x-chess-pgn","nsc","application/x-conference","cpio","application/x-cpio","csh","application/x-csh","deb","application/x-debian-package","udeb","application/x-debian-package","dgc","application/x-dgc-compressed","dir","application/x-director","cct","application/x-director","cst","application/x-director","cxt","application/x-director","dcr","application/x-director","dxr","application/x-director","fgd","application/x-director","swa","application/x-director","w3d","application/x-director","wad","application/x-doom","ncx","application/x-dtbncx+xml","dtb","application/x-dtbook+xml","res","application/x-dtbresource+xml","dvi","application/x-dvi","evy","application/x-envoy","eva","application/x-eva","bdf","application/x-font-bdf","gsf","application/x-font-ghostscript","psf","application/x-font-linux-psf","pcf","application/x-font-pcf","snf","application/x-font-snf","pfa","application/x-font-type1","afm","application/x-font-type1","pfb","application/x-font-type1","pfm","application/x-font-type1","arc","application/x-freearc","spl","application/x-futuresplash","gca","application/x-gca-compressed","ulx","application/x-glulx","gnumeric","application/x-gnumeric","gramps","application/x-gramps-xml","gtar","application/x-gtar","hdf","application/x-hdf","install","application/x-install-instructions","iso","application/x-iso9660-image","jnlp","application/x-java-jnlp-file","latex","application/x-latex","lzh","application/x-lzh-compressed","lha","application/x-lzh-compressed","mie","application/x-mie","prc","application/x-mobipocket-ebook","mobi","application/x-mobipocket-ebook","application","application/x-ms-application","lnk","application/x-ms-shortcut","wmd","application/x-ms-wmd","wmz","application/x-ms-wmz","xbap","application/x-ms-xbap","mdb","application/x-msaccess","obd","application/x-msbinder","crd","application/x-mscardfile","clp","application/x-msclip","exe","application/x-msdownload","bat","application/x-msdownload","com","application/x-msdownload","dll","application/x-msdownload","msi","application/x-msdownload","mvb","application/x-msmediaview","m13","application/x-msmediaview","m14","application/x-msmediaview","wmf","application/x-msmetafile","emf","application/x-msmetafile","emz","application/x-msmetafile","mny","application/x-msmoney","pub","application/x-mspublisher","scd","application/x-msschedule","trm","application/x-msterminal","wri","application/x-mswrite","nc","application/x-netcdf","cdf","application/x-netcdf","nzb","application/x-nzb","p12","application/x-pkcs12","pfx","application/x-pkcs12","p7b","application/x-pkcs7-certificates","spc","application/x-pkcs7-certificates","p7r","application/x-pkcs7-certreqresp","rar","application/x-rar-compressed","ris","application/x-research-info-systems","sh","application/x-sh","shar","application/x-shar","swf","application/x-shockwave-flash","xap","application/x-silverlight-app","sql","application/x-sql","sit","application/x-stuffit","sitx","application/x-stuffitx","srt","application/x-subrip","sv4cpio","application/x-sv4cpio","sv4crc","application/x-sv4crc","t3","application/x-t3vm-image","gam","application/x-tads","tar","application/x-tar","tcl","application/x-tcl","tex","application/x-tex","tfm","application/x-tex-tfm","texinfo","application/x-texinfo","texi","application/x-texinfo","obj","application/x-tgif","ustar","application/x-ustar","src","application/x-wais-source","der","application/x-x509-ca-cert","crt","application/x-x509-ca-cert","fig","application/x-xfig","xlf","application/x-xliff+xml","xpi","application/x-xpinstall","xz","application/x-xz","z1","application/x-zmachine","z2","application/x-zmachine","z3","application/x-zmachine","z4","application/x-zmachine","z5","application/x-zmachine","z6","application/x-zmachine","z7","application/x-zmachine","z8","application/x-zmachine","xaml","application/xaml+xml","xdf","application/xcap-diff+xml","xenc","application/xenc+xml","xhtml","application/xhtml+xml","xht","application/xhtml+xml","xml","application/xml","xsl","application/xml","dtd","application/xml-dtd","xop","application/xop+xml","xpl","application/xproc+xml","xslt","application/xslt+xml","xspf","application/xspf+xml","mxml","application/xv+xml","xhvml","application/xv+xml","xvm","application/xv+xml","xvml","application/xv+xml","yang","application/yang","yin","application/yin+xml","zip","application/zip","aac","audio/aac","adp","audio/adpcm","au","audio/basic","snd","audio/basic","mid","audio/midi","kar","audio/midi","midi","audio/midi","rmi","audio/midi","m4a","audio/mp4","mp4a","audio/mp4","mp3","audio/mpeg","m2a","audio/mpeg","m3a","audio/mpeg","mp2","audio/mpeg","mp2a","audio/mpeg","mpga","audio/mpeg","ogg","audio/ogg","oga","audio/ogg","opus","audio/ogg","spx","audio/ogg","s3m","audio/s3m","sil","audio/silk","uva","audio/vnd.dece.audio","uvva","audio/vnd.dece.audio","eol","audio/vnd.digital-winds","dra","audio/vnd.dra","dts","audio/vnd.dts","dtshd","audio/vnd.dts.hd","lvp","audio/vnd.lucent.voice","pya","audio/vnd.ms-playready.media.pya","ecelp4800","audio/vnd.nuera.ecelp4800","ecelp7470","audio/vnd.nuera.ecelp7470","ecelp9600","audio/vnd.nuera.ecelp9600","rip","audio/vnd.rip","weba","audio/webm","aif","audio/x-aiff","aifc","audio/x-aiff","aiff","audio/x-aiff","caf","audio/x-caf","flac","audio/x-flac","mka","audio/x-matroska","m3u","audio/x-mpegurl","wax","audio/x-ms-wax","wma","audio/x-ms-wma","ram","audio/x-pn-realaudio","ra","audio/x-pn-realaudio","rmp","audio/x-pn-realaudio-plugin","wav","audio/x-wav","xm","audio/xm","cdx","chemical/x-cdx","cif","chemical/x-cif","cmdf","chemical/x-cmdf","cml","chemical/x-cml","csml","chemical/x-csml","xyz","chemical/x-xyz","ttc","font/collection","otf","font/otf","ttf","font/ttf","woff","font/woff","woff2","font/woff2","avif","image/avif","bmp","image/bmp","cgm","image/cgm","g3","image/g3fax","gif","image/gif","heic","image/heic","heif","image/heif","ief","image/ief","jpg","image/jpeg","jpe","image/jpeg","jpeg","image/jpeg","jxl","image/jxl","ktx","image/ktx","png","image/png","btif","image/prs.btif","sgi","image/sgi","svg","image/svg+xml","svgz","image/svg+xml","tiff","image/tiff","tif","image/tiff","psd","image/vnd.adobe.photoshop","uvi","image/vnd.dece.graphic","uvg","image/vnd.dece.graphic","uvvg","image/vnd.dece.graphic","uvvi","image/vnd.dece.graphic","djvu","image/vnd.djvu","djv","image/vnd.djvu","sub","image/vnd.dvb.subtitle","dwg","image/vnd.dwg","dxf","image/vnd.dxf","fbs","image/vnd.fastbidsheet","fpx","image/vnd.fpx","fst","image/vnd.fst","mmr","image/vnd.fujixerox.edmics-mmr","rlc","image/vnd.fujixerox.edmics-rlc","mdi","image/vnd.ms-modi","wdp","image/vnd.ms-photo","npx","image/vnd.net-fpx","wbmp","image/vnd.wap.wbmp","xif","image/vnd.xiff","webp","image/webp","3ds","image/x-3ds","ras","image/x-cmu-raster","cmx","image/x-cmx","fh","image/x-freehand","fh4","image/x-freehand","fh5","image/x-freehand","fh7","image/x-freehand","fhc","image/x-freehand","ico","image/x-icon","sid","image/x-mrsid-image","pcx","image/x-pcx","pic","image/x-pict","pct","image/x-pict","pnm","image/x-portable-anymap","pbm","image/x-portable-bitmap","pgm","image/x-portable-graymap","ppm","image/x-portable-pixmap","rgb","image/x-rgb","tga","image/x-tga","xbm","image/x-xbitmap","xpm","image/x-xpixmap","xwd","image/x-xwindowdump","eml","message/rfc822","mime","message/rfc822","gltf","model/gltf+json","glb","model/gltf-binary","igs","model/iges","iges","model/iges","msh","model/mesh","mesh","model/mesh","silo","model/mesh","dae","model/vnd.collada+xml","dwf","model/vnd.dwf","gdl","model/vnd.gdl","gtw","model/vnd.gtw","vtu","model/vnd.vtu","vrml","model/vrml","wrl","model/vrml","x3db","model/x3d+binary","x3dbz","model/x3d+binary","x3dv","model/x3d+vrml","x3dvz","model/x3d+vrml","x3d","model/x3d+xml","x3dz","model/x3d+xml","appcache","text/cache-manifest","ics","text/calendar","ifb","text/calendar","css","text/css","csv","text/csv","html","text/html","htm","text/html","js","text/javascript","mjs","text/javascript","md","text/markdown","markdown","text/markdown","n3","text/n3","txt","text/plain","conf","text/plain","def","text/plain","in","text/plain","list","text/plain","log","text/plain","text","text/plain","dsc","text/prs.lines.tag","rtx","text/richtext","sgml","text/sgml","sgm","text/sgml","tsv","text/tab-separated-values","t","text/troff","man","text/troff","me","text/troff","ms","text/troff","roff","text/troff","tr","text/troff","ttl","text/turtle","uri","text/uri-list","uris","text/uri-list","urls","text/uri-list","vcard","text/vcard","curl","text/vnd.curl","dcurl","text/vnd.curl.dcurl","mcurl","text/vnd.curl.mcurl","scurl","text/vnd.curl.scurl","fly","text/vnd.fly","flx","text/vnd.fmi.flexstor","gv","text/vnd.graphviz","3dml","text/vnd.in3d.3dml","spot","text/vnd.in3d.spot","jad","text/vnd.sun.j2me.app-descriptor","wml","text/vnd.wap.wml","wmls","text/vnd.wap.wmlscript","asm","text/x-asm","s","text/x-asm","c","text/x-c","cc","text/x-c","cpp","text/x-c","cxx","text/x-c","dic","text/x-c","h","text/x-c","hh","text/x-c","dart","text/x-dart","f","text/x-fortran","f77","text/x-fortran","f90","text/x-fortran","for","text/x-fortran","java","text/x-java-source","nfo","text/x-nfo","opml","text/x-opml","pas","text/x-pascal","p","text/x-pascal","etx","text/x-setext","sfv","text/x-sfv","uu","text/x-uuencode","vcs","text/x-vcalendar","vcf","text/x-vcard","3gp","video/3gpp","3g2","video/3gpp2","h261","video/h261","h263","video/h263","h264","video/h264","jpgv","video/jpeg","jpm","video/jpm","jpgm","video/jpm","mj2","video/mj2","mjp2","video/mj2","ts","video/mp2t","m2t","video/mp2t","m2ts","video/mp2t","mts","video/mp2t","mp4","video/mp4","mp4v","video/mp4","mpg4","video/mp4","mpg","video/mpeg","m1v","video/mpeg","m2v","video/mpeg","mpe","video/mpeg","mpeg","video/mpeg","ogv","video/ogg","mov","video/quicktime","qt","video/quicktime","uvh","video/vnd.dece.hd","uvvh","video/vnd.dece.hd","uvm","video/vnd.dece.mobile","uvvm","video/vnd.dece.mobile","uvp","video/vnd.dece.pd","uvvp","video/vnd.dece.pd","uvs","video/vnd.dece.sd","uvvs","video/vnd.dece.sd","uvv","video/vnd.dece.video","uvvv","video/vnd.dece.video","dvb","video/vnd.dvb.file","fvt","video/vnd.fvt","mxu","video/vnd.mpegurl","m4u","video/vnd.mpegurl","pyv","video/vnd.ms-playready.media.pyv","uvu","video/vnd.uvvu.mp4","uvvu","video/vnd.uvvu.mp4","viv","video/vnd.vivo","webm","video/webm","f4v","video/x-f4v","fli","video/x-fli","flv","video/x-flv","m4v","video/x-m4v","mkv","video/x-matroska","mk3d","video/x-matroska","mks","video/x-matroska","mng","video/x-mng","asf","video/x-ms-asf","asx","video/x-ms-asf","vob","video/x-ms-vob","wm","video/x-ms-wm","wmv","video/x-ms-wmv","wmx","video/x-ms-wmx","wvx","video/x-ms-wvx","avi","video/x-msvideo","movie","video/x-sgi-movie","smv","video/x-smv","ice","x-conference/x-cooltalk"],A.T("aJ<V,V>"))
B.cg=new A.aJ([34665,"exif",40965,"interop",34853,"gps"],A.T("aJ<f,V>"))
B.d0=new A.aB(2,"falseFloydSteinberg")
B.d1=new A.aB(3,"jarvisJudiceNinke")
B.d2=new A.aB(4,"stucki")
B.d3=new A.aB(5,"burkes")
B.d4=new A.aB(6,"atkinson")
B.aM=s([0,0,0],t.a)
B.ig=s([B.aM,B.aM,B.aM],t.U)
B.iq=s([0.4375,1,0],t.a)
B.ip=s([0.1875,-1,1],t.a)
B.em=s([0.3125,0,1],t.a)
B.jl=s([0.0625,1,1],t.a)
B.iX=s([B.iq,B.ip,B.em,B.jl],t.U)
B.h1=s([0.375,1,0],t.a)
B.kV=s([0.375,0,1],t.a)
B.ks=s([0.25,1,1],t.a)
B.f0=s([B.h1,B.kV,B.ks],t.U)
B.dz=s([0.14583333333333334,1,0],t.a)
B.iO=s([0.10416666666666667,2,0],t.a)
B.bV=s([0.0625,-2,1],t.a)
B.jk=s([0.10416666666666667,-1,1],t.a)
B.km=s([0.14583333333333334,0,1],t.a)
B.hP=s([0.10416666666666667,1,1],t.a)
B.c1=s([0.0625,2,1],t.a)
B.hR=s([0.020833333333333332,-2,2],t.a)
B.fV=s([0.0625,-1,2],t.a)
B.k1=s([0.10416666666666667,0,2],t.a)
B.k9=s([0.0625,1,2],t.a)
B.hz=s([0.020833333333333332,2,2],t.a)
B.ix=s([B.dz,B.iO,B.bV,B.jk,B.km,B.hP,B.c1,B.hR,B.fV,B.k1,B.k9,B.hz],t.U)
B.jK=s([0.19047619047619047,1,0],t.a)
B.kR=s([0.09523809523809523,2,0],t.a)
B.eq=s([0.047619047619047616,-2,1],t.a)
B.fP=s([0.09523809523809523,-1,1],t.a)
B.kp=s([0.19047619047619047,0,1],t.a)
B.hx=s([0.09523809523809523,1,1],t.a)
B.fk=s([0.047619047619047616,2,1],t.a)
B.kC=s([0.023809523809523808,-2,2],t.a)
B.kj=s([0.047619047619047616,-1,2],t.a)
B.l_=s([0.09523809523809523,0,2],t.a)
B.fK=s([0.047619047619047616,1,2],t.a)
B.jZ=s([0.023809523809523808,2,2],t.a)
B.fE=s([B.jK,B.kR,B.eq,B.fP,B.kp,B.hx,B.fk,B.kC,B.kj,B.l_,B.fK,B.jZ],t.U)
B.kE=s([0.25,1,0],t.a)
B.bI=s([0.125,2,0],t.a)
B.br=s([0.125,-1,1],t.a)
B.jf=s([0.25,0,1],t.a)
B.bW=s([0.125,1,1],t.a)
B.kz=s([B.kE,B.bI,B.bV,B.br,B.jf,B.bW,B.c1],t.U)
B.hO=s([0.125,1,0],t.a)
B.hg=s([0.125,0,1],t.a)
B.j4=s([0.125,0,2],t.a)
B.f_=s([B.hO,B.bI,B.br,B.hg,B.bW,B.j4],t.U)
B.l4=new A.aJ([B.ba,B.ig,B.aG,B.iX,B.d0,B.f0,B.d1,B.ix,B.d2,B.fE,B.d3,B.kz,B.d4,B.f_],A.T("aJ<aB,r<r<k>>>"))
B.d5=new A.aB(7,"bayer2x2")
B.d7=new A.aB(9,"bayer8x8")
B.j7=s([0,0.5],t.n)
B.jq=s([0.75,0.25],t.n)
B.fr=s([B.j7,B.jq],t.A)
B.hu=s([0,0.5,0.125,0.625],t.n)
B.kO=s([0.75,0.25,0.875,0.375],t.n)
B.j8=s([0.1875,0.6875,0.0625,0.5625],t.n)
B.hy=s([0.9375,0.4375,0.8125,0.3125],t.n)
B.ew=s([B.hu,B.kO,B.j8,B.hy],t.A)
B.hj=s([0,0.5,0.125,0.625,0.03125,0.53125,0.15625,0.65625],t.n)
B.fa=s([0.75,0.25,0.875,0.375,0.78125,0.28125,0.90625,0.40625],t.n)
B.dR=s([0.1875,0.6875,0.0625,0.5625,0.21875,0.71875,0.09375,0.59375],t.n)
B.f6=s([0.9375,0.4375,0.8125,0.3125,0.96875,0.46875,0.84375,0.34375],t.n)
B.hS=s([0.046875,0.546875,0.171875,0.671875,0.015625,0.515625,0.140625,0.640625],t.n)
B.ez=s([0.796875,0.296875,0.921875,0.421875,0.765625,0.265625,0.890625,0.390625],t.n)
B.k0=s([0.234375,0.734375,0.109375,0.609375,0.203125,0.703125,0.078125,0.578125],t.n)
B.ku=s([0.984375,0.484375,0.859375,0.359375,0.953125,0.453125,0.828125,0.328125],t.n)
B.ft=s([B.hj,B.fa,B.dR,B.f6,B.hS,B.ez,B.k0,B.ku],t.A)
B.ch=new A.aJ([B.d5,B.fr,B.d6,B.ew,B.d7,B.ft],A.T("aJ<aB,r<r<D>>>"))
B.ci=new A.aJ([B.A,1,B.u,3,B.B,15,B.e,255,B.n,65535,B.R,4294967295,B.U,127,B.V,32767,B.W,2147483647,B.I,1,B.Q,1,B.T,1],A.T("aJ<at,f>"))
B.ld=new A.hF(0,"none")
B.le=new A.hF(4,"paeth")
B.a7=new A.c3(0,"invalid")
B.co=new A.c3(1,"pbm")
B.cp=new A.c3(2,"pgm2")
B.aW=new A.c3(3,"pgm5")
B.cq=new A.c3(4,"ppm3")
B.aX=new A.c3(5,"ppm6")
B.m7=new A.eQ(0,"auto")
B.lj=new A.eQ(3,"rgb4")
B.lk=new A.eQ(4,"rgba4")
B.m8=new A.jL(1,"neural")
B.cv=new A.cP(0,0)
B.aZ=new A.aZ(0,"bilevel")
B.lt=new A.aZ(1,"gray4bit")
B.lu=new A.aZ(2,"gray")
B.lv=new A.aZ(3,"grayAlpha")
B.lw=new A.aZ(4,"palette")
B.cy=new A.aZ(5,"rgb")
B.lx=new A.aZ(6,"rgba")
B.ly=new A.aZ(7,"yCbCrSub")
B.a8=new A.aZ(8,"generic")
B.lz=new A.aZ(9,"invalid")
B.lN=A.bg("fE")
B.lO=A.bg("iM")
B.lP=A.bg("iW")
B.lQ=A.bg("e2")
B.lR=A.bg("h8")
B.lS=A.bg("ef")
B.lT=A.bg("jb")
B.lU=A.bg("J")
B.lV=A.bg("i_")
B.lW=A.bg("bp")
B.lX=A.bg("jW")
B.lY=A.bg("bK")
B.lZ=new A.i3(!1)
B.m_=new A.i3(!0)
B.a9=new A.dE(0,"undefined")
B.b3=new A.dE(1,"lossy")
B.aB=new A.dE(2,"lossless")
B.m2=new A.dE(3,"animated")
B.aC=new A.dG(0,"none")
B.m3=new A.dG(1,"partial")
B.m4=new A.dG(2,"full")
B.aa=new A.dG(3,"finish")})();(function staticFields(){$.kM=null
$.aP=A.j([],A.T("t<J>"))
$.nF=null
$.n4=null
$.n3=null
$.oA=null
$.or=null
$.oG=null
$.li=null
$.lw=null
$.mH=null
$.kP=A.j([],A.T("t<r<J>?>"))
$.dM=null
$.fu=null
$.fv=null
$.mB=!1
$.a2=B.F
$.bh=A.nU("_config")
$.my=null
$.nR=!1
$.rc=A.j([A.mO(),A.v5(),A.va(),A.vb(),A.vc(),A.vd(),A.ve(),A.vf(),A.vg(),A.vh(),A.v6(),A.v7(),A.v8(),A.v9(),A.mO(),A.mO()],A.T("t<f(f,bp,f)>"))
$.U=null
$.nd=A.nU("_eLut")})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"vn","oK",()=>A.lr("_$dart_dartClosure"))
s($,"vm","mQ",()=>A.lr("_$dart_dartClosure_dartJSInterop"))
s($,"wc","p8",()=>A.j([new J.hl()],A.T("t<eR>")))
s($,"vy","oO",()=>A.bJ(A.jV({
toString:function(){return"$receiver$"}})))
s($,"vz","oP",()=>A.bJ(A.jV({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"vA","oQ",()=>A.bJ(A.jV(null)))
s($,"vB","oR",()=>A.bJ(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"vE","oU",()=>A.bJ(A.jV(void 0)))
s($,"vF","oV",()=>A.bJ(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"vD","oT",()=>A.bJ(A.nN(null)))
s($,"vC","oS",()=>A.bJ(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"vH","oX",()=>A.bJ(A.nN(void 0)))
s($,"vG","oW",()=>A.bJ(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"vP","mS",()=>A.ro())
s($,"vV","p4",()=>A.hw(4096))
s($,"vT","p2",()=>new A.kY().$0())
s($,"vU","p3",()=>new A.kX().$0())
s($,"wa","iG",()=>A.iA(B.lU))
s($,"vS","p1",()=>A.mu(B.am,B.aN,257,286,15))
s($,"vR","p0",()=>A.mu(B.bK,B.a4,0,30,15))
s($,"vQ","p_",()=>A.mu(null,B.dZ,0,19,7))
s($,"vp","oM",()=>A.fX(B.kH))
s($,"vo","oL",()=>A.fX(B.f9))
s($,"we","lI",()=>{var q=null,p="ISOSpeed"
return A.lZ([11,A.i("ProcessingSoftware",B.l,q),254,A.i("SubfileType",B.p,1),255,A.i("OldSubfileType",B.p,1),256,A.i("ImageWidth",B.p,1),257,A.i("ImageLength",B.p,1),258,A.i("BitsPerSample",B.k,1),259,A.i("Compression",B.k,1),262,A.i("PhotometricInterpretation",B.k,1),263,A.i("Thresholding",B.k,1),264,A.i("CellWidth",B.k,1),265,A.i("CellLength",B.k,1),266,A.i("FillOrder",B.k,1),269,A.i("DocumentName",B.l,q),270,A.i("ImageDescription",B.l,q),271,A.i("Make",B.l,q),272,A.i("Model",B.l,q),273,A.i("StripOffsets",B.p,q),274,A.i("Orientation",B.k,1),277,A.i("SamplesPerPixel",B.k,1),278,A.i("RowsPerStrip",B.p,1),279,A.i("StripByteCounts",B.p,1),280,A.i("MinSampleValue",B.k,1),281,A.i("MaxSampleValue",B.k,1),282,A.i("XResolution",B.t,1),283,A.i("YResolution",B.t,1),284,A.i("PlanarConfiguration",B.k,1),285,A.i("PageName",B.l,q),286,A.i("XPosition",B.t,1),287,A.i("YPosition",B.t,1),290,A.i("GrayResponseUnit",B.k,1),291,A.i("GrayResponseCurve",B.f,q),292,A.i("T4Options",B.f,q),293,A.i("T6Options",B.f,q),296,A.i("ResolutionUnit",B.k,1),297,A.i("PageNumber",B.k,2),300,A.i("ColorResponseUnit",B.f,q),301,A.i("TransferFunction",B.k,768),305,A.i("Software",B.l,q),306,A.i("DateTime",B.l,q),315,A.i("Artist",B.l,q),316,A.i("HostComputer",B.l,q),317,A.i("Predictor",B.k,1),318,A.i("WhitePoint",B.t,2),319,A.i("PrimaryChromaticities",B.t,6),320,A.i("ColorMap",B.k,q),321,A.i("HalftoneHints",B.k,2),322,A.i("TileWidth",B.p,1),323,A.i("TileLength",B.p,1),324,A.i("TileOffsets",B.p,q),325,A.i("TileByteCounts",B.f,q),326,A.i("BadFaxLines",B.f,q),327,A.i("CleanFaxData",B.f,q),328,A.i("ConsecutiveBadFaxLines",B.f,q),332,A.i("InkSet",B.f,q),333,A.i("InkNames",B.f,q),334,A.i("NumberofInks",B.f,q),336,A.i("DotRange",B.f,q),337,A.i("TargetPrinter",B.l,q),338,A.i("ExtraSamples",B.f,q),339,A.i("SampleFormat",B.k,1),340,A.i("SMinSampleValue",B.f,q),341,A.i("SMaxSampleValue",B.f,q),342,A.i("TransferRange",B.f,q),343,A.i("ClipPath",B.f,q),512,A.i("JPEGProc",B.f,q),513,A.i("JPEGInterchangeFormat",B.f,q),514,A.i("JPEGInterchangeFormatLength",B.f,q),529,A.i("YCbCrCoefficients",B.t,3),530,A.i("YCbCrSubSampling",B.k,1),531,A.i("YCbCrPositioning",B.k,1),532,A.i("ReferenceBlackWhite",B.t,6),700,A.i("ApplicationNotes",B.k,1),18246,A.i("Rating",B.k,1),33421,A.i("CFARepeatPatternDim",B.f,q),33422,A.i("CFAPattern",B.f,q),33423,A.i("BatteryLevel",B.f,q),33432,A.i("Copyright",B.l,q),33434,A.i("ExposureTime",B.t,1),33437,A.i("FNumber",B.t,q),33723,A.i("IPTC-NAA",B.p,1),34665,A.i("ExifOffset",B.f,q),34675,A.i("InterColorProfile",B.f,q),34850,A.i("ExposureProgram",B.k,1),34852,A.i("SpectralSensitivity",B.l,q),34853,A.i("GPSOffset",B.f,q),34855,A.i(p,B.p,1),34856,A.i("OECF",B.f,q),34864,A.i("SensitivityType",B.k,1),34866,A.i("RecommendedExposureIndex",B.p,1),34867,A.i(p,B.p,1),36864,A.i("ExifVersion",B.J,q),36867,A.i("DateTimeOriginal",B.l,q),36868,A.i("DateTimeDigitized",B.l,q),36880,A.i("OffsetTime",B.l,q),36881,A.i("OffsetTimeOriginal",B.l,q),36882,A.i("OffsetTimeDigitized",B.l,q),37121,A.i("ComponentsConfiguration",B.J,q),37122,A.i("CompressedBitsPerPixel",B.f,q),37377,A.i("ShutterSpeedValue",B.f,q),37378,A.i("ApertureValue",B.f,q),37379,A.i("BrightnessValue",B.f,q),37380,A.i("ExposureBiasValue",B.f,q),37381,A.i("MaxApertureValue",B.f,q),37382,A.i("SubjectDistance",B.f,q),37383,A.i("MeteringMode",B.f,q),37384,A.i("LightSource",B.f,q),37385,A.i("Flash",B.f,q),37386,A.i("FocalLength",B.f,q),37396,A.i("SubjectArea",B.f,q),37500,A.i("MakerNote",B.J,q),37510,A.i("UserComment",B.J,q),37520,A.i("SubSecTime",B.f,q),37521,A.i("SubSecTimeOriginal",B.f,q),37522,A.i("SubSecTimeDigitized",B.f,q),40091,A.i("XPTitle",B.f,q),40092,A.i("XPComment",B.f,q),40093,A.i("XPAuthor",B.f,q),40094,A.i("XPKeywords",B.f,q),40095,A.i("XPSubject",B.f,q),40960,A.i("FlashPixVersion",B.f,q),40961,A.i("ColorSpace",B.k,1),40962,A.i("ExifImageWidth",B.k,1),40963,A.i("ExifImageLength",B.k,1),40964,A.i("RelatedSoundFile",B.f,q),40965,A.i("InteroperabilityOffset",B.f,q),41483,A.i("FlashEnergy",B.f,q),41484,A.i("SpatialFrequencyResponse",B.f,q),41486,A.i("FocalPlaneXResolution",B.f,q),41487,A.i("FocalPlaneYResolution",B.f,q),41488,A.i("FocalPlaneResolutionUnit",B.f,q),41492,A.i("SubjectLocation",B.f,q),41493,A.i("ExposureIndex",B.f,q),41495,A.i("SensingMethod",B.f,q),41728,A.i("FileSource",B.f,q),41729,A.i("SceneType",B.f,q),41730,A.i("CVAPattern",B.f,q),41985,A.i("CustomRendered",B.f,q),41986,A.i("ExposureMode",B.f,q),41987,A.i("WhiteBalance",B.f,q),41988,A.i("DigitalZoomRatio",B.f,q),41989,A.i("FocalLengthIn35mmFilm",B.f,q),41990,A.i("SceneCaptureType",B.f,q),41991,A.i("GainControl",B.f,q),41992,A.i("Contrast",B.f,q),41993,A.i("Saturation",B.f,q),41994,A.i("Sharpness",B.f,q),41995,A.i("DeviceSettingDescription",B.f,q),41996,A.i("SubjectDistanceRange",B.f,q),42016,A.i("ImageUniqueID",B.f,q),42032,A.i("CameraOwnerName",B.l,q),42033,A.i("BodySerialNumber",B.l,q),42034,A.i("LensSpecification",B.f,q),42035,A.i("LensMake",B.l,q),42036,A.i("LensModel",B.l,q),42037,A.i("LensSerialNumber",B.l,q),42240,A.i("Gamma",B.t,1),50341,A.i("PrintIM",B.f,q),59932,A.i("Padding",B.f,q),59933,A.i("OffsetSchema",B.f,q),65e3,A.i("OwnerName",B.l,q),65001,A.i("SerialNumber",B.l,q)],t.p,A.T("fP"))})
s($,"vq","iD",()=>A.m0(A.j([0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63],t.t)))
r($,"vI","iE",()=>A.hw(511))
r($,"vJ","lE",()=>A.hw(511))
r($,"vL","lF",()=>A.nA(2041))
r($,"vM","lG",()=>A.nA(225))
r($,"vK","aH",()=>A.hw(766))
s($,"wf","mV",()=>A.m0(B.js))
s($,"wg","p9",()=>A.m0(B.hX))
s($,"wb","fy",()=>new A.l6().$0())
s($,"vN","oY",()=>A.nz(0))
s($,"vO","oZ",()=>A.n7(0,0,0,0))
s($,"vv","oN",()=>A.np(0,0,0))
s($,"w6","aq",()=>A.hw(1))
s($,"w7","az",()=>A.pN(B.d.gB($.aq()),0,null))
s($,"w_","ap",()=>A.q5(1))
s($,"w0","ay",()=>J.pa(B.C.gB($.ap()),0,null))
s($,"w1","P",()=>A.q7(1))
s($,"w3","a7",()=>J.pb(B.o.gB($.P()),0,null))
s($,"w2","cd",()=>A.pE(B.o.gB($.P())))
s($,"vY","iF",()=>A.nz(1))
s($,"vZ","lH",()=>A.nO(B.z.gB($.iF()),0))
s($,"vW","mT",()=>A.q0(1))
s($,"vX","p5",()=>A.nO(B.a6.gB($.mT()),0))
s($,"w4","mU",()=>A.qu(1))
s($,"w5","p6",()=>{var q=$.mU()
return A.pF(q.gB(q))})
s($,"vr","lD",()=>new A.jq(A.j([],A.T("t<eo>"))))
r($,"vs","mR",()=>new A.jr())
s($,"w9","p7",()=>{var q=t.N
return new A.jv(A.I(q,q),A.j([],A.T("t<vt>")))})})();(function nativeSupport(){!function(){var s=function(a){var m={}
m[a]=1
return Object.keys(hunkHelpers.convertToFastObject(m))[0]}
v.getIsolateTag=function(a){return s("___dart_"+a+v.isolateTag)}
var r="___dart_isolate_tags_"
var q=Object[r]||(Object[r]=Object.create(null))
var p="_ZxYxX"
for(var o=0;;o++){var n=s(p+"_"+o+"_")
if(!(n in q)){q[n]=1
v.isolateTag=n
break}}v.dispatchPropertyName=v.getIsolateTag("dispatch_record")}()
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.cr,SharedArrayBuffer:A.cr,ArrayBufferView:A.ev,DataView:A.hv,Float32Array:A.eq,Float64Array:A.er,Int16Array:A.es,Int32Array:A.et,Int8Array:A.eu,Uint16Array:A.ew,Uint32Array:A.ex,Uint8ClampedArray:A.ey,CanvasPixelArray:A.ey,Uint8Array:A.cs})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.ak.$nativeSuperclassTag="ArrayBufferView"
A.fh.$nativeSuperclassTag="ArrayBufferView"
A.fi.$nativeSuperclassTag="ArrayBufferView"
A.c1.$nativeSuperclassTag="ArrayBufferView"
A.fj.$nativeSuperclassTag="ArrayBufferView"
A.fk.$nativeSuperclassTag="ArrayBufferView"
A.aM.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$0=function(){return this()}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$0=function(){return this()}
Function.prototype.$1$1=function(a){return this(a)}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.uu
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=native_executor.js.map
