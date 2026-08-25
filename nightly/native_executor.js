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
if(a[b]!==s){A.tf(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.j(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.lS(b)
return new s(c,this)}:function(){if(s===null)s=A.lS(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.lS(a).prototype
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
lZ(a,b,c,d){return{i:a,p:b,e:c,x:d}},
kL(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.lV==null){A.t2()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.h(A.n0("Return interceptor for "+A.z(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.ke
if(o==null)o=$.ke=A.kK(n)
p=q[o]}if(p!=null)return p
p=A.t8(a)
if(p!=null)return p
if(typeof a=="function")return B.dw
s=Object.getPrototypeOf(a)
if(s==null)return B.cl
if(s===Object.prototype)return B.cl
if(typeof q=="function"){o=$.ke
if(o==null)o=$.ke=A.kK(n)
Object.defineProperty(q,o,{value:B.b3,enumerable:false,writable:true,configurable:true})
return B.b3}return B.b3},
mG(a,b){if(a<0||a>4294967295)throw A.h(A.ap(a,0,4294967295,"length",null))
return J.mH(new Array(a),b)},
ao(a,b){if(a<0||a>4294967295)throw A.h(A.ap(a,0,4294967295,"length",null))
return J.mH(new Array(a),b)},
h5(a,b){if(a<0)throw A.h(A.br("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.q("t<0>"))},
cg(a,b){if(a<0)throw A.h(A.br("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.q("t<0>"))},
mH(a,b){var s=A.j(a,b.q("t<0>"))
s.$flags=1
return s},
mI(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
oQ(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.mI(r))break;++b}return b},
oR(a,b){var s,r,q
for(s=a.length;b>0;b=r){r=b-1
if(!(r<s))return A.a(a,r)
q=a.charCodeAt(r)
if(q!==32&&q!==13&&!J.mI(q))break}return b},
cF(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.d8.prototype
return J.e7.prototype}if(typeof a=="string")return J.d9.prototype
if(a==null)return J.e6.prototype
if(typeof a=="boolean")return J.h6.prototype
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bA.prototype
if(typeof a=="symbol")return J.db.prototype
if(typeof a=="bigint")return J.da.prototype
return a}if(a instanceof A.J)return a
return J.kL(a)},
a5(a){if(typeof a=="string")return J.d9.prototype
if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bA.prototype
if(typeof a=="symbol")return J.db.prototype
if(typeof a=="bigint")return J.da.prototype
return a}if(a instanceof A.J)return a
return J.kL(a)},
am(a){if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bA.prototype
if(typeof a=="symbol")return J.db.prototype
if(typeof a=="bigint")return J.da.prototype
return a}if(a instanceof A.J)return a
return J.kL(a)},
rZ(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.d8.prototype
return J.e7.prototype}if(a==null)return a
if(!(a instanceof A.J))return J.dr.prototype
return a},
bc(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bA.prototype
if(typeof a=="symbol")return J.db.prototype
if(typeof a=="bigint")return J.da.prototype
return a}if(a instanceof A.J)return a
return J.kL(a)},
c9(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.cF(a).Y(a,b)},
d(a,b){if(typeof b==="number")if(Array.isArray(a)||A.t7(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.am(a).l(a,b)},
x(a,b,c){return J.am(a).h(a,b,c)},
m7(a,b,c){return J.bc(a).fZ(a,b,c)},
ob(a,b,c){return J.bc(a).h_(a,b,c)},
oc(a,b,c){return J.bc(a).h0(a,b,c)},
l1(a,b,c){return J.bc(a).h1(a,b,c)},
od(a){return J.bc(a).h2(a)},
m8(a,b,c){return J.bc(a).dr(a,b,c)},
Z(a,b,c){return J.bc(a).h3(a,b,c)},
aC(a){return J.bc(a).h4(a)},
D(a,b,c){return J.bc(a).cN(a,b,c)},
m9(a,b){return J.am(a).bG(a,b)},
bp(a,b,c,d){return J.am(a).aD(a,b,c,d)},
aP(a){return J.cF(a).gJ(a)},
fh(a){return J.am(a).gH(a)},
bq(a){return J.a5(a).gv(a)},
oe(a){return J.bc(a).gcV(a)},
of(a){return J.cF(a).gaT(a)},
l2(a){if(typeof a==="number")return a>0?1:a<0?-1:a
return J.rZ(a).gem(a)},
og(a,b,c){return J.am(a).cz(a,b,c)},
ma(a,b,c){return J.bc(a).hE(a,b,c)},
l3(a,b){return J.am(a).dz(a,b)},
l4(a,b,c){return J.am(a).bj(a,b,c)},
oh(a,b){return J.am(a).hp(a,b)},
dH(a){return J.cF(a).D(a)},
oi(a,b){return J.am(a).hv(a,b)},
fT:function fT(){},
h6:function h6(){},
e6:function e6(){},
e9:function e9(){},
bW:function bW(){},
hl:function hl(){},
dr:function dr(){},
bA:function bA(){},
da:function da(){},
db:function db(){},
t:function t(a){this.$ti=a},
h4:function h4(){},
iO:function iO(a){this.$ti=a},
dI:function dI(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
e8:function e8(){},
d8:function d8(){},
e7:function e7(){},
d9:function d9(){}},A={ld:function ld(){},
iU(a){return new A.dc("Field '"+a+"' has not been initialized.")},
oS(a){return new A.dc("Field '"+a+"' has already been initialized.")},
bD(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
jn(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
fg(a,b,c){return a},
lW(a){var s,r
for(s=$.aN.length,r=0;r<s;++r)if(a===$.aN[r])return!0
return!1},
dq(a,b,c,d){A.dn(b,"start")
if(c!=null){A.dn(c,"end")
if(b>c)A.az(A.ap(b,0,c,"start",null))}return new A.eJ(a,b,c,d.q("eJ<0>"))},
oU(a,b,c,d){if(t.gw.b(a))return new A.dK(a,b,c.q("@<0>").an(d).q("dK<1,2>"))
return new A.bB(a,b,c.q("@<0>").an(d).q("bB<1,2>"))},
iN(){return new A.dp("No element")},
mE(){return new A.dp("Too few elements")},
dc:function dc(a){this.a=a},
an:function an(a){this.a=a},
jm:function jm(){},
E:function E(){},
aE:function aE(){},
eJ:function eJ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
ci:function ci(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bB:function bB(a,b,c){this.a=a
this.b=b
this.$ti=c},
dK:function dK(a,b,c){this.a=a
this.b=b
this.$ti=c},
ed:function ed(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
b6:function b6(a,b,c){this.a=a
this.b=b
this.$ti=c},
eU:function eU(a,b,c){this.a=a
this.b=b
this.$ti=c},
eV:function eV(a,b,c){this.a=a
this.b=b
this.$ti=c},
ca:function ca(a){this.$ti=a},
dL:function dL(a){this.$ti=a},
cB:function cB(a,b){this.a=a
this.$ti=b},
eW:function eW(a,b){this.a=a
this.$ti=b},
X:function X(){},
bm:function bm(){},
ds:function ds(){},
nN(a){var s=A.nM(a)
if(s!=null)return s
return"minified:"+a},
t7(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.ez.b(a)},
z(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.dH(a)
return s},
eB(a){var s,r=$.mR
if(r==null)r=$.mR=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
pi(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
if(3>=r.length)return A.a(r,3)
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
hq(a){var s,r,q,p
if(a instanceof A.J)return A.ax(A.ay(a),null)
s=J.cF(a)
if(s===B.du||s===B.dx||t.bI.b(a)){r=B.b5(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.ax(A.ay(a),null)},
mS(a){var s,r,q
if(a==null||typeof a=="number"||A.ku(a))return J.dH(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.at)return a.D(0)
if(a instanceof A.c2)return a.fG(!0)
s=$.oa()
for(r=0;r<1;++r){q=s[r].lF(a)
if(q!=null)return q}return"Instance of '"+A.hq(a)+"'"},
mQ(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
pj(a){var s,r,q,p=A.j([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.U)(a),++r){q=a[r]
if(!A.i2(q))throw A.h(A.c5(q))
if(q<=65535)B.c.C(p,q)
else if(q<=1114111){B.c.C(p,55296+(B.a.j(q-65536,10)&1023))
B.c.C(p,56320+(q&1023))}else throw A.h(A.c5(q))}return A.mQ(p)},
mT(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.i2(q))throw A.h(A.c5(q))
if(q<0)throw A.h(A.c5(q))
if(q>65535)return A.pj(a)}return A.mQ(a)},
pk(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
dh(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.j(s,10)|55296)>>>0,s&1023|56320)}throw A.h(A.ap(a,0,1114111,null,null))},
dg(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
ph(a){var s=A.dg(a).getUTCFullYear()+0
return s},
pf(a){var s=A.dg(a).getUTCMonth()+1
return s},
pb(a){var s=A.dg(a).getUTCDate()+0
return s},
pc(a){var s=A.dg(a).getUTCHours()+0
return s},
pe(a){var s=A.dg(a).getUTCMinutes()+0
return s},
pg(a){var s=A.dg(a).getUTCSeconds()+0
return s},
pd(a){var s=A.dg(a).getUTCMilliseconds()+0
return s},
pa(a){var s=a.$thrownJsError
if(s==null)return null
return A.bN(s)},
mU(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.a6(a,s)
a.$thrownJsError=s
s.stack=b.D(0)}},
i8(a){throw A.h(A.c5(a))},
a(a,b){if(a==null)J.bq(a)
throw A.h(A.kA(a,b))},
kA(a,b){var s,r="index"
if(!A.i2(b))return new A.b1(!0,b,r,null)
s=J.bq(a)
if(b<0||b>=s)return A.lc(b,s,a,null,r)
return A.ly(b,r)},
rM(a,b,c){if(a<0||a>c)return A.ap(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ap(b,a,c,"end",null)
return new A.b1(!0,b,"end",null)},
c5(a){return new A.b1(!0,a,null,null)},
h(a){return A.a6(a,new Error())},
a6(a,b){var s
if(a==null)a=new A.bl()
b.dartException=a
s=A.tg
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
tg(){return J.dH(this.dartException)},
az(a,b){throw A.a6(a,b==null?new Error():b)},
b(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.az(A.qS(a,b,c),s)},
qS(a,b,c){var s,r,q,p,o,n,m,l,k
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
return new A.eL("'"+s+"': Cannot "+o+" "+l+k+n)},
U(a){throw A.h(A.be(a))},
bE(a){var s,r,q,p,o,n
a=A.te(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.j([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.ju(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
jv(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
mZ(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
le(a,b){var s=b==null,r=s?null:b.method
return new A.ha(a,r,s?null:b.receiver)},
c7(a){var s
if(a==null)return new A.j7(a)
if(a instanceof A.dM){s=a.a
return A.c6(a,s==null?A.fd(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.c6(a,a.dartException)
return A.rA(a)},
c6(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
rA(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.j(r,16)&8191)===10)switch(q){case 438:return A.c6(a,A.le(A.z(s)+" (Error "+q+")",null))
case 445:case 5007:A.z(s)
return A.c6(a,new A.en())}}if(a instanceof TypeError){p=$.nS()
o=$.nT()
n=$.nU()
m=$.nV()
l=$.nY()
k=$.nZ()
j=$.nX()
$.nW()
i=$.o0()
h=$.o_()
g=p.bM(s)
if(g!=null)return A.c6(a,A.le(A.bK(s),g))
else{g=o.bM(s)
if(g!=null){g.method="call"
return A.c6(a,A.le(A.bK(s),g))}else if(n.bM(s)!=null||m.bM(s)!=null||l.bM(s)!=null||k.bM(s)!=null||j.bM(s)!=null||m.bM(s)!=null||i.bM(s)!=null||h.bM(s)!=null){A.bK(s)
return A.c6(a,new A.en())}}return A.c6(a,new A.hK(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.eG()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.c6(a,new A.b1(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.eG()
return a},
bN(a){var s
if(a instanceof A.dM)return a.b
if(a==null)return new A.f7(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.f7(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
i9(a){if(a==null)return J.aP(a)
if(typeof a=="object")return A.eB(a)
return J.aP(a)},
rI(a){if(typeof a=="number")return B.b.gJ(a)
if(a instanceof A.hZ)return A.eB(a)
if(a instanceof A.c2)return a.gJ(a)
return A.i9(a)},
nF(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.h(0,a[s],a[r])}return b},
r5(a,b,c,d,e,f){t.Z.a(a)
switch(A.o(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.h(A.ml("Unsupported number of arguments for wrapped closure"))},
dF(a,b){var s=a.$identity
if(!!s)return s
s=A.rJ(a,b)
a.$identity=s
return s},
rJ(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.r5)},
oq(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.hE().constructor.prototype):Object.create(new A.cH(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.mi(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.om(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.mi(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
om(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.h("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.ok)}throw A.h("Error in functionType of tearoff")},
on(a,b,c,d){var s=A.mh
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
mi(a,b,c,d){if(c)return A.op(a,b,d)
return A.on(b.length,d,a,b)},
oo(a,b,c,d){var s=A.mh,r=A.ol
switch(b?-1:a){case 0:throw A.h(new A.hD("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
op(a,b,c){var s,r
if($.mf==null)$.mf=A.me("interceptor")
if($.mg==null)$.mg=A.me("receiver")
s=b.length
r=A.oo(s,c,a,b)
return r},
lS(a){return A.oq(a)},
ok(a,b){return A.fb(v.typeUniverse,A.ay(a.a),b)},
mh(a){return a.a},
ol(a){return a.b},
me(a){var s,r,q,p=new A.cH("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.h(A.br("Field name "+a+" not found.",null))},
kK(a){return v.getIsolateTag(a)},
uK(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
t8(a){var s,r,q,p,o,n=A.bK($.nG.$1(a)),m=$.kB[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.kP[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.nn($.nz.$2(a,n))
if(q!=null){m=$.kB[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.kP[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.kR(s)
$.kB[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.kP[n]=s
return s}if(p==="-"){o=A.kR(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.nJ(a,s)
if(p==="*")throw A.h(A.n0(n))
if(v.leafTags[n]===true){o=A.kR(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.nJ(a,s)},
nJ(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.lZ(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
kR(a){return J.lZ(a,!1,null,!!a.$iaJ)},
ta(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.kR(s)
else return J.lZ(s,c,null,null)},
t2(){if(!0===$.lV)return
$.lV=!0
A.t3()},
t3(){var s,r,q,p,o,n,m,l
$.kB=Object.create(null)
$.kP=Object.create(null)
A.t1()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.nK.$1(o)
if(n!=null){m=A.ta(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
t1(){var s,r,q,p,o,n,m=B.cT()
m=A.dE(B.cU,A.dE(B.cV,A.dE(B.b6,A.dE(B.b6,A.dE(B.cW,A.dE(B.cX,A.dE(B.cY(B.b5),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.nG=new A.kM(p)
$.nz=new A.kN(o)
$.nK=new A.kO(n)},
dE(a,b){return a(b)||b},
rL(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
te(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
cE:function cE(a,b){this.a=a
this.b=b},
cV:function cV(){},
bP:function bP(a,b,c){this.a=a
this.b=b
this.$ti=c},
f0:function f0(a,b){this.a=a
this.$ti=b},
f1:function f1(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
b3:function b3(a,b){this.a=a
this.$ti=b},
fR:function fR(){},
d7:function d7(a,b){this.a=a
this.$ti=b},
eF:function eF(){},
ju:function ju(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
en:function en(){},
ha:function ha(a,b,c){this.a=a
this.b=b
this.c=c},
hK:function hK(a){this.a=a},
j7:function j7(a){this.a=a},
dM:function dM(a,b){this.a=a
this.b=b},
f7:function f7(a){this.a=a
this.b=null},
at:function at(){},
fo:function fo(){},
fp:function fp(){},
hF:function hF(){},
hE:function hE(){},
cH:function cH(a,b){this.a=a
this.b=b},
hD:function hD(a){this.a=a},
b5:function b5(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
iY:function iY(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
ch:function ch(a,b){this.a=a
this.$ti=b},
Q:function Q(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
iZ:function iZ(a,b){this.a=a
this.$ti=b},
av:function av(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
ea:function ea(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
kM:function kM(a){this.a=a},
kN:function kN(a){this.a=a},
kO:function kO(a){this.a=a},
c2:function c2(){},
dA:function dA(){},
c(a){throw A.a6(A.iU(a),new Error())},
m0(a){throw A.a6(A.oS(a),new Error())},
tf(a){throw A.a6(new A.dc("Field '"+a+"' has been assigned during initialization."),new Error())},
n5(a){var s=new A.k0(a)
return s.b=s},
k0:function k0(a){this.a=a
this.b=null},
aM(a,b,c){},
q(a){var s,r,q
if(t.aP.b(a))return a
s=J.a5(a)
r=A.F(s.gv(a),null,!1,t.z)
for(q=0;q<s.gv(a);++q)B.c.h(r,q,s.l(a,q))
return r},
oY(a){return new Float32Array(a)},
oZ(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Float32Array(a,b,c)},
p_(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Int16Array(a,b,c)},
p0(a){return new Int32Array(a)},
p1(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Int32Array(a,b,c)},
mM(a){return new Int8Array(a)},
p2(a,b,c){A.aM(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
p3(a){return new Uint16Array(a)},
p4(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
p5(a){return new Uint32Array(a)},
p6(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
hf(a){return new Uint8Array(a)},
p7(a){return new Uint8Array(A.q(a))},
p8(a,b,c){A.aM(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bL(a,b,c){if(a>>>0!==a||a>=c)throw A.h(A.kA(b,a))},
ba(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.h(A.rM(a,b,c))
if(b==null)return c
return b},
cj:function cj(){},
ej:function ej(){},
i_:function i_(a){this.a=a},
he:function he(){},
aj:function aj(){},
bX:function bX(){},
aK:function aK(){},
ee:function ee(){},
ef:function ef(){},
eg:function eg(){},
eh:function eh(){},
ei:function ei(){},
ek:function ek(){},
el:function el(){},
em:function em(){},
ck:function ck(){},
f2:function f2(){},
f3:function f3(){},
f4:function f4(){},
f5:function f5(){},
lz(a,b){var s=b.c
return s==null?b.c=A.f9(a,"cc",[b.x]):s},
mX(a){var s=a.w
if(s===6||s===7)return A.mX(a.x)
return s===11||s===12},
pq(a){return a.as},
S(a){return A.km(v.typeUniverse,a,!1)},
t5(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.c4(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
c4(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.c4(a1,s,a3,a4)
if(r===s)return a2
return A.ne(a1,r,!0)
case 7:s=a2.x
r=A.c4(a1,s,a3,a4)
if(r===s)return a2
return A.nd(a1,r,!0)
case 8:q=a2.y
p=A.dD(a1,q,a3,a4)
if(p===q)return a2
return A.f9(a1,a2.x,p)
case 9:o=a2.x
n=A.c4(a1,o,a3,a4)
m=a2.y
l=A.dD(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.lK(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.dD(a1,j,a3,a4)
if(i===j)return a2
return A.nf(a1,k,i)
case 11:h=a2.x
g=A.c4(a1,h,a3,a4)
f=a2.y
e=A.rx(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.nc(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.dD(a1,d,a3,a4)
o=a2.x
n=A.c4(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.lL(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.h(A.fj("Attempted to substitute unexpected RTI kind "+a0))}},
dD(a,b,c,d){var s,r,q,p,o=b.length,n=A.kp(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.c4(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
ry(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.kp(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.c4(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
rx(a,b,c,d){var s,r=b.a,q=A.dD(a,r,c,d),p=b.b,o=A.dD(a,p,c,d),n=b.c,m=A.ry(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.hV()
s.a=q
s.b=o
s.c=m
return s},
j(a,b){a[v.arrayRti]=b
return a},
kx(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.t0(s)
return a.$S()}return null},
t4(a,b){var s
if(A.mX(b))if(a instanceof A.at){s=A.kx(a)
if(s!=null)return s}return A.ay(a)},
ay(a){if(a instanceof A.J)return A.l(a)
if(Array.isArray(a))return A.al(a)
return A.lO(J.cF(a))},
al(a){var s=a[v.arrayRti],r=t.gn
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
l(a){var s=a.$ti
return s!=null?s:A.lO(a)},
lO(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.r2(a,s)},
r2(a,b){var s=a instanceof A.at?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.qC(v.typeUniverse,s.name)
b.$ccache=r
return r},
t0(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.km(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
t_(a){return A.bM(A.l(a))},
lU(a){var s=A.kx(a)
return A.bM(s==null?A.ay(a):s)},
lR(a){var s
if(a instanceof A.c2)return A.rQ(a.$r,a.f3())
s=a instanceof A.at?A.kx(a):null
if(s!=null)return s
if(t.ci.b(a))return J.of(a).a
if(Array.isArray(a))return A.al(a)
return A.ay(a)},
bM(a){var s=a.r
return s==null?a.r=new A.hZ(a):s},
rQ(a,b){var s,r,q=b,p=q.length
if(p===0)return t.bQ
if(0>=p)return A.a(q,0)
s=A.fb(v.typeUniverse,A.lR(q[0]),"@<0>")
for(r=1;r<p;++r){if(!(r<q.length))return A.a(q,r)
s=A.nh(v.typeUniverse,s,A.lR(q[r]))}return A.fb(v.typeUniverse,s,a)},
bd(a){return A.bM(A.km(v.typeUniverse,a,!1))},
r1(a){var s=this
s.b=A.rv(s)
return s.b(a)},
rv(a){var s,r,q,p,o
if(a===t.K)return A.rb
if(A.cG(a))return A.rf
s=a.w
if(s===6)return A.qZ
if(s===1)return A.ns
if(s===7)return A.r6
r=A.ru(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.cG)){a.f="$i"+q
if(q==="r")return A.r9
if(a===t.m)return A.r8
return A.re}}else if(s===10){p=A.rL(a.x,a.y)
o=p==null?A.ns:p
return o==null?A.fd(o):o}return A.qX},
ru(a){if(a.w===8){if(a===t.p)return A.i2
if(a===t.V||a===t.q)return A.ra
if(a===t.N)return A.rd
if(a===t.y)return A.ku}return null},
r0(a){var s=this,r=A.qW
if(A.cG(s))r=A.qL
else if(s===t.K)r=A.fd
else if(A.dG(s)){r=A.qY
if(s===t.I)r=A.qJ
else if(s===t.dk)r=A.nn
else if(s===t.fQ)r=A.qH
else if(s===t.cg)r=A.nm
else if(s===t.cD)r=A.qI
else if(s===t.an)r=A.qK}else if(s===t.p)r=A.o
else if(s===t.N)r=A.bK
else if(s===t.y)r=A.nl
else if(s===t.q)r=A.lM
else if(s===t.V)r=A.i1
else if(s===t.m)r=A.bn
s.a=r
return s.a(a)},
qX(a){var s=this
if(a==null)return A.dG(s)
return A.nH(v.typeUniverse,A.t4(a,s),s)},
qZ(a){if(a==null)return!0
return this.x.b(a)},
re(a){var s,r=this
if(a==null)return A.dG(r)
s=r.f
if(a instanceof A.J)return!!a[s]
return!!J.cF(a)[s]},
r9(a){var s,r=this
if(a==null)return A.dG(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.J)return!!a[s]
return!!J.cF(a)[s]},
r8(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.J)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
nr(a){if(typeof a=="object"){if(a instanceof A.J)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
qW(a){var s=this
if(a==null){if(A.dG(s))return a}else if(s.b(a))return a
throw A.a6(A.no(a,s),new Error())},
qY(a){var s=this
if(a==null||s.b(a))return a
throw A.a6(A.no(a,s),new Error())},
no(a,b){return new A.dB("TypeError: "+A.n6(a,A.ax(b,null)))},
rH(a,b,c,d){if(A.nH(v.typeUniverse,a,b))return a
throw A.a6(A.qu("The type argument '"+A.ax(a,null)+"' is not a subtype of the type variable bound '"+A.ax(b,null)+"' of type variable '"+c+"' in '"+d+"'."),new Error())},
n6(a,b){return A.ir(a)+": type '"+A.ax(A.lR(a),null)+"' is not a subtype of type '"+b+"'"},
qu(a){return new A.dB("TypeError: "+a)},
b_(a,b){return new A.dB("TypeError: "+A.n6(a,b))},
r6(a){var s=this
return s.x.b(a)||A.lz(v.typeUniverse,s).b(a)},
rb(a){return a!=null},
fd(a){if(a!=null)return a
throw A.a6(A.b_(a,"Object"),new Error())},
rf(a){return!0},
qL(a){return a},
ns(a){return!1},
ku(a){return!0===a||!1===a},
nl(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a6(A.b_(a,"bool"),new Error())},
qH(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a6(A.b_(a,"bool?"),new Error())},
i1(a){if(typeof a=="number")return a
throw A.a6(A.b_(a,"double"),new Error())},
qI(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a6(A.b_(a,"double?"),new Error())},
i2(a){return typeof a=="number"&&Math.floor(a)===a},
o(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a6(A.b_(a,"int"),new Error())},
qJ(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a6(A.b_(a,"int?"),new Error())},
ra(a){return typeof a=="number"},
lM(a){if(typeof a=="number")return a
throw A.a6(A.b_(a,"num"),new Error())},
nm(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a6(A.b_(a,"num?"),new Error())},
rd(a){return typeof a=="string"},
bK(a){if(typeof a=="string")return a
throw A.a6(A.b_(a,"String"),new Error())},
nn(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a6(A.b_(a,"String?"),new Error())},
bn(a){if(A.nr(a))return a
throw A.a6(A.b_(a,"JSObject"),new Error())},
qK(a){if(a==null)return a
if(A.nr(a))return a
throw A.a6(A.b_(a,"JSObject?"),new Error())},
nw(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.ax(a[q],b)
return s},
rl(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.nw(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.ax(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
np(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
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
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.ax(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.ax(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.ax(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.ax(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.ax(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
ax(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.ax(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.ax(a.x,b)+">"
if(l===8){p=A.rz(a.x)
o=a.y
return o.length>0?p+("<"+A.nw(o,b)+">"):p}if(l===10)return A.rl(a,b)
if(l===11)return A.np(a,b,null)
if(l===12)return A.np(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
rz(a){var s=A.nM(a)
if(s!=null)return s
return"minified:"+a},
qD(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
qC(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.km(a,b,!1)
else if(typeof m=="number"){s=m
r=A.fa(a,5,"#")
q=A.kp(s)
for(p=0;p<s;++p)q[p]=r
o=A.f9(a,b,q)
n[b]=o
return o}else return m},
qB(a,b){return A.nj(a.tR,b)},
qA(a,b){return A.nj(a.eT,b)},
km(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.ng(a,null,b,!1)
r.set(b,s)
return s},
fb(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.ng(a,b,c,!0)
q.set(c,r)
return r},
nh(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.lK(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
ng(a,b,c,d){return A.qr(A.ql(a,b,c,d))},
c3(a,b){b.a=A.r0
b.b=A.r1
return b},
fa(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.b9(null,null)
s.w=b
s.as=c
r=A.c3(a,s)
a.eC.set(c,r)
return r},
ne(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.qy(a,b,r,c)
a.eC.set(r,s)
return s},
qy(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.cG(b))if(!(b===t.b||b===t.v))if(s!==6)r=s===7&&A.dG(b.x)
if(r)return b
else if(s===1)return t.b}q=new A.b9(null,null)
q.w=6
q.x=b
q.as=c
return A.c3(a,q)},
nd(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.qw(a,b,r,c)
a.eC.set(r,s)
return s},
qw(a,b,c,d){var s,r
if(d){s=b.w
if(A.cG(b)||b===t.K)return b
else if(s===1)return A.f9(a,"cc",[b])
else if(b===t.b||b===t.v)return t.eH}r=new A.b9(null,null)
r.w=7
r.x=b
r.as=c
return A.c3(a,r)},
qz(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.b9(null,null)
s.w=13
s.x=b
s.as=q
r=A.c3(a,s)
a.eC.set(q,r)
return r},
f8(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
qv(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
f9(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.f8(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.b9(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.c3(a,r)
a.eC.set(p,q)
return q},
lK(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.f8(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.b9(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.c3(a,o)
a.eC.set(q,n)
return n},
nf(a,b,c){var s,r,q="+"+(b+"("+A.f8(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.b9(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.c3(a,s)
a.eC.set(q,r)
return r},
nc(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.f8(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.f8(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.qv(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.b9(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.c3(a,p)
a.eC.set(r,o)
return o},
lL(a,b,c,d){var s,r=b.as+("<"+A.f8(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.qx(a,b,c,r,d)
a.eC.set(r,s)
return s},
qx(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.kp(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.c4(a,b,r,0)
m=A.dD(a,c,r,0)
return A.lL(a,n,m,c!==m)}}l=new A.b9(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.c3(a,l)},
ql(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
qr(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.qn(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.na(a,r,l,k,!1)
else if(q===46)r=A.na(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.cD(a.u,a.e,k.pop()))
break
case 94:k.push(A.qz(a.u,k.pop()))
break
case 35:k.push(A.fa(a.u,5,"#"))
break
case 64:k.push(A.fa(a.u,2,"@"))
break
case 126:k.push(A.fa(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.qp(a,k)
break
case 38:A.qo(a,k)
break
case 63:p=a.u
k.push(A.ne(p,A.cD(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.nd(p,A.cD(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.qm(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.nb(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.qs(a.u,a.e,o)
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
return A.cD(a.u,a.e,m)},
qn(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
na(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.qD(s,o.x)[p]
if(n==null)A.az('No "'+p+'" in "'+A.pq(o)+'"')
d.push(A.fb(s,o,n))}else d.push(p)
return m},
qp(a,b){var s,r=a.u,q=A.n9(a,b),p=b.pop()
if(typeof p=="string")b.push(A.f9(r,p,q))
else{s=A.cD(r,a.e,p)
switch(s.w){case 11:b.push(A.lL(r,s,q,a.n))
break
default:b.push(A.lK(r,s,q))
break}}},
qm(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.n9(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.cD(p,a.e,o)
q=new A.hV()
q.a=s
q.b=n
q.c=m
b.push(A.nc(p,r,q))
return
case-4:b.push(A.nf(p,b.pop(),s))
return
default:throw A.h(A.fj("Unexpected state under `()`: "+A.z(o)))}},
qo(a,b){var s=b.pop()
if(0===s){b.push(A.fa(a.u,1,"0&"))
return}if(1===s){b.push(A.fa(a.u,4,"1&"))
return}throw A.h(A.fj("Unexpected extended operation "+A.z(s)))},
n9(a,b){var s=b.splice(a.p)
A.nb(a.u,a.e,s)
a.p=b.pop()
return s},
cD(a,b,c){if(typeof c=="string")return A.f9(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.qq(a,b,c)}else return c},
nb(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.cD(a,b,c[s])},
qs(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.cD(a,b,c[s])},
qq(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.h(A.fj("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.h(A.fj("Bad index "+c+" for "+b.D(0)))},
nH(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.ab(a,b,null,c,null)
r.set(c,s)}return s},
ab(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.cG(d))return!0
s=b.w
if(s===4)return!0
if(A.cG(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.ab(a,c[b.x],c,d,e))return!0
q=d.w
p=t.b
if(b===p||b===t.v){if(q===7)return A.ab(a,b,c,d.x,e)
return d===p||d===t.v||q===6}if(d===t.K){if(s===7)return A.ab(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.ab(a,b.x,c,d,e))return!1
return A.ab(a,A.lz(a,b),c,d,e)}if(s===6)return A.ab(a,p,c,d,e)&&A.ab(a,b.x,c,d,e)
if(q===7){if(A.ab(a,b,c,d.x,e))return!0
return A.ab(a,b,c,A.lz(a,d),e)}if(q===6)return A.ab(a,b,c,p,e)||A.ab(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.Z)return!0
o=s===10
if(o&&d===t.gT)return!0
if(q===12){if(b===t.cj)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.ab(a,j,c,i,e)||!A.ab(a,i,e,j,c))return!1}return A.nq(a,b.x,c,d.x,e)}if(q===11){if(b===t.cj)return!0
if(p)return!1
return A.nq(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.r7(a,b,c,d,e)}if(o&&q===10)return A.rc(a,b,c,d,e)
return!1},
nq(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.ab(a3,a4.x,a5,a6.x,a7))return!1
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
if(!A.ab(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.ab(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.ab(a3,k[h],a7,g,a5))return!1}f=s.c
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
if(!A.ab(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
r7(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.fb(a,b,r[o])
return A.nk(a,p,null,c,d.y,e)}return A.nk(a,b.y,null,c,d.y,e)},
nk(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.ab(a,b[s],d,e[s],f))return!1
return!0},
rc(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.ab(a,r[s],c,q[s],e))return!1
return!0},
dG(a){var s=a.w,r=!0
if(!(a===t.b||a===t.v))if(!A.cG(a))if(s!==6)r=s===7&&A.dG(a.x)
return r},
cG(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
nj(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
kp(a){return a>0?new Array(a):v.typeUniverse.sEA},
b9:function b9(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
hV:function hV(){this.c=this.b=this.a=null},
hZ:function hZ(a){this.a=a},
hT:function hT(){},
dB:function dB(a){this.a=a},
qf(){var s,r,q
if(self.scheduleImmediate!=null)return A.rC()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.dF(new A.jX(s),1)).observe(r,{childList:true})
return new A.jW(s,r,q)}else if(self.setImmediate!=null)return A.rD()
return A.rE()},
qg(a){self.scheduleImmediate(A.dF(new A.jY(t.M.a(a)),0))},
qh(a){self.setImmediate(A.dF(new A.jZ(t.M.a(a)),0))},
qi(a){t.M.a(a)
A.qt(0,a)},
qt(a,b){var s=new A.ki()
s.ic(a,b)
return s},
rh(a){return new A.hQ(new A.ac($.a2,a.q("ac<0>")),a.q("hQ<0>"))},
qO(a,b){a.$2(0,null)
b.b=!0
return b.a},
uG(a,b){A.qP(a,b)},
qN(a,b){b.e6(a)},
qM(a,b){b.e7(A.c7(a),A.bN(a))},
qP(a,b){var s,r,q=new A.ks(b),p=new A.kt(b)
if(a instanceof A.ac)a.fF(q,p,t.z)
else{s=t.z
if(a instanceof A.ac)a.hq(q,p,s)
else{r=new A.ac($.a2,t._)
r.a=8
r.c=a
r.fF(q,p,s)}}},
rB(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.a2.ho(new A.kw(s),t.x,t.p,t.z)},
l6(a){var s
if(t.C.b(a)){s=a.gcD()
if(s!=null)return s}return B.ac},
r3(a,b){if($.a2===B.D)return null
return null},
r4(a,b){if($.a2!==B.D)A.r3(a,b)
if(b==null)if(t.C.b(a)){b=a.gcD()
if(b==null){A.mU(a,B.ac)
b=B.ac}}else b=B.ac
else if(t.C.b(a))A.mU(a,b)
return new A.aQ(a,b)},
lF(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t._;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.pr()
b.dC(new A.aQ(new A.b1(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.fp(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.dj()
b.d6(o.a)
A.dx(b,p)
return}b.a^=2
A.i3(null,null,b.b,t.M.a(new A.k6(o,b)))},
dx(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.u,r=t.F;;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.lQ(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.dx(d.a,c)
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
A.lQ(j.a,j.b)
return}g=$.a2
if(g!==h)$.a2=h
else g=null
c=c.c
if((c&15)===8)new A.ka(q,d,n).$0()
else if(o){if((c&1)!==0)new A.k9(q,j).$0()}else if((c&2)!==0)new A.k8(d,q).$0()
if(g!=null)$.a2=g
c=q.c
if(c instanceof A.ac){p=q.a.$ti
p=p.q("cc<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.dk(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.lF(c,f,!0)
return}}f=q.a.b
e=r.a(f.c)
f.c=null
b=f.dk(e)
c=q.b
p=q.c
if(!c){f.$ti.c.a(p)
f.a=8
f.c=p}else{s.a(p)
f.a=f.a&1|16
f.c=p}d.a=f
c=f}},
rm(a,b){var s
if(t.Q.b(a))return b.ho(a,t.z,t.K,t.l)
s=t.E
if(s.b(a))return s.a(a)
throw A.h(A.l5(a,"onError",u.c))},
rj(){var s,r
for(s=$.dC;s!=null;s=$.dC){$.ff=null
r=s.b
$.dC=r
if(r==null)$.fe=null
s.a.$0()}},
rw(){$.lP=!0
try{A.rj()}finally{$.ff=null
$.lP=!1
if($.dC!=null)$.m4().$1(A.nA())}},
nx(a){var s=new A.hR(a),r=$.fe
if(r==null){$.dC=$.fe=s
if(!$.lP)$.m4().$1(A.nA())}else $.fe=r.b=s},
rt(a){var s,r,q,p=$.dC
if(p==null){A.nx(a)
$.ff=$.fe
return}s=new A.hR(a)
r=$.ff
if(r==null){s.b=p
$.dC=$.ff=s}else{q=r.b
s.b=q
$.ff=r.b=s
if(q==null)$.fe=s}},
u6(a,b){A.fg(a,"stream",t.K)
return new A.hX(b.q("hX<0>"))},
lQ(a,b){A.rt(new A.kv(a,b))},
nv(a,b,c,d,e){var s,r=$.a2
if(r===c)return d.$0()
$.a2=c
s=r
try{r=d.$0()
return r}finally{$.a2=s}},
rp(a,b,c,d,e,f,g){var s,r=$.a2
if(r===c)return d.$1(e)
$.a2=c
s=r
try{r=d.$1(e)
return r}finally{$.a2=s}},
ro(a,b,c,d,e,f,g,h,i){var s,r=$.a2
if(r===c)return d.$2(e,f)
$.a2=c
s=r
try{r=d.$2(e,f)
return r}finally{$.a2=s}},
i3(a,b,c,d){t.M.a(d)
if(B.D!==c){d=c.kO(d)
d=d}A.nx(d)},
jX:function jX(a){this.a=a},
jW:function jW(a,b,c){this.a=a
this.b=b
this.c=c},
jY:function jY(a){this.a=a},
jZ:function jZ(a){this.a=a},
ki:function ki(){},
kj:function kj(a,b){this.a=a
this.b=b},
hQ:function hQ(a,b){this.a=a
this.b=!1
this.$ti=b},
ks:function ks(a){this.a=a},
kt:function kt(a){this.a=a},
kw:function kw(a){this.a=a},
aQ:function aQ(a,b){this.a=a
this.b=b},
hS:function hS(){},
eX:function eX(a,b){this.a=a
this.$ti=b},
cC:function cC(a,b,c,d,e){var _=this
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
k3:function k3(a,b){this.a=a
this.b=b},
k7:function k7(a,b){this.a=a
this.b=b},
k6:function k6(a,b){this.a=a
this.b=b},
k5:function k5(a,b){this.a=a
this.b=b},
k4:function k4(a,b){this.a=a
this.b=b},
ka:function ka(a,b,c){this.a=a
this.b=b
this.c=c},
kb:function kb(a,b){this.a=a
this.b=b},
kc:function kc(a){this.a=a},
k9:function k9(a,b){this.a=a
this.b=b},
k8:function k8(a,b){this.a=a
this.b=b},
hR:function hR(a){this.a=a
this.b=null},
hX:function hX(a){this.$ti=a},
fc:function fc(){},
hW:function hW(){},
kg:function kg(a,b){this.a=a
this.b=b},
kv:function kv(a,b){this.a=a
this.b=b},
n7(a,b){var s=a[b]
return s===a?null:s},
lH(a,b,c){if(c==null)a[b]=a
else a[b]=c},
lG(){var s=Object.create(null)
A.lH(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
oT(a,b){return new A.b5(a.q("@<0>").an(b).q("b5<1,2>"))},
lf(a,b,c){return b.q("@<0>").an(c).q("iX<1,2>").a(A.nF(a,new A.b5(b.q("@<0>").an(c).q("b5<1,2>"))))},
I(a,b){return new A.b5(a.q("@<0>").an(b).q("b5<1,2>"))},
eb(a,b,c){var s=A.oT(b,c)
a.bL(0,new A.j_(s,b,c))
return s},
lg(a){var s,r
if(A.lW(a))return"{...}"
s=new A.eH("")
try{r={}
B.c.C($.aN,a)
s.a+="{"
r.a=!0
a.bL(0,new A.j3(r,s))
s.a+="}"}finally{if(0>=$.aN.length)return A.a($.aN,-1)
$.aN.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
eY:function eY(){},
dy:function dy(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
eZ:function eZ(a,b){this.a=a
this.$ti=b},
f_:function f_(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
j_:function j_(a,b,c){this.a=a
this.b=b
this.c=c},
H:function H(){},
ai:function ai(){},
j3:function j3(a,b){this.a=a
this.b=b},
qF(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.o6()
else s=new Uint8Array(o)
for(r=0;r<o;++r){q=b+r
if(!(q<a.length))return A.a(a,q)
p=a[q]
if((p&255)!==p)p=255
s[r]=p}return s},
qE(a,b,c,d){var s=a?$.o5():$.o4()
if(s==null)return null
if(0===c&&d===b.length)return A.ni(s,b)
return A.ni(s,b.subarray(c,d))},
ni(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
qG(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
ko:function ko(){},
kn:function kn(){},
kl:function kl(){},
kk:function kk(){},
cI:function cI(){},
fu:function fu(){},
fx:function fx(){},
hb:function hb(){},
iW:function iW(){},
iV:function iV(a){this.a=a},
hL:function hL(){},
hM:function hM(a){this.a=a},
i0:function i0(a){this.a=a
this.b=16
this.c=0},
t6(a){var s=A.pi(a,null)
if(s!=null)return s
throw A.h(A.la(a,null,null))},
ou(a,b){a=A.a6(a,new Error())
if(a==null)a=A.fd(a)
a.stack=b.D(0)
throw a},
F(a,b,c,d){var s,r=c?J.h5(a,d):J.mG(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
dd(a,b,c){var s,r,q=A.j([],c.q("t<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.U)(a),++r)B.c.C(q,c.a(a[r]))
if(b)return q
q.$flags=1
return q},
w(a,b){var s,r
if(Array.isArray(a))return A.j(a.slice(0),b.q("t<0>"))
s=A.j([],b.q("t<0>"))
for(r=J.fh(a);r.E();)B.c.C(s,r.gP())
return s},
mK(a,b,c){var s,r=J.h5(a,c)
for(s=0;s<a;++s)B.c.h(r,s,b.$1(s))
return r},
eI(a,b,c){var s,r,q,p,o
A.dn(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.h(A.ap(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.mT(b>0||c<o?p.slice(b,c):p)}if(t.bm.b(a))return A.ps(a,b,c)
if(r)a=J.oh(a,c)
if(b>0)a=J.l3(a,b)
s=A.w(a,t.p)
return A.mT(s)},
ps(a,b,c){var s=a.length
if(b>=s)return""
return A.pk(a,b,c==null||c>s?s:c)},
mY(a,b,c){var s=J.fh(b)
if(!s.E())return a
if(c.length===0){do a+=A.z(s.gP())
while(s.E())}else{a+=A.z(s.gP())
while(s.E())a=a+c+A.z(s.gP())}return a},
pr(){return A.bN(new Error())},
os(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
mj(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
fw(a){if(a>=10)return""+a
return"0"+a},
ir(a){if(typeof a=="number"||A.ku(a)||a==null)return J.dH(a)
if(typeof a=="string")return JSON.stringify(a)
return A.mS(a)},
ov(a,b){A.fg(a,"error",t.K)
A.fg(b,"stackTrace",t.l)
A.ou(a,b)},
fj(a){return new A.fi(a)},
br(a,b){return new A.b1(!1,null,b,a)},
l5(a,b,c){return new A.b1(!0,a,b,c)},
pp(a){var s=null
return new A.dm(s,s,!1,s,s,a)},
ly(a,b){return new A.dm(null,null,!0,a,b,"Value not in range")},
ap(a,b,c,d,e){return new A.dm(b,c,!0,a,d,"Invalid value")},
bC(a,b,c){if(0>a||a>c)throw A.h(A.ap(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.h(A.ap(b,a,c,"end",null))
return b}return c},
dn(a,b){if(a<0)throw A.h(A.ap(a,0,null,b,null))
return a},
lc(a,b,c,d,e){return new A.fO(b,!0,a,e,"Index out of range")},
aq(a){return new A.eL(a)},
n0(a){return new A.hJ(a)},
lA(a){return new A.dp(a)},
be(a){return new A.fs(a)},
ml(a){return new A.k2(a)},
la(a,b,c){return new A.ix(a,b,c)},
oP(a,b,c){var s,r
if(A.lW(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.j([],t.s)
B.c.C($.aN,a)
try{A.rg(a,s)}finally{if(0>=$.aN.length)return A.a($.aN,-1)
$.aN.pop()}r=A.mY(b,t.Y.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
mF(a,b,c){var s,r
if(A.lW(a))return b+"..."+c
s=new A.eH(b)
B.c.C($.aN,a)
try{r=s
r.a=A.mY(r.a,a,", ")}finally{if(0>=$.aN.length)return A.a($.aN,-1)
$.aN.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
rg(a,b){var s,r,q,p,o,n,m,l=a.gH(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.E())return
s=A.z(l.gP())
B.c.C(b,s)
k+=s.length+2;++j}if(!l.E()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gP();++j
if(!l.E()){if(j<=4){B.c.C(b,A.z(p))
return}r=A.z(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gP();++j
for(;l.E();p=o,o=n){n=l.gP();++j
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
j8(a,b,c,d){var s
if(B.C===c){s=J.aP(a)
b=J.aP(b)
return A.jn(A.bD(A.bD($.id(),s),b))}if(B.C===d){s=J.aP(a)
b=J.aP(b)
c=J.aP(c)
return A.jn(A.bD(A.bD(A.bD($.id(),s),b),c))}s=J.aP(a)
b=J.aP(b)
c=J.aP(c)
d=J.aP(d)
d=A.jn(A.bD(A.bD(A.bD(A.bD($.id(),s),b),c),d))
return d},
n(a){var s,r,q=$.id()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.U)(a),++r)q=A.bD(q,J.aP(a[r]))
return A.jn(q)},
fv:function fv(a,b,c){this.a=a
this.b=b
this.c=c},
k1:function k1(){},
V:function V(){},
fi:function fi(a){this.a=a},
bl:function bl(){},
b1:function b1(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dm:function dm(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fO:function fO(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
eL:function eL(a){this.a=a},
hJ:function hJ(a){this.a=a},
dp:function dp(a){this.a=a},
fs:function fs(a){this.a=a},
hh:function hh(){},
eG:function eG(){},
k2:function k2(a){this.a=a},
ix:function ix(a,b,c){this.a=a
this.b=b
this.c=c},
e:function e(){},
ak:function ak(){},
J:function J(){},
hY:function hY(){},
eH:function eH(a){this.a=a},
j6:function j6(a){this.a=a},
qQ(a,b,c){t.Z.a(a)
if(A.o(c)>=1)return a.$1(b)
return a.$0()},
nu(a){return a==null||A.ku(a)||typeof a=="number"||typeof a=="string"||t.cu.b(a)||t.D.b(a)||t.go.b(a)||t.dQ.b(a)||t.h7.b(a)||t.k.b(a)||t.bv.b(a)||t.h4.b(a)||t.eT.b(a)||t.dI.b(a)||t.fd.b(a)},
lX(a){if(A.nu(a))return a
return new A.kQ(new A.dy(t.hg)).$1(a)},
tc(a,b){var s=new A.ac($.a2,b.q("ac<0>")),r=new A.eX(s,b.q("eX<0>"))
a.then(A.dF(new A.kS(r,b),1),A.dF(new A.kT(r),1))
return s},
nt(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
nC(a){if(A.nt(a))return a
return new A.kz(new A.dy(t.hg)).$1(a)},
kQ:function kQ(a){this.a=a},
kS:function kS(a,b){this.a=a
this.b=b},
kT:function kT(a){this.a=a},
kz:function kz(a){this.a=a},
fG(a){var s=new A.iB()
s.hX(a)
return s},
iB:function iB(){this.a=$
this.b=0
this.c=2147483647},
jU:function jU(){},
kq:function kq(){},
jV:function jV(){},
kr:function kr(){},
ot(a,b,c,d){var s=A.lI(),r=A.lI(),q=A.lI(),p=new Uint16Array(16),o=new Uint32Array(573),n=new Uint8Array(573)
s=new A.io(a,c,s,r,q,p,o,n)
s.jz(b,d)
s.j2(B.a9)
return s},
mk(a,b,c,d){var s,r=b*2,q=a.length
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
lI(){return new A.kd()},
qj(a,b,c){var s,r,q,p,o,n,m,l=new Uint16Array(16)
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
n=A.qk(n,m)
a.$flags&2&&A.b(a)
if(!(o<q))return A.a(a,o)
a[o]=n}},
qk(a,b){var s,r=0
do{s=A.aG(a,1)
r=(r|a&1)<<1>>>0
if(--b,b>0){a=s
continue}else break}while(!0)
return A.aG(r,1)},
n8(a){var s
if(a<256){if(!(a>=0))return A.a(B.ah,a)
s=B.ah[a]}else{s=256+A.aG(a,7)
if(!(s<512))return A.a(B.ah,s)
s=B.ah[s]}return s},
lJ(a,b,c,d,e){return new A.kh(a,b,c,d,e)},
aG(a,b){if(a>=0)return B.a.aW(a,b)
else return B.a.aW(a,b)+B.a.S(2,(~b>>>0)+65536&65535)},
dw:function dw(a,b){this.a=a
this.b=b},
io:function io(a,b,c,d,e,f,g,h){var _=this
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
_.bf=_.aX=_.bT=_.ck=_.bK=_.aR=_.bJ=_.y2=_.y1=_.xr=$},
aZ:function aZ(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
kd:function kd(){this.c=this.b=this.a=$},
kh:function kh(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
iK:function iK(a,b){var _=this
_.a=a
_.b=null
_.c=b
_.e=_.d=0},
jT:function jT(){},
fn:function fn(a,b){this.a=a
this.b=b},
iL(a,b,c,d){var s,r,q=new A.fP(b)
if(d==null)d=0
if(c==null)c=a.length-d
s=a.length
if(d+c>s)c=s-d
r=t.D.b(a)?a:new Uint8Array(A.q(a))
s=J.D(B.d.gB(r),r.byteOffset+d,c)
q.b=s
q.d=s.length
return q},
fP:function fP(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
fQ:function fQ(){},
mN(a,b){var s=b==null?32768:b
return new A.eo(new Uint8Array(s),a)},
eo:function eo(a,b){this.b=0
this.c=a
this.a=b},
hj:function hj(){},
mb(a,b,c){var s,r,q,p,o,n,m
if(b<1||b>9||c<1||c>9)throw A.h(new A.ig("BlurHash components must be between 1 and 9."))
s=a.aQ(B.e)
r=J.cg(c,t.dL)
for(q=t.O,p=0;p<c;++p)r[p]=A.F(b,new A.bt(0,0,0),!1,q)
for(o=0;o<c;++o)for(q=o===0,n=0;n<b;++n){m=n===0&&q?1:2
if(!(o<r.length))return A.a(r,o)
B.c.h(r[o],n,A.rk(s,n,o,m))}q=A.qU(r)
if(0>=r.length)return A.a(r,0)
return new A.ie(q)},
qU(a){var s,r,q,p,o,n,m,l=a.length
if(0>=l)return A.a(a,0)
s=a[0].length
r=A.F(s*l,new A.bt(0,0,0),!1,t.O)
for(q=0,p=0;p<l;++p)for(o=0;o<s;++o,q=n){n=q+1
if(!(p<a.length))return A.a(a,p)
m=a[p]
if(!(o<m.length))return A.a(m,o)
B.c.h(r,q,m[o])}return A.qV(r,s,l)},
qV(a,b,c){var s,r,q,p,o,n,m,l,k=B.c.gl7(a),j=A.dq(a,1,null,A.al(a).c).lC(0),i=A.i6(b-1+(c-1)*9,1)
if(j.length!==0){s=A.al(j)
r=Math.max(0,Math.min(82,B.b.bo(new A.b6(j,s.q("A(1)").a(A.rG()),s.q("b6<1,A>")).lw(0,B.cR)*166-0.5)))
q=(r+1)/166
i+=A.i6(r,1)}else{i+=A.i6(0,1)
q=1}i+=A.i6((A.lY(k.a)<<16>>>0)+(A.lY(k.b)<<8>>>0)+A.lY(k.c),4)
for(s=j.length,p=0;p<j.length;j.length===s||(0,A.U)(j),++p,i=l){o=j[p]
n=o.a/q
m=o.b/q
l=o.c/q
l=i+A.i6(B.b.bo(Math.max(0,Math.min(18,Math.pow(Math.abs(n),0.5)*J.l2(n)*9+9.5)))*19*19+B.b.bo(Math.max(0,Math.min(18,Math.pow(Math.abs(m),0.5)*J.l2(m)*9+9.5)))*19+B.b.bo(Math.max(0,Math.min(18,Math.pow(Math.abs(l),0.5)*J.l2(l)*9+9.5))),2)}return i.charCodeAt(0)==0?i:i},
ri(a){t.O.a(a)
return Math.max(Math.abs(a.a),Math.max(Math.abs(a.b),Math.abs(a.c)))},
rk(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=null,i=0,h=0,g=0
if(a.gaE()>=3)for(s=a.a,s=s.gH(s),r=3.141592653589793*c,q=3.141592653589793*b;s.E();){p=s.gP()
o=p.gaZ()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gaU()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
l=d*n*Math.cos(r*o/m)
i+=l*A.kU(A.o(p.gn()))
h+=l*A.kU(A.o(p.gt()))
g+=l*A.kU(A.o(p.gu()))}else for(s=a.a,s=s.gH(s),r=3.141592653589793*c,q=3.141592653589793*b;s.E();){p=s.gP()
o=p.gaZ()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gaU()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
m=d*n*Math.cos(r*o/m)*A.kU(A.o(p.gn()))
i+=m
h+=m
g+=m}k=1/(a.gR()*a.gK())
return new A.bt(i*k,h*k,g*k)},
ie:function ie(a){this.a=a},
ig:function ig(a){this.a=a},
kU(a){var s=a/255
if(s<=0.04045)return s/12.92
return Math.pow((s+0.055)/1.055,2.4)},
lY(a){var s=B.b.L(a,0,1)
if(s<=0.0031308)return B.b.i(s*12.92*255+0.5)
return B.b.i((1.055*Math.pow(s,0.4166666666666667)-0.055)*255+0.5)},
bt:function bt(a,b,c){this.a=a
this.b=b
this.c=c},
il:function il(a,b){this.a=a
this.b=b},
R:function R(a){this.a=-1
this.b=a},
cJ:function cJ(a){this.a=a},
cK:function cK(a){this.a=a},
cL:function cL(a){this.a=a},
cM:function cM(a){this.a=a},
cN:function cN(a){this.a=a},
cO:function cO(a){this.a=a},
cQ:function cQ(a,b){this.a=a
this.b=b},
cR:function cR(a){this.a=a},
cS:function cS(a,b){this.a=a
this.b=b},
cT:function cT(a){this.a=a},
cU:function cU(a,b){this.a=a
this.b=b},
or(a,b,c,d){var s=new A.cP(new Uint8Array(4))
s.hS(a,b,c,d)
return s},
bO:function bO(a){this.a=a},
fq:function fq(a){this.a=a},
cP:function cP(a){this.a=a},
dJ:function dJ(a){this.a=a},
ft:function ft(a){this.a=a},
i4(a,b,c){var s
if(b===c)return a
switch(b.a){case 0:if(a===0)s=0
else{s=B.ck.l(0,c)
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
case 1:return B.a.j(A.o(a),1)
case 2:return a
case 3:return a*17
case 4:return a*4369
case 5:return a*286331153
case 6:return a*8
case 7:return a*2184
case 8:return a*143165576
case 9:case 10:case 11:return a/3}break
case 3:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.o(a),6)
case 2:return B.a.j(A.o(a),4)
case 3:return a
case 4:return a*257
case 5:return a*16843009
case 6:return B.a.j(A.o(a),1)
case 7:return a*128
case 8:return a*8421504
case 9:case 10:case 11:return a/255}break
case 4:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.o(a),14)
case 2:return B.a.j(A.o(a),12)
case 3:return B.a.j(A.o(a),8)
case 4:return a
case 5:return A.o(a)<<8>>>0
case 6:return B.a.j(A.o(a),9)
case 7:return B.a.j(A.o(a),1)
case 8:return a*524296
case 9:case 10:case 11:return a/65535}break
case 5:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.o(a),30)
case 2:return B.a.j(A.o(a),28)
case 3:return B.a.j(A.o(a),24)
case 4:return B.a.j(A.o(a),16)
case 5:return a
case 6:return B.a.j(A.o(a),25)
case 7:return B.a.j(A.o(a),17)
case 8:return B.a.j(A.o(a),1)
case 9:case 10:case 11:return a/4294967295}break
case 6:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.o(a),5)
case 2:return a<=0?0:B.a.j(A.o(a),3)
case 3:return a<=0?0:A.o(a)<<1>>>0
case 4:return a<=0?0:A.o(a)*516
case 5:return a<=0?0:A.o(a)*33818640
case 6:return a
case 7:return a*258
case 8:return a*16909320
case 9:case 10:case 11:return a/127}break
case 7:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.o(a),15)
case 2:return a<=0?0:B.a.j(A.o(a),11)
case 3:return a<=0?0:B.a.j(A.o(a),7)
case 4:return a<=0?0:A.o(a)<<1>>>0
case 5:return a<=0?0:A.o(a)*131076
case 6:return B.a.j(A.o(a),8)
case 7:return a
case 8:return A.o(a)*65538
case 9:case 10:case 11:return a/32767}break
case 8:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.o(a),29)
case 2:return a<=0?0:B.a.j(A.o(a),27)
case 3:return a<=0?0:B.a.j(A.o(a),23)
case 4:return a<=0?0:B.a.j(A.o(a),16)
case 5:return a<=0?0:A.o(a)<<1>>>0
case 6:return B.a.j(A.o(a),24)
case 7:return B.a.j(A.o(a),16)
case 8:return a
case 9:case 10:case 11:return a/2147483647}break
case 9:case 10:case 11:switch(c.a){case 0:return a===0?0:1
case 1:return B.b.i(B.b.L(a,0,1)*3)
case 2:return B.b.i(B.b.L(a,0,1)*15)
case 3:return B.b.i(B.b.L(a,0,1)*255)
case 4:return B.b.i(B.b.L(a,0,1)*65535)
case 5:return B.b.i(B.b.L(a,0,1)*4294967295)
case 6:return B.b.i(a<0?B.b.L(a,-1,1)*128:B.b.L(a,-1,1)*127)
case 7:return B.b.i(a<0?B.b.L(a,-1,1)*32768:B.b.L(a,-1,1)*32767)
case 8:return B.b.i(a<0?B.b.L(a,-1,1)*2147483648:B.b.L(a,-1,1)*2147483647)
case 9:case 10:case 11:return a}break}},
au:function au(a,b){this.a=a
this.b=b},
dR:function dR(a,b){this.a=a
this.b=b},
fk:function fk(a,b){this.a=a
this.b=b},
dN(a){var s,r=new A.bQ(A.I(t.N,t.P))
r.hY(a)
s=a.b
if(s!=null)r.b=new Uint8Array(A.q(s))
return r},
l7(a){var s=new A.bQ(A.I(t.N,t.P))
s.cm(a)
return s},
bQ:function bQ(a){this.b=null
this.a=a},
hU:function hU(a,b){this.a=a
this.b=b},
i(a,b,c){return new A.fy(a,b)},
fy:function fy(a,b){this.a=a
this.b=b},
aR:function aR(a){this.a=a},
iD:function iD(a){this.a=a},
ms(a){var s=new A.aI(A.I(t.p,t.r),new A.aR(A.I(t.N,t.P)))
s.h9(a)
return s},
aI:function aI(a,b){this.a=a
this.b=b},
iE:function iE(a){this.a=a},
iF:function iF(a){this.a=a},
oK(a){var s=new Uint16Array(1)
s[0]=a
return new A.by(s)},
mz(a,b){var s=new A.by(new Uint16Array(b))
s.i2(a,b)
return s},
iG(a){var s=new Uint32Array(1)
s[0]=a
return new A.aS(s)},
mu(a,b){var s=new A.aS(new Uint32Array(b))
s.i_(a,b)
return s},
mv(a,b){var s,r=J.cg(b,t.i)
for(s=0;s<b;++s)r[s]=new A.aW(a.k(),a.k())
return new A.bg(r)},
my(a,b){var s=new A.bx(new Int16Array(b))
s.i1(a,b)
return s},
mw(a,b){var s=new A.bw(new Int32Array(b))
s.i0(a,b)
return s},
mx(a,b){var s,r,q,p,o=J.cg(b,t.i)
for(s=0;s<b;++s){r=a.k()
q=$.O()
q.$flags&2&&A.b(q)
q[0]=r
r=$.a9()
if(0>=r.length)return A.a(r,0)
p=r[0]
q[0]=a.k()
o[s]=new A.aW(p,r[0])}return new A.bi(o)},
mA(a,b){var s=new A.bT(new Float32Array(b))
s.i3(a,b)
return s},
mt(a,b){var s=new A.bS(new Float64Array(b))
s.hZ(a,b)
return s},
ae:function ae(a,b){this.a=a
this.b=b},
a3:function a3(){},
b4:function b4(a){this.a=a},
ce:function ce(a){this.a=a},
by:function by(a){this.a=a},
aS:function aS(a){this.a=a},
bg:function bg(a){this.a=a},
bh:function bh(a){this.a=a},
bx:function bx(a){this.a=a},
bw:function bw(a){this.a=a},
bi:function bi(a){this.a=a},
bT:function bT(a){this.a=a},
bS:function bS(a){this.a=a},
bU:function bU(a){this.a=a},
cf:function cf(a){this.a=a},
nE(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(a4===B.bb)return a5.eh(a3)
if(B.cj.a8(a4))return A.rN(a3,a5,a4,a7)
s=B.l3.l(0,a4)
s.toString
r=a3.gK()
q=a3.gR()
p=a5.gN()
o=A.P(null,null,B.e,0,B.j,r,null,0,1,p,B.e,q,!1)
n=new A.kC(A.bz(a3,!1,!1),a5,o,p,s,q,r)
if(a6===B.dc){m=q+r-1
for(l=q-1,k=0;k<m;++k){j=k<r?0:k-r+1
i=k<q?k:l
if((k&1)===0)for(h=j;h<=i;++h)n.$3(h,k-h,1)
else for(h=i;h>=j;--h)n.$3(h,k-h,1)}return o}if(a6===B.dd){g=Math.max(q,r)
for(f=1;f<g;)f=f<<1>>>0
e=A.j([0,0],t.t)
d=f*f
for(k=0;k<d;++k){A.r_(f,k,e)
s=e[0]
if(s<q&&e[1]<r)n.$3(s,e[1],1)}return o}c=a6===B.db
b=c?-1:1
for(a=q-1,a0=0;a0<r;++a0){if(c)b*=-1
s=b===1
a1=s?0:a
a2=s?q:0
for(h=a1;h!==a2;h+=b)n.$3(h,a0,b)}return o},
rN(a,b,c,d){var s,r,q,p,o,n,m,l,k=null,j=B.cj.l(0,c),i=j.length,h=a.gK(),g=a.gR(),f=A.P(k,k,B.e,0,B.j,h,k,0,1,b.gN(),B.e,g,!1)
for(s=0;s<h;++s){r=j[B.a.a9(s,i)]
for(q=r.length,p=0;p<g;++p){o=a.a
n=o==null?k:o.O(p,s,k)
if(n==null)n=new A.C()
o=B.a.a9(p,i)
if(!(o<q))return A.a(r,o)
m=(r[o]-0.5)*255*d
l=b.eg(B.b.aS(B.b.L(n.l(0,0)+m,0,255)),B.b.aS(B.b.L(n.l(0,1)+m,0,255)),B.b.aS(B.b.L(n.l(0,2)+m,0,255)))
o=f.a
if(o!=null)o.aJ(p,s,l)}}return f},
r_(a,b,c){var s,r,q,p,o,n
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
aD:function aD(a,b){this.a=a
this.b=b},
cW:function cW(a,b){this.a=a
this.b=b},
kC:function kC(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
mc(a){var s,r,q=new A.ij()
if(!A.md(a))A.az(A.m("Not a bitmap file."))
a.d+=2
s=a.k()
r=$.O()
r.$flags&2&&A.b(r)
r[0]=s
s=$.a9()
if(0>=s.length)return A.a(s,0)
a.d+=4
r[0]=a.k()
q.b=s[0]
return q},
md(a){if(a.c-a.d<2)return!1
return A.p(a,null,0).p()===19778},
oj(a,b){var s,r,q,p,o=b==null?A.mc(a):b,n=a.d,m=a.k(),l=a.k(),k=$.O()
k.$flags&2&&A.b(k)
k[0]=l
l=$.a9()
if(0>=l.length)return A.a(l,0)
s=l[0]
k[0]=a.k()
l=l[0]
r=a.p()
q=a.p()
p=a.k()
if(p>=14)A.az(A.m("Unsupported BMP compression type: "+p))
if(!(p<14))return A.a(B.av,p)
p=B.av[p]
a.k()
k[0]=a.k()
k[0]=a.k()
k=a.k()
a.k()
n=new A.bs(o,s,l,m,r,q,p,k,n)
n.ev(a,b)
return n},
ad:function ad(a,b){this.a=a
this.b=b},
ij:function ij(){this.b=$},
bs:function bs(a,b,c,d,e,f,g,h,i){var _=this
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
fl:function fl(a){this.a=$
this.b=null
this.c=a},
ih:function ih(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ip:function ip(a){this.a=$
this.b=null
this.c=a},
ii:function ii(){},
L:function L(){},
im:function im(){},
iq:function iq(){},
fz:function fz(){},
e3:function e3(a,b,c,d){var _=this
_.r=a
_.w=b
_.x=c
_.b=_.a=0
_.c=d},
cX:function cX(a,b){this.a=a
this.b=b},
cb:function cb(a,b){this.a=a
this.b=b},
fA:function fA(){var _=this
_.w=_.r=_.f=_.d=_.c=_.b=_.a=$},
mm(a,b,c,d){var s,r
switch(a.a){case 1:return new A.fY(c,b)
case 2:return new A.e4(c,d==null?1:d,b)
case 3:return new A.e4(c,d==null?16:d,b)
case 4:s=d==null?32:d
r=new A.fW(c,s,b)
r.i6(b,c,s)
return r
case 5:return new A.fX(c,d==null?16:d,b)
case 6:return new A.e3(c,d==null?32:d,!1,b)
case 7:return new A.e3(c,d==null?32:d,!0,b)
default:throw A.h(A.m("Invalid compression type: "+a.D(0)))}},
b2:function b2(a,b){this.a=a
this.b=b},
bu:function bu(){},
fU:function fU(){},
oz(a,b,c,d){var s,r,q,p,o,n,m,l
if(b===0){if(d!==0)throw A.h(A.m("Incomplete huffman data"))
return}s=a.d
r=a.k()
q=a.k()
a.d+=4
p=a.k()
o=!0
if(r<65537)o=q>=65537
if(o)throw A.h(A.m("Invalid huffman table size"))
a.d+=4
n=A.F(65537,0,!1,t.p)
m=J.ao(16384,t.gV)
for(l=0;l<16384;++l)m[l]=new A.fB()
A.oA(a,b-20,r,q,n)
if(p>8*(b-(a.d-s)))throw A.h(A.m("Error in header for Huffman-encoded data (invalid number of bits)."))
A.ow(n,r,q,m)
A.oy(n,m,a,p,q,d,c)},
oy(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k,j="Error in Huffman-encoded data (invalid code).",i=A.j([0,0],t.t),h=c.d+B.a.W(d+7,8)
for(s=b.length,r=0;c.d<h;){A.l8(i,c)
while(q=i[1],q>=14){p=B.a.aW(i[0],q-14)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.h(i,1,q-p)
r=A.l9(o.b,e,i,c,g,r,f)}else{if(o.c==null)throw A.h(A.m(j))
for(n=0;n<o.b;++n){q=o.c
if(!(n<q.length))return A.a(q,n)
q=q[n]
if(!(q<65537))return A.a(a,q)
m=a[q]&63
for(;;){q=i[1]
if(!(q<m&&c.d<h))break
A.l8(i,c)}if(q>=m){p=o.c
if(!(n<p.length))return A.a(p,n)
p=p[n]
if(!(p<65537))return A.a(a,p)
q-=m
if(a[p]>>>6===(B.a.aW(i[0],q)&B.a.S(1,m)-1)>>>0){B.c.h(i,1,q)
q=o.c
if(!(n<q.length))return A.a(q,n)
l=A.l9(q[n],e,i,c,g,r,f)
r=l
break}}}if(n===o.b)throw A.h(A.m(j))}}}k=8-d&7
B.c.h(i,0,B.a.j(i[0],k))
B.c.h(i,1,i[1]-k)
while(q=i[1],q>0){p=B.a.V(i[0],14-q)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.h(i,1,q-p)
r=A.l9(o.b,e,i,c,g,r,f)}else throw A.h(A.m(j))}if(r!==f)throw A.h(A.m("Error in Huffman-encoded data (decoded data are shorter than expected)."))},
l9(a,b,c,d,e,f,g){var s,r,q,p,o,n,m="Error in Huffman-encoded data (decoded data are longer than expected)."
if(a===b){if(c[1]<8)A.l8(c,d)
B.c.h(c,1,c[1]-8)
s=B.a.aW(c[0],c[1])&255
if(f+s>g)throw A.h(A.m(m))
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
e[f]=a}else throw A.h(A.m(m))
f=n}return f},
ow(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i="Error in Huffman-encoded data (invalid code table entry)."
for(s=d.length,r=t.t,q=t.p;b<=c;++b){if(!(b<65537))return A.a(a,b)
p=a[b]
o=p>>>6
n=p&63
if(B.a.a7(o,n)!==0)throw A.h(A.m(i))
if(n>14){p=B.a.a3(o,n-14)
if(!(p<s))return A.a(d,p)
m=d[p]
if(m.a!==0)throw A.h(A.m(i))
p=++m.b
l=m.c
if(l!=null){m.shl(A.F(p,0,!1,q))
for(k=0;k<m.b-1;++k){p=m.c
p.toString
if(!(k<l.length))return A.a(l,k)
B.c.h(p,k,l[k])}}else m.shl(A.j([0],r))
p=m.c
p.toString
B.c.h(p,m.b-1,b)}else if(n!==0){p=14-n
j=B.a.V(o,p)
if(!(j<s))return A.a(d,j)
for(k=B.a.V(1,p);k>0;--k,++j){if(!(j<s))return A.a(d,j)
m=d[j]
if(m.a!==0||m.c!=null)throw A.h(A.m(i))
m.a=n
m.b=b}}}},
oA(a,b,c,d,e){var s,r,q,p,o,n="Error in Huffman-encoded data (unexpected end of code table data).",m="Error in Huffman-encoded data (code table is longer than expected).",l=a.d,k=A.j([0,0],t.t)
for(s=d+1;c<=d;++c){if(a.d-l>b)throw A.h(A.m(n))
r=A.mn(6,k,a)
B.c.h(e,c,r)
if(r===63){if(a.d-l>b)throw A.h(A.m(n))
q=A.mn(8,k,a)+6
if(c+q>s)throw A.h(A.m(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.h(e,c,0)}--c}else if(r>=59){q=r-59+2
if(c+q>s)throw A.h(A.m(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.h(e,c,0)}--c}}A.ox(e)},
ox(a){var s,r,q,p,o,n=A.F(59,0,!1,t.p)
for(s=0;s<65537;++s){r=a[s]
if(!(r<59))return A.a(n,r)
B.c.h(n,r,n[r]+1)}for(q=0,s=58;s>0;--s,q=p){p=q+n[s]>>>1
B.c.h(n,s,q)}for(s=0;s<65537;++s){o=a[s]
if(o>0){if(!(o<59))return A.a(n,o)
r=n[o]
B.c.h(n,o,r+1)
B.c.h(a,s,(o|r<<6)>>>0)}}},
l8(a,b){B.c.h(a,0,(a[0]<<8|b.G())>>>0)
B.c.h(a,1,a[1]+8>>>0)},
mn(a,b,c){var s
while(s=b[1],s<a){B.c.h(b,0,(b[0]<<8|J.d(c.a,c.d++))>>>0)
B.c.h(b,1,b[1]+8>>>0)}B.c.h(b,1,s-a)
return(B.a.aW(b[0],b[1])&B.a.S(1,a)-1)>>>0},
fB:function fB(){this.b=this.a=0
this.c=null},
oB(a){var s=A.v(a,!1,null,0)
if(s.k()!==20000630)return!1
if(s.G()!==2)return!1
if((s.bs()&4294967289)>>>0!==0)return!1
return!0},
fC:function fC(a){var _=this
_.b=_.a=0
_.c=a
_.d=null
_.e=$},
mC(a,b,c){var s=new A.fV(a,A.j([],t.g9),A.I(t.N,t.aX),B.bd,b)
s.hV(a,b,c)
return s},
dO:function dO(){},
it:function it(a,b){this.a=a
this.b=b},
fV:function fV(a,b,c,d,e){var _=this
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
fW:function fW(a,b,c){var _=this
_.r=null
_.w=a
_.x=b
_.y=$
_.z=null
_.b=_.a=0
_.c=c},
f6:function f6(){var _=this
_.f=_.e=_.d=_.c=_.b=_.a=$},
fX:function fX(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
fY:function fY(a,b){var _=this
_.r=null
_.w=a
_.b=_.a=0
_.c=b},
e4:function e4(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
is:function is(){this.a=null},
mp(a){var s=new Uint8Array(a*3)
return new A.dS(A.oI(a),a,null,new A.aL(s,a,3))},
oH(a){return new A.dS(a.a,a.b,a.c,A.mO(a.d))},
oI(a){var s
for(s=1;s<=8;++s)if(B.a.S(1,s)>=a)return s
return 0},
dS:function dS(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dT:function dT(){},
fZ:function fZ(){var _=this
_.e=_.d=_.c=_.b=_.a=$
_.f=null
_.r=80
_.w=0
_.x=-1
_.y=$},
dU:function dU(a){var _=this
_.b=_.a=0
_.e=_.c=null
_.r=a},
iy:function iy(){var _=this
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
iz:function iz(){var _=this
_.b=0
_.as=_.Q=_.z=null
_.ax=_.at=$
_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=_.ch=_.ay=0
_.fx=!1
_.fy=$
_.go=0
_.id=null},
iA:function iA(a,b){this.a=a
this.b=b},
mr(a){var s,r,q,p
if(a.p()!==0)return null
s=a.p()
if(s>=3)return null
if(B.dE[s]===B.bf)return null
r=a.p()
q=J.cg(r,t.gx)
for(p=0;p<r;++p){J.d(a.a,a.d++)
J.d(a.a,a.d++)
J.d(a.a,a.d++);++a.d
a.p()
a.p()
q[p]=new A.fM(a.k(),a.k())}return new A.fL(r,q)},
cZ:function cZ(a,b){this.a=a
this.b=b},
fL:function fL(a,b){this.d=a
this.e=b},
fM:function fM(a,b){this.d=a
this.e=b},
fJ:function fJ(a,b,c,d,e,f,g,h,i){var _=this
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
iC:function iC(){this.b=this.a=null},
jS:function jS(){},
fK:function fK(){},
fr:function fr(a,b,c){this.e=a
this.f=b
this.r=c},
bR:function bR(){},
cd:function cd(a){this.a=a},
dY:function dY(a){this.a=a},
td(b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2
if($.lN==null){s=new Uint8Array(768)
for(r=0;r<256;++r){q=256+r
if(!(q<768))return A.a(s,q)
s[q]=r}for(r=256;r<512;++r){q=256+r
if(!(q<768))return A.a(s,q)
s[q]=255}$.lN=s}for(q=b6.$flags|0,r=0;r<64;++r){p=b4[r]
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
b6[a9]=l-b}for(q=$.lN,p=b5.$flags|0,r=0;r<64;++r){q.toString
o=B.a.j(b6[r]+8,4)
o=384+((o&2147483647)-((o&2147483648)>>>0))
if(!(o>=0&&o<768))return A.a(q,o)
o=q[o]
p&2&&A.b(b5)
if(!(r<64))return A.a(b5,r)
b5[r]=o}},
rY(e5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2=null,e3="ifd0",e4=e5.w
if(e4.l(0,e3).a.a8(274)){s=e4.l(0,e3).gcl()
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
m=A.P(e2,e2,B.e,0,B.j,n,e2,0,3,e2,B.e,o,!1)
m.e=A.dN(e4)
m.gbI().l(0,e3).scl(e2)
m.c=e5.r
l=s-1
k=q-1
switch(r){case 2:j=new A.kD(m,k)
break
case 3:j=new A.kE(m,k,l)
break
case 4:j=new A.kF(m,l)
break
case 5:j=new A.kG(m)
break
case 6:j=new A.kH(m,l)
break
case 7:j=new A.kI(m,l,k)
break
case 8:j=new A.kJ(m,k)
break
default:j=m.ghI()
break}e4=e5.as
i=e4.length
switch(i){case 1:if(0>=i)return A.a(e4,0)
h=e4[0]
g=h.e
f=h.f
e=h.r
for(e4=g.length,d=0;d<s;++d){c=B.a.a7(d,e)
if(!(c<e4))return A.a(g,c)
b=g[c]
for(a=0;a<q;++a){a0=B.a.a7(a,f)
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
for(e4=a6.length,i=a7.length,a2=a8.length,d=0;d<s;++d){c=B.a.a7(d,e)
b3=B.a.a7(d,b0)
b4=B.a.a7(d,b2)
if(!(c<e4))return A.a(a6,c)
b=a6[c]
if(!(b3<i))return A.a(a7,b3)
b5=a7[b3]
if(!(b4<a2))return A.a(a8,b4)
b6=a8[b4]
for(a=0;a<q;++a){a0=B.a.a7(a,f)
b7=B.a.a7(a,a9)
b8=B.a.a7(a,b1)
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
b9=B.a.L((c4&2147483647)-((c4&2147483648)>>>0),0,255)
c4=B.a.j(a1-88*c2-183*c3,8)
c0=B.a.L((c4&2147483647)-((c4&2147483648)>>>0),0,255)
c4=B.a.j(a1+454*c2,8)
c1=B.a.L((c4&2147483647)-((c4&2147483648)>>>0),0,255)}j.$5(a,d,b9,c0,c1)}}break
case 4:a2=e5.c
if(a2==null)throw A.h(A.m("Unsupported color mode (4 components)"))
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
for(e4=a6.length,i=a7.length,c4=a8.length,c9=c6.length,d=0;d<s;++d){c=B.a.a7(d,e)
b3=B.a.a7(d,b0)
b4=B.a.a7(d,b2)
d0=B.a.a7(d,c8)
if(!(c<e4))return A.a(a6,c)
b=a6[c]
if(!(b3<i))return A.a(a7,b3)
b5=a7[b3]
if(!(b4<c4))return A.a(a8,b4)
b6=a8[b4]
if(!(d0<c9))return A.a(c6,d0)
d1=c6[d0]
for(a=0;a<q;++a){a0=B.a.a7(a,f)
b7=B.a.a7(a,a9)
b8=B.a.a7(a,b1)
d2=B.a.a7(a,c7)
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
d3=255-B.a.L((d9&2147483647)-((d9&2147483648)>>>0),0,255)
d9=B.a.j(d8-88*d7-183*d6,8)
d4=255-B.a.L((d9&2147483647)-((d9&2147483648)>>>0),0,255)
d9=B.a.j(d8+454*d7,8)
a1=255-B.a.L((d9&2147483647)-((d9&2147483648)>>>0),0,255)}d9=B.a.j(d3*d5,8)
e0=B.a.j(d4*d5,8)
e1=B.a.j(a1*d5,8)
j.$5(a,d,(d9&2147483647)-((d9&2147483648)>>>0),(e0&2147483647)-((e0&2147483648)>>>0),(e1&2147483647)-((e1&2147483648)>>>0))}}break
default:throw A.h(A.m("Unsupported color mode"))}return m},
kD:function kD(a,b){this.a=a
this.b=b},
kE:function kE(a,b,c){this.a=a
this.b=b
this.c=c},
kF:function kF(a,b){this.a=a
this.b=b},
kG:function kG(a){this.a=a},
kH:function kH(a,b){this.a=a
this.b=b},
kI:function kI(a,b,c){this.a=a
this.b=b
this.c=c},
kJ:function kJ(a,b){this.a=a
this.b=b},
iP:function iP(){this.d=null},
bV:function bV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.y=_.x=_.w=_.r=_.f=_.e=$},
mJ(){var s=A.F(4,null,!1,t.bC),r=A.j([],t.f8),q=t.eA,p=J.h5(0,q)
q=J.h5(0,q)
return new A.iR(new A.bQ(A.I(t.N,t.P)),s,r,p,q,A.j([],t.eB))},
iR:function iR(a,b,c,d,e,f){var _=this
_.b=_.a=$
_.r=_.e=_.d=_.c=null
_.w=a
_.x=b
_.y=c
_.z=d
_.Q=e
_.as=f},
dz:function dz(a){this.a=a
this.b=0},
h8:function h8(a,b){var _=this
_.e=_.d=_.c=_.b=null
_.r=_.f=0
_.x=_.w=$
_.y=a
_.z=b},
iT:function iT(){this.r=this.f=$},
h9:function h9(a,b,c,d,e,f,g,h){var _=this
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
h7:function h7(){},
iQ:function iQ(a,b){this.a=a
this.b=b},
iS:function iS(a,b,c,d,e,f,g,h,i){var _=this
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
df:function df(a,b){this.a=a
this.b=b},
ez:function ez(a,b){this.a=a
this.b=b},
eA:function eA(){},
h_:function h_(a,b,c,d,e,f,g,h,i){var _=this
_.y=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
mD(){var s=t.N
return new A.h0(A.I(s,s),A.j([],t.dm),A.j([],t.t))},
bY:function bY(a,b){this.a=a
this.b=b},
hp:function hp(){},
h0:function h0(a,b,c){var _=this
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
hm:function hm(a){var _=this
_.a=a
_.c=_.b=0
_.d=$
_.e=0},
p9(){return new A.hn()},
ho:function ho(a,b){this.a=a
this.b=b},
hn:function hn(){var _=this
_.a=null
_.c=0
_.e=$
_.f=0
_.r=!1
_.w=null},
bZ:function bZ(a,b){this.a=a
this.b=b},
c_:function c_(a){this.b=this.a=0
this.e=a},
ja:function ja(a){this.b=this.a=null
this.c=a},
jb:function jb(){},
hr:function hr(){this.a=null},
hs:function hs(){this.a=null},
bk:function bk(){},
hv:function hv(){this.a=null},
hw:function hw(){this.a=null},
hz:function hz(){this.a=null},
hA:function hA(){this.a=null},
eC:function eC(a){this.b=a},
hy:function hy(){},
jc:function jc(){var _=this
_.w=_.r=_.f=_.e=$},
cx:function cx(a){this.a=a
this.c=null},
mV(a){var s=new A.ht(A.j([],t.cE),A.I(t.p,t.fh))
s.i8(a)
return s},
lt(a,b,c,d){var s=a/255,r=b/255,q=c/255,p=d/255,o=r*(1-q),n=s*(1-p)
return B.b.i(B.b.L((2*s<q?2*r*s+o+n:p*q-2*(q-s)*(p-r)+o+n)*255,0,255))},
je(a,b){if(b===0)return 0
return B.a.i(B.a.L(B.b.i(255*(1-(1-a/255)/(b/255))),0,255))},
jg(a,b){return B.a.i(B.a.L(a+b-255,0,255))},
lv(a,b){return B.a.i(B.a.L(255-(255-b)*(255-a),0,255))},
jf(a,b){if(b===255)return 255
return B.b.i(B.b.L(a/255/(1-b/255)*255,0,255))},
lw(a,b){var s=a/255,r=b/255,q=1-r
return B.b.aS(255*(q*r*s+r*(1-q*(1-s))))},
lr(a,b){var s=b/255,r=a/255
if(r<0.5)return B.b.aS(510*s*r)
else return B.b.aS(255*(1-2*(1-s)*(1-r)))},
lx(a,b){if(b<128)return A.je(a,2*b)
else return A.jf(a,2*(b-128))},
ls(a,b){var s
if(b<128)return A.jg(a,2*b)
else{s=2*(b-128)
return s+a>255?255:a+s}},
lu(a,b){return b<128?Math.min(a,2*b):Math.max(a,2*(b-128))},
lq(a,b){return B.b.aS(b+a-2*b*a/255)},
aF(a,b,c){var s,r,q
if(a==null)s=0
else{s=a.length
if(c===1){if(!(b>=0&&b<s))return A.a(a,b)
s=a[b]}else{if(!(b>=0&&b<s))return A.a(a,b)
r=a[b]
q=b+1
if(!(q<s))return A.a(a,q)
q=(r<<8|a[q])>>>8
s=q}}return s},
mW(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.I(t.p,t.fW)
for(s=c1.length,r=0;q=c1.length,r<q;c1.length===s||(0,A.U)(c1),++r){p=c1[r]
b6.h(0,p.a,p)}if(b8===8)o=1
else o=b8===16?2:-1
n=A.P(b5,b5,B.e,0,B.j,c0,b5,0,q,b5,B.e,b9,!1)
if(o===-1)throw A.h(A.m("PSD: unsupported bit depth: "+A.z(b8)))
m=b6.l(0,0)
l=b6.l(0,1)
k=b6.l(0,2)
j=b6.l(0,-1)
i=A.j([0,0,0],t.t)
h=-o
for(s=n.a,s=s.gH(s),g=q>=5,f=q===4,e=q>=2,q=q>=4;s.E();){d=s.gP()
h+=o
switch(b7){case B.cu:d.sn(A.aF(m.c,h,o))
d.st(A.aF(l.c,h,o))
d.su(A.aF(k.c,h,o))
d.sA(q?A.aF(j.c,h,o):255)
if(d.gA()!==0){d.sn((d.gn()+d.gA()-255)*255/d.gA())
d.st((d.gt()+d.gA()-255)*255/d.gA())
d.su((d.gu()+d.gA()-255)*255/d.gA())}break
case B.cw:c=A.aF(m.c,h,o)
b=A.aF(l.c,h,o)
a=A.aF(k.c,h,o)
a0=q?A.aF(j.c,h,o):255
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
b0=[B.b.aS(B.b.L(a7*255,0,255)),B.b.aS(B.b.L(a8*255,0,255)),B.b.aS(B.b.L(a9*255,0,255))]
d.sn(b0[0])
d.st(b0[1])
d.su(b0[2])
d.sA(a0)
break
case B.ct:b1=A.aF(m.c,h,o)
a0=e?A.aF(j.c,h,o):255
d.sn(b1)
d.st(b1)
d.su(b1)
d.sA(a0)
break
case B.cv:b2=A.aF(m.c,h,o)
b3=A.aF(l.c,h,o)
a1=A.aF(k.c,h,o)
b4=A.aF(b6.l(0,f?-1:3).c,h,o)
a0=g?A.aF(j.c,h,o):255
A.nB(255-b2,255-b3,255-a1,255-b4,i)
d.sn(i[0])
d.st(i[1])
d.su(i[2])
d.sA(a0)
break
default:throw A.h(A.m("Unhandled color mode: "+A.z(b7)))}}return n},
b8:function b8(a,b){this.a=a
this.b=b},
ht:function ht(a,b){var _=this
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
hu:function hu(){},
hx:function hx(a,b,c){var _=this
_.b=_.a=null
_.f=_.e=_.d=_.c=$
_.r=null
_.as=_.y=_.w=$
_.ay=a
_.ch=b
_.cx=null
_.cy=c},
pm(a,b){var s
switch(a){case"lsct":s=b.c-b.d
b.k()
if(s>=12){if(b.al(4)!=="8BIM")A.az(A.m("Invalid key in layer additional data"))
b.al(4)}if(s>=16)b.k()
return new A.hy()
default:return new A.eC(b)}},
di:function di(){},
jd:function jd(){this.a=null},
hB:function hB(){},
aV:function aV(a,b,c){this.a=a
this.b=b
this.c=c},
M:function M(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dl:function dl(a,b,c){this.a=a
this.b=b
this.$ti=c},
dj:function dj(){var _=this
_.Q=_.z=_.y=_.f=_.d=_.b=_.a=0},
dk:function dk(a){var _=this
_.b=0
_.c=a
_.Q=_.r=_.f=0},
eD:function eD(){this.y=this.b=this.a=0},
a8(a,b){var s,r=a>>>8
if(!(r<256))return A.a(B.V,r)
r=B.V[r]
s=b>>>8
if(!(s<256))return A.a(B.V,s)
return(r<<17|B.V[s]<<16|B.V[a&255]<<1|B.V[b&255])>>>0},
a4:function a4(a){var _=this
_.a=a
_.b=0
_.c=!1
_.d=0
_.e=!1
_.f=0
_.r=!1},
jh:function jh(){this.b=this.a=null},
pn(a,b,c){var s=new A.jj(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dl(r.cR(),q.cR(),t.aN)
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
po(a,b,c){var s=new A.jk(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dl(r.cR(),q.cR(),t.eZ)
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
eE:function eE(a,b){this.a=a
this.b=b},
ji:function ji(){},
jj:function jj(a,b,c){this.a=a
this.b=b
this.c=c},
jk:function jk(a,b,c){this.a=a
this.b=b
this.c=c},
eK:function eK(a){var _=this
_.b=_.a=0
_.c=a
_.Q=_.z=_.y=_.x=_.f=_.e=0
_.as=null
_.ax=0},
aw:function aw(a,b){this.a=a
this.b=b},
jo:function jo(){this.a=null
this.b=$},
jp:function jp(){},
jq:function jq(a){this.a=a
this.c=this.b=0},
hG:function hG(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.f=e},
lB(a,b,c){var s=new A.jt(b,a),r=t.I
s.e=A.F(b,null,!1,r)
s.f=A.F(b,null,!1,r)
return s},
jt:function jt(a,b){var _=this
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
hH:function hH(a,b,c,d){var _=this
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
cy:function cy(a,b){this.a=a
this.b=b},
aa:function aa(a,b){this.a=a
this.b=b},
aY:function aY(a,b){this.a=a
this.b=b},
hI:function hI(a){var _=this
_.b=_.a=0
_.d=null
_.f=a},
mL(){return new A.j2(new Uint8Array(4096))},
j2:function j2(a){var _=this
_.a=9
_.d=_.c=_.b=0
_.w=_.r=_.f=_.e=$
_.x=a
_.z=_.y=$
_.Q=null
_.as=$},
jr:function jr(){this.a=null
this.c=$},
js:function js(){},
lC(a,b){var s=new Int32Array(4),r=new Int32Array(4),q=new Int8Array(4),p=new Int8Array(4),o=A.F(8,null,!1,t.eW),n=A.F(4,null,!1,t.dP)
return new A.jy(a,b,new A.jE(),new A.jH(),new A.jA(s,r),new A.jJ(q,p),o,n,new Uint8Array(4))},
n3(a,b,c){if(c===0)if(a===0)return b===0?6:5
else return b===0?4:0
return c},
jy:function jy(a,b,c,d,e,f,g,h,i){var _=this
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
_.aR=null
_.bK=$
_.bT=_.ck=null
_.aX=$},
jK:function jK(){},
n1(a){var s=new A.eN(a)
s.b=254
s.c=0
s.d=-8
return s},
eN:function eN(a){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=!1},
G(a,b,c){return B.a.aF(B.a.j(a+2*b+c+2,2),32)},
pF(a){var s,r=A.j([A.G(J.d(a.a,a.d+-33),J.d(a.a,a.d+-32),J.d(a.a,a.d+-31)),A.G(J.d(a.a,a.d+-32),J.d(a.a,a.d+-31),J.d(a.a,a.d+-30)),A.G(J.d(a.a,a.d+-31),J.d(a.a,a.d+-30),J.d(a.a,a.d+-29)),A.G(J.d(a.a,a.d+-30),J.d(a.a,a.d+-29),J.d(a.a,a.d+-28))],t.t)
for(s=0;s<4;++s)a.c6(s*32,4,r)},
px(a){var s=J.d(a.a,a.d+-33),r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=A.p(a,null,0),m=n.d_(),l=A.G(s,r,q)
m.$flags&2&&A.b(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.d_()
m=A.G(r,q,p)
l.$flags&2&&A.b(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m
n.d+=32
m=n.d_()
l=A.G(q,p,o)
m.$flags&2&&A.b(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.d_()
m=A.G(p,o,o)
l.$flags&2&&A.b(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m},
pv(a){var s,r,q,p
for(s=4,r=0;r<4;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
s=B.a.j(s,3)
for(r=0;r<4;++r){q=a.a
p=a.d+r*32
J.bp(q,p,p+4,s)}},
lD(a,b){var s,r,q,p,o,n,m=255-J.d(a.a,a.d+-33)
for(s=0,r=0;r<b;++r){q=m+J.d(a.a,a.d+(s-1))
for(p=0;p<b;++p){o=$.aH()
n=q+J.d(a.a,a.d+(-32+p))
if(!(n>=0&&n<766))return A.a(o,n)
n=o[n]
J.x(a.a,a.d+(s+p),n)}s+=32}},
pD(a){A.lD(a,4)},
pE(a){A.lD(a,8)},
pC(a){A.lD(a,16)},
pB(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=J.d(a.a,a.d+-33),m=J.d(a.a,a.d+-32),l=J.d(a.a,a.d+-31),k=J.d(a.a,a.d+-30),j=J.d(a.a,a.d+-29)
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
pA(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
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
pH(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+-33),o=J.d(a.a,a.d+-32),n=J.d(a.a,a.d+-31),m=J.d(a.a,a.d+-30),l=J.d(a.a,a.d+-29),k=B.a.aF(B.a.j(p+o+1,1),32)
a.h(0,65,k)
a.h(0,0,k)
k=B.a.aF(B.a.j(o+n+1,1),32)
a.h(0,66,k)
a.h(0,1,k)
k=B.a.aF(B.a.j(n+m+1,1),32)
a.h(0,67,k)
a.h(0,2,k)
a.h(0,3,B.a.aF(B.a.j(m+l+1,1),32))
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
pG(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.h(0,0,B.a.aF(B.a.j(r+q+1,1),32))
s=B.a.aF(B.a.j(q+p+1,1),32)
a.h(0,64,s)
a.h(0,1,s)
s=B.a.aF(B.a.j(p+o+1,1),32)
a.h(0,65,s)
a.h(0,2,s)
s=B.a.aF(B.a.j(o+n+1,1),32)
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
py(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95)
a.h(0,0,B.a.aF(B.a.j(r+q+1,1),32))
s=B.a.aF(B.a.j(q+p+1,1),32)
a.h(0,32,s)
a.h(0,2,s)
s=B.a.aF(B.a.j(p+o+1,1),32)
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
pw(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+95),o=J.d(a.a,a.d+-33),n=J.d(a.a,a.d+-32),m=J.d(a.a,a.d+-31),l=J.d(a.a,a.d+-30),k=B.a.aF(B.a.j(s+o+1,1),32)
a.h(0,34,k)
a.h(0,0,k)
k=B.a.aF(B.a.j(r+s+1,1),32)
a.h(0,66,k)
a.h(0,32,k)
k=B.a.aF(B.a.j(q+r+1,1),32)
a.h(0,98,k)
a.h(0,64,k)
a.h(0,96,B.a.aF(B.a.j(p+q+1,1),32))
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
pS(a){var s
for(s=0;s<16;++s)a.bq(s*32,16,a,-32)},
pQ(a){var s,r,q,p,o
for(s=0,r=16;r>0;--r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.bp(p,o,o+16,q)
s+=32}},
jC(a,b){var s,r,q
for(s=0;s<16;++s){r=b.a
q=b.d+s*32
J.bp(r,q,q+16,a)}},
pI(a){var s,r
for(s=16,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))+J.d(a.a,a.d+(r-32))
A.jC(B.a.j(s,5),a)},
pK(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.jC(B.a.j(s,4),a)},
pJ(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(r-32))
A.jC(B.a.j(s,4),a)},
pL(a){A.jC(128,a)},
pT(a){var s
for(s=0;s<8;++s)a.bq(s*32,8,a,-32)},
pR(a){var s,r,q,p,o
for(s=0,r=0;r<8;++r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.bp(p,o,o+8,q)
s+=32}},
jD(a,b){var s,r,q
for(s=0;s<8;++s){r=b.a
q=b.d+s*32
J.bp(r,q,q+8,a)}},
pM(a){var s,r
for(s=8,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
A.jD(B.a.j(s,4),a)},
pN(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))
A.jD(B.a.j(s,3),a)},
pO(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.jD(B.a.j(s,3),a)},
pP(a){A.jD(128,a)},
c0(a,b,c,d,e){var s=b+c+d*32,r=J.d(a.a,a.d+s)+B.a.j(e,3)
if(!((r&-256)>>>0===0))r=r<0?0:255
a.h(0,s,r)},
jB(a,b,c,d,e){A.c0(a,0,0,b,c+d)
A.c0(a,0,1,b,c+e)
A.c0(a,0,2,b,c-e)
A.c0(a,0,3,b,c-d)},
pz(){var s,r,q,p
if(!$.n2){for(s=-255;s<=255;++s){r=$.ib()
q=255+s
p=s<0?-s:s
r.$flags&2&&A.b(r)
r[q]=p
p=$.kX()
r=B.a.j(r[q],1)
p.$flags&2&&A.b(p)
p[q]=r}for(s=-1020;s<=1020;++s){r=$.kY()
if(s<-128)q=-128
else q=s>127?127:s
r.$flags&2&&A.b(r)
r[1020+s]=q}for(s=-112;s<=112;++s){r=$.kZ()
if(s<-16)q=-16
else q=s>15?15:s
r.$flags&2&&A.b(r)
r[112+s]=q}for(s=-255;s<=510;++s){r=$.aH()
if(s<0)q=0
else q=s>255?255:s
r.$flags&2&&A.b(r)
r[255+s]=q}$.n2=!0}},
jz:function jz(){},
pu(){var s,r=J.ao(3,t.D)
for(s=0;s<3;++s)r[s]=new Uint8Array(11)
return new A.eM(r)},
q8(){var s,r,q,p,o=new Uint8Array(3),n=J.ao(4,t.c7)
for(s=t.dd,r=0;r<4;++r){q=J.ao(8,s)
for(p=0;p<8;++p)q[p]=A.pu()
n[r]=q}B.d.aD(o,0,3,255)
return new A.jI(o,n)},
jE:function jE(){this.d=$},
jH:function jH(){},
jJ:function jJ(a,b){var _=this
_.b=_.a=!1
_.c=!0
_.d=a
_.e=b},
eM:function eM(a){this.a=a},
jI:function jI(a,b){this.a=a
this.b=b},
jA:function jA(a,b){var _=this
_.a=$
_.b=null
_.d=_.c=$
_.e=a
_.f=b},
bH:function bH(){var _=this
_.b=_.a=0
_.c=!1
_.d=0},
eP:function eP(){this.b=this.a=0},
hP:function hP(a,b,c){this.a=a
this.b=b
this.c=c},
eQ:function eQ(a,b){var _=this
_.a=a
_.b=$
_.c=b
_.e=_.d=null
_.f=$},
eR:function eR(a,b,c){this.a=a
this.b=b
this.c=c},
lE(a,b){var s,r=A.j([],t.e),q=A.j([],t.gk),p=new Uint32Array(2),o=new A.hN(a,p)
p=o.e=J.D(B.o.gB(p),0,null)
s=a.G()
p.$flags&2&&A.b(p)
if(0>=p.length)return A.a(p,0)
p[0]=s
s=a.G()
p.$flags&2&&A.b(p)
if(1>=p.length)return A.a(p,1)
p[1]=s
s=a.G()
p.$flags&2&&A.b(p)
if(2>=p.length)return A.a(p,2)
p[2]=s
s=a.G()
p.$flags&2&&A.b(p)
if(3>=p.length)return A.a(p,3)
p[3]=s
s=a.G()
p.$flags&2&&A.b(p)
if(4>=p.length)return A.a(p,4)
p[4]=s
s=a.G()
p.$flags&2&&A.b(p)
if(5>=p.length)return A.a(p,5)
p[5]=s
s=a.G()
p.$flags&2&&A.b(p)
if(6>=p.length)return A.a(p,6)
p[6]=s
s=a.G()
p.$flags&2&&A.b(p)
if(7>=p.length)return A.a(p,7)
p[7]=s
o.b=!1
return new A.eO(o,b,r,q)},
c1(a,b){return B.a.j(a+B.a.S(1,b)-1,b)},
eO:function eO(a,b,c,d){var _=this
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
h1:function h1(a,b,c,d){var _=this
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
hN:function hN(a,b){var _=this
_.a=0
_.b=!0
_.c=a
_.d=b
_.e=$},
jF:function jF(a,b){this.a=a
this.b=b},
bI(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
cA(a){if(a<0)return 0
if(a>255)return 255
return a},
jG(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
pU(a,b,c){return 4278190080},
pV(a,b,c){return a},
q_(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return b[c]},
q0(a,b,c){var s=c+1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
q1(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
q2(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bI(A.bI(a,b[r]),s)},
q3(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return A.bI(a,b[s])},
q4(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return A.bI(a,b[c])},
q5(a,b,c){var s=c-1,r=b.length
if(!(s>=0&&s<r))return A.a(b,s)
s=b[s]
if(!(c>=0&&c<r))return A.a(b,c)
return A.bI(s,b[c])},
q6(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bI(s,b[r])},
pW(a,b,c){var s,r,q=c-1,p=b.length
if(!(q>=0&&q<p))return A.a(b,q)
q=b[q]
if(!(c>=0&&c<p))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<p))return A.a(b,r)
r=b[r]
return A.bI(A.bI(a,q),A.bI(s,r))},
pX(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return A.jG(s>>>24,a>>>24,r>>>24)+A.jG(s>>>16&255,a>>>16&255,r>>>16&255)+A.jG(s>>>8&255,a>>>8&255,r>>>8&255)+A.jG(s&255,a&255,r&255)<=0?s:a},
pY(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return(A.cA((a>>>24)+(s>>>24)-(r>>>24))<<24|A.cA((a>>>16&255)+(s>>>16&255)-(r>>>16&255))<<16|A.cA((a>>>8&255)+(s>>>8&255)-(r>>>8&255))<<8|A.cA((a&255)+(s&255)-(r&255)))>>>0},
pZ(a,b,c){var s,r,q,p,o,n=b.length
if(!(c>=0&&c<n))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<n))return A.a(b,r)
r=b[r]
q=A.bI(a,s)
s=q>>>24
n=q>>>16&255
p=q>>>8&255
o=q>>>0&255
return(A.cA(s+B.a.W(s-(r>>>24),2))<<24|A.cA(n+B.a.W(n-(r>>>16&255),2))<<16|A.cA(p+B.a.W(p-(r>>>8&255),2))<<8|A.cA(o+B.a.W(o-(r&255),2)))>>>0},
cz:function cz(a,b){this.a=a
this.b=b},
hO:function hO(a){var _=this
_.a=a
_.c=_.b=0
_.d=null
_.e=0},
jL:function jL(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0
_.r=1
_.w=!1
_.x=$
_.y=!1},
eS:function eS(){},
h2:function h2(a,b,c){var _=this
_.a=a
_.b=b
_.e=c
_.f=$
_.r=1
_.x=_.w=$},
lb(a){var s,r=J.cg(a,t.gj)
for(s=0;s<a;++s)r[s]=new A.fE()
return new A.dW(r,0)},
oJ(){var s,r,q=J.ao(5,t.fa)
for(s=0;s<5;++s)q[s]=A.lb(0)
r=J.ao(64,t.ak)
for(s=0;s<64;++s)r[s]=new A.fF()
return new A.dV(q,r)},
fE:function fE(){this.b=this.a=0},
fF:function fF(){this.b=this.a=0},
dW:function dW(a,b){this.a=a
this.b=b},
dV:function dV(a,b){var _=this
_.a=a
_.b=!1
_.c=0
_.e=_.d=!1
_.f=b},
dX:function dX(){var _=this
_.b=_.a=null
_.e=_.d=0},
fH:function fH(a){this.a=a
this.b=null},
du:function du(a,b){this.a=a
this.b=b},
dv:function dv(a,b){var _=this
_.b=_.a=0
_.e=_.d=!1
_.f=a
_.w=""
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
e5:function e5(a,b){var _=this
_.b=_.a=0
_.e=_.d=!1
_.f=a
_.w=""
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
jM:function jM(){this.b=this.a=null},
jN:function jN(){},
jP:function jP(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jQ:function jQ(){},
jO:function jO(a){this.a=a},
bJ:function bJ(a,b,c){this.a=a
this.b=b
this.c=c},
k_:function k_(a){this.a=a
this.c=this.b=0},
mq(a){return new A.cY(a.a,a.b,B.d.hO(a.c,0))},
fI:function fI(a,b){this.a=a
this.b=b},
cY:function cY(a,b,c){this.a=a
this.b=b
this.c=c},
P(a,b,c,d,e,f,g,h,i,j,k,l,m){var s,r=new A.bj(null,null,null,a,h,e,d,0)
B.c.C(r.gaj(),r)
r.c=g
if(b!=null)r.e=A.dN(b)
s=!1
if(j==null)if(m)s=r.gM()===B.y||r.gM()===B.t||r.gM()===B.z||r.gM()===B.e||r.gM()===B.n
r.eS(l,f,c,i,s?r.iC(c,k,i):j)
return r},
fN(a,b,c,d){var s,r,q,p=null,o=a.e
o=o==null?p:A.dN(o)
s=a.c
s=s==null?p:A.mq(s)
r=a.w
q=a.r
o=new A.bj(p,s,o,p,q,r,a.y,a.z)
o.i5(a,b,c,d)
return o},
bz(a,b,c){var s,r,q,p,o=null,n=a.a
n=n==null?o:n.bm(c)
s=a.e
s=s==null?o:A.dN(s)
r=a.c
r=r==null?o:A.mq(r)
q=a.w
p=a.r
n=new A.bj(n,r,s,o,p,q,a.y,a.z)
n.i4(a,b,c)
return n},
fD:function fD(a,b){this.a=a
this.b=b},
bj:function bj(a,b,c,d,e,f,g,h){var _=this
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
iJ:function iJ(a,b){this.a=a
this.b=b},
iI:function iI(){},
af:function af(){},
oL(a,b,c){return new A.d_(new Uint16Array(a*b*c),a,b,c)},
d_:function d_(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
oM(a,b,c){return new A.d0(new Float32Array(a*b*c),a,b,c)},
d0:function d0(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dZ:function dZ(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e_:function e_(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e0:function e0(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
e1:function e1(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
d1:function d1(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
d2:function d2(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
d3:function d3(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
oN(a,b,c){return new A.d4(new Uint32Array(a*b*c),a,b,c)},
d4:function d4(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
d5:function d5(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
mB(a,b,c){return new A.d6(new Uint8Array(a*b*c),null,a,b,c)},
d6:function d6(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
h3:function h3(a,b){this.a=a
this.b=b},
aU:function aU(){},
ep:function ep(a,b,c){this.c=a
this.a=b
this.b=c},
eq:function eq(a,b,c){this.c=a
this.a=b
this.b=c},
er:function er(a,b,c){this.c=a
this.a=b
this.b=c},
es:function es(a,b,c){this.c=a
this.a=b
this.b=c},
et:function et(a,b,c){this.c=a
this.a=b
this.b=c},
eu:function eu(a,b,c){this.c=a
this.a=b
this.b=c},
ev:function ev(a,b,c){this.c=a
this.a=b
this.b=c},
de:function de(a,b,c){this.c=a
this.a=b
this.b=c},
mO(a){return new A.aL(new Uint8Array(A.q(a.c)),a.a,a.b)},
aL:function aL(a,b,c){this.c=a
this.a=b
this.b=c},
li(a){return new A.cl(-1,0,-a.c,a)},
cl:function cl(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lj(a){return new A.cm(-1,0,-a.c,a)},
cm:function cm(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lk(a){return new A.cn(-1,0,-a.c,a)},
cn:function cn(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ll(a){return new A.co(-1,0,-a.c,a)},
co:function co(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lm(a){return new A.cp(-1,0,-a.c,a)},
cp:function cp(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ln(a){return new A.cq(-1,0,-a.c,a)},
cq:function cq(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
b7(a,b,c,d,e){a.a5(b-1,c)
return new A.hk(a,b,b+d-1,c+e-1)},
hk:function hk(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
ew(a){return new A.cr(-1,0,0,-1,0,a)},
cr:function cr(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
lo(a){return new A.cs(-1,0,-a.c,a)},
cs:function cs(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ex(a){return new A.ct(-1,0,0,-2,0,a)},
ct:function ct(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
lp(a){return new A.cu(-1,0,-a.c,a)},
cu:function cu(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ey(a){return new A.cv(-1,0,0,-(a.c<<2>>>0),a)},
cv:function cv(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
j9(a){return new A.cw(-1,0,-a.c,a)},
cw:function cw(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
C:function C(){},
rU(a,b){switch(b.a){case 0:A.i7(a)
break
case 1:A.rW(a)
break
case 2:A.rV(a)
break}return a},
rW(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,c=a.gaj().length
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
if((o==null?d:o.gN())!=null)for(j=l-1,i=0;i<k;++i,--j)for(h=0;h<m;++h){o=p.a
g=o==null?d:o.O(h,i,d)
if(g==null)g=new A.C()
o=p.a
f=o==null?d:o.O(h,j,d)
if(f==null)f=new A.C()
e=g.gT()
g.sT(f.gT())
f.sT(e)}else for(j=l-1,i=0;i<k;++i,--j)for(h=0;h<m;++h){o=p.a
g=o==null?d:o.O(h,i,d)
if(g==null)g=new A.C()
o=p.a
f=o==null?d:o.O(h,j,d)
if(f==null)f=new A.C()
e=g.gn()
g.sn(f.gn())
f.sn(e)
e=g.gt()
g.st(f.gt())
f.st(e)
e=g.gu()
g.su(f.gu())
f.su(e)
e=g.gA()
g.sA(f.gA())
f.sA(e)}}return a},
i7(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null,b=a.gaj().length
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
if((o==null?c:o.gN())!=null)for(j=m-1,i=0;i<l;++i)for(h=j,g=0;g<k;++g,--h){o=p.a
f=o==null?c:o.O(g,i,c)
if(f==null)f=new A.C()
o=p.a
e=o==null?c:o.O(h,i,c)
if(e==null)e=new A.C()
d=f.gT()
f.sT(e.gT())
e.sT(d)}else for(j=m-1,i=0;i<l;++i)for(h=j,g=0;g<k;++g,--h){o=p.a
f=o==null?c:o.O(g,i,c)
if(f==null)f=new A.C()
o=p.a
e=o==null?c:o.O(h,i,c)
if(e==null)e=new A.C()
d=f.gn()
f.sn(e.gn())
e.sn(d)
d=f.gt()
f.st(e.gt())
e.st(d)
d=f.gu()
f.su(e.gu())
e.su(d)
d=f.gA()
f.sA(e.gA())
e.sA(d)}}return a},
rV(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null,a=a0.gaj().length
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
if((n?b:o.gN())!=null)for(j=l-1,i=m-1,h=0;h<k;++h,--j)for(g=i,f=0;f<m;++f,--g){o=p.a
e=o==null?b:o.O(f,h,b)
if(e==null)e=new A.C()
o=p.a
d=o==null?b:o.O(g,j,b)
if(d==null)d=new A.C()
c=e.gT()
e.sT(d.gT())
d.sT(c)}else for(j=l-1,i=m-1,h=0;h<k;++h,--j)for(g=i,f=0;f<m;++f,--g){o=p.a
e=o==null?b:o.O(f,h,b)
if(e==null)e=new A.C()
o=p.a
d=o==null?b:o.O(g,j,b)
if(d==null)d=new A.C()
c=e.gn()
e.sn(d.gn())
d.sn(c)
c=e.gt()
e.st(d.gt())
d.st(c)
c=e.gu()
e.su(d.gu())
d.su(c)
c=e.gA()
e.sA(d.gA())
d.sA(c)}}return a0},
iu:function iu(a,b){this.a=a
this.b=b},
m(a){return new A.iH(a)},
iH:function iH(a){this.a=a},
v(a,b,c,d){var s=J.a5(a),r=s.gv(a)
s=c==null?s.gv(a):d+c
return new A.ag(a,d,Math.min(r,s),d,b)},
p(a,b,c){var s=a.a,r=a.d,q=a.b,p=J.bq(s),o=b==null?a.c:a.d+c+b
return new A.ag(s,q,Math.min(p,o),r+c,a.e)},
ag:function ag(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
lh(a,b,c){var s=new A.hg(c,new Int32Array(256))
s.jE(b)
s.kM(a)
return s},
hg:function hg(a,b){var _=this
_.a=$
_.b=a
_.c=16
_.d=3
_.f=_.e=$
_.r=null
_.Q=_.z=_.y=_.x=_.w=$
_.as=b
_.ax=_.at=$},
a7(a,b){return new A.hi(a,new Uint8Array(b))},
hi:function hi(a,b){this.a=0
this.b=a
this.c=b},
jl:function jl(a,b){this.a=a
this.b=b},
hC:function hC(){},
aW:function aW(a,b){this.a=a
this.b=b},
hc:function hc(a,b){this.a=a
this.b=b},
j0:function j0(a){this.c=a},
j1:function j1(){},
ec:function ec(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
oV(a){var s=null,r=A.nD(a)
if(r==null)return s
return new A.hd(a,r.gR(),r.gK(),A.mb(r,4,3).a,s,s,s)},
oW(a){var s,r,q,p,o,n,m=null,l=A.nD(a.a),k=l.gK()>l.gR()?a.b:m,j=A.rK(l,k,l.gR()>=l.gK()?a.b:m)
k=a.c
s=A.rP(k,j)
if(s==null)return m
r=new Uint8Array(A.q(s))
q=j.gR()
p=j.gK()
o=l.gK()
n=l.gR()
k=$.o9().li(k,m)
return new A.hd(r,q,p,a.d?A.mb(j,4,3).a:m,k,o,n)},
hd:function hd(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
j4:function j4(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jR:function jR(a,b,c){this.a=a
this.b=b
this.c=c},
eT:function eT(a,b){this.a=a
this.b=b},
m_(){var s=0,r=A.rh(t.x),q,p,o
var $async$m_=A.rB(function(a,b){if(a===1)return A.qM(b,r)
for(;;)switch(s){case 0:$.kW().fY(new A.ec("[native implementations worker]: Starting...",null,$.m3().$1(null),B.dA))
q=A.bn(v.G.self)
p=new A.kV()
if(typeof p=="function")A.az(A.br("Attempting to rewrap a JS function.",null))
o=function(c,d){return function(e){return c(d,e,arguments.length)}}(A.qQ,p)
o[$.m2()]=p
q.onmessage=o
return A.qN(null,r)}})
return A.qO($async$m_,r)},
ny(a,b){var s,r,q
try{A.bn(v.G.self).postMessage(A.lX(A.lf(["label",a,"data",b],t.N,t.z)))}catch(q){s=A.c7(q)
r=A.bN(q)
$.kW().hd(u.g+A.z(s)+", "+A.z(r))}},
rn(a,b,c){var s,r,q,p
a=a
if(a!=null)try{s=A.lX(a)
if(s!=null)a=s}catch(p){a=J.dH(a)}try{A.bn(v.G.self).postMessage(A.lX(A.lf(["label","stacktrace","origin",c,"error",a,"stacktrace",b.D(0)],t.N,t.X)))}catch(p){r=A.c7(p)
q=A.bN(p)
$.kW().hd(u.g+A.z(r)+", "+A.z(q))}},
kV:function kV(){},
oX(a){var s=B.m.lh(a,".")
if(s<0||s+1>=a.length)return a
return B.m.es(a,s+1).toLowerCase()},
j5:function j5(a,b){this.a=a
this.b=b},
pt(a){throw A.h(A.aq("Uint64List not supported on the web."))},
oO(a,b,c){return J.l1(a,b,c)},
n_(a,b){return J.Z(a,b,null)},
oF(a){return J.m7(a,0,null)},
oG(a){return a.lP(0,0,null)},
nM(a){return v.mangledGlobalNames[a]},
nI(a,b,c){A.rH(c,t.q,"T","max")
return Math.max(c.a(a),c.a(b))},
rX(a){var s,r,q,p,o,n=a.gv(0)
for(s=1,r=0;n>0;){q=3800>n?n:3800
n-=q
while(--q,q>=0){p=a.b
p.toString
o=a.c++
if(!(o>=0&&o<p.length))return A.a(p,o)
s+=p[o]
r+=s}s=B.a.a9(s,65521)
r=B.a.a9(r,65521)}return(r<<16|s)>>>0},
bo(a,b){var s,r,q=J.a5(a),p=q.gv(a)
b^=4294967295
for(s=0;p>=8;){r=s+1
b=B.E[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.E[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.E[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.E[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.E[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.E[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.E[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.E[(b^q.l(a,r))&255]^b>>>8
p-=8}if(p>0)do{r=s+1
b=B.E[(b^q.l(a,s))&255]^b>>>8
if(--p,p>0){s=r
continue}else break}while(!0)
return(b^4294967295)>>>0},
i6(a,b){var s,r,q,p=B.l1.gc5()
p=A.w(p,A.l(p).q("e.E"))
for(s=1,r="";s<=b;++s,r=q){q=B.b.i(B.b.a9(a/Math.pow(83,b-s),83))
if(q>=0&&q<p.length){if(!(q>=0&&q<p.length))return A.a(p,q)
q=p[q]}else q=null
q=r+A.z(q)}return r.charCodeAt(0)==0?r:r},
lT(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n,m,l
if(j==null)j=0
if(k==null)k=0
if(i==null)i=b.gR()
if(h==null)h=b.gK()
if(e==null)e=a.gR()<b.gR()?a.gR():b.gR()
if(d==null)d=a.gK()<b.gK()?a.gK():b.gK()
s=c===B.aC
if(!s&&a.gaN())a=a.e8(a.gaE())
r=h/d
q=i/e
p=t.p
o=J.ao(d,p)
for(n=0;n<d;++n)o[n]=k+B.b.i(n*r)
m=J.ao(e,p)
for(l=0;l<e;++l)m[l]=j+B.b.i(l*q)
if(s)A.qT(b,a,f,g,e,d,m,o,null,B.ba)
else A.qR(b,a,f,g,e,d,m,o,c,!1,null,B.ba)
return a},
qT(a,b,c,d,e,f,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h=b.gR(),g=b.gK()
for(s=a0.length,r=a1.length,q=null,p=0;p<f;++p)for(o=d+p,n=o>=g,m=0;m<e;++m){l=c+m
if(l>=h||n)continue
if(!(m<s))return A.a(a0,m)
k=a0[m]
if(!(p<r))return A.a(a1,p)
j=a1[p]
i=a.a
q=i==null?null:i.O(k,j,q)
if(q==null)q=new A.C()
b.c8(l,o,q)}},
qR(a,b,c,d,e,f,g,h,i,j,a0,a1){var s,r,q,p,o,n,m,l,k
for(s=g.length,r=h.length,q=null,p=0;p<f;++p)for(o=d+p,n=0;n<e;++n){if(!(n<s))return A.a(g,n)
m=g[n]
if(!(p<r))return A.a(h,p)
l=h[p]
k=a.a
q=k==null?null:k.O(m,l,q)
if(q==null)q=new A.C()
A.rO(b,c+n,o,q,i,!1,a0,a1)}},
rO(a6,a7,a8,a9,b0,b1,b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5
if(!a6.hh(a7,a8))return a6
if(b0===B.aC||a6.gaN())if(a6.hh(a7,a8)){a6.aP(a7,a8).ah(a9)
return a6}s=a9.gag()
r=a9.gac()
q=a9.gaf()
p=a9.gv(a9)<4?1:a9.ga_()
if(p===0)return a6
o=a6.aP(a7,a8)
n=o.gag()
m=o.gac()
l=o.gaf()
k=o.ga_()
switch(b0.a){case 0:return a6
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
h=B.b.L(p,0.01,1)
i=p<0
d=i?0:1
c=B.b.L(s/h*d,0,0.99)
d=B.b.L(p,0.01,1)
h=i?0:1
b=B.b.L(r/d*h,0,0.99)
h=B.b.L(p,0.01,1)
i=i?0:1
a=B.b.L(q/h*i,0,0.99)
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
o.sag(s*p+n*k*a5)
o.sac(r*p+m*k*a5)
o.saf(q*p+l*k*a5)
o.sa_(p+k*a5)
return a6},
rR(a,b,c,d,e,f,g){var s,r=B.b.L(Math.min(d,e),0,a.gR()-1),q=B.b.L(Math.min(f,g),0,a.gK()-1),p=B.b.L(Math.max(d,e),0,a.gR()-1),o=B.b.L(Math.max(f,g),0,a.gK()-1),n=a.a.bi(0,r,q,p-r+1,o-q+1)
for(s=n.a;n.E();)s.ah(c)
return a},
oC(a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=b2<16384,a5=a8>b0?b0:a8
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
A.dP(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.dP(a,a6[b],q)
a2=q[0]
a3=q[1]
A.dP(a0,a2,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[e]=a
a6[d]=q[1]
A.dP(a1,a3,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[c]=a
a6[b]=q[1]}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.dQ(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.dQ(a,a6[b],q)
a2=q[0]
a3=q[1]
A.dQ(a0,a2,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[e]=a
a6[d]=q[1]
A.dQ(a1,a3,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[c]=a
a6[b]=q[1]}}if(i){c=e+m
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.dP(a,a6[c],q)
a0=q[0]
a=q[1]
a6.$flags&2&&A.b(a6)
a6[c]=a}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.dQ(a,a6[c],q)
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
A.dP(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.b(a6)
a6[d]=i}else{if(!(e>=0&&e<p))return A.a(a6,e)
i=a6[e]
if(!(d>=0&&d<p))return A.a(a6,d)
A.dQ(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.b(a6)
a6[d]=i}a6.$flags&2&&A.b(a6)
if(!(e>=0&&e<p))return A.a(a6,e)
a6[e]=a0}}r=s>>>1}},
dP(a,b,c){var s,r,q,p,o=$.ar()
o.$flags&2&&A.b(o)
o[0]=a
s=$.aA()
if(0>=s.length)return A.a(s,0)
r=s[0]
o[0]=b
q=s[0]
p=r+(q&1)+B.a.j(q,1)
B.c.h(c,0,p)
B.c.h(c,1,p-q)},
dQ(a,b,c){var s=a-B.a.j(b,1)&65535
B.c.h(c,1,s)
B.c.h(c,0,b+s-32768&65535)},
rT(a){var s,r,q,p,o,n,m,l,k=null,j=a.toLowerCase()
if(B.m.bn(j,".jpg")||B.m.bn(j,".jpeg")){s=new Uint8Array(64)
r=new Uint8Array(64)
q=new Float32Array(64)
p=new Float32Array(64)
o=A.F(65535,k,!1,t.T)
n=t.I
m=A.F(65535,k,!1,n)
l=A.F(64,k,!1,n)
n=A.F(64,k,!1,n)
s=new A.iS(s,r,q,p,o,m,l,n,new Int32Array(2048))
s.e=s.d7(B.ch,B.ag)
s.f=s.d7(B.bP,B.ag)
r=t.d
s.r=r.a(s.d7(B.br,B.bC))
s.w=r.a(s.d7(B.bH,B.bZ))
s.jA()
s.jD()
s.hJ(100)
return s}if(B.m.bn(j,".png"))return A.p9()
if(B.m.bn(j,".tga"))return new A.jp()
if(B.m.bn(j,".gif"))return new A.iz()
if(B.m.bn(j,".tif")||B.m.bn(j,".tiff"))return new A.js()
if(B.m.bn(j,".bmp"))return new A.ii()
if(B.m.bn(j,".ico"))return new A.fK()
if(B.m.bn(j,".cur"))return new A.fK()
if(B.m.bn(j,".pvr"))return new A.ji()
if(B.m.bn(j,".webp"))return new A.jN()
return k},
rS(a){var s,r,q,p,o,n,m,l,k,j,i,h=null,g=new A.h7()
if(g.bz(a))return g
s=new A.hm(A.mD())
if(s.bz(a))return s
r=new A.iy()
r.f=A.v(a,!1,h,0)
r.a=new A.dU(A.j([],t.c))
if(r.f6())return r
q=new A.jM()
if(q.bz(a))return q
p=new A.jr()
if(p.ft(A.v(a,!1,h,0))!=null)return p
if(A.mV(a).c===943870035)return new A.jd()
if(A.oB(a))return new A.is()
o=new A.fl(!1)
if(o.bz(a))return o
n=new A.ja(A.j([],t.s))
if(n.bz(a))return n
m=new A.jo()
l=A.v(a,!1,h,0)
k=m.a=new A.eK(B.az)
k.cm(l)
if(k.hk())return m
j=new A.iC()
k=A.v(a,!1,h,0)
j.a=k
k=A.mr(k)
j.b=k
if(k!=null)return j
i=new A.jh()
if(i.b7(a)!=null)return i
return h},
nD(a){var s=A.rS(a)
return s==null?null:s.b9(a,null)},
rP(a,b){var s=A.rT(a)
if(s==null)return null
return s.bH(b)},
qd(a,b,c,d,e,f){A.qa(f,a,b,c,d,e,!0,f)},
qe(a,b,c,d,e,f){A.qb(f,a,b,c,d,e,!0,f)},
qc(a,b,c,d,e,f){A.q9(f,a,b,c,d,e,!0,f)},
dt(a,b,c,d,e){var s,r,q
for(s=0;s<d;++s){r=J.d(a.a,a.d+s)
q=J.d(b.a,b.d+s)
J.x(c.a,c.d+s,r+q)}},
qa(a,b,c,d,e,f,g,h){var s,r,q=null,p=e*d,o=e+f,n=A.v(a,!1,q,p),m=A.v(a,!1,q,p),l=A.p(m,q,0)
if(e===0){m.h(0,0,J.d(n.a,n.d))
A.dt(A.p(n,q,1),l,A.p(m,q,1),b-1,!0)
l.d+=d
n.d+=d
m.d+=d
e=1}for(s=-d,r=b-1;e<o;){A.dt(n,A.p(l,q,s),m,1,!0)
A.dt(A.p(n,q,1),l,A.p(m,q,1),r,!0);++e
l.d+=d
n.d+=d
m.d+=d}},
qb(a,b,c,d,e,f,g,h){var s=null,r=e*d,q=e+f,p=A.v(a,!1,s,r),o=A.v(h,!1,s,r),n=A.p(o,s,0)
if(e===0){o.h(0,0,J.d(p.a,p.d))
A.dt(A.p(p,s,1),n,A.p(o,s,1),b-1,!0)
p.d+=d
o.d+=d
e=1}else n.d-=d
while(e<q){A.dt(p,n,o,b,!0);++e
n.d+=d
p.d+=d
o.d+=d}},
q9(a,b,c,d,e,f,g,h){var s,r,q,p,o,n=null,m=e*d,l=e+f,k=A.v(a,!1,n,m),j=A.v(h,!1,n,m),i=A.p(j,n,0)
if(e===0){j.h(0,0,J.d(k.a,k.d))
A.dt(A.p(k,n,1),i,A.p(j,n,1),b-1,!0)
i.d+=d
k.d+=d
j.d+=d
e=1}for(s=-d;e<l;){A.dt(k,A.p(i,n,s),j,1,!0)
for(r=1;r<b;++r){q=r-d
p=J.d(i.a,i.d+(r-1))+J.d(i.a,i.d+q)-J.d(i.a,i.d+(q-1))
if((p&4294967040)>>>0===0)o=p
else o=p<0?0:255
q=J.d(k.a,k.d+r)
J.x(j.a,j.d+r,q+o)}++e
i.d+=d
k.d+=d
j.d+=d}},
rF(a){var s="ifd0",r=A.bz(a,!1,!1)
if(!a.gbI().l(0,s).a.a8(274)||a.gbI().l(0,s).gcl()===1)return r
r.e=A.dN(a.gbI())
r.gbI().l(0,s).scl(null)
switch(a.gbI().l(0,s).gcl()){case 2:return A.i7(r)
case 3:return A.rU(r,B.dr)
case 4:return A.i7(A.i5(r,180))
case 5:return A.i7(A.i5(r,90))
case 6:return A.i5(r,90)
case 7:return A.i7(A.i5(r,-90))
case 8:return A.i5(r,-90)}return r},
rK(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=null,a0=a3==null
if(a0&&a2==null)throw A.h(A.m("Invalid size"))
a1.gaN()
if(a1.gbI().l(0,"ifd0").a.a8(274)&&a1.gbI().l(0,"ifd0").gcl()!==1)a1=A.rF(a1)
if(a2==null||a2<=0){a3.toString
a2=B.b.aS(a3*(a1.gK()/a1.gR()))}if(a0||a3<=0)a3=B.b.aS(a2*(a1.gR()/a1.gK()))
if(a3===a1.gR()&&a2===a1.gK())return A.bz(a1,!1,!1)
s=new Int32Array(a3)
for(a0=a1.a,r=a0==null,q=0;q<a3;++q){p=r?a:a0.a
p=B.a.aw(q*(p==null?0:p),a3)
if(!(q<a3))return A.a(s,q)
s[q]=p}o=new Int32Array(a2)
for(n=0;n<a2;++n){p=r?a:a0.b
p=B.a.aw(n*(p==null?0:p),a2)
if(!(n<a2))return A.a(o,n)
o[n]=p}m=a1.gaj().length
for(a0=t.g,l=a,k=0;k<m;++k){j=a1.x
if(j===$)j=a1.x=A.j([],a0)
if(!(k<j.length))return A.a(j,k)
i=j[k]
h=A.fN(i,a2,!0,a3)
r=l==null
if(!r)l.aL(h)
if(r)l=h
r=i.a
if((r==null?a:r.gN())!=null)for(n=0;n<a2;++n){if(!(n<a2))return A.a(o,n)
g=o[n]
for(q=0;q<a3;++q){if(!(q<a3))return A.a(s,q)
r=s[q]
p=i.a
r=p==null?a:B.b.i(p.aP(r,g).gT())
if(r==null)r=0
p=h.a
if(p!=null)p.aJ(q,n,r)}}else{f=i.aq(0,0)
for(n=0;n<a2;++n){if(!(n<a2))return A.a(o,n)
e=o[n]
for(q=0;q<a3;++q){if(!(q<a3))return A.a(s,q)
r=s[q]
p=i.a
if(p!=null)p.O(r,e,f)
r=f.gn()
p=f.gt()
d=f.gu()
c=f.gA()
b=h.a
if(b!=null)b.ar(q,n,r,p,d,c)}}}}l.toString
return l},
i5(a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7=null,a8=B.a.a9(b0,360)
a9.gaN()
if(B.a.a9(a8,90)===0)switch(B.a.W(a8,90)){case 1:return A.rs(a9)
case 2:return A.rq(a9)
case 3:return A.rr(a9)
default:return A.bz(a9,!1,!1)}s=a8*3.141592653589793/180
r=Math.cos(s)
q=Math.sin(s)
p=a9.gR()
o=a9.gR()
n=a9.gK()
m=a9.gK()
l=0.5*a9.gR()
k=0.5*a9.gK()
n=Math.abs(p*r)+Math.abs(n*q)
j=0.5*n
m=Math.abs(o*q)+Math.abs(m*r)
i=0.5*m
h=a9.gaj().length
for(p=t.g,g=a7,f=0;f<h;++f){e=a9.x
if(e===$)e=a9.x=A.j([],p)
if(!(f<e.length))return A.a(e,f)
d=e[f]
o=g==null
c=o?a7:g.dq()
if(c==null){b=B.b.i(n)
c=A.fN(a9,B.b.i(m),!0,b)}if(o)g=c
for(o=c.a,o=o.gH(o);o.E();){a=o.gP()
a0=a.gaZ()
a1=a.gaU()
b=a0-j
a2=a1-i
a3=l+b*r+a2*q
a4=k-b*q+a2*r
b=!1
if(a3>=0)if(a4>=0){a2=d.a
a5=a2==null
a6=a5?a7:a2.a
if(a3<(a6==null?0:a6)){b=a5?a7:a2.b
b=a4<(b==null?0:b)}}if(b)c.c8(a0,a1,d.hA(a3,a4,B.dv))}}g.toString
return g},
rs(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gaj(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.U)(s),++p){o=s[p]
n=q==null
m=n?f:q.dq()
if(m==null){l=o.a
k=l==null
j=k?f:l.b
if(j==null)j=0
l=k?f:l.a
m=A.fN(o,l==null?0:l,!0,j)}if(n)q=m
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
n=n==null?f:n.O(h,i-g,f)
m.c8(g,h,n==null?new A.C():n);++g}++h}}q.toString
return q},
rq(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gaj(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.U)(s),++p){o=s[p]
n=o.a
m=n==null
l=m?f:n.a
k=(l==null?0:l)-1
n=m?f:n.b
j=(n==null?0:n)-1
n=q==null
i=n?f:q.dq()
if(i==null)i=A.bz(o,!0,!0)
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
m=m==null?f:m.O(k-g,n,f)
i.c8(g,h,m==null?new A.C():m);++g}++h}}q.toString
return q},
rr(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gaj(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.U)(s),++p){o=s[p]
n=a.a
n=n==null?f:n.a
m=(n==null?0:n)-1
n=q==null
l=n?f:q.dq()
if(l==null){k=o.a
j=k==null
i=j?f:k.b
if(i==null)i=0
k=j?f:k.a
l=A.fN(o,k==null?0:k,!0,i)}if(n)q=l
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
k=k==null?f:k.O(n,g,f)
l.c8(g,h,k==null?new A.C():k);++g}++h}}q.toString
return q},
ky(a){var s
a=(a&-a)>>>0
s=a!==0?31:32
if((a&65535)!==0)s-=16
if((a&16711935)!==0)s-=8
if((a&252645135)!==0)s-=4
if((a&858993459)!==0)s-=2
return(a&1431655765)!==0?s-1:s},
th(a){var s
$.m6().h(0,0,a)
s=$.o8()
if(0>=s.length)return A.a(s,0)
return s[0]},
nL(a,b,c,d){return(B.a.L(a,0,255)|B.a.L(b,0,255)<<8|B.a.L(c,0,255)<<16|B.a.L(d,0,255)<<24)>>>0},
bb(a,b,c){var s,r,q,p,o=b.gv(b),n=b.gM(),m=a.gN(),l=m==null?null:m.gM()
if(l==null)l=a.gM()
s=a.gv(a)
if(o===1)b.h(0,0,A.i4(B.b.bo(a.gv(a)>2?a.gao():a.l(0,0)),l,n))
else if(o<=s)for(r=0;r<o;++r)b.h(0,r,A.i4(a.l(0,r),l,n))
else if(s===2){q=A.i4(a.l(0,0),l,n)
if(o===3){b.h(0,0,q)
b.h(0,1,q)
b.h(0,2,q)}else{c=A.i4(a.l(0,1),l,n)
b.h(0,0,q)
b.h(0,1,q)
b.h(0,2,q)
b.h(0,3,c)}}else{for(r=0;r<s;++r)b.h(0,r,A.i4(a.l(0,r),l,n))
p=s===1?b.l(0,0):0
for(r=s;r<o;++r)b.h(0,r,r===3?c:p)}return b},
aO(a,b,c,d,e){var s,r,q=a.gN(),p=q==null?null:q.gM()
if(p==null)p=a.gM()
q=e==null
s=q?null:e.gM()
c=s==null?c:s
if(c==null)c=a.gM()
s=q?null:e.gv(e)
d=s==null?d:s
if(d==null)d=a.gv(a)
if(b==null)b=0
if(c===p&&d===a.gv(a)){if(q)return a.U()
e.ah(a)
return e}switch(c.a){case 3:if(q)r=new A.bO(new Uint8Array(d))
else r=e
return A.bb(a,r,b)
case 0:return A.bb(a,q?new A.cQ(d,0):e,b)
case 1:return A.bb(a,q?new A.cS(d,0):e,b)
case 2:if(q){q=d<3?1:2
r=new A.cU(d,new Uint8Array(q))}else r=e
return A.bb(a,r,b)
case 4:if(q)r=new A.cR(new Uint16Array(d))
else r=e
return A.bb(a,r,b)
case 5:if(q)r=new A.cT(new Uint32Array(d))
else r=e
return A.bb(a,r,b)
case 6:if(q)r=new A.cO(new Int8Array(d))
else r=e
return A.bb(a,r,b)
case 7:if(q)r=new A.cM(new Int16Array(d))
else r=e
return A.bb(a,r,b)
case 8:if(q)r=new A.cN(new Int32Array(d))
else r=e
return A.bb(a,r,b)
case 9:if(q)r=new A.cJ(new Uint16Array(d))
else r=e
return A.bb(a,r,b)
case 10:if(q)r=new A.cK(new Float32Array(d))
else r=e
return A.bb(a,r,b)
case 11:if(q)r=new A.cL(new Float64Array(d))
else r=e
return A.bb(a,r,b)}},
a_(a){return 0.299*a.gn()+0.587*a.gt()+0.114*a.gu()},
nB(a,b,c,d,e){var s=1-d/255
B.c.h(e,0,B.b.aS(255*(1-a/255)*s))
B.c.h(e,1,B.b.aS(255*(1-b/255)*s))
B.c.h(e,2,B.b.aS(255*(1-c/255)*s))},
K(a){var s,r,q,p=$.m5()
p.$flags&2&&A.b(p)
p[0]=a
p=$.o7()
if(0>=p.length)return A.a(p,0)
s=p[0]
if(a===0)return s>>>16
if($.T==null)A.Y()
r=s>>>23&511
p=$.mo.cK()
if(!(r<p.length))return A.a(p,r)
r=p[r]
if(r!==0){q=s&8388607
return r+(q+4095+(q>>>13&1)>>>13)}return A.oD(s)},
oD(a){var s,r,q=a>>>16&32768,p=(a>>>23&255)-112,o=a&8388607
if(p<=0){if(p<-10)return q
o|=8388608
s=14-p
return(q|B.a.aW(o+(B.a.V(1,s-1)-1)+(B.a.a3(o,s)&1),s))>>>0}else if(p===143)if(o===0)return q|31744
else{o=o>>>13
r=o===0?1:0
return q|o|r|31744}else{o=o+4095+(o>>>13&1)
if((o&8388608)!==0){++p
o=0}if(p>30)return q|31744
return(q|p<<10|o>>>13)>>>0}},
Y(){var s,r,q,p,o,n=$.T
if(n!=null)return n
s=new Uint32Array(65536)
$.T=J.m7(B.o.gB(s),0,null)
n=new Uint16Array(512)
$.mo.b=n
for(r=0;r<256;++r){q=(r&255)-112
if(q<=0||q>=30){n[r]=0
p=(r|256)>>>0
if(!(p<512))return A.a(n,p)
n[p]=0}else{p=q<<10>>>0
n[r]=p
o=(r|256)>>>0
if(!(o<512))return A.a(n,o)
n[o]=(p|32768)>>>0}}for(r=0;r<65536;++r)s[r]=A.oE(r)
n=$.T
n.toString
return n},
oE(a){var s,r=a>>>15&1,q=a>>>10&31,p=a&1023
if(q===0)if(p===0)return r<<31>>>0
else{while((p&1024)===0){p=p<<1;--q}++q
p&=4294966271}else if(q===31){s=r<<31
if(p===0)return(s|2139095040)>>>0
else return(s|p<<13|2139095040)>>>0}return(r<<31|q+112<<23|p<<13)>>>0},
pl(a){var s="[Matrix] "+a.a,r=a.c
if(r!=null)s+="\n"+r.D(0)
switch(a.d.a){case 0:A.bn(v.G.console).error("!!!CRITICAL!!! "+s)
break
case 1:A.bn(v.G.console).error(s)
break
case 2:A.bn(v.G.console).warn(s)
break
case 3:A.bn(v.G.console).info(s)
break
case 4:A.bn(v.G.console).debug(s)
break
case 5:A.bn(v.G.console).log(s)
break}},
t9(){return A.m_()}},B={}
var w=[A,J,B]
var $={}
A.ld.prototype={}
J.fT.prototype={
Y(a,b){return a===b},
gJ(a){return A.eB(a)},
D(a){return"Instance of '"+A.hq(a)+"'"},
gaT(a){return A.bM(A.lO(this))}}
J.h6.prototype={
D(a){return String(a)},
gJ(a){return a?519018:218159},
gaT(a){return A.bM(t.y)},
$iN:1,
$ib0:1}
J.e6.prototype={
Y(a,b){return null==b},
D(a){return"null"},
gJ(a){return 0},
$iN:1}
J.e9.prototype={$ia0:1}
J.bW.prototype={
gJ(a){return 0},
D(a){return String(a)}}
J.hl.prototype={}
J.dr.prototype={}
J.bA.prototype={
D(a){var s=a[$.nO()]
if(s==null)s=a[$.m2()]
if(s==null)return this.hR(a)
return"JavaScript function for "+J.dH(s)},
$ibv:1}
J.da.prototype={
gJ(a){return 0},
D(a){return String(a)}}
J.db.prototype={
gJ(a){return 0},
D(a){return String(a)}}
J.t.prototype={
C(a,b){A.al(a).c.a(b)
a.$flags&1&&A.b(a,29)
a.push(b)},
c7(a,b){var s
a.$flags&1&&A.b(a,"removeAt",1)
s=a.length
if(b>=s)throw A.h(A.ly(b,null))
return a.splice(b,1)[0]},
fW(a,b){var s
A.al(a).q("e<1>").a(b)
a.$flags&1&&A.b(a,"addAll",2)
if(Array.isArray(b)){this.ie(a,b)
return}for(s=J.fh(b);s.E();)a.push(s.gP())},
ie(a,b){var s,r
t.gn.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.h(A.be(a))
for(r=0;r<s;++r)a.push(b[r])},
e5(a){a.$flags&1&&A.b(a,"clear","clear")
a.length=0},
cz(a,b,c){var s=A.al(a)
return new A.b6(a,s.an(c).q("1(2)").a(b),s.q("@<1>").an(c).q("b6<1,2>"))},
lg(a,b){var s,r=A.F(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.h(r,s,A.z(a[s]))
return r.join(b)},
hp(a,b){return A.dq(a,0,A.fg(b,"count",t.p),A.al(a).c)},
dz(a,b){return A.dq(a,b,null,A.al(a).c)},
bG(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
bj(a,b,c){if(b<0||b>a.length)throw A.h(A.ap(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.h(A.ap(c,b,a.length,"end",null))
if(b===c)return A.j([],A.al(a))
return A.j(a.slice(b,c),A.al(a))},
gl7(a){if(a.length>0)return a[0]
throw A.h(A.iN())},
geb(a){var s=a.length
if(s>0)return a[s-1]
throw A.h(A.iN())},
au(a,b,c,d,e){var s,r,q,p,o
A.al(a).q("e<1>").a(d)
a.$flags&2&&A.b(a,5)
A.bC(b,c,a.length)
s=c-b
if(s===0)return
A.dn(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.l3(d,e).ee(0,!1)
q=0}p=J.a5(r)
if(q+s>p.gv(r))throw A.h(A.mE())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.l(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.l(r,q+o)},
aD(a,b,c,d){var s
A.al(a).q("1?").a(d)
a.$flags&2&&A.b(a,"fillRange")
A.bC(b,c,a.length)
for(s=b;s<c;++s)a[s]=d},
hN(a,b){var s,r,q,p,o,n=A.al(a)
n.q("f(1,1)?").a(b)
a.$flags&2&&A.b(a,"sort")
s=a.length
if(s<2)return
if(s===2){r=a[0]
q=a[1]
n=b.$2(r,q)
if(typeof n!=="number")return n.hC()
if(n>0){a[0]=q
a[1]=r}return}p=0
if(n.c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.dF(b,2))
if(p>0)this.kx(a,p)},
kx(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
ci(a,b){var s
for(s=0;s<a.length;++s)if(J.c9(a[s],b))return!0
return!1},
D(a){return A.mF(a,"[","]")},
gH(a){return new J.dI(a,a.length,A.al(a).q("dI<1>"))},
gJ(a){return A.eB(a)},
gv(a){return a.length},
sv(a,b){a.$flags&1&&A.b(a,"set length","change the length of")
if(b<0)throw A.h(A.ap(b,0,null,"newLength",null))
if(b>a.length)A.al(a).c.a(null)
a.length=b},
l(a,b){if(!(b>=0&&b<a.length))throw A.h(A.kA(a,b))
return a[b]},
h(a,b,c){A.al(a).c.a(c)
a.$flags&2&&A.b(a)
if(!(b>=0&&b<a.length))throw A.h(A.kA(a,b))
a[b]=c},
hv(a,b){return new A.cB(a,b.q("cB<0>"))},
$iah:1,
$iE:1,
$ie:1,
$ir:1}
J.h4.prototype={
lF(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.hq(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.iO.prototype={}
J.dI.prototype={
gP(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.U(q)
throw A.h(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iB:1}
J.e8.prototype={
ds(a,b){var s
A.lM(b)
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gea(b)
if(this.gea(a)===s)return 0
if(this.gea(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gea(a){return a===0?1/a<0:a<0},
gem(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
i(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.h(A.aq(""+a+".toInt()"))},
be(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.h(A.aq(""+a+".ceil()"))},
bo(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.h(A.aq(""+a+".floor()"))},
aS(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.h(A.aq(""+a+".round()"))},
L(a,b,c){if(this.ds(b,c)>0)throw A.h(A.c5(b))
if(this.ds(a,b)<0)return b
if(this.ds(a,c)>0)return c
return a},
dw(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.h(A.ap(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.az(A.aq("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.m.ej("0",o)},
D(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gJ(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a9(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
if(b<0)return s-b
else return s+b},
aw(a,b){A.lM(b)
if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.fE(a,b)},
W(a,b){return(a|0)===a?a/b|0:this.fE(a,b)},
fE(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.h(A.aq("Result of truncating division is "+A.z(s)+": "+A.z(a)+" ~/ "+b))},
V(a,b){if(b<0)throw A.h(A.c5(b))
return b>31?0:a<<b>>>0},
S(a,b){return b>31?0:a<<b>>>0},
aW(a,b){var s
if(b<0)throw A.h(A.c5(b))
if(a>0)s=this.a7(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
j(a,b){var s
if(a>0)s=this.a7(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
a3(a,b){if(0>b)throw A.h(A.c5(b))
return this.a7(a,b)},
a7(a,b){return b>31?0:a>>>b},
gaT(a){return A.bM(t.q)},
$iA:1,
$ik:1}
J.d8.prototype={
gem(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
aF(a,b){var s=this.V(1,b-1)
return((a&s-1)>>>0)-((a&s)>>>0)},
gkP(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.W(q,4294967296)
s+=32}return s-Math.clz32(q)},
gaT(a){return A.bM(t.p)},
$iN:1,
$if:1}
J.e7.prototype={
gaT(a){return A.bM(t.V)},
$iN:1}
J.d9.prototype={
bn(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.es(a,r-s)},
ep(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
hQ(a,b,c){return a.substring(b,A.bC(b,c,a.length))},
es(a,b){return this.hQ(a,b,null)},
hu(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(0>=o)return A.a(p,0)
if(p.charCodeAt(0)===133){s=J.oQ(p,1)
if(s===o)return""}else s=0
r=o-1
if(!(r>=0))return A.a(p,r)
q=p.charCodeAt(r)===133?J.oR(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
ej(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.h(B.cZ)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
lh(a,b){var s=a.length,r=b.length
if(s+r>s)s-=r
return a.lastIndexOf(b,s)},
D(a){return a},
gJ(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gaT(a){return A.bM(t.N)},
gv(a){return a.length},
$iah:1,
$iN:1,
$imP:1,
$iW:1}
A.dc.prototype={
D(a){return"LateInitializationError: "+this.a}}
A.an.prototype={
gv(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s.charCodeAt(b)}}
A.jm.prototype={}
A.E.prototype={}
A.aE.prototype={
gH(a){var s=this
return new A.ci(s,s.gv(s),A.l(s).q("ci<aE.E>"))},
cz(a,b,c){var s=A.l(this)
return new A.b6(this,s.an(c).q("1(aE.E)").a(b),s.q("@<aE.E>").an(c).q("b6<1,2>"))},
lw(a,b){var s,r,q,p=this
A.l(p).q("aE.E(aE.E,aE.E)").a(b)
s=p.gv(p)
if(s===0)throw A.h(A.iN())
r=p.bG(0,0)
for(q=1;q<s;++q){r=b.$2(r,p.bG(0,q))
if(s!==p.gv(p))throw A.h(A.be(p))}return r}}
A.eJ.prototype={
gjc(){var s=J.bq(this.a),r=this.c
if(r==null||r>s)return s
return r},
gkF(){var s=J.bq(this.a),r=this.b
if(r>s)return s
return r},
gv(a){var s,r=J.bq(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
bG(a,b){var s=this,r=s.gkF()+b
if(b<0||r>=s.gjc())throw A.h(A.lc(b,s.gv(0),s,null,"index"))
return J.m9(s.a,r)},
dz(a,b){var s,r,q=this
A.dn(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.ca(q.$ti.q("ca<1>"))
return A.dq(q.a,s,r,q.$ti.c)},
ee(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.a5(n),l=m.gv(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=p.$ti.c
return b?J.h5(0,n):J.mG(0,n)}r=A.F(s,m.bG(n,o),b,p.$ti.c)
for(q=1;q<s;++q){B.c.h(r,q,m.bG(n,o+q))
if(m.gv(n)<l)throw A.h(A.be(p))}return r},
lC(a){return this.ee(0,!0)}}
A.ci.prototype={
gP(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=J.a5(q),o=p.gv(q)
if(r.b!==o)throw A.h(A.be(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.bG(q,s);++r.c
return!0},
$iB:1}
A.bB.prototype={
gH(a){var s=this.a
return new A.ed(s.gH(s),this.b,A.l(this).q("ed<1,2>"))},
gv(a){var s=this.a
return s.gv(s)}}
A.dK.prototype={$iE:1}
A.ed.prototype={
E(){var s=this,r=s.b
if(r.E()){s.a=s.c.$1(r.gP())
return!0}s.a=null
return!1},
gP(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iB:1}
A.b6.prototype={
gv(a){return J.bq(this.a)},
bG(a,b){return this.b.$1(J.m9(this.a,b))}}
A.eU.prototype={
gH(a){return new A.eV(J.fh(this.a),this.b,this.$ti.q("eV<1>"))},
cz(a,b,c){var s=this.$ti
return new A.bB(this,s.an(c).q("1(2)").a(b),s.q("@<1>").an(c).q("bB<1,2>"))}}
A.eV.prototype={
E(){var s,r
for(s=this.a,r=this.b;s.E();)if(r.$1(s.gP()))return!0
return!1},
gP(){return this.a.gP()},
$iB:1}
A.ca.prototype={
gH(a){return B.cS},
gv(a){return 0},
cz(a,b,c){this.$ti.an(c).q("1(2)").a(b)
return new A.ca(c.q("ca<0>"))}}
A.dL.prototype={
E(){return!1},
gP(){throw A.h(A.iN())},
$iB:1}
A.cB.prototype={
gH(a){return new A.eW(J.fh(this.a),this.$ti.q("eW<1>"))}}
A.eW.prototype={
E(){var s,r
for(s=this.a,r=this.$ti.c;s.E();)if(r.b(s.gP()))return!0
return!1},
gP(){return this.$ti.c.a(this.a.gP())},
$iB:1}
A.X.prototype={
sv(a,b){throw A.h(A.aq("Cannot change the length of a fixed-length list"))},
C(a,b){A.ay(a).q("X.E").a(b)
throw A.h(A.aq("Cannot add to a fixed-length list"))},
c7(a,b){throw A.h(A.aq("Cannot remove from a fixed-length list"))}}
A.bm.prototype={
h(a,b,c){A.l(this).q("bm.E").a(c)
throw A.h(A.aq("Cannot modify an unmodifiable list"))},
sv(a,b){throw A.h(A.aq("Cannot change the length of an unmodifiable list"))},
C(a,b){A.l(this).q("bm.E").a(b)
throw A.h(A.aq("Cannot add to an unmodifiable list"))},
c7(a,b){throw A.h(A.aq("Cannot remove from an unmodifiable list"))},
au(a,b,c,d,e){A.l(this).q("e<bm.E>").a(d)
throw A.h(A.aq("Cannot modify an unmodifiable list"))},
bD(a,b,c,d){return this.au(0,b,c,d,0)},
aD(a,b,c,d){A.l(this).q("bm.E?").a(d)
throw A.h(A.aq("Cannot modify an unmodifiable list"))}}
A.ds.prototype={}
A.cE.prototype={$r:"+(1,2)",$s:1}
A.cV.prototype={
D(a){return A.lg(this)},
$iaT:1}
A.bP.prototype={
gv(a){return this.b.length},
gfg(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
a8(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
l(a,b){if(!this.a8(b))return null
return this.b[this.a[b]]},
bL(a,b){var s,r,q,p
this.$ti.q("~(1,2)").a(b)
s=this.gfg()
r=this.b
for(q=s.length,p=0;p<q;++p)b.$2(s[p],r[p])},
gc5(){return new A.f0(this.gfg(),this.$ti.q("f0<1>"))}}
A.f0.prototype={
gv(a){return this.a.length},
gH(a){var s=this.a
return new A.f1(s,s.length,this.$ti.q("f1<1>"))}}
A.f1.prototype={
gP(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0},
$iB:1}
A.b3.prototype={
cF(){var s=this,r=s.$map
if(r==null){r=new A.ea(s.$ti.q("ea<1,2>"))
A.nF(s.a,r)
s.$map=r}return r},
a8(a){return this.cF().a8(a)},
l(a,b){return this.cF().l(0,b)},
bL(a,b){this.$ti.q("~(1,2)").a(b)
this.cF().bL(0,b)},
gc5(){var s=this.cF()
return new A.ch(s,A.l(s).q("ch<1>"))},
gv(a){return this.cF().a}}
A.fR.prototype={
Y(a,b){if(b==null)return!1
return b instanceof A.d7&&this.a.Y(0,b.a)&&A.lU(this)===A.lU(b)},
gJ(a){return A.j8(this.a,A.lU(this),B.C,B.C)},
D(a){var s=B.c.lg([A.bM(this.$ti.c)],", ")
return this.a.D(0)+" with "+("<"+s+">")}}
A.d7.prototype={
$2(a,b){return this.a.$1$2(a,b,this.$ti.y[0])},
$S(){return A.t5(A.kx(this.a),this.$ti)}}
A.eF.prototype={}
A.ju.prototype={
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
A.en.prototype={
D(a){return"Null check operator used on a null value"}}
A.ha.prototype={
D(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.hK.prototype={
D(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.j7.prototype={
D(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.dM.prototype={}
A.f7.prototype={
D(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iaX:1}
A.at.prototype={
D(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.nN(r==null?"unknown":r)+"'"},
$ibv:1,
glL(){return this},
$C:"$1",
$R:1,
$D:null}
A.fo.prototype={$C:"$0",$R:0}
A.fp.prototype={$C:"$2",$R:2}
A.hF.prototype={}
A.hE.prototype={
D(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.nN(s)+"'"}}
A.cH.prototype={
Y(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.cH))return!1
return this.$_target===b.$_target&&this.a===b.a},
gJ(a){return(A.i9(this.a)^A.eB(this.$_target))>>>0},
D(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.hq(this.a)+"'")}}
A.hD.prototype={
D(a){return"RuntimeError: "+this.a}}
A.b5.prototype={
gv(a){return this.a},
gc5(){return new A.ch(this,A.l(this).q("ch<1>"))},
a8(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.lb(a)},
lb(a){var s=this.d
if(s==null)return!1
return this.cU(this.f2(s,a),a)>=0},
l(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.lc(b)},
lc(a){var s,r,q=this.d
if(q==null)return null
s=this.f2(q,a)
r=this.cU(s,a)
if(r<0)return null
return s[r].b},
h(a,b,c){var s,r,q=this,p=A.l(q)
p.c.a(b)
p.y[1].a(c)
if(typeof b=="string"){s=q.b
q.ex(s==null?q.b=q.dT():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.ex(r==null?q.c=q.dT():r,b,c)}else q.le(b,c)},
le(a,b){var s,r,q,p,o=this,n=A.l(o)
n.c.a(a)
n.y[1].a(b)
s=o.d
if(s==null)s=o.d=o.dT()
r=o.du(a)
q=s[r]
if(q==null)s[r]=[o.dU(a,b)]
else{p=o.cU(q,a)
if(p>=0)q[p].b=b
else q.push(o.dU(a,b))}},
ln(a,b){var s,r,q=this,p=A.l(q)
p.c.a(a)
p.q("2()").a(b)
if(q.a8(a)){s=q.l(0,a)
return s==null?p.y[1].a(s):s}r=b.$0()
q.h(0,a,r)
return r},
cA(a,b){var s=this
if(typeof b=="string")return s.fw(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.fw(s.c,b)
else return s.ld(b)},
ld(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.du(a)
r=n[s]
q=o.cU(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.fJ(p)
if(r.length===0)delete n[s]
return p.b},
bL(a,b){var s,r,q=this
A.l(q).q("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.h(A.be(q))
s=s.c}},
ex(a,b,c){var s,r=A.l(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.dU(b,c)
else s.b=c},
fw(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.fJ(s)
delete a[b]
return s.b},
fk(){this.r=this.r+1&1073741823},
dU(a,b){var s=this,r=A.l(s),q=new A.iY(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.fk()
return q},
fJ(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.fk()},
du(a){return J.aP(a)&1073741823},
f2(a,b){return a[this.du(b)]},
cU(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.c9(a[r].a,b))return r
return-1},
D(a){return A.lg(this)},
dT(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$iiX:1}
A.iY.prototype={}
A.ch.prototype={
gv(a){return this.a.a},
gH(a){var s=this.a
return new A.Q(s,s.r,s.e,this.$ti.q("Q<1>"))}}
A.Q.prototype={
gP(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.h(A.be(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iB:1}
A.iZ.prototype={
gv(a){return this.a.a},
gH(a){var s=this.a
return new A.av(s,s.r,s.e,this.$ti.q("av<1>"))}}
A.av.prototype={
gP(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.h(A.be(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}},
$iB:1}
A.ea.prototype={
du(a){return A.rI(a)&1073741823},
cU(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.c9(a[r].a,b))return r
return-1}}
A.kM.prototype={
$1(a){return this.a(a)},
$S:19}
A.kN.prototype={
$2(a,b){return this.a(a,b)},
$S:28}
A.kO.prototype={
$1(a){return this.a(A.bK(a))},
$S:35}
A.c2.prototype={
D(a){return this.fG(!1)},
fG(a){var s,r,q,p,o,n=this.jh(),m=this.f3(),l=(a?"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
if(!(q<m.length))return A.a(m,q)
o=m[q]
l=a?l+A.mS(o):l+A.z(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
jh(){var s,r=this.$s
while($.kf.length<=r)B.c.C($.kf,null)
s=$.kf[r]
if(s==null){s=this.iy()
B.c.h($.kf,r,s)}return s},
iy(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=t.K,j=J.cg(l,k)
for(s=0;s<l;++s)j[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
B.c.h(j,q,r[s])}}j=A.dd(j,!1,k)
j.$flags=3
return j}}
A.dA.prototype={
f3(){return[this.a,this.b]},
Y(a,b){if(b==null)return!1
return b instanceof A.dA&&this.$s===b.$s&&J.c9(this.a,b.a)&&J.c9(this.b,b.b)},
gJ(a){return A.j8(this.$s,this.a,this.b,B.C)}}
A.k0.prototype={
cK(){var s=this.b
if(s===this)throw A.h(A.iU(this.a))
return s}}
A.cj.prototype={
gcV(a){return a.byteLength},
gaT(a){return B.lN},
cN(a,b,c){A.aM(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
h4(a){return this.cN(a,0,null)},
h1(a,b,c){A.aM(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
dr(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
h2(a){return this.dr(a,0,null)},
h_(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,2)
return new Int16Array(a,b,c)},
h3(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
h0(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Int32Array(a,b,c)},
fZ(a,b,c){A.aM(a,b,c)
c=B.a.W(a.byteLength-b,4)
return new Float32Array(a,b,c)},
$iN:1,
$icj:1,
$ifm:1}
A.ej.prototype={
gB(a){if(((a.$flags|0)&2)!==0)return new A.i_(a.buffer)
else return a.buffer},
jF(a,b,c,d){var s=A.ap(b,0,c,d,null)
throw A.h(s)},
eK(a,b,c,d){if(b>>>0!==b||b>c)this.jF(a,b,c,d)},
$ia1:1}
A.i_.prototype={
gcV(a){return this.a.byteLength},
cN(a,b,c){var s=A.p8(this.a,b,c)
s.$flags=3
return s},
h4(a){return this.cN(0,0,null)},
h1(a,b,c){var s=A.p2(this.a,b,c)
s.$flags=3
return s},
dr(a,b,c){var s=A.p4(this.a,b,c)
s.$flags=3
return s},
h2(a){return this.dr(0,0,null)},
h_(a,b,c){var s=A.p_(this.a,b,c)
s.$flags=3
return s},
h3(a,b,c){var s=A.p6(this.a,b,c)
s.$flags=3
return s},
h0(a,b,c){var s=A.p1(this.a,b,c)
s.$flags=3
return s},
fZ(a,b,c){var s=A.oZ(this.a,b,c)
s.$flags=3
return s},
$ifm:1}
A.he.prototype={
gaT(a){return B.lO},
$iN:1,
$iik:1}
A.aj.prototype={
gv(a){return a.length},
fC(a,b,c,d,e){var s,r,q=a.length
this.eK(a,b,q,"start")
this.eK(a,c,q,"end")
if(b>c)throw A.h(A.ap(b,0,c,null,null))
s=c-b
if(e<0)throw A.h(A.br(e,null))
r=d.length
if(r-e<s)throw A.h(A.lA("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iah:1,
$iaJ:1}
A.bX.prototype={
l(a,b){A.bL(b,a,a.length)
return a[b]},
h(a,b,c){A.i1(c)
a.$flags&2&&A.b(a)
A.bL(b,a,a.length)
a[b]=c},
au(a,b,c,d,e){t.bM.a(d)
a.$flags&2&&A.b(a,5)
if(t.d4.b(d)){this.fC(a,b,c,d,e)
return}this.eu(a,b,c,d,e)},
bD(a,b,c,d){return this.au(a,b,c,d,0)},
$iE:1,
$ie:1,
$ir:1}
A.aK.prototype={
h(a,b,c){A.o(c)
a.$flags&2&&A.b(a)
A.bL(b,a,a.length)
a[b]=c},
au(a,b,c,d,e){t.hb.a(d)
a.$flags&2&&A.b(a,5)
if(t.bc.b(d)){this.fC(a,b,c,d,e)
return}this.eu(a,b,c,d,e)},
bD(a,b,c,d){return this.au(a,b,c,d,0)},
$iE:1,
$ie:1,
$ir:1}
A.ee.prototype={
gaT(a){return B.lP},
bj(a,b,c){return new Float32Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$iiv:1}
A.ef.prototype={
gaT(a){return B.lQ},
bj(a,b,c){return new Float64Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$iiw:1}
A.eg.prototype={
gaT(a){return B.lR},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Int16Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$ifS:1}
A.eh.prototype={
gaT(a){return B.lS},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Int32Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$ie2:1}
A.ei.prototype={
gaT(a){return B.lT},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Int8Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$iiM:1}
A.ek.prototype={
gaT(a){return B.lV},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Uint16Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$ijw:1}
A.el.prototype={
gaT(a){return B.lW},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Uint32Array(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$ibF:1}
A.em.prototype={
gaT(a){return B.lX},
gv(a){return a.length},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Uint8ClampedArray(a.subarray(b,A.ba(b,c,a.length)))},
$iN:1,
$ijx:1}
A.ck.prototype={
gaT(a){return B.lY},
gv(a){return a.length},
l(a,b){A.bL(b,a,a.length)
return a[b]},
bj(a,b,c){return new Uint8Array(a.subarray(b,A.ba(b,c,a.length)))},
hO(a,b){return this.bj(a,b,null)},
$iN:1,
$ick:1,
$ibG:1}
A.f2.prototype={}
A.f3.prototype={}
A.f4.prototype={}
A.f5.prototype={}
A.b9.prototype={
q(a){return A.fb(v.typeUniverse,this,a)},
an(a){return A.nh(v.typeUniverse,this,a)}}
A.hV.prototype={}
A.hZ.prototype={
D(a){return A.ax(this.a,null)}}
A.hT.prototype={
D(a){return this.a}}
A.dB.prototype={$ibl:1}
A.jX.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:12}
A.jW.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:25}
A.jY.prototype={
$0(){this.a.$0()},
$S:13}
A.jZ.prototype={
$0(){this.a.$0()},
$S:13}
A.ki.prototype={
ic(a,b){if(self.setTimeout!=null)self.setTimeout(A.dF(new A.kj(this,b),0),a)
else throw A.h(A.aq("`setTimeout()` not found."))}}
A.kj.prototype={
$0(){this.b.$0()},
$S:2}
A.hQ.prototype={
e6(a){var s,r=this,q=r.$ti
q.q("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.eD(a)
else{s=r.a
if(q.q("cc<1>").b(a))s.eJ(a)
else s.eN(a)}},
e7(a,b){var s=this.a
if(this.b)s.dF(new A.aQ(a,b))
else s.dC(new A.aQ(a,b))}}
A.ks.prototype={
$1(a){return this.a.$2(0,a)},
$S:6}
A.kt.prototype={
$2(a,b){this.a.$2(1,new A.dM(a,t.l.a(b)))},
$S:37}
A.kw.prototype={
$2(a,b){this.a(A.o(a),b)},
$S:38}
A.aQ.prototype={
D(a){return A.z(this.a)},
$iV:1,
gcD(){return this.b}}
A.hS.prototype={
e7(a,b){var s=this.a
if((s.a&30)!==0)throw A.h(A.lA("Future already completed"))
s.dC(A.r4(a,b))},
h8(a){return this.e7(a,null)}}
A.eX.prototype={
e6(a){var s,r=this.$ti
r.q("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.h(A.lA("Future already completed"))
s.eD(r.q("1/").a(a))}}
A.cC.prototype={
lj(a){if((this.c&15)!==6)return!0
return this.b.b.ed(t.al.a(this.d),a.a,t.y,t.K)},
l9(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.lz(q,m,a.b,o,n,t.l)
else p=l.ed(t.E.a(q),m,o,n)
try{o=r.$ti.q("2/").a(p)
return o}catch(s){if(t.eK.b(A.c7(s))){if((r.c&1)!==0)throw A.h(A.br("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.h(A.br("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.ac.prototype={
hq(a,b,c){var s,r,q=this.$ti
q.an(c).q("1/(2)").a(a)
s=$.a2
if(s===B.D){if(!t.Q.b(b)&&!t.E.b(b))throw A.h(A.l5(b,"onError",u.c))}else{c.q("@<0/>").an(q.c).q("1(2)").a(a)
b=A.rm(b,s)}r=new A.ac(s,c.q("ac<0>"))
this.dB(new A.cC(r,3,a,b,q.q("@<1>").an(c).q("cC<1,2>")))
return r},
fF(a,b,c){var s,r=this.$ti
r.an(c).q("1/(2)").a(a)
s=new A.ac($.a2,c.q("ac<0>"))
this.dB(new A.cC(s,19,a,b,r.q("@<1>").an(c).q("cC<1,2>")))
return s},
kC(a){this.a=this.a&1|16
this.c=a},
d6(a){this.a=a.a&30|this.a&1
this.c=a.c},
dB(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.dB(a)
return}r.d6(s)}A.i3(null,null,r.b,t.M.a(new A.k3(r,a)))}},
fp(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.fp(a)
return}m.d6(n)}l.a=m.dk(a)
A.i3(null,null,m.b,t.M.a(new A.k7(l,m)))}},
dj(){var s=t.F.a(this.c)
this.c=null
return this.dk(s)},
dk(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
eN(a){var s,r=this
r.$ti.c.a(a)
s=r.dj()
r.a=8
r.c=a
A.dx(r,s)},
ix(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.dj()
q.d6(a)
A.dx(q,r)},
dF(a){var s=this.dj()
this.kC(a)
A.dx(this,s)},
eD(a){var s=this.$ti
s.q("1/").a(a)
if(s.q("cc<1>").b(a)){this.eJ(a)
return}this.ik(a)},
ik(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.i3(null,null,s.b,t.M.a(new A.k5(s,a)))},
eJ(a){A.lF(this.$ti.q("cc<1>").a(a),this,!1)
return},
dC(a){this.a^=2
A.i3(null,null,this.b,t.M.a(new A.k4(this,a)))},
$icc:1}
A.k3.prototype={
$0(){A.dx(this.a,this.b)},
$S:2}
A.k7.prototype={
$0(){A.dx(this.b,this.a.a)},
$S:2}
A.k6.prototype={
$0(){A.lF(this.a.a,this.b,!0)},
$S:2}
A.k5.prototype={
$0(){this.a.eN(this.b)},
$S:2}
A.k4.prototype={
$0(){this.a.dF(this.b)},
$S:2}
A.ka.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.ly(t.fO.a(q.d),t.z)}catch(p){s=A.c7(p)
r=A.bN(p)
if(k.c&&t.u.a(k.b.a.c).a===s){q=k.a
q.c=t.u.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.l6(q)
n=k.a
n.c=new A.aQ(q,o)
q=n}q.b=!0
return}if(j instanceof A.ac&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.u.a(j.c)
q.b=!0}return}if(j instanceof A.ac){m=k.b.a
l=new A.ac(m.b,m.$ti)
j.hq(new A.kb(l,m),new A.kc(l),t.x)
q=k.a
q.c=l
q.b=!1}},
$S:2}
A.kb.prototype={
$1(a){this.a.ix(this.b)},
$S:12}
A.kc.prototype={
$2(a,b){A.fd(a)
t.l.a(b)
this.a.dF(new A.aQ(a,b))},
$S:16}
A.k9.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.ed(o.q("2/(1)").a(p.d),m,o.q("2/"),n)}catch(l){s=A.c7(l)
r=A.bN(l)
q=s
p=r
if(p==null)p=A.l6(q)
o=this.a
o.c=new A.aQ(q,p)
o.b=!0}},
$S:2}
A.k8.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.u.a(l.a.a.c)
p=l.b
if(p.a.lj(s)&&p.a.e!=null){p.c=p.a.l9(s)
p.b=!1}}catch(o){r=A.c7(o)
q=A.bN(o)
p=t.u.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.l6(p)
m=l.b
m.c=new A.aQ(p,n)
p=m}p.b=!0}},
$S:2}
A.hR.prototype={}
A.hX.prototype={}
A.fc.prototype={$in4:1}
A.hW.prototype={
lA(a){var s,r,q
t.M.a(a)
try{if(B.D===$.a2){a.$0()
return}A.nv(null,null,this,a,t.x)}catch(q){s=A.c7(q)
r=A.bN(q)
A.lQ(A.fd(s),t.l.a(r))}},
kO(a){return new A.kg(this,t.M.a(a))},
ly(a,b){b.q("0()").a(a)
if($.a2===B.D)return a.$0()
return A.nv(null,null,this,a,b)},
ed(a,b,c,d){c.q("@<0>").an(d).q("1(2)").a(a)
d.a(b)
if($.a2===B.D)return a.$1(b)
return A.rp(null,null,this,a,b,c,d)},
lz(a,b,c,d,e,f){d.q("@<0>").an(e).an(f).q("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.a2===B.D)return a.$2(b,c)
return A.ro(null,null,this,a,b,c,d,e,f)},
ho(a,b,c,d){return b.q("@<0>").an(c).an(d).q("1(2,3)").a(a)}}
A.kg.prototype={
$0(){return this.a.lA(this.b)},
$S:2}
A.kv.prototype={
$0(){A.ov(this.a,this.b)},
$S:2}
A.eY.prototype={
gv(a){return this.a},
gc5(){return new A.eZ(this,this.$ti.q("eZ<1>"))},
a8(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.iz(a)},
iz(a){var s=this.d
if(s==null)return!1
return this.dO(this.eM(s,a),a)>=0},
l(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.n7(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.n7(q,b)
return r}else return this.jr(b)},
jr(a){var s,r,q=this.d
if(q==null)return null
s=this.eM(q,a)
r=this.dO(s,a)
return r<0?null:s[r+1]},
h(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.eL(s==null?m.b=A.lG():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.eL(r==null?m.c=A.lG():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.lG()
p=A.i9(b)&1073741823
o=q[p]
if(o==null){A.lH(q,p,[b,c]);++m.a
m.e=null}else{n=m.dO(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
bL(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.q("~(1,2)").a(b)
s=m.eP()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.l(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.h(A.be(m))}},
eP(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.F(i.a,null,!1,t.z)
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
eL(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.lH(a,b,c)},
eM(a,b){return a[A.i9(b)&1073741823]}}
A.dy.prototype={
dO(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.eZ.prototype={
gv(a){return this.a.a},
gH(a){var s=this.a
return new A.f_(s,s.eP(),this.$ti.q("f_<1>"))}}
A.f_.prototype={
gP(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.h(A.be(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$iB:1}
A.j_.prototype={
$2(a,b){this.a.h(0,this.b.a(a),this.c.a(b))},
$S:17}
A.H.prototype={
gH(a){return new A.ci(a,this.gv(a),A.ay(a).q("ci<H.E>"))},
bG(a,b){return this.l(a,b)},
ci(a,b){var s,r=this.gv(a)
for(s=0;s<r;++s){if(this.l(a,s)===b)return!0
if(r!==this.gv(a))throw A.h(A.be(a))}return!1},
hv(a,b){return new A.cB(a,b.q("cB<0>"))},
cz(a,b,c){var s=A.ay(a)
return new A.b6(a,s.an(c).q("1(H.E)").a(b),s.q("@<H.E>").an(c).q("b6<1,2>"))},
dz(a,b){return A.dq(a,b,null,A.ay(a).q("H.E"))},
hp(a,b){return A.dq(a,0,A.fg(b,"count",t.p),A.ay(a).q("H.E"))},
C(a,b){var s
A.ay(a).q("H.E").a(b)
s=this.gv(a)
this.sv(a,s+1)
this.h(a,s,b)},
iw(a,b,c){var s,r=this,q=r.gv(a),p=c-b
for(s=c;s<q;++s)r.h(a,s-p,r.l(a,s))
r.sv(a,q-p)},
bj(a,b,c){var s,r=this.gv(a)
A.bC(b,c,r)
A.bC(b,c,this.gv(a))
s=A.ay(a).q("H.E")
s=A.w(A.dq(a,b,c,s),s)
return s},
aD(a,b,c,d){var s
A.ay(a).q("H.E?").a(d)
A.bC(b,c,this.gv(a))
for(s=b;s<c;++s)this.h(a,s,d)},
au(a,b,c,d,e){var s,r,q,p,o
A.ay(a).q("e<H.E>").a(d)
A.bC(b,c,this.gv(a))
s=c-b
if(s===0)return
A.dn(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.l3(d,e).ee(0,!1)
r=0}p=J.a5(q)
if(r+s>p.gv(q))throw A.h(A.mE())
if(r<b)for(o=s-1;o>=0;--o)this.h(a,b+o,p.l(q,r+o))
else for(o=0;o<s;++o)this.h(a,b+o,p.l(q,r+o))},
bD(a,b,c,d){return this.au(a,b,c,d,0)},
c7(a,b){var s=this.l(a,b)
this.iw(a,b,b+1)
return s},
hE(a,b,c){A.ay(a).q("e<H.E>").a(c)
this.bD(a,b,b+c.length,c)},
D(a){return A.mF(a,"[","]")},
$iE:1,
$ie:1,
$ir:1}
A.ai.prototype={
bL(a,b){var s,r,q,p=A.l(this)
p.q("~(ai.K,ai.V)").a(b)
for(s=this.gc5(),s=s.gH(s),p=p.q("ai.V");s.E();){r=s.gP()
q=this.l(0,r)
b.$2(r,q==null?p.a(q):q)}},
gv(a){var s=this.gc5()
return s.gv(s)},
D(a){return A.lg(this)},
$iaT:1}
A.j3.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.z(a)
r.a=(r.a+=s)+": "
s=A.z(b)
r.a+=s},
$S:18}
A.ko.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:10}
A.kn.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:10}
A.kl.prototype={
cw(a){var s,r,q=a.length,p=A.bC(0,null,q),o=new Uint8Array(p)
for(s=0;s<p;++s){if(!(s<q))return A.a(a,s)
r=a.charCodeAt(s)
if((r&4294967040)!==0)throw A.h(A.l5(a,"string","Contains invalid characters."))
if(!(s<p))return A.a(o,s)
o[s]=r}return o}}
A.kk.prototype={
cw(a){var s,r,q,p
t.L.a(a)
s=a.length
r=A.bC(0,null,s)
for(q=0;q<r;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if((p&4294967040)!==0){if(!this.a)throw A.h(A.la("Invalid value in input: "+p,null,null))
return this.iB(a,0,r)}}return A.eI(a,0,r)},
iB(a,b,c){var s,r,q,p
t.L.a(a)
for(s=a.length,r=b,q="";r<c;++r){if(!(r<s))return A.a(a,r)
p=a[r]
q+=A.dh((p&4294967040)!==0?65533:p)}return q.charCodeAt(0)==0?q:q}}
A.cI.prototype={}
A.fu.prototype={}
A.fx.prototype={}
A.hb.prototype={
c3(a){var s
t.L.a(a)
s=B.dy.cw(a)
return s}}
A.iW.prototype={}
A.iV.prototype={}
A.hL.prototype={
kT(a,b){t.L.a(a)
return(b===!0?B.m_:B.lZ).cw(a)}}
A.hM.prototype={
cw(a){return new A.i0(this.a).eQ(t.L.a(a),0,null,!0)}}
A.i0.prototype={
eQ(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.bC(b,c,a.length)
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.qF(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.qE(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.dI(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.qG(o)
l.b=0
throw A.h(A.la(m,a,p+l.c))}return n},
dI(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.W(b+c,2)
r=q.dI(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.dI(a,s,c,d)}return q.kX(a,b,c,d)},
kX(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.eH(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
A:for(r=k.a;;){for(;;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.dh(f)
e.a+=p
if(d===a0)break A
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.dh(h)
e.a+=p
break
case 65:p=A.dh(h)
e.a+=p;--d
break
default:p=A.dh(h)
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
p=A.dh(a[l])
e.a+=p}else{p=A.eI(a,d,n)
e.a+=p}if(n===a0)break A
d=o}else d=o}if(a1&&g>32)if(r){c=A.dh(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.fv.prototype={
Y(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.fv)if(this.a===b.a)s=this.b===b.b
return s},
gJ(a){return A.j8(this.a,this.b,B.C,B.C)},
D(a){var s=this,r=A.os(A.ph(s)),q=A.fw(A.pf(s)),p=A.fw(A.pb(s)),o=A.fw(A.pc(s)),n=A.fw(A.pe(s)),m=A.fw(A.pg(s)),l=A.mj(A.pd(s)),k=s.b,j=k===0?"":A.mj(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"}}
A.k1.prototype={
D(a){return this.a6()}}
A.V.prototype={
gcD(){return A.pa(this)}}
A.fi.prototype={
D(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.ir(s)
return"Assertion failed"}}
A.bl.prototype={}
A.b1.prototype={
gdL(){return"Invalid argument"+(!this.a?"(s)":"")},
gdK(){return""},
D(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.z(p),n=s.gdL()+q+o
if(!s.a)return n
return n+s.gdK()+": "+A.ir(s.ge9())},
ge9(){return this.b}}
A.dm.prototype={
ge9(){return A.nm(this.b)},
gdL(){return"RangeError"},
gdK(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.z(q):""
else if(q==null)s=": Not greater than or equal to "+A.z(r)
else if(q>r)s=": Not in inclusive range "+A.z(r)+".."+A.z(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.z(r)
return s}}
A.fO.prototype={
ge9(){return A.o(this.b)},
gdL(){return"RangeError"},
gdK(){if(A.o(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gv(a){return this.f}}
A.eL.prototype={
D(a){return"Unsupported operation: "+this.a}}
A.hJ.prototype={
D(a){return"UnimplementedError: "+this.a}}
A.dp.prototype={
D(a){return"Bad state: "+this.a}}
A.fs.prototype={
D(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.ir(s)+"."}}
A.hh.prototype={
D(a){return"Out of Memory"},
gcD(){return null},
$iV:1}
A.eG.prototype={
D(a){return"Stack Overflow"},
gcD(){return null},
$iV:1}
A.k2.prototype={
D(a){return"Exception: "+this.a}}
A.ix.prototype={
D(a){var s=this.a,r=""!==s?"FormatException: "+s:"FormatException",q=this.c
return q!=null?r+(" (at offset "+A.z(q)+")"):r}}
A.e.prototype={
cz(a,b,c){var s=A.l(this)
return A.oU(this,s.an(c).q("1(e.E)").a(b),s.q("e.E"),c)},
gv(a){var s,r=this.gH(this)
for(s=0;r.E();)++s
return s},
bG(a,b){var s,r
A.dn(b,"index")
s=this.gH(this)
for(r=b;s.E();){if(r===0)return s.gP();--r}throw A.h(A.lc(b,b-r,this,null,"index"))},
D(a){return A.oP(this,"(",")")}}
A.ak.prototype={
gJ(a){return A.J.prototype.gJ.call(this,0)},
D(a){return"null"}}
A.J.prototype={$iJ:1,
Y(a,b){return this===b},
gJ(a){return A.eB(this)},
D(a){return"Instance of '"+A.hq(this)+"'"},
gaT(a){return A.t_(this)},
toString(){return this.D(this)}}
A.hY.prototype={
D(a){return""},
$iaX:1}
A.eH.prototype={
gv(a){return this.a.length},
D(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.j6.prototype={
D(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.kQ.prototype={
$1(a){var s,r,q,p
if(A.nu(a))return a
s=this.a
if(s.a8(a))return s.l(0,a)
if(t.eO.b(a)){r={}
s.h(0,a,r)
for(s=a.gc5(),s=s.gH(s);s.E();){q=s.gP()
r[q]=this.$1(a.l(0,q))}return r}else if(t.Y.b(a)){p=[]
s.h(0,a,p)
B.c.fW(p,J.og(a,this,t.z))
return p}else return a},
$S:9}
A.kS.prototype={
$1(a){return this.a.e6(this.b.q("0/?").a(a))},
$S:6}
A.kT.prototype={
$1(a){if(a==null)return this.a.h8(new A.j6(a===undefined))
return this.a.h8(a)},
$S:6}
A.kz.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.nt(a))return a
s=this.a
a.toString
if(s.a8(a))return s.l(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.az(A.ap(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.fg(!0,"isUtc",t.y)
return new A.fv(r,0,!0)}if(a instanceof RegExp)throw A.h(A.br("structured clone of RegExp",null))
if(a instanceof Promise)return A.tc(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.I(p,p)
s.h(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.am(n),p=s.gH(n);p.E();)m.push(A.nC(p.gP()))
for(l=0;l<s.gv(n);++l){k=s.l(n,l)
if(!(l<m.length))return A.a(m,l)
j=m[l]
if(k!=null)o.h(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.h(0,a,o)
h=A.o(a.length)
for(s=J.am(i),l=0;l<h;++l)o.push(this.$1(s.l(i,l)))
return o}return a},
$S:9}
A.iB.prototype={
hX(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=a.length
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
A.jU.prototype={}
A.kq.prototype={
kZ(a,b,c,d){var s,r,q,p,o,n,m=null
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
if(B.a.a9(o*256+n,31)!==0)return!1
if((n>>>5&1)!==0){a.k()
return!1}if(m!=null)b.a0(m)
s=new A.eo(new Uint8Array(32768),B.ab)
new A.iK(a,s).jy()
m=J.D(B.d.gB(s.c),s.c.byteOffset,s.b)
a.k()}if(m!=null)b.a0(m)
return!0}}
A.jV.prototype={}
A.kr.prototype={
he(a,b){var s
t.L.a(a)
s=A.mN(B.a0,32768)
this.l3(A.iL(a,B.ab,null,null),s,b,!1,null)
return s.ef()},
l3(a,b,c,d,e){var s,r,q,p,o,n,m,l,k
b.a=B.a0
s=(B.a.L(15,0,15)-8<<4|8)>>>0
b.m(s)
r=s*256
for(q=0;p=(q|0)>>>0,B.a.a9(r+p,31)!==0;)++q
b.m(p)
o=a.c
n=A.rX(a)
a.c=o
A.ot(a,6,b,15)
p=n&255
m=n>>>24&255
l=n>>>16&255
k=n>>>8&255
if(b.a===B.a0){b.m(m)
b.m(l)
b.m(k)
b.m(p)}else{b.m(p)
b.m(k)
b.m(l)
b.m(m)}}}
A.dw.prototype={
a6(){return"_DeflateFlushMode."+this.b}}
A.io.prototype={
jz(a,b){var s,r,q,p,o=this,n=!0
if(b>=9)if(b<=15)n=a>9
if(n)return!1
s=o.jt(a)
if(s==null)return!1
$.bf.b=s
n=new Uint16Array(1146)
o.p1=n
r=new Uint16Array(122)
o.p2=r
q=new Uint16Array(78)
o.p3=q
o.as=b
p=o.Q=B.a.S(1,b)
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
p.c=$.o3()
p=o.R8
p.a=r
p.c=$.o2()
p=o.RG
p.a=q
p.c=$.o1()
o.bf=o.aX=0
o.bT=8
o.fc()
o.ay=2*o.Q
B.A.aD(o.CW,0,o.cy,0)
o.k2=o.fr=o.id=0
o.fx=o.k3=2
o.cx=o.go=0
return!0},
j2(a){var s,r,q,p,o=this,n=o.x
n===$&&A.c("_pending")
if(n!==0)o.dP()
n=o.a
s=n.c
n=n.d
n===$&&A.c("_length")
r=!0
if(s>=n){n=o.k2
n===$&&A.c("_lookAhead")
if(n===0)n=a!==B.aB&&o.c!==666
else n=r}else n=r
if(n){switch($.bf.cK().e){case 0:q=o.j5(a)
break
case 1:q=o.j3(a)
break
case 2:q=o.j4(a)
break
default:q=-1
break}n=q===2
if(n||q===3)o.c=666
if(q===0||n)return 0
if(q===1){if(a===B.m3){o.aH(2,3)
o.cu(256,B.ak)
o.h5()
n=o.bT
n===$&&A.c("_lastEOBLen")
s=o.bf
s===$&&A.c("_numValidBits")
if(1+n+10-s<9){o.aH(2,3)
o.cu(256,B.ak)
o.h5()}o.bT=7}else{o.fH(0,0,!1)
if(a===B.m4){n=o.cy
n===$&&A.c("_hashSize")
s=o.CW
p=0
for(;p<n;++p){s===$&&A.c("_head")
s.$flags&2&&A.b(s)
if(!(p<s.length))return A.a(s,p)
s[p]=0}}}o.dP()}}if(a!==B.a9)return 0
return 1},
fc(){var s=this,r=s.p1
r===$&&A.c("_dynamicLengthTree")
B.A.aD(r,0,572,0)
r=s.p2
r===$&&A.c("_dynamicDistTree")
B.A.aD(r,0,60,0)
r=s.p3
r===$&&A.c("_bitLengthTree")
B.A.aD(r,0,38,0)
r=s.p1
r.$flags&2&&A.b(r)
r[512]=1
s.y2=s.ck=s.aR=s.bK=0},
dZ(a,b){var s,r,q,p,o,n,m=this.ry
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
o=A.mk(a,o,m[r],p)}else o=!1
if(o)++r
if(!(r>=0&&r<573))return A.a(m,r)
if(A.mk(a,s,m[r],p))break
o=m[r]
q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=o
n=r<<1>>>0
b=r
r=n}q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=s},
fA(a,b){var s,r,q,p,o,n,m,l,k,j,i,h="_bitLengthTree",g=a.length
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
io(){var s,r,q=this,p=q.p1
p===$&&A.c("_dynamicLengthTree")
s=q.p4.b
s===$&&A.c("maxCode")
q.fA(p,s)
s=q.p2
s===$&&A.c("_dynamicDistTree")
p=q.R8.b
p===$&&A.c("maxCode")
q.fA(s,p)
q.RG.dD(q)
for(p=q.p3,r=18;r>=3;--r){p===$&&A.c("_bitLengthTree")
s=B.at[r]*2+1
if(!(s<78))return A.a(p,s)
if(p[s]!==0)break}p=q.aR
p===$&&A.c("_optimalLen")
q.aR=p+(3*(r+1)+5+5+4)
return r},
kB(a,b,c){var s,r,q,p,o=this
o.aH(a-257,5)
s=b-1
o.aH(s,5)
o.aH(c-4,4)
for(r=0;r<c;++r){q=o.p3
q===$&&A.c("_bitLengthTree")
if(!(r<19))return A.a(B.at,r)
p=B.at[r]*2+1
if(!(p<78))return A.a(q,p)
o.aH(q[p],3)}q=o.p1
q===$&&A.c("_dynamicLengthTree")
o.fB(q,a-1)
q=o.p2
q===$&&A.c("_dynamicDistTree")
o.fB(q,s)},
fB(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_bitLengthTree",d=a.length
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
f.aH(g&65535,h[i]&65535)}while(--m,m!==0)}else if(s!==0){if(s!==n){l=f.p3
l===$&&A.c(e)
p.a(l)
i=s*2
if(!(i<78))return A.a(l,i)
h=l[i];++i
if(!(i<78))return A.a(l,i)
f.aH(h&65535,l[i]&65535);--m}l=f.p3
l===$&&A.c(e)
p.a(l)
f.aH(l[32]&65535,l[33]&65535)
f.aH(m-3,2)}else{l=f.p3
if(m<=10){l===$&&A.c(e)
p.a(l)
f.aH(l[34]&65535,l[35]&65535)
f.aH(m-3,3)}else{l===$&&A.c(e)
p.a(l)
f.aH(l[36]&65535,l[37]&65535)
f.aH(m-11,7)}}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
k8(a,b,c){var s,r,q=this
if(c===0)return
s=q.f
s===$&&A.c("_pendingBuffer")
r=q.x
r===$&&A.c("_pending")
B.d.au(s,r,r+c,a,b)
q.x=q.x+c},
bk(a){var s,r=this.f
r===$&&A.c("_pendingBuffer")
s=this.x
s===$&&A.c("_pending")
this.x=s+1
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a},
cu(a,b){var s,r,q
t.L.a(b)
s=a*2
r=b.length
if(!(s<r))return A.a(b,s)
q=b[s];++s
if(!(s<r))return A.a(b,s)
this.aH(q&65535,b[s]&65535)},
aH(a,b){var s,r=this,q="_bitBuffer",p=r.bf
p===$&&A.c("_numValidBits")
s=r.aX
if(p>16-b){s===$&&A.c(q)
p=r.aX=(s|B.a.V(a,p)&65535)>>>0
r.bk(p)
r.bk(A.aG(p,8))
r.aX=A.aG(a,16-r.bf)
r.bf=r.bf+(b-16)}else{s===$&&A.c(q)
r.aX=(s|B.a.V(a,p)&65535)>>>0
r.bf=p+b}},
cM(a,b){var s,r,q,p,o,n=this,m="_dynamicLengthTree",l="_matches",k="_dynamicDistTree",j=n.f
j===$&&A.c("_pendingBuffer")
s=n.bJ
s===$&&A.c("_dbuf")
r=n.y2
r===$&&A.c("_lastLit")
r=s+r*2
s=A.aG(a,8)
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
j[s]=r+1}else{j=n.ck
j===$&&A.c(l)
n.ck=j+1
j=n.p1
j===$&&A.c(m)
if(!(b>=0&&b<256))return A.a(B.aT,b)
s=(B.aT[b]+256+1)*2
if(!(s<1146))return A.a(j,s)
r=j[s]
j.$flags&2&&A.b(j)
j[s]=r+1
r=n.p2
r===$&&A.c(k)
s=A.n8(a-1)*2
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
p+=r[q]*(5+B.a2[o])}p=A.aG(p,3)
r=n.ck
r===$&&A.c(l)
q=n.y2
if(r<q/2&&p<(j-s)/2)return!0
j=q}s=n.y1
s===$&&A.c("_litBufferSize")
return j===s-1},
eO(a,b){var s,r,q,p,o,n,m,l,k=this,j=t.L
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
if(o===0)k.cu(n,a)
else{m=B.aT[n]
k.cu(m+256+1,a)
if(!(m<29))return A.a(B.aO,m)
l=B.aO[m]
if(l!==0)k.aH(n-B.dY[m],l);--o
m=A.n8(o)
k.cu(m,b)
if(!(m<30))return A.a(B.a2,m)
l=B.a2[m]
if(l!==0)k.aH(o-B.f3[m],l)}}while(s<k.y2)}k.cu(256,a)
if(513>=a.length)return A.a(a,513)
k.bT=a[513]},
hF(){var s,r,q,p,o,n="_dynamicLengthTree"
for(s=this.p1,r=0,q=0;r<7;){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}for(o=0;r<128;){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
o+=s[p];++r}while(r<256){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}this.y=q>A.aG(o,2)?0:1},
h5(){var s=this,r="_bitBuffer",q=s.bf
q===$&&A.c("_numValidBits")
if(q===16){q=s.aX
q===$&&A.c(r)
s.bk(q)
s.bk(A.aG(q,8))
s.bf=s.aX=0}else if(q>=8){q=s.aX
q===$&&A.c(r)
s.bk(q)
s.aX=A.aG(s.aX,8)
s.bf=s.bf-8}},
eE(){var s=this,r="_bitBuffer",q=s.bf
q===$&&A.c("_numValidBits")
if(q>8){q=s.aX
q===$&&A.c(r)
s.bk(q)
s.bk(A.aG(q,8))}else if(q>0){q=s.aX
q===$&&A.c(r)
s.bk(q)}s.bf=s.aX=0},
c0(a){var s,r,q,p,o,n=this,m=n.fr
m===$&&A.c("_blockStart")
if(m>=0)s=m
else s=-1
r=n.id
r===$&&A.c("_strStart")
m=r-m
r=n.k4
r===$&&A.c("_level")
if(r>0){if(n.y===2)n.hF()
n.p4.dD(n)
n.R8.dD(n)
q=n.io()
r=n.aR
r===$&&A.c("_optimalLen")
p=A.aG(r+3+7,3)
r=n.bK
r===$&&A.c("_staticLen")
o=A.aG(r+3+7,3)
if(o<=p)p=o}else{o=m+5
p=o
q=0}if(m+4<=p&&s!==-1)n.fH(s,m,a)
else if(o===p){n.aH(2+(a?1:0),3)
n.eO(B.ak,B.bL)}else{n.aH(4+(a?1:0),3)
m=n.p4.b
m===$&&A.c("maxCode")
s=n.R8.b
s===$&&A.c("maxCode")
n.kB(m+1,s+1,q+1)
s=n.p1
s===$&&A.c("_dynamicLengthTree")
m=n.p2
m===$&&A.c("_dynamicDistTree")
n.eO(s,m)}n.fc()
if(a)n.eE()
n.fr=n.id
n.dP()},
j5(a){var s,r,q,p,o,n=this,m=n.r
m===$&&A.c("_pendingBufferSize")
s=m-5
s=65535>s?s:65535
for(m=a===B.aB;;){r=n.k2
r===$&&A.c("_lookAhead")
if(r<=1){n.dN()
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
n.c0(!1)}r=n.id
q=n.fr
o=n.Q
o===$&&A.c("_windowSize")
if(r-q>=o-262)n.c0(!1)}m=a===B.a9
n.c0(m)
return m?3:1},
fH(a,b,c){var s,r=this
r.aH(c?1:0,3)
r.eE()
r.bT=8
r.bk(b)
r.bk(A.aG(b,8))
s=(~b>>>0)+65536&65535
r.bk(s)
r.bk(A.aG(s,8))
s=r.ax
s===$&&A.c("_window")
r.k8(s,a,b)},
dN(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_windowSize",f=h.a
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
B.d.au(r,0,s,r,s)
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
l=h.kb(s,h.id+h.k2,p)
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
j3(a){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_insertHash",f="_hashShift",e="_window",d="_strStart",c="_hashMask",b="_windowMask"
for(s=a===B.aB,r=$.bf.a,q=0;;){p=h.k2
p===$&&A.c("_lookAhead")
if(p<262){h.dN()
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
if(p!==2)h.fx=h.fj(q)}p=h.fx
p===$&&A.c("_matchLength")
o=h.id
if(p>=3){o===$&&A.c(d)
j=h.cM(o-h.k1,p-3)
p=h.k2
o=h.fx
p-=o
h.k2=p
n=$.bf.b
if(n===$.bf)A.az(A.iU(r))
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
j=h.cM(0,p[o]&255)
h.k2=h.k2-1
h.id=h.id+1}if(j)h.c0(!1)}s=a===B.a9
h.c0(s)
return s?3:1},
j4(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_insertHash",e="_hashShift",d="_window",c="_strStart",b="_hashMask",a="_windowMask",a0="_matchAvailable"
for(s=a1===B.aB,r=$.bf.a,q=0;;){p=g.k2
p===$&&A.c("_lookAhead")
if(p<262){g.dN()
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
if(q!==0){n=$.bf.b
if(n===$.bf)A.az(A.iU(r))
if(p<n.b){p=g.id
p===$&&A.c(c)
o=g.Q
o===$&&A.c("_windowSize")
o=(p-q&65535)<=o-262
p=o}else p=o}else p=o
o=2
if(p){p=g.ok
p===$&&A.c("_strategy")
if(p!==2){p=g.fj(q)
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
i=g.cM(p-1-g.fy,o-3)
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
if(i)g.c0(!1)}else{p=g.go
p===$&&A.c(a0)
if(p!==0){p=g.ax
p===$&&A.c(d)
o=g.id
o===$&&A.c(c);--o
if(!(o>=0&&o<p.length))return A.a(p,o)
if(g.cM(0,p[o]&255))g.c0(!1)
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
g.cM(0,s[r]&255)
g.go=0}s=a1===B.a9
g.c0(s)
return s?3:1},
fj(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=$.bf.cK().d,a=c.id
a===$&&A.c("_strStart")
s=c.k3
s===$&&A.c("_prevLength")
r=c.Q
r===$&&A.c("_windowSize")
r-=262
q=a>r?a-r:0
p=$.bf.cK().c
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
if(c.k3>=$.bf.cK().a)b=b>>>2
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
kb(a,b,c){var s,r,q,p,o,n,m=this
if(c!==0){s=m.a
r=s.c
s=s.d
s===$&&A.c("_length")
s=r>=s}else s=!0
if(s)return 0
q=m.a.ai(c)
p=q.gv(0)
if(p===0)return 0
o=q.a4()
n=o.length
if(p>n)p=n
B.d.bD(a,b,b+p,o)
m.e+=p
m.d=A.bo(o,m.d)
return p},
dP(){var s,r=this,q=r.x
q===$&&A.c("_pending")
s=r.f
s===$&&A.c("_pendingBuffer")
r.b.hx(s,q)
s=r.w
s===$&&A.c("_pendingOut")
r.w=s+q
q=r.x-q
r.x=q
if(q===0)r.w=0},
jt(a){switch(a){case 0:return new A.aZ(0,0,0,0,0)
case 1:return new A.aZ(4,4,8,4,1)
case 2:return new A.aZ(4,5,16,8,1)
case 3:return new A.aZ(4,6,32,32,1)
case 4:return new A.aZ(4,4,16,16,2)
case 5:return new A.aZ(8,16,32,32,2)
case 6:return new A.aZ(8,16,128,128,2)
case 7:return new A.aZ(8,32,128,256,2)
case 8:return new A.aZ(32,128,258,1024,2)
case 9:return new A.aZ(32,258,258,4096,2)}return null}}
A.aZ.prototype={}
A.kd.prototype={
jq(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3="_optimalLen",a4=a2.a
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
e=a5.aR
e===$&&A.c(a3)
a5.aR=e+a*(m+b)
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
if(j!==m){e=a5.aR
e===$&&A.c(a3)
if(!(n>=0&&n<i))return A.a(a4,n)
a5.aR=e+(m-j)*a4[n]
a4.$flags&2&&A.b(a4)
a4[k]=m}--f}}},
dD(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.a
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
f=a1.aR
f===$&&A.c("_optimalLen")
a1.aR=f-1
if(i){f=a1.bK
f===$&&A.c("_staticLen");++h
if(!(h<r.length))return A.a(r,h)
a1.bK=f-r[h]}}a.b=j
for(k=B.a.W(h,2);k>=1;--k)a1.dZ(a0,k)
g=q
do{k=p[1]
i=a1.to--
if(!(i>=0&&i<573))return A.a(p,i)
i=p[i]
o&2&&A.b(p)
p[1]=i
a1.dZ(a0,1)
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
a1.dZ(a0,1)
if(a1.to>=2){g=b
continue}else break}while(!0)
s=--a1.x1
o=p[1]
if(!(s>=0&&s<573))return A.a(p,s)
p[s]=o
a.jq(a1)
A.qj(a0,j,a1.rx)}}
A.kh.prototype={}
A.iK.prototype={
gbF(){var s=this.a
if(s==null)return s
s.d===$&&A.c("_length")
return s},
jy(){var s,r,q=this
q.e=q.d=0
if(q.gbF()==null)return
for(;;){s=q.gbF()
r=s.c
s=s.d
s===$&&A.c("_length")
if(!(r<s))break
if(!q.jN())return}},
jN(){var s,r,q,p=this,o=p.gbF()
if(o!=null){s=o.c
r=o.d
r===$&&A.c("_length")
r=s>=r
s=r}else s=!0
if(s)return!1
q=p.bl(3)
switch(B.a.j(q,1)){case 0:if(p.jX()===-1)return!1
break
case 1:if(p.eV($.nQ(),$.nP())===-1)return!1
break
case 2:if(p.jO()===-1)return!1
break
default:return!1}return(q&1)===0},
bl(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.e,s<a){s=o.gbF()
r=s.c
s=s.d
s===$&&A.c("_length")
if(r>=s)return-1
s=o.gbF()
r=s.b
r.toString
s=s.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
q=r[s]
s=o.d
r=o.e
o.d=(s|B.a.V(q,r))>>>0
o.e=r+8}r=o.d
p=B.a.S(1,a)
o.d=B.a.a7(r,a)
o.e=s-a
return(r&p-1)>>>0},
e0(a){var s,r,q,p,o,n,m,l=this,k=a.a
k===$&&A.c("table")
s=a.b
while(r=l.e,r<s){r=l.gbF()
q=r.c
r=r.d
r===$&&A.c("_length")
if(q>=r)return-1
r=l.gbF()
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
l.d=B.a.a7(q,m)
l.e=r-m
return n&65535},
jX(){var s,r,q=this
q.e=q.d=0
s=q.bl(16)
r=q.bl(16)
if(s!==0&&s!==(r^65535)>>>0)return-1
if(s>q.gbF().gv(0))return-1
q.c.lK(q.gbF().ai(s))
return 0},
jO(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.bl(5)
if(h===-1)return-1
h+=257
if(h>288)return-1
s=i.bl(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=i.bl(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=i.bl(3)
if(o===-1)return-1
n=B.at[p]
if(!(n<19))return A.a(q,n)
q[n]=o}m=A.fG(q)
n=h+s
l=new Uint8Array(n)
k=J.D(B.d.gB(l),0,h)
j=J.D(B.d.gB(l),h,s)
if(i.iD(n,m,l)===-1)return-1
return i.eV(A.fG(k),A.fG(j))},
eV(a,b){var s,r,q,p,o,n,m,l,k=this
for(s=k.c;;){r=k.e0(a)
if(r<0||r>285)return-1
if(r===256)break
if(r<256){s.m(r&255)
continue}q=r-257
if(!(q>=0&&q<29))return A.a(B.c6,q)
p=B.c6[q]+k.bl(B.kO[q])
o=k.e0(b)
if(o<0||o>29)return-1
if(!(o>=0&&o<30))return A.a(B.c7,o)
n=B.c7[o]+k.bl(B.a2[o])
for(m=-n;p>n;){s.a0(s.am(m))
p-=n}if(p===n)s.a0(s.am(m))
else s.a0(s.er(m,p-n))}while(s=k.e,s>=8){k.e=s-8
s=k.gbF()
m=--s.c
l=s.d
l===$&&A.c("_length")
s.c=B.a.L(m,0,l)}return 0},
iD(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=0,r=0;r<a;){q=k.e0(b)
if(q===-1)return-1
p=0
switch(q){case 16:o=k.bl(2)
if(o===-1)return-1
o+=3
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=s}break
case 17:o=k.bl(3)
if(o===-1)return-1
o+=3
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
case 18:o=k.bl(7)
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
A.jT.prototype={
c4(a){var s
t.L.a(a)
s=A.mN(B.ab,32768)
B.d0.kZ(A.iL(a,B.a0,null,null),s,!1,!1)
return s.ef()}}
A.fn.prototype={
a6(){return"ByteOrder."+this.b}}
A.fP.prototype={
gv(a){var s=this.b
return s==null?0:s.length-this.c},
hP(a,b){var s=this.b
if(s==null)return A.iL(A.j([],t.t),B.ab,null,null)
return A.iL(s,this.a,a,b)},
G(){var s,r=this.b
r.toString
s=this.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
a4(){var s,r,q,p=this,o=p.b
if(o==null)return new Uint8Array(0)
s=p.gv(0)
r=p.c
q=o.length
if(r+s>q)s=q-r
return J.D(B.d.gB(o),p.b.byteOffset+p.c,s)}}
A.fQ.prototype={
k(){var s=this,r=s.G(),q=s.G(),p=s.G(),o=s.G()
if(s.a===B.a0)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
ai(a){var s=this,r=s.hP(a,s.c)
s.c=s.c+r.gv(0)
return r}}
A.eo.prototype={
ef(){return J.D(B.d.gB(this.c),this.c.byteOffset,this.b)},
m(a){var s,r,q=this
if(q.b===q.c.length)q.jL()
s=q.c
r=q.b++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
hx(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=a.length
while(s=o.b,r=s+b,q=o.c,p=q.length,r>p)o.dV(r-p)
B.d.bD(q,s,r,a)
o.b+=b},
a0(a){return this.hx(a,null)},
lK(a){var s,r,q,p,o,n,m=this
for(;;){s=m.b
r=a.b
q=r==null
p=q?0:r.length-a.c
o=m.c
n=o.length
if(!(s+p>n))break
m.dV(s+(q?0:r.length-a.c)-n)}if(!q)B.d.au(o,s,s+a.gv(0),r,a.c)
m.b=m.b+a.gv(0)},
er(a,b){var s=this
if(a<0)a=s.b+a
if(b==null)b=s.b
else if(b<0)b=s.b+b
return J.D(B.d.gB(s.c),s.c.byteOffset+a,b-a)},
am(a){return this.er(a,null)},
dV(a){var s=a!=null?a>32768?a:32768:32768,r=this.c,q=r.length,p=new Uint8Array((q+s)*2)
B.d.bD(p,0,q,r)
this.c=p},
jL(){return this.dV(null)},
gv(a){return this.b}}
A.hj.prototype={}
A.ie.prototype={}
A.ig.prototype={
D(a){return"Exception: "+this.a}}
A.bt.prototype={
D(a){return"ColorTriplet("+A.z(this.a)+", "+A.z(this.b)+", "+A.z(this.c)+")"}}
A.il.prototype={
a6(){return"Channel."+this.b}}
A.R.prototype={
E(){var s=this.b
return++this.a<s.gv(s)},
gP(){return this.b.l(0,this.a)},
$iB:1}
A.cJ.prototype={
U(){return new A.cJ(new Uint16Array(A.q(this.a)))},
gM(){return B.G},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=A.K(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){return this.gn()},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
sn(a){var s,r=this.a,q=r.length
if(q!==0){s=A.K(a)
r.$flags&2&&A.b(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s,r=this.a
if(r.length>1){r=r[1]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
st(a){var s,r=this.a
if(r.length>1){s=A.K(a)
r.$flags&2&&A.b(r)
r[1]=s}},
gu(){var s,r=this.a
if(r.length>2){r=r[2]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
su(a){var s,r=this.a
if(r.length>2){s=A.K(a)
r.$flags&2&&A.b(r)
r[2]=s}},
gA(){var s,r=this.a
if(r.length>3){r=r[3]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
ga_(){return this.gA()/1},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=A.K(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cK.prototype={
U(){return new A.cK(new Float32Array(A.q(this.a)))},
gM(){return B.O},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.b(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:1},
ga_(){return this.gA()/1},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cL.prototype={
U(){return new A.cL(new Float64Array(A.q(this.a)))},
gM(){return B.Q},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.b(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:1},
ga_(){return this.gA()/1},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cM.prototype={
U(){return new A.cM(new Int16Array(A.q(this.a)))},
gM(){return B.S},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/32767},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cN.prototype={
U(){return new A.cN(new Int32Array(A.q(this.a)))},
gM(){return B.T},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gn(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sn(a){var s=this.a,r=s.length
if(r!==0){A.o(a)
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
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/2147483647},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cO.prototype={
U(){return new A.cO(new Int8Array(A.q(this.a)))},
gM(){return B.R},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/127},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cQ.prototype={
U(){var s=this.b
s===$&&A.c("data")
return new A.cQ(this.a,s)},
gM(){return B.y},
gN(){return null},
cb(a){var s
if(a<this.a){s=this.b
s===$&&A.c("data")
s=B.a.a3(s,7-a)&1}else s=0
return s},
bZ(a,b){var s
if(a>=this.a)return
a=7-a
s=this.b
s===$&&A.c("data")
this.b=b!==0?(s|B.a.V(1,a))>>>0:(s&~(B.a.V(1,a)&255))>>>0},
l(a,b){return this.cb(b)},
h(a,b,c){return this.bZ(b,c)},
gT(){return this.cb(0)},
gn(){return this.cb(0)},
sn(a){this.bZ(0,a)},
gt(){return this.cb(1)},
st(a){this.bZ(1,a)},
gu(){return this.cb(2)},
su(a){this.bZ(2,a)},
gA(){return this.cb(3)},
ga_(){return this.cb(3)/1},
gao(){return A.a_(this)},
ah(a){this.ae(a.gn(),a.gt(),a.gu(),a.gA())},
ae(a,b,c,d){var s=this
s.bZ(0,a)
s.bZ(1,b)
s.bZ(2,c)
s.bZ(3,d)},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1,
gv(a){return this.a}}
A.cR.prototype={
U(){return new A.cR(new Uint16Array(A.q(this.a)))},
gM(){return B.n},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/65535},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cS.prototype={
U(){var s=this.b
s===$&&A.c("data")
return new A.cS(this.a,s)},
gM(){return B.t},
gN(){return null},
cc(a){var s
if(a<this.a){s=this.b
s===$&&A.c("data")
s=B.a.a3(s,6-(a<<1>>>0))&3}else s=0
return s},
c_(a,b){var s,r,q
if(a>=this.a)return
if(!(a>=0&&a<4))return A.a(B.bx,a)
s=B.bx[a]
r=B.b.i(b)
q=this.b
q===$&&A.c("data")
this.b=(q&s|B.a.V(r&3,6-(a<<1>>>0)))>>>0},
l(a,b){return this.cc(b)},
h(a,b,c){return this.c_(b,c)},
gT(){return this.cc(0)},
gn(){return this.cc(0)},
sn(a){this.c_(0,a)},
gt(){return this.cc(1)},
st(a){this.c_(1,a)},
gu(){return this.cc(2)},
su(a){this.c_(2,a)},
gA(){return this.cc(3)},
ga_(){return this.cc(3)/3},
gao(){return A.a_(this)},
ah(a){this.ae(a.gn(),a.gt(),a.gu(),a.gA())},
ae(a,b,c,d){var s=this
s.c_(0,a)
s.c_(1,b)
s.c_(2,c)
s.c_(3,d)},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1,
gv(a){return this.a}}
A.cT.prototype={
U(){return new A.cT(new Uint32Array(A.q(this.a)))},
gM(){return B.P},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/4294967295},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.cU.prototype={
U(){return new A.cU(this.a,new Uint8Array(A.q(this.b)))},
gM(){return B.z},
gN(){return null},
cd(a){var s,r
if(a<0||a>=this.a)s=0
else{s=this.b
r=s.length
if(a<2){if(0>=r)return A.a(s,0)
s=B.a.a3(s[0],4-(a<<2>>>0))&15}else{if(1>=r)return A.a(s,1)
s=B.a.a3(s[1],4-((a&1)<<2))&15}}return s},
c2(a,b){var s,r,q,p
if(a>=this.a)return
s=B.a.L(B.b.i(b),0,15)
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
l(a,b){return this.cd(b)},
h(a,b,c){return this.c2(b,c)},
gT(){return this.cd(0)},
gn(){return this.cd(0)},
sn(a){this.c2(0,a)},
gt(){return this.cd(1)},
st(a){this.c2(1,a)},
gu(){return this.cd(2)},
su(a){this.c2(2,a)},
gA(){return this.cd(3)},
ga_(){return this.cd(3)/15},
gao(){return A.a_(this)},
ah(a){this.ae(a.gn(),a.gt(),a.gu(),a.gA())},
ae(a,b,c,d){var s=this
s.c2(0,a)
s.c2(1,b)
s.c2(2,c)
s.c2(3,d)},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1,
gv(a){return this.a}}
A.bO.prototype={
hS(a,b,c,d){var s,r=this.a
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
U(){return new A.bO(new Uint8Array(A.q(this.a)))},
gM(){return B.e},
gv(a){return this.a.length},
gN(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
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
gA(){var s=this.a
return s.length>3?s[3]:255},
ga_(){return this.gA()/255},
gao(){return A.a_(this)},
ah(a){var s,r,q=this
q.sn(a.gn())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.b(r)
r[3]=s}},
gH(a){return new A.R(this)},
Y(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.fq.prototype={}
A.cP.prototype={}
A.dJ.prototype={
U(){return new A.dJ(this.a)},
gM(){return B.e},
gv(a){return 4},
gN(){return null},
l(a,b){var s
if(b>=0&&b<4){s=b<<3>>>0
s=B.a.a7((this.a&B.a.S(255,s))>>>0,s)}else s=0
return s},
h(a,b,c){},
ah(a){},
gT(){return this.l(0,0)},
gn(){return this.l(0,0)},
sn(a){},
gt(){return this.l(0,1)},
st(a){},
gu(){return this.l(0,2)},
su(a){},
gA(){return this.l(0,3)},
ga_(){return this.gA()/255},
gao(){return A.a_(this)},
gH(a){return new A.R(this)},
Y(a,b){var s,r,q=this
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===q.gv(q)){s=b.gJ(b)
r=A.w(q,A.l(q).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$iy:1}
A.ft.prototype={
gA(){return 255},
ga_(){return 1},
gv(a){return 3}}
A.au.prototype={
a6(){return"Format."+this.b}}
A.dR.prototype={
a6(){return"FormatType."+this.b}}
A.fk.prototype={
a6(){return"BlendMode."+this.b}}
A.bQ.prototype={
d1(a){var s=$.l0()
if(!s.a8(a))return"<unknown>"
return s.l(0,a).a},
D(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=new A.Q(s,s.r,s.e,A.l(s).q("Q<1>")),q=t.p,p=t.r,o=t.N,n=t.P,m="";r.E();){l=r.d
m+=l+"\n"
k=s.l(0,l)
for(l=k.a,l=new A.Q(l,l.r,l.e,A.l(l).q("Q<1>"));l.E();){j=l.d
i=k.l(0,j)
m=i==null?m+("\t"+e.d1(j)+"\n"):m+("\t"+e.d1(j)+": "+i.D(0)+"\n")}for(l=k.b.a,j=new A.Q(l,l.r,l.e,A.l(l).q("Q<1>"));j.E();){h=j.d
m+=h+"\n"
if(!l.a8(h))l.h(0,h,new A.aI(A.I(q,p),new A.aR(A.I(o,n))))
g=l.l(0,h)
for(h=g.a,h=new A.Q(h,h.r,h.e,A.l(h).q("Q<1>"));h.E();){f=h.d
i=g.l(0,f)
m=i==null?m+("\t"+e.d1(f)+"\n"):m+("\t"+e.d1(f)+": "+i.D(0)+"\n")}}}return m.charCodeAt(0)==0?m:m},
aY(a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="exif",a7="interop",a8=a9.b
a9.b=!0
a9.a1(19789)
a9.a1(42)
a9.I(8)
s=a5.a
if(s.l(0,"ifd0")==null)s.h(0,"ifd0",new A.aI(A.I(t.p,t.r),new A.aR(A.I(t.N,t.P))))
r=s.l(0,"ifd1")
q=a5.b
p=q!=null&&q.length!==0&&r!=null
if(p){r.h(0,513,A.iG(0))
r.h(0,514,A.iG(q.length))}else if(r!=null){o=r.a
o.cA(0,513)
o.cA(0,514)}n=A.j(["ifd0"],t.s)
for(o=new A.Q(s,s.r,s.e,A.l(s).q("Q<1>"));o.E();){m=o.d
if(m!=="ifd0")B.c.C(n,m)}o=t.N
m=t.p
l=A.I(o,m)
for(k=n.length,j=t.r,i=t.P,h=8,g=0;g<n.length;n.length===k||(0,A.U)(n),++g){f=n[g]
e=s.l(0,f)
e.toString
l.h(0,f,h)
d=e.b.a
if(d.a8(a6)){c=new Uint32Array(1)
c[0]=0
e.h(0,34665,new A.aS(c))}else e.a.cA(0,34665)
if(d.a8(a7)){c=new Uint32Array(1)
c[0]=0
e.h(0,40965,new A.aS(c))}else e.a.cA(0,40965)
if(d.a8("gps")){c=new Uint32Array(1)
c[0]=0
e.h(0,34853,new A.aS(c))}else e.a.cA(0,34853)
e=e.a
h+=2+12*e.a+4
for(e=new A.av(e,e.r,e.e,A.l(e).q("av<2>"));e.E();){c=e.d
b=c.gaG().a
if(!(b<14))return A.a(B.u,b)
a=B.u[b]*c.gv(c)
if(a>4)h+=a}for(e=new A.Q(d,d.r,d.e,A.l(d).q("Q<1>"));e.E();){c=e.d
if(!d.a8(c))d.h(0,c,new A.aI(A.I(m,j),new A.aR(A.I(o,i))))
b=d.l(0,c)
b.toString
l.h(0,c,h)
b=b.a
a0=2+12*b.a
for(c=new A.av(b,b.r,b.e,A.l(b).q("av<2>"));c.E();){b=c.d
a1=b.gaG().a
if(!(a1<14))return A.a(B.u,a1)
a=B.u[a1]*b.gv(b)
if(a>4)a0+=a}h+=a0}}if(p)r.l(0,513).bw(h)
a2=n.length
for(k=a2-1,a3=0;a3<a2;++a3){if(!(a3<n.length))return A.a(n,a3)
f=n[a3]
a4=s.l(0,f)
e=a4.b.a
if(e.a8(a6)){d=a4.l(0,34665)
d.toString
c=l.l(0,a6)
c.toString
d.bw(c)}if(e.a8(a7)){d=a4.l(0,40965)
d.toString
c=l.l(0,a7)
c.toString
d.bw(c)}if(e.a8("gps")){d=a4.l(0,34853)
d.toString
c=l.l(0,"gps")
c.toString
d.bw(c)}d=l.l(0,f)
d.toString
a5.fR(a9,a4,d+2+12*a4.a.a+4)
if(a3===k)a9.I(0)
else{d=a3+1
if(!(d<n.length))return A.a(n,d)
d=l.l(0,n[d])
d.toString
a9.I(d)}a5.fS(a9,a4)
for(d=new A.Q(e,e.r,e.e,A.l(e).q("Q<1>"));d.E();){c=d.d
if(!e.a8(c))e.h(0,c,new A.aI(A.I(m,j),new A.aR(A.I(o,i))))
b=e.l(0,c)
b.toString
c=l.l(0,c)
c.toString
a5.fR(a9,b,c+2+12*b.a.a)
a5.fS(a9,b)}}if(p)a9.a0(q)
a9.b=a8},
fR(a,b,c){var s,r,q,p,o,n,m=b.a
a.a1(m.a)
for(m=new A.Q(m,m.r,m.e,A.l(m).q("Q<1>"));m.E();){s=m.d
r=b.l(0,s)
r.toString
q=s===273
p=q&&r.gaG()===B.H?B.p:r.gaG()
o=q&&r.gaG()===B.H?1:r.gv(r)
a.a1(s)
a.a1(p.a)
a.I(o)
s=r.gaG().a
if(!(s<14))return A.a(B.u,s)
n=B.u[s]*r.gv(r)
if(n<=4){r.aY(a)
while(n<4){a.m(0);++n}}else{a.I(c)
c+=n}}return c},
fS(a,b){var s,r,q
for(s=b.a,s=new A.av(s,s.r,s.e,A.l(s).q("av<2>"));s.E();){r=s.d
q=r.gaG().a
if(!(q<14))return A.a(B.u,q)
if(B.u[q]*r.gv(r)>4)r.aY(a)}},
cm(c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3=this,c4="Length must be a non-negative integer: ",c5=c6.e
c6.e=!0
s=c6.d
a2=c6.p()
if(a2===18761){c6.e=!1
if(c6.p()!==42){c6.e=c5
return!1}}else if(a2===19789){c6.e=!0
if(c6.p()!==42){c6.e=c5
return!1}}else return!1
r=c6.k()
q=0
a3=c3.a
a4=t.cO
a5=c6.c
a6=t.p
a7=t.r
a8=t.N
a9=t.P
for(;;){b0=r
if(typeof b0!=="number")return b0.hC()
if(!(b0>0))break
try{b0=s
b1=r
if(typeof b0!=="number")return b0.aO()
if(typeof b1!=="number")return A.i8(b1)
b1=b0+b1
c6.d=b1
if(a5-b1<2)break
p=new A.aI(A.I(a6,a7),new A.aR(A.I(a8,a9)))
o=c6.p()
b0=o
if(typeof b0!=="number")return b0.ej()
if(b0*12>a5-c6.d)break
n=o
b0=n
if(b0<0)A.az(A.br(c4+A.z(b0),null))
m=A.j(new Array(b0),a4)
l=0
for(;;){b0=l
b1=n
if(typeof b0!=="number")return b0.hD()
if(typeof b1!=="number")return A.i8(b1)
if(!(b0<b1))break
J.x(m,l,c3.fs(c6,s))
b0=l
if(typeof b0!=="number")return b0.aO()
l=b0+1}k=m
for(b0=k,b1=b0.length,b2=0;b2<b0.length;b0.length===b1||(0,A.U)(b0),++b2){j=b0[b2]
if(j.b!=null){b3=j.a
b4=j.b
b4.toString
J.x(p,b3,b4)}}a3.h(0,"ifd"+A.z(q),p)
b0=q
if(typeof b0!=="number")return b0.aO()
q=b0+1
i=c6.k()
if(J.c9(i,r))break
else r=i}catch(b5){break}}for(b0=new A.av(a3,a3.r,a3.e,A.l(a3).q("av<2>"));b0.E();){h=b0.d
for(b1=B.ci.gc5(),b1=b1.gH(b1);b1.E();){g=b1.gP()
b3=A.o(g)
if(h.a.a8(b3))try{f=J.d(h,g).i(0)
b3=s
b4=f
if(typeof b3!=="number")return b3.aO()
if(typeof b4!=="number")return A.i8(b4)
c6.d=b3+b4
e=new A.aI(A.I(a6,a7),new A.aR(A.I(a8,a9)))
d=c6.p()
c=d
b4=c
if(b4<0)A.az(A.br(c4+A.z(b4),null))
b=A.j(new Array(b4),a4)
a=0
for(;;){b3=a
b4=c
if(typeof b3!=="number")return b3.hD()
if(typeof b4!=="number")return A.i8(b4)
if(!(b3<b4))break
J.x(b,a,c3.fs(c6,s))
b3=a
if(typeof b3!=="number")return b3.aO()
a=b3+1}a0=b
for(b3=a0,b4=b3.length,b2=0;b2<b3.length;b3.length===b4||(0,A.U)(b3),++b2){a1=b3[b2]
if(a1.b!=null){b6=a1.a
b7=a1.b
b7.toString
J.x(e,b6,b7)}}b3=h.b
b4=B.ci.l(0,g)
b4.toString
b3.a.h(0,b4,a9.a(e))}catch(b5){continue}}}c3.b=null
b8=a3.l(0,"ifd1")
if(b8!=null){a3=b8.a
a3=a3.a8(513)&&a3.a8(514)}else a3=!1
if(a3){b9=b8.l(0,513).i(0)
c0=b8.l(0,514).i(0)
a3=s
if(typeof a3!=="number")return a3.aO()
c1=a3+b9
if(c0>0){a3=s
if(typeof a3!=="number")return A.i8(a3)
a3=c1>=a3&&c1+c0<=a5}else a3=!1
if(a3){c2=c6.d
c6.d=c1
c3.b=c6.ai(c0).a4()
c6.d=c2}}c6.e=c5
return!1},
fs(a,b){var s,r,q,p,o,n,m,l=a.p(),k=a.p(),j=a.k(),i=new A.hU(l,null)
if(k>=14)return i
s=B.bS[k]
r=j*B.u[k]
q=a.d
if((r>4?a.d=a.k()+b:q)+r>a.c)return i
p=a.ai(r)
switch(s.a){case 0:break
case 6:i.b=new A.bh(new Int8Array(A.q(J.l1(B.d.gB(p.a4()),0,j))))
break
case 1:i.b=new A.b4(new Uint8Array(A.q(p.ai(j).a4())))
break
case 7:i.b=new A.bU(new Uint8Array(A.q(p.ai(j).a4())))
break
case 2:i.b=new A.ce(j===0?"":p.al(j-1))
break
case 3:i.b=A.mz(p,j)
break
case 4:i.b=A.mu(p,j)
break
case 5:i.b=A.mv(p,j)
break
case 10:i.b=A.mx(p,j)
break
case 8:i.b=A.my(p,j)
break
case 9:i.b=A.mw(p,j)
break
case 11:i.b=A.mA(p,j)
break
case 12:i.b=A.mt(p,j)
break
case 13:if(j===1){o=new A.cf(0)
n=p.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=n
n=$.a9()
if(0>=n.length)return A.a(n,0)
o.a=n[0]
i.b=o}break}a.d=q+4
return i}}
A.hU.prototype={}
A.fy.prototype={}
A.aR.prototype={
hY(a){a.a.bL(0,new A.iD(this))},
ghi(a){var s,r=this.a
if(r.a===0)return!0
for(r=new A.av(r,r.r,r.e,A.l(r).q("av<2>"));r.E();){s=r.d
if(!(s.a.a===0&&s.b.ghi(0)))return!1}return!0},
l(a,b){var s=this.a
if(!s.a8(b))s.h(0,b,new A.aI(A.I(t.p,t.r),new A.aR(A.I(t.N,t.P))))
s=s.l(0,b)
s.toString
return s}}
A.iD.prototype={
$2(a,b){var s
A.bK(a)
s=A.ms(t.P.a(b))
this.a.a.h(0,a,s)
return s},
$S:11}
A.aI.prototype={
h9(a){a.a.bL(0,new A.iE(this))
a.b.a.bL(0,new A.iF(this))},
l(a,b){var s=this.a.l(0,b)
return s},
h(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(typeof b=="string")b=B.l0.l(0,b)
if(!A.i2(b))return
if(c instanceof A.a3)k.a.h(0,b,c)
else{s=$.l0().l(0,b)
if(s!=null)switch(s.b.a){case 1:if(t.L.b(c))k.a.h(0,b,new A.b4(new Uint8Array(A.q(new Uint8Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Uint8Array(1)
q[0]=r
k.a.h(0,b,new A.b4(q))}break
case 2:break
case 3:if(t.L.b(c))k.a.h(0,b,new A.by(new Uint16Array(A.q(new Uint16Array(A.q(c))))))
else if(typeof c=="number")k.a.h(0,b,A.oK(B.a.i(c)))
break
case 4:if(t.L.b(c))k.a.h(0,b,new A.aS(new Uint32Array(A.q(new Uint32Array(A.q(c))))))
else if(typeof c=="number")k.a.h(0,b,A.iG(B.a.i(c)))
break
case 5:if(t.bJ.b(c))k.a.h(0,b,new A.bg(A.dd(c,!0,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.h(0,b,new A.bg(A.j([new A.aW(q,c[1])],t.aK)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.cg(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.aW(l,q[1])}k.a.h(0,b,new A.bg(A.dd(o,!0,r)))}break
case 6:if(t.L.b(c))k.a.h(0,b,new A.bh(new Int8Array(A.q(new Int8Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int8Array(1)
q[0]=r
k.a.h(0,b,new A.bh(q))}break
case 7:if(t.L.b(c))k.a.h(0,b,new A.bU(new Uint8Array(A.q(new Uint8Array(A.q(c))))))
break
case 8:if(t.L.b(c))k.a.h(0,b,new A.bx(new Int16Array(A.q(new Int16Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int16Array(1)
q[0]=r
k.a.h(0,b,new A.bx(q))}break
case 9:if(t.L.b(c))k.a.h(0,b,new A.bw(new Int32Array(A.q(new Int32Array(A.q(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int32Array(1)
q[0]=r
k.a.h(0,b,new A.bw(q))}break
case 10:if(t.bJ.b(c))k.a.h(0,b,new A.bi(A.dd(c,!0,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.h(0,b,new A.bi(A.j([new A.aW(q,c[1])],t.aK)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.cg(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.aW(l,q[1])}k.a.h(0,b,new A.bi(A.dd(o,!0,r)))}break
case 11:if(t.H.b(c))k.a.h(0,b,new A.bT(new Float32Array(A.q(new Float32Array(A.q(c))))))
else if(typeof c=="number"){r=new Float32Array(1)
r[0]=c
k.a.h(0,b,new A.bT(r))}break
case 12:if(t.H.b(c))k.a.h(0,b,new A.bS(new Float64Array(A.q(new Float64Array(A.q(c))))))
else if(typeof c=="number"){r=new Float64Array(1)
r[0]=c
k.a.h(0,b,new A.bS(r))}break
case 13:if(typeof c=="number")k.a.h(0,b,new A.cf(B.a.i(c)))
break
case 0:break}}},
gcl(){var s=this.a.l(0,274)
return s==null?null:s.i(0)},
scl(a){this.a.cA(0,274)}}
A.iE.prototype={
$2(a,b){var s
A.o(a)
s=t.r.a(b).U()
this.a.a.h(0,a,s)
return s},
$S:20}
A.iF.prototype={
$2(a,b){var s
A.bK(a)
s=A.ms(t.P.a(b))
this.a.b.a.h(0,a,s)
return s},
$S:11}
A.ae.prototype={
a6(){return"IfdValueType."+this.b}}
A.a3.prototype={
ab(a,b){A.o(b)
return 0},
i(a){return this.ab(0,0)},
bt(){return new Uint8Array(0)},
D(a){return""},
Y(a,b){var s=this
if(b==null)return!1
return b instanceof A.a3&&s.gaG()===b.gaG()&&s.gv(s)===b.gv(b)&&s.gJ(s)===b.gJ(b)},
gJ(a){return 0},
bw(a){}}
A.b4.prototype={
U(){return new A.b4(new Uint8Array(A.q(this.a)))},
gaG(){return B.bg},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.b4){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ab(0,0)},
bw(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bt(){return this.a},
aY(a){a.a0(this.a)},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.ce.prototype={
U(){return new A.ce(this.a)},
gaG(){return B.l},
gv(a){return this.a.length+1},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.ce){s=this.a
r=b.a
s=s.length+1===r.length+1&&B.m.gJ(s)===B.m.gJ(r)}else s=!1
return s},
gJ(a){return B.m.gJ(this.a)},
bt(){return new Uint8Array(A.q(new A.an(this.a)))},
aY(a){a.a0(new A.an(this.a))
a.m(0)},
D(a){return this.a}}
A.by.prototype={
i2(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.p()
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.by(new Uint16Array(A.q(this.a)))},
gaG(){return B.k},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.by){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ab(0,0)},
bw(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bt(){return J.aC(B.A.gB(this.a))},
aY(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.a1(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.aS.prototype={
i_(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.aS(new Uint32Array(A.q(this.a)))},
gaG(){return B.p},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.aS){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ab(0,0)},
bw(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bt(){return J.aC(B.o.gB(this.a))},
aY(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.I(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bg.prototype={
U(){return new A.bg(A.dd(this.a,!0,t.i))},
gaG(){return B.r},
gv(a){return this.a.length},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].i(0)},
i(a){return this.ab(0,0)},
Y(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bg){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.n(s)===A.n(q)}else s=!1
return s},
gJ(a){return A.n(this.a)},
aY(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.U)(s),++q){p=s[q]
a.I(p.a)
a.I(p.b)}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].D(0)}else s=A.z(s)
return s}}
A.bh.prototype={
U(){return new A.bh(new Int8Array(A.q(this.a)))},
gaG(){return B.bl},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bh){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ab(0,0)},
bw(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bt(){return J.aC(B.ay.gB(this.a))},
aY(a){a.a0(J.D(B.ay.gB(this.a),0,null))},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bx.prototype={
i1(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.p()
o=$.ar()
o.$flags&2&&A.b(o)
o[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.bx(new Int16Array(A.q(this.a)))},
gaG(){return B.bm},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bx){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ab(0,0)},
bw(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bt(){return J.aC(B.ax.gB(this.a))},
aY(a){var s,r,q,p=new Int16Array(1),o=J.m8(B.ax.gB(p),0,null),n=this.a,m=n.length
for(s=o.length,r=0;r<m;++r){q=n[r]
if(0>=1)return A.a(p,0)
p[0]=q
if(0>=s)return A.a(o,0)
a.a1(o[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bw.prototype={
i0(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.O()
o.$flags&2&&A.b(o)
o[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.bw(new Int32Array(A.q(this.a)))},
gaG(){return B.bn},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bw){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.ab(0,0)},
bw(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bt(){return J.aC(B.Z.gB(this.a))},
aY(a){var s,r,q,p=this.a,o=p.length
for(s=0;s<o;++s){r=p[s]
q=$.ic()
q.$flags&2&&A.b(q)
q[0]=r
r=$.l_()
if(0>=r.length)return A.a(r,0)
a.I(r[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bi.prototype={
U(){return new A.bi(A.dd(this.a,!0,t.i))},
gaG(){return B.bh},
gv(a){return this.a.length},
Y(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bi){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.n(s)===A.n(q)}else s=!1
return s},
gJ(a){return A.n(this.a)},
ab(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].i(0)},
i(a){return this.ab(0,0)},
aY(a){var s,r,q,p,o,n
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.U)(s),++q){p=s[q]
o=$.ic()
o.$flags&2&&A.b(o)
o[0]=p.a
n=$.l_()
if(0>=n.length)return A.a(n,0)
a.I(n[0])
o[0]=p.b
a.I(n[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].D(0)}else s=A.z(s)
return s}}
A.bT.prototype={
i3(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.O()
o.$flags&2&&A.b(o)
o[0]=p
p=$.c8()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.bT(new Float32Array(A.q(this.a)))},
gaG(){return B.bi},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bT){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
bt(){return J.aC(B.a4.gB(this.a))},
aY(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.lI(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.z(s[0])}else s=A.z(s)
return s}}
A.bS.prototype={
hZ(a,b){var s,r
for(s=this.a,r=0;r<b;++r)B.a5.h(s,r,a.dv())},
U(){return new A.bS(new Float64Array(A.q(this.a)))},
gaG(){return B.bj},
gv(a){return this.a.length},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bS){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
bt(){return J.aC(B.a5.gB(this.a))},
aY(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.lJ(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.z(s[0])}else s=A.z(s)
return s}}
A.bU.prototype={
U(){return new A.bU(new Uint8Array(A.q(this.a)))},
gaG(){return B.H},
gv(a){return this.a.length},
bt(){return this.a},
Y(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bU){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
aY(a){a.a0(this.a)},
D(a){return"<data>"}}
A.cf.prototype={
U(){return A.iG(this.a)},
gaG(){return B.bk},
gv(a){return 1},
Y(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cf)s=this.a===b.a
return s},
gJ(a){return this.a},
ab(a,b){if(A.o(b)!==0)throw A.h(A.pp("Ifd tags must have exactly one entry (the offset)"))
return this.a},
i(a){return this.ab(0,0)},
bw(a){this.a=a},
bt(){var s=this.a
return new Uint8Array(A.q(A.j([B.a.j(s,24),B.a.j(s,16),B.a.j(s,8),s],t.t)))},
aY(a){a.I(this.a)},
D(a){return"Ifd@"+this.a}}
A.aD.prototype={
a6(){return"DitherKernel."+this.b}}
A.cW.prototype={
a6(){return"DitherScanOrder."+this.b}}
A.kC.prototype={
$3(a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.a,a0=a.aP(a5,a6),a1=B.b.i(a0.l(0,0)),a2=B.b.i(a0.l(0,1)),a3=B.b.i(a0.l(0,2)),a4=b.b.eg(a1,a2,a3)
b.c.hH(a5,a6,a4)
s=b.d
r=a1-s.aV(a4,0)
q=a2-s.aV(a4,1)
p=a3-s.aV(a4,2)
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
c=i==null?null:i.O(a5+h,a6+g,null)
if(c==null)c=new A.C()
c.sn(c.gn()+r*d)
c.st(c.gt()+q*d)
c.su(c.gu()+p*d)}}},
$S:21}
A.ad.prototype={
a6(){return"BmpCompression."+this.b}}
A.ij.prototype={}
A.bs.prototype={
ev(a,b){var s,r,q,p,o,n,m,l=this,k=l.d,j=k<=40
if(j){s=l.r
s=s===B.aa||s===B.aF}else s=!0
if(s){s=l.as=a.k()
r=A.ky(s)
l.CW=r
q=B.a.a3(s,r)
s=q>0
l.cx=s?255/q:0
r=l.at=a.k()
p=A.ky(r)
l.cy=p
o=B.a.a3(r,p)
l.db=s?255/o:0
r=l.ax=a.k()
p=A.ky(r)
l.dx=p
n=B.a.a3(r,p)
l.dy=s?255/n:0
if(!j||l.r===B.aF){j=l.ay=a.k()
s=A.ky(j)
l.fr=s
m=B.a.a3(j,s)
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
if(l.f<=8)l.lq(a)},
gcT(){var s=this.d
if(s!==40)if(s===124){s=this.ay
s===$&&A.c("alphaMask")
s=s===0}else s=!1
else s=!0
return s},
gK(){return Math.abs(this.c)},
lq(a){var s,r,q,p,o,n=this,m=n.z
if(m===0)m=B.a.S(1,n.f)
n.ch=new A.aL(new Uint8Array(m*3),m,3)
for(s=0;s<m;++s){r=J.d(a.a,a.d++)
q=J.d(a.a,a.d++)
p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n.ch.d2(s,p,q,r,o)}},
kY(a2,a3){var s,r,q,p,o,n,m,l,k,j=this,i="_redShift",h="_redScale",g="greenMask",f="_greenShift",e="_greenScale",d="blueMask",c="_blueShift",b="_blueScale",a="alphaMask",a0="_alphaShift",a1="_alphaScale"
t.dX.a(a3)
if(j.ch!=null){s=j.f
if(s===1){r=a2.G()
for(q=7;q>=0;--q)a3.$4(B.a.aW(r,q)&1,0,0,0)
return}else if(s===2){r=a2.G()
for(q=6;q>=0;q-=2)a3.$4(B.a.aW(r,q)&2,0,0,0)}else if(s===4){r=a2.G()
a3.$4(B.a.j(r,4)&15,0,0,0)
a3.$4(r&15,0,0,0)
return}else if(s===8){a3.$4(a2.G(),0,0,0)
return}}s=j.r
if(s===B.aa&&j.f===32){p=a2.k()
s=j.as
s===$&&A.c("redMask")
o=j.CW
o===$&&A.c(i)
o=B.a.a3((p&s)>>>0,o)
s=j.cx
s===$&&A.c(h)
n=B.b.i(o*s)
s=j.at
s===$&&A.c(g)
o=j.cy
o===$&&A.c(f)
o=B.a.a3((p&s)>>>0,o)
s=j.db
s===$&&A.c(e)
m=B.b.i(o*s)
s=j.ax
s===$&&A.c(d)
o=j.dx
o===$&&A.c(c)
o=B.a.a3((p&s)>>>0,o)
s=j.dy
s===$&&A.c(b)
l=B.b.i(o*s)
if(j.gcT())k=255
else{s=j.ay
s===$&&A.c(a)
o=j.fr
o===$&&A.c(a0)
o=B.a.a3((p&s)>>>0,o)
s=j.fx
s===$&&A.c(a1)
k=B.b.i(o*s)}return a3.$4(n,m,l,k)}else{o=j.f
if(o===32&&s===B.aE){l=a2.G()
m=a2.G()
n=a2.G()
k=a2.G()
return a3.$4(n,m,l,j.gcT()?255:k)}else if(o===24){l=a2.G()
m=a2.G()
return a3.$4(a2.G(),m,l,255)}else if(o===16){p=a2.p()
s=j.as
s===$&&A.c("redMask")
o=j.CW
o===$&&A.c(i)
o=B.a.a3((p&s)>>>0,o)
s=j.cx
s===$&&A.c(h)
n=B.b.i(o*s)
s=j.at
s===$&&A.c(g)
o=j.cy
o===$&&A.c(f)
o=B.a.a3((p&s)>>>0,o)
s=j.db
s===$&&A.c(e)
m=B.b.i(o*s)
s=j.ax
s===$&&A.c(d)
o=j.dx
o===$&&A.c(c)
o=B.a.a3((p&s)>>>0,o)
s=j.dy
s===$&&A.c(b)
l=B.b.i(o*s)
if(j.gcT())k=255
else{s=j.ay
s===$&&A.c(a)
o=j.fr
o===$&&A.c(a0)
o=B.a.a3((p&s)>>>0,o)
s=j.fx
s===$&&A.c(a1)
k=B.b.i(o*s)}return a3.$4(n,m,l,k)}else throw A.h(A.m("Unsupported bitsPerPixel ("+o+") or compression ("+s.D(0)+")."))}},
$iL:1}
A.fl.prototype={
bz(a){var s,r
if(!A.md(A.v(a,!1,null,0))||a.length<18)return!1
s=A.v(a,!1,null,0)
s.d+=14
r=s.k()
return r>=12&&r<=124},
b7(a){var s
if(!this.bz(a))return null
s=A.v(a,!1,null,0)
this.a=s
return this.b=A.oj(s,null)},
ap(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.b
if(a0==null)return new A.bj(a,a,a,a,0,B.j,0,0)
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
else if(q===1)m=B.y
else{if(q===2)n=B.t
else if(q===4)n=B.z
else n=B.e
m=n}l=s?a:a0.ch
k=A.P(a,a,m,0,B.j,a0.gK(),a,0,o,l,B.e,r,!1)
for(j=k.gK()-1,s=a0.c,r=1/s<0,n=s<0,s=s===0;j>=0;--j){i={}
if(!(s?r:n))h=j
else{g=k.a
g=g==null?a:g.b
h=(g==null?0:g)-1-j}g=b.a
f=g.am(p)
g.d=g.d+(f.c-f.d)
g=k.a
e=g==null
d=e?a:g.a
if(d==null)d=0
i.a=0
c=e?a:g.O(0,h,a)
if(c==null)c=new A.C()
while(i.a<d)a0.kY(f,new A.ih(i,b,d,a0,c))}return k},
b9(a,b){if(this.b7(a)==null)return null
return this.ap(0)}}
A.ih.prototype={
$4(a,b,c,d){var s,r,q=this,p=q.a
if(p.a<q.c){s=q.b.c&&q.d.ch!=null
r=q.e
if(s){s=q.d
r.ae(s.ch.b1(a),s.ch.b0(a),s.ch.b_(a),s.ch.b6(a))}else r.ae(a,b,c,d)
r.E();++p.a}},
$S:22}
A.ip.prototype={}
A.ii.prototype={
bH(c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=null,b8=A.a7(!1,8192),b9=c3.gaE(),c0=c3.a,c1=c0==null?b7:c0.gN(),c2=c3.gM()
c0=c2===B.y
if(c0&&b9===1&&c1==null){c1=new A.aL(new Uint8Array(6),2,3)
c1.b4(0,0,0,0)
c1.b4(1,255,255,255)}else if(c0&&b9===2){c3=c3.cQ(B.t,1,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else if(c0&&b9===3&&c1==null){c3=c3.cj(B.z,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else if(c0&&b9===4)c3=c3.cP(B.e,4)
else{c0=c2===B.t
if(c0&&b9===1&&c1==null){c3=c3.cj(B.t,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else if(c0&&b9===2){c3=c3.cj(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else if(c0&&b9===3&&c1==null){c3=c3.cj(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else if(c0&&b9===4){c3=c3.cj(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else{c0=c2===B.z
if(c0&&b9===1&&c1==null){c3=c3.cj(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gN()}else if(c0&&b9===2)c3=c3.cP(B.e,3)
else if(c0&&b9===3&&c1==null)c3=c3.cP(B.e,3)
else if(c0&&b9===4)c3=c3.cP(B.e,4)
else{c0=c2===B.e
if(c0&&b9===1&&c1==null)c3=c3.cj(B.e,!0)
else if(c0&&b9===2)c3.cP(B.e,3)
else if(c3.gb2())c3=c3.aQ(B.e)
else if(c3.gaN()&&c3.gaE()===4)c3=c3.e8(4)}}}c0=c3.gaM()
s=c3.a
r=c0*s.c
if(r===12)r=16
c0=r>8
q=c0?B.aa:B.aE
s=s.gbh()
p=s
if(p==null)p=0
o=B.a.W(c3.gR()*r+31,32)*4
n=o-p
m=n>0?A.F(n,255,!1,t.p):b7
l=r>=1&&r<=8?B.a.V(1,r):0
k=o*c3.gK()
j=c0?124:40
i=j+14
h=l*4
g=i+h
f=g-g
b8.a1(19778)
b8.I(k+i+h+f)
b8.I(0)
b8.I(g)
b8.I(j)
b8.I(c3.gR())
b8.I(c3.gK())
b8.a1(1)
b8.a1(r)
b8.I(q.a)
b8.I(k)
b8.I(11811)
b8.I(11811)
s=r===8
b8.I(s?255:0)
b8.I(s?255:0)
if(c0){c0=r===16
e=c0?15:255
d=c0?240:65280
c=c0?3840:16711680
b=c0?61440:4278190080
b8.I(c)
b8.I(d)
b8.I(e)
b8.I(b)
b8.I(1934772034)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(0)
b8.I(2)
b8.I(0)
b8.I(0)
b8.I(0)}c0=r===1
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
if(!a||r===2||r===4||s){a5=c3.gcV(0)-p
a6=c3.gK()
for(s=m!=null,a=r===4,a7=r===2,a8=0;a8<a6;++a8){a9=c3.a
a9=a9==null?b7:a9.gB(a9)
if(a9==null)a9=B.d.gB(new Uint8Array(0))
b0=J.D(a9,a5,p)
if(c0)b8.a0(b0)
else if(a7){a0=b0.length
for(b1=0;b1<a0;++b1){b2=b0[b1]
b8.m((b2&15)<<4|b2>>>4)}}else if(a){a0=b0.length
for(b1=0;b1<a0;++b1){b2=b0[b1]
b8.m(b2>>>4<<4|b2&15)}}else b8.a0(b0)
if(s)b8.a0(m)
a5-=p}return J.D(B.d.gB(b8.c),0,b8.a)}b3=c3.gaE()===4
a6=c3.gK()
b4=c3.gR()
if(r===16)for(a8=a6-1,c0=m!=null,b5=b7;a8>=0;--a8){s=c3.a
b5=s==null?b7:s.O(0,a8,b5)
if(b5==null)b5=new A.C()
for(b6=0;b6<b4;++b6){b8.m((B.b.i(b5.gt())<<4|B.b.i(b5.gu()))>>>0)
b8.m((B.b.i(b5.gA())<<4|B.b.i(b5.gn()))>>>0)
b5.E()}if(c0)b8.a0(m)}else for(a8=a6-1,c0=m!=null,b5=b7;a8>=0;--a8){s=c3.a
b5=s==null?b7:s.O(0,a8,b5)
if(b5==null)b5=new A.C()
for(b6=0;b6<b4;++b6){b8.m(A.o(b5.gu()))
b8.m(A.o(b5.gt()))
b8.m(A.o(b5.gn()))
if(b3)b8.m(A.o(b5.gA()))
b5.E()}if(c0)b8.a0(m)}return J.D(B.d.gB(b8.c),0,b8.a)}}
A.L.prototype={}
A.im.prototype={}
A.iq.prototype={}
A.fz.prototype={}
A.e3.prototype={
cW(){return this.w},
bu(a,b,c,d,e){throw A.h(A.m("B44 compression not yet supported."))},
cB(a,b,c){return this.bu(a,b,c,null,null)},
D(a){return A.z(this.r)+" "+this.x}}
A.cX.prototype={
a6(){return"ExrChannelType."+this.b}}
A.cb.prototype={
a6(){return"ExrChannelName."+this.b}}
A.fA.prototype={
hT(a){var s=this,r=a.cY()
s.a=r
if(r.length===0)return
r=a.k()
if(!(r<3))return A.a(B.bI,r)
s.c=B.bI[r]
a.G()
a.d+=3
s.f=a.k()
s.r=a.k()
r=s.a
if(r==="R"){s.w=!0
s.b=B.de}else if(r==="G"){s.w=!0
s.b=B.df}else if(r==="B"){s.w=!0
s.b=B.dg}else if(r==="A"){s.w=!0
s.b=B.dh}else{s.w=!1
s.b=B.di}switch(s.c.a){case 0:s.d=4
break
case 1:s.d=2
break
case 2:s.d=4
break}}}
A.b2.prototype={
a6(){return"ExrCompressorType."+this.b}}
A.bu.prototype={
bu(a,b,c,d,e){throw A.h(A.m("Unsupported compression type"))},
cB(a,b,c){return this.bu(a,b,c,null,null)}}
A.fU.prototype={}
A.fB.prototype={
shl(a){this.c=t.T.a(a)}}
A.fC.prototype={
hU(a){var s,r,q,p,o=this,n=A.v(a,!1,null,0)
if(n.k()!==20000630)throw A.h(A.m("File is not an OpenEXR image file."))
s=o.d=n.G()
if(s!==2)throw A.h(A.m("Cannot read version "+s+" image files."))
s=o.e=n.bs()
if((s&4294967289)>>>0!==0)throw A.h(A.m("The file format version number's flag field contains unrecognized flags."))
if((s&16)===0){r=o.c
q=A.mC(r.length,(s&2)!==0,n)
if(q.w>0)B.c.C(r,q)}else for(s=o.c;;){q=A.mC(s.length,(o.e&2)!==0,n)
if(q.w<=0)break
B.c.C(s,q)}s=o.c
r=s.length
if(r===0)throw A.h(A.m("Error reading image header"))
for(p=0;p<s.length;s.length===r||(0,A.U)(s),++p)s[p].lp(n)
o.kl(n)},
kl(a){var s,r,q,p,o=this
for(s=o.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.U)(s),++q){p=s[q]
o.a=Math.max(o.a,p.w)
o.b=Math.max(o.b,p.x)
if(p.db)o.ku(p,a)
else o.kt(p,a)}},
ku(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=this.e
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
if(s)if(p.k()!==n)throw A.h(A.m("Invalid Image Data"))
e=p.k()
d=p.k()
p.k()
p.k()
c=p.am(p.k())
p.d=p.d+(c.c-c.d)
g=b6.dy
g.toString
b=d*g
a=b6.dx
a.toString
g=r.bu(c,e*a,b,a,g)
a=g.length
a=Math.min(a,a)
a0=new A.ag(g,0,a,0,!1)
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
switch(g.a){case 1:g=a0.p()
b0=$.T
b0=b0!=null?b0:A.Y()
if(!(g<b0.length))return A.a(b0,g)
b1=b0[g]
break
case 2:b1=a0.p()
break
case 0:b1=a0.k()
break
default:b1=b4}g=a7.d
g===$&&A.c("dataSize")
a4+=g
g=a7.w
g===$&&A.c("isColorChannel")
if(g){g=b5.a
b2=g==null?b4:g.O(a8,b,b4)
if(b2==null)b2=new A.C()
g=a7.b
g===$&&A.c("nameType")
b2.h(0,g.a,b1)}else{g=a7.a
g===$&&A.c("name")
b0=b5.b
b3=b0!=null?b0.l(0,g):b4
if(b3!=null)b3.aa(a8,b,b1,0,0)}}}++a5;++b}++f;++h}++i}++j;++l}++m}},
kt(a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=null,a7=this.e
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
if(s)if(n.k()!==3.141592653589793)throw A.h(A.m("Invalid Image Data"))
i=n.k()
h=$.O()
h.$flags&2&&A.b(h)
h[0]=i
i=$.a9()
if(0>=i.length)return A.a(i,0)
h[0]=n.k()
g=n.am(i[0])
n.d=n.d+(g.c-g.d)
if(l){i=r.cB(g,0,k)
h=i.length
f=new A.ag(i,0,Math.min(h,h),0,!1)}else f=g
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
switch(i.a){case 1:i=f.p()
h=$.T
h=h!=null?h:A.Y()
if(!(i<h.length))return A.a(h,i)
a3=h[i]
break
case 2:a3=f.p()
break
case 0:a3=f.k()
break
default:a3=a6}i=a0.d
i===$&&A.c("dataSize")
b+=i
i=a0.w
i===$&&A.c("isColorChannel")
if(i){i=a7.a
a4=i==null?a6:i.O(a2,k,a6)
if(a4==null)a4=new A.C()
i=a0.b
i===$&&A.c("nameType")
a4.h(0,i.a,a3)}else{i=a0.a
i===$&&A.c("name")
h=a7.b
a5=h!=null?h.l(0,i):a6
if(a5!=null)a5.aa(a2,k,a3,0,0)}}}++c;++k}}},
$iL:1}
A.dO.prototype={
hV(a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=null,a5="dataType",a6="dataWindow",a7=A.I(t.N,t.w)
for(s=a3.e,r=t.t,q=t.L,p=a3.c,o=B.G;;){n=b0.cY()
if(n.length===0)break
b0.cY()
m=b0.am(b0.k())
b0.d=b0.d+(m.c-m.d)
s.h(0,n,new A.fz())
switch(n){case"channels":for(;;){l=new A.fA()
l.hT(m)
k=l.a
k===$&&A.c("name")
if(k.length===0)break
j=l.w
j===$&&A.c("isColorChannel")
if(j){++a3.d
k=l.c
k===$&&A.c(a5)
if(k===B.aH)o=B.G
else o=k===B.aI?B.O:B.P}else{j=l.c
j===$&&A.c(a5)
if(j===B.aH){j=a3.w
i=a3.x
a7.h(0,k,new A.d_(new Uint16Array(j*i),j,i,1))}else if(j===B.aI){j=a3.w
i=a3.x
a7.h(0,k,new A.d0(new Float32Array(j*i),j,i,1))}else if(j===B.bc){j=a3.w
i=a3.x
a7.h(0,k,new A.d4(new Uint32Array(j*i),j,i,1))}}B.c.C(p,l)}break
case"chromaticities":k=new Float32Array(8)
a3.at=k
j=m.k()
i=$.O()
i.$flags&2&&A.b(i)
i[0]=j
j=$.c8()
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
if(!(k>=0&&k<8))return A.a(B.bU,k)
a3.ax=B.bU[k]
break
case"dataWindow":k=m.k()
j=$.O()
j.$flags&2&&A.b(j)
j[0]=k
k=$.a9()
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
j=$.O()
j.$flags&2&&A.b(j)
j[0]=k
k=$.a9()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
j[0]=m.k()
j[0]=m.k()
break
case"lineOrder":break
case"pixelAspectRatio":k=m.k()
j=$.O()
j.$flags&2&&A.b(j)
j[0]=k
k=$.c8()
if(0>=k.length)return A.a(k,0)
break
case"screenWindowCenter":k=m.k()
j=$.O()
j.$flags&2&&A.b(j)
j[0]=k
k=$.c8()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
break
case"screenWindowWidth":k=m.k()
j=$.O()
j.$flags&2&&A.b(j)
j[0]=k
k=$.c8()
if(0>=k.length)return A.a(k,0)
break
case"tiles":a3.dx=m.k()
a3.dy=m.k()
f=J.d(m.a,m.d++)
a3.fr=f&15
a3.fx=B.a.j(f,4)&15
break
case"type":e=m.cY()
if(e!=="deepscanline")if(e!=="deeptile")throw A.h(A.m("EXR Invalid type: "+e))
break
default:break}}s=a3.w
a3.b=A.P(a4,a4,o,0,B.j,a3.x,a4,0,a3.d,a4,B.e,s,!1)
for(s=new A.Q(a7,a7.r,a7.e,a7.$ti.q("Q<1>"));s.E();){r=s.d
q=a3.b
q.toString
k=a7.l(0,r)
k.toString
q.hG(r,k)}if(a3.db){s={}
r=a3.r
r===$&&A.c(a6)
a3.id=a3.it(r[0],r[2],r[1],r[3])
r=a3.r
a3.k1=a3.iu(r[0],r[2],r[1],r[3])
if(a3.fr!==2)a3.k1=1
r=a3.id
r.toString
q=a3.r
a3.fy=a3.eI(r,q[0],q[2],a3.dx,a3.fx)
q=a3.k1
q.toString
r=a3.r
a3.go=a3.eI(q,r[1],r[3],a3.dy,a3.fx)
r=a3.is()
a3.k2=r
q=a3.dx
q.toString
q=r*q
a3.k3=q
a3.CW=A.mm(a3.ax,a3,q,a3.dy)
s.a=s.b=0
q=a3.id
q.toString
r=a3.k1
r.toString
a3.ay=A.mK(q*r,new A.it(s,a3),t.bv)}else{s=a3.x
r=a3.ch=new Uint32Array(s+1)
for(q=p.length,k=a3.r,j=a3.w,d=0;d<q;++d){c=p[d]
i=c.d
i===$&&A.c("dataSize")
h=c.f
h===$&&A.c("xSampling")
b=B.a.aw(i*j,h)
for(i=c.r,a=0;a<s;++a){k===$&&A.c(a6)
h=k[1]
i===$&&A.c("ySampling")
if(B.a.a9(a+h,i)===0)r[a]=r[a]+b}}for(a0=0,a=0;a<s;++a)a0=Math.max(a0,r[a])
s=A.mm(a3.ax,a3,a0,a4)
a3.CW=s
s=a3.cx=s.cW()
r=a3.ch
q=r.length
p=new Uint32Array(q)
a3.cy=p
for(--q,a1=0,a2=0;a2<=q;++a2){if(B.a.a9(a2,s)===0)a1=0
p[a2]=a1
a1+=r[a2]}s=B.a.aw(a3.x+s,s)
a3.ay=A.j([new Uint32Array(s-1)],t.hh)}},
it(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.o(r)
s=(q===0?o.dc(r):o.d5(r))+1
break
case 2:p=b-a+1
s=(o.fx===0?o.dc(p):o.d5(p))+1
break
default:throw A.h(A.m("Unknown LevelMode format."))}return s},
iu(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.o(r)
s=(q===0?o.dc(r):o.d5(r))+1
break
case 2:p=d-c+1
s=(o.fx===0?o.dc(p):o.d5(p))+1
break
default:throw A.h(A.m("Unknown LevelMode format."))}return s},
dc(a){var s
for(s=0;a>1;){++s
a=B.a.j(a,1)}return s},
d5(a){var s,r
for(s=0,r=0;a>1;){if((a&1)!==0)r=1;++s
a=B.a.j(a,1)}return s+r},
is(){var s,r,q,p,o
for(s=this.c,r=s.length,q=0,p=0;p<r;++p){o=s[p].d
o===$&&A.c("dataSize")
q+=o}return q},
eI(a,b,c,d,e){var s,r,q,p,o,n,m=J.ao(a,t.p)
for(s=e===1,r=c-b+1,q=0;q<a;++q){p=B.a.S(1,q)
o=B.a.aw(r,p)
if(s&&o*p<r)++o
n=Math.max(o,1)
d.toString
m[q]=B.a.aw(n+d-1,d)}return m}}
A.it.prototype={
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
$S:23}
A.fV.prototype={
lp(a){var s,r,q,p,o,n=this
if(n.db)for(s=0;s<n.ay.length;++s){r=0
for(;;){q=n.ay
if(!(s<q.length))return A.a(q,s)
q=q[s]
if(!(r<q.length))break
p=a.ec()
q.$flags&2&&A.b(q)
q[r]=p;++r}}else{q=n.ay
if(0>=q.length)return A.a(q,0)
o=q[0].length
for(s=0;s<o;++s){q=n.ay
if(0>=q.length)return A.a(q,0)
q=q[0]
p=a.ec()
q.$flags&2&&A.b(q)
if(!(s<q.length))return A.a(q,s)
q[s]=p}}}}
A.fW.prototype={
i6(a,b,c){var s,r,q,p=this,o=a.c.length,n=J.ao(o,t.eP)
for(s=0;s<o;++s)n[s]=new A.f6()
p.y=t.gR.a(n)
r=p.w
r.toString
q=B.a.W(r*p.x,2)
p.z=new Uint16Array(q)},
cW(){return this.x},
bu(a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="_channelData"
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
i=B.a.aw(a8,q)
h=B.a.aw(s,q)
q=i*q<a8?0:1
q=h-i+q
j.c=q
p=k.r
p===$&&A.c("ySampling")
i=B.a.aw(a9,p)
h=B.a.aw(r,p)
g=i*p<a9?0:1
g=h-i+g
j.d=g
j.e=p
p=k.d
p===$&&A.c("dataSize")
p=p/2|0
j.f=p
m+=q*g*p}f=a7.p()
e=a7.p()
if(e>=8192)throw A.h(A.m("Error in header for PIZ-compressed data (invalid bitmap size)."))
d=new Uint8Array(8192)
if(f<=e){c=a7.ai(e-f+1)
b=c.c-c.d
for(a=f,l=0;l<b;++l,a=a0){a0=a+1
q=J.d(c.a,c.d+l)
if(!(a<8192))return A.a(d,a)
d[a]=q}}a1=new Uint16Array(65536)
a2=a5.kz(d,a1)
A.oz(a7,a7.k(),a5.z,m)
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
A.oC(p,g+a,a3,q,a4,a3*q,a2);++a}}q=a5.z
q.toString
a5.ih(a1,q,m)
q=a5.r
if(q==null){q=a5.w
q.toString
q=a5.r=A.a7(!1,q*a5.x+73728)}q.a=0
for(;a9<=r;++a9)for(l=0;l<n;++l){q=a5.y
q===$&&A.c(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
q=j.e
q===$&&A.c("ys")
if(B.a.a9(a9,q)!==0)continue
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
return J.D(B.d.gB(q.c),0,q.a)},
cB(a,b,c){return this.bu(a,b,c,null,null)},
ih(a,b,c){var s,r,q,p=t.L
p.a(a)
p.a(b)
for(p=b.length,s=b.$flags|0,r=0;r<c;++r){if(!(r<p))return A.a(b,r)
q=b[r]
if(!(q>=0&&q<65536))return A.a(a,q)
q=a[q]
s&2&&A.b(b)
b[r]=q}},
kz(a,b){var s,r,q,p,o,n
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
A.f6.prototype={}
A.fX.prototype={
cW(){return this.x},
bu(a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.F.c4(a4.a4()),a3=a1.y
if(a3==null){a3=a1.w
a3.toString
a3=a1.y=A.a7(!1,a1.x*a3)}a3.a=0
s=A.j([0,0,0,0],t.t)
r=new Uint32Array(1)
q=J.D(B.o.gB(r),0,null)
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
if(B.a.a9(a6,g)!==0)continue
g=h.f
g===$&&A.c("xSampling")
f=B.a.aw(a5,g)
e=B.a.aw(p,g)
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
return J.D(B.d.gB(a3.c),0,a3.a)},
cB(a,b,c){return this.bu(a,b,c,null,null)}}
A.fY.prototype={
cW(){return 1},
bu(a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a0.c,a=A.a7(!1,(b-a0.d)*2)
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
p=$.as()
p.$flags&2&&A.b(p)
p[0]=q
q=$.aB()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0){n=-o
for(;m=n-1,n>0;n=m)a.m(J.d(a0.a,a0.d++))}else for(n=o;m=n-1,n>=0;n=m)a.m(J.d(a0.a,a0.d++))}l=J.D(B.d.gB(a.c),0,a.a)
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
cB(a,b,c){return this.bu(a,b,c,null,null)},
D(a){return A.z(this.w)}}
A.e4.prototype={
cW(){return this.x},
bu(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=B.F.c4(a.a4())
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
cB(a,b,c){return this.bu(a,b,c,null,null)},
D(a){return A.z(this.w)}}
A.is.prototype={
ap(a){var s=this.a
if(s==null)return null
s=s.c
if(!(a<s.length))return A.a(s,a)
return s[a].b},
b9(a,b){var s=new A.fC(A.j([],t.dw))
s.hU(a)
this.a=s
return this.ap(0)}}
A.dS.prototype={
l6(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
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
ei(){var s,r,q,p,o,n,m,l=this
if(l.c==null)return l.d
s=l.d
r=s.a
q=new A.aL(new Uint8Array(r*4),r,4)
for(p=0;p<r;++p){o=s.b1(p)
n=s.b0(p)
m=s.b_(p)
q.d2(p,o,n,m,p===l.c?0:255)}return q}}
A.dT.prototype={
hW(a){var s,r,q,p,o,n,m=this
m.a=a.p()
m.b=a.p()
m.c=a.p()
m.d=a.p()
s=a.G()
m.e=(s&64)!==0
if((s&128)!==0){m.f=A.mp(B.a.S(1,(s&7)+1))
for(r=0;q=m.f,r<q.b;++r){p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n=J.d(a.a,a.d++)
q.d.b4(r,p,o,n)}}m.y=a.d-a.b}}
A.fZ.prototype={}
A.dU.prototype={$iL:1}
A.iy.prototype={
b7(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.f=A.v(a,!1,null,0)
i.a=new A.dU(A.j([],t.c))
if(!i.f6())return null
try{while(p=i.f,o=p.d,o<p.c){n=p.a
p.d=o+1
s=J.d(n,o)
switch(s){case 44:r=i.fD()
if(r==null){p=i.a
return p}p=r
p.r=i.e
p.w=i.c
if(i.b!==0){if(r.f==null&&i.a.e!=null){p=i.a.e
o=p.a
n=p.b
m=p.c
p=p.d
r.f=new A.dS(o,n,m,new A.aL(new Uint8Array(A.q(p.c)),p.a,p.b))}if(r.f!=null)r.f.c=i.d}B.c.C(i.a.r,r)
break
case 33:p=i.f
q=J.d(p.a,p.d++)
if(J.c9(q,255)){p=i.f
if(p.al(J.d(p.a,p.d++))==="NETSCAPE2.0"){l=J.d(p.a,p.d++)
k=J.d(p.a,p.d++)
if(l===3&&k===1)i.r=p.p()}else i.dl()}else if(J.c9(q,249)){p=i.f
p.toString
i.kg(p)}else i.dl()
break
case 59:p=i.a
return p
default:break}}}catch(j){}return i.a},
kg(a){var s,r,q,p=this
a.G()
s=a.G()
p.e=a.p()
p.d=a.G()
a.G()
p.c=B.a.j(s,2)&7
p.b=s&1
r=a.d3(1,0)
if(J.d(r.a,r.d)===44){++a.d
q=p.fD()
if(q==null)return
q.r=p.e
q.w=p.c
r=p.b!==0
q.x=r?p.d:-1
if(r){r=q.f
if(r==null&&p.a.e!=null){r=p.a.e
r.toString
r=q.f=A.oH(r)}if(r!=null)r.c=p.d}B.c.C(p.a.r,q)}},
ap(a){var s,r,q,p=this,o=p.f
if(o==null||p.a==null)return null
s=p.a.r
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.c("_inputPosition")
o.d=s
return p.iR(q)},
b9(a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null
if(a5.b7(a7)==null)return a6
s=a5.a.r.length
if(s===1)return a5.ap(0)
for(s=t.p,r=a6,q=r,p=0;o=a5.a.r,p<o.length;++p){a8=o[p]
n=a5.ap(p)
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
if(o){q.aL(n)
r=n
continue}g=a8.f
if(!(g!=null)){o=a5.a.e
o.toString
g=o}o=j?a6:k.a
if(o==null)o=0
m=j?a6:k.b
if(m==null)m=0
f=A.P(a6,a6,B.e,0,B.j,m,a6,0,1,g.ei(),B.e,o,!1)
o=a8.w
if(o===2){o=f.a
e=o==null?a6:J.aC(o.gB(o))
if(e==null){o=f.a
o=o==null?a6:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
e=J.aC(o)}o=a8.x
m=e.length-1
if(o!==-1)B.d.aD(e,0,m,o)
else{o=a5.a.c.a
l=o.length
if(l!==0){if(0>=l)return A.a(o,0)
o=o[0]}else o=0
B.d.aD(e,0,m,o)}}else if(o!==3)if(a8.f!=null){o=r.a
d=o==null?a6:o.gN()
c=A.I(s,s)
for(o=d.a,b=0;b<o;++b)c.h(0,b,g.l6(d.b1(b),d.b0(b),d.b_(b),d.b6(b)))
o=f.a
a=o==null?a6:J.aC(o.gB(o))
if(a==null){o=f.a
o=o==null?a6:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
a=J.aC(o)}o=r.a
a0=o==null?a6:J.aC(o.gB(o))
if(a0==null){o=r.a
o=o==null?a6:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
a0=J.aC(o)}for(a1=a.length,o=a0.length,m=a.$flags|0,a2=0;a2<a1;++a2){if(!(a2<o))return A.a(a0,a2)
a3=c.l(0,a0[a2])
if(a3!=null&&a3!==-1){m&2&&A.b(a)
a[a2]=a3}}}f.y=n.y
for(o=n.a,o=o.gH(o);o.E();){a4=o.gP()
if(a4.gA()!==0){m=a4.gaZ()
l=a8.a
l===$&&A.c("x")
k=a4.gaU()
j=a8.b
j===$&&A.c("y")
f.c8(m+l,k+j,a4)}}q.aL(f)
r=f}return q},
fD(){var s,r=this.f
if(r.d>=r.c)return null
s=new A.fZ()
s.hW(r);++this.f.d
this.dl()
return s},
iR(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=null
if(i.w==null){i.w=new Uint8Array(256)
i.x=new Uint8Array(4095)
i.y=new Uint8Array(4096)
i.z=new Uint32Array(4096)}s=i.Q=i.f.G()
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
B.o.aD(s,0,4096,4098)
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
n=A.P(h,h,B.e,0,B.j,r,h,0,1,o.ei(),B.e,s,!1)
m=new Uint8Array(s)
s=a.e
s===$&&A.c("interlaced")
if(s){s=a.b
s===$&&A.c("y")
for(r=s+r,l=0,k=0;l<4;++l)for(j=s+B.dC[l];j<r;j+=B.f_[l],++k){if(!i.f7(m))return n
i.fK(n,j,o,m)}}else for(j=0;j<r;++j){if(!i.f7(m))return n
i.fK(n,j,o,m)}return n},
fK(a,b,c,d){var s,r,q,p=d.length
for(s=0;s<p;++s){r=d[s]
q=a.a
if(q!=null)q.aa(s,b,r,0,0)}},
f6(){var s,r,q,p,o,n=this,m=n.f.al(6)
if(m!=="GIF87a"&&m!=="GIF89a")return!1
s=n.a
s.toString
s.a=n.f.p()
s=n.a
s.toString
s.b=n.f.p()
r=n.f.G()
s=n.a
s.toString
s.c=new A.bO(new Uint8Array(A.q(A.j([n.f.G()],t.t))));++n.f.d
if((r&128)!==0){s=n.a
s.toString
s.e=A.mp(B.a.S(1,(r&7)+1))
for(q=0;q<n.a.e.b;++q){s=n.f
p=J.d(s.a,s.d++)
s=n.f
o=J.d(s.a,s.d++)
s=n.f
r=J.d(s.a,s.d++)
n.a.e.d.b4(q,p,o,r)}}n.a.toString
return!0},
f7(a){var s=this,r=s.as
r.toString
s.as=r-a.length
if(!s.j1(a))return!1
if(s.as===0)s.dl()
return!0},
dl(){var s,r,q,p=this.f
if(p.d>=p.c)return!0
s=p.G()
for(;;){if(s!==0){p=this.f
p=p.d<p.c}else p=!1
if(!p)break
p=this.f
r=p.d+=s
if(r>=p.c)return!0
q=p.a
p.d=r+1
s=J.d(q,r)}return!0},
j1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_stack",e="_suffix",d=g.ay
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
r=p}}for(d=a.$flags|0;r<s;){n=g.ch=g.j0()
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
o=g.dS(q,n,o)
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
q=g.dS(o,q,i)
j.$flags&2&&A.b(j)
j[l]=q}else{j===$&&A.c(e)
k.toString
q=g.dS(o,k,i)
j.$flags&2&&A.b(j)
j[l]=q}}q=g.ch
q.toString
g.CW=q}}return!0},
j0(){var s,r,q,p,o=this
if(o.cy>12)return null
while(s=o.ax,r=o.cy,s<r){s=o.im()
s.toString
r=o.at
q=o.ax
o.at=(r|B.a.V(s,q))>>>0
o.ax=q+8}q=o.at
if(!(r>=0&&r<13))return A.a(B.bB,r)
p=B.bB[r]
o.at=B.a.a7(q,r)
o.ax=s-r
s=o.db
if(s<4097){++s
o.db=s
s=s>o.cx&&r<12}else s=!1
if(s){o.cx=o.cx<<1>>>0
o.cy=r+1}return q&p},
dS(a,b,c){var s,r,q=0
for(;;){if(b>c){s=q+1
r=q<=4095
q=s}else r=!1
if(!r)break
if(b>4095)return 4098
a.toString
if(!(b>=0))return A.a(a,b)
b=a[b]}return b},
im(){var s,r,q=this,p=q.w,o=p[0],n=p.$flags|0
if(o===0){o=q.f.G()
n&2&&A.b(p)
p[0]=o
p=q.w
o=p[0]
if(o===0)return null
B.d.bD(p,1,1+o,q.f.ai(o).a4())
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
A.iz.prototype={
gfz(){return B.da},
fX(a,b){var s,r,q,p=this
if(p.id==null){p.id=A.a7(!1,8192)
if(!a.gaN()){s=A.lh(a,256,10)
p.as=s
p.z=A.nE(a,B.aG,s,p.gfz(),1)}else p.z=a
p.Q=b
p.at=a.gR()
p.ax=a.gK()
return}if(p.ay===0){s=p.at
s===$&&A.c("_width")
r=p.ax
r===$&&A.c("_height")
p.fU(s,r)
p.fP()}s=p.z
s.toString
p.fT(s)
s=p.z
s.toString
r=p.at
r===$&&A.c("_width")
q=p.ax
q===$&&A.c("_height")
p.ey(s,r,q);++p.ay
if(!a.gaN()){s=A.lh(a,256,10)
p.as=s
p.z=A.nE(a,B.aG,s,p.gfz(),1)}else p.z=a
p.Q=b},
aL(a){return this.fX(a,null)},
dt(){var s,r,q,p,o=this
if(o.id==null)return null
if(o.ay===0){s=o.at
s===$&&A.c("_width")
r=o.ax
r===$&&A.c("_height")
o.fU(s,r)
o.fP()}s=o.z
s.toString
o.fT(s)
s=o.z
s.toString
r=o.at
r===$&&A.c("_width")
q=o.ax
q===$&&A.c("_height")
o.ey(s,r,q)
o.id.m(59)
o.as=o.z=null
o.ay=0
q=o.id
p=J.D(B.d.gB(q.c),0,q.a)
o.id=null
return p},
bH(a){var s,r,q,p=this,o=a.gaj().length
if(o<=1){p.aL(a)
o=p.dt()
o.toString
return o}p.b=a.r
for(o=a.gaj(),s=o.length,r=0;r<o.length;o.length===s||(0,A.U)(o),++r){q=o[r]
p.fX(q,B.a.W(q.y,10))}o=p.dt()
o.toString
return o},
ey(a,b,c){var s,r,q,p,o,n,m,l,k,j
if(!a.gaN())throw A.h(A.m("GIF can only encode palette images."))
s=a.a
r=s==null?null:s.gN()
q=r.a
p=this.id
p.m(44)
p.a1(0)
p.a1(0)
p.a1(b)
p.a1(c)
o=J.D(r.gB(r),0,null)
p.m(135)
n=r.b
if(n===3)p.a0(o)
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
p.m(0)}this.ja(a,b,c)},
ja(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d={}
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
o=new A.iA(d,p)
n=o.$0()
for(m=0,l=5003;l<65536;l*=2)++m
m=8-m
for(k=0;k<5003;++k)s[k]=-1
e.cI(e.dy)
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
if(j)break}e.cI(n)
q=e.fr
if(q<4096){e.fr=q+1
r[k]=q
s[k]=h}else{for(k=0;k<5003;++k)s[k]=-1
q=e.dy
e.fr=q+2
e.fx=!0
e.cI(q)}f=o.$0()
n=i
i=f}}e.cI(n)
e.cI(e.db)
e.id.m(0)},
cI(a){var s,r=this,q=r.ch,p=r.CW
if(!(p>=0&&p<17))return A.a(B.c1,p)
q&=B.c1[p]
r.ch=q
if(p>0){q=(q|B.a.S(a,p))>>>0
r.ch=q}else{r.ch=a
q=a}p+=r.cx
r.CW=p
while(p>=8){r.eA(q&255)
q=B.a.j(r.ch,8)
r.ch=q
p=r.CW-=8}if(r.fr>r.dx||r.fx)if(r.fx){s=r.cy
r.cx=s
r.dx=B.a.S(1,s)-1
r.fx=!1}else{s=++r.cx
if(s===12)r.dx=4096
else r.dx=B.a.S(1,s)-1}if(a===r.db){while(p>0){r.eA(q&255)
q=B.a.j(r.ch,8)
r.ch=q
p=r.CW-=8}r.fQ()}},
fQ(){var s,r=this,q=r.go
if(q>0){r.id.m(q)
q=r.id
q.toString
s=r.fy
s===$&&A.c("_block")
q.hw(s,r.go)
r.go=0}},
eA(a){var s,r,q=this,p=q.fy
p===$&&A.c("_block")
s=q.go
r=s+1
q.go=r
p.$flags&2&&A.b(p)
if(!(s<256))return A.a(p,s)
p[s]=a
if(r>=254)q.fQ()},
fP(){var s,r=this
r.id.m(33)
r.id.m(255)
r.id.m(11)
r.id.a0(new A.an("NETSCAPE2.0"))
s=r.id
s.toString
s.a0(A.j([3,1],t.t))
r.id.a1(r.b)
r.id.m(0)},
fT(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
h.id.m(33)
h.id.m(249)
h.id.m(4)
s=a.a
r=s==null?null:s.gN()
q=r.b
p=q-1
o=0
n=0
if(q===4||q===2){m=J.D(r.gB(r),0,null)
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
fU(a,b){var s=this
s.id.a0(new A.an("GIF89a"))
s.id.a1(a)
s.id.a1(b)
s.id.m(0)
s.id.m(0)
s.id.m(0)}}
A.iA.prototype={
$0(){var s,r,q=this.a
if(q.a)return-1
s=this.b
r=A.o(s.gP().gT())
if(!s.E())q.a=!0
return r},
$S:24}
A.cZ.prototype={
a6(){return"IcoType."+this.b}}
A.fL.prototype={$iL:1}
A.fM.prototype={}
A.fJ.prototype={
gK(){return B.a.W(A.bs.prototype.gK.call(this),2)},
gcT(){return!(this.d===40&&this.f===32)&&A.bs.prototype.gcT.call(this)}}
A.iC.prototype={
b9(a,b){var s,r,q,p=this,o=A.v(a,!1,null,0)
p.a=o
s=p.b=A.mr(o)
if(s==null)return null
o=s.e.length
if(o===1)return p.ap(0)
for(r=null,q=0;q<p.b.e.length;++q){b=p.ap(q)
if(b==null)continue
if(r==null){b.w=B.j
r=b}else r.aL(b)}return r},
ap(b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=null,a9=this.a
if(a9!=null){s=this.b
s=s==null||b0>=s.d}else s=!0
if(s)return a8
s=this.b.e
if(!(b0<s.length))return A.a(s,b0)
r=s[b0]
s=a9.a
a9=a9.b+r.e
q=r.d
p=J.l4(s,a9,a9+q)
o=new A.hm(A.mD())
t.D.a(p)
if(o.bz(p))return o.c3(p)
n=A.a7(!1,14)
n.a1(19778)
n.I(q)
n.I(0)
n.I(0)
a9=A.v(p,!1,a8,0)
s=A.mc(A.v(J.D(B.d.gB(n.c),0,n.a),!1,a8,0))
q=a9.d
m=a9.k()
l=a9.k()
k=$.O()
k.$flags&2&&A.b(k)
k[0]=l
l=$.a9()
if(0>=l.length)return A.a(l,0)
j=l[0]
k[0]=a9.k()
l=l[0]
i=a9.p()
h=a9.p()
g=a9.k()
if(g>=14)A.az(A.m("Unsupported BMP compression type: "+g))
if(!(g<14))return A.a(B.av,g)
g=B.av[g]
a9.k()
k[0]=a9.k()
k[0]=a9.k()
k=a9.k()
a9.k()
f=new A.fJ(s,j,l,m,i,h,g,k,q)
f.ev(a9,s)
if(m!==40&&i!==1)return a8
e=k===0&&h<=8?40+4*B.a.S(1,h):40+4*k
s.b=e
n.a-=4
n.I(e)
d=A.v(p,!1,a8,0)
c=new A.ip(!0)
c.a=d
c.b=f
b=c.ap(0)
if(h>=32)return b
a=32-B.a.a9(j,32)
a0=B.a.W(a===32?j:j+a,8)
for(a9=l<0,s=l===0,l=1/l<0,a1=0;a1<B.a.W(A.bs.prototype.gK.call(f),2);++a1){if(!(s?l:a9))a2=a1
else{q=b.a
q=q==null?a8:q.b
a2=(q==null?0:q)-1-a1}a3=d.am(a0)
d.d=d.d+(a3.c-a3.d)
q=b.a
a4=q==null?a8:q.O(0,a2,a8)
if(a4==null)a4=new A.C()
for(a5=0;a5<j;){a6=J.d(a3.a,a3.d++)
a7=7
for(;;){if(!(a7>-1&&a5<j))break
if((a6&B.a.V(1,a7))>>>0!==0)a4.sA(0)
a4.E();++a5;--a7}}}return b}}
A.jS.prototype={
bH(a){var s=a.gaj().length
if(s>1)return this.hf(a.gaj())
else return this.hf(A.j([a],t.g))},
hf(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null
t.gX.a(a)
s=a.length
r=A.a7(!1,8192)
r.a1(0)
r.a1(1)
r.a1(s)
q=6+s*16
p=A.j([A.j([],t.t)],t.S)
for(o=a.length,n=0,m=0;m<a.length;a.length===o||(0,A.U)(a),++m){l=a[m]
k=l.a
j=k==null
i=j?g:k.a
if((i==null?0:i)<=256){i=j?g:k.b
i=(i==null?0:i)>256}else i=!0
if(i)throw A.h(A.ml("ICO and CUR support only sizes until 256"))
k=j?g:k.a
r.m(k==null?0:k)
k=l.a
k=k==null?g:k.b
r.m(k==null?0:k)
r.m(0)
r.m(0)
r.a1(0)
r.a1(32)
h=new A.hn().bH(l)
k=h.length
r.I(k)
r.I(q)
q+=k;++n
B.c.C(p,h)}for(o=p.length,m=0;m<p.length;p.length===o||(0,A.U)(p),++m)r.a0(p[m])
return J.D(B.d.gB(r.c),0,r.a)}}
A.fK.prototype={}
A.fr.prototype={}
A.bR.prototype={}
A.cd.prototype={}
A.dY.prototype={}
A.kD.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-a,b,c,d,e)},
$S:4}
A.kE.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-a,this.c-b,c,d,e)},
$S:4}
A.kF.prototype={
$5(a,b,c,d,e){return this.a.aa(a,this.b-b,c,d,e)},
$S:4}
A.kG.prototype={
$5(a,b,c,d,e){return this.a.aa(b,a,c,d,e)},
$S:4}
A.kH.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-b,a,c,d,e)},
$S:4}
A.kI.prototype={
$5(a,b,c,d,e){return this.a.aa(this.b-b,this.c-a,c,d,e)},
$S:4}
A.kJ.prototype={
$5(a,b,c,d,e){return this.a.aa(b,this.b-a,c,d,e)},
$S:4}
A.iP.prototype={}
A.bV.prototype={}
A.iR.prototype={
lH(a){var s,r,q,p,o,n=this,m=A.v(t.L.a(a),!0,null,0)
n.a=m
s=m.d3(2,0)
if(J.d(s.a,s.d)!==255||J.d(s.a,s.d+1)!==216)return!1
if(n.cs()!==216)return!1
r=n.cs()
q=!1
p=!1
for(;;){if(r!==217){m=n.a
m=m.d<m.c}else m=!1
if(!m)break
o=n.a.p()
if(o<2)break
m=n.a
m.d=m.d+(o-2)
switch(r){case 192:case 193:case 194:q=!0
break
case 218:p=!0
break}r=n.cs()}return q&&p},
cm(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
h.a=A.v(t.L.a(a),!0,null,0)
h.k9()
if(h.y.length!==1)throw A.h(A.m("Only single frame JPEGs supported"))
s=h.d
for(r=s.z,q=s.y,p=h.as,o=0;o<r.length;++o){n=q.l(0,r[o])
m=n.a
l=s.f
k=n.b
j=s.r
i=h.ip(s,n)
if(m===l)m=0
else m=m===1&&l===4?2:1
if(k===j)l=0
else l=k===1&&j===4?2:1
B.c.C(p,new A.fr(i,m,l))}},
k9(){var s,r,q,p,o,n,m=this
if(m.cs()!==216)throw A.h(A.m("Start Of Image marker not found."))
s=m.cs()
for(;;){if(s!==217){r=m.a
r===$&&A.c("input")
r=r.d<r.c}else r=!1
if(!r)break
r=m.a
r===$&&A.c("input")
q=r.p()
if(q<2)A.az(A.m("Invalid Block"))
r=m.a
p=r.am(q-2)
o=r.d=r.d+(p.c-p.d)
switch(s){case 224:case 225:case 226:case 227:case 228:case 229:case 230:case 231:case 232:case 233:case 234:case 235:case 236:case 237:case 238:case 239:case 254:m.ka(s,p)
break
case 219:m.kd(p)
break
case 192:case 193:case 194:m.kf(s,p)
break
case 195:case 197:case 198:case 199:case 200:case 201:case 202:case 203:case 205:case 206:case 207:throw A.h(A.m("Unhandled frame type "+B.a.dw(s,16)))
case 196:m.kc(p)
break
case 221:m.e=p.p()
break
case 218:m.ks(p)
break
case 255:if(J.d(r.a,o)!==255)--m.a.d
break
default:n=!1
if(J.d(r.a,o+-3)===255){r=m.a
if(J.d(r.a,r.d+-2)>=192){r=m.a
r=J.d(r.a,r.d+-2)<=254}else r=n}else r=n
if(r){m.a.d-=3
break}if(s!==0)throw A.h(A.m("Unknown JPEG marker "+B.a.dw(s,16)))
break}s=m.cs()}},
cs(){var s,r=this,q=r.a
q===$&&A.c("input")
if(q.d>=q.c)return 0
do{do{s=r.a.G()
if(s!==255){q=r.a
q=q.d<q.c}else q=!1}while(q)
q=r.a
if(q.d>=q.c)return s
do{s=r.a.G()
if(s===255){q=r.a
q=q.d<q.c}else q=!1}while(q)
if(s===0){q=r.a
q=q.d<q.c}else q=!1}while(q)
return s},
kk(a){var s
for(s=0;s<12;++s)if(J.d(a.a,a.d++)!==B.ks[s])return
this.r=new A.cY("ICC_PROFILE",B.aL,a.a4())},
ke(a){if(a.k()!==1165519206)return
if(a.p()!==0)return
this.w.cm(a)},
ka(a,b){var s,r,q,p,o,n=this,m=b
if(a===224){s=m
r=!1
if(J.d(s.a,s.d)===74){s=m
if(J.d(s.a,s.d+1)===70){s=m
if(J.d(s.a,s.d+2)===73){s=m
if(J.d(s.a,s.d+3)===70){s=m
s=J.d(s.a,s.d+4)===0}else s=r}else s=r}else s=r}else s=r
if(s){s=new A.iT()
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
m.d3(14+3*r*q,14)}}else if(a===225)n.ke(m)
else if(a===226)n.kk(m)
else if(a===238){s=m
r=!1
if(J.d(s.a,s.d)===65){s=m
if(J.d(s.a,s.d+1)===100){s=m
if(J.d(s.a,s.d+2)===111){s=m
if(J.d(s.a,s.d+3)===98){s=m
if(J.d(s.a,s.d+4)===101){s=m
s=J.d(s.a,s.d+5)===0}else s=r}else s=r}else s=r}else s=r}else s=r
if(s){p=new A.iP()
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
n.c=p}}else if(a===254)try{m.lt()}catch(o){}},
kd(a){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=this.x;q=a.d,p=q<s,p;){p=a.a
a.d=q+1
o=J.d(p,q)
n=B.a.j(o,4)
o&=15
if(o>=4)throw A.h(A.m("Invalid number of quantization tables"))
if(r[o]==null)B.c.h(r,o,new Int16Array(64))
m=r[o]
for(q=n!==0,l=0;l<64;++l){k=q?a.p():J.d(a.a,a.d++)
m.toString
p=$.ia()
if(!(l<p.length))return A.a(p,l)
p=p[l]
m.$flags&2&&A.b(m)
if(!(p<64))return A.a(m,p)
m[p]=k}}if(p)throw A.h(A.m("Bad length for DQT block"))},
kf(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
if(i.d!=null)throw A.h(A.m("Duplicate JPG frame data found."))
s=A.I(t.p,t.d2)
r=A.j([],t.t)
q=new A.h8(s,r)
q.b=a===194
q.c=b.G()
q.d=b.p()
q.e=b.p()
p=b.G()
for(o=i.x,n=0;n<p;++n){m=J.d(b.a,b.d++)
l=J.d(b.a,b.d++)
k=B.a.j(l,4)
j=J.d(b.a,b.d++)
B.c.C(r,m)
s.h(0,m,new A.bV(k&15,l&15,o,j))}q.lm()
i.d=q
B.c.C(i.y,q)},
kc(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.c,r=this.Q,q=this.z;p=a.d,p<s;){o=a.a
a.d=p+1
n=J.d(o,p)
m=new Uint8Array(16)
for(l=0,k=0;k<16;++k){p=J.d(a.a,a.d++)
if(!(k<16))return A.a(m,k)
m[k]=p
l+=m[k]}j=a.am(l)
a.d=a.d+(j.c-j.d)
i=j.a4()
if((n&16)!==0){n-=16
h=q}else h=r
if(h.length<=n)B.c.sv(h,n+1)
B.c.h(h,n,this.jI(m,i))}},
ks(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a.G()
if(b<1||b>4)throw A.h(A.m("Invalid SOS block"))
s=c.d
s.toString
r=A.j([],t.b7)
for(q=c.z,p=c.Q,o=s.y,n=t.g8,m=0;m<b;++m){l=J.d(a.a,a.d++)
k=J.d(a.a,a.d++)
if(!o.a8(l))throw A.h(A.m("Invalid Component in SOS block"))
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
j.x=n.a(g)}B.c.C(r,j)}f=a.G()
e=a.G()
d=a.G()
q=B.a.j(d,4)
p=c.a
p===$&&A.c("input")
q=new A.h9(p,s,r,c.e,f,e,q&15,d&15)
p=s.w
p===$&&A.c("mcusPerLine")
q.f=p
q.r=s.b
q.bS()},
jI(a,b){var s,r,q,p,o,n,m,l,k=A.j([],t.e8),j=16
for(;;){if(!(j>0&&a[j-1]===0))break;--j}s=t.fe
B.c.C(k,new A.dz(A.F(2,null,!1,s)))
if(0>=k.length)return A.a(k,0)
r=k[0]
for(q=b.length,p=0,o=0;o<j;){for(n=0;n<a[o];++n){if(0>=k.length)return A.a(k,-1)
r=k.pop()
m=r.b
if(!(p>=0&&p<q))return A.a(b,p)
B.c.h(r.a,m,new A.dY(b[p]))
while(m=r.b,m>0){if(0>=k.length)return A.a(k,-1)
r=k.pop()}r.b=m+1
B.c.C(k,r)
for(;k.length<=o;r=l){m=A.F(2,null,!1,s)
l=new A.dz(m)
B.c.C(k,l)
B.c.h(r.a,r.b,new A.cd(m))}++p}++o
if(o<j){m=A.F(2,null,!1,s)
l=new A.dz(m)
B.c.C(k,l)
B.c.h(r.a,r.b,new A.cd(m))
r=l}}if(0>=k.length)return A.a(k,0)
return k[0].a},
ip(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a1.e
a===$&&A.c("blocksPerLine")
s=a1.f
s===$&&A.c("blocksPerColumn")
r=a<<3>>>0
q=new Int32Array(64)
p=new Uint8Array(64)
o=s*8
n=A.F(o,null,!1,t.aD)
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
A.td(e,d[f],p,q)
c=f<<3>>>0
for(e=c+8,b=0;b<8;++b){d=i+b
if(!(d<o))return A.a(n,d)
d=n[d]
if(d!=null)B.d.au(d,c,e,p,b<<3>>>0)}}}return n}}
A.dz.prototype={}
A.h8.prototype={
lm(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this
for(s=a.y,r=A.l(s).q("Q<1>"),q=new A.Q(s,s.r,s.e,r);q.E();){p=s.l(0,q.d)
a.f=Math.max(a.f,p.a)
a.r=Math.max(a.r,p.b)}q=a.e
q.toString
a.w=B.b.be(q/8/a.f)
q=a.d
q.toString
a.x=B.b.be(q/8/a.r)
for(r=new A.Q(s,s.r,s.e,r),q=t.fv,o=t.k,n=t.f0;r.E();){m=s.l(0,r.d)
m.toString
l=a.e
l.toString
k=m.a
j=B.b.be(B.b.be(l/8)*k/a.f)
l=a.d
l.toString
i=m.b
h=B.b.be(B.b.be(l/8)*i/a.r)
g=a.w*k
f=a.x*i
e=J.ao(f,n)
for(d=0;d<f;++d){c=J.ao(g,o)
for(b=0;b<g;++b)c[b]=new Int32Array(64)
e[d]=c}m.e=j
m.f=h
m.r=q.a(e)}}}
A.iT.prototype={}
A.h9.prototype={
bS(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a="blocksPerLine",a0=b.y,a1=a0.length,a2=b.r
a2.toString
if(a2)if(b.Q===0)s=b.at===0?b.giN():b.giP()
else s=b.at===0?b.giE():b.giG()
else s=b.giK()
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
for(r=b.a,q=t.fb,o=0;o<p;){for(n=0;n<a1;++n){if(!(n<a0.length))return A.a(a0,n)
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
j=B.a.aw(o,k)
i=B.a.a9(o,k)
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
for(f=0;f<g;++f)for(e=0;e<h;++e)b.iS(m,s,o,f,e)}++o;++l}}b.ch=0
if(o>=p)break
d=J.d(r.a,r.d)
c=J.d(r.a,r.d+1)
if(d===255)if(c>=208&&c<=215)r.d+=2
else break}},
cf(){var s,r=this,q=r.ch
if(q>0){--q
r.ch=q
return B.a.aW(r.ay,q)&1}q=r.a
if(q.d>=q.c)return null
s=q.G()
r.ay=s
if(s===255)if(q.G()!==0)return null
r.ch=7
return B.a.j(r.ay,7)&1},
cH(a){var s,r,q=new A.cd(t.g8.a(a))
while(s=this.cf(),s!=null){if(q instanceof A.cd){r=q.a
if(s>>>0!==s||s>=2)return A.a(r,s)
q=r[s]}if(q instanceof A.dY)return q.a}return null},
e1(a){var s,r
for(s=0;a>0;){r=this.cf()
if(r==null)return null
s=(s<<1|r)>>>0;--a}return s},
cL(a){var s
if(a==null)return 0
if(a===1)return this.cf()===1?1:-1
s=this.e1(a)
if(s==null)return 0
if(s>=B.a.V(1,a-1))return s
return s+B.a.S(-1,a)+1},
iL(a,b){var s,r,q,p,o,n,m,l,k=this
t.L.a(b)
s=a.w
s===$&&A.c("huffmanTableDC")
r=k.cH(s)
q=r===0?0:k.cL(r)
s=a.y
s===$&&A.c("pred")
s+=q
a.y=s
b.$flags&2&&A.b(b)
b[0]=s
for(p=1;p<64;){s=a.x
s===$&&A.c("huffmanTableAC")
o=k.cH(s)
if(o==null)break
n=o&15
m=o>>>4
if(n===0){if(m<15)break
p+=16
continue}p+=m
n=k.cL(n)
s=$.ia()
if(!(p>=0&&p<s.length))return A.a(s,p)
l=s[p]
b.$flags&2&&A.b(b)
if(!(l<64))return A.a(b,l)
b[l]=n;++p}},
iO(a,b){var s,r,q
t.L.a(b)
s=a.w
s===$&&A.c("huffmanTableDC")
r=this.cH(s)
q=r===0?0:B.a.S(this.cL(r),this.ax)
s=a.y
s===$&&A.c("pred")
s+=q
a.y=s
b.$flags&2&&A.b(b)
b[0]=s},
iQ(a,b){var s,r
t.L.a(b)
s=b[0]
r=this.cf()
r.toString
r=B.a.S(r,this.ax)
b.$flags&2&&A.b(b)
b[0]=(s|r)>>>0},
iF(a,b){var s,r,q,p,o,n,m,l,k=this
t.L.a(b)
s=k.CW
if(s>0){k.CW=s-1
return}r=k.Q
q=k.as
for(s=k.ax;r<=q;){p=a.x
p===$&&A.c("huffmanTableAC")
p=k.cH(p)
p.toString
o=p&15
n=p>>>4
if(o===0){if(n<15){s=k.e1(n)
s.toString
k.CW=s+B.a.S(1,n)-1
break}r+=16
continue}r+=n
p=$.ia()
if(!(r>=0&&r<p.length))return A.a(p,r)
m=p[r]
p=k.cL(o)
l=B.a.S(1,s)
b.$flags&2&&A.b(b)
if(!(m<64))return A.a(b,m)
b[m]=p*l;++r}},
iH(a,b){var s,r,q,p,o,n,m,l,k,j=this
t.L.a(b)
s=j.Q
r=j.as
A:for(q=j.ax,p=0;s<=r;){o=$.ia()
if(!(s>=0&&s<o.length))return A.a(o,s)
n=o[s]
o=j.cx
switch(o){case 0:o=a.x
o===$&&A.c("huffmanTableAC")
m=j.cH(o)
if(m==null)throw A.h(A.m("Invalid progressive encoding"))
l=m&15
p=m>>>4
if(l===0)if(p<15){o=j.e1(p)
o.toString
j.CW=o+B.a.S(1,p)
j.cx=4}else{j.cx=1
p=16}else{if(l!==1)throw A.h(A.m("invalid ACn encoding"))
j.cy=j.cL(l)
j.cx=p!==0?2:3}continue A
case 1:case 2:if(!(n<64))return A.a(b,n)
k=b[n]
if(k!==0){o=j.cf()
o.toString
o=B.a.S(o,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=k+o}else{--p
if(p===0)j.cx=o===2?3:0}break
case 3:if(!(n<64))return A.a(b,n)
o=b[n]
if(o!==0){k=j.cf()
k.toString
k=B.a.S(k,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=o+k}else{o=j.cy
o===$&&A.c("successiveACNextValue")
o=B.a.S(o,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=o
j.cx=0}break
case 4:if(!(n<64))return A.a(b,n)
o=b[n]
if(o!==0){k=j.cf()
k.toString
k=B.a.S(k,q)
b.$flags&2&&A.b(b)
if(!(n<64))return A.a(b,n)
b[n]=o+k}break}++s}if(j.cx===4)if(--j.CW===0)j.cx=0},
iS(a,b,c,d,e){var s,r,q,p,o
t.fb.a(b)
s=this.f
s===$&&A.c("mcusPerLine")
r=B.a.aw(c,s)*a.b+d
q=B.a.a9(c,s)*a.a+e
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
A.h7.prototype={
bz(a){var s=a.length,r=!0
if(s>=2){if(0>=s)return A.a(a,0)
if(a[0]===255){if(1>=s)return A.a(a,1)
s=a[1]!==216}else s=r}else s=r
if(s)return!1
return A.mJ().lH(a)},
b9(a,b){var s=A.mJ()
s.cm(a)
if(s.y.length!==1)throw A.h(A.m("only single frame JPEGs supported"))
return A.rY(s)},
c3(a){return this.b9(a,null)}}
A.iQ.prototype={
a6(){return"JpegChroma."+this.b}}
A.iS.prototype={
hJ(a){a=B.a.i(B.a.L(a,1,100))
if(this.at===a)return
this.jC(a<50?B.b.bo(5000/a):B.a.bo(200-a*2))
this.at=a},
bH(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=A.a7(!0,8192)
c.bQ(b,216)
c.bQ(b,224)
b.a1(16)
b.m(74)
b.m(70)
b.m(73)
b.m(70)
b.m(0)
b.m(1)
b.m(1)
b.m(0)
b.a1(1)
b.a1(1)
b.m(0)
b.m(0)
c.kJ(b,a.gbI())
s=a.c
if(s!=null){c.bQ(b,226)
r=s.l0()
q=A.j([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
b.a1(14+r.length)
b.a0(q)
b.a0(r)}c.kI(b)
s=a.gR()
p=a.gK()
c.bQ(b,192)
b.a1(17)
b.m(8)
b.a1(p)
b.a1(s)
b.m(3)
b.m(1)
b.m(17)
b.m(0)
b.m(2)
b.m(17)
b.m(1)
b.m(3)
b.m(17)
b.m(1)
c.kH(b)
c.bQ(b,218)
b.a1(12)
b.m(3)
b.m(1)
b.m(0)
b.m(2)
b.m(17)
b.m(3)
b.m(17)
b.m(0)
b.m(63)
b.m(0)
c.ax=0
c.ay=7
o=a.gR()
n=a.gK()
m=new Float32Array(64)
l=new Float32Array(64)
k=new Float32Array(64)
for(s=c.c,p=c.d,j=0,i=0,h=0,g=0;g<n;g+=8)for(f=0;f<o;f+=8){c.iv(a,f,g,o,n,m,l,k,B.d1)
e=c.e
d=c.r
d===$&&A.c("_yacHuffman")
j=c.e_(b,m,s,j,e,d)
d=c.f
e=c.w
e===$&&A.c("_uvacHuffman")
i=c.e_(b,l,p,i,d,e)
h=c.e_(b,k,p,h,c.f,c.w)}s=c.ay
if(s>=0){++s
c.bP(b,A.j([B.a.V(1,s)-1,s],t.t))}c.bQ(b,217)
return J.D(B.d.gB(b.c),0,b.a)},
iv(a,b,c,d,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
for(s=this.as,r=c+1,q=0;q<64;++q){p=q>>>3
o=c+p
n=b+(q&7)
if(o>=a0)o-=r+p-a0
if(n>=d)n-=n-d+1
m=a.a
l=m==null?null:m.O(n,o,null)
if(l==null)l=new A.C()
if(l.gM()!==B.e)l=l.aQ(B.e)
if(l.gv(l)>3){k=l.ga_()
j=1-k
l.sn(B.b.aS(l.gn()*k+a4.l(0,0)*j))
l.st(B.b.aS(l.gt()*k+a4.l(0,1)*j))
l.su(B.b.aS(l.gu()*k+a4.l(0,2)*j))}i=B.b.i(l.gn())
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
jC(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.a,r=s.$flags|0,q=0;q<64;++q){p=B.b.bo((B.iQ[q]*a+50)/100)
if(p<1)p=1
else if(p>255)p=255
o=B.a1[q]
r&2&&A.b(s)
if(!(o<64))return A.a(s,o)
s[o]=p}for(r=b.b,o=r.$flags|0,n=0;n<64;++n){m=B.b.bo((B.eL[n]*a+50)/100)
if(m<1)m=1
else if(m>255)m=255
l=B.a1[n]
o&2&&A.b(r)
if(!(l<64))return A.a(r,l)
r[l]=m}for(o=b.c,l=o.$flags|0,k=b.d,j=k.$flags|0,i=0,h=0;h<8;++h)for(g=0;g<8;++g){if(!(i>=0&&i<64))return A.a(B.a1,i)
f=B.a1[i]
if(!(f<64))return A.a(s,f)
e=s[f]
d=B.bA[h]
c=B.bA[g]
l&2&&A.b(o)
o[i]=1/(e*d*c*8)
f=r[f]
j&2&&A.b(k)
k[i]=1/(f*d*c*8);++i}},
d7(a,b){var s,r,q,p,o,n,m,l=t.L
l.a(a)
l.a(b)
l=t.t
s=A.j([A.j([],l)],t.ca)
for(r=b.length,q=0,p=0,o=1;o<=16;++o){for(n=1;n<=a[o];++n){if(!(p>=0&&p<r))return A.a(b,p)
m=b[p]
if(s.length<=m)B.c.sv(s,m+1)
B.c.h(s,m,A.j([q,o],l));++p;++q}q*=2}return s},
jA(){var s,r,q,p,o,n,m,l,k,j,i
for(s=this.y,r=this.x,q=t.t,p=1,o=2,n=1;n<=15;++n){for(m=p;m<o;++m){l=32767+m
B.c.h(s,l,n)
B.c.h(r,l,A.j([m,n],q))}for(l=o-1,k=-l,j=-p;k<=j;++k){i=32767+k
B.c.h(s,i,n)
B.c.h(r,i,A.j([l+k,n],q))}p=p<<1>>>0
o=o<<1>>>0}},
jD(){var s,r,q
for(s=this.as,r=s.$flags|0,q=0;q<256;++q){r&2&&A.b(s)
s[q]=19595*q
s[q+256]=38470*q
s[q+512]=7471*q+32768
s[q+768]=-11059*q
s[q+1024]=-21709*q
s[q+1280]=32768*q+8421375
s[q+1536]=-27439*q
s[q+1792]=-5329*q}},
jg(d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5=t.H
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
kJ(a,b){var s,r
if(b.ghi(0))return
s=A.a7(!1,8192)
b.aY(s)
r=J.D(B.d.gB(s.c),0,s.a)
this.bQ(a,225)
a.a1(r.length+8)
a.I(1165519206)
a.a1(0)
a.a0(r)},
kI(a){var s,r,q
this.bQ(a,219)
a.a1(132)
a.m(0)
for(s=this.a,r=0;r<64;++r)a.m(s[r])
a.m(1)
for(s=this.b,q=0;q<64;++q)a.m(s[q])},
kH(a){var s,r,q,p,o,n,m,l
this.bQ(a,196)
a.a1(418)
a.m(0)
for(s=0;s<16;){++s
a.m(B.ch[s])}for(r=0;r<=11;++r)a.m(B.ag[r])
a.m(16)
for(q=0;q<16;){++q
a.m(B.br[q])}for(p=0;p<=161;++p)a.m(B.bC[p])
a.m(1)
for(o=0;o<16;){++o
a.m(B.bP[o])}for(n=0;n<=11;++n)a.m(B.ag[n])
a.m(17)
for(m=0;m<16;){++m
a.m(B.bH[m])}for(l=0;l<=161;++l)a.m(B.bZ[l])},
e_(a,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=t.H
b.a(a0)
b.a(a1)
t.fl.a(a3)
t.d.a(a4)
b=a4.length
if(0>=b)return A.a(a4,0)
s=a4[0]
if(240>=b)return A.a(a4,240)
r=a4[240]
q=c.jg(a0,a1)
for(b=c.Q,p=0;p<64;++p)B.c.h(b,B.a1[p],q[p])
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
A.df.prototype={
a6(){return"PngDisposeMode."+this.b}}
A.ez.prototype={
a6(){return"PngBlendMode."+this.b}}
A.eA.prototype={}
A.h_.prototype={}
A.bY.prototype={
a6(){return"PngFilterType."+this.b}}
A.hp.prototype={
sN(a){this.w=t.di.a(a)},
slE(a){this.x=t.T.a(a)},
$iL:1}
A.h0.prototype={}
A.hm.prototype={
bz(a){var s,r=A.v(a,!0,null,0).ai(8)
for(s=0;s<8;++s)if(J.d(r.a,r.d+s)!==B.c5[s])return!1
return!0},
b7(b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=this,b5=null,b6=A.v(b7,!0,b5,0)
b4.d=b6
s=b6.ai(8)
for(r=0;r<8;++r)if(J.d(s.a,s.d+r)!==B.c5[r])return b5
for(b6=b4.a,q=b6.cy,p=t.t,o=b6.db,n=t.L,m=b6.ax;;){l=b4.d
k=l.d-l.b
j=l.k()
i=b4.d.al(4)
switch(i){case"tEXt":l=b4.d
h=l.am(j)
l.d=l.d+(h.c-h.d)
g=h.a4()
f=g.length
for(r=0;r<f;++r)if(g[r]===0){l=r+1
m.h(0,B.b7.c3(new Uint8Array(g.subarray(0,A.ba(0,r,f)))),B.b7.c3(new Uint8Array(g.subarray(l,A.ba(l,b5,f)))))
break}b4.d.d+=4
break
case"pHYs":l=b4.d
h=l.am(j)
l.d=l.d+(h.c-h.d)
e=A.p(h,b5,0)
e.k()
e.k()
J.d(e.a,e.d++)
b4.d.d+=4
break
case"IHDR":l=b4.d
h=l.am(j)
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
switch(l){case 0:if(!B.c.ci(A.j([1,2,4,8,16],p),b6.c))return b5
break
case 2:if(!B.c.ci(A.j([8,16],p),b6.c))return b5
break
case 3:if(!B.c.ci(A.j([1,2,4,8],p),b6.c))return b5
break
case 4:if(!B.c.ci(A.j([8,16],p),b6.c))return b5
break
case 6:if(!B.c.ci(A.j([8,16],p),b6.c))return b5
break}if(b4.d.k()!==A.bo(n.a(c),A.bo(new A.an(i),0)))throw A.h(A.m("Invalid "+i+" checksum"))
break
case"PLTE":l=b4.d
h=l.am(j)
l.d=l.d+(h.c-h.d)
b6.sN(h.a4())
if(b4.d.k()!==A.bo(n.a(n.a(b6.w)),A.bo(new A.an(i),0)))throw A.h(A.m("Invalid "+i+" checksum"))
break
case"tRNS":l=b4.d
h=l.am(j)
l.d=l.d+(h.c-h.d)
b6.slE(h.a4())
b=b4.d.k()
l=b6.x
l.toString
if(b!==A.bo(n.a(l),A.bo(new A.an(i),0)))throw A.h(A.m("Invalid "+i+" checksum"))
break
case"IEND":b4.d.d+=4
break
case"gAMA":if(j!==4)throw A.h(A.m("Invalid gAMA chunk"))
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
a3=b4.d.p()
a4=b4.d.p()
l=b4.d
a5=J.d(l.a,l.d++)
l=b4.d
a6=J.d(l.a,l.d++)
if(!(a5>=0&&a5<3))return A.a(B.bq,a5)
l=B.bq[a5]
if(!(a6>=0&&a6<2))return A.a(B.bQ,a6)
a7=B.bQ[a6]
B.c.C(q,new A.h_(A.j([],p),a,a0,a1,a2,a3,a4,l,a7))
b4.d.d+=4
break
case"fdAT":b4.d.k()
B.c.C(B.c.geb(q).y,k)
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
if(l!=null){l=B.d.ci(l,a8)?0:255
a7=new Uint8Array(4)
a7[0]=b0
a7[1]=b2
a7[2]=b3
a7[3]=l
b6.z=new A.cP(a7)}else{l=new Uint8Array(3)
l[0]=b0
l[1]=b2
l[2]=b3
b6.z=new A.fq(l)}}else if(l===0||l===4){b4.d.p()
j-=2}else if(l===2||l===6){l=b4.d
l.p()
l.p()
l.p()
j-=24}if(j>0)b4.d.d+=j
b4.d.d+=4
break
case"iCCP":b6.Q=b4.d.cY()
l=b4.d
J.d(l.a,l.d++)
l=b6.Q
a7=b4.d
h=a7.am(j-(l.length+2))
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
ap(c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=null,b7=null,b8=b5.a,b9=b8.a,c0=b8.b,c1=b8.cy,c2=c1.length
if(c2===0||c3===0){r=A.j([],t.gN)
c1=b8.db
q=c1.length
for(c2=t.L,p=0,o=0;o<q;++o){n=b5.d
n===$&&A.c("_input")
if(!(o<c1.length))return A.a(c1,o)
n.d=c1[o]
m=n.k()
l=b5.d.al(4)
n=b5.d
k=n.am(m)
n.d=n.d+(k.c-k.d)
j=k.a4()
p+=j.length
B.c.C(r,j)
if(b5.d.k()!==A.bo(c2.a(j),A.bo(new A.an(l),0)))throw A.h(A.m("Invalid "+l+" checksum"))}b7=new Uint8Array(p)
for(c1=r.length,i=0,h=0;h<r.length;r.length===c1||(0,A.U)(r),++h){j=r[h]
J.ma(b7,i,j)
i+=j.length}}else{if(c3>=c2)throw A.h(A.m("Invalid Frame Number: "+c3))
if(!(c3<c2))return A.a(c1,c3)
g=c1[c3]
b9=g.b
c0=g.c
r=A.j([],t.gN)
for(c1=g.y,p=0,o=0;o<c1.length;++o){c2=b5.d
c2===$&&A.c("_input")
c2.d=c1[o]
m=c2.k()
c2=b5.d
c2.al(4)
c2.d+=4
c2=b5.d
k=c2.am(m-4)
c2.d=c2.d+(k.c-k.d)
j=k.a4()
p+=j.length
B.c.C(r,j)}b7=new Uint8Array(p)
for(c1=r.length,i=0,h=0;h<r.length;r.length===c1||(0,A.U)(r),++h){j=r[h]
J.ma(b7,i,j)
i+=j.length}}c1=b8.d
f=1
if(!(c1===3))if(!(c1===0)){if(c1===4)c1=2
else c1=c1===6?4:3
f=c1}s=null
try{s=B.F.c4(b7)}catch(e){return b6}d=A.v(s,!0,b6,0)
b5.c=b5.b=0
c=b6
if(b8.d===3){c1=b8.w
if(c1!=null){c2=c1.length
b=c2/3|0
a=b8.x
n=a!=null
a0=n?a.length:0
a1=n?4:3
c=new A.aL(new Uint8Array(b*a1),b,a1)
for(n=a1===4,o=0,a2=0;o<b;++o,a2+=3){if(n&&o<a0){if(!(o<a.length))return A.a(a,o)
a3=a[o]}else a3=255
if(!(a2<c2))return A.a(c1,a2)
a4=c1[a2]
a5=a2+1
if(!(a5<c2))return A.a(c1,a5)
a5=c1[a5]
a6=a2+2
if(!(a6<c2))return A.a(c1,a6)
c.d2(o,a4,a5,c1[a6],a3)}}}if(b8.d===0&&b8.x!=null&&c==null&&b8.c<=8){a=b8.x
a7=a.length
c1=b8.c
b=B.a.V(1,c1)
c2=b*4
n=new Uint8Array(c2)
c=new A.aL(n,b,4)
if(c1===1)a8=255
else if(c1===2)a8=85
else{c1=c1===4?17:1
a8=c1}for(o=0;o<b;++o){a9=o*a8
c.d2(o,a9,a9,a9,255)}for(o=0;o<a7;o+=2){c1=a[o]
a4=o+1
if(!(a4<a7))return A.a(a,a4)
b0=(c1&255)<<8|a[a4]&255
if(b0<b){c1=b0*4+3
if(!(c1<c2))return A.a(n,c1)
n[c1]=0}}}c1=b8.c
if(c1===1)b1=B.y
else if(c1===2)b1=B.t
else{if(c1===4)c2=B.z
else c2=c1===16?B.n:B.e
b1=c2}c2=b8.d
if(c2===0&&b8.x!=null&&c1>8)f=4
b2=A.P(b6,b6,b1,0,B.j,c0,b6,0,c2===2&&b8.x!=null?4:f,c,B.e,b9,!1)
b3=b8.a
b4=b8.b
b8.a=b9
b8.b=c0
b5.e=0
if(b8.r!==0){c1=c0+7>>>3
b5.ce(d,b2,0,0,8,8,b9+7>>>3,c1)
c2=b9+3
b5.ce(d,b2,4,0,8,8,c2>>>3,c1)
c1=c0+3
b5.ce(d,b2,0,4,4,8,c2>>>2,c1>>>3)
c2=b9+1
b5.ce(d,b2,2,0,4,4,c2>>>2,c1>>>2)
c1=c0+1
b5.ce(d,b2,0,2,2,4,c2>>>1,c1>>>2)
b5.ce(d,b2,1,0,2,2,b9>>>1,c1>>>1)
b5.ce(d,b2,0,1,1,2,b9,c0>>>1)}else b5.k_(d,b2)
b8.a=b3
b8.b=b4
c1=b8.at
if(c1!=null)b2.c=new A.cY(b8.Q,B.aM,c1)
b8=b8.ax
if(b8.a!==0)b2.kN(b8)
return b2},
b9(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null
if(b.b7(t.D.a(a0))==null)return a
s=b.a
r=s.cy
q=r.length
if(q===0){s=b.ap(0)
s.toString
return s}for(q=t.g,p=a,o=p,n=0;n<s.CW;++n){if(!(n<r.length))return A.a(r,n)
a1=r[n]
m=b.ap(n)
if(m==null)continue
if(o==null||p==null){o=m.e8(m.gaE())
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
j=j===(i==null?0:i)&&a1.d===0&&a1.e===0&&a1.x===B.cm}else j=!1
if(j){l=a1.f
m.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
o.aL(m)
p=m
continue}d=o.x
if(d===$)d=o.x=A.j([],q)
if(!(l<d.length))return A.a(d,l)
p=A.bz(d[l],!1,!1)
c=k.w
if(c===B.co){l=k.d
j=k.e
i=s.z
if(i==null){i=new Uint8Array(4)
h=new A.cP(i)
i[0]=0
i[1]=0
i[2]=0
i[3]=0
i=h}A.rR(p,!1,i,l,l+k.b-1,j,j+k.c-1)}else if(c===B.cp&&n>1){l=n-2
d=o.x
if(d===$)d=o.x=A.j([],q)
if(!(l>=0&&l<d.length))return A.a(d,l)
j=k.d
i=k.e
h=k.b
g=k.c
p=A.lT(p,d[l],B.aD,g,h,j,i,g,h,j,i)}l=a1.f
p.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
l=a1.x===B.cn?B.aD:B.aC
p=A.lT(p,m,l,a,a,a1.d,a1.e,a,a,a,a)
o.aL(p)}return o},
c3(a){return this.b9(a,null)},
ce(a4,a5,a6,a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a1.a,a3=a2.d
if(a3===4)s=2
else if(a3===2)s=3
else{a3=a3===6?4:1
s=a3}r=s*a2.c
q=B.a.j(r+7,3)
p=B.a.j(r*b0+7,3)
o=A.j([null,null],t.ff)
n=A.j([0,0,0,0],t.t)
for(a2=a8>1,m=a8-a6,l=a7,k=0,j=0;k<b1;++k,l+=a9,++a1.e){a3=J.d(a4.a,a4.d++)
if(!(a3>=0&&a3<5))return A.a(B.as,a3)
i=B.as[a3]
h=a4.am(p)
a4.d=a4.d+(h.c-h.d)
B.c.h(o,j,h.a4())
if(!(j>=0&&j<2))return A.a(o,j)
g=o[j]
j=1-j
f=o[j]
g.toString
a1.fI(i,q,g,f)
a1.c=a1.b=0
a3=g.length
e=new A.ag(g,0,Math.min(a3,a3),0,!0)
for(a3=m<=1,d=a6,c=0;c<b0;++c,d+=a8){a1.fv(e,n)
b=a5.a
b=b==null?null:b.O(d,l,null)
a1.e3(b==null?new A.C():b,n)
if(!a3||a2)for(a=0;a<a8;++a)for(b=l+a,a0=0;a0<m;++a0)a1.e3(a5.aq(d+a0,b),n)}}},
k_(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.a,a0=a.d
if(a0===4)s=2
else if(a0===2)s=3
else{a0=a0===6?4:1
s=a0}r=s*a.c
q=a.a
p=a.b
o=B.a.j(q*r+7,3)
n=B.a.j(r+7,3)
m=A.F(o,0,!1,t.p)
l=A.j([m,m],t.S)
k=A.j([0,0,0,0],t.t)
a=a2.a
j=a.gH(a)
j.E()
for(i=0,h=0;i<p;++i,h=e){a=J.d(a1.a,a1.d++)
if(!(a>=0&&a<5))return A.a(B.as,a)
g=B.as[a]
f=a1.am(o)
a1.d=a1.d+(f.c-f.d)
B.c.h(l,h,f.a4())
if(!(h>=0&&h<2))return A.a(l,h)
e=1-h
b.fI(g,n,l[h],l[e])
b.c=b.b=0
a=l[h]
a0=a.length
d=new A.ag(a,0,Math.min(a0,a0),0,!0)
for(c=0;c<q;++c){b.fv(d,k)
b.e3(j.gP(),k)
j.E()}}},
fI(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
t.L.a(c)
t.T.a(d)
s=c.length
switch(a.a){case 0:break
case 1:for(r=J.am(c),q=b;q<s;++q){p=c.length
if(!(q<p))return A.a(c,q)
o=c[q]
n=q-b
if(!(n>=0&&n<p))return A.a(c,n)
r.h(c,q,o+c[n]&255)}break
case 2:for(r=J.am(c),p=d!=null,q=0;q<s;++q){if(p){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+m&255)}break
case 3:for(r=J.am(c),p=d!=null,q=0;q<s;++q){if(q<b)l=0
else{o=q-b
if(!(o>=0&&o<c.length))return A.a(c,o)
l=c[o]}if(p){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+B.a.j(l+m,1)&255)}break
case 4:for(r=J.am(c),p=d==null,o=!p,q=0;q<s;++q){n=q<b
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
bx(a,b){var s,r,q,p,o,n=this
if(b===0)return 0
if(b===8)return a.G()
if(b===16)return a.p()
for(s=a.c;r=n.c,r<b;){r=a.d
if(r>=s)throw A.h(A.m("Invalid PNG data."))
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
r=B.a.a3(n.b,s)
n.c=s
return r&o},
fv(a,b){var s,r,q=this
t.L.a(b)
s=q.a
r=s.d
switch(r){case 0:B.c.h(b,0,q.bx(a,s.c))
return
case 2:B.c.h(b,0,q.bx(a,s.c))
B.c.h(b,1,q.bx(a,s.c))
B.c.h(b,2,q.bx(a,s.c))
return
case 3:B.c.h(b,0,q.bx(a,s.c))
return
case 4:B.c.h(b,0,q.bx(a,s.c))
B.c.h(b,1,q.bx(a,s.c))
return
case 6:B.c.h(b,0,q.bx(a,s.c))
B.c.h(b,1,q.bx(a,s.c))
B.c.h(b,2,q.bx(a,s.c))
B.c.h(b,3,q.bx(a,s.c))
return}throw A.h(A.m("Invalid color type: "+r+"."))},
e3(a,b){var s,r,q,p,o,n,m,l,k,j
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
a.ae(p,p,p,p!==((q&255)<<24|r&255)>>>0?a.gF():0)
return}a.av(b[0],0,0)
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
if(o!==((q&255)<<8|m&255)||p!==((l&255)<<8|k&255)||n!==((j&255)<<8|s&255)){a.ae(o,p,n,a.gF())
return}}a.av(o,p,n)
return
case 3:a.sT(b[0])
return
case 4:a.av(b[0],b[1],0)
return
case 6:a.ae(b[0],b[1],b[2],b[3])
return}throw A.h(A.m("Invalid color type: "+r+"."))}}
A.ho.prototype={
a6(){return"PngFilter."+this.b}}
A.hn.prototype={
aL(a){var s,r,q,p,o,n,m,l,k,j=this,i=8192
if(!(a.gb2()&&a.gM()!==B.n))s=a.gaM()<8&&!a.gaN()&&a.gaE()>1
else s=!0
if(s)a=a.aQ(B.e)
if(j.w==null){s=A.a7(!0,i)
j.w=s
s.a0(A.j([137,80,78,71,13,10,26,10],t.t))
r=A.a7(!0,i)
r.I(a.gR())
r.I(a.gK())
r.m(a.gaM())
if(a.gaN())s=3
else if(a.gaE()===1)s=0
else if(a.gaE()===2)s=4
else s=a.gaE()===3?2:6
r.m(s)
r.m(0)
r.m(0)
r.m(0)
s=j.w
s.toString
j.by(s,"IHDR",J.D(B.d.gB(r.c),0,r.a))
s=a.c
if(s!=null){r=A.a7(!0,i)
r.a0(new A.an(s.a))
r.m(0)
r.m(0)
r.a0(s.kS())
s=j.w
s.toString
j.by(s,"iCCP",J.D(B.d.gB(r.c),0,r.a))}if(a.gaN()){s=j.a
if(s!=null){s=s.a
s===$&&A.c("palette")
j.fV(s)}else{s=a.a
s=s==null?null:s.gN()
s.toString
j.fV(s)}}if(j.r){r=A.a7(!0,i)
s=j.e
s===$&&A.c("_frames")
r.I(s)
r.I(j.c)
s=j.w
s.toString
j.by(s,"acTL",J.D(B.d.gB(r.c),0,r.a))}}q=a.gaN()?1:a.gaE()
p=a.gM()===B.n?2:1
s=a.gR()
o=a.gK()
n=a.gK()
m=new Uint8Array(s*o*q*p+n)
j.ji(0,a,m)
l=B.b9.he(t.L.a(m),null)
s=a.d
if(s!=null)for(s=new A.Q(s,s.r,s.e,A.l(s).q("Q<1>"));s.E();){o=s.d
n=a.d.l(0,o)
n.toString
r=new A.hi(!0,new Uint8Array(8192))
r.a0(B.b8.cw(o))
r.m(0)
r.a0(B.b8.cw(n))
o=j.w
o.toString
j.by(o,"tEXt",J.D(B.d.gB(r.c),0,r.a))}if(j.r){r=A.a7(!0,i)
r.I(j.f)
r.I(a.gR())
r.I(a.gK())
r.I(0)
r.I(0)
r.a1(a.y)
r.a1(1000)
r.m(1)
r.m(0)
s=j.w
s.toString
j.by(s,"fcTL",J.D(B.d.gB(r.c),0,r.a));++j.f}if(j.f<=1){s=j.w
s.toString
j.by(s,"IDAT",l)}else{k=A.a7(!0,i)
k.I(j.f)
k.a0(l)
s=j.w
s.toString
j.by(s,"fdAT",J.D(B.d.gB(k.c),0,k.a));++j.f}},
dt(){var s,r=this,q=r.w
if(q==null)return null
r.by(q,"IEND",A.j([],t.t))
r.f=0
q=r.w
s=J.D(B.d.gB(q.c),0,q.a)
r.w=null
return s},
bH(a){var s,r,q,p,o,n=this,m=a.gaj().length
if(m<=1){n.e=1
n.r=!1
n.aL(a)}else{m=a.gaj().length
n.e=m
n.r=m>1
n.c=a.r
if(a.gaN()){s=n.a=A.lh(a,256,10)
for(m=a.gaj(),r=m.length,q=0;q<m.length;m.length===r||(0,A.U)(m),++q){p=m[q]
if(p!==a){s.fh(p)
s.f1()
s.fe()
s.eR()}}}for(m=a.gaj(),r=m.length,q=0;q<m.length;m.length===r||(0,A.U)(m),++q){p=m[q]
o=n.a
if(o!=null)n.aL(o.eh(p))
else n.aL(p)}}m=n.dt()
m.toString
return m},
fV(a){var s,r,q,p=this
if(a.gM()===B.e&&a.b===3&&a.a===256){s=p.w
s.toString
p.by(s,"PLTE",J.D(a.gB(a),0,null))}else{s=a.a
r=A.a7(!0,s*3)
for(q=0;q<s;++q){r.m(B.b.i(a.b1(q)))
r.m(B.b.i(a.b0(q)))
r.m(B.b.i(a.b_(q)))}s=p.w
s.toString
p.by(s,"PLTE",J.D(B.d.gB(r.c),0,r.a))}if(a.b===4){s=a.a
r=A.a7(!0,s)
for(q=0;q<s;++q)r.m(B.b.i(a.b6(q)))
s=p.w
s.toString
p.by(s,"tRNS",J.D(B.d.gB(r.c),0,r.a))}},
by(a,b,c){t.L.a(c)
a.I(c.length)
a.a0(new A.an(b))
a.a0(c)
a.I(A.bo(c,A.bo(new A.an(b),0)))},
ji(a,b,c){var s,r,q=this,p=b.gaN()?B.ld:B.le,o=b.gB(0),n=b.a.gbh(),m=b.gaN()?1:b.gaE(),l=B.a.j(m*b.gaM()+7,3),k=b.gaM()+7>>>3,j=p.a,i=J.bc(o),h=0,g=0,f=null,e=0
for(;;){s=b.a
s=s==null?null:s.b
if(!(e<(s==null?0:s)))break
r=i.cN(o,g,n)
g+=n
switch(j){case 1:h=q.jn(r,k,l,c,h)
break
case 2:h=q.jo(r,f,k,c,h)
break
case 3:h=q.jj(r,f,k,l,c,h)
break
case 4:h=q.jl(r,f,k,l,c,h)
break
default:h=q.jk(r,k,c,h)
break}++e
f=r}},
fO(a,b,c,d,e){var s,r,q,p;--a
for(s=b.length,r=d.$flags|0;a>=0;e=q){q=e+1
p=c+a
if(!(p<s))return A.a(b,p)
p=b[p]
r&2&&A.b(d)
if(!(e<d.length))return A.a(d,e)
d[e]=p;--a}return e},
jk(a,b,c,d){var s,r,q,p,o=d+1
c.$flags&2&&A.b(c)
s=c.length
if(!(d<s))return A.a(c,d)
c[d]=0
r=a.length
if(b===1)for(d=o,q=0;q<r;++q,d=o){o=d+1
p=a[q]
if(!(d<s))return A.a(c,d)
c[d]=p}else for(d=o,q=0;q<r;q+=b)d=this.fO(b,a,q,c,d)
return d},
jn(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=e+1
d.$flags&2&&A.b(d)
s=d.length
if(!(e<s))return A.a(d,e)
d[e]=1
for(e=j,r=0;r<c;r+=b)e=this.fO(b,a,r,d,e)
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
jo(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i=e+1
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
jj(a,b,c,d,e,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=a0+1
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
jM(a,b,c){var s=a+b-c,r=s>a?s-a:a-s,q=s>b?s-b:b-s,p=s>c?s-c:c-s
if(r<=q&&r<=p)return a
else if(q<=p)return b
return c},
jl(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=a3+1
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
d=this.jM(i,g,f)
c=a3+1
p&2&&A.b(a2)
if(!(a3>=0&&a3<s))return A.a(a2,a3)
a2[a3]=e-d&255}return a3}}
A.bZ.prototype={
a6(){return"PnmFormat."+this.b}}
A.c_.prototype={}
A.ja.prototype={
bz(a){var s
this.b=A.v(a,!1,null,0)
s=this.de()
if(s==="P1"||s==="P2"||s==="P5"||s==="P3"||s==="P6")return!0
return!1},
b9(a,b){if(this.b7(a)==null)return null
return this.ap(0)},
b7(a){var s,r,q=this
q.b=A.v(a,!1,null,0)
s=q.de()
if(s==="P1"){r=q.a=new A.c_(B.a6)
r.e=B.cq}else if(s==="P2"){r=q.a=new A.c_(B.a6)
r.e=B.cr}else if(s==="P5"){r=q.a=new A.c_(B.a6)
r.e=B.aX}else if(s==="P3"){r=q.a=new A.c_(B.a6)
r.e=B.cs}else if(s==="P6"){r=q.a=new A.c_(B.a6)
r.e=B.aY}else return q.b=null
r.a=q.cJ()
r=q.a
r.toString
r.b=q.cJ()
r=q.a
if(r.a===0||r.b===0)return q.a=q.b=null
return r},
ap(a){var s,r,q,p,o,n=this,m=null,l=n.a
if(l==null)return m
s=l.e
if(s===B.cq){s=l.a
r=A.P(m,m,B.y,0,B.j,l.b,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.E();){q=l.gP()
if(n.de()==="1")q.av(1,1,1)
else q.av(0,0,0)}return r}else if(s===B.cr||s===B.aX){p=n.cJ()
if(p===0)return m
l=n.a
s=l.a
l=l.b
r=A.P(m,m,n.hg(p),0,B.j,l,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.E();){q=l.gP()
o=n.di(n.a.e,p)
q.av(o,o,o)}return r}else if(s===B.cs||s===B.aY){p=n.cJ()
if(p===0)return m
l=n.a
s=l.a
l=l.b
r=A.P(m,m,n.hg(p),0,B.j,l,m,0,3,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.E();)l.gP().av(n.di(n.a.e,p),n.di(n.a.e,p),n.di(n.a.e,p))
return r}return m},
hg(a){if(a>255)return B.n
if(a>15)return B.e
if(a>3)return B.z
if(a>1)return B.t
return B.y},
di(a,b){if(a===B.aX||a===B.aY)return this.b.G()
return this.cJ()},
cJ(){var s,r,q=this.de()
if(J.bq(q)===0)return 0
try{s=A.t6(q)
return s}catch(r){return 0}},
de(){var s,r,q,p,o=this.b
if(o==null)return""
s=this.c
if(s.length!==0)return B.c.c7(s,0)
r=B.m.hu(o.ls())
if(r.length===0)return""
while(B.m.ep(r,"#"))r=B.m.hu(this.b.hn(70))
o=t.cc
q=A.w(new A.eU(A.j(r.split(" "),t.s),t.bB.a(new A.jb()),o),o.q("e.E"))
for(o=q.length,p=0;p<o;++p)if(B.m.ep(q[p],"#")){B.c.sv(q,p)
break}B.c.fW(s,q)
if(s.length===0)return""
return B.c.c7(s,0)}}
A.jb.prototype={
$1(a){return A.bK(a)!==""},
$S:26}
A.hr.prototype={
sla(a){t.T.a(a)},
shK(a){t.T.a(a)},
slu(a){t.T.a(a)},
slv(a){t.T.a(a)}}
A.hs.prototype={
sbR(a){t.T.a(a)},
sbU(a){t.T.a(a)}}
A.bk.prototype={}
A.hv.prototype={
sbR(a){t.T.a(a)},
sbU(a){t.T.a(a)}}
A.hw.prototype={
sbR(a){t.T.a(a)},
sbU(a){t.T.a(a)}}
A.hz.prototype={
sbR(a){t.T.a(a)},
sbU(a){t.T.a(a)}}
A.hA.prototype={
sbR(a){t.T.a(a)},
sbU(a){t.T.a(a)}}
A.eC.prototype={}
A.hy.prototype={}
A.jc.prototype={
i7(a){var s,r,q,p,o=this
a.p()
a.p()
a.p()
a.p()
s=B.a.W(a.c-a.d,8)
if(s>0){o.e=new Uint16Array(s)
o.f=new Uint16Array(s)
o.r=new Uint16Array(s)
o.w=new Uint16Array(s)
for(r=0;r<s;++r){q=o.e
p=a.p()
q.$flags&2&&A.b(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.f
q=a.p()
p.$flags&2&&A.b(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q
q=o.r
p=a.p()
q.$flags&2&&A.b(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.w
q=a.p()
p.$flags&2&&A.b(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q}}}}
A.cx.prototype={
hm(a,b,c,d,e,f,g){if(a.c-a.d<2)return
if(e==null)e=a.p()
switch(e){case 0:d.toString
this.kr(a,b,c,d)
break
case 1:if(f==null)f=this.ko(a,c)
d.toString
this.kq(a,b,c,d,f,g)
break
default:throw A.h(A.m("Unsupported compression: "+e))}},
lr(a,b,c,d){return this.hm(a,b,c,d,null,null,0)},
ko(a,b){var s,r,q=new Uint16Array(b)
for(s=0;s<b;++s){r=a.p()
if(!(s<b))return A.a(q,s)
q[s]=r}return q},
kr(a,b,c,d){var s,r=b*c
if(d===16)r*=2
if(r>a.c-a.d){s=new Uint8Array(r)
this.c=s
B.d.aD(s,0,r,255)
return}this.c=a.ai(r).a4()},
kq(a,b,c,d,e,f){var s,r,q,p,o,n,m,l=b*c
if(d===16)l*=2
s=new Uint8Array(l)
this.c=s
r=f*c
q=e.length
if(r>=q){B.d.aD(s,0,l,255)
return}for(p=0,o=0;o<c;++o,r=n){n=r+1
if(!(r>=0&&r<q))return A.a(e,r)
m=a.am(e[r])
a.d=a.d+(m.c-m.d)
s=this.c
s.toString
this.iX(m,s,p)
p+=b}},
iX(a,b,c){var s,r,q,p,o,n,m,l
for(s=a.c,r=b.length;q=a.d,q<s;){p=a.a
a.d=q+1
q=J.d(p,q)
p=$.as()
p.$flags&2&&A.b(p)
p[0]=q
q=$.aB()
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
A.b8.prototype={
a6(){return"PsdColorMode."+this.b}}
A.ht.prototype={
i8(a){var s,r,q=this
q.as=A.v(a,!0,null,0)
q.k6()
if(q.c!==943870035)return
s=q.as.k()
q.as.ai(s)
s=q.as.k()
q.at=q.as.ai(s)
s=q.as.k()
q.ax=q.as.ai(s)
r=q.as
q.ay=r.ai(r.c-r.d)},
bS(){var s,r=this
if(r.c===943870035){s=r.as
s===$&&A.c("_input")
s=s==null}else s=!0
if(s)return!1
r.km()
r.kn()
r.kp()
r.ay=r.ax=r.at=r.as=null
return!0},
hb(){if(!this.bS())return null
return this.lx()},
lx(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=null,a2=a0.y
if(a2!=null)return a2
a2=a0.a
a2=A.P(a1,a1,B.e,0,B.j,a0.b,a1,0,4,a1,B.e,a2,!1)
a0.y=a2
a2.e5(0)
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
g=h==null?a1:h.O(i,l,a1)
if(g==null)g=new A.C()
f=B.b.i(g.gn())
e=B.b.i(g.gt())
d=B.b.i(g.gu())
c=B.b.i(g.gA())
j.toString
if(j>=0&&j<a0.a&&q&&m<a0.b){h=r.b
h.toString
b=a0.y.a
a=b==null?a1:b.O(h+i,k,a1)
if(a==null)a=new A.C()
a0.il(B.b.i(a.gn()),B.b.i(a.gt()),B.b.i(a.gu()),B.b.i(a.gA()),f,e,d,c,o,p,a)}++i;++j}++l;++m}}a2=a0.y
a2.toString
return a2},
il(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n=h/255*j
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
case 1768188278:p=A.je(a,e)
q=A.je(b,f)
r=A.je(c,g)
s=h
break
case 1818391150:p=A.jg(a,e)
q=A.jg(b,f)
r=A.jg(c,g)
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
case 1935897198:p=A.lv(a,e)
q=A.lv(b,f)
r=A.lv(c,g)
s=h
break
case 1684633120:p=A.jf(a,e)
q=A.jf(b,f)
r=A.jf(c,g)
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
case 1870030194:p=A.lt(a,e,d,h)
q=A.lt(b,f,d,h)
r=A.lt(c,g,d,h)
s=h
break
case 1934387572:p=A.lw(a,e)
q=A.lw(b,f)
r=A.lw(c,g)
s=h
break
case 1749838196:p=A.lr(a,e)
q=A.lr(b,f)
r=A.lr(c,g)
s=h
break
case 1984719220:p=A.lx(a,e)
q=A.lx(b,f)
r=A.lx(c,g)
s=h
break
case 1816947060:p=A.ls(a,e)
q=A.ls(b,f)
r=A.ls(c,g)
s=h
break
case 1884055924:p=A.lu(a,e)
q=A.lu(b,f)
r=A.lu(c,g)
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
case 1936553316:p=A.lq(a,e)
q=A.lq(b,f)
r=A.lq(c,g)
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
k.sA(B.b.i(d*o+s*n))},
k6(){var s,r,q=this,p=q.as
p===$&&A.c("_input")
q.c=p.k()
p=q.as.p()
q.d=p
if(p!==1){q.c=0
return}s=q.as.ai(6)
for(r=0;r<6;++r)if(J.d(s.a,s.d+r)!==0){q.c=0
return}q.e=q.as.p()
q.b=q.as.k()
q.a=q.as.k()
q.f=q.as.p()
p=q.as.p()
if(!(p<8))return A.a(B.cg,p)
q.r=B.cg[p]},
km(){var s,r,q,p,o,n,m=this,l=m.at
l.d=l.b
for(l=m.z;s=m.at,s.d<s.c;){r=s.k()
q=m.at.p()
s=m.at
p=J.d(s.a,s.d++)
m.at.al(p)
if((p&1)===0)++m.at.d
p=m.at.k()
s=m.at
o=s.am(p)
n=s.d+(o.c-o.d)
s.d=n
if((p&1)===1)s.d=n+1
if(r===943868237)l.h(0,q,new A.hu())}},
kn(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.ax
h.d=h.b
s=h.k()
if((s&1)!==0)++s
r=i.ax.ai(s)
h=i.w
B.c.e5(h)
if(s>0){q=r.p()
p=$.ar()
p.$flags&2&&A.b(p)
p[0]=q
q=$.aA()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0)o=-o
for(q=t.N,p=t.hf,n=t.cE,m=t.af,l=0;l<o;++l){k=new A.hx(A.I(q,p),A.j([],n),A.j([],m))
k.i9(r)
B.c.C(h,k)}}for(l=0;l<h.length;++l)h[l].lo(r,i)
s=i.ax.k()
j=i.ax.ai(s)
if(s>0){j.p()
j.p()
j.p()
j.p()
j.p()
j.p()
j.G()}},
kp(){var s,r,q,p,o,n,m=this,l="channels",k=m.ay
k.d=k.b
s=k.p()
if(s===1){k=m.b
r=m.e
r===$&&A.c(l)
q=k*r
p=new Uint16Array(q)
for(o=0;o<q;++o)p[o]=m.ay.p()}else p=null
m.x=t.eS.a(A.j([],t.h0))
o=0
for(;;){k=m.e
k===$&&A.c(l)
if(!(o<k))break
k=m.x
r=m.ay
r.toString
n=o===3?-1:o
n=new A.cx(n)
n.hm(r,m.a,m.b,m.f,s,p,o)
B.c.C(k,n);++o}m.y=A.mW(m.r,m.f,m.a,m.b,m.x)},
$iL:1}
A.hu.prototype={}
A.hx.prototype={
i9(a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a4.k(),a3=$.O()
a3.$flags&2&&A.b(a3)
a3[0]=a2
a2=$.a9()
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
a1.as=t.eS.a(A.j([],t.h0))
s=a4.p()
for(r=0;r<s;++r){a2=a4.p()
a3=$.ar()
a3.$flags&2&&A.b(a3)
a3[0]=a2
a2=$.aA()
if(0>=a2.length)return A.a(a2,0)
q=a2[0]
a4.k()
B.c.C(a1.as,new A.cx(q))}p=a4.k()
if(p!==943868237)throw A.h(A.m("Invalid PSD layer signature: "+B.a.dw(p,16)))
a1.r=a4.k()
a1.w=a4.G()
a4.G()
a1.y=a4.G()
if(a4.G()!==0)throw A.h(A.m("Invalid PSD layer data"))
o=a4.k()
n=a4.ai(o)
if(o>0){o=n.k()
if(o>0){m=n.ai(o)
a2=m.d
m.k()
m.k()
m.k()
m.k()
m.G()
m.G()
if(m.c-a2===20)m.d+=2
else{m.G()
m.G()
m.k()
m.k()
m.k()
m.k()}}o=n.k()
if(o>0)new A.jc().i7(n.ai(o))
o=n.G()
n.al(o)
l=4-B.a.a9(o,4)-1
if(l>0)n.d+=l
for(a2=n.c,a3=a1.ay,k=a1.cy,j=t.t,i=t.g0;n.d<a2;){p=n.k()
if(p!==943868237)throw A.h(A.m("PSD invalid signature for layer additional data: "+B.a.dw(p,16)))
h=n.al(4)
o=n.k()
g=n.am(o)
f=n.d+(g.c-g.d)
n.d=f
if((o&1)===1)n.d=f+1
a3.h(0,h,A.pm(h,g))
if(h==="lrFX"){e=A.p(i.a(a3.l(0,"lrFX")).b,null,0)
e.p()
d=e.p()
for(c=0;c<d;++c){e.al(4)
b=e.al(4)
a=e.k()
if(b==="dsdw"){a0=new A.hs()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbR(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
e.al(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbU(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))}else if(b==="isdw"){a0=new A.hw()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbR(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
e.al(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbU(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))}else if(b==="oglw"){a0=new A.hz()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbR(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
e.al(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2)a0.sbU(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))}else if(b==="iglw"){a0=new A.hv()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbR(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
e.al(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){J.d(e.a,e.d++)
a0.sbU(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))}}else if(b==="bevl"){a0=new A.hr()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.al(8)
e.al(8)
a0.sla(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
a0.shK(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){a0.slu(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
a0.slv(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))}}else if(b==="sofi"){a0=new A.hA()
B.c.C(k,a0)
a0.a=e.k()
e.al(4)
a0.sbR(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbU(A.j([e.p(),e.p(),e.p(),e.p(),e.p()],j))}else e.d+=a}}}}},
lo(a,b){var s,r,q,p,o,n=this,m=0
for(;;){s=n.as
s===$&&A.c("channels")
if(!(m<s.length))break
s=s[m]
r=n.e
r===$&&A.c("width")
q=n.f
q===$&&A.c("height")
s.lr(a,r,q,b.f);++m}r=b.r
q=b.f
p=n.e
p===$&&A.c("width")
o=n.f
o===$&&A.c("height")
n.cx=A.mW(r,q,p,o,s)}}
A.di.prototype={}
A.jd.prototype={
b9(a,b){var s,r,q,p=null,o=A.mV(a)
this.a=o
s=1
if(s===1){o=o.hb()
return o}for(r=p,q=0;q<s;++q){o=this.a
b=o==null?p:o.hb()
if(b==null)continue
if(r==null){b.w=B.be
r=b}else r.aL(b)}return r}}
A.hB.prototype={}
A.aV.prototype={
cR(){return new A.aV(this.a,this.b,this.c)},
el(a){var s,r=this
t.h.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s},
ek(a){var s,r=this
t.h.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s}}
A.M.prototype={
cR(){var s=this
return new A.M(s.a,s.b,s.c,s.d)},
aO(a,b){var s=this
return new A.M(s.a+b.a,s.b+b.b,s.c+b.c,s.d+b.d)},
eq(a,b){var s=this
return new A.M(s.a-b.a,s.b-b.b,s.c-b.c,s.d-b.d)},
hc(a){var s=this
return s.a*a.a+s.b*a.b+s.c*a.c+s.d*a.d},
el(a){var s,r=this
t.R.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s
s=a.d
if(s<r.d)r.d=s},
ek(a){var s,r=this
t.R.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s
s=a.d
if(s>r.d)r.d=s}}
A.dl.prototype={
C(a,b){this.$ti.c.a(b)
this.a.el(b)
this.b.ek(b)}}
A.dj.prototype={$iL:1,
gK(){return this.b}}
A.dk.prototype={$iL:1,
gK(){return this.f}}
A.eD.prototype={$iL:1,
gK(){return this.b}}
A.a4.prototype={
scO(a){var s=this.a,r=this.b+1
s.$flags&2&&A.b(s)
if(!(r<s.length))return A.a(s,r)
s[r]=a},
bV(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.q,s)
return new A.aV(B.q[s],B.q[q>>>4&31],B.x[q&15])}else return new A.aV(B.x[q>>>7&15],B.x[q>>>3&15],B.aw[q&7])},
bX(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.q,s)
return new A.M(B.q[s],B.q[q>>>4&31],B.x[q&15],255)}else return new A.M(B.x[q>>>7&15],B.x[q>>>3&15],B.aw[q&7],B.aw[q>>>11&7])},
bW(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.q,s)
return new A.aV(B.q[s],B.q[q>>>5&31],B.q[q&31])}else return new A.aV(B.x[q>>>8&15],B.x[q>>>4&15],B.x[q&15])},
bY(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.q,s)
return new A.M(B.q[s],B.q[q>>>5&31],B.q[q&31],255)}else return new A.M(B.x[q>>>8&15],B.x[q>>>4&15],B.x[q&15],B.aw[q>>>12&7])},
aK(){var s=this,r=s.c?1:0,q=s.d,p=s.e?1:0,o=s.f,n=s.r?1:0
return(r|(q&16383)<<1|p<<15|(o&32767)<<16|n<<31)>>>0},
aC(){var s,r=this,q=r.a,p=r.b+1
if(!(p<q.length))return A.a(q,p)
s=q[p]
r.c=(s&1)===1
r.scO(r.aK())
r.d=s>>>1&16383
r.scO(r.aK())
r.e=(s>>>15&1)===1
r.scO(r.aK())
r.f=s>>>16&32767
r.scO(r.aK())
r.r=(s>>>31&1)===1
r.scO(r.aK())}}
A.jh.prototype={
b7(a){var s,r=this,q=a.length,p=q-(q>>>1&1431655765)>>>0
p=(p&858993459)+(p>>>2&858993459)
if((p+(p>>>4)>>>0&252645135)*16843009>>>0>>>24===1){s=r.iJ(a)
if(s!=null){r.a=a
return r.b=s}}s=r.iW(a)
if(s!=null){r.a=a
return r.b=s}s=r.iU(a)
if(s!=null){r.a=a
return r.b=s}return null},
iW(a){var s,r,q=A.v(a,!1,null,0)
if(q.k()!==52)return null
if(q.k()!==55727696)return null
s=A.j([0,0,0,0],t.t)
r=new A.dk(s)
q.k()
r.b=q.k()
B.c.h(s,0,q.G())
B.c.h(s,1,q.G())
B.c.h(s,2,q.G())
B.c.h(s,3,q.G())
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
iU(a){var s,r,q=A.v(a,!1,null,0)
if(q.k()!==52)return null
s=new A.dj()
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
iJ(a){var s,r,q,p,o,n,m=null,l=a.length,k=A.v(a,!1,m,0)
if(k.k()!==0)return m
s=new A.eD()
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
if((B.a.S(64,n)&l)>>>0!==0){p=B.a.S(16,o)
q=1
break}if((B.a.S(128,n)&l)>>>0!==0){p=B.a.S(16,o)
break}++o}if(o===10)return m}if((q+1)*2===4)return m
s.b=s.a=p
return s},
ap(a){var s,r,q=this,p=q.b
if(p==null||q.a==null)return null
if(p instanceof A.eD){p=p.a
s=q.b.gK()
r=q.a
r.toString
return q.dJ(p,s,r)}else if(p instanceof A.dj){p=q.a
p.toString
return q.iT(p)}else if(p instanceof A.dk){p=q.a
p.toString
return q.iV(p)}return null},
b9(a,b){if(this.b7(a)==null)return null
return this.ap(0)},
iT(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=a.length
if(e<52||g.b==null)return f
s=g.b
s.toString
t.fi.a(s)
r=A.v(a,!1,f,0)
r.d+=52
q=s.Q
if(q<1)q=(s.d&4096)!==0?6:1
if(q!==1)return f
p=s.a
o=s.b
if(p*o*s.f/8>e-52)return f
switch(s.d&255){case 16:n=A.P(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
l=J.d(r.a,r.d++)
k=J.d(r.a,r.d++)
m.sn(k&240)
m.st((k&15)<<4)
m.su(l&240)
m.sA((l&15)<<4)}return n
case 17:n=A.P(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
j=r.p()
i=(j&1)!==0?255:0
m.sn(j>>>8&248)
m.st(j>>>3&248)
m.su((j&62)<<2)
m.sA(i)}return n
case 18:n=A.P(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
m.sn(J.d(r.a,r.d++))
m.st(J.d(r.a,r.d++))
m.su(J.d(r.a,r.d++))
m.sA(J.d(r.a,r.d++))}return n
case 19:n=A.P(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
j=r.p()
m.sn(j>>>8&248)
m.st(j>>>3&252)
m.su((j&31)<<3)}return n
case 20:n=A.P(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
j=r.p()
m.sn((j&31)<<3)
m.st(j>>>2&248)
m.su(j>>>7&248)}return n
case 21:n=A.P(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
m.sn(J.d(r.a,r.d++))
m.st(J.d(r.a,r.d++))
m.su(J.d(r.a,r.d++))}return n
case 22:n=A.P(f,f,B.e,0,B.j,o,f,0,1,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();)s.gP().sn(J.d(r.a,r.d++))
return n
case 23:n=A.P(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.E();){m=s.gP()
i=J.d(r.a,r.d++)
h=J.d(r.a,r.d++)
m.sn(h)
m.st(h)
m.su(h)
m.sA(i)}return n
case 24:return f
case 25:return s.y===0?g.eY(p,o,r.a4()):g.dJ(p,o,r.a4())}return f},
iV(a){var s,r=this.b
if(!(r instanceof A.dk))return null
s=A.v(a,!1,null,0)
s.d=(s.d+=52)+r.Q
if(r.c[0]===0)switch(r.b){case 2:return this.eY(r.r,r.f,s.a4())
case 3:return this.dJ(r.r,r.f,s.a4())}return null},
eY(e4,e5,e6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4=null,d5=A.P(d4,d4,B.e,0,B.j,e5,d4,0,3,d4,B.e,e4,!1),d6=e4/4|0,d7=d6-1,d8=J.Z(B.d.gB(e6),0,null),d9=new A.a4(d8),e0=new A.a4(J.Z(B.d.gB(e6),0,null)),e1=new A.a4(J.Z(B.d.gB(e6),0,null)),e2=new A.a4(J.Z(B.d.gB(e6),0,null)),e3=new A.a4(J.Z(B.d.gB(e6),0,null))
for(s=d8.length,r=0,q=0;r<d6;++r,q+=4)for(p=0,o=0;p<d6;++p,o+=4){d9.b=A.a8(p,r)<<1>>>0
d9.aC()
n=d9.b
if(!(n<s))return A.a(d8,n)
m=d8[n]
l=d9.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&d7)>>>0
h=(i+1&d7)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&d7)>>>0
e=(f+1&d7)>>>0
e0.b=A.a8(f,i)<<1>>>0
e0.aC()
e1.b=A.a8(e,i)<<1>>>0
e1.aC()
e2.b=A.a8(f,h)<<1>>>0
e2.aC()
e3.b=A.a8(e,h)<<1>>>0
e3.aC()
d=e0.bV()
if(!(k>=0&&k<16))return A.a(B.h,k)
c=B.h[k][0]
b=d.a
a=d.b
d=d.c
a0=e1.bV()
a1=B.h[k][1]
a2=a0.a
a3=a0.b
a0=a0.c
a4=e2.bV()
a5=B.h[k][2]
a6=a4.a
a7=a4.b
a4=a4.c
a8=e3.bV()
a9=B.h[k][3]
b0=a8.a
b1=a8.b
a8=a8.c
b2=e0.bW()
b3=B.h[k][0]
b4=b2.a
b5=b2.b
b2=b2.c
b6=e1.bW()
b7=B.h[k][1]
b8=b6.a
b9=b6.b
b6=b6.c
c0=e2.bW()
c1=B.h[k][2]
c2=c0.a
c3=c0.b
c0=c0.c
c4=e3.bW()
c5=B.h[k][3]
c6=c4.a
c7=c4.b
c4=c4.c
c8=B.c0[l+m&3]
c9=c8[0]
d0=c8[1]
d1=B.a.j((b*c+a2*a1+a6*a5+b0*a9)*c9+(b4*b3+b8*b7+c2*c1+c6*c5)*d0,7)
d2=B.a.j((a*c+a3*a1+a7*a5+b1*a9)*c9+(b5*b3+b9*b7+c3*c1+c7*c5)*d0,7)
d3=B.a.j((d*c+a0*a1+a4*a5+a8*a9)*c9+(b2*b3+b6*b7+c0*c1+c4*c5)*d0,7)
d0=d5.a
if(d0!=null)d0.aa(g+o,n,d1,d2,d3)
m=m>>>2;++k}}}return d5},
dJ(c0,c1,c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=null,b1=A.P(b0,b0,B.e,0,B.j,c1,b0,0,4,b0,B.e,c0,!1),b2=c0/4|0,b3=b2-1,b4=J.Z(B.d.gB(c2),0,null),b5=new A.a4(b4),b6=new A.a4(J.Z(B.d.gB(c2),0,null)),b7=new A.a4(J.Z(B.d.gB(c2),0,null)),b8=new A.a4(J.Z(B.d.gB(c2),0,null)),b9=new A.a4(J.Z(B.d.gB(c2),0,null))
for(s=b4.length,r=0,q=0;r<b2;++r,q+=4)for(p=0,o=0;p<b2;++p,o+=4){b5.b=A.a8(p,r)<<1>>>0
b5.aC()
n=b5.b
if(!(n<s))return A.a(b4,n)
m=b4[n]
l=b5.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&b3)>>>0
h=(i+1&b3)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&b3)>>>0
e=(f+1&b3)>>>0
b6.b=A.a8(f,i)<<1>>>0
b6.aC()
b7.b=A.a8(e,i)<<1>>>0
b7.aC()
b8.b=A.a8(f,h)<<1>>>0
b8.aC()
b9.b=A.a8(e,h)<<1>>>0
b9.aC()
d=b6.bX()
if(!(k>=0&&k<16))return A.a(B.h,k)
c=B.h[k][0]
b=d.a
a=d.b
a0=d.c
d=d.d
a1=b7.bX()
a2=B.h[k][1]
a2=new A.M(b*c,a*c,a0*c,d*c).aO(0,new A.M(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a1=b8.bX()
c=B.h[k][2]
c=a2.aO(0,new A.M(a1.a*c,a1.b*c,a1.c*c,a1.d*c))
a1=b9.bX()
a2=B.h[k][3]
a3=c.aO(0,new A.M(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a2=b6.bY()
a1=B.h[k][0]
c=a2.a
d=a2.b
a0=a2.c
a2=a2.d
a=b7.bY()
b=B.h[k][1]
b=new A.M(c*a1,d*a1,a0*a1,a2*a1).aO(0,new A.M(a.a*b,a.b*b,a.c*b,a.d*b))
a=b8.bY()
a1=B.h[k][2]
a1=b.aO(0,new A.M(a.a*a1,a.b*a1,a.c*a1,a.d*a1))
a=b9.bY()
b=B.h[k][3]
a4=a1.aO(0,new A.M(a.a*b,a.b*b,a.c*b,a.d*b))
a5=B.c0[l+m&3]
b=a3.a
a=a5[0]
a1=a4.a
a2=a5[1]
a6=B.a.j(b*a+a1*a2,7)
a7=B.a.j(a3.b*a+a4.b*a2,7)
a8=B.a.j(a3.c*a+a4.c*a2,7)
a9=B.a.j(a3.d*a5[2]+a4.d*a5[3],7)
a2=b1.a
if(a2!=null)a2.ar(g+o,n,a6,a7,a8,a9)
m=m>>>2;++k}}}return b1}}
A.eE.prototype={
a6(){return"PvrFormat."+this.b}}
A.ji.prototype={
bH(a){var s,r,q,p,o=A.a7(!1,8192)
switch(0){case 0:if(a.gaE()===3){s=this.l1(a)
r=B.lj}else{s=this.l2(a)
r=B.lk}break}q=a.gK()
p=a.gR()
o.I(55727696)
o.I(0)
o.I(r.a-1)
o.I(0)
o.I(0)
o.I(0)
o.I(q)
o.I(p)
o.I(1)
o.I(1)
o.I(1)
o.I(1)
o.I(0)
o.a0(s)
return J.D(B.d.gB(o.c),0,o.a)},
l1(d0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9
if(d0.gR()!==d0.gK())throw A.h(A.m("PVRTC requires a square image."))
s=d0.gR()
if((s&s-1)>>>0!==0)throw A.h(A.m(u.b))
r=B.a.W(d0.gR(),4)
q=r-1
s=B.a.W(d0.gR()*d0.gK(),2)
p=new Uint8Array(s)
s=J.Z(B.d.gB(p),0,null)
o=new A.a4(s)
n=new A.a4(J.Z(B.d.gB(p),0,null))
m=new A.a4(J.Z(B.d.gB(p),0,null))
l=new A.a4(J.Z(B.d.gB(p),0,null))
k=new A.a4(J.Z(B.d.gB(p),0,null))
for(j=s.$flags|0,i=t.h,h=0;h<r;++h)for(g=0;g<r;++g){f=A.pn(d0,g,h)
o.b=A.a8(g,h)<<1>>>0
o.aC()
o.c=!1
e=o.aK()
d=o.b+1
j&2&&A.b(s)
if(!(d<s.length))return A.a(s,d)
s[d]=e
e=i.a(f.a)
c=e.a
if(!(c>=0&&c<256))return A.a(B.K,c)
b=B.K[c]
c=e.b
if(!(c>=0&&c<256))return A.a(B.K,c)
a=B.K[c]
e=e.c
if(!(e>=0&&e<256))return A.a(B.I,e)
o.d=(b<<9|a<<4|B.I[e])>>>0
s[d]=o.aK()
o.e=!0
s[d]=o.aK()
e=i.a(f.b)
c=e.a
if(!(c>=0&&c<256))return A.a(B.v,c)
b=B.v[c]
c=e.b
if(!(c>=0&&c<256))return A.a(B.v,c)
a=B.v[c]
e=e.c
if(!(e>=0&&e<256))return A.a(B.v,e)
o.f=(b<<10|a<<5|B.v[e])>>>0
s[d]=o.aK()
o.r=!1
s[d]=o.aK()}for(h=0,a0=0;h<r;++h,a0+=4)for(g=0,a1=0;g<r;++g,a1+=4){for(a2=0,a3=0,a4=0;a4<4;++a4){a5=(h+(a4<2?-1:0)&q)>>>0
a6=(a5+1&q)>>>0
for(i=a0+a4,a7=0;a7<4;++a7){a8=(g+(a7<2?-1:0)&q)>>>0
a9=(a8+1&q)>>>0
n.b=A.a8(a8,a5)<<1>>>0
n.aC()
m.b=A.a8(a9,a5)<<1>>>0
m.aC()
l.b=A.a8(a8,a6)<<1>>>0
l.aC()
k.b=A.a8(a9,a6)<<1>>>0
k.aC()
e=n.bV()
if(!(a2>=0&&a2<16))return A.a(B.h,a2)
d=B.h[a2][0]
c=e.a
b0=e.b
e=e.c
b1=m.bV()
b2=B.h[a2][1]
b3=b1.a
b4=b1.b
b1=b1.c
b5=l.bV()
b6=B.h[a2][2]
b7=b5.a
b8=b5.b
b5=b5.c
b9=k.bV()
c0=B.h[a2][3]
b7=c*d+b3*b2+b7*b6+b9.a*c0
b8=b0*d+b4*b2+b8*b6+b9.b*c0
c0=e*d+b1*b2+b5*b6+b9.c*c0
b9=n.bW()
b6=B.h[a2][0]
b5=b9.a
b2=b9.b
b9=b9.c
b1=m.bW()
d=B.h[a2][1]
e=b1.a
b4=b1.b
b1=b1.c
b0=l.bW()
b3=B.h[a2][2]
c=b0.a
c1=b0.b
b0=b0.c
c2=k.bW()
c3=B.h[a2][3]
c4=c2.a
c5=c2.b
c2=c2.c
c6=d0.a
c7=c6==null?null:c6.O(a1+a7,i,null)
if(c7==null)c7=new A.C()
e=b5*b6+e*d+c*b3+c4*c3-b7
c5=b2*b6+b4*d+c1*b3+c5*c3-b8
c3=b9*b6+b1*d+b0*b3+c2*c3-c0
c8=((B.b.i(c7.gn())*16-b7)*e+(B.b.i(c7.gt())*16-b8)*c5+(B.b.i(c7.gu())*16-c0)*c3)*16
c9=e*e+c5*c5+c3*c3
if(c8>3*c9)++a3
if(c8>8*c9)++a3
if(c8>13*c9)++a3
a3=(a3>>>2|a3<<30)>>>0;++a2}}o.b=A.a8(g,h)<<1>>>0
o.aC()
i=o.b
j&2&&A.b(s)
if(!(i<s.length))return A.a(s,i)
s[i]=a3}return p},
l2(c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1
if(c2.gR()!==c2.gK())throw A.h(A.m("PVRTC requires a square image."))
s=c2.gR()
if((s&s-1)>>>0!==0)throw A.h(A.m(u.b))
r=B.a.W(c2.gR(),4)
q=r-1
s=B.a.W(c2.gR()*c2.gK(),2)
p=new Uint8Array(s)
s=J.Z(B.d.gB(p),0,null)
o=new A.a4(s)
n=new A.a4(J.Z(B.d.gB(p),0,null))
m=new A.a4(J.Z(B.d.gB(p),0,null))
l=new A.a4(J.Z(B.d.gB(p),0,null))
k=new A.a4(J.Z(B.d.gB(p),0,null))
for(j=t.R,i=s.$flags|0,h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){d=A.po(c2,e,g)
o.b=A.a8(f,h)<<1>>>0
o.aC()
o.c=!1
c=o.aK()
b=o.b+1
i&2&&A.b(s)
if(!(b<s.length))return A.a(s,b)
s[b]=c
c=j.a(d.a)
a=c.d
if(!(a>=0&&a<256))return A.a(B.au,a)
a0=B.au[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.K,a)
a2=B.K[a]
if(!(a1>=0&&a1<256))return A.a(B.K,a1)
a3=B.K[a1]
if(!(c>=0&&c<256))return A.a(B.I,c)
o.d=(a2<<9|a3<<4|B.I[c])>>>0
s[b]=o.aK()
o.e=!0
s[b]=o.aK()}else{if(!(a>=0&&a<256))return A.a(B.I,a)
a2=B.I[a]
if(!(a1>=0&&a1<256))return A.a(B.I,a1)
a3=B.I[a1]
if(!(c>=0&&c<256))return A.a(B.au,c)
o.d=(a0<<11|a2<<7|a3<<3|B.au[c])>>>0
s[b]=o.aK()
o.e=!1
s[b]=o.aK()}c=j.a(d.b)
a=c.d
if(!(a>=0&&a<256))return A.a(B.bv,a)
a0=B.bv[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.v,a)
a2=B.v[a]
if(!(a1>=0&&a1<256))return A.a(B.v,a1)
a3=B.v[a1]
if(!(c>=0&&c<256))return A.a(B.v,c)
o.f=(a2<<10|a3<<5|B.v[c])>>>0
s[b]=o.aK()
o.r=!0
s[b]=o.aK()}else{if(!(a>=0&&a<256))return A.a(B.U,a)
a2=B.U[a]
if(!(a1>=0&&a1<256))return A.a(B.U,a1)
a3=B.U[a1]
if(!(c>=0&&c<256))return A.a(B.U,c)
o.f=(a0<<12|a2<<8|a3<<4|B.U[c])>>>0
s[b]=o.aK()
o.r=!1
s[b]=o.aK()}}for(h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){for(a4=0,a5=0,a6=0;a6<4;++a6){a7=(h+(a6<2?-1:0)&q)>>>0
a8=(a7+1&q)>>>0
for(j=g+a6,a9=0;a9<4;++a9){b0=(f+(a9<2?-1:0)&q)>>>0
b1=(b0+1&q)>>>0
n.b=A.a8(b0,a7)<<1>>>0
n.aC()
m.b=A.a8(b1,a7)<<1>>>0
m.aC()
l.b=A.a8(b0,a8)<<1>>>0
l.aC()
k.b=A.a8(b1,a8)<<1>>>0
k.aC()
c=n.bX()
if(!(a4>=0&&a4<16))return A.a(B.h,a4)
b=B.h[a4][0]
a=c.a
a1=c.b
b2=c.c
c=c.d
b3=m.bX()
b4=B.h[a4][1]
b4=new A.M(a*b,a1*b,b2*b,c*b).aO(0,new A.M(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b3=l.bX()
b=B.h[a4][2]
b=b4.aO(0,new A.M(b3.a*b,b3.b*b,b3.c*b,b3.d*b))
b3=k.bX()
b4=B.h[a4][3]
b5=b.aO(0,new A.M(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b4=n.bY()
b3=B.h[a4][0]
b=b4.a
c=b4.b
b2=b4.c
b4=b4.d
a1=m.bY()
a=B.h[a4][1]
a=new A.M(b*b3,c*b3,b2*b3,b4*b3).aO(0,new A.M(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a1=l.bY()
b3=B.h[a4][2]
b3=a.aO(0,new A.M(a1.a*b3,a1.b*b3,a1.c*b3,a1.d*b3))
a1=k.bY()
a=B.h[a4][3]
b6=b3.aO(0,new A.M(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a=c2.a
b7=a==null?null:a.O(e+a9,j,null)
if(b7==null)b7=new A.C()
a2=A.o(b7.gn())
a3=A.o(b7.gt())
b8=A.o(b7.gu())
a0=A.o(b7.gA())
b9=b6.eq(0,b5)
c0=new A.M(a2*16,a3*16,b8*16,a0*16).eq(0,b5).hc(b9)*16
c1=b9.hc(b9)
if(c0>3*c1)++a5
if(c0>8*c1)++a5
if(c0>13*c1)++a5
a5=(a5>>>2|a5<<30)>>>0;++a4}}o.b=A.a8(f,h)<<1>>>0
o.aC()
j=o.b
i&2&&A.b(s)
if(!(j<s.length))return A.a(s,j)
s[j]=a5}return p}}
A.jj.prototype={
$2(a,b){var s=this.a.aP(this.b+a,this.c+b)
return new A.aV(A.o(s.gn()),A.o(s.gt()),A.o(s.gu()))},
$S:27}
A.jk.prototype={
$2(a,b){var s=this.a.aP(this.b+a,this.c+b)
return new A.M(A.o(s.gn()),A.o(s.gt()),A.o(s.gu()),A.o(s.gA()))},
$S:40}
A.eK.prototype={
cm(a){var s,r,q=this
if(a.c-a.d<18)return
q.a=a.G()
q.b=a.G()
s=a.G()
if(s<12){if(!(s>=0))return A.a(B.bW,s)
r=B.bW[s]}else r=B.az
q.c=r
a.p()
q.e=a.p()
q.f=a.G()
a.p()
a.p()
q.x=a.p()
q.y=a.p()
q.z=a.G()
q.Q=a.G()},
hk(){var s=this,r=s.z
if(r!==8&&r!==16&&r!==24&&r!==32)return!1
r=s.c
if(r===B.L||r===B.M){if(s.e>256||s.b!==1)return!1
r=s.f
if(r!==16&&r!==24&&r!==32)return!1}else if(s.b===1)return!1
return!0},
$iL:1}
A.aw.prototype={
a6(){return"TgaImageType."+this.b}}
A.jo.prototype={
b9(a,b){if(this.b7(a)==null)return null
return this.ap(0)},
b7(a){var s,r,q,p,o=this
o.a=new A.eK(B.az)
s=A.v(a,!1,null,0)
o.b=s
r=s.ai(18)
o.a.cm(r)
s=o.a
if(!s.hk())return null
q=o.b
q.d+=s.a
p=s.c
if(p===B.L||p===B.M)s.as=q.ai(s.e*B.a.j(s.f,3)).a4()
s=o.a
s.ax=o.b.d
return s},
ap(a){var s=this,r=s.a
if(r==null)return null
r=r.c
if(r===B.cz)return s.eX()
else if(r===B.cy||r===B.M)return s.iY()
else if(r===B.L)return s.eX()
return null},
eT(a,b){var s,r,q,p,o,n,m,l=this,k=A.v(a,!1,null,0),j=l.a.f
if(j===16){j=l.b
j===$&&A.c("input")
s=j.p()
r=s>>>7&248
q=s>>>2&248
p=(s&31)<<3
o=(s&32768)!==0?0:255
for(n=0;n<l.a.e;++n){b.bE(n,r)
b.bC(n,q)
b.bB(n,p)
b.bA(n,o)}}else{m=j===32
for(n=0;n<l.a.e;++n){p=J.d(k.a,k.d++)
q=J.d(k.a,k.d++)
r=J.d(k.a,k.d++)
o=m?J.d(k.a,k.d++):255
b.bE(n,r)
b.bC(n,q)
b.bB(n,p)
b.bA(n,o)}}},
iY(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,c=e.a,b=c.z,a=b===16,a0=a||b===32,a1=c.x,a2=c.y,a3=a0?4:3
c=c.c
s=A.P(d,d,B.e,0,B.j,a2,d,0,a3,d,B.e,a1,c===B.L||c===B.M)
c=s.a
if((c==null?d:c.gN())!=null){c=e.a.as
c.toString
a1=s.a
a1=a1==null?d:a1.gN()
a1.toString
e.eT(c,a1)}r=s.gR()
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
if(a1!=null)a1.aJ(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{a1=e.b
if(a){i=a1.p()
l=i>>>7&248
h=i>>>2&248
g=(i&31)<<3
f=(i&32768)!==0?0:255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.ar(p,q,l,h,g,f)
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
if(a1!=null)a1.ar(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}}else if(c)for(k=0;k<n;++k){a1=e.b
l=J.d(a1.a,a1.d++)
j=p+1
a1=s.a
if(a1!=null)a1.aJ(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else if(a)for(k=0;k<n;++k){i=e.b.p()
f=(i&32768)!==0?0:255
j=p+1
a1=s.a
if(a1!=null)a1.ar(p,q,i>>>7&248,i>>>2&248,(i&31)<<3,f)
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
if(a1!=null)a1.ar(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}if(p>=r){--q
if(q<0)break
p=0}}return s},
eX(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=d.b
b===$&&A.c("input")
s=d.a
b.d=s.ax
r=s.z
b=r===16
q=!0
if(!b)if(r!==32){p=s.c
if(p===B.L||p===B.M){p=s.f
p=p===16||p===32}else p=!1
q=p}p=s.x
o=s.y
n=q?4:3
s=s.c
m=A.P(c,c,B.e,0,B.j,o,c,0,n,c,B.e,p,s===B.L||s===B.M)
s=d.a
p=s.c
if(p===B.L||p===B.M){s=s.as
s.toString
p=m.a
p=p==null?c:p.gN()
p.toString
d.eT(s,p)}if(r===8)for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
j=J.d(b.a,b.d++)
b=m.a
if(b!=null)b.aJ(k,l,j);++k}}else if(b)for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
i=d.b.p()
h=(i&32768)!==0?0:255
b=m.a
if(b!=null)b.ar(k,l,i>>>7&248,i>>>2&248,(i&31)<<3,h);++k}}else for(l=m.gK()-1;l>=0;--l){k=0
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
if(b!=null)b.ar(k,l,e,f,g,h);++k}}return m}}
A.jp.prototype={
bH(a){var s,r,q,p,o,n,m,l=null,k=A.a7(!0,8192),j=A.F(18,0,!1,t.p)
B.c.h(j,2,2)
B.c.h(j,12,a.gR()&255)
B.c.h(j,13,B.a.j(a.gR(),8)&255)
B.c.h(j,14,a.gK()&255)
B.c.h(j,15,B.a.j(a.gK(),8)&255)
s=a.a
s=s==null?l:s.gN()
r=s==null?l:s.b
if(r==null)r=a.gaE()
B.c.h(j,16,r===3?24:32)
k.a0(j)
if(r===4)for(q=a.gK()-1;q>=0;--q){p=0
for(;;){s=a.a
o=s==null
n=o?l:s.a
if(!(p<(n==null?0:n)))break
m=o?l:s.O(p,q,l)
if(m==null)m=new A.C()
k.m(A.o(m.gu()))
k.m(A.o(m.gt()))
k.m(A.o(m.gn()))
k.m(A.o(m.gA()));++p}}else for(q=a.gK()-1;q>=0;--q){p=0
for(;;){s=a.a
o=s==null
n=o?l:s.a
if(!(p<(n==null?0:n)))break
m=o?l:s.O(p,q,l)
if(m==null)m=new A.C()
k.m(A.o(m.gu()))
k.m(A.o(m.gt()))
k.m(A.o(m.gn()));++p}}return J.D(B.d.gB(k.c),0,k.a)}}
A.jq.prototype={
ak(a){var s,r,q,p,o,n=this
if(a===0)return 0
if(n.c===0){n.c=8
n.b=n.a.G()}for(s=n.a,r=0;q=n.c,a>q;){p=B.a.V(r,q)
o=n.b
if(!(q>=0&&q<9))return A.a(B.B,q)
r=p+(o&B.B[q])
a-=q
n.c=8
n.b=J.d(s.a,s.d++)}if(a>0){if(q===0){n.c=8
n.b=s.G()}s=B.a.V(r,a)
q=n.b
p=n.c-a
q=B.a.aW(q,p)
if(!(a<9))return A.a(B.B,a)
r=s+(q&B.B[a])
n.c=p}return r}}
A.hG.prototype={
D(a){var s=this,r=s.a,q=$.l0().l(0,r)
if(q!=null)return q.a+": "+s.b.D(0)+" "+s.c
return"<"+r+">: "+s.b.D(0)+" "+s.c},
br(){var s,r,q,p,o=this,n=o.e
if(n!=null)return n
n=o.f
n.d=o.d
s=o.c
r=o.b
if(r!==B.f){q=r.a
if(!(q<14))return A.a(B.u,q)
q=B.u[q]}else q=0
p=n.ai(s*q)
switch(r.a){case 1:return o.e=new A.b4(new Uint8Array(A.q(p.ai(s).a4())))
case 2:return o.e=new A.ce(s===0?"":p.al(s-1))
case 7:return o.e=new A.b4(new Uint8Array(A.q(p.ai(s).a4())))
case 3:return o.e=A.mz(p,s)
case 4:return o.e=A.mu(p,s)
case 5:return o.e=A.mv(p,s)
case 11:return o.e=A.mA(p,s)
case 12:return o.e=A.mt(p,s)
case 6:return o.e=new A.bh(new Int8Array(A.q(J.l1(B.d.gB(p.a4()),0,s))))
case 8:return o.e=A.my(p,s)
case 9:return o.e=A.mw(p,s)
case 10:return o.e=A.mx(p,s)
case 13:case 0:return null}}}
A.jt.prototype={
kV(a,b,c,d){var s,r,q,p=this
p.r=b
p.x=p.w=0
s=B.a.W(p.a+7,8)
for(r=0,q=0;q<d;++q){p.dH(a,r,c)
r+=s}},
dH(a,b,c){var s,r,q,p,o,n,m,l,k=this
k.d=0
for(s=k.a,r=!0;c<s;){while(r){q=k.c1(10)
if(!(q<1024))return A.a(B.ap,q)
p=B.ap[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|k.b8(2))>>>0
if(!(q<16))return A.a(B.J,q)
p=B.J[q]
n=B.a.j(p,1)
c+=B.a.j(p,4)&4095
k.aI(4-(n&7))}else if(o===0)throw A.h(A.m("TIFFFaxDecoder0"))
else if(o===15)throw A.h(A.m("TIFFFaxDecoder1"))
else{c+=B.a.j(p,5)&2047
k.aI(10-o)
if((p&1)===0){B.c.h(k.f,k.d++,c)
r=!1}}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}while(!r){q=k.b8(4)
if(!(q<16))return A.a(B.af,q)
p=B.af[q]
m=p>>>5&2047
l=!0
if(m===100){q=k.c1(9)
if(!(q<512))return A.a(B.aj,q)
p=B.aj[q]
o=B.a.j(p,1)&15
m=B.a.j(p,5)&2047
if(o===12){k.aI(5)
q=k.b8(4)
if(!(q<16))return A.a(B.J,q)
p=B.J[q]
n=B.a.j(p,1)
m=B.a.j(p,4)&4095
k.bd(a,b,c,m)
c+=m
k.aI(4-(n&7))}else if(o===15)throw A.h(A.m("TIFFFaxDecoder2"))
else{k.bd(a,b,c,m)
c+=m
k.aI(9-o)
if((p&1)===0){B.c.h(k.f,k.d++,c)
r=l}}}else{if(m===200){q=k.b8(2)
if(!(q<4))return A.a(B.ae,q)
p=B.ae[q]
m=p>>>5&2047
k.bd(a,b,c,m)
c+=m
k.aI(2-(p>>>1&15))
B.c.h(k.f,k.d++,c)}else{k.bd(a,b,c,m)
c+=m
k.aI(4-(p>>>1&15))
B.c.h(k.f,k.d++,c)}r=l}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}}B.c.h(k.f,k.d++,c)},
kW(a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
a0.r=a2
a0.z=3
a0.x=a0.w=0
s=a0.a
r=B.a.W(s+7,8)
q=A.F(2,null,!1,t.I)
a0.at=a5&1
a0.as=a5>>>2&1
if(a0.fq()!==1)throw A.h(A.m("TIFFFaxDecoder3"))
a0.dH(a1,0,a3)
for(p=r,o=1;o<a4;++o){if(a0.fq()===0){n=a0.e
a0.e=a0.f
a0.f=n
a0.y=0
m=a3
l=-1
k=!0
j=0
for(;;){m.toString
if(!(m<s))break
a0.f8(l,k,q)
i=q[0]
h=q[1]
g=a0.b8(7)
if(!(g<128))return A.a(B.an,g)
g=B.an[g]&255
f=g>>>3&15
e=g&7
if(f===0){if(!k){h.toString
a0.bd(a1,p,m,h-m)}a0.aI(7-e)
m=h
l=m}else if(f===1){a0.aI(7-e)
d=j+1
c=d+1
if(k){m+=a0.d9()
B.c.h(a0.f,j,m)
b=a0.d8()
a0.bd(a1,p,m,b)
m+=b
B.c.h(a0.f,d,m)}else{b=a0.d8()
a0.bd(a1,p,m,b)
m+=b
B.c.h(a0.f,j,m)
m+=a0.d9()
B.c.h(a0.f,d,m)}j=c
l=m}else{if(f<=8){i.toString
a=i+(f-5)
d=j+1
B.c.h(a0.f,j,a)
k=!k
if(k)a0.bd(a1,p,m,a-m)
a0.aI(7-e)}else throw A.h(A.m("TIFFFaxDecoder4"))
m=a
j=d
l=m}}B.c.h(a0.f,j,m)
a0.d=j+1}else a0.dH(a1,p,a3)
p+=r}},
l_(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.r=a6
a4.z=4
a4.x=a4.w=0
s=a4.a
r=B.a.W(s+7,8)
q=A.F(2,null,!1,t.I)
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
a4.f8(k,j,q)
h=q[0]
g=q[1]
f=a4.b8(7)
if(!(f<128))return A.a(B.an,f)
f=B.an[f]&255
e=f>>>3&15
d=f&7
if(e===0){if(!j){g.toString
a4.bd(a5,o,l,g-l)}a4.aI(7-d)
l=g
k=l}else if(e===1){a4.aI(7-d)
c=i+1
b=c+1
if(j){l+=a4.d9()
B.c.h(m,i,l)
a=a4.d8()
a4.bd(a5,o,l,a)
l+=a
B.c.h(m,c,l)}else{a=a4.d8()
a4.bd(a5,o,l,a)
l+=a
B.c.h(m,i,l)
l+=a4.d9()
B.c.h(m,c,l)}i=b
k=l}else if(e<=8){h.toString
a0=h+(e-5)
c=i+1
B.c.h(m,i,a0)
j=!j
if(j)a4.bd(a5,o,l,a0-l)
a4.aI(7-d)
l=a0
i=c
k=l}else if(e===11){if(a4.b8(3)!==7)throw A.h(A.m("TIFFFaxDecoder5"))
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
a4.bd(a5,o,l,1);++l
i=c}}}else throw A.h(A.m("TIFFFaxDecoder5 "+e))}B.c.h(m,i,l)
a4.d=i+1
o+=r}},
d9(){var s,r,q,p,o,n,m=this
for(s=0,r=!0;r;){q=m.c1(10)
if(!(q<1024))return A.a(B.ap,q)
p=B.ap[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|m.b8(2))>>>0
if(!(q<16))return A.a(B.J,q)
p=B.J[q]
n=B.a.j(p,1)
s+=B.a.j(p,4)&4095
m.aI(4-(n&7))}else if(o===0)throw A.h(A.m("TIFFFaxDecoder0"))
else if(o===15)throw A.h(A.m("TIFFFaxDecoder1"))
else{s+=B.a.j(p,5)&2047
m.aI(10-o)
if((p&1)===0)r=!1}}return s},
d8(){var s,r,q,p,o,n,m,l=this
for(s=0,r=!1;!r;){q=l.b8(4)
if(!(q<16))return A.a(B.af,q)
p=B.af[q]
o=p>>>5&2047
if(o===100){q=l.c1(9)
if(!(q<512))return A.a(B.aj,q)
p=B.aj[q]
n=B.a.j(p,1)&15
m=B.a.j(p,5)
if(n===12){l.aI(5)
q=l.b8(4)
if(!(q<16))return A.a(B.J,q)
p=B.J[q]
m=B.a.j(p,1)
s+=B.a.j(p,4)&4095
l.aI(4-(m&7))}else if(n===15)throw A.h(A.m("TIFFFaxDecoder2"))
else{s+=m&2047
l.aI(9-n)
if((p&1)===0)r=!0}}else{if(o===200){q=l.b8(2)
if(!(q<4))return A.a(B.ae,q)
p=B.ae[q]
s+=p>>>5&2047
l.aI(2-(p>>>1&15))}else{s+=o
l.aI(4-(p>>>1&15))}r=!0}}return s},
fq(){var s,r,q=this,p="TIFFFaxDecoder8",o=q.as
if(o===0){if(q.c1(12)!==1)throw A.h(A.m("TIFFFaxDecoder6"))}else if(o===1){o=q.w
o.toString
s=8-o
if(q.c1(s)!==0)throw A.h(A.m(p))
if(s<4)if(q.c1(8)!==0)throw A.h(A.m(p))
while(r=q.c1(8),r!==1)if(r!==0)throw A.h(A.m(p))}if(q.at===0)return 1
else return q.b8(1)},
f8(a,b,c){var s,r,q,p,o,n,m=this
t.cP.a(c)
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
bd(a,b,c,d){var s,r,q,p,o,n=8*b+A.o(c),m=n+d,l=B.a.j(n,3),k=n&7
if(k>0){s=B.a.V(1,7-k)
r=J.d(a.a,a.d+l)
for(;;){if(!(s>0&&n<m))break
r=(r|s)>>>0
s=s>>>1;++n}a.h(0,l,r)}l=B.a.j(n,3)
for(q=m-7;n<q;l=p){p=l+1
J.x(a.a,a.d+l,255)
n+=8}while(n<m){l=B.a.j(n,3)
q=J.d(a.a,a.d+l)
o=B.a.V(1,7-(n&7))
J.x(a.a,a.d+l,(q|o)>>>0);++n}},
c1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.r
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
m=B.Y[J.d(e.a,s+q)&255]
if(!(q===r)){e=q+1
s=f.r
p=s.a
s=s.d
if(e===r)o=B.Y[J.d(p,s+e)&255]
else{o=B.Y[J.d(p,s+e)&255]
e=f.r
n=B.Y[J.d(e.a,e.d+(q+2))&255]}}}else throw A.h(A.m("TIFFFaxDecoder7"))
e=f.w
e.toString
l=8-e
k=a-l
if(k>8){j=k-8
i=8}else{i=k
j=0}e=f.x
e.toString
e=f.x=e+1
if(!(l>=0&&l<9))return A.a(B.B,l)
h=B.a.V(m&B.B[l],k)
if(!(i>=0))return A.a(B.W,i)
g=B.a.a3(o&B.W[i],8-i)
if(j!==0){g=B.a.V(g,j)
if(!(j<9))return A.a(B.W,j)
g|=B.a.a3(n&B.W[j],8-j)
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
n=B.Y[J.d(h.a,s+q)&255]
if(!(q===r)){h=i.r
o=B.Y[J.d(h.a,h.d+(q+1))&255]}}else throw A.h(A.m("TIFFFaxDecoder7"))
h=i.w
h.toString
m=8-h
l=a-m
k=m-a
if(k>=0){if(!(m>=0&&m<9))return A.a(B.B,m)
j=B.a.a3(n&B.B[m],k)
h+=a
i.w=h
if(h===8){i.w=0
h=i.x
h.toString
i.x=h+1}}else{if(!(m>=0&&m<9))return A.a(B.B,m)
j=B.a.V(n&B.B[m],-k)
if(!(l>=0&&l<9))return A.a(B.W,l)
j=(j|B.a.a3(o&B.W[l],8-l))>>>0
h=i.x
h.toString
i.x=h+1
i.w=l}return j},
aI(a){var s,r=this,q=r.w
q.toString
s=q-a
if(s<0){q=r.x
q.toString
r.x=q-1
r.w=8+s}else r.w=s}}
A.hH.prototype={
ia(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=A.p(a0,c,0),a=a0.p()
for(s=d.a,r=0;r<a;++r){q=a0.p()
p=a0.p()
o=a0.k()
if(p>13){a0.d+=4
continue}n=B.bS[p]
if(o*B.u[p]>4)m=a0.k()
else{m=a0.d
a0.d=m+4}l=new A.hG(q,n,o,m,b)
s.h(0,q,l)
if(q===256){k=l.br()
k=k==null?c:k.i(0)
d.b=k==null?0:k}else if(q===257){k=l.br()
k=k==null?c:k.i(0)
d.c=k==null?0:k}else if(q===262){j=l.br()
i=j==null?c:j.i(0)
if(i==null)i=17
if(i<17){if(!(i>=0))return A.a(B.bN,i)
d.d=B.bN[i]}else d.d=B.b1}else if(q===259){k=l.br()
k=k==null?c:k.i(0)
d.e=k==null?0:k}else if(q===258){k=l.br()
k=k==null?c:k.i(0)
d.f=k==null?0:k}else if(q===277){k=l.br()
k=k==null?c:k.i(0)
d.r=k==null?0:k}else if(q===317){k=l.br()
k=k==null?c:k.i(0)
d.Q=k==null?0:k}else if(q===339){k=l.br()
j=k==null?c:k.i(0)
if(j==null)j=0
if(!(j>=0&&j<4))return A.a(B.bR,j)
d.x=B.bR[j]}else if(q===320){j=l.br()
if(j!=null){k=J.od(B.d.gB(j.bt()))
d.id=k
d.k1=0
k=k.length/3|0
d.k2=k
d.k3=k*2}}}k=d.id
h=k!=null
if(h&&d.d===B.b2)d.r=1
if(d.b===0||d.c===0)return
if(h&&d.f===8){g=k.length
for(h=k.$flags|0,r=0;r<g;++r){f=k[r]
h&2&&A.b(k)
k[r]=f>>>8}}if(d.d===B.b0)d.z=!0
d.w=d.r
if(s.a8(324)){d.ay=d.ct(322)
d.ch=d.ct(323)
d.CW=d.dh(324)
d.cx=d.dh(325)}else{d.ay=d.dg(322,d.b)
if(!s.a8(278))d.ch=d.dg(323,d.c)
else{e=d.ct(278)
if(e===-1)d.ch=d.c
else d.ch=e}d.CW=d.dh(273)
d.cx=d.dh(279)}k=d.b
h=d.ay
d.cy=B.a.aw(k+h-1,h)
h=d.c
k=d.ch
d.db=B.a.aw(h+k-1,k)
d.dy=d.dg(266,1)
d.fr=d.ct(292)
d.fx=d.ct(293)
d.ct(338)
switch(d.d.a){case 0:case 1:s=d.f
if(s===1&&d.r===1)d.y=B.b_
else if(s===4&&d.r===1)d.y=B.lt
else if(B.a.a9(s,8)===0){s=d.r
if(s===1)d.y=B.lu
else if(s===2)d.y=B.lv
else d.y=B.a7}break
case 2:if(B.a.a9(d.f,8)===0){s=d.r
if(s===3)d.y=B.cA
else if(s===4)d.y=B.lx
else d.y=B.a7}break
case 3:s=!1
if(d.r===1)if(d.id!=null){s=d.f
s=s===4||s===8||s===16}if(s)d.y=B.lw
break
case 4:if(d.f===1&&d.r===1)d.y=B.b_
break
case 6:if(d.e===7&&d.f===8&&d.r===3)d.y=B.cA
else{if(s.a8(530)){j=s.l(0,530).br()
d.as=j.i(0)
s=d.at=j.ab(0,1)}else s=d.at=d.as=2
k=d.as
k===$&&A.c("chromaSubH")
if(k*s===1)d.y=B.a7
else if(d.f===8&&d.r===3)d.y=B.ly}break
case 5:if(B.a.a9(d.f,8)===0)d.y=B.a7
s=d.r
if(s===4)d.w=3
else if(s===5)d.w=4
break
default:if(B.a.a9(d.f,8)===0)d.y=B.a7
break}},
c3(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.x,a1=a0===B.a_,a2=a0===B.i
a0=b.f
if(a0===1)s=B.y
else if(a0===2)s=B.t
else{if(a0===4)a0=B.z
else if(a1&&a0===16)a0=B.G
else if(a1&&a0===32)a0=B.O
else if(a1&&a0===64)a0=B.Q
else if(a2&&a0===8)a0=B.R
else if(a2&&a0===16)a0=B.S
else if(a2&&a0===32)a0=B.T
else if(a0===16)a0=B.n
else a0=a0===32?B.P:B.e
s=a0}r=b.id!=null&&b.d===B.b2
q=r?3:b.w
a0=b.b
p=A.P(a,a,s,0,B.j,b.c,a,0,q,a,s,a0,r)
if(r){a0=p.a
a0=a0==null?a:a0.gN()
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
b.iZ(a3,p,c,e);++c;++d}++e}return p},
iZ(b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=this,b1=null
if(b0.y===B.b_){b0.iM(b2,b3,b4,b5)
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
else if(p===5){r=A.v(new Uint8Array(j),!1,b1,0)
q=A.mL()
try{q.ha(A.p(b2,s,0),r.a)}catch(i){}if(b0.Q===2)for(h=0;h<b0.ch;++h){g=b0.r
p=b0.ay
f=g*(h*p+1)
e=p*g
for(;g<e;++g){p=r
m=J.d(p.a,p.d+f)
k=r
d=b0.r
d=J.d(k.a,k.d+(f-d))
J.x(p.a,p.d+f,m+d);++f}}}else if(p===32773){r=A.v(new Uint8Array(j),!1,b1,0)
b0.eW(b2,j,r.a)}else if(p===32946)r=A.v(B.F.c4(b2.cZ(0,0,s)),!1,b1,0)
else if(p===8)r=A.v(B.F.c4(b2.cZ(0,0,s)),!1,b1,0)
else if(p===6||p===7){b0.jH(new A.h7().c3(t.D.a(b2.cZ(0,0,s))),b3,n,l,b0.ay,b0.ch)
return}else throw A.h(A.m("Unsupported Compression Type: "+p))
c=A.j([0,0,0],t.t)
for(b=l,a=0;a<b0.ch;++a,++b)for(a0=n,a1=0;a1<b0.ay;++a1,++a0){p=r
if(p.d>=p.c||a0>=b0.b||b>=b0.c)break
p=b0.r
if(p===1){p=b0.x
if(p===B.a_){p=b0.f
if(p===32){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.c8()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else if(p===64)a2=r.dv()
else if(p===16){p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a2=m[p]}else a2=0
if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aJ(a0,b,a2)}}else{m=b0.f
if(m===8)if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else{p=r
a2=J.d(p.a,p.d++)}else if(m===16)if(p===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else a2=r.p()
else if(m===32)if(p===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else a2=r.k()
else a2=0
if(b0.d===B.b0){p=b3.a
a3=p==null?b1:p.gF()
a2=(a3==null?0:a3)-a2}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aJ(a0,b,a2)}}}else if(p===2){p=b0.f
if(p===8){if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else{p=r
a4=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}}else if(p===16){if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else a4=r.p()
if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.p()}else if(p===32){if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else a4=r.k()
if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()}else{a4=0
a5=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aa(a0,b,a4,a5,0)}}else if(p===3){p=b0.x
if(p===B.a_){p=b0.f
if(p===32){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.c8()
if(0>=p.length)return A.a(p,0)
a6=p[0]
m[0]=r.k()
a7=p[0]
m[0]=r.k()
a8=p[0]}else{a7=0
a8=0
if(p===64)a6=r.dv()
else if(p===16){p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a6=m[p]
p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a7=m[p]
p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a8=m[p]}else a6=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aa(a0,b,a6,a7,a8)}}else{m=b0.f
if(m===8){if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else{p=r
a6=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}}else if(m===16){if(p===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.p()
if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.p()
if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.p()}else if(m===32){if(p===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.k()
if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()}else{a6=0
a7=0
a8=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aa(a0,b,a6,a7,a8)}}}else if(p>=4)if(b0.x===B.a_){p=b0.f
if(p===32){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.c8()
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
if(p===64)a6=r.dv()
else if(p===16){p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a6=m[p]
p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a7=m[p]
p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a8=m[p]
p=r.p()
m=$.T
m=m!=null?m:A.Y()
if(!(p<m.length))return A.a(m,p)
a9=m[p]}else a6=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.ar(a0,b,a6,a7,a8,a9)}}else{p=b3.a
a5=p==null?b1:p.gF()
if(a5==null)a5=0
p=b0.f
if(p===8){if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else{p=r
a6=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else{p=r
a9=J.d(p.a,p.d++)}if(b0.r===5)if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.as()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aB()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}}else if(p===16){if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.p()
if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.p()
if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.p()
if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.p()
if(b0.r===5)if(b0.x===B.i){p=r.p()
m=$.ar()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aA()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.p()}else if(p===32){if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.k()
if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()
if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.k()
if(b0.r===5)if(b0.x===B.i){p=r.k()
m=$.O()
m.$flags&2&&A.b(m)
m[0]=p
p=$.a9()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()}else{a6=0
a7=0
a8=0
a9=0}if(b0.d===B.cB){A.nB(a6,a7,a8,a9,c)
a6=c[0]
a7=c[1]
a8=c[2]
a9=a5}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.ar(a0,b,a6,a7,a8,a9)}}}}else throw A.h(A.m("Unsupported bitsPerSample: "+p))},
jH(a,b,c,d,e,f){var s,r,q,p
for(s=0;s<f;++s)for(r=s+d,q=0;q<e;++q){p=a.a
p=p==null?null:p.O(q,s,null)
if(p==null)p=new A.C()
b.c8(q+c,r,p)}},
iM(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=null,a4=a2.cy
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
if(n===32773){l=B.a.a9(a4,8)===0?B.a.W(a4,8)*p:(B.a.W(a4,8)+1)*p
s=A.v(new Uint8Array(a4*p),!1,a3,0)
a2.eW(a5,l,s.a)}else if(n===5){s=A.v(new Uint8Array(a4*p),!1,a3,0)
A.mL().ha(A.p(a5,m,0),s.a)
if(a2.Q===2)for(k=0;k<a2.c;++k){j=a2.r
i=j*(k*a2.b+1)
for(;j<a2.b*a2.r;++j){a4=s
p=J.d(a4.a,a4.d+i)
n=s
h=a2.r
h=J.d(n.a,n.d+(i-h))
J.x(a4.a,a4.d+i,p+h);++i}}}else if(n===2){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.lB(a2.dy,a4,p).kV(s,a5,0,a2.ch)}catch(g){}}else if(n===3){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.lB(a2.dy,a4,p).kW(s,a5,0,a2.ch,a2.fr)}catch(g){}}else if(n===4){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.lB(a2.dy,a4,p).l_(s,a5,0,a2.ch,a2.fx)}catch(g){}}else if(n===8)s=A.v(B.F.c4(a5.cZ(0,0,m)),!1,a3,0)
else if(n===32946)s=A.v(B.F.c4(a5.cZ(0,0,m)),!1,a3,0)
else if(n===1)s=a5
else throw A.h(A.m("Unsupported Compression Type: "+n))
f=new A.jq(s)
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
a4=f.ak(1)
p=a6.a
if(a4===0){if(p!=null)p.aa(a0,b,d,0,0)}else if(p!=null)p.aa(a0,b,c,0,0)}f.c=0}},
eW(a,b,c){var s,r,q,p,o,n,m,l,k,j
t.L.a(c)
for(s=J.am(c),r=0,q=0;q<b;){p=r+1
o=J.d(a.a,a.d+r)
n=$.as()
n.$flags&2&&A.b(n)
n[0]=o
o=$.aB()
if(0>=o.length)return A.a(o,0)
m=o[0]
if(m>=0&&m<=127)for(o=m+1,r=p,l=0;l<o;++l,q=k,r=p){k=q+1
p=r+1
s.h(c,q,J.d(a.a,a.d+r))}else{o=m<=-1&&m>=-127
r=p+1
if(o){j=J.d(a.a,a.d+p)
for(o=-m+1,l=0;l<o;++l,q=k){k=q+1
s.h(c,q,j)}}}}},
dg(a,b){var s=this.a
if(!s.a8(a))return b
s=s.l(0,a).br()
s=s==null?null:s.i(0)
return s==null?0:s},
ct(a){return this.dg(a,0)},
dh(a){var s,r=this.a
if(!r.a8(a))return null
s=r.l(0,a)
r=s.br()
r.toString
return A.mK(s.c,r.gbN(r),t.p)}}
A.cy.prototype={
a6(){return"TiffFormat."+this.b}}
A.aa.prototype={
a6(){return"TiffPhotometricType."+this.b}}
A.aY.prototype={
a6(){return"TiffImageType."+this.b}}
A.hI.prototype={$iL:1}
A.j2.prototype={
ha(a,b){var s,r,q,p,o,n,m,l,k=this,j="_bufferLength"
t.L.a(b)
k.r=b
s=J.bq(b)
k.w=0
r=t.D.a(a.a)
k.e=r
q=k.f=r.length
k.b=a.d
if(0>=q)return A.a(r,0)
if(r[0]===0){if(1>=q)return A.a(r,1)
r=r[1]===1}else r=!1
if(r)throw A.h(A.m("Invalid LZW Data"))
k.fd()
k.d=k.c=0
p=k.dR()
r=k.x
o=0
for(;;){if(!(p!==257&&k.w<s))break
if(p===256){k.fd()
p=k.dR()
k.as=0
if(p===257)break
J.x(k.r,k.w++,p)
o=p}else{q=k.Q
q.toString
if(p<q){k.fa(p)
q=k.as
q===$&&A.c(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.x(q,m,r[n])}q=k.as-1
if(!(q>=0&&q<4096))return A.a(r,q)
k.ez(o,r[q])}else{k.fa(o)
q=k.as
q===$&&A.c(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.x(q,m,r[n])}q=k.r
m=k.w++
l=k.as-1
if(!(l>=0&&l<4096))return A.a(r,l)
J.x(q,m,r[l])
l=k.as-1
if(!(l>=0&&l<4096))return A.a(r,l)
k.ez(o,r[l])}o=p}p=k.dR()}},
ez(a,b){var s,r=this,q=r.y
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
fa(a){var s,r,q,p,o,n,m,l=this
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
dR(){var s,r,q,p,o=this,n=o.b,m=o.f
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
n=B.a.a3(o.c,n)
r-=9
if(!(r>=0&&r<4))return A.a(B.bw,r)
return n&B.bw[r]},
fd(){var s,r,q=this
q.y=new Uint8Array(4096)
s=new Uint32Array(4096)
q.z=s
B.o.aD(s,0,4096,4098)
for(s=q.y,r=0;r<256;++r){s.$flags&2&&A.b(s)
s[r]=r}q.a=9
q.Q=258}}
A.jr.prototype={
ap(a){var s,r,q=this.a
if(q==null)return null
q=q.f
if(!(a<q.length))return A.a(q,a)
q=q[a]
s=this.c
s===$&&A.c("_input")
r=q.c3(s)
return r},
b9(a,b){var s,r,q,p=this,o=null,n=A.v(a,!1,o,0)
p.c=n
n=p.a=p.ft(n)
if(n==null)return o
s=n.f.length
r=p.ap(0)
if(r==null)return o
r.e=A.l7(A.v(a,!1,o,0))
r.w=B.be
for(q=1;q<s;++q)r.aL(p.ap(q))
return r},
ft(a){var s,r,q,p,o,n,m,l,k,j,i=null,h=A.j([],t.aU),g=new A.hI(h),f=a.p()
if(f!==18761&&f!==19789)return i
if(f===19789)a.e=!0
else a.e=!1
q=a.p()
g.d=q
if(q!==42)return i
p=a.k()
o=A.p(a,i,0)
o.d=p
s=o
for(q=t.p,n=t.cV;p!==0;){r=null
try{m=new A.hH(A.I(q,n),B.b1,B.aZ,B.lz)
m.ia(s)
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
A.js.prototype={
bH(a){var s,r,q,p,o,n,m,l,k,j,i,h,g="ifd0",f=A.a7(!1,8192),e=new A.bQ(A.I(t.N,t.P))
if(a.e!=null)e.l(0,g).h9(a.gbI().l(0,g))
if(a.gb2())a=a.aQ(B.e)
if(a.gaE()===1)s=1
else s=a.gaN()?3:2
r=a.gaE()
q=e.l(0,g)
q.h(0,"ImageWidth",a.gR())
q.h(0,"ImageHeight",a.gK())
q.h(0,"BitsPerSample",a.gaM())
q.h(0,"SampleFormat",this.jw(a).a)
q.h(0,"SamplesPerPixel",a.gaN()?1:r)
q.h(0,"Compression",1)
q.h(0,"PhotometricInterpretation",s)
q.h(0,"RowsPerStrip",a.gK())
q.h(0,"PlanarConfiguration",1)
q.h(0,"TileWidth",a.gR())
q.h(0,"TileLength",a.gK())
q.h(0,"StripByteCounts",a.gcV(0))
q.h(0,"StripOffsets",new A.bU(new Uint8Array(A.q(a.a4()))))
if(a.gaN()){p=a.a
o=p==null?null:p.gN()
n=o.a
p=n*3
m=new Uint16Array(p)
for(l=0,k=0;l<3;++l)for(j=0;j<n;++j,k=i){i=k+1
h=B.b.i(o.aV(j,l))
if(!(k>=0&&k<p))return A.a(m,k)
m[k]=h<<8>>>0}q.h(0,"ColorMap",m)}e.aY(f)
return J.D(B.d.gB(f.c),0,f.a)},
jw(a){var s=a.a
s=s==null?null:s.gbp()
switch((s==null?B.N:s).a){case 0:return B.aZ
case 1:return B.i
case 2:return B.a_}}}
A.jy.prototype={
cS(){var s,r=this.a,q=r.bs()
if((q&1)!==0)return!1
if((q>>>1&7)>3)return!1
if((q>>>4&1)===0)return!1
this.f.d=q>>>5
if(r.bs()!==2752925)return!1
s=this.b
s.a=r.p()
s.b=r.p()
return!0},
bS(){var s,r,q,p=this,o=null
if(!p.ju())return o
s=p.b
r=s.a
p.d=A.P(o,o,B.e,0,B.j,s.b,o,0,4,o,B.e,r,!1)
p.jB()
if(!p.jQ())return o
s=s.w
if(s.length!==0){q=A.v(new A.an(s),!1,o,0)
s=p.d
s.toString
s.e=A.l7(q)}return p.d},
ju(){var s,r,q,p,o=this
if(!o.cS())return!1
o.fr=A.q8()
for(s=o.dy,r=0;r<4;++r){q=new Int32Array(2)
p=new Int32Array(2)
B.c.h(s,r,new A.hP(q,p,new Int32Array(2)))}o.y=o.Q=0
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
p=A.n1(s.am(p))
o.c=p
s.d+=q.d
p.a2(1)
o.c.a2(1)
o.jW(o.x,o.fr)
o.jP()
if(!o.jS(s))return!1
o.jU()
o.c.a2(1)
o.jT()
return!0},
jW(a,b){var s,r,q,p=this,o=p.c
o===$&&A.c("br")
o=o.a2(1)!==0
a.a=o
if(o){a.b=p.c.a2(1)!==0
if(p.c.a2(1)!==0){a.c=p.c.a2(1)!==0
for(o=a.d,s=0;s<4;++s){if(p.c.a2(1)!==0){r=p.c
q=r.a2(7)
r=r.a2(1)===1?-q:q}else r=0
o.$flags&2&&A.b(o)
o[s]=r}for(o=a.e,s=0;s<4;++s){if(p.c.a2(1)!==0){r=p.c
q=r.a2(6)
r=r.a2(1)===1?-q:q}else r=0
o.$flags&2&&A.b(o)
o[s]=r}}if(a.b)for(s=0;s<3;++s){o=b.a
r=p.c.a2(1)!==0?p.c.a2(8):255
o.$flags&2&&A.b(o)
o[s]=r}}else a.b=!1
return!0},
jP(){var s,r,q,p=this,o=p.w,n=p.c
n===$&&A.c("br")
o.a=n.a2(1)!==0
o.b=p.c.a2(6)
o.c=p.c.a2(3)
n=p.c.a2(1)!==0
o.d=n
if(n)if(p.c.a2(1)!==0){for(n=o.e,s=0;s<4;++s)if(p.c.a2(1)!==0){r=p.c
q=r.a2(6)
r=r.a2(1)===1?-q:q
n.$flags&2&&A.b(n)
n[s]=r}for(n=o.f,s=0;s<4;++s)if(p.c.a2(1)!==0){r=p.c
q=r.a2(6)
r=r.a2(1)===1?-q:q
n.$flags&2&&A.b(n)
n[s]=r}}if(o.b===0)n=0
else n=o.a?1:2
p.aR=n
return!0},
jS(a){var s,r,q,p,o,n,m,l=a.c-a.d,k=this.c
k===$&&A.c("br")
k=B.a.S(1,k.a2(2))
this.cy=k
s=k-1
r=s*3
if(l<r)return!1
for(k=this.db,q=0,p=0;p<s;++p,r=n){o=a.d3(3,q)
n=r+((J.d(o.a,o.d)|J.d(o.a,o.d+1)<<8|J.d(o.a,o.d+2)<<16)>>>0)
if(n>l)n=l
m=new A.eN(a.c9(n-r,r))
m.b=254
m.c=0
m.d=-8
B.c.h(k,p,m)
q+=3}B.c.h(k,s,A.n1(a.c9(l-r,a.d-a.b+r)))
return r<l},
jU(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.c
e===$&&A.c("br")
s=e.a2(7)
r=f.c.a2(1)!==0?f.c.cC(4):0
q=f.c.a2(1)!==0?f.c.cC(4):0
p=f.c.a2(1)!==0?f.c.cC(4):0
o=f.c.a2(1)!==0?f.c.cC(4):0
n=f.c.a2(1)!==0?f.c.cC(4):0
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
g=B.aR[g]
i.$flags&2&&A.b(i)
i[0]=g
if(j<0)g=0
else g=j>127?127:j
i[1]=B.aS[g]
g=h.b
i=j+q
if(i<0)i=0
else if(i>127)i=127
i=B.aR[i]
g.$flags&2&&A.b(g)
g[0]=i*2
i=j+p
if(i<0)i=0
else if(i>127)i=127
g[1]=B.aS[i]*101581>>>16
if(g[1]<8)g[1]=8
i=h.c
g=j+o
if(g<0)g=0
else if(g>117)g=117
g=B.aR[g]
i.$flags&2&&A.b(i)
i[0]=g
g=j+n
if(g<0)g=0
else if(g>127)g=127
i[1]=B.aS[g]}},
jT(){var s,r,q,p,o,n,m=this,l=m.fr
for(s=0;s<4;++s)for(r=0;r<8;++r)for(q=0;q<3;++q)for(p=0;p<11;++p){o=m.c
o===$&&A.c("br")
n=o.ad(B.jR[s][r][q][p])!==0?m.c.a2(8):B.eq[s][r][q][p]
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
o=o.a2(1)!==0
m.fx=o
if(o)m.fy=m.c.a2(8)},
jY(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.aR
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
jB(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=h.b,e=f.at
if(e!=null)h.bT=e
s=J.ao(4,t.e6)
for(e=t.ao,r=0;r<4;++r)s[r]=A.j([new A.bH(),new A.bH()],e)
h.bK=t.gS.a(s)
e=h.at
e.toString
s=J.ao(e,t.dE)
for(q=0;q<e;++q){p=new Uint8Array(16)
o=new Uint8Array(8)
s[q]=new A.eR(p,o,new Uint8Array(8))}h.k2=t.cC.a(s)
h.ok=new Uint8Array(832)
e=h.at
e.toString
h.go=new Uint8Array(4*e)
p=h.p4=16*e
o=h.R8=8*e
n=h.aR
n.toString
if(!(n<3))return A.a(B.ad,n)
m=B.ad[n]
l=m*p
k=(m/2|0)*o
h.p1=A.v(new Uint8Array(16*p+l),!1,g,l)
p=8*o+k
h.p2=A.v(new Uint8Array(p),!1,g,k)
h.p3=A.v(new Uint8Array(p),!1,g,k)
f=f.a
h.RG=A.v(new Uint8Array(f),!1,g,0)
j=f+1>>>1
h.rx=A.v(new Uint8Array(j),!1,g,0)
h.ry=A.v(new Uint8Array(j),!1,g,0)
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
s=J.ao(i,t.ai)
for(q=0;q<i;++q)s[q]=new A.eP()
h.k3=t.eQ.a(s)
f=h.at
f.toString
s=J.ao(f,t.gU)
for(q=0;q<f;++q){e=new Int16Array(384)
s[q]=new A.eQ(e,new Uint8Array(16))}h.bJ=t.db.a(s)
f=h.at
f.toString
h.k4=t.ge.a(A.F(f,g,!1,t.aj))
h.jY()
A.pz()
h.e=new A.jz()
return!0},
jQ(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d="isIntra4x4"
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
p=p.ad(e.fr.a[0])
o=e.c
m=e.fr
e.k1=p===0?o.ad(m.a[1]):2+o.ad(m.a[2])}p=e.fx
p===$&&A.c("_useSkipProba")
if(p){p=e.c
p===$&&A.c("br")
o=e.fy
o===$&&A.c("_skipP")
h=p.ad(o)!==0}else h=!1
e.jR()
if(!h)h=e.jV(j,n)
else{l.a=j.a=0
p=i.b
p===$&&A.c(d)
if(!p)l.b=j.b=0
i.f=i.e=0}p=e.aR
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
B.d.aD(s,0,4,0)
e.y1=0
e.kw()
p=e.aR
p.toString
f=!1
if(p>0){p=e.y2
o=e.ch
o===$&&A.c("_tlMbY")
if(p>=o){o=e.cx
o.toString
o=p<=o
f=o}}if(!e.jp(f))return!1
p=++e.y2}return!0},
kw(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null,a6="_dsp",a7=a4.y2,a8=a4.ok
a8===$&&A.c("_yuvBlock")
s=A.v(a8,!1,a5,40)
r=A.v(a8,!1,a5,584)
q=A.v(a8,!1,a5,600)
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
s.bq(o-4,4,s,o+12)}for(m=-1;m<8;++m){o=m*32
l=o-4
o+=4
r.bq(l,4,r,o)
q.bq(l,4,q,o)}}else{for(m=0;m<16;++m)J.x(s.a,s.d+(m*32-1),129)
for(m=0;m<8;++m){o=m*32-1
J.x(r.a,r.d+o,129)
J.x(q.a,q.d+o,129)}if(a8){J.x(q.a,q.d+-33,129)
J.x(r.a,r.d+-33,129)
J.x(s.a,s.d+-33,129)}}o=a4.k2
o===$&&A.c("_yuvT")
if(!(p<o.length))return A.a(o,p)
k=o[p]
j=n.a
i=n.e
if(a8){s.c6(-32,16,k.a)
r.c6(-32,8,k.b)
q.c6(-32,8,k.c)}else if(p===0){o=s.a
l=s.d+-33
J.bp(o,l,l+21,127)
l=r.a
o=r.d+-33
J.bp(l,o,o+9,127)
o=q.a
l=q.d+-33
J.bp(o,l,l+9,127)}o=n.b
o===$&&A.c("isIntra4x4")
if(o){h=A.p(s,a5,-16)
g=h.d_()
if(a8){o=a4.at
o.toString
if(p>=o-1){o=k.a[15]
l=h.a
f=h.d
J.bp(l,f,f+4,o)}else{o=a4.k2
l=p+1
if(!(l<o.length))return A.a(o,l)
h.c6(0,4,o[l].a)}}o=g.length
if(0>=o)return A.a(g,0)
e=g[0]
g.$flags&2&&A.b(g)
if(96>=o)return A.a(g,96)
g[96]=e
g[64]=e
g[32]=e
for(o=n.c,d=0;d<16;++d,i=i<<2>>>0){c=A.p(s,a5,B.cd[d])
l=o[d]
if(!(l<10))return A.a(B.c_,l)
B.c_[l].$1(c)
i.toString
l=d*16
a4.f_(i,new A.ag(j,l,Math.min(384,384),l,!1),c)}}else{o=A.n3(p,a7,n.c[0])
o.toString
if(!(o<7))return A.a(B.cc,o)
B.cc[o].$1(s)
if(i!==0)for(d=0;d<16;++d,i=i<<2>>>0){c=A.p(s,a5,B.cd[d])
i.toString
o=d*16
a4.f_(i,new A.ag(j,o,Math.min(384,384),o,!1),c)}}o=n.f
o===$&&A.c("nonZeroUV")
l=A.n3(p,a7,n.d)
l.toString
if(!(l<7))return A.a(B.aU,l)
B.aU[l].$1(r)
B.aU[l].$1(q)
l=Math.min(384,384)
b=new A.ag(j,256,l,256,!1)
if((o&255)!==0){f=a4.e
if((o&170)!==0){f===$&&A.c(a6)
f.bO(b,r)
f.bO(A.p(b,a5,16),A.p(r,a5,4))
a=A.p(b,a5,32)
a0=A.p(r,a5,128)
f.bO(a,a0)
f.bO(A.p(a,a5,16),A.p(a0,a5,4))}else{f===$&&A.c(a6)
f.ht(b,r)}}a1=new A.ag(j,320,l,320,!1)
o=o>>>8
if((o&255)!==0){l=a4.e
if((o&170)!==0){l===$&&A.c(a6)
l.bO(a1,q)
l.bO(A.p(a1,a5,16),A.p(q,a5,4))
o=A.p(a1,a5,32)
f=A.p(q,a5,128)
l.bO(o,f)
l.bO(A.p(o,a5,16),A.p(f,a5,4))}else{l===$&&A.c(a6)
l.ht(a1,q)}}o=a4.ax
o.toString
if(a7<o-1){B.d.au(k.a,0,16,s.a4(),480)
B.d.au(k.b,0,8,r.a4(),224)
B.d.au(k.c,0,8,q.a4(),224)}a2=p*16
a3=p*8
for(m=0;m<16;++m){o=a4.p4
o.toString
l=a4.p1
l===$&&A.c("_cacheY")
l.bq(a2+m*o,16,s,m*32)}for(m=0;m<8;++m){o=a4.R8
o.toString
l=a4.p2
l===$&&A.c("_cacheU")
f=m*32
l.bq(a3+m*o,8,r,f)
o=a4.R8
o.toString
l=a4.p3
l===$&&A.c("_cacheV")
l.bq(a3+m*o,8,q,f)}++p}},
f_(a,b,c){var s,r,q,p,o,n,m="_dsp"
switch(a>>>30){case 3:s=this.e
s===$&&A.c(m)
s.lD(b,c,!1)
break
case 2:this.e===$&&A.c(m)
r=J.d(b.a,b.d)+4
q=B.a.aF(B.a.j(J.d(b.a,b.d+4)*35468,16),32)
p=B.a.aF(B.a.j(J.d(b.a,b.d+4)*85627,16),32)
o=B.a.aF(B.a.j(J.d(b.a,b.d+1)*35468,16),32)
n=B.a.aF(B.a.j(J.d(b.a,b.d+1)*85627,16),32)
A.jB(c,0,r+p,n,o)
A.jB(c,1,r+q,n,o)
A.jB(c,2,r-q,n,o)
A.jB(c,3,r-p,n,o)
break
case 1:s=this.e
s===$&&A.c(m)
s.d0(b,c)
break
default:break}},
j7(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f="_dsp",e=h.p4,d=h.k4
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
if(h.aR===1){if(a>0){s=h.e
s===$&&A.c(f)
e.toString
s.en(r,e,p+4)}if(d.c){s=h.e
s===$&&A.c(f)
e.toString
s.hL(r,e,p)}if(b>0){s=h.e
s===$&&A.c(f)
e.toString
s.eo(r,e,p+4)}if(d.c){d=h.e
d===$&&A.c(f)
e.toString
d.hM(r,e,p)}}else{o=h.R8
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
s.cr(r,1,e,16,n,q,k)
o.toString
s.cr(m,1,o,8,n,q,k)
s.cr(l,1,o,8,n,q,k)}if(d.c){s=h.e
s===$&&A.c(f)
e.toString
s.l8(r,e,p,q,k)
o.toString
j=A.p(m,g,4)
i=A.p(l,g,4)
s.cq(j,1,o,8,p,q,k)
s.cq(i,1,o,8,p,q,k)}if(b>0){s=h.e
s===$&&A.c(f)
e.toString
n=p+4
s.cr(r,e,1,16,n,q,k)
o.toString
s.cr(m,o,1,8,n,q,k)
s.cr(l,o,1,8,n,q,k)}if(d.c){d=h.e
d===$&&A.c(f)
e.toString
d.lG(r,e,p,q,k)
o.toString
s=4*o
j=A.p(m,g,s)
i=A.p(l,g,s)
d.cq(j,o,1,8,p,q,k)
d.cq(i,o,1,8,p,q,k)}}},
jm(){var s,r=this,q=r.ay
q===$&&A.c("_tlMbX")
s=q
for(;;){q=r.CW
q.toString
if(!(s<q))break
r.j7(s,r.y2);++s}},
jp(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.aR
a1.toString
if(!(a1<3))return A.a(B.ad,a1)
s=B.ad[a1]
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
if(a2)a.jm()
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
if(a.bT!=null&&j<i){g=a.xr=a.j_(j,i-j)
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
a.k7(j-f,a.z-b,i-j)}if(a1){a1=a.p1
g=a.p4
g.toString
a1.bq(p,r,o,16*g)
g=a.p2
p=a.R8
p.toString
g.bq(n,q,m,8*p)
p=a.p3
g=a.R8
g.toString
p.bq(n,q,l,8*g)}return!0},
k7(a,b,c){if(b<=0||c<=0)return!1
this.j9(a,b,c)
this.j8(a,b,c)
return!0},
dE(a){var s
if((a&-4194304)>>>0===0)s=B.a.j(a,14)
else s=a<0?0:255
return s},
dn(a,b,c,d){var s=19077*a
d.h(0,0,this.dE(s+26149*c+-3644112))
d.h(0,1,this.dE(s-6419*b-13320*c+2229552))
d.h(0,2,this.dE(s+33050*b+-4527440))},
dm(a7,a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=new A.jK(),a2=b5-1,a3=B.a.j(a2,1),a4=a1.$2(J.d(a9.a,a9.d),J.d(b0.a,b0.d)),a5=a1.$2(J.d(b1.a,b1.d),J.d(b2.a,b2.d)),a6=B.a.j(3*a4+a5+131074,2)
a.dn(J.d(a7.a,a7.d),a6&255,a6>>>16,b3)
b3.h(0,3,255)
s=a8!=null
if(s){a6=B.a.j(3*a5+a4+131074,2)
r=J.d(a8.a,a8.d)
b4.toString
a.dn(r,a6&255,a6>>>16,b4)
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
J.x(e.a,e.d,c)
g=i-6419*h-13320*g+2229552
if((g&-4194304)>>>0===0)c=B.a.j(g,14)
else c=g<0?0:255
J.x(e.a,e.d+1,c)
i=i+33050*h+-4527440
if((i&-4194304)>>>0===0)c=B.a.j(i,14)
else c=i<0?0:255
J.x(e.a,e.d+2,c)
J.x(e.a,e.d+3,255)
i=J.d(a7.a,a7.d+r)
h=k&255
g=k>>>16
e=r*4
d=A.p(b3,a0,e)
i=19077*i
b=i+26149*g+-3644112
if((b&-4194304)>>>0===0)c=B.a.j(b,14)
else c=b<0?0:255
J.x(d.a,d.d,c)
g=i-6419*h-13320*g+2229552
if((g&-4194304)>>>0===0)c=B.a.j(g,14)
else c=g<0?0:255
J.x(d.a,d.d+1,c)
i=i+33050*h+-4527440
if((i&-4194304)>>>0===0)c=B.a.j(i,14)
else c=i<0?0:255
J.x(d.a,d.d+2,c)
J.x(d.a,d.d+3,255)
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
J.x(f.a,f.d,c)
h=j-6419*i-13320*h+2229552
if((h&-4194304)>>>0===0)c=B.a.j(h,14)
else c=h<0?0:255
J.x(f.a,f.d+1,c)
j=j+33050*i+-4527440
if((j&-4194304)>>>0===0)c=B.a.j(j,14)
else c=j<0?0:255
J.x(f.a,f.d+2,c)
J.x(f.a,f.d+3,255)
r=J.d(a8.a,a8.d+r)
j=k&255
i=k>>>16
e=A.p(b4,a0,e)
r=19077*r
h=r+26149*i+-3644112
if((h&-4194304)>>>0===0)c=B.a.j(h,14)
else c=h<0?0:255
J.x(e.a,e.d,c)
i=r-6419*j-13320*i+2229552
if((i&-4194304)>>>0===0)c=B.a.j(i,14)
else c=i<0?0:255
J.x(e.a,e.d+1,c)
r=r+33050*j+-4527440
if((r&-4194304)>>>0===0)c=B.a.j(r,14)
else c=r<0?0:255
J.x(e.a,e.d+2,c)
J.x(e.a,e.d+3,255)}}if((b5&1)===0){a6=B.a.j(3*a4+a5+131074,2)
r=J.d(a7.a,a7.d+a2)
j=a2*4
i=A.p(b3,a0,j)
a.dn(r,a6&255,a6>>>16,i)
i.h(0,3,255)
if(s){a6=B.a.j(3*a5+a4+131074,2)
a2=J.d(a8.a,a8.d+a2)
b4.toString
j=A.p(b4,a0,j)
a.dn(a2,a6&255,a6>>>16,j)
j.h(0,3,255)}}},
j8(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.xr
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
l=l==null?null:l.O(n,p,null);(l==null?new A.C():l).sA(m)}s.d=s.d+j.a}},
j9(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=J.D(g.d.gB(0),0,null),d=g.b.a,c=A.v(e,!1,f,a*d*4),b=g.to
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
if(a===0){g.dm(s,f,r,q,r,q,c,f,a0)
k=a1}else{d=g.RG
d===$&&A.c("_tmpY")
g.dm(d,s,m,l,r,q,A.p(c,f,-n),c,a0)
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
g.dm(A.p(s,f,-i),s,m,l,r,q,A.p(c,f,b),c,a0)}d=s.d
b=g.p4
b.toString
s.d=d+b
if(g.Q+p<g.as){d=g.RG
d===$&&A.c("_tmpY")
d.c6(0,a0,s)
g.rx.c6(0,o,r)
g.ry.c6(0,o,q);--k}else if((p&1)===0)g.dm(s,f,r,q,r,q,A.p(c,f,n),f,a0)
return k},
j_(a,b){var s,r,q,p,o,n,m,l,k,j=this,i="_alphaPlane",h=j.b,g=h.a,f=h.b
if(a<0||b<=0||a+b>f)return null
if(a===0){h=g*f
j.aX=new Uint8Array(h)
s=j.bT
r=new A.jL(s,g,f)
q=s.G()
p=r.d=q&3
r.e=B.a.j(q,2)&3
r.f=B.a.j(q,4)&3
r.r=B.a.j(q,6)&3
if(r.ghj())if(p===0){if(s.c-s.d<h)r.r=1}else if(p===1){o=new A.dv(B.a8,A.j([],t.J))
o.a=g
o.b=f
h=A.j([],t.e)
p=A.j([],t.gk)
n=new Uint32Array(2)
m=new A.hN(s,n)
n=m.e=J.D(B.o.gB(n),0,null)
l=s.G()
n.$flags&2&&A.b(n)
if(0>=n.length)return A.a(n,0)
n[0]=l
l=s.G()
n.$flags&2&&A.b(n)
if(1>=n.length)return A.a(n,1)
n[1]=l
l=s.G()
n.$flags&2&&A.b(n)
if(2>=n.length)return A.a(n,2)
n[2]=l
l=s.G()
n.$flags&2&&A.b(n)
if(3>=n.length)return A.a(n,3)
n[3]=l
l=s.G()
n.$flags&2&&A.b(n)
if(4>=n.length)return A.a(n,4)
n[4]=l
l=s.G()
n.$flags&2&&A.b(n)
if(5>=n.length)return A.a(n,5)
n[5]=l
l=s.G()
n.$flags&2&&A.b(n)
if(6>=n.length)return A.a(n,6)
n[6]=l
s=s.G()
n.$flags&2&&A.b(n)
if(7>=n.length)return A.a(n,7)
n[7]=s
m.b=!1
p=new A.h1(m,o,h,p)
p.dy=g
p.fr=f
r.x=p
p.cE(g,f,!0)
h=r.x
s=h.ch
p=s.length
if(p===1){if(0>=p)return A.a(s,0)
h=s[0].a===B.cD&&h.jG()}else h=!1
if(h){r.y=!0
h=r.x
s=h.c
k=s.a*s.b
h.db=0
s=B.a.a9(k,4)
s=new Uint8Array(k+(4-s))
h.cy=s
h.cx=J.Z(B.d.gB(s),0,null)}else{r.y=!1
r.x.eB(g)}}else r.r=1
j.ck=r}h=j.ck
if(h!=null)if(!h.w){s=j.aX
s===$&&A.c(i)
if(!h.kU(a,b,s))return null}h=j.aX
h===$&&A.c(i)
return A.v(h,!1,null,a*g)},
jV(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=a2.fr.b,a4=a2.dy,a5=a2.k1
a5===$&&A.c("_segment")
if(!(a5<4))return A.a(a4,a5)
s=a4[a5]
a5=a2.bJ
a5===$&&A.c("_mbData")
a4=a2.y1
if(!(a4<a5.length))return A.a(a5,a4)
r=a5[a4]
q=A.v(r.a,!1,null,0)
a4=a2.k3
a4===$&&A.c("_mbInfo")
if(0>=a4.length)return A.a(a4,0)
p=a4[0]
q.lk(0,q.c-q.d,0)
a4=r.b
a4===$&&A.c("isIntra4x4")
if(!a4){o=A.v(new Int16Array(16),!1,null,0)
a4=a6.b
a5=p.b
if(1>=a3.length)return A.a(a3,1)
n=a2.dQ(a7,a3[1],a4+a5,s.b,0,o)
a6.b=p.b=n>0?1:0
if(n>1)a2.kG(o,q)
else{m=B.a.j(J.d(o.a,o.d)+3,3)
for(l=0;l<256;l+=16)J.x(q.a,q.d+l,m)}k=a3[0]
j=1}else{if(3>=a3.length)return A.a(a3,3)
k=a3[3]
j=0}i=a6.a&15
h=p.a&15
for(g=0,f=0;f<4;++f){e=h&1
for(d=0,c=0;c<4;++c){n=a2.dQ(a7,k,e+(i&1),s.a,j,q)
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
i=B.a.a7(a6.a,a5)
h=B.a.a7(p.a,a5)
for(d=0,f=0;f<2;++f){e=h&1
for(c=0;c<2;++c){if(2>=a4)return A.a(a3,2)
n=a2.dQ(a7,a3[2],e+(i&1),s.c,0,q)
e=n>0?1:0
i=i>>>1|e<<3
a5=J.d(q.a,q.d)!==0?1:0
if(n>3)a5=3
else if(n>1)a5=2
d=(d<<2|a5)>>>0
q.d+=16}i=i>>>2
h=h>>>1|e<<5}a0=(a0|B.a.S(d,4*a1))>>>0
a=(a|B.a.S(i<<4>>>0,a1))>>>0
b=(b|B.a.S(h&240,a1))>>>0}a6.a=a
p.a=b
r.e=g
r.f=a0
if((a0&43690)===0)s.toString
return(g|a0)>>>0===0},
kG(a,b){var s,r,q,p,o,n,m,l,k,j,i=new Int32Array(16)
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
J.x(b.a,b.d+k,p)
p=B.a.j(l+m,3)
J.x(b.a,b.d+(k+16),p)
p=B.a.j(q-n,3)
J.x(b.a,b.d+(k+32),p)
p=B.a.j(l-m,3)
J.x(b.a,b.d+(k+48),p)
k+=64}},
jv(a,b){var s,r,q,p,o,n,m
t.L.a(b)
if(a.ad(b[3])===0)s=a.ad(b[4])===0?2:3+a.ad(b[5])
else if(a.ad(b[6])===0)s=a.ad(b[7])===0?5+a.ad(159):7+2*a.ad(165)+a.ad(145)
else{r=a.ad(b[8])
q=9+r
if(!(q<11))return A.a(b,q)
p=2*r+a.ad(b[q])
if(!(p<4))return A.a(B.by,p)
o=B.by[p]
n=o.length
for(s=0,m=0;m<n;++m)s+=s+a.ad(o[m])
s+=3+B.a.S(8,p)}return s},
dQ(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j
t.c7.a(b)
t.L.a(d)
s=b.length
if(!(e<s))return A.a(b,e)
r=b[e].a
if(!(c<r.length))return A.a(r,c)
q=r[c]
for(;e<16;e=p){if(a.ad(q[0])===0)return e
while(a.ad(q[1])===0){++e
if(!(e>=0&&e<17))return A.a(B.ar,e)
r=B.ar[e]
if(!(r<s))return A.a(b,r)
r=b[r].a
if(0>=r.length)return A.a(r,0)
q=r[0]
if(e===16)return 16}p=e+1
if(!(p>=0&&p<17))return A.a(B.ar,p)
r=B.ar[p]
if(!(r<s))return A.a(b,r)
o=b[r].a
r=o.length
if(a.ad(q[2])===0){if(1>=r)return A.a(o,1)
q=o[1]
n=1}else{n=this.jv(a,q)
if(2>=r)return A.a(o,2)
q=o[2]}if(!(e>=0&&e<16))return A.a(B.bT,e)
r=B.bT[e]
m=a.b
m===$&&A.c("_range")
l=a.eF(B.a.j(m,1))
m=a.b
if(m>>>0!==m||m>=128)return A.a(B.ao,m)
k=B.ao[m]
a.b=B.c2[m]
m=a.d
m===$&&A.c("_bits")
a.d=m-k
m=l!==0?-n:n
j=d[e>0?1:0]
J.x(f.a,f.d+r,m*j)}return 16},
jR(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.y1,g=4*h,f=i.go,e=i.id,d=i.bJ
d===$&&A.c("_mbData")
if(!(h<d.length))return A.a(d,h)
s=d[h]
h=i.c
h===$&&A.c("br")
h=h.ad(145)===0
s.b=h
if(!h){if(i.c.ad(156)!==0)r=i.c.ad(128)!==0?1:3
else r=i.c.ad(163)!==0?2:0
h=s.c
h.$flags&2&&A.b(h)
h[0]=r
f.toString
B.d.aD(f,g,g+4,r)
B.d.aD(e,0,4,r)}else{q=s.c
for(p=0,o=0;o<4;++o,p=j){r=e[o]
for(n=0;n<4;++n){h=g+n
if(!(h<f.length))return A.a(f,h)
d=f[h]
if(!(d<10))return A.a(B.bV,d)
d=B.bV[d]
if(!(r>=0&&r<10))return A.a(d,r)
m=d[r]
l=i.c.ad(m[0])
if(!(l<18))return A.a(B.am,l)
k=B.am[l]
while(k>0){d=i.c
if(!(k<9))return A.a(m,k)
d=2*k+d.ad(m[k])
if(!(d>=0&&d<18))return A.a(B.am,d)
k=B.am[d]}r=-k
f.$flags&2&&A.b(f)
f[h]=r}j=p+4
f.toString
B.d.au(q,p,j,f,g)
e.$flags&2&&A.b(e)
if(!(o<4))return A.a(e,o)
e[o]=r}}if(i.c.ad(142)===0)h=0
else if(i.c.ad(114)===0)h=2
else h=i.c.ad(183)!==0?1:3
s.d=h}}
A.jK.prototype={
$2(a,b){return(a|b<<16)>>>0},
$S:14}
A.eN.prototype={
a2(a){var s,r
for(s=0;r=a-1,a>0;a=r)s=(s|B.a.V(this.ad(128),r))>>>0
return s},
cC(a){var s=this.a2(a)
return this.a2(1)===1?-s:s},
ad(a){var s,r=this,q=r.b
q===$&&A.c("_range")
s=r.eF(B.a.j(q*a,8))
if(r.b<=126)r.kD()
return s},
eF(a){var s,r,q,p,o,n=this,m="_value",l=n.d
l===$&&A.c("_bits")
if(l<0){s=n.a
r=s.c
q=s.d
if(r-q>=1){p=s.G()
l=n.c
l===$&&A.c(m)
n.c=(p|l<<8)>>>0
l=n.d+8
n.d=l
o=l}else{if(q<r){l=s.G()
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
if(B.a.aW(l,o)>a){s=n.b
s===$&&A.c("_range")
r=a+1
n.b=s-r
n.c=l-B.a.V(r,o)
return 1}else{n.b=a
return 0}},
kD(){var s,r=this,q=r.b
q===$&&A.c("_range")
if(!(q>=0&&q<128))return A.a(B.ao,q)
s=B.ao[q]
r.b=B.c2[q]
q=r.d
q===$&&A.c("_bits")
r.d=q-s}}
A.jz.prototype={
eo(a,b,c){var s,r=A.p(a,null,0)
for(s=0;s<16;++s){r.d=a.d+s
if(this.fl(r,b,c))this.da(r,b)}},
en(a,b,c){var s,r=A.p(a,null,0)
for(s=0;s<16;++s){r.d=a.d+s*b
if(this.fl(r,1,c))this.da(r,1)}},
hM(a,b,c){var s,r,q=A.p(a,null,0)
for(s=4*b,r=3;r>0;--r){q.d+=s
this.eo(q,b,c)}},
hL(a,b,c){var s,r=A.p(a,null,0)
for(s=3;s>0;--s){r.d+=4
this.en(r,b,c)}},
lG(a,b,c,d,e){var s,r,q=A.p(a,null,0)
for(s=4*b,r=3;r>0;--r){q.d+=s
this.cq(q,b,1,16,c,d,e)}},
l8(a,b,c,d,e){var s,r=A.p(a,null,0)
for(s=3;s>0;--s){r.d+=4
this.cq(r,1,b,16,c,d,e)}},
cr(a,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=A.p(a,null,0)
for(s=-3*a0,r=-2*a0,q=-a0,p=2*a0;o=a2-1,a2>0;a2=o){if(this.fm(b,a0,a3,a4))if(this.fb(b,a0,a5))this.da(b,a0)
else{n=J.d(b.a,b.d+s)
m=J.d(b.a,b.d+r)
l=J.d(b.a,b.d+q)
k=J.d(b.a,b.d)
j=J.d(b.a,b.d+a0)
i=J.d(b.a,b.d+p)
h=$.kY()
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
J.x(b.a,b.d+s,h)
h=$.aH()
g=255+m+d
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.x(b.a,b.d+r,g)
g=$.aH()
h=255+l+e
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.x(b.a,b.d+q,h)
h=$.aH()
g=255+k-e
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.x(b.a,b.d,g)
g=$.aH()
h=255+j-d
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.x(b.a,b.d+a0,h)
h=$.aH()
g=255+i-c
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.x(b.a,b.d+p,g)}b.d+=a1}},
cq(a,b,c,d,e,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=A.p(a,null,0)
for(s=-2*b,r=-b;q=d-1,d>0;d=q){if(this.fm(f,b,e,a0))if(this.fb(f,b,a1))this.da(f,b)
else{p=J.d(f.a,f.d+s)
o=J.d(f.a,f.d+r)
n=J.d(f.a,f.d)
m=J.d(f.a,f.d+b)
l=3*(n-o)
k=$.kZ()
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
J.x(f.a,f.d+s,k)
k=$.aH()
j=255+o+h
if(!(j>=0&&j<766))return A.a(k,j)
j=k[j]
J.x(f.a,f.d+r,j)
j=$.aH()
k=255+n-i
if(!(k>=0&&k<766))return A.a(j,k)
k=j[k]
J.x(f.a,f.d,k)
k=$.aH()
j=255+m-g
if(!(j>=0&&j<766))return A.a(k,j)
j=k[j]
J.x(f.a,f.d+b,j)}f.d+=c}},
da(a,b){var s,r,q,p=J.d(a.a,a.d+-2*b),o=-b,n=J.d(a.a,a.d+o),m=J.d(a.a,a.d),l=J.d(a.a,a.d+b),k=$.kY(),j=1020+p-l
if(!(j>=0&&j<2041))return A.a(k,j)
s=3*(m-n)+k[j]
j=$.kZ()
k=112+B.a.aF(B.a.j(s+4,3),32)
if(!(k>=0&&k<225))return A.a(j,k)
r=j[k]
k=112+B.a.aF(B.a.j(s+3,3),32)
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
fb(a,b,c){var s=J.d(a.a,a.d+-2*b),r=J.d(a.a,a.d+-b),q=J.d(a.a,a.d),p=J.d(a.a,a.d+b),o=$.ib(),n=255+s-r
if(!(n>=0&&n<511))return A.a(o,n)
if(o[n]<=c){n=255+p-q
if(!(n>=0&&n<511))return A.a(o,n)
n=o[n]>c
o=n}else o=!0
return o},
fl(a,b,c){var s,r=J.d(a.a,a.d+-2*b),q=J.d(a.a,a.d+-b),p=J.d(a.a,a.d),o=J.d(a.a,a.d+b),n=$.ib(),m=255+q-p
if(!(m>=0&&m<511))return A.a(n,m)
m=n[m]
n=$.kX()
s=255+r-o
if(!(s>=0&&s<511))return A.a(n,s)
return 2*m+n[s]<=c},
fm(a,b,c,d){var s,r,q,p=J.d(a.a,a.d+-4*b),o=J.d(a.a,a.d+-3*b),n=J.d(a.a,a.d+-2*b),m=J.d(a.a,a.d+-b),l=J.d(a.a,a.d),k=J.d(a.a,a.d+b),j=J.d(a.a,a.d+2*b),i=J.d(a.a,a.d+3*b),h=$.ib(),g=255+m-l
if(!(g>=0&&g<511))return A.a(h,g)
g=h[g]
s=$.kX()
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
A.c0(b,g,0,0,o+i)
A.c0(b,g,1,0,n+j)
A.c0(b,g,2,0,n-j)
A.c0(b,g,3,0,o-i);++r
g+=32}},
lD(a,b,c){this.bO(a,b)
if(c)this.bO(A.p(a,null,16),A.p(b,null,4))},
d0(a,b){var s,r,q=J.d(a.a,a.d)+4
for(s=0;s<4;++s)for(r=0;r<4;++r)A.c0(b,0,r,s,q)},
ht(a,b){var s=this,r=null
if(J.d(a.a,a.d)!==0)s.d0(a,b)
if(J.d(a.a,a.d+16)!==0)s.d0(A.p(a,r,16),A.p(b,r,4))
if(J.d(a.a,a.d+32)!==0)s.d0(A.p(a,r,32),A.p(b,r,128))
if(J.d(a.a,a.d+48)!==0)s.d0(A.p(a,r,48),A.p(b,r,132))}}
A.jE.prototype={}
A.jH.prototype={}
A.jJ.prototype={}
A.eM.prototype={}
A.jI.prototype={}
A.jA.prototype={}
A.bH.prototype={}
A.eP.prototype={}
A.hP.prototype={}
A.eQ.prototype={}
A.eR.prototype={}
A.eO.prototype={
cS(){var s,r,q,p,o=this,n=o.b
if(n.ak(8)!==47)return!1
s=n.ak(14)+1
r=n.ak(14)+1
q=n.ak(1)
o.dy=s
o.fr=r
p=o.c
p.f=B.aA
p.a=s
p.b=r
p.d=q!==0
if(n.ak(3)!==0)return!1
return!0},
bS(){var s,r,q,p,o,n=this,m=null
n.f=0
if(!n.cS())return m
n.cE(n.dy,n.fr,!0)
n.eB(n.dy)
s=n.dy
n.d=A.P(m,m,B.e,0,B.j,n.fr,m,0,4,m,B.e,s,!1)
s=n.cx
s.toString
r=n.c
q=r.a
p=r.b
if(!n.dG(s,q,p,p,n.gk0()))return m
s=r.w
if(s.length!==0){o=A.v(new A.an(s),!1,m,0)
s=n.d
s.toString
s.e=A.l7(o)}return n.d},
eB(a){var s,r=this,q=r.c
q=q.a*q.b+a
s=new Uint32Array(q+a*16)
r.cx=s
r.cy=J.D(B.o.gB(s),0,null)
r.db=q
return!0},
kv(a){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=l.b
r=s.ak(2)
q=l.CW
p=B.a.S(1,r)
if((q&p)>>>0!==0)return!1
l.CW=(q|p)>>>0
o=new A.hO(B.cC)
B.c.C(l.ch,o)
if(!(r<4))return A.a(B.c9,r)
q=B.c9[r]
o.a=q
o.b=a[0]
o.c=a[1]
switch(q.a){case 0:case 1:s=s.ak(3)+2
o.e=s
o.d=l.cE(A.c1(o.b,s),A.c1(o.c,o.e),!1)
break
case 3:n=s.ak(8)+1
if(n>16)m=0
else if(n>4)m=1
else{s=n>2?2:3
m=s}B.c.h(a,0,A.c1(o.b,m))
o.e=m
o.d=l.cE(n,1,!1)
l.je(n,o)
break
case 2:break}return!0},
cE(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c)for(s=k.b,r=t.t,q=b,p=a;s.ak(1)!==0;){o=A.j([p,q],r)
if(!k.kv(o))throw A.h(A.m("Invalid Transform"))
p=o[0]
q=o[1]}else{q=b
p=a}s=k.b
if(s.ak(1)!==0){n=s.ak(4)
if(!(n>=1&&n<=11))throw A.h(A.m("Invalid Color Cache"))}else n=0
if(!k.ki(p,q,n,c))throw A.h(A.m("Invalid Huffman Codes"))
if(n>0){s=B.a.S(1,n)
k.w=s
k.x=new A.jF(new Uint32Array(s),32-n)}else k.w=0
s=k.c
s.a=p
s.b=q
m=k.z
k.Q=A.c1(p,m)
k.y=m===0?4294967295:B.a.S(1,m)-1
if(c){k.f=0
return null}l=new Uint32Array(p*q)
if(!k.dG(l,p,q,q,null))throw A.h(A.m("Failed to decode image data."))
k.f=0
return l},
dG(b5,b6,b7,b8,b9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=this
t.g6.a(b9)
s=b4.f
r=B.a.aw(s,b6)
q=B.a.a9(s,b6)
p=b4.f5(q,r)
o=b4.f
n=b6*b7
m=b6*b8
s=b4.w
l=280+s
k=s>0?b4.x:null
j=b4.y
for(s=b5.length,i=b4.b,h=b9!=null,g=b5.$flags|0,f=o;o<m;){if((q&j)>>>0===0){e=b4.cG(b4.as,b4.Q,b4.z,q,r)
d=b4.ax
if(!(e<d.length))return A.a(d,e)
p=d[e]}c=0
if(p.d){d=p.c
g&2&&A.b(b5)
if(!(o>=0&&o<s))return A.a(b5,o)
b5[o]=d;++o;++q
if(q>=b6){++r
if(h&&r<=b8)b9.$2(r,!0)
if(k!=null)for(d=k.b,b=k.a,a=b.$flags|0;f<o;){if(!(f>=0&&f<s))return A.a(b5,f)
a0=b5[f]
a1=B.a.a3(a0*506832829>>>0,d)
a&2&&A.b(b)
if(!(a1<b.length))return A.a(b,a1)
b[a1]=a0;++f}q=c}continue}if(i.a>=32)i.cg()
if(p.e){a2=i.cX()&63
d=p.f
if(!(a2<d.length))return A.a(d,a2)
a3=d[a2]
d=a3.a
b=i.a
if(d<256){i.a=b+d
d=a3.b
g&2&&A.b(b5)
if(!(o>=0&&o<s))return A.a(b5,o)
b5[o]=d
a4=0}else{i.a=b+(d-256)
a4=a3.b}if(i.b)break
if(a4===0){++o;++q
if(q>=b6){++r
if(h&&r<=b8)b9.$2(r,!0)
if(k!=null)for(d=k.b,b=k.a,a=b.$flags|0;f<o;){if(!(f>=0&&f<s))return A.a(b5,f)
a0=b5[f]
a1=B.a.a3(a0*506832829>>>0,d)
a&2&&A.b(b)
if(!(a1<b.length))return A.a(b,a1)
b[a1]=a0;++f}q=c}continue}}else a4=p.cn(0,i)
if(a4<256){if(p.b){d=p.c
g&2&&A.b(b5)
if(!(o>=0&&o<s))return A.a(b5,o)
b5[o]=(d|a4<<8)>>>0}else{a5=p.cn(1,i)
if(i.a>=32)i.cg()
a6=A.nL(p.cn(2,i),a4,a5,p.cn(3,i))
g&2&&A.b(b5)
if(!(o>=0&&o<s))return A.a(b5,o)
b5[o]=a6}++o;++q
if(q>=b6){++r
if(h&&r<=b8)b9.$2(r,!0)
if(k!=null)for(d=k.b,b=k.a,a=b.$flags|0;f<o;){if(!(f>=0&&f<s))return A.a(b5,f)
a0=b5[f]
a1=B.a.a3(a0*506832829>>>0,d)
a&2&&A.b(b)
if(!(a1<b.length))return A.a(b,a1)
b[a1]=a0;++f}q=c}}else if(a4<280){a7=b4.dd(a4-256)
a8=p.cn(4,i)
if(i.a>=32)i.cg()
a9=b4.fn(b6,b4.dd(a8))
if(o<a9||n-o<a7)return!1
else{b0=o-a9
for(b1=0;b1<a7;++b1){d=o+b1
b=b0+b1
if(!(b>=0&&b<s))return A.a(b5,b)
b=b5[b]
g&2&&A.b(b5)
if(!(d>=0&&d<s))return A.a(b5,d)
b5[d]=b}}o+=a7
q+=a7
while(q>=b6){q-=b6;++r
if(h&&r<=b8)b9.$2(r,!0)}if((q&j)>>>0!==0){e=b4.cG(b4.as,b4.Q,b4.z,q,r)
d=b4.ax
if(!(e<d.length))return A.a(d,e)
p=d[e]}if(k!=null)for(d=k.b,b=k.a,a=b.$flags|0;f<o;){if(!(f>=0&&f<s))return A.a(b5,f)
a0=b5[f]
a1=B.a.a3(a0*506832829>>>0,d)
a&2&&A.b(b)
if(!(a1<b.length))return A.a(b,a1)
b[a1]=a0;++f}}else if(a4<l){a1=a4-280
while(f<o){k.toString
if(!(f>=0&&f<s))return A.a(b5,f)
d=b5[f]
b2=B.a.a3(d*506832829>>>0,k.b)
b=k.a
b.$flags&2&&A.b(b)
if(!(b2<b.length))return A.a(b,b2)
b[b2]=d;++f}d=k.a
b=d.length
if(!(a1<b))return A.a(d,a1)
a=d[a1]
g&2&&A.b(b5)
if(!(o>=0&&o<s))return A.a(b5,o)
b5[o]=a;++o;++q
if(q>=b6){++r
if(h&&r<=b8)b9.$2(r,!0)
for(a=k.b,a0=d.$flags|0;f<o;){if(!(f>=0&&f<s))return A.a(b5,f)
b3=b5[f]
a1=B.a.a3(b3*506832829>>>0,a)
a0&2&&A.b(d)
if(!(a1<b))return A.a(d,a1)
d[a1]=b3;++f}q=c}}else return!1}if(h)b9.$2(r>b8?b8:r,!1)
b4.f=o
return!0},
jG(){var s,r,q,p,o,n,m,l
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
jf(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
if(b&&B.a.a9(a,16)!==0)return
s=g.r
r=a-s
q=g.dy
p=q*s
while(r>0){o=r>16?16:r
n=q*o
m=q*s
l=g.db
g.eC(s,o,p)
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
iI(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i=this,h="_pixels8",g=i.f,f=B.a.aw(g,a1),e=B.a.a9(g,a1),d=i.f5(e,f),c=i.f,b=a1*a2,a=a1*a3,a0=i.y
g=i.b
for(;;){if(!(!g.b&&c<a))break
if((e&a0)>>>0===0){s=i.cG(i.as,i.Q,i.z,e,f)
r=i.ax
if(!(s<r.length))return A.a(r,s)
d=r[s]}if(g.a>=32)g.cg()
q=d.cn(0,g)
if(q<256){r=i.cy
r===$&&A.c(h)
r.$flags&2&&A.b(r)
if(!(c>=0&&c<r.length))return A.a(r,c)
r[c]=q;++c;++e
if(e>=a1){++f
if(B.a.a9(f,16)===0)i.dM(f)
e=0}}else if(q<280){p=i.dd(q-256)
o=d.cn(4,g)
if(g.a>=32)g.cg()
n=i.fn(a1,i.dd(o))
if(c>=n&&b-c>=p)for(r=i.cy,m=0;m<p;++m){r===$&&A.c(h)
l=c+m
k=l-n
j=r.length
if(!(k>=0&&k<j))return A.a(r,k)
k=r[k]
r.$flags&2&&A.b(r)
if(!(l>=0&&l<j))return A.a(r,l)
r[l]=k}else{i.f=c
return!0}c+=p
e+=p
while(e>=a1){e-=a1;++f
if(B.a.a9(f,16)===0)i.dM(f)}if(c<a&&(e&a0)>>>0!==0){s=i.cG(i.as,i.Q,i.z,e,f)
r=i.ax
if(!(s<r.length))return A.a(r,s)
d=r[s]}}else return!1}i.dM(f)
i.f=c
return!0},
dM(a){var s,r,q=this,p=q.r,o=a-p,n=q.cy
n===$&&A.c("_pixels8")
s=A.v(n,!1,null,q.c.a*p)
if(o>0){n=q.dx
n.toString
r=A.v(n,!1,null,q.dy*p)
n=q.ch
if(0>=n.length)return A.a(n,0)
n[0].kQ(p,p+o,s,r)}q.r=a},
k5(a,b){var s,r,q,p,o,n,m=this,l=m.c.a,k=m.r
if(b)if(B.a.a9(a,16)!==0)return
s=a-k
if(s<=0){m.r=a
return}m.eC(k,s,l*k)
for(r=m.db,q=m.r,p=0;p<s;++p,++q)for(o=0;o<m.dy;++o,++r){l=m.cx
if(!(r>=0&&r<l.length))return A.a(l,r)
n=l[r]
l=m.d.a
if(l!=null)l.ar(o,q,n>>>16&255,n>>>8&255,n&255,n>>>24&255)}m.r=a},
eC(a,b,c){var s,r=this,q=r.ch,p=q.length,o=r.c.a,n=a+b,m=r.db,l=r.cx
l.toString
B.o.au(l,m,m+o*b,l,c)
for(;s=p-1,p>0;p=s){if(!(s>=0&&s<q.length))return A.a(q,s)
o=q[s]
l=r.cx
l.toString
o.lf(a,n,l,m,l,m)}},
ki(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1,c=null
if(a1&&e.b.ak(1)!==0){s=2+e.b.ak(3)
r=A.c1(a,s)
q=A.c1(b,s)
p=r*q
o=e.cE(r,q,!1)
if(o==null)return!1
e.z=s
for(n=o.length,m=o.$flags|0,l=d,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
j=o[k]>>>8&65535
m&2&&A.b(o)
o[k]=j
if(j>=l)l=j+1}if(l>1000||l>a*b){c=new Int32Array(1)
B.Z.aD(c,0,1,255)
for(d=0,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
i=o[k]
if(!(i<1))return A.a(c,i)
if(c[i]===-1){h=d+1
c[i]=d
d=h}g=c[i]
m&2&&A.b(o)
o[k]=g}}else d=l}else{o=null
l=1}if(e.b.b)return!1
f=e.kj(a0,d,l,c)
if(f==null)return!1
e.as=o
e.at=d
e.ax=f
return!0},
e2(a,b,c,d,e,f){var s,r=a.a,q=a.b,p=d
do{p-=c
s=q+(b+p)
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
s.a=e
s.b=f}while(p>0)},
jK(a,b,c){var s=B.a.V(1,b-c)
while(b<15){s-=a[b]
if(s<=0)break;++b
s=s<<1>>>0}return b-c},
f9(a,b){var s=B.a.V(1,b-1)
while((a&s)>>>0!==0)s=s>>>1
return s!==0?((a&s-1)>>>0)+s:a},
eH(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.a.S(1,a6),a3=new Int32Array(16),a4=new Int32Array(16)
for(s=a7.length,r=0;r<a8;++r){if(!(r<s))return A.a(a7,r)
q=a7[r]
if(q>15)return 0
if(!(q>=0))return A.a(a3,q)
a3[q]=a3[q]+1}if(a3[0]===a8)return 0
a4[1]=0
for(p=1;p<15;p=o){q=a3[p]
if(q>B.a.S(1,p))return 0
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
a1.e2(a5,0,1,a2,0,a9[0])}return a2}l=a2-1
for(s=a5==null,k=0,j=1,i=1,r=0,p=1,h=2;p<=a6;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
if(!(p<16))return A.a(a3,p)
i-=a3[p]
if(i<0)return 0
if(s)continue
for(g=p&255;a3[p]>0;a3[p]=a3[p]-1,r=f){f=r+1
if(!(r>=0&&r<a9.length))return A.a(a9,r)
a1.e2(a5,k,h,a2,g,a9[r])
k=a1.f9(k,p)}}for(p=a6+1,s=!s,e=a2,d=0,c=4294967295,h=2;p<=15;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
i-=a3[p]
if(i<0)return 0
for(g=p-a6&255;a3[p]>0;a3[p]=a3[p]-1){b=(k&l)>>>0
if(b!==c){if(s)d+=e
a=a1.jK(a3,p,a6)
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
a1.e2(a5,d+B.a.a7(k,a6),h,e,g,a0)
r=f}k=a1.f9(k,p)}}if(j!==2*a4[15]-1)return 0
return a2},
fM(a,b,c,d){var s,r,q,p,o,n,m=this.eH(null,b,c,d,null)
if(m===0||a==null)return m
s=a.b
r=s.d
q=s.e
if(r+m>=q){p=new A.dX()
if(m>q)q=m
o=A.lb(q)
p.e=q
p.b=p.a=o
a.b=p
s=p}n=new Uint16Array(d)
this.eH(s.b,b,c,d,n)
return m},
kh(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.fH(new A.dX())
c.ew(128)
if(this.fM(c,7,a,19)===0)return!1
s=this.b
if(s.ak(1)!==0){r=2+s.ak(2+2*s.ak(3))
if(r>b)return!1}else r=b
for(q=8,p=0;p<b;r=o){o=r-1
if(r===0)break
if(s.a>=32)s.cg()
n=c.b.a
n.toString
m=n.a
n=n.b+(s.cX()&127)
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
if(!(i<3))return A.a(B.bt,i)
h=B.bt[i]
g=B.e8[i]
f=s.ak(h)+g
if(p+f>b)return!1
e=k===16?q:0
for(n=a0.$flags|0;d=f-1,f>0;f=d,p=j){j=p+1
n&2&&A.b(a0)
if(!(p>=0&&p<a0.length))return A.a(a0,p)
a0[p]=e}}}return!0},
fu(a,b,c){var s,r,q,p,o,n,m,l=this.b,k=l.ak(1)
B.Z.aD(b,0,a,0)
if(k!==0){s=l.ak(1)
r=l.ak(l.ak(1)===0?1:8)
b.$flags&2&&A.b(b)
q=b.length
if(!(r<q))return A.a(b,r)
b[r]=1
if(s+1===2){r=l.ak(8)
if(!(r<q))return A.a(b,r)
b[r]=1}p=!0}else{o=new Int32Array(19)
n=l.ak(4)+4
for(m=0;m<n;++m){if(!(m<19))return A.a(B.al,m)
s=B.al[m]
q=l.ak(3)
if(!(s<19))return A.a(o,s)
o[s]=q}p=this.kh(o,a,b)}return p&&!l.b?this.fM(c,8,b,a):0},
d4(a,b,c){var s=c.a,r=a.a
c.a=s+r
c.b=(c.b|B.a.S(a.b,b))>>>0
return r},
iq(a){var s,r,q,p,o,n,m,l,k,j,i=this
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
j=B.a.a7(o,i.d4(k,8,n))
if(1>=r)return A.a(s,1)
m=s[1]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a7(j,i.d4(l[m],16,n))
if(2>=r)return A.a(s,2)
m=s[2]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a7(j,i.d4(l[m],0,n))
if(3>=r)return A.a(s,3)
m=s[3]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
B.a.a7(j,i.d4(l[m],24,n))}}},
kj(a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null,a7=a9>0,a8=280+(a7?B.a.S(1,a9):0)
if(!(a9<12))return A.a(B.bD,a9)
s=B.bD[a9]
r=b2==null
if(r&&b0!==b1)return a6
q=new Int32Array(a8)
p=J.ao(b0,t.ct)
for(o=0;o<b0;++o)p[o]=A.oJ()
n=new A.fH(new A.dX())
n.ew(b0*s)
a5.ay=n
for(n=!r,m=0;m<b1;++m){if(n){if(!(m<b2.length))return A.a(b2,m)
l=b2[m]===-1}else l=!1
if(l)for(k=0;k<5;++k){j=B.bF[k]
if(a5.fu(k===0&&a7?j+B.a.S(1,a9):j,q,a6)===0)return a6}else{if(r)l=m
else{if(!(m<b2.length))return A.a(b2,m)
l=b2[m]}if(!(l>=0&&l<b0))return A.a(p,l)
i=p[l]
h=i.a
for(l=h.length,g=0,f=!0,e=0,k=0;k<5;++k){j=B.bF[k]
if(k===0&&a7)j+=B.a.S(1,a9)
d=a5.fu(j,q,a5.ay)
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
c.b=new A.dW(b.a,b.b+d)
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
c=b[c].b<24}if(c){i.d=!0
b=h[0]
a2=b.a
b=b.b
if(!(b<a2.length))return A.a(a2,b)
i.c=(l|a2[b].b<<8)>>>0}l=c}else l=c
l=!l&&g<6
i.e=l
if(l)a5.iq(i)}}return p},
dd(a){var s
if(a<4)return a+1
s=B.a.j(a-2,1)
return B.a.S(2+(a&1),s)+this.b.ak(s)+1},
fn(a,b){var s,r,q
if(b>120)return b-120
else{s=b-1
if(!(s>=0))return A.a(B.bG,s)
r=B.bG[s]
q=(r>>>4)*a+(8-(r&15))
return q>=1?q:1}},
je(a,b){var s,r,q,p,o,n,m,l,k=B.a.S(1,B.a.a7(8,b.e)),j=new Uint32Array(k),i=b.d
i.toString
s=J.D(B.o.gB(i),0,null)
r=J.D(B.o.gB(j),0,null)
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
cG(a,b,c,d,e){var s
if(c===0||a==null)return 0
s=b*B.a.j(e,c)+B.a.j(d,c)
if(!(s<a.length))return A.a(a,s)
return a[s]},
f5(a,b){var s=this,r=s.cG(s.as,s.Q,s.z,a,b),q=s.ax
if(!(r<q.length))return A.a(q,r)
return q[r]}}
A.h1.prototype={
l5(a,b){return this.jf(a,b)}}
A.hN.prototype={
cX(){var s,r,q,p=this.a
if(p<32){s=this.d
r=B.a.a3(s[0],p)
s=s[1]
if(!(p>=0))return A.a(B.a3,p)
q=r+((s&B.a3[p])>>>0)*(B.a3[32-p]+1)}else{s=this.d
q=p===32?s[1]:B.a.a3(s[1],p-32)}return q},
ak(a){var s,r,q=this
if(!q.b&&a<25){s=q.cX()
if(!(a<33))return A.a(B.a3,a)
r=B.a3[a]
q.a+=a
q.cg()
return(s&r)>>>0}else{q.b=!0
throw A.h(A.m("Not enough data in input."))}},
cg(){var s,r,q,p=this,o=p.c,n=p.d,m=n.$flags|0,l=o.c
for(;;){if(!(p.a>=8&&o.d<l))break
s=J.d(o.a,o.d++)
r=n[0]
q=n[1]
m&2&&A.b(n)
n[0]=(r>>>8)+(q&255)*16777216
n[1]=q>>>8
n[1]=(n[1]|s*16777216)>>>0
p.a-=8}}}
A.jF.prototype={}
A.cz.prototype={
a6(){return"VP8LImageTransformType."+this.b}}
A.hO.prototype={
lf(a,b,c,d,e,f){var s,r,q,p,o=this,n=o.b
switch(o.a.a){case 2:o.kL(e,f,(b-a)*n)
break
case 0:o.ll(a,b,c,d,e,f)
if(b!==o.c){s=f-n
B.o.au(e,s,s+n,c,f+(b-a-1)*n)}break
case 1:o.kR(a,b,c,d,e,f)
break
case 3:if(d===f&&o.e>0){r=b-a
q=r*A.c1(n,o.e)
p=f+r*n-q
B.o.au(e,p,p+q,c,f)
o.h7(a,b,c,p,e,f)}else o.h7(a,b,c,d,e,f)
break}},
kQ(a,b,c,d){var s,r,q,p,o,n,m=this.e,l=B.a.a7(8,m),k=this.b,j=this.d
if(l<8){s=B.a.S(1,m)-1
r=B.a.S(1,l)-1
for(q=a;q<b;++q)for(p=0,o=0;o<k;++o){if((o&s)>>>0===0){p=J.d(c.a,c.d);++c.d}m=(p&r)>>>0
if(!(m>=0&&m<j.length))return A.a(j,m)
m=j[m]
J.x(d.a,d.d,m>>>8&255);++d.d
p=B.a.j(p,l)}}else for(q=a;q<b;++q)for(o=0;o<k;++o){n=J.d(c.a,c.d);++c.d
if(!(n>=0&&n<j.length))return A.a(j,n)
m=j[n]
J.x(d.a,d.d,m>>>8&255);++d.d}},
h7(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=this.e,i=B.a.a7(8,j),h=this.b,g=this.d
if(i<8){s=B.a.S(1,j)-1
r=B.a.S(1,i)-1
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
o=B.a.a7(o,i)}}else for(j=c.length,q=e.$flags|0,p=a;p<b;++p)for(n=0;n<h;++n,f=l,d=m){l=f+1
g.toString
m=d+1
if(!(d>=0&&d<j))return A.a(c,d)
k=c[d]>>>8&255
if(!(k<g.length))return A.a(g,k)
k=g[k]
q&2&&A.b(e)
if(!(f>=0&&f<e.length))return A.a(e,f)
e[f]=k}},
kR(a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.b,a1=a.e,a2=B.a.S(1,a1)-1,a3=A.c1(a0,a1),a4=B.a.j(a5,a.e)*a3
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
i=$.as()
i.$flags&2&&A.b(i)
i[0]=j
j=$.aB()
if(0>=j.length)return A.a(j,0)
h=j[0]
i[0]=k
g=j[0]
f=$.ic()
f.$flags&2&&A.b(f)
f[0]=h*g
e=$.l_()
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
co(a,b){return(((a&4278255360)>>>0)+((b&4278255360)>>>0)&4278255360|(a&16711935)+(b&16711935)&16711935)>>>0},
ll(b1,b2,b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=4278190080,b0=a8.b
if(b1===0){s=b3.length
if(!(b4<s))return A.a(b3,b4)
r=a8.co(b3[b4],a9)
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
m=a8.co(b3[k],m)
k=o+l
r&2&&A.b(b5)
if(!(k<q))return A.a(b5,k)
b5[k]=m}b4+=b0
b6+=b0;++b1}s=a8.e
j=B.a.S(1,s)
i=j-1
h=A.c1(b0,s)
g=B.a.j(b1,a8.e)*h
for(s=b3.length,r=~i,q=b5.length,f=b1;f<b2;){k=b6-b0
if(!(k>=0&&k<q))return A.a(b5,k)
e=b5[k]
if(!(b4<s))return A.a(b3,b4)
k=a8.co(b3[b4],e)
b5.$flags&2&&A.b(b5)
if(!(b6<q))return A.a(b5,b6)
b5[b6]=k
for(d=g,c=1;c<b0;c=a1,d=b){k=a8.d
b=d+1
if(!(d<k.length))return A.a(k,d)
a=k[d]>>>8&15
a0=$.q7[a]
a1=((c&r)>>>0)+j
if(a1>b0)a1=b0
a2=b4+c
k=b6+c
a3=k-b0
a4=a1-c
if(a===0)for(a5=b5.$flags|0,l=0;l<a4;++l){a6=k+l
a7=a2+l
if(!(a7>=0&&a7<s))return A.a(b3,a7)
a7=a8.co(b3[a7],a9)
a5&2&&A.b(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=a7}else if(a===1){a5=k-1
if(!(a5>=0&&a5<q))return A.a(b5,a5)
m=b5[a5]
for(a5=b5.$flags|0,l=0;l<a4;++l){a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
m=a8.co(b3[a6],m)
a6=k+l
a5&2&&A.b(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=m}}else for(l=0;l<a4;++l){a5=k+l
a6=a5-1
if(!(a6>=0&&a6<q))return A.a(b5,a6)
e=a0.$3(b5[a6],b5,a3+l)
a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
a6=a8.co(b3[a6],e)
b5.$flags&2&&A.b(b5)
if(!(a5>=0&&a5<q))return A.a(b5,a5)
b5[a5]=a6}}b4+=b0
b6+=b0;++f
if((f&i)>>>0===0)g+=h}},
kL(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=a.$flags|0,q=0;q<c;++q){p=b+q
if(!(p<s))return A.a(a,p)
o=a[p]
n=o>>>8&255
r&2&&A.b(a)
a[p]=(o&4278255360|(o&16711935)+(n<<16|n)&16711935)>>>0}}}
A.jL.prototype={
ghj(){var s=this,r=s.d
if(r>1||s.e>=4||s.f>1||s.r!==0)return!1
return!0},
kU(a,b,c){var s,r,q,p,o,n,m=this
if(!m.ghj())return!1
s=m.e
if(!(s<4))return A.a(B.ce,s)
r=B.ce[s]
if(m.d===0){s=m.b
q=a*s
p=m.a
B.d.au(c,q,b*s,p.a,p.d-p.b+q)}else{s=a+b
p=m.x
p===$&&A.c("_vp8l")
p.dx=c
o=p.c
if(m.y)s=p.iI(o.a,o.b,s)
else{n=p.cx
n.toString
p=p.dG(n,o.a,o.b,s,t.d6.a(p.gl4()))
s=p}if(!s)return!1}if(r!=null){s=m.b
r.$6(s,m.c,s,a,b,c)}if(m.f===1)if(!m.j6(c,m.b,m.c,a,b))return!1
if(a+b>=m.c)m.w=!0
return!0},
j6(a,b,c,d,e){if(b<=0||c<=0||d<0||e<0||d+e>c)return!1
return!0}}
A.eS.prototype={
ib(a,b){var s=this,r=a.G()
s.r=0
s.f=(r&1)!==0
s.w=a.d-a.b
s.x=b-16}}
A.h2.prototype={}
A.fE.prototype={}
A.fF.prototype={}
A.dW.prototype={
gv(a){return this.a.length-this.b}}
A.dV.prototype={
cn(a,b){var s,r,q,p,o,n=b.cX()&255,m=this.a
if(!(a<m.length))return A.a(m,a)
s=m[a]
r=s.a
q=s.b+n
if(!(q<r.length))return A.a(r,q)
p=r[q].a-8
if(p>0){b.a+=8
o=b.cX()
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
A.dX.prototype={}
A.fH.prototype={
ew(a){var s=this.b=this.a,r=A.lb(a)
s.e=a
s.b=s.a=r}}
A.du.prototype={
a6(){return"WebPFormat."+this.b}}
A.dv.prototype={$iL:1}
A.e5.prototype={}
A.jM.prototype={
bz(a){var s=A.v(t.L.a(a),!1,null,0)
this.b=s
if(!this.f4(s))return!1
return!0},
b7(a){var s,r=this,q=null,p=A.v(t.L.a(a),!1,q,0)
r.b=p
if(!r.f4(p))return q
p=new A.e5(B.a8,A.j([],t.J))
r.a=p
s=r.b
s.toString
if(!r.fN(s,p))return q
p=r.a
switch(p.f.a){case 3:p.as=p.z.length
return p
case 2:s=r.b
s.toString
s.d=p.ay
if(!A.lE(s,p).cS())return q
p=r.a
p.as=p.z.length
return p
case 1:s=r.b
s.toString
s.d=p.ay
if(!A.lC(s,p).cS())return q
p=r.a
p.as=p.z.length
return p
case 0:throw A.h(A.m("Unknown format for WebP"))}},
ap(a){var s,r,q,p=this,o=p.b
if(o==null||p.a==null)return null
s=p.a
if(s.e){s=s.z
r=s.length
if(a>=r)return null
if(!(a<r))return A.a(s,a)
q=s[a]
s=q.x
s===$&&A.c("_frameSize")
r=q.w
r===$&&A.c("_framePosition")
return p.eU(o.c9(s,r),a)}r=s.f
if(r===B.aA)return A.lE(o.c9(s.ch,s.ay),s).bS()
else if(r===B.b4)return A.lC(o.c9(s.ch,s.ay),s).bS()
return null},
b9(a,b){var s,r,q,p,o,n,m,l,k=this,j=null
if(k.b7(t.L.a(a))==null)return j
s=k.a.e
if(!s)return k.ap(0)
for(r=j,q=r,p=0;s=k.a,p<s.as;++p){s=s.z
if(!(p<s.length))return A.a(s,p)
b=s[p]
o=k.ap(p)
if(o==null)continue
o.y=b.e
if(q==null||r==null){s=k.a
n=s.a
s=s.b
m=o.gaE()
l=o.a
l=l==null?j:l.gM()
if(l==null)l=B.e
q=A.P(j,j,l,o.y,B.j,s,j,0,m,j,B.e,n,!1)
r=q}else{r=A.bz(r,!1,!1)
s=b.f
s===$&&A.c("clearFrame")
if(s){s=r.a
if(s!=null)s.b5(0,j)}}A.lT(r,o,B.aD,j,j,b.a,b.b,j,j,j,j)
q.aL(r)}return q},
eU(a,b){var s,r,q,p=null,o=A.j([],t.J),n=new A.e5(B.a8,o)
if(!this.fN(a,n))return p
s=n.f
if(s===B.a8)return p
n.as=this.a.as
if(n.e){s=o.length
if(b>=s)return p
r=o[b]
o=r.x
o===$&&A.c("_frameSize")
s=r.w
s===$&&A.c("_framePosition")
return this.eU(a.c9(o,s),b)}else{q=a.c9(n.ch,n.ay)
if(s===B.aA)return A.lE(q,n).bS()
else if(s===B.b4)return A.lC(q,n).bS()}return p},
f4(a){if(a.al(4)!=="RIFF")return!1
a.k()
if(a.al(4)!=="WEBP")return!1
return!0},
fN(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g
for(s=a.c,r=a.b;a.d<s;){q=a.al(4)
p=a.k()
o=p+1>>>1<<1>>>0
n=a.d
m=n-r
switch(q){case"VP8X":if(!this.jx(a,b))return!1
break
case"VP8 ":b.ay=m
b.ch=p
b.f=B.b4
break
case"VP8L":b.ay=m
b.ch=p
b.f=B.aA
break
case"ALPH":b.toString
n=a.a
l=a.e
k=J.a5(n)
j=k.gv(n)
k=k.gv(n)
n=new A.ag(n,0,Math.min(j,k),0,l)
b.at=n
n.d=a.d
a.d+=o
break
case"ANIM":b.f=B.m2
i=a.k()
n=new Uint8Array(4)
n[0]=i>>>8&255
n[1]=i>>>16&255
n[2]=i>>>24&255
n[3]=i&255
a.p()
break
case"ANMF":if(!this.js(a,b,p))return!1
break
case"ICCP":b.toString
h=a.am(p)
a.d=n+(h.c-h.d)
h.a4()
break
case"EXIF":b.toString
b.w=a.al(p)
break
case"XMP ":b.toString
a.al(p)
break
default:a.d=n+o
break}n=a.d
g=o-(n-r-m)
if(g>0)a.d=n+g}if(!b.d)b.d=b.at!=null
return b.f!==B.a8},
jx(a,b){var s,r,q,p,o=a.G()
if((o&192)!==0)return!1
s=B.a.j(o,4)
r=B.a.j(o,1)
if((o&1)!==0)return!1
if(a.bs()!==0)return!1
q=a.bs()
p=a.bs()
b.a=q+1
b.b=p+1
b.e=(r&1)!==0
b.d=(s&1)!==0
return!0},
js(a,b,c){var s,r=a.bs(),q=a.bs()
a.bs()
a.bs()
s=new A.h2(r*2,q*2,a.bs())
s.ib(a,c)
if(s.r!==0)return!1
B.c.C(b.z,s)
return!0}}
A.jN.prototype={
bH(a){var s=this,r=s.jb(a,a.gR(),a.gK()),q=A.a7(!1,8192),p=r.length,o=(p&1)===1,n=o?1:0
q.a0(s.e4("RIFF"))
q.I(12+(p+n))
q.a0(s.e4("WEBP"))
q.a0(s.e4("VP8L"))
q.I(p)
q.a0(r)
if(o)q.m(0)
return J.D(B.d.gB(q.c),0,q.a)},
jb(f4,f5,f6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2,e3,e4,e5,e6,e7,e8,e9=this,f0=A.a7(!1,8192),f1=f4.gaE()>=4,f2=f1?1:0,f3=f5-1|f6-1<<14|f2<<28
f0.m(47)
f0.m(f3&255)
f0.m(f3>>>8&255)
f0.m(f3>>>16&255)
f0.m(f3>>>24&255)
s=B.a.W(f5+32-1,32)
r=B.a.W(f6+32-1,32)
q=f5*f6
p=new Uint8Array(q)
o=new Uint8Array(q)
n=new Uint8Array(q)
m=new Uint8Array(q)
for(l=0,k=0;k<f6;++k)for(j=0;j<f5;++j){f2=f4.a
i=f2==null?null:f2.O(j,k,null)
if(i==null)i=new A.C()
f2=B.a.L(B.b.i(i.gt()),0,255)
if(!(l>=0&&l<q))return A.a(p,l)
p[l]=f2
f2=B.a.L(B.b.i(i.gn()),0,255)
if(!(l<q))return A.a(o,l)
o[l]=f2
f2=B.a.L(B.b.i(i.gu()),0,255)
if(!(l<q))return A.a(n,l)
n[l]=f2
f2=f1?B.a.L(B.b.i(i.gA()),0,255):255
if(!(l<q))return A.a(m,l)
m[l]=f2;++l}e9.ij(o,p,n,q)
h=e9.kA(o,p,n,m,f5,f6,s,r,32)
e9.ii(o,p,n,m,f5,f6,s,32,h)
f2=t.t
g=A.j([],f2)
f=new A.k_(g)
f.X(1,1)
f.X(2,2)
f.X(1,1)
f.X(0,2)
f.X(3,3)
e9.kK(f,s,r,h)
f.X(0,1)
f.X(0,1)
f.X(0,1)
e=A.j([],t.f7)
d=A.j([],f2)
c=A.j([],f2)
b=A.j([],f2)
f2=t.p
a=A.I(f2,t.L)
a0=new A.jP(p,o,n,m,a)
for(a1=0;a1<q;){if(!(a1>=0))return A.a(p,a1)
a2=a.l(0,(p[a1]<<24|o[a1]<<16|n[a1]<<8|m[a1])>>>0)
a3=0
a4=0
if(a1>0&&a2!=null)for(a5=J.a5(a2),a6=a5.gv(a2)-1;a6>=0;--a6){a7=a5.l(a2,a6)
a8=a1-a7
if(a8>1048456)break
a9=1
for(;;){b0=!1
if(a9<4096){b1=a1+a9
if(b1<q){b2=p[b1]
b3=a7+a9
if(!(b3>=0&&b3<q))return A.a(p,b3)
if(b2===p[b3]){b2=o[b1]
if(!(b3<q))return A.a(o,b3)
if(b2===o[b3]){b2=n[b1]
if(!(b3<q))return A.a(n,b3)
if(b2===n[b3]){b0=m[b1]
if(!(b3<q))return A.a(m,b3)
b3=b0===m[b3]
b0=b3}}}}}if(!b0)break;++a9}if(a9<=a3)b0=a9===a3&&a8<a4
else b0=!0
if(b0){a4=a8
a3=a9}}if(a3>=3){B.c.C(e,!1)
B.c.C(c,a3)
B.c.C(b,a4)
for(b4=0;b4<a3;++b4)a0.$1(a1+b4)
a1+=a3}else{B.c.C(e,!0)
B.c.C(d,a1)
a0.$1(a1);++a1}}b5=A.F(280,0,!1,f2)
b6=A.F(256,0,!1,f2)
b7=A.F(256,0,!1,f2)
b8=A.F(256,0,!1,f2)
b9=A.F(40,0,!1,f2)
for(f2=e.length,c0=0,c1=0,c2=0;c2<e.length;e.length===f2||(0,A.U)(e),++c2)if(e[c2]){c3=c0+1
if(!(c0<d.length))return A.a(d,c0)
c4=d[c0]
if(!(c4<q))return A.a(p,c4)
a5=p[c4]
if(!(a5<280))return A.a(b5,a5)
B.c.h(b5,a5,b5[a5]+1)
if(!(c4<q))return A.a(o,c4)
a5=o[c4]
if(!(a5<256))return A.a(b6,a5)
B.c.h(b6,a5,b6[a5]+1)
if(!(c4<q))return A.a(n,c4)
a5=n[c4]
if(!(a5<256))return A.a(b7,a5)
B.c.h(b7,a5,b7[a5]+1)
if(!(c4<q))return A.a(m,c4)
a5=m[c4]
if(!(a5<256))return A.a(b8,a5)
B.c.h(b8,a5,b8[a5]+1)
c0=c3}else{if(!(c1<c.length))return A.a(c,c1)
a9=c[c1]
if(!(c1<b.length))return A.a(b,c1)
a8=b[c1];++c1
a5=e9.fi(a9)
if(!(a5<280))return A.a(b5,a5)
B.c.h(b5,a5,b5[a5]+1)
a5=e9.fo(e9.eZ(f5,a8))
if(!(a5>=0&&a5<40))return A.a(b9,a5)
B.c.h(b9,a5,b9[a5]+1)}c5=e9.cp(b5,280)
c6=e9.cp(b6,256)
c7=e9.cp(b7,256)
c8=e9.cp(b8,256)
c9=e9.cp(b9,40)
e9.cv(f,280,c5)
e9.cv(f,256,c6)
e9.cv(f,256,c7)
e9.cv(f,256,c8)
e9.cv(f,40,c9)
d0=e9.ca(new Int32Array(A.q(c5)),280)
d1=e9.ca(new Int32Array(A.q(c6)),256)
d2=e9.ca(new Int32Array(A.q(c7)),256)
d3=e9.ca(new Int32Array(A.q(c8)),256)
d4=e9.ca(new Int32Array(A.q(c9)),40)
for(f2=e.length,a5=d4.length,b0=c9.length,b1=d0.length,b2=c5.length,b3=d1.length,d5=c6.length,d6=d2.length,d7=c7.length,d8=d3.length,d9=c8.length,c0=0,c1=0,c2=0;c2<e.length;e.length===f2||(0,A.U)(e),++c2)if(e[c2]){c3=c0+1
if(!(c0<d.length))return A.a(d,c0)
c4=d[c0]
if(!(c4<q))return A.a(p,c4)
e0=p[c4]
if(!(e0<b1))return A.a(d0,e0)
e1=d0[e0]
if(!(e0<b2))return A.a(c5,e0)
f.X(e1,c5[e0])
if(!(c4<q))return A.a(o,c4)
e0=o[c4]
if(!(e0<b3))return A.a(d1,e0)
e1=d1[e0]
if(!(e0<d5))return A.a(c6,e0)
f.X(e1,c6[e0])
if(!(c4<q))return A.a(n,c4)
e0=n[c4]
if(!(e0<d6))return A.a(d2,e0)
e1=d2[e0]
if(!(e0<d7))return A.a(c7,e0)
f.X(e1,c7[e0])
if(!(c4<q))return A.a(m,c4)
e0=m[c4]
if(!(e0<d8))return A.a(d3,e0)
e1=d3[e0]
if(!(e0<d9))return A.a(c8,e0)
f.X(e1,c8[e0])
c0=c3}else{if(!(c1<c.length))return A.a(c,c1)
a9=c[c1]
if(!(c1<b.length))return A.a(b,c1)
a8=b[c1];++c1
e2=e9.fi(a9)
if(!(e2<b1))return A.a(d0,e2)
e0=d0[e2]
if(!(e2<b2))return A.a(c5,e2)
f.X(e0,c5[e2])
e3=e9.jJ(a9)
e4=e3.a
if(e4>0)f.X(e3.b,e4)
e5=e9.eZ(f5,a8)
e6=e9.fo(e5)
if(!(e6>=0&&e6<a5))return A.a(d4,e6)
e0=d4[e6]
if(!(e6<b0))return A.a(c9,e6)
f.X(e0,c9[e6])
e7=e9.jZ(e5)
e8=e7.a
if(e8>0)f.X(e7.b,e8)}if(f.c>0){B.c.C(g,f.b)
f.c=f.b=0}f0.a0(new Uint8Array(A.q(g)))
return J.D(B.d.gB(f0.c),0,f0.a)},
ij(a,b,c,d){var s,r,q,p,o,n,m,l
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
kA(b8,b9,c0,c1,c2,c3,c4,c5,c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=A.F(c4*c5,11,!1,t.p)
for(s=b8.length,r=b9.length,q=c0.length,p=0;p<c5;++p)for(o=p*c4,n=p*c6,m=n+c6,l=0;l<c4;++l){k=l*c6
j=B.a.L(k+c6,0,c2)
i=B.a.L(m,0,c3)
for(h=11,g=2147483647,f=0;f<4;++f){e=B.dR[f]
for(d=n,c=0;d<i;++d)for(b=d===0,a=d*c2,a0=k;a0<j;++a0){a1=a+a0
if(b&&a0===0){a2=0
a3=0
a4=0}else if(b){a5=a1-1
if(!(a5>=0&&a5<s))return A.a(b8,a5)
a2=b8[a5]
if(!(a5<r))return A.a(b9,a5)
a3=b9[a5]
if(!(a5<q))return A.a(c0,a5)
a4=c0[a5]}else{a6=a1-c2
if(a0===0){if(!(a6>=0&&a6<s))return A.a(b8,a6)
a2=b8[a6]
if(!(a6<r))return A.a(b9,a6)
a3=b9[a6]
if(!(a6<q))return A.a(c0,a6)
a4=c0[a6]}else{a5=a1-1
switch(e){case 1:if(!(a5>=0&&a5<s))return A.a(b8,a5)
a2=b8[a5]
if(!(a5<r))return A.a(b9,a5)
a3=b9[a5]
if(!(a5<q))return A.a(c0,a5)
a4=c0[a5]
break
case 2:if(!(a6>=0&&a6<s))return A.a(b8,a6)
a2=b8[a6]
if(!(a6<r))return A.a(b9,a6)
a3=b9[a6]
if(!(a6<q))return A.a(c0,a6)
a4=c0[a6]
break
case 7:if(!(a5>=0&&a5<s))return A.a(b8,a5)
a7=b8[a5]
if(!(a6>=0&&a6<s))return A.a(b8,a6)
a2=a7+b8[a6]>>>1
if(!(a5<r))return A.a(b9,a5)
a7=b9[a5]
if(!(a6<r))return A.a(b9,a6)
a3=a7+b9[a6]>>>1
if(!(a5<q))return A.a(c0,a5)
a7=c0[a5]
if(!(a6<q))return A.a(c0,a6)
a4=a7+c0[a6]>>>1
break
default:a8=a6-1
if(!(a5>=0&&a5<s))return A.a(b8,a5)
a2=b8[a5]
if(!(a8>=0&&a8<s))return A.a(b8,a8)
a7=b8[a8]
if(!(a5<r))return A.a(b9,a5)
a3=b9[a5]
if(!(a8<r))return A.a(b9,a8)
a9=b9[a8]
if(!(a5<q))return A.a(c0,a5)
a4=c0[a5]
if(!(a8<q))return A.a(c0,a8)
b0=c0[a8]
if(!(a6>=0&&a6<s))return A.a(b8,a6)
b1=b8[a6]
if(!(a6<r))return A.a(b9,a6)
b2=b9[a6]
if(!(a6<q))return A.a(c0,a6)
b3=c0[a6]
if(Math.abs(a2-a7)+Math.abs(a3-a9)+Math.abs(a4-b0)<=Math.abs(b1-a7)+Math.abs(b2-a9)+Math.abs(b3-b0)){a4=b3
a3=b2
a2=b1}}}}if(!(a1>=0&&a1<s))return A.a(b8,a1)
b4=b8[a1]-a2&255
if(!(a1<r))return A.a(b9,a1)
b5=b9[a1]-a3&255
if(!(a1<q))return A.a(c0,a1)
b6=c0[a1]-a4&255
a7=b4<128?b4:256-b4
a9=b5<128?b5:256-b5
b0=b6<128?b6:256-b6
c=c+a7+a9+b0}if(c<g){g=c
h=e}}B.c.h(b7,o+l,h)}return b7},
ii(b5,b6,b7,b8,b9,c0,c1,c2,c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4
t.L.a(c3)
s=new Uint8Array(A.q(b5))
r=new Uint8Array(A.q(b6))
q=new Uint8Array(A.q(b7))
p=new Uint8Array(A.q(b8))
for(o=s.length,n=r.length,m=q.length,l=p.length,k=c3.length,j=b5.$flags|0,i=b6.$flags|0,h=b7.$flags|0,g=b8.$flags|0,f=0;f<c0;++f)for(e=f===0,d=f*b9,c=0;c<b9;++c){b=d+c
if(e&&c===0){a=0
a0=0
a1=0
a2=255}else if(e){a3=b-1
if(!(a3>=0&&a3<o))return A.a(s,a3)
a=s[a3]
if(!(a3<n))return A.a(r,a3)
a0=r[a3]
if(!(a3<m))return A.a(q,a3)
a1=q[a3]
if(!(a3<l))return A.a(p,a3)
a2=p[a3]}else{a4=b-b9
if(c===0){if(!(a4>=0&&a4<o))return A.a(s,a4)
a=s[a4]
if(!(a4<n))return A.a(r,a4)
a0=r[a4]
if(!(a4<m))return A.a(q,a4)
a1=q[a4]
if(!(a4<l))return A.a(p,a4)
a2=p[a4]}else{a3=b-1
a5=B.a.gkP(c2)-1
a6=B.a.a3(f,a5)*c1+B.a.a3(c,a5)
if(!(a6>=0&&a6<k))return A.a(c3,a6)
switch(c3[a6]){case 1:if(!(a3>=0&&a3<o))return A.a(s,a3)
a=s[a3]
if(!(a3<n))return A.a(r,a3)
a0=r[a3]
if(!(a3<m))return A.a(q,a3)
a1=q[a3]
if(!(a3<l))return A.a(p,a3)
a2=p[a3]
break
case 2:if(!(a4>=0&&a4<o))return A.a(s,a4)
a=s[a4]
if(!(a4<n))return A.a(r,a4)
a0=r[a4]
if(!(a4<m))return A.a(q,a4)
a1=q[a4]
if(!(a4<l))return A.a(p,a4)
a2=p[a4]
break
case 7:if(!(a3>=0&&a3<o))return A.a(s,a3)
a6=s[a3]
if(!(a4>=0&&a4<o))return A.a(s,a4)
a=a6+s[a4]>>>1
if(!(a3<n))return A.a(r,a3)
a6=r[a3]
if(!(a4<n))return A.a(r,a4)
a0=a6+r[a4]>>>1
if(!(a3<m))return A.a(q,a3)
a6=q[a3]
if(!(a4<m))return A.a(q,a4)
a1=a6+q[a4]>>>1
if(!(a3<l))return A.a(p,a3)
a6=p[a3]
if(!(a4<l))return A.a(p,a4)
a2=a6+p[a4]>>>1
break
default:a7=a4-1
if(!(a3>=0&&a3<o))return A.a(s,a3)
a=s[a3]
if(!(a7>=0&&a7<o))return A.a(s,a7)
a6=s[a7]
if(!(a3<n))return A.a(r,a3)
a0=r[a3]
if(!(a7<n))return A.a(r,a7)
a8=r[a7]
if(!(a3<m))return A.a(q,a3)
a1=q[a3]
if(!(a7<m))return A.a(q,a7)
a9=q[a7]
if(!(a3<l))return A.a(p,a3)
a2=p[a3]
if(!(a7<l))return A.a(p,a7)
b0=p[a7]
if(!(a4>=0&&a4<o))return A.a(s,a4)
b1=s[a4]
if(!(a4<n))return A.a(r,a4)
b2=r[a4]
if(!(a4<m))return A.a(q,a4)
b3=q[a4]
if(!(a4<l))return A.a(p,a4)
b4=p[a4]
if(Math.abs(a-a6)+Math.abs(a0-a8)+Math.abs(a1-a9)+Math.abs(a2-b0)<=Math.abs(b1-a6)+Math.abs(b2-a8)+Math.abs(b3-a9)+Math.abs(b4-b0)){a2=b4
a1=b3
a0=b2
a=b1}}}}if(!(b>=0&&b<o))return A.a(s,b)
a6=s[b]
j&2&&A.b(b5)
if(!(b<b5.length))return A.a(b5,b)
b5[b]=a6-a&255
if(!(b<n))return A.a(r,b)
a6=r[b]
i&2&&A.b(b6)
if(!(b<b6.length))return A.a(b6,b)
b6[b]=a6-a0&255
if(!(b<m))return A.a(q,b)
a6=q[b]
h&2&&A.b(b7)
if(!(b<b7.length))return A.a(b7,b)
b7[b]=a6-a1&255
if(!(b<l))return A.a(p,b)
a6=p[b]
g&2&&A.b(b8)
if(!(b<b8.length))return A.a(b8,b)
b8[b]=a6-a2&255}},
kK(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i
t.L.a(d)
s=b*c
r=A.F(280,0,!1,t.p)
for(q=d.length,p=0;p<q;++p){o=d[p]
if(!(o>=0&&o<280))return A.a(r,o)
B.c.h(r,o,r[o]+1)}n=this.cp(r,280)
m=this.ca(new Int32Array(A.q(n)),280)
a.X(0,1)
this.cv(a,280,n)
a.X(1,1)
a.X(0,1)
a.X(0,1)
a.X(0,1)
a.X(1,1)
a.X(0,1)
a.X(0,1)
a.X(0,1)
a.X(1,1)
a.X(0,1)
a.X(1,1)
a.X(255,8)
a.X(1,1)
a.X(0,1)
a.X(0,1)
a.X(0,1)
for(l=m.length,k=n.length,j=0;j<s;++j){if(!(j<q))return A.a(d,j)
o=d[j]
if(!(o>=0&&o<l))return A.a(m,o)
i=m[o]
if(!(o<k))return A.a(n,o)
a.X(i,n[o])}},
fi(a){var s,r
if(a<=4)return 255+a
s=a-1
r=this.df(s)
return 256+2*r+(B.a.aW(s,r-1)&1)},
jJ(a){var s,r
if(a<=4)return B.cx
s=a-1
r=this.df(s)-1
return new A.cE(r,s-B.a.V(2+(B.a.aW(s,r)&1),r))},
eZ(a,b){var s,r=B.a.aw(b,a),q=b-r*a
if(q<=8&&r<8){s=r*16+8-q
if(!(s>=0&&s<128))return A.a(B.ai,s)
return B.ai[s]+1}else if(q>a-8&&r<7){s=(r+1)*16+8+a-q
if(!(s>=0&&s<128))return A.a(B.ai,s)
return B.ai[s]+1}return b+120},
fo(a){var s,r=a-1
if(r<4)return r
s=this.df(r)
return 2*s+(B.a.aW(r,s-1)&1)},
jZ(a){var s,r=a-1
if(r<4)return B.cx
s=this.df(r)-1
return new A.cE(s,r-B.a.V(2+(B.a.aW(r,s)&1),s))},
df(a){var s
for(s=0;a>1;){a=B.a.j(a,1);++s}return s},
eG(a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5
t.L.a(a6)
s=t.p
r=A.F(a7,0,!1,s)
q=t.t
p=A.j([],q)
for(o=a6.length,n=0;n<a7;++n){if(!(n<o))return A.a(a6,n)
if(a6[n]>0)B.c.C(p,n)}m=p.length
if(m===0){B.c.h(r,0,1)
return r}if(m===1){if(0>=m)return A.a(p,0)
B.c.h(r,p[0],1)
return r}l=2*m
k=A.F(l,0,!1,s)
j=A.F(l,-1,!1,s)
i=A.F(l,-1,!1,s)
for(h=1;;h*=2){for(n=0;g=p.length,n<g;++n){s=p[n]
if(!(s<o))return A.a(a6,s)
B.c.h(k,n,a6[s])
if(!(n<l))return A.a(k,n)
if(k[n]<h)B.c.h(k,n,h)}s=A.j(new Array(g),q)
for(n=0;n<g;++n)s[n]=n
B.c.hN(s,new A.jO(k))
for(m=A.al(s).c,f=s.$flags|0;s.length>1;g=c){e=B.c.c7(s,0)
d=B.c.c7(s,0)
c=g+1
if(!(e<l))return A.a(k,e)
b=k[e]
if(!(d<l))return A.a(k,d)
B.c.h(k,g,b+k[d])
B.c.h(j,g,e)
B.c.h(i,g,d)
b=s.length
a=0
for(;;){if(a<b){a0=s[a]
if(!(a0<l))return A.a(k,a0)
a0=k[a0]
if(!(g<l))return A.a(k,g)
a0=a0<=k[g]}else a0=!1
if(!a0)break;++a}m.a(g)
f&1&&A.b(s,"insert",2)
if(a>b)A.az(A.ly(a,null))
s.splice(a,0,g)}a1=A.j([s[0]],q)
a2=A.j([0],q)
for(a3=0;s=a1.length,s!==0;){if(0>=s)return A.a(a1,-1)
a4=a1.pop()
if(0>=a2.length)return A.a(a2,-1)
a5=a2.pop()
if(!(a4>=0&&a4<l))return A.a(j,a4)
s=j[a4]
if(s===-1){if(!(a4<p.length))return A.a(p,a4)
B.c.h(r,p[a4],a5)
if(a5>a3)a3=a5}else{B.c.C(a1,s)
if(!(a4<l))return A.a(i,a4)
B.c.C(a1,i[a4])
s=a5+1
B.c.C(a2,s)
B.c.C(a2,s)}}if(a3<=a8)break}return r},
cp(a,b){return this.eG(a,b,15)},
cv(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
t.L.a(c)
s=A.j([],t.t)
for(r=c.length,q=0;q<b;++q){if(!(q<r))return A.a(c,q)
if(c[q]>0)B.c.C(s,q)}r=s.length
if(r<=2)r=r===0||B.c.geb(s)<=255
else r=!1
if(r){a.X(1,1)
r=s.length
if(r===0){a.X(0,1)
a.X(0,1)
a.X(0,1)
return}a.X(r-1,1)
if(0>=s.length)return A.a(s,0)
p=s[0]
if(p<=1){a.X(0,1)
a.X(p,1)}else{a.X(1,1)
a.X(p,8)}r=s.length
if(r===2){if(1>=r)return A.a(s,1)
a.X(s[1],8)}else if(r===1)B.c.h(c,p,0)
return}o=this.ir(c,b)
n=A.F(19,0,!1,t.p)
for(r=o.length,m=0;m<o.length;o.length===r||(0,A.U)(o),++m){l=o[m].a
if(!(l>=0&&l<19))return A.a(n,l)
B.c.h(n,l,n[l]+1)}k=this.eG(n,19,7)
j=this.ca(new Int32Array(A.q(k)),19)
r=k.length
q=18
for(;;){if(!(q>=4)){i=4
break}l=B.al[q]
if(!(l<r))return A.a(k,l)
if(k[l]!==0){i=q+1
break}--q}a.X(0,1)
a.X(i-4,4)
for(q=0;q<i;++q){l=B.al[q]
if(!(l<r))return A.a(k,l)
a.X(k[l],3)}a.X(0,1)
for(l=o.length,h=j.length,m=0;m<o.length;o.length===l||(0,A.U)(o),++m){g=o[m]
f=g.a
if(!(f>=0&&f<h))return A.a(j,f)
e=j[f]
if(!(f<r))return A.a(k,f)
a.X(e,k[f])
f=g.b
if(f>0)a.X(g.c,f)}},
ir(a,b){var s,r,q,p,o,n,m,l,k,j
t.L.a(a)
s=A.j([],t.e7)
for(r=a.length,q=0;q<b;){if(!(q>=0&&q<r))return A.a(a,q)
p=a[q]
if(p===0){o=0
for(;;){n=q+o
if(n<b){if(!(n<r))return A.a(a,n)
m=a[n]===0}else m=!1
if(!m)break;++o}for(l=o;l>0;)if(l>=11){k=B.a.L(l,11,138)
B.c.C(s,new A.bJ(18,7,k-11))
l-=k}else if(l>=3){k=B.a.L(l,3,10)
B.c.C(s,new A.bJ(17,3,k-3))
l-=k}else{B.c.C(s,new A.bJ(0,0,0));--l}q=n}else{B.c.C(s,new A.bJ(p,0,0));++q
for(;;){if(q<b){if(!(q>=0&&q<r))return A.a(a,q)
m=a[q]===p}else m=!1
if(!m)break
o=0
for(;;){n=q+o
if(n<b){if(!(n>=0&&n<r))return A.a(a,n)
m=a[n]===p&&o<6}else m=!1
if(!m)break;++o}if(o>=3)B.c.C(s,new A.bJ(16,2,o-3))
else for(j=0;j<o;++j)B.c.C(s,new A.bJ(p,0,0))
q=n}}}return s},
ca(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=t.p,g=A.F(b,0,!1,h)
for(s=a.length,r=0,q=0;q<b;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if(p>r)r=p}if(r===0)return g
o=r+1
n=A.F(o,0,!1,h)
for(q=0;q<b;++q){if(!(q<s))return A.a(a,q)
m=a[q]
if(m>0){if(!(m<o))return A.a(n,m)
B.c.h(n,m,n[m]+1)}}B.c.h(n,0,0)
l=A.F(o,0,!1,h)
for(k=0,j=1;j<=r;++j){h=j-1
if(!(h<o))return A.a(n,h)
k=k+n[h]<<1>>>0
B.c.h(l,j,k)}for(q=0;q<b;++q){if(!(q<s))return A.a(a,q)
i=a[q]
if(i>0){if(!(i<o))return A.a(l,i)
B.c.h(g,q,this.ky(l[i],i))
B.c.h(l,i,l[i]+1)}}return g},
ky(a,b){var s,r
for(s=0,r=0;r<b;++r){s=(s<<1|a&1)>>>0
a=a>>>1}return s},
e4(a){var s,r=a.length,q=new Uint8Array(r)
for(s=0;s<r;++s){if(!(s<r))return A.a(q,s)
q[s]=a.charCodeAt(s)}return q}}
A.jP.prototype={
$1(a){var s,r,q,p,o=this,n=o.a
if(!(a<n.length))return A.a(n,a)
n=n[a]
s=o.b
if(!(a<s.length))return A.a(s,a)
s=s[a]
r=o.c
if(!(a<r.length))return A.a(r,a)
r=r[a]
q=o.d
if(!(a<q.length))return A.a(q,a)
p=o.e.ln((n<<24|s<<16|r<<8|q[a])>>>0,new A.jQ())
n=J.a5(p)
if(n.gv(p)>=64)n.c7(p,0)
n.C(p,a)},
$S:29}
A.jQ.prototype={
$0(){return A.j([],t.t)},
$S:30}
A.jO.prototype={
$2(a,b){var s,r,q
A.o(a)
A.o(b)
s=this.a
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
q=s[a]
if(!(b>=0&&b<r))return A.a(s,b)
return B.a.ds(q,s[b])},
$S:14}
A.bJ.prototype={}
A.k_.prototype={
X(a,b){var s,r,q,p,o,n=this
for(s=n.a;b>0;){r=n.c
q=8-r
p=b<q?b:q
o=B.a.V(1,p)
o=(n.b|B.a.V((a&o-1)>>>0,r))>>>0
n.b=o
a=B.a.aW(a,p)
b-=p
r+=p
n.c=r
if(r===8){B.c.C(s,o)
n.c=n.b=0}}}}
A.fI.prototype={
a6(){return"IccProfileCompression."+this.b}}
A.cY.prototype={
kS(){var s,r=this
if(r.b===B.aM)return r.c
s=B.b9.he(t.L.a(r.c),null)
r.c=s
r.b=B.aM
return s},
l0(){var s,r=this
if(r.b===B.aL)return r.c
s=B.F.c4(r.c)
r.c=s
r.b=B.aL
return s}}
A.fD.prototype={
a6(){return"FrameType."+this.b}}
A.bj.prototype={
gaj(){var s=this.x
return s===$?this.x=A.j([],t.g):s},
i5(a,b,c,d){var s,r,q,p=this,o=a.gM(),n=a.gaE(),m=a.a
p.eS(d,b,o,n,m==null?null:m.gN())
o=a.b
if(o!=null)p.b=A.eb(o,t.N,t.w)
o=a.d
if(o!=null){n=t.N
p.d=A.eb(o,n,n)}B.c.C(p.gaj(),p)
if(!c){s=a.gaj().length
for(o=t.g,r=1;r<s;++r){q=a.x
if(q===$)q=a.x=A.j([],o)
if(!(r<q.length))return A.a(q,r)
p.aL(A.fN(q[r],b,!1,d))}}},
i4(a,b,c){var s,r,q,p,o=this,n=a.b
if(n!=null)o.b=A.eb(n,t.N,t.w)
n=a.d
if(n!=null){s=t.N
o.d=A.eb(n,s,s)}B.c.C(o.gaj(),o)
if(!b&&a.gaj().length>1){r=a.gaj().length
for(n=t.g,q=1;q<r;++q){p=a.x
if(p===$)p=a.x=A.j([],n)
if(!(q<p.length))return A.a(p,q)
o.aL(A.bz(p[q],!1,!1))}}},
aL(a){var s=this
if(a==null)a=A.bz(s,!0,!0)
a.z=s.gaj().length
if(s.gaj().length===0||B.c.geb(s.gaj())!==a)B.c.C(s.gaj(),a)
return a},
dq(){return this.aL(null)},
eS(a,b,c,d,e){var s,r,q=this,p=null
switch(c.a){case 0:if(e==null){s=B.b.be(a*d/8)
r=new A.d1($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.be(a/8)
r=new A.d1($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 1:if(e==null){s=B.b.be(a*(d<<1>>>0)/8)
r=new A.d3($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.be(a/4)
r=new A.d3($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 2:if(e==null){if(d===2)s=a
else if(d===4)s=a*2
else s=d===3?B.b.be(a*1.5):B.b.be(a/2)
r=new A.d5($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.be(a/2)
r=new A.d5($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 3:if(e==null)q.a=A.mB(a,b,d)
else q.a=new A.d6(new Uint8Array(a*b),e,a,b,1)
break
case 4:s=a*b
if(e==null)q.a=new A.d2(new Uint16Array(s*d),p,a,b,d)
else q.a=new A.d2(new Uint16Array(s),e,a,b,1)
break
case 5:q.a=A.oN(a,b,d)
break
case 6:q.a=new A.e1(new Int8Array(a*b*d),a,b,d)
break
case 7:q.a=new A.e_(new Int16Array(a*b*d),a,b,d)
break
case 8:q.a=new A.e0(new Int32Array(a*b*d),a,b,d)
break
case 9:q.a=A.oL(a,b,d)
break
case 10:q.a=A.oM(a,b,d)
break
case 11:q.a=new A.dZ(new Float64Array(a*b*4*d),a,b,d)
break}},
D(a){var s=this
return"Image("+s.gR()+", "+s.gK()+", "+s.gM().b+", "+s.gaE()+")"},
gR(){var s=this.a
s=s==null?null:s.a
return s==null?0:s},
gK(){var s=this.a
s=s==null?null:s.b
return s==null?0:s},
gM(){var s=this.a
s=s==null?null:s.gM()
return s==null?B.e:s},
gbI(){var s=this.e
return s==null?this.e=new A.bQ(A.I(t.N,t.P)):s},
hG(a,b){var s=this,r=s.b;(r==null?s.b=A.I(t.N,t.w):r).h(0,a,b)
if(s.b.a===0)s.b=null},
gH(a){var s=this.a
return s.gH(s)},
gB(a){var s=this.a
s=s==null?null:s.gB(s)
if(s==null)s=B.d.gB(new Uint8Array(0))
return s},
a4(){var s=this.a
s=s==null?null:J.aC(s.gB(s))
return s==null?J.aC(this.gB(0)):s},
gcV(a){var s=this.a
s=s==null?null:J.oe(s.gB(s))
return s==null?0:s},
gaE(){var s=this.a
s=s==null?null:s.gN()
s=s==null?null:s.b
if(s==null){s=this.a
s=s==null?null:s.c}return s==null?0:s},
gb2(){var s=this.a
s=s==null?null:s.gb2()
return s===!0},
gaN(){var s=this.a
return(s==null?null:s.gN())!=null},
gaM(){var s=this.a
s=s==null?null:s.gaM()
return s==null?0:s},
hh(a,b){return a>=0&&b>=0&&a<this.gR()&&b<this.gK()},
b3(a,b,c,d){var s=this.a
s=s==null?null:s.b3(a,b,c,d)
if(s==null)s=new A.bO(new Uint8Array(0))
return s},
O(a,b,c){var s=this.a
s=s==null?null:s.O(a,b,c)
return s==null?new A.C():s},
aP(a,b){return this.O(a,b,null)},
aq(a,b){if(a<0||a>=this.gR()||b<0||b>=this.gK())return new A.C()
return this.O(a,b,null)},
hA(a,b,c){switch(c.a){case 0:return this.aq(B.b.i(a),B.b.i(b))
case 1:case 3:return this.hB(a,b)
case 2:return this.hz(a,b)}},
hB(a,b){var s,r,q,p,o,n,m=this,l=B.b.i(a),k=l-(a>=0?0:1),j=k+1
l=B.b.i(b)
s=l-(b>=0?0:1)
r=s+1
l=new A.iJ(a-k,b-s)
q=m.aq(k,s)
p=r>=m.gK()?q:m.aq(k,r)
o=j>=m.gR()?q:m.aq(j,s)
n=j>=m.gR()||r>=m.gK()?q:m.aq(j,r)
return m.b3(l.$4(q.gn(),o.gn(),p.gn(),n.gn()),l.$4(q.gt(),o.gt(),p.gt(),n.gt()),l.$4(q.gu(),o.gu(),p.gu(),n.gu()),l.$4(q.gA(),o.gA(),p.gA(),n.gA()))},
hz(d2,d3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6=this,c7=B.b.i(d2),c8=c7-(d2>=0?0:1),c9=c8-1,d0=c8+1,d1=c8+2
c7=B.b.i(d3)
s=c7-(d3>=0?0:1)
r=s-1
q=s+1
p=s+2
o=d2-c8
n=d3-s
c7=new A.iI()
m=c6.aq(c8,s)
l=c9<0
k=!l
j=!k||r<0?m:c6.aq(c9,r)
i=l?m:c6.aq(c8,r)
h=r<0
g=h||d0>=c6.gR()?m:c6.aq(d0,r)
f=d1>=c6.gR()||h?m:c6.aq(d1,r)
e=c7.$5(o,j.gn(),i.gn(),g.gn(),f.gn())
d=c7.$5(o,j.gt(),i.gt(),g.gt(),f.gt())
c=c7.$5(o,j.gu(),i.gu(),g.gu(),f.gu())
b=c7.$5(o,j.gA(),i.gA(),g.gA(),f.gA())
a=l?m:c6.aq(c9,s)
a0=d0>=c6.gR()?m:c6.aq(d0,s)
a1=d1>=c6.gR()?m:c6.aq(d1,s)
a2=c7.$5(o,a.gn(),m.gn(),a0.gn(),a1.gn())
a3=c7.$5(o,a.gt(),m.gt(),a0.gt(),a1.gt())
a4=c7.$5(o,a.gu(),m.gu(),a0.gu(),a1.gu())
a5=c7.$5(o,a.gA(),m.gA(),a0.gA(),a1.gA())
a6=!k||q>=c6.gK()?m:c6.aq(c9,q)
a7=q>=c6.gK()?m:c6.aq(c8,q)
a8=d0>=c6.gR()||q>=c6.gK()?m:c6.aq(d0,q)
a9=d1>=c6.gR()||q>=c6.gK()?m:c6.aq(d1,q)
b0=c7.$5(o,a6.gn(),a7.gn(),a8.gn(),a9.gn())
b1=c7.$5(o,a6.gt(),a7.gt(),a8.gt(),a9.gt())
b2=c7.$5(o,a6.gu(),a7.gu(),a8.gu(),a9.gu())
b3=c7.$5(o,a6.gA(),a7.gA(),a8.gA(),a9.gA())
b4=!k||p>=c6.gK()?m:c6.aq(c9,p)
b5=p>=c6.gK()?m:c6.aq(c8,p)
b6=d0>=c6.gR()||p>=c6.gK()?m:c6.aq(d0,p)
b7=d1>=c6.gR()||p>=c6.gK()?m:c6.aq(d1,p)
b8=c7.$5(o,b4.gn(),b5.gn(),b6.gn(),b7.gn())
b9=c7.$5(o,b4.gt(),b5.gt(),b6.gt(),b7.gt())
c0=c7.$5(o,b4.gu(),b5.gu(),b6.gu(),b7.gu())
c1=c7.$5(o,b4.gA(),b5.gA(),b6.gA(),b7.gA())
c2=c7.$5(n,e,a2,b0,b8)
c3=c7.$5(n,d,a3,b1,b9)
c4=c7.$5(n,c,a4,b2,c0)
c5=c7.$5(n,b,a5,b3,c1)
return c6.b3(B.b.i(c2),B.b.i(c3),B.b.i(c4),B.b.i(c5))},
c8(a,b,c){var s
if(t.dv.b(c))if(c.gbg().gN()!=null)if(this.gaN()){s=this.a
if(s!=null)s.aa(a,b,c.gT(),0,0)
return}s=this.a
if(s!=null)s.ar(a,b,c.gn(),c.gt(),c.gu(),c.gA())},
hH(a,b,c){var s=this.a
return s==null?null:s.aJ(a,b,c)},
aa(a,b,c,d,e){var s=this.a
return s==null?null:s.aa(a,b,c,d,e)},
gF(){var s=this.a
s=s==null?null:s.gF()
return s==null?0:s},
b5(a,b){var s=this.a
return s==null?null:s.b5(0,b)},
e5(a){return this.b5(0,null)},
cQ(a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null
if(a7==null)a7=a5.gM()
if(a8==null)a8=a5.gaE()
s=B.ck.l(0,a7)
r=!1
if(a7===a5.gM())if(a8===a5.gaE()){if(!a9){q=a5.a
q=(q==null?a6:q.gN())==null}else q=!1
if(!q){if(a9){r=a5.a
r=(r==null?a6:r.gN())!=null}}else r=!0}if(r){p=A.bz(a5,!1,!1)
return p}for(r=a5.gaj(),q=r.length,o=t.N,n=t.p,m=a6,l=0;l<r.length;r.length===q||(0,A.U)(r),++l,m=d){k=r[l]
j=k.a
i=j==null
h=i?a6:j.a
if(h==null)h=0
j=i?a6:j.b
if(j==null)j=0
i=k.e
i=i==null?a6:A.dN(i)
g=k.c
if(g==null)g=a6
else{f=g.a
e=g.b
g=g.c
g=new A.cY(f,e,new Uint8Array(g.subarray(0,A.ba(0,a6,g.length))))}f=k.w
e=k.r
p=A.P(a6,i,a7,k.y,f,j,g,e,a8,a6,B.e,h,a9)
j=k.d
p.slB(j!=null?A.eb(j,o,o):a6)
if(m!=null){m.aL(p)
d=m}else d=p
j=p.a
c=j==null?a6:j.gN()
j=p.a
j=j==null?a6:j.gN()
b=j==null?a6:j.gM()
if(b==null)b=a7
j=k.a
if(c!=null){a=A.I(n,n)
a0=j==null?a6:j.O(0,0,a6)
if(a0==null)a0=new A.C()
for(j=p.a,j=j.gH(j),a1=a6,a2=0;j.E();){a3=j.gP()
a4=A.nL(B.b.bo(a0.gag()*255),B.b.bo(a0.gac()*255),B.b.bo(a0.gaf()*255),0)
if(a.a8(a4)){i=a.l(0,a4)
i.toString
a3.sT(i)}else{a.h(0,a4,a2)
a3.sT(a2)
a1=A.aO(a0,s,b,a8,a1)
c.b4(a2,a1.gn(),a1.gt(),a1.gu());++a2}a0.E()}}else{a0=j==null?a6:j.O(0,0,a6)
if(a0==null)a0=new A.C()
for(j=p.a,j=j.gH(j);j.E();){A.aO(a0,s,a6,a6,j.gP())
a0.E()}}}m.toString
return m},
aQ(a){return this.cQ(a,null,!1)},
e8(a){return this.cQ(null,a,!1)},
cj(a,b){return this.cQ(a,null,b)},
cP(a,b){return this.cQ(a,b,!1)},
kN(a){var s,r,q,p
t.ck.a(a)
if(this.d==null){s=t.N
this.d=A.I(s,s)}for(s=new A.Q(a,a.r,a.e,A.l(a).q("Q<1>"));s.E();){r=s.d
q=this.d
q.toString
p=a.l(0,r)
p.toString
q.h(0,r,p)}},
iC(a,b,c){var s,r=65536
switch(b.a){case 0:return null
case 1:return null
case 2:return null
case 3:s=a===B.n?r:256
return new A.aL(new Uint8Array(s*c),s,c)
case 4:s=a===B.n?r:256
return new A.ev(new Uint16Array(s*c),s,c)
case 5:s=a===B.n?r:256
return new A.de(new Uint32Array(s*c),s,c)
case 6:s=a===B.n?r:256
return new A.eu(new Int8Array(s*c),s,c)
case 7:s=a===B.n?r:256
return new A.es(new Int16Array(s*c),s,c)
case 8:s=a===B.n?r:256
return new A.et(new Int32Array(s*c),s,c)
case 9:s=a===B.n?r:256
return new A.ep(new Uint16Array(s*c),s,c)
case 10:s=a===B.n?r:256
return new A.eq(new Float32Array(s*c),s,c)
case 11:s=a===B.n?r:256
return new A.er(new Float64Array(s*c),s,c)}},
slB(a){this.d=t.cZ.a(a)}}
A.iJ.prototype={
$4(a,b,c,d){var s=this.b
return a+this.a*(b-a+s*(a+d-c-b))+s*(c-a)},
$S:31}
A.iI.prototype={
$5(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
$S:32}
A.af.prototype={
gN(){return null}}
A.d_.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Uint16Array(r.length)
else r=new Uint16Array(A.q(r))
return new A.d_(r,s.a,s.b,s.c)},
gM(){return B.G},
gbp(){return B.aK},
gB(a){return B.A.gB(this.d)},
gaM(){return 16},
gbh(){return this.a*this.c*2},
gH(a){return A.li(this)},
bi(a,b,c,d,e){return A.b7(A.li(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gF(){return 1},
gb2(){return!0},
b3(a,b,c,d){var s=new Uint16Array(4),r=new A.cJ(s)
s[0]=A.K(a)
s[1]=A.K(b)
s[2]=A.K(c)
s[3]=A.K(d)
s=r
return s},
O(a,b,c){if(c==null||!(c instanceof A.cl)||c.d!==this)c=A.li(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=A.K(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aa(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.K(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=A.K(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=A.K(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.K(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=A.K(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=A.K(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=A.K(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
D(a){return"ImageDataFloat16("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){}}
A.d0.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Float32Array(r.length)
else r=new Float32Array(A.q(r))
return new A.d0(r,s.a,s.b,s.c)},
gM(){return B.O},
gbp(){return B.aK},
gB(a){return B.a4.gB(this.d)},
gaM(){return 32},
gH(a){return A.lj(this)},
bi(a,b,c,d,e){return A.b7(A.lj(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gF(){return 1},
gbh(){return this.a*this.c*4},
gb2(){return!0},
b3(a,b,c,d){var s=new Float32Array(4),r=new A.cK(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
O(a,b,c){if(c==null||!(c instanceof A.cm)||c.d!==this)c=A.lj(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s=this.c,r=b*this.a*s+a*s
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
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
A.dZ.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Float64Array(r.length)
else r=new Float64Array(A.q(r))
return new A.dZ(r,s.a,s.b,s.c)},
gM(){return B.Q},
gbp(){return B.aK},
gB(a){return B.a5.gB(this.d)},
gv(a){return this.d.byteLength},
gaM(){return 64},
gH(a){return A.lk(this)},
bi(a,b,c,d,e){return A.b7(A.lk(this),b,c,d,e)},
gF(){return 1},
gbh(){return this.a*this.c*8},
gb2(){return!0},
b3(a,b,c,d){var s=new Float64Array(4),r=new A.cL(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
O(a,b,c){if(c==null||!(c instanceof A.cn)||c.d!==this)c=A.lk(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s=this.c,r=b*this.a*s+a*s
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
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
A.e_.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Int16Array(r.length)
else r=new Int16Array(A.q(r))
return new A.e_(r,s.a,s.b,s.c)},
gM(){return B.S},
gbp(){return B.aJ},
gB(a){return B.ax.gB(this.d)},
gH(a){return A.ll(this)},
bi(a,b,c,d,e){return A.b7(A.ll(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gF(){return 32767},
gb2(){return!0},
gaM(){return 16},
gbh(){return this.a*this.c*2},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int16Array(4),n=new A.cM(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
O(a,b,c){if(c==null||!(c instanceof A.co)||c.d!==this)c=A.ll(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
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
A.e0.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Int32Array(r.length)
else r=new Int32Array(A.q(r))
return new A.e0(r,s.a,s.b,s.c)},
gM(){return B.T},
gbp(){return B.aJ},
gB(a){return B.Z.gB(this.d)},
gaM(){return 32},
gbh(){return this.a*this.c*4},
gH(a){return A.lm(this)},
bi(a,b,c,d,e){return A.b7(A.lm(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gF(){return 2147483647},
gb2(){return!0},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int32Array(4),n=new A.cN(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
O(a,b,c){if(c==null||!(c instanceof A.cp)||c.d!==this)c=A.lm(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
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
A.e1.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Int8Array(r.length)
else r=new Int8Array(A.q(r))
return new A.e1(r,s.a,s.b,s.c)},
gM(){return B.R},
gbp(){return B.aJ},
gB(a){return B.ay.gB(this.d)},
gbh(){return this.a*this.c},
gH(a){return A.ln(this)},
bi(a,b,c,d,e){return A.b7(A.ln(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gF(){return 127},
gb2(){return!0},
gaM(){return 8},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int8Array(4),n=new A.cO(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
O(a,b,c){if(c==null||!(c instanceof A.cq)||c.d!==this)c=A.ln(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
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
A.d1.prototype={
lM(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.m0("data")
this.d=s},
bm(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.q(q))}s=r.f
s=s==null?null:s.U()
return new A.d1(q,r.e,s,r.a,r.b,r.c)},
gM(){return B.y},
gbp(){return B.N},
gv(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gF(){var s=this.f
s=s==null?null:s.gF()
return s==null?1:s},
gb2(){return!1},
gB(a){var s=this.d
s===$&&A.c("data")
return B.d.gB(s)},
gaM(){return 1},
gH(a){return A.ew(this)},
bi(a,b,c,d,e){return A.b7(A.ew(this),b,c,d,e)},
b3(a,b,c,d){var s=new A.cQ(4,0)
s.ae(B.b.i(a),B.b.i(b),B.b.i(c),B.b.i(d))
return s},
O(a,b,c){if(c==null||!(c instanceof A.cr)||c.f!==this)c=A.ew(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ew(r):s).a5(a,b)
r.r.az(0,c)},
aa(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ew(r):s).a5(a,b)
r.r.av(c,d,e)},
ar(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ew(r):s).a5(a,b)
r.r.ae(c,d,e,f)},
D(a){return"ImageDataUint1("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gbh(){return this.e},
gN(){return this.f}}
A.d2.prototype={
bm(a){var s,r=this,q=r.d
if(a)q=new Uint16Array(q.length)
else q=new Uint16Array(A.q(q))
s=r.e
s=s==null?null:s.U()
return new A.d2(q,s,r.a,r.b,r.c)},
gM(){return B.n},
gbp(){return B.N},
gB(a){return B.A.gB(this.d)},
gaM(){return 16},
gF(){var s=this.e
s=s==null?null:s.gF()
return s==null?65535:s},
gbh(){return this.a*this.c*2},
gH(a){return A.lo(this)},
bi(a,b,c,d,e){return A.b7(A.lo(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gb2(){return!0},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Uint16Array(4),n=new A.cR(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
O(a,b,c){if(c==null||!(c instanceof A.cs)||c.d!==this)c=A.lo(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
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
gN(){return this.e}}
A.d3.prototype={
lN(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.m0("data")
this.d=s},
bm(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.q(q))}s=r.f
s=s==null?null:s.U()
return new A.d3(q,r.e,s,r.a,r.b,r.c)},
gM(){return B.t},
gbp(){return B.N},
gaM(){return 2},
gB(a){var s=this.d
s===$&&A.c("data")
return B.d.gB(s)},
gH(a){return A.ex(this)},
bi(a,b,c,d,e){return A.b7(A.ex(this),b,c,d,e)},
gv(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gF(){var s=this.f
s=s==null?null:s.gF()
return s==null?3:s},
gb2(){return!1},
b3(a,b,c,d){var s=new A.cS(4,0)
s.ae(B.b.i(a),B.b.i(b),B.b.i(c),B.b.i(d))
return s},
O(a,b,c){if(c==null||!(c instanceof A.ct)||c.f!==this)c=A.ex(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ex(r):s).a5(a,b)
r.r.aA(0,c)},
aa(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ex(r):s).a5(a,b)
r.r.av(c,d,e)},
ar(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ex(r):s).a5(a,b)
r.r.ae(c,d,e,f)},
D(a){return"ImageDataUint2("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gbh(){return this.e},
gN(){return this.f}}
A.d4.prototype={
bm(a){var s=this,r=s.d
if(a)r=new Uint32Array(r.length)
else r=new Uint32Array(A.q(r))
return new A.d4(r,s.a,s.b,s.c)},
gM(){return B.P},
gbp(){return B.N},
gB(a){return B.o.gB(this.d)},
gbh(){return this.a*this.c*4},
gaM(){return 32},
gF(){return 4294967295},
gH(a){return A.lp(this)},
bi(a,b,c,d,e){return A.b7(A.lp(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gb2(){return!0},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Uint32Array(4),n=new A.cT(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
O(a,b,c){if(c==null||!(c instanceof A.cu)||c.d!==this)c=A.lp(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
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
A.d5.prototype={
lO(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.m0("data")
this.d=s},
bm(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.q(q))}s=r.f
s=s==null?null:s.U()
return new A.d5(q,r.e,s,r.a,r.b,r.c)},
gM(){return B.z},
gbp(){return B.N},
gB(a){var s=this.d
s===$&&A.c("data")
return B.d.gB(s)},
gH(a){return A.ey(this)},
bi(a,b,c,d,e){return A.b7(A.ey(this),b,c,d,e)},
gv(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gF(){var s=this.f
s=s==null?null:s.gF()
return s==null?15:s},
gb2(){return!1},
gaM(){return 4},
b3(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new A.cU(4,new Uint8Array(2))
o.ae(s,r,q,p)
s=o
return s},
O(a,b,c){if(c==null||!(c instanceof A.cv)||c.e!==this)c=A.ey(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ey(r):s).a5(a,b)
r.r.aB(0,c)},
aa(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ey(r):s).a5(a,b)
r.r.av(c,d,e)},
ar(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ey(r):s).a5(a,b)
r.r.ae(c,d,e,f)},
D(a){return"ImageDataUint4("+this.a+", "+this.b+", "+this.c+")"},
b5(a,b){},
gbh(){return this.e},
gN(){return this.f}}
A.d6.prototype={
bm(a){var s,r=this,q=r.d
if(a)q=new Uint8Array(q.length)
else q=new Uint8Array(A.q(q))
s=r.e
s=s==null?null:s.U()
return new A.d6(q,s,r.a,r.b,r.c)},
gM(){return B.e},
gbp(){return B.N},
gB(a){return B.d.gB(this.d)},
gbh(){return this.a*this.c},
gaM(){return 8},
gH(a){return A.j9(this)},
bi(a,b,c,d,e){return A.b7(A.j9(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gF(){var s=this.e
s=s==null?null:s.gF()
return s==null?255:s},
gb2(){return!1},
b3(a,b,c,d){var s=A.or(B.b.i(B.b.L(a,0,255)),B.b.i(B.b.L(b,0,255)),B.b.i(B.b.L(c,0,255)),B.b.i(B.b.L(d,0,255)))
return s},
O(a,b,c){if(c==null||!(c instanceof A.cw)||c.d!==this)c=A.j9(this)
c.a5(a,b)
return c},
aP(a,b){return this.O(a,b,null)},
aJ(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
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
ar(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
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
b5(a,b){var s,r,q,p,o,n,m,l=this,k=l.c
if(k===1){k=l.d
B.d.aD(k,0,k.length,0)}else if(k===2){s=J.m8(B.d.gB(l.d),0,null)
B.A.aD(s,0,s.length,0)}else if(k===4){r=J.Z(B.d.gB(l.d),0,null)
B.o.aD(r,0,r.length,0)}else for(q=A.j9(l),k=q.d,p=k.c>0,k=k.d,o=k.$flags|0;q.E();){if(p){n=q.c
m=B.b.i(B.a.L(0,0,255))
o&2&&A.b(k)
if(!(n>=0&&n<k.length))return A.a(k,n)
k[n]=m}q.st(0)
q.su(0)}},
gN(){return this.e}}
A.h3.prototype={
a6(){return"Interpolation."+this.b}}
A.aU.prototype={}
A.ep.prototype={
U(){return new A.ep(new Uint16Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.A.gB(this.c)},
gM(){return B.G},
gF(){return 1},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=A.K(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b4(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=A.K(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=A.K(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=A.K(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aV(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b1(a){var s,r
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
return r[s]},
b0(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b_(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b6(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.T
s=s!=null?s:A.Y()
if(!(r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.eq.prototype={
U(){return new A.eq(new Float32Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.a4.gB(this.c)},
gM(){return B.O},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.er.prototype={
U(){return new A.er(new Float64Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.a5.gB(this.c)},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.es.prototype={
U(){return new A.es(new Int16Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.ax.gB(this.c)},
gM(){return B.S},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.et.prototype={
U(){return new A.et(new Int32Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.Z.gB(this.c)},
gM(){return B.T},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.eu.prototype={
U(){return new A.eu(new Int8Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.ay.gB(this.c)},
gM(){return B.R},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.ev.prototype={
U(){return new A.ev(new Uint16Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.A.gB(this.c)},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.de.prototype={
U(){return new A.de(new Uint32Array(A.q(this.c)),this.a,this.b)},
gB(a){return B.o.gB(this.c)},
gM(){return B.P},
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.aL.prototype={
U(){return A.mO(this)},
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
d2(a,b,c,d,e){var s,r,q,p,o=this.b
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
aV(a,b){var s,r=this.b
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
bE(a,b){return this.Z(a,0,b)},
bC(a,b){return this.Z(a,1,b)},
bB(a,b){return this.Z(a,2,b)},
bA(a,b){return this.Z(a,3,b)}}
A.cl.prototype={
U(){var s=this
return new A.cl(s.a,s.b,s.c,s.d)},
gM(){return B.G},
gv(a){return this.d.c},
gN(){return null},
gF(){return 1},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=A.K(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gn()},
sT(a){this.sn(a)},
gn(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sn(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=A.K(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=A.K(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=A.K(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.T
r=r!=null?r:A.Y()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r,q,p=this.d
if(p.c>3){s=this.gt()
p=p.d
r=this.c+3
q=A.K(s)
p.$flags&2&&A.b(p)
if(!(r>=0&&r<p.length))return A.a(p,r)
p[r]=q}},
gag(){return this.gn()/1},
sag(a){this.sn(a)},
gac(){return this.gt()/1},
sac(a){this.st(a)},
gaf(){return this.gu()/1},
saf(a){this.su(a)},
ga_(){return this.gA()/1},
sa_(a){this.sA(a)},
gao(){return A.a_(this)},
ah(a){var s=this
if(s.d.c>0){s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())}},
av(a,b,c){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.K(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){s=p.c+1
r=A.K(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){n=p.c+2
s=A.K(c)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}},
ae(a,b,c,d){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.K(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){s=p.c+1
r=A.K(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){s=p.c+2
r=A.K(c)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>3){n=p.c+3
s=A.K(d)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cl){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.cm.prototype={
U(){var s=this
return new A.cm(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gN(){return null},
gF(){return 1},
gM(){return B.O},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=1
return r},
sA(a){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gag(){return this.gn()/1},
sag(a){this.sn(a)},
gac(){return this.gt()/1},
sac(a){this.st(a)},
gaf(){return this.gu()/1},
saf(a){this.su(a)},
ga_(){return this.gA()/1},
sa_(a){this.sA(a)},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q=this.d,p=q.d,o=this.c
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
ae(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cm){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.cn.prototype={
U(){var s=this
return new A.cn(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gN(){return null},
gF(){return 1},
gM(){return B.Q},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gag(){return this.gn()/1},
sag(a){this.sn(a)},
gac(){return this.gt()/1},
sac(a){this.st(a)},
gaf(){return this.gu()/1},
saf(a){this.su(a)},
ga_(){return this.gA()/1},
sa_(a){this.sA(a)},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q=this.d,p=q.d,o=this.c
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
ae(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cn){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.co.prototype={
U(){var s=this
return new A.co(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gN(){return null},
gF(){return 32767},
gM(){return B.S},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gag(){return this.gn()/32767},
sag(a){this.sn(a*32767)},
gac(){return this.gt()/32767},
sac(a){this.st(a*32767)},
gaf(){return this.gu()/32767},
saf(a){this.su(a*32767)},
ga_(){return this.gA()/32767},
sa_(a){this.sA(a*32767)},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q,p,o=this.d,n=o.c
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
ae(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.co){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.cp.prototype={
U(){var s=this
return new A.cp(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gN(){return null},
gF(){return 2147483647},
gM(){return B.T},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gag(){return this.gn()/2147483647},
sag(a){this.sn(a*2147483647)},
gac(){return this.gt()/2147483647},
sac(a){this.st(a*2147483647)},
gaf(){return this.gu()/2147483647},
saf(a){this.su(a*2147483647)},
ga_(){return this.gA()/2147483647},
sa_(a){this.sA(a*2147483647)},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q,p,o=this.d,n=o.c
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
ae(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cp){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.cq.prototype={
U(){var s=this
return new A.cq(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gN(){return null},
gF(){return 127},
gM(){return B.R},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gag(){return this.gn()/127},
sag(a){this.sn(a*127)},
gac(){return this.gt()/127},
sac(a){this.st(a*127)},
gaf(){return this.gu()/127},
saf(a){this.su(a*127)},
ga_(){return this.gA()/127},
sa_(a){this.sA(a*127)},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q,p,o=this.d,n=o.c
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
ae(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cq){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.hk.prototype={
E(){var s=this,r=s.a
if(r.gaZ()+1>s.d){r.a5(s.b,r.gaU()+1)
return r.gaU()<=s.e}return r.E()},
gP(){return this.a},
$iB:1}
A.cr.prototype={
U(){var s=this
return new A.cr(s.a,s.b,s.c,s.d,s.e,s.f)},
gv(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gN(){return this.f.f},
gF(){return this.f.gF()},
gM(){return B.y},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.f
r=b*s.e
q.e=r
s=a*s.c
q.c=r+B.a.j(s,3)
q.d=s&7},
gP(){return this},
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
dW(a){var s,r,q=this.c,p=7-(this.d+a)
if(p<0){p+=8;++q}s=this.f.d
s===$&&A.c("data")
r=s.length
if(q>=r)return 0
if(!(q>=0))return A.a(s,q)
return B.a.a3(s[q],p)&1},
ba(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dW(a):0
else s=r.aV(this.dW(0),a)
return s},
az(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=7-(this.d+a)
if(r<0){++s
r+=8}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.L(B.b.i(b),0,1)
if(!(r>=0&&r<8))return A.a(B.bK,r)
n=B.bK[r]
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.ba(b)},
h(a,b,c){return this.az(b,c)},
gT(){return this.dW(0)},
sT(a){this.az(0,a)},
gn(){return this.ba(0)},
sn(a){this.az(0,a)},
gt(){return this.ba(1)},
st(a){this.az(1,a)},
gu(){return this.ba(2)},
su(a){this.az(2,a)},
gA(){return this.ba(3)},
sA(a){this.az(3,a)},
gag(){return this.ba(0)/this.f.gF()},
sag(a){this.az(0,a*this.f.gF())},
gac(){return this.ba(1)/this.f.gF()},
sac(a){this.az(1,a*this.f.gF())},
gaf(){return this.ba(2)/this.f.gF()},
saf(a){this.az(2,a*this.f.gF())},
ga_(){return this.ba(3)/this.f.gF()},
sa_(a){this.az(3,a*this.f.gF())},
gao(){return A.a_(this)},
ah(a){var s=this
s.az(0,a.gn())
s.az(1,a.gt())
s.az(2,a.gu())
s.az(3,a.gA())},
av(a,b,c){var s=this,r=s.f.c
if(r>0){s.az(0,a)
if(r>1){s.az(1,b)
if(r>2)s.az(2,c)}}},
ae(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.az(0,a)
if(r>1){s.az(1,b)
if(r>2){s.az(2,c)
if(r>3)s.az(3,d)}}}},
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cr){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a5(b)
if(s.gv(b)!==q)return!1
if(p.ba(0)!==s.l(b,0))return!1
if(q>1){if(p.ba(1)!==s.l(b,1))return!1
if(q>2){if(p.ba(2)!==s.l(b,2))return!1
if(q>3)if(p.ba(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.f}}
A.cs.prototype={
U(){var s=this
return new A.cs(s.a,s.b,s.c,s.d)},
gv(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gN(){return this.d.e},
gF(){return this.d.gF()},
gM(){return B.n},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bv(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aV(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bv(b)},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gt(){var s,r=this.d,q=r.e
if(q==null)if(r.c>1){r=r.d
q=this.c+1
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b0(r[s])
r=s}return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d,q=r.e
if(q==null)if(r.c>2){r=r.d
q=this.c+2
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b_(r[s])
r=s}return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s,r=this.d,q=r.e
if(q==null)if(r.c>3){r=r.d
q=this.c+3
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b6(r[s])
r=s}return r},
sA(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gag(){return this.gn()/this.d.gF()},
sag(a){this.sn(a*this.d.gF())},
gac(){return this.gt()/this.d.gF()},
sac(a){this.st(a*this.d.gF())},
gaf(){return this.gu()/this.d.gF()},
saf(a){this.su(a*this.d.gF())},
ga_(){return this.gA()/this.d.gF()},
sa_(a){this.sA(a*this.d.gF())},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q,p,o=this.d,n=o.c
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
ae(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cs){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a5(b)
if(s.gv(b)!==q)return!1
if(p.bv(0)!==s.l(b,0))return!1
if(q>1){if(p.bv(1)!==s.l(b,1))return!1
if(q>2){if(p.bv(2)!==s.l(b,2))return!1
if(q>3)if(p.bv(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.ct.prototype={
U(){var s=this
return new A.ct(s.a,s.b,s.c,s.d,s.e,s.f)},
gv(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gN(){return this.f.f},
gF(){return this.f.gF()},
gM(){return B.t},
gh6(){var s=this.f
return s.f!=null?2:s.c<<1>>>0},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.gh6()
r=b*p.f.e
p.e=r
q=a*s
p.c=r+B.a.j(q,3)
p.d=q&7},
gP(){return this},
E(){var s=this,r=++s.a,q=s.f
if(r===q.a){s.a=0
r=++s.b
s.d=0;++s.c
s.e=s.e+q.e
return r<q.b}if(q.f!=null||q.c===1){if((s.d+=2)>7){s.d=0;++s.c}}else{r*=s.gh6()
s.d=r&7
s.c=s.e+B.a.j(r,3)}r=s.c
q=q.d
q===$&&A.c("data")
return r<q.length},
dX(a){var s,r=this.c,q=6-(this.d+(a<<1>>>0))
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.c("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a3(s[r],q)&3},
bb(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dX(a):0
else s=r.aV(this.dX(0),a)
return s},
aA(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=6-(this.d+(a<<1>>>0))
if(r<0){++s
r+=8}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.L(B.b.i(b),0,3)
q=B.a.j(r,1)
if(!(q<4))return A.a(B.bp,q)
n=B.bp[q]
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bb(b)},
h(a,b,c){return this.aA(b,c)},
gT(){return this.dX(0)},
sT(a){this.aA(0,a)},
gn(){return this.bb(0)},
sn(a){this.aA(0,a)},
gt(){return this.bb(1)},
st(a){this.aA(1,a)},
gu(){return this.bb(2)},
su(a){this.aA(2,a)},
gA(){return this.bb(3)},
sA(a){this.aA(3,a)},
gag(){return this.bb(0)/this.f.gF()},
sag(a){this.aA(0,a*this.f.gF())},
gac(){return this.bb(1)/this.f.gF()},
sac(a){this.aA(1,a*this.f.gF())},
gaf(){return this.bb(2)/this.f.gF()},
saf(a){this.aA(2,a*this.f.gF())},
ga_(){return this.bb(3)/this.f.gF()},
sa_(a){this.aA(3,a*this.f.gF())},
gao(){return A.a_(this)},
ah(a){var s=this
s.aA(0,a.gn())
s.aA(1,a.gt())
s.aA(2,a.gu())
s.aA(3,a.gA())},
av(a,b,c){var s=this,r=s.f.c
if(r>0){s.aA(0,a)
if(r>1){s.aA(1,b)
if(r>2)s.aA(2,c)}}},
ae(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aA(0,a)
if(r>1){s.aA(1,b)
if(r>2){s.aA(2,c)
if(r>3)s.aA(3,d)}}}},
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ct){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a5(b)
if(s.gv(b)!==q)return!1
if(p.bb(0)!==s.l(b,0))return!1
if(q>1){if(p.bb(1)!==s.l(b,1))return!1
if(q>2){if(p.bb(2)!==s.l(b,2))return!1
if(q>3)if(p.bb(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.f}}
A.cu.prototype={
U(){var s=this
return new A.cu(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gN(){return null},
gF(){return 4294967295},
gM(){return B.P},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
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
gT(){return this.gn()},
sT(a){this.sn(a)},
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
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gag(){return this.gn()/4294967295},
sag(a){this.sn(a*4294967295)},
gac(){return this.gt()/4294967295},
sac(a){this.st(a*4294967295)},
gaf(){return this.gu()/4294967295},
saf(a){this.su(a*4294967295)},
ga_(){return this.gA()/4294967295},
sa_(a){this.sA(a*4294967295)},
gao(){return A.a_(this)},
ah(a){var s=this
s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
av(a,b,c){var s,r,q,p,o=this.d,n=o.c
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
ae(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cu){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a5(b)
r=n.d
q=r.c
if(s.gv(b)!==q)return!1
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
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.cv.prototype={
U(){var s=this
return new A.cv(s.a,s.b,s.c,s.d,s.e)},
gv(a){var s=this.e,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gN(){return this.e.f},
gF(){return this.e.gF()},
gM(){return B.z},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q,p=this
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
gP(){return this},
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
dY(a){var s,r=this.c,q=4-(this.d+(a<<2>>>0))
if(q<0){q+=8;++r}s=this.e.d
s===$&&A.c("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a3(s[r],q)&15},
bc(a){var s=this.e,r=s.f
if(r==null)s=s.c>a?this.dY(a):0
else s=r.aV(this.dY(0),a)
return s},
aB(a,b){var s,r,q,p,o,n,m=this.e
if(a>=m.c)return
s=this.c
r=4-(this.d+(a<<2>>>0))
if(r<0){r+=8;++s}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.L(B.b.i(b),0,15)
n=r===4?15:240
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bc(b)},
h(a,b,c){return this.aB(b,c)},
gT(){return this.dY(0)},
sT(a){this.aB(0,a)},
gn(){return this.bc(0)},
sn(a){this.aB(0,a)},
gt(){return this.bc(1)},
st(a){this.aB(1,a)},
gu(){return this.bc(2)},
su(a){this.aB(2,a)},
gA(){return this.bc(3)},
sA(a){this.aB(3,a)},
gag(){return this.bc(0)/this.e.gF()},
sag(a){this.aB(0,a*this.e.gF())},
gac(){return this.bc(1)/this.e.gF()},
sac(a){this.aB(1,a*this.e.gF())},
gaf(){return this.bc(2)/this.e.gF()},
saf(a){this.aB(2,a*this.e.gF())},
ga_(){return this.bc(3)/this.e.gF()},
sa_(a){this.aB(3,a*this.e.gF())},
gao(){return A.a_(this)},
ah(a){var s=this
s.aB(0,a.gn())
s.aB(1,a.gt())
s.aB(2,a.gu())
s.aB(3,a.gA())},
av(a,b,c){var s=this,r=s.e.c
if(r>0){s.aB(0,a)
if(r>1){s.aB(1,b)
if(r>2)s.aB(2,c)}}},
ae(a,b,c,d){var s=this,r=s.e.c
if(r>0){s.aB(0,a)
if(r>1){s.aB(1,b)
if(r>2){s.aB(2,c)
if(r>3)s.aB(3,d)}}}},
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cv){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){q=p.e.c
s=J.a5(b)
if(s.gv(b)!==q)return!1
if(p.bc(0)!==s.l(b,0))return!1
if(q>1){if(p.bc(1)!==s.l(b,1))return!1
if(q>2){if(p.bc(2)!==s.l(b,2))return!1
if(q>3)if(p.bc(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.e}}
A.cw.prototype={
U(){var s=this
return new A.cw(s.a,s.b,s.c,s.d)},
gv(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gN(){return this.d.e},
gF(){return this.d.gF()},
gM(){return B.e},
gaZ(){return this.a},
gaU(){return this.b},
a5(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gP(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bv(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aV(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bv(b)},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(B.b.L(c,0,255))
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){var s=this.d.d,r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
sT(a){var s=this.d.d,r=this.c,q=B.b.i(B.b.L(a,0,255))
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
r=B.b.i(B.b.L(a,0,255))
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
s=B.b.i(B.b.L(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.i(B.b.L(a,0,255))
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
s=B.b.i(B.b.L(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.i(B.b.L(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gA(){var s,r=this,q=r.d,p=q.e
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
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.i(B.b.L(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.i(B.b.L(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gag(){return this.gn()/this.d.gF()},
sag(a){this.sn(a*this.d.gF())},
gac(){return this.gt()/this.d.gF()},
sac(a){this.st(a*this.d.gF())},
gaf(){return this.gu()/this.d.gF()},
saf(a){this.su(a*this.d.gF())},
ga_(){return this.gA()/this.d.gF()},
sa_(a){this.sA(a*this.d.gF())},
gao(){return this.d.c===2?this.gn():A.a_(this)},
ah(a){var s=this
if(s.d.e!=null)s.sT(a.gT())
else{s.sn(a.gn())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())}},
av(a,b,c){var s,r,q,p,o=this.d,n=o.c
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
ae(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
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
gH(a){return new A.R(this)},
Y(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cw){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a5(b)
if(s.gv(b)!==q)return!1
if(p.bv(0)!==s.l(b,0))return!1
if(q>1){if(p.bv(1)!==s.l(b,1))return!1
if(q>2){if(p.bv(2)!==s.l(b,2))return!1
if(q>3)if(p.bv(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aQ(a){return A.aO(this,null,a,null,null)},
$iB:1,
$iy:1,
$iu:1,
gbg(){return this.d}}
A.C.prototype={
U(){return new A.C()},
gbg(){return $.nR()},
gaZ(){return 0},
gaU(){return 0},
gv(a){return 0},
gF(){return 0},
gM(){return B.e},
gN(){return null},
l(a,b){return 0},
h(a,b,c){},
gT(){return 0},
sT(a){},
gn(){return 0},
sn(a){},
gt(){return 0},
st(a){},
gu(){return 0},
su(a){},
gA(){return 0},
sA(a){},
gag(){return 0},
sag(a){},
gac(){return 0},
sac(a){},
gaf(){return 0},
saf(a){},
ga_(){return 0},
sa_(a){},
gao(){return 0},
ah(a){},
av(a,b,c){},
ae(a,b,c,d){},
a5(a,b){},
gP(){return this},
E(){return!1},
Y(a,b){if(b==null)return!1
return b instanceof A.C},
gJ(a){return 0},
gH(a){return new A.R(this)},
aQ(a){return this},
$iB:1,
$iy:1,
$iu:1}
A.iu.prototype={
a6(){return"FlipDirection."+this.b}}
A.iH.prototype={
D(a){return"ImageException: "+this.a}}
A.ag.prototype={
gv(a){return this.c-this.d},
h(a,b,c){J.x(this.a,this.d+b,c)
return c},
bq(a,b,c,d){var s=this.a,r=J.am(s),q=this.d+a
if(c instanceof A.ag)r.au(s,q,q+b,c.a,c.d+d)
else r.au(s,q,q+b,t.L.a(c),d)},
c6(a,b,c){return this.bq(a,b,c,0)},
lk(a,b,c){var s=this.a,r=this.d+a
J.bp(s,r,r+b,c)},
dA(a,b,c){var s=this,r=c!=null?s.b+c:s.d
return A.v(s.a,s.e,a,r+b)},
am(a){return this.dA(a,0,null)},
c9(a,b){return this.dA(a,0,b)},
d3(a,b){return this.dA(a,b,null)},
G(){return J.d(this.a,this.d++)},
ai(a){var s=this.am(a)
this.d=this.d+(s.c-s.d)
return s},
al(a){var s,r,q,p,o,n=this
if(a==null){s=A.j([],t.t)
for(r=n.c;q=n.d,q<r;){p=n.a
n.d=q+1
o=J.d(p,q)
if(o===0)return A.eI(s,0,null)
B.c.C(s,o)}throw A.h(A.m("EOF reached without finding string terminator (length: "+A.z(a)+")"))}return A.eI(n.ai(a).a4(),0,null)},
cY(){return this.al(null)},
hn(a){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
B.c.C(n,p)
if(p===10||n.length>=a)return A.eI(n,0,null)}return A.eI(n,0,null)},
ls(){return this.hn(256)},
lt(){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
if(p===0){t.L.a(n)
return new A.i0(!0).eQ(n,0,null,!0)}B.c.C(n,p)}return B.d_.kT(n,!0)},
p(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255
if(s.e)return r<<8|q
return q<<8|r},
bs(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255
if(s.e)return p|q<<8|r<<16
return r|q<<8|p<<16},
k(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255
if(s.e)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
dv(){return A.th(this.ec())},
ec(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255,n=J.d(s.a,s.d++)&255,m=J.d(s.a,s.d++)&255,l=J.d(s.a,s.d++)&255,k=J.d(s.a,s.d++)&255
if(s.e)return(B.a.S(r,56)|B.a.S(q,48)|B.a.S(p,40)|B.a.S(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.S(k,56)|B.a.S(l,48)|B.a.S(m,40)|B.a.S(n,32)|o<<24|p<<16|q<<8|r)>>>0},
cZ(a,b,c){var s,r=this,q=r.a
if(t.D.b(q))return r.hs(b,c)
s=r.b+r.d+b
return J.l4(q,s,c<=0?r.c:s+c)},
hs(a,b){var s,r=this,q=b==null?r.c-r.d-a:b,p=r.a
if(t.D.b(p))return J.D(B.d.gB(p),p.byteOffset+r.d+a,q)
s=r.d+a
s=J.l4(p,s,s+q)
return new Uint8Array(A.q(s))},
a4(){return this.hs(0,null)},
d_(){var s=this.a
if(t.D.b(s))return J.Z(B.d.gB(s),s.byteOffset+this.d,null)
return J.Z(B.d.gB(this.a4()),0,null)},
sB(a,b){this.a=t.L.a(b)}}
A.hg.prototype={
gN(){var s=this.a
s===$&&A.c("palette")
return s},
kM(a){var s=this
s.fh(a)
s.f1()
s.fe()
s.eR()},
hy(a){var s=B.b.i(a.gn()),r=B.b.i(a.gt())
return this.ff(B.b.i(a.gu()),r,s)},
eg(a,b,c){return this.ff(c,b,a)},
jE(a){var s,r,q,p,o,n,m,l=this,k=l.c=Math.max(a,4)
l.f=k-l.d
l.r=k-1
s=B.b.W(k,8)
l.w=s
l.x=s*256
l.Q=new A.de(new Uint32Array(1024),256,4)
l.a=new A.aL(new Uint8Array(768),256,3)
l.d=3
l.e=2
s=B.b.j(k,3)
l.y=new Int32Array(s)
s=t.V
r=t.H
l.z=r.a(A.F(k*3,0,!1,s))
l.at=r.a(A.F(l.c,0,!1,s))
l.ax=r.a(A.F(l.c,0,!1,s))
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
eR(){var s,r,q,p,o,n,m
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
ff(a,b,c){var s,r,q,p,o,n,m,l,k,j,i="_palette",h=this.as
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
f1(){var s,r,q,p,o,n,m,l=this,k="_palette"
for(s=0,r=0;s<l.c;++s){for(q=0;q<3;++q,++r){p=l.z
p===$&&A.c("_network")
if(!(r>=0&&r<p.length))return A.a(p,r)
o=B.a.L(B.b.i(0.5+p[r]),0,255)
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
fe(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
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
fL(a,b){var s,r,q,p
for(s=this.y,r=a*a,q=0;q<a;++q){s===$&&A.c("_radiusPower")
p=B.b.i(b*((r-q*q)*256/r))
s.$flags&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
fh(a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4="_network",a5=a3.x
a5===$&&A.c("initBiasRadius")
s=a3.b
r=30+B.a.W(s-1,3)
q=a6.gR()*a6.gK()
p=B.a.aw(q,s)
o=Math.max(B.a.W(p,100),1)
if(o===0)o=1
n=B.a.j(a5,8)
if(n<=1)n=0
a3.fL(n,1024)
if(q<1509)m=a3.b=1
else if(B.a.a9(q,499)!==0)m=499
else if(B.a.a9(q,491)!==0)m=491
else m=B.a.a9(q,487)!==0?487:503
l=a6.gR()
k=a6.gK()
for(j=a5,i=1024,h=0,g=0,f=0,e=0;e<p;){a5=a6.a
d=a5==null?null:a5.O(g,f,null)
if(d==null)d=new A.C()
c=d.gn()
b=d.gt()
a=d.gu()
if(e===0){a5=a3.z
a5===$&&A.c(a4)
s=a3.e
s===$&&A.c("bgColor")
B.c.h(a5,s*3,a)
B.c.h(a3.z,a3.e*3+1,b)
B.c.h(a3.z,a3.e*3+2,c)}a0=a3.kE(a,b,c)
if(a0<0)a0=a3.iA(a,b,c)
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
if(n>0)a3.ig(a1,n,a0,a,b,c)}h+=m
g+=m
while(g>l){g-=l;++f}while(h>=q){h-=q
f-=k}++e
if(B.a.a9(e,o)===0){i-=B.a.aw(i,r)
j-=B.a.W(j,30)
n=B.a.j(j,8)
if(n<=1)n=0
a3.fL(n,i)}}},
ig(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_network",f=c-b,e=h.d-1
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
iA(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1e30
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
kE(a,b,c){var s,r,q,p,o,n,m
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
A.hi.prototype={
m(a){var s,r,q=this
if(q.a===q.c.length)q.jd()
s=q.c
r=q.a++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a&255},
hw(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=J.bq(a)
while(s=o.a,r=s+b,q=o.c,p=q.length,r>p)o.f0(r-p)
B.d.bD(q,s,r,a)
o.a+=b},
a0(a){return this.hw(a,null)},
a1(a){var s=this
if(s.b){s.m(B.a.j(a,8)&255)
s.m(a&255)
return}s.m(a&255)
s.m(B.a.j(a,8)&255)},
I(a){var s=this
if(s.b){s.m(B.a.j(a,24)&255)
s.m(B.a.j(a,16)&255)
s.m(B.a.j(a,8)&255)
s.m(a&255)
return}s.m(a&255)
s.m(B.a.j(a,8)&255)
s.m(B.a.j(a,16)&255)
s.m(B.a.j(a,24)&255)},
lI(a){var s,r,q=this,p=new Float32Array(1)
p[0]=a
s=J.D(B.a4.gB(p),0,null)
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
lJ(a){var s,r,q=this,p=new Float64Array(1)
p[0]=a
s=J.D(B.a5.gB(p),0,null)
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
f0(a){var s,r,q,p
if(a!=null)s=a
else{r=this.c.length
s=r===0?8192:r*2}r=this.c
q=r.length
p=new Uint8Array(q+s)
B.d.bD(p,0,q,r)
this.c=p},
jd(){return this.f0(null)},
gv(a){return this.a}}
A.jl.prototype={
a6(){return"QuantizerType."+this.b}}
A.hC.prototype={
eh(a){var s,r,q=a.gR(),p=A.P(null,null,B.e,0,B.j,a.gK(),null,0,1,this.gN(),B.e,q,!1)
q=p.a
s=q.gH(q)
s.E()
p.z=a.z
p.w=a.w
p.y=a.y
for(q=a.a,q=q.gH(q);q.E();){r=q.gP()
s.gP().h(0,0,this.hy(r))
s.E()}return p}}
A.aW.prototype={
i(a){var s=this.b
return s===0?0:B.a.aw(this.a,s)},
Y(a,b){if(b==null)return!1
return b instanceof A.aW&&this.a===b.a&&this.b===b.b},
gJ(a){return A.j8(this.a,this.b,B.C,B.C)},
D(a){return""+this.a+"/"+this.b}}
A.hc.prototype={
a6(){return"Level."+this.b}}
A.j0.prototype={
fY(a){B.c.C(this.c,a)
if(a.d.a<=3)A.pl(a)},
hd(a){return this.fY(new A.ec(a,null,$.m3().$1(null),B.dz))}}
A.j1.prototype={
$1(a){return a},
$S:33}
A.ec.prototype={}
A.hd.prototype={
hr(){var s,r=this,q=A.I(t.N,t.z)
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
A.j4.prototype={}
A.jR.prototype={}
A.eT.prototype={
a6(){return"WebWorkerOperations."+this.b}}
A.kV.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j=t.cX.a(A.nC(A.bn(a).data))
try{n=j
m=n.l(0,"label")
if(n.a8("name")){l=A.o(n.l(0,"name"))
if(!(l>=0&&l<2))return A.a(B.cf,l)
l=B.cf[l]}else l=null
s=new A.jR(m,l,n.l(0,"data"))
switch(s.b){case B.cE:n=A.eb(t.eO.a(s.c),t.N,t.z)
r=A.oW(new A.j4(t.D.a(n.l(0,"bytes")),A.o(n.l(0,"maxDimension")),A.bK(n.l(0,"fileName")),A.nl(n.l(0,"calcBlurhash"))))
n=A.i1(s.a)
m=r
A.ny(n,m==null?null:m.hr())
break
case B.cF:n=J.oi(t.j.a(s.c),t.p)
n=A.w(n,n.$ti.q("e.E"))
q=A.oV(new Uint8Array(A.q(n)))
n=A.i1(s.a)
q=q
A.ny(n,q==null?null:q.hr())
break
default:throw A.h(new A.bl())}}catch(k){p=A.c7(k)
o=A.bN(k)
A.rn(p,o,A.i1(J.d(j,"label")))}},
$S:34}
A.j5.prototype={
li(a,b){var s,r=A.oX(a)
this.a.l(0,r)
s=B.l2.l(0,r)
if(s!=null)return s
return null}};(function aliases(){var s=J.bW.prototype
s.hR=s.D
s=A.H.prototype
s.eu=s.au})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers.installInstanceTearOff,p=hunkHelpers._instance_2u,o=hunkHelpers.installStaticTearOff
s(A,"rC","qg",8)
s(A,"rD","qh",8)
s(A,"rE","qi",8)
r(A,"nA","rw",2)
s(A,"rG","ri",36)
q(A.a3.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.b4.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.by.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.aS.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.bg.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.bh.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.bx.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.bw.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.bi.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
q(A.cf.prototype,"gbN",1,0,null,["$1","$0"],["ab","i"],3,0,0)
var n
p(n=A.h9.prototype,"giK","iL",5)
p(n,"giN","iO",5)
p(n,"giP","iQ",5)
p(n,"giE","iF",5)
p(n,"giG","iH",5)
s(A,"tr","pF",0)
s(A,"tk","px",0)
s(A,"ti","pv",0)
s(A,"tp","pD",0)
s(A,"tq","pE",0)
s(A,"to","pC",0)
s(A,"tn","pB",0)
s(A,"tm","pA",0)
s(A,"tt","pH",0)
s(A,"ts","pG",0)
s(A,"tl","py",0)
s(A,"tj","pw",0)
s(A,"tE","pS",0)
s(A,"tC","pQ",0)
s(A,"tu","pI",0)
s(A,"tw","pK",0)
s(A,"tv","pJ",0)
s(A,"tx","pL",0)
s(A,"tF","pT",0)
s(A,"tD","pR",0)
s(A,"ty","pM",0)
s(A,"tz","pN",0)
s(A,"tA","pO",0)
s(A,"tB","pP",0)
p(A.eO.prototype,"gk0","k5",15)
p(A.h1.prototype,"gl4","l5",15)
o(A,"m1",3,null,["$3"],["pU"],1,0)
o(A,"tG",3,null,["$3"],["pV"],1,0)
o(A,"tL",3,null,["$3"],["q_"],1,0)
o(A,"tM",3,null,["$3"],["q0"],1,0)
o(A,"tN",3,null,["$3"],["q1"],1,0)
o(A,"tO",3,null,["$3"],["q2"],1,0)
o(A,"tP",3,null,["$3"],["q3"],1,0)
o(A,"tQ",3,null,["$3"],["q4"],1,0)
o(A,"tR",3,null,["$3"],["q5"],1,0)
o(A,"tS",3,null,["$3"],["q6"],1,0)
o(A,"tH",3,null,["$3"],["pW"],1,0)
o(A,"tI",3,null,["$3"],["pX"],1,0)
o(A,"tJ",3,null,["$3"],["pY"],1,0)
o(A,"tK",3,null,["$3"],["pZ"],1,0)
q(A.bj.prototype,"ghI",0,5,null,["$5"],["aa"],4,0,0)
o(A,"tb",2,null,["$1$2","$2"],["nI",function(a,b){return A.nI(a,b,t.q)}],39,0)
o(A,"tU",6,null,["$6"],["qd"],7,0)
o(A,"tV",6,null,["$6"],["qe"],7,0)
o(A,"tT",6,null,["$6"],["qc"],7,0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.J,null)
q(A.J,[A.ld,J.fT,A.eF,J.dI,A.V,A.H,A.jm,A.e,A.ci,A.ed,A.eV,A.dL,A.eW,A.X,A.bm,A.c2,A.cV,A.f1,A.at,A.ju,A.j7,A.dM,A.f7,A.ai,A.iY,A.Q,A.av,A.k0,A.i_,A.b9,A.hV,A.hZ,A.ki,A.hQ,A.aQ,A.hS,A.cC,A.ac,A.hR,A.hX,A.fc,A.f_,A.fu,A.cI,A.i0,A.fv,A.k1,A.hh,A.eG,A.k2,A.ix,A.ak,A.hY,A.eH,A.j6,A.iB,A.jU,A.jV,A.io,A.aZ,A.kd,A.kh,A.iK,A.jT,A.fQ,A.hj,A.ie,A.ig,A.bt,A.R,A.aR,A.hU,A.fy,A.aI,A.a3,A.ij,A.bs,A.im,A.iq,A.L,A.fz,A.bu,A.fA,A.fB,A.fC,A.dO,A.f6,A.dS,A.dT,A.dU,A.fL,A.fM,A.fr,A.bR,A.iP,A.bV,A.iR,A.dz,A.h8,A.iT,A.h9,A.eA,A.hp,A.bk,A.di,A.jc,A.cx,A.ht,A.hu,A.hx,A.hB,A.dl,A.dj,A.dk,A.eD,A.a4,A.eK,A.jq,A.hG,A.jt,A.hH,A.hI,A.j2,A.jy,A.eN,A.jz,A.jE,A.jH,A.jJ,A.eM,A.jI,A.jA,A.bH,A.eP,A.hP,A.eQ,A.eR,A.eO,A.hN,A.jF,A.hO,A.jL,A.eS,A.fE,A.fF,A.dW,A.dV,A.dX,A.fH,A.dv,A.bJ,A.k_,A.cY,A.aU,A.hk,A.iH,A.ag,A.hC,A.hi,A.aW,A.j0,A.ec,A.hd,A.j4,A.jR,A.j5])
q(J.fT,[J.h6,J.e6,J.e9,J.da,J.db,J.e8,J.d9])
q(J.e9,[J.bW,J.t,A.cj,A.ej])
q(J.bW,[J.hl,J.dr,J.bA])
r(J.h4,A.eF)
r(J.iO,J.t)
q(J.e8,[J.d8,J.e7])
q(A.V,[A.dc,A.bl,A.ha,A.hK,A.hD,A.hT,A.fi,A.b1,A.eL,A.hJ,A.dp,A.fs])
r(A.ds,A.H)
r(A.an,A.ds)
q(A.e,[A.E,A.bB,A.eU,A.cB,A.f0,A.cJ,A.cK,A.cL,A.cM,A.cN,A.cO,A.cQ,A.cR,A.cS,A.cT,A.cU,A.bO,A.dJ,A.bj,A.af,A.cl,A.cm,A.cn,A.co,A.cp,A.cq,A.cr,A.cs,A.ct,A.cu,A.cv,A.cw,A.C])
q(A.E,[A.aE,A.ca,A.ch,A.iZ,A.eZ])
q(A.aE,[A.eJ,A.b6])
r(A.dK,A.bB)
r(A.dA,A.c2)
r(A.cE,A.dA)
q(A.cV,[A.bP,A.b3])
q(A.at,[A.fR,A.fo,A.fp,A.hF,A.kM,A.kO,A.jX,A.jW,A.ks,A.kb,A.kQ,A.kS,A.kT,A.kz,A.kC,A.ih,A.it,A.kD,A.kE,A.kF,A.kG,A.kH,A.kI,A.kJ,A.jb,A.jP,A.iJ,A.iI,A.j1,A.kV])
r(A.d7,A.fR)
r(A.en,A.bl)
q(A.hF,[A.hE,A.cH])
q(A.ai,[A.b5,A.eY])
r(A.ea,A.b5)
q(A.fp,[A.kN,A.kt,A.kw,A.kc,A.j_,A.j3,A.iD,A.iE,A.iF,A.jj,A.jk,A.jK,A.jO])
q(A.ej,[A.he,A.aj])
q(A.aj,[A.f2,A.f4])
r(A.f3,A.f2)
r(A.bX,A.f3)
r(A.f5,A.f4)
r(A.aK,A.f5)
q(A.bX,[A.ee,A.ef])
q(A.aK,[A.eg,A.eh,A.ei,A.ek,A.el,A.em,A.ck])
r(A.dB,A.hT)
q(A.fo,[A.jY,A.jZ,A.kj,A.k3,A.k7,A.k6,A.k5,A.k4,A.ka,A.k9,A.k8,A.kg,A.kv,A.ko,A.kn,A.iA,A.jQ])
r(A.eX,A.hS)
r(A.hW,A.fc)
r(A.dy,A.eY)
q(A.fu,[A.kl,A.kk,A.hM])
r(A.fx,A.cI)
q(A.fx,[A.hb,A.hL])
r(A.iW,A.kl)
r(A.iV,A.kk)
q(A.b1,[A.dm,A.fO])
r(A.kq,A.jU)
r(A.kr,A.jV)
q(A.k1,[A.dw,A.fn,A.il,A.au,A.dR,A.fk,A.ae,A.aD,A.cW,A.ad,A.cX,A.cb,A.b2,A.cZ,A.iQ,A.df,A.ez,A.bY,A.ho,A.bZ,A.b8,A.eE,A.aw,A.cy,A.aa,A.aY,A.cz,A.du,A.fI,A.fD,A.h3,A.iu,A.jl,A.hc,A.eT])
r(A.fP,A.fQ)
r(A.eo,A.hj)
q(A.bO,[A.fq,A.cP])
r(A.ft,A.dJ)
r(A.bQ,A.aR)
q(A.a3,[A.b4,A.ce,A.by,A.aS,A.bg,A.bh,A.bx,A.bw,A.bi,A.bT,A.bS,A.bU,A.cf])
q(A.im,[A.fl,A.is,A.iy,A.iC,A.h7,A.hm,A.ja,A.jd,A.jh,A.jo,A.jr,A.jM])
r(A.ip,A.fl)
q(A.iq,[A.ii,A.iz,A.jS,A.iS,A.hn,A.ji,A.jp,A.js,A.jN])
r(A.fU,A.bu)
q(A.fU,[A.e3,A.fW,A.fX,A.fY,A.e4])
r(A.fV,A.dO)
r(A.fZ,A.dT)
r(A.fJ,A.bs)
r(A.fK,A.jS)
q(A.bR,[A.cd,A.dY])
r(A.h_,A.eA)
r(A.h0,A.hp)
r(A.c_,A.L)
q(A.bk,[A.hr,A.hs,A.hv,A.hw,A.hz,A.hA])
q(A.di,[A.eC,A.hy])
q(A.hB,[A.aV,A.M])
r(A.h1,A.eO)
r(A.h2,A.eS)
r(A.e5,A.dv)
q(A.af,[A.d_,A.d0,A.dZ,A.e_,A.e0,A.e1,A.d1,A.d2,A.d3,A.d4,A.d5,A.d6])
q(A.aU,[A.ep,A.eq,A.er,A.es,A.et,A.eu,A.ev,A.de,A.aL])
r(A.hg,A.hC)
s(A.ds,A.bm)
s(A.f2,A.H)
s(A.f3,A.X)
s(A.f4,A.H)
s(A.f5,A.X)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{f:"int",A:"double",k:"num",W:"String",b0:"bool",ak:"Null",r:"List",J:"Object",aT:"Map",a0:"JSObject"},mangledNames:{},types:["~(ag)","f(f,bF,f)","~()","f([f])","~(f,f,k,k,k)","~(bV,r<f>)","~(@)","~(f,f,f,f,f,bG)","~(~())","J?(J?)","@()","~(W,aI)","ak(@)","ak()","f(f,f)","~(f,b0)","ak(J,aX)","~(@,@)","~(J?,J?)","@(@)","~(f,a3)","~(f,f,f)","~(k,k,k,k)","bF(f)","f()","ak(~())","b0(W)","aV(f,f)","@(@,W)","~(f)","r<f>()","k(k,k,k,k)","k(k,k,k,k,k)","aX?(aX?)","ak(a0)","@(W)","A(bt)","ak(@,aX)","~(f,@)","0^(0^,0^)<k>","M(f,f)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"2;":(a,b)=>c=>c instanceof A.cE&&a.b(c.a)&&b.b(c.b)}}
A.qB(v.typeUniverse,JSON.parse('{"bA":"bW","hl":"bW","dr":"bW","u3":"cj","h6":{"b0":[],"N":[]},"e6":{"N":[]},"e9":{"a0":[]},"bW":{"a0":[]},"t":{"r":["1"],"E":["1"],"a0":[],"e":["1"],"ah":["1"]},"h4":{"eF":[]},"iO":{"t":["1"],"r":["1"],"E":["1"],"a0":[],"e":["1"],"ah":["1"]},"dI":{"B":["1"]},"e8":{"A":[],"k":[]},"d8":{"A":[],"f":[],"k":[],"N":[]},"e7":{"A":[],"k":[],"N":[]},"d9":{"W":[],"mP":[],"ah":["@"],"N":[]},"dc":{"V":[]},"an":{"H":["f"],"bm":["f"],"r":["f"],"E":["f"],"e":["f"],"H.E":"f","bm.E":"f"},"E":{"e":["1"]},"aE":{"E":["1"],"e":["1"]},"eJ":{"aE":["1"],"E":["1"],"e":["1"],"e.E":"1","aE.E":"1"},"ci":{"B":["1"]},"bB":{"e":["2"],"e.E":"2"},"dK":{"bB":["1","2"],"E":["2"],"e":["2"],"e.E":"2"},"ed":{"B":["2"]},"b6":{"aE":["2"],"E":["2"],"e":["2"],"e.E":"2","aE.E":"2"},"eU":{"e":["1"],"e.E":"1"},"eV":{"B":["1"]},"ca":{"E":["1"],"e":["1"],"e.E":"1"},"dL":{"B":["1"]},"cB":{"e":["1"],"e.E":"1"},"eW":{"B":["1"]},"ds":{"H":["1"],"bm":["1"],"r":["1"],"E":["1"],"e":["1"]},"cE":{"dA":[],"c2":[]},"cV":{"aT":["1","2"]},"bP":{"cV":["1","2"],"aT":["1","2"]},"f0":{"e":["1"],"e.E":"1"},"f1":{"B":["1"]},"b3":{"cV":["1","2"],"aT":["1","2"]},"fR":{"at":[],"bv":[]},"d7":{"at":[],"bv":[]},"en":{"bl":[],"V":[]},"ha":{"V":[]},"hK":{"V":[]},"f7":{"aX":[]},"at":{"bv":[]},"fo":{"at":[],"bv":[]},"fp":{"at":[],"bv":[]},"hF":{"at":[],"bv":[]},"hE":{"at":[],"bv":[]},"cH":{"at":[],"bv":[]},"hD":{"V":[]},"b5":{"ai":["1","2"],"iX":["1","2"],"aT":["1","2"],"ai.K":"1","ai.V":"2"},"ch":{"E":["1"],"e":["1"],"e.E":"1"},"Q":{"B":["1"]},"iZ":{"E":["1"],"e":["1"],"e.E":"1"},"av":{"B":["1"]},"ea":{"b5":["1","2"],"ai":["1","2"],"iX":["1","2"],"aT":["1","2"],"ai.K":"1","ai.V":"2"},"dA":{"c2":[]},"cj":{"a0":[],"fm":[],"N":[]},"ej":{"a0":[],"a1":[]},"i_":{"fm":[]},"he":{"ik":[],"a0":[],"a1":[],"N":[]},"aj":{"aJ":["1"],"a0":[],"a1":[],"ah":["1"]},"bX":{"H":["A"],"aj":["A"],"r":["A"],"aJ":["A"],"E":["A"],"a0":[],"a1":[],"ah":["A"],"e":["A"],"X":["A"]},"aK":{"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"]},"ee":{"bX":[],"iv":[],"H":["A"],"aj":["A"],"r":["A"],"aJ":["A"],"E":["A"],"a0":[],"a1":[],"ah":["A"],"e":["A"],"X":["A"],"N":[],"H.E":"A","X.E":"A"},"ef":{"bX":[],"iw":[],"H":["A"],"aj":["A"],"r":["A"],"aJ":["A"],"E":["A"],"a0":[],"a1":[],"ah":["A"],"e":["A"],"X":["A"],"N":[],"H.E":"A","X.E":"A"},"eg":{"aK":[],"fS":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"eh":{"aK":[],"e2":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"ei":{"aK":[],"iM":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"ek":{"aK":[],"jw":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"el":{"aK":[],"bF":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"em":{"aK":[],"jx":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"ck":{"aK":[],"bG":[],"H":["f"],"aj":["f"],"r":["f"],"aJ":["f"],"E":["f"],"a0":[],"a1":[],"ah":["f"],"e":["f"],"X":["f"],"N":[],"H.E":"f","X.E":"f"},"hT":{"V":[]},"dB":{"bl":[],"V":[]},"aQ":{"V":[]},"eX":{"hS":["1"]},"ac":{"cc":["1"]},"fc":{"n4":[]},"hW":{"fc":[],"n4":[]},"eY":{"ai":["1","2"],"aT":["1","2"]},"dy":{"eY":["1","2"],"ai":["1","2"],"aT":["1","2"],"ai.K":"1","ai.V":"2"},"eZ":{"E":["1"],"e":["1"],"e.E":"1"},"f_":{"B":["1"]},"H":{"r":["1"],"E":["1"],"e":["1"]},"ai":{"aT":["1","2"]},"fx":{"cI":["W","r<f>"]},"hb":{"cI":["W","r<f>"]},"hL":{"cI":["W","r<f>"]},"A":{"k":[]},"f":{"k":[]},"r":{"E":["1"],"e":["1"]},"W":{"mP":[]},"fi":{"V":[]},"bl":{"V":[]},"b1":{"V":[]},"dm":{"V":[]},"fO":{"V":[]},"eL":{"V":[]},"hJ":{"V":[]},"dp":{"V":[]},"fs":{"V":[]},"hh":{"V":[]},"eG":{"V":[]},"hY":{"aX":[]},"fP":{"fQ":[]},"eo":{"hj":[]},"R":{"B":["k"]},"cJ":{"y":[],"e":["k"],"e.E":"k"},"cK":{"y":[],"e":["k"],"e.E":"k"},"cL":{"y":[],"e":["k"],"e.E":"k"},"cM":{"y":[],"e":["k"],"e.E":"k"},"cN":{"y":[],"e":["k"],"e.E":"k"},"cO":{"y":[],"e":["k"],"e.E":"k"},"cQ":{"y":[],"e":["k"],"e.E":"k"},"cR":{"y":[],"e":["k"],"e.E":"k"},"cS":{"y":[],"e":["k"],"e.E":"k"},"cT":{"y":[],"e":["k"],"e.E":"k"},"cU":{"y":[],"e":["k"],"e.E":"k"},"bO":{"y":[],"e":["k"],"e.E":"k"},"fq":{"y":[],"e":["k"],"e.E":"k"},"cP":{"y":[],"e":["k"],"e.E":"k"},"dJ":{"y":[],"e":["k"],"e.E":"k"},"ft":{"y":[],"e":["k"],"e.E":"k"},"bQ":{"aR":[]},"b4":{"a3":[]},"ce":{"a3":[]},"by":{"a3":[]},"aS":{"a3":[]},"bg":{"a3":[]},"bh":{"a3":[]},"bx":{"a3":[]},"bw":{"a3":[]},"bi":{"a3":[]},"bT":{"a3":[]},"bS":{"a3":[]},"bU":{"a3":[]},"cf":{"a3":[]},"bs":{"L":[]},"e3":{"bu":[]},"fU":{"bu":[]},"fC":{"L":[]},"fV":{"dO":[]},"fW":{"bu":[]},"fX":{"bu":[]},"fY":{"bu":[]},"e4":{"bu":[]},"fZ":{"dT":[]},"dU":{"L":[]},"fL":{"L":[]},"fJ":{"bs":[],"L":[]},"cd":{"bR":[]},"dY":{"bR":[]},"h_":{"eA":[]},"hp":{"L":[]},"h0":{"L":[]},"c_":{"L":[]},"hr":{"bk":[]},"hs":{"bk":[]},"hv":{"bk":[]},"hw":{"bk":[]},"hz":{"bk":[]},"hA":{"bk":[]},"eC":{"di":[]},"hy":{"di":[]},"ht":{"L":[]},"dj":{"L":[]},"dk":{"L":[]},"eD":{"L":[]},"eK":{"L":[]},"hI":{"L":[]},"h2":{"eS":[]},"dv":{"L":[]},"e5":{"dv":[],"L":[]},"bj":{"e":["u"],"e.E":"u"},"af":{"e":["u"]},"d_":{"af":[],"e":["u"],"e.E":"u"},"d0":{"af":[],"e":["u"],"e.E":"u"},"dZ":{"af":[],"e":["u"],"e.E":"u"},"e_":{"af":[],"e":["u"],"e.E":"u"},"e0":{"af":[],"e":["u"],"e.E":"u"},"e1":{"af":[],"e":["u"],"e.E":"u"},"d1":{"af":[],"e":["u"],"e.E":"u"},"d2":{"af":[],"e":["u"],"e.E":"u"},"d3":{"af":[],"e":["u"],"e.E":"u"},"d4":{"af":[],"e":["u"],"e.E":"u"},"d5":{"af":[],"e":["u"],"e.E":"u"},"d6":{"af":[],"e":["u"],"e.E":"u"},"ep":{"aU":[]},"eq":{"aU":[]},"er":{"aU":[]},"es":{"aU":[]},"et":{"aU":[]},"eu":{"aU":[]},"ev":{"aU":[]},"de":{"aU":[]},"aL":{"aU":[]},"cl":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cm":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cn":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"co":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cp":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cq":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"hk":{"B":["u"]},"cr":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cs":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"ct":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cu":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cv":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"cw":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"C":{"u":[],"y":[],"e":["k"],"B":["u"],"e.E":"k"},"hg":{"hC":[]},"ik":{"a1":[]},"iM":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"bG":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"jx":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"fS":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"jw":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"e2":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"bF":{"r":["f"],"E":["f"],"a1":[],"e":["f"]},"iv":{"r":["A"],"E":["A"],"a1":[],"e":["A"]},"iw":{"r":["A"],"E":["A"],"a1":[],"e":["A"]},"u":{"y":[],"B":["u"],"e":["k"]}}'))
A.qA(v.typeUniverse,JSON.parse('{"E":1,"ds":1,"aj":1,"fu":2,"hB":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",b:"PVRTC requires a power-of-two sized image.",g:"[native implementations worker] Error responding: "}
var t=(function rtii(){var s=A.S
return{u:s("aQ"),dI:s("fm"),fd:s("ik"),G:s("y"),O:s("bt"),W:s("bP<W,f>"),gw:s("E<@>"),C:s("V"),aX:s("fz"),gV:s("fB"),h4:s("iv"),eT:s("iw"),Z:s("bv"),ct:s("dV"),gj:s("fE"),ak:s("fF"),fa:s("dW"),gx:s("fM"),P:s("aI"),r:s("a3"),w:s("af"),dQ:s("fS"),k:s("e2"),cu:s("iM"),bM:s("e<A>"),Y:s("e<@>"),hb:s("e<f>"),eB:s("t<fr>"),g9:s("t<fA>"),dw:s("t<dO>"),c:s("t<dT>"),e:s("t<dV>"),g:s("t<bj>"),b7:s("t<bV>"),dB:s("t<r<r<r<f>>>>"),o:s("t<r<r<f>>>"),A:s("t<r<A>>"),S:s("t<r<f>>"),U:s("t<r<k>>"),dm:s("t<eA>"),h0:s("t<cx>"),af:s("t<bk>"),cE:s("t<hx>"),aK:s("t<aW>"),s:s("t<W>"),aU:s("t<hH>"),gN:s("t<bG>"),ao:s("t<bH>"),gk:s("t<hO>"),J:s("t<eS>"),e7:s("t<bJ>"),cO:s("t<hU>"),e8:s("t<dz>"),f7:s("t<b0>"),n:s("t<A>"),gn:s("t<@>"),t:s("t<f>"),f8:s("t<h8?>"),ca:s("t<r<f>?>"),hh:s("t<bF?>"),ff:s("t<bG?>"),a:s("t<k>"),B:s("t<~(ag)>"),aP:s("ah<@>"),v:s("e6"),m:s("a0"),cj:s("bA"),ez:s("aJ<@>"),d2:s("bV"),cX:s("iX<@,@>"),dL:s("r<bt>"),gX:s("r<bj>"),f0:s("r<e2>"),fv:s("r<r<e2>>"),gS:s("r<r<bH>>"),f:s("r<r<f>>"),eS:s("r<cx>"),bJ:s("r<aW>"),c7:s("r<eM>"),e6:s("r<bH>"),eQ:s("r<eP>"),db:s("r<eQ>"),cC:s("r<eR>"),H:s("r<A>"),j:s("r<@>"),L:s("r<f>"),g8:s("r<bR?>"),d:s("r<r<f>?>"),ge:s("r<bH?>"),gR:s("r<f6?>"),cP:s("r<f?>"),ck:s("aT<W,W>"),eO:s("aT<@,@>"),d4:s("bX"),bc:s("aK"),bm:s("ck"),b:s("ak"),K:s("J"),dv:s("u"),fW:s("cx"),fh:s("hu"),g0:s("eC"),hf:s("di"),fi:s("dj"),aN:s("dl<aV>"),eZ:s("dl<M>"),h:s("aV"),R:s("M"),i:s("aW"),gT:s("u5"),bQ:s("+()"),l:s("aX"),N:s("W"),cV:s("hG"),ci:s("N"),eK:s("bl"),h7:s("jw"),bv:s("bF"),go:s("jx"),D:s("bG"),bI:s("dr"),dd:s("eM"),ai:s("eP"),gU:s("eQ"),dE:s("eR"),cc:s("eU<W>"),_:s("ac<@>"),hg:s("dy<J?,J?>"),eP:s("f6"),y:s("b0"),al:s("b0(J)"),bB:s("b0(W)"),V:s("A"),z:s("@"),fO:s("@()"),E:s("@(J)"),Q:s("@(J,aX)"),p:s("f"),eH:s("cc<ak>?"),fe:s("bR?"),bC:s("fS?"),an:s("a0?"),T:s("r<f>?"),eA:s("r<bR?>?"),fl:s("r<r<f>?>?"),di:s("r<f?>?"),cZ:s("aT<W,W>?"),X:s("J?"),dk:s("W?"),aD:s("bG?"),eW:s("eN?"),aj:s("bH?"),dP:s("hP?"),F:s("cC<@,@>?"),fQ:s("b0?"),cD:s("A?"),I:s("f?"),cg:s("k?"),g6:s("~(f,b0)?"),q:s("k"),x:s("~"),M:s("~()"),fb:s("~(bV,r<f>)"),d6:s("~(f,b0)"),dX:s("~(k,k,k,k)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.du=J.fT.prototype
B.c=J.t.prototype
B.a=J.d8.prototype
B.b=J.e8.prototype
B.m=J.d9.prototype
B.dw=J.bA.prototype
B.dx=J.e9.prototype
B.a4=A.ee.prototype
B.a5=A.ef.prototype
B.ax=A.eg.prototype
B.Z=A.eh.prototype
B.ay=A.ei.prototype
B.A=A.ek.prototype
B.o=A.el.prototype
B.d=A.ck.prototype
B.cl=J.hl.prototype
B.b3=J.dr.prototype
B.aC=new A.fk(0,"direct")
B.aD=new A.fk(1,"alpha")
B.aE=new A.ad(0,"none")
B.aa=new A.ad(3,"bitfields")
B.aF=new A.ad(6,"alphaBitfields")
B.ab=new A.fn(0,"littleEndian")
B.a0=new A.fn(1,"bigEndian")
B.cR=new A.d7(A.tb(),A.S("d7<A>"))
B.cS=new A.dL(A.S("dL<0&>"))
B.b5=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.cT=function() {
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
B.cY=function(getTagFallback) {
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
B.cU=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.cX=function(hooks) {
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
B.cW=function(hooks) {
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
B.cV=function(hooks) {
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
B.b6=function(hooks) { return hooks; }

B.b7=new A.hb()
B.b8=new A.iW()
B.cZ=new A.hh()
B.C=new A.jm()
B.d_=new A.hL()
B.F=new A.jT()
B.D=new A.hW()
B.ac=new A.hY()
B.d0=new A.kq()
B.b9=new A.kr()
B.ba=new A.il(4,"luminance")
B.d1=new A.ft(4294967295)
B.bb=new A.aD(0,"none")
B.aG=new A.aD(1,"floydSteinberg")
B.d8=new A.aD(8,"bayer4x4")
B.da=new A.cW(0,"raster")
B.db=new A.cW(1,"serpentine")
B.dc=new A.cW(2,"zigzag")
B.dd=new A.cW(3,"hilbert")
B.de=new A.cb(0,"red")
B.df=new A.cb(1,"green")
B.dg=new A.cb(2,"blue")
B.dh=new A.cb(3,"alpha")
B.di=new A.cb(4,"other")
B.bc=new A.cX(0,"uint")
B.aH=new A.cX(1,"half")
B.aI=new A.cX(2,"float")
B.bd=new A.b2(0,"none")
B.dr=new A.iu(2,"both")
B.N=new A.dR(0,"uint")
B.aJ=new A.dR(1,"int")
B.aK=new A.dR(2,"float")
B.y=new A.au(0,"uint1")
B.t=new A.au(1,"uint2")
B.O=new A.au(10,"float32")
B.Q=new A.au(11,"float64")
B.z=new A.au(2,"uint4")
B.e=new A.au(3,"uint8")
B.n=new A.au(4,"uint16")
B.P=new A.au(5,"uint32")
B.R=new A.au(6,"int8")
B.S=new A.au(7,"int16")
B.T=new A.au(8,"int32")
B.G=new A.au(9,"float16")
B.be=new A.fD(1,"page")
B.j=new A.fD(2,"sequence")
B.aL=new A.fI(0,"none")
B.aM=new A.fI(1,"deflate")
B.bf=new A.cZ(2,"cur")
B.f=new A.ae(0,"none")
B.bg=new A.ae(1,"byte")
B.bh=new A.ae(10,"sRational")
B.bi=new A.ae(11,"single")
B.bj=new A.ae(12,"double")
B.bk=new A.ae(13,"ifd")
B.l=new A.ae(2,"ascii")
B.k=new A.ae(3,"short")
B.p=new A.ae(4,"long")
B.r=new A.ae(5,"rational")
B.bl=new A.ae(6,"sByte")
B.H=new A.ae(7,"undefined")
B.bm=new A.ae(8,"sShort")
B.bn=new A.ae(9,"sLong")
B.dv=new A.h3(0,"nearest")
B.m5=new A.h3(1,"linear")
B.m6=new A.iQ(0,"yuv444")
B.dy=new A.iV(!1)
B.dz=new A.hc(1,"error")
B.dA=new A.hc(3,"info")
B.I=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15],t.t)
B.ad=s([0,2,8],t.t)
B.dC=s([0,4,2,1],t.t)
B.ds=new A.cZ(0,"invalid")
B.dt=new A.cZ(1,"ico")
B.dE=s([B.ds,B.dt,B.bf],A.S("t<cZ>"))
B.dR=s([1,2,7,11],t.t)
B.aO=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],t.t)
B.bp=s([252,243,207,63],t.t)
B.l7=new A.df(0,"none")
B.co=new A.df(1,"background")
B.cp=new A.df(2,"previous")
B.bq=s([B.l7,B.co,B.cp],A.S("t<df>"))
B.ae=s([292,260,226,226],t.t)
B.br=s([0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125],t.t)
B.dY=s([0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0],t.t)
B.bt=s([2,3,7],t.t)
B.af=s([3226,6412,200,168,38,38,134,134,100,100,100,100,68,68,68,68],t.t)
B.e0=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],t.t)
B.e8=s([3,3,11],t.t)
B.bv=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7],t.t)
B.aV=s([128,128,128,128,128,128,128,128,128,128,128],t.t)
B.bz=s([B.aV,B.aV,B.aV],t.S)
B.eX=s([253,136,254,255,228,219,128,128,128,128,128],t.t)
B.h3=s([189,129,242,255,227,213,255,219,128,128,128],t.t)
B.h8=s([106,126,227,252,214,209,255,255,128,128,128],t.t)
B.iK=s([B.eX,B.h3,B.h8],t.S)
B.iS=s([1,98,248,255,236,226,255,255,128,128,128],t.t)
B.ee=s([181,133,238,254,221,234,255,154,128,128,128],t.t)
B.ec=s([78,134,202,247,198,180,255,219,128,128,128],t.t)
B.jj=s([B.iS,B.ee,B.ec],t.S)
B.eS=s([1,185,249,255,243,255,128,128,128,128,128],t.t)
B.iP=s([184,150,247,255,236,224,128,128,128,128,128],t.t)
B.kd=s([77,110,216,255,236,230,128,128,128,128,128],t.t)
B.ia=s([B.eS,B.iP,B.kd],t.S)
B.ik=s([1,101,251,255,241,255,128,128,128,128,128],t.t)
B.eV=s([170,139,241,252,236,209,255,255,128,128,128],t.t)
B.it=s([37,116,196,243,228,255,255,255,128,128,128],t.t)
B.eE=s([B.ik,B.eV,B.it],t.S)
B.hm=s([1,204,254,255,245,255,128,128,128,128,128],t.t)
B.kx=s([207,160,250,255,238,128,128,128,128,128,128],t.t)
B.kw=s([102,103,231,255,211,171,128,128,128,128,128],t.t)
B.fo=s([B.hm,B.kx,B.kw],t.S)
B.ev=s([1,152,252,255,240,255,128,128,128,128,128],t.t)
B.kF=s([177,135,243,255,234,225,128,128,128,128,128],t.t)
B.i5=s([80,129,211,255,194,224,128,128,128,128,128],t.t)
B.iJ=s([B.ev,B.kF,B.i5],t.S)
B.bE=s([1,1,255,128,128,128,128,128,128,128,128],t.t)
B.ja=s([246,1,255,128,128,128,128,128,128,128,128],t.t)
B.hN=s([255,128,128,128,128,128,128,128,128,128,128],t.t)
B.kR=s([B.bE,B.ja,B.hN],t.S)
B.fh=s([B.bz,B.iK,B.jj,B.ia,B.eE,B.fo,B.iJ,B.kR],t.o)
B.kf=s([198,35,237,223,193,187,162,160,145,155,62],t.t)
B.eW=s([131,45,198,221,172,176,220,157,252,221,1],t.t)
B.ke=s([68,47,146,208,149,167,221,162,255,223,128],t.t)
B.hw=s([B.kf,B.eW,B.ke],t.S)
B.jm=s([1,149,241,255,221,224,255,255,128,128,128],t.t)
B.jC=s([184,141,234,253,222,220,255,199,128,128,128],t.t)
B.hJ=s([81,99,181,242,176,190,249,202,255,255,128],t.t)
B.k1=s([B.jm,B.jC,B.hJ],t.S)
B.jQ=s([1,129,232,253,214,197,242,196,255,255,128],t.t)
B.ku=s([99,121,210,250,201,198,255,202,128,128,128],t.t)
B.iL=s([23,91,163,242,170,187,247,210,255,255,128],t.t)
B.hR=s([B.jQ,B.ku,B.iL],t.S)
B.fG=s([1,200,246,255,234,255,128,128,128,128,128],t.t)
B.jN=s([109,178,241,255,231,245,255,255,128,128,128],t.t)
B.dX=s([44,130,201,253,205,192,255,255,128,128,128],t.t)
B.k5=s([B.fG,B.jN,B.dX],t.S)
B.eo=s([1,132,239,251,219,209,255,165,128,128,128],t.t)
B.dF=s([94,136,225,251,218,190,255,255,128,128,128],t.t)
B.jS=s([22,100,174,245,186,161,255,199,128,128,128],t.t)
B.ii=s([B.eo,B.dF,B.jS],t.S)
B.jB=s([1,182,249,255,232,235,128,128,128,128,128],t.t)
B.iD=s([124,143,241,255,227,234,128,128,128,128,128],t.t)
B.h_=s([35,77,181,251,193,211,255,205,128,128,128],t.t)
B.ha=s([B.jB,B.iD,B.h_],t.S)
B.kS=s([1,157,247,255,236,231,255,255,128,128,128],t.t)
B.fg=s([121,141,235,255,225,227,255,255,128,128,128],t.t)
B.jO=s([45,99,188,251,195,217,255,224,128,128,128],t.t)
B.eD=s([B.kS,B.fg,B.jO],t.S)
B.dG=s([1,1,251,255,213,255,128,128,128,128,128],t.t)
B.e2=s([203,1,248,255,255,128,128,128,128,128,128],t.t)
B.jD=s([137,1,177,255,224,255,128,128,128,128,128],t.t)
B.ew=s([B.dG,B.e2,B.jD],t.S)
B.ju=s([B.hw,B.k1,B.hR,B.k5,B.ii,B.ha,B.eD,B.ew],t.o)
B.ft=s([253,9,248,251,207,208,255,192,128,128,128],t.t)
B.jb=s([175,13,224,243,193,185,249,198,255,255,128],t.t)
B.kP=s([73,17,171,221,161,179,236,167,255,234,128],t.t)
B.j0=s([B.ft,B.jb,B.kP],t.S)
B.jr=s([1,95,247,253,212,183,255,255,128,128,128],t.t)
B.hZ=s([239,90,244,250,211,209,255,255,128,128,128],t.t)
B.kc=s([155,77,195,248,188,195,255,255,128,128,128],t.t)
B.jA=s([B.jr,B.hZ,B.kc],t.S)
B.ho=s([1,24,239,251,218,219,255,205,128,128,128],t.t)
B.jd=s([201,51,219,255,196,186,128,128,128,128,128],t.t)
B.hY=s([69,46,190,239,201,218,255,228,128,128,128],t.t)
B.jo=s([B.ho,B.jd,B.hY],t.S)
B.h6=s([1,191,251,255,255,128,128,128,128,128,128],t.t)
B.ir=s([223,165,249,255,213,255,128,128,128,128,128],t.t)
B.iR=s([141,124,248,255,255,128,128,128,128,128,128],t.t)
B.jP=s([B.h6,B.ir,B.iR],t.S)
B.hB=s([1,16,248,255,255,128,128,128,128,128,128],t.t)
B.fe=s([190,36,230,255,236,255,128,128,128,128,128],t.t)
B.eY=s([149,1,255,128,128,128,128,128,128,128,128],t.t)
B.ep=s([B.hB,B.fe,B.eY],t.S)
B.iN=s([1,226,255,128,128,128,128,128,128,128,128],t.t)
B.j3=s([247,192,255,128,128,128,128,128,128,128,128],t.t)
B.kb=s([240,128,255,128,128,128,128,128,128,128,128],t.t)
B.e4=s([B.iN,B.j3,B.kb],t.S)
B.k4=s([1,134,252,255,255,128,128,128,128,128,128],t.t)
B.iC=s([213,62,250,255,255,128,128,128,128,128,128],t.t)
B.kC=s([55,93,255,128,128,128,128,128,128,128,128],t.t)
B.iM=s([B.k4,B.iC,B.kC],t.S)
B.eO=s([B.j0,B.jA,B.jo,B.jP,B.ep,B.e4,B.iM,B.bz],t.o)
B.iE=s([202,24,213,235,186,191,220,160,240,175,255],t.t)
B.eU=s([126,38,182,232,169,184,228,174,255,187,128],t.t)
B.es=s([61,46,138,219,151,178,240,170,255,216,128],t.t)
B.jy=s([B.iE,B.eU,B.es],t.S)
B.i4=s([1,112,230,250,199,191,247,159,255,255,128],t.t)
B.eC=s([166,109,228,252,211,215,255,174,128,128,128],t.t)
B.im=s([39,77,162,232,172,180,245,178,255,255,128],t.t)
B.jw=s([B.i4,B.eC,B.im],t.S)
B.i6=s([1,52,220,246,198,199,249,220,255,255,128],t.t)
B.fm=s([124,74,191,243,183,193,250,221,255,255,128],t.t)
B.fZ=s([24,71,130,219,154,170,243,182,255,255,128],t.t)
B.jv=s([B.i6,B.fm,B.fZ],t.S)
B.fX=s([1,182,225,249,219,240,255,224,128,128,128],t.t)
B.kA=s([149,150,226,252,216,205,255,171,128,128,128],t.t)
B.kX=s([28,108,170,242,183,194,254,223,255,255,128],t.t)
B.kp=s([B.fX,B.kA,B.kX],t.S)
B.kY=s([1,81,230,252,204,203,255,192,128,128,128],t.t)
B.jK=s([123,102,209,247,188,196,255,233,128,128,128],t.t)
B.k9=s([20,95,153,243,164,173,255,203,128,128,128],t.t)
B.jL=s([B.kY,B.jK,B.k9],t.S)
B.hG=s([1,222,248,255,216,213,128,128,128,128,128],t.t)
B.iB=s([168,175,246,252,235,205,255,255,128,128,128],t.t)
B.h1=s([47,116,215,255,211,212,255,255,128,128,128],t.t)
B.f8=s([B.hG,B.iB,B.h1],t.S)
B.hF=s([1,121,236,253,212,214,255,255,128,128,128],t.t)
B.i7=s([141,84,213,252,201,202,255,219,128,128,128],t.t)
B.iZ=s([42,80,160,240,162,185,255,205,128,128,128],t.t)
B.hc=s([B.hF,B.i7,B.iZ],t.S)
B.kJ=s([244,1,255,128,128,128,128,128,128,128,128],t.t)
B.dD=s([238,1,255,128,128,128,128,128,128,128,128],t.t)
B.j5=s([B.bE,B.kJ,B.dD],t.S)
B.dV=s([B.jy,B.jw,B.jv,B.kp,B.jL,B.f8,B.hc,B.j5],t.o)
B.eq=s([B.fh,B.ju,B.eO,B.dV],t.dB)
B.bw=s([511,1023,2047,4095],t.t)
B.bx=s([63,207,243,252],t.t)
B.eL=s([17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99],t.t)
B.ag=s([0,1,2,3,4,5,6,7,8,9,10,11],t.t)
B.f_=s([8,8,4,2],t.t)
B.dP=s([173,148,140],t.t)
B.dQ=s([176,155,140,135],t.t)
B.dN=s([180,157,141,134,130],t.t)
B.e1=s([254,254,243,230,196,177,153,140,133,130,129],t.t)
B.by=s([B.dP,B.dQ,B.dN,B.e1],t.S)
B.f3=s([0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576],t.t)
B.bA=s([1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379],t.n)
B.fa=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.bB=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095],t.t)
B.ah=s([0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29],t.t)
B.bC=s([1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250],t.t)
B.ai=s([96,73,55,39,23,13,5,1,255,255,255,255,255,255,255,255,101,78,58,42,26,16,8,2,0,3,9,17,27,43,59,79,102,86,62,46,32,20,10,6,4,7,11,21,33,47,63,87,105,90,70,52,37,28,18,14,12,15,19,29,38,53,71,91,110,99,82,66,48,35,30,24,22,25,31,36,49,67,83,100,115,108,94,76,64,50,44,40,34,41,45,51,65,77,95,109,118,113,103,92,80,68,60,56,54,57,61,69,81,93,104,114,119,116,111,106,97,88,84,74,72,75,85,89,98,107,112,117],t.t)
B.u=s([0,1,1,2,4,8,1,1,2,4,8,4,8,4],t.t)
B.bD=s([2954,2956,2958,2962,2970,2986,3018,3082,3212,3468,3980,5004],t.t)
B.bF=s([280,256,256,256,40],t.t)
B.a1=s([0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63],t.t)
B.aj=s([62,62,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,588,588,588,588,588,588,588,588,1680,1680,20499,22547,24595,26643,1776,1776,1808,1808,-24557,-22509,-20461,-18413,1904,1904,1936,1936,-16365,-14317,782,782,782,782,814,814,814,814,-12269,-10221,10257,10257,12305,12305,14353,14353,16403,18451,1712,1712,1744,1744,28691,30739,-32749,-30701,-28653,-26605,2061,2061,2061,2061,2061,2061,2061,2061,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,750,750,750,750,1616,1616,1648,1648,1424,1424,1456,1456,1488,1488,1520,1520,1840,1840,1872,1872,1968,1968,8209,8209,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,1552,1552,1584,1584,2000,2000,2032,2032,976,976,1008,1008,1040,1040,1072,1072,1296,1296,1328,1328,718,718,718,718,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,4113,4113,6161,6161,848,848,880,880,912,912,944,944,622,622,622,622,654,654,654,654,1104,1104,1136,1136,1168,1168,1200,1200,1232,1232,1264,1264,686,686,686,686,1360,1360,1392,1392,12,12,12,12,12,12,12,12,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390],t.t)
B.aR=s([4,5,6,7,8,9,10,10,11,12,13,14,15,16,17,17,18,19,20,20,21,21,22,22,23,23,24,25,25,26,27,28,29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,93,95,96,98,100,101,102,104,106,108,110,112,114,116,118,122,124,126,128,130,132,134,136,138,140,143,145,148,151,154,157],t.t)
B.bG=s([24,7,23,25,40,6,39,41,22,26,38,42,56,5,55,57,21,27,54,58,37,43,72,4,71,73,20,28,53,59,70,74,36,44,88,69,75,52,60,3,87,89,19,29,86,90,35,45,68,76,85,91,51,61,104,2,103,105,18,30,102,106,34,46,84,92,67,77,101,107,50,62,120,1,119,121,83,93,17,31,100,108,66,78,118,122,33,47,117,123,49,63,99,109,82,94,0,116,124,65,79,16,32,98,110,48,115,125,81,95,64,114,126,97,111,80,113,127,96,112],t.t)
B.aS=s([4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,234,239,245,249,254,259,264,269,274,279,284],t.t)
B.bH=s([0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119],t.t)
B.aT=s([0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28],t.t)
B.bI=s([B.bc,B.aH,B.aI],A.S("t<cX>"))
B.a2=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.U=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15],t.t)
B.bK=s([254,253,251,247,239,223,191,127],t.t)
B.ak=s([12,8,140,8,76,8,204,8,44,8,172,8,108,8,236,8,28,8,156,8,92,8,220,8,60,8,188,8,124,8,252,8,2,8,130,8,66,8,194,8,34,8,162,8,98,8,226,8,18,8,146,8,82,8,210,8,50,8,178,8,114,8,242,8,10,8,138,8,74,8,202,8,42,8,170,8,106,8,234,8,26,8,154,8,90,8,218,8,58,8,186,8,122,8,250,8,6,8,134,8,70,8,198,8,38,8,166,8,102,8,230,8,22,8,150,8,86,8,214,8,54,8,182,8,118,8,246,8,14,8,142,8,78,8,206,8,46,8,174,8,110,8,238,8,30,8,158,8,94,8,222,8,62,8,190,8,126,8,254,8,1,8,129,8,65,8,193,8,33,8,161,8,97,8,225,8,17,8,145,8,81,8,209,8,49,8,177,8,113,8,241,8,9,8,137,8,73,8,201,8,41,8,169,8,105,8,233,8,25,8,153,8,89,8,217,8,57,8,185,8,121,8,249,8,5,8,133,8,69,8,197,8,37,8,165,8,101,8,229,8,21,8,149,8,85,8,213,8,53,8,181,8,117,8,245,8,13,8,141,8,77,8,205,8,45,8,173,8,109,8,237,8,29,8,157,8,93,8,221,8,61,8,189,8,125,8,253,8,19,9,275,9,147,9,403,9,83,9,339,9,211,9,467,9,51,9,307,9,179,9,435,9,115,9,371,9,243,9,499,9,11,9,267,9,139,9,395,9,75,9,331,9,203,9,459,9,43,9,299,9,171,9,427,9,107,9,363,9,235,9,491,9,27,9,283,9,155,9,411,9,91,9,347,9,219,9,475,9,59,9,315,9,187,9,443,9,123,9,379,9,251,9,507,9,7,9,263,9,135,9,391,9,71,9,327,9,199,9,455,9,39,9,295,9,167,9,423,9,103,9,359,9,231,9,487,9,23,9,279,9,151,9,407,9,87,9,343,9,215,9,471,9,55,9,311,9,183,9,439,9,119,9,375,9,247,9,503,9,15,9,271,9,143,9,399,9,79,9,335,9,207,9,463,9,47,9,303,9,175,9,431,9,111,9,367,9,239,9,495,9,31,9,287,9,159,9,415,9,95,9,351,9,223,9,479,9,63,9,319,9,191,9,447,9,127,9,383,9,255,9,511,9,0,7,64,7,32,7,96,7,16,7,80,7,48,7,112,7,8,7,72,7,40,7,104,7,24,7,88,7,56,7,120,7,4,7,68,7,36,7,100,7,20,7,84,7,52,7,116,7,3,8,131,8,67,8,195,8,35,8,163,8,99,8,227,8],t.t)
B.aU=s([A.ty(),A.tq(),A.tF(),A.tD(),A.tA(),A.tz(),A.tB()],t.B)
B.bL=s([0,5,16,5,8,5,24,5,4,5,20,5,12,5,28,5,2,5,18,5,10,5,26,5,6,5,22,5,14,5,30,5,1,5,17,5,9,5,25,5,5,5,21,5,13,5,29,5,3,5,19,5,11,5,27,5,7,5,23,5],t.t)
B.b0=new A.aa(0,"whiteIsZero")
B.lA=new A.aa(1,"blackIsZero")
B.lH=new A.aa(2,"rgb")
B.b2=new A.aa(3,"palette")
B.lI=new A.aa(4,"transparencyMask")
B.cB=new A.aa(5,"cmyk")
B.lJ=new A.aa(6,"yCbCr")
B.lK=new A.aa(7,"reserved7")
B.lL=new A.aa(8,"cieLab")
B.lM=new A.aa(9,"iccLab")
B.lB=new A.aa(10,"ituLab")
B.lC=new A.aa(11,"logL")
B.lD=new A.aa(12,"logLuv")
B.lE=new A.aa(13,"colorFilterArray")
B.lF=new A.aa(14,"linearRaw")
B.lG=new A.aa(15,"depth")
B.b1=new A.aa(16,"unknown")
B.bN=s([B.b0,B.lA,B.lH,B.b2,B.lI,B.cB,B.lJ,B.lK,B.lL,B.lM,B.lB,B.lC,B.lD,B.lE,B.lF,B.lG,B.b1],A.S("t<aa>"))
B.bP=s([0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0],t.t)
B.v=s([0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,31],t.t)
B.cm=new A.ez(0,"source")
B.cn=new A.ez(1,"over")
B.bQ=s([B.cm,B.cn],A.S("t<ez>"))
B.ls=new A.cy(0,"invalid")
B.aZ=new A.cy(1,"uint")
B.i=new A.cy(2,"int")
B.a_=new A.cy(3,"float")
B.bR=s([B.ls,B.aZ,B.i,B.a_],A.S("t<cy>"))
B.al=s([17,18,0,1,2,3,4,5,16,6,7,8,9,10,11,12,13,14,15],t.t)
B.am=s([-0.0,1,-1,2,-2,3,4,6,-3,5,-4,-5,-6,7,-7,8,-8,-9],t.t)
B.bS=s([B.f,B.bg,B.l,B.k,B.p,B.r,B.bl,B.H,B.bm,B.bn,B.bh,B.bi,B.bj,B.bk],A.S("t<ae>"))
B.bT=s([0,1,4,8,5,2,3,6,9,12,13,10,7,11,14,15],t.t)
B.dj=new A.b2(1,"rle")
B.dk=new A.b2(2,"zips")
B.dl=new A.b2(3,"zip")
B.dm=new A.b2(4,"piz")
B.dn=new A.b2(5,"pxr24")
B.dp=new A.b2(6,"b44")
B.dq=new A.b2(7,"b44a")
B.bU=s([B.bd,B.dj,B.dk,B.dl,B.dm,B.dn,B.dp,B.dq],A.S("t<b2>"))
B.iV=s([231,120,48,89,115,113,120,152,112],t.t)
B.dW=s([152,179,64,126,170,118,46,70,95],t.t)
B.hX=s([175,69,143,80,85,82,72,155,103],t.t)
B.eh=s([56,58,10,171,218,189,17,13,152],t.t)
B.il=s([114,26,17,163,44,195,21,10,173],t.t)
B.iA=s([121,24,80,195,26,62,44,64,85],t.t)
B.ih=s([144,71,10,38,171,213,144,34,26],t.t)
B.jU=s([170,46,55,19,136,160,33,206,71],t.t)
B.fH=s([63,20,8,114,114,208,12,9,226],t.t)
B.hn=s([81,40,11,96,182,84,29,16,36],t.t)
B.dH=s([B.iV,B.dW,B.hX,B.eh,B.il,B.iA,B.ih,B.jU,B.fH,B.hn],t.S)
B.fd=s([134,183,89,137,98,101,106,165,148],t.t)
B.jF=s([72,187,100,130,157,111,32,75,80],t.t)
B.iH=s([66,102,167,99,74,62,40,234,128],t.t)
B.e3=s([41,53,9,178,241,141,26,8,107],t.t)
B.hi=s([74,43,26,146,73,166,49,23,157],t.t)
B.fR=s([65,38,105,160,51,52,31,115,128],t.t)
B.fU=s([104,79,12,27,217,255,87,17,7],t.t)
B.hV=s([87,68,71,44,114,51,15,186,23],t.t)
B.jx=s([47,41,14,110,182,183,21,17,194],t.t)
B.j9=s([66,45,25,102,197,189,23,18,22],t.t)
B.ka=s([B.fd,B.jF,B.iH,B.e3,B.hi,B.fR,B.fU,B.hV,B.jx,B.j9],t.S)
B.iU=s([88,88,147,150,42,46,45,196,205],t.t)
B.io=s([43,97,183,117,85,38,35,179,61],t.t)
B.h0=s([39,53,200,87,26,21,43,232,171],t.t)
B.hM=s([56,34,51,104,114,102,29,93,77],t.t)
B.ib=s([39,28,85,171,58,165,90,98,64],t.t)
B.fM=s([34,22,116,206,23,34,43,166,73],t.t)
B.dI=s([107,54,32,26,51,1,81,43,31],t.t)
B.jX=s([68,25,106,22,64,171,36,225,114],t.t)
B.fc=s([34,19,21,102,132,188,16,76,124],t.t)
B.kk=s([62,18,78,95,85,57,50,48,51],t.t)
B.fq=s([B.iU,B.io,B.h0,B.hM,B.ib,B.fM,B.dI,B.jX,B.fc,B.kk],t.S)
B.i8=s([193,101,35,159,215,111,89,46,111],t.t)
B.eN=s([60,148,31,172,219,228,21,18,111],t.t)
B.em=s([112,113,77,85,179,255,38,120,114],t.t)
B.kg=s([40,42,1,196,245,209,10,25,109],t.t)
B.hD=s([88,43,29,140,166,213,37,43,154],t.t)
B.fO=s([61,63,30,155,67,45,68,1,209],t.t)
B.h7=s([100,80,8,43,154,1,51,26,71],t.t)
B.e6=s([142,78,78,16,255,128,34,197,171],t.t)
B.i3=s([41,40,5,102,211,183,4,1,221],t.t)
B.fy=s([51,50,17,168,209,192,23,25,82],t.t)
B.fp=s([B.i8,B.eN,B.em,B.kg,B.hD,B.fO,B.h7,B.e6,B.i3,B.fy],t.S)
B.fY=s([138,31,36,171,27,166,38,44,229],t.t)
B.fn=s([67,87,58,169,82,115,26,59,179],t.t)
B.ji=s([63,59,90,180,59,166,93,73,154],t.t)
B.k6=s([40,40,21,116,143,209,34,39,175],t.t)
B.eb=s([47,15,16,183,34,223,49,45,183],t.t)
B.eT=s([46,17,33,183,6,98,15,32,183],t.t)
B.l_=s([57,46,22,24,128,1,54,17,37],t.t)
B.h9=s([65,32,73,115,28,128,23,128,205],t.t)
B.iG=s([40,3,9,115,51,192,18,6,223],t.t)
B.hf=s([87,37,9,115,59,77,64,21,47],t.t)
B.i2=s([B.fY,B.fn,B.ji,B.k6,B.eb,B.eT,B.l_,B.h9,B.iG,B.hf],t.S)
B.kI=s([104,55,44,218,9,54,53,130,226],t.t)
B.eB=s([64,90,70,205,40,41,23,26,57],t.t)
B.jh=s([54,57,112,184,5,41,38,166,213],t.t)
B.fN=s([30,34,26,133,152,116,10,32,134],t.t)
B.j1=s([39,19,53,221,26,114,32,73,255],t.t)
B.fw=s([31,9,65,234,2,15,1,118,73],t.t)
B.i1=s([75,32,12,51,192,255,160,43,51],t.t)
B.fP=s([88,31,35,67,102,85,55,186,85],t.t)
B.hs=s([56,21,23,111,59,205,45,37,192],t.t)
B.ht=s([55,38,70,124,73,102,1,34,98],t.t)
B.kM=s([B.kI,B.eB,B.jh,B.fN,B.j1,B.fw,B.i1,B.fP,B.hs,B.ht],t.S)
B.hr=s([125,98,42,88,104,85,117,175,82],t.t)
B.fT=s([95,84,53,89,128,100,113,101,45],t.t)
B.iu=s([75,79,123,47,51,128,81,171,1],t.t)
B.ey=s([57,17,5,71,102,57,53,41,49],t.t)
B.jc=s([38,33,13,121,57,73,26,1,85],t.t)
B.kz=s([41,10,67,138,77,110,90,47,114],t.t)
B.i_=s([115,21,2,10,102,255,166,23,6],t.t)
B.ff=s([101,29,16,10,85,128,101,196,26],t.t)
B.h5=s([57,18,10,102,102,213,34,20,43],t.t)
B.hC=s([117,20,15,36,163,128,68,1,26],t.t)
B.hU=s([B.hr,B.fT,B.iu,B.ey,B.jc,B.kz,B.i_,B.ff,B.h5,B.hC],t.S)
B.hd=s([102,61,71,37,34,53,31,243,192],t.t)
B.kv=s([69,60,71,38,73,119,28,222,37],t.t)
B.hg=s([68,45,128,34,1,47,11,245,171],t.t)
B.dM=s([62,17,19,70,146,85,55,62,70],t.t)
B.kV=s([37,43,37,154,100,163,85,160,1],t.t)
B.kq=s([63,9,92,136,28,64,32,201,85],t.t)
B.jI=s([75,15,9,9,64,255,184,119,16],t.t)
B.fk=s([86,6,28,5,64,255,25,248,1],t.t)
B.j6=s([56,8,17,132,137,255,55,116,128],t.t)
B.et=s([58,15,20,82,135,57,26,121,40],t.t)
B.ie=s([B.hd,B.kv,B.hg,B.dM,B.kV,B.kq,B.jI,B.fk,B.j6,B.et],t.S)
B.iy=s([164,50,31,137,154,133,25,35,218],t.t)
B.fj=s([51,103,44,131,131,123,31,6,158],t.t)
B.kn=s([86,40,64,135,148,224,45,183,128],t.t)
B.hW=s([22,26,17,131,240,154,14,1,209],t.t)
B.eQ=s([45,16,21,91,64,222,7,1,197],t.t)
B.k7=s([56,21,39,155,60,138,23,102,213],t.t)
B.kL=s([83,12,13,54,192,255,68,47,28],t.t)
B.iI=s([85,26,85,85,128,128,32,146,171],t.t)
B.hO=s([18,11,7,63,144,171,4,4,246],t.t)
B.fr=s([35,27,10,146,174,171,12,26,128],t.t)
B.hH=s([B.iy,B.fj,B.kn,B.hW,B.eQ,B.k7,B.kL,B.iI,B.hO,B.fr],t.S)
B.jt=s([190,80,35,99,180,80,126,54,45],t.t)
B.jT=s([85,126,47,87,176,51,41,20,32],t.t)
B.je=s([101,75,128,139,118,146,116,128,85],t.t)
B.jE=s([56,41,15,176,236,85,37,9,62],t.t)
B.eu=s([71,30,17,119,118,255,17,18,138],t.t)
B.id=s([101,38,60,138,55,70,43,26,142],t.t)
B.hK=s([146,36,19,30,171,255,97,27,20],t.t)
B.iT=s([138,45,61,62,219,1,81,188,64],t.t)
B.kh=s([32,41,20,117,151,142,20,21,163],t.t)
B.jV=s([112,19,12,61,195,128,48,4,24],t.t)
B.jn=s([B.jt,B.jT,B.je,B.jE,B.eu,B.id,B.hK,B.iT,B.kh,B.jV],t.S)
B.bV=s([B.dH,B.ka,B.fq,B.fp,B.i2,B.kM,B.hU,B.ie,B.hH,B.jn],t.o)
B.az=new A.aw(0,"none")
B.L=new A.aw(1,"palette")
B.cz=new A.aw(2,"rgb")
B.lm=new A.aw(3,"gray")
B.ln=new A.aw(4,"reserved4")
B.lo=new A.aw(5,"reserved5")
B.lp=new A.aw(6,"reserved6")
B.lq=new A.aw(7,"reserved7")
B.lr=new A.aw(8,"reserved8")
B.M=new A.aw(9,"paletteRle")
B.cy=new A.aw(10,"rgbRle")
B.ll=new A.aw(11,"grayRle")
B.bW=s([B.az,B.L,B.cz,B.lm,B.ln,B.lo,B.lp,B.lq,B.lr,B.M,B.cy,B.ll],A.S("t<aw>"))
B.bZ=s([0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250],t.t)
B.is=s([0,1,1,1,0],t.t)
B.c_=s([A.ti(),A.tp(),A.tr(),A.tk(),A.tn(),A.tt(),A.tm(),A.ts(),A.tj(),A.tl()],t.B)
B.aQ=s([8,0,8,0],t.t)
B.ez=s([5,3,5,3],t.t)
B.e9=s([3,5,3,5],t.t)
B.bo=s([0,8,0,8],t.t)
B.bu=s([4,4,4,4],t.t)
B.el=s([4,4,0,0],t.t)
B.c0=s([B.aQ,B.ez,B.e9,B.bo,B.aQ,B.bu,B.el,B.bo],t.S)
B.c1=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535],t.t)
B.an=s([80,88,23,71,30,30,62,62,4,4,4,4,4,4,4,4,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41],t.t)
B.iQ=s([16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99],t.t)
B.V=s([0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845],t.t)
B.c2=s([127,127,191,127,159,191,223,127,143,159,175,191,207,223,239,127,135,143,151,159,167,175,183,191,199,207,215,223,231,239,247,127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,127],t.t)
B.ao=s([7,6,6,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],t.t)
B.J=s([28679,28679,31752,-32759,-31735,-30711,-29687,-28663,29703,29703,30727,30727,-27639,-26615,-25591,-24567],t.t)
B.ap=s([6430,6400,6400,6400,3225,3225,3225,3225,944,944,944,944,976,976,976,976,1456,1456,1456,1456,1488,1488,1488,1488,718,718,718,718,718,718,718,718,750,750,750,750,750,750,750,750,1520,1520,1520,1520,1552,1552,1552,1552,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,654,654,654,654,654,654,654,654,1072,1072,1072,1072,1104,1104,1104,1104,1136,1136,1136,1136,1168,1168,1168,1168,1200,1200,1200,1200,1232,1232,1232,1232,622,622,622,622,622,622,622,622,1008,1008,1008,1008,1040,1040,1040,1040,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,1712,1712,1712,1712,1744,1744,1744,1744,846,846,846,846,846,846,846,846,1264,1264,1264,1264,1296,1296,1296,1296,1328,1328,1328,1328,1360,1360,1360,1360,1392,1392,1392,1392,1424,1424,1424,1424,686,686,686,686,686,686,686,686,910,910,910,910,910,910,910,910,1968,1968,1968,1968,2000,2000,2000,2000,2032,2032,2032,2032,16,16,16,16,10257,10257,10257,10257,12305,12305,12305,12305,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,878,878,878,878,878,878,878,878,1904,1904,1904,1904,1936,1936,1936,1936,-18413,-18413,-16365,-16365,-14317,-14317,-10221,-10221,590,590,590,590,590,590,590,590,782,782,782,782,782,782,782,782,1584,1584,1584,1584,1616,1616,1616,1616,1648,1648,1648,1648,1680,1680,1680,1680,814,814,814,814,814,814,814,814,1776,1776,1776,1776,1808,1808,1808,1808,1840,1840,1840,1840,1872,1872,1872,1872,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,14353,14353,14353,14353,16401,16401,16401,16401,22547,22547,24595,24595,20497,20497,20497,20497,18449,18449,18449,18449,26643,26643,28691,28691,30739,30739,-32749,-32749,-30701,-30701,-28653,-28653,-26605,-26605,-24557,-24557,-22509,-22509,-20461,-20461,8207,8207,8207,8207,8207,8207,8207,8207,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232],t.t)
B.K=s([0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31],t.t)
B.ar=s([0,1,2,3,6,4,5,6,6,6,6,6,6,6,6,7,0],t.t)
B.l8=new A.bY(0,"none")
B.l9=new A.bY(1,"sub")
B.la=new A.bY(2,"up")
B.lb=new A.bY(3,"average")
B.lc=new A.bY(4,"paeth")
B.as=s([B.l8,B.l9,B.la,B.lb,B.lc],A.S("t<bY>"))
B.E=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.B=s([0,1,3,7,15,31,63,127,255],t.t)
B.at=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.au=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7],t.t)
B.w=s([255,255,255,255,255,255,255,255,255,255,255],t.t)
B.X=s([B.w,B.w,B.w],t.S)
B.hL=s([176,246,255,255,255,255,255,255,255,255,255],t.t)
B.kE=s([223,241,252,255,255,255,255,255,255,255,255],t.t)
B.f6=s([249,253,253,255,255,255,255,255,255,255,255],t.t)
B.i0=s([B.hL,B.kE,B.f6],t.S)
B.hp=s([255,244,252,255,255,255,255,255,255,255,255],t.t)
B.hb=s([234,254,254,255,255,255,255,255,255,255,255],t.t)
B.c8=s([253,255,255,255,255,255,255,255,255,255,255],t.t)
B.fi=s([B.hp,B.hb,B.c8],t.S)
B.km=s([255,246,254,255,255,255,255,255,255,255,255],t.t)
B.j2=s([239,253,254,255,255,255,255,255,255,255,255],t.t)
B.c4=s([254,255,254,255,255,255,255,255,255,255,255],t.t)
B.jG=s([B.km,B.j2,B.c4],t.S)
B.bM=s([255,248,254,255,255,255,255,255,255,255,255],t.t)
B.fC=s([251,255,254,255,255,255,255,255,255,255,255],t.t)
B.iz=s([B.bM,B.fC,B.w],t.S)
B.aP=s([255,253,254,255,255,255,255,255,255,255,255],t.t)
B.iw=s([251,254,254,255,255,255,255,255,255,255,255],t.t)
B.fK=s([B.aP,B.iw,B.c4],t.S)
B.ef=s([255,254,253,255,254,255,255,255,255,255,255],t.t)
B.hl=s([250,255,254,255,254,255,255,255,255,255,255],t.t)
B.aq=s([254,255,255,255,255,255,255,255,255,255,255],t.t)
B.hE=s([B.ef,B.hl,B.aq],t.S)
B.h4=s([B.X,B.i0,B.fi,B.jG,B.iz,B.fK,B.hE,B.X],t.o)
B.dU=s([217,255,255,255,255,255,255,255,255,255,255],t.t)
B.hI=s([225,252,241,253,255,255,254,255,255,255,255],t.t)
B.jg=s([234,250,241,250,253,255,253,254,255,255,255],t.t)
B.jW=s([B.dU,B.hI,B.jg],t.S)
B.aW=s([255,254,255,255,255,255,255,255,255,255,255],t.t)
B.f9=s([223,254,254,255,255,255,255,255,255,255,255],t.t)
B.eR=s([238,253,254,254,255,255,255,255,255,255,255],t.t)
B.j_=s([B.aW,B.f9,B.eR],t.S)
B.he=s([249,254,255,255,255,255,255,255,255,255,255],t.t)
B.kj=s([B.bM,B.he,B.w],t.S)
B.jZ=s([255,253,255,255,255,255,255,255,255,255,255],t.t)
B.iv=s([247,254,255,255,255,255,255,255,255,255,255],t.t)
B.ij=s([B.jZ,B.iv,B.w],t.S)
B.eM=s([252,255,255,255,255,255,255,255,255,255,255],t.t)
B.e5=s([B.aP,B.eM,B.w],t.S)
B.ca=s([255,254,254,255,255,255,255,255,255,255,255],t.t)
B.eP=s([B.ca,B.c8,B.w],t.S)
B.iY=s([255,254,253,255,255,255,255,255,255,255,255],t.t)
B.bO=s([250,255,255,255,255,255,255,255,255,255,255],t.t)
B.eK=s([B.iY,B.bO,B.aq],t.S)
B.ei=s([B.jW,B.j_,B.kj,B.ij,B.e5,B.eP,B.eK,B.X],t.o)
B.jp=s([186,251,250,255,255,255,255,255,255,255,255],t.t)
B.fz=s([234,251,244,254,255,255,255,255,255,255,255],t.t)
B.jH=s([251,251,243,253,254,255,254,255,255,255,255],t.t)
B.fI=s([B.jp,B.fz,B.jH],t.S)
B.fE=s([236,253,254,255,255,255,255,255,255,255,255],t.t)
B.iW=s([251,253,253,254,254,255,255,255,255,255,255],t.t)
B.hu=s([B.aP,B.fE,B.iW],t.S)
B.js=s([254,254,254,255,255,255,255,255,255,255,255],t.t)
B.fA=s([B.ca,B.js,B.w],t.S)
B.jM=s([254,254,255,255,255,255,255,255,255,255,255],t.t)
B.fD=s([B.aW,B.jM,B.aq],t.S)
B.cb=s([B.w,B.aq,B.w],t.S)
B.eg=s([B.fI,B.hu,B.fA,B.fD,B.cb,B.X,B.X,B.X],t.o)
B.hj=s([248,255,255,255,255,255,255,255,255,255,255],t.t)
B.fS=s([250,254,252,254,255,255,255,255,255,255,255],t.t)
B.fx=s([248,254,249,253,255,255,255,255,255,255,255],t.t)
B.hx=s([B.hj,B.fS,B.fx],t.S)
B.ed=s([255,253,253,255,255,255,255,255,255,255,255],t.t)
B.k3=s([246,253,253,255,255,255,255,255,255,255,255],t.t)
B.fJ=s([252,254,251,254,254,255,255,255,255,255,255],t.t)
B.k2=s([B.ed,B.k3,B.fJ],t.S)
B.kT=s([255,254,252,255,255,255,255,255,255,255,255],t.t)
B.fv=s([248,254,253,255,255,255,255,255,255,255,255],t.t)
B.eJ=s([253,255,254,254,255,255,255,255,255,255,255],t.t)
B.iF=s([B.kT,B.fv,B.eJ],t.S)
B.kK=s([255,251,254,255,255,255,255,255,255,255,255],t.t)
B.i9=s([245,251,254,255,255,255,255,255,255,255,255],t.t)
B.ic=s([253,253,254,255,255,255,255,255,255,255,255],t.t)
B.f2=s([B.kK,B.i9,B.ic],t.S)
B.f4=s([255,251,253,255,255,255,255,255,255,255,255],t.t)
B.hq=s([252,253,254,255,255,255,255,255,255,255,255],t.t)
B.jz=s([B.f4,B.hq,B.aW],t.S)
B.eF=s([255,252,255,255,255,255,255,255,255,255,255],t.t)
B.kH=s([249,255,254,255,255,255,255,255,255,255,255],t.t)
B.fV=s([255,255,254,255,255,255,255,255,255,255,255],t.t)
B.dL=s([B.eF,B.kH,B.fV],t.S)
B.kW=s([255,255,253,255,255,255,255,255,255,255,255],t.t)
B.fB=s([B.kW,B.bO,B.w],t.S)
B.eI=s([B.hx,B.k2,B.iF,B.f2,B.jz,B.dL,B.fB,B.cb],t.o)
B.jR=s([B.h4,B.ei,B.eg,B.eI],t.dB)
B.cG=new A.ad(1,"rle8")
B.cL=new A.ad(2,"rle4")
B.cM=new A.ad(4,"jpeg")
B.cN=new A.ad(5,"png")
B.cO=new A.ad(7,"reserved7")
B.cP=new A.ad(8,"reserved8")
B.cQ=new A.ad(9,"reserved9")
B.cH=new A.ad(10,"reserved10")
B.cI=new A.ad(11,"cmyk")
B.cJ=new A.ad(12,"cmykRle8")
B.cK=new A.ad(13,"cmykRle4")
B.av=s([B.aE,B.cG,B.cL,B.aa,B.cM,B.cN,B.aF,B.cO,B.cP,B.cQ,B.cH,B.cI,B.cJ,B.cK],A.S("t<ad>"))
B.W=s([0,128,192,224,240,248,252,254,255],t.t)
B.c5=s([137,80,78,71,13,10,26,10],t.t)
B.a3=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535,131071,262143,524287,1048575,2097151,4194303,8388607,16777215,33554431,67108863,134217727,268435455,536870911,1073741823,2147483647,4294967295],t.t)
B.c6=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.c7=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.cC=new A.cz(0,"predictor")
B.m0=new A.cz(1,"crossColor")
B.m1=new A.cz(2,"subtractGreen")
B.cD=new A.cz(3,"colorIndexing")
B.c9=s([B.cC,B.m0,B.m1,B.cD],A.S("t<cz>"))
B.x=s([0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255],t.t)
B.ks=s([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
B.cc=s([A.tu(),A.to(),A.tE(),A.tC(),A.tw(),A.tv(),A.tx()],t.B)
B.cd=s([0,4,8,12,128,132,136,140,256,260,264,268,384,388,392,396],t.t)
B.ce=s([null,A.tU(),A.tV(),A.tT()],A.S("t<~(f,f,f,f,f,bG)?>"))
B.cE=new A.eT(0,"shrinkImage")
B.cF=new A.eT(1,"calcImageMetadata")
B.cf=s([B.cE,B.cF],A.S("t<eT>"))
B.aw=s([0,36,72,109,145,182,218,255],t.t)
B.q=s([0,8,16,24,32,41,49,57,65,74,82,90,98,106,115,123,131,139,148,156,164,172,180,189,197,205,213,222,230,238,246,255],t.t)
B.kG=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.lf=new A.b8(0,"bitmap")
B.ct=new A.b8(1,"grayscale")
B.lg=new A.b8(2,"indexed")
B.cu=new A.b8(3,"rgb")
B.cv=new A.b8(4,"cmyk")
B.lh=new A.b8(5,"multiChannel")
B.li=new A.b8(6,"duoTone")
B.cw=new A.b8(7,"lab")
B.cg=s([B.lf,B.ct,B.lg,B.cu,B.cv,B.lh,B.li,B.cw],A.S("t<b8>"))
B.kO=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.ch=s([0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0],t.t)
B.e_=s([2,6,2,6],t.t)
B.eG=s([6,2,6,2],t.t)
B.dZ=s([2,2,6,6],t.t)
B.dS=s([1,3,3,9],t.t)
B.ej=s([4,0,12,0],t.t)
B.e7=s([3,1,9,3],t.t)
B.eZ=s([8,8,0,0],t.t)
B.ek=s([4,12,0,0],t.t)
B.dO=s([16,0,0,0],t.t)
B.dK=s([12,4,0,0],t.t)
B.eH=s([6,6,2,2],t.t)
B.ea=s([3,9,1,3],t.t)
B.dJ=s([12,0,4,0],t.t)
B.f5=s([9,3,3,1],t.t)
B.h=s([B.bu,B.e_,B.aQ,B.eG,B.dZ,B.dS,B.ej,B.e7,B.eZ,B.ek,B.dO,B.dK,B.eH,B.ea,B.dJ,B.f5],t.S)
B.Y=s([0,-128,64,-64,32,-96,96,-32,16,-112,80,-48,48,-80,112,-16,8,-120,72,-56,40,-88,104,-24,24,-104,88,-40,56,-72,120,-8,4,-124,68,-60,36,-92,100,-28,20,-108,84,-44,52,-76,116,-12,12,-116,76,-52,44,-84,108,-20,28,-100,92,-36,60,-68,124,-4,2,-126,66,-62,34,-94,98,-30,18,-110,82,-46,50,-78,114,-14,10,-118,74,-54,42,-86,106,-22,26,-102,90,-38,58,-70,122,-6,6,-122,70,-58,38,-90,102,-26,22,-106,86,-42,54,-74,118,-10,14,-114,78,-50,46,-82,110,-18,30,-98,94,-34,62,-66,126,-2,1,-127,65,-63,33,-95,97,-31,17,-111,81,-47,49,-79,113,-15,9,-119,73,-55,41,-87,105,-23,25,-103,89,-39,57,-71,121,-7,5,-123,69,-59,37,-91,101,-27,21,-107,85,-43,53,-75,117,-11,13,-115,77,-51,45,-83,109,-19,29,-99,93,-35,61,-67,125,-3,3,-125,67,-61,35,-93,99,-29,19,-109,83,-45,51,-77,115,-13,11,-117,75,-53,43,-85,107,-21,27,-101,91,-37,59,-69,123,-5,7,-121,71,-57,39,-89,103,-25,23,-105,87,-41,55,-73,119,-9,15,-113,79,-49,47,-81,111,-17,31,-97,95,-33,63,-65,127,-1],t.t)
B.l6={ProcessingSoftware:0,SubfileType:1,OldSubfileType:2,ImageWidth:3,ImageLength:4,ImageHeight:5,BitsPerSample:6,Compression:7,PhotometricInterpretation:8,Thresholding:9,CellWidth:10,CellLength:11,FillOrder:12,DocumentName:13,ImageDescription:14,Make:15,Model:16,StripOffsets:17,Orientation:18,SamplesPerPixel:19,RowsPerStrip:20,StripByteCounts:21,MinSampleValue:22,MaxSampleValue:23,XResolution:24,YResolution:25,PlanarConfiguration:26,PageName:27,XPosition:28,YPosition:29,GrayResponseUnit:30,GrayResponseCurve:31,T4Options:32,T6Options:33,ResolutionUnit:34,PageNumber:35,ColorResponseUnit:36,TransferFunction:37,Software:38,DateTime:39,Artist:40,HostComputer:41,Predictor:42,WhitePoint:43,PrimaryChromaticities:44,ColorMap:45,HalftoneHints:46,TileWidth:47,TileLength:48,TileOffsets:49,TileByteCounts:50,BadFaxLines:51,CleanFaxData:52,ConsecutiveBadFaxLines:53,InkSet:54,InkNames:55,NumberofInks:56,DotRange:57,TargetPrinter:58,ExtraSamples:59,SampleFormat:60,SMinSampleValue:61,SMaxSampleValue:62,TransferRange:63,ClipPath:64,JPEGProc:65,JPEGInterchangeFormat:66,JPEGInterchangeFormatLength:67,YCbCrCoefficients:68,YCbCrSubSampling:69,YCbCrPositioning:70,ReferenceBlackWhite:71,ApplicationNotes:72,Rating:73,CFARepeatPatternDim:74,CFAPattern:75,BatteryLevel:76,Copyright:77,ExposureTime:78,FNumber:79,"IPTC-NAA":80,ExifOffset:81,InterColorProfile:82,ExposureProgram:83,SpectralSensitivity:84,GPSOffset:85,ISOSpeed:86,OECF:87,SensitivityType:88,RecommendedExposureIndex:89,ExifVersion:90,DateTimeOriginal:91,DateTimeDigitized:92,OffsetTime:93,OffsetTimeOriginal:94,OffsetTimeDigitized:95,ComponentsConfiguration:96,CompressedBitsPerPixel:97,ShutterSpeedValue:98,ApertureValue:99,BrightnessValue:100,ExposureBiasValue:101,MaxApertureValue:102,SubjectDistance:103,MeteringMode:104,LightSource:105,Flash:106,FocalLength:107,SubjectArea:108,MakerNote:109,UserComment:110,SubSecTime:111,SubSecTimeOriginal:112,SubSecTimeDigitized:113,XPTitle:114,XPComment:115,XPAuthor:116,XPKeywords:117,XPSubject:118,FlashPixVersion:119,ColorSpace:120,ExifImageWidth:121,ExifImageLength:122,RelatedSoundFile:123,InteroperabilityOffset:124,FlashEnergy:125,SpatialFrequencyResponse:126,FocalPlaneXResolution:127,FocalPlaneYResolution:128,FocalPlaneResolutionUnit:129,SubjectLocation:130,ExposureIndex:131,SensingMethod:132,FileSource:133,SceneType:134,CVAPattern:135,CustomRendered:136,ExposureMode:137,WhiteBalance:138,DigitalZoomRatio:139,FocalLengthIn35mmFilm:140,SceneCaptureType:141,GainControl:142,Contrast:143,Saturation:144,Sharpness:145,DeviceSettingDescription:146,SubjectDistanceRange:147,ImageUniqueID:148,CameraOwnerName:149,BodySerialNumber:150,LensSpecification:151,LensMake:152,LensModel:153,LensSerialNumber:154,Gamma:155,PrintIM:156,Padding:157,OffsetSchema:158,OwnerName:159,SerialNumber:160,InteropIndex:161,InteropVersion:162,RelatedImageFileFormat:163,RelatedImageWidth:164,RelatedImageLength:165,GPSVersionID:166,GPSLatitudeRef:167,GPSLatitude:168,GPSLongitudeRef:169,GPSLongitude:170,GPSAltitudeRef:171,GPSAltitude:172,GPSTimeStamp:173,GPSSatellites:174,GPSStatus:175,GPSMeasureMode:176,GPSDOP:177,GPSSpeedRef:178,GPSSpeed:179,GPSTrackRef:180,GPSTrack:181,GPSImgDirectionRef:182,GPSImgDirection:183,GPSMapDatum:184,GPSDestLatitudeRef:185,GPSDestLatitude:186,GPSDestLongitudeRef:187,GPSDestLongitude:188,GPSDestBearingRef:189,GPSDestBearing:190,GPSDestDistanceRef:191,GPSDestDistance:192,GPSProcessingMethod:193,GPSAreaInformation:194,GPSDate:195,GPSDifferential:196}
B.l0=new A.bP(B.l6,[11,254,255,256,257,257,258,259,262,263,264,265,266,269,270,271,272,273,274,277,278,279,280,281,282,283,284,285,286,287,290,291,292,293,296,297,300,301,305,306,315,316,317,318,319,320,321,322,323,324,325,326,327,328,332,333,334,336,337,338,339,340,341,342,343,512,513,514,529,530,531,532,700,18246,33421,33422,33423,33432,33434,33437,33723,34665,34675,34850,34852,34853,34855,34856,34864,34866,36864,36867,36868,36880,36881,36882,37121,37122,37377,37378,37379,37380,37381,37382,37383,37384,37385,37386,37396,37500,37510,37520,37521,37522,40091,40092,40093,40094,40095,40960,40961,40962,40963,40964,40965,41483,41484,41486,41487,41488,41492,41493,41495,41728,41729,41730,41985,41986,41987,41988,41989,41990,41991,41992,41993,41994,41995,41996,42016,42032,42033,42034,42035,42036,42037,42240,50341,59932,59933,65e3,65001,1,2,4096,4097,4098,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30],t.W)
B.l4={"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,A:10,B:11,C:12,D:13,E:14,F:15,G:16,H:17,I:18,J:19,K:20,L:21,M:22,N:23,O:24,P:25,Q:26,R:27,S:28,T:29,U:30,V:31,W:32,X:33,Y:34,Z:35,a:36,b:37,c:38,d:39,e:40,f:41,g:42,h:43,i:44,j:45,k:46,l:47,m:48,n:49,o:50,p:51,q:52,r:53,s:54,t:55,u:56,v:57,w:58,x:59,y:60,z:61,"#":62,$:63,"%":64,"*":65,"+":66,",":67,"-":68,".":69,":":70,";":71,"=":72,"?":73,"@":74,"[":75,"]":76,"^":77,_:78,"{":79,"|":80,"}":81,"~":82}
B.l1=new A.bP(B.l4,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82],t.W)
B.l5={"123":0,"3dml":1,"3ds":2,"3g2":3,"3gp":4,"7z":5,aab:6,aac:7,aam:8,aas:9,abw:10,ac:11,acc:12,ace:13,acu:14,acutc:15,adp:16,aep:17,afm:18,afp:19,ahead:20,ai:21,aif:22,aifc:23,aiff:24,air:25,ait:26,ami:27,apk:28,appcache:29,application:30,apr:31,arc:32,asc:33,asf:34,asm:35,aso:36,asx:37,atc:38,atom:39,atomcat:40,atomsvc:41,atx:42,au:43,avi:44,avif:45,aw:46,azf:47,azs:48,azw:49,bat:50,bcpio:51,bdf:52,bdm:53,bed:54,bh2:55,bin:56,blb:57,blorb:58,bmi:59,bmp:60,book:61,box:62,boz:63,bpk:64,btif:65,bz:66,bz2:67,c:68,c11amc:69,c11amz:70,c4d:71,c4f:72,c4g:73,c4p:74,c4u:75,cab:76,caf:77,cap:78,car:79,cat:80,cb7:81,cba:82,cbr:83,cbt:84,cbz:85,cc:86,cct:87,ccxml:88,cdbcmsg:89,cdf:90,cdkey:91,cdmia:92,cdmic:93,cdmid:94,cdmio:95,cdmiq:96,cdx:97,cdxml:98,cdy:99,cer:100,cfs:101,cgm:102,chat:103,chm:104,chrt:105,cif:106,cii:107,cil:108,cla:109,class:110,clkk:111,clkp:112,clkt:113,clkw:114,clkx:115,clp:116,cmc:117,cmdf:118,cml:119,cmp:120,cmx:121,cod:122,com:123,conf:124,cpio:125,cpp:126,cpt:127,crd:128,crl:129,crt:130,cryptonote:131,csh:132,csml:133,csp:134,css:135,cst:136,csv:137,cu:138,curl:139,cww:140,cxt:141,cxx:142,dae:143,daf:144,dart:145,dataless:146,davmount:147,dbk:148,dcm:149,dcr:150,dcurl:151,dd2:152,ddd:153,deb:154,def:155,deploy:156,der:157,dfac:158,dgc:159,dic:160,dir:161,dis:162,dist:163,distz:164,djv:165,djvu:166,dll:167,dmg:168,dmp:169,dms:170,dna:171,doc:172,docm:173,docx:174,dot:175,dotm:176,dotx:177,dp:178,dpg:179,dra:180,dsc:181,dssc:182,dtb:183,dtd:184,dts:185,dtshd:186,dump:187,dvb:188,dvi:189,dwf:190,dwg:191,dxf:192,dxp:193,dxr:194,ecelp4800:195,ecelp7470:196,ecelp9600:197,ecma:198,edm:199,edx:200,efif:201,ei6:202,elc:203,emf:204,eml:205,emma:206,emz:207,eol:208,eot:209,eps:210,epub:211,es3:212,esa:213,esf:214,et3:215,etx:216,eva:217,evy:218,exe:219,exi:220,ext:221,ez:222,ez2:223,ez3:224,f:225,f4v:226,f77:227,f90:228,fbs:229,fcdt:230,fcs:231,fdf:232,fe_launch:233,fg5:234,fgd:235,fh:236,fh4:237,fh5:238,fh7:239,fhc:240,fig:241,flac:242,fli:243,flo:244,flv:245,flw:246,flx:247,fly:248,fm:249,fnc:250,for:251,fpx:252,frame:253,fsc:254,fst:255,ftc:256,fti:257,fvt:258,fxp:259,fxpl:260,fzs:261,g2w:262,g3:263,g3w:264,gac:265,gam:266,gbr:267,gca:268,gdl:269,geo:270,gex:271,ggb:272,ggt:273,ghf:274,gif:275,gim:276,glb:277,gltf:278,gml:279,gmx:280,gnumeric:281,gph:282,gpx:283,gqf:284,gqs:285,gram:286,gramps:287,gre:288,grv:289,grxml:290,gsf:291,gtar:292,gtm:293,gtw:294,gv:295,gxf:296,gxt:297,h:298,h261:299,h263:300,h264:301,hal:302,hbci:303,hdf:304,heic:305,heif:306,hh:307,hlp:308,hpgl:309,hpid:310,hps:311,hqx:312,htke:313,htm:314,html:315,hvd:316,hvp:317,hvs:318,i2g:319,icc:320,ice:321,icm:322,ico:323,ics:324,ief:325,ifb:326,ifm:327,iges:328,igl:329,igm:330,igs:331,igx:332,iif:333,imp:334,ims:335,in:336,ink:337,inkml:338,install:339,iota:340,ipfix:341,ipk:342,irm:343,irp:344,iso:345,itp:346,ivp:347,ivu:348,jad:349,jam:350,jar:351,java:352,jisp:353,jlt:354,jnlp:355,joda:356,jpe:357,jpeg:358,jpg:359,jpgm:360,jpgv:361,jpm:362,js:363,json:364,jsonml:365,kar:366,karbon:367,kfo:368,kia:369,kml:370,kmz:371,kne:372,knp:373,kon:374,kpr:375,kpt:376,kpxx:377,ksp:378,ktr:379,ktx:380,ktz:381,kwd:382,kwt:383,lasxml:384,latex:385,lbd:386,lbe:387,les:388,lha:389,link66:390,list:391,list3820:392,listafp:393,lnk:394,log:395,lostxml:396,lrf:397,lrm:398,ltf:399,lvp:400,lwp:401,lzh:402,m13:403,m14:404,m1v:405,m21:406,m2a:407,m2v:408,m3a:409,m3u:410,m3u8:411,m4a:412,m4b:413,m4u:414,m4v:415,ma:416,mads:417,mag:418,maker:419,man:420,mar:421,mathml:422,mb:423,mbk:424,mbox:425,mc1:426,mcd:427,mcurl:428,md:429,markdown:430,mdb:431,mdi:432,me:433,mesh:434,meta4:435,metalink:436,mets:437,mfm:438,mft:439,mgp:440,mgz:441,mid:442,midi:443,mie:444,mif:445,mime:446,mj2:447,mjp2:448,mjs:449,mk3d:450,mka:451,mks:452,mkv:453,mlp:454,mmd:455,mmf:456,mmr:457,mng:458,mny:459,mobi:460,mods:461,mov:462,movie:463,mp2:464,mp21:465,mp2a:466,mp3:467,mp4:468,mp4a:469,mp4s:470,mp4v:471,mpc:472,mpe:473,mpeg:474,mpg:475,mpg4:476,mpga:477,mpkg:478,mpm:479,mpn:480,mpp:481,mpt:482,mpy:483,mqy:484,mrc:485,mrcx:486,ms:487,mscml:488,mseed:489,mseq:490,msf:491,msh:492,msi:493,msl:494,msty:495,mts:496,mus:497,musicxml:498,mvb:499,mwf:500,mxf:501,mxl:502,mxml:503,mxs:504,mxu:505,"n-gage":506,n3:507,nb:508,nbp:509,nc:510,ncx:511,nfo:512,ngdat:513,nitf:514,nlu:515,nml:516,nnd:517,nns:518,nnw:519,npx:520,nsc:521,nsf:522,ntf:523,nzb:524,oa2:525,oa3:526,oas:527,obd:528,obj:529,oda:530,odb:531,odc:532,odf:533,odft:534,odg:535,odi:536,odm:537,odp:538,ods:539,odt:540,oga:541,ogg:542,ogv:543,ogx:544,omdoc:545,onepkg:546,onetmp:547,onetoc:548,onetoc2:549,opf:550,opml:551,oprc:552,org:553,osf:554,osfpvg:555,otc:556,otf:557,otg:558,oth:559,oti:560,otp:561,ots:562,ott:563,oxps:564,oxt:565,p:566,p10:567,p12:568,p7b:569,p7c:570,p7m:571,p7r:572,p7s:573,p8:574,pas:575,paw:576,pbd:577,pbm:578,pcap:579,pcf:580,pcl:581,pclxl:582,pct:583,pcurl:584,pcx:585,pdb:586,pdf:587,pfa:588,pfb:589,pfm:590,pfr:591,pfx:592,pgm:593,pgn:594,pgp:595,pic:596,pkg:597,pki:598,pkipath:599,plb:600,plc:601,plf:602,pls:603,pml:604,png:605,pnm:606,portpkg:607,pot:608,potm:609,potx:610,ppam:611,ppd:612,ppm:613,pps:614,ppsm:615,ppsx:616,ppt:617,pptm:618,pptx:619,pqa:620,prc:621,pre:622,prf:623,ps:624,psb:625,psd:626,psf:627,pskcxml:628,ptid:629,pub:630,pvb:631,pwn:632,pya:633,pyv:634,qam:635,qbo:636,qfx:637,qps:638,qt:639,qwd:640,qwt:641,qxb:642,qxd:643,qxl:644,qxt:645,ra:646,ram:647,rar:648,ras:649,rcprofile:650,rdf:651,rdz:652,rep:653,res:654,rgb:655,rif:656,rip:657,ris:658,rl:659,rlc:660,rld:661,rm:662,rmi:663,rmp:664,rms:665,rmvb:666,rnc:667,roa:668,roff:669,rp9:670,rpss:671,rpst:672,rq:673,rs:674,rsd:675,rss:676,rtf:677,rtx:678,s:679,s3m:680,saf:681,sbml:682,sc:683,scd:684,scm:685,scq:686,scs:687,scurl:688,sda:689,sdc:690,sdd:691,sdkd:692,sdkm:693,sdp:694,sdw:695,see:696,seed:697,sema:698,semd:699,semf:700,ser:701,setpay:702,setreg:703,"sfd-hdstx":704,sfs:705,sfv:706,sgi:707,sgl:708,sgm:709,sgml:710,sh:711,shar:712,shf:713,sid:714,sig:715,sil:716,silo:717,sis:718,sisx:719,sit:720,sitx:721,skd:722,skm:723,skp:724,skt:725,sldm:726,sldx:727,slt:728,sm:729,smf:730,smi:731,smil:732,smv:733,smzip:734,snd:735,snf:736,so:737,spc:738,spf:739,spl:740,spot:741,spp:742,spq:743,spx:744,sql:745,src:746,srt:747,sru:748,srx:749,ssdl:750,sse:751,ssf:752,ssml:753,st:754,stc:755,std:756,stf:757,sti:758,stk:759,stl:760,str:761,stw:762,sub:763,sus:764,susp:765,sv4cpio:766,sv4crc:767,svc:768,svd:769,svg:770,svgz:771,swa:772,swf:773,swi:774,sxc:775,sxd:776,sxg:777,sxi:778,sxm:779,sxw:780,t:781,t3:782,taglet:783,tao:784,tar:785,tcap:786,tcl:787,teacher:788,tei:789,teicorpus:790,tex:791,texi:792,texinfo:793,text:794,tfi:795,tfm:796,tga:797,thmx:798,tif:799,tiff:800,tmo:801,toml:802,torrent:803,tpl:804,tpt:805,tr:806,tra:807,trm:808,tsd:809,tsv:810,ttc:811,ttf:812,ttl:813,twd:814,twds:815,txd:816,txf:817,txt:818,u32:819,udeb:820,ufd:821,ufdl:822,ulx:823,umj:824,unityweb:825,uoml:826,uri:827,uris:828,urls:829,ustar:830,utz:831,uu:832,uva:833,uvd:834,uvf:835,uvg:836,uvh:837,uvi:838,uvm:839,uvp:840,uvs:841,uvt:842,uvu:843,uvv:844,uvva:845,uvvd:846,uvvf:847,uvvg:848,uvvh:849,uvvi:850,uvvm:851,uvvp:852,uvvs:853,uvvt:854,uvvu:855,uvvv:856,uvvx:857,uvvz:858,uvx:859,uvz:860,vcard:861,vcd:862,vcf:863,vcg:864,vcs:865,vcx:866,vis:867,viv:868,vob:869,vor:870,vox:871,vrml:872,vsd:873,vsf:874,vss:875,vst:876,vsw:877,vtu:878,vxml:879,w3d:880,wad:881,wasm:882,wav:883,wax:884,wbmp:885,wbs:886,wbxml:887,wcm:888,wdb:889,wdp:890,weba:891,webm:892,webmanifest:893,webp:894,wg:895,wgt:896,wks:897,wm:898,wma:899,wmd:900,wmf:901,wml:902,wmlc:903,wmls:904,wmlsc:905,wmv:906,wmx:907,wmz:908,woff:909,woff2:910,wpd:911,wpl:912,wps:913,wqd:914,wri:915,wrl:916,wsdl:917,wspolicy:918,wtb:919,wvx:920,x32:921,x3d:922,x3db:923,x3dbz:924,x3dv:925,x3dvz:926,x3dz:927,xaml:928,xap:929,xar:930,xbap:931,xbd:932,xbm:933,xdf:934,xdm:935,xdp:936,xdssc:937,xdw:938,xenc:939,xer:940,xfdf:941,xfdl:942,xht:943,xhtml:944,xhvml:945,xif:946,xla:947,xlam:948,xlc:949,xlf:950,xlm:951,xls:952,xlsb:953,xlsm:954,xlsx:955,xlt:956,xltm:957,xltx:958,xlw:959,xm:960,xml:961,xo:962,xop:963,xpi:964,xpl:965,xpm:966,xpr:967,xps:968,xpw:969,xpx:970,xsl:971,xslt:972,xsm:973,xspf:974,xul:975,xvm:976,xvml:977,xwd:978,xyz:979,xz:980,yang:981,yin:982,z1:983,z2:984,z3:985,z4:986,z5:987,z6:988,z7:989,z8:990,zaz:991,zip:992,zir:993,zirz:994,zmm:995}
B.l2=new A.bP(B.l5,["application/vnd.lotus-1-2-3","text/vnd.in3d.3dml","image/x-3ds","video/3gpp2","video/3gpp","application/x-7z-compressed","application/x-authorware-bin","audio/aac","application/x-authorware-map","application/x-authorware-seg","application/x-abiword","application/pkix-attr-cert","application/vnd.americandynamics.acc","application/x-ace-compressed","application/vnd.acucobol","application/vnd.acucorp","audio/adpcm","application/vnd.audiograph","application/x-font-type1","application/vnd.ibm.modcap","application/vnd.ahead.space","application/postscript","audio/x-aiff","audio/x-aiff","audio/x-aiff","application/vnd.adobe.air-application-installer-package+zip","application/vnd.dvb.ait","application/vnd.amiga.ami","application/vnd.android.package-archive","text/cache-manifest","application/x-ms-application","application/vnd.lotus-approach","application/x-freearc","application/pgp-signature","video/x-ms-asf","text/x-asm","application/vnd.accpac.simply.aso","video/x-ms-asf","application/vnd.acucorp","application/atom+xml","application/atomcat+xml","application/atomsvc+xml","application/vnd.antix.game-component","audio/basic","video/x-msvideo","image/avif","application/applixware","application/vnd.airzip.filesecure.azf","application/vnd.airzip.filesecure.azs","application/vnd.amazon.ebook","application/x-msdownload","application/x-bcpio","application/x-font-bdf","application/vnd.syncml.dm+wbxml","application/vnd.realvnc.bed","application/vnd.fujitsu.oasysprs","application/octet-stream","application/x-blorb","application/x-blorb","application/vnd.bmi","image/bmp","application/vnd.framemaker","application/vnd.previewsystems.box","application/x-bzip2","application/octet-stream","image/prs.btif","application/x-bzip","application/x-bzip2","text/x-c","application/vnd.cluetrust.cartomobile-config","application/vnd.cluetrust.cartomobile-config-pkg","application/vnd.clonk.c4group","application/vnd.clonk.c4group","application/vnd.clonk.c4group","application/vnd.clonk.c4group","application/vnd.clonk.c4group","application/vnd.ms-cab-compressed","audio/x-caf","application/vnd.tcpdump.pcap","application/vnd.curl.car","application/vnd.ms-pki.seccat","application/x-cbr","application/x-cbr","application/x-cbr","application/x-cbr","application/x-cbr","text/x-c","application/x-director","application/ccxml+xml","application/vnd.contact.cmsg","application/x-netcdf","application/vnd.mediastation.cdkey","application/cdmi-capability","application/cdmi-container","application/cdmi-domain","application/cdmi-object","application/cdmi-queue","chemical/x-cdx","application/vnd.chemdraw+xml","application/vnd.cinderella","application/pkix-cert","application/x-cfs-compressed","image/cgm","application/x-chat","application/vnd.ms-htmlhelp","application/vnd.kde.kchart","chemical/x-cif","application/vnd.anser-web-certificate-issue-initiation","application/vnd.ms-artgalry","application/vnd.claymore","application/java-vm","application/vnd.crick.clicker.keyboard","application/vnd.crick.clicker.palette","application/vnd.crick.clicker.template","application/vnd.crick.clicker.wordbank","application/vnd.crick.clicker","application/x-msclip","application/vnd.cosmocaller","chemical/x-cmdf","chemical/x-cml","application/vnd.yellowriver-custom-menu","image/x-cmx","application/vnd.rim.cod","application/x-msdownload","text/plain","application/x-cpio","text/x-c","application/mac-compactpro","application/x-mscardfile","application/pkix-crl","application/x-x509-ca-cert","application/vnd.rig.cryptonote","application/x-csh","chemical/x-csml","application/vnd.commonspace","text/css","application/x-director","text/csv","application/cu-seeme","text/vnd.curl","application/prs.cww","application/x-director","text/x-c","model/vnd.collada+xml","application/vnd.mobius.daf","text/x-dart","application/vnd.fdsn.seed","application/davmount+xml","application/docbook+xml","application/dicom","application/x-director","text/vnd.curl.dcurl","application/vnd.oma.dd2+xml","application/vnd.fujixerox.ddd","application/x-debian-package","text/plain","application/octet-stream","application/x-x509-ca-cert","application/vnd.dreamfactory","application/x-dgc-compressed","text/x-c","application/x-director","application/vnd.mobius.dis","application/octet-stream","application/octet-stream","image/vnd.djvu","image/vnd.djvu","application/x-msdownload","application/x-apple-diskimage","application/vnd.tcpdump.pcap","application/octet-stream","application/vnd.dna","application/msword","application/vnd.ms-word.document.macroenabled.12","application/vnd.openxmlformats-officedocument.wordprocessingml.document","application/msword","application/vnd.ms-word.template.macroenabled.12","application/vnd.openxmlformats-officedocument.wordprocessingml.template","application/vnd.osgi.dp","application/vnd.dpgraph","audio/vnd.dra","text/prs.lines.tag","application/dssc+der","application/x-dtbook+xml","application/xml-dtd","audio/vnd.dts","audio/vnd.dts.hd","application/octet-stream","video/vnd.dvb.file","application/x-dvi","model/vnd.dwf","image/vnd.dwg","image/vnd.dxf","application/vnd.spotfire.dxp","application/x-director","audio/vnd.nuera.ecelp4800","audio/vnd.nuera.ecelp7470","audio/vnd.nuera.ecelp9600","application/ecmascript","application/vnd.novadigm.edm","application/vnd.novadigm.edx","application/vnd.picsel","application/vnd.pg.osasli","application/octet-stream","application/x-msmetafile","message/rfc822","application/emma+xml","application/x-msmetafile","audio/vnd.digital-winds","application/vnd.ms-fontobject","application/postscript","application/epub+zip","application/vnd.eszigno3+xml","application/vnd.osgi.subsystem","application/vnd.epson.esf","application/vnd.eszigno3+xml","text/x-setext","application/x-eva","application/x-envoy","application/x-msdownload","application/exi","application/vnd.novadigm.ext","application/andrew-inset","application/vnd.ezpix-album","application/vnd.ezpix-package","text/x-fortran","video/x-f4v","text/x-fortran","text/x-fortran","image/vnd.fastbidsheet","application/vnd.adobe.formscentral.fcdt","application/vnd.isac.fcs","application/vnd.fdf","application/vnd.denovo.fcselayout-link","application/vnd.fujitsu.oasysgp","application/x-director","image/x-freehand","image/x-freehand","image/x-freehand","image/x-freehand","image/x-freehand","application/x-xfig","audio/x-flac","video/x-fli","application/vnd.micrografx.flo","video/x-flv","application/vnd.kde.kivio","text/vnd.fmi.flexstor","text/vnd.fly","application/vnd.framemaker","application/vnd.frogans.fnc","text/x-fortran","image/vnd.fpx","application/vnd.framemaker","application/vnd.fsc.weblaunch","image/vnd.fst","application/vnd.fluxtime.clip","application/vnd.anser-web-funds-transfer-initiation","video/vnd.fvt","application/vnd.adobe.fxp","application/vnd.adobe.fxp","application/vnd.fuzzysheet","application/vnd.geoplan","image/g3fax","application/vnd.geospace","application/vnd.groove-account","application/x-tads","application/rpki-ghostbusters","application/x-gca-compressed","model/vnd.gdl","application/vnd.dynageo","application/vnd.geometry-explorer","application/vnd.geogebra.file","application/vnd.geogebra.tool","application/vnd.groove-help","image/gif","application/vnd.groove-identity-message","model/gltf-binary","model/gltf+json","application/gml+xml","application/vnd.gmx","application/x-gnumeric","application/vnd.flographit","application/gpx+xml","application/vnd.grafeq","application/vnd.grafeq","application/srgs","application/x-gramps-xml","application/vnd.geometry-explorer","application/vnd.groove-injector","application/srgs+xml","application/x-font-ghostscript","application/x-gtar","application/vnd.groove-tool-message","model/vnd.gtw","text/vnd.graphviz","application/gxf","application/vnd.geonext","text/x-c","video/h261","video/h263","video/h264","application/vnd.hal+xml","application/vnd.hbci","application/x-hdf","image/heic","image/heif","text/x-c","application/winhlp","application/vnd.hp-hpgl","application/vnd.hp-hpid","application/vnd.hp-hps","application/mac-binhex40","application/vnd.kenameaapp","text/html","text/html","application/vnd.yamaha.hv-dic","application/vnd.yamaha.hv-voice","application/vnd.yamaha.hv-script","application/vnd.intergeo","application/vnd.iccprofile","x-conference/x-cooltalk","application/vnd.iccprofile","image/x-icon","text/calendar","image/ief","text/calendar","application/vnd.shana.informed.formdata","model/iges","application/vnd.igloader","application/vnd.insors.igm","model/iges","application/vnd.micrografx.igx","application/vnd.shana.informed.interchange","application/vnd.accpac.simply.imp","application/vnd.ms-ims","text/plain","application/inkml+xml","application/inkml+xml","application/x-install-instructions","application/vnd.astraea-software.iota","application/ipfix","application/vnd.shana.informed.package","application/vnd.ibm.rights-management","application/vnd.irepository.package+xml","application/x-iso9660-image","application/vnd.shana.informed.formtemplate","application/vnd.immervision-ivp","application/vnd.immervision-ivu","text/vnd.sun.j2me.app-descriptor","application/vnd.jam","application/java-archive","text/x-java-source","application/vnd.jisp","application/vnd.hp-jlyt","application/x-java-jnlp-file","application/vnd.joost.joda-archive","image/jpeg","image/jpeg","image/jpeg","video/jpm","video/jpeg","video/jpm","text/javascript","application/json","application/jsonml+json","audio/midi","application/vnd.kde.karbon","application/vnd.kde.kformula","application/vnd.kidspiration","application/vnd.google-earth.kml+xml","application/vnd.google-earth.kmz","application/vnd.kinar","application/vnd.kinar","application/vnd.kde.kontour","application/vnd.kde.kpresenter","application/vnd.kde.kpresenter","application/vnd.ds-keypoint","application/vnd.kde.kspread","application/vnd.kahootz","image/ktx","application/vnd.kahootz","application/vnd.kde.kword","application/vnd.kde.kword","application/vnd.las.las+xml","application/x-latex","application/vnd.llamagraphics.life-balance.desktop","application/vnd.llamagraphics.life-balance.exchange+xml","application/vnd.hhe.lesson-player","application/x-lzh-compressed","application/vnd.route66.link66+xml","text/plain","application/vnd.ibm.modcap","application/vnd.ibm.modcap","application/x-ms-shortcut","text/plain","application/lost+xml","application/octet-stream","application/vnd.ms-lrm","application/vnd.frogans.ltf","audio/vnd.lucent.voice","application/vnd.lotus-wordpro","application/x-lzh-compressed","application/x-msmediaview","application/x-msmediaview","video/mpeg","application/mp21","audio/mpeg","video/mpeg","audio/mpeg","audio/x-mpegurl","application/vnd.apple.mpegurl","audio/mp4","audio/mp4","video/vnd.mpegurl","video/x-m4v","application/mathematica","application/mads+xml","application/vnd.ecowin.chart","application/vnd.framemaker","text/troff","application/octet-stream","application/mathml+xml","application/mathematica","application/vnd.mobius.mbk","application/mbox","application/vnd.medcalcdata","application/vnd.mcd","text/vnd.curl.mcurl","text/markdown","text/markdown","application/x-msaccess","image/vnd.ms-modi","text/troff","model/mesh","application/metalink4+xml","application/metalink+xml","application/mets+xml","application/vnd.mfmp","application/rpki-manifest","application/vnd.osgeo.mapguide.package","application/vnd.proteus.magazine","audio/midi","audio/midi","application/x-mie","application/vnd.mif","message/rfc822","video/mj2","video/mj2","text/javascript","video/x-matroska","audio/x-matroska","video/x-matroska","video/x-matroska","application/vnd.dolby.mlp","application/vnd.chipnuts.karaoke-mmd","application/vnd.smaf","image/vnd.fujixerox.edmics-mmr","video/x-mng","application/x-msmoney","application/x-mobipocket-ebook","application/mods+xml","video/quicktime","video/x-sgi-movie","audio/mpeg","application/mp21","audio/mpeg","audio/mpeg","video/mp4","audio/mp4","application/mp4","video/mp4","application/vnd.mophun.certificate","video/mpeg","video/mpeg","video/mpeg","video/mp4","audio/mpeg","application/vnd.apple.installer+xml","application/vnd.blueice.multipass","application/vnd.mophun.application","application/vnd.ms-project","application/vnd.ms-project","application/vnd.ibm.minipay","application/vnd.mobius.mqy","application/marc","application/marcxml+xml","text/troff","application/mediaservercontrol+xml","application/vnd.fdsn.mseed","application/vnd.mseq","application/vnd.epson.msf","model/mesh","application/x-msdownload","application/vnd.mobius.msl","application/vnd.muvee.style","model/vnd.mts","application/vnd.musician","application/vnd.recordare.musicxml+xml","application/x-msmediaview","application/vnd.mfer","application/mxf","application/vnd.recordare.musicxml","application/xv+xml","application/vnd.triscape.mxs","video/vnd.mpegurl","application/vnd.nokia.n-gage.symbian.install","text/n3","application/mathematica","application/vnd.wolfram.player","application/x-netcdf","application/x-dtbncx+xml","text/x-nfo","application/vnd.nokia.n-gage.data","application/vnd.nitf","application/vnd.neurolanguage.nlu","application/vnd.enliven","application/vnd.noblenet-directory","application/vnd.noblenet-sealer","application/vnd.noblenet-web","image/vnd.net-fpx","application/x-conference","application/vnd.lotus-notes","application/vnd.nitf","application/x-nzb","application/vnd.fujitsu.oasys2","application/vnd.fujitsu.oasys3","application/vnd.fujitsu.oasys","application/x-msbinder","application/x-tgif","application/oda","application/vnd.oasis.opendocument.database","application/vnd.oasis.opendocument.chart","application/vnd.oasis.opendocument.formula","application/vnd.oasis.opendocument.formula-template","application/vnd.oasis.opendocument.graphics","application/vnd.oasis.opendocument.image","application/vnd.oasis.opendocument.text-master","application/vnd.oasis.opendocument.presentation","application/vnd.oasis.opendocument.spreadsheet","application/vnd.oasis.opendocument.text","audio/ogg","audio/ogg","video/ogg","application/ogg","application/omdoc+xml","application/onenote","application/onenote","application/onenote","application/onenote","application/oebps-package+xml","text/x-opml","application/vnd.palm","application/vnd.lotus-organizer","application/vnd.yamaha.openscoreformat","application/vnd.yamaha.openscoreformat.osfpvg+xml","application/vnd.oasis.opendocument.chart-template","application/x-font-otf","application/vnd.oasis.opendocument.graphics-template","application/vnd.oasis.opendocument.text-web","application/vnd.oasis.opendocument.image-template","application/vnd.oasis.opendocument.presentation-template","application/vnd.oasis.opendocument.spreadsheet-template","application/vnd.oasis.opendocument.text-template","application/oxps","application/vnd.openofficeorg.extension","text/x-pascal","application/pkcs10","application/x-pkcs12","application/x-pkcs7-certificates","application/pkcs7-mime","application/pkcs7-mime","application/x-pkcs7-certreqresp","application/pkcs7-signature","application/pkcs8","text/x-pascal","application/vnd.pawaafile","application/vnd.powerbuilder6","image/x-portable-bitmap","application/vnd.tcpdump.pcap","application/x-font-pcf","application/vnd.hp-pcl","application/vnd.hp-pclxl","image/x-pict","application/vnd.curl.pcurl","image/x-pcx","application/vnd.palm","application/pdf","application/x-font-type1","application/x-font-type1","application/x-font-type1","application/font-tdpfr","application/x-pkcs12","image/x-portable-graymap","application/x-chess-pgn","application/pgp-encrypted","image/x-pict","application/octet-stream","application/pkixcmp","application/pkix-pkipath","application/vnd.3gpp.pic-bw-large","application/vnd.mobius.plc","application/vnd.pocketlearn","application/pls+xml","application/vnd.ctc-posml","image/png","image/x-portable-anymap","application/vnd.macports.portpkg","application/vnd.ms-powerpoint","application/vnd.ms-powerpoint.template.macroenabled.12","application/vnd.openxmlformats-officedocument.presentationml.template","application/vnd.ms-powerpoint.addin.macroenabled.12","application/vnd.cups-ppd","image/x-portable-pixmap","application/vnd.ms-powerpoint","application/vnd.ms-powerpoint.slideshow.macroenabled.12","application/vnd.openxmlformats-officedocument.presentationml.slideshow","application/vnd.ms-powerpoint","application/vnd.ms-powerpoint.presentation.macroenabled.12","application/vnd.openxmlformats-officedocument.presentationml.presentation","application/vnd.palm","application/x-mobipocket-ebook","application/vnd.lotus-freelance","application/pics-rules","application/postscript","application/vnd.3gpp.pic-bw-small","image/vnd.adobe.photoshop","application/x-font-linux-psf","application/pskc+xml","application/vnd.pvi.ptid1","application/x-mspublisher","application/vnd.3gpp.pic-bw-var","application/vnd.3m.post-it-notes","audio/vnd.ms-playready.media.pya","video/vnd.ms-playready.media.pyv","application/vnd.epson.quickanime","application/vnd.intu.qbo","application/vnd.intu.qfx","application/vnd.publishare-delta-tree","video/quicktime","application/vnd.quark.quarkxpress","application/vnd.quark.quarkxpress","application/vnd.quark.quarkxpress","application/vnd.quark.quarkxpress","application/vnd.quark.quarkxpress","application/vnd.quark.quarkxpress","audio/x-pn-realaudio","audio/x-pn-realaudio","application/x-rar-compressed","image/x-cmu-raster","application/vnd.ipunplugged.rcprofile","application/rdf+xml","application/vnd.data-vision.rdz","application/vnd.businessobjects","application/x-dtbresource+xml","image/x-rgb","application/reginfo+xml","audio/vnd.rip","application/x-research-info-systems","application/resource-lists+xml","image/vnd.fujixerox.edmics-rlc","application/resource-lists-diff+xml","application/vnd.rn-realmedia","audio/midi","audio/x-pn-realaudio-plugin","application/vnd.jcp.javame.midlet-rms","application/vnd.rn-realmedia-vbr","application/relax-ng-compact-syntax","application/rpki-roa","text/troff","application/vnd.cloanto.rp9","application/vnd.nokia.radio-presets","application/vnd.nokia.radio-preset","application/sparql-query","application/rls-services+xml","application/rsd+xml","application/rss+xml","application/rtf","text/richtext","text/x-asm","audio/s3m","application/vnd.yamaha.smaf-audio","application/sbml+xml","application/vnd.ibm.secure-container","application/x-msschedule","application/vnd.lotus-screencam","application/scvp-cv-request","application/scvp-cv-response","text/vnd.curl.scurl","application/vnd.stardivision.draw","application/vnd.stardivision.calc","application/vnd.stardivision.impress","application/vnd.solent.sdkm+xml","application/vnd.solent.sdkm+xml","application/sdp","application/vnd.stardivision.writer","application/vnd.seemail","application/vnd.fdsn.seed","application/vnd.sema","application/vnd.semd","application/vnd.semf","application/java-serialized-object","application/set-payment-initiation","application/set-registration-initiation","application/vnd.hydrostatix.sof-data","application/vnd.spotfire.sfs","text/x-sfv","image/sgi","application/vnd.stardivision.writer-global","text/sgml","text/sgml","application/x-sh","application/x-shar","application/shf+xml","image/x-mrsid-image","application/pgp-signature","audio/silk","model/mesh","application/vnd.symbian.install","application/vnd.symbian.install","application/x-stuffit","application/x-stuffitx","application/vnd.koan","application/vnd.koan","application/vnd.koan","application/vnd.koan","application/vnd.ms-powerpoint.slide.macroenabled.12","application/vnd.openxmlformats-officedocument.presentationml.slide","application/vnd.epson.salt","application/vnd.stepmania.stepchart","application/vnd.stardivision.math","application/smil+xml","application/smil+xml","video/x-smv","application/vnd.stepmania.package","audio/basic","application/x-font-snf","application/octet-stream","application/x-pkcs7-certificates","application/vnd.yamaha.smaf-phrase","application/x-futuresplash","text/vnd.in3d.spot","application/scvp-vp-response","application/scvp-vp-request","audio/ogg","application/x-sql","application/x-wais-source","application/x-subrip","application/sru+xml","application/sparql-results+xml","application/ssdl+xml","application/vnd.kodak-descriptor","application/vnd.epson.ssf","application/ssml+xml","application/vnd.sailingtracker.track","application/vnd.sun.xml.calc.template","application/vnd.sun.xml.draw.template","application/vnd.wt.stf","application/vnd.sun.xml.impress.template","application/hyperstudio","application/vnd.ms-pki.stl","application/vnd.pg.format","application/vnd.sun.xml.writer.template","text/vnd.dvb.subtitle","application/vnd.sus-calendar","application/vnd.sus-calendar","application/x-sv4cpio","application/x-sv4crc","application/vnd.dvb.service","application/vnd.svd","image/svg+xml","image/svg+xml","application/x-director","application/x-shockwave-flash","application/vnd.aristanetworks.swi","application/vnd.sun.xml.calc","application/vnd.sun.xml.draw","application/vnd.sun.xml.writer.global","application/vnd.sun.xml.impress","application/vnd.sun.xml.math","application/vnd.sun.xml.writer","text/troff","application/x-t3vm-image","application/vnd.mynfc","application/vnd.tao.intent-module-archive","application/x-tar","application/vnd.3gpp2.tcap","application/x-tcl","application/vnd.smart.teacher","application/tei+xml","application/tei+xml","application/x-tex","application/x-texinfo","application/x-texinfo","text/plain","application/thraud+xml","application/x-tex-tfm","image/x-tga","application/vnd.ms-officetheme","image/tiff","image/tiff","application/vnd.tmobile-livetv","application/toml","application/x-bittorrent","application/vnd.groove-tool-template","application/vnd.trid.tpt","text/troff","application/vnd.trueapp","application/x-msterminal","application/timestamped-data","text/tab-separated-values","application/x-font-ttf","application/x-font-ttf","text/turtle","application/vnd.simtech-mindmapper","application/vnd.simtech-mindmapper","application/vnd.genomatix.tuxedo","application/vnd.mobius.txf","text/plain","application/x-authorware-bin","application/x-debian-package","application/vnd.ufdl","application/vnd.ufdl","application/x-glulx","application/vnd.umajin","application/vnd.unity","application/vnd.uoml+xml","text/uri-list","text/uri-list","text/uri-list","application/x-ustar","application/vnd.uiq.theme","text/x-uuencode","audio/vnd.dece.audio","application/vnd.dece.data","application/vnd.dece.data","image/vnd.dece.graphic","video/vnd.dece.hd","image/vnd.dece.graphic","video/vnd.dece.mobile","video/vnd.dece.pd","video/vnd.dece.sd","application/vnd.dece.ttml+xml","video/vnd.uvvu.mp4","video/vnd.dece.video","audio/vnd.dece.audio","application/vnd.dece.data","application/vnd.dece.data","image/vnd.dece.graphic","video/vnd.dece.hd","image/vnd.dece.graphic","video/vnd.dece.mobile","video/vnd.dece.pd","video/vnd.dece.sd","application/vnd.dece.ttml+xml","video/vnd.uvvu.mp4","video/vnd.dece.video","application/vnd.dece.unspecified","application/vnd.dece.zip","application/vnd.dece.unspecified","application/vnd.dece.zip","text/vcard","application/x-cdlink","text/x-vcard","application/vnd.groove-vcard","text/x-vcalendar","application/vnd.vcx","application/vnd.visionary","video/vnd.vivo","video/x-ms-vob","application/vnd.stardivision.writer","application/x-authorware-bin","model/vrml","application/vnd.visio","application/vnd.vsf","application/vnd.visio","application/vnd.visio","application/vnd.visio","model/vnd.vtu","application/voicexml+xml","application/x-director","application/x-doom","application/wasm","audio/x-wav","audio/x-ms-wax","image/vnd.wap.wbmp","application/vnd.criticaltools.wbs+xml","application/vnd.wap.wbxml","application/vnd.ms-works","application/vnd.ms-works","image/vnd.ms-photo","audio/webm","video/webm","application/manifest+json","image/webp","application/vnd.pmi.widget","application/widget","application/vnd.ms-works","video/x-ms-wm","audio/x-ms-wma","application/x-ms-wmd","application/x-msmetafile","text/vnd.wap.wml","application/vnd.wap.wmlc","text/vnd.wap.wmlscript","application/vnd.wap.wmlscriptc","video/x-ms-wmv","video/x-ms-wmx","application/x-ms-wmz","application/x-font-woff","font/woff2","application/vnd.wordperfect","application/vnd.ms-wpl","application/vnd.ms-works","application/vnd.wqd","application/x-mswrite","model/vrml","application/wsdl+xml","application/wspolicy+xml","application/vnd.webturbo","video/x-ms-wvx","application/x-authorware-bin","model/x3d+xml","model/x3d+binary","model/x3d+binary","model/x3d+vrml","model/x3d+vrml","model/x3d+xml","application/xaml+xml","application/x-silverlight-app","application/vnd.xara","application/x-ms-xbap","application/vnd.fujixerox.docuworks.binder","image/x-xbitmap","application/xcap-diff+xml","application/vnd.syncml.dm+xml","application/vnd.adobe.xdp+xml","application/dssc+xml","application/vnd.fujixerox.docuworks","application/xenc+xml","application/patch-ops-error+xml","application/vnd.adobe.xfdf","application/vnd.xfdl","application/xhtml+xml","application/xhtml+xml","application/xv+xml","image/vnd.xiff","application/vnd.ms-excel","application/vnd.ms-excel.addin.macroenabled.12","application/vnd.ms-excel","application/x-xliff+xml","application/vnd.ms-excel","application/vnd.ms-excel","application/vnd.ms-excel.sheet.binary.macroenabled.12","application/vnd.ms-excel.sheet.macroenabled.12","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","application/vnd.ms-excel","application/vnd.ms-excel.template.macroenabled.12","application/vnd.openxmlformats-officedocument.spreadsheetml.template","application/vnd.ms-excel","audio/xm","application/xml","application/vnd.olpc-sugar","application/xop+xml","application/x-xpinstall","application/xproc+xml","image/x-xpixmap","application/vnd.is-xpr","application/vnd.ms-xpsdocument","application/vnd.intercon.formnet","application/vnd.intercon.formnet","application/xml","application/xslt+xml","application/vnd.syncml+xml","application/xspf+xml","application/vnd.mozilla.xul+xml","application/xv+xml","application/xv+xml","image/x-xwindowdump","chemical/x-xyz","application/x-xz","application/yang","application/yin+xml","application/x-zmachine","application/x-zmachine","application/x-zmachine","application/x-zmachine","application/x-zmachine","application/x-zmachine","application/x-zmachine","application/x-zmachine","application/vnd.zzazz.deck+xml","application/zip","application/vnd.zul","application/vnd.zul","application/vnd.handheld-entertainment+xml"],A.S("bP<W,W>"))
B.ci=new A.b3([34665,"exif",40965,"interop",34853,"gps"],A.S("b3<f,W>"))
B.d2=new A.aD(2,"falseFloydSteinberg")
B.d3=new A.aD(3,"jarvisJudiceNinke")
B.d4=new A.aD(4,"stucki")
B.d5=new A.aD(5,"burkes")
B.d6=new A.aD(6,"atkinson")
B.aN=s([0,0,0],t.a)
B.ig=s([B.aN,B.aN,B.aN],t.U)
B.iq=s([0.4375,1,0],t.a)
B.ip=s([0.1875,-1,1],t.a)
B.en=s([0.3125,0,1],t.a)
B.jl=s([0.0625,1,1],t.a)
B.iX=s([B.iq,B.ip,B.en,B.jl],t.U)
B.h2=s([0.375,1,0],t.a)
B.kU=s([0.375,0,1],t.a)
B.kr=s([0.25,1,1],t.a)
B.f1=s([B.h2,B.kU,B.kr],t.U)
B.dB=s([0.14583333333333334,1,0],t.a)
B.iO=s([0.10416666666666667,2,0],t.a)
B.bX=s([0.0625,-2,1],t.a)
B.jk=s([0.10416666666666667,-1,1],t.a)
B.kl=s([0.14583333333333334,0,1],t.a)
B.hQ=s([0.10416666666666667,1,1],t.a)
B.c3=s([0.0625,2,1],t.a)
B.hS=s([0.020833333333333332,-2,2],t.a)
B.fW=s([0.0625,-1,2],t.a)
B.k0=s([0.10416666666666667,0,2],t.a)
B.k8=s([0.0625,1,2],t.a)
B.hA=s([0.020833333333333332,2,2],t.a)
B.ix=s([B.dB,B.iO,B.bX,B.jk,B.kl,B.hQ,B.c3,B.hS,B.fW,B.k0,B.k8,B.hA],t.U)
B.jJ=s([0.19047619047619047,1,0],t.a)
B.kQ=s([0.09523809523809523,2,0],t.a)
B.er=s([0.047619047619047616,-2,1],t.a)
B.fQ=s([0.09523809523809523,-1,1],t.a)
B.ko=s([0.19047619047619047,0,1],t.a)
B.hy=s([0.09523809523809523,1,1],t.a)
B.fl=s([0.047619047619047616,2,1],t.a)
B.kB=s([0.023809523809523808,-2,2],t.a)
B.ki=s([0.047619047619047616,-1,2],t.a)
B.kZ=s([0.09523809523809523,0,2],t.a)
B.fL=s([0.047619047619047616,1,2],t.a)
B.jY=s([0.023809523809523808,2,2],t.a)
B.fF=s([B.jJ,B.kQ,B.er,B.fQ,B.ko,B.hy,B.fl,B.kB,B.ki,B.kZ,B.fL,B.jY],t.U)
B.kD=s([0.25,1,0],t.a)
B.bJ=s([0.125,2,0],t.a)
B.bs=s([0.125,-1,1],t.a)
B.jf=s([0.25,0,1],t.a)
B.bY=s([0.125,1,1],t.a)
B.ky=s([B.kD,B.bJ,B.bX,B.bs,B.jf,B.bY,B.c3],t.U)
B.hP=s([0.125,1,0],t.a)
B.hh=s([0.125,0,1],t.a)
B.j4=s([0.125,0,2],t.a)
B.f0=s([B.hP,B.bJ,B.bs,B.hh,B.bY,B.j4],t.U)
B.l3=new A.b3([B.bb,B.ig,B.aG,B.iX,B.d2,B.f1,B.d3,B.ix,B.d4,B.fF,B.d5,B.ky,B.d6,B.f0],A.S("b3<aD,r<r<k>>>"))
B.d7=new A.aD(7,"bayer2x2")
B.d9=new A.aD(9,"bayer8x8")
B.j7=s([0,0.5],t.n)
B.jq=s([0.75,0.25],t.n)
B.fs=s([B.j7,B.jq],t.A)
B.hv=s([0,0.5,0.125,0.625],t.n)
B.kN=s([0.75,0.25,0.875,0.375],t.n)
B.j8=s([0.1875,0.6875,0.0625,0.5625],t.n)
B.hz=s([0.9375,0.4375,0.8125,0.3125],t.n)
B.ex=s([B.hv,B.kN,B.j8,B.hz],t.A)
B.hk=s([0,0.5,0.125,0.625,0.03125,0.53125,0.15625,0.65625],t.n)
B.fb=s([0.75,0.25,0.875,0.375,0.78125,0.28125,0.90625,0.40625],t.n)
B.dT=s([0.1875,0.6875,0.0625,0.5625,0.21875,0.71875,0.09375,0.59375],t.n)
B.f7=s([0.9375,0.4375,0.8125,0.3125,0.96875,0.46875,0.84375,0.34375],t.n)
B.hT=s([0.046875,0.546875,0.171875,0.671875,0.015625,0.515625,0.140625,0.640625],t.n)
B.eA=s([0.796875,0.296875,0.921875,0.421875,0.765625,0.265625,0.890625,0.390625],t.n)
B.k_=s([0.234375,0.734375,0.109375,0.609375,0.203125,0.703125,0.078125,0.578125],t.n)
B.kt=s([0.984375,0.484375,0.859375,0.359375,0.953125,0.453125,0.828125,0.328125],t.n)
B.fu=s([B.hk,B.fb,B.dT,B.f7,B.hT,B.eA,B.k_,B.kt],t.A)
B.cj=new A.b3([B.d7,B.fs,B.d8,B.ex,B.d9,B.fu],A.S("b3<aD,r<r<A>>>"))
B.ck=new A.b3([B.y,1,B.t,3,B.z,15,B.e,255,B.n,65535,B.P,4294967295,B.R,127,B.S,32767,B.T,2147483647,B.G,1,B.O,1,B.Q,1],A.S("b3<au,f>"))
B.ld=new A.ho(0,"none")
B.le=new A.ho(4,"paeth")
B.a6=new A.bZ(0,"invalid")
B.cq=new A.bZ(1,"pbm")
B.cr=new A.bZ(2,"pgm2")
B.aX=new A.bZ(3,"pgm5")
B.cs=new A.bZ(4,"ppm3")
B.aY=new A.bZ(5,"ppm6")
B.m7=new A.eE(0,"auto")
B.lj=new A.eE(3,"rgb4")
B.lk=new A.eE(4,"rgba4")
B.m8=new A.jl(1,"neural")
B.cx=new A.cE(0,0)
B.b_=new A.aY(0,"bilevel")
B.lt=new A.aY(1,"gray4bit")
B.lu=new A.aY(2,"gray")
B.lv=new A.aY(3,"grayAlpha")
B.lw=new A.aY(4,"palette")
B.cA=new A.aY(5,"rgb")
B.lx=new A.aY(6,"rgba")
B.ly=new A.aY(7,"yCbCrSub")
B.a7=new A.aY(8,"generic")
B.lz=new A.aY(9,"invalid")
B.lN=A.bd("fm")
B.lO=A.bd("ik")
B.lP=A.bd("iv")
B.lQ=A.bd("iw")
B.lR=A.bd("fS")
B.lS=A.bd("e2")
B.lT=A.bd("iM")
B.lU=A.bd("J")
B.lV=A.bd("jw")
B.lW=A.bd("bF")
B.lX=A.bd("jx")
B.lY=A.bd("bG")
B.lZ=new A.hM(!1)
B.m_=new A.hM(!0)
B.a8=new A.du(0,"undefined")
B.b4=new A.du(1,"lossy")
B.aA=new A.du(2,"lossless")
B.m2=new A.du(3,"animated")
B.aB=new A.dw(0,"none")
B.m3=new A.dw(1,"partial")
B.m4=new A.dw(2,"full")
B.a9=new A.dw(3,"finish")})();(function staticFields(){$.ke=null
$.aN=A.j([],A.S("t<J>"))
$.mR=null
$.mg=null
$.mf=null
$.nG=null
$.nz=null
$.nK=null
$.kB=null
$.kP=null
$.lV=null
$.kf=A.j([],A.S("t<r<J>?>"))
$.dC=null
$.fe=null
$.ff=null
$.lP=!1
$.a2=B.D
$.bf=A.n5("_config")
$.lN=null
$.n2=!1
$.q7=A.j([A.m1(),A.tG(),A.tL(),A.tM(),A.tN(),A.tO(),A.tP(),A.tQ(),A.tR(),A.tS(),A.tH(),A.tI(),A.tJ(),A.tK(),A.m1(),A.m1()],A.S("t<f(f,bF,f)>"))
$.T=null
$.mo=A.n5("_eLut")})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"tX","nO",()=>A.kK("_$dart_dartClosure"))
s($,"tW","m2",()=>A.kK("_$dart_dartClosure_dartJSInterop"))
s($,"uJ","oa",()=>A.j([new J.h4()],A.S("t<eF>")))
s($,"u7","nS",()=>A.bE(A.jv({
toString:function(){return"$receiver$"}})))
s($,"u8","nT",()=>A.bE(A.jv({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"u9","nU",()=>A.bE(A.jv(null)))
s($,"ua","nV",()=>A.bE(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"ud","nY",()=>A.bE(A.jv(void 0)))
s($,"ue","nZ",()=>A.bE(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"uc","nX",()=>A.bE(A.mZ(null)))
s($,"ub","nW",()=>A.bE(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"ug","o0",()=>A.bE(A.mZ(void 0)))
s($,"uf","o_",()=>A.bE(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"um","m4",()=>A.qf())
s($,"us","o6",()=>A.hf(4096))
s($,"uq","o4",()=>new A.ko().$0())
s($,"ur","o5",()=>new A.kn().$0())
s($,"uI","id",()=>A.i9(B.lU))
s($,"up","o3",()=>A.lJ(B.ak,B.aO,257,286,15))
s($,"uo","o2",()=>A.lJ(B.bL,B.a2,0,30,15))
s($,"un","o1",()=>A.lJ(null,B.e0,0,19,7))
s($,"tZ","nQ",()=>A.fG(B.kG))
s($,"tY","nP",()=>A.fG(B.fa))
s($,"uL","l0",()=>{var q=null,p="ISOSpeed"
return A.lf([11,A.i("ProcessingSoftware",B.l,q),254,A.i("SubfileType",B.p,1),255,A.i("OldSubfileType",B.p,1),256,A.i("ImageWidth",B.p,1),257,A.i("ImageLength",B.p,1),258,A.i("BitsPerSample",B.k,1),259,A.i("Compression",B.k,1),262,A.i("PhotometricInterpretation",B.k,1),263,A.i("Thresholding",B.k,1),264,A.i("CellWidth",B.k,1),265,A.i("CellLength",B.k,1),266,A.i("FillOrder",B.k,1),269,A.i("DocumentName",B.l,q),270,A.i("ImageDescription",B.l,q),271,A.i("Make",B.l,q),272,A.i("Model",B.l,q),273,A.i("StripOffsets",B.p,q),274,A.i("Orientation",B.k,1),277,A.i("SamplesPerPixel",B.k,1),278,A.i("RowsPerStrip",B.p,1),279,A.i("StripByteCounts",B.p,1),280,A.i("MinSampleValue",B.k,1),281,A.i("MaxSampleValue",B.k,1),282,A.i("XResolution",B.r,1),283,A.i("YResolution",B.r,1),284,A.i("PlanarConfiguration",B.k,1),285,A.i("PageName",B.l,q),286,A.i("XPosition",B.r,1),287,A.i("YPosition",B.r,1),290,A.i("GrayResponseUnit",B.k,1),291,A.i("GrayResponseCurve",B.f,q),292,A.i("T4Options",B.f,q),293,A.i("T6Options",B.f,q),296,A.i("ResolutionUnit",B.k,1),297,A.i("PageNumber",B.k,2),300,A.i("ColorResponseUnit",B.f,q),301,A.i("TransferFunction",B.k,768),305,A.i("Software",B.l,q),306,A.i("DateTime",B.l,q),315,A.i("Artist",B.l,q),316,A.i("HostComputer",B.l,q),317,A.i("Predictor",B.k,1),318,A.i("WhitePoint",B.r,2),319,A.i("PrimaryChromaticities",B.r,6),320,A.i("ColorMap",B.k,q),321,A.i("HalftoneHints",B.k,2),322,A.i("TileWidth",B.p,1),323,A.i("TileLength",B.p,1),324,A.i("TileOffsets",B.p,q),325,A.i("TileByteCounts",B.f,q),326,A.i("BadFaxLines",B.f,q),327,A.i("CleanFaxData",B.f,q),328,A.i("ConsecutiveBadFaxLines",B.f,q),332,A.i("InkSet",B.f,q),333,A.i("InkNames",B.f,q),334,A.i("NumberofInks",B.f,q),336,A.i("DotRange",B.f,q),337,A.i("TargetPrinter",B.l,q),338,A.i("ExtraSamples",B.f,q),339,A.i("SampleFormat",B.k,1),340,A.i("SMinSampleValue",B.f,q),341,A.i("SMaxSampleValue",B.f,q),342,A.i("TransferRange",B.f,q),343,A.i("ClipPath",B.f,q),512,A.i("JPEGProc",B.f,q),513,A.i("JPEGInterchangeFormat",B.f,q),514,A.i("JPEGInterchangeFormatLength",B.f,q),529,A.i("YCbCrCoefficients",B.r,3),530,A.i("YCbCrSubSampling",B.k,1),531,A.i("YCbCrPositioning",B.k,1),532,A.i("ReferenceBlackWhite",B.r,6),700,A.i("ApplicationNotes",B.k,1),18246,A.i("Rating",B.k,1),33421,A.i("CFARepeatPatternDim",B.f,q),33422,A.i("CFAPattern",B.f,q),33423,A.i("BatteryLevel",B.f,q),33432,A.i("Copyright",B.l,q),33434,A.i("ExposureTime",B.r,1),33437,A.i("FNumber",B.r,q),33723,A.i("IPTC-NAA",B.p,1),34665,A.i("ExifOffset",B.f,q),34675,A.i("InterColorProfile",B.f,q),34850,A.i("ExposureProgram",B.k,1),34852,A.i("SpectralSensitivity",B.l,q),34853,A.i("GPSOffset",B.f,q),34855,A.i(p,B.p,1),34856,A.i("OECF",B.f,q),34864,A.i("SensitivityType",B.k,1),34866,A.i("RecommendedExposureIndex",B.p,1),34867,A.i(p,B.p,1),36864,A.i("ExifVersion",B.H,q),36867,A.i("DateTimeOriginal",B.l,q),36868,A.i("DateTimeDigitized",B.l,q),36880,A.i("OffsetTime",B.l,q),36881,A.i("OffsetTimeOriginal",B.l,q),36882,A.i("OffsetTimeDigitized",B.l,q),37121,A.i("ComponentsConfiguration",B.H,q),37122,A.i("CompressedBitsPerPixel",B.f,q),37377,A.i("ShutterSpeedValue",B.f,q),37378,A.i("ApertureValue",B.f,q),37379,A.i("BrightnessValue",B.f,q),37380,A.i("ExposureBiasValue",B.f,q),37381,A.i("MaxApertureValue",B.f,q),37382,A.i("SubjectDistance",B.f,q),37383,A.i("MeteringMode",B.f,q),37384,A.i("LightSource",B.f,q),37385,A.i("Flash",B.f,q),37386,A.i("FocalLength",B.f,q),37396,A.i("SubjectArea",B.f,q),37500,A.i("MakerNote",B.H,q),37510,A.i("UserComment",B.H,q),37520,A.i("SubSecTime",B.f,q),37521,A.i("SubSecTimeOriginal",B.f,q),37522,A.i("SubSecTimeDigitized",B.f,q),40091,A.i("XPTitle",B.f,q),40092,A.i("XPComment",B.f,q),40093,A.i("XPAuthor",B.f,q),40094,A.i("XPKeywords",B.f,q),40095,A.i("XPSubject",B.f,q),40960,A.i("FlashPixVersion",B.f,q),40961,A.i("ColorSpace",B.k,1),40962,A.i("ExifImageWidth",B.k,1),40963,A.i("ExifImageLength",B.k,1),40964,A.i("RelatedSoundFile",B.f,q),40965,A.i("InteroperabilityOffset",B.f,q),41483,A.i("FlashEnergy",B.f,q),41484,A.i("SpatialFrequencyResponse",B.f,q),41486,A.i("FocalPlaneXResolution",B.f,q),41487,A.i("FocalPlaneYResolution",B.f,q),41488,A.i("FocalPlaneResolutionUnit",B.f,q),41492,A.i("SubjectLocation",B.f,q),41493,A.i("ExposureIndex",B.f,q),41495,A.i("SensingMethod",B.f,q),41728,A.i("FileSource",B.f,q),41729,A.i("SceneType",B.f,q),41730,A.i("CVAPattern",B.f,q),41985,A.i("CustomRendered",B.f,q),41986,A.i("ExposureMode",B.f,q),41987,A.i("WhiteBalance",B.f,q),41988,A.i("DigitalZoomRatio",B.f,q),41989,A.i("FocalLengthIn35mmFilm",B.f,q),41990,A.i("SceneCaptureType",B.f,q),41991,A.i("GainControl",B.f,q),41992,A.i("Contrast",B.f,q),41993,A.i("Saturation",B.f,q),41994,A.i("Sharpness",B.f,q),41995,A.i("DeviceSettingDescription",B.f,q),41996,A.i("SubjectDistanceRange",B.f,q),42016,A.i("ImageUniqueID",B.f,q),42032,A.i("CameraOwnerName",B.l,q),42033,A.i("BodySerialNumber",B.l,q),42034,A.i("LensSpecification",B.f,q),42035,A.i("LensMake",B.l,q),42036,A.i("LensModel",B.l,q),42037,A.i("LensSerialNumber",B.l,q),42240,A.i("Gamma",B.r,1),50341,A.i("PrintIM",B.f,q),59932,A.i("Padding",B.f,q),59933,A.i("OffsetSchema",B.f,q),65e3,A.i("OwnerName",B.l,q),65001,A.i("SerialNumber",B.l,q)],t.p,A.S("fy"))})
s($,"u_","ia",()=>A.p7(A.j([0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63],t.t)))
r($,"uh","ib",()=>A.hf(511))
r($,"ui","kX",()=>A.hf(511))
r($,"uk","kY",()=>A.mM(2041))
r($,"ul","kZ",()=>A.mM(225))
r($,"uj","aH",()=>A.hf(766))
s($,"u4","nR",()=>A.mB(0,0,0))
s($,"uE","as",()=>A.hf(1))
s($,"uF","aB",()=>A.oO(B.d.gB($.as()),0,null))
s($,"ux","ar",()=>A.p3(1))
s($,"uy","aA",()=>J.ob(B.A.gB($.ar()),0,null))
s($,"uz","O",()=>A.p5(1))
s($,"uB","a9",()=>J.oc(B.o.gB($.O()),0,null))
s($,"uA","c8",()=>A.oF(B.o.gB($.O())))
s($,"uv","ic",()=>A.p0(1))
s($,"uw","l_",()=>A.n_(B.Z.gB($.ic()),0))
s($,"ut","m5",()=>A.oY(1))
s($,"uu","o7",()=>A.n_(B.a4.gB($.m5()),0))
s($,"uC","m6",()=>A.pt(1))
s($,"uD","o8",()=>{var q=$.m6()
return A.oG(q.gB(q))})
s($,"u0","kW",()=>new A.j0(A.j([],A.S("t<ec>"))))
r($,"u1","m3",()=>new A.j1())
s($,"uH","o9",()=>{var q=t.N
return new A.j5(A.I(q,q),A.j([],A.S("t<u2>")))})})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.cj,SharedArrayBuffer:A.cj,ArrayBufferView:A.ej,DataView:A.he,Float32Array:A.ee,Float64Array:A.ef,Int16Array:A.eg,Int32Array:A.eh,Int8Array:A.ei,Uint16Array:A.ek,Uint32Array:A.el,Uint8ClampedArray:A.em,CanvasPixelArray:A.em,Uint8Array:A.ck})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.aj.$nativeSuperclassTag="ArrayBufferView"
A.f2.$nativeSuperclassTag="ArrayBufferView"
A.f3.$nativeSuperclassTag="ArrayBufferView"
A.bX.$nativeSuperclassTag="ArrayBufferView"
A.f4.$nativeSuperclassTag="ArrayBufferView"
A.f5.$nativeSuperclassTag="ArrayBufferView"
A.aK.$nativeSuperclassTag="ArrayBufferView"})()
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
var s=A.t9
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=native_executor.js.map
