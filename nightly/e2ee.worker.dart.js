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
if(a[b]!==s){A.jz(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.M(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.eR(b)
return new s(c,this)}:function(){if(s===null)s=A.eR(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.eR(a).prototype
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
eV(a,b,c,d){return{i:a,p:b,e:c,x:d}},
e6(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.eS==null){A.jo()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.d(A.fp("Return interceptor for "+A.c(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.dJ
if(o==null)o=$.dJ=A.e5(n)
p=q[o]}if(p!=null)return p
p=A.ju(a)
if(p!=null)return p
if(typeof a=="function")return B.O
s=Object.getPrototypeOf(a)
if(s==null)return B.C
if(s===Object.prototype)return B.C
if(typeof q=="function"){o=$.dJ
if(o==null)o=$.dJ=A.e5(n)
Object.defineProperty(q,o,{value:B.t,enumerable:false,writable:true,configurable:true})
return B.t}return B.t},
hB(a,b){if(a<0||a>4294967295)throw A.d(A.aa(a,0,4294967295,"length",null))
return J.hC(new Array(a),b)},
hC(a,b){var s=A.M(a,b.h("z<0>"))
s.$flags=1
return s},
aM(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.bk.prototype
return J.cg.prototype}if(typeof a=="string")return J.aT.prototype
if(a==null)return J.bl.prototype
if(typeof a=="boolean")return J.cf.prototype
if(Array.isArray(a))return J.z.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a6.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e6(a)},
e2(a){if(typeof a=="string")return J.aT.prototype
if(a==null)return a
if(Array.isArray(a))return J.z.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a6.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e6(a)},
e3(a){if(a==null)return a
if(Array.isArray(a))return J.z.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a6.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e6(a)},
e4(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.a6.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e6(a)},
ev(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.aM(a).F(a,b)},
eY(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.js(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.e2(a).j(a,b)},
eZ(a,b,c){return J.e4(a).bw(a,b,c)},
bd(a,b){return J.e3(a).u(a,b)},
ew(a){return J.e4(a).aW(a)},
f_(a,b,c){return J.e4(a).a5(a,b,c)},
hn(a,b){return J.e3(a).T(a,b)},
ex(a){return J.e4(a).gH(a)},
cT(a){return J.aM(a).gt(a)},
ey(a){return J.e3(a).gA(a)},
aQ(a){return J.e2(a).gm(a)},
ez(a){return J.aM(a).gq(a)},
ho(a,b,c){return J.e3(a).V(a,b,c)},
T(a){return J.aM(a).k(a)},
cd:function cd(){},
cf:function cf(){},
bl:function bl(){},
bm:function bm(){},
am:function am(){},
cu:function cu(){},
bD:function bD(){},
a6:function a6(){},
aU:function aU(){},
aV:function aV(){},
z:function z(a){this.$ti=a},
ce:function ce(){},
d8:function d8(a){this.$ti=a},
be:function be(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
ch:function ch(){},
bk:function bk(){},
cg:function cg(){},
aT:function aT(){}},A={eE:function eE(){},
hD(a){return new A.bn("Field '"+a+"' has not been initialized.")},
fn(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
hW(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
dZ(a,b,c){return a},
eT(a){var s,r
for(s=$.S.length,r=0;r<s;++r)if(a===$.S[r])return!0
return!1},
hF(a,b,c,d){if(t.d.b(a))return new A.bh(a,b,c.h("@<0>").l(d).h("bh<1,2>"))
return new A.a8(a,b,c.h("@<0>").l(d).h("a8<1,2>"))},
b2:function b2(a){this.a=0
this.b=a},
bn:function bn(a){this.a=a},
dg:function dg(){},
l:function l(){},
a7:function a7(){},
aB:function aB(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
a8:function a8(a,b,c){this.a=a
this.b=b
this.$ti=c},
bh:function bh(a,b,c){this.a=a
this.b=b
this.$ti=c},
bs:function bs(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
a9:function a9(a,b,c){this.a=a
this.b=b
this.$ti=c},
aF:function aF(a,b,c){this.a=a
this.b=b
this.$ti=c},
bG:function bG(a,b,c){this.a=a
this.b=b
this.$ti=c},
L:function L(){},
h7(a){var s=A.h6(a)
if(s!=null)return s
return"minified:"+a},
js(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.w.b(a)},
c(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.T(a)
return s},
bA(a){var s,r=$.ff
if(r==null)r=$.ff=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
cv(a){var s,r,q,p
if(a instanceof A.k)return A.R(A.bb(a),null)
s=J.aM(a)
if(s===B.N||s===B.P||t.cr.b(a)){r=B.v(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.R(A.bb(a),null)},
hQ(a){var s,r,q
if(typeof a=="number"||A.dW(a))return J.T(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.ak)return a.k(0)
s=$.hm()
for(r=0;r<1;++r){q=s[r].bZ(a)
if(q!=null)return q}return"Instance of '"+A.cv(a)+"'"},
hR(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
Q(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
hP(a){return a.c?A.Q(a).getUTCFullYear()+0:A.Q(a).getFullYear()+0},
hN(a){return a.c?A.Q(a).getUTCMonth()+1:A.Q(a).getMonth()+1},
hJ(a){return a.c?A.Q(a).getUTCDate()+0:A.Q(a).getDate()+0},
hK(a){return a.c?A.Q(a).getUTCHours()+0:A.Q(a).getHours()+0},
hM(a){return a.c?A.Q(a).getUTCMinutes()+0:A.Q(a).getMinutes()+0},
hO(a){return a.c?A.Q(a).getUTCSeconds()+0:A.Q(a).getSeconds()+0},
hL(a){return a.c?A.Q(a).getUTCMilliseconds()+0:A.Q(a).getMilliseconds()+0},
hI(a){var s=a.$thrownJsError
if(s==null)return null
return A.au(s)},
fg(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.B(a,s)
a.$thrownJsError=s
s.stack=b.k(0)}},
jm(a){throw A.d(A.j8(a))},
e(a,b){if(a==null)J.aQ(a)
throw A.d(A.cQ(a,b))},
cQ(a,b){var s,r="index"
if(!A.fM(b))return new A.a_(!0,b,r,null)
s=A.n(J.aQ(a))
if(b<0||b>=s)return A.f6(b,s,a,r)
return A.hS(b,r)},
jg(a,b,c){if(a<0||a>c)return A.aa(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.aa(b,a,c,"end",null)
return new A.a_(!0,b,"end",null)},
j8(a){return new A.a_(!0,a,null,null)},
d(a){return A.B(a,new Error())},
B(a,b){var s
if(a==null)a=new A.ab()
b.dartException=a
s=A.jA
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
jA(){return J.T(this.dartException)},
X(a,b){throw A.B(a,b==null?new Error():b)},
Y(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.X(A.iy(a,b,c),s)},
iy(a,b,c){var s,r,q,p,o,n,m,l,k
if(typeof b=="string")s=b
else{r="[]=;add;removeWhere;retainWhere;removeRange;setRange;setInt8;setInt16;setInt32;setUint8;setUint16;setUint32;setFloat32;setFloat64".split(";")
q=r.length
p=b
if(p>q){c=p/q|0
p%=q}s=r[p]}o=typeof c=="string"?c:"modify;remove from;add to".split(";")[c]
n=t.cK.b(a)?"list":"ByteData"
m=a.$flags|0
l="a "
if((m&4)!==0)k="constant "
else if((m&2)!==0){k="unmodifiable "
l="an "}else k=(m&1)!==0?"fixed-length ":""
return new A.bE("'"+s+"': Cannot "+o+" "+l+k+n)},
c2(a){throw A.d(A.bg(a))},
ac(a){var s,r,q,p,o,n
a=A.jy(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.M([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.dk(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
dl(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
fo(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
eF(a,b){var s=b==null,r=s?null:b.method
return new A.ci(a,r,s?null:b.receiver)},
N(a){var s
if(a==null)return new A.df(a)
if(a instanceof A.bj){s=a.a
return A.av(a,s==null?A.J(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.av(a,a.dartException)
return A.j7(a)},
av(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
j7(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.h.a4(r,16)&8191)===10)switch(q){case 438:return A.av(a,A.eF(A.c(s)+" (Error "+q+")",null))
case 445:case 5007:A.c(s)
return A.av(a,new A.bz())}}if(a instanceof TypeError){p=$.h9()
o=$.ha()
n=$.hb()
m=$.hc()
l=$.hf()
k=$.hg()
j=$.he()
$.hd()
i=$.hi()
h=$.hh()
g=p.C(s)
if(g!=null)return A.av(a,A.eF(A.i(s),g))
else{g=o.C(s)
if(g!=null){g.method="call"
return A.av(a,A.eF(A.i(s),g))}else if(n.C(s)!=null||m.C(s)!=null||l.C(s)!=null||k.C(s)!=null||j.C(s)!=null||m.C(s)!=null||i.C(s)!=null||h.C(s)!=null){A.i(s)
return A.av(a,new A.bz())}}return A.av(a,new A.cD(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.bC()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.av(a,new A.a_(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.bC()
return a},
au(a){var s
if(a instanceof A.bj)return a.b
if(a==null)return new A.bT(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.bT(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
eo(a){if(a==null)return J.cT(a)
if(typeof a=="object")return A.bA(a)
return J.cT(a)},
jh(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.v(0,a[s],a[r])}return b},
iI(a,b,c,d,e,f){t.Z.a(a)
switch(A.n(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.d(A.U("Unsupported number of arguments for wrapped closure"))},
c1(a,b){var s=a.$identity
if(!!s)return s
s=A.je(a,b)
a.$identity=s
return s},
je(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.iI)},
hw(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.cy().constructor.prototype):Object.create(new A.aR(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.f4(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.hs(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.f4(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
hs(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.d("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.hp)}throw A.d("Error in functionType of tearoff")},
ht(a,b,c,d){var s=A.f3
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
f4(a,b,c,d){if(c)return A.hv(a,b,d)
return A.ht(b.length,d,a,b)},
hu(a,b,c,d){var s=A.f3,r=A.hq
switch(b?-1:a){case 0:throw A.d(new A.cw("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
hv(a,b,c){var s,r
if($.f1==null)$.f1=A.f0("interceptor")
if($.f2==null)$.f2=A.f0("receiver")
s=b.length
r=A.hu(s,c,a,b)
return r},
eR(a){return A.hw(a)},
hp(a,b){return A.dR(v.typeUniverse,A.bb(a.a),b)},
f3(a){return a.a},
hq(a){return a.b},
f0(a){var s,r,q,p=new A.aR("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.d(A.aj("Field name "+a+" not found.",null))},
e5(a){return v.getIsolateTag(a)},
k_(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
ju(a){var s,r,q,p,o,n=A.i($.h1.$1(a)),m=$.e0[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.eb[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.dT($.fW.$2(a,n))
if(q!=null){m=$.e0[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.eb[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.en(s)
$.e0[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.eb[n]=s
return s}if(p==="-"){o=A.en(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.h3(a,s)
if(p==="*")throw A.d(A.fp(n))
if(v.leafTags[n]===true){o=A.en(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.h3(a,s)},
h3(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.eV(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
en(a){return J.eV(a,!1,null,!!a.$iP)},
jv(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.en(s)
else return J.eV(s,c,null,null)},
jo(){if(!0===$.eS)return
$.eS=!0
A.jp()},
jp(){var s,r,q,p,o,n,m,l
$.e0=Object.create(null)
$.eb=Object.create(null)
A.jn()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.h4.$1(o)
if(n!=null){m=A.jv(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
jn(){var s,r,q,p,o,n,m=B.F()
m=A.b9(B.G,A.b9(B.H,A.b9(B.w,A.b9(B.w,A.b9(B.I,A.b9(B.J,A.b9(B.K(B.v),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.h1=new A.e8(p)
$.fW=new A.e9(o)
$.h4=new A.ea(n)},
b9(a,b){return a(b)||b},
jf(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
jy(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
bB:function bB(){},
dk:function dk(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
bz:function bz(){},
ci:function ci(a,b,c){this.a=a
this.b=b
this.c=c},
cD:function cD(a){this.a=a},
df:function df(a){this.a=a},
bj:function bj(a,b){this.a=a
this.b=b},
bT:function bT(a){this.a=a
this.b=null},
ak:function ak(){},
c6:function c6(){},
c7:function c7(){},
cA:function cA(){},
cy:function cy(){},
aR:function aR(a,b){this.a=a
this.b=b},
cw:function cw(a){this.a=a},
aA:function aA(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
da:function da(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
bp:function bp(a,b){this.a=a
this.$ti=b},
bo:function bo(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
e8:function e8(a){this.a=a},
e9:function e9(a){this.a=a},
ea:function ea(a){this.a=a},
as(a){return a},
hG(a){return new DataView(new ArrayBuffer(a))},
fc(a){return new Uint8Array(a)},
I(a,b,c){return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
aK(a,b,c){if(a>>>0!==a||a>=c)throw A.d(A.cQ(b,a))},
ix(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.d(A.jg(a,b,c))
if(b==null)return c
return b},
ao:function ao(){},
aY:function aY(){},
bw:function bw(){},
cN:function cN(a){this.a=a},
bt:function bt(){},
H:function H(){},
bu:function bu(){},
bv:function bv(){},
cl:function cl(){},
cm:function cm(){},
cn:function cn(){},
co:function co(){},
cp:function cp(){},
cq:function cq(){},
cr:function cr(){},
bx:function bx(){},
by:function by(){},
bP:function bP(){},
bQ:function bQ(){},
bR:function bR(){},
bS:function bS(){},
eG(a,b){var s=b.c
return s==null?b.c=A.bX(a,"a1",[b.x]):s},
fj(a){var s=a.w
if(s===6||s===7)return A.fj(a.x)
return s===11||s===12},
hT(a){return a.as},
ba(a){return A.dQ(v.typeUniverse,a,!1)},
aL(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.aL(a1,s,a3,a4)
if(r===s)return a2
return A.fA(a1,r,!0)
case 7:s=a2.x
r=A.aL(a1,s,a3,a4)
if(r===s)return a2
return A.fz(a1,r,!0)
case 8:q=a2.y
p=A.b8(a1,q,a3,a4)
if(p===q)return a2
return A.bX(a1,a2.x,p)
case 9:o=a2.x
n=A.aL(a1,o,a3,a4)
m=a2.y
l=A.b8(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.eK(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.b8(a1,j,a3,a4)
if(i===j)return a2
return A.fB(a1,k,i)
case 11:h=a2.x
g=A.aL(a1,h,a3,a4)
f=a2.y
e=A.j4(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.fy(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.b8(a1,d,a3,a4)
o=a2.x
n=A.aL(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.eL(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.d(A.c4("Attempted to substitute unexpected RTI kind "+a0))}},
b8(a,b,c,d){var s,r,q,p,o=b.length,n=A.dS(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.aL(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
j5(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.dS(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.aL(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
j4(a,b,c,d){var s,r=b.a,q=A.b8(a,r,c,d),p=b.b,o=A.b8(a,p,c,d),n=b.c,m=A.j5(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.cI()
s.a=q
s.b=o
s.c=m
return s},
M(a,b){a[v.arrayRti]=b
return a},
fY(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.jl(s)
return a.$S()}return null},
jq(a,b){var s
if(A.fj(b))if(a instanceof A.ak){s=A.fY(a)
if(s!=null)return s}return A.bb(a)},
bb(a){if(a instanceof A.k)return A.K(a)
if(Array.isArray(a))return A.ae(a)
return A.eO(J.aM(a))},
ae(a){var s=a[v.arrayRti],r=t.r
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
K(a){var s=a.$ti
return s!=null?s:A.eO(a)},
eO(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.iF(a,s)},
iF(a,b){var s=a instanceof A.ak?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.io(v.typeUniverse,s.name)
b.$ccache=r
return r},
jl(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.dQ(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
jk(a){return A.at(A.K(a))},
j3(a){var s=a instanceof A.ak?A.fY(a):null
if(s!=null)return s
if(t.a4.b(a))return J.ez(a).a
if(Array.isArray(a))return A.ae(a)
return A.bb(a)},
at(a){var s=a.r
return s==null?a.r=new A.dP(a):s},
Z(a){return A.at(A.dQ(v.typeUniverse,a,!1))},
iE(a){var s=this
s.b=A.j1(s)
return s.b(a)},
j1(a){var s,r,q,p,o
if(a===t.K)return A.iO
if(A.aN(a))return A.iS
s=a.w
if(s===6)return A.iC
if(s===1)return A.fO
if(s===7)return A.iJ
r=A.j0(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.aN)){a.f="$i"+q
if(q==="r")return A.iM
if(a===t.m)return A.iL
return A.iR}}else if(s===10){p=A.jf(a.x,a.y)
o=p==null?A.fO:p
return o==null?A.J(o):o}return A.iA},
j0(a){if(a.w===8){if(a===t.S)return A.fM
if(a===t.i||a===t.o)return A.iN
if(a===t.N)return A.iQ
if(a===t.y)return A.dW}return null},
iD(a){var s=this,r=A.iz
if(A.aN(s))r=A.it
else if(s===t.K)r=A.J
else if(A.bc(s)){r=A.iB
if(s===t.a3)r=A.eN
else if(s===t.T)r=A.dT
else if(s===t.cG)r=A.iq
else if(s===t.ae)r=A.fG
else if(s===t.dd)r=A.ir
else if(s===t.b1)r=A.fF}else if(s===t.S)r=A.n
else if(s===t.N)r=A.i
else if(s===t.y)r=A.cO
else if(s===t.o)r=A.is
else if(s===t.i)r=A.eM
else if(s===t.m)r=A.b
s.a=r
return s.a(a)},
iA(a){var s=this
if(a==null)return A.bc(s)
return A.jt(v.typeUniverse,A.jq(a,s),s)},
iC(a){if(a==null)return!0
return this.x.b(a)},
iR(a){var s,r=this
if(a==null)return A.bc(r)
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.aM(a)[s]},
iM(a){var s,r=this
if(a==null)return A.bc(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.aM(a)[s]},
iL(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.k)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
fN(a){if(typeof a=="object"){if(a instanceof A.k)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
iz(a){var s=this
if(a==null){if(A.bc(s))return a}else if(s.b(a))return a
throw A.B(A.fH(a,s),new Error())},
iB(a){var s=this
if(a==null||s.b(a))return a
throw A.B(A.fH(a,s),new Error())},
fH(a,b){return new A.bV("TypeError: "+A.fs(a,A.R(b,null)))},
fs(a,b){return A.cY(a)+": type '"+A.R(A.j3(a),null)+"' is not a subtype of type '"+b+"'"},
V(a,b){return new A.bV("TypeError: "+A.fs(a,b))},
iJ(a){var s=this
return s.x.b(a)||A.eG(v.typeUniverse,s).b(a)},
iO(a){return a!=null},
J(a){if(a!=null)return a
throw A.B(A.V(a,"Object"),new Error())},
iS(a){return!0},
it(a){return a},
fO(a){return!1},
dW(a){return!0===a||!1===a},
cO(a){if(!0===a)return!0
if(!1===a)return!1
throw A.B(A.V(a,"bool"),new Error())},
iq(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.B(A.V(a,"bool?"),new Error())},
eM(a){if(typeof a=="number")return a
throw A.B(A.V(a,"double"),new Error())},
ir(a){if(typeof a=="number")return a
if(a==null)return a
throw A.B(A.V(a,"double?"),new Error())},
fM(a){return typeof a=="number"&&Math.floor(a)===a},
n(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.B(A.V(a,"int"),new Error())},
eN(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.B(A.V(a,"int?"),new Error())},
iN(a){return typeof a=="number"},
is(a){if(typeof a=="number")return a
throw A.B(A.V(a,"num"),new Error())},
fG(a){if(typeof a=="number")return a
if(a==null)return a
throw A.B(A.V(a,"num?"),new Error())},
iQ(a){return typeof a=="string"},
i(a){if(typeof a=="string")return a
throw A.B(A.V(a,"String"),new Error())},
dT(a){if(typeof a=="string")return a
if(a==null)return a
throw A.B(A.V(a,"String?"),new Error())},
b(a){if(A.fN(a))return a
throw A.B(A.V(a,"JSObject"),new Error())},
fF(a){if(a==null)return a
if(A.fN(a))return a
throw A.B(A.V(a,"JSObject?"),new Error())},
fT(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.R(a[q],b)
return s},
iX(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.fT(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.R(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
fI(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.M([],t.s)
else a2=a4.length
r=a4.length
for(q=s;q>0;--q)B.d.u(a4,"T"+(r+q))
for(p=t.X,o="<",n="",q=0;q<s;++q,n=a1){m=a4.length
l=m-1-q
if(!(l>=0))return A.e(a4,l)
o=o+n+a4[l]
k=a5[q]
j=k.w
if(!(j===2||j===3||j===4||j===5||k===p))o+=" extends "+A.R(k,a4)}o+=">"}else o=""
p=a3.x
i=a3.y
h=i.a
g=h.length
f=i.b
e=f.length
d=i.c
c=d.length
b=A.R(p,a4)
for(a="",a0="",q=0;q<g;++q,a0=a1)a+=a0+A.R(h[q],a4)
if(e>0){a+=a0+"["
for(a0="",q=0;q<e;++q,a0=a1)a+=a0+A.R(f[q],a4)
a+="]"}if(c>0){a+=a0+"{"
for(a0="",q=0;q<c;q+=3,a0=a1){a+=a0
if(d[q+1])a+="required "
a+=A.R(d[q+2],a4)+" "+d[q]}a+="}"}if(a2!=null){a4.toString
a4.length=a2}return o+"("+a+") => "+b},
R(a,b){var s,r,q,p,o,n,m,l=a.w
if(l===5)return"erased"
if(l===2)return"dynamic"
if(l===3)return"void"
if(l===1)return"Never"
if(l===4)return"any"
if(l===6){s=a.x
r=A.R(s,b)
q=s.w
return(q===11||q===12?"("+r+")":r)+"?"}if(l===7)return"FutureOr<"+A.R(a.x,b)+">"
if(l===8){p=A.j6(a.x)
o=a.y
return o.length>0?p+("<"+A.fT(o,b)+">"):p}if(l===10)return A.iX(a,b)
if(l===11)return A.fI(a,b,null)
if(l===12)return A.fI(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.e(b,n)
return b[n]}return"?"},
j6(a){var s=A.h6(a)
if(s!=null)return s
return"minified:"+a},
ip(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
io(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.dQ(a,b,!1)
else if(typeof m=="number"){s=m
r=A.bY(a,5,"#")
q=A.dS(s)
for(p=0;p<s;++p)q[p]=r
o=A.bX(a,b,q)
n[b]=o
return o}else return m},
il(a,b){return A.fD(a.tR,b)},
ik(a,b){return A.fD(a.eT,b)},
dQ(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.fC(a,null,b,!1)
r.set(b,s)
return s},
dR(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.fC(a,b,c,!0)
q.set(c,r)
return r},
im(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.eK(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
fC(a,b,c,d){return A.ib(A.i5(a,b,c,d))},
ar(a,b){b.a=A.iD
b.b=A.iE
return b},
bY(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.a2(null,null)
s.w=b
s.as=c
r=A.ar(a,s)
a.eC.set(c,r)
return r},
fA(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.ii(a,b,r,c)
a.eC.set(r,s)
return s},
ii(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.aN(b))if(!(b===t.P||b===t.u))if(s!==6)r=s===7&&A.bc(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.a2(null,null)
q.w=6
q.x=b
q.as=c
return A.ar(a,q)},
fz(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.ig(a,b,r,c)
a.eC.set(r,s)
return s},
ig(a,b,c,d){var s,r
if(d){s=b.w
if(A.aN(b)||b===t.K)return b
else if(s===1)return A.bX(a,"a1",[b])
else if(b===t.P||b===t.u)return t.bc}r=new A.a2(null,null)
r.w=7
r.x=b
r.as=c
return A.ar(a,r)},
ij(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.a2(null,null)
s.w=13
s.x=b
s.as=q
r=A.ar(a,s)
a.eC.set(q,r)
return r},
bW(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
ie(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
bX(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.bW(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.a2(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.ar(a,r)
a.eC.set(p,q)
return q},
eK(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.bW(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.a2(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.ar(a,o)
a.eC.set(q,n)
return n},
fB(a,b,c){var s,r,q="+"+(b+"("+A.bW(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.a2(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.ar(a,s)
a.eC.set(q,r)
return r},
fy(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.bW(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.bW(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.ie(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.a2(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.ar(a,p)
a.eC.set(r,o)
return o},
eL(a,b,c,d){var s,r=b.as+("<"+A.bW(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.ih(a,b,c,r,d)
a.eC.set(r,s)
return s},
ih(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.dS(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.aL(a,b,r,0)
m=A.b8(a,c,r,0)
return A.eL(a,n,m,c!==m)}}l=new A.a2(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.ar(a,l)},
i5(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
ib(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.i7(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.fv(a,r,l,k,!1)
else if(q===46)r=A.fv(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.aJ(a.u,a.e,k.pop()))
break
case 94:k.push(A.ij(a.u,k.pop()))
break
case 35:k.push(A.bY(a.u,5,"#"))
break
case 64:k.push(A.bY(a.u,2,"@"))
break
case 126:k.push(A.bY(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.i9(a,k)
break
case 38:A.i8(a,k)
break
case 63:p=a.u
k.push(A.fA(p,A.aJ(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.fz(p,A.aJ(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.i6(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.fw(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.ic(a.u,a.e,o)
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
return A.aJ(a.u,a.e,m)},
i7(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
fv(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.ip(s,o.x)[p]
if(n==null)A.X('No "'+p+'" in "'+A.hT(o)+'"')
d.push(A.dR(s,o,n))}else d.push(p)
return m},
i9(a,b){var s,r=a.u,q=A.fu(a,b),p=b.pop()
if(typeof p=="string")b.push(A.bX(r,p,q))
else{s=A.aJ(r,a.e,p)
switch(s.w){case 11:b.push(A.eL(r,s,q,a.n))
break
default:b.push(A.eK(r,s,q))
break}}},
i6(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.fu(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.aJ(p,a.e,o)
q=new A.cI()
q.a=s
q.b=n
q.c=m
b.push(A.fy(p,r,q))
return
case-4:b.push(A.fB(p,b.pop(),s))
return
default:throw A.d(A.c4("Unexpected state under `()`: "+A.c(o)))}},
i8(a,b){var s=b.pop()
if(0===s){b.push(A.bY(a.u,1,"0&"))
return}if(1===s){b.push(A.bY(a.u,4,"1&"))
return}throw A.d(A.c4("Unexpected extended operation "+A.c(s)))},
fu(a,b){var s=b.splice(a.p)
A.fw(a.u,a.e,s)
a.p=b.pop()
return s},
aJ(a,b,c){if(typeof c=="string")return A.bX(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.ia(a,b,c)}else return c},
fw(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.aJ(a,b,c[s])},
ic(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.aJ(a,b,c[s])},
ia(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.d(A.c4("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.d(A.c4("Bad index "+c+" for "+b.k(0)))},
jt(a,b,c){var s,r=b.d
if(r==null)r=b.d=new Map()
s=r.get(c)
if(s==null){s=A.A(a,b,null,c,null)
r.set(c,s)}return s},
A(a,b,c,d,e){var s,r,q,p,o,n,m,l,k,j,i
if(b===d)return!0
if(A.aN(d))return!0
s=b.w
if(s===4)return!0
if(A.aN(b))return!1
if(b.w===1)return!0
r=s===13
if(r)if(A.A(a,c[b.x],c,d,e))return!0
q=d.w
p=t.P
if(b===p||b===t.u){if(q===7)return A.A(a,b,c,d.x,e)
return d===p||d===t.u||q===6}if(d===t.K){if(s===7)return A.A(a,b.x,c,d,e)
return s!==6}if(s===7){if(!A.A(a,b.x,c,d,e))return!1
return A.A(a,A.eG(a,b),c,d,e)}if(s===6)return A.A(a,p,c,d,e)&&A.A(a,b.x,c,d,e)
if(q===7){if(A.A(a,b,c,d.x,e))return!0
return A.A(a,b,c,A.eG(a,d),e)}if(q===6)return A.A(a,b,c,p,e)||A.A(a,b,c,d.x,e)
if(r)return!1
p=s!==11
if((!p||s===12)&&d===t.Z)return!0
o=s===10
if(o&&d===t.cY)return!0
if(q===12){if(b===t.g)return!0
if(s!==12)return!1
n=b.y
m=d.y
l=n.length
if(l!==m.length)return!1
c=c==null?n:n.concat(c)
e=e==null?m:m.concat(e)
for(k=0;k<l;++k){j=n[k]
i=m[k]
if(!A.A(a,j,c,i,e)||!A.A(a,i,e,j,c))return!1}return A.fL(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.fL(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.iK(a,b,c,d,e)}if(o&&q===10)return A.iP(a,b,c,d,e)
return!1},
fL(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
if(!A.A(a3,a4.x,a5,a6.x,a7))return!1
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
if(!A.A(a3,p[h],a7,g,a5))return!1}for(h=0;h<m;++h){g=l[h]
if(!A.A(a3,p[o+h],a7,g,a5))return!1}for(h=0;h<i;++h){g=l[m+h]
if(!A.A(a3,k[h],a7,g,a5))return!1}f=s.c
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
if(!A.A(a3,e[a+2],a7,g,a5))return!1
break}}while(b<d){if(f[b+1])return!1
b+=3}return!0},
iK(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.dR(a,b,r[o])
return A.fE(a,p,null,c,d.y,e)}return A.fE(a,b.y,null,c,d.y,e)},
fE(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.A(a,b[s],d,e[s],f))return!1
return!0},
iP(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.A(a,r[s],c,q[s],e))return!1
return!0},
bc(a){var s=a.w,r=!0
if(!(a===t.P||a===t.u))if(!A.aN(a))if(s!==6)r=s===7&&A.bc(a.x)
return r},
aN(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
fD(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
dS(a){return a>0?new Array(a):v.typeUniverse.sEA},
a2:function a2(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
cI:function cI(){this.c=this.b=this.a=null},
dP:function dP(a){this.a=a},
cH:function cH(){},
bV:function bV(a){this.a=a},
hX(){var s,r,q
if(self.scheduleImmediate!=null)return A.j9()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.c1(new A.dr(s),1)).observe(r,{childList:true})
return new A.dq(s,r,q)}else if(self.setImmediate!=null)return A.ja()
return A.jb()},
hY(a){self.scheduleImmediate(A.c1(new A.ds(t.M.a(a)),0))},
hZ(a){self.setImmediate(A.c1(new A.dt(t.M.a(a)),0))},
i_(a){t.M.a(a)
A.id(0,a)},
id(a,b){var s=new A.dN()
s.bg(a,b)
return s},
F(a){return new A.cE(new A.x($.t,a.h("x<0>")),a.h("cE<0>"))},
E(a,b){a.$2(0,null)
b.b=!0
return b.a},
m(a,b){A.iu(a,b)},
D(a,b){b.ao(a)},
C(a,b){b.ap(A.N(a),A.au(a))},
iu(a,b){var s,r,q=new A.dU(b),p=new A.dV(b)
if(a instanceof A.x)a.aV(q,p,t.z)
else{s=t.z
if(a instanceof A.x)a.b7(q,p,s)
else{r=new A.x($.t,t._)
r.a=8
r.c=a
r.aV(q,p,s)}}},
G(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(r){e=r
d=c}}}}(a,1)
return $.t.aw(new A.dY(s),t.H,t.S,t.z)},
eB(a){var s
if(t.C.b(a)){s=a.gO()
if(s!=null)return s}return B.o},
iG(a,b){if($.t===B.i)return null
return null},
iH(a,b){if($.t!==B.i)A.iG(a,b)
if(b==null)if(t.C.b(a)){b=a.gO()
if(b==null){A.fg(a,B.o)
b=B.o}}else b=B.o
else if(t.C.b(a))A.fg(a,b)
return new A.O(a,b)},
eH(a,b,c){var s,r,q,p,o={},n=o.a=a
for(s=t._;r=n.a,(r&4)!==0;n=a){a=s.a(n.c)
o.a=a}if(n===b){s=A.fk()
b.ae(new A.O(new A.a_(!0,n,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=n.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=n
n.aT(p)
return}if(!c)if(b.c==null)n=(s&16)===0||q!==0
else n=!1
else n=!0
if(n){p=b.P()
b.a_(o.a)
A.aI(b,p)
return}b.a^=2
A.b7(null,null,b.b,t.M.a(new A.dB(o,b)))},
aI(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d={},c=d.a=a
for(s=t.n,r=t.F;;){q={}
p=c.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(c.c)
A.cP(m.a,m.b)}return}q.a=b
l=b.a
for(c=b;l!=null;c=l,l=k){c.a=null
A.aI(d.a,c)
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
A.cP(j.a,j.b)
return}g=$.t
if(g!==h)$.t=h
else g=null
c=c.c
if((c&15)===8)new A.dF(q,d,n).$0()
else if(o){if((c&1)!==0)new A.dE(q,j).$0()}else if((c&2)!==0)new A.dD(d,q).$0()
if(g!=null)$.t=g
c=q.c
if(c instanceof A.x){p=q.a.$ti
p=p.h("a1<2>").b(c)||!p.y[1].b(c)}else p=!1
if(p){f=q.a.b
if((c.a&24)!==0){e=r.a(f.c)
f.c=null
b=f.a2(e)
f.a=c.a&30|f.a&1
f.c=c.c
d.a=c
continue}else A.eH(c,f,!0)
return}}f=q.a.b
e=r.a(f.c)
f.c=null
b=f.a2(e)
c=q.b
p=q.c
if(!c){f.$ti.c.a(p)
f.a=8
f.c=p}else{s.a(p)
f.a=f.a&1|16
f.c=p}d.a=f
c=f}},
iY(a,b){var s
if(t.Q.b(a))return b.aw(a,t.z,t.K,t.l)
s=t.v
if(s.b(a))return s.a(a)
throw A.d(A.eA(a,"onError",u.c))},
iU(){var s,r
for(s=$.b6;s!=null;s=$.b6){$.c0=null
r=s.b
$.b6=r
if(r==null)$.c_=null
s.a.$0()}},
j2(){$.eP=!0
try{A.iU()}finally{$.c0=null
$.eP=!1
if($.b6!=null)$.eX().$1(A.fX())}},
fV(a){var s=new A.cF(a),r=$.c_
if(r==null){$.b6=$.c_=s
if(!$.eP)$.eX().$1(A.fX())}else $.c_=r.b=s},
j_(a){var s,r,q,p=$.b6
if(p==null){A.fV(a)
$.c0=$.c_
return}s=new A.cF(a)
r=$.c0
if(r==null){s.b=p
$.b6=$.c0=s}else{q=r.b
s.b=q
$.c0=r.b=s
if(q==null)$.c_=s}},
h5(a){var s=null,r=$.t
if(B.i===r){A.b7(s,s,B.i,a)
return}A.b7(s,s,r,t.M.a(r.aX(a)))},
jJ(a,b){A.dZ(a,"stream",t.K)
return new A.cL(b.h("cL<0>"))},
fU(a){return},
i4(a,b){if(b==null)b=A.jd()
if(t.aD.b(b))return a.aw(b,t.z,t.K,t.l)
if(t.bo.b(b))return t.v.a(b)
throw A.d(A.aj("handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace.",null))},
iW(a,b){A.cP(a,b)},
iV(){},
cP(a,b){A.j_(new A.dX(a,b))},
fR(a,b,c,d,e){var s,r=$.t
if(r===c)return d.$0()
$.t=c
s=r
try{r=d.$0()
return r}finally{$.t=s}},
fS(a,b,c,d,e,f,g){var s,r=$.t
if(r===c)return d.$1(e)
$.t=c
s=r
try{r=d.$1(e)
return r}finally{$.t=s}},
iZ(a,b,c,d,e,f,g,h,i){var s,r=$.t
if(r===c)return d.$2(e,f)
$.t=c
s=r
try{r=d.$2(e,f)
return r}finally{$.t=s}},
b7(a,b,c,d){t.M.a(d)
if(B.i!==c){d=c.aX(d)
d=d}A.fV(d)},
dr:function dr(a){this.a=a},
dq:function dq(a,b,c){this.a=a
this.b=b
this.c=c},
ds:function ds(a){this.a=a},
dt:function dt(a){this.a=a},
dN:function dN(){},
dO:function dO(a,b){this.a=a
this.b=b},
cE:function cE(a,b){this.a=a
this.b=!1
this.$ti=b},
dU:function dU(a){this.a=a},
dV:function dV(a){this.a=a},
dY:function dY(a){this.a=a},
O:function O(a,b){this.a=a
this.b=b},
b1:function b1(a,b){this.a=a
this.$ti=b},
ap:function ap(a,b,c,d,e){var _=this
_.ay=0
_.CW=_.ch=null
_.w=a
_.a=b
_.d=c
_.e=d
_.r=null
_.$ti=e},
aG:function aG(){},
bU:function bU(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.e=_.d=null
_.$ti=c},
dM:function dM(a,b){this.a=a
this.b=b},
cG:function cG(){},
bH:function bH(a,b){this.a=a
this.$ti=b},
aH:function aH(a,b,c,d,e){var _=this
_.a=null
_.b=a
_.c=b
_.d=c
_.e=d
_.$ti=e},
x:function x(a,b){var _=this
_.a=0
_.b=a
_.c=null
_.$ti=b},
dy:function dy(a,b){this.a=a
this.b=b},
dC:function dC(a,b){this.a=a
this.b=b},
dB:function dB(a,b){this.a=a
this.b=b},
dA:function dA(a,b){this.a=a
this.b=b},
dz:function dz(a,b){this.a=a
this.b=b},
dF:function dF(a,b,c){this.a=a
this.b=b
this.c=c},
dG:function dG(a,b){this.a=a
this.b=b},
dH:function dH(a){this.a=a},
dE:function dE(a,b){this.a=a
this.b=b},
dD:function dD(a,b){this.a=a
this.b=b},
cF:function cF(a){this.a=a
this.b=null},
b_:function b_(){},
di:function di(a,b){this.a=a
this.b=b},
dj:function dj(a,b){this.a=a
this.b=b},
bI:function bI(){},
bJ:function bJ(){},
ad:function ad(){},
b5:function b5(){},
bL:function bL(){},
bK:function bK(a,b){this.b=a
this.a=null
this.$ti=b},
cJ:function cJ(a){var _=this
_.a=0
_.c=_.b=null
_.$ti=a},
dK:function dK(a,b){this.a=a
this.b=b},
b3:function b3(a,b){var _=this
_.a=1
_.b=a
_.c=null
_.$ti=b},
cL:function cL(a){this.$ti=a},
bZ:function bZ(){},
cK:function cK(){},
dL:function dL(a,b){this.a=a
this.b=b},
dX:function dX(a,b){this.a=a
this.b=b},
ft(a,b){var s=a[b]
return s===a?null:s},
eJ(a,b,c){if(c==null)a[b]=a
else a[b]=c},
eI(){var s=Object.create(null)
A.eJ(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
j(a,b,c){return b.h("@<0>").l(c).h("f7<1,2>").a(A.jh(a,new A.aA(b.h("@<0>").l(c).h("aA<1,2>"))))},
bq(a,b){return new A.aA(a.h("@<0>").l(b).h("aA<1,2>"))},
fb(a){var s,r
if(A.eT(a))return"{...}"
s=new A.cz("")
try{r={}
B.d.u($.S,a)
s.a+="{"
r.a=!0
a.ar(0,new A.dd(r,s))
s.a+="}"}finally{if(0>=$.S.length)return A.e($.S,-1)
$.S.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
bM:function bM(){},
b4:function b4(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
bN:function bN(a,b){this.a=a
this.$ti=b},
bO:function bO(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
u:function u(){},
aD:function aD(){},
dd:function dd(a,b){this.a=a
this.b=b},
i3(a,b,c,d,e,f,g,a0){var s,r,q,p,o,n,m,l,k,j,i=a0>>>2,h=3-(a0&3)
for(s=b.length,r=a.length,q=f.$flags|0,p=c,o=0;p<d;++p){if(!(p<s))return A.e(b,p)
n=b[p]
o|=n
i=(i<<8|n)&16777215;--h
if(h===0){m=g+1
l=i>>>18&63
if(!(l<r))return A.e(a,l)
q&2&&A.Y(f)
k=f.length
if(!(g<k))return A.e(f,g)
f[g]=a.charCodeAt(l)
g=m+1
l=i>>>12&63
if(!(l<r))return A.e(a,l)
if(!(m<k))return A.e(f,m)
f[m]=a.charCodeAt(l)
m=g+1
l=i>>>6&63
if(!(l<r))return A.e(a,l)
if(!(g<k))return A.e(f,g)
f[g]=a.charCodeAt(l)
g=m+1
l=i&63
if(!(l<r))return A.e(a,l)
if(!(m<k))return A.e(f,m)
f[m]=a.charCodeAt(l)
i=0
h=3}}if(o>=0&&o<=255){if(h<3){m=g+1
j=m+1
if(3-h===1){s=i>>>2&63
if(!(s<r))return A.e(a,s)
q&2&&A.Y(f)
q=f.length
if(!(g<q))return A.e(f,g)
f[g]=a.charCodeAt(s)
s=i<<4&63
if(!(s<r))return A.e(a,s)
if(!(m<q))return A.e(f,m)
f[m]=a.charCodeAt(s)
g=j+1
if(!(j<q))return A.e(f,j)
f[j]=61
if(!(g<q))return A.e(f,g)
f[g]=61}else{s=i>>>10&63
if(!(s<r))return A.e(a,s)
q&2&&A.Y(f)
q=f.length
if(!(g<q))return A.e(f,g)
f[g]=a.charCodeAt(s)
s=i>>>4&63
if(!(s<r))return A.e(a,s)
if(!(m<q))return A.e(f,m)
f[m]=a.charCodeAt(s)
g=j+1
s=i<<2&63
if(!(s<r))return A.e(a,s)
if(!(j<q))return A.e(f,j)
f[j]=a.charCodeAt(s)
if(!(g<q))return A.e(f,g)
f[g]=61}return 0}return(i<<2|3-h)>>>0}for(p=c;p<d;){if(!(p<s))return A.e(b,p)
n=b[p]
if(n>255)break;++p}if(!(p<s))return A.e(b,p)
throw A.d(A.eA(b,"Not a byte value at index "+p+": 0x"+B.h.bY(b[p],16),null))},
i2(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i="Invalid encoding before padding",h="Invalid character",g=B.h.a4(a1,2),f=a1&3,e=$.hk()
for(s=a.length,r=e.length,q=d.$flags|0,p=b,o=0;p<c;++p){if(!(p<s))return A.e(a,p)
n=a.charCodeAt(p)
o|=n
m=n&127
if(!(m<r))return A.e(e,m)
l=e[m]
if(l>=0){g=(g<<6|l)&16777215
f=f+1&3
if(f===0){k=a0+1
q&2&&A.Y(d)
m=d.length
if(!(a0<m))return A.e(d,a0)
d[a0]=g>>>16&255
a0=k+1
if(!(k<m))return A.e(d,k)
d[k]=g>>>8&255
k=a0+1
if(!(a0<m))return A.e(d,a0)
d[a0]=g&255
a0=k
g=0}continue}else if(l===-1&&f>1){if(o>127)break
if(f===3){if((g&3)!==0)throw A.d(A.aS(i,a,p))
k=a0+1
q&2&&A.Y(d)
s=d.length
if(!(a0<s))return A.e(d,a0)
d[a0]=g>>>10
if(!(k<s))return A.e(d,k)
d[k]=g>>>2}else{if((g&15)!==0)throw A.d(A.aS(i,a,p))
q&2&&A.Y(d)
if(!(a0<d.length))return A.e(d,a0)
d[a0]=g>>>4}j=(3-f)*3
if(n===37)j+=2
return A.fr(a,p+1,c,-j-1)}throw A.d(A.aS(h,a,p))}if(o>=0&&o<=127)return(g<<2|f)>>>0
for(p=b;p<c;++p){if(!(p<s))return A.e(a,p)
if(a.charCodeAt(p)>127)break}throw A.d(A.aS(h,a,p))},
i0(a,b,c,d){var s=A.i1(a,b,c),r=(d&3)+(s-b),q=B.h.a4(r,2)*3,p=r&3
if(p!==0&&s<c)q+=p-1
if(q>0)return new Uint8Array(q)
return $.hj()},
i1(a,b,c){var s,r=a.length,q=c,p=q,o=0
for(;;){if(!(p>b&&o<2))break
A:{--p
if(!(p>=0&&p<r))return A.e(a,p)
s=a.charCodeAt(p)
if(s===61){++o
q=p
break A}if((s|32)===100){if(p===b)break;--p
if(!(p>=0&&p<r))return A.e(a,p)
s=a.charCodeAt(p)}if(s===51){if(p===b)break;--p
if(!(p>=0&&p<r))return A.e(a,p)
s=a.charCodeAt(p)}if(s===37){++o
q=p
break A}break}}return q},
fr(a,b,c,d){var s,r,q
if(b===c)return d
s=-d-1
for(r=a.length;s>0;){if(!(b<r))return A.e(a,b)
q=a.charCodeAt(b)
if(s===3){if(q===61){s-=3;++b
break}if(q===37){--s;++b
if(b===c)break
if(!(b<r))return A.e(a,b)
q=a.charCodeAt(b)}else break}if((s>3?s-3:s)===2){if(q!==51)break;++b;--s
if(b===c)break
if(!(b<r))return A.e(a,b)
q=a.charCodeAt(b)}if((q|32)!==100)break;++b;--s
if(b===c)break}if(b!==c)throw A.d(A.aS("Invalid padding character",a,b))
return-s-1},
c5:function c5(){},
cV:function cV(){},
dv:function dv(a){this.a=0
this.b=a},
cU:function cU(){},
du:function du(){this.a=0},
aw:function aw(){},
c9:function c9(){},
hy(a,b){a=A.B(a,new Error())
if(a==null)a=A.J(a)
a.stack=b.k(0)
throw a},
f9(a,b,c,d){var s,r=J.hB(a,d)
if(a!==0&&b!=null)for(s=0;s<a;++s)r[s]=b
return r},
f8(a,b){var s,r=A.M([],b.h("z<0>"))
for(s=J.ey(a);s.p();)B.d.u(r,s.gn())
return r},
hU(a){var s
A.fh(0,"start")
s=A.hV(a,0,null)
return s},
hV(a,b,c){var s=a.length
if(b>=s)return""
return A.hR(a,b,s)},
fm(a,b,c){var s=J.ey(b)
if(!s.p())return a
if(c.length===0){do a+=A.c(s.gn())
while(s.p())}else{a+=A.c(s.gn())
while(s.p())a=a+c+A.c(s.gn())}return a},
fk(){return A.au(new Error())},
hx(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
f5(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
cb(a){if(a>=10)return""+a
return"0"+a},
cY(a){if(typeof a=="number"||A.dW(a)||a==null)return J.T(a)
if(typeof a=="string")return JSON.stringify(a)
return A.hQ(a)},
hz(a,b){A.dZ(a,"error",t.K)
A.dZ(b,"stackTrace",t.l)
A.hy(a,b)},
c4(a){return new A.c3(a)},
aj(a,b){return new A.a_(!1,null,b,a)},
eA(a,b,c){return new A.a_(!0,a,b,c)},
hS(a,b){return new A.aZ(null,null,!0,a,b,"Value not in range")},
aa(a,b,c,d,e){return new A.aZ(b,c,!0,a,d,"Invalid value")},
fi(a,b,c){if(0>a||a>c)throw A.d(A.aa(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.d(A.aa(b,a,c,"end",null))
return b}return c},
fh(a,b){if(a<0)throw A.d(A.aa(a,0,null,b,null))
return a},
f6(a,b,c,d){return new A.cc(b,!0,a,d,"Index out of range")},
bF(a){return new A.bE(a)},
fp(a){return new A.cC(a)},
cx(a){return new A.aE(a)},
bg(a){return new A.c8(a)},
U(a){return new A.dx(a)},
aS(a,b,c){return new A.d0(a,b,c)},
hA(a,b,c){var s,r
if(A.eT(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.M([],t.s)
B.d.u($.S,a)
try{A.iT(a,s)}finally{if(0>=$.S.length)return A.e($.S,-1)
$.S.pop()}r=A.fm(b,t.R.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
d7(a,b,c){var s,r
if(A.eT(a))return b+"..."+c
s=new A.cz(b)
B.d.u($.S,a)
try{r=s
r.a=A.fm(r.a,a,", ")}finally{if(0>=$.S.length)return A.e($.S,-1)
$.S.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
iT(a,b){var s,r,q,p,o,n,m,l=a.gA(a),k=0,j=0
for(;;){if(!(k<80||j<3))break
if(!l.p())return
s=A.c(l.gn())
B.d.u(b,s)
k+=s.length+2;++j}if(!l.p()){if(j<=5)return
if(0>=b.length)return A.e(b,-1)
r=b.pop()
if(0>=b.length)return A.e(b,-1)
q=b.pop()}else{p=l.gn();++j
if(!l.p()){if(j<=4){B.d.u(b,A.c(p))
return}r=A.c(p)
if(0>=b.length)return A.e(b,-1)
q=b.pop()
k+=r.length+2}else{o=l.gn();++j
for(;l.p();p=o,o=n){n=l.gn();++j
if(j>100){for(;;){if(!(k>75&&j>3))break
if(0>=b.length)return A.e(b,-1)
k-=b.pop().length+2;--j}B.d.u(b,"...")
return}}q=A.c(p)
r=A.c(o)
k+=r.length+q.length+4}}if(j>b.length+2){k+=5
m="..."}else m=null
for(;;){if(!(k>80&&b.length>3))break
if(0>=b.length)return A.e(b,-1)
k-=b.pop().length+2
if(m==null){k+=5
m="..."}}if(m!=null)B.d.u(b,m)
B.d.u(b,q)
B.d.u(b,r)},
hH(a,b){var s=B.h.gt(a)
b=B.h.gt(b)
b=A.hW(A.fn(A.fn($.hl(),s),b))
return b},
ca:function ca(a,b,c){this.a=a
this.b=b
this.c=c},
dw:function dw(){},
w:function w(){},
c3:function c3(a){this.a=a},
ab:function ab(){},
a_:function a_(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
aZ:function aZ(a,b,c,d,e,f){var _=this
_.e=a
_.f=b
_.a=c
_.b=d
_.c=e
_.d=f},
cc:function cc(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
bE:function bE(a){this.a=a},
cC:function cC(a){this.a=a},
aE:function aE(a){this.a=a},
c8:function c8(a){this.a=a},
cs:function cs(){},
bC:function bC(){},
dx:function dx(a){this.a=a},
d0:function d0(a,b,c){this.a=a
this.b=b
this.c=c},
f:function f(){},
y:function y(){},
k:function k(){},
cM:function cM(){},
cz:function cz(a){this.a=a},
eD(a,b){var s,r,q,p,o
if(b.length===0)return!1
s=b.split(".")
r=v.G
for(q=s.length,p=0;p<q;++p,r=o){o=r[s[p]]
A.fF(o)
if(o==null)return!1}return a instanceof t.g.a(r)},
de:function de(a){this.a=a},
fJ(a){var s
if(typeof a=="function")throw A.d(A.aj("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.iv,a)
s[$.et()]=a
return s},
fK(a){var s
if(typeof a=="function")throw A.d(A.aj("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e){return b(c,d,e,arguments.length)}}(A.iw,a)
s[$.et()]=a
return s},
iv(a,b,c){t.Z.a(a)
if(A.n(c)>=1)return a.$1(b)
return a.$0()},
iw(a,b,c,d){t.Z.a(a)
A.n(d)
if(d>=2)return a.$2(b,c)
if(d===1)return a.$1(b)
return a.$0()},
fQ(a){return a==null||A.dW(a)||typeof a=="number"||typeof a=="string"||t.U.b(a)||t.D.b(a)||t.ca.b(a)||t.O.b(a)||t.c0.b(a)||t.k.b(a)||t.bk.b(a)||t.G.b(a)||t.q.b(a)||t.J.b(a)||t.V.b(a)},
h(a){if(A.fQ(a))return a
return new A.ec(new A.b4(t.A)).$1(a)},
eQ(a,b,c,d){return d.a(a[b].apply(a,c))},
ag(a,b){var s=new A.x($.t,b.h("x<0>")),r=new A.bH(s,b.h("bH<0>"))
a.then(A.c1(new A.ep(r,b),1),A.c1(new A.eq(r),1))
return s},
fP(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
fZ(a){if(A.fP(a))return a
return new A.e_(new A.b4(t.A)).$1(a)},
ec:function ec(a){this.a=a},
ep:function ep(a,b){this.a=a
this.b=b},
eq:function eq(a){this.a=a},
e_:function e_(a){this.a=a},
dI:function dI(a){this.a=a},
an:function an(a,b){this.a=a
this.b=b},
aC:function aC(a,b,c){this.a=a
this.b=b
this.d=c},
db(a){return $.hE.bT(a,new A.dc(a))},
aX:function aX(a,b,c){var _=this
_.a=a
_.b=b
_.c=null
_.d=c
_.f=null},
dc:function dc(a){this.a=a},
ai:function ai(a,b){this.a=a
this.b=b},
bi:function bi(a,b,c){this.a=a
this.b=b
this.c=c},
ax:function ax(a,b,c,d){var _=this
_.a=-1
_.b=a
_.c=b
_.d=c
_.f=d},
cW:function cW(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
cX:function cX(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
a0:function a0(a,b){this.a=a
this.b=b},
d3:function d3(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
al:function al(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.e=d
_.f=$
_.w=_.r=!1
_.x=e
_.y=0
_.z=f
_.Q=g},
d1:function d1(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
d2:function d2(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fd(a,b,c){var s=new A.ct(a,c,b),r=a.f
if(r<=0||r>255)A.X(A.U("Invalid key ring size"))
s.b=t.bG.a(A.f9(r,null,!1,t.aF))
return s},
d9:function d9(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
cj:function cj(a,b,c,d){var _=this
_.a=a
_.c=b
_.d=c
_.e=null
_.f=d},
aW:function aW(a,b){this.a=a
this.b=b},
ct:function ct(a,b,c){var _=this
_.a=0
_.b=$
_.c=!1
_.d=a
_.e=b
_.f=c
_.r=0},
jr(a){return a===0||a===1||a===2||a===3||a===4||a===5||a===6||a===7||a===8||a===9||a===16||a===17||a===18||a===19||a===20||a===21},
jj(a,b,c){var s,r,q,p,o,n
for(s=b.length,r=a.length,q=c==="h265",p=0;p<s;++p){o=b[p]
if(q){if(!(o<r))return A.e(a,o)
if(A.jr(a[o]>>>1&63))return o+2}else{if(!(o<r))return A.e(a,o)
n=a[o]&31
if(n===5||n===1)return o+2}}return null},
ji(a){var s,r,q,p,o,n=A.M([],t.t),m=a.length,l=m-3
for(s=l-1,r=0,q=0;q<l;r=q){while(q<l){if(q<s){if(!(q>=0))return A.e(a,q)
p=a[q]===0&&a[q+1]===0&&a[q+2]===0&&a[q+3]===1}else p=!1
if(p)break
if(!(q>=0))return A.e(a,q)
if(a[q]===0&&a[q+1]===0&&a[q+2]===1)break;++q}if(q>=l)q=m
o=q
for(;;){if(o>r){p=o-1
if(!(p>=0))return A.e(a,p)
p=a[p]===0}else p=!1
if(!p)break;--o}if(r===0){if(o!==r)throw A.d(A.U("byte stream contains leading data"))}else B.d.u(n,r)
if(q<l){if(!(q>=0))return A.e(a,q)
p=a[q]===0&&a[q+1]===0&&a[q+2]===0&&a[q+3]===1}else p=!1
q+=p?4:3}return n},
jx(a,b){var s,r=A.ji(a)
if(b==="unknown")return new A.ck(0,b)
s=A.jj(a,r,b)
if(s==null)throw A.d(A.U("Could not find NALU"))
return new A.ck(s,b)},
ck:function ck(a,b){this.a=a
this.b=b},
dh:function dh(){var _=this
_.a=0
_.b=null
_.d=_.c=0},
h2(a,b,c){var s,r,q=null,p=A.az($.aP,new A.e7(b),t.j)
if(p==null){$.v().i(B.f,"creating new cryptor for "+a+", trackId "+b,q,q)
s=A.b(v.G.self)
r=t.S
p=new A.al(A.bq(r,r),a,b,c.G(a),B.m,s,new A.dh())
B.d.u($.aP,p)}else if(a!==p.b){s=c.G(a)
if(p.x!==B.k){$.v().i(B.f,"setParticipantId: lastError != CryptorError.kOk, reset state to kNew",q,q)
p.x=B.m}p.b=a
p.e=s
p.Q.b5()}return p},
h0(a,b,c){var s,r=A.az($.eW,new A.e1(b),t.p)
if(r==null){$.v().i(B.f,"creating new cryptor for "+a+", dataCryptorId "+b,null,null)
s=A.b(v.G.self)
r=new A.ax(a,b,c.G(a),s)
B.d.u($.eW,r)}else if(a!==r.b){s=c.G(a)
r.b=a
r.d=s}return r},
jB(a){var s=A.az($.aP,new A.er(a),t.j)
if(s!=null)s.b=null},
jC(a){var s=A.az($.eW,new A.es(a),t.p)
if(s!=null)s.b=null},
eU(){var s=0,r=A.F(t.H),q,p
var $async$eU=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:p=$.cR()
if(p.b!=null)A.X(A.bF('Please set "hierarchicalLoggingEnabled" to true if you want to change the level on a non-root logger.'))
J.ev(p.c,B.b)
p.c=B.b
p.aR().bR(new A.ej())
p=$.v()
p.i(B.f,"Worker created",null,null)
q=v.G
if("RTCTransformEvent" in A.b(q.self)){p.i(B.f,"setup RTCTransformEvent event handler",null,null)
A.b(q.self).onrtctransform=A.fJ(new A.ek())}A.b(q.self).onmessage=A.fJ(new A.el(new A.em()))
return A.D(null,r)}})
return A.E($async$eU,r)},
e7:function e7(a){this.a=a},
e1:function e1(a){this.a=a},
er:function er(a){this.a=a},
es:function es(a){this.a=a},
ej:function ej(){},
ek:function ek(){},
em:function em(){},
ed:function ed(a){this.a=a},
ee:function ee(a){this.a=a},
ef:function ef(a){this.a=a},
eg:function eg(a){this.a=a},
eh:function eh(a){this.a=a},
ei:function ei(a){this.a=a},
el:function el(a){this.a=a},
h6(a){return v.mangledGlobalNames[a]},
jw(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
ah(a){throw A.B(A.hD(a),new Error())},
jz(a){throw A.B(new A.bn("Field '"+a+"' has been assigned during initialization."),new Error())},
az(a,b,c){var s,r,q
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.c2)(a),++r){q=a[r]
if(b.$1(q))return q}return null},
h_(a,b){switch(a){case"HKDF":return A.j(["name","HKDF","salt",b,"hash","SHA-256","info",new Uint8Array(128)],t.N,t.z)
case"PBKDF2":return A.j(["name","PBKDF2","salt",b,"hash","SHA-256","iterations",1e5],t.N,t.z)
default:throw A.d(A.U("algorithm "+a+" is currently unsupported"))}}},B={}
var w=[A,J,B]
var $={}
A.eE.prototype={}
J.cd.prototype={
F(a,b){return a===b},
gt(a){return A.bA(a)},
k(a){return"Instance of '"+A.cv(a)+"'"},
gq(a){return A.at(A.eO(this))}}
J.cf.prototype={
k(a){return String(a)},
gt(a){return a?519018:218159},
gq(a){return A.at(t.y)},
$ip:1,
$iW:1}
J.bl.prototype={
F(a,b){return null==b},
k(a){return"null"},
gt(a){return 0},
$ip:1,
$iy:1}
J.bm.prototype={$iq:1}
J.am.prototype={
gt(a){return 0},
gq(a){return B.X},
k(a){return String(a)}}
J.cu.prototype={}
J.bD.prototype={}
J.a6.prototype={
k(a){var s=a[$.h8()]
if(s==null)s=a[$.et()]
if(s==null)return this.bd(a)
return"JavaScript function for "+J.T(s)},
$iay:1}
J.aU.prototype={
gt(a){return 0},
k(a){return String(a)}}
J.aV.prototype={
gt(a){return 0},
k(a){return String(a)}}
J.z.prototype={
u(a,b){A.ae(a).c.a(b)
a.$flags&1&&A.Y(a,29)
a.push(b)},
bC(a,b){var s
A.ae(a).h("f<1>").a(b)
a.$flags&1&&A.Y(a,"addAll",2)
for(s=b.gA(b);s.p();)a.push(s.gn())},
V(a,b,c){var s=A.ae(a)
return new A.a9(a,s.l(c).h("1(2)").a(b),s.h("@<1>").l(c).h("a9<1,2>"))},
T(a,b){if(!(b>=0&&b<a.length))return A.e(a,b)
return a[b]},
bD(a,b){var s
for(s=0;s<a.length;++s)if(J.ev(a[s],b))return!0
return!1},
k(a){return A.d7(a,"[","]")},
gA(a){return new J.be(a,a.length,A.ae(a).h("be<1>"))},
gt(a){return A.bA(a)},
gm(a){return a.length},
j(a,b){A.n(b)
if(!(b>=0&&b<a.length))throw A.d(A.cQ(a,b))
return a[b]},
v(a,b,c){A.ae(a).c.a(c)
a.$flags&2&&A.Y(a)
if(!(b>=0&&b<a.length))throw A.d(A.cQ(a,b))
a[b]=c},
gq(a){return A.at(A.ae(a))},
$il:1,
$if:1,
$ir:1}
J.ce.prototype={
bZ(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.cv(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.d8.prototype={}
J.be.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.c2(q)
throw A.d(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$ia4:1}
J.ch.prototype={
b8(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.d(A.bF(""+a+".toInt()"))},
bY(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.d(A.aa(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.e(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.X(A.bF("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.e(p,1)
s=p[1]
if(3>=r)return A.e(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.l.aC("0",o)},
k(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gt(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
aa(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
bz(a,b){return(a|0)===a?a/b|0:this.bA(a,b)},
bA(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.d(A.bF("Result of truncating division is "+A.c(s)+": "+A.c(a)+" ~/ "+b))},
a4(a,b){var s
if(a>0)s=this.bx(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
bx(a,b){return b>31?0:a>>>b},
gq(a){return A.at(t.o)},
$io:1,
$iaO:1}
J.bk.prototype={
gq(a){return A.at(t.S)},
$ip:1,
$ia:1}
J.cg.prototype={
gq(a){return A.at(t.i)},
$ip:1}
J.aT.prototype={
bM(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.aG(a,r-s)},
bc(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
Z(a,b,c){return a.substring(b,A.fi(b,c,a.length))},
aG(a,b){return this.Z(a,b,null)},
aC(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.d(B.L)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
bP(a,b){var s=a.length,r=b.length
if(s+r>s)s-=r
return a.lastIndexOf(b,s)},
k(a){return a},
gt(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gq(a){return A.at(t.N)},
gm(a){return a.length},
j(a,b){A.n(b)
if(!(b.c0(0,0)&&b.c1(0,a.length)))throw A.d(A.cQ(a,b))
return a[b]},
$ip:1,
$ife:1,
$ia5:1}
A.b2.prototype={
u(a,b){var s,r,q,p,o,n,m,l=this
t.L.a(b)
s=b.length
if(s===0)return
r=l.a+s
q=l.b
p=q.length
if(p<r){o=r*2
if(o<1024)o=1024
else{n=o-1
n|=B.h.a4(n,1)
n|=n>>>2
n|=n>>>4
n|=n>>>8
o=((n|n>>>16)>>>0)+1}m=new Uint8Array(o)
B.e.aE(m,0,p,q)
l.b=m
q=m}B.e.aE(q,l.a,r,b)
l.a=r},
aA(){var s=this
if(s.a===0)return $.cS()
return new Uint8Array(A.as(J.f_(B.e.gH(s.b),s.b.byteOffset,s.a)))},
gm(a){return this.a},
$ihr:1}
A.bn.prototype={
k(a){return"LateInitializationError: "+this.a}}
A.dg.prototype={}
A.l.prototype={}
A.a7.prototype={
gA(a){var s=this
return new A.aB(s,s.gm(s),A.K(s).h("aB<a7.E>"))},
V(a,b,c){var s=A.K(this)
return new A.a9(this,s.l(c).h("1(a7.E)").a(b),s.h("@<a7.E>").l(c).h("a9<1,2>"))}}
A.aB.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s,r=this,q=r.a,p=J.e2(q),o=p.gm(q)
if(r.b!==o)throw A.d(A.bg(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.T(q,s);++r.c
return!0},
$ia4:1}
A.a8.prototype={
gA(a){var s=this.a
return new A.bs(s.gA(s),this.b,A.K(this).h("bs<1,2>"))},
gm(a){var s=this.a
return s.gm(s)}}
A.bh.prototype={$il:1}
A.bs.prototype={
p(){var s=this,r=s.b
if(r.p()){s.a=s.c.$1(r.gn())
return!0}s.a=null
return!1},
gn(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$ia4:1}
A.a9.prototype={
gm(a){return J.aQ(this.a)},
T(a,b){return this.b.$1(J.hn(this.a,b))}}
A.aF.prototype={
gA(a){return new A.bG(J.ey(this.a),this.b,this.$ti.h("bG<1>"))},
V(a,b,c){var s=this.$ti
return new A.a8(this,s.l(c).h("1(2)").a(b),s.h("@<1>").l(c).h("a8<1,2>"))}}
A.bG.prototype={
p(){var s,r
for(s=this.a,r=this.b;s.p();)if(r.$1(s.gn()))return!0
return!1},
gn(){return this.a.gn()},
$ia4:1}
A.L.prototype={}
A.bB.prototype={}
A.dk.prototype={
C(a){var s,r,q=this,p=new RegExp(q.a).exec(a)
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
A.bz.prototype={
k(a){return"Null check operator used on a null value"}}
A.ci.prototype={
k(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.cD.prototype={
k(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.df.prototype={
k(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.bj.prototype={}
A.bT.prototype={
k(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ia3:1}
A.ak.prototype={
k(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.h7(r==null?"unknown":r)+"'"},
$iay:1,
gc_(){return this},
$C:"$1",
$R:1,
$D:null}
A.c6.prototype={$C:"$0",$R:0}
A.c7.prototype={$C:"$2",$R:2}
A.cA.prototype={}
A.cy.prototype={
k(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.h7(s)+"'"}}
A.aR.prototype={
F(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.aR))return!1
return this.$_target===b.$_target&&this.a===b.a},
gt(a){return(A.eo(this.a)^A.bA(this.$_target))>>>0},
k(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.cv(this.a)+"'")}}
A.cw.prototype={
k(a){return"RuntimeError: "+this.a}}
A.aA.prototype={
gm(a){return this.a},
ga9(){return new A.bp(this,this.$ti.h("bp<1>"))},
a6(a){var s=this.b
if(s==null)return!1
return s[a]!=null},
j(a,b){var s,r,q,p,o=null
if(typeof b=="string"){s=this.b
if(s==null)return o
r=s[b]
q=r==null?o:r.b
return q}else if(typeof b=="number"&&(b&0x3fffffff)===b){p=this.c
if(p==null)return o
r=p[b]
q=r==null?o:r.b
return q}else return this.bO(b)},
bO(a){var s,r,q=this.d
if(q==null)return null
s=this.bq(q,a)
r=this.b1(s,a)
if(r<0)return null
return s[r].b},
v(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"){s=m.b
m.aH(s==null?m.b=m.aj():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.aH(r==null?m.c=m.aj():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.aj()
p=J.cT(b)&1073741823
o=q[p]
if(o==null)q[p]=[m.ak(b,c)]
else{n=m.b1(o,b)
if(n>=0)o[n].b=c
else o.push(m.ak(b,c))}}},
bT(a,b){var s,r,q=this,p=q.$ti
p.c.a(a)
p.h("2()").a(b)
if(q.a6(a)){s=q.j(0,a)
return s==null?p.y[1].a(s):s}r=b.$0()
q.v(0,a,r)
return r},
bU(a,b){var s=this.bu(this.b,b)
return s},
ar(a,b){var s,r,q=this
q.$ti.h("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.d(A.bg(q))
s=s.c}},
aH(a,b,c){var s,r=this.$ti
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.ak(b,c)
else s.b=c},
bu(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.bB(s)
delete a[b]
return s.b},
aS(){this.r=this.r+1&1073741823},
ak(a,b){var s=this,r=s.$ti,q=new A.da(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.aS()
return q},
bB(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.aS()},
bq(a,b){return a[J.cT(b)&1073741823]},
b1(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.ev(a[r].a,b))return r
return-1},
k(a){return A.fb(this)},
aj(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$if7:1}
A.da.prototype={}
A.bp.prototype={
gm(a){return this.a.a},
gA(a){var s=this.a
return new A.bo(s,s.r,s.e,this.$ti.h("bo<1>"))}}
A.bo.prototype={
gn(){return this.d},
p(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.bg(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$ia4:1}
A.e8.prototype={
$1(a){return this.a(a)},
$S:13}
A.e9.prototype={
$2(a,b){return this.a(a,b)},
$S:14}
A.ea.prototype={
$1(a){return this.a(A.i(a))},
$S:15}
A.ao.prototype={
gq(a){return B.Q},
a5(a,b,c){return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
aW(a){return this.a5(a,0,null)},
$ip:1,
$iao:1,
$ibf:1}
A.aY.prototype={$iaY:1}
A.bw.prototype={
gH(a){if(((a.$flags|0)&2)!==0)return new A.cN(a.buffer)
else return a.buffer},
br(a,b,c,d){var s=A.aa(b,0,c,d,null)
throw A.d(s)},
aM(a,b,c,d){if(b>>>0!==b||b>c)this.br(a,b,c,d)}}
A.cN.prototype={
a5(a,b,c){var s=A.I(this.a,b,c)
s.$flags=3
return s},
aW(a){return this.a5(0,0,null)},
$ibf:1}
A.bt.prototype={
gq(a){return B.R},
bw(a,b,c){return a.setInt8(b,c)},
$ip:1,
$ieC:1}
A.H.prototype={
gm(a){return a.length},
$iP:1}
A.bu.prototype={
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$il:1,
$if:1,
$ir:1}
A.bv.prototype={
aE(a,b,c,d){var s,r,q,p
t.e.a(d)
a.$flags&2&&A.Y(a,5)
s=a.length
this.aM(a,b,s,"start")
this.aM(a,c,s,"end")
if(b>c)A.X(A.aa(b,0,c,null,null))
r=c-b
q=d.length
if(q<r)A.X(A.cx("Not enough elements"))
p=q!==r?d.subarray(0,r):d
a.set(p,b)
return},
$il:1,
$if:1,
$ir:1}
A.cl.prototype={
gq(a){return B.S},
$ip:1,
$icZ:1}
A.cm.prototype={
gq(a){return B.T},
$ip:1,
$id_:1}
A.cn.prototype={
gq(a){return B.U},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$id4:1}
A.co.prototype={
gq(a){return B.V},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$id5:1}
A.cp.prototype={
gq(a){return B.W},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$id6:1}
A.cq.prototype={
gq(a){return B.Z},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$idm:1}
A.cr.prototype={
gq(a){return B.a_},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$idn:1}
A.bx.prototype={
gq(a){return B.a0},
gm(a){return a.length},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$idp:1}
A.by.prototype={
gq(a){return B.a1},
gm(a){return a.length},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
B(a,b,c){return new Uint8Array(a.subarray(b,A.ix(b,c,a.length)))},
aF(a,b){return this.B(a,b,null)},
$ip:1,
$icB:1}
A.bP.prototype={}
A.bQ.prototype={}
A.bR.prototype={}
A.bS.prototype={}
A.a2.prototype={
h(a){return A.dR(v.typeUniverse,this,a)},
l(a){return A.im(v.typeUniverse,this,a)}}
A.cI.prototype={}
A.dP.prototype={
k(a){return A.R(this.a,null)}}
A.cH.prototype={
k(a){return this.a}}
A.bV.prototype={$iab:1}
A.dr.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:5}
A.dq.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:16}
A.ds.prototype={
$0(){this.a.$0()},
$S:6}
A.dt.prototype={
$0(){this.a.$0()},
$S:6}
A.dN.prototype={
bg(a,b){if(self.setTimeout!=null)self.setTimeout(A.c1(new A.dO(this,b),0),a)
else throw A.d(A.bF("`setTimeout()` not found."))}}
A.dO.prototype={
$0(){this.b.$0()},
$S:0}
A.cE.prototype={
ao(a){var s,r=this,q=r.$ti
q.h("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.ad(a)
else{s=r.a
if(q.h("a1<1>").b(a))s.aL(a)
else s.aO(a)}},
ap(a,b){var s=this.a
if(this.b)s.a0(new A.O(a,b))
else s.ae(new A.O(a,b))}}
A.dU.prototype={
$1(a){return this.a.$2(0,a)},
$S:3}
A.dV.prototype={
$2(a,b){this.a.$2(1,new A.bj(a,t.l.a(b)))},
$S:17}
A.dY.prototype={
$2(a,b){this.a(A.n(a),b)},
$S:18}
A.O.prototype={
k(a){return A.c(this.a)},
$iw:1,
gO(){return this.b}}
A.b1.prototype={}
A.ap.prototype={
al(){},
am(){},
sa1(a){this.ch=this.$ti.h("ap<1>?").a(a)},
san(a){this.CW=this.$ti.h("ap<1>?").a(a)}}
A.aG.prototype={
gai(){return this.c<4},
by(a,b,c,d){var s,r,q,p,o,n,m=this,l=A.K(m)
l.h("~(1)?").a(a)
t.Y.a(c)
if((m.c&4)!==0){l=new A.b3($.t,l.h("b3<1>"))
A.h5(l.gbs())
if(c!=null)l.c=t.M.a(c)
return l}s=$.t
r=d?1:0
q=b!=null?32:0
t.h.l(l.c).h("1(2)").a(a)
A.i4(s,b)
p=c==null?A.jc():c
t.M.a(p)
l=l.h("ap<1>")
o=new A.ap(m,a,s,r|q,l)
o.CW=o
o.ch=o
l.a(o)
o.ay=m.c&1
n=m.e
m.e=o
o.sa1(null)
o.san(n)
if(n==null)m.d=o
else n.sa1(o)
if(m.d==m.e)A.fU(m.a)
return o},
ab(){if((this.c&4)!==0)return new A.aE("Cannot add new events after calling close")
return new A.aE("Cannot add new events while doing an addStream")},
bo(a){var s,r,q,p,o,n=this,m=A.K(n)
m.h("~(ad<1>)").a(a)
s=n.c
if((s&2)!==0)throw A.d(A.cx(u.o))
r=n.d
if(r==null)return
q=s&1
n.c=s^3
for(m=m.h("ap<1>");r!=null;){s=r.ay
if((s&1)===q){r.ay=s|2
a.$1(r)
s=r.ay^=1
p=r.ch
if((s&4)!==0){m.a(r)
o=r.CW
if(o==null)n.d=p
else o.sa1(p)
if(p==null)n.e=o
else p.san(o)
r.san(r)
r.sa1(r)}r.ay&=4294967293
r=p}else r=r.ch}n.c&=4294967293
if(n.d==null)n.aK()},
aK(){if((this.c&4)!==0)if(null.gc2())null.ad(null)
A.fU(this.b)},
$ifl:1,
$ifx:1,
$iaq:1}
A.bU.prototype={
gai(){return A.aG.prototype.gai.call(this)&&(this.c&2)===0},
ab(){if((this.c&2)!==0)return new A.aE(u.o)
return this.be()},
a3(a){var s,r=this
r.$ti.c.a(a)
s=r.d
if(s==null)return
if(s===r.e){r.c|=2
s.aI(a)
r.c&=4294967293
if(r.d==null)r.aK()
return}r.bo(new A.dM(r,a))}}
A.dM.prototype={
$1(a){this.a.$ti.h("ad<1>").a(a).aI(this.b)},
$S(){return this.a.$ti.h("~(ad<1>)")}}
A.cG.prototype={
ap(a,b){var s=this.a
if((s.a&30)!==0)throw A.d(A.cx("Future already completed"))
s.ae(A.iH(a,b))},
aY(a){return this.ap(a,null)}}
A.bH.prototype={
ao(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.d(A.cx("Future already completed"))
s.ad(r.h("1/").a(a))}}
A.aH.prototype={
bS(a){if((this.c&15)!==6)return!0
return this.b.b.az(t.c1.a(this.d),a.a,t.y,t.K)},
bN(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.bW(q,m,a.b,o,n,t.l)
else p=l.az(t.v.a(q),m,o,n)
try{o=r.$ti.h("2/").a(p)
return o}catch(s){if(t.b7.b(A.N(s))){if((r.c&1)!==0)throw A.d(A.aj("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.d(A.aj("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.x.prototype={
b7(a,b,c){var s,r,q=this.$ti
q.l(c).h("1/(2)").a(a)
s=$.t
if(s===B.i){if(!t.Q.b(b)&&!t.v.b(b))throw A.d(A.eA(b,"onError",u.c))}else{c.h("@<0/>").l(q.c).h("1(2)").a(a)
b=A.iY(b,s)}r=new A.x(s,c.h("x<0>"))
this.ac(new A.aH(r,3,a,b,q.h("@<1>").l(c).h("aH<1,2>")))
return r},
aV(a,b,c){var s,r=this.$ti
r.l(c).h("1/(2)").a(a)
s=new A.x($.t,c.h("x<0>"))
this.ac(new A.aH(s,19,a,b,r.h("@<1>").l(c).h("aH<1,2>")))
return s},
bv(a){this.a=this.a&1|16
this.c=a},
a_(a){this.a=a.a&30|this.a&1
this.c=a.c},
ac(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.ac(a)
return}r.a_(s)}A.b7(null,null,r.b,t.M.a(new A.dy(r,a)))}},
aT(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.aT(a)
return}m.a_(n)}l.a=m.a2(a)
A.b7(null,null,m.b,t.M.a(new A.dC(l,m)))}},
P(){var s=t.F.a(this.c)
this.c=null
return this.a2(s)},
a2(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
aO(a){var s,r=this
r.$ti.c.a(a)
s=r.P()
r.a=8
r.c=a
A.aI(r,s)},
bm(a){var s,r,q=this
if((a.a&16)!==0){s=q.b===a.b
s=!(s||s)}else s=!1
if(s)return
r=q.P()
q.a_(a)
A.aI(q,r)},
a0(a){var s=this.P()
this.bv(a)
A.aI(this,s)},
bl(a,b){A.J(a)
t.l.a(b)
this.a0(new A.O(a,b))},
ad(a){var s=this.$ti
s.h("1/").a(a)
if(s.h("a1<1>").b(a)){this.aL(a)
return}this.bi(a)},
bi(a){var s=this
s.$ti.c.a(a)
s.a^=2
A.b7(null,null,s.b,t.M.a(new A.dA(s,a)))},
aL(a){A.eH(this.$ti.h("a1<1>").a(a),this,!1)
return},
ae(a){this.a^=2
A.b7(null,null,this.b,t.M.a(new A.dz(this,a)))},
$ia1:1}
A.dy.prototype={
$0(){A.aI(this.a,this.b)},
$S:0}
A.dC.prototype={
$0(){A.aI(this.b,this.a.a)},
$S:0}
A.dB.prototype={
$0(){A.eH(this.a.a,this.b,!0)},
$S:0}
A.dA.prototype={
$0(){this.a.aO(this.b)},
$S:0}
A.dz.prototype={
$0(){this.a.a0(this.b)},
$S:0}
A.dF.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
j=q.b.b.bV(t.bd.a(q.d),t.z)}catch(p){s=A.N(p)
r=A.au(p)
if(k.c&&t.n.a(k.b.a.c).a===s){q=k.a
q.c=t.n.a(k.b.a.c)}else{q=s
o=r
if(o==null)o=A.eB(q)
n=k.a
n.c=new A.O(q,o)
q=n}q.b=!0
return}if(j instanceof A.x&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.n.a(j.c)
q.b=!0}return}if(j instanceof A.x){m=k.b.a
l=new A.x(m.b,m.$ti)
j.b7(new A.dG(l,m),new A.dH(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.dG.prototype={
$1(a){this.a.bm(this.b)},
$S:5}
A.dH.prototype={
$2(a,b){A.J(a)
t.l.a(b)
this.a.a0(new A.O(a,b))},
$S:19}
A.dE.prototype={
$0(){var s,r,q,p,o,n,m,l
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
q.c=p.b.b.az(o.h("2/(1)").a(p.d),m,o.h("2/"),n)}catch(l){s=A.N(l)
r=A.au(l)
q=s
p=r
if(p==null)p=A.eB(q)
o=this.a
o.c=new A.O(q,p)
o.b=!0}},
$S:0}
A.dD.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.n.a(l.a.a.c)
p=l.b
if(p.a.bS(s)&&p.a.e!=null){p.c=p.a.bN(s)
p.b=!1}}catch(o){r=A.N(o)
q=A.au(o)
p=t.n.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.eB(p)
m=l.b
m.c=new A.O(p,n)
p=m}p.b=!0}},
$S:0}
A.cF.prototype={}
A.b_.prototype={
gm(a){var s={},r=new A.x($.t,t.aQ)
s.a=0
this.b2(new A.di(s,this),!0,new A.dj(s,r),r.gbk())
return r}}
A.di.prototype={
$1(a){this.b.$ti.c.a(a);++this.a.a},
$S(){return this.b.$ti.h("~(1)")}}
A.dj.prototype={
$0(){var s=this.b,r=s.$ti,q=r.h("1/").a(this.a.a),p=s.P()
r.c.a(q)
s.a=8
s.c=q
A.aI(s,p)},
$S:0}
A.bI.prototype={
gt(a){return(A.bA(this.a)^892482866)>>>0},
F(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.b1&&b.a===this.a}}
A.bJ.prototype={
al(){A.K(this.w).h("b0<1>").a(this)},
am(){A.K(this.w).h("b0<1>").a(this)}}
A.ad.prototype={
aI(a){var s,r=this,q=A.K(r)
q.c.a(a)
s=r.e
if((s&8)!==0)return
if(s<64)r.a3(a)
else r.bh(new A.bK(a,q.h("bK<1>")))},
al(){},
am(){},
bh(a){var s,r,q=this,p=q.r
if(p==null)p=q.r=new A.cJ(A.K(q).h("cJ<1>"))
s=p.c
if(s==null)p.b=p.c=a
else p.c=s.a=a
r=q.e
if((r&128)===0){r|=128
q.e=r
if(r<256)p.aD(q)}},
a3(a){var s,r=this,q=A.K(r).c
q.a(a)
s=r.e
r.e=s|64
r.d.bX(r.a,a,q)
r.e&=4294967231
r.bj((s&4)!==0)},
bj(a){var s,r,q=this,p=q.e
if((p&128)!==0&&q.r.c==null){p=q.e=p&4294967167
s=!1
if((p&4)!==0)if(p<256){s=q.r
s=s==null?null:s.c==null
s=s!==!1}if(s){p&=4294967291
q.e=p}}for(;;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=p^64
if(r)q.al()
else q.am()
p=q.e&=4294967231}if((p&128)!==0&&p<256)q.r.aD(q)},
$ib0:1,
$iaq:1}
A.b5.prototype={
b2(a,b,c,d){var s=this.$ti
s.h("~(1)?").a(a)
t.Y.a(c)
return this.a.by(s.h("~(1)?").a(a),d,c,b===!0)},
bR(a){return this.b2(a,null,null,null)}}
A.bL.prototype={}
A.bK.prototype={}
A.cJ.prototype={
aD(a){var s,r=this
r.$ti.h("aq<1>").a(a)
s=r.a
if(s===1)return
if(s>=1){r.a=1
return}A.h5(new A.dK(r,a))
r.a=1}}
A.dK.prototype={
$0(){var s,r,q,p=this.a,o=p.a
p.a=0
if(o===3)return
s=p.$ti.h("aq<1>").a(this.b)
r=p.b
q=r.a
p.b=q
if(q==null)p.c=null
A.K(r).h("aq<1>").a(s).a3(r.b)},
$S:0}
A.b3.prototype={
bt(){var s,r=this,q=r.a-1
if(q===0){r.a=-1
s=r.c
if(s!=null){r.c=null
r.b.b6(s)}}else r.a=q},
$ib0:1}
A.cL.prototype={}
A.bZ.prototype={$ifq:1}
A.cK.prototype={
b6(a){var s,r,q
t.M.a(a)
try{if(B.i===$.t){a.$0()
return}A.fR(null,null,this,a,t.H)}catch(q){s=A.N(q)
r=A.au(q)
A.cP(A.J(s),t.l.a(r))}},
bX(a,b,c){var s,r,q
c.h("~(0)").a(a)
c.a(b)
try{if(B.i===$.t){a.$1(b)
return}A.fS(null,null,this,a,b,t.H,c)}catch(q){s=A.N(q)
r=A.au(q)
A.cP(A.J(s),t.l.a(r))}},
aX(a){return new A.dL(this,t.M.a(a))},
j(a,b){return null},
bV(a,b){b.h("0()").a(a)
if($.t===B.i)return a.$0()
return A.fR(null,null,this,a,b)},
az(a,b,c,d){c.h("@<0>").l(d).h("1(2)").a(a)
d.a(b)
if($.t===B.i)return a.$1(b)
return A.fS(null,null,this,a,b,c,d)},
bW(a,b,c,d,e,f){d.h("@<0>").l(e).l(f).h("1(2,3)").a(a)
e.a(b)
f.a(c)
if($.t===B.i)return a.$2(b,c)
return A.iZ(null,null,this,a,b,c,d,e,f)},
aw(a,b,c,d){return b.h("@<0>").l(c).l(d).h("1(2,3)").a(a)}}
A.dL.prototype={
$0(){return this.a.b6(this.b)},
$S:0}
A.dX.prototype={
$0(){A.hz(this.a,this.b)},
$S:0}
A.bM.prototype={
gm(a){return this.a},
ga9(){return new A.bN(this,this.$ti.h("bN<1>"))},
a6(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.bn(a)},
bn(a){var s=this.d
if(s==null)return!1
return this.ah(this.aN(s,a),a)>=0},
j(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.ft(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.ft(q,b)
return r}else return this.bp(b)},
bp(a){var s,r,q=this.d
if(q==null)return null
s=this.aN(q,a)
r=this.ah(s,a)
return r<0?null:s[r+1]},
v(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.aJ(s==null?m.b=A.eI():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.aJ(r==null?m.c=A.eI():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.eI()
p=A.eo(b)&1073741823
o=q[p]
if(o==null){A.eJ(q,p,[b,c]);++m.a
m.e=null}else{n=m.ah(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
ar(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.h("~(1,2)").a(b)
s=m.aP()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.j(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.d(A.bg(m))}},
aP(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.f9(i.a,null,!1,t.z)
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
aJ(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.eJ(a,b,c)},
aN(a,b){return a[A.eo(b)&1073741823]}}
A.b4.prototype={
ah(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.bN.prototype={
gm(a){return this.a.a},
gA(a){var s=this.a
return new A.bO(s,s.aP(),this.$ti.h("bO<1>"))}}
A.bO.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.d(A.bg(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$ia4:1}
A.u.prototype={
gA(a){return new A.aB(a,a.length,A.bb(a).h("aB<u.E>"))},
T(a,b){if(!(b>=0&&b<a.length))return A.e(a,b)
return a[b]},
V(a,b,c){var s=A.bb(a)
return new A.a9(a,s.l(c).h("1(u.E)").a(b),s.h("@<u.E>").l(c).h("a9<1,2>"))},
k(a){return A.d7(a,"[","]")}}
A.aD.prototype={
ar(a,b){var s,r,q,p=A.K(this)
p.h("~(1,2)").a(b)
for(s=this.ga9(),s=s.gA(s),p=p.y[1];s.p();){r=s.gn()
q=this.j(0,r)
b.$2(r,q==null?p.a(q):q)}},
gm(a){var s=this.ga9()
return s.gm(s)},
k(a){return A.fb(this)},
$ibr:1}
A.dd.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.c(a)
r.a=(r.a+=s)+": "
s=A.c(b)
r.a+=s},
$S:20}
A.c5.prototype={}
A.cV.prototype={
I(a){var s
t.L.a(a)
s=a.length
if(s===0)return""
s=new A.dv("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/").bI(a,0,s,!0)
s.toString
return A.hU(s)}}
A.dv.prototype={
bI(a,b,c,d){var s,r,q,p,o
t.L.a(a)
s=this.a
r=(s&3)+(c-b)
q=B.h.bz(r,3)
p=q*4
if(r-q*3>0)p+=4
o=new Uint8Array(p)
this.a=A.i3(this.b,a,b,c,!0,o,0,s)
if(p>0)return o
return null}}
A.cU.prototype={
I(a){var s,r,q,p=A.fi(0,null,a.length)
if(0===p)return new Uint8Array(0)
s=new A.du()
r=s.bE(a,0,p)
r.toString
q=s.a
if(q<-1)A.X(A.aS("Missing padding character",a,p))
if(q>0)A.X(A.aS("Invalid length, must be multiple of four",a,p))
s.a=-1
return r}}
A.du.prototype={
bE(a,b,c){var s,r=this,q=r.a
if(q<0){r.a=A.fr(a,b,c,q)
return null}if(b===c)return new Uint8Array(0)
s=A.i0(a,b,c,q)
r.a=A.i2(a,b,c,s,0,r.a)
return s}}
A.aw.prototype={}
A.c9.prototype={}
A.ca.prototype={
F(a,b){if(b==null)return!1
return b instanceof A.ca&&this.a===b.a&&this.b===b.b&&this.c===b.c},
gt(a){return A.hH(this.a,this.b)},
k(a){var s=this,r=A.hx(A.hP(s)),q=A.cb(A.hN(s)),p=A.cb(A.hJ(s)),o=A.cb(A.hK(s)),n=A.cb(A.hM(s)),m=A.cb(A.hO(s)),l=A.f5(A.hL(s)),k=s.b,j=k===0?"":A.f5(k)
k=r+"-"+q
if(s.c)return k+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"
else return k+"-"+p+" "+o+":"+n+":"+m+"."+l+j}}
A.dw.prototype={
k(a){return this.aQ()}}
A.w.prototype={
gO(){return A.hI(this)}}
A.c3.prototype={
k(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.cY(s)
return"Assertion failed"}}
A.ab.prototype={}
A.a_.prototype={
gag(){return"Invalid argument"+(!this.a?"(s)":"")},
gaf(){return""},
k(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.c(p),n=s.gag()+q+o
if(!s.a)return n
return n+s.gaf()+": "+A.cY(s.gau())},
gau(){return this.b}}
A.aZ.prototype={
gau(){return A.fG(this.b)},
gag(){return"RangeError"},
gaf(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.c(q):""
else if(q==null)s=": Not greater than or equal to "+A.c(r)
else if(q>r)s=": Not in inclusive range "+A.c(r)+".."+A.c(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.c(r)
return s}}
A.cc.prototype={
gau(){return A.n(this.b)},
gag(){return"RangeError"},
gaf(){if(A.n(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gm(a){return this.f}}
A.bE.prototype={
k(a){return"Unsupported operation: "+this.a}}
A.cC.prototype={
k(a){return"UnimplementedError: "+this.a}}
A.aE.prototype={
k(a){return"Bad state: "+this.a}}
A.c8.prototype={
k(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.cY(s)+"."}}
A.cs.prototype={
k(a){return"Out of Memory"},
gO(){return null},
$iw:1}
A.bC.prototype={
k(a){return"Stack Overflow"},
gO(){return null},
$iw:1}
A.dx.prototype={
k(a){return"Exception: "+this.a}}
A.d0.prototype={
k(a){var s,r,q,p,o,n,m,l,k,j,i=this.a,h=""!==i?"FormatException: "+i:"FormatException",g=this.c,f=this.b,e=g<0||g>f.length
if(e)g=null
if(g==null){if(f.length>78)f=B.l.Z(f,0,75)+"..."
return h+"\n"+f}for(s=f.length,r=1,q=0,p=!1,o=0;o<g;++o){if(!(o<s))return A.e(f,o)
n=f.charCodeAt(o)
if(n===10){if(q!==o||!p)++r
q=o+1
p=!1}else if(n===13){++r
q=o+1
p=!0}}h=r>1?h+(" (at line "+r+", character "+(g-q+1)+")\n"):h+(" (at character "+(g+1)+")\n")
for(o=g;o<s;++o){if(!(o>=0))return A.e(f,o)
n=f.charCodeAt(o)
if(n===10||n===13){s=o
break}}m=""
if(s-q>78){l="..."
if(g-q<75){k=q+75
j=q}else{if(s-g<75){j=s-75
k=s
l=""}else{j=g-36
k=g+36}m="..."}}else{k=s
j=q
l=""}return h+m+B.l.Z(f,j,k)+l+"\n"+B.l.aC(" ",g-j+m.length)+"^\n"}}
A.f.prototype={
V(a,b,c){var s=A.K(this)
return A.hF(this,s.l(c).h("1(f.E)").a(b),s.h("f.E"),c)},
gm(a){var s,r=this.gA(this)
for(s=0;r.p();)++s
return s},
T(a,b){var s,r
A.fh(b,"index")
s=this.gA(this)
for(r=b;s.p();){if(r===0)return s.gn();--r}throw A.d(A.f6(b,b-r,this,"index"))},
k(a){return A.hA(this,"(",")")}}
A.y.prototype={
gt(a){return A.k.prototype.gt.call(this,0)},
k(a){return"null"}}
A.k.prototype={$ik:1,
F(a,b){return this===b},
gt(a){return A.bA(this)},
k(a){return"Instance of '"+A.cv(this)+"'"},
gq(a){return A.jk(this)},
toString(){return this.k(this)}}
A.cM.prototype={
k(a){return""},
$ia3:1}
A.cz.prototype={
gm(a){return this.a.length},
k(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.de.prototype={
k(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.ec.prototype={
$1(a){var s,r,q,p
if(A.fQ(a))return a
s=this.a
if(s.a6(a))return s.j(0,a)
if(t.f.b(a)){r={}
s.v(0,a,r)
for(s=a.ga9(),s=s.gA(s);s.p();){q=s.gn()
r[q]=this.$1(a.j(0,q))}return r}else if(t.R.b(a)){p=[]
s.v(0,a,p)
B.d.bC(p,J.ho(a,this,t.z))
return p}else return a},
$S:8}
A.ep.prototype={
$1(a){return this.a.ao(this.b.h("0/?").a(a))},
$S:3}
A.eq.prototype={
$1(a){if(a==null)return this.a.aY(new A.de(a===undefined))
return this.a.aY(a)},
$S:3}
A.e_.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(A.fP(a))return a
s=this.a
a.toString
if(s.a6(a))return s.j(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.X(A.aa(r,-864e13,864e13,"millisecondsSinceEpoch",null))
A.dZ(!0,"isUtc",t.y)
return new A.ca(r,0,!0)}if(a instanceof RegExp)throw A.d(A.aj("structured clone of RegExp",null))
if(a instanceof Promise)return A.ag(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.bq(p,p)
s.v(0,a,o)
n=Object.keys(a)
m=[]
for(s=n.length,l=0;l<n.length;n.length===s||(0,A.c2)(n),++l)m.push(A.fZ(n[l]))
for(k=0;k<n.length;++k){j=n[k]
if(!(k<m.length))return A.e(m,k)
i=m[k]
if(j!=null)o.v(0,i,this.$1(a[j]))}return o}if(a instanceof Array){h=a
o=[]
s.v(0,a,o)
g=A.n(a.length)
for(k=0;k<g;++k){if(!(k<h.length))return A.e(h,k)
o.push(this.$1(h[k]))}return o}return a},
$S:8}
A.dI.prototype={
bf(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.d(A.bF("No source of cryptographically secure random numbers available."))},
av(a){var s,r,q,p,o,n,m,l,k=null
if(a<=0||a>4294967296)throw A.d(new A.aZ(k,k,!1,k,k,"max must be in range 0 < max \u2264 2^32, was "+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.Y(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.n(Math.pow(256,s))
for(o=a-1,n=(a&o)>>>0===0;;){crypto.getRandomValues(J.f_(B.r.gH(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}}}
A.an.prototype={
F(a,b){if(b==null)return!1
return b instanceof A.an&&this.b===b.b},
gt(a){return this.b},
k(a){return this.a}}
A.aC.prototype={
k(a){return"["+this.a.a+"] "+this.d+": "+this.b}}
A.aX.prototype={
gb0(){var s=this.b,r=s==null?null:s.a.length!==0,q=this.a
return r===!0?s.gb0()+"."+q:q},
gbQ(){var s,r
if(this.b==null){s=this.c
s.toString
r=s}else{s=$.cR().c
s.toString
r=s}return r},
i(a,b,c,d){var s,r=this,q=a.b
if(q>=r.gbQ().b){if(q>=2000){A.fk()
a.k(0)}q=r.gb0()
Date.now()
$.fa=$.fa+1
s=new A.aC(a,b,q)
if(r.b==null)r.aU(s)
else $.cR().aU(s)}},
aR(){if(this.b==null){var s=this.f
if(s==null)s=this.f=new A.bU(null,null,t.W)
return new A.b1(s,A.K(s).h("b1<1>"))}else return $.cR().aR()},
aU(a){var s=this.f
if(s!=null){A.K(s).c.a(a)
if(!s.gai())A.X(s.ab())
s.a3(a)}return null}}
A.dc.prototype={
$0(){var s,r,q,p=this.a
if(B.l.bc(p,"."))A.X(A.aj("name shouldn't start with a '.'",null))
if(B.l.bM(p,"."))A.X(A.aj("name shouldn't end with a '.'",null))
s=B.l.bP(p,".")
if(s===-1)r=p!==""?A.db(""):null
else{r=A.db(B.l.Z(p,0,s))
p=B.l.aG(p,s+1)}q=new A.aX(p,r,A.bq(t.N,t.I))
if(r==null)q.c=B.f
else r.d.v(0,p,q)
return q},
$S:21}
A.ai.prototype={
aQ(){return"Algorithm."+this.b}}
A.bi.prototype={}
A.ax.prototype={
a8(a,b){return this.bL(a,b)},
bL(a1,a2){var s=0,r=A.F(t.a5),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$a8=A.G(function(a3,a4){if(a3===1){o.push(a4)
s=p}for(;;)switch(s){case 0:c=$.v()
b=""+a2.length
c.i(B.j,"encodeFunction: buffer "+b,null,null)
h=n.d.K(0)
m=h==null?null:h.b
l=0
if(m==null){c.i(B.b,"encodeFunction: no secretKey for index "+A.c(l)+", cannot encrypt",null,null)
q=null
s=1
break}h=Date.now()
g=new DataView(new ArrayBuffer(12))
f=n.a
if(f===-1)f=n.a=$.eu().av(65535)
g.setUint32(0,$.eu().av(Math.max(0,4294967295))>>>0,!1)
g.setUint32(4,h,!1)
g.setUint32(8,h-B.h.aa(f,65535),!1)
n.a=f+1
k=J.ew(B.r.gH(g))
e=new DataView(new ArrayBuffer(2))
e.setInt8(0,12)
e.setInt8(1,A.n(l))
p=4
h=A.b(A.b(n.f.crypto).subtle)
f=A.h(A.j(["name","AES-GCM","iv",k],t.N,t.K))
if(f==null)f=A.J(f)
a0=t.a
s=7
return A.m(A.ag(A.b(h.encrypt(f,m,a2)),t.X),$async$a8)
case 7:j=a0.a(a4)
c.i(B.c,"encodeFunction: encrypted buffer: "+b+", cipherText: "+A.I(j,0,null).length,null,null)
b=A.I(j,0,null)
q=new A.bi(b,l,k)
s=1
break
p=2
s=6
break
case 4:p=3
a=o.pop()
i=A.N(a)
$.v().i(B.b,"encodeFunction encrypt: e "+J.T(i),null,null)
throw a
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$a8,r)},
S(a,b){return this.bH(a,b)},
bH(a4,a5){var s=0,r=A.F(t.E),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3
var $async$S=A.G(function(a6,a7){if(a6===1){o.push(a7)
s=p}for(;;)switch(s){case 0:a1={}
a1.a=0
e=$.v()
d=a5.a
e.i(B.j,"decodeFunction: data packet length "+d.length,null,null)
a1.b=a1.c=null
m=0
p=4
c={}
b=a5.c
l=b.length
k=a5.b
j=b
i=d
a=a1.b=n.d.K(m)
e.i(B.c,"decodeFunction: start decrypting data packet length "+J.aQ(i)+", ivLength "+A.c(l)+", keyIndex "+A.c(k)+", iv "+A.c(j),null,null)
if(a==null||!n.d.c){q=null
s=1
break}c.a=a
h=new A.cW(a1,c,n,j,i,m)
g=new A.cX(a1,c,n,h)
p=8
s=11
return A.m(h.$0(),$async$S)
case 11:p=4
s=10
break
case 8:p=7
a2=o.pop()
f=A.N(a2)
e=$.v()
e.i(B.c,"decodeFunction: kInternalError catch "+A.c(f),null,null)
s=12
return A.m(g.$0(),$async$S)
case 12:s=10
break
case 7:s=4
break
case 10:d=a1.c
if(d==null){a1=A.U(u.r)
throw A.d(a1)}c=n.d
c.r=0
c.c=!0
e.i(B.c,u.f+J.aQ(i)+", decrypted: "+A.I(d,0,null).length,null,null)
a1=a1.c
a1.toString
a1=A.I(a1,0,null)
q=a1
s=1
break
p=2
s=6
break
case 4:p=3
a3=o.pop()
n.d.aZ()
throw a3
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$S,r)}}
A.cW.prototype={
$0(){var s=0,r=A.F(t.H),q=this,p,o,n,m,l,k,j
var $async$$0=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:m=q.c
l=A.b(A.b(m.f.crypto).subtle)
k=A.h(A.j(["name","AES-GCM","iv",q.d],t.N,t.K))
if(k==null)k=A.J(k)
p=q.b
j=t.a
s=2
return A.m(A.ag(A.b(l.decrypt(k,p.a.b,q.e)),t.X),$async$$0)
case 2:o=j.a(b)
k=q.a
k.c=o
l=$.v()
l.i(B.c,u.D+A.I(o,0,null).length,null,null)
n=k.c
if(n==null)throw A.d(A.U("[decryptFrameInternal] could not decrypt"))
l.i(B.c,u.D+A.I(n,0,null).length,null,null)
s=p.a!==k.b?3:4
break
case 3:l.i(B.j,u.E,null,null)
s=5
return A.m(m.d.L(p.a,q.f),$async$$0)
case 5:case 4:return A.D(null,r)}})
return A.E($async$$0,r)},
$S:2}
A.cX.prototype={
$0(){var s=0,r=A.F(t.H),q=this,p,o,n,m,l,k,j,i,h
var $async$$0=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:n=q.a
m=n.a
l=q.c
k=l.d
j=k.d
i=j.c
if(m>=i||i<=0)throw A.d(A.U(u.w))
m=q.b
s=2
return A.m(k.M(m.a.a,j.b),$async$$0)
case 2:p=b
s=3
return A.m(l.d.N(m.a.a,J.ex(p)),$async$$0)
case 3:o=b
l=l.d
h=m
s=4
return A.m(l.J(o,l.d.b),$async$$0)
case 4:h.a=b;++n.a
s=5
return A.m(q.d.$0(),$async$$0)
case 5:return A.D(null,r)}})
return A.E($async$$0,r)},
$S:2}
A.a0.prototype={
aQ(){return"CryptorError."+this.b}}
A.d3.prototype={}
A.al.prototype={
gb_(){if(this.b==null)return!1
return this.r},
Y(a,b,c,d,e,f,g){return this.bb(a,b,c,d,e,f,g)},
ba(a,b,c,d,e,f){return this.Y(null,a,b,c,d,e,f)},
bb(a,b,c,d,e,f,g){var s=0,r=A.F(t.H),q,p=this,o,n,m,l,k,j
var $async$Y=A.G(function(h,a0){if(h===1)return A.C(a0,r)
for(;;)switch(s){case 0:j=$.v()
j.i(B.f,"setupTransform "+d+" kind "+c,null,null)
p.f=c
if(a!=null){j.i(B.f,"setting codec on cryptor to "+a,null,null)
p.d=a}if(b&&p.w){j.i(B.f,"setupTransform: transform already active, skipping setup",null,null)
s=1
break}j=v.G.TransformStream
m=d==="encode"?A.fK(p.gbJ()):A.fK(p.gbF())
l=t.N
o=A.b(new j(A.b(A.h(A.j(["transform",m],l,t.g)))))
try{A.b(A.b(e.pipeThrough(o)).pipeTo(g))}catch(i){n=A.N(i)
$.v().i(B.b,"e "+J.T(n),null,null)
if(p.x!==B.q){p.x=B.q
p.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",p.b,"state","internalError","error","Internal error: "+J.T(n)],l,t.T)))}}p.w=!0
p.c=f
case 1:return A.D(q,r)}})
return A.E($async$Y,r)},
aB(a,b){var s,r,q,p,o,n,m=this,l=null,k="Unsupported codec for track ",j=""
if(A.eD(a,"RTCEncodedVideoFrame")){s=A.I(t.a.a(a.data),0,l)
if("type" in a){j=A.i(a.type)
$.v().i(B.c,"frameType: "+j,l,l)}}else s=l
r=A.M(["h264","h265"],t.s)
q=b==null?l:b.toLowerCase()
if(B.d.bD(r,q==null?"":q)){if(s==null)throw A.d(A.cx("Frame data is null for codec "+A.c(b)))
b.toString
p=A.jx(s,b)
r=p.b
if(r==="unknown"){if(m.x!==B.z){m.x=B.z
q=m.b
o=m.c
n=m.f
n===$&&A.ah("kind")
m.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",q,"trackId",o,"kind",n,"state","unsupportedCodec","error",k+o+", detected codec "+r],t.N,t.T)))}throw A.d(A.U(k+m.c))}return p.a}switch(j){case"key":return 10
case"delta":return 3
case"audio":return 1
default:return 0}},
b3(a){var s,r,q,p,o,n=null
new Uint8Array(0)
if(A.eD(a,"RTCEncodedVideoFrame")){s=A.I(t.a.a(a.data),0,n)
if("type" in a){r=A.i(a.type)
$.v().i(B.c,"frameType: "+r,n,n)}else r=""
q=A.b(a.getMetadata())
p=A.n(q.synchronizationSource)
if("rtpTimestamp" in q)o=B.h.b8(A.n(q.rtpTimestamp))
else o="timestamp" in a?A.n(A.eM(a.timestamp)):0}else{if(A.eD(a,"RTCEncodedAudioFrame")){s=A.I(t.a.a(a.data),0,n)
q=A.b(a.getMetadata())
p=A.n(q.synchronizationSource)
if("rtpTimestamp" in q)o=B.h.b8(A.n(q.rtpTimestamp))
else o="timestamp" in a?A.n(A.eM(a.timestamp)):0}else throw A.d(A.U("encodeFunction: frame is not a RTCEncodedVideoFrame or RTCEncodedAudioFrame"))
r="audio"}return new A.d3(r,p,o,s)},
aq(a,b,c){a.data=t.a.a(B.e.gH(c.aA()))
b.enqueue(a)},
a7(a,b){return this.bK(A.b(a),A.b(b))},
bK(a6,a7){var s=0,r=A.F(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5
var $async$a7=A.G(function(a8,a9){if(a8===1){o.push(a9)
s=p}for(;;)switch(s){case 0:p=4
d=!0
if(n.gb_()){c=t.a
b=c.a(a6.data)
if(!(b.byteLength===0)){d=c.a(a6.data)
d=d.byteLength===0}}if(d){if(n.e.d.r){s=1
break}a7.enqueue(a6)
s=1
break}m=n.b3(a6)
d=$.v()
d.i(B.j,"encodeFunction: buffer "+m.d.length+", synchronizationSource "+m.b+" frameType "+m.a,null,null)
c=n.e.K(n.y)
l=c==null?null:c.b
k=n.y
if(l==null){if(n.x!==B.p){n.x=B.p
d=n.b
c=n.c
b=n.f
b===$&&A.ah("kind")
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",d,"trackId",c,"kind",b,"state","missingKey","error","Missing key for track "+c],t.N,t.T)))}s=1
break}c=n.f
c===$&&A.ah("kind")
j=c==="video"?n.aB(a6,n.d):1
b=m.b
a=m.c
a0=new DataView(new ArrayBuffer(12))
c=n.a
if(c.j(0,b)==null)c.v(0,b,$.eu().av(65535))
a1=c.j(0,b)
if(a1==null)a1=0
a0.setUint32(0,b,!1)
a0.setUint32(4,a,!1)
a0.setUint32(8,a-B.h.aa(a1,65535),!1)
c.v(0,b,a1+1)
i=J.ew(B.r.gH(a0))
h=new DataView(new ArrayBuffer(2))
c=h
c.$flags&2&&A.Y(c,6)
J.eZ(c,0,12)
c=h
b=A.n(k)
c.$flags&2&&A.Y(c,6)
J.eZ(c,1,b)
b=n.z
c=A.b(A.b(b.crypto).subtle)
a=t.N
a2=A.h(A.j(["name","AES-GCM","iv",i,"additionalData",B.e.B(m.d,0,j)],a,t.K))
if(a2==null)a2=A.J(a2)
a5=t.a
s=7
return A.m(A.ag(A.b(c.encrypt(a2,l,B.e.B(m.d,j,m.d.length))),t.X),$async$a7)
case 7:g=a5.a(a9)
d.i(B.c,"encodeFunction: encrypted buffer: "+m.d.length+", cipherText: "+A.I(g,0,null).length,null,null)
c=$.cS()
f=new A.b2(c)
J.bd(f,new Uint8Array(A.as(B.e.B(m.d,0,j))))
J.bd(f,A.I(g,0,null))
J.bd(f,i)
J.bd(f,J.ew(J.ex(h)))
n.aq(a6,a7,f)
if(n.x!==B.k){n.x=B.k
b.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",n.b,"trackId",n.c,"kind",n.f,"state","ok","error","encryption ok"],a,t.T)))}d.i(B.c,"encodeFunction[CryptorError.kOk]: frame enqueued kind "+n.f+",codec "+A.c(n.d)+" headerLength: "+A.c(j)+",  timestamp: "+m.c+", ssrc: "+m.b+", data length: "+m.d.length+", encrypted length: "+f.aA().length+", iv "+A.c(i),null,null)
p=2
s=6
break
case 4:p=3
a4=o.pop()
e=A.N(a4)
$.v().i(B.b,"encodeFunction encrypt: e "+J.T(e),null,null)
if(n.x!==B.y){n.x=B.y
d=n.b
c=n.c
b=n.f
b===$&&A.ah("kind")
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",d,"trackId",c,"kind",b,"state","encryptError","error",J.T(e)],t.N,t.T)))}s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$a7,r)},
R(a,b){return this.bG(A.b(a),A.b(b))},
bG(b1,b2){var s=0,r=A.F(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0
var $async$R=A.G(function(b3,b4){if(b3===1){o.push(b4)
s=p}for(;;)switch(s){case 0:a7={}
a8=n.b3(b1)
a7.a=0
b=$.v()
b.i(B.j,"decodeFunction: frame length "+a8.d.length,null,null)
a7.b=a7.c=null
a7.d=n.y
if(!n.gb_()||a8.d.length===0){n.Q.b4()
if(n.e.d.r){s=1
break}b.i(B.j,"enqueuing empty dtx frame",null,null)
b2.enqueue(b1)
s=1
break}a=n.e.d.e
if(a!=null){a0=a8.d
a1=a.length
a2=a1+1
if(a0.length>a2){a3=B.e.B(a8.d,a8.d.length-a1,a8.d.length)
b.i(B.c,"magicBytesBuffer "+A.c(a3)+", magicBytes "+A.c(a),null,null)
a0=n.Q
if(A.d7(a3,"[","]")===A.d7(a,"[","]")){++a0.a
if(a0.b==null)a0.b=Date.now()
a0.c=Date.now()
if(a0.a<100)if(a0.b!=null){a7=Date.now()
a0=a0.b
a0.toString
a0=a7-a0<2000
a7=a0}else a7=!0
else a7=!1
if(a7){a7=B.e.aF(a8.d,a8.d.length-1)
if(0>=a7.length){q=A.e(a7,0)
s=1
break}b.i(B.c,"decodeFunction: skip unencrypted frame, type "+a7[0],null,null)
e=new A.b2($.cS())
e.u(0,new Uint8Array(A.as(B.e.B(a8.d,0,a8.d.length-a2))))
b.i(B.j,"decodeFunction: enqueuing silent frame src: "+A.c(a8.d),null,null)
n.aq(b1,b2,e)
b.i(B.j,"decodeFunction: enqueuing done",null,null)
s=1
break}else{b.i(B.b,"decodeFunction: SIF limit reached, dropping frame",null,null)
s=1
break}}else a0.b4()}}p=4
a={}
a0=n.f
a0===$&&A.ah("kind")
m=a0==="video"?n.aB(b1,n.d):1
l=B.e.aF(a8.d,a8.d.length-2)
k=J.eY(l,0)
j=J.eY(l,1)
a1=a8.d
a2=a8.d
a4=k
if(typeof a4!=="number"){q=A.jm(a4)
s=1
break}i=B.e.B(a1,a2.length-a4-2,a8.d.length-2)
a5=a7.b=n.e.K(j)
a7.d=j
b.i(B.c,"decodeFunction: start decrypting frame headerLength "+A.c(m)+" "+a8.d.length+" frameTrailer "+A.c(l)+", ivLength "+A.c(k)+", keyIndex "+A.c(j)+", iv "+A.c(i),null,null)
if(a5==null||!n.e.c){if(n.x!==B.p){n.x=B.p
a7=n.b
b=n.c
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",a7,"trackId",b,"kind",n.f,"state","missingKey","error","Missing key for track "+b],t.N,t.T)))}s=1
break}a.a=a5
h=new A.d1(a7,a,n,i,a8,m,k)
g=new A.d2(a7,a,n,h)
p=8
s=11
return A.m(h.$0(),$async$R)
case 11:p=4
s=10
break
case 8:p=7
a9=o.pop()
f=A.N(a9)
n.x=B.q
b=$.v()
b.i(B.c,"decodeFunction: kInternalError catch "+A.c(f),null,null)
s=12
return A.m(g.$0(),$async$R)
case 12:s=10
break
case 7:s=4
break
case 10:a=a7.c
if(a==null){a7=A.U(u.r)
throw A.d(a7)}a0=n.e
a0.r=0
a0.c=!0
b.i(B.c,u.f+a8.d.length+", decrypted: "+A.I(a,0,null).length,null,null)
a=$.cS()
e=new A.b2(a)
J.bd(e,new Uint8Array(A.as(B.e.B(a8.d,0,m))))
a7=a7.c
a7.toString
J.bd(e,A.I(a7,0,null))
n.aq(b1,b2,e)
if(n.x!==B.k){n.x=B.k
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",n.b,"trackId",n.c,"kind",n.f,"state","ok","error","decryption ok"],t.N,t.T)))}b.i(B.j,"decodeFunction[CryptorError.kOk]: decryption success kind "+n.f+", headerLength: "+A.c(m)+", timestamp: "+a8.c+", ssrc: "+a8.b+", data length: "+a8.d.length+", decrypted length: "+e.aA().length+", keyindex "+A.c(j)+" iv "+A.c(i),null,null)
p=2
s=6
break
case 4:p=3
b0=o.pop()
d=A.N(b0)
c=A.au(b0)
$.v().i(B.b,"decodeFunction[CryptorError.kDecryptError]: "+A.c(d)+", "+A.c(c),null,null)
if(n.x!==B.x){n.x=B.x
a7=n.b
b=n.c
a=n.f
a===$&&A.ah("kind")
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",a7,"trackId",b,"kind",a,"state","decryptError","error",J.T(d)],t.N,t.T)))}n.e.aZ()
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$R,r)}}
A.d1.prototype={
$0(){var s=0,r=A.F(t.H),q=this,p,o,n,m,l,k,j,i,h,g,f
var $async$$0=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:n=q.c
m=n.z
l=A.b(A.b(m.crypto).subtle)
k=q.e
j=k.d
i=q.f
h=t.N
g=A.h(A.j(["name","AES-GCM","iv",q.d,"additionalData",B.e.B(j,0,i)],h,t.K))
if(g==null)g=A.J(g)
p=q.b
f=t.a
s=2
return A.m(A.ag(A.b(l.decrypt(g,p.a.b,B.e.B(j,i,j.length-q.r-2))),t.X),$async$$0)
case 2:o=f.a(b)
j=q.a
j.c=o
i=$.v()
i.i(B.c,u.D+A.I(o,0,null).length,null,null)
l=j.c
if(l==null)throw A.d(A.U("[decryptFrameInternal] could not decrypt"))
i.i(B.c,u.D+A.I(l,0,null).length,null,null)
s=p.a!==j.b?3:4
break
case 3:i.i(B.j,u.E,null,null)
s=5
return A.m(n.e.L(p.a,j.d),$async$$0)
case 5:case 4:l=n.x
if(l!==B.k&&l!==B.A&&j.a>0){i.i(B.c,"decodeFunction::decryptFrameInternal: KeyRatcheted: ssrc "+k.b+" timestamp "+k.c+" ratchetCount "+j.a+"  participantId: "+A.c(n.b),null,null)
i.i(B.c,"decodeFunction::decryptFrameInternal: ratchetKey: lastError != CryptorError.kKeyRatcheted, reset state to kKeyRatcheted",null,null)
n.x=B.A
l=n.b
k=n.c
n=n.f
n===$&&A.ah("kind")
m.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",l,"trackId",k,"kind",n,"state","keyRatcheted","error","Key ratcheted ok"],h,t.T)))}return A.D(null,r)}})
return A.E($async$$0,r)},
$S:2}
A.d2.prototype={
$0(){var s=0,r=A.F(t.H),q=this,p,o,n,m,l,k,j,i,h
var $async$$0=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:n=q.a
m=n.a
l=q.c
k=l.e
j=k.d
i=j.c
if(m>=i||i<=0)throw A.d(A.U(u.w))
m=q.b
s=2
return A.m(k.M(m.a.a,j.b),$async$$0)
case 2:p=b
s=3
return A.m(l.e.N(m.a.a,J.ex(p)),$async$$0)
case 3:o=b
l=l.e
h=m
s=4
return A.m(l.J(o,l.d.b),$async$$0)
case 4:h.a=b;++n.a
s=5
return A.m(q.d.$0(),$async$$0)
case 5:return A.D(null,r)}})
return A.E($async$$0,r)},
$S:2}
A.d9.prototype={
k(a){var s=this
return"KeyOptions{sharedKey: "+s.a+", ratchetWindowSize: "+s.c+", failureTolerance: "+s.d+", uncryptedMagicBytes: "+A.c(s.e)+", ratchetSalt: "+A.c(s.b)+"}"}}
A.cj.prototype={
G(a){var s,r,q=this,p=q.c
if(p.a)return q.W()
s=q.d
r=s.j(0,a)
if(r==null){r=A.fd(p,a,q.a)
p=q.f
if(p.length!==0)r.b9(p)
s.v(0,a,r)}return r},
W(){var s=this,r=s.e
return r==null?s.e=A.fd(s.c,"shared-key",s.a):r},
X(a,b){var s=0,r=A.F(t.H),q=this
var $async$X=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:$.v().i(B.f,"setting shared key",null,null)
q.f=a
s=2
return A.m(q.W().D(a,b),$async$X)
case 2:return A.D(null,r)}})
return A.E($async$X,r)}}
A.aW.prototype={}
A.ct.prototype={
aZ(){var s=this,r=s.d.d
if(r<0)return
if(++s.r>r){$.v().i(B.b,"key for "+s.f+" is being marked as invalid",null,null)
s.c=!1}},
U(a){var s=0,r=A.F(t.E),q,p=2,o=[],n=this,m,l,k,j,i,h,g
var $async$U=A.G(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:j=n.K(a)
i=j==null?null:j.a
if(i==null){q=null
s=1
break}p=4
g=t.a
s=7
return A.m(A.ag(A.b(A.b(A.b(n.e.crypto).subtle).exportKey("raw",i)),t.X),$async$U)
case 7:m=g.a(c)
j=A.I(m,0,null)
q=j
s=1
break
p=2
s=6
break
case 4:p=3
h=o.pop()
l=A.N(h)
$.v().i(B.b,"exportKey: "+A.c(l),null,null)
q=null
s=1
break
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$U,r)},
E(a){var s=0,r=A.F(t.E),q,p=this,o,n,m,l
var $async$E=A.G(function(b,c){if(b===1)return A.C(c,r)
for(;;)switch(s){case 0:m=p.K(a)
l=m==null?null:m.a
if(l==null){q=null
s=1
break}m=p.d.b
s=3
return A.m(p.M(l,m),$async$E)
case 3:o=c
s=5
return A.m(p.N(l,B.e.gH(o)),$async$E)
case 5:s=4
return A.m(p.J(c,m),$async$E)
case 4:n=c
s=6
return A.m(p.L(n,a==null?p.a:a),$async$E)
case 6:q=o
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$E,r)},
N(a,b){var s=0,r=A.F(t.m),q,p=this,o
var $async$N=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:o=t.m
s=3
return A.m(A.ag(A.eQ(A.b(A.b(p.e.crypto).subtle),"importKey",["raw",t.a.a(b),A.J(A.b(a.algorithm).name),!1,t.c.a(A.h(A.M(["deriveBits","deriveKey"],t.s)))],o),o),$async$N)
case 3:q=d
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$N,r)},
K(a){var s,r=this.b
r===$&&A.ah("cryptoKeyRing")
s=a==null?this.a:a
if(!(s>=0&&s<r.length))return A.e(r,s)
return r[s]},
D(a,b){var s=0,r=A.F(t.H),q=this,p,o,n
var $async$D=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:o=A.b(A.b(q.e.crypto).subtle)
n=t.N
n=A.h(A.j(["name","PBKDF2"],n,n))
if(n==null)n=A.J(n)
p=t.m
s=4
return A.m(A.ag(A.eQ(o,"importKey",["raw",a,n,!1,t.c.a(A.h(A.M(["deriveBits","deriveKey"],t.s)))],p),p),$async$D)
case 4:s=3
return A.m(q.J(d,q.d.b),$async$D)
case 3:s=2
return A.m(q.L(d,b),$async$D)
case 2:q.r=0
q.c=!0
return A.D(null,r)}})
return A.E($async$D,r)},
b9(a){return this.D(a,0)},
L(a,b){var s=0,r=A.F(t.H),q=this,p
var $async$L=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:$.v().i(B.a,"setKeySetFromMaterial: set new key, index: "+b,null,null)
if(b>=0){p=q.b
p===$&&A.ah("cryptoKeyRing")
q.a=B.h.aa(b,p.length)}p=q.b
p===$&&A.ah("cryptoKeyRing")
B.d.v(p,q.a,a)
return A.D(null,r)}})
return A.E($async$L,r)},
J(a,b){var s=0,r=A.F(t.x),q,p=this,o,n,m,l,k,j,i
var $async$J=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:n=A.h_(A.i(A.b(a.algorithm).name),b)
m=A.b(A.b(p.e.crypto).subtle)
l=A.h(n)
if(l==null)l=A.J(l)
o=A.h(A.j(["name","AES-GCM","length",128],t.N,t.K))
if(o==null)o=A.J(o)
k=A
j=a
i=A
s=3
return A.m(A.ag(A.eQ(m,"deriveKey",[l,a,o,!1,t.c.a(A.h(A.M(["encrypt","decrypt"],t.s)))],t.m),t.X),$async$J)
case 3:q=new k.aW(j,i.b(d))
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$J,r)},
M(a,b){var s=0,r=A.F(t.D),q,p=this,o,n,m,l
var $async$M=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:o=A.h_("PBKDF2",b)
n=A.b(A.b(p.e.crypto).subtle)
m=A.h(o)
if(m==null)m=A.J(m)
l=A
s=3
return A.m(A.ag(A.b(n.deriveBits(m,a,256)),t.a),$async$M)
case 3:q=l.I(d,0,null)
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$M,r)}}
A.ck.prototype={}
A.dh.prototype={
b4(){var s=this
if(s.b==null)return
if(++s.d>s.a||Date.now()-s.c>2000)s.b5()},
b5(){this.a=this.d=0
this.b=null}}
A.e7.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.e1.prototype={
$1(a){return t.p.a(a).c===this.a},
$S:10}
A.er.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.es.prototype={
$1(a){return t.p.a(a).c===this.a},
$S:10}
A.ej.prototype={
$1(a){t.cH.a(a)
A.jw("["+a.d+"] "+a.a.a+": "+a.b)},
$S:22}
A.ek.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g=null
A.b(a)
s=$.v()
s.i(B.f,"Got onrtctransform event",g,g)
r=A.b(a.transformer)
r.handled=!0
q=A.b(r.options)
p=A.i(q.kind)
o=A.i(q.participantId)
n=A.i(q.trackId)
m=A.dT(q.codec)
l=A.i(q.msgType)
k=A.i(q.keyProviderId)
j=$.af.j(0,k)
if(j==null){s.i(B.b,"KeyProvider not found for "+k,g,g)
return}i=A.h2(o,n,j)
s=A.b(r.readable)
h=A.b(r.writable)
i.Y(m==null?g:m,!1,p,l,s,n,h)},
$S:11}
A.em.prototype={
$1(d2){var s=0,r=A.F(t.P),q,p=2,o=[],n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1
var $async$$1=A.G(function(d3,d4){if(d3===1){o.push(d4)
s=p}for(;;)switch(s){case 0:c6=t.f.a(A.fZ(d2.data))
c7=c6.j(0,"msgType")
c8=A.dT(c6.j(0,"msgId"))
c9=$.v()
c9.i(B.a,"Got message "+A.c(c7)+", msgId "+A.c(c8),null,null)
case 3:switch(c7){case"keyProviderInit":s=5
break
case"keyProviderDispose":s=6
break
case"enable":s=7
break
case"decode":s=8
break
case"encode":s=9
break
case"removeTransform":s=10
break
case"setKey":s=11
break
case"setSharedKey":s=12
break
case"ratchetKey":s=13
break
case"ratchetSharedKey":s=14
break
case"setKeyIndex":s=15
break
case"exportKey":s=16
break
case"exportSharedKey":s=17
break
case"setSifTrailer":s=18
break
case"updateCodec":s=19
break
case"dispose":s=20
break
case"dataCryptorEncrypt":s=21
break
case"dataCryptorDecrypt":s=22
break
case"dataCryptorDispose":s=23
break
default:s=24
break}break
case 5:a0=c6.j(0,"keyOptions")
a1=A.i(c6.j(0,"keyProviderId"))
a2=J.e2(a0)
a3=A.cO(a2.j(a0,"sharedKey"))
a4=new Uint8Array(A.as(B.n.I(A.i(a2.j(a0,"ratchetSalt")))))
a5=A.n(a2.j(a0,"ratchetWindowSize"))
a6=a2.j(a0,"failureTolerance")
a6=A.n(a6==null?-1:a6)
a7=a2.j(a0,"uncryptedMagicBytes")!=null?new Uint8Array(A.as(B.n.I(A.i(a2.j(a0,"uncryptedMagicBytes"))))):null
a8=a2.j(a0,"keyRingSize")
a8=A.n(a8==null?16:a8)
a2=a2.j(a0,"discardFrameWhenCryptorNotReady")
a9=new A.d9(a3,a4,a5,a6,a7,a8,A.cO(a2==null?!1:a2))
c9.i(B.a,"Init with keyProviderOptions:\n "+a9.k(0),null,null)
c9=v.G
a2=A.b(c9.self)
a3=t.N
a4=new Uint8Array(0)
$.af.v(0,a1,new A.cj(a2,a9,A.bq(a3,t.bW),a4))
A.b(c9.self).postMessage(A.h(A.j(["type","init","msgId",c8,"msgType","response"],a3,t.T)))
s=4
break
case 6:a1=A.i(c6.j(0,"keyProviderId"))
c9.i(B.a,"Dispose keyProvider "+a1,null,null)
$.af.bU(0,a1)
A.b(v.G.self).postMessage(A.h(A.j(["type","dispose","msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 7:b0=A.cO(c6.j(0,"enabled"))
b1=A.i(c6.j(0,"trackId"))
a2=$.aP
a3=A.ae(a2)
a4=a3.h("aF<1>")
b2=A.f8(new A.aF(a2,a3.h("W(1)").a(new A.ed(b1)),a4),a4.h("f.E"))
for(a2=b2.length,a3=""+b0,a4="Set enable "+a3+" for trackId ",a5="setEnabled["+a3+u.h,b3=0;b3<b2.length;b2.length===a2||(0,A.c2)(b2),++b3){k=b2[b3]
c9.i(B.a,a4+k.c,null,null)
if(k.x!==B.k){c9.i(B.f,a5,null,null)
k.x=B.m}c9.i(B.a,"setEnabled for "+A.c(k.b)+", enabled: "+a3,null,null)
k.r=b0}A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorEnabled","enable",b0,"msgId",c8,"msgType","response"],t.N,t.X)))
s=4
break
case 8:case 9:b4=c6.j(0,"kind")
b5=A.cO(c6.j(0,"exist"))
n=A.i(c6.j(0,"participantId"))
b1=c6.j(0,"trackId")
b6=A.b(c6.j(0,"readableStream"))
b7=A.b(c6.j(0,"writableStream"))
a1=A.i(c6.j(0,"keyProviderId"))
c9.i(B.a,"SetupTransform for kind "+A.c(b4)+", trackId "+A.c(b1)+", participantId "+n+", "+J.ez(b6).k(0)+" "+J.ez(b7).k(0)+"}",null,null)
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorSetup","participantId",n,"trackId",b1,"exist",b5,"operation",c7,"error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.z)))
s=1
break}A.i(b1)
k=A.h2(n,b1,b8)
A.i(c7)
A.i(b4)
s=25
return A.m(k.ba(b5&&c7==="decode",b4,c7,b6,b1,b7),$async$$1)
case 25:A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorSetup","participantId",n,"trackId",b1,"exist",b5,"operation",c7,"msgId",c8,"msgType","response"],t.N,t.z)))
k.x=B.m
s=4
break
case 10:b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Removing trackId "+b1,null,null)
A.jB(b1)
A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorRemoved","trackId",b1,"msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 11:case 12:b9=new Uint8Array(A.as(B.n.I(A.i(c6.j(0,"key")))))
e=A.n(c6.j(0,"keyIndex"))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=b8.c.a
a3=""+e
s=a2?26:28
break
case 26:c9.i(B.a,"Set SharedKey keyIndex "+a3,null,null)
s=29
return A.m(b8.X(b9,e),$async$$1)
case 29:s=27
break
case 28:n=A.i(c6.j(0,"participantId"))
c9.i(B.a,"Set key for participant "+n+", keyIndex "+a3,null,null)
s=30
return A.m(b8.G(n).D(b9,e),$async$$1)
case 30:case 27:A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","participantId",c6.j(0,"participantId"),"sharedKey",a2,"keyIndex",e,"msgId",c8,"msgType","response"],t.N,t.z)))
s=4
break
case 13:case 14:e=c6.j(0,"keyIndex")
n=A.i(c6.j(0,"participantId"))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=b8.c.a
s=a2?31:33
break
case 31:c9.i(B.a,"RatchetKey for SharedKey, keyIndex "+A.c(e),null,null)
s=34
return A.m(b8.W().E(A.eN(e)),$async$$1)
case 34:c0=d4
s=32
break
case 33:c9.i(B.a,"RatchetKey for participant "+n+", keyIndex "+A.c(e),null,null)
s=35
return A.m(b8.G(n).E(A.eN(e)),$async$$1)
case 35:c0=d4
case 32:c9=A.b(v.G.self)
a3=c0!=null?B.u.I(t.B.h("aw.S").a(c0)):""
c9.postMessage(A.h(A.j(["type","ratchetKey","sharedKey",a2,"participantId",n,"newKey",a3,"keyIndex",e,"msgId",c8,"msgType","response"],t.N,t.z)))
s=4
break
case 15:e=c6.j(0,"index")
b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Setup key index for track "+b1,null,null)
a2=$.aP
a3=A.ae(a2)
a4=a3.h("aF<1>")
b2=A.f8(new A.aF(a2,a3.h("W(1)").a(new A.ee(b1)),a4),a4.h("f.E"))
for(a2=b2.length,b3=0;b3<b2.length;b2.length===a2||(0,A.c2)(b2),++b3){c1=b2[b3]
c9.i(B.a,"Set keyIndex for trackId "+c1.c,null,null)
A.n(e)
if(c1.x!==B.k){c9.i(B.f,"setKeyIndex: lastError != CryptorError.kOk, reset state to kNew",null,null)
c1.x=B.m}c9.i(B.a,"setKeyIndex for "+A.c(c1.b)+", newIndex: "+e,null,null)
c1.y=e}A.b(v.G.self).postMessage(A.h(A.j(["type","setKeyIndex","keyIndex",e,"msgId",c8,"msgType","response"],t.N,t.z)))
s=4
break
case 16:case 17:e=A.n(c6.j(0,"keyIndex"))
n=A.i(c6.j(0,"participantId"))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=""+e
s=b8.c.a?36:38
break
case 36:c9.i(B.a,"Export SharedKey keyIndex "+a2,null,null)
s=39
return A.m(b8.W().U(e),$async$$1)
case 39:b9=d4
s=37
break
case 38:c9.i(B.a,"Export key for participant "+n+", keyIndex "+a2,null,null)
s=40
return A.m(b8.G(n).U(e),$async$$1)
case 40:b9=d4
case 37:c9=A.b(v.G.self)
a2=b9!=null?B.u.I(t.B.h("aw.S").a(b9)):""
c9.postMessage(A.h(A.j(["type","exportKey","participantId",n,"keyIndex",e,"exportedKey",a2,"msgId",c8,"msgType","response"],t.N,t.X)))
s=4
break
case 18:c2=new Uint8Array(A.as(B.n.I(A.i(c6.j(0,"sifTrailer")))))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}b8.c.e=c2
c9.i(B.a,"SetSifTrailer = "+A.c(c2),null,null)
for(a2=$.aP,a3=a2.length,b3=0;b3<a2.length;a2.length===a3||(0,A.c2)(a2),++b3){c1=a2[b3]
c9.i(B.a,"setSifTrailer for "+A.c(c1.b)+", magicBytes: "+A.c(c2),null,null)
c1.e.d.e=c2}A.b(v.G.self).postMessage(A.h(A.j(["type","setSifTrailer","msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 19:c3=A.i(c6.j(0,"codec"))
b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Update codec for trackId "+b1+", codec "+c3,null,null)
k=A.az($.aP,new A.ef(b1),t.j)
if(k!=null){if(k.x!==B.k){c9.i(B.f,"updateCodec["+c3+u.h,null,null)
k.x=B.m}c9.i(B.a,"updateCodec for "+A.c(k.b)+", codec: "+c3,null,null)
k.d=c3}A.b(v.G.self).postMessage(A.h(A.j(["type","updateCodec","msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 20:b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Dispose for trackId "+b1,null,null)
k=A.az($.aP,new A.eg(b1),t.j)
c9=v.G
a2=t.N
a3=t.T
if(k!=null){k.x=B.M
A.b(c9.self).postMessage(A.h(A.j(["type","cryptorDispose","participantId",k.b,"trackId",b1,"msgId",c8,"msgType","response"],a2,a3)))}else A.b(c9.self).postMessage(A.h(A.j(["type","cryptorDispose","error","cryptor not found","msgId",c8,"msgType","response"],a2,a3)))
s=4
break
case 21:n=A.i(c6.j(0,"participantId"))
m=t.D.a(c6.j(0,"data"))
e=A.n(c6.j(0,"keyIndex"))
l=A.i(c6.j(0,"dataCryptorId"))
c4=A.i(c6.j(0,"algorithm"))
if(A.az(B.B,new A.eh(c4),t.b)==null){A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","error","algorithm not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}c9.i(B.a,"Encrypt for dataCryptorId "+A.c(l)+", participantId "+A.c(n)+", keyIndex "+e+", data length "+J.aQ(m)+", algorithm "+c4,null,null)
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}k=A.h0(n,l,b8)
p=42
s=45
return A.m(k.a8(k.d,m),$async$$1)
case 45:j=d4
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","participantId",n,"dataCryptorId",l,"data",j.a,"keyIndex",j.b,"iv",j.c,"msgId",c8,"msgType","response"],t.N,t.X)))
p=2
s=44
break
case 42:p=41
d0=o.pop()
i=A.N(d0)
$.v().i(B.b,"Error encrypting data: "+A.c(i),null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","error",J.T(i),"msgId",c8,"msgType","response"],t.N,t.T)))
s=44
break
case 41:s=2
break
case 44:s=4
break
case 22:h=A.i(c6.j(0,"participantId"))
a2=t.D
g=a2.a(c6.j(0,"data"))
f=a2.a(c6.j(0,"iv"))
e=A.n(c6.j(0,"keyIndex"))
d=A.i(c6.j(0,"dataCryptorId"))
c4=A.i(c6.j(0,"algorithm"))
if(A.az(B.B,new A.ei(c4),t.b)==null){A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","error","algorithm not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}c9.i(B.a,"Decrypt for dataCryptorId "+A.c(d)+", participantId "+A.c(h)+", keyIndex "+A.c(e)+", data length "+J.aQ(g)+", algorithm "+c4,null,null)
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.af.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}c=A.h0(h,d,b8)
p=47
s=50
return A.m(c.S(c.d,new A.bi(g,e,f)),$async$$1)
case 50:b=d4
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","participantId",h,"dataCryptorId",d,"data",b,"msgId",c8,"msgType","response"],t.N,t.X)))
p=2
s=49
break
case 47:p=46
d1=o.pop()
a=A.N(d1)
$.v().i(B.b,"Error decrypting data: "+A.c(a),null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","error",J.T(a),"msgId",c8,"msgType","response"],t.N,t.T)))
s=49
break
case 46:s=2
break
case 49:s=4
break
case 23:l=A.i(c6.j(0,"dataCryptorId"))
c9.i(B.a,"Dispose for dataCryptorId "+l,null,null)
A.jC(l)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDispose","dataCryptorId",l,"msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 24:c9.i(B.b,"Unknown message kind "+c6.k(0),null,null)
case 4:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$$1,r)},
$S:23}
A.ed.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.ee.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.ef.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.eg.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.eh.prototype={
$1(a){return t.b.a(a).b===this.a},
$S:12}
A.ei.prototype={
$1(a){return t.b.a(a).b===this.a},
$S:12}
A.el.prototype={
$1(a){this.a.$1(A.b(a))},
$S:11};(function aliases(){var s=J.am.prototype
s.bd=s.k
s=A.aG.prototype
s.be=s.ab})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers._static_2,p=hunkHelpers._instance_2u,o=hunkHelpers._instance_0u
s(A,"j9","hY",4)
s(A,"ja","hZ",4)
s(A,"jb","i_",4)
r(A,"fX","j2",0)
q(A,"jd","iW",7)
r(A,"jc","iV",0)
p(A.x.prototype,"gbk","bl",7)
o(A.b3.prototype,"gbs","bt",0)
var n
p(n=A.al.prototype,"gbJ","a7",9)
p(n,"gbF","R",9)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.k,null)
q(A.k,[A.eE,J.cd,A.bB,J.be,A.b2,A.w,A.dg,A.f,A.aB,A.bs,A.bG,A.L,A.dk,A.df,A.bj,A.bT,A.ak,A.aD,A.da,A.bo,A.cN,A.a2,A.cI,A.dP,A.dN,A.cE,A.O,A.b_,A.ad,A.aG,A.cG,A.aH,A.x,A.cF,A.bL,A.cJ,A.b3,A.cL,A.bZ,A.bO,A.u,A.aw,A.c9,A.dv,A.du,A.ca,A.dw,A.cs,A.bC,A.dx,A.d0,A.y,A.cM,A.cz,A.de,A.dI,A.an,A.aC,A.aX,A.bi,A.ax,A.d3,A.al,A.d9,A.cj,A.aW,A.ct,A.ck,A.dh])
q(J.cd,[J.cf,J.bl,J.bm,J.aU,J.aV,J.ch,J.aT])
q(J.bm,[J.am,J.z,A.ao,A.bw])
q(J.am,[J.cu,J.bD,J.a6])
r(J.ce,A.bB)
r(J.d8,J.z)
q(J.ch,[J.bk,J.cg])
q(A.w,[A.bn,A.ab,A.ci,A.cD,A.cw,A.cH,A.c3,A.a_,A.bE,A.cC,A.aE,A.c8])
q(A.f,[A.l,A.a8,A.aF])
q(A.l,[A.a7,A.bp,A.bN])
r(A.bh,A.a8)
r(A.a9,A.a7)
r(A.bz,A.ab)
q(A.ak,[A.c6,A.c7,A.cA,A.e8,A.ea,A.dr,A.dq,A.dU,A.dM,A.dG,A.di,A.ec,A.ep,A.eq,A.e_,A.e7,A.e1,A.er,A.es,A.ej,A.ek,A.em,A.ed,A.ee,A.ef,A.eg,A.eh,A.ei,A.el])
q(A.cA,[A.cy,A.aR])
q(A.aD,[A.aA,A.bM])
q(A.c7,[A.e9,A.dV,A.dY,A.dH,A.dd])
r(A.aY,A.ao)
q(A.bw,[A.bt,A.H])
q(A.H,[A.bP,A.bR])
r(A.bQ,A.bP)
r(A.bu,A.bQ)
r(A.bS,A.bR)
r(A.bv,A.bS)
q(A.bu,[A.cl,A.cm])
q(A.bv,[A.cn,A.co,A.cp,A.cq,A.cr,A.bx,A.by])
r(A.bV,A.cH)
q(A.c6,[A.ds,A.dt,A.dO,A.dy,A.dC,A.dB,A.dA,A.dz,A.dF,A.dE,A.dD,A.dj,A.dK,A.dL,A.dX,A.dc,A.cW,A.cX,A.d1,A.d2])
r(A.b5,A.b_)
r(A.bI,A.b5)
r(A.b1,A.bI)
r(A.bJ,A.ad)
r(A.ap,A.bJ)
r(A.bU,A.aG)
r(A.bH,A.cG)
r(A.bK,A.bL)
r(A.cK,A.bZ)
r(A.b4,A.bM)
r(A.c5,A.aw)
q(A.c9,[A.cV,A.cU])
q(A.a_,[A.aZ,A.cc])
q(A.dw,[A.ai,A.a0])
s(A.bP,A.u)
s(A.bQ,A.L)
s(A.bR,A.u)
s(A.bS,A.L)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{a:"int",o:"double",aO:"num",a5:"String",W:"bool",y:"Null",r:"List",k:"Object",br:"Map",q:"JSObject"},mangledNames:{},types:["~()","W(al)","a1<~>()","~(@)","~(~())","y(@)","y()","~(k,a3)","k?(k?)","~(q,q)","W(ax)","y(q)","W(ai)","@(@)","@(@,a5)","@(a5)","y(~())","y(@,a3)","~(a,@)","y(k,a3)","~(k?,k?)","aX()","~(aC)","a1<y>(q)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.il(v.typeUniverse,JSON.parse('{"a6":"am","cu":"am","bD":"am","jG":"ao","cf":{"W":[],"p":[]},"bl":{"y":[],"p":[]},"bm":{"q":[]},"am":{"q":[]},"z":{"r":["1"],"l":["1"],"q":[],"f":["1"]},"ce":{"bB":[]},"d8":{"z":["1"],"r":["1"],"l":["1"],"q":[],"f":["1"]},"be":{"a4":["1"]},"ch":{"o":[],"aO":[]},"bk":{"o":[],"a":[],"aO":[],"p":[]},"cg":{"o":[],"aO":[],"p":[]},"aT":{"a5":[],"fe":[],"p":[]},"b2":{"hr":[]},"bn":{"w":[]},"l":{"f":["1"]},"a7":{"l":["1"],"f":["1"]},"aB":{"a4":["1"]},"a8":{"f":["2"],"f.E":"2"},"bh":{"a8":["1","2"],"l":["2"],"f":["2"],"f.E":"2"},"bs":{"a4":["2"]},"a9":{"a7":["2"],"l":["2"],"f":["2"],"f.E":"2","a7.E":"2"},"aF":{"f":["1"],"f.E":"1"},"bG":{"a4":["1"]},"bz":{"ab":[],"w":[]},"ci":{"w":[]},"cD":{"w":[]},"bT":{"a3":[]},"ak":{"ay":[]},"c6":{"ay":[]},"c7":{"ay":[]},"cA":{"ay":[]},"cy":{"ay":[]},"aR":{"ay":[]},"cw":{"w":[]},"aA":{"aD":["1","2"],"f7":["1","2"],"br":["1","2"]},"bp":{"l":["1"],"f":["1"],"f.E":"1"},"bo":{"a4":["1"]},"aY":{"ao":[],"q":[],"bf":[],"p":[]},"ao":{"q":[],"bf":[],"p":[]},"bw":{"q":[]},"cN":{"bf":[]},"bt":{"eC":[],"q":[],"p":[]},"H":{"P":["1"],"q":[]},"bu":{"u":["o"],"H":["o"],"r":["o"],"P":["o"],"l":["o"],"q":[],"f":["o"],"L":["o"]},"bv":{"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"]},"cl":{"cZ":[],"u":["o"],"H":["o"],"r":["o"],"P":["o"],"l":["o"],"q":[],"f":["o"],"L":["o"],"p":[],"u.E":"o"},"cm":{"d_":[],"u":["o"],"H":["o"],"r":["o"],"P":["o"],"l":["o"],"q":[],"f":["o"],"L":["o"],"p":[],"u.E":"o"},"cn":{"d4":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"co":{"d5":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"cp":{"d6":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"cq":{"dm":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"cr":{"dn":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"bx":{"dp":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"by":{"cB":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"L":["a"],"p":[],"u.E":"a"},"cH":{"w":[]},"bV":{"ab":[],"w":[]},"ad":{"b0":["1"],"aq":["1"]},"O":{"w":[]},"b1":{"bI":["1"],"b5":["1"],"b_":["1"]},"ap":{"bJ":["1"],"ad":["1"],"b0":["1"],"aq":["1"]},"aG":{"fl":["1"],"fx":["1"],"aq":["1"]},"bU":{"aG":["1"],"fl":["1"],"fx":["1"],"aq":["1"]},"bH":{"cG":["1"]},"x":{"a1":["1"]},"bI":{"b5":["1"],"b_":["1"]},"bJ":{"ad":["1"],"b0":["1"],"aq":["1"]},"b5":{"b_":["1"]},"bK":{"bL":["1"]},"b3":{"b0":["1"]},"bZ":{"fq":[]},"cK":{"bZ":[],"fq":[]},"bM":{"aD":["1","2"],"br":["1","2"]},"b4":{"bM":["1","2"],"aD":["1","2"],"br":["1","2"]},"bN":{"l":["1"],"f":["1"],"f.E":"1"},"bO":{"a4":["1"]},"aD":{"br":["1","2"]},"c5":{"aw":["r<a>","a5"],"aw.S":"r<a>"},"o":{"aO":[]},"a":{"aO":[]},"r":{"l":["1"],"f":["1"]},"a5":{"fe":[]},"c3":{"w":[]},"ab":{"w":[]},"a_":{"w":[]},"aZ":{"w":[]},"cc":{"w":[]},"bE":{"w":[]},"cC":{"w":[]},"aE":{"w":[]},"c8":{"w":[]},"cs":{"w":[]},"bC":{"w":[]},"cM":{"a3":[]},"d6":{"r":["a"],"l":["a"],"f":["a"]},"cB":{"r":["a"],"l":["a"],"f":["a"]},"dp":{"r":["a"],"l":["a"],"f":["a"]},"d4":{"r":["a"],"l":["a"],"f":["a"]},"dm":{"r":["a"],"l":["a"],"f":["a"]},"d5":{"r":["a"],"l":["a"],"f":["a"]},"dn":{"r":["a"],"l":["a"],"f":["a"]},"cZ":{"r":["o"],"l":["o"],"f":["o"]},"d_":{"r":["o"],"l":["o"],"f":["o"]}}'))
A.ik(v.typeUniverse,JSON.parse('{"l":1,"H":1,"bL":1,"c9":2}'))
var u={o:"Cannot fire new event. Controller is already firing an event",c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",r:"[decodeFunction] decryption failed even after ratcheting",w:"[ratchetKeyInternal] cannot ratchet anymore",h:"]: lastError != CryptorError.kOk, reset state to kNew",f:"decodeFunction: decryption success, buffer length ",D:"decodeFunction::decryptFrameInternal: decrypted: ",E:"decodeFunction::decryptFrameInternal: ratchetKey: decryption ok, newState: kKeyRatcheted"}
var t=(function rtii(){var s=A.ba
return{h:s("@<~>"),b:s("ai"),n:s("O"),B:s("c5"),J:s("bf"),V:s("eC"),p:s("ax"),d:s("l<@>"),C:s("w"),G:s("cZ"),q:s("d_"),j:s("al"),Z:s("ay"),O:s("d4"),k:s("d5"),U:s("d6"),R:s("f<@>"),e:s("f<a>"),s:s("z<a5>"),r:s("z<@>"),t:s("z<a>"),c:s("z<k?>"),u:s("bl"),m:s("q"),g:s("a6"),w:s("P<@>"),x:s("aW"),cK:s("r<@>"),L:s("r<a>"),bG:s("r<aW?>"),cH:s("aC"),I:s("aX"),f:s("br<@,@>"),a:s("aY"),P:s("y"),K:s("k"),bW:s("ct"),cY:s("jI"),l:s("a3"),N:s("a5"),a4:s("p"),b7:s("ab"),c0:s("dm"),bk:s("dn"),ca:s("dp"),D:s("cB"),cr:s("bD"),_:s("x<@>"),aQ:s("x<a>"),A:s("b4<k?,k?>"),W:s("bU<aC>"),y:s("W"),c1:s("W(k)"),i:s("o"),z:s("@"),bd:s("@()"),v:s("@(k)"),Q:s("@(k,a3)"),S:s("a"),a5:s("bi?"),bc:s("a1<y>?"),b1:s("q?"),aF:s("aW?"),X:s("k?"),T:s("a5?"),E:s("cB?"),F:s("aH<@,@>?"),cG:s("W?"),dd:s("o?"),a3:s("a?"),ae:s("aO?"),Y:s("~()?"),o:s("aO"),H:s("~"),M:s("~()"),bo:s("~(k)"),aD:s("~(k,a3)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.N=J.cd.prototype
B.d=J.z.prototype
B.h=J.bk.prototype
B.l=J.aT.prototype
B.O=J.a6.prototype
B.P=J.bm.prototype
B.r=A.bt.prototype
B.e=A.by.prototype
B.C=J.cu.prototype
B.t=J.bD.prototype
B.n=new A.cU()
B.u=new A.cV()
B.v=function getTagFallback(o) {
  var s = Object.prototype.toString.call(o);
  return s.substring(8, s.length - 1);
}
B.F=function() {
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
B.K=function(getTagFallback) {
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
B.G=function(hooks) {
  if (typeof dartExperimentalFixupGetTag != "function") return hooks;
  hooks.getTag = dartExperimentalFixupGetTag(hooks.getTag);
}
B.J=function(hooks) {
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
B.I=function(hooks) {
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
B.H=function(hooks) {
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
B.w=function(hooks) { return hooks; }

B.L=new A.cs()
B.a2=new A.dg()
B.i=new A.cK()
B.o=new A.cM()
B.m=new A.a0(0,"kNew")
B.k=new A.a0(1,"kOk")
B.x=new A.a0(2,"kDecryptError")
B.y=new A.a0(3,"kEncryptError")
B.z=new A.a0(4,"kUnsupportedCodec")
B.p=new A.a0(5,"kMissingKey")
B.A=new A.a0(6,"kKeyRatcheted")
B.q=new A.a0(7,"kInternalError")
B.M=new A.a0(8,"kDisposed")
B.a=new A.an("CONFIG",700)
B.c=new A.an("FINER",400)
B.j=new A.an("FINE",500)
B.f=new A.an("INFO",800)
B.b=new A.an("WARNING",900)
B.D=new A.ai(0,"kAesGcm")
B.E=new A.ai(1,"kAesCbc")
B.B=s([B.D,B.E],A.ba("z<ai>"))
B.Q=A.Z("bf")
B.R=A.Z("eC")
B.S=A.Z("cZ")
B.T=A.Z("d_")
B.U=A.Z("d4")
B.V=A.Z("d5")
B.W=A.Z("d6")
B.X=A.Z("q")
B.Y=A.Z("k")
B.Z=A.Z("dm")
B.a_=A.Z("dn")
B.a0=A.Z("dp")
B.a1=A.Z("cB")})();(function staticFields(){$.dJ=null
$.S=A.M([],A.ba("z<k>"))
$.ff=null
$.f2=null
$.f1=null
$.h1=null
$.fW=null
$.h4=null
$.e0=null
$.eb=null
$.eS=null
$.b6=null
$.c_=null
$.c0=null
$.eP=!1
$.t=B.i
$.fa=0
$.hE=A.bq(t.N,t.I)
$.aP=A.M([],A.ba("z<al>"))
$.eW=A.M([],A.ba("z<ax>"))
$.af=A.bq(t.N,A.ba("cj"))})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"jE","h8",()=>A.e5("_$dart_dartClosure"))
s($,"jD","et",()=>A.e5("_$dart_dartClosure_dartJSInterop"))
s($,"jX","cS",()=>A.fc(0))
s($,"jZ","hm",()=>A.M([new J.ce()],A.ba("z<bB>")))
s($,"jK","h9",()=>A.ac(A.dl({
toString:function(){return"$receiver$"}})))
s($,"jL","ha",()=>A.ac(A.dl({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"jM","hb",()=>A.ac(A.dl(null)))
s($,"jN","hc",()=>A.ac(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"jQ","hf",()=>A.ac(A.dl(void 0)))
s($,"jR","hg",()=>A.ac(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"jP","he",()=>A.ac(A.fo(null)))
s($,"jO","hd",()=>A.ac(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"jT","hi",()=>A.ac(A.fo(void 0)))
s($,"jS","hh",()=>A.ac(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"jU","eX",()=>A.hX())
s($,"jW","hk",()=>new Int8Array(A.as(A.M([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.t))))
s($,"jV","hj",()=>A.fc(0))
s($,"jY","hl",()=>A.eo(B.Y))
s($,"jH","eu",()=>{var r=new A.dI(A.hG(8))
r.bf()
return r})
s($,"jF","cR",()=>A.db(""))
s($,"k0","v",()=>A.db("E2EE.Worker"))})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({SharedArrayBuffer:A.ao,ArrayBuffer:A.aY,ArrayBufferView:A.bw,DataView:A.bt,Float32Array:A.cl,Float64Array:A.cm,Int16Array:A.cn,Int32Array:A.co,Int8Array:A.cp,Uint16Array:A.cq,Uint32Array:A.cr,Uint8ClampedArray:A.bx,CanvasPixelArray:A.bx,Uint8Array:A.by})
hunkHelpers.setOrUpdateLeafTags({SharedArrayBuffer:true,ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.H.$nativeSuperclassTag="ArrayBufferView"
A.bP.$nativeSuperclassTag="ArrayBufferView"
A.bQ.$nativeSuperclassTag="ArrayBufferView"
A.bu.$nativeSuperclassTag="ArrayBufferView"
A.bR.$nativeSuperclassTag="ArrayBufferView"
A.bS.$nativeSuperclassTag="ArrayBufferView"
A.bv.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$0=function(){return this()}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$1$1=function(a){return this(a)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.eU
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=e2ee.worker.dart.js.map
