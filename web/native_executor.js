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
if(a[b]!==s){A.nC(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.j(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.nt(b)
return new s(c,this)}:function(){if(s===null)s=A.nt(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.nt(a).prototype
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
nA(a,b,c,d){return{i:a,p:b,e:c,x:d}},
ml(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.nw==null){A.vS()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.f(A.oK("Return interceptor for "+A.y(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.lI
if(o==null)o=$.lI=A.mk(n)
p=q[o]}if(p!=null)return p
p=A.vY(a)
if(p!=null)return p
if(typeof a=="function")return B.dD
s=Object.getPrototypeOf(a)
if(s==null)return B.co
if(s===Object.prototype)return B.co
if(typeof q=="function"){o=$.lI
if(o==null)o=$.lI=A.mk(n)
Object.defineProperty(q,o,{value:B.b3,enumerable:false,writable:true,configurable:true})
return B.b3}return B.b3},
on(a,b){if(a<0||a>4294967295)throw A.f(A.aw(a,0,4294967295,"length",null))
return J.oo(new Array(a),b)},
af(a,b){if(a<0||a>4294967295)throw A.f(A.aw(a,0,4294967295,"length",null))
return J.oo(new Array(a),b)},
hJ(a,b){if(a<0)throw A.f(A.aX("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.m("q<0>"))},
bL(a,b){if(a<0)throw A.f(A.aX("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.m("q<0>"))},
oo(a,b){var s=A.j(a,b.m("q<0>"))
s.$flags=1
return s},
r_(a,b){var s=t.bP
return J.qj(s.a(a),s.a(b))},
op(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
r0(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.op(r))break;++b}return b},
r1(a,b){var s,r,q
for(s=a.length;b>0;b=r){r=b-1
if(!(r<s))return A.a(a,r)
q=a.charCodeAt(r)
if(q!==32&&q!==13&&!J.op(q))break}return b},
d2(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.dw.prototype
return J.eF.prototype}if(typeof a=="string")return J.cz.prototype
if(a==null)return J.eE.prototype
if(typeof a=="boolean")return J.hK.prototype
if(Array.isArray(a))return J.q.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bM.prototype
if(typeof a=="symbol")return J.dz.prototype
if(typeof a=="bigint")return J.dy.prototype
return a}if(a instanceof A.K)return a
return J.ml(a)},
ae(a){if(typeof a=="string")return J.cz.prototype
if(a==null)return a
if(Array.isArray(a))return J.q.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bM.prototype
if(typeof a=="symbol")return J.dz.prototype
if(typeof a=="bigint")return J.dy.prototype
return a}if(a instanceof A.K)return a
return J.ml(a)},
aV(a){if(a==null)return a
if(Array.isArray(a))return J.q.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bM.prototype
if(typeof a=="symbol")return J.dz.prototype
if(typeof a=="bigint")return J.dy.prototype
return a}if(a instanceof A.K)return a
return J.ml(a)},
vN(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.dw.prototype
return J.eF.prototype}if(a==null)return a
if(!(a instanceof A.K))return J.cT.prototype
return a},
vO(a){if(typeof a=="number")return J.dx.prototype
if(typeof a=="string")return J.cz.prototype
if(a==null)return a
if(!(a instanceof A.K))return J.cT.prototype
return a},
bp(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bM.prototype
if(typeof a=="symbol")return J.dz.prototype
if(typeof a=="bigint")return J.dy.prototype
return a}if(a instanceof A.K)return a
return J.ml(a)},
cm(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.d2(a).Z(a,b)},
d(a,b){if(typeof b==="number")if(Array.isArray(a)||A.vX(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.aV(a).l(a,b)},
a_(a,b,c){return J.aV(a).i(a,b,c)},
qf(a,b,c){return J.bp(a).hg(a,b,c)},
nP(a,b,c){return J.bp(a).hh(a,b,c)},
qg(a,b,c){return J.bp(a).hi(a,b,c)},
qh(a,b,c){return J.bp(a).hj(a,b,c)},
mA(a,b,c){return J.bp(a).hk(a,b,c)},
qi(a){return J.bp(a).hl(a)},
nQ(a,b,c){return J.bp(a).dw(a,b,c)},
a1(a,b,c){return J.bp(a).hm(a,b,c)},
G(a){return J.bp(a).hn(a)},
C(a,b,c){return J.bp(a).cS(a,b,c)},
qj(a,b){return J.vO(a).bO(a,b)},
nR(a,b){return J.aV(a).bA(a,b)},
e6(a,b,c,d){return J.aV(a).a8(a,b,c,d)},
aN(a){return J.d2(a).gM(a)},
fX(a){return J.aV(a).gI(a)},
bC(a){return J.ae(a).gu(a)},
qk(a){return J.bp(a).gcA(a)},
ql(a){return J.d2(a).gaW(a)},
mB(a){if(typeof a==="number")return a>0?1:a<0?-1:a
return J.vN(a).geC(a)},
qm(a,b,c){return J.aV(a).cj(a,b,c)},
qn(a,b){return J.aV(a).dJ(a,b)},
mC(a,b,c){return J.aV(a).cl(a,b,c)},
qo(a,b){return J.aV(a).hS(a,b)},
e7(a){return J.d2(a).D(a)},
qp(a,b){return J.aV(a).hY(a,b)},
hx:function hx(){},
hK:function hK(){},
eE:function eE(){},
eG:function eG(){},
c7:function c7(){},
hY:function hY(){},
cT:function cT(){},
bM:function bM(){},
dy:function dy(){},
dz:function dz(){},
q:function q(a){this.$ti=a},
hI:function hI(){},
jJ:function jJ(a){this.$ti=a},
e8:function e8(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
dx:function dx(){},
dw:function dw(){},
eF:function eF(){},
cz:function cz(){}},A={mL:function mL(){},
r4(a){return new A.dA("Field '"+a+"' has been assigned during initialization.")},
jR(a){return new A.dA("Field '"+a+"' has not been initialized.")},
r5(a){return new A.dA("Field '"+a+"' has already been initialized.")},
bP(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
kB(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
fU(a,b,c){return a},
nx(a){var s,r
for(s=$.aU.length,r=0;r<s;++r)if(a===$.aU[r])return!0
return!1},
dN(a,b,c,d){A.dL(b,"start")
if(c!=null){A.dL(c,"end")
if(b>c)A.a3(A.aw(b,0,c,"start",null))}return new A.fi(a,b,c,d.m("fi<0>"))},
rb(a,b,c,d){if(t.gt.b(a))return new A.cp(a,b,c.m("@<0>").am(d).m("cp<1,2>"))
return new A.bN(a,b,c.m("@<0>").am(d).m("bN<1,2>"))},
dv(){return new A.dM("No element")},
om(){return new A.dM("Too few elements")},
dA:function dA(a){this.a=a},
ah:function ah(a){this.a=a},
kz:function kz(){},
B:function B(){},
av:function av(){},
fi:function fi(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
cC:function cC(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
bN:function bN(a,b,c){this.a=a
this.b=b
this.$ti=c},
cp:function cp(a,b,c){this.a=a
this.b=b
this.$ti=c},
eM:function eM(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
bi:function bi(a,b,c){this.a=a
this.b=b
this.$ti=c},
cW:function cW(a,b,c){this.a=a
this.b=b
this.$ti=c},
fw:function fw(a,b,c){this.a=a
this.b=b
this.$ti=c},
cq:function cq(a){this.$ti=a},
ec:function ec(a){this.$ti=a},
cX:function cX(a,b){this.a=a
this.$ti=b},
fx:function fx(a,b){this.a=a
this.$ti=b},
aB:function aB(){},
bR:function bR(){},
dO:function dO(){},
qA(){throw A.f(A.bn("Cannot modify constant Set"))},
pN(a){var s=A.pM(a)
if(s!=null)return s
return"minified:"+a},
vX(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.dX.b(a)},
y(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.e7(a)
return s},
fa(a){var s,r=$.oA
if(r==null)r=$.oA=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
rG(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
if(3>=r.length)return A.a(r,3)
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
i1(a){var s,r,q,p
if(a instanceof A.K)return A.aF(A.aW(a),null)
s=J.d2(a)
if(s===B.dA||s===B.dE||t.cx.b(a)){r=B.b6(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.aF(A.aW(a),null)},
oB(a){var s,r,q
if(a==null||typeof a=="number"||A.m0(a))return J.e7(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.aA)return a.D(0)
if(a instanceof A.cf)return a.fW(!0)
s=$.qe()
for(r=0;r<1;++r){q=s[r].mO(a)
if(q!=null)return q}return"Instance of '"+A.i1(a)+"'"},
oz(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
rH(a){var s,r,q,p=A.j([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.L)(a),++r){q=a[r]
if(!A.iQ(q))throw A.f(A.bZ(q))
if(q<=65535)B.c.C(p,q)
else if(q<=1114111){B.c.C(p,55296+(B.a.j(q-65536,10)&1023))
B.c.C(p,56320+(q&1023))}else throw A.f(A.bZ(q))}return A.oz(p)},
oC(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.iQ(q))throw A.f(A.bZ(q))
if(q<0)throw A.f(A.bZ(q))
if(q>65535)return A.rH(a)}return A.oz(a)},
rI(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
dF(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.j(s,10)|55296)>>>0,s&1023|56320)}throw A.f(A.aw(a,0,1114111,null,null))},
dE(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
rF(a){var s=A.dE(a).getUTCFullYear()+0
return s},
rD(a){var s=A.dE(a).getUTCMonth()+1
return s},
rz(a){var s=A.dE(a).getUTCDate()+0
return s},
rA(a){var s=A.dE(a).getUTCHours()+0
return s},
rC(a){var s=A.dE(a).getUTCMinutes()+0
return s},
rE(a){var s=A.dE(a).getUTCSeconds()+0
return s},
rB(a){var s=A.dE(a).getUTCMilliseconds()+0
return s},
ry(a){var s=a.$thrownJsError
if(s==null)return null
return A.c0(s)},
oD(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.a9(a,s)
a.$thrownJsError=s
s.stack=b.D(0)}},
iU(a){throw A.f(A.bZ(a))},
a(a,b){if(a==null)J.bC(a)
throw A.f(A.mf(a,b))},
mf(a,b){var s,r="index"
if(!A.iQ(b))return new A.bc(!0,b,r,null)
s=A.n(J.bC(a))
if(b<0||b>=s)return A.jE(b,s,a,null,r)
return A.n7(b,r)},
vD(a,b,c){if(a<0||a>c)return A.aw(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.aw(b,a,c,"end",null)
return new A.bc(!0,b,"end",null)},
bZ(a){return new A.bc(!0,a,null,null)},
f(a){return A.a9(a,new Error())},
a9(a,b){var s
if(a==null)a=new A.bx()
b.dartException=a
s=A.wc
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
wc(){return J.e7(this.dartException)},
a3(a,b){throw A.a9(a,b==null?new Error():b)},
b(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.a3(A.uu(a,b,c),s)},
uu(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.gs.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.fk("'"+s+"': Cannot "+o+" "+l+k+n)},
L(a){throw A.f(A.aI(a))},
bQ(a){var s,r,q,p,o,n
a=A.w5(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.j([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.kN(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
kO(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
oI(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
mN(a,b){var s=b==null,r=s?null:b.method
return new A.hO(a,r,s?null:b.receiver)},
br(a){var s
if(a==null)return new A.k4(a)
if(a instanceof A.ed){s=a.a
return A.ck(a,s==null?A.fR(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.ck(a,a.dartException)
return A.vl(a)},
ck(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
vl(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.j(r,16)&8191)===10)switch(q){case 438:return A.ck(a,A.mN(A.y(s)+" (Error "+q+")",null))
case 445:case 5007:A.y(s)
return A.ck(a,new A.eX())}}if(a instanceof TypeError){p=$.pS()
o=$.pT()
n=$.pU()
m=$.pV()
l=$.pY()
k=$.pZ()
j=$.pX()
$.pW()
i=$.q0()
h=$.q_()
g=p.bI(s)
if(g!=null)return A.ck(a,A.mN(A.bA(s),g))
else{g=o.bI(s)
if(g!=null){g.method="call"
return A.ck(a,A.mN(A.bA(s),g))}else if(n.bI(s)!=null||m.bI(s)!=null||l.bI(s)!=null||k.bI(s)!=null||j.bI(s)!=null||m.bI(s)!=null||i.bI(s)!=null||h.bI(s)!=null){A.bA(s)
return A.ck(a,new A.eX())}}return A.ck(a,new A.io(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.ff()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.ck(a,new A.bc(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.ff()
return a},
c0(a){var s
if(a instanceof A.ed)return a.b
if(a==null)return new A.fL(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.fL(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
iX(a){if(a==null)return J.aN(a)
if(typeof a=="object")return A.fa(a)
return J.aN(a)},
vz(a){if(typeof a=="number")return B.b.gM(a)
if(a instanceof A.iK)return A.fa(a)
if(a instanceof A.cf)return a.gM(a)
return A.iX(a)},
pw(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.i(0,a[s],a[r])}return b},
uK(a,b,c,d,e,f){t.Z.a(a)
switch(A.n(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.f(A.o3("Unsupported number of arguments for wrapped closure"))},
e3(a,b){var s=a.$identity
if(!!s)return s
s=A.vA(a,b)
a.$identity=s
return s},
vA(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.uK)},
qz(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.ig().constructor.prototype):Object.create(new A.d4(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.nZ(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.qv(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.nZ(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
qv(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.f("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.qs)}throw A.f("Error in functionType of tearoff")},
qw(a,b,c,d){var s=A.nY
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
nZ(a,b,c,d){if(c)return A.qy(a,b,d)
return A.qw(b.length,d,a,b)},
qx(a,b,c,d){var s=A.nY,r=A.qt
switch(b?-1:a){case 0:throw A.f(new A.ie("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
qy(a,b,c){var s,r
if($.nW==null)$.nW=A.nV("interceptor")
if($.nX==null)$.nX=A.nV("receiver")
s=b.length
r=A.qx(s,c,a,b)
return r},
nt(a){return A.qz(a)},
qs(a,b){return A.fP(v.typeUniverse,A.aW(a.a),b)},
nY(a){return a.a},
qt(a){return a.b},
nV(a){var s,r,q,p=new A.d4("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.f(A.aX("Field name "+a+" not found.",null))},
mk(a){return v.getIsolateTag(a)},
xN(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
vY(a){var s,r,q,p,o,n=A.bA($.pA.$1(a)),m=$.mg[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.mp[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.p8($.pn.$2(a,n))
if(q!=null){m=$.mg[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.mp[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.mr(s)
$.mg[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.mp[n]=s
return s}if(p==="-"){o=A.mr(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.pH(a,s)
if(p==="*")throw A.f(A.oK(n))
if(v.leafTags[n]===true){o=A.mr(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.pH(a,s)},
pH(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.nA(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
mr(a){return J.nA(a,!1,null,!!a.$iaR)},
w_(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.mr(s)
else return J.nA(s,c,null,null)},
vS(){if(!0===$.nw)return
$.nw=!0
A.vT()},
vT(){var s,r,q,p,o,n,m,l
$.mg=Object.create(null)
$.mp=Object.create(null)
A.vR()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.pJ.$1(o)
if(n!=null){m=A.w_(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
vR(){var s,r,q,p,o,n,m=B.cX()
m=A.e0(B.cY,A.e0(B.cZ,A.e0(B.b7,A.e0(B.b7,A.e0(B.d_,A.e0(B.d0,A.e0(B.d1(B.b6),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.pA=new A.mm(p)
$.pn=new A.mn(o)
$.pJ=new A.mo(n)},
e0(a,b){return a(b)||b},
vC(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
w5(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
d1:function d1(a,b){this.a=a
this.b=b},
dh:function dh(){},
di:function di(a,b,c){this.a=a
this.b=b
this.$ti=c},
fC:function fC(a,b){this.a=a
this.$ti=b},
cZ:function cZ(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
aO:function aO(a,b){this.a=a
this.$ti=b},
eb:function eb(){},
el:function el(a,b){this.a=a
this.$ti=b},
hw:function hw(){},
du:function du(a,b){this.a=a
this.$ti=b},
fe:function fe(){},
kN:function kN(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
eX:function eX(){},
hO:function hO(a,b,c){this.a=a
this.b=b
this.c=c},
io:function io(a){this.a=a},
k4:function k4(a){this.a=a},
ed:function ed(a,b){this.a=a
this.b=b},
fL:function fL(a){this.a=a
this.b=null},
aA:function aA(){},
h3:function h3(){},
h4:function h4(){},
ih:function ih(){},
ig:function ig(){},
d4:function d4(a,b){this.a=a
this.b=b},
ie:function ie(a){this.a=a},
bh:function bh(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
jV:function jV(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
cB:function cB(a,b){this.a=a
this.$ti=b},
Y:function Y(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
jW:function jW(a,b){this.a=a
this.$ti=b},
aq:function aq(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
eH:function eH(a,b){this.a=a
this.$ti=b},
eI:function eI(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
cA:function cA(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
mm:function mm(a){this.a=a},
mn:function mn(a){this.a=a},
mo:function mo(a){this.a=a},
cf:function cf(){},
dV:function dV(){},
c(a){throw A.a9(A.jR(a),new Error())},
A(a){throw A.a9(A.r5(a),new Error())},
nC(a){throw A.a9(A.r4(a),new Error())},
oP(a){var s=new A.lt(a)
return s.b=s},
lt:function lt(a){this.a=a
this.b=null},
aE(a,b,c){},
p(a){var s,r,q
if(t.iy.b(a))return a
s=J.ae(a)
r=A.I(s.gu(a),null,!1,t.z)
for(q=0;q<s.gu(a);++q)B.c.i(r,q,s.l(a,q))
return r},
rf(a,b,c){A.aE(a,b,c)
return c==null?new DataView(a,b):new DataView(a,b,c)},
rg(a){return new Float32Array(a)},
rh(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Float32Array(a,b,c)},
ri(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Int16Array(a,b,c)},
ou(a){return new Int32Array(a)},
rj(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Int32Array(a,b,c)},
ov(a){return new Int8Array(a)},
rk(a,b,c){A.aE(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
rl(a){return new Uint16Array(a)},
rm(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
rn(a){return new Uint32Array(a)},
ro(a,b,c){A.aE(a,b,c)
if(c==null)c=B.a.V(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
eW(a){return new Uint8Array(a)},
rp(a){return new Uint8Array(A.p(a))},
rq(a,b,c){A.aE(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bY(a,b,c){if(a>>>0!==a||a>=c)throw A.f(A.mf(b,a))},
iO(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.f(A.vD(a,b,c))
if(b==null)return c
return b},
cD:function cD(){},
eS:function eS(){},
iL:function iL(a){this.a=a},
hS:function hS(){},
aj:function aj(){},
c9:function c9(){},
aS:function aS(){},
eN:function eN(){},
eO:function eO(){},
eP:function eP(){},
eQ:function eQ(){},
eR:function eR(){},
eT:function eT(){},
eU:function eU(){},
eV:function eV(){},
cE:function cE(){},
fF:function fF(){},
fG:function fG(){},
fH:function fH(){},
fI:function fI(){},
n8(a,b){var s=b.c
return s==null?b.c=A.fN(a,"ct",[b.x]):s},
oG(a){var s=a.w
if(s===6||s===7)return A.oG(a.x)
return s===11||s===12},
rP(a){return a.as},
T(a){return A.lT(v.typeUniverse,a,!1)},
vV(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.ch(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
ch(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.ch(a1,s,a3,a4)
if(r===s)return a2
return A.oY(a1,r,!0)
case 7:s=a2.x
r=A.ch(a1,s,a3,a4)
if(r===s)return a2
return A.oX(a1,r,!0)
case 8:q=a2.y
p=A.dZ(a1,q,a3,a4)
if(p===q)return a2
return A.fN(a1,a2.x,p)
case 9:o=a2.x
n=A.ch(a1,o,a3,a4)
m=a2.y
l=A.dZ(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.nj(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.dZ(a1,j,a3,a4)
if(i===j)return a2
return A.oZ(a1,k,i)
case 11:h=a2.x
g=A.ch(a1,h,a3,a4)
f=a2.y
e=A.vh(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.oW(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.dZ(a1,d,a3,a4)
o=a2.x
n=A.ch(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.nk(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.f(A.h_("Attempted to substitute unexpected RTI kind "+a0))}},
dZ(a,b,c,d){var s,r,q,p,o=b.length,n=A.lW(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.ch(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
vi(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.lW(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.ch(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
vh(a,b,c,d){var s,r=b.a,q=A.dZ(a,r,c,d),p=b.b,o=A.dZ(a,p,c,d),n=b.c,m=A.vi(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.iC()
s.a=q
s.b=o
s.c=m
return s},
j(a,b){a[v.arrayRti]=b
return a},
m9(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.vQ(s)
return a.$S()}return null},
vU(a,b){var s
if(A.oG(b))if(a instanceof A.aA){s=A.m9(a)
if(s!=null)return s}return A.aW(a)},
aW(a){if(a instanceof A.K)return A.m(a)
if(Array.isArray(a))return A.ak(a)
return A.np(J.d2(a))},
ak(a){var s=a[v.arrayRti],r=t.dG
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
m(a){var s=a.$ti
return s!=null?s:A.np(a)},
np(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.uG(a,s)},
uG(a,b){var s=a instanceof A.aA?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.ua(v.typeUniverse,s.name)
b.$ccache=r
return r},
vQ(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.lT(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
vP(a){return A.c_(A.m(a))},
nv(a){var s=A.m9(a)
return A.c_(s==null?A.aW(a):s)},
ns(a){var s
if(a instanceof A.cf)return A.vH(a.$r,a.fk())
s=a instanceof A.aA?A.m9(a):null
if(s!=null)return s
if(t.aJ.b(a))return J.ql(a).a
if(Array.isArray(a))return A.ak(a)
return A.aW(a)},
c_(a){var s=a.r
return s==null?a.r=new A.iK(a):s},
vH(a,b){var s,r,q=b,p=q.length
if(p===0)return t.aK
if(0>=p)return A.a(q,0)
s=A.fP(v.typeUniverse,A.ns(q[0]),"@<0>")
for(r=1;r<p;++r){if(!(r<q.length))return A.a(q,r)
s=A.p0(v.typeUniverse,s,A.ns(q[r]))}return A.fP(v.typeUniverse,s,a)},
bq(a){return A.c_(A.lT(v.typeUniverse,a,!1))},
uF(a){var s=this
s.b=A.vf(s)
return s.b(a)},
vf(a){var s,r,q,p,o
if(a===t.K)return A.uQ
if(A.d3(a))return A.uU
s=a.w
if(s===6)return A.uC
if(s===1)return A.pe
if(s===7)return A.uL
r=A.ve(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.d3)){a.f="$i"+q
if(q==="r")return A.uO
if(a===t.m)return A.uN
return A.uT}}else if(s===10){p=A.vC(a.x,a.y)
o=p==null?A.pe:p
return o==null?A.fR(o):o}return A.uA},
ve(a){if(a.w===8){if(a===t.p)return A.iQ
if(a===t.V||a===t.q)return A.uP
if(a===t.N)return A.uS
if(a===t.y)return A.m0}return null},
uE(a){var s=this,r=A.uz
if(A.d3(s))r=A.uj
else if(s===t.K)r=A.fR
else if(A.e5(s)){r=A.uB
if(s===t.I)r=A.uh
else if(s===t.jv)r=A.p8
else if(s===t.fU)r=A.uf
else if(s===t.jh)r=A.p7
else if(s===t.jX)r=A.ug
else if(s===t.mU)r=A.ui}else if(s===t.p)r=A.n
else if(s===t.N)r=A.bA
else if(s===t.y)r=A.p6
else if(s===t.q)r=A.nl
else if(s===t.V)r=A.iN
else if(s===t.m)r=A.bz
s.a=r
return s.a(a)},
uA(a){var s=this
if(a==null)return A.e5(s)
return A.pC(v.typeUniverse,A.vU(a,s),s)},
uC(a){if(a==null)return!0
return this.x.b(a)},
uT(a){var s,r=this
if(a==null)return A.e5(r)
s=r.f
if(a instanceof A.K)return!!a[s]
return!!J.d2(a)[s]},
uO(a){var s,r=this
if(a==null)return A.e5(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.K)return!!a[s]
return!!J.d2(a)[s]},
uN(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.K)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
pd(a){if(typeof a=="object"){if(a instanceof A.K)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
uz(a){var s=this
if(a==null){if(A.e5(s))return a}else if(s.b(a))return a
throw A.a9(A.pa(a,s),new Error())},
uB(a){var s=this
if(a==null||s.b(a))return a
throw A.a9(A.pa(a,s),new Error())},
pa(a,b){return new A.dX("TypeError: "+A.oQ(a,A.aF(b,null)))},
vw(a,b,c,d){if(A.pC(v.typeUniverse,a,b))return a
throw A.a9(A.u2("The type argument '"+A.aF(a,null)+"' is not a subtype of the type variable bound '"+A.aF(b,null)+"' of type variable '"+c+"' in '"+d+"'."),new Error())},
oQ(a,b){return A.jf(a)+": type '"+A.aF(A.ns(a),null)+"' is not a subtype of type '"+b+"'"},
u2(a){return new A.dX("TypeError: "+a)},
b9(a,b){return new A.dX("TypeError: "+A.oQ(a,b))},
uL(a){var s=this
return s.x.b(a)||A.n8(v.typeUniverse,s).b(a)},
uQ(a){return a!=null},
fR(a){if(a!=null)return a
throw A.a9(A.b9(a,"Object"),new Error())},
uU(a){return!0},
uj(a){return a},
pe(a){return!1},
m0(a){return!0===a||!1===a},
p6(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a9(A.b9(a,"bool"),new Error())},
uf(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a9(A.b9(a,"bool?"),new Error())},
iN(a){if(typeof a=="number")return a
throw A.a9(A.b9(a,"double"),new Error())},
ug(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a9(A.b9(a,"double?"),new Error())},
iQ(a){return typeof a=="number"&&Math.floor(a)===a},
n(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a9(A.b9(a,"int"),new Error())},
uh(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a9(A.b9(a,"int?"),new Error())},
uP(a){return typeof a=="number"},
nl(a){if(typeof a=="number")return a
throw A.a9(A.b9(a,"num"),new Error())},
p7(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a9(A.b9(a,"num?"),new Error())},
uS(a){return typeof a=="string"},
bA(a){if(typeof a=="string")return a
throw A.a9(A.b9(a,"String"),new Error())},
p8(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a9(A.b9(a,"String?"),new Error())},
bz(a){if(A.pd(a))return a
throw A.a9(A.b9(a,"JSObject"),new Error())},
ui(a){if(a==null)return a
if(A.pd(a))return a
throw A.a9(A.b9(a,"JSObject?"),new Error())},
pi(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.aF(a[q],b)
return s},
v0(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.pi(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.aF(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
pb(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
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
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.aF(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.aF(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.aF(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.aF(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.aF(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
aF(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.aF(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.aF(a.x,b)+">"
if(l===8){p=A.vk(a.x)
o=a.y
return o.length>0?p+("<"+A.pi(o,b)+">"):p}if(l===10)return A.v0(a,b)
if(l===11)return A.pb(a,b,null)
if(l===12)return A.pb(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
vk(a){var s=A.pM(a)
if(s!=null)return s
return"minified:"+a},
ub(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
ua(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.lT(a,b,!1)
else if(typeof m=="number"){s=m
r=A.fO(a,5,"#")
q=A.lW(s)
for(p=0;p<s;++p)q[p]=r
o=A.fN(a,b,q)
n[b]=o
return o}else return m},
u9(a,b){return A.p2(a.tR,b)},
u8(a,b){return A.p2(a.eT,b)},
lT(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.p_(a,null,b,!1)
r.set(b,s)
return s},
fP(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.p_(a,b,c,!0)
q.set(c,r)
return r},
p0(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.nj(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
p_(a,b,c,d){return A.u_(A.tU(a,b,c,d))},
cg(a,b){b.a=A.uE
b.b=A.uF
return b},
fO(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.bm(null,null)
s.w=b
s.as=c
r=A.cg(a,s)
a.eC.set(c,r)
return r},
oY(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.u6(a,b,r,c)
a.eC.set(r,s)
return s},
u6(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.d3(b))if(!(b===t.b||b===t.v))if(s!==6)r=s===7&&A.e5(b.x)
if(r)return b
else if(s===1)return t.b}q=new A.bm(null,null)
q.w=6
q.x=b
q.as=c
return A.cg(a,q)},
oX(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.u4(a,b,r,c)
a.eC.set(r,s)
return s},
u4(a,b,c,d){var s,r
if(d){s=b.w
if(A.d3(b)||b===t.K)return b
else if(s===1)return A.fN(a,"ct",[b])
else if(b===t.b||b===t.v)return t.gK}r=new A.bm(null,null)
r.w=7
r.x=b
r.as=c
return A.cg(a,r)},
u7(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.bm(null,null)
s.w=13
s.x=b
s.as=q
r=A.cg(a,s)
a.eC.set(q,r)
return r},
fM(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
u3(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
fN(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.fM(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.bm(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.cg(a,r)
a.eC.set(p,q)
return q},
nj(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.fM(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.bm(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.cg(a,o)
a.eC.set(q,n)
return n},
oZ(a,b,c){var s,r,q="+"+(b+"("+A.fM(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.bm(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.cg(a,s)
a.eC.set(q,r)
return r},
oW(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.fM(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.fM(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.u3(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.bm(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.cg(a,p)
a.eC.set(r,o)
return o},
nk(a,b,c,d){var s,r=b.as+("<"+A.fM(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.u5(a,b,c,r,d)
a.eC.set(r,s)
return s},
u5(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.lW(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.ch(a,b,r,0)
m=A.dZ(a,c,r,0)
return A.nk(a,n,m,c!==m)}}l=new A.bm(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.cg(a,l)},
tU(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
u_(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.tW(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.oU(a,r,l,k,!1)
else if(q===46)r=A.oU(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.d0(a.u,a.e,k.pop()))
break
case 94:k.push(A.u7(a.u,k.pop()))
break
case 35:k.push(A.fO(a.u,5,"#"))
break
case 64:k.push(A.fO(a.u,2,"@"))
break
case 126:k.push(A.fO(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.tY(a,k)
break
case 38:A.tX(a,k)
break
case 63:p=a.u
k.push(A.oY(p,A.d0(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.oX(p,A.d0(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.tV(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.oV(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.u0(a.u,a.e,o)
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
return A.d0(a.u,a.e,m)},
tW(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
oU(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.ub(s,o.x)[p]
if(n==null)A.a3('No "'+p+'" in "'+A.rP(o)+'"')
d.push(A.fP(s,o,n))}else d.push(p)
return m},
tY(a,b){var s,r=a.u,q=A.oT(a,b),p=b.pop()
if(typeof p=="string")b.push(A.fN(r,p,q))
else{s=A.d0(r,a.e,p)
switch(s.w){case 11:b.push(A.nk(r,s,q,a.n))
break
default:b.push(A.nj(r,s,q))
break}}},
tV(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.oT(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.d0(p,a.e,o)
q=new A.iC()
q.a=s
q.b=n
q.c=m
b.push(A.oW(p,r,q))
return
case-4:b.push(A.oZ(p,b.pop(),s))
return
default:throw A.f(A.h_("Unexpected state under `()`: "+A.y(o)))}},
tX(a,b){var s=b.pop()
if(0===s){b.push(A.fO(a.u,1,"0&"))
return}if(1===s){b.push(A.fO(a.u,4,"1&"))
return}throw A.f(A.h_("Unexpected extended operation "+A.y(s)))},
oT(a,b){var s=b.splice(a.p)
A.oV(a.u,a.e,s)
a.p=b.pop()
return s},
d0(a,b,c){if(typeof c=="string")return A.fN(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.tZ(a,b,c)}else return c},
oV(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.d0(a,b,c[s])},
u0(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.d0(a,b,c[s])},
tZ(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.f(A.h_("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.f(A.h_("Bad index "+c+" for "+b.D(0)))},
pC(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.ad(a,b,null,c,null)
r.set(c,s)}return s},
ad(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.d3(d))return!0
s=b.w
if(s===4)return!0
if(A.d3(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.ad(a,c[b.x],c,d,e))return!0
q=d.w
p=t.b
if(b===p||b===t.v){if(q===7)return A.ad(a,b,c,d.x,e)
return d===p||d===t.v||q===6}if(d===t.K){if(s===7)return A.ad(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.ad(a,b.x,c,d,e))return!1
return A.ad(a,A.n8(a,b),c,d,e)}if(s===6)return A.ad(a,p,c,d,e)&&A.ad(a,b.x,c,d,e)
if(q===7){if(A.ad(a,b,c,d.x,e))return!0
return A.ad(a,b,c,A.n8(a,d),e)}if(q===6)return A.ad(a,b,c,p,e)||A.ad(a,b,c,d.x,e)
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
if(!A.ad(a,j,c,i,e)||!A.ad(a,i,e,j,c))return!1}return A.pc(a,b.x,c,d.x,e)}if(q===11){if(b===t.dY)return!0
if(p)return!1
return A.pc(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.uM(a,b,c,d,e)}if(o&&q===10)return A.uR(a,b,c,d,e)
return!1},
pc(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.ad(a3,a4.x,a5,a6.x,a7))return!1
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
if(!A.ad(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.ad(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.ad(a3,k[h],a7,g,a5))return!1}f=s.c
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
if(!A.ad(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
uM(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.fP(a,b,r[o])
return A.p5(a,p,null,c,d.y,e)}return A.p5(a,b.y,null,c,d.y,e)},
p5(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.ad(a,b[s],d,e[s],f))return!1
return!0},
uR(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.ad(a,r[s],c,q[s],e))return!1
return!0},
e5(a){var s=a.w,r=!0
if(!(a===t.b||a===t.v))if(!A.d3(a))if(s!==6)r=s===7&&A.e5(a.x)
return r},
d3(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
p2(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
lW(a){return a>0?new Array(a):v.typeUniverse.sEA},
bm:function bm(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
iC:function iC(){this.c=this.b=this.a=null},
iK:function iK(a){this.a=a},
iA:function iA(){},
dX:function dX(a){this.a=a},
tO(){var s,r,q
if(self.scheduleImmediate!=null)return A.vs()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.e3(new A.lq(s),1)).observe(r,{childList:true})
return new A.lp(s,r,q)}else if(self.setImmediate!=null)return A.vt()
return A.vu()},
tP(a){self.scheduleImmediate(A.e3(new A.lr(t.M.a(a)),0))},
tQ(a){self.setImmediate(A.e3(new A.ls(t.M.a(a)),0))},
tR(a){t.M.a(a)
A.u1(0,a)},
u1(a,b){var s=new A.lP()
s.iJ(a,b)
return s},
uX(a){return new A.iw(new A.ag($.a6,a.m("ag<0>")),a.m("iw<0>"))},
um(a,b){a.$2(0,null)
b.b=!0
return b.a},
xF(a,b){A.un(a,b)},
ul(a,b){b.ei(a)},
uk(a,b){b.ej(A.br(a),A.c0(a))},
un(a,b){var s,r,q=new A.lY(b),p=new A.lZ(b)
if(a instanceof A.ag)a.fV(q,p,t.z)
else{s=t.z
if(a instanceof A.ag)a.hT(q,p,s)
else{r=new A.ag($.a6,t.c)
r.a=8
r.c=a
r.fV(q,p,s)}}},
vn(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.a6.hO(new A.m7(s),t.w,t.p,t.z)},
mE(a){var s
if(t.C.b(a)){s=a.gcF()
if(s!=null)return s}return B.ag},
uH(a,b){if($.a6===B.G)return null
return null},
uI(a,b){if($.a6!==B.G)A.uH(a,b)
if(b==null)if(t.C.b(a)){b=a.gcF()
if(b==null){A.oD(a,B.ag)
b=B.ag}}else b=B.ag
else if(t.C.b(a))A.oD(a,b)
return new A.aY(a,b)},
nd(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t.c;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.rQ()
b.dM(new A.aY(new A.bc(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.fG(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.dr()
b.da(o.a)
A.dS(b,p)
return}b.a^=2
A.iR(null,null,b.b,t.M.a(new A.lz(o,b)))},
dS(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.u,r=t.F;;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.nr(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.dS(d.a,c)
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
A.nr(j.a,j.b)
return}g=$.a6
if(g!==h)$.a6=h
else g=null
c=c.c
if((c&15)===8)new A.lD(q,d,n).$0()
else if(o){if((c&1)!==0)new A.lC(q,j).$0()}else if((c&2)!==0)new A.lB(d,q).$0()
if(g!=null)$.a6=g
c=q.c
if(c instanceof A.ag){p=q.a.$ti
p=p.m("ct<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.ds(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.nd(c,f,!0)
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
v1(a,b){var s
if(t.Y.b(a))return b.hO(a,t.z,t.K,t.l)
s=t.W
if(s.b(a))return s.a(a)
throw A.f(A.mD(a,"onError",u.c))},
uZ(){var s,r
for(s=$.dY;s!=null;s=$.dY){$.fT=null
r=s.b
$.dY=r
if(r==null)$.fS=null
s.a.$0()}},
vg(){$.nq=!0
try{A.uZ()}finally{$.fT=null
$.nq=!1
if($.dY!=null)$.nL().$1(A.po())}},
pj(a){var s=new A.ix(a),r=$.fS
if(r==null){$.dY=$.fS=s
if(!$.nq)$.nL().$1(A.po())}else $.fS=r.b=s},
vd(a){var s,r,q,p=$.dY
if(p==null){A.pj(a)
$.fT=$.fS
return}s=new A.ix(a)
r=$.fT
if(r==null){s.b=p
$.dY=$.fT=s}else{q=r.b
s.b=q
$.fT=r.b=s
if(q==null)$.fS=s}},
x3(a,b){A.fU(a,"stream",t.K)
return new A.iH(b.m("iH<0>"))},
nr(a,b){A.vd(new A.m3(a,b))},
ph(a,b,c,d,e){var s,r=$.a6
if(r===c)return d.$0()
$.a6=c
s=r
try{r=d.$0()
return r}finally{$.a6=s}},
v9(a,b,c,d,e,f,g){var s,r=$.a6
if(r===c)return d.$1(e)
$.a6=c
s=r
try{r=d.$1(e)
return r}finally{$.a6=s}},
v8(a,b,c,d,e,f,g,h,i){var s,r=$.a6
if(r===c)return d.$2(e,f)
$.a6=c
s=r
try{r=d.$2(e,f)
return r}finally{$.a6=s}},
iR(a,b,c,d){t.M.a(d)
if(B.G!==c){d=c.lN(d)
d=d}A.pj(d)},
lq:function lq(a){this.a=a},
lp:function lp(a,b,c){this.a=a
this.b=b
this.c=c},
lr:function lr(a){this.a=a},
ls:function ls(a){this.a=a},
lP:function lP(){},
lQ:function lQ(a,b){this.a=a
this.b=b},
iw:function iw(a,b){this.a=a
this.b=!1
this.$ti=b},
lY:function lY(a){this.a=a},
lZ:function lZ(a){this.a=a},
m7:function m7(a){this.a=a},
aY:function aY(a,b){this.a=a
this.b=b},
iy:function iy(){},
fy:function fy(a,b){this.a=a
this.$ti=b},
cY:function cY(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
ag:function ag(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
lw:function lw(a,b){this.a=a
this.b=b},
lA:function lA(a,b){this.a=a
this.b=b},
lz:function lz(a,b){this.a=a
this.b=b},
ly:function ly(a,b){this.a=a
this.b=b},
lx:function lx(a,b){this.a=a
this.b=b},
lD:function lD(a,b,c){this.a=a
this.b=b
this.c=c},
lE:function lE(a,b){this.a=a
this.b=b},
lF:function lF(a){this.a=a},
lC:function lC(a,b){this.a=a
this.b=b},
lB:function lB(a,b){this.a=a
this.b=b},
ix:function ix(a){this.a=a
this.b=null},
iH:function iH(a){this.$ti=a},
fQ:function fQ(){},
iG:function iG(){},
lN:function lN(a,b){this.a=a
this.b=b},
m3:function m3(a,b){this.a=a
this.b=b},
oR(a,b){var s=a[b]
return s===a?null:s},
nf(a,b,c){if(c==null)a[b]=a
else a[b]=c},
ne(){var s=Object.create(null)
A.nf(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
r6(a,b){return new A.bh(a.m("@<0>").am(b).m("bh<1,2>"))},
mO(a,b,c){return b.m("@<0>").am(c).m("jU<1,2>").a(A.pw(a,new A.bh(b.m("@<0>").am(c).m("bh<1,2>"))))},
J(a,b){return new A.bh(a.m("@<0>").am(b).m("bh<1,2>"))},
r7(a){return new A.d_(a.m("d_<0>"))},
mP(a){return new A.d_(a.m("d_<0>"))},
nh(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
eJ(a,b,c){var s=A.r6(b,c)
a.bH(0,new A.jX(s,b,c))
return s},
r8(a,b){var s=A.r7(b)
s.cf(0,a)
return s},
mQ(a){var s,r
if(A.nx(a))return"{...}"
s=new A.fg("")
try{r={}
B.c.C($.aU,a)
s.a+="{"
r.a=!0
a.bH(0,new A.k0(r,s))
s.a+="}"}finally{if(0>=$.aU.length)return A.a($.aU,-1)
$.aU.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
r9(a){return 8},
ra(a){var s
a=(a<<1>>>0)-1
for(;;a=s){s=(a&a-1)>>>0
if(s===0)return a}},
fz:function fz(){},
dT:function dT(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
fA:function fA(a,b){this.a=a
this.$ti=b},
fB:function fB(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
d_:function d_(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
iE:function iE(a){this.a=a
this.b=null},
fD:function fD(a,b,c){var _=this
_.a=a
_.b=b
_.d=_.c=null
_.$ti=c},
jX:function jX(a,b,c){this.a=a
this.b=b
this.c=c},
H:function H(){},
ar:function ar(){},
k0:function k0(a,b){this.a=a
this.b=b},
eK:function eK(a,b){var _=this
_.a=a
_.d=_.c=_.b=0
_.$ti=b},
fE:function fE(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.$ti=e},
cd:function cd(){},
fK:function fK(){},
ud(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.q8()
else s=new Uint8Array(o)
for(r=0;r<o;++r){q=b+r
if(!(q<a.length))return A.a(a,q)
p=a[q]
if((p&255)!==p)p=255
s[r]=p}return s},
uc(a,b,c,d){var s=a?$.q7():$.q6()
if(s==null)return null
if(0===c&&d===b.length)return A.p1(s,b)
return A.p1(s,b.subarray(c,d))},
p1(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
ue(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
lV:function lV(){},
lU:function lU(){},
lS:function lS(){},
lR:function lR(){},
d5:function d5(){},
h9:function h9(){},
hb:function hb(){},
hP:function hP(){},
jT:function jT(){},
jS:function jS(a){this.a=a},
ip:function ip(){},
iq:function iq(a){this.a=a},
iM:function iM(a){this.a=a
this.b=16
this.c=0},
vW(a){var s=A.rG(a,null)
if(s!=null)return s
throw A.f(A.mI(a,null,null))},
qD(a,b){a=A.a9(a,new Error())
if(a==null)a=A.fR(a)
a.stack=b.D(0)
throw a},
I(a,b,c,d){var s,r=c?J.hJ(a,d):J.on(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
dB(a,b,c){var s,r,q=A.j([],c.m("q<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.L)(a),++r)B.c.C(q,c.a(a[r]))
if(b)return q
q.$flags=1
return q},
t(a,b){var s,r
if(Array.isArray(a))return A.j(a.slice(0),b.m("q<0>"))
s=A.j([],b.m("q<0>"))
for(r=J.fX(a);r.E();)B.c.C(s,r.gO())
return s},
os(a,b,c){var s,r=J.hJ(a,c)
for(s=0;s<a;++s)B.c.i(r,s,b.$1(s))
return r},
fh(a,b,c){var s,r,q,p,o
A.dL(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.f(A.aw(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.oC(b>0||c<o?p.slice(b,c):p)}if(t.hD.b(a))return A.rR(a,b,c)
if(r)a=J.qo(a,c)
if(b>0)a=J.qn(a,b)
s=A.t(a,t.p)
return A.oC(s)},
rR(a,b,c){var s=a.length
if(b>=s)return""
return A.rI(a,b,c==null||c>s?s:c)},
oH(a,b,c){var s=J.fX(b)
if(!s.E())return a
if(c.length===0){do a+=A.y(s.gO())
while(s.E())}else{a+=A.y(s.gO())
while(s.E())a=a+c+A.y(s.gO())}return a},
rQ(){return A.c0(new Error())},
qB(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
o1(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
ha(a){if(a>=10)return""+a
return"0"+a},
jf(a){if(typeof a=="number"||A.m0(a)||a==null)return J.e7(a)
if(typeof a=="string")return JSON.stringify(a)
return A.oB(a)},
qE(a,b){A.fU(a,"error",t.K)
A.fU(b,"stackTrace",t.l)
A.qD(a,b)},
h_(a){return new A.fZ(a)},
aX(a,b){return new A.bc(!1,null,b,a)},
mD(a,b,c){return new A.bc(!0,a,b,c)},
rO(a){var s=null
return new A.dK(s,s,!1,s,s,a)},
n7(a,b){return new A.dK(null,null,!0,a,b,"Value not in range")},
aw(a,b,c,d,e){return new A.dK(b,c,!0,a,d,"Invalid value")},
bl(a,b,c){if(0>a||a>c)throw A.f(A.aw(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.f(A.aw(b,a,c,"end",null))
return b}return c},
dL(a,b){if(a<0)throw A.f(A.aw(a,0,null,b,null))
return a},
jE(a,b,c,d,e){return new A.hu(b,!0,a,e,"Index out of range")},
qX(a,b,c){if(0>a||a>=b)throw A.f(A.jE(a,b,c,null,"index"))
return a},
bn(a){return new A.fk(a)},
oK(a){return new A.im(a)},
kA(a){return new A.dM(a)},
aI(a){return new A.h7(a)},
o3(a){return new A.lv(a)},
mI(a,b,c){return new A.ej(a,b,c)},
qZ(a,b,c){var s,r
if(A.nx(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.j([],t.s)
B.c.C($.aU,a)
try{A.uV(a,s)}finally{if(0>=$.aU.length)return A.a($.aU,-1)
$.aU.pop()}r=A.oH(b,t.e7.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
jI(a,b,c){var s,r
if(A.nx(a))return b+"..."+c
s=new A.fg(b)
B.c.C($.aU,a)
try{r=s
r.a=A.oH(r.a,a,", ")}finally{if(0>=$.aU.length)return A.a($.aU,-1)
$.aU.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
uV(a,b){var s,r,q,p,o,n,m,l=a.gI(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.E())return
s=A.y(l.gO())
B.c.C(b,s)
k+=s.length+2;++j}if(!l.E()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gO();++j
if(!l.E()){if(j<=4){B.c.C(b,A.y(p))
return}r=A.y(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gO();++j
for(;l.E();p=o,o=n){n=l.gO();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2;--j}B.c.C(b,"...")
return}}q=A.y(p)
r=A.y(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.c.C(b,m)
B.c.C(b,q)
B.c.C(b,r)},
k5(a,b,c,d){var s
if(B.F===c){s=J.aN(a)
b=J.aN(b)
return A.kB(A.bP(A.bP($.j0(),s),b))}if(B.F===d){s=J.aN(a)
b=J.aN(b)
c=J.aN(c)
return A.kB(A.bP(A.bP(A.bP($.j0(),s),b),c))}s=J.aN(a)
b=J.aN(b)
c=J.aN(c)
d=J.aN(d)
d=A.kB(A.bP(A.bP(A.bP(A.bP($.j0(),s),b),c),d))
return d},
o(a){var s,r,q=$.j0()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.L)(a),++r)q=A.bP(q,J.aN(a[r]))
return A.kB(q)},
co:function co(a,b,c){this.a=a
this.b=b
this.c=c},
lu:function lu(){},
Z:function Z(){},
fZ:function fZ(a){this.a=a},
bx:function bx(){},
bc:function bc(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dK:function dK(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
hu:function hu(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
fk:function fk(a){this.a=a},
im:function im(a){this.a=a},
dM:function dM(a){this.a=a},
h7:function h7(a){this.a=a},
hU:function hU(){},
ff:function ff(){},
lv:function lv(a){this.a=a},
ej:function ej(a,b,c){this.a=a
this.b=b
this.c=c},
e:function e(){},
c8:function c8(a,b,c){this.a=a
this.b=b
this.$ti=c},
as:function as(){},
K:function K(){},
iI:function iI(){},
fg:function fg(a){this.a=a},
hd:function hd(a,b){this.a=a
this.$ti=b},
k3:function k3(a){this.a=a},
us(a,b,c){t.Z.a(a)
if(A.n(c)>=1)return a.$1(b)
return a.$0()},
pg(a){return a==null||A.m0(a)||typeof a=="number"||typeof a=="string"||t.jx.b(a)||t.D.b(a)||t.nn.b(a)||t.m6.b(a)||t.hM.b(a)||t.k.b(a)||t.Q.b(a)||t.pk.b(a)||t.kI.b(a)||t.lo.b(a)||t.fW.b(a)},
ny(a){if(A.pg(a))return a
return new A.mq(new A.dT(t.mp)).$1(a)},
w3(a,b){var s=new A.ag($.a6,b.m("ag<0>")),r=new A.fy(s,b.m("fy<0>"))
a.then(A.e3(new A.ms(r,b),1),A.e3(new A.mt(r),1))
return s},
pf(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
pt(a){if(A.pf(a))return a
return new A.me(new A.dT(t.mp)).$1(a)},
mq:function mq(a){this.a=a},
ms:function ms(a,b){this.a=a
this.b=b},
mt:function mt(a){this.a=a},
me:function me(a){this.a=a},
hl(a){var s=new A.jt()
s.iq(a)
return s},
jt:function jt(){this.a=$
this.b=0
this.c=2147483647},
ew:function ew(a,b){this.a=a
this.b=b},
ev:function ev(a,b,c){var _=this
_.a=a
_.b=b
_.c=null
_.e=_.d=0
_.f=c},
dW:function dW(a,b){this.a=a
this.b=b},
lo:function lo(){},
lX:function lX(){},
qC(a,b,c,d){var s=A.ng(),r=A.ng(),q=A.ng(),p=new Uint16Array(16),o=new Uint32Array(573),n=new Uint8Array(573)
s=new A.jc(a,c,s,r,q,p,o,n)
s.kj(b,d)
s.jG(B.ad)
return s},
o2(a,b,c,d){var s,r=b*2,q=a.length
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
ng(){return new A.lH()},
tS(a,b,c){var s,r,q,p,o,n,m,l=new Uint16Array(16)
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
n=A.tT(n,m)
a.$flags&2&&A.b(a)
if(!(o<q))return A.a(a,o)
a[o]=n}},
tT(a,b){var s,r=0
do{s=A.aL(a,1)
r=(r|a&1)<<1>>>0
if(--b,b>0){a=s
continue}else break}while(!0)
return A.aL(r,1)},
oS(a){var s
if(a<256){if(!(a>=0))return A.a(B.al,a)
s=B.al[a]}else{s=256+A.aL(a,7)
if(!(s<512))return A.a(B.al,s)
s=B.al[s]}return s},
ni(a,b,c,d,e){return new A.lO(a,b,c,d,e)},
aL(a,b){if(a>=0)return B.a.aJ(a,b)
else return B.a.aJ(a,b)+B.a.S(2,(~b>>>0)+65536&65535)},
dR:function dR(a,b){this.a=a
this.b=b},
jc:function jc(a,b,c,d,e,f,g,h){var _=this
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
_.bk=_.aZ=_.bS=_.ci=_.bG=_.aV=_.bF=_.y2=_.y1=_.xr=$},
b8:function b8(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
lH:function lH(){this.c=this.b=this.a=$},
lO:function lO(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jF:function jF(a,b){var _=this
_.a=a
_.b=null
_.c=b
_.d=!1
_.f=_.e=0},
bb(a){return new A.fY(a,null,null)},
fY:function fY(a,b,c){this.a=a
this.b=b
this.c=c},
e9:function e9(a,b){this.a=a
this.b=b},
oj(a){return new A.ex(new A.iz(a,0,new Uint8Array(65536),B.T),0,null,B.T)},
ok(a,b,c){return new A.ex(a.b,a.c+b,c,a.a)},
ex:function ex(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.e=0
_.a=d},
iz:function iz(a,b,c,d){var _=this
_.b=a
_.c=b
_.d=c
_.r=_.f=_.e=0
_.w=!1
_.a=d},
hv(a,b,c,d){var s,r,q,p,o=new A.ey(b)
if(d==null)d=0
if(d<0)d=0
else{s=a.length
if(d>s)d=s}r=a.length-d
if(c==null)c=r
if(c<0||c>r)c=r
q=t.D.b(a)?a:new Uint8Array(A.p(a))
p=J.C(B.d.gq(q),q.byteOffset+d,c)
o.b=p
o.d=p.length
return o},
ey:function ey(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
ez:function ez(){},
rr(a){return new A.hW(new Uint8Array(32768),a)},
hW:function hW(a,b){this.b=0
this.c=a
this.a=b},
eY:function eY(){},
nS(a,b,c){var s,r,q,p,o,n,m
if(b<1||b>9||c<1||c>9)throw A.f(new A.j2("BlurHash components must be between 1 and 9."))
s=a.aS(B.e)
r=J.bL(c,t.fh)
for(q=t.O,p=0;p<c;++p)r[p]=A.I(b,new A.bD(0,0,0),!1,q)
for(o=0;o<c;++o)for(q=o===0,n=0;n<b;++n){m=n===0&&q?1:2
if(!(o<r.length))return A.a(r,o)
B.c.i(r[o],n,A.v_(s,n,o,m))}q=A.uw(r)
if(0>=r.length)return A.a(r,0)
return new A.j1(q)},
uw(a){var s,r,q,p,o,n,m,l=a.length
if(0>=l)return A.a(a,0)
s=a[0].length
r=A.I(s*l,new A.bD(0,0,0),!1,t.O)
for(q=0,p=0;p<l;++p)for(o=0;o<s;++o,q=n){n=q+1
if(!(p<a.length))return A.a(a,p)
m=a[p]
if(!(o<m.length))return A.a(m,o)
B.c.i(r,q,m[o])}return A.ux(r,s,l)},
ux(a,b,c){var s,r,q,p,o,n,m,l,k=B.c.ghC(a),j=A.dN(a,1,null,A.ak(a).c).mK(0),i=A.iT(b-1+(c-1)*9,1)
if(j.length!==0){s=A.ak(j)
r=Math.max(0,Math.min(82,B.b.b3(new A.bi(j,s.m("D(1)").a(A.vv()),s.m("bi<1,D>")).mE(0,B.cV)*166-0.5)))
q=(r+1)/166
i+=A.iT(r,1)}else{i+=A.iT(0,1)
q=1}i+=A.iT((A.nz(k.a)<<16>>>0)+(A.nz(k.b)<<8>>>0)+A.nz(k.c),4)
for(s=j.length,p=0;p<j.length;j.length===s||(0,A.L)(j),++p,i=l){o=j[p]
n=o.a/q
m=o.b/q
l=o.c/q
l=i+A.iT(B.b.b3(Math.max(0,Math.min(18,Math.pow(Math.abs(n),0.5)*J.mB(n)*9+9.5)))*19*19+B.b.b3(Math.max(0,Math.min(18,Math.pow(Math.abs(m),0.5)*J.mB(m)*9+9.5)))*19+B.b.b3(Math.max(0,Math.min(18,Math.pow(Math.abs(l),0.5)*J.mB(l)*9+9.5))),2)}return i.charCodeAt(0)==0?i:i},
uY(a){t.O.a(a)
return Math.max(Math.abs(a.a),Math.max(Math.abs(a.b),Math.abs(a.c)))},
v_(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=null,i=0,h=0,g=0
if(a.gad()>=3)for(s=a.a,s=s.gI(s),r=3.141592653589793*c,q=3.141592653589793*b;s.E();){p=s.gO()
o=p.gb6()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gb_()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
l=d*n*Math.cos(r*o/m)
i+=l*A.mu(A.n(p.gt()))
h+=l*A.mu(A.n(p.gA()))
g+=l*A.mu(A.n(p.gB()))}else for(s=a.a,s=s.gI(s),r=3.141592653589793*c,q=3.141592653589793*b;s.E();){p=s.gO()
o=p.gb6()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gb_()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
m=d*n*Math.cos(r*o/m)*A.mu(A.n(p.gt()))
i+=m
h+=m
g+=m}k=1/(a.gN()*a.gJ())
return new A.bD(i*k,h*k,g*k)},
j1:function j1(a){this.a=a},
j2:function j2(a){this.a=a},
mu(a){var s=a/255
if(s<=0.04045)return s/12.92
return Math.pow((s+0.055)/1.055,2.4)},
nz(a){var s=B.b.F(a,0,1)
if(s<=0.0031308)return B.b.h(s*12.92*255+0.5)
return B.b.h((1.055*Math.pow(s,0.4166666666666667)-0.055)*255+0.5)},
bD:function bD(a,b,c){this.a=a
this.b=b
this.c=c},
ja:function ja(a,b){this.a=a
this.b=b},
W:function W(a){this.a=-1
this.b=a},
d6:function d6(a){this.a=a},
d7:function d7(a){this.a=a},
d8:function d8(a){this.a=a},
d9:function d9(a){this.a=a},
da:function da(a){this.a=a},
db:function db(a){this.a=a},
dc:function dc(a,b){this.a=a
this.b=b},
dd:function dd(a){this.a=a},
de:function de(a,b){this.a=a
this.b=b},
df:function df(a){this.a=a},
dg:function dg(a,b){this.a=a
this.b=b},
o_(a,b,c,d){var s=new A.cn(new Uint8Array(4))
s.ik(a,b,c,d)
return s},
bd:function bd(a){this.a=a},
h5:function h5(a){this.a=a},
cn:function cn(a){this.a=a},
ea:function ea(a){this.a=a},
h8:function h8(a){this.a=a},
e4(a,b,c){var s
if(b===c)return a
switch(b.a){case 0:if(a===0)s=0
else{s=B.cn.l(0,c)
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
case 1:return B.a.j(A.n(a),1)
case 2:return a
case 3:return a*17
case 4:return a*4369
case 5:return a*286331153
case 6:return a*8
case 7:return a*2184
case 8:return a*143165576
case 9:case 10:case 11:return a/3}break
case 3:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.n(a),6)
case 2:return B.a.j(A.n(a),4)
case 3:return a
case 4:return a*257
case 5:return a*16843009
case 6:return B.a.j(A.n(a),1)
case 7:return a*128
case 8:return a*8421504
case 9:case 10:case 11:return a/255}break
case 4:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.n(a),14)
case 2:return B.a.j(A.n(a),12)
case 3:return B.a.j(A.n(a),8)
case 4:return a
case 5:return A.n(a)<<8>>>0
case 6:return B.a.j(A.n(a),9)
case 7:return B.a.j(A.n(a),1)
case 8:return a*524296
case 9:case 10:case 11:return a/65535}break
case 5:switch(c.a){case 0:return a===0?0:1
case 1:return B.a.j(A.n(a),30)
case 2:return B.a.j(A.n(a),28)
case 3:return B.a.j(A.n(a),24)
case 4:return B.a.j(A.n(a),16)
case 5:return a
case 6:return B.a.j(A.n(a),25)
case 7:return B.a.j(A.n(a),17)
case 8:return B.a.j(A.n(a),1)
case 9:case 10:case 11:return a/4294967295}break
case 6:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.n(a),5)
case 2:return a<=0?0:B.a.j(A.n(a),3)
case 3:return a<=0?0:A.n(a)<<1>>>0
case 4:return a<=0?0:A.n(a)*516
case 5:return a<=0?0:A.n(a)*33818640
case 6:return a
case 7:return a*258
case 8:return a*16909320
case 9:case 10:case 11:return a/127}break
case 7:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.n(a),15)
case 2:return a<=0?0:B.a.j(A.n(a),11)
case 3:return a<=0?0:B.a.j(A.n(a),7)
case 4:return a<=0?0:A.n(a)<<1>>>0
case 5:return a<=0?0:A.n(a)*131076
case 6:return B.a.j(A.n(a),8)
case 7:return a
case 8:return A.n(a)*65538
case 9:case 10:case 11:return a/32767}break
case 8:switch(c.a){case 0:return a===0?0:1
case 1:return a<=0?0:B.a.j(A.n(a),29)
case 2:return a<=0?0:B.a.j(A.n(a),27)
case 3:return a<=0?0:B.a.j(A.n(a),23)
case 4:return a<=0?0:B.a.j(A.n(a),16)
case 5:return a<=0?0:A.n(a)<<1>>>0
case 6:return B.a.j(A.n(a),24)
case 7:return B.a.j(A.n(a),16)
case 8:return a
case 9:case 10:case 11:return a/2147483647}break
case 9:case 10:case 11:switch(c.a){case 0:return a===0?0:1
case 1:return B.b.h(B.b.F(a,0,1)*3)
case 2:return B.b.h(B.b.F(a,0,1)*15)
case 3:return B.b.h(B.b.F(a,0,1)*255)
case 4:return B.b.h(B.b.F(a,0,1)*65535)
case 5:return B.b.h(B.b.F(a,0,1)*4294967295)
case 6:return B.b.h(a<0?B.b.F(a,-1,1)*128:B.b.F(a,-1,1)*127)
case 7:return B.b.h(a<0?B.b.F(a,-1,1)*32768:B.b.F(a,-1,1)*32767)
case 8:return B.b.h(a<0?B.b.F(a,-1,1)*2147483648:B.b.F(a,-1,1)*2147483647)
case 9:case 10:case 11:return a}break}},
au:function au(a,b){this.a=a
this.b=b},
ek:function ek(a,b){this.a=a
this.b=b},
h0:function h0(a,b){this.a=a
this.b=b},
ee(a){var s,r=new A.bE(A.J(t.N,t.P))
r.ir(a)
s=a.b
if(s!=null)r.b=new Uint8Array(A.p(s))
return r},
mF(a){var s=new A.bE(A.J(t.N,t.P))
s.bV(a)
return s},
bE:function bE(a){this.b=null
this.c=0
this.a=a},
iB:function iB(a,b){this.a=a
this.b=b},
i(a,b,c){return new A.hc(a,b)},
hc:function hc(a,b){this.a=a
this.b=b},
b_:function b_(a){this.a=a},
jy:function jy(a){this.a=a},
o9(a){var s=new A.aP(A.J(t.p,t.r),new A.b_(A.J(t.N,t.P)))
s.ht(a)
return s},
aP:function aP(a,b){this.a=a
this.b=b},
jz:function jz(a){this.a=a},
jA:function jA(a){this.a=a},
qT(a){var s=new Uint16Array(1)
s[0]=a
return new A.bK(s)},
og(a,b){var s=new A.bK(new Uint16Array(b))
s.iw(a,b)
return s},
jB(a){var s=new Uint32Array(1)
s[0]=a
return new A.b0(s)},
ob(a,b){var s=new A.b0(new Uint32Array(b))
s.it(a,b)
return s},
oc(a,b){var s,r=J.bL(b,t.i)
for(s=0;s<b;++s)r[s]=new A.b4(a.k(),a.k())
return new A.bt(r)},
of(a,b){var s=new A.bJ(new Int16Array(b))
s.iv(a,b)
return s},
od(a,b){var s=new A.bI(new Int32Array(b))
s.iu(a,b)
return s},
oe(a,b){var s,r,q,p,o=J.bL(b,t.i)
for(s=0;s<b;++s){r=a.k()
q=$.U()
q.$flags&2&&A.b(q)
q[0]=r
r=$.ab()
if(0>=r.length)return A.a(r,0)
p=r[0]
q[0]=a.k()
o[s]=new A.b4(p,r[0])}return new A.bv(o)},
oh(a,b){var s=new A.c4(new Float32Array(b))
s.ix(a,b)
return s},
oa(a,b){var s=new A.c3(new Float64Array(b))
s.is(a,b)
return s},
am:function am(a,b){this.a=a
this.b=b},
a7:function a7(){},
bg:function bg(a){this.a=a},
cv:function cv(a){this.a=a},
bK:function bK(a){this.a=a},
b0:function b0(a){this.a=a},
bt:function bt(a){this.a=a},
bu:function bu(a){this.a=a},
bJ:function bJ(a){this.a=a},
bI:function bI(a){this.a=a},
bv:function bv(a){this.a=a},
c4:function c4(a){this.a=a},
c3:function c3(a){this.a=a},
c5:function c5(a){this.a=a},
cw:function cw(a){this.a=a},
pv(c7,c8,c9,d0,d1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6=null
if(c7.gaw())c7=c7.dz(c7.gad())
if(c8===B.bd)return c9.eu(c7)
if(B.cm.ac(c8))return A.vE(c7,c9,c8,d1)
s=B.lb.l(0,c8)
s.toString
r=c7.gJ()
q=c7.gN()
p=c9.gR()
o=A.V(c6,c6,B.e,0,B.j,r,c6,0,1,p,B.e,q,!1)
n=!1
if(c7.gL()===B.e)if(!c7.gaw()){m=c7.gad()>=3
n=m}l=c7.gad()
k=n?new Uint8Array(A.p(c7.Y())):c6
j=o.Y()
m=n?p.a*3:0
i=new Int32Array(m)
if(n)for(h=p.a,g=p.b,f=2<g,e=1<g,d=0<g,c=p.c,b=c.length,a=0,a0=0;a<h;++a,a0=a1){a1=a0+1
if(d){a2=a*g
if(!(a2>=0&&a2<b))return A.a(c,a2)
a2=c[a2]}else a2=0
a2=B.a.h(a2)
if(!(a0<m))return A.a(i,a0)
i[a0]=a2
a0=a1+1
if(e){a2=a*g+1
if(!(a2>=0&&a2<b))return A.a(c,a2)
a2=c[a2]}else a2=0
a2=B.a.h(a2)
if(!(a1<m))return A.a(i,a1)
i[a1]=a2
a1=a0+1
if(f){a2=a*g+2
if(!(a2>=0&&a2<b))return A.a(c,a2)
a2=c[a2]}else a2=0
a2=B.a.h(a2)
if(!(a0<m))return A.a(i,a0)
i[a0]=a2}a3=s.length
m=A.j([],t.n)
for(a4=0;a4<a3;++a4)m.push(s[a4][0])
a5=new Float64Array(A.p(m))
m=t.t
h=A.j([],m)
for(a4=0;a4<a3;++a4)h.push(B.b.h(s[a4][1]))
a6=new Int32Array(A.p(h))
h=A.j([],m)
for(a4=0;a4<a3;++a4)h.push(B.b.h(s[a4][2]))
a7=new A.mh(k,q,l,c9,j,i,a3,a6,new Int32Array(A.p(h)),r,a5)
a8=new A.mi(n?c7:A.aQ(c7,!1,!1),c9,o,p,s,q,r)
a9=n?a7:a8
if(d0===B.dg){b0=q+r-1
for(b1=q-1,b2=0;b2<b0;++b2){b3=b2<r?0:b2-r+1
b4=b2<q?b2:b1
if((b2&1)===0)for(b5=b3;b5<=b4;++b5)a9.$3(b5,b2-b5,1)
else for(b5=b4;b5>=b3;--b5)a9.$3(b5,b2-b5,1)}return o}if(d0===B.dh){b6=Math.max(q,r)
for(b7=1;b7<b6;)b7=b7<<1>>>0
b8=A.j([0,0],m)
b9=b7*b7
for(b2=0;b2<b9;++b2){A.uD(b7,b2,b8)
s=b8[0]
if(s<q&&b8[1]<r)a9.$3(s,b8[1],1)}return o}c0=d0===B.df
c1=c0?-1:1
for(c2=q-1,c3=0;c3<r;++c3){if(c0)c1*=-1
s=c1===1
c4=s?0:c2
c5=s?q:0
for(b5=c4;b5!==c5;b5+=c1)a9.$3(b5,c3,c1)}return o},
vE(a,b,c,d){var s,r,q,p,o,n,m,l,k=null,j=B.cm.l(0,c),i=j.length,h=a.gJ(),g=a.gN(),f=A.V(k,k,B.e,0,B.j,h,k,0,1,b.gR(),B.e,g,!1)
for(s=0;s<h;++s){r=j[B.a.a5(s,i)]
for(q=r.length,p=0;p<g;++p){o=a.a
n=o==null?k:o.P(p,s,k)
if(n==null)n=new A.E()
o=B.a.a5(p,i)
if(!(o<q))return A.a(r,o)
m=(r[o]-0.5)*255*d
l=b.dG(B.b.av(B.b.F(n.l(0,0)+m,0,255)),B.b.av(B.b.F(n.l(0,1)+m,0,255)),B.b.av(B.b.F(n.l(0,2)+m,0,255)))
o=f.a
if(o!=null)o.aO(p,s,l)}}return f},
uD(a,b,c){var s,r,q,p,o,n
B.c.i(c,0,0)
B.c.i(c,1,0)
for(s=b,r=1;r<a;r=r<<1>>>0){q=s>>>1&1
p=(s^q)&1
if(p===0){if(q===1){o=r-1
B.c.i(c,0,o-c[0])
B.c.i(c,1,o-c[1])}n=c[0]
c[0]=c[1]
c[1]=n}B.c.i(c,0,c[0]+r*q)
B.c.i(c,1,c[1]+r*p)
s=s>>>2}},
aJ:function aJ(a,b){this.a=a
this.b=b},
dj:function dj(a,b){this.a=a
this.b=b},
mh:function mh(a,b,c,d,e,f,g,h,i,j,k){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i
_.y=j
_.z=k},
mi:function mi(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
ax(a,b,c,d){var s
if(d)s=a<0||b<0
else s=a<1||b<1
if(s)throw A.f(A.l("Invalid image dimensions "+a+"x"+b))
if(c>0&&a*b>c)throw A.f(A.l("Image dimensions "+a+"x"+b+" exceed the maximum of "+c+" pixels"))},
bO:function bO(a){this.a=a
this.c=0},
nT(a){var s,r,q=new A.j8()
if(!A.nU(a))A.a3(A.l("Not a bitmap file."))
a.d+=2
s=a.k()
r=$.U()
r.$flags&2&&A.b(r)
r[0]=s
s=$.ab()
if(0>=s.length)return A.a(s,0)
a.d+=4
r[0]=a.k()
q.b=s[0]
return q},
nU(a){if(a.c-a.d<2)return!1
return A.w(a,null,0).n()===19778},
qr(a,b){var s,r,q,p,o=b==null?A.nT(a):b,n=a.d,m=a.k(),l=a.k(),k=$.U()
k.$flags&2&&A.b(k)
k[0]=l
l=$.ab()
if(0>=l.length)return A.a(l,0)
s=l[0]
k[0]=a.k()
l=l[0]
r=a.n()
q=a.n()
p=a.k()
if(p>=14)A.a3(A.l("Unsupported BMP compression type: "+p))
if(!(p<14))return A.a(B.az,p)
p=B.az[p]
a.k()
k[0]=a.k()
k[0]=a.k()
k=a.k()
a.k()
n=new A.aZ(o,s,l,m,r,q,p,k,n)
n.eM(a,b)
return n},
al:function al(a,b){this.a=a
this.b=b},
j8:function j8(){this.b=$},
aZ:function aZ(a,b,c,d,e,f,g,h,i){var _=this
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
qq(a,b){return new A.h1(a,b==null?268435456:b)},
h1:function h1(a,b){var _=this
_.a=$
_.b=null
_.c=a
_.d=b},
j6:function j6(a,b){this.a=a
this.b=b},
j4:function j4(a,b){this.a=a
this.b=b},
j3:function j3(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
j5:function j5(a,b,c){this.a=a
this.b=b
this.c=c},
jd:function jd(a,b){var _=this
_.a=$
_.b=null
_.c=a
_.d=b},
j7:function j7(){},
M:function M(){},
jb:function jb(){},
je:function je(){},
he:function he(){},
eA:function eA(a,b,c,d){var _=this
_.r=a
_.w=b
_.x=c
_.b=_.a=0
_.c=d},
cs:function cs(a,b){this.a=a
this.b=b},
cr:function cr(a,b){this.a=a
this.b=b},
hf:function hf(){var _=this
_.w=_.r=_.f=_.d=_.c=_.b=_.a=$},
o4(a,b,c,d){var s,r
switch(a.a){case 1:return new A.hC(c,b)
case 2:return new A.eB(c,d==null?1:d,b)
case 3:return new A.eB(c,d==null?16:d,b)
case 4:s=d==null?32:d
r=new A.hA(c,s,b)
r.iA(b,c,s)
return r
case 5:return new A.hB(c,d==null?16:d,b)
case 6:return new A.eA(c,d==null?32:d,!1,b)
case 7:return new A.eA(c,d==null?32:d,!0,b)
default:throw A.f(A.l("Invalid compression type: "+a.D(0)))}},
bf:function bf(a,b){this.a=a
this.b=b},
bF:function bF(){},
hy:function hy(){},
qI(a,b,c,d){var s,r,q,p,o,n,m,l
if(b===0){if(d!==0)throw A.f(A.l("Incomplete huffman data"))
return}s=a.d
r=a.k()
q=a.k()
a.d+=4
p=a.k()
o=!0
if(r<65537)o=q>=65537
if(o)throw A.f(A.l("Invalid huffman table size"))
a.d+=4
n=A.I(65537,0,!1,t.p)
m=J.af(16384,t.ho)
for(l=0;l<16384;++l)m[l]=new A.hg()
A.qJ(a,b-20,r,q,n)
if(p>8*(b-(a.d-s)))throw A.f(A.l("Error in header for Huffman-encoded data (invalid number of bits)."))
A.qF(n,r,q,m)
A.qH(n,m,a,p,q,d,c)},
qH(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k,j="Error in Huffman-encoded data (invalid code).",i=A.j([0,0],t.t),h=c.d+B.a.V(d+7,8)
for(s=b.length,r=0;c.d<h;){A.mG(i,c)
while(q=i[1],q>=14){p=B.a.aJ(i[0],q-14)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.i(i,1,q-p)
r=A.mH(o.b,e,i,c,g,r,f)}else{if(o.c==null)throw A.f(A.l(j))
for(n=0;n<o.b;++n){q=o.c
if(!(n<q.length))return A.a(q,n)
q=q[n]
if(!(q<65537))return A.a(a,q)
m=a[q]&63
for(;;){q=i[1]
if(!(q<m&&c.d<h))break
A.mG(i,c)}if(q>=m){p=o.c
if(!(n<p.length))return A.a(p,n)
p=p[n]
if(!(p<65537))return A.a(a,p)
q-=m
if(a[p]>>>6===(B.a.aJ(i[0],q)&B.a.S(1,m)-1)>>>0){B.c.i(i,1,q)
q=o.c
if(!(n<q.length))return A.a(q,n)
l=A.mH(q[n],e,i,c,g,r,f)
r=l
break}}}if(n===o.b)throw A.f(A.l(j))}}}k=8-d&7
B.c.i(i,0,B.a.j(i[0],k))
B.c.i(i,1,i[1]-k)
while(q=i[1],q>0){p=B.a.U(i[0],14-q)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.i(i,1,q-p)
r=A.mH(o.b,e,i,c,g,r,f)}else throw A.f(A.l(j))}if(r!==f)throw A.f(A.l("Error in Huffman-encoded data (decoded data are shorter than expected)."))},
mH(a,b,c,d,e,f,g){var s,r,q,p,o,n,m="Error in Huffman-encoded data (decoded data are longer than expected)."
if(a===b){if(c[1]<8)A.mG(c,d)
B.c.i(c,1,c[1]-8)
s=B.a.aJ(c[0],c[1])&255
if(f+s>g)throw A.f(A.l(m))
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
e[f]=a}else throw A.f(A.l(m))
f=n}return f},
qF(a,b,c,d){var s,r,q,p,o,n,m,l,k="Error in Huffman-encoded data (invalid code table entry)."
for(s=d.length,r=t.t;b<=c;++b){if(!(b<65537))return A.a(a,b)
q=a[b]
p=q>>>6
o=q&63
if(B.a.a6(p,o)!==0)throw A.f(A.l(k))
if(o>14){q=B.a.a0(p,o-14)
if(!(q<s))return A.a(d,q)
n=d[q]
if(n.a!==0)throw A.f(A.l(k));++n.b
q=n.c
if(q==null){q=A.j([],r)
n.smt(q)}B.c.C(q,b)}else if(o!==0){q=14-o
m=B.a.U(p,q)
if(!(m<s))return A.a(d,m)
for(l=B.a.U(1,q);l>0;--l,++m){if(!(m<s))return A.a(d,m)
n=d[m]
if(n.a!==0||n.c!=null)throw A.f(A.l(k))
n.a=o
n.b=b}}}},
qJ(a,b,c,d,e){var s,r,q,p,o,n="Error in Huffman-encoded data (unexpected end of code table data).",m="Error in Huffman-encoded data (code table is longer than expected).",l=a.d,k=A.j([0,0],t.t)
for(s=d+1;c<=d;++c){if(a.d-l>b)throw A.f(A.l(n))
r=A.o5(6,k,a)
B.c.i(e,c,r)
if(r===63){if(a.d-l>b)throw A.f(A.l(n))
q=A.o5(8,k,a)+6
if(c+q>s)throw A.f(A.l(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.i(e,c,0)}--c}else if(r>=59){q=r-59+2
if(c+q>s)throw A.f(A.l(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.i(e,c,0)}--c}}A.qG(e)},
qG(a){var s,r,q,p,o,n=A.I(59,0,!1,t.p)
for(s=0;s<65537;++s){r=a[s]
if(!(r<59))return A.a(n,r)
B.c.i(n,r,n[r]+1)}for(q=0,s=58;s>0;--s,q=p){p=q+n[s]>>>1
B.c.i(n,s,q)}for(s=0;s<65537;++s){o=a[s]
if(o>0){if(!(o<59))return A.a(n,o)
r=n[o]
B.c.i(n,o,r+1)
B.c.i(a,s,(o|r<<6)>>>0)}}},
mG(a,b){B.c.i(a,0,(a[0]<<8|b.H())>>>0)
B.c.i(a,1,a[1]+8>>>0)},
o5(a,b,c){var s
while(s=b[1],s<a){B.c.i(b,0,(b[0]<<8|J.d(c.a,c.d++))>>>0)
B.c.i(b,1,b[1]+8>>>0)}B.c.i(b,1,s-a)
return(B.a.aJ(b[0],b[1])&B.a.S(1,a)-1)>>>0},
hg:function hg(){this.b=this.a=0
this.c=null},
qK(a){var s
if(a.length<8)return!1
s=A.v(a,!1,null,0)
if(s.k()!==20000630)return!1
if(s.H()!==2)return!1
if((s.bt()&4294967289)>>>0!==0)return!1
return!0},
hh:function hh(a){var _=this
_.b=_.a=0
_.c=a
_.d=null
_.e=$},
ol(a,b,c,d){var s=new A.hz(a,A.j([],t.a_),A.J(t.N,t.iW),B.bg,b)
s.io(a,b,c,d)
return s},
ef:function ef(){},
jk:function jk(a,b){this.a=a
this.b=b},
hz:function hz(a,b,c,d,e){var _=this
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
hA:function hA(a,b,c){var _=this
_.r=null
_.w=a
_.x=b
_.y=$
_.z=null
_.b=_.a=0
_.c=c},
fJ:function fJ(){var _=this
_.f=_.e=_.d=_.c=_.b=_.a=$},
hB:function hB(a,b,c){var _=this
_.r=a
_.w=b
_.x=null
_.b=_.a=0
_.c=c},
hC:function hC(a,b){var _=this
_.r=null
_.w=a
_.b=_.a=0
_.c=b},
eB:function eB(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
jg:function jg(a){this.a=null
this.b=a},
jj:function jj(a,b){this.a=a
this.b=b},
jh:function jh(a,b){this.a=a
this.b=b},
ji:function ji(a,b,c){this.a=a
this.b=b
this.c=c},
o7(a){var s=new Uint8Array(a*3)
return new A.em(A.qR(a),a,null,new A.aT(s,a,3))},
qQ(a){return new A.em(a.a,a.b,a.c,A.ow(a.d))},
qR(a){var s
for(s=1;s<=8;++s)if(B.a.S(1,s)>=a)return s
return 0},
em:function em(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
en:function en(){},
hD:function hD(){var _=this
_.e=_.d=_.c=_.b=_.a=$
_.f=null
_.r=80
_.w=0
_.x=-1
_.y=$},
c1:function c1(a){var _=this
_.b=_.a=0
_.e=_.c=null
_.r=a},
jn:function jn(a){var _=this
_.a=null
_.b=a
_.f=_.e=_.d=_.c=0
_.r=null
_.w=0
_.x=null
_.z=_.y=$
_.Q=null
_.as=0
_.at=null
_.ch=_.ay=_.ax=0
_.CW=null
_.fr=_.dy=_.dx=_.db=_.cy=_.cx=0},
jq:function jq(a,b){this.a=a
this.b=b},
jo:function jo(a,b){this.a=a
this.b=b},
jp:function jp(a,b,c){this.a=a
this.b=b
this.c=c},
jr:function jr(){var _=this
_.b=0
_.as=_.Q=_.z=null
_.ax=_.at=$
_.fr=_.dy=_.dx=_.db=_.cy=_.cx=_.CW=_.ch=_.ay=0
_.fx=!1
_.fy=$
_.go=0
_.id=null},
js:function js(a,b){this.a=a
this.b=b},
o8(a){var s,r,q,p
if(a.n()!==0)return null
s=a.n()
if(s>=3)return null
if(B.dM[s]===B.bi)return null
r=a.n()
q=J.bL(r,t.aw)
for(p=0;p<r;++p){J.d(a.a,a.d++)
J.d(a.a,a.d++)
J.d(a.a,a.d++);++a.d
a.n()
a.n()
q[p]=new A.hr(a.k(),a.k())}return new A.hq(r,q)},
dl:function dl(a,b){this.a=a
this.b=b},
hq:function hq(a,b){this.d=a
this.e=b},
hr:function hr(a,b){this.d=a
this.e=b},
ho:function ho(a,b,c,d,e,f,g,h,i){var _=this
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
ju:function ju(a){this.b=this.a=null
this.c=a},
jx:function jx(a,b){this.a=a
this.b=b},
jw:function jw(a,b,c){this.a=a
this.b=b
this.c=c},
jv:function jv(a,b){this.a=a
this.b=b},
ln:function ln(){},
hp:function hp(){},
o0(a,b,c,d,e){var s,r
if(a===b)s=0
else s=a===1&&b===4?2:1
if(c===d)r=0
else r=c===1&&d===4?2:1
return new A.h6(e,s,r)},
h6:function h6(a,b,c){this.e=a
this.f=b
this.r=c},
pB(a){var s=$.qd(),r=s.a,q=r.get(a)
if(q==null){q=A.uq(a)
s.$ti.m("1?").a(q)
r.set(a,q)
s=q}else s=q
return s},
uq(a){var s,r,q,p,o,n=new Uint16Array(512)
for(s=0;s<512;++s)for(r=a,q=1;q<=9;++q){p=r[B.a.a0(s,9-q)&1]
if(p instanceof A.dk){o=p.a
if(!(s<512))return A.a(n,s)
n[s]=(q<<8|o)>>>0
break}if(!(p instanceof A.cu))break
r=p.a}return n},
c2:function c2(){},
cu:function cu(a){this.a=a},
dk:function dk(a){this.a=a},
or(a){var s,r=a.f.e
r.toString
s=a.b
s=new A.jP(a,B.a.aa(r+s-1,s),a.gdH())
s.iB(a)
return s},
pz(a){var s,r=A.or(a)
r.i0(0,a.gdH())
s=r.d
s===$&&A.c("image")
return s},
jP:function jP(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.w=_.r=_.f=_.e=_.d=$},
jK:function jK(){this.d=null},
c6:function c6(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.x=_.w=_.r=_.f=_.e=$
_.y=!1
_.z=0
_.ay=_.ax=_.at=_.as=_.Q=$},
mM(){var s,r,q,p,o=A.I(4,null,!1,t.jH),n=A.j([],t.gU),m=t.iM,l=J.hJ(0,m)
m=J.hJ(0,m)
s=A.j([],t.an)
r=A.j([],t.hg)
q=new Uint8Array(64)
p=new Int32Array(64)
return new A.hL(new A.bE(A.J(t.N,t.P)),o,n,l,m,s,r,q,p,new Int16Array(0))},
r2(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=B.a.aa(8,b),e=f*f
for(s=e>>>1,r=c.length,q=0;q<b;++q){p=d+q
if(!(p<r))return A.a(c,p)
p=c[p]
p.toString
for(o=p.$flags|0,n=q*f,m=0;m<b;++m){for(l=m*f,k=0,j=0;j<f;++j){i=(n+j)*8+l
for(h=0;h<f;++h){g=i+h
if(!(g<64))return A.a(a,g)
k+=a[g]}}l=a0+m
g=B.a.aa(k+s,e)
o&2&&A.b(p)
if(!(l<p.length))return A.a(p,l)
p[l]=g}}},
hL:function hL(a,b,c,d,e,f,g,h,i,j){var _=this
_.a=0
_.b=1
_.d=_.c=$
_.x=_.r=_.f=_.e=null
_.y=a
_.z=b
_.Q=c
_.as=d
_.at=e
_.ax=f
_.ay=!1
_.ch=0
_.cx=_.CW=!1
_.cy=null
_.db=g
_.dx=h
_.dy=i
_.fr=j},
dU:function dU(a){this.a=a
this.b=0},
iF:function iF(){},
hM:function hM(a,b){var _=this
_.e=_.d=_.c=_.b=null
_.r=_.f=0
_.x=_.w=$
_.y=a
_.z=b},
jQ:function jQ(){this.r=this.f=$},
hN:function hN(a,b,c,d,e,f,g,h,i){var _=this
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
_.ay=null
_.cx=_.CW=_.ch=0
_.cy=!1
_.dx=_.db=0
_.dy=$
_.fr=i},
oq(){return new A.jM(268435456)},
jM:function jM(a){this.a=a},
jN:function jN(a,b,c){this.a=a
this.b=b
this.c=c},
r3(a,b){return a>0?a:a+B.a.U(1,b)-1},
jL:function jL(a,b){this.a=a
this.b=b},
jO:function jO(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.w=_.r=_.f=_.e=$
_.x=e
_.y=f
_.z=g
_.Q=null
_.at=_.as=0},
lG:function lG(a,b){this.a=a
this.b=b},
kb:function kb(a,b,c){this.a=a
this.b=b
this.c=c},
dD:function dD(a,b){this.a=a
this.b=b},
f8:function f8(a,b){this.a=a
this.b=b},
f9:function f9(){},
hE:function hE(a,b,c,d,e,f,g,h,i){var _=this
_.y=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
ca:function ca(a,b){this.a=a
this.b=b},
i0:function i0(){},
hF:function hF(a,b,c){var _=this
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
oy(a){var s=t.N,r=A.j([],t.fi),q=A.j([],t.t),p=a==null?268435456:a
return new A.k7(new A.hF(A.J(s,s),r,q),p)},
k7:function k7(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=0
_.e=$
_.f=0},
ka:function ka(a,b){this.a=a
this.b=b},
k8:function k8(a,b){this.a=a
this.b=b},
k9:function k9(a,b,c){this.a=a
this.b=b
this.c=c},
iJ:function iJ(){},
rs(){return new A.hZ()},
rx(a){var s,r,q,p,o=new A.ah(a),n=!1
if(o.gu(0)!==0)if(a.length<=79){if(o.gu(0)===0)A.a3(A.dv())
if(o.l(0,0)!==32){if(o.gu(0)===0)A.a3(A.dv())
s=o.l(0,o.gu(0)-1)!==32}else s=n
n=s}s=a.length
r=0
for(;;){if(!(n&&r<s))break
if(!(r<s))return A.a(a,r)
q=a.charCodeAt(r)
if(!(q>=32&&q<=126))p=q>=161&&q<=255
else p=!0
if(p){if(q===32){p=r-1
if(!(p>=0))return A.a(a,p)
p=a.charCodeAt(p)===32}else p=!1
n=!p}else n=!1;++r}return n?a:"ICC_PROFILE"},
rv(a,b,c){var s,r,q,p=a.length,o=c.$flags|0,n=1,m=0
for(;;){if(!(m<b&&m<p))break
s=n+1
if(!(m<p))return A.a(a,m)
r=a[m]
o&2&&A.b(c)
if(!(n<c.length))return A.a(c,n)
c[n]=r;++m
n=s}for(m=b;m<p;++m,n=s){s=n+1
r=a[m]
q=m-b
if(!(q>=0))return A.a(a,q)
q=a[q]
o&2&&A.b(c)
if(!(n<c.length))return A.a(c,n)
c[n]=r-q}},
rw(a,b,c){var s,r,q,p,o,n,m,l=a.length
for(s=b.length,r=c.$flags|0,q=1,p=0;p<l;++p,q=o){o=q+1
n=a[p]
if(!(p<s))return A.a(b,p)
m=b[p]
r&2&&A.b(c)
if(!(q<c.length))return A.a(c,q)
c[q]=n-m}},
rt(a,b,c,d){var s,r,q,p,o=a.length,n=b.length,m=d.$flags|0,l=1,k=0
for(;;){if(!(k<c&&k<o))break
s=l+1
if(!(k<o))return A.a(a,k)
r=a[k]
if(!(k<n))return A.a(b,k)
q=b[k]
m&2&&A.b(d)
if(!(l<d.length))return A.a(d,l)
d[l]=r-(q>>>1);++k
l=s}for(k=c;k<o;++k,l=s){s=l+1
r=a[k]
q=k-c
if(!(q>=0))return A.a(a,q)
q=a[q]
if(!(k<n))return A.a(b,k)
p=b[k]
m&2&&A.b(d)
if(!(l<d.length))return A.a(d,l)
d[l]=r-(q+p>>>1)}},
ru(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=a.length,i=b.length,h=d.$flags|0,g=1,f=0
for(;;){if(!(f<c&&f<j))break
s=g+1
if(!(f<j))return A.a(a,f)
r=a[f]
if(!(f<i))return A.a(b,f)
q=b[f]
h&2&&A.b(d)
if(!(g<d.length))return A.a(d,g)
d[g]=r-q;++f
g=s}for(f=c;f<j;++f,g=s){r=f-c
if(!(r>=0))return A.a(a,r)
p=a[r]
if(!(f<i))return A.a(b,f)
o=b[f]
if(!(r<i))return A.a(b,r)
n=b[r]
m=o-n
l=p-n
k=m+l
if(m<0)m=-m
if(l<0)l=-l
if(k<0)k=-k
s=g+1
r=a[f]
if(m<=l&&m<=k)q=p
else q=l<=k?o:n
h&2&&A.b(d)
if(!(g<d.length))return A.a(d,g)
d[g]=r-q}},
i_:function i_(a,b){this.a=a
this.b=b},
hZ:function hZ(){var _=this
_.a=null
_.c=0
_.e=$
_.f=0
_.r=!1
_.w=null},
kd:function kd(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
kc:function kc(a,b,c){this.a=a
this.b=b
this.c=c},
cb:function cb(a,b){this.a=a
this.b=b},
cc:function cc(a){this.b=this.a=0
this.e=a},
ke:function ke(a,b){var _=this
_.b=_.a=null
_.c=a
_.d=b},
kh:function kh(a,b,c){this.a=a
this.b=b
this.c=c},
ki:function ki(a,b){this.a=a
this.b=b},
kg:function kg(a,b){this.a=a
this.b=b},
kf:function kf(){},
i2:function i2(){this.a=null},
i3:function i3(){this.a=null},
bw:function bw(){},
i6:function i6(){this.a=null},
i7:function i7(){this.a=null},
ia:function ia(){this.a=null},
ib:function ib(){this.a=null},
fb:function fb(a){this.b=a},
i9:function i9(){},
kj:function kj(){var _=this
_.w=_.r=_.f=_.e=$},
cR:function cR(a){this.a=a
this.c=null},
oE(a,b){var s=A.j([],t.k9),r=b==null?268435456:b
r=new A.i4(s,A.J(t.p,t.ok),a.length,r)
r.iD(a,b)
return r},
n2(a,b,c,d){var s=a/255,r=b/255,q=c/255,p=d/255,o=r*(1-q),n=s*(1-p)
return B.b.h(B.b.F((2*s<q?2*r*s+o+n:p*q-2*(q-s)*(p-r)+o+n)*255,0,255))},
ko(a,b){if(b===0)return 0
return B.a.h(B.a.F(B.b.h(255*(1-(1-a/255)/(b/255))),0,255))},
kq(a,b){return B.a.h(B.a.F(a+b-255,0,255))},
n4(a,b){return B.a.h(B.a.F(255-(255-b)*(255-a),0,255))},
kp(a,b){if(b===255)return 255
return B.b.h(B.b.F(a/255/(1-b/255)*255,0,255))},
n5(a,b){var s=a/255,r=b/255,q=1-r
return B.b.av(255*(q*r*s+r*(1-q*(1-s))))},
n0(a,b){var s=b/255,r=a/255
if(r<0.5)return B.b.av(510*s*r)
else return B.b.av(255*(1-2*(1-s)*(1-r)))},
n6(a,b){if(b<128)return A.ko(a,2*b)
else return A.kp(a,2*(b-128))},
n1(a,b){var s
if(b<128)return A.kq(a,2*b)
else{s=2*(b-128)
return s+a>255?255:a+s}},
n3(a,b){return b<128?Math.min(a,2*b):Math.max(a,2*(b-128))},
n_(a,b){return B.b.av(b+a-2*b*a/255)},
aK(a,b,c){var s,r,q
if(a==null)s=0
else{s=a.length
if(c===1){if(!(b>=0&&b<s))return A.a(a,b)
s=a[b]}else{if(!(b>=0&&b<s))return A.a(a,b)
r=a[b]
q=b+1
if(!(q<s))return A.a(a,q)
q=(r<<8|a[q])>>>8
s=q}}return s},
oF(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.J(t.p,t.dS)
for(s=c1.length,r=0;q=c1.length,r<q;c1.length===s||(0,A.L)(c1),++r){p=c1[r]
b6.i(0,p.a,p)}if(b8===8)o=1
else o=b8===16?2:-1
n=A.V(b5,b5,B.e,0,B.j,c0,b5,0,q,b5,B.e,b9,!1)
if(o===-1)throw A.f(A.l("PSD: unsupported bit depth: "+A.y(b8)))
m=b6.l(0,0)
l=b6.l(0,1)
k=b6.l(0,2)
j=b6.l(0,-1)
i=A.j([0,0,0],t.t)
h=-o
for(s=n.a,s=s.gI(s),g=q>=5,f=q===4,e=q>=2,q=q>=4;s.E();){d=s.gO()
h+=o
switch(b7){case B.cx:d.st(A.aK(m.c,h,o))
d.sA(A.aK(l.c,h,o))
d.sB(A.aK(k.c,h,o))
d.sv(q?A.aK(j.c,h,o):255)
if(d.gv()!==0){d.st((d.gt()+d.gv()-255)*255/d.gv())
d.sA((d.gA()+d.gv()-255)*255/d.gv())
d.sB((d.gB()+d.gv()-255)*255/d.gv())}break
case B.cz:c=A.aK(m.c,h,o)
b=A.aK(l.c,h,o)
a=A.aK(k.c,h,o)
a0=q?A.aK(j.c,h,o):255
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
b0=[B.b.av(B.b.F(a7*255,0,255)),B.b.av(B.b.F(a8*255,0,255)),B.b.av(B.b.F(a9*255,0,255))]
d.st(b0[0])
d.sA(b0[1])
d.sB(b0[2])
d.sv(a0)
break
case B.cw:b1=A.aK(m.c,h,o)
a0=e?A.aK(j.c,h,o):255
d.st(b1)
d.sA(b1)
d.sB(b1)
d.sv(a0)
break
case B.cy:b2=A.aK(m.c,h,o)
b3=A.aK(l.c,h,o)
a1=A.aK(k.c,h,o)
b4=A.aK(b6.l(0,f?-1:3).c,h,o)
a0=g?A.aK(j.c,h,o):255
A.ps(255-b2,255-b3,255-a1,255-b4,i)
d.st(i[0])
d.sA(i[1])
d.sB(i[2])
d.sv(a0)
break
default:throw A.f(A.l("Unhandled color mode: "+A.y(b7)))}}return n},
bk:function bk(a,b){this.a=a
this.b=b},
i4:function i4(a,b,c,d){var _=this
_.b=_.a=0
_.d=_.c=null
_.e=$
_.r=_.f=null
_.w=a
_.x=$
_.y=null
_.z=b
_.as=$
_.at=c
_.ch=_.ay=_.ax=null
_.CW=d},
i5:function i5(){},
i8:function i8(a,b,c){var _=this
_.b=_.a=null
_.f=_.e=_.d=_.c=$
_.r=null
_.as=_.y=_.w=$
_.ay=a
_.ch=b
_.cx=null
_.cy=c},
rK(a,b){var s
switch(a){case"lsct":s=b.c-b.d
b.k()
if(s>=12){if(b.au(4)!=="8BIM")A.a3(A.l("Invalid key in layer additional data"))
b.au(4)}if(s>=16)b.k()
return new A.i9()
default:return new A.fb(b)}},
dG:function dG(){},
kk:function kk(a){this.a=null
this.b=a},
km:function km(a,b,c){this.a=a
this.b=b
this.c=c},
kn:function kn(a,b){this.a=a
this.b=b},
kl:function kl(a,b){this.a=a
this.b=b},
ic:function ic(){},
b3:function b3(a,b,c){this.a=a
this.b=b
this.c=c},
R:function R(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dJ:function dJ(a,b,c){this.a=a
this.b=b
this.$ti=c},
dH:function dH(){var _=this
_.Q=_.z=_.y=_.f=_.d=_.b=_.a=0},
dI:function dI(a){var _=this
_.b=0
_.c=a
_.Q=_.r=_.f=0},
fc:function fc(){this.y=this.b=this.a=0},
aa(a,b){var s,r=a>>>8
if(!(r<256))return A.a(B.Y,r)
r=B.Y[r]
s=b>>>8
if(!(s<256))return A.a(B.Y,s)
return(r<<17|B.Y[s]<<16|B.Y[a&255]<<1|B.Y[b&255])>>>0},
a8:function a8(a){var _=this
_.a=a
_.b=0
_.c=!1
_.d=0
_.e=!1
_.f=0
_.r=!1},
kr:function kr(a){this.b=this.a=null
this.c=a},
ku:function ku(a,b){this.a=a
this.b=b},
ks:function ks(a,b){this.a=a
this.b=b},
kt:function kt(a,b,c){this.a=a
this.b=b
this.c=c},
rL(a,b,c){var s=new A.kw(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dJ(r.cX(),q.cX(),t.nv)
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
rM(a,b,c){var s=new A.kx(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dJ(r.cX(),q.cX(),t.n5)
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
fd:function fd(a,b){this.a=a
this.b=b},
kv:function kv(){},
kw:function kw(a,b,c){this.a=a
this.b=b
this.c=c},
kx:function kx(a,b,c){this.a=a
this.b=b
this.c=c},
fj:function fj(a){var _=this
_.b=_.a=0
_.c=a
_.Q=_.z=_.y=_.x=_.f=_.e=0
_.as=null
_.ax=0},
aC:function aC(a,b){this.a=a
this.b=b},
kC:function kC(a){this.a=null
this.b=$
this.c=a},
kE:function kE(a,b,c){this.a=a
this.b=b
this.c=c},
kF:function kF(a,b){this.a=a
this.b=b},
kD:function kD(a,b){this.a=a
this.b=b},
rS(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i=d.length
for(s=e===4,r=a.length,q=d.$flags|0,p=c>=3,o=b,n=0;n<i;n+=e,o+=c){m=n+1
l=n+2
if(p){k=o+2
if(!(k>=0&&k<r))return A.a(a,k)
k=a[k]
q&2&&A.b(d)
d[n]=k
k=o+1
if(!(k>=0&&k<r))return A.a(a,k)
k=a[k]
if(!(m<i))return A.a(d,m)
d[m]=k
if(!(o>=0&&o<r))return A.a(a,o)
k=a[o]
if(!(l<i))return A.a(d,l)
d[l]=k
if(s){m=n+3
l=o+3
if(!(l<r))return A.a(a,l)
l=a[l]
if(!(m<i))return A.a(d,m)
d[m]=l}}else{if(!(o>=0&&o<r))return A.a(a,o)
j=a[o]
q&2&&A.b(d)
d[n]=j
if(!(m<i))return A.a(d,m)
d[m]=j
if(!(l<i))return A.a(d,l)
d[l]=j
if(s){m=n+3
l=o+1
if(!(l<r))return A.a(a,l)
l=a[l]
if(!(m<i))return A.a(d,m)
d[m]=l}}}},
kG:function kG(){},
kH:function kH(a){this.a=a
this.c=this.b=0},
ii:function ii(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.f=e},
n9(a,b,c){var s=new A.kM(b,a),r=t.I
s.e=A.I(b,null,!1,r)
s.f=A.I(b,null,!1,r)
return s},
kM:function kM(a,b){var _=this
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
ij:function ij(a,b,c,d){var _=this
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
cS:function cS(a,b){this.a=a
this.b=b},
ac:function ac(a,b){this.a=a
this.b=b},
b6:function b6(a,b){this.a=a
this.b=b},
ik:function ik(a){var _=this
_.b=_.a=0
_.d=null
_.f=a},
ot(){return new A.k_(new Uint8Array(4096))},
k_:function k_(a){var _=this
_.a=9
_.d=_.c=_.b=0
_.w=_.r=_.f=_.e=$
_.x=a
_.z=_.y=$
_.Q=null
_.as=$},
kI:function kI(a){this.a=null
this.c=$
this.d=a},
kJ:function kJ(a,b){this.a=a
this.b=b},
kK:function kK(a,b,c){this.a=a
this.b=b
this.c=c},
kL:function kL(){},
na(a,b){var s=new Int32Array(4),r=new Int32Array(4),q=new Int8Array(4),p=new Int8Array(4),o=A.I(8,null,!1,t.nX),n=A.I(4,null,!1,t.nk)
return new A.kQ(a,b,new A.kY(),new A.l8(),new A.kS(s,r),new A.la(q,p),o,n,new Uint8Array(4))},
aD(a,b,c,d,e){var s,r,q,p,o
for(s=c.length,r=a.$flags|0,q=0;q<e;++q){p=b+q
o=d+q
if(!(o>=0&&o<s))return A.a(c,o)
o=c[o]
r&2&&A.b(a)
if(!(p>=0&&p<a.length))return A.a(a,p)
a[p]=o}},
oN(a,b,c){if(c===0)if(a===0)return b===0?6:5
else return b===0?4:0
return c},
kQ:function kQ(a,b,c,d,e,f,g,h,i){var _=this
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
_.bF=$
_.aV=null
_.bG=$
_.bS=_.ci=null
_.aZ=$},
oL(a){var s=new A.fm(a)
s.b=254
s.c=0
s.d=-8
return s},
fm:function fm(a){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=!1},
F(a,b,c){return B.a.b5(B.a.j(a+2*b+c+2,2),32)},
t6(a){var s,r=A.j([A.F(J.d(a.a,a.d+-33),J.d(a.a,a.d+-32),J.d(a.a,a.d+-31)),A.F(J.d(a.a,a.d+-32),J.d(a.a,a.d+-31),J.d(a.a,a.d+-30)),A.F(J.d(a.a,a.d+-31),J.d(a.a,a.d+-30),J.d(a.a,a.d+-29)),A.F(J.d(a.a,a.d+-30),J.d(a.a,a.d+-29),J.d(a.a,a.d+-28))],t.t)
for(s=0;s<4;++s)a.dC(s*32,4,r)},
rZ(a){var s=J.d(a.a,a.d+-33),r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=A.w(a,null,0),m=n.dF(),l=A.F(s,r,q)
m.$flags&2&&A.b(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.dF()
m=A.F(r,q,p)
l.$flags&2&&A.b(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m
n.d+=32
m=n.dF()
l=A.F(q,p,o)
m.$flags&2&&A.b(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.dF()
m=A.F(p,o,o)
l.$flags&2&&A.b(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m},
rX(a){var s,r,q,p
for(s=4,r=0;r<4;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
s=B.a.j(s,3)
for(r=0;r<4;++r){q=a.a
p=a.d+r*32
J.e6(q,p,p+4,s)}},
nb(a,b){var s,r,q,p,o,n,m=255-J.d(a.a,a.d+-33)
for(s=0,r=0;r<b;++r){q=m+J.d(a.a,a.d+(s-1))
for(p=0;p<b;++p){o=$.mx()
n=q+J.d(a.a,a.d+(-32+p))
if(!(n>=0&&n<766))return A.a(o,n)
n=o[n]
J.a_(a.a,a.d+(s+p),n)}s+=32}},
t4(a){A.nb(a,4)},
t5(a){A.nb(a,8)},
t3(a){A.nb(a,16)},
t2(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=J.d(a.a,a.d+-33),m=J.d(a.a,a.d+-32),l=J.d(a.a,a.d+-31),k=J.d(a.a,a.d+-30),j=J.d(a.a,a.d+-29)
a.i(0,96,A.F(q,p,o))
s=A.F(r,q,p)
a.i(0,97,s)
a.i(0,64,s)
s=A.F(n,r,q)
a.i(0,98,s)
a.i(0,65,s)
a.i(0,32,s)
s=A.F(m,n,r)
a.i(0,99,s)
a.i(0,66,s)
a.i(0,33,s)
a.i(0,0,s)
s=A.F(l,m,n)
a.i(0,67,s)
a.i(0,34,s)
a.i(0,1,s)
s=A.F(k,l,m)
a.i(0,35,s)
a.i(0,2,s)
a.i(0,3,A.F(j,k,l))},
t1(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.i(0,0,A.F(r,q,p))
s=A.F(q,p,o)
a.i(0,32,s)
a.i(0,1,s)
s=A.F(p,o,n)
a.i(0,64,s)
a.i(0,33,s)
a.i(0,2,s)
s=A.F(o,n,m)
a.i(0,96,s)
a.i(0,65,s)
a.i(0,34,s)
a.i(0,3,s)
s=A.F(n,m,l)
a.i(0,97,s)
a.i(0,66,s)
a.i(0,35,s)
s=A.F(m,l,k)
a.i(0,98,s)
a.i(0,67,s)
a.i(0,99,A.F(l,k,k))},
t8(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+-33),o=J.d(a.a,a.d+-32),n=J.d(a.a,a.d+-31),m=J.d(a.a,a.d+-30),l=J.d(a.a,a.d+-29),k=B.a.b5(B.a.j(p+o+1,1),32)
a.i(0,65,k)
a.i(0,0,k)
k=B.a.b5(B.a.j(o+n+1,1),32)
a.i(0,66,k)
a.i(0,1,k)
k=B.a.b5(B.a.j(n+m+1,1),32)
a.i(0,67,k)
a.i(0,2,k)
a.i(0,3,B.a.b5(B.a.j(m+l+1,1),32))
a.i(0,96,A.F(q,r,s))
a.i(0,64,A.F(r,s,p))
k=A.F(s,p,o)
a.i(0,97,k)
a.i(0,32,k)
k=A.F(p,o,n)
a.i(0,98,k)
a.i(0,33,k)
k=A.F(o,n,m)
a.i(0,99,k)
a.i(0,34,k)
a.i(0,35,A.F(n,m,l))},
t7(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.i(0,0,B.a.b5(B.a.j(r+q+1,1),32))
s=B.a.b5(B.a.j(q+p+1,1),32)
a.i(0,64,s)
a.i(0,1,s)
s=B.a.b5(B.a.j(p+o+1,1),32)
a.i(0,65,s)
a.i(0,2,s)
s=B.a.b5(B.a.j(o+n+1,1),32)
a.i(0,66,s)
a.i(0,3,s)
a.i(0,32,A.F(r,q,p))
s=A.F(q,p,o)
a.i(0,96,s)
a.i(0,33,s)
s=A.F(p,o,n)
a.i(0,97,s)
a.i(0,34,s)
s=A.F(o,n,m)
a.i(0,98,s)
a.i(0,35,s)
a.i(0,67,A.F(n,m,l))
a.i(0,99,A.F(m,l,k))},
t_(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95)
a.i(0,0,B.a.b5(B.a.j(r+q+1,1),32))
s=B.a.b5(B.a.j(q+p+1,1),32)
a.i(0,32,s)
a.i(0,2,s)
s=B.a.b5(B.a.j(p+o+1,1),32)
a.i(0,64,s)
a.i(0,34,s)
a.i(0,1,A.F(r,q,p))
s=A.F(q,p,o)
a.i(0,33,s)
a.i(0,3,s)
s=A.F(p,o,o)
a.i(0,65,s)
a.i(0,35,s)
a.i(0,99,o)
a.i(0,98,o)
a.i(0,97,o)
a.i(0,96,o)
a.i(0,66,o)
a.i(0,67,o)},
rY(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+95),o=J.d(a.a,a.d+-33),n=J.d(a.a,a.d+-32),m=J.d(a.a,a.d+-31),l=J.d(a.a,a.d+-30),k=B.a.b5(B.a.j(s+o+1,1),32)
a.i(0,34,k)
a.i(0,0,k)
k=B.a.b5(B.a.j(r+s+1,1),32)
a.i(0,66,k)
a.i(0,32,k)
k=B.a.b5(B.a.j(q+r+1,1),32)
a.i(0,98,k)
a.i(0,64,k)
a.i(0,96,B.a.b5(B.a.j(p+q+1,1),32))
a.i(0,3,A.F(n,m,l))
a.i(0,2,A.F(o,n,m))
k=A.F(s,o,n)
a.i(0,35,k)
a.i(0,1,k)
k=A.F(r,s,o)
a.i(0,67,k)
a.i(0,33,k)
k=A.F(q,r,s)
a.i(0,99,k)
a.i(0,65,k)
a.i(0,97,A.F(p,q,r))},
tj(a){var s
for(s=0;s<16;++s)a.cB(s*32,16,a,-32)},
th(a){var s,r,q,p,o
for(s=0,r=16;r>0;--r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.e6(p,o,o+16,q)
s+=32}},
kW(a,b){var s,r,q
for(s=0;s<16;++s){r=b.a
q=b.d+s*32
J.e6(r,q,q+16,a)}},
t9(a){var s,r
for(s=16,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))+J.d(a.a,a.d+(r-32))
A.kW(B.a.j(s,5),a)},
tb(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.kW(B.a.j(s,4),a)},
ta(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(r-32))
A.kW(B.a.j(s,4),a)},
tc(a){A.kW(128,a)},
tk(a){var s
for(s=0;s<8;++s)a.cB(s*32,8,a,-32)},
ti(a){var s,r,q,p,o
for(s=0,r=0;r<8;++r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.e6(p,o,o+8,q)
s+=32}},
kX(a,b){var s,r,q
for(s=0;s<8;++s){r=b.a
q=b.d+s*32
J.e6(r,q,q+8,a)}},
td(a){var s,r
for(s=8,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
A.kX(B.a.j(s,4),a)},
te(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))
A.kX(B.a.j(s,3),a)},
tf(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.kX(B.a.j(s,3),a)},
tg(a){A.kX(128,a)},
kT(a,b){return B.a.j(a*b+1073741824,16)-16384},
kU(a,b,c,d,e){var s=b+c+d*32
a.i(0,s,A.rW(J.d(a.a,a.d+s)+(B.a.j(e+65536,3)-8192)))},
kV(a,b,c,d,e){A.kU(a,0,0,b,c+d)
A.kU(a,0,1,b,c+e)
A.kU(a,0,2,b,c-e)
A.kU(a,0,3,b,c-d)},
t0(){var s,r,q,p
if(!$.oM){for(s=-255;s<=255;++s){r=$.nH()
q=255+s
p=s<0?-s:s
r.$flags&2&&A.b(r)
r[q]=p
p=$.nI()
r=B.a.j(r[q],1)
p.$flags&2&&A.b(p)
p[q]=r}for(s=-1020;s<=1020;++s){r=$.nJ()
if(s<-128)q=-128
else q=s>127?127:s
r.$flags&2&&A.b(r)
r[1020+s]=q}for(s=-112;s<=112;++s){r=$.nK()
if(s<-16)q=-16
else q=s>15?15:s
r.$flags&2&&A.b(r)
r[112+s]=q}for(s=-255;s<=510;++s){r=$.mx()
if(s<0)q=0
else q=s>255?255:s
r.$flags&2&&A.b(r)
r[255+s]=q}$.oM=!0}},
rW(a){var s
if((a&-256)>>>0===0)s=a
else s=a<0?0:255
return s},
kR:function kR(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
rV(){var s,r=J.af(3,t.D)
for(s=0;s<3;++s)r[s]=new Uint8Array(11)
return new A.fl(r)},
tD(){var s,r,q,p,o=new Uint8Array(3),n=J.af(4,t.ac)
for(s=t.e5,r=0;r<4;++r){q=J.af(8,s)
for(p=0;p<8;++p)q[p]=A.rV()
n[r]=q}B.d.a8(o,0,3,255)
return new A.l9(o,n)},
kY:function kY(){this.d=$},
l8:function l8(){},
la:function la(a,b){var _=this
_.b=_.a=!1
_.c=!0
_.d=a
_.e=b},
fl:function fl(a){this.a=a},
l9:function l9(a,b){this.a=a
this.b=b},
kS:function kS(a,b){var _=this
_.a=$
_.b=null
_.d=_.c=$
_.e=a
_.f=b},
bS:function bS(){var _=this
_.b=_.a=0
_.c=!1
_.d=0},
fr:function fr(){this.b=this.a=0},
iv:function iv(a,b,c){this.a=a
this.b=b
this.c=c},
fs:function fs(a,b){var _=this
_.a=a
_.b=$
_.c=b
_.e=_.d=null
_.f=$},
ft:function ft(a,b,c){this.a=a
this.b=b
this.c=c},
nc(a,b){var s,r=A.j([],t.nK),q=A.j([],t.ip),p=new Uint32Array(2),o=new A.ir(a,p)
p=o.e=J.C(B.o.gq(p),0,null)
s=a.H()
p.$flags&2&&A.b(p)
if(0>=p.length)return A.a(p,0)
p[0]=s
s=a.H()
p.$flags&2&&A.b(p)
if(1>=p.length)return A.a(p,1)
p[1]=s
s=a.H()
p.$flags&2&&A.b(p)
if(2>=p.length)return A.a(p,2)
p[2]=s
s=a.H()
p.$flags&2&&A.b(p)
if(3>=p.length)return A.a(p,3)
p[3]=s
s=a.H()
p.$flags&2&&A.b(p)
if(4>=p.length)return A.a(p,4)
p[4]=s
s=a.H()
p.$flags&2&&A.b(p)
if(5>=p.length)return A.a(p,5)
p[5]=s
s=a.H()
p.$flags&2&&A.b(p)
if(6>=p.length)return A.a(p,6)
p[6]=s
s=a.H()
p.$flags&2&&A.b(p)
if(7>=p.length)return A.a(p,7)
p[7]=s
o.b=!1
return new A.fn(o,b,r,q)},
ce(a,b){return B.a.j(a+B.a.S(1,b)-1,b)},
fn:function fn(a,b,c,d){var _=this
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
hG:function hG(a,b,c,d){var _=this
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
vo(d4,d5,d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3=J.af(12,t.Q)
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
for(c2=0;c2<12;++c2){f=A.uo(d3[c2])
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
c5=A.pm(d5,d7)*A.pm(d6,d7)
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
break}++c2}return new A.kZ(c9,c7,c7&&!d2)},
pm(a,b){return B.a.j(a+B.a.S(1,b)-1,b)},
uo(a){var s,r,q,p,o,n,m,l,k
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
kZ:function kZ(a,b,c){this.a=a
this.b=b
this.c=c},
vy(b5,b6,b7,b8,b9,c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4
if(b5.length<b9||b6.length<b9||b7.length<b9||b8.length<b9)throw A.f(A.aX("computeMatches needs "+b9+" of every plane",null))
s=new Uint32Array(b9)
r=new Int32Array(b9)
q=new A.lJ(b9,s,r)
q.iH(b5,b6,b7,b8,b9)
q.mc()
p=new Uint32Array(b9)
o=t.fT
o=A.r8(new A.cW(A.j([1,2,c0-1,c0,c0+1],t.t),t.gw.a(new A.ma(b9)),o),o.m("e.E"))
o=A.t(o,A.m(o).c)
B.c.eF(o)
n=new Int32Array(A.p(o))
m=n.length
if(m>5)throw A.f(A.kA("the near-neighbor walk has five slots, not "+m))
l=new Int32Array(5)
B.u.a8(l,0,5,b9)
for(k=0;k<m;++k){o=n[k]
if(!(k<5))return A.a(l,k)
l[k]=o}j=l[0]
i=l[1]
h=l[2]
g=l[3]
f=l[4]
e=b9-1
for(d=b9,c=0,b=0,a=0,a0=0,a1=0;e>0;){for(;d>e;d=a2){a2=d-1
if(!(a2<b9))return A.a(s,a2)
a3=s[a2]
if(a2>=j){o=a2-j
if(!(o>=0&&o<b9))return A.a(s,o)
o=a3===s[o]}else o=!1
if(o){if(c<4095)++c}else c=0
if(a2>=i){o=a2-i
if(!(o>=0&&o<b9))return A.a(s,o)
o=a3===s[o]}else o=!1
if(o){if(b<4095)++b}else b=0
if(a2>=h){o=a2-h
if(!(o>=0&&o<b9))return A.a(s,o)
o=a3===s[o]}else o=!1
if(o){if(a<4095)++a}else a=0
if(a2>=g){o=a2-g
if(!(o>=0&&o<b9))return A.a(s,o)
o=a3===s[o]}else o=!1
if(o){if(a0<4095)++a0}else a0=0
if(a2>=f){o=a2-f
if(!(o>=0&&o<b9))return A.a(s,o)
o=a3===s[o]}else o=!1
if(o){if(a1<4095)++a1}else a1=0}a4=b9-e
if(a4>4095)a4=4095
if(c>0){a5=j
a6=c}else{a6=0
a5=0}if(b>a6){a5=i
a6=b}if(a>a6){a5=h
a6=a}if(a0>a6){a5=g
a6=a0}if(a1>a6){a5=f
a6=a1}if(a6<a4){a7=a4<256?a4:256
if(!(e<b9))return A.a(r,e)
k=r[e]
a8=0
for(;;){if(!(k>=0&&a8<86))break;++a8
a9=e-k
if(a9>1048456)break
o=k+a6
if(!(o>=0&&o<b9))return A.a(s,o)
o=s[o]
b0=e+a6
if(!(b0>=0&&b0<b9))return A.a(s,b0)
if(o===s[b0]){b1=0
for(;;){if(b1<a4){o=e+b1
if(!(o<b9))return A.a(s,o)
o=s[o]
b0=k+b1
if(!(b0>=0&&b0<b9))return A.a(s,b0)
b0=o===s[b0]
o=b0}else o=!1
if(!o)break;++b1}if(b1>a6){if(b1>=a7){a5=a9
a6=b1
break}a5=a9
a6=b1}}if(!(k>=0&&k<b9))return A.a(r,k)
k=r[k]}}o=a5<<12
if(!(e<b9))return A.a(p,e)
p[e]=(o|a6)>>>0
b0=a5>0
b2=e
for(;;){if(!(b0&&a6<4095))break
b3=b2-1
b4=!0
if(b3>0)if(b3>=a5){b4=b3-a5
if(!(b4>=0&&b4<b9))return A.a(s,b4)
b4=s[b4]
if(!(b3>=0&&b3<b9))return A.a(s,b3)
b4=b4!==s[b3]}if(b4)break;++a6
if(!(b3>=0))return A.a(p,b3)
p[b3]=(o|a6)>>>0
b2=b3}e=b2-1}return new A.l6(p,n)},
w6(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=a2.a,a0=a2.b,a1=a2.c
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
e=c}++g}return new A.l_(n,m,k,j,i)},
tl(a,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i=new Float64Array(280),h=new Float64Array(256),g=new Float64Array(256),f=new Float64Array(256),e=new Float64Array(40),d=a.a,c=a.b,b=a.c
for(s=b.length,r=c.length,q=a1.length,p=a0.length,o=a2.length,n=a3.length,m=0;m<d;){if(!(m>=0&&m<r))return A.a(c,m)
l=c[m]
if(l<=1){if(!(m<q))return A.a(a1,m)
k=a1[m]
B.q.i(i,k,B.q.l(i,k)+1)
if(!(m<p))return A.a(a0,m)
k=a0[m]
B.q.i(h,k,B.q.l(h,k)+1)
if(!(m<o))return A.a(a2,m)
k=a2[m]
B.q.i(g,k,B.q.l(g,k)+1)
if(!(m<n))return A.a(a3,m)
k=a3[m]
B.q.i(f,k,B.q.l(f,k)+1);++m}else{k=A.iW(l)
if(!(k>=0&&k<280))return A.a(i,k)
j=i[k]
if(!(k<280))return A.a(i,k)
i[k]=j+1
if(!(m<s))return A.a(b,m)
j=A.iY(A.iS(a4,b[m]))
if(!(j>=0&&j<40))return A.a(e,j)
k=e[j]
if(!(j<40))return A.a(e,j)
e[j]=k+1
m+=l}}return new A.l2(A.it(i),A.it(h),A.it(g),A.it(f),A.it(e))},
it(a){var s,r,q,p,o,n,m,l
for(s=a.length,r=0,q=0;q<s;++q)r+=a[q]
if(r===0){p=new Float64Array(s)
B.q.a8(p,0,s,8)
return p}o=new Float64Array(s)
for(p=r+1,n=0;n<s;++n){m=a[n]
l=Math.log((m>0?m:1)/p)
if(!(n<s))return A.a(o,n)
o[n]=-(l/0.6931471805599453)}return o},
l_:function l_(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
l4:function l4(a,b,c){this.a=a
this.b=b
this.c=c},
l6:function l6(a,b){this.a=a
this.b=b},
ma:function ma(a){this.a=a},
lJ:function lJ(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.e=_.d=$},
l2:function l2(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=$},
l3:function l3(a){this.a=a},
ir:function ir(a,b){var _=this
_.a=0
_.b=!0
_.c=a
_.d=b
_.e=$},
is:function is(a){var _=this
_.a=a
_.d=_.c=_.b=0},
l1:function l1(a,b){this.a=a
this.b=b},
w8(a,b,c,d,e,f,g,h,i,j){var s,r,q,p,o,n,m,l
for(s=j.length,r=0,q=1/0,p=null,o=0;o<3;++o){n=B.dK[o]
m=new Int32Array(s)
if(n>0)A.vm(a,b,c,d,e,f,g,n,m)
else B.u.a8(m,0,s,-1)
l=A.uy(a,b,c,d,e,f,g,h,i,n,m)
if(l<q){p=m
q=l
r=n}}p.toString
B.u.dI(j,0,p)
return r},
vm(a,a0,a1,a2,a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=B.a.U(1,a6),e=new Uint32Array(f),d=new Uint8Array(f),c=new A.m5(a2,a,a0,a1),b=new A.m6(32-a6)
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
uy(a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=280+(b3>0?B.a.U(1,b3):0),b=t.p,a=A.I(c,0,!1,b),a0=A.I(256,0,!1,b),a1=A.I(256,0,!1,b),a2=A.I(256,0,!1,b),a3=A.I(40,0,!1,b)
for(b=a8.length,s=b0.length,r=b1.length,q=a5.length,p=a4.length,o=a6.length,n=a7.length,m=b4.length,l=a9.length,k=0,j=0,i=0;i<b;++i)if(a8[i]!==0){if(!(k<m))return A.a(b4,k)
h=b4[k]
g=k+1
if(!(k<l))return A.a(a9,k)
f=a9[k]
if(h>=0){e=280+h
if(!(e<c))return A.a(a,e)
B.c.i(a,e,a[e]+1)}else{if(!(f>=0&&f<q))return A.a(a5,f)
e=a5[f]
B.c.i(a,e,B.c.l(a,e)+1)
if(!(f<p))return A.a(a4,f)
e=a4[f]
B.c.i(a0,e,B.c.l(a0,e)+1)
if(!(f<o))return A.a(a6,f)
e=a6[f]
B.c.i(a1,e,B.c.l(a1,e)+1)
if(!(f<n))return A.a(a7,f)
e=a7[f]
B.c.i(a2,e,B.c.l(a2,e)+1)}k=g}else{if(!(j<s))return A.a(b0,j)
e=A.iW(b0[j])
if(!(e>=0&&e<c))return A.a(a,e)
B.c.i(a,e,a[e]+1)
if(!(j<r))return A.a(b1,j)
e=A.iY(A.iS(b2,b1[j]))
if(!(e>=0&&e<40))return A.a(a3,e)
B.c.i(a3,e,a3[e]+1);++j}d=A.iP(a)+A.iP(a0)+A.iP(a1)+A.iP(a2)+A.iP(a3)
for(c=[a,a0,a1,a2,a3],i=0;i<5;++i)for(b=B.c.gI(c[i]);b.E();)if(b.gO()>0)d+=4
return d},
iP(a){var s,r,q,p,o
for(s=a.length,r=0,q=0;q<s;++q)r+=a[q]
if(r===0)return 0
for(p=0,q=0;q<s;++q){o=a[q]
if(o>0)p-=o*(Math.log(o/r)/0.6931471805599453)}return p},
m5:function m5(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
m6:function m6(a){this.a=a},
no(a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
for(s=a2.length,r=a1.length,q=0,p=0,o=0;o<a3;++o){if(!(o<r))return A.a(a1,o)
n=a1[o]
n=n<128?n:n-256
if(!(o<s))return A.a(a2,o)
m=a2[o]
q+=n*(m<128?m:m-256)
p+=n*n}if(p===0)return 0
l=B.a.F(B.b.av(32*q/p),-128,127)
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
i=g}B.u.a8(a6,0,i,0)
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
w9(c1,c2,c3,c4,c5,c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7=B.a.S(1,c6),a8=B.a.j(c4+a7-1,c6),a9=B.a.j(c5+a7-1,c6),b0=A.j([],t.l3),b1=new Uint32Array(512),b2=new Uint32Array(512),b3=a7*a7,b4=new Uint8Array(b3),b5=new Uint8Array(b3),b6=new Uint8Array(b3),b7=new Uint8Array(b3),b8=new Int32Array(6),b9=new Int32Array(6),c0=new Int32Array(6)
for(s=c2.length,r=c1.length,q=c3.length,p=0;p<a9;++p)for(o=p*a7,n=o+a7,m=0;m<a8;++m){l=m*a7
k=l+a7
k=k<c4?k:c4
j=n<c5?n:c5
for(i=o,h=0;i<j;++i){g=i*c4
for(f=l;f<k;++f){e=g+f
if(!(e>=0&&e<s))return A.a(c2,e)
B.d.i(b4,h,c2[e])
if(!(e<r))return A.a(c1,e)
B.d.i(b5,h,c1[e])
if(!(e<q))return A.a(c3,e)
B.d.i(b6,h,c3[e]);++h}}d=A.no(b4,b5,h,b8,b9,c0)
c=A.no(b4,b6,h,b8,b9,c0)
for(b=c-256,a=c<128,a0=0;a0<h;++a0){if(!(a0<b3))return A.a(b6,a0)
a1=b6[a0]
a2=b4[a0]
a3=a?c:b
a2=B.a.j(a3*(a2<128?a2:a2-256),5)
if(!(a0<b3))return A.a(b7,a0)
b7[a0]=a1-a2&255}a4=A.no(b5,b7,h,b8,b9,c0)
B.c.C(b0,new A.fo(d,c,a4))
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
b2[a3]=a5+1}}return A.m_(b1,256,0)+A.m_(b1,256,256)-A.m_(b2,256,0)-A.m_(b2,256,256)>a8*a9*24?b0:null},
m_(a,b,c){var s,r,q,p,o
for(s=0,r=0;r<b;++r){q=c+r
if(!(q<512))return A.a(a,q)
s+=a[q]}if(s===0)return 0
for(p=0,r=0;r<b;++r){q=c+r
if(!(q<512))return A.a(a,q)
o=a[q]
if(o>0)p-=o*(Math.log(o/s)/0.6931471805599453)}return p},
vq(a,b,c,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=B.a.j(a0+B.a.S(1,a2)-1,a2)
for(s=c.$flags|0,r=a.$flags|0,q=c.length,p=b.length,o=a3.length,n=a.length,m=0;m<a1;++m)for(l=m*a0,k=0;k<a0;++k){j=l+k
i=B.a.a6(m,a2)*d+B.a.a6(k,a2)
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
fo:function fo(a,b,c){this.a=a
this.b=b
this.c=c},
tn(a,b){return B.a.aJ(a+B.a.U(1,b)-1,b)},
tm(a,b){var s,r,q,p,o,n,m,l,k=b.a,j=b.b,i=b.c
for(s=j.$flags|0,r=a.a,q=r.length,p=i.$flags|0,o=0;o<k;){if(!(o>=0&&o<q))return A.a(r,o)
n=r[o]&4095
m=n>=3?n:1
s&2&&A.b(j)
if(!(o<j.length))return A.a(j,o)
j[o]=m
l=r[o]
p&2&&A.b(i)
if(!(o<i.length))return A.a(i,o)
i[o]=l>>>12
o+=m}},
l5:function l5(a){this.a=a},
lK:function lK(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
iD:function iD(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.z=_.y=_.x=_.w=_.r=$},
fq(a){var s=new Float64Array(5),r=new Int32Array(5),q=new Int32Array(5),p=A.I(5,$.q1(),!1,t.k),o=new Int32Array(5),n=new Uint32Array(a),m=new Uint32Array(256),l=new Uint32Array(256),k=new Uint32Array(256)
return new A.fp(a,n,m,l,k,new Uint32Array(40),s,r,q,p,o)},
vx(a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=null,a6=a7.length
if(a6<2)return a5
s=t.cy
r=A.j([],s)
q=new Int32Array(a6)
for(p=0;p<a6;++p){o=a7[p]
if(o.gcg()===0){q[p]=0
if(r.length===0){n=A.fq(o.a)
o.cR(n)
B.c.C(r,n)}continue}for(m=-1,l=1/0,k=0;j=r.length,k<j;++k){j=r[k].hJ(o)
if(!(k<r.length))return A.a(r,k)
i=j-r[k].gcg()-o.gcg()
if(i<l){l=i
m=k}}if(m>=0)h=l>160&&j<16
else h=!0
if(h){q[p]=j
n=A.fq(o.a)
o.cR(n)
B.c.C(r,n)}else{q[p]=m
if(!(m>=0&&m<j))return A.a(r,m)
o.cR(r[m])}}if(r.length<2)return a5
g=B.c.ghC(a7).a
f=r.length
e=J.af(f,t.d)
for(d=0;d<f;++d)e[d]=A.fq(g)
for(p=0;p<a6;++p){o=a7[p]
if(o.gcg()===0)q[p]=p>0?q[p-1]:0
else{for(c=0,l=1/0,k=0;k<r.length;++k){j=r[k].hJ(o)
if(!(k<r.length))return A.a(r,k)
i=j-r[k].gcg()
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
q[p]=a[s]}B.c.cT(r)
B.c.cf(r,a0)
a1=A.fq(g)
for(d=0;d<a6;++d)a7[d].cR(a1)
for(s=r.length,a2=0,d=0;j=r.length,d<j;r.length===s||(0,A.L)(r),++d)a2+=r[d].gcg()
a3=new Uint32Array(j)
for(d=0;d<a6;++d){k=q[d]
if(!(k>=0&&k<j))return A.a(a3,k)
a3[k]=a3[k]+1}for(a4=0,d=0;d<j;++d){n=a3[d]
if(n>0)a4-=n*(Math.log(n/a6)/0.6931471805599453)}a2+=a4+160
return a2<a1.gcg()?new A.l0(q,r.length,a2):a5},
m2:function m2(){},
fp:function fp(a,b,c,d,e,f,g,h,i,j,k){var _=this
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
l0:function l0(a,b,c){this.a=a
this.b=b
this.c=c},
iW(a){var s,r
if(a<=4)return 255+a
s=a-1
r=A.m1(s)
return 256+2*r+(B.a.aJ(s,r-1)&1)},
pD(a){var s,r
if(a<=4)return B.cA
s=a-1
r=A.m1(s)-1
return new A.d1(r,s-B.a.U(2+(B.a.aJ(s,r)&1),r))},
iS(a,b){var s,r=B.a.aa(b,a),q=b-r*a
if(q<=8&&r<8){s=r*16+8-q
if(!(s>=0&&s<128))return A.a(B.am,s)
return B.am[s]+1}else if(q>a-8&&r<7){s=(r+1)*16+8+a-q
if(!(s>=0&&s<128))return A.a(B.am,s)
return B.am[s]+1}return b+120},
iY(a){var s,r=a-1
if(r<4)return r
s=A.m1(r)
return 2*s+(B.a.aJ(r,s-1)&1)},
pI(a){var s,r=a-1
if(r<4)return B.cA
s=A.m1(r)-1
return new A.d1(s,r-B.a.U(2+(B.a.aJ(r,s)&1),s))},
m1(a){var s
for(s=0;a>1;){a=B.a.j(a,1);++s}return s},
e1(a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=t.p,a2=A.I(a6,0,!1,a1),a3=t.t,a4=A.j([],a3)
for(s=0;s<a6;++s){if(!(s<a5.length))return A.a(a5,s)
if(a5[s]>0)B.c.C(a4,s)}r=a4.length
if(r===0){B.c.i(a2,0,1)
return a2}if(r===1){if(0>=r)return A.a(a4,0)
B.c.i(a2,a4[0],1)
return a2}q=2*r
p=A.I(q,0,!1,a1)
o=A.I(q,-1,!1,a1)
n=A.I(q,-1,!1,a1)
for(m=1;;m*=2){for(s=0;l=a4.length,s<l;++s){a1=a4[s]
if(!(a1<a5.length))return A.a(a5,a1)
B.c.i(p,s,a5[a1])
if(!(s<q))return A.a(p,s)
if(p[s]<m)B.c.i(p,s,m)}a1=A.j(new Array(l),a3)
for(s=0;s<l;++s)a1[s]=s
B.c.eG(a1,new A.m8(p))
for(r=A.ak(a1).c,k=a1.$flags|0;a1.length>1;l=h){j=B.c.hQ(a1,0)
i=B.c.hQ(a1,0)
h=l+1
if(!(j<q))return A.a(p,j)
g=p[j]
if(!(i<q))return A.a(p,i)
B.c.i(p,l,g+p[i])
B.c.i(o,l,j)
B.c.i(n,l,i)
g=a1.length
f=0
for(;;){if(f<g){e=a1[f]
if(!(e<q))return A.a(p,e)
e=p[e]
if(!(l<q))return A.a(p,l)
e=e<=p[l]}else e=!1
if(!e)break;++f}r.a(l)
k&1&&A.b(a1,"insert",2)
if(f>g)A.a3(A.n7(f,null))
a1.splice(f,0,l)}d=A.j([a1[0]],a3)
c=A.j([0],a3)
for(b=0;a1=d.length,a1!==0;){if(0>=a1)return A.a(d,-1)
a=d.pop()
if(0>=c.length)return A.a(c,-1)
a0=c.pop()
if(!(a>=0&&a<q))return A.a(o,a)
a1=o[a]
if(a1===-1){if(!(a<a4.length))return A.a(a4,a)
B.c.i(a2,a4[a],a0)
if(a0>b)b=a0}else{B.c.C(d,a1)
if(!(a<q))return A.a(n,a)
B.c.C(d,n[a])
a1=a0+1
B.c.C(c,a1)
B.c.C(c,a1)}}if(b<=a7)break}return a2},
fV(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=A.j([],t.t)
for(s=c.length,r=0;r<b;++r){if(!(r<s))return A.a(c,r)
if(c[r]>0)B.c.C(e,r)}s=e.length
if(s<=2)s=s===0||B.c.gem(e)<=255
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
a.T(e[1],8)}else B.c.i(c,q,0)
return}p=A.ur(c,b)
o=A.I(19,0,!1,t.p)
for(s=p.length,n=0;n<p.length;p.length===s||(0,A.L)(p),++n){m=p[n].a
if(!(m>=0&&m<19))return A.a(o,m)
B.c.i(o,m,o[m]+1)}l=A.e1(o,19,7)
k=A.e2(new Int32Array(A.p(l)),19)
s=l.length
r=18
for(;;){if(!(r>=4)){j=4
break}m=B.ap[r]
if(!(m<s))return A.a(l,m)
if(l[m]!==0){j=r+1
break}--r}a.T(0,1)
a.T(j-4,4)
for(r=0;r<j;++r){m=B.ap[r]
if(!(m<s))return A.a(l,m)
a.T(l[m],3)}a.T(0,1)
for(m=p.length,i=k.length,n=0;n<p.length;p.length===m||(0,A.L)(p),++n){h=p[n]
g=h.a
if(!(g>=0&&g<i))return A.a(k,g)
f=k[g]
if(!(g<s))return A.a(l,g)
a.T(f,l[g])
g=h.b
if(g>0)a.T(h.c,g)}s=e.length
if(s===1){if(0>=s)return A.a(e,0)
B.c.i(c,e[0],0)}},
ur(a,b){var s,r,q,p,o,n,m,l,k,j=A.j([],t.cF)
for(s=a.length,r=0;r<b;){if(!(r>=0&&r<s))return A.a(a,r)
q=a[r]
if(q===0){p=0
for(;;){o=r+p
if(o<b){if(!(o<s))return A.a(a,o)
n=a[o]===0}else n=!1
if(!n)break;++p}for(m=p;m>0;)if(m>=11){l=B.a.F(m,11,138)
B.c.C(j,new A.bW(18,7,l-11))
m-=l}else if(m>=3){l=B.a.F(m,3,10)
B.c.C(j,new A.bW(17,3,l-3))
m-=l}else{B.c.C(j,new A.bW(0,0,0));--m}r=o}else{B.c.C(j,new A.bW(q,0,0));++r
for(;;){if(r<b){if(!(r>=0&&r<s))return A.a(a,r)
n=a[r]===q}else n=!1
if(!n)break
p=0
for(;;){o=r+p
if(o<b){if(!(o>=0&&o<s))return A.a(a,o)
n=a[o]===q&&p<6}else n=!1
if(!n)break;++p}if(p>=3)B.c.C(j,new A.bW(16,2,p-3))
else for(k=0;k<p;++k)B.c.C(j,new A.bW(q,0,0))
r=o}}}return j},
e2(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=t.p,g=A.I(b,0,!1,h)
for(s=a.length,r=0,q=0;q<b;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if(p>r)r=p}if(r===0)return g
o=r+1
n=A.I(o,0,!1,h)
for(q=0;q<b;++q){if(!(q<s))return A.a(a,q)
m=a[q]
if(m>0){if(!(m<o))return A.a(n,m)
B.c.i(n,m,n[m]+1)}}B.c.i(n,0,0)
l=A.I(o,0,!1,h)
for(k=0,j=1;j<=r;++j){h=j-1
if(!(h<o))return A.a(n,h)
k=k+n[h]<<1>>>0
B.c.i(l,j,k)}for(q=0;q<b;++q){if(!(q<s))return A.a(a,q)
i=a[q]
if(i>0){if(!(i<o))return A.a(l,i)
B.c.i(g,q,A.v7(l[i],i))
B.c.i(l,i,l[i]+1)}}return g},
v7(a,b){var s,r
for(s=0,r=0;r<b;++r){s=(s<<1|a&1)>>>0
a=a>>>1}return s},
m8:function m8(a){this.a=a},
bW:function bW(a,b,c){this.a=a
this.b=b
this.c=c},
bT(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
cV(a){if(a<0)return 0
if(a>255)return 255
return a},
l7(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
to(a,b,c){return 4278190080},
tp(a,b,c){return a},
tu(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return b[c]},
tv(a,b,c){var s=c+1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
tw(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
tx(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bT(A.bT(a,b[r]),s)},
ty(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return A.bT(a,b[s])},
tz(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return A.bT(a,b[c])},
tA(a,b,c){var s=c-1,r=b.length
if(!(s>=0&&s<r))return A.a(b,s)
s=b[s]
if(!(c>=0&&c<r))return A.a(b,c)
return A.bT(s,b[c])},
tB(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bT(s,b[r])},
tq(a,b,c){var s,r,q=c-1,p=b.length
if(!(q>=0&&q<p))return A.a(b,q)
q=b[q]
if(!(c>=0&&c<p))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<p))return A.a(b,r)
r=b[r]
return A.bT(A.bT(a,q),A.bT(s,r))},
tr(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return A.l7(s>>>24,a>>>24,r>>>24)+A.l7(s>>>16&255,a>>>16&255,r>>>16&255)+A.l7(s>>>8&255,a>>>8&255,r>>>8&255)+A.l7(s&255,a&255,r&255)<=0?s:a},
ts(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return(A.cV((a>>>24)+(s>>>24)-(r>>>24))<<24|A.cV((a>>>16&255)+(s>>>16&255)-(r>>>16&255))<<16|A.cV((a>>>8&255)+(s>>>8&255)-(r>>>8&255))<<8|A.cV((a&255)+(s&255)-(r&255)))>>>0},
tt(a,b,c){var s,r,q,p,o,n=b.length
if(!(c>=0&&c<n))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<n))return A.a(b,r)
r=b[r]
q=A.bT(a,s)
s=q>>>24
n=q>>>16&255
p=q>>>8&255
o=q>>>0&255
return(A.cV(s+B.a.V(s-(r>>>24),2))<<24|A.cV(n+B.a.V(n-(r>>>16&255),2))<<16|A.cV(p+B.a.V(p-(r>>>8&255),2))<<8|A.cV(o+B.a.V(o-(r&255),2)))>>>0},
cU:function cU(a,b){this.a=a
this.b=b},
iu:function iu(a){var _=this
_.a=a
_.c=_.b=0
_.d=null
_.e=0},
lb:function lb(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0
_.r=1
_.w=!1
_.x=$
_.y=!1},
nE(a){var s,r=a.length,q=new Uint8Array(r)
for(s=0;s<r;++s){if(!(s<r))return A.a(q,s)
q[s]=a.charCodeAt(s)}return q},
vp(a,b,c,d,e,f,g,h){var s,r,q=A.a0(!1,8192)
A.e_(q,g>>>1)
A.e_(q,h>>>1)
A.e_(q,f-1)
A.e_(q,e-1)
A.e_(q,B.a.F(c,0,16777215))
q.p(3)
for(s=d.length,r=0;r<d.length;d.length===s||(0,A.L)(d),++r)d[r].i2(q)
return J.C(B.d.gq(q.c),0,q.a)},
pq(a){var s,r,q,p,o,n
for(s=a.length,r=4,q=0;q<s;++q){p=a[q].b.length
o=(p&1)===1?1:0
r+=8+p+o}n=A.a0(!1,8192)
n.a2(A.nE("RIFF"))
n.K(r)
n.a2(A.nE("WEBP"))
for(s=a.length,q=0;q<a.length;a.length===s||(0,A.L)(a),++q)a[q].i2(n)
return J.C(B.d.gq(n.c),0,n.a)},
e_(a,b){a.p(b&255)
a.p(B.a.j(b,8)&255)
a.p(B.a.j(b,16)&255)},
bU:function bU(a,b){this.a=a
this.b=b},
fu:function fu(){},
hH:function hH(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.r=_.f=$
_.w=1
_.y=_.x=$},
mJ(a){var s,r=J.bL(a,t.a6)
for(s=0;s<a;++s)r[s]=new A.hj()
return new A.ep(r,0)},
qS(){var s,r,q=J.af(5,t.lJ)
for(s=0;s<5;++s)q[s]=A.mJ(0)
r=J.af(64,t.lq)
for(s=0;s<64;++s)r[s]=new A.hk()
return new A.eo(q,r)},
hj:function hj(){this.b=this.a=0},
hk:function hk(){this.b=this.a=0},
ep:function ep(a,b){this.a=a
this.b=b},
eo:function eo(a,b){var _=this
_.a=a
_.b=!1
_.c=0
_.e=_.d=!1
_.f=b},
eq:function eq(){var _=this
_.b=_.a=null
_.e=_.d=0},
hm:function hm(a){this.a=a
this.b=null},
dQ:function dQ(a,b){this.a=a
this.b=b},
bV:function bV(a,b){var _=this
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
eC:function eC(a,b){var _=this
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
lc:function lc(a){this.a=null
this.b=a
this.c=null},
lf:function lf(a,b){this.a=a
this.b=b},
ld:function ld(a,b){this.a=a
this.b=b},
le:function le(a,b,c){this.a=a
this.b=b
this.c=c},
tE(a){var s,r,q,p,o,n,m,l,k,j=null,i=t.g,h=0
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
if(p)throw A.f(A.l("WebP animation frames must fit the "+a.gN()+"x"+a.gJ()+" canvas, but frame "+h+" is "+q.gN()+"x"+q.gJ()+"."));++h}},
lh(a,b){var s
if(a==null)return 0
s=b.$1(a)
return B.a.F(B.b.av(s),0,255)},
tH(a){var s=a.c
if(s==null)return null
return s.b===B.S?s.c:A.mK(s).hv()},
tG(a){var s,r,q,p,o,n
for(s=a.gae(),r=s.length,q=0;q<s.length;s.length===r||(0,A.L)(s),++q){p=s[q]
if(!(p.gad()===2||p.gad()===4))continue
for(o=p.a,o=o.gI(o);o.E();){n=o.gO()
if(n.gv()!==n.gG())return!0}}return!1},
tF(a){var s
if(a.gbh().gd0(0))return null
s=A.a0(!1,8192)
a.gbh().aX(s)
return J.C(B.d.gq(s.c),0,s.a)},
lg:function lg(){},
li:function li(){},
lj:function lj(){},
lk:function lk(){},
ll:function ll(){},
mK(a){return new A.bH(a.a,a.b,B.d.ih(a.c,0))},
hn:function hn(a,b){this.a=a
this.b=b},
bH:function bH(a,b,c){this.a=a
this.b=b
this.c=c},
V(a,b,c,d,e,f,g,h,i,j,k,l,m){var s,r=null,q=new A.an(r,r,r,a,h,e,d,0)
B.c.C(q.gae(),q)
if(l<0||f<0)A.a3(A.aX("Invalid image dimensions "+l+"x"+f,r))
q.c=g
if(b!=null)q.e=A.ee(b)
s=!1
if(j==null)if(m)s=q.gL()===B.A||q.gL()===B.w||q.gL()===B.B||q.gL()===B.e||q.gL()===B.n
q.f8(l,f,c,i,s?q.jb(c,k,i):j)
return q},
hs(a,b,c,d){var s,r,q,p,o=null,n=a.e
n=n==null?o:A.ee(n)
s=a.c
s=s==null?o:A.mK(s)
r=a.w
q=a.r
p=a.f
p=p==null?o:new A.bd(new Uint8Array(A.p(p.a)))
r=new A.an(o,s,n,p,q,r,a.y,a.z)
r.iz(a,b,c,d)
return r},
aQ(a,b,c){var s,r,q,p,o,n=null,m=a.a
m=m==null?n:m.bp(c)
s=a.e
s=s==null?n:A.ee(s)
r=a.c
r=r==null?n:A.mK(r)
q=a.w
p=a.r
o=a.f
o=o==null?n:new A.bd(new Uint8Array(A.p(o.a)))
q=new A.an(m,r,s,o,p,q,a.y,a.z)
q.iy(a,b,c)
return q},
hi:function hi(a,b){this.a=a
this.b=b},
an:function an(a,b,c,d,e,f,g,h){var _=this
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
jD:function jD(a,b){this.a=a
this.b=b},
jC:function jC(){},
ao:function ao(){},
qU(a,b,c){return new A.dm(new Uint16Array(a*b*c),a,b,c)},
dm:function dm(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
qV(a,b,c){return new A.dn(new Float32Array(a*b*c),a,b,c)},
dn:function dn(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
er:function er(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
es:function es(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
et:function et(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
eu:function eu(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dp:function dp(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
cx:function cx(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
dq:function dq(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
qW(a,b,c){return new A.dr(new Uint32Array(a*b*c),a,b,c)},
dr:function dr(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
ds:function ds(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
oi(a,b,c){return new A.dt(new Uint8Array(a*b*c),null,a,b,c)},
dt:function dt(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
eD:function eD(a,b){this.a=a
this.b=b},
b2:function b2(){},
eZ:function eZ(a,b,c){this.c=a
this.a=b
this.b=c},
f_:function f_(a,b,c){this.c=a
this.a=b
this.b=c},
f0:function f0(a,b,c){this.c=a
this.a=b
this.b=c},
f1:function f1(a,b,c){this.c=a
this.a=b
this.b=c},
f2:function f2(a,b,c){this.c=a
this.a=b
this.b=c},
f3:function f3(a,b,c){this.c=a
this.a=b
this.b=c},
f4:function f4(a,b,c){this.c=a
this.a=b
this.b=c},
dC:function dC(a,b,c){this.c=a
this.a=b
this.b=c},
ow(a){return new A.aT(new Uint8Array(A.p(a.c)),a.a,a.b)},
aT:function aT(a,b,c){this.c=a
this.a=b
this.b=c},
mS(a){return new A.cF(-1,0,-a.c,a)},
cF:function cF(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mT(a){return new A.cG(-1,0,-a.c,a)},
cG:function cG(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mU(a){return new A.cH(-1,0,-a.c,a)},
cH:function cH(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mV(a){return new A.cI(-1,0,-a.c,a)},
cI:function cI(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mW(a){return new A.cJ(-1,0,-a.c,a)},
cJ:function cJ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
mX(a){return new A.cK(-1,0,-a.c,a)},
cK:function cK(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
bj(a,b,c,d,e){a.a9(b-1,c)
return new A.hX(a,b,b+d-1,c+e-1)},
hX:function hX(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
f5(a){return new A.cL(-1,0,0,-1,0,a)},
cL:function cL(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
mY(a){return new A.cM(-1,0,-a.c,a)},
cM:function cM(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
f6(a){return new A.cN(-1,0,0,-2,0,a)},
cN:function cN(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
mZ(a){return new A.cO(-1,0,-a.c,a)},
cO:function cO(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
f7(a){return new A.cP(-1,0,0,-(a.c<<2>>>0),a)},
cP:function cP(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
k6(a){return new A.cQ(-1,0,-a.c,a)},
cQ:function cQ(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
E:function E(){},
pr(a,b){var s
if(b===B.a4)s=A.ba(a)>0
else s=a.gL()===B.e&&!a.gaw()
return s},
pG(a,b){return b>=5&&b<=8?a.gJ():a.gN()},
pF(a,b){return b>=5&&b<=8?a.gN():a.gJ()},
w7(a,b,c,d,e,f,g,h,i,j,k,l){var s,r,q,p,o
if(!A.pr(a,c))return!1
s=a.Y()
r=A.ba(a)
q=new A.lL(s,r,A.pG(a,l),A.pF(a,l))
q.iI(a,l)
p=b.Y()
o=b.a.gaz()
if(c===B.a4){if(A.ba(b)!==r)return!1
A.v6(q,p,o,d,e,f,g,j,k)
return!0}if(b.gL()!==B.e||b.a.c!==a.a.c)return!1
switch(c.a){case 1:A.v5(q,p,o,d,e,f,g,h,i)
return!0
case 3:A.v3(q,p,o,d,e,f,g,h,i)
return!0
case 2:A.v4(q,p,o,d,e,f,g,h,i)
return!0
case 0:return!1}},
v6(a,b,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=a.b,d=a.a,c=new Int32Array(a3)
for(s=a5.length,r=a.f,q=0;q<a3;++q){if(!(q<s))return A.a(a5,q)
p=a5[q]
r===$&&A.c("colStep")
if(!(q<a3))return A.a(c,q)
c[q]=p*r}for(s=d.length,r=b.$flags|0,p=a6.length,o=a.e,n=a.r,m=a1*e,l=0;l<a4;++l){if(!(l<p))return A.a(a6,l)
k=a6[l]
o===$&&A.c("base")
n===$&&A.c("rowStep")
j=o+k*n
i=(a2+l)*a0+m
for(q=0;q<a3;++q){h=j+c[q]
for(g=0;g<e;++g,i=f){f=i+1
k=h+g
if(!(k>=0&&k<s))return A.a(d,k)
k=d[k]
r&2&&A.b(b)
if(!(i>=0&&i<b.length))return A.a(b,i)
b[i]=k}}}},
v5(a,b,a0,a1,a2,a3,a4,a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h=a.b,g=a.c-1,f=a.d-1,e=new Int32Array(a3),d=new Int32Array(a3),c=new Float64Array(a3)
for(s=0;s<a3;++s){r=s*a5
q=B.b.h(r)
if(!(s<a3))return A.a(c,s)
c[s]=r-q
p=a.f
p===$&&A.c("colStep")
if(!(s<a3))return A.a(e,s)
e[s]=q*p
o=B.a.F(q+1,0,g)
if(!(s<a3))return A.a(d,s)
d[s]=o*p}for(p=a.a,o=a1*h,n=0;n<a4;++n){m=n*a6
l=B.b.h(m)
k=B.a.F(l+1,0,f)
j=a.e
j===$&&A.c("base")
i=a.r
i===$&&A.c("rowStep")
A.uW(p,j+l*i,j+k*i,b,(a2+n)*a0+o,h,a3,e,d,c,m-l)}},
uW(a,b,a0,a1,a2,a3,a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c
for(s=a.length,r=a5.length,q=a6.length,p=a7.length,o=0;o<a4;++o){if(!(o<r))return A.a(a5,o)
n=a5[o]
m=b+n
if(!(o<q))return A.a(a6,o)
l=a6[o]
k=b+l
j=a0+n
i=a0+l
if(!(o<p))return A.a(a7,o)
h=a7[o]
for(g=0;g<a3;++g,a2=c){n=m+g
if(!(n>=0&&n<s))return A.a(a,n)
f=a[n]
e=B.d.l(a,k+g)
n=j+g
if(!(n>=0&&n<s))return A.a(a,n)
d=a[n]
c=a2+1
n=B.b.h(f+h*(e-f+a8*(f+B.d.l(a,i+g)-d-e))+a8*(d-f))
a1.$flags&2&&A.b(a1)
if(!(a2>=0&&a2<a1.length))return A.a(a1,a2)
a1[a2]=n}}},
v3(a5,a6,a7,a8,a9,b0,b1,b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=a5.b,a3=new Int32Array(b0),a4=new Int32Array(b0)
for(s=0;s<b0;s=q){r=B.b.h(s*b2)
q=s+1
p=B.b.h(q*b2)
if(p===r)++p
if(!(s<b0))return A.a(a3,s)
a3[s]=r
if(!(s<b0))return A.a(a4,s)
a4[s]=p}o=new Int32Array(a2)
for(n=a5.a,m=a8*a2,l=0;l<b1;l=j){k=B.b.h(l*b3)
j=l+1
i=B.b.h(j*b3)
if(i===k)++i
h=(a9+l)*a7+m
for(g=i-k,s=0;s<b0;++s){r=a3[s]
p=a4[s]
for(f=0;f<a2;++f){if(!(f<a2))return A.a(o,f)
o[f]=0}for(e=p-r,d=k;d<i;++d){c=a5.e
c===$&&A.c("base")
b=a5.r
b===$&&A.c("rowStep")
a=a5.f
a===$&&A.c("colStep")
A.vj(n,c+d*b+r*a,e,a,a2,o)}a0=1/(g*e)
for(e=a6.$flags|0,f=0;f<a2;++f,h=a1){a1=h+1
c=B.b.h(o[f]*a0)
e&2&&A.b(a6)
if(!(h>=0&&h<a6.length))return A.a(a6,h)
a6[h]=c}}}},
vj(a,b,c,d,e,f){var s,r,q,p,o,n,m
for(s=f.length,r=a.length,q=f.$flags|0,p=0;p<c;++p,b+=d)for(o=0;o<e;++o){if(!(o<s))return A.a(f,o)
n=f[o]
m=b+o
if(!(m>=0&&m<r))return A.a(a,m)
m=a[m]
q&2&&A.b(f)
f[o]=n+m}},
v4(c0,c1,c2,c3,c4,c5,c6,c7,c8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=c0.b,b5=c0.a,b6=c5*4,b7=new Int32Array(b6),b8=new Uint8Array(b6),b9=new Float64Array(c5)
for(s=c0.f,r=c0.c,q=0;q<c5;++q){p=q*c7
o=B.b.h(p)
if(!(q<c5))return A.a(b9,q)
b9[q]=p-o
for(n=q*4,m=0;m<4;++m){l=o+m-1
k=n+m
s===$&&A.c("colStep")
if(!(k<b6))return A.a(b7,k)
b7[k]=l*s
j=l<0||l>=r?0:1
if(!(k<b6))return A.a(b8,k)
b8[k]=j}}i=new Int32Array(4)
h=new Uint8Array(4)
g=new Int32Array(16)
f=new Float64Array(4)
for(s=c1.$flags|0,r=b5.length,n=c3*b4,k=c0.e,j=c0.r,e=c0.d,d=0;d<c6;++d){c=d*c8
b=B.b.h(c)
a=c-b
for(m=0;m<4;++m){a0=b+m-1
k===$&&A.c("base")
j===$&&A.c("rowStep")
if(!(m<4))return A.a(i,m)
i[m]=k+a0*j
a1=a0<0||a0>=e?0:1
if(!(m<4))return A.a(h,m)
h[m]=a1}a2=(c4+d)*c2+n
for(q=0;q<c5;++q){a1=i[1]
a3=q*4
a4=a3+1
if(!(a4<b6))return A.a(b7,a4)
a5=a1+b7[a4]
for(a6=0;a6<4;++a6)for(a1=a6*4,m=0;m<4;++m){a4=a1+m
if(h[a6]!==0){a7=a3+m
if(!(a7<b6))return A.a(b8,a7)
a7=b8[a7]===0}else a7=!0
if(a7)a7=a5
else{a7=i[a6]
a8=a3+m
if(!(a8<b6))return A.a(b7,a8)
a8=a7+b7[a8]
a7=a8}if(!(a4<16))return A.a(g,a4)
g[a4]=a7}a9=b9[q]
for(b0=0;b0<b4;++b0,a2=b3){for(a6=0;a6<4;++a6){b1=a6*4
if(!(b1<16))return A.a(g,b1)
a1=g[b1]+b0
if(!(a1>=0&&a1<r))return A.a(b5,a1)
a1=b5[a1]
a3=b1+1
if(!(a3<16))return A.a(g,a3)
a3=g[a3]+b0
if(!(a3>=0&&a3<r))return A.a(b5,a3)
a3=b5[a3]
a4=b1+2
if(!(a4<16))return A.a(g,a4)
a4=g[a4]+b0
if(!(a4>=0&&a4<r))return A.a(b5,a4)
a4=b5[a4]
a7=b1+3
if(!(a7<16))return A.a(g,a7)
a7=g[a7]+b0
if(!(a7>=0&&a7<r))return A.a(b5,a7)
a7=A.p9(a9,a1,a3,a4,b5[a7])
if(!(a6<4))return A.a(f,a6)
f[a6]=a7}b2=A.p9(a,f[0],f[1],f[2],f[3])
b3=a2+1
if(b2<0)a1=0
else a1=b2>255?255:B.b.h(b2)
s&2&&A.b(c1)
if(!(a2>=0&&a2<c1.length))return A.a(c1,a2)
c1[a2]=a1}}}},
p9(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
lL:function lL(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.r=_.f=_.e=$},
vB(f1,f2,f3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2,e3,e4,e5,e6,e7,e8=null,e9="ifd0",f0={}
f0.a=s
f0.a=B.a4
r=f3==null
if(r&&f2==null)throw A.f(A.l("Invalid size"))
f1.gaw()
q=1
if(f1.gbh().l(0,e9).a.ac(274)&&f1.gbh().l(0,e9).gbU()!==1){p=f1.gbh().l(0,e9).gbU()
p.toString
if(p>=2&&p<=8&&B.c.m9(f1.gae(),new A.mb(f0)))q=p
else f1=A.pp(f1)}o=A.pG(f1,q)
n=A.pF(f1,q)
if(f2==null||f2<=0){f3.toString
f2=B.b.av(f3*(n/o))}if(r||f3<=0)f3=B.b.av(f2*(o/n))
if(f3===o&&f2===n)return q===1?A.aQ(f1,!1,!1):A.pp(f1)
m=new Int32Array(f3)
for(l=0;l<f3;++l){r=B.a.aa(l*o,f3)
if(!(l<f3))return A.a(m,l)
m[l]=r}k=new Int32Array(f2)
for(j=0;j<f2;++j){r=B.a.aa(j*n,f2)
if(!(j<f2))return A.a(k,j)
k[j]=r}i=f1.gae().length
for(r=q>=5,p=t.g,h=q<=8,g=e8,f=0;f<i;++f){e=f1.x
if(e===$)e=f1.x=A.j([],p)
if(!(f<e.length))return A.a(e,f)
d=e[f]
c=A.hs(d,f2,!0,f3)
b=g==null
if(!b)g.aR(c)
if(b)g=c
b=r&&h
a=d.a
if(b){b=a==null?e8:a.a
if(b==null)b=0}else{b=a==null?e8:a.b
if(b==null)b=0}a0=b/f2
if(r&&h){b=a==null?e8:a.b
if(b==null)b=0}else{b=a==null?e8:a.a
if(b==null)b=0}a1=b/f3
if(A.w7(d,c,f0.a,0,0,f3,f2,a1,a0,m,k,q))continue
b=f0.a
if(b===B.dC){a2=d.ao(0,0)
for(j=0;j<f2;j=a4){a3=B.b.h(j*a0)
a4=j+1
a5=B.b.h(a4*a0)
if(a5===a3)++a5
for(l=0;l<f3;l=a7){a6=B.b.h(l*a1)
a7=l+1
a8=B.b.h(a7*a1)
if(a8===a6)++a8
for(a9=a3,b0=0,b1=0,b2=0,b3=0,b4=0;a9<a5;++a9)for(b5=a6;b5<a8;++b5,++b4){b=d.a
if(b!=null)b.P(b5,a9,a2)
b0+=a2.gt()
b1+=a2.gA()
b2+=a2.gB()
b3+=a2.gv()}b6=1/b4
b=c.a
if(b!=null)b.aA(l,j,b0*b6,b1*b6,b2*b6,b3*b6)}}}else if(b===B.a4){b=d.a
if((b==null?e8:b.gR())!=null)for(j=0;j<f2;++j){if(!(j<f2))return A.a(k,j)
b7=k[j]
for(l=0;l<f3;++l){if(!(l<f3))return A.a(m,l)
b=m[l]
a=d.a
b=a==null?e8:B.b.h(a.aU(b,b7).gW())
if(b==null)b=0
a=c.a
if(a!=null)a.aO(l,j,b)}}else{a2=d.ao(0,0)
for(j=0;j<f2;++j){if(!(j<f2))return A.a(k,j)
a9=k[j]
for(l=0;l<f3;++l){if(!(l<f3))return A.a(m,l)
b=m[l]
a=d.a
if(a!=null)a.P(b,a9,a2)
b=a2.gt()
a=a2.gA()
b8=a2.gB()
b9=a2.gv()
c0=c.a
if(c0!=null)c0.aA(l,j,b,a,b8,b9)}}}}else if(b===B.dB){c1=d.ao(0,0)
c2=d.ao(0,0)
c3=d.ao(0,0)
c4=d.ao(0,0)
b=d.a
a=b==null
b8=a?e8:b.a
c5=(b8==null?0:b8)-1
b=a?e8:b.b
c6=(b==null?0:b)-1
for(j=0;j<f2;++j){c7=j*a0
c8=B.b.h(c7)
c9=c7-c8
d0=B.a.F(c8+1,0,c6)
for(l=0;l<f3;++l){d1=l*a1
d2=B.b.h(d1)
d3=d1-d2
d4=B.a.F(d2+1,0,c5)
b=d.a
if(b!=null)b.P(d2,c8,c1)
b=d.a
if(b!=null)b.P(d2,d0,c2)
b=d.a
if(b!=null)b.P(d4,c8,c3)
b=d.a
if(b!=null)b.P(d4,d0,c4)
b=c1.gt()
a=c3.gt()
b8=c2.gt()
b9=c4.gt()
c0=c1.gA()
d5=c3.gA()
d6=c2.gA()
d7=c4.gA()
d8=c1.gB()
d9=c3.gB()
e0=c2.gB()
e1=c4.gB()
e2=c1.gv()
e3=c3.gv()
e4=c2.gv()
e5=c4.gv()
e6=c.a
if(e6!=null)e6.aA(l,j,b+d3*(a-b+c9*(b+b9-b8-a))+c9*(b8-b),c0+d3*(d5-c0+c9*(c0+d7-d6-d5))+c9*(d6-c0),d8+d3*(d9-d8+c9*(d8+e1-e0-d9))+c9*(e0-d8),e2+d3*(e3-e2+c9*(e2+e5-e4-e3))+c9*(e4-e2))}}}else for(j=0;j<f2;++j){e7=j*a0
for(l=0;l<f3;++l)c.c8(l,j,d.ew(l*a1,e7,f0.a))}}if(q!==1)g.gbh().l(0,e9).sbU(e8)
g.toString
return g},
mb:function mb(a){this.a=a},
vK(a,b){switch(b.a){case 0:A.mj(a)
break
case 1:A.py(a)
break
case 2:A.vL(a)
break}return a},
py(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=null,a2=a3.gae().length
for(s=t.g,r=0;r<a2;++r){q=a3.x
if(q===$)q=a3.x=A.j([],s)
if(!(r<q.length))return A.a(q,r)
p=q[r]
o=p.a
n=o==null
m=n?a1:o.a
if(m==null)m=0
l=n?a1:o.b
if(l==null)l=0
k=B.a.V(l,2)
if(!n){j=J.G(o.gq(o))
if(j==null){o=p.a
o=o==null?a1:o.gq(o)
if(o==null)o=B.d.gq(new Uint8Array(0))
j=J.G(o)}i=p.a.gaz()
h=new Uint8Array(i)
for(g=l-1,f=0;f<k;++f,--g){e=f*i
d=g*i
B.d.ab(h,0,i,j,e)
B.d.ab(j,e,e+i,j,d)
B.d.aB(j,d,d+i,h)}continue}o=a3.a
if((o==null?a1:o.gR())!=null)for(g=l-1,f=0;f<k;++f,--g)for(c=0;c<m;++c){o=p.a
b=o==null?a1:o.P(c,f,a1)
if(b==null)b=new A.E()
o=p.a
a=o==null?a1:o.P(c,g,a1)
if(a==null)a=new A.E()
a0=b.gW()
b.sW(a.gW())
a.sW(a0)}else for(g=l-1,f=0;f<k;++f,--g)for(c=0;c<m;++c){o=p.a
b=o==null?a1:o.P(c,f,a1)
if(b==null)b=new A.E()
o=p.a
a=o==null?a1:o.P(c,g,a1)
if(a==null)a=new A.E()
a0=b.gt()
b.st(a.gt())
a.st(a0)
a0=b.gA()
b.sA(a.gA())
a.sA(a0)
a0=b.gB()
b.sB(a.gB())
a.sB(a0)
a0=b.gv()
b.sv(a.gv())
a.sv(a0)}}return a3},
mj(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=null,a1=a2.gae().length
for(s=t.g,r=0;r<a1;++r){q=a2.x
if(q===$)q=a2.x=A.j([],s)
if(!(r<q.length))return A.a(q,r)
p=q[r]
o=p.a
n=o==null
m=n?a0:o.a
if(m==null)m=0
l=n?a0:o.b
if(l==null)l=0
k=B.a.V(m,2)
j=A.ba(p)
if(j>0){o=p.a
i=o==null?a0:J.G(o.gq(o))
if(i==null){o=p.a
o=o==null?a0:o.gq(o)
if(o==null)o=B.d.gq(new Uint8Array(0))
i=J.G(o)}h=p.a.gaz()
for(g=0;g<l;++g)A.pK(i,g*h,m,j)
continue}o=a2.a
if((o==null?a0:o.gR())!=null)for(f=m-1,g=0;g<l;++g)for(e=f,d=0;d<k;++d,--e){o=p.a
c=o==null?a0:o.P(d,g,a0)
if(c==null)c=new A.E()
o=p.a
b=o==null?a0:o.P(e,g,a0)
if(b==null)b=new A.E()
a=c.gW()
c.sW(b.gW())
b.sW(a)}else for(f=m-1,g=0;g<l;++g)for(e=f,d=0;d<k;++d,--e){o=p.a
c=o==null?a0:o.P(d,g,a0)
if(c==null)c=new A.E()
o=p.a
b=o==null?a0:o.P(e,g,a0)
if(b==null)b=new A.E()
a=c.gt()
c.st(b.gt())
b.st(a)
a=c.gA()
c.sA(b.gA())
b.sA(a)
a=c.gB()
c.sB(b.gB())
b.sB(a)
a=c.gv()
c.sv(b.gv())
b.sv(a)}}return a2},
vL(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=null,a0=a1.gae().length
for(s=t.g,r=0;r<a0;++r){q=a1.x
if(q===$)q=a1.x=A.j([],s)
if(!(r<q.length))return A.a(q,r)
p=q[r]
o=p.a
n=o==null
m=n?a:o.a
if(m==null)m=0
l=n?a:o.b
if(l==null)l=0
k=A.ba(p)
if(k>0){o=p.a
o=o==null?a:J.G(o.gq(o))
if(o==null){o=p.a
o=o==null?a:o.gq(o)
if(o==null)o=B.d.gq(new Uint8Array(0))
o=J.G(o)}A.pK(o,0,m*l,k)
continue}o=p.a
if((o==null?a:o.gR())!=null)for(j=l-1,i=m-1,h=0;h<=j;++h,--j){g=h===j?B.a.V(m,2):m
for(f=i,e=0;e<g;++e,--f){o=p.a
d=o==null?a:o.P(e,h,a)
if(d==null)d=new A.E()
o=p.a
c=o==null?a:o.P(f,j,a)
if(c==null)c=new A.E()
b=d.gW()
d.sW(c.gW())
c.sW(b)}}else for(j=l-1,i=m-1,h=0;h<=j;++h,--j){g=h===j?B.a.V(m,2):m
for(f=i,e=0;e<g;++e,--f){o=p.a
d=o==null?a:o.P(e,h,a)
if(d==null)d=new A.E()
o=p.a
c=o==null?a:o.P(f,j,a)
if(c==null)c=new A.E()
b=d.gt()
d.st(c.gt())
c.st(b)
b=d.gA()
d.sA(c.gA())
c.sA(b)
b=d.gB()
d.sB(c.gB())
c.sB(b)
b=d.gv()
d.sv(c.gv())
c.sv(b)}}}return a1},
jl:function jl(a,b){this.a=a
this.b=b},
l(a){return new A.ht(a)},
ht:function ht(a){this.a=a},
v(a,b,c,d){var s=J.ae(a),r=s.gu(a)
s=c==null?s.gu(a):d+c
return new A.ai(a,d,Math.min(r,s),d,b)},
w(a,b,c){var s=a.a,r=a.d,q=J.bC(s),p=b==null?a.c:a.d+c+b
return new A.ai(s,a.b,Math.min(q,p),r+c,a.e)},
ai:function ai(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
mR(a,b,c){var s=new Int32Array(256),r=new Int32Array(0),q=new Int32Array(65536)
s=new A.hT(c,s,r,q,new Uint16Array(65536))
s.kn(b)
s.hd(a)
return s},
hT:function hT(a,b,c,d,e){var _=this
_.a=$
_.b=a
_.c=16
_.d=3
_.f=_.e=$
_.r=null
_.Q=_.z=_.y=_.x=_.w=$
_.as=b
_.at=c
_.ax=d
_.ay=e
_.CW=_.ch=$},
a0(a,b){return new A.hV(a,new Uint8Array(b))},
hV:function hV(a,b){this.a=0
this.b=a
this.c=b},
ky:function ky(a,b){this.a=a
this.b=b},
id:function id(){},
b4:function b4(a,b){this.a=a
this.b=b},
hQ:function hQ(a,b){this.a=a
this.b=b},
jY:function jY(a){this.c=a},
jZ:function jZ(){},
eL:function eL(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
rc(a){var s=null,r=A.pu(a)
if(r==null)return s
return new A.hR(a,r.gN(),r.gJ(),A.nS(r,4,3).a,s,s,s)},
rd(a){var s,r,q,p,o,n,m=null,l=A.pu(a.a),k=l.gJ()>l.gN()?a.b:m,j=A.vB(l,k,l.gN()>=l.gJ()?a.b:m)
k=a.c
s=A.vG(k,j)
if(s==null)return m
r=new Uint8Array(A.p(s))
q=j.gN()
p=j.gJ()
o=l.gJ()
n=l.gN()
k=$.qc().mp(k,m)
return new A.hR(r,q,p,a.d?A.nS(j,4,3).a:m,k,o,n)},
hR:function hR(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
k1:function k1(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
lm:function lm(a,b,c){this.a=a
this.b=b
this.c=c},
fv:function fv(a,b){this.a=a
this.b=b},
nB(){var s=0,r=A.uX(t.w),q,p,o
var $async$nB=A.vn(function(a,b){if(a===1)return A.uk(b,r)
for(;;)switch(s){case 0:$.mw().hf(new A.eL("[native implementations worker]: Starting...",null,$.nG().$1(null),B.dH))
q=A.bz(v.G.self)
p=new A.mv()
if(typeof p=="function")A.a3(A.aX("Attempting to rewrap a JS function.",null))
o=function(c,d){return function(e){return c(d,e,arguments.length)}}(A.us,p)
o[$.nF()]=p
q.onmessage=o
return A.ul(null,r)}})
return A.um($async$nB,r)},
pl(a,b){var s,r,q
try{A.bz(v.G.self).postMessage(A.ny(A.mO(["label",a,"data",b],t.N,t.z)))}catch(q){s=A.br(q)
r=A.c0(q)
$.mw().hy(u.g+A.y(s)+", "+A.y(r))}},
v2(a,b,c){var s,r,q,p
a=a
if(a!=null)try{s=A.ny(a)
if(s!=null)a=s}catch(p){a=J.e7(a)}try{A.bz(v.G.self).postMessage(A.ny(A.mO(["label","stacktrace","origin",c,"error",a,"stacktrace",b.D(0)],t.N,t.X)))}catch(p){r=A.br(p)
q=A.c0(p)
$.mw().hy(u.g+A.y(r)+", "+A.y(q))}},
mv:function mv(){},
re(a){var s=B.m.mo(a,".")
if(s<0||s+1>=a.length)return a
return B.m.eK(a,s+1).toLowerCase()},
k2:function k2(a,b){this.a=a
this.b=b},
rT(a){throw A.f(A.bn("Uint64List not supported on the web."))},
qY(a,b,c){return J.mA(a,b,c)},
rU(a,b,c){var s=a.BYTES_PER_ELEMENT
c=A.bl(b,c,B.a.aa(a.byteLength,s))
return J.C(B.d.gq(a),a.byteOffset+b*s,(c-b)*s)},
oJ(a,b,c){return J.a1(a,b,c)},
qO(a){return J.nP(a,0,null)},
qP(a){return a.mX(0,0,null)},
pM(a){return v.mangledGlobalNames[a]},
pE(a,b,c){A.vw(c,t.q,"T","max")
return Math.max(c.a(a),c.a(b))},
vM(a){var s,r,q,p,o,n=a.gu(0)
for(s=1,r=0;n>0;){q=3800>n?n:3800
n-=q
while(--q,q>=0){p=a.b
p.toString
o=a.c++
if(!(o>=0&&o<p.length))return A.a(p,o)
s+=p[o]
r+=s}s=B.a.a5(s,65521)
r=B.a.a5(r,65521)}return(r<<16|s)>>>0},
bB(a,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=J.ae(a),b=c.gu(a)
a0^=4294967295
s=0
if(t.D.b(a)&&b>=16){r=$.qb()
q=a.BYTES_PER_ELEMENT
p=A.bl(0,null,B.a.aa(a.byteLength,q))
o=J.qf(B.d.gq(a),a.byteOffset+0*q,p*q)
while(b>=8){n=o.getUint32(s,!0)^a0
m=o.getUint32(s+4,!0)
l=r[1792+(n&255)]
k=r[1536+(n>>>8&255)]
j=r[1280+(n>>>16&255)]
i=1024+(n>>>24)
if(!(i<2048))return A.a(r,i)
i=r[i]
h=r[768+(m&255)]
g=r[512+(m>>>8&255)]
f=r[256+(m>>>16&255)]
e=m>>>24
if(!(e<2048))return A.a(r,e)
a0=l^k^j^i^h^g^f^r[e]
s+=8
b-=8}}while(b>=8){d=s+1
a0=B.C[(a0^c.l(a,s))&255]^a0>>>8
s=d+1
a0=B.C[(a0^c.l(a,d))&255]^a0>>>8
d=s+1
a0=B.C[(a0^c.l(a,s))&255]^a0>>>8
s=d+1
a0=B.C[(a0^c.l(a,d))&255]^a0>>>8
d=s+1
a0=B.C[(a0^c.l(a,s))&255]^a0>>>8
s=d+1
a0=B.C[(a0^c.l(a,d))&255]^a0>>>8
d=s+1
a0=B.C[(a0^c.l(a,s))&255]^a0>>>8
s=d+1
a0=B.C[(a0^c.l(a,d))&255]^a0>>>8
b-=8}if(b>0)do{d=s+1
a0=B.C[(a0^c.l(a,s))&255]^a0>>>8
if(--b,b>0){s=d
continue}else break}while(!0)
return(a0^4294967295)>>>0},
up(){var s,r,q,p,o,n,m,l=new Uint32Array(2048)
for(s=0;s<256;++s){r=B.C[s]
if(!(s<2048))return A.a(l,s)
l[s]=r}for(q=1;q<8;++q)for(r=(q-1)*256,p=q*256,s=0;s<256;++s){o=r+s
if(!(o>=0&&o<2048))return A.a(l,o)
n=l[o]
o=p+s
m=B.C[n&255]
if(!(o<2048))return A.a(l,o)
l[o]=(m^n>>>8)>>>0}return l},
iT(a,b){var s,r,q,p=B.l9.gc7()
p=A.t(p,A.m(p).m("e.E"))
for(s=1,r="";s<=b;++s,r=q){q=B.b.h(B.b.a5(a/Math.pow(83,b-s),83))
if(q>=0&&q<p.length){if(!(q>=0&&q<p.length))return A.a(p,q)
q=p[q]}else q=null
q=r+A.y(q)}return r.charCodeAt(0)==0?r:r},
nu(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n,m,l
if(j==null)j=0
if(k==null)k=0
if(i==null)i=b.gN()
if(h==null)h=b.gJ()
if(e==null)e=a.gN()<b.gN()?a.gN():b.gN()
if(d==null)d=a.gJ()<b.gJ()?a.gJ():b.gJ()
s=c===B.ae
if(!s&&a.gaw())a=a.dz(a.gad())
r=h/d
q=i/e
p=t.p
o=J.af(d,p)
for(n=0;n<d;++n)o[n]=k+B.b.h(n*r)
m=J.af(e,p)
for(l=0;l<e;++l)m[l]=j+B.b.h(l*q)
if(s)A.uv(b,a,f,g,e,d,m,o,null,B.bc)
else A.ut(b,a,f,g,e,d,m,o,c,!1,null,B.bc)
return a},
uv(a5,a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=a6.gN(),a3=a6.gJ(),a4=A.ba(a5)
if(a4>0&&A.ba(a6)===a4&&a5.gL()===a6.gL()&&a5.gaw()===a6.gaw()&&a7>=0&&a8>=0){s=a5.Y()
r=a6.Y()
q=a5.a.gaz()
p=a6.a.gaz()
o=Math.min(a9,a2-a7)
n=s.length
m=r.$flags|0
l=b1.length
k=b2.length
j=a7*a4
i=0
for(;;){if(!(i<b0&&a8+i<a3))break
if(!(i<k))return A.a(b2,i)
h=b2[i]*q
g=(a8+i)*p+j
for(f=0;f<o;++f){if(!(f<l))return A.a(b1,f)
e=h+b1[f]*a4
for(d=0;d<a4;++d,g=c){c=g+1
b=e+d
if(!(b>=0&&b<n))return A.a(s,b)
b=s[b]
m&2&&A.b(r)
if(!(g>=0&&g<r.length))return A.a(r,g)
r[g]=b}}++i}return}for(n=b1.length,m=b2.length,a=null,i=0;i<b0;++i)for(a0=a8+i,l=a0>=a3,f=0;f<a9;++f){a1=a7+f
if(a1>=a2||l)continue
if(!(f<n))return A.a(b1,f)
k=b1[f]
if(!(i<m))return A.a(b2,i)
j=b2[i]
b=a5.a
a=b==null?null:b.P(k,j,a)
if(a==null)a=new A.E()
a6.c8(a1,a0,a)}},
ut(a,b,c,d,e,f,g,h,i,j,a0,a1){var s,r,q,p,o,n,m,l,k
for(s=g.length,r=h.length,q=null,p=0;p<f;++p)for(o=d+p,n=0;n<e;++n){if(!(n<s))return A.a(g,n)
m=g[n]
if(!(p<r))return A.a(h,p)
l=h[p]
k=a.a
q=k==null?null:k.P(m,l,q)
if(q==null)q=new A.E()
A.vF(b,c+n,o,q,i,!1,a0,a1)}},
vF(a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7
if(!a8.hF(a9,b0))return a8
if(b2===B.ae||a8.gaw())if(a8.hF(a9,b0)){a8.aU(a9,b0).b9(b1)
return a8}s=b1.gal()
r=b1.gai()
q=b1.gak()
p=b1.gu(b1)<4?1:b1.ga1()
if(p===0)return a8
o=a8.aU(a9,b0)
n=o.gal()
m=o.gai()
l=o.gak()
k=o.ga1()
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
h=B.b.F(p,0.01,1)
i=p<0
d=i?0:1
c=B.b.F(s/h*d,0,0.99)
d=B.b.F(p,0.01,1)
h=i?0:1
b=B.b.F(r/d*h,0,0.99)
h=B.b.F(p,0.01,1)
i=i?0:1
a=B.b.F(q/h*i,0,0.99)
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
o.sal((s*p+n*k*a5)*a7)
o.sai((r*p+m*k*a5)*a7)
o.sak((q*p+l*k*a5)*a7)
o.sa1(a6)
return a8},
px(a,b,c,d,e,f,g){var s,r=B.b.F(Math.min(d,e),0,a.gN()-1),q=B.b.F(Math.min(f,g),0,a.gJ()-1),p=B.b.F(Math.max(d,e),0,a.gN()-1),o=B.b.F(Math.max(f,g),0,a.gJ()-1),n=a.a.bm(0,r,q,p-r+1,o-q+1)
for(s=n.a;n.E();)s.b9(c)
return a},
ci(a){if(a.gN()<1||a.gJ()<1||a.a==null)throw A.f(A.l("Cannot encode an empty image"))},
P(a,b){var s,r,q
try{r=a.$0()
return r}catch(q){s=A.br(q)
if(s instanceof A.ht)throw q
throw A.f(A.l("Invalid image data: "+A.y(s)))}},
qL(a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=b2<16384,a5=a8>b0?b0:a8
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
A.eg(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.eg(a,a6[b],q)
a2=q[0]
a3=q[1]
A.eg(a0,a2,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[e]=a
a6[d]=q[1]
A.eg(a1,a3,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[c]=a
a6[b]=q[1]}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.eh(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.eh(a,a6[b],q)
a2=q[0]
a3=q[1]
A.eh(a0,a2,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[e]=a
a6[d]=q[1]
A.eh(a1,a3,q)
a=q[0]
a6.$flags&2&&A.b(a6)
a6[c]=a
a6[b]=q[1]}}if(i){c=e+m
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.eg(a,a6[c],q)
a0=q[0]
a=q[1]
a6.$flags&2&&A.b(a6)
a6[c]=a}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.eh(a,a6[c],q)
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
A.eg(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.b(a6)
a6[d]=i}else{if(!(e>=0&&e<p))return A.a(a6,e)
i=a6[e]
if(!(d>=0&&d<p))return A.a(a6,d)
A.eh(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.b(a6)
a6[d]=i}a6.$flags&2&&A.b(a6)
if(!(e>=0&&e<p))return A.a(a6,e)
a6[e]=a0}}r=s>>>1}},
eg(a,b,c){var s,r,q,p,o=$.ay()
o.$flags&2&&A.b(o)
o[0]=a
s=$.aG()
if(0>=s.length)return A.a(s,0)
r=s[0]
o[0]=b
q=s[0]
p=r+(q&1)+B.a.j(q,1)
B.c.i(c,0,p)
B.c.i(c,1,p-q)},
eh(a,b,c){var s=a-B.a.j(b,1)&65535
B.c.i(c,1,s)
B.c.i(c,0,b+s-32768&65535)},
vJ(a){var s,r,q,p,o,n,m=a.toLowerCase()
if(B.m.bq(m,".jpg")||B.m.bq(m,".jpeg")){s=new Uint8Array(64)
r=new Uint8Array(64)
q=new Float32Array(64)
p=new Float32Array(64)
o=new Int32Array(64)
n=new Int32Array(64)
s=new A.jO(s,r,q,p,o,n,new Int32Array(2048))
s.e=s.dc(B.ck,B.ak)
s.f=s.dc(B.bS,B.ak)
s.r=s.dc(B.bu,B.bF)
s.w=s.dc(B.bK,B.c1)
s.km()
s.ia(100)
return s}if(B.m.bq(m,".png"))return A.rs()
if(B.m.bq(m,".tga"))return new A.kG()
if(B.m.bq(m,".gif"))return new A.jr()
if(B.m.bq(m,".tif")||B.m.bq(m,".tiff"))return new A.kL()
if(B.m.bq(m,".bmp"))return new A.j7()
if(B.m.bq(m,".ico"))return new A.hp()
if(B.m.bq(m,".cur"))return new A.hp()
if(B.m.bq(m,".pvr"))return new A.kv()
if(B.m.bq(m,".webp"))return new A.lg()
return null},
vI(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null,f=268435456,e=A.oq()
if(e.aT(a))return e
s=A.oy(g)
if(s.aT(a))return s
r=new A.jn(f)
if(r.aT(a))return r
q=new A.lc(f)
if(q.aT(a))return q
p=new A.kI(f)
if(p.fJ(A.v(a,!1,g,0),!0)!=null)return p
o=new A.kk(f)
if(o.aT(a))return o
if(A.qK(a))return new A.jg(f)
n=A.qq(!1,g)
if(n.aT(a))return n
m=A.I(A.r9(g),g,!1,t.jv)
l=new A.ke(new A.eK(m,t.p8),f)
if(l.aT(a))return l
k=new A.kC(f)
j=A.v(a,!1,g,0)
m=k.a=new A.fj(B.aC)
m.bV(j)
if(m.hH())return k
i=new A.ju(f)
if(i.aT(a))return i
h=new A.kr(f)
if(h.aT(a))return h
return g},
pu(a){var s=A.vI(a)
return s==null?null:s.bg(a,null)},
vG(a,b){var s=A.vJ(a)
if(s==null)return null
return s.bR(b)},
w4(b3,b4,b5,b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2
if($.nn==null){s=new Uint8Array(768)
for(r=0;r<256;++r){q=256+r
if(!(q<768))return A.a(s,q)
s[q]=r}for(r=256;r<512;++r){q=256+r
if(!(q<768))return A.a(s,q)
s[q]=255}$.nn=s}for(q=b4.length,p=b7.$flags|0,r=0;r<64;++r){o=b5+r
if(!(o<q))return A.a(b4,o)
o=b4[o]
n=b3[r]
p&2&&A.b(b7)
if(!(r<64))return A.a(b7,r)
b7[r]=o*n}for(m=0,r=0;r<8;++r,m+=8){q=1+m
if(!(q<64))return A.a(b7,q)
o=b7[q]
n=!1
if(o===0){l=2+m
if(!(l<64))return A.a(b7,l)
if(b7[l]===0){l=3+m
if(!(l<64))return A.a(b7,l)
if(b7[l]===0){l=4+m
if(!(l<64))return A.a(b7,l)
if(b7[l]===0){l=5+m
if(!(l<64))return A.a(b7,l)
if(b7[l]===0){l=6+m
if(!(l<64))return A.a(b7,l)
if(b7[l]===0){n=7+m
if(!(n<64))return A.a(b7,n)
n=b7[n]===0}}}}}}if(n){if(!(m<64))return A.a(b7,m)
q=B.a.j(5793*b7[m]+512,10)
k=(q&2147483647)-((q&2147483648)>>>0)
p&2&&A.b(b7)
if(!(m<64))return A.a(b7,m)
b7[m]=k
q=m+1
if(!(q<64))return A.a(b7,q)
b7[q]=k
q=m+2
if(!(q<64))return A.a(b7,q)
b7[q]=k
q=m+3
if(!(q<64))return A.a(b7,q)
b7[q]=k
q=m+4
if(!(q<64))return A.a(b7,q)
b7[q]=k
q=m+5
if(!(q<64))return A.a(b7,q)
b7[q]=k
q=m+6
if(!(q<64))return A.a(b7,q)
b7[q]=k
q=m+7
if(!(q<64))return A.a(b7,q)
b7[q]=k
continue}if(!(m<64))return A.a(b7,m)
n=B.a.j(5793*b7[m]+128,8)
j=(n&2147483647)-((n&2147483648)>>>0)
n=4+m
if(!(n<64))return A.a(b7,n)
l=B.a.j(5793*b7[n]+128,8)
i=(l&2147483647)-((l&2147483648)>>>0)
l=2+m
if(!(l<64))return A.a(b7,l)
h=b7[l]
g=6+m
if(!(g<64))return A.a(b7,g)
f=b7[g]
e=7+m
if(!(e<64))return A.a(b7,e)
d=b7[e]
c=B.a.j(2896*(o-d)+128,8)
b=(c&2147483647)-((c&2147483648)>>>0)
d=B.a.j(2896*(o+d)+128,8)
a=(d&2147483647)-((d&2147483648)>>>0)
d=3+m
if(!(d<64))return A.a(b7,d)
o=b7[d]<<4
a0=(o&2147483647)-((o&2147483648)>>>0)
o=5+m
if(!(o<64))return A.a(b7,o)
c=b7[o]<<4
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
p&2&&A.b(b7)
if(!(m<64))return A.a(b7,m)
b7[m]=j+k
if(!(e<64))return A.a(b7,e)
b7[e]=j-k
if(!(q<64))return A.a(b7,q)
b7[q]=i+a3
if(!(g<64))return A.a(b7,g)
b7[g]=i-a3
if(!(l<64))return A.a(b7,l)
b7[l]=c+a0
if(!(o<64))return A.a(b7,o)
b7[o]=c-a0
if(!(d<64))return A.a(b7,d)
b7[d]=a4+b
if(!(n<64))return A.a(b7,n)
b7[n]=a4-b}for(r=0;r<8;++r){a6=8+r
a7=16+r
a8=24+r
a9=32+r
b0=40+r
b1=48+r
b2=56+r
q=b7[a6]
if(q===0&&b7[a7]===0&&b7[a8]===0&&b7[a9]===0&&b7[b0]===0&&b7[b1]===0&&b7[b2]===0){q=B.a.j(5793*b7[r]+8192,14)
k=(q&2147483647)-((q&2147483648)>>>0)
p&2&&A.b(b7)
if(!(r<64))return A.a(b7,r)
b7[r]=k
if(!(a6<64))return A.a(b7,a6)
b7[a6]=k
if(!(a7<64))return A.a(b7,a7)
b7[a7]=k
if(!(a8<64))return A.a(b7,a8)
b7[a8]=k
if(!(a9<64))return A.a(b7,a9)
b7[a9]=k
if(!(b0<64))return A.a(b7,b0)
b7[b0]=k
if(!(b1<64))return A.a(b7,b1)
b7[b1]=k
if(!(b2<64))return A.a(b7,b2)
b7[b2]=k
continue}o=B.a.j(5793*b7[r]+2048,12)
j=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(5793*b7[a9]+2048,12)
i=(o&2147483647)-((o&2147483648)>>>0)
h=b7[a7]
f=b7[b1]
o=b7[b2]
n=B.a.j(2896*(q-o)+2048,12)
b=(n&2147483647)-((n&2147483648)>>>0)
o=B.a.j(2896*(q+o)+2048,12)
a=(o&2147483647)-((o&2147483648)>>>0)
a0=b7[a8]
a1=b7[b0]
o=B.a.j(j-i+1,1)
k=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(j+i+1,1)
j=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(h*3784+f*1567+2048,12)
q=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(h*1567-f*3784+2048,12)
h=(o&2147483647)-((o&2147483648)>>>0)
o=B.a.j(b-a1+1,1)
o=(o&2147483647)-((o&2147483648)>>>0)
n=B.a.j(b+a1+1,1)
b=(n&2147483647)-((n&2147483648)>>>0)
n=B.a.j(a+a0+1,1)
n=(n&2147483647)-((n&2147483648)>>>0)
l=B.a.j(a-a0+1,1)
a0=(l&2147483647)-((l&2147483648)>>>0)
l=B.a.j(j-q+1,1)
l=(l&2147483647)-((l&2147483648)>>>0)
q=B.a.j(j+q+1,1)
j=(q&2147483647)-((q&2147483648)>>>0)
q=B.a.j(k-h+1,1)
q=(q&2147483647)-((q&2147483648)>>>0)
g=B.a.j(k+h+1,1)
i=(g&2147483647)-((g&2147483648)>>>0)
g=B.a.j(b*2276+n*3406+2048,12)
k=(g&2147483647)-((g&2147483648)>>>0)
n=B.a.j(b*3406-n*2276+2048,12)
b=(n&2147483647)-((n&2147483648)>>>0)
n=B.a.j(a0*799+o*4017+2048,12)
n=(n&2147483647)-((n&2147483648)>>>0)
o=B.a.j(a0*4017-o*799+2048,12)
a0=(o&2147483647)-((o&2147483648)>>>0)
p&2&&A.b(b7)
if(!(r<64))return A.a(b7,r)
b7[r]=j+k
if(!(b2<64))return A.a(b7,b2)
b7[b2]=j-k
b7[a6]=i+n
b7[b1]=i-n
b7[a7]=q+a0
b7[b0]=q-a0
b7[a8]=l+b
b7[a9]=l-b}for(q=$.nn,p=b6.$flags|0,r=0;r<64;++r){q.toString
o=B.a.j(b7[r]+8,4)
o=384+((o&2147483647)-((o&2147483648)>>>0))
if(!(o>=0&&o<768))return A.a(q,o)
o=q[o]
p&2&&A.b(b6)
if(!(r<64))return A.a(b6,r)
b6[r]=o}},
cj(a,b){return(a&65535)*b+((a>>>16)*b&65535)*65536>>>0},
w1(d1,d2,d3,d4,d5,d6,d7,d8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5=d8.a,c6=d8.b,c7=d8.c,c8=d1.b,c9=c8.length,d0=c9<=5
for(s=0;s<c9;++s){r=c8[s]
d0=d0&&r>=1&&r<c5}q=d3.length
if(q<c5||d4.length<c5||d5.length<c5||d6.length<c5||d1.a.length!==c5||d2.ghI().length<=4095||!d0)throw A.f(A.aX("optimalCover needs "+c5+" of every array",null))
p=c5+1
o=new Float64Array(p)
B.q.a8(o,1,p,1/0)
n=new Uint16Array(p)
m=new Uint8Array(p)
l=d2.ghI()
k=d1.a
j=new Float64Array(c9)
for(s=0;s<c9;++s){i=d2.hw(c8[s],d7)
if(!(s<c9))return A.a(j,s)
j[s]=i}h=new Int32Array(c9)
g=1+c9
for(i=l.length,f=d4.length,e=d5.length,d=d6.length,c=k.length,b=d2.a,a=b.length,a0=d2.b,a1=a0.length,a2=d2.c,a3=a2.length,a4=d2.d,a5=a4.length,a6=0;a6<c5;a6=b3){a7=o[a6]
if(!(a6<f))return A.a(d4,a6)
a8=d4[a6]
if(!(a8<a))return A.a(b,a8)
a8=b[a8]
if(!(a6<q))return A.a(d3,a6)
a9=d3[a6]
if(!(a9<a1))return A.a(a0,a9)
a9=a0[a9]
if(!(a6<e))return A.a(d5,a6)
b0=d5[a6]
if(!(b0<a3))return A.a(a2,b0)
b0=a2[b0]
if(!(a6<d))return A.a(d6,a6)
b1=d6[a6]
if(!(b1<a5))return A.a(a4,b1)
b2=a7+(a8+a9+b0+a4[b1])
b3=a6+1
if(b2<o[b3]){if(!(b3<p))return A.a(o,b3)
o[b3]=b2
if(!(b3<p))return A.a(n,b3)
n[b3]=1}for(b4=0;b4<g;++b4){if(b4===0){if(!(a6<c))return A.a(k,a6)
b5=k[a6]
b6=b5&4095
if(b6<3)continue
b7=a7+d2.hw(b5>>>12,d7)}else{s=b4-1
if(!(s>=0))return A.a(c8,s)
r=c8[s]
if(a6<r)continue
if(h[s]<=a6){a8=d4[a6]
a9=a6-r
if(!(a9>=0&&a9<f))return A.a(d4,a9)
b0=!0
if(a8===d4[a9]){a8=d3[a6]
if(!(a9<q))return A.a(d3,a9)
if(a8===d3[a9]){a8=d5[a6]
if(!(a9<e))return A.a(d5,a9)
if(a8===d5[a9]){a8=d6[a6]
if(!(a9<d))return A.a(d6,a9)
a9=a8!==d6[a9]
a8=a9}else a8=b0}else a8=b0}else a8=b0
if(a8)continue
b8=b3
for(;;){a8=!1
if(b8<c5){if(!(b8<f))return A.a(d4,b8)
a9=d4[b8]
b0=b8-r
if(!(b0>=0&&b0<f))return A.a(d4,b0)
if(a9===d4[b0]){if(!(b8<q))return A.a(d3,b8)
a9=d3[b8]
if(!(b0<q))return A.a(d3,b0)
if(a9===d3[b0]){if(!(b8<e))return A.a(d5,b8)
a9=d5[b8]
if(!(b0<e))return A.a(d5,b0)
if(a9===d5[b0]){if(!(b8<d))return A.a(d6,b8)
a8=d6[b8]
if(!(b0<d))return A.a(d6,b0)
b0=a8===d6[b0]
a8=b0}}}}if(!a8)break;++b8}if(!(s<c9))return A.a(h,s)
h[s]=b8}b9=h[s]-a6
b6=b9>4095?4095:b9
if(b6<3)continue
b7=a7+j[s]}c0=b6<16?b6:16
for(c1=3;c1<=c0;++c1){if(!(c1<i))return A.a(l,c1)
s=b7+l[c1]
a8=a6+c1
if(!(a8<p))return A.a(o,a8)
if(s<o[a8]){if(!(a8<p))return A.a(o,a8)
o[a8]=s
if(!(a8<p))return A.a(n,a8)
n[a8]=c1
if(!(a8<p))return A.a(m,a8)
m[a8]=b4}}if(b6>c0){if(!(b6<i))return A.a(l,b6)
s=b7+l[b6]
a8=a6+b6
if(!(a8<p))return A.a(o,a8)
if(s<o[a8]){if(!(a8<p))return A.a(o,a8)
o[a8]=s
if(!(a8<p))return A.a(n,a8)
n[a8]=b6
if(!(a8<p))return A.a(m,a8)
m[a8]=b4}}}}for(q=c7.$flags|0,i=c6.$flags|0,c2=c5;c2>0;c2=c3){if(!(c2<p))return A.a(n,c2)
c1=n[c2]
c3=c2-c1
i&2&&A.b(c6)
if(!(c3>=0&&c3<c6.length))return A.a(c6,c3)
c6[c3]=c1
c4=m[c2]
if(c4===0){if(!(c3<c))return A.a(k,c3)
f=k[c3]>>>12}else{f=c4-1
if(!(f>=0&&f<c9))return A.a(c8,f)
f=c8[f]}q&2&&A.b(c7)
if(!(c3<c7.length))return A.a(c7,c3)
c7[c3]=f}},
bX(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
p3(a,b,c){var s,r,q,p,o=(a>>>24)+(b>>>24)-(c>>>24)
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
p4(a,b,c){var s,r,q,p,o=A.bX(a,b),n=o>>>24
n+=B.a.V(n-(c>>>24),2)
if(n<0)s=0
else s=n>255?255:n
n=o>>>16&255
n+=B.a.V(n-(c>>>16&255),2)
if(n<0)r=0
else r=n>255?255:n
n=o>>>8&255
n+=B.a.V(n-(c>>>8&255),2)
if(n<0)q=0
else q=n>255?255:n
n=o&255
n+=B.a.V(n-(c&255),2)
if(n<0)p=0
else p=n>255?255:n
return(s<<24|r<<16|q<<8|p)>>>0},
m4(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
pk(a,b,c){return A.m4(a>>>24,b>>>24,c>>>24)+A.m4(a>>>16&255,b>>>16&255,c>>>16&255)+A.m4(a>>>8&255,b>>>8&255,c>>>8&255)+A.m4(a&255,b&255,c&255)<=0?a:b},
w2(a,b,c,d,e){switch(a){case 0:return 4278190080
case 1:return b
case 2:return c
case 3:return e
case 4:return d
case 5:return A.bX(A.bX(b,e),c)
case 6:return A.bX(b,d)
case 7:return A.bX(b,c)
case 8:return A.bX(d,c)
case 9:return A.bX(c,e)
case 10:return A.bX(A.bX(b,d),A.bX(c,e))
case 11:return A.pk(c,b,d)
case 12:return A.p3(b,c,d)
default:return A.p4(b,c,d)}},
wa(b5,b6,b7,b8,b9,c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2=A.I(b8*b9,11,!1,t.p),b3=new Int32Array(14),b4=new Uint32Array(14)
for(s=b5.length,r=0;r<b9;++r)for(q=r*b8,p=r*c0,o=p+c0,n=0;n<b8;++n){m=n*c0
l=B.a.F(m+c0,0,b6)
k=B.a.F(o,0,b7)
B.u.a8(b3,0,14,0)
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
b4[11]=A.pk(a,c,a0)
b4[12]=A.p3(c,a,a0)
b4[13]=A.p4(c,a,a0)
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
b0=a3}}B.c.i(b2,q+n,b0)}return b2},
vr(a1,a2,a3,a4,a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=B.a.geh(a9)-1
for(s=a1.length,r=b0.length,q=a5.$flags|0,p=a2.$flags|0,o=a3.$flags|0,n=a4.$flags|0,m=0;m<a7;++m){l=m*a6
k=B.a.a0(m,a0)*a8
for(j=m===0,i=0;i<a6;++i){h=l+i
if(j)if(i===0)g=4278190080
else{f=h-1
if(!(f>=0&&f<s))return A.a(a1,f)
g=a1[f]}else{f=h-a6
if(i===0){if(!(f>=0&&f<s))return A.a(a1,f)
g=a1[f]}else{e=k+B.a.a0(i,a0)
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
g=A.w2(e,d,c,b,a1[f])}}if(!(h>=0&&h<s))return A.a(a1,h)
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
wS(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=b*c,i=A.I(280,0,!1,t.p)
for(s=d.length,r=0;r<s;++r){q=d[r]
if(!(q<280))return A.a(i,q)
B.c.i(i,q,i[q]+1)}p=A.e1(i,280,15)
o=A.e2(new Int32Array(A.p(p)),280)
a.T(0,1)
A.fV(a,280,p)
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
tM(a,b,c,d,e,f){A.tJ(f,a,b,c,d,e,!0,f)},
tN(a,b,c,d,e,f){A.tK(f,a,b,c,d,e,!0,f)},
tL(a,b,c,d,e,f){A.tI(f,a,b,c,d,e,!0,f)},
dP(a,b,c,d,e){var s,r,q
if(e)for(s=0;s<d;++s){r=J.d(a.a,a.d+s)
q=J.d(b.a,b.d+s)
J.a_(c.a,c.d+s,r+q)}else for(s=0;s<d;++s){r=J.d(a.a,a.d+s)
q=J.d(b.a,b.d+s)
J.a_(c.a,c.d+s,r-q)}},
tJ(a,b,c,d,e,f,g,h){var s,r,q=null,p=e*d,o=e+f,n=A.v(a,!1,q,p),m=A.v(h,!1,q,p),l=A.w(g?m:n,q,0)
if(e===0){m.i(0,0,J.d(n.a,n.d))
A.dP(A.w(n,q,1),l,A.w(m,q,1),b-1,g)
l.d+=d
n.d+=d
m.d+=d
e=1}for(s=-d,r=b-1;e<o;){A.dP(n,A.w(l,q,s),m,1,g)
A.dP(A.w(n,q,1),l,A.w(m,q,1),r,g);++e
l.d+=d
n.d+=d
m.d+=d}},
tK(a,b,c,d,e,f,g,h){var s=null,r=e*d,q=e+f,p=A.v(a,!1,s,r),o=A.v(h,!1,s,r),n=A.w(g?o:p,s,0)
if(e===0){o.i(0,0,J.d(p.a,p.d))
A.dP(A.w(p,s,1),n,A.w(o,s,1),b-1,g)
p.d+=d
o.d+=d
e=1}else n.d-=d
while(e<q){A.dP(p,n,o,b,g);++e
n.d+=d
p.d+=d
o.d+=d}},
tI(a,b,c,d,e,f,g,a0){var s,r,q,p,o,n,m=null,l=e*d,k=e+f,j=A.v(a,!1,m,l),i=A.v(a0,!1,m,l),h=A.w(g?i:j,m,0)
if(e===0){i.i(0,0,J.d(j.a,j.d))
A.dP(A.w(j,m,1),h,A.w(i,m,1),b-1,g)
h.d+=d
j.d+=d
i.d+=d
e=1}for(s=-d;e<k;){A.dP(j,A.w(h,m,s),i,1,g)
for(r=1;r<b;++r){q=r-d
p=J.d(h.a,h.d+(r-1))+J.d(h.a,h.d+q)-J.d(h.a,h.d+(q-1))
if((p&4294967040)>>>0===0)o=p
else o=p<0?0:255
q=J.d(j.a,j.d+r)
n=g?o:-o
J.a_(i.a,i.d+r,q+n)}++e
h.d+=d
j.d+=d
i.d+=d}},
ba(a){var s,r,q=a.a
if(q==null)return 0
s=a.gaN()*q.c
if((s&7)!==0)return 0
r=B.a.j(s,3)
return q.gaz()===a.gN()*r?r:0},
wb(a,b,c,d){var s,r,q,p,o,n,m
for(s=a.length,r=a.$flags|0,q=0;q<d;++q){p=b+q
if(!(p>=0&&p<s))return A.a(a,p)
o=a[p]
n=c+q
if(!(n>=0&&n<s))return A.a(a,n)
m=a[n]
r&2&&A.b(a)
a[p]=m
a[n]=o}},
pK(a,b,c,d){var s,r
for(s=b+(c-1)*d,r=b;r<s;r+=d,s-=d)A.wb(a,r,s,d)},
pp(a){var s,r="ifd0"
if(!a.gbh().l(0,r).a.ac(274)||a.gbh().l(0,r).gbU()===1)return A.aQ(a,!1,!1)
switch(a.gbh().l(0,r).gbU()){case 2:s=A.mj(A.aQ(a,!1,!1))
break
case 3:s=A.vK(A.aQ(a,!1,!1),B.dw)
break
case 4:s=A.py(A.aQ(a,!1,!1))
break
case 5:s=A.mj(A.mc(a,90))
break
case 6:s=A.mc(a,90)
break
case 7:s=A.mj(A.mc(a,-90))
break
case 8:s=A.mc(a,-90)
break
default:s=A.aQ(a,!1,!1)
break}s.e=A.ee(a.gbh())
s.gbh().l(0,r).sbU(null)
return s},
mc(b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=null,b0=B.a.a5(b2,360)
b1.gaw()
if(B.a.a5(b0,90)===0)switch(B.a.V(b0,90)){case 1:return A.vc(b1)
case 2:return A.va(b1)
case 3:return A.vb(b1)
default:return A.aQ(b1,!1,!1)}s=b0*3.141592653589793/180
r=Math.cos(s)
q=Math.sin(s)
p=b1.gN()
o=b1.gN()
n=b1.gJ()
m=b1.gJ()
l=0.5*b1.gN()
k=0.5*b1.gJ()
n=Math.abs(p*r)+Math.abs(n*q)
j=0.5*n
m=Math.abs(o*q)+Math.abs(m*r)
i=0.5*m
h=b1.gae().length
for(p=t.g,g=b1.f,f=a9,e=0;e<h;++e){d=b1.x
if(d===$)d=b1.x=A.j([],p)
if(!(e<d.length))return A.a(d,e)
c=d[e]
o=f==null
b=o?a9:f.dv()
if(b==null){a=B.b.h(n)
b=A.hs(b1,B.b.h(m),!0,a)}if(o)f=b
a0=c.f
if(a0==null)a0=g
if(a0!=null){o=b.a
if(o!=null)o.bb(0,a0)}for(o=b.a,o=o.gI(o);o.E();){a1=o.gO()
a2=a1.gb6()
a3=a1.gb_()
a=a2-j
a4=a3-i
a5=l+a*r+a4*q
a6=k-a*q+a4*r
a=!1
if(a5>=0)if(a6>=0){a4=c.a
a7=a4==null
a8=a7?a9:a4.a
if(a5<(a8==null?0:a8)){a=a7?a9:a4.b
a=a6<(a==null?0:a)}}if(a)b.c8(a2,a3,c.ew(a5,a6,B.a4))}}f.toString
return f},
vc(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
for(s=a.gae(),r=s.length,q=b,p=0;p<s.length;s.length===r||(0,A.L)(s),++p){o=s[p]
n=q==null
m=n?b:q.dv()
if(m==null){l=o.a
k=l==null
j=k?b:l.b
if(j==null)j=0
l=k?b:l.a
m=A.hs(o,l==null?0:l,!0,j)}if(n)q=m
n=o.a
n=n==null?b:n.b
i=(n==null?0:n)-1
h=A.ba(o)
if(h>0&&A.ba(m)===h){n=o.a
l=n==null
k=l?b:n.a
g=-(k==null?0:k)*h
f=l?b:J.G(n.gq(n))
if(f==null){n=o.a
n=n==null?b:n.gq(n)
if(n==null)n=B.d.gq(new Uint8Array(0))
f=J.G(n)}n=m.a
e=n==null?b:J.G(n.gq(n))
if(e==null){n=m.a
n=n==null?b:n.gq(n)
if(n==null)n=B.d.gq(new Uint8Array(0))
e=J.G(n)}d=0
for(;;){n=m.a
l=n==null
k=l?b:n.b
if(!(d<(k==null?0:k)))break
k=o.a
k=k==null?b:k.a
if(k==null)k=0
j=l?b:n.a
if(j==null)j=0
n=l?b:n.a
if(n==null)n=0
A.nm(f,(i*k+d)*h,g,e,d*j*h,n,h);++d}continue}d=0
for(;;){n=m.a
n=n==null?b:n.b
if(!(d<(n==null?0:n)))break
c=0
for(;;){n=m.a
n=n==null?b:n.a
if(!(c<(n==null?0:n)))break
n=o.a
n=n==null?b:n.P(d,i-c,b)
m.c8(c,d,n==null?new A.E():n);++c}++d}}q.toString
return q},
va(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null
for(s=a.gae(),r=s.length,q=c,p=0;p<s.length;s.length===r||(0,A.L)(s),++p){o=s[p]
n=o.a
m=n==null
l=m?c:n.a
k=(l==null?0:l)-1
n=m?c:n.b
j=(n==null?0:n)-1
n=q==null
i=n?c:q.dv()
if(i==null)i=A.aQ(o,!0,!0)
if(n)q=i
h=A.ba(o)
if(h>0&&A.ba(i)===h){n=o.a
m=n==null
l=m?c:n.a
if(l==null)l=0
g=m?c:n.b
f=l*(g==null?0:g)
n=m?c:J.G(n.gq(n))
if(n==null){n=o.a
n=n==null?c:n.gq(n)
if(n==null)n=B.d.gq(new Uint8Array(0))
n=J.G(n)}m=i.a
m=m==null?c:J.G(m.gq(m))
if(m==null){m=i.a
m=m==null?c:m.gq(m)
if(m==null)m=B.d.gq(new Uint8Array(0))
m=J.G(m)}A.nm(n,(f-1)*h,-h,m,0,f,h)
continue}e=0
for(;;){n=i.a
n=n==null?c:n.b
if(!(e<(n==null?0:n)))break
n=j-e
d=0
for(;;){m=i.a
m=m==null?c:m.a
if(!(d<(m==null?0:m)))break
m=o.a
m=m==null?c:m.P(k-d,n,c)
i.c8(d,e,m==null?new A.E():m);++d}++e}}q.toString
return q},
vb(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
for(s=a.gae(),r=s.length,q=b,p=0;p<s.length;s.length===r||(0,A.L)(s),++p){o=s[p]
n=a.a
n=n==null?b:n.a
m=(n==null?0:n)-1
n=q==null
l=n?b:q.dv()
if(l==null){k=o.a
j=k==null
i=j?b:k.b
if(i==null)i=0
k=j?b:k.a
l=A.hs(o,k==null?0:k,!0,i)}if(n)q=l
h=A.ba(o)
n=!1
if(h>0)if(A.ba(l)===h){n=o.a
n=n==null?b:n.a
if(n==null)n=0
k=a.a
k=k==null?b:k.a
n=n===(k==null?0:k)}if(n){n=o.a
k=n==null
j=k?b:n.a
g=(j==null?0:j)*h
f=k?b:J.G(n.gq(n))
if(f==null){n=o.a
n=n==null?b:n.gq(n)
if(n==null)n=B.d.gq(new Uint8Array(0))
f=J.G(n)}n=l.a
e=n==null?b:J.G(n.gq(n))
if(e==null){n=l.a
n=n==null?b:n.gq(n)
if(n==null)n=B.d.gq(new Uint8Array(0))
e=J.G(n)}d=0
for(;;){n=l.a
k=n==null
j=k?b:n.b
if(!(d<(j==null?0:j)))break
j=k?b:n.a
if(j==null)j=0
n=k?b:n.a
if(n==null)n=0
A.nm(f,(m-d)*h,g,e,d*j*h,n,h);++d}continue}d=0
for(;;){n=l.a
n=n==null?b:n.b
if(!(d<(n==null?0:n)))break
n=m-d
c=0
for(;;){k=l.a
k=k==null?b:k.a
if(!(c<(k==null?0:k)))break
k=o.a
k=k==null?b:k.P(n,c,b)
l.c8(c,d,k==null?new A.E():k);++c}++d}}q.toString
return q},
nm(a,b,c,d,e,f,g){var s,r,q,p,o,n
for(s=a.length,r=d.$flags|0,q=0;q<f;++q,b+=c)for(p=0;p<g;++p,e=o){o=e+1
n=b+p
if(!(n>=0&&n<s))return A.a(a,n)
n=a[n]
r&2&&A.b(d)
if(!(e>=0&&e<d.length))return A.a(d,e)
d[e]=n}},
iV(a,b){var s=A.hv(a,B.T,null,null),r=A.oj(new A.ev(s,B.a3,B.b5))
try{s=r.af(b).Y()
return s}finally{r.hq()}},
md(a){var s
a=(a&-a)>>>0
s=a!==0?31:32
if((a&65535)!==0)s-=16
if((a&16711935)!==0)s-=8
if((a&252645135)!==0)s-=4
if((a&858993459)!==0)s-=2
return(a&1431655765)!==0?s-1:s},
wd(a){var s
$.nN().i(0,0,a)
s=$.qa()
if(0>=s.length)return A.a(s,0)
return s[0]},
pL(a,b,c,d){return(B.a.F(a,0,255)|B.a.F(b,0,255)<<8|B.a.F(c,0,255)<<16|B.a.F(d,0,255)<<24)>>>0},
bo(a,b,c){var s,r,q,p,o,n=b.gu(b),m=b.gL(),l=a.gR(),k=l==null?null:l.gL()
if(k==null)k=a.gL()
s=a.gu(a)
if(n===1)b.i(0,0,A.e4(B.b.b3(a.gu(a)>2?a.gaq():a.l(0,0)),k,m))
else if(n===2){r=s>2?a.gaq():a.l(0,0)
b.i(0,0,A.e4(!B.ls.bP(0,k)?B.b.b3(r):r,k,m))
b.i(0,1,A.e4(s===2?a.l(0,1):a.gv(),k,m))}else if(n<=s)for(q=0;q<n;++q)b.i(0,q,A.e4(a.l(0,q),k,m))
else if(s===2){p=A.e4(a.l(0,0),k,m)
if(n===3){b.i(0,0,p)
b.i(0,1,p)
b.i(0,2,p)}else{c=A.e4(a.l(0,1),k,m)
b.i(0,0,p)
b.i(0,1,p)
b.i(0,2,p)
b.i(0,3,c)}}else{for(q=0;q<s;++q)b.i(0,q,A.e4(a.l(0,q),k,m))
o=s===1?b.l(0,0):0
for(q=s;q<n;++q)b.i(0,q,q===3?c:o)}return b},
aM(a,b,c,d,e){var s,r,q=a.gR(),p=q==null?null:q.gL()
if(p==null)p=a.gL()
q=e==null
s=q?null:e.gL()
c=s==null?c:s
if(c==null)c=a.gL()
s=q?null:e.gu(e)
d=s==null?d:s
if(d==null)d=a.gu(a)
if(b==null)b=0
if(c===p&&d===a.gu(a)){if(q)return a.X()
e.b9(a)
return e}switch(c.a){case 3:if(q)r=new A.bd(new Uint8Array(d))
else r=e
return A.bo(a,r,b)
case 0:return A.bo(a,q?new A.dc(d,0):e,b)
case 1:return A.bo(a,q?new A.de(d,0):e,b)
case 2:if(q){q=d<3?1:2
r=new A.dg(d,new Uint8Array(q))}else r=e
return A.bo(a,r,b)
case 4:if(q)r=new A.dd(new Uint16Array(d))
else r=e
return A.bo(a,r,b)
case 5:if(q)r=new A.df(new Uint32Array(d))
else r=e
return A.bo(a,r,b)
case 6:if(q)r=new A.db(new Int8Array(d))
else r=e
return A.bo(a,r,b)
case 7:if(q)r=new A.d9(new Int16Array(d))
else r=e
return A.bo(a,r,b)
case 8:if(q)r=new A.da(new Int32Array(d))
else r=e
return A.bo(a,r,b)
case 9:if(q)r=new A.d6(new Uint16Array(d))
else r=e
return A.bo(a,r,b)
case 10:if(q)r=new A.d7(new Float32Array(d))
else r=e
return A.bo(a,r,b)
case 11:if(q)r=new A.d8(new Float64Array(d))
else r=e
return A.bo(a,r,b)}},
a2(a){return 0.299*a.gt()+0.587*a.gA()+0.114*a.gB()},
ps(a,b,c,d,e){var s=1-d/255
B.c.i(e,0,B.b.av(255*(1-a/255)*s))
B.c.i(e,1,B.b.av(255*(1-b/255)*s))
B.c.i(e,2,B.b.av(255*(1-c/255)*s))},
O(a){var s,r,q,p=$.nM()
p.$flags&2&&A.b(p)
p[0]=a
p=$.q9()
if(0>=p.length)return A.a(p,0)
s=p[0]
if(a===0)return s>>>16
if($.N==null)A.Q()
r=s>>>23&511
p=$.o6.cN()
if(!(r<p.length))return A.a(p,r)
r=p[r]
if(r!==0){q=s&8388607
return r+(q+4095+(q>>>13&1)>>>13)}return A.qM(s)},
qM(a){var s,r,q=a>>>16&32768,p=(a>>>23&255)-112,o=a&8388607
if(p<=0){if(p<-10)return q
o|=8388608
s=14-p
return(q|B.a.aJ(o+(B.a.U(1,s-1)-1)+(B.a.a0(o,s)&1),s))>>>0}else if(p===143)if(o===0)return q|31744
else{o=o>>>13
r=o===0?1:0
return q|o|r|31744}else{o=o+4095+(o>>>13&1)
if((o&8388608)!==0){++p
o=0}if(p>30)return q|31744
return(q|p<<10|o>>>13)>>>0}},
Q(){var s,r,q,p,o,n=$.N
if(n!=null)return n
s=new Uint32Array(65536)
$.N=J.nP(B.o.gq(s),0,null)
n=new Uint16Array(512)
$.o6.b=n
for(r=0;r<256;++r){q=(r&255)-112
if(q<=0||q>=30){n[r]=0
p=(r|256)>>>0
if(!(p<512))return A.a(n,p)
n[p]=0}else{p=q<<10>>>0
n[r]=p
o=(r|256)>>>0
if(!(o<512))return A.a(n,o)
n[o]=(p|32768)>>>0}}for(r=0;r<65536;++r)s[r]=A.qN(r)
n=$.N
n.toString
return n},
qN(a){var s,r=a>>>15&1,q=a>>>10&31,p=a&1023
if(q===0)if(p===0)return r<<31>>>0
else{while((p&1024)===0){p=p<<1;--q}++q
p&=4294966271}else if(q===31){s=r<<31
if(p===0)return(s|2139095040)>>>0
else return(s|p<<13|2139095040)>>>0}return(r<<31|q+112<<23|p<<13)>>>0},
rJ(a){var s="[Matrix] "+a.a,r=a.c
if(r!=null)s+="\n"+r.D(0)
switch(a.d.a){case 0:A.bz(v.G.console).error("!!!CRITICAL!!! "+s)
break
case 1:A.bz(v.G.console).error(s)
break
case 2:A.bz(v.G.console).warn(s)
break
case 3:A.bz(v.G.console).info(s)
break
case 4:A.bz(v.G.console).debug(s)
break
case 5:A.bz(v.G.console).log(s)
break}},
vZ(){return A.nB()}},B={}
var w=[A,J,B]
var $={}
A.mL.prototype={}
J.hx.prototype={
Z(a,b){return a===b},
gM(a){return A.fa(a)},
D(a){return"Instance of '"+A.i1(a)+"'"},
gaW(a){return A.c_(A.np(this))}}
J.hK.prototype={
D(a){return String(a)},
gM(a){return a?519018:218159},
gaW(a){return A.c_(t.y)},
$iS:1,
$iat:1}
J.eE.prototype={
Z(a,b){return null==b},
D(a){return"null"},
gM(a){return 0},
$iS:1}
J.eG.prototype={$ia4:1}
J.c7.prototype={
gM(a){return 0},
D(a){return String(a)}}
J.hY.prototype={}
J.cT.prototype={}
J.bM.prototype={
D(a){var s=a[$.pO()]
if(s==null)s=a[$.nF()]
if(s==null)return this.ij(a)
return"JavaScript function for "+J.e7(s)},
$ibG:1}
J.dy.prototype={
gM(a){return 0},
D(a){return String(a)}}
J.dz.prototype={
gM(a){return 0},
D(a){return String(a)}}
J.q.prototype={
C(a,b){A.ak(a).c.a(b)
a.$flags&1&&A.b(a,29)
a.push(b)},
hQ(a,b){var s
a.$flags&1&&A.b(a,"removeAt",1)
s=a.length
if(b>=s)throw A.f(A.n7(b,null))
return a.splice(b,1)[0]},
cf(a,b){var s
A.ak(a).m("e<1>").a(b)
a.$flags&1&&A.b(a,"addAll",2)
if(Array.isArray(b)){this.iL(a,b)
return}for(s=J.fX(b);s.E();)a.push(s.gO())},
iL(a,b){var s,r
t.dG.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.f(A.aI(a))
for(r=0;r<s;++r)a.push(b[r])},
cT(a){a.$flags&1&&A.b(a,"clear","clear")
a.length=0},
cj(a,b,c){var s=A.ak(a)
return new A.bi(a,s.am(c).m("1(2)").a(b),s.m("@<1>").am(c).m("bi<1,2>"))},
mn(a,b){var s,r=A.I(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.i(r,s,A.y(a[s]))
return r.join(b)},
hS(a,b){return A.dN(a,0,A.fU(b,"count",t.p),A.ak(a).c)},
dJ(a,b){return A.dN(a,b,null,A.ak(a).c)},
bA(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
cl(a,b,c){if(b<0||b>a.length)throw A.f(A.aw(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.f(A.aw(c,b,a.length,"end",null))
if(b===c)return A.j([],A.ak(a))
return A.j(a.slice(b,c),A.ak(a))},
ghC(a){if(a.length>0)return a[0]
throw A.f(A.dv())},
gem(a){var s=a.length
if(s>0)return a[s-1]
throw A.f(A.dv())},
ab(a,b,c,d,e){var s,r,q,p
A.ak(a).m("e<1>").a(d)
a.$flags&2&&A.b(a,5)
A.bl(b,c,a.length)
s=c-b
if(s===0)return
A.dL(e,"skipCount")
r=d
q=J.ae(r)
if(e+s>q.gu(r))throw A.f(A.om())
if(e<b)for(p=s-1;p>=0;--p)a[b+p]=q.l(r,e+p)
else for(p=0;p<s;++p)a[b+p]=q.l(r,e+p)},
a8(a,b,c,d){var s
A.ak(a).m("1?").a(d)
a.$flags&2&&A.b(a,"fillRange")
A.bl(b,c,a.length)
for(s=b;s<c;++s)a[s]=d},
m9(a,b){var s,r
A.ak(a).m("at(1)").a(b)
s=a.length
for(r=0;r<s;++r){if(!b.$1(a[r]))return!1
if(a.length!==s)throw A.f(A.aI(a))}return!0},
eG(a,b){var s,r,q,p,o,n=A.ak(a)
n.m("h(1,1)?").a(b)
a.$flags&2&&A.b(a,"sort")
s=a.length
if(s<2)return
if(b==null)b=J.uJ()
if(s===2){r=a[0]
q=a[1]
n=b.$2(r,q)
if(typeof n!=="number")return n.i6()
if(n>0){a[0]=q
a[1]=r}return}p=0
if(n.c.b(null))for(o=0;o<a.length;++o)if(a[o]===void 0){a[o]=null;++p}a.sort(A.e3(b,2))
if(p>0)this.lk(a,p)},
eF(a){return this.eG(a,null)},
lk(a,b){var s,r=a.length
for(;s=r-1,r>0;r=s)if(a[s]===null){a[s]=void 0;--b
if(b===0)break}},
bP(a,b){var s
for(s=0;s<a.length;++s)if(J.cm(a[s],b))return!0
return!1},
D(a){return A.jI(a,"[","]")},
gI(a){return new J.e8(a,a.length,A.ak(a).m("e8<1>"))},
gM(a){return A.fa(a)},
gu(a){return a.length},
su(a,b){a.$flags&1&&A.b(a,"set length","change the length of")
if(b<0)throw A.f(A.aw(b,0,null,"newLength",null))
if(b>a.length)A.ak(a).c.a(null)
a.length=b},
l(a,b){if(!(b>=0&&b<a.length))throw A.f(A.mf(a,b))
return a[b]},
i(a,b,c){A.ak(a).c.a(c)
a.$flags&2&&A.b(a)
if(!(b>=0&&b<a.length))throw A.f(A.mf(a,b))
a[b]=c},
hY(a,b){return new A.cX(a,b.m("cX<0>"))},
$iap:1,
$iB:1,
$ie:1,
$ir:1}
J.hI.prototype={
mO(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.i1(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.jJ.prototype={}
J.e8.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.L(q)
throw A.f(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iz:1}
J.dx.prototype={
bO(a,b){var s
A.nl(b)
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.gel(b)
if(this.gel(a)===s)return 0
if(this.gel(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
gel(a){return a===0?1/a<0:a<0},
geC(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
h(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.f(A.bn(""+a+".toInt()"))},
bj(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.f(A.bn(""+a+".ceil()"))},
b3(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.f(A.bn(""+a+".floor()"))},
av(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.f(A.bn(""+a+".round()"))},
F(a,b,c){if(this.bO(b,c)>0)throw A.f(A.bZ(b))
if(this.bO(a,b)<0)return b
if(this.bO(a,c)>0)return c
return a},
dE(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.f(A.aw(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.a3(A.bn("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.m.ey("0",o)},
D(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gM(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
a5(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
if(b<0)return s-b
else return s+b},
aa(a,b){A.nl(b)
if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.fU(a,b)},
V(a,b){return(a|0)===a?a/b|0:this.fU(a,b)},
fU(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.f(A.bn("Result of truncating division is "+A.y(s)+": "+A.y(a)+" ~/ "+b))},
U(a,b){if(b<0)throw A.f(A.bZ(b))
return b>31?0:a<<b>>>0},
S(a,b){return b>31?0:a<<b>>>0},
aJ(a,b){var s
if(b<0)throw A.f(A.bZ(b))
if(a>0)s=this.a6(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
j(a,b){var s
if(a>0)s=this.a6(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
a0(a,b){if(0>b)throw A.f(A.bZ(b))
return this.a6(a,b)},
a6(a,b){return b>31?0:a>>>b},
ic(a,b){if(b<0)throw A.f(A.bZ(b))
return this.lq(a,b)},
lq(a,b){if(b>31)return 0
return a>>>b},
gaW(a){return A.c_(t.q)},
$ibe:1,
$iD:1,
$ik:1}
J.dw.prototype={
geC(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
b5(a,b){var s=this.U(1,b-1)
return((a&s-1)>>>0)-((a&s)>>>0)},
geh(a){var s,r=a<0?-a-1:a,q=r
for(s=32;q>=4294967296;){q=this.V(q,4294967296)
s+=32}return s-Math.clz32(q)},
gaW(a){return A.c_(t.p)},
$iS:1,
$ih:1}
J.eF.prototype={
gaW(a){return A.c_(t.V)},
$iS:1}
J.cz.prototype={
bq(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.eK(a,r-s)},
eH(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
ii(a,b,c){return a.substring(b,A.bl(b,c,a.length))},
eK(a,b){return this.ii(a,b,null)},
hX(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(0>=o)return A.a(p,0)
if(p.charCodeAt(0)===133){s=J.r0(p,1)
if(s===o)return""}else s=0
r=o-1
if(!(r>=0))return A.a(p,r)
q=p.charCodeAt(r)===133?J.r1(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
ey(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.f(B.d2)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
mo(a,b){var s=a.length,r=b.length
if(s+r>s)s-=r
return a.lastIndexOf(b,s)},
bO(a,b){var s
A.bA(b)
if(a===b)s=0
else s=a<b?-1:1
return s},
D(a){return a},
gM(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gaW(a){return A.c_(t.N)},
gu(a){return a.length},
$iap:1,
$iS:1,
$ibe:1,
$iox:1,
$iX:1}
A.dA.prototype={
D(a){return"LateInitializationError: "+this.a}}
A.ah.prototype={
gu(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s.charCodeAt(b)}}
A.kz.prototype={}
A.B.prototype={}
A.av.prototype={
gI(a){var s=this
return new A.cC(s,s.gu(s),A.m(s).m("cC<av.E>"))},
cj(a,b,c){var s=A.m(this)
return new A.bi(this,s.am(c).m("1(av.E)").a(b),s.m("@<av.E>").am(c).m("bi<1,2>"))},
mE(a,b){var s,r,q,p=this
A.m(p).m("av.E(av.E,av.E)").a(b)
s=p.gu(p)
if(s===0)throw A.f(A.dv())
r=p.bA(0,0)
for(q=1;q<s;++q){r=b.$2(r,p.bA(0,q))
if(s!==p.gu(p))throw A.f(A.aI(p))}return r}}
A.fi.prototype={
gjQ(){var s=J.bC(this.a),r=this.c
if(r==null||r>s)return s
return r},
glu(){var s=J.bC(this.a),r=this.b
if(r>s)return s
return r},
gu(a){var s,r=J.bC(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
bA(a,b){var s=this,r=s.glu()+b
if(b<0||r>=s.gjQ())throw A.f(A.jE(b,s.gu(0),s,null,"index"))
return J.nR(s.a,r)},
dJ(a,b){var s,r,q=this
A.dL(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.cq(q.$ti.m("cq<1>"))
return A.dN(q.a,s,r,q.$ti.c)},
mL(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.ae(n),l=m.gu(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=p.$ti.c
return b?J.hJ(0,n):J.on(0,n)}r=A.I(s,m.bA(n,o),b,p.$ti.c)
for(q=1;q<s;++q){B.c.i(r,q,m.bA(n,o+q))
if(m.gu(n)<l)throw A.f(A.aI(p))}return r},
mK(a){return this.mL(0,!0)}}
A.cC.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s,r=this,q=r.a,p=J.ae(q),o=p.gu(q)
if(r.b!==o)throw A.f(A.aI(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.bA(q,s);++r.c
return!0},
$iz:1}
A.bN.prototype={
gI(a){var s=this.a
return new A.eM(s.gI(s),this.b,A.m(this).m("eM<1,2>"))},
gu(a){var s=this.a
return s.gu(s)}}
A.cp.prototype={$iB:1}
A.eM.prototype={
E(){var s=this,r=s.b
if(r.E()){s.a=s.c.$1(r.gO())
return!0}s.a=null
return!1},
gO(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iz:1}
A.bi.prototype={
gu(a){return J.bC(this.a)},
bA(a,b){return this.b.$1(J.nR(this.a,b))}}
A.cW.prototype={
gI(a){return new A.fw(J.fX(this.a),this.b,this.$ti.m("fw<1>"))},
cj(a,b,c){var s=this.$ti
return new A.bN(this,s.am(c).m("1(2)").a(b),s.m("@<1>").am(c).m("bN<1,2>"))}}
A.fw.prototype={
E(){var s,r
for(s=this.a,r=this.b;s.E();)if(r.$1(s.gO()))return!0
return!1},
gO(){return this.a.gO()},
$iz:1}
A.cq.prototype={
gI(a){return B.cW},
gu(a){return 0},
cj(a,b,c){this.$ti.am(c).m("1(2)").a(b)
return new A.cq(c.m("cq<0>"))}}
A.ec.prototype={
E(){return!1},
gO(){throw A.f(A.dv())},
$iz:1}
A.cX.prototype={
gI(a){return new A.fx(J.fX(this.a),this.$ti.m("fx<1>"))}}
A.fx.prototype={
E(){var s,r
for(s=this.a,r=this.$ti.c;s.E();)if(r.b(s.gO()))return!0
return!1},
gO(){return this.$ti.c.a(this.a.gO())},
$iz:1}
A.aB.prototype={}
A.bR.prototype={
i(a,b,c){A.m(this).m("bR.E").a(c)
throw A.f(A.bn("Cannot modify an unmodifiable list"))},
ab(a,b,c,d,e){A.m(this).m("e<bR.E>").a(d)
throw A.f(A.bn("Cannot modify an unmodifiable list"))},
aB(a,b,c,d){return this.ab(0,b,c,d,0)},
a8(a,b,c,d){A.m(this).m("bR.E?").a(d)
throw A.f(A.bn("Cannot modify an unmodifiable list"))}}
A.dO.prototype={}
A.d1.prototype={$r:"+(1,2)",$s:1}
A.dh.prototype={
D(a){return A.mQ(this)},
$ib1:1}
A.di.prototype={
gu(a){return this.b.length},
gfA(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
ac(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
l(a,b){if(!this.ac(b))return null
return this.b[this.a[b]]},
bH(a,b){var s,r,q,p
this.$ti.m("~(1,2)").a(b)
s=this.gfA()
r=this.b
for(q=s.length,p=0;p<q;++p)b.$2(s[p],r[p])},
gc7(){return new A.fC(this.gfA(),this.$ti.m("fC<1>"))}}
A.fC.prototype={
gu(a){return this.a.length},
gI(a){var s=this.a
return new A.cZ(s,s.length,this.$ti.m("cZ<1>"))}}
A.cZ.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0},
$iz:1}
A.aO.prototype={
ca(){var s=this,r=s.$map
if(r==null){r=new A.cA(s.$ti.m("cA<1,2>"))
A.pw(s.a,r)
s.$map=r}return r},
ac(a){return this.ca().ac(a)},
l(a,b){return this.ca().l(0,b)},
bH(a,b){this.$ti.m("~(1,2)").a(b)
this.ca().bH(0,b)},
gc7(){var s=this.ca()
return new A.cB(s,A.m(s).m("cB<1>"))},
gu(a){return this.ca().a}}
A.eb.prototype={
C(a,b){A.m(this).c.a(b)
A.qA()}}
A.el.prototype={
gu(a){return this.a.length},
gI(a){var s=this.a
return new A.cZ(s,s.length,this.$ti.m("cZ<1>"))},
ca(){var s,r,q,p,o=this,n=o.$map
if(n==null){n=new A.cA(o.$ti.m("cA<1,1>"))
for(s=o.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.L)(s),++q){p=s[q]
n.i(0,p,p)}o.$map=n}return n},
bP(a,b){return this.ca().ac(b)}}
A.hw.prototype={
Z(a,b){if(b==null)return!1
return b instanceof A.du&&this.a.Z(0,b.a)&&A.nv(this)===A.nv(b)},
gM(a){return A.k5(this.a,A.nv(this),B.F,B.F)},
D(a){var s=B.c.mn([A.c_(this.$ti.c)],", ")
return this.a.D(0)+" with "+("<"+s+">")}}
A.du.prototype={
$2(a,b){return this.a.$1$2(a,b,this.$ti.y[0])},
$S(){return A.vV(A.m9(this.a),this.$ti)}}
A.fe.prototype={}
A.kN.prototype={
bI(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
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
A.eX.prototype={
D(a){return"Null check operator used on a null value"}}
A.hO.prototype={
D(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.io.prototype={
D(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.k4.prototype={
D(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.ed.prototype={}
A.fL.prototype={
D(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ib5:1}
A.aA.prototype={
D(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.pN(r==null?"unknown":r)+"'"},
$ibG:1,
gmT(){return this},
$C:"$1",
$R:1,
$D:null}
A.h3.prototype={$C:"$0",$R:0}
A.h4.prototype={$C:"$2",$R:2}
A.ih.prototype={}
A.ig.prototype={
D(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.pN(s)+"'"}}
A.d4.prototype={
Z(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.d4))return!1
return this.$_target===b.$_target&&this.a===b.a},
gM(a){return(A.iX(this.a)^A.fa(this.$_target))>>>0},
D(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.i1(this.a)+"'")}}
A.ie.prototype={
D(a){return"RuntimeError: "+this.a}}
A.bh.prototype={
gu(a){return this.a},
gc7(){return new A.cB(this,A.m(this).m("cB<1>"))},
ac(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.mh(a)},
mh(a){var s=this.d
if(s==null)return!1
return this.d_(this.fj(s,a),a)>=0},
l(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.mi(b)},
mi(a){var s,r,q=this.d
if(q==null)return null
s=this.fj(q,a)
r=this.d_(s,a)
if(r<0)return null
return s[r].b},
i(a,b,c){var s,r,q=this,p=A.m(q)
p.c.a(b)
p.y[1].a(c)
if(typeof b=="string"){s=q.b
q.eO(s==null?q.b=q.e4():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.eO(r==null?q.c=q.e4():r,b,c)}else q.mk(b,c)},
mk(a,b){var s,r,q,p,o=this,n=A.m(o)
n.c.a(a)
n.y[1].a(b)
s=o.d
if(s==null)s=o.d=o.e4()
r=o.dB(a)
q=s[r]
if(q==null)s[r]=[o.e5(a,b)]
else{p=o.d_(q,a)
if(p>=0)q[p].b=b
else q.push(o.e5(a,b))}},
cC(a,b){var s=this
if(typeof b=="string")return s.fM(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.fM(s.c,b)
else return s.mj(b)},
mj(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.dB(a)
r=n[s]
q=o.d_(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.fZ(p)
if(r.length===0)delete n[s]
return p.b},
bH(a,b){var s,r,q=this
A.m(q).m("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.f(A.aI(q))
s=s.c}},
eO(a,b,c){var s,r=A.m(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.e5(b,c)
else s.b=c},
fM(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.fZ(s)
delete a[b]
return s.b},
fC(){this.r=this.r+1&1073741823},
e5(a,b){var s=this,r=A.m(s),q=new A.jV(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.fC()
return q},
fZ(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.fC()},
dB(a){return J.aN(a)&1073741823},
fj(a,b){return a[this.dB(b)]},
d_(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.cm(a[r].a,b))return r
return-1},
D(a){return A.mQ(this)},
e4(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$ijU:1}
A.jV.prototype={}
A.cB.prototype={
gu(a){return this.a.a},
gI(a){var s=this.a
return new A.Y(s,s.r,s.e,this.$ti.m("Y<1>"))}}
A.Y.prototype={
gO(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.f(A.aI(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iz:1}
A.jW.prototype={
gu(a){return this.a.a},
gI(a){var s=this.a
return new A.aq(s,s.r,s.e,this.$ti.m("aq<1>"))}}
A.aq.prototype={
gO(){return this.d},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.f(A.aI(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}},
$iz:1}
A.eH.prototype={
gu(a){return this.a.a},
gI(a){var s=this.a
return new A.eI(s,s.r,s.e,this.$ti.m("eI<1,2>"))}}
A.eI.prototype={
gO(){var s=this.d
s.toString
return s},
E(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.f(A.aI(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=new A.c8(s.a,s.b,r.$ti.m("c8<1,2>"))
r.c=s.c
return!0}},
$iz:1}
A.cA.prototype={
dB(a){return A.vz(a)&1073741823},
d_(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.cm(a[r].a,b))return r
return-1}}
A.mm.prototype={
$1(a){return this.a(a)},
$S:24}
A.mn.prototype={
$2(a,b){return this.a(a,b)},
$S:28}
A.mo.prototype={
$1(a){return this.a(A.bA(a))},
$S:33}
A.cf.prototype={
D(a){return this.fW(!1)},
fW(a){var s,r,q,p,o,n=this.jW(),m=this.fk(),l=(a?"Record ":"")+"("
for(s=n.length,r="",q=0;q<s;++q,r=", "){l+=r
p=n[q]
if(typeof p=="string")l=l+p+": "
if(!(q<m.length))return A.a(m,q)
o=m[q]
l=a?l+A.oB(o):l+A.y(o)}l+=")"
return l.charCodeAt(0)==0?l:l},
jW(){var s,r=this.$s
while($.lM.length<=r)B.c.C($.lM,null)
s=$.lM[r]
if(s==null){s=this.j5()
B.c.i($.lM,r,s)}return s},
j5(){var s,r,q,p=this.$r,o=p.indexOf("("),n=p.substring(1,o),m=p.substring(o),l=m==="()"?0:m.replace(/[^,]/g,"").length+1,k=t.K,j=J.bL(l,k)
for(s=0;s<l;++s)j[s]=s
if(n!==""){r=n.split(",")
s=r.length
for(q=l;s>0;){--q;--s
B.c.i(j,q,r[s])}}j=A.dB(j,!1,k)
j.$flags=3
return j}}
A.dV.prototype={
fk(){return[this.a,this.b]},
Z(a,b){if(b==null)return!1
return b instanceof A.dV&&this.$s===b.$s&&J.cm(this.a,b.a)&&J.cm(this.b,b.b)},
gM(a){return A.k5(this.$s,this.a,this.b,B.F)}}
A.lt.prototype={
cN(){var s=this.b
if(s===this)throw A.f(A.jR(this.a))
return s}}
A.cD.prototype={
gcA(a){return a.byteLength},
gaW(a){return B.lV},
cS(a,b,c){A.aE(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
hn(a){return this.cS(a,0,null)},
hk(a,b,c){A.aE(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
dw(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
hl(a){return this.dw(a,0,null)},
hi(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,2)
return new Int16Array(a,b,c)},
hm(a,b,c){A.aE(a,b,c)
if(c==null)c=B.a.V(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
hj(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Int32Array(a,b,c)},
hh(a,b,c){A.aE(a,b,c)
c=B.a.V(a.byteLength-b,4)
return new Float32Array(a,b,c)},
hg(a,b,c){A.aE(a,b,c)
return c==null?new DataView(a,b):new DataView(a,b,c)},
$iS:1,
$icD:1,
$ih2:1}
A.eS.prototype={
gq(a){if(((a.$flags|0)&2)!==0)return new A.iL(a.buffer)
else return a.buffer},
ko(a,b,c,d){var s=A.aw(b,0,c,d,null)
throw A.f(s)},
f0(a,b,c,d){if(b>>>0!==b||b>c)this.ko(a,b,c,d)},
$ia5:1}
A.iL.prototype={
gcA(a){return this.a.byteLength},
cS(a,b,c){var s=A.rq(this.a,b,c)
s.$flags=3
return s},
hn(a){return this.cS(0,0,null)},
hk(a,b,c){var s=A.rk(this.a,b,c)
s.$flags=3
return s},
dw(a,b,c){var s=A.rm(this.a,b,c)
s.$flags=3
return s},
hl(a){return this.dw(0,0,null)},
hi(a,b,c){var s=A.ri(this.a,b,c)
s.$flags=3
return s},
hm(a,b,c){var s=A.ro(this.a,b,c)
s.$flags=3
return s},
hj(a,b,c){var s=A.rj(this.a,b,c)
s.$flags=3
return s},
hh(a,b,c){var s=A.rh(this.a,b,c)
s.$flags=3
return s},
hg(a,b,c){var s=A.rf(this.a,b,c)
s.$flags=3
return s},
$ih2:1}
A.hS.prototype={
gaW(a){return B.lW},
$iS:1,
$ij9:1}
A.aj.prototype={
gu(a){return a.length},
fR(a,b,c,d,e){var s,r,q
t.dO.a(d)
s=a.length
this.f0(a,b,s,"start")
this.f0(a,c,s,"end")
if(b>c)throw A.f(A.aw(b,0,c,null,null))
r=c-b
if(e<0)throw A.f(A.aX(e,null))
q=d.length
if(q-e<r)throw A.f(A.kA("Not enough elements"))
if(e!==0||q!==r)d=d.subarray(e,e+r)
a.set(d,b)},
$iap:1,
$iaR:1}
A.c9.prototype={
l(a,b){A.bY(b,a,a.length)
return a[b]},
i(a,b,c){A.iN(c)
a.$flags&2&&A.b(a)
A.bY(b,a,a.length)
a[b]=c},
ab(a,b,c,d,e){t.id.a(d)
a.$flags&2&&A.b(a,5)
if(t.dQ.b(d)){this.fR(a,b,c,d,e)
return}this.eL(a,b,c,d,e)},
aB(a,b,c,d){return this.ab(a,b,c,d,0)},
$iB:1,
$ie:1,
$ir:1}
A.aS.prototype={
i(a,b,c){A.n(c)
a.$flags&2&&A.b(a)
A.bY(b,a,a.length)
a[b]=c},
ab(a,b,c,d,e){t.fm.a(d)
a.$flags&2&&A.b(a,5)
if(t.aj.b(d)){this.fR(a,b,c,d,e)
return}this.eL(a,b,c,d,e)},
aB(a,b,c,d){return this.ab(a,b,c,d,0)},
$iB:1,
$ie:1,
$ir:1}
A.eN.prototype={
gaW(a){return B.lX},
$iS:1,
$ijm:1}
A.eO.prototype={
gaW(a){return B.lY},
$iS:1,
$iei:1}
A.eP.prototype={
gaW(a){return B.lZ},
l(a,b){A.bY(b,a,a.length)
return a[b]},
cl(a,b,c){return new Int16Array(a.subarray(b,A.iO(b,c,a.length)))},
$iS:1,
$icy:1}
A.eQ.prototype={
gaW(a){return B.m_},
l(a,b){A.bY(b,a,a.length)
return a[b]},
$iS:1,
$ijG:1}
A.eR.prototype={
gaW(a){return B.m0},
l(a,b){A.bY(b,a,a.length)
return a[b]},
$iS:1,
$ijH:1}
A.eT.prototype={
gaW(a){return B.m2},
l(a,b){A.bY(b,a,a.length)
return a[b]},
$iS:1,
$iil:1}
A.eU.prototype={
gaW(a){return B.m3},
l(a,b){A.bY(b,a,a.length)
return a[b]},
$iS:1,
$iby:1}
A.eV.prototype={
gaW(a){return B.m4},
gu(a){return a.length},
l(a,b){A.bY(b,a,a.length)
return a[b]},
$iS:1,
$ikP:1}
A.cE.prototype={
gaW(a){return B.m5},
gu(a){return a.length},
l(a,b){A.bY(b,a,a.length)
return a[b]},
cl(a,b,c){return new Uint8Array(a.subarray(b,A.iO(b,c,a.length)))},
ih(a,b){return this.cl(a,b,null)},
$iS:1,
$icE:1,
$ib7:1}
A.fF.prototype={}
A.fG.prototype={}
A.fH.prototype={}
A.fI.prototype={}
A.bm.prototype={
m(a){return A.fP(v.typeUniverse,this,a)},
am(a){return A.p0(v.typeUniverse,this,a)}}
A.iC.prototype={}
A.iK.prototype={
D(a){return A.aF(this.a,null)}}
A.iA.prototype={
D(a){return this.a}}
A.dX.prototype={$ibx:1}
A.lq.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:12}
A.lp.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:22}
A.lr.prototype={
$0(){this.a.$0()},
$S:17}
A.ls.prototype={
$0(){this.a.$0()},
$S:17}
A.lP.prototype={
iJ(a,b){if(self.setTimeout!=null)self.setTimeout(A.e3(new A.lQ(this,b),0),a)
else throw A.f(A.bn("`setTimeout()` not found."))}}
A.lQ.prototype={
$0(){this.b.$0()},
$S:3}
A.iw.prototype={
ei(a){var s,r=this,q=r.$ti
q.m("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.eU(a)
else{s=r.a
if(q.m("ct<1>").b(a))s.f_(a)
else s.f4(a)}},
ej(a,b){var s=this.a
if(this.b)s.dR(new A.aY(a,b))
else s.dM(new A.aY(a,b))}}
A.lY.prototype={
$1(a){return this.a.$2(0,a)},
$S:8}
A.lZ.prototype={
$2(a,b){this.a.$2(1,new A.ed(a,t.l.a(b)))},
$S:20}
A.m7.prototype={
$2(a,b){this.a(A.n(a),b)},
$S:46}
A.aY.prototype={
D(a){return A.y(this.a)},
$iZ:1,
gcF(){return this.b}}
A.iy.prototype={
ej(a,b){var s=this.a
if((s.a&30)!==0)throw A.f(A.kA("Future already completed"))
s.dM(A.uI(a,b))},
hs(a){return this.ej(a,null)}}
A.fy.prototype={
ei(a){var s,r=this.$ti
r.m("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.f(A.kA("Future already completed"))
s.eU(r.m("1/").a(a))}}
A.cY.prototype={
mq(a){if((this.c&15)!==6)return!0
return this.b.b.ep(t.nU.a(this.d),a.a,t.y,t.K)},
mf(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Y.b(q))p=l.mH(q,m,a.b,o,n,t.l)
else p=l.ep(t.W.a(q),m,o,n)
try{o=r.$ti.m("2/").a(p)
return o}catch(s){if(t.do.b(A.br(s))){if((r.c&1)!==0)throw A.f(A.aX("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.f(A.aX("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.ag.prototype={
hT(a,b,c){var s,r,q=this.$ti
q.am(c).m("1/(2)").a(a)
s=$.a6
if(s===B.G){if(!t.Y.b(b)&&!t.W.b(b))throw A.f(A.mD(b,"onError",u.c))}else{c.m("@<0/>").am(q.c).m("1(2)").a(a)
b=A.v1(b,s)}r=new A.ag(s,c.m("ag<0>"))
this.dL(new A.cY(r,3,a,b,q.m("@<1>").am(c).m("cY<1,2>")))
return r},
fV(a,b,c){var s,r=this.$ti
r.am(c).m("1/(2)").a(a)
s=new A.ag($.a6,c.m("ag<0>"))
this.dL(new A.cY(s,19,a,b,r.m("@<1>").am(c).m("cY<1,2>")))
return s},
lo(a){this.a=this.a&1|16
this.c=a},
da(a){this.a=a.a&30|this.a&1
this.c=a.c},
dL(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t.c.a(r.c)
if((s.a&24)===0){s.dL(a)
return}r.da(s)}A.iR(null,null,r.b,t.M.a(new A.lw(r,a)))}},
fG(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t.c.a(m.c)
if((n.a&24)===0){n.fG(a)
return}m.da(n)}l.a=m.ds(a)
A.iR(null,null,m.b,t.M.a(new A.lA(l,m)))}},
dr(){var s=t.F.a(this.c)
this.c=null
return this.ds(s)},
ds(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
f4(a){var s,r=this
r.$ti.c.a(a)
s=r.dr()
r.a=8
r.c=a
A.dS(r,s)},
j3(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.dr()
q.da(a)
A.dS(q,r)},
dR(a){var s=this.dr()
this.lo(a)
A.dS(this,s)},
eU(a){var s=this.$ti
s.m("1/").a(a)
if(s.m("ct<1>").b(a)){this.f_(a)
return}this.iP(a)},
iP(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.iR(null,null,s.b,t.M.a(new A.ly(s,a)))},
f_(a){A.nd(this.$ti.m("ct<1>").a(a),this,!1)
return},
dM(a){this.a^=2
A.iR(null,null,this.b,t.M.a(new A.lx(this,a)))},
$ict:1}
A.lw.prototype={
$0(){A.dS(this.a,this.b)},
$S:3}
A.lA.prototype={
$0(){A.dS(this.b,this.a.a)},
$S:3}
A.lz.prototype={
$0(){A.nd(this.a.a,this.b,!0)},
$S:3}
A.ly.prototype={
$0(){this.a.f4(this.b)},
$S:3}
A.lx.prototype={
$0(){this.a.dR(this.b)},
$S:3}
A.lD.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.mG(t.mY.a(q.d),t.z)}catch(p){s=A.br(p)
r=A.c0(p)
if(k.c&&t.u.a(k.b.a.c).a===s){q=k.a
q.c=t.u.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.mE(q)
n=k.a
n.c=new A.aY(q,o)
q=n}q.b=!0
return}if(j instanceof A.ag&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.u.a(j.c)
q.b=!0}return}if(j instanceof A.ag){m=k.b.a
l=new A.ag(m.b,m.$ti)
j.hT(new A.lE(l,m),new A.lF(l),t.w)
q=k.a
q.c=l
q.b=!1}},
$S:3}
A.lE.prototype={
$1(a){this.a.j3(this.b)},
$S:12}
A.lF.prototype={
$2(a,b){A.fR(a)
t.l.a(b)
this.a.dR(new A.aY(a,b))},
$S:48}
A.lC.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.ep(o.m("2/(1)").a(p.d),m,o.m("2/"),n)}catch(l){s=A.br(l)
r=A.c0(l)
q=s
p=r
if(p==null)p=A.mE(q)
o=this.a
o.c=new A.aY(q,p)
o.b=!0}},
$S:3}
A.lB.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.u.a(l.a.a.c)
p=l.b
if(p.a.mq(s)&&p.a.e!=null){p.c=p.a.mf(s)
p.b=!1}}catch(o){r=A.br(o)
q=A.c0(o)
p=t.u.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.mE(p)
m=l.b
m.c=new A.aY(p,n)
p=m}p.b=!0}},
$S:3}
A.ix.prototype={}
A.iH.prototype={}
A.fQ.prototype={$ioO:1}
A.iG.prototype={
mI(a){var s,r,q
t.M.a(a)
try{if(B.G===$.a6){a.$0()
return}A.ph(null,null,this,a,t.w)}catch(q){s=A.br(q)
r=A.c0(q)
A.nr(A.fR(s),t.l.a(r))}},
lN(a){return new A.lN(this,t.M.a(a))},
mG(a,b){b.m("0()").a(a)
if($.a6===B.G)return a.$0()
return A.ph(null,null,this,a,b)},
ep(a,b,c,d){c.m("@<0>").am(d).m("1(2)").a(a)
d.a(b)
if($.a6===B.G)return a.$1(b)
return A.v9(null,null,this,a,b,c,d)},
mH(a,b,c,d,e,f){d.m("@<0>").am(e).am(f).m("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.a6===B.G)return a.$2(b,c)
return A.v8(null,null,this,a,b,c,d,e,f)},
hO(a,b,c,d){return b.m("@<0>").am(c).am(d).m("1(2,3)").a(a)}}
A.lN.prototype={
$0(){return this.a.mI(this.b)},
$S:3}
A.m3.prototype={
$0(){A.qE(this.a,this.b)},
$S:3}
A.fz.prototype={
gu(a){return this.a},
gc7(){return new A.fA(this,this.$ti.m("fA<1>"))},
ac(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.j7(a)},
j7(a){var s=this.d
if(s==null)return!1
return this.cI(this.f3(s,a),a)>=0},
l(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.oR(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.oR(q,b)
return r}else return this.k5(b)},
k5(a){var s,r,q=this.d
if(q==null)return null
s=this.f3(q,a)
r=this.cI(s,a)
return r<0?null:s[r+1]},
i(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.f2(s==null?m.b=A.ne():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.f2(r==null?m.c=A.ne():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.ne()
p=A.iX(b)&1073741823
o=q[p]
if(o==null){A.nf(q,p,[b,c]);++m.a
m.e=null}else{n=m.cI(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
bH(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.m("~(1,2)").a(b)
s=m.f6()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.l(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.f(A.aI(m))}},
f6(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.I(i.a,null,!1,t.z)
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
f2(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.nf(a,b,c)},
f3(a,b){return a[A.iX(b)&1073741823]}}
A.dT.prototype={
cI(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.fA.prototype={
gu(a){return this.a.a},
gI(a){var s=this.a
return new A.fB(s,s.f6(),this.$ti.m("fB<1>"))}}
A.fB.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.f(A.aI(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$iz:1}
A.d_.prototype={
gI(a){var s=this,r=new A.fD(s,s.r,A.m(s).m("fD<1>"))
r.c=s.e
return r},
gu(a){return this.a},
C(a,b){var s,r,q=this
A.m(q).c.a(b)
if(typeof b=="string"&&b!=="__proto__"){s=q.b
return q.f1(s==null?q.b=A.nh():s,b)}else if(typeof b=="number"&&(b&1073741823)===b){r=q.c
return q.f1(r==null?q.c=A.nh():r,b)}else return q.iK(b)},
iK(a){var s,r,q,p=this
A.m(p).c.a(a)
s=p.d
if(s==null)s=p.d=A.nh()
r=p.j6(a)
q=s[r]
if(q==null)s[r]=[p.dQ(a)]
else{if(p.cI(q,a)>=0)return!1
q.push(p.dQ(a))}return!0},
f1(a,b){A.m(this).c.a(b)
if(t.nF.a(a[b])!=null)return!1
a[b]=this.dQ(b)
return!0},
dQ(a){var s=this,r=new A.iE(A.m(s).c.a(a))
if(s.e==null)s.e=s.f=r
else s.f=s.f.b=r;++s.a
s.r=s.r+1&1073741823
return r},
j6(a){return J.aN(a)&1073741823},
cI(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.cm(a[r].a,b))return r
return-1}}
A.iE.prototype={}
A.fD.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
E(){var s=this,r=s.c,q=s.a
if(s.b!==q.r)throw A.f(A.aI(q))
else if(r==null){s.d=null
return!1}else{s.d=s.$ti.m("1?").a(r.a)
s.c=r.b
return!0}},
$iz:1}
A.jX.prototype={
$2(a,b){this.a.i(0,this.b.a(a),this.c.a(b))},
$S:49}
A.H.prototype={
gI(a){return new A.cC(a,this.gu(a),A.aW(a).m("cC<H.E>"))},
bA(a,b){return this.l(a,b)},
bP(a,b){var s,r=this.gu(a)
for(s=0;s<r;++s){if(this.l(a,s)===b)return!0
if(r!==this.gu(a))throw A.f(A.aI(a))}return!1},
hY(a,b){return new A.cX(a,b.m("cX<0>"))},
cj(a,b,c){var s=A.aW(a)
return new A.bi(a,s.am(c).m("1(H.E)").a(b),s.m("@<H.E>").am(c).m("bi<1,2>"))},
dJ(a,b){return A.dN(a,b,null,A.aW(a).m("H.E"))},
hS(a,b){return A.dN(a,0,A.fU(b,"count",t.p),A.aW(a).m("H.E"))},
cl(a,b,c){var s,r=this.gu(a)
A.bl(b,c,r)
A.bl(b,c,this.gu(a))
s=A.aW(a).m("H.E")
s=A.t(A.dN(a,b,c,s),s)
return s},
a8(a,b,c,d){var s
A.aW(a).m("H.E?").a(d)
A.bl(b,c,this.gu(a))
for(s=b;s<c;++s)this.i(a,s,d)},
ab(a,b,c,d,e){var s,r,q
A.aW(a).m("e<H.E>").a(d)
A.bl(b,c,this.gu(a))
s=c-b
if(s===0)return
A.dL(e,"skipCount")
r=J.ae(d)
if(e+s>r.gu(d))throw A.f(A.om())
if(e<b)for(q=s-1;q>=0;--q)this.i(a,b+q,r.l(d,e+q))
else for(q=0;q<s;++q)this.i(a,b+q,r.l(d,e+q))},
aB(a,b,c,d){return this.ab(a,b,c,d,0)},
dI(a,b,c){A.aW(a).m("e<H.E>").a(c)
this.aB(a,b,b+c.length,c)},
D(a){return A.jI(a,"[","]")},
$iB:1,
$ie:1,
$ir:1}
A.ar.prototype={
bH(a,b){var s,r,q,p=A.m(this)
p.m("~(ar.K,ar.V)").a(b)
for(s=this.gc7(),s=s.gI(s),p=p.m("ar.V");s.E();){r=s.gO()
q=this.l(0,r)
b.$2(r,q==null?p.a(q):q)}},
gu(a){var s=this.gc7()
return s.gu(s)},
D(a){return A.mQ(this)},
$ib1:1}
A.k0.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.y(a)
r.a=(r.a+=s)+": "
s=A.y(b)
r.a+=s},
$S:25}
A.eK.prototype={
gI(a){var s=this
return new A.fE(s,s.c,s.d,s.b,s.$ti.m("fE<1>"))},
gd0(a){return this.b===this.c},
gu(a){return(this.c-this.b&this.a.length-1)>>>0},
bA(a,b){var s,r,q,p=this
A.qX(b,p.gu(0),p)
s=p.a
r=s.length
q=(p.b+b&r-1)>>>0
if(!(q>=0&&q<r))return A.a(s,q)
q=s[q]
return q==null?p.$ti.c.a(q):q},
cf(a,b){var s,r,q,p,o,n,m,l,k=this,j=k.$ti
j.m("e<1>").a(b)
s=b.length
r=k.gu(0)
q=r+s
p=k.a
o=p.length
if(q>=o){n=A.I(A.ra(q+(q>>>1)),null,!1,j.m("1?"))
k.c=k.lK(n)
k.a=n
k.b=0
B.c.ab(n,r,q,b,0)
k.c+=s}else{j=k.c
m=o-j
if(s<m){B.c.ab(p,j,j+s,b,0)
k.c+=s}else{l=s-m
B.c.ab(p,j,j+m,b,0)
B.c.ab(k.a,0,l,b,m)
k.c=l}}++k.d},
D(a){return A.jI(this,"{","}")},
hR(){var s,r,q=this,p=q.b
if(p===q.c)throw A.f(A.dv());++q.d
s=q.a
if(!(p<s.length))return A.a(s,p)
r=s[p]
if(r==null)r=q.$ti.c.a(r)
B.c.i(s,p,null)
q.b=(q.b+1&q.a.length-1)>>>0
return r},
lK(a){var s,r,q,p,o,n=this
n.$ti.m("r<1?>").a(a)
s=n.b
r=n.c
q=n.a
if(s<=r){p=r-s
B.c.ab(a,0,p,q,s)
return p}else{o=q.length-s
B.c.ab(a,0,o,q,s)
B.c.ab(a,o,o+n.c,n.a,0)
return n.c+o}},
$irN:1}
A.fE.prototype={
gO(){var s=this.e
return s==null?this.$ti.c.a(s):s},
E(){var s,r,q=this,p=q.a
if(q.c!==p.d)A.a3(A.aI(p))
s=q.d
if(s===q.b){q.e=null
return!1}p=p.a
r=p.length
if(!(s<r))return A.a(p,s)
q.e=p[s]
q.d=(s+1&r-1)>>>0
return!0},
$iz:1}
A.cd.prototype={
cf(a,b){var s
A.m(this).m("e<1>").a(b)
for(s=b.gI(b);s.E();)this.C(0,s.gO())},
cj(a,b,c){var s=A.m(this)
return new A.cp(this,s.am(c).m("1(2)").a(b),s.m("@<1>").am(c).m("cp<1,2>"))},
D(a){return A.jI(this,"{","}")},
$iB:1,
$ie:1}
A.fK.prototype={}
A.lV.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:13}
A.lU.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:13}
A.lS.prototype={
cv(a){var s,r,q=a.length,p=A.bl(0,null,q),o=new Uint8Array(p)
for(s=0;s<p;++s){if(!(s<q))return A.a(a,s)
r=a.charCodeAt(s)
if((r&4294967040)!==0)throw A.f(A.mD(a,"string","Contains invalid characters."))
if(!(s<p))return A.a(o,s)
o[s]=r}return o}}
A.lR.prototype={
cv(a){var s,r,q,p
t.L.a(a)
s=a.length
r=A.bl(0,null,s)
for(q=0;q<r;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if((p&4294967040)!==0){if(!this.a)throw A.f(A.mI("Invalid value in input: "+p,null,null))
return this.j9(a,0,r)}}return A.fh(a,0,r)},
j9(a,b,c){var s,r,q,p
t.L.a(a)
for(s=a.length,r=b,q="";r<c;++r){if(!(r<s))return A.a(a,r)
p=a[r]
q+=A.dF((p&4294967040)!==0?65533:p)}return q.charCodeAt(0)==0?q:q}}
A.d5.prototype={}
A.h9.prototype={}
A.hb.prototype={}
A.hP.prototype={
cz(a){var s
t.L.a(a)
s=B.dF.cv(a)
return s}}
A.jT.prototype={}
A.jS.prototype={}
A.ip.prototype={
lV(a,b){t.L.a(a)
return(b===!0?B.m7:B.m6).cv(a)}}
A.iq.prototype={
cv(a){return new A.iM(this.a).f7(t.L.a(a),0,null,!0)}}
A.iM.prototype={
f7(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.bl(b,c,a.length)
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.ud(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.uc(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.dU(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.ue(o)
l.b=0
throw A.f(A.mI(m,a,p+l.c))}return n},
dU(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.V(b+c,2)
r=q.dU(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.dU(a,s,c,d)}return q.m_(a,b,c,d)},
m_(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.fg(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
A:for(r=k.a;;){for(;;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.dF(f)
e.a+=p
if(d===a0)break A
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.dF(h)
e.a+=p
break
case 65:p=A.dF(h)
e.a+=p;--d
break
default:p=A.dF(h)
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
p=A.dF(a[l])
e.a+=p}else{p=A.fh(a,d,n)
e.a+=p}if(n===a0)break A
d=o}else d=o}if(a1&&g>32)if(r){c=A.dF(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.co.prototype={
Z(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.co)if(this.a===b.a)s=this.b===b.b
return s},
gM(a){return A.k5(this.a,this.b,B.F,B.F)},
bO(a,b){var s
t.cs.a(b)
s=B.a.bO(this.a,b.a)
if(s!==0)return s
return B.a.bO(this.b,b.b)},
D(a){var s=this,r=A.qB(A.rF(s)),q=A.ha(A.rD(s)),p=A.ha(A.rz(s)),o=A.ha(A.rA(s)),n=A.ha(A.rC(s)),m=A.ha(A.rE(s)),l=A.o1(A.rB(s)),k=s.b,j=k===0?"":A.o1(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"},
$ibe:1}
A.lu.prototype={
D(a){return this.a7()}}
A.Z.prototype={
gcF(){return A.ry(this)}}
A.fZ.prototype={
D(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.jf(s)
return"Assertion failed"}}
A.bx.prototype={}
A.bc.prototype={
gdY(){return"Invalid argument"+(!this.a?"(s)":"")},
gdX(){return""},
D(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.y(p),n=s.gdY()+q+o
if(!s.a)return n
return n+s.gdX()+": "+A.jf(s.gek())},
gek(){return this.b}}
A.dK.prototype={
gek(){return A.p7(this.b)},
gdY(){return"RangeError"},
gdX(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.y(q):""
else if(q==null)s=": Not greater than or equal to "+A.y(r)
else if(q>r)s=": Not in inclusive range "+A.y(r)+".."+A.y(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.y(r)
return s}}
A.hu.prototype={
gek(){return A.n(this.b)},
gdY(){return"RangeError"},
gdX(){if(A.n(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gu(a){return this.f}}
A.fk.prototype={
D(a){return"Unsupported operation: "+this.a}}
A.im.prototype={
D(a){return"UnimplementedError: "+this.a}}
A.dM.prototype={
D(a){return"Bad state: "+this.a}}
A.h7.prototype={
D(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.jf(s)+"."}}
A.hU.prototype={
D(a){return"Out of Memory"},
gcF(){return null},
$iZ:1}
A.ff.prototype={
D(a){return"Stack Overflow"},
gcF(){return null},
$iZ:1}
A.lv.prototype={
D(a){return"Exception: "+this.a}}
A.ej.prototype={
D(a){var s=this.a,r=""!==s?"FormatException: "+s:"FormatException",q=this.c
return q!=null?r+(" (at offset "+A.y(q)+")"):r}}
A.e.prototype={
cj(a,b,c){var s=A.m(this)
return A.rb(this,s.am(c).m("1(e.E)").a(b),s.m("e.E"),c)},
gu(a){var s,r=this.gI(this)
for(s=0;r.E();)++s
return s},
bA(a,b){var s,r
A.dL(b,"index")
s=this.gI(this)
for(r=b;s.E();){if(r===0)return s.gO();--r}throw A.f(A.jE(b,b-r,this,null,"index"))},
D(a){return A.qZ(this,"(",")")}}
A.c8.prototype={
D(a){return"MapEntry("+A.y(this.a)+": "+A.y(this.b)+")"}}
A.as.prototype={
gM(a){return A.K.prototype.gM.call(this,0)},
D(a){return"null"}}
A.K.prototype={$iK:1,
Z(a,b){return this===b},
gM(a){return A.fa(this)},
D(a){return"Instance of '"+A.i1(this)+"'"},
gaW(a){return A.vP(this)},
toString(){return this.D(this)}}
A.iI.prototype={
D(a){return""},
$ib5:1}
A.fg.prototype={
gu(a){return this.a.length},
D(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.hd.prototype={
D(a){return"Expando:null"}}
A.k3.prototype={
D(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.mq.prototype={
$1(a){var s,r,q,p
if(A.pg(a))return a
s=this.a
if(s.ac(a))return s.l(0,a)
if(t.av.b(a)){r={}
s.i(0,a,r)
for(s=a.gc7(),s=s.gI(s);s.E();){q=s.gO()
r[q]=this.$1(a.l(0,q))}return r}else if(t.e7.b(a)){p=[]
s.i(0,a,p)
B.c.cf(p,J.qm(a,this,t.z))
return p}else return a},
$S:14}
A.ms.prototype={
$1(a){return this.a.ei(this.b.m("0/?").a(a))},
$S:8}
A.mt.prototype={
$1(a){if(a==null)return this.a.hs(new A.k3(a===undefined))
return this.a.hs(a)},
$S:8}
A.me.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.pf(a))return a
s=this.a
a.toString
if(s.ac(a))return s.l(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.a3(A.aw(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.fU(!0,"isUtc",t.y)
return new A.co(r,0,!0)}if(a instanceof RegExp)throw A.f(A.aX("structured clone of RegExp",null))
if(a instanceof Promise)return A.w3(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.J(p,p)
s.i(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.aV(n),p=s.gI(n);p.E();)m.push(A.pt(p.gO()))
for(l=0;l<s.gu(n);++l){k=s.l(n,l)
if(!(l<m.length))return A.a(m,l)
j=m[l]
if(k!=null)o.i(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.i(0,a,o)
h=A.n(a.length)
for(s=J.aV(i),l=0;l<h;++l)o.push(this.$1(s.l(i,l)))
return o}return a},
$S:14}
A.jt.prototype={
iq(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=a.length
for(s=0;s<f;++s){r=a[s]
if(r>g.b)g.b=r
if(r<g.c)g.c=r}r=g.b
q=B.a.U(1,r)
p=g.a=new Uint32Array(q)
for(o=1,n=0,m=2;o<=r;){for(l=o<<16,s=0;s<f;++s)if(a[s]===o){for(k=n,j=0,i=0;i<o;++i){j=(j<<1|k&1)>>>0
k=k>>>1}for(h=(l|s)>>>0,i=j;i<q;i+=m){if(!(i>=0))return A.a(p,i)
p[i]=h}++n}++o
n=n<<1>>>0
m=m<<1>>>0}}}
A.ew.prototype={
a7(){return"InflateFormat."+this.b}}
A.ev.prototype={
lZ(a){var s,r,q,p,o,n,m=this,l="Truncated zlib stream"
switch(m.f.a){case 0:s=m.a
r=s.c
q=s.d
q===$&&A.c("_length")
if(r>=q){if(m.d===0&&m.b!==B.dz)throw A.f(A.bb("Empty input is not a "+m.b.b+" stream"))
m.f=B.cJ
return!1}if(m.b===B.aM)if(!m.l1()){if(m.d!==0)throw A.f(A.bb("Data after the last gzip member"))
s.c=r
m.b=B.a3}if(m.b===B.a3){if(s.gu(0)<2)A.a3(A.bb(l))
p=s.H()
o=s.H()
if((p&15)!==8)A.a3(A.bb("Only deflate compression is supported"))
if(B.a.a5(p*256+o,31)!==0)A.a3(A.bb("Invalid zlib header"))
if((o&32)!==0)A.a3(A.bb("zlib preset dictionaries are not supported"))}m.e=a.e+a.f
m.c=new A.jF(s,a)
m.f=B.md
return!0
case 1:s=m.c
r=!s.kw()
if(r&&s.d)A.a3(A.bb("Invalid deflate data"))
if(r)m.f=B.me
return!0
case 2:s=m.b
if(s===B.aM){s=m.a
if(s.gu(0)<8)throw A.f(A.bb("Truncated gzip stream"))
s.k()
n=s.k()
if(B.a.a5(a.e+a.f-m.e,4294967296)!==n)throw A.f(A.bb("gzip member length does not match"))}else if(s===B.a3){s=m.a
if(s.gu(0)<4)throw A.f(A.bb(l))
s.k()}++m.d
s=m.b===B.aM
m.f=s?B.b5:B.cJ
return s
case 3:return!1}},
l1(){var s,r,q,p,o=this.a
if(o.gu(0)<10)return!1
if(o.n()!==35615)return!1
if(o.H()!==8)return!1
s=o.H()
o.k()
o.H()
o.H()
if((s&4)!==0){if(o.gu(0)<2)return!1
r=o.n()
if(o.gu(0)<r)return!1
q=o.c+=r
p=o.d
p===$&&A.c("_length")
o.c=B.a.F(q,0,p)}if((s&8)!==0&&!this.fT())return!1
if((s&16)!==0&&!this.fT())return!1
if((s&2)!==0){if(o.gu(0)<2)return!1
o.n()}return!0},
fT(){var s,r,q=this.a
for(;;){s=q.c
r=q.d
r===$&&A.c("_length")
if(!(s<r))break
r=q.b
r.toString
q.c=s+1
if(!(s>=0&&s<r.length))return A.a(r,s)
if(r[s]===0)return!0}return!1},
$iqu:1}
A.dW.prototype={
a7(){return"_State."+this.b}}
A.lo.prototype={}
A.lX.prototype={
hA(a,b){var s
t.L.a(a)
s=A.rr(B.a2)
this.m6(A.hv(a,B.T,null,null),s,b,!1,null)
return J.C(B.d.gq(s.c),s.c.byteOffset,s.b)},
m6(a,b,c,d,e){var s=b.a
b.a=B.a2
try{this.jO(a,b,c,!1,e)}finally{b.slP(s)}},
jO(a,b,c,d,e){var s,r,q,p,o,n,m,l,k=(B.a.F(15,0,15)-8<<4|8)>>>0
b.p(k)
s=k*256
for(r=0;q=(r|0)>>>0,B.a.a5(s+q,31)!==0;)++r
b.p(q)
p=a.c
o=A.vM(a)
a.c=p
A.qC(a,6,b,15)
q=o&255
n=o>>>24&255
m=o>>>16&255
l=o>>>8&255
if(b.a===B.a2){b.p(n)
b.p(m)
b.p(l)
b.p(q)}else{b.p(q)
b.p(l)
b.p(m)
b.p(n)}}}
A.dR.prototype={
a7(){return"_DeflateFlushMode."+this.b}}
A.jc.prototype={
kj(a,b){var s,r,q,p,o=this,n=!0
if(b>=9)if(b<=15)n=a>9
if(n)return!1
s=o.k7(a)
if(s==null)return!1
$.bs.b=s
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
o.bF=16384
o.xr=49152
o.k4=a
o.w=o.x=o.ok=0
o.c=113
o.d=0
p=o.p4
p.a=n
p.c=$.q5()
p=o.R8
p.a=r
p.c=$.q4()
p=o.RG
p.a=q
p.c=$.q3()
o.bk=o.aZ=0
o.bS=8
o.fv()
o.ay=2*o.Q
B.D.a8(o.CW,0,o.cy,0)
o.k2=o.fr=o.id=0
o.fx=o.k3=2
o.cx=o.go=0
return!0},
jG(a){var s,r,q,p,o=this,n=o.x
n===$&&A.c("_pending")
if(n!==0)o.e0()
n=o.a
s=n.c
n=n.d
n===$&&A.c("_length")
r=!0
if(s>=n){n=o.k2
n===$&&A.c("_lookAhead")
if(n===0)n=a!==B.aE&&o.c!==666
else n=r}else n=r
if(n){switch($.bs.cN().e){case 0:q=o.jJ(a)
break
case 1:q=o.jH(a)
break
case 2:q=o.jI(a)
break
default:q=-1
break}n=q===2
if(n||q===3)o.c=666
if(q===0||n)return 0
if(q===1){if(a===B.mb){o.aL(2,3)
o.ct(256,B.ao)
o.ho()
n=o.bS
n===$&&A.c("_lastEOBLen")
s=o.bk
s===$&&A.c("_numValidBits")
if(1+n+10-s<9){o.aL(2,3)
o.ct(256,B.ao)
o.ho()}o.bS=7}else{o.fX(0,0,!1)
if(a===B.mc){n=o.cy
n===$&&A.c("_hashSize")
s=o.CW
p=0
for(;p<n;++p){s===$&&A.c("_head")
s.$flags&2&&A.b(s)
if(!(p<s.length))return A.a(s,p)
s[p]=0}}}o.e0()}}if(a!==B.ad)return 0
return 1},
fv(){var s=this,r=s.p1
r===$&&A.c("_dynamicLengthTree")
B.D.a8(r,0,572,0)
r=s.p2
r===$&&A.c("_dynamicDistTree")
B.D.a8(r,0,60,0)
r=s.p3
r===$&&A.c("_bitLengthTree")
B.D.a8(r,0,38,0)
r=s.p1
r.$flags&2&&A.b(r)
r[512]=1
s.y2=s.ci=s.aV=s.bG=0},
ea(a,b){var s,r,q,p,o,n,m=this.ry
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
o=A.o2(a,o,m[r],p)}else o=!1
if(o)++r
if(!(r>=0&&r<573))return A.a(m,r)
if(A.o2(a,s,m[r],p))break
o=m[r]
q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=o
n=r<<1>>>0
b=r
r=n}q&2&&A.b(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=s},
fO(a,b){var s,r,q,p,o,n,m,l,k,j,i,h="_bitLengthTree",g=a.length
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
iV(){var s,r,q=this,p=q.p1
p===$&&A.c("_dynamicLengthTree")
s=q.p4.b
s===$&&A.c("maxCode")
q.fO(p,s)
s=q.p2
s===$&&A.c("_dynamicDistTree")
p=q.R8.b
p===$&&A.c("maxCode")
q.fO(s,p)
q.RG.dN(q)
for(p=q.p3,r=18;r>=3;--r){p===$&&A.c("_bitLengthTree")
s=B.ax[r]*2+1
if(!(s<78))return A.a(p,s)
if(p[s]!==0)break}p=q.aV
p===$&&A.c("_optimalLen")
q.aV=p+(3*(r+1)+5+5+4)
return r},
ln(a,b,c){var s,r,q,p,o=this
o.aL(a-257,5)
s=b-1
o.aL(s,5)
o.aL(c-4,4)
for(r=0;r<c;++r){q=o.p3
q===$&&A.c("_bitLengthTree")
if(!(r<19))return A.a(B.ax,r)
p=B.ax[r]*2+1
if(!(p<78))return A.a(q,p)
o.aL(q[p],3)}q=o.p1
q===$&&A.c("_dynamicLengthTree")
o.fP(q,a-1)
q=o.p2
q===$&&A.c("_dynamicDistTree")
o.fP(q,s)},
fP(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_bitLengthTree",d=a.length
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
f.aL(g&65535,h[i]&65535)}while(--m,m!==0)}else if(s!==0){if(s!==n){l=f.p3
l===$&&A.c(e)
p.a(l)
i=s*2
if(!(i<78))return A.a(l,i)
h=l[i];++i
if(!(i<78))return A.a(l,i)
f.aL(h&65535,l[i]&65535);--m}l=f.p3
l===$&&A.c(e)
p.a(l)
f.aL(l[32]&65535,l[33]&65535)
f.aL(m-3,2)}else{l=f.p3
if(m<=10){l===$&&A.c(e)
p.a(l)
f.aL(l[34]&65535,l[35]&65535)
f.aL(m-3,3)}else{l===$&&A.c(e)
p.a(l)
f.aL(l[36]&65535,l[37]&65535)
f.aL(m-11,7)}}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
kU(a,b,c){var s,r,q=this
if(c===0)return
s=q.f
s===$&&A.c("_pendingBuffer")
r=q.x
r===$&&A.c("_pending")
B.d.ab(s,r,r+c,a,b)
q.x=q.x+c},
bn(a){var s,r=this.f
r===$&&A.c("_pendingBuffer")
s=this.x
s===$&&A.c("_pending")
this.x=s+1
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a},
ct(a,b){var s,r,q
t.L.a(b)
s=a*2
r=b.length
if(!(s<r))return A.a(b,s)
q=b[s];++s
if(!(s<r))return A.a(b,s)
this.aL(q&65535,b[s]&65535)},
aL(a,b){var s,r=this,q="_bitBuffer",p=r.bk
p===$&&A.c("_numValidBits")
s=r.aZ
if(p>16-b){s===$&&A.c(q)
p=r.aZ=(s|B.a.U(a,p)&65535)>>>0
r.bn(p)
r.bn(A.aL(p,8))
r.aZ=A.aL(a,16-r.bk)
r.bk=r.bk+(b-16)}else{s===$&&A.c(q)
r.aZ=(s|B.a.U(a,p)&65535)>>>0
r.bk=p+b}},
cP(a,b){var s,r,q,p,o,n=this,m="_dynamicLengthTree",l="_matches",k="_dynamicDistTree",j=n.f
j===$&&A.c("_pendingBuffer")
s=n.bF
s===$&&A.c("_dbuf")
r=n.y2
r===$&&A.c("_lastLit")
r=s+r*2
s=A.aL(a,8)
j.$flags&2&&A.b(j)
if(!(r<j.length))return A.a(j,r)
j[r]=s
s=n.f
r=n.bF
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
j[s]=r+1}else{j=n.ci
j===$&&A.c(l)
n.ci=j+1
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
s=A.oS(a-1)*2
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
p+=r[q]*(5+B.a6[o])}p=A.aL(p,3)
r=n.ci
r===$&&A.c(l)
q=n.y2
if(r<q/2&&p<(j-s)/2)return!0
j=q}s=n.y1
s===$&&A.c("_litBufferSize")
return j===s-1},
f5(a,b){var s,r,q,p,o,n,m,l,k=this,j=t.L
j.a(a)
j.a(b)
j=k.y2
j===$&&A.c("_lastLit")
if(j!==0){s=0
do{j=k.f
j===$&&A.c("_pendingBuffer")
r=k.bF
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
if(o===0)k.ct(n,a)
else{m=B.aT[n]
k.ct(m+256+1,a)
if(!(m<29))return A.a(B.aO,m)
l=B.aO[m]
if(l!==0)k.aL(n-B.e4[m],l);--o
m=A.oS(o)
k.ct(m,b)
if(!(m<30))return A.a(B.a6,m)
l=B.a6[m]
if(l!==0)k.aL(o-B.fb[m],l)}}while(s<k.y2)}k.ct(256,a)
if(513>=a.length)return A.a(a,513)
k.bS=a[513]},
i7(){var s,r,q,p,o,n="_dynamicLengthTree"
for(s=this.p1,r=0,q=0;r<7;){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}for(o=0;r<128;){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
o+=s[p];++r}while(r<256){s===$&&A.c(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}this.y=q>A.aL(o,2)?0:1},
ho(){var s=this,r="_bitBuffer",q=s.bk
q===$&&A.c("_numValidBits")
if(q===16){q=s.aZ
q===$&&A.c(r)
s.bn(q)
s.bn(A.aL(q,8))
s.bk=s.aZ=0}else if(q>=8){q=s.aZ
q===$&&A.c(r)
s.bn(q)
s.aZ=A.aL(s.aZ,8)
s.bk=s.bk-8}},
eV(){var s=this,r="_bitBuffer",q=s.bk
q===$&&A.c("_numValidBits")
if(q>8){q=s.aZ
q===$&&A.c(r)
s.bn(q)
s.bn(A.aL(q,8))}else if(q>0){q=s.aZ
q===$&&A.c(r)
s.bn(q)}s.bk=s.aZ=0},
c1(a){var s,r,q,p,o,n=this,m=n.fr
m===$&&A.c("_blockStart")
if(m>=0)s=m
else s=-1
r=n.id
r===$&&A.c("_strStart")
m=r-m
r=n.k4
r===$&&A.c("_level")
if(r>0){if(n.y===2)n.i7()
n.p4.dN(n)
n.R8.dN(n)
q=n.iV()
r=n.aV
r===$&&A.c("_optimalLen")
p=A.aL(r+3+7,3)
r=n.bG
r===$&&A.c("_staticLen")
o=A.aL(r+3+7,3)
if(o<=p)p=o}else{o=m+5
p=o
q=0}if(m+4<=p&&s!==-1)n.fX(s,m,a)
else if(o===p){n.aL(2+(a?1:0),3)
n.f5(B.ao,B.bO)}else{n.aL(4+(a?1:0),3)
m=n.p4.b
m===$&&A.c("maxCode")
s=n.R8.b
s===$&&A.c("maxCode")
n.ln(m+1,s+1,q+1)
s=n.p1
s===$&&A.c("_dynamicLengthTree")
m=n.p2
m===$&&A.c("_dynamicDistTree")
n.f5(s,m)}n.fv()
if(a)n.eV()
n.fr=n.id
n.e0()},
jJ(a){var s,r,q,p,o,n=this,m=n.r
m===$&&A.c("_pendingBufferSize")
s=m-5
s=65535>s?s:65535
for(m=a===B.aE;;){r=n.k2
r===$&&A.c("_lookAhead")
if(r<=1){n.e_()
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
if(r-q>=o-262)n.c1(!1)}m=a===B.ad
n.c1(m)
return m?3:1},
fX(a,b,c){var s,r=this
r.aL(c?1:0,3)
r.eV()
r.bS=8
r.bn(b)
r.bn(A.aL(b,8))
s=(~b>>>0)+65536&65535
r.bn(s)
r.bn(A.aL(s,8))
s=r.ax
s===$&&A.c("_window")
r.kU(s,a,b)},
e_(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_windowSize",f=h.a
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
B.d.ab(r,0,s,r,s)
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
l=h.kX(s,h.id+h.k2,p)
s=h.k2=h.k2+l
if(s>=3){r=h.ax
q=h.id
n=r.length
if(q>>>0!==q||q>=n)return A.a(r,q)
j=r[q]&255
h.cx=j
i=h.dy
i===$&&A.c("_hashShift")
i=B.a.U(j,i);++q
if(!(q<n))return A.a(r,q)
q=r[q]
r=h.dx
r===$&&A.c("_hashMask")
h.cx=((i^q&255)&r)>>>0}}while(s<262&&!(f.c>=f.d))},
jH(a){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_insertHash",f="_hashShift",e="_window",d="_strStart",c="_hashMask",b="_windowMask"
for(s=a===B.aE,r=$.bs.a,q=0;;){p=h.k2
p===$&&A.c("_lookAhead")
if(p<262){h.e_()
p=h.k2
if(p<262&&s)return 0
if(p===0)break}if(p>=3){p=h.cx
p===$&&A.c(g)
o=h.dy
o===$&&A.c(f)
o=B.a.U(p,o)
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
if(p!==2)h.fx=h.fB(q)}p=h.fx
p===$&&A.c("_matchLength")
o=h.id
if(p>=3){o===$&&A.c(d)
j=h.cP(o-h.k1,p-3)
p=h.k2
o=h.fx
p-=o
h.k2=p
n=$.bs.b
if(n===$.bs)A.a3(A.jR(r))
if(o<=n.b&&p>=3){p=h.fx=o-1
do{o=h.id=h.id+1
n=h.cx
n===$&&A.c(g)
m=h.dy
m===$&&A.c(f)
m=B.a.U(n,m)
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
l=B.a.U(m,l);++p
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
h.id=h.id+1}if(j)h.c1(!1)}s=a===B.ad
h.c1(s)
return s?3:1},
jI(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_insertHash",e="_hashShift",d="_window",c="_strStart",b="_hashMask",a="_windowMask",a0="_matchAvailable"
for(s=a1===B.aE,r=$.bs.a,q=0;;){p=g.k2
p===$&&A.c("_lookAhead")
if(p<262){g.e_()
p=g.k2
if(p<262&&s)return 0
if(p===0)break}if(p>=3){p=g.cx
p===$&&A.c(f)
o=g.dy
o===$&&A.c(e)
o=B.a.U(p,o)
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
if(q!==0){n=$.bs.b
if(n===$.bs)A.a3(A.jR(r))
if(p<n.b){p=g.id
p===$&&A.c(c)
o=g.Q
o===$&&A.c("_windowSize")
o=(p-q&65535)<=o-262
p=o}else p=o}else p=o
o=2
if(p){p=g.ok
p===$&&A.c("_strategy")
if(p!==2){p=g.fB(q)
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
m=B.a.U(n,m)
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
g.go=0}s=a1===B.ad
g.c1(s)
return s?3:1},
fB(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=$.bs.cN().d,a=c.id
a===$&&A.c("_strStart")
s=c.k3
s===$&&A.c("_prevLength")
r=c.Q
r===$&&A.c("_windowSize")
r-=262
q=a>r?a-r:0
p=$.bs.cN().c
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
if(c.k3>=$.bs.cN().a)b=b>>>2
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
kX(a,b,c){var s,r,q,p,o,n,m=this
if(c!==0){s=m.a
r=s.c
s=s.d
s===$&&A.c("_length")
s=r>=s}else s=!0
if(s)return 0
q=m.a.af(c)
p=q.gu(q)
if(p===0)return 0
o=q.Y()
n=o.length
if(p>n)p=n
B.d.aB(a,b,b+p,o)
m.e+=p
m.d=A.bB(o,m.d)
return p},
e0(){var s,r=this,q=r.x
q===$&&A.c("_pending")
s=r.f
s===$&&A.c("_pendingBuffer")
r.b.er(s,q)
s=r.w
s===$&&A.c("_pendingOut")
r.w=s+q
q=r.x-q
r.x=q
if(q===0)r.w=0},
k7(a){switch(a){case 0:return new A.b8(0,0,0,0,0)
case 1:return new A.b8(4,4,8,4,1)
case 2:return new A.b8(4,5,16,8,1)
case 3:return new A.b8(4,6,32,32,1)
case 4:return new A.b8(4,4,16,16,2)
case 5:return new A.b8(8,16,32,32,2)
case 6:return new A.b8(8,16,128,128,2)
case 7:return new A.b8(8,32,128,256,2)
case 8:return new A.b8(32,128,258,1024,2)
case 9:return new A.b8(32,258,258,4096,2)}return null}}
A.b8.prototype={}
A.lH.prototype={
k0(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3="_optimalLen",a4=a2.a
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
e=a5.aV
e===$&&A.c(a3)
a5.aV=e+a*(m+b)
if(k){e=a5.bG
e===$&&A.c("_staticLen")
if(!(d<r.length))return A.a(r,d)
a5.bG=e+a*(r[d]+b)}}if(g===0)return
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
if(j!==m){e=a5.aV
e===$&&A.c(a3)
if(!(n>=0&&n<i))return A.a(a4,n)
a5.aV=e+(m-j)*a4[n]
a4.$flags&2&&A.b(a4)
a4[k]=m}--f}}},
dN(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.a
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
f=a1.aV
f===$&&A.c("_optimalLen")
a1.aV=f-1
if(i){f=a1.bG
f===$&&A.c("_staticLen");++h
if(!(h<r.length))return A.a(r,h)
a1.bG=f-r[h]}}a.b=j
for(k=B.a.V(h,2);k>=1;--k)a1.ea(a0,k)
g=q
do{k=p[1]
i=a1.to--
if(!(i>=0&&i<573))return A.a(p,i)
i=p[i]
o&2&&A.b(p)
p[1]=i
a1.ea(a0,1)
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
a1.ea(a0,1)
if(a1.to>=2){g=b
continue}else break}while(!0)
s=--a1.x1
o=p[1]
if(!(s>=0&&s<573))return A.a(p,s)
p[s]=o
a.k0(a1)
A.tS(a0,j,a1.rx)}}
A.lO.prototype={}
A.jF.prototype={
gc3(){var s=this.a
if(s==null)return s
s.d===$&&A.c("_length")
return s},
kw(){var s,r,q,p=this,o=p.gc3()
if(o!=null){s=o.c
r=o.d
r===$&&A.c("_length")
r=s>=r
s=r}else s=!0
if(s)return!1
q=p.bo(3)
switch(B.a.j(q,1)){case 0:if(p.kG()===-1){p.d=!0
return!1}break
case 1:if(p.fb($.pQ(),$.pP())===-1){p.d=!0
return!1}break
case 2:if(p.kx()===-1){p.d=!0
return!1}break
default:p.d=!0
return!1}return(q&1)===0},
bo(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.f,s<a){s=o.gc3()
r=s.c
s=s.d
s===$&&A.c("_length")
if(r>=s)return-1
s=o.gc3()
r=s.b
r.toString
s=s.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
q=r[s]
s=o.e
r=o.f
o.e=(s|B.a.U(q,r))>>>0
o.f=r+8}r=o.e
p=B.a.S(1,a)
o.e=B.a.a6(r,a)
o.f=s-a
return(r&p-1)>>>0},
ec(a){var s,r,q,p,o,n,m,l=this,k=a.a
k===$&&A.c("table")
s=a.b
while(r=l.f,r<s){r=l.gc3()
q=r.c
r=r.d
r===$&&A.c("_length")
if(q>=r)return-1
r=l.gc3()
q=r.b
q.toString
r=r.c++
if(!(r>=0&&r<q.length))return A.a(q,r)
p=q[r]
r=l.e
q=l.f
l.e=(r|B.a.U(p,q))>>>0
l.f=q+8}q=l.e
o=(q&B.a.U(1,s)-1)>>>0
if(!(o<k.length))return A.a(k,o)
n=k[o]
m=n>>>16
if(m===0)return-1
l.e=B.a.a6(q,m)
l.f=r-m
return n&65535},
kG(){var s,r,q=this
q.f=q.e=0
s=q.bo(16)
r=q.bo(16)
if(s!==0&&s!==(r^65535)>>>0)return-1
if(s>q.gc3().gu(0))return-1
q.c.i1(q.gc3().af(s))
return 0},
kx(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.bo(5)
if(h===-1)return-1
h+=257
if(h>288)return-1
s=i.bo(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=i.bo(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=i.bo(3)
if(o===-1)return-1
n=B.ax[p]
if(!(n<19))return A.a(q,n)
q[n]=o}m=A.hl(q)
n=h+s
l=new Uint8Array(n)
k=J.C(B.d.gq(l),0,h)
j=J.C(B.d.gq(l),h,s)
if(i.ki(n,m,l)===-1)return-1
return i.fb(A.hl(k),A.hl(j))},
fb(a,b){var s,r,q,p,o,n,m,l=this
for(s=l.c;;){r=l.ec(a)
if(r<0||r>285)return-1
if(r===256)break
if(r<256){s.p(r&255)
continue}q=r-257
if(!(q>=0&&q<29))return A.a(B.c9,q)
p=B.c9[q]
o=l.bo(B.kW[q])
n=l.ec(b)
if(n<0||n>29)return-1
if(!(n>=0&&n<30))return A.a(B.ca,n)
m=B.ca[n]+l.bo(B.a6[n])
if(m<1||m>s.gu(s))return-1
s.hZ(m,p+o)}while(s=l.f,s>=8){l.f=s-8
s=l.gc3()
p=--s.c
o=s.d
o===$&&A.c("_length")
s.c=B.a.F(p,0,o)}return 0},
ki(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=0,r=0;r<a;){q=k.ec(b)
if(q===-1)return-1
p=0
switch(q){case 16:o=k.bo(2)
if(o===-1)return-1
o+=3
if(r+o>a)return-1
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=s}break
case 17:o=k.bo(3)
if(o===-1)return-1
o+=3
if(r+o>a)return-1
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.b(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
case 18:o=k.bo(7)
if(o===-1)return-1
o+=11
if(r+o>a)return-1
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
A.fY.prototype={}
A.e9.prototype={
a7(){return"ByteOrder."+this.b}}
A.ex.prototype={
gen(){return this.e},
eB(a){return this.e=a},
gu(a){var s=this,r=s.d
if(r!=null)return Math.max(0,r-s.e)
return s.b.hP(s.c+s.e)},
gmm(){var s,r,q=this,p=q.d
if(p!=null&&q.e>=p)return!0
s=q.b
r=q.c+q.e
s.dg(r,1)
return r>=s.e+s.f},
hq(){if(this.c===0&&this.d==null){var s=this.b
s.d=new Uint8Array(0)
s.e=s.e+s.f
s.f=0
s.w=!0}},
eJ(a,b){var s=this.d
if(s!=null)a=Math.min(a,Math.max(0,s-b))
return A.ok(this,b,a)},
H(){var s,r=this
if(r.gmm())return 0
s=r.b.lO(r.c+r.e);++r.e
return s},
af(a){var s,r,q=this,p=q.d
if(p!=null)a=Math.max(0,Math.min(a,p-q.e))
s=q.e
r=A.ok(q,s,a)
q.e=s+a
return r},
Y(){var s,r,q=this,p=q.d
if(p!=null){s=q.e
return q.b.hL(q.c+s,Math.max(0,p-s))}s=q.b
r=q.c+q.e
return s.hL(r,s.hP(r))}}
A.iz.prototype={
gu(a){return this.e+this.f},
dg(a,b){var s,r=this,q=r.e
if(a<q)throw A.f(A.bb("Position "+a+" of the decoded data has already been read past, only the last "+r.f+" bytes from "+q+" are still held"))
r.r=a
q=r.b
s=a+b
for(;;){if(!(!r.w&&r.e+r.f<s))break
if(!q.lZ(r))r.w=!0}},
lO(a){var s,r,q=this
q.dg(a,1)
s=q.e
if(a>=s+q.f)return 0
r=q.d
s=a-s
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
hL(a,b){var s,r,q=this
q.dg(a,b)
s=q.e
r=Math.max(0,Math.min(b,s+q.f-a))
s=a-s
return B.d.cl(q.d,s,s+r)},
hP(a){this.dg(a,0)
return Math.max(0,this.e+this.f-a)},
ef(a){var s,r,q,p,o=this,n=o.f,m=o.d
if(n+a<=m.length)return
s=o.e
r=Math.max(s,Math.min(o.r-o.c,s+n-32768))-s
if(r>0){B.d.ab(m,0,n-r,m,r)
n=o.f-=r
o.e+=r}m=n+a
s=o.d
q=s.length
if(m>q){m=Math.max(q*2,m)
p=new Uint8Array(m)
B.d.aB(p,0,n,s)
o.d=p}},
p(a){var s,r,q=this
if(q.f===q.d.length)q.ef(1)
s=q.d
r=q.f++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
er(a,b){var s,r,q=this
t.L.a(a)
b=a.length
q.ef(b)
s=q.d
r=q.f
B.d.aB(s,r,r+b,a)
q.f+=b},
a2(a){return this.er(a,null)},
i1(a){return this.a2(a.Y())},
hZ(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
i.ef(b)
s=i.f
r=s-a
if(r<0)throw A.f(A.bb("Back reference before the start of the data"))
q=s+b
if(a>=b){p=i.d
B.d.ab(p,s,q,p,r)}else for(p=i.d,o=p.length,n=p.$flags|0,m=r;s<q;s=l,m=k){l=s+1
k=m+1
if(!(m<o))return A.a(p,m)
j=p[m]
n&2&&A.b(p)
if(!(s>=0&&s<o))return A.a(p,s)
p[s]=j}i.f+=b}}
A.ey.prototype={
gen(){return this.c},
gu(a){var s=this.b
return s==null?0:s.length-this.c},
eB(a){this.c=a},
eJ(a,b){var s=this.b
if(s==null)return A.hv(A.j([],t.t),B.T,null,null)
return A.hv(s,this.a,a,b)},
H(){var s,r=this.b
r.toString
s=this.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
Y(){var s,r,q=this,p=q.b
if(p==null)return new Uint8Array(0)
s=q.gu(0)
r=p.length-q.c
if(s<0||s>r)s=r
return J.C(B.d.gq(p),q.b.byteOffset+q.c,s)}}
A.ez.prototype={
n(){var s=this.H(),r=this.H()
if(this.a===B.a2)return(s<<8|r)>>>0
return(r<<8|s)>>>0},
k(){var s=this,r=s.H(),q=s.H(),p=s.H(),o=s.H()
if(s.a===B.a2)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
af(a){var s=this,r=s.eJ(a,s.gen())
s.eB(s.gen()+r.gu(r))
return r}}
A.hW.prototype={
p(a){var s,r,q=this
if(q.b===q.c.length)q.kv()
s=q.c
r=q.b++
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
er(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=a.length
while(s=o.b,r=s+b,q=o.c,p=q.length,r>p)o.dl(r-p)
B.d.aB(q,s,r,a)
o.b+=b},
i1(a){var s,r,q,p,o=this
while(s=o.b,r=a.gu(a),q=o.c,s+r>q.length)o.dl(o.b+a.gu(a)-o.c.length)
if(a instanceof A.ey){s=a.b
if(s!=null){r=o.b
B.d.ab(q,r,r+a.gu(0),s,a.c)}}else{p=a.Y()
s=o.c
r=o.b
B.d.ab(s,r,r+a.gu(a),p,0)}o.b=o.b+a.gu(a)},
hZ(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
while(s=i.b,r=s+b,q=i.c,p=q.length,r>p)i.dl(r-p)
o=s-a
if(a>=b)B.d.ab(q,s,r,q,o)
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
B.d.aB(s,0,q,r)
this.c=s},
kv(){return this.dl(null)},
gu(a){return this.b}}
A.eY.prototype={
slP(a){this.a=t.aO.a(a)}}
A.j1.prototype={}
A.j2.prototype={
D(a){return"Exception: "+this.a}}
A.bD.prototype={
D(a){return"ColorTriplet("+A.y(this.a)+", "+A.y(this.b)+", "+A.y(this.c)+")"}}
A.ja.prototype={
a7(){return"Channel."+this.b}}
A.W.prototype={
E(){var s=this.b
return++this.a<s.gu(s)},
gO(){return this.b.l(0,this.a)},
$iz:1}
A.d6.prototype={
X(){return new A.d6(new Uint16Array(A.p(this.a)))},
gL(){return B.H},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=A.O(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){return this.gt()},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else if(r>1){s=s[1]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else if(r>2){s=s[2]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else if(r>3){s=s[3]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
ga1(){return this.gv()/1},
gaq(){return this.a.length===2?this.gt():A.a2(this)},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.d7.prototype={
X(){return new A.d7(new Float32Array(A.p(this.a)))},
gL(){return B.I},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.b(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:1
return s},
ga1(){return this.gv()/1},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.d8.prototype={
X(){return new A.d8(new Float64Array(A.p(this.a)))},
gL(){return B.Q},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.b(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:1
return s},
ga1(){return this.gv()/1},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.d9.prototype={
X(){return new A.d9(new Int16Array(A.p(this.a)))},
gL(){return B.V},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:0
return s},
ga1(){return this.gv()/32767},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.da.prototype={
X(){return new A.da(new Int32Array(A.p(this.a)))},
gL(){return B.W},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:0
return s},
ga1(){return this.gv()/2147483647},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.db.prototype={
X(){return new A.db(new Int8Array(A.p(this.a)))},
gL(){return B.U},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:0
return s},
ga1(){return this.gv()/127},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.dc.prototype={
X(){var s=this.b
s===$&&A.c("data")
return new A.dc(this.a,s)},
gL(){return B.A},
gR(){return null},
c_(a){var s
if(a<this.a){s=this.b
s===$&&A.c("data")
s=B.a.a0(s,7-a)&1}else s=0
return s},
cn(a,b){var s
if(a>=this.a)return
a=7-a
s=this.b
s===$&&A.c("data")
this.b=b!==0?(s|B.a.U(1,a))>>>0:(s&~(B.a.U(1,a)&255))>>>0},
l(a,b){return this.c_(b)},
i(a,b,c){return this.cn(b,c)},
gW(){return this.c_(0)},
gt(){return this.c_(0)},
gA(){return this.c_(this.a===2?0:1)},
gB(){return this.c_(this.a===2?0:2)},
gv(){return this.c_(this.a===2?1:3)},
ga1(){return this.c_(this.a===2?1:3)/1},
gaq(){return this.a===2?this.c_(0):A.a2(this)},
ap(a,b,c,d){var s,r=this
r.cn(0,a)
s=r.a
if(s===2)r.cn(1,d)
else if(s>2){r.cn(1,b)
r.cn(2,c)
r.cn(3,d)}},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1,
gu(a){return this.a}}
A.dd.prototype={
X(){return new A.dd(new Uint16Array(A.p(this.a)))},
gL(){return B.n},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:0
return s},
ga1(){return this.gv()/65535},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.de.prototype={
X(){var s=this.b
s===$&&A.c("data")
return new A.de(this.a,s)},
gL(){return B.w},
gR(){return null},
c0(a){var s
if(a<this.a){s=this.b
s===$&&A.c("data")
s=B.a.a0(s,6-(a<<1>>>0))&3}else s=0
return s},
co(a,b){var s,r,q
if(a>=this.a)return
if(!(a>=0&&a<4))return A.a(B.bA,a)
s=B.bA[a]
r=B.b.h(b)
q=this.b
q===$&&A.c("data")
this.b=(q&s|B.a.U(r&3,6-(a<<1>>>0)))>>>0},
l(a,b){return this.c0(b)},
i(a,b,c){return this.co(b,c)},
gW(){return this.c0(0)},
gt(){return this.c0(0)},
gA(){return this.c0(this.a===2?0:1)},
gB(){return this.c0(this.a===2?0:2)},
gv(){return this.c0(this.a===2?1:3)},
ga1(){return this.c0(this.a===2?1:3)/3},
gaq(){return this.a===2?this.c0(0):A.a2(this)},
ap(a,b,c,d){var s,r=this
r.co(0,a)
s=r.a
if(s===2)r.co(1,d)
else if(s>2){r.co(1,b)
r.co(2,c)
r.co(3,d)}},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1,
gu(a){return this.a}}
A.df.prototype={
X(){return new A.df(new Uint32Array(A.p(this.a)))},
gL(){return B.R},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:0
return s},
ga1(){return this.gv()/4294967295},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.dg.prototype={
X(){return new A.dg(this.a,new Uint8Array(A.p(this.b)))},
gL(){return B.B},
gR(){return null},
c2(a){var s,r
if(a<0||a>=this.a)s=0
else{s=this.b
r=s.length
if(a<2){if(0>=r)return A.a(s,0)
s=B.a.a0(s[0],4-(a<<2>>>0))&15}else{if(1>=r)return A.a(s,1)
s=B.a.a0(s[1],4-((a&1)<<2))&15}}return s},
cu(a,b){var s,r,q,p
if(a>=this.a)return
s=B.a.F(B.b.h(b),0,15)
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
l(a,b){return this.c2(b)},
i(a,b,c){return this.cu(b,c)},
gW(){return this.c2(0)},
gt(){return this.c2(0)},
gA(){return this.c2(this.a===2?0:1)},
gB(){return this.c2(this.a===2?0:2)},
gv(){return this.c2(this.a===2?1:3)},
ga1(){return this.c2(this.a===2?1:3)/15},
gaq(){return this.a===2?this.c2(0):A.a2(this)},
ap(a,b,c,d){var s,r=this
r.cu(0,a)
s=r.a
if(s===2)r.cu(1,d)
else if(s>2){r.cu(1,b)
r.cu(2,c)
r.cu(3,d)}},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1,
gu(a){return this.a}}
A.bd.prototype={
ik(a,b,c,d){var s,r=this.a
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
X(){return new A.bd(new Uint8Array(A.p(this.a)))},
gL(){return B.e},
gu(a){return this.a.length},
gR(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
i(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gW(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gt(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gA(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>1?s[1]:0
return s},
gB(){var s=this.a,r=s.length
if(r===2){if(0>=r)return A.a(s,0)
s=s[0]}else s=r>2?s[2]:0
return s},
gv(){var s=this.a,r=s.length
if(r===2){if(1>=r)return A.a(s,1)
s=s[1]}else s=r>3?s[3]:255
return s},
ga1(){return this.gv()/255},
gaq(){var s=this.a,r=s.length
if(r===2)if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
else s=A.a2(this)
return s},
gI(a){return new A.W(this)},
Z(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===this.a.length){s=b.gM(b)
r=A.t(this,A.m(this).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.h5.prototype={}
A.cn.prototype={}
A.ea.prototype={
X(){return new A.ea(this.a)},
gL(){return B.e},
gu(a){return 4},
gR(){return null},
l(a,b){var s
if(b>=0&&b<4){s=b<<3>>>0
s=B.a.a6((this.a&B.a.S(255,s))>>>0,s)}else s=0
return s},
i(a,b,c){},
gW(){return this.l(0,0)},
gt(){return this.l(0,0)},
gA(){return this.l(0,1)},
gB(){return this.l(0,2)},
gv(){return this.l(0,3)},
ga1(){return this.gv()/255},
gaq(){return A.a2(this)},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q=this
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gu(b)===q.gu(q)){s=b.gM(b)
r=A.t(q,A.m(q).m("e.E"))
s=s===A.o(r)}return s},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
$ix:1}
A.h8.prototype={
gv(){return 255},
ga1(){return 1},
gu(a){return 3}}
A.au.prototype={
a7(){return"Format."+this.b}}
A.ek.prototype={
a7(){return"FormatType."+this.b}}
A.h0.prototype={
a7(){return"BlendMode."+this.b}}
A.bE.prototype={
d5(a){var s=$.mz()
if(!s.ac(a))return"<unknown>"
return s.l(0,a).a},
D(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=new A.Y(s,s.r,s.e,A.m(s).m("Y<1>")),q=t.p,p=t.r,o=t.N,n=t.P,m="";r.E();){l=r.d
m+=l+"\n"
k=s.l(0,l)
for(l=k.a,l=new A.Y(l,l.r,l.e,A.m(l).m("Y<1>"));l.E();){j=l.d
i=k.l(0,j)
m=i==null?m+("\t"+e.d5(j)+"\n"):m+("\t"+e.d5(j)+": "+i.D(0)+"\n")}for(l=k.b.a,j=new A.Y(l,l.r,l.e,A.m(l).m("Y<1>"));j.E();){h=j.d
m+=h+"\n"
if(!l.ac(h))l.i(0,h,new A.aP(A.J(q,p),new A.b_(A.J(o,n))))
g=l.l(0,h)
for(h=g.a,h=new A.Y(h,h.r,h.e,A.m(h).m("Y<1>"));h.E();){f=h.d
i=g.l(0,f)
m=i==null?m+("\t"+e.d5(f)+"\n"):m+("\t"+e.d5(f)+": "+i.D(0)+"\n")}}}return m.charCodeAt(0)==0?m:m},
aX(a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="exif",a7="interop",a8=a9.b
a9.b=!0
a9.a3(19789)
a9.a3(42)
a9.K(8)
s=a5.a
if(s.l(0,"ifd0")==null)s.i(0,"ifd0",new A.aP(A.J(t.p,t.r),new A.b_(A.J(t.N,t.P))))
r=s.l(0,"ifd1")
q=a5.b
p=q!=null&&q.length!==0&&r!=null
if(p){r.i(0,513,A.jB(0))
r.i(0,514,A.jB(q.length))}else if(r!=null){o=r.a
o.cC(0,513)
o.cC(0,514)}n=A.j(["ifd0"],t.s)
for(o=new A.Y(s,s.r,s.e,A.m(s).m("Y<1>"));o.E();){m=o.d
if(m!=="ifd0")B.c.C(n,m)}o=t.N
m=t.p
l=A.J(o,m)
for(k=n.length,j=t.r,i=t.P,h=8,g=0;g<n.length;n.length===k||(0,A.L)(n),++g){f=n[g]
e=s.l(0,f)
e.toString
l.i(0,f,h)
d=e.b.a
if(d.ac(a6)){c=new Uint32Array(1)
c[0]=0
e.i(0,34665,new A.b0(c))}else e.a.cC(0,34665)
if(d.ac(a7)){c=new Uint32Array(1)
c[0]=0
e.i(0,40965,new A.b0(c))}else e.a.cC(0,40965)
if(d.ac("gps")){c=new Uint32Array(1)
c[0]=0
e.i(0,34853,new A.b0(c))}else e.a.cC(0,34853)
e=e.a
h+=2+12*e.a+4
for(e=new A.aq(e,e.r,e.e,A.m(e).m("aq<2>"));e.E();){c=e.d
b=c.gaI().a
if(!(b<14))return A.a(B.r,b)
a=B.r[b]*c.gu(c)
if(a>4)h+=a}for(e=new A.Y(d,d.r,d.e,A.m(d).m("Y<1>"));e.E();){c=e.d
if(!d.ac(c))d.i(0,c,new A.aP(A.J(m,j),new A.b_(A.J(o,i))))
b=d.l(0,c)
b.toString
l.i(0,c,h)
b=b.a
a0=2+12*b.a
for(c=new A.aq(b,b.r,b.e,A.m(b).m("aq<2>"));c.E();){b=c.d
a1=b.gaI().a
if(!(a1<14))return A.a(B.r,a1)
a=B.r[a1]*b.gu(b)
if(a>4)a0+=a}h+=a0}}if(p)r.l(0,513).bx(h)
a2=n.length
for(k=a2-1,a3=0;a3<a2;++a3){if(!(a3<n.length))return A.a(n,a3)
f=n[a3]
a4=s.l(0,f)
e=a4.b.a
if(e.ac(a6)){d=a4.l(0,34665)
d.toString
c=l.l(0,a6)
c.toString
d.bx(c)}if(e.ac(a7)){d=a4.l(0,40965)
d.toString
c=l.l(0,a7)
c.toString
d.bx(c)}if(e.ac("gps")){d=a4.l(0,34853)
d.toString
c=l.l(0,"gps")
c.toString
d.bx(c)}d=l.l(0,f)
d.toString
a5.h4(a9,a4,d+2+12*a4.a.a+4)
if(a3===k)a9.K(0)
else{d=a3+1
if(!(d<n.length))return A.a(n,d)
d=l.l(0,n[d])
d.toString
a9.K(d)}a5.h5(a9,a4)
for(d=new A.Y(e,e.r,e.e,A.m(e).m("Y<1>"));d.E();){c=d.d
if(!e.ac(c))e.i(0,c,new A.aP(A.J(m,j),new A.b_(A.J(o,i))))
b=e.l(0,c)
b.toString
c=l.l(0,c)
c.toString
a5.h4(a9,b,c+2+12*b.a.a)
a5.h5(a9,b)}}if(p)a9.a2(q)
a9.b=a8},
h4(a,b,c){var s,r,q,p,o,n,m=b.a
a.a3(m.a)
for(m=new A.Y(m,m.r,m.e,A.m(m).m("Y<1>"));m.E();){s=m.d
r=b.l(0,s)
r.toString
q=s===273
p=q&&r.gaI()===B.J?B.p:r.gaI()
o=q&&r.gaI()===B.J?1:r.gu(r)
a.a3(s)
a.a3(p.a)
a.K(o)
s=r.gaI().a
if(!(s<14))return A.a(B.r,s)
n=B.r[s]*r.gu(r)
if(n<=4){r.aX(a)
while(n<4){a.p(0);++n}}else{a.K(c)
c+=n}}return c},
h5(a,b){var s,r,q
for(s=b.a,s=new A.aq(s,s.r,s.e,A.m(s).m("aq<2>"));s.E();){r=s.d
q=r.gaI().a
if(!(q<14))return A.a(B.r,q)
if(B.r[q]*r.gu(r)>4)r.aX(a)}},
bV(c6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3=this,c4="Length must be a non-negative integer: ",c5=c6.e
c6.e=!0
s=c6.d
a1=c6.n()
if(a1===18761){c6.e=!1
if(c6.n()!==42){c6.e=c5
return!1}}else if(a1===19789){c6.e=!0
if(c6.n()!==42){c6.e=c5
return!1}}else return!1
r=c6.k()
c3.c=0
q=0
a2=t.p
a3=A.mP(a2)
a4=c3.a
a5=t.n0
a6=c6.c
a7=t.r
a8=t.N
a9=t.P
for(;;){b0=r
if(typeof b0!=="number")return b0.i6()
if(b0>0){b0=q
if(typeof b0!=="number")return b0.ex()
b0=b0<64&&a3.C(0,r)}else b0=!1
if(!b0)break
try{b0=s
b1=r
if(typeof b0!=="number")return b0.ah()
if(typeof b1!=="number")return A.iU(b1)
b1=b0+b1
c6.d=b1
if(a6-b1<2)break
p=new A.aP(A.J(a2,a7),new A.b_(A.J(a8,a9)))
o=c6.n()
b0=o
if(typeof b0!=="number")return b0.ey()
if(b0*12>a6-c6.d)break
n=o
b0=n
if(b0<0)A.a3(A.aX(c4+A.y(b0),null))
m=A.j(new Array(b0),a5)
l=0
for(;;){b0=l
b1=n
if(typeof b0!=="number")return b0.ex()
if(typeof b1!=="number")return A.iU(b1)
if(!(b0<b1))break
J.a_(m,l,c3.fI(c6,s))
b0=l
if(typeof b0!=="number")return b0.ah()
l=b0+1}k=m
for(b0=k,b1=b0.length,b2=0;b2<b0.length;b0.length===b1||(0,A.L)(b0),++b2){j=b0[b2]
if(j.b!=null){b3=j.a
b4=j.b
b4.toString
J.a_(p,b3,b4)}}a4.i(0,"ifd"+A.y(q),p)
b0=q
if(typeof b0!=="number")return b0.ah()
q=b0+1
r=c6.k()}catch(b5){break}}for(b0=new A.aq(a4,a4.r,a4.e,A.m(a4).m("aq<2>"));b0.E();){i=b0.d
for(b1=B.cl.gc7(),b1=b1.gI(b1);b1.E();){h=b1.gO()
b3=A.n(h)
if(i.a.ac(b3))try{g=J.d(i,h).h(0)
b3=s
b4=g
if(typeof b3!=="number")return b3.ah()
if(typeof b4!=="number")return A.iU(b4)
c6.d=b3+b4
f=new A.aP(A.J(a2,a7),new A.b_(A.J(a8,a9)))
e=c6.n()
d=e
b4=d
if(b4<0)A.a3(A.aX(c4+A.y(b4),null))
c=A.j(new Array(b4),a5)
b=0
for(;;){b3=b
b4=d
if(typeof b3!=="number")return b3.ex()
if(typeof b4!=="number")return A.iU(b4)
if(!(b3<b4))break
J.a_(c,b,c3.fI(c6,s))
b3=b
if(typeof b3!=="number")return b3.ah()
b=b3+1}a=c
for(b3=a,b4=b3.length,b2=0;b2<b3.length;b3.length===b4||(0,A.L)(b3),++b2){a0=b3[b2]
if(a0.b!=null){b6=a0.a
b7=a0.b
b7.toString
J.a_(f,b6,b7)}}b3=i.b
b4=B.cl.l(0,h)
b4.toString
b3.a.i(0,b4,a9.a(f))}catch(b5){continue}}}c3.b=null
b8=a4.l(0,"ifd1")
if(b8!=null){a2=b8.a
a2=a2.ac(513)&&a2.ac(514)}else a2=!1
if(a2){b9=b8.l(0,513).h(0)
c0=b8.l(0,514).h(0)
a2=s
if(typeof a2!=="number")return a2.ah()
c1=a2+b9
if(c0>0){a2=s
if(typeof a2!=="number")return A.iU(a2)
a2=c1>=a2&&c1+c0<=a6}else a2=!1
if(a2){c2=c6.d
c6.d=c1
c3.b=c6.af(c0).Y()
c6.d=c2}}c6.e=c5
return!1},
fI(a,b){var s,r,q,p,o,n,m,l=a.n(),k=a.n(),j=a.k(),i=new A.iB(l,null)
if(k>=14)return i
s=B.bV[k]
r=j*B.r[k]
if(this.c+r>16777216)return i
q=a.d
if((r>4?a.d=a.k()+b:q)+r>a.c)return i
p=a.af(r)
this.c+=r
switch(s.a){case 0:break
case 6:i.b=new A.bu(new Int8Array(A.p(J.mA(B.d.gq(p.Y()),0,j))))
break
case 1:i.b=new A.bg(new Uint8Array(A.p(p.af(j).Y())))
break
case 7:i.b=new A.c5(new Uint8Array(A.p(p.af(j).Y())))
break
case 2:i.b=new A.cv(j===0?"":p.au(j-1))
break
case 3:i.b=A.og(p,j)
break
case 4:i.b=A.ob(p,j)
break
case 5:i.b=A.oc(p,j)
break
case 10:i.b=A.oe(p,j)
break
case 8:i.b=A.of(p,j)
break
case 9:i.b=A.od(p,j)
break
case 11:i.b=A.oh(p,j)
break
case 12:i.b=A.oa(p,j)
break
case 13:if(j===1){o=new A.cw(0)
n=p.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=n
n=$.ab()
if(0>=n.length)return A.a(n,0)
o.a=n[0]
i.b=o}break}a.d=q+4
return i}}
A.iB.prototype={}
A.hc.prototype={}
A.b_.prototype={
ir(a){a.a.bH(0,new A.jy(this))},
gd0(a){var s,r=this.a
if(r.a===0)return!0
for(r=new A.aq(r,r.r,r.e,A.m(r).m("aq<2>"));r.E();){s=r.d
if(!(s.a.a===0&&s.b.gd0(0)))return!1}return!0},
l(a,b){var s=this.a
if(!s.ac(b))s.i(0,b,new A.aP(A.J(t.p,t.r),new A.b_(A.J(t.N,t.P))))
s=s.l(0,b)
s.toString
return s}}
A.jy.prototype={
$2(a,b){var s
A.bA(a)
s=A.o9(t.P.a(b))
this.a.a.i(0,a,s)
return s},
$S:15}
A.aP.prototype={
ht(a){a.a.bH(0,new A.jz(this))
a.b.a.bH(0,new A.jA(this))},
l(a,b){var s=this.a.l(0,b)
return s},
i(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(typeof b=="string")b=B.l8.l(0,b)
if(!A.iQ(b))return
if(c instanceof A.a7)k.a.i(0,b,c)
else{s=$.mz().l(0,b)
if(s!=null)switch(s.b.a){case 1:if(t.L.b(c))k.a.i(0,b,new A.bg(new Uint8Array(A.p(new Uint8Array(A.p(c))))))
else if(typeof c=="number"){r=B.a.h(c)
q=new Uint8Array(1)
q[0]=r
k.a.i(0,b,new A.bg(q))}break
case 2:break
case 3:if(t.L.b(c))k.a.i(0,b,new A.bK(new Uint16Array(A.p(new Uint16Array(A.p(c))))))
else if(typeof c=="number")k.a.i(0,b,A.qT(B.a.h(c)))
break
case 4:if(t.L.b(c))k.a.i(0,b,new A.b0(new Uint32Array(A.p(new Uint32Array(A.p(c))))))
else if(typeof c=="number")k.a.i(0,b,A.jB(B.a.h(c)))
break
case 5:if(t.ee.b(c))k.a.i(0,b,new A.bt(A.dB(c,!0,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.i(0,b,new A.bt(A.j([new A.b4(q,c[1])],t.lf)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.bL(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.b4(l,q[1])}k.a.i(0,b,new A.bt(A.dB(o,!0,r)))}break
case 6:if(t.L.b(c))k.a.i(0,b,new A.bu(new Int8Array(A.p(new Int8Array(A.p(c))))))
else if(typeof c=="number"){r=B.a.h(c)
q=new Int8Array(1)
q[0]=r
k.a.i(0,b,new A.bu(q))}break
case 7:if(t.L.b(c))k.a.i(0,b,new A.c5(new Uint8Array(A.p(new Uint8Array(A.p(c))))))
break
case 8:if(t.L.b(c))k.a.i(0,b,new A.bJ(new Int16Array(A.p(new Int16Array(A.p(c))))))
else if(typeof c=="number"){r=B.a.h(c)
q=new Int16Array(1)
q[0]=r
k.a.i(0,b,new A.bJ(q))}break
case 9:if(t.L.b(c))k.a.i(0,b,new A.bI(new Int32Array(A.p(new Int32Array(A.p(c))))))
else if(typeof c=="number"){r=B.a.h(c)
q=new Int32Array(1)
q[0]=r
k.a.i(0,b,new A.bI(q))}break
case 10:if(t.ee.b(c))k.a.i(0,b,new A.bv(A.dB(c,!0,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.i(0,b,new A.bv(A.j([new A.b4(q,c[1])],t.lf)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.bL(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.b4(l,q[1])}k.a.i(0,b,new A.bv(A.dB(o,!0,r)))}break
case 11:if(t.bd.b(c))k.a.i(0,b,new A.c4(new Float32Array(A.p(new Float32Array(A.p(c))))))
else if(typeof c=="number"){r=new Float32Array(1)
r[0]=c
k.a.i(0,b,new A.c4(r))}break
case 12:if(t.bd.b(c))k.a.i(0,b,new A.c3(new Float64Array(A.p(new Float64Array(A.p(c))))))
else if(typeof c=="number"){r=new Float64Array(1)
r[0]=c
k.a.i(0,b,new A.c3(r))}break
case 13:if(typeof c=="number")k.a.i(0,b,new A.cw(B.a.h(c)))
break
case 0:break}}},
gbU(){var s=this.a.l(0,274)
return s==null?null:s.h(0)},
sbU(a){this.a.cC(0,274)}}
A.jz.prototype={
$2(a,b){var s
A.n(a)
s=t.r.a(b).X()
this.a.a.i(0,a,s)
return s},
$S:35}
A.jA.prototype={
$2(a,b){var s
A.bA(a)
s=A.o9(t.P.a(b))
this.a.b.a.i(0,a,s)
return s},
$S:15}
A.am.prototype={
a7(){return"IfdValueType."+this.b}}
A.a7.prototype={
ag(a,b){A.n(b)
return 0},
h(a){return this.ag(0,0)},
bu(){return new Uint8Array(0)},
D(a){return""},
Z(a,b){var s=this
if(b==null)return!1
return b instanceof A.a7&&s.gaI()===b.gaI()&&s.gu(s)===b.gu(b)&&s.gM(s)===b.gM(b)},
gM(a){return 0},
bx(a){}}
A.bg.prototype={
X(){return new A.bg(new Uint8Array(A.p(this.a)))},
gaI(){return B.bj},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bg){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
h(a){return this.ag(0,0)},
bx(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bu(){return this.a},
aX(a){a.a2(this.a)},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.y(s)
return s}}
A.cv.prototype={
X(){return new A.cv(this.a)},
gaI(){return B.l},
gu(a){return this.a.length+1},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.cv){s=this.a
r=b.a
s=s.length+1===r.length+1&&B.m.gM(s)===B.m.gM(r)}else s=!1
return s},
gM(a){return B.m.gM(this.a)},
bu(){return new Uint8Array(A.p(new A.ah(this.a)))},
aX(a){a.a2(new A.ah(this.a))
a.p(0)},
D(a){return this.a}}
A.bK.prototype={
iw(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.n()
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bK(new Uint16Array(A.p(this.a)))},
gaI(){return B.k},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bK){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
h(a){return this.ag(0,0)},
bx(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bu(){return J.G(B.D.gq(this.a))},
aX(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.a3(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.y(s)
return s}}
A.b0.prototype={
it(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.b0(new Uint32Array(A.p(this.a)))},
gaI(){return B.p},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.b0){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
h(a){return this.ag(0,0)},
bx(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bu(){return J.G(B.o.gq(this.a))},
aX(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.K(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.y(s)
return s}}
A.bt.prototype={
X(){return new A.bt(A.dB(this.a,!0,t.i))},
gaI(){return B.v},
gu(a){return this.a.length},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].h(0)},
h(a){return this.ag(0,0)},
Z(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bt){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.o(s)===A.o(q)}else s=!1
return s},
gM(a){return A.o(this.a)},
aX(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.L)(s),++q){p=s[q]
a.K(p.a)
a.K(p.b)}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].D(0)}else s=A.y(s)
return s}}
A.bu.prototype={
X(){return new A.bu(new Int8Array(A.p(this.a)))},
gaI(){return B.bo},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bu){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
h(a){return this.ag(0,0)},
bx(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bu(){return J.G(B.aB.gq(this.a))},
aX(a){a.a2(J.C(B.aB.gq(this.a),0,null))},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.y(s)
return s}}
A.bJ.prototype={
iv(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.n()
o=$.ay()
o.$flags&2&&A.b(o)
o[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bJ(new Int16Array(A.p(this.a)))},
gaI(){return B.bp},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bJ){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
h(a){return this.ag(0,0)},
bx(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bu(){return J.G(B.a9.gq(this.a))},
aX(a){var s,r,q,p=new Int16Array(1),o=J.nQ(B.a9.gq(p),0,null),n=this.a,m=n.length
for(s=o.length,r=0;r<m;++r){q=n[r]
if(0>=1)return A.a(p,0)
p[0]=q
if(0>=s)return A.a(o,0)
a.a3(o[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.y(s)
return s}}
A.bI.prototype={
iu(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.U()
o.$flags&2&&A.b(o)
o[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.bI(new Int32Array(A.p(this.a)))},
gaI(){return B.bq},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bI){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
h(a){return this.ag(0,0)},
bx(a){var s=this.a
s.$flags&2&&A.b(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
bu(){return J.G(B.u.gq(this.a))},
aX(a){var s,r,q,p=this.a,o=p.length
for(s=0;s<o;++s){r=p[s]
q=$.j_()
q.$flags&2&&A.b(q)
q[0]=r
r=$.my()
if(0>=r.length)return A.a(r,0)
a.K(r[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.y(s)
return s}}
A.bv.prototype={
X(){return new A.bv(A.dB(this.a,!0,t.i))},
gaI(){return B.bk},
gu(a){return this.a.length},
Z(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bv){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.o(s)===A.o(q)}else s=!1
return s},
gM(a){return A.o(this.a)},
ag(a,b){var s
A.n(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].h(0)},
h(a){return this.ag(0,0)},
aX(a){var s,r,q,p,o,n
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.L)(s),++q){p=s[q]
o=$.j_()
o.$flags&2&&A.b(o)
o[0]=p.a
n=$.my()
if(0>=n.length)return A.a(n,0)
a.K(n[0])
o[0]=p.b
a.K(n[0])}},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].D(0)}else s=A.y(s)
return s}}
A.c4.prototype={
ix(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.U()
o.$flags&2&&A.b(o)
o[0]=p
p=$.cl()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
X(){return new A.c4(new Float32Array(A.p(this.a)))},
gaI(){return B.bl},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c4){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
bu(){return J.G(B.a8.gq(this.a))},
aX(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.mR(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.y(s[0])}else s=A.y(s)
return s}}
A.c3.prototype={
is(a,b){var s,r
for(s=this.a,r=0;r<b;++r)B.q.i(s,r,a.dD())},
X(){return new A.c3(new Float64Array(A.p(this.a)))},
gaI(){return B.bm},
gu(a){return this.a.length},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c3){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
bu(){return J.G(B.q.gq(this.a))},
aX(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.mS(r[s])},
D(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.y(s[0])}else s=A.y(s)
return s}}
A.c5.prototype={
X(){return new A.c5(new Uint8Array(A.p(this.a)))},
gaI(){return B.J},
gu(a){return this.a.length},
bu(){return this.a},
Z(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c5){s=this.a
r=b.a
s=s.length===r.length&&A.o(s)===A.o(r)}else s=!1
return s},
gM(a){return A.o(this.a)},
aX(a){a.a2(this.a)},
D(a){return"<data>"}}
A.cw.prototype={
X(){return A.jB(this.a)},
gaI(){return B.bn},
gu(a){return 1},
Z(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.cw)s=this.a===b.a
return s},
gM(a){return this.a},
ag(a,b){if(A.n(b)!==0)throw A.f(A.rO("Ifd tags must have exactly one entry (the offset)"))
return this.a},
h(a){return this.ag(0,0)},
bx(a){this.a=a},
bu(){var s=this.a
return new Uint8Array(A.p(A.j([B.a.j(s,24),B.a.j(s,16),B.a.j(s,8),s],t.t)))},
aX(a){a.K(this.a)},
D(a){return"Ifd@"+this.a}}
A.aJ.prototype={
a7(){return"DitherKernel."+this.b}}
A.dj.prototype={
a7(){return"DitherScanOrder."+this.b}}
A.mh.prototype={
$3(b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=a5.a,a7=a5.b,a8=b3*a7+b2,a9=a5.c,b0=a8*a9,b1=a6.length
if(!(b0>=0&&b0<b1))return A.a(a6,b0)
s=a6[b0]
r=b0+1
if(!(r<b1))return A.a(a6,r)
q=a6[r]
r=b0+2
if(!(r<b1))return A.a(a6,r)
p=a6[r]
o=a5.d.dG(s,q,p)
r=a5.e
r.$flags&2&&A.b(r)
if(!(a8>=0&&a8<r.length))return A.a(r,a8)
r[a8]=o
a8=a5.f
r=o*3
n=a8.length
if(!(r>=0&&r<n))return A.a(a8,r)
m=s-a8[r]
l=r+1
if(!(l<n))return A.a(a8,l)
k=q-a8[l]
r+=2
if(!(r<n))return A.a(a8,r)
j=p-a8[r]
if(m===0&&k===0&&j===0)return
a8=b4===1
i=a8?0:a5.r-1
h=a8?a5.r:-1
for(a8=a5.w,r=a8.length,n=a5.x,l=n.length,g=a5.y,f=a6.$flags|0,e=a5.z,d=e.length,c=i;c!==h;c+=b4){if(!(c>=0&&c<r))return A.a(a8,c)
b=b2+a8[c]
if(!(c<l))return A.a(n,c)
a=b3+n[c]
if(b>=0&&b<a7&&a>=0&&a<g){if(!(c<d))return A.a(e,c)
a0=e[c]
a1=(a*a7+b)*a9
if(!(a1>=0&&a1<b1))return A.a(a6,a1)
a2=a6[a1]+m*a0
if(a2<0)a3=0
else a3=a2>255?255:B.b.h(a2)
f&2&&A.b(a6)
a6[a1]=a3
a3=a1+1
if(!(a3<b1))return A.a(a6,a3)
a2=a6[a3]+k*a0
if(a2<0)a4=0
else a4=a2>255?255:B.b.h(a2)
a6[a3]=a4
a4=a1+2
if(!(a4<b1))return A.a(a6,a4)
a2=a6[a4]+j*a0
if(a2<0)a3=0
else a3=a2>255?255:B.b.h(a2)
a6[a4]=a3}}},
$S:16}
A.mi.prototype={
$3(a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.a,a0=a.aU(a5,a6),a1=B.b.h(a0.l(0,0)),a2=B.b.h(a0.l(0,1)),a3=B.b.h(a0.l(0,2)),a4=b.b.dG(a1,a2,a3)
b.c.i9(a5,a6,a4)
s=b.d
r=a1-s.aY(a4,0)
q=a2-s.aY(a4,1)
p=a3-s.aY(a4,2)
if(r===0&&q===0&&p===0)return
s=a7===1
o=s?0:b.e.length-1
n=s?b.e.length:0
for(s=b.e,m=s.length,l=b.f,k=b.r,j=o;j!==n;j+=a7){if(!(j>=0&&j<m))return A.a(s,j)
i=s[j]
h=B.b.h(i[1])
g=B.b.h(i[2])
f=h+a5
e=!1
if(f>=0)if(f<l){f=g+a6
f=f>=0&&f<k}else f=e
else f=e
if(f){d=i[0]
i=a.a
c=i==null?null:i.P(a5+h,a6+g,null)
if(c==null)c=new A.E()
c.st(c.gt()+r*d)
c.sA(c.gA()+q*d)
c.sB(c.gB()+p*d)}}},
$S:16}
A.bO.prototype={
ce(a,b,c){var s,r=this.c+b*c
this.c=r
s=this.a
if(s>0&&r>s)throw A.f(A.l("Animation frames exceed the maximum of "+s+" pixels"))}}
A.al.prototype={
a7(){return"BmpCompression."+this.b}}
A.j8.prototype={}
A.aZ.prototype={
eM(a,b){var s,r,q,p,o,n,m,l=this,k=l.d,j=k<=40
if(j){s=l.r
s=s===B.af||s===B.aH}else s=!0
if(s){s=l.as=a.k()
r=A.md(s)
l.CW=r
q=B.a.a0(s,r)
s=q>0
l.cx=s?255/q:0
r=l.at=a.k()
p=A.md(r)
l.cy=p
o=B.a.a0(r,p)
l.db=s?255/o:0
r=l.ax=a.k()
p=A.md(r)
l.dx=p
n=B.a.a0(r,p)
l.dy=s?255/n:0
if(!j||l.r===B.aH){j=l.ay=a.k()
s=A.md(j)
l.fr=s
m=B.a.a0(j,s)
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
if(l.f<=8)l.my(a)},
gcZ(){var s=this.d
if(s!==40)if(s===124){s=this.ay
s===$&&A.c("alphaMask")
s=s===0}else s=!1
else s=!0
return s},
gJ(){return Math.abs(this.c)},
my(a){var s,r,q,p,o,n=this,m=n.z
if(m===0)m=B.a.S(1,n.f)
n.ch=new A.aT(new Uint8Array(m*3),m,3)
for(s=0;s<m;++s){r=J.d(a.a,a.d++)
q=J.d(a.a,a.d++)
p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n.ch.d6(s,p,q,r,o)}},
m2(a2,a3){var s,r,q,p,o,n,m,l,k,j=this,i="_redShift",h="_redScale",g="greenMask",f="_greenShift",e="_greenScale",d="blueMask",c="_blueShift",b="_blueScale",a="alphaMask",a0="_alphaShift",a1="_alphaScale"
t.jO.a(a3)
if(j.ch!=null){s=j.f
if(s===1){r=a2.H()
for(q=7;q>=0;--q)a3.$4(B.a.aJ(r,q)&1,0,0,0)
return}else if(s===2){r=a2.H()
for(q=6;q>=0;q-=2)a3.$4(B.a.aJ(r,q)&2,0,0,0)}else if(s===4){r=a2.H()
a3.$4(B.a.j(r,4)&15,0,0,0)
a3.$4(r&15,0,0,0)
return}else if(s===8){a3.$4(a2.H(),0,0,0)
return}}s=j.r
if(s===B.af&&j.f===32){p=a2.k()
s=j.as
s===$&&A.c("redMask")
o=j.CW
o===$&&A.c(i)
o=B.a.a0((p&s)>>>0,o)
s=j.cx
s===$&&A.c(h)
n=B.b.h(o*s)
s=j.at
s===$&&A.c(g)
o=j.cy
o===$&&A.c(f)
o=B.a.a0((p&s)>>>0,o)
s=j.db
s===$&&A.c(e)
m=B.b.h(o*s)
s=j.ax
s===$&&A.c(d)
o=j.dx
o===$&&A.c(c)
o=B.a.a0((p&s)>>>0,o)
s=j.dy
s===$&&A.c(b)
l=B.b.h(o*s)
if(j.gcZ())k=255
else{s=j.ay
s===$&&A.c(a)
o=j.fr
o===$&&A.c(a0)
o=B.a.a0((p&s)>>>0,o)
s=j.fx
s===$&&A.c(a1)
k=B.b.h(o*s)}return a3.$4(n,m,l,k)}else{o=j.f
if(o===32&&s===B.aG){l=a2.H()
m=a2.H()
n=a2.H()
k=a2.H()
return a3.$4(n,m,l,j.gcZ()?255:k)}else if(o===24){l=a2.H()
m=a2.H()
return a3.$4(a2.H(),m,l,255)}else if(o===16){p=a2.n()
s=j.as
s===$&&A.c("redMask")
o=j.CW
o===$&&A.c(i)
o=B.a.a0((p&s)>>>0,o)
s=j.cx
s===$&&A.c(h)
n=B.b.h(o*s)
s=j.at
s===$&&A.c(g)
o=j.cy
o===$&&A.c(f)
o=B.a.a0((p&s)>>>0,o)
s=j.db
s===$&&A.c(e)
m=B.b.h(o*s)
s=j.ax
s===$&&A.c(d)
o=j.dx
o===$&&A.c(c)
o=B.a.a0((p&s)>>>0,o)
s=j.dy
s===$&&A.c(b)
l=B.b.h(o*s)
if(j.gcZ())k=255
else{s=j.ay
s===$&&A.c(a)
o=j.fr
o===$&&A.c(a0)
o=B.a.a0((p&s)>>>0,o)
s=j.fx
s===$&&A.c(a1)
k=B.b.h(o*s)}return a3.$4(n,m,l,k)}else throw A.f(A.l("Unsupported bitsPerPixel ("+o+") or compression ("+s.D(0)+")."))}},
$iM:1}
A.h1.prototype={
aT(a){var s,r
if(!A.nU(A.v(a,!1,null,0))||a.length<18)return!1
s=A.v(a,!1,null,0)
s.d+=14
r=s.k()
return r>=12&&r<=124},
aK(a){return A.P(new A.j6(this,a),t.bL)},
iT(a){var s
if(!this.aT(a))return null
s=A.v(a,!1,null,0)
this.a=s
return this.b=A.qr(s,null)},
an(a){return A.P(new A.j4(this,a),t.mo)},
iS(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.b
if(a0==null)return new A.an(a,a,a,a,0,B.j,0,0)
s=b.a
s===$&&A.c("_input")
r=a0.a.b
r===$&&A.c("imageOffset")
s.d=r
r=a0.b
A.ax(r,a0.gJ(),b.d,!1)
q=a0.f
p=B.a.V(r*q+31,32)*4
s=a0.gJ()
o=b.a
if(p*s>o.c-o.d)throw A.f(A.l("Truncated BMP data"))
s=b.c
if(s)n=4
else if(q===1||q===4||q===8)n=1
else{o=q===32?4:3
n=o}if(s)m=B.e
else if(q===1)m=B.A
else{if(q===2)o=B.w
else if(q===4)o=B.B
else o=B.e
m=o}l=s?a:a0.ch
k=A.V(a,a,m,0,B.j,a0.gJ(),a,0,n,l,B.e,r,!1)
for(j=k.gJ()-1,s=a0.c,r=1/s<0,o=s<0,s=s===0;j>=0;--j){i={}
if(!(s?r:o))h=j
else{g=k.a
g=g==null?a:g.b
h=(g==null?0:g)-1-j}g=b.a
f=g.aH(p)
g.d=g.d+(f.c-f.d)
g=k.a
e=g==null
d=e?a:g.a
if(d==null)d=0
i.a=0
c=e?a:g.P(0,h,a)
if(c==null)c=new A.E()
while(i.a<d)a0.m2(f,new A.j3(i,b,d,a0,c))}return k},
bg(a,b){return A.P(new A.j5(this,a,b),t.H)},
iR(a,b){var s=this.aK(a)
if(s==null||s.b<1||s.gJ()<1)return null
return this.an(0)}}
A.j6.prototype={
$0(){return this.a.iT(this.b)},
$S:36}
A.j4.prototype={
$0(){return this.a.iS(this.b)},
$S:39}
A.j3.prototype={
$4(a,b,c,d){var s,r,q=this,p=q.a
if(p.a<q.c){s=q.b.c&&q.d.ch!=null
r=q.e
if(s){s=q.d
r.ap(s.ch.b2(a),s.ch.b1(a),s.ch.b0(a),s.ch.b7(a))}else r.ap(a,b,c,d)
r.E();++p.a}},
$S:21}
A.j5.prototype={
$0(){return this.a.iR(this.b,this.c)},
$S:1}
A.jd.prototype={}
A.j7.prototype={
bR(d0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9=null
A.ci(d0)
s=d0.gad()
r=d0.a
q=r==null?c9:r.gR()
p=d0.gL()
r=p===B.A
if(r&&s===1&&q==null){q=new A.aT(new Uint8Array(6),2,3)
q.ba(0,0,0,0)
q.ba(1,255,255,255)}else if(r&&s===2){d0=d0.lU(B.w,1,!0)
r=d0.a
q=r==null?c9:r.gR()}else if(r&&s===3&&q==null){d0=d0.cw(B.B,!0)
r=d0.a
q=r==null?c9:r.gR()}else if(r&&s===4)d0=d0.cV(B.e,4)
else{r=p===B.w
if(r&&s===1&&q==null){d0=d0.cw(B.w,!0)
r=d0.a
q=r==null?c9:r.gR()}else if(r&&s===2){d0=d0.cw(B.e,!0)
r=d0.a
q=r==null?c9:r.gR()}else if(r&&s===3&&q==null){d0=d0.cw(B.e,!0)
r=d0.a
q=r==null?c9:r.gR()}else if(r&&s===4){d0=d0.cw(B.e,!0)
r=d0.a
q=r==null?c9:r.gR()}else{r=p===B.B
if(r&&s===1&&q==null){d0=d0.cw(B.e,!0)
r=d0.a
q=r==null?c9:r.gR()}else if(r&&s===2)d0=d0.cV(B.e,3)
else if(r&&s===3&&q==null)d0=d0.cV(B.e,3)
else if(r&&s===4)d0=d0.cV(B.e,4)
else{r=p===B.e
if(!(r&&s===1&&q==null))if(r&&s===2)d0=d0.cV(B.e,4)
else if(d0.gb4())d0=d0.aS(B.e)
else if(d0.gaw()&&d0.gad()===4)d0=d0.dz(4)}}}r=d0.gaN()
o=d0.a
n=r*o.c
if(n===12)n=16
r=n>8
m=r?B.af:B.aG
o=o.gaz()
l=o
if(l==null)l=0
k=B.a.V(d0.gN()*n+31,32)*4
j=k-l
i=j>0?A.I(j,255,!1,t.p):c9
h=n>=1&&n<=8?B.a.U(1,n):0
g=k*d0.gJ()
f=r?124:40
e=f+14
d=h*4
c=e+d
b=c-c
a=g+e+d+b
a0=A.a0(!1,a)
a0.a3(19778)
a0.K(a)
a0.K(0)
a0.K(c)
a0.K(f)
a0.K(d0.gN())
a0.K(d0.gJ())
a0.a3(1)
a0.a3(n)
a0.K(m.a)
a0.K(g)
a0.K(11811)
a0.K(11811)
o=n===8
a0.K(o?255:0)
a0.K(o?255:0)
if(r){r=n===16
a1=r?15:255
a2=r?240:65280
a3=r?3840:16711680
a4=r?61440:4278190080
a0.K(a3)
a0.K(a2)
a0.K(a1)
a0.K(a4)
a0.K(1934772034)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(0)
a0.K(2)
a0.K(0)
a0.K(0)
a0.K(0)}r=n===1
a5=!r
if(!a5||n===2||n===4||o)if(q!=null){a6=q.a
if(a6>h)a6=h
for(a7=0;a7<a6;++a7){a0.p(B.b.h(q.b0(a7)))
a0.p(B.b.h(q.b1(a7)))
a0.p(B.b.h(q.b2(a7)))
a0.p(0)}for(;a7<h;++a7){a0.p(0)
a0.p(0)
a0.p(0)
a0.p(0)}}else if(r){a0.p(0)
a0.p(0)
a0.p(0)
a0.p(0)
a0.p(255)
a0.p(255)
a0.p(255)
a0.p(0)}else if(n===2)for(a7=0;a7<4;++a7){a8=a7*85
a0.p(a8)
a0.p(a8)
a0.p(a8)
a0.p(0)}else if(n===4)for(a7=0;a7<16;++a7){a8=a7*17
a0.p(a8)
a0.p(a8)
a0.p(a8)
a0.p(0)}else if(o)for(a7=0;a7<256;++a7){a0.p(a7)
a0.p(a7)
a0.p(a7)
a0.p(0)}for(a9=b;b0=a9-1,a9>0;a9=b0)a0.p(0)
if(!a5||n===2||n===4||o){b1=d0.gcA(0)-l
b2=d0.gJ()
for(o=i!=null,a5=n===4,b3=n===2,b4=0;b4<b2;++b4){b5=d0.a
b5=b5==null?c9:b5.gq(b5)
if(b5==null)b5=B.d.gq(new Uint8Array(0))
b6=J.C(b5,b1,l)
if(r)a0.a2(b6)
else if(b3){a6=b6.length
for(b7=0;b7<a6;++b7){b8=b6[b7]
a0.p((b8&15)<<4|b8>>>4)}}else if(a5){a6=b6.length
for(b7=0;b7<a6;++b7){b8=b6[b7]
a0.p(b8>>>4<<4|b8&15)}}else a0.a2(b6)
if(o)a0.a2(i)
b1-=l}return J.C(B.d.gq(a0.c),0,a0.a)}b9=d0.gad()===4
b2=d0.gJ()
c0=d0.gN()
if(n===16)for(b4=b2-1,r=i!=null,c1=c9;b4>=0;--b4){o=d0.a
c1=o==null?c9:o.P(0,b4,c1)
if(c1==null)c1=new A.E()
for(c2=0;c2<c0;++c2){a0.p((B.b.h(c1.gA())<<4|B.b.h(c1.gB()))>>>0)
a0.p((B.b.h(c1.gv())<<4|B.b.h(c1.gt()))>>>0)
c1.E()}if(r)a0.a2(i)}else{r=c0*(b9?4:3)
c3=new Uint8Array(r)
if(d0.gL()===B.e&&!d0.gaw()){c4=d0.Y()
c5=d0.a.gaz()
s=d0.gad()
for(b4=b2-1,o=i!=null,a5=c4.length;b4>=0;--b4){for(c6=b4*c5,c7=0;c7<r;c6+=s){c8=c7+1
b3=c6+2
if(!(b3>=0&&b3<a5))return A.a(c4,b3)
b3=c4[b3]
if(!(c7<r))return A.a(c3,c7)
c3[c7]=b3
c7=c8+1
b3=c6+1
if(!(b3>=0&&b3<a5))return A.a(c4,b3)
b3=c4[b3]
if(!(c8<r))return A.a(c3,c8)
c3[c8]=b3
c8=c7+1
if(!(c6>=0&&c6<a5))return A.a(c4,c6)
b3=c4[c6]
if(!(c7<r))return A.a(c3,c7)
c3[c7]=b3
if(b9){c7=c8+1
b3=c6+3
if(!(b3<a5))return A.a(c4,b3)
b3=c4[b3]
if(!(c8<r))return A.a(c3,c8)
c3[c8]=b3}else c7=c8}a0.a2(c3)
if(o)a0.a2(i)}}else for(b4=b2-1,o=i!=null,c1=c9;b4>=0;--b4){a5=d0.a
c1=a5==null?c9:a5.P(0,b4,c1)
if(c1==null)c1=new A.E()
for(c2=0,c7=0;c2<c0;++c2){c8=c7+1
a5=A.n(c1.gB())
if(!(c7<r))return A.a(c3,c7)
c3[c7]=a5
c7=c8+1
a5=A.n(c1.gA())
if(!(c8<r))return A.a(c3,c8)
c3[c8]=a5
c8=c7+1
a5=A.n(c1.gt())
if(!(c7<r))return A.a(c3,c7)
c3[c7]=a5
if(b9){c7=c8+1
a5=A.n(c1.gv())
if(!(c8<r))return A.a(c3,c8)
c3[c8]=a5}else c7=c8
c1.E()}a0.a2(c3)
if(o)a0.a2(i)}}return J.C(B.d.gq(a0.c),0,a0.a)}}
A.M.prototype={}
A.jb.prototype={}
A.je.prototype={}
A.he.prototype={}
A.eA.prototype={
d1(){return this.w},
bv(a,b,c,d,e){throw A.f(A.l("B44 compression not yet supported."))},
cD(a,b,c){return this.bv(a,b,c,null,null)},
D(a){return A.y(this.r)+" "+this.x}}
A.cs.prototype={
a7(){return"ExrChannelType."+this.b}}
A.cr.prototype={
a7(){return"ExrChannelName."+this.b}}
A.hf.prototype={
il(a){var s=this,r=a.d3()
s.a=r
if(r.length===0)return
r=a.k()
if(!(r<3))return A.a(B.bL,r)
s.c=B.bL[r]
a.H()
a.d+=3
s.f=a.k()
s.r=a.k()
r=s.a
if(r==="R"){s.w=!0
s.b=B.di}else if(r==="G"){s.w=!0
s.b=B.dj}else if(r==="B"){s.w=!0
s.b=B.dk}else if(r==="A"){s.w=!0
s.b=B.dl}else{s.w=!1
s.b=B.dm}switch(s.c.a){case 0:s.d=4
break
case 1:s.d=2
break
case 2:s.d=4
break}}}
A.bf.prototype={
a7(){return"ExrCompressorType."+this.b}}
A.bF.prototype={
bv(a,b,c,d,e){throw A.f(A.l("Unsupported compression type"))},
cD(a,b,c){return this.bv(a,b,c,null,null)}}
A.hy.prototype={}
A.hg.prototype={
smt(a){this.c=t.T.a(a)}}
A.hh.prototype={
im(a,b){var s,r,q,p,o,n=this,m=A.v(a,!1,null,0)
if(m.k()!==20000630)throw A.f(A.l("File is not an OpenEXR image file."))
s=n.d=m.H()
if(s!==2)throw A.f(A.l("Cannot read version "+s+" image files."))
s=n.e=m.bt()
if((s&4294967289)>>>0!==0)throw A.f(A.l("The file format version number's flag field contains unrecognized flags."))
r=new A.bO(b)
if((s&16)===0){q=n.c
p=A.ol(q.length,(s&2)!==0,m,b)
if(p.w>0)B.c.C(q,p)}else for(s=n.c;;){p=A.ol(s.length,(n.e&2)!==0,m,b)
q=p.w
if(q<=0)break
r.ce(0,q,p.x)
B.c.C(s,p)}s=n.c
q=s.length
if(q===0)throw A.f(A.l("Error reading image header"))
for(o=0;o<s.length;s.length===q||(0,A.L)(s),++o)s[o].mx(m)
n.l8(m)},
l8(a){var s,r,q,p,o=this
for(s=o.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.L)(s),++q){p=s[q]
o.a=Math.max(o.a,p.w)
o.b=Math.max(o.b,p.x)
if(p.db)o.lh(p,a)
else o.lg(p,a)}},
lh(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=this.e
b5===$&&A.c("flags")
s=(b5&16)!==0
b5=b6.b
b5.toString
r=b6.CW
q=b6.ay
p=A.w(b7,b4,0)
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
if(s)if(p.k()!==n)throw A.f(A.l("Invalid Image Data"))
e=p.k()
d=p.k()
p.k()
p.k()
c=p.aH(p.k())
p.d=p.d+(c.c-c.d)
g=b6.dy
g.toString
b=d*g
a=b6.dx
a.toString
g=r.bv(c,e*a,b,a,g)
a=g.length
a=Math.min(a,a)
a0=new A.ai(g,0,a,0,!1)
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
switch(g.a){case 1:g=a0.n()
b0=$.N
b0=b0!=null?b0:A.Q()
if(!(g<b0.length))return A.a(b0,g)
b1=b0[g]
break
case 2:b1=a0.n()
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
if(b2==null)b2=new A.E()
g=a7.b
g===$&&A.c("nameType")
b2.i(0,g.a,b1)}else{g=a7.a
g===$&&A.c("name")
b0=b5.b
b3=b0!=null?b0.l(0,g):b4
if(b3!=null)b3.aP(a8,b,b1,0,0)}}}++a5;++b}++f;++h}++i}++j;++l}++m}},
lg(a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=null,a7=this.e
a7===$&&A.c("flags")
s=(a7&16)!==0
a7=a8.b
a7.toString
r=a8.CW
q=a8.ay
if(0>=q.length)return A.a(q,0)
p=q[0]
o=a8.cx
n=A.w(a9,a6,0)
for(q=p.length,m=a8.c,l=r!=null,k=0,j=0;j<q;++j){n.d=p[j]
if(s)if(n.k()!==3.141592653589793)throw A.f(A.l("Invalid Image Data"))
i=n.k()
h=$.U()
h.$flags&2&&A.b(h)
h[0]=i
i=$.ab()
if(0>=i.length)return A.a(i,0)
h[0]=n.k()
g=n.aH(i[0])
n.d=n.d+(g.c-g.d)
if(l){i=r.cD(g,0,k)
h=i.length
f=new A.ai(i,0,Math.min(h,h),0,!1)}else f=g
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
switch(i.a){case 1:i=f.n()
h=$.N
h=h!=null?h:A.Q()
if(!(i<h.length))return A.a(h,i)
a3=h[i]
break
case 2:a3=f.n()
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
if(a4==null)a4=new A.E()
i=a0.b
i===$&&A.c("nameType")
a4.i(0,i.a,a3)}else{i=a0.a
i===$&&A.c("name")
h=a7.b
a5=h!=null?h.l(0,i):a6
if(a5!=null)a5.aP(a2,k,a3,0,0)}}}++c;++k}}},
$iM:1}
A.ef.prototype={
io(b5,b6,b7,b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=this,b1=null,b2="dataType",b3="dataWindow",b4=A.J(t.N,t.oD)
for(s=b0.e,r=t.t,q=t.L,p=b0.c,o=B.H;;){n=b7.d3()
if(n.length===0)break
b7.d3()
m=b7.aH(b7.k())
b7.d=b7.d+(m.c-m.d)
s.i(0,n,new A.he())
switch(n){case"channels":for(;;){l=new A.hf()
l.il(m)
k=l.a
k===$&&A.c("name")
if(k.length===0)break
j=l.w
j===$&&A.c("isColorChannel")
if(j){++b0.d
k=l.c
k===$&&A.c(b2)
if(k===B.be)o=B.H
else o=k===B.bf?B.I:B.R}else{j=l.c
j===$&&A.c(b2)
b4.i(0,k,j)}B.c.C(p,l)}break
case"chromaticities":k=new Float32Array(8)
b0.at=k
j=m.k()
i=$.U()
i.$flags&2&&A.b(i)
i[0]=j
j=$.cl()
if(0>=j.length)return A.a(j,0)
k[0]=j[0]
k=b0.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.b(k)
k[1]=h
h=b0.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.b(h)
h[2]=k
k=b0.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.b(k)
k[3]=h
h=b0.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.b(h)
h[4]=k
k=b0.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.b(k)
k[5]=h
h=b0.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.b(h)
h[6]=k
k=b0.at
i[0]=m.k()
j=j[0]
k.$flags&2&&A.b(k)
k[7]=j
break
case"compression":k=J.d(m.a,m.d++)
if(!(k>=0&&k<8))return A.a(B.bX,k)
b0.ax=B.bX[k]
break
case"dataWindow":k=m.k()
j=$.U()
j.$flags&2&&A.b(j)
j[0]=k
k=$.ab()
if(0>=k.length)return A.a(k,0)
i=k[0]
j[0]=m.k()
h=k[0]
j[0]=m.k()
g=k[0]
j[0]=m.k()
k=q.a(A.j([i,h,g,k[0]],r))
b0.r=k
b0.w=k[2]-k[0]+1
b0.x=k[3]-k[1]+1
break
case"displayWindow":k=m.k()
j=$.U()
j.$flags&2&&A.b(j)
j[0]=k
k=$.ab()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
j[0]=m.k()
j[0]=m.k()
break
case"lineOrder":break
case"pixelAspectRatio":k=m.k()
j=$.U()
j.$flags&2&&A.b(j)
j[0]=k
k=$.cl()
if(0>=k.length)return A.a(k,0)
break
case"screenWindowCenter":k=m.k()
j=$.U()
j.$flags&2&&A.b(j)
j[0]=k
k=$.cl()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
break
case"screenWindowWidth":k=m.k()
j=$.U()
j.$flags&2&&A.b(j)
j[0]=k
k=$.cl()
if(0>=k.length)return A.a(k,0)
break
case"tiles":b0.dx=m.k()
b0.dy=m.k()
f=J.d(m.a,m.d++)
b0.fr=f&15
b0.fx=B.a.j(f,4)&15
break
case"type":e=m.d3()
if(e!=="deepscanline")if(e!=="deeptile")throw A.f(A.l("EXR Invalid type: "+e))
break
default:break}}s=b0.w
if(s===0&&b0.x===0)return
A.ax(s,b0.x,b8,!1)
s=b0.w
b0.b=A.V(b1,b1,o,0,B.j,b0.x,b1,0,b0.d,b1,B.e,s,!1)
for(s=new A.eH(b4,b4.$ti.m("eH<1,2>")).gI(0);s.E();){d=s.d
switch(d.b.a){case 1:r=b0.w
q=b0.x
r=new A.dm(new Uint16Array(r*q),r,q,1)
break
case 2:r=b0.w
q=b0.x
r=new A.dn(new Float32Array(r*q),r,q,1)
break
case 0:r=b0.w
q=b0.x
r=new A.dr(new Uint32Array(r*q),r,q,1)
break
default:r=b1}q=b0.b
q.toString
q.i8(d.a,r)}if(b0.db){c={}
b=b0.dx
if(b==null)b=0
a=b0.dy
if(a==null)a=0
if(b<1||a<1)throw A.f(A.l("Invalid EXR tile size"))
A.ax(b,a,b8,!1)
s=b0.r
s===$&&A.c(b3)
b0.id=b0.j_(s[0],s[2],s[1],s[3])
s=b0.r
b0.k1=b0.j0(s[0],s[2],s[1],s[3])
if(b0.fr!==2)b0.k1=1
s=b0.id
s.toString
r=b0.r
b0.fy=b0.eZ(s,r[0],r[2],b0.dx,b0.fx)
r=b0.k1
r.toString
s=b0.r
b0.go=b0.eZ(r,s[1],s[3],b0.dy,b0.fx)
s=b0.iZ()
b0.k2=s
r=b0.dx
r.toString
r=s*r
b0.k3=r
b0.CW=A.o4(b0.ax,b0,r,b0.dy)
s=b0.k1
s.toString
r=b0.id
q=b0.fy
p=b0.go
a0=0
a1=0
for(;a1<s;++a1){r.toString
a2=0
for(;a2<r;++a2){if(!(a2<q.length))return A.a(q,a2)
k=q[a2]
if(!(a1<p.length))return A.a(p,a1)
a0+=k*p[a1]}}if(a0*8>b7.c-b7.d)throw A.f(A.l("Truncated EXR data"))
c.a=c.b=0
s=b0.id
s.toString
r=b0.k1
r.toString
b0.ay=A.os(s*r,new A.jk(c,b0),t.Q)}else{s=b0.x
r=b0.ch=new Uint32Array(s+1)
for(q=p.length,k=b0.r,j=b0.w,a3=0;a3<q;++a3){a4=p[a3]
i=a4.d
i===$&&A.c("dataSize")
h=a4.f
h===$&&A.c("xSampling")
a5=B.a.aa(i*j,h)
for(i=a4.r,a6=0;a6<s;++a6){k===$&&A.c(b3)
h=k[1]
i===$&&A.c("ySampling")
if(B.a.a5(a6+h,i)===0)r[a6]=r[a6]+a5}}for(a7=0,a6=0;a6<s;++a6)a7=Math.max(a7,r[a6])
s=A.o4(b0.ax,b0,a7,b1)
b0.CW=s
s=b0.cx=s.d1()
r=b0.ch
q=r.length
p=new Uint32Array(q)
b0.cy=p
for(--q,a8=0,a9=0;a9<=q;++a9){if(B.a.a5(a9,s)===0)a8=0
p[a9]=a8
a8+=r[a9]}s=B.a.aa(b0.x+s,s)
b0.ay=A.j([new Uint32Array(s-1)],t.mD)}},
j_(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.n(r)
s=(q===0?o.di(r):o.d9(r))+1
break
case 2:p=b-a+1
s=(o.fx===0?o.di(p):o.d9(p))+1
break
default:throw A.f(A.l("Unknown LevelMode format."))}return s},
j0(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.n(r)
s=(q===0?o.di(r):o.d9(r))+1
break
case 2:p=d-c+1
s=(o.fx===0?o.di(p):o.d9(p))+1
break
default:throw A.f(A.l("Unknown LevelMode format."))}return s},
di(a){var s
for(s=0;a>1;){++s
a=B.a.j(a,1)}return s},
d9(a){var s,r
for(s=0,r=0;a>1;){if((a&1)!==0)r=1;++s
a=B.a.j(a,1)}return s+r},
iZ(){var s,r,q,p,o
for(s=this.c,r=s.length,q=0,p=0;p<r;++p){o=s[p].d
o===$&&A.c("dataSize")
q+=o}return q},
eZ(a,b,c,d,e){var s,r,q,p,o,n,m=J.af(a,t.p)
for(s=e===1,r=c-b+1,q=0;q<a;++q){p=B.a.S(1,q)
o=B.a.aa(r,p)
if(s&&o*p<r)++o
n=Math.max(o,1)
d.toString
m[q]=B.a.aa(n+d-1,d)}return m}}
A.jk.prototype={
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
A.hz.prototype={
mx(a){var s,r,q,p,o,n=this
if(n.db)for(s=0;s<n.ay.length;++s){r=0
for(;;){q=n.ay
if(!(s<q.length))return A.a(q,s)
q=q[s]
if(!(r<q.length))break
p=a.eo()
q.$flags&2&&A.b(q)
q[r]=p;++r}}else{q=n.ay
if(0>=q.length)return A.a(q,0)
o=q[0].length
for(s=0;s<o;++s){q=n.ay
if(0>=q.length)return A.a(q,0)
q=q[0]
p=a.eo()
q.$flags&2&&A.b(q)
if(!(s<q.length))return A.a(q,s)
q[s]=p}}}}
A.hA.prototype={
iA(a,b,c){var s,r,q,p=this,o=a.c.length,n=J.af(o,t.nA)
for(s=0;s<o;++s)n[s]=new A.fJ()
p.y=t.a3.a(n)
r=p.w
r.toString
q=B.a.V(r*p.x,2)
p.z=new Uint16Array(q)},
d1(){return this.x},
bv(a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="_channelData"
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
i=B.a.aa(a8,q)
h=B.a.aa(s,q)
q=i*q<a8?0:1
q=h-i+q
j.c=q
p=k.r
p===$&&A.c("ySampling")
i=B.a.aa(a9,p)
h=B.a.aa(r,p)
g=i*p<a9?0:1
g=h-i+g
j.d=g
j.e=p
p=k.d
p===$&&A.c("dataSize")
p=p/2|0
j.f=p
m+=q*g*p}f=a7.n()
e=a7.n()
if(e>=8192)throw A.f(A.l("Error in header for PIZ-compressed data (invalid bitmap size)."))
d=new Uint8Array(8192)
if(f<=e){c=a7.af(e-f+1)
b=c.c-c.d
for(a=f,l=0;l<b;++l,a=a0){a0=a+1
q=J.d(c.a,c.d+l)
if(!(a<8192))return A.a(d,a)
d[a]=q}}a1=new Uint16Array(65536)
a2=a5.ll(d,a1)
A.qI(a7,a7.k(),a5.z,m)
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
A.qL(p,g+a,a3,q,a4,a3*q,a2);++a}}q=a5.z
q.toString
a5.iN(a1,q,m)
q=a5.r
if(q==null){q=a5.w
q.toString
q=a5.r=A.a0(!1,q*a5.x+73728)}q.a=0
for(;a9<=r;++a9)for(l=0;l<n;++l){q=a5.y
q===$&&A.c(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
q=j.e
q===$&&A.c("ys")
if(B.a.a5(a9,q)!==0)continue
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
q.a3(p[g])}}q=a5.r
return J.C(B.d.gq(q.c),0,q.a)},
cD(a,b,c){return this.bv(a,b,c,null,null)},
iN(a,b,c){var s,r,q,p=t.L
p.a(a)
p.a(b)
for(p=b.length,s=b.$flags|0,r=0;r<c;++r){if(!(r<p))return A.a(b,r)
q=b[r]
if(!(q>=0&&q<65536))return A.a(a,q)
q=a[q]
s&2&&A.b(b)
b[r]=q}},
ll(a,b){var s,r,q,p,o,n
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
A.fJ.prototype={}
A.hB.prototype={
d1(){return this.w},
bv(a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a4.Y(),a3=a1.r
a3.toString
a3=a1.w*a3
s=A.iV(a2,a3)
a2=a1.x;(a2==null?a1.x=A.a0(!1,a3):a2).a=0
r=A.j([0,0,0,0],t.t)
q=new Uint32Array(1)
p=J.C(B.o.gq(q),0,null)
if(a7==null)a7=a1.c.w
if(a8==null)a8=a1.c.cx
o=a5+a7-1
n=a6+a8-1
a2=a1.c
a3=a2.w
if(o>a3)o=a3-1
a3=a2.x
if(n>a3)n=a3-1
a1.a=o-a5+1
a1.b=n-a6+1
a2=a2.c
m=a2.length
for(a3=p.length,l=s.length,k=a6,j=0;k<=n;++k)for(i=0;i<m;++i){if(!(i<a2.length))return A.a(a2,i)
h=a2[i]
g=h.r
g===$&&A.c("ySampling")
if(B.a.a5(a6,g)!==0)continue
g=h.f
g===$&&A.c("xSampling")
f=B.a.aa(a5,g)
e=B.a.aa(o,g)
g=f*g<a5?0:1
d=e-f+g
if(0>=1)return A.a(q,0)
q[0]=0
g=h.c
g===$&&A.c("dataType")
switch(g.a){case 0:B.c.i(r,0,j)
B.c.i(r,1,r[0]+d)
B.c.i(r,2,r[1]+d)
j=r[2]+d
for(c=0;c<d;++c){g=r[0]
B.c.i(r,0,g+1)
if(!(g>=0&&g<l))return A.a(s,g)
g=s[g]
b=r[1]
B.c.i(r,1,b+1)
if(!(b>=0&&b<l))return A.a(s,b)
b=s[b]
a=r[2]
B.c.i(r,2,a+1)
if(!(a>=0&&a<l))return A.a(s,a)
a=s[a]
q[0]=q[0]+((g<<24|b<<16|a<<8)>>>0)
for(a0=0;a0<4;++a0){g=a1.x
g.toString
if(!(a0<a3))return A.a(p,a0)
g.p(p[a0])}}break
case 1:B.c.i(r,0,j)
B.c.i(r,1,r[0]+d)
j=r[1]+d
for(c=0;c<d;++c){g=r[0]
B.c.i(r,0,g+1)
if(!(g>=0&&g<l))return A.a(s,g)
g=s[g]
b=r[1]
B.c.i(r,1,b+1)
if(!(b>=0&&b<l))return A.a(s,b)
b=s[b]
q[0]=q[0]+((g<<8|b)>>>0)
for(a0=0;a0<2;++a0){g=a1.x
g.toString
if(!(a0<a3))return A.a(p,a0)
g.p(p[a0])}}break
case 2:B.c.i(r,0,j)
B.c.i(r,1,r[0]+d)
B.c.i(r,2,r[1]+d)
j=r[2]+d
for(c=0;c<d;++c){g=r[0]
B.c.i(r,0,g+1)
if(!(g>=0&&g<l))return A.a(s,g)
g=s[g]
b=r[1]
B.c.i(r,1,b+1)
if(!(b>=0&&b<l))return A.a(s,b)
b=s[b]
a=r[2]
B.c.i(r,2,a+1)
if(!(a>=0&&a<l))return A.a(s,a)
a=s[a]
q[0]=q[0]+((g<<24|b<<16|a<<8)>>>0)
for(a0=0;a0<4;++a0){g=a1.x
g.toString
if(!(a0<a3))return A.a(p,a0)
g.p(p[a0])}}break}}a2=a1.x
return J.C(B.d.gq(a2.c),0,a2.a)},
cD(a,b,c){return this.bv(a,b,c,null,null)}}
A.hC.prototype={
d1(){return 1},
bv(a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a0.c,a=A.a0(!1,(b-a0.d)*2)
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
p=$.az()
p.$flags&2&&A.b(p)
p[0]=q
q=$.aH()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0){n=-o
for(;m=n-1,n>0;n=m)a.p(J.d(a0.a,a0.d++))}else for(n=o;m=n-1,n>=0;n=m)a.p(J.d(a0.a,a0.d++))}l=J.C(B.d.gq(a.c),0,a.a)
k=l.length
for(b=l.$flags|0,j=1;j<k;++j){q=l[j-1]
p=l[j]
b&2&&A.b(l)
l[j]=q+p-128}b=c.r
if(b==null||b.length!==k)b=c.r=new Uint8Array(k)
q=B.a.V(k+1,2)
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
cD(a,b,c){return this.bv(a,b,c,null,null)},
D(a){return A.y(this.w)}}
A.eB.prototype={
d1(){return this.x},
bv(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=a.Y(),e=g.w
if(e==null)e=0
s=A.iV(f,e*g.x)
if(d==null)d=g.c.w
if(a0==null)a0=g.c.cx
r=b+d-1
q=c+a0-1
f=g.c
e=f.w
if(r>e)r=e-1
f=f.x
if(q>f)q=f-1
g.a=r-b+1
g.b=q-c+1
p=s.length
for(f=s.$flags|0,o=1;o<p;++o){e=s[o-1]
n=s[o]
f&2&&A.b(s)
s[o]=e+n-128}f=g.y
if(f==null||f.length!==p)f=g.y=new Uint8Array(p)
e=B.a.V(p+1,2)
for(m=0,l=0;;e=h,m=j){if(l<p){k=l+1
j=m+1
if(!(m<p))return A.a(s,m)
n=s[m]
f.$flags&2&&A.b(f)
i=f.length
if(!(l<i))return A.a(f,l)
f[l]=n}else break
if(k<p){l=k+1
h=e+1
if(!(e<p))return A.a(s,e)
e=s[e]
if(!(k<i))return A.a(f,k)
f[k]=e}else break}return f},
cD(a,b,c){return this.bv(a,b,c,null,null)},
D(a){return A.y(this.w)}}
A.jg.prototype={
aK(a){return A.P(new A.jj(this,a),t._)},
an(a){return A.P(new A.jh(this,a),t.H)},
jT(a){var s=this.a
if(s==null)return null
s=s.c
if(!(a<s.length))return A.a(s,a)
return s[a].b},
bg(a,b){return A.P(new A.ji(this,a,b),t.H)},
jS(a,b){if(this.aK(a)==null)return null
return this.an(0)}}
A.jj.prototype={
$0(){var s=this.a,r=new A.hh(A.j([],t.lv))
r.im(this.b,s.b)
return s.a=r},
$S:5}
A.jh.prototype={
$0(){return this.a.jT(this.b)},
$S:1}
A.ji.prototype={
$0(){return this.a.jS(this.b,this.c)},
$S:1}
A.em.prototype={
md(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(d===0&&e.c!=null){s=e.c
s.toString
return s}for(s=e.b,r=e.d,q=-1,p=-1,o=0;o<s;++o){n=r.b2(o)
m=r.b1(o)
l=r.b0(o)
k=r.b7(o)
if(n===a&&m===b&&l===c&&k===d)return o
j=a-n
i=b-m
h=c-l
g=d-k
f=j*j+i*i+h*h+g*g
if(p===-1){p=o
q=f}else if(f<q){p=o
q=f}}return p},
ev(){var s,r,q,p,o,n,m,l=this
if(l.c==null)return l.d
s=l.d
r=s.a
q=new A.aT(new Uint8Array(r*4),r,4)
for(p=0;p<r;++p){o=s.b2(p)
n=s.b1(p)
m=s.b0(p)
q.d6(p,o,n,m,p===l.c?0:255)}return q}}
A.en.prototype={
ip(a){var s,r,q,p,o,n,m=this
m.a=a.n()
m.b=a.n()
m.c=a.n()
m.d=a.n()
s=a.H()
m.e=(s&64)!==0
if((s&128)!==0){m.f=A.o7(B.a.S(1,(s&7)+1))
for(r=0;q=m.f,r<q.b;++r){p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n=J.d(a.a,a.d++)
q.d.ba(r,p,o,n)}}m.y=a.d-a.b}}
A.hD.prototype={}
A.c1.prototype={$iM:1}
A.jn.prototype={
aT(a){var s,r
this.r=A.v(a,!1,null,0)
this.a=new A.c1(A.j([],t.lM))
try{s=this.ft()
return s}catch(r){return!1}},
aK(a){return A.P(new A.jq(this,a),t.bT)},
ke(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.r=A.v(a,!1,null,0)
i.a=new A.c1(A.j([],t.lM))
if(!i.ft())return null
p=i.a
A.ax(p.a,p.b,i.b,!0)
try{while(p=i.r,o=p.d,o<p.c){n=p.a
p.d=o+1
s=J.d(n,o)
switch(s){case 44:r=i.fS()
if(r==null){p=i.a
return p}p=r
p.r=i.f
p.w=i.d
if(i.c!==0){if(r.f==null&&i.a.e!=null){p=i.a.e
o=p.a
n=p.b
m=p.c
p=p.d
r.f=new A.em(o,n,m,new A.aT(new Uint8Array(A.p(p.c)),p.a,p.b))}if(r.f!=null)r.f.c=i.e}B.c.C(i.a.r,r)
break
case 33:p=i.r
q=J.d(p.a,p.d++)
if(J.cm(q,255)){p=i.r
if(p.au(J.d(p.a,p.d++))==="NETSCAPE2.0"){l=J.d(p.a,p.d++)
k=J.d(p.a,p.d++)
if(l===3&&k===1)i.w=p.n()}else i.dt()}else if(J.cm(q,249)){p=i.r
p.toString
i.l2(p)}else i.dt()
break
case 59:p=i.a
return p
default:break}}}catch(j){}return i.a},
l2(a){var s,r,q,p=this
a.H()
s=a.H()
p.f=a.n()
p.e=a.H()
a.H()
p.d=B.a.j(s,2)&7
p.c=s&1
r=a.d7(1,0)
if(J.d(r.a,r.d)===44){++a.d
q=p.fS()
if(q==null)return
q.r=p.f
q.w=p.d
r=p.c!==0
q.x=r?p.e:-1
if(r){r=q.f
if(r==null&&p.a.e!=null){r=p.a.e
r.toString
r=q.f=A.qQ(r)}if(r!=null)r.c=p.e}B.c.C(p.a.r,q)}},
an(a){return A.P(new A.jo(this,a),t.H)},
kd(a){var s,r,q,p=this,o=p.r
if(o==null||p.a==null)return null
s=p.a.r
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.c("_inputPosition")
o.d=s
return p.ju(q)},
bg(a,b){return A.P(new A.jp(this,a,b),t.H)},
kc(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null
if(a4.aK(a6)==null)return a5
s=a4.a
r=s.r.length
if(r===1)return a4.an(0)
new A.bO(a4.b).ce(0,s.a*r,s.b)
for(s=t.p,q=a5,p=q,o=0;r=a4.a.r,o<r.length;++o){a7=r[o]
n=a4.an(o)
if(n==null)return a5
n.y=a7.r*10
if(p==null||q==null){n.r=a4.w
q=n
p=q
continue}r=n.a
m=r==null
l=m?a5:r.a
if(l==null)l=0
k=q.a
j=k==null
i=j?a5:k.a
h=!1
if(l===(i==null?0:i)){r=m?a5:r.b
if(r==null)r=0
m=j?a5:k.b
if(r===(m==null?0:m)){r=a7.a
r===$&&A.c("x")
if(r===0){r=a7.b
r===$&&A.c("y")
r=r===0&&a7.w===2}else r=h}else r=h}else r=h
if(r){p.aR(n)
q=n
continue}g=a7.f
if(!(g!=null)){r=a4.a.e
r.toString
g=r}r=j?a5:k.a
if(r==null)r=0
m=j?a5:k.b
if(m==null)m=0
f=A.V(a5,a5,B.e,0,B.j,m,a5,0,1,g.ev(),B.e,r,!1)
r=a7.w
if(r===2){r=f.a
e=r==null?a5:J.G(r.gq(r))
if(e==null){r=f.a
r=r==null?a5:r.gq(r)
if(r==null)r=B.d.gq(new Uint8Array(0))
e=J.G(r)}r=a7.x
m=e.length
if(r!==-1)B.d.a8(e,0,m,r)
else{r=a4.a.c.a
l=r.length
if(l!==0){if(0>=l)return A.a(r,0)
r=r[0]}else r=0
B.d.a8(e,0,m,r)}}else if(r!==3)if(a7.f!=null){r=q.a
d=r==null?a5:r.gR()
c=A.J(s,s)
for(r=d.a,b=0;b<r;++b)c.i(0,b,g.md(d.b2(b),d.b1(b),d.b0(b),d.b7(b)))
r=f.a
a=r==null?a5:J.G(r.gq(r))
if(a==null){r=f.a
r=r==null?a5:r.gq(r)
if(r==null)r=B.d.gq(new Uint8Array(0))
a=J.G(r)}r=q.a
a0=r==null?a5:J.G(r.gq(r))
if(a0==null){r=q.a
r=r==null?a5:r.gq(r)
if(r==null)r=B.d.gq(new Uint8Array(0))
a0=J.G(r)}for(a1=a.length,r=a0.length,m=a.$flags|0,a2=0;a2<a1;++a2){if(!(a2<r))return A.a(a0,a2)
a3=c.l(0,a0[a2])
if(a3!=null&&a3!==-1){m&2&&A.b(a)
a[a2]=a3}}}f.y=n.y
r=a7.a
r===$&&A.c("x")
m=a7.b
m===$&&A.c("y")
a4.j4(n,f,r,m)
p.aR(f)
q=f}return p},
fS(){var s,r=this.r
if(r.d>=r.c)return null
s=new A.hD()
s.ip(r);++this.r.d
this.dt()
return s},
ju(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=null
if(f.x==null){f.x=new Uint8Array(256)
f.y=new Uint8Array(4095)
f.z=new Uint8Array(4096)
f.Q=new Uint32Array(4096)}s=f.as=f.r.H()
r=B.a.U(1,s)
f.fr=r;++r
f.dy=r
f.dx=r+1;++s
f.db=s
f.cy=B.a.U(1,s)
f.ch=0
f.cx=4098
f.ax=f.ay=0
s=f.x
s.toString
s.$flags&2&&A.b(s)
s[0]=0
s=f.Q
s.toString
B.o.a8(s,0,4096,4098)
s=a.c
s===$&&A.c("width")
r=a.d
r===$&&A.c("height")
q=a.a
q===$&&A.c("x")
p=f.a
if(q+s<=p.a){q=a.b
q===$&&A.c("y")
q=q+r>p.b}else q=!0
if(q)return e
o=a.f
if(!(o!=null)){q=p.e
q.toString
o=q}f.at=s*r
n=A.V(e,e,B.e,0,B.j,r,e,0,1,o.ev(),B.e,s,!1)
m=new Uint8Array(s)
q=a.e
q===$&&A.c("interlaced")
if(q){q=a.b
q===$&&A.c("y")
for(r=q+r,l=0,k=0;l<4;++l)for(j=q+B.dJ[l];j<r;j+=B.f7[l],++k){if(!f.fo(m))return n
p=n.a
i=p==null
h=i?e:p.a
g=j*(h==null?0:h)
p=i?e:J.G(p.gq(p))
if(p==null){p=n.a
p=p==null?e:p.gq(p)
if(p==null)p=B.d.gq(new Uint8Array(0))
p=J.G(p)}B.d.aB(p,g,g+s,m)}}else for(j=0;j<r;++j){if(!f.fo(m))return n
q=n.a
p=q==null
i=p?e:q.a
g=j*(i==null?0:i)
q=p?e:J.G(q.gq(q))
if(q==null){q=n.a
q=q==null?e:q.gq(q)
if(q==null)q=B.d.gq(new Uint8Array(0))
q=J.G(q)}B.d.aB(q,g,g+s,m)}return n},
j4(a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=a2.a,a=b==null?null:b.gR(),a0=a.a,a1=J.bL(a0,t.y)
for(s=0;s<a0;++s)a1[s]=a.b7(s)!==0
r=a2.Y()
q=a3.Y()
p=a2.gN()
o=a3.gN()
n=a3.gJ()
b=a2.a
m=a1.length
l=r.length
k=q.$flags|0
j=b==null
i=0
for(;;){h=j?null:b.b
if(!(i<(h==null?0:h)))break
g=i+a5
if(g>=n)break
for(f=i*p,h=g*o,e=0;e<p;++e,++f){d=e+a4
if(d>=o)break
if(!(f>=0&&f<l))return A.a(r,f)
s=r[f]
if(s<m&&a1[s]){c=h+d
k&2&&A.b(q)
if(!(c>=0&&c<q.length))return A.a(q,c)
q[c]=s}}++i}},
ft(){var s,r,q,p,o,n=this,m=n.r.au(6)
if(m!=="GIF87a"&&m!=="GIF89a")return!1
s=n.a
s.toString
s.a=n.r.n()
s=n.a
s.toString
s.b=n.r.n()
r=n.r.H()
s=n.a
s.toString
s.c=new A.bd(new Uint8Array(A.p(A.j([n.r.H()],t.t))));++n.r.d
if((r&128)!==0){s=n.a
s.toString
s.e=A.o7(B.a.S(1,(r&7)+1))
for(q=0;q<n.a.e.b;++q){s=n.r
p=J.d(s.a,s.d++)
s=n.r
o=J.d(s.a,s.d++)
s=n.r
r=J.d(s.a,s.d++)
n.a.e.d.ba(q,p,o,r)}}n.a.toString
return!0},
fo(a){var s=this,r=s.at
r.toString
s.at=r-a.length
if(!s.jF(a))return!1
if(s.at===0)s.dt()
return!0},
dt(){var s,r,q,p=this.r
if(p.d>=p.c)return!0
s=p.H()
for(;;){if(s!==0){p=this.r
p=p.d<p.c}else p=!1
if(!p)break
p=this.r
r=p.d+=s
if(r>=p.c)return!0
q=p.a
p.d=r+1
s=J.d(q,r)}return!0},
jF(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_stack",e="_suffix",d=g.ch
if(d>4095)return!1
s=a.length
r=0
if(d!==0){q=a.$flags|0
for(;;){if(!(d!==0&&r<s))break
p=r+1
o=g.y
o===$&&A.c(f)
d=g.ch=d-1
if(!(d>=0))return A.a(o,d)
o=o[d]
q&2&&A.b(a)
if(!(r<s))return A.a(a,r)
a[r]=o
r=p}}for(d=a.$flags|0;r<s;){n=g.CW=g.jE()
if(n==null)return!1
q=g.dy
if(n===q)return!1
o=g.fr
if(n===o){for(o=g.Q,m=0;m<=4095;++m){o.toString
o.$flags&2&&A.b(o)
o[m]=4098}g.dx=q+1
q=g.as+1
g.db=q
g.cy=B.a.U(1,q)
g.cx=4098}else{if(n<o){p=r+1
d&2&&A.b(a)
if(!(r>=0))return A.a(a,r)
a[r]=n
r=p}else{q=g.Q
q.toString
if(n>>>0!==n||n>=4096)return A.a(q,n)
if(q[n]===4098){l=g.dx-2
if(n===l){n=g.cx
k=g.z
k===$&&A.c(e)
j=g.y
j===$&&A.c(f)
i=g.ch++
o=g.e3(q,n,o)
j.$flags&2&&A.b(j)
if(!(i>=0&&i<4095))return A.a(j,i)
j[i]=o
k.$flags&2&&A.b(k)
if(!(l>=0&&l<4096))return A.a(k,l)
k[l]=o}else return!1}m=0
for(;;){h=m+1
if(!(m<=4095&&n>g.fr&&n<=4095))break
q=g.y
q===$&&A.c(f)
o=g.ch++
l=g.z
l===$&&A.c(e)
if(!(n>=0&&n<4096))return A.a(l,n)
l=l[n]
q.$flags&2&&A.b(q)
if(!(o>=0&&o<4095))return A.a(q,o)
q[o]=l
n=g.Q[n]
m=h}if(h>=4095||n>4095)return!1
q=g.y
q===$&&A.c(f)
o=g.ch
l=g.ch=o+1
q.$flags&2&&A.b(q)
if(!(o>=0&&o<4095))return A.a(q,o)
q[o]=n
o=l
for(;;){if(!(o!==0&&r<s))break
p=r+1
o=g.ch=o-1
if(!(o>=0&&o<4095))return A.a(q,o)
l=q[o]
d&2&&A.b(a)
if(!(r>=0&&r<s))return A.a(a,r)
a[r]=l
r=p}}q=g.cx
if(q!==4098){o=g.Q
o.toString
l=g.dx-2
if(!(l>=0&&l<4096))return A.a(o,l)
l=o[l]===4098
o=l}else o=!1
if(o){o=g.Q
o.toString
l=g.dx-2
o.$flags&2&&A.b(o)
if(!(l>=0&&l<4096))return A.a(o,l)
o[l]=q
k=g.CW
j=g.z
i=g.fr
if(k===l){j===$&&A.c(e)
q=g.e3(o,q,i)
j.$flags&2&&A.b(j)
j[l]=q}else{j===$&&A.c(e)
k.toString
q=g.e3(o,k,i)
j.$flags&2&&A.b(j)
j[l]=q}}q=g.CW
q.toString
g.cx=q}}return!0},
jE(){var s,r,q,p,o=this
if(o.db>12)return null
while(s=o.ay,r=o.db,s<r){s=o.iU()
s.toString
r=o.ax
q=o.ay
o.ax=(r|B.a.U(s,q))>>>0
o.ay=q+8}q=o.ax
if(!(r>=0&&r<13))return A.a(B.bE,r)
p=B.bE[r]
o.ax=B.a.a6(q,r)
o.ay=s-r
s=o.dx
if(s<4097){++s
o.dx=s
s=s>o.cy&&r<12}else s=!1
if(s){o.cy=o.cy<<1>>>0
o.db=r+1}return q&p},
e3(a,b,c){var s,r,q=0
for(;;){if(b>c){s=q+1
r=q<=4095
q=s}else r=!1
if(!r)break
if(b>4095)return 4098
a.toString
if(!(b>=0))return A.a(a,b)
b=a[b]}return b},
iU(){var s,r,q=this,p=q.x,o=p[0],n=p.$flags|0
if(o===0){o=q.r.H()
n&2&&A.b(p)
p[0]=o
p=q.x
o=p[0]
if(o===0)return null
B.d.aB(p,1,1+o,q.r.af(o).Y())
p=q.x
s=p[1]
p.$flags&2&&A.b(p)
p[1]=2
p[0]=p[0]-1}else{r=p[1]
n&2&&A.b(p)
p[1]=r+1
if(!(r<256))return A.a(p,r)
s=p[r]
p[0]=o-1}return s}}
A.jq.prototype={
$0(){return this.a.ke(this.b)},
$S:51}
A.jo.prototype={
$0(){return this.a.kd(this.b)},
$S:1}
A.jp.prototype={
$0(){return this.a.kc(this.b,this.c)},
$S:1}
A.jr.prototype={
gfN(){return B.de},
hc(a,b){var s,r,q,p=this
if(p.id==null){p.id=A.a0(!1,8192)
if(!a.gaw()){s=A.mR(a,256,10)
p.as=s
p.z=A.pv(a,B.aI,s,p.gfN(),1)}else p.z=a
p.Q=b
p.at=a.gN()
p.ax=a.gJ()
return}if(p.ay===0){s=p.at
s===$&&A.c("_width")
r=p.ax
r===$&&A.c("_height")
p.h7(s,r)
p.h2()}s=p.z
s.toString
p.h6(s)
s=p.z
s.toString
r=p.at
r===$&&A.c("_width")
q=p.ax
q===$&&A.c("_height")
p.eP(s,r,q);++p.ay
if(!a.gaw()){s=A.mR(a,256,10)
p.as=s
p.z=A.pv(a,B.aI,s,p.gfN(),1)}else p.z=a
p.Q=b},
aR(a){return this.hc(a,null)},
dA(){var s,r,q,p,o=this
if(o.id==null)return null
if(o.ay===0){s=o.at
s===$&&A.c("_width")
r=o.ax
r===$&&A.c("_height")
o.h7(s,r)
o.h2()}s=o.z
s.toString
o.h6(s)
s=o.z
s.toString
r=o.at
r===$&&A.c("_width")
q=o.ax
q===$&&A.c("_height")
o.eP(s,r,q)
o.id.p(59)
o.as=o.z=null
o.ay=0
q=o.id
p=J.C(B.d.gq(q.c),0,q.a)
o.id=null
return p},
bR(a){var s,r,q,p,o=this
A.ci(a)
s=a.gae().length
if(s<=1){o.aR(a)
s=o.dA()
s.toString
return s}o.b=a.r
for(s=a.gae(),r=s.length,q=0;q<s.length;s.length===r||(0,A.L)(s),++q){p=s[q]
o.hc(p,B.a.V(p.y,10))}s=o.dA()
s.toString
return s},
eP(a,b,c){var s,r,q,p,o,n,m,l,k,j
if(!a.gaw())throw A.f(A.l("GIF can only encode palette images."))
s=a.a
r=s==null?null:s.gR()
q=r.a
p=this.id
p.p(44)
p.a3(0)
p.a3(0)
p.a3(b)
p.a3(c)
o=J.C(r.gq(r),0,null)
p.p(135)
n=r.b
if(n===3)p.a2(o)
else if(n===4)for(s=o.length,m=0,l=0;m<q;++m,l+=4){if(!(l<s))return A.a(o,l)
p.p(o[l])
k=l+1
if(!(k<s))return A.a(o,k)
p.p(o[k])
k=l+2
if(!(k<s))return A.a(o,k)
p.p(o[k])}else if(n===1||n===2)for(s=o.length,m=0,l=0;m<q;++m,l+=n){if(!(l>=0&&l<s))return A.a(o,l)
j=o[l]
p.p(j)
p.p(j)
p.p(j)}for(m=q;m<256;++m){p.p(0)
p.p(0)
p.p(0)}this.jP(a,b,c)},
jP(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d={}
e.go=e.CW=e.ch=0
e.fy=new Uint8Array(256)
e.id.p(8)
s=new Int32Array(5003)
r=new Int32Array(5003)
q=a.a
p=q.gI(q)
p.E()
e.cx=e.cy=9
e.dx=511
e.dy=256
e.db=257
e.fx=!1
e.fr=258
d.a=!1
o=new A.js(d,p)
n=o.$0()
for(m=0,l=5003;l<65536;l*=2)++m
m=8-m
for(k=0;k<5003;++k)s[k]=-1
e.cL(e.dy)
for(j=!0;j;){i=o.$0()
for(j=!1;i!==-1;){h=(i<<12>>>0)+n
k=(B.a.U(i,m)^n)>>>0
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
e.id.p(0)},
cL(a){var s,r=this,q=r.ch,p=r.CW
if(!(p>=0&&p<17))return A.a(B.c4,p)
q&=B.c4[p]
r.ch=q
if(p>0){q=(q|B.a.S(a,p))>>>0
r.ch=q}else{r.ch=a
q=a}p+=r.cx
r.CW=p
while(p>=8){r.eR(q&255)
q=B.a.j(r.ch,8)
r.ch=q
p=r.CW-=8}if(r.fr>r.dx||r.fx)if(r.fx){s=r.cy
r.cx=s
r.dx=B.a.S(1,s)-1
r.fx=!1}else{s=++r.cx
if(s===12)r.dx=4096
else r.dx=B.a.S(1,s)-1}if(a===r.db){while(p>0){r.eR(q&255)
q=B.a.j(r.ch,8)
r.ch=q
p=r.CW-=8}r.h3()}},
h3(){var s,r=this,q=r.go
if(q>0){r.id.p(q)
q=r.id
q.toString
s=r.fy
s===$&&A.c("_block")
q.i_(s,r.go)
r.go=0}},
eR(a){var s,r,q=this,p=q.fy
p===$&&A.c("_block")
s=q.go
r=s+1
q.go=r
p.$flags&2&&A.b(p)
if(!(s<256))return A.a(p,s)
p[s]=a
if(r>=254)q.h3()},
h2(){var s,r=this
r.id.p(33)
r.id.p(255)
r.id.p(11)
r.id.a2(new A.ah("NETSCAPE2.0"))
s=r.id
s.toString
s.a2(A.j([3,1],t.t))
r.id.a3(r.b)
r.id.p(0)},
h6(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
h.id.p(33)
h.id.p(249)
h.id.p(4)
s=a.a
r=s==null?null:s.gR()
q=r.b
p=q-1
o=0
n=0
if(q===4||q===2){m=J.C(r.gq(r),0,null)
l=r.a
for(s=m.length,k=p,j=o;j<l;++j,k+=q){if(!(k>=0&&k<s))return A.a(m,k)
if(m[k]===0){o=j
n=1
break}}}h.id.p(n|8)
s=h.id
s.toString
i=h.Q
s.a3(i==null?80:i)
h.id.p(o)
h.id.p(0)},
h7(a,b){var s=this
s.id.a2(new A.ah("GIF89a"))
s.id.a3(a)
s.id.a3(b)
s.id.p(0)
s.id.p(0)
s.id.p(0)}}
A.js.prototype={
$0(){var s,r,q=this.a
if(q.a)return-1
s=this.b
r=A.n(s.gO().gW())
if(!s.E())q.a=!0
return r},
$S:26}
A.dl.prototype={
a7(){return"IcoType."+this.b}}
A.hq.prototype={$iM:1}
A.hr.prototype={}
A.ho.prototype={
gJ(){return B.a.V(A.aZ.prototype.gJ.call(this),2)},
gcZ(){return!(this.d===40&&this.f===32)&&A.aZ.prototype.gcZ.call(this)}}
A.ju.prototype={
aT(a){var s,r=this,q=A.v(a,!1,null,0)
r.a=q
try{r.b=A.o8(q)}catch(s){r.b=null}return r.b!=null},
aK(a){return A.P(new A.jx(this,a),t._)},
bg(a,b){return A.P(new A.jw(this,a,b),t.H)},
kg(a,b){var s,r,q,p,o,n,m=this,l=null
if(m.aK(a)==null)return l
s=m.b.e.length
if(s===1)return m.an(0)
r=new A.bO(m.c)
for(q=l,p=0;p<m.b.e.length;++p){b=m.an(p)
if(b==null)continue
s=b.a
o=s==null
n=o?l:s.a
if(n==null)n=0
s=o?l:s.b
r.ce(0,n,s==null?0:s)
if(q==null){b.w=B.j
q=b}else q.aR(b)}return q},
an(a){return A.P(new A.jv(this,a),t.H)},
kh(b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1=a9.a
if(b1!=null){s=a9.b
s=s==null||b2>=s.d}else s=!0
if(s)return b0
s=a9.b.e
if(!(b2<s.length))return A.a(s,b2)
r=s[b2]
s=b1.a
b1=b1.b+r.e
q=r.d
p=J.mC(s,b1,b1+q)
b1=a9.c
o=A.oy(b1)
t.D.a(p)
if(o.aT(p))return o.bg(p,0)
n=A.a0(!1,14)
n.a3(19778)
n.K(q)
n.K(0)
n.K(0)
s=A.v(p,!1,b0,0)
q=A.nT(A.v(J.C(B.d.gq(n.c),0,n.a),!1,b0,0))
m=s.d
l=s.k()
k=s.k()
j=$.U()
j.$flags&2&&A.b(j)
j[0]=k
k=$.ab()
if(0>=k.length)return A.a(k,0)
i=k[0]
j[0]=s.k()
k=k[0]
h=s.n()
g=s.n()
f=s.k()
if(f>=14)A.a3(A.l("Unsupported BMP compression type: "+f))
if(!(f<14))return A.a(B.az,f)
f=B.az[f]
s.k()
j[0]=s.k()
j[0]=s.k()
j=s.k()
s.k()
e=new A.ho(q,i,k,l,h,g,f,j,m)
e.eM(s,q)
if(l!==40&&h!==1)return b0
d=j===0&&g<=8?40+4*B.a.S(1,g):40+4*j
q.b=d
n.a-=4
n.K(d)
c=A.v(p,!1,b0,0)
b=new A.jd(!0,b1)
b.a=c
b.b=e
a=b.an(0)
if(g>=32)return a
a0=32-B.a.a5(i,32)
a1=B.a.V(a0===32?i:i+a0,8)
for(b1=k<0,s=k===0,k=1/k<0,a2=0;a2<B.a.V(A.aZ.prototype.gJ.call(e),2);++a2){if(!(s?k:b1))a3=a2
else{q=a.a
q=q==null?b0:q.b
a3=(q==null?0:q)-1-a2}a4=c.aH(a1)
c.d=c.d+(a4.c-a4.d)
q=a.a
a5=q==null?b0:q.P(0,a3,b0)
if(a5==null)a5=new A.E()
for(a6=0;a6<i;){a7=J.d(a4.a,a4.d++)
a8=7
for(;;){if(!(a8>-1&&a6<i))break
if((a7&B.a.U(1,a8))>>>0!==0)a5.sv(0)
a5.E();++a6;--a8}}}return a}}
A.jx.prototype={
$0(){var s=this.a,r=A.v(this.b,!1,null,0)
s.a=r
return s.b=A.o8(r)},
$S:5}
A.jw.prototype={
$0(){return this.a.kg(this.b,this.c)},
$S:1}
A.jv.prototype={
$0(){return this.a.kh(this.b)},
$S:1}
A.ln.prototype={
bR(a){var s
A.ci(a)
s=a.gae().length
if(s>1)return this.hB(a.gae())
else return this.hB(A.j([a],t.g))},
hB(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null
t.aL.a(a)
s=a.length
r=A.a0(!1,8192)
r.a3(0)
r.a3(1)
r.a3(s)
q=6+s*16
p=A.j([A.j([],t.t)],t.S)
for(o=a.length,n=0,m=0;m<a.length;a.length===o||(0,A.L)(a),++m){l=a[m]
k=l.a
j=k==null
i=j?g:k.a
if((i==null?0:i)<=256){i=j?g:k.b
i=(i==null?0:i)>256}else i=!0
if(i)throw A.f(A.o3("ICO and CUR support only sizes until 256"))
k=j?g:k.a
r.p(k==null?0:k)
k=l.a
k=k==null?g:k.b
r.p(k==null?0:k)
r.p(0)
r.p(0)
r.a3(0)
r.a3(32)
h=new A.hZ().hz(l,!0)
k=h.length
r.K(k)
r.K(q)
q+=k;++n
B.c.C(p,h)}for(o=p.length,m=0;m<p.length;p.length===o||(0,A.L)(p),++m)r.a2(p[m])
return J.C(B.d.gq(r.c),0,r.a)}}
A.hp.prototype={}
A.h6.prototype={}
A.c2.prototype={}
A.cu.prototype={}
A.dk.prototype={}
A.jP.prototype={
iB(a){var s,r,q,p,o,n,m,l=this,k=null,j="ifd0",i="_start",h="_xStep",g="_yStep",f=l.a,e=f.y
if(e.l(0,j).a.ac(274)){s=e.l(0,j).gbU()
s.toString
r=s}else r=0
q=r>=5&&r<=8
p=q?l.c:l.b
s=A.V(k,k,B.e,0,B.j,q?l.b:l.c,k,0,3,k,B.e,p,!1)
s.e=A.ee(e)
s.gbh().l(0,j).sbU(k)
s.c=f.x
l.d!==$&&A.A("image")
l.d=s
f=s.a
f=J.G(f.gq(f))
l.e!==$&&A.A("_data")
l.e=f
o=s.a.gaz()
n=l.b-1
m=l.c-1
f=l.f
switch(r){case 2:f!==$&&A.A(i)
l.f=n*3
l.r!==$&&A.A(h)
l.r=-3
l.w!==$&&A.A(g)
l.w=o
break
case 3:f!==$&&A.A(i)
l.f=m*o+n*3
l.r!==$&&A.A(h)
l.r=-3
l.w!==$&&A.A(g)
l.w=-o
break
case 4:f!==$&&A.A(i)
l.f=m*o
l.r!==$&&A.A(h)
l.r=3
l.w!==$&&A.A(g)
l.w=-o
break
case 5:f!==$&&A.A(i)
l.f=0
l.r!==$&&A.A(h)
l.r=o
l.w!==$&&A.A(g)
l.w=3
break
case 6:f!==$&&A.A(i)
l.f=m*3
l.r!==$&&A.A(h)
l.r=o
l.w!==$&&A.A(g)
l.w=-3
break
case 7:f!==$&&A.A(i)
l.f=n*o+m*3
l.r!==$&&A.A(h)
l.r=-o
l.w!==$&&A.A(g)
l.w=-3
break
case 8:f!==$&&A.A(i)
l.f=n*o
l.r!==$&&A.A(h)
l.r=-o
l.w!==$&&A.A(g)
l.w=3
break
default:f!==$&&A.A(i)
l.f=0
l.r!==$&&A.A(h)
l.r=3
l.w!==$&&A.A(g)
l.w=o
break}},
i0(d7,d8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9=this,d0="_start",d1="_yStep",d2="_data",d3="_xStep",d4=c9.a,d5=d4.ax,d6=d5.length
switch(d6){case 1:if(0>=d6)return A.a(d5,0)
s=d5[0]
r=s.f
q=s.r
d4=c9.f
d4===$&&A.c(d0)
d6=c9.w
d6===$&&A.c(d1)
p=d4+d7*d6
for(d4=c9.b,o=c9.r,n=c9.e,m=s.e,l=m.length,k=d7;k<d8;++k,p+=d6){j=B.a.j(k,q)
if(!(j<l))return A.a(m,j)
i=m[j]
j=i.length
h=p
g=0
while(g<d4){f=B.a.a6(g,r)
if(!(f<j))return A.a(i,f)
e=i[f]
n===$&&A.c(d2)
n.$flags&2&&A.b(n)
f=n.length
if(!(h>=0&&h<f))return A.a(n,h)
n[h]=e
d=h+1
if(!(d<f))return A.a(n,d)
n[d]=e
d=h+2
if(!(d<f))return A.a(n,d)
n[d]=e;++g
o===$&&A.c(d3)
h+=o}}break
case 3:d4=d4.e
c=d4==null||d4.d===1
if(0>=d6)return A.a(d5,0)
s=d5[0]
if(1>=d6)return A.a(d5,1)
b=d5[1]
if(2>=d6)return A.a(d5,2)
a=d5[2]
r=s.f
q=s.r
a0=b.f
a1=b.r
a2=a.f
a3=a.r
a4=$.nO()
d4=c9.f
d4===$&&A.c(d0)
d6=c9.w
d6===$&&A.c(d1)
p=d4+d7*d6
for(d4=c9.b,o=c9.r,n=c9.e,m=s.e,l=m.length,j=b.e,f=j.length,d=a.e,a5=d.length,k=d7;k<d8;++k,p+=d6){a6=B.a.j(k,q)
if(!(a6<l))return A.a(m,a6)
a6=m[a6]
a6.toString
a7=B.a.j(k,a1)
if(!(a7<f))return A.a(j,a7)
a7=j[a7]
a7.toString
a8=B.a.j(k,a3)
if(!(a8<a5))return A.a(d,a8)
a8=d[a8]
a8.toString
if(c){a9=a6.length
b0=a7.length
b1=a8.length
h=p
g=0
while(g<d4){b2=B.a.a6(g,r)
if(!(b2<a9))return A.a(a6,b2)
e=(a6[b2]<<8>>>0)+65536
b2=B.a.a6(g,a0)
if(!(b2<b0))return A.a(a7,b2)
b3=a7[b2]-128
b2=B.a.a6(g,a2)
if(!(b2<b1))return A.a(a8,b2)
b4=a8[b2]-128
n===$&&A.c(d2)
b2=B.a.j(e+359*b4,8)
if(!(b2<768))return A.a(a4,b2)
b2=a4[b2]
n.$flags&2&&A.b(n)
b5=n.length
if(!(h>=0&&h<b5))return A.a(n,h)
n[h]=b2
b2=h+1
b6=B.a.j(e-88*b3-183*b4,8)
if(!(b6<768))return A.a(a4,b6)
b6=a4[b6]
if(!(b2<b5))return A.a(n,b2)
n[b2]=b6
b6=h+2
b2=B.a.j(e+454*b3,8)
if(!(b2<768))return A.a(a4,b2)
b2=a4[b2]
if(!(b6<b5))return A.a(n,b6)
n[b6]=b2;++g
o===$&&A.c(d3)
h+=o}}else{a9=a6.length
b0=a7.length
b1=a8.length
h=p
g=0
while(g<d4){n===$&&A.c(d2)
b2=B.a.a6(g,r)
if(!(b2<a9))return A.a(a6,b2)
b2=a6[b2]
n.$flags&2&&A.b(n)
b5=n.length
if(!(h>=0&&h<b5))return A.a(n,h)
n[h]=b2
b2=h+1
b6=B.a.a6(g,a0)
if(!(b6<b0))return A.a(a7,b6)
b6=a7[b6]
if(!(b2<b5))return A.a(n,b2)
n[b2]=b6
b6=h+2
b2=B.a.a6(g,a2)
if(!(b2<b1))return A.a(a8,b2)
b2=a8[b2]
if(!(b6<b5))return A.a(n,b6)
n[b6]=b2;++g
o===$&&A.c(d3)
h+=o}}}break
case 4:d4=d4.e
if(d4==null)throw A.f(A.l("Unsupported color mode (4 components)"))
d4=d4.d===0
if(0>=d6)return A.a(d5,0)
s=d5[0]
if(1>=d6)return A.a(d5,1)
b=d5[1]
if(2>=d6)return A.a(d5,2)
a=d5[2]
if(3>=d6)return A.a(d5,3)
b7=d5[3]
r=s.f
q=s.r
a0=b.f
a1=b.r
a2=a.f
a3=a.r
b8=b7.f
b9=b7.r
a4=$.nO()
d6=c9.f
d6===$&&A.c(d0)
o=c9.w
o===$&&A.c(d1)
p=d6+d7*o
for(d6=c9.b,n=c9.r,m=c9.e,l=s.e,j=l.length,f=b.e,d=f.length,a5=a.e,a6=a5.length,a7=b7.e,a8=a7.length,k=d7;k<d8;++k,p+=o){a9=B.a.j(k,q)
if(!(a9<j))return A.a(l,a9)
a9=l[a9]
a9.toString
b0=B.a.j(k,a1)
if(!(b0<d))return A.a(f,b0)
b0=f[b0]
b0.toString
b1=B.a.j(k,a3)
if(!(b1<a6))return A.a(a5,b1)
b1=a5[b1]
b1.toString
b2=B.a.j(k,b9)
if(!(b2<a8))return A.a(a7,b2)
c0=a7[b2]
b2=a9.length
b5=b0.length
b6=b1.length
c1=c0.length
h=p
g=0
while(g<d6){c2=B.a.a6(g,b8)
if(!(c2<c1))return A.a(c0,c2)
c3=c0[c2]
if(d4){c2=B.a.a6(g,r)
if(!(c2<b2))return A.a(a9,c2)
c4=a9[c2]
c2=B.a.a6(g,a0)
if(!(c2<b5))return A.a(b0,c2)
c5=b0[c2]
c2=B.a.a6(g,a2)
if(!(c2<b6))return A.a(b1,c2)
e=b1[c2]}else{c2=B.a.a6(g,r)
if(!(c2<b2))return A.a(a9,c2)
c6=(a9[c2]<<8>>>0)+65536
c2=B.a.a6(g,a0)
if(!(c2<b5))return A.a(b0,c2)
b3=b0[c2]-128
c2=B.a.a6(g,a2)
if(!(c2<b6))return A.a(b1,c2)
b4=b1[c2]-128
c2=B.a.j(c6+359*b4,8)
if(!(c2<768))return A.a(a4,c2)
c4=255-a4[c2]
c2=B.a.j(c6-88*b3-183*b4,8)
if(!(c2<768))return A.a(a4,c2)
c5=255-a4[c2]
c2=B.a.j(c6+454*b3,8)
if(!(c2<768))return A.a(a4,c2)
e=255-a4[c2]}m===$&&A.c(d2)
c2=B.a.j(c4*c3,8)
m.$flags&2&&A.b(m)
c7=m.length
if(!(h>=0&&h<c7))return A.a(m,h)
m[h]=c2
c2=h+1
c8=B.a.j(c5*c3,8)
if(!(c2<c7))return A.a(m,c2)
m[c2]=c8
c8=h+2
c2=B.a.j(e*c3,8)
if(!(c8<c7))return A.a(m,c8)
m[c8]=c2;++g
n===$&&A.c(d3)
h+=n}}break
default:throw A.f(A.l("Unsupported color mode"))}}}
A.jK.prototype={}
A.c6.prototype={}
A.hL.prototype={
mQ(a){var s,r,q,p,o,n=this,m=A.v(t.L.a(a),!0,null,0)
n.c=m
s=m.d7(2,0)
if(J.d(s.a,s.d)!==255||J.d(s.a,s.d+1)!==216)return!1
if(n.cb()!==216)return!1
r=n.cb()
q=!1
p=!1
for(;;){if(r!==217){m=n.c
m=m.d<m.c}else m=!1
if(!m)break
o=n.c.n()
if(o<2)break
m=n.c
m.d=m.d+(o-2)
switch(r){case 192:case 193:case 194:q=!0
break
case 218:if(q)return!0
p=!0
break}r=n.cb()}return q&&p},
bV(a){var s,r,q,p,o,n,m=this
m.c=A.v(t.L.a(a),!0,null,0)
m.kV()
if(m.Q.length!==1)throw A.f(A.l("Only single frame JPEGs supported"))
s=m.f
s.toString
if(m.cy!=null)return
if(!m.ay){m.ay=!0
s.mv(m.b===8)}for(r=s.z,q=s.y,p=m.ax,o=0;o<r.length;++o){n=q.l(0,r[o])
B.c.C(p,A.o0(n.a,s.f,n.b,s.r,m.iW(s,n)))}},
gdH(){var s,r=this.f.d
r.toString
s=this.b
return B.a.aa(r+s-1,s)},
kV(){var s,r,q,p,o,n,m=this
m.ch=0
if(m.cb()!==216)throw A.f(A.l("Start Of Image marker not found."))
s=m.cb()
for(;;){if(s!==217){r=m.c
r===$&&A.c("input")
r=r.d<r.c}else r=!1
if(!r)break
A:{if(s>=208&&s<=215||s===1){s=m.cb()
break A}r=m.c
r===$&&A.c("input")
q=r.n()
if(q<2)A.a3(A.l("Invalid Block"))
r=m.c
p=r.aH(q-2)
o=r.d=r.d+(p.c-p.d)
switch(s){case 224:case 225:case 226:case 227:case 228:case 229:case 230:case 231:case 232:case 233:case 234:case 235:case 236:case 237:case 238:case 239:case 254:m.kW(s,p)
break
case 219:m.kZ(p)
break
case 192:case 193:case 194:m.l0(s,p)
break
case 195:case 197:case 198:case 199:case 200:case 201:case 202:case 203:case 205:case 206:case 207:throw A.f(A.l("Unhandled frame type "+B.a.dE(s,16)))
case 196:m.kY(p)
break
case 221:m.r=p.n()
break
case 218:m.lf(p)
break
case 255:if(J.d(r.a,o)!==255)--m.c.d
break
default:n=!1
if(J.d(r.a,o+-3)===255){r=m.c
if(J.d(r.a,r.d+-2)>=192){r=m.c
r=J.d(r.a,r.d+-2)<=254}else r=n}else r=n
if(r){m.c.d-=3
break}if(s!==0)throw A.f(A.l("Unknown JPEG marker "+B.a.dE(s,16)))
break}s=m.cb()}}},
cb(){var s,r=this,q=r.c
q===$&&A.c("input")
if(q.d>=q.c)return 0
do{do{s=r.c.H()
if(s!==255){q=r.c
q=q.d<q.c}else q=!1}while(q)
q=r.c
if(q.d>=q.c)return s
do{s=r.c.H()
if(s===255){q=r.c
q=q.d<q.c}else q=!1}while(q)
if(s===0){q=r.c
q=q.d<q.c}else q=!1}while(q)
return s},
l7(a){var s
for(s=0;s<12;++s)if(J.d(a.a,a.d++)!==B.kA[s])return
this.x=new A.bH("ICC_PROFILE",B.S,a.Y())},
l_(a){if(a.k()!==1165519206)return
if(a.n()!==0)return
this.y.bV(a)},
kW(a,b){var s,r,q,p,o,n=this,m=b
if(n.cy!=null)s=a===225||a===238
else s=!1
if(s)n.cx=!0
if(a===224){s=m
r=!1
if(J.d(s.a,s.d)===74){s=m
if(J.d(s.a,s.d+1)===70){s=m
if(J.d(s.a,s.d+2)===73){s=m
if(J.d(s.a,s.d+3)===70){s=m
s=J.d(s.a,s.d+4)===0}else s=r}else s=r}else s=r}else s=r
if(s){s=new A.jQ()
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
n.d=s
m.d7(14+3*r*q,14)}}else if(a===225)n.l_(m)
else if(a===226)n.l7(m)
else if(a===238){s=m
r=!1
if(J.d(s.a,s.d)===65){s=m
if(J.d(s.a,s.d+1)===100){s=m
if(J.d(s.a,s.d+2)===111){s=m
if(J.d(s.a,s.d+3)===98){s=m
if(J.d(s.a,s.d+4)===101){s=m
s=J.d(s.a,s.d+5)===0}else s=r}else s=r}else s=r}else s=r}else s=r
if(s){p=new A.jK()
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
n.e=p}}else if(a===254)try{m.mB()}catch(o){}},
kZ(a){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=this.z;q=a.d,p=q<s,p;){p=a.a
a.d=q+1
o=J.d(p,q)
n=B.a.j(o,4)
o&=15
if(o>=4)throw A.f(A.l("Invalid number of quantization tables"))
if(r[o]==null)B.c.i(r,o,new Int16Array(64))
m=r[o]
for(q=n!==0,l=0;l<64;++l){k=q?a.n():J.d(a.a,a.d++)
m.toString
p=$.iZ()
if(!(l<p.length))return A.a(p,l)
p=p[l]
m.$flags&2&&A.b(m)
if(!(p<64))return A.a(m,p)
m[p]=k}}if(p)throw A.f(A.l("Bad length for DQT block"))},
l0(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
if(i.f!=null)throw A.f(A.l("Duplicate JPG frame data found."))
s=A.J(t.p,t.fg)
r=A.j([],t.t)
q=new A.hM(s,r)
q.b=a===194
q.c=b.H()
q.d=b.n()
q.e=b.n()
p=b.H()
for(o=i.z,n=0;n<p;++n){m=J.d(b.a,b.d++)
l=J.d(b.a,b.d++)
k=B.a.j(l,4)
j=J.d(b.a,b.d++)
B.c.C(r,m)
s.i(0,m,new A.c6(k&15,l&15,o,j))}i.lB(q)
i.f=q
B.c.C(i.Q,q)},
lB(a){var s,r,q,p=a.e
p.toString
s=a.d
s.toString
if(p===0||s===0)throw A.f(A.l("Invalid JPEG dimensions "+p+"x"+s))
r=this.a
if(r>0&&p*s>r)throw A.f(A.l("JPEG dimensions "+p+"x"+s+" exceed the maximum of "+r+" pixels"))
p=a.y
s=p.a
if(s===0||s>4)throw A.f(A.l("Unsupported number of JPEG components: "+s))
for(p=new A.aq(p,p.r,p.e,A.m(p).m("aq<2>"));p.E();){s=p.d
r=s.a
q=!0
if(r>=1)if(r<=4){s=s.b
s=s<1||s>4}else s=q
else s=q
if(s)throw A.f(A.l("Invalid JPEG sampling factor"))}},
kY(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.c,r=this.at,q=this.as;p=a.d,p<s;){o=a.a
a.d=p+1
n=J.d(o,p)
m=new Uint8Array(16)
for(l=0,k=0;k<16;++k){p=J.d(a.a,a.d++)
if(!(k<16))return A.a(m,k)
m[k]=p
l+=m[k]}j=a.aH(l)
a.d=a.d+(j.c-j.d)
i=j.Y()
if((n&16)!==0){n-=16
h=q}else h=r
if(h.length<=n)B.c.su(h,n+1)
B.c.i(h,n,this.ks(m,i))}},
lf(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
if(++a0.ch>1000)throw A.f(A.l("Too many JPEG scans"))
s=a1.H()
if(s<1||s>4)throw A.f(A.l("Invalid SOS block"))
r=a0.f
r.toString
q=A.j([],t.ns)
for(p=a0.as,o=a0.at,n=r.y,m=t.hQ,l=0;l<s;++l){k=J.d(a1.a,a1.d++)
j=J.d(a1.a,a1.d++)
if(!n.ac(k))throw A.f(A.l("Invalid Component in SOS block"))
i=n.l(0,k)
i.toString
h=B.a.j(j,4)&15
g=j&15
f=o.length
if(h<f){if(!(h<f))return A.a(o,h)
f=o[h]
f.toString
i.Q=m.a(f)
i.at=A.pB(f)}f=p.length
if(g<f){if(!(g<f))return A.a(p,g)
f=p[g]
f.toString
i.as=m.a(f)
i.ax=A.pB(f)}B.c.C(q,i)}e=a1.H()
d=a1.H()
c=a1.H()
p=B.a.j(c,4)
o=r.b
o.toString
if(o&&a0.b===8&&e>0)return
if(a0.cy!=null)throw A.f(B.d4)
b=!1
if(!a0.ay){a0.ay=!0
o=r.z
if(0>=o.length)return A.a(o,0)
o=n.l(0,o[0])
o.toString
if(a0.CW){m=r.b
m.toString
if(!m){m=q.length
if(m===n.a)if(m<=1)o=o.a===1&&o.b===1
else o=!0
else o=b
b=o}}r.hK(b,a0.b===8)
if(b)a0.ls(r)}o=a0.c
o===$&&A.c("input")
n=a0.r
a=new A.hN(o,r,q,n,e,d,p&15,c&15,new Int16Array(64))
p=r.w
p===$&&A.c("mcusPerLine")
a.f=p
a.r=r.b
if(b)a.sms(a0.gjj())
a.bQ()},
ks(a,b){var s,r,q,p,o,n,m,l,k=A.j([],t.kv),j=16
for(;;){if(!(j>0&&a[j-1]===0))break;--j}s=t.er
B.c.C(k,new A.dU(A.I(2,null,!1,s)))
if(0>=k.length)return A.a(k,0)
r=k[0]
for(q=b.length,p=0,o=0;o<j;){for(n=0;n<a[o];++n){if(0>=k.length)return A.a(k,-1)
r=k.pop()
m=r.b
if(!(p>=0&&p<q))return A.a(b,p)
B.c.i(r.a,m,new A.dk(b[p]))
while(m=r.b,m>0){if(0>=k.length)return A.a(k,-1)
r=k.pop()}r.b=m+1
B.c.C(k,r)
for(;k.length<=o;r=l){m=A.I(2,null,!1,s)
l=new A.dU(m)
B.c.C(k,l)
B.c.i(r.a,r.b,new A.cu(m))}++p}++o
if(o<j){m=A.I(2,null,!1,s)
l=new A.dU(m)
B.c.C(k,l)
B.c.i(r.a,r.b,new A.cu(m))
r=l}}if(0>=k.length)return A.a(k,0)
return k[0].a},
iW(a,b){var s,r,q,p,o,n,m,l,k=b.e
k===$&&A.c("blocksPerLine")
s=b.f
s===$&&A.c("blocksPerColumn")
r=B.a.aa(8,this.b)
q=k*r
p=new Int32Array(64)
o=new Uint8Array(64)
n=A.I(s*r,null,!1,t.nh)
for(m=0;m<s;++m){for(k=m*r,l=0;l<r;++l)B.c.i(n,k+l,new Uint8Array(q))
this.eX(b,m,n,k,o,p)}b.x=new Int16Array(0)
return n},
eX(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c
t.bi.a(a0)
s=B.a.aa(8,this.b)
r=a.x
r===$&&A.c("coefficients")
q=a.r
q===$&&A.c("blocksPerLineForMcu")
p=a.c
o=a.d
if(!(o>=0&&o<4))return A.a(p,o)
o=p[o]
o.toString
p=s===8
n=s===1
q=b*q
m=a0.length
l=r.length
k=0
for(;;){j=a.e
j===$&&A.c("blocksPerLine")
if(!(k<j))break
A:{i=q+k
h=i<<6>>>0
if(n){j=a.y?i:h
if(!(j>=0&&j<l))return A.a(r,j)
g=r[j]
if(!(a1<m))return A.a(a0,a1)
j=a0[a1]
j.toString
f=128+B.b.b3((B.b.b3((5793*B.b.b3((5793*(g*o[0])+512)/1024)+8192)/16384)+8)/16)
if(f<0)e=0
else e=f>255?255:f
j.$flags&2&&A.b(j)
if(!(k<j.length))return A.a(j,k)
j[k]=e
break A}A.w4(o,r,h,a2,a3)
d=k*s
if(p)for(j=d+8,c=0;c<8;++c){e=a1+c
if(!(e<m))return A.a(a0,e)
e=a0[e]
if(e!=null)B.d.ab(e,d,j,a2,c<<3>>>0)}else A.r2(a2,s,a0,a1,d)}++k}},
m1(a){var s,r,q,p=this
t.L.a(a)
p.CW=!0
try{p.bV(a)}catch(s){if(A.br(s) instanceof A.iF)return p.fa(a)
else throw s}r=p.cy
if(r==null)return A.pz(p)
if(p.cx)return p.fa(a)
q=r.d
q===$&&A.c("image")
q.c=p.x
return q},
fa(a){var s
t.L.a(a)
s=A.mM()
s.a=this.a
s.b=this.b
s.bV(a)
return A.pz(s)},
ls(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=B.a.aa(8,c.b),a=c.db
B.c.cT(a)
for(s=a0.z,r=s.length,q=t.h,p=a0.y,o=c.ax,n=t.nh,m=0;m<s.length;s.length===r||(0,A.L)(s),++m){l=p.l(0,s[m])
k=l.a
j=a0.f
i=l.b
h=a0.r
g=l.f
g===$&&A.c("blocksPerColumn")
B.c.C(o,A.o0(k,j,i,h,A.I(g*b,null,!1,n)))
f=i*b
e=A.j(new Array(f),q)
for(k=l.e,d=0;d<f;++d){k===$&&A.c("blocksPerLine")
e[d]=new Uint8Array(k*b)}B.c.C(a,e)}c.cy=A.or(c)},
jk(a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=a5.f
a6.toString
s=B.a.aa(8,a5.b)
for(r=a6.z,q=a5.dx,p=a5.dy,o=a6.y,n=a5.ax,m=a5.db,l=0;l<r.length;++l){k=o.l(0,r[l])
k.toString
if(!(l<n.length))return A.a(n,l)
j=n[l].e
if(!(l<m.length))return A.a(m,l)
i=m[l]
for(h=k.b,g=a7*h,f=0;f<h;++f){e=g+f
d=k.f
d===$&&A.c("blocksPerColumn")
if(e>=d)break
for(d=e*s,c=f*s,b=0;b<s;++b){a=c+b
if(!(a<i.length))return A.a(i,a)
B.c.i(j,d+b,i[a])}a5.eX(k,f,j,d,q,p)}k=k.x
k===$&&A.c("coefficients")
h=a5.fr
g=k.length
if(h.length<g)h=a5.fr=new Int16Array(g)
B.a9.aB(k,0,g,h)}a0=a6.r*s
a1=a7*a0
a2=Math.min(a1+a0,a5.gdH())
if(a1<a2)a5.cy.i0(a1,a2)
for(l=0;l<r.length;++l){a6=o.l(0,r[l])
a6.toString
if(!(l<n.length))return A.a(n,l)
j=n[l].e
a6=a6.b
a3=a7*a6*s
a6=a3+a6*s
q=j.length
a4=a3
for(;;){if(!(a4<a6&&a4<q))break
B.c.i(j,a4,null);++a4}}}}
A.dU.prototype={}
A.iF.prototype={}
A.hM.prototype={
hK(a,b){var s,r,q,p,o,n,m,l,k,j,i=this
for(s=i.y,r=A.m(s).m("Y<1>"),q=new A.Y(s,s.r,s.e,r);q.E();){p=s.l(0,q.d)
i.f=Math.max(i.f,p.a)
i.r=Math.max(i.r,p.b)}q=i.e
q.toString
i.w=B.b.bj(q/8/i.f)
q=i.d
q.toString
i.x=B.b.bj(q/8/i.r)
for(r=new A.Y(s,s.r,s.e,r);r.E();){q=s.l(0,r.d)
q.toString
o=i.e
o.toString
n=q.a
m=B.b.bj(B.b.bj(o/8)*n/i.f)
o=i.d
o.toString
l=q.b
k=B.b.bj(B.b.bj(o/8)*l/i.r)
j=i.w*n
n=i.x
q.e=m
q.f=k
q.r=j
n=q.w=n*l
q.y=b
q.z=a?l:0
o=a?l:n
n=b?1:64
q.x=new Int16Array(j*o*n)}},
mv(a){return this.hK(!1,a)}}
A.jQ.prototype={}
A.hN.prototype={
bQ(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0="blocksPerLine",a1="blocksPerColumn",a2="mcusPerLine",a3="mcusPerColumn",a4=a.y,a5=a4.length,a6=a.r
a6.toString
if(a6)if(a.Q===0)s=a.at===0?a.gjo():a.gjq()
else s=a.at===0?a.gjd():a.gjf()
else s=a.gjl()
a6=a5===1
if(a6){if(0>=a5)return A.a(a4,0)
r=a4[0]
q=r.e
q===$&&A.c(a0)
r=r.f
r===$&&A.c(a1)
p=q*r}else{r=a.f
r===$&&A.c(a2)
q=a.b.x
q===$&&A.c(a3)
p=r*q}r=a.z
if(r==null||r===0)a.z=p
for(r=a.a,q=t.E,o=0;o<p;){for(n=0;n<a5;++n){if(!(n<a4.length))return A.a(a4,n)
a4[n].ay=0}a.db=0
if(a6){if(0>=a4.length)return A.a(a4,0)
m=a4[0]
l=0
for(;;){k=a.z
k.toString
if(!(l<k))break
q.a(s)
k=m.e
k===$&&A.c(a0)
j=B.a.aa(o,k)
i=B.a.a5(o,k)
k=m.z
k=k>0?B.a.a5(j,k):j
h=m.r
h===$&&A.c("blocksPerLineForMcu")
a.fc(m,s,k*h+i);++o
if(a.ay!=null&&B.a.a5(o,m.e)===0)a.eg(B.a.aa(o,m.e));++l}}else{l=0
for(;;){k=a.z
k.toString
if(!(l<k))break
for(n=0;n<a5;++n){if(!(n<a4.length))return A.a(a4,n)
m=a4[n]
g=m.a
f=m.b
for(e=0;e<f;++e)for(d=0;d<g;++d)a.jv(m,s,o,e,d)}++o
if(a.ay!=null){k=a.f
k===$&&A.c(a2)
k=B.a.a5(o,k)===0}else k=!1
if(k){k=a.f
k===$&&A.c(a2)
a.eg(B.a.aa(o,k))}++l}}a.cx=a.CW=0
k=a.cy=!1
if(o>=p)break
c=J.d(r.a,r.d)
b=J.d(r.a,r.d+1)
if(c===255)if(b>=208?b<=215:k)r.d+=2
else break}if(a.ay!=null){if(a6){if(0>=a4.length)return A.a(a4,0)
a4=a4[0].f
a4===$&&A.c(a1)}else{a4=a.b.x
a4===$&&A.c(a3)}a.eg(a4)}},
eg(a){var s,r
while(s=this.ch,s<a){r=this.ay
r.toString
this.ch=s+1
r.$1(s)}},
dZ(){var s,r,q=this,p=q.a,o=p.c
for(;;){if(!(q.cx<=24&&!q.cy))break
s=p.d
if(s>=o){q.cy=!0
break}r=J.d(p.a,s)
if(r===255){s=p.d
if(o-s<2||J.d(p.a,s+1)!==0){q.cy=!0
break}p.d+=2}else ++p.d
q.CW=(q.CW<<8|r)>>>0
q.cx+=8}},
cr(){var s=this,r=s.cx
if(r===0){s.dZ()
r=s.cx
if(r===0)return null}--r
s.cx=r
return B.a.a0(s.CW,r)&1},
cK(a,b){var s,r,q,p,o,n,m=this
t.hQ.a(a)
if(m.cx<9)m.dZ()
s=m.cx
if(s>=9){r=B.a.a0(m.CW,s-9)&511
if(!(r<b.length))return A.a(b,r)
q=b[r]
if(q!==0){m.cx=s-(q>>>8)
return q&255}}for(p=a;;){o=m.cr()
if(o==null)return null
if(o>>>0!==o||o>=2)return A.a(p,o)
n=p[o]
if(n instanceof A.dk)return n.a
if(!(n instanceof A.cu))return null
p=n.a}},
ed(a){var s=this,r=s.cx
if(r<a){s.dZ()
r=s.cx
if(r<a){s.cx=0
return null}}r-=a
s.cx=r
return(B.a.a0(s.CW,r)&B.a.S(1,a)-1)>>>0},
cO(a){var s
if(a==null)return 0
if(a===1)return this.cr()===1?1:-1
s=this.ed(a)
if(s==null)return 0
if(s>=B.a.U(1,a-1))return s
return s+B.a.S(-1,a)+1},
jm(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=a.Q
j===$&&A.c("huffmanTableDC")
s=a.at
s===$&&A.c("huffmanLookupDC")
r=k.cK(j,s)
q=r===0?0:k.cO(r)
j=a.ay
j===$&&A.c("pred")
j+=q
a.ay=j
b.$flags&2&&A.b(b)
s=b.length
if(!(c<s))return A.a(b,c)
b[c]=j
for(p=1;p<64;){j=a.as
j===$&&A.c("huffmanTableAC")
o=a.ax
o===$&&A.c("huffmanLookupAC")
n=k.cK(j,o)
if(n==null)break
m=n&15
l=n>>>4
if(m===0){if(l<15)break
p+=16
continue}p+=l
m=k.cO(m)
j=$.iZ()
if(!(p>=0&&p<j.length))return A.a(j,p)
j=c+j[p]
b.$flags&2&&A.b(b)
if(!(j<s))return A.a(b,j)
b[j]=m;++p}},
jp(a,b,c){var s,r,q,p=a.Q
p===$&&A.c("huffmanTableDC")
s=a.at
s===$&&A.c("huffmanLookupDC")
r=this.cK(p,s)
q=r===0?0:B.a.S(this.cO(r),this.ax)
p=a.ay
p===$&&A.c("pred")
p+=q
a.ay=p
b.$flags&2&&A.b(b)
if(!(c<b.length))return A.a(b,c)
b[c]=p},
jr(a,b,c){var s,r
if(!(c<b.length))return A.a(b,c)
s=b[c]
r=this.cr()
r.toString
r=B.a.S(r,this.ax)
b.$flags&2&&A.b(b)
b[c]=(s|r)>>>0},
je(a,b,c){var s,r,q,p,o,n,m,l=this,k=l.db
if(k>0){l.db=k-1
return}s=l.Q
r=l.as
for(k=l.ax;s<=r;){q=a.as
q===$&&A.c("huffmanTableAC")
p=a.ax
p===$&&A.c("huffmanLookupAC")
p=l.cK(q,p)
p.toString
o=p&15
n=p>>>4
if(o===0){if(n<15){k=l.ed(n)
k.toString
l.db=k+B.a.S(1,n)-1
break}s+=16
continue}s+=n
q=$.iZ()
if(!(s>=0&&s<q.length))return A.a(q,s)
q=c+q[s]
p=l.cO(o)
m=B.a.S(1,k)
b.$flags&2&&A.b(b)
if(!(q<b.length))return A.a(b,q)
b[q]=p*m;++s}},
jg(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.Q,i=k.as
A:for(s=b.length,r=k.ax,q=0;j<=i;){p=$.iZ()
if(!(j>=0&&j<p.length))return A.a(p,j)
o=c+p[j]
p=k.dx
switch(p){case 0:p=a.as
p===$&&A.c("huffmanTableAC")
n=a.ax
n===$&&A.c("huffmanLookupAC")
m=k.cK(p,n)
if(m==null)throw A.f(A.l("Invalid progressive encoding"))
l=m&15
q=m>>>4
if(l===0)if(q<15){p=k.ed(q)
p.toString
k.db=p+B.a.S(1,q)
k.dx=4}else{k.dx=1
q=16}else{if(l!==1)throw A.f(A.l("invalid ACn encoding"))
k.dy=k.cO(l)
k.dx=q!==0?2:3}continue A
case 1:case 2:if(!(o<s))return A.a(b,o)
n=b[o]
if(n!==0){p=k.cr()
p.toString
p=B.a.S(p,r)
b.$flags&2&&A.b(b)
b[o]=n+p}else{--q
if(q===0)k.dx=p===2?3:0}break
case 3:if(!(o<s))return A.a(b,o)
p=b[o]
if(p!==0){n=k.cr()
n.toString
n=B.a.S(n,r)
b.$flags&2&&A.b(b)
b[o]=p+n}else{p=k.dy
p===$&&A.c("successiveACNextValue")
p=B.a.S(p,r)
b.$flags&2&&A.b(b)
b[o]=p
k.dx=0}break
case 4:if(!(o<s))return A.a(b,o)
p=b[o]
if(p!==0){n=k.cr()
n.toString
n=B.a.S(n,r)
b.$flags&2&&A.b(b)
b[o]=p+n}break}++j}if(k.dx===4)if(--k.db===0)k.dx=0},
jv(a,b,c,d,e){var s,r,q,p,o="blocksPerLineForMcu"
t.E.a(b)
s=this.f
s===$&&A.c("mcusPerLine")
r=B.a.aa(c,s)*a.b+d
q=B.a.a5(c,s)*a.a+e
s=a.w
s===$&&A.c("blocksPerColumnForMcu")
if(r<s){s=a.r
s===$&&A.c(o)
s=q>=s}else s=!0
if(s)return
s=a.z
s=s>0?B.a.a5(r,s):r
p=a.r
p===$&&A.c(o)
this.fc(a,b,s*p+q)},
fc(a,b,c){var s,r,q
t.E.a(b)
s=a.x
s===$&&A.c("coefficients")
if(!a.y){b.$3(a,s,c<<6>>>0)
return}r=this.fr
if(!(c>=0&&c<s.length))return A.a(s,c)
q=s[c]
r.$flags&2&&A.b(r)
r[0]=q
b.$3(a,r,0)
q=r[0]
s.$flags&2&&A.b(s)
s[c]=q},
sms(a){this.ay=t.bZ.a(a)}}
A.jM.prototype={
aT(a){var s,r=a.length,q=!0
if(r>=2){if(0>=r)return A.a(a,0)
if(a[0]===255){if(1>=r)return A.a(a,1)
r=a[1]!==216}else r=q}else r=q
if(r)return!1
try{r=A.mM().mQ(a)
return r}catch(s){return!1}},
bg(a,b){return A.P(new A.jN(this,a,b),t.H)},
cz(a){return this.bg(a,null)}}
A.jN.prototype={
$0(){var s=A.mM()
s.a=this.a.a
s.b=1
return s.m1(this.b)},
$S:1}
A.jL.prototype={
a7(){return"JpegChroma."+this.b}}
A.jO.prototype={
ia(a){a=B.a.h(B.a.F(a,1,100))
if(this.Q===a)return
this.kl(a<50?B.b.b3(5000/a):B.a.b3(200-a*2))
this.Q=a},
bR(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
A.ci(a1)
s=A.a0(!0,8192)
a0.bM(s,216)
a0.bM(s,224)
s.a3(16)
s.p(74)
s.p(70)
s.p(73)
s.p(70)
s.p(0)
s.p(1)
s.p(1)
s.p(0)
s.a3(1)
s.a3(1)
s.p(0)
s.p(0)
a0.lI(s,a1.gbh())
r=a1.c
if(r!=null){a0.bM(s,226)
q=r.hv()
p=A.j([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
s.a3(14+q.length)
s.a2(p)
s.a2(q)}a0.lG(s)
r=a1.gN()
o=a1.gJ()
a0.bM(s,192)
s.a3(17)
s.p(8)
s.a3(o)
s.a3(r)
s.p(3)
s.p(1)
s.p(17)
s.p(0)
s.p(2)
s.p(17)
s.p(1)
s.p(3)
s.p(17)
s.p(1)
a0.lF(s)
a0.bM(s,218)
s.a3(12)
s.p(3)
s.p(1)
s.p(0)
s.p(2)
s.p(17)
s.p(3)
s.p(17)
s.p(0)
s.p(63)
s.p(0)
a0.at=a0.as=0
n=a1.gN()
m=a1.gJ()
l=a1.f
if(l==null)l=B.d5
k=new Float32Array(64)
j=new Float32Array(64)
i=new Float32Array(64)
for(r=a0.c,o=a0.d,h=0,g=0,f=0,e=0;e<m;e+=8)for(d=0;d<n;d+=8){a0.j1(a1,d,e,n,m,k,j,i,l)
c=a0.e
c===$&&A.c("_ydcHuffman")
b=a0.r
b===$&&A.c("_yacHuffman")
h=a0.eb(s,k,r,h,c,b)
b=a0.f
b===$&&A.c("_uvdcHuffman")
c=a0.w
c===$&&A.c("_uvacHuffman")
g=a0.eb(s,j,o,g,b,c)
f=a0.eb(s,i,o,f,a0.f,a0.w)}a=8-a0.at
a0.bL(s,B.a.U(1,a)-1,a)
a0.bM(s,217)
return J.C(B.d.gq(s.c),0,s.a)},
j1(a,b,c,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d
if(a.gL()===B.e&&!a.gaw()&&a.gad()>=3){s=a.a
this.j2(J.G(s.gq(s)),a.a.gaz(),a.gad(),b,c,a0,a1,a2,a3,a4,a5)
return}for(s=this.z,r=c+1,q=null,p=0;p<64;++p){o=p>>>3
n=c+o
m=b+(p&7)
if(n>=a1)n-=r+o-a1
if(m>=a0)m-=m-a0+1
l=a.a
q=l==null?null:l.P(m,n,q)
if(q==null)q=new A.E()
k=q.gL()!==B.e?q.aS(B.e):q
j=B.b.h(k.gt())
i=B.b.h(k.gA())
h=B.b.h(k.gB())
if(k.gu(k)>3){g=k.ga1()
f=1-g
j=B.a.F(B.b.av(j*g+a5.gt()*f),0,255)
i=B.a.F(B.b.av(i*g+a5.gA()*f),0,255)
h=B.a.F(B.b.av(h*g+a5.gB()*f),0,255)}if(!(j>=0&&j<2048))return A.a(s,j)
l=s[j]
e=i+256
if(!(e>=0&&e<2048))return A.a(s,e)
e=s[e]
d=h+512
if(!(d>=0&&d<2048))return A.a(s,d)
d=B.a.j(l+e+s[d],16)
a2.$flags&2&&A.b(a2)
if(!(p<64))return A.a(a2,p)
a2[p]=d-128
d=j+768
if(!(d<2048))return A.a(s,d)
d=s[d]
e=i+1024
if(!(e>=0&&e<2048))return A.a(s,e)
e=s[e]
l=h+1280
if(!(l>=0&&l<2048))return A.a(s,l)
l=B.a.j(d+e+s[l],16)
a3.$flags&2&&A.b(a3)
if(!(p<64))return A.a(a3,p)
a3[p]=l-128
l=j+1280
if(!(l<2048))return A.a(s,l)
l=s[l]
e=i+1536
if(!(e>=0&&e<2048))return A.a(s,e)
e=s[e]
d=h+1792
if(!(d>=0&&d<2048))return A.a(s,d)
d=B.a.j(l+e+s[d],16)
a4.$flags&2&&A.b(a4)
if(!(p<64))return A.a(a4,p)
a4[p]=d-128}},
j2(a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this.z,a1=b4.gt(),a2=b4.gA(),a3=b4.gB()
for(s=a6>3,r=a4.length,q=a9-1,p=b0-1,o=0,n=0;o<8;++o){m=a8+o
l=(m<b0?m:p)*a5
for(k=0;k<8;++k,++n){j=a7+k
i=l+(j<a9?j:q)*a6
if(!(i>=0&&i<r))return A.a(a4,i)
h=a4[i]
g=i+1
if(!(g<r))return A.a(a4,g)
f=a4[g]
g=i+2
if(!(g<r))return A.a(a4,g)
e=a4[g]
if(s){g=i+3
if(!(g<r))return A.a(a4,g)
d=a4[g]/255
c=1-d
h=B.a.F(B.b.av(h*d+a1*c),0,255)
f=B.a.F(B.b.av(f*d+a2*c),0,255)
e=B.a.F(B.b.av(e*d+a3*c),0,255)}if(!(h>=0&&h<2048))return A.a(a0,h)
g=a0[h]
b=f+256
if(!(b>=0&&b<2048))return A.a(a0,b)
b=a0[b]
a=e+512
if(!(a>=0&&a<2048))return A.a(a0,a)
a=B.a.j(g+b+a0[a],16)
b1.$flags&2&&A.b(b1)
if(!(n>=0&&n<64))return A.a(b1,n)
b1[n]=a-128
a=h+768
if(!(a<2048))return A.a(a0,a)
a=a0[a]
b=f+1024
if(!(b>=0&&b<2048))return A.a(a0,b)
b=a0[b]
g=e+1280
if(!(g>=0&&g<2048))return A.a(a0,g)
g=B.a.j(a+b+a0[g],16)
b2.$flags&2&&A.b(b2)
if(!(n<64))return A.a(b2,n)
b2[n]=g-128
g=h+1280
if(!(g<2048))return A.a(a0,g)
g=a0[g]
b=f+1536
if(!(b>=0&&b<2048))return A.a(a0,b)
b=a0[b]
a=e+1792
if(!(a>=0&&a<2048))return A.a(a0,a)
a=B.a.j(g+b+a0[a],16)
b3.$flags&2&&A.b(b3)
if(!(n<64))return A.a(b3,n)
b3[n]=a-128}}},
bM(a,b){a.p(255)
a.p(b&255)},
kl(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.a,r=s.$flags|0,q=0;q<64;++q){p=B.b.b3((B.iY[q]*a+50)/100)
if(p<1)p=1
else if(p>255)p=255
o=B.a5[q]
r&2&&A.b(s)
if(!(o<64))return A.a(s,o)
s[o]=p}for(r=b.b,o=r.$flags|0,n=0;n<64;++n){m=B.b.b3((B.eT[n]*a+50)/100)
if(m<1)m=1
else if(m>255)m=255
l=B.a5[n]
o&2&&A.b(r)
if(!(l<64))return A.a(r,l)
r[l]=m}for(o=b.c,l=o.$flags|0,k=b.d,j=k.$flags|0,i=0,h=0;h<8;++h)for(g=0;g<8;++g){if(!(i>=0&&i<64))return A.a(B.a5,i)
f=B.a5[i]
if(!(f<64))return A.a(s,f)
e=s[f]
d=B.bD[h]
c=B.bD[g]
l&2&&A.b(o)
o[i]=1/(e*d*c*8)
f=r[f]
j&2&&A.b(k)
k[i]=1/(f*d*c*8);++i}},
dc(a,b){var s,r,q,p,o,n,m,l=t.L
l.a(a)
l.a(b)
l=new Int32Array(256)
s=new Uint8Array(256)
for(r=b.length,q=0,p=0,o=1;o<=16;++o){for(n=1;n<=a[o];++n){if(!(p>=0&&p<r))return A.a(b,p)
m=b[p]
if(!(m<256))return A.a(l,m)
l[m]=q
s[m]=o;++p;++q}q*=2}return new A.lG(l,s)},
km(){var s,r,q
for(s=this.z,r=s.$flags|0,q=0;q<256;++q){r&2&&A.b(s)
s[q]=19595*q
s[q+256]=38470*q
s[q+512]=7471*q+32768
s[q+768]=-11059*q
s[q+1024]=-21709*q
s[q+1280]=32768*q+8421375
s[q+1536]=-27439*q
s[q+1792]=-5329*q}},
jV(d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5
for(s=d6.$flags|0,r=0,q=0;q<8;++q){if(!(r<64))return A.a(d6,r)
p=d6[r]
o=r+1
if(!(o<64))return A.a(d6,o)
n=d6[o]
m=r+2
if(!(m<64))return A.a(d6,m)
l=d6[m]
k=r+3
if(!(k<64))return A.a(d6,k)
j=d6[k]
i=r+4
if(!(i<64))return A.a(d6,i)
h=d6[i]
g=r+5
if(!(g<64))return A.a(d6,g)
f=d6[g]
e=r+6
if(!(e<64))return A.a(d6,e)
d=d6[e]
c=r+7
if(!(c<64))return A.a(d6,c)
b=d6[c]
a=p+b
a0=p-b
a1=n+d
a2=n-d
a3=l+f
a4=l-f
a5=j+h
a6=a+a5
a7=a-a5
a8=a1+a3
s&2&&A.b(d6)
if(!(r<64))return A.a(d6,r)
d6[r]=a6+a8
if(!(i<64))return A.a(d6,i)
d6[i]=a6-a8
a9=(a1-a3+a7)*0.707106781
if(!(m<64))return A.a(d6,m)
d6[m]=a7+a9
if(!(e<64))return A.a(d6,e)
d6[e]=a7-a9
a6=j-h+a4
b0=a2+a0
b1=(a6-b0)*0.382683433
b2=0.5411961*a6+b1
b3=1.306562965*b0+b1
b4=(a4+a2)*0.707106781
b5=a0+b4
b6=a0-b4
if(!(g<64))return A.a(d6,g)
d6[g]=b6+b2
if(!(k<64))return A.a(d6,k)
d6[k]=b6-b2
if(!(o<64))return A.a(d6,o)
d6[o]=b5+b3
if(!(c<64))return A.a(d6,c)
d6[c]=b5-b3
r+=8}for(r=0,q=0;q<8;++q){if(!(r<64))return A.a(d6,r)
p=d6[r]
o=r+8
if(!(o<64))return A.a(d6,o)
n=d6[o]
m=r+16
if(!(m<64))return A.a(d6,m)
l=d6[m]
k=r+24
if(!(k<64))return A.a(d6,k)
j=d6[k]
i=r+32
if(!(i<64))return A.a(d6,i)
h=d6[i]
g=r+40
if(!(g<64))return A.a(d6,g)
f=d6[g]
e=r+48
if(!(e<64))return A.a(d6,e)
d=d6[e]
c=r+56
if(!(c<64))return A.a(d6,c)
b=d6[c]
b7=p+b
b8=p-b
b9=n+d
c0=n-d
c1=l+f
c2=l-f
c3=j+h
c4=b7+c3
c5=b7-c3
c6=b9+c1
s&2&&A.b(d6)
if(!(r<64))return A.a(d6,r)
d6[r]=c4+c6
if(!(i<64))return A.a(d6,i)
d6[i]=c4-c6
c7=(b9-c1+c5)*0.707106781
if(!(m<64))return A.a(d6,m)
d6[m]=c5+c7
if(!(e<64))return A.a(d6,e)
d6[e]=c5-c7
c4=j-h+c2
c8=c0+b8
c9=(c4-c8)*0.382683433
d0=0.5411961*c4+c9
d1=1.306562965*c8+c9
d2=(c2+c0)*0.707106781
d3=b8+d2
d4=b8-d2
if(!(g<64))return A.a(d6,g)
d6[g]=d4+d0
if(!(k<64))return A.a(d6,k)
d6[k]=d4-d0
if(!(o<64))return A.a(d6,o)
d6[o]=d3+d1
if(!(c<64))return A.a(d6,c)
d6[c]=d3-d1;++r}for(s=this.x,q=0;q<64;++q){d5=d6[q]*d7[q]
o=d5>0?B.b.h(d5+0.5):B.b.h(d5-0.5)
s.$flags&2&&A.b(s)
s[q]=o}return s},
lI(a,b){var s,r
if(b.gd0(0))return
s=A.a0(!1,8192)
b.aX(s)
r=J.C(B.d.gq(s.c),0,s.a)
this.bM(a,225)
a.a3(r.length+8)
a.K(1165519206)
a.a3(0)
a.a2(r)},
lG(a){var s,r,q
this.bM(a,219)
a.a3(132)
a.p(0)
for(s=this.a,r=0;r<64;++r)a.p(s[r])
a.p(1)
for(s=this.b,q=0;q<64;++q)a.p(s[q])},
lF(a){var s,r,q,p,o,n,m,l
this.bM(a,196)
a.a3(418)
a.p(0)
for(s=0;s<16;){++s
a.p(B.ck[s])}for(r=0;r<=11;++r)a.p(B.ak[r])
a.p(16)
for(q=0;q<16;){++q
a.p(B.bu[q])}for(p=0;p<=161;++p)a.p(B.bF[p])
a.p(1)
for(o=0;o<16;){++o
a.p(B.bS[o])}for(n=0;n<=11;++n)a.p(B.ak[n])
a.p(17)
for(m=0;m<16;){++m
a.p(B.bK[m])}for(l=0;l<=161;++l)a.p(B.c1[l])},
eb(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.jV(b,a0),c=e.y
for(s=c.$flags|0,r=0;r<64;++r){q=B.a5[r]
p=d[r]
s&2&&A.b(c)
if(!(q<64))return A.a(c,q)
c[q]=p}s=c[0]
o=s-a1
if(o===0)e.bL(a,a2.a[0],a2.b[0])
else{n=B.a.geh(o<0?-o:o)
q=a2.a
if(!(n>=0&&n<256))return A.a(q,n)
e.bL(a,q[n],a2.b[n])
e.bL(a,A.r3(o,n),n)}m=63
for(;;){if(!(m>0&&c[m]===0))break;--m}if(m===0){e.bL(a,a3.a[0],a3.b[0])
return s}for(q=a3.a,p=a3.b,l=1;l<=m;){k=l
for(;;){if(!(k>=0&&k<64))return A.a(c,k)
if(!(c[k]===0&&k<=m))break;++k}j=k-l
if(j>=16){i=B.a.j(j,4)
for(h=1;h<=i;++h)e.bL(a,q[240],p[240])
j&=15}g=c[k]
n=B.a.geh(g<0?-g:g)
f=(j<<4>>>0)+n
if(!(f>=0&&f<256))return A.a(q,f)
e.bL(a,q[f],p[f])
e.bL(a,g>0?g:g+B.a.U(1,n)-1,n)
l=k+1}if(m!==63)e.bL(a,q[0],p[0])
return s},
bL(a,b,c){var s,r,q=this
q.as=(B.a.U(q.as,c)|b)>>>0
q.at+=c
while(s=q.at,s>=8){s-=8
q.at=s
r=B.a.a0(q.as,s)&255
a.p(r)
if(r===255)a.p(0)}q.as=(q.as&B.a.U(1,s)-1)>>>0}}
A.lG.prototype={
gu(a){return this.b}}
A.kb.prototype={}
A.dD.prototype={
a7(){return"PngDisposeMode."+this.b}}
A.f8.prototype={
a7(){return"PngBlendMode."+this.b}}
A.f9.prototype={}
A.hE.prototype={}
A.ca.prototype={
a7(){return"PngFilterType."+this.b}}
A.i0.prototype={
sN(a){this.a=A.n(a)},
sJ(a){this.b=A.n(a)},
sR(a){this.w=t.gy.a(a)},
smN(a){this.x=t.T.a(a)},
$iM:1}
A.hF.prototype={}
A.k7.prototype={
aT(a){var s
if(a.length<8)return!1
for(s=0;s<8;++s)if(a[s]!==B.c8[s])return!1
return!0},
aK(a){return A.P(new A.ka(this,a),t._)},
kJ(b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=null,b7=A.v(b8,!0,b6,0)
b5.e=b7
s=b7.af(8)
for(r=0;r<8;++r)if(J.d(s.a,s.d+r)!==B.c8[r])return b6
for(b7=b5.a,q=b7.cy,p=t.t,o=b7.db,n=t.L,m=b5.b,l=b7.ax;;){k=b5.e
j=k.d-k.b
i=k.k()
h=b5.e.au(4)
switch(h){case"tEXt":k=b5.e
g=k.aH(i)
k.d=k.d+(g.c-g.d)
f=g.Y()
e=f.length
for(r=0;r<e;++r)if(f[r]===0){k=r+1
l.i(0,B.b8.cz(new Uint8Array(f.subarray(0,A.iO(0,r,e)))),B.b8.cz(new Uint8Array(f.subarray(k,A.iO(k,b6,e)))))
break}b5.e.d+=4
break
case"pHYs":k=b5.e
g=k.aH(i)
k.d=k.d+(g.c-g.d)
d=A.w(g,b6,0)
d.k()
d.k()
J.d(d.a,d.d++)
b5.e.d+=4
break
case"IHDR":k=b5.e
g=k.aH(i)
k.d=k.d+(g.c-g.d)
c=A.w(g,b6,0)
b=c.Y()
b7.a=c.k()
k=c.k()
b7.b=k
A.ax(b7.a,k,m,!1)
b7.c=J.d(c.a,c.d++)
b7.d=J.d(c.a,c.d++)
J.d(c.a,c.d++)
b7.f=J.d(c.a,c.d++)
b7.r=J.d(c.a,c.d++)
k=b7.d
if(!(k===0||k===2||k===3||k===4||k===6))return b6
if(b7.f!==0)return b6
switch(k){case 0:if(!B.c.bP(A.j([1,2,4,8,16],p),b7.c))return b6
break
case 2:if(!B.c.bP(A.j([8,16],p),b7.c))return b6
break
case 3:if(!B.c.bP(A.j([1,2,4,8],p),b7.c))return b6
break
case 4:if(!B.c.bP(A.j([8,16],p),b7.c))return b6
break
case 6:if(!B.c.bP(A.j([8,16],p),b7.c))return b6
break}if(b5.e.k()!==A.bB(n.a(b),A.bB(new A.ah(h),0)))throw A.f(A.l("Invalid "+h+" checksum"))
break
case"PLTE":k=b5.e
g=k.aH(i)
k.d=k.d+(g.c-g.d)
b7.sR(g.Y())
if(b5.e.k()!==A.bB(n.a(n.a(b7.w)),A.bB(new A.ah(h),0)))throw A.f(A.l("Invalid "+h+" checksum"))
break
case"tRNS":k=b5.e
g=k.aH(i)
k.d=k.d+(g.c-g.d)
b7.smN(g.Y())
a=b5.e.k()
k=b7.x
k.toString
if(a!==A.bB(n.a(k),A.bB(new A.ah(h),0)))throw A.f(A.l("Invalid "+h+" checksum"))
break
case"IEND":b5.e.d+=4
break
case"gAMA":if(i!==4)throw A.f(A.l("Invalid gAMA chunk"))
b5.e.k()
b5.e.d+=4
break
case"IDAT":B.c.C(o,j)
k=b5.e
k.d=(k.d+=i)+4
break
case"acTL":b7.CW=b5.e.k()
b5.e.k()
b5.e.d+=4
break
case"fcTL":b5.e.k()
a0=b5.e.k()
a1=b5.e.k()
a2=b5.e.k()
a3=b5.e.k()
a4=b5.e.n()
a5=b5.e.n()
k=b5.e
a6=J.d(k.a,k.d++)
k=b5.e
a7=J.d(k.a,k.d++)
if(!(a6>=0&&a6<3))return A.a(B.bt,a6)
k=B.bt[a6]
if(!(a7>=0&&a7<2))return A.a(B.bT,a7)
a8=B.bT[a7]
B.c.C(q,new A.hE(A.j([],p),a0,a1,a2,a3,a4,a5,k,a8))
b5.e.d+=4
break
case"fdAT":b5.e.k()
B.c.C(B.c.gem(q).y,j)
k=b5.e
k.d=(k.d+=i-4)+4
break
case"bKGD":k=b7.d
if(k===3){k=b5.e
a9=J.d(k.a,k.d++);--i
b0=a9*3
k=b7.w
a8=k.length
if(!(b0>=0&&b0<a8))return A.a(k,b0)
b1=k[b0]
b2=b0+1
if(!(b2<a8))return A.a(k,b2)
b3=k[b2]
b2=b0+2
if(!(b2<a8))return A.a(k,b2)
b4=k[b2]
k=b7.x
if(k!=null){k=B.d.bP(k,a9)?0:255
a8=new Uint8Array(4)
a8[0]=b1
a8[1]=b3
a8[2]=b4
a8[3]=k
b7.z=new A.cn(a8)}else{k=new Uint8Array(3)
k[0]=b1
k[1]=b3
k[2]=b4
b7.z=new A.h5(k)}}else if(k===0||k===4){b5.e.n()
i-=2}else if(k===2||k===6){k=b5.e
k.n()
k.n()
k.n()
i-=24}if(i>0)b5.e.d+=i
b5.e.d+=4
break
case"iCCP":b7.Q=b5.e.d3()
k=b5.e
J.d(k.a,k.d++)
k=b7.Q
a8=b5.e
g=a8.aH(i-(k.length+2))
a8.d=a8.d+(g.c-g.d)
b7.at=g.Y()
b5.e.d+=4
break
case"cICP":k=b5.e
a8=k.d
if(i===4){b2=k.a
k.d=a8+1
J.d(b2,a8)
a8=b5.e
J.d(a8.a,a8.d++)
a8=b5.e
J.d(a8.a,a8.d++)
a8=b5.e
J.d(a8.a,a8.d++)}else k.d=a8+i
b5.e.d+=4
break
default:k=b5.e
k.d=(k.d+=i)+4
break}if(h==="IEND")break
k=b5.e
if(k.d>=k.c)return b6}return b7},
an(a){return A.P(new A.k8(this,a),t.H)},
kI(c4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=this,b8=null,b9=b7.a,c0=b9.a,c1=b9.b,c2=b9.cy,c3=c2.length
if(c3===0||c4===0){m=A.j([],t.h)
c2=b9.db
l=c2.length
for(c3=t.L,k=0,j=0;j<l;++j){i=b7.e
i===$&&A.c("_input")
if(!(j<c2.length))return A.a(c2,j)
i.d=c2[j]
h=i.k()
g=b7.e.au(4)
i=b7.e
f=i.aH(h)
i.d=i.d+(f.c-f.d)
e=f.Y()
k+=e.length
B.c.C(m,e)
if(b7.e.k()!==A.bB(c3.a(e),A.bB(new A.ah(g),0)))throw A.f(A.l("Invalid "+g+" checksum"))}d=new Uint8Array(k)
for(c2=m.length,c=0,b=0;b<m.length;m.length===c2||(0,A.L)(m),++b){e=m[b]
B.d.dI(d,c,e)
c+=e.length}}else{if(c4>=c3)throw A.f(A.l("Invalid Frame Number: "+c4))
if(!(c4<c3))return A.a(c2,c4)
a=c2[c4]
c0=a.b
c1=a.c
A.ax(c0,c1,b7.b,!1)
m=A.j([],t.h)
for(c2=a.y,k=0,j=0;j<c2.length;++j){c3=b7.e
c3===$&&A.c("_input")
c3.d=c2[j]
h=c3.k()
c3=b7.e
c3.au(4)
c3.d+=4
c3=b7.e
f=c3.aH(h-4)
c3.d=c3.d+(f.c-f.d)
e=f.Y()
k+=e.length
B.c.C(m,e)}d=new Uint8Array(k)
for(c2=m.length,c=0,b=0;b<m.length;m.length===c2||(0,A.L)(m),++b){e=m[b]
B.d.dI(d,c,e)
c+=e.length}}c2=b9.d
a0=1
if(!(c2===3))if(!(c2===0)){if(c2===4)c2=2
else c2=c2===6?4:3
a0=c2}c2=A.hv(d,B.T,b8,b8)
s=A.oj(new A.ev(c2,B.a3,B.b5))
b7.d=b7.c=0
a1=b8
if(b9.d===3){c2=b9.w
if(c2!=null){c3=c2.length
a2=c3/3|0
a3=b9.x
i=a3!=null
a4=i?a3.length:0
a5=i?4:3
a1=new A.aT(new Uint8Array(a2*a5),a2,a5)
for(i=a5===4,j=0,a6=0;j<a2;++j,a6+=3){if(i&&j<a4){if(!(j<a3.length))return A.a(a3,j)
a7=a3[j]}else a7=255
if(!(a6<c3))return A.a(c2,a6)
a8=c2[a6]
a9=a6+1
if(!(a9<c3))return A.a(c2,a9)
a9=c2[a9]
b0=a6+2
if(!(b0<c3))return A.a(c2,b0)
a1.d6(j,a8,a9,c2[b0],a7)}}}if(b9.d===0&&b9.x!=null&&a1==null&&b9.c<=8){a3=b9.x
b1=a3.length
c2=b9.c
a2=B.a.U(1,c2)
c3=a2*4
i=new Uint8Array(c3)
a1=new A.aT(i,a2,4)
if(c2===1)b2=255
else if(c2===2)b2=85
else{c2=c2===4?17:1
b2=c2}for(j=0;j<a2;++j){b3=j*b2
a1.d6(j,b3,b3,b3,255)}for(j=0;j<b1;j+=2){c2=a3[j]
a8=j+1
if(!(a8<b1))return A.a(a3,a8)
b4=(c2&255)<<8|a3[a8]&255
if(b4<a2){c2=b4*4+3
if(!(c2<c3))return A.a(i,c2)
i[c2]=0}}}c2=b9.c
if(c2===1)b5=B.A
else if(c2===2)b5=B.w
else{if(c2===4)c3=B.B
else c3=c2===16?B.n:B.e
b5=c3}c3=b9.d
if(c3===0&&b9.x!=null&&c2>8)a0=4
r=A.V(b8,b8,b5,0,B.j,c1,b8,0,c3===2&&b9.x!=null?4:a0,a1,B.e,c0,!1)
q=b9.a
p=b9.b
b9.a=c0
b9.b=c1
o=c0
n=c1
b7.f=0
try{if(b9.r!==0){c2=o
if(typeof c2!=="number")return c2.ah()
c2=B.b.j(c2+7,3)
c3=n
if(typeof c3!=="number")return c3.ah()
b7.cc(s,r,0,0,8,8,c2,B.b.j(c3+7,3))
c3=o
if(typeof c3!=="number")return c3.ah()
c3=B.b.j(c3+3,3)
c2=n
if(typeof c2!=="number")return c2.ah()
b7.cc(s,r,4,0,8,8,c3,B.b.j(c2+7,3))
c2=o
if(typeof c2!=="number")return c2.ah()
c2=B.b.j(c2+3,2)
c3=n
if(typeof c3!=="number")return c3.ah()
b7.cc(s,r,0,4,4,8,c2,B.b.j(c3+3,3))
c3=o
if(typeof c3!=="number")return c3.ah()
c3=B.b.j(c3+1,2)
c2=n
if(typeof c2!=="number")return c2.ah()
b7.cc(s,r,2,0,4,4,c3,B.b.j(c2+3,2))
c2=o
if(typeof c2!=="number")return c2.ah()
c2=B.b.j(c2+1,1)
c3=n
if(typeof c3!=="number")return c3.ah()
b7.cc(s,r,0,2,2,4,c2,B.b.j(c3+1,2))
c3=o
if(typeof c3!=="number")return c3.aJ()
c3=B.b.j(c3,1)
c2=n
if(typeof c2!=="number")return c2.ah()
b7.cc(s,r,1,0,2,2,c3,B.b.j(c2+1,1))
c2=n
if(typeof c2!=="number")return c2.aJ()
b7.cc(s,r,0,1,1,2,o,B.b.j(c2,1))}else b7.kO(s,r)}catch(b6){c2=A.br(b6)
if(c2 instanceof A.fY)return b8
else if(c2 instanceof A.ej)return b8
else if(c2 instanceof A.iJ)return b8
else throw b6}finally{s.hq()
b9.sN(q)
b9.sJ(p)}c2=b9.at
if(c2!=null)r.c=new A.bH(b9.Q,B.aL,c2)
b9=b9.ax
if(b9.a!==0)r.lM(b9)
return r},
bg(a,b){return A.P(new A.k9(this,t.D.a(a),b),t.H)},
kH(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null
if(a.aK(a1)==null)return a0
s=a.a
r=s.cy
q=r.length
if(q===0||a2!=null)return a.an(a2==null?0:a2)
p=Math.min(s.CW,q)
new A.bO(a.b).ce(0,s.a*p,s.b)
for(q=t.g,o=a0,n=o,m=0;m<p;++m){if(!(m<r.length))return A.a(r,m)
a2=r[m]
l=a.an(m)
if(l==null)continue
if(n==null||o==null){n=l.dz(l.gad())
k=a2.f
n.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
o=n
continue}k=m-1
if(!(k>=0&&k<r.length))return A.a(r,k)
j=r[k]
i=l.a
h=i==null
g=h?a0:i.a
if(g==null)g=0
f=o.a
e=f==null
d=e?a0:f.a
if(g===(d==null?0:d)){i=h?a0:i.b
if(i==null)i=0
h=e?a0:f.b
i=i===(h==null?0:h)&&a2.d===0&&a2.e===0&&a2.x===B.cp}else i=!1
if(i){k=a2.f
l.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
n.aR(l)
o=l
continue}c=n.x
if(c===$)c=n.x=A.j([],q)
if(!(k<c.length))return A.a(c,k)
o=A.aQ(c[k],!1,!1)
b=j.w
if(b===B.cr){k=j.d
i=j.e
h=s.z
if(h==null){h=new Uint8Array(4)
g=new A.cn(h)
h[0]=0
h[1]=0
h[2]=0
h[3]=0
h=g}A.px(o,!1,h,k,k+j.b-1,i,i+j.c-1)}else if(b===B.cs&&m>1){k=m-2
c=n.x
if(c===$)c=n.x=A.j([],q)
if(!(k>=0&&k<c.length))return A.a(c,k)
i=j.d
h=j.e
g=j.b
f=j.c
o=A.nu(o,c[k],B.aF,f,g,i,h,f,g,i,h)}k=a2.f
o.y=B.b.h((k===0||a2.r===0?0:k/a2.r)*1000)
k=a2.x===B.cq?B.aF:B.ae
o=A.nu(o,l,k,a0,a0,a2.d,a2.e,a0,a0,a0,a0)
n.aR(o)}return n},
ge9(){var s=this.a.d
if(s===4)s=2
else if(s===2)s=3
else s=s===6?4:1
return s},
cc(a,b,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this
if(a4===0||a5===0)return
s=c.ge9()
r=c.a.c
q=s*r
p=B.a.j(q+7,3)
o=B.a.V(q*a4+7,8)
n=r===8||r===16
m=A.j([0,0,0,0],t.t)
for(l=a1,k=null,j=null,i=0;i<a5;++i,l+=a3,++c.f,j=g){s=a.H()
if(!(s<5))return A.a(B.aw,s)
h=B.aw[s]
g=a.af(o).Y()
s=g.length
if(s!==o)throw A.f(B.ba)
c.fY(h,p,g,j)
if(n){c.h9(g,b,l,a0,a2,a4)
continue}c.d=c.c=0
f=new A.ai(g,0,Math.min(s,s),0,!0)
for(e=a0,d=0;d<a4;++d,e+=a2){c.fL(f,m)
s=b.a
k=s==null?null:s.P(e,l,k)
if(k==null)k=new A.E()
c.fQ(k,m)}}},
kO(a,a0){var s,r,q,p,o,n,m,l=this,k=l.ge9(),j=l.a,i=j.c,h=k*i,g=j.a,f=j.b,e=B.a.V(g*h+7,8),d=B.a.j(h+7,3),c=i===8||i===16,b=A.j([0,0,0,0],t.t)
k=a0.a
s=k.gI(k)
s.E()
for(r=null,q=0;q<f;++q,r=o){k=a.H()
if(!(k<5))return A.a(B.aw,k)
p=B.aw[k]
o=a.af(e).Y()
k=o.length
if(k!==e)throw A.f(B.ba)
l.fY(p,d,o,r)
if(c){l.h9(o,a0,q,0,1,g)
continue}l.d=l.c=0
n=new A.ai(o,0,Math.min(k,k),0,!0)
for(m=0;m<g;++m){l.fL(n,b)
l.fQ(s.gO(),b)
s.E()}}},
h9(a2,a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this.ge9(),b=a3.a,a=b.c,a0=this.a,a1=a0.x
if(a0.c===8){s=J.G(b.gq(b))
r=a4*a3.a.gaz()+a5*a
q=a6*a
if(a===c){if(a6===1){B.d.aB(s,r,r+a7*c,a2)
return}for(b=a2.length,a0=s.$flags|0,p=0,o=0;p<a7;++p,r+=q)for(n=0;n<c;++n,o=l){m=r+n
l=o+1
if(!(o>=0&&o<b))return A.a(a2,o)
k=a2[o]
a0&2&&A.b(s)
if(!(m>=0&&m<s.length))return A.a(s,m)
s[m]=k}return}b=a1.length
if(0>=b)return A.a(a1,0)
a0=a1[0]
if(1>=b)return A.a(a1,1)
j=(a0&255)<<8|a1[1]&255
if(2>=b)return A.a(a1,2)
a0=a1[2]
if(3>=b)return A.a(a1,3)
i=(a0&255)<<8|a1[3]&255
if(4>=b)return A.a(a1,4)
a0=a1[4]
if(5>=b)return A.a(a1,5)
h=(a0&255)<<8|a1[5]&255
for(b=a2.length,a0=s.$flags|0,p=0,o=0;p<a7;++p,o+=3,r+=q){if(!(o<b))return A.a(a2,o)
g=a2[o]
m=o+1
if(!(m<b))return A.a(a2,m)
f=a2[m]
m=o+2
if(!(m<b))return A.a(a2,m)
e=a2[m]
a0&2&&A.b(s)
m=s.length
if(!(r>=0&&r<m))return A.a(s,r)
s[r]=g
k=r+1
if(!(k<m))return A.a(s,k)
s[k]=f
k=r+2
if(!(k<m))return A.a(s,k)
s[k]=e
k=r+3
d=g===j&&f===i&&e===h?0:255
if(!(k<m))return A.a(s,k)
s[k]=d}return}s=t.iI.a(b).d
r=(a4*a3.gN()+a5)*a
q=a6*a
if(a===c)for(b=a2.length,a0=s.$flags|0,p=0,o=0;p<a7;++p,r+=q)for(n=0;n<c;++n,o+=2){m=r+n
if(!(o>=0&&o<b))return A.a(a2,o)
k=a2[o]
d=o+1
if(!(d<b))return A.a(a2,d)
d=a2[d]
a0&2&&A.b(s)
if(!(m>=0&&m<s.length))return A.a(s,m)
s[m]=(k<<8|d)>>>0}else if(c===3){b=a1.length
if(0>=b)return A.a(a1,0)
a0=a1[0]
if(1>=b)return A.a(a1,1)
j=(a0&255)<<8|a1[1]&255
if(2>=b)return A.a(a1,2)
a0=a1[2]
if(3>=b)return A.a(a1,3)
i=(a0&255)<<8|a1[3]&255
if(4>=b)return A.a(a1,4)
a0=a1[4]
if(5>=b)return A.a(a1,5)
h=(a0&255)<<8|a1[5]&255
for(b=a2.length,a0=s.$flags|0,p=0,o=0;p<a7;++p,o+=6,r+=q){if(!(o<b))return A.a(a2,o)
m=a2[o]
k=o+1
if(!(k<b))return A.a(a2,k)
g=(m<<8|a2[k])>>>0
k=o+2
if(!(k<b))return A.a(a2,k)
k=a2[k]
m=o+3
if(!(m<b))return A.a(a2,m)
f=(k<<8|a2[m])>>>0
m=o+4
if(!(m<b))return A.a(a2,m)
m=a2[m]
k=o+5
if(!(k<b))return A.a(a2,k)
e=(m<<8|a2[k])>>>0
a0&2&&A.b(s)
k=s.length
if(!(r>=0&&r<k))return A.a(s,r)
s[r]=g
m=r+1
if(!(m<k))return A.a(s,m)
s[m]=f
m=r+2
if(!(m<k))return A.a(s,m)
s[m]=e
m=r+3
d=g===j&&f===i&&e===h?0:65535
if(!(m<k))return A.a(s,m)
s[m]=d}}else{b=a1.length
if(0>=b)return A.a(a1,0)
a0=a1[0]
if(1>=b)return A.a(a1,1)
i=(a0&255)<<8|a1[1]&255
for(b=a2.length,a0=s.$flags|0,p=0,o=0;p<a7;++p,o+=2,r+=q){if(!(o<b))return A.a(a2,o)
m=a2[o]
k=o+1
if(!(k<b))return A.a(a2,k)
f=(m<<8|a2[k])>>>0
a0&2&&A.b(s)
k=s.length
if(!(r>=0&&r<k))return A.a(s,r)
s[r]=f
m=r+1
if(!(m<k))return A.a(s,m)
s[m]=f
m=r+2
if(!(m<k))return A.a(s,m)
s[m]=f
m=r+3
d=f===i?0:65535
if(!(m<k))return A.a(s,m)
s[m]=d}}},
fY(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g=c.length,f=b<g?b:g
switch(a.a){case 0:break
case 1:for(s=c.$flags|0,r=b;r<g;++r){q=c[r]
p=r-b
if(!(p>=0))return A.a(c,p)
p=c[p]
s&2&&A.b(c)
c[r]=q+p}break
case 2:if(d!=null)for(s=d.length,q=c.$flags|0,r=0;r<g;++r){p=c[r]
if(!(r<s))return A.a(d,r)
o=d[r]
q&2&&A.b(c)
c[r]=p+o}break
case 3:if(d==null)for(s=c.$flags|0,r=b;r<g;++r){q=c[r]
p=r-b
if(!(p>=0))return A.a(c,p)
p=c[p]
s&2&&A.b(c)
c[r]=q+(p>>>1)}else{for(s=d.length,q=c.$flags|0,r=0;r<f;++r){if(!(r<g))return A.a(c,r)
p=c[r]
if(!(r<s))return A.a(d,r)
o=d[r]
q&2&&A.b(c)
c[r]=p+(o>>>1)}for(r=b;r<g;++r){p=c[r]
o=r-b
if(!(o>=0))return A.a(c,o)
o=c[o]
if(!(r<s))return A.a(d,r)
n=d[r]
q&2&&A.b(c)
c[r]=p+(o+n>>>1)}}break
case 4:if(d==null)for(s=c.$flags|0,r=b;r<g;++r){q=c[r]
p=r-b
if(!(p>=0))return A.a(c,p)
p=c[p]
s&2&&A.b(c)
c[r]=q+p}else{for(s=d.length,q=c.$flags|0,r=0;r<f;++r){if(!(r<g))return A.a(c,r)
p=c[r]
if(!(r<s))return A.a(d,r)
o=d[r]
q&2&&A.b(c)
c[r]=p+o}for(r=b;r<g;++r){p=r-b
if(!(p>=0))return A.a(c,p)
m=c[p]
if(!(r<s))return A.a(d,r)
l=d[r]
if(!(p<s))return A.a(d,p)
k=d[p]
j=l-k
i=m-k
h=j+i
if(j<0)j=-j
if(i<0)i=-i
if(h<0)h=-h
p=c[r]
if(j<=i&&j<=h)o=m
else o=i<=h?l:k
q&2&&A.b(c)
c[r]=p+o}}break}},
by(a,b){var s,r,q,p,o,n=this
if(b===0)return 0
if(b===8)return a.H()
if(b===16)return a.n()
for(s=a.c;r=n.d,r<b;){r=a.d
if(r>=s)throw A.f(A.l("Invalid PNG data."))
q=a.a
a.d=r+1
p=J.d(q,r)
r=n.d
n.c=B.a.U(p,r)
n.d=r+8}if(b===1)o=1
else if(b===2)o=3
else{if(b===4)s=15
else s=0
o=s}s=r-b
r=B.a.a0(n.c,s)
n.d=s
return r&o},
fL(a,b){var s,r,q=this
t.L.a(b)
s=q.a
r=s.d
switch(r){case 0:B.c.i(b,0,q.by(a,s.c))
return
case 2:B.c.i(b,0,q.by(a,s.c))
B.c.i(b,1,q.by(a,s.c))
B.c.i(b,2,q.by(a,s.c))
return
case 3:B.c.i(b,0,q.by(a,s.c))
return
case 4:B.c.i(b,0,q.by(a,s.c))
B.c.i(b,1,q.by(a,s.c))
return
case 6:B.c.i(b,0,q.by(a,s.c))
B.c.i(b,1,q.by(a,s.c))
B.c.i(b,2,q.by(a,s.c))
B.c.i(b,3,q.by(a,s.c))
return}throw A.f(A.l("Invalid color type: "+r+"."))},
fQ(a,b){var s,r,q,p,o,n,m,l,k,j
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
a.ap(p,p,p,p!==((q&255)<<8|r&255)?a.gG():0)
return}a.aG(b[0],0,0)
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
if(o!==((q&255)<<8|m&255)||p!==((l&255)<<8|k&255)||n!==((j&255)<<8|s&255)){a.ap(o,p,n,a.gG())
return}}a.aG(o,p,n)
return
case 3:a.sW(b[0])
return
case 4:a.ap(b[0],0,0,b[1])
return
case 6:a.ap(b[0],b[1],b[2],b[3])
return}throw A.f(A.l("Invalid color type: "+r+"."))}}
A.ka.prototype={
$0(){return this.a.kJ(this.b)},
$S:5}
A.k8.prototype={
$0(){return this.a.kI(this.b)},
$S:1}
A.k9.prototype={
$0(){return this.a.kH(this.b,this.c)},
$S:1}
A.iJ.prototype={}
A.i_.prototype={
a7(){return"PngFilter."+this.b}}
A.hZ.prototype={
aR(a){var s,r,q,p,o,n,m=this,l=8192,k={}
if(!(a.gb4()&&a.gL()!==B.n))s=a.gaN()<8&&!a.gaw()&&a.gad()>1
else s=!0
if(s)a=a.aS(B.e)
if(m.w==null){s=A.a0(!0,l)
m.w=s
s.a2(A.j([137,80,78,71,13,10,26,10],t.t))
r=A.a0(!0,l)
r.K(a.gN())
r.K(a.gJ())
r.p(a.gaN())
if(a.gaw())s=3
else if(a.gad()===1)s=0
else if(a.gad()===2)s=4
else s=a.gad()===3?2:6
r.p(s)
r.p(0)
r.p(0)
r.p(0)
s=m.w
s.toString
m.bz(s,"IHDR",J.C(B.d.gq(r.c),0,r.a))
s=a.c
if(s!=null){r=A.a0(!0,l)
r.a2(new A.ah(A.rx(s.a)))
r.p(0)
r.p(0)
r.a2(s.lT())
s=m.w
s.toString
m.bz(s,"iCCP",J.C(B.d.gq(r.c),0,r.a))}if(a.gaw()){s=m.a
if(s!=null){s=s.a
s===$&&A.c("palette")
m.h8(s)}else{s=a.a
s=s==null?null:s.gR()
s.toString
m.h8(s)}}if(m.r){r=A.a0(!0,l)
s=m.e
s===$&&A.c("_frames")
r.K(s)
r.K(m.c)
s=m.w
s.toString
m.bz(s,"acTL",J.C(B.d.gq(r.c),0,r.a))}}s=a.d
if(s!=null)for(s=new A.Y(s,s.r,s.e,A.m(s).m("Y<1>"));s.E();){q=s.d
p=a.d.l(0,q)
p.toString
r=new A.hV(!0,new Uint8Array(8192))
r.a2(B.b9.cv(q))
r.p(0)
r.a2(B.b9.cv(p))
q=m.w
q.toString
m.bz(q,"tEXt",J.C(B.d.gq(r.c),0,r.a))}if(m.r){r=A.a0(!0,l)
r.K(m.f)
r.K(a.gN())
r.K(a.gJ())
r.K(0)
r.K(0)
r.a3(a.y)
r.a3(1000)
r.p(1)
r.p(0)
s=m.w
s.toString
m.bz(s,"fcTL",J.C(B.d.gq(r.c),0,r.a));++m.f}o=m.f<=1
n=o?0:4
r=new Uint8Array(n+65536)
k.a=n
k.b=0
s=new A.kd(k,m,o,r,n)
q=new A.kc(k,r,s)
p=A.a0(!1,(a.a.gaz()+1)*a.gJ())
m.jX(0,a,new A.kb(null,q,p))
q.$1(B.bb.hA(t.L.a(J.C(B.d.gq(p.c),0,p.a)),null))
if(k.a>n||k.b===0)s.$0()},
dA(){var s,r=this,q=r.w
if(q==null)return null
r.bz(q,"IEND",A.j([],t.t))
r.f=0
q=r.w
s=J.C(B.d.gq(q.c),0,q.a)
r.w=null
return s},
hz(a,b){var s,r,q,p,o,n,m=this
A.ci(a)
if(a.gae().length<=1||b){m.e=1
m.r=!1
m.aR(a)}else{s=a.gae().length
m.e=s
m.r=s>1
m.c=a.r
if(a.gaw()){r=A.mR(a,256,10)
m.a=r
for(s=a.gae(),q=s.length,p=0;p<s.length;s.length===q||(0,A.L)(s),++p){o=s[p]
if(o!==a)r.hd(o)}}for(s=a.gae(),q=s.length,p=0;p<s.length;s.length===q||(0,A.L)(s),++p){o=s[p]
n=m.a
if(n!=null)m.aR(n.eu(o))
else m.aR(o)}}s=m.dA()
s.toString
return s},
bR(a){return this.hz(a,!1)},
h8(a){var s,r,q,p=this
if(a.gL()===B.e&&a.b===3&&a.a===256){s=p.w
s.toString
p.bz(s,"PLTE",J.C(a.gq(a),0,null))}else{s=a.a
r=A.a0(!0,s*3)
for(q=0;q<s;++q){r.p(B.b.h(a.b2(q)))
r.p(B.b.h(a.b1(q)))
r.p(B.b.h(a.b0(q)))}s=p.w
s.toString
p.bz(s,"PLTE",J.C(B.d.gq(r.c),0,r.a))}if(a.b===4){s=a.a
r=A.a0(!0,s)
for(q=0;q<s;++q)r.p(B.b.h(a.b7(q)))
s=p.w
s.toString
p.bz(s,"tRNS",J.C(B.d.gq(r.c),0,r.a))}},
bz(a,b,c){t.L.a(c)
a.K(c.length)
a.a2(new A.ah(b))
a.a2(c)
a.K(A.bB(c,A.bB(new A.ah(b),0)))},
jX(a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=a8.gaw()?B.lk:B.ll,a=a8.gq(0),a0=a8.a.gaz(),a1=a8.gaw()?1:a8.gad(),a2=B.a.j(a1*a8.gaN()+7,3),a3=a8.gaN()+7>>>3,a4=new Uint8Array(a0),a5=[a4,new Uint8Array(a0)],a6=a5[1]
a4=a0+1
s=new Uint8Array(a4)
r=b.a
if(0>=a4)return A.a(s,0)
s[0]=r
q=a9.c
p=a3>1
o=J.bp(a)
n=a3-1
m=0
l=0
for(;;){k=a8.a
k=k==null?null:k.b
if(!(l<(k==null?0:k)))break
j=o.cS(a,m,a0)
i=a5[l&1]
if(p)for(k=j.length,h=i.$flags|0,g=0;g<a0;g+=a3)for(f=n,e=0;e<a3;++e,--f){d=g+e
c=g+f
if(!(c>=0&&c<k))return A.a(j,c)
c=j[c]
h&2&&A.b(i)
if(!(d<i.length))return A.a(i,d)
i[d]=c}else B.d.aB(i,0,a0,j)
switch(r){case 0:B.d.aB(s,1,a4,i)
break
case 1:A.rv(i,a2,s)
break
case 2:A.rw(i,a6,s)
break
case 3:A.rt(i,a6,a2,s)
break
case 4:A.ru(i,a6,a2,s)
break}q.a2(s);++l
m+=a0
a6=i}}}
A.kd.prototype={
$0(){var s,r,q=this,p=q.b,o=q.d,n=q.a
if(q.c){s=p.w
s.toString
p.bz(s,"IDAT",J.C(B.d.gq(o),0,n.a))}else{s=p.f
o.$flags&2&&A.b(o)
r=o.length
if(0>=r)return A.a(o,0)
o[0]=s>>>24&255
if(1>=r)return A.a(o,1)
o[1]=s>>>16&255
if(2>=r)return A.a(o,2)
o[2]=s>>>8&255
if(3>=r)return A.a(o,3)
o[3]=s&255
p.f=s+1
s=p.w
s.toString
p.bz(s,"fdAT",J.C(B.d.gq(o),0,n.a))}n.a=q.e;++n.b},
$S:3}
A.kc.prototype={
$1(a){var s,r,q,p,o,n,m,l
for(s=a.length,r=this.a,q=this.b,p=q.length,o=this.c,n=0;n<s;){m=r.a
l=Math.min(s-n,p-m)
B.d.ab(q,m,m+l,a,n)
n+=l
if((r.a+=l)===p)o.$0()}},
$S:29}
A.cb.prototype={
a7(){return"PnmFormat."+this.b}}
A.cc.prototype={}
A.ke.prototype={
aT(a){var s
this.b=A.v(a,!1,null,0)
s=this.dk()
if(s==="P1"||s==="P2"||s==="P5"||s==="P3"||s==="P6")return!0
return!1},
bg(a,b){return A.P(new A.kh(this,a,b),t.H)},
kK(a,b){if(this.aK(a)==null)return null
return this.an(0)},
aK(a){return A.P(new A.ki(this,a),t._)},
kM(a){var s,r,q,p=this
p.b=A.v(a,!1,null,0)
s=p.dk()
if(s==="P1"){r=p.a=new A.cc(B.aa)
r.e=B.ct}else if(s==="P2"){r=p.a=new A.cc(B.aa)
r.e=B.cu}else if(s==="P5"){r=p.a=new A.cc(B.aa)
r.e=B.aX}else if(s==="P3"){r=p.a=new A.cc(B.aa)
r.e=B.cv}else if(s==="P6"){r=p.a=new A.cc(B.aa)
r.e=B.aY}else return p.b=null
r.a=p.cM()
r=p.a
r.toString
r.b=p.cM()
r=p.a
q=r.a
if(q<1||r.b<1)return p.a=p.b=null
A.ax(q,r.b,p.d,!1)
return p.a},
an(a){return A.P(new A.kg(this,a),t.H)},
kL(a){var s,r,q,p,o,n=this,m=null,l=n.a
if(l==null)return m
s=l.e
if(s===B.ct){n.dO(1)
s=l.a
r=A.V(m,m,B.A,0,B.j,l.b,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gI(l);l.E();){q=l.gO()
if(n.dk()==="1")q.aG(1,1,1)
else q.aG(0,0,0)}return r}else if(s===B.cu||s===B.aX){p=n.cM()
if(p===0)return m
n.dO(1)
l=n.a
s=l.a
l=l.b
r=A.V(m,m,n.hE(p),0,B.j,l,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gI(l);l.E();){q=l.gO()
o=n.dq(n.a.e,p)
q.aG(o,o,o)}return r}else if(s===B.cv||s===B.aY){p=n.cM()
if(p===0)return m
n.dO(3)
l=n.a
s=l.a
l=l.b
r=A.V(m,m,n.hE(p),0,B.j,l,m,0,3,m,B.e,s,!1)
for(l=r.a,l=l.gI(l);l.E();)l.gO().aG(n.dq(n.a.e,p),n.dq(n.a.e,p),n.dq(n.a.e,p))
return r}return m},
dO(a){var s,r=this.a,q=r.a
r=r.b
s=this.b
if(s.c-s.d+this.c.gu(0)<q*r*a)throw A.f(A.l("Truncated PNM data"))},
hE(a){if(a>255)return B.n
if(a>15)return B.e
if(a>3)return B.B
if(a>1)return B.w
return B.A},
dq(a,b){if(a===B.aX||a===B.aY)return this.b.H()
return this.cM()},
cM(){var s,r,q=this.dk()
if(J.bC(q)===0)return 0
try{s=A.vW(q)
return s}catch(r){return 0}},
dk(){var s,r,q,p,o=this.b
if(o==null)return""
s=this.c
if(!s.gd0(0))return s.hR()
r=B.m.hX(o.mA())
if(r.length===0)return""
while(B.m.eH(r,"#"))r=B.m.hX(this.b.hN(70))
o=t.no
q=A.t(new A.cW(A.j(r.split(" "),t.s),t.gS.a(new A.kf()),o),o.m("e.E"))
for(o=q.length,p=0;p<o;++p)if(B.m.eH(q[p],"#")){B.c.su(q,p)
break}s.cf(0,q)
if(s.b===s.c)return""
return s.hR()}}
A.kh.prototype={
$0(){return this.a.kK(this.b,this.c)},
$S:1}
A.ki.prototype={
$0(){return this.a.kM(this.b)},
$S:5}
A.kg.prototype={
$0(){return this.a.kL(this.b)},
$S:1}
A.kf.prototype={
$1(a){return A.bA(a)!==""},
$S:30}
A.i2.prototype={
smg(a){t.T.a(a)},
sib(a){t.T.a(a)},
smC(a){t.T.a(a)},
smD(a){t.T.a(a)}}
A.i3.prototype={
sbN(a){t.T.a(a)},
sbT(a){t.T.a(a)}}
A.bw.prototype={}
A.i6.prototype={
sbN(a){t.T.a(a)},
sbT(a){t.T.a(a)}}
A.i7.prototype={
sbN(a){t.T.a(a)},
sbT(a){t.T.a(a)}}
A.ia.prototype={
sbN(a){t.T.a(a)},
sbT(a){t.T.a(a)}}
A.ib.prototype={
sbN(a){t.T.a(a)},
sbT(a){t.T.a(a)}}
A.fb.prototype={}
A.i9.prototype={}
A.kj.prototype={
iC(a){var s,r,q,p,o=this
a.n()
a.n()
a.n()
a.n()
s=B.a.V(a.c-a.d,8)
if(s>0){o.e=new Uint16Array(s)
o.f=new Uint16Array(s)
o.r=new Uint16Array(s)
o.w=new Uint16Array(s)
for(r=0;r<s;++r){q=o.e
p=a.n()
q.$flags&2&&A.b(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.f
q=a.n()
p.$flags&2&&A.b(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q
q=o.r
p=a.n()
q.$flags&2&&A.b(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.w
q=a.n()
p.$flags&2&&A.b(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q}}}}
A.cR.prototype={
hM(a,b,c,d,e,f,g){if(a.c-a.d<2)return
if(e==null)e=a.n()
switch(e){case 0:d.toString
this.le(a,b,c,d)
break
case 1:if(f==null)f=this.lb(a,c)
d.toString
this.ld(a,b,c,d,f,g)
break
default:throw A.f(A.l("Unsupported compression: "+e))}},
mz(a,b,c,d){return this.hM(a,b,c,d,null,null,0)},
lb(a,b){var s,r,q=new Uint16Array(b)
for(s=0;s<b;++s){r=a.n()
if(!(s<b))return A.a(q,s)
q[s]=r}return q},
le(a,b,c,d){var s,r=b*c
if(d===16)r*=2
if(r>a.c-a.d){s=new Uint8Array(r)
this.c=s
B.d.a8(s,0,r,255)
return}this.c=a.af(r).Y()},
ld(a,b,c,d,e,f){var s,r,q,p,o,n,m,l=b*c
if(d===16)l*=2
s=new Uint8Array(l)
this.c=s
r=f*c
q=e.length
if(r>=q){B.d.a8(s,0,l,255)
return}for(p=0,o=0;o<c;++o,r=n){n=r+1
if(!(r>=0&&r<q))return A.a(e,r)
m=a.aH(e[r])
a.d=a.d+(m.c-m.d)
s=this.c
s.toString
this.jA(m,s,p)
p+=b}},
jA(a,b,c){var s,r,q,p,o,n,m,l
for(s=a.c,r=b.length;q=a.d,q<s;){p=a.a
a.d=q+1
q=J.d(p,q)
p=$.az()
p.$flags&2&&A.b(p)
p[0]=q
q=$.aH()
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
A.bk.prototype={
a7(){return"PsdColorMode."+this.b}}
A.i4.prototype={
glQ(){var s=this.e
s===$&&A.c("channels")
return s},
iD(a,b){var s,r,q=this
q.as=A.v(a,!0,null,0)
q.kS()
if(q.c!==943870035)return
s=q.as.k()
q.as.af(s)
s=q.as.k()
q.ax=q.as.af(s)
s=q.as.k()
q.ay=q.as.af(s)
r=q.as
q.ch=r.af(r.c-r.d)},
bQ(){var s,r=this
if(r.c===943870035){s=r.as
s===$&&A.c("_input")
s=s==null}else s=!0
if(s)return!1
A.ax(r.a,r.b,r.CW,!1)
s=r.e
s===$&&A.c("channels")
if(s<1||s>56)throw A.f(A.l("Invalid number of PSD channels: "+r.glQ()))
r.l9()
r.la()
r.lc()
r.ch=r.ay=r.ax=r.as=null
return!0},
m0(){if(!this.bQ())return null
return this.mF()},
mF(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this,a1=null,a2=a0.y
if(a2!=null)return a2
a2=a0.a
a2=A.V(a1,a1,B.e,0,B.j,a0.b,a1,0,4,a1,B.e,a2,!1)
a0.y=a2
a2.cT(0)
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
if(g==null)g=new A.E()
f=B.b.h(g.gt())
e=B.b.h(g.gA())
d=B.b.h(g.gB())
c=B.b.h(g.gv())
j.toString
if(j>=0&&j<a0.a&&q&&m<a0.b){h=r.b
h.toString
b=a0.y.a
a=b==null?a1:b.P(h+i,k,a1)
if(a==null)a=new A.E()
a0.iQ(B.b.h(a.gt()),B.b.h(a.gA()),B.b.h(a.gB()),B.b.h(a.gv()),f,e,d,c,o,p,a)}++i;++j}++l;++m}}a2=a0.y
a2.toString
return a2},
iQ(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n=h/255*j
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
case 1768188278:p=A.ko(a,e)
q=A.ko(b,f)
r=A.ko(c,g)
s=h
break
case 1818391150:p=A.kq(a,e)
q=A.kq(b,f)
r=A.kq(c,g)
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
case 1935897198:p=A.n4(a,e)
q=A.n4(b,f)
r=A.n4(c,g)
s=h
break
case 1684633120:p=A.kp(a,e)
q=A.kp(b,f)
r=A.kp(c,g)
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
case 1870030194:p=A.n2(a,e,d,h)
q=A.n2(b,f,d,h)
r=A.n2(c,g,d,h)
s=h
break
case 1934387572:p=A.n5(a,e)
q=A.n5(b,f)
r=A.n5(c,g)
s=h
break
case 1749838196:p=A.n0(a,e)
q=A.n0(b,f)
r=A.n0(c,g)
s=h
break
case 1984719220:p=A.n6(a,e)
q=A.n6(b,f)
r=A.n6(c,g)
s=h
break
case 1816947060:p=A.n1(a,e)
q=A.n1(b,f)
r=A.n1(c,g)
s=h
break
case 1884055924:p=A.n3(a,e)
q=A.n3(b,f)
r=A.n3(c,g)
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
case 1936553316:p=A.n_(a,e)
q=A.n_(b,f)
r=A.n_(c,g)
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
k.st(B.b.h(a*o+p*n))
k.sA(B.b.h(b*o+q*n))
k.sB(B.b.h(c*o+r*n))
k.sv(B.b.h(d*o+s*n))},
kS(){var s,r,q=this,p=q.as
p===$&&A.c("_input")
q.c=p.k()
p=q.as.n()
q.d=p
if(p!==1){q.c=0
return}s=q.as.af(6)
for(r=0;r<6;++r)if(J.d(s.a,s.d+r)!==0){q.c=0
return}q.e=q.as.n()
q.b=q.as.k()
q.a=q.as.k()
q.f=q.as.n()
p=q.as.n()
if(!(p<8))return A.a(B.cj,p)
q.r=B.cj[p]},
l9(){var s,r,q,p,o,n,m=this,l=m.ax
l.d=l.b
for(l=m.z;s=m.ax,s.d<s.c;){r=s.k()
q=m.ax.n()
s=m.ax
p=J.d(s.a,s.d++)
m.ax.au(p)
if((p&1)===0)++m.ax.d
p=m.ax.k()
s=m.ax
o=s.aH(p)
n=s.d+(o.c-o.d)
s.d=n
if((p&1)===1)s.d=n+1
if(r===943868237)l.i(0,q,new A.i5())}},
la(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c="channels",b=d.ay
b.d=b.b
s=b.k()
if((s&1)!==0)++s
r=d.ay.af(s)
b=d.w
B.c.cT(b)
if(s>0){q=r.n()
p=$.ay()
p.$flags&2&&A.b(p)
p[0]=q
q=$.aG()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0)o=-o
for(q=t.N,p=t.mi,n=t.k9,m=t.na,l=0;l<o;++l){k=new A.i8(A.J(q,p),A.j([],n),A.j([],m))
k.iE(r)
B.c.C(b,k)}}q=d.CW
j=new A.bO(q)
i=d.f===16?2:1
p=d.a
n=d.b
m=d.e
m===$&&A.c(c)
h=p*n*m*i
for(p=b.length,g=0;g<b.length;b.length===p||(0,A.L)(b),++g){k=b[g]
n=k.e
n===$&&A.c("width")
m=k.f
m===$&&A.c("height")
A.ax(n,m,q,!0)
j.ce(0,k.e,k.f)
m=k.e
n=k.f
f=k.as
f===$&&A.c(c)
h+=m*n*f.length*i}if(h>Math.max(128*d.at,16777216))throw A.f(A.l("PSD data is too small for its size"))
for(l=0;l<b.length;++l)b[l].mw(r,d)
s=d.ay.k()
e=d.ay.af(s)
if(s>0){e.n()
e.n()
e.n()
e.n()
e.n()
e.n()
e.H()}},
lc(){var s,r,q,p,o,n,m=this,l="channels",k=m.ch
k.d=k.b
s=k.n()
if(s===1){k=m.b
r=m.e
r===$&&A.c(l)
q=k*r
p=new Uint16Array(q)
for(o=0;o<q;++o)p[o]=m.ch.n()}else p=null
m.x=t.cf.a(A.j([],t.mS))
o=0
for(;;){k=m.e
k===$&&A.c(l)
if(!(o<k))break
k=m.x
r=m.ch
r.toString
n=o===3?-1:o
n=new A.cR(n)
n.hM(r,m.a,m.b,m.f,s,p,o)
B.c.C(k,n);++o}m.y=A.oF(m.r,m.f,m.a,m.b,m.x)},
$iM:1}
A.i5.prototype={}
A.i8.prototype={
iE(a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a4.k(),a3=$.U()
a3.$flags&2&&A.b(a3)
a3[0]=a2
a2=$.ab()
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
s=a4.n()
for(r=0;r<s;++r){a2=a4.n()
a3=$.ay()
a3.$flags&2&&A.b(a3)
a3[0]=a2
a2=$.aG()
if(0>=a2.length)return A.a(a2,0)
q=a2[0]
a4.k()
B.c.C(a1.as,new A.cR(q))}p=a4.k()
if(p!==943868237)throw A.f(A.l("Invalid PSD layer signature: "+B.a.dE(p,16)))
a1.r=a4.k()
a1.w=a4.H()
a4.H()
a1.y=a4.H()
if(a4.H()!==0)throw A.f(A.l("Invalid PSD layer data"))
o=a4.k()
n=a4.af(o)
if(o>0){o=n.k()
if(o>0){m=n.af(o)
a2=m.d
m.k()
m.k()
m.k()
m.k()
m.H()
m.H()
if(m.c-a2===20)m.d+=2
else{m.H()
m.H()
m.k()
m.k()
m.k()
m.k()}}o=n.k()
if(o>0)new A.kj().iC(n.af(o))
o=n.H()
n.au(o)
l=4-B.a.a5(o,4)-1
if(l>0)n.d+=l
for(a2=n.c,a3=a1.ay,k=a1.cy,j=t.t,i=t.dM;n.d<a2;){p=n.k()
if(p!==943868237)throw A.f(A.l("PSD invalid signature for layer additional data: "+B.a.dE(p,16)))
h=n.au(4)
o=n.k()
g=n.aH(o)
f=n.d+(g.c-g.d)
n.d=f
if((o&1)===1)n.d=f+1
a3.i(0,h,A.rK(h,g))
if(h==="lrFX"){e=A.w(i.a(a3.l(0,"lrFX")).b,null,0)
e.n()
d=e.n()
for(c=0;c<d;++c){e.au(4)
b=e.au(4)
a=e.k()
if(b==="dsdw"){a0=new A.i3()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbN(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.au(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbT(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else if(b==="isdw"){a0=new A.i7()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbN(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.au(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbT(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else if(b==="oglw"){a0=new A.ia()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbN(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.au(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2)a0.sbT(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else if(b==="iglw"){a0=new A.i6()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbN(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.au(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){J.d(e.a,e.d++)
a0.sbT(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}}else if(b==="bevl"){a0=new A.i2()
B.c.C(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.au(8)
e.au(8)
a0.smg(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
a0.sib(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){a0.smC(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
a0.smD(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}}else if(b==="sofi"){a0=new A.ib()
B.c.C(k,a0)
a0.a=e.k()
e.au(4)
a0.sbN(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbT(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else e.d+=a}}}}},
mw(a,b){var s,r,q,p,o,n=this,m=0
for(;;){s=n.as
s===$&&A.c("channels")
if(!(m<s.length))break
s=s[m]
r=n.e
r===$&&A.c("width")
q=n.f
q===$&&A.c("height")
s.mz(a,r,q,b.f);++m}r=b.r
q=b.f
p=n.e
p===$&&A.c("width")
o=n.f
o===$&&A.c("height")
n.cx=A.oF(r,q,p,o,s)}}
A.dG.prototype={}
A.kk.prototype={
aT(a){var s,r
try{s=A.oE(a,null).c
return s===943870035}catch(r){return!1}},
bg(a,b){return A.P(new A.km(this,a,b),t.H)},
kR(a,b){var s,r,q,p=this
if(p.aK(a)==null)return null
s=p.a==null?null:1
if(s==null)s=0
if(s===1)return p.an(0)
for(r=null,q=0;q<s;++q){b=p.an(q)
if(b==null)continue
if(r==null){b.w=B.bh
r=b}else r.aR(b)}return r},
aK(a){return A.P(new A.kn(this,a),t._)},
an(a){return A.P(new A.kl(this,a),t.H)}}
A.km.prototype={
$0(){return this.a.kR(this.b,this.c)},
$S:1}
A.kn.prototype={
$0(){var s=this.a
return s.a=A.oE(this.b,s.b)},
$S:5}
A.kl.prototype={
$0(){var s=this.a.a
return s==null?null:s.m0()},
$S:1}
A.ic.prototype={}
A.b3.prototype={
cX(){return new A.b3(this.a,this.b,this.c)},
eA(a){var s,r=this
t.j.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s},
ez(a){var s,r=this
t.j.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s}}
A.R.prototype={
cX(){var s=this
return new A.R(s.a,s.b,s.c,s.d)},
ah(a,b){var s=this
return new A.R(s.a+b.a,s.b+b.b,s.c+b.c,s.d+b.d)},
eI(a,b){var s=this
return new A.R(s.a-b.a,s.b-b.b,s.c-b.c,s.d-b.d)},
hx(a){var s=this
return s.a*a.a+s.b*a.b+s.c*a.c+s.d*a.d},
eA(a){var s,r=this
t.R.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s
s=a.d
if(s<r.d)r.d=s},
ez(a){var s,r=this
t.R.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s
s=a.d
if(s>r.d)r.d=s}}
A.dJ.prototype={
C(a,b){this.$ti.c.a(b)
this.a.eA(b)
this.b.ez(b)}}
A.dH.prototype={$iM:1,
gN(){return this.a},
gJ(){return this.b}}
A.dI.prototype={$iM:1,
gJ(){return this.f},
gN(){return this.r}}
A.fc.prototype={$iM:1,
gN(){return this.a},
gJ(){return this.b}}
A.a8.prototype={
scU(a){var s=this.a,r=this.b+1
s.$flags&2&&A.b(s)
if(!(r<s.length))return A.a(s,r)
s[r]=a},
bW(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.t,s)
return new A.b3(B.t[s],B.t[q>>>4&31],B.z[q&15])}else return new A.b3(B.z[q>>>7&15],B.z[q>>>3&15],B.aA[q&7])},
bY(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.t,s)
return new A.R(B.t[s],B.t[q>>>4&31],B.z[q&15],255)}else return new A.R(B.z[q>>>7&15],B.z[q>>>3&15],B.aA[q&7],B.aA[q>>>11&7])},
bX(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.t,s)
return new A.b3(B.t[s],B.t[q>>>5&31],B.t[q&31])}else return new A.b3(B.z[q>>>8&15],B.z[q>>>4&15],B.z[q&15])},
bZ(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.t,s)
return new A.R(B.t[s],B.t[q>>>5&31],B.t[q&31],255)}else return new A.R(B.z[q>>>8&15],B.z[q>>>4&15],B.z[q&15],B.aA[q>>>12&7])},
aQ(){var s=this,r=s.c?1:0,q=s.d,p=s.e?1:0,o=s.f,n=s.r?1:0
return(r|(q&16383)<<1|p<<15|(o&32767)<<16|n<<31)>>>0},
aF(){var s,r=this,q=r.a,p=r.b+1
if(!(p<q.length))return A.a(q,p)
s=q[p]
r.c=(s&1)===1
r.scU(r.aQ())
r.d=s>>>1&16383
r.scU(r.aQ())
r.e=(s>>>15&1)===1
r.scU(r.aQ())
r.f=s>>>16&32767
r.scU(r.aQ())
r.r=(s>>>31&1)===1
r.scU(r.aQ())}}
A.kr.prototype={
aT(a){var s,r
try{s=this.aK(a)
return s!=null}catch(r){return!1}},
aK(a){return A.P(new A.ku(this,a),t._)},
lt(a){var s,r=this,q=a.length,p=q-(q>>>1&1431655765)>>>0
p=(p&858993459)+(p>>>2&858993459)
if((p+(p>>>4)>>>0&252645135)*16843009>>>0>>>24===1){s=r.ji(a)
if(s!=null){r.a=a
return r.b=s}}s=r.jz(a)
if(s!=null){r.a=a
return r.b=s}s=r.jx(a)
if(s!=null){r.a=a
return r.b=s}return null},
jz(a){var s,r,q=A.v(a,!1,null,0)
if(q.c-q.d<52)return null
if(q.k()!==55727696)return null
s=A.j([0,0,0,0],t.t)
r=new A.dI(s)
q.k()
r.b=q.k()
B.c.i(s,0,q.H())
B.c.i(s,1,q.H())
B.c.i(s,2,q.H())
B.c.i(s,3,q.H())
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
jx(a){var s,r,q=A.v(a,!1,null,0)
if(q.k()!==52)return null
s=new A.dH()
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
ji(a){var s,r,q,p,o,n,m=null,l=a.length,k=A.v(a,!1,m,0)
if(k.k()!==0)return m
s=new A.fc()
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
an(a){return A.P(new A.ks(this,a),t.H)},
js(a){var s,r,q=this,p=q.b
if(p==null||q.a==null)return null
A.ax(p.gN(),q.b.gJ(),q.c,!1)
p=q.b
if(p instanceof A.fc){p=p.a
s=q.b.gJ()
r=q.a
r.toString
return q.dV(p,s,r)}else if(p instanceof A.dH){p=q.a
p.toString
return q.jw(p)}else if(p instanceof A.dI){p=q.a
p.toString
return q.jy(p)}return null},
bg(a,b){return A.P(new A.kt(this,a,b),t.H)},
jc(a,b){if(this.aK(a)==null)return null
return this.an(0)},
jw(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=a.length
if(e<52||g.b==null)return f
s=g.b
s.toString
t.fF.a(s)
r=A.v(a,!1,f,0)
r.d+=52
q=s.Q
if(q<1)q=(s.d&4096)!==0?6:1
if(q!==1)return f
p=s.a
o=s.b
if(p*o*s.f/8>e-52)return f
switch(s.d&255){case 16:n=A.V(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
l=J.d(r.a,r.d++)
k=J.d(r.a,r.d++)
m.st(k&240)
m.sA((k&15)<<4)
m.sB(l&240)
m.sv((l&15)<<4)}return n
case 17:n=A.V(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
j=r.n()
i=(j&1)!==0?255:0
m.st(j>>>8&248)
m.sA(j>>>3&248)
m.sB((j&62)<<2)
m.sv(i)}return n
case 18:n=A.V(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
m.st(J.d(r.a,r.d++))
m.sA(J.d(r.a,r.d++))
m.sB(J.d(r.a,r.d++))
m.sv(J.d(r.a,r.d++))}return n
case 19:n=A.V(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
j=r.n()
m.st(j>>>8&248)
m.sA(j>>>3&252)
m.sB((j&31)<<3)}return n
case 20:n=A.V(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
j=r.n()
m.st((j&31)<<3)
m.sA(j>>>2&248)
m.sB(j>>>7&248)}return n
case 21:n=A.V(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
m.st(J.d(r.a,r.d++))
m.sA(J.d(r.a,r.d++))
m.sB(J.d(r.a,r.d++))}return n
case 22:n=A.V(f,f,B.e,0,B.j,o,f,0,1,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();)s.gO().st(J.d(r.a,r.d++))
return n
case 23:n=A.V(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gI(s);s.E();){m=s.gO()
i=J.d(r.a,r.d++)
h=J.d(r.a,r.d++)
m.st(h)
m.sA(h)
m.sB(h)
m.sv(i)}return n
case 24:return f
case 25:return s.y===0?g.ff(p,o,r.Y()):g.dV(p,o,r.Y())}return f},
jy(a){var s,r=this.b
if(!(r instanceof A.dI))return null
s=A.v(a,!1,null,0)
s.d=(s.d+=52)+r.Q
if(r.c[0]===0)switch(r.b){case 2:return this.ff(r.r,r.f,s.Y())
case 3:return this.dV(r.r,r.f,s.Y())}return null},
ff(e4,e5,e6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4=null,d5=A.V(d4,d4,B.e,0,B.j,e5,d4,0,3,d4,B.e,e4,!1),d6=e4/4|0,d7=d6-1,d8=J.a1(B.d.gq(e6),0,null),d9=new A.a8(d8),e0=new A.a8(J.a1(B.d.gq(e6),0,null)),e1=new A.a8(J.a1(B.d.gq(e6),0,null)),e2=new A.a8(J.a1(B.d.gq(e6),0,null)),e3=new A.a8(J.a1(B.d.gq(e6),0,null))
for(s=d8.length,r=0,q=0;r<d6;++r,q+=4)for(p=0,o=0;p<d6;++p,o+=4){d9.b=A.aa(p,r)<<1>>>0
d9.aF()
n=d9.b
if(!(n<s))return A.a(d8,n)
m=d8[n]
l=d9.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&d7)>>>0
h=(i+1&d7)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&d7)>>>0
e=(f+1&d7)>>>0
e0.b=A.aa(f,i)<<1>>>0
e0.aF()
e1.b=A.aa(e,i)<<1>>>0
e1.aF()
e2.b=A.aa(f,h)<<1>>>0
e2.aF()
e3.b=A.aa(e,h)<<1>>>0
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
c8=B.c3[l+m&3]
c9=c8[0]
d0=c8[1]
d1=B.a.j((b*c+a2*a1+a6*a5+b0*a9)*c9+(b4*b3+b8*b7+c2*c1+c6*c5)*d0,7)
d2=B.a.j((a*c+a3*a1+a7*a5+b1*a9)*c9+(b5*b3+b9*b7+c3*c1+c7*c5)*d0,7)
d3=B.a.j((d*c+a0*a1+a4*a5+a8*a9)*c9+(b2*b3+b6*b7+c0*c1+c4*c5)*d0,7)
d0=d5.a
if(d0!=null)d0.aP(g+o,n,d1,d2,d3)
m=m>>>2;++k}}}return d5},
dV(c0,c1,c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=null,b1=A.V(b0,b0,B.e,0,B.j,c1,b0,0,4,b0,B.e,c0,!1),b2=c0/4|0,b3=b2-1,b4=J.a1(B.d.gq(c2),0,null),b5=new A.a8(b4),b6=new A.a8(J.a1(B.d.gq(c2),0,null)),b7=new A.a8(J.a1(B.d.gq(c2),0,null)),b8=new A.a8(J.a1(B.d.gq(c2),0,null)),b9=new A.a8(J.a1(B.d.gq(c2),0,null))
for(s=b4.length,r=0,q=0;r<b2;++r,q+=4)for(p=0,o=0;p<b2;++p,o+=4){b5.b=A.aa(p,r)<<1>>>0
b5.aF()
n=b5.b
if(!(n<s))return A.a(b4,n)
m=b4[n]
l=b5.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&b3)>>>0
h=(i+1&b3)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&b3)>>>0
e=(f+1&b3)>>>0
b6.b=A.aa(f,i)<<1>>>0
b6.aF()
b7.b=A.aa(e,i)<<1>>>0
b7.aF()
b8.b=A.aa(f,h)<<1>>>0
b8.aF()
b9.b=A.aa(e,h)<<1>>>0
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
a2=new A.R(b*c,a*c,a0*c,d*c).ah(0,new A.R(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a1=b8.bY()
c=B.h[k][2]
c=a2.ah(0,new A.R(a1.a*c,a1.b*c,a1.c*c,a1.d*c))
a1=b9.bY()
a2=B.h[k][3]
a3=c.ah(0,new A.R(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a2=b6.bZ()
a1=B.h[k][0]
c=a2.a
d=a2.b
a0=a2.c
a2=a2.d
a=b7.bZ()
b=B.h[k][1]
b=new A.R(c*a1,d*a1,a0*a1,a2*a1).ah(0,new A.R(a.a*b,a.b*b,a.c*b,a.d*b))
a=b8.bZ()
a1=B.h[k][2]
a1=b.ah(0,new A.R(a.a*a1,a.b*a1,a.c*a1,a.d*a1))
a=b9.bZ()
b=B.h[k][3]
a4=a1.ah(0,new A.R(a.a*b,a.b*b,a.c*b,a.d*b))
a5=B.c3[l+m&3]
b=a3.a
a=a5[0]
a1=a4.a
a2=a5[1]
a6=B.a.j(b*a+a1*a2,7)
a7=B.a.j(a3.b*a+a4.b*a2,7)
a8=B.a.j(a3.c*a+a4.c*a2,7)
a9=B.a.j(a3.d*a5[2]+a4.d*a5[3],7)
a2=b1.a
if(a2!=null)a2.aA(g+o,n,a6,a7,a8,a9)
m=m>>>2;++k}}}return b1}}
A.ku.prototype={
$0(){return this.a.lt(this.b)},
$S:5}
A.ks.prototype={
$0(){return this.a.js(this.b)},
$S:1}
A.kt.prototype={
$0(){return this.a.jc(this.b,this.c)},
$S:1}
A.fd.prototype={
a7(){return"PvrFormat."+this.b}}
A.kv.prototype={
bR(a){var s,r,q,p,o
A.ci(a)
s=A.a0(!1,8192)
switch(0){case 0:if(a.gad()===3){r=this.m4(a)
q=B.lq}else{r=this.m5(a)
q=B.lr}break}p=a.gJ()
o=a.gN()
s.K(55727696)
s.K(0)
s.K(q.a-1)
s.K(0)
s.K(0)
s.K(0)
s.K(p)
s.K(o)
s.K(1)
s.K(1)
s.K(1)
s.K(1)
s.K(0)
s.a2(r)
return J.C(B.d.gq(s.c),0,s.a)},
m4(d0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9
if(d0.gN()!==d0.gJ())throw A.f(A.l("PVRTC requires a square image."))
s=d0.gN()
if((s&s-1)>>>0!==0)throw A.f(A.l(u.b))
r=B.a.V(d0.gN(),4)
q=r-1
s=B.a.V(d0.gN()*d0.gJ(),2)
p=new Uint8Array(s)
s=J.a1(B.d.gq(p),0,null)
o=new A.a8(s)
n=new A.a8(J.a1(B.d.gq(p),0,null))
m=new A.a8(J.a1(B.d.gq(p),0,null))
l=new A.a8(J.a1(B.d.gq(p),0,null))
k=new A.a8(J.a1(B.d.gq(p),0,null))
for(j=s.$flags|0,i=t.j,h=0;h<r;++h)for(g=0;g<r;++g){f=A.rL(d0,g,h)
o.b=A.aa(g,h)<<1>>>0
o.aF()
o.c=!1
e=o.aQ()
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
s[d]=o.aQ()
o.e=!0
s[d]=o.aQ()
e=i.a(f.b)
c=e.a
if(!(c>=0&&c<256))return A.a(B.x,c)
b=B.x[c]
c=e.b
if(!(c>=0&&c<256))return A.a(B.x,c)
a=B.x[c]
e=e.c
if(!(e>=0&&e<256))return A.a(B.x,e)
o.f=(b<<10|a<<5|B.x[e])>>>0
s[d]=o.aQ()
o.r=!1
s[d]=o.aQ()}for(h=0,a0=0;h<r;++h,a0+=4)for(g=0,a1=0;g<r;++g,a1+=4){for(a2=0,a3=0,a4=0;a4<4;++a4){a5=(h+(a4<2?-1:0)&q)>>>0
a6=(a5+1&q)>>>0
for(i=a0+a4,a7=0;a7<4;++a7){a8=(g+(a7<2?-1:0)&q)>>>0
a9=(a8+1&q)>>>0
n.b=A.aa(a8,a5)<<1>>>0
n.aF()
m.b=A.aa(a9,a5)<<1>>>0
m.aF()
l.b=A.aa(a8,a6)<<1>>>0
l.aF()
k.b=A.aa(a9,a6)<<1>>>0
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
if(c7==null)c7=new A.E()
e=b5*b6+e*d+c*b3+c4*c3-b7
c5=b2*b6+b4*d+c1*b3+c5*c3-b8
c3=b9*b6+b1*d+b0*b3+c2*c3-c0
c8=((B.b.h(c7.gt())*16-b7)*e+(B.b.h(c7.gA())*16-b8)*c5+(B.b.h(c7.gB())*16-c0)*c3)*16
c9=e*e+c5*c5+c3*c3
if(c8>3*c9)++a3
if(c8>8*c9)++a3
if(c8>13*c9)++a3
a3=(a3>>>2|a3<<30)>>>0;++a2}}o.b=A.aa(g,h)<<1>>>0
o.aF()
i=o.b
j&2&&A.b(s)
if(!(i<s.length))return A.a(s,i)
s[i]=a3}return p},
m5(c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1
if(c2.gN()!==c2.gJ())throw A.f(A.l("PVRTC requires a square image."))
s=c2.gN()
if((s&s-1)>>>0!==0)throw A.f(A.l(u.b))
r=B.a.V(c2.gN(),4)
q=r-1
s=B.a.V(c2.gN()*c2.gJ(),2)
p=new Uint8Array(s)
s=J.a1(B.d.gq(p),0,null)
o=new A.a8(s)
n=new A.a8(J.a1(B.d.gq(p),0,null))
m=new A.a8(J.a1(B.d.gq(p),0,null))
l=new A.a8(J.a1(B.d.gq(p),0,null))
k=new A.a8(J.a1(B.d.gq(p),0,null))
for(j=t.R,i=s.$flags|0,h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){d=A.rM(c2,e,g)
o.b=A.aa(f,h)<<1>>>0
o.aF()
o.c=!1
c=o.aQ()
b=o.b+1
i&2&&A.b(s)
if(!(b<s.length))return A.a(s,b)
s[b]=c
c=j.a(d.a)
a=c.d
if(!(a>=0&&a<256))return A.a(B.ay,a)
a0=B.ay[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.M,a)
a2=B.M[a]
if(!(a1>=0&&a1<256))return A.a(B.M,a1)
a3=B.M[a1]
if(!(c>=0&&c<256))return A.a(B.K,c)
o.d=(a2<<9|a3<<4|B.K[c])>>>0
s[b]=o.aQ()
o.e=!0
s[b]=o.aQ()}else{if(!(a>=0&&a<256))return A.a(B.K,a)
a2=B.K[a]
if(!(a1>=0&&a1<256))return A.a(B.K,a1)
a3=B.K[a1]
if(!(c>=0&&c<256))return A.a(B.ay,c)
o.d=(a0<<11|a2<<7|a3<<3|B.ay[c])>>>0
s[b]=o.aQ()
o.e=!1
s[b]=o.aQ()}c=j.a(d.b)
a=c.d
if(!(a>=0&&a<256))return A.a(B.by,a)
a0=B.by[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.x,a)
a2=B.x[a]
if(!(a1>=0&&a1<256))return A.a(B.x,a1)
a3=B.x[a1]
if(!(c>=0&&c<256))return A.a(B.x,c)
o.f=(a2<<10|a3<<5|B.x[c])>>>0
s[b]=o.aQ()
o.r=!0
s[b]=o.aQ()}else{if(!(a>=0&&a<256))return A.a(B.X,a)
a2=B.X[a]
if(!(a1>=0&&a1<256))return A.a(B.X,a1)
a3=B.X[a1]
if(!(c>=0&&c<256))return A.a(B.X,c)
o.f=(a0<<12|a2<<8|a3<<4|B.X[c])>>>0
s[b]=o.aQ()
o.r=!1
s[b]=o.aQ()}}for(h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){for(a4=0,a5=0,a6=0;a6<4;++a6){a7=(h+(a6<2?-1:0)&q)>>>0
a8=(a7+1&q)>>>0
for(j=g+a6,a9=0;a9<4;++a9){b0=(f+(a9<2?-1:0)&q)>>>0
b1=(b0+1&q)>>>0
n.b=A.aa(b0,a7)<<1>>>0
n.aF()
m.b=A.aa(b1,a7)<<1>>>0
m.aF()
l.b=A.aa(b0,a8)<<1>>>0
l.aF()
k.b=A.aa(b1,a8)<<1>>>0
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
b4=new A.R(a*b,a1*b,b2*b,c*b).ah(0,new A.R(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b3=l.bY()
b=B.h[a4][2]
b=b4.ah(0,new A.R(b3.a*b,b3.b*b,b3.c*b,b3.d*b))
b3=k.bY()
b4=B.h[a4][3]
b5=b.ah(0,new A.R(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b4=n.bZ()
b3=B.h[a4][0]
b=b4.a
c=b4.b
b2=b4.c
b4=b4.d
a1=m.bZ()
a=B.h[a4][1]
a=new A.R(b*b3,c*b3,b2*b3,b4*b3).ah(0,new A.R(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a1=l.bZ()
b3=B.h[a4][2]
b3=a.ah(0,new A.R(a1.a*b3,a1.b*b3,a1.c*b3,a1.d*b3))
a1=k.bZ()
a=B.h[a4][3]
b6=b3.ah(0,new A.R(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a=c2.a
b7=a==null?null:a.P(e+a9,j,null)
if(b7==null)b7=new A.E()
a2=A.n(b7.gt())
a3=A.n(b7.gA())
b8=A.n(b7.gB())
a0=A.n(b7.gv())
b9=b6.eI(0,b5)
c0=new A.R(a2*16,a3*16,b8*16,a0*16).eI(0,b5).hx(b9)*16
c1=b9.hx(b9)
if(c0>3*c1)++a5
if(c0>8*c1)++a5
if(c0>13*c1)++a5
a5=(a5>>>2|a5<<30)>>>0;++a4}}o.b=A.aa(f,h)<<1>>>0
o.aF()
j=o.b
i&2&&A.b(s)
if(!(j<s.length))return A.a(s,j)
s[j]=a5}return p}}
A.kw.prototype={
$2(a,b){var s=this.a.aU(this.b+a,this.c+b)
return new A.b3(A.n(s.gt()),A.n(s.gA()),A.n(s.gB()))},
$S:31}
A.kx.prototype={
$2(a,b){var s=this.a.aU(this.b+a,this.c+b)
return new A.R(A.n(s.gt()),A.n(s.gA()),A.n(s.gB()),A.n(s.gv()))},
$S:32}
A.fj.prototype={
bV(a){var s,r,q=this
if(a.c-a.d<18)return
q.a=a.H()
q.b=a.H()
s=a.H()
if(s<12){if(!(s>=0))return A.a(B.bZ,s)
r=B.bZ[s]}else r=B.aC
q.c=r
a.n()
q.e=a.n()
q.f=a.H()
a.n()
a.n()
q.x=a.n()
q.y=a.n()
q.z=a.H()
q.Q=a.H()},
hH(){var s=this,r=s.z
if(r!==8&&r!==16&&r!==24&&r!==32)return!1
r=s.c
if(r===B.N||r===B.O){if(s.e>256||s.b!==1)return!1
r=s.f
if(r!==16&&r!==24&&r!==32)return!1}else if(s.b===1)return!1
return!0},
$iM:1}
A.aC.prototype={
a7(){return"TgaImageType."+this.b}}
A.kC.prototype={
bg(a,b){return A.P(new A.kE(this,a,b),t.H)},
lv(a,b){if(this.aK(a)==null)return null
return this.an(0)},
aK(a){return A.P(new A.kF(this,a),t._)},
lx(a){var s,r,q,p,o=this
o.a=new A.fj(B.aC)
s=A.v(a,!1,null,0)
o.b=s
r=s.af(18)
o.a.bV(r)
s=o.a
if(!s.hH()||s.x<1||s.y<1)return null
q=o.b
q.d+=s.a
p=s.c
if(p===B.N||p===B.O)s.as=q.af(s.e*B.a.j(s.f,3)).Y()
s=o.a
s.ax=o.b.d
return s},
an(a){return A.P(new A.kD(this,a),t.H)},
lw(a){var s=this,r=s.a
if(r==null)return null
A.ax(r.x,r.y,s.c,!1)
r=s.a.c
if(r===B.cC)return s.fe()
else if(r===B.cB||r===B.O)return s.jB()
else if(r===B.N)return s.fe()
return null},
f9(a,b){var s,r,q,p,o,n,m,l=this,k=A.v(a,!1,null,0),j=l.a.f
if(j===16){j=l.b
j===$&&A.c("input")
s=j.n()
r=s>>>7&248
q=s>>>2&248
p=(s&31)<<3
o=(s&32768)!==0?0:255
for(n=0;n<l.a.e;++n){b.bE(n,r)
b.bD(n,q)
b.bC(n,p)
b.bB(n,o)}}else{m=j===32
for(n=0;n<l.a.e;++n){p=J.d(k.a,k.d++)
q=J.d(k.a,k.d++)
r=J.d(k.a,k.d++)
o=m?J.d(k.a,k.d++):255
b.bE(n,r)
b.bD(n,q)
b.bC(n,p)
b.bB(n,o)}}},
jB(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,c=e.a,b=c.z,a=b===16,a0=a||b===32,a1=c.x,a2=c.y,a3=a0?4:3
c=c.c
s=A.V(d,d,B.e,0,B.j,a2,d,0,a3,d,B.e,a1,c===B.N||c===B.O)
c=s.a
if((c==null?d:c.gR())!=null){c=e.a.as
c.toString
a1=s.a
a1=a1==null?d:a1.gR()
a1.toString
e.f9(c,a1)}r=s.gN()
q=s.gJ()-1
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
if(a1!=null)a1.aO(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}else{a1=e.b
if(a){i=a1.n()
l=i>>>7&248
h=i>>>2&248
g=(i&31)<<3
f=(i&32768)!==0?0:255
for(k=0;k<n;++k){j=p+1
a1=s.a
if(a1!=null)a1.aA(p,q,l,h,g,f)
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
if(a1!=null)a1.aA(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}}else if(c)for(k=0;k<n;++k){a1=e.b
l=J.d(a1.a,a1.d++)
j=p+1
a1=s.a
if(a1!=null)a1.aO(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else if(a)for(k=0;k<n;++k){i=e.b.n()
f=(i&32768)!==0?0:255
j=p+1
a1=s.a
if(a1!=null)a1.aA(p,q,i>>>7&248,i>>>2&248,(i&31)<<3,f)
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
if(a1!=null)a1.aA(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}if(p>=r){--q
if(q<0)break
p=0}}return s},
fe(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=d.b
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
m=A.V(c,c,B.e,0,B.j,o,c,0,n,c,B.e,p,s===B.N||s===B.O)
s=d.a
p=s.c
if(p===B.N||p===B.O){s=s.as
s.toString
p=m.a
p=p==null?c:p.gR()
p.toString
d.f9(s,p)}if(r===8)for(l=m.gJ()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
j=J.d(b.a,b.d++)
b=m.a
if(b!=null)b.aO(k,l,j);++k}}else if(b)for(l=m.gJ()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
i=d.b.n()
h=(i&32768)!==0?0:255
b=m.a
if(b!=null)b.aA(k,l,i>>>7&248,i>>>2&248,(i&31)<<3,h);++k}}else for(l=m.gJ()-1;l>=0;--l){k=0
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
if(b!=null)b.aA(k,l,e,f,g,h);++k}}return m}}
A.kE.prototype={
$0(){return this.a.lv(this.b,this.c)},
$S:1}
A.kF.prototype={
$0(){return this.a.lx(this.b)},
$S:5}
A.kD.prototype={
$0(){return this.a.lw(this.b)},
$S:1}
A.kG.prototype={
bR(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null
A.ci(a)
if(a.gL()!==B.e)a=a.aS(B.e)
s=a.a
s=s==null?b:s.gR()
r=s==null?b:s.b
if(r==null)r=a.gad()
q=r===4||r===2
p=q?4:3
o=a.gN()
n=a.gJ()
m=A.a0(!0,18+o*n*p)
l=A.I(18,0,!1,t.p)
B.c.i(l,2,2)
B.c.i(l,12,o&255)
B.c.i(l,13,B.a.j(o,8)&255)
B.c.i(l,14,n&255)
B.c.i(l,15,B.a.j(n,8)&255)
B.c.i(l,16,q?32:24)
m.a2(l)
s=o*p
k=new Uint8Array(s)
if(!a.gaw()){j=a.Y()
i=a.a.gaz()
for(h=n-1;h>=0;--h){A.rS(j,h*i,r,k,p)
m.a2(k)}}else for(h=n-1,g=b;h>=0;--h){f=a.a
g=f==null?b:f.P(0,h,g)
if(g==null)g=new A.E()
for(e=0,d=0;e<o;++e,g.E()){c=d+1
f=B.b.h(g.gB())
if(!(d<s))return A.a(k,d)
k[d]=f
d=c+1
f=B.b.h(g.gA())
if(!(c<s))return A.a(k,c)
k[c]=f
c=d+1
f=B.b.h(g.gt())
if(!(d<s))return A.a(k,d)
k[d]=f
if(q){d=c+1
f=B.b.h(g.gv())
if(!(c<s))return A.a(k,c)
k[c]=f}else d=c}m.a2(k)}return J.C(B.d.gq(m.c),0,m.a)}}
A.kH.prototype={
ar(a){var s,r,q,p,o,n=this
if(a===0)return 0
if(n.c===0){n.c=8
n.b=n.a.H()}for(s=n.a,r=0;q=n.c,a>q;){p=B.a.U(r,q)
o=n.b
if(!(q>=0&&q<9))return A.a(B.E,q)
r=p+(o&B.E[q])
a-=q
n.c=8
n.b=J.d(s.a,s.d++)}if(a>0){if(q===0){n.c=8
n.b=s.H()}s=B.a.U(r,a)
q=n.b
p=n.c-a
q=B.a.aJ(q,p)
if(!(a<9))return A.a(B.E,a)
r=s+(q&B.E[a])
n.c=p}return r}}
A.ii.prototype={
D(a){var s=this,r=s.a,q=$.mz().l(0,r)
if(q!=null)return q.a+": "+s.b.D(0)+" "+s.c
return"<"+r+">: "+s.b.D(0)+" "+s.c},
bs(){var s,r,q,p,o,n,m=this,l=m.e
if(l!=null)return l
l=m.f
s=m.d
l.d=s
r=m.c
q=m.b
p=q!==B.f
if(p){o=q.a
if(!(o<14))return A.a(B.r,o)
o=B.r[o]}else o=0
if(r*o>l.c-s)throw A.f(A.l("Invalid TIFF tag "+m.a+" count: "+r))
if(p){s=q.a
if(!(s<14))return A.a(B.r,s)
s=B.r[s]}else s=0
n=l.af(r*s)
switch(q.a){case 1:return m.e=new A.bg(new Uint8Array(A.p(n.af(r).Y())))
case 2:return m.e=new A.cv(r===0?"":n.au(r-1))
case 7:return m.e=new A.bg(new Uint8Array(A.p(n.af(r).Y())))
case 3:return m.e=A.og(n,r)
case 4:return m.e=A.ob(n,r)
case 5:return m.e=A.oc(n,r)
case 11:return m.e=A.oh(n,r)
case 12:return m.e=A.oa(n,r)
case 6:return m.e=new A.bu(new Int8Array(A.p(J.mA(B.d.gq(n.Y()),0,r))))
case 8:return m.e=A.of(n,r)
case 9:return m.e=A.od(n,r)
case 10:return m.e=A.oe(n,r)
case 13:case 0:return null}}}
A.kM.prototype={
lX(a,b,c,d){var s,r,q,p=this
p.r=b
p.x=p.w=0
s=B.a.V(p.a+7,8)
for(r=0,q=0;q<d;++q){p.dT(a,r,c)
r+=s}},
dT(a,b,c){var s,r,q,p,o,n,m,l,k=this
k.d=0
for(s=k.a,r=!0;c<s;){while(r){q=k.c4(10)
if(!(q<1024))return A.a(B.at,q)
p=B.at[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|k.bc(2))>>>0
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
n=B.a.j(p,1)
c+=B.a.j(p,4)&4095
k.aM(4-(n&7))}else if(o===0)throw A.f(A.l("TIFFFaxDecoder0"))
else if(o===15)throw A.f(A.l("TIFFFaxDecoder1"))
else{c+=B.a.j(p,5)&2047
k.aM(10-o)
if((p&1)===0){B.c.i(k.f,k.d++,c)
r=!1}}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}while(!r){q=k.bc(4)
if(!(q<16))return A.a(B.aj,q)
p=B.aj[q]
m=p>>>5&2047
l=!0
if(m===100){q=k.c4(9)
if(!(q<512))return A.a(B.an,q)
p=B.an[q]
o=B.a.j(p,1)&15
m=B.a.j(p,5)&2047
if(o===12){k.aM(5)
q=k.bc(4)
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
n=B.a.j(p,1)
m=B.a.j(p,4)&4095
k.bi(a,b,c,m)
c+=m
k.aM(4-(n&7))}else if(o===15)throw A.f(A.l("TIFFFaxDecoder2"))
else{k.bi(a,b,c,m)
c+=m
k.aM(9-o)
if((p&1)===0){B.c.i(k.f,k.d++,c)
r=l}}}else{if(m===200){q=k.bc(2)
if(!(q<4))return A.a(B.ai,q)
p=B.ai[q]
m=p>>>5&2047
k.bi(a,b,c,m)
c+=m
k.aM(2-(p>>>1&15))
B.c.i(k.f,k.d++,c)}else{k.bi(a,b,c,m)
c+=m
k.aM(4-(p>>>1&15))
B.c.i(k.f,k.d++,c)}r=l}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}}B.c.i(k.f,k.d++,c)},
lY(a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
a0.r=a2
a0.z=3
a0.x=a0.w=0
s=a0.a
r=B.a.V(s+7,8)
q=A.I(2,null,!1,t.I)
a0.at=a5&1
a0.as=a5>>>2&1
if(a0.fH()!==1)throw A.f(A.l("TIFFFaxDecoder3"))
a0.dT(a1,0,a3)
for(p=r,o=1;o<a4;++o){if(a0.fH()===0){n=a0.e
a0.e=a0.f
a0.f=n
a0.y=0
m=a3
l=-1
k=!0
j=0
for(;;){m.toString
if(!(m<s))break
a0.fp(l,k,q)
i=q[0]
h=q[1]
g=a0.bc(7)
if(!(g<128))return A.a(B.ar,g)
g=B.ar[g]&255
f=g>>>3&15
e=g&7
if(f===0){if(!k){h.toString
a0.bi(a1,p,m,h-m)}a0.aM(7-e)
m=h
l=m}else if(f===1){a0.aM(7-e)
d=j+1
c=d+1
if(k){m+=a0.de()
B.c.i(a0.f,j,m)
b=a0.dd()
a0.bi(a1,p,m,b)
m+=b
B.c.i(a0.f,d,m)}else{b=a0.dd()
a0.bi(a1,p,m,b)
m+=b
B.c.i(a0.f,j,m)
m+=a0.de()
B.c.i(a0.f,d,m)}j=c
l=m}else{if(f<=8){i.toString
a=i+(f-5)
d=j+1
B.c.i(a0.f,j,a)
k=!k
if(k)a0.bi(a1,p,m,a-m)
a0.aM(7-e)}else throw A.f(A.l("TIFFFaxDecoder4"))
m=a
j=d
l=m}}B.c.i(a0.f,j,m)
a0.d=j+1}else a0.dT(a1,p,a3)
p+=r}},
m3(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.r=a6
a4.z=4
a4.x=a4.w=0
s=a4.a
r=B.a.V(s+7,8)
q=A.I(2,null,!1,t.I)
p=a4.f
a4.d=0
a4.d=1
B.c.i(p,0,s)
B.c.i(p,a4.d++,s)
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
a4.fp(k,j,q)
h=q[0]
g=q[1]
f=a4.bc(7)
if(!(f<128))return A.a(B.ar,f)
f=B.ar[f]&255
e=f>>>3&15
d=f&7
if(e===0){if(!j){g.toString
a4.bi(a5,o,l,g-l)}a4.aM(7-d)
l=g
k=l}else if(e===1){a4.aM(7-d)
c=i+1
b=c+1
if(j){l+=a4.de()
B.c.i(m,i,l)
a=a4.dd()
a4.bi(a5,o,l,a)
l+=a
B.c.i(m,c,l)}else{a=a4.dd()
a4.bi(a5,o,l,a)
l+=a
B.c.i(m,i,l)
l+=a4.de()
B.c.i(m,c,l)}i=b
k=l}else if(e<=8){h.toString
a0=h+(e-5)
c=i+1
B.c.i(m,i,a0)
j=!j
if(j)a4.bi(a5,o,l,a0-l)
a4.aM(7-d)
l=a0
i=c
k=l}else if(e===11){if(a4.bc(3)!==7)throw A.f(A.l("TIFFFaxDecoder5"))
for(a1=0,a2=!1;!a2;j=a3){while(a4.bc(1)!==1)++a1
if(a1>5){a1-=6
if(!j&&a1>0){c=i+1
B.c.i(m,i,l)
i=c}l+=a1
if(a1>0)j=!0
a3=a4.bc(1)===0
if(a3){if(!j){c=i+1
B.c.i(m,i,l)
i=c}}else if(j){c=i+1
B.c.i(m,i,l)
i=c}j=a3
a2=!0}a3=a1===5
if(a3){if(!j){c=i+1
B.c.i(m,i,l)
i=c}l+=a1}else{l+=a1
c=i+1
B.c.i(m,i,l)
a4.bi(a5,o,l,1);++l
i=c}}}else throw A.f(A.l("TIFFFaxDecoder5 "+e))}B.c.i(m,i,l)
a4.d=i+1
o+=r}},
de(){var s,r,q,p,o,n,m=this
for(s=0,r=!0;r;){q=m.c4(10)
if(!(q<1024))return A.a(B.at,q)
p=B.at[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|m.bc(2))>>>0
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
n=B.a.j(p,1)
s+=B.a.j(p,4)&4095
m.aM(4-(n&7))}else if(o===0)throw A.f(A.l("TIFFFaxDecoder0"))
else if(o===15)throw A.f(A.l("TIFFFaxDecoder1"))
else{s+=B.a.j(p,5)&2047
m.aM(10-o)
if((p&1)===0)r=!1}}return s},
dd(){var s,r,q,p,o,n,m,l=this
for(s=0,r=!1;!r;){q=l.bc(4)
if(!(q<16))return A.a(B.aj,q)
p=B.aj[q]
o=p>>>5&2047
if(o===100){q=l.c4(9)
if(!(q<512))return A.a(B.an,q)
p=B.an[q]
n=B.a.j(p,1)&15
m=B.a.j(p,5)
if(n===12){l.aM(5)
q=l.bc(4)
if(!(q<16))return A.a(B.L,q)
p=B.L[q]
m=B.a.j(p,1)
s+=B.a.j(p,4)&4095
l.aM(4-(m&7))}else if(n===15)throw A.f(A.l("TIFFFaxDecoder2"))
else{s+=m&2047
l.aM(9-n)
if((p&1)===0)r=!0}}else{if(o===200){q=l.bc(2)
if(!(q<4))return A.a(B.ai,q)
p=B.ai[q]
s+=p>>>5&2047
l.aM(2-(p>>>1&15))}else{s+=o
l.aM(4-(p>>>1&15))}r=!0}}return s},
fH(){var s,r,q=this,p="TIFFFaxDecoder8",o=q.as
if(o===0){if(q.c4(12)!==1)throw A.f(A.l("TIFFFaxDecoder6"))}else if(o===1){o=q.w
o.toString
s=8-o
if(q.c4(s)!==0)throw A.f(A.l(p))
if(s<4)if(q.c4(8)!==0)throw A.f(A.l(p))
while(r=q.c4(8),r!==1)if(r!==0)throw A.f(A.l(p))}if(q.at===0)return 1
else return q.bc(1)},
fp(a,b,c){var s,r,q,p,o,n,m=this
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
B.c.i(c,0,n)
break}}n=o+1
if(n<r){if(!(n<q))return A.a(s,n)
B.c.i(c,1,s[n])}},
bi(a,b,c,d){var s,r,q,p,o,n=8*b+A.n(c),m=n+d,l=B.a.j(n,3),k=n&7
if(k>0){s=B.a.U(1,7-k)
r=J.d(a.a,a.d+l)
for(;;){if(!(s>0&&n<m))break
r=(r|s)>>>0
s=s>>>1;++n}a.i(0,l,r)}l=B.a.j(n,3)
for(q=m-7;n<q;l=p){p=l+1
J.a_(a.a,a.d+l,255)
n+=8}while(n<m){l=B.a.j(n,3)
q=J.d(a.a,a.d+l)
o=B.a.U(1,7-(n&7))
J.a_(a.a,a.d+l,(q|o)>>>0);++n}},
c4(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.r
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
n=B.a0[J.d(e.a,e.d+(q+2))&255]}}}else throw A.f(A.l("TIFFFaxDecoder7"))
e=f.w
e.toString
l=8-e
k=a-l
if(k>8){j=k-8
i=8}else{i=k
j=0}e=f.x
e.toString
e=f.x=e+1
if(!(l>=0&&l<9))return A.a(B.E,l)
h=B.a.U(m&B.E[l],k)
if(!(i>=0))return A.a(B.Z,i)
g=B.a.a0(o&B.Z[i],8-i)
if(j!==0){g=B.a.U(g,j)
if(!(j<9))return A.a(B.Z,j)
g|=B.a.a0(n&B.Z[j],8-j)
f.x=e+1
f.w=j}else if(i===8){f.w=0
f.x=e+1}else f.w=i
return(h|g)>>>0},
bc(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.r
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
o=B.a0[J.d(h.a,h.d+(q+1))&255]}}else throw A.f(A.l("TIFFFaxDecoder7"))
h=i.w
h.toString
m=8-h
l=a-m
k=m-a
if(k>=0){if(!(m>=0&&m<9))return A.a(B.E,m)
j=B.a.a0(n&B.E[m],k)
h+=a
i.w=h
if(h===8){i.w=0
h=i.x
h.toString
i.x=h+1}}else{if(!(m>=0&&m<9))return A.a(B.E,m)
j=B.a.U(n&B.E[m],-k)
if(!(l>=0&&l<9))return A.a(B.Z,l)
j=(j|B.a.a0(o&B.Z[l],8-l))>>>0
h=i.x
h.toString
i.x=h+1
i.w=l}return j},
aM(a){var s,r=this,q=r.w
q.toString
s=q-a
if(s<0){q=r.x
q.toString
r.x=q-1
r.w=8+s}else r.w=s}}
A.ij.prototype={
iF(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=A.w(a0,c,0),a=a0.n()
for(s=d.a,r=0;r<a;++r){q=a0.n()
p=a0.n()
o=a0.k()
if(p>13){a0.d+=4
continue}n=B.bV[p]
if(o*B.r[p]>4)m=a0.k()
else{m=a0.d
a0.d=m+4}l=new A.ii(q,n,o,m,b)
s.i(0,q,l)
if(q===256){k=l.bs()
k=k==null?c:k.h(0)
d.b=k==null?0:k}else if(q===257){k=l.bs()
k=k==null?c:k.h(0)
d.c=k==null?0:k}else if(q===262){j=l.bs()
i=j==null?c:j.h(0)
if(i==null)i=17
if(i<17){if(!(i>=0))return A.a(B.bQ,i)
d.d=B.bQ[i]}else d.d=B.b1}else if(q===259){k=l.bs()
k=k==null?c:k.h(0)
d.e=k==null?0:k}else if(q===258){k=l.bs()
k=k==null?c:k.h(0)
d.f=k==null?0:k}else if(q===277){k=l.bs()
k=k==null?c:k.h(0)
d.r=k==null?0:k}else if(q===317){k=l.bs()
k=k==null?c:k.h(0)
d.Q=k==null?0:k}else if(q===339){k=l.bs()
j=k==null?c:k.h(0)
if(j==null)j=0
if(!(j>=0&&j<4))return A.a(B.bU,j)
d.x=B.bU[j]}else if(q===320){j=l.bs()
if(j!=null){k=J.qi(B.d.gq(j.bu()))
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
if(s.ac(324)){d.ay=d.cs(322)
d.ch=d.cs(323)
d.CW=d.dn(324)
d.cx=d.dn(325)}else{d.ay=d.dm(322,d.b)
if(!s.ac(278))k=d.ch=d.dm(323,d.c)
else{e=d.cs(278)
if(e===-1){k=d.c
d.ch=k}else{d.ch=e
k=e}}h=d.c
if(k>h)d.ch=h
d.CW=d.dn(273)
d.cx=d.dn(279)}k=d.b
h=d.ay
d.cy=B.a.aa(k+h-1,h)
h=d.c
k=d.ch
d.db=B.a.aa(h+k-1,k)
d.dy=d.dm(266,1)
d.fr=d.cs(292)
d.fx=d.cs(293)
d.cs(338)
switch(d.d.a){case 0:case 1:s=d.f
if(s===1&&d.r===1)d.y=B.b_
else if(s===4&&d.r===1)d.y=B.lB
else if(B.a.a5(s,8)===0){s=d.r
if(s===1)d.y=B.lC
else if(s===2)d.y=B.lD
else d.y=B.ab}break
case 2:if(B.a.a5(d.f,8)===0){s=d.r
if(s===3)d.y=B.cD
else if(s===4)d.y=B.lF
else d.y=B.ab}break
case 3:s=!1
if(d.r===1)if(d.id!=null){s=d.f
s=s===4||s===8||s===16}if(s)d.y=B.lE
break
case 4:if(d.f===1&&d.r===1)d.y=B.b_
break
case 6:if(d.e===7&&d.f===8&&d.r===3)d.y=B.cD
else{if(s.ac(530)){j=s.l(0,530).bs()
d.as=j.h(0)
s=d.at=j.ag(0,1)}else s=d.at=d.as=2
k=d.as
k===$&&A.c("chromaSubH")
if(k*s===1)d.y=B.ab
else if(d.f===8&&d.r===3)d.y=B.lG}break
case 5:if(B.a.a5(d.f,8)===0)d.y=B.ab
s=d.r
if(s===4)d.w=3
else if(s===5)d.w=4
break
default:if(B.a.a5(d.f,8)===0)d.y=B.ab
break}},
cz(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.x,a1=a0===B.a1,a2=a0===B.i
a0=b.f
if(a0===1)s=B.A
else if(a0===2)s=B.w
else{if(a0===4)a0=B.B
else if(a1&&a0===16)a0=B.H
else if(a1&&a0===32)a0=B.I
else if(a1&&a0===64)a0=B.Q
else if(a2&&a0===8)a0=B.U
else if(a2&&a0===16)a0=B.V
else if(a2&&a0===32)a0=B.W
else if(a0===16)a0=B.n
else a0=a0===32?B.R:B.e
s=a0}r=b.id!=null&&b.d===B.b2
q=r?3:b.w
a0=b.b
p=A.V(a,a,s,0,B.j,b.c,a,0,q,a,s,a0,r)
if(r){a0=p.a
a0=a0==null?a:a0.gR()
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
a0.ba(f,l,o[h],o[i])}}e=0
d=0
for(;;){a0=b.db
a0===$&&A.c("tilesY")
if(!(e<a0))break
c=0
for(;;){a0=b.cy
a0===$&&A.c("tilesX")
if(!(c<a0))break
b.jC(a3,p,c,e);++c;++d}++e}return p},
jC(b5,b6,b7,b8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3=this,b4=null
if(b3.y===B.b_){b3.jn(b5,b6,b7,b8)
return}p=b3.cy
p===$&&A.c("tilesX")
o=b8*p+b7
p=b3.CW
if(!(o>=0&&o<p.length))return A.a(p,o)
b5.d=p[o]
p=b3.ay
n=b7*p
m=b3.ch
l=b8*m
k=b3.cx
if(!(o<k.length))return A.a(k,o)
s=k[o]
j=p*m*b3.r
p=b3.f
m=p===16
if(m)j*=2
else if(p===32)j*=4
r=null
if(p===8||m||p===32||p===64){p=b3.e
if(p===1)r=b5
else if(p===5){r=A.v(new Uint8Array(j),!1,b4,0)
q=A.ot()
try{q.hu(A.w(b5,s,0),r.a)}catch(i){}if(b3.Q===2)for(h=0;h<b3.ch;++h){g=b3.r
p=b3.ay
f=g*(h*p+1)
e=p*g
for(;g<e;++g){p=r
m=J.d(p.a,p.d+f)
k=r
d=b3.r
d=J.d(k.a,k.d+(f-d))
J.a_(p.a,p.d+f,m+d);++f}}}else if(p===32773){r=A.v(new Uint8Array(j),!1,b4,0)
b3.fd(b5,j,r.a)}else if(p===32946||p===8){c=b5.eq(0,0,s)
p=b3.f
b=p<8?1:B.a.j(p+7,3)
r=A.v(A.iV(c,b3.ay*b3.ch*b3.r*b),!1,b4,0)}else if(p===6||p===7){c=b5.eq(0,0,s)
a=A.oq().cz(t.D.a(c))
if(a!=null)b3.kr(a,b6,n,l,b3.ay,b3.ch)
return}else throw A.f(A.l("Unsupported Compression Type: "+p))
a0=A.j([0,0,0],t.t)
for(a1=l,a2=0;a2<b3.ch;++a2,++a1)for(a3=n,a4=0;a4<b3.ay;++a4,++a3){p=r
if(p.d>=p.c||a3>=b3.b||a1>=b3.c)break
p=b3.r
if(p===1){p=b3.x
if(p===B.a1){p=b3.f
if(p===32){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.cl()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else if(p===64)a5=r.dD()
else if(p===16){p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
a5=m[p]}else a5=0
if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aO(a3,a1,a5)}}else{m=b3.f
if(m===8)if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}else if(m===16)if(p===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.n()
else if(m===32)if(p===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()
else a5=0
if(b3.d===B.b0){p=b6.a
a6=p==null?b4:p.gG()
a5=(a6==null?0:a6)-a5}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aO(a3,a1,a5)}}}else if(p===2){p=b3.f
if(p===8){if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}}else if(p===16){if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.n()
if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.n()}else if(p===32){if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()}else{a7=0
a8=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aA(a3,a1,a7,0,0,a8)}}else if(p===3){p=b3.x
if(p===B.a1){p=b3.f
if(p===32){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.cl()
if(0>=p.length)return A.a(p,0)
a9=p[0]
m[0]=r.k()
b0=p[0]
m[0]=r.k()
b1=p[0]}else{b0=0
b1=0
if(p===64)a9=r.dD()
else if(p===16){p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
a9=m[p]
p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
b0=m[p]
p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
b1=m[p]}else a9=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aP(a3,a1,a9,b0,b1)}}else{m=b3.f
if(m===8){if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else{p=r
a9=J.d(p.a,p.d++)}if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
b0=p[0]}else{p=r
b0=J.d(p.a,p.d++)}if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
b1=p[0]}else{p=r
b1=J.d(p.a,p.d++)}}else if(m===16){if(p===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.n()
if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
b0=p[0]}else b0=r.n()
if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
b1=p[0]}else b1=r.n()}else if(m===32){if(p===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.k()
if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
b0=p[0]}else b0=r.k()
if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
b1=p[0]}else b1=r.k()}else{a9=0
b0=0
b1=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aP(a3,a1,a9,b0,b1)}}}else if(p>=4)if(b3.x===B.a1){p=b3.f
if(p===32){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.cl()
if(0>=p.length)return A.a(p,0)
a9=p[0]
m[0]=r.k()
b0=p[0]
m[0]=r.k()
b1=p[0]
m[0]=r.k()
b2=p[0]}else{b0=0
b1=0
b2=0
if(p===64)a9=r.dD()
else if(p===16){p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
a9=m[p]
p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
b0=m[p]
p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
b1=m[p]
p=r.n()
m=$.N
m=m!=null?m:A.Q()
if(!(p<m.length))return A.a(m,p)
b2=m[p]}else a9=0}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aA(a3,a1,a9,b0,b1,b2)}}else{p=b6.a
a8=p==null?b4:p.gG()
if(a8==null)a8=0
p=b3.f
if(p===8){if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else{p=r
a9=J.d(p.a,p.d++)}if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
b0=p[0]}else{p=r
b0=J.d(p.a,p.d++)}if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
b1=p[0]}else{p=r
b1=J.d(p.a,p.d++)}if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
b2=p[0]}else{p=r
b2=J.d(p.a,p.d++)}if(b3.r===5)if(b3.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.az()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aH()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}}else if(p===16){if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.n()
if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
b0=p[0]}else b0=r.n()
if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
b1=p[0]}else b1=r.n()
if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
b2=p[0]}else b2=r.n()
if(b3.r===5)if(b3.x===B.i){p=r.n()
m=$.ay()
m.$flags&2&&A.b(m)
m[0]=p
p=$.aG()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.n()}else if(p===32){if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.k()
if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
b0=p[0]}else b0=r.k()
if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
b1=p[0]}else b1=r.k()
if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
b2=p[0]}else b2=r.k()
if(b3.r===5)if(b3.x===B.i){p=r.k()
m=$.U()
m.$flags&2&&A.b(m)
m[0]=p
p=$.ab()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()}else{a9=0
b0=0
b1=0
b2=0}if(b3.d===B.cE){A.ps(a9,b0,b1,b2,a0)
a9=a0[0]
b0=a0[1]
b1=a0[2]
b2=a8}if(a3<b3.b&&a1<b3.c){p=b6.a
if(p!=null)p.aA(a3,a1,a9,b0,b1,b2)}}}}else throw A.f(A.l("Unsupported bitsPerSample: "+p))},
kr(a,b,c,d,e,f){var s,r,q,p
for(s=0;s<f;++s)for(r=s+d,q=0;q<e;++q){p=a.a
p=p==null?null:p.P(q,s,null)
if(p==null)p=new A.E()
b.c8(q+c,r,p)}},
jn(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=null,a4=a2.cy
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
if(n===32773){l=B.a.a5(a4,8)===0?B.a.V(a4,8)*p:(B.a.V(a4,8)+1)*p
s=A.v(new Uint8Array(a4*p),!1,a3,0)
a2.fd(a5,l,s.a)}else if(n===5){s=A.v(new Uint8Array(a4*p),!1,a3,0)
A.ot().hu(A.w(a5,m,0),s.a)
if(a2.Q===2)for(k=0;k<a2.c;++k){j=a2.r
i=j*(k*a2.b+1)
for(;j<a2.b*a2.r;++j){a4=s
p=J.d(a4.a,a4.d+i)
n=s
h=a2.r
h=J.d(n.a,n.d+(i-h))
J.a_(a4.a,a4.d+i,p+h);++i}}}else if(n===2){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.n9(a2.dy,a4,p).lX(s,a5,0,a2.ch)}catch(g){}}else if(n===3){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.n9(a2.dy,a4,p).lY(s,a5,0,a2.ch,a2.fr)}catch(g){}}else if(n===4){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.n9(a2.dy,a4,p).m3(s,a5,0,a2.ch,a2.fx)}catch(g){}}else if(n===8||n===32946)s=A.v(A.iV(a5.eq(0,0,m),B.a.j(a2.ay+7,3)*a2.ch),!1,a3,0)
else if(n===1)s=a5
else throw A.f(A.l("Unsupported Compression Type: "+n))
f=new A.kH(s)
e=a6.gG()
a4=a2.z
d=a4?e:0
c=a4?0:e
for(b=o,a=0;a<a2.ch;++a,++b){for(a0=q,a1=0;a1<a2.ay;++a1,++a0){a4=a6.a
p=a4==null
n=p?a3:a4.b
if(b<(n==null?0:n)){a4=p?a3:a4.a
a4=a0>=(a4==null?0:a4)}else a4=!0
if(a4)break
a4=f.ar(1)
p=a6.a
if(a4===0){if(p!=null)p.aP(a0,b,d,0,0)}else if(p!=null)p.aP(a0,b,c,0,0)}f.c=0}},
fd(a,b,c){var s,r,q,p,o,n,m,l,k,j
t.L.a(c)
for(s=J.aV(c),r=0,q=0;q<b;){p=r+1
o=J.d(a.a,a.d+r)
n=$.az()
n.$flags&2&&A.b(n)
n[0]=o
o=$.aH()
if(0>=o.length)return A.a(o,0)
m=o[0]
if(m>=0&&m<=127)for(o=m+1,r=p,l=0;l<o;++l,q=k,r=p){k=q+1
p=r+1
s.i(c,q,J.d(a.a,a.d+r))}else{o=m<=-1&&m>=-127
r=p+1
if(o){j=J.d(a.a,a.d+p)
for(o=-m+1,l=0;l<o;++l,q=k){k=q+1
s.i(c,q,j)}}}}},
dm(a,b){var s=this.a
if(!s.ac(a))return b
s=s.l(0,a).bs()
s=s==null?null:s.h(0)
return s==null?0:s},
cs(a){return this.dm(a,0)},
dn(a){var s,r=this.a
if(!r.ac(a))return null
s=r.l(0,a)
r=s.bs()
r.toString
return A.os(s.c,r.gbJ(r),t.p)}}
A.cS.prototype={
a7(){return"TiffFormat."+this.b}}
A.ac.prototype={
a7(){return"TiffPhotometricType."+this.b}}
A.b6.prototype={
a7(){return"TiffImageType."+this.b}}
A.ik.prototype={$iM:1}
A.k_.prototype={
hu(a,b){var s,r,q,p,o,n,m,l,k=this,j="_bufferLength"
t.L.a(b)
k.r=b
s=J.bC(b)
k.w=0
r=t.D.a(a.a)
k.e=r
q=k.f=r.length
k.b=a.d
if(0>=q)return A.a(r,0)
if(r[0]===0){if(1>=q)return A.a(r,1)
r=r[1]===1}else r=!1
if(r)throw A.f(A.l("Invalid LZW Data"))
k.fw()
k.d=k.c=0
p=k.e2()
r=k.x
o=0
for(;;){if(!(p!==257&&k.w<s))break
if(p===256){k.fw()
p=k.e2()
k.as=0
if(p===257)break
J.a_(k.r,k.w++,p)
o=p}else{q=k.Q
q.toString
if(p<q){k.fs(p)
q=k.as
q===$&&A.c(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.a_(q,m,r[n])}q=k.as-1
if(!(q>=0&&q<4096))return A.a(r,q)
k.eQ(o,r[q])}else{k.fs(o)
q=k.as
q===$&&A.c(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.a_(q,m,r[n])}q=k.r
m=k.w++
l=k.as-1
if(!(l>=0&&l<4096))return A.a(r,l)
J.a_(q,m,r[l])
l=k.as-1
if(!(l>=0&&l<4096))return A.a(r,l)
k.eQ(o,r[l])}o=p}p=k.e2()}},
eQ(a,b){var s,r=this,q=r.y
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
fs(a){var s,r,q,p,o,n,m,l=this
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
e2(){var s,r,q,p,o=this,n=o.b,m=o.f
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
n=B.a.a0(o.c,n)
r-=9
if(!(r>=0&&r<4))return A.a(B.bz,r)
return n&B.bz[r]},
fw(){var s,r,q=this
q.y=new Uint8Array(4096)
s=new Uint32Array(4096)
q.z=s
B.o.a8(s,0,4096,4098)
for(s=q.y,r=0;r<256;++r){s.$flags&2&&A.b(s)
s[r]=r}q.a=9
q.Q=258}}
A.kI.prototype={
an(a){return A.P(new A.kJ(this,a),t.H)},
lz(a){var s,r,q=this.a
if(q==null)return null
q=q.f
if(!(a<q.length))return A.a(q,a)
s=q[a]
q=this.d
A.ax(s.b,s.c,q,!1)
A.ax(s.ay,s.ch,q,!1)
q=this.c
q===$&&A.c("_input")
r=s.cz(q)
return r},
bg(a,b){return A.P(new A.kK(this,a,b),t.H)},
ly(a,b){var s,r,q,p,o,n,m=this,l=null,k=A.v(a,!1,l,0)
m.c=k
k=m.a=m.l3(k)
if(k==null)return l
k=k.f
s=k.length
r=new A.bO(m.d)
for(q=0;q<k.length;k.length===s||(0,A.L)(k),++q){p=k[q]
r.ce(0,p.b,p.c)}o=m.an(0)
if(o==null)return l
o.e=A.mF(A.v(a,!1,l,0))
o.w=B.bh
for(n=1;n<s;++n)o.aR(m.an(n))
return o},
fJ(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=null,f=A.j([],t.fZ),e=new A.ik(f),d=a.c
if(d-a.d<8)return g
q=a.n()
if(q!==18761&&q!==19789)return g
if(q===19789)a.e=!0
else a.e=!1
p=a.n()
e.d=p
if(p!==42)return g
o=a.k()
n=A.w(a,g,0)
n.d=o
s=n
p=t.p
m=A.mP(p)
l=t.e8
for(;;){if(!(o!==0&&o<d&&f.length<1024&&m.C(0,o)))break
r=null
try{k=new A.ij(A.J(p,l),B.b1,B.aZ,B.lH)
k.iF(s)
r=k
j=r
if(!(j.b!==0&&j.c!==0))break}catch(i){break}B.c.C(f,r)
j=f.length
if(j===1){if(0>=j)return A.a(f,0)
h=f[0]
e.a=h.b
if(0>=j)return A.a(f,0)
e.b=h.c}if(b)break
o=s.k()
if(o!==0)s.d=o}return f.length!==0?e:g},
l3(a){return this.fJ(a,!1)}}
A.kJ.prototype={
$0(){return this.a.lz(this.b)},
$S:1}
A.kK.prototype={
$0(){return this.a.ly(this.b,this.c)},
$S:1}
A.kL.prototype={
bR(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e="ifd0"
A.ci(a)
s=new A.bE(A.J(t.N,t.P))
if(a.e!=null)s.l(0,e).ht(a.gbh().l(0,e))
if(a.gb4())a=a.aS(B.e)
if(a.gad()===1)r=1
else r=a.gaw()?3:2
q=a.gad()
p=s.l(0,e)
p.i(0,"ImageWidth",a.gN())
p.i(0,"ImageHeight",a.gJ())
p.i(0,"BitsPerSample",a.gaN())
p.i(0,"SampleFormat",this.ka(a).a)
p.i(0,"SamplesPerPixel",a.gaw()?1:q)
p.i(0,"Compression",1)
p.i(0,"PhotometricInterpretation",r)
p.i(0,"RowsPerStrip",a.gJ())
p.i(0,"PlanarConfiguration",1)
p.i(0,"TileWidth",a.gN())
p.i(0,"TileLength",a.gJ())
p.i(0,"StripByteCounts",a.gcA(0))
p.i(0,"StripOffsets",new A.c5(a.Y()))
if(a.gaw()){o=a.a
n=o==null?null:o.gR()
m=n.a
o=m*3
l=new Uint16Array(o)
for(k=0,j=0;k<3;++k)for(i=0;i<m;++i,j=h){h=j+1
g=B.b.h(n.aY(i,k))
if(!(j>=0&&j<o))return A.a(l,j)
l[j]=g<<8>>>0}p.i(0,"ColorMap",l)}f=A.a0(!1,a.gcA(0)+8192)
s.aX(f)
return J.C(B.d.gq(f.c),0,f.a)},
ka(a){var s=a.a
s=s==null?null:s.gbr()
switch((s==null?B.P:s).a){case 0:return B.aZ
case 1:return B.i
case 2:return B.a1}}}
A.kQ.prototype={
cY(){var s,r=this.a,q=r.bt()
if((q&1)!==0)return!1
if((q>>>1&7)>3)return!1
if((q>>>4&1)===0)return!1
this.f.d=q>>>5
if(r.bt()!==2752925)return!1
s=this.b
s.a=r.n()
s.b=r.n()
return!0},
bQ(){var s,r,q,p,o=this,n=null
if(!o.k8())return n
s=o.b
r=s.a
o.d=A.V(n,n,B.e,0,B.j,s.b,n,0,4,n,B.e,r,!1)
o.kk()
if(!o.kz())return n
r=s.w
if(r.length!==0){q=A.v(new A.ah(r),!1,n,0)
r=o.d
r.toString
r.e=A.mF(q)}p=s.r
if(p!=null)o.d.c=new A.bH("ICC_PROFILE",B.S,p)
return o.d},
k8(){var s,r,q,p,o=this
if(!o.cY())return!1
o.fr=A.tD()
for(s=o.dy,r=0;r<4;++r){q=new Int32Array(2)
p=new Int32Array(2)
B.c.i(s,r,new A.iv(q,p,new Int32Array(2)))}o.y=o.Q=0
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
p=A.oL(s.aH(p))
o.c=p
s.d+=q.d
p.a4(1)
o.c.a4(1)
o.kF(o.x,o.fr)
o.ky()
if(!o.kB(s))return!1
o.kD()
o.c.a4(1)
o.kC()
return!0},
kF(a,b){var s,r,q,p=this,o=p.c
o===$&&A.c("br")
o=o.a4(1)!==0
a.a=o
if(o){a.b=p.c.a4(1)!==0
if(p.c.a4(1)!==0){a.c=p.c.a4(1)!==0
for(o=a.d,s=0;s<4;++s){if(p.c.a4(1)!==0){r=p.c
q=r.a4(7)
r=r.a4(1)===1?-q:q}else r=0
o.$flags&2&&A.b(o)
o[s]=r}for(o=a.e,s=0;s<4;++s){if(p.c.a4(1)!==0){r=p.c
q=r.a4(6)
r=r.a4(1)===1?-q:q}else r=0
o.$flags&2&&A.b(o)
o[s]=r}}if(a.b)for(s=0;s<3;++s){o=b.a
r=p.c.a4(1)!==0?p.c.a4(8):255
o.$flags&2&&A.b(o)
o[s]=r}}else a.b=!1
return!0},
ky(){var s,r,q,p=this,o=p.w,n=p.c
n===$&&A.c("br")
o.a=n.a4(1)!==0
o.b=p.c.a4(6)
o.c=p.c.a4(3)
n=p.c.a4(1)!==0
o.d=n
if(n)if(p.c.a4(1)!==0){for(n=o.e,s=0;s<4;++s)if(p.c.a4(1)!==0){r=p.c
q=r.a4(6)
r=r.a4(1)===1?-q:q
n.$flags&2&&A.b(n)
n[s]=r}for(n=o.f,s=0;s<4;++s)if(p.c.a4(1)!==0){r=p.c
q=r.a4(6)
r=r.a4(1)===1?-q:q
n.$flags&2&&A.b(n)
n[s]=r}}if(o.b===0)n=0
else n=o.a?1:2
p.aV=n
return!0},
kB(a){var s,r,q,p,o,n,m,l=a.c-a.d,k=this.c
k===$&&A.c("br")
k=B.a.S(1,k.a4(2))
this.cy=k
s=k-1
r=s*3
if(l<r)return!1
for(k=this.db,q=0,p=0;p<s;++p,r=n){o=a.d7(3,q)
n=r+((J.d(o.a,o.d)|J.d(o.a,o.d+1)<<8|J.d(o.a,o.d+2)<<16)>>>0)
if(n>l)n=l
m=new A.fm(a.c9(n-r,r))
m.b=254
m.c=0
m.d=-8
B.c.i(k,p,m)
q+=3}B.c.i(k,s,A.oL(a.c9(l-r,a.d-a.b+r)))
return r<l},
kD(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.c
e===$&&A.c("br")
s=e.a4(7)
r=f.c.a4(1)!==0?f.c.cE(4):0
q=f.c.a4(1)!==0?f.c.cE(4):0
p=f.c.a4(1)!==0?f.c.cE(4):0
o=f.c.a4(1)!==0?f.c.cE(4):0
n=f.c.a4(1)!==0?f.c.cE(4):0
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
kC(){var s,r,q,p,o,n,m=this,l=m.fr
for(s=0;s<4;++s)for(r=0;r<8;++r)for(q=0;q<3;++q)for(p=0;p<11;++p){o=m.c
o===$&&A.c("br")
n=o.aj(B.jZ[s][r][q][p])!==0?m.c.a4(8):B.ey[s][r][q][p]
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
o=o.a4(1)!==0
m.fx=o
if(o)m.fy=m.c.a4(8)},
kN(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.aV
f.toString
if(f>0){s=g.w
for(f=s.e,r=s.f,q=g.x,p=q.e,o=0;o<4;++o){if(q.a){n=p[o]
if(!q.c){m=s.b
m.toString
n+=m}}else n=s.b
for(l=0;l<=1;++l){m=g.bG
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
kk(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=g.b,d=e.at
if(d!=null)g.bS=d
d=t.jz
s=J.af(4,d)
for(r=t.by,q=0;q<4;++q)s[q]=A.j([new A.bS(),new A.bS()],r)
g.bG=t.mL.a(s)
r=g.at
r.toString
s=J.af(r,t.ij)
for(p=0;p<r;++p){o=new Uint8Array(16)
n=new Uint8Array(8)
s[p]=new A.ft(o,n,new Uint8Array(8))}g.k2=t.f4.a(s)
g.ok=new Uint8Array(832)
r=g.at
r.toString
g.go=new Uint8Array(4*r)
o=g.p4=16*r
n=g.R8=8*r
m=g.aV
m.toString
if(!(m<3))return A.a(B.ah,m)
l=B.ah[m]
k=l*o
j=(l/2|0)*n
g.p1=A.v(new Uint8Array(16*o+k),!1,f,k)
o=8*n+j
g.p2=A.v(new Uint8Array(o),!1,f,j)
g.p3=A.v(new Uint8Array(o),!1,f,j)
e=e.a
g.RG=A.v(new Uint8Array(e),!1,f,0)
i=e+1>>>1
g.rx=A.v(new Uint8Array(i),!1,f,0)
g.ry=A.v(new Uint8Array(i),!1,f,0)
if(m===2)g.ch=g.ay=0
else{e=B.a.V(g.y-l,16)
g.ay=e
o=B.a.V(g.Q-l,16)
g.ch=o
if(e<0)g.ay=0
if(o<0)g.ch=0}e=B.a.V(g.as+15+l,16)
g.cx=e
o=B.a.V(g.z+15+l,16)
g.CW=o
if(o>r)g.CW=r
o=g.ax
o.toString
if(e>o)g.cx=o
h=r+1
s=J.af(h,t.f_)
for(p=0;p<h;++p)s[p]=new A.fr()
g.k3=t.jt.a(s)
e=g.at
e.toString
s=J.af(e,t.h2)
for(p=0;p<e;++p){r=new Int16Array(384)
s[p]=new A.fs(r,new Uint8Array(16))}g.bF=t.as.a(s)
e=g.at
e.toString
s=J.af(e,t.nC)
for(p=0;p<e;++p)s[p]=new A.bS()
g.k4=d.a(s)
g.kN()
e=$.nH()
d=$.nI()
r=$.nJ()
o=$.nK()
n=$.mx()
m=new Int32Array(16)
A.t0()
g.e=new A.kR(e,d,r,o,n,m)
return!0},
kz(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d="isIntra4x4"
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
k=e.bF
k===$&&A.c("_mbData")
if(!(p<k.length))return A.a(k,p)
i=k[p]
if(r.b){p=e.c
p===$&&A.c("br")
p=p.aj(e.fr.a[0])
o=e.c
m=e.fr
e.k1=p===0?o.aj(m.a[1]):2+o.aj(m.a[2])}p=e.fx
p===$&&A.c("_useSkipProba")
if(p){p=e.c
p===$&&A.c("br")
o=e.fy
o===$&&A.c("_skipP")
h=p.aj(o)!==0}else h=!1
e.kA()
if(!h)h=e.kE(j,n)
else{l.a=j.a=0
p=i.b
p===$&&A.c(d)
if(!p)l.b=j.b=0
i.f=i.e=0}p=e.aV
p.toString
if(p>0){p=e.bG
p===$&&A.c("_fStrengths")
o=e.k1
o===$&&A.c("_segment")
if(!(o<p.length))return A.a(p,o)
o=p[o]
p=i.b
p===$&&A.c(d)
g=o[p?1:0]
o=e.k4
o===$&&A.c("_fInfo")
m=e.y1
if(!(m<o.length))return A.a(o,m)
m=o[m]
m.a=g.a
m.b=g.b
m.d=g.d
m.c=g.c||!h}++e.y1}p=e.k3
p===$&&A.c("_mbInfo")
if(0>=p.length)return A.a(p,0)
p=p[0]
p.b=p.a=0
B.d.a8(s,0,4,0)
e.y1=0
e.lj()
p=e.aV
p.toString
f=!1
if(p>0){p=e.y2
o=e.ch
o===$&&A.c("_tlMbY")
if(p>=o){o=e.cx
o.toString
o=p<=o
f=o}}if(!e.jZ(f))return!1
p=++e.y2}return!0},
lj(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9=this,b0=null,b1="_dsp",b2=a9.y2,b3=a9.ok
b3===$&&A.c("_yuvBlock")
s=A.v(b3,!1,b0,40)
r=A.v(b3,!1,b0,584)
q=A.v(b3,!1,b0,600)
p=a9.p1
p===$&&A.c("_cacheY")
o=t.D
n=o.a(p.a)
p=a9.p2
p===$&&A.c("_cacheU")
m=o.a(p.a)
p=a9.p3
p===$&&A.c("_cacheV")
l=o.a(p.a)
p=a9.p4
p.toString
o=a9.R8
o.toString
k=b2>0
j=b3.$flags|0
i=0
for(;;){h=a9.at
h.toString
if(!(i<h))break
h=a9.bF
h===$&&A.c("_mbData")
if(!(i<h.length))return A.a(h,i)
g=h[i]
if(i>0){for(f=-1;f<16;++f){h=40+f*32
A.aD(b3,h-4,b3,h+12,4)}for(f=-1;f<8;++f){h=f*32
e=584+h
A.aD(b3,e-4,b3,e+4,4)
h=600+h
A.aD(b3,h-4,b3,h+4,4)}}else{for(f=0;f<16;++f){h=40+f*32-1
j&2&&A.b(b3)
if(!(h<832))return A.a(b3,h)
b3[h]=129}for(f=0;f<8;++f){h=f*32
e=584+h-1
j&2&&A.b(b3)
if(!(e<832))return A.a(b3,e)
b3[e]=129
h=600+h-1
if(!(h<832))return A.a(b3,h)
b3[h]=129}if(k){j&2&&A.b(b3)
b3[567]=129
b3[551]=129
b3[7]=129}}h=a9.k2
h===$&&A.c("_yuvT")
if(!(i<h.length))return A.a(h,i)
d=h[i]
c=g.a
b=g.e
if(k){A.aD(b3,8,d.a,0,16)
A.aD(b3,552,d.b,0,8)
A.aD(b3,568,d.c,0,8)}else if(i===0){B.d.a8(b3,7,28,127)
B.d.a8(b3,551,560,127)
B.d.a8(b3,567,576,127)}h=g.b
h===$&&A.c("isIntra4x4")
if(h){if(k){h=a9.at
h.toString
if(i>=h-1)B.d.a8(b3,24,28,d.a[15])
else{h=a9.k2
e=i+1
if(!(e<h.length))return A.a(h,e)
A.aD(b3,24,h[e].a,0,4)}}A.aD(b3,152,b3,24,4)
A.aD(b3,280,b3,24,4)
A.aD(b3,408,b3,24,4)
for(h=g.c,a=0;a<16;++a,b=b<<2>>>0){a0=A.w(s,b0,B.cg[a])
e=h[a]
if(!(e<10))return A.a(B.c2,e)
B.c2[e].$1(a0)
b.toString
e=a*16
a9.fg(b,new A.ai(c,e,Math.min(384,384),e,!1),a0)}}else{h=A.oN(i,b2,g.c[0])
h.toString
if(!(h<7))return A.a(B.cf,h)
B.cf[h].$1(s)
if(b!==0)for(a=0;a<16;++a,b=b<<2>>>0){a0=A.w(s,b0,B.cg[a])
b.toString
h=a*16
a9.fg(b,new A.ai(c,h,Math.min(384,384),h,!1),a0)}}h=g.f
h===$&&A.c("nonZeroUV")
e=A.oN(i,b2,g.d)
e.toString
if(!(e<7))return A.a(B.aU,e)
B.aU[e].$1(r)
B.aU[e].$1(q)
e=Math.min(384,384)
a1=new A.ai(c,256,e,256,!1)
if((h&255)!==0){a2=a9.e
if((h&170)!==0){a2===$&&A.c(b1)
a2.bK(a1,r)
a2.bK(A.w(a1,b0,16),A.w(r,b0,4))
a3=A.w(a1,b0,32)
a4=A.w(r,b0,128)
a2.bK(a3,a4)
a2.bK(A.w(a3,b0,16),A.w(a4,b0,4))}else{a2===$&&A.c(b1)
a2.hW(a1,r)}}a5=new A.ai(c,320,e,320,!1)
h=h>>>8
if((h&255)!==0){e=a9.e
if((h&170)!==0){e===$&&A.c(b1)
e.bK(a5,q)
e.bK(A.w(a5,b0,16),A.w(q,b0,4))
h=A.w(a5,b0,32)
a2=A.w(q,b0,128)
e.bK(h,a2)
e.bK(A.w(h,b0,16),A.w(a2,b0,4))}else{e===$&&A.c(b1)
e.hW(a5,q)}}h=a9.ax
h.toString
if(b2<h-1){A.aD(d.a,0,b3,520,16)
A.aD(d.b,0,b3,808,8)
A.aD(d.c,0,b3,824,8)}a6=a9.p1.d+i*16
h=i*8
a7=a9.p2.d+h
a8=a9.p3.d+h
for(f=0;f<16;++f)A.aD(n,a6+f*p,b3,40+f*32,16)
for(f=0;f<8;++f){h=f*o
e=f*32
A.aD(m,a7+h,b3,584+e,8)
A.aD(l,a8+h,b3,600+e,8)}++i}},
fg(a,b,c){var s,r,q,p,o,n,m="_dsp"
switch(a>>>30){case 3:s=this.e
s===$&&A.c(m)
s.mM(b,c,!1)
break
case 2:this.e===$&&A.c(m)
r=J.d(b.a,b.d)+4
q=A.kT(J.d(b.a,b.d+4),35468)
p=A.kT(J.d(b.a,b.d+4),85627)
o=A.kT(J.d(b.a,b.d+1),35468)
n=A.kT(J.d(b.a,b.d+1),85627)
A.kV(c,0,r+p,n,o)
A.kV(c,1,r+q,n,o)
A.kV(c,2,r-q,n,o)
A.kV(c,3,r-p,n,o)
break
case 1:s=this.e
s===$&&A.c(m)
s.d4(b,c)
break
default:break}},
jL(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d="_dsp",c=e.p4
c.toString
s=e.k4
s===$&&A.c("_fInfo")
if(!(a>=0&&a<s.length))return A.a(s,a)
r=s[a]
s=e.p1
s===$&&A.c("_cacheY")
q=t.D
p=q.a(s.a)
o=s.d+a*16
n=r.a
if(n===0)return
if(e.aV===1){if(a>0){s=e.e
s===$&&A.c(d)
s.eD(p,o,c,n+4)}if(r.c){s=e.e
s===$&&A.c(d)
s.ie(p,o,c,n)}if(b>0){s=e.e
s===$&&A.c(d)
s.eE(p,o,c,n+4)}if(r.c){s=e.e
s===$&&A.c(d)
s.ig(p,o,c,n)}}else{m=r.b
s=e.R8
s.toString
l=e.p2
l===$&&A.c("_cacheU")
k=q.a(l.a)
j=a*8
i=l.d+j
l=e.p3
l===$&&A.c("_cacheV")
h=q.a(l.a)
g=l.d+j
f=r.d
if(a>0){q=e.e
q===$&&A.c(d)
l=n+4
q.cq(p,o,1,c,16,l,m,f)
q.cq(k,i,1,s,8,l,m,f)
q.cq(h,g,1,s,8,l,m,f)}if(r.c){q=e.e
q===$&&A.c(d)
q.me(p,o,c,n,m,f)
q.cp(k,i+4,1,s,8,n,m,f)
q.cp(h,g+4,1,s,8,n,m,f)}if(b>0){q=e.e
q===$&&A.c(d)
l=n+4
q.cq(p,o,c,1,16,l,m,f)
q.cq(k,i,s,1,8,l,m,f)
q.cq(h,g,s,1,8,l,m,f)}if(r.c){q=e.e
q===$&&A.c(d)
q.mP(p,o,c,n,m,f)
c=4*s
q.cp(k,i+c,s,1,8,n,m,f)
q.cp(h,g+c,s,1,8,n,m,f)}}},
jY(){var s,r=this,q=r.ay
q===$&&A.c("_tlMbX")
s=q
for(;;){q=r.CW
q.toString
if(!(s<q))break
r.jL(s,r.y2);++s}},
jZ(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.aV
a1.toString
if(!(a1<3))return A.a(B.ah,a1)
s=B.ah[a1]
a1=a.p4
a1.toString
r=s*a1
a1=a.R8
a1.toString
q=(s/2|0)*a1
a1=a.p1
a1===$&&A.c("_cacheY")
p=-r
o=A.w(a1,a0,p)
a1=a.p2
a1===$&&A.c("_cacheU")
n=-q
m=A.w(a1,a0,n)
a1=a.p3
a1===$&&A.c("_cacheV")
l=A.w(a1,a0,n)
k=a.y2
a1=a.cx
a1.toString
j=k*16
i=(k+1)*16
if(a2)a.jY()
if(k!==0){j-=s
a.to=A.w(o,a0,0)
a.x1=A.w(m,a0,0)
a.x2=A.w(l,a0,0)}else{a.to=A.w(a.p1,a0,0)
a.x1=A.w(a.p2,a0,0)
a.x2=A.w(a.p3,a0,0)}a1=k<a1-1
if(a1)i-=s
h=a.as
if(i>h)i=h
a.xr=null
if(a.bS!=null&&j<i){g=a.xr=a.jD(j,i-j)
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
a.kT(j-f,a.z-b,i-j)}if(a1){a1=a.p1
g=a.p4
g.toString
a1.cB(p,r,o,16*g)
g=a.p2
p=a.R8
p.toString
g.cB(n,q,m,8*p)
p=a.p3
g=a.R8
g.toString
p.cB(n,q,l,8*g)}return!0},
kT(a,b,c){if(b<=0||c<=0)return!1
this.jN(a,b,c)
this.jM(a,b,c)
return!0},
dP(a){var s
if((a&-4194304)>>>0===0)s=B.a.j(a,14)
else s=a<0?0:255
return s},
c6(a,b,c,d,e){var s,r,q,p
t.D.a(d)
s=19077*a
r=this.dP(s+26149*c+-3644112)
d.$flags&2&&A.b(d)
q=d.length
if(!(e>=0&&e<q))return A.a(d,e)
d[e]=r
r=e+1
p=this.dP(s-6419*b-13320*c+2229552)
if(!(r<q))return A.a(d,r)
d[r]=p
p=e+2
s=this.dP(s+33050*b+-4527440)
if(!(p<q))return A.a(d,p)
d[p]=s
s=e+3
if(!(s<q))return A.a(d,s)
d[s]=255},
du(c2,c3,c4,c5,c6,c7,c8,c9,d0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null,a6=t.D,a7=a6.a(c2.a),a8=c2.d,a9=a6.a(c4.a),b0=c4.d,b1=a6.a(c5.a),b2=c5.d,b3=a6.a(c6.a),b4=c6.d,b5=a6.a(c7.a),b6=c7.d,b7=a6.a(c8.a),b8=c8.d,b9=c3==null,c0=b9?a5:a6.a(c3.a),c1=b9?a5:c3.d
if(c1==null)c1=0
b9=c9==null
s=b9?a5:a6.a(c9.a)
r=b9?a5:c9.d
if(r==null)r=0
a6=d0-1
q=B.a.j(a6,1)
b9=a9.length
if(!(b0>=0&&b0<b9))return A.a(a9,b0)
p=a9[b0]
o=b1.length
if(!(b2>=0&&b2<o))return A.a(b1,b2)
n=(p|b1[b2]<<16)>>>0
p=b3.length
if(!(b4>=0&&b4<p))return A.a(b3,b4)
m=b3[b4]
l=b5.length
if(!(b6>=0&&b6<l))return A.a(b5,b6)
k=(m|b5[b6]<<16)>>>0
j=3*n+k+131074>>>2
m=a7.length
if(!(a8>=0&&a8<m))return A.a(a7,a8)
a4.c6(a7[a8],j&255,j>>>16,b7,b8)
i=c0!=null
if(i){j=3*k+n+131074>>>2
if(!(c1>=0&&c1<c0.length))return A.a(c0,c1)
h=c0[c1]
s.toString
a4.c6(h,j&255,j>>>16,s,r)}for(g=1;g<=q;++g,k=d,n=e){h=b0+g
if(!(h<b9))return A.a(a9,h)
h=a9[h]
f=b2+g
if(!(f<o))return A.a(b1,f)
e=(h|b1[f]<<16)>>>0
f=b4+g
if(!(f<p))return A.a(b3,f)
f=b3[f]
h=b6+g
if(!(h<l))return A.a(b5,h)
d=(f|b5[h]<<16)>>>0
c=n+e+k+d+524296
b=c+2*(e+k)>>>3
a=c+2*(n+d)>>>3
j=b+n>>>1
a0=a+e>>>1
h=2*g
f=a8+h
a1=f-1
if(!(a1>=0&&a1<m))return A.a(a7,a1)
a2=(h-1)*4
a4.c6(a7[a1],j&255,j>>>16,b7,b8+a2)
if(!(f<m))return A.a(a7,f)
a1=h*4
a4.c6(a7[f],a0&255,a0>>>16,b7,b8+a1)
if(i){j=a+k>>>1
a0=b+d>>>1
h=c1+h
f=h-1
a3=c0.length
if(!(f>=0&&f<a3))return A.a(c0,f)
f=c0[f]
s.toString
a4.c6(f,j&255,j>>>16,s,r+a2)
if(!(h>=0&&h<a3))return A.a(c0,h)
a4.c6(c0[h],a0&255,a0>>>16,s,r+a1)}}if((d0&1)===0){j=3*n+k+131074>>>2
b9=a8+d0-1
if(!(b9>=0&&b9<m))return A.a(a7,b9)
a6*=4
a4.c6(a7[b9],j&255,j>>>16,b7,b8+a6)
if(i){j=3*k+n+131074>>>2
b9=c1+d0-1
if(!(b9>=0&&b9<c0.length))return A.a(c0,b9)
b9=c0[b9]
s.toString
a4.c6(b9,j&255,j>>>16,s,r+a6)}}},
jM(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.xr
if(f==null)return
s=t.D.a(f.a)
r=f.d
if(a===0){q=c-1
p=a}else{p=a-1
r-=g.b.a
q=c}f=g.Q
o=g.as
if(f+a+c===o)q=o-f-p
n=g.d.Y()
m=g.d.gN()*4
for(f=g.b.a,o=s.length,l=n.$flags|0,k=0;k<q;++k){j=(k+p)*m+3
for(i=0;i<b;++i,j+=4){h=r+i
if(!(h>=0&&h<o))return A.a(s,h)
h=s[h]
l&2&&A.b(n)
if(!(j>=0&&j<n.length))return A.a(n,j)
n[j]=h}r+=f}},
jN(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=J.C(g.d.gq(0),0,null),d=g.b.a,c=A.v(e,!1,f,a*d*4),b=g.to
b===$&&A.c("_y")
s=A.w(b,f,0)
b=g.x1
b===$&&A.c("_u")
r=A.w(b,f,0)
b=g.x2
b===$&&A.c("_v")
q=A.w(b,f,0)
p=a+a1
o=B.a.j(a0+1,1)
n=d*4
d=g.rx
d===$&&A.c("_tmpU")
m=A.w(d,f,0)
d=g.ry
d===$&&A.c("_tmpV")
l=A.w(d,f,0)
if(a===0){g.du(s,f,r,q,r,q,c,f,a0)
k=a1}else{d=g.RG
d===$&&A.c("_tmpY")
g.du(d,s,m,l,r,q,A.w(c,f,-n),c,a0)
k=a1+1}m.sq(0,r.a)
l.sq(0,q.a)
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
g.du(A.w(s,f,-i),s,m,l,r,q,A.w(c,f,b),c,a0)}d=s.d
b=g.p4
b.toString
s.d=d+b
if(g.Q+p<g.as){d=g.RG
d===$&&A.c("_tmpY")
d.dC(0,a0,s)
g.rx.dC(0,o,r)
g.ry.dC(0,o,q);--k}else if((p&1)===0)g.du(s,f,r,q,r,q,A.w(c,f,n),f,a0)
return k},
jD(a,b){var s,r,q,p,o,n,m,l,k,j=this,i="_alphaPlane",h=j.b,g=h.a,f=h.b
if(a<0||b<=0||a+b>f)return null
if(a===0){h=g*f
j.aZ=new Uint8Array(h)
s=j.bS
r=new A.lb(s,g,f)
q=s.H()
p=r.d=q&3
r.e=B.a.j(q,2)&3
r.f=B.a.j(q,4)&3
r.r=B.a.j(q,6)&3
if(r.ghG())if(p===0){if(s.c-s.d<h)r.r=1}else if(p===1){o=new A.bV(B.ac,A.j([],t.J))
o.a=g
o.b=f
h=A.j([],t.nK)
p=A.j([],t.ip)
n=new Uint32Array(2)
m=new A.ir(s,n)
n=m.e=J.C(B.o.gq(n),0,null)
l=s.H()
n.$flags&2&&A.b(n)
if(0>=n.length)return A.a(n,0)
n[0]=l
l=s.H()
n.$flags&2&&A.b(n)
if(1>=n.length)return A.a(n,1)
n[1]=l
l=s.H()
n.$flags&2&&A.b(n)
if(2>=n.length)return A.a(n,2)
n[2]=l
l=s.H()
n.$flags&2&&A.b(n)
if(3>=n.length)return A.a(n,3)
n[3]=l
l=s.H()
n.$flags&2&&A.b(n)
if(4>=n.length)return A.a(n,4)
n[4]=l
l=s.H()
n.$flags&2&&A.b(n)
if(5>=n.length)return A.a(n,5)
n[5]=l
l=s.H()
n.$flags&2&&A.b(n)
if(6>=n.length)return A.a(n,6)
n[6]=l
s=s.H()
n.$flags&2&&A.b(n)
if(7>=n.length)return A.a(n,7)
n[7]=s
m.b=!1
p=new A.hG(m,o,h,p)
p.dy=g
p.fr=f
r.x=p
p.cH(g,f,!0)
h=r.x
s=h.ch
p=s.length
if(p===1){if(0>=p)return A.a(s,0)
h=s[0].a===B.cG&&h.kq()}else h=!1
if(h){r.y=!0
h=r.x
s=h.c
k=s.a*s.b
h.db=0
s=B.a.a5(k,4)
s=new Uint8Array(k+(4-s))
h.cy=s
h.cx=J.a1(B.d.gq(s),0,null)}else{r.y=!1
r.x.eS(g)}}else r.r=1
j.ci=r}h=j.ci
if(h!=null)if(!h.w){s=j.aZ
s===$&&A.c(i)
if(!h.lW(a,b,s))return null}h=j.aZ
h===$&&A.c(i)
return A.v(h,!1,null,a*g)},
kE(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=a2.fr.b,a4=a2.dy,a5=a2.k1
a5===$&&A.c("_segment")
if(!(a5<4))return A.a(a4,a5)
s=a4[a5]
a5=a2.bF
a5===$&&A.c("_mbData")
a4=a2.y1
if(!(a4<a5.length))return A.a(a5,a4)
r=a5[a4]
q=A.v(r.a,!1,null,0)
a4=a2.k3
a4===$&&A.c("_mbInfo")
if(0>=a4.length)return A.a(a4,0)
p=a4[0]
q.mr(0,q.c-q.d,0)
a4=r.b
a4===$&&A.c("isIntra4x4")
if(!a4){o=A.v(new Int16Array(16),!1,null,0)
a4=a6.b
a5=p.b
if(1>=a3.length)return A.a(a3,1)
n=a2.e1(a7,a3[1],a4+a5,s.b,0,o)
a6.b=p.b=n>0?1:0
if(n>1)a2.lA(o,q)
else{m=B.a.j(J.d(o.a,o.d)+3,3)
for(l=0;l<256;l+=16)J.a_(q.a,q.d+l,m)}k=a3[0]
j=1}else{if(3>=a3.length)return A.a(a3,3)
k=a3[3]
j=0}i=a6.a&15
h=p.a&15
for(g=0,f=0;f<4;++f){e=h&1
for(d=0,c=0;c<4;++c){n=a2.e1(a7,k,e+(i&1),s.a,j,q)
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
i=B.a.a6(a6.a,a5)
h=B.a.a6(p.a,a5)
for(d=0,f=0;f<2;++f){e=h&1
for(c=0;c<2;++c){if(2>=a4)return A.a(a3,2)
n=a2.e1(a7,a3[2],e+(i&1),s.c,0,q)
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
lA(a,b){var s,r,q,p,o,n,m,l,k,j,i=new Int32Array(16)
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
J.a_(b.a,b.d+k,p)
p=B.a.j(l+m,3)
J.a_(b.a,b.d+(k+16),p)
p=B.a.j(q-n,3)
J.a_(b.a,b.d+(k+32),p)
p=B.a.j(l-m,3)
J.a_(b.a,b.d+(k+48),p)
k+=64}},
k9(a,b){var s,r,q,p,o,n,m
t.L.a(b)
if(a.aj(b[3])===0)s=a.aj(b[4])===0?2:3+a.aj(b[5])
else if(a.aj(b[6])===0)s=a.aj(b[7])===0?5+a.aj(159):7+2*a.aj(165)+a.aj(145)
else{r=a.aj(b[8])
q=9+r
if(!(q<11))return A.a(b,q)
p=2*r+a.aj(b[q])
if(!(p<4))return A.a(B.bB,p)
o=B.bB[p]
n=o.length
for(s=0,m=0;m<n;++m)s+=s+a.aj(o[m])
s+=3+B.a.S(8,p)}return s},
e1(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j
t.ac.a(b)
t.L.a(d)
s=b.length
if(!(e<s))return A.a(b,e)
r=b[e].a
if(!(c<r.length))return A.a(r,c)
q=r[c]
for(;e<16;e=p){if(a.aj(q[0])===0)return e
while(a.aj(q[1])===0){++e
if(!(e>=0&&e<17))return A.a(B.av,e)
r=B.av[e]
if(!(r<s))return A.a(b,r)
r=b[r].a
if(0>=r.length)return A.a(r,0)
q=r[0]
if(e===16)return 16}p=e+1
if(!(p>=0&&p<17))return A.a(B.av,p)
r=B.av[p]
if(!(r<s))return A.a(b,r)
o=b[r].a
r=o.length
if(a.aj(q[2])===0){if(1>=r)return A.a(o,1)
q=o[1]
n=1}else{n=this.k9(a,q)
if(2>=r)return A.a(o,2)
q=o[2]}if(!(e>=0&&e<16))return A.a(B.bW,e)
r=B.bW[e]
m=a.b
m===$&&A.c("_range")
l=a.eW(B.a.j(m,1))
m=a.b
if(m>>>0!==m||m>=128)return A.a(B.as,m)
k=B.as[m]
a.b=B.c5[m]
m=a.d
m===$&&A.c("_bits")
a.d=m-k
m=l!==0?-n:n
j=d[e>0?1:0]
J.a_(f.a,f.d+r,m*j)}return 16},
kA(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.y1,g=4*h,f=i.go,e=i.id,d=i.bF
d===$&&A.c("_mbData")
if(!(h<d.length))return A.a(d,h)
s=d[h]
h=i.c
h===$&&A.c("br")
h=h.aj(145)===0
s.b=h
if(!h){if(i.c.aj(156)!==0)r=i.c.aj(128)!==0?1:3
else r=i.c.aj(163)!==0?2:0
h=s.c
h.$flags&2&&A.b(h)
h[0]=r
f.toString
B.d.a8(f,g,g+4,r)
B.d.a8(e,0,4,r)}else{q=s.c
for(p=0,o=0;o<4;++o,p=j){r=e[o]
for(n=0;n<4;++n){h=g+n
if(!(h<f.length))return A.a(f,h)
d=f[h]
if(!(d<10))return A.a(B.bY,d)
d=B.bY[d]
if(!(r>=0&&r<10))return A.a(d,r)
m=d[r]
l=i.c.aj(m[0])
if(!(l<18))return A.a(B.aq,l)
k=B.aq[l]
while(k>0){d=i.c
if(!(k<9))return A.a(m,k)
d=2*k+d.aj(m[k])
if(!(d>=0&&d<18))return A.a(B.aq,d)
k=B.aq[d]}r=-k
f.$flags&2&&A.b(f)
f[h]=r}j=p+4
f.toString
B.d.ab(q,p,j,f,g)
e.$flags&2&&A.b(e)
if(!(o<4))return A.a(e,o)
e[o]=r}}if(i.c.aj(142)===0)h=0
else if(i.c.aj(114)===0)h=2
else h=i.c.aj(183)!==0?1:3
s.d=h}}
A.fm.prototype={
a4(a){var s,r
for(s=0;r=a-1,a>0;a=r)s=(s|B.a.U(this.aj(128),r))>>>0
return s},
cE(a){var s=this.a4(a)
return this.a4(1)===1?-s:s},
aj(a){var s,r=this,q=r.b
q===$&&A.c("_range")
s=r.eW(B.a.j(q*a,8))
if(r.b<=126)r.lp()
return s},
eW(a){var s,r,q,p,o,n=this,m="_value",l=n.d
l===$&&A.c("_bits")
if(l<0){s=n.a
r=s.c
q=s.d
if(r-q>=1){p=s.H()
l=n.c
l===$&&A.c(m)
n.c=(p|l<<8)>>>0
l=n.d+8
n.d=l
o=l}else{if(q<r){l=s.H()
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
if(B.a.aJ(l,o)>a){s=n.b
s===$&&A.c("_range")
r=a+1
n.b=s-r
n.c=l-B.a.U(r,o)
return 1}else{n.b=a
return 0}},
lp(){var s,r=this,q=r.b
q===$&&A.c("_range")
if(!(q>=0&&q<128))return A.a(B.as,q)
s=B.as[q]
r.b=B.c5[q]
q=r.d
q===$&&A.c("_bits")
r.d=q-s}}
A.kR.prototype={
eE(a,b,c,d){var s,r
t.D.a(a)
for(s=0;s<16;++s){r=b+s
if(this.fD(a,r,c,d))this.df(a,r,c)}},
eD(a,b,c,d){var s,r
t.D.a(a)
for(s=0;s<16;++s){r=b+s*c
if(this.fD(a,r,1,d))this.df(a,r,1)}},
ig(a,b,c,d){var s
t.D.a(a)
for(s=1;s<=3;++s)this.eE(a,b+4*s*c,c,d)},
ie(a,b,c,d){var s
t.D.a(a)
for(s=1;s<=3;++s)this.eD(a,b+4*s,c,d)},
mP(a,b,c,d,e,f){var s
t.D.a(a)
for(s=1;s<=3;++s)this.cp(a,b+4*s*c,c,1,16,d,e,f)},
me(a,b,c,d,e,f){var s
t.D.a(a)
for(s=1;s<=3;++s)this.cp(a,b+4*s,1,c,16,d,e,f)},
cq(a5,a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
t.D.a(a5)
for(s=3*a7,r=a5.length,q=2*a7,p=a4.c,o=a4.e,n=a5.$flags|0,m=0;m<a9;++m,a6+=a8)if(a4.fE(a5,a6,a7,b0,b1))if(a4.fu(a5,a6,a7,b2))a4.df(a5,a6,a7)
else{l=a6-s
if(!(l>=0&&l<r))return A.a(a5,l)
k=a5[l]
j=a6-q
if(!(j>=0&&j<r))return A.a(a5,j)
i=a5[j]
h=a6-a7
if(!(h>=0&&h<r))return A.a(a5,h)
g=a5[h]
if(!(a6>=0&&a6<r))return A.a(a5,a6)
f=a5[a6]
e=a6+a7
if(!(e<r))return A.a(a5,e)
d=a5[e]
c=a6+q
if(!(c<r))return A.a(a5,c)
b=a5[c]
a=1020+i-d
if(!(a>=0&&a<2041))return A.a(p,a)
a=1020+3*(f-g)+p[a]
if(!(a>=0&&a<2041))return A.a(p,a)
a0=p[a]
a1=B.a.j(27*a0+63+3456,7)-27
a2=B.a.j(18*a0+63+2304,7)-18
a3=B.a.j(9*a0+63+1152,7)-9
a=255+k+a3
if(!(a<766))return A.a(o,a)
a=o[a]
n&2&&A.b(a5)
a5[l]=a
a=255+i+a2
if(!(a<766))return A.a(o,a)
a5[j]=o[a]
a=255+g+a1
if(!(a<766))return A.a(o,a)
a5[h]=o[a]
a=255+f-a1
if(!(a>=0&&a<766))return A.a(o,a)
a5[a6]=o[a]
a=255+d-a2
if(!(a>=0&&a<766))return A.a(o,a)
a5[e]=o[a]
a=255+b-a3
if(!(a>=0&&a<766))return A.a(o,a)
a5[c]=o[a]}},
cp(a0,a1,a2,a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this
t.D.a(a0)
for(s=2*a2,r=a0.length,q=a.d,p=a.e,o=a0.$flags|0,n=0;n<a4;++n,a1+=a3)if(a.fE(a0,a1,a2,a5,a6))if(a.fu(a0,a1,a2,a7))a.df(a0,a1,a2)
else{m=a1-s
if(!(m>=0&&m<r))return A.a(a0,m)
l=a0[m]
k=a1-a2
if(!(k>=0&&k<r))return A.a(a0,k)
j=a0[k]
if(!(a1>=0&&a1<r))return A.a(a0,a1)
i=a0[a1]
h=a1+a2
if(!(h<r))return A.a(a0,h)
g=a0[h]
f=3*(i-j)
e=B.a.j(f+4+1024,3)-128+112
if(!(e>=0&&e<225))return A.a(q,e)
d=q[e]
e=B.a.j(f+3+1024,3)-128+112
if(!(e>=0&&e<225))return A.a(q,e)
c=q[e]
b=B.a.j(d+1+16,1)-8
e=255+l+b
if(!(e<766))return A.a(p,e)
e=p[e]
o&2&&A.b(a0)
a0[m]=e
e=255+j+c
if(!(e>=0&&e<766))return A.a(p,e)
a0[k]=p[e]
e=255+i-d
if(!(e>=0&&e<766))return A.a(p,e)
a0[a1]=p[e]
e=255+g-b
if(!(e>=0&&e<766))return A.a(p,e)
a0[h]=p[e]}},
df(a,b,c){var s,r,q,p,o,n,m,l,k
t.D.a(a)
s=b-2*c
r=a.length
if(!(s>=0&&s<r))return A.a(a,s)
q=a[s]
s=b-c
if(!(s>=0&&s<r))return A.a(a,s)
p=a[s]
if(!(b>=0&&b<r))return A.a(a,b)
o=a[b]
n=b+c
if(!(n<r))return A.a(a,n)
r=this.c
n=1020+q-a[n]
if(!(n>=0&&n<2041))return A.a(r,n)
m=3*(o-p)+r[n]
n=this.d
r=B.a.j(m+4+1024,3)-128+112
if(!(r>=0&&r<225))return A.a(n,r)
l=n[r]
r=B.a.j(m+3+1024,3)-128+112
if(!(r>=0&&r<225))return A.a(n,r)
k=this.e
r=255+p+n[r]
if(!(r>=0&&r<766))return A.a(k,r)
r=k[r]
a.$flags&2&&A.b(a)
a[s]=r
r=255+o-l
if(!(r>=0&&r<766))return A.a(k,r)
a[b]=k[r]},
fu(a,b,c,d){var s,r,q,p,o,n
t.D.a(a)
s=b-2*c
r=a.length
if(!(s>=0&&s<r))return A.a(a,s)
q=a[s]
s=b-c
if(!(s>=0&&s<r))return A.a(a,s)
p=a[s]
if(!(b>=0&&b<r))return A.a(a,b)
o=a[b]
s=b+c
if(!(s<r))return A.a(a,s)
n=a[s]
s=this.a
r=255+q-p
if(!(r>=0&&r<511))return A.a(s,r)
if(s[r]<=d){r=255+n-o
if(!(r>=0&&r<511))return A.a(s,r)
r=s[r]>d
s=r}else s=!0
return s},
fD(a,b,c,d){var s,r,q,p,o,n,m
t.D.a(a)
s=b-2*c
r=a.length
if(!(s>=0&&s<r))return A.a(a,s)
q=a[s]
s=b-c
if(!(s>=0&&s<r))return A.a(a,s)
p=a[s]
if(!(b>=0&&b<r))return A.a(a,b)
o=a[b]
s=b+c
if(!(s<r))return A.a(a,s)
n=a[s]
s=this.a
r=255+p-o
if(!(r>=0&&r<511))return A.a(s,r)
r=s[r]
s=this.b
m=255+q-n
if(!(m>=0&&m<511))return A.a(s,m)
return 2*r+s[m]<=d},
fE(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h,g
t.D.a(a)
s=b-4*c
r=a.length
if(!(s>=0&&s<r))return A.a(a,s)
q=a[s]
s=3*c
p=b-s
if(!(p>=0&&p<r))return A.a(a,p)
o=a[p]
p=2*c
n=b-p
if(!(n>=0&&n<r))return A.a(a,n)
m=a[n]
n=b-c
if(!(n>=0&&n<r))return A.a(a,n)
l=a[n]
if(!(b>=0&&b<r))return A.a(a,b)
k=a[b]
n=b+c
if(!(n<r))return A.a(a,n)
j=a[n]
p=b+p
if(!(p<r))return A.a(a,p)
i=a[p]
s=b+s
if(!(s<r))return A.a(a,s)
h=a[s]
s=this.a
r=255+l-k
if(!(r>=0&&r<511))return A.a(s,r)
r=s[r]
p=this.b
n=255+m
g=n-j
if(!(g>=0&&g<511))return A.a(p,g)
if(2*r+p[g]>d)return!1
r=255+q-o
if(!(r>=0&&r<511))return A.a(s,r)
p=!1
if(s[r]<=e){r=255+o-m
if(!(r>=0&&r<511))return A.a(s,r)
if(s[r]<=e){r=n-l
if(!(r>=0&&r<511))return A.a(s,r)
if(s[r]<=e){r=255+h-i
if(!(r>=0&&r<511))return A.a(s,r)
if(s[r]<=e){r=255+i-j
if(!(r>=0&&r<511))return A.a(s,r)
if(s[r]<=e){r=255+j-k
if(!(r>=0&&r<511))return A.a(s,r)
r=s[r]<=e
s=r}else s=p}else s=p}else s=p}else s=p}else s=p
return s},
bK(a,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=t.m6.a(a.a),d=t.D.a(a0.a),c=this.f,b=a.d
for(s=e.length,r=c.$flags|0,q=0,p=0;p<4;++p){if(!(b>=0&&b<s))return A.a(e,b)
o=e[b]
n=b+8
if(!(n<s))return A.a(e,n)
n=e[n]
m=o+n
l=o-n
n=b+4
if(!(n<s))return A.a(e,n)
n=e[n]
o=B.a.j(n*35468+1073741824,16)
k=b+12
if(!(k<s))return A.a(e,k)
k=e[k]
j=o-16384-(B.a.j(k*85627+1073741824,16)-16384)
i=B.a.j(n*85627+1073741824,16)-16384+(B.a.j(k*35468+1073741824,16)-16384)
h=q+1
r&2&&A.b(c)
if(!(q<16))return A.a(c,q)
c[q]=m+i
q=h+1
if(!(h<16))return A.a(c,h)
c[h]=l+j
h=q+1
if(!(q<16))return A.a(c,q)
c[q]=l-j
q=h+1
if(!(h<16))return A.a(c,h)
c[h]=m-i;++b}g=a0.d
for(s=d.$flags|0,r=d.length,q=0,p=0;p<4;++p){if(!(q<16))return A.a(c,q)
f=c[q]+4
o=q+8
if(!(o<16))return A.a(c,o)
o=c[o]
m=f+o
l=f-o
o=q+4
if(!(o<16))return A.a(c,o)
o=c[o]
n=B.a.j(o*35468+1073741824,16)
k=q+12
if(!(k<16))return A.a(c,k)
k=c[k]
j=n-16384-(B.a.j(k*85627+1073741824,16)-16384)
i=B.a.j(o*85627+1073741824,16)-16384+(B.a.j(k*35468+1073741824,16)-16384)
if(!(g>=0&&g<r))return A.a(d,g)
k=d[g]+(B.a.j(m+i+65536,3)-8192)
if((k&-256)>>>0===0)o=k
else o=k<0?0:255
s&2&&A.b(d)
d[g]=o
o=g+1
if(!(o<r))return A.a(d,o)
n=d[o]+(B.a.j(l+j+65536,3)-8192)
if(!((n&-256)>>>0===0))n=n<0?0:255
d[o]=n
n=g+2
if(!(n<r))return A.a(d,n)
o=d[n]+(B.a.j(l-j+65536,3)-8192)
if(!((o&-256)>>>0===0))o=o<0?0:255
d[n]=o
o=g+3
if(!(o<r))return A.a(d,o)
n=d[o]+(B.a.j(m-i+65536,3)-8192)
if(!((n&-256)>>>0===0))n=n<0?0:255
d[o]=n;++q
g+=32}},
mM(a,b,c){this.bK(a,b)
if(c)this.bK(A.w(a,null,16),A.w(b,null,4))},
d4(a,b){var s,r,q,p,o,n
for(s=J.d(a.a,a.d)+4+65536,r=0;r<4;++r)for(q=r*32,p=0;p<4;++p){o=p+q
n=J.d(b.a,b.d+o)+(B.a.j(s,3)-8192)
if(!((n&-256)>>>0===0))n=n<0?0:255
J.a_(b.a,b.d+o,n)}},
hW(a,b){var s=this,r=null
if(J.d(a.a,a.d)!==0)s.d4(a,b)
if(J.d(a.a,a.d+16)!==0)s.d4(A.w(a,r,16),A.w(b,r,4))
if(J.d(a.a,a.d+32)!==0)s.d4(A.w(a,r,32),A.w(b,r,128))
if(J.d(a.a,a.d+48)!==0)s.d4(A.w(a,r,48),A.w(b,r,132))}}
A.kY.prototype={}
A.l8.prototype={}
A.la.prototype={}
A.fl.prototype={}
A.l9.prototype={}
A.kS.prototype={}
A.bS.prototype={}
A.fr.prototype={}
A.iv.prototype={}
A.fs.prototype={}
A.ft.prototype={}
A.fn.prototype={
cY(){var s,r,q,p,o=this,n=o.b
if(n.ar(8)!==47)return!1
s=n.ar(14)+1
r=n.ar(14)+1
q=n.ar(1)
o.dy=s
o.fr=r
p=o.c
p.f=B.aD
p.a=s
p.b=r
p.d=q!==0
if(n.ar(3)!==0)return!1
return!0},
bQ(){var s,r,q,p,o,n,m=this,l=null
m.f=0
if(!m.cY())return l
m.cH(m.dy,m.fr,!0)
m.eS(m.dy)
s=m.dy
m.d=A.V(l,l,B.e,0,B.j,m.fr,l,0,4,l,B.e,s,!1)
s=m.cx
s.toString
r=m.c
q=r.a
p=r.b
if(!m.dS(s,q,p,p,m.gkP()))return l
s=r.w
if(s.length!==0){o=A.v(new A.ah(s),!1,l,0)
s=m.d
s.toString
s.e=A.mF(o)}n=r.r
if(n!=null)m.d.c=new A.bH("ICC_PROFILE",B.S,n)
return m.d},
eS(a){var s,r=this,q=r.c
q=q.a*q.b+a
s=new Uint32Array(q+a*16)
r.cx=s
r.cy=J.C(B.o.gq(s),0,null)
r.db=q
return!0},
li(a){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=l.b
r=s.ar(2)
q=l.CW
p=B.a.S(1,r)
if((q&p)>>>0!==0)return!1
l.CW=(q|p)>>>0
o=new A.iu(B.cF)
B.c.C(l.ch,o)
if(!(r<4))return A.a(B.cc,r)
q=B.cc[r]
o.a=q
o.b=a[0]
o.c=a[1]
switch(q.a){case 0:case 1:s=s.ar(3)+2
o.e=s
o.d=l.cH(A.ce(o.b,s),A.ce(o.c,o.e),!1)
break
case 3:n=s.ar(8)+1
if(n>16)m=0
else if(n>4)m=1
else{s=n>2?2:3
m=s}B.c.i(a,0,A.ce(o.b,m))
o.e=m
o.d=l.cH(n,1,!1)
l.jR(n,o)
break
case 2:break}return!0},
cH(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c)for(s=k.b,r=t.t,q=b,p=a;s.ar(1)!==0;){o=A.j([p,q],r)
if(!k.li(o))throw A.f(A.l("Invalid Transform"))
p=o[0]
q=o[1]}else{q=b
p=a}s=k.b
if(s.ar(1)!==0){n=s.ar(4)
if(!(n>=1&&n<=11))throw A.f(A.l("Invalid Color Cache"))}else n=0
if(!k.l5(p,q,n,c))throw A.f(A.l("Invalid Huffman Codes"))
if(n>0){s=B.a.S(1,n)
k.w=s
k.x=new A.l1(new Uint32Array(s),32-n)}else k.w=0
s=k.c
s.a=p
s.b=q
m=k.z
k.Q=A.ce(p,m)
k.y=m===0?4294967295:B.a.S(1,m)-1
if(c){k.f=0
return null}l=new Uint32Array(p*q)
if(!k.dS(l,p,q,q,null))throw A.f(A.l("Failed to decode image data."))
k.f=0
return l},
dS(b6,b7,b8,b9,c0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=this,b5=506832829
t.ec.a(c0)
s=b4.f
r=B.a.aa(s,b7)
q=B.a.a5(s,b7)
p=b7*b8
o=b7*b9
if(s>=o){if(c0!=null)c0.$2(b9,!1)
return!0}n=b4.fm(q,r)
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
a1=B.a.a0(A.cj(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}q=c}continue}if(i.a>=32)i.cd()
if(n.e){a2=i.d2()&63
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
a1=B.a.a0(A.cj(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}q=c}continue}}else a4=n.ck(0,i)
if(a4<256){if(n.b){d=n.c
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=(d|a4<<8)>>>0}else{a5=n.ck(1,i)
if(i.a>=32)i.cd()
a6=A.pL(n.ck(2,i),a4,a5,n.ck(3,i))
g&2&&A.b(b6)
if(!(f>=0&&f<m))return A.a(b6,f)
b6[f]=a6}++f;++q
if(q>=b7){++r
if(h&&r<=b9)c0.$2(r,!0)
if(k!=null)for(d=k.a,b=k.b,a=d.$flags|0;s<f;){if(!(s>=0&&s<m))return A.a(b6,s)
a0=b6[s]
a1=B.a.a0(A.cj(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}q=c}}else if(a4<280){a7=b4.dj(a4-256)
a8=n.ck(4,i)
if(i.a>=32)i.cd()
a9=b4.fF(b7,b4.dj(a8))
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
a1=B.a.a0(A.cj(a0,b5),b)
a&2&&A.b(d)
if(!(a1<d.length))return A.a(d,a1)
d[a1]=a0;++s}}else if(a4<l){b2=a4-280
while(s<f){k.toString
if(!(s>=0&&s<m))return A.a(b6,s)
d=b6[s]
b=k.a
a=B.a.a0(A.cj(d,b5),k.b)
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
b3=B.a.a0(A.cj(a1,b5),a)
a0&2&&A.b(d)
if(!(b3<b))return A.a(d,b3)
d[b3]=a1;++s}q=c}}else return!1}if(h)c0.$2(r>b9?b9:r,!1)
b4.f=f
return!0},
kq(){var s,r,q,p,o,n,m,l
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
jU(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
if(b&&B.a.a5(a,16)!==0)return
s=g.r
r=a-s
q=g.dy
p=q*s
while(r>0){o=r>16?16:r
n=q*o
m=q*s
l=g.db
g.eT(s,o,p)
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
jh(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_pixels8",d=f.f,c=B.a.aa(d,a1),b=B.a.a5(d,a1),a=a1*a2,a0=a1*a3
if(d>=a0){f.dh(c)
return!0}s=f.fm(b,c)
r=f.y
q=f.b
for(;;){if(!(!q.b&&d<a0))break
if((b&r)>>>0===0){p=f.cJ(f.as,f.Q,f.z,b,c)
o=f.ax
if(!(p<o.length))return A.a(o,p)
s=o[p]}if(q.a>=32)q.cd()
n=s.ck(0,q)
if(n<256){o=f.cy
o===$&&A.c(e)
o.$flags&2&&A.b(o)
if(!(d>=0&&d<o.length))return A.a(o,d)
o[d]=n;++d;++b
if(b>=a1){++c
if(B.a.a5(c,16)===0)f.dh(c)
b=0}}else if(n<280){m=f.dj(n-256)
l=s.ck(4,q)
if(q.a>=32)q.cd()
k=f.fF(a1,f.dj(l))
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
if(B.a.a5(c,16)===0)f.dh(c)}if(d<a0&&(b&r)>>>0!==0){p=f.cJ(f.as,f.Q,f.z,b,c)
o=f.ax
if(!(p<o.length))return A.a(o,p)
s=o[p]}}else return!1}f.dh(c)
f.f=d
return!0},
dh(a){var s,r,q=this,p=q.r,o=a-p,n=q.cy
n===$&&A.c("_pixels8")
s=A.v(n,!1,null,q.c.a*p)
if(o>0){n=q.dx
n.toString
r=A.v(n,!1,null,q.dy*p)
n=q.ch
if(0>=n.length)return A.a(n,0)
n[0].lR(p,p+o,s,r)}q.r=a},
kQ(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.c.a,f=h.r
if(b)if(B.a.a5(a,16)!==0)return
s=a-f
if(s<=0){h.r=a
return}h.eT(f,s,g*f)
g=h.cx
g.toString
r=h.d.Y()
f=h.r
q=h.dy
p=f*q*4
for(o=h.db,f=g.length,n=r.$flags|0,m=0;m<s;++m)for(l=0;l<q;++l,++o){if(!(o>=0&&o<f))return A.a(g,o)
k=g[o]
j=p+1
n&2&&A.b(r)
i=r.length
if(!(p>=0&&p<i))return A.a(r,p)
r[p]=k>>>16&255
p=j+1
if(!(j>=0&&j<i))return A.a(r,j)
r[j]=k>>>8&255
j=p+1
if(!(p>=0&&p<i))return A.a(r,p)
r[p]=k&255
p=j+1
if(!(j>=0&&j<i))return A.a(r,j)
r[j]=k>>>24&255}h.r=a},
eT(a,b,c){var s,r=this,q=r.ch,p=q.length,o=r.c.a,n=a+b,m=r.db,l=r.cx
l.toString
B.o.ab(l,m,m+o*b,l,c)
for(;s=p-1,p>0;p=s){if(!(s>=0&&s<q.length))return A.a(q,s)
o=q[s]
l=r.cx
l.toString
o.ml(a,n,l,m,l,m)}},
l5(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1,c=null
if(a1&&e.b.ar(1)!==0){s=2+e.b.ar(3)
r=A.ce(a,s)
q=A.ce(b,s)
p=r*q
o=e.cH(r,q,!1)
if(o==null)return!1
e.z=s
for(n=o.length,m=o.$flags|0,l=d,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
j=o[k]>>>8&65535
m&2&&A.b(o)
o[k]=j
if(j>=l)l=j+1}if(l>1000||l>a*b){c=new Int32Array(1)
B.u.a8(c,0,1,255)
for(d=0,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
i=o[k]
if(!(i<1))return A.a(c,i)
if(c[i]===-1){h=d+1
c[i]=d
d=h}g=c[i]
m&2&&A.b(o)
o[k]=g}}else d=l}else{o=null
l=1}if(e.b.b)return!1
f=e.l6(a0,d,l,c)
if(f==null)return!1
e.as=o
e.at=d
e.ax=f
return!0},
ee(a,b,c,d,e,f){var s,r=a.a,q=a.b,p=d
do{p-=c
s=q+(b+p)
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
s.a=e
s.b=f}while(p>0)},
ku(a,b,c){var s=B.a.U(1,b-c)
while(b<15){s-=a[b]
if(s<=0)break;++b
s=s<<1>>>0}return b-c},
fq(a,b){var s=B.a.U(1,b-1)
while((a&s)>>>0!==0)s=s>>>1
return s!==0?((a&s-1)>>>0)+s:a},
eY(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.a.S(1,a6),a3=new Int32Array(16),a4=new Int32Array(16)
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
a1.ee(a5,0,1,a2,0,a9[0])}return a2}l=a2-1
for(s=a5==null,k=0,j=1,i=1,r=0,p=1,h=2;p<=a6;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
if(!(p<16))return A.a(a3,p)
i-=a3[p]
if(i<0)return 0
if(s)continue
for(g=p&255;a3[p]>0;a3[p]=a3[p]-1,r=f){f=r+1
if(!(r>=0&&r<a9.length))return A.a(a9,r)
a1.ee(a5,k,h,a2,g,a9[r])
k=a1.fq(k,p)}}for(p=a6+1,s=!s,e=a2,d=0,c=4294967295,h=2;p<=15;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
i-=a3[p]
if(i<0)return 0
for(g=p-a6&255;a3[p]>0;a3[p]=a3[p]-1){b=(k&l)>>>0
if(b!==c){if(s)d+=e
a=a1.ku(a3,p,a6)
e=B.a.U(1,a)
a2+=e
if(s){q=a5.a
m=a5.b+b
if(!(m>=0&&m<q.length))return A.a(q,m)
m=q[m]
m.a=a+a6&255
m.b=d-b}c=b}if(s){f=r+1
if(!(r>=0&&r<a9.length))return A.a(a9,r)
a0=a9[r]
a1.ee(a5,d+B.a.a6(k,a6),h,e,g,a0)
r=f}k=a1.fq(k,p)}}if(j!==2*a4[15]-1)return 0
return a2},
h0(a,b,c,d){var s,r,q,p,o,n,m=this.eY(null,b,c,d,null)
if(m===0||a==null)return m
s=a.b
r=s.d
q=s.e
if(r+m>=q){p=new A.eq()
if(m>q)q=m
o=A.mJ(q)
p.e=q
p.b=p.a=o
a.b=p
s=p}n=new Uint16Array(d)
this.eY(s.b,b,c,d,n)
return m},
l4(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.hm(new A.eq())
c.eN(128)
if(this.h0(c,7,a,19)===0)return!1
s=this.b
if(s.ar(1)!==0){r=2+s.ar(2+2*s.ar(3))
if(r>b)return!1}else r=b
for(q=8,p=0;p<b;r=o){o=r-1
if(r===0)break
if(s.a>=32)s.cd()
n=c.b.a
n.toString
m=n.a
n=n.b+(s.d2()&127)
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
if(!(i<3))return A.a(B.bw,i)
h=B.bw[i]
g=B.ef[i]
f=s.ar(h)+g
if(p+f>b)return!1
e=k===16?q:0
for(n=a0.$flags|0;d=f-1,f>0;f=d,p=j){j=p+1
n&2&&A.b(a0)
if(!(p>=0&&p<a0.length))return A.a(a0,p)
a0[p]=e}}}return!0},
fK(a,b,c){var s,r,q,p,o,n,m,l=this.b,k=l.ar(1)
B.u.a8(b,0,a,0)
if(k!==0){s=l.ar(1)
r=l.ar(l.ar(1)===0?1:8)
b.$flags&2&&A.b(b)
q=b.length
if(!(r<q))return A.a(b,r)
b[r]=1
if(s+1===2){r=l.ar(8)
if(!(r<q))return A.a(b,r)
b[r]=1}p=!0}else{o=new Int32Array(19)
n=l.ar(4)+4
for(m=0;m<n;++m){if(!(m<19))return A.a(B.ap,m)
s=B.ap[m]
q=l.ar(3)
if(!(s<19))return A.a(o,s)
o[s]=q}p=this.l4(o,a,b)}return p&&!l.b?this.h0(c,8,b,a):0},
d8(a,b,c){var s=c.a,r=a.a
c.a=s+r
c.b=(c.b|B.a.S(a.b,b))>>>0
return r},
iX(a){var s,r,q,p,o,n,m,l,k,j,i=this
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
j=B.a.a6(o,i.d8(k,8,n))
if(1>=r)return A.a(s,1)
m=s[1]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a6(j,i.d8(l[m],16,n))
if(2>=r)return A.a(s,2)
m=s[2]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a6(j,i.d8(l[m],0,n))
if(3>=r)return A.a(s,3)
m=s[3]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
B.a.a6(j,i.d8(l[m],24,n))}}},
l6(a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null,a7=a9>0,a8=280+(a7?B.a.S(1,a9):0)
if(!(a9<12))return A.a(B.bG,a9)
s=B.bG[a9]
r=b2==null
if(r&&b0!==b1)return a6
q=new Int32Array(a8)
p=J.af(b0,t.co)
for(o=0;o<b0;++o)p[o]=A.qS()
n=new A.hm(new A.eq())
n.eN(b0*s)
a5.ay=n
for(n=!r,m=0;m<b1;++m){if(n){if(!(m<b2.length))return A.a(b2,m)
l=b2[m]===-1}else l=!1
if(l)for(k=0;k<5;++k){j=B.bI[k]
if(a5.fK(k===0&&a7?j+B.a.S(1,a9):j,q,a6)===0)return a6}else{if(r)l=m
else{if(!(m<b2.length))return A.a(b2,m)
l=b2[m]}if(!(l>=0&&l<b0))return A.a(p,l)
i=p[l]
h=i.a
for(l=h.length,g=0,f=!0,e=0,k=0;k<5;++k){j=B.bI[k]
if(k===0&&a7)j+=B.a.S(1,a9)
d=a5.fK(j,q,a5.ay)
c=a5.ay.b.b
c.toString
B.c.i(h,k,c)
if(d===0)return a6
if(f&&B.iA[k]===1){if(!(k<l))return A.a(h,k)
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
c.b=new A.ep(b.a,b.b+d)
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
if(l)a5.iX(i)}}return p},
dj(a){var s
if(a<4)return a+1
s=B.a.j(a-2,1)
return B.a.S(2+(a&1),s)+this.b.ar(s)+1},
fF(a,b){var s,r,q
if(b>120)return b-120
else{s=b-1
if(!(s>=0))return A.a(B.bJ,s)
r=B.bJ[s]
q=(r>>>4)*a+(8-(r&15))
return q>=1?q:1}},
jR(a,b){var s,r,q,p,o,n,m,l,k=B.a.S(1,B.a.a6(8,b.e)),j=new Uint32Array(k),i=b.d
i.toString
s=J.C(B.o.gq(i),0,null)
r=J.C(B.o.gq(j),0,null)
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
fm(a,b){var s=this,r=s.cJ(s.as,s.Q,s.z,a,b),q=s.ax
if(!(r<q.length))return A.a(q,r)
return q[r]}}
A.hG.prototype={
mb(a,b){return this.jU(a,b)}}
A.kZ.prototype={}
A.l_.prototype={
gu(a){return this.c}}
A.l4.prototype={}
A.l6.prototype={}
A.ma.prototype={
$1(a){A.n(a)
return a>=1&&a<this.a},
$S:34}
A.lJ.prototype={
iH(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=h.a,f=1
for(;;){s=B.a.S(1,f)
if(!(s<g&&f<18))break;++f}h.e!==$&&A.A("_shift")
h.e=32-f
r=new Int32Array(s)
B.u.a8(r,0,s,-1)
h.d!==$&&A.A("_head")
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
mc(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=e.a
if(d<=2)return
s=e.b
r=e.c
q=e.d
q===$&&A.c("_head")
for(p=d-1,o=s.length,n=e.e,m=q.length,l=r.$flags|0,k=q.$flags|0,j=0;j<p;j=h){if(!(j<o))return A.a(s,j)
i=s[j]
h=j+1
if(!(h<o))return A.a(s,h)
g=A.cj(s[h],3332679571)
i=A.cj(i,1540483478)
n===$&&A.c("_shift")
f=B.a.ic(g+i>>>0,n)
if(!(f<m))return A.a(q,f)
i=q[f]
l&2&&A.b(r)
if(!(j<r.length))return A.a(r,j)
r[j]=i
k&2&&A.b(q)
q[f]=j}l&2&&A.b(r)
if(!(p<r.length))return A.a(r,p)
r[p]=-1}}
A.l2.prototype={
ghI(){var s,r=this,q=r.f
if(q===$){s=new A.l3(r).$0()
r.f!==$&&A.nC("lengthBits")
r.f=s
q=s}return q},
hw(a,b){var s=A.iS(b,a),r=A.pI(s),q=this.e,p=A.iY(s)
if(!(p>=0&&p<q.length))return A.a(q,p)
return q[p]+r.a}}
A.l3.prototype={
$0(){var s,r,q,p,o,n=new Float64Array(4096)
for(s=this.a.a,r=s.length,q=1;q<=4095;++q){p=A.pD(q)
o=A.iW(q)
if(!(o>=0&&o<r))return A.a(s,o)
o=s[o]
if(!(q<4096))return A.a(n,q)
n[q]=o+p.a}return n},
$S:18}
A.ir.prototype={
d2(){var s,r,q,p=this.a
if(p<32){s=this.d
r=B.a.a0(s[0],p)
s=s[1]
if(!(p>=0))return A.a(B.a7,p)
q=r+((s&B.a7[p])>>>0)*(B.a7[32-p]+1)}else{s=this.d
q=p===32?s[1]:B.a.a0(s[1],p-32)}return q},
ar(a){var s,r,q=this
if(!q.b&&a<25){s=q.d2()
if(!(a<33))return A.a(B.a7,a)
r=B.a7[a]
q.a+=a
q.cd()
return(s&r)>>>0}else{q.b=!0
throw A.f(A.l("Not enough data in input."))}},
cd(){var s,r,q,p=this,o=p.c,n=p.d,m=n.$flags|0,l=o.c
for(;;){if(!(p.a>=8&&o.d<l))break
s=J.d(o.a,o.d++)
r=n[0]
q=n[1]
m&2&&A.b(n)
n[0]=(r>>>8)+(q&255)*16777216
n[1]=q>>>8
n[1]=(n[1]|s*16777216)>>>0
p.a-=8}}}
A.is.prototype={
kf(){var s=this.a,r=new Uint8Array(s.length*2)
B.d.aB(r,0,this.b,s)
this.a=r},
T(a,b){var s,r,q,p,o,n=this
while(b>0){s=n.d
r=8-s
q=b<r?b:r
p=B.a.U(1,q)
n.c=(n.c|B.a.U((a&p-1)>>>0,s))>>>0
a=B.a.aJ(a,q)
b-=q
s+=q
n.d=s
if(s===8){s=n.b
p=n.a
o=p.length
if(s===o){o=new Uint8Array(o*2)
B.d.aB(o,0,s,p)
n.a=o
s=o}else s=p
p=n.b++
o=n.c
s.$flags&2&&A.b(s)
if(!(p<s.length))return A.a(s,p)
s[p]=o
n.d=n.c=0}}},
hD(){var s,r,q,p=this
if(p.d>0){if(p.b===p.a.length)p.kf()
s=p.a
r=p.b++
q=p.c
s.$flags&2&&A.b(s)
if(!(r<s.length))return A.a(s,r)
s[r]=q
p.d=p.c=0}},
es(){var s=this.b,r=this.a
return s===r.length?r:new Uint8Array(A.p(A.rU(r,0,s)))}}
A.l1.prototype={}
A.m5.prototype={
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
$S:19}
A.m6.prototype={
$1(a){return B.a.a0(A.cj(a,506832829),this.a)},
$S:19}
A.fo.prototype={}
A.l5.prototype={
m8(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=a3.gN(),a2=a3.gJ()
if(a1<=0||a2<=0||a1>16383||a2>16383)throw A.f(A.l("WebP images must be between 1x1 and 16383x16383, got "+a1+"x"+a2))
s=a1*a2
r=new Uint8Array(s)
q=new Uint8Array(s)
p=new Uint8Array(s)
o=new Uint8Array(s)
n=a3.gad()===2||a3.gad()===4
m=a3.gad()===1
l=a3.gG()
k=l===255?1:255/l
for(j=k===1,i=!1,h=0,g=0;g<a2;++g)for(f=0;f<a1;++f){e=a3.a
d=e==null?null:e.P(f,g,null)
if(d==null)d=new A.E()
c=m?d.gt():d.gA()
b=m?d.gt():d.gB()
if(j){e=B.a.F(B.b.h(c),0,255)
if(!(h>=0&&h<s))return A.a(r,h)
r[h]=e
e=B.a.F(B.b.h(d.gt()),0,255)
if(!(h<s))return A.a(q,h)
q[h]=e
e=B.a.F(B.b.h(b),0,255)
if(!(h<s))return A.a(p,h)
p[h]=e
e=n?B.a.F(B.b.h(d.gv()),0,255):255
if(!(h<s))return A.a(o,h)
o[h]=e}else{e=B.a.F(B.b.av(c*k),0,255)
if(!(h>=0&&h<s))return A.a(r,h)
r[h]=e
e=B.a.F(B.b.av(d.gt()*k),0,255)
if(!(h<s))return A.a(q,h)
q[h]=e
e=B.a.F(B.b.av(b*k),0,255)
if(!(h<s))return A.a(p,h)
p[h]=e
e=n?B.a.F(B.b.av(d.gv()*k),0,255):255
if(!(h<s))return A.a(o,h)
o[h]=e}if(!(h>=0&&h<s))return A.a(o,h)
if(o[h]!==255)i=!0;++h}j=i?1:0
a=a1-1|a2-1<<14|j<<28
a0=A.a0(!1,8192)
a0.p(47)
a0.p(a&255)
a0.p(a>>>8&255)
a0.p(a>>>16&255)
a0.p(a>>>24&255)
a0.a2(this.m7(q,r,p,o,a1,a2,i))
return J.C(B.d.gq(a0.c),0,a0.a)},
m7(a4,a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a8+16-1,a=B.a.V(b,16),a0=a9+16-1,a1=B.a.V(a0,16),a2=a8*a9,a3=new Uint32Array(a2)
for(s=a7.length,r=a4.length,q=a5.length,p=a6.length,o=0;o<a2;++o){if(!(o<s))return A.a(a7,o)
n=a7[o]
if(!(o<r))return A.a(a4,o)
m=a4[o]
if(!(o<q))return A.a(a5,o)
l=a5[o]
if(!(o<p))return A.a(a6,o)
a3[o]=(n<<24|m<<16|l<<8|a6[o])>>>0}k=c.iY(a4,a5,a6,a7,a2)
if(k!=null){j=new A.is(new Uint8Array(4096))
c.lJ(j,k,a4,a5,a6,a7,a8,a9)
j.hD()
return j.es()}i=A.vo(a3,a8,a9,4)
n=i.a
if(n){c.iO(a4,a5,a6,a2)
for(o=0;o<a2;++o){if(!(o<s))return A.a(a7,o)
m=a7[o]
if(!(o<r))return A.a(a4,o)
l=a4[o]
if(!(o<q))return A.a(a5,o)
h=a5[o]
if(!(o<p))return A.a(a6,o)
a3[o]=(m<<24|l<<16|h<<8|a6[o])>>>0}}if(i.b){g=A.wa(a3,a8,a9,a,a1,16)
A.vr(a3,a4,a5,a6,a7,a8,a9,a,16,g)}else g=null
if(i.c){f=A.w9(a4,a5,a6,a8,a9,4)
if(f!=null)A.vq(a4,a5,a6,a8,a9,4,f)}else f=null
j=new A.is(new Uint8Array(4096))
if(n){j.T(1,1)
j.T(2,2)}if(g!=null){j.T(1,1)
j.T(0,2)
j.T(2,3)
A.wS(j,a,a1,g)}if(f!=null){e=B.a.j(b,4)
d=B.a.j(a0,4)
j.T(1,1)
j.T(1,2)
j.T(2,3)
c.lE(j,e,d,f)}j.T(0,1)
c.cQ(j,a4,a5,a6,a7,a8,a2,!0)
j.hD()
return j.es()},
cQ(d8,d9,e0,e1,e2,e3,e4,e5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4="green",d5=A.vy(d9,e0,e1,e2,e4,e3),d6=new Int32Array(e4),d7=new A.l4(e4,d6,new Int32Array(e4))
A.tm(d5,d7)
A.w1(d5,A.tl(d7,d9,e0,e1,e2,e3),d9,e0,e1,e2,e3,d7)
s=A.w6(d7)
r=s.a
q=s.b
p=s.c
o=s.d
n=s.e
m=p.length
l=new Int32Array(m)
k=new Int32Array(m)
for(d6=o.length,j=0;j<m;++j){l[j]=A.iW(p[j])
if(!(j<d6))return A.a(o,j)
k[j]=A.iY(A.iS(e3,o[j]))}i=q.length
h=new Int32Array(i)
g=A.w8(d9,e0,e1,e2,r,q,p,o,e3,h)
f=g>0
e=280+(f?B.a.U(1,g):0)
if(f){d8.T(1,1)
d8.T(g,4)}else d8.T(0,1)
d=e5?this.lm(d9,e0,e1,e2,r,q,l,k,n,h,e3,e4,e):null
if(e5)if(d==null)d8.T(0,1)
else{d8.T(1,1)
d8.T(d.a-2,3)
this.lH(d8,d)}f=d==null
c=f?null:d.d.b
if(c==null)c=1
b=r.length
a=new Int32Array(b)
if(!f){a0=d.d.a
a1=d.a
a2=d.b
for(f=a0.length,a3=n.length,a4=0,a5=0,a6=0;a6<b;++a6){if(!(a6<a3))return A.a(n,a6)
a7=n[a6]
while(a8=a7-a4,a8>=e3){a4+=e3;++a5}a8=B.a.a0(a5,a1)*a2+B.a.aJ(a8,a1)
if(!(a8<f))return A.a(a0,a8)
a[a6]=a0[a8]}}a9=J.af(c,t.d)
for(b0=0;b0<c;++b0)a9[b0]=A.fq(e)
for(f=d9.length,a3=e0.length,a8=e1.length,b1=e2.length,b2=0,b3=0,a6=0;a6<b;++a6){b4=a[a6]
if(!(b4>=0&&b4<c))return A.a(a9,b4)
b5=a9[b4]
if(r[a6]!==0){if(!(b2<i))return A.a(h,b2)
b6=h[b2]
b7=b2+1
b8=q[b2]
if(b6>=0)b5.ha(b6)
else{if(!(b8>=0&&b8<f))return A.a(d9,b8)
b4=d9[b8]
if(!(b8<a3))return A.a(e0,b8)
b9=e0[b8]
if(!(b8<a8))return A.a(e1,b8)
c0=e1[b8]
if(!(b8<b1))return A.a(e2,b8)
b5.he(b4,b9,c0,e2[b8])}b2=b7}else{if(!(b3<m))return A.a(l,b3)
b5.hb(l[b3],k[b3]);++b3}}c1=A.j([],t.bm)
for(b4=t.L,b0=0;b0<c;++b0){b5=a9[b0]
b9=A.e1(b5.b,e,15)
c0=A.e1(b5.c,256,15)
c2=A.e1(b5.d,256,15)
c3=A.e1(b5.e,256,15)
c4=A.e1(b5.f,40,15)
c5=new A.iD(e,b9,c0,c2,c3,c4)
A.fV(d8,e,b9)
A.fV(d8,256,c0)
A.fV(d8,256,c2)
A.fV(d8,256,c3)
A.fV(d8,40,c4)
c5.r=b4.a(A.e2(new Int32Array(A.p(b9)),e))
c5.w=b4.a(A.e2(new Int32Array(A.p(c0)),256))
c5.x=b4.a(A.e2(new Int32Array(A.p(c2)),256))
c5.y=b4.a(A.e2(new Int32Array(A.p(c3)),256))
c5.z=b4.a(A.e2(new Int32Array(A.p(c4)),40))
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
c0=A.iW(c7)
b4.a(b9)
c2=b4.a(c6.b)
if(!(c0>=0&&c0<b9.length))return A.a(b9,c0)
b9=b9[c0]
if(!(c0<c2.length))return A.a(c2,c0)
d8.T(b9,c2[c0])
c9=A.pD(c7)
d0=c9.a
if(d0>0)d8.T(c9.b,d0)
d1=A.iS(e3,c8)
b9=c6.z
b9===$&&A.c("dist")
c0=A.iY(d1)
b4.a(b9)
c2=b4.a(c6.f)
if(!(c0>=0&&c0<b9.length))return A.a(b9,c0)
b9=b9[c0]
if(!(c0<c2.length))return A.a(c2,c0)
d8.T(b9,c2[c0])
d2=A.pI(d1)
d3=d2.a
if(d3>0)d8.T(d2.b,d3)}}},
lm(b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=B.a.aa(c6,c5)
for(s=b9.length,r=c1.length,q=c2.length,p=c3.length,o=b5.length,n=b6.length,m=b7.length,l=b8.length,k=c4.length,j=c0.length,i=t.d,h=null,g=0;g<3;++g){f=B.et[g]
e=B.a.S(1,f)
d=B.a.j(c5+e-1,f)
c=B.a.j(b4+e-1,f)
e=d*c
if(e<2||e>2600)continue
b=J.af(e,i)
for(a=0;a<e;++a)b[a]=A.fq(c7)
for(a0=0,a1=0,a2=0,a3=0,a4=0;a4<s;++a4){if(!(a4<p))return A.a(c3,a4)
a5=c3[a4]
while(a6=a5-a2,a6>=c5){a2+=c5;++a3}a6=B.a.a6(a3,f)*d+B.a.j(a6,f)
if(!(a6<e))return A.a(b,a6)
a7=b[a6]
if(b9[a4]!==0){if(!(a0<k))return A.a(c4,a0)
a8=c4[a0]
a9=a0+1
if(!(a0<j))return A.a(c0,a0)
b0=c0[a0]
if(a8>=0)a7.ha(a8)
else{if(!(b0>=0&&b0<o))return A.a(b5,b0)
a6=b5[b0]
if(!(b0<n))return A.a(b6,b0)
b1=b6[b0]
if(!(b0<m))return A.a(b7,b0)
b2=b7[b0]
if(!(b0<l))return A.a(b8,b0)
a7.he(a6,b1,b2,b8[b0])}a0=a9}else{if(!(a1<r))return A.a(c1,a1)
a6=c1[a1]
if(!(a1<q))return A.a(c2,a1)
a7.hb(a6,c2[a1]);++a1}}b3=A.vx(b)
if(b3!=null)e=h==null||b3.c<h.d.c
else e=!1
if(e)h=new A.lK(f,d,c,b3)}return h},
lH(a,b){var s,r,q,p,o,n=b.b,m=n*b.c,l=new Uint8Array(m),k=new Uint8Array(m),j=new Uint8Array(m),i=new Uint8Array(m)
B.d.a8(i,0,m,255)
for(s=b.d.a,r=s.length,q=0;q<m;++q){if(!(q<r))return A.a(s,q)
p=s[q]
o=B.a.j(p,8)
if(!(q<m))return A.a(l,q)
l[q]=o&255
if(!(q<m))return A.a(k,q)
k[q]=p&255}this.cQ(a,l,k,j,i,n,m,!1)},
iY(a,b,c,d,e){var s,r,q,p,o,n,m,l,k=A.mP(t.p)
for(s=d.length,r=a.length,q=b.length,p=c.length,o=0;o<e;++o){if(!(o<s))return A.a(d,o)
n=d[o]
if(!(o<r))return A.a(a,o)
m=a[o]
if(!(o<q))return A.a(b,o)
l=b[o]
if(!(o<p))return A.a(c,o)
if(k.C(0,(n<<24|m<<16|l<<8|c[o])>>>0)&&k.a>256)return null}s=A.t(k,k.$ti.c)
B.c.eF(s)
return new Uint32Array(A.p(s))},
lJ(b5,b6,b7,b8,b9,c0,c1,c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=b6.length
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
d=A.J(e,e)
for(k=0;k<b4;++k)d.i(0,b6[k],k)
if(b4>16)c=0
else if(b4>4)c=1
else{e=b4>2?2:3
c=e}b=A.tn(c1,c)
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
a0[k]=a8}else{a9=B.a.a6(8,c)
for(e=c0.length,a2=b7.length,a3=b8.length,a4=b9.length,a5=B.a.S(1,c)-1,b0=0;b0<c2;++b0)for(a6=b0*c1,a7=b0*b,b1=0;b1<c1;++b1){k=a6+b1
if(!(k>=0&&k<e))return A.a(c0,k)
a8=c0[k]
if(!(k<a2))return A.a(b7,k)
b2=b7[k]
if(!(k<a3))return A.a(b8,k)
b3=b8[k]
if(!(k<a4))return A.a(b9,k)
b3=d.l(0,(a8<<24|b2<<16|b3<<8|b9[k])>>>0)
b3.toString
b2=a7+B.a.a6(b1,c)
if(!(b2<a))return A.a(a0,b2)
a8=a0[b2]
b3=B.a.S(b3,((b1&a5)>>>0)*a9)
if(!(b2<a))return A.a(a0,b2)
a0[b2]=(a8|b3)>>>0}}this.cQ(b5,a1,a0,a1,a1,b,a,!0)},
iO(a,b,c,d){var s,r,q,p,o,n,m,l
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
lE(a,b,c,d){var s,r,q,p,o,n,m,l
t.o6.a(d)
s=b*c
r=new Uint8Array(s)
q=new Uint8Array(s)
p=new Uint8Array(s)
o=new Uint8Array(s)
B.d.a8(o,0,s,255)
for(n=d.length,m=0;m<s;++m){if(!(m<n))return A.a(d,m)
l=d[m]
r[m]=l.c&255
q[m]=l.b&255
p[m]=l.a&255}this.cQ(a,r,q,p,o,b,s,!1)}}
A.lK.prototype={}
A.iD.prototype={}
A.m2.prototype={
$0(){var s,r,q=new Float64Array(4096)
for(s=1;s<4096;++s){r=Math.log(s)
if(!(s<4096))return A.a(q,s)
q[s]=r}return q},
$S:18}
A.fp.prototype={
he(a,b,c,d){var s,r=this,q=r.b
if(!(b>=0&&b<q.length))return A.a(q,b)
s=q[b]
q.$flags&2&&A.b(q)
q[b]=s+1
if(s===0)r.c5(0,b)
q=r.c
if(!(a>=0&&a<256))return A.a(q,a)
s=q[a]
q.$flags&2&&A.b(q)
q[a]=s+1
if(s===0)r.c5(1,a)
q=r.d
if(!(c>=0&&c<256))return A.a(q,c)
s=q[c]
q.$flags&2&&A.b(q)
q[c]=s+1
if(s===0)r.c5(2,c)
q=r.e
if(!(d>=0&&d<256))return A.a(q,d)
s=q[d]
q.$flags&2&&A.b(q)
q[d]=s+1
if(s===0)r.c5(3,d)},
ha(a){var s,r=this.b,q=280+a
if(!(q>=0&&q<r.length))return A.a(r,q)
s=r[q]
r.$flags&2&&A.b(r)
r[q]=s+1
if(s===0)this.c5(0,q)},
hb(a,b){var s,r=this,q=r.b
if(!(a>=0&&a<q.length))return A.a(q,a)
s=q[a]
q.$flags&2&&A.b(q)
q[a]=s+1
if(s===0)r.c5(0,a)
q=r.f
if(!(b>=0&&b<40))return A.a(q,b)
s=q[b]
q.$flags&2&&A.b(q)
q[b]=s+1
if(s===0)r.c5(4,b)},
cR(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f
for(s=this.Q,r=this.as,q=0;q<5;++q){p=this.gcG()[q]
o=a.gcG()[q]
n=s[q]
m=r[q]
for(l=o.length,k=p.length,j=n.length,i=0;i<m;++i){if(!(i<j))return A.a(n,i)
h=n[i]
if(!(h>=0&&h<l))return A.a(o,h)
if(o[h]===0)a.c5(q,h)
g=o[h]
if(!(h<k))return A.a(p,h)
f=p[h]
o.$flags&2&&A.b(o)
o[h]=g+f}}a.z=!1},
gcg(){var s,r,q,p,o,n,m,l,k=this
k.dW()
for(s=k.y,r=k.w,q=k.x,p=0,o=0;o<5;++o){n=r[o]
m=q[o]
if(m===0)n=0
else{if(m<4096){l=$.fW()
if(!(m>=0&&m<l.length))return A.a(l,m)
l=l[m]}else l=Math.log(m)
l=(n+m*l)/0.6931471805599453
n=l}p+=n+s[o]*4}return p},
hJ(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.dW()
a5.dW()
for(s=a4.x,r=a5.x,q=a4.w,p=a4.y,o=a5.Q,n=a5.as,m=0,l=0;l<5;++l){k=a4.gcG()[l]
j=a5.gcG()[l]
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
if(a0>0){if(a0<4096){a2=$.fW()
if(!(a0<a2.length))return A.a(a2,a0)
a2=a2[a0]}else a2=Math.log(a0)
i+=a0*a2}else ++h
a3=a0+a1
if(a3<4096){a2=$.fW()
if(!(a3<a2.length))return A.a(a2,a3)
a2=a2[a3]}else a2=Math.log(a3)
i-=a3*a2}e=s[l]+r[l]
if(e===0)e=0
else{if(e<4096){d=$.fW()
if(!(e>=0&&e<d.length))return A.a(d,e)
d=d[e]}else d=Math.log(e)
d=(i+e*d)/0.6931471805599453
e=d}m+=e+h*4}return m},
gcG(){var s,r=this,q=r.r
if(q===$){s=A.j([r.b,r.c,r.d,r.e,r.f],t.gF)
r.r!==$&&A.nC("_arrays")
r.r=s
q=s}return q},
c5(a,b){var s,r,q,p,o,n=this.Q
if(!(a<5))return A.a(n,a)
s=n[a]
r=this.as
q=r[a]
if(q===s.length){p=q===0?8:q*2
o=new Int32Array(p)
B.u.aB(o,0,q,s)
B.c.i(n,a,o)
s=o}s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=b
r.$flags&2&&A.b(r)
r[a]=q+1},
dW(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
if(a0.z)return
for(s=a0.w,r=s.$flags|0,q=a0.x,p=q.$flags|0,o=a0.y,n=o.$flags|0,m=a0.Q,l=a0.as,k=0;k<5;++k){j=a0.gcG()[k]
i=m[k]
h=l[k]
for(g=i.length,f=j.length,e=0,d=0,c=0;c<h;++c){if(!(c<g))return A.a(i,c)
b=i[c]
if(!(b>=0&&b<f))return A.a(j,b)
a=j[b]
if(a<4096){b=$.fW()
if(!(a<b.length))return A.a(b,a)
b=b[a]}else b=Math.log(a)
e-=a*b
d+=a}r&2&&A.b(s)
s[k]=e
p&2&&A.b(q)
q[k]=d
n&2&&A.b(o)
o[k]=h}a0.z=!0}}
A.l0.prototype={}
A.m8.prototype={
$2(a,b){var s,r,q
A.n(a)
A.n(b)
s=this.a
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
q=s[a]
if(!(b>=0&&b<r))return A.a(s,b)
return B.a.bO(q,s[b])},
$S:50}
A.bW.prototype={}
A.cU.prototype={
a7(){return"VP8LImageTransformType."+this.b}}
A.iu.prototype={
ml(a,b,c,d,e,f){var s,r,q,p,o=this,n=o.b
switch(o.a.a){case 2:o.lL(e,f,(b-a)*n)
break
case 0:o.mu(a,b,c,d,e,f)
if(b!==o.c){s=f-n
B.o.ab(e,s,s+n,c,f+(b-a-1)*n)}break
case 1:o.lS(a,b,c,d,e,f)
break
case 3:if(d===f&&o.e>0){r=b-a
q=r*A.ce(n,o.e)
p=f+r*n-q
B.o.ab(e,p,p+q,c,f)
o.hr(a,b,c,p,e,f)}else o.hr(a,b,c,d,e,f)
break}},
lR(a,b,c,d){var s,r,q,p,o,n,m=this.e,l=B.a.a6(8,m),k=this.b,j=this.d
if(l<8){s=B.a.S(1,m)-1
r=B.a.S(1,l)-1
for(q=a;q<b;++q)for(p=0,o=0;o<k;++o){if((o&s)>>>0===0){p=J.d(c.a,c.d);++c.d}m=(p&r)>>>0
if(!(m>=0&&m<j.length))return A.a(j,m)
m=j[m]
J.a_(d.a,d.d,m>>>8&255);++d.d
p=B.a.j(p,l)}}else for(q=a;q<b;++q)for(o=0;o<k;++o){n=J.d(c.a,c.d);++c.d
if(!(n>=0&&n<j.length))return A.a(j,n)
m=j[n]
J.a_(d.a,d.d,m>>>8&255);++d.d}},
hr(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=this.e,i=B.a.a6(8,j),h=this.b,g=this.d
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
o=B.a.a6(o,i)}}else for(j=c.length,q=e.$flags|0,p=a;p<b;++p)for(n=0;n<h;++n,f=l,d=m){l=f+1
g.toString
m=d+1
if(!(d>=0&&d<j))return A.a(c,d)
k=c[d]>>>8&255
if(!(k<g.length))return A.a(g,k)
k=g[k]
q&2&&A.b(e)
if(!(f>=0&&f<e.length))return A.a(e,f)
e[f]=k}},
lS(a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.b,a1=a.e,a2=B.a.S(1,a1)-1,a3=A.ce(a0,a1),a4=B.a.j(a5,a.e)*a3
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
i=$.az()
i.$flags&2&&A.b(i)
i[0]=j
j=$.aH()
if(0>=j.length)return A.a(j,0)
h=j[0]
i[0]=k
g=j[0]
f=$.j_()
f.$flags&2&&A.b(f)
f[0]=h*g
e=$.my()
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
cm(a,b){return(((a&4278255360)>>>0)+((b&4278255360)>>>0)&4278255360|(a&16711935)+(b&16711935)&16711935)>>>0},
mu(b1,b2,b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=4278190080,b0=a8.b
if(b1===0){s=b3.length
if(!(b4<s))return A.a(b3,b4)
r=a8.cm(b3[b4],a9)
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
m=a8.cm(b3[k],m)
k=o+l
r&2&&A.b(b5)
if(!(k<q))return A.a(b5,k)
b5[k]=m}b4+=b0
b6+=b0;++b1}s=a8.e
j=B.a.S(1,s)
i=j-1
h=A.ce(b0,s)
g=B.a.j(b1,a8.e)*h
for(s=b3.length,r=~i,q=b5.length,f=b1;f<b2;){k=b6-b0
if(!(k>=0&&k<q))return A.a(b5,k)
e=b5[k]
if(!(b4<s))return A.a(b3,b4)
k=a8.cm(b3[b4],e)
b5.$flags&2&&A.b(b5)
if(!(b6<q))return A.a(b5,b6)
b5[b6]=k
for(d=g,c=1;c<b0;c=a1,d=b){k=a8.d
b=d+1
if(!(d<k.length))return A.a(k,d)
a=k[d]>>>8&15
a0=$.tC[a]
a1=((c&r)>>>0)+j
if(a1>b0)a1=b0
a2=b4+c
k=b6+c
a3=k-b0
a4=a1-c
if(a===0)for(a5=b5.$flags|0,l=0;l<a4;++l){a6=k+l
a7=a2+l
if(!(a7>=0&&a7<s))return A.a(b3,a7)
a7=a8.cm(b3[a7],a9)
a5&2&&A.b(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=a7}else if(a===1){a5=k-1
if(!(a5>=0&&a5<q))return A.a(b5,a5)
m=b5[a5]
for(a5=b5.$flags|0,l=0;l<a4;++l){a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
m=a8.cm(b3[a6],m)
a6=k+l
a5&2&&A.b(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=m}}else for(l=0;l<a4;++l){a5=k+l
a6=a5-1
if(!(a6>=0&&a6<q))return A.a(b5,a6)
e=a0.$3(b5[a6],b5,a3+l)
a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
a6=a8.cm(b3[a6],e)
b5.$flags&2&&A.b(b5)
if(!(a5>=0&&a5<q))return A.a(b5,a5)
b5[a5]=a6}}b4+=b0
b6+=b0;++f
if((f&i)>>>0===0)g+=h}},
lL(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=a.$flags|0,q=0;q<c;++q){p=b+q
if(!(p<s))return A.a(a,p)
o=a[p]
n=o>>>8&255
r&2&&A.b(a)
a[p]=(o&4278255360|(o&16711935)+(n<<16|n)&16711935)>>>0}}}
A.lb.prototype={
ghG(){var s=this,r=s.d
if(r>1||s.e>=4||s.f>1||s.r!==0)return!1
return!0},
lW(a,b,c){var s,r,q,p,o,n,m=this
if(!m.ghG())return!1
s=m.e
if(!(s<4))return A.a(B.ch,s)
r=B.ch[s]
if(m.d===0){s=m.b
q=a*s
p=m.a
B.d.ab(c,q,q+b*s,p.a,p.d-p.b+q)}else{s=a+b
p=m.x
p===$&&A.c("_vp8l")
p.dx=c
o=p.c
if(m.y)s=p.jh(o.a,o.b,s)
else{n=p.cx
n.toString
p=p.dS(n,o.a,o.b,s,t.kX.a(p.gma()))
s=p}if(!s)return!1}if(r!=null){s=m.b
r.$6(s,m.c,s,a,b,c)}if(m.f===1)if(!m.jK(c,m.b,m.c,a,b))return!1
if(a+b>=m.c)m.w=!0
return!0},
jK(a,b,c,d,e){if(b<=0||c<=0||d<0||e<0||d+e>c)return!1
return!0}}
A.bU.prototype={
i2(a){var s,r
a.a2(A.nE(this.a))
s=this.b
r=s.length
a.K(r)
a.a2(s)
if((r&1)===1)a.p(0)}}
A.fu.prototype={
iG(a,b){var s=this,r=a.H()
s.w=0
s.f=(r&1)!==0
s.r=(r&2)===0
s.x=a.d-a.b
s.y=b-16}}
A.hH.prototype={}
A.hj.prototype={}
A.hk.prototype={}
A.ep.prototype={
gu(a){return this.a.length-this.b}}
A.eo.prototype={
ck(a,b){var s,r,q,p,o,n=b.d2()&255,m=this.a
if(!(a<m.length))return A.a(m,a)
s=m[a]
r=s.a
q=s.b+n
if(!(q<r.length))return A.a(r,q)
p=r[q].a-8
if(p>0){b.a+=8
o=b.d2()
m=m[a]
s=m.a
r=m.b+n
if(!(r<s.length))return A.a(s,r)
n=n+s[r].b+((o&B.a.U(1,p)-1)>>>0)}else m=s
s=b.a
r=m.a
m=m.b+n
if(!(m>=0&&m<r.length))return A.a(r,m)
m=r[m]
b.a=s+m.a
return m.b}}
A.eq.prototype={}
A.hm.prototype={
eN(a){var s=this.b=this.a,r=A.mJ(a)
s.e=a
s.b=s.a=r}}
A.dQ.prototype={
a7(){return"WebPFormat."+this.b}}
A.bV.prototype={$iM:1}
A.eC.prototype={}
A.lc.prototype={
aT(a){var s,r=A.v(t.L.a(a),!1,null,0)
this.c=r
try{r=this.fl(r)
return r}catch(s){return!1}},
aK(a){return A.P(new A.lf(this,t.L.a(a)),t.b0)},
lD(a){var s,r,q,p,o=this,n=null,m=A.v(t.L.a(a),!1,n,0)
o.c=m
if(!o.fl(m))return n
m=new A.eC(B.ac,A.j([],t.J))
o.a=m
s=o.c
s.toString
if(!o.fn(s,m))return n
m=o.a
switch(m.f.a){case 3:s=o.b
A.ax(m.a,m.b,s,!1)
for(m=o.a.z,r=m.length,q=0;q<m.length;m.length===r||(0,A.L)(m),++q){p=m[q]
A.ax(p.c,p.d,s,!1)}m=o.a
m.as=m.z.length
return m
case 2:s=o.c
s.toString
s.d=m.ay
if(!A.nc(s,m).cY())return n
m=o.a
A.ax(m.a,m.b,o.b,!1)
m=o.a
m.as=m.z.length
return m
case 1:s=o.c
s.toString
s.d=m.ay
if(!A.na(s,m).cY())return n
m=o.a
A.ax(m.a,m.b,o.b,!1)
m=o.a
m.as=m.z.length
return m
case 0:throw A.f(A.l("Unknown format for WebP"))}},
an(a){return A.P(new A.ld(this,a),t.H)},
jt(a){var s,r,q,p=this,o=p.c
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
return p.h1(o.c9(s,r),a)}r=s.f
if(r===B.aD)return A.nc(o.c9(s.ch,s.ay),s).bQ()
else if(r===B.b4)return A.na(o.c9(s.ch,s.ay),s).bQ()
return null},
bg(a,b){return A.P(new A.le(this,t.L.a(a),b),t.H)},
lC(a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=null
if(a1.aK(t.L.a(a3))==null)return a2
s=a1.a
r=s.e
if(!r)return a1.an(0)
new A.bO(a1.b).ce(0,s.a*s.as,s.b)
for(s=t.N,r=t.P,q=a2,p=q,o=p,n=0;m=a1.a,n<m.as;++n){m=m.z
if(!(n<m.length))return A.a(m,n)
a4=m[n]
l=a1.an(n)
if(l==null)continue
m=a4.e
l.y=m
if(o==null||p==null){k=a1.a
j=k.a
k=k.b
i=l.gad()
h=l.a
h=h==null?a2:h.gL()
if(h==null)h=B.e
g=l.y
f=a1.a
e=f.y
d=f.c
f=f.w
if(f.length===0)f=a2
else{f=new A.ah(f)
c=f.gu(0)
b=f.gu(0)
a=new A.bE(A.J(s,r))
a.bV(new A.ai(f,0,Math.min(c,b),0,!1))
f=a}a0=a1.a.r
o=A.V(d,f,h,g,B.j,k,a0==null?a2:new A.bH("ICC_PROFILE",B.S,a0),e,i,a2,B.e,j,!1)
p=o}else{p=A.aQ(p,!1,!1)
if(q!=null){k=q.f
k===$&&A.c("clearFrame")}else k=!1
if(k){k=q.a
j=q.b
i=q.c
h=q.d
A.px(p,!1,$.q2(),k,k+i-1,j,j+h-1)}}p.y=m
m=a4.r
m===$&&A.c("blendFrame")
m=m?B.aF:B.ae
A.nu(p,l,m,a2,a2,a4.a,a4.b,a2,a2,a2,a2)
if(p!==o)o.aR(p)
q=a4}return o},
h1(a,b){var s,r,q,p=null,o=A.j([],t.J),n=new A.eC(B.ac,o)
if(!this.fn(a,n))return p
s=n.f
if(s===B.ac)return p
n.as=this.a.as
if(n.e){s=o.length
if(b>=s)return p
r=o[b]
o=r.y
o===$&&A.c("_frameSize")
s=r.x
s===$&&A.c("_framePosition")
return this.h1(a.c9(o,s),b)}else{q=a.c9(n.ch,n.ay)
if(s===B.aD)return A.nc(q,n).bQ()
else if(s===B.b4)return A.na(q,n).bQ()}return p},
fl(a){if(a.au(4)!=="RIFF")return!1
a.k()
if(a.au(4)!=="WEBP")return!1
return!0},
fn(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g
for(s=a.c,r=a.b;a.d<s;){q=a.au(4)
p=a.k()
o=p+1>>>1<<1>>>0
n=a.d
m=n-r
switch(q){case"VP8X":if(!this.kb(a,b))return!1
break
case"VP8 ":b.ay=m
b.ch=p
b.f=B.b4
break
case"VP8L":b.ay=m
b.ch=p
b.f=B.aD
break
case"ALPH":b.toString
n=a.a
l=a.e
k=J.ae(n)
j=k.gu(n)
k=k.gu(n)
n=new A.ai(n,0,Math.min(j,k),0,l)
b.at=n
n.d=a.d
a.d+=o
break
case"ANIM":b.f=B.ma
i=a.k()
n=new Uint8Array(4)
n[0]=i>>>16&255
n[1]=i>>>8&255
n[2]=i&255
n[3]=i>>>24&255
b.c=new A.cn(n)
b.y=a.n()
break
case"ANMF":if(!this.k6(a,b,p))return!1
break
case"ICCP":b.toString
h=a.aH(p)
a.d=n+(h.c-h.d)
b.r=h.Y()
break
case"EXIF":b.toString
b.w=a.au(p)
break
case"XMP ":b.toString
a.au(p)
break
default:a.d=n+o
break}n=a.d
g=o-(n-r-m)
if(g>0)a.d=n+g}if(!b.d)b.d=b.at!=null
return b.f!==B.ac},
kb(a,b){var s,r,q,p,o=a.H()
if((o&192)!==0)return!1
s=B.a.j(o,4)
r=B.a.j(o,1)
if((o&1)!==0)return!1
if(a.bt()!==0)return!1
q=a.bt()
p=a.bt()
b.a=q+1
b.b=p+1
b.e=(r&1)!==0
b.d=(s&1)!==0
return!0},
k6(a,b,c){var s=new A.hH(a.bt()*2,a.bt()*2,a.bt()+1,a.bt()+1,a.bt())
s.iG(a,c)
if(s.w!==0)return!1
B.c.C(b.z,s)
return!0}}
A.lf.prototype={
$0(){return this.a.lD(this.b)},
$S:38}
A.ld.prototype={
$0(){return this.a.jt(this.b)},
$S:1}
A.le.prototype={
$0(){return this.a.lC(this.b,this.c)},
$S:1}
A.lg.prototype={
bR(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b
A.ci(a)
s=a.gae().length>1
if(s)A.tE(a)
r=A.tF(a)
q=A.tH(a)
p=this.fh(a)
o=p.length>1
if(!s&&r==null&&q==null&&!o)return A.pq(p)
n=q!=null
m=o||A.tG(a)
l=r!=null
k=n?32:0
m=m?16:0
j=l?8:0
i=s?2:0
h=a.gN()
g=a.gJ()
f=A.a0(!1,8192)
f.p(k|m|j|i|0)
f.p(0)
f.p(0)
f.p(0)
A.e_(f,h-1)
A.e_(f,g-1)
e=A.j([new A.bU("VP8X",J.C(B.d.gq(f.c),0,f.a))],t.iu)
if(n)B.c.C(e,new A.bU("ICCP",q))
if(s){d=a.f
n=A.lh(d,new A.li())
m=A.lh(d,new A.lj())
k=A.lh(d,new A.lk())
j=A.lh(d,new A.ll())
i=a.r
f=A.a0(!1,8192)
f.K((j<<24|n<<16|m<<8|k)>>>0)
f.a3(B.a.F(i,0,65535))
B.c.C(e,new A.bU("ANIM",J.C(B.d.gq(f.c),0,f.a)))
for(n=a.gae(),m=n.length,c=0;c<n.length;n.length===m||(0,A.L)(n),++c){b=n[c]
k=b.a
j=k==null
i=j?null:k.a
if(i==null)i=0
k=j?null:k.b
if(k==null)k=0
j=b.y
B.c.C(e,new A.bU("ANMF",A.vp(!1,!0,j,b===a?p:this.fh(b),k,i,0,0)))}}else B.c.cf(e,p)
if(l)B.c.C(e,new A.bU("EXIF",r))
return A.pq(e)},
fh(a){var s=A.j([new A.bU("VP8L",new A.l5(!0).m8(a))],t.iu)
return s}}
A.li.prototype={
$1(a){var s=a.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
$S:7}
A.lj.prototype={
$1(a){return a.gA()},
$S:7}
A.lk.prototype={
$1(a){return a.gB()},
$S:7}
A.ll.prototype={
$1(a){return a.gv()},
$S:7}
A.hn.prototype={
a7(){return"IccProfileCompression."+this.b}}
A.bH.prototype={
lT(){var s,r=this
if(r.b===B.aL)return r.c
s=B.bb.hA(t.L.a(r.c),null)
r.c=s
r.b=B.aL
return s},
hv(){var s,r=this
if(r.b===B.S)return r.c
s=A.iV(r.c,16777216)
r.c=s
r.b=B.S
return s}}
A.hi.prototype={
a7(){return"FrameType."+this.b}}
A.an.prototype={
gae(){var s=this.x
return s===$?this.x=A.j([],t.g):s},
iz(a,b,c,d){var s,r,q,p=this,o=a.gL(),n=a.gad(),m=a.a
p.f8(d,b,o,n,m==null?null:m.gR())
o=a.b
if(o!=null)p.b=A.eJ(o,t.N,t.x)
o=a.d
if(o!=null){n=t.N
p.d=A.eJ(o,n,n)}B.c.C(p.gae(),p)
if(!c){s=a.gae().length
for(o=t.g,r=1;r<s;++r){q=a.x
if(q===$)q=a.x=A.j([],o)
if(!(r<q.length))return A.a(q,r)
p.aR(A.hs(q[r],b,!1,d))}}},
iy(a,b,c){var s,r,q,p,o=this,n=a.b
if(n!=null)o.b=A.eJ(n,t.N,t.x)
n=a.d
if(n!=null){s=t.N
o.d=A.eJ(n,s,s)}B.c.C(o.gae(),o)
if(!b&&a.gae().length>1){r=a.gae().length
for(n=t.g,q=1;q<r;++q){p=a.x
if(p===$)p=a.x=A.j([],n)
if(!(q<p.length))return A.a(p,q)
o.aR(A.aQ(p[q],!1,!1))}}},
aR(a){var s=this
if(a==null)a=A.aQ(s,!0,!0)
a.z=s.gae().length
if(s.gae().length===0||B.c.gem(s.gae())!==a)B.c.C(s.gae(),a)
return a},
dv(){return this.aR(null)},
f8(a,b,c,d,e){var s,r,q=this,p=null
switch(c.a){case 0:if(e==null){s=B.b.bj(a*d/8)
r=new A.dp($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bj(a/8)
r=new A.dp($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 1:if(e==null){s=B.b.bj(a*(d<<1>>>0)/8)
r=new A.dq($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bj(a/4)
r=new A.dq($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 2:if(e==null){if(d===2)s=a
else if(d===4)s=a*2
else s=d===3?B.b.bj(a*1.5):B.b.bj(a/2)
r=new A.ds($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bj(a/2)
r=new A.ds($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 3:if(e==null)q.a=A.oi(a,b,d)
else q.a=new A.dt(new Uint8Array(a*b),e,a,b,1)
break
case 4:s=a*b
if(e==null)q.a=new A.cx(new Uint16Array(s*d),p,a,b,d)
else q.a=new A.cx(new Uint16Array(s),e,a,b,1)
break
case 5:q.a=A.qW(a,b,d)
break
case 6:q.a=new A.eu(new Int8Array(a*b*d),a,b,d)
break
case 7:q.a=new A.es(new Int16Array(a*b*d),a,b,d)
break
case 8:q.a=new A.et(new Int32Array(a*b*d),a,b,d)
break
case 9:q.a=A.qU(a,b,d)
break
case 10:q.a=A.qV(a,b,d)
break
case 11:q.a=new A.er(new Float64Array(a*b*4*d),a,b,d)
break}},
D(a){var s=this
return"Image("+s.gN()+", "+s.gJ()+", "+s.gL().b+", "+s.gad()+")"},
gN(){var s=this.a
s=s==null?null:s.a
return s==null?0:s},
gJ(){var s=this.a
s=s==null?null:s.b
return s==null?0:s},
gL(){var s=this.a
s=s==null?null:s.gL()
return s==null?B.e:s},
gbh(){var s=this.e
return s==null?this.e=new A.bE(A.J(t.N,t.P)):s},
i8(a,b){var s=this,r=s.b;(r==null?s.b=A.J(t.N,t.x):r).i(0,a,b)
if(s.b.a===0)s.b=null},
gI(a){var s=this.a
return s.gI(s)},
gq(a){var s=this.a
s=s==null?null:s.gq(s)
if(s==null)s=B.d.gq(new Uint8Array(0))
return s},
Y(){var s=this.a
s=s==null?null:J.G(s.gq(s))
return s==null?J.G(this.gq(0)):s},
gcA(a){var s=this.a
s=s==null?null:J.qk(s.gq(s))
return s==null?0:s},
gad(){var s=this.a
s=s==null?null:s.gR()
s=s==null?null:s.b
if(s==null){s=this.a
s=s==null?null:s.c}return s==null?0:s},
gb4(){var s=this.a
s=s==null?null:s.gb4()
return s===!0},
gaw(){var s=this.a
return(s==null?null:s.gR())!=null},
gaN(){var s=this.a
s=s==null?null:s.gaN()
return s==null?0:s},
hF(a,b){return a>=0&&b>=0&&a<this.gN()&&b<this.gJ()},
b8(a,b,c,d){var s=this.a
s=s==null?null:s.b8(a,b,c,d)
if(s==null)s=new A.bd(new Uint8Array(0))
return s},
P(a,b,c){var s=this.a
s=s==null?null:s.P(a,b,c)
return s==null?new A.E():s},
aU(a,b){return this.P(a,b,null)},
ao(a,b){if(a<0||a>=this.gN()||b<0||b>=this.gJ())return new A.E()
return this.P(a,b,null)},
ew(a,b,c){switch(c.a){case 0:return this.ao(B.b.h(a),B.b.h(b))
case 1:case 3:return this.i5(a,b)
case 2:return this.i4(a,b)}},
i5(a,b){var s,r,q,p,o,n,m=this,l=B.b.h(a),k=l-(a>=0?0:1),j=k+1
l=B.b.h(b)
s=l-(b>=0?0:1)
r=s+1
l=new A.jD(a-k,b-s)
q=m.ao(k,s)
p=r>=m.gJ()?q:m.ao(k,r)
o=j>=m.gN()?q:m.ao(j,s)
n=j>=m.gN()||r>=m.gJ()?q:m.ao(j,r)
return m.b8(l.$4(q.gt(),o.gt(),p.gt(),n.gt()),l.$4(q.gA(),o.gA(),p.gA(),n.gA()),l.$4(q.gB(),o.gB(),p.gB(),n.gB()),l.$4(q.gv(),o.gv(),p.gv(),n.gv()))},
i4(c8,c9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2=this,c3=B.b.h(c8),c4=c3-(c8>=0?0:1),c5=c4-1,c6=c4+1,c7=c4+2
c3=B.b.h(c9)
s=c3-(c9>=0?0:1)
r=s-1
q=s+1
p=s+2
o=c8-c4
n=c9-s
c3=new A.jC()
m=c2.ao(c4,s)
l=c5<0
k=!l
j=!k||r<0?m:c2.ao(c5,r)
i=r<0
h=i?m:c2.ao(c4,r)
g=i||c6>=c2.gN()?m:c2.ao(c6,r)
f=c7>=c2.gN()||i?m:c2.ao(c7,r)
e=c3.$5(o,j.gt(),h.gt(),g.gt(),f.gt())
d=c3.$5(o,j.gA(),h.gA(),g.gA(),f.gA())
c=c3.$5(o,j.gB(),h.gB(),g.gB(),f.gB())
b=c3.$5(o,j.gv(),h.gv(),g.gv(),f.gv())
a=l?m:c2.ao(c5,s)
a0=c6>=c2.gN()?m:c2.ao(c6,s)
a1=c7>=c2.gN()?m:c2.ao(c7,s)
a2=c3.$5(o,a.gt(),m.gt(),a0.gt(),a1.gt())
a3=c3.$5(o,a.gA(),m.gA(),a0.gA(),a1.gA())
a4=c3.$5(o,a.gB(),m.gB(),a0.gB(),a1.gB())
a5=c3.$5(o,a.gv(),m.gv(),a0.gv(),a1.gv())
a6=!k||q>=c2.gJ()?m:c2.ao(c5,q)
a7=q>=c2.gJ()?m:c2.ao(c4,q)
a8=c6>=c2.gN()||q>=c2.gJ()?m:c2.ao(c6,q)
a9=c7>=c2.gN()||q>=c2.gJ()?m:c2.ao(c7,q)
b0=c3.$5(o,a6.gt(),a7.gt(),a8.gt(),a9.gt())
b1=c3.$5(o,a6.gA(),a7.gA(),a8.gA(),a9.gA())
b2=c3.$5(o,a6.gB(),a7.gB(),a8.gB(),a9.gB())
b3=c3.$5(o,a6.gv(),a7.gv(),a8.gv(),a9.gv())
b4=!k||p>=c2.gJ()?m:c2.ao(c5,p)
b5=p>=c2.gJ()?m:c2.ao(c4,p)
b6=c6>=c2.gN()||p>=c2.gJ()?m:c2.ao(c6,p)
b7=c7>=c2.gN()||p>=c2.gJ()?m:c2.ao(c7,p)
b8=c3.$5(o,b4.gt(),b5.gt(),b6.gt(),b7.gt())
b9=c3.$5(o,b4.gA(),b5.gA(),b6.gA(),b7.gA())
c0=c3.$5(o,b4.gB(),b5.gB(),b6.gB(),b7.gB())
c1=c3.$5(o,b4.gv(),b5.gv(),b6.gv(),b7.gv())
return c2.b8(c3.$5(n,e,a2,b0,b8),c3.$5(n,d,a3,b1,b9),c3.$5(n,c,a4,b2,c0),c3.$5(n,b,a5,b3,c1))},
c8(a,b,c){var s
if(t.mK.b(c))if(c.gbl().gR()!=null)if(this.gaw()){s=this.a
if(s!=null)s.aP(a,b,c.gW(),0,0)
return}s=this.a
if(s!=null)s.aA(a,b,c.gt(),c.gA(),c.gB(),c.gv())},
i9(a,b,c){var s=this.a
return s==null?null:s.aO(a,b,c)},
gG(){var s=this.a
s=s==null?null:s.gG()
return s==null?0:s},
bb(a,b){var s=this.a
return s==null?null:s.bb(0,b)},
cT(a){return this.bb(0,null)},
cW(a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=this,a7=null
if(a9==null)a9=a6.gL()
if(b0==null)b0=a6.gad()
s=a8==null
if(s)a8=B.cn.l(0,a9)
r=!1
if(a9===a6.gL())if(b0===a6.gad()){if(!b1){q=a6.a
q=(q==null?a7:q.gR())==null}else q=!1
if(!q){if(b1){r=a6.a
r=(r==null?a7:r.gR())!=null}}else r=!0}if(r){p=A.aQ(a6,!1,!1)
if(!s)s=p.gad()===2||p.gad()===4
else s=!1
if(s)for(s=p.gae(),r=s.length,o=0;o<s.length;s.length===r||(0,A.L)(s),++o)for(q=s[o].a,q=q.gI(q);q.E();){n=q.gO()
a8.toString
n.sv(a8)}return p}for(s=a6.gae(),r=s.length,q=t.N,m=t.p,l=a7,o=0;o<s.length;s.length===r||(0,A.L)(s),++o,l=c){k=s[o]
j=k.a
i=j==null
h=i?a7:j.a
if(h==null)h=0
j=i?a7:j.b
if(j==null)j=0
i=k.e
i=i==null?a7:A.ee(i)
g=k.c
if(g==null)g=a7
else{f=g.a
e=g.b
g=g.c
g=new A.bH(f,e,new Uint8Array(g.subarray(0,A.iO(0,a7,g.length))))}f=k.f
f=f==null?a7:new A.bd(new Uint8Array(A.p(f.a)))
e=k.w
d=k.r
p=A.V(f,i,a9,k.y,e,j,g,d,b0,a7,B.e,h,b1)
j=k.d
p.smJ(j!=null?A.eJ(j,q,q):a7)
if(l!=null){l.aR(p)
c=l}else c=p
j=p.a
b=j==null?a7:j.gR()
j=p.a
j=j==null?a7:j.gR()
a=j==null?a7:j.gL()
if(a==null)a=a9
j=k.a
if(b!=null){a0=A.J(m,m)
a1=j==null?a7:j.P(0,0,a7)
if(a1==null)a1=new A.E()
for(j=p.a,j=j.gI(j),a2=0;j.E();){a3=j.gO()
a4=A.pL(B.b.b3(a1.gal()*255),B.b.b3(a1.gai()*255),B.b.b3(a1.gak()*255),0)
if(a0.ac(a4)){i=a0.l(0,a4)
i.toString
a3.sW(i)}else{a0.i(0,a4,a2)
a3.sW(a2)
a5=A.aM(a1,a8,a,b0,a7)
b.ba(a2,a5.gt(),a5.gA(),a5.gB());++a2}a1.E()}}else{a1=j==null?a7:j.P(0,0,a7)
if(a1==null)a1=new A.E()
for(j=p.a,j=j.gI(j);j.E();){A.aM(a1,a8,a7,a7,j.gO())
a1.E()}}}l.toString
return l},
aS(a){return this.cW(null,a,null,!1)},
dz(a){return this.cW(null,null,a,!1)},
lU(a,b,c){return this.cW(null,a,b,c)},
cw(a,b){return this.cW(null,a,null,b)},
cV(a,b){return this.cW(null,a,b,!1)},
lM(a){var s,r,q,p
t.je.a(a)
if(this.d==null){s=t.N
this.d=A.J(s,s)}for(s=new A.Y(a,a.r,a.e,A.m(a).m("Y<1>"));s.E();){r=s.d
q=this.d
q.toString
p=a.l(0,r)
p.toString
q.i(0,r,p)}},
jb(a,b,c){var s,r=65536
switch(b.a){case 0:return null
case 1:return null
case 2:return null
case 3:s=a===B.n?r:256
return new A.aT(new Uint8Array(s*c),s,c)
case 4:s=a===B.n?r:256
return new A.f4(new Uint16Array(s*c),s,c)
case 5:s=a===B.n?r:256
return new A.dC(new Uint32Array(s*c),s,c)
case 6:s=a===B.n?r:256
return new A.f3(new Int8Array(s*c),s,c)
case 7:s=a===B.n?r:256
return new A.f1(new Int16Array(s*c),s,c)
case 8:s=a===B.n?r:256
return new A.f2(new Int32Array(s*c),s,c)
case 9:s=a===B.n?r:256
return new A.eZ(new Uint16Array(s*c),s,c)
case 10:s=a===B.n?r:256
return new A.f_(new Float32Array(s*c),s,c)
case 11:s=a===B.n?r:256
return new A.f0(new Float64Array(s*c),s,c)}},
smJ(a){this.d=t.lG.a(a)}}
A.jD.prototype={
$4(a,b,c,d){var s=this.b
return a+this.a*(b-a+s*(a+d-c-b))+s*(c-a)},
$S:40}
A.jC.prototype={
$5(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
$S:41}
A.ao.prototype={
gR(){return null}}
A.dm.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Uint16Array(r.length)
else r=new Uint16Array(A.p(r))
return new A.dm(r,s.a,s.b,s.c)},
gL(){return B.H},
gbr(){return B.aK},
gq(a){return B.D.gq(this.d)},
gaN(){return 16},
gaz(){return this.a*this.c*2},
gI(a){return A.mS(this)},
bm(a,b,c,d,e){return A.bj(A.mS(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gG(){return 1},
gb4(){return!0},
b8(a,b,c,d){var s=new Uint16Array(4),r=new A.d6(s)
s[0]=A.O(a)
s[1]=A.O(b)
s[2]=A.O(c)
s[3]=A.O(d)
s=r
return s},
P(a,b,c){if(c==null||!(c instanceof A.cF)||c.d!==this)c=A.mS(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=A.O(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d,o=A.O(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=A.O(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=A.O(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.O(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=A.O(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=A.O(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=A.O(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=A.O(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataFloat16("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.dn.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Float32Array(r.length)
else r=new Float32Array(A.p(r))
return new A.dn(r,s.a,s.b,s.c)},
gL(){return B.I},
gbr(){return B.aK},
gq(a){return B.a8.gq(this.d)},
gaN(){return 32},
gI(a){return A.mT(this)},
bm(a,b,c,d,e){return A.bj(A.mT(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gG(){return 1},
gaz(){return this.a*this.c*4},
gb4(){return!0},
b8(a,b,c,d){var s=new Float32Array(4),r=new A.d7(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
P(a,b,c){if(c==null||!(c instanceof A.cG)||c.d!==this)c=A.mT(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s=this.c,r=b*this.a*s+a*s
s=this.d
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=c
if(r>2){r=q+1
if(!(r<s))return A.a(p,r)
p[r]=d
r=q+2
if(!(r<s))return A.a(p,r)
p[r]=e}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q===2){q=p+1
if(!(q<s))return A.a(o,q)
o[q]=f}else if(q>2){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
r=p+2
if(!(r<s))return A.a(o,r)
o[r]=e
if(q>3){q=p+3
if(!(q<s))return A.a(o,q)
o[q]=f}}},
D(a){return"ImageDataFloat32("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.er.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Float64Array(r.length)
else r=new Float64Array(A.p(r))
return new A.er(r,s.a,s.b,s.c)},
gL(){return B.Q},
gbr(){return B.aK},
gq(a){return B.q.gq(this.d)},
gu(a){return this.d.byteLength},
gaN(){return 64},
gI(a){return A.mU(this)},
bm(a,b,c,d,e){return A.bj(A.mU(this),b,c,d,e)},
gG(){return 1},
gaz(){return this.a*this.c*8},
gb4(){return!0},
b8(a,b,c,d){var s=new Float64Array(4),r=new A.d8(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
P(a,b,c){if(c==null||!(c instanceof A.cH)||c.d!==this)c=A.mU(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s=this.c,r=b*this.a*s+a*s
s=this.d
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=c
if(r>2){r=q+1
if(!(r<s))return A.a(p,r)
p[r]=d
r=q+2
if(!(r<s))return A.a(p,r)
p[r]=e}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q===2){q=p+1
if(!(q<s))return A.a(o,q)
o[q]=f}else if(q>2){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
r=p+2
if(!(r<s))return A.a(o,r)
o[r]=e
if(q>3){q=p+3
if(!(q<s))return A.a(o,q)
o[q]=f}}},
D(a){return"ImageDataFloat64("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.es.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Int16Array(r.length)
else r=new Int16Array(A.p(r))
return new A.es(r,s.a,s.b,s.c)},
gL(){return B.V},
gbr(){return B.aJ},
gq(a){return B.a9.gq(this.d)},
gI(a){return A.mV(this)},
bm(a,b,c,d,e){return A.bj(A.mV(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gG(){return 32767},
gb4(){return!0},
gaN(){return 16},
gaz(){return this.a*this.c*2},
b8(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int16Array(4),n=new A.d9(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cI)||c.d!==this)c=A.mV(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d,o=B.b.h(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=B.b.h(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=B.b.h(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.h(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=B.b.h(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=B.b.h(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataInt16("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.et.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Int32Array(r.length)
else r=new Int32Array(A.p(r))
return new A.et(r,s.a,s.b,s.c)},
gL(){return B.W},
gbr(){return B.aJ},
gq(a){return B.u.gq(this.d)},
gaN(){return 32},
gaz(){return this.a*this.c*4},
gI(a){return A.mW(this)},
bm(a,b,c,d,e){return A.bj(A.mW(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gG(){return 2147483647},
gb4(){return!0},
b8(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int32Array(4),n=new A.da(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cJ)||c.d!==this)c=A.mW(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d,o=B.b.h(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=B.b.h(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=B.b.h(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.h(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=B.b.h(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=B.b.h(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataInt32("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.eu.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Int8Array(r.length)
else r=new Int8Array(A.p(r))
return new A.eu(r,s.a,s.b,s.c)},
gL(){return B.U},
gbr(){return B.aJ},
gq(a){return B.aB.gq(this.d)},
gaz(){return this.a*this.c},
gI(a){return A.mX(this)},
bm(a,b,c,d,e){return A.bj(A.mX(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gG(){return 127},
gb4(){return!0},
gaN(){return 8},
b8(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Int8Array(4),n=new A.db(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cK)||c.d!==this)c=A.mX(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
r=this.d
s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*(this.a*r)+a*r,p=this.d,o=B.b.h(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=B.b.h(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=B.b.h(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.h(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=B.b.h(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=B.b.h(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataInt8("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.dp.prototype={
mU(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.A("data")
this.d=s},
bp(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.p(q))}s=r.f
s=s==null?null:s.X()
return new A.dp(q,r.e,s,r.a,r.b,r.c)},
gL(){return B.A},
gbr(){return B.P},
gu(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gG(){var s=this.f
s=s==null?null:s.gG()
return s==null?1:s},
gb4(){return!1},
gq(a){var s=this.d
s===$&&A.c("data")
return B.d.gq(s)},
gaN(){return 1},
gI(a){return A.f5(this)},
bm(a,b,c,d,e){return A.bj(A.f5(this),b,c,d,e)},
b8(a,b,c,d){var s=new A.dc(4,0)
s.ap(B.b.h(a),B.b.h(b),B.b.h(c),B.b.h(d))
return s},
P(a,b,c){if(c==null||!(c instanceof A.cL)||c.f!==this)c=A.f5(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f5(r):s).a9(a,b)
r.r.aC(0,c)},
aP(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f5(r):s).a9(a,b)
r.r.aG(c,d,e)},
aA(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f5(r):s).a9(a,b)
r.r.ap(c,d,e,f)},
D(a){return"ImageDataUint1("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){},
gaz(){return this.e},
gR(){return this.f}}
A.cx.prototype={
bp(a){var s,r=this,q=r.d
if(a)q=new Uint16Array(q.length)
else q=new Uint16Array(A.p(q))
s=r.e
s=s==null?null:s.X()
return new A.cx(q,s,r.a,r.b,r.c)},
gL(){return B.n},
gbr(){return B.P},
gq(a){return B.D.gq(this.d)},
gaN(){return 16},
gG(){var s=this.e
s=s==null?null:s.gG()
return s==null?65535:s},
gaz(){return this.a*this.c*2},
gI(a){return A.mY(this)},
bm(a,b,c,d,e){return A.bj(A.mY(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gb4(){return!0},
b8(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Uint16Array(4),n=new A.dd(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cM)||c.d!==this)c=A.mY(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d,o=B.b.h(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=B.b.h(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=B.b.h(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.h(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=B.b.h(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=B.b.h(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataUint16("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){},
gR(){return this.e}}
A.dq.prototype={
mV(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.A("data")
this.d=s},
bp(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.p(q))}s=r.f
s=s==null?null:s.X()
return new A.dq(q,r.e,s,r.a,r.b,r.c)},
gL(){return B.w},
gbr(){return B.P},
gaN(){return 2},
gq(a){var s=this.d
s===$&&A.c("data")
return B.d.gq(s)},
gI(a){return A.f6(this)},
bm(a,b,c,d,e){return A.bj(A.f6(this),b,c,d,e)},
gu(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gG(){var s=this.f
s=s==null?null:s.gG()
return s==null?3:s},
gb4(){return!1},
b8(a,b,c,d){var s=new A.de(4,0)
s.ap(B.b.h(a),B.b.h(b),B.b.h(c),B.b.h(d))
return s},
P(a,b,c){if(c==null||!(c instanceof A.cN)||c.f!==this)c=A.f6(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f6(r):s).a9(a,b)
r.r.aD(0,c)},
aP(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f6(r):s).a9(a,b)
r.r.aG(c,d,e)},
aA(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f6(r):s).a9(a,b)
r.r.ap(c,d,e,f)},
D(a){return"ImageDataUint2("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){},
gaz(){return this.e},
gR(){return this.f}}
A.dr.prototype={
bp(a){var s=this,r=s.d
if(a)r=new Uint32Array(r.length)
else r=new Uint32Array(A.p(r))
return new A.dr(r,s.a,s.b,s.c)},
gL(){return B.R},
gbr(){return B.P},
gq(a){return B.o.gq(this.d)},
gaz(){return this.a*this.c*4},
gaN(){return 32},
gG(){return 4294967295},
gI(a){return A.mZ(this)},
bm(a,b,c,d,e){return A.bj(A.mZ(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gb4(){return!0},
b8(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new Uint32Array(4),n=new A.df(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
P(a,b,c){if(c==null||!(c instanceof A.cO)||c.d!==this)c=A.mZ(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*this.a*r+a*r,p=this.d,o=B.b.h(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=B.b.h(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=B.b.h(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.h(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=B.b.h(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=B.b.h(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataUint32("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){}}
A.ds.prototype={
mW(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.A("data")
this.d=s},
bp(a){var s,r=this,q=r.d
if(a){q===$&&A.c("data")
q=new Uint8Array(q.length)}else{q===$&&A.c("data")
q=new Uint8Array(A.p(q))}s=r.f
s=s==null?null:s.X()
return new A.ds(q,r.e,s,r.a,r.b,r.c)},
gL(){return B.B},
gbr(){return B.P},
gq(a){var s=this.d
s===$&&A.c("data")
return B.d.gq(s)},
gI(a){return A.f7(this)},
bm(a,b,c,d,e){return A.bj(A.f7(this),b,c,d,e)},
gu(a){var s=this.d
s===$&&A.c("data")
return s.byteLength},
gG(){var s=this.f
s=s==null?null:s.gG()
return s==null?15:s},
gb4(){return!1},
gaN(){return 4},
b8(a,b,c,d){var s=B.b.h(a),r=B.b.h(b),q=B.b.h(c),p=B.b.h(d),o=new A.dg(4,new Uint8Array(2))
o.ap(s,r,q,p)
s=o
return s},
P(a,b,c){if(c==null||!(c instanceof A.cP)||c.e!==this)c=A.f7(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f7(r):s).a9(a,b)
r.r.aE(0,c)},
aP(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f7(r):s).a9(a,b)
r.r.aG(c,d,e)},
aA(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.f7(r):s).a9(a,b)
r.r.ap(c,d,e,f)},
D(a){return"ImageDataUint4("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){},
gaz(){return this.e},
gR(){return this.f}}
A.dt.prototype={
bp(a){var s,r=this,q=r.d
if(a)q=new Uint8Array(q.length)
else q=new Uint8Array(A.p(q))
s=r.e
s=s==null?null:s.X()
return new A.dt(q,s,r.a,r.b,r.c)},
gL(){return B.e},
gbr(){return B.P},
gq(a){return B.d.gq(this.d)},
gaz(){return this.a*this.c},
gaN(){return 8},
gI(a){return A.k6(this)},
bm(a,b,c,d,e){return A.bj(A.k6(this),b,c,d,e)},
gu(a){return this.d.byteLength},
gG(){var s=this.e
s=s==null?null:s.gG()
return s==null?255:s},
gb4(){return!1},
b8(a,b,c,d){var s=A.o_(B.b.h(B.b.F(a,0,255)),B.b.h(B.b.F(b,0,255)),B.b.h(B.b.F(c,0,255)),B.b.h(B.b.F(d,0,255)))
return s},
P(a,b,c){if(c==null||!(c instanceof A.cQ)||c.d!==this)c=A.k6(this)
c.a9(a,b)
return c},
aU(a,b){return this.P(a,b,null)},
aO(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
r=this.d
s=B.b.h(c)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
aP(a,b,c,d,e){var s,r=this.c,q=b*(this.a*r)+a*r,p=this.d,o=B.b.h(c)
p.$flags&2&&A.b(p)
s=p.length
if(!(q>=0&&q<s))return A.a(p,q)
p[q]=o
if(r>2){r=q+1
o=B.b.h(d)
if(!(r<s))return A.a(p,r)
p[r]=o
o=q+2
r=B.b.h(e)
if(!(o<s))return A.a(p,o)
p[o]=r}},
aA(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.h(c)
o.$flags&2&&A.b(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q===2){q=p+1
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}else if(q>2){n=p+1
r=B.b.h(d)
if(!(n<s))return A.a(o,n)
o[n]=r
r=p+2
n=B.b.h(e)
if(!(r<s))return A.a(o,r)
o[r]=n
if(q>3){q=p+3
n=B.b.h(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
D(a){return"ImageDataUint8("+this.a+", "+this.b+", "+this.c+")"},
bb(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=b==null?g:A.aM(b,g,B.e,g,g),e=h.c
if(e===1){s=f==null?0:B.a.F(A.n(f.gt()),0,255)
e=h.d
B.d.a8(e,0,e.length,s)}else if(e===2){e=f==null
s=e?0:B.a.F(A.n(f.gt()),0,255)
r=e?0:B.a.F(A.n(f.gv()),0,255)
q=J.nQ(B.d.gq(h.d),0,null)
B.D.a8(q,0,q.length,(r<<8|s)>>>0)}else if(e===4){e=f==null
s=e?0:B.a.F(A.n(f.gt()),0,255)
p=e?0:B.a.F(A.n(f.gA()),0,255)
o=e?0:B.a.F(A.n(f.gB()),0,255)
r=e?0:B.a.F(A.n(f.gv()),0,255)
n=J.a1(B.d.gq(h.d),0,null)
B.o.a8(n,0,n.length,(r<<24|o<<16|p<<8|s)>>>0)}else{e=f==null
s=e?0:B.a.F(A.n(f.gt()),0,255)
p=e?0:B.a.F(A.n(f.gA()),0,255)
o=e?0:B.a.F(A.n(f.gB()),0,255)
for(m=A.k6(h),e=m.d,l=e.c>0,e=e.d,k=e.$flags|0;m.E();){if(l){j=m.c
i=B.b.h(B.a.F(s,0,255))
k&2&&A.b(e)
if(!(j>=0&&j<e.length))return A.a(e,j)
e[j]=i}m.sA(p)
m.sB(o)}}},
gR(){return this.e}}
A.eD.prototype={
a7(){return"Interpolation."+this.b}}
A.b2.prototype={}
A.eZ.prototype={
X(){return new A.eZ(new Uint16Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.D.gq(this.c)},
gL(){return B.H},
gG(){return 1},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=A.O(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=A.O(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=A.O(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=A.O(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s,r
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
return r[s]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.f_.prototype={
X(){return new A.f_(new Float32Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.a8.gq(this.c)},
gL(){return B.I},
gG(){return 1},
a_(a,b,c){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c}},
ba(a,b,c,d){var s,r,q,p=this.b
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
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.f0.prototype={
X(){return new A.f0(new Float64Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.q.gq(this.c)},
gL(){return B.Q},
gG(){return 1},
a_(a,b,c){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c}},
ba(a,b,c,d){var s,r,q,p=this.b
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
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.f1.prototype={
X(){return new A.f1(new Int16Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.a9.gq(this.c)},
gL(){return B.V},
gG(){return 32767},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.h(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.h(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.f2.prototype={
X(){return new A.f2(new Int32Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.u.gq(this.c)},
gL(){return B.W},
gG(){return 2147483647},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.h(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.h(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.f3.prototype={
X(){return new A.f3(new Int8Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.aB.gq(this.c)},
gL(){return B.U},
gG(){return 127},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.h(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.h(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.f4.prototype={
X(){return new A.f4(new Uint16Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.D.gq(this.c)},
gL(){return B.n},
gG(){return 65535},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.h(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.h(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.dC.prototype={
X(){return new A.dC(new Uint32Array(A.p(this.c)),this.a,this.b)},
gq(a){return B.o.gq(this.c)},
gL(){return B.R},
gG(){return 4294967295},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.h(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.h(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
b1(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b0(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b7(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.aT.prototype={
X(){return A.ow(this)},
gq(a){return B.d.gq(this.c)},
gL(){return B.e},
gG(){return 255},
a_(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.h(c)
s.$flags&2&&A.b(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
ba(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.b.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=B.b.h(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
d6(a,b,c,d,e){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.a.h(b)
s.$flags&2&&A.b(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=B.a.h(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){r=a+2
p=B.a.h(d)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>3){o=a+3
r=B.a.h(e)
if(!(o<q))return A.a(s,o)
s[o]=r}}}},
aY(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
b2(a){var s,r
a*=this.b
s=this.c
r=s.length
if(a>=r)return 0
if(!(a>=0))return A.a(s,a)
return s[a]},
b1(a){var s,r,q=this.b
if(q<2)return 0
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+1
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
b0(a){var s,r,q=this.b
if(q<3)return 0
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+2
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
b7(a){var s,r,q=this.b
if(q<4)return 255
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+3
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
bE(a,b){return this.a_(a,0,b)},
bD(a,b){return this.a_(a,1,b)},
bC(a,b){return this.a_(a,2,b)},
bB(a,b){return this.a_(a,3,b)}}
A.cF.prototype={
X(){var s=this
return new A.cF(s.a,s.b,s.c,s.d)},
gL(){return B.H},
gu(a){return this.d.c},
gR(){return null},
gG(){return 1},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=A.O(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.N
r=r!=null?r:A.Q()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=A.O(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.O(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=A.O(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=A.O(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=A.O(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.N
s=s!=null?s:A.Q()
if(!(r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=1
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=A.O(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=A.O(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/1},
sal(a){this.st(a)},
gai(){return this.gA()/1},
sai(a){this.sA(a)},
gak(){return this.gB()/1},
sak(a){this.sB(a)},
ga1(){return this.gv()/1},
sa1(a){this.sv(a)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
if(s.d.c>0){s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())}},
aG(a,b,c){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.O(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){n=p.c+1
s=A.O(b)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s
s=p.c+2
n=A.O(c)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=n}}},
ap(a,b,c,d){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.O(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=p.c+1
s=A.O(d)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}else if(n>2){s=p.c+1
r=A.O(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
r=p.c+2
s=A.O(c)
if(!(r>=0&&r<q))return A.a(o,r)
o[r]=s
if(n>3){n=p.c+3
s=A.O(d)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cF){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cG.prototype={
X(){var s=this
return new A.cG(s.a,s.b,s.c,s.d)},
gu(a){return this.d.c},
gR(){return null},
gG(){return 1},
gL(){return B.I},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
i(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=c}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}else if(r>1){s=s.d
r=this.c+1
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}else if(r>2){s=s.d
r=this.c+2
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=1
return s},
sv(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}else if(r>3){s=s.d
r=this.c+3
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}},
gal(){return this.gt()/1},
sal(a){this.st(a)},
gai(){return this.gA()/1},
sai(a){this.sA(a)},
gak(){return this.gB()/1},
sak(a){this.sB(a)},
ga1(){return this.gv()/1},
sa1(a){this.sv(a)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r=this.d,q=r.d,p=this.c
q.$flags&2&&A.b(q)
s=q.length
if(!(p>=0&&p<s))return A.a(q,p)
q[p]=a
if(r.c>2){r=p+1
if(!(r<s))return A.a(q,r)
q[r]=b
p+=2
if(!(p<s))return A.a(q,p)
q[p]=c}},
ap(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.b(p)
s=p.length
if(!(o>=0&&o<s))return A.a(p,o)
p[o]=a
q=q.c
if(q===2){q=o+1
if(!(q<s))return A.a(p,q)
p[q]=d}else if(q>2){r=o+1
if(!(r<s))return A.a(p,r)
p[r]=b
r=o+2
if(!(r<s))return A.a(p,r)
p[r]=c
if(q>3){q=o+3
if(!(q<s))return A.a(p,q)
p[q]=d}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cG){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cH.prototype={
X(){var s=this
return new A.cH(s.a,s.b,s.c,s.d)},
gu(a){return this.d.c},
gR(){return null},
gG(){return 1},
gL(){return B.Q},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
i(a,b,c){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=c}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.b(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}else if(r>1){s=s.d
r=this.c+1
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}else if(r>2){s=s.d
r=this.c+2
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=1
return s},
sv(a){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}else if(r>3){s=s.d
r=this.c+3
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a}},
gal(){return this.gt()/1},
sal(a){this.st(a)},
gai(){return this.gA()/1},
sai(a){this.sA(a)},
gak(){return this.gB()/1},
sak(a){this.sB(a)},
ga1(){return this.gv()/1},
sa1(a){this.sv(a)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r=this.d,q=r.d,p=this.c
q.$flags&2&&A.b(q)
s=q.length
if(!(p>=0&&p<s))return A.a(q,p)
q[p]=a
if(r.c>2){r=p+1
if(!(r<s))return A.a(q,r)
q[r]=b
p+=2
if(!(p<s))return A.a(q,p)
q[p]=c}},
ap(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.b(p)
s=p.length
if(!(o>=0&&o<s))return A.a(p,o)
p[o]=a
q=q.c
if(q===2){q=o+1
if(!(q<s))return A.a(p,q)
p[q]=d}else if(q>2){r=o+1
if(!(r<s))return A.a(p,r)
p[r]=b
r=o+2
if(!(r<s))return A.a(p,r)
p[r]=c
if(q>3){q=o+3
if(!(q<s))return A.a(p,q)
p[q]=d}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cH){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cI.prototype={
X(){var s=this
return new A.cI(s.a,s.b,s.c,s.d)},
gu(a){return this.d.c},
gR(){return null},
gG(){return 32767},
gL(){return B.V},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.h(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=32767
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/32767},
sal(a){this.st(a*32767)},
gai(){return this.gA()/32767},
sai(a){this.sA(a*32767)},
gak(){return this.gB()/32767},
sak(a){this.sB(a*32767)},
ga1(){return this.gv()/32767},
sa1(a){this.sv(a*32767)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r,q,p=this.d,o=p.c
if(o>0){p=p.d
s=this.c
r=B.a.h(a)
p.$flags&2&&A.b(p)
q=p.length
if(!(s>=0&&s<q))return A.a(p,s)
p[s]=r
if(o>2){o=s+1
r=B.a.h(b)
if(!(o<q))return A.a(p,o)
p[o]=r
s+=2
r=B.a.h(c)
if(!(s<q))return A.a(p,s)
p[s]=r}}},
ap(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.h(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=s+1
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}else if(n>2){r=s+1
p=B.a.h(b)
if(!(r<q))return A.a(o,r)
o[r]=p
p=s+2
r=B.a.h(c)
if(!(p<q))return A.a(o,p)
o[p]=r
if(n>3){n=s+3
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cI){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cJ.prototype={
X(){var s=this
return new A.cJ(s.a,s.b,s.c,s.d)},
gu(a){return this.d.c},
gR(){return null},
gG(){return 2147483647},
gL(){return B.W},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.h(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=2147483647
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/2147483647},
sal(a){this.st(a*2147483647)},
gai(){return this.gA()/2147483647},
sai(a){this.sA(a*2147483647)},
gak(){return this.gB()/2147483647},
sak(a){this.sB(a*2147483647)},
ga1(){return this.gv()/2147483647},
sa1(a){this.sv(a*2147483647)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r,q,p=this.d,o=p.c
if(o>0){p=p.d
s=this.c
r=B.a.h(a)
p.$flags&2&&A.b(p)
q=p.length
if(!(s>=0&&s<q))return A.a(p,s)
p[s]=r
if(o>2){o=s+1
r=B.a.h(b)
if(!(o<q))return A.a(p,o)
p[o]=r
s+=2
r=B.a.h(c)
if(!(s<q))return A.a(p,s)
p[s]=r}}},
ap(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.h(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=s+1
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}else if(n>2){r=s+1
p=B.a.h(b)
if(!(r<q))return A.a(o,r)
o[r]=p
p=s+2
r=B.a.h(c)
if(!(p<q))return A.a(o,p)
o[p]=r
if(n>3){n=s+3
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cJ){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cK.prototype={
X(){var s=this
return new A.cK(s.a,s.b,s.c,s.d)},
gu(a){return this.d.c},
gR(){return null},
gG(){return 127},
gL(){return B.U},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.h(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=127
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/127},
sal(a){this.st(a*127)},
gai(){return this.gA()/127},
sai(a){this.sA(a*127)},
gak(){return this.gB()/127},
sak(a){this.sB(a*127)},
ga1(){return this.gv()/127},
sa1(a){this.sv(a*127)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r,q,p=this.d,o=p.c
if(o>0){p=p.d
s=this.c
r=B.a.h(a)
p.$flags&2&&A.b(p)
q=p.length
if(!(s>=0&&s<q))return A.a(p,s)
p[s]=r
if(o>2){o=s+1
r=B.a.h(b)
if(!(o<q))return A.a(p,o)
p[o]=r
s+=2
r=B.a.h(c)
if(!(s<q))return A.a(p,s)
p[s]=r}}},
ap(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.h(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=s+1
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}else if(n>2){r=s+1
p=B.a.h(b)
if(!(r<q))return A.a(o,r)
o[r]=p
p=s+2
r=B.a.h(c)
if(!(p<q))return A.a(o,p)
o[p]=r
if(n>3){n=s+3
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cK){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.hX.prototype={
E(){var s=this,r=s.a
if(r.gb6()+1>s.d){r.a9(s.b,r.gb_()+1)
return r.gb_()<=s.e}return r.E()},
gO(){return this.a},
$iz:1}
A.cL.prototype={
X(){var s=this
return new A.cL(s.a,s.b,s.c,s.d,s.e,s.f)},
gu(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.f.f},
gG(){return this.f.gG()},
gL(){return B.A},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.f
r=b*s.e
q.e=r
s=a*s.c
q.c=r+B.a.j(s,3)
q.d=s&7},
gO(){return this},
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
e6(a){var s,r,q=this.c,p=7-(this.d+a)
if(p<0){p+=8;++q}s=this.f.d
s===$&&A.c("data")
r=s.length
if(q>=r)return 0
if(!(q>=0))return A.a(s,q)
return B.a.a0(s[q],p)&1},
bd(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.e6(a):0
else s=r.aY(this.e6(0),a)
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
o=B.a.F(B.b.h(b),0,1)
if(!(r>=0&&r<8))return A.a(B.bN,r)
n=B.bN[r]
q=B.a.U(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bd(b)},
i(a,b,c){return this.aC(b,c)},
gW(){return this.e6(0)},
sW(a){this.aC(0,a)},
gt(){return this.bd(0)},
st(a){this.aC(0,a)},
gA(){return this.f.c===2?this.bd(0):this.bd(1)},
sA(a){this.aC(this.f.c===2?0:1,a)},
gB(){return this.f.c===2?this.bd(0):this.bd(2)},
sB(a){this.aC(this.f.c===2?0:2,a)},
gv(){var s=this.f,r=s.f==null
if(r&&s.c===2)s=this.bd(1)
else s=r&&s.c<4?s.gG():this.bd(3)
return s},
sv(a){this.aC(this.f.c===2?1:3,a)},
gal(){return this.bd(0)/this.f.gG()},
sal(a){this.aC(0,a*this.f.gG())},
gai(){return this.gA()/this.f.gG()},
sai(a){var s=this.f,r=s.gG()
s=s.c===2?0:1
this.aC(s,a*r)},
gak(){return this.gB()/this.f.gG()},
sak(a){var s=this.f,r=s.gG()
s=s.c===2?0:2
this.aC(s,a*r)},
ga1(){return this.gv()/this.f.gG()},
sa1(a){var s=this.f,r=s.gG()
s=s.c===2?1:3
this.aC(s,a*r)},
gaq(){return this.f.c===2?this.bd(0):A.a2(this)},
b9(a){var s,r,q=this
q.aC(0,a.gt())
s=a.gA()
r=q.f.c===2
q.aC(r?0:1,s)
s=a.gB()
q.aC(r?0:2,s)
s=a.gv()
q.aC(r?1:3,s)},
aG(a,b,c){var s=this,r=s.f.c
if(r>0){s.aC(0,a)
if(r>2){s.aC(1,b)
s.aC(2,c)}}},
ap(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aC(0,a)
if(r===2)s.aC(1,d)
else if(r>2){s.aC(1,b)
s.aC(2,c)
if(r>3)s.aC(3,d)}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cL){s=A.t(p,A.m(p).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.ae(b)
if(s.gu(b)!==q)return!1
if(p.bd(0)!==s.l(b,0))return!1
if(q>1){if(p.bd(1)!==s.l(b,1))return!1
if(q>2){if(p.bd(2)!==s.l(b,2))return!1
if(q>3)if(p.bd(3)!==s.l(b,3))return!1}}return!0}return!1},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.f}}
A.cM.prototype={
X(){var s=this
return new A.cM(s.a,s.b,s.c,s.d)},
gu(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.d.e},
gG(){return this.d.gG()},
gL(){return B.n},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bw(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aY(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bw(b)},
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.h(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d,q=r.e
if(q==null)if(r.c>0){r=r.d
q=this.c
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b2(r[s])
r=s}return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s,r=this,q=r.d,p=q.e
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
s=p.b1(q[s])
q=s}return q},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s,r=this,q=r.d,p=q.e
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
s=p.b0(q[s])
q=s}return q},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.h(a)
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
q=p}else q=q.gG()}else{q=q.d
s=r.c
if(!(s>=0&&s<q.length))return A.a(q,s)
s=p.b7(q[s])
q=s}return q},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/this.d.gG()},
sal(a){this.st(a*this.d.gG())},
gai(){return this.gA()/this.d.gG()},
sai(a){this.sA(a*this.d.gG())},
gak(){return this.gB()/this.d.gG()},
sak(a){this.sB(a*this.d.gG())},
ga1(){return this.gv()/this.d.gG()},
sa1(a){this.sv(a*this.d.gG())},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r,q,p=this.d,o=p.c
if(o>0){p=p.d
s=this.c
r=B.a.h(a)
p.$flags&2&&A.b(p)
q=p.length
if(!(s>=0&&s<q))return A.a(p,s)
p[s]=r
if(o>2){o=s+1
r=B.a.h(b)
if(!(o<q))return A.a(p,o)
p[o]=r
s+=2
r=B.a.h(c)
if(!(s<q))return A.a(p,s)
p[s]=r}}},
ap(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.h(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=s+1
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}else if(n>2){r=s+1
p=B.a.h(b)
if(!(r<q))return A.a(o,r)
o[r]=p
p=s+2
r=B.a.h(c)
if(!(p<q))return A.a(o,p)
o[p]=r
if(n>3){n=s+3
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cM){s=A.t(p,A.m(p).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.ae(b)
if(s.gu(b)!==q)return!1
if(p.bw(0)!==s.l(b,0))return!1
if(q>1){if(p.bw(1)!==s.l(b,1))return!1
if(q>2){if(p.bw(2)!==s.l(b,2))return!1
if(q>3)if(p.bw(3)!==s.l(b,3))return!1}}return!0}return!1},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cN.prototype={
X(){var s=this
return new A.cN(s.a,s.b,s.c,s.d,s.e,s.f)},
gu(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.f.f},
gG(){return this.f.gG()},
gL(){return B.w},
ghp(){var s=this.f
return s.f!=null?2:s.c<<1>>>0},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.ghp()
r=b*p.f.e
p.e=r
q=a*s
p.c=r+B.a.j(q,3)
p.d=q&7},
gO(){return this},
E(){var s=this,r=++s.a,q=s.f
if(r===q.a){s.a=0
r=++s.b
s.d=0;++s.c
s.e=s.e+q.e
return r<q.b}if(q.f!=null||q.c===1){if((s.d+=2)>7){s.d=0;++s.c}}else{r*=s.ghp()
s.d=r&7
s.c=s.e+B.a.j(r,3)}r=s.c
q=q.d
q===$&&A.c("data")
return r<q.length},
e7(a){var s,r=this.c,q=6-(this.d+(a<<1>>>0))
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.c("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a0(s[r],q)&3},
be(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.e7(a):0
else s=r.aY(this.e7(0),a)
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
o=B.a.F(B.b.h(b),0,3)
q=B.a.j(r,1)
if(!(q<4))return A.a(B.bs,q)
n=B.bs[q]
q=B.a.U(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.be(b)},
i(a,b,c){return this.aD(b,c)},
gW(){return this.e7(0)},
sW(a){this.aD(0,a)},
gt(){return this.be(0)},
st(a){this.aD(0,a)},
gA(){return this.f.c===2?this.be(0):this.be(1)},
sA(a){this.aD(this.f.c===2?0:1,a)},
gB(){return this.f.c===2?this.be(0):this.be(2)},
sB(a){this.aD(this.f.c===2?0:2,a)},
gv(){var s=this.f,r=s.f==null
if(r&&s.c===2)s=this.be(1)
else s=r&&s.c<4?s.gG():this.be(3)
return s},
sv(a){this.aD(this.f.c===2?1:3,a)},
gal(){return this.be(0)/this.f.gG()},
sal(a){this.aD(0,a*this.f.gG())},
gai(){return this.gA()/this.f.gG()},
sai(a){var s=this.f,r=s.gG()
s=s.c===2?0:1
this.aD(s,a*r)},
gak(){return this.gB()/this.f.gG()},
sak(a){var s=this.f,r=s.gG()
s=s.c===2?0:2
this.aD(s,a*r)},
ga1(){return this.gv()/this.f.gG()},
sa1(a){var s=this.f,r=s.gG()
s=s.c===2?1:3
this.aD(s,a*r)},
gaq(){return this.f.c===2?this.be(0):A.a2(this)},
b9(a){var s,r,q=this
q.aD(0,a.gt())
s=a.gA()
r=q.f.c===2
q.aD(r?0:1,s)
s=a.gB()
q.aD(r?0:2,s)
s=a.gv()
q.aD(r?1:3,s)},
aG(a,b,c){var s=this,r=s.f.c
if(r>0){s.aD(0,a)
if(r>2){s.aD(1,b)
s.aD(2,c)}}},
ap(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aD(0,a)
if(r===2)s.aD(1,d)
else if(r>2){s.aD(1,b)
s.aD(2,c)
if(r>3)s.aD(3,d)}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cN){s=A.t(p,A.m(p).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.ae(b)
if(s.gu(b)!==q)return!1
if(p.be(0)!==s.l(b,0))return!1
if(q>1){if(p.be(1)!==s.l(b,1))return!1
if(q>2){if(p.be(2)!==s.l(b,2))return!1
if(q>3)if(p.be(3)!==s.l(b,3))return!1}}return!0}return!1},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.f}}
A.cO.prototype={
X(){var s=this
return new A.cO(s.a,s.b,s.c,s.d)},
gu(a){return this.d.c},
gR(){return null},
gG(){return 4294967295},
gL(){return B.R},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
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
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.h(c)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){return this.gt()},
sW(a){this.st(a)},
gt(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(a)
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>1){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>2){s=s.d
r=this.c+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=0
return s},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gv(){var s=this.d,r=s.c
if(r===2){s=s.d
r=this.c+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else if(r>3){s=s.d
r=this.c+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=r}else s=4294967295
return s},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.h(a)
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/4294967295},
sal(a){this.st(a*4294967295)},
gai(){return this.gA()/4294967295},
sai(a){this.sA(a*4294967295)},
gak(){return this.gB()/4294967295},
sak(a){this.sB(a*4294967295)},
ga1(){return this.gv()/4294967295},
sa1(a){this.sv(a*4294967295)},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())},
aG(a,b,c){var s,r,q,p=this.d,o=p.c
if(o>0){p=p.d
s=this.c
r=B.a.h(a)
p.$flags&2&&A.b(p)
q=p.length
if(!(s>=0&&s<q))return A.a(p,s)
p[s]=r
if(o>2){o=s+1
r=B.a.h(b)
if(!(o<q))return A.a(p,o)
p[o]=r
s+=2
r=B.a.h(c)
if(!(s<q))return A.a(p,s)
p[s]=r}}},
ap(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.h(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=s+1
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}else if(n>2){r=s+1
p=B.a.h(b)
if(!(r<q))return A.a(o,r)
o[r]=p
p=s+2
r=B.a.h(c)
if(!(p<q))return A.a(o,p)
o[p]=r
if(n>3){n=s+3
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cO){s=A.t(n,A.m(n).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=J.ae(b)
r=n.d
q=r.c
if(s.gu(b)!==q)return!1
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
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.cP.prototype={
X(){var s=this
return new A.cP(s.a,s.b,s.c,s.d,s.e)},
gu(a){var s=this.e,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.e.f},
gG(){return this.e.gG()},
gL(){return B.B},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q,p=this
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
gO(){return this},
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
e8(a){var s,r=this.c,q=4-(this.d+(a<<2>>>0))
if(q<0){q+=8;++r}s=this.e.d
s===$&&A.c("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a0(s[r],q)&15},
bf(a){var s=this.e,r=s.f
if(r==null)s=s.c>a?this.e8(a):0
else s=r.aY(this.e8(0),a)
return s},
aE(a,b){var s,r,q,p,o,n,m=this.e
if(a>=m.c)return
s=this.c
r=4-(this.d+(a<<2>>>0))
if(r<0){r+=8;++s}q=m.d
q===$&&A.c("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.F(B.b.h(b),0,15)
n=r===4?15:240
q=B.a.U(o,r)
m=m.d
m.$flags&2&&A.b(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.bf(b)},
i(a,b,c){return this.aE(b,c)},
gW(){return this.e8(0)},
sW(a){this.aE(0,a)},
gt(){return this.bf(0)},
st(a){this.aE(0,a)},
gA(){return this.e.c===2?this.bf(0):this.bf(1)},
sA(a){this.aE(this.e.c===2?0:1,a)},
gB(){return this.e.c===2?this.bf(0):this.bf(2)},
sB(a){this.aE(this.e.c===2?0:2,a)},
gv(){var s=this.e,r=s.f==null
if(r&&s.c===2)s=this.bf(1)
else s=r&&s.c<4?s.gG():this.bf(3)
return s},
sv(a){this.aE(this.e.c===2?1:3,a)},
gal(){return this.bf(0)/this.e.gG()},
sal(a){this.aE(0,a*this.e.gG())},
gai(){return this.gA()/this.e.gG()},
sai(a){var s=this.e,r=s.gG()
s=s.c===2?0:1
this.aE(s,a*r)},
gak(){return this.gB()/this.e.gG()},
sak(a){var s=this.e,r=s.gG()
s=s.c===2?0:2
this.aE(s,a*r)},
ga1(){return this.gv()/this.e.gG()},
sa1(a){var s=this.e,r=s.gG()
s=s.c===2?1:3
this.aE(s,a*r)},
gaq(){return this.e.c===2?this.bf(0):A.a2(this)},
b9(a){var s,r,q=this
q.aE(0,a.gt())
s=a.gA()
r=q.e.c===2
q.aE(r?0:1,s)
s=a.gB()
q.aE(r?0:2,s)
s=a.gv()
q.aE(r?1:3,s)},
aG(a,b,c){var s=this,r=s.e.c
if(r>0){s.aE(0,a)
if(r>2){s.aE(1,b)
s.aE(2,c)}}},
ap(a,b,c,d){var s=this,r=s.e.c
if(r>0){s.aE(0,a)
if(r===2)s.aE(1,d)
else if(r>2){s.aE(1,b)
s.aE(2,c)
if(r>3)s.aE(3,d)}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cP){s=A.t(p,A.m(p).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){q=p.e.c
s=J.ae(b)
if(s.gu(b)!==q)return!1
if(p.bf(0)!==s.l(b,0))return!1
if(q>1){if(p.bf(1)!==s.l(b,1))return!1
if(q>2){if(p.bf(2)!==s.l(b,2))return!1
if(q>3)if(p.bf(3)!==s.l(b,3))return!1}}return!0}return!1},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.e}}
A.cQ.prototype={
X(){var s=this
return new A.cQ(s.a,s.b,s.c,s.d)},
gu(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gR(){return this.d.e},
gG(){return this.d.gG()},
gL(){return B.e},
gb6(){return this.a},
gb_(){return this.b},
a9(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
E(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bw(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aY(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bw(b)},
i(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.h(B.b.F(c,0,255))
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gW(){var s=this.d.d,r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
sW(a){var s=this.d.d,r=this.c,q=B.b.h(B.b.F(a,0,255))
s.$flags&2&&A.b(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=q},
gt(){var s,r=this.d,q=r.e
if(q==null)if(r.c>0){r=r.d
q=this.c
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b2(r[s])
r=s}return r},
st(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.h(B.b.F(a,0,255))
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s,r=this,q=r.d,p=q.e
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
s=p.b1(q[s])
q=s}return q},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.F(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.h(B.b.F(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gB(){var s,r=this,q=r.d,p=q.e
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
s=p.b0(q[s])
q=s}return q},
sB(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.h(B.b.F(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.h(B.b.F(a,0,255))
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
s=p.b7(q[s])
q=s}return q},
sv(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.h(B.b.F(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.h(B.b.F(a,0,255))
r.$flags&2&&A.b(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gal(){return this.gt()/this.d.gG()},
sal(a){this.st(a*this.d.gG())},
gai(){return this.gA()/this.d.gG()},
sai(a){this.sA(a*this.d.gG())},
gak(){return this.gB()/this.d.gG()},
sak(a){this.sB(a*this.d.gG())},
ga1(){return this.gv()/this.d.gG()},
sa1(a){this.sv(a*this.d.gG())},
gaq(){return this.d.c===2?this.gt():A.a2(this)},
b9(a){var s=this
if(s.d.e!=null)s.sW(a.gW())
else{s.st(a.gt())
s.sA(a.gA())
s.sB(a.gB())
s.sv(a.gv())}},
aG(a,b,c){var s,r,q,p=this.d,o=p.c
if(o>0){p=p.d
s=this.c
r=B.a.h(a)
p.$flags&2&&A.b(p)
q=p.length
if(!(s>=0&&s<q))return A.a(p,s)
p[s]=r
if(o>2){o=s+1
r=B.a.h(b)
if(!(o<q))return A.a(p,o)
p[o]=r
s+=2
r=B.a.h(c)
if(!(s<q))return A.a(p,s)
p[s]=r}}},
ap(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.h(a)
o.$flags&2&&A.b(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n===2){n=s+1
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}else if(n>2){r=s+1
p=B.a.h(b)
if(!(r<q))return A.a(o,r)
o[r]=p
p=s+2
r=B.a.h(c)
if(!(p<q))return A.a(o,p)
o[p]=r
if(n>3){n=s+3
s=B.a.h(d)
if(!(n<q))return A.a(o,n)
o[n]=s}}}},
gI(a){return new A.W(this)},
Z(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cQ){s=A.t(p,A.m(p).m("e.E"))
s=A.o(s)
r=A.t(b,A.m(b).m("e.E"))
return s===A.o(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.ae(b)
if(s.gu(b)!==q)return!1
if(p.bw(0)!==s.l(b,0))return!1
if(q>1){if(p.bw(1)!==s.l(b,1))return!1
if(q>2){if(p.bw(2)!==s.l(b,2))return!1
if(q>3)if(p.bw(3)!==s.l(b,3))return!1}}return!0}return!1},
gM(a){var s=A.t(this,A.m(this).m("e.E"))
return A.o(s)},
aS(a){return A.aM(this,null,a,null,null)},
$iz:1,
$ix:1,
$iu:1,
gbl(){return this.d}}
A.E.prototype={
X(){return new A.E()},
gbl(){return $.pR()},
gb6(){return 0},
gb_(){return 0},
gu(a){return 0},
gG(){return 0},
gL(){return B.e},
gR(){return null},
l(a,b){return 0},
i(a,b,c){},
gW(){return 0},
sW(a){},
gt(){return 0},
st(a){},
gA(){return 0},
sA(a){},
gB(){return 0},
sB(a){},
gv(){return 0},
sv(a){},
gal(){return 0},
sal(a){},
gai(){return 0},
sai(a){},
gak(){return 0},
sak(a){},
ga1(){return 0},
sa1(a){},
gaq(){return 0},
b9(a){},
aG(a,b,c){},
ap(a,b,c,d){},
a9(a,b){},
gO(){return this},
E(){return!1},
Z(a,b){if(b==null)return!1
return b instanceof A.E},
gM(a){return 0},
gI(a){return new A.W(this)},
aS(a){return this},
$iz:1,
$ix:1,
$iu:1}
A.lL.prototype={
iI(a,b){var s=this,r="base",q="colStep",p="rowStep",o=a.a.gaz(),n=s.b,m=(a.gN()-1)*n,l=(a.gJ()-1)*o,k=s.e
switch(b){case 2:k!==$&&A.A(r)
s.e=m
s.f!==$&&A.A(q)
s.f=-n
s.r!==$&&A.A(p)
s.r=o
break
case 3:k!==$&&A.A(r)
s.e=l+m
s.f!==$&&A.A(q)
s.f=-n
s.r!==$&&A.A(p)
s.r=-o
break
case 4:k!==$&&A.A(r)
s.e=l
s.f!==$&&A.A(q)
s.f=n
s.r!==$&&A.A(p)
s.r=-o
break
case 5:k!==$&&A.A(r)
s.e=0
s.f!==$&&A.A(q)
s.f=o
s.r!==$&&A.A(p)
s.r=n
break
case 6:k!==$&&A.A(r)
s.e=l
s.f!==$&&A.A(q)
s.f=-o
s.r!==$&&A.A(p)
s.r=n
break
case 7:k!==$&&A.A(r)
s.e=l+m
s.f!==$&&A.A(q)
s.f=-o
s.r!==$&&A.A(p)
s.r=-n
break
case 8:k!==$&&A.A(r)
s.e=m
s.f!==$&&A.A(q)
s.f=o
s.r!==$&&A.A(p)
s.r=-n
break
default:k!==$&&A.A(r)
s.e=0
s.f!==$&&A.A(q)
s.f=n
s.r!==$&&A.A(p)
s.r=o
break}}}
A.mb.prototype={
$1(a){return A.pr(t.mo.a(a),this.a.a)},
$S:42}
A.jl.prototype={
a7(){return"FlipDirection."+this.b}}
A.ht.prototype={
D(a){return"ImageException: "+this.a}}
A.ai.prototype={
gu(a){return this.c-this.d},
i(a,b,c){J.a_(this.a,this.d+b,c)
return c},
cB(a,b,c,d){var s=this.a,r=J.aV(s),q=this.d+a
if(c instanceof A.ai)r.ab(s,q,q+b,c.a,c.d+d)
else r.ab(s,q,q+b,t.L.a(c),d)},
dC(a,b,c){return this.cB(a,b,c,0)},
mr(a,b,c){var s=this.a,r=this.d+a
J.e6(s,r,r+b,c)},
dK(a,b,c){var s=this,r=c!=null?s.b+c:s.d
return A.v(s.a,s.e,a,r+b)},
aH(a){return this.dK(a,0,null)},
c9(a,b){return this.dK(a,0,b)},
d7(a,b){return this.dK(a,b,null)},
H(){return J.d(this.a,this.d++)},
af(a){var s=this.aH(a)
this.d=this.d+(s.c-s.d)
return s},
au(a){var s,r,q,p,o,n=this
if(a==null){s=A.j([],t.t)
for(r=n.c;q=n.d,q<r;){p=n.a
n.d=q+1
o=J.d(p,q)
if(o===0)return A.fh(s,0,null)
B.c.C(s,o)}throw A.f(A.l("EOF reached without finding string terminator (length: "+A.y(a)+")"))}return A.fh(n.af(a).Y(),0,null)},
d3(){return this.au(null)},
hN(a){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
B.c.C(n,p)
if(p===10||n.length>=a)return A.fh(n,0,null)}return A.fh(n,0,null)},
mA(){return this.hN(256)},
mB(){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
if(p===0){t.L.a(n)
return new A.iM(!0).f7(n,0,null,!0)}B.c.C(n,p)}return B.d3.lV(n,!0)},
n(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255
if(s.e)return r<<8|q
return q<<8|r},
bt(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255
if(s.e)return p|q<<8|r<<16
return r|q<<8|p<<16},
k(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255
if(s.e)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
dD(){return A.wd(this.eo())},
eo(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255,n=J.d(s.a,s.d++)&255,m=J.d(s.a,s.d++)&255,l=J.d(s.a,s.d++)&255,k=J.d(s.a,s.d++)&255
if(s.e)return(B.a.S(r,56)|B.a.S(q,48)|B.a.S(p,40)|B.a.S(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.S(k,56)|B.a.S(l,48)|B.a.S(m,40)|B.a.S(n,32)|o<<24|p<<16|q<<8|r)>>>0},
eq(a,b,c){var s,r=this,q=r.a
if(t.D.b(q))return r.hV(b,c)
s=r.b+r.d+b
return J.mC(q,s,c<=0?r.c:s+c)},
hV(a,b){var s,r=this,q=b==null?r.c-r.d-a:b,p=r.a
if(t.D.b(p))return J.C(B.d.gq(p),p.byteOffset+r.d+a,q)
s=r.d+a
s=new Uint8Array(A.p(J.mC(p,s,s+q)))
return s},
Y(){return this.hV(0,null)},
dF(){var s=this.a
if(t.D.b(s))return J.a1(B.d.gq(s),s.byteOffset+this.d,null)
return J.a1(B.d.gq(this.Y()),0,null)},
sq(a,b){this.a=t.L.a(b)}}
A.hT.prototype={
gR(){var s=this.a
s===$&&A.c("palette")
return s},
hd(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.kt(a)
i.k_()
i.kp()
i.ja()
B.u.a8(i.ax,0,65536,0)
s=i.c
r=s*4
q=i.at=new Int32Array(r)
for(p=i.Q,o=0;o<s;++o)for(n=o*4,m=0;m<4;++m){l=n+m
p===$&&A.c("_palette")
k=p.b
if(m<k){j=p.c
k=o*k+m
if(!(k>=0&&k<j.length))return A.a(j,k)
k=j[k]}else k=0
k=B.a.h(k)
if(!(l<r))return A.a(q,l)
q[l]=k}},
i3(a){var s=B.b.h(a.gt()),r=B.b.h(a.gA())
return this.fz(B.b.h(a.gB()),r,s)},
dG(a,b,c){var s,r=this,q=(a<<16|b<<8|c)>>>0,p=(q^q>>>11)&65535,o=r.ax,n=q+1
if(o[p]===n)return r.ay[p]
s=r.fz(c,b,a)
o.$flags&2&&A.b(o)
o[p]=n
o=r.ay
o.$flags&2&&A.b(o)
o[p]=s
return s},
kn(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.c=Math.max(a,4)
g.f=f-g.d
g.r=f-1
s=B.b.V(f,8)
g.w=s
g.x=s*256
g.Q=new A.dC(new Uint32Array(1024),256,4)
g.a=new A.aT(new Uint8Array(768),256,3)
g.d=3
g.e=2
s=B.b.j(f,3)
g.y=new Int32Array(s)
s=g.z=new Float64Array(f*3)
r=g.ch=new Float64Array(f)
q=g.CW=new Float64Array(f)
p=s.length
if(0>=p)return A.a(s,0)
s[0]=0
if(1>=p)return A.a(s,1)
s[1]=0
if(2>=p)return A.a(s,2)
s[2]=0
if(3>=p)return A.a(s,3)
s[3]=255
if(4>=p)return A.a(s,4)
s[4]=255
if(5>=p)return A.a(s,5)
s[5]=255
o=1/f
for(n=q.length,m=r.length,l=0;l<3;++l){if(!(l<n))return A.a(q,l)
q[l]=o
if(!(l<m))return A.a(r,l)
r[l]=0}for(k=3*3,j=g.f,l=3;l<f;++l,k=i){i=k+1
h=255*(l-3)/j
if(!(k<p))return A.a(s,k)
s[k]=h
k=i+1
if(!(i<p))return A.a(s,i)
s[i]=h
i=k+1
if(!(k<p))return A.a(s,k)
s[k]=h
if(!(l<n))return A.a(q,l)
q[l]=o
if(!(l<m))return A.a(r,l)
r[l]=0}},
ja(){var s,r,q,p,o,n,m
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
r.ba(s,Math.abs(o),Math.abs(n),Math.abs(q))}},
fz(a,b,c){var s,r,q,p,o,n,m,l,k,j=this.at,i=this.as
if(!(b>=0&&b<256))return A.a(i,b)
s=i[b]
r=s-1
q=this.c
i=j.length
p=1000
o=-1
for(;;){n=s<q
if(!(n||r>=0))break
if(n){n=s*4
m=n+1
if(!(m>=0&&m<i))return A.a(j,m)
l=j[m]-b
if(l>=p)s=q
else{if(l<0)l=-l
if(!(n>=0&&n<i))return A.a(j,n)
k=j[n]-a
l+=k<0?-k:k
if(l<p){n+=2
if(!(n<i))return A.a(j,n)
k=j[n]-c
l+=k<0?-k:k
if(l<p){o=s
p=l}}++s}}if(r>=0){n=r*4
m=n+1
if(!(m>=0&&m<i))return A.a(j,m)
l=b-j[m]
if(l>=p)r=-1
else{if(l<0)l=-l
if(!(n>=0&&n<i))return A.a(j,n)
k=j[n]-a
l+=k<0?-k:k
if(l<p){n+=2
if(!(n<i))return A.a(j,n)
k=j[n]-c
l+=k<0?-k:k
if(l<p){o=r
p=l}}--r}}}return o},
k_(){var s,r,q,p,o,n,m,l=this,k="_palette"
for(s=0,r=0;s<l.c;++s){for(q=0;q<3;++q,++r){p=l.z
p===$&&A.c("_network")
if(!(r>=0&&r<p.length))return A.a(p,r)
o=B.a.F(B.b.h(0.5+p[r]),0,255)
p=l.Q
p===$&&A.c(k)
n=p.b
if(q<n){p=p.c
n=s*n+q
m=B.a.h(o)
p.$flags&2&&A.b(p)
if(!(n>=0&&n<p.length))return A.a(p,n)
p[n]=m}}p=l.Q
p===$&&A.c(k)
n=p.b
if(3<n){p=p.c
n=s*n+3
m=B.a.h(s)
p.$flags&2&&A.b(p)
if(!(n>=0&&n<p.length))return A.a(p,n)
p[n]=m}}},
kp(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
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
i=B.a.h(i)
d.$flags&2&&A.b(d)
if(!(c>=0&&c<d.length))return A.a(d,c)
d[c]=i}if(j){c=m*l
j=r.c
i=B.a.h(f)
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
j=B.a.h(j)
i.$flags&2&&A.b(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
j=m*l+1
i=B.a.h(f)
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
j=B.a.h(j)
i.$flags&2&&A.b(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
j=m*l+2
i=B.a.h(f)
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
j=B.a.h(j)
i.$flags&2&&A.b(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
l=m*l+3
j=B.a.h(f)
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
h_(a,b){var s,r,q,p
for(s=this.y,r=a*a,q=0;q<a;++q){s===$&&A.c("_radiusPower")
p=B.b.h(b*((r-q*q)*256/r))
s.$flags&2&&A.b(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
kt(a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="_network",a7=a5.x
a7===$&&A.c("initBiasRadius")
s=a5.b
r=30+B.a.V(s-1,3)
q=a8.gN()*a8.gJ()
p=B.a.aa(q,s)
o=Math.max(B.a.V(p,100),1)
if(o===0)o=1
n=B.a.j(a7,8)
if(n<=1)n=0
a5.h_(n,1024)
if(q<1509)m=a5.b=1
else if(B.a.a5(q,499)!==0)m=499
else if(B.a.a5(q,491)!==0)m=491
else m=B.a.a5(q,487)!==0?487:503
l=a8.gN()
k=a8.gJ()
for(j=a7,i=1024,h=0,g=0,f=0,e=0,d=null;e<p;){a7=a8.a
d=a7==null?null:a7.P(g,f,d)
if(d==null)d=new A.E()
c=d.gt()
b=d.gA()
a=d.gB()
if(e===0){a7=a5.z
a7===$&&A.c(a6)
s=a5.e
s===$&&A.c("bgColor")
s*=3
a7.$flags&2&&A.b(a7)
a0=a7.length
if(!(s>=0&&s<a0))return A.a(a7,s)
a7[s]=a
a1=s+1
if(!(a1<a0))return A.a(a7,a1)
a7[a1]=b
s+=2
if(!(s<a0))return A.a(a7,s)
a7[s]=c}a2=a5.lr(a,b,c)
if(a2<0)a2=a5.j8(a,b,c)
if(a2>=a5.d){a3=i/1024
a4=a2*3
a7=a5.z
a7===$&&A.c(a6)
s=a7.length
if(!(a4>=0&&a4<s))return A.a(a7,a4)
a0=a7[a4]
a7.$flags&2&&A.b(a7)
a7[a4]=a0-a3*(a0-a)
a0=a4+1
if(!(a0<s))return A.a(a7,a0)
a1=a7[a0]
a7[a0]=a1-a3*(a1-b)
a1=a4+2
if(!(a1<s))return A.a(a7,a1)
s=a7[a1]
a7[a1]=s-a3*(s-c)
if(n>0)a5.iM(a3,n,a2,a,b,c)}h+=m
g+=m
while(g>l){g-=l;++f}while(h>=q){h-=q
f-=k}++e
if(B.a.a5(e,o)===0){i-=B.a.aa(i,r)
j-=B.a.V(j,30)
n=B.a.j(j,8)
if(n<=1)n=0
a5.h_(n,i)}}},
iM(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_network",d=a0-b,c=f.d-1
if(d<c)d=c
s=a0+b
r=f.c
if(s>r)s=r
q=a0+1
p=a0-1
o=f.y
n=f.z
m=1
for(;;){l=q<s
if(!(l||p>d))break
o===$&&A.c("_radiusPower")
k=m+1
if(!(m<o.length))return A.a(o,m)
j=o[m]
if(l){i=q*3
n===$&&A.c(e)
l=n.length
if(!(i>=0&&i<l))return A.a(n,i)
h=n[i]
n.$flags&2&&A.b(n)
n[i]=h-j*(h-a1)/262144
h=i+1
if(!(h<l))return A.a(n,h)
g=n[h]
n[h]=g-j*(g-a2)/262144
g=i+2
if(!(g<l))return A.a(n,g)
l=n[g]
n[g]=l-j*(l-a3)/262144;++q}if(p>d){i=p*3
n===$&&A.c(e)
l=n.length
if(!(i>=0&&i<l))return A.a(n,i)
h=n[i]
n.$flags&2&&A.b(n)
n[i]=h-j*(h-a1)/262144
h=i+1
if(!(h<l))return A.a(n,h)
g=n[h]
n[h]=g-j*(g-a2)/262144
g=i+2
if(!(g<l))return A.a(n,g)
l=n[g]
n[g]=l-j*(l-a3)/262144;--p}m=k}},
j8(a0,a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=1e30
for(s=b.d,r=s*3,q=b.c,p=b.CW,o=b.ch,n=b.z,m=a,l=m,k=-1,j=-1;s<q;++s,r=i){n===$&&A.c("_network")
i=r+1
h=n.length
if(!(r<h))return A.a(n,r)
g=n[r]-a0
if(g<0)g=-g
r=i+1
if(!(i<h))return A.a(n,i)
f=n[i]-a1
if(f<0)f=-f
i=r+1
if(!(r<h))return A.a(n,r)
e=n[r]-a2
if(e<0)e=-e
g=g+f+e
if(g<l){k=s
l=g}o===$&&A.c("_bias")
if(!(s<o.length))return A.a(o,s)
d=g-o[s]
if(d<m){j=s
m=d}p===$&&A.c("_freq")
if(!(s<p.length))return A.a(p,s)
h=p[s]
p.$flags&2&&A.b(p)
p[s]=h-0.0009765625*h
h=o[s]
c=p[s]
o.$flags&2&&A.b(o)
o[s]=h+c}p===$&&A.c("_freq")
if(!(k>=0&&k<p.length))return A.a(p,k)
q=p[k]
p.$flags&2&&A.b(p)
p[k]=q+0.0009765625
o===$&&A.c("_bias")
if(!(k<o.length))return A.a(o,k)
q=o[k]
o.$flags&2&&A.b(o)
o[k]=q-1
return j},
lr(a,b,c){var s,r,q,p,o,n,m
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
A.hV.prototype={
p(a){var s,r=this,q=r.a
if(q===r.c.length)r.fi(q+1)
q=r.c
s=r.a++
q.$flags&2&&A.b(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=a&255},
i_(a,b){var s,r,q=this
t.L.a(a)
if(b==null)b=J.bC(a)
s=q.a+b
if(s>q.c.length)q.fi(s)
s=q.c
r=q.a
B.d.aB(s,r,r+b,a)
q.a+=b},
a2(a){return this.i_(a,null)},
a3(a){var s=this
A.n(a)
if(s.b){s.p(B.a.j(a,8)&255)
s.p(a&255)
return}s.p(a&255)
s.p(B.a.j(a,8)&255)},
K(a){var s=this
if(s.b){s.p(B.a.j(a,24)&255)
s.p(B.a.j(a,16)&255)
s.p(B.a.j(a,8)&255)
s.p(a&255)
return}s.p(a&255)
s.p(B.a.j(a,8)&255)
s.p(B.a.j(a,16)&255)
s.p(B.a.j(a,24)&255)},
mR(a){var s,r,q=this,p=new Float32Array(1)
p[0]=a
s=J.C(B.a8.gq(p),0,null)
if(q.b){if(3>=s.length)return A.a(s,3)
q.p(s[3])
q.p(s[2])
q.p(s[1])
q.p(s[0])
return}r=s.length
if(0>=r)return A.a(s,0)
q.p(s[0])
if(1>=r)return A.a(s,1)
q.p(s[1])
if(2>=r)return A.a(s,2)
q.p(s[2])
if(3>=r)return A.a(s,3)
q.p(s[3])},
mS(a){var s,r,q=this,p=new Float64Array(1)
p[0]=a
s=J.C(B.q.gq(p),0,null)
if(q.b){if(7>=s.length)return A.a(s,7)
q.p(s[7])
q.p(s[6])
q.p(s[5])
q.p(s[4])
q.p(s[3])
q.p(s[2])
q.p(s[1])
q.p(s[0])
return}r=s.length
if(0>=r)return A.a(s,0)
q.p(s[0])
if(1>=r)return A.a(s,1)
q.p(s[1])
if(2>=r)return A.a(s,2)
q.p(s[2])
if(3>=r)return A.a(s,3)
q.p(s[3])
if(4>=r)return A.a(s,4)
q.p(s[4])
if(5>=r)return A.a(s,5)
q.p(s[5])
if(6>=r)return A.a(s,6)
q.p(s[6])
if(7>=r)return A.a(s,7)
q.p(s[7])},
fi(a){var s=this.c,r=Math.max(s.length*3,a+8192),q=new Uint8Array(r)
B.d.aB(q,0,this.a,s)
this.c=q},
gu(a){return this.a}}
A.ky.prototype={
a7(){return"QuantizerType."+this.b}}
A.id.prototype={
eu(a){var s,r,q=a.gN(),p=A.V(null,null,B.e,0,B.j,a.gJ(),null,0,1,this.gR(),B.e,q,!1)
q=p.a
s=q.gI(q)
s.E()
p.z=a.z
p.w=a.w
p.y=a.y
for(q=a.a,q=q.gI(q);q.E();){r=q.gO()
s.gO().i(0,0,this.i3(r))
s.E()}return p}}
A.b4.prototype={
h(a){var s=this.b
return s===0?0:B.a.aa(this.a,s)},
Z(a,b){if(b==null)return!1
return b instanceof A.b4&&this.a===b.a&&this.b===b.b},
gM(a){return A.k5(this.a,this.b,B.F,B.F)},
D(a){return""+this.a+"/"+this.b}}
A.hQ.prototype={
a7(){return"Level."+this.b}}
A.jY.prototype={
hf(a){B.c.C(this.c,a)
if(a.d.a<=3)A.rJ(a)},
hy(a){return this.hf(new A.eL(a,null,$.nG().$1(null),B.dG))}}
A.jZ.prototype={
$1(a){return a},
$S:43}
A.eL.prototype={}
A.hR.prototype={
hU(){var s,r=this,q=A.J(t.N,t.z)
q.i(0,"bytes",r.a)
q.i(0,"width",r.b)
q.i(0,"height",r.c)
s=r.e
if(s!=null)q.i(0,"mimeType",s)
s=r.d
if(s!=null)q.i(0,"blurhash",s)
s=r.f
if(s!=null)q.i(0,"originalHeight",s)
s=r.r
if(s!=null)q.i(0,"originalWidth",s)
return q}}
A.k1.prototype={}
A.lm.prototype={}
A.fv.prototype={
a7(){return"WebWorkerOperations."+this.b}}
A.mv.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j=t.n1.a(A.pt(A.bz(a).data))
try{n=j
m=n.l(0,"label")
if(n.ac("name")){l=A.n(n.l(0,"name"))
if(!(l>=0&&l<2))return A.a(B.ci,l)
l=B.ci[l]}else l=null
s=new A.lm(m,l,n.l(0,"data"))
switch(s.b){case B.cH:n=A.eJ(t.av.a(s.c),t.N,t.z)
r=A.rd(new A.k1(t.D.a(n.l(0,"bytes")),A.n(n.l(0,"maxDimension")),A.bA(n.l(0,"fileName")),A.p6(n.l(0,"calcBlurhash"))))
n=A.iN(s.a)
m=r
A.pl(n,m==null?null:m.hU())
break
case B.cI:n=J.qp(t.gs.a(s.c),t.p)
n=A.t(n,n.$ti.m("e.E"))
q=A.rc(new Uint8Array(A.p(n)))
n=A.iN(s.a)
q=q
A.pl(n,q==null?null:q.hU())
break
default:throw A.f(new A.bx())}}catch(k){p=A.br(k)
o=A.c0(k)
A.v2(p,o,A.iN(J.d(j,"label")))}},
$S:44}
A.k2.prototype={
mp(a,b){var s,r=A.re(a)
this.a.l(0,r)
s=B.la.l(0,r)
if(s!=null)return s
return null}};(function aliases(){var s=J.c7.prototype
s.ij=s.D
s=A.H.prototype
s.eL=s.ab})();(function installTearOffs(){var s=hunkHelpers._static_2,r=hunkHelpers._static_1,q=hunkHelpers._static_0,p=hunkHelpers.installInstanceTearOff,o=hunkHelpers._instance_1u,n=hunkHelpers._instance_2u,m=hunkHelpers.installStaticTearOff
s(J,"uJ","r_",45)
r(A,"vs","tP",10)
r(A,"vt","tQ",10)
r(A,"vu","tR",10)
q(A,"po","vg",3)
r(A,"vv","uY",47)
p(A.a7.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bg.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bK.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.b0.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bt.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bu.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bJ.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bI.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.bv.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
p(A.cw.prototype,"gbJ",1,0,null,["$1","$0"],["ag","h"],4,0,0)
o(A.hL.prototype,"gjj","jk",27)
var l
p(l=A.hN.prototype,"gjl",0,3,null,["$3"],["jm"],6,0,0)
p(l,"gjo",0,3,null,["$3"],["jp"],6,0,0)
p(l,"gjq",0,3,null,["$3"],["jr"],6,0,0)
p(l,"gjd",0,3,null,["$3"],["je"],6,0,0)
p(l,"gjf",0,3,null,["$3"],["jg"],6,0,0)
r(A,"wn","t6",0)
r(A,"wg","rZ",0)
r(A,"we","rX",0)
r(A,"wl","t4",0)
r(A,"wm","t5",0)
r(A,"wk","t3",0)
r(A,"wj","t2",0)
r(A,"wi","t1",0)
r(A,"wp","t8",0)
r(A,"wo","t7",0)
r(A,"wh","t_",0)
r(A,"wf","rY",0)
r(A,"wA","tj",0)
r(A,"wy","th",0)
r(A,"wq","t9",0)
r(A,"ws","tb",0)
r(A,"wr","ta",0)
r(A,"wt","tc",0)
r(A,"wB","tk",0)
r(A,"wz","ti",0)
r(A,"wu","td",0)
r(A,"wv","te",0)
r(A,"ww","tf",0)
r(A,"wx","tg",0)
n(A.fn.prototype,"gkP","kQ",11)
n(A.hG.prototype,"gma","mb",11)
m(A,"nD",3,null,["$3"],["to"],2,0)
m(A,"wC",3,null,["$3"],["tp"],2,0)
m(A,"wH",3,null,["$3"],["tu"],2,0)
m(A,"wI",3,null,["$3"],["tv"],2,0)
m(A,"wJ",3,null,["$3"],["tw"],2,0)
m(A,"wK",3,null,["$3"],["tx"],2,0)
m(A,"wL",3,null,["$3"],["ty"],2,0)
m(A,"wM",3,null,["$3"],["tz"],2,0)
m(A,"wN",3,null,["$3"],["tA"],2,0)
m(A,"wO",3,null,["$3"],["tB"],2,0)
m(A,"wD",3,null,["$3"],["tq"],2,0)
m(A,"wE",3,null,["$3"],["tr"],2,0)
m(A,"wF",3,null,["$3"],["ts"],2,0)
m(A,"wG",3,null,["$3"],["tt"],2,0)
m(A,"w0",2,null,["$1$2","$2"],["pE",function(a,b){return A.pE(a,b,t.q)}],37,0)
m(A,"wQ",6,null,["$6"],["tM"],9,0)
m(A,"wR",6,null,["$6"],["tN"],9,0)
m(A,"wP",6,null,["$6"],["tL"],9,0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.K,null)
q(A.K,[A.mL,J.hx,A.fe,J.e8,A.Z,A.H,A.kz,A.e,A.cC,A.eM,A.fw,A.ec,A.fx,A.aB,A.bR,A.cf,A.dh,A.cZ,A.cd,A.aA,A.kN,A.k4,A.ed,A.fL,A.ar,A.jV,A.Y,A.aq,A.eI,A.lt,A.iL,A.bm,A.iC,A.iK,A.lP,A.iw,A.aY,A.iy,A.cY,A.ag,A.ix,A.iH,A.fQ,A.fB,A.iE,A.fD,A.fE,A.h9,A.d5,A.iM,A.co,A.lu,A.hU,A.ff,A.lv,A.ej,A.c8,A.as,A.iI,A.fg,A.hd,A.k3,A.jt,A.ev,A.lo,A.jc,A.b8,A.lH,A.lO,A.jF,A.ez,A.eY,A.j1,A.j2,A.bD,A.W,A.b_,A.iB,A.hc,A.aP,A.a7,A.bO,A.j8,A.aZ,A.jb,A.je,A.M,A.he,A.bF,A.hf,A.hg,A.hh,A.ef,A.fJ,A.em,A.en,A.c1,A.hq,A.hr,A.h6,A.c2,A.jP,A.jK,A.c6,A.hL,A.dU,A.iF,A.hM,A.jQ,A.hN,A.lG,A.kb,A.f9,A.i0,A.iJ,A.bw,A.dG,A.kj,A.cR,A.i4,A.i5,A.i8,A.ic,A.dJ,A.dH,A.dI,A.fc,A.a8,A.fj,A.kH,A.ii,A.kM,A.ij,A.ik,A.k_,A.kQ,A.fm,A.kR,A.kY,A.l8,A.la,A.fl,A.l9,A.kS,A.bS,A.fr,A.iv,A.fs,A.ft,A.fn,A.kZ,A.l_,A.l4,A.l6,A.lJ,A.l2,A.ir,A.is,A.l1,A.fo,A.l5,A.lK,A.iD,A.fp,A.l0,A.bW,A.iu,A.lb,A.bU,A.fu,A.hj,A.hk,A.ep,A.eo,A.eq,A.hm,A.bV,A.bH,A.b2,A.hX,A.lL,A.ht,A.ai,A.id,A.hV,A.b4,A.jY,A.eL,A.hR,A.k1,A.lm,A.k2])
q(J.hx,[J.hK,J.eE,J.eG,J.dy,J.dz,J.dx,J.cz])
q(J.eG,[J.c7,J.q,A.cD,A.eS])
q(J.c7,[J.hY,J.cT,J.bM])
r(J.hI,A.fe)
r(J.jJ,J.q)
q(J.dx,[J.dw,J.eF])
q(A.Z,[A.dA,A.bx,A.hO,A.io,A.ie,A.iA,A.fZ,A.bc,A.fk,A.im,A.dM,A.h7])
r(A.dO,A.H)
r(A.ah,A.dO)
q(A.e,[A.B,A.bN,A.cW,A.cX,A.fC,A.d6,A.d7,A.d8,A.d9,A.da,A.db,A.dc,A.dd,A.de,A.df,A.dg,A.bd,A.ea,A.an,A.ao,A.cF,A.cG,A.cH,A.cI,A.cJ,A.cK,A.cL,A.cM,A.cN,A.cO,A.cP,A.cQ,A.E])
q(A.B,[A.av,A.cq,A.cB,A.jW,A.eH,A.fA])
q(A.av,[A.fi,A.bi,A.eK])
r(A.cp,A.bN)
r(A.dV,A.cf)
r(A.d1,A.dV)
q(A.dh,[A.di,A.aO])
q(A.cd,[A.eb,A.fK])
r(A.el,A.eb)
q(A.aA,[A.hw,A.h3,A.h4,A.ih,A.mm,A.mo,A.lq,A.lp,A.lY,A.lE,A.mq,A.ms,A.mt,A.me,A.mh,A.mi,A.j3,A.jk,A.kc,A.kf,A.ma,A.m5,A.m6,A.li,A.lj,A.lk,A.ll,A.jD,A.jC,A.mb,A.jZ,A.mv])
r(A.du,A.hw)
r(A.eX,A.bx)
q(A.ih,[A.ig,A.d4])
q(A.ar,[A.bh,A.fz])
r(A.cA,A.bh)
q(A.h4,[A.mn,A.lZ,A.m7,A.lF,A.jX,A.k0,A.jy,A.jz,A.jA,A.kw,A.kx,A.m8])
q(A.eS,[A.hS,A.aj])
q(A.aj,[A.fF,A.fH])
r(A.fG,A.fF)
r(A.c9,A.fG)
r(A.fI,A.fH)
r(A.aS,A.fI)
q(A.c9,[A.eN,A.eO])
q(A.aS,[A.eP,A.eQ,A.eR,A.eT,A.eU,A.eV,A.cE])
r(A.dX,A.iA)
q(A.h3,[A.lr,A.ls,A.lQ,A.lw,A.lA,A.lz,A.ly,A.lx,A.lD,A.lC,A.lB,A.lN,A.m3,A.lV,A.lU,A.j6,A.j4,A.j5,A.jj,A.jh,A.ji,A.jq,A.jo,A.jp,A.js,A.jx,A.jw,A.jv,A.jN,A.ka,A.k8,A.k9,A.kd,A.kh,A.ki,A.kg,A.km,A.kn,A.kl,A.ku,A.ks,A.kt,A.kE,A.kF,A.kD,A.kJ,A.kK,A.l3,A.m2,A.lf,A.ld,A.le])
r(A.fy,A.iy)
r(A.iG,A.fQ)
r(A.dT,A.fz)
r(A.d_,A.fK)
q(A.h9,[A.lS,A.lR,A.iq])
r(A.hb,A.d5)
q(A.hb,[A.hP,A.ip])
r(A.jT,A.lS)
r(A.jS,A.lR)
q(A.bc,[A.dK,A.hu])
q(A.lu,[A.ew,A.dW,A.dR,A.e9,A.ja,A.au,A.ek,A.h0,A.am,A.aJ,A.dj,A.al,A.cs,A.cr,A.bf,A.dl,A.jL,A.dD,A.f8,A.ca,A.i_,A.cb,A.bk,A.fd,A.aC,A.cS,A.ac,A.b6,A.cU,A.dQ,A.hn,A.hi,A.eD,A.jl,A.ky,A.hQ,A.fv])
r(A.lX,A.lo)
r(A.fY,A.ej)
q(A.ez,[A.ex,A.ey])
q(A.eY,[A.iz,A.hW])
q(A.bd,[A.h5,A.cn])
r(A.h8,A.ea)
r(A.bE,A.b_)
q(A.a7,[A.bg,A.cv,A.bK,A.b0,A.bt,A.bu,A.bJ,A.bI,A.bv,A.c4,A.c3,A.c5,A.cw])
q(A.jb,[A.h1,A.jg,A.jn,A.ju,A.jM,A.k7,A.ke,A.kk,A.kr,A.kC,A.kI,A.lc])
r(A.jd,A.h1)
q(A.je,[A.j7,A.jr,A.ln,A.jO,A.hZ,A.kv,A.kG,A.kL,A.lg])
r(A.hy,A.bF)
q(A.hy,[A.eA,A.hA,A.hB,A.hC,A.eB])
r(A.hz,A.ef)
r(A.hD,A.en)
r(A.ho,A.aZ)
r(A.hp,A.ln)
q(A.c2,[A.cu,A.dk])
r(A.hE,A.f9)
r(A.hF,A.i0)
r(A.cc,A.M)
q(A.bw,[A.i2,A.i3,A.i6,A.i7,A.ia,A.ib])
q(A.dG,[A.fb,A.i9])
q(A.ic,[A.b3,A.R])
r(A.hG,A.fn)
r(A.hH,A.fu)
r(A.eC,A.bV)
q(A.ao,[A.dm,A.dn,A.er,A.es,A.et,A.eu,A.dp,A.cx,A.dq,A.dr,A.ds,A.dt])
q(A.b2,[A.eZ,A.f_,A.f0,A.f1,A.f2,A.f3,A.f4,A.dC,A.aT])
r(A.hT,A.id)
s(A.dO,A.bR)
s(A.fF,A.H)
s(A.fG,A.aB)
s(A.fH,A.H)
s(A.fI,A.aB)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{h:"int",D:"double",k:"num",X:"String",at:"bool",as:"Null",r:"List",K:"Object",b1:"Map",a4:"JSObject"},mangledNames:{},types:["~(ai)","an?()","h(h,by,h)","~()","h([h])","M?()","~(c6,cy,h)","k(x)","~(@)","~(h,h,h,h,h,b7)","~(~())","~(h,at)","as(@)","@()","K?(K?)","~(X,aP)","~(h,h,h)","as()","ei()","h(h)","as(@,b5)","~(k,k,k,k)","as(~())","by(h)","@(@)","~(K?,K?)","h()","~(h)","@(@,X)","~(b7)","at(X)","b3(h,h)","R(h,h)","@(X)","at(h)","~(h,a7)","aZ?()","0^(0^,0^)<k>","bV?()","an()","k(k,k,k,k)","k(k,k,k,k,k)","at(an)","b5?(b5?)","as(a4)","h(@,@)","~(h,@)","D(bD)","as(K,b5)","~(@,@)","h(h,h)","c1?()"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti"),rttc:{"2;":(a,b)=>c=>c instanceof A.d1&&a.b(c.a)&&b.b(c.b)}}
A.u9(v.typeUniverse,JSON.parse('{"bM":"c7","hY":"c7","cT":"c7","x0":"cD","hK":{"at":[],"S":[]},"eE":{"S":[]},"eG":{"a4":[]},"c7":{"a4":[]},"q":{"r":["1"],"B":["1"],"a4":[],"e":["1"],"ap":["1"]},"hI":{"fe":[]},"jJ":{"q":["1"],"r":["1"],"B":["1"],"a4":[],"e":["1"],"ap":["1"]},"e8":{"z":["1"]},"dx":{"D":[],"k":[],"be":["k"]},"dw":{"D":[],"h":[],"k":[],"be":["k"],"S":[]},"eF":{"D":[],"k":[],"be":["k"],"S":[]},"cz":{"X":[],"be":["X"],"ox":[],"ap":["@"],"S":[]},"dA":{"Z":[]},"ah":{"H":["h"],"bR":["h"],"r":["h"],"B":["h"],"e":["h"],"H.E":"h","bR.E":"h"},"B":{"e":["1"]},"av":{"B":["1"],"e":["1"]},"fi":{"av":["1"],"B":["1"],"e":["1"],"e.E":"1","av.E":"1"},"cC":{"z":["1"]},"bN":{"e":["2"],"e.E":"2"},"cp":{"bN":["1","2"],"B":["2"],"e":["2"],"e.E":"2"},"eM":{"z":["2"]},"bi":{"av":["2"],"B":["2"],"e":["2"],"e.E":"2","av.E":"2"},"cW":{"e":["1"],"e.E":"1"},"fw":{"z":["1"]},"cq":{"B":["1"],"e":["1"],"e.E":"1"},"ec":{"z":["1"]},"cX":{"e":["1"],"e.E":"1"},"fx":{"z":["1"]},"dO":{"H":["1"],"bR":["1"],"r":["1"],"B":["1"],"e":["1"]},"d1":{"dV":[],"cf":[]},"dh":{"b1":["1","2"]},"di":{"dh":["1","2"],"b1":["1","2"]},"fC":{"e":["1"],"e.E":"1"},"cZ":{"z":["1"]},"aO":{"dh":["1","2"],"b1":["1","2"]},"eb":{"cd":["1"],"B":["1"],"e":["1"]},"el":{"eb":["1"],"cd":["1"],"B":["1"],"e":["1"]},"hw":{"aA":[],"bG":[]},"du":{"aA":[],"bG":[]},"eX":{"bx":[],"Z":[]},"hO":{"Z":[]},"io":{"Z":[]},"fL":{"b5":[]},"aA":{"bG":[]},"h3":{"aA":[],"bG":[]},"h4":{"aA":[],"bG":[]},"ih":{"aA":[],"bG":[]},"ig":{"aA":[],"bG":[]},"d4":{"aA":[],"bG":[]},"ie":{"Z":[]},"bh":{"ar":["1","2"],"jU":["1","2"],"b1":["1","2"],"ar.K":"1","ar.V":"2"},"cB":{"B":["1"],"e":["1"],"e.E":"1"},"Y":{"z":["1"]},"jW":{"B":["1"],"e":["1"],"e.E":"1"},"aq":{"z":["1"]},"eH":{"B":["c8<1,2>"],"e":["c8<1,2>"],"e.E":"c8<1,2>"},"eI":{"z":["c8<1,2>"]},"cA":{"bh":["1","2"],"ar":["1","2"],"jU":["1","2"],"b1":["1","2"],"ar.K":"1","ar.V":"2"},"dV":{"cf":[]},"cD":{"a4":[],"h2":[],"S":[]},"eS":{"a4":[],"a5":[]},"iL":{"h2":[]},"hS":{"j9":[],"a4":[],"a5":[],"S":[]},"aj":{"aR":["1"],"a4":[],"a5":[],"ap":["1"]},"c9":{"H":["D"],"aj":["D"],"r":["D"],"aR":["D"],"B":["D"],"a4":[],"a5":[],"ap":["D"],"e":["D"],"aB":["D"]},"aS":{"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"]},"eN":{"c9":[],"jm":[],"H":["D"],"aj":["D"],"r":["D"],"aR":["D"],"B":["D"],"a4":[],"a5":[],"ap":["D"],"e":["D"],"aB":["D"],"S":[],"H.E":"D"},"eO":{"c9":[],"ei":[],"H":["D"],"aj":["D"],"r":["D"],"aR":["D"],"B":["D"],"a4":[],"a5":[],"ap":["D"],"e":["D"],"aB":["D"],"S":[],"H.E":"D"},"eP":{"aS":[],"cy":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"eQ":{"aS":[],"jG":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"eR":{"aS":[],"jH":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"eT":{"aS":[],"il":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"eU":{"aS":[],"by":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"eV":{"aS":[],"kP":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"cE":{"aS":[],"b7":[],"H":["h"],"aj":["h"],"r":["h"],"aR":["h"],"B":["h"],"a4":[],"a5":[],"ap":["h"],"e":["h"],"aB":["h"],"S":[],"H.E":"h"},"iA":{"Z":[]},"dX":{"bx":[],"Z":[]},"aY":{"Z":[]},"fy":{"iy":["1"]},"ag":{"ct":["1"]},"fQ":{"oO":[]},"iG":{"fQ":[],"oO":[]},"fz":{"ar":["1","2"],"b1":["1","2"]},"dT":{"fz":["1","2"],"ar":["1","2"],"b1":["1","2"],"ar.K":"1","ar.V":"2"},"fA":{"B":["1"],"e":["1"],"e.E":"1"},"fB":{"z":["1"]},"d_":{"cd":["1"],"B":["1"],"e":["1"]},"fD":{"z":["1"]},"H":{"r":["1"],"B":["1"],"e":["1"]},"ar":{"b1":["1","2"]},"eK":{"rN":["1"],"av":["1"],"B":["1"],"e":["1"],"e.E":"1","av.E":"1"},"fE":{"z":["1"]},"cd":{"B":["1"],"e":["1"]},"fK":{"cd":["1"],"B":["1"],"e":["1"]},"hb":{"d5":["X","r<h>"]},"hP":{"d5":["X","r<h>"]},"ip":{"d5":["X","r<h>"]},"co":{"be":["co"]},"D":{"k":[],"be":["k"]},"h":{"k":[],"be":["k"]},"r":{"B":["1"],"e":["1"]},"k":{"be":["k"]},"X":{"be":["X"],"ox":[]},"fZ":{"Z":[]},"bx":{"Z":[]},"bc":{"Z":[]},"dK":{"Z":[]},"hu":{"Z":[]},"fk":{"Z":[]},"im":{"Z":[]},"dM":{"Z":[]},"h7":{"Z":[]},"hU":{"Z":[]},"ff":{"Z":[]},"iI":{"b5":[]},"ev":{"qu":[]},"ex":{"ez":[]},"iz":{"eY":[]},"ey":{"ez":[]},"hW":{"eY":[]},"W":{"z":["k"]},"d6":{"x":[],"e":["k"],"e.E":"k"},"d7":{"x":[],"e":["k"],"e.E":"k"},"d8":{"x":[],"e":["k"],"e.E":"k"},"d9":{"x":[],"e":["k"],"e.E":"k"},"da":{"x":[],"e":["k"],"e.E":"k"},"db":{"x":[],"e":["k"],"e.E":"k"},"dc":{"x":[],"e":["k"],"e.E":"k"},"dd":{"x":[],"e":["k"],"e.E":"k"},"de":{"x":[],"e":["k"],"e.E":"k"},"df":{"x":[],"e":["k"],"e.E":"k"},"dg":{"x":[],"e":["k"],"e.E":"k"},"bd":{"x":[],"e":["k"],"e.E":"k"},"h5":{"x":[],"e":["k"],"e.E":"k"},"cn":{"x":[],"e":["k"],"e.E":"k"},"ea":{"x":[],"e":["k"],"e.E":"k"},"h8":{"x":[],"e":["k"],"e.E":"k"},"bE":{"b_":[]},"bg":{"a7":[]},"cv":{"a7":[]},"bK":{"a7":[]},"b0":{"a7":[]},"bt":{"a7":[]},"bu":{"a7":[]},"bJ":{"a7":[]},"bI":{"a7":[]},"bv":{"a7":[]},"c4":{"a7":[]},"c3":{"a7":[]},"c5":{"a7":[]},"cw":{"a7":[]},"aZ":{"M":[]},"eA":{"bF":[]},"hy":{"bF":[]},"hh":{"M":[]},"hz":{"ef":[]},"hA":{"bF":[]},"hB":{"bF":[]},"hC":{"bF":[]},"eB":{"bF":[]},"hD":{"en":[]},"c1":{"M":[]},"hq":{"M":[]},"ho":{"aZ":[],"M":[]},"cu":{"c2":[]},"dk":{"c2":[]},"hE":{"f9":[]},"i0":{"M":[]},"hF":{"M":[]},"cc":{"M":[]},"i2":{"bw":[]},"i3":{"bw":[]},"i6":{"bw":[]},"i7":{"bw":[]},"ia":{"bw":[]},"ib":{"bw":[]},"fb":{"dG":[]},"i9":{"dG":[]},"i4":{"M":[]},"dH":{"M":[]},"dI":{"M":[]},"fc":{"M":[]},"fj":{"M":[]},"ik":{"M":[]},"hH":{"fu":[]},"bV":{"M":[]},"eC":{"bV":[],"M":[]},"an":{"e":["u"],"e.E":"u"},"ao":{"e":["u"]},"dm":{"ao":[],"e":["u"],"e.E":"u"},"dn":{"ao":[],"e":["u"],"e.E":"u"},"er":{"ao":[],"e":["u"],"e.E":"u"},"es":{"ao":[],"e":["u"],"e.E":"u"},"et":{"ao":[],"e":["u"],"e.E":"u"},"eu":{"ao":[],"e":["u"],"e.E":"u"},"dp":{"ao":[],"e":["u"],"e.E":"u"},"cx":{"ao":[],"e":["u"],"e.E":"u"},"dq":{"ao":[],"e":["u"],"e.E":"u"},"dr":{"ao":[],"e":["u"],"e.E":"u"},"ds":{"ao":[],"e":["u"],"e.E":"u"},"dt":{"ao":[],"e":["u"],"e.E":"u"},"eZ":{"b2":[]},"f_":{"b2":[]},"f0":{"b2":[]},"f1":{"b2":[]},"f2":{"b2":[]},"f3":{"b2":[]},"f4":{"b2":[]},"dC":{"b2":[]},"aT":{"b2":[]},"cF":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cG":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cH":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cI":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cJ":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cK":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"hX":{"z":["u"]},"cL":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cM":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cN":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cO":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cP":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"cQ":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"E":{"u":[],"x":[],"e":["k"],"z":["u"],"e.E":"k"},"hT":{"id":[]},"j9":{"a5":[]},"jH":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"b7":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"kP":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"cy":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"il":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"jG":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"by":{"r":["h"],"B":["h"],"a5":[],"e":["h"]},"jm":{"r":["D"],"B":["D"],"a5":[],"e":["D"]},"ei":{"r":["D"],"B":["D"],"a5":[],"e":["D"]},"x":{"e":["k"]},"u":{"x":[],"z":["u"],"e":["k"]}}'))
A.u8(v.typeUniverse,JSON.parse('{"B":1,"dO":1,"aj":1,"fK":1,"h9":2,"ic":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",b:"PVRTC requires a power-of-two sized image.",g:"[native implementations worker] Error responding: "}
var t=(function rtii(){var s=A.T
return{u:s("aY"),lo:s("h2"),fW:s("j9"),aO:s("e9"),G:s("x"),O:s("bD"),bP:s("be<@>"),e:s("di<X,h>"),cs:s("co"),gt:s("B<@>"),C:s("Z"),iW:s("he"),oD:s("cs"),ho:s("hg"),pk:s("jm"),kI:s("ei"),Z:s("bG"),co:s("eo"),a6:s("hj"),lq:s("hk"),lJ:s("ep"),aw:s("hr"),P:s("aP"),r:s("a7"),mo:s("an"),x:s("ao"),iI:s("cx"),m6:s("cy"),k:s("jG"),jx:s("jH"),id:s("e<D>"),e7:s("e<@>"),fm:s("e<h>"),an:s("q<h6>"),a_:s("q<hf>"),lv:s("q<ef>"),lM:s("q<en>"),nK:s("q<eo>"),g:s("q<an>"),ns:s("q<c6>"),hc:s("q<r<r<r<h>>>>"),o:s("q<r<r<h>>>"),hg:s("q<r<b7>>"),A:s("q<r<D>>"),S:s("q<r<h>>"),U:s("q<r<k>>"),fi:s("q<f9>"),mS:s("q<cR>"),na:s("q<bw>"),k9:s("q<i8>"),lf:s("q<b4>"),s:s("q<X>"),fZ:s("q<ij>"),gF:s("q<by>"),h:s("q<b7>"),by:s("q<bS>"),l3:s("q<fo>"),cy:s("q<fp>"),ip:s("q<iu>"),iu:s("q<bU>"),J:s("q<fu>"),cF:s("q<bW>"),n0:s("q<iB>"),bm:s("q<iD>"),kv:s("q<dU>"),n:s("q<D>"),dG:s("q<@>"),t:s("q<h>"),gU:s("q<hM?>"),mD:s("q<by?>"),a:s("q<k>"),B:s("q<~(ai)>"),iy:s("ap<@>"),v:s("eE"),m:s("a4"),dY:s("bM"),dX:s("aR<@>"),fg:s("c6"),n1:s("jU<@,@>"),p8:s("eK<X>"),fh:s("r<bD>"),aL:s("r<an>"),mL:s("r<r<bS>>"),f:s("r<r<h>>"),cf:s("r<cR>"),ee:s("r<b4>"),ac:s("r<fl>"),jz:s("r<bS>"),o6:s("r<fo>"),jt:s("r<fr>"),as:s("r<fs>"),f4:s("r<ft>"),bd:s("r<D>"),gs:s("r<@>"),L:s("r<h>"),hQ:s("r<c2?>"),bi:s("r<b7?>"),a3:s("r<fJ?>"),dW:s("r<h?>"),je:s("b1<X,X>"),av:s("b1<@,@>"),dQ:s("c9"),aj:s("aS"),dO:s("aj<@>"),hD:s("cE"),b:s("as"),K:s("K"),mK:s("u"),dS:s("cR"),ok:s("i5"),dM:s("fb"),mi:s("dG"),fF:s("dH"),nv:s("dJ<b3>"),n5:s("dJ<R>"),j:s("b3"),R:s("R"),i:s("b4"),lZ:s("x2"),aK:s("+()"),l:s("b5"),N:s("X"),e8:s("ii"),aJ:s("S"),do:s("bx"),hM:s("il"),Q:s("by"),nn:s("kP"),D:s("b7"),cx:s("cT"),e5:s("fl"),nC:s("bS"),d:s("fp"),f_:s("fr"),h2:s("fs"),ij:s("ft"),no:s("cW<X>"),fT:s("cW<h>"),c:s("ag<@>"),mp:s("dT<K?,K?>"),nA:s("fJ"),y:s("at"),nU:s("at(K)"),gS:s("at(X)"),gw:s("at(h)"),V:s("D"),z:s("@"),mY:s("@()"),W:s("@(K)"),Y:s("@(K,b5)"),p:s("h"),bL:s("aZ?"),_:s("M?"),gK:s("ct<as>?"),bT:s("c1?"),er:s("c2?"),H:s("an?"),jH:s("cy?"),mU:s("a4?"),T:s("r<h>?"),iM:s("r<c2?>?"),gy:s("r<h?>?"),lG:s("b1<X,X>?"),X:s("K?"),jv:s("X?"),nh:s("b7?"),nX:s("fm?"),nk:s("iv?"),b0:s("bV?"),F:s("cY<@,@>?"),nF:s("iE?"),fU:s("at?"),jX:s("D?"),I:s("h?"),jh:s("k?"),bZ:s("~(h)?"),ec:s("~(h,at)?"),q:s("k"),w:s("~"),M:s("~()"),E:s("~(c6,cy,h)"),kX:s("~(h,at)"),jO:s("~(k,k,k,k)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.dA=J.hx.prototype
B.c=J.q.prototype
B.a=J.dw.prototype
B.b=J.dx.prototype
B.m=J.cz.prototype
B.dD=J.bM.prototype
B.dE=J.eG.prototype
B.a8=A.eN.prototype
B.q=A.eO.prototype
B.a9=A.eP.prototype
B.u=A.eQ.prototype
B.aB=A.eR.prototype
B.D=A.eT.prototype
B.o=A.eU.prototype
B.d=A.cE.prototype
B.co=J.hY.prototype
B.b3=J.cT.prototype
B.ae=new A.h0(0,"direct")
B.aF=new A.h0(1,"alpha")
B.aG=new A.al(0,"none")
B.af=new A.al(3,"bitfields")
B.aH=new A.al(6,"alphaBitfields")
B.T=new A.e9(0,"littleEndian")
B.a2=new A.e9(1,"bigEndian")
B.cV=new A.du(A.w0(),A.T("du<D>"))
B.cW=new A.ec(A.T("ec<0&>"))
B.b6=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.cX=function() {
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
B.d1=function(getTagFallback) {
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
B.cY=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.d0=function(hooks) {
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
B.d_=function(hooks) {
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
B.cZ=function(hooks) {
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
B.b7=function(hooks) { return hooks; }

B.b8=new A.hP()
B.b9=new A.jT()
B.d2=new A.hU()
B.F=new A.kz()
B.d3=new A.ip()
B.d4=new A.iF()
B.G=new A.iG()
B.ag=new A.iI()
B.ba=new A.iJ()
B.bb=new A.lX()
B.bc=new A.ja(4,"luminance")
B.d5=new A.h8(4294967295)
B.bd=new A.aJ(0,"none")
B.aI=new A.aJ(1,"floydSteinberg")
B.dc=new A.aJ(8,"bayer4x4")
B.de=new A.dj(0,"raster")
B.df=new A.dj(1,"serpentine")
B.dg=new A.dj(2,"zigzag")
B.dh=new A.dj(3,"hilbert")
B.di=new A.cr(0,"red")
B.dj=new A.cr(1,"green")
B.dk=new A.cr(2,"blue")
B.dl=new A.cr(3,"alpha")
B.dm=new A.cr(4,"other")
B.be=new A.cs(1,"half")
B.bf=new A.cs(2,"float")
B.bg=new A.bf(0,"none")
B.dw=new A.jl(2,"both")
B.P=new A.ek(0,"uint")
B.aJ=new A.ek(1,"int")
B.aK=new A.ek(2,"float")
B.A=new A.au(0,"uint1")
B.w=new A.au(1,"uint2")
B.I=new A.au(10,"float32")
B.Q=new A.au(11,"float64")
B.B=new A.au(2,"uint4")
B.e=new A.au(3,"uint8")
B.n=new A.au(4,"uint16")
B.R=new A.au(5,"uint32")
B.U=new A.au(6,"int8")
B.V=new A.au(7,"int16")
B.W=new A.au(8,"int32")
B.H=new A.au(9,"float16")
B.bh=new A.hi(1,"page")
B.j=new A.hi(2,"sequence")
B.S=new A.hn(0,"none")
B.aL=new A.hn(1,"deflate")
B.bi=new A.dl(2,"cur")
B.f=new A.am(0,"none")
B.bj=new A.am(1,"byte")
B.bk=new A.am(10,"sRational")
B.bl=new A.am(11,"single")
B.bm=new A.am(12,"double")
B.bn=new A.am(13,"ifd")
B.l=new A.am(2,"ascii")
B.k=new A.am(3,"short")
B.p=new A.am(4,"long")
B.v=new A.am(5,"rational")
B.bo=new A.am(6,"sByte")
B.J=new A.am(7,"undefined")
B.bp=new A.am(8,"sShort")
B.bq=new A.am(9,"sLong")
B.aM=new A.ew(0,"gzip")
B.a3=new A.ew(1,"zlib")
B.dz=new A.ew(2,"raw")
B.a4=new A.eD(0,"nearest")
B.dB=new A.eD(1,"linear")
B.dC=new A.eD(3,"average")
B.mf=new A.jL(0,"yuv444")
B.dF=new A.jS(!1)
B.dG=new A.hQ(1,"error")
B.dH=new A.hQ(3,"info")
B.K=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15],t.t)
B.ah=s([0,2,8],t.t)
B.dJ=s([0,4,2,1],t.t)
B.dK=s([0,8,10],t.t)
B.dx=new A.dl(0,"invalid")
B.dy=new A.dl(1,"ico")
B.dM=s([B.dx,B.dy,B.bi],A.T("q<dl>"))
B.aO=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],t.t)
B.bs=s([252,243,207,63],t.t)
B.le=new A.dD(0,"none")
B.cr=new A.dD(1,"background")
B.cs=new A.dD(2,"previous")
B.bt=s([B.le,B.cr,B.cs],A.T("q<dD>"))
B.ai=s([292,260,226,226],t.t)
B.bu=s([0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125],t.t)
B.e4=s([0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0],t.t)
B.bw=s([2,3,7],t.t)
B.aj=s([3226,6412,200,168,38,38,134,134,100,100,100,100,68,68,68,68],t.t)
B.e7=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],t.t)
B.ef=s([3,3,11],t.t)
B.et=s([4,5,6],t.t)
B.by=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7],t.t)
B.aV=s([128,128,128,128,128,128,128,128,128,128,128],t.t)
B.bC=s([B.aV,B.aV,B.aV],t.S)
B.f4=s([253,136,254,255,228,219,128,128,128,128,128],t.t)
B.hb=s([189,129,242,255,227,213,255,219,128,128,128],t.t)
B.hg=s([106,126,227,252,214,209,255,255,128,128,128],t.t)
B.iS=s([B.f4,B.hb,B.hg],t.S)
B.j_=s([1,98,248,255,236,226,255,255,128,128,128],t.t)
B.el=s([181,133,238,254,221,234,255,154,128,128,128],t.t)
B.ej=s([78,134,202,247,198,180,255,219,128,128,128],t.t)
B.jr=s([B.j_,B.el,B.ej],t.S)
B.f_=s([1,185,249,255,243,255,128,128,128,128,128],t.t)
B.iX=s([184,150,247,255,236,224,128,128,128,128,128],t.t)
B.kl=s([77,110,216,255,236,230,128,128,128,128,128],t.t)
B.ij=s([B.f_,B.iX,B.kl],t.S)
B.it=s([1,101,251,255,241,255,128,128,128,128,128],t.t)
B.f2=s([170,139,241,252,236,209,255,255,128,128,128],t.t)
B.iB=s([37,116,196,243,228,255,255,255,128,128,128],t.t)
B.eM=s([B.it,B.f2,B.iB],t.S)
B.hu=s([1,204,254,255,245,255,128,128,128,128,128],t.t)
B.kF=s([207,160,250,255,238,128,128,128,128,128,128],t.t)
B.kE=s([102,103,231,255,211,171,128,128,128,128,128],t.t)
B.fw=s([B.hu,B.kF,B.kE],t.S)
B.eD=s([1,152,252,255,240,255,128,128,128,128,128],t.t)
B.kN=s([177,135,243,255,234,225,128,128,128,128,128],t.t)
B.id=s([80,129,211,255,194,224,128,128,128,128,128],t.t)
B.iR=s([B.eD,B.kN,B.id],t.S)
B.bH=s([1,1,255,128,128,128,128,128,128,128,128],t.t)
B.ji=s([246,1,255,128,128,128,128,128,128,128,128],t.t)
B.hV=s([255,128,128,128,128,128,128,128,128,128,128],t.t)
B.kZ=s([B.bH,B.ji,B.hV],t.S)
B.fp=s([B.bC,B.iS,B.jr,B.ij,B.eM,B.fw,B.iR,B.kZ],t.o)
B.kn=s([198,35,237,223,193,187,162,160,145,155,62],t.t)
B.f3=s([131,45,198,221,172,176,220,157,252,221,1],t.t)
B.km=s([68,47,146,208,149,167,221,162,255,223,128],t.t)
B.hE=s([B.kn,B.f3,B.km],t.S)
B.ju=s([1,149,241,255,221,224,255,255,128,128,128],t.t)
B.jK=s([184,141,234,253,222,220,255,199,128,128,128],t.t)
B.hR=s([81,99,181,242,176,190,249,202,255,255,128],t.t)
B.k9=s([B.ju,B.jK,B.hR],t.S)
B.jY=s([1,129,232,253,214,197,242,196,255,255,128],t.t)
B.kC=s([99,121,210,250,201,198,255,202,128,128,128],t.t)
B.iT=s([23,91,163,242,170,187,247,210,255,255,128],t.t)
B.hZ=s([B.jY,B.kC,B.iT],t.S)
B.fO=s([1,200,246,255,234,255,128,128,128,128,128],t.t)
B.jV=s([109,178,241,255,231,245,255,255,128,128,128],t.t)
B.e3=s([44,130,201,253,205,192,255,255,128,128,128],t.t)
B.kd=s([B.fO,B.jV,B.e3],t.S)
B.ew=s([1,132,239,251,219,209,255,165,128,128,128],t.t)
B.dN=s([94,136,225,251,218,190,255,255,128,128,128],t.t)
B.k_=s([22,100,174,245,186,161,255,199,128,128,128],t.t)
B.ir=s([B.ew,B.dN,B.k_],t.S)
B.jJ=s([1,182,249,255,232,235,128,128,128,128,128],t.t)
B.iL=s([124,143,241,255,227,234,128,128,128,128,128],t.t)
B.h7=s([35,77,181,251,193,211,255,205,128,128,128],t.t)
B.hi=s([B.jJ,B.iL,B.h7],t.S)
B.l_=s([1,157,247,255,236,231,255,255,128,128,128],t.t)
B.fo=s([121,141,235,255,225,227,255,255,128,128,128],t.t)
B.jW=s([45,99,188,251,195,217,255,224,128,128,128],t.t)
B.eL=s([B.l_,B.fo,B.jW],t.S)
B.dO=s([1,1,251,255,213,255,128,128,128,128,128],t.t)
B.e9=s([203,1,248,255,255,128,128,128,128,128,128],t.t)
B.jL=s([137,1,177,255,224,255,128,128,128,128,128],t.t)
B.eE=s([B.dO,B.e9,B.jL],t.S)
B.jC=s([B.hE,B.k9,B.hZ,B.kd,B.ir,B.hi,B.eL,B.eE],t.o)
B.fB=s([253,9,248,251,207,208,255,192,128,128,128],t.t)
B.jj=s([175,13,224,243,193,185,249,198,255,255,128],t.t)
B.kX=s([73,17,171,221,161,179,236,167,255,234,128],t.t)
B.j8=s([B.fB,B.jj,B.kX],t.S)
B.jz=s([1,95,247,253,212,183,255,255,128,128,128],t.t)
B.i6=s([239,90,244,250,211,209,255,255,128,128,128],t.t)
B.kk=s([155,77,195,248,188,195,255,255,128,128,128],t.t)
B.jI=s([B.jz,B.i6,B.kk],t.S)
B.hw=s([1,24,239,251,218,219,255,205,128,128,128],t.t)
B.jl=s([201,51,219,255,196,186,128,128,128,128,128],t.t)
B.i5=s([69,46,190,239,201,218,255,228,128,128,128],t.t)
B.jw=s([B.hw,B.jl,B.i5],t.S)
B.he=s([1,191,251,255,255,128,128,128,128,128,128],t.t)
B.iz=s([223,165,249,255,213,255,128,128,128,128,128],t.t)
B.iZ=s([141,124,248,255,255,128,128,128,128,128,128],t.t)
B.jX=s([B.he,B.iz,B.iZ],t.S)
B.hJ=s([1,16,248,255,255,128,128,128,128,128,128],t.t)
B.fm=s([190,36,230,255,236,255,128,128,128,128,128],t.t)
B.f5=s([149,1,255,128,128,128,128,128,128,128,128],t.t)
B.ex=s([B.hJ,B.fm,B.f5],t.S)
B.iV=s([1,226,255,128,128,128,128,128,128,128,128],t.t)
B.jb=s([247,192,255,128,128,128,128,128,128,128,128],t.t)
B.kj=s([240,128,255,128,128,128,128,128,128,128,128],t.t)
B.eb=s([B.iV,B.jb,B.kj],t.S)
B.kc=s([1,134,252,255,255,128,128,128,128,128,128],t.t)
B.iK=s([213,62,250,255,255,128,128,128,128,128,128],t.t)
B.kK=s([55,93,255,128,128,128,128,128,128,128,128],t.t)
B.iU=s([B.kc,B.iK,B.kK],t.S)
B.eW=s([B.j8,B.jI,B.jw,B.jX,B.ex,B.eb,B.iU,B.bC],t.o)
B.iM=s([202,24,213,235,186,191,220,160,240,175,255],t.t)
B.f1=s([126,38,182,232,169,184,228,174,255,187,128],t.t)
B.eA=s([61,46,138,219,151,178,240,170,255,216,128],t.t)
B.jG=s([B.iM,B.f1,B.eA],t.S)
B.ic=s([1,112,230,250,199,191,247,159,255,255,128],t.t)
B.eK=s([166,109,228,252,211,215,255,174,128,128,128],t.t)
B.iv=s([39,77,162,232,172,180,245,178,255,255,128],t.t)
B.jE=s([B.ic,B.eK,B.iv],t.S)
B.ie=s([1,52,220,246,198,199,249,220,255,255,128],t.t)
B.fu=s([124,74,191,243,183,193,250,221,255,255,128],t.t)
B.h6=s([24,71,130,219,154,170,243,182,255,255,128],t.t)
B.jD=s([B.ie,B.fu,B.h6],t.S)
B.h4=s([1,182,225,249,219,240,255,224,128,128,128],t.t)
B.kI=s([149,150,226,252,216,205,255,171,128,128,128],t.t)
B.l4=s([28,108,170,242,183,194,254,223,255,255,128],t.t)
B.kx=s([B.h4,B.kI,B.l4],t.S)
B.l5=s([1,81,230,252,204,203,255,192,128,128,128],t.t)
B.jS=s([123,102,209,247,188,196,255,233,128,128,128],t.t)
B.kh=s([20,95,153,243,164,173,255,203,128,128,128],t.t)
B.jT=s([B.l5,B.jS,B.kh],t.S)
B.hO=s([1,222,248,255,216,213,128,128,128,128,128],t.t)
B.iJ=s([168,175,246,252,235,205,255,255,128,128,128],t.t)
B.h9=s([47,116,215,255,211,212,255,255,128,128,128],t.t)
B.fg=s([B.hO,B.iJ,B.h9],t.S)
B.hN=s([1,121,236,253,212,214,255,255,128,128,128],t.t)
B.ig=s([141,84,213,252,201,202,255,219,128,128,128],t.t)
B.j6=s([42,80,160,240,162,185,255,205,128,128,128],t.t)
B.hk=s([B.hN,B.ig,B.j6],t.S)
B.kR=s([244,1,255,128,128,128,128,128,128,128,128],t.t)
B.dL=s([238,1,255,128,128,128,128,128,128,128,128],t.t)
B.jd=s([B.bH,B.kR,B.dL],t.S)
B.e1=s([B.jG,B.jE,B.jD,B.kx,B.jT,B.fg,B.hk,B.jd],t.o)
B.ey=s([B.fp,B.jC,B.eW,B.e1],t.hc)
B.bz=s([511,1023,2047,4095],t.t)
B.bA=s([63,207,243,252],t.t)
B.eT=s([17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99],t.t)
B.ak=s([0,1,2,3,4,5,6,7,8,9,10,11],t.t)
B.f7=s([8,8,4,2],t.t)
B.dX=s([173,148,140],t.t)
B.dY=s([176,155,140,135],t.t)
B.dV=s([180,157,141,134,130],t.t)
B.e8=s([254,254,243,230,196,177,153,140,133,130,129],t.t)
B.bB=s([B.dX,B.dY,B.dV,B.e8],t.S)
B.fb=s([0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576],t.t)
B.bD=s([1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379],t.n)
B.fi=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.bE=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095],t.t)
B.al=s([0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29],t.t)
B.bF=s([1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250],t.t)
B.am=s([96,73,55,39,23,13,5,1,255,255,255,255,255,255,255,255,101,78,58,42,26,16,8,2,0,3,9,17,27,43,59,79,102,86,62,46,32,20,10,6,4,7,11,21,33,47,63,87,105,90,70,52,37,28,18,14,12,15,19,29,38,53,71,91,110,99,82,66,48,35,30,24,22,25,31,36,49,67,83,100,115,108,94,76,64,50,44,40,34,41,45,51,65,77,95,109,118,113,103,92,80,68,60,56,54,57,61,69,81,93,104,114,119,116,111,106,97,88,84,74,72,75,85,89,98,107,112,117],t.t)
B.r=s([0,1,1,2,4,8,1,1,2,4,8,4,8,4],t.t)
B.bG=s([2954,2956,2958,2962,2970,2986,3018,3082,3212,3468,3980,5004],t.t)
B.bI=s([280,256,256,256,40],t.t)
B.a5=s([0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63],t.t)
B.an=s([62,62,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,588,588,588,588,588,588,588,588,1680,1680,20499,22547,24595,26643,1776,1776,1808,1808,-24557,-22509,-20461,-18413,1904,1904,1936,1936,-16365,-14317,782,782,782,782,814,814,814,814,-12269,-10221,10257,10257,12305,12305,14353,14353,16403,18451,1712,1712,1744,1744,28691,30739,-32749,-30701,-28653,-26605,2061,2061,2061,2061,2061,2061,2061,2061,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,750,750,750,750,1616,1616,1648,1648,1424,1424,1456,1456,1488,1488,1520,1520,1840,1840,1872,1872,1968,1968,8209,8209,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,1552,1552,1584,1584,2000,2000,2032,2032,976,976,1008,1008,1040,1040,1072,1072,1296,1296,1328,1328,718,718,718,718,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,4113,4113,6161,6161,848,848,880,880,912,912,944,944,622,622,622,622,654,654,654,654,1104,1104,1136,1136,1168,1168,1200,1200,1232,1232,1264,1264,686,686,686,686,1360,1360,1392,1392,12,12,12,12,12,12,12,12,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390],t.t)
B.aR=s([4,5,6,7,8,9,10,10,11,12,13,14,15,16,17,17,18,19,20,20,21,21,22,22,23,23,24,25,25,26,27,28,29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,93,95,96,98,100,101,102,104,106,108,110,112,114,116,118,122,124,126,128,130,132,134,136,138,140,143,145,148,151,154,157],t.t)
B.bJ=s([24,7,23,25,40,6,39,41,22,26,38,42,56,5,55,57,21,27,54,58,37,43,72,4,71,73,20,28,53,59,70,74,36,44,88,69,75,52,60,3,87,89,19,29,86,90,35,45,68,76,85,91,51,61,104,2,103,105,18,30,102,106,34,46,84,92,67,77,101,107,50,62,120,1,119,121,83,93,17,31,100,108,66,78,118,122,33,47,117,123,49,63,99,109,82,94,0,116,124,65,79,16,32,98,110,48,115,125,81,95,64,114,126,97,111,80,113,127,96,112],t.t)
B.aS=s([4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,234,239,245,249,254,259,264,269,274,279,284],t.t)
B.bK=s([0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119],t.t)
B.aT=s([0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28],t.t)
B.dn=new A.cs(0,"uint")
B.bL=s([B.dn,B.be,B.bf],A.T("q<cs>"))
B.a6=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.X=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15],t.t)
B.bN=s([254,253,251,247,239,223,191,127],t.t)
B.ao=s([12,8,140,8,76,8,204,8,44,8,172,8,108,8,236,8,28,8,156,8,92,8,220,8,60,8,188,8,124,8,252,8,2,8,130,8,66,8,194,8,34,8,162,8,98,8,226,8,18,8,146,8,82,8,210,8,50,8,178,8,114,8,242,8,10,8,138,8,74,8,202,8,42,8,170,8,106,8,234,8,26,8,154,8,90,8,218,8,58,8,186,8,122,8,250,8,6,8,134,8,70,8,198,8,38,8,166,8,102,8,230,8,22,8,150,8,86,8,214,8,54,8,182,8,118,8,246,8,14,8,142,8,78,8,206,8,46,8,174,8,110,8,238,8,30,8,158,8,94,8,222,8,62,8,190,8,126,8,254,8,1,8,129,8,65,8,193,8,33,8,161,8,97,8,225,8,17,8,145,8,81,8,209,8,49,8,177,8,113,8,241,8,9,8,137,8,73,8,201,8,41,8,169,8,105,8,233,8,25,8,153,8,89,8,217,8,57,8,185,8,121,8,249,8,5,8,133,8,69,8,197,8,37,8,165,8,101,8,229,8,21,8,149,8,85,8,213,8,53,8,181,8,117,8,245,8,13,8,141,8,77,8,205,8,45,8,173,8,109,8,237,8,29,8,157,8,93,8,221,8,61,8,189,8,125,8,253,8,19,9,275,9,147,9,403,9,83,9,339,9,211,9,467,9,51,9,307,9,179,9,435,9,115,9,371,9,243,9,499,9,11,9,267,9,139,9,395,9,75,9,331,9,203,9,459,9,43,9,299,9,171,9,427,9,107,9,363,9,235,9,491,9,27,9,283,9,155,9,411,9,91,9,347,9,219,9,475,9,59,9,315,9,187,9,443,9,123,9,379,9,251,9,507,9,7,9,263,9,135,9,391,9,71,9,327,9,199,9,455,9,39,9,295,9,167,9,423,9,103,9,359,9,231,9,487,9,23,9,279,9,151,9,407,9,87,9,343,9,215,9,471,9,55,9,311,9,183,9,439,9,119,9,375,9,247,9,503,9,15,9,271,9,143,9,399,9,79,9,335,9,207,9,463,9,47,9,303,9,175,9,431,9,111,9,367,9,239,9,495,9,31,9,287,9,159,9,415,9,95,9,351,9,223,9,479,9,63,9,319,9,191,9,447,9,127,9,383,9,255,9,511,9,0,7,64,7,32,7,96,7,16,7,80,7,48,7,112,7,8,7,72,7,40,7,104,7,24,7,88,7,56,7,120,7,4,7,68,7,36,7,100,7,20,7,84,7,52,7,116,7,3,8,131,8,67,8,195,8,35,8,163,8,99,8,227,8],t.t)
B.aU=s([A.wu(),A.wm(),A.wB(),A.wz(),A.ww(),A.wv(),A.wx()],t.B)
B.bO=s([0,5,16,5,8,5,24,5,4,5,20,5,12,5,28,5,2,5,18,5,10,5,26,5,6,5,22,5,14,5,30,5,1,5,17,5,9,5,25,5,5,5,21,5,13,5,29,5,3,5,19,5,11,5,27,5,7,5,23,5],t.t)
B.b0=new A.ac(0,"whiteIsZero")
B.lI=new A.ac(1,"blackIsZero")
B.lP=new A.ac(2,"rgb")
B.b2=new A.ac(3,"palette")
B.lQ=new A.ac(4,"transparencyMask")
B.cE=new A.ac(5,"cmyk")
B.lR=new A.ac(6,"yCbCr")
B.lS=new A.ac(7,"reserved7")
B.lT=new A.ac(8,"cieLab")
B.lU=new A.ac(9,"iccLab")
B.lJ=new A.ac(10,"ituLab")
B.lK=new A.ac(11,"logL")
B.lL=new A.ac(12,"logLuv")
B.lM=new A.ac(13,"colorFilterArray")
B.lN=new A.ac(14,"linearRaw")
B.lO=new A.ac(15,"depth")
B.b1=new A.ac(16,"unknown")
B.bQ=s([B.b0,B.lI,B.lP,B.b2,B.lQ,B.cE,B.lR,B.lS,B.lT,B.lU,B.lJ,B.lK,B.lL,B.lM,B.lN,B.lO,B.b1],A.T("q<ac>"))
B.bS=s([0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0],t.t)
B.x=s([0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,31],t.t)
B.cp=new A.f8(0,"source")
B.cq=new A.f8(1,"over")
B.bT=s([B.cp,B.cq],A.T("q<f8>"))
B.lA=new A.cS(0,"invalid")
B.aZ=new A.cS(1,"uint")
B.i=new A.cS(2,"int")
B.a1=new A.cS(3,"float")
B.bU=s([B.lA,B.aZ,B.i,B.a1],A.T("q<cS>"))
B.ap=s([17,18,0,1,2,3,4,5,16,6,7,8,9,10,11,12,13,14,15],t.t)
B.aq=s([-0.0,1,-1,2,-2,3,4,6,-3,5,-4,-5,-6,7,-7,8,-8,-9],t.t)
B.bV=s([B.f,B.bj,B.l,B.k,B.p,B.v,B.bo,B.J,B.bp,B.bq,B.bk,B.bl,B.bm,B.bn],A.T("q<am>"))
B.bW=s([0,1,4,8,5,2,3,6,9,12,13,10,7,11,14,15],t.t)
B.dp=new A.bf(1,"rle")
B.dq=new A.bf(2,"zips")
B.dr=new A.bf(3,"zip")
B.ds=new A.bf(4,"piz")
B.dt=new A.bf(5,"pxr24")
B.du=new A.bf(6,"b44")
B.dv=new A.bf(7,"b44a")
B.bX=s([B.bg,B.dp,B.dq,B.dr,B.ds,B.dt,B.du,B.dv],A.T("q<bf>"))
B.j2=s([231,120,48,89,115,113,120,152,112],t.t)
B.e2=s([152,179,64,126,170,118,46,70,95],t.t)
B.i4=s([175,69,143,80,85,82,72,155,103],t.t)
B.eo=s([56,58,10,171,218,189,17,13,152],t.t)
B.iu=s([114,26,17,163,44,195,21,10,173],t.t)
B.iI=s([121,24,80,195,26,62,44,64,85],t.t)
B.iq=s([144,71,10,38,171,213,144,34,26],t.t)
B.k1=s([170,46,55,19,136,160,33,206,71],t.t)
B.fP=s([63,20,8,114,114,208,12,9,226],t.t)
B.hv=s([81,40,11,96,182,84,29,16,36],t.t)
B.dP=s([B.j2,B.e2,B.i4,B.eo,B.iu,B.iI,B.iq,B.k1,B.fP,B.hv],t.S)
B.fl=s([134,183,89,137,98,101,106,165,148],t.t)
B.jN=s([72,187,100,130,157,111,32,75,80],t.t)
B.iP=s([66,102,167,99,74,62,40,234,128],t.t)
B.ea=s([41,53,9,178,241,141,26,8,107],t.t)
B.hq=s([74,43,26,146,73,166,49,23,157],t.t)
B.fZ=s([65,38,105,160,51,52,31,115,128],t.t)
B.h1=s([104,79,12,27,217,255,87,17,7],t.t)
B.i2=s([87,68,71,44,114,51,15,186,23],t.t)
B.jF=s([47,41,14,110,182,183,21,17,194],t.t)
B.jh=s([66,45,25,102,197,189,23,18,22],t.t)
B.ki=s([B.fl,B.jN,B.iP,B.ea,B.hq,B.fZ,B.h1,B.i2,B.jF,B.jh],t.S)
B.j1=s([88,88,147,150,42,46,45,196,205],t.t)
B.iw=s([43,97,183,117,85,38,35,179,61],t.t)
B.h8=s([39,53,200,87,26,21,43,232,171],t.t)
B.hU=s([56,34,51,104,114,102,29,93,77],t.t)
B.ik=s([39,28,85,171,58,165,90,98,64],t.t)
B.fU=s([34,22,116,206,23,34,43,166,73],t.t)
B.dQ=s([107,54,32,26,51,1,81,43,31],t.t)
B.k4=s([68,25,106,22,64,171,36,225,114],t.t)
B.fk=s([34,19,21,102,132,188,16,76,124],t.t)
B.ks=s([62,18,78,95,85,57,50,48,51],t.t)
B.fy=s([B.j1,B.iw,B.h8,B.hU,B.ik,B.fU,B.dQ,B.k4,B.fk,B.ks],t.S)
B.ih=s([193,101,35,159,215,111,89,46,111],t.t)
B.eV=s([60,148,31,172,219,228,21,18,111],t.t)
B.eu=s([112,113,77,85,179,255,38,120,114],t.t)
B.ko=s([40,42,1,196,245,209,10,25,109],t.t)
B.hL=s([88,43,29,140,166,213,37,43,154],t.t)
B.fW=s([61,63,30,155,67,45,68,1,209],t.t)
B.hf=s([100,80,8,43,154,1,51,26,71],t.t)
B.ed=s([142,78,78,16,255,128,34,197,171],t.t)
B.ib=s([41,40,5,102,211,183,4,1,221],t.t)
B.fG=s([51,50,17,168,209,192,23,25,82],t.t)
B.fx=s([B.ih,B.eV,B.eu,B.ko,B.hL,B.fW,B.hf,B.ed,B.ib,B.fG],t.S)
B.h5=s([138,31,36,171,27,166,38,44,229],t.t)
B.fv=s([67,87,58,169,82,115,26,59,179],t.t)
B.jq=s([63,59,90,180,59,166,93,73,154],t.t)
B.ke=s([40,40,21,116,143,209,34,39,175],t.t)
B.ei=s([47,15,16,183,34,223,49,45,183],t.t)
B.f0=s([46,17,33,183,6,98,15,32,183],t.t)
B.l7=s([57,46,22,24,128,1,54,17,37],t.t)
B.hh=s([65,32,73,115,28,128,23,128,205],t.t)
B.iO=s([40,3,9,115,51,192,18,6,223],t.t)
B.hn=s([87,37,9,115,59,77,64,21,47],t.t)
B.ia=s([B.h5,B.fv,B.jq,B.ke,B.ei,B.f0,B.l7,B.hh,B.iO,B.hn],t.S)
B.kQ=s([104,55,44,218,9,54,53,130,226],t.t)
B.eJ=s([64,90,70,205,40,41,23,26,57],t.t)
B.jp=s([54,57,112,184,5,41,38,166,213],t.t)
B.fV=s([30,34,26,133,152,116,10,32,134],t.t)
B.j9=s([39,19,53,221,26,114,32,73,255],t.t)
B.fE=s([31,9,65,234,2,15,1,118,73],t.t)
B.i9=s([75,32,12,51,192,255,160,43,51],t.t)
B.fX=s([88,31,35,67,102,85,55,186,85],t.t)
B.hA=s([56,21,23,111,59,205,45,37,192],t.t)
B.hB=s([55,38,70,124,73,102,1,34,98],t.t)
B.kU=s([B.kQ,B.eJ,B.jp,B.fV,B.j9,B.fE,B.i9,B.fX,B.hA,B.hB],t.S)
B.hz=s([125,98,42,88,104,85,117,175,82],t.t)
B.h0=s([95,84,53,89,128,100,113,101,45],t.t)
B.iC=s([75,79,123,47,51,128,81,171,1],t.t)
B.eG=s([57,17,5,71,102,57,53,41,49],t.t)
B.jk=s([38,33,13,121,57,73,26,1,85],t.t)
B.kH=s([41,10,67,138,77,110,90,47,114],t.t)
B.i7=s([115,21,2,10,102,255,166,23,6],t.t)
B.fn=s([101,29,16,10,85,128,101,196,26],t.t)
B.hd=s([57,18,10,102,102,213,34,20,43],t.t)
B.hK=s([117,20,15,36,163,128,68,1,26],t.t)
B.i1=s([B.hz,B.h0,B.iC,B.eG,B.jk,B.kH,B.i7,B.fn,B.hd,B.hK],t.S)
B.hl=s([102,61,71,37,34,53,31,243,192],t.t)
B.kD=s([69,60,71,38,73,119,28,222,37],t.t)
B.ho=s([68,45,128,34,1,47,11,245,171],t.t)
B.dU=s([62,17,19,70,146,85,55,62,70],t.t)
B.l2=s([37,43,37,154,100,163,85,160,1],t.t)
B.ky=s([63,9,92,136,28,64,32,201,85],t.t)
B.jQ=s([75,15,9,9,64,255,184,119,16],t.t)
B.fs=s([86,6,28,5,64,255,25,248,1],t.t)
B.je=s([56,8,17,132,137,255,55,116,128],t.t)
B.eB=s([58,15,20,82,135,57,26,121,40],t.t)
B.io=s([B.hl,B.kD,B.ho,B.dU,B.l2,B.ky,B.jQ,B.fs,B.je,B.eB],t.S)
B.iG=s([164,50,31,137,154,133,25,35,218],t.t)
B.fr=s([51,103,44,131,131,123,31,6,158],t.t)
B.kv=s([86,40,64,135,148,224,45,183,128],t.t)
B.i3=s([22,26,17,131,240,154,14,1,209],t.t)
B.eY=s([45,16,21,91,64,222,7,1,197],t.t)
B.kf=s([56,21,39,155,60,138,23,102,213],t.t)
B.kT=s([83,12,13,54,192,255,68,47,28],t.t)
B.iQ=s([85,26,85,85,128,128,32,146,171],t.t)
B.hW=s([18,11,7,63,144,171,4,4,246],t.t)
B.fz=s([35,27,10,146,174,171,12,26,128],t.t)
B.hP=s([B.iG,B.fr,B.kv,B.i3,B.eY,B.kf,B.kT,B.iQ,B.hW,B.fz],t.S)
B.jB=s([190,80,35,99,180,80,126,54,45],t.t)
B.k0=s([85,126,47,87,176,51,41,20,32],t.t)
B.jm=s([101,75,128,139,118,146,116,128,85],t.t)
B.jM=s([56,41,15,176,236,85,37,9,62],t.t)
B.eC=s([71,30,17,119,118,255,17,18,138],t.t)
B.im=s([101,38,60,138,55,70,43,26,142],t.t)
B.hS=s([146,36,19,30,171,255,97,27,20],t.t)
B.j0=s([138,45,61,62,219,1,81,188,64],t.t)
B.kp=s([32,41,20,117,151,142,20,21,163],t.t)
B.k2=s([112,19,12,61,195,128,48,4,24],t.t)
B.jv=s([B.jB,B.k0,B.jm,B.jM,B.eC,B.im,B.hS,B.j0,B.kp,B.k2],t.S)
B.bY=s([B.dP,B.ki,B.fy,B.fx,B.ia,B.kU,B.i1,B.io,B.hP,B.jv],t.o)
B.aC=new A.aC(0,"none")
B.N=new A.aC(1,"palette")
B.cC=new A.aC(2,"rgb")
B.lu=new A.aC(3,"gray")
B.lv=new A.aC(4,"reserved4")
B.lw=new A.aC(5,"reserved5")
B.lx=new A.aC(6,"reserved6")
B.ly=new A.aC(7,"reserved7")
B.lz=new A.aC(8,"reserved8")
B.O=new A.aC(9,"paletteRle")
B.cB=new A.aC(10,"rgbRle")
B.lt=new A.aC(11,"grayRle")
B.bZ=s([B.aC,B.N,B.cC,B.lu,B.lv,B.lw,B.lx,B.ly,B.lz,B.O,B.cB,B.lt],A.T("q<aC>"))
B.c1=s([0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250],t.t)
B.iA=s([0,1,1,1,0],t.t)
B.c2=s([A.we(),A.wl(),A.wn(),A.wg(),A.wj(),A.wp(),A.wi(),A.wo(),A.wf(),A.wh()],t.B)
B.aQ=s([8,0,8,0],t.t)
B.eH=s([5,3,5,3],t.t)
B.eg=s([3,5,3,5],t.t)
B.br=s([0,8,0,8],t.t)
B.bx=s([4,4,4,4],t.t)
B.es=s([4,4,0,0],t.t)
B.c3=s([B.aQ,B.eH,B.eg,B.br,B.aQ,B.bx,B.es,B.br],t.S)
B.c4=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535],t.t)
B.ar=s([80,88,23,71,30,30,62,62,4,4,4,4,4,4,4,4,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41],t.t)
B.iY=s([16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99],t.t)
B.Y=s([0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845],t.t)
B.c5=s([127,127,191,127,159,191,223,127,143,159,175,191,207,223,239,127,135,143,151,159,167,175,183,191,199,207,215,223,231,239,247,127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,127],t.t)
B.as=s([7,6,6,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],t.t)
B.L=s([28679,28679,31752,-32759,-31735,-30711,-29687,-28663,29703,29703,30727,30727,-27639,-26615,-25591,-24567],t.t)
B.at=s([6430,6400,6400,6400,3225,3225,3225,3225,944,944,944,944,976,976,976,976,1456,1456,1456,1456,1488,1488,1488,1488,718,718,718,718,718,718,718,718,750,750,750,750,750,750,750,750,1520,1520,1520,1520,1552,1552,1552,1552,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,654,654,654,654,654,654,654,654,1072,1072,1072,1072,1104,1104,1104,1104,1136,1136,1136,1136,1168,1168,1168,1168,1200,1200,1200,1200,1232,1232,1232,1232,622,622,622,622,622,622,622,622,1008,1008,1008,1008,1040,1040,1040,1040,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,1712,1712,1712,1712,1744,1744,1744,1744,846,846,846,846,846,846,846,846,1264,1264,1264,1264,1296,1296,1296,1296,1328,1328,1328,1328,1360,1360,1360,1360,1392,1392,1392,1392,1424,1424,1424,1424,686,686,686,686,686,686,686,686,910,910,910,910,910,910,910,910,1968,1968,1968,1968,2000,2000,2000,2000,2032,2032,2032,2032,16,16,16,16,10257,10257,10257,10257,12305,12305,12305,12305,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,878,878,878,878,878,878,878,878,1904,1904,1904,1904,1936,1936,1936,1936,-18413,-18413,-16365,-16365,-14317,-14317,-10221,-10221,590,590,590,590,590,590,590,590,782,782,782,782,782,782,782,782,1584,1584,1584,1584,1616,1616,1616,1616,1648,1648,1648,1648,1680,1680,1680,1680,814,814,814,814,814,814,814,814,1776,1776,1776,1776,1808,1808,1808,1808,1840,1840,1840,1840,1872,1872,1872,1872,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,14353,14353,14353,14353,16401,16401,16401,16401,22547,22547,24595,24595,20497,20497,20497,20497,18449,18449,18449,18449,26643,26643,28691,28691,30739,30739,-32749,-32749,-30701,-30701,-28653,-28653,-26605,-26605,-24557,-24557,-22509,-22509,-20461,-20461,8207,8207,8207,8207,8207,8207,8207,8207,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232],t.t)
B.M=s([0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31],t.t)
B.av=s([0,1,2,3,6,4,5,6,6,6,6,6,6,6,6,7,0],t.t)
B.lf=new A.ca(0,"none")
B.lg=new A.ca(1,"sub")
B.lh=new A.ca(2,"up")
B.li=new A.ca(3,"average")
B.lj=new A.ca(4,"paeth")
B.aw=s([B.lf,B.lg,B.lh,B.li,B.lj],A.T("q<ca>"))
B.C=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.E=s([0,1,3,7,15,31,63,127,255],t.t)
B.ax=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.ay=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7],t.t)
B.y=s([255,255,255,255,255,255,255,255,255,255,255],t.t)
B.a_=s([B.y,B.y,B.y],t.S)
B.hT=s([176,246,255,255,255,255,255,255,255,255,255],t.t)
B.kM=s([223,241,252,255,255,255,255,255,255,255,255],t.t)
B.fe=s([249,253,253,255,255,255,255,255,255,255,255],t.t)
B.i8=s([B.hT,B.kM,B.fe],t.S)
B.hx=s([255,244,252,255,255,255,255,255,255,255,255],t.t)
B.hj=s([234,254,254,255,255,255,255,255,255,255,255],t.t)
B.cb=s([253,255,255,255,255,255,255,255,255,255,255],t.t)
B.fq=s([B.hx,B.hj,B.cb],t.S)
B.ku=s([255,246,254,255,255,255,255,255,255,255,255],t.t)
B.ja=s([239,253,254,255,255,255,255,255,255,255,255],t.t)
B.c7=s([254,255,254,255,255,255,255,255,255,255,255],t.t)
B.jO=s([B.ku,B.ja,B.c7],t.S)
B.bP=s([255,248,254,255,255,255,255,255,255,255,255],t.t)
B.fK=s([251,255,254,255,255,255,255,255,255,255,255],t.t)
B.iH=s([B.bP,B.fK,B.y],t.S)
B.aP=s([255,253,254,255,255,255,255,255,255,255,255],t.t)
B.iE=s([251,254,254,255,255,255,255,255,255,255,255],t.t)
B.fS=s([B.aP,B.iE,B.c7],t.S)
B.em=s([255,254,253,255,254,255,255,255,255,255,255],t.t)
B.ht=s([250,255,254,255,254,255,255,255,255,255,255],t.t)
B.au=s([254,255,255,255,255,255,255,255,255,255,255],t.t)
B.hM=s([B.em,B.ht,B.au],t.S)
B.hc=s([B.a_,B.i8,B.fq,B.jO,B.iH,B.fS,B.hM,B.a_],t.o)
B.e0=s([217,255,255,255,255,255,255,255,255,255,255],t.t)
B.hQ=s([225,252,241,253,255,255,254,255,255,255,255],t.t)
B.jo=s([234,250,241,250,253,255,253,254,255,255,255],t.t)
B.k3=s([B.e0,B.hQ,B.jo],t.S)
B.aW=s([255,254,255,255,255,255,255,255,255,255,255],t.t)
B.fh=s([223,254,254,255,255,255,255,255,255,255,255],t.t)
B.eZ=s([238,253,254,254,255,255,255,255,255,255,255],t.t)
B.j7=s([B.aW,B.fh,B.eZ],t.S)
B.hm=s([249,254,255,255,255,255,255,255,255,255,255],t.t)
B.kr=s([B.bP,B.hm,B.y],t.S)
B.k6=s([255,253,255,255,255,255,255,255,255,255,255],t.t)
B.iD=s([247,254,255,255,255,255,255,255,255,255,255],t.t)
B.is=s([B.k6,B.iD,B.y],t.S)
B.eU=s([252,255,255,255,255,255,255,255,255,255,255],t.t)
B.ec=s([B.aP,B.eU,B.y],t.S)
B.cd=s([255,254,254,255,255,255,255,255,255,255,255],t.t)
B.eX=s([B.cd,B.cb,B.y],t.S)
B.j5=s([255,254,253,255,255,255,255,255,255,255,255],t.t)
B.bR=s([250,255,255,255,255,255,255,255,255,255,255],t.t)
B.eS=s([B.j5,B.bR,B.au],t.S)
B.ep=s([B.k3,B.j7,B.kr,B.is,B.ec,B.eX,B.eS,B.a_],t.o)
B.jx=s([186,251,250,255,255,255,255,255,255,255,255],t.t)
B.fH=s([234,251,244,254,255,255,255,255,255,255,255],t.t)
B.jP=s([251,251,243,253,254,255,254,255,255,255,255],t.t)
B.fQ=s([B.jx,B.fH,B.jP],t.S)
B.fM=s([236,253,254,255,255,255,255,255,255,255,255],t.t)
B.j3=s([251,253,253,254,254,255,255,255,255,255,255],t.t)
B.hC=s([B.aP,B.fM,B.j3],t.S)
B.jA=s([254,254,254,255,255,255,255,255,255,255,255],t.t)
B.fI=s([B.cd,B.jA,B.y],t.S)
B.jU=s([254,254,255,255,255,255,255,255,255,255,255],t.t)
B.fL=s([B.aW,B.jU,B.au],t.S)
B.ce=s([B.y,B.au,B.y],t.S)
B.en=s([B.fQ,B.hC,B.fI,B.fL,B.ce,B.a_,B.a_,B.a_],t.o)
B.hr=s([248,255,255,255,255,255,255,255,255,255,255],t.t)
B.h_=s([250,254,252,254,255,255,255,255,255,255,255],t.t)
B.fF=s([248,254,249,253,255,255,255,255,255,255,255],t.t)
B.hF=s([B.hr,B.h_,B.fF],t.S)
B.ek=s([255,253,253,255,255,255,255,255,255,255,255],t.t)
B.kb=s([246,253,253,255,255,255,255,255,255,255,255],t.t)
B.fR=s([252,254,251,254,254,255,255,255,255,255,255],t.t)
B.ka=s([B.ek,B.kb,B.fR],t.S)
B.l0=s([255,254,252,255,255,255,255,255,255,255,255],t.t)
B.fD=s([248,254,253,255,255,255,255,255,255,255,255],t.t)
B.eR=s([253,255,254,254,255,255,255,255,255,255,255],t.t)
B.iN=s([B.l0,B.fD,B.eR],t.S)
B.kS=s([255,251,254,255,255,255,255,255,255,255,255],t.t)
B.ii=s([245,251,254,255,255,255,255,255,255,255,255],t.t)
B.il=s([253,253,254,255,255,255,255,255,255,255,255],t.t)
B.fa=s([B.kS,B.ii,B.il],t.S)
B.fc=s([255,251,253,255,255,255,255,255,255,255,255],t.t)
B.hy=s([252,253,254,255,255,255,255,255,255,255,255],t.t)
B.jH=s([B.fc,B.hy,B.aW],t.S)
B.eN=s([255,252,255,255,255,255,255,255,255,255,255],t.t)
B.kP=s([249,255,254,255,255,255,255,255,255,255,255],t.t)
B.h2=s([255,255,254,255,255,255,255,255,255,255,255],t.t)
B.dT=s([B.eN,B.kP,B.h2],t.S)
B.l3=s([255,255,253,255,255,255,255,255,255,255,255],t.t)
B.fJ=s([B.l3,B.bR,B.y],t.S)
B.eQ=s([B.hF,B.ka,B.iN,B.fa,B.jH,B.dT,B.fJ,B.ce],t.o)
B.jZ=s([B.hc,B.ep,B.en,B.eQ],t.hc)
B.cK=new A.al(1,"rle8")
B.cP=new A.al(2,"rle4")
B.cQ=new A.al(4,"jpeg")
B.cR=new A.al(5,"png")
B.cS=new A.al(7,"reserved7")
B.cT=new A.al(8,"reserved8")
B.cU=new A.al(9,"reserved9")
B.cL=new A.al(10,"reserved10")
B.cM=new A.al(11,"cmyk")
B.cN=new A.al(12,"cmykRle8")
B.cO=new A.al(13,"cmykRle4")
B.az=s([B.aG,B.cK,B.cP,B.af,B.cQ,B.cR,B.aH,B.cS,B.cT,B.cU,B.cL,B.cM,B.cN,B.cO],A.T("q<al>"))
B.Z=s([0,128,192,224,240,248,252,254,255],t.t)
B.c8=s([137,80,78,71,13,10,26,10],t.t)
B.a7=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535,131071,262143,524287,1048575,2097151,4194303,8388607,16777215,33554431,67108863,134217727,268435455,536870911,1073741823,2147483647,4294967295],t.t)
B.c9=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.ca=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.cF=new A.cU(0,"predictor")
B.m8=new A.cU(1,"crossColor")
B.m9=new A.cU(2,"subtractGreen")
B.cG=new A.cU(3,"colorIndexing")
B.cc=s([B.cF,B.m8,B.m9,B.cG],A.T("q<cU>"))
B.z=s([0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255],t.t)
B.kA=s([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
B.cf=s([A.wq(),A.wk(),A.wA(),A.wy(),A.ws(),A.wr(),A.wt()],t.B)
B.cg=s([0,4,8,12,128,132,136,140,256,260,264,268,384,388,392,396],t.t)
B.ch=s([null,A.wQ(),A.wR(),A.wP()],A.T("q<~(h,h,h,h,h,b7)?>"))
B.cH=new A.fv(0,"shrinkImage")
B.cI=new A.fv(1,"calcImageMetadata")
B.ci=s([B.cH,B.cI],A.T("q<fv>"))
B.aA=s([0,36,72,109,145,182,218,255],t.t)
B.t=s([0,8,16,24,32,41,49,57,65,74,82,90,98,106,115,123,131,139,148,156,164,172,180,189,197,205,213,222,230,238,246,255],t.t)
B.kO=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.lm=new A.bk(0,"bitmap")
B.cw=new A.bk(1,"grayscale")
B.ln=new A.bk(2,"indexed")
B.cx=new A.bk(3,"rgb")
B.cy=new A.bk(4,"cmyk")
B.lo=new A.bk(5,"multiChannel")
B.lp=new A.bk(6,"duoTone")
B.cz=new A.bk(7,"lab")
B.cj=s([B.lm,B.cw,B.ln,B.cx,B.cy,B.lo,B.lp,B.cz],A.T("q<bk>"))
B.kW=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.ck=s([0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0],t.t)
B.e6=s([2,6,2,6],t.t)
B.eO=s([6,2,6,2],t.t)
B.e5=s([2,2,6,6],t.t)
B.dZ=s([1,3,3,9],t.t)
B.eq=s([4,0,12,0],t.t)
B.ee=s([3,1,9,3],t.t)
B.f6=s([8,8,0,0],t.t)
B.er=s([4,12,0,0],t.t)
B.dW=s([16,0,0,0],t.t)
B.dS=s([12,4,0,0],t.t)
B.eP=s([6,6,2,2],t.t)
B.eh=s([3,9,1,3],t.t)
B.dR=s([12,0,4,0],t.t)
B.fd=s([9,3,3,1],t.t)
B.h=s([B.bx,B.e6,B.aQ,B.eO,B.e5,B.dZ,B.eq,B.ee,B.f6,B.er,B.dW,B.dS,B.eP,B.eh,B.dR,B.fd],t.S)
B.a0=s([0,-128,64,-64,32,-96,96,-32,16,-112,80,-48,48,-80,112,-16,8,-120,72,-56,40,-88,104,-24,24,-104,88,-40,56,-72,120,-8,4,-124,68,-60,36,-92,100,-28,20,-108,84,-44,52,-76,116,-12,12,-116,76,-52,44,-84,108,-20,28,-100,92,-36,60,-68,124,-4,2,-126,66,-62,34,-94,98,-30,18,-110,82,-46,50,-78,114,-14,10,-118,74,-54,42,-86,106,-22,26,-102,90,-38,58,-70,122,-6,6,-122,70,-58,38,-90,102,-26,22,-106,86,-42,54,-74,118,-10,14,-114,78,-50,46,-82,110,-18,30,-98,94,-34,62,-66,126,-2,1,-127,65,-63,33,-95,97,-31,17,-111,81,-47,49,-79,113,-15,9,-119,73,-55,41,-87,105,-23,25,-103,89,-39,57,-71,121,-7,5,-123,69,-59,37,-91,101,-27,21,-107,85,-43,53,-75,117,-11,13,-115,77,-51,45,-83,109,-19,29,-99,93,-35,61,-67,125,-3,3,-125,67,-61,35,-93,99,-29,19,-109,83,-45,51,-77,115,-13,11,-117,75,-53,43,-85,107,-21,27,-101,91,-37,59,-69,123,-5,7,-121,71,-57,39,-89,103,-25,23,-105,87,-41,55,-73,119,-9,15,-113,79,-49,47,-81,111,-17,31,-97,95,-33,63,-65,127,-1],t.t)
B.ld={ProcessingSoftware:0,SubfileType:1,OldSubfileType:2,ImageWidth:3,ImageLength:4,ImageHeight:5,BitsPerSample:6,Compression:7,PhotometricInterpretation:8,Thresholding:9,CellWidth:10,CellLength:11,FillOrder:12,DocumentName:13,ImageDescription:14,Make:15,Model:16,StripOffsets:17,Orientation:18,SamplesPerPixel:19,RowsPerStrip:20,StripByteCounts:21,MinSampleValue:22,MaxSampleValue:23,XResolution:24,YResolution:25,PlanarConfiguration:26,PageName:27,XPosition:28,YPosition:29,GrayResponseUnit:30,GrayResponseCurve:31,T4Options:32,T6Options:33,ResolutionUnit:34,PageNumber:35,ColorResponseUnit:36,TransferFunction:37,Software:38,DateTime:39,Artist:40,HostComputer:41,Predictor:42,WhitePoint:43,PrimaryChromaticities:44,ColorMap:45,HalftoneHints:46,TileWidth:47,TileLength:48,TileOffsets:49,TileByteCounts:50,BadFaxLines:51,CleanFaxData:52,ConsecutiveBadFaxLines:53,InkSet:54,InkNames:55,NumberofInks:56,DotRange:57,TargetPrinter:58,ExtraSamples:59,SampleFormat:60,SMinSampleValue:61,SMaxSampleValue:62,TransferRange:63,ClipPath:64,JPEGProc:65,JPEGInterchangeFormat:66,JPEGInterchangeFormatLength:67,YCbCrCoefficients:68,YCbCrSubSampling:69,YCbCrPositioning:70,ReferenceBlackWhite:71,ApplicationNotes:72,Rating:73,CFARepeatPatternDim:74,CFAPattern:75,BatteryLevel:76,Copyright:77,ExposureTime:78,FNumber:79,"IPTC-NAA":80,ExifOffset:81,InterColorProfile:82,ExposureProgram:83,SpectralSensitivity:84,GPSOffset:85,ISOSpeed:86,OECF:87,SensitivityType:88,RecommendedExposureIndex:89,ExifVersion:90,DateTimeOriginal:91,DateTimeDigitized:92,OffsetTime:93,OffsetTimeOriginal:94,OffsetTimeDigitized:95,ComponentsConfiguration:96,CompressedBitsPerPixel:97,ShutterSpeedValue:98,ApertureValue:99,BrightnessValue:100,ExposureBiasValue:101,MaxApertureValue:102,SubjectDistance:103,MeteringMode:104,LightSource:105,Flash:106,FocalLength:107,SubjectArea:108,MakerNote:109,UserComment:110,SubSecTime:111,SubSecTimeOriginal:112,SubSecTimeDigitized:113,XPTitle:114,XPComment:115,XPAuthor:116,XPKeywords:117,XPSubject:118,FlashPixVersion:119,ColorSpace:120,ExifImageWidth:121,ExifImageLength:122,RelatedSoundFile:123,InteroperabilityOffset:124,FlashEnergy:125,SpatialFrequencyResponse:126,FocalPlaneXResolution:127,FocalPlaneYResolution:128,FocalPlaneResolutionUnit:129,SubjectLocation:130,ExposureIndex:131,SensingMethod:132,FileSource:133,SceneType:134,CVAPattern:135,CustomRendered:136,ExposureMode:137,WhiteBalance:138,DigitalZoomRatio:139,FocalLengthIn35mmFilm:140,SceneCaptureType:141,GainControl:142,Contrast:143,Saturation:144,Sharpness:145,DeviceSettingDescription:146,SubjectDistanceRange:147,ImageUniqueID:148,CameraOwnerName:149,BodySerialNumber:150,LensSpecification:151,LensMake:152,LensModel:153,LensSerialNumber:154,Gamma:155,PrintIM:156,Padding:157,OffsetSchema:158,OwnerName:159,SerialNumber:160,InteropIndex:161,InteropVersion:162,RelatedImageFileFormat:163,RelatedImageWidth:164,RelatedImageLength:165,GPSVersionID:166,GPSLatitudeRef:167,GPSLatitude:168,GPSLongitudeRef:169,GPSLongitude:170,GPSAltitudeRef:171,GPSAltitude:172,GPSTimeStamp:173,GPSSatellites:174,GPSStatus:175,GPSMeasureMode:176,GPSDOP:177,GPSSpeedRef:178,GPSSpeed:179,GPSTrackRef:180,GPSTrack:181,GPSImgDirectionRef:182,GPSImgDirection:183,GPSMapDatum:184,GPSDestLatitudeRef:185,GPSDestLatitude:186,GPSDestLongitudeRef:187,GPSDestLongitude:188,GPSDestBearingRef:189,GPSDestBearing:190,GPSDestDistanceRef:191,GPSDestDistance:192,GPSProcessingMethod:193,GPSAreaInformation:194,GPSDate:195,GPSDifferential:196}
B.l8=new A.di(B.ld,[11,254,255,256,257,257,258,259,262,263,264,265,266,269,270,271,272,273,274,277,278,279,280,281,282,283,284,285,286,287,290,291,292,293,296,297,300,301,305,306,315,316,317,318,319,320,321,322,323,324,325,326,327,328,332,333,334,336,337,338,339,340,341,342,343,512,513,514,529,530,531,532,700,18246,33421,33422,33423,33432,33434,33437,33723,34665,34675,34850,34852,34853,34855,34856,34864,34866,36864,36867,36868,36880,36881,36882,37121,37122,37377,37378,37379,37380,37381,37382,37383,37384,37385,37386,37396,37500,37510,37520,37521,37522,40091,40092,40093,40094,40095,40960,40961,40962,40963,40964,40965,41483,41484,41486,41487,41488,41492,41493,41495,41728,41729,41730,41985,41986,41987,41988,41989,41990,41991,41992,41993,41994,41995,41996,42016,42032,42033,42034,42035,42036,42037,42240,50341,59932,59933,65e3,65001,1,2,4096,4097,4098,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30],t.e)
B.lc={"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,A:10,B:11,C:12,D:13,E:14,F:15,G:16,H:17,I:18,J:19,K:20,L:21,M:22,N:23,O:24,P:25,Q:26,R:27,S:28,T:29,U:30,V:31,W:32,X:33,Y:34,Z:35,a:36,b:37,c:38,d:39,e:40,f:41,g:42,h:43,i:44,j:45,k:46,l:47,m:48,n:49,o:50,p:51,q:52,r:53,s:54,t:55,u:56,v:57,w:58,x:59,y:60,z:61,"#":62,$:63,"%":64,"*":65,"+":66,",":67,"-":68,".":69,":":70,";":71,"=":72,"?":73,"@":74,"[":75,"]":76,"^":77,_:78,"{":79,"|":80,"}":81,"~":82}
B.l9=new A.di(B.lc,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82],t.e)
B.la=new A.aO(["ez","application/andrew-inset","aw","application/applixware","atom","application/atom+xml","atomcat","application/atomcat+xml","atomsvc","application/atomsvc+xml","ccxml","application/ccxml+xml","cdmia","application/cdmi-capability","cdmic","application/cdmi-container","cdmid","application/cdmi-domain","cdmio","application/cdmi-object","cdmiq","application/cdmi-queue","cu","application/cu-seeme","davmount","application/davmount+xml","dcm","application/dicom","dbk","application/docbook+xml","dssc","application/dssc+der","xdssc","application/dssc+xml","ecma","application/ecmascript","emma","application/emma+xml","epub","application/epub+zip","exi","application/exi","pfr","application/font-tdpfr","gml","application/gml+xml","gpx","application/gpx+xml","gxf","application/gxf","stk","application/hyperstudio","ink","application/inkml+xml","inkml","application/inkml+xml","ipfix","application/ipfix","jar","application/java-archive","ser","application/java-serialized-object","class","application/java-vm","json","application/json","jsonml","application/jsonml+json","lostxml","application/lost+xml","hqx","application/mac-binhex40","cpt","application/mac-compactpro","mads","application/mads+xml","webmanifest","application/manifest+json","mrc","application/marc","mrcx","application/marcxml+xml","nb","application/mathematica","ma","application/mathematica","mb","application/mathematica","mathml","application/mathml+xml","mbox","application/mbox","mscml","application/mediaservercontrol+xml","metalink","application/metalink+xml","meta4","application/metalink4+xml","mets","application/mets+xml","mods","application/mods+xml","mp21","application/mp21","m21","application/mp21","mp4s","application/mp4","doc","application/msword","dot","application/msword","mxf","application/mxf","bin","application/octet-stream","bpk","application/octet-stream","deploy","application/octet-stream","dist","application/octet-stream","distz","application/octet-stream","dms","application/octet-stream","dump","application/octet-stream","elc","application/octet-stream","lrf","application/octet-stream","mar","application/octet-stream","pkg","application/octet-stream","so","application/octet-stream","oda","application/oda","opf","application/oebps-package+xml","ogx","application/ogg","omdoc","application/omdoc+xml","onetoc","application/onenote","onepkg","application/onenote","onetmp","application/onenote","onetoc2","application/onenote","oxps","application/oxps","xer","application/patch-ops-error+xml","pdf","application/pdf","pgp","application/pgp-encrypted","asc","application/pgp-signature","sig","application/pgp-signature","prf","application/pics-rules","p10","application/pkcs10","p7m","application/pkcs7-mime","p7c","application/pkcs7-mime","p7s","application/pkcs7-signature","p8","application/pkcs8","ac","application/pkix-attr-cert","cer","application/pkix-cert","crl","application/pkix-crl","pkipath","application/pkix-pkipath","pki","application/pkixcmp","pls","application/pls+xml","ps","application/postscript","ai","application/postscript","eps","application/postscript","cww","application/prs.cww","pskcxml","application/pskc+xml","rdf","application/rdf+xml","rif","application/reginfo+xml","rnc","application/relax-ng-compact-syntax","rl","application/resource-lists+xml","rld","application/resource-lists-diff+xml","rs","application/rls-services+xml","gbr","application/rpki-ghostbusters","mft","application/rpki-manifest","roa","application/rpki-roa","rsd","application/rsd+xml","rss","application/rss+xml","rtf","application/rtf","sbml","application/sbml+xml","scq","application/scvp-cv-request","scs","application/scvp-cv-response","spq","application/scvp-vp-request","spp","application/scvp-vp-response","sdp","application/sdp","setpay","application/set-payment-initiation","setreg","application/set-registration-initiation","shf","application/shf+xml","smil","application/smil+xml","smi","application/smil+xml","rq","application/sparql-query","srx","application/sparql-results+xml","gram","application/srgs","grxml","application/srgs+xml","sru","application/sru+xml","ssdl","application/ssdl+xml","ssml","application/ssml+xml","tei","application/tei+xml","teicorpus","application/tei+xml","tfi","application/thraud+xml","tsd","application/timestamped-data","toml","application/toml","plb","application/vnd.3gpp.pic-bw-large","psb","application/vnd.3gpp.pic-bw-small","pvb","application/vnd.3gpp.pic-bw-var","tcap","application/vnd.3gpp2.tcap","pwn","application/vnd.3m.post-it-notes","aso","application/vnd.accpac.simply.aso","imp","application/vnd.accpac.simply.imp","acu","application/vnd.acucobol","atc","application/vnd.acucorp","acutc","application/vnd.acucorp","air","application/vnd.adobe.air-application-installer-package+zip","fcdt","application/vnd.adobe.formscentral.fcdt","fxp","application/vnd.adobe.fxp","fxpl","application/vnd.adobe.fxp","xdp","application/vnd.adobe.xdp+xml","xfdf","application/vnd.adobe.xfdf","ahead","application/vnd.ahead.space","azf","application/vnd.airzip.filesecure.azf","azs","application/vnd.airzip.filesecure.azs","azw","application/vnd.amazon.ebook","acc","application/vnd.americandynamics.acc","ami","application/vnd.amiga.ami","apk","application/vnd.android.package-archive","cii","application/vnd.anser-web-certificate-issue-initiation","fti","application/vnd.anser-web-funds-transfer-initiation","atx","application/vnd.antix.game-component","mpkg","application/vnd.apple.installer+xml","m3u8","application/vnd.apple.mpegurl","swi","application/vnd.aristanetworks.swi","iota","application/vnd.astraea-software.iota","aep","application/vnd.audiograph","mpm","application/vnd.blueice.multipass","bmi","application/vnd.bmi","rep","application/vnd.businessobjects","cdxml","application/vnd.chemdraw+xml","mmd","application/vnd.chipnuts.karaoke-mmd","cdy","application/vnd.cinderella","cla","application/vnd.claymore","rp9","application/vnd.cloanto.rp9","c4g","application/vnd.clonk.c4group","c4d","application/vnd.clonk.c4group","c4f","application/vnd.clonk.c4group","c4p","application/vnd.clonk.c4group","c4u","application/vnd.clonk.c4group","c11amc","application/vnd.cluetrust.cartomobile-config","c11amz","application/vnd.cluetrust.cartomobile-config-pkg","csp","application/vnd.commonspace","cdbcmsg","application/vnd.contact.cmsg","cmc","application/vnd.cosmocaller","clkx","application/vnd.crick.clicker","clkk","application/vnd.crick.clicker.keyboard","clkp","application/vnd.crick.clicker.palette","clkt","application/vnd.crick.clicker.template","clkw","application/vnd.crick.clicker.wordbank","wbs","application/vnd.criticaltools.wbs+xml","pml","application/vnd.ctc-posml","ppd","application/vnd.cups-ppd","car","application/vnd.curl.car","pcurl","application/vnd.curl.pcurl","rdz","application/vnd.data-vision.rdz","uvf","application/vnd.dece.data","uvd","application/vnd.dece.data","uvvd","application/vnd.dece.data","uvvf","application/vnd.dece.data","uvt","application/vnd.dece.ttml+xml","uvvt","application/vnd.dece.ttml+xml","uvx","application/vnd.dece.unspecified","uvvx","application/vnd.dece.unspecified","uvz","application/vnd.dece.zip","uvvz","application/vnd.dece.zip","fe_launch","application/vnd.denovo.fcselayout-link","dna","application/vnd.dna","mlp","application/vnd.dolby.mlp","dpg","application/vnd.dpgraph","dfac","application/vnd.dreamfactory","kpxx","application/vnd.ds-keypoint","ait","application/vnd.dvb.ait","svc","application/vnd.dvb.service","geo","application/vnd.dynageo","mag","application/vnd.ecowin.chart","nml","application/vnd.enliven","esf","application/vnd.epson.esf","msf","application/vnd.epson.msf","qam","application/vnd.epson.quickanime","slt","application/vnd.epson.salt","ssf","application/vnd.epson.ssf","es3","application/vnd.eszigno3+xml","et3","application/vnd.eszigno3+xml","ez2","application/vnd.ezpix-album","ez3","application/vnd.ezpix-package","fdf","application/vnd.fdf","mseed","application/vnd.fdsn.mseed","seed","application/vnd.fdsn.seed","dataless","application/vnd.fdsn.seed","gph","application/vnd.flographit","ftc","application/vnd.fluxtime.clip","fm","application/vnd.framemaker","book","application/vnd.framemaker","frame","application/vnd.framemaker","maker","application/vnd.framemaker","fnc","application/vnd.frogans.fnc","ltf","application/vnd.frogans.ltf","fsc","application/vnd.fsc.weblaunch","oas","application/vnd.fujitsu.oasys","oa2","application/vnd.fujitsu.oasys2","oa3","application/vnd.fujitsu.oasys3","fg5","application/vnd.fujitsu.oasysgp","bh2","application/vnd.fujitsu.oasysprs","ddd","application/vnd.fujixerox.ddd","xdw","application/vnd.fujixerox.docuworks","xbd","application/vnd.fujixerox.docuworks.binder","fzs","application/vnd.fuzzysheet","txd","application/vnd.genomatix.tuxedo","ggb","application/vnd.geogebra.file","ggs","application/vnd.geogebra.slides","ggt","application/vnd.geogebra.tool","gex","application/vnd.geometry-explorer","gre","application/vnd.geometry-explorer","gxt","application/vnd.geonext","g2w","application/vnd.geoplan","g3w","application/vnd.geospace","gmx","application/vnd.gmx","kml","application/vnd.google-earth.kml+xml","kmz","application/vnd.google-earth.kmz","gqf","application/vnd.grafeq","gqs","application/vnd.grafeq","gac","application/vnd.groove-account","ghf","application/vnd.groove-help","gim","application/vnd.groove-identity-message","grv","application/vnd.groove-injector","gtm","application/vnd.groove-tool-message","tpl","application/vnd.groove-tool-template","vcg","application/vnd.groove-vcard","hal","application/vnd.hal+xml","zmm","application/vnd.handheld-entertainment+xml","hbci","application/vnd.hbci","les","application/vnd.hhe.lesson-player","hpgl","application/vnd.hp-hpgl","hpid","application/vnd.hp-hpid","hps","application/vnd.hp-hps","jlt","application/vnd.hp-jlyt","pcl","application/vnd.hp-pcl","pclxl","application/vnd.hp-pclxl","sfd-hdstx","application/vnd.hydrostatix.sof-data","mpy","application/vnd.ibm.minipay","afp","application/vnd.ibm.modcap","list3820","application/vnd.ibm.modcap","listafp","application/vnd.ibm.modcap","irm","application/vnd.ibm.rights-management","sc","application/vnd.ibm.secure-container","icc","application/vnd.iccprofile","icm","application/vnd.iccprofile","igl","application/vnd.igloader","ivp","application/vnd.immervision-ivp","ivu","application/vnd.immervision-ivu","igm","application/vnd.insors.igm","xpw","application/vnd.intercon.formnet","xpx","application/vnd.intercon.formnet","i2g","application/vnd.intergeo","qbo","application/vnd.intu.qbo","qfx","application/vnd.intu.qfx","rcprofile","application/vnd.ipunplugged.rcprofile","irp","application/vnd.irepository.package+xml","xpr","application/vnd.is-xpr","fcs","application/vnd.isac.fcs","jam","application/vnd.jam","rms","application/vnd.jcp.javame.midlet-rms","jisp","application/vnd.jisp","joda","application/vnd.joost.joda-archive","ktz","application/vnd.kahootz","ktr","application/vnd.kahootz","karbon","application/vnd.kde.karbon","chrt","application/vnd.kde.kchart","kfo","application/vnd.kde.kformula","flw","application/vnd.kde.kivio","kon","application/vnd.kde.kontour","kpr","application/vnd.kde.kpresenter","kpt","application/vnd.kde.kpresenter","ksp","application/vnd.kde.kspread","kwd","application/vnd.kde.kword","kwt","application/vnd.kde.kword","htke","application/vnd.kenameaapp","kia","application/vnd.kidspiration","kne","application/vnd.kinar","knp","application/vnd.kinar","skp","application/vnd.koan","skd","application/vnd.koan","skm","application/vnd.koan","skt","application/vnd.koan","sse","application/vnd.kodak-descriptor","lasxml","application/vnd.las.las+xml","lbd","application/vnd.llamagraphics.life-balance.desktop","lbe","application/vnd.llamagraphics.life-balance.exchange+xml","123","application/vnd.lotus-1-2-3","apr","application/vnd.lotus-approach","pre","application/vnd.lotus-freelance","nsf","application/vnd.lotus-notes","org","application/vnd.lotus-organizer","scm","application/vnd.lotus-screencam","lwp","application/vnd.lotus-wordpro","portpkg","application/vnd.macports.portpkg","mcd","application/vnd.mcd","mc1","application/vnd.medcalcdata","cdkey","application/vnd.mediastation.cdkey","mwf","application/vnd.mfer","mfm","application/vnd.mfmp","flo","application/vnd.micrografx.flo","igx","application/vnd.micrografx.igx","mif","application/vnd.mif","daf","application/vnd.mobius.daf","dis","application/vnd.mobius.dis","mbk","application/vnd.mobius.mbk","mqy","application/vnd.mobius.mqy","msl","application/vnd.mobius.msl","plc","application/vnd.mobius.plc","txf","application/vnd.mobius.txf","mpn","application/vnd.mophun.application","mpc","application/vnd.mophun.certificate","xul","application/vnd.mozilla.xul+xml","cil","application/vnd.ms-artgalry","cab","application/vnd.ms-cab-compressed","xls","application/vnd.ms-excel","xla","application/vnd.ms-excel","xlc","application/vnd.ms-excel","xlm","application/vnd.ms-excel","xlt","application/vnd.ms-excel","xlw","application/vnd.ms-excel","xlam","application/vnd.ms-excel.addin.macroenabled.12","xlsb","application/vnd.ms-excel.sheet.binary.macroenabled.12","xlsm","application/vnd.ms-excel.sheet.macroenabled.12","xltm","application/vnd.ms-excel.template.macroenabled.12","eot","application/vnd.ms-fontobject","chm","application/vnd.ms-htmlhelp","ims","application/vnd.ms-ims","lrm","application/vnd.ms-lrm","thmx","application/vnd.ms-officetheme","cat","application/vnd.ms-pki.seccat","stl","application/vnd.ms-pki.stl","ppt","application/vnd.ms-powerpoint","pot","application/vnd.ms-powerpoint","pps","application/vnd.ms-powerpoint","ppam","application/vnd.ms-powerpoint.addin.macroenabled.12","pptm","application/vnd.ms-powerpoint.presentation.macroenabled.12","sldm","application/vnd.ms-powerpoint.slide.macroenabled.12","ppsm","application/vnd.ms-powerpoint.slideshow.macroenabled.12","potm","application/vnd.ms-powerpoint.template.macroenabled.12","mpp","application/vnd.ms-project","mpt","application/vnd.ms-project","docm","application/vnd.ms-word.document.macroenabled.12","dotm","application/vnd.ms-word.template.macroenabled.12","wps","application/vnd.ms-works","wcm","application/vnd.ms-works","wdb","application/vnd.ms-works","wks","application/vnd.ms-works","wpl","application/vnd.ms-wpl","xps","application/vnd.ms-xpsdocument","mseq","application/vnd.mseq","mus","application/vnd.musician","msty","application/vnd.muvee.style","taglet","application/vnd.mynfc","nlu","application/vnd.neurolanguage.nlu","ntf","application/vnd.nitf","nitf","application/vnd.nitf","nnd","application/vnd.noblenet-directory","nns","application/vnd.noblenet-sealer","nnw","application/vnd.noblenet-web","ngdat","application/vnd.nokia.n-gage.data","n-gage","application/vnd.nokia.n-gage.symbian.install","rpst","application/vnd.nokia.radio-preset","rpss","application/vnd.nokia.radio-presets","edm","application/vnd.novadigm.edm","edx","application/vnd.novadigm.edx","ext","application/vnd.novadigm.ext","odc","application/vnd.oasis.opendocument.chart","otc","application/vnd.oasis.opendocument.chart-template","odb","application/vnd.oasis.opendocument.database","odf","application/vnd.oasis.opendocument.formula","odft","application/vnd.oasis.opendocument.formula-template","odg","application/vnd.oasis.opendocument.graphics","otg","application/vnd.oasis.opendocument.graphics-template","odi","application/vnd.oasis.opendocument.image","oti","application/vnd.oasis.opendocument.image-template","odp","application/vnd.oasis.opendocument.presentation","otp","application/vnd.oasis.opendocument.presentation-template","ods","application/vnd.oasis.opendocument.spreadsheet","ots","application/vnd.oasis.opendocument.spreadsheet-template","odt","application/vnd.oasis.opendocument.text","odm","application/vnd.oasis.opendocument.text-master","ott","application/vnd.oasis.opendocument.text-template","oth","application/vnd.oasis.opendocument.text-web","xo","application/vnd.olpc-sugar","dd2","application/vnd.oma.dd2+xml","oxt","application/vnd.openofficeorg.extension","pptx","application/vnd.openxmlformats-officedocument.presentationml.presentation","sldx","application/vnd.openxmlformats-officedocument.presentationml.slide","ppsx","application/vnd.openxmlformats-officedocument.presentationml.slideshow","potx","application/vnd.openxmlformats-officedocument.presentationml.template","xlsx","application/vnd.openxmlformats-officedocument.spreadsheetml.sheet","xltx","application/vnd.openxmlformats-officedocument.spreadsheetml.template","docx","application/vnd.openxmlformats-officedocument.wordprocessingml.document","dotx","application/vnd.openxmlformats-officedocument.wordprocessingml.template","mgp","application/vnd.osgeo.mapguide.package","dp","application/vnd.osgi.dp","esa","application/vnd.osgi.subsystem","pdb","application/vnd.palm","oprc","application/vnd.palm","pqa","application/vnd.palm","paw","application/vnd.pawaafile","str","application/vnd.pg.format","ei6","application/vnd.pg.osasli","efif","application/vnd.picsel","wg","application/vnd.pmi.widget","plf","application/vnd.pocketlearn","pbd","application/vnd.powerbuilder6","box","application/vnd.previewsystems.box","mgz","application/vnd.proteus.magazine","qps","application/vnd.publishare-delta-tree","ptid","application/vnd.pvi.ptid1","qxd","application/vnd.quark.quarkxpress","qwd","application/vnd.quark.quarkxpress","qwt","application/vnd.quark.quarkxpress","qxb","application/vnd.quark.quarkxpress","qxl","application/vnd.quark.quarkxpress","qxt","application/vnd.quark.quarkxpress","bed","application/vnd.realvnc.bed","mxl","application/vnd.recordare.musicxml","musicxml","application/vnd.recordare.musicxml+xml","cryptonote","application/vnd.rig.cryptonote","cod","application/vnd.rim.cod","rm","application/vnd.rn-realmedia","rmvb","application/vnd.rn-realmedia-vbr","link66","application/vnd.route66.link66+xml","st","application/vnd.sailingtracker.track","see","application/vnd.seemail","sema","application/vnd.sema","semd","application/vnd.semd","semf","application/vnd.semf","ifm","application/vnd.shana.informed.formdata","itp","application/vnd.shana.informed.formtemplate","iif","application/vnd.shana.informed.interchange","ipk","application/vnd.shana.informed.package","twd","application/vnd.simtech-mindmapper","twds","application/vnd.simtech-mindmapper","mmf","application/vnd.smaf","teacher","application/vnd.smart.teacher","sdkm","application/vnd.solent.sdkm+xml","sdkd","application/vnd.solent.sdkm+xml","dxp","application/vnd.spotfire.dxp","sfs","application/vnd.spotfire.sfs","sdc","application/vnd.stardivision.calc","sda","application/vnd.stardivision.draw","sdd","application/vnd.stardivision.impress","smf","application/vnd.stardivision.math","sdw","application/vnd.stardivision.writer","vor","application/vnd.stardivision.writer","sgl","application/vnd.stardivision.writer-global","smzip","application/vnd.stepmania.package","sm","application/vnd.stepmania.stepchart","sxc","application/vnd.sun.xml.calc","stc","application/vnd.sun.xml.calc.template","sxd","application/vnd.sun.xml.draw","std","application/vnd.sun.xml.draw.template","sxi","application/vnd.sun.xml.impress","sti","application/vnd.sun.xml.impress.template","sxm","application/vnd.sun.xml.math","sxw","application/vnd.sun.xml.writer","sxg","application/vnd.sun.xml.writer.global","stw","application/vnd.sun.xml.writer.template","sus","application/vnd.sus-calendar","susp","application/vnd.sus-calendar","svd","application/vnd.svd","sis","application/vnd.symbian.install","sisx","application/vnd.symbian.install","xsm","application/vnd.syncml+xml","bdm","application/vnd.syncml.dm+wbxml","xdm","application/vnd.syncml.dm+xml","tao","application/vnd.tao.intent-module-archive","pcap","application/vnd.tcpdump.pcap","cap","application/vnd.tcpdump.pcap","dmp","application/vnd.tcpdump.pcap","tmo","application/vnd.tmobile-livetv","tpt","application/vnd.trid.tpt","mxs","application/vnd.triscape.mxs","tra","application/vnd.trueapp","ufd","application/vnd.ufdl","ufdl","application/vnd.ufdl","utz","application/vnd.uiq.theme","umj","application/vnd.umajin","unityweb","application/vnd.unity","uoml","application/vnd.uoml+xml","vcx","application/vnd.vcx","vsd","application/vnd.visio","vss","application/vnd.visio","vst","application/vnd.visio","vsw","application/vnd.visio","vis","application/vnd.visionary","vsf","application/vnd.vsf","wbxml","application/vnd.wap.wbxml","wmlc","application/vnd.wap.wmlc","wmlsc","application/vnd.wap.wmlscriptc","wtb","application/vnd.webturbo","nbp","application/vnd.wolfram.player","wpd","application/vnd.wordperfect","wqd","application/vnd.wqd","stf","application/vnd.wt.stf","xar","application/vnd.xara","xfdl","application/vnd.xfdl","hvd","application/vnd.yamaha.hv-dic","hvs","application/vnd.yamaha.hv-script","hvp","application/vnd.yamaha.hv-voice","osf","application/vnd.yamaha.openscoreformat","osfpvg","application/vnd.yamaha.openscoreformat.osfpvg+xml","saf","application/vnd.yamaha.smaf-audio","spf","application/vnd.yamaha.smaf-phrase","cmp","application/vnd.yellowriver-custom-menu","zir","application/vnd.zul","zirz","application/vnd.zul","zaz","application/vnd.zzazz.deck+xml","vxml","application/voicexml+xml","wasm","application/wasm","wgt","application/widget","hlp","application/winhlp","wsdl","application/wsdl+xml","wspolicy","application/wspolicy+xml","7z","application/x-7z-compressed","abw","application/x-abiword","ace","application/x-ace-compressed","dmg","application/x-apple-diskimage","aab","application/x-authorware-bin","u32","application/x-authorware-bin","vox","application/x-authorware-bin","x32","application/x-authorware-bin","aam","application/x-authorware-map","aas","application/x-authorware-seg","bcpio","application/x-bcpio","torrent","application/x-bittorrent","blb","application/x-blorb","blorb","application/x-blorb","bz","application/x-bzip","bz2","application/x-bzip2","boz","application/x-bzip2","cbr","application/x-cbr","cb7","application/x-cbr","cba","application/x-cbr","cbt","application/x-cbr","cbz","application/x-cbr","vcd","application/x-cdlink","cfs","application/x-cfs-compressed","chat","application/x-chat","pgn","application/x-chess-pgn","nsc","application/x-conference","cpio","application/x-cpio","csh","application/x-csh","deb","application/x-debian-package","udeb","application/x-debian-package","dgc","application/x-dgc-compressed","dir","application/x-director","cct","application/x-director","cst","application/x-director","cxt","application/x-director","dcr","application/x-director","dxr","application/x-director","fgd","application/x-director","swa","application/x-director","w3d","application/x-director","wad","application/x-doom","ncx","application/x-dtbncx+xml","dtb","application/x-dtbook+xml","res","application/x-dtbresource+xml","dvi","application/x-dvi","evy","application/x-envoy","eva","application/x-eva","bdf","application/x-font-bdf","gsf","application/x-font-ghostscript","psf","application/x-font-linux-psf","pcf","application/x-font-pcf","snf","application/x-font-snf","pfa","application/x-font-type1","afm","application/x-font-type1","pfb","application/x-font-type1","pfm","application/x-font-type1","arc","application/x-freearc","spl","application/x-futuresplash","gca","application/x-gca-compressed","ulx","application/x-glulx","gnumeric","application/x-gnumeric","gramps","application/x-gramps-xml","gtar","application/x-gtar","hdf","application/x-hdf","install","application/x-install-instructions","iso","application/x-iso9660-image","jnlp","application/x-java-jnlp-file","latex","application/x-latex","lzh","application/x-lzh-compressed","lha","application/x-lzh-compressed","mie","application/x-mie","prc","application/x-mobipocket-ebook","mobi","application/x-mobipocket-ebook","application","application/x-ms-application","lnk","application/x-ms-shortcut","wmd","application/x-ms-wmd","wmz","application/x-ms-wmz","xbap","application/x-ms-xbap","mdb","application/x-msaccess","obd","application/x-msbinder","crd","application/x-mscardfile","clp","application/x-msclip","exe","application/x-msdownload","bat","application/x-msdownload","com","application/x-msdownload","dll","application/x-msdownload","msi","application/x-msdownload","mvb","application/x-msmediaview","m13","application/x-msmediaview","m14","application/x-msmediaview","wmf","application/x-msmetafile","emf","application/x-msmetafile","emz","application/x-msmetafile","mny","application/x-msmoney","pub","application/x-mspublisher","scd","application/x-msschedule","trm","application/x-msterminal","wri","application/x-mswrite","nc","application/x-netcdf","cdf","application/x-netcdf","nzb","application/x-nzb","p12","application/x-pkcs12","pfx","application/x-pkcs12","p7b","application/x-pkcs7-certificates","spc","application/x-pkcs7-certificates","p7r","application/x-pkcs7-certreqresp","rar","application/x-rar-compressed","ris","application/x-research-info-systems","sh","application/x-sh","shar","application/x-shar","swf","application/x-shockwave-flash","xap","application/x-silverlight-app","sql","application/x-sql","sit","application/x-stuffit","sitx","application/x-stuffitx","srt","application/x-subrip","sv4cpio","application/x-sv4cpio","sv4crc","application/x-sv4crc","t3","application/x-t3vm-image","gam","application/x-tads","tar","application/x-tar","tcl","application/x-tcl","tex","application/x-tex","tfm","application/x-tex-tfm","texinfo","application/x-texinfo","texi","application/x-texinfo","obj","application/x-tgif","ustar","application/x-ustar","src","application/x-wais-source","der","application/x-x509-ca-cert","crt","application/x-x509-ca-cert","fig","application/x-xfig","xlf","application/x-xliff+xml","xpi","application/x-xpinstall","xz","application/x-xz","z1","application/x-zmachine","z2","application/x-zmachine","z3","application/x-zmachine","z4","application/x-zmachine","z5","application/x-zmachine","z6","application/x-zmachine","z7","application/x-zmachine","z8","application/x-zmachine","xaml","application/xaml+xml","xdf","application/xcap-diff+xml","xenc","application/xenc+xml","xhtml","application/xhtml+xml","xht","application/xhtml+xml","xml","application/xml","xsl","application/xml","dtd","application/xml-dtd","xop","application/xop+xml","xpl","application/xproc+xml","xslt","application/xslt+xml","xspf","application/xspf+xml","mxml","application/xv+xml","xhvml","application/xv+xml","xvm","application/xv+xml","xvml","application/xv+xml","yang","application/yang","yin","application/yin+xml","zip","application/zip","aac","audio/aac","adp","audio/adpcm","au","audio/basic","snd","audio/basic","mid","audio/midi","kar","audio/midi","midi","audio/midi","rmi","audio/midi","m4a","audio/mp4","mp4a","audio/mp4","mp3","audio/mpeg","m2a","audio/mpeg","m3a","audio/mpeg","mp2","audio/mpeg","mp2a","audio/mpeg","mpga","audio/mpeg","ogg","audio/ogg","oga","audio/ogg","opus","audio/ogg","spx","audio/ogg","s3m","audio/s3m","sil","audio/silk","uva","audio/vnd.dece.audio","uvva","audio/vnd.dece.audio","eol","audio/vnd.digital-winds","dra","audio/vnd.dra","dts","audio/vnd.dts","dtshd","audio/vnd.dts.hd","lvp","audio/vnd.lucent.voice","pya","audio/vnd.ms-playready.media.pya","ecelp4800","audio/vnd.nuera.ecelp4800","ecelp7470","audio/vnd.nuera.ecelp7470","ecelp9600","audio/vnd.nuera.ecelp9600","rip","audio/vnd.rip","weba","audio/webm","aif","audio/x-aiff","aifc","audio/x-aiff","aiff","audio/x-aiff","caf","audio/x-caf","flac","audio/x-flac","mka","audio/x-matroska","m3u","audio/x-mpegurl","wax","audio/x-ms-wax","wma","audio/x-ms-wma","ram","audio/x-pn-realaudio","ra","audio/x-pn-realaudio","rmp","audio/x-pn-realaudio-plugin","wav","audio/x-wav","xm","audio/xm","cdx","chemical/x-cdx","cif","chemical/x-cif","cmdf","chemical/x-cmdf","cml","chemical/x-cml","csml","chemical/x-csml","xyz","chemical/x-xyz","ttc","font/collection","otf","font/otf","ttf","font/ttf","woff","font/woff","woff2","font/woff2","avif","image/avif","bmp","image/bmp","cgm","image/cgm","g3","image/g3fax","gif","image/gif","heic","image/heic","heif","image/heif","ief","image/ief","jpg","image/jpeg","jpe","image/jpeg","jpeg","image/jpeg","jxl","image/jxl","ktx","image/ktx","png","image/png","btif","image/prs.btif","sgi","image/sgi","svg","image/svg+xml","svgz","image/svg+xml","tiff","image/tiff","tif","image/tiff","psd","image/vnd.adobe.photoshop","uvi","image/vnd.dece.graphic","uvg","image/vnd.dece.graphic","uvvg","image/vnd.dece.graphic","uvvi","image/vnd.dece.graphic","djvu","image/vnd.djvu","djv","image/vnd.djvu","sub","image/vnd.dvb.subtitle","dwg","image/vnd.dwg","dxf","image/vnd.dxf","fbs","image/vnd.fastbidsheet","fpx","image/vnd.fpx","fst","image/vnd.fst","mmr","image/vnd.fujixerox.edmics-mmr","rlc","image/vnd.fujixerox.edmics-rlc","mdi","image/vnd.ms-modi","wdp","image/vnd.ms-photo","npx","image/vnd.net-fpx","wbmp","image/vnd.wap.wbmp","xif","image/vnd.xiff","webp","image/webp","3ds","image/x-3ds","ras","image/x-cmu-raster","cmx","image/x-cmx","fh","image/x-freehand","fh4","image/x-freehand","fh5","image/x-freehand","fh7","image/x-freehand","fhc","image/x-freehand","ico","image/x-icon","sid","image/x-mrsid-image","pcx","image/x-pcx","pic","image/x-pict","pct","image/x-pict","pnm","image/x-portable-anymap","pbm","image/x-portable-bitmap","pgm","image/x-portable-graymap","ppm","image/x-portable-pixmap","rgb","image/x-rgb","tga","image/x-tga","xbm","image/x-xbitmap","xpm","image/x-xpixmap","xwd","image/x-xwindowdump","eml","message/rfc822","mime","message/rfc822","gltf","model/gltf+json","glb","model/gltf-binary","igs","model/iges","iges","model/iges","msh","model/mesh","mesh","model/mesh","silo","model/mesh","dae","model/vnd.collada+xml","dwf","model/vnd.dwf","gdl","model/vnd.gdl","gtw","model/vnd.gtw","vtu","model/vnd.vtu","vrml","model/vrml","wrl","model/vrml","x3db","model/x3d+binary","x3dbz","model/x3d+binary","x3dv","model/x3d+vrml","x3dvz","model/x3d+vrml","x3d","model/x3d+xml","x3dz","model/x3d+xml","appcache","text/cache-manifest","ics","text/calendar","ifb","text/calendar","css","text/css","csv","text/csv","html","text/html","htm","text/html","js","text/javascript","mjs","text/javascript","md","text/markdown","markdown","text/markdown","n3","text/n3","txt","text/plain","conf","text/plain","def","text/plain","in","text/plain","list","text/plain","log","text/plain","text","text/plain","dsc","text/prs.lines.tag","rtx","text/richtext","sgml","text/sgml","sgm","text/sgml","tsv","text/tab-separated-values","t","text/troff","man","text/troff","me","text/troff","ms","text/troff","roff","text/troff","tr","text/troff","ttl","text/turtle","uri","text/uri-list","uris","text/uri-list","urls","text/uri-list","vcard","text/vcard","curl","text/vnd.curl","dcurl","text/vnd.curl.dcurl","mcurl","text/vnd.curl.mcurl","scurl","text/vnd.curl.scurl","fly","text/vnd.fly","flx","text/vnd.fmi.flexstor","gv","text/vnd.graphviz","3dml","text/vnd.in3d.3dml","spot","text/vnd.in3d.spot","jad","text/vnd.sun.j2me.app-descriptor","wml","text/vnd.wap.wml","wmls","text/vnd.wap.wmlscript","asm","text/x-asm","s","text/x-asm","c","text/x-c","cc","text/x-c","cpp","text/x-c","cxx","text/x-c","dic","text/x-c","h","text/x-c","hh","text/x-c","dart","text/x-dart","f","text/x-fortran","f77","text/x-fortran","f90","text/x-fortran","for","text/x-fortran","java","text/x-java-source","nfo","text/x-nfo","opml","text/x-opml","pas","text/x-pascal","p","text/x-pascal","etx","text/x-setext","sfv","text/x-sfv","uu","text/x-uuencode","vcs","text/x-vcalendar","vcf","text/x-vcard","3gp","video/3gpp","3g2","video/3gpp2","h261","video/h261","h263","video/h263","h264","video/h264","jpgv","video/jpeg","jpm","video/jpm","jpgm","video/jpm","mj2","video/mj2","mjp2","video/mj2","ts","video/mp2t","m2t","video/mp2t","m2ts","video/mp2t","mts","video/mp2t","mp4","video/mp4","mp4v","video/mp4","mpg4","video/mp4","mpg","video/mpeg","m1v","video/mpeg","m2v","video/mpeg","mpe","video/mpeg","mpeg","video/mpeg","ogv","video/ogg","mov","video/quicktime","qt","video/quicktime","uvh","video/vnd.dece.hd","uvvh","video/vnd.dece.hd","uvm","video/vnd.dece.mobile","uvvm","video/vnd.dece.mobile","uvp","video/vnd.dece.pd","uvvp","video/vnd.dece.pd","uvs","video/vnd.dece.sd","uvvs","video/vnd.dece.sd","uvv","video/vnd.dece.video","uvvv","video/vnd.dece.video","dvb","video/vnd.dvb.file","fvt","video/vnd.fvt","mxu","video/vnd.mpegurl","m4u","video/vnd.mpegurl","pyv","video/vnd.ms-playready.media.pyv","uvu","video/vnd.uvvu.mp4","uvvu","video/vnd.uvvu.mp4","viv","video/vnd.vivo","webm","video/webm","f4v","video/x-f4v","fli","video/x-fli","flv","video/x-flv","m4v","video/x-m4v","mkv","video/x-matroska","mk3d","video/x-matroska","mks","video/x-matroska","mng","video/x-mng","asf","video/x-ms-asf","asx","video/x-ms-asf","vob","video/x-ms-vob","wm","video/x-ms-wm","wmv","video/x-ms-wmv","wmx","video/x-ms-wmx","wvx","video/x-ms-wvx","avi","video/x-msvideo","movie","video/x-sgi-movie","smv","video/x-smv","ice","x-conference/x-cooltalk"],A.T("aO<X,X>"))
B.cl=new A.aO([34665,"exif",40965,"interop",34853,"gps"],A.T("aO<h,X>"))
B.d6=new A.aJ(2,"falseFloydSteinberg")
B.d7=new A.aJ(3,"jarvisJudiceNinke")
B.d8=new A.aJ(4,"stucki")
B.d9=new A.aJ(5,"burkes")
B.da=new A.aJ(6,"atkinson")
B.aN=s([0,0,0],t.a)
B.ip=s([B.aN,B.aN,B.aN],t.U)
B.iy=s([0.4375,1,0],t.a)
B.ix=s([0.1875,-1,1],t.a)
B.ev=s([0.3125,0,1],t.a)
B.jt=s([0.0625,1,1],t.a)
B.j4=s([B.iy,B.ix,B.ev,B.jt],t.U)
B.ha=s([0.375,1,0],t.a)
B.l1=s([0.375,0,1],t.a)
B.kz=s([0.25,1,1],t.a)
B.f9=s([B.ha,B.l1,B.kz],t.U)
B.dI=s([0.14583333333333334,1,0],t.a)
B.iW=s([0.10416666666666667,2,0],t.a)
B.c_=s([0.0625,-2,1],t.a)
B.js=s([0.10416666666666667,-1,1],t.a)
B.kt=s([0.14583333333333334,0,1],t.a)
B.hY=s([0.10416666666666667,1,1],t.a)
B.c6=s([0.0625,2,1],t.a)
B.i_=s([0.020833333333333332,-2,2],t.a)
B.h3=s([0.0625,-1,2],t.a)
B.k8=s([0.10416666666666667,0,2],t.a)
B.kg=s([0.0625,1,2],t.a)
B.hI=s([0.020833333333333332,2,2],t.a)
B.iF=s([B.dI,B.iW,B.c_,B.js,B.kt,B.hY,B.c6,B.i_,B.h3,B.k8,B.kg,B.hI],t.U)
B.jR=s([0.19047619047619047,1,0],t.a)
B.kY=s([0.09523809523809523,2,0],t.a)
B.ez=s([0.047619047619047616,-2,1],t.a)
B.fY=s([0.09523809523809523,-1,1],t.a)
B.kw=s([0.19047619047619047,0,1],t.a)
B.hG=s([0.09523809523809523,1,1],t.a)
B.ft=s([0.047619047619047616,2,1],t.a)
B.kJ=s([0.023809523809523808,-2,2],t.a)
B.kq=s([0.047619047619047616,-1,2],t.a)
B.l6=s([0.09523809523809523,0,2],t.a)
B.fT=s([0.047619047619047616,1,2],t.a)
B.k5=s([0.023809523809523808,2,2],t.a)
B.fN=s([B.jR,B.kY,B.ez,B.fY,B.kw,B.hG,B.ft,B.kJ,B.kq,B.l6,B.fT,B.k5],t.U)
B.kL=s([0.25,1,0],t.a)
B.bM=s([0.125,2,0],t.a)
B.bv=s([0.125,-1,1],t.a)
B.jn=s([0.25,0,1],t.a)
B.c0=s([0.125,1,1],t.a)
B.kG=s([B.kL,B.bM,B.c_,B.bv,B.jn,B.c0,B.c6],t.U)
B.hX=s([0.125,1,0],t.a)
B.hp=s([0.125,0,1],t.a)
B.jc=s([0.125,0,2],t.a)
B.f8=s([B.hX,B.bM,B.bv,B.hp,B.c0,B.jc],t.U)
B.lb=new A.aO([B.bd,B.ip,B.aI,B.j4,B.d6,B.f9,B.d7,B.iF,B.d8,B.fN,B.d9,B.kG,B.da,B.f8],A.T("aO<aJ,r<r<k>>>"))
B.db=new A.aJ(7,"bayer2x2")
B.dd=new A.aJ(9,"bayer8x8")
B.jf=s([0,0.5],t.n)
B.jy=s([0.75,0.25],t.n)
B.fA=s([B.jf,B.jy],t.A)
B.hD=s([0,0.5,0.125,0.625],t.n)
B.kV=s([0.75,0.25,0.875,0.375],t.n)
B.jg=s([0.1875,0.6875,0.0625,0.5625],t.n)
B.hH=s([0.9375,0.4375,0.8125,0.3125],t.n)
B.eF=s([B.hD,B.kV,B.jg,B.hH],t.A)
B.hs=s([0,0.5,0.125,0.625,0.03125,0.53125,0.15625,0.65625],t.n)
B.fj=s([0.75,0.25,0.875,0.375,0.78125,0.28125,0.90625,0.40625],t.n)
B.e_=s([0.1875,0.6875,0.0625,0.5625,0.21875,0.71875,0.09375,0.59375],t.n)
B.ff=s([0.9375,0.4375,0.8125,0.3125,0.96875,0.46875,0.84375,0.34375],t.n)
B.i0=s([0.046875,0.546875,0.171875,0.671875,0.015625,0.515625,0.140625,0.640625],t.n)
B.eI=s([0.796875,0.296875,0.921875,0.421875,0.765625,0.265625,0.890625,0.390625],t.n)
B.k7=s([0.234375,0.734375,0.109375,0.609375,0.203125,0.703125,0.078125,0.578125],t.n)
B.kB=s([0.984375,0.484375,0.859375,0.359375,0.953125,0.453125,0.828125,0.328125],t.n)
B.fC=s([B.hs,B.fj,B.e_,B.ff,B.i0,B.eI,B.k7,B.kB],t.A)
B.cm=new A.aO([B.db,B.fA,B.dc,B.eF,B.dd,B.fC],A.T("aO<aJ,r<r<D>>>"))
B.cn=new A.aO([B.A,1,B.w,3,B.B,15,B.e,255,B.n,65535,B.R,4294967295,B.U,127,B.V,32767,B.W,2147483647,B.H,1,B.I,1,B.Q,1],A.T("aO<au,h>"))
B.lk=new A.i_(0,"none")
B.ll=new A.i_(4,"paeth")
B.aa=new A.cb(0,"invalid")
B.ct=new A.cb(1,"pbm")
B.cu=new A.cb(2,"pgm2")
B.aX=new A.cb(3,"pgm5")
B.cv=new A.cb(4,"ppm3")
B.aY=new A.cb(5,"ppm6")
B.mg=new A.fd(0,"auto")
B.lq=new A.fd(3,"rgb4")
B.lr=new A.fd(4,"rgba4")
B.mh=new A.ky(1,"neural")
B.cA=new A.d1(0,0)
B.ls=new A.el([B.H,B.I,B.Q],A.T("el<au>"))
B.b_=new A.b6(0,"bilevel")
B.lB=new A.b6(1,"gray4bit")
B.lC=new A.b6(2,"gray")
B.lD=new A.b6(3,"grayAlpha")
B.lE=new A.b6(4,"palette")
B.cD=new A.b6(5,"rgb")
B.lF=new A.b6(6,"rgba")
B.lG=new A.b6(7,"yCbCrSub")
B.ab=new A.b6(8,"generic")
B.lH=new A.b6(9,"invalid")
B.lV=A.bq("h2")
B.lW=A.bq("j9")
B.lX=A.bq("jm")
B.lY=A.bq("ei")
B.lZ=A.bq("cy")
B.m_=A.bq("jG")
B.m0=A.bq("jH")
B.m1=A.bq("K")
B.m2=A.bq("il")
B.m3=A.bq("by")
B.m4=A.bq("kP")
B.m5=A.bq("b7")
B.m6=new A.iq(!1)
B.m7=new A.iq(!0)
B.ac=new A.dQ(0,"undefined")
B.b4=new A.dQ(1,"lossy")
B.aD=new A.dQ(2,"lossless")
B.ma=new A.dQ(3,"animated")
B.aE=new A.dR(0,"none")
B.mb=new A.dR(1,"partial")
B.mc=new A.dR(2,"full")
B.ad=new A.dR(3,"finish")
B.b5=new A.dW(0,"header")
B.md=new A.dW(1,"blocks")
B.me=new A.dW(2,"trailer")
B.cJ=new A.dW(3,"done")})();(function staticFields(){$.lI=null
$.aU=A.j([],A.T("q<K>"))
$.oA=null
$.nX=null
$.nW=null
$.pA=null
$.pn=null
$.pJ=null
$.mg=null
$.mp=null
$.nw=null
$.lM=A.j([],A.T("q<r<K>?>"))
$.dY=null
$.fS=null
$.fT=null
$.nq=!1
$.a6=B.G
$.bs=A.oP("_config")
$.nn=null
$.oM=!1
$.tC=A.j([A.nD(),A.wC(),A.wH(),A.wI(),A.wJ(),A.wK(),A.wL(),A.wM(),A.wN(),A.wO(),A.wD(),A.wE(),A.wF(),A.wG(),A.nD(),A.nD()],A.T("q<h(h,by,h)>"))
$.N=null
$.o6=A.oP("_eLut")})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"wU","pO",()=>A.mk("_$dart_dartClosure"))
s($,"wT","nF",()=>A.mk("_$dart_dartClosure_dartJSInterop"))
s($,"xM","qe",()=>A.j([new J.hI()],A.T("q<fe>")))
s($,"x4","pS",()=>A.bQ(A.kO({
toString:function(){return"$receiver$"}})))
s($,"x5","pT",()=>A.bQ(A.kO({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"x6","pU",()=>A.bQ(A.kO(null)))
s($,"x7","pV",()=>A.bQ(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"xa","pY",()=>A.bQ(A.kO(void 0)))
s($,"xb","pZ",()=>A.bQ(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"x9","pX",()=>A.bQ(A.oI(null)))
s($,"x8","pW",()=>A.bQ(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"xd","q0",()=>A.bQ(A.oI(void 0)))
s($,"xc","q_",()=>A.bQ(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"xl","nL",()=>A.tO())
s($,"xr","q8",()=>A.eW(4096))
s($,"xp","q6",()=>new A.lV().$0())
s($,"xq","q7",()=>new A.lU().$0())
s($,"xJ","j0",()=>A.iX(B.m1))
s($,"xo","q5",()=>A.ni(B.ao,B.aO,257,286,15))
s($,"xn","q4",()=>A.ni(B.bO,B.a6,0,30,15))
s($,"xm","q3",()=>A.ni(null,B.e7,0,19,7))
s($,"wW","pQ",()=>A.hl(B.kO))
s($,"wV","pP",()=>A.hl(B.fi))
s($,"xH","qb",()=>A.up())
s($,"xO","mz",()=>{var q=null,p="ISOSpeed"
return A.mO([11,A.i("ProcessingSoftware",B.l,q),254,A.i("SubfileType",B.p,1),255,A.i("OldSubfileType",B.p,1),256,A.i("ImageWidth",B.p,1),257,A.i("ImageLength",B.p,1),258,A.i("BitsPerSample",B.k,1),259,A.i("Compression",B.k,1),262,A.i("PhotometricInterpretation",B.k,1),263,A.i("Thresholding",B.k,1),264,A.i("CellWidth",B.k,1),265,A.i("CellLength",B.k,1),266,A.i("FillOrder",B.k,1),269,A.i("DocumentName",B.l,q),270,A.i("ImageDescription",B.l,q),271,A.i("Make",B.l,q),272,A.i("Model",B.l,q),273,A.i("StripOffsets",B.p,q),274,A.i("Orientation",B.k,1),277,A.i("SamplesPerPixel",B.k,1),278,A.i("RowsPerStrip",B.p,1),279,A.i("StripByteCounts",B.p,1),280,A.i("MinSampleValue",B.k,1),281,A.i("MaxSampleValue",B.k,1),282,A.i("XResolution",B.v,1),283,A.i("YResolution",B.v,1),284,A.i("PlanarConfiguration",B.k,1),285,A.i("PageName",B.l,q),286,A.i("XPosition",B.v,1),287,A.i("YPosition",B.v,1),290,A.i("GrayResponseUnit",B.k,1),291,A.i("GrayResponseCurve",B.f,q),292,A.i("T4Options",B.f,q),293,A.i("T6Options",B.f,q),296,A.i("ResolutionUnit",B.k,1),297,A.i("PageNumber",B.k,2),300,A.i("ColorResponseUnit",B.f,q),301,A.i("TransferFunction",B.k,768),305,A.i("Software",B.l,q),306,A.i("DateTime",B.l,q),315,A.i("Artist",B.l,q),316,A.i("HostComputer",B.l,q),317,A.i("Predictor",B.k,1),318,A.i("WhitePoint",B.v,2),319,A.i("PrimaryChromaticities",B.v,6),320,A.i("ColorMap",B.k,q),321,A.i("HalftoneHints",B.k,2),322,A.i("TileWidth",B.p,1),323,A.i("TileLength",B.p,1),324,A.i("TileOffsets",B.p,q),325,A.i("TileByteCounts",B.f,q),326,A.i("BadFaxLines",B.f,q),327,A.i("CleanFaxData",B.f,q),328,A.i("ConsecutiveBadFaxLines",B.f,q),332,A.i("InkSet",B.f,q),333,A.i("InkNames",B.f,q),334,A.i("NumberofInks",B.f,q),336,A.i("DotRange",B.f,q),337,A.i("TargetPrinter",B.l,q),338,A.i("ExtraSamples",B.f,q),339,A.i("SampleFormat",B.k,1),340,A.i("SMinSampleValue",B.f,q),341,A.i("SMaxSampleValue",B.f,q),342,A.i("TransferRange",B.f,q),343,A.i("ClipPath",B.f,q),512,A.i("JPEGProc",B.f,q),513,A.i("JPEGInterchangeFormat",B.f,q),514,A.i("JPEGInterchangeFormatLength",B.f,q),529,A.i("YCbCrCoefficients",B.v,3),530,A.i("YCbCrSubSampling",B.k,1),531,A.i("YCbCrPositioning",B.k,1),532,A.i("ReferenceBlackWhite",B.v,6),700,A.i("ApplicationNotes",B.k,1),18246,A.i("Rating",B.k,1),33421,A.i("CFARepeatPatternDim",B.f,q),33422,A.i("CFAPattern",B.f,q),33423,A.i("BatteryLevel",B.f,q),33432,A.i("Copyright",B.l,q),33434,A.i("ExposureTime",B.v,1),33437,A.i("FNumber",B.v,q),33723,A.i("IPTC-NAA",B.p,1),34665,A.i("ExifOffset",B.f,q),34675,A.i("InterColorProfile",B.f,q),34850,A.i("ExposureProgram",B.k,1),34852,A.i("SpectralSensitivity",B.l,q),34853,A.i("GPSOffset",B.f,q),34855,A.i(p,B.p,1),34856,A.i("OECF",B.f,q),34864,A.i("SensitivityType",B.k,1),34866,A.i("RecommendedExposureIndex",B.p,1),34867,A.i(p,B.p,1),36864,A.i("ExifVersion",B.J,q),36867,A.i("DateTimeOriginal",B.l,q),36868,A.i("DateTimeDigitized",B.l,q),36880,A.i("OffsetTime",B.l,q),36881,A.i("OffsetTimeOriginal",B.l,q),36882,A.i("OffsetTimeDigitized",B.l,q),37121,A.i("ComponentsConfiguration",B.J,q),37122,A.i("CompressedBitsPerPixel",B.f,q),37377,A.i("ShutterSpeedValue",B.f,q),37378,A.i("ApertureValue",B.f,q),37379,A.i("BrightnessValue",B.f,q),37380,A.i("ExposureBiasValue",B.f,q),37381,A.i("MaxApertureValue",B.f,q),37382,A.i("SubjectDistance",B.f,q),37383,A.i("MeteringMode",B.f,q),37384,A.i("LightSource",B.f,q),37385,A.i("Flash",B.f,q),37386,A.i("FocalLength",B.f,q),37396,A.i("SubjectArea",B.f,q),37500,A.i("MakerNote",B.J,q),37510,A.i("UserComment",B.J,q),37520,A.i("SubSecTime",B.f,q),37521,A.i("SubSecTimeOriginal",B.f,q),37522,A.i("SubSecTimeDigitized",B.f,q),40091,A.i("XPTitle",B.f,q),40092,A.i("XPComment",B.f,q),40093,A.i("XPAuthor",B.f,q),40094,A.i("XPKeywords",B.f,q),40095,A.i("XPSubject",B.f,q),40960,A.i("FlashPixVersion",B.f,q),40961,A.i("ColorSpace",B.k,1),40962,A.i("ExifImageWidth",B.k,1),40963,A.i("ExifImageLength",B.k,1),40964,A.i("RelatedSoundFile",B.f,q),40965,A.i("InteroperabilityOffset",B.f,q),41483,A.i("FlashEnergy",B.f,q),41484,A.i("SpatialFrequencyResponse",B.f,q),41486,A.i("FocalPlaneXResolution",B.f,q),41487,A.i("FocalPlaneYResolution",B.f,q),41488,A.i("FocalPlaneResolutionUnit",B.f,q),41492,A.i("SubjectLocation",B.f,q),41493,A.i("ExposureIndex",B.f,q),41495,A.i("SensingMethod",B.f,q),41728,A.i("FileSource",B.f,q),41729,A.i("SceneType",B.f,q),41730,A.i("CVAPattern",B.f,q),41985,A.i("CustomRendered",B.f,q),41986,A.i("ExposureMode",B.f,q),41987,A.i("WhiteBalance",B.f,q),41988,A.i("DigitalZoomRatio",B.f,q),41989,A.i("FocalLengthIn35mmFilm",B.f,q),41990,A.i("SceneCaptureType",B.f,q),41991,A.i("GainControl",B.f,q),41992,A.i("Contrast",B.f,q),41993,A.i("Saturation",B.f,q),41994,A.i("Sharpness",B.f,q),41995,A.i("DeviceSettingDescription",B.f,q),41996,A.i("SubjectDistanceRange",B.f,q),42016,A.i("ImageUniqueID",B.f,q),42032,A.i("CameraOwnerName",B.l,q),42033,A.i("BodySerialNumber",B.l,q),42034,A.i("LensSpecification",B.f,q),42035,A.i("LensMake",B.l,q),42036,A.i("LensModel",B.l,q),42037,A.i("LensSerialNumber",B.l,q),42240,A.i("Gamma",B.v,1),50341,A.i("PrintIM",B.f,q),59932,A.i("Padding",B.f,q),59933,A.i("OffsetSchema",B.f,q),65e3,A.i("OwnerName",B.l,q),65001,A.i("SerialNumber",B.l,q)],t.p,A.T("hc"))})
s($,"xL","qd",()=>new A.hd(new WeakMap(),A.T("hd<il>")))
s($,"xG","nO",()=>{var q,p=A.eW(768),o=J.bL(256,t.p)
for(q=0;q<256;++q)o[q]=q
B.d.aB(p,256,512,o)
B.d.a8(p,512,768,255)
return p})
s($,"wX","iZ",()=>A.rp(A.j([0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63],t.t)))
r($,"xe","nH",()=>A.eW(511))
r($,"xf","nI",()=>A.eW(511))
r($,"xh","nJ",()=>A.ov(2041))
r($,"xi","nK",()=>A.ov(225))
r($,"xg","mx",()=>A.eW(766))
s($,"xK","fW",()=>new A.m2().$0())
s($,"xj","q1",()=>A.ou(0))
s($,"xk","q2",()=>A.o_(0,0,0,0))
s($,"x1","pR",()=>A.oi(0,0,0))
s($,"xD","az",()=>A.eW(1))
s($,"xE","aH",()=>A.qY(B.d.gq($.az()),0,null))
s($,"xw","ay",()=>A.rl(1))
s($,"xx","aG",()=>J.qg(B.D.gq($.ay()),0,null))
s($,"xy","U",()=>A.rn(1))
s($,"xA","ab",()=>J.qh(B.o.gq($.U()),0,null))
s($,"xz","cl",()=>A.qO(B.o.gq($.U())))
s($,"xu","j_",()=>A.ou(1))
s($,"xv","my",()=>A.oJ(B.u.gq($.j_()),0,null))
s($,"xs","nM",()=>A.rg(1))
s($,"xt","q9",()=>A.oJ(B.a8.gq($.nM()),0,null))
s($,"xB","nN",()=>A.rT(1))
s($,"xC","qa",()=>{var q=$.nN()
return A.qP(q.gq(q))})
s($,"wY","mw",()=>new A.jY(A.j([],A.T("q<eL>"))))
r($,"wZ","nG",()=>new A.jZ())
s($,"xI","qc",()=>{var q=t.N
return new A.k2(A.J(q,q),A.j([],A.T("q<x_>")))})})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.cD,SharedArrayBuffer:A.cD,ArrayBufferView:A.eS,DataView:A.hS,Float32Array:A.eN,Float64Array:A.eO,Int16Array:A.eP,Int32Array:A.eQ,Int8Array:A.eR,Uint16Array:A.eT,Uint32Array:A.eU,Uint8ClampedArray:A.eV,CanvasPixelArray:A.eV,Uint8Array:A.cE})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.aj.$nativeSuperclassTag="ArrayBufferView"
A.fF.$nativeSuperclassTag="ArrayBufferView"
A.fG.$nativeSuperclassTag="ArrayBufferView"
A.c9.$nativeSuperclassTag="ArrayBufferView"
A.fH.$nativeSuperclassTag="ArrayBufferView"
A.fI.$nativeSuperclassTag="ArrayBufferView"
A.aS.$nativeSuperclassTag="ArrayBufferView"})()
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
var s=A.vZ
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=native_executor.js.map
