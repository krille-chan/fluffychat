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
if(a[b]!==s){A.rL(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.j(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.lu(b)
return new s(c,this)}:function(){if(s===null)s=A.lu(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.lu(a).prototype
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
lB(a,b,c,d){return{i:a,p:b,e:c,x:d}},
kk(a){var s,r,q,p,o,n=a[v.dispatchPropertyName]
if(n==null)if($.lx==null){A.ry()
n=a[v.dispatchPropertyName]}if(n!=null){s=n.p
if(!1===s)return n.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return n.i
if(n.e===r)throw A.h(A.mC("Return interceptor for "+A.z(s(a,n))))}q=a.constructor
if(q==null)p=null
else{o=$.jX
if(o==null)o=$.jX=v.getIsolateTag("_$dart_js")
p=q[o]}if(p!=null)return p
p=A.rE(a)
if(p!=null)return p
if(typeof a=="function")return B.dd
s=Object.getPrototypeOf(a)
if(s==null)return B.cf
if(s===Object.prototype)return B.cf
if(typeof q=="function"){o=$.jX
if(o==null)o=$.jX=v.getIsolateTag("_$dart_js")
Object.defineProperty(q,o,{value:B.b2,enumerable:false,writable:true,configurable:true})
return B.b2}return B.b2},
mi(a,b){if(a<0||a>4294967295)throw A.h(A.an(a,0,4294967295,"length",null))
return J.mj(new Array(a),b)},
am(a,b){if(a<0||a>4294967295)throw A.h(A.an(a,0,4294967295,"length",null))
return J.mj(new Array(a),b)},
h0(a,b){if(a<0)throw A.h(A.c2("Length must be a non-negative integer: "+a,null))
return A.j(new Array(a),b.q("t<0>"))},
d0(a,b){return A.j(new Array(a),b.q("t<0>"))},
mj(a,b){var s=A.j(a,b.q("t<0>"))
s.$flags=1
return s},
mk(a){if(a<256)switch(a){case 9:case 10:case 11:case 12:case 13:case 32:case 133:case 160:return!0
default:return!1}switch(a){case 5760:case 8192:case 8193:case 8194:case 8195:case 8196:case 8197:case 8198:case 8199:case 8200:case 8201:case 8202:case 8232:case 8233:case 8239:case 8287:case 12288:case 65279:return!0
default:return!1}},
oo(a,b){var s,r
for(s=a.length;b<s;){r=a.charCodeAt(b)
if(r!==32&&r!==13&&!J.mk(r))break;++b}return b},
op(a,b){var s,r,q
for(s=a.length;b>0;b=r){r=b-1
if(!(r<s))return A.a(a,r)
q=a.charCodeAt(r)
if(q!==32&&q!==13&&!J.mk(q))break}return b},
cx(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.d1.prototype
return J.dY.prototype}if(typeof a=="string")return J.d2.prototype
if(a==null)return J.dX.prototype
if(typeof a=="boolean")return J.h1.prototype
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bw.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.H)return a
return J.kk(a)},
a9(a){if(typeof a=="string")return J.d2.prototype
if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bw.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.H)return a
return J.kk(a)},
ak(a){if(a==null)return a
if(Array.isArray(a))return J.t.prototype
if(typeof a!="object"){if(typeof a=="function")return J.bw.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.H)return a
return J.kk(a)},
rt(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.d1.prototype
return J.dY.prototype}if(a==null)return a
if(!(a instanceof A.H))return J.di.prototype
return a},
b7(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.bw.prototype
if(typeof a=="symbol")return J.d4.prototype
if(typeof a=="bigint")return J.d3.prototype
return a}if(a instanceof A.H)return a
return J.kk(a)},
fa(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.cx(a).W(a,b)},
d(a,b){if(typeof b==="number")if(Array.isArray(a)||A.rD(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.ak(a).l(a,b)},
y(a,b,c){return J.ak(a).h(a,b,c)},
lK(a,b,c){return J.b7(a).fG(a,b,c)},
nK(a,b,c){return J.b7(a).fH(a,b,c)},
nL(a,b,c){return J.b7(a).fI(a,b,c)},
kC(a,b,c){return J.b7(a).fJ(a,b,c)},
nM(a){return J.b7(a).fK(a)},
lL(a,b,c){return J.b7(a).dj(a,b,c)},
W(a,b,c){return J.b7(a).fL(a,b,c)},
az(a){return J.b7(a).fM(a)},
E(a,b,c){return J.b7(a).cG(a,b,c)},
lM(a,b){return J.ak(a).bE(a,b)},
bl(a,b,c,d){return J.ak(a).aO(a,b,c,d)},
bJ(a){return J.cx(a).gJ(a)},
fb(a){return J.ak(a).gH(a)},
bm(a){return J.a9(a).gv(a)},
nN(a){return J.b7(a).gcP(a)},
nO(a){return J.cx(a).gaP(a)},
kD(a){if(typeof a==="number")return a>0?1:a<0?-1:a
return J.rt(a).gec(a)},
nP(a,b,c){return J.ak(a).cs(a,b,c)},
lN(a,b,c){return J.b7(a).hn(a,b,c)},
kE(a,b){return J.ak(a).dq(a,b)},
kF(a,b,c){return J.ak(a).bh(a,b,c)},
nQ(a,b){return J.ak(a).h8(a,b)},
dx(a){return J.cx(a).C(a)},
nR(a,b){return J.ak(a).he(a,b)},
fO:function fO(){},
h1:function h1(){},
dX:function dX(){},
e_:function e_(){},
bQ:function bQ(){},
hg:function hg(){},
di:function di(){},
bw:function bw(){},
d3:function d3(){},
d4:function d4(){},
t:function t(a){this.$ti=a},
h_:function h_(){},
iD:function iD(a){this.$ti=a},
dy:function dy(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
dZ:function dZ(){},
d1:function d1(){},
dY:function dY(){},
d2:function d2(){}},A={kQ:function kQ(){},
iK(a){return new A.d5("Field '"+a+"' has not been initialized.")},
oq(a){return new A.d5("Field '"+a+"' has already been initialized.")},
eC(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
le(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
f8(a,b,c){return a},
ly(a){var s,r
for(s=$.aL.length,r=0;r<s;++r)if(a===$.aL[r])return!0
return!1},
dh(a,b,c,d){A.df(b,"start")
if(c!=null){A.df(c,"end")
if(b>c)A.b8(A.an(b,0,c,"start",null))}return new A.eB(a,b,c,d.q("eB<0>"))},
os(a,b,c,d){if(t.gw.b(a))return new A.dA(a,b,c.q("@<0>").am(d).q("dA<1,2>"))
return new A.by(a,b,c.q("@<0>").am(d).q("by<1,2>"))},
iC(){return new A.dg("No element")},
mg(){return new A.dg("Too few elements")},
d5:function d5(a){this.a=a},
al:function al(a){this.a=a},
ja:function ja(){},
C:function C(){},
aA:function aA(){},
eB:function eB(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.$ti=d},
cb:function cb(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
by:function by(a,b,c){this.a=a
this.b=b
this.$ti=c},
dA:function dA(a,b,c){this.a=a
this.b=b
this.$ti=c},
e4:function e4(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
b0:function b0(a,b,c){this.a=a
this.b=b
this.$ti=c},
eN:function eN(a,b,c){this.a=a
this.b=b
this.$ti=c},
eO:function eO(a,b,c){this.a=a
this.b=b
this.$ti=c},
c3:function c3(a){this.$ti=a},
dB:function dB(a){this.$ti=a},
cu:function cu(a,b){this.a=a
this.$ti=b},
eP:function eP(a,b){this.a=a
this.$ti=b},
ar:function ar(){},
bD:function bD(){},
dj:function dj(){},
np(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
rD(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.ez.b(a)},
z(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.dx(a)
return s},
es(a){var s,r=$.ms
if(r==null)r=$.ms=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
oP(a,b){var s,r=/^\s*[+-]?((0x[a-f0-9]+)|(\d+)|([a-z0-9]+))\s*$/i.exec(a)
if(r==null)return null
if(3>=r.length)return A.a(r,3)
s=r[3]
if(s!=null)return parseInt(a,10)
if(r[2]!=null)return parseInt(a,16)
return null},
hl(a){var s,r,q,p
if(a instanceof A.H)return A.aw(A.aK(a),null)
s=J.cx(a)
if(s===B.db||s===B.de||t.bI.b(a)){r=B.b4(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.aw(A.aK(a),null)},
oQ(a){var s,r,q
if(typeof a=="number"||A.kc(a))return J.dx(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.aq)return a.C(0)
s=$.nJ()
for(r=0;r<1;++r){q=s[r].l6(a)
if(q!=null)return q}return"Instance of '"+A.hl(a)+"'"},
mr(a){var s,r,q,p,o=a.length
if(o<=500)return String.fromCharCode.apply(null,a)
for(s="",r=0;r<o;r=q){q=r+500
p=q<o?q:o
s+=String.fromCharCode.apply(null,a.slice(r,p))}return s},
oR(a){var s,r,q,p=A.j([],t.t)
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a1)(a),++r){q=a[r]
if(!A.hX(q))throw A.h(A.bZ(q))
if(q<=65535)B.c.G(p,q)
else if(q<=1114111){B.c.G(p,55296+(B.a.j(q-65536,10)&1023))
B.c.G(p,56320+(q&1023))}else throw A.h(A.bZ(q))}return A.mr(p)},
mt(a){var s,r,q
for(s=a.length,r=0;r<s;++r){q=a[r]
if(!A.hX(q))throw A.h(A.bZ(q))
if(q<0)throw A.h(A.bZ(q))
if(q>65535)return A.oR(a)}return A.mr(a)},
oS(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
d9(a){var s
if(a<=65535)return String.fromCharCode(a)
if(a<=1114111){s=a-65536
return String.fromCharCode((B.a.j(s,10)|55296)>>>0,s&1023|56320)}throw A.h(A.an(a,0,1114111,null,null))},
d8(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
oO(a){var s=A.d8(a).getUTCFullYear()+0
return s},
oM(a){var s=A.d8(a).getUTCMonth()+1
return s},
oI(a){var s=A.d8(a).getUTCDate()+0
return s},
oJ(a){var s=A.d8(a).getUTCHours()+0
return s},
oL(a){var s=A.d8(a).getUTCMinutes()+0
return s},
oN(a){var s=A.d8(a).getUTCSeconds()+0
return s},
oK(a){var s=A.d8(a).getUTCMilliseconds()+0
return s},
oH(a){var s=a.$thrownJsError
if(s==null)return null
return A.bk(s)},
mu(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.a4(a,s)
a.$thrownJsError=s
s.stack=b.C(0)}},
nj(a){throw A.h(A.bZ(a))},
a(a,b){if(a==null)J.bm(a)
throw A.h(A.ki(a,b))},
ki(a,b){var s,r="index"
if(!A.hX(b))return new A.aX(!0,b,r,null)
s=J.bm(a)
if(b<0||b>=s)return A.kP(b,s,a,null,r)
return A.mx(b,r)},
ri(a,b,c){if(a<0||a>c)return A.an(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.an(b,a,c,"end",null)
return new A.aX(!0,b,"end",null)},
bZ(a){return new A.aX(!0,a,null,null)},
h(a){return A.a4(a,new Error())},
a4(a,b){var s
if(a==null)a=new A.bg()
b.dartException=a
s=A.rM
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
rM(){return J.dx(this.dartException)},
b8(a,b){throw A.a4(a,b==null?new Error():b)},
c(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.b8(A.qo(a,b,c),s)},
qo(a,b,c){var s,r,q,p,o,n,m,l,k
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
return new A.eE("'"+s+"': Cannot "+o+" "+l+k+n)},
a1(a){throw A.h(A.ba(a))},
bA(a){var s,r,q,p,o,n
a=A.rK(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.j([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.jh(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
ji(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
mA(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
kR(a,b){var s=b==null,r=s?null:b.method
return new A.h5(a,r,s?null:b.receiver)},
c0(a){var s
if(a==null)return new A.iX(a)
if(a instanceof A.dC){s=a.a
return A.c_(a,s==null?A.f5(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.c_(a,a.dartException)
return A.r6(a)},
c_(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
r6(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.a.j(r,16)&8191)===10)switch(q){case 438:return A.c_(a,A.kR(A.z(s)+" (Error "+q+")",null))
case 445:case 5007:A.z(s)
return A.c_(a,new A.ee())}}if(a instanceof TypeError){p=$.nr()
o=$.ns()
n=$.nt()
m=$.nu()
l=$.nx()
k=$.ny()
j=$.nw()
$.nv()
i=$.nA()
h=$.nz()
g=p.bJ(s)
if(g!=null)return A.c_(a,A.kR(A.bG(s),g))
else{g=o.bJ(s)
if(g!=null){g.method="call"
return A.c_(a,A.kR(A.bG(s),g))}else if(n.bJ(s)!=null||m.bJ(s)!=null||l.bJ(s)!=null||k.bJ(s)!=null||j.bJ(s)!=null||m.bJ(s)!=null||i.bJ(s)!=null||h.bJ(s)!=null){A.bG(s)
return A.c_(a,new A.ee())}}return A.c_(a,new A.hE(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.ey()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.c_(a,new A.aX(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.ey()
return a},
bk(a){var s
if(a instanceof A.dC)return a.b
if(a==null)return new A.f0(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.f0(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
i2(a){if(a==null)return J.bJ(a)
if(typeof a=="object")return A.es(a)
return J.bJ(a)},
re(a){if(typeof a=="number")return B.b.gJ(a)
if(a instanceof A.hT)return A.es(a)
return A.i2(a)},
nh(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.h(0,a[s],a[r])}return b},
qB(a,b,c,d,e,f){t.Z.a(a)
switch(A.o(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.h(A.lX("Unsupported number of arguments for wrapped closure"))},
f9(a,b){var s=a.$identity
if(!!s)return s
s=A.rf(a,b)
a.$identity=s
return s},
rf(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.qB)},
nZ(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.hy().constructor.prototype):Object.create(new A.cz(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.lU(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.nV(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.lU(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
nV(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.h("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.nT)}throw A.h("Error in functionType of tearoff")},
nW(a,b,c,d){var s=A.lT
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
lU(a,b,c,d){if(c)return A.nY(a,b,d)
return A.nW(b.length,d,a,b)},
nX(a,b,c,d){var s=A.lT,r=A.nU
switch(b?-1:a){case 0:throw A.h(new A.hx("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
nY(a,b,c){var s,r
if($.lR==null)$.lR=A.lQ("interceptor")
if($.lS==null)$.lS=A.lQ("receiver")
s=b.length
r=A.nX(s,c,a,b)
return r},
lu(a){return A.nZ(a)},
nT(a,b){return A.k4(v.typeUniverse,A.aK(a.a),b)},
lT(a){return a.a},
nU(a){return a.b},
lQ(a){var s,r,q,p=new A.cz("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.h(A.c2("Field name "+a+" not found.",null))},
ru(a){return v.getIsolateTag(a)},
u9(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
rE(a){var s,r,q,p,o,n=A.bG($.ni.$1(a)),m=$.kj[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.ko[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.n_($.nb.$2(a,n))
if(q!=null){m=$.kj[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.ko[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.kq(s)
$.kj[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.ko[n]=s
return s}if(p==="-"){o=A.kq(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.nm(a,s)
if(p==="*")throw A.h(A.mC(n))
if(v.leafTags[n]===true){o=A.kq(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.nm(a,s)},
nm(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.lB(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
kq(a){return J.lB(a,!1,null,!!a.$iaF)},
rG(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.kq(s)
else return J.lB(s,c,null,null)},
ry(){if(!0===$.lx)return
$.lx=!0
A.rz()},
rz(){var s,r,q,p,o,n,m,l
$.kj=Object.create(null)
$.ko=Object.create(null)
A.rx()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.nn.$1(o)
if(n!=null){m=A.rG(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
rx(){var s,r,q,p,o,n,m=B.cM()
m=A.dv(B.cN,A.dv(B.cO,A.dv(B.b5,A.dv(B.b5,A.dv(B.cP,A.dv(B.cQ,A.dv(B.cR(B.b4),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.ni=new A.kl(p)
$.nb=new A.km(o)
$.nn=new A.kn(n)},
dv(a,b){return a(b)||b},
rh(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
rK(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
cN:function cN(){},
cO:function cO(a,b,c){this.a=a
this.b=b
this.$ti=c},
eU:function eU(a,b){this.a=a
this.$ti=b},
eV:function eV(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
c6:function c6(a,b){this.a=a
this.$ti=b},
fL:function fL(){},
d_:function d_(a,b){this.a=a
this.$ti=b},
ex:function ex(){},
jh:function jh(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
ee:function ee(){},
h5:function h5(a,b,c){this.a=a
this.b=b
this.c=c},
hE:function hE(a){this.a=a},
iX:function iX(a){this.a=a},
dC:function dC(a,b){this.a=a
this.b=b},
f0:function f0(a){this.a=a
this.b=null},
aq:function aq(){},
fi:function fi(){},
fj:function fj(){},
hz:function hz(){},
hy:function hy(){},
cz:function cz(a,b){this.a=a
this.b=b},
hx:function hx(a){this.a=a},
b_:function b_(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
iO:function iO(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
ca:function ca(a,b){this.a=a
this.$ti=b},
O:function O(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
iP:function iP(a,b){this.a=a
this.$ti=b},
at:function at(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
e0:function e0(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
kl:function kl(a){this.a=a},
km:function km(a){this.a=a},
kn:function kn(a){this.a=a},
b(a){throw A.a4(A.iK(a),new Error())},
lD(a){throw A.a4(A.oq(a),new Error())},
rL(a){throw A.a4(new A.d5("Field '"+a+"' has been assigned during initialization."),new Error())},
mH(a){var s=new A.jJ(a)
return s.b=s},
jJ:function jJ(a){this.a=a
this.b=null},
aI(a,b,c){},
r(a){var s,r,q
if(t.aP.b(a))return a
s=J.a9(a)
r=A.S(s.gv(a),null,!1,t.z)
for(q=0;q<s.gv(a);++q)B.c.h(r,q,s.l(a,q))
return r},
ov(a){return new Float32Array(a)},
ow(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,4)
return new Float32Array(a,b,c)},
ox(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,2)
return new Int16Array(a,b,c)},
oy(a){return new Int32Array(a)},
oz(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,4)
return new Int32Array(a,b,c)},
mn(a){return new Int8Array(a)},
oA(a,b,c){A.aI(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
oB(a){return new Uint16Array(a)},
oC(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
oD(a){return new Uint32Array(a)},
oE(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
ha(a){return new Uint8Array(a)},
oF(a,b,c){A.aI(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
bH(a,b,c){if(a>>>0!==a||a>=c)throw A.h(A.ki(b,a))},
b4(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.h(A.ri(a,b,c))
if(b==null)return c
return b},
cc:function cc(){},
ea:function ea(){},
hU:function hU(a){this.a=a},
h9:function h9(){},
ai:function ai(){},
bR:function bR(){},
aG:function aG(){},
e5:function e5(){},
e6:function e6(){},
e7:function e7(){},
e8:function e8(){},
e9:function e9(){},
eb:function eb(){},
ec:function ec(){},
ed:function ed(){},
cd:function cd(){},
eW:function eW(){},
eX:function eX(){},
eY:function eY(){},
eZ:function eZ(){},
lc(a,b){var s=b.c
return s==null?b.c=A.f2(a,"c5",[b.x]):s},
my(a){var s=a.w
if(s===6||s===7)return A.my(a.x)
return s===11||s===12},
oY(a){return a.as},
U(a){return A.k3(v.typeUniverse,a,!1)},
rB(a,b){var s,r,q,p,o
if(a==null)return null
s=b.y
r=a.Q
if(r==null)r=a.Q=new Map()
q=b.as
p=r.get(q)
if(p!=null)return p
o=A.bY(v.typeUniverse,a.x,s,0)
r.set(q,o)
return o},
bY(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.bY(a1,s,a3,a4)
if(r===s)return a2
return A.mS(a1,r,!0)
case 7:s=a2.x
r=A.bY(a1,s,a3,a4)
if(r===s)return a2
return A.mR(a1,r,!0)
case 8:q=a2.y
p=A.du(a1,q,a3,a4)
if(p===q)return a2
return A.f2(a1,a2.x,p)
case 9:o=a2.x
n=A.bY(a1,o,a3,a4)
m=a2.y
l=A.du(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.lo(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.du(a1,j,a3,a4)
if(i===j)return a2
return A.mT(a1,k,i)
case 11:h=a2.x
g=A.bY(a1,h,a3,a4)
f=a2.y
e=A.r3(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.mQ(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.du(a1,d,a3,a4)
o=a2.x
n=A.bY(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.lp(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.h(A.fd("Attempted to substitute unexpected RTI kind "+a0))}},
du(a,b,c,d){var s,r,q,p,o=b.length,n=A.k7(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.bY(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
r4(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.k7(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.bY(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
r3(a,b,c,d){var s,r=b.a,q=A.du(a,r,c,d),p=b.b,o=A.du(a,p,c,d),n=b.c,m=A.r4(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.hP()
s.a=q
s.b=o
s.c=m
return s},
j(a,b){a[v.arrayRti]=b
return a},
kf(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.rw(s)
return a.$S()}return null},
rA(a,b){var s
if(A.my(b))if(a instanceof A.aq){s=A.kf(a)
if(s!=null)return s}return A.aK(a)},
aK(a){if(a instanceof A.H)return A.l(a)
if(Array.isArray(a))return A.av(a)
return A.lr(J.cx(a))},
av(a){var s=a[v.arrayRti],r=t.gn
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
l(a){var s=a.$ti
return s!=null?s:A.lr(a)},
lr(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.qy(a,s)},
qy(a,b){var s=a instanceof A.aq?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.q8(v.typeUniverse,s.name)
b.$ccache=r
return r},
rw(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.k3(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
rv(a){return A.bI(A.l(a))},
lw(a){var s=A.kf(a)
return A.bI(s==null?A.aK(a):s)},
r2(a){var s=a instanceof A.aq?A.kf(a):null
if(s!=null)return s
if(t.ci.b(a))return J.nO(a).a
if(Array.isArray(a))return A.av(a)
return A.aK(a)},
bI(a){var s=a.r
return s==null?a.r=new A.hT(a):s},
b9(a){return A.bI(A.k3(v.typeUniverse,a,!1))},
qx(a){var s=this
s.b=A.r0(s)
return s.b(a)},
r0(a){var s,r,q,p,o
if(a===t.K)return A.qH
if(A.cy(a))return A.qL
s=a.w
if(s===6)return A.qv
if(s===1)return A.n4
if(s===7)return A.qC
r=A.r_(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.cy)){a.f="$i"+q
if(q==="q")return A.qF
if(a===t.m)return A.qE
return A.qK}}else if(s===10){p=A.rh(a.x,a.y)
o=p==null?A.n4:p
return o==null?A.f5(o):o}return A.qt},
r_(a){if(a.w===8){if(a===t.p)return A.hX
if(a===t.V||a===t.q)return A.qG
if(a===t.N)return A.qJ
if(a===t.y)return A.kc}return null},
qw(a){var s=this,r=A.qs
if(A.cy(s))r=A.qh
else if(s===t.K)r=A.f5
else if(A.dw(s)){r=A.qu
if(s===t.I)r=A.qf
else if(s===t.dk)r=A.n_
else if(s===t.fQ)r=A.qd
else if(s===t.cg)r=A.mZ
else if(s===t.cD)r=A.qe
else if(s===t.an)r=A.qg}else if(s===t.p)r=A.o
else if(s===t.N)r=A.bG
else if(s===t.y)r=A.mX
else if(s===t.q)r=A.mY
else if(s===t.V)r=A.hW
else if(s===t.m)r=A.bi
s.a=r
return s.a(a)},
qt(a){var s=this
if(a==null)return A.dw(s)
return A.nk(v.typeUniverse,A.rA(a,s),s)},
qv(a){if(a==null)return!0
return this.x.b(a)},
qK(a){var s,r=this
if(a==null)return A.dw(r)
s=r.f
if(a instanceof A.H)return!!a[s]
return!!J.cx(a)[s]},
qF(a){var s,r=this
if(a==null)return A.dw(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.H)return!!a[s]
return!!J.cx(a)[s]},
qE(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.H)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
n3(a){if(typeof a=="object"){if(a instanceof A.H)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
qs(a){var s=this
if(a==null){if(A.dw(s))return a}else if(s.b(a))return a
throw A.a4(A.n0(a,s),new Error())},
qu(a){var s=this
if(a==null||s.b(a))return a
throw A.a4(A.n0(a,s),new Error())},
n0(a,b){return new A.ds("TypeError: "+A.mI(a,A.aw(b,null)))},
rd(a,b,c,d){if(A.nk(v.typeUniverse,a,b))return a
throw A.a4(A.q_("The type argument '"+A.aw(a,null)+"' is not a subtype of the type variable bound '"+A.aw(b,null)+"' of type variable '"+c+"' in '"+d+"'."),new Error())},
mI(a,b){return A.ih(a)+": type '"+A.aw(A.r2(a),null)+"' is not a subtype of type '"+b+"'"},
q_(a){return new A.ds("TypeError: "+a)},
aW(a,b){return new A.ds("TypeError: "+A.mI(a,b))},
qC(a){var s=this
return s.x.b(a)||A.lc(v.typeUniverse,s).b(a)},
qH(a){return a!=null},
f5(a){if(a!=null)return a
throw A.a4(A.aW(a,"Object"),new Error())},
qL(a){return!0},
qh(a){return a},
n4(a){return!1},
kc(a){return!0===a||!1===a},
mX(a){if(!0===a)return!0
if(!1===a)return!1
throw A.a4(A.aW(a,"bool"),new Error())},
qd(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.a4(A.aW(a,"bool?"),new Error())},
hW(a){if(typeof a=="number")return a
throw A.a4(A.aW(a,"double"),new Error())},
qe(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a4(A.aW(a,"double?"),new Error())},
hX(a){return typeof a=="number"&&Math.floor(a)===a},
o(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.a4(A.aW(a,"int"),new Error())},
qf(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.a4(A.aW(a,"int?"),new Error())},
qG(a){return typeof a=="number"},
mY(a){if(typeof a=="number")return a
throw A.a4(A.aW(a,"num"),new Error())},
mZ(a){if(typeof a=="number")return a
if(a==null)return a
throw A.a4(A.aW(a,"num?"),new Error())},
qJ(a){return typeof a=="string"},
bG(a){if(typeof a=="string")return a
throw A.a4(A.aW(a,"String"),new Error())},
n_(a){if(typeof a=="string")return a
if(a==null)return a
throw A.a4(A.aW(a,"String?"),new Error())},
bi(a){if(A.n3(a))return a
throw A.a4(A.aW(a,"JSObject"),new Error())},
qg(a){if(a==null)return a
if(A.n3(a))return a
throw A.a4(A.aW(a,"JSObject?"),new Error())},
n8(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.aw(a[q],b)
return s},
qR(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.n8(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.aw(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
n1(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.j([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)B.c.G(a4,"T"+(r+q))
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
if(l===8){p=A.r5(a.x)
o=a.y
return o.length>0?p+("<"+A.n8(o,b)+">"):p}if(l===10)return A.qR(a,b)
if(l===11)return A.n1(a,b,null)
if(l===12)return A.n1(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.a(b,n)
return b[n]}return"?"},
r5(a){var s=v.mangledGlobalNames[a]
if(s!=null)return s
return"minified:"+a},
q9(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
q8(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.k3(a,b,!1)
else if(typeof m=="number"){s=m
r=A.f3(a,5,"#")
q=A.k7(s)
for(p=0;p<s;++p)q[p]=r
o=A.f2(a,b,q)
n[b]=o
return o}else return m},
q6(a,b){return A.mV(a.tR,b)},
q5(a,b){return A.mV(a.eT,b)},
k3(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.mO(A.mM(a,null,b,!1))
r.set(b,s)
return s},
k4(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.mO(A.mM(a,b,c,!0))
q.set(c,r)
return r},
q7(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.lo(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
bX(a,b){b.a=A.qw
b.b=A.qx
return b},
f3(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.b3(null,null)
s.w=b
s.as=c
r=A.bX(a,s)
a.eC.set(c,r)
return r},
mS(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.q3(a,b,r,c)
a.eC.set(r,s)
return s},
q3(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.cy(b))if(!(b===t.b||b===t.u))if(s!==6)r=s===7&&A.dw(b.x)
if(r)return b
else if(s===1)return t.b}q=new A.b3(null,null)
q.w=6
q.x=b
q.as=c
return A.bX(a,q)},
mR(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.q1(a,b,r,c)
a.eC.set(r,s)
return s},
q1(a,b,c,d){var s,r
if(d){s=b.w
if(A.cy(b)||b===t.K)return b
else if(s===1)return A.f2(a,"c5",[b])
else if(b===t.b||b===t.u)return t.eH}r=new A.b3(null,null)
r.w=7
r.x=b
r.as=c
return A.bX(a,r)},
q4(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.b3(null,null)
s.w=13
s.x=b
s.as=q
r=A.bX(a,s)
a.eC.set(q,r)
return r},
f1(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
q0(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
f2(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.f1(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.b3(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.bX(a,r)
a.eC.set(p,q)
return q},
lo(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.f1(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.b3(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.bX(a,o)
a.eC.set(q,n)
return n},
mT(a,b,c){var s,r,q="+"+(b+"("+A.f1(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.b3(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.bX(a,s)
a.eC.set(q,r)
return r},
mQ(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.f1(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.f1(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.q0(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.b3(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.bX(a,p)
a.eC.set(r,o)
return o},
lp(a,b,c,d){var s,r=b.as+("<"+A.f1(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.q2(a,b,c,r,d)
a.eC.set(r,s)
return s},
q2(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.k7(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.bY(a,b,r,0)
m=A.du(a,c,r,0)
return A.lp(a,n,m,c!==m)}}l=new A.b3(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.bX(a,l)},
mM(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
mO(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.pU(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.mN(a,r,l,k,!1)
else if(q===46)r=A.mN(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.cw(a.u,a.e,k.pop()))
break
case 94:k.push(A.q4(a.u,k.pop()))
break
case 35:k.push(A.f3(a.u,5,"#"))
break
case 64:k.push(A.f3(a.u,2,"@"))
break
case 126:k.push(A.f3(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.pW(a,k)
break
case 38:A.pV(a,k)
break
case 63:p=a.u
k.push(A.mS(p,A.cw(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.mR(p,A.cw(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.pT(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.mP(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.pY(a.u,a.e,o)
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
return A.cw(a.u,a.e,m)},
pU(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
mN(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.q9(s,o.x)[p]
if(n==null)A.b8('No "'+p+'" in "'+A.oY(o)+'"')
d.push(A.k4(s,o,n))}else d.push(p)
return m},
pW(a,b){var s,r=a.u,q=A.mL(a,b),p=b.pop()
if(typeof p=="string")b.push(A.f2(r,p,q))
else{s=A.cw(r,a.e,p)
switch(s.w){case 11:b.push(A.lp(r,s,q,a.n))
break
default:b.push(A.lo(r,s,q))
break}}},
pT(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.mL(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.cw(p,a.e,o)
q=new A.hP()
q.a=s
q.b=n
q.c=m
b.push(A.mQ(p,r,q))
return
case-4:b.push(A.mT(p,b.pop(),s))
return
default:throw A.h(A.fd("Unexpected state under `()`: "+A.z(o)))}},
pV(a,b){var s=b.pop()
if(0===s){b.push(A.f3(a.u,1,"0&"))
return}if(1===s){b.push(A.f3(a.u,4,"1&"))
return}throw A.h(A.fd("Unexpected extended operation "+A.z(s)))},
mL(a,b){var s=b.splice(a.p)
A.mP(a.u,a.e,s)
a.p=b.pop()
return s},
cw(a,b,c){if(typeof c=="string")return A.f2(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.pX(a,b,c)}else return c},
mP(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.cw(a,b,c[s])},
pY(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.cw(a,b,c[s])},
pX(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.h(A.fd("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.h(A.fd("Bad index "+c+" for "+b.C(0)))},
nk(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.a8(a,b,null,c,null)
r.set(c,s)}return s},
a8(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.cy(d))return!0
s=b.w
if(s===4)return!0
if(A.cy(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.a8(a,c[b.x],c,d,e))return!0
q=d.w
p=t.b
if(b===p||b===t.u){if(q===7)return A.a8(a,b,c,d.x,e)
return d===p||d===t.u||q===6}if(d===t.K){if(s===7)return A.a8(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.a8(a,b.x,c,d,e))return!1
return A.a8(a,A.lc(a,b),c,d,e)}if(s===6)return A.a8(a,p,c,d,e)&&A.a8(a,b.x,c,d,e)
if(q===7){if(A.a8(a,b,c,d.x,e))return!0
return A.a8(a,b,c,A.lc(a,d),e)}if(q===6)return A.a8(a,b,c,p,e)||A.a8(a,b,c,d.x,e)
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
if(!A.a8(a,j,c,i,e)||!A.a8(a,i,e,j,c))return!1}return A.n2(a,b.x,c,d.x,e)}if(q===11){if(b===t.cj)return!0
if(p)return!1
return A.n2(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.qD(a,b,c,d,e)}if(o&&q===10)return A.qI(a,b,c,d,e)
return!1},
n2(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.a8(a3,a4.x,a5,a6.x,a7))return!1
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
if(!A.a8(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.a8(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.a8(a3,k[h],a7,g,a5))return!1}f=s.c
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
if(!A.a8(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
qD(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.k4(a,b,r[o])
return A.mW(a,p,null,c,d.y,e)}return A.mW(a,b.y,null,c,d.y,e)},
mW(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.a8(a,b[s],d,e[s],f))return!1
return!0},
qI(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.a8(a,r[s],c,q[s],e))return!1
return!0},
dw(a){var s=a.w,r=!0
if(!(a===t.b||a===t.u))if(!A.cy(a))if(s!==6)r=s===7&&A.dw(a.x)
return r},
cy(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
mV(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
k7(a){return a>0?new Array(a):v.typeUniverse.sEA},
b3:function b3(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
hP:function hP(){this.c=this.b=this.a=null},
hT:function hT(a){this.a=a},
hN:function hN(){},
ds:function ds(a){this.a=a},
pN(){var s,r,q
if(self.scheduleImmediate!=null)return A.r8()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.f9(new A.jG(s),1)).observe(r,{childList:true})
return new A.jF(s,r,q)}else if(self.setImmediate!=null)return A.r9()
return A.ra()},
pO(a){self.scheduleImmediate(A.f9(new A.jH(t.M.a(a)),0))},
pP(a){self.setImmediate(A.f9(new A.jI(t.M.a(a)),0))},
pQ(a){t.M.a(a)
A.pZ(0,a)},
pZ(a,b){var s=new A.k_()
s.hT(a,b)
return s},
qN(a){return new A.hK(new A.ab($.a0,a.q("ab<0>")),a.q("hK<0>"))},
qk(a,b){a.$2(0,null)
b.b=!0
return b.a},
u6(a,b){A.ql(a,b)},
qj(a,b){b.e_(a)},
qi(a,b){b.e0(A.c0(a),A.bk(a))},
ql(a,b){var s,r,q=new A.ka(b),p=new A.kb(b)
if(a instanceof A.ab)a.fk(q,p,t.z)
else{s=t.z
if(a instanceof A.ab)a.h9(q,p,s)
else{r=new A.ab($.a0,t._)
r.a=8
r.c=a
r.fk(q,p,s)}}},
r7(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.a0.h6(new A.ke(s),t.w,t.p,t.z)},
kH(a){var s
if(t.C.b(a)){s=a.gcv()
if(s!=null)return s}return B.ad},
qz(a,b){if($.a0===B.B)return null
return null},
qA(a,b){if($.a0!==B.B)A.qz(a,b)
if(b==null)if(t.C.b(a)){b=a.gcv()
if(b==null){A.mu(a,B.ad)
b=B.ad}}else b=B.ad
else if(t.C.b(a))A.mu(a,b)
return new A.aM(a,b)},
lj(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t._;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.oZ()
b.du(new A.aM(new A.aX(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.f8(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.dd()
b.d0(o.a)
A.dp(b,p)
return}b.a^=2
A.hY(null,null,b.b,t.M.a(new A.jP(o,b)))},
dp(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.n,r=t.F;;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.lt(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.dp(d.a,c)
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
A.lt(j.a,j.b)
return}g=$.a0
if(g!==h)$.a0=h
else g=null
c=c.c
if((c&15)===8)new A.jT(q,d,n).$0()
else if(o){if((c&1)!==0)new A.jS(q,j).$0()}else if((c&2)!==0)new A.jR(d,q).$0()
if(g!=null)$.a0=g
c=q.c
if(c instanceof A.ab){p=q.a.$ti
p=p.q("c5<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.de(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.lj(c,f,!0)
return}}f=q.a.b
e=r.a(f.c)
f.c=null
b=f.de(e)
c=q.b
p=q.c
if(!c){f.$ti.c.a(p)
f.a=8
f.c=p}else{s.a(p)
f.a=f.a&1|16
f.c=p}d.a=f
c=f}},
qS(a,b){var s
if(t.Q.b(a))return b.h6(a,t.z,t.K,t.l)
s=t.x
if(s.b(a))return s.a(a)
throw A.h(A.kG(a,"onError",u.c))},
qP(){var s,r
for(s=$.dt;s!=null;s=$.dt){$.f7=null
r=s.b
$.dt=r
if(r==null)$.f6=null
s.a.$0()}},
r1(){$.ls=!0
try{A.qP()}finally{$.f7=null
$.ls=!1
if($.dt!=null)$.lH().$1(A.nc())}},
n9(a){var s=new A.hL(a),r=$.f6
if(r==null){$.dt=$.f6=s
if(!$.ls)$.lH().$1(A.nc())}else $.f6=r.b=s},
qZ(a){var s,r,q,p=$.dt
if(p==null){A.n9(a)
$.f7=$.f6
return}s=new A.hL(a)
r=$.f7
if(r==null){s.b=p
$.dt=$.f7=s}else{q=r.b
s.b=q
$.f7=r.b=s
if(q==null)$.f6=s}},
tx(a,b){A.f8(a,"stream",t.K)
return new A.hR(b.q("hR<0>"))},
lt(a,b){A.qZ(new A.kd(a,b))},
n7(a,b,c,d,e){var s,r=$.a0
if(r===c)return d.$0()
$.a0=c
s=r
try{r=d.$0()
return r}finally{$.a0=s}},
qV(a,b,c,d,e,f,g){var s,r=$.a0
if(r===c)return d.$1(e)
$.a0=c
s=r
try{r=d.$1(e)
return r}finally{$.a0=s}},
qU(a,b,c,d,e,f,g,h,i){var s,r=$.a0
if(r===c)return d.$2(e,f)
$.a0=c
s=r
try{r=d.$2(e,f)
return r}finally{$.a0=s}},
hY(a,b,c,d){t.M.a(d)
if(B.B!==c){d=c.ki(d)
d=d}A.n9(d)},
jG:function jG(a){this.a=a},
jF:function jF(a,b,c){this.a=a
this.b=b
this.c=c},
jH:function jH(a){this.a=a},
jI:function jI(a){this.a=a},
k_:function k_(){},
k0:function k0(a,b){this.a=a
this.b=b},
hK:function hK(a,b){this.a=a
this.b=!1
this.$ti=b},
ka:function ka(a){this.a=a},
kb:function kb(a){this.a=a},
ke:function ke(a){this.a=a},
aM:function aM(a,b){this.a=a
this.b=b},
hM:function hM(){},
eQ:function eQ(a,b){this.a=a
this.$ti=b},
cv:function cv(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
ab:function ab(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
jM:function jM(a,b){this.a=a
this.b=b},
jQ:function jQ(a,b){this.a=a
this.b=b},
jP:function jP(a,b){this.a=a
this.b=b},
jO:function jO(a,b){this.a=a
this.b=b},
jN:function jN(a,b){this.a=a
this.b=b},
jT:function jT(a,b,c){this.a=a
this.b=b
this.c=c},
jU:function jU(a,b){this.a=a
this.b=b},
jV:function jV(a){this.a=a},
jS:function jS(a,b){this.a=a
this.b=b},
jR:function jR(a,b){this.a=a
this.b=b},
hL:function hL(a){this.a=a
this.b=null},
hR:function hR(a){this.$ti=a},
f4:function f4(){},
kd:function kd(a,b){this.a=a
this.b=b},
hQ:function hQ(){},
jY:function jY(a,b){this.a=a
this.b=b},
mJ(a,b){var s=a[b]
return s===a?null:s},
ll(a,b,c){if(c==null)a[b]=a
else a[b]=c},
lk(){var s=Object.create(null)
A.ll(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
or(a,b){return new A.b_(a.q("@<0>").am(b).q("b_<1,2>"))},
kS(a,b,c){return b.q("@<0>").am(c).q("iN<1,2>").a(A.nh(a,new A.b_(b.q("@<0>").am(c).q("b_<1,2>"))))},
I(a,b){return new A.b_(a.q("@<0>").am(b).q("b_<1,2>"))},
e1(a,b,c){var s=A.or(b,c)
a.bI(0,new A.iQ(s,b,c))
return s},
kU(a){var s,r
if(A.ly(a))return"{...}"
s=new A.ez("")
try{r={}
B.c.G($.aL,a)
s.a+="{"
r.a=!0
a.bI(0,new A.iU(r,s))
s.a+="}"}finally{if(0>=$.aL.length)return A.a($.aL,-1)
$.aL.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
eR:function eR(){},
dq:function dq(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
eS:function eS(a,b){this.a=a
this.$ti=b},
eT:function eT(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
iQ:function iQ(a,b,c){this.a=a
this.b=b
this.c=c},
G:function G(){},
ah:function ah(){},
iU:function iU(a,b){this.a=a
this.b=b},
qb(a,b,c){var s,r,q,p,o=c-b
if(o<=4096)s=$.nG()
else s=new Uint8Array(o)
for(r=0;r<o;++r){q=b+r
if(!(q<a.length))return A.a(a,q)
p=a[q]
if((p&255)!==p)p=255
s[r]=p}return s},
qa(a,b,c,d){var s=a?$.nF():$.nE()
if(s==null)return null
if(0===c&&d===b.length)return A.mU(s,b)
return A.mU(s,b.subarray(c,d))},
mU(a,b){var s,r
try{s=a.decode(b)
return s}catch(r){}return null},
qc(a){switch(a){case 65:return"Missing extension byte"
case 67:return"Unexpected extension byte"
case 69:return"Invalid UTF-8 byte"
case 71:return"Overlong encoding"
case 73:return"Out of unicode range"
case 75:return"Encoded surrogate"
case 77:return"Unfinished UTF-8 octet sequence"
default:return""}},
k6:function k6(){},
k5:function k5(){},
k2:function k2(){},
k1:function k1(){},
cA:function cA(){},
fo:function fo(){},
fs:function fs(){},
h6:function h6(){},
iM:function iM(){},
iL:function iL(a){this.a=a},
hF:function hF(){},
hG:function hG(a){this.a=a},
hV:function hV(a){this.a=a
this.b=16
this.c=0},
rC(a){var s=A.oP(a,null)
if(s!=null)return s
throw A.h(A.kM(a,null,null))},
o2(a,b){a=A.a4(a,new Error())
if(a==null)a=A.f5(a)
a.stack=b.C(0)
throw a},
S(a,b,c,d){var s,r=c?J.h0(a,d):J.mi(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
e2(a,b){var s,r,q=A.j([],b.q("t<0>"))
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a1)(a),++r)B.c.G(q,b.a(a[r]))
return q},
w(a,b){var s,r
if(Array.isArray(a))return A.j(a.slice(0),b.q("t<0>"))
s=A.j([],b.q("t<0>"))
for(r=J.fb(a);r.D();)B.c.G(s,r.gO())
return s},
kT(a,b,c){var s,r=J.h0(a,c)
for(s=0;s<a;++s)B.c.h(r,s,b.$1(s))
return r},
eA(a,b,c){var s,r,q,p,o
A.df(b,"start")
s=c==null
r=!s
if(r){q=c-b
if(q<0)throw A.h(A.an(c,b,null,"end",null))
if(q===0)return""}if(Array.isArray(a)){p=a
o=p.length
if(s)c=o
return A.mt(b>0||c<o?p.slice(b,c):p)}if(t.bm.b(a))return A.p_(a,b,c)
if(r)a=J.nQ(a,c)
if(b>0)a=J.kE(a,b)
s=A.w(a,t.p)
return A.mt(s)},
p_(a,b,c){var s=a.length
if(b>=s)return""
return A.oS(a,b,c==null||c>s?s:c)},
mz(a,b,c){var s=J.fb(b)
if(!s.D())return a
if(c.length===0){do a+=A.z(s.gO())
while(s.D())}else{a+=A.z(s.gO())
while(s.D())a=a+c+A.z(s.gO())}return a},
oZ(){return A.bk(new Error())},
o0(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
lV(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
fq(a){if(a>=10)return""+a
return"0"+a},
ih(a){if(typeof a=="number"||A.kc(a)||a==null)return J.dx(a)
if(typeof a=="string")return JSON.stringify(a)
return A.oQ(a)},
o3(a,b){A.f8(a,"error",t.K)
A.f8(b,"stackTrace",t.l)
A.o2(a,b)},
fd(a){return new A.fc(a)},
c2(a,b){return new A.aX(!1,null,b,a)},
kG(a,b,c){return new A.aX(!0,a,b,c)},
oX(a){var s=null
return new A.de(s,s,!1,s,s,a)},
mx(a,b){return new A.de(null,null,!0,a,b,"Value not in range")},
an(a,b,c,d,e){return new A.de(b,c,!0,a,d,"Invalid value")},
bz(a,b,c){if(0>a||a>c)throw A.h(A.an(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.h(A.an(b,a,c,"end",null))
return b}return c},
df(a,b){if(a<0)throw A.h(A.an(a,0,null,b,null))
return a},
kP(a,b,c,d,e){return new A.fI(b,!0,a,e,"Index out of range")},
bh(a){return new A.eE(a)},
mC(a){return new A.hD(a)},
ld(a){return new A.dg(a)},
ba(a){return new A.fm(a)},
lX(a){return new A.jL(a)},
kM(a,b,c){return new A.io(a,b,c)},
on(a,b,c){var s,r
if(A.ly(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.j([],t.s)
B.c.G($.aL,a)
try{A.qM(a,s)}finally{if(0>=$.aL.length)return A.a($.aL,-1)
$.aL.pop()}r=A.mz(b,t.W.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
mh(a,b,c){var s,r
if(A.ly(a))return b+"..."+c
s=new A.ez(b)
B.c.G($.aL,a)
try{r=s
r.a=A.mz(r.a,a,", ")}finally{if(0>=$.aL.length)return A.a($.aL,-1)
$.aL.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
qM(a,b){var s,r,q,p,o,n,m,l=a.gH(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.D())return
s=A.z(l.gO())
B.c.G(b,s)
k+=s.length+2;++j}if(!l.D()){if(j<=5)return
if(0>=b.length)return A.a(b,-1)
r=b.pop()
if(0>=b.length)return A.a(b,-1)
q=b.pop()}else{p=l.gO();++j
if(!l.D()){if(j<=4){B.c.G(b,A.z(p))
return}r=A.z(p)
if(0>=b.length)return A.a(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gO();++j
for(;l.D();p=o,o=n){n=l.gO();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2;--j}B.c.G(b,"...")
return}}q=A.z(p)
r=A.z(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.a(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.c.G(b,m)
B.c.G(b,q)
B.c.G(b,r)},
kW(a,b,c){var s
if(B.ac===c){s=J.bJ(a)
b=J.bJ(b)
return A.le(A.eC(A.eC($.kA(),s),b))}s=J.bJ(a)
b=J.bJ(b)
c=J.bJ(c)
c=A.le(A.eC(A.eC(A.eC($.kA(),s),b),c))
return c},
n(a){var s,r,q=$.kA()
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.a1)(a),++r)q=A.eC(q,J.bJ(a[r]))
return A.le(q)},
fp:function fp(a,b,c){this.a=a
this.b=b
this.c=c},
jK:function jK(){},
T:function T(){},
fc:function fc(a){this.a=a},
bg:function bg(){},
aX:function aX(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
de:function de(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
fI:function fI(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
eE:function eE(a){this.a=a},
hD:function hD(a){this.a=a},
dg:function dg(a){this.a=a},
fm:function fm(a){this.a=a},
hc:function hc(){},
ey:function ey(){},
jL:function jL(a){this.a=a},
io:function io(a,b,c){this.a=a
this.b=b
this.c=c},
e:function e(){},
aj:function aj(){},
H:function H(){},
hS:function hS(){},
ez:function ez(a){this.a=a},
iW:function iW(a){this.a=a},
qm(a,b,c){t.Z.a(a)
if(A.o(c)>=1)return a.$1(b)
return a.$0()},
n6(a){return a==null||A.kc(a)||typeof a=="number"||typeof a=="string"||t.cu.b(a)||t.D.b(a)||t.go.b(a)||t.dQ.b(a)||t.h7.b(a)||t.k.b(a)||t.bv.b(a)||t.h4.b(a)||t.eT.b(a)||t.dI.b(a)||t.fd.b(a)},
lz(a){if(A.n6(a))return a
return new A.kp(new A.dq(t.hg)).$1(a)},
rI(a,b){var s=new A.ab($.a0,b.q("ab<0>")),r=new A.eQ(s,b.q("eQ<0>"))
a.then(A.f9(new A.kr(r,b),1),A.f9(new A.ks(r),1))
return s},
n5(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
ne(a){if(A.n5(a))return a
return new A.kh(new A.dq(t.hg)).$1(a)},
kp:function kp(a){this.a=a},
kr:function kr(a,b){this.a=a
this.b=b},
ks:function ks(a){this.a=a},
kh:function kh(a){this.a=a},
kO(a){var s=new A.dN()
s.ds(a)
return s},
dN:function dN(){this.a=$
this.b=0
this.c=2147483647},
jD:function jD(){},
k8:function k8(){},
jE:function jE(){},
k9:function k9(){},
o1(a,b,c,d){var s=A.lm(),r=A.lm(),q=A.lm(),p=new Uint16Array(16),o=new Uint32Array(573),n=new Uint8Array(573)
s=new A.id(a,c,s,r,q,p,o,n)
s.j8(b,d)
s.iE(B.a9)
return s},
lW(a,b,c,d){var s,r=b*2,q=a.length
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
lm(){return new A.jW()},
pR(a,b,c){var s,r,q,p,o,n,m,l=new Uint16Array(16)
for(s=0,r=1;r<=15;++r){s=s+c[r-1]<<1>>>0
if(!(r<16))return A.a(l,r)
l[r]=s}for(q=a.length,p=0;p<=b;++p){o=p*2
n=o+1
if(!(n<q))return A.a(a,n)
m=a[n]
if(m===0)continue
if(!(m>=0&&m<16))return A.a(l,m)
n=l[m]
if(!(m<16))return A.a(l,m)
l[m]=n+1
n=A.pS(n,m)
a.$flags&2&&A.c(a)
if(!(o<q))return A.a(a,o)
a[o]=n}},
pS(a,b){var s,r=0
do{s=A.aC(a,1)
r=(r|a&1)<<1>>>0
if(--b,b>0){a=s
continue}else break}while(!0)
return A.aC(r,1)},
mK(a){var s
if(a<256){if(!(a>=0))return A.a(B.ai,a)
s=B.ai[a]}else{s=256+A.aC(a,7)
if(!(s<512))return A.a(B.ai,s)
s=B.ai[s]}return s},
ln(a,b,c,d,e){return new A.jZ(a,b,c,d,e)},
aC(a,b){if(a>=0)return B.a.bg(a,b)
else return B.a.bg(a,b)+B.a.R(2,(~b>>>0)+65536&65535)},
dn:function dn(a,b){this.a=a
this.b=b},
id:function id(a,b,c,d,e,f,g,h){var _=this
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
_.bc=_.aS=_.bR=_.cf=_.bH=_.aN=_.bG=_.y2=_.y1=_.xr=$},
aV:function aV(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
jW:function jW(){this.c=this.b=this.a=$},
jZ:function jZ(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
iz:function iz(a,b,c,d){var _=this
_.a=a
_.b=null
_.c=b
_.e=_.d=0
_.r=c
_.w=d},
jC:function jC(){},
fh:function fh(a,b){this.a=a
this.b=b},
iA(a,b,c,d){var s,r,q=new A.fJ(b)
if(d==null)d=0
if(c==null)c=a.length-d
s=a.length
if(d+c>s)c=s-d
r=t.D.b(a)?a:new Uint8Array(A.r(a))
s=J.E(B.d.gB(r),r.byteOffset+d,c)
q.b=s
q.d=s.length
return q},
fJ:function fJ(a){var _=this
_.b=null
_.c=0
_.d=$
_.a=a},
fK:function fK(){},
mo(a,b){var s=b==null?32768:b
return new A.ef(new Uint8Array(s),a)},
ef:function ef(a,b){this.b=0
this.c=a
this.a=b},
he:function he(){},
lO(a,b,c){var s,r,q,p,o,n,m
if(b<1||b>9||c<1||c>9)throw A.h(new A.i6("BlurHash components must be between 1 and 9."))
s=a.aM(B.e)
r=J.d0(c,t.dL)
for(q=t.O,p=0;p<c;++p)r[p]=A.S(b,new A.bo(0,0,0),!1,q)
for(o=0;o<c;++o)for(q=o===0,n=0;n<b;++n){m=n===0&&q?1:2
if(!(o<r.length))return A.a(r,o)
B.c.h(r[o],n,A.qQ(s,n,o,m))}q=A.qq(r)
if(0>=r.length)return A.a(r,0)
return new A.i5(q)},
qq(a){var s,r,q,p,o,n,m,l=a.length
if(0>=l)return A.a(a,0)
s=a[0].length
r=A.S(s*l,new A.bo(0,0,0),!1,t.O)
for(q=0,p=0;p<l;++p)for(o=0;o<s;++o,q=n){n=q+1
if(!(p<a.length))return A.a(a,p)
m=a[p]
if(!(o<m.length))return A.a(m,o)
B.c.h(r,q,m[o])}return A.qr(r,s,l)},
qr(a,b,c){var s,r,q,p,o,n,m,l,k=B.c.gkC(a),j=A.dh(a,1,null,A.av(a).c).l3(0),i=A.i0(b-1+(c-1)*9,1)
if(j.length!==0){s=A.av(j)
r=Math.max(0,Math.min(82,B.b.bl(new A.b0(j,s.q("B(1)").a(A.rc()),s.q("b0<1,B>")).kY(0,B.cK)*166-0.5)))
q=(r+1)/166
i+=A.i0(r,1)}else{i+=A.i0(0,1)
q=1}i+=A.i0((A.lA(k.a)<<16>>>0)+(A.lA(k.b)<<8>>>0)+A.lA(k.c),4)
for(s=j.length,p=0;p<j.length;j.length===s||(0,A.a1)(j),++p,i=l){o=j[p]
n=o.a/q
m=o.b/q
l=o.c/q
l=i+A.i0(B.b.bl(Math.max(0,Math.min(18,Math.pow(Math.abs(n),0.5)*J.kD(n)*9+9.5)))*19*19+B.b.bl(Math.max(0,Math.min(18,Math.pow(Math.abs(m),0.5)*J.kD(m)*9+9.5)))*19+B.b.bl(Math.max(0,Math.min(18,Math.pow(Math.abs(l),0.5)*J.kD(l)*9+9.5))),2)}return i.charCodeAt(0)==0?i:i},
qO(a){t.O.a(a)
return Math.max(Math.abs(a.a),Math.max(Math.abs(a.b),Math.abs(a.c)))},
qQ(a,b,c,d){var s,r,q,p,o,n,m,l,k,j=null,i=0,h=0,g=0
if(a.gaC()>=3)for(s=a.a,s=s.gH(s),r=3.141592653589793*c,q=3.141592653589793*b;s.D();){p=s.gO()
o=p.gaU()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gaQ()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
l=d*n*Math.cos(r*o/m)
i+=l*A.kt(A.o(p.gm()))
h+=l*A.kt(A.o(p.gt()))
g+=l*A.kt(A.o(p.gu()))}else for(s=a.a,s=s.gH(s),r=3.141592653589793*c,q=3.141592653589793*b;s.D();){p=s.gO()
o=p.gaU()
n=a.a
n=n==null?j:n.a
if(n==null)n=0
n=Math.cos(q*o/n)
o=p.gaQ()
m=a.a
m=m==null?j:m.b
if(m==null)m=0
m=d*n*Math.cos(r*o/m)*A.kt(A.o(p.gm()))
i+=m
h+=m
g+=m}k=1/(a.gS()*a.gK())
return new A.bo(i*k,h*k,g*k)},
i5:function i5(a){this.a=a},
i6:function i6(a){this.a=a},
kt(a){var s=a/255
if(s<=0.04045)return s/12.92
return Math.pow((s+0.055)/1.055,2.4)},
lA(a){var s=B.b.P(a,0,1)
if(s<=0.0031308)return B.b.i(s*12.92*255+0.5)
return B.b.i((1.055*Math.pow(s,0.4166666666666667)-0.055)*255+0.5)},
bo:function bo(a,b,c){this.a=a
this.b=b
this.c=c},
ib:function ib(a,b){this.a=a
this.b=b},
P:function P(a){this.a=-1
this.b=a},
cB:function cB(a){this.a=a},
cC:function cC(a){this.a=a},
cD:function cD(a){this.a=a},
cE:function cE(a){this.a=a},
cF:function cF(a){this.a=a},
cG:function cG(a){this.a=a},
cI:function cI(a,b){this.a=a
this.b=b},
cJ:function cJ(a){this.a=a},
cK:function cK(a,b){this.a=a
this.b=b},
cL:function cL(a){this.a=a},
cM:function cM(a,b){this.a=a
this.b=b},
o_(a,b,c,d){var s=new A.cH(new Uint8Array(4))
s.hz(a,b,c,d)
return s},
bK:function bK(a){this.a=a},
fk:function fk(a){this.a=a},
cH:function cH(a){this.a=a},
dz:function dz(a){this.a=a},
fn:function fn(a){this.a=a},
hZ(a,b,c){var s
if(b===c)return a
switch(b.a){case 0:if(a===0)s=0
else{s=B.ce.l(0,c)
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
case 1:return B.b.i(B.b.P(a,0,1)*3)
case 2:return B.b.i(B.b.P(a,0,1)*15)
case 3:return B.b.i(B.b.P(a,0,1)*255)
case 4:return B.b.i(B.b.P(a,0,1)*65535)
case 5:return B.b.i(B.b.P(a,0,1)*4294967295)
case 6:return B.b.i(a<0?B.b.P(a,-1,1)*128:B.b.P(a,-1,1)*127)
case 7:return B.b.i(a<0?B.b.P(a,-1,1)*32768:B.b.P(a,-1,1)*32767)
case 8:return B.b.i(a<0?B.b.P(a,-1,1)*2147483648:B.b.P(a,-1,1)*2147483647)
case 9:case 10:case 11:return a}break}},
as:function as(a,b){this.a=a
this.b=b},
dH:function dH(a,b){this.a=a
this.b=b},
fe:function fe(a,b){this.a=a
this.b=b},
dD(a){var s=new A.bL(A.I(t.N,t.P))
s.hE(a)
return s},
kJ(a){var s=new A.bL(A.I(t.N,t.P))
s.ci(a)
return s},
bL:function bL(a){this.a=a},
hO:function hO(a,b){this.a=a
this.b=b},
i(a,b,c){return new A.ft(a,b)},
ft:function ft(a,b){this.a=a
this.b=b},
aN:function aN(a){this.a=a},
it:function it(a){this.a=a},
m3(a){var s=new A.aE(A.I(t.p,t.r),new A.aN(A.I(t.N,t.P)))
s.fR(a)
return s},
aE:function aE(a,b){this.a=a
this.b=b},
iu:function iu(a){this.a=a},
iv:function iv(a){this.a=a},
oi(a){var s=new Uint16Array(1)
s[0]=a
return new A.bt(s)},
mb(a,b){var s=new A.bt(new Uint16Array(b))
s.hJ(a,b)
return s},
m5(a){var s=new Uint32Array(1)
s[0]=a
return new A.aO(s)},
m6(a,b){var s=new A.aO(new Uint32Array(b))
s.hG(a,b)
return s},
m7(a,b){var s,r=J.d0(b,t.i)
for(s=0;s<b;++s)r[s]=new A.aS(a.k(),a.k())
return new A.bc(r)},
ma(a,b){var s=new A.bs(new Int16Array(b))
s.hI(a,b)
return s},
m8(a,b){var s=new A.br(new Int32Array(b))
s.hH(a,b)
return s},
m9(a,b){var s,r,q,p,o=J.d0(b,t.i)
for(s=0;s<b;++s){r=a.k()
q=$.N()
q.$flags&2&&A.c(q)
q[0]=r
r=$.a6()
if(0>=r.length)return A.a(r,0)
p=r[0]
q[0]=a.k()
o[s]=new A.aS(p,r[0])}return new A.be(o)},
mc(a,b){var s=new A.bO(new Float32Array(b))
s.hK(a,b)
return s},
m4(a,b){var s=new A.bN(new Float64Array(b))
s.hF(a,b)
return s},
ad:function ad(a,b){this.a=a
this.b=b},
a2:function a2(){},
aZ:function aZ(a){this.a=a},
c8:function c8(a){this.a=a},
bt:function bt(a){this.a=a},
aO:function aO(a){this.a=a},
bc:function bc(a){this.a=a},
bd:function bd(a){this.a=a},
bs:function bs(a){this.a=a},
br:function br(a){this.a=a},
be:function be(a){this.a=a},
bO:function bO(a){this.a=a},
bN:function bN(a){this.a=a},
bP:function bP(a){this.a=a},
c9:function c9(a){this.a=a},
ng(b6,b7,b8,b9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null
if(b7===B.cW)return b8.e8(b6)
s=b7.a
if(!(s<5))return A.a(B.bC,s)
r=B.bC[s]
q=b6.gK()
p=b6.gS()
o=b8.gM()
n=A.Q(b5,b5,B.e,0,B.j,q,b5,0,1,o,B.e,p,!1)
m=A.bv(b6,!1,!1)
for(l=r.length,s=o.b,k=2<s,j=1<s,i=0<s,h=o.c,g=h.length,f=0;f<q;++f)for(e=0;e!==p;++e){d=m.a
c=d==null?b5:d.N(e,f,b5)
if(c==null)c=new A.D()
b=B.b.i(c.l(0,0))
a=B.b.i(c.l(0,1))
a0=B.b.i(c.l(0,2))
a1=b8.hi(b,a,a0)
d=n.a
if(d!=null)d.aL(e,f,a1)
if(i){d=a1*s
if(!(d>=0&&d<g))return A.a(h,d)
a2=h[d]}else a2=0
if(j){d=a1*s+1
if(!(d>=0&&d<g))return A.a(h,d)
a3=h[d]}else a3=0
if(k){d=a1*s+2
if(!(d>=0&&d<g))return A.a(h,d)
a4=h[d]}else a4=0
a5=b-a2
a6=a-a3
a7=a0-a4
if(a5===0&&a6===0&&a7===0)continue
for(a8=0;a8!==l;++a8){if(!(a8>=0&&a8<l))return A.a(r,a8)
d=r[a8]
a9=B.b.i(d[1])
b0=B.b.i(d[2])
b1=a9+e
b2=!1
if(b1>=0)if(b1<p){b1=b0+f
b1=b1>=0&&b1<q}else b1=b2
else b1=b2
if(b1){b3=d[0]
d=m.a
b4=d==null?b5:d.N(e+a9,f+b0,b5)
if(b4==null)b4=new A.D()
b4.sm(b4.gm()+a5*b3)
b4.st(b4.gt()+a6*b3)
b4.su(b4.gu()+a7*b3)}}}return n},
fr:function fr(a,b){this.a=a
this.b=b},
lP(a){var s,r,q=new A.i9()
if(!A.kI(a))A.b8(A.m("Not a bitmap file."))
a.d+=2
s=a.k()
r=$.N()
r.$flags&2&&A.c(r)
r[0]=s
s=$.a6()
if(0>=s.length)return A.a(s,0)
a.d+=4
r[0]=a.k()
q.b=s[0]
return q},
kI(a){if(a.c-a.d<2)return!1
return A.p(a,null,0).n()===19778},
nS(a,b){var s,r,q,p,o=b==null?A.lP(a):b,n=a.d,m=a.k(),l=a.k(),k=$.N()
k.$flags&2&&A.c(k)
k[0]=l
l=$.a6()
if(0>=l.length)return A.a(l,0)
s=l[0]
k[0]=a.k()
l=l[0]
r=a.n()
q=a.n()
p=a.k()
if(!(p<14))return A.a(B.au,p)
p=B.au[p]
a.k()
k[0]=a.k()
k[0]=a.k()
k=a.k()
a.k()
n=new A.bn(o,s,l,m,r,q,p,k,n)
n.ej(a,b)
return n},
ac:function ac(a,b){this.a=a
this.b=b},
i9:function i9(){this.b=$},
bn:function bn(a,b,c,d,e,f,g,h,i){var _=this
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
ff:function ff(a){this.a=$
this.b=null
this.c=a},
i7:function i7(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
ie:function ie(a){this.a=$
this.b=null
this.c=a},
i8:function i8(){},
K:function K(){},
ic:function ic(){},
ig:function ig(){},
fu:function fu(){},
dU:function dU(a,b,c,d){var _=this
_.r=a
_.w=b
_.x=c
_.b=_.a=0
_.c=d},
cP:function cP(a,b){this.a=a
this.b=b},
c4:function c4(a,b){this.a=a
this.b=b},
fv:function fv(){var _=this
_.w=_.r=_.f=_.d=_.c=_.b=_.a=$},
lY(a,b,c,d){var s,r
switch(a.a){case 1:return new A.fT(c,b)
case 2:return new A.dV(c,d==null?1:d,b)
case 3:return new A.dV(c,d==null?16:d,b)
case 4:s=d==null?32:d
r=new A.fR(c,s,b)
r.hN(b,c,s)
return r
case 5:return new A.fS(c,d==null?16:d,b)
case 6:return new A.dU(c,d==null?32:d,!1,b)
case 7:return new A.dU(c,d==null?32:d,!0,b)
default:throw A.h(A.m("Invalid compression type: "+a.C(0)))}},
aY:function aY(a,b){this.a=a
this.b=b},
bp:function bp(){},
fP:function fP(){},
o7(a,b,c,d){var s,r,q,p,o,n,m,l
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
n=A.S(65537,0,!1,t.p)
m=J.am(16384,t.gV)
for(l=0;l<16384;++l)m[l]=new A.fw()
A.o8(a,b-20,r,q,n)
if(p>8*(b-(a.d-s)))throw A.h(A.m("Error in header for Huffman-encoded data (invalid number of bits)."))
A.o4(n,r,q,m)
A.o6(n,m,a,p,q,d,c)},
o6(a,b,c,d,e,f,g){var s,r,q,p,o,n,m,l,k,j="Error in Huffman-encoded data (invalid code).",i=A.j([0,0],t.t),h=c.d+B.a.X(d+7,8)
for(s=b.length,r=0;c.d<h;){A.kK(i,c)
while(q=i[1],q>=14){p=B.a.bg(i[0],q-14)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.h(i,1,q-p)
r=A.kL(o.b,e,i,c,g,r,f)}else{if(o.c==null)throw A.h(A.m(j))
for(n=0;n<o.b;++n){q=o.c
if(!(n<q.length))return A.a(q,n)
q=q[n]
if(!(q<65537))return A.a(a,q)
m=a[q]&63
for(;;){q=i[1]
if(!(q<m&&c.d<h))break
A.kK(i,c)}if(q>=m){p=o.c
if(!(n<p.length))return A.a(p,n)
p=p[n]
if(!(p<65537))return A.a(a,p)
q-=m
if(a[p]>>>6===(B.a.bg(i[0],q)&B.a.R(1,m)-1)>>>0){B.c.h(i,1,q)
q=o.c
if(!(n<q.length))return A.a(q,n)
l=A.kL(q[n],e,i,c,g,r,f)
r=l
break}}}if(n===o.b)throw A.h(A.m(j))}}}k=8-d&7
B.c.h(i,0,B.a.j(i[0],k))
B.c.h(i,1,i[1]-k)
while(q=i[1],q>0){p=B.a.V(i[0],14-q)&16383
if(!(p<s))return A.a(b,p)
o=b[p]
p=o.a
if(p!==0){B.c.h(i,1,q-p)
r=A.kL(o.b,e,i,c,g,r,f)}else throw A.h(A.m(j))}if(r!==f)throw A.h(A.m("Error in Huffman-encoded data (decoded data are shorter than expected)."))},
kL(a,b,c,d,e,f,g){var s,r,q,p,o,n,m="Error in Huffman-encoded data (decoded data are longer than expected)."
if(a===b){if(c[1]<8)A.kK(c,d)
B.c.h(c,1,c[1]-8)
s=B.a.bg(c[0],c[1])&255
if(f+s>g)throw A.h(A.m(m))
r=f-1
q=e.length
if(!(r>=0&&r<q))return A.a(e,r)
p=e[r]
for(r=e.$flags|0;o=s-1,s>0;s=o,f=n){n=f+1
r&2&&A.c(e)
if(!(f<q))return A.a(e,f)
e[f]=p}}else{if(f<g){e.toString
n=f+1
e.$flags&2&&A.c(e)
if(!(f<e.length))return A.a(e,f)
e[f]=a}else throw A.h(A.m(m))
f=n}return f},
o4(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i="Error in Huffman-encoded data (invalid code table entry)."
for(s=d.length,r=t.t,q=t.p;b<=c;++b){if(!(b<65537))return A.a(a,b)
p=a[b]
o=p>>>6
n=p&63
if(B.a.a4(o,n)!==0)throw A.h(A.m(i))
if(n>14){p=B.a.a5(o,n-14)
if(!(p<s))return A.a(d,p)
m=d[p]
if(m.a!==0)throw A.h(A.m(i))
p=++m.b
l=m.c
if(l!=null){m.sh3(A.S(p,0,!1,q))
for(k=0;k<m.b-1;++k){p=m.c
p.toString
if(!(k<l.length))return A.a(l,k)
B.c.h(p,k,l[k])}}else m.sh3(A.j([0],r))
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
o8(a,b,c,d,e){var s,r,q,p,o,n="Error in Huffman-encoded data (unexpected end of code table data).",m="Error in Huffman-encoded data (code table is longer than expected).",l=a.d,k=A.j([0,0],t.t)
for(s=d+1;c<=d;++c){if(a.d-l>b)throw A.h(A.m(n))
r=A.lZ(6,k,a)
B.c.h(e,c,r)
if(r===63){if(a.d-l>b)throw A.h(A.m(n))
q=A.lZ(8,k,a)+6
if(c+q>s)throw A.h(A.m(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.h(e,c,0)}--c}else if(r>=59){q=r-59+2
if(c+q>s)throw A.h(A.m(m))
for(;p=q-1,q!==0;q=p,c=o){o=c+1
B.c.h(e,c,0)}--c}}A.o5(e)},
o5(a){var s,r,q,p,o,n=A.S(59,0,!1,t.p)
for(s=0;s<65537;++s){r=a[s]
if(!(r<59))return A.a(n,r)
B.c.h(n,r,n[r]+1)}for(q=0,s=58;s>0;--s,q=p){p=q+n[s]>>>1
B.c.h(n,s,q)}for(s=0;s<65537;++s){o=a[s]
if(o>0){if(!(o<59))return A.a(n,o)
r=n[o]
B.c.h(n,o,r+1)
B.c.h(a,s,(o|r<<6)>>>0)}}},
kK(a,b){B.c.h(a,0,((a[0]<<8|b.F())&-1)>>>0)
B.c.h(a,1,(a[1]+8&-1)>>>0)},
lZ(a,b,c){var s
while(s=b[1],s<a){B.c.h(b,0,((b[0]<<8|J.d(c.a,c.d++))&-1)>>>0)
B.c.h(b,1,(b[1]+8&-1)>>>0)}B.c.h(b,1,s-a)
return(B.a.bg(b[0],b[1])&B.a.R(1,a)-1)>>>0},
fw:function fw(){this.b=this.a=0
this.c=null},
o9(a){var s=A.v(a,!1,null,0)
if(s.k()!==20000630)return!1
if(s.F()!==2)return!1
if((s.bp()&4294967289)>>>0!==0)return!1
return!0},
fx:function fx(a){var _=this
_.b=_.a=0
_.c=a
_.d=null
_.e=$},
me(a,b,c){var s=new A.fQ(a,A.j([],t.g9),A.I(t.N,t.aX),B.bc,b)
s.hC(a,b,c)
return s},
dE:function dE(){},
ij:function ij(a,b){this.a=a
this.b=b},
fQ:function fQ(a,b,c,d,e){var _=this
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
fR:function fR(a,b,c){var _=this
_.r=null
_.w=a
_.x=b
_.y=$
_.z=null
_.b=_.a=0
_.c=c},
f_:function f_(){var _=this
_.f=_.e=_.d=_.c=_.b=_.a=$},
fS:function fS(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
fT:function fT(a,b){var _=this
_.r=null
_.w=a
_.b=_.a=0
_.c=b},
dV:function dV(a,b,c){var _=this
_.w=a
_.x=b
_.y=null
_.b=_.a=0
_.c=c},
ii:function ii(){this.a=null},
m0(a){var s=new Uint8Array(a*3)
return new A.dI(A.og(a),a,null,new A.aH(s,a,3))},
of(a){return new A.dI(a.a,a.b,a.c,A.mp(a.d))},
og(a){var s
for(s=1;s<=8;++s)if(B.a.R(1,s)>=a)return s
return 0},
dI:function dI(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dJ:function dJ(){},
fU:function fU(){var _=this
_.e=_.d=_.c=_.b=_.a=$
_.f=null
_.r=80
_.w=0
_.x=-1
_.y=$},
dK:function dK(a){var _=this
_.b=_.a=0
_.e=_.c=null
_.r=a},
ip:function ip(){var _=this
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
iq:function iq(){var _=this
_.b=0
_.y=_.x=_.w=null
_.Q=_.z=$
_.db=_.cy=_.cx=_.CW=_.ch=_.ay=_.ax=_.at=_.as=0
_.dx=!1
_.dy=$
_.fr=0
_.fx=null},
ir:function ir(a,b){this.a=a
this.b=b},
m2(a){var s,r,q,p
if(a.n()!==0)return null
s=a.n()
if(s>=3)return null
if(B.dk[s]===B.be)return null
r=a.n()
q=J.d0(r,t.gx)
for(p=0;p<r;++p){J.d(a.a,a.d++)
J.d(a.a,a.d++)
J.d(a.a,a.d++);++a.d
a.n()
a.n()
q[p]=new A.fG(a.k(),a.k())}return new A.fF(r,q)},
cR:function cR(a,b){this.a=a
this.b=b},
fF:function fF(a,b){this.d=a
this.e=b},
fG:function fG(a,b){this.d=a
this.e=b},
fD:function fD(a,b,c,d,e,f,g,h,i){var _=this
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
is:function is(){this.b=this.a=null},
jB:function jB(){},
fE:function fE(){},
fl:function fl(a,b,c){this.e=a
this.f=b
this.r=c},
bM:function bM(){},
c7:function c7(a){this.a=a},
dP:function dP(a){this.a=a},
iE:function iE(){this.d=null},
bx:function bx(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.y=_.x=_.w=_.r=_.f=_.e=$},
ml(){var s=A.S(4,null,!1,t.bC),r=A.j([],t.f8),q=t.eA,p=J.h0(0,q)
q=J.h0(0,q)
return new A.iG(new A.bL(A.I(t.N,t.P)),s,r,p,q,A.j([],t.eB))},
iG:function iG(a,b,c,d,e,f){var _=this
_.b=_.a=$
_.r=_.e=_.d=_.c=null
_.w=a
_.x=b
_.y=c
_.z=d
_.Q=e
_.as=f},
iH:function iH(a,b){this.a=a
this.b=b},
dr:function dr(a){this.a=a
this.b=0},
h3:function h3(a,b){var _=this
_.e=_.d=_.c=_.b=null
_.r=_.f=0
_.x=_.w=$
_.y=a
_.z=b},
iJ:function iJ(){this.r=this.f=$},
h4:function h4(a,b,c,d,e,f,g,h){var _=this
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
h2:function h2(){},
iF:function iF(a,b){this.a=a
this.b=b},
iI:function iI(a,b,c,d,e,f,g,h,i){var _=this
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
d7:function d7(a,b){this.a=a
this.b=b},
eq:function eq(a,b){this.a=a
this.b=b},
er:function er(){},
fV:function fV(a,b,c,d,e,f,g,h,i){var _=this
_.y=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g
_.w=h
_.x=i},
mf(){var s=t.N
return new A.fW(A.I(s,s),A.j([],t.dm),A.j([],t.t))},
bS:function bS(a,b){this.a=a
this.b=b},
hk:function hk(){},
fW:function fW(a,b,c){var _=this
_.c=_.b=_.a=0
_.d=-1
_.r=_.f=0
_.z=_.x=_.w=null
_.Q=""
_.at=null
_.ax=a
_.ch=1
_.cx=b
_.cy=c},
hh:function hh(a){var _=this
_.a=a
_.c=_.b=0
_.d=$
_.e=0},
oG(){return new A.hi()},
hj:function hj(a,b){this.a=a
this.b=b},
hi:function hi(){var _=this
_.a=null
_.c=0
_.e=$
_.f=0
_.r=!1
_.w=null},
bT:function bT(a,b){this.a=a
this.b=b},
bU:function bU(a){this.b=this.a=0
this.e=a},
iZ:function iZ(a){this.b=this.a=null
this.c=a},
j_:function j_(){},
hm:function hm(){this.a=null},
hn:function hn(){this.a=null},
bf:function bf(){},
hq:function hq(){this.a=null},
hr:function hr(){this.a=null},
ht:function ht(){this.a=null},
hu:function hu(){this.a=null},
eu:function eu(a){this.b=a},
hs:function hs(){},
j0:function j0(){var _=this
_.w=_.r=_.f=_.e=$},
cq:function cq(a){this.a=a
this.c=null},
mv(a){var s=new A.ho(A.I(t.p,t.fh))
s.hP(a)
return s},
l7(a,b,c,d){var s=a/255,r=b/255,q=c/255,p=d/255,o=r*(1-q),n=s*(1-p)
return B.b.i(B.b.P((2*s<q?2*r*s+o+n:p*q-2*(q-s)*(p-r)+o+n)*255,0,255))},
j2(a,b){if(b===0)return 0
return B.a.i(B.a.P(B.b.i(255*(1-(1-a/255)/(b/255))),0,255))},
j4(a,b){return B.a.i(B.a.P(a+b-255,0,255))},
l9(a,b){return B.a.i(B.a.P(255-(255-b)*(255-a),0,255))},
j3(a,b){if(b===255)return 255
return B.b.i(B.b.P(a/255/(1-b/255)*255,0,255))},
la(a,b){var s=a/255,r=b/255,q=1-r
return B.b.bq(255*(q*r*s+r*(1-q*(1-s))))},
l5(a,b){var s=b/255,r=a/255
if(r<0.5)return B.b.bq(510*s*r)
else return B.b.bq(255*(1-2*(1-s)*(1-r)))},
lb(a,b){if(b<128)return A.j2(a,2*b)
else return A.j3(a,2*(b-128))},
l6(a,b){var s
if(b<128)return A.j4(a,2*b)
else{s=2*(b-128)
return s+a>255?255:a+s}},
l8(a,b){return b<128?Math.min(a,2*b):Math.max(a,2*(b-128))},
l4(a,b){return B.b.bq(b+a-2*b*a/255)},
aB(a,b,c){var s,r,q
if(a==null)s=0
else{s=a.length
if(c===1){if(!(b>=0&&b<s))return A.a(a,b)
s=a[b]}else{if(!(b>=0&&b<s))return A.a(a,b)
r=a[b]
q=b+1
if(!(q<s))return A.a(a,q)
q=(r<<8|a[q])>>>8
s=q}}return s},
mw(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=null,b6=A.I(t.p,t.fW)
for(s=c1.length,r=0;q=c1.length,r<q;c1.length===s||(0,A.a1)(c1),++r){p=c1[r]
b6.h(0,p.a,p)}if(b8===8)o=1
else o=b8===16?2:-1
n=A.Q(b5,b5,B.e,0,B.j,c0,b5,0,q,b5,B.e,b9,!1)
if(o===-1)throw A.h(A.m("PSD: unsupported bit depth: "+A.z(b8)))
m=b6.l(0,0)
l=b6.l(0,1)
k=b6.l(0,2)
j=b6.l(0,-1)
i=A.j([0,0,0],t.t)
h=-o
for(s=n.a,s=s.gH(s),g=q>=5,f=q===4,e=q>=2,q=q>=4;s.D();){d=s.gO()
h+=o
switch(b7){case B.co:d.sm(A.aB(m.c,h,o))
d.st(A.aB(l.c,h,o))
d.su(A.aB(k.c,h,o))
d.sA(q?A.aB(j.c,h,o):255)
if(d.gA()!==0){d.sm((d.gm()+d.gA()-255)*255/d.gA())
d.st((d.gt()+d.gA()-255)*255/d.gA())
d.su((d.gu()+d.gA()-255)*255/d.gA())}break
case B.cq:c=A.aB(m.c,h,o)
b=A.aB(l.c,h,o)
a=A.aB(k.c,h,o)
a0=q?A.aB(j.c,h,o):255
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
a7=a2*3.2406+a1*-1.5372+a3*-0.4986
a8=a2*-0.9689+a1*1.8758+a3*0.0415
a9=a2*0.0557+a1*-0.204+a3*1.057
a7=a7>0.0031308?1.055*Math.pow(a7,0.4166666666666667)-0.055:12.92*a7
a8=a8>0.0031308?1.055*Math.pow(a8,0.4166666666666667)-0.055:12.92*a8
a9=a9>0.0031308?1.055*Math.pow(a9,0.4166666666666667)-0.055:12.92*a9
b0=[B.b.i(B.b.P(a7*255,0,255)),B.b.i(B.b.P(a8*255,0,255)),B.b.i(B.b.P(a9*255,0,255))]
d.sm(b0[0])
d.st(b0[1])
d.su(b0[2])
d.sA(a0)
break
case B.cn:b1=A.aB(m.c,h,o)
a0=e?A.aB(j.c,h,o):255
d.sm(b1)
d.st(b1)
d.su(b1)
d.sA(a0)
break
case B.cp:b2=A.aB(m.c,h,o)
b3=A.aB(l.c,h,o)
a1=A.aB(k.c,h,o)
b4=A.aB(b6.l(0,f?-1:3).c,h,o)
a0=g?A.aB(j.c,h,o):255
A.nd(255-b2,255-b3,255-a1,255-b4,i)
d.sm(i[0])
d.st(i[1])
d.su(i[2])
d.sA(a0)
break
default:throw A.h(A.m("Unhandled color mode: "+A.z(b7)))}}return n},
b2:function b2(a,b){this.a=a
this.b=b},
ho:function ho(a){var _=this
_.b=_.a=0
_.d=_.c=null
_.e=$
_.r=_.f=null
_.x=_.w=$
_.y=null
_.z=a
_.as=$
_.ay=_.ax=_.at=null},
hp:function hp(){},
et:function et(a,b,c){var _=this
_.b=_.a=null
_.f=_.e=_.d=_.c=$
_.r=null
_.as=_.y=_.w=$
_.ay=a
_.ch=b
_.cx=null
_.cy=c},
oU(a,b){var s
switch(a){case"lsct":s=b.c-b.d
b.k()
if(s>=12){if(b.ak(4)!=="8BIM")A.b8(A.m("Invalid key in layer additional data"))
b.ak(4)}if(s>=16)b.k()
return new A.hs()
default:return new A.eu(b)}},
da:function da(){},
j1:function j1(){this.a=null},
hv:function hv(){},
aR:function aR(a,b,c){this.a=a
this.b=b
this.c=c},
L:function L(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
dd:function dd(a,b,c){this.a=a
this.b=b
this.$ti=c},
db:function db(){var _=this
_.Q=_.z=_.y=_.f=_.d=_.b=_.a=0},
dc:function dc(a){var _=this
_.b=0
_.c=a
_.Q=_.r=_.f=0},
ev:function ev(){this.y=this.b=this.a=0},
a5(a,b){var s,r=a>>>8
if(!(r<256))return A.a(B.V,r)
r=B.V[r]
s=b>>>8
if(!(s<256))return A.a(B.V,s)
return(r<<17|B.V[s]<<16|B.V[a&255]<<1|B.V[b&255])>>>0},
a3:function a3(a){var _=this
_.a=a
_.b=0
_.c=!1
_.d=0
_.e=!1
_.f=0
_.r=!1},
j5:function j5(){this.b=this.a=null},
oV(a,b,c){var s=new A.j7(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dd(r.cK(),q.cK(),t.aN)
p.G(0,s.$2(1,0))
p.G(0,s.$2(2,0))
p.G(0,s.$2(3,0))
p.G(0,s.$2(0,1))
p.G(0,s.$2(1,1))
p.G(0,s.$2(1,2))
p.G(0,s.$2(1,3))
p.G(0,s.$2(2,0))
p.G(0,s.$2(2,1))
p.G(0,s.$2(2,2))
p.G(0,s.$2(2,3))
p.G(0,s.$2(3,0))
p.G(0,s.$2(3,1))
p.G(0,s.$2(3,2))
p.G(0,s.$2(3,3))
return p},
oW(a,b,c){var s=new A.j8(a,b,c),r=s.$2(0,0),q=s.$2(0,0),p=new A.dd(r.cK(),q.cK(),t.eZ)
p.G(0,s.$2(1,0))
p.G(0,s.$2(2,0))
p.G(0,s.$2(3,0))
p.G(0,s.$2(0,1))
p.G(0,s.$2(1,1))
p.G(0,s.$2(1,2))
p.G(0,s.$2(1,3))
p.G(0,s.$2(2,0))
p.G(0,s.$2(2,1))
p.G(0,s.$2(2,2))
p.G(0,s.$2(2,3))
p.G(0,s.$2(3,0))
p.G(0,s.$2(3,1))
p.G(0,s.$2(3,2))
p.G(0,s.$2(3,3))
return p},
ew:function ew(a,b){this.a=a
this.b=b},
j6:function j6(){},
j7:function j7(a,b,c){this.a=a
this.b=b
this.c=c},
j8:function j8(a,b,c){this.a=a
this.b=b
this.c=c},
eD:function eD(a){var _=this
_.b=_.a=0
_.c=a
_.Q=_.z=_.y=_.x=_.f=_.e=0
_.as=null
_.ax=0},
au:function au(a,b){this.a=a
this.b=b},
jb:function jb(){this.a=null
this.b=$},
jc:function jc(){},
jd:function jd(a){this.a=a
this.c=this.b=0},
hA:function hA(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=null
_.f=e},
lf(a,b,c){var s=new A.jg(b,a),r=t.I
s.e=A.S(b,null,!1,r)
s.f=A.S(b,null,!1,r)
return s},
jg:function jg(a,b){var _=this
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
hB:function hB(a,b,c,d){var _=this
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
cr:function cr(a,b){this.a=a
this.b=b},
a7:function a7(a,b){this.a=a
this.b=b},
aU:function aU(a,b){this.a=a
this.b=b},
hC:function hC(a){var _=this
_.b=_.a=0
_.d=null
_.f=a},
mm(){return new A.iT(new Uint8Array(4096))},
iT:function iT(a){var _=this
_.a=9
_.d=_.c=_.b=0
_.w=_.r=_.f=_.e=$
_.x=a
_.z=_.y=$
_.Q=null
_.as=$},
je:function je(){this.a=null
this.c=$},
jf:function jf(){},
lg(a,b){var s=new Int32Array(4),r=new Int32Array(4),q=new Int8Array(4),p=new Int8Array(4),o=A.S(8,null,!1,t.eW),n=A.S(4,null,!1,t.dP)
return new A.jl(a,b,new A.jr(),new A.ju(),new A.jn(s,r),new A.jw(q,p),o,n,new Uint8Array(4))},
mF(a,b,c){if(c===0)if(a===0)return b===0?6:5
else return b===0?4:0
return c},
jl:function jl(a,b,c,d,e,f,g,h,i){var _=this
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
_.bG=$
_.aN=null
_.bH=$
_.bR=_.cf=null
_.aS=$},
jx:function jx(){},
mD(a){var s=new A.eG(a)
s.b=254
s.c=0
s.d=-8
return s},
eG:function eG(a){var _=this
_.a=a
_.d=_.c=_.b=$
_.e=!1},
F(a,b,c){return B.a.aB(B.a.j(a+2*b+c+2,2),32)},
pc(a){var s,r=A.j([A.F(J.d(a.a,a.d+-33),J.d(a.a,a.d+-32),J.d(a.a,a.d+-31)),A.F(J.d(a.a,a.d+-32),J.d(a.a,a.d+-31),J.d(a.a,a.d+-30)),A.F(J.d(a.a,a.d+-31),J.d(a.a,a.d+-30),J.d(a.a,a.d+-29)),A.F(J.d(a.a,a.d+-30),J.d(a.a,a.d+-29),J.d(a.a,a.d+-28))],t.t)
for(s=0;s<4;++s)a.c4(s*32,4,r)},
p4(a){var s=J.d(a.a,a.d+-33),r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=A.p(a,null,0),m=n.cU(),l=A.F(s,r,q)
m.$flags&2&&A.c(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.cU()
m=A.F(r,q,p)
l.$flags&2&&A.c(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m
n.d+=32
m=n.cU()
l=A.F(q,p,o)
m.$flags&2&&A.c(m)
if(0>=m.length)return A.a(m,0)
m[0]=16843009*l
n.d+=32
l=n.cU()
m=A.F(p,o,o)
l.$flags&2&&A.c(l)
if(0>=l.length)return A.a(l,0)
l[0]=16843009*m},
p2(a){var s,r,q,p
for(s=4,r=0;r<4;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
s=B.a.j(s,3)
for(r=0;r<4;++r){q=a.a
p=a.d+r*32
J.bl(q,p,p+4,s)}},
lh(a,b){var s,r,q,p,o,n,m=255-J.d(a.a,a.d+-33)
for(s=0,r=0;r<b;++r){q=m+J.d(a.a,a.d+(s-1))
for(p=0;p<b;++p){o=$.aD()
n=q+J.d(a.a,a.d+(-32+p))
if(!(n>=0&&n<766))return A.a(o,n)
n=o[n]
J.y(a.a,a.d+(s+p),n)}s+=32}},
pa(a){A.lh(a,4)},
pb(a){A.lh(a,8)},
p9(a){A.lh(a,16)},
p8(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95),n=J.d(a.a,a.d+-33),m=J.d(a.a,a.d+-32),l=J.d(a.a,a.d+-31),k=J.d(a.a,a.d+-30),j=J.d(a.a,a.d+-29)
a.h(0,96,A.F(q,p,o))
s=A.F(r,q,p)
a.h(0,97,s)
a.h(0,64,s)
s=A.F(n,r,q)
a.h(0,98,s)
a.h(0,65,s)
a.h(0,32,s)
s=A.F(m,n,r)
a.h(0,99,s)
a.h(0,66,s)
a.h(0,33,s)
a.h(0,0,s)
s=A.F(l,m,n)
a.h(0,67,s)
a.h(0,34,s)
a.h(0,1,s)
s=A.F(k,l,m)
a.h(0,35,s)
a.h(0,2,s)
a.h(0,3,A.F(j,k,l))},
p7(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.h(0,0,A.F(r,q,p))
s=A.F(q,p,o)
a.h(0,32,s)
a.h(0,1,s)
s=A.F(p,o,n)
a.h(0,64,s)
a.h(0,33,s)
a.h(0,2,s)
s=A.F(o,n,m)
a.h(0,96,s)
a.h(0,65,s)
a.h(0,34,s)
a.h(0,3,s)
s=A.F(n,m,l)
a.h(0,97,s)
a.h(0,66,s)
a.h(0,35,s)
s=A.F(m,l,k)
a.h(0,98,s)
a.h(0,67,s)
a.h(0,99,A.F(l,k,k))},
pe(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+-33),o=J.d(a.a,a.d+-32),n=J.d(a.a,a.d+-31),m=J.d(a.a,a.d+-30),l=J.d(a.a,a.d+-29),k=B.a.aB(B.a.j(p+o+1,1),32)
a.h(0,65,k)
a.h(0,0,k)
k=B.a.aB(B.a.j(o+n+1,1),32)
a.h(0,66,k)
a.h(0,1,k)
k=B.a.aB(B.a.j(n+m+1,1),32)
a.h(0,67,k)
a.h(0,2,k)
a.h(0,3,B.a.aB(B.a.j(m+l+1,1),32))
a.h(0,96,A.F(q,r,s))
a.h(0,64,A.F(r,s,p))
k=A.F(s,p,o)
a.h(0,97,k)
a.h(0,32,k)
k=A.F(p,o,n)
a.h(0,98,k)
a.h(0,33,k)
k=A.F(o,n,m)
a.h(0,99,k)
a.h(0,34,k)
a.h(0,35,A.F(n,m,l))},
pd(a){var s,r=J.d(a.a,a.d+-32),q=J.d(a.a,a.d+-31),p=J.d(a.a,a.d+-30),o=J.d(a.a,a.d+-29),n=J.d(a.a,a.d+-28),m=J.d(a.a,a.d+-27),l=J.d(a.a,a.d+-26),k=J.d(a.a,a.d+-25)
a.h(0,0,B.a.aB(B.a.j(r+q+1,1),32))
s=B.a.aB(B.a.j(q+p+1,1),32)
a.h(0,64,s)
a.h(0,1,s)
s=B.a.aB(B.a.j(p+o+1,1),32)
a.h(0,65,s)
a.h(0,2,s)
s=B.a.aB(B.a.j(o+n+1,1),32)
a.h(0,66,s)
a.h(0,3,s)
a.h(0,32,A.F(r,q,p))
s=A.F(q,p,o)
a.h(0,96,s)
a.h(0,33,s)
s=A.F(p,o,n)
a.h(0,97,s)
a.h(0,34,s)
s=A.F(o,n,m)
a.h(0,98,s)
a.h(0,35,s)
a.h(0,67,A.F(n,m,l))
a.h(0,99,A.F(m,l,k))},
p5(a){var s,r=J.d(a.a,a.d+-1),q=J.d(a.a,a.d+31),p=J.d(a.a,a.d+63),o=J.d(a.a,a.d+95)
a.h(0,0,B.a.aB(B.a.j(r+q+1,1),32))
s=B.a.aB(B.a.j(q+p+1,1),32)
a.h(0,32,s)
a.h(0,2,s)
s=B.a.aB(B.a.j(p+o+1,1),32)
a.h(0,64,s)
a.h(0,34,s)
a.h(0,1,A.F(r,q,p))
s=A.F(q,p,o)
a.h(0,33,s)
a.h(0,3,s)
s=A.F(p,o,o)
a.h(0,65,s)
a.h(0,35,s)
a.h(0,99,o)
a.h(0,98,o)
a.h(0,97,o)
a.h(0,96,o)
a.h(0,66,o)
a.h(0,67,o)},
p3(a){var s=J.d(a.a,a.d+-1),r=J.d(a.a,a.d+31),q=J.d(a.a,a.d+63),p=J.d(a.a,a.d+95),o=J.d(a.a,a.d+-33),n=J.d(a.a,a.d+-32),m=J.d(a.a,a.d+-31),l=J.d(a.a,a.d+-30),k=B.a.aB(B.a.j(s+o+1,1),32)
a.h(0,34,k)
a.h(0,0,k)
k=B.a.aB(B.a.j(r+s+1,1),32)
a.h(0,66,k)
a.h(0,32,k)
k=B.a.aB(B.a.j(q+r+1,1),32)
a.h(0,98,k)
a.h(0,64,k)
a.h(0,96,B.a.aB(B.a.j(p+q+1,1),32))
a.h(0,3,A.F(n,m,l))
a.h(0,2,A.F(o,n,m))
k=A.F(s,o,n)
a.h(0,35,k)
a.h(0,1,k)
k=A.F(r,s,o)
a.h(0,67,k)
a.h(0,33,k)
k=A.F(q,r,s)
a.h(0,99,k)
a.h(0,65,k)
a.h(0,97,A.F(p,q,r))},
pp(a){var s
for(s=0;s<16;++s)a.bn(s*32,16,a,-32)},
pn(a){var s,r,q,p,o
for(s=0,r=16;r>0;--r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.bl(p,o,o+16,q)
s+=32}},
jp(a,b){var s,r,q
for(s=0;s<16;++s){r=b.a
q=b.d+s*32
J.bl(r,q,q+16,a)}},
pf(a){var s,r
for(s=16,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))+J.d(a.a,a.d+(r-32))
A.jp(B.a.j(s,5),a)},
ph(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.jp(B.a.j(s,4),a)},
pg(a){var s,r
for(s=8,r=0;r<16;++r)s+=J.d(a.a,a.d+(r-32))
A.jp(B.a.j(s,4),a)},
pi(a){A.jp(128,a)},
pq(a){var s
for(s=0;s<8;++s)a.bn(s*32,8,a,-32)},
po(a){var s,r,q,p,o
for(s=0,r=0;r<8;++r){q=J.d(a.a,a.d+(s-1))
p=a.a
o=a.d+s
J.bl(p,o,o+8,q)
s+=32}},
jq(a,b){var s,r,q
for(s=0;s<8;++s){r=b.a
q=b.d+s*32
J.bl(r,q,q+8,a)}},
pj(a){var s,r
for(s=8,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))+J.d(a.a,a.d+(-1+r*32))
A.jq(B.a.j(s,4),a)},
pk(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(r-32))
A.jq(B.a.j(s,3),a)},
pl(a){var s,r
for(s=4,r=0;r<8;++r)s+=J.d(a.a,a.d+(-1+r*32))
A.jq(B.a.j(s,3),a)},
pm(a){A.jq(128,a)},
bV(a,b,c,d,e){var s=b+c+d*32,r=J.d(a.a,a.d+s)+B.a.j(e,3)
if(!((r&-256)>>>0===0))r=r<0?0:255
a.h(0,s,r)},
jo(a,b,c,d,e){A.bV(a,0,0,b,c+d)
A.bV(a,0,1,b,c+e)
A.bV(a,0,2,b,c-e)
A.bV(a,0,3,b,c-d)},
p6(){var s,r,q,p
if(!$.mE){for(s=-255;s<=255;++s){r=$.i3()
q=255+s
p=s<0?-s:s
r.$flags&2&&A.c(r)
r[q]=p
p=$.kw()
r=B.a.j(r[q],1)
p.$flags&2&&A.c(p)
p[q]=r}for(s=-1020;s<=1020;++s){r=$.kx()
if(s<-128)q=-128
else q=s>127?127:s
r.$flags&2&&A.c(r)
r[1020+s]=q}for(s=-112;s<=112;++s){r=$.ky()
if(s<-16)q=-16
else q=s>15?15:s
r.$flags&2&&A.c(r)
r[112+s]=q}for(s=-255;s<=510;++s){r=$.aD()
if(s<0)q=0
else q=s>255?255:s
r.$flags&2&&A.c(r)
r[255+s]=q}$.mE=!0}},
jm:function jm(){},
p1(){var s,r=J.am(3,t.D)
for(s=0;s<3;++s)r[s]=new Uint8Array(11)
return new A.eF(r)},
pG(){var s,r,q,p,o=new Uint8Array(3),n=J.am(4,t.c7)
for(s=t.dd,r=0;r<4;++r){q=J.am(8,s)
for(p=0;p<8;++p)q[p]=A.p1()
n[r]=q}B.d.aO(o,0,3,255)
return new A.jv(o,n)},
jr:function jr(){this.d=$},
ju:function ju(){},
jw:function jw(a,b){var _=this
_.b=_.a=!1
_.c=!0
_.d=a
_.e=b},
eF:function eF(a){this.a=a},
jv:function jv(a,b){this.a=a
this.b=b},
jn:function jn(a,b){var _=this
_.a=$
_.b=null
_.d=_.c=$
_.e=a
_.f=b},
bE:function bE(){var _=this
_.b=_.a=0
_.c=!1
_.d=0},
eI:function eI(){this.b=this.a=0},
hJ:function hJ(a,b,c){this.a=a
this.b=b
this.c=c},
eJ:function eJ(a,b){var _=this
_.a=a
_.b=$
_.c=b
_.e=_.d=null
_.f=$},
eK:function eK(a,b,c){this.a=a
this.b=b
this.c=c},
li(a,b){var s,r=A.j([],t.e),q=A.j([],t.gk),p=new Uint32Array(2),o=new A.hH(a,p)
p=o.d=J.E(B.o.gB(p),0,null)
s=a.F()
p.$flags&2&&A.c(p)
if(0>=p.length)return A.a(p,0)
p[0]=s
s=a.F()
p.$flags&2&&A.c(p)
if(1>=p.length)return A.a(p,1)
p[1]=s
s=a.F()
p.$flags&2&&A.c(p)
if(2>=p.length)return A.a(p,2)
p[2]=s
s=a.F()
p.$flags&2&&A.c(p)
if(3>=p.length)return A.a(p,3)
p[3]=s
s=a.F()
p.$flags&2&&A.c(p)
if(4>=p.length)return A.a(p,4)
p[4]=s
s=a.F()
p.$flags&2&&A.c(p)
if(5>=p.length)return A.a(p,5)
p[5]=s
s=a.F()
p.$flags&2&&A.c(p)
if(6>=p.length)return A.a(p,6)
p[6]=s
s=a.F()
p.$flags&2&&A.c(p)
if(7>=p.length)return A.a(p,7)
p[7]=s
return new A.eH(o,b,r,q)},
bW(a,b){return B.a.j(a+B.a.R(1,b)-1,b)},
eH:function eH(a,b,c,d){var _=this
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
fX:function fX(a,b,c,d){var _=this
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
hH:function hH(a,b){var _=this
_.a=0
_.b=a
_.c=b
_.d=$},
js:function js(a,b){this.a=a
this.b=b},
bF(a,b){return((a^b)>>>1&2139062143)+((a&b)>>>0)},
ct(a){if(a<0)return 0
if(a>255)return 255
return a},
jt(a,b,c){return Math.abs(b-c)-Math.abs(a-c)},
pr(a,b,c){return 4278190080},
ps(a,b,c){return a},
px(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return b[c]},
py(a,b,c){var s=c+1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
pz(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return b[s]},
pA(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bF(A.bF(a,b[r]),s)},
pB(a,b,c){var s=c-1
if(!(s>=0&&s<b.length))return A.a(b,s)
return A.bF(a,b[s])},
pC(a,b,c){if(!(c>=0&&c<b.length))return A.a(b,c)
return A.bF(a,b[c])},
pD(a,b,c){var s=c-1,r=b.length
if(!(s>=0&&s<r))return A.a(b,s)
s=b[s]
if(!(c>=0&&c<r))return A.a(b,c)
return A.bF(s,b[c])},
pE(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<q))return A.a(b,r)
return A.bF(s,b[r])},
pt(a,b,c){var s,r,q=c-1,p=b.length
if(!(q>=0&&q<p))return A.a(b,q)
q=b[q]
if(!(c>=0&&c<p))return A.a(b,c)
s=b[c]
r=c+1
if(!(r<p))return A.a(b,r)
r=b[r]
return A.bF(A.bF(a,q),A.bF(s,r))},
pu(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return A.jt(s>>>24,a>>>24,r>>>24)+A.jt(s>>>16&255,a>>>16&255,r>>>16&255)+A.jt(s>>>8&255,a>>>8&255,r>>>8&255)+A.jt(s&255,a&255,r&255)<=0?s:a},
pv(a,b,c){var s,r,q=b.length
if(!(c>=0&&c<q))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<q))return A.a(b,r)
r=b[r]
return(A.ct((a>>>24)+(s>>>24)-(r>>>24))<<24|A.ct((a>>>16&255)+(s>>>16&255)-(r>>>16&255))<<16|A.ct((a>>>8&255)+(s>>>8&255)-(r>>>8&255))<<8|A.ct((a&255)+(s&255)-(r&255)))>>>0},
pw(a,b,c){var s,r,q,p,o,n=b.length
if(!(c>=0&&c<n))return A.a(b,c)
s=b[c]
r=c-1
if(!(r>=0&&r<n))return A.a(b,r)
r=b[r]
q=A.bF(a,s)
s=q>>>24
n=q>>>16&255
p=q>>>8&255
o=q>>>0&255
return(A.ct(s+B.a.X(s-(r>>>24),2))<<24|A.ct(n+B.a.X(n-(r>>>16&255),2))<<16|A.ct(p+B.a.X(p-(r>>>8&255),2))<<8|A.ct(o+B.a.X(o-(r&255),2)))>>>0},
cs:function cs(a,b){this.a=a
this.b=b},
hI:function hI(a){var _=this
_.a=a
_.c=_.b=0
_.d=null
_.e=0},
jy:function jy(a,b,c){var _=this
_.a=a
_.b=b
_.c=c
_.f=_.e=_.d=0
_.r=1
_.w=!1
_.x=$
_.y=!1},
eL:function eL(){},
fY:function fY(a,b,c){var _=this
_.a=a
_.b=b
_.e=c
_.f=$
_.r=1
_.x=_.w=$},
kN(a){var s,r=J.d0(a,t.gj)
for(s=0;s<a;++s)r[s]=new A.fz()
return new A.dM(r,0)},
oh(){var s,r,q=J.am(5,t.fa)
for(s=0;s<5;++s)q[s]=A.kN(0)
r=J.am(64,t.ak)
for(s=0;s<64;++s)r[s]=new A.fA()
return new A.dL(q,r)},
fz:function fz(){this.b=this.a=0},
fA:function fA(){this.b=this.a=0},
dM:function dM(a,b){this.a=a
this.b=b},
dL:function dL(a,b){var _=this
_.a=a
_.b=!1
_.c=0
_.e=_.d=!1
_.f=b},
dO:function dO(){var _=this
_.b=_.a=null
_.e=_.d=0},
fB:function fB(a){this.a=a
this.b=null},
dl:function dl(a,b){this.a=a
this.b=b},
dm:function dm(a,b){var _=this
_.b=_.a=0
_.e=_.d=!1
_.f=a
_.w=""
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
dW:function dW(a,b){var _=this
_.b=_.a=0
_.e=_.d=!1
_.f=a
_.w=""
_.z=b
_.as=0
_.at=null
_.ch=_.ay=0},
jz:function jz(){this.b=this.a=null},
m1(a){return new A.cQ(a.a,a.b,B.d.hu(a.c,0))},
fC:function fC(a,b){this.a=a
this.b=b},
cQ:function cQ(a,b,c){this.a=a
this.b=b
this.c=c},
Q(a,b,c,d,e,f,g,h,i,j,k,l,m){var s,r=new A.bu(null,null,null,a,h,e,d,0)
B.c.G(r.gah(),r)
r.c=g
if(b!=null)r.e=A.dD(b)
s=!1
if(j==null)if(m)s=r.gL()===B.y||r.gL()===B.t||r.gL()===B.z||r.gL()===B.e||r.gL()===B.m
r.eF(l,f,c,i,s?r.ia(c,k,i):j)
return r},
fH(a,b,c,d){var s,r,q,p=null,o=a.e
o=o==null?p:A.dD(o)
s=a.c
s=s==null?p:A.m1(s)
r=a.w
q=a.r
o=new A.bu(p,s,o,p,q,r,a.y,a.z)
o.hM(a,b,c,d)
return o},
bv(a,b,c){var s,r,q,p,o=null,n=a.a
n=n==null?o:n.bk(c)
s=a.e
s=s==null?o:A.dD(s)
r=a.c
r=r==null?o:A.m1(r)
q=a.w
p=a.r
n=new A.bu(n,r,s,o,p,q,a.y,a.z)
n.hL(a,b,c)
return n},
fy:function fy(a,b){this.a=a
this.b=b},
bu:function bu(a,b,c,d,e,f,g,h){var _=this
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
iy:function iy(a,b){this.a=a
this.b=b},
ix:function ix(){},
ae:function ae(){},
oj(a,b,c){return new A.cS(new Uint16Array(a*b*c),a,b,c)},
cS:function cS(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
ok(a,b,c){return new A.cT(new Float32Array(a*b*c),a,b,c)},
cT:function cT(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dQ:function dQ(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dR:function dR(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dS:function dS(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
dT:function dT(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
cU:function cU(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
cV:function cV(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
cW:function cW(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
ol(a,b,c){return new A.cX(new Uint32Array(a*b*c),a,b,c)},
cX:function cX(a,b,c,d){var _=this
_.d=a
_.a=b
_.b=c
_.c=d},
cY:function cY(a,b,c,d,e,f){var _=this
_.d=a
_.e=b
_.f=c
_.r=null
_.a=d
_.b=e
_.c=f},
md(a,b,c){return new A.cZ(new Uint8Array(a*b*c),null,a,b,c)},
cZ:function cZ(a,b,c,d,e){var _=this
_.d=a
_.e=b
_.a=c
_.b=d
_.c=e},
fZ:function fZ(a,b){this.a=a
this.b=b},
aQ:function aQ(){},
eg:function eg(a,b,c){this.c=a
this.a=b
this.b=c},
eh:function eh(a,b,c){this.c=a
this.a=b
this.b=c},
ei:function ei(a,b,c){this.c=a
this.a=b
this.b=c},
ej:function ej(a,b,c){this.c=a
this.a=b
this.b=c},
ek:function ek(a,b,c){this.c=a
this.a=b
this.b=c},
el:function el(a,b,c){this.c=a
this.a=b
this.b=c},
em:function em(a,b,c){this.c=a
this.a=b
this.b=c},
d6:function d6(a,b,c){this.c=a
this.a=b
this.b=c},
mp(a){return new A.aH(new Uint8Array(A.r(a.c)),a.a,a.b)},
aH:function aH(a,b,c){this.c=a
this.a=b
this.b=c},
kX(a){return new A.ce(-1,0,-a.c,a)},
ce:function ce(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
kY(a){return new A.cf(-1,0,-a.c,a)},
cf:function cf(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
kZ(a){return new A.cg(-1,0,-a.c,a)},
cg:function cg(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l_(a){return new A.ch(-1,0,-a.c,a)},
ch:function ch(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l0(a){return new A.ci(-1,0,-a.c,a)},
ci:function ci(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
l1(a){return new A.cj(-1,0,-a.c,a)},
cj:function cj(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
b1(a,b,c,d,e){a.a3(b-1,c)
return new A.hf(a,b,b+d-1,c+e-1)},
hf:function hf(a,b,c,d){var _=this
_.a=a
_.b=b
_.d=c
_.e=d},
en(a){return new A.ck(-1,0,0,-1,0,a)},
ck:function ck(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
l2(a){return new A.cl(-1,0,-a.c,a)},
cl:function cl(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
eo(a){return new A.cm(-1,0,0,-2,0,a)},
cm:function cm(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
l3(a){return new A.cn(-1,0,-a.c,a)},
cn:function cn(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ep(a){return new A.co(-1,0,0,-(a.c<<2>>>0),a)},
co:function co(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
iY(a){return new A.cp(-1,0,-a.c,a)},
cp:function cp(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
D:function D(){},
ro(a,b){switch(b.a){case 0:A.i1(a)
break
case 1:A.rq(a)
break
case 2:A.rp(a)
break}return a},
rq(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=null,c=a.gah().length
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
k=B.a.X(l,2)
o=a.a
if((o==null?d:o.gM())!=null)for(j=l-1,i=0;i<k;++i,--j)for(h=0;h<m;++h){o=p.a
g=o==null?d:o.N(h,i,d)
if(g==null)g=new A.D()
o=p.a
f=o==null?d:o.N(h,j,d)
if(f==null)f=new A.D()
e=g.gT()
g.sT(f.gT())
f.sT(e)}else for(j=l-1,i=0;i<k;++i,--j)for(h=0;h<m;++h){o=p.a
g=o==null?d:o.N(h,i,d)
if(g==null)g=new A.D()
o=p.a
f=o==null?d:o.N(h,j,d)
if(f==null)f=new A.D()
e=g.gm()
g.sm(f.gm())
f.sm(e)
e=g.gt()
g.st(f.gt())
f.st(e)
e=g.gu()
g.su(f.gu())
f.su(e)
e=g.gA()
g.sA(f.gA())
f.sA(e)}}return a},
i1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=null,b=a.gah().length
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
k=B.a.X(m,2)
o=a.a
if((o==null?c:o.gM())!=null)for(j=m-1,i=0;i<l;++i)for(h=j,g=0;g<k;++g,--h){o=p.a
f=o==null?c:o.N(g,i,c)
if(f==null)f=new A.D()
o=p.a
e=o==null?c:o.N(h,i,c)
if(e==null)e=new A.D()
d=f.gT()
f.sT(e.gT())
e.sT(d)}else for(j=m-1,i=0;i<l;++i)for(h=j,g=0;g<k;++g,--h){o=p.a
f=o==null?c:o.N(g,i,c)
if(f==null)f=new A.D()
o=p.a
e=o==null?c:o.N(h,i,c)
if(e==null)e=new A.D()
d=f.gm()
f.sm(e.gm())
e.sm(d)
d=f.gt()
f.st(e.gt())
e.st(d)
d=f.gu()
f.su(e.gu())
e.su(d)
d=f.gA()
f.sA(e.gA())
e.sA(d)}}return a},
rp(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=null,a=a0.gah().length
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
k=B.a.X(l,2)
if((n?b:o.gM())!=null)for(j=l-1,i=m-1,h=0;h<k;++h,--j)for(g=i,f=0;f<m;++f,--g){o=p.a
e=o==null?b:o.N(f,h,b)
if(e==null)e=new A.D()
o=p.a
d=o==null?b:o.N(g,j,b)
if(d==null)d=new A.D()
c=e.gT()
e.sT(d.gT())
d.sT(c)}else for(j=l-1,i=m-1,h=0;h<k;++h,--j)for(g=i,f=0;f<m;++f,--g){o=p.a
e=o==null?b:o.N(f,h,b)
if(e==null)e=new A.D()
o=p.a
d=o==null?b:o.N(g,j,b)
if(d==null)d=new A.D()
c=e.gm()
e.sm(d.gm())
d.sm(c)
c=e.gt()
e.st(d.gt())
d.st(c)
c=e.gu()
e.su(d.gu())
d.su(c)
c=e.gA()
e.sA(d.gA())
d.sA(c)}}return a0},
ik:function ik(a,b){this.a=a
this.b=b},
m(a){return new A.iw(a)},
iw:function iw(a){this.a=a},
v(a,b,c,d){var s=J.a9(a),r=s.gv(a)
s=c==null?s.gv(a):d+c
return new A.af(a,d,Math.min(r,s),d,b)},
p(a,b,c){var s=a.a,r=a.d,q=a.b,p=J.bm(s),o=b==null?a.c:a.d+c+b
return new A.af(s,q,Math.min(p,o),r+c,a.e)},
af:function af(a,b,c,d,e){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e},
kV(a,b,c){var s=new A.hb(c,new Int32Array(256))
s.jd(b)
s.kg(a)
return s},
hb:function hb(a,b){var _=this
_.a=$
_.b=a
_.c=16
_.d=3
_.f=_.e=$
_.r=null
_.Q=_.z=_.y=_.x=_.w=$
_.as=b
_.ax=_.at=$},
aa(a,b){return new A.hd(a,new Uint8Array(b))},
hd:function hd(a,b){this.a=0
this.b=a
this.c=b},
j9:function j9(a,b){this.a=a
this.b=b},
hw:function hw(){},
aS:function aS(a,b){this.a=a
this.b=b},
h7:function h7(a,b){this.a=a
this.b=b},
iR:function iR(a){this.c=a},
iS:function iS(){},
e3:function e3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
ot(a){var s=A.nf(a)
if(s==null)return null
return new A.h8(a,s.gS(),s.gK(),A.lO(s,4,3).a,null,null)},
ou(a){var s,r,q,p,o=null,n=A.nf(a.a),m=n.gK()>n.gS()?a.b:o,l=A.rg(n,m,n.gS()>=n.gK()?a.b:o),k=A.rk(a.c,l)
if(k==null)return o
s=new Uint8Array(A.r(k))
m=l.gS()
r=l.gK()
q=n.gK()
p=n.gS()
return new A.h8(s,m,r,a.d?A.lO(l,4,3).a:o,q,p)},
h8:function h8(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
iV:function iV(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
jA:function jA(a,b,c){this.a=a
this.b=b
this.c=c},
eM:function eM(a,b){this.a=a
this.b=b},
lC(){var s=0,r=A.qN(t.w),q,p,o
var $async$lC=A.r7(function(a,b){if(a===1)return A.qi(b,r)
for(;;)switch(s){case 0:$.kv().fF(new A.e3("[native implementations worker]: Starting...",null,$.lG().$1(null),B.dh))
q=A.bi(v.G.self)
p=new A.ku()
if(typeof p=="function")A.b8(A.c2("Attempting to rewrap a JS function.",null))
o=function(c,d){return function(e){return c(d,e,arguments.length)}}(A.qm,p)
o[$.lF()]=p
q.onmessage=o
return A.qj(null,r)}})
return A.qk($async$lC,r)},
na(a,b){var s,r,q
try{A.bi(v.G.self).postMessage(A.lz(A.kS(["label",a,"data",b],t.N,t.z)))}catch(q){s=A.c0(q)
r=A.bk(q)
$.kv().fV(u.g+A.z(s)+", "+A.z(r))}},
qT(a,b,c){var s,r,q,p
a=a
if(a!=null)try{s=A.lz(a)
if(s!=null)a=s}catch(p){a=J.dx(a)}try{A.bi(v.G.self).postMessage(A.lz(A.kS(["label","stacktrace","origin",c,"error",a,"stacktrace",b.C(0)],t.N,t.X)))}catch(p){r=A.c0(p)
q=A.bk(p)
$.kv().fV(u.g+A.z(r)+", "+A.z(q))}},
ku:function ku(){},
p0(a){throw A.h(A.bh("Uint64List not supported on the web."))},
om(a,b,c){return J.kC(a,b,c)},
mB(a,b){return J.W(a,b,null)},
od(a){return J.lK(a,0,null)},
oe(a){return a.lh(0,0,null)},
nl(a,b,c){A.rd(c,t.q,"T","max")
return Math.max(c.a(a),c.a(b))},
rr(a){var s,r,q,p,o,n=a.gv(0)
for(s=1,r=0;n>0;){q=3800>n?n:3800
n-=q
while(--q,q>=0){p=a.b
p.toString
o=a.c++
if(!(o>=0&&o<p.length))return A.a(p,o)
s+=p[o]
r+=s}s=B.a.a8(s,65521)
r=B.a.a8(r,65521)}return(r<<16|s)>>>0},
bj(a,b){var s,r,q=J.a9(a),p=q.gv(a)
b^=4294967295
for(s=0;p>=8;){r=s+1
b=B.C[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.C[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.C[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.C[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.C[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.C[(b^q.l(a,r))&255]^b>>>8
r=s+1
b=B.C[(b^q.l(a,s))&255]^b>>>8
s=r+1
b=B.C[(b^q.l(a,r))&255]^b>>>8
p-=8}if(p>0)do{r=s+1
b=B.C[(b^q.l(a,s))&255]^b>>>8
if(--p,p>0){s=r
continue}else break}while(!0)
return(b^4294967295)>>>0},
i0(a,b){var s,r,q,p=B.kh.gc3()
p=A.w(p,A.l(p).q("e.E"))
for(s=1,r="";s<=b;++s,r=q){q=B.b.i(B.b.a8(a/Math.pow(83,b-s),83))
if(q>=0&&q<p.length){if(!(q>=0&&q<p.length))return A.a(p,q)
q=p[q]}else q=null
q=r+A.z(q)}return r.charCodeAt(0)==0?r:r},
lv(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n,m,l
if(j==null)j=0
if(k==null)k=0
if(i==null)i=b.gS()
if(h==null)h=b.gK()
if(e==null)e=a.gS()<b.gS()?a.gS():b.gS()
if(d==null)d=a.gK()<b.gK()?a.gK():b.gK()
s=c===B.aB
if(!s&&a.gaK())a=a.e1(a.gaC())
r=h/d
q=i/e
p=t.p
o=J.am(d,p)
for(n=0;n<d;++n)o[n]=k+B.b.i(n*r)
m=J.am(e,p)
for(l=0;l<e;++l)m[l]=j+B.b.i(l*q)
if(s)A.qp(b,a,f,g,e,d,m,o,null,B.b9)
else A.qn(b,a,f,g,e,d,m,o,c,!1,null,B.b9)
return a},
qp(a,b,c,d,e,f,g,h,i,j){var s,r,q,p,o,n,m,l,k
for(s=g.length,r=h.length,q=null,p=0;p<f;++p)for(o=d+p,n=0;n<e;++n){if(!(n<s))return A.a(g,n)
m=g[n]
if(!(p<r))return A.a(h,p)
l=h[p]
k=a.a
q=k==null?null:k.N(m,l,q)
if(q==null)q=new A.D()
b.c5(c+n,o,q)}},
qn(a,b,c,d,e,f,g,h,i,j,a0,a1){var s,r,q,p,o,n,m,l,k
for(s=g.length,r=h.length,q=null,p=0;p<f;++p)for(o=d+p,n=0;n<e;++n){if(!(n<s))return A.a(g,n)
m=g[n]
if(!(p<r))return A.a(h,p)
l=h[p]
k=a.a
q=k==null?null:k.N(m,l,q)
if(q==null)q=new A.D()
A.rj(b,c+n,o,q,i,!1,a0,a1)}},
rj(a6,a7,a8,a9,b0,b1,b2,b3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5
if(!a6.fZ(a7,a8))return a6
if(b0===B.aB||a6.gaK())if(a6.fZ(a7,a8)){a6.aR(a7,a8).af(a9)
return a6}s=a9.gae()
r=a9.gaa()
q=a9.gad()
p=a9.gv(a9)<4?1:a9.ga_()
if(p===0)return a6
o=a6.aR(a7,a8)
n=o.gae()
m=o.gaa()
l=o.gad()
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
h=B.b.P(p,0.01,1)
i=p<0
d=i?0:1
c=B.b.P(s/h*d,0,0.99)
d=B.b.P(p,0.01,1)
h=i?0:1
b=B.b.P(r/d*h,0,0.99)
h=B.b.P(p,0.01,1)
i=i?0:1
a=B.b.P(q/h*i,0,0.99)
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
o.sae(s*p+n*k*a5)
o.saa(r*p+m*k*a5)
o.sad(q*p+l*k*a5)
o.sa_(p+k*a5)
return a6},
rl(a,b,c,d,e,f,g){var s,r=B.b.P(Math.min(d,e),0,a.gS()-1),q=B.b.P(Math.min(f,g),0,a.gK()-1),p=B.b.P(Math.max(d,e),0,a.gS()-1),o=B.b.P(Math.max(f,g),0,a.gK()-1),n=a.a.bf(0,r,q,p-r+1,o-q+1)
for(s=n.a;n.D();)s.af(c)
return a},
oa(a6,a7,a8,a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=b2<16384,a5=a8>b0?b0:a8
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
A.dF(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.dF(a,a6[b],q)
a2=q[0]
a3=q[1]
A.dF(a0,a2,q)
a=q[0]
a6.$flags&2&&A.c(a6)
a6[e]=a
a6[d]=q[1]
A.dF(a1,a3,q)
a=q[0]
a6.$flags&2&&A.c(a6)
a6[c]=a
a6[b]=q[1]}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.dG(a,a6[c],q)
a0=q[0]
a1=q[1]
if(!(d>=0&&d<p))return A.a(a6,d)
a=a6[d]
if(!(b>=0&&b<p))return A.a(a6,b)
A.dG(a,a6[b],q)
a2=q[0]
a3=q[1]
A.dG(a0,a2,q)
a=q[0]
a6.$flags&2&&A.c(a6)
a6[e]=a
a6[d]=q[1]
A.dG(a1,a3,q)
a=q[0]
a6.$flags&2&&A.c(a6)
a6[c]=a
a6[b]=q[1]}}if(i){c=e+m
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.dF(a,a6[c],q)
a0=q[0]
a=q[1]
a6.$flags&2&&A.c(a6)
a6[c]=a}else{if(!(e>=0&&e<p))return A.a(a6,e)
a=a6[e]
if(!(c>=0&&c<p))return A.a(a6,c)
A.dG(a,a6[c],q)
a0=q[0]
a=q[1]
a6.$flags&2&&A.c(a6)
a6[c]=a}a6.$flags&2&&A.c(a6)
if(!(e>=0&&e<p))return A.a(a6,e)
a6[e]=a0}}if((b0&s)>>>0!==0){f=g+h
for(e=g;e<=f;e+=j){d=e+k
if(a4){if(!(e>=0&&e<p))return A.a(a6,e)
i=a6[e]
if(!(d>=0&&d<p))return A.a(a6,d)
A.dF(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.c(a6)
a6[d]=i}else{if(!(e>=0&&e<p))return A.a(a6,e)
i=a6[e]
if(!(d>=0&&d<p))return A.a(a6,d)
A.dG(i,a6[d],q)
a0=q[0]
i=q[1]
a6.$flags&2&&A.c(a6)
a6[d]=i}a6.$flags&2&&A.c(a6)
if(!(e>=0&&e<p))return A.a(a6,e)
a6[e]=a0}}r=s>>>1}},
dF(a,b,c){var s,r,q,p,o=$.ao()
o.$flags&2&&A.c(o)
o[0]=a
s=$.ax()
if(0>=s.length)return A.a(s,0)
r=s[0]
o[0]=b
q=s[0]
p=r+(q&1)+B.a.j(q,1)
B.c.h(c,0,p)
B.c.h(c,1,p-q)},
dG(a,b,c){var s=a-B.a.j(b,1)&65535
B.c.h(c,1,s)
B.c.h(c,0,b+s-32768&65535)},
rn(a){var s,r,q,p,o,n,m,l,k=null,j=a.toLowerCase()
if(B.n.bw(j,".jpg")||B.n.bw(j,".jpeg")){s=new Uint8Array(64)
r=new Uint8Array(64)
q=new Float32Array(64)
p=new Float32Array(64)
o=A.S(65535,k,!1,t.T)
n=t.I
m=A.S(65535,k,!1,n)
l=A.S(64,k,!1,n)
n=A.S(64,k,!1,n)
s=new A.iI(s,r,q,p,o,m,l,n,new Int32Array(2048))
s.e=s.d1(B.cc,B.ah)
s.f=s.d1(B.bN,B.ah)
r=t.d
s.r=r.a(s.d1(B.bq,B.bA))
s.w=r.a(s.d1(B.bG,B.bV))
s.j9()
s.jc()
s.hq(100)
return s}if(B.n.bw(j,".png"))return A.oG()
if(B.n.bw(j,".tga"))return new A.jc()
if(B.n.bw(j,".gif"))return new A.iq()
if(B.n.bw(j,".tif")||B.n.bw(j,".tiff"))return new A.jf()
if(B.n.bw(j,".bmp"))return new A.i8()
if(B.n.bw(j,".ico"))return new A.fE()
if(B.n.bw(j,".cur"))return new A.fE()
if(B.n.bw(j,".pvr"))return new A.j6()
return k},
rm(a){var s,r,q,p,o,n,m,l,k,j,i=null
if(A.ml().l8(a))return new A.h2()
s=new A.hh(A.mf())
if(s.cr(a))return s
r=new A.ip()
r.f=A.v(a,!1,i,0)
r.a=new A.dK(A.j([],t.Y))
if(r.eS())return r
q=new A.jz()
if(q.cr(a))return q
p=new A.je()
if(p.fb(A.v(a,!1,i,0))!=null)return p
if(A.mv(a).c===943870035)return new A.j1()
if(A.o9(a))return new A.ii()
if(A.kI(A.v(a,!1,i,0)))return new A.ff(!1)
o=new A.jb()
n=A.v(a,!1,i,0)
m=o.a=new A.eD(B.ay)
m.ci(n)
if(m.h1())return o
l=new A.is()
m=A.v(a,!1,i,0)
l.a=m
m=A.m2(m)
l.b=m
if(m!=null)return l
k=new A.j5()
if(k.b4(a)!=null)return k
j=new A.iZ(A.j([],t.s))
if(j.cr(a))return j
return i},
nf(a){var s=A.rm(a)
return s==null?null:s.b6(a,null)},
rk(a,b){var s=A.rn(a)
if(s==null)return null
return s.bQ(b)},
rJ(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4
if($.lq==null){s=$.lq=new Uint8Array(768)
for(r=-256;r<0;++r)s[256+r]=0
for(r=0;r<256;++r)s[256+r]=r
for(r=256;r<512;++r)s[256+r]=255}for(s=a8.$flags|0,r=0;r<64;++r){q=a6[r]
p=a5[r]
s&2&&A.c(a8)
if(!(r<64))return A.a(a8,r)
a8[r]=q*p}for(o=0,r=0;r<8;++r,o+=8){q=1+o
if(!(q<64))return A.a(a8,q)
p=a8[q]
n=!1
if(p===0){m=2+o
if(!(m<64))return A.a(a8,m)
if(a8[m]===0){m=3+o
if(!(m<64))return A.a(a8,m)
if(a8[m]===0){m=4+o
if(!(m<64))return A.a(a8,m)
if(a8[m]===0){m=5+o
if(!(m<64))return A.a(a8,m)
if(a8[m]===0){m=6+o
if(!(m<64))return A.a(a8,m)
if(a8[m]===0){n=7+o
if(!(n<64))return A.a(a8,n)
n=a8[n]===0}}}}}}if(n){if(!(o<64))return A.a(a8,o)
q=B.a.j(5793*a8[o]+512,10)
l=(q&2147483647)-((q&2147483648)>>>0)
s&2&&A.c(a8)
if(!(o<64))return A.a(a8,o)
a8[o]=l
q=o+1
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=o+2
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=o+3
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=o+4
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=o+5
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=o+6
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=o+7
if(!(q<64))return A.a(a8,q)
a8[q]=l
continue}if(!(o<64))return A.a(a8,o)
n=B.a.j(5793*a8[o]+128,8)
k=(n&2147483647)-((n&2147483648)>>>0)
n=4+o
if(!(n<64))return A.a(a8,n)
m=B.a.j(5793*a8[n]+128,8)
j=(m&2147483647)-((m&2147483648)>>>0)
m=2+o
if(!(m<64))return A.a(a8,m)
i=a8[m]
h=6+o
if(!(h<64))return A.a(a8,h)
g=a8[h]
f=7+o
if(!(f<64))return A.a(a8,f)
e=a8[f]
d=B.a.j(2896*(p-e)+128,8)
c=(d&2147483647)-((d&2147483648)>>>0)
e=B.a.j(2896*(p+e)+128,8)
b=(e&2147483647)-((e&2147483648)>>>0)
e=3+o
if(!(e<64))return A.a(a8,e)
p=a8[e]<<4
a=(p&2147483647)-((p&2147483648)>>>0)
p=5+o
if(!(p<64))return A.a(a8,p)
d=a8[p]<<4
a0=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(k-j+1,1)
l=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(k+j+1,1)
k=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(i*3784+g*1567+128,8)
d=(d&2147483647)-((d&2147483648)>>>0)
a1=B.a.j(i*1567-g*3784+128,8)
i=(a1&2147483647)-((a1&2147483648)>>>0)
a1=B.a.j(c-a0+1,1)
a1=(a1&2147483647)-((a1&2147483648)>>>0)
a2=B.a.j(c+a0+1,1)
c=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.j(b+a+1,1)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a3=B.a.j(b-a+1,1)
a=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.j(k-d+1,1)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
d=B.a.j(k+d+1,1)
k=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(l-i+1,1)
d=(d&2147483647)-((d&2147483648)>>>0)
a4=B.a.j(l+i+1,1)
j=(a4&2147483647)-((a4&2147483648)>>>0)
a4=B.a.j(c*2276+a2*3406+2048,12)
l=(a4&2147483647)-((a4&2147483648)>>>0)
a2=B.a.j(c*3406-a2*2276+2048,12)
c=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.j(a*799+a1*4017+2048,12)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a1=B.a.j(a*4017-a1*799+2048,12)
a=(a1&2147483647)-((a1&2147483648)>>>0)
s&2&&A.c(a8)
if(!(o<64))return A.a(a8,o)
a8[o]=k+l
if(!(f<64))return A.a(a8,f)
a8[f]=k-l
if(!(q<64))return A.a(a8,q)
a8[q]=j+a2
if(!(h<64))return A.a(a8,h)
a8[h]=j-a2
if(!(m<64))return A.a(a8,m)
a8[m]=d+a
if(!(p<64))return A.a(a8,p)
a8[p]=d-a
if(!(e<64))return A.a(a8,e)
a8[e]=a3+c
if(!(n<64))return A.a(a8,n)
a8[n]=a3-c}for(r=0;r<8;++r){q=8+r
p=a8[q]
if(p===0&&a8[16+r]===0&&a8[24+r]===0&&a8[32+r]===0&&a8[40+r]===0&&a8[48+r]===0&&a8[56+r]===0){p=B.a.j(5793*a8[r]+8192,14)
l=(p&2147483647)-((p&2147483648)>>>0)
s&2&&A.c(a8)
if(!(r<64))return A.a(a8,r)
a8[r]=l
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=16+r
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=24+r
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=32+r
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=40+r
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=48+r
if(!(q<64))return A.a(a8,q)
a8[q]=l
q=56+r
if(!(q<64))return A.a(a8,q)
a8[q]=l
continue}n=B.a.j(5793*a8[r]+2048,12)
k=(n&2147483647)-((n&2147483648)>>>0)
n=32+r
m=B.a.j(5793*a8[n]+2048,12)
j=(m&2147483647)-((m&2147483648)>>>0)
m=16+r
i=a8[m]
h=48+r
g=a8[h]
f=56+r
e=a8[f]
d=B.a.j(2896*(p-e)+2048,12)
c=(d&2147483647)-((d&2147483648)>>>0)
e=B.a.j(2896*(p+e)+2048,12)
b=(e&2147483647)-((e&2147483648)>>>0)
e=24+r
a=a8[e]
p=40+r
a0=a8[p]
d=B.a.j(k-j+1,1)
l=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(k+j+1,1)
k=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(i*3784+g*1567+2048,12)
d=(d&2147483647)-((d&2147483648)>>>0)
a1=B.a.j(i*1567-g*3784+2048,12)
i=(a1&2147483647)-((a1&2147483648)>>>0)
a1=B.a.j(c-a0+1,1)
a1=(a1&2147483647)-((a1&2147483648)>>>0)
a2=B.a.j(c+a0+1,1)
c=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.j(b+a+1,1)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a3=B.a.j(b-a+1,1)
a=(a3&2147483647)-((a3&2147483648)>>>0)
a3=B.a.j(k-d+1,1)
a3=(a3&2147483647)-((a3&2147483648)>>>0)
d=B.a.j(k+d+1,1)
k=(d&2147483647)-((d&2147483648)>>>0)
d=B.a.j(l-i+1,1)
d=(d&2147483647)-((d&2147483648)>>>0)
a4=B.a.j(l+i+1,1)
j=(a4&2147483647)-((a4&2147483648)>>>0)
a4=B.a.j(c*2276+a2*3406+2048,12)
l=(a4&2147483647)-((a4&2147483648)>>>0)
a2=B.a.j(c*3406-a2*2276+2048,12)
c=(a2&2147483647)-((a2&2147483648)>>>0)
a2=B.a.j(a*799+a1*4017+2048,12)
a2=(a2&2147483647)-((a2&2147483648)>>>0)
a1=B.a.j(a*4017-a1*799+2048,12)
a=(a1&2147483647)-((a1&2147483648)>>>0)
s&2&&A.c(a8)
if(!(r<64))return A.a(a8,r)
a8[r]=k+l
if(!(f<64))return A.a(a8,f)
a8[f]=k-l
a8[q]=j+a2
a8[h]=j-a2
a8[m]=d+a
a8[p]=d-a
a8[e]=a3+c
a8[n]=a3-c}for(s=$.lq,q=a7.$flags|0,r=0;r<64;++r){s.toString
p=B.a.j(a8[r]+8,4)
p=384+((p&2147483647)-((p&2147483648)>>>0))
if(!(p>=0&&p<768))return A.a(s,p)
p=s[p]
q&2&&A.c(a7)
if(!(r<64))return A.a(a7,r)
a7[r]=p}},
rs(e5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5,d6,d7,d8,d9,e0,e1,e2=null,e3="ifd0",e4=e5.w
if(e4.l(0,e3).a.ag(274)){s=e4.l(0,e3).gcg()
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
m.e=A.dD(e4)
m.gbF().l(0,e3).scg(e2)
m.c=e5.r
l=s-1
k=q-1
e4=e5.as
s=e4.length
switch(s){case 1:if(0>=s)return A.a(e4,0)
j=e4[0]
i=j.e
h=j.f
g=j.r
e4=r===8
s=r===7
q=r===6
f=r===5
e=r===4
d=r===3
c=r===2
b=i.length
a=0
for(;;){a0=e5.d.d
a0.toString
if(!(a<a0))break
a1=B.a.a4(a,g)
if(!(a1<b))return A.a(i,a1)
a2=i[a1]
a0=l-a
a3=0
for(;;){a4=e5.d.e
a4.toString
if(!(a3<a4))break
a5=B.a.a4(a3,h)
if(!(a5<a2.length))return A.a(a2,a5)
a6=a2[a5]
if(c){a4=m.a
if(a4!=null)a4.Y(k-a3,a,a6,a6,a6)}else if(d){a4=m.a
if(a4!=null)a4.Y(k-a3,a0,a6,a6,a6)}else if(e){a4=m.a
if(a4!=null)a4.Y(a3,a0,a6,a6,a6)}else if(f){a4=m.a
if(a4!=null)a4.Y(a,a3,a6,a6,a6)}else if(q){a4=m.a
if(a4!=null)a4.Y(a0,a3,a6,a6,a6)}else if(s){a4=m.a
if(a4!=null)a4.Y(a0,k-a3,a6,a6,a6)}else{a4=m.a
if(e4){if(a4!=null)a4.Y(a,k-a3,a6,a6,a6)}else if(a4!=null)a4.Y(a3,a,a6,a6,a6)}++a3}++a}break
case 3:if(0>=s)return A.a(e4,0)
j=e4[0]
if(1>=s)return A.a(e4,1)
a7=e4[1]
if(2>=s)return A.a(e4,2)
a8=e4[2]
a9=j.e
b0=a7.e
b1=a8.e
h=j.f
g=j.r
b2=a7.f
b3=a7.r
b4=a8.f
b5=a8.r
e4=r===8
s=r===7
q=r===6
f=r===5
e=r===4
d=r===3
c=r===2
b=a9.length
a0=b0.length
a4=b1.length
a=0
for(;;){b6=e5.d.d
b6.toString
if(!(a<b6))break
a1=B.a.a4(a,g)
b7=B.a.a4(a,b3)
b8=B.a.a4(a,b5)
if(!(a1<b))return A.a(a9,a1)
a2=a9[a1]
if(!(b7<a0))return A.a(b0,b7)
b9=b0[b7]
if(!(b8<a4))return A.a(b1,b8)
c0=b1[b8]
b6=l-a
a3=0
for(;;){c1=e5.d.e
c1.toString
if(!(a3<c1))break
a5=B.a.a4(a3,h)
c2=B.a.a4(a3,b2)
c3=B.a.a4(a3,b4)
if(!(a5<a2.length))return A.a(a2,a5)
a6=a2[a5]<<8>>>0
if(!(c2<b9.length))return A.a(b9,c2)
c4=b9[c2]-128
if(!(c3<c0.length))return A.a(c0,c3)
c5=c0[c3]-128
c1=B.a.j(a6+359*c5+128,8)
c6=B.a.P((c1&2147483647)-((c1&2147483648)>>>0),0,255)
c1=B.a.j(a6-88*c4-183*c5+128,8)
c7=B.a.P((c1&2147483647)-((c1&2147483648)>>>0),0,255)
c1=B.a.j(a6+454*c4+128,8)
c8=B.a.P((c1&2147483647)-((c1&2147483648)>>>0),0,255)
if(c){c1=m.a
if(c1!=null)c1.Y(k-a3,a,c6,c7,c8)}else if(d){c1=m.a
if(c1!=null)c1.Y(k-a3,b6,c6,c7,c8)}else if(e){c1=m.a
if(c1!=null)c1.Y(a3,b6,c6,c7,c8)}else if(f){c1=m.a
if(c1!=null)c1.Y(a,a3,c6,c7,c8)}else if(q){c1=m.a
if(c1!=null)c1.Y(b6,a3,c6,c7,c8)}else if(s){c1=m.a
if(c1!=null)c1.Y(b6,k-a3,c6,c7,c8)}else{c1=m.a
if(e4){if(c1!=null)c1.Y(a,k-a3,c6,c7,c8)}else if(c1!=null)c1.Y(a3,a,c6,c7,c8)}++a3}++a}break
case 4:q=e5.c
if(q==null)throw A.h(A.m("Unsupported color mode (4 components)"))
q=q.d===0
if(0>=s)return A.a(e4,0)
j=e4[0]
if(1>=s)return A.a(e4,1)
a7=e4[1]
if(2>=s)return A.a(e4,2)
a8=e4[2]
if(3>=s)return A.a(e4,3)
c9=e4[3]
a9=j.e
b0=a7.e
b1=a8.e
d0=c9.e
h=j.f
g=j.r
b2=a7.f
b3=a7.r
b4=a8.f
b5=a8.r
d1=c9.f
d2=c9.r
e4=r===8
s=r===7
f=r===6
e=r===5
d=r===4
c=r===3
b=r===2
a0=a9.length
a4=b0.length
b6=b1.length
c1=d0.length
a=0
for(;;){d3=e5.d.d
d3.toString
if(!(a<d3))break
a1=B.a.a4(a,g)
b7=B.a.a4(a,b3)
b8=B.a.a4(a,b5)
d4=B.a.a4(a,d2)
if(!(a1<a0))return A.a(a9,a1)
a2=a9[a1]
if(!(b7<a4))return A.a(b0,b7)
b9=b0[b7]
if(!(b8<b6))return A.a(b1,b8)
c0=b1[b8]
if(!(d4<c1))return A.a(d0,d4)
d5=d0[d4]
d3=l-a
a3=0
for(;;){d6=e5.d.e
d6.toString
if(!(a3<d6))break
a5=B.a.a4(a3,h)
c2=B.a.a4(a3,b2)
c3=B.a.a4(a3,b4)
d7=B.a.a4(a3,d1)
if(q){if(!(a5<a2.length))return A.a(a2,a5)
d8=a2[a5]
if(!(c2<b9.length))return A.a(b9,c2)
d9=b9[c2]
if(!(c3<c0.length))return A.a(c0,c3)
a6=c0[c3]
if(!(d7<d5.length))return A.a(d5,d7)
e0=d5[d7]}else{if(!(a5<a2.length))return A.a(a2,a5)
a6=a2[a5]
if(!(c2<b9.length))return A.a(b9,c2)
c4=b9[c2]
if(!(c3<c0.length))return A.a(c0,c3)
c5=c0[c3]
if(!(d7<d5.length))return A.a(d5,d7)
e0=d5[d7]
d6=c5-128
d8=255-B.a.P(B.b.i(a6+1.402*d6),0,255)
e1=c4-128
d9=255-B.b.i(B.b.P(a6-0.3441363*e1-0.71413636*d6,0,255))
a6=255-B.a.P(B.b.i(a6+1.772*e1),0,255)}d6=B.a.j(d8*e0,8)
c6=(d6&2147483647)-((d6&2147483648)>>>0)
d6=B.a.j(d9*e0,8)
c7=(d6&2147483647)-((d6&2147483648)>>>0)
d6=B.a.j(a6*e0,8)
c8=(d6&2147483647)-((d6&2147483648)>>>0)
if(b){d6=m.a
if(d6!=null)d6.Y(k-a3,a,c6,c7,c8)}else if(c){d6=m.a
if(d6!=null)d6.Y(k-a3,d3,c6,c7,c8)}else if(d){d6=m.a
if(d6!=null)d6.Y(a3,d3,c6,c7,c8)}else if(e){d6=m.a
if(d6!=null)d6.Y(a,a3,c6,c7,c8)}else if(f){d6=m.a
if(d6!=null)d6.Y(d3,a3,c6,c7,c8)}else if(s){d6=m.a
if(d6!=null)d6.Y(d3,k-a3,c6,c7,c8)}else{d6=m.a
if(e4){if(d6!=null)d6.Y(a,k-a3,c6,c7,c8)}else if(d6!=null)d6.Y(a3,a,c6,c7,c8)}++a3}++a}break
default:throw A.h(A.m("Unsupported color mode"))}return m},
pL(a,b,c,d,e,f){A.pI(f,a,b,c,d,e,!0,f)},
pM(a,b,c,d,e,f){A.pJ(f,a,b,c,d,e,!0,f)},
pK(a,b,c,d,e,f){A.pH(f,a,b,c,d,e,!0,f)},
dk(a,b,c,d,e){var s,r,q
for(s=0;s<d;++s){r=J.d(a.a,a.d+s)
q=J.d(b.a,b.d+s)
J.y(c.a,c.d+s,r+q)}},
pI(a,b,c,d,e,f,g,h){var s,r,q=null,p=e*d,o=e+f,n=A.v(a,!1,q,p),m=A.v(a,!1,q,p),l=A.p(m,q,0)
if(e===0){m.h(0,0,J.d(n.a,n.d))
A.dk(A.p(n,q,1),l,A.p(m,q,1),b-1,!0)
l.d+=d
n.d+=d
m.d+=d
e=1}for(s=-d,r=b-1;e<o;){A.dk(n,A.p(l,q,s),m,1,!0)
A.dk(A.p(n,q,1),l,A.p(m,q,1),r,!0);++e
l.d+=d
n.d+=d
m.d+=d}},
pJ(a,b,c,d,e,f,g,h){var s=null,r=e*d,q=e+f,p=A.v(a,!1,s,r),o=A.v(h,!1,s,r),n=A.p(o,s,0)
if(e===0){o.h(0,0,J.d(p.a,p.d))
A.dk(A.p(p,s,1),n,A.p(o,s,1),b-1,!0)
p.d+=d
o.d+=d
e=1}else n.d-=d
while(e<q){A.dk(p,n,o,b,!0);++e
n.d+=d
p.d+=d
o.d+=d}},
pH(a,b,c,d,e,f,g,h){var s,r,q,p,o,n=null,m=e*d,l=e+f,k=A.v(a,!1,n,m),j=A.v(h,!1,n,m),i=A.p(j,n,0)
if(e===0){j.h(0,0,J.d(k.a,k.d))
A.dk(A.p(k,n,1),i,A.p(j,n,1),b-1,!0)
i.d+=d
k.d+=d
j.d+=d
e=1}for(s=-d;e<l;){A.dk(k,A.p(i,n,s),j,1,!0)
for(r=1;r<b;++r){q=r-d
p=J.d(i.a,i.d+(r-1))+J.d(i.a,i.d+q)-J.d(i.a,i.d+(q-1))
if((p&4294967040)>>>0===0)o=p
else o=p<0?0:255
q=J.d(k.a,k.d+r)
J.y(j.a,j.d+r,q+o)}++e
i.d+=d
k.d+=d
j.d+=d}},
rb(a){var s="ifd0",r=A.bv(a,!1,!1)
if(!a.gbF().l(0,s).a.ag(274)||a.gbF().l(0,s).gcg()===1)return r
r.e=A.dD(a.gbF())
r.gbF().l(0,s).scg(null)
switch(a.gbF().l(0,s).gcg()){case 2:return A.i1(r)
case 3:return A.ro(r,B.d8)
case 4:return A.i1(A.i_(r,180))
case 5:return A.i1(A.i_(r,90))
case 6:return A.i_(r,90)
case 7:return A.i1(A.i_(r,-90))
case 8:return A.i_(r,-90)}return r},
rg(a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=null,a1=a4==null
if(a1&&a3==null)throw A.h(A.m("Invalid size"))
a2.gaK()
if(a2.gbF().l(0,"ifd0").a.ag(274)&&a2.gbF().l(0,"ifd0").gcg()!==1)a2=A.rb(a2)
if(a3==null||a3<=0){a4.toString
a3=B.b.bq(a4*(a2.gK()/a2.gS()))}if(a1||a4<=0)a4=B.b.bq(a3*(a2.gS()/a2.gK()))
if(a4===a2.gS()&&a3===a2.gK())return A.bv(a2,!1,!1)
s=new Int32Array(a4)
r=a2.gS()/a4
for(q=0;q<a4;++q){a1=B.b.i(q*r)
if(!(q<a4))return A.a(s,q)
s[q]=a1}p=new Int32Array(a3)
o=a2.gK()/a3
for(n=0;n<a3;++n){a1=B.b.i(n*o)
if(!(n<a3))return A.a(p,n)
p[n]=a1}m=a2.gah().length
for(a1=t.g,l=a0,k=0;k<m;++k){j=a2.x
if(j===$)j=a2.x=A.j([],a1)
if(!(k<j.length))return A.a(j,k)
i=j[k]
h=A.fH(i,a3,!0,a4)
g=l==null
if(!g)l.aI(h)
if(g)l=h
g=i.a
f=g==null
e=f?a0:g.b
o=(e==null?0:e)/a3
if((f?a0:g.gM())!=null)for(n=0;n<a3;++n){d=B.b.i(n*o)
for(q=0;q<a4;++q){if(!(q<a4))return A.a(s,q)
g=s[q]
f=i.a
g=f==null?a0:B.b.i(f.aR(g,d).gT())
if(g==null)g=0
f=h.a
if(f!=null)f.aL(q,n,g)}}else{c=i.ap(0,0)
for(n=0;n<a3;++n)for(q=0;q<a4;++q){if(!(q<a4))return A.a(s,q)
g=s[q]
if(!(n<a3))return A.a(p,n)
f=p[n]
e=i.a
if(e!=null)e.N(g,f,c)
g=c.gm()
f=c.gt()
e=c.gu()
b=c.gA()
a=h.a
if(a!=null)a.aq(q,n,g,f,e,b)}}}l.toString
return l},
i_(a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7=null,a8=B.a.a8(b0,360)
a9.gaK()
if(B.a.a8(a8,90)===0)switch(B.a.X(a8,90)){case 1:return A.qY(a9)
case 2:return A.qW(a9)
case 3:return A.qX(a9)
default:return A.bv(a9,!1,!1)}s=a8*3.141592653589793/180
r=Math.cos(s)
q=Math.sin(s)
p=a9.gS()
o=a9.gS()
n=a9.gK()
m=a9.gK()
l=0.5*a9.gS()
k=0.5*a9.gK()
n=Math.abs(p*r)+Math.abs(n*q)
j=0.5*n
m=Math.abs(o*q)+Math.abs(m*r)
i=0.5*m
h=a9.gah().length
for(p=t.g,g=a7,f=0;f<h;++f){e=a9.x
if(e===$)e=a9.x=A.j([],p)
if(!(f<e.length))return A.a(e,f)
d=e[f]
o=g==null
c=o?a7:g.di()
if(c==null){b=B.b.i(n)
c=A.fH(a9,B.b.i(m),!0,b)}if(o)g=c
for(o=c.a,o=o.gH(o);o.D();){a=o.gO()
a0=a.gaU()
a1=a.gaQ()
b=a0-j
a2=a1-i
a3=l+b*r+a2*q
a4=k-b*q+a2*r
b=!1
if(a3>=0)if(a4>=0){a2=d.a
a5=a2==null
a6=a5?a7:a2.a
if(a3<(a6==null?0:a6)){b=a5?a7:a2.b
b=a4<(b==null?0:b)}}if(b)c.c5(a0,a1,d.hk(a3,a4,B.dc))}}g.toString
return g},
qY(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gah(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.a1)(s),++p){o=s[p]
n=q==null
m=n?f:q.di()
if(m==null){l=o.a
k=l==null
j=k?f:l.b
if(j==null)j=0
l=k?f:l.a
m=A.fH(o,l==null?0:l,!0,j)}if(n)q=m
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
n=n==null?f:n.N(h,i-g,f)
m.c5(g,h,n==null?new A.D():n);++g}++h}}q.toString
return q},
qW(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gah(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.a1)(s),++p){o=s[p]
n=o.a
m=n==null
l=m?f:n.a
k=(l==null?0:l)-1
n=m?f:n.b
j=(n==null?0:n)-1
n=q==null
i=n?f:q.di()
if(i==null)i=A.bv(o,!0,!0)
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
m=m==null?f:m.N(k-g,n,f)
i.c5(g,h,m==null?new A.D():m);++g}++h}}q.toString
return q},
qX(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=null
for(s=a.gah(),r=s.length,q=f,p=0;p<s.length;s.length===r||(0,A.a1)(s),++p){o=s[p]
n=a.a
n=n==null?f:n.a
m=(n==null?0:n)-1
n=q==null
l=n?f:q.di()
if(l==null){k=o.a
j=k==null
i=j?f:k.b
if(i==null)i=0
k=j?f:k.a
l=A.fH(o,k==null?0:k,!0,i)}if(n)q=l
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
k=k==null?f:k.N(n,g,f)
l.c5(g,h,k==null?new A.D():k);++g}++h}}q.toString
return q},
kg(a){var s
a=(a&-a)>>>0
s=a!==0?31:32
if((a&65535)!==0)s-=16
if((a&16711935)!==0)s-=8
if((a&252645135)!==0)s-=4
if((a&858993459)!==0)s-=2
return(a&1431655765)!==0?s-1:s},
rN(a){var s
$.lJ().h(0,0,a)
s=$.nI()
if(0>=s.length)return A.a(s,0)
return s[0]},
no(a,b,c,d){return(B.a.P(a,0,255)|B.a.P(b,0,255)<<8|B.a.P(c,0,255)<<16|B.a.P(d,0,255)<<24)>>>0},
b5(a,b,c){var s,r,q,p,o=b.gv(b),n=b.gL(),m=a.gM(),l=m==null?null:m.gL()
if(l==null)l=a.gL()
s=a.gv(a)
if(o===1)b.h(0,0,A.hZ(B.b.bl(a.gv(a)>2?a.gan():a.l(0,0)),l,n))
else if(o<=s)for(r=0;r<o;++r)b.h(0,r,A.hZ(a.l(0,r),l,n))
else if(s===2){q=A.hZ(a.l(0,0),l,n)
if(o===3){b.h(0,0,q)
b.h(0,1,q)
b.h(0,2,q)}else{c=A.hZ(a.l(0,1),l,n)
b.h(0,0,q)
b.h(0,1,q)
b.h(0,2,q)
b.h(0,3,c)}}else{for(r=0;r<s;++r)b.h(0,r,A.hZ(a.l(0,r),l,n))
p=s===1?b.l(0,0):0
for(r=s;r<o;++r)b.h(0,r,r===3?c:p)}return b},
aJ(a,b,c,d,e){var s,r,q=a.gM(),p=q==null?null:q.gL()
if(p==null)p=a.gL()
q=e==null
s=q?null:e.gL()
c=s==null?c:s
if(c==null)c=a.gL()
s=q?null:e.gv(e)
d=s==null?d:s
if(d==null)d=a.gv(a)
if(b==null)b=0
if(c===p&&d===a.gv(a)){if(q)return a.U()
e.af(a)
return e}switch(c.a){case 3:if(q)r=new A.bK(new Uint8Array(d))
else r=e
return A.b5(a,r,b)
case 0:return A.b5(a,q?new A.cI(d,0):e,b)
case 1:return A.b5(a,q?new A.cK(d,0):e,b)
case 2:if(q){q=d<3?1:2
r=new A.cM(d,new Uint8Array(q))}else r=e
return A.b5(a,r,b)
case 4:if(q)r=new A.cJ(new Uint16Array(d))
else r=e
return A.b5(a,r,b)
case 5:if(q)r=new A.cL(new Uint32Array(d))
else r=e
return A.b5(a,r,b)
case 6:if(q)r=new A.cG(new Int8Array(d))
else r=e
return A.b5(a,r,b)
case 7:if(q)r=new A.cE(new Int16Array(d))
else r=e
return A.b5(a,r,b)
case 8:if(q)r=new A.cF(new Int32Array(d))
else r=e
return A.b5(a,r,b)
case 9:if(q)r=new A.cB(new Uint16Array(d))
else r=e
return A.b5(a,r,b)
case 10:if(q)r=new A.cC(new Float32Array(d))
else r=e
return A.b5(a,r,b)
case 11:if(q)r=new A.cD(new Float64Array(d))
else r=e
return A.b5(a,r,b)}},
Y(a){return 0.299*a.gm()+0.587*a.gt()+0.114*a.gu()},
nd(a,b,c,d,e){var s=1-d/255
B.c.h(e,0,B.b.bq(255*(1-a/255)*s))
B.c.h(e,1,B.b.bq(255*(1-b/255)*s))
B.c.h(e,2,B.b.bq(255*(1-c/255)*s))},
J(a){var s,r,q,p=$.lI()
p.$flags&2&&A.c(p)
p[0]=a
p=$.nH()
if(0>=p.length)return A.a(p,0)
s=p[0]
if(a===0)return s>>>16
if($.R==null)A.V()
r=s>>>23&511
p=$.m_.cD()
if(!(r<p.length))return A.a(p,r)
r=p[r]
if(r!==0){q=s&8388607
return r+(q+4095+(q>>>13&1)>>>13)}return A.ob(s)},
ob(a){var s,r,q=a>>>16&32768,p=(a>>>23&255)-112,o=a&8388607
if(p<=0){if(p<-10)return q
o|=8388608
s=14-p
return(q|B.a.bg(o+(B.a.V(1,s-1)-1)+(B.a.a5(o,s)&1),s))>>>0}else if(p===143)if(o===0)return q|31744
else{o=o>>>13
r=o===0?1:0
return q|o|r|31744}else{o=o+4095+(o>>>13&1)
if((o&8388608)!==0){++p
o=0}if(p>30)return q|31744
return(q|p<<10|o>>>13)>>>0}},
V(){var s,r,q,p,o,n=$.R
if(n!=null)return n
s=new Uint32Array(65536)
$.R=J.lK(B.o.gB(s),0,null)
n=new Uint16Array(512)
$.m_.b=n
for(r=0;r<256;++r){q=(r&255)-112
if(q<=0||q>=30){n[r]=0
p=(r|256)>>>0
if(!(p<512))return A.a(n,p)
n[p]=0}else{p=q<<10>>>0
n[r]=p
o=(r|256)>>>0
if(!(o<512))return A.a(n,o)
n[o]=(p|32768)>>>0}}for(r=0;r<65536;++r)s[r]=A.oc(r)
n=$.R
n.toString
return n},
oc(a){var s,r=a>>>15&1,q=a>>>10&31,p=a&1023
if(q===0)if(p===0)return r<<31>>>0
else{while((p&1024)===0){p=p<<1;--q}++q
p&=4294966271}else if(q===31){s=r<<31
if(p===0)return(s|2139095040)>>>0
else return(s|p<<13|2139095040)>>>0}return(r<<31|q+112<<23|p<<13)>>>0},
oT(a){var s="[Matrix] "+a.a,r=a.c
if(r!=null)s+="\n"+r.C(0)
switch(a.d.a){case 0:A.bi(v.G.console).error("!!!CRITICAL!!! "+s)
break
case 1:A.bi(v.G.console).error(s)
break
case 2:A.bi(v.G.console).warn(s)
break
case 3:A.bi(v.G.console).info(s)
break
case 4:A.bi(v.G.console).debug(s)
break
case 5:A.bi(v.G.console).log(s)
break}},
rF(){return A.lC()}},B={}
var w=[A,J,B]
var $={}
A.kQ.prototype={}
J.fO.prototype={
W(a,b){return a===b},
gJ(a){return A.es(a)},
C(a){return"Instance of '"+A.hl(a)+"'"},
gaP(a){return A.bI(A.lr(this))}}
J.h1.prototype={
C(a){return String(a)},
gJ(a){return a?519018:218159},
gaP(a){return A.bI(t.y)},
$iM:1,
$ib6:1}
J.dX.prototype={
W(a,b){return null==b},
C(a){return"null"},
gJ(a){return 0},
$iM:1}
J.e_.prototype={$iZ:1}
J.bQ.prototype={
gJ(a){return 0},
C(a){return String(a)}}
J.hg.prototype={}
J.di.prototype={}
J.bw.prototype={
C(a){var s=a[$.lF()]
if(s==null)return this.hy(a)
return"JavaScript function for "+J.dx(s)},
$ibq:1}
J.d3.prototype={
gJ(a){return 0},
C(a){return String(a)}}
J.d4.prototype={
gJ(a){return 0},
C(a){return String(a)}}
J.t.prototype={
G(a,b){A.av(a).c.a(b)
a.$flags&1&&A.c(a,29)
a.push(b)},
h7(a,b){var s
a.$flags&1&&A.c(a,"removeAt",1)
s=a.length
if(b>=s)throw A.h(A.mx(b,null))
return a.splice(b,1)[0]},
fD(a,b){var s
A.av(a).q("e<1>").a(b)
a.$flags&1&&A.c(a,"addAll",2)
if(Array.isArray(b)){this.hU(a,b)
return}for(s=J.fb(b);s.D();)a.push(s.gO())},
hU(a,b){var s,r
t.gn.a(b)
s=b.length
if(s===0)return
if(a===b)throw A.h(A.ba(a))
for(r=0;r<s;++r)a.push(b[r])},
cs(a,b,c){var s=A.av(a)
return new A.b0(a,s.am(c).q("1(2)").a(b),s.q("@<1>").am(c).q("b0<1,2>"))},
kL(a,b){var s,r=A.S(a.length,"",!1,t.N)
for(s=0;s<a.length;++s)this.h(r,s,A.z(a[s]))
return r.join(b)},
h8(a,b){return A.dh(a,0,A.f8(b,"count",t.p),A.av(a).c)},
dq(a,b){return A.dh(a,b,null,A.av(a).c)},
bE(a,b){if(!(b>=0&&b<a.length))return A.a(a,b)
return a[b]},
bh(a,b,c){if(b<0||b>a.length)throw A.h(A.an(b,0,a.length,"start",null))
if(c<b||c>a.length)throw A.h(A.an(c,b,a.length,"end",null))
if(b===c)return A.j([],A.av(a))
return A.j(a.slice(b,c),A.av(a))},
gkC(a){if(a.length>0)return a[0]
throw A.h(A.iC())},
gh2(a){var s=a.length
if(s>0)return a[s-1]
throw A.h(A.iC())},
ar(a,b,c,d,e){var s,r,q,p,o
A.av(a).q("e<1>").a(d)
a.$flags&2&&A.c(a,5)
A.bz(b,c,a.length)
s=c-b
if(s===0)return
A.df(e,"skipCount")
if(t.j.b(d)){r=d
q=e}else{r=J.kE(d,e).e6(0,!1)
q=0}p=J.a9(r)
if(q+s>p.gv(r))throw A.h(A.mg())
if(q<b)for(o=s-1;o>=0;--o)a[b+o]=p.l(r,q+o)
else for(o=0;o<s;++o)a[b+o]=p.l(r,q+o)},
aO(a,b,c,d){var s
A.av(a).q("1?").a(d)
a.$flags&2&&A.c(a,"fillRange")
A.bz(b,c,a.length)
for(s=b;s<c;++s)a[s]=d},
cd(a,b){var s
for(s=0;s<a.length;++s)if(J.fa(a[s],b))return!0
return!1},
C(a){return A.mh(a,"[","]")},
gH(a){return new J.dy(a,a.length,A.av(a).q("dy<1>"))},
gJ(a){return A.es(a)},
gv(a){return a.length},
sv(a,b){a.$flags&1&&A.c(a,"set length","change the length of")
if(b<0)throw A.h(A.an(b,0,null,"newLength",null))
if(b>a.length)A.av(a).c.a(null)
a.length=b},
l(a,b){if(!(b>=0&&b<a.length))throw A.h(A.ki(a,b))
return a[b]},
h(a,b,c){A.av(a).c.a(c)
a.$flags&2&&A.c(a)
if(!(b>=0&&b<a.length))throw A.h(A.ki(a,b))
a[b]=c},
he(a,b){return new A.cu(a,b.q("cu<0>"))},
$iag:1,
$iC:1,
$ie:1,
$iq:1}
J.h_.prototype={
l6(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.hl(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.iD.prototype={}
J.dy.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
D(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.a1(q)
throw A.h(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$iA:1}
J.dZ.prototype={
dZ(a,b){var s
if(a<b)return-1
else if(a>b)return 1
else if(a===b){if(a===0){s=this.ge3(b)
if(this.ge3(a)===s)return 0
if(this.ge3(a))return-1
return 1}return 0}else if(isNaN(a)){if(isNaN(b))return 0
return 1}else return-1},
ge3(a){return a===0?1/a<0:a<0},
gec(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
i(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.h(A.bh(""+a+".toInt()"))},
bb(a){var s,r
if(a>=0){if(a<=2147483647){s=a|0
return a===s?s:s+1}}else if(a>=-2147483648)return a|0
r=Math.ceil(a)
if(isFinite(r))return r
throw A.h(A.bh(""+a+".ceil()"))},
bl(a){var s,r
if(a>=0){if(a<=2147483647)return a|0}else if(a>=-2147483648){s=a|0
return a===s?s:s-1}r=Math.floor(a)
if(isFinite(r))return r
throw A.h(A.bh(""+a+".floor()"))},
bq(a){if(a>0){if(a!==1/0)return Math.round(a)}else if(a>-1/0)return 0-Math.round(0-a)
throw A.h(A.bh(""+a+".round()"))},
P(a,b,c){if(this.dZ(b,c)>0)throw A.h(A.bZ(b))
if(this.dZ(a,b)<0)return b
if(this.dZ(a,c)>0)return c
return a},
dn(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.h(A.an(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.a(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.b8(A.bh("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.a(p,1)
s=p[1]
if(3>=r)return A.a(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.n.hm("0",o)},
C(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gJ(a){var s,r,q,p,o=a|0
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
aG(a,b){A.mY(b)
if((a|0)===a)if(b>=1||b<-1)return a/b|0
return this.fj(a,b)},
X(a,b){return(a|0)===a?a/b|0:this.fj(a,b)},
fj(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.h(A.bh("Result of truncating division is "+A.z(s)+": "+A.z(a)+" ~/ "+b))},
V(a,b){if(b<0)throw A.h(A.bZ(b))
return b>31?0:a<<b>>>0},
R(a,b){return b>31?0:a<<b>>>0},
bg(a,b){var s
if(b<0)throw A.h(A.bZ(b))
if(a>0)s=this.a4(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
j(a,b){var s
if(a>0)s=this.a4(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
a5(a,b){if(0>b)throw A.h(A.bZ(b))
return this.a4(a,b)},
a4(a,b){return b>31?0:a>>>b},
gaP(a){return A.bI(t.q)},
$iB:1,
$ik:1}
J.d1.prototype={
gec(a){var s
if(a>0)s=1
else s=a<0?-1:a
return s},
aB(a,b){var s=this.V(1,b-1)
return((a&s-1)>>>0)-((a&s)>>>0)},
gaP(a){return A.bI(t.p)},
$iM:1,
$if:1}
J.dY.prototype={
gaP(a){return A.bI(t.V)},
$iM:1}
J.d2.prototype={
bw(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.hw(a,r-s)},
ef(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
hx(a,b,c){return a.substring(b,A.bz(b,c,a.length))},
hw(a,b){return this.hx(a,b,null)},
hd(a){var s,r,q,p=a.trim(),o=p.length
if(o===0)return p
if(0>=o)return A.a(p,0)
if(p.charCodeAt(0)===133){s=J.oo(p,1)
if(s===o)return""}else s=0
r=o-1
if(!(r>=0))return A.a(p,r)
q=p.charCodeAt(r)===133?J.op(p,r):o
if(s===0&&q===o)return p
return p.substring(s,q)},
hm(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.h(B.cS)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
C(a){return a},
gJ(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gaP(a){return A.bI(t.N)},
gv(a){return a.length},
$iag:1,
$iM:1,
$imq:1,
$iX:1}
A.d5.prototype={
C(a){return"LateInitializationError: "+this.a}}
A.al.prototype={
gv(a){return this.a.length},
l(a,b){var s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s.charCodeAt(b)}}
A.ja.prototype={}
A.C.prototype={}
A.aA.prototype={
gH(a){var s=this
return new A.cb(s,s.gv(s),A.l(s).q("cb<aA.E>"))},
cs(a,b,c){var s=A.l(this)
return new A.b0(this,s.am(c).q("1(aA.E)").a(b),s.q("@<aA.E>").am(c).q("b0<1,2>"))},
kY(a,b){var s,r,q,p=this
A.l(p).q("aA.E(aA.E,aA.E)").a(b)
s=p.gv(p)
if(s===0)throw A.h(A.iC())
r=p.bE(0,0)
for(q=1;q<s;++q){r=b.$2(r,p.bE(0,q))
if(s!==p.gv(p))throw A.h(A.ba(p))}return r}}
A.eB.prototype={
giN(){var s=J.bm(this.a),r=this.c
if(r==null||r>s)return s
return r},
gka(){var s=J.bm(this.a),r=this.b
if(r>s)return s
return r},
gv(a){var s,r=J.bm(this.a),q=this.b
if(q>=r)return 0
s=this.c
if(s==null||s>=r)return r-q
return s-q},
bE(a,b){var s=this,r=s.gka()+b
if(b<0||r>=s.giN())throw A.h(A.kP(b,s.gv(0),s,null,"index"))
return J.lM(s.a,r)},
dq(a,b){var s,r,q=this
A.df(b,"count")
s=q.b+b
r=q.c
if(r!=null&&s>=r)return new A.c3(q.$ti.q("c3<1>"))
return A.dh(q.a,s,r,q.$ti.c)},
e6(a,b){var s,r,q,p=this,o=p.b,n=p.a,m=J.a9(n),l=m.gv(n),k=p.c
if(k!=null&&k<l)l=k
s=l-o
if(s<=0){n=p.$ti.c
return b?J.h0(0,n):J.mi(0,n)}r=A.S(s,m.bE(n,o),b,p.$ti.c)
for(q=1;q<s;++q){B.c.h(r,q,m.bE(n,o+q))
if(m.gv(n)<l)throw A.h(A.ba(p))}return r},
l3(a){return this.e6(0,!0)}}
A.cb.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
D(){var s,r=this,q=r.a,p=J.a9(q),o=p.gv(q)
if(r.b!==o)throw A.h(A.ba(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.bE(q,s);++r.c
return!0},
$iA:1}
A.by.prototype={
gH(a){var s=this.a
return new A.e4(s.gH(s),this.b,A.l(this).q("e4<1,2>"))},
gv(a){var s=this.a
return s.gv(s)}}
A.dA.prototype={$iC:1}
A.e4.prototype={
D(){var s=this,r=s.b
if(r.D()){s.a=s.c.$1(r.gO())
return!0}s.a=null
return!1},
gO(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$iA:1}
A.b0.prototype={
gv(a){return J.bm(this.a)},
bE(a,b){return this.b.$1(J.lM(this.a,b))}}
A.eN.prototype={
gH(a){return new A.eO(J.fb(this.a),this.b,this.$ti.q("eO<1>"))},
cs(a,b,c){var s=this.$ti
return new A.by(this,s.am(c).q("1(2)").a(b),s.q("@<1>").am(c).q("by<1,2>"))}}
A.eO.prototype={
D(){var s,r
for(s=this.a,r=this.b;s.D();)if(r.$1(s.gO()))return!0
return!1},
gO(){return this.a.gO()},
$iA:1}
A.c3.prototype={
gH(a){return B.cL},
gv(a){return 0},
cs(a,b,c){this.$ti.am(c).q("1(2)").a(b)
return new A.c3(c.q("c3<0>"))}}
A.dB.prototype={
D(){return!1},
gO(){throw A.h(A.iC())},
$iA:1}
A.cu.prototype={
gH(a){return new A.eP(J.fb(this.a),this.$ti.q("eP<1>"))}}
A.eP.prototype={
D(){var s,r
for(s=this.a,r=this.$ti.c;s.D();)if(r.b(s.gO()))return!0
return!1},
gO(){return this.$ti.c.a(this.a.gO())},
$iA:1}
A.ar.prototype={}
A.bD.prototype={
h(a,b,c){A.l(this).q("bD.E").a(c)
throw A.h(A.bh("Cannot modify an unmodifiable list"))},
ar(a,b,c,d,e){A.l(this).q("e<bD.E>").a(d)
throw A.h(A.bh("Cannot modify an unmodifiable list"))},
bB(a,b,c,d){return this.ar(0,b,c,d,0)},
aO(a,b,c,d){A.l(this).q("bD.E?").a(d)
throw A.h(A.bh("Cannot modify an unmodifiable list"))}}
A.dj.prototype={}
A.cN.prototype={
C(a){return A.kU(this)},
$iaP:1}
A.cO.prototype={
gv(a){return this.b.length},
gf1(){var s=this.$keys
if(s==null){s=Object.keys(this.a)
this.$keys=s}return s},
ag(a){if(typeof a!="string")return!1
if("__proto__"===a)return!1
return this.a.hasOwnProperty(a)},
l(a,b){if(!this.ag(b))return null
return this.b[this.a[b]]},
bI(a,b){var s,r,q,p
this.$ti.q("~(1,2)").a(b)
s=this.gf1()
r=this.b
for(q=s.length,p=0;p<q;++p)b.$2(s[p],r[p])},
gc3(){return new A.eU(this.gf1(),this.$ti.q("eU<1>"))}}
A.eU.prototype={
gv(a){return this.a.length},
gH(a){var s=this.a
return new A.eV(s,s.length,this.$ti.q("eV<1>"))}}
A.eV.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
D(){var s=this,r=s.c
if(r>=s.b){s.d=null
return!1}s.d=s.a[r]
s.c=r+1
return!0},
$iA:1}
A.c6.prototype={
d7(){var s=this,r=s.$map
if(r==null){r=new A.e0(s.$ti.q("e0<1,2>"))
A.nh(s.a,r)
s.$map=r}return r},
l(a,b){return this.d7().l(0,b)},
bI(a,b){this.$ti.q("~(1,2)").a(b)
this.d7().bI(0,b)},
gc3(){var s=this.d7()
return new A.ca(s,A.l(s).q("ca<1>"))},
gv(a){return this.d7().a}}
A.fL.prototype={
W(a,b){if(b==null)return!1
return b instanceof A.d_&&this.a.W(0,b.a)&&A.lw(this)===A.lw(b)},
gJ(a){return A.kW(this.a,A.lw(this),B.ac)},
C(a){var s=B.c.kL([A.bI(this.$ti.c)],", ")
return this.a.C(0)+" with "+("<"+s+">")}}
A.d_.prototype={
$2(a,b){return this.a.$1$2(a,b,this.$ti.y[0])},
$S(){return A.rB(A.kf(this.a),this.$ti)}}
A.ex.prototype={}
A.jh.prototype={
bJ(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
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
A.ee.prototype={
C(a){return"Null check operator used on a null value"}}
A.h5.prototype={
C(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.hE.prototype={
C(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.iX.prototype={
C(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.dC.prototype={}
A.f0.prototype={
C(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$iaT:1}
A.aq.prototype={
C(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.np(r==null?"unknown":r)+"'"},
$ibq:1,
glc(){return this},
$C:"$1",
$R:1,
$D:null}
A.fi.prototype={$C:"$0",$R:0}
A.fj.prototype={$C:"$2",$R:2}
A.hz.prototype={}
A.hy.prototype={
C(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.np(s)+"'"}}
A.cz.prototype={
W(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.cz))return!1
return this.$_target===b.$_target&&this.a===b.a},
gJ(a){return(A.i2(this.a)^A.es(this.$_target))>>>0},
C(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.hl(this.a)+"'")}}
A.hx.prototype={
C(a){return"RuntimeError: "+this.a}}
A.b_.prototype={
gv(a){return this.a},
gc3(){return new A.ca(this,A.l(this).q("ca<1>"))},
ag(a){var s,r
if(typeof a=="string"){s=this.b
if(s==null)return!1
return s[a]!=null}else if(typeof a=="number"&&(a&0x3fffffff)===a){r=this.c
if(r==null)return!1
return r[a]!=null}else return this.kG(a)},
kG(a){var s=this.d
if(s==null)return!1
return this.cO(s[this.cN(a)],a)>=0},
l(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.kH(b)},
kH(a){var s,r,q=this.d
if(q==null)return null
s=q[this.cN(a)]
r=this.cO(s,a)
if(r<0)return null
return s[r].b},
h(a,b,c){var s,r,q=this,p=A.l(q)
p.c.a(b)
p.y[1].a(c)
if(typeof b=="string"){s=q.b
q.el(s==null?q.b=q.dN():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=q.c
q.el(r==null?q.c=q.dN():r,b,c)}else q.kJ(b,c)},
kJ(a,b){var s,r,q,p,o=this,n=A.l(o)
n.c.a(a)
n.y[1].a(b)
s=o.d
if(s==null)s=o.d=o.dN()
r=o.cN(a)
q=s[r]
if(q==null)s[r]=[o.dO(a,b)]
else{p=o.cO(q,a)
if(p>=0)q[p].b=b
else q.push(o.dO(a,b))}},
dm(a,b){var s=this
if(typeof b=="string")return s.fe(s.b,b)
else if(typeof b=="number"&&(b&0x3fffffff)===b)return s.fe(s.c,b)
else return s.kI(b)},
kI(a){var s,r,q,p,o=this,n=o.d
if(n==null)return null
s=o.cN(a)
r=n[s]
q=o.cO(r,a)
if(q<0)return null
p=r.splice(q,1)[0]
o.fn(p)
if(r.length===0)delete n[s]
return p.b},
bI(a,b){var s,r,q=this
A.l(q).q("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.h(A.ba(q))
s=s.c}},
el(a,b,c){var s,r=A.l(this)
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.dO(b,c)
else s.b=c},
fe(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.fn(s)
delete a[b]
return s.b},
f4(){this.r=this.r+1&1073741823},
dO(a,b){var s=this,r=A.l(s),q=new A.iO(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.f4()
return q},
fn(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.f4()},
cN(a){return J.bJ(a)&1073741823},
cO(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.fa(a[r].a,b))return r
return-1},
C(a){return A.kU(this)},
dN(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$iiN:1}
A.iO.prototype={}
A.ca.prototype={
gv(a){return this.a.a},
gH(a){var s=this.a
return new A.O(s,s.r,s.e,this.$ti.q("O<1>"))}}
A.O.prototype={
gO(){return this.d},
D(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.h(A.ba(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$iA:1}
A.iP.prototype={
gv(a){return this.a.a},
gH(a){var s=this.a
return new A.at(s,s.r,s.e,this.$ti.q("at<1>"))}}
A.at.prototype={
gO(){return this.d},
D(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.h(A.ba(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.b
r.c=s.c
return!0}},
$iA:1}
A.e0.prototype={
cN(a){return A.re(a)&1073741823},
cO(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.fa(a[r].a,b))return r
return-1}}
A.kl.prototype={
$1(a){return this.a(a)},
$S:32}
A.km.prototype={
$2(a,b){return this.a(a,b)},
$S:35}
A.kn.prototype={
$1(a){return this.a(A.bG(a))},
$S:34}
A.jJ.prototype={
cD(){var s=this.b
if(s===this)throw A.h(A.iK(this.a))
return s}}
A.cc.prototype={
gcP(a){return a.byteLength},
gaP(a){return B.l_},
cG(a,b,c){A.aI(a,b,c)
return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
fM(a){return this.cG(a,0,null)},
fJ(a,b,c){A.aI(a,b,c)
return c==null?new Int8Array(a,b):new Int8Array(a,b,c)},
dj(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,2)
return new Uint16Array(a,b,c)},
fK(a){return this.dj(a,0,null)},
fH(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,2)
return new Int16Array(a,b,c)},
fL(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,4)
return new Uint32Array(a,b,c)},
fI(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,4)
return new Int32Array(a,b,c)},
fG(a,b,c){A.aI(a,b,c)
c=B.a.X(a.byteLength-b,4)
return new Float32Array(a,b,c)},
$iM:1,
$icc:1,
$ifg:1}
A.ea.prototype={
gB(a){if(((a.$flags|0)&2)!==0)return new A.hU(a.buffer)
else return a.buffer},
je(a,b,c,d){var s=A.an(b,0,c,d,null)
throw A.h(s)},
ey(a,b,c,d){if(b>>>0!==b||b>c)this.je(a,b,c,d)},
$ia_:1}
A.hU.prototype={
gcP(a){return this.a.byteLength},
cG(a,b,c){var s=A.oF(this.a,b,c)
s.$flags=3
return s},
fM(a){return this.cG(0,0,null)},
fJ(a,b,c){var s=A.oA(this.a,b,c)
s.$flags=3
return s},
dj(a,b,c){var s=A.oC(this.a,b,c)
s.$flags=3
return s},
fK(a){return this.dj(0,0,null)},
fH(a,b,c){var s=A.ox(this.a,b,c)
s.$flags=3
return s},
fL(a,b,c){var s=A.oE(this.a,b,c)
s.$flags=3
return s},
fI(a,b,c){var s=A.oz(this.a,b,c)
s.$flags=3
return s},
fG(a,b,c){var s=A.ow(this.a,b,c)
s.$flags=3
return s},
$ifg:1}
A.h9.prototype={
gaP(a){return B.l0},
$iM:1,
$iia:1}
A.ai.prototype={
gv(a){return a.length},
fh(a,b,c,d,e){var s,r,q=a.length
this.ey(a,b,q,"start")
this.ey(a,c,q,"end")
if(b>c)throw A.h(A.an(b,0,c,null,null))
s=c-b
if(e<0)throw A.h(A.c2(e,null))
r=d.length
if(r-e<s)throw A.h(A.ld("Not enough elements"))
if(e!==0||r!==s)d=d.subarray(e,e+s)
a.set(d,b)},
$iag:1,
$iaF:1}
A.bR.prototype={
l(a,b){A.bH(b,a,a.length)
return a[b]},
h(a,b,c){A.hW(c)
a.$flags&2&&A.c(a)
A.bH(b,a,a.length)
a[b]=c},
ar(a,b,c,d,e){t.bM.a(d)
a.$flags&2&&A.c(a,5)
if(t.d4.b(d)){this.fh(a,b,c,d,e)
return}this.ei(a,b,c,d,e)},
bB(a,b,c,d){return this.ar(a,b,c,d,0)},
$iC:1,
$ie:1,
$iq:1}
A.aG.prototype={
h(a,b,c){A.o(c)
a.$flags&2&&A.c(a)
A.bH(b,a,a.length)
a[b]=c},
ar(a,b,c,d,e){t.hb.a(d)
a.$flags&2&&A.c(a,5)
if(t.bc.b(d)){this.fh(a,b,c,d,e)
return}this.ei(a,b,c,d,e)},
bB(a,b,c,d){return this.ar(a,b,c,d,0)},
$iC:1,
$ie:1,
$iq:1}
A.e5.prototype={
gaP(a){return B.l1},
bh(a,b,c){return new Float32Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$iil:1}
A.e6.prototype={
gaP(a){return B.l2},
bh(a,b,c){return new Float64Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$iim:1}
A.e7.prototype={
gaP(a){return B.l3},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Int16Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$ifM:1}
A.e8.prototype={
gaP(a){return B.l4},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Int32Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$ifN:1}
A.e9.prototype={
gaP(a){return B.l5},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Int8Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$iiB:1}
A.eb.prototype={
gaP(a){return B.l7},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint16Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$ijj:1}
A.ec.prototype={
gaP(a){return B.l8},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint32Array(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$ibB:1}
A.ed.prototype={
gaP(a){return B.l9},
gv(a){return a.length},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint8ClampedArray(a.subarray(b,A.b4(b,c,a.length)))},
$iM:1,
$ijk:1}
A.cd.prototype={
gaP(a){return B.la},
gv(a){return a.length},
l(a,b){A.bH(b,a,a.length)
return a[b]},
bh(a,b,c){return new Uint8Array(a.subarray(b,A.b4(b,c,a.length)))},
hu(a,b){return this.bh(a,b,null)},
$iM:1,
$icd:1,
$ibC:1}
A.eW.prototype={}
A.eX.prototype={}
A.eY.prototype={}
A.eZ.prototype={}
A.b3.prototype={
q(a){return A.k4(v.typeUniverse,this,a)},
am(a){return A.q7(v.typeUniverse,this,a)}}
A.hP.prototype={}
A.hT.prototype={
C(a){return A.aw(this.a,null)}}
A.hN.prototype={
C(a){return this.a}}
A.ds.prototype={$ibg:1}
A.jG.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:8}
A.jF.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:15}
A.jH.prototype={
$0(){this.a.$0()},
$S:9}
A.jI.prototype={
$0(){this.a.$0()},
$S:9}
A.k_.prototype={
hT(a,b){if(self.setTimeout!=null)self.setTimeout(A.f9(new A.k0(this,b),0),a)
else throw A.h(A.bh("`setTimeout()` not found."))}}
A.k0.prototype={
$0(){this.b.$0()},
$S:2}
A.hK.prototype={
e_(a){var s,r=this,q=r.$ti
q.q("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.er(a)
else{s=r.a
if(q.q("c5<1>").b(a))s.ex(a)
else s.eA(a)}},
e0(a,b){var s=this.a
if(this.b)s.dz(new A.aM(a,b))
else s.du(new A.aM(a,b))}}
A.ka.prototype={
$1(a){return this.a.$2(0,a)},
$S:5}
A.kb.prototype={
$2(a,b){this.a.$2(1,new A.dC(a,t.l.a(b)))},
$S:17}
A.ke.prototype={
$2(a,b){this.a(A.o(a),b)},
$S:22}
A.aM.prototype={
C(a){return A.z(this.a)},
$iT:1,
gcv(){return this.b}}
A.hM.prototype={
e0(a,b){var s=this.a
if((s.a&30)!==0)throw A.h(A.ld("Future already completed"))
s.du(A.qA(a,b))},
fQ(a){return this.e0(a,null)}}
A.eQ.prototype={
e_(a){var s,r=this.$ti
r.q("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.h(A.ld("Future already completed"))
s.er(r.q("1/").a(a))}}
A.cv.prototype={
kM(a){if((this.c&15)!==6)return!0
return this.b.b.e5(t.al.a(this.d),a.a,t.y,t.K)},
kE(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.l0(q,m,a.b,o,n,t.l)
else p=l.e5(t.x.a(q),m,o,n)
try{o=r.$ti.q("2/").a(p)
return o}catch(s){if(t.eK.b(A.c0(s))){if((r.c&1)!==0)throw A.h(A.c2("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.h(A.c2("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.ab.prototype={
h9(a,b,c){var s,r,q=this.$ti
q.am(c).q("1/(2)").a(a)
s=$.a0
if(s===B.B){if(!t.Q.b(b)&&!t.x.b(b))throw A.h(A.kG(b,"onError",u.c))}else{c.q("@<0/>").am(q.c).q("1(2)").a(a)
b=A.qS(b,s)}r=new A.ab(s,c.q("ab<0>"))
this.dt(new A.cv(r,3,a,b,q.q("@<1>").am(c).q("cv<1,2>")))
return r},
fk(a,b,c){var s,r=this.$ti
r.am(c).q("1/(2)").a(a)
s=new A.ab($.a0,c.q("ab<0>"))
this.dt(new A.cv(s,19,a,b,r.q("@<1>").am(c).q("cv<1,2>")))
return s},
k7(a){this.a=this.a&1|16
this.c=a},
d0(a){this.a=a.a&30|this.a&1
this.c=a.c},
dt(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.dt(a)
return}r.d0(s)}A.hY(null,null,r.b,t.M.a(new A.jM(r,a)))}},
f8(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.f8(a)
return}m.d0(n)}l.a=m.de(a)
A.hY(null,null,m.b,t.M.a(new A.jQ(l,m)))}},
dd(){var s=t.F.a(this.c)
this.c=null
return this.de(s)},
de(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
eA(a){var s,r=this
r.$ti.c.a(a)
s=r.dd()
r.a=8
r.c=a
A.dp(r,s)},
i6(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.dd()
q.d0(a)
A.dp(q,r)},
dz(a){var s=this.dd()
this.k7(a)
A.dp(this,s)},
er(a){var s=this.$ti
s.q("1/").a(a)
if(s.q("c5<1>").b(a)){this.ex(a)
return}this.hX(a)},
hX(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.hY(null,null,s.b,t.M.a(new A.jO(s,a)))},
ex(a){A.lj(this.$ti.q("c5<1>").a(a),this,!1)
return},
du(a){this.a^=2
A.hY(null,null,this.b,t.M.a(new A.jN(this,a)))},
$ic5:1}
A.jM.prototype={
$0(){A.dp(this.a,this.b)},
$S:2}
A.jQ.prototype={
$0(){A.dp(this.b,this.a.a)},
$S:2}
A.jP.prototype={
$0(){A.lj(this.a.a,this.b,!0)},
$S:2}
A.jO.prototype={
$0(){this.a.eA(this.b)},
$S:2}
A.jN.prototype={
$0(){this.a.dz(this.b)},
$S:2}
A.jT.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.l_(t.fO.a(q.d),t.z)}catch(p){s=A.c0(p)
r=A.bk(p)
if(k.c&&t.n.a(k.b.a.c).a===s){q=k.a
q.c=t.n.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.kH(q)
n=k.a
n.c=new A.aM(q,o)
q=n}q.b=!0
return}if(j instanceof A.ab&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.n.a(j.c)
q.b=!0}return}if(j instanceof A.ab){m=k.b.a
l=new A.ab(m.b,m.$ti)
j.h9(new A.jU(l,m),new A.jV(l),t.w)
q=k.a
q.c=l
q.b=!1}},
$S:2}
A.jU.prototype={
$1(a){this.a.i6(this.b)},
$S:8}
A.jV.prototype={
$2(a,b){A.f5(a)
t.l.a(b)
this.a.dz(new A.aM(a,b))},
$S:24}
A.jS.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.e5(o.q("2/(1)").a(p.d),m,o.q("2/"),n)}catch(l){s=A.c0(l)
r=A.bk(l)
q=s
p=r
if(p==null)p=A.kH(q)
o=this.a
o.c=new A.aM(q,p)
o.b=!0}},
$S:2}
A.jR.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.n.a(l.a.a.c)
p=l.b
if(p.a.kM(s)&&p.a.e!=null){p.c=p.a.kE(s)
p.b=!1}}catch(o){r=A.c0(o)
q=A.bk(o)
p=t.n.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.kH(p)
m=l.b
m.c=new A.aM(p,n)
p=m}p.b=!0}},
$S:2}
A.hL.prototype={}
A.hR.prototype={}
A.f4.prototype={$imG:1}
A.kd.prototype={
$0(){A.o3(this.a,this.b)},
$S:2}
A.hQ.prototype={
l1(a){var s,r,q
t.M.a(a)
try{if(B.B===$.a0){a.$0()
return}A.n7(null,null,this,a,t.w)}catch(q){s=A.c0(q)
r=A.bk(q)
A.lt(A.f5(s),t.l.a(r))}},
ki(a){return new A.jY(this,t.M.a(a))},
l_(a,b){b.q("0()").a(a)
if($.a0===B.B)return a.$0()
return A.n7(null,null,this,a,b)},
e5(a,b,c,d){c.q("@<0>").am(d).q("1(2)").a(a)
d.a(b)
if($.a0===B.B)return a.$1(b)
return A.qV(null,null,this,a,b,c,d)},
l0(a,b,c,d,e,f){d.q("@<0>").am(e).am(f).q("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.a0===B.B)return a.$2(b,c)
return A.qU(null,null,this,a,b,c,d,e,f)},
h6(a,b,c,d){return b.q("@<0>").am(c).am(d).q("1(2,3)").a(a)}}
A.jY.prototype={
$0(){return this.a.l1(this.b)},
$S:2}
A.eR.prototype={
gv(a){return this.a},
gc3(){return new A.eS(this,this.$ti.q("eS<1>"))},
ag(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.i7(a)},
i7(a){var s=this.d
if(s==null)return!1
return this.dI(this.eP(s,a),a)>=0},
l(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.mJ(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.mJ(q,b)
return r}else return this.j0(b)},
j0(a){var s,r,q=this.d
if(q==null)return null
s=this.eP(q,a)
r=this.dI(s,a)
return r<0?null:s[r+1]},
h(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.ez(s==null?m.b=A.lk():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.ez(r==null?m.c=A.lk():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.lk()
p=A.i2(b)&1073741823
o=q[p]
if(o==null){A.ll(q,p,[b,c]);++m.a
m.e=null}else{n=m.dI(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
bI(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.q("~(1,2)").a(b)
s=m.eC()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.l(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.h(A.ba(m))}},
eC(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.S(i.a,null,!1,t.z)
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
ez(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.ll(a,b,c)},
eP(a,b){return a[A.i2(b)&1073741823]}}
A.dq.prototype={
dI(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.eS.prototype={
gv(a){return this.a.a},
gH(a){var s=this.a
return new A.eT(s,s.eC(),this.$ti.q("eT<1>"))}}
A.eT.prototype={
gO(){var s=this.d
return s==null?this.$ti.c.a(s):s},
D(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.h(A.ba(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$iA:1}
A.iQ.prototype={
$2(a,b){this.a.h(0,this.b.a(a),this.c.a(b))},
$S:27}
A.G.prototype={
gH(a){return new A.cb(a,this.gv(a),A.aK(a).q("cb<G.E>"))},
bE(a,b){return this.l(a,b)},
cd(a,b){var s,r=this.gv(a)
for(s=0;s<r;++s){if(this.l(a,s)===b)return!0
if(r!==this.gv(a))throw A.h(A.ba(a))}return!1},
he(a,b){return new A.cu(a,b.q("cu<0>"))},
cs(a,b,c){var s=A.aK(a)
return new A.b0(a,s.am(c).q("1(G.E)").a(b),s.q("@<G.E>").am(c).q("b0<1,2>"))},
dq(a,b){return A.dh(a,b,null,A.aK(a).q("G.E"))},
h8(a,b){return A.dh(a,0,A.f8(b,"count",t.p),A.aK(a).q("G.E"))},
bh(a,b,c){var s,r=this.gv(a)
A.bz(b,c,r)
A.bz(b,c,this.gv(a))
s=A.aK(a).q("G.E")
s=A.w(A.dh(a,b,c,s),s)
return s},
aO(a,b,c,d){var s
A.aK(a).q("G.E?").a(d)
A.bz(b,c,this.gv(a))
for(s=b;s<c;++s)this.h(a,s,d)},
ar(a,b,c,d,e){var s,r,q,p,o
A.aK(a).q("e<G.E>").a(d)
A.bz(b,c,this.gv(a))
s=c-b
if(s===0)return
A.df(e,"skipCount")
if(t.j.b(d)){r=e
q=d}else{q=J.kE(d,e).e6(0,!1)
r=0}p=J.a9(q)
if(r+s>p.gv(q))throw A.h(A.mg())
if(r<b)for(o=s-1;o>=0;--o)this.h(a,b+o,p.l(q,r+o))
else for(o=0;o<s;++o)this.h(a,b+o,p.l(q,r+o))},
bB(a,b,c,d){return this.ar(a,b,c,d,0)},
hn(a,b,c){A.aK(a).q("e<G.E>").a(c)
this.bB(a,b,b+c.length,c)},
C(a){return A.mh(a,"[","]")},
$iC:1,
$ie:1,
$iq:1}
A.ah.prototype={
bI(a,b){var s,r,q,p=A.l(this)
p.q("~(ah.K,ah.V)").a(b)
for(s=this.gc3(),s=s.gH(s),p=p.q("ah.V");s.D();){r=s.gO()
q=this.l(0,r)
b.$2(r,q==null?p.a(q):q)}},
gv(a){var s=this.gc3()
return s.gv(s)},
C(a){return A.kU(this)},
$iaP:1}
A.iU.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.z(a)
r.a=(r.a+=s)+": "
s=A.z(b)
r.a+=s},
$S:14}
A.k6.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:true})
return s}catch(r){}return null},
$S:10}
A.k5.prototype={
$0(){var s,r
try{s=new TextDecoder("utf-8",{fatal:false})
return s}catch(r){}return null},
$S:10}
A.k2.prototype={
cq(a){var s,r,q=a.length,p=A.bz(0,null,q),o=new Uint8Array(p)
for(s=0;s<p;++s){if(!(s<q))return A.a(a,s)
r=a.charCodeAt(s)
if((r&4294967040)!==0)throw A.h(A.kG(a,"string","Contains invalid characters."))
if(!(s<p))return A.a(o,s)
o[s]=r}return o}}
A.k1.prototype={
cq(a){var s,r,q,p
t.L.a(a)
s=a.length
r=A.bz(0,null,s)
for(q=0;q<r;++q){if(!(q<s))return A.a(a,q)
p=a[q]
if((p&4294967040)!==0){if(!this.a)throw A.h(A.kM("Invalid value in input: "+p,null,null))
return this.i9(a,0,r)}}return A.eA(a,0,r)},
i9(a,b,c){var s,r,q,p
t.L.a(a)
for(s=a.length,r=b,q="";r<c;++r){if(!(r<s))return A.a(a,r)
p=a[r]
q+=A.d9((p&4294967040)!==0?65533:p)}return q.charCodeAt(0)==0?q:q}}
A.cA.prototype={}
A.fo.prototype={}
A.fs.prototype={}
A.h6.prototype={
c1(a){var s
t.L.a(a)
s=B.df.cq(a)
return s}}
A.iM.prototype={}
A.iL.prototype={}
A.hF.prototype={
kn(a,b){t.L.a(a)
return(b===!0?B.lc:B.lb).cq(a)}}
A.hG.prototype={
cq(a){return new A.hV(this.a).eD(t.L.a(a),0,null,!0)}}
A.hV.prototype={
eD(a,b,c,d){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=A.bz(b,c,a.length)
if(b===s)return""
if(a instanceof Uint8Array){r=a
q=r
p=0}else{q=A.qb(a,b,s)
s-=b
p=b
b=0}if(s-b>=15){o=l.a
n=A.qa(o,q,b,s)
if(n!=null){if(!o)return n
if(n.indexOf("\ufffd")<0)return n}}n=l.dC(q,b,s,!0)
o=l.b
if((o&1)!==0){m=A.qc(o)
l.b=0
throw A.h(A.kM(m,a,p+l.c))}return n},
dC(a,b,c,d){var s,r,q=this
if(c-b>1000){s=B.a.X(b+c,2)
r=q.dC(a,b,s,!1)
if((q.b&1)!==0)return r
return r+q.dC(a,s,c,d)}return q.kr(a,b,c,d)},
kr(a,b,a0,a1){var s,r,q,p,o,n,m,l,k=this,j="AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFFFFFFFFFFFFFFFFGGGGGGGGGGGGGGGGHHHHHHHHHHHHHHHHHHHHHHHHHHHIHHHJEEBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBKCCCCCCCCCCCCDCLONNNMEEEEEEEEEEE",i=" \x000:XECCCCCN:lDb \x000:XECCCCCNvlDb \x000:XECCCCCN:lDb AAAAA\x00\x00\x00\x00\x00AAAAA00000AAAAA:::::AAAAAGG000AAAAA00KKKAAAAAG::::AAAAA:IIIIAAAAA000\x800AAAAA\x00\x00\x00\x00 AAAAA",h=65533,g=k.b,f=k.c,e=new A.ez(""),d=b+1,c=a.length
if(!(b>=0&&b<c))return A.a(a,b)
s=a[b]
$label0$0:for(r=k.a;;){for(;;d=o){if(!(s>=0&&s<256))return A.a(j,s)
q=j.charCodeAt(s)&31
f=g<=32?s&61694>>>q:(s&63|f<<6)>>>0
p=g+q
if(!(p>=0&&p<144))return A.a(i,p)
g=i.charCodeAt(p)
if(g===0){p=A.d9(f)
e.a+=p
if(d===a0)break $label0$0
break}else if((g&1)!==0){if(r)switch(g){case 69:case 67:p=A.d9(h)
e.a+=p
break
case 65:p=A.d9(h)
e.a+=p;--d
break
default:p=A.d9(h)
e.a=(e.a+=p)+p
break}else{k.b=g
k.c=d-1
return""}g=0}if(d===a0)break $label0$0
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
p=A.d9(a[l])
e.a+=p}else{p=A.eA(a,d,n)
e.a+=p}if(n===a0)break $label0$0
d=o}else d=o}if(a1&&g>32)if(r){c=A.d9(h)
e.a+=c}else{k.b=77
k.c=a0
return""}k.b=g
k.c=f
c=e.a
return c.charCodeAt(0)==0?c:c}}
A.fp.prototype={
W(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.fp)if(this.a===b.a)s=this.b===b.b
return s},
gJ(a){return A.kW(this.a,this.b,B.ac)},
C(a){var s=this,r=A.o0(A.oO(s)),q=A.fq(A.oM(s)),p=A.fq(A.oI(s)),o=A.fq(A.oJ(s)),n=A.fq(A.oL(s)),m=A.fq(A.oN(s)),l=A.lV(A.oK(s)),k=s.b,j=k===0?"":A.lV(k)
return r+"-"+q+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"}}
A.jK.prototype={
C(a){return this.a6()}}
A.T.prototype={
gcv(){return A.oH(this)}}
A.fc.prototype={
C(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.ih(s)
return"Assertion failed"}}
A.bg.prototype={}
A.aX.prototype={
gdF(){return"Invalid argument"+(!this.a?"(s)":"")},
gdE(){return""},
C(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.z(p),n=s.gdF()+q+o
if(!s.a)return n
return n+s.gdE()+": "+A.ih(s.ge2())},
ge2(){return this.b}}
A.de.prototype={
ge2(){return A.mZ(this.b)},
gdF(){return"RangeError"},
gdE(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.z(q):""
else if(q==null)s=": Not greater than or equal to "+A.z(r)
else if(q>r)s=": Not in inclusive range "+A.z(r)+".."+A.z(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.z(r)
return s}}
A.fI.prototype={
ge2(){return A.o(this.b)},
gdF(){return"RangeError"},
gdE(){if(A.o(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gv(a){return this.f}}
A.eE.prototype={
C(a){return"Unsupported operation: "+this.a}}
A.hD.prototype={
C(a){return"UnimplementedError: "+this.a}}
A.dg.prototype={
C(a){return"Bad state: "+this.a}}
A.fm.prototype={
C(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.ih(s)+"."}}
A.hc.prototype={
C(a){return"Out of Memory"},
gcv(){return null},
$iT:1}
A.ey.prototype={
C(a){return"Stack Overflow"},
gcv(){return null},
$iT:1}
A.jL.prototype={
C(a){return"Exception: "+this.a}}
A.io.prototype={
C(a){var s=this.a,r=""!==s?"FormatException: "+s:"FormatException",q=this.c
return q!=null?r+(" (at offset "+A.z(q)+")"):r}}
A.e.prototype={
cs(a,b,c){var s=A.l(this)
return A.os(this,s.am(c).q("1(e.E)").a(b),s.q("e.E"),c)},
gv(a){var s,r=this.gH(this)
for(s=0;r.D();)++s
return s},
bE(a,b){var s,r
A.df(b,"index")
s=this.gH(this)
for(r=b;s.D();){if(r===0)return s.gO();--r}throw A.h(A.kP(b,b-r,this,null,"index"))},
C(a){return A.on(this,"(",")")}}
A.aj.prototype={
gJ(a){return A.H.prototype.gJ.call(this,0)},
C(a){return"null"}}
A.H.prototype={$iH:1,
W(a,b){return this===b},
gJ(a){return A.es(this)},
C(a){return"Instance of '"+A.hl(this)+"'"},
gaP(a){return A.rv(this)},
toString(){return this.C(this)}}
A.hS.prototype={
C(a){return""},
$iaT:1}
A.ez.prototype={
gv(a){return this.a.length},
C(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.iW.prototype={
C(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.kp.prototype={
$1(a){var s,r,q,p
if(A.n6(a))return a
s=this.a
if(s.ag(a))return s.l(0,a)
if(t.eO.b(a)){r={}
s.h(0,a,r)
for(s=a.gc3(),s=s.gH(s);s.D();){q=s.gO()
r[q]=this.$1(a.l(0,q))}return r}else if(t.W.b(a)){p=[]
s.h(0,a,p)
B.c.fD(p,J.nP(a,this,t.z))
return p}else return a},
$S:11}
A.kr.prototype={
$1(a){return this.a.e_(this.b.q("0/?").a(a))},
$S:5}
A.ks.prototype={
$1(a){if(a==null)return this.a.fQ(new A.iW(a===undefined))
return this.a.fQ(a)},
$S:5}
A.kh.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h
if(A.n5(a))return a
s=this.a
a.toString
if(s.ag(a))return s.l(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.b8(A.an(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.f8(!0,"isUtc",t.y)
return new A.fp(r,0,!0)}if(a instanceof RegExp)throw A.h(A.c2("structured clone of RegExp",null))
if(a instanceof Promise)return A.rI(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.I(p,p)
s.h(0,a,o)
n=Object.keys(a)
m=[]
for(s=J.ak(n),p=s.gH(n);p.D();)m.push(A.ne(p.gO()))
for(l=0;l<s.gv(n);++l){k=s.l(n,l)
if(!(l<m.length))return A.a(m,l)
j=m[l]
if(k!=null)o.h(0,j,this.$1(a[k]))}return o}if(a instanceof Array){i=a
o=[]
s.h(0,a,o)
h=A.o(a.length)
for(s=J.ak(i),l=0;l<h;++l)o.push(this.$1(s.l(i,l)))
return o}return a},
$S:11}
A.dN.prototype={
ds(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=a.length
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
A.jD.prototype={}
A.k8.prototype={
kt(a,b,c,d){var s,r,q,p,o,n,m=null
for(;;){s=a.c
r=a.d
r===$&&A.b("_length")
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
return!1}if(m!=null)b.a7(m)
s=new A.dN()
s.ds(B.jX)
r=new A.dN()
r.ds(B.eO)
q=new A.ef(new Uint8Array(32768),B.ab)
new A.iz(a,q,s,r).j7()
m=J.E(B.d.gB(q.c),q.c.byteOffset,q.b)
a.k()}if(m!=null)b.a7(m)
return!0}}
A.jE.prototype={}
A.k9.prototype={
fW(a,b){var s
t.L.a(a)
s=A.mo(B.a0,32768)
this.ky(A.iA(a,B.ab,null,null),s,b,!1,null)
return s.e7()},
ky(a,b,c,d,e){var s,r,q,p,o,n,m,l,k
b.a=B.a0
s=(B.a.P(15,0,15)-8<<4|8)>>>0
b.p(s)
r=s*256
for(q=0;p=(q|0)>>>0,B.a.a8(r+p,31)!==0;)++q
b.p(p)
o=a.c
n=A.rr(a)
a.c=o
A.o1(a,6,b,15)
p=n&255
m=n>>>24&255
l=n>>>16&255
k=n>>>8&255
if(b.a===B.a0){b.p(m)
b.p(l)
b.p(k)
b.p(p)}else{b.p(p)
b.p(k)
b.p(l)
b.p(m)}}}
A.dn.prototype={
a6(){return"_DeflateFlushMode."+this.b}}
A.id.prototype={
j8(a,b){var s,r,q,p,o=this,n=!0
if(b>=9)if(b<=15)n=a>9
if(n)return!1
s=o.j2(a)
if(s==null)return!1
$.bb.b=s
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
o.bG=16384
o.xr=49152
o.k4=a
o.w=o.x=o.ok=0
o.c=113
o.d=0
p=o.p4
p.a=n
p.c=$.nD()
p=o.R8
p.a=r
p.c=$.nC()
p=o.RG
p.a=q
p.c=$.nB()
o.bc=o.aS=0
o.bR=8
o.eY()
o.ji()
return!0},
iE(a){var s,r,q,p,o=this,n=o.x
n===$&&A.b("_pending")
if(n!==0)o.dJ()
n=o.a
s=n.c
n=n.d
n===$&&A.b("_length")
r=!0
if(s>=n){n=o.k2
n===$&&A.b("_lookAhead")
if(n===0)n=a!==B.aA&&o.c!==666
else n=r}else n=r
if(n){switch($.bb.cD().e){case 0:q=o.iH(a)
break
case 1:q=o.iF(a)
break
case 2:q=o.iG(a)
break
default:q=-1
break}n=q===2
if(n||q===3)o.c=666
if(q===0||n)return 0
if(q===1){if(a===B.lg){o.aE(2,3)
o.cp(256,B.ak)
o.fN()
n=o.bR
n===$&&A.b("_lastEOBLen")
s=o.bc
s===$&&A.b("_numValidBits")
if(1+n+10-s<9){o.aE(2,3)
o.cp(256,B.ak)
o.fN()}o.bR=7}else{o.fl(0,0,!1)
if(a===B.lh){n=o.cy
n===$&&A.b("_hashSize")
s=o.CW
p=0
for(;p<n;++p){s===$&&A.b("_head")
s.$flags&2&&A.c(s)
if(!(p<s.length))return A.a(s,p)
s[p]=0}}}o.dJ()}}if(a!==B.a9)return 0
return 1},
ji(){var s,r,q,p=this,o=p.Q
o===$&&A.b("_windowSize")
p.ay=2*o
o=p.CW
o===$&&A.b("_head")
s=p.cy
s===$&&A.b("_hashSize");--s
o.$flags&2&&A.c(o)
r=o.length
if(!(s>=0&&s<r))return A.a(o,s)
o[s]=0
for(q=0;q<s;++q){if(!(q<r))return A.a(o,q)
o[q]=0}p.k2=p.fr=p.id=0
p.fx=p.k3=2
p.cx=p.go=0},
eY(){var s,r,q,p,o=this,n="_dynamicLengthTree"
for(s=o.p1,r=0;r<286;++r){s===$&&A.b(n)
q=r*2
s.$flags&2&&A.c(s)
if(!(q<1146))return A.a(s,q)
s[q]=0}for(q=o.p2,r=0;r<30;++r){q===$&&A.b("_dynamicDistTree")
p=r*2
q.$flags&2&&A.c(q)
if(!(p<122))return A.a(q,p)
q[p]=0}for(q=o.p3,r=0;r<19;++r){q===$&&A.b("_bitLengthTree")
p=r*2
q.$flags&2&&A.c(q)
if(!(p<78))return A.a(q,p)
q[p]=0}s===$&&A.b(n)
s.$flags&2&&A.c(s)
s[512]=1
o.y2=o.cf=o.aN=o.bH=0},
dT(a,b){var s,r,q,p,o,n,m=this.ry
if(!(b>=0&&b<573))return A.a(m,b)
s=m[b]
r=b<<1>>>0
q=m.$flags|0
p=this.x2
for(;;){o=this.to
o===$&&A.b("_heapLen")
if(!(r<=o))break
if(r<o){o=r+1
if(!(o>=0&&o<573))return A.a(m,o)
o=m[o]
if(!(r>=0&&r<573))return A.a(m,r)
o=A.lW(a,o,m[r],p)}else o=!1
if(o)++r
if(!(r>=0&&r<573))return A.a(m,r)
if(A.lW(a,s,m[r],p))break
o=m[r]
q&2&&A.c(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=o
n=r<<1>>>0
b=r
r=n}q&2&&A.c(m)
if(!(b>=0&&b<573))return A.a(m,b)
m[b]=s},
ff(a,b){var s,r,q,p,o,n,m,l,k,j,i,h="_bitLengthTree",g=a.length
if(1>=g)return A.a(a,1)
s=a[1]
if(s===0){r=138
q=3}else{r=7
q=4}p=(b+1)*2+1
a.$flags&2&&A.c(a)
if(!(p>=0&&p<g))return A.a(a,p)
a[p]=65535
for(p=this.p3,o=0,n=-1,m=0;o<=b;s=k){++o
l=o*2+1
if(!(l<g))return A.a(a,l)
k=a[l];++m
if(m<r&&s===k)continue
else{j=3
if(m<q){p===$&&A.b(h)
l=s*2
if(!(l>=0&&l<78))return A.a(p,l)
i=p[l]
p.$flags&2&&A.c(p)
p[l]=i+m}else if(s!==0){if(s!==n){p===$&&A.b(h)
l=s*2
if(!(l>=0&&l<78))return A.a(p,l)
i=p[l]
p.$flags&2&&A.c(p)
p[l]=i+1}p===$&&A.b(h)
l=p[32]
p.$flags&2&&A.c(p)
p[32]=l+1}else if(m<=10){p===$&&A.b(h)
l=p[34]
p.$flags&2&&A.c(p)
p[34]=l+1}else{p===$&&A.b(h)
l=p[36]
p.$flags&2&&A.c(p)
p[36]=l+1}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
i_(){var s,r,q=this,p=q.p1
p===$&&A.b("_dynamicLengthTree")
s=q.p4.b
s===$&&A.b("maxCode")
q.ff(p,s)
s=q.p2
s===$&&A.b("_dynamicDistTree")
p=q.R8.b
p===$&&A.b("maxCode")
q.ff(s,p)
q.RG.dv(q)
for(p=q.p3,r=18;r>=3;--r){p===$&&A.b("_bitLengthTree")
s=B.as[r]*2+1
if(!(s<78))return A.a(p,s)
if(p[s]!==0)break}p=q.aN
p===$&&A.b("_optimalLen")
q.aN=p+(3*(r+1)+5+5+4)
return r},
k6(a,b,c){var s,r,q,p,o=this
o.aE(a-257,5)
s=b-1
o.aE(s,5)
o.aE(c-4,4)
for(r=0;r<c;++r){q=o.p3
q===$&&A.b("_bitLengthTree")
if(!(r<19))return A.a(B.as,r)
p=B.as[r]*2+1
if(!(p<78))return A.a(q,p)
o.aE(q[p],3)}q=o.p1
q===$&&A.b("_dynamicLengthTree")
o.fg(q,a-1)
q=o.p2
q===$&&A.b("_dynamicDistTree")
o.fg(q,s)},
fg(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e="_bitLengthTree",d=a.length
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
h===$&&A.b(e)
p.a(h)
if(!(l>=0&&l<78))return A.a(h,l)
g=h[l]
if(!(i>=0&&i<78))return A.a(h,i)
f.aE(g&65535,h[i]&65535)}while(--m,m!==0)}else if(s!==0){if(s!==n){l=f.p3
l===$&&A.b(e)
p.a(l)
i=s*2
if(!(i>=0&&i<78))return A.a(l,i)
h=l[i];++i
if(!(i<78))return A.a(l,i)
f.aE(h&65535,l[i]&65535);--m}l=f.p3
l===$&&A.b(e)
p.a(l)
f.aE(l[32]&65535,l[33]&65535)
f.aE(m-3,2)}else{l=f.p3
if(m<=10){l===$&&A.b(e)
p.a(l)
f.aE(l[34]&65535,l[35]&65535)
f.aE(m-3,3)}else{l===$&&A.b(e)
p.a(l)
f.aE(l[36]&65535,l[37]&65535)
f.aE(m-11,7)}}}if(k===0){q=j
r=138}else if(s===k){q=j
r=6}else{r=7
q=4}n=s
m=0}},
jD(a,b,c){var s,r,q=this
if(c===0)return
s=q.f
s===$&&A.b("_pendingBuffer")
r=q.x
r===$&&A.b("_pending")
B.d.ar(s,r,r+c,a,b)
q.x=q.x+c},
bi(a){var s,r=this.f
r===$&&A.b("_pendingBuffer")
s=this.x
s===$&&A.b("_pending")
this.x=s+1
r.$flags&2&&A.c(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a},
cp(a,b){var s,r,q
t.L.a(b)
s=a*2
r=b.length
if(!(s>=0&&s<r))return A.a(b,s)
q=b[s];++s
if(!(s<r))return A.a(b,s)
this.aE(q&65535,b[s]&65535)},
aE(a,b){var s,r=this,q="_bitBuffer",p=r.bc
p===$&&A.b("_numValidBits")
s=r.aS
if(p>16-b){s===$&&A.b(q)
p=r.aS=(s|B.a.V(a,p)&65535)>>>0
r.bi(p)
r.bi(A.aC(p,8))
r.aS=A.aC(a,16-r.bc)
r.bc=r.bc+(b-16)}else{s===$&&A.b(q)
r.aS=(s|B.a.V(a,p)&65535)>>>0
r.bc=p+b}},
cF(a,b){var s,r,q,p,o,n=this,m="_dynamicLengthTree",l="_matches",k="_dynamicDistTree",j=n.f
j===$&&A.b("_pendingBuffer")
s=n.bG
s===$&&A.b("_dbuf")
r=n.y2
r===$&&A.b("_lastLit")
r=s+r*2
s=A.aC(a,8)
j.$flags&2&&A.c(j)
if(!(r<j.length))return A.a(j,r)
j[r]=s
s=n.f
r=n.bG
j=n.y2
r=r+j*2+1
s.$flags&2&&A.c(s)
q=s.length
if(!(r<q))return A.a(s,r)
s[r]=a
r=n.xr
r===$&&A.b("_lbuf")
r+=j
if(!(r<q))return A.a(s,r)
s[r]=b
n.y2=j+1
if(a===0){j=n.p1
j===$&&A.b(m)
s=b*2
if(!(s>=0&&s<1146))return A.a(j,s)
r=j[s]
j.$flags&2&&A.c(j)
j[s]=r+1}else{j=n.cf
j===$&&A.b(l)
n.cf=j+1
j=n.p1
j===$&&A.b(m)
if(!(b>=0&&b<256))return A.a(B.aR,b)
s=(B.aR[b]+256+1)*2
if(!(s<1146))return A.a(j,s)
r=j[s]
j.$flags&2&&A.c(j)
j[s]=r+1
r=n.p2
r===$&&A.b(k)
s=A.mK(a-1)*2
if(!(s<122))return A.a(r,s)
j=r[s]
r.$flags&2&&A.c(r)
r[s]=j+1}j=n.y2
if((j&8191)===0){s=n.k4
s===$&&A.b("_level")
s=s>2}else s=!1
if(s){p=j*8
j=n.id
j===$&&A.b("_strStart")
s=n.fr
s===$&&A.b("_blockStart")
for(r=n.p2,o=0;o<30;++o){r===$&&A.b(k)
q=o*2
if(!(q<122))return A.a(r,q)
p+=r[q]*(5+B.a2[o])}p=A.aC(p,3)
r=n.cf
r===$&&A.b(l)
q=n.y2
if(r<q/2&&p<(j-s)/2)return!0
j=q}s=n.y1
s===$&&A.b("_litBufferSize")
return j===s-1},
eB(a,b){var s,r,q,p,o,n,m,l,k=this,j=t.L
j.a(a)
j.a(b)
j=k.y2
j===$&&A.b("_lastLit")
if(j!==0){s=0
do{j=k.f
j===$&&A.b("_pendingBuffer")
r=k.bG
r===$&&A.b("_dbuf")
r+=s*2
q=j.length
if(!(r<q))return A.a(j,r)
p=j[r];++r
if(!(r<q))return A.a(j,r)
o=p<<8&65280|j[r]&255
r=k.xr
r===$&&A.b("_lbuf")
r+=s
if(!(r<q))return A.a(j,r)
n=j[r]&255;++s
if(o===0)k.cp(n,a)
else{m=B.aR[n]
k.cp(m+256+1,a)
if(!(m<29))return A.a(B.aM,m)
l=B.aM[m]
if(l!==0)k.aE(n-B.dE[m],l);--o
m=A.mK(o)
k.cp(m,b)
if(!(m<30))return A.a(B.a2,m)
l=B.a2[m]
if(l!==0)k.aE(o-B.eI[m],l)}}while(s<k.y2)}k.cp(256,a)
if(513>=a.length)return A.a(a,513)
k.bR=a[513]},
ho(){var s,r,q,p,o,n="_dynamicLengthTree"
for(s=this.p1,r=0,q=0;r<7;){s===$&&A.b(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}for(o=0;r<128;){s===$&&A.b(n)
p=r*2
if(!(p<1146))return A.a(s,p)
o+=s[p];++r}while(r<256){s===$&&A.b(n)
p=r*2
if(!(p<1146))return A.a(s,p)
q+=s[p];++r}this.y=q>A.aC(o,2)?0:1},
fN(){var s=this,r="_bitBuffer",q=s.bc
q===$&&A.b("_numValidBits")
if(q===16){q=s.aS
q===$&&A.b(r)
s.bi(q)
s.bi(A.aC(q,8))
s.bc=s.aS=0}else if(q>=8){q=s.aS
q===$&&A.b(r)
s.bi(q)
s.aS=A.aC(s.aS,8)
s.bc=s.bc-8}},
es(){var s=this,r="_bitBuffer",q=s.bc
q===$&&A.b("_numValidBits")
if(q>8){q=s.aS
q===$&&A.b(r)
s.bi(q)
s.bi(A.aC(q,8))}else if(q>0){q=s.aS
q===$&&A.b(r)
s.bi(q)}s.bc=s.aS=0},
bZ(a){var s,r,q,p,o,n=this,m=n.fr
m===$&&A.b("_blockStart")
if(m>=0)s=m
else s=-1
r=n.id
r===$&&A.b("_strStart")
m=r-m
r=n.k4
r===$&&A.b("_level")
if(r>0){if(n.y===2)n.ho()
n.p4.dv(n)
n.R8.dv(n)
q=n.i_()
r=n.aN
r===$&&A.b("_optimalLen")
p=A.aC(r+3+7,3)
r=n.bH
r===$&&A.b("_staticLen")
o=A.aC(r+3+7,3)
if(o<=p)p=o}else{o=m+5
p=o
q=0}if(m+4<=p&&s!==-1)n.fl(s,m,a)
else if(o===p){n.aE(2+(a?1:0),3)
n.eB(B.ak,B.bJ)}else{n.aE(4+(a?1:0),3)
m=n.p4.b
m===$&&A.b("maxCode")
s=n.R8.b
s===$&&A.b("maxCode")
n.k6(m+1,s+1,q+1)
s=n.p1
s===$&&A.b("_dynamicLengthTree")
m=n.p2
m===$&&A.b("_dynamicDistTree")
n.eB(s,m)}n.eY()
if(a)n.es()
n.fr=n.id
n.dJ()},
iH(a){var s,r,q,p,o,n=this,m=n.r
m===$&&A.b("_pendingBufferSize")
s=m-5
s=65535>s?s:65535
for(m=a===B.aA;;){r=n.k2
r===$&&A.b("_lookAhead")
if(r<=1){n.dH()
r=n.k2
q=r===0
if(q&&m)return 0
if(q)break}q=n.id
q===$&&A.b("_strStart")
r=n.id=q+r
n.k2=0
q=n.fr
q===$&&A.b("_blockStart")
p=q+s
if(r>=p){n.k2=r-p
n.id=p
n.bZ(!1)}r=n.id
q=n.fr
o=n.Q
o===$&&A.b("_windowSize")
if(r-q>=o-262)n.bZ(!1)}m=a===B.a9
n.bZ(m)
return m?3:1},
fl(a,b,c){var s,r=this
r.aE(c?1:0,3)
r.es()
r.bR=8
r.bi(b)
r.bi(A.aC(b,8))
s=(~b>>>0)+65536&65535
r.bi(s)
r.bi(A.aC(s,8))
s=r.ax
s===$&&A.b("_window")
r.jD(s,a,b)},
dH(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_windowSize",f=h.a
do{s=h.ay
s===$&&A.b("_actualWindowSize")
r=h.k2
r===$&&A.b("_lookAhead")
q=h.id
q===$&&A.b("_strStart")
p=s-r-q
if(p===0&&q===0&&r===0){s=h.Q
s===$&&A.b(g)
p=s}else{s=h.Q
s===$&&A.b(g)
if(q>=s+s-262){r=h.ax
r===$&&A.b("_window")
B.d.ar(r,0,s,r,s)
s=h.k1
o=h.Q
h.k1=s-o
h.id=h.id-o
s=h.fr
s===$&&A.b("_blockStart")
h.fr=s-o
s=h.cy
s===$&&A.b("_hashSize")
r=h.CW
r===$&&A.b("_head")
q=r.length
n=r.$flags|0
m=s
l=m
do{--m
if(!(m>=0&&m<q))return A.a(r,m)
k=r[m]&65535
s=k>=o?k-o:0
n&2&&A.c(r)
r[m]=s}while(--l,l!==0)
s=h.ch
s===$&&A.b("_prev")
r=s.length
q=s.$flags|0
m=o
l=m
do{--m
if(!(m>=0&&m<r))return A.a(s,m)
k=s[m]&65535
n=k>=o?k-o:0
q&2&&A.c(s)
s[m]=n}while(--l,l!==0)
p+=o}}s=f.c
r=f.d
r===$&&A.b("_length")
if(s>=r)return
s=h.ax
s===$&&A.b("_window")
l=h.jG(s,h.id+h.k2,p)
s=h.k2=h.k2+l
if(s>=3){r=h.ax
q=h.id
n=r.length
if(q>>>0!==q||q>=n)return A.a(r,q)
j=r[q]&255
h.cx=j
i=h.dy
i===$&&A.b("_hashShift")
i=B.a.V(j,i);++q
if(!(q<n))return A.a(r,q)
q=r[q]
r=h.dx
r===$&&A.b("_hashMask")
h.cx=((i^q&255)&r)>>>0}}while(s<262&&!(f.c>=f.d))},
iF(a){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_insertHash",f="_hashShift",e="_window",d="_strStart",c="_hashMask",b="_windowMask"
for(s=a===B.aA,r=$.bb.a,q=0;;){p=h.k2
p===$&&A.b("_lookAhead")
if(p<262){h.dH()
p=h.k2
if(p<262&&s)return 0
if(p===0)break}if(p>=3){p=h.cx
p===$&&A.b(g)
o=h.dy
o===$&&A.b(f)
o=B.a.V(p,o)
p=h.ax
p===$&&A.b(e)
n=h.id
n===$&&A.b(d)
m=n+2
if(!(m>=0&&m<p.length))return A.a(p,m)
m=p[m]
p=h.dx
p===$&&A.b(c)
p=((o^m&255)&p)>>>0
h.cx=p
m=h.CW
m===$&&A.b("_head")
if(!(p<m.length))return A.a(m,p)
o=m[p]
q=o&65535
l=h.ch
l===$&&A.b("_prev")
k=h.at
k===$&&A.b(b)
k=(n&k)>>>0
l.$flags&2&&A.c(l)
if(!(k>=0&&k<l.length))return A.a(l,k)
l[k]=o
m.$flags&2&&A.c(m)
m[p]=n}if(q!==0){p=h.id
p===$&&A.b(d)
o=h.Q
o===$&&A.b("_windowSize")
o=(p-q&65535)<=o-262
p=o}else p=!1
if(p){p=h.ok
p===$&&A.b("_strategy")
if(p!==2)h.fx=h.f3(q)}p=h.fx
p===$&&A.b("_matchLength")
o=h.id
if(p>=3){o===$&&A.b(d)
j=h.cF(o-h.k1,p-3)
p=h.k2
o=h.fx
p-=o
h.k2=p
n=$.bb.b
if(n===$.bb)A.b8(A.iK(r))
if(o<=n.b&&p>=3){p=h.fx=o-1
do{o=h.id=h.id+1
n=h.cx
n===$&&A.b(g)
m=h.dy
m===$&&A.b(f)
m=B.a.V(n,m)
n=h.ax
n===$&&A.b(e)
l=o+2
if(!(l>=0&&l<n.length))return A.a(n,l)
l=n[l]
n=h.dx
n===$&&A.b(c)
n=((m^l&255)&n)>>>0
h.cx=n
l=h.CW
l===$&&A.b("_head")
if(!(n<l.length))return A.a(l,n)
m=l[n]
q=m&65535
k=h.ch
k===$&&A.b("_prev")
i=h.at
i===$&&A.b(b)
i=(o&i)>>>0
k.$flags&2&&A.c(k)
if(!(i>=0&&i<k.length))return A.a(k,i)
k[i]=m
l.$flags&2&&A.c(l)
l[n]=o}while(p=h.fx=p-1,p!==0)
h.id=o+1}else{p=h.id=h.id+o
h.fx=0
o=h.ax
o===$&&A.b(e)
n=o.length
if(!(p>=0&&p<n))return A.a(o,p)
m=o[p]&255
h.cx=m
l=h.dy
l===$&&A.b(f)
l=B.a.V(m,l);++p
if(!(p<n))return A.a(o,p)
p=o[p]
o=h.dx
o===$&&A.b(c)
h.cx=((l^p&255)&o)>>>0}}else{p=h.ax
p===$&&A.b(e)
o===$&&A.b(d)
if(!(o>=0&&o<p.length))return A.a(p,o)
j=h.cF(0,p[o]&255)
h.k2=h.k2-1
h.id=h.id+1}if(j)h.bZ(!1)}s=a===B.a9
h.bZ(s)
return s?3:1},
iG(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_insertHash",e="_hashShift",d="_window",c="_strStart",b="_hashMask",a="_windowMask",a0="_matchAvailable"
for(s=a1===B.aA,r=$.bb.a,q=0;;){p=g.k2
p===$&&A.b("_lookAhead")
if(p<262){g.dH()
p=g.k2
if(p<262&&s)return 0
if(p===0)break}if(p>=3){p=g.cx
p===$&&A.b(f)
o=g.dy
o===$&&A.b(e)
o=B.a.V(p,o)
p=g.ax
p===$&&A.b(d)
n=g.id
n===$&&A.b(c)
m=n+2
if(!(m>=0&&m<p.length))return A.a(p,m)
m=p[m]
p=g.dx
p===$&&A.b(b)
p=((o^m&255)&p)>>>0
g.cx=p
m=g.CW
m===$&&A.b("_head")
if(!(p<m.length))return A.a(m,p)
o=m[p]
q=o&65535
l=g.ch
l===$&&A.b("_prev")
k=g.at
k===$&&A.b(a)
k=(n&k)>>>0
l.$flags&2&&A.c(l)
if(!(k>=0&&k<l.length))return A.a(l,k)
l[k]=o
m.$flags&2&&A.c(m)
m[p]=n}p=g.fx
p===$&&A.b("_matchLength")
g.k3=p
g.fy=g.k1
g.fx=2
o=!1
if(q!==0){n=$.bb.b
if(n===$.bb)A.b8(A.iK(r))
if(p<n.b){p=g.id
p===$&&A.b(c)
o=g.Q
o===$&&A.b("_windowSize")
o=(p-q&65535)<=o-262
p=o}else p=o}else p=o
o=2
if(p){p=g.ok
p===$&&A.b("_strategy")
if(p!==2){p=g.f3(q)
g.fx=p}else p=o
n=!1
if(p<=5)if(g.ok!==1){if(p===3){n=g.id
n===$&&A.b(c)
n=n-g.k1>4096}}else n=!0
if(n){g.fx=2
p=o}}else p=o
o=g.k3
if(o>=3&&p<=o){p=g.id
p===$&&A.b(c)
j=p+g.k2-3
i=g.cF(p-1-g.fy,o-3)
o=g.k2
p=g.k3
g.k2=o-(p-1)
p=g.k3=p-2
do{o=g.id=g.id+1
if(o<=j){n=g.cx
n===$&&A.b(f)
m=g.dy
m===$&&A.b(e)
m=B.a.V(n,m)
n=g.ax
n===$&&A.b(d)
l=o+2
if(!(l>=0&&l<n.length))return A.a(n,l)
l=n[l]
n=g.dx
n===$&&A.b(b)
n=((m^l&255)&n)>>>0
g.cx=n
l=g.CW
l===$&&A.b("_head")
if(!(n<l.length))return A.a(l,n)
m=l[n]
q=m&65535
k=g.ch
k===$&&A.b("_prev")
h=g.at
h===$&&A.b(a)
h=(o&h)>>>0
k.$flags&2&&A.c(k)
if(!(h>=0&&h<k.length))return A.a(k,h)
k[h]=m
l.$flags&2&&A.c(l)
l[n]=o}}while(p=g.k3=p-1,p!==0)
g.go=0
g.fx=2
g.id=o+1
if(i)g.bZ(!1)}else{p=g.go
p===$&&A.b(a0)
if(p!==0){p=g.ax
p===$&&A.b(d)
o=g.id
o===$&&A.b(c);--o
if(!(o>=0&&o<p.length))return A.a(p,o)
if(g.cF(0,p[o]&255))g.bZ(!1)
g.id=g.id+1
g.k2=g.k2-1}else{g.go=1
p=g.id
p===$&&A.b(c)
g.id=p+1
g.k2=g.k2-1}}}s=g.go
s===$&&A.b(a0)
if(s!==0){s=g.ax
s===$&&A.b(d)
r=g.id
r===$&&A.b(c);--r
if(!(r>=0&&r<s.length))return A.a(s,r)
g.cF(0,s[r]&255)
g.go=0}s=a1===B.a9
g.bZ(s)
return s?3:1},
f3(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=$.bb.cD().d,a=c.id
a===$&&A.b("_strStart")
s=c.k3
s===$&&A.b("_prevLength")
r=c.Q
r===$&&A.b("_windowSize")
r-=262
q=a>r?a-r:0
p=$.bb.cD().c
r=c.at
r===$&&A.b("_windowMask")
o=c.id+258
n=c.ax
n===$&&A.b("_window")
m=a+s
l=m-1
k=n.length
if(!(l>=0&&l<k))return A.a(n,l)
j=n[l]
if(!(m>=0&&m<k))return A.a(n,m)
i=n[m]
if(c.k3>=$.bb.cD().a)b=b>>>2
n=c.k2
n===$&&A.b("_lookAhead")
if(p>n)p=n
h=o-258
g=s
f=a
do{c$0:{a=c.ax
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
e=a0}if(s)break c$0
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
a===$&&A.b("_prev")
s=a0&r
if(!(s>=0&&s<a.length))return A.a(a,s)
a0=a[s]&65535
if(a0>q){--b
a=b!==0}else a=!1}while(a)
a=c.k2
if(g<=a)return g
return a},
jG(a,b,c){var s,r,q,p,o,n,m=this
if(c!==0){s=m.a
r=s.c
s=s.d
s===$&&A.b("_length")
s=r>=s}else s=!0
if(s)return 0
q=m.a.aj(c)
p=q.gv(0)
if(p===0)return 0
o=q.a2()
n=o.length
if(p>n)p=n
B.d.bB(a,b,b+p,o)
m.e+=p
m.d=A.bj(o,m.d)
return p},
dJ(){var s,r=this,q=r.x
q===$&&A.b("_pending")
s=r.f
s===$&&A.b("_pendingBuffer")
r.b.hg(s,q)
s=r.w
s===$&&A.b("_pendingOut")
r.w=s+q
q=r.x-q
r.x=q
if(q===0)r.w=0},
j2(a){switch(a){case 0:return new A.aV(0,0,0,0,0)
case 1:return new A.aV(4,4,8,4,1)
case 2:return new A.aV(4,5,16,8,1)
case 3:return new A.aV(4,6,32,32,1)
case 4:return new A.aV(4,4,16,16,2)
case 5:return new A.aV(8,16,32,32,2)
case 6:return new A.aV(8,16,128,128,2)
case 7:return new A.aV(8,32,128,256,2)
case 8:return new A.aV(32,128,258,1024,2)
case 9:return new A.aV(32,258,258,4096,2)}return null}}
A.aV.prototype={}
A.jW.prototype={
j_(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3="_optimalLen",a4=a2.a
a4===$&&A.b("dynamicTree")
s=a2.c
s===$&&A.b("staticDesc")
r=s.a
q=s.b
p=s.c
o=s.e
for(s=a5.rx,n=s.$flags|0,m=0;m<=15;++m){n&2&&A.c(s)
s[m]=0}l=a5.ry
k=a5.x1
k===$&&A.b("_heapMax")
if(!(k>=0&&k<573))return A.a(l,k)
j=l[k]*2+1
a4.$flags&2&&A.c(a4)
i=a4.length
if(!(j>=0&&j<i))return A.a(a4,j)
a4[j]=0
for(h=k+1,k=r!=null,j=q.length,g=0;h<573;++h){f=l[h]
e=f*2
d=e+1
if(!(d>=0&&d<i))return A.a(a4,d)
c=a4[d]*2+1
if(!(c>=0&&c<i))return A.a(a4,c)
m=a4[c]+1
if(m>o){++g
m=o}a4.$flags&2&&A.c(a4)
a4[d]=m
c=a2.b
c===$&&A.b("maxCode")
if(f>c)continue
if(!(m>=0&&m<16))return A.a(s,m)
c=s[m]
n&2&&A.c(s)
s[m]=c+1
if(f>=p){c=f-p
if(!(c>=0&&c<j))return A.a(q,c)
b=q[c]}else b=0
if(!(e>=0&&e<i))return A.a(a4,e)
a=a4[e]
e=a5.aN
e===$&&A.b(a3)
a5.aN=e+a*(m+b)
if(k){e=a5.bH
e===$&&A.b("_staticLen")
if(!(d<r.length))return A.a(r,d)
a5.bH=e+a*(r[d]+b)}}if(g===0)return
m=o-1
do{a0=m
for(;;){if(!(a0>=0&&a0<16))return A.a(s,a0)
k=s[a0]
if(!(k===0))break;--a0}n&2&&A.c(s)
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
n===$&&A.b("maxCode")
if(a1>n)continue
n=a1*2
k=n+1
if(!(k>=0&&k<i))return A.a(a4,k)
j=a4[k]
if(j!==m){e=a5.aN
e===$&&A.b(a3)
if(!(n>=0&&n<i))return A.a(a4,n)
a5.aN=e+(m-j)*a4[n]
a4.$flags&2&&A.c(a4)
a4[k]=m}--f}}},
dv(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.a
a0===$&&A.b("dynamicTree")
s=a.c
s===$&&A.b("staticDesc")
r=s.a
q=s.d
a1.to=0
a1.x1=573
for(s=a0.length,p=a1.ry,o=p.$flags|0,n=a1.x2,m=n.$flags|0,l=a0.$flags|0,k=0,j=-1;k<q;++k){i=k*2
if(!(i<s))return A.a(a0,i)
if(a0[i]!==0){i=++a1.to
o&2&&A.c(p)
if(!(i>=0&&i<573))return A.a(p,i)
p[i]=k
m&2&&A.c(n)
if(!(k<573))return A.a(n,k)
n[k]=0
j=k}else{++i
l&2&&A.c(a0)
if(!(i<s))return A.a(a0,i)
a0[i]=0}}for(i=r!=null;h=a1.to,h<2;){++h
a1.to=h
if(j<2){++j
g=j}else g=0
o&2&&A.c(p)
if(!(h>=0))return A.a(p,h)
p[h]=g
h=g*2
l&2&&A.c(a0)
if(!(h>=0&&h<s))return A.a(a0,h)
a0[h]=1
m&2&&A.c(n)
if(!(g>=0))return A.a(n,g)
n[g]=0
f=a1.aN
f===$&&A.b("_optimalLen")
a1.aN=f-1
if(i){f=a1.bH
f===$&&A.b("_staticLen");++h
if(!(h<r.length))return A.a(r,h)
a1.bH=f-r[h]}}a.b=j
for(k=B.a.X(h,2);k>=1;--k)a1.dT(a0,k)
g=q
do{k=p[1]
i=a1.to--
if(!(i>=0&&i<573))return A.a(p,i)
i=p[i]
o&2&&A.c(p)
p[1]=i
a1.dT(a0,1)
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
l&2&&A.c(a0)
if(!(i<s))return A.a(a0,i)
a0[i]=f+c
if(!(k>=0&&k<573))return A.a(n,k)
c=n[k]
if(!(e>=0&&e<573))return A.a(n,e)
f=n[e]
i=c>f?c:f
m&2&&A.c(n)
if(!(g<573))return A.a(n,g)
n[g]=i+1;++h;++d
if(!(d<s))return A.a(a0,d)
a0[d]=g
if(!(h<s))return A.a(a0,h)
a0[h]=g
b=g+1
p[1]=g
a1.dT(a0,1)
if(a1.to>=2){g=b
continue}else break}while(!0)
s=--a1.x1
o=p[1]
if(!(s>=0&&s<573))return A.a(p,s)
p[s]=o
a.j_(a1)
A.pR(a0,j,a1.rx)}}
A.jZ.prototype={}
A.iz.prototype={
gbD(){var s=this.a
if(s==null)return s
s.d===$&&A.b("_length")
return s},
j7(){var s,r,q=this
q.e=q.d=0
if(q.gbD()==null)return
for(;;){s=q.gbD()
r=s.c
s=s.d
s===$&&A.b("_length")
if(!(r<s))break
if(!q.jm())return}},
jm(){var s,r,q,p=this,o=p.gbD()
if(o!=null){s=o.c
r=o.d
r===$&&A.b("_length")
r=s>=r
s=r}else s=!0
if(s)return!1
q=p.bj(3)
switch(B.a.j(q,1)){case 0:if(p.jw()===-1)return!1
break
case 1:if(p.eI(p.r,p.w)===-1)return!1
break
case 2:if(p.jn()===-1)return!1
break
default:return!1}return(q&1)===0},
bj(a){var s,r,q,p,o=this
if(a===0)return 0
while(s=o.e,s<a){s=o.gbD()
r=s.c
s=s.d
s===$&&A.b("_length")
if(r>=s)return-1
s=o.gbD()
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
o.d=B.a.a4(r,a)
o.e=s-a
return(r&p-1)>>>0},
dV(a){var s,r,q,p,o,n,m,l=this,k=a.a
k===$&&A.b("table")
s=a.b
while(r=l.e,r<s){r=l.gbD()
q=r.c
r=r.d
r===$&&A.b("_length")
if(q>=r)return-1
r=l.gbD()
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
l.d=B.a.a4(q,m)
l.e=r-m
return n&65535},
jw(){var s,r,q=this
q.e=q.d=0
s=q.bj(16)
r=q.bj(16)
if(s!==0&&s!==(r^65535)>>>0)return-1
if(s>q.gbD().gv(0))return-1
q.c.lb(q.gbD().aj(s))
return 0},
jn(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.bj(5)
if(h===-1)return-1
h+=257
if(h>288)return-1
s=i.bj(5)
if(s===-1)return-1;++s
if(s>32)return-1
r=i.bj(4)
if(r===-1)return-1
r+=4
if(r>19)return-1
q=new Uint8Array(19)
for(p=0;p<r;++p){o=i.bj(3)
if(o===-1)return-1
n=B.as[p]
if(!(n<19))return A.a(q,n)
q[n]=o}m=A.kO(q)
n=h+s
l=new Uint8Array(n)
k=J.E(B.d.gB(l),0,h)
j=J.E(B.d.gB(l),h,s)
if(i.ib(n,m,l)===-1)return-1
return i.eI(A.kO(k),A.kO(j))},
eI(a,b){var s,r,q,p,o,n,m,l,k=this
for(s=k.c;;){r=k.dV(a)
if(r<0||r>285)return-1
if(r===256)break
if(r<256){s.p(r&255)
continue}q=r-257
if(!(q>=0&&q<29))return A.a(B.c1,q)
p=B.c1[q]+k.bj(B.k3[q])
o=k.dV(b)
if(o<0||o>29)return-1
if(!(o>=0&&o<30))return A.a(B.c2,o)
n=B.c2[o]+k.bj(B.a2[o])
for(m=-n;p>n;){s.a7(s.al(m))
p-=n}if(p===n)s.a7(s.al(m))
else s.a7(s.eh(m,p-n))}while(s=k.e,s>=8){k.e=s-8
s=k.gbD()
m=--s.c
l=s.d
l===$&&A.b("_length")
s.c=B.a.P(m,0,l)}return 0},
ib(a,b,c){var s,r,q,p,o,n,m,l,k=this
for(s=0,r=0;r<a;){q=k.dV(b)
if(q===-1)return-1
p=0
switch(q){case 16:o=k.bj(2)
if(o===-1)return-1
o+=3
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.c(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=s}break
case 17:o=k.bj(3)
if(o===-1)return-1
o+=3
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.c(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
case 18:o=k.bj(7)
if(o===-1)return-1
o+=11
for(n=c.$flags|0;m=o-1,o>0;o=m,r=l){l=r+1
n&2&&A.c(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=0}s=p
break
default:if(q<0||q>15)return-1
l=r+1
c.$flags&2&&A.c(c)
if(!(r>=0&&r<c.length))return A.a(c,r)
c[r]=q
r=l
s=q
break}}return 0}}
A.jC.prototype={
c2(a){var s
t.L.a(a)
s=A.mo(B.ab,32768)
B.cU.kt(A.iA(a,B.a0,null,null),s,!1,!1)
return s.e7()}}
A.fh.prototype={
a6(){return"ByteOrder."+this.b}}
A.fJ.prototype={
gv(a){var s=this.b
return s==null?0:s.length-this.c},
hv(a,b){var s=this.b
if(s==null)return A.iA(A.j([],t.t),B.ab,null,null)
return A.iA(s,this.a,a,b)},
F(){var s,r=this.b
r.toString
s=this.c++
if(!(s>=0&&s<r.length))return A.a(r,s)
return r[s]},
a2(){var s,r,q,p=this,o=p.b
if(o==null)return new Uint8Array(0)
s=p.gv(0)
r=p.c
q=o.length
if(r+s>q)s=q-r
return J.E(B.d.gB(o),p.b.byteOffset+p.c,s)}}
A.fK.prototype={
k(){var s=this,r=s.F(),q=s.F(),p=s.F(),o=s.F()
if(s.a===B.a0)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
aj(a){var s=this,r=s.hv(a,s.c)
s.c=s.c+r.gv(0)
return r}}
A.ef.prototype={
e7(){return J.E(B.d.gB(this.c),this.c.byteOffset,this.b)},
p(a){var s,r,q=this
if(q.b===q.c.length)q.jk()
s=q.c
r=q.b++
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a},
hg(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=a.length
while(s=o.b,r=s+b,q=o.c,p=q.length,r>p)o.dP(r-p)
B.d.bB(q,s,r,a)
o.b+=b},
a7(a){return this.hg(a,null)},
lb(a){var s,r,q,p,o,n,m=this
for(;;){s=m.b
r=a.b
q=r==null
p=q?0:r.length-a.c
o=m.c
n=o.length
if(!(s+p>n))break
m.dP(s+(q?0:r.length-a.c)-n)}if(!q)B.d.ar(o,s,s+a.gv(0),r,a.c)
m.b=m.b+a.gv(0)},
eh(a,b){var s=this
if(a<0)a=s.b+a
if(b==null)b=s.b
else if(b<0)b=s.b+b
return J.E(B.d.gB(s.c),s.c.byteOffset+a,b-a)},
al(a){return this.eh(a,null)},
dP(a){var s=a!=null?a>32768?a:32768:32768,r=this.c,q=r.length,p=new Uint8Array((q+s)*2)
B.d.bB(p,0,q,r)
this.c=p},
jk(){return this.dP(null)},
gv(a){return this.b}}
A.he.prototype={}
A.i5.prototype={}
A.i6.prototype={
C(a){return"Exception: "+this.a}}
A.bo.prototype={
C(a){return"ColorTriplet("+A.z(this.a)+", "+A.z(this.b)+", "+A.z(this.c)+")"}}
A.ib.prototype={
a6(){return"Channel."+this.b}}
A.P.prototype={
D(){var s=this.b
return++this.a<s.gv(s)},
gO(){return this.b.l(0,this.a)},
$iA:1}
A.cB.prototype={
U(){return new A.cB(new Uint16Array(A.r(this.a)))},
gL(){return B.E},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=A.J(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){return this.gm()},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]}else s=0
return s},
sm(a){var s,r=this.a,q=r.length
if(q!==0){s=A.J(a)
r.$flags&2&&A.c(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s,r=this.a
if(r.length>1){r=r[1]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
st(a){var s,r=this.a
if(r.length>1){s=A.J(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s,r=this.a
if(r.length>2){r=r[2]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
su(a){var s,r=this.a
if(r.length>2){s=A.J(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s,r=this.a
if(r.length>3){r=r[3]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
ga_(){return this.gA()/1},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=A.J(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cC.prototype={
U(){return new A.cC(new Float32Array(A.r(this.a)))},
gL(){return B.M},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.c(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s=this.a,r=s.length
if(r!==0){s.$flags&2&&A.c(s)
if(0>=r)return A.a(s,0)
s[0]=a}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s=this.a
if(s.length>1){s.$flags&2&&A.c(s)
s[1]=a}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s=this.a
if(s.length>2){s.$flags&2&&A.c(s)
s[2]=a}},
gA(){var s=this.a
return s.length>3?s[3]:1},
ga_(){return this.gA()/1},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cD.prototype={
U(){return new A.cD(new Float64Array(A.r(this.a)))},
gL(){return B.Q},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s=this.a,r=s.length
if(b<r){s.$flags&2&&A.c(s)
if(!(b>=0))return A.a(s,b)
s[b]=c}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s=this.a,r=s.length
if(r!==0){s.$flags&2&&A.c(s)
if(0>=r)return A.a(s,0)
s[0]=a}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s=this.a
if(s.length>1){s.$flags&2&&A.c(s)
s[1]=a}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s=this.a
if(s.length>2){s.$flags&2&&A.c(s)
s[2]=a}},
gA(){var s=this.a
return s.length>3?s[3]:1},
ga_(){return this.gA()/1},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cE.prototype={
U(){return new A.cE(new Int16Array(A.r(this.a)))},
gL(){return B.S},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.c(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/32767},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cF.prototype={
U(){return new A.cF(new Int32Array(A.r(this.a)))},
gL(){return B.T},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s=this.a,r=s.length
if(r!==0){A.o(a)
s.$flags&2&&A.c(s)
if(0>=r)return A.a(s,0)
s[0]=a}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/2147483647},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cG.prototype={
U(){return new A.cG(new Int8Array(A.r(this.a)))},
gL(){return B.R},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.c(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/127},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cI.prototype={
U(){var s=this.b
s===$&&A.b("data")
return new A.cI(this.a,s)},
gL(){return B.y},
gM(){return null},
c7(a){var s
if(a<this.a){s=this.b
s===$&&A.b("data")
s=B.a.a5(s,7-a)&1}else s=0
return s},
bX(a,b){var s
if(a>=this.a)return
a=7-a
s=this.b
s===$&&A.b("data")
this.b=b!==0?(s|B.a.V(1,a))>>>0:(s&~(B.a.V(1,a)&255))>>>0},
l(a,b){return this.c7(b)},
h(a,b,c){return this.bX(b,c)},
gT(){return this.c7(0)},
gm(){return this.c7(0)},
sm(a){this.bX(0,a)},
gt(){return this.c7(1)},
st(a){this.bX(1,a)},
gu(){return this.c7(2)},
su(a){this.bX(2,a)},
gA(){return this.c7(3)},
ga_(){return this.c7(3)/1},
gan(){return A.Y(this)},
af(a){this.ac(a.gm(),a.gt(),a.gu(),a.gA())},
ac(a,b,c,d){var s=this
s.bX(0,a)
s.bX(1,b)
s.bX(2,c)
s.bX(3,d)},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1,
gv(a){return this.a}}
A.cJ.prototype={
U(){return new A.cJ(new Uint16Array(A.r(this.a)))},
gL(){return B.m},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.c(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/65535},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cK.prototype={
U(){var s=this.b
s===$&&A.b("data")
return new A.cK(this.a,s)},
gL(){return B.t},
gM(){return null},
c8(a){var s
if(a<this.a){s=this.b
s===$&&A.b("data")
s=B.a.a5(s,6-(a<<1>>>0))&3}else s=0
return s},
bY(a,b){var s,r,q
if(a>=this.a)return
if(!(a>=0&&a<4))return A.a(B.bv,a)
s=B.bv[a]
r=B.b.i(b)
q=this.b
q===$&&A.b("data")
this.b=(q&s|B.a.V(r&3,6-(a<<1>>>0)))>>>0},
l(a,b){return this.c8(b)},
h(a,b,c){return this.bY(b,c)},
gT(){return this.c8(0)},
gm(){return this.c8(0)},
sm(a){this.bY(0,a)},
gt(){return this.c8(1)},
st(a){this.bY(1,a)},
gu(){return this.c8(2)},
su(a){this.bY(2,a)},
gA(){return this.c8(3)},
ga_(){return this.c8(3)/3},
gan(){return A.Y(this)},
af(a){this.ac(a.gm(),a.gt(),a.gu(),a.gA())},
ac(a,b,c,d){var s=this
s.bY(0,a)
s.bY(1,b)
s.bY(2,c)
s.bY(3,d)},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1,
gv(a){return this.a}}
A.cL.prototype={
U(){return new A.cL(new Uint32Array(A.r(this.a)))},
gL(){return B.N},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.c(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s=this.a
return s.length>3?s[3]:0},
ga_(){return this.gA()/4294967295},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.cM.prototype={
U(){return new A.cM(this.a,new Uint8Array(A.r(this.b)))},
gL(){return B.z},
gM(){return null},
c9(a){var s,r
if(a<0||a>=this.a)s=0
else{s=this.b
r=s.length
if(a<2){if(0>=r)return A.a(s,0)
s=B.a.a5(s[0],4-(a<<2>>>0))&15}else{if(1>=r)return A.a(s,1)
s=B.a.a5(s[1],4-((a&1)<<2))&15}}return s},
c0(a,b){var s,r,q,p
if(a>=this.a)return
s=B.a.P(B.b.i(b),0,15)
if(a>1){a&=1
r=1}else r=0
if(a===0){q=this.b
if(!(r<q.length))return A.a(q,r)
p=q[r]
q.$flags&2&&A.c(q)
q[r]=(p&15|s<<4)>>>0}else if(a===1){q=this.b
if(!(r<q.length))return A.a(q,r)
p=q[r]
q.$flags&2&&A.c(q)
q[r]=(p&240|s)>>>0}},
l(a,b){return this.c9(b)},
h(a,b,c){return this.c0(b,c)},
gT(){return this.c9(0)},
gm(){return this.c9(0)},
sm(a){this.c0(0,a)},
gt(){return this.c9(1)},
st(a){this.c0(1,a)},
gu(){return this.c9(2)},
su(a){this.c0(2,a)},
gA(){return this.c9(3)},
ga_(){return this.c9(3)/15},
gan(){return A.Y(this)},
af(a){this.ac(a.gm(),a.gt(),a.gu(),a.gA())},
ac(a,b,c,d){var s=this
s.c0(0,a)
s.c0(1,b)
s.c0(2,c)
s.c0(3,d)},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1,
gv(a){return this.a}}
A.bK.prototype={
hz(a,b,c,d){var s,r=this.a
r.$flags&2&&A.c(r)
s=r.length
if(0>=s)return A.a(r,0)
r[0]=a
if(1>=s)return A.a(r,1)
r[1]=b
if(2>=s)return A.a(r,2)
r[2]=c
if(3>=s)return A.a(r,3)
r[3]=d},
U(){return new A.bK(new Uint8Array(A.r(this.a)))},
gL(){return B.e},
gv(a){return this.a.length},
gM(){return null},
l(a,b){var s=this.a,r=s.length
if(b<r){if(!(b>=0))return A.a(s,b)
s=s[b]}else s=0
return s},
h(a,b,c){var s,r=this.a,q=r.length
if(b<q){s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(b>=0))return A.a(r,b)
r[b]=s}},
gT(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
gm(){var s=this.a,r=s.length
if(r!==0){if(0>=r)return A.a(s,0)
s=s[0]}else s=0
return s},
sm(a){var s,r=this.a,q=r.length
if(q!==0){s=B.b.i(a)
r.$flags&2&&A.c(r)
if(0>=q)return A.a(r,0)
r[0]=s}},
gt(){var s=this.a
return s.length>1?s[1]:0},
st(a){var s,r=this.a
if(r.length>1){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[1]=s}},
gu(){var s=this.a
return s.length>2?s[2]:0},
su(a){var s,r=this.a
if(r.length>2){s=B.b.i(a)
r.$flags&2&&A.c(r)
r[2]=s}},
gA(){var s=this.a
return s.length>3?s[3]:255},
ga_(){return this.gA()/255},
gan(){return A.Y(this)},
af(a){var s,r,q=this
q.sm(a.gm())
q.st(a.gt())
q.su(a.gu())
s=a.gA()
r=q.a
if(r.length>3){s=B.b.i(s)
r.$flags&2&&A.c(r)
r[3]=s}},
gH(a){return new A.P(this)},
W(a,b){var s,r
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===this.a.length){s=b.gJ(b)
r=A.w(this,A.l(this).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.fk.prototype={}
A.cH.prototype={}
A.dz.prototype={
U(){return new A.dz(this.a)},
gL(){return B.e},
gv(a){return 4},
gM(){return null},
l(a,b){var s
if(b>=0&&b<4){s=b<<3>>>0
s=B.a.a4((this.a&B.a.R(255,s))>>>0,s)}else s=0
return s},
h(a,b,c){},
af(a){},
gT(){return this.l(0,0)},
gm(){return this.l(0,0)},
sm(a){},
gt(){return this.l(0,1)},
st(a){},
gu(){return this.l(0,2)},
su(a){},
gA(){return this.l(0,3)},
ga_(){return this.gA()/255},
gan(){return A.Y(this)},
gH(a){return new A.P(this)},
W(a,b){var s,r,q=this
if(b==null)return!1
s=!1
if(t.G.b(b))if(b.gv(b)===q.gv(q)){s=b.gJ(b)
r=A.w(q,A.l(q).q("e.E"))
s=s===A.n(r)}return s},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
$ix:1}
A.fn.prototype={
gA(){return 255},
ga_(){return 1},
gv(a){return 3}}
A.as.prototype={
a6(){return"Format."+this.b}}
A.dH.prototype={
a6(){return"FormatType."+this.b}}
A.fe.prototype={
a6(){return"BlendMode."+this.b}}
A.bL.prototype={
cW(a){var s=$.kB()
if(!s.ag(a))return"<unknown>"
return s.l(0,a).a},
C(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
for(s=e.a,r=new A.O(s,s.r,s.e,A.l(s).q("O<1>")),q=t.p,p=t.r,o=t.N,n=t.P,m="";r.D();){l=r.d
m+=l+"\n"
k=s.l(0,l)
for(l=k.a,l=new A.O(l,l.r,l.e,A.l(l).q("O<1>"));l.D();){j=l.d
i=k.l(0,j)
m=i==null?m+("\t"+e.cW(j)+"\n"):m+("\t"+e.cW(j)+": "+i.C(0)+"\n")}for(l=k.b.a,j=new A.O(l,l.r,l.e,A.l(l).q("O<1>"));j.D();){h=j.d
m+=h+"\n"
if(!l.ag(h))l.h(0,h,new A.aE(A.I(q,p),new A.aN(A.I(o,n))))
g=l.l(0,h)
for(h=g.a,h=new A.O(h,h.r,h.e,A.l(h).q("O<1>"));h.D();){f=h.d
i=g.l(0,f)
m=i==null?m+("\t"+e.cW(f)+"\n"):m+("\t"+e.cW(f)+": "+i.C(0)+"\n")}}}return m.charCodeAt(0)==0?m:m},
aT(a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2="exif",a3="interop",a4=a5.b
a5.b=!0
a5.a0(19789)
a5.a0(42)
a5.I(8)
s=a1.a
if(s.l(0,"ifd0")==null)s.h(0,"ifd0",new A.aE(A.I(t.p,t.r),new A.aN(A.I(t.N,t.P))))
r=A.j(["ifd0"],t.s)
for(q=new A.O(s,s.r,s.e,A.l(s).q("O<1>"));q.D();){p=q.d
if(p!=="ifd0")B.c.G(r,p)}q=t.N
p=t.p
o=A.I(q,p)
for(n=r.length,m=t.r,l=t.P,k=8,j=0;i=r.length,j<i;r.length===n||(0,A.a1)(r),++j){h=r[j]
i=s.l(0,h)
i.toString
o.h(0,h,k)
g=i.b.a
if(g.ag(a2)){f=new Uint32Array(1)
f[0]=0
i.h(0,34665,new A.aO(f))}else i.a.dm(0,34665)
if(g.ag(a3)){f=new Uint32Array(1)
f[0]=0
i.h(0,40965,new A.aO(f))}else i.a.dm(0,40965)
if(g.ag("gps")){f=new Uint32Array(1)
f[0]=0
i.h(0,34853,new A.aO(f))}else i.a.dm(0,34853)
i=i.a
k+=2+12*i.a+4
for(i=new A.at(i,i.r,i.e,A.l(i).q("at<2>"));i.D();){f=i.d
e=f.gaD().a
if(!(e<14))return A.a(B.u,e)
d=B.u[e]*f.gv(f)
if(d>4)k+=d}for(i=new A.O(g,g.r,g.e,A.l(g).q("O<1>"));i.D();){f=i.d
if(!g.ag(f))g.h(0,f,new A.aE(A.I(p,m),new A.aN(A.I(q,l))))
e=g.l(0,f)
e.toString
o.h(0,f,k)
e=e.a
c=2+12*e.a
for(f=new A.at(e,e.r,e.e,A.l(e).q("at<2>"));f.D();){e=f.d
b=e.gaD().a
if(!(b<14))return A.a(B.u,b)
d=B.u[b]*e.gv(e)
if(d>4)c+=d}k+=c}}for(n=i-1,a=0;a<i;++a){if(!(a<r.length))return A.a(r,a)
h=r[a]
a0=s.l(0,h)
g=a0.b.a
if(g.ag(a2)){f=a0.l(0,34665)
f.toString
e=o.l(0,a2)
e.toString
f.bA(e)}if(g.ag(a3)){f=a0.l(0,40965)
f.toString
e=o.l(0,a3)
e.toString
f.bA(e)}if(g.ag("gps")){f=a0.l(0,34853)
f.toString
e=o.l(0,"gps")
e.toString
f.bA(e)}f=o.l(0,h)
f.toString
a1.fw(a5,a0,f+2+12*a0.a.a+4)
if(a===n)a5.I(0)
else{f=a+1
if(!(f<r.length))return A.a(r,f)
f=o.l(0,r[f])
f.toString
a5.I(f)}a1.fz(a5,a0)
for(f=new A.O(g,g.r,g.e,A.l(g).q("O<1>"));f.D();){e=f.d
if(!g.ag(e))g.h(0,e,new A.aE(A.I(p,m),new A.aN(A.I(q,l))))
b=g.l(0,e)
b.toString
e=o.l(0,e)
e.toString
a1.fw(a5,b,e+2+12*b.a.a)
a1.fz(a5,b)}}a5.b=a4},
fw(a,b,c){var s,r,q,p,o,n,m=b.a
a.a0(m.a)
for(m=new A.O(m,m.r,m.e,A.l(m).q("O<1>"));m.D();){s=m.d
r=b.l(0,s)
r.toString
q=s===273
p=q&&r.gaD()===B.F?B.p:r.gaD()
o=q&&r.gaD()===B.F?1:r.gv(r)
a.a0(s)
a.a0(p.a)
a.I(o)
s=r.gaD().a
if(!(s<14))return A.a(B.u,s)
n=B.u[s]*r.gv(r)
if(n<=4){r.aT(a)
while(n<4){a.p(0);++n}}else{a.I(c)
c+=n}}return c},
fz(a,b){var s,r,q
for(s=b.a,s=new A.at(s,s.r,s.e,A.l(s).q("at<2>"));s.D();){r=s.d
q=r.gaD().a
if(!(q<14))return A.a(B.u,q)
if(B.u[q]*r.gv(r)>4)r.aT(a)}},
ci(b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=b5.e
b5.e=!0
s=b5.d
h=b5.n()
if(h===18761){b5.e=!1
if(b5.n()!==42){b5.e=b4
return!1}}else if(h===19789){b5.e=!0
if(b5.n()!==42){b5.e=b4
return!1}}else return!1
g=b5.k()
for(f=this.a,e=t.cO,d=t.p,c=t.r,b=t.N,a=t.P,a0=b5.c,a1=0;g>0;g=b0){a2=s
if(typeof a2!=="number")return a2.aZ()
a2+=g
b5.d=a2
if(a0-a2<2)break
a3=new A.aE(A.I(d,c),new A.aN(A.I(b,a)))
a4=b5.n()
a5=A.j(new Array(a4),e)
for(a6=0;a6<a4;++a6)a5[a6]=this.fa(b5,s)
for(a2=a5.length,a7=0;a7<a5.length;a5.length===a2||(0,A.a1)(a5),++a7){a8=a5[a7]
a9=a8.b
if(a9!=null)a3.h(0,a8.a,a9)}f.h(0,"ifd"+a1,a3);++a1
b0=b5.k()
if(b0===g)break}for(f=new A.at(f,f.r,f.e,A.l(f).q("at<2>"));f.D();){r=f.d
for(a0=B.cd.gc3(),a0=a0.gH(a0);a0.D();){q=a0.gO()
a2=A.o(q)
if(r.a.ag(a2))try{p=J.d(r,q).i(0)
a2=s
a9=p
if(typeof a2!=="number")return a2.aZ()
if(typeof a9!=="number")return A.nj(a9)
b5.d=a2+a9
o=new A.aE(A.I(d,c),new A.aN(A.I(b,a)))
n=b5.n()
m=n
a9=m
if(a9<0)A.b8(A.c2("Length must be a non-negative integer: "+A.z(a9),null))
l=A.j(new Array(a9),e)
k=0
for(;;){a2=k
a9=m
if(typeof a2!=="number")return a2.ld()
if(typeof a9!=="number")return A.nj(a9)
if(!(a2<a9))break
J.y(l,k,this.fa(b5,s))
a2=k
if(typeof a2!=="number")return a2.aZ()
k=a2+1}j=l
for(a2=j,a9=a2.length,a7=0;a7<a2.length;a2.length===a9||(0,A.a1)(a2),++a7){i=a2[a7]
if(i.b!=null){b1=i.a
b2=i.b
b2.toString
J.y(o,b1,b2)}}a2=r.b
a9=B.cd.l(0,q)
a9.toString
a2.a.h(0,a9,a.a(o))}catch(b3){continue}}}b5.e=b4
return!1},
fa(a,b){var s,r,q,p,o,n,m,l=a.n(),k=a.n(),j=a.k(),i=new A.hO(l,null)
if(k>14)return i
if(!(k<14))return A.a(B.aT,k)
s=B.aT[k]
r=j*B.u[k]
q=a.d
if((r>4?a.d=a.k()+b:q)+r>a.c)return i
p=a.aj(r)
switch(s.a){case 0:break
case 6:i.b=new A.bd(new Int8Array(A.r(J.kC(B.d.gB(p.a2()),0,j))))
break
case 1:i.b=new A.aZ(new Uint8Array(A.r(p.aj(j).a2())))
break
case 7:i.b=new A.bP(new Uint8Array(A.r(p.aj(j).a2())))
break
case 2:i.b=new A.c8(j===0?"":p.ak(j-1))
break
case 3:i.b=A.mb(p,j)
break
case 4:i.b=A.m6(p,j)
break
case 5:i.b=A.m7(p,j)
break
case 10:i.b=A.m9(p,j)
break
case 8:i.b=A.ma(p,j)
break
case 9:i.b=A.m8(p,j)
break
case 11:i.b=A.mc(p,j)
break
case 12:i.b=A.m4(p,j)
break
case 13:if(j===1){o=new A.c9(0)
n=p.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=n
n=$.a6()
if(0>=n.length)return A.a(n,0)
o.a=n[0]
i.b=o}break}a.d=q+4
return i}}
A.hO.prototype={}
A.ft.prototype={}
A.aN.prototype={
hE(a){a.a.bI(0,new A.it(this))},
gh_(a){var s,r=this.a
if(r.a===0)return!0
for(r=new A.at(r,r.r,r.e,A.l(r).q("at<2>"));r.D();){s=r.d
if(!(s.a.a===0&&s.b.gh_(0)))return!1}return!0},
l(a,b){var s=this.a
if(!s.ag(b))s.h(0,b,new A.aE(A.I(t.p,t.r),new A.aN(A.I(t.N,t.P))))
s=s.l(0,b)
s.toString
return s}}
A.it.prototype={
$2(a,b){var s
A.bG(a)
s=A.m3(t.P.a(b))
this.a.a.h(0,a,s)
return s},
$S:12}
A.aE.prototype={
fR(a){a.a.bI(0,new A.iu(this))
a.b.a.bI(0,new A.iv(this))},
l(a,b){var s=this.a.l(0,b)
return s},
h(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(typeof b=="string")b=B.kg.l(0,b)
if(!A.hX(b))return
if(c instanceof A.a2)k.a.h(0,b,c)
else{s=$.kB().l(0,b)
if(s!=null)switch(s.b.a){case 1:if(t.L.b(c))k.a.h(0,b,new A.aZ(new Uint8Array(A.r(new Uint8Array(A.r(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Uint8Array(1)
q[0]=r
k.a.h(0,b,new A.aZ(q))}break
case 2:break
case 3:if(t.L.b(c))k.a.h(0,b,new A.bt(new Uint16Array(A.r(new Uint16Array(A.r(c))))))
else if(typeof c=="number")k.a.h(0,b,A.oi(B.a.i(c)))
break
case 4:if(t.L.b(c))k.a.h(0,b,new A.aO(new Uint32Array(A.r(new Uint32Array(A.r(c))))))
else if(typeof c=="number")k.a.h(0,b,A.m5(B.a.i(c)))
break
case 5:if(t.bJ.b(c))k.a.h(0,b,new A.bc(A.e2(c,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.h(0,b,new A.bc(A.j([new A.aS(q,c[1])],t.aK)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.d0(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.aS(l,q[1])}k.a.h(0,b,new A.bc(A.e2(o,r)))}break
case 6:if(t.L.b(c))k.a.h(0,b,new A.bd(new Int8Array(A.r(new Int8Array(A.r(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int8Array(1)
q[0]=r
k.a.h(0,b,new A.bd(q))}break
case 7:if(t.L.b(c))k.a.h(0,b,new A.bP(new Uint8Array(A.r(new Uint8Array(A.r(c))))))
break
case 8:if(t.L.b(c))k.a.h(0,b,new A.bs(new Int16Array(A.r(new Int16Array(A.r(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int16Array(1)
q[0]=r
k.a.h(0,b,new A.bs(q))}break
case 9:if(t.L.b(c))k.a.h(0,b,new A.br(new Int32Array(A.r(new Int32Array(A.r(c))))))
else if(typeof c=="number"){r=B.a.i(c)
q=new Int32Array(1)
q[0]=r
k.a.h(0,b,new A.br(q))}break
case 10:if(t.bJ.b(c))k.a.h(0,b,new A.be(A.e2(c,t.i)))
else if(t.L.b(c)&&c.length===2){r=c.length
if(0>=r)return A.a(c,0)
q=c[0]
if(1>=r)return A.a(c,1)
k.a.h(0,b,new A.be(A.j([new A.aS(q,c[1])],t.aK)))}else if(t.f.b(c)){p=c.length
r=t.i
o=J.d0(p,r)
for(n=0;n<p;++n){q=c[n]
m=q.length
if(0>=m)return A.a(q,0)
l=q[0]
if(1>=m)return A.a(q,1)
o[n]=new A.aS(l,q[1])}k.a.h(0,b,new A.be(A.e2(o,r)))}break
case 11:if(t.H.b(c))k.a.h(0,b,new A.bO(new Float32Array(A.r(new Float32Array(A.r(c))))))
else if(typeof c=="number"){r=new Float32Array(1)
r[0]=c
k.a.h(0,b,new A.bO(r))}break
case 12:if(t.H.b(c))k.a.h(0,b,new A.bN(new Float64Array(A.r(new Float64Array(A.r(c))))))
else if(typeof c=="number"){r=new Float64Array(1)
r[0]=c
k.a.h(0,b,new A.bN(r))}break
case 13:if(typeof c=="number")k.a.h(0,b,new A.c9(B.a.i(c)))
break
case 0:break}}},
gcg(){var s=this.a.l(0,274)
return s==null?null:s.i(0)},
scg(a){this.a.dm(0,274)}}
A.iu.prototype={
$2(a,b){var s
A.o(a)
s=t.r.a(b).U()
this.a.a.h(0,a,s)
return s},
$S:16}
A.iv.prototype={
$2(a,b){var s
A.bG(a)
s=A.m3(t.P.a(b))
this.a.b.a.h(0,a,s)
return s},
$S:12}
A.ad.prototype={
a6(){return"IfdValueType."+this.b}}
A.a2.prototype={
a9(a,b){A.o(b)
return 0},
i(a){return this.a9(0,0)},
br(){return new Uint8Array(0)},
C(a){return""},
W(a,b){var s=this
if(b==null)return!1
return b instanceof A.a2&&s.gaD()===b.gaD()&&s.gv(s)===b.gv(b)&&s.gJ(s)===b.gJ(b)},
gJ(a){return 0},
bA(a){}}
A.aZ.prototype={
U(){return new A.aZ(new Uint8Array(A.r(this.a)))},
gaD(){return B.bf},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.aZ){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.a9(0,0)},
bA(a){var s=this.a
s.$flags&2&&A.c(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
br(){return this.a},
aT(a){a.a7(this.a)},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.c8.prototype={
U(){return new A.c8(this.a)},
gaD(){return B.l},
gv(a){return this.a.length+1},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.c8){s=this.a
r=b.a
s=s.length+1===r.length+1&&B.n.gJ(s)===B.n.gJ(r)}else s=!1
return s},
gJ(a){return B.n.gJ(this.a)},
br(){return new Uint8Array(A.r(new A.al(this.a)))},
aT(a){a.a7(new A.al(this.a))
a.p(0)},
C(a){return this.a}}
A.bt.prototype={
hJ(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.n()
r&2&&A.c(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.bt(new Uint16Array(A.r(this.a)))},
gaD(){return B.k},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bt){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.a9(0,0)},
bA(a){var s=this.a
s.$flags&2&&A.c(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
br(){return J.az(B.P.gB(this.a))},
aT(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.a0(r[s])},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.aO.prototype={
hG(a,b){var s,r,q,p
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
r&2&&A.c(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.aO(new Uint32Array(A.r(this.a)))},
gaD(){return B.p},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.aO){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.a9(0,0)},
bA(a){var s=this.a
s.$flags&2&&A.c(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
br(){return J.az(B.o.gB(this.a))},
aT(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.I(r[s])},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bc.prototype={
U(){return new A.bc(A.e2(this.a,t.i))},
gaD(){return B.r},
gv(a){return this.a.length},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].i(0)},
i(a){return this.a9(0,0)},
W(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.bc){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.n(s)===A.n(q)}else s=!1
return s},
gJ(a){return A.n(this.a)},
aT(a){var s,r,q,p
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a1)(s),++q){p=s[q]
a.I(p.a)
a.I(p.b)}},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].C(0)}else s=A.z(s)
return s}}
A.bd.prototype={
U(){return new A.bd(new Int8Array(A.r(this.a)))},
gaD(){return B.bk},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bd){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.a9(0,0)},
bA(a){var s=this.a
s.$flags&2&&A.c(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
br(){return J.az(B.ax.gB(this.a))},
aT(a){a.a7(J.E(B.ax.gB(this.a),0,null))},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.bs.prototype={
hI(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.n()
o=$.ao()
o.$flags&2&&A.c(o)
o[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.c(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.bs(new Int16Array(A.r(this.a)))},
gaD(){return B.bl},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bs){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.a9(0,0)},
bA(a){var s=this.a
s.$flags&2&&A.c(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
br(){return J.az(B.aw.gB(this.a))},
aT(a){var s,r,q,p=new Int16Array(1),o=J.lL(B.aw.gB(p),0,null),n=this.a,m=n.length
for(s=o.length,r=0;r<m;++r){q=n[r]
if(0>=1)return A.a(p,0)
p[0]=q
if(0>=s)return A.a(o,0)
a.a0(o[0])}},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.br.prototype={
hH(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.N()
o.$flags&2&&A.c(o)
o[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.c(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.br(new Int32Array(A.r(this.a)))},
gaD(){return B.bm},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.br){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b]},
i(a){return this.a9(0,0)},
bA(a){var s=this.a
s.$flags&2&&A.c(s)
if(0>=s.length)return A.a(s,0)
s[0]=a},
br(){return J.az(B.Z.gB(this.a))},
aT(a){var s,r,q,p=this.a,o=p.length
for(s=0;s<o;++s){r=p[s]
q=$.i4()
q.$flags&2&&A.c(q)
q[0]=r
r=$.kz()
if(0>=r.length)return A.a(r,0)
a.I(r[0])}},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=""+s[0]}else s=A.z(s)
return s}}
A.be.prototype={
U(){return new A.be(A.e2(this.a,t.i))},
gaD(){return B.bg},
gv(a){return this.a.length},
W(a,b){var s,r,q
if(b==null)return!1
if(b instanceof A.be){s=this.a
r=s.length
q=b.a
s=r===q.length&&A.n(s)===A.n(q)}else s=!1
return s},
gJ(a){return A.n(this.a)},
a9(a,b){var s
A.o(b)
s=this.a
if(!(b>=0&&b<s.length))return A.a(s,b)
return s[b].i(0)},
i(a){return this.a9(0,0)},
aT(a){var s,r,q,p,o,n
for(s=this.a,r=s.length,q=0;q<s.length;s.length===r||(0,A.a1)(s),++q){p=s[q]
o=$.i4()
o.$flags&2&&A.c(o)
o[0]=p.a
n=$.kz()
if(0>=n.length)return A.a(n,0)
a.I(n[0])
o[0]=p.b
a.I(n[0])}},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=s[0].C(0)}else s=A.z(s)
return s}}
A.bO.prototype={
hK(a,b){var s,r,q,p,o
for(s=this.a,r=s.$flags|0,q=0;q<b;++q){p=a.k()
o=$.N()
o.$flags&2&&A.c(o)
o[0]=p
p=$.c1()
if(0>=p.length)return A.a(p,0)
p=p[0]
r&2&&A.c(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
U(){return new A.bO(new Float32Array(A.r(this.a)))},
gaD(){return B.bh},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bO){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
br(){return J.az(B.a4.gB(this.a))},
aT(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.l9(r[s])},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.z(s[0])}else s=A.z(s)
return s}}
A.bN.prototype={
hF(a,b){var s,r
for(s=this.a,r=0;r<b;++r)B.a5.h(s,r,a.dl())},
U(){return new A.bN(new Float64Array(A.r(this.a)))},
gaD(){return B.bi},
gv(a){return this.a.length},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bN){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
br(){return J.az(B.a5.gB(this.a))},
aT(a){var s,r=this.a,q=r.length
for(s=0;s<q;++s)a.la(r[s])},
C(a){var s=this.a,r=s.length
if(r===1){if(0>=r)return A.a(s,0)
s=A.z(s[0])}else s=A.z(s)
return s}}
A.bP.prototype={
U(){return new A.bP(new Uint8Array(A.r(this.a)))},
gaD(){return B.F},
gv(a){return this.a.length},
br(){return this.a},
W(a,b){var s,r
if(b==null)return!1
if(b instanceof A.bP){s=this.a
r=b.a
s=s.length===r.length&&A.n(s)===A.n(r)}else s=!1
return s},
gJ(a){return A.n(this.a)},
aT(a){a.a7(this.a)},
C(a){return"<data>"}}
A.c9.prototype={
U(){return A.m5(this.a)},
gaD(){return B.bj},
gv(a){return 1},
W(a,b){var s
if(b==null)return!1
s=!1
if(b instanceof A.c9)s=this.a===b.a
return s},
gJ(a){return this.a},
a9(a,b){if(A.o(b)!==0)throw A.h(A.oX("Ifd tags must have exactly one entry (the offset)"))
return this.a},
i(a){return this.a9(0,0)},
bA(a){this.a=a},
br(){var s=this.a
return new Uint8Array(A.r(A.j([B.a.j(s,24),B.a.j(s,16),B.a.j(s,8),s],t.t)))},
aT(a){a.I(this.a)},
C(a){return"Ifd@"+this.a}}
A.fr.prototype={
a6(){return"DitherKernel."+this.b}}
A.ac.prototype={
a6(){return"BmpCompression."+this.b}}
A.i9.prototype={}
A.bn.prototype={
ej(a,b){var s,r,q,p,o,n,m,l=this,k=l.d,j=k<=40
if(j){s=l.r
s=s===B.aa||s===B.aE}else s=!0
if(s){s=l.as=a.k()
r=A.kg(s)
l.CW=r
q=B.a.a5(s,r)
s=q>0
l.cx=s?255/q:0
r=l.at=a.k()
p=A.kg(r)
l.cy=p
o=B.a.a5(r,p)
l.db=s?255/o:0
r=l.ax=a.k()
p=A.kg(r)
l.dx=p
n=B.a.a5(r,p)
l.dy=s?255/n:0
if(!j||l.r===B.aE){j=l.ay=a.k()
s=A.kg(j)
l.fr=s
m=B.a.a5(j,s)
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
if(l.f<=8)l.kS(a)},
gcM(){var s=this.d
if(s!==40)if(s===124){s=this.ay
s===$&&A.b("alphaMask")
s=s===0}else s=!1
else s=!0
return s},
gK(){return Math.abs(this.c)},
kS(a){var s,r,q,p,o,n=this,m=n.z
if(m===0)m=B.a.R(1,n.f)
n.ch=new A.aH(new Uint8Array(m*3),m,3)
for(s=0;s<m;++s){r=J.d(a.a,a.d++)
q=J.d(a.a,a.d++)
p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n.ch.cX(s,p,q,r,o)}},
ks(a2,a3){var s,r,q,p,o,n,m,l,k,j=this,i="_redShift",h="_redScale",g="greenMask",f="_greenShift",e="_greenScale",d="blueMask",c="_blueShift",b="_blueScale",a="alphaMask",a0="_alphaShift",a1="_alphaScale"
t.dX.a(a3)
if(j.ch!=null){s=j.f
if(s===1){r=a2.F()
for(q=7;q>=0;--q)a3.$4(B.a.bg(r,q)&1,0,0,0)
return}else if(s===2){r=a2.F()
for(q=6;q>=0;q-=2)a3.$4(B.a.bg(r,q)&2,0,0,0)}else if(s===4){r=a2.F()
a3.$4(B.a.j(r,4)&15,0,0,0)
a3.$4(r&15,0,0,0)
return}else if(s===8){a3.$4(a2.F(),0,0,0)
return}}s=j.r
if(s===B.aa&&j.f===32){p=a2.k()
s=j.as
s===$&&A.b("redMask")
o=j.CW
o===$&&A.b(i)
o=B.a.a5((p&s)>>>0,o)
s=j.cx
s===$&&A.b(h)
n=B.b.i(o*s)
s=j.at
s===$&&A.b(g)
o=j.cy
o===$&&A.b(f)
o=B.a.a5((p&s)>>>0,o)
s=j.db
s===$&&A.b(e)
m=B.b.i(o*s)
s=j.ax
s===$&&A.b(d)
o=j.dx
o===$&&A.b(c)
o=B.a.a5((p&s)>>>0,o)
s=j.dy
s===$&&A.b(b)
l=B.b.i(o*s)
if(j.gcM())k=255
else{s=j.ay
s===$&&A.b(a)
o=j.fr
o===$&&A.b(a0)
o=B.a.a5((p&s)>>>0,o)
s=j.fx
s===$&&A.b(a1)
k=B.b.i(o*s)}return a3.$4(n,m,l,k)}else{o=j.f
if(o===32&&s===B.aD){l=a2.F()
m=a2.F()
n=a2.F()
k=a2.F()
return a3.$4(n,m,l,j.gcM()?255:k)}else if(o===24){l=a2.F()
m=a2.F()
return a3.$4(a2.F(),m,l,255)}else if(o===16){p=a2.n()
s=j.as
s===$&&A.b("redMask")
o=j.CW
o===$&&A.b(i)
o=B.a.a5((p&s)>>>0,o)
s=j.cx
s===$&&A.b(h)
n=B.b.i(o*s)
s=j.at
s===$&&A.b(g)
o=j.cy
o===$&&A.b(f)
o=B.a.a5((p&s)>>>0,o)
s=j.db
s===$&&A.b(e)
m=B.b.i(o*s)
s=j.ax
s===$&&A.b(d)
o=j.dx
o===$&&A.b(c)
o=B.a.a5((p&s)>>>0,o)
s=j.dy
s===$&&A.b(b)
l=B.b.i(o*s)
if(j.gcM())k=255
else{s=j.ay
s===$&&A.b(a)
o=j.fr
o===$&&A.b(a0)
o=B.a.a5((p&s)>>>0,o)
s=j.fx
s===$&&A.b(a1)
k=B.b.i(o*s)}return a3.$4(n,m,l,k)}else throw A.h(A.m("Unsupported bitsPerPixel ("+o+") or compression ("+s.C(0)+")."))}},
$iK:1}
A.ff.prototype={
b4(a){var s,r=null
if(!A.kI(A.v(a,!1,r,0)))return r
s=A.v(a,!1,r,0)
this.a=s
return this.b=A.nS(s,r)},
ao(a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.b
if(a0==null)return new A.bu(a,a,a,a,0,B.j,0,0)
s=b.a
s===$&&A.b("_input")
r=a0.a.b
r===$&&A.b("imageOffset")
s.d=r
q=a0.f
r=a0.b
p=B.a.X(r*q+31,32)*4
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
k=A.Q(a,a,m,0,B.j,a0.gK(),a,0,o,l,B.e,r,!1)
for(j=k.gK()-1,s=a0.c,r=1/s<0,n=s<0,s=s===0;j>=0;--j){i={}
if(!(s?r:n))h=j
else{g=k.a
g=g==null?a:g.b
h=(g==null?0:g)-1-j}g=b.a
f=g.al(p)
g.d=g.d+(f.c-f.d)
g=k.a
e=g==null
d=e?a:g.a
if(d==null)d=0
i.a=0
c=e?a:g.N(0,h,a)
if(c==null)c=new A.D()
while(i.a<d)a0.ks(f,new A.i7(i,b,d,a0,c))}return k},
b6(a,b){if(this.b4(a)==null)return null
return this.ao(0)}}
A.i7.prototype={
$4(a,b,c,d){var s,r,q=this,p=q.a
if(p.a<q.c){s=q.b.c&&q.d.ch!=null
r=q.e
if(s){s=q.d
r.ac(s.ch.aX(a),s.ch.aW(a),s.ch.aV(a),s.ch.b3(a))}else r.ac(a,b,c,d)
r.D();++p.a}},
$S:18}
A.ie.prototype={}
A.i8.prototype={
bQ(c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7=null,b8=A.aa(!1,8192),b9=c3.gaC(),c0=c3.a,c1=c0==null?b7:c0.gM(),c2=c3.gL()
c0=c2===B.y
if(c0&&b9===1&&c1==null){c1=new A.aH(new Uint8Array(6),2,3)
c1.b0(0,0,0,0)
c1.b0(1,255,255,255)}else if(c0&&b9===2){c3=c3.cJ(B.t,1,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else if(c0&&b9===3&&c1==null){c3=c3.ce(B.z,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else if(c0&&b9===4)c3=c3.cI(B.e,4)
else{c0=c2===B.t
if(c0&&b9===1&&c1==null){c3=c3.ce(B.t,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else if(c0&&b9===2){c3=c3.ce(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else if(c0&&b9===3&&c1==null){c3=c3.ce(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else if(c0&&b9===4){c3=c3.ce(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else{c0=c2===B.z
if(c0&&b9===1&&c1==null){c3=c3.ce(B.e,!0)
c0=c3.a
c1=c0==null?b7:c0.gM()}else if(c0&&b9===2)c3=c3.cI(B.e,3)
else if(c0&&b9===3&&c1==null)c3=c3.cI(B.e,3)
else if(c0&&b9===4)c3=c3.cI(B.e,4)
else{c0=c2===B.e
if(c0&&b9===1&&c1==null)c3=c3.ce(B.e,!0)
else if(c0&&b9===2)c3.cI(B.e,3)
else if(c3.gaY())c3=c3.aM(B.e)
else if(c3.gaK()&&c3.gaC()===4)c3=c3.e1(4)}}}c0=c3.gaJ()
s=c3.a
r=c0*s.c
if(r===12)r=16
c0=r>8
q=c0?B.aa:B.aD
s=s.gbe()
p=s
if(p==null)p=0
o=B.a.X(c3.gS()*r+31,32)*4
n=o-p
m=n>0?A.S(n,255,!1,t.p):b7
l=r>=1&&r<=8?B.a.V(1,r):0
k=o*c3.gK()
j=c0?124:40
i=j+14
h=l*4
g=i+h
f=g-g
b8.a0(19778)
b8.I(k+i+h+f)
b8.I(0)
b8.I(g)
b8.I(j)
b8.I(c3.gS())
b8.I(c3.gK())
b8.a0(1)
b8.a0(r)
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
for(a1=0;a1<a0;++a1){b8.p(B.b.i(c1.aV(a1)))
b8.p(B.b.i(c1.aW(a1)))
b8.p(B.b.i(c1.aX(a1)))
b8.p(0)}for(;a1<l;++a1){b8.p(0)
b8.p(0)
b8.p(0)
b8.p(0)}}else if(c0){b8.p(0)
b8.p(0)
b8.p(0)
b8.p(0)
b8.p(255)
b8.p(255)
b8.p(255)
b8.p(0)}else if(r===2)for(a1=0;a1<4;++a1){a2=a1*85
b8.p(a2)
b8.p(a2)
b8.p(a2)
b8.p(0)}else if(r===4)for(a1=0;a1<16;++a1){a2=a1*17
b8.p(a2)
b8.p(a2)
b8.p(a2)
b8.p(0)}else if(s)for(a1=0;a1<256;++a1){b8.p(a1)
b8.p(a1)
b8.p(a1)
b8.p(0)}for(a3=f;a4=a3-1,a3>0;a3=a4)b8.p(0)
if(!a||r===2||r===4||s){a5=c3.gcP(0)-p
a6=c3.gK()
for(s=m!=null,a=r===4,a7=r===2,a8=0;a8<a6;++a8){a9=c3.a
a9=a9==null?b7:a9.gB(a9)
if(a9==null)a9=B.d.gB(new Uint8Array(0))
b0=J.E(a9,a5,p)
if(c0)b8.a7(b0)
else if(a7){a0=b0.length
for(b1=0;b1<a0;++b1){b2=b0[b1]
b8.p((b2&15)<<4|b2>>>4)}}else if(a){a0=b0.length
for(b1=0;b1<a0;++b1){b2=b0[b1]
b8.p(b2>>>4<<4|b2&15)}}else b8.a7(b0)
if(s)b8.a7(m)
a5-=p}return J.E(B.d.gB(b8.c),0,b8.a)}b3=c3.gaC()===4
a6=c3.gK()
b4=c3.gS()
if(r===16)for(a8=a6-1,c0=m!=null,b5=b7;a8>=0;--a8){s=c3.a
b5=s==null?b7:s.N(0,a8,b5)
if(b5==null)b5=new A.D()
for(b6=0;b6<b4;++b6){b8.p((B.b.i(b5.gt())<<4|B.b.i(b5.gu()))>>>0)
b8.p((B.b.i(b5.gA())<<4|B.b.i(b5.gm()))>>>0)
b5.D()}if(c0)b8.a7(m)}else for(a8=a6-1,c0=m!=null,b5=b7;a8>=0;--a8){s=c3.a
b5=s==null?b7:s.N(0,a8,b5)
if(b5==null)b5=new A.D()
for(b6=0;b6<b4;++b6){b8.p(A.o(b5.gu()))
b8.p(A.o(b5.gt()))
b8.p(A.o(b5.gm()))
if(b3)b8.p(A.o(b5.gA()))
b5.D()}if(c0)b8.a7(m)}return J.E(B.d.gB(b8.c),0,b8.a)}}
A.K.prototype={}
A.ic.prototype={}
A.ig.prototype={}
A.fu.prototype={}
A.dU.prototype={
cQ(){return this.w},
bs(a,b,c,d,e){throw A.h(A.m("B44 compression not yet supported."))},
ct(a,b,c){return this.bs(a,b,c,null,null)},
C(a){return A.z(this.r)+" "+this.x}}
A.cP.prototype={
a6(){return"ExrChannelType."+this.b}}
A.c4.prototype={
a6(){return"ExrChannelName."+this.b}}
A.fv.prototype={
hA(a){var s=this,r=a.cS()
s.a=r
if(r.length===0)return
r=a.k()
if(!(r<3))return A.a(B.bH,r)
s.c=B.bH[r]
a.F()
a.d+=3
s.f=a.k()
s.r=a.k()
r=s.a
if(r==="R"){s.w=!0
s.b=B.cX}else if(r==="G"){s.w=!0
s.b=B.cY}else if(r==="B"){s.w=!0
s.b=B.cZ}else if(r==="A"){s.w=!0
s.b=B.d_}else{s.w=!1
s.b=B.d0}switch(s.c.a){case 0:s.d=4
break
case 1:s.d=2
break
case 2:s.d=4
break}}}
A.aY.prototype={
a6(){return"ExrCompressorType."+this.b}}
A.bp.prototype={
bs(a,b,c,d,e){throw A.h(A.m("Unsupported compression type"))},
ct(a,b,c){return this.bs(a,b,c,null,null)}}
A.fP.prototype={}
A.fw.prototype={
sh3(a){this.c=t.T.a(a)}}
A.fx.prototype={
hB(a){var s,r,q,p,o=this,n=A.v(a,!1,null,0)
if(n.k()!==20000630)throw A.h(A.m("File is not an OpenEXR image file."))
s=o.d=n.F()
if(s!==2)throw A.h(A.m("Cannot read version "+s+" image files."))
s=o.e=n.bp()
if((s&4294967289)>>>0!==0)throw A.h(A.m("The file format version number's flag field contains unrecognized flags."))
if((s&16)===0){r=o.c
q=A.me(r.length,(s&2)!==0,n)
if(q.w>0)B.c.G(r,q)}else for(s=o.c;;){q=A.me(s.length,(o.e&2)!==0,n)
if(q.w<=0)break
B.c.G(s,q)}s=o.c
r=s.length
if(r===0)throw A.h(A.m("Error reading image header"))
for(p=0;p<s.length;s.length===r||(0,A.a1)(s),++p)s[p].kR(n)
o.jQ(n)},
jQ(a){var s,r,q,p,o=this
for(s=o.c,r=s.length,q=0;q<s.length;s.length===r||(0,A.a1)(s),++q){p=s[q]
o.a=Math.max(o.a,p.w)
o.b=Math.max(o.b,p.x)
if(p.db)o.jZ(p,a)
else o.jY(p,a)}},
jZ(b6,b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=null,b5=this.e
b5===$&&A.b("flags")
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
c=p.al(p.k())
p.d=p.d+(c.c-c.d)
g=b6.dy
g.toString
b=d*g
a=b6.dx
a.toString
g=r.bs(c,e*a,b,a,g)
a=g.length
a=Math.min(a,a)
a0=new A.af(g,0,a,0,!1)
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
g===$&&A.b("dataType")
switch(g.a){case 1:g=a0.n()
b0=$.R
b0=b0!=null?b0:A.V()
if(!(g<b0.length))return A.a(b0,g)
b1=b0[g]
break
case 2:b1=a0.n()
break
case 0:b1=a0.k()
break
default:b1=b4}g=a7.d
g===$&&A.b("dataSize")
a4+=g
g=a7.w
g===$&&A.b("isColorChannel")
if(g){g=b5.a
b2=g==null?b4:g.N(a8,b,b4)
if(b2==null)b2=new A.D()
g=a7.b
g===$&&A.b("nameType")
b2.h(0,g.a,b1)}else{g=a7.a
g===$&&A.b("name")
b0=b5.b
b3=b0!=null?b0.l(0,g):b4
if(b3!=null)b3.Y(a8,b,b1,0,0)}}}++a5;++b}++f;++h}++i}++j;++l}++m}},
jY(a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6=null,a7=this.e
a7===$&&A.b("flags")
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
h=$.N()
h.$flags&2&&A.c(h)
h[0]=i
i=$.a6()
if(0>=i.length)return A.a(i,0)
h[0]=n.k()
g=n.al(i[0])
n.d=n.d+(g.c-g.d)
if(l){i=r.ct(g,0,k)
h=i.length
f=new A.af(i,0,Math.min(h,h),0,!1)}else f=g
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
i===$&&A.b("dataType")
switch(i.a){case 1:i=f.n()
h=$.R
h=h!=null?h:A.V()
if(!(i<h.length))return A.a(h,i)
a3=h[i]
break
case 2:a3=f.n()
break
case 0:a3=f.k()
break
default:a3=a6}i=a0.d
i===$&&A.b("dataSize")
b+=i
i=a0.w
i===$&&A.b("isColorChannel")
if(i){i=a7.a
a4=i==null?a6:i.N(a2,k,a6)
if(a4==null)a4=new A.D()
i=a0.b
i===$&&A.b("nameType")
a4.h(0,i.a,a3)}else{i=a0.a
i===$&&A.b("name")
h=a7.b
a5=h!=null?h.l(0,i):a6
if(a5!=null)a5.Y(a2,k,a3,0,0)}}}++c;++k}}},
$iK:1}
A.dE.prototype={
hC(a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=null,a5="dataType",a6="dataWindow",a7=A.I(t.N,t.v)
for(s=a3.e,r=t.t,q=t.L,p=a3.c,o=B.E;;){n=b0.cS()
if(n.length===0)break
b0.cS()
m=b0.al(b0.k())
b0.d=b0.d+(m.c-m.d)
s.h(0,n,new A.fu())
switch(n){case"channels":for(;;){l=new A.fv()
l.hA(m)
k=l.a
k===$&&A.b("name")
if(k.length===0)break
j=l.w
j===$&&A.b("isColorChannel")
if(j){++a3.d
k=l.c
k===$&&A.b(a5)
if(k===B.aF)o=B.E
else o=k===B.aG?B.M:B.N}else{j=l.c
j===$&&A.b(a5)
if(j===B.aF){j=a3.w
i=a3.x
a7.h(0,k,new A.cS(new Uint16Array(j*i),j,i,1))}else if(j===B.aG){j=a3.w
i=a3.x
a7.h(0,k,new A.cT(new Float32Array(j*i),j,i,1))}else if(j===B.bb){j=a3.w
i=a3.x
a7.h(0,k,new A.cX(new Uint32Array(j*i),j,i,1))}}B.c.G(p,l)}break
case"chromaticities":k=new Float32Array(8)
a3.at=k
j=m.k()
i=$.N()
i.$flags&2&&A.c(i)
i[0]=j
j=$.c1()
if(0>=j.length)return A.a(j,0)
k[0]=j[0]
k=a3.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.c(k)
k[1]=h
h=a3.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.c(h)
h[2]=k
k=a3.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.c(k)
k[3]=h
h=a3.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.c(h)
h[4]=k
k=a3.at
i[0]=m.k()
h=j[0]
k.$flags&2&&A.c(k)
k[5]=h
h=a3.at
i[0]=m.k()
k=j[0]
h.$flags&2&&A.c(h)
h[6]=k
k=a3.at
i[0]=m.k()
j=j[0]
k.$flags&2&&A.c(k)
k[7]=j
break
case"compression":k=J.d(m.a,m.d++)
if(!(k>=0&&k<8))return A.a(B.bS,k)
a3.ax=B.bS[k]
break
case"dataWindow":k=m.k()
j=$.N()
j.$flags&2&&A.c(j)
j[0]=k
k=$.a6()
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
j=$.N()
j.$flags&2&&A.c(j)
j[0]=k
k=$.a6()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
j[0]=m.k()
j[0]=m.k()
break
case"lineOrder":break
case"pixelAspectRatio":k=m.k()
j=$.N()
j.$flags&2&&A.c(j)
j[0]=k
k=$.c1()
if(0>=k.length)return A.a(k,0)
break
case"screenWindowCenter":k=m.k()
j=$.N()
j.$flags&2&&A.c(j)
j[0]=k
k=$.c1()
if(0>=k.length)return A.a(k,0)
j[0]=m.k()
break
case"screenWindowWidth":k=m.k()
j=$.N()
j.$flags&2&&A.c(j)
j[0]=k
k=$.c1()
if(0>=k.length)return A.a(k,0)
break
case"tiles":a3.dx=m.k()
a3.dy=m.k()
f=J.d(m.a,m.d++)
a3.fr=f&15
a3.fx=B.a.j(f,4)&15
break
case"type":e=m.cS()
if(e!=="deepscanline")if(e!=="deeptile")throw A.h(A.m("EXR Invalid type: "+e))
break
default:break}}s=a3.w
a3.b=A.Q(a4,a4,o,0,B.j,a3.x,a4,0,a3.d,a4,B.e,s,!1)
for(s=new A.O(a7,a7.r,a7.e,a7.$ti.q("O<1>"));s.D();){r=s.d
q=a3.b
q.toString
k=a7.l(0,r)
k.toString
q.hp(r,k)}if(a3.db){s={}
r=a3.r
r===$&&A.b(a6)
a3.id=a3.i3(r[0],r[2],r[1],r[3])
r=a3.r
a3.k1=a3.i4(r[0],r[2],r[1],r[3])
if(a3.fr!==2)a3.k1=1
r=a3.id
r.toString
q=a3.r
a3.fy=a3.ew(r,q[0],q[2],a3.dx,a3.fx)
q=a3.k1
q.toString
r=a3.r
a3.go=a3.ew(q,r[1],r[3],a3.dy,a3.fx)
r=a3.i2()
a3.k2=r
q=a3.dx
q.toString
q=r*q
a3.k3=q
a3.CW=A.lY(a3.ax,a3,q,a3.dy)
s.a=s.b=0
q=a3.id
q.toString
r=a3.k1
r.toString
a3.ay=A.kT(q*r,new A.ij(s,a3),t.bv)}else{s=a3.x
r=a3.ch=new Uint32Array(s+1)
for(q=p.length,k=a3.r,j=a3.w,d=0;d<q;++d){c=p[d]
i=c.d
i===$&&A.b("dataSize")
h=c.f
h===$&&A.b("xSampling")
b=B.a.aG(i*j,h)
for(i=c.r,a=0;a<s;++a){k===$&&A.b(a6)
h=k[1]
i===$&&A.b("ySampling")
if(B.a.a8(a+h,i)===0)r[a]=r[a]+b}}for(a0=0,a=0;a<s;++a)a0=Math.max(a0,r[a])
s=A.lY(a3.ax,a3,a0,a4)
a3.CW=s
s=a3.cx=s.cQ()
r=a3.ch
q=r.length
p=new Uint32Array(q)
a3.cy=p
for(--q,a1=0,a2=0;a2<=q;++a2){if(B.a.a8(a2,s)===0)a1=0
p[a2]=a1
a1+=r[a2]}s=B.a.aG(a3.x+s,s)
a3.ay=A.j([new Uint32Array(s-1)],t.hh)}},
i3(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.o(r)
s=(q===0?o.d5(r):o.d_(r))+1
break
case 2:p=b-a+1
s=(o.fx===0?o.d5(p):o.d_(p))+1
break
default:throw A.h(A.m("Unknown LevelMode format."))}return s},
i4(a,b,c,d){var s,r,q,p,o=this
switch(o.fr){case 0:s=1
break
case 1:r=Math.max(b-a+1,d-c+1)
q=o.fx
A.o(r)
s=(q===0?o.d5(r):o.d_(r))+1
break
case 2:p=d-c+1
s=(o.fx===0?o.d5(p):o.d_(p))+1
break
default:throw A.h(A.m("Unknown LevelMode format."))}return s},
d5(a){var s
for(s=0;a>1;){++s
a=B.a.j(a,1)}return s},
d_(a){var s,r
for(s=0,r=0;a>1;){if((a&1)!==0)r=1;++s
a=B.a.j(a,1)}return s+r},
i2(){var s,r,q,p,o
for(s=this.c,r=s.length,q=0,p=0;p<r;++p){o=s[p].d
o===$&&A.b("dataSize")
q+=o}return q},
ew(a,b,c,d,e){var s,r,q,p,o,n,m=J.am(a,t.p)
for(s=e===1,r=c-b+1,q=0;q<a;++q){p=B.a.R(1,q)
o=B.a.aG(r,p)
if(s&&o*p<r)++o
n=Math.max(o,1)
d.toString
m[q]=B.a.aG(n+d-1,d)}return m}}
A.ij.prototype={
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
$S:19}
A.fQ.prototype={
kR(a){var s,r,q,p,o,n=this
if(n.db)for(s=0;s<n.ay.length;++s){r=0
for(;;){q=n.ay
if(!(s<q.length))return A.a(q,s)
q=q[s]
if(!(r<q.length))break
p=a.e4()
q.$flags&2&&A.c(q)
q[r]=p;++r}}else{q=n.ay
if(0>=q.length)return A.a(q,0)
o=q[0].length
for(s=0;s<o;++s){q=n.ay
if(0>=q.length)return A.a(q,0)
q=q[0]
p=a.e4()
q.$flags&2&&A.c(q)
if(!(s<q.length))return A.a(q,s)
q[s]=p}}}}
A.fR.prototype={
hN(a,b,c){var s,r,q,p=this,o=a.c.length,n=J.am(o,t.eP)
for(s=0;s<o;++s)n[s]=new A.f_()
p.y=t.gR.a(n)
r=p.w
r.toString
q=B.a.X(r*p.x,2)
p.z=new Uint16Array(q)},
cQ(){return this.x},
bs(a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6="_channelData"
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
q===$&&A.b(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
j.b=j.a=m
q=k.f
q===$&&A.b("xSampling")
i=B.a.aG(a8,q)
h=B.a.aG(s,q)
q=i*q<a8?0:1
q=h-i+q
j.c=q
p=k.r
p===$&&A.b("ySampling")
i=B.a.aG(a9,p)
h=B.a.aG(r,p)
g=i*p<a9?0:1
g=h-i+g
j.d=g
j.e=p
p=k.d
p===$&&A.b("dataSize")
p=p/2|0
j.f=p
m+=q*g*p}f=a7.n()
e=a7.n()
if(e>=8192)throw A.h(A.m("Error in header for PIZ-compressed data (invalid bitmap size)."))
d=new Uint8Array(8192)
if(f<=e){c=a7.aj(e-f+1)
b=c.c-c.d
for(a=f,l=0;l<b;++l,a=a0){a0=a+1
q=J.d(c.a,c.d+l)
if(!(a<8192))return A.a(d,a)
d[a]=q}}a1=new Uint16Array(65536)
a2=a5.k5(d,a1)
A.o7(a7,a7.k(),a5.z,m)
for(l=0;l<n;++l){q=a5.y
q===$&&A.b(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
a=0
for(;;){q=j.f
q===$&&A.b("size")
if(!(a<q))break
p=a5.z
p.toString
g=j.a
g===$&&A.b("start")
a3=j.c
a3===$&&A.b("nx")
a4=j.d
a4===$&&A.b("ny")
A.oa(p,g+a,a3,q,a4,a3*q,a2);++a}}q=a5.z
q.toString
a5.hW(a1,q,m)
q=a5.r
if(q==null){q=a5.w
q.toString
q=a5.r=A.aa(!1,q*a5.x+73728)}q.a=0
for(;a9<=r;++a9)for(l=0;l<n;++l){q=a5.y
q===$&&A.b(a6)
if(!(l<q.length))return A.a(q,l)
j=q[l]
q=j.e
q===$&&A.b("ys")
if(B.a.a8(a9,q)!==0)continue
q=j.c
q===$&&A.b("nx")
p=j.f
p===$&&A.b("size")
a8=q*p
for(;a8>0;--a8){q=a5.r
q.toString
p=a5.z
p.toString
g=j.b
g===$&&A.b("end")
j.b=g+1
if(!(g>=0&&g<p.length))return A.a(p,g)
q.a0(p[g])}}q=a5.r
return J.E(B.d.gB(q.c),0,q.a)},
ct(a,b,c){return this.bs(a,b,c,null,null)},
hW(a,b,c){var s,r,q,p=t.L
p.a(a)
p.a(b)
for(p=b.length,s=b.$flags|0,r=0;r<c;++r){if(!(r<p))return A.a(b,r)
q=b[r]
if(!(q>=0&&q<65536))return A.a(a,q)
q=a[q]
s&2&&A.c(b)
b[r]=q}},
k5(a,b){var s,r,q,p,o,n
for(s=b.$flags|0,r=0,q=0;q<65536;++q){if(q!==0){p=q>>>3
if(!(p<8192))return A.a(a,p)
p=(a[p]&1<<(q&7))>>>0!==0}else p=!0
if(p){o=r+1
s&2&&A.c(b)
if(!(r<65536))return A.a(b,r)
b[r]=q
r=o}}for(o=r;o<65536;o=n){n=o+1
s&2&&A.c(b)
if(!(o<65536))return A.a(b,o)
b[o]=0}return r-1}}
A.f_.prototype={}
A.fS.prototype={
cQ(){return this.x},
bs(a4,a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.D.c2(a4.a2()),a3=a1.y
if(a3==null){a3=a1.w
a3.toString
a3=a1.y=A.aa(!1,a1.x*a3)}a3.a=0
s=A.j([0,0,0,0],t.t)
r=new Uint32Array(1)
q=J.E(B.o.gB(r),0,null)
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
g===$&&A.b("ySampling")
if(B.a.a8(a6,g)!==0)continue
g=h.f
g===$&&A.b("xSampling")
f=B.a.aG(a5,g)
e=B.a.aG(p,g)
g=f*g<a5?0:1
d=e-f+g
if(0>=1)return A.a(r,0)
r[0]=0
g=h.c
g===$&&A.b("dataType")
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
g.p(q[a0])}}break
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
g.p(q[a0])}}break
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
g.p(q[a0])}}break}}a3=a1.y
return J.E(B.d.gB(a3.c),0,a3.a)},
ct(a,b,c){return this.bs(a,b,c,null,null)}}
A.fT.prototype={
cQ(){return 1},
bs(a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=a0.c,a=A.aa(!1,(b-a0.d)*2)
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
p=$.ap()
p.$flags&2&&A.c(p)
p[0]=q
q=$.ay()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0){n=-o
for(;m=n-1,n>0;n=m)a.p(J.d(a0.a,a0.d++))}else for(n=o;m=n-1,n>=0;n=m)a.p(J.d(a0.a,a0.d++))}l=J.E(B.d.gB(a.c),0,a.a)
k=l.length
for(b=l.$flags|0,j=1;j<k;++j){q=l[j-1]
p=l[j]
b&2&&A.c(l)
l[j]=q+p-128}b=c.r
if(b==null||b.length!==k)b=c.r=new Uint8Array(k)
q=B.a.X(k+1,2)
for(i=0,h=0;;q=d,i=f){if(h<k){g=h+1
f=i+1
if(!(i<k))return A.a(l,i)
p=l[i]
b.$flags&2&&A.c(b)
e=b.length
if(!(h<e))return A.a(b,h)
b[h]=p}else break
if(g<k){h=g+1
d=q+1
if(!(q<k))return A.a(l,q)
q=l[q]
if(!(g<e))return A.a(b,g)
b[g]=q}else break}return b},
ct(a,b,c){return this.bs(a,b,c,null,null)},
C(a){return A.z(this.w)}}
A.dV.prototype={
cQ(){return this.x},
bs(a,b,c,d,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=B.D.c2(a.a2())
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
q&2&&A.c(e)
e[n]=p+m-128}q=f.y
if(q==null||q.length!==o)q=f.y=new Uint8Array(o)
p=B.a.X(o+1,2)
for(l=0,k=0;;p=g,l=i){if(k<o){j=k+1
i=l+1
if(!(l<o))return A.a(e,l)
m=e[l]
q.$flags&2&&A.c(q)
h=q.length
if(!(k<h))return A.a(q,k)
q[k]=m}else break
if(j<o){k=j+1
g=p+1
if(!(p<o))return A.a(e,p)
p=e[p]
if(!(j<h))return A.a(q,j)
q[j]=p}else break}return q},
ct(a,b,c){return this.bs(a,b,c,null,null)},
C(a){return A.z(this.w)}}
A.ii.prototype={
ao(a){var s=this.a
if(s==null)return null
s=s.c
if(!(a<s.length))return A.a(s,a)
return s[a].b},
b6(a,b){var s=new A.fx(A.j([],t.dw))
s.hB(a)
this.a=s
return this.ao(0)}}
A.dI.prototype={
kB(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this
if(d===0&&e.c!=null){s=e.c
s.toString
return s}for(s=e.b,r=e.d,q=-1,p=-1,o=0;o<s;++o){n=r.aX(o)
m=r.aW(o)
l=r.aV(o)
k=r.b3(o)
if(n===a&&m===b&&l===c&&k===d)return o
j=a-n
i=b-m
h=c-l
g=d-k
f=j*j+i*i+h*h+g*g
if(p===-1){p=o
q=f}else if(f<q){p=o
q=f}}return p},
e9(){var s,r,q,p,o,n,m,l=this
if(l.c==null)return l.d
s=l.d
r=s.a
q=new A.aH(new Uint8Array(r*4),r,4)
for(p=0;p<r;++p){o=s.aX(p)
n=s.aW(p)
m=s.aV(p)
q.cX(p,o,n,m,p===l.c?0:255)}return q}}
A.dJ.prototype={
hD(a){var s,r,q,p,o,n,m=this
m.a=a.n()
m.b=a.n()
m.c=a.n()
m.d=a.n()
s=a.F()
m.e=(s&64)!==0
if((s&128)!==0){m.f=A.m0(B.a.R(1,(s&7)+1))
for(r=0;q=m.f,r<q.b;++r){p=J.d(a.a,a.d++)
o=J.d(a.a,a.d++)
n=J.d(a.a,a.d++)
q.d.b0(r,p,o,n)}}m.y=a.d-a.b}}
A.fU.prototype={}
A.dK.prototype={$iK:1}
A.ip.prototype={
b4(a){var s,r,q,p,o,n,m,l,k,j,i=this
i.f=A.v(a,!1,null,0)
i.a=new A.dK(A.j([],t.Y))
if(!i.eS())return null
try{while(p=i.f,o=p.d,o<p.c){n=p.a
p.d=o+1
s=J.d(n,o)
switch(s){case 44:r=i.fi()
if(r==null){p=i.a
return p}p=r
p.r=i.e
p.w=i.c
if(i.b!==0){if(r.f==null&&i.a.e!=null){p=i.a.e
o=p.a
n=p.b
m=p.c
p=p.d
r.f=new A.dI(o,n,m,new A.aH(new Uint8Array(A.r(p.c)),p.a,p.b))}if(r.f!=null)r.f.c=i.d}B.c.G(i.a.r,r)
break
case 33:p=i.f
q=J.d(p.a,p.d++)
if(J.fa(q,255)){p=i.f
if(p.ak(J.d(p.a,p.d++))==="NETSCAPE2.0"){l=J.d(p.a,p.d++)
k=J.d(p.a,p.d++)
if(l===3&&k===1)i.r=p.n()}else i.df()}else if(J.fa(q,249)){p=i.f
p.toString
i.jL(p)}else i.df()
break
case 59:p=i.a
return p
default:break}}}catch(j){}return i.a},
jL(a){var s,r,q,p=this
a.F()
s=a.F()
p.e=a.n()
p.d=a.F()
a.F()
p.c=B.a.j(s,2)&7
p.b=s&1
r=a.cY(1,0)
if(J.d(r.a,r.d)===44){++a.d
q=p.fi()
if(q==null)return
q.r=p.e
q.w=p.c
r=p.b!==0
q.x=r?p.d:-1
if(r){r=q.f
if(r==null&&p.a.e!=null){r=p.a.e
r.toString
r=q.f=A.of(r)}if(r!=null)r.c=p.d}B.c.G(p.a.r,q)}},
ao(a){var s,r,q,p=this,o=p.f
if(o==null||p.a==null)return null
s=p.a.r
r=s.length
if(a>=r)return null
q=s[a]
s=q.y
s===$&&A.b("_inputPosition")
o.d=s
return p.is(q)},
b6(a5,a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4=null
if(a3.b4(a5)==null)return a4
s=a3.a.r.length
if(s===1)return a3.ao(0)
for(s=t.p,r=a4,q=r,p=0;o=a3.a.r,p<o.length;++p){a6=o[p]
n=a3.ao(p)
if(n==null)return a4
n.y=a6.r*10
if(q==null||r==null){n.r=a3.r
r=n
q=r
continue}o=n.a
m=o==null
l=m?a4:o.a
if(l==null)l=0
k=r.a
j=k==null
i=j?a4:k.a
h=!1
if(l===(i==null?0:i)){o=m?a4:o.b
if(o==null)o=0
m=j?a4:k.b
if(o===(m==null?0:m)){o=a6.a
o===$&&A.b("x")
if(o===0){o=a6.b
o===$&&A.b("y")
o=o===0&&a6.w===2}else o=h}else o=h}else o=h
if(o){q.aI(n)
r=n
continue}g=a6.f
if(!(g!=null)){o=a3.a.e
o.toString
g=o}o=j?a4:k.a
if(o==null)o=0
m=j?a4:k.b
if(m==null)m=0
f=A.Q(a4,a4,B.e,0,B.j,m,a4,0,1,g.e9(),B.e,o,!1)
o=a6.w
if(o===2){o=f.a
e=o==null?a4:J.az(o.gB(o))
if(e==null){o=f.a
o=o==null?a4:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
e=J.az(o)}o=a6.x
m=e.length-1
if(o!==-1)B.d.aO(e,0,m,o)
else{o=a3.a.c.a
l=o.length
if(l!==0){if(0>=l)return A.a(o,0)
o=o[0]}else o=0
B.d.aO(e,0,m,o)}}else if(o!==3)if(a6.f!=null){o=r.a
o=o==null?a4:o.gM()
o.toString
d=A.I(s,s)
for(m=g.b,c=0;c<m;++c)d.h(0,c,g.kB(o.aX(c),o.aW(c),o.aV(c),o.b3(c)))
o=f.a
b=o==null?a4:J.az(o.gB(o))
if(b==null){o=f.a
o=o==null?a4:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
b=J.az(o)}o=r.a
a=o==null?a4:J.az(o.gB(o))
if(a==null){o=r.a
o=o==null?a4:o.gB(o)
if(o==null)o=B.d.gB(new Uint8Array(0))
a=J.az(o)}for(a0=b.length,o=a.length,m=b.$flags|0,a1=0;a1<a0;++a1){if(!(a1<o))return A.a(a,a1)
l=d.l(0,a[a1])
l.toString
if(l!==-1){m&2&&A.c(b)
b[a1]=l}}}f.y=n.y
for(o=n.a,o=o.gH(o);o.D();){a2=o.gO()
if(a2.gA()!==0){m=a2.gaU()
l=a6.a
l===$&&A.b("x")
k=a2.gaQ()
j=a6.b
j===$&&A.b("y")
f.c5(m+l,k+j,a2)}}q.aI(f)
r=f}return q},
fi(){var s,r=this.f
if(r.d>=r.c)return null
s=new A.fU()
s.hD(r);++this.f.d
this.df()
return s},
is(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=null
if(i.w==null){i.w=new Uint8Array(256)
i.x=new Uint8Array(4095)
i.y=new Uint8Array(4096)
i.z=new Uint32Array(4096)}s=i.Q=i.f.F()
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
s.$flags&2&&A.c(s)
s[0]=0
s=i.z
s.toString
B.o.aO(s,0,4096,4098)
s=a.c
s===$&&A.b("width")
r=a.d
r===$&&A.b("height")
q=a.a
q===$&&A.b("x")
p=i.a
if(q+s<=p.a){q=a.b
q===$&&A.b("y")
q=q+r>p.b}else q=!0
if(q)return h
o=a.f
if(!(o!=null)){q=p.e
q.toString
o=q}i.as=s*r
n=A.Q(h,h,B.e,0,B.j,r,h,0,1,o.e9(),B.e,s,!1)
m=new Uint8Array(s)
s=a.e
s===$&&A.b("interlaced")
if(s){s=a.b
s===$&&A.b("y")
for(r=s+r,l=0,k=0;l<4;++l)for(j=s+B.di[l];j<r;j+=B.eE[l],++k){if(!i.eT(m))return n
i.fo(n,j,o,m)}}else for(j=0;j<r;++j){if(!i.eT(m))return n
i.fo(n,j,o,m)}return n},
fo(a,b,c,d){var s,r,q,p=d.length
for(s=0;s<p;++s){r=d[s]
q=a.a
if(q!=null)q.Y(s,b,r,0,0)}},
eS(){var s,r,q,p,o,n=this,m=n.f.ak(6)
if(m!=="GIF87a"&&m!=="GIF89a")return!1
s=n.a
s.toString
s.a=n.f.n()
s=n.a
s.toString
s.b=n.f.n()
r=n.f.F()
s=n.a
s.toString
s.c=new A.bK(new Uint8Array(A.r(A.j([n.f.F()],t.t))));++n.f.d
if((r&128)!==0){s=n.a
s.toString
s.e=A.m0(B.a.R(1,(r&7)+1))
for(q=0;q<n.a.e.b;++q){s=n.f
p=J.d(s.a,s.d++)
s=n.f
o=J.d(s.a,s.d++)
s=n.f
r=J.d(s.a,s.d++)
n.a.e.d.b0(q,p,o,r)}}n.a.toString
return!0},
eT(a){var s=this,r=s.as
r.toString
s.as=r-a.length
if(!s.iD(a))return!1
if(s.as===0)s.df()
return!0},
df(){var s,r,q,p=this.f
if(p.d>=p.c)return!0
s=p.F()
for(;;){if(s!==0){p=this.f
p=p.d<p.c}else p=!1
if(!p)break
p=this.f
r=p.d+=s
if(r>=p.c)return!0
q=p.a
p.d=r+1
s=J.d(q,r)}return!0},
iD(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f="_stack",e="_suffix",d=g.ay
if(d>4095)return!1
s=a.length
r=0
if(d!==0){q=a.$flags|0
for(;;){if(!(d!==0&&r<s))break
p=r+1
o=g.x
o===$&&A.b(f)
d=g.ay=d-1
if(!(d>=0))return A.a(o,d)
o=o[d]
q&2&&A.c(a)
if(!(r<s))return A.a(a,r)
a[r]=o
r=p}}for(d=a.$flags|0;r<s;){n=g.ch=g.iC()
if(n==null)return!1
q=g.dx
if(n===q)return!1
o=g.dy
if(n===o){for(o=g.z,m=0;m<=4095;++m){o.toString
o.$flags&2&&A.c(o)
o[m]=4098}g.db=q+1
q=g.Q+1
g.cy=q
g.cx=B.a.V(1,q)
g.CW=4098}else{if(n<o){p=r+1
d&2&&A.c(a)
if(!(r>=0))return A.a(a,r)
a[r]=n
r=p}else{q=g.z
q.toString
if(n>>>0!==n||n>=4096)return A.a(q,n)
if(q[n]===4098){l=g.db-2
if(n===l){n=g.CW
k=g.y
k===$&&A.b(e)
j=g.x
j===$&&A.b(f)
i=g.ay++
o=g.dM(q,n,o)
j.$flags&2&&A.c(j)
if(!(i>=0&&i<4095))return A.a(j,i)
j[i]=o
k.$flags&2&&A.c(k)
if(!(l>=0&&l<4096))return A.a(k,l)
k[l]=o}else return!1}m=0
for(;;){h=m+1
if(!(m<=4095&&n>g.dy&&n<=4095))break
q=g.x
q===$&&A.b(f)
o=g.ay++
l=g.y
l===$&&A.b(e)
if(!(n>=0&&n<4096))return A.a(l,n)
l=l[n]
q.$flags&2&&A.c(q)
if(!(o>=0&&o<4095))return A.a(q,o)
q[o]=l
n=g.z[n]
m=h}if(h>=4095||n>4095)return!1
q=g.x
q===$&&A.b(f)
o=g.ay
l=g.ay=o+1
q.$flags&2&&A.c(q)
if(!(o>=0&&o<4095))return A.a(q,o)
q[o]=n
o=l
for(;;){if(!(o!==0&&r<s))break
p=r+1
o=g.ay=o-1
if(!(o>=0&&o<4095))return A.a(q,o)
l=q[o]
d&2&&A.c(a)
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
o.$flags&2&&A.c(o)
if(!(l>=0&&l<4096))return A.a(o,l)
o[l]=q
k=g.ch
j=g.y
i=g.dy
if(k===l){j===$&&A.b(e)
q=g.dM(o,q,i)
j.$flags&2&&A.c(j)
j[l]=q}else{j===$&&A.b(e)
k.toString
q=g.dM(o,k,i)
j.$flags&2&&A.c(j)
j[l]=q}}q=g.ch
q.toString
g.CW=q}}return!0},
iC(){var s,r,q,p,o=this
if(o.cy>12)return null
while(s=o.ax,r=o.cy,s<r){s=o.hZ()
s.toString
r=o.at
q=o.ax
o.at=(r|B.a.V(s,q))>>>0
o.ax=q+8}q=o.at
if(!(r>=0&&r<13))return A.a(B.bz,r)
p=B.bz[r]
o.at=B.a.a4(q,r)
o.ax=s-r
s=o.db
if(s<4097){++s
o.db=s
s=s>o.cx&&r<12}else s=!1
if(s){o.cx=o.cx<<1>>>0
o.cy=r+1}return q&p},
dM(a,b,c){var s,r,q=0
for(;;){if(b>c){s=q+1
r=q<=4095
q=s}else r=!1
if(!r)break
if(b>4095)return 4098
a.toString
if(!(b>=0))return A.a(a,b)
b=a[b]}return b},
hZ(){var s,r,q=this,p=q.w,o=p[0],n=p.$flags|0
if(o===0){o=q.f.F()
n&2&&A.c(p)
p[0]=o
p=q.w
o=p[0]
if(o===0)return null
B.d.bB(p,1,1+o,q.f.aj(o).a2())
p=q.w
s=p[1]
p.$flags&2&&A.c(p)
p[1]=2
p[0]=p[0]-1}else{r=p[1]
n&2&&A.c(p)
p[1]=r+1
if(!(r<256))return A.a(p,r)
s=p[r]
p[0]=o-1}return s}}
A.iq.prototype={
fE(a,b){var s,r,q,p=this
if(p.fx==null){p.fx=A.aa(!1,8192)
if(!a.gaK()){s=A.kV(a,256,10)
p.y=s
p.w=A.ng(a,B.ba,s,!1)}else p.w=a
p.x=b
p.z=a.gS()
p.Q=a.gK()
return}if(p.as===0){s=p.z
s===$&&A.b("_width")
r=p.Q
r===$&&A.b("_height")
p.fB(s,r)
p.fu()}s=p.w
s.toString
p.fA(s)
s=p.w
s.toString
r=p.z
r===$&&A.b("_width")
q=p.Q
q===$&&A.b("_height")
p.em(s,r,q);++p.as
if(!a.gaK()){s=A.kV(a,256,10)
p.y=s
p.w=A.ng(a,B.ba,s,!1)}else p.w=a
p.x=b},
aI(a){return this.fE(a,null)},
dk(){var s,r,q,p,o=this
if(o.fx==null)return null
if(o.as===0){s=o.z
s===$&&A.b("_width")
r=o.Q
r===$&&A.b("_height")
o.fB(s,r)
o.fu()}s=o.w
s.toString
o.fA(s)
s=o.w
s.toString
r=o.z
r===$&&A.b("_width")
q=o.Q
q===$&&A.b("_height")
o.em(s,r,q)
o.fx.p(59)
o.y=o.w=null
o.as=0
q=o.fx
p=J.E(B.d.gB(q.c),0,q.a)
o.fx=null
return p},
bQ(a){var s,r,q,p=this,o=a.gah().length
if(o<=1){p.aI(a)
o=p.dk()
o.toString
return o}p.b=a.r
for(o=a.gah(),s=o.length,r=0;r<o.length;o.length===s||(0,A.a1)(o),++r){q=o[r]
p.fE(q,B.a.X(q.y,10))}o=p.dk()
o.toString
return o},
em(a,b,c){var s,r,q,p,o,n,m,l,k,j
if(!a.gaK())throw A.h(A.m("GIF can only encode palette images."))
s=a.a
r=s==null?null:s.gM()
q=r.a
p=this.fx
p.p(44)
p.a0(0)
p.a0(0)
p.a0(b)
p.a0(c)
o=J.E(r.gB(r),0,null)
p.p(135)
n=r.b
if(n===3)p.a7(o)
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
p.p(0)}this.iM(a,b,c)},
iM(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d={}
e.fr=e.ax=e.at=0
e.dy=new Uint8Array(256)
e.fx.p(8)
s=new Int32Array(5003)
r=new Int32Array(5003)
q=a.a
p=q.gH(q)
p.D()
e.ay=e.ch=9
e.cx=511
e.cy=256
e.CW=257
e.dx=!1
e.db=258
d.a=!1
o=new A.ir(d,p)
n=o.$0()
for(m=0,l=5003;l<65536;l*=2)++m
m=8-m
for(k=0;k<5003;++k)s[k]=-1
e.cB(e.cy)
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
if(j)break}e.cB(n)
q=e.db
if(q<4096){e.db=q+1
r[k]=q
s[k]=h}else{for(k=0;k<5003;++k)s[k]=-1
q=e.cy
e.db=q+2
e.dx=!0
e.cB(q)}f=o.$0()
n=i
i=f}}e.cB(n)
e.cB(e.CW)
e.fx.p(0)},
cB(a){var s,r=this,q=r.at,p=r.ax
if(!(p>=0&&p<17))return A.a(B.bY,p)
q&=B.bY[p]
r.at=q
if(p>0){q=(q|B.a.R(a,p))>>>0
r.at=q}else{r.at=a
q=a}p+=r.ay
r.ax=p
while(p>=8){r.eo(q&255)
q=B.a.j(r.at,8)
r.at=q
p=r.ax-=8}if(r.db>r.cx||r.dx)if(r.dx){s=r.ch
r.ay=s
r.cx=B.a.R(1,s)-1
r.dx=!1}else{s=++r.ay
if(s===12)r.cx=4096
else r.cx=B.a.R(1,s)-1}if(a===r.CW){while(p>0){r.eo(q&255)
q=B.a.j(r.at,8)
r.at=q
p=r.ax-=8}r.fv()}},
fv(){var s,r=this,q=r.fr
if(q>0){r.fx.p(q)
q=r.fx
q.toString
s=r.dy
s===$&&A.b("_block")
q.hf(s,r.fr)
r.fr=0}},
eo(a){var s,r,q=this,p=q.dy
p===$&&A.b("_block")
s=q.fr
r=s+1
q.fr=r
p.$flags&2&&A.c(p)
if(!(s<256))return A.a(p,s)
p[s]=a
if(r>=254)q.fv()},
fu(){var s,r=this
r.fx.p(33)
r.fx.p(255)
r.fx.p(11)
r.fx.a7(new A.al("NETSCAPE2.0"))
s=r.fx
s.toString
s.a7(A.j([3,1],t.t))
r.fx.a0(r.b)
r.fx.p(0)},
fA(a){var s,r,q,p,o,n,m,l,k,j,i,h=this
h.fx.p(33)
h.fx.p(249)
h.fx.p(4)
s=a.a
r=s==null?null:s.gM()
q=r.b
p=q-1
o=0
n=0
if(q===4||q===2){m=J.E(r.gB(r),0,null)
l=r.a
for(s=m.length,k=p,j=o;j<l;++j,k+=q){if(!(k>=0&&k<s))return A.a(m,k)
if(m[k]===0){o=j
n=1
break}}}h.fx.p(n|8)
s=h.fx
s.toString
i=h.x
s.a0(i==null?80:i)
h.fx.p(o)
h.fx.p(0)},
fB(a,b){var s=this
s.fx.a7(new A.al("GIF89a"))
s.fx.a0(a)
s.fx.a0(b)
s.fx.p(0)
s.fx.p(0)
s.fx.p(0)}}
A.ir.prototype={
$0(){var s,r,q=this.a
if(q.a)return-1
s=this.b
r=A.o(s.gO().gT())
if(!s.D())q.a=!0
return r},
$S:20}
A.cR.prototype={
a6(){return"IcoType."+this.b}}
A.fF.prototype={$iK:1}
A.fG.prototype={}
A.fD.prototype={
gK(){return B.a.X(A.bn.prototype.gK.call(this),2)},
gcM(){return!(this.d===40&&this.f===32)&&A.bn.prototype.gcM.call(this)}}
A.is.prototype={
b6(a,b){var s,r,q,p=this,o=A.v(a,!1,null,0)
p.a=o
s=p.b=A.m2(o)
if(s==null)return null
o=s.e.length
if(o===1)return p.ao(0)
for(r=null,q=0;q<p.b.e.length;++q){b=p.ao(q)
if(b==null)continue
if(r==null){b.w=B.j
r=b}else r.aI(b)}return r},
ao(b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=null,a9=this.a
if(a9!=null){s=this.b
s=s==null||b0>=s.d}else s=!0
if(s)return a8
s=this.b.e
if(!(b0<s.length))return A.a(s,b0)
r=s[b0]
s=a9.a
a9=a9.b+r.e
q=r.d
p=J.kF(s,a9,a9+q)
o=new A.hh(A.mf())
t.D.a(p)
if(o.cr(p))return o.c1(p)
n=A.aa(!1,14)
n.a0(19778)
n.I(q)
n.I(0)
n.I(0)
a9=A.v(p,!1,a8,0)
s=A.lP(A.v(J.E(B.d.gB(n.c),0,n.a),!1,a8,0))
q=a9.d
m=a9.k()
l=a9.k()
k=$.N()
k.$flags&2&&A.c(k)
k[0]=l
l=$.a6()
if(0>=l.length)return A.a(l,0)
j=l[0]
k[0]=a9.k()
l=l[0]
i=a9.n()
h=a9.n()
g=a9.k()
if(!(g<14))return A.a(B.au,g)
g=B.au[g]
a9.k()
k[0]=a9.k()
k[0]=a9.k()
k=a9.k()
a9.k()
f=new A.fD(s,j,l,m,i,h,g,k,q)
f.ej(a9,s)
if(m!==40&&i!==1)return a8
e=k===0&&h<=8?40+4*B.a.R(1,h):40+4*k
s.b=e
n.a-=4
n.I(e)
d=A.v(p,!1,a8,0)
c=new A.ie(!0)
c.a=d
c.b=f
b=c.ao(0)
if(h>=32)return b
a=32-B.a.a8(j,32)
a0=B.a.X(a===32?j:j+a,8)
for(a9=l<0,s=l===0,l=1/l<0,a1=0;a1<B.a.X(A.bn.prototype.gK.call(f),2);++a1){if(!(s?l:a9))a2=a1
else{q=b.a
q=q==null?a8:q.b
a2=(q==null?0:q)-1-a1}a3=d.al(a0)
d.d=d.d+(a3.c-a3.d)
q=b.a
a4=q==null?a8:q.N(0,a2,a8)
if(a4==null)a4=new A.D()
for(a5=0;a5<j;){a6=J.d(a3.a,a3.d++)
a7=7
for(;;){if(!(a7>-1&&a5<j))break
if((a6&B.a.V(1,a7))>>>0!==0)a4.sA(0)
a4.D();++a5;--a7}}}return b}}
A.jB.prototype={
bQ(a){var s=a.gah().length
if(s>1)return this.fX(a.gah())
else return this.fX(A.j([a],t.g))},
fX(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null
t.gX.a(a)
s=a.length
r=A.aa(!1,8192)
r.a0(0)
r.a0(1)
r.a0(s)
q=6+s*16
p=A.j([A.j([],t.t)],t.S)
for(o=a.length,n=0,m=0;m<a.length;a.length===o||(0,A.a1)(a),++m){l=a[m]
k=l.a
j=k==null
i=j?g:k.a
if((i==null?0:i)<=256){i=j?g:k.b
i=(i==null?0:i)>256}else i=!0
if(i)throw A.h(A.lX("ICO and CUR support only sizes until 256"))
k=j?g:k.a
r.p(k==null?0:k)
k=l.a
k=k==null?g:k.b
r.p(k==null?0:k)
r.p(0)
r.p(0)
r.a0(0)
r.a0(32)
h=new A.hi().bQ(l)
k=h.length
r.I(k)
r.I(q)
q+=k;++n
B.c.G(p,h)}for(o=p.length,m=0;m<p.length;p.length===o||(0,A.a1)(p),++m)r.a7(p[m])
return J.E(B.d.gB(r.c),0,r.a)}}
A.fE.prototype={}
A.fl.prototype={}
A.bM.prototype={}
A.c7.prototype={}
A.dP.prototype={}
A.iE.prototype={}
A.bx.prototype={}
A.iG.prototype={
l8(a){var s,r,q,p,o,n=this,m=A.v(t.L.a(a),!0,null,0)
n.a=m
s=m.cY(2,0)
if(J.d(s.a,s.d)!==255||J.d(s.a,s.d+1)!==216)return!1
if(n.cn()!==216)return!1
r=n.cn()
q=!1
p=!1
for(;;){if(r!==217){m=n.a
m=m.d<m.c}else m=!1
if(!m)break
o=n.a.n()
if(o<2)break
m=n.a
m.d=m.d+(o-2)
switch(r){case 192:case 193:case 194:q=!0
break
case 218:p=!0
break}r=n.cn()}return q&&p},
ci(a){var s,r,q,p,o,n,m,l,k=this
k.a=A.v(t.L.a(a),!0,null,0)
k.jE()
if(k.y.length!==1)throw A.h(A.m("Only single frame JPEGs supported"))
for(s=k.as,r=0;q=k.d,p=q.z,r<p.length;++r){o=q.y.l(0,p[r])
q=o.a
p=k.d
n=p.f
m=o.b
l=p.r
p=k.i0(p,o)
if(q===n)q=0
else q=q===1&&n===4?2:1
if(m===l)n=0
else n=m===1&&l===4?2:1
B.c.G(s,new A.fl(p,q,n))}},
jE(){var s,r,q,p,o,n,m=this
if(m.cn()!==216)throw A.h(A.m("Start Of Image marker not found."))
s=m.cn()
for(;;){if(s!==217){r=m.a
r===$&&A.b("input")
r=r.d<r.c}else r=!1
if(!r)break
r=m.a
r===$&&A.b("input")
q=r.n()
if(q<2)A.b8(A.m("Invalid Block"))
r=m.a
p=r.al(q-2)
o=r.d=r.d+(p.c-p.d)
switch(s){case 224:case 225:case 226:case 227:case 228:case 229:case 230:case 231:case 232:case 233:case 234:case 235:case 236:case 237:case 238:case 239:case 254:m.jF(s,p)
break
case 219:m.jI(p)
break
case 192:case 193:case 194:m.jK(s,p)
break
case 195:case 197:case 198:case 199:case 200:case 201:case 202:case 203:case 205:case 206:case 207:throw A.h(A.m("Unhandled frame type "+B.a.dn(s,16)))
case 196:m.jH(p)
break
case 221:m.e=p.n()
break
case 218:m.jX(p)
break
case 255:if(J.d(r.a,o)!==255)--m.a.d
break
default:n=!1
if(J.d(r.a,o+-3)===255){r=m.a
if(J.d(r.a,r.d+-2)>=192){r=m.a
r=J.d(r.a,r.d+-2)<=254}else r=n}else r=n
if(r){m.a.d-=3
break}if(s!==0)throw A.h(A.m("Unknown JPEG marker "+B.a.dn(s,16)))
break}s=m.cn()}},
cn(){var s,r=this,q=r.a
q===$&&A.b("input")
if(q.d>=q.c)return 0
do{do{s=r.a.F()
if(s!==255){q=r.a
q=q.d<q.c}else q=!1}while(q)
q=r.a
if(q.d>=q.c)return s
do{s=r.a.F()
if(s===255){q=r.a
q=q.d<q.c}else q=!1}while(q)
if(s===0){q=r.a
q=q.d<q.c}else q=!1}while(q)
return s},
jP(a){var s
for(s=0;s<12;++s)if(J.d(a.a,a.d++)!==B.jM[s])return
this.r=new A.cQ("ICC_PROFILE",B.aJ,a.a2())},
jJ(a){if(a.k()!==1165519206)return
if(a.n()!==0)return
this.w.ci(a)},
jF(a,b){var s,r,q,p,o=this,n=b
if(a===224){s=n
r=!1
if(J.d(s.a,s.d)===74){s=n
if(J.d(s.a,s.d+1)===70){s=n
if(J.d(s.a,s.d+2)===73){s=n
if(J.d(s.a,s.d+3)===70){s=n
s=J.d(s.a,s.d+4)===0}else s=r}else s=r}else s=r}else s=r
if(s){s=new A.iJ()
r=n
J.d(r.a,r.d+5)
r=n
J.d(r.a,r.d+6)
r=n
J.d(r.a,r.d+7)
r=n
J.d(r.a,r.d+8)
r=n
J.d(r.a,r.d+9)
r=n
J.d(r.a,r.d+10)
r=n
J.d(r.a,r.d+11)
r=n
r=J.d(r.a,r.d+12)
s.f=r
q=n
q=J.d(q.a,q.d+13)
s.r=q
o.b=s
n.cY(14+3*r*q,14)}}else if(a===225)o.jJ(n)
else if(a===226)o.jP(n)
else if(a===238){s=n
r=!1
if(J.d(s.a,s.d)===65){s=n
if(J.d(s.a,s.d+1)===100){s=n
if(J.d(s.a,s.d+2)===111){s=n
if(J.d(s.a,s.d+3)===98){s=n
if(J.d(s.a,s.d+4)===101){s=n
s=J.d(s.a,s.d+5)===0}else s=r}else s=r}else s=r}else s=r}else s=r
if(s){o.c=new A.iE()
s=n
J.d(s.a,s.d+6)
o.c.toString
s=n
J.d(s.a,s.d+7)
s=n
J.d(s.a,s.d+8)
o.c.toString
s=n
J.d(s.a,s.d+9)
s=n
J.d(s.a,s.d+10)
s=o.c
s.toString
r=n
s.d=J.d(r.a,r.d+11)}}else if(a===254)try{n.kV()}catch(p){A.bk(p)}},
jI(a){var s,r,q,p,o,n,m,l,k
for(s=a.c,r=this.x;q=a.d,p=q<s,p;){p=a.a
a.d=q+1
o=J.d(p,q)
n=B.a.j(o,4)
o&=15
if(o>=4)throw A.h(A.m("Invalid number of quantization tables"))
if(r[o]==null)B.c.h(r,o,new Int16Array(64))
m=r[o]
for(q=n!==0,l=0;l<64;++l){k=q?a.n():J.d(a.a,a.d++)
m.toString
p=B.O[l]
m.$flags&2&&A.c(m)
if(!(p<64))return A.a(m,p)
m[p]=k}}if(p)throw A.h(A.m("Bad length for DQT block"))},
jK(a,b){var s,r,q,p,o,n,m,l=this
if(l.d!=null)throw A.h(A.m("Duplicate JPG frame data found."))
s=l.d=new A.h3(A.I(t.p,t.c),A.j([],t.t))
s.b=a===194
s.c=b.F()
s=l.d
s.toString
s.d=b.n()
s=l.d
s.toString
s.e=b.n()
r=b.F()
for(s=l.x,q=0;q<r;++q){p=J.d(b.a,b.d++)
o=J.d(b.a,b.d++)
n=B.a.j(o,4)
m=J.d(b.a,b.d++)
B.c.G(l.d.z,p)
l.d.y.h(0,p,new A.bx(n&15,o&15,s,m))}l.d.kP()
B.c.G(l.y,l.d)},
jH(a){var s,r,q,p,o,n,m,l,k,j,i,h
for(s=a.c,r=this.Q,q=this.z;p=a.d,p<s;){o=a.a
a.d=p+1
n=J.d(o,p)
m=new Uint8Array(16)
for(l=0,k=0;k<16;++k){p=J.d(a.a,a.d++)
if(!(k<16))return A.a(m,k)
m[k]=p
l+=m[k]}j=a.al(l)
a.d=a.d+(j.c-j.d)
i=j.a2()
if((n&16)!==0){n-=16
h=q}else h=r
if(h.length<=n)B.c.sv(h,n+1)
B.c.h(h,n,this.jh(m,i))}},
jX(a){var s,r,q,p,o,n,m,l=this,k=a.F()
if(k<1||k>4)throw A.h(A.m("Invalid SOS block"))
s=A.kT(k,new A.iH(l,a),t.c)
r=a.F()
q=a.F()
p=a.F()
o=B.a.j(p,4)
n=l.a
n===$&&A.b("input")
m=l.d
o=new A.h4(n,m,s,l.e,r,q,o&15,p&15)
n=m.w
n===$&&A.b("mcusPerLine")
o.f=n
o.r=m.b
o.bP()},
jh(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=A.j([],t.e8),g=16
for(;;){if(!(g>0&&a[g-1]===0))break;--g}s=t.fR
B.c.G(h,new A.dr(A.j([],s)))
if(0>=h.length)return A.a(h,0)
r=h[0]
for(q=b.length,p=0,o=0;o<g;){for(n=0;n<a[o];++n){if(0>=h.length)return A.a(h,-1)
r=h.pop()
m=r.a
l=m.length
k=r.b
if(l<=k)B.c.sv(m,k+1)
l=r.b
if(!(p>=0&&p<q))return A.a(b,p)
B.c.h(m,l,new A.dP(b[p]))
while(m=r.b,m>0){if(0>=h.length)return A.a(h,-1)
r=h.pop()}r.b=m+1
B.c.G(h,r)
for(;h.length<=o;r=j){m=A.j([],s)
j=new A.dr(m)
B.c.G(h,j)
l=r.a
k=l.length
i=r.b
if(k<=i)B.c.sv(l,i+1)
B.c.h(l,r.b,new A.c7(m))}++p}++o
if(o<g){m=A.j([],s)
j=new A.dr(m)
B.c.G(h,j)
l=r.a
k=l.length
i=r.b
if(k<=i)B.c.sv(l,i+1)
B.c.h(l,r.b,new A.c7(m))
r=j}}if(0>=h.length)return A.a(h,0)
return h[0].a},
i0(a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=a4.e
a2===$&&A.b("blocksPerLine")
s=a4.f
s===$&&A.b("blocksPerColumn")
r=a2<<3>>>0
q=new Int32Array(64)
p=new Uint8Array(64)
o=s*8
n=A.S(o,null,!1,t.aD)
for(m=a4.c,l=a4.d,k=0,j=0;j<s;++j){i=j<<3>>>0
for(h=0;h<8;++h,k=g){g=k+1
B.c.h(n,k,new Uint8Array(r))}for(f=0;f<a2;++f){if(!(l>=0&&l<4))return A.a(m,l)
e=m[l]
e.toString
d=a4.r
d===$&&A.b("blocks")
if(!(j<d.length))return A.a(d,j)
d=d[j]
if(!(f<d.length))return A.a(d,f)
A.rJ(e,d[f],p,q)
c=f<<3>>>0
for(b=0,a=0;a<8;++a){e=i+a
if(!(e<o))return A.a(n,e)
a0=n[e]
for(h=0;h<8;++h,b=a1){a0.toString
e=c+h
a1=b+1
if(!(b>=0&&b<64))return A.a(p,b)
d=p[b]
a0.$flags&2&&A.c(a0)
if(!(e<a0.length))return A.a(a0,e)
a0[e]=d}}}}return n}}
A.iH.prototype={
$1(a){var s,r,q,p,o,n=this.b,m=n.F(),l=n.F()
n=this.a
if(!n.d.y.ag(m))throw A.h(A.m("Invalid Component in SOS block"))
s=n.d.y.l(0,m)
s.toString
r=B.a.j(l,4)&15
q=l&15
p=n.Q
o=p.length
if(r<o){if(!(r<o))return A.a(p,r)
p=p[r]
p.toString
s.w=t.B.a(p)}n=n.z
p=n.length
if(q<p){if(!(q<p))return A.a(n,q)
n=n[q]
n.toString
s.x=t.B.a(n)}return s},
$S:21}
A.dr.prototype={}
A.h3.prototype={
kP(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this
for(s=a.y,r=A.l(s).q("O<1>"),q=new A.O(s,s.r,s.e,r);q.D();){p=s.l(0,q.d)
a.f=Math.max(a.f,p.a)
a.r=Math.max(a.r,p.b)}q=a.e
q.toString
a.w=B.b.bb(q/8/a.f)
q=a.d
q.toString
a.x=B.b.bb(q/8/a.r)
for(r=new A.O(s,s.r,s.e,r),q=t.fZ,o=t.k,n=t.f0;r.D();){m=s.l(0,r.d)
m.toString
l=a.e
l.toString
k=m.a
j=B.b.bb(B.b.bb(l/8)*k/a.f)
l=a.d
l.toString
i=m.b
h=B.b.bb(B.b.bb(l/8)*i/a.r)
g=a.w*k
f=a.x*i
e=J.am(f,n)
for(d=0;d<f;++d){c=J.am(g,o)
for(b=0;b<g;++b)c[b]=new Int32Array(64)
e[d]=c}m.e=j
m.f=h
m.r=q.a(e)}}}
A.iJ.prototype={}
A.h4.prototype={
bP(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a="blocksPerLine",a0=b.y,a1=a0.length,a2=b.r
a2.toString
if(a2)if(b.Q===0)s=b.at===0?b.gio():b.giq()
else s=b.at===0?b.gic():b.gig()
else s=b.gik()
a2=a1===1
if(a2){if(0>=a1)return A.a(a0,0)
r=a0[0]
q=r.e
q===$&&A.b(a)
r=r.f
r===$&&A.b("blocksPerColumn")
p=q*r}else{r=b.f
r===$&&A.b("mcusPerLine")
q=b.b.x
q===$&&A.b("mcusPerColumn")
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
k===$&&A.b(a)
j=B.a.aG(o,k)
i=B.a.a8(o,k)
k=m.r
k===$&&A.b("blocks")
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
for(f=0;f<g;++f)for(e=0;e<h;++e)b.it(m,s,o,f,e)}++o;++l}}b.ch=0
d=J.d(r.a,r.d)
c=J.d(r.a,r.d+1)
if(d===255)if(c>=208&&c<=215)r.d+=2
else break}},
cb(){var s,r=this,q=r.ch
if(q>0){--q
r.ch=q
return B.a.bg(r.ay,q)&1}q=r.a
if(q.d>=q.c)return null
s=q.F()
r.ay=s
if(s===255)if(q.F()!==0)return null
r.ch=7
return B.a.j(r.ay,7)&1},
cA(a){var s,r,q=new A.c7(t.B.a(a))
while(s=this.cb(),s!=null){if(q instanceof A.c7){r=q.a
if(s>>>0!==s||s>=r.length)return A.a(r,s)
q=r[s]}if(q instanceof A.dP)return q.a}return null},
dW(a){var s,r
for(s=0;a>0;){r=this.cb()
if(r==null)return null
s=(s<<1|r)>>>0;--a}return s},
cE(a){var s
if(a==null)return 0
if(a===1)return this.cb()===1?1:-1
s=this.dW(a)
if(s==null)return 0
if(s>=B.a.V(1,a-1))return s
return s+B.a.R(-1,a)+1},
il(a,b){var s,r,q,p,o,n,m,l,k=this
t.L.a(b)
s=a.w
s===$&&A.b("huffmanTableDC")
r=k.cA(s)
q=r===0?0:k.cE(r)
s=a.y
s===$&&A.b("pred")
s+=q
a.y=s
b.$flags&2&&A.c(b)
b[0]=s
for(p=1;p<64;){s=a.x
s===$&&A.b("huffmanTableAC")
o=k.cA(s)
if(o==null)break
n=o&15
m=o>>>4
if(n===0){if(m<15)break
p+=16
continue}p+=m
n=k.cE(n)
if(!(p>=0&&p<80))return A.a(B.O,p)
l=B.O[p]
b.$flags&2&&A.c(b)
if(!(l<64))return A.a(b,l)
b[l]=n;++p}},
ip(a,b){var s,r,q
t.L.a(b)
s=a.w
s===$&&A.b("huffmanTableDC")
r=this.cA(s)
q=r===0?0:B.a.R(this.cE(r),this.ax)
s=a.y
s===$&&A.b("pred")
s+=q
a.y=s
b.$flags&2&&A.c(b)
b[0]=s},
ir(a,b){var s,r
t.L.a(b)
s=b[0]
r=this.cb()
r.toString
r=B.a.R(r,this.ax)
b.$flags&2&&A.c(b)
b[0]=(s|r)>>>0},
ie(a,b){var s,r,q,p,o,n,m,l,k=this
t.L.a(b)
s=k.CW
if(s>0){k.CW=s-1
return}r=k.Q
q=k.as
for(s=k.ax;r<=q;){p=a.x
p===$&&A.b("huffmanTableAC")
p=k.cA(p)
p.toString
o=p&15
n=p>>>4
if(o===0){if(n<15){s=k.dW(n)
s.toString
k.CW=s+B.a.R(1,n)-1
break}r+=16
continue}r+=n
if(!(r>=0&&r<80))return A.a(B.O,r)
m=B.O[r]
p=k.cE(o)
l=B.a.R(1,s)
b.$flags&2&&A.c(b)
if(!(m<64))return A.a(b,m)
b[m]=p*l;++r}},
ih(a,b){var s,r,q,p,o,n,m,l,k,j=this
t.L.a(b)
s=j.Q
r=j.as
$label0$1:for(q=j.ax,p=0;s<=r;){if(!(s>=0&&s<80))return A.a(B.O,s)
o=B.O[s]
n=j.cx
switch(n){case 0:n=a.x
n===$&&A.b("huffmanTableAC")
m=j.cA(n)
if(m==null)throw A.h(A.m("Invalid progressive encoding"))
l=m&15
p=m>>>4
if(l===0)if(p<15){n=j.dW(p)
n.toString
j.CW=n+B.a.R(1,p)
j.cx=4}else{j.cx=1
p=16}else{if(l!==1)throw A.h(A.m("invalid ACn encoding"))
j.cy=j.cE(l)
j.cx=p!==0?2:3}continue $label0$1
case 1:case 2:if(!(o<64))return A.a(b,o)
k=b[o]
if(k!==0){n=j.cb()
n.toString
n=B.a.R(n,q)
b.$flags&2&&A.c(b)
if(!(o<64))return A.a(b,o)
b[o]=k+n}else{--p
if(p===0)j.cx=n===2?3:0}break
case 3:if(!(o<64))return A.a(b,o)
n=b[o]
if(n!==0){k=j.cb()
k.toString
k=B.a.R(k,q)
b.$flags&2&&A.c(b)
if(!(o<64))return A.a(b,o)
b[o]=n+k}else{n=j.cy
n===$&&A.b("successiveACNextValue")
n=B.a.R(n,q)
b.$flags&2&&A.c(b)
if(!(o<64))return A.a(b,o)
b[o]=n
j.cx=0}break
case 4:if(!(o<64))return A.a(b,o)
n=b[o]
if(n!==0){k=j.cb()
k.toString
k=B.a.R(k,q)
b.$flags&2&&A.c(b)
if(!(o<64))return A.a(b,o)
b[o]=n+k}break}++s}if(j.cx===4)if(--j.CW===0)j.cx=0},
it(a,b,c,d,e){var s,r,q,p,o
t.fb.a(b)
s=this.f
s===$&&A.b("mcusPerLine")
r=B.a.aG(c,s)*a.b+d
q=B.a.a8(c,s)*a.a+e
s=a.r
s===$&&A.b("blocks")
p=s.length
if(r>=p)return
if(!(r>=0))return A.a(s,r)
s=s[r]
o=s.length
if(q>=o)return
if(!(q>=0))return A.a(s,q)
b.$2(a,s[q])}}
A.h2.prototype={
b6(a,b){var s=A.ml()
s.ci(a)
if(s.y.length!==1)throw A.h(A.m("only single frame JPEGs supported"))
return A.rs(s)},
c1(a){return this.b6(a,null)}}
A.iF.prototype={
a6(){return"JpegChroma."+this.b}}
A.iI.prototype={
hq(a){a=B.a.i(B.a.P(a,1,100))
if(this.at===a)return
this.jb(a<50?B.b.bl(5000/a):B.a.bl(200-a*2))
this.at=a},
bQ(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=A.aa(!0,8192)
c.bN(b,216)
c.bN(b,224)
b.a0(16)
b.p(74)
b.p(70)
b.p(73)
b.p(70)
b.p(0)
b.p(1)
b.p(1)
b.p(0)
b.a0(1)
b.a0(1)
b.p(0)
b.p(0)
c.ke(b,a.gbF())
s=a.c
if(s!=null){c.bN(b,226)
r=s.kv()
q=A.j([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
b.a0(14+r.length)
b.a7(q)
b.a7(r)}c.kd(b)
s=a.gS()
p=a.gK()
c.bN(b,192)
b.a0(17)
b.p(8)
b.a0(p)
b.a0(s)
b.p(3)
b.p(1)
b.p(17)
b.p(0)
b.p(2)
b.p(17)
b.p(1)
b.p(3)
b.p(17)
b.p(1)
c.kc(b)
c.bN(b,218)
b.a0(12)
b.p(3)
b.p(1)
b.p(0)
b.p(2)
b.p(17)
b.p(3)
b.p(17)
b.p(0)
b.p(63)
b.p(0)
c.ax=0
c.ay=7
o=a.gS()
n=a.gK()
m=new Float32Array(64)
l=new Float32Array(64)
k=new Float32Array(64)
for(s=c.c,p=c.d,j=0,i=0,h=0,g=0;g<n;g+=8)for(f=0;f<o;f+=8){c.i5(a,f,g,o,n,m,l,k,B.cV)
e=c.e
d=c.r
d===$&&A.b("_yacHuffman")
j=c.dU(b,m,s,j,e,d)
d=c.f
e=c.w
e===$&&A.b("_uvacHuffman")
i=c.dU(b,l,p,i,d,e)
h=c.dU(b,k,p,h,c.f,c.w)}s=c.ay
if(s>=0){++s
c.bM(b,A.j([B.a.V(1,s)-1,s],t.t))}c.bN(b,217)
return J.E(B.d.gB(b.c),0,b.a)},
i5(a,b,c,d,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
for(s=this.as,r=c+1,q=0;q<64;++q){p=q>>>3
o=c+p
n=b+(q&7)
if(o>=a0)o-=r+p-a0
if(n>=d)n-=n-d+1
m=a.a
l=m==null?null:m.N(n,o,null)
if(l==null)l=new A.D()
if(l.gL()!==B.e)l=l.aM(B.e)
if(l.gv(l)>3){k=l.ga_()
j=1-k
l.sm(B.b.bq(l.gm()*k+a4.l(0,0)*j))
l.st(B.b.bq(l.gt()*k+a4.l(0,1)*j))
l.su(B.b.bq(l.gu()*k+a4.l(0,2)*j))}i=B.b.i(l.gm())
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
a1.$flags&2&&A.c(a1)
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
a2.$flags&2&&A.c(a2)
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
a3.$flags&2&&A.c(a3)
if(!(q<64))return A.a(a3,q)
a3[q]=e-128}},
bN(a,b){a.p(255)
a.p(b&255)},
jb(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.a,r=s.$flags|0,q=0;q<64;++q){p=B.b.bl((B.ih[q]*a+50)/100)
if(p<1)p=1
else if(p>255)p=255
o=B.a1[q]
r&2&&A.c(s)
if(!(o<64))return A.a(s,o)
s[o]=p}for(r=b.b,o=r.$flags|0,n=0;n<64;++n){m=B.b.bl((B.ep[n]*a+50)/100)
if(m<1)m=1
else if(m>255)m=255
l=B.a1[n]
o&2&&A.c(r)
if(!(l<64))return A.a(r,l)
r[l]=m}for(o=b.c,l=o.$flags|0,k=b.d,j=k.$flags|0,i=0,h=0;h<8;++h)for(g=0;g<8;++g){if(!(i>=0&&i<64))return A.a(B.a1,i)
f=B.a1[i]
if(!(f<64))return A.a(s,f)
e=s[f]
d=B.by[h]
c=B.by[g]
l&2&&A.c(o)
o[i]=1/(e*d*c*8)
f=r[f]
j&2&&A.c(k)
k[i]=1/(f*d*c*8);++i}},
d1(a,b){var s,r,q,p,o,n,m,l=t.L
l.a(a)
l.a(b)
l=t.t
s=A.j([A.j([],l)],t.ca)
for(r=b.length,q=0,p=0,o=1;o<=16;++o){for(n=1;n<=a[o];++n){if(!(p>=0&&p<r))return A.a(b,p)
m=b[p]
if(s.length<=m)B.c.sv(s,m+1)
B.c.h(s,m,A.j([q,o],l));++p;++q}q*=2}return s},
j9(){var s,r,q,p,o,n,m,l,k,j,i
for(s=this.y,r=this.x,q=t.t,p=1,o=2,n=1;n<=15;++n){for(m=p;m<o;++m){l=32767+m
B.c.h(s,l,n)
B.c.h(r,l,A.j([m,n],q))}for(l=o-1,k=-l,j=-p;k<=j;++k){i=32767+k
B.c.h(s,i,n)
B.c.h(r,i,A.j([l+k,n],q))}p=p<<1>>>0
o=o<<1>>>0}},
jc(){var s,r,q
for(s=this.as,r=s.$flags|0,q=0;q<256;++q){r&2&&A.c(s)
s[q]=19595*q
s[q+256]=38470*q
s[q+512]=7471*q+32768
s[q+768]=-11059*q
s[q+1024]=-21709*q
s[q+1280]=32768*q+8421375
s[q+1536]=-27439*q
s[q+1792]=-5329*q}},
iR(d6,d7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4,d5=t.H
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
d5&2&&A.c(d6)
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
d5&2&&A.c(d6)
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
ke(a,b){var s,r
if(b.gh_(0))return
s=A.aa(!1,8192)
b.aT(s)
r=J.E(B.d.gB(s.c),0,s.a)
this.bN(a,225)
a.a0(r.length+8)
a.I(1165519206)
a.a0(0)
a.a7(r)},
kd(a){var s,r,q
this.bN(a,219)
a.a0(132)
a.p(0)
for(s=this.a,r=0;r<64;++r)a.p(s[r])
a.p(1)
for(s=this.b,q=0;q<64;++q)a.p(s[q])},
kc(a){var s,r,q,p,o,n,m,l
this.bN(a,196)
a.a0(418)
a.p(0)
for(s=0;s<16;){++s
a.p(B.cc[s])}for(r=0;r<=11;++r)a.p(B.ah[r])
a.p(16)
for(q=0;q<16;){++q
a.p(B.bq[q])}for(p=0;p<=161;++p)a.p(B.bA[p])
a.p(1)
for(o=0;o<16;){++o
a.p(B.bN[o])}for(n=0;n<=11;++n)a.p(B.ah[n])
a.p(17)
for(m=0;m<16;){++m
a.p(B.bG[m])}for(l=0;l<=161;++l)a.p(B.bV[l])},
dU(a,a0,a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=this,b=t.H
b.a(a0)
b.a(a1)
t.fl.a(a3)
t.d.a(a4)
b=a4.length
if(0>=b)return A.a(a4,0)
s=a4[0]
if(240>=b)return A.a(a4,240)
r=a4[240]
q=c.iR(a0,a1)
for(b=c.Q,p=0;p<64;++p)B.c.h(b,B.a1[p],q[p])
o=b[0]
o.toString
n=o-a2
if(n===0){if(0>=a3.length)return A.a(a3,0)
m=a3[0]
m.toString
c.bM(a,m)}else{l=32767+n
a3.toString
m=c.y
if(!(l>=0&&l<65535))return A.a(m,l)
m=m[l]
m.toString
if(!(m<a3.length))return A.a(a3,m)
m=a3[m]
m.toString
c.bM(a,m)
m=c.x[l]
m.toString
c.bM(a,m)}k=63
for(;;){if(!(k>0&&b[k]===0))break;--k}if(k===0){s.toString
c.bM(a,s)
return o}for(m=c.y,j=c.x,i=1;i<=k;){h=i
for(;;){if(!(h>=0&&h<64))return A.a(b,h)
if(!(b[h]===0&&h<=k))break;++h}g=h-i
if(g>=16){f=B.a.j(g,4)
for(e=1;e<=f;++e){r.toString
c.bM(a,r)}g&=15}d=b[h]
d.toString
l=32767+d
if(!(l>=0&&l<65535))return A.a(m,l)
d=m[l]
d.toString
d=(g<<4>>>0)+d
if(!(d<a4.length))return A.a(a4,d)
d=a4[d]
d.toString
c.bM(a,d)
d=j[l]
d.toString
c.bM(a,d)
i=h+1}if(k!==63){s.toString
c.bM(a,s)}return o},
bM(a,b){var s,r,q,p=this
t.L.a(b)
s=b.length
if(0>=s)return A.a(b,0)
r=b[0]
if(1>=s)return A.a(b,1)
q=b[1]-1
while(q>=0){if((r&B.a.V(1,q))>>>0!==0)p.ax=(p.ax|B.a.V(1,p.ay))>>>0;--q
if(--p.ay<0){s=p.ax
if(s===255){a.p(255)
a.p(0)}else a.p(s)
p.ay=7
p.ax=0}}}}
A.d7.prototype={
a6(){return"PngDisposeMode."+this.b}}
A.eq.prototype={
a6(){return"PngBlendMode."+this.b}}
A.er.prototype={}
A.fV.prototype={}
A.bS.prototype={
a6(){return"PngFilterType."+this.b}}
A.hk.prototype={
sM(a){this.w=t.di.a(a)},
sl5(a){this.x=t.T.a(a)},
$iK:1}
A.fW.prototype={}
A.hh.prototype={
cr(a){var s,r=A.v(a,!0,null,0).aj(8)
for(s=0;s<8;++s)if(J.d(r.a,r.d+s)!==B.c0[s])return!1
return!0},
b4(b7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4=this,b5=null,b6=A.v(b7,!0,b5,0)
b4.d=b6
s=b6.aj(8)
for(r=0;r<8;++r)if(J.d(s.a,s.d+r)!==B.c0[r])return b5
for(b6=b4.a,q=b6.cx,p=t.t,o=b6.cy,n=t.L,m=b6.ax;;){l=b4.d
k=l.d-l.b
j=l.k()
i=b4.d.ak(4)
switch(i){case"tEXt":l=b4.d
h=l.al(j)
l.d=l.d+(h.c-h.d)
g=h.a2()
f=g.length
for(r=0;r<f;++r)if(g[r]===0){l=r+1
m.h(0,B.b6.c1(new Uint8Array(g.subarray(0,A.b4(0,r,f)))),B.b6.c1(new Uint8Array(g.subarray(l,A.b4(l,b5,f)))))
break}b4.d.d+=4
break
case"pHYs":l=b4.d
h=l.al(j)
l.d=l.d+(h.c-h.d)
e=A.p(h,b5,0)
e.k()
e.k()
J.d(e.a,e.d++)
b4.d.d+=4
break
case"IHDR":l=b4.d
h=l.al(j)
l.d=l.d+(h.c-h.d)
d=A.p(h,b5,0)
c=d.a2()
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
switch(l){case 0:if(!B.c.cd(A.j([1,2,4,8,16],p),b6.c))return b5
break
case 2:if(!B.c.cd(A.j([8,16],p),b6.c))return b5
break
case 3:if(!B.c.cd(A.j([1,2,4,8],p),b6.c))return b5
break
case 4:if(!B.c.cd(A.j([8,16],p),b6.c))return b5
break
case 6:if(!B.c.cd(A.j([8,16],p),b6.c))return b5
break}if(b4.d.k()!==A.bj(n.a(c),A.bj(new A.al(i),0)))throw A.h(A.m("Invalid "+i+" checksum"))
break
case"PLTE":l=b4.d
h=l.al(j)
l.d=l.d+(h.c-h.d)
b6.sM(h.a2())
if(b4.d.k()!==A.bj(n.a(n.a(b6.w)),A.bj(new A.al(i),0)))throw A.h(A.m("Invalid "+i+" checksum"))
break
case"tRNS":l=b4.d
h=l.al(j)
l.d=l.d+(h.c-h.d)
b6.sl5(h.a2())
b=b4.d.k()
l=b6.x
l.toString
if(b!==A.bj(n.a(l),A.bj(new A.al(i),0)))throw A.h(A.m("Invalid "+i+" checksum"))
break
case"IEND":b4.d.d+=4
break
case"gAMA":if(j!==4)throw A.h(A.m("Invalid gAMA chunk"))
b4.d.k()
b4.d.d+=4
break
case"IDAT":B.c.G(o,k)
l=b4.d
l.d=(l.d+=j)+4
break
case"acTL":b6.ch=b4.d.k()
b4.d.k()
b4.d.d+=4
break
case"fcTL":b4.d.k()
a=b4.d.k()
a0=b4.d.k()
a1=b4.d.k()
a2=b4.d.k()
a3=b4.d.n()
a4=b4.d.n()
l=b4.d
a5=J.d(l.a,l.d++)
l=b4.d
a6=J.d(l.a,l.d++)
if(!(a5>=0&&a5<3))return A.a(B.bp,a5)
l=B.bp[a5]
if(!(a6>=0&&a6<2))return A.a(B.bO,a6)
a7=B.bO[a6]
B.c.G(q,new A.fV(A.j([],p),a,a0,a1,a2,a3,a4,l,a7))
b4.d.d+=4
break
case"fdAT":b4.d.k()
B.c.G(B.c.gh2(q).y,k)
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
if(l!=null){l=B.d.cd(l,a8)?0:255
a7=new Uint8Array(4)
a7[0]=b0
a7[1]=b2
a7[2]=b3
a7[3]=l
b6.z=new A.cH(a7)}else{l=new Uint8Array(3)
l[0]=b0
l[1]=b2
l[2]=b3
b6.z=new A.fk(l)}}else if(l===0||l===4){b4.d.n()
j-=2}else if(l===2||l===6){l=b4.d
l.n()
l.n()
l.n()
j-=24}if(j>0)b4.d.d+=j
b4.d.d+=4
break
case"iCCP":b6.Q=b4.d.cS()
l=b4.d
J.d(l.a,l.d++)
l=b6.Q
a7=b4.d
h=a7.al(j-(l.length+2))
a7.d=a7.d+(h.c-h.d)
b6.at=h.a2()
b4.d.d+=4
break
default:l=b4.d
l.d=(l.d+=j)+4
break}if(i==="IEND")break
l=b4.d
if(l.d>=l.c)return b5}return b6},
ao(c3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5=this,b6=null,b7=null,b8=b5.a,b9=b8.a,c0=b8.b,c1=b8.cx,c2=c1.length
if(c2===0||c3===0){r=A.j([],t.gN)
c1=b8.cy
q=c1.length
for(c2=t.L,p=0,o=0;o<q;++o){n=b5.d
n===$&&A.b("_input")
if(!(o<c1.length))return A.a(c1,o)
n.d=c1[o]
m=n.k()
l=b5.d.ak(4)
n=b5.d
k=n.al(m)
n.d=n.d+(k.c-k.d)
j=k.a2()
p+=j.length
B.c.G(r,j)
if(b5.d.k()!==A.bj(c2.a(j),A.bj(new A.al(l),0)))throw A.h(A.m("Invalid "+l+" checksum"))}b7=new Uint8Array(p)
for(c1=r.length,i=0,h=0;h<r.length;r.length===c1||(0,A.a1)(r),++h){j=r[h]
J.lN(b7,i,j)
i+=j.length}}else{if(c3>=c2)throw A.h(A.m("Invalid Frame Number: "+c3))
if(!(c3<c2))return A.a(c1,c3)
g=c1[c3]
b9=g.b
c0=g.c
r=A.j([],t.gN)
for(c1=g.y,p=0,o=0;o<c1.length;++o){c2=b5.d
c2===$&&A.b("_input")
c2.d=c1[o]
m=c2.k()
c2=b5.d
c2.ak(4)
c2.d+=4
c2=b5.d
k=c2.al(m-4)
c2.d=c2.d+(k.c-k.d)
j=k.a2()
p+=j.length
B.c.G(r,j)}b7=new Uint8Array(p)
for(c1=r.length,i=0,h=0;h<r.length;r.length===c1||(0,A.a1)(r),++h){j=r[h]
J.lN(b7,i,j)
i+=j.length}}c1=b8.d
f=1
if(!(c1===3))if(!(c1===0)){if(c1===4)c1=2
else c1=c1===6?4:3
f=c1}s=null
try{s=B.D.c2(b7)}catch(e){return b6}d=A.v(s,!0,b6,0)
b5.c=b5.b=0
c=b6
if(b8.d===3){c1=b8.w
if(c1!=null){c2=c1.length
b=c2/3|0
a=b8.x
n=a!=null
a0=n?a.length:0
a1=n?4:3
c=new A.aH(new Uint8Array(b*a1),b,a1)
for(n=a1===4,o=0,a2=0;o<b;++o,a2+=3){if(n&&o<a0){if(!(o<a.length))return A.a(a,o)
a3=a[o]}else a3=255
if(!(a2<c2))return A.a(c1,a2)
a4=c1[a2]
a5=a2+1
if(!(a5<c2))return A.a(c1,a5)
a5=c1[a5]
a6=a2+2
if(!(a6<c2))return A.a(c1,a6)
c.cX(o,a4,a5,c1[a6],a3)}}}if(b8.d===0&&b8.x!=null&&c==null&&b8.c<=8){a=b8.x
a7=a.length
c1=b8.c
b=B.a.V(1,c1)
c2=b*4
n=new Uint8Array(c2)
c=new A.aH(n,b,4)
if(c1===1)a8=255
else if(c1===2)a8=85
else{c1=c1===4?17:1
a8=c1}for(o=0;o<b;++o){a9=o*a8
c.cX(o,a9,a9,a9,255)}for(o=0;o<a7;o+=2){c1=a[o]
a4=o+1
if(!(a4<a7))return A.a(a,a4)
b0=(c1&255)<<8|a[a4]&255
if(b0<b){c1=b0*4+3
if(!(c1<c2))return A.a(n,c1)
n[c1]=0}}}c1=b8.c
if(c1===1)b1=B.y
else if(c1===2)b1=B.t
else{if(c1===4)c2=B.z
else c2=c1===16?B.m:B.e
b1=c2}c2=b8.d
if(c2===0&&b8.x!=null&&c1>8)f=4
b2=A.Q(b6,b6,b1,0,B.j,c0,b6,0,c2===2&&b8.x!=null?4:f,c,B.e,b9,!1)
b3=b8.a
b4=b8.b
b8.a=b9
b8.b=c0
b5.e=0
if(b8.r!==0){c1=c0+7>>>3
b5.ca(d,b2,0,0,8,8,b9+7>>>3,c1)
c2=b9+3
b5.ca(d,b2,4,0,8,8,c2>>>3,c1)
c1=c0+3
b5.ca(d,b2,0,4,4,8,c2>>>2,c1>>>3)
c2=b9+1
b5.ca(d,b2,2,0,4,4,c2>>>2,c1>>>2)
c1=c0+1
b5.ca(d,b2,0,2,2,4,c2>>>1,c1>>>2)
b5.ca(d,b2,1,0,2,2,b9>>>1,c1>>>1)
b5.ca(d,b2,0,1,1,2,b9,c0>>>1)}else b5.jy(d,b2)
b8.a=b3
b8.b=b4
c1=b8.at
if(c1!=null)b2.c=new A.cQ(b8.Q,B.aK,c1)
b8=b8.ax
if(b8.a!==0)b2.kh(b8)
return b2},
b6(a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null
if(b.b4(t.D.a(a0))==null)return a
s=b.a
r=s.cx
q=r.length
if(q===0){s=b.ao(0)
s.toString
return s}for(q=t.g,p=a,o=p,n=0;n<s.ch;++n){if(!(n<r.length))return A.a(r,n)
a1=r[n]
m=b.ao(n)
if(m==null)continue
if(o==null||p==null){o=m.e1(m.gaC())
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
j=j===(i==null?0:i)&&a1.d===0&&a1.e===0&&a1.x===B.cg}else j=!1
if(j){l=a1.f
m.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
o.aI(m)
p=m
continue}d=o.x
if(d===$)d=o.x=A.j([],q)
if(!(l<d.length))return A.a(d,l)
p=A.bv(d[l],!1,!1)
c=k.w
if(c===B.ci){l=k.d
j=k.e
i=s.z
if(i==null){i=new Uint8Array(4)
h=new A.cH(i)
i[0]=0
i[1]=0
i[2]=0
i[3]=0
i=h}A.rl(p,!1,i,l,l+k.b-1,j,j+k.c-1)}else if(c===B.cj&&n>1){l=n-2
d=o.x
if(d===$)d=o.x=A.j([],q)
if(!(l>=0&&l<d.length))return A.a(d,l)
j=k.d
i=k.e
h=k.b
g=k.c
p=A.lv(p,d[l],B.aC,g,h,j,i,g,h,j,i)}l=a1.f
p.y=B.b.i((l===0||a1.r===0?0:l/a1.r)*1000)
l=a1.x===B.ch?B.aC:B.aB
p=A.lv(p,m,l,a,a,a1.d,a1.e,a,a,a,a)
o.aI(p)}return o},
c1(a){return this.b6(a,null)},
ca(a4,a5,a6,a7,a8,a9,b0,b1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a1.a,a3=a2.d
if(a3===4)s=2
else if(a3===2)s=3
else{a3=a3===6?4:1
s=a3}r=s*a2.c
q=B.a.j(r+7,3)
p=B.a.j(r*b0+7,3)
o=A.j([null,null],t.ff)
n=A.j([0,0,0,0],t.t)
for(a2=a8>1,m=a8-a6,l=a7,k=0,j=0;k<b1;++k,l+=a9,++a1.e){a3=J.d(a4.a,a4.d++)
if(!(a3>=0&&a3<5))return A.a(B.ar,a3)
i=B.ar[a3]
h=a4.al(p)
a4.d=a4.d+(h.c-h.d)
B.c.h(o,j,h.a2())
if(!(j>=0&&j<2))return A.a(o,j)
g=o[j]
j=1-j
f=o[j]
g.toString
a1.fm(i,q,g,f)
a1.c=a1.b=0
a3=g.length
e=new A.af(g,0,Math.min(a3,a3),0,!0)
for(a3=m<=1,d=a6,c=0;c<b0;++c,d+=a8){a1.fd(e,n)
b=a5.a
b=b==null?null:b.N(d,l,null)
a1.dY(b==null?new A.D():b,n)
if(!a3||a2)for(a=0;a<a8;++a)for(b=l+a,a0=0;a0<m;++a0)a1.dY(a5.ap(d+a0,b),n)}}},
jy(a1,a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=b.a,a0=a.d
if(a0===4)s=2
else if(a0===2)s=3
else{a0=a0===6?4:1
s=a0}r=s*a.c
q=a.a
p=a.b
o=B.a.j(q*r+7,3)
n=B.a.j(r+7,3)
m=A.S(o,0,!1,t.p)
l=A.j([m,m],t.S)
k=A.j([0,0,0,0],t.t)
a=a2.a
j=a.gH(a)
j.D()
for(i=0,h=0;i<p;++i,h=e){a=J.d(a1.a,a1.d++)
if(!(a>=0&&a<5))return A.a(B.ar,a)
g=B.ar[a]
f=a1.al(o)
a1.d=a1.d+(f.c-f.d)
B.c.h(l,h,f.a2())
if(!(h>=0&&h<2))return A.a(l,h)
e=1-h
b.fm(g,n,l[h],l[e])
b.c=b.b=0
a=l[h]
a0=a.length
d=new A.af(a,0,Math.min(a0,a0),0,!0)
for(c=0;c<q;++c){b.fd(d,k)
b.dY(j.gO(),k)
j.D()}}},
fm(a,b,c,d){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e
t.L.a(c)
t.T.a(d)
s=c.length
switch(a.a){case 0:break
case 1:for(r=J.ak(c),q=b;q<s;++q){p=c.length
if(!(q<p))return A.a(c,q)
o=c[q]
n=q-b
if(!(n>=0&&n<p))return A.a(c,n)
r.h(c,q,o+c[n]&255)}break
case 2:for(r=J.ak(c),p=d!=null,q=0;q<s;++q){if(p){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+m&255)}break
case 3:for(r=J.ak(c),p=d!=null,q=0;q<s;++q){if(q<b)l=0
else{o=q-b
if(!(o>=0&&o<c.length))return A.a(c,o)
l=c[o]}if(p){if(!(q<d.length))return A.a(d,q)
m=d[q]}else m=0
if(!(q<c.length))return A.a(c,q)
r.h(c,q,c[q]+B.a.j(l+m,1)&255)}break
case 4:for(r=J.ak(c),p=d==null,o=!p,q=0;q<s;++q){n=q<b
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
bu(a,b){var s,r,q,p,o,n=this
if(b===0)return 0
if(b===8)return a.F()
if(b===16)return a.n()
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
r=B.a.a5(n.b,s)
n.c=s
return r&o},
fd(a,b){var s,r,q=this
t.L.a(b)
s=q.a
r=s.d
switch(r){case 0:B.c.h(b,0,q.bu(a,s.c))
return
case 2:B.c.h(b,0,q.bu(a,s.c))
B.c.h(b,1,q.bu(a,s.c))
B.c.h(b,2,q.bu(a,s.c))
return
case 3:B.c.h(b,0,q.bu(a,s.c))
return
case 4:B.c.h(b,0,q.bu(a,s.c))
B.c.h(b,1,q.bu(a,s.c))
return
case 6:B.c.h(b,0,q.bu(a,s.c))
B.c.h(b,1,q.bu(a,s.c))
B.c.h(b,2,q.bu(a,s.c))
B.c.h(b,3,q.bu(a,s.c))
return}throw A.h(A.m("Invalid color type: "+r+"."))},
dY(a,b){var s,r,q,p,o,n,m,l,k,j
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
a.ac(p,p,p,p!==((q&255)<<24|r&255)>>>0?a.gE():0)
return}a.au(b[0],0,0)
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
if(o!==((q&255)<<8|m&255)||p!==((l&255)<<8|k&255)||n!==((j&255)<<8|s&255)){a.ac(o,p,n,a.gE())
return}}a.au(o,p,n)
return
case 3:a.sT(b[0])
return
case 4:a.au(b[0],b[1],0)
return
case 6:a.ac(b[0],b[1],b[2],b[3])
return}throw A.h(A.m("Invalid color type: "+r+"."))}}
A.hj.prototype={
a6(){return"PngFilter."+this.b}}
A.hi.prototype={
aI(a){var s,r,q,p,o,n,m,l,k,j=this,i=8192
if(!(a.gaY()&&a.gL()!==B.m))s=a.gaJ()<8&&!a.gaK()&&a.gaC()>1
else s=!0
if(s)a=a.aM(B.e)
if(j.w==null){s=A.aa(!0,i)
j.w=s
s.a7(A.j([137,80,78,71,13,10,26,10],t.t))
r=A.aa(!0,i)
r.I(a.gS())
r.I(a.gK())
r.p(a.gaJ())
if(a.gaK())s=3
else if(a.gaC()===1)s=0
else if(a.gaC()===2)s=4
else s=a.gaC()===3?2:6
r.p(s)
r.p(0)
r.p(0)
r.p(0)
s=j.w
s.toString
j.bv(s,"IHDR",J.E(B.d.gB(r.c),0,r.a))
s=a.c
if(s!=null){r=A.aa(!0,i)
r.a7(new A.al(s.a))
r.p(0)
r.p(0)
r.a7(s.km())
s=j.w
s.toString
j.bv(s,"iCCP",J.E(B.d.gB(r.c),0,r.a))}if(a.gaK()){s=j.a
if(s!=null){s=s.a
s===$&&A.b("palette")
j.fC(s)}else{s=a.a
s=s==null?null:s.gM()
s.toString
j.fC(s)}}if(j.r){r=A.aa(!0,i)
s=j.e
s===$&&A.b("_frames")
r.I(s)
r.I(j.c)
s=j.w
s.toString
j.bv(s,"acTL",J.E(B.d.gB(r.c),0,r.a))}}q=a.gaK()?1:a.gaC()
p=a.gL()===B.m?2:1
s=a.gS()
o=a.gK()
n=a.gK()
m=new Uint8Array(s*o*q*p+n)
j.iS(0,a,m)
l=B.b8.fW(t.L.a(m),null)
s=a.d
if(s!=null)for(s=new A.O(s,s.r,s.e,A.l(s).q("O<1>"));s.D();){o=s.d
n=a.d.l(0,o)
n.toString
r=new A.hd(!0,new Uint8Array(8192))
r.a7(B.b7.cq(o))
r.p(0)
r.a7(B.b7.cq(n))
o=j.w
o.toString
j.bv(o,"tEXt",J.E(B.d.gB(r.c),0,r.a))}if(j.r){r=A.aa(!0,i)
r.I(j.f)
r.I(a.gS())
r.I(a.gK())
r.I(0)
r.I(0)
r.a0(a.y)
r.a0(1000)
r.p(1)
r.p(0)
s=j.w
s.toString
j.bv(s,"fcTL",J.E(B.d.gB(r.c),0,r.a));++j.f}if(j.f<=1){s=j.w
s.toString
j.bv(s,"IDAT",l)}else{k=A.aa(!0,i)
k.I(j.f)
k.a7(l)
s=j.w
s.toString
j.bv(s,"fdAT",J.E(B.d.gB(k.c),0,k.a));++j.f}},
dk(){var s,r=this,q=r.w
if(q==null)return null
r.bv(q,"IEND",A.j([],t.t))
r.f=0
q=r.w
s=J.E(B.d.gB(q.c),0,q.a)
r.w=null
return s},
bQ(a){var s,r,q,p,o,n=this,m=a.gah().length
if(m<=1){n.e=1
n.r=!1
n.aI(a)}else{m=a.gah().length
n.e=m
n.r=m>1
n.c=a.r
if(a.gaK()){s=n.a=A.kV(a,256,10)
for(m=a.gah(),r=m.length,q=0;q<m.length;m.length===r||(0,A.a1)(m),++q){p=m[q]
if(p!==a){s.f2(p)
s.eO()
s.f_()
s.eE()}}}for(m=a.gah(),r=m.length,q=0;q<m.length;m.length===r||(0,A.a1)(m),++q){p=m[q]
o=n.a
if(o!=null)n.aI(o.e8(p))
else n.aI(p)}}m=n.dk()
m.toString
return m},
fC(a){var s,r,q,p=this
if(a.gL()===B.e&&a.b===3&&a.a===256){s=p.w
s.toString
p.bv(s,"PLTE",J.E(a.gB(a),0,null))}else{s=a.a
r=A.aa(!0,s*3)
for(q=0;q<s;++q){r.p(B.b.i(a.aX(q)))
r.p(B.b.i(a.aW(q)))
r.p(B.b.i(a.aV(q)))}s=p.w
s.toString
p.bv(s,"PLTE",J.E(B.d.gB(r.c),0,r.a))}if(a.b===4){s=a.a
r=A.aa(!0,s)
for(q=0;q<s;++q)r.p(B.b.i(a.b3(q)))
s=p.w
s.toString
p.bv(s,"tRNS",J.E(B.d.gB(r.c),0,r.a))}},
bv(a,b,c){t.L.a(c)
a.I(c.length)
a.a7(new A.al(b))
a.a7(c)
a.I(A.bj(c,A.bj(new A.al(b),0)))},
iS(a,b,c){var s,r,q=this,p=b.gaK()?B.kq:B.kr,o=b.gB(0),n=b.a.gbe(),m=b.gaK()?1:b.gaC(),l=B.a.j(m*b.gaJ()+7,3),k=b.gaJ()+7>>>3,j=p.a,i=J.b7(o),h=0,g=0,f=null,e=0
for(;;){s=b.a
s=s==null?null:s.b
if(!(e<(s==null?0:s)))break
r=i.cG(o,g,n)
g+=n
switch(j){case 1:h=q.iX(r,k,l,c,h)
break
case 2:h=q.iY(r,f,k,c,h)
break
case 3:h=q.iT(r,f,k,l,c,h)
break
case 4:h=q.iV(r,f,k,l,c,h)
break
default:h=q.iU(r,k,c,h)
break}++e
f=r}},
ft(a,b,c,d,e){var s,r,q,p;--a
for(s=b.length,r=d.$flags|0;a>=0;e=q){q=e+1
p=c+a
if(!(p<s))return A.a(b,p)
p=b[p]
r&2&&A.c(d)
if(!(e<d.length))return A.a(d,e)
d[e]=p;--a}return e},
iU(a,b,c,d){var s,r,q,p,o=d+1
c.$flags&2&&A.c(c)
s=c.length
if(!(d<s))return A.a(c,d)
c[d]=0
r=a.length
if(b===1)for(d=o,q=0;q<r;++q,d=o){o=d+1
p=a[q]
if(!(d<s))return A.a(c,d)
c[d]=p}else for(d=o,q=0;q<r;q+=b)d=this.ft(b,a,q,c,d)
return d},
iX(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j=e+1
d.$flags&2&&A.c(d)
s=d.length
if(!(e<s))return A.a(d,e)
d[e]=1
for(e=j,r=0;r<c;r+=b)e=this.ft(b,a,r,d,e)
q=a.length
for(p=b-1,o=d.$flags|0,r=c;r<q;r+=b)for(n=p,m=0;m<b;++m,--n,e=j){j=e+1
l=r+n
if(!(l>=0&&l<q))return A.a(a,l)
k=a[l]
l-=c
if(!(l>=0))return A.a(a,l)
l=a[l]
o&2&&A.c(d)
if(!(e>=0&&e<s))return A.a(d,e)
d[e]=k-l&255}return e},
iY(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i=e+1
d.$flags&2&&A.c(d)
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
p&2&&A.c(d)
if(!(e>=0&&e<s))return A.a(d,e)
d[e]=k-j&255}return e},
iT(a,b,c,d,e,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=a0+1
e.$flags&2&&A.c(e)
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
p&2&&A.c(e)
if(!(a0>=0&&a0<s))return A.a(e,a0)
e[a0]=g-(j+h>>>1)}return a0},
jl(a,b,c){var s=a+b-c,r=s>a?s-a:a-s,q=s>b?s-b:b-s,p=s>c?s-c:c-s
if(r<=q&&r<=p)return a
else if(q<=p)return b
return c},
iV(a,b,a0,a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=a3+1
a2.$flags&2&&A.c(a2)
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
d=this.jl(i,g,f)
c=a3+1
p&2&&A.c(a2)
if(!(a3>=0&&a3<s))return A.a(a2,a3)
a2[a3]=e-d&255}return a3}}
A.bT.prototype={
a6(){return"PnmFormat."+this.b}}
A.bU.prototype={}
A.iZ.prototype={
cr(a){var s
this.b=A.v(a,!1,null,0)
s=this.d8()
if(s==="P1"||s==="P2"||s==="P5"||s==="P3"||s==="P6")return!0
return!1},
b6(a,b){if(this.b4(a)==null)return null
return this.ao(0)},
b4(a){var s,r,q=this
q.b=A.v(a,!1,null,0)
s=q.d8()
if(s==="P1"){r=q.a=new A.bU(B.a6)
r.e=B.ck}else if(s==="P2"){r=q.a=new A.bU(B.a6)
r.e=B.cl}else if(s==="P5"){r=q.a=new A.bU(B.a6)
r.e=B.aW}else if(s==="P3"){r=q.a=new A.bU(B.a6)
r.e=B.cm}else if(s==="P6"){r=q.a=new A.bU(B.a6)
r.e=B.aX}else return q.b=null
r.a=q.cC()
r=q.a
r.toString
r.b=q.cC()
r=q.a
if(r.a===0||r.b===0)return q.a=q.b=null
return r},
ao(a){var s,r,q,p,o,n=this,m=null,l=n.a
if(l==null)return m
s=l.e
if(s===B.ck){s=l.a
r=A.Q(m,m,B.y,0,B.j,l.b,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.D();){q=l.gO()
if(n.d8()==="1")q.au(1,1,1)
else q.au(0,0,0)}return r}else if(s===B.cl||s===B.aW){p=n.cC()
if(p===0)return m
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.fY(p),0,B.j,l,m,0,1,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.D();){q=l.gO()
o=n.dc(n.a.e,p)
q.au(o,o,o)}return r}else if(s===B.cm||s===B.aX){p=n.cC()
if(p===0)return m
l=n.a
s=l.a
l=l.b
r=A.Q(m,m,n.fY(p),0,B.j,l,m,0,3,m,B.e,s,!1)
for(l=r.a,l=l.gH(l);l.D();)l.gO().au(n.dc(n.a.e,p),n.dc(n.a.e,p),n.dc(n.a.e,p))
return r}return m},
fY(a){if(a>255)return B.m
if(a>15)return B.e
if(a>3)return B.z
if(a>1)return B.t
return B.y},
dc(a,b){if(a===B.aW||a===B.aX)return this.b.F()
return this.cC()},
cC(){var s,r,q=this.d8()
if(J.bm(q)===0)return 0
try{s=A.rC(q)
return s}catch(r){return 0}},
d8(){var s,r,q,p,o=this.b
if(o==null)return""
s=this.c
if(s.length!==0)return B.c.h7(s,0)
r=B.n.hd(o.kU())
if(r.length===0)return""
while(B.n.ef(r,"#"))r=B.n.hd(this.b.h5(70))
o=t.cc
q=A.w(new A.eN(A.j(r.split(" "),t.s),t.bB.a(new A.j_()),o),o.q("e.E"))
for(o=q.length,p=0;p<o;++p)if(B.n.ef(q[p],"#")){B.c.sv(q,p)
break}B.c.fD(s,q)
if(s.length===0)return""
return B.c.h7(s,0)}}
A.j_.prototype={
$1(a){return A.bG(a)!==""},
$S:23}
A.hm.prototype={
skF(a){t.T.a(a)},
shr(a){t.T.a(a)},
skW(a){t.T.a(a)},
skX(a){t.T.a(a)}}
A.hn.prototype={
sbO(a){t.T.a(a)},
sbS(a){t.T.a(a)}}
A.bf.prototype={}
A.hq.prototype={
sbO(a){t.T.a(a)},
sbS(a){t.T.a(a)}}
A.hr.prototype={
sbO(a){t.T.a(a)},
sbS(a){t.T.a(a)}}
A.ht.prototype={
sbO(a){t.T.a(a)},
sbS(a){t.T.a(a)}}
A.hu.prototype={
sbO(a){t.T.a(a)},
sbS(a){t.T.a(a)}}
A.eu.prototype={}
A.hs.prototype={}
A.j0.prototype={
hO(a){var s,r,q,p,o=this
a.n()
a.n()
a.n()
a.n()
s=B.a.X(a.c-a.d,8)
if(s>0){o.e=new Uint16Array(s)
o.f=new Uint16Array(s)
o.r=new Uint16Array(s)
o.w=new Uint16Array(s)
for(r=0;r<s;++r){q=o.e
p=a.n()
q.$flags&2&&A.c(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.f
q=a.n()
p.$flags&2&&A.c(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q
q=o.r
p=a.n()
q.$flags&2&&A.c(q)
if(!(r<q.length))return A.a(q,r)
q[r]=p
p=o.w
q=a.n()
p.$flags&2&&A.c(p)
if(!(r<p.length))return A.a(p,r)
p[r]=q}}}}
A.cq.prototype={
h4(a,b,c,d,e,f,g){if(a.c-a.d<2)return
if(e==null)e=a.n()
switch(e){case 0:d.toString
this.jW(a,b,c,d)
break
case 1:if(f==null)f=this.jT(a,c)
d.toString
this.jV(a,b,c,d,f,g)
break
default:throw A.h(A.m("Unsupported compression: "+e))}},
kT(a,b,c,d){return this.h4(a,b,c,d,null,null,0)},
jT(a,b){var s,r,q=new Uint16Array(b)
for(s=0;s<b;++s){r=a.n()
if(!(s<b))return A.a(q,s)
q[s]=r}return q},
jW(a,b,c,d){var s,r=b*c
if(d===16)r*=2
if(r>a.c-a.d){s=new Uint8Array(r)
this.c=s
B.d.aO(s,0,r,255)
return}this.c=a.aj(r).a2()},
jV(a,b,c,d,e,f){var s,r,q,p,o,n,m,l=b*c
if(d===16)l*=2
s=new Uint8Array(l)
this.c=s
r=f*c
q=e.length
if(r>=q){B.d.aO(s,0,l,255)
return}for(p=0,o=0;o<c;++o,r=n){n=r+1
if(!(r>=0&&r<q))return A.a(e,r)
m=a.al(e[r])
a.d=a.d+(m.c-m.d)
s=this.c
s.toString
this.iy(m,s,p)
p+=b}},
iy(a,b,c){var s,r,q,p,o,n,m,l
for(s=a.c,r=b.length;q=a.d,q<s;){p=a.a
a.d=q+1
q=J.d(p,q)
p=$.ap()
p.$flags&2&&A.c(p)
p[0]=q
q=$.ay()
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
q&2&&A.c(b)
if(!(c>=0&&c<r))return A.a(b,c)
b[c]=n}}else{++o
if(c+o>r)o=r-c
o=Math.min(o,s-a.d)
for(m=0;m<o;++m,c=l){l=c+1
q=J.d(a.a,a.d++)
b.$flags&2&&A.c(b)
if(!(c>=0&&c<r))return A.a(b,c)
b[c]=q}}}}}
A.b2.prototype={
a6(){return"PsdColorMode."+this.b}}
A.ho.prototype={
hP(a){var s,r,q=this
q.as=A.v(a,!0,null,0)
q.jB()
if(q.c!==943870035)return
s=q.as.k()
q.as.aj(s)
s=q.as.k()
q.at=q.as.aj(s)
s=q.as.k()
q.ax=q.as.aj(s)
r=q.as
q.ay=r.aj(r.c-r.d)},
bP(){var s,r=this
if(r.c===943870035){s=r.as
s===$&&A.b("_input")
s=s==null}else s=!0
if(s)return!1
r.jR()
r.jS()
r.jU()
r.ay=r.ax=r.at=r.as=null
return!0},
fT(){if(!this.bP())return null
return this.kZ()},
kZ(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.y
if(a1!=null)return a1
a1=a.a
a1=A.Q(a0,a0,B.e,0,B.j,a.b,a0,0,4,a0,B.e,a1,!1)
a.y=a1
a1.kj(0)
s=0
for(;;){a1=a.w
a1===$&&A.b("layers")
if(!(s<a1.length))break
c$0:{r=a1[s]
a1=r.y
a1===$&&A.b("flags")
if((a1&2)!==0)break c$0
a1=r.w
a1===$&&A.b("opacity")
q=a1/255
p=r.r
o=r.cx
a1=r.a
a1.toString
n=a1
m=0
for(;;){a1=r.f
a1===$&&A.b("height")
if(!(m<a1))break
a1=r.a
a1.toString
l=a1+m
k=r.b
a1=n>=0
j=0
for(;;){i=r.e
i===$&&A.b("width")
if(!(j<i))break
i=o.a
h=i==null?a0:i.N(j,m,a0)
if(h==null)h=new A.D()
g=B.b.i(h.gm())
f=B.b.i(h.gt())
e=B.b.i(h.gu())
d=B.b.i(h.gA())
k.toString
if(k>=0&&k<a.a&&a1&&n<a.b){i=r.b
i.toString
c=a.y.a
b=c==null?a0:c.N(i+j,l,a0)
if(b==null)b=new A.D()
a.hY(B.b.i(b.gm()),B.b.i(b.gt()),B.b.i(b.gu()),B.b.i(b.gA()),g,f,e,d,p,q,b)}++j;++k}++m;++n}}++s}a1=a.y
a1.toString
return a1},
hY(a,b,c,d,e,f,g,h,i,j,k){var s,r,q,p,o,n=h/255*j
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
case 1768188278:p=A.j2(a,e)
q=A.j2(b,f)
r=A.j2(c,g)
s=h
break
case 1818391150:p=A.j4(a,e)
q=A.j4(b,f)
r=A.j4(c,g)
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
case 1935897198:p=A.l9(a,e)
q=A.l9(b,f)
r=A.l9(c,g)
s=h
break
case 1684633120:p=A.j3(a,e)
q=A.j3(b,f)
r=A.j3(c,g)
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
case 1870030194:p=A.l7(a,e,d,h)
q=A.l7(b,f,d,h)
r=A.l7(c,g,d,h)
s=h
break
case 1934387572:p=A.la(a,e)
q=A.la(b,f)
r=A.la(c,g)
s=h
break
case 1749838196:p=A.l5(a,e)
q=A.l5(b,f)
r=A.l5(c,g)
s=h
break
case 1984719220:p=A.lb(a,e)
q=A.lb(b,f)
r=A.lb(c,g)
s=h
break
case 1816947060:p=A.l6(a,e)
q=A.l6(b,f)
r=A.l6(c,g)
s=h
break
case 1884055924:p=A.l8(a,e)
q=A.l8(b,f)
r=A.l8(c,g)
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
case 1936553316:p=A.l4(a,e)
q=A.l4(b,f)
r=A.l4(c,g)
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
k.sm(B.b.i(a*o+p*n))
k.st(B.b.i(b*o+q*n))
k.su(B.b.i(c*o+r*n))
k.sA(B.b.i(d*o+s*n))},
jB(){var s,r,q=this,p=q.as
p===$&&A.b("_input")
q.c=p.k()
p=q.as.n()
q.d=p
if(p!==1){q.c=0
return}s=q.as.aj(6)
for(r=0;r<6;++r)if(J.d(s.a,s.d+r)!==0){q.c=0
return}q.e=q.as.n()
q.b=q.as.k()
q.a=q.as.k()
q.f=q.as.n()
p=q.as.n()
if(!(p<8))return A.a(B.cb,p)
q.r=B.cb[p]},
jR(){var s,r,q,p,o,n,m=this,l=m.at
l.d=l.b
for(l=m.z;s=m.at,s.d<s.c;){r=s.k()
q=m.at.n()
s=m.at
p=J.d(s.a,s.d++)
m.at.ak(p)
if((p&1)===0)++m.at.d
p=m.at.k()
s=m.at
o=s.al(p)
n=s.d+(o.c-o.d)
s.d=n
if((p&1)===1)s.d=n+1
if(r===943868237)l.h(0,q,new A.hp())}},
jS(){var s,r,q,p,o,n,m,l,k,j=this,i=j.ax
i.d=i.b
s=i.k()
if((s&1)!==0)++s
r=j.ax.aj(s)
i=t.cE
j.w=t.dl.a(A.j([],i))
if(s>0){q=r.n()
p=$.ao()
p.$flags&2&&A.c(p)
p[0]=q
q=$.ax()
if(0>=q.length)return A.a(q,0)
o=q[0]
if(o<0)o=-o
for(q=t.N,p=t.hf,n=t.af,m=0;m<o;++m){l=new A.et(A.I(q,p),A.j([],i),A.j([],n))
l.hQ(r)
B.c.G(j.w,l)}}for(m=0;i=j.w,m<i.length;++m)i[m].kQ(r,j)
s=j.ax.k()
k=j.ax.aj(s)
if(s>0){k.n()
k.n()
k.n()
k.n()
k.n()
k.n()
k.F()}},
jU(){var s,r,q,p,o,n,m=this,l="channels",k=m.ay
k.d=k.b
s=k.n()
if(s===1){k=m.b
r=m.e
r===$&&A.b(l)
q=k*r
p=new Uint16Array(q)
for(o=0;o<q;++o)p[o]=m.ay.n()}else p=null
m.x=t.eS.a(A.j([],t.h0))
o=0
for(;;){k=m.e
k===$&&A.b(l)
if(!(o<k))break
k=m.x
r=m.ay
r.toString
n=o===3?-1:o
n=new A.cq(n)
n.h4(r,m.a,m.b,m.f,s,p,o)
B.c.G(k,n);++o}m.y=A.mw(m.r,m.f,m.a,m.b,m.x)},
$iK:1}
A.hp.prototype={}
A.et.prototype={
hQ(a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=a4.k(),a3=$.N()
a3.$flags&2&&A.c(a3)
a3[0]=a2
a2=$.a6()
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
s=a4.n()
for(r=0;r<s;++r){a2=a4.n()
a3=$.ao()
a3.$flags&2&&A.c(a3)
a3[0]=a2
a2=$.ax()
if(0>=a2.length)return A.a(a2,0)
q=a2[0]
a4.k()
B.c.G(a1.as,new A.cq(q))}p=a4.k()
if(p!==943868237)throw A.h(A.m("Invalid PSD layer signature: "+B.a.dn(p,16)))
a1.r=a4.k()
a1.w=a4.F()
a4.F()
a1.y=a4.F()
if(a4.F()!==0)throw A.h(A.m("Invalid PSD layer data"))
o=a4.k()
n=a4.aj(o)
if(o>0){o=n.k()
if(o>0){m=n.aj(o)
a2=m.d
m.k()
m.k()
m.k()
m.k()
m.F()
m.F()
if(m.c-a2===20)m.d+=2
else{m.F()
m.F()
m.k()
m.k()
m.k()
m.k()}}o=n.k()
if(o>0)new A.j0().hO(n.aj(o))
o=n.F()
n.ak(o)
l=4-B.a.a8(o,4)-1
if(l>0)n.d+=l
for(a2=n.c,a3=a1.ay,k=a1.cy,j=t.t,i=t.g0;n.d<a2;){p=n.k()
if(p!==943868237)throw A.h(A.m("PSD invalid signature for layer additional data: "+B.a.dn(p,16)))
h=n.ak(4)
o=n.k()
g=n.al(o)
f=n.d+(g.c-g.d)
n.d=f
if((o&1)===1)n.d=f+1
a3.h(0,h,A.oU(h,g))
if(h==="lrFX"){e=A.p(i.a(a3.l(0,"lrFX")).b,null,0)
e.n()
d=e.n()
for(c=0;c<d;++c){e.ak(4)
b=e.ak(4)
a=e.k()
if(b==="dsdw"){a0=new A.hn()
B.c.G(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbO(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.ak(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbS(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else if(b==="isdw"){a0=new A.hr()
B.c.G(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.k()
a0.sbO(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.ak(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbS(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else if(b==="oglw"){a0=new A.ht()
B.c.G(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbO(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.ak(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2)a0.sbS(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else if(b==="iglw"){a0=new A.hq()
B.c.G(k,a0)
a0.a=e.k()
e.k()
e.k()
a0.sbO(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
e.ak(8)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){J.d(e.a,e.d++)
a0.sbS(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}}else if(b==="bevl"){a0=new A.hm()
B.c.G(k,a0)
a0.a=e.k()
e.k()
e.k()
e.k()
e.ak(8)
e.ak(8)
a0.skF(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
a0.shr(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
J.d(e.a,e.d++)
if(a0.a===2){a0.skW(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
a0.skX(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}}else if(b==="sofi"){a0=new A.hu()
B.c.G(k,a0)
a0.a=e.k()
e.ak(4)
a0.sbO(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))
J.d(e.a,e.d++)
J.d(e.a,e.d++)
a0.sbS(A.j([e.n(),e.n(),e.n(),e.n(),e.n()],j))}else e.d+=a}}}}},
kQ(a,b){var s,r,q,p,o,n=this,m=0
for(;;){s=n.as
s===$&&A.b("channels")
if(!(m<s.length))break
s=s[m]
r=n.e
r===$&&A.b("width")
q=n.f
q===$&&A.b("height")
s.kT(a,r,q,b.f);++m}r=b.r
q=b.f
p=n.e
p===$&&A.b("width")
o=n.f
o===$&&A.b("height")
n.cx=A.mw(r,q,p,o,s)}}
A.da.prototype={}
A.j1.prototype={
b6(a,b){var s,r,q,p=null,o=A.mv(a)
this.a=o
s=1
if(s===1){o=o.fT()
return o}for(r=p,q=0;q<s;++q){o=this.a
b=o==null?p:o.fT()
if(b==null)continue
if(r==null){b.w=B.bd
r=b}else r.aI(b)}return r}}
A.hv.prototype={}
A.aR.prototype={
cK(){return new A.aR(this.a,this.b,this.c)},
eb(a){var s,r=this
t.h.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s},
ea(a){var s,r=this
t.h.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s}}
A.L.prototype={
cK(){var s=this
return new A.L(s.a,s.b,s.c,s.d)},
aZ(a,b){var s=this
return new A.L(s.a+b.a,s.b+b.b,s.c+b.c,s.d+b.d)},
eg(a,b){var s=this
return new A.L(s.a-b.a,s.b-b.b,s.c-b.c,s.d-b.d)},
fU(a){var s=this
return s.a*a.a+s.b*a.b+s.c*a.c+s.d*a.d},
eb(a){var s,r=this
t.R.a(a)
s=a.a
if(s<r.a)r.a=s
s=a.b
if(s<r.b)r.b=s
s=a.c
if(s<r.c)r.c=s
s=a.d
if(s<r.d)r.d=s},
ea(a){var s,r=this
t.R.a(a)
s=a.a
if(s>r.a)r.a=s
s=a.b
if(s>r.b)r.b=s
s=a.c
if(s>r.c)r.c=s
s=a.d
if(s>r.d)r.d=s}}
A.dd.prototype={
G(a,b){this.$ti.c.a(b)
this.a.eb(b)
this.b.ea(b)}}
A.db.prototype={$iK:1,
gK(){return this.b}}
A.dc.prototype={$iK:1,
gK(){return this.f}}
A.ev.prototype={$iK:1,
gK(){return this.b}}
A.a3.prototype={
scH(a){var s=this.a,r=this.b+1
s.$flags&2&&A.c(s)
if(!(r<s.length))return A.a(s,r)
s[r]=a},
bT(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.q,s)
return new A.aR(B.q[s],B.q[q>>>4&31],B.x[q&15])}else return new A.aR(B.x[q>>>7&15],B.x[q>>>3&15],B.av[q&7])},
bV(){var s,r=this.e,q=this.d
if(r){s=q>>>9
if(!(s<32))return A.a(B.q,s)
return new A.L(B.q[s],B.q[q>>>4&31],B.x[q&15],255)}else return new A.L(B.x[q>>>7&15],B.x[q>>>3&15],B.av[q&7],B.av[q>>>11&7])},
bU(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.q,s)
return new A.aR(B.q[s],B.q[q>>>5&31],B.q[q&31])}else return new A.aR(B.x[q>>>8&15],B.x[q>>>4&15],B.x[q&15])},
bW(){var s,r=this.r,q=this.f
if(r){s=q>>>10
if(!(s<32))return A.a(B.q,s)
return new A.L(B.q[s],B.q[q>>>5&31],B.q[q&31],255)}else return new A.L(B.x[q>>>8&15],B.x[q>>>4&15],B.x[q&15],B.av[q>>>12&7])},
aH(){var s=this,r=s.c?1:0,q=s.d,p=s.e?1:0,o=s.f,n=s.r?1:0
return(r|(q&16383)<<1|p<<15|(o&32767)<<16|n<<31)>>>0},
aA(){var s,r=this,q=r.a,p=r.b+1
if(!(p<q.length))return A.a(q,p)
s=q[p]
r.c=(s&1)===1
r.scH(r.aH())
r.d=s>>>1&16383
r.scH(r.aH())
r.e=(s>>>15&1)===1
r.scH(r.aH())
r.f=s>>>16&32767
r.scH(r.aH())
r.r=(s>>>31&1)===1
r.scH(r.aH())}}
A.j5.prototype={
b4(a){var s,r=this,q=a.length,p=q-(q>>>1&1431655765)>>>0
p=(p&858993459)+(p>>>2&858993459)
if((p+(p>>>4)>>>0&252645135)*16843009>>>0>>>24===1){s=r.ij(a)
if(s!=null){r.a=a
return r.b=s}}s=r.ix(a)
if(s!=null){r.a=a
return r.b=s}s=r.iv(a)
if(s!=null){r.a=a
return r.b=s}return null},
ix(a){var s,r,q=A.v(a,!1,null,0)
if(q.k()!==52)return null
if(q.k()!==55727696)return null
s=A.j([0,0,0,0],t.t)
r=new A.dc(s)
q.k()
r.b=q.k()
B.c.h(s,0,q.F())
B.c.h(s,1,q.F())
B.c.h(s,2,q.F())
B.c.h(s,3,q.F())
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
iv(a){var s,r,q=A.v(a,!1,null,0)
if(q.k()!==52)return null
s=new A.db()
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
ij(a){var s,r,q,p,o,n,m=null,l=a.length,k=A.v(a,!1,m,0)
if(k.k()!==0)return m
s=new A.ev()
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
ao(a){var s,r,q=this,p=q.b
if(p==null||q.a==null)return null
if(p instanceof A.ev){p=p.a
s=q.b.gK()
r=q.a
r.toString
return q.dD(p,s,r)}else if(p instanceof A.db){p=q.a
p.toString
return q.iu(p)}else if(p instanceof A.dc){p=q.a
p.toString
return q.iw(p)}return null},
b6(a,b){if(this.b4(a)==null)return null
return this.ao(0)},
iu(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=a.length
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
switch(s.d&255){case 16:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
l=J.d(r.a,r.d++)
k=J.d(r.a,r.d++)
m.sm(k&240)
m.st((k&15)<<4)
m.su(l&240)
m.sA((l&15)<<4)}return n
case 17:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
j=r.n()
i=(j&1)!==0?255:0
m.sm(j>>>8&248)
m.st(j>>>3&248)
m.su((j&62)<<2)
m.sA(i)}return n
case 18:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
m.sm(J.d(r.a,r.d++))
m.st(J.d(r.a,r.d++))
m.su(J.d(r.a,r.d++))
m.sA(J.d(r.a,r.d++))}return n
case 19:n=A.Q(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
j=r.n()
m.sm(j>>>8&248)
m.st(j>>>3&252)
m.su((j&31)<<3)}return n
case 20:n=A.Q(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
j=r.n()
m.sm((j&31)<<3)
m.st(j>>>2&248)
m.su(j>>>7&248)}return n
case 21:n=A.Q(f,f,B.e,0,B.j,o,f,0,3,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
m.sm(J.d(r.a,r.d++))
m.st(J.d(r.a,r.d++))
m.su(J.d(r.a,r.d++))}return n
case 22:n=A.Q(f,f,B.e,0,B.j,o,f,0,1,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();)s.gO().sm(J.d(r.a,r.d++))
return n
case 23:n=A.Q(f,f,B.e,0,B.j,o,f,0,4,f,B.e,p,!1)
for(s=n.a,s=s.gH(s);s.D();){m=s.gO()
i=J.d(r.a,r.d++)
h=J.d(r.a,r.d++)
m.sm(h)
m.st(h)
m.su(h)
m.sA(i)}return n
case 24:return f
case 25:return s.y===0?g.eL(p,o,r.a2()):g.dD(p,o,r.a2())}return f},
iw(a){var s,r=this.b
if(!(r instanceof A.dc))return null
s=A.v(a,!1,null,0)
s.d=(s.d+=52)+r.Q
if(r.c[0]===0)switch(r.b){case 2:return this.eL(r.r,r.f,s.a2())
case 3:return this.dD(r.r,r.f,s.a2())}return null},
eL(e4,e5,e6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1,d2,d3,d4=null,d5=A.Q(d4,d4,B.e,0,B.j,e5,d4,0,3,d4,B.e,e4,!1),d6=e4/4|0,d7=d6-1,d8=J.W(B.d.gB(e6),0,null),d9=new A.a3(d8),e0=new A.a3(J.W(B.d.gB(e6),0,null)),e1=new A.a3(J.W(B.d.gB(e6),0,null)),e2=new A.a3(J.W(B.d.gB(e6),0,null)),e3=new A.a3(J.W(B.d.gB(e6),0,null))
for(s=d8.length,r=0,q=0;r<d6;++r,q+=4)for(p=0,o=0;p<d6;++p,o+=4){d9.b=A.a5(p,r)<<1>>>0
d9.aA()
n=d9.b
if(!(n<s))return A.a(d8,n)
m=d8[n]
l=d9.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&d7)>>>0
h=(i+1&d7)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&d7)>>>0
e=(f+1&d7)>>>0
e0.b=A.a5(f,i)<<1>>>0
e0.aA()
e1.b=A.a5(e,i)<<1>>>0
e1.aA()
e2.b=A.a5(f,h)<<1>>>0
e2.aA()
e3.b=A.a5(e,h)<<1>>>0
e3.aA()
d=e0.bT()
if(!(k>=0&&k<16))return A.a(B.h,k)
c=B.h[k][0]
b=d.a
a=d.b
d=d.c
a0=e1.bT()
a1=B.h[k][1]
a2=a0.a
a3=a0.b
a0=a0.c
a4=e2.bT()
a5=B.h[k][2]
a6=a4.a
a7=a4.b
a4=a4.c
a8=e3.bT()
a9=B.h[k][3]
b0=a8.a
b1=a8.b
a8=a8.c
b2=e0.bU()
b3=B.h[k][0]
b4=b2.a
b5=b2.b
b2=b2.c
b6=e1.bU()
b7=B.h[k][1]
b8=b6.a
b9=b6.b
b6=b6.c
c0=e2.bU()
c1=B.h[k][2]
c2=c0.a
c3=c0.b
c0=c0.c
c4=e3.bU()
c5=B.h[k][3]
c6=c4.a
c7=c4.b
c4=c4.c
c8=B.bX[l+m&3]
c9=c8[0]
d0=c8[1]
d1=B.a.j((b*c+a2*a1+a6*a5+b0*a9)*c9+(b4*b3+b8*b7+c2*c1+c6*c5)*d0,7)
d2=B.a.j((a*c+a3*a1+a7*a5+b1*a9)*c9+(b5*b3+b9*b7+c3*c1+c7*c5)*d0,7)
d3=B.a.j((d*c+a0*a1+a4*a5+a8*a9)*c9+(b2*b3+b6*b7+c0*c1+c4*c5)*d0,7)
d0=d5.a
if(d0!=null)d0.Y(g+o,n,d1,d2,d3)
m=m>>>2;++k}}}return d5},
dD(c0,c1,c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=null,b1=A.Q(b0,b0,B.e,0,B.j,c1,b0,0,4,b0,B.e,c0,!1),b2=c0/4|0,b3=b2-1,b4=J.W(B.d.gB(c2),0,null),b5=new A.a3(b4),b6=new A.a3(J.W(B.d.gB(c2),0,null)),b7=new A.a3(J.W(B.d.gB(c2),0,null)),b8=new A.a3(J.W(B.d.gB(c2),0,null)),b9=new A.a3(J.W(B.d.gB(c2),0,null))
for(s=b4.length,r=0,q=0;r<b2;++r,q+=4)for(p=0,o=0;p<b2;++p,o+=4){b5.b=A.a5(p,r)<<1>>>0
b5.aA()
n=b5.b
if(!(n<s))return A.a(b4,n)
m=b4[n]
l=b5.c?4:0
for(k=0,j=0;j<4;++j){i=(r+(j<2?-1:0)&b3)>>>0
h=(i+1&b3)>>>0
for(n=j+q,g=0;g<4;++g){f=(p+(g<2?-1:0)&b3)>>>0
e=(f+1&b3)>>>0
b6.b=A.a5(f,i)<<1>>>0
b6.aA()
b7.b=A.a5(e,i)<<1>>>0
b7.aA()
b8.b=A.a5(f,h)<<1>>>0
b8.aA()
b9.b=A.a5(e,h)<<1>>>0
b9.aA()
d=b6.bV()
if(!(k>=0&&k<16))return A.a(B.h,k)
c=B.h[k][0]
b=d.a
a=d.b
a0=d.c
d=d.d
a1=b7.bV()
a2=B.h[k][1]
a2=new A.L(b*c,a*c,a0*c,d*c).aZ(0,new A.L(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a1=b8.bV()
c=B.h[k][2]
c=a2.aZ(0,new A.L(a1.a*c,a1.b*c,a1.c*c,a1.d*c))
a1=b9.bV()
a2=B.h[k][3]
a3=c.aZ(0,new A.L(a1.a*a2,a1.b*a2,a1.c*a2,a1.d*a2))
a2=b6.bW()
a1=B.h[k][0]
c=a2.a
d=a2.b
a0=a2.c
a2=a2.d
a=b7.bW()
b=B.h[k][1]
b=new A.L(c*a1,d*a1,a0*a1,a2*a1).aZ(0,new A.L(a.a*b,a.b*b,a.c*b,a.d*b))
a=b8.bW()
a1=B.h[k][2]
a1=b.aZ(0,new A.L(a.a*a1,a.b*a1,a.c*a1,a.d*a1))
a=b9.bW()
b=B.h[k][3]
a4=a1.aZ(0,new A.L(a.a*b,a.b*b,a.c*b,a.d*b))
a5=B.bX[l+m&3]
b=a3.a
a=a5[0]
a1=a4.a
a2=a5[1]
a6=B.a.j(b*a+a1*a2,7)
a7=B.a.j(a3.b*a+a4.b*a2,7)
a8=B.a.j(a3.c*a+a4.c*a2,7)
a9=B.a.j(a3.d*a5[2]+a4.d*a5[3],7)
a2=b1.a
if(a2!=null)a2.aq(g+o,n,a6,a7,a8,a9)
m=m>>>2;++k}}}return b1}}
A.ew.prototype={
a6(){return"PvrFormat."+this.b}}
A.j6.prototype={
bQ(a){var s,r,q,p,o=A.aa(!1,8192)
switch(0){case 0:if(a.gaC()===3){s=this.kw(a)
r=B.kw}else{s=this.kx(a)
r=B.kx}break}q=a.gK()
p=a.gS()
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
o.a7(s)
return J.E(B.d.gB(o.c),0,o.a)},
kw(d0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9
if(d0.gS()!==d0.gK())throw A.h(A.m("PVRTC requires a square image."))
s=d0.gS()
if((s&s-1)>>>0!==0)throw A.h(A.m(u.b))
r=B.a.X(d0.gS(),4)
q=r-1
s=B.a.X(d0.gS()*d0.gK(),2)
p=new Uint8Array(s)
s=J.W(B.d.gB(p),0,null)
o=new A.a3(s)
n=new A.a3(J.W(B.d.gB(p),0,null))
m=new A.a3(J.W(B.d.gB(p),0,null))
l=new A.a3(J.W(B.d.gB(p),0,null))
k=new A.a3(J.W(B.d.gB(p),0,null))
for(j=s.$flags|0,i=t.h,h=0;h<r;++h)for(g=0;g<r;++g){f=A.oV(d0,g,h)
o.b=A.a5(g,h)<<1>>>0
o.aA()
o.c=!1
e=o.aH()
d=o.b+1
j&2&&A.c(s)
if(!(d<s.length))return A.a(s,d)
s[d]=e
e=i.a(f.a)
c=e.a
if(!(c>=0&&c<256))return A.a(B.I,c)
b=B.I[c]
c=e.b
if(!(c>=0&&c<256))return A.a(B.I,c)
a=B.I[c]
e=e.c
if(!(e>=0&&e<256))return A.a(B.G,e)
o.d=(b<<9|a<<4|B.G[e])>>>0
s[d]=o.aH()
o.e=!0
s[d]=o.aH()
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
s[d]=o.aH()
o.r=!1
s[d]=o.aH()}for(h=0,a0=0;h<r;++h,a0+=4)for(g=0,a1=0;g<r;++g,a1+=4){for(a2=0,a3=0,a4=0;a4<4;++a4){a5=(h+(a4<2?-1:0)&q)>>>0
a6=(a5+1&q)>>>0
for(i=a0+a4,a7=0;a7<4;++a7){a8=(g+(a7<2?-1:0)&q)>>>0
a9=(a8+1&q)>>>0
n.b=A.a5(a8,a5)<<1>>>0
n.aA()
m.b=A.a5(a9,a5)<<1>>>0
m.aA()
l.b=A.a5(a8,a6)<<1>>>0
l.aA()
k.b=A.a5(a9,a6)<<1>>>0
k.aA()
e=n.bT()
if(!(a2>=0&&a2<16))return A.a(B.h,a2)
d=B.h[a2][0]
c=e.a
b0=e.b
e=e.c
b1=m.bT()
b2=B.h[a2][1]
b3=b1.a
b4=b1.b
b1=b1.c
b5=l.bT()
b6=B.h[a2][2]
b7=b5.a
b8=b5.b
b5=b5.c
b9=k.bT()
c0=B.h[a2][3]
b7=c*d+b3*b2+b7*b6+b9.a*c0
b8=b0*d+b4*b2+b8*b6+b9.b*c0
c0=e*d+b1*b2+b5*b6+b9.c*c0
b9=n.bU()
b6=B.h[a2][0]
b5=b9.a
b2=b9.b
b9=b9.c
b1=m.bU()
d=B.h[a2][1]
e=b1.a
b4=b1.b
b1=b1.c
b0=l.bU()
b3=B.h[a2][2]
c=b0.a
c1=b0.b
b0=b0.c
c2=k.bU()
c3=B.h[a2][3]
c4=c2.a
c5=c2.b
c2=c2.c
c6=d0.a
c7=c6==null?null:c6.N(a1+a7,i,null)
if(c7==null)c7=new A.D()
e=b5*b6+e*d+c*b3+c4*c3-b7
c5=b2*b6+b4*d+c1*b3+c5*c3-b8
c3=b9*b6+b1*d+b0*b3+c2*c3-c0
c8=((B.b.i(c7.gm())*16-b7)*e+(B.b.i(c7.gt())*16-b8)*c5+(B.b.i(c7.gu())*16-c0)*c3)*16
c9=e*e+c5*c5+c3*c3
if(c8>3*c9)++a3
if(c8>8*c9)++a3
if(c8>13*c9)++a3
a3=(a3>>>2|a3<<30)>>>0;++a2}}o.b=A.a5(g,h)<<1>>>0
o.aA()
i=o.b
j&2&&A.c(s)
if(!(i<s.length))return A.a(s,i)
s[i]=a3}return p},
kx(c2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1
if(c2.gS()!==c2.gK())throw A.h(A.m("PVRTC requires a square image."))
s=c2.gS()
if((s&s-1)>>>0!==0)throw A.h(A.m(u.b))
r=B.a.X(c2.gS(),4)
q=r-1
s=B.a.X(c2.gS()*c2.gK(),2)
p=new Uint8Array(s)
s=J.W(B.d.gB(p),0,null)
o=new A.a3(s)
n=new A.a3(J.W(B.d.gB(p),0,null))
m=new A.a3(J.W(B.d.gB(p),0,null))
l=new A.a3(J.W(B.d.gB(p),0,null))
k=new A.a3(J.W(B.d.gB(p),0,null))
for(j=t.R,i=s.$flags|0,h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){d=A.oW(c2,e,g)
o.b=A.a5(f,h)<<1>>>0
o.aA()
o.c=!1
c=o.aH()
b=o.b+1
i&2&&A.c(s)
if(!(b<s.length))return A.a(s,b)
s[b]=c
c=j.a(d.a)
a=c.d
if(!(a>=0&&a<256))return A.a(B.at,a)
a0=B.at[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.I,a)
a2=B.I[a]
if(!(a1>=0&&a1<256))return A.a(B.I,a1)
a3=B.I[a1]
if(!(c>=0&&c<256))return A.a(B.G,c)
o.d=(a2<<9|a3<<4|B.G[c])>>>0
s[b]=o.aH()
o.e=!0
s[b]=o.aH()}else{if(!(a>=0&&a<256))return A.a(B.G,a)
a2=B.G[a]
if(!(a1>=0&&a1<256))return A.a(B.G,a1)
a3=B.G[a1]
if(!(c>=0&&c<256))return A.a(B.at,c)
o.d=(a0<<11|a2<<7|a3<<3|B.at[c])>>>0
s[b]=o.aH()
o.e=!1
s[b]=o.aH()}c=j.a(d.b)
a=c.d
if(!(a>=0&&a<256))return A.a(B.bt,a)
a0=B.bt[a]
a=c.a
a1=c.b
c=c.c
if(a0===7){if(!(a>=0&&a<256))return A.a(B.v,a)
a2=B.v[a]
if(!(a1>=0&&a1<256))return A.a(B.v,a1)
a3=B.v[a1]
if(!(c>=0&&c<256))return A.a(B.v,c)
o.f=(a2<<10|a3<<5|B.v[c])>>>0
s[b]=o.aH()
o.r=!0
s[b]=o.aH()}else{if(!(a>=0&&a<256))return A.a(B.U,a)
a2=B.U[a]
if(!(a1>=0&&a1<256))return A.a(B.U,a1)
a3=B.U[a1]
if(!(c>=0&&c<256))return A.a(B.U,c)
o.f=(a0<<12|a2<<8|a3<<4|B.U[c])>>>0
s[b]=o.aH()
o.r=!1
s[b]=o.aH()}}for(h=0,g=0;h<r;++h,g+=4)for(f=0,e=0;f<r;++f,e+=4){for(a4=0,a5=0,a6=0;a6<4;++a6){a7=(h+(a6<2?-1:0)&q)>>>0
a8=(a7+1&q)>>>0
for(j=g+a6,a9=0;a9<4;++a9){b0=(f+(a9<2?-1:0)&q)>>>0
b1=(b0+1&q)>>>0
n.b=A.a5(b0,a7)<<1>>>0
n.aA()
m.b=A.a5(b1,a7)<<1>>>0
m.aA()
l.b=A.a5(b0,a8)<<1>>>0
l.aA()
k.b=A.a5(b1,a8)<<1>>>0
k.aA()
c=n.bV()
if(!(a4>=0&&a4<16))return A.a(B.h,a4)
b=B.h[a4][0]
a=c.a
a1=c.b
b2=c.c
c=c.d
b3=m.bV()
b4=B.h[a4][1]
b4=new A.L(a*b,a1*b,b2*b,c*b).aZ(0,new A.L(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b3=l.bV()
b=B.h[a4][2]
b=b4.aZ(0,new A.L(b3.a*b,b3.b*b,b3.c*b,b3.d*b))
b3=k.bV()
b4=B.h[a4][3]
b5=b.aZ(0,new A.L(b3.a*b4,b3.b*b4,b3.c*b4,b3.d*b4))
b4=n.bW()
b3=B.h[a4][0]
b=b4.a
c=b4.b
b2=b4.c
b4=b4.d
a1=m.bW()
a=B.h[a4][1]
a=new A.L(b*b3,c*b3,b2*b3,b4*b3).aZ(0,new A.L(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a1=l.bW()
b3=B.h[a4][2]
b3=a.aZ(0,new A.L(a1.a*b3,a1.b*b3,a1.c*b3,a1.d*b3))
a1=k.bW()
a=B.h[a4][3]
b6=b3.aZ(0,new A.L(a1.a*a,a1.b*a,a1.c*a,a1.d*a))
a=c2.a
b7=a==null?null:a.N(e+a9,j,null)
if(b7==null)b7=new A.D()
a2=A.o(b7.gm())
a3=A.o(b7.gt())
b8=A.o(b7.gu())
a0=A.o(b7.gA())
b9=b6.eg(0,b5)
c0=new A.L(a2*16,a3*16,b8*16,a0*16).eg(0,b5).fU(b9)*16
c1=b9.fU(b9)
if(c0>3*c1)++a5
if(c0>8*c1)++a5
if(c0>13*c1)++a5
a5=(a5>>>2|a5<<30)>>>0;++a4}}o.b=A.a5(f,h)<<1>>>0
o.aA()
j=o.b
i&2&&A.c(s)
if(!(j<s.length))return A.a(s,j)
s[j]=a5}return p}}
A.j7.prototype={
$2(a,b){var s=this.a.aR(this.b+a,this.c+b)
return new A.aR(A.o(s.gm()),A.o(s.gt()),A.o(s.gu()))},
$S:37}
A.j8.prototype={
$2(a,b){var s=this.a.aR(this.b+a,this.c+b)
return new A.L(A.o(s.gm()),A.o(s.gt()),A.o(s.gu()),A.o(s.gA()))},
$S:25}
A.eD.prototype={
ci(a){var s,r,q=this
if(a.c-a.d<18)return
q.a=a.F()
q.b=a.F()
s=a.F()
if(s<12){if(!(s>=0))return A.a(B.bU,s)
r=B.bU[s]}else r=B.ay
q.c=r
a.n()
q.e=a.n()
q.f=a.F()
a.n()
a.n()
q.x=a.n()
q.y=a.n()
q.z=a.F()
q.Q=a.F()},
h1(){var s=this,r=s.z
if(r!==8&&r!==16&&r!==24&&r!==32)return!1
r=s.c
if(r===B.J||r===B.K){if(s.e>256||s.b!==1)return!1
r=s.f
if(r!==16&&r!==24&&r!==32)return!1}else if(s.b===1)return!1
return!0},
$iK:1}
A.au.prototype={
a6(){return"TgaImageType."+this.b}}
A.jb.prototype={
b6(a,b){if(this.b4(a)==null)return null
return this.ao(0)},
b4(a){var s,r,q,p,o=this
o.a=new A.eD(B.ay)
s=A.v(a,!1,null,0)
o.b=s
r=s.aj(18)
o.a.ci(r)
s=o.a
if(!s.h1())return null
q=o.b
q.d+=s.a
p=s.c
if(p===B.J||p===B.K)s.as=q.aj(s.e*B.a.j(s.f,3)).a2()
s=o.a
s.ax=o.b.d
return s},
ao(a){var s=this,r=s.a
if(r==null)return null
r=r.c
if(r===B.cs)return s.eK()
else if(r===B.cr||r===B.K)return s.iz()
else if(r===B.J)return s.eK()
return null},
eG(a,b){var s,r,q,p,o,n,m,l=this,k=A.v(a,!1,null,0),j=l.a.f
if(j===16){j=l.b
j===$&&A.b("input")
s=j.n()
r=s>>>7&248
q=s>>>2&248
p=(s&31)<<3
o=(s&32768)!==0?0:255
for(n=0;n<l.a.e;++n){b.bC(n,r)
b.bz(n,q)
b.by(n,p)
b.bx(n,o)}}else{m=j===32
for(n=0;n<l.a.e;++n){p=J.d(k.a,k.d++)
q=J.d(k.a,k.d++)
r=J.d(k.a,k.d++)
o=m?J.d(k.a,k.d++):255
b.bC(n,r)
b.bz(n,q)
b.by(n,p)
b.bx(n,o)}}},
iz(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=null,c=e.a,b=c.z,a=b===16,a0=a||b===32,a1=c.x,a2=c.y,a3=a0?4:3
c=c.c
s=A.Q(d,d,B.e,0,B.j,a2,d,0,a3,d,B.e,a1,c===B.J||c===B.K)
c=s.a
if((c==null?d:c.gM())!=null){c=e.a.as
c.toString
a1=s.a
a1=a1==null?d:a1.gM()
a1.toString
e.eG(c,a1)}r=s.gS()
q=s.gK()-1
c=b===8
p=0
for(;;){a1=e.b
a1===$&&A.b("input")
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
if(a1!=null)a1.aL(p,q,l)
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
if(a1!=null)a1.aq(p,q,l,h,g,f)
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
if(a1!=null)a1.aq(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}}}else if(c)for(k=0;k<n;++k){a1=e.b
l=J.d(a1.a,a1.d++)
j=p+1
a1=s.a
if(a1!=null)a1.aL(p,q,l)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}else if(a)for(k=0;k<n;++k){i=e.b.n()
f=(i&32768)!==0?0:255
j=p+1
a1=s.a
if(a1!=null)a1.aq(p,q,i>>>7&248,i>>>2&248,(i&31)<<3,f)
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
if(a1!=null)a1.aq(p,q,l,h,g,f)
if(j>=r){--q
if(q<0){p=m
break}p=0}else p=j}if(p>=r){--q
if(q<0)break
p=0}}return s},
eK(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=d.b
b===$&&A.b("input")
s=d.a
b.d=s.ax
r=s.z
b=r===16
q=!0
if(!b)if(r!==32){p=s.c
if(p===B.J||p===B.K){p=s.f
p=p===16||p===32}else p=!1
q=p}p=s.x
o=s.y
n=q?4:3
s=s.c
m=A.Q(c,c,B.e,0,B.j,o,c,0,n,c,B.e,p,s===B.J||s===B.K)
s=d.a
p=s.c
if(p===B.J||p===B.K){s=s.as
s.toString
p=m.a
p=p==null?c:p.gM()
p.toString
d.eG(s,p)}if(r===8)for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
b=d.b
j=J.d(b.a,b.d++)
b=m.a
if(b!=null)b.aL(k,l,j);++k}}else if(b)for(l=m.gK()-1;l>=0;--l){k=0
for(;;){b=m.a
b=b==null?c:b.a
if(!(k<(b==null?0:b)))break
i=d.b.n()
h=(i&32768)!==0?0:255
b=m.a
if(b!=null)b.aq(k,l,i>>>7&248,i>>>2&248,(i&31)<<3,h);++k}}else for(l=m.gK()-1;l>=0;--l){k=0
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
if(b!=null)b.aq(k,l,e,f,g,h);++k}}return m}}
A.jc.prototype={
bQ(a){var s,r,q,p,o,n,m,l=null,k=A.aa(!0,8192),j=A.S(18,0,!1,t.p)
B.c.h(j,2,2)
B.c.h(j,12,a.gS()&255)
B.c.h(j,13,B.a.j(a.gS(),8)&255)
B.c.h(j,14,a.gK()&255)
B.c.h(j,15,B.a.j(a.gK(),8)&255)
s=a.a
s=s==null?l:s.gM()
r=s==null?l:s.b
if(r==null)r=a.gaC()
B.c.h(j,16,r===3?24:32)
k.a7(j)
if(r===4)for(q=a.gK()-1;q>=0;--q){p=0
for(;;){s=a.a
o=s==null
n=o?l:s.a
if(!(p<(n==null?0:n)))break
m=o?l:s.N(p,q,l)
if(m==null)m=new A.D()
k.p(A.o(m.gu()))
k.p(A.o(m.gt()))
k.p(A.o(m.gm()))
k.p(A.o(m.gA()));++p}}else for(q=a.gK()-1;q>=0;--q){p=0
for(;;){s=a.a
o=s==null
n=o?l:s.a
if(!(p<(n==null?0:n)))break
m=o?l:s.N(p,q,l)
if(m==null)m=new A.D()
k.p(A.o(m.gu()))
k.p(A.o(m.gt()))
k.p(A.o(m.gm()));++p}}return J.E(B.d.gB(k.c),0,k.a)}}
A.jd.prototype={
ai(a){var s,r,q,p,o,n=this
if(a===0)return 0
if(n.c===0){n.c=8
n.b=n.a.F()}for(s=n.a,r=0;q=n.c,a>q;){p=B.a.V(r,q)
o=n.b
if(!(q>=0&&q<9))return A.a(B.A,q)
r=p+(o&B.A[q])
a-=q
n.c=8
n.b=J.d(s.a,s.d++)}if(a>0){if(q===0){n.c=8
n.b=s.F()}s=B.a.V(r,a)
q=n.b
p=n.c-a
q=B.a.bg(q,p)
if(!(a<9))return A.a(B.A,a)
r=s+(q&B.A[a])
n.c=p}return r}}
A.hA.prototype={
C(a){var s=this,r=s.a,q=$.kB().l(0,r)
if(q!=null)return q.a+": "+s.b.C(0)+" "+s.c
return"<"+r+">: "+s.b.C(0)+" "+s.c},
bo(){var s,r,q,p,o=this,n=o.e
if(n!=null)return n
n=o.f
n.d=o.d
s=o.c
r=o.b
if(r!==B.f){q=r.a
if(!(q<14))return A.a(B.u,q)
q=B.u[q]}else q=0
p=n.aj(s*q)
switch(r.a){case 1:return o.e=new A.aZ(new Uint8Array(A.r(p.aj(s).a2())))
case 2:return o.e=new A.c8(s===0?"":p.ak(s-1))
case 7:return o.e=new A.aZ(new Uint8Array(A.r(p.aj(s).a2())))
case 3:return o.e=A.mb(p,s)
case 4:return o.e=A.m6(p,s)
case 5:return o.e=A.m7(p,s)
case 11:return o.e=A.mc(p,s)
case 12:return o.e=A.m4(p,s)
case 6:return o.e=new A.bd(new Int8Array(A.r(J.kC(B.d.gB(p.a2()),0,s))))
case 8:return o.e=A.ma(p,s)
case 9:return o.e=A.m8(p,s)
case 10:return o.e=A.m9(p,s)
case 13:case 0:return null}}}
A.jg.prototype={
kp(a,b,c,d){var s,r,q,p=this
p.r=b
p.x=p.w=0
s=B.a.X(p.a+7,8)
for(r=0,q=0;q<d;++q){p.dB(a,r,c)
r+=s}},
dB(a,b,c){var s,r,q,p,o,n,m,l,k=this
k.d=0
for(s=k.a,r=!0;c<s;){while(r){q=k.c_(10)
if(!(q<1024))return A.a(B.ao,q)
p=B.ao[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|k.b5(2))>>>0
if(!(q<16))return A.a(B.H,q)
p=B.H[q]
n=B.a.j(p,1)
c+=B.a.j(p,4)&4095
k.aF(4-(n&7))}else if(o===0)throw A.h(A.m("TIFFFaxDecoder0"))
else if(o===15)throw A.h(A.m("TIFFFaxDecoder1"))
else{c+=B.a.j(p,5)&2047
k.aF(10-o)
if((p&1)===0){B.c.h(k.f,k.d++,c)
r=!1}}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}while(!r){q=k.b5(4)
if(!(q<16))return A.a(B.ag,q)
p=B.ag[q]
m=p>>>5&2047
l=!0
if(m===100){q=k.c_(9)
if(!(q<512))return A.a(B.aj,q)
p=B.aj[q]
o=B.a.j(p,1)&15
m=B.a.j(p,5)&2047
if(o===12){k.aF(5)
q=k.b5(4)
if(!(q<16))return A.a(B.H,q)
p=B.H[q]
n=B.a.j(p,1)
m=B.a.j(p,4)&4095
k.ba(a,b,c,m)
c+=m
k.aF(4-(n&7))}else if(o===15)throw A.h(A.m("TIFFFaxDecoder2"))
else{k.ba(a,b,c,m)
c+=m
k.aF(9-o)
if((p&1)===0){B.c.h(k.f,k.d++,c)
r=l}}}else{if(m===200){q=k.b5(2)
if(!(q<4))return A.a(B.af,q)
p=B.af[q]
m=p>>>5&2047
k.ba(a,b,c,m)
c+=m
k.aF(2-(p>>>1&15))
B.c.h(k.f,k.d++,c)}else{k.ba(a,b,c,m)
c+=m
k.aF(4-(p>>>1&15))
B.c.h(k.f,k.d++,c)}r=l}}if(c===s){if(k.z===2)if(k.w!==0){s=k.x
s.toString
k.x=s+1
k.w=0}break}}B.c.h(k.f,k.d++,c)},
kq(a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=this
a0.r=a2
a0.z=3
a0.x=a0.w=0
s=a0.a
r=B.a.X(s+7,8)
q=A.S(2,null,!1,t.I)
a0.at=a5&1
a0.as=a5>>>2&1
if(a0.f9()!==1)throw A.h(A.m("TIFFFaxDecoder3"))
a0.dB(a1,0,a3)
for(p=r,o=1;o<a4;++o){if(a0.f9()===0){n=a0.e
a0.e=a0.f
a0.f=n
a0.y=0
m=a3
l=-1
k=!0
j=0
for(;;){m.toString
if(!(m<s))break
a0.eU(l,k,q)
i=q[0]
h=q[1]
g=a0.b5(7)
if(!(g<128))return A.a(B.am,g)
g=B.am[g]&255
f=g>>>3&15
e=g&7
if(f===0){if(!k){h.toString
a0.ba(a1,p,m,h-m)}a0.aF(7-e)
m=h
l=m}else if(f===1){a0.aF(7-e)
d=j+1
c=d+1
if(k){m+=a0.d3()
B.c.h(a0.f,j,m)
b=a0.d2()
a0.ba(a1,p,m,b)
m+=b
B.c.h(a0.f,d,m)}else{b=a0.d2()
a0.ba(a1,p,m,b)
m+=b
B.c.h(a0.f,j,m)
m+=a0.d3()
B.c.h(a0.f,d,m)}j=c
l=m}else{if(f<=8){i.toString
a=i+(f-5)
d=j+1
B.c.h(a0.f,j,a)
k=!k
if(k)a0.ba(a1,p,m,a-m)
a0.aF(7-e)}else throw A.h(A.m("TIFFFaxDecoder4"))
m=a
j=d
l=m}}B.c.h(a0.f,j,m)
a0.d=j+1}else a0.dB(a1,p,a3)
p+=r}},
ku(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this
a4.r=a6
a4.z=4
a4.x=a4.w=0
s=a4.a
r=B.a.X(s+7,8)
q=A.S(2,null,!1,t.I)
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
a4.eU(k,j,q)
h=q[0]
g=q[1]
f=a4.b5(7)
if(!(f<128))return A.a(B.am,f)
f=B.am[f]&255
e=f>>>3&15
d=f&7
if(e===0){if(!j){g.toString
a4.ba(a5,o,l,g-l)}a4.aF(7-d)
l=g
k=l}else if(e===1){a4.aF(7-d)
c=i+1
b=c+1
if(j){l+=a4.d3()
B.c.h(m,i,l)
a=a4.d2()
a4.ba(a5,o,l,a)
l+=a
B.c.h(m,c,l)}else{a=a4.d2()
a4.ba(a5,o,l,a)
l+=a
B.c.h(m,i,l)
l+=a4.d3()
B.c.h(m,c,l)}i=b
k=l}else if(e<=8){h.toString
a0=h+(e-5)
c=i+1
B.c.h(m,i,a0)
j=!j
if(j)a4.ba(a5,o,l,a0-l)
a4.aF(7-d)
l=a0
i=c
k=l}else if(e===11){if(a4.b5(3)!==7)throw A.h(A.m("TIFFFaxDecoder5"))
for(a1=0,a2=!1;!a2;j=a3){while(a4.b5(1)!==1)++a1
if(a1>5){a1-=6
if(!j&&a1>0){c=i+1
B.c.h(m,i,l)
i=c}l+=a1
if(a1>0)j=!0
a3=a4.b5(1)===0
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
a4.ba(a5,o,l,1);++l
i=c}}}else throw A.h(A.m("TIFFFaxDecoder5 "+e))}B.c.h(m,i,l)
a4.d=i+1
o+=r}},
d3(){var s,r,q,p,o,n,m=this
for(s=0,r=!0;r;){q=m.c_(10)
if(!(q<1024))return A.a(B.ao,q)
p=B.ao[q]
o=B.a.j(p,1)&15
if(o===12){q=(q<<2&12|m.b5(2))>>>0
if(!(q<16))return A.a(B.H,q)
p=B.H[q]
n=B.a.j(p,1)
s+=B.a.j(p,4)&4095
m.aF(4-(n&7))}else if(o===0)throw A.h(A.m("TIFFFaxDecoder0"))
else if(o===15)throw A.h(A.m("TIFFFaxDecoder1"))
else{s+=B.a.j(p,5)&2047
m.aF(10-o)
if((p&1)===0)r=!1}}return s},
d2(){var s,r,q,p,o,n,m,l=this
for(s=0,r=!1;!r;){q=l.b5(4)
if(!(q<16))return A.a(B.ag,q)
p=B.ag[q]
o=p>>>5&2047
if(o===100){q=l.c_(9)
if(!(q<512))return A.a(B.aj,q)
p=B.aj[q]
n=B.a.j(p,1)&15
m=B.a.j(p,5)
if(n===12){l.aF(5)
q=l.b5(4)
if(!(q<16))return A.a(B.H,q)
p=B.H[q]
m=B.a.j(p,1)
s+=B.a.j(p,4)&4095
l.aF(4-(m&7))}else if(n===15)throw A.h(A.m("TIFFFaxDecoder2"))
else{s+=m&2047
l.aF(9-n)
if((p&1)===0)r=!0}}else{if(o===200){q=l.b5(2)
if(!(q<4))return A.a(B.af,q)
p=B.af[q]
s+=p>>>5&2047
l.aF(2-(p>>>1&15))}else{s+=o
l.aF(4-(p>>>1&15))}r=!0}}return s},
f9(){var s,r,q=this,p="TIFFFaxDecoder8",o=q.as
if(o===0){if(q.c_(12)!==1)throw A.h(A.m("TIFFFaxDecoder6"))}else if(o===1){o=q.w
o.toString
s=8-o
if(q.c_(s)!==0)throw A.h(A.m(p))
if(s<4)if(q.c_(8)!==0)throw A.h(A.m(p))
while(r=q.c_(8),r!==1)if(r!==0)throw A.h(A.m(p))}if(q.at===0)return 1
else return q.b5(1)},
eU(a,b,c){var s,r,q,p,o,n,m=this
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
ba(a,b,c,d){var s,r,q,p,o,n=8*b+A.o(c),m=n+d,l=B.a.j(n,3),k=n&7
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
c_(a){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.r
e===$&&A.b("data")
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
if(!(l>=0&&l<9))return A.a(B.A,l)
h=B.a.V(m&B.A[l],k)
if(!(i>=0))return A.a(B.W,i)
g=B.a.a5(o&B.W[i],8-i)
if(j!==0){g=B.a.V(g,j)
if(!(j<9))return A.a(B.W,j)
g|=B.a.a5(n&B.W[j],8-j)
f.x=e+1
f.w=j}else if(i===8){f.w=0
f.x=e+1}else f.w=i
return(h|g)>>>0},
b5(a){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.r
h===$&&A.b("data")
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
if(k>=0){if(!(m>=0&&m<9))return A.a(B.A,m)
j=B.a.a5(n&B.A[m],k)
h+=a
i.w=h
if(h===8){i.w=0
h=i.x
h.toString
i.x=h+1}}else{if(!(m>=0&&m<9))return A.a(B.A,m)
j=B.a.V(n&B.A[m],-k)
if(!(l>=0&&l<9))return A.a(B.W,l)
j=(j|B.a.a5(o&B.W[l],8-l))>>>0
h=i.x
h.toString
i.x=h+1
i.w=l}return j},
aF(a){var s,r=this,q=r.w
q.toString
s=q-a
if(s<0){q=r.x
q.toString
r.x=q-1
r.w=8+s}else r.w=s}}
A.hB.prototype={
hR(a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d=this,c=null,b=A.p(a0,c,0),a=a0.n()
for(s=d.a,r=0;r<a;++r){q=a0.n()
p=a0.n()
o=a0.k()
if(p>13){a0.d+=4
continue}n=B.aT[p]
if(o*B.u[p]>4)m=a0.k()
else{m=a0.d
a0.d=m+4}l=new A.hA(q,n,o,m,b)
s.h(0,q,l)
if(q===256){k=l.bo()
k=k==null?c:k.i(0)
d.b=k==null?0:k}else if(q===257){k=l.bo()
k=k==null?c:k.i(0)
d.c=k==null?0:k}else if(q===262){j=l.bo()
i=j==null?c:j.i(0)
if(i==null)i=17
if(i<17){if(!(i>=0))return A.a(B.bL,i)
d.d=B.bL[i]}else d.d=B.b0}else if(q===259){k=l.bo()
k=k==null?c:k.i(0)
d.e=k==null?0:k}else if(q===258){k=l.bo()
k=k==null?c:k.i(0)
d.f=k==null?0:k}else if(q===277){k=l.bo()
k=k==null?c:k.i(0)
d.r=k==null?0:k}else if(q===317){k=l.bo()
k=k==null?c:k.i(0)
d.Q=k==null?0:k}else if(q===339){k=l.bo()
j=k==null?c:k.i(0)
if(j==null)j=0
if(!(j>=0&&j<4))return A.a(B.bP,j)
d.x=B.bP[j]}else if(q===320){j=l.bo()
if(j!=null){k=J.nM(B.d.gB(j.br()))
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
h&2&&A.c(k)
k[r]=f>>>8}}if(d.d===B.b_)d.z=!0
d.w=d.r
if(s.ag(324)){d.ay=d.co(322)
d.ch=d.co(323)
d.CW=d.da(324)
d.cx=d.da(325)}else{d.ay=d.d9(322,d.b)
if(!s.ag(278))d.ch=d.d9(323,d.c)
else{e=d.co(278)
if(e===-1)d.ch=d.c
else d.ch=e}d.CW=d.da(273)
d.cx=d.da(279)}k=d.b
h=d.ay
d.cy=B.a.aG(k+h-1,h)
h=d.c
k=d.ch
d.db=B.a.aG(h+k-1,k)
d.dy=d.d9(266,1)
d.fr=d.co(292)
d.fx=d.co(293)
d.co(338)
switch(d.d.a){case 0:case 1:s=d.f
if(s===1&&d.r===1)d.y=B.aZ
else if(s===4&&d.r===1)d.y=B.kG
else if(B.a.a8(s,8)===0){s=d.r
if(s===1)d.y=B.kH
else if(s===2)d.y=B.kI
else d.y=B.a7}break
case 2:if(B.a.a8(d.f,8)===0){s=d.r
if(s===3)d.y=B.ct
else if(s===4)d.y=B.kK
else d.y=B.a7}break
case 3:s=!1
if(d.r===1)if(d.id!=null){s=d.f
s=s===4||s===8||s===16}if(s)d.y=B.kJ
break
case 4:if(d.f===1&&d.r===1)d.y=B.aZ
break
case 6:if(d.e===7&&d.f===8&&d.r===3)d.y=B.ct
else{if(s.ag(530)){j=s.l(0,530).bo()
d.as=j.i(0)
s=d.at=j.a9(0,1)}else s=d.at=d.as=2
k=d.as
k===$&&A.b("chromaSubH")
if(k*s===1)d.y=B.a7
else if(d.f===8&&d.r===3)d.y=B.kL}break
case 5:if(B.a.a8(d.f,8)===0)d.y=B.a7
s=d.r
if(s===4)d.w=3
else if(s===5)d.w=4
break
default:if(B.a.a8(d.f,8)===0)d.y=B.a7
break}},
c1(a3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this,a=null,a0=b.x,a1=a0===B.a_,a2=a0===B.i
a0=b.f
if(a0===1)s=B.y
else if(a0===2)s=B.t
else{if(a0===4)a0=B.z
else if(a1&&a0===16)a0=B.E
else if(a1&&a0===32)a0=B.M
else if(a1&&a0===64)a0=B.Q
else if(a2&&a0===8)a0=B.R
else if(a2&&a0===16)a0=B.S
else if(a2&&a0===32)a0=B.T
else if(a0===16)a0=B.m
else a0=a0===32?B.N:B.e
s=a0}r=b.id!=null&&b.d===B.b1
q=r?3:b.w
a0=b.b
p=A.Q(a,a,s,0,B.j,b.c,a,0,q,a,s,a0,r)
if(r){a0=p.a
a0=a0==null?a:a0.gM()
a0.toString
o=b.id
n=o.length
m=n/3|0
l=b.k1
l===$&&A.b("colorMapRed")
k=b.k2
k===$&&A.b("colorMapGreen")
j=b.k3
j===$&&A.b("colorMapBlue")
for(i=j,h=k,g=l,f=0;f<m;++f,++g,++h,++i){if(i>=n)break
if(!(g<n))return A.a(o,g)
l=o[g]
if(!(h<n))return A.a(o,h)
a0.b0(f,l,o[h],o[i])}}e=0
d=0
for(;;){a0=b.db
a0===$&&A.b("tilesY")
if(!(e<a0))break
c=0
for(;;){a0=b.cy
a0===$&&A.b("tilesX")
if(!(c<a0))break
b.iA(a3,p,c,e);++c;++d}++e}return p},
iA(b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0=this,b1=null
if(b0.y===B.aZ){b0.im(b2,b3,b4,b5)
return}p=b0.cy
p===$&&A.b("tilesX")
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
q=A.mm()
try{q.fS(A.p(b2,s,0),r.a)}catch(i){}if(b0.Q===2)for(h=0;h<b0.ch;++h){g=b0.r
p=b0.ay
f=g*(h*p+1)
e=p*g
for(;g<e;++g){p=r
m=J.d(p.a,p.d+f)
k=r
d=b0.r
d=J.d(k.a,k.d+(f-d))
J.y(p.a,p.d+f,m+d);++f}}}else if(p===32773){r=A.v(new Uint8Array(j),!1,b1,0)
b0.eJ(b2,j,r.a)}else if(p===32946)r=A.v(B.D.c2(b2.cT(0,0,s)),!1,b1,0)
else if(p===8)r=A.v(B.D.c2(b2.cT(0,0,s)),!1,b1,0)
else if(p===6||p===7){b0.jg(new A.h2().c1(t.D.a(b2.cT(0,0,s))),b3,n,l,b0.ay,b0.ch)
return}else throw A.h(A.m("Unsupported Compression Type: "+p))
c=A.j([0,0,0],t.t)
for(b=l,a=0;a<b0.ch;++a,++b)for(a0=n,a1=0;a1<b0.ay;++a1,++a0){p=r
if(p.d>=p.c||a0>=b0.b||b>=b0.c)break
p=b0.r
if(p===1){p=b0.x
if(p===B.a_){p=b0.f
if(p===32){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.c1()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else if(p===64)a2=r.dl()
else if(p===16){p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a2=m[p]}else a2=0
if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aL(a0,b,a2)}}else{m=b0.f
if(m===8)if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else{p=r
a2=J.d(p.a,p.d++)}else if(m===16)if(p===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else a2=r.n()
else if(m===32)if(p===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a2=p[0]}else a2=r.k()
else a2=0
if(b0.d===B.b_){p=b3.a
a3=p==null?b1:p.gE()
a2=(a3==null?0:a3)-a2}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aL(a0,b,a2)}}}else if(p===2){p=b0.f
if(p===8){if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else{p=r
a4=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}}else if(p===16){if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else a4=r.n()
if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.n()}else if(p===32){if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a4=p[0]}else a4=r.k()
if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()}else{a4=0
a5=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.Y(a0,b,a4,a5,0)}}else if(p===3){p=b0.x
if(p===B.a_){p=b0.f
if(p===32){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.c1()
if(0>=p.length)return A.a(p,0)
a6=p[0]
m[0]=r.k()
a7=p[0]
m[0]=r.k()
a8=p[0]}else{a7=0
a8=0
if(p===64)a6=r.dl()
else if(p===16){p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a6=m[p]
p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a7=m[p]
p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a8=m[p]}else a6=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.Y(a0,b,a6,a7,a8)}}else{m=b0.f
if(m===8){if(p===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else{p=r
a6=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}}else if(m===16){if(p===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.n()
if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.n()
if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.n()}else if(m===32){if(p===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.k()
if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()}else{a6=0
a7=0
a8=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.Y(a0,b,a6,a7,a8)}}}else if(p>=4)if(b0.x===B.a_){p=b0.f
if(p===32){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.c1()
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
if(p===64)a6=r.dl()
else if(p===16){p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a6=m[p]
p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a7=m[p]
p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a8=m[p]
p=r.n()
m=$.R
m=m!=null?m:A.V()
if(!(p<m.length))return A.a(m,p)
a9=m[p]}else a6=0}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aq(a0,b,a6,a7,a8,a9)}}else{p=b3.a
a5=p==null?b1:p.gE()
if(a5==null)a5=0
p=b0.f
if(p===8){if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else{p=r
a6=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else{p=r
a7=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else{p=r
a8=J.d(p.a,p.d++)}if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else{p=r
a9=J.d(p.a,p.d++)}if(b0.r===5)if(b0.x===B.i){p=r
p=J.d(p.a,p.d++)
m=$.ap()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ay()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else{p=r
a5=J.d(p.a,p.d++)}}else if(p===16){if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.n()
if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.n()
if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.n()
if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.n()
if(b0.r===5)if(b0.x===B.i){p=r.n()
m=$.ao()
m.$flags&2&&A.c(m)
m[0]=p
p=$.ax()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.n()}else if(p===32){if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a6=p[0]}else a6=r.k()
if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a7=p[0]}else a7=r.k()
if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a8=p[0]}else a8=r.k()
if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a9=p[0]}else a9=r.k()
if(b0.r===5)if(b0.x===B.i){p=r.k()
m=$.N()
m.$flags&2&&A.c(m)
m[0]=p
p=$.a6()
if(0>=p.length)return A.a(p,0)
a5=p[0]}else a5=r.k()}else{a6=0
a7=0
a8=0
a9=0}if(b0.d===B.cu){A.nd(a6,a7,a8,a9,c)
a6=c[0]
a7=c[1]
a8=c[2]
a9=a5}if(a0<b0.b&&b<b0.c){p=b3.a
if(p!=null)p.aq(a0,b,a6,a7,a8,a9)}}}}else throw A.h(A.m("Unsupported bitsPerSample: "+p))},
jg(a,b,c,d,e,f){var s,r,q,p
for(s=0;s<f;++s)for(r=s+d,q=0;q<e;++q){p=a.a
p=p==null?null:p.N(q,s,null)
if(p==null)p=new A.D()
b.c5(q+c,r,p)}},
im(a5,a6,a7,a8){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=null,a4=a2.cy
a4===$&&A.b("tilesX")
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
if(n===32773){l=B.a.a8(a4,8)===0?B.a.X(a4,8)*p:(B.a.X(a4,8)+1)*p
s=A.v(new Uint8Array(a4*p),!1,a3,0)
a2.eJ(a5,l,s.a)}else if(n===5){s=A.v(new Uint8Array(a4*p),!1,a3,0)
A.mm().fS(A.p(a5,m,0),s.a)
if(a2.Q===2)for(k=0;k<a2.c;++k){j=a2.r
i=j*(k*a2.b+1)
for(;j<a2.b*a2.r;++j){a4=s
p=J.d(a4.a,a4.d+i)
n=s
h=a2.r
h=J.d(n.a,n.d+(i-h))
J.y(a4.a,a4.d+i,p+h);++i}}}else if(n===2){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.lf(a2.dy,a4,p).kp(s,a5,0,a2.ch)}catch(g){}}else if(n===3){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.lf(a2.dy,a4,p).kq(s,a5,0,a2.ch,a2.fr)}catch(g){}}else if(n===4){s=A.v(new Uint8Array(a4*p),!1,a3,0)
try{A.lf(a2.dy,a4,p).ku(s,a5,0,a2.ch,a2.fx)}catch(g){}}else if(n===8)s=A.v(B.D.c2(a5.cT(0,0,m)),!1,a3,0)
else if(n===32946)s=A.v(B.D.c2(a5.cT(0,0,m)),!1,a3,0)
else if(n===1)s=a5
else throw A.h(A.m("Unsupported Compression Type: "+n))
f=new A.jd(s)
e=a6.gE()
a4=a2.z
d=a4?e:0
c=a4?0:e
for(b=o,a=0;a<a2.ch;++a,++b){for(a0=q,a1=0;a1<a2.ay;++a1,++a0){a4=a6.a
p=a4==null
n=p?a3:a4.b
if(b<(n==null?0:n)){a4=p?a3:a4.a
a4=a0>=(a4==null?0:a4)}else a4=!0
if(a4)break
a4=f.ai(1)
p=a6.a
if(a4===0){if(p!=null)p.Y(a0,b,d,0,0)}else if(p!=null)p.Y(a0,b,c,0,0)}f.c=0}},
eJ(a,b,c){var s,r,q,p,o,n,m,l,k,j
t.L.a(c)
for(s=J.ak(c),r=0,q=0;q<b;){p=r+1
o=J.d(a.a,a.d+r)
n=$.ap()
n.$flags&2&&A.c(n)
n[0]=o
o=$.ay()
if(0>=o.length)return A.a(o,0)
m=o[0]
if(m>=0&&m<=127)for(o=m+1,r=p,l=0;l<o;++l,q=k,r=p){k=q+1
p=r+1
s.h(c,q,J.d(a.a,a.d+r))}else{o=m<=-1&&m>=-127
r=p+1
if(o){j=J.d(a.a,a.d+p)
for(o=-m+1,l=0;l<o;++l,q=k){k=q+1
s.h(c,q,j)}}}}},
d9(a,b){var s=this.a
if(!s.ag(a))return b
s=s.l(0,a).bo()
s=s==null?null:s.i(0)
return s==null?0:s},
co(a){return this.d9(a,0)},
da(a){var s,r=this.a
if(!r.ag(a))return null
s=r.l(0,a)
r=s.bo()
r.toString
return A.kT(s.c,r.gbK(r),t.p)}}
A.cr.prototype={
a6(){return"TiffFormat."+this.b}}
A.a7.prototype={
a6(){return"TiffPhotometricType."+this.b}}
A.aU.prototype={
a6(){return"TiffImageType."+this.b}}
A.hC.prototype={$iK:1}
A.iT.prototype={
fS(a,b){var s,r,q,p,o,n,m,l,k=this,j="_bufferLength"
t.L.a(b)
k.r=b
s=J.bm(b)
k.w=0
r=t.D.a(a.a)
k.e=r
q=k.f=r.length
k.b=a.d
if(0>=q)return A.a(r,0)
if(r[0]===0){if(1>=q)return A.a(r,1)
r=r[1]===1}else r=!1
if(r)throw A.h(A.m("Invalid LZW Data"))
k.eZ()
k.d=k.c=0
p=k.dL()
r=k.x
o=0
for(;;){if(!(p!==257&&k.w<s))break
if(p===256){k.eZ()
p=k.dL()
k.as=0
if(p===257)break
J.y(k.r,k.w++,p)
o=p}else{q=k.Q
q.toString
if(p<q){k.eW(p)
q=k.as
q===$&&A.b(j)
n=q-1
for(;n>=0;--n){q=k.r
m=k.w++
if(!(n<4096))return A.a(r,n)
J.y(q,m,r[n])}q=k.as-1
if(!(q>=0&&q<4096))return A.a(r,q)
k.en(o,r[q])}else{k.eW(o)
q=k.as
q===$&&A.b(j)
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
k.en(o,r[l])}o=p}p=k.dL()}},
en(a,b){var s,r=this,q=r.y
q===$&&A.b("_table")
s=r.Q
s.toString
q.$flags&2&&A.c(q)
if(!(s<4096))return A.a(q,s)
q[s]=b
q=r.z
q===$&&A.b("_prefix")
q.$flags&2&&A.c(q)
q[s]=a
s=r.Q=s+1
if(s===511)r.a=10
else if(s===1023)r.a=11
else if(s===2047)r.a=12},
eW(a){var s,r,q,p,o,n,m,l=this
l.as=0
s=l.x
l.as=1
r=l.y
r===$&&A.b("_table")
if(!(a<4096))return A.a(r,a)
q=r[a]
s.$flags&2&&A.c(s)
s[0]=q
q=l.z
q===$&&A.b("_prefix")
p=q[a]
for(o=1;p!==4098;o=n){n=o+1
l.as=n
if(!(p>=0&&p<4096))return A.a(r,p)
m=r[p]
if(!(o<4096))return A.a(s,o)
s[o]=m
p=q[p]}},
dL(){var s,r,q,p,o=this,n=o.b,m=o.f
m===$&&A.b("_dataLength")
if(n>=m)return 257
for(;s=o.d,r=o.a,s<r;n=p){if(n>=m)return 257
r=o.c
q=o.e
q===$&&A.b("_data")
p=n+1
o.b=p
if(!(n>=0&&n<q.length))return A.a(q,n)
o.c=(r<<8>>>0)+q[n]>>>0
o.d=s+8}n=s-r
o.d=n
n=B.a.a5(o.c,n)
r-=9
if(!(r>=0&&r<4))return A.a(B.bu,r)
return n&B.bu[r]},
eZ(){var s,r,q=this
q.y=new Uint8Array(4096)
s=new Uint32Array(4096)
q.z=s
B.o.aO(s,0,4096,4098)
for(s=q.y,r=0;r<256;++r){s.$flags&2&&A.c(s)
s[r]=r}q.a=9
q.Q=258}}
A.je.prototype={
ao(a){var s,r,q=this.a
if(q==null)return null
q=q.f
if(!(a<q.length))return A.a(q,a)
q=q[a]
s=this.c
s===$&&A.b("_input")
r=q.c1(s)
return r},
b6(a,b){var s,r,q,p=this,o=null,n=A.v(a,!1,o,0)
p.c=n
n=p.a=p.fb(n)
if(n==null)return o
s=n.f.length
r=p.ao(0)
if(r==null)return o
r.e=A.kJ(A.v(a,!1,o,0))
r.w=B.bd
for(q=1;q<s;++q)r.aI(p.ao(q))
return r},
fb(a){var s,r,q,p,o,n,m,l,k,j,i=null,h=A.j([],t.aU),g=new A.hC(h),f=a.n()
if(f!==18761&&f!==19789)return i
if(f===19789)a.e=!0
else a.e=!1
q=a.n()
g.d=q
if(q!==42)return i
p=a.k()
o=A.p(a,i,0)
o.d=p
s=o
for(q=t.p,n=t.cV;p!==0;){r=null
try{m=new A.hB(A.I(q,n),B.b0,B.aY,B.kM)
m.hR(s)
r=m
l=r
if(!(l.b!==0&&l.c!==0))break}catch(k){break}B.c.G(h,r)
l=h.length
if(l===1){if(0>=l)return A.a(h,0)
j=h[0]
g.a=j.b
if(0>=l)return A.a(h,0)
g.b=j.c}p=s.k()
if(p!==0)s.d=p}return h.length!==0?g:i}}
A.jf.prototype={
bQ(a){var s,r,q,p,o,n,m,l,k,j,i,h,g="ifd0",f=A.aa(!1,8192),e=new A.bL(A.I(t.N,t.P))
if(a.e!=null)e.l(0,g).fR(a.gbF().l(0,g))
if(a.gaY())a=a.aM(B.e)
if(a.gaC()===1)s=1
else s=a.gaK()?3:2
r=a.gaC()
q=e.l(0,g)
q.h(0,"ImageWidth",a.gS())
q.h(0,"ImageHeight",a.gK())
q.h(0,"BitsPerSample",a.gaJ())
q.h(0,"SampleFormat",this.j5(a).a)
q.h(0,"SamplesPerPixel",a.gaK()?1:r)
q.h(0,"Compression",1)
q.h(0,"PhotometricInterpretation",s)
q.h(0,"RowsPerStrip",a.gK())
q.h(0,"PlanarConfiguration",1)
q.h(0,"TileWidth",a.gS())
q.h(0,"TileLength",a.gK())
q.h(0,"StripByteCounts",a.gcP(0))
q.h(0,"StripOffsets",new A.bP(new Uint8Array(A.r(a.a2()))))
if(a.gaK()){p=a.a
o=p==null?null:p.gM()
n=o.a
p=n*3
m=new Uint16Array(p)
for(l=0,k=0;l<3;++l)for(j=0;j<n;++j,k=i){i=k+1
h=B.b.i(o.b2(j,l))
if(!(k>=0&&k<p))return A.a(m,k)
m[k]=h<<8>>>0}q.h(0,"ColorMap",m)}e.aT(f)
return J.E(B.d.gB(f.c),0,f.a)},
j5(a){var s=a.a
s=s==null?null:s.gbm()
switch((s==null?B.L:s).a){case 0:return B.aY
case 1:return B.i
case 2:return B.a_}}}
A.jl.prototype={
cL(){var s,r=this.a,q=r.bp()
if((q&1)!==0)return!1
if((q>>>1&7)>3)return!1
if((q>>>4&1)===0)return!1
this.f.d=q>>>5
if(r.bp()!==2752925)return!1
s=this.b
s.a=r.n()
s.b=r.n()
return!0},
bP(){var s,r,q,p=this,o=null
if(!p.j3())return o
s=p.b
r=s.a
p.d=A.Q(o,o,B.e,0,B.j,s.b,o,0,4,o,B.e,r,!1)
p.ja()
if(!p.jp())return o
s=s.w
if(s.length!==0){q=A.v(new A.al(s),!1,o,0)
s=p.d
s.toString
s.e=A.kJ(q)}return p.d},
j3(){var s,r,q,p,o=this
if(!o.cL())return!1
o.fr=A.pG()
for(s=o.dy,r=0;r<4;++r){q=new Int32Array(2)
p=new Int32Array(2)
B.c.h(s,r,new A.hJ(q,p,new Int32Array(2)))}o.y=o.Q=0
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
p===$&&A.b("partitionLength")
p=A.mD(s.al(p))
o.c=p
s.d+=q.d
p.a1(1)
o.c.a1(1)
o.jv(o.x,o.fr)
o.jo()
if(!o.jr(s))return!1
o.jt()
o.c.a1(1)
o.js()
return!0},
jv(a,b){var s,r,q,p=this,o=p.c
o===$&&A.b("br")
o=o.a1(1)!==0
a.a=o
if(o){a.b=p.c.a1(1)!==0
if(p.c.a1(1)!==0){a.c=p.c.a1(1)!==0
for(o=a.d,s=0;s<4;++s){if(p.c.a1(1)!==0){r=p.c
q=r.a1(7)
r=r.a1(1)===1?-q:q}else r=0
o.$flags&2&&A.c(o)
o[s]=r}for(o=a.e,s=0;s<4;++s){if(p.c.a1(1)!==0){r=p.c
q=r.a1(6)
r=r.a1(1)===1?-q:q}else r=0
o.$flags&2&&A.c(o)
o[s]=r}}if(a.b)for(s=0;s<3;++s){o=b.a
r=p.c.a1(1)!==0?p.c.a1(8):255
o.$flags&2&&A.c(o)
o[s]=r}}else a.b=!1
return!0},
jo(){var s,r,q,p=this,o=p.w,n=p.c
n===$&&A.b("br")
o.a=n.a1(1)!==0
o.b=p.c.a1(6)
o.c=p.c.a1(3)
n=p.c.a1(1)!==0
o.d=n
if(n)if(p.c.a1(1)!==0){for(n=o.e,s=0;s<4;++s)if(p.c.a1(1)!==0){r=p.c
q=r.a1(6)
r=r.a1(1)===1?-q:q
n.$flags&2&&A.c(n)
n[s]=r}for(n=o.f,s=0;s<4;++s)if(p.c.a1(1)!==0){r=p.c
q=r.a1(6)
r=r.a1(1)===1?-q:q
n.$flags&2&&A.c(n)
n[s]=r}}if(o.b===0)n=0
else n=o.a?1:2
p.aN=n
return!0},
jr(a){var s,r,q,p,o,n,m,l=a.c-a.d,k=this.c
k===$&&A.b("br")
k=B.a.R(1,k.a1(2))
this.cy=k
s=k-1
r=s*3
if(l<r)return!1
for(k=this.db,q=0,p=0;p<s;++p,r=n){o=a.cY(3,q)
n=r+((J.d(o.a,o.d)|J.d(o.a,o.d+1)<<8|J.d(o.a,o.d+2)<<16)>>>0)
if(n>l)n=l
m=new A.eG(a.c6(n-r,r))
m.b=254
m.c=0
m.d=-8
B.c.h(k,p,m)
q+=3}B.c.h(k,s,A.mD(a.c6(l-r,a.d-a.b+r)))
return r<l},
jt(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=this,e=f.c
e===$&&A.b("br")
s=e.a1(7)
r=f.c.a1(1)!==0?f.c.cu(4):0
q=f.c.a1(1)!==0?f.c.cu(4):0
p=f.c.a1(1)!==0?f.c.cu(4):0
o=f.c.a1(1)!==0?f.c.cu(4):0
n=f.c.a1(1)!==0?f.c.cu(4):0
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
g=B.aP[g]
i.$flags&2&&A.c(i)
i[0]=g
if(j<0)g=0
else g=j>127?127:j
i[1]=B.aQ[g]
g=h.b
i=j+q
if(i<0)i=0
else if(i>127)i=127
i=B.aP[i]
g.$flags&2&&A.c(g)
g[0]=i*2
i=j+p
if(i<0)i=0
else if(i>127)i=127
g[1]=B.aQ[i]*101581>>>16
if(g[1]<8)g[1]=8
i=h.c
g=j+o
if(g<0)g=0
else if(g>117)g=117
g=B.aP[g]
i.$flags&2&&A.c(i)
i[0]=g
g=j+n
if(g<0)g=0
else if(g>127)g=127
i[1]=B.aQ[g]}},
js(){var s,r,q,p,o,n,m=this,l=m.fr
for(s=0;s<4;++s)for(r=0;r<8;++r)for(q=0;q<3;++q)for(p=0;p<11;++p){o=m.c
o===$&&A.b("br")
n=o.ab(B.je[s][r][q][p])!==0?m.c.a1(8):B.e6[s][r][q][p]
o=l.b
if(!(s<o.length))return A.a(o,s)
o=o[s]
if(!(r<o.length))return A.a(o,r)
o=o[r].a
if(!(q<o.length))return A.a(o,q)
o=o[q]
o.$flags&2&&A.c(o)
o[p]=n}o=m.c
o===$&&A.b("br")
o=o.a1(1)!==0
m.fx=o
if(o)m.fy=m.c.a1(8)},
jx(){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=g.aN
f.toString
if(f>0){s=g.w
for(f=s.e,r=s.f,q=g.x,p=q.e,o=0;o<4;++o){if(q.a){n=p[o]
if(!q.c){m=s.b
m.toString
n+=m}}else n=s.b
for(l=0;l<=1;++l){m=g.bH
m===$&&A.b("_fStrengths")
if(!(o<m.length))return A.a(m,o)
k=m[o][l]
m=s.d
m===$&&A.b("useLfDelta")
if(m){n.toString
j=n+f[0]
if(l!==0)j+=r[0]}else j=n
j.toString
if(j<0)j=0
else if(j>63)j=63
if(j>0){m=s.c
m===$&&A.b("sharpness")
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
ja(){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f=h.b,e=f.at
if(e!=null)h.bR=e
s=J.am(4,t.e6)
for(e=t.ao,r=0;r<4;++r)s[r]=A.j([new A.bE(),new A.bE()],e)
h.bH=t.gS.a(s)
e=h.at
e.toString
s=J.am(e,t.dE)
for(q=0;q<e;++q){p=new Uint8Array(16)
o=new Uint8Array(8)
s[q]=new A.eK(p,o,new Uint8Array(8))}h.k2=t.cC.a(s)
h.ok=new Uint8Array(832)
e=h.at
e.toString
h.go=new Uint8Array(4*e)
p=h.p4=16*e
o=h.R8=8*e
n=h.aN
n.toString
if(!(n<3))return A.a(B.ae,n)
m=B.ae[n]
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
else{f=B.a.X(h.y-m,16)
h.ay=f
p=B.a.X(h.Q-m,16)
h.ch=p
if(f<0)h.ay=0
if(p<0)h.ch=0}f=B.a.X(h.as+15+m,16)
h.cx=f
p=B.a.X(h.z+15+m,16)
h.CW=p
if(p>e)h.CW=e
p=h.ax
p.toString
if(f>p)h.cx=p
i=e+1
s=J.am(i,t.ai)
for(q=0;q<i;++q)s[q]=new A.eI()
h.k3=t.eQ.a(s)
f=h.at
f.toString
s=J.am(f,t.gU)
for(q=0;q<f;++q){e=new Int16Array(384)
s[q]=new A.eJ(e,new Uint8Array(16))}h.bG=t.db.a(s)
f=h.at
f.toString
h.k4=t.ge.a(A.S(f,g,!1,t.aj))
h.jx()
A.p6()
h.e=new A.jm()
return!0},
jp(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d="isIntra4x4"
e.y2=0
s=e.id
r=e.x
q=e.db
p=0
for(;;){o=e.cx
o.toString
if(!(p<o))break
o=e.cy
o===$&&A.b("_numPartitions")
o=(p&o-1)>>>0
if(!(o>=0&&o<8))return A.a(q,o)
n=q[o]
for(;;){p=e.y1
o=e.at
o.toString
if(!(p<o))break
o=e.k3
o===$&&A.b("_mbInfo")
m=o.length
if(0>=m)return A.a(o,0)
l=o[0]
k=1+p
if(!(k<m))return A.a(o,k)
j=o[k]
k=e.bG
k===$&&A.b("_mbData")
if(!(p<k.length))return A.a(k,p)
i=k[p]
if(r.b){p=e.c
p===$&&A.b("br")
p=p.ab(e.fr.a[0])
o=e.c
m=e.fr
e.k1=p===0?o.ab(m.a[1]):2+o.ab(m.a[2])}p=e.fx
p===$&&A.b("_useSkipProba")
if(p){p=e.c
p===$&&A.b("br")
o=e.fy
o===$&&A.b("_skipP")
h=p.ab(o)!==0}else h=!1
e.jq()
if(!h)h=e.ju(j,n)
else{l.a=j.a=0
p=i.b
p===$&&A.b(d)
if(!p)l.b=j.b=0
i.f=i.e=0}p=e.aN
p.toString
if(p>0){p=e.k4
p===$&&A.b("_fInfo")
o=e.y1
m=e.bH
m===$&&A.b("_fStrengths")
k=e.k1
k===$&&A.b("_segment")
if(!(k<m.length))return A.a(m,k)
k=m[k]
m=i.b
m===$&&A.b(d)
B.c.h(p,o,k[m?1:0])
p=e.k4
o=e.y1
if(!(o<p.length))return A.a(p,o)
g=p[o]
g.c=g.c||!h}++e.y1}p=e.k3
p===$&&A.b("_mbInfo")
if(0>=p.length)return A.a(p,0)
p=p[0]
p.b=p.a=0
B.d.aO(s,0,4,0)
e.y1=0
e.k0()
p=e.aN
p.toString
f=!1
if(p>0){p=e.y2
o=e.ch
o===$&&A.b("_tlMbY")
if(p>=o){o=e.cx
o.toString
o=p<=o
f=o}}if(!e.iZ(f))return!1
p=++e.y2}return!0},
k0(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4=this,a5=null,a6="_dsp",a7=a4.y2,a8=a4.ok
a8===$&&A.b("_yuvBlock")
s=A.v(a8,!1,a5,40)
r=A.v(a8,!1,a5,584)
q=A.v(a8,!1,a5,600)
a8=a7>0
p=0
for(;;){o=a4.at
o.toString
if(!(p<o))break
o=a4.bG
o===$&&A.b("_mbData")
if(!(p<o.length))return A.a(o,p)
n=o[p]
if(p>0){for(m=-1;m<16;++m){o=m*32
s.bn(o-4,4,s,o+12)}for(m=-1;m<8;++m){o=m*32
l=o-4
o+=4
r.bn(l,4,r,o)
q.bn(l,4,q,o)}}else{for(m=0;m<16;++m)J.y(s.a,s.d+(m*32-1),129)
for(m=0;m<8;++m){o=m*32-1
J.y(r.a,r.d+o,129)
J.y(q.a,q.d+o,129)}if(a8){J.y(q.a,q.d+-33,129)
J.y(r.a,r.d+-33,129)
J.y(s.a,s.d+-33,129)}}o=a4.k2
o===$&&A.b("_yuvT")
if(!(p<o.length))return A.a(o,p)
k=o[p]
j=n.a
i=n.e
if(a8){s.c4(-32,16,k.a)
r.c4(-32,8,k.b)
q.c4(-32,8,k.c)}else if(p===0){o=s.a
l=s.d+-33
J.bl(o,l,l+21,127)
l=r.a
o=r.d+-33
J.bl(l,o,o+9,127)
o=q.a
l=q.d+-33
J.bl(o,l,l+9,127)}o=n.b
o===$&&A.b("isIntra4x4")
if(o){h=A.p(s,a5,-16)
g=h.cU()
if(a8){o=a4.at
o.toString
if(p>=o-1){o=k.a[15]
l=h.a
f=h.d
J.bl(l,f,f+4,o)}else{o=a4.k2
l=p+1
if(!(l<o.length))return A.a(o,l)
h.c4(0,4,o[l].a)}}o=g.length
if(0>=o)return A.a(g,0)
e=g[0]
g.$flags&2&&A.c(g)
if(96>=o)return A.a(g,96)
g[96]=e
g[64]=e
g[32]=e
for(o=n.c,d=0;d<16;++d,i=i<<2>>>0){c=A.p(s,a5,B.c8[d])
l=o[d]
if(!(l<10))return A.a(B.bW,l)
B.bW[l].$1(c)
i.toString
l=d*16
a4.eM(i,new A.af(j,l,Math.min(384,384),l,!1),c)}}else{o=A.mF(p,a7,n.c[0])
o.toString
if(!(o<7))return A.a(B.c7,o)
B.c7[o].$1(s)
if(i!==0)for(d=0;d<16;++d,i=i<<2>>>0){c=A.p(s,a5,B.c8[d])
i.toString
o=d*16
a4.eM(i,new A.af(j,o,Math.min(384,384),o,!1),c)}}o=n.f
o===$&&A.b("nonZeroUV")
l=A.mF(p,a7,n.d)
l.toString
if(!(l<7))return A.a(B.aS,l)
B.aS[l].$1(r)
B.aS[l].$1(q)
l=Math.min(384,384)
b=new A.af(j,256,l,256,!1)
if((o&255)!==0){f=a4.e
if((o&170)!==0){f===$&&A.b(a6)
f.bL(b,r)
f.bL(A.p(b,a5,16),A.p(r,a5,4))
a=A.p(b,a5,32)
a0=A.p(r,a5,128)
f.bL(a,a0)
f.bL(A.p(a,a5,16),A.p(a0,a5,4))}else{f===$&&A.b(a6)
f.hc(b,r)}}a1=new A.af(j,320,l,320,!1)
o=o>>>8
if((o&255)!==0){l=a4.e
if((o&170)!==0){l===$&&A.b(a6)
l.bL(a1,q)
l.bL(A.p(a1,a5,16),A.p(q,a5,4))
o=A.p(a1,a5,32)
f=A.p(q,a5,128)
l.bL(o,f)
l.bL(A.p(o,a5,16),A.p(f,a5,4))}else{l===$&&A.b(a6)
l.hc(a1,q)}}o=a4.ax
o.toString
if(a7<o-1){B.d.ar(k.a,0,16,s.a2(),480)
B.d.ar(k.b,0,8,r.a2(),224)
B.d.ar(k.c,0,8,q.a2(),224)}a2=p*16
a3=p*8
for(m=0;m<16;++m){o=a4.p4
o.toString
l=a4.p1
l===$&&A.b("_cacheY")
l.bn(a2+m*o,16,s,m*32)}for(m=0;m<8;++m){o=a4.R8
o.toString
l=a4.p2
l===$&&A.b("_cacheU")
f=m*32
l.bn(a3+m*o,8,r,f)
o=a4.R8
o.toString
l=a4.p3
l===$&&A.b("_cacheV")
l.bn(a3+m*o,8,q,f)}++p}},
eM(a,b,c){var s,r,q,p,o,n,m="_dsp"
switch(a>>>30){case 3:s=this.e
s===$&&A.b(m)
s.l4(b,c,!1)
break
case 2:this.e===$&&A.b(m)
r=J.d(b.a,b.d)+4
q=B.a.aB(B.a.j(J.d(b.a,b.d+4)*35468,16),32)
p=B.a.aB(B.a.j(J.d(b.a,b.d+4)*85627,16),32)
o=B.a.aB(B.a.j(J.d(b.a,b.d+1)*35468,16),32)
n=B.a.aB(B.a.j(J.d(b.a,b.d+1)*85627,16),32)
A.jo(c,0,r+p,n,o)
A.jo(c,1,r+q,n,o)
A.jo(c,2,r-q,n,o)
A.jo(c,3,r-p,n,o)
break
case 1:s=this.e
s===$&&A.b(m)
s.cV(b,c)
break
default:break}},
iJ(a,b){var s,r,q,p,o,n,m,l,k,j,i,h=this,g=null,f="_dsp",e=h.p4,d=h.k4
d===$&&A.b("_fInfo")
if(!(a>=0&&a<d.length))return A.a(d,a)
d=d[a]
d.toString
s=h.p1
s===$&&A.b("_cacheY")
r=A.p(s,g,a*16)
q=d.b
p=d.a
if(p===0)return
if(h.aN===1){if(a>0){s=h.e
s===$&&A.b(f)
e.toString
s.ed(r,e,p+4)}if(d.c){s=h.e
s===$&&A.b(f)
e.toString
s.hs(r,e,p)}if(b>0){s=h.e
s===$&&A.b(f)
e.toString
s.ee(r,e,p+4)}if(d.c){d=h.e
d===$&&A.b(f)
e.toString
d.ht(r,e,p)}}else{o=h.R8
s=h.p2
s===$&&A.b("_cacheU")
n=a*8
m=A.p(s,g,n)
s=h.p3
s===$&&A.b("_cacheV")
l=A.p(s,g,n)
k=d.d
if(a>0){s=h.e
s===$&&A.b(f)
e.toString
n=p+4
s.cm(r,1,e,16,n,q,k)
o.toString
s.cm(m,1,o,8,n,q,k)
s.cm(l,1,o,8,n,q,k)}if(d.c){s=h.e
s===$&&A.b(f)
e.toString
s.kD(r,e,p,q,k)
o.toString
j=A.p(m,g,4)
i=A.p(l,g,4)
s.cl(j,1,o,8,p,q,k)
s.cl(i,1,o,8,p,q,k)}if(b>0){s=h.e
s===$&&A.b(f)
e.toString
n=p+4
s.cm(r,e,1,16,n,q,k)
o.toString
s.cm(m,o,1,8,n,q,k)
s.cm(l,o,1,8,n,q,k)}if(d.c){d=h.e
d===$&&A.b(f)
e.toString
d.l7(r,e,p,q,k)
o.toString
s=4*o
j=A.p(m,g,s)
i=A.p(l,g,s)
d.cl(j,o,1,8,p,q,k)
d.cl(i,o,1,8,p,q,k)}}},
iW(){var s,r=this,q=r.ay
q===$&&A.b("_tlMbX")
s=q
for(;;){q=r.CW
q.toString
if(!(s<q))break
r.iJ(s,r.y2);++s}},
iZ(a2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=a.aN
a1.toString
if(!(a1<3))return A.a(B.ae,a1)
s=B.ae[a1]
a1=a.p4
a1.toString
r=s*a1
a1=a.R8
a1.toString
q=(s/2|0)*a1
a1=a.p1
a1===$&&A.b("_cacheY")
p=-r
o=A.p(a1,a0,p)
a1=a.p2
a1===$&&A.b("_cacheU")
n=-q
m=A.p(a1,a0,n)
a1=a.p3
a1===$&&A.b("_cacheV")
l=A.p(a1,a0,n)
k=a.y2
a1=a.cx
a1.toString
j=k*16
i=(k+1)*16
if(a2)a.iW()
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
if(a.bR!=null&&j<i){g=a.xr=a.iB(j,i-j)
if(g==null)return!1}else g=a0
f=a.Q
if(j<f){e=f-j
d=a.to
d===$&&A.b("_y")
c=d.d
b=a.p4
b.toString
d.d=c+b*e
b=a.x1
b===$&&A.b("_u")
c=b.d
d=a.R8
d.toString
d*=B.a.j(e,1)
b.d=c+d
c=a.x2
c===$&&A.b("_v")
c.d+=d
if(g!=null)g.d=g.d+a.b.a*e
j=f}if(j<i){d=a.to
d===$&&A.b("_y")
c=d.d
b=a.y
d.d=c+b
c=a.x1
c===$&&A.b("_u")
d=b>>>1
c.d=c.d+d
c=a.x2
c===$&&A.b("_v")
c.d+=d
if(g!=null)g.d+=b
a.jC(j-f,a.z-b,i-j)}if(a1){a1=a.p1
g=a.p4
g.toString
a1.bn(p,r,o,16*g)
g=a.p2
p=a.R8
p.toString
g.bn(n,q,m,8*p)
p=a.p3
g=a.R8
g.toString
p.bn(n,q,l,8*g)}return!0},
jC(a,b,c){if(b<=0||c<=0)return!1
this.iL(a,b,c)
this.iK(a,b,c)
return!0},
dw(a){var s
if((a&-4194304)>>>0===0)s=B.a.j(a,14)
else s=a<0?0:255
return s},
dh(a,b,c,d){var s=19077*a
d.h(0,0,this.dw(s+26149*c+-3644112))
d.h(0,1,this.dw(s-6419*b-13320*c+2229552))
d.h(0,2,this.dw(s+33050*b+-4527440))},
dg(a7,a8,a9,b0,b1,b2,b3,b4,b5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=null,a1=new A.jx(),a2=b5-1,a3=B.a.j(a2,1),a4=a1.$2(J.d(a9.a,a9.d),J.d(b0.a,b0.d)),a5=a1.$2(J.d(b1.a,b1.d),J.d(b2.a,b2.d)),a6=B.a.j(3*a4+a5+131074,2)
a.dh(J.d(a7.a,a7.d),a6&255,a6>>>16,b3)
b3.h(0,3,255)
s=a8!=null
if(s){a6=B.a.j(3*a5+a4+131074,2)
r=J.d(a8.a,a8.d)
b4.toString
a.dh(r,a6&255,a6>>>16,b4)
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
a.dh(r,a6&255,a6>>>16,i)
i.h(0,3,255)
if(s){a6=B.a.j(3*a5+a4+131074,2)
a2=J.d(a8.a,a8.d+a2)
b4.toString
j=A.p(b4,a0,j)
a.dh(a2,a6&255,a6>>>16,j)
j.h(0,3,255)}}},
iK(a,b,c){var s,r,q,p,o,n,m,l,k=this,j=k.xr
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
l=l==null?null:l.N(n,p,null);(l==null?new A.D():l).sA(m)}s.d=s.d+j.a}},
iL(a,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g=this,f=null,e=J.E(g.d.gB(0),0,null),d=g.b.a,c=A.v(e,!1,f,a*d*4),b=g.to
b===$&&A.b("_y")
s=A.p(b,f,0)
b=g.x1
b===$&&A.b("_u")
r=A.p(b,f,0)
b=g.x2
b===$&&A.b("_v")
q=A.p(b,f,0)
p=a+a1
o=B.a.j(a0+1,1)
n=d*4
d=g.rx
d===$&&A.b("_tmpU")
m=A.p(d,f,0)
d=g.ry
d===$&&A.b("_tmpV")
l=A.p(d,f,0)
if(a===0){g.dg(s,f,r,q,r,q,c,f,a0)
k=a1}else{d=g.RG
d===$&&A.b("_tmpY")
g.dg(d,s,m,l,r,q,A.p(c,f,-n),c,a0)
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
g.dg(A.p(s,f,-i),s,m,l,r,q,A.p(c,f,b),c,a0)}d=s.d
b=g.p4
b.toString
s.d=d+b
if(g.Q+p<g.as){d=g.RG
d===$&&A.b("_tmpY")
d.c4(0,a0,s)
g.rx.c4(0,o,r)
g.ry.c4(0,o,q);--k}else if((p&1)===0)g.dg(s,f,r,q,r,q,A.p(c,f,n),f,a0)
return k},
iB(a,b){var s,r,q,p,o,n,m,l,k,j=this,i="_alphaPlane",h=j.b,g=h.a,f=h.b
if(a<0||b<=0||a+b>f)return null
if(a===0){h=g*f
j.aS=new Uint8Array(h)
s=j.bR
r=new A.jy(s,g,f)
q=s.F()
p=r.d=q&3
r.e=B.a.j(q,2)&3
r.f=B.a.j(q,4)&3
r.r=B.a.j(q,6)&3
if(r.gh0())if(p===0){if(s.c-s.d<h)r.r=1}else if(p===1){o=new A.dm(B.a8,A.j([],t.J))
o.a=g
o.b=f
h=A.j([],t.e)
p=A.j([],t.gk)
n=new Uint32Array(2)
m=new A.hH(s,n)
n=m.d=J.E(B.o.gB(n),0,null)
l=s.F()
n.$flags&2&&A.c(n)
if(0>=n.length)return A.a(n,0)
n[0]=l
l=s.F()
n.$flags&2&&A.c(n)
if(1>=n.length)return A.a(n,1)
n[1]=l
l=s.F()
n.$flags&2&&A.c(n)
if(2>=n.length)return A.a(n,2)
n[2]=l
l=s.F()
n.$flags&2&&A.c(n)
if(3>=n.length)return A.a(n,3)
n[3]=l
l=s.F()
n.$flags&2&&A.c(n)
if(4>=n.length)return A.a(n,4)
n[4]=l
l=s.F()
n.$flags&2&&A.c(n)
if(5>=n.length)return A.a(n,5)
n[5]=l
l=s.F()
n.$flags&2&&A.c(n)
if(6>=n.length)return A.a(n,6)
n[6]=l
s=s.F()
n.$flags&2&&A.c(n)
if(7>=n.length)return A.a(n,7)
n[7]=s
p=new A.fX(m,o,h,p)
p.dy=g
p.fr=f
r.x=p
p.cw(g,f,!0)
h=r.x
s=h.ch
p=s.length
if(p===1){if(0>=p)return A.a(s,0)
h=s[0].a===B.cw&&h.jf()}else h=!1
if(h){r.y=!0
h=r.x
s=h.c
k=s.a*s.b
h.db=0
s=B.a.a8(k,4)
s=new Uint8Array(k+(4-s))
h.cy=s
h.cx=J.W(B.d.gB(s),0,null)}else{r.y=!1
r.x.ep(g)}}else r.r=1
j.cf=r}h=j.cf
if(h!=null)if(!h.w){s=j.aS
s===$&&A.b(i)
if(!h.ko(a,b,s))return null}h=j.aS
h===$&&A.b(i)
return A.v(h,!1,null,a*g)},
ju(a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2=this,a3=a2.fr.b,a4=a2.dy,a5=a2.k1
a5===$&&A.b("_segment")
if(!(a5<4))return A.a(a4,a5)
s=a4[a5]
a5=a2.bG
a5===$&&A.b("_mbData")
a4=a2.y1
if(!(a4<a5.length))return A.a(a5,a4)
r=a5[a4]
q=A.v(r.a,!1,null,0)
a4=a2.k3
a4===$&&A.b("_mbInfo")
if(0>=a4.length)return A.a(a4,0)
p=a4[0]
q.kN(0,q.c-q.d,0)
a4=r.b
a4===$&&A.b("isIntra4x4")
if(!a4){o=A.v(new Int16Array(16),!1,null,0)
a4=a6.b
a5=p.b
if(1>=a3.length)return A.a(a3,1)
n=a2.dK(a7,a3[1],a4+a5,s.b,0,o)
a6.b=p.b=n>0?1:0
if(n>1)a2.kb(o,q)
else{m=B.a.j(J.d(o.a,o.d)+3,3)
for(l=0;l<256;l+=16)J.y(q.a,q.d+l,m)}k=a3[0]
j=1}else{if(3>=a3.length)return A.a(a3,3)
k=a3[3]
j=0}i=a6.a&15
h=p.a&15
for(g=0,f=0;f<4;++f){e=h&1
for(d=0,c=0;c<4;++c){n=a2.dK(a7,k,e+(i&1),s.a,j,q)
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
i=B.a.a4(a6.a,a5)
h=B.a.a4(p.a,a5)
for(d=0,f=0;f<2;++f){e=h&1
for(c=0;c<2;++c){if(2>=a4)return A.a(a3,2)
n=a2.dK(a7,a3[2],e+(i&1),s.c,0,q)
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
kb(a,b){var s,r,q,p,o,n,m,l,k,j,i=new Int32Array(16)
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
j4(a,b){var s,r,q,p,o,n,m
t.L.a(b)
if(a.ab(b[3])===0)s=a.ab(b[4])===0?2:3+a.ab(b[5])
else if(a.ab(b[6])===0)s=a.ab(b[7])===0?5+a.ab(159):7+2*a.ab(165)+a.ab(145)
else{r=a.ab(b[8])
q=9+r
if(!(q<11))return A.a(b,q)
p=2*r+a.ab(b[q])
if(!(p<4))return A.a(B.bw,p)
o=B.bw[p]
n=o.length
for(s=0,m=0;m<n;++m)s+=s+a.ab(o[m])
s+=3+B.a.R(8,p)}return s},
dK(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j
t.c7.a(b)
t.L.a(d)
s=b.length
if(!(e<s))return A.a(b,e)
r=b[e].a
if(!(c<r.length))return A.a(r,c)
q=r[c]
for(;e<16;e=p){if(a.ab(q[0])===0)return e
while(a.ab(q[1])===0){++e
if(!(e>=0&&e<17))return A.a(B.aq,e)
r=B.aq[e]
if(!(r<s))return A.a(b,r)
r=b[r].a
if(0>=r.length)return A.a(r,0)
q=r[0]
if(e===16)return 16}p=e+1
if(!(p>=0&&p<17))return A.a(B.aq,p)
r=B.aq[p]
if(!(r<s))return A.a(b,r)
o=b[r].a
r=o.length
if(a.ab(q[2])===0){if(1>=r)return A.a(o,1)
q=o[1]
n=1}else{n=this.j4(a,q)
if(2>=r)return A.a(o,2)
q=o[2]}if(!(e>=0&&e<16))return A.a(B.bR,e)
r=B.bR[e]
m=a.b
m===$&&A.b("_range")
l=a.eu(B.a.j(m,1))
m=a.b
if(m>>>0!==m||m>=128)return A.a(B.an,m)
k=B.an[m]
a.b=B.bZ[m]
m=a.d
m===$&&A.b("_bits")
a.d=m-k
m=l!==0?-n:n
j=d[e>0?1:0]
J.y(f.a,f.d+r,m*j)}return 16},
jq(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.y1,g=4*h,f=i.go,e=i.id,d=i.bG
d===$&&A.b("_mbData")
if(!(h<d.length))return A.a(d,h)
s=d[h]
h=i.c
h===$&&A.b("br")
h=h.ab(145)===0
s.b=h
if(!h){if(i.c.ab(156)!==0)r=i.c.ab(128)!==0?1:3
else r=i.c.ab(163)!==0?2:0
h=s.c
h.$flags&2&&A.c(h)
h[0]=r
f.toString
B.d.aO(f,g,g+4,r)
B.d.aO(e,0,4,r)}else{q=s.c
for(p=0,o=0;o<4;++o,p=j){r=e[o]
for(n=0;n<4;++n){h=g+n
if(!(h<f.length))return A.a(f,h)
d=f[h]
if(!(d<10))return A.a(B.bT,d)
d=B.bT[d]
if(!(r>=0&&r<10))return A.a(d,r)
m=d[r]
l=i.c.ab(m[0])
if(!(l<18))return A.a(B.al,l)
k=B.al[l]
while(k>0){d=i.c
if(!(k<9))return A.a(m,k)
d=2*k+d.ab(m[k])
if(!(d>=0&&d<18))return A.a(B.al,d)
k=B.al[d]}r=-k
f.$flags&2&&A.c(f)
f[h]=r}j=p+4
f.toString
B.d.ar(q,p,j,f,g)
e.$flags&2&&A.c(e)
if(!(o<4))return A.a(e,o)
e[o]=r}}if(i.c.ab(142)===0)h=0
else if(i.c.ab(114)===0)h=2
else h=i.c.ab(183)!==0?1:3
s.d=h}}
A.jx.prototype={
$2(a,b){return(a|b<<16)>>>0},
$S:26}
A.eG.prototype={
a1(a){var s,r
for(s=0;r=a-1,a>0;a=r)s=(s|B.a.V(this.ab(128),r))>>>0
return s},
cu(a){var s=this.a1(a)
return this.a1(1)===1?-s:s},
ab(a){var s,r=this,q=r.b
q===$&&A.b("_range")
s=r.eu(B.a.j(q*a,8))
if(r.b<=126)r.k8()
return s},
eu(a){var s,r,q,p,o,n=this,m="_value",l=n.d
l===$&&A.b("_bits")
if(l<0){s=n.a
r=s.c
q=s.d
if(r-q>=1){p=s.F()
l=n.c
l===$&&A.b(m)
n.c=(p|l<<8)>>>0
l=n.d+8
n.d=l
o=l}else{if(q<r){l=s.F()
s=n.c
s===$&&A.b(m)
n.c=(l|s<<8)>>>0
s=n.d+8
n.d=s
l=s}else if(!n.e){s=n.c
s===$&&A.b(m)
n.c=s<<8>>>0
l+=8
n.d=l
n.e=!0}o=l}}else o=l
l=n.c
l===$&&A.b(m)
if(B.a.bg(l,o)>a){s=n.b
s===$&&A.b("_range")
r=a+1
n.b=s-r
n.c=l-B.a.V(r,o)
return 1}else{n.b=a
return 0}},
k8(){var s,r=this,q=r.b
q===$&&A.b("_range")
if(!(q>=0&&q<128))return A.a(B.an,q)
s=B.an[q]
r.b=B.bZ[q]
q=r.d
q===$&&A.b("_bits")
r.d=q-s}}
A.jm.prototype={
ee(a,b,c){var s,r=A.p(a,null,0)
for(s=0;s<16;++s){r.d=a.d+s
if(this.f5(r,b,c))this.d4(r,b)}},
ed(a,b,c){var s,r=A.p(a,null,0)
for(s=0;s<16;++s){r.d=a.d+s*b
if(this.f5(r,1,c))this.d4(r,1)}},
ht(a,b,c){var s,r,q=A.p(a,null,0)
for(s=4*b,r=3;r>0;--r){q.d+=s
this.ee(q,b,c)}},
hs(a,b,c){var s,r=A.p(a,null,0)
for(s=3;s>0;--s){r.d+=4
this.ed(r,b,c)}},
l7(a,b,c,d,e){var s,r,q=A.p(a,null,0)
for(s=4*b,r=3;r>0;--r){q.d+=s
this.cl(q,b,1,16,c,d,e)}},
kD(a,b,c,d,e){var s,r=A.p(a,null,0)
for(s=3;s>0;--s){r.d+=4
this.cl(r,1,b,16,c,d,e)}},
cm(a,a0,a1,a2,a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=A.p(a,null,0)
for(s=-3*a0,r=-2*a0,q=-a0,p=2*a0;o=a2-1,a2>0;a2=o){if(this.f6(b,a0,a3,a4))if(this.eX(b,a0,a5))this.d4(b,a0)
else{n=J.d(b.a,b.d+s)
m=J.d(b.a,b.d+r)
l=J.d(b.a,b.d+q)
k=J.d(b.a,b.d)
j=J.d(b.a,b.d+a0)
i=J.d(b.a,b.d+p)
h=$.kx()
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
g=$.aD()
h=255+n+c
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.y(b.a,b.d+s,h)
h=$.aD()
g=255+m+d
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.y(b.a,b.d+r,g)
g=$.aD()
h=255+l+e
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.y(b.a,b.d+q,h)
h=$.aD()
g=255+k-e
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.y(b.a,b.d,g)
g=$.aD()
h=255+j-d
if(!(h>=0&&h<766))return A.a(g,h)
h=g[h]
J.y(b.a,b.d+a0,h)
h=$.aD()
g=255+i-c
if(!(g>=0&&g<766))return A.a(h,g)
g=h[g]
J.y(b.a,b.d+p,g)}b.d+=a1}},
cl(a,b,c,d,e,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f=A.p(a,null,0)
for(s=-2*b,r=-b;q=d-1,d>0;d=q){if(this.f6(f,b,e,a0))if(this.eX(f,b,a1))this.d4(f,b)
else{p=J.d(f.a,f.d+s)
o=J.d(f.a,f.d+r)
n=J.d(f.a,f.d)
m=J.d(f.a,f.d+b)
l=3*(n-o)
k=$.ky()
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
j=$.aD()
k=255+p+g
if(!(k>=0&&k<766))return A.a(j,k)
k=j[k]
J.y(f.a,f.d+s,k)
k=$.aD()
j=255+o+h
if(!(j>=0&&j<766))return A.a(k,j)
j=k[j]
J.y(f.a,f.d+r,j)
j=$.aD()
k=255+n-i
if(!(k>=0&&k<766))return A.a(j,k)
k=j[k]
J.y(f.a,f.d,k)
k=$.aD()
j=255+m-g
if(!(j>=0&&j<766))return A.a(k,j)
j=k[j]
J.y(f.a,f.d+b,j)}f.d+=c}},
d4(a,b){var s,r,q,p=J.d(a.a,a.d+-2*b),o=-b,n=J.d(a.a,a.d+o),m=J.d(a.a,a.d),l=J.d(a.a,a.d+b),k=$.kx(),j=1020+p-l
if(!(j>=0&&j<2041))return A.a(k,j)
s=3*(m-n)+k[j]
j=$.ky()
k=112+B.a.aB(B.a.j(s+4,3),32)
if(!(k>=0&&k<225))return A.a(j,k)
r=j[k]
k=112+B.a.aB(B.a.j(s+3,3),32)
if(!(k>=0&&k<225))return A.a(j,k)
q=j[k]
k=$.aD()
j=255+n+q
if(!(j>=0&&j<766))return A.a(k,j)
a.h(0,o,k[j])
j=$.aD()
k=255+m-r
if(!(k>=0&&k<766))return A.a(j,k)
a.h(0,0,j[k])},
eX(a,b,c){var s=J.d(a.a,a.d+-2*b),r=J.d(a.a,a.d+-b),q=J.d(a.a,a.d),p=J.d(a.a,a.d+b),o=$.i3(),n=255+s-r
if(!(n>=0&&n<511))return A.a(o,n)
if(o[n]<=c){n=255+p-q
if(!(n>=0&&n<511))return A.a(o,n)
n=o[n]>c
o=n}else o=!0
return o},
f5(a,b,c){var s,r=J.d(a.a,a.d+-2*b),q=J.d(a.a,a.d+-b),p=J.d(a.a,a.d),o=J.d(a.a,a.d+b),n=$.i3(),m=255+q-p
if(!(m>=0&&m<511))return A.a(n,m)
m=n[m]
n=$.kw()
s=255+r-o
if(!(s>=0&&s<511))return A.a(n,s)
return 2*m+n[s]<=c},
f6(a,b,c,d){var s,r,q,p=J.d(a.a,a.d+-4*b),o=J.d(a.a,a.d+-3*b),n=J.d(a.a,a.d+-2*b),m=J.d(a.a,a.d+-b),l=J.d(a.a,a.d),k=J.d(a.a,a.d+b),j=J.d(a.a,a.d+2*b),i=J.d(a.a,a.d+3*b),h=$.i3(),g=255+m-l
if(!(g>=0&&g<511))return A.a(h,g)
g=h[g]
s=$.kw()
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
bL(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=new Int32Array(16)
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
A.bV(b,g,0,0,o+i)
A.bV(b,g,1,0,n+j)
A.bV(b,g,2,0,n-j)
A.bV(b,g,3,0,o-i);++r
g+=32}},
l4(a,b,c){this.bL(a,b)
if(c)this.bL(A.p(a,null,16),A.p(b,null,4))},
cV(a,b){var s,r,q=J.d(a.a,a.d)+4
for(s=0;s<4;++s)for(r=0;r<4;++r)A.bV(b,0,r,s,q)},
hc(a,b){var s=this,r=null
if(J.d(a.a,a.d)!==0)s.cV(a,b)
if(J.d(a.a,a.d+16)!==0)s.cV(A.p(a,r,16),A.p(b,r,4))
if(J.d(a.a,a.d+32)!==0)s.cV(A.p(a,r,32),A.p(b,r,128))
if(J.d(a.a,a.d+48)!==0)s.cV(A.p(a,r,48),A.p(b,r,132))}}
A.jr.prototype={}
A.ju.prototype={}
A.jw.prototype={}
A.eF.prototype={}
A.jv.prototype={}
A.jn.prototype={}
A.bE.prototype={}
A.eI.prototype={}
A.hJ.prototype={}
A.eJ.prototype={}
A.eK.prototype={}
A.eH.prototype={
cL(){var s,r,q,p,o=this,n=o.b
if(n.ai(8)!==47)return!1
s=n.ai(14)+1
r=n.ai(14)+1
q=n.ai(1)
o.dy=s
o.fr=r
p=o.c
p.f=B.az
p.a=s
p.b=r
p.d=q!==0
if(n.ai(3)!==0)return!1
return!0},
bP(){var s,r,q,p,o,n=this,m=null
n.f=0
if(!n.cL())return m
n.cw(n.dy,n.fr,!0)
n.ep(n.dy)
s=n.dy
n.d=A.Q(m,m,B.e,0,B.j,n.fr,m,0,4,m,B.e,s,!1)
s=n.cx
s.toString
r=n.c
q=r.a
p=r.b
if(!n.dA(s,q,p,p,n.gjz()))return m
s=r.w
if(s.length!==0){o=A.v(new A.al(s),!1,m,0)
s=n.d
s.toString
s.e=A.kJ(o)}return n.d},
ep(a){var s,r=this,q=r.c
q=q.a*q.b+a
s=new Uint32Array(q+a*16)
r.cx=s
r.cy=J.E(B.o.gB(s),0,null)
r.db=q
return!0},
k_(a){var s,r,q,p,o,n,m,l=this
t.L.a(a)
s=l.b
r=s.ai(2)
q=l.CW
p=B.a.R(1,r)
if((q&p)>>>0!==0)return!1
l.CW=(q|p)>>>0
o=new A.hI(B.cv)
B.c.G(l.ch,o)
if(!(r<4))return A.a(B.c4,r)
q=B.c4[r]
o.a=q
o.b=a[0]
o.c=a[1]
switch(q.a){case 0:case 1:s=s.ai(3)+2
o.e=s
o.d=l.cw(A.bW(o.b,s),A.bW(o.c,o.e),!1)
break
case 3:n=s.ai(8)+1
if(n>16)m=0
else if(n>4)m=1
else{s=n>2?2:3
m=s}B.c.h(a,0,A.bW(o.b,m))
o.e=m
o.d=l.cw(n,1,!1)
l.iP(n,o)
break
case 2:break}return!0},
cw(a,b,c){var s,r,q,p,o,n,m,l,k=this
if(c)for(s=k.b,r=t.t,q=b,p=a;s.ai(1)!==0;){o=A.j([p,q],r)
if(!k.k_(o))throw A.h(A.m("Invalid Transform"))
p=o[0]
q=o[1]}else{q=b
p=a}s=k.b
if(s.ai(1)!==0){n=s.ai(4)
if(!(n>=1&&n<=11))throw A.h(A.m("Invalid Color Cache"))}else n=0
if(!k.jN(p,q,n,c))throw A.h(A.m("Invalid Huffman Codes"))
if(n>0){s=B.a.R(1,n)
k.w=s
k.x=new A.js(new Uint32Array(s),32-n)}else k.w=0
s=k.c
s.a=p
s.b=q
m=k.z
k.Q=A.bW(p,m)
k.y=m===0?4294967295:B.a.R(1,m)-1
if(c){k.f=0
return null}l=new Uint32Array(p*q)
if(!k.dA(l,p,q,q,null))throw A.h(A.m("Failed to decode image data."))
k.f=0
return l},
dA(b7,b8,b9,c0,c1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6=this
t.e7.a(c1)
s=b6.f
r=B.a.aG(s,b8)
q=B.a.a8(s,b8)
p=b6.eR(q,r)
o=b6.f
n=b8*b9
m=b8*c0
s=b6.w
l=280+s
k=s>0?b6.x:null
j=b6.y
for(s=b7.length,i=b6.b,h=c1!=null,g=b7.$flags|0,f=i.b,e=f.c,d=o;o<m;){if((q&j)>>>0===0){c=b6.cz(b6.as,b6.Q,b6.z,q,r)
b=b6.ax
if(!(c<b.length))return A.a(b,c)
p=b[c]}a=0
if(p.d){b=p.c
g&2&&A.c(b7)
if(!(o>=0&&o<s))return A.a(b7,o)
b7[o]=b;++o;++q
if(q>=b8){++r
if(h&&r<=c0)c1.$2(r,!0)
if(k!=null)for(b=k.b,a0=k.a,a1=a0.$flags|0;d<o;){if(!(d>=0&&d<s))return A.a(b7,d)
a2=b7[d]
a3=B.a.a5(a2*506832829>>>0,b)
a1&2&&A.c(a0)
if(!(a3<a0.length))return A.a(a0,a3)
a0[a3]=a2;++d}q=a}continue}if(i.a>=32)i.cc()
if(p.e){a4=i.cR()&63
b=p.f
if(!(a4<b.length))return A.a(b,a4)
a5=b[a4]
b=a5.a
a0=i.a
if(b<256){b=i.a=a0+b
a0=a5.b
g&2&&A.c(b7)
if(!(o>=0&&o<s))return A.a(b7,o)
b7[o]=a0
a6=0}else{b=i.a=a0+(b-256)
a6=a5.b}if(f.d>=e&&b>=64)break
if(a6===0){++o;++q
if(q>=b8){++r
if(h&&r<=c0)c1.$2(r,!0)
if(k!=null)for(b=k.b,a0=k.a,a1=a0.$flags|0;d<o;){if(!(d>=0&&d<s))return A.a(b7,d)
a2=b7[d]
a3=B.a.a5(a2*506832829>>>0,b)
a1&2&&A.c(a0)
if(!(a3<a0.length))return A.a(a0,a3)
a0[a3]=a2;++d}q=a}continue}}else a6=p.cj(0,i)
if(a6<256){if(p.b){b=p.c
g&2&&A.c(b7)
if(!(o>=0&&o<s))return A.a(b7,o)
b7[o]=(b|a6<<8)>>>0}else{a7=p.cj(1,i)
if(i.a>=32)i.cc()
a8=A.no(p.cj(2,i),a6,a7,p.cj(3,i))
g&2&&A.c(b7)
if(!(o>=0&&o<s))return A.a(b7,o)
b7[o]=a8}++o;++q
if(q>=b8){++r
if(h&&r<=c0)c1.$2(r,!0)
if(k!=null)for(b=k.b,a0=k.a,a1=a0.$flags|0;d<o;){if(!(d>=0&&d<s))return A.a(b7,d)
a2=b7[d]
a3=B.a.a5(a2*506832829>>>0,b)
a1&2&&A.c(a0)
if(!(a3<a0.length))return A.a(a0,a3)
a0[a3]=a2;++d}q=a}}else if(a6<280){a9=b6.d6(a6-256)
b0=p.cj(4,i)
if(i.a>=32)i.cc()
b1=b6.f7(b8,b6.d6(b0))
if(f.d>=e&&i.a>=64)break
if(o<b1||n-o<a9)return!1
else{b2=o-b1
for(b3=0;b3<a9;++b3){b=o+b3
a0=b2+b3
if(!(a0>=0&&a0<s))return A.a(b7,a0)
a0=b7[a0]
g&2&&A.c(b7)
if(!(b>=0&&b<s))return A.a(b7,b)
b7[b]=a0}}o+=a9
q+=a9
while(q>=b8){q-=b8;++r
if(h&&r<=c0)c1.$2(r,!0)}if((q&j)>>>0!==0){c=b6.cz(b6.as,b6.Q,b6.z,q,r)
b=b6.ax
if(!(c<b.length))return A.a(b,c)
p=b[c]}if(k!=null)for(b=k.b,a0=k.a,a1=a0.$flags|0;d<o;){if(!(d>=0&&d<s))return A.a(b7,d)
a2=b7[d]
a3=B.a.a5(a2*506832829>>>0,b)
a1&2&&A.c(a0)
if(!(a3<a0.length))return A.a(a0,a3)
a0[a3]=a2;++d}}else if(a6<l){a3=a6-280
while(d<o){k.toString
if(!(d>=0&&d<s))return A.a(b7,d)
b=b7[d]
b4=B.a.a5(b*506832829>>>0,k.b)
a0=k.a
a0.$flags&2&&A.c(a0)
if(!(b4<a0.length))return A.a(a0,b4)
a0[b4]=b;++d}b=k.a
a0=b.length
if(!(a3<a0))return A.a(b,a3)
a1=b[a3]
g&2&&A.c(b7)
if(!(o>=0&&o<s))return A.a(b7,o)
b7[o]=a1;++o;++q
if(q>=b8){++r
if(h&&r<=c0)c1.$2(r,!0)
for(a1=k.b,a2=b.$flags|0;d<o;){if(!(d>=0&&d<s))return A.a(b7,d)
b5=b7[d]
a3=B.a.a5(b5*506832829>>>0,a1)
a2&2&&A.c(b)
if(!(a3<a0))return A.a(b,a3)
b[a3]=b5;++d}q=a}}else return!1}if(h)c1.$2(r>c0?c0:r,!1)
b6.f=o
return!0},
jf(){var s,r,q,p,o,n,m,l
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
iQ(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g=this
if(b&&B.a.a8(a,16)!==0)return
s=g.r
r=a-s
q=g.dy
p=q*s
while(r>0){o=r>16?16:r
n=q*o
m=q*s
l=g.db
g.eq(s,o,p)
for(q=g.dx,k=g.cx,j=0;j<n;++j){q.toString
i=m+j
h=l+j
if(!(h<k.length))return A.a(k,h)
h=k[h]
q.$flags&2&&A.c(q)
if(!(i>=0&&i<q.length))return A.a(q,i)
q[i]=h>>>8&255}r-=o
q=g.dy
p+=o*q
s+=o}g.r=a},
ii(a1,a2,a3){var s,r,q,p,o,n,m,l,k,j,i=this,h="_pixels8",g=i.f,f=B.a.aG(g,a1),e=B.a.a8(g,a1),d=i.eR(e,f),c=i.f,b=a1*a2,a=a1*a3,a0=i.y
g=i.b
for(;;){s=g.b
if(!(!(s.d>=s.c&&g.a>=64)&&c<a))break
if((e&a0)>>>0===0){r=i.cz(i.as,i.Q,i.z,e,f)
s=i.ax
if(!(r<s.length))return A.a(s,r)
d=s[r]}if(g.a>=32)g.cc()
q=d.cj(0,g)
if(q<256){s=i.cy
s===$&&A.b(h)
s.$flags&2&&A.c(s)
if(!(c>=0&&c<s.length))return A.a(s,c)
s[c]=q;++c;++e
if(e>=a1){++f
if(B.a.a8(f,16)===0)i.dG(f)
e=0}}else if(q<280){p=i.d6(q-256)
o=d.cj(4,g)
if(g.a>=32)g.cc()
n=i.f7(a1,i.d6(o))
if(c>=n&&b-c>=p)for(s=i.cy,m=0;m<p;++m){s===$&&A.b(h)
l=c+m
k=l-n
j=s.length
if(!(k>=0&&k<j))return A.a(s,k)
k=s[k]
s.$flags&2&&A.c(s)
if(!(l>=0&&l<j))return A.a(s,l)
s[l]=k}else{i.f=c
return!0}c+=p
e+=p
while(e>=a1){e-=a1;++f
if(B.a.a8(f,16)===0)i.dG(f)}if(c<a&&(e&a0)>>>0!==0){r=i.cz(i.as,i.Q,i.z,e,f)
s=i.ax
if(!(r<s.length))return A.a(s,r)
d=s[r]}}else return!1}i.dG(f)
i.f=c
return!0},
dG(a){var s,r,q=this,p=q.r,o=a-p,n=q.cy
n===$&&A.b("_pixels8")
s=A.v(n,!1,null,q.c.a*p)
if(o>0){n=q.dx
n.toString
r=A.v(n,!1,null,q.dy*p)
n=q.ch
if(0>=n.length)return A.a(n,0)
n[0].kk(p,p+o,s,r)}q.r=a},
jA(a,b){var s,r,q,p,o,n,m=this,l=m.c.a,k=m.r
if(b)if(B.a.a8(a,16)!==0)return
s=a-k
if(s<=0){m.r=a
return}m.eq(k,s,l*k)
for(r=m.db,q=m.r,p=0;p<s;++p,++q)for(o=0;o<m.dy;++o,++r){l=m.cx
if(!(r>=0&&r<l.length))return A.a(l,r)
n=l[r]
l=m.d.a
if(l!=null)l.aq(o,q,n>>>16&255,n>>>8&255,n&255,n>>>24&255)}m.r=a},
eq(a,b,c){var s,r,q,p,o=this,n=o.ch,m=n.length,l=o.c.a,k=a+b,j=o.db
for(s=c;r=m-1,m>0;s=j,m=r){if(!(r>=0&&r<n.length))return A.a(n,r)
q=n[r]
p=o.cx
p.toString
q.kK(a,k,p,s,p,j)}if(s!==j){n=o.cx
n.toString
B.o.ar(n,j,j+l*b,n,s)}},
jN(a,b,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1,c=null
if(a1&&e.b.ai(1)!==0){s=2+e.b.ai(3)
r=A.bW(a,s)
q=A.bW(b,s)
p=r*q
o=e.cw(r,q,!1)
if(o==null)return!1
e.z=s
for(n=o.length,m=o.$flags|0,l=d,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
j=o[k]>>>8&65535
m&2&&A.c(o)
o[k]=j
if(j>=l)l=j+1}if(l>1000||l>a*b){c=new Int32Array(1)
B.Z.aO(c,0,1,255)
for(d=0,k=0;k<p;++k){if(!(k<n))return A.a(o,k)
i=o[k]
if(!(i<1))return A.a(c,i)
if(c[i]===-1){h=d+1
c[i]=d
d=h}g=c[i]
m&2&&A.c(o)
o[k]=g}}else d=l}else{o=null
l=1}n=e.b
m=n.b
if(m.d>=m.c&&n.a>=64)return!1
f=e.jO(a0,d,l,c)
if(f==null)return!1
e.as=o
e.at=d
e.ax=f
return!0},
dX(a,b,c,d,e,f){var s,r=a.a,q=a.b,p=d
do{p-=c
s=q+(b+p)
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
s.a=e
s.b=f}while(p>0)},
jj(a,b,c){var s=B.a.V(1,b-c)
while(b<15){s-=a[b]
if(s<=0)break;++b
s=s<<1>>>0}return b-c},
eV(a,b){var s=B.a.V(1,b-1)
while((a&s)>>>0!==0)s=s>>>1
return s!==0?((a&s-1)>>>0)+s:a},
ev(a5,a6,a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=this,a2=B.a.R(1,a6),a3=new Int32Array(16),a4=new Int32Array(16)
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
a9.$flags&2&&A.c(a9)
if(!(m>=0&&m<a9.length))return A.a(a9,m)
a9[m]=r}else{if(!(n<16))return A.a(a4,n)
a4[n]=a4[n]+1}}if(a4[15]===1){if(q){a5.toString
if(0>=a9.length)return A.a(a9,0)
a1.dX(a5,0,1,a2,0,a9[0])}return a2}l=a2-1
for(s=a5==null,k=0,j=1,i=1,r=0,p=1,h=2;p<=a6;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
if(!(p<16))return A.a(a3,p)
i-=a3[p]
if(i<0)return 0
if(s)continue
for(g=p&255;a3[p]>0;a3[p]=a3[p]-1,r=f){f=r+1
if(!(r>=0&&r<a9.length))return A.a(a9,r)
a1.dX(a5,k,h,a2,g,a9[r])
k=a1.eV(k,p)}}for(p=a6+1,s=!s,e=a2,d=0,c=4294967295,h=2;p<=15;++p,h=h<<1>>>0){i=i<<1>>>0
j+=i
i-=a3[p]
if(i<0)return 0
for(g=p-a6&255;a3[p]>0;a3[p]=a3[p]-1){b=(k&l)>>>0
if(b!==c){if(s)d+=e
a=a1.jj(a3,p,a6)
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
a1.dX(a5,d+B.a.a4(k,a6),h,e,g,a0)
r=f}k=a1.eV(k,p)}}if(j!==2*a4[15]-1)return 0
return a2},
fq(a,b,c,d){var s,r,q,p,o,n,m=this.ev(null,b,c,d,null)
if(m===0||a==null)return m
s=a.b
r=s.d
q=s.e
if(r+m>=q){p=new A.dO()
if(m>q)q=m
o=A.kN(q)
p.e=q
p.b=p.a=o
a.b=p
s=p}n=new Uint16Array(d)
this.ev(s.b,b,c,d,n)
return m},
jM(a,b,a0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c=new A.fB(new A.dO())
c.ek(128)
if(this.fq(c,7,a,19)===0)return!1
s=this.b
if(s.ai(1)!==0){r=2+s.ai(2+2*s.ai(3))
if(r>b)return!1}else r=b
for(q=8,p=0;p<b;r=o){o=r-1
if(r===0)break
if(s.a>=32)s.cc()
n=c.b.a
n.toString
m=n.a
n=n.b+(s.cR()&127)
if(!(n<m.length))return A.a(m,n)
l=m[n]
s.a=s.a+l.a
k=l.b
if(k<16){j=p+1
a0.$flags&2&&A.c(a0)
if(!(p>=0&&p<a0.length))return A.a(a0,p)
a0[p]=k
if(k!==0)q=k
p=j}else{i=k-16
if(!(i<3))return A.a(B.br,i)
h=B.br[i]
g=B.dP[i]
f=s.ai(h)+g
if(p+f>b)return!1
e=k===16?q:0
for(n=a0.$flags|0;d=f-1,f>0;f=d,p=j){j=p+1
n&2&&A.c(a0)
if(!(p>=0&&p<a0.length))return A.a(a0,p)
a0[p]=e}}}return!0},
fc(a,b,c){var s,r,q,p,o,n,m,l=this.b,k=l.ai(1)
B.Z.aO(b,0,a,0)
if(k!==0){s=l.ai(1)
r=l.ai(l.ai(1)===0?1:8)
b.$flags&2&&A.c(b)
q=b.length
if(!(r<q))return A.a(b,r)
b[r]=1
if(s+1===2){r=l.ai(8)
if(!(r<q))return A.a(b,r)
b[r]=1}p=!0}else{o=new Int32Array(19)
n=l.ai(4)+4
for(m=0;m<n;++m){if(!(m<19))return A.a(B.bQ,m)
s=B.bQ[m]
q=l.ai(3)
if(!(s<19))return A.a(o,s)
o[s]=q}p=this.jM(o,a,b)}if(p){s=l.b
p=!(s.d>=s.c&&l.a>=64)}else p=!1
return p?this.fq(c,8,b,a):0},
cZ(a,b,c){var s=c.a,r=a.a
c.a=s+r
c.b=(c.b|B.a.R(a.b,b))>>>0
return r},
i1(a){var s,r,q,p,o,n,m,l,k,j,i=this
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
j=B.a.a4(o,i.cZ(k,8,n))
if(1>=r)return A.a(s,1)
m=s[1]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a4(j,i.cZ(l[m],16,n))
if(2>=r)return A.a(s,2)
m=s[2]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
j=B.a.a4(j,i.cZ(l[m],0,n))
if(3>=r)return A.a(s,3)
m=s[3]
l=m.a
m=m.b+j
if(!(m<l.length))return A.a(l,m)
B.a.a4(j,i.cZ(l[m],24,n))}}},
jO(a9,b0,b1,b2){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null,a7=a9>0,a8=280+(a7?B.a.R(1,a9):0)
if(!(a9<12))return A.a(B.bB,a9)
s=B.bB[a9]
r=b2==null
if(r&&b0!==b1)return a6
q=new Int32Array(a8)
p=J.am(b0,t.ct)
for(o=0;o<b0;++o)p[o]=A.oh()
n=new A.fB(new A.dO())
n.ek(b0*s)
a5.ay=n
for(n=!r,m=0;m<b1;++m){if(n){if(!(m<b2.length))return A.a(b2,m)
l=b2[m]===-1}else l=!1
if(l)for(k=0;k<5;++k){j=B.bE[k]
if(a5.fc(k===0&&a7?j+B.a.R(1,a9):j,q,a6)===0)return a6}else{if(r)l=m
else{if(!(m<b2.length))return A.a(b2,m)
l=b2[m]}if(!(l>=0&&l<b0))return A.a(p,l)
i=p[l]
h=i.a
for(l=h.length,g=0,f=!0,e=0,k=0;k<5;++k){j=B.bE[k]
if(k===0&&a7)j+=B.a.R(1,a9)
d=a5.fc(j,q,a5.ay)
c=a5.ay.b.b
c.toString
B.c.h(h,k,c)
if(d===0)return a6
if(f&&B.hV[k]===1){if(!(k<l))return A.a(h,k)
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
c.b=new A.dM(b.a,b.b+d)
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
if(l)a5.i1(i)}}return p},
d6(a){var s
if(a<4)return a+1
s=B.a.j(a-2,1)
return B.a.R(2+(a&1),s)+this.b.ai(s)+1},
f7(a,b){var s,r,q
if(b>120)return b-120
else{s=b-1
if(!(s>=0))return A.a(B.bF,s)
r=B.bF[s]
q=(r>>>4)*a+(8-(r&15))
return q>=1?q:1}},
iP(a,b){var s,r,q,p,o,n,m,l,k=B.a.R(1,B.a.a4(8,b.e)),j=new Uint32Array(k),i=b.d
i.toString
s=J.E(B.o.gB(i),0,null)
r=J.E(B.o.gB(j),0,null)
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
o&2&&A.c(r)
if(!(n<p))return A.a(r,n)
r[n]=m+l&255}for(q=4*k;n<q;++n){o&2&&A.c(r)
if(!(n<p))return A.a(r,n)
r[n]=0}b.d=j
return!0},
cz(a,b,c,d,e){var s
if(c===0||a==null)return 0
s=b*B.a.j(e,c)+B.a.j(d,c)
if(!(s<a.length))return A.a(a,s)
return a[s]},
eR(a,b){var s=this,r=s.cz(s.as,s.Q,s.z,a,b),q=s.ax
if(!(r<q.length))return A.a(q,r)
return q[r]}}
A.fX.prototype={
kA(a,b){return this.iQ(a,b)}}
A.hH.prototype={
cR(){var s,r,q,p=this.a
if(p<32){s=this.c
r=B.a.a5(s[0],p)
s=s[1]
if(!(p>=0))return A.a(B.a3,p)
q=r+((s&B.a3[p])>>>0)*(B.a3[32-p]+1)}else{s=this.c
q=p===32?s[1]:B.a.a5(s[1],p-32)}return q},
ai(a){var s,r=this,q=r.b
if(!(q.d>=q.c&&r.a>=64)&&a<25){q=r.cR()
if(!(a<33))return A.a(B.a3,a)
s=B.a3[a]
r.a+=a
r.cc()
return(q&s)>>>0}else throw A.h(A.m("Not enough data in input."))},
cc(){var s,r,q,p=this,o=p.b,n=p.c,m=n.$flags|0,l=o.c
for(;;){if(!(p.a>=8&&o.d<l))break
s=J.d(o.a,o.d++)
r=n[0]
q=n[1]
m&2&&A.c(n)
n[0]=(r>>>8)+(q&255)*16777216
n[1]=q>>>8
n[1]=(n[1]|s*16777216)>>>0
p.a-=8}}}
A.js.prototype={}
A.cs.prototype={
a6(){return"VP8LImageTransformType."+this.b}}
A.hI.prototype={
kK(a,b,c,d,e,f){var s,r,q,p,o=this,n=o.b
switch(o.a.a){case 2:o.kf(e,f,(b-a)*n)
break
case 0:o.kO(a,b,c,d,e,f)
if(b!==o.c){s=f-n
B.o.ar(e,s,s+n,c,f+(b-a-1)*n)}break
case 1:o.kl(a,b,c,d,e,f)
break
case 3:if(d===f&&o.e>0){r=b-a
q=r*A.bW(n,o.e)
p=f+r*n-q
B.o.ar(e,p,p+q,c,f)
o.fP(a,b,c,p,e,f)}else o.fP(a,b,c,d,e,f)
break}},
kk(a,b,c,d){var s,r,q,p,o,n,m=this.e,l=B.a.a4(8,m),k=this.b,j=this.d
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
fP(a,b,c,d,e,f){var s,r,q,p,o,n,m,l,k,j=this.e,i=B.a.a4(8,j),h=this.b,g=this.d
if(i<8){s=B.a.R(1,j)-1
r=B.a.R(1,i)-1
for(j=e.$flags|0,q=c.length,p=a;p<b;++p)for(o=0,n=0;n<h;++n,f=l){if((n&s)>>>0===0){m=d+1
if(!(d>=0&&d<q))return A.a(c,d)
o=c[d]>>>8&255
d=m}l=f+1
k=o&r
if(!(k>=0&&k<g.length))return A.a(g,k)
k=g[k]
j&2&&A.c(e)
if(!(f>=0&&f<e.length))return A.a(e,f)
e[f]=k
o=B.a.a4(o,i)}}else for(j=c.length,q=e.$flags|0,p=a;p<b;++p)for(n=0;n<h;++n,f=l,d=m){l=f+1
g.toString
m=d+1
if(!(d>=0&&d<j))return A.a(c,d)
k=c[d]>>>8&255
if(!(k<g.length))return A.a(g,k)
k=g[k]
q&2&&A.c(e)
if(!(f>=0&&f<e.length))return A.a(e,f)
e[f]=k}},
kl(a5,a6,a7,a8,a9,b0){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a=this,a0=a.b,a1=a.e,a2=B.a.R(1,a1)-1,a3=A.bW(a0,a1),a4=B.a.j(a5,a.e)*a3
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
if(!(l>=0&&l<a1))return A.a(a7,l)
l=a7[l]
k=l>>>8&255
j=q[0]
i=$.ap()
i.$flags&2&&A.c(i)
i[0]=j
j=$.ay()
if(0>=j.length)return A.a(j,0)
h=j[0]
i[0]=k
g=j[0]
f=$.i4()
f.$flags&2&&A.c(f)
f[0]=h*g
e=$.kz()
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
s&2&&A.c(a9)
if(!(n<a9.length))return A.a(a9,n)
a9[n]=(l&4278255360|d<<16|((l&255)+(c>>>5)>>>0)+(b>>>5)>>>0&255)>>>0}b0+=a0
a8+=a0;++r
if((r&a2)>>>0===0)a4+=a3}},
ck(a,b){return(((a&4278255360)>>>0)+((b&4278255360)>>>0)&4278255360|(a&16711935)+(b&16711935)&16711935)>>>0},
kO(b1,b2,b3,b4,b5,b6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8=this,a9=4278190080,b0=a8.b
if(b1===0){s=b3.length
if(!(b4>=0&&b4<s))return A.a(b3,b4)
r=a8.ck(b3[b4],a9)
b5.$flags&2&&A.c(b5)
q=b5.length
if(!(b6<q))return A.a(b5,b6)
b5[b6]=r
p=b4+1
o=b6+1
n=b0-1
m=b5[b6]
for(r=b5.$flags|0,l=0;l<n;++l){k=p+l
if(!(k<s))return A.a(b3,k)
m=a8.ck(b3[k],m)
k=o+l
r&2&&A.c(b5)
if(!(k<q))return A.a(b5,k)
b5[k]=m}b4+=b0
b6+=b0;++b1}s=a8.e
j=B.a.R(1,s)
i=j-1
h=A.bW(b0,s)
g=B.a.j(b1,a8.e)*h
for(s=b3.length,r=~i,q=b5.length,f=b1;f<b2;){k=b6-b0
if(!(k>=0&&k<q))return A.a(b5,k)
e=b5[k]
if(!(b4>=0&&b4<s))return A.a(b3,b4)
k=a8.ck(b3[b4],e)
b5.$flags&2&&A.c(b5)
if(!(b6<q))return A.a(b5,b6)
b5[b6]=k
for(d=g,c=1;c<b0;c=a1,d=b){k=a8.d
b=d+1
if(!(d<k.length))return A.a(k,d)
a=k[d]>>>8&15
a0=$.pF[a]
a1=((c&r)>>>0)+j
if(a1>b0)a1=b0
a2=b4+c
k=b6+c
a3=k-b0
a4=a1-c
if(a===0)for(a5=b5.$flags|0,l=0;l<a4;++l){a6=k+l
a7=a2+l
if(!(a7>=0&&a7<s))return A.a(b3,a7)
a7=a8.ck(b3[a7],a9)
a5&2&&A.c(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=a7}else if(a===1){a5=k-1
if(!(a5>=0&&a5<q))return A.a(b5,a5)
m=b5[a5]
for(a5=b5.$flags|0,l=0;l<a4;++l){a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
m=a8.ck(b3[a6],m)
a6=k+l
a5&2&&A.c(b5)
if(!(a6>=0&&a6<q))return A.a(b5,a6)
b5[a6]=m}}else for(l=0;l<a4;++l){a5=k+l
a6=a5-1
if(!(a6>=0&&a6<q))return A.a(b5,a6)
e=a0.$3(b5[a6],b5,a3+l)
a6=a2+l
if(!(a6>=0&&a6<s))return A.a(b3,a6)
a6=a8.ck(b3[a6],e)
b5.$flags&2&&A.c(b5)
if(!(a5>=0&&a5<q))return A.a(b5,a5)
b5[a5]=a6}}b4+=b0
b6+=b0;++f
if((f&i)>>>0===0)g+=h}},
kf(a,b,c){var s,r,q,p,o,n
for(s=a.length,r=a.$flags|0,q=0;q<c;++q){p=b+q
if(!(p<s))return A.a(a,p)
o=a[p]
n=o>>>8&255
r&2&&A.c(a)
a[p]=(o&4278255360|(o&16711935)+(n<<16|n)&16711935)>>>0}}}
A.jy.prototype={
gh0(){var s=this,r=s.d
if(r>1||s.e>=4||s.f>1||s.r!==0)return!1
return!0},
ko(a,b,c){var s,r,q,p,o,n,m=this
if(!m.gh0())return!1
s=m.e
if(!(s<4))return A.a(B.c9,s)
r=B.c9[s]
if(m.d===0){s=m.b
q=a*s
p=m.a
B.d.ar(c,q,b*s,p.a,p.d-p.b+q)}else{s=a+b
p=m.x
p===$&&A.b("_vp8l")
p.dx=c
o=p.c
if(m.y)s=p.ii(o.a,o.b,s)
else{n=p.cx
n.toString
p=p.dA(n,o.a,o.b,s,t.d6.a(p.gkz()))
s=p}if(!s)return!1}if(r!=null){s=m.b
r.$6(s,m.c,s,a,b,c)}if(m.f===1)if(!m.iI(c,m.b,m.c,a,b))return!1
if(a+b>=m.c)m.w=!0
return!0},
iI(a,b,c,d,e){if(b<=0||c<=0||d<0||e<0||d+e>c)return!1
return!0}}
A.eL.prototype={
hS(a,b){var s=this,r=a.F()
s.r=0
s.f=(r&1)!==0
s.w=a.d-a.b
s.x=b-16}}
A.fY.prototype={}
A.fz.prototype={}
A.fA.prototype={}
A.dM.prototype={
gv(a){return this.a.length-this.b}}
A.dL.prototype={
cj(a,b){var s,r,q,p,o,n=b.cR()&255,m=this.a
if(!(a<m.length))return A.a(m,a)
s=m[a]
r=s.a
q=s.b+n
if(!(q<r.length))return A.a(r,q)
p=r[q].a-8
if(p>0){b.a+=8
o=b.cR()
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
A.dO.prototype={}
A.fB.prototype={
ek(a){var s=this.b=this.a,r=A.kN(a)
s.e=a
s.b=s.a=r}}
A.dl.prototype={
a6(){return"WebPFormat."+this.b}}
A.dm.prototype={$iK:1}
A.dW.prototype={}
A.jz.prototype={
cr(a){var s=A.v(t.L.a(a),!1,null,0)
this.b=s
if(!this.eQ(s))return!1
return!0},
b4(a){var s,r=this,q=null,p=A.v(t.L.a(a),!1,q,0)
r.b=p
if(!r.eQ(p))return q
p=new A.dW(B.a8,A.j([],t.J))
r.a=p
s=r.b
s.toString
if(!r.fs(s,p))return q
p=r.a
switch(p.f.a){case 3:p.as=p.z.length
return p
case 2:s=r.b
s.toString
s.d=p.ay
if(!A.li(s,p).cL())return q
p=r.a
p.as=p.z.length
return p
case 1:s=r.b
s.toString
s.d=p.ay
if(!A.lg(s,p).cL())return q
p=r.a
p.as=p.z.length
return p
case 0:throw A.h(A.m("Unknown format for WebP"))}},
ao(a){var s,r,q,p=this,o=p.b
if(o==null||p.a==null)return null
s=p.a
if(s.e){s=s.z
r=s.length
if(a>=r)return null
if(!(a<r))return A.a(s,a)
q=s[a]
s=q.x
s===$&&A.b("_frameSize")
r=q.w
r===$&&A.b("_framePosition")
return p.eH(o.c6(s,r),a)}r=s.f
if(r===B.az)return A.li(o.c6(s.ch,s.ay),s).bP()
else if(r===B.b3)return A.lg(o.c6(s.ch,s.ay),s).bP()
return null},
b6(a,b){var s,r,q,p,o,n,m,l,k=this,j=null
if(k.b4(t.L.a(a))==null)return j
s=k.a.e
if(!s)return k.ao(0)
for(r=j,q=r,p=0;s=k.a,p<s.as;++p){s=s.z
if(!(p<s.length))return A.a(s,p)
b=s[p]
o=k.ao(p)
if(o==null)continue
o.y=b.e
if(q==null||r==null){s=k.a
n=s.a
s=s.b
m=o.gaC()
l=o.a
l=l==null?j:l.gL()
if(l==null)l=B.e
q=A.Q(j,j,l,o.y,B.j,s,j,0,m,j,B.e,n,!1)
r=q}else{r=A.bv(r,!1,!1)
s=b.f
s===$&&A.b("clearFrame")
if(s){s=r.a
if(s!=null)s.b1(0,j)}}A.lv(r,o,B.aC,j,j,b.a,b.b,j,j,j,j)
q.aI(r)}return q},
eH(a,b){var s,r,q,p=null,o=A.j([],t.J),n=new A.dW(B.a8,o)
if(!this.fs(a,n))return p
s=n.f
if(s===B.a8)return p
n.as=this.a.as
if(n.e){s=o.length
if(b>=s)return p
r=o[b]
o=r.x
o===$&&A.b("_frameSize")
s=r.w
s===$&&A.b("_framePosition")
return this.eH(a.c6(o,s),b)}else{q=a.c6(n.ch,n.ay)
if(s===B.az)return A.li(q,n).bP()
else if(s===B.b3)return A.lg(q,n).bP()}return p},
eQ(a){if(a.ak(4)!=="RIFF")return!1
a.k()
if(a.ak(4)!=="WEBP")return!1
return!0},
fs(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g
for(s=a.c,r=a.b;a.d<s;){q=a.ak(4)
p=a.k()
o=p+1>>>1<<1>>>0
n=a.d
m=n-r
switch(q){case"VP8X":if(!this.j6(a,b))return!1
break
case"VP8 ":b.ay=m
b.ch=p
b.f=B.b3
break
case"VP8L":b.ay=m
b.ch=p
b.f=B.az
break
case"ALPH":b.toString
n=a.a
l=a.e
k=J.a9(n)
j=k.gv(n)
k=k.gv(n)
n=new A.af(n,0,Math.min(j,k),0,l)
b.at=n
n.d=a.d
a.d+=o
break
case"ANIM":b.f=B.lf
i=a.k()
n=new Uint8Array(4)
n[0]=i>>>8&255
n[1]=i>>>16&255
n[2]=i>>>24&255
n[3]=i&255
a.n()
break
case"ANMF":if(!this.j1(a,b,p))return!1
break
case"ICCP":b.toString
h=a.al(p)
a.d=n+(h.c-h.d)
h.a2()
break
case"EXIF":b.toString
b.w=a.ak(p)
break
case"XMP ":b.toString
a.ak(p)
break
default:a.d=n+o
break}n=a.d
g=o-(n-r-m)
if(g>0)a.d=n+g}if(!b.d)b.d=b.at!=null
return b.f!==B.a8},
j6(a,b){var s,r,q,p,o=a.F()
if((o&192)!==0)return!1
s=B.a.j(o,4)
r=B.a.j(o,1)
if((o&1)!==0)return!1
if(a.bp()!==0)return!1
q=a.bp()
p=a.bp()
b.a=q+1
b.b=p+1
b.e=(r&1)!==0
b.d=(s&1)!==0
return!0},
j1(a,b,c){var s,r=a.bp(),q=a.bp()
a.bp()
a.bp()
s=new A.fY(r*2,q*2,a.bp())
s.hS(a,c)
if(s.r!==0)return!1
B.c.G(b.z,s)
return!0}}
A.fC.prototype={
a6(){return"IccProfileCompression."+this.b}}
A.cQ.prototype={
km(){var s,r=this
if(r.b===B.aK)return r.c
s=B.b8.fW(t.L.a(r.c),null)
r.c=s
r.b=B.aK
return s},
kv(){var s,r=this
if(r.b===B.aJ)return r.c
s=B.D.c2(r.c)
r.c=s
r.b=B.aJ
return s}}
A.fy.prototype={
a6(){return"FrameType."+this.b}}
A.bu.prototype={
gah(){var s=this.x
return s===$?this.x=A.j([],t.g):s},
hM(a,b,c,d){var s,r,q,p=this,o=a.gL(),n=a.gaC(),m=a.a
p.eF(d,b,o,n,m==null?null:m.gM())
o=a.b
if(o!=null)p.b=A.e1(o,t.N,t.v)
o=a.d
if(o!=null){n=t.N
p.d=A.e1(o,n,n)}B.c.G(p.gah(),p)
if(!c){s=a.gah().length
for(o=t.g,r=1;r<s;++r){q=a.x
if(q===$)q=a.x=A.j([],o)
if(!(r<q.length))return A.a(q,r)
p.aI(A.fH(q[r],b,!1,d))}}},
hL(a,b,c){var s,r,q,p,o=this,n=a.b
if(n!=null)o.b=A.e1(n,t.N,t.v)
n=a.d
if(n!=null){s=t.N
o.d=A.e1(n,s,s)}B.c.G(o.gah(),o)
if(!b&&a.gah().length>1){r=a.gah().length
for(n=t.g,q=1;q<r;++q){p=a.x
if(p===$)p=a.x=A.j([],n)
if(!(q<p.length))return A.a(p,q)
o.aI(A.bv(p[q],!1,!1))}}},
aI(a){var s=this
if(a==null)a=A.bv(s,!0,!0)
a.z=s.gah().length
if(s.gah().length===0||B.c.gh2(s.gah())!==a)B.c.G(s.gah(),a)
return a},
di(){return this.aI(null)},
eF(a,b,c,d,e){var s,r,q=this,p=null
switch(c.a){case 0:if(e==null){s=B.b.bb(a*d/8)
r=new A.cU($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bb(a/8)
r=new A.cU($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 1:if(e==null){s=B.b.bb(a*(d<<1>>>0)/8)
r=new A.cW($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bb(a/4)
r=new A.cW($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 2:if(e==null){if(d===2)s=a
else if(d===4)s=a*2
else s=d===3?B.b.bb(a*1.5):B.b.bb(a/2)
r=new A.cY($,s,p,a,b,d)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}else{s=B.b.bb(a/2)
r=new A.cY($,s,e,a,b,1)
s=Math.max(s*b,1)
r.d=new Uint8Array(s)
q.a=r}break
case 3:if(e==null)q.a=A.md(a,b,d)
else q.a=new A.cZ(new Uint8Array(a*b),e,a,b,1)
break
case 4:s=a*b
if(e==null)q.a=new A.cV(new Uint16Array(s*d),p,a,b,d)
else q.a=new A.cV(new Uint16Array(s),e,a,b,1)
break
case 5:q.a=A.ol(a,b,d)
break
case 6:q.a=new A.dT(new Int8Array(a*b*d),a,b,d)
break
case 7:q.a=new A.dR(new Int16Array(a*b*d),a,b,d)
break
case 8:q.a=new A.dS(new Int32Array(a*b*d),a,b,d)
break
case 9:q.a=A.oj(a,b,d)
break
case 10:q.a=A.ok(a,b,d)
break
case 11:q.a=new A.dQ(new Float64Array(a*b*4*d),a,b,d)
break}},
C(a){var s=this
return"Image("+s.gS()+", "+s.gK()+", "+s.gL().b+", "+s.gaC()+")"},
gS(){var s=this.a
s=s==null?null:s.a
return s==null?0:s},
gK(){var s=this.a
s=s==null?null:s.b
return s==null?0:s},
gL(){var s=this.a
s=s==null?null:s.gL()
return s==null?B.e:s},
gbF(){var s=this.e
return s==null?this.e=new A.bL(A.I(t.N,t.P)):s},
hp(a,b){var s=this,r=s.b;(r==null?s.b=A.I(t.N,t.v):r).h(0,a,b)
if(s.b.a===0)s.b=null},
gH(a){var s=this.a
return s.gH(s)},
gB(a){var s=this.a
s=s==null?null:s.gB(s)
if(s==null)s=B.d.gB(new Uint8Array(0))
return s},
a2(){var s=this.a
s=s==null?null:J.az(s.gB(s))
return s==null?J.az(this.gB(0)):s},
gcP(a){var s=this.a
s=s==null?null:J.nN(s.gB(s))
return s==null?0:s},
gaC(){var s=this.a
s=s==null?null:s.gM()
s=s==null?null:s.b
if(s==null){s=this.a
s=s==null?null:s.c}return s==null?0:s},
gaY(){var s=this.a
s=s==null?null:s.gaY()
return s===!0},
gaK(){var s=this.a
return(s==null?null:s.gM())!=null},
gaJ(){var s=this.a
s=s==null?null:s.gaJ()
return s==null?0:s},
fZ(a,b){return a>=0&&b>=0&&a<this.gS()&&b<this.gK()},
b_(a,b,c,d){var s=this.a
s=s==null?null:s.b_(a,b,c,d)
if(s==null)s=new A.bK(new Uint8Array(0))
return s},
N(a,b,c){var s=this.a
s=s==null?null:s.N(a,b,c)
return s==null?new A.D():s},
aR(a,b){return this.N(a,b,null)},
ap(a,b){if(a<0||a>=this.gS()||b<0||b>=this.gK())return new A.D()
return this.N(a,b,null)},
hk(a,b,c){switch(c.a){case 0:return this.ap(B.b.i(a),B.b.i(b))
case 1:case 3:return this.hl(a,b)
case 2:return this.hj(a,b)}},
hl(a,b){var s,r,q,p,o,n,m=this,l=B.b.i(a),k=l-(a>=0?0:1),j=k+1
l=B.b.i(b)
s=l-(b>=0?0:1)
r=s+1
l=new A.iy(a-k,b-s)
q=m.ap(k,s)
p=r>=m.gK()?q:m.ap(k,r)
o=j>=m.gS()?q:m.ap(j,s)
n=j>=m.gS()||r>=m.gK()?q:m.ap(j,r)
return m.b_(l.$4(q.gm(),o.gm(),p.gm(),n.gm()),l.$4(q.gt(),o.gt(),p.gt(),n.gt()),l.$4(q.gu(),o.gu(),p.gu(),n.gu()),l.$4(q.gA(),o.gA(),p.gA(),n.gA()))},
hj(d2,d3){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6=this,c7=B.b.i(d2),c8=c7-(d2>=0?0:1),c9=c8-1,d0=c8+1,d1=c8+2
c7=B.b.i(d3)
s=c7-(d3>=0?0:1)
r=s-1
q=s+1
p=s+2
o=d2-c8
n=d3-s
c7=new A.ix()
m=c6.ap(c8,s)
l=c9<0
k=!l
j=!k||r<0?m:c6.ap(c9,r)
i=l?m:c6.ap(c8,r)
h=r<0
g=h||d0>=c6.gS()?m:c6.ap(d0,r)
f=d1>=c6.gS()||h?m:c6.ap(d1,r)
e=c7.$5(o,j.gm(),i.gm(),g.gm(),f.gm())
d=c7.$5(o,j.gt(),i.gt(),g.gt(),f.gt())
c=c7.$5(o,j.gu(),i.gu(),g.gu(),f.gu())
b=c7.$5(o,j.gA(),i.gA(),g.gA(),f.gA())
a=l?m:c6.ap(c9,s)
a0=d0>=c6.gS()?m:c6.ap(d0,s)
a1=d1>=c6.gS()?m:c6.ap(d1,s)
a2=c7.$5(o,a.gm(),m.gm(),a0.gm(),a1.gm())
a3=c7.$5(o,a.gt(),m.gt(),a0.gt(),a1.gt())
a4=c7.$5(o,a.gu(),m.gu(),a0.gu(),a1.gu())
a5=c7.$5(o,a.gA(),m.gA(),a0.gA(),a1.gA())
a6=!k||q>=c6.gK()?m:c6.ap(c9,q)
a7=q>=c6.gK()?m:c6.ap(c8,q)
a8=d0>=c6.gS()||q>=c6.gK()?m:c6.ap(d0,q)
a9=d1>=c6.gS()||q>=c6.gK()?m:c6.ap(d1,q)
b0=c7.$5(o,a6.gm(),a7.gm(),a8.gm(),a9.gm())
b1=c7.$5(o,a6.gt(),a7.gt(),a8.gt(),a9.gt())
b2=c7.$5(o,a6.gu(),a7.gu(),a8.gu(),a9.gu())
b3=c7.$5(o,a6.gA(),a7.gA(),a8.gA(),a9.gA())
b4=!k||p>=c6.gK()?m:c6.ap(c9,p)
b5=p>=c6.gK()?m:c6.ap(c8,p)
b6=d0>=c6.gS()||p>=c6.gK()?m:c6.ap(d0,p)
b7=d1>=c6.gS()||p>=c6.gK()?m:c6.ap(d1,p)
b8=c7.$5(o,b4.gm(),b5.gm(),b6.gm(),b7.gm())
b9=c7.$5(o,b4.gt(),b5.gt(),b6.gt(),b7.gt())
c0=c7.$5(o,b4.gu(),b5.gu(),b6.gu(),b7.gu())
c1=c7.$5(o,b4.gA(),b5.gA(),b6.gA(),b7.gA())
c2=c7.$5(n,e,a2,b0,b8)
c3=c7.$5(n,d,a3,b1,b9)
c4=c7.$5(n,c,a4,b2,c0)
c5=c7.$5(n,b,a5,b3,c1)
return c6.b_(B.b.i(c2),B.b.i(c3),B.b.i(c4),B.b.i(c5))},
c5(a,b,c){var s
if(t.dv.b(c))if(c.gbd().gM()!=null)if(this.gaK()){s=this.a
if(s!=null)s.Y(a,b,c.gT(),0,0)
return}s=this.a
if(s!=null)s.aq(a,b,c.gm(),c.gt(),c.gu(),c.gA())},
gE(){var s=this.a
s=s==null?null:s.gE()
return s==null?0:s},
b1(a,b){var s=this.a
return s==null?null:s.b1(0,b)},
kj(a){return this.b1(0,null)},
cJ(a7,a8,a9){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5=this,a6=null
if(a7==null)a7=a5.gL()
if(a8==null)a8=a5.gaC()
s=B.ce.l(0,a7)
r=!1
if(a7===a5.gL())if(a8===a5.gaC()){if(!a9){q=a5.a
q=(q==null?a6:q.gM())==null}else q=!1
if(!q){if(a9){r=a5.a
r=(r==null?a6:r.gM())!=null}}else r=!0}if(r)return A.bv(a5,!1,!1)
for(r=a5.gah(),q=r.length,p=t.N,o=t.p,n=a6,m=0;m<r.length;r.length===q||(0,A.a1)(r),++m,n=d){l=r[m]
k=l.a
j=k==null
i=j?a6:k.a
if(i==null)i=0
k=j?a6:k.b
if(k==null)k=0
j=l.e
j=j==null?a6:A.dD(j)
h=l.c
if(h==null)h=a6
else{g=h.a
f=h.b
h=h.c
h=new A.cQ(g,f,new Uint8Array(h.subarray(0,A.b4(0,a6,h.length))))}g=l.w
f=l.r
e=A.Q(a6,j,a7,l.y,g,k,h,f,a8,a6,B.e,i,a9)
k=l.d
e.sl2(k!=null?A.e1(k,p,p):a6)
if(n!=null){n.aI(e)
d=n}else d=e
k=e.a
c=k==null?a6:k.gM()
k=e.a
k=k==null?a6:k.gM()
b=k==null?a6:k.gL()
if(b==null)b=a7
k=l.a
if(c!=null){a=A.I(o,o)
a0=k==null?a6:k.N(0,0,a6)
if(a0==null)a0=new A.D()
for(k=e.a,k=k.gH(k),a1=a6,a2=0;k.D();){a3=k.gO()
a4=A.no(B.b.bl(a0.gae()*255),B.b.bl(a0.gaa()*255),B.b.bl(a0.gad()*255),0)
if(a.ag(a4)){j=a.l(0,a4)
j.toString
a3.sT(j)}else{a.h(0,a4,a2)
a3.sT(a2)
a1=A.aJ(a0,s,b,a8,a1)
c.b0(a2,a1.gm(),a1.gt(),a1.gu());++a2}a0.D()}}else{a0=k==null?a6:k.N(0,0,a6)
if(a0==null)a0=new A.D()
for(k=e.a,k=k.gH(k);k.D();){A.aJ(a0,s,a6,a6,k.gO())
a0.D()}}}n.toString
return n},
aM(a){return this.cJ(a,null,!1)},
e1(a){return this.cJ(null,a,!1)},
ce(a,b){return this.cJ(a,null,b)},
cI(a,b){return this.cJ(a,b,!1)},
kh(a){var s,r,q,p
t.ck.a(a)
if(this.d==null){s=t.N
this.d=A.I(s,s)}for(s=new A.O(a,a.r,a.e,A.l(a).q("O<1>"));s.D();){r=s.d
q=this.d
q.toString
p=a.l(0,r)
p.toString
q.h(0,r,p)}},
ia(a,b,c){var s,r=65536
switch(b.a){case 0:return null
case 1:return null
case 2:return null
case 3:s=a===B.m?r:256
return new A.aH(new Uint8Array(s*c),s,c)
case 4:s=a===B.m?r:256
return new A.em(new Uint16Array(s*c),s,c)
case 5:s=a===B.m?r:256
return new A.d6(new Uint32Array(s*c),s,c)
case 6:s=a===B.m?r:256
return new A.el(new Int8Array(s*c),s,c)
case 7:s=a===B.m?r:256
return new A.ej(new Int16Array(s*c),s,c)
case 8:s=a===B.m?r:256
return new A.ek(new Int32Array(s*c),s,c)
case 9:s=a===B.m?r:256
return new A.eg(new Uint16Array(s*c),s,c)
case 10:s=a===B.m?r:256
return new A.eh(new Float32Array(s*c),s,c)
case 11:s=a===B.m?r:256
return new A.ei(new Float64Array(s*c),s,c)}},
sl2(a){this.d=t.cZ.a(a)}}
A.iy.prototype={
$4(a,b,c,d){var s=this.b
return a+this.a*(b-a+s*(a+d-c-b))+s*(c-a)},
$S:28}
A.ix.prototype={
$5(a,b,c,d,e){var s=-b,r=a*a
return c+0.5*(a*(s+d)+r*(2*b-5*c+4*d-e)+r*a*(s+3*c-3*d+e))},
$S:29}
A.ae.prototype={
gM(){return null}}
A.cS.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Uint16Array(r.length)
else r=new Uint16Array(A.r(r))
return new A.cS(r,s.a,s.b,s.c)},
gL(){return B.E},
gbm(){return B.aI},
gB(a){return B.P.gB(this.d)},
gaJ(){return 16},
gbe(){return this.a*this.c*2},
gH(a){return A.kX(this)},
bf(a,b,c,d,e){return A.b1(A.kX(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gE(){return 1},
gaY(){return!0},
b_(a,b,c,d){var s=new Uint16Array(4),r=new A.cB(s)
s[0]=A.J(a)
s[1]=A.J(b)
s[2]=A.J(c)
s[3]=A.J(d)
s=r
return s},
N(a,b,c){if(c==null||!(c instanceof A.ce)||c.d!==this)c=A.kX(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=A.J(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.J(c)
o.$flags&2&&A.c(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=A.J(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){q=p+2
n=A.J(e)
if(!(q<s))return A.a(o,q)
o[q]=n}}},
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=A.J(c)
o.$flags&2&&A.c(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=n
if(q>1){n=p+1
r=A.J(d)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>2){n=p+2
r=A.J(e)
if(!(n<s))return A.a(o,n)
o[n]=r
if(q>3){q=p+3
n=A.J(f)
if(!(q<s))return A.a(o,q)
o[q]=n}}}},
C(a){return"ImageDataFloat16("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.cT.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Float32Array(r.length)
else r=new Float32Array(A.r(r))
return new A.cT(r,s.a,s.b,s.c)},
gL(){return B.M},
gbm(){return B.aI},
gB(a){return B.a4.gB(this.d)},
gaJ(){return 32},
gH(a){return A.kY(this)},
bf(a,b,c,d,e){return A.b1(A.kY(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gE(){return 1},
gbe(){return this.a*this.c*4},
gaY(){return!0},
b_(a,b,c,d){var s=new Float32Array(4),r=new A.cC(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
N(a,b,c){if(c==null||!(c instanceof A.cf)||c.d!==this)c=A.kY(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s=this.c,r=b*this.a*s+a*s
s=this.d
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.c(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q>1){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
if(q>2){q=p+2
if(!(q<s))return A.a(o,q)
o[q]=e}}},
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataFloat32("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.dQ.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Float64Array(r.length)
else r=new Float64Array(A.r(r))
return new A.dQ(r,s.a,s.b,s.c)},
gL(){return B.Q},
gbm(){return B.aI},
gB(a){return B.a5.gB(this.d)},
gv(a){return this.d.byteLength},
gaJ(){return 64},
gH(a){return A.kZ(this)},
bf(a,b,c,d,e){return A.b1(A.kZ(this),b,c,d,e)},
gE(){return 1},
gbe(){return this.a*this.c*8},
gaY(){return!0},
b_(a,b,c,d){var s=new Float64Array(4),r=new A.cD(s)
s[0]=a
s[1]=b
s[2]=c
s[3]=d
s=r
return s},
N(a,b,c){if(c==null||!(c instanceof A.cg)||c.d!==this)c=A.kZ(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s=this.c,r=b*this.a*s+a*s
s=this.d
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.c(o)
s=o.length
if(!(p>=0&&p<s))return A.a(o,p)
o[p]=c
if(q>1){r=p+1
if(!(r<s))return A.a(o,r)
o[r]=d
if(q>2){q=p+2
if(!(q<s))return A.a(o,q)
o[q]=e}}},
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataFloat64("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.dR.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Int16Array(r.length)
else r=new Int16Array(A.r(r))
return new A.dR(r,s.a,s.b,s.c)},
gL(){return B.S},
gbm(){return B.aH},
gB(a){return B.aw.gB(this.d)},
gH(a){return A.l_(this)},
bf(a,b,c,d,e){return A.b1(A.l_(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gE(){return 32767},
gaY(){return!0},
gaJ(){return 16},
gbe(){return this.a*this.c*2},
b_(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int16Array(4),n=new A.cE(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
N(a,b,c){if(c==null||!(c instanceof A.ch)||c.d!==this)c=A.l_(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataInt16("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.dS.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Int32Array(r.length)
else r=new Int32Array(A.r(r))
return new A.dS(r,s.a,s.b,s.c)},
gL(){return B.T},
gbm(){return B.aH},
gB(a){return B.Z.gB(this.d)},
gaJ(){return 32},
gbe(){return this.a*this.c*4},
gH(a){return A.l0(this)},
bf(a,b,c,d,e){return A.b1(A.l0(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gE(){return 2147483647},
gaY(){return!0},
b_(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int32Array(4),n=new A.cF(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
N(a,b,c){if(c==null||!(c instanceof A.ci)||c.d!==this)c=A.l0(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataInt32("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.dT.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Int8Array(r.length)
else r=new Int8Array(A.r(r))
return new A.dT(r,s.a,s.b,s.c)},
gL(){return B.R},
gbm(){return B.aH},
gB(a){return B.ax.gB(this.d)},
gbe(){return this.a*this.c},
gH(a){return A.l1(this)},
bf(a,b,c,d,e){return A.b1(A.l1(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gE(){return 127},
gaY(){return!0},
gaJ(){return 8},
b_(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Int8Array(4),n=new A.cG(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
N(a,b,c){if(c==null||!(c instanceof A.cj)||c.d!==this)c=A.l1(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataInt8("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.cU.prototype={
le(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.lD("data")
this.d=s},
bk(a){var s,r=this,q=r.d
if(a){q===$&&A.b("data")
q=new Uint8Array(q.length)}else{q===$&&A.b("data")
q=new Uint8Array(A.r(q))}s=r.f
s=s==null?null:s.U()
return new A.cU(q,r.e,s,r.a,r.b,r.c)},
gL(){return B.y},
gbm(){return B.L},
gv(a){var s=this.d
s===$&&A.b("data")
return s.byteLength},
gE(){var s=this.f
s=s==null?null:s.gE()
return s==null?1:s},
gaY(){return!1},
gB(a){var s=this.d
s===$&&A.b("data")
return B.d.gB(s)},
gaJ(){return 1},
gH(a){return A.en(this)},
bf(a,b,c,d,e){return A.b1(A.en(this),b,c,d,e)},
b_(a,b,c,d){var s=new A.cI(4,0)
s.ac(B.b.i(a),B.b.i(b),B.b.i(c),B.b.i(d))
return s},
N(a,b,c){if(c==null||!(c instanceof A.ck)||c.f!==this)c=A.en(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.en(r):s).a3(a,b)
r.r.av(0,c)},
Y(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.en(r):s).a3(a,b)
r.r.au(c,d,e)},
aq(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.en(r):s).a3(a,b)
r.r.ac(c,d,e,f)},
C(a){return"ImageDataUint1("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){},
gbe(){return this.e},
gM(){return this.f}}
A.cV.prototype={
bk(a){var s,r=this,q=r.d
if(a)q=new Uint16Array(q.length)
else q=new Uint16Array(A.r(q))
s=r.e
s=s==null?null:s.U()
return new A.cV(q,s,r.a,r.b,r.c)},
gL(){return B.m},
gbm(){return B.L},
gB(a){return B.P.gB(this.d)},
gaJ(){return 16},
gE(){var s=this.e
s=s==null?null:s.gE()
return s==null?65535:s},
gbe(){return this.a*this.c*2},
gH(a){return A.l2(this)},
bf(a,b,c,d,e){return A.b1(A.l2(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gaY(){return!0},
b_(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Uint16Array(4),n=new A.cJ(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
N(a,b,c){if(c==null||!(c instanceof A.cl)||c.d!==this)c=A.l2(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataUint16("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){},
gM(){return this.e}}
A.cW.prototype={
lf(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.lD("data")
this.d=s},
bk(a){var s,r=this,q=r.d
if(a){q===$&&A.b("data")
q=new Uint8Array(q.length)}else{q===$&&A.b("data")
q=new Uint8Array(A.r(q))}s=r.f
s=s==null?null:s.U()
return new A.cW(q,r.e,s,r.a,r.b,r.c)},
gL(){return B.t},
gbm(){return B.L},
gaJ(){return 2},
gB(a){var s=this.d
s===$&&A.b("data")
return B.d.gB(s)},
gH(a){return A.eo(this)},
bf(a,b,c,d,e){return A.b1(A.eo(this),b,c,d,e)},
gv(a){var s=this.d
s===$&&A.b("data")
return s.byteLength},
gE(){var s=this.f
s=s==null?null:s.gE()
return s==null?3:s},
gaY(){return!1},
b_(a,b,c,d){var s=new A.cK(4,0)
s.ac(B.b.i(a),B.b.i(b),B.b.i(c),B.b.i(d))
return s},
N(a,b,c){if(c==null||!(c instanceof A.cm)||c.f!==this)c=A.eo(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eo(r):s).a3(a,b)
r.r.aw(0,c)},
Y(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eo(r):s).a3(a,b)
r.r.au(c,d,e)},
aq(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.eo(r):s).a3(a,b)
r.r.ac(c,d,e,f)},
C(a){return"ImageDataUint2("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){},
gbe(){return this.e},
gM(){return this.f}}
A.cX.prototype={
bk(a){var s=this,r=s.d
if(a)r=new Uint32Array(r.length)
else r=new Uint32Array(A.r(r))
return new A.cX(r,s.a,s.b,s.c)},
gL(){return B.N},
gbm(){return B.L},
gB(a){return B.o.gB(this.d)},
gbe(){return this.a*this.c*4},
gaJ(){return 32},
gE(){return 4294967295},
gH(a){return A.l3(this)},
bf(a,b,c,d,e){return A.b1(A.l3(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gaY(){return!0},
b_(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new Uint32Array(4),n=new A.cL(o)
o[0]=s
o[1]=r
o[2]=q
o[3]=p
s=n
return s},
N(a,b,c){if(c==null||!(c instanceof A.cn)||c.d!==this)c=A.l3(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*this.a*r+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*this.a*q+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataUint32("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){}}
A.cY.prototype={
lg(a,b,c){var s=Math.max(this.e*b,1)
s=new Uint8Array(s)
this.d!==$&&A.lD("data")
this.d=s},
bk(a){var s,r=this,q=r.d
if(a){q===$&&A.b("data")
q=new Uint8Array(q.length)}else{q===$&&A.b("data")
q=new Uint8Array(A.r(q))}s=r.f
s=s==null?null:s.U()
return new A.cY(q,r.e,s,r.a,r.b,r.c)},
gL(){return B.z},
gbm(){return B.L},
gB(a){var s=this.d
s===$&&A.b("data")
return B.d.gB(s)},
gH(a){return A.ep(this)},
bf(a,b,c,d,e){return A.b1(A.ep(this),b,c,d,e)},
gv(a){var s=this.d
s===$&&A.b("data")
return s.byteLength},
gE(){var s=this.f
s=s==null?null:s.gE()
return s==null?15:s},
gaY(){return!1},
gaJ(){return 4},
b_(a,b,c,d){var s=B.b.i(a),r=B.b.i(b),q=B.b.i(c),p=B.b.i(d),o=new A.cM(4,new Uint8Array(2))
o.ac(s,r,q,p)
s=o
return s},
N(a,b,c){if(c==null||!(c instanceof A.co)||c.e!==this)c=A.ep(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ep(r):s).a3(a,b)
r.r.az(0,c)},
Y(a,b,c,d,e){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ep(r):s).a3(a,b)
r.r.au(c,d,e)},
aq(a,b,c,d,e,f){var s,r=this
if(r.c<1)return
s=r.r;(s==null?r.r=A.ep(r):s).a3(a,b)
r.r.ac(c,d,e,f)},
C(a){return"ImageDataUint4("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){},
gbe(){return this.e},
gM(){return this.f}}
A.cZ.prototype={
bk(a){var s,r=this,q=r.d
if(a)q=new Uint8Array(q.length)
else q=new Uint8Array(A.r(q))
s=r.e
s=s==null?null:s.U()
return new A.cZ(q,s,r.a,r.b,r.c)},
gL(){return B.e},
gbm(){return B.L},
gB(a){return B.d.gB(this.d)},
gbe(){return this.a*this.c},
gaJ(){return 8},
gH(a){return A.iY(this)},
bf(a,b,c,d,e){return A.b1(A.iY(this),b,c,d,e)},
gv(a){return this.d.byteLength},
gE(){var s=this.e
s=s==null?null:s.gE()
return s==null?255:s},
gaY(){return!1},
b_(a,b,c,d){var s=A.o_(B.b.i(B.b.P(a,0,255)),B.b.i(B.b.P(b,0,255)),B.b.i(B.b.P(c,0,255)),B.b.i(B.b.P(d,0,255)))
return s},
N(a,b,c){if(c==null||!(c instanceof A.cp)||c.d!==this)c=A.iY(this)
c.a3(a,b)
return c},
aR(a,b){return this.N(a,b,null)},
aL(a,b,c){var s,r=this.c,q=b*(this.a*r)+a*r
r=this.d
s=B.b.i(c)
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s},
Y(a,b,c,d,e){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
aq(a,b,c,d,e,f){var s,r,q=this.c,p=b*(this.a*q)+a*q,o=this.d,n=B.b.i(c)
o.$flags&2&&A.c(o)
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
C(a){return"ImageDataUint8("+this.a+", "+this.b+", "+this.c+")"},
b1(a,b){var s,r,q,p,o,n,m,l=this,k=l.c
if(k===1){k=l.d
B.d.aO(k,0,k.length,0)}else if(k===2){s=J.lL(B.d.gB(l.d),0,null)
B.P.aO(s,0,s.length,0)}else if(k===4){r=J.W(B.d.gB(l.d),0,null)
B.o.aO(r,0,r.length,0)}else for(q=A.iY(l),k=q.d,p=k.c>0,k=k.d,o=k.$flags|0;q.D();){if(p){n=q.c
m=B.b.i(B.a.P(0,0,255))
o&2&&A.c(k)
if(!(n>=0&&n<k.length))return A.a(k,n)
k[n]=m}q.st(0)
q.su(0)}},
gM(){return this.e}}
A.fZ.prototype={
a6(){return"Interpolation."+this.b}}
A.aQ.prototype={}
A.eg.prototype={
U(){return new A.eg(new Uint16Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.P.gB(this.c)},
gL(){return B.E},
gE(){return 1},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=A.J(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=A.J(b)
s.$flags&2&&A.c(s)
q=s.length
if(!(a>=0&&a<q))return A.a(s,a)
s[a]=r
if(o>1){r=a+1
p=A.J(c)
if(!(r<q))return A.a(s,r)
s[r]=p
if(o>2){o=a+2
r=A.J(d)
if(!(o<q))return A.a(s,o)
s[o]=r}}},
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s,r
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
s=s[a]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
return r[s]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]
s=$.R
s=s!=null?s:A.V()
if(!(r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.eh.prototype={
U(){return new A.eh(new Float32Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.a4.gB(this.c)},
gL(){return B.M},
gE(){return 1},
Z(a,b,c){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c}},
b0(a,b,c,d){var s,r,q,p=this.b
a*=p
s=this.c
s.$flags&2&&A.c(s)
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
s[a]=b
if(p>1){q=a+1
if(!(q<r))return A.a(s,q)
s[q]=c
if(p>2){p=a+2
if(!(p<r))return A.a(s,p)
s[p]=d}}},
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.ei.prototype={
U(){return new A.ei(new Float64Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.a5.gB(this.c)},
gL(){return B.Q},
gE(){return 1},
Z(a,b,c){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=c}},
b0(a,b,c,d){var s,r,q,p=this.b
a*=p
s=this.c
s.$flags&2&&A.c(s)
r=s.length
if(!(a>=0&&a<r))return A.a(s,a)
s[a]=b
if(p>1){q=a+1
if(!(q<r))return A.a(s,q)
s[q]=c
if(p>2){p=a+2
if(!(p<r))return A.a(s,p)
s[p]=d}}},
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.ej.prototype={
U(){return new A.ej(new Int16Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.aw.gB(this.c)},
gL(){return B.S},
gE(){return 32767},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.c(s)
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
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.ek.prototype={
U(){return new A.ek(new Int32Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.Z.gB(this.c)},
gL(){return B.T},
gE(){return 2147483647},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.c(s)
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
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.el.prototype={
U(){return new A.el(new Int8Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.ax.gB(this.c)},
gL(){return B.R},
gE(){return 127},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.c(s)
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
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.em.prototype={
U(){return new A.em(new Uint16Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.P.gB(this.c)},
gL(){return B.m},
gE(){return 65535},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.c(s)
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
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.d6.prototype={
U(){return new A.d6(new Uint32Array(A.r(this.c)),this.a,this.b)},
gB(a){return B.o.gB(this.c)},
gL(){return B.N},
gE(){return 4294967295},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.c(s)
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
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s
a*=this.b
s=this.c
if(!(a>=0&&a<s.length))return A.a(s,a)
return s[a]},
aW(a){var s,r=this.b
if(r<2)return 0
s=this.c
r=a*r+1
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
aV(a){var s,r=this.b
if(r<3)return 0
s=this.c
r=a*r+2
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
b3(a){var s,r=this.b
if(r<4)return 0
s=this.c
r=a*r+3
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.aH.prototype={
U(){return A.mp(this)},
gB(a){return B.d.gB(this.c)},
gL(){return B.e},
gE(){return 255},
Z(a,b,c){var s,r,q=this.b
if(b<q){s=this.c
q=a*q+b
r=B.a.i(c)
s.$flags&2&&A.c(s)
if(!(q>=0&&q<s.length))return A.a(s,q)
s[q]=r}},
b0(a,b,c,d){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.b.i(b)
s.$flags&2&&A.c(s)
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
cX(a,b,c,d,e){var s,r,q,p,o=this.b
a*=o
s=this.c
r=B.a.i(b)
s.$flags&2&&A.c(s)
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
b2(a,b){var s,r=this.b
if(b<r){s=this.c
r=a*r+b
if(!(r>=0&&r<s.length))return A.a(s,r)
r=s[r]}else r=0
return r},
aX(a){var s,r
a*=this.b
s=this.c
r=s.length
if(a>=r)return 0
if(!(a>=0))return A.a(s,a)
return s[a]},
aW(a){var s,r,q=this.b
if(q<2)return 0
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+1
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
aV(a){var s,r,q=this.b
if(q<3)return 0
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+2
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
b3(a){var s,r,q=this.b
if(q<4)return 255
a*=q
q=this.c
s=q.length
if(a>=s)return 0
r=a+3
if(!(r>=0&&r<s))return A.a(q,r)
return q[r]},
bC(a,b){return this.Z(a,0,b)},
bz(a,b){return this.Z(a,1,b)},
by(a,b){return this.Z(a,2,b)},
bx(a,b){return this.Z(a,3,b)}}
A.ce.prototype={
U(){var s=this
return new A.ce(s.a,s.b,s.c,s.d)},
gL(){return B.E},
gv(a){return this.d.c},
gM(){return null},
gE(){return 1},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c+q.c
r.c=s
return s<q.d.length},
l(a,b){var s,r=this.d
if(b<r.c){r=r.d
s=this.c+b
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=A.J(c)
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=A.J(a)
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gt(){var s,r=this.d
if(r.c>1){r=r.d
s=this.c+1
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=A.J(a)
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gu(){var s,r=this.d
if(r.c>2){r=r.d
s=this.c+2
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=A.J(a)
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gA(){var s,r=this.d
if(r.c>3){r=r.d
s=this.c+3
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=$.R
r=r!=null?r:A.V()
if(!(s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sA(a){var s,r,q,p=this.d
if(p.c>3){s=this.gt()
p=p.d
r=this.c+3
q=A.J(s)
p.$flags&2&&A.c(p)
if(!(r>=0&&r<p.length))return A.a(p,r)
p[r]=q}},
gae(){return this.gm()/1},
sae(a){this.sm(a)},
gaa(){return this.gt()/1},
saa(a){this.st(a)},
gad(){return this.gu()/1},
sad(a){this.su(a)},
ga_(){return this.gA()/1},
sa_(a){this.sA(a)},
gan(){return A.Y(this)},
af(a){var s=this
if(s.d.c>0){s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())}},
au(a,b,c){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.J(a)
o.$flags&2&&A.c(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){s=p.c+1
r=A.J(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){n=p.c+2
s=A.J(c)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}},
ac(a,b,c,d){var s,r,q,p=this,o=p.d,n=o.c
if(n>0){o=o.d
s=p.c
r=A.J(a)
o.$flags&2&&A.c(o)
q=o.length
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>1){s=p.c+1
r=A.J(b)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>2){s=p.c+2
r=A.J(c)
if(!(s>=0&&s<q))return A.a(o,s)
o[s]=r
if(n>3){n=p.c+3
s=A.J(d)
if(!(n>=0&&n<q))return A.a(o,n)
o[n]=s}}}}},
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.ce){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.cf.prototype={
U(){var s=this
return new A.cf(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gM(){return null},
gE(){return 1},
gL(){return B.M},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
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
r.$flags&2&&A.c(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=c}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.c(r)
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
r.$flags&2&&A.c(r)
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
r.$flags&2&&A.c(r)
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
r.$flags&2&&A.c(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gae(){return this.gm()/1},
sae(a){this.sm(a)},
gaa(){return this.gt()/1},
saa(a){this.st(a)},
gad(){return this.gu()/1},
sad(a){this.su(a)},
ga_(){return this.gA()/1},
sa_(a){this.sA(a)},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.c(p)
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
ac(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.c(p)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cf){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.cg.prototype={
U(){var s=this
return new A.cg(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gM(){return null},
gE(){return 1},
gL(){return B.Q},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
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
r.$flags&2&&A.c(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=c}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
r.$flags&2&&A.c(r)
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
r.$flags&2&&A.c(r)
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
r.$flags&2&&A.c(r)
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
r.$flags&2&&A.c(r)
if(!(s>=0&&s<r.length))return A.a(r,s)
r[s]=a}},
gae(){return this.gm()/1},
sae(a){this.sm(a)},
gaa(){return this.gt()/1},
saa(a){this.st(a)},
gad(){return this.gu()/1},
sad(a){this.su(a)},
ga_(){return this.gA()/1},
sa_(a){this.sA(a)},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.c(p)
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
ac(a,b,c,d){var s,r,q=this.d,p=q.d,o=this.c
p.$flags&2&&A.c(p)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cg){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.ch.prototype={
U(){var s=this
return new A.ch(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gM(){return null},
gE(){return 32767},
gL(){return B.S},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gae(){return this.gm()/32767},
sae(a){this.sm(a*32767)},
gaa(){return this.gt()/32767},
saa(a){this.st(a*32767)},
gad(){return this.gu()/32767},
sad(a){this.su(a*32767)},
ga_(){return this.gA()/32767},
sa_(a){this.sA(a*32767)},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
ac(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.ch){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.ci.prototype={
U(){var s=this
return new A.ci(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gM(){return null},
gE(){return 2147483647},
gL(){return B.T},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gae(){return this.gm()/2147483647},
sae(a){this.sm(a*2147483647)},
gaa(){return this.gt()/2147483647},
saa(a){this.st(a*2147483647)},
gad(){return this.gu()/2147483647},
sad(a){this.su(a*2147483647)},
ga_(){return this.gA()/2147483647},
sa_(a){this.sA(a*2147483647)},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
ac(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.ci){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.cj.prototype={
U(){var s=this
return new A.cj(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gM(){return null},
gE(){return 127},
gL(){return B.R},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gae(){return this.gm()/127},
sae(a){this.sm(a*127)},
gaa(){return this.gt()/127},
saa(a){this.st(a*127)},
gad(){return this.gu()/127},
sad(a){this.su(a*127)},
ga_(){return this.gA()/127},
sa_(a){this.sA(a*127)},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
ac(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cj){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.hf.prototype={
D(){var s=this,r=s.a
if(r.gaU()+1>s.d){r.a3(s.b,r.gaQ()+1)
return r.gaQ()<=s.e}return r.D()},
gO(){return this.a},
$iA:1}
A.ck.prototype={
U(){var s=this
return new A.ck(s.a,s.b,s.c,s.d,s.e,s.f)},
gv(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gM(){return this.f.f},
gE(){return this.f.gE()},
gL(){return B.y},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.f
r=b*s.e
q.e=r
s=a*s.c
q.c=r+B.a.j(s,3)
q.d=s&7},
gO(){return this},
D(){var s,r=this,q=++r.a,p=r.f
if(q===p.a){r.a=0
q=++r.b
r.d=0;++r.c
r.e=r.e+p.e
return q<p.b}s=p.c
if(p.f!=null||s===1){if(++r.d>7){r.d=0;++r.c}}else{q*=s
r.d=q&7
r.c=r.e+B.a.j(q,3)}q=r.c
p=p.d
p===$&&A.b("data")
return q<p.byteLength},
dQ(a){var s,r,q=this.c,p=7-(this.d+a)
if(p<0){p+=8;++q}s=this.f.d
s===$&&A.b("data")
r=s.length
if(q>=r)return 0
if(!(q>=0))return A.a(s,q)
return B.a.a5(s[q],p)&1},
b7(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dQ(a):0
else s=r.b2(this.dQ(0),a)
return s},
av(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=7-(this.d+a)
if(r<0){++s
r+=8}q=m.d
q===$&&A.b("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.P(B.b.i(b),0,1)
if(!(r>=0&&r<8))return A.a(B.bI,r)
n=B.bI[r]
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.c(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.b7(b)},
h(a,b,c){return this.av(b,c)},
gT(){return this.dQ(0)},
sT(a){this.av(0,a)},
gm(){return this.b7(0)},
sm(a){this.av(0,a)},
gt(){return this.b7(1)},
st(a){this.av(1,a)},
gu(){return this.b7(2)},
su(a){this.av(2,a)},
gA(){return this.b7(3)},
sA(a){this.av(3,a)},
gae(){return this.b7(0)/this.f.gE()},
sae(a){this.av(0,a*this.f.gE())},
gaa(){return this.b7(1)/this.f.gE()},
saa(a){this.av(1,a*this.f.gE())},
gad(){return this.b7(2)/this.f.gE()},
sad(a){this.av(2,a*this.f.gE())},
ga_(){return this.b7(3)/this.f.gE()},
sa_(a){this.av(3,a*this.f.gE())},
gan(){return A.Y(this)},
af(a){var s=this
s.av(0,a.gm())
s.av(1,a.gt())
s.av(2,a.gu())
s.av(3,a.gA())},
au(a,b,c){var s=this,r=s.f.c
if(r>0){s.av(0,a)
if(r>1){s.av(1,b)
if(r>2)s.av(2,c)}}},
ac(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.av(0,a)
if(r>1){s.av(1,b)
if(r>2){s.av(2,c)
if(r>3)s.av(3,d)}}}},
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.ck){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a9(b)
if(s.gv(b)!==q)return!1
if(p.b7(0)!==s.l(b,0))return!1
if(q>1){if(p.b7(1)!==s.l(b,1))return!1
if(q>2){if(p.b7(2)!==s.l(b,2))return!1
if(q>3)if(p.b7(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.f}}
A.cl.prototype={
U(){var s=this
return new A.cl(s.a,s.b,s.c,s.d)},
gv(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gM(){return this.d.e},
gE(){return this.d.gE()},
gL(){return B.m},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bt(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b2(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bt(b)},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(c)
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d,q=r.e
if(q==null)if(r.c>0){r=r.d
q=this.c
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aX(r[s])
r=s}return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
s=q.aW(r[s])
r=s}return r},
st(a){var s,r,q=this.d
if(q.c>1){q=q.d
s=this.c+1
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
s=q.aV(r[s])
r=s}return r},
su(a){var s,r,q=this.d
if(q.c>2){q=q.d
s=this.c+2
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
s=q.b3(r[s])
r=s}return r},
sA(a){var s,r,q=this.d
if(q.c>3){q=q.d
s=this.c+3
r=B.b.i(a)
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gae(){return this.gm()/this.d.gE()},
sae(a){this.sm(a*this.d.gE())},
gaa(){return this.gt()/this.d.gE()},
saa(a){this.st(a*this.d.gE())},
gad(){return this.gu()/this.d.gE()},
sad(a){this.su(a*this.d.gE())},
ga_(){return this.gA()/this.d.gE()},
sa_(a){this.sA(a*this.d.gE())},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
ac(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cl){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a9(b)
if(s.gv(b)!==q)return!1
if(p.bt(0)!==s.l(b,0))return!1
if(q>1){if(p.bt(1)!==s.l(b,1))return!1
if(q>2){if(p.bt(2)!==s.l(b,2))return!1
if(q>3)if(p.bt(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.cm.prototype={
U(){var s=this
return new A.cm(s.a,s.b,s.c,s.d,s.e,s.f)},
gv(a){var s=this.f,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gM(){return this.f.f},
gE(){return this.f.gE()},
gL(){return B.t},
gfO(){var s=this.f
return s.f!=null?2:s.c<<1>>>0},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q,p=this
p.a=a
p.b=b
s=p.gfO()
r=b*p.f.e
p.e=r
q=a*s
p.c=r+B.a.j(q,3)
p.d=q&7},
gO(){return this},
D(){var s=this,r=++s.a,q=s.f
if(r===q.a){s.a=0
r=++s.b
s.d=0;++s.c
s.e=s.e+q.e
return r<q.b}if(q.f!=null||q.c===1){if((s.d+=2)>7){s.d=0;++s.c}}else{r*=s.gfO()
s.d=r&7
s.c=s.e+B.a.j(r,3)}r=s.c
q=q.d
q===$&&A.b("data")
return r<q.length},
dR(a){var s,r=this.c,q=6-(this.d+(a<<1>>>0))
if(q<0){q+=8;++r}s=this.f.d
s===$&&A.b("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a5(s[r],q)&3},
b8(a){var s=this.f,r=s.f
if(r==null)s=s.c>a?this.dR(a):0
else s=r.b2(this.dR(0),a)
return s},
aw(a,b){var s,r,q,p,o,n,m=this.f
if(a>=m.c)return
s=this.c
r=6-(this.d+(a<<1>>>0))
if(r<0){++s
r+=8}q=m.d
q===$&&A.b("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.P(B.b.i(b),0,3)
q=B.a.j(r,1)
if(!(q<4))return A.a(B.bo,q)
n=B.bo[q]
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.c(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.b8(b)},
h(a,b,c){return this.aw(b,c)},
gT(){return this.dR(0)},
sT(a){this.aw(0,a)},
gm(){return this.b8(0)},
sm(a){this.aw(0,a)},
gt(){return this.b8(1)},
st(a){this.aw(1,a)},
gu(){return this.b8(2)},
su(a){this.aw(2,a)},
gA(){return this.b8(3)},
sA(a){this.aw(3,a)},
gae(){return this.b8(0)/this.f.gE()},
sae(a){this.aw(0,a*this.f.gE())},
gaa(){return this.b8(1)/this.f.gE()},
saa(a){this.aw(1,a*this.f.gE())},
gad(){return this.b8(2)/this.f.gE()},
sad(a){this.aw(2,a*this.f.gE())},
ga_(){return this.b8(3)/this.f.gE()},
sa_(a){this.aw(3,a*this.f.gE())},
gan(){return A.Y(this)},
af(a){var s=this
s.aw(0,a.gm())
s.aw(1,a.gt())
s.aw(2,a.gu())
s.aw(3,a.gA())},
au(a,b,c){var s=this,r=s.f.c
if(r>0){s.aw(0,a)
if(r>1){s.aw(1,b)
if(r>2)s.aw(2,c)}}},
ac(a,b,c,d){var s=this,r=s.f.c
if(r>0){s.aw(0,a)
if(r>1){s.aw(1,b)
if(r>2){s.aw(2,c)
if(r>3)s.aw(3,d)}}}},
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cm){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.f
r=s.f
q=r!=null?r.b:s.c
s=J.a9(b)
if(s.gv(b)!==q)return!1
if(p.b8(0)!==s.l(b,0))return!1
if(q>1){if(p.b8(1)!==s.l(b,1))return!1
if(q>2){if(p.b8(2)!==s.l(b,2))return!1
if(q>3)if(p.b8(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.f}}
A.cn.prototype={
U(){var s=this
return new A.cn(s.a,s.b,s.c,s.d)},
gv(a){return this.d.c},
gM(){return null},
gE(){return 4294967295},
gL(){return B.N},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){return this.gm()},
sT(a){this.sm(a)},
gm(){var s,r=this.d
if(r.c>0){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=r[s]
r=s}else r=0
return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(a)
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
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
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gae(){return this.gm()/4294967295},
sae(a){this.sm(a*4294967295)},
gaa(){return this.gt()/4294967295},
saa(a){this.st(a*4294967295)},
gad(){return this.gu()/4294967295},
sad(a){this.su(a*4294967295)},
ga_(){return this.gA()/4294967295},
sa_(a){this.sA(a*4294967295)},
gan(){return A.Y(this)},
af(a){var s=this
s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())},
au(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
ac(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p,o,n=this
if(b==null)return!1
if(b instanceof A.cn){s=A.w(n,A.l(n).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=J.a9(b)
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
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.co.prototype={
U(){var s=this
return new A.co(s.a,s.b,s.c,s.d,s.e)},
gv(a){var s=this.e,r=s.f
r=r==null?null:r.b
return r==null?s.c:r},
gM(){return this.e.f},
gE(){return this.e.gE()},
gL(){return B.z},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q,p=this
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
D(){var s,r,q,p=this,o=p.e
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
o===$&&A.b("data")
return s<o.length},
dS(a){var s,r=this.c,q=4-(this.d+(a<<2>>>0))
if(q<0){q+=8;++r}s=this.e.d
s===$&&A.b("data")
if(!(r>=0&&r<s.length))return A.a(s,r)
return B.a.a5(s[r],q)&15},
b9(a){var s=this.e,r=s.f
if(r==null)s=s.c>a?this.dS(a):0
else s=r.b2(this.dS(0),a)
return s},
az(a,b){var s,r,q,p,o,n,m=this.e
if(a>=m.c)return
s=this.c
r=4-(this.d+(a<<2>>>0))
if(r<0){r+=8;++s}q=m.d
q===$&&A.b("data")
if(!(s>=0&&s<q.length))return A.a(q,s)
p=q[s]
o=B.a.P(B.b.i(b),0,15)
n=r===4?15:240
q=B.a.V(o,r)
m=m.d
m.$flags&2&&A.c(m)
if(!(s<m.length))return A.a(m,s)
m[s]=(p&n|q)>>>0},
l(a,b){return this.b9(b)},
h(a,b,c){return this.az(b,c)},
gT(){return this.dS(0)},
sT(a){this.az(0,a)},
gm(){return this.b9(0)},
sm(a){this.az(0,a)},
gt(){return this.b9(1)},
st(a){this.az(1,a)},
gu(){return this.b9(2)},
su(a){this.az(2,a)},
gA(){return this.b9(3)},
sA(a){this.az(3,a)},
gae(){return this.b9(0)/this.e.gE()},
sae(a){this.az(0,a*this.e.gE())},
gaa(){return this.b9(1)/this.e.gE()},
saa(a){this.az(1,a*this.e.gE())},
gad(){return this.b9(2)/this.e.gE()},
sad(a){this.az(2,a*this.e.gE())},
ga_(){return this.b9(3)/this.e.gE()},
sa_(a){this.az(3,a*this.e.gE())},
gan(){return A.Y(this)},
af(a){var s=this
s.az(0,a.gm())
s.az(1,a.gt())
s.az(2,a.gu())
s.az(3,a.gA())},
au(a,b,c){var s=this,r=s.e.c
if(r>0){s.az(0,a)
if(r>1){s.az(1,b)
if(r>2)s.az(2,c)}}},
ac(a,b,c,d){var s=this,r=s.e.c
if(r>0){s.az(0,a)
if(r>1){s.az(1,b)
if(r>2){s.az(2,c)
if(r>3)s.az(3,d)}}}},
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.co){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){q=p.e.c
s=J.a9(b)
if(s.gv(b)!==q)return!1
if(p.b9(0)!==s.l(b,0))return!1
if(q>1){if(p.b9(1)!==s.l(b,1))return!1
if(q>2){if(p.b9(2)!==s.l(b,2))return!1
if(q>3)if(p.b9(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.e}}
A.cp.prototype={
U(){var s=this
return new A.cp(s.a,s.b,s.c,s.d)},
gv(a){var s=this.d,r=s.e
r=r==null?null:r.b
return r==null?s.c:r},
gM(){return this.d.e},
gE(){return this.d.gE()},
gL(){return B.e},
gaU(){return this.a},
gaQ(){return this.b},
a3(a,b){var s,r,q=this
q.a=a
q.b=b
s=q.d
r=s.c
q.c=b*s.a*r+a*r},
gO(){return this},
D(){var s,r=this,q=r.d
if(++r.a===q.a){r.a=0
if(++r.b===q.b)return!1}s=r.c
s+=q.e==null?q.c:1
r.c=s
return s<q.d.length},
bt(a){var s,r=this.d,q=r.e
if(q!=null){r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.b2(r[s],a)
r=s}else if(a<r.c){r=r.d
q=this.c+a
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
return r},
l(a,b){return this.bt(b)},
h(a,b,c){var s,r,q=this.d
if(b<q.c){q=q.d
s=this.c+b
r=B.b.i(B.b.P(c,0,255))
q.$flags&2&&A.c(q)
if(!(s>=0&&s<q.length))return A.a(q,s)
q[s]=r}},
gT(){var s=this.d.d,r=this.c
if(!(r>=0&&r<s.length))return A.a(s,r)
return s[r]},
sT(a){var s=this.d.d,r=this.c,q=B.b.i(B.b.P(a,0,255))
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=q},
gm(){var s,r=this.d,q=r.e
if(q==null)if(r.c>0){r=r.d
q=this.c
if(!(q>=0&&q<r.length))return A.a(r,q)
q=r[q]
r=q}else r=0
else{r=r.d
s=this.c
if(!(s>=0&&s<r.length))return A.a(r,s)
s=q.aX(r[s])
r=s}return r},
sm(a){var s,r,q=this.d
if(q.c>0){q=q.d
s=this.c
r=B.b.i(B.b.P(a,0,255))
q.$flags&2&&A.c(q)
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
s=p.aW(q[s])
q=s}return q},
st(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.i(B.b.P(a,0,255))
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>1){r=r.d
q=this.c+1
s=B.b.i(B.b.P(a,0,255))
r.$flags&2&&A.c(r)
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
s=p.aV(q[s])
q=s}return q},
su(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c
s=B.b.i(B.b.P(a,0,255))
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>2){r=r.d
q=this.c+2
s=B.b.i(B.b.P(a,0,255))
r.$flags&2&&A.c(r)
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
s=p.b3(q[s])
q=s}return q},
sA(a){var s,r=this.d,q=r.c
if(q===2){r=r.d
q=this.c+1
s=B.b.i(B.b.P(a,0,255))
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}else if(q>3){r=r.d
q=this.c+3
s=B.b.i(B.b.P(a,0,255))
r.$flags&2&&A.c(r)
if(!(q>=0&&q<r.length))return A.a(r,q)
r[q]=s}},
gae(){return this.gm()/this.d.gE()},
sae(a){this.sm(a*this.d.gE())},
gaa(){return this.gt()/this.d.gE()},
saa(a){this.st(a*this.d.gE())},
gad(){return this.gu()/this.d.gE()},
sad(a){this.su(a*this.d.gE())},
ga_(){return this.gA()/this.d.gE()},
sa_(a){this.sA(a*this.d.gE())},
gan(){return this.d.c===2?this.gm():A.Y(this)},
af(a){var s=this
if(s.d.e!=null)s.sT(a.gT())
else{s.sm(a.gm())
s.st(a.gt())
s.su(a.gu())
s.sA(a.gA())}},
au(a,b,c){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
ac(a,b,c,d){var s,r,q,p,o=this.d,n=o.c
if(n>0){o=o.d
s=this.c
r=B.a.i(a)
o.$flags&2&&A.c(o)
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
gH(a){return new A.P(this)},
W(a,b){var s,r,q,p=this
if(b==null)return!1
if(b instanceof A.cp){s=A.w(p,A.l(p).q("e.E"))
s=A.n(s)
r=A.w(b,A.l(b).q("e.E"))
return s===A.n(r)}if(t.L.b(b)){s=p.d
r=s.e
q=r!=null?r.b:s.c
s=J.a9(b)
if(s.gv(b)!==q)return!1
if(p.bt(0)!==s.l(b,0))return!1
if(q>1){if(p.bt(1)!==s.l(b,1))return!1
if(q>2){if(p.bt(2)!==s.l(b,2))return!1
if(q>3)if(p.bt(3)!==s.l(b,3))return!1}}return!0}return!1},
gJ(a){var s=A.w(this,A.l(this).q("e.E"))
return A.n(s)},
aM(a){return A.aJ(this,null,a,null,null)},
$iA:1,
$ix:1,
$iu:1,
gbd(){return this.d}}
A.D.prototype={
U(){return new A.D()},
gbd(){return $.nq()},
gaU(){return 0},
gaQ(){return 0},
gv(a){return 0},
gE(){return 0},
gL(){return B.e},
gM(){return null},
l(a,b){return 0},
h(a,b,c){},
gT(){return 0},
sT(a){},
gm(){return 0},
sm(a){},
gt(){return 0},
st(a){},
gu(){return 0},
su(a){},
gA(){return 0},
sA(a){},
gae(){return 0},
sae(a){},
gaa(){return 0},
saa(a){},
gad(){return 0},
sad(a){},
ga_(){return 0},
sa_(a){},
gan(){return 0},
af(a){},
au(a,b,c){},
ac(a,b,c,d){},
a3(a,b){},
gO(){return this},
D(){return!1},
W(a,b){if(b==null)return!1
return b instanceof A.D},
gJ(a){return 0},
gH(a){return new A.P(this)},
aM(a){return this},
$iA:1,
$ix:1,
$iu:1}
A.ik.prototype={
a6(){return"FlipDirection."+this.b}}
A.iw.prototype={
C(a){return"ImageException: "+this.a}}
A.af.prototype={
gv(a){return this.c-this.d},
h(a,b,c){J.y(this.a,this.d+b,c)
return c},
bn(a,b,c,d){var s=this.a,r=J.ak(s),q=this.d+a
if(c instanceof A.af)r.ar(s,q,q+b,c.a,c.d+d)
else r.ar(s,q,q+b,t.L.a(c),d)},
c4(a,b,c){return this.bn(a,b,c,0)},
kN(a,b,c){var s=this.a,r=this.d+a
J.bl(s,r,r+b,c)},
dr(a,b,c){var s=this,r=c!=null?s.b+c:s.d
return A.v(s.a,s.e,a,r+b)},
al(a){return this.dr(a,0,null)},
c6(a,b){return this.dr(a,0,b)},
cY(a,b){return this.dr(a,b,null)},
F(){return J.d(this.a,this.d++)},
aj(a){var s=this.al(a)
this.d=this.d+(s.c-s.d)
return s},
ak(a){var s,r,q,p,o,n=this
if(a==null){s=A.j([],t.t)
for(r=n.c;q=n.d,q<r;){p=n.a
n.d=q+1
o=J.d(p,q)
if(o===0)return A.eA(s,0,null)
B.c.G(s,o)}throw A.h(A.m("EOF reached without finding string terminator (length: "+A.z(a)+")"))}return A.eA(n.aj(a).a2(),0,null)},
cS(){return this.ak(null)},
h5(a){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
B.c.G(n,p)
if(p===10||n.length>=a)return A.eA(n,0,null)}return A.eA(n,0,null)},
kU(){return this.h5(256)},
kV(){var s,r,q,p,o=this,n=A.j([],t.t)
for(s=o.c;r=o.d,r<s;){q=o.a
o.d=r+1
p=J.d(q,r)
if(p===0){t.L.a(n)
return new A.hV(!0).eD(n,0,null,!0)}B.c.G(n,p)}return B.cT.kn(n,!0)},
n(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255
if(s.e)return r<<8|q
return q<<8|r},
bp(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255
if(s.e)return p|q<<8|r<<16
return r|q<<8|p<<16},
k(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255
if(s.e)return(r<<24|q<<16|p<<8|o)>>>0
return(o<<24|p<<16|q<<8|r)>>>0},
dl(){return A.rN(this.e4())},
e4(){var s=this,r=J.d(s.a,s.d++)&255,q=J.d(s.a,s.d++)&255,p=J.d(s.a,s.d++)&255,o=J.d(s.a,s.d++)&255,n=J.d(s.a,s.d++)&255,m=J.d(s.a,s.d++)&255,l=J.d(s.a,s.d++)&255,k=J.d(s.a,s.d++)&255
if(s.e)return(B.a.R(r,56)|B.a.R(q,48)|B.a.R(p,40)|B.a.R(o,32)|n<<24|m<<16|l<<8|k)>>>0
return(B.a.R(k,56)|B.a.R(l,48)|B.a.R(m,40)|B.a.R(n,32)|o<<24|p<<16|q<<8|r)>>>0},
cT(a,b,c){var s,r=this,q=r.a
if(t.D.b(q))return r.hb(b,c)
s=r.b+r.d+b
return J.kF(q,s,c<=0?r.c:s+c)},
hb(a,b){var s,r=this,q=b==null?r.c-r.d-a:b,p=r.a
if(t.D.b(p))return J.E(B.d.gB(p),p.byteOffset+r.d+a,q)
s=r.d+a
s=J.kF(p,s,s+q)
return new Uint8Array(A.r(s))},
a2(){return this.hb(0,null)},
cU(){var s=this.a
if(t.D.b(s))return J.W(B.d.gB(s),s.byteOffset+this.d,null)
return J.W(B.d.gB(this.a2()),0,null)},
sB(a,b){this.a=t.L.a(b)}}
A.hb.prototype={
gM(){var s=this.a
s===$&&A.b("palette")
return s},
kg(a){var s=this
s.f2(a)
s.eO()
s.f_()
s.eE()},
hh(a){var s=B.b.i(a.gm()),r=B.b.i(a.gt())
return this.f0(B.b.i(a.gu()),r,s)},
hi(a,b,c){return this.f0(c,b,a)},
jd(a){var s,r,q,p,o,n,m,l=this,k=l.c=Math.max(a,4)
l.f=k-l.d
l.r=k-1
s=B.b.X(k,8)
l.w=s
l.x=s*256
l.Q=new A.d6(new Uint32Array(1024),256,4)
l.a=new A.aH(new Uint8Array(768),256,3)
l.d=3
l.e=2
s=B.b.j(k,3)
l.y=new Int32Array(s)
s=t.V
r=t.H
l.z=r.a(A.S(k*3,0,!1,s))
l.at=r.a(A.S(l.c,0,!1,s))
l.ax=r.a(A.S(l.c,0,!1,s))
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
eE(){var s,r,q,p,o,n,m
for(s=0;s<this.c;++s){r=this.a
r===$&&A.b("palette")
q=this.Q
q===$&&A.b("_palette")
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
r.b0(s,Math.abs(o),Math.abs(n),Math.abs(q))}},
f0(a,b,c){var s,r,q,p,o,n,m,l,k,j,i="_palette",h=this.as
if(!(b>=0&&b<256))return A.a(h,b)
s=h[b]
r=s-1
q=this.c
h=this.Q
p=1000
o=-1
for(;;){n=s<q
if(!(n||r>=0))break
if(n){h===$&&A.b(i)
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
p=k}}++s}}if(r>=0){h===$&&A.b(i)
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
eO(){var s,r,q,p,o,n,m,l=this,k="_palette"
for(s=0,r=0;s<l.c;++s){for(q=0;q<3;++q,++r){p=l.z
p===$&&A.b("_network")
if(!(r>=0&&r<p.length))return A.a(p,r)
o=B.a.P(B.b.i(0.5+p[r]),0,255)
p=l.Q
p===$&&A.b(k)
n=p.b
if(q<n){p=p.c
n=s*n+q
m=B.a.i(o)
p.$flags&2&&A.c(p)
if(!(n>=0&&n<p.length))return A.a(p,n)
p[n]=m}}p=l.Q
p===$&&A.b(k)
n=p.b
if(3<n){p=p.c
n=s*n+3
m=B.a.i(s)
p.$flags&2&&A.c(p)
if(!(n>=0&&n<p.length))return A.a(p,n)
p[n]=m}}},
f_(){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b=this
for(s=b.c,r=b.Q,q=b.as,p=q.$flags|0,o=0,n=0,m=0;m<s;m=g){r===$&&A.b("_palette")
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
d.$flags&2&&A.c(d)
if(!(c>=0&&c<d.length))return A.a(d,c)
d[c]=i}if(j){c=m*l
j=r.c
i=B.a.i(f)
j.$flags&2&&A.c(j)
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
i.$flags&2&&A.c(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
j=m*l+1
i=B.a.i(f)
k.$flags&2&&A.c(k)
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
i.$flags&2&&A.c(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
j=m*l+2
i=B.a.i(f)
k.$flags&2&&A.c(k)
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
i.$flags&2&&A.c(i)
if(!(d>=0&&d<i.length))return A.a(i,d)
i[d]=j}if(k){k=r.c
l=m*l+3
j=B.a.i(f)
k.$flags&2&&A.c(k)
if(!(l>=0&&l<k.length))return A.a(k,l)
k[l]=j}}if(h!==o){p&2&&A.c(q)
if(!(o>=0&&o<256))return A.a(q,o)
q[o]=n+m>>>1
for(f=o+1;f<h;++f){if(!(f<256))return A.a(q,f)
q[f]=m}n=m
o=h}}s=b.r
s.toString
r=B.a.j(n+s,1)
p&2&&A.c(q)
if(!(o>=0&&o<256))return A.a(q,o)
q[o]=r
for(g=o+1;g<256;++g)q[g]=s},
fp(a,b){var s,r,q,p
for(s=this.y,r=a*a,q=0;q<a;++q){s===$&&A.b("_radiusPower")
p=B.b.i(b*((r-q*q)*256/r))
s.$flags&2&&A.c(s)
if(!(q<s.length))return A.a(s,q)
s[q]=p}},
f2(a6){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3=this,a4="_network",a5=a3.x
a5===$&&A.b("initBiasRadius")
s=a3.b
r=30+B.a.X(s-1,3)
q=a6.gS()*a6.gK()
p=B.a.aG(q,s)
o=Math.max(B.a.X(p,100),1)
if(o===0)o=1
n=B.a.j(a5,8)
if(n<=1)n=0
a3.fp(n,1024)
if(q<1509)m=a3.b=1
else if(B.a.a8(q,499)!==0)m=499
else if(B.a.a8(q,491)!==0)m=491
else m=B.a.a8(q,487)!==0?487:503
l=a6.gS()
k=a6.gK()
for(j=a5,i=1024,h=0,g=0,f=0,e=0;e<p;){a5=a6.a
d=a5==null?null:a5.N(g,f,null)
if(d==null)d=new A.D()
c=d.gm()
b=d.gt()
a=d.gu()
if(e===0){a5=a3.z
a5===$&&A.b(a4)
s=a3.e
s===$&&A.b("bgColor")
B.c.h(a5,s*3,a)
B.c.h(a3.z,a3.e*3+1,b)
B.c.h(a3.z,a3.e*3+2,c)}a0=a3.k9(a,b,c)
if(a0<0)a0=a3.i8(a,b,c)
if(a0>=a3.d){a1=i/1024
d=a0*3
a5=a3.z
a5===$&&A.b(a4)
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
if(n>0)a3.hV(a1,n,a0,a,b,c)}h+=m
g+=m
while(g>l){g-=l;++f}while(h>=q){h-=q
f-=k}++e
if(B.a.a8(e,o)===0){i-=B.a.aG(i,r)
j-=B.a.X(j,30)
n=B.a.j(j,8)
if(n<=1)n=0
a3.fp(n,i)}}},
hV(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i,h=this,g="_network",f=c-b,e=h.d-1
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
m===$&&A.b("_radiusPower")
l=o+1
if(!(o<m.length))return A.a(m,o)
k=m[o]
if(n){j=q*3
n=h.z
n===$&&A.b(g)
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
n===$&&A.b(g)
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
i8(a,b,c){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e=this,d=1e30
for(s=e.d,r=s*3,q=d,p=q,o=-1,n=-1;s<e.c;++s,r=l){m=e.z
m===$&&A.b("_network")
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
m===$&&A.b("_bias")
if(!(s<m.length))return A.a(m,s)
g=j-m[s]
if(g<q){n=s
q=g}m=e.ax
m===$&&A.b("_freq")
if(!(s<m.length))return A.a(m,s)
k=m[s]
B.c.h(m,s,k-0.0009765625*k)
k=e.at
if(!(s<k.length))return A.a(k,s)
m=k[s]
f=e.ax
if(!(s<f.length))return A.a(f,s)
B.c.h(k,s,m+f[s])}m=e.ax
m===$&&A.b("_freq")
if(!(o>=0&&o<m.length))return A.a(m,o)
B.c.h(m,o,m[o]+0.0009765625)
m=e.at
m===$&&A.b("_bias")
if(!(o<m.length))return A.a(m,o)
B.c.h(m,o,m[o]-1)
return n},
k9(a,b,c){var s,r,q,p,o,n,m
for(s=this.d,r=this.z,q=0,p=0;q<s;++q){r===$&&A.b("_network")
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
A.hd.prototype={
p(a){var s,r,q=this
if(q.a===q.c.length)q.iO()
s=q.c
r=q.a++
s.$flags&2&&A.c(s)
if(!(r>=0&&r<s.length))return A.a(s,r)
s[r]=a&255},
hf(a,b){var s,r,q,p,o=this
t.L.a(a)
if(b==null)b=J.bm(a)
while(s=o.a,r=s+b,q=o.c,p=q.length,r>p)o.eN(r-p)
B.d.bB(q,s,r,a)
o.a+=b},
a7(a){return this.hf(a,null)},
a0(a){var s=this
if(s.b){s.p(B.a.j(a,8)&255)
s.p(a&255)
return}s.p(a&255)
s.p(B.a.j(a,8)&255)},
I(a){var s=this
if(s.b){s.p(B.a.j(a,24)&255)
s.p(B.a.j(a,16)&255)
s.p(B.a.j(a,8)&255)
s.p(a&255)
return}s.p(a&255)
s.p(B.a.j(a,8)&255)
s.p(B.a.j(a,16)&255)
s.p(B.a.j(a,24)&255)},
l9(a){var s,r,q=this,p=new Float32Array(1)
p[0]=a
s=J.E(B.a4.gB(p),0,null)
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
la(a){var s,r,q=this,p=new Float64Array(1)
p[0]=a
s=J.E(B.a5.gB(p),0,null)
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
eN(a){var s,r,q,p
if(a!=null)s=a
else{r=this.c.length
s=r===0?8192:r*2}r=this.c
q=r.length
p=new Uint8Array(q+s)
B.d.bB(p,0,q,r)
this.c=p},
iO(){return this.eN(null)},
gv(a){return this.a}}
A.j9.prototype={
a6(){return"QuantizerType."+this.b}}
A.hw.prototype={
e8(a){var s,r,q=a.gS(),p=A.Q(null,null,B.e,0,B.j,a.gK(),null,0,1,this.gM(),B.e,q,!1)
q=p.a
s=q.gH(q)
s.D()
p.z=a.z
p.w=a.w
p.y=a.y
for(q=a.a,q=q.gH(q);q.D();){r=q.gO()
s.gO().h(0,0,this.hh(r))
s.D()}return p}}
A.aS.prototype={
i(a){var s=this.b
return s===0?0:B.a.aG(this.a,s)},
W(a,b){if(b==null)return!1
return b instanceof A.aS&&this.a===b.a&&this.b===b.b},
gJ(a){return A.kW(this.a,this.b,B.ac)},
C(a){return""+this.a+"/"+this.b}}
A.h7.prototype={
a6(){return"Level."+this.b}}
A.iR.prototype={
fF(a){B.c.G(this.c,a)
if(a.d.a<=3)A.oT(a)},
fV(a){return this.fF(new A.e3(a,null,$.lG().$1(null),B.dg))}}
A.iS.prototype={
$1(a){return a},
$S:30}
A.e3.prototype={}
A.h8.prototype={
ha(){var s,r=this,q=A.I(t.N,t.z)
q.h(0,"bytes",r.a)
q.h(0,"width",r.b)
q.h(0,"height",r.c)
s=r.d
if(s!=null)q.h(0,"blurhash",s)
s=r.e
if(s!=null)q.h(0,"originalHeight",s)
s=r.f
if(s!=null)q.h(0,"originalWidth",s)
return q}}
A.iV.prototype={}
A.jA.prototype={}
A.eM.prototype={
a6(){return"WebWorkerOperations."+this.b}}
A.ku.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j=t.cX.a(A.ne(A.bi(a).data))
try{n=j
m=n.l(0,"label")
if(n.ag("name")){l=A.o(n.l(0,"name"))
if(!(l>=0&&l<2))return A.a(B.ca,l)
l=B.ca[l]}else l=null
s=new A.jA(m,l,n.l(0,"data"))
switch(s.b){case B.cx:n=A.e1(t.eO.a(s.c),t.N,t.z)
r=A.ou(new A.iV(t.D.a(n.l(0,"bytes")),A.o(n.l(0,"maxDimension")),A.bG(n.l(0,"fileName")),A.mX(n.l(0,"calcBlurhash"))))
n=A.hW(s.a)
m=r
A.na(n,m==null?null:m.ha())
break
case B.cy:n=J.nR(t.j.a(s.c),t.p)
n=A.w(n,n.$ti.q("e.E"))
q=A.ot(new Uint8Array(A.r(n)))
n=A.hW(s.a)
q=q
A.na(n,q==null?null:q.ha())
break
default:throw A.h(new A.bg())}}catch(k){p=A.c0(k)
o=A.bk(k)
A.qT(p,o,A.hW(J.d(j,"label")))}},
$S:31};(function aliases(){var s=J.bQ.prototype
s.hy=s.C
s=A.G.prototype
s.ei=s.ar})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers.installInstanceTearOff,p=hunkHelpers._instance_2u,o=hunkHelpers.installStaticTearOff
s(A,"r8","pO",7)
s(A,"r9","pP",7)
s(A,"ra","pQ",7)
r(A,"nc","r1",2)
s(A,"rc","qO",33)
q(A.a2.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.aZ.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.bt.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.aO.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.bc.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.bd.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.bs.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.br.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.be.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
q(A.c9.prototype,"gbK",1,0,null,["$1","$0"],["a9","i"],3,0,0)
var n
p(n=A.h4.prototype,"gik","il",4)
p(n,"gio","ip",4)
p(n,"giq","ir",4)
p(n,"gic","ie",4)
p(n,"gig","ih",4)
s(A,"rX","pc",0)
s(A,"rQ","p4",0)
s(A,"rO","p2",0)
s(A,"rV","pa",0)
s(A,"rW","pb",0)
s(A,"rU","p9",0)
s(A,"rT","p8",0)
s(A,"rS","p7",0)
s(A,"rZ","pe",0)
s(A,"rY","pd",0)
s(A,"rR","p5",0)
s(A,"rP","p3",0)
s(A,"t9","pp",0)
s(A,"t7","pn",0)
s(A,"t_","pf",0)
s(A,"t1","ph",0)
s(A,"t0","pg",0)
s(A,"t2","pi",0)
s(A,"ta","pq",0)
s(A,"t8","po",0)
s(A,"t3","pj",0)
s(A,"t4","pk",0)
s(A,"t5","pl",0)
s(A,"t6","pm",0)
p(A.eH.prototype,"gjz","jA",13)
p(A.fX.prototype,"gkz","kA",13)
o(A,"lE",3,null,["$3"],["pr"],1,0)
o(A,"tb",3,null,["$3"],["ps"],1,0)
o(A,"tg",3,null,["$3"],["px"],1,0)
o(A,"th",3,null,["$3"],["py"],1,0)
o(A,"ti",3,null,["$3"],["pz"],1,0)
o(A,"tj",3,null,["$3"],["pA"],1,0)
o(A,"tk",3,null,["$3"],["pB"],1,0)
o(A,"tl",3,null,["$3"],["pC"],1,0)
o(A,"tm",3,null,["$3"],["pD"],1,0)
o(A,"tn",3,null,["$3"],["pE"],1,0)
o(A,"tc",3,null,["$3"],["pt"],1,0)
o(A,"td",3,null,["$3"],["pu"],1,0)
o(A,"te",3,null,["$3"],["pv"],1,0)
o(A,"tf",3,null,["$3"],["pw"],1,0)
o(A,"rH",2,null,["$1$2","$2"],["nl",function(a,b){return A.nl(a,b,t.q)}],36,0)
o(A,"tp",6,null,["$6"],["pL"],6,0)
o(A,"tq",6,null,["$6"],["pM"],6,0)
o(A,"to",6,null,["$6"],["pK"],6,0)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.H,null)
q(A.H,[A.kQ,J.fO,A.ex,J.dy,A.T,A.G,A.ja,A.e,A.cb,A.e4,A.eO,A.dB,A.eP,A.ar,A.bD,A.cN,A.eV,A.aq,A.jh,A.iX,A.dC,A.f0,A.ah,A.iO,A.O,A.at,A.jJ,A.hU,A.b3,A.hP,A.hT,A.k_,A.hK,A.aM,A.hM,A.cv,A.ab,A.hL,A.hR,A.f4,A.eT,A.fo,A.cA,A.hV,A.fp,A.jK,A.hc,A.ey,A.jL,A.io,A.aj,A.hS,A.ez,A.iW,A.dN,A.jD,A.jE,A.id,A.aV,A.jW,A.jZ,A.iz,A.jC,A.fK,A.he,A.i5,A.i6,A.bo,A.P,A.aN,A.hO,A.ft,A.aE,A.a2,A.i9,A.bn,A.ic,A.ig,A.K,A.fu,A.bp,A.fv,A.fw,A.fx,A.dE,A.f_,A.dI,A.dJ,A.dK,A.fF,A.fG,A.fl,A.bM,A.iE,A.bx,A.iG,A.dr,A.h3,A.iJ,A.h4,A.er,A.hk,A.bf,A.da,A.j0,A.cq,A.ho,A.hp,A.et,A.hv,A.dd,A.db,A.dc,A.ev,A.a3,A.eD,A.jd,A.hA,A.jg,A.hB,A.hC,A.iT,A.jl,A.eG,A.jm,A.jr,A.ju,A.jw,A.eF,A.jv,A.jn,A.bE,A.eI,A.hJ,A.eJ,A.eK,A.eH,A.hH,A.js,A.hI,A.jy,A.eL,A.fz,A.fA,A.dM,A.dL,A.dO,A.fB,A.dm,A.cQ,A.aQ,A.hf,A.iw,A.af,A.hw,A.hd,A.aS,A.iR,A.e3,A.h8,A.iV,A.jA])
q(J.fO,[J.h1,J.dX,J.e_,J.d3,J.d4,J.dZ,J.d2])
q(J.e_,[J.bQ,J.t,A.cc,A.ea])
q(J.bQ,[J.hg,J.di,J.bw])
r(J.h_,A.ex)
r(J.iD,J.t)
q(J.dZ,[J.d1,J.dY])
q(A.T,[A.d5,A.bg,A.h5,A.hE,A.hx,A.hN,A.fc,A.aX,A.eE,A.hD,A.dg,A.fm])
r(A.dj,A.G)
r(A.al,A.dj)
q(A.e,[A.C,A.by,A.eN,A.cu,A.eU,A.cB,A.cC,A.cD,A.cE,A.cF,A.cG,A.cI,A.cJ,A.cK,A.cL,A.cM,A.bK,A.dz,A.bu,A.ae,A.ce,A.cf,A.cg,A.ch,A.ci,A.cj,A.ck,A.cl,A.cm,A.cn,A.co,A.cp,A.D])
q(A.C,[A.aA,A.c3,A.ca,A.iP,A.eS])
q(A.aA,[A.eB,A.b0])
r(A.dA,A.by)
q(A.cN,[A.cO,A.c6])
q(A.aq,[A.fL,A.fi,A.fj,A.hz,A.kl,A.kn,A.jG,A.jF,A.ka,A.jU,A.kp,A.kr,A.ks,A.kh,A.i7,A.ij,A.iH,A.j_,A.iy,A.ix,A.iS,A.ku])
r(A.d_,A.fL)
r(A.ee,A.bg)
q(A.hz,[A.hy,A.cz])
q(A.ah,[A.b_,A.eR])
r(A.e0,A.b_)
q(A.fj,[A.km,A.kb,A.ke,A.jV,A.iQ,A.iU,A.it,A.iu,A.iv,A.j7,A.j8,A.jx])
q(A.ea,[A.h9,A.ai])
q(A.ai,[A.eW,A.eY])
r(A.eX,A.eW)
r(A.bR,A.eX)
r(A.eZ,A.eY)
r(A.aG,A.eZ)
q(A.bR,[A.e5,A.e6])
q(A.aG,[A.e7,A.e8,A.e9,A.eb,A.ec,A.ed,A.cd])
r(A.ds,A.hN)
q(A.fi,[A.jH,A.jI,A.k0,A.jM,A.jQ,A.jP,A.jO,A.jN,A.jT,A.jS,A.jR,A.kd,A.jY,A.k6,A.k5,A.ir])
r(A.eQ,A.hM)
r(A.hQ,A.f4)
r(A.dq,A.eR)
q(A.fo,[A.k2,A.k1,A.hG])
r(A.fs,A.cA)
q(A.fs,[A.h6,A.hF])
r(A.iM,A.k2)
r(A.iL,A.k1)
q(A.aX,[A.de,A.fI])
r(A.k8,A.jD)
r(A.k9,A.jE)
q(A.jK,[A.dn,A.fh,A.ib,A.as,A.dH,A.fe,A.ad,A.fr,A.ac,A.cP,A.c4,A.aY,A.cR,A.iF,A.d7,A.eq,A.bS,A.hj,A.bT,A.b2,A.ew,A.au,A.cr,A.a7,A.aU,A.cs,A.dl,A.fC,A.fy,A.fZ,A.ik,A.j9,A.h7,A.eM])
r(A.fJ,A.fK)
r(A.ef,A.he)
q(A.bK,[A.fk,A.cH])
r(A.fn,A.dz)
r(A.bL,A.aN)
q(A.a2,[A.aZ,A.c8,A.bt,A.aO,A.bc,A.bd,A.bs,A.br,A.be,A.bO,A.bN,A.bP,A.c9])
q(A.ic,[A.ff,A.ii,A.ip,A.is,A.h2,A.hh,A.iZ,A.j1,A.j5,A.jb,A.je,A.jz])
r(A.ie,A.ff)
q(A.ig,[A.i8,A.iq,A.jB,A.iI,A.hi,A.j6,A.jc,A.jf])
r(A.fP,A.bp)
q(A.fP,[A.dU,A.fR,A.fS,A.fT,A.dV])
r(A.fQ,A.dE)
r(A.fU,A.dJ)
r(A.fD,A.bn)
r(A.fE,A.jB)
q(A.bM,[A.c7,A.dP])
r(A.fV,A.er)
r(A.fW,A.hk)
r(A.bU,A.K)
q(A.bf,[A.hm,A.hn,A.hq,A.hr,A.ht,A.hu])
q(A.da,[A.eu,A.hs])
q(A.hv,[A.aR,A.L])
r(A.fX,A.eH)
r(A.fY,A.eL)
r(A.dW,A.dm)
q(A.ae,[A.cS,A.cT,A.dQ,A.dR,A.dS,A.dT,A.cU,A.cV,A.cW,A.cX,A.cY,A.cZ])
q(A.aQ,[A.eg,A.eh,A.ei,A.ej,A.ek,A.el,A.em,A.d6,A.aH])
r(A.hb,A.hw)
s(A.dj,A.bD)
s(A.eW,A.G)
s(A.eX,A.ar)
s(A.eY,A.G)
s(A.eZ,A.ar)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{f:"int",B:"double",k:"num",X:"String",b6:"bool",aj:"Null",q:"List",H:"Object",aP:"Map",Z:"JSObject"},mangledNames:{},types:["~(af)","f(f,bB,f)","~()","f([f])","~(bx,q<f>)","~(@)","~(f,f,f,f,f,bC)","~(~())","aj(@)","aj()","@()","H?(H?)","~(X,aE)","~(f,b6)","~(H?,H?)","aj(~())","~(f,a2)","aj(@,aT)","~(k,k,k,k)","bB(f)","f()","bx(f)","~(f,@)","b6(X)","aj(H,aT)","L(f,f)","f(f,f)","~(@,@)","k(k,k,k,k)","k(k,k,k,k,k)","aT?(aT?)","aj(Z)","@(@)","B(bo)","@(X)","@(@,X)","0^(0^,0^)<k>","aR(f,f)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.q6(v.typeUniverse,JSON.parse('{"bw":"bQ","hg":"bQ","di":"bQ","tu":"cc","h1":{"b6":[],"M":[]},"dX":{"M":[]},"e_":{"Z":[]},"bQ":{"Z":[]},"t":{"q":["1"],"C":["1"],"Z":[],"e":["1"],"ag":["1"]},"h_":{"ex":[]},"iD":{"t":["1"],"q":["1"],"C":["1"],"Z":[],"e":["1"],"ag":["1"]},"dy":{"A":["1"]},"dZ":{"B":[],"k":[]},"d1":{"B":[],"f":[],"k":[],"M":[]},"dY":{"B":[],"k":[],"M":[]},"d2":{"X":[],"mq":[],"ag":["@"],"M":[]},"d5":{"T":[]},"al":{"G":["f"],"bD":["f"],"q":["f"],"C":["f"],"e":["f"],"G.E":"f","bD.E":"f"},"C":{"e":["1"]},"aA":{"C":["1"],"e":["1"]},"eB":{"aA":["1"],"C":["1"],"e":["1"],"e.E":"1","aA.E":"1"},"cb":{"A":["1"]},"by":{"e":["2"],"e.E":"2"},"dA":{"by":["1","2"],"C":["2"],"e":["2"],"e.E":"2"},"e4":{"A":["2"]},"b0":{"aA":["2"],"C":["2"],"e":["2"],"e.E":"2","aA.E":"2"},"eN":{"e":["1"],"e.E":"1"},"eO":{"A":["1"]},"c3":{"C":["1"],"e":["1"],"e.E":"1"},"dB":{"A":["1"]},"cu":{"e":["1"],"e.E":"1"},"eP":{"A":["1"]},"dj":{"G":["1"],"bD":["1"],"q":["1"],"C":["1"],"e":["1"]},"cN":{"aP":["1","2"]},"cO":{"cN":["1","2"],"aP":["1","2"]},"eU":{"e":["1"],"e.E":"1"},"eV":{"A":["1"]},"c6":{"cN":["1","2"],"aP":["1","2"]},"fL":{"aq":[],"bq":[]},"d_":{"aq":[],"bq":[]},"ee":{"bg":[],"T":[]},"h5":{"T":[]},"hE":{"T":[]},"f0":{"aT":[]},"aq":{"bq":[]},"fi":{"aq":[],"bq":[]},"fj":{"aq":[],"bq":[]},"hz":{"aq":[],"bq":[]},"hy":{"aq":[],"bq":[]},"cz":{"aq":[],"bq":[]},"hx":{"T":[]},"b_":{"ah":["1","2"],"iN":["1","2"],"aP":["1","2"],"ah.K":"1","ah.V":"2"},"ca":{"C":["1"],"e":["1"],"e.E":"1"},"O":{"A":["1"]},"iP":{"C":["1"],"e":["1"],"e.E":"1"},"at":{"A":["1"]},"e0":{"b_":["1","2"],"ah":["1","2"],"iN":["1","2"],"aP":["1","2"],"ah.K":"1","ah.V":"2"},"cc":{"Z":[],"fg":[],"M":[]},"ea":{"Z":[],"a_":[]},"hU":{"fg":[]},"h9":{"ia":[],"Z":[],"a_":[],"M":[]},"ai":{"aF":["1"],"Z":[],"a_":[],"ag":["1"]},"bR":{"G":["B"],"ai":["B"],"q":["B"],"aF":["B"],"C":["B"],"Z":[],"a_":[],"ag":["B"],"e":["B"],"ar":["B"]},"aG":{"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"]},"e5":{"bR":[],"il":[],"G":["B"],"ai":["B"],"q":["B"],"aF":["B"],"C":["B"],"Z":[],"a_":[],"ag":["B"],"e":["B"],"ar":["B"],"M":[],"G.E":"B"},"e6":{"bR":[],"im":[],"G":["B"],"ai":["B"],"q":["B"],"aF":["B"],"C":["B"],"Z":[],"a_":[],"ag":["B"],"e":["B"],"ar":["B"],"M":[],"G.E":"B"},"e7":{"aG":[],"fM":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"e8":{"aG":[],"fN":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"e9":{"aG":[],"iB":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"eb":{"aG":[],"jj":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"ec":{"aG":[],"bB":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"ed":{"aG":[],"jk":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"cd":{"aG":[],"bC":[],"G":["f"],"ai":["f"],"q":["f"],"aF":["f"],"C":["f"],"Z":[],"a_":[],"ag":["f"],"e":["f"],"ar":["f"],"M":[],"G.E":"f"},"hN":{"T":[]},"ds":{"bg":[],"T":[]},"aM":{"T":[]},"eQ":{"hM":["1"]},"ab":{"c5":["1"]},"f4":{"mG":[]},"hQ":{"f4":[],"mG":[]},"eR":{"ah":["1","2"],"aP":["1","2"]},"dq":{"eR":["1","2"],"ah":["1","2"],"aP":["1","2"],"ah.K":"1","ah.V":"2"},"eS":{"C":["1"],"e":["1"],"e.E":"1"},"eT":{"A":["1"]},"G":{"q":["1"],"C":["1"],"e":["1"]},"ah":{"aP":["1","2"]},"fs":{"cA":["X","q<f>"]},"h6":{"cA":["X","q<f>"]},"hF":{"cA":["X","q<f>"]},"B":{"k":[]},"f":{"k":[]},"q":{"C":["1"],"e":["1"]},"X":{"mq":[]},"fc":{"T":[]},"bg":{"T":[]},"aX":{"T":[]},"de":{"T":[]},"fI":{"T":[]},"eE":{"T":[]},"hD":{"T":[]},"dg":{"T":[]},"fm":{"T":[]},"hc":{"T":[]},"ey":{"T":[]},"hS":{"aT":[]},"fJ":{"fK":[]},"ef":{"he":[]},"P":{"A":["k"]},"cB":{"x":[],"e":["k"],"e.E":"k"},"cC":{"x":[],"e":["k"],"e.E":"k"},"cD":{"x":[],"e":["k"],"e.E":"k"},"cE":{"x":[],"e":["k"],"e.E":"k"},"cF":{"x":[],"e":["k"],"e.E":"k"},"cG":{"x":[],"e":["k"],"e.E":"k"},"cI":{"x":[],"e":["k"],"e.E":"k"},"cJ":{"x":[],"e":["k"],"e.E":"k"},"cK":{"x":[],"e":["k"],"e.E":"k"},"cL":{"x":[],"e":["k"],"e.E":"k"},"cM":{"x":[],"e":["k"],"e.E":"k"},"bK":{"x":[],"e":["k"],"e.E":"k"},"fk":{"x":[],"e":["k"],"e.E":"k"},"cH":{"x":[],"e":["k"],"e.E":"k"},"dz":{"x":[],"e":["k"],"e.E":"k"},"fn":{"x":[],"e":["k"],"e.E":"k"},"bL":{"aN":[]},"aZ":{"a2":[]},"c8":{"a2":[]},"bt":{"a2":[]},"aO":{"a2":[]},"bc":{"a2":[]},"bd":{"a2":[]},"bs":{"a2":[]},"br":{"a2":[]},"be":{"a2":[]},"bO":{"a2":[]},"bN":{"a2":[]},"bP":{"a2":[]},"c9":{"a2":[]},"bn":{"K":[]},"dU":{"bp":[]},"fP":{"bp":[]},"fx":{"K":[]},"fQ":{"dE":[]},"fR":{"bp":[]},"fS":{"bp":[]},"fT":{"bp":[]},"dV":{"bp":[]},"fU":{"dJ":[]},"dK":{"K":[]},"fF":{"K":[]},"fD":{"bn":[],"K":[]},"c7":{"bM":[]},"dP":{"bM":[]},"fV":{"er":[]},"hk":{"K":[]},"fW":{"K":[]},"bU":{"K":[]},"hm":{"bf":[]},"hn":{"bf":[]},"hq":{"bf":[]},"hr":{"bf":[]},"ht":{"bf":[]},"hu":{"bf":[]},"eu":{"da":[]},"hs":{"da":[]},"ho":{"K":[]},"db":{"K":[]},"dc":{"K":[]},"ev":{"K":[]},"eD":{"K":[]},"hC":{"K":[]},"fY":{"eL":[]},"dm":{"K":[]},"dW":{"dm":[],"K":[]},"bu":{"e":["u"],"e.E":"u"},"ae":{"e":["u"]},"cS":{"ae":[],"e":["u"],"e.E":"u"},"cT":{"ae":[],"e":["u"],"e.E":"u"},"dQ":{"ae":[],"e":["u"],"e.E":"u"},"dR":{"ae":[],"e":["u"],"e.E":"u"},"dS":{"ae":[],"e":["u"],"e.E":"u"},"dT":{"ae":[],"e":["u"],"e.E":"u"},"cU":{"ae":[],"e":["u"],"e.E":"u"},"cV":{"ae":[],"e":["u"],"e.E":"u"},"cW":{"ae":[],"e":["u"],"e.E":"u"},"cX":{"ae":[],"e":["u"],"e.E":"u"},"cY":{"ae":[],"e":["u"],"e.E":"u"},"cZ":{"ae":[],"e":["u"],"e.E":"u"},"eg":{"aQ":[]},"eh":{"aQ":[]},"ei":{"aQ":[]},"ej":{"aQ":[]},"ek":{"aQ":[]},"el":{"aQ":[]},"em":{"aQ":[]},"d6":{"aQ":[]},"aH":{"aQ":[]},"ce":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cf":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cg":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"ch":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"ci":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cj":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"hf":{"A":["u"]},"ck":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cl":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cm":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cn":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"co":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"cp":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"D":{"u":[],"x":[],"e":["k"],"A":["u"],"e.E":"k"},"hb":{"hw":[]},"ia":{"a_":[]},"iB":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"bC":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"jk":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"fM":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"jj":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"fN":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"bB":{"q":["f"],"C":["f"],"a_":[],"e":["f"]},"il":{"q":["B"],"C":["B"],"a_":[],"e":["B"]},"im":{"q":["B"],"C":["B"],"a_":[],"e":["B"]},"u":{"x":[],"A":["u"],"e":["k"]}}'))
A.q5(v.typeUniverse,JSON.parse('{"C":1,"dj":1,"ai":1,"fo":2,"hv":1}'))
var u={c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",b:"PVRTC requires a power-of-two sized image.",g:"[native implementations worker] Error responding: "}
var t=(function rtii(){var s=A.U
return{n:s("aM"),dI:s("fg"),fd:s("ia"),G:s("x"),O:s("bo"),E:s("cO<X,f>"),gw:s("C<@>"),C:s("T"),aX:s("fu"),gV:s("fw"),h4:s("il"),eT:s("im"),Z:s("bq"),ct:s("dL"),gj:s("fz"),ak:s("fA"),fa:s("dM"),gx:s("fG"),P:s("aE"),r:s("a2"),v:s("ae"),dQ:s("fM"),k:s("fN"),cu:s("iB"),bM:s("e<B>"),W:s("e<@>"),hb:s("e<f>"),eB:s("t<fl>"),g9:s("t<fv>"),dw:s("t<dE>"),Y:s("t<dJ>"),e:s("t<dL>"),g:s("t<bu>"),dB:s("t<q<q<q<f>>>>"),o:s("t<q<q<f>>>"),S:s("t<q<f>>"),U:s("t<q<k>>"),dm:s("t<er>"),h0:s("t<cq>"),af:s("t<bf>"),cE:s("t<et>"),aK:s("t<aS>"),s:s("t<X>"),aU:s("t<hB>"),gN:s("t<bC>"),ao:s("t<bE>"),gk:s("t<hI>"),J:s("t<eL>"),cO:s("t<hO>"),e8:s("t<dr>"),gn:s("t<@>"),t:s("t<f>"),fR:s("t<bM?>"),f8:s("t<h3?>"),ca:s("t<q<f>?>"),hh:s("t<bB?>"),ff:s("t<bC?>"),a:s("t<k>"),A:s("t<~(af)>"),aP:s("ag<@>"),u:s("dX"),m:s("Z"),cj:s("bw"),ez:s("aF<@>"),c:s("bx"),cX:s("iN<@,@>"),dL:s("q<bo>"),gX:s("q<bu>"),f0:s("q<fN>"),fZ:s("q<q<q<f>>>"),gS:s("q<q<bE>>"),f:s("q<q<f>>"),eS:s("q<cq>"),dl:s("q<et>"),bJ:s("q<aS>"),c7:s("q<eF>"),e6:s("q<bE>"),eQ:s("q<eI>"),db:s("q<eJ>"),cC:s("q<eK>"),H:s("q<B>"),j:s("q<@>"),L:s("q<f>"),B:s("q<bM?>"),d:s("q<q<f>?>"),ge:s("q<bE?>"),gR:s("q<f_?>"),cP:s("q<f?>"),ck:s("aP<X,X>"),eO:s("aP<@,@>"),d4:s("bR"),bc:s("aG"),bm:s("cd"),b:s("aj"),K:s("H"),dv:s("u"),fW:s("cq"),fh:s("hp"),g0:s("eu"),hf:s("da"),fi:s("db"),aN:s("dd<aR>"),eZ:s("dd<L>"),h:s("aR"),R:s("L"),i:s("aS"),gT:s("tw"),l:s("aT"),N:s("X"),cV:s("hA"),ci:s("M"),eK:s("bg"),h7:s("jj"),bv:s("bB"),go:s("jk"),D:s("bC"),bI:s("di"),dd:s("eF"),ai:s("eI"),gU:s("eJ"),dE:s("eK"),cc:s("eN<X>"),_:s("ab<@>"),hg:s("dq<H?,H?>"),eP:s("f_"),y:s("b6"),al:s("b6(H)"),bB:s("b6(X)"),V:s("B"),z:s("@"),fO:s("@()"),x:s("@(H)"),Q:s("@(H,aT)"),p:s("f"),eH:s("c5<aj>?"),bC:s("fM?"),an:s("Z?"),T:s("q<f>?"),eA:s("q<bM?>?"),fl:s("q<q<f>?>?"),di:s("q<f?>?"),cZ:s("aP<X,X>?"),X:s("H?"),dk:s("X?"),aD:s("bC?"),eW:s("eG?"),aj:s("bE?"),dP:s("hJ?"),F:s("cv<@,@>?"),fQ:s("b6?"),cD:s("B?"),I:s("f?"),cg:s("k?"),e7:s("~(f,b6)?"),q:s("k"),w:s("~"),M:s("~()"),fb:s("~(bx,q<f>)"),d6:s("~(f,b6)"),dX:s("~(k,k,k,k)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.db=J.fO.prototype
B.c=J.t.prototype
B.a=J.d1.prototype
B.b=J.dZ.prototype
B.n=J.d2.prototype
B.dd=J.bw.prototype
B.de=J.e_.prototype
B.a4=A.e5.prototype
B.a5=A.e6.prototype
B.aw=A.e7.prototype
B.Z=A.e8.prototype
B.ax=A.e9.prototype
B.P=A.eb.prototype
B.o=A.ec.prototype
B.d=A.cd.prototype
B.cf=J.hg.prototype
B.b2=J.di.prototype
B.aB=new A.fe(0,"direct")
B.aC=new A.fe(1,"alpha")
B.aD=new A.ac(0,"none")
B.aa=new A.ac(3,"bitfields")
B.aE=new A.ac(6,"alphaBitfields")
B.ab=new A.fh(0,"littleEndian")
B.a0=new A.fh(1,"bigEndian")
B.cK=new A.d_(A.rH(),A.U("d_<B>"))
B.cL=new A.dB(A.U("dB<0&>"))
B.b4=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.cM=function() {
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
B.cR=function(getTagFallback) {
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
B.cN=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.cQ=function(hooks) {
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
B.cP=function(hooks) {
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
B.cO=function(hooks) {
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

B.b6=new A.h6()
B.b7=new A.iM()
B.cS=new A.hc()
B.ac=new A.ja()
B.cT=new A.hF()
B.D=new A.jC()
B.B=new A.hQ()
B.ad=new A.hS()
B.cU=new A.k8()
B.b8=new A.k9()
B.b9=new A.ib(4,"luminance")
B.cV=new A.fn(4294967295)
B.cW=new A.fr(0,"none")
B.ba=new A.fr(2,"floydSteinberg")
B.cX=new A.c4(0,"red")
B.cY=new A.c4(1,"green")
B.cZ=new A.c4(2,"blue")
B.d_=new A.c4(3,"alpha")
B.d0=new A.c4(4,"other")
B.bb=new A.cP(0,"uint")
B.aF=new A.cP(1,"half")
B.aG=new A.cP(2,"float")
B.bc=new A.aY(0,"none")
B.d8=new A.ik(2,"both")
B.L=new A.dH(0,"uint")
B.aH=new A.dH(1,"int")
B.aI=new A.dH(2,"float")
B.y=new A.as(0,"uint1")
B.t=new A.as(1,"uint2")
B.M=new A.as(10,"float32")
B.Q=new A.as(11,"float64")
B.z=new A.as(2,"uint4")
B.e=new A.as(3,"uint8")
B.m=new A.as(4,"uint16")
B.N=new A.as(5,"uint32")
B.R=new A.as(6,"int8")
B.S=new A.as(7,"int16")
B.T=new A.as(8,"int32")
B.E=new A.as(9,"float16")
B.bd=new A.fy(1,"page")
B.j=new A.fy(2,"sequence")
B.aJ=new A.fC(0,"none")
B.aK=new A.fC(1,"deflate")
B.be=new A.cR(2,"cur")
B.f=new A.ad(0,"none")
B.bf=new A.ad(1,"byte")
B.bg=new A.ad(10,"sRational")
B.bh=new A.ad(11,"single")
B.bi=new A.ad(12,"double")
B.bj=new A.ad(13,"ifd")
B.l=new A.ad(2,"ascii")
B.k=new A.ad(3,"short")
B.p=new A.ad(4,"long")
B.r=new A.ad(5,"rational")
B.bk=new A.ad(6,"sByte")
B.F=new A.ad(7,"undefined")
B.bl=new A.ad(8,"sShort")
B.bm=new A.ad(9,"sLong")
B.dc=new A.fZ(0,"nearest")
B.li=new A.fZ(1,"linear")
B.lj=new A.iF(0,"yuv444")
B.df=new A.iL(!1)
B.dg=new A.h7(1,"error")
B.dh=new A.h7(3,"info")
B.G=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15],t.t)
B.ae=s([0,2,8],t.t)
B.di=s([0,4,2,1],t.t)
B.d9=new A.cR(0,"invalid")
B.da=new A.cR(1,"ico")
B.dk=s([B.d9,B.da,B.be],A.U("t<cR>"))
B.aM=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0],t.t)
B.bo=s([252,243,207,63],t.t)
B.kk=new A.d7(0,"none")
B.ci=new A.d7(1,"background")
B.cj=new A.d7(2,"previous")
B.bp=s([B.kk,B.ci,B.cj],A.U("t<d7>"))
B.af=s([292,260,226,226],t.t)
B.bq=s([0,0,2,1,3,3,2,4,3,5,5,4,4,0,0,1,125],t.t)
B.dE=s([0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0],t.t)
B.br=s([2,3,7],t.t)
B.ag=s([3226,6412,200,168,38,38,134,134,100,100,100,100,68,68,68,68],t.t)
B.dH=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7],t.t)
B.dP=s([3,3,11],t.t)
B.bt=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7],t.t)
B.aU=s([128,128,128,128,128,128,128,128,128,128,128],t.t)
B.bx=s([B.aU,B.aU,B.aU],t.S)
B.eB=s([253,136,254,255,228,219,128,128,128,128,128],t.t)
B.fD=s([189,129,242,255,227,213,255,219,128,128,128],t.t)
B.fI=s([106,126,227,252,214,209,255,255,128,128,128],t.t)
B.ib=s([B.eB,B.fD,B.fI],t.S)
B.ij=s([1,98,248,255,236,226,255,255,128,128,128],t.t)
B.dV=s([181,133,238,254,221,234,255,154,128,128,128],t.t)
B.dT=s([78,134,202,247,198,180,255,219,128,128,128],t.t)
B.iJ=s([B.ij,B.dV,B.dT],t.S)
B.ew=s([1,185,249,255,243,255,128,128,128,128,128],t.t)
B.ig=s([184,150,247,255,236,224,128,128,128,128,128],t.t)
B.jy=s([77,110,216,255,236,230,128,128,128,128,128],t.t)
B.hE=s([B.ew,B.ig,B.jy],t.S)
B.hO=s([1,101,251,255,241,255,128,128,128,128,128],t.t)
B.ez=s([170,139,241,252,236,209,255,255,128,128,128],t.t)
B.hW=s([37,116,196,243,228,255,255,255,128,128,128],t.t)
B.ei=s([B.hO,B.ez,B.hW],t.S)
B.fW=s([1,204,254,255,245,255,128,128,128,128,128],t.t)
B.jQ=s([207,160,250,255,238,128,128,128,128,128,128],t.t)
B.jP=s([102,103,231,255,211,171,128,128,128,128,128],t.t)
B.f0=s([B.fW,B.jQ,B.jP],t.S)
B.eb=s([1,152,252,255,240,255,128,128,128,128,128],t.t)
B.jW=s([177,135,243,255,234,225,128,128,128,128,128],t.t)
B.hz=s([80,129,211,255,194,224,128,128,128,128,128],t.t)
B.ia=s([B.eb,B.jW,B.hz],t.S)
B.bD=s([1,1,255,128,128,128,128,128,128,128,128],t.t)
B.iB=s([246,1,255,128,128,128,128,128,128,128,128],t.t)
B.hj=s([255,128,128,128,128,128,128,128,128,128,128],t.t)
B.k6=s([B.bD,B.iB,B.hj],t.S)
B.eU=s([B.bx,B.ib,B.iJ,B.hE,B.ei,B.f0,B.ia,B.k6],t.o)
B.jA=s([198,35,237,223,193,187,162,160,145,155,62],t.t)
B.eA=s([131,45,198,221,172,176,220,157,252,221,1],t.t)
B.jz=s([68,47,146,208,149,167,221,162,255,223,128],t.t)
B.h4=s([B.jA,B.eA,B.jz],t.S)
B.iL=s([1,149,241,255,221,224,255,255,128,128,128],t.t)
B.j_=s([184,141,234,253,222,220,255,199,128,128,128],t.t)
B.hf=s([81,99,181,242,176,190,249,202,255,255,128],t.t)
B.jn=s([B.iL,B.j_,B.hf],t.S)
B.jd=s([1,129,232,253,214,197,242,196,255,255,128],t.t)
B.jN=s([99,121,210,250,201,198,255,202,128,128,128],t.t)
B.ic=s([23,91,163,242,170,187,247,210,255,255,128],t.t)
B.hm=s([B.jd,B.jN,B.ic],t.S)
B.fg=s([1,200,246,255,234,255,128,128,128,128,128],t.t)
B.ja=s([109,178,241,255,231,245,255,255,128,128,128],t.t)
B.dD=s([44,130,201,253,205,192,255,255,128,128,128],t.t)
B.jr=s([B.fg,B.ja,B.dD],t.S)
B.e4=s([1,132,239,251,219,209,255,165,128,128,128],t.t)
B.dl=s([94,136,225,251,218,190,255,255,128,128,128],t.t)
B.jf=s([22,100,174,245,186,161,255,199,128,128,128],t.t)
B.hM=s([B.e4,B.dl,B.jf],t.S)
B.iZ=s([1,182,249,255,232,235,128,128,128,128,128],t.t)
B.i4=s([124,143,241,255,227,234,128,128,128,128,128],t.t)
B.fz=s([35,77,181,251,193,211,255,205,128,128,128],t.t)
B.fK=s([B.iZ,B.i4,B.fz],t.S)
B.k7=s([1,157,247,255,236,231,255,255,128,128,128],t.t)
B.eT=s([121,141,235,255,225,227,255,255,128,128,128],t.t)
B.jb=s([45,99,188,251,195,217,255,224,128,128,128],t.t)
B.eh=s([B.k7,B.eT,B.jb],t.S)
B.dm=s([1,1,251,255,213,255,128,128,128,128,128],t.t)
B.dJ=s([203,1,248,255,255,128,128,128,128,128,128],t.t)
B.j0=s([137,1,177,255,224,255,128,128,128,128,128],t.t)
B.ec=s([B.dm,B.dJ,B.j0],t.S)
B.iS=s([B.h4,B.jn,B.hm,B.jr,B.hM,B.fK,B.eh,B.ec],t.o)
B.f4=s([253,9,248,251,207,208,255,192,128,128,128],t.t)
B.iC=s([175,13,224,243,193,185,249,198,255,255,128],t.t)
B.k4=s([73,17,171,221,161,179,236,167,255,234,128],t.t)
B.it=s([B.f4,B.iC,B.k4],t.S)
B.iP=s([1,95,247,253,212,183,255,255,128,128,128],t.t)
B.hs=s([239,90,244,250,211,209,255,255,128,128,128],t.t)
B.jx=s([155,77,195,248,188,195,255,255,128,128,128],t.t)
B.iY=s([B.iP,B.hs,B.jx],t.S)
B.fY=s([1,24,239,251,218,219,255,205,128,128,128],t.t)
B.iE=s([201,51,219,255,196,186,128,128,128,128,128],t.t)
B.hr=s([69,46,190,239,201,218,255,228,128,128,128],t.t)
B.iN=s([B.fY,B.iE,B.hr],t.S)
B.fG=s([1,191,251,255,255,128,128,128,128,128,128],t.t)
B.hU=s([223,165,249,255,213,255,128,128,128,128,128],t.t)
B.ii=s([141,124,248,255,255,128,128,128,128,128,128],t.t)
B.jc=s([B.fG,B.hU,B.ii],t.S)
B.h7=s([1,16,248,255,255,128,128,128,128,128,128],t.t)
B.eR=s([190,36,230,255,236,255,128,128,128,128,128],t.t)
B.eC=s([149,1,255,128,128,128,128,128,128,128,128],t.t)
B.e5=s([B.h7,B.eR,B.eC],t.S)
B.ie=s([1,226,255,128,128,128,128,128,128,128,128],t.t)
B.iw=s([247,192,255,128,128,128,128,128,128,128,128],t.t)
B.jw=s([240,128,255,128,128,128,128,128,128,128,128],t.t)
B.dL=s([B.ie,B.iw,B.jw],t.S)
B.jq=s([1,134,252,255,255,128,128,128,128,128,128],t.t)
B.i3=s([213,62,250,255,255,128,128,128,128,128,128],t.t)
B.jU=s([55,93,255,128,128,128,128,128,128,128,128],t.t)
B.id=s([B.jq,B.i3,B.jU],t.S)
B.es=s([B.it,B.iY,B.iN,B.jc,B.e5,B.dL,B.id,B.bx],t.o)
B.i5=s([202,24,213,235,186,191,220,160,240,175,255],t.t)
B.ey=s([126,38,182,232,169,184,228,174,255,187,128],t.t)
B.e8=s([61,46,138,219,151,178,240,170,255,216,128],t.t)
B.iW=s([B.i5,B.ey,B.e8],t.S)
B.hy=s([1,112,230,250,199,191,247,159,255,255,128],t.t)
B.eg=s([166,109,228,252,211,215,255,174,128,128,128],t.t)
B.hQ=s([39,77,162,232,172,180,245,178,255,255,128],t.t)
B.iU=s([B.hy,B.eg,B.hQ],t.S)
B.hA=s([1,52,220,246,198,199,249,220,255,255,128],t.t)
B.eZ=s([124,74,191,243,183,193,250,221,255,255,128],t.t)
B.fy=s([24,71,130,219,154,170,243,182,255,255,128],t.t)
B.iT=s([B.hA,B.eZ,B.fy],t.S)
B.fw=s([1,182,225,249,219,240,255,224,128,128,128],t.t)
B.jS=s([149,150,226,252,216,205,255,171,128,128,128],t.t)
B.kc=s([28,108,170,242,183,194,254,223,255,255,128],t.t)
B.jJ=s([B.fw,B.jS,B.kc],t.S)
B.kd=s([1,81,230,252,204,203,255,192,128,128,128],t.t)
B.j7=s([123,102,209,247,188,196,255,233,128,128,128],t.t)
B.ju=s([20,95,153,243,164,173,255,203,128,128,128],t.t)
B.j8=s([B.kd,B.j7,B.ju],t.S)
B.hc=s([1,222,248,255,216,213,128,128,128,128,128],t.t)
B.i2=s([168,175,246,252,235,205,255,255,128,128,128],t.t)
B.fB=s([47,116,215,255,211,212,255,255,128,128,128],t.t)
B.eM=s([B.hc,B.i2,B.fB],t.S)
B.hb=s([1,121,236,253,212,214,255,255,128,128,128],t.t)
B.hB=s([141,84,213,252,201,202,255,219,128,128,128],t.t)
B.ir=s([42,80,160,240,162,185,255,205,128,128,128],t.t)
B.fM=s([B.hb,B.hB,B.ir],t.S)
B.k_=s([244,1,255,128,128,128,128,128,128,128,128],t.t)
B.dj=s([238,1,255,128,128,128,128,128,128,128,128],t.t)
B.iy=s([B.bD,B.k_,B.dj],t.S)
B.dA=s([B.iW,B.iU,B.iT,B.jJ,B.j8,B.eM,B.fM,B.iy],t.o)
B.e6=s([B.eU,B.iS,B.es,B.dA],t.dB)
B.bu=s([511,1023,2047,4095],t.t)
B.bv=s([63,207,243,252],t.t)
B.ep=s([17,18,24,47,99,99,99,99,18,21,26,66,99,99,99,99,24,26,56,99,99,99,99,99,47,66,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99,99],t.t)
B.ah=s([0,1,2,3,4,5,6,7,8,9,10,11],t.t)
B.eE=s([8,8,4,2],t.t)
B.dw=s([173,148,140],t.t)
B.dx=s([176,155,140,135],t.t)
B.du=s([180,157,141,134,130],t.t)
B.dI=s([254,254,243,230,196,177,153,140,133,130,129],t.t)
B.bw=s([B.dw,B.dx,B.du,B.dI],t.S)
B.eI=s([0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576],t.t)
B.by=s([1,1.387039845,1.306562965,1.175875602,1,0.785694958,0.5411961,0.275899379],A.U("t<B>"))
B.eO=s([5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5],t.t)
B.bz=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095],t.t)
B.ai=s([0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29],t.t)
B.bA=s([1,2,3,0,4,17,5,18,33,49,65,6,19,81,97,7,34,113,20,50,129,145,161,8,35,66,177,193,21,82,209,240,36,51,98,114,130,9,10,22,23,24,25,26,37,38,39,40,41,42,52,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,225,226,227,228,229,230,231,232,233,234,241,242,243,244,245,246,247,248,249,250],t.t)
B.u=s([0,1,1,2,4,8,1,1,2,4,8,4,8,4],t.t)
B.bB=s([2954,2956,2958,2962,2970,2986,3018,3082,3212,3468,3980,5004],t.t)
B.aL=s([0,0,0],t.t)
B.hK=s([B.aL,B.aL,B.aL],t.S)
B.fC=s([0.375,1,0],t.a)
B.k9=s([0.375,0,1],t.a)
B.jL=s([0.25,1,1],t.a)
B.eG=s([B.fC,B.k9,B.jL],t.U)
B.hT=s([0.4375,1,0],t.a)
B.hS=s([0.1875,-1,1],t.a)
B.e3=s([0.3125,0,1],t.a)
B.iK=s([0.0625,1,1],t.a)
B.ip=s([B.hT,B.hS,B.e3,B.iK],t.U)
B.j6=s([0.19047619047619047,1,0],t.a)
B.k5=s([0.09523809523809523,2,0],t.a)
B.e7=s([0.047619047619047616,-2,1],t.a)
B.fq=s([0.09523809523809523,-1,1],t.a)
B.jI=s([0.19047619047619047,0,1],t.a)
B.h6=s([0.09523809523809523,1,1],t.a)
B.eY=s([0.047619047619047616,2,1],t.a)
B.jT=s([0.023809523809523808,-2,2],t.a)
B.jD=s([0.047619047619047616,-1,2],t.a)
B.ke=s([0.09523809523809523,0,2],t.a)
B.fl=s([0.047619047619047616,1,2],t.a)
B.jl=s([0.023809523809523808,2,2],t.a)
B.ff=s([B.j6,B.k5,B.e7,B.fq,B.jI,B.h6,B.eY,B.jT,B.jD,B.ke,B.fl,B.jl],t.U)
B.hl=s([0.125,1,0],t.a)
B.fP=s([0.125,2,0],t.a)
B.dC=s([0.125,-1,1],t.a)
B.fS=s([0.125,0,1],t.a)
B.hF=s([0.125,1,1],t.a)
B.ix=s([0.125,0,2],t.a)
B.eF=s([B.hl,B.fP,B.dC,B.fS,B.hF,B.ix],t.U)
B.bC=s([B.hK,B.eG,B.ip,B.ff,B.eF],A.U("t<q<q<k>>>"))
B.bE=s([280,256,256,256,40],t.t)
B.a1=s([0,1,5,6,14,15,27,28,2,4,7,13,16,26,29,42,3,8,12,17,25,30,41,43,9,11,18,24,31,40,44,53,10,19,23,32,39,45,52,54,20,22,33,38,46,51,55,60,21,34,37,47,50,56,59,61,35,36,48,49,57,58,62,63],t.t)
B.aj=s([62,62,30,30,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,3225,588,588,588,588,588,588,588,588,1680,1680,20499,22547,24595,26643,1776,1776,1808,1808,-24557,-22509,-20461,-18413,1904,1904,1936,1936,-16365,-14317,782,782,782,782,814,814,814,814,-12269,-10221,10257,10257,12305,12305,14353,14353,16403,18451,1712,1712,1744,1744,28691,30739,-32749,-30701,-28653,-26605,2061,2061,2061,2061,2061,2061,2061,2061,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,424,750,750,750,750,1616,1616,1648,1648,1424,1424,1456,1456,1488,1488,1520,1520,1840,1840,1872,1872,1968,1968,8209,8209,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,1552,1552,1584,1584,2000,2000,2032,2032,976,976,1008,1008,1040,1040,1072,1072,1296,1296,1328,1328,718,718,718,718,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,456,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,326,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,358,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,490,4113,4113,6161,6161,848,848,880,880,912,912,944,944,622,622,622,622,654,654,654,654,1104,1104,1136,1136,1168,1168,1200,1200,1232,1232,1264,1264,686,686,686,686,1360,1360,1392,1392,12,12,12,12,12,12,12,12,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390,390],t.t)
B.aP=s([4,5,6,7,8,9,10,10,11,12,13,14,15,16,17,17,18,19,20,20,21,21,22,22,23,23,24,25,25,26,27,28,29,30,31,32,33,34,35,36,37,37,38,39,40,41,42,43,44,45,46,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,76,77,78,79,80,81,82,83,84,85,86,87,88,89,91,93,95,96,98,100,101,102,104,106,108,110,112,114,116,118,122,124,126,128,130,132,134,136,138,140,143,145,148,151,154,157],t.t)
B.bF=s([24,7,23,25,40,6,39,41,22,26,38,42,56,5,55,57,21,27,54,58,37,43,72,4,71,73,20,28,53,59,70,74,36,44,88,69,75,52,60,3,87,89,19,29,86,90,35,45,68,76,85,91,51,61,104,2,103,105,18,30,102,106,34,46,84,92,67,77,101,107,50,62,120,1,119,121,83,93,17,31,100,108,66,78,118,122,33,47,117,123,49,63,99,109,82,94,0,116,124,65,79,16,32,98,110,48,115,125,81,95,64,114,126,97,111,80,113,127,96,112],t.t)
B.aQ=s([4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88,90,92,94,96,98,100,102,104,106,108,110,112,114,116,119,122,125,128,131,134,137,140,143,146,149,152,155,158,161,164,167,170,173,177,181,185,189,193,197,201,205,209,213,217,221,225,229,234,239,245,249,254,259,264,269,274,279,284],t.t)
B.bG=s([0,0,2,1,2,4,4,3,4,7,5,4,4,0,1,2,119],t.t)
B.aR=s([0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28],t.t)
B.bH=s([B.bb,B.aF,B.aG],A.U("t<cP>"))
B.a2=s([0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13],t.t)
B.U=s([0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15],t.t)
B.bI=s([254,253,251,247,239,223,191,127],t.t)
B.ak=s([12,8,140,8,76,8,204,8,44,8,172,8,108,8,236,8,28,8,156,8,92,8,220,8,60,8,188,8,124,8,252,8,2,8,130,8,66,8,194,8,34,8,162,8,98,8,226,8,18,8,146,8,82,8,210,8,50,8,178,8,114,8,242,8,10,8,138,8,74,8,202,8,42,8,170,8,106,8,234,8,26,8,154,8,90,8,218,8,58,8,186,8,122,8,250,8,6,8,134,8,70,8,198,8,38,8,166,8,102,8,230,8,22,8,150,8,86,8,214,8,54,8,182,8,118,8,246,8,14,8,142,8,78,8,206,8,46,8,174,8,110,8,238,8,30,8,158,8,94,8,222,8,62,8,190,8,126,8,254,8,1,8,129,8,65,8,193,8,33,8,161,8,97,8,225,8,17,8,145,8,81,8,209,8,49,8,177,8,113,8,241,8,9,8,137,8,73,8,201,8,41,8,169,8,105,8,233,8,25,8,153,8,89,8,217,8,57,8,185,8,121,8,249,8,5,8,133,8,69,8,197,8,37,8,165,8,101,8,229,8,21,8,149,8,85,8,213,8,53,8,181,8,117,8,245,8,13,8,141,8,77,8,205,8,45,8,173,8,109,8,237,8,29,8,157,8,93,8,221,8,61,8,189,8,125,8,253,8,19,9,275,9,147,9,403,9,83,9,339,9,211,9,467,9,51,9,307,9,179,9,435,9,115,9,371,9,243,9,499,9,11,9,267,9,139,9,395,9,75,9,331,9,203,9,459,9,43,9,299,9,171,9,427,9,107,9,363,9,235,9,491,9,27,9,283,9,155,9,411,9,91,9,347,9,219,9,475,9,59,9,315,9,187,9,443,9,123,9,379,9,251,9,507,9,7,9,263,9,135,9,391,9,71,9,327,9,199,9,455,9,39,9,295,9,167,9,423,9,103,9,359,9,231,9,487,9,23,9,279,9,151,9,407,9,87,9,343,9,215,9,471,9,55,9,311,9,183,9,439,9,119,9,375,9,247,9,503,9,15,9,271,9,143,9,399,9,79,9,335,9,207,9,463,9,47,9,303,9,175,9,431,9,111,9,367,9,239,9,495,9,31,9,287,9,159,9,415,9,95,9,351,9,223,9,479,9,63,9,319,9,191,9,447,9,127,9,383,9,255,9,511,9,0,7,64,7,32,7,96,7,16,7,80,7,48,7,112,7,8,7,72,7,40,7,104,7,24,7,88,7,56,7,120,7,4,7,68,7,36,7,100,7,20,7,84,7,52,7,116,7,3,8,131,8,67,8,195,8,35,8,163,8,99,8,227,8],t.t)
B.aS=s([A.t3(),A.rW(),A.ta(),A.t8(),A.t5(),A.t4(),A.t6()],t.A)
B.bJ=s([0,5,16,5,8,5,24,5,4,5,20,5,12,5,28,5,2,5,18,5,10,5,26,5,6,5,22,5,14,5,30,5,1,5,17,5,9,5,25,5,5,5,21,5,13,5,29,5,3,5,19,5,11,5,27,5,7,5,23,5],t.t)
B.b_=new A.a7(0,"whiteIsZero")
B.kN=new A.a7(1,"blackIsZero")
B.kU=new A.a7(2,"rgb")
B.b1=new A.a7(3,"palette")
B.kV=new A.a7(4,"transparencyMask")
B.cu=new A.a7(5,"cmyk")
B.kW=new A.a7(6,"yCbCr")
B.kX=new A.a7(7,"reserved7")
B.kY=new A.a7(8,"cieLab")
B.kZ=new A.a7(9,"iccLab")
B.kO=new A.a7(10,"ituLab")
B.kP=new A.a7(11,"logL")
B.kQ=new A.a7(12,"logLuv")
B.kR=new A.a7(13,"colorFilterArray")
B.kS=new A.a7(14,"linearRaw")
B.kT=new A.a7(15,"depth")
B.b0=new A.a7(16,"unknown")
B.bL=s([B.b_,B.kN,B.kU,B.b1,B.kV,B.cu,B.kW,B.kX,B.kY,B.kZ,B.kO,B.kP,B.kQ,B.kR,B.kS,B.kT,B.b0],A.U("t<a7>"))
B.bN=s([0,0,3,1,1,1,1,1,1,1,1,1,0,0,0,0,0],t.t)
B.v=s([0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31,31,31,31,31,31,31,31,31],t.t)
B.cg=new A.eq(0,"source")
B.ch=new A.eq(1,"over")
B.bO=s([B.cg,B.ch],A.U("t<eq>"))
B.kF=new A.cr(0,"invalid")
B.aY=new A.cr(1,"uint")
B.i=new A.cr(2,"int")
B.a_=new A.cr(3,"float")
B.bP=s([B.kF,B.aY,B.i,B.a_],A.U("t<cr>"))
B.bQ=s([17,18,0,1,2,3,4,5,16,6,7,8,9,10,11,12,13,14,15],t.t)
B.al=s([-0.0,1,-1,2,-2,3,4,6,-3,5,-4,-5,-6,7,-7,8,-8,-9],t.t)
B.aT=s([B.f,B.bf,B.l,B.k,B.p,B.r,B.bk,B.F,B.bl,B.bm,B.bg,B.bh,B.bi,B.bj],A.U("t<ad>"))
B.bR=s([0,1,4,8,5,2,3,6,9,12,13,10,7,11,14,15],t.t)
B.d1=new A.aY(1,"rle")
B.d2=new A.aY(2,"zips")
B.d3=new A.aY(3,"zip")
B.d4=new A.aY(4,"piz")
B.d5=new A.aY(5,"pxr24")
B.d6=new A.aY(6,"b44")
B.d7=new A.aY(7,"b44a")
B.bS=s([B.bc,B.d1,B.d2,B.d3,B.d4,B.d5,B.d6,B.d7],A.U("t<aY>"))
B.im=s([231,120,48,89,115,113,120,152,112],t.t)
B.dB=s([152,179,64,126,170,118,46,70,95],t.t)
B.hq=s([175,69,143,80,85,82,72,155,103],t.t)
B.dY=s([56,58,10,171,218,189,17,13,152],t.t)
B.hP=s([114,26,17,163,44,195,21,10,173],t.t)
B.i1=s([121,24,80,195,26,62,44,64,85],t.t)
B.hL=s([144,71,10,38,171,213,144,34,26],t.t)
B.jh=s([170,46,55,19,136,160,33,206,71],t.t)
B.fh=s([63,20,8,114,114,208,12,9,226],t.t)
B.fX=s([81,40,11,96,182,84,29,16,36],t.t)
B.dn=s([B.im,B.dB,B.hq,B.dY,B.hP,B.i1,B.hL,B.jh,B.fh,B.fX],t.S)
B.eQ=s([134,183,89,137,98,101,106,165,148],t.t)
B.j2=s([72,187,100,130,157,111,32,75,80],t.t)
B.i8=s([66,102,167,99,74,62,40,234,128],t.t)
B.dK=s([41,53,9,178,241,141,26,8,107],t.t)
B.fT=s([74,43,26,146,73,166,49,23,157],t.t)
B.fr=s([65,38,105,160,51,52,31,115,128],t.t)
B.fu=s([104,79,12,27,217,255,87,17,7],t.t)
B.ho=s([87,68,71,44,114,51,15,186,23],t.t)
B.iV=s([47,41,14,110,182,183,21,17,194],t.t)
B.iA=s([66,45,25,102,197,189,23,18,22],t.t)
B.jv=s([B.eQ,B.j2,B.i8,B.dK,B.fT,B.fr,B.fu,B.ho,B.iV,B.iA],t.S)
B.il=s([88,88,147,150,42,46,45,196,205],t.t)
B.hR=s([43,97,183,117,85,38,35,179,61],t.t)
B.fA=s([39,53,200,87,26,21,43,232,171],t.t)
B.hi=s([56,34,51,104,114,102,29,93,77],t.t)
B.hG=s([39,28,85,171,58,165,90,98,64],t.t)
B.fm=s([34,22,116,206,23,34,43,166,73],t.t)
B.dp=s([107,54,32,26,51,1,81,43,31],t.t)
B.jk=s([68,25,106,22,64,171,36,225,114],t.t)
B.eP=s([34,19,21,102,132,188,16,76,124],t.t)
B.jF=s([62,18,78,95,85,57,50,48,51],t.t)
B.f2=s([B.il,B.hR,B.fA,B.hi,B.hG,B.fm,B.dp,B.jk,B.eP,B.jF],t.S)
B.hC=s([193,101,35,159,215,111,89,46,111],t.t)
B.er=s([60,148,31,172,219,228,21,18,111],t.t)
B.e2=s([112,113,77,85,179,255,38,120,114],t.t)
B.jB=s([40,42,1,196,245,209,10,25,109],t.t)
B.h9=s([88,43,29,140,166,213,37,43,154],t.t)
B.fo=s([61,63,30,155,67,45,68,1,209],t.t)
B.fH=s([100,80,8,43,154,1,51,26,71],t.t)
B.dN=s([142,78,78,16,255,128,34,197,171],t.t)
B.hx=s([41,40,5,102,211,183,4,1,221],t.t)
B.f8=s([51,50,17,168,209,192,23,25,82],t.t)
B.f1=s([B.hC,B.er,B.e2,B.jB,B.h9,B.fo,B.fH,B.dN,B.hx,B.f8],t.S)
B.fx=s([138,31,36,171,27,166,38,44,229],t.t)
B.f_=s([67,87,58,169,82,115,26,59,179],t.t)
B.iI=s([63,59,90,180,59,166,93,73,154],t.t)
B.js=s([40,40,21,116,143,209,34,39,175],t.t)
B.dS=s([47,15,16,183,34,223,49,45,183],t.t)
B.ex=s([46,17,33,183,6,98,15,32,183],t.t)
B.kf=s([57,46,22,24,128,1,54,17,37],t.t)
B.fJ=s([65,32,73,115,28,128,23,128,205],t.t)
B.i7=s([40,3,9,115,51,192,18,6,223],t.t)
B.fQ=s([87,37,9,115,59,77,64,21,47],t.t)
B.hw=s([B.fx,B.f_,B.iI,B.js,B.dS,B.ex,B.kf,B.fJ,B.i7,B.fQ],t.S)
B.jZ=s([104,55,44,218,9,54,53,130,226],t.t)
B.ef=s([64,90,70,205,40,41,23,26,57],t.t)
B.iH=s([54,57,112,184,5,41,38,166,213],t.t)
B.fn=s([30,34,26,133,152,116,10,32,134],t.t)
B.iu=s([39,19,53,221,26,114,32,73,255],t.t)
B.f6=s([31,9,65,234,2,15,1,118,73],t.t)
B.hv=s([75,32,12,51,192,255,160,43,51],t.t)
B.fp=s([88,31,35,67,102,85,55,186,85],t.t)
B.h1=s([56,21,23,111,59,205,45,37,192],t.t)
B.h2=s([55,38,70,124,73,102,1,34,98],t.t)
B.k2=s([B.jZ,B.ef,B.iH,B.fn,B.iu,B.f6,B.hv,B.fp,B.h1,B.h2],t.S)
B.h0=s([125,98,42,88,104,85,117,175,82],t.t)
B.ft=s([95,84,53,89,128,100,113,101,45],t.t)
B.hX=s([75,79,123,47,51,128,81,171,1],t.t)
B.ed=s([57,17,5,71,102,57,53,41,49],t.t)
B.iD=s([38,33,13,121,57,73,26,1,85],t.t)
B.jR=s([41,10,67,138,77,110,90,47,114],t.t)
B.ht=s([115,21,2,10,102,255,166,23,6],t.t)
B.eS=s([101,29,16,10,85,128,101,196,26],t.t)
B.fF=s([57,18,10,102,102,213,34,20,43],t.t)
B.h8=s([117,20,15,36,163,128,68,1,26],t.t)
B.hn=s([B.h0,B.ft,B.hX,B.ed,B.iD,B.jR,B.ht,B.eS,B.fF,B.h8],t.S)
B.fN=s([102,61,71,37,34,53,31,243,192],t.t)
B.jO=s([69,60,71,38,73,119,28,222,37],t.t)
B.fR=s([68,45,128,34,1,47,11,245,171],t.t)
B.dt=s([62,17,19,70,146,85,55,62,70],t.t)
B.ka=s([37,43,37,154,100,163,85,160,1],t.t)
B.jK=s([63,9,92,136,28,64,32,201,85],t.t)
B.j5=s([75,15,9,9,64,255,184,119,16],t.t)
B.eX=s([86,6,28,5,64,255,25,248,1],t.t)
B.iz=s([56,8,17,132,137,255,55,116,128],t.t)
B.e9=s([58,15,20,82,135,57,26,121,40],t.t)
B.hJ=s([B.fN,B.jO,B.fR,B.dt,B.ka,B.jK,B.j5,B.eX,B.iz,B.e9],t.S)
B.i_=s([164,50,31,137,154,133,25,35,218],t.t)
B.eW=s([51,103,44,131,131,123,31,6,158],t.t)
B.jH=s([86,40,64,135,148,224,45,183,128],t.t)
B.hp=s([22,26,17,131,240,154,14,1,209],t.t)
B.eu=s([45,16,21,91,64,222,7,1,197],t.t)
B.jt=s([56,21,39,155,60,138,23,102,213],t.t)
B.k1=s([83,12,13,54,192,255,68,47,28],t.t)
B.i9=s([85,26,85,85,128,128,32,146,171],t.t)
B.hk=s([18,11,7,63,144,171,4,4,246],t.t)
B.f3=s([35,27,10,146,174,171,12,26,128],t.t)
B.hd=s([B.i_,B.eW,B.jH,B.hp,B.eu,B.jt,B.k1,B.i9,B.hk,B.f3],t.S)
B.iR=s([190,80,35,99,180,80,126,54,45],t.t)
B.jg=s([85,126,47,87,176,51,41,20,32],t.t)
B.iF=s([101,75,128,139,118,146,116,128,85],t.t)
B.j1=s([56,41,15,176,236,85,37,9,62],t.t)
B.ea=s([71,30,17,119,118,255,17,18,138],t.t)
B.hI=s([101,38,60,138,55,70,43,26,142],t.t)
B.hg=s([146,36,19,30,171,255,97,27,20],t.t)
B.ik=s([138,45,61,62,219,1,81,188,64],t.t)
B.jC=s([32,41,20,117,151,142,20,21,163],t.t)
B.ji=s([112,19,12,61,195,128,48,4,24],t.t)
B.iM=s([B.iR,B.jg,B.iF,B.j1,B.ea,B.hI,B.hg,B.ik,B.jC,B.ji],t.S)
B.bT=s([B.dn,B.jv,B.f2,B.f1,B.hw,B.k2,B.hn,B.hJ,B.hd,B.iM],t.o)
B.ay=new A.au(0,"none")
B.J=new A.au(1,"palette")
B.cs=new A.au(2,"rgb")
B.kz=new A.au(3,"gray")
B.kA=new A.au(4,"reserved4")
B.kB=new A.au(5,"reserved5")
B.kC=new A.au(6,"reserved6")
B.kD=new A.au(7,"reserved7")
B.kE=new A.au(8,"reserved8")
B.K=new A.au(9,"paletteRle")
B.cr=new A.au(10,"rgbRle")
B.ky=new A.au(11,"grayRle")
B.bU=s([B.ay,B.J,B.cs,B.kz,B.kA,B.kB,B.kC,B.kD,B.kE,B.K,B.cr,B.ky],A.U("t<au>"))
B.bV=s([0,1,2,3,17,4,5,33,49,6,18,65,81,7,97,113,19,34,50,129,8,20,66,145,161,177,193,9,35,51,82,240,21,98,114,209,10,22,36,52,225,37,241,23,24,25,26,38,39,40,41,42,53,54,55,56,57,58,67,68,69,70,71,72,73,74,83,84,85,86,87,88,89,90,99,100,101,102,103,104,105,106,115,116,117,118,119,120,121,122,130,131,132,133,134,135,136,137,138,146,147,148,149,150,151,152,153,154,162,163,164,165,166,167,168,169,170,178,179,180,181,182,183,184,185,186,194,195,196,197,198,199,200,201,202,210,211,212,213,214,215,216,217,218,226,227,228,229,230,231,232,233,234,242,243,244,245,246,247,248,249,250],t.t)
B.hV=s([0,1,1,1,0],t.t)
B.bW=s([A.rO(),A.rV(),A.rX(),A.rQ(),A.rT(),A.rZ(),A.rS(),A.rY(),A.rP(),A.rR()],t.A)
B.aO=s([8,0,8,0],t.t)
B.ee=s([5,3,5,3],t.t)
B.dQ=s([3,5,3,5],t.t)
B.bn=s([0,8,0,8],t.t)
B.bs=s([4,4,4,4],t.t)
B.e1=s([4,4,0,0],t.t)
B.bX=s([B.aO,B.ee,B.dQ,B.bn,B.aO,B.bs,B.e1,B.bn],t.S)
B.bY=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535],t.t)
B.am=s([80,88,23,71,30,30,62,62,4,4,4,4,4,4,4,4,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,35,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,51,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41,41],t.t)
B.ih=s([16,11,10,16,24,40,51,61,12,12,14,19,26,58,60,55,14,13,16,24,40,57,69,56,14,17,22,29,51,87,80,62,18,22,37,56,68,109,103,77,24,35,55,64,81,104,113,92,49,64,78,87,103,121,120,101,72,92,95,98,112,100,103,99],t.t)
B.V=s([0,1,4,5,16,17,20,21,64,65,68,69,80,81,84,85,256,257,260,261,272,273,276,277,320,321,324,325,336,337,340,341,1024,1025,1028,1029,1040,1041,1044,1045,1088,1089,1092,1093,1104,1105,1108,1109,1280,1281,1284,1285,1296,1297,1300,1301,1344,1345,1348,1349,1360,1361,1364,1365,4096,4097,4100,4101,4112,4113,4116,4117,4160,4161,4164,4165,4176,4177,4180,4181,4352,4353,4356,4357,4368,4369,4372,4373,4416,4417,4420,4421,4432,4433,4436,4437,5120,5121,5124,5125,5136,5137,5140,5141,5184,5185,5188,5189,5200,5201,5204,5205,5376,5377,5380,5381,5392,5393,5396,5397,5440,5441,5444,5445,5456,5457,5460,5461,16384,16385,16388,16389,16400,16401,16404,16405,16448,16449,16452,16453,16464,16465,16468,16469,16640,16641,16644,16645,16656,16657,16660,16661,16704,16705,16708,16709,16720,16721,16724,16725,17408,17409,17412,17413,17424,17425,17428,17429,17472,17473,17476,17477,17488,17489,17492,17493,17664,17665,17668,17669,17680,17681,17684,17685,17728,17729,17732,17733,17744,17745,17748,17749,20480,20481,20484,20485,20496,20497,20500,20501,20544,20545,20548,20549,20560,20561,20564,20565,20736,20737,20740,20741,20752,20753,20756,20757,20800,20801,20804,20805,20816,20817,20820,20821,21504,21505,21508,21509,21520,21521,21524,21525,21568,21569,21572,21573,21584,21585,21588,21589,21760,21761,21764,21765,21776,21777,21780,21781,21824,21825,21828,21829,21840,21841,21844,21845],t.t)
B.bZ=s([127,127,191,127,159,191,223,127,143,159,175,191,207,223,239,127,135,143,151,159,167,175,183,191,199,207,215,223,231,239,247,127,131,135,139,143,147,151,155,159,163,167,171,175,179,183,187,191,195,199,203,207,211,215,219,223,227,231,235,239,243,247,251,127,129,131,133,135,137,139,141,143,145,147,149,151,153,155,157,159,161,163,165,167,169,171,173,175,177,179,181,183,185,187,189,191,193,195,197,199,201,203,205,207,209,211,213,215,217,219,221,223,225,227,229,231,233,235,237,239,241,243,245,247,249,251,253,127],t.t)
B.an=s([7,6,6,5,5,5,5,4,4,4,4,4,4,4,4,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0],t.t)
B.H=s([28679,28679,31752,-32759,-31735,-30711,-29687,-28663,29703,29703,30727,30727,-27639,-26615,-25591,-24567],t.t)
B.ao=s([6430,6400,6400,6400,3225,3225,3225,3225,944,944,944,944,976,976,976,976,1456,1456,1456,1456,1488,1488,1488,1488,718,718,718,718,718,718,718,718,750,750,750,750,750,750,750,750,1520,1520,1520,1520,1552,1552,1552,1552,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,428,654,654,654,654,654,654,654,654,1072,1072,1072,1072,1104,1104,1104,1104,1136,1136,1136,1136,1168,1168,1168,1168,1200,1200,1200,1200,1232,1232,1232,1232,622,622,622,622,622,622,622,622,1008,1008,1008,1008,1040,1040,1040,1040,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,44,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,396,1712,1712,1712,1712,1744,1744,1744,1744,846,846,846,846,846,846,846,846,1264,1264,1264,1264,1296,1296,1296,1296,1328,1328,1328,1328,1360,1360,1360,1360,1392,1392,1392,1392,1424,1424,1424,1424,686,686,686,686,686,686,686,686,910,910,910,910,910,910,910,910,1968,1968,1968,1968,2000,2000,2000,2000,2032,2032,2032,2032,16,16,16,16,10257,10257,10257,10257,12305,12305,12305,12305,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,330,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,362,878,878,878,878,878,878,878,878,1904,1904,1904,1904,1936,1936,1936,1936,-18413,-18413,-16365,-16365,-14317,-14317,-10221,-10221,590,590,590,590,590,590,590,590,782,782,782,782,782,782,782,782,1584,1584,1584,1584,1616,1616,1616,1616,1648,1648,1648,1648,1680,1680,1680,1680,814,814,814,814,814,814,814,814,1776,1776,1776,1776,1808,1808,1808,1808,1840,1840,1840,1840,1872,1872,1872,1872,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,6157,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,-12275,14353,14353,14353,14353,16401,16401,16401,16401,22547,22547,24595,24595,20497,20497,20497,20497,18449,18449,18449,18449,26643,26643,28691,28691,30739,30739,-32749,-32749,-30701,-30701,-28653,-28653,-26605,-26605,-24557,-24557,-22509,-22509,-20461,-20461,8207,8207,8207,8207,8207,8207,8207,8207,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,72,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,104,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,4107,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,266,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,298,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,524,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,556,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,136,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,168,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,460,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,492,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,2059,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,200,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232,232],t.t)
B.I=s([0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,30,30,30,30,30,30,30,30,31],t.t)
B.aq=s([0,1,2,3,6,4,5,6,6,6,6,6,6,6,6,7,0],t.t)
B.kl=new A.bS(0,"none")
B.km=new A.bS(1,"sub")
B.kn=new A.bS(2,"up")
B.ko=new A.bS(3,"average")
B.kp=new A.bS(4,"paeth")
B.ar=s([B.kl,B.km,B.kn,B.ko,B.kp],A.U("t<bS>"))
B.C=s([0,1996959894,3993919788,2567524794,124634137,1886057615,3915621685,2657392035,249268274,2044508324,3772115230,2547177864,162941995,2125561021,3887607047,2428444049,498536548,1789927666,4089016648,2227061214,450548861,1843258603,4107580753,2211677639,325883990,1684777152,4251122042,2321926636,335633487,1661365465,4195302755,2366115317,997073096,1281953886,3579855332,2724688242,1006888145,1258607687,3524101629,2768942443,901097722,1119000684,3686517206,2898065728,853044451,1172266101,3705015759,2882616665,651767980,1373503546,3369554304,3218104598,565507253,1454621731,3485111705,3099436303,671266974,1594198024,3322730930,2970347812,795835527,1483230225,3244367275,3060149565,1994146192,31158534,2563907772,4023717930,1907459465,112637215,2680153253,3904427059,2013776290,251722036,2517215374,3775830040,2137656763,141376813,2439277719,3865271297,1802195444,476864866,2238001368,4066508878,1812370925,453092731,2181625025,4111451223,1706088902,314042704,2344532202,4240017532,1658658271,366619977,2362670323,4224994405,1303535960,984961486,2747007092,3569037538,1256170817,1037604311,2765210733,3554079995,1131014506,879679996,2909243462,3663771856,1141124467,855842277,2852801631,3708648649,1342533948,654459306,3188396048,3373015174,1466479909,544179635,3110523913,3462522015,1591671054,702138776,2966460450,3352799412,1504918807,783551873,3082640443,3233442989,3988292384,2596254646,62317068,1957810842,3939845945,2647816111,81470997,1943803523,3814918930,2489596804,225274430,2053790376,3826175755,2466906013,167816743,2097651377,4027552580,2265490386,503444072,1762050814,4150417245,2154129355,426522225,1852507879,4275313526,2312317920,282753626,1742555852,4189708143,2394877945,397917763,1622183637,3604390888,2714866558,953729732,1340076626,3518719985,2797360999,1068828381,1219638859,3624741850,2936675148,906185462,1090812512,3747672003,2825379669,829329135,1181335161,3412177804,3160834842,628085408,1382605366,3423369109,3138078467,570562233,1426400815,3317316542,2998733608,733239954,1555261956,3268935591,3050360625,752459403,1541320221,2607071920,3965973030,1969922972,40735498,2617837225,3943577151,1913087877,83908371,2512341634,3803740692,2075208622,213261112,2463272603,3855990285,2094854071,198958881,2262029012,4057260610,1759359992,534414190,2176718541,4139329115,1873836001,414664567,2282248934,4279200368,1711684554,285281116,2405801727,4167216745,1634467795,376229701,2685067896,3608007406,1308918612,956543938,2808555105,3495958263,1231636301,1047427035,2932959818,3654703836,1088359270,936918e3,2847714899,3736837829,1202900863,817233897,3183342108,3401237130,1404277552,615818150,3134207493,3453421203,1423857449,601450431,3009837614,3294710456,1567103746,711928724,3020668471,3272380065,1510334235,755167117],t.t)
B.A=s([0,1,3,7,15,31,63,127,255],t.t)
B.as=s([16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15],t.t)
B.at=s([0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,6,7],t.t)
B.w=s([255,255,255,255,255,255,255,255,255,255,255],t.t)
B.X=s([B.w,B.w,B.w],t.S)
B.hh=s([176,246,255,255,255,255,255,255,255,255,255],t.t)
B.jV=s([223,241,252,255,255,255,255,255,255,255,255],t.t)
B.eL=s([249,253,253,255,255,255,255,255,255,255,255],t.t)
B.hu=s([B.hh,B.jV,B.eL],t.S)
B.fZ=s([255,244,252,255,255,255,255,255,255,255,255],t.t)
B.fL=s([234,254,254,255,255,255,255,255,255,255,255],t.t)
B.c3=s([253,255,255,255,255,255,255,255,255,255,255],t.t)
B.eV=s([B.fZ,B.fL,B.c3],t.S)
B.jG=s([255,246,254,255,255,255,255,255,255,255,255],t.t)
B.iv=s([239,253,254,255,255,255,255,255,255,255,255],t.t)
B.c_=s([254,255,254,255,255,255,255,255,255,255,255],t.t)
B.j3=s([B.jG,B.iv,B.c_],t.S)
B.bK=s([255,248,254,255,255,255,255,255,255,255,255],t.t)
B.fc=s([251,255,254,255,255,255,255,255,255,255,255],t.t)
B.i0=s([B.bK,B.fc,B.w],t.S)
B.aN=s([255,253,254,255,255,255,255,255,255,255,255],t.t)
B.hZ=s([251,254,254,255,255,255,255,255,255,255,255],t.t)
B.fk=s([B.aN,B.hZ,B.c_],t.S)
B.dW=s([255,254,253,255,254,255,255,255,255,255,255],t.t)
B.fV=s([250,255,254,255,254,255,255,255,255,255,255],t.t)
B.ap=s([254,255,255,255,255,255,255,255,255,255,255],t.t)
B.ha=s([B.dW,B.fV,B.ap],t.S)
B.fE=s([B.X,B.hu,B.eV,B.j3,B.i0,B.fk,B.ha,B.X],t.o)
B.dz=s([217,255,255,255,255,255,255,255,255,255,255],t.t)
B.he=s([225,252,241,253,255,255,254,255,255,255,255],t.t)
B.iG=s([234,250,241,250,253,255,253,254,255,255,255],t.t)
B.jj=s([B.dz,B.he,B.iG],t.S)
B.aV=s([255,254,255,255,255,255,255,255,255,255,255],t.t)
B.eN=s([223,254,254,255,255,255,255,255,255,255,255],t.t)
B.ev=s([238,253,254,254,255,255,255,255,255,255,255],t.t)
B.is=s([B.aV,B.eN,B.ev],t.S)
B.fO=s([249,254,255,255,255,255,255,255,255,255,255],t.t)
B.jE=s([B.bK,B.fO,B.w],t.S)
B.jm=s([255,253,255,255,255,255,255,255,255,255,255],t.t)
B.hY=s([247,254,255,255,255,255,255,255,255,255,255],t.t)
B.hN=s([B.jm,B.hY,B.w],t.S)
B.eq=s([252,255,255,255,255,255,255,255,255,255,255],t.t)
B.dM=s([B.aN,B.eq,B.w],t.S)
B.c5=s([255,254,254,255,255,255,255,255,255,255,255],t.t)
B.et=s([B.c5,B.c3,B.w],t.S)
B.iq=s([255,254,253,255,255,255,255,255,255,255,255],t.t)
B.bM=s([250,255,255,255,255,255,255,255,255,255,255],t.t)
B.eo=s([B.iq,B.bM,B.ap],t.S)
B.dZ=s([B.jj,B.is,B.jE,B.hN,B.dM,B.et,B.eo,B.X],t.o)
B.iO=s([186,251,250,255,255,255,255,255,255,255,255],t.t)
B.f9=s([234,251,244,254,255,255,255,255,255,255,255],t.t)
B.j4=s([251,251,243,253,254,255,254,255,255,255,255],t.t)
B.fi=s([B.iO,B.f9,B.j4],t.S)
B.fe=s([236,253,254,255,255,255,255,255,255,255,255],t.t)
B.io=s([251,253,253,254,254,255,255,255,255,255,255],t.t)
B.h3=s([B.aN,B.fe,B.io],t.S)
B.iQ=s([254,254,254,255,255,255,255,255,255,255,255],t.t)
B.fa=s([B.c5,B.iQ,B.w],t.S)
B.j9=s([254,254,255,255,255,255,255,255,255,255,255],t.t)
B.fd=s([B.aV,B.j9,B.ap],t.S)
B.c6=s([B.w,B.ap,B.w],t.S)
B.dX=s([B.fi,B.h3,B.fa,B.fd,B.c6,B.X,B.X,B.X],t.o)
B.fU=s([248,255,255,255,255,255,255,255,255,255,255],t.t)
B.fs=s([250,254,252,254,255,255,255,255,255,255,255],t.t)
B.f7=s([248,254,249,253,255,255,255,255,255,255,255],t.t)
B.h5=s([B.fU,B.fs,B.f7],t.S)
B.dU=s([255,253,253,255,255,255,255,255,255,255,255],t.t)
B.jp=s([246,253,253,255,255,255,255,255,255,255,255],t.t)
B.fj=s([252,254,251,254,254,255,255,255,255,255,255],t.t)
B.jo=s([B.dU,B.jp,B.fj],t.S)
B.k8=s([255,254,252,255,255,255,255,255,255,255,255],t.t)
B.f5=s([248,254,253,255,255,255,255,255,255,255,255],t.t)
B.en=s([253,255,254,254,255,255,255,255,255,255,255],t.t)
B.i6=s([B.k8,B.f5,B.en],t.S)
B.k0=s([255,251,254,255,255,255,255,255,255,255,255],t.t)
B.hD=s([245,251,254,255,255,255,255,255,255,255,255],t.t)
B.hH=s([253,253,254,255,255,255,255,255,255,255,255],t.t)
B.eH=s([B.k0,B.hD,B.hH],t.S)
B.eJ=s([255,251,253,255,255,255,255,255,255,255,255],t.t)
B.h_=s([252,253,254,255,255,255,255,255,255,255,255],t.t)
B.iX=s([B.eJ,B.h_,B.aV],t.S)
B.ej=s([255,252,255,255,255,255,255,255,255,255,255],t.t)
B.jY=s([249,255,254,255,255,255,255,255,255,255,255],t.t)
B.fv=s([255,255,254,255,255,255,255,255,255,255,255],t.t)
B.ds=s([B.ej,B.jY,B.fv],t.S)
B.kb=s([255,255,253,255,255,255,255,255,255,255,255],t.t)
B.fb=s([B.kb,B.bM,B.w],t.S)
B.em=s([B.h5,B.jo,B.i6,B.eH,B.iX,B.ds,B.fb,B.c6],t.o)
B.je=s([B.fE,B.dZ,B.dX,B.em],t.dB)
B.cz=new A.ac(1,"rle8")
B.cE=new A.ac(2,"rle4")
B.cF=new A.ac(4,"jpeg")
B.cG=new A.ac(5,"png")
B.cH=new A.ac(7,"reserved7")
B.cI=new A.ac(8,"reserved8")
B.cJ=new A.ac(9,"reserved9")
B.cA=new A.ac(10,"reserved10")
B.cB=new A.ac(11,"cmyk")
B.cC=new A.ac(12,"cmykRle8")
B.cD=new A.ac(13,"cmykRle4")
B.au=s([B.aD,B.cz,B.cE,B.aa,B.cF,B.cG,B.aE,B.cH,B.cI,B.cJ,B.cA,B.cB,B.cC,B.cD],A.U("t<ac>"))
B.W=s([0,128,192,224,240,248,252,254,255],t.t)
B.c0=s([137,80,78,71,13,10,26,10],t.t)
B.a3=s([0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535,131071,262143,524287,1048575,2097151,4194303,8388607,16777215,33554431,67108863,134217727,268435455,536870911,1073741823,2147483647,4294967295],t.t)
B.c1=s([3,4,5,6,7,8,9,10,11,13,15,17,19,23,27,31,35,43,51,59,67,83,99,115,131,163,195,227,258],t.t)
B.c2=s([1,2,3,4,5,7,9,13,17,25,33,49,65,97,129,193,257,385,513,769,1025,1537,2049,3073,4097,6145,8193,12289,16385,24577],t.t)
B.cv=new A.cs(0,"predictor")
B.ld=new A.cs(1,"crossColor")
B.le=new A.cs(2,"subtractGreen")
B.cw=new A.cs(3,"colorIndexing")
B.c4=s([B.cv,B.ld,B.le,B.cw],A.U("t<cs>"))
B.x=s([0,17,34,51,68,85,102,119,136,153,170,187,204,221,238,255],t.t)
B.jM=s([73,67,67,95,80,82,79,70,73,76,69,0],t.t)
B.c7=s([A.t_(),A.rU(),A.t9(),A.t7(),A.t1(),A.t0(),A.t2()],t.A)
B.c8=s([0,4,8,12,128,132,136,140,256,260,264,268,384,388,392,396],t.t)
B.c9=s([null,A.tp(),A.tq(),A.to()],A.U("t<~(f,f,f,f,f,bC)?>"))
B.cx=new A.eM(0,"shrinkImage")
B.cy=new A.eM(1,"calcImageMetadata")
B.ca=s([B.cx,B.cy],A.U("t<eM>"))
B.av=s([0,36,72,109,145,182,218,255],t.t)
B.q=s([0,8,16,24,32,41,49,57,65,74,82,90,98,106,115,123,131,139,148,156,164,172,180,189,197,205,213,222,230,238,246,255],t.t)
B.jX=s([8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,9,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,7,8,8,8,8,8,8,8,8],t.t)
B.ks=new A.b2(0,"bitmap")
B.cn=new A.b2(1,"grayscale")
B.kt=new A.b2(2,"indexed")
B.co=new A.b2(3,"rgb")
B.cp=new A.b2(4,"cmyk")
B.ku=new A.b2(5,"multiChannel")
B.kv=new A.b2(6,"duoTone")
B.cq=new A.b2(7,"lab")
B.cb=s([B.ks,B.cn,B.kt,B.co,B.cp,B.ku,B.kv,B.cq],A.U("t<b2>"))
B.k3=s([0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0,0,0],t.t)
B.O=s([0,1,8,16,9,2,3,10,17,24,32,25,18,11,4,5,12,19,26,33,40,48,41,34,27,20,13,6,7,14,21,28,35,42,49,56,57,50,43,36,29,22,15,23,30,37,44,51,58,59,52,45,38,31,39,46,53,60,61,54,47,55,62,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63,63],t.t)
B.cc=s([0,0,1,5,1,1,1,1,1,1,0,0,0,0,0,0,0],t.t)
B.dG=s([2,6,2,6],t.t)
B.ek=s([6,2,6,2],t.t)
B.dF=s([2,2,6,6],t.t)
B.dy=s([1,3,3,9],t.t)
B.e_=s([4,0,12,0],t.t)
B.dO=s([3,1,9,3],t.t)
B.eD=s([8,8,0,0],t.t)
B.e0=s([4,12,0,0],t.t)
B.dv=s([16,0,0,0],t.t)
B.dr=s([12,4,0,0],t.t)
B.el=s([6,6,2,2],t.t)
B.dR=s([3,9,1,3],t.t)
B.dq=s([12,0,4,0],t.t)
B.eK=s([9,3,3,1],t.t)
B.h=s([B.bs,B.dG,B.aO,B.ek,B.dF,B.dy,B.e_,B.dO,B.eD,B.e0,B.dv,B.dr,B.el,B.dR,B.dq,B.eK],t.S)
B.Y=s([0,-128,64,-64,32,-96,96,-32,16,-112,80,-48,48,-80,112,-16,8,-120,72,-56,40,-88,104,-24,24,-104,88,-40,56,-72,120,-8,4,-124,68,-60,36,-92,100,-28,20,-108,84,-44,52,-76,116,-12,12,-116,76,-52,44,-84,108,-20,28,-100,92,-36,60,-68,124,-4,2,-126,66,-62,34,-94,98,-30,18,-110,82,-46,50,-78,114,-14,10,-118,74,-54,42,-86,106,-22,26,-102,90,-38,58,-70,122,-6,6,-122,70,-58,38,-90,102,-26,22,-106,86,-42,54,-74,118,-10,14,-114,78,-50,46,-82,110,-18,30,-98,94,-34,62,-66,126,-2,1,-127,65,-63,33,-95,97,-31,17,-111,81,-47,49,-79,113,-15,9,-119,73,-55,41,-87,105,-23,25,-103,89,-39,57,-71,121,-7,5,-123,69,-59,37,-91,101,-27,21,-107,85,-43,53,-75,117,-11,13,-115,77,-51,45,-83,109,-19,29,-99,93,-35,61,-67,125,-3,3,-125,67,-61,35,-93,99,-29,19,-109,83,-45,51,-77,115,-13,11,-117,75,-53,43,-85,107,-21,27,-101,91,-37,59,-69,123,-5,7,-121,71,-57,39,-89,103,-25,23,-105,87,-41,55,-73,119,-9,15,-113,79,-49,47,-81,111,-17,31,-97,95,-33,63,-65,127,-1],t.t)
B.kj={ProcessingSoftware:0,SubfileType:1,OldSubfileType:2,ImageWidth:3,ImageLength:4,ImageHeight:5,BitsPerSample:6,Compression:7,PhotometricInterpretation:8,Thresholding:9,CellWidth:10,CellLength:11,FillOrder:12,DocumentName:13,ImageDescription:14,Make:15,Model:16,StripOffsets:17,Orientation:18,SamplesPerPixel:19,RowsPerStrip:20,StripByteCounts:21,MinSampleValue:22,MaxSampleValue:23,XResolution:24,YResolution:25,PlanarConfiguration:26,PageName:27,XPosition:28,YPosition:29,GrayResponseUnit:30,GrayResponseCurve:31,T4Options:32,T6Options:33,ResolutionUnit:34,PageNumber:35,ColorResponseUnit:36,TransferFunction:37,Software:38,DateTime:39,Artist:40,HostComputer:41,Predictor:42,WhitePoint:43,PrimaryChromaticities:44,ColorMap:45,HalftoneHints:46,TileWidth:47,TileLength:48,TileOffsets:49,TileByteCounts:50,BadFaxLines:51,CleanFaxData:52,ConsecutiveBadFaxLines:53,InkSet:54,InkNames:55,NumberofInks:56,DotRange:57,TargetPrinter:58,ExtraSamples:59,SampleFormat:60,SMinSampleValue:61,SMaxSampleValue:62,TransferRange:63,ClipPath:64,JPEGProc:65,JPEGInterchangeFormat:66,JPEGInterchangeFormatLength:67,YCbCrCoefficients:68,YCbCrSubSampling:69,YCbCrPositioning:70,ReferenceBlackWhite:71,ApplicationNotes:72,Rating:73,CFARepeatPatternDim:74,CFAPattern:75,BatteryLevel:76,Copyright:77,ExposureTime:78,FNumber:79,"IPTC-NAA":80,ExifOffset:81,InterColorProfile:82,ExposureProgram:83,SpectralSensitivity:84,GPSOffset:85,ISOSpeed:86,OECF:87,SensitivityType:88,RecommendedExposureIndex:89,ExifVersion:90,DateTimeOriginal:91,DateTimeDigitized:92,OffsetTime:93,OffsetTimeOriginal:94,OffsetTimeDigitized:95,ComponentsConfiguration:96,CompressedBitsPerPixel:97,ShutterSpeedValue:98,ApertureValue:99,BrightnessValue:100,ExposureBiasValue:101,MaxApertureValue:102,SubjectDistance:103,MeteringMode:104,LightSource:105,Flash:106,FocalLength:107,SubjectArea:108,MakerNote:109,UserComment:110,SubSecTime:111,SubSecTimeOriginal:112,SubSecTimeDigitized:113,XPTitle:114,XPComment:115,XPAuthor:116,XPKeywords:117,XPSubject:118,FlashPixVersion:119,ColorSpace:120,ExifImageWidth:121,ExifImageLength:122,RelatedSoundFile:123,InteroperabilityOffset:124,FlashEnergy:125,SpatialFrequencyResponse:126,FocalPlaneXResolution:127,FocalPlaneYResolution:128,FocalPlaneResolutionUnit:129,SubjectLocation:130,ExposureIndex:131,SensingMethod:132,FileSource:133,SceneType:134,CVAPattern:135,CustomRendered:136,ExposureMode:137,WhiteBalance:138,DigitalZoomRatio:139,FocalLengthIn35mmFilm:140,SceneCaptureType:141,GainControl:142,Contrast:143,Saturation:144,Sharpness:145,DeviceSettingDescription:146,SubjectDistanceRange:147,ImageUniqueID:148,CameraOwnerName:149,BodySerialNumber:150,LensSpecification:151,LensMake:152,LensModel:153,LensSerialNumber:154,Gamma:155,PrintIM:156,Padding:157,OffsetSchema:158,OwnerName:159,SerialNumber:160,InteropIndex:161,InteropVersion:162,RelatedImageFileFormat:163,RelatedImageWidth:164,RelatedImageLength:165,GPSVersionID:166,GPSLatitudeRef:167,GPSLatitude:168,GPSLongitudeRef:169,GPSLongitude:170,GPSAltitudeRef:171,GPSAltitude:172,GPSTimeStamp:173,GPSSatellites:174,GPSStatus:175,GPSMeasureMode:176,GPSDOP:177,GPSSpeedRef:178,GPSSpeed:179,GPSTrackRef:180,GPSTrack:181,GPSImgDirectionRef:182,GPSImgDirection:183,GPSMapDatum:184,GPSDestLatitudeRef:185,GPSDestLatitude:186,GPSDestLongitudeRef:187,GPSDestLongitude:188,GPSDestBearingRef:189,GPSDestBearing:190,GPSDestDistanceRef:191,GPSDestDistance:192,GPSProcessingMethod:193,GPSAreaInformation:194,GPSDate:195,GPSDifferential:196}
B.kg=new A.cO(B.kj,[11,254,255,256,257,257,258,259,262,263,264,265,266,269,270,271,272,273,274,277,278,279,280,281,282,283,284,285,286,287,290,291,292,293,296,297,300,301,305,306,315,316,317,318,319,320,321,322,323,324,325,326,327,328,332,333,334,336,337,338,339,340,341,342,343,512,513,514,529,530,531,532,700,18246,33421,33422,33423,33432,33434,33437,33723,34665,34675,34850,34852,34853,34855,34856,34864,34866,36864,36867,36868,36880,36881,36882,37121,37122,37377,37378,37379,37380,37381,37382,37383,37384,37385,37386,37396,37500,37510,37520,37521,37522,40091,40092,40093,40094,40095,40960,40961,40962,40963,40964,40965,41483,41484,41486,41487,41488,41492,41493,41495,41728,41729,41730,41985,41986,41987,41988,41989,41990,41991,41992,41993,41994,41995,41996,42016,42032,42033,42034,42035,42036,42037,42240,50341,59932,59933,65e3,65001,1,2,4096,4097,4098,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30],t.E)
B.ki={"0":0,"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,A:10,B:11,C:12,D:13,E:14,F:15,G:16,H:17,I:18,J:19,K:20,L:21,M:22,N:23,O:24,P:25,Q:26,R:27,S:28,T:29,U:30,V:31,W:32,X:33,Y:34,Z:35,a:36,b:37,c:38,d:39,e:40,f:41,g:42,h:43,i:44,j:45,k:46,l:47,m:48,n:49,o:50,p:51,q:52,r:53,s:54,t:55,u:56,v:57,w:58,x:59,y:60,z:61,"#":62,$:63,"%":64,"*":65,"+":66,",":67,"-":68,".":69,":":70,";":71,"=":72,"?":73,"@":74,"[":75,"]":76,"^":77,_:78,"{":79,"|":80,"}":81,"~":82}
B.kh=new A.cO(B.ki,[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82],t.E)
B.cd=new A.c6([34665,"exif",40965,"interop",34853,"gps"],A.U("c6<f,X>"))
B.ce=new A.c6([B.y,1,B.t,3,B.z,15,B.e,255,B.m,65535,B.N,4294967295,B.R,127,B.S,32767,B.T,2147483647,B.E,1,B.M,1,B.Q,1],A.U("c6<as,f>"))
B.kq=new A.hj(0,"none")
B.kr=new A.hj(4,"paeth")
B.a6=new A.bT(0,"invalid")
B.ck=new A.bT(1,"pbm")
B.cl=new A.bT(2,"pgm2")
B.aW=new A.bT(3,"pgm5")
B.cm=new A.bT(4,"ppm3")
B.aX=new A.bT(5,"ppm6")
B.lk=new A.ew(0,"auto")
B.kw=new A.ew(3,"rgb4")
B.kx=new A.ew(4,"rgba4")
B.ll=new A.j9(1,"neural")
B.aZ=new A.aU(0,"bilevel")
B.kG=new A.aU(1,"gray4bit")
B.kH=new A.aU(2,"gray")
B.kI=new A.aU(3,"grayAlpha")
B.kJ=new A.aU(4,"palette")
B.ct=new A.aU(5,"rgb")
B.kK=new A.aU(6,"rgba")
B.kL=new A.aU(7,"yCbCrSub")
B.a7=new A.aU(8,"generic")
B.kM=new A.aU(9,"invalid")
B.l_=A.b9("fg")
B.l0=A.b9("ia")
B.l1=A.b9("il")
B.l2=A.b9("im")
B.l3=A.b9("fM")
B.l4=A.b9("fN")
B.l5=A.b9("iB")
B.l6=A.b9("H")
B.l7=A.b9("jj")
B.l8=A.b9("bB")
B.l9=A.b9("jk")
B.la=A.b9("bC")
B.lb=new A.hG(!1)
B.lc=new A.hG(!0)
B.a8=new A.dl(0,"undefined")
B.b3=new A.dl(1,"lossy")
B.az=new A.dl(2,"lossless")
B.lf=new A.dl(3,"animated")
B.aA=new A.dn(0,"none")
B.lg=new A.dn(1,"partial")
B.lh=new A.dn(2,"full")
B.a9=new A.dn(3,"finish")})();(function staticFields(){$.jX=null
$.aL=A.j([],A.U("t<H>"))
$.ms=null
$.lS=null
$.lR=null
$.ni=null
$.nb=null
$.nn=null
$.kj=null
$.ko=null
$.lx=null
$.dt=null
$.f6=null
$.f7=null
$.ls=!1
$.a0=B.B
$.bb=A.mH("_config")
$.lq=null
$.mE=!1
$.pF=A.j([A.lE(),A.tb(),A.tg(),A.th(),A.ti(),A.tj(),A.tk(),A.tl(),A.tm(),A.tn(),A.tc(),A.td(),A.te(),A.tf(),A.lE(),A.lE()],A.U("t<f(f,bB,f)>"))
$.R=null
$.m_=A.mH("_eLut")})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal,r=hunkHelpers.lazy
s($,"tr","lF",()=>A.ru("_$dart_dartClosure"))
s($,"u8","nJ",()=>A.j([new J.h_()],A.U("t<ex>")))
s($,"ty","nr",()=>A.bA(A.ji({
toString:function(){return"$receiver$"}})))
s($,"tz","ns",()=>A.bA(A.ji({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"tA","nt",()=>A.bA(A.ji(null)))
s($,"tB","nu",()=>A.bA(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"tE","nx",()=>A.bA(A.ji(void 0)))
s($,"tF","ny",()=>A.bA(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(q){return q.message}}()))
s($,"tD","nw",()=>A.bA(A.mA(null)))
s($,"tC","nv",()=>A.bA(function(){try{null.$method$}catch(q){return q.message}}()))
s($,"tH","nA",()=>A.bA(A.mA(void 0)))
s($,"tG","nz",()=>A.bA(function(){try{(void 0).$method$}catch(q){return q.message}}()))
s($,"tN","lH",()=>A.pN())
s($,"tT","nG",()=>A.ha(4096))
s($,"tR","nE",()=>new A.k6().$0())
s($,"tS","nF",()=>new A.k5().$0())
s($,"u7","kA",()=>A.i2(B.l6))
s($,"tQ","nD",()=>A.ln(B.ak,B.aM,257,286,15))
s($,"tP","nC",()=>A.ln(B.bJ,B.a2,0,30,15))
s($,"tO","nB",()=>A.ln(null,B.dH,0,19,7))
s($,"ua","kB",()=>{var q=null,p="ISOSpeed"
return A.kS([11,A.i("ProcessingSoftware",B.l,q),254,A.i("SubfileType",B.p,1),255,A.i("OldSubfileType",B.p,1),256,A.i("ImageWidth",B.p,1),257,A.i("ImageLength",B.p,1),258,A.i("BitsPerSample",B.k,1),259,A.i("Compression",B.k,1),262,A.i("PhotometricInterpretation",B.k,1),263,A.i("Thresholding",B.k,1),264,A.i("CellWidth",B.k,1),265,A.i("CellLength",B.k,1),266,A.i("FillOrder",B.k,1),269,A.i("DocumentName",B.l,q),270,A.i("ImageDescription",B.l,q),271,A.i("Make",B.l,q),272,A.i("Model",B.l,q),273,A.i("StripOffsets",B.p,q),274,A.i("Orientation",B.k,1),277,A.i("SamplesPerPixel",B.k,1),278,A.i("RowsPerStrip",B.p,1),279,A.i("StripByteCounts",B.p,1),280,A.i("MinSampleValue",B.k,1),281,A.i("MaxSampleValue",B.k,1),282,A.i("XResolution",B.r,1),283,A.i("YResolution",B.r,1),284,A.i("PlanarConfiguration",B.k,1),285,A.i("PageName",B.l,q),286,A.i("XPosition",B.r,1),287,A.i("YPosition",B.r,1),290,A.i("GrayResponseUnit",B.k,1),291,A.i("GrayResponseCurve",B.f,q),292,A.i("T4Options",B.f,q),293,A.i("T6Options",B.f,q),296,A.i("ResolutionUnit",B.k,1),297,A.i("PageNumber",B.k,2),300,A.i("ColorResponseUnit",B.f,q),301,A.i("TransferFunction",B.k,768),305,A.i("Software",B.l,q),306,A.i("DateTime",B.l,q),315,A.i("Artist",B.l,q),316,A.i("HostComputer",B.l,q),317,A.i("Predictor",B.k,1),318,A.i("WhitePoint",B.r,2),319,A.i("PrimaryChromaticities",B.r,6),320,A.i("ColorMap",B.k,q),321,A.i("HalftoneHints",B.k,2),322,A.i("TileWidth",B.p,1),323,A.i("TileLength",B.p,1),324,A.i("TileOffsets",B.p,q),325,A.i("TileByteCounts",B.f,q),326,A.i("BadFaxLines",B.f,q),327,A.i("CleanFaxData",B.f,q),328,A.i("ConsecutiveBadFaxLines",B.f,q),332,A.i("InkSet",B.f,q),333,A.i("InkNames",B.f,q),334,A.i("NumberofInks",B.f,q),336,A.i("DotRange",B.f,q),337,A.i("TargetPrinter",B.l,q),338,A.i("ExtraSamples",B.f,q),339,A.i("SampleFormat",B.k,1),340,A.i("SMinSampleValue",B.f,q),341,A.i("SMaxSampleValue",B.f,q),342,A.i("TransferRange",B.f,q),343,A.i("ClipPath",B.f,q),512,A.i("JPEGProc",B.f,q),513,A.i("JPEGInterchangeFormat",B.f,q),514,A.i("JPEGInterchangeFormatLength",B.f,q),529,A.i("YCbCrCoefficients",B.r,3),530,A.i("YCbCrSubSampling",B.k,1),531,A.i("YCbCrPositioning",B.k,1),532,A.i("ReferenceBlackWhite",B.r,6),700,A.i("ApplicationNotes",B.k,1),18246,A.i("Rating",B.k,1),33421,A.i("CFARepeatPatternDim",B.f,q),33422,A.i("CFAPattern",B.f,q),33423,A.i("BatteryLevel",B.f,q),33432,A.i("Copyright",B.l,q),33434,A.i("ExposureTime",B.r,1),33437,A.i("FNumber",B.r,q),33723,A.i("IPTC-NAA",B.p,1),34665,A.i("ExifOffset",B.f,q),34675,A.i("InterColorProfile",B.f,q),34850,A.i("ExposureProgram",B.k,1),34852,A.i("SpectralSensitivity",B.l,q),34853,A.i("GPSOffset",B.f,q),34855,A.i(p,B.p,1),34856,A.i("OECF",B.f,q),34864,A.i("SensitivityType",B.k,1),34866,A.i("RecommendedExposureIndex",B.p,1),34867,A.i(p,B.p,1),36864,A.i("ExifVersion",B.F,q),36867,A.i("DateTimeOriginal",B.l,q),36868,A.i("DateTimeDigitized",B.l,q),36880,A.i("OffsetTime",B.l,q),36881,A.i("OffsetTimeOriginal",B.l,q),36882,A.i("OffsetTimeDigitized",B.l,q),37121,A.i("ComponentsConfiguration",B.F,q),37122,A.i("CompressedBitsPerPixel",B.f,q),37377,A.i("ShutterSpeedValue",B.f,q),37378,A.i("ApertureValue",B.f,q),37379,A.i("BrightnessValue",B.f,q),37380,A.i("ExposureBiasValue",B.f,q),37381,A.i("MaxApertureValue",B.f,q),37382,A.i("SubjectDistance",B.f,q),37383,A.i("MeteringMode",B.f,q),37384,A.i("LightSource",B.f,q),37385,A.i("Flash",B.f,q),37386,A.i("FocalLength",B.f,q),37396,A.i("SubjectArea",B.f,q),37500,A.i("MakerNote",B.F,q),37510,A.i("UserComment",B.F,q),37520,A.i("SubSecTime",B.f,q),37521,A.i("SubSecTimeOriginal",B.f,q),37522,A.i("SubSecTimeDigitized",B.f,q),40091,A.i("XPTitle",B.f,q),40092,A.i("XPComment",B.f,q),40093,A.i("XPAuthor",B.f,q),40094,A.i("XPKeywords",B.f,q),40095,A.i("XPSubject",B.f,q),40960,A.i("FlashPixVersion",B.f,q),40961,A.i("ColorSpace",B.k,1),40962,A.i("ExifImageWidth",B.k,1),40963,A.i("ExifImageLength",B.k,1),40964,A.i("RelatedSoundFile",B.f,q),40965,A.i("InteroperabilityOffset",B.f,q),41483,A.i("FlashEnergy",B.f,q),41484,A.i("SpatialFrequencyResponse",B.f,q),41486,A.i("FocalPlaneXResolution",B.f,q),41487,A.i("FocalPlaneYResolution",B.f,q),41488,A.i("FocalPlaneResolutionUnit",B.f,q),41492,A.i("SubjectLocation",B.f,q),41493,A.i("ExposureIndex",B.f,q),41495,A.i("SensingMethod",B.f,q),41728,A.i("FileSource",B.f,q),41729,A.i("SceneType",B.f,q),41730,A.i("CVAPattern",B.f,q),41985,A.i("CustomRendered",B.f,q),41986,A.i("ExposureMode",B.f,q),41987,A.i("WhiteBalance",B.f,q),41988,A.i("DigitalZoomRatio",B.f,q),41989,A.i("FocalLengthIn35mmFilm",B.f,q),41990,A.i("SceneCaptureType",B.f,q),41991,A.i("GainControl",B.f,q),41992,A.i("Contrast",B.f,q),41993,A.i("Saturation",B.f,q),41994,A.i("Sharpness",B.f,q),41995,A.i("DeviceSettingDescription",B.f,q),41996,A.i("SubjectDistanceRange",B.f,q),42016,A.i("ImageUniqueID",B.f,q),42032,A.i("CameraOwnerName",B.l,q),42033,A.i("BodySerialNumber",B.l,q),42034,A.i("LensSpecification",B.f,q),42035,A.i("LensMake",B.l,q),42036,A.i("LensModel",B.l,q),42037,A.i("LensSerialNumber",B.l,q),42240,A.i("Gamma",B.r,1),50341,A.i("PrintIM",B.f,q),59932,A.i("Padding",B.f,q),59933,A.i("OffsetSchema",B.f,q),65e3,A.i("OwnerName",B.l,q),65001,A.i("SerialNumber",B.l,q)],t.p,A.U("ft"))})
r($,"tI","i3",()=>A.ha(511))
r($,"tJ","kw",()=>A.ha(511))
r($,"tL","kx",()=>A.mn(2041))
r($,"tM","ky",()=>A.mn(225))
r($,"tK","aD",()=>A.ha(766))
s($,"tv","nq",()=>A.md(0,0,0))
s($,"u4","ap",()=>A.ha(1))
s($,"u5","ay",()=>A.om(B.d.gB($.ap()),0,null))
s($,"tY","ao",()=>A.oB(1))
s($,"tZ","ax",()=>J.nK(B.P.gB($.ao()),0,null))
s($,"u_","N",()=>A.oD(1))
s($,"u1","a6",()=>J.nL(B.o.gB($.N()),0,null))
s($,"u0","c1",()=>A.od(B.o.gB($.N())))
s($,"tW","i4",()=>A.oy(1))
s($,"tX","kz",()=>A.mB(B.Z.gB($.i4()),0))
s($,"tU","lI",()=>A.ov(1))
s($,"tV","nH",()=>A.mB(B.a4.gB($.lI()),0))
s($,"u2","lJ",()=>A.p0(1))
s($,"u3","nI",()=>{var q=$.lJ()
return A.oe(q.gB(q))})
s($,"ts","kv",()=>new A.iR(A.j([],A.U("t<e3>"))))
r($,"tt","lG",()=>new A.iS())})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({ArrayBuffer:A.cc,SharedArrayBuffer:A.cc,ArrayBufferView:A.ea,DataView:A.h9,Float32Array:A.e5,Float64Array:A.e6,Int16Array:A.e7,Int32Array:A.e8,Int8Array:A.e9,Uint16Array:A.eb,Uint32Array:A.ec,Uint8ClampedArray:A.ed,CanvasPixelArray:A.ed,Uint8Array:A.cd})
hunkHelpers.setOrUpdateLeafTags({ArrayBuffer:true,SharedArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.ai.$nativeSuperclassTag="ArrayBufferView"
A.eW.$nativeSuperclassTag="ArrayBufferView"
A.eX.$nativeSuperclassTag="ArrayBufferView"
A.bR.$nativeSuperclassTag="ArrayBufferView"
A.eY.$nativeSuperclassTag="ArrayBufferView"
A.eZ.$nativeSuperclassTag="ArrayBufferView"
A.aG.$nativeSuperclassTag="ArrayBufferView"})()
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
var s=A.rF
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=native_executor.js.map
