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
if(a[b]!==s){A.jv(b)}a[b]=r}var q=a[b]
a[c]=function(){return q}
return q}}function makeConstList(a,b){if(b!=null)A.K(a,b)
a.$flags=7
return a}function convertToFastObject(a){function t(){}t.prototype=a
new t()
return a}function convertAllToFastObject(a){for(var s=0;s<a.length;++s){convertToFastObject(a[s])}}var y=0
function instanceTearOffGetter(a,b){var s=null
return a?function(c){if(s===null)s=A.eP(b)
return new s(c,this)}:function(){if(s===null)s=A.eP(b)
return new s(this,null)}}function staticTearOffGetter(a){var s=null
return function(){if(s===null)s=A.eP(a).prototype
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
eT(a,b,c,d){return{i:a,p:b,e:c,x:d}},
e3(a){var s,r,q,p,o,n="_$dart_js",m=a[v.dispatchPropertyName]
if(m==null)if($.eQ==null){A.jk()
m=a[v.dispatchPropertyName]}if(m!=null){s=m.p
if(!1===s)return m.i
if(!0===s)return a
r=Object.getPrototypeOf(a)
if(s===r)return m.i
if(m.e===r)throw A.d(A.fn("Return interceptor for "+A.c(s(a,m))))}q=a.constructor
if(q==null)p=null
else{o=$.dI
if(o==null)o=$.dI=A.e2(n)
p=q[o]}if(p!=null)return p
p=A.jq(a)
if(p!=null)return p
if(typeof a=="function")return B.O
s=Object.getPrototypeOf(a)
if(s==null)return B.C
if(s===Object.prototype)return B.C
if(typeof q=="function"){o=$.dI
if(o==null)o=$.dI=A.e2(n)
Object.defineProperty(q,o,{value:B.t,enumerable:false,writable:true,configurable:true})
return B.t}return B.t},
hw(a,b){if(a<0||a>4294967295)throw A.d(A.ab(a,0,4294967295,"length",null))
return J.hy(new Array(a),b)},
hx(a,b){if(a<0)throw A.d(A.a6("Length must be a non-negative integer: "+a,null))
return A.K(new Array(a),b.h("y<0>"))},
hy(a,b){var s=A.K(a,b.h("y<0>"))
s.$flags=1
return s},
aM(a){if(typeof a=="number"){if(Math.floor(a)==a)return J.bj.prototype
return J.ce.prototype}if(typeof a=="string")return J.aT.prototype
if(a==null)return J.bk.prototype
if(typeof a=="boolean")return J.cd.prototype
if(Array.isArray(a))return J.y.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a7.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e3(a)},
e_(a){if(typeof a=="string")return J.aT.prototype
if(a==null)return a
if(Array.isArray(a))return J.y.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a7.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e3(a)},
e0(a){if(a==null)return a
if(Array.isArray(a))return J.y.prototype
if(typeof a!="object"){if(typeof a=="function")return J.a7.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e3(a)},
e1(a){if(a==null)return a
if(typeof a!="object"){if(typeof a=="function")return J.a7.prototype
if(typeof a=="symbol")return J.aV.prototype
if(typeof a=="bigint")return J.aU.prototype
return a}if(a instanceof A.k)return a
return J.e3(a)},
es(a,b){if(a==null)return b==null
if(typeof a!="object")return b!=null&&a===b
return J.aM(a).F(a,b)},
eW(a,b){if(typeof b==="number")if(Array.isArray(a)||typeof a=="string"||A.jo(a,a[v.dispatchPropertyName]))if(b>>>0===b&&b<a.length)return a[b]
return J.e_(a).j(a,b)},
eX(a,b,c){return J.e1(a).bD(a,b,c)},
bc(a,b){return J.e0(a).u(a,b)},
et(a){return J.e1(a).b2(a)},
eY(a,b,c){return J.e1(a).aa(a,b,c)},
hi(a,b){return J.e0(a).V(a,b)},
eu(a){return J.e1(a).gH(a)},
cP(a){return J.aM(a).gt(a)},
ev(a){return J.e0(a).gA(a)},
aQ(a){return J.e_(a).gm(a)},
ew(a){return J.aM(a).gq(a)},
hj(a,b,c){return J.e0(a).X(a,b,c)},
T(a){return J.aM(a).k(a)},
cb:function cb(){},
cd:function cd(){},
bk:function bk(){},
bl:function bl(){},
an:function an(){},
cs:function cs(){},
bC:function bC(){},
a7:function a7(){},
aU:function aU(){},
aV:function aV(){},
y:function y(a){this.$ti=a},
cc:function cc(){},
d5:function d5(a){this.$ti=a},
bd:function bd(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
cf:function cf(){},
bj:function bj(){},
ce:function ce(){},
aT:function aT(){}},A={eA:function eA(){},
hz(a){return new A.bm("Field '"+a+"' has not been initialized.")},
fl(a,b){a=a+b&536870911
a=a+((a&524287)<<10)&536870911
return a^a>>>6},
hS(a){a=a+((a&67108863)<<3)&536870911
a^=a>>>11
return a+((a&16383)<<15)&536870911},
eO(a,b,c){return a},
eR(a){var s,r
for(s=$.S.length,r=0;r<s;++r)if(a===$.S[r])return!0
return!1},
hB(a,b,c,d){if(t.d.b(a))return new A.bg(a,b,c.h("@<0>").l(d).h("bg<1,2>"))
return new A.a9(a,b,c.h("@<0>").l(d).h("a9<1,2>"))},
b2:function b2(a){this.a=0
this.b=a},
bm:function bm(a){this.a=a},
dd:function dd(){},
l:function l(){},
a8:function a8(){},
aB:function aB(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
a9:function a9(a,b,c){this.a=a
this.b=b
this.$ti=c},
bg:function bg(a,b,c){this.a=a
this.b=b
this.$ti=c},
br:function br(a,b,c){var _=this
_.a=null
_.b=a
_.c=b
_.$ti=c},
aa:function aa(a,b,c){this.a=a
this.b=b
this.$ti=c},
aF:function aF(a,b,c){this.a=a
this.b=b
this.$ti=c},
bF:function bF(a,b,c){this.a=a
this.b=b
this.$ti=c},
M:function M(){},
h2(a){var s=A.h1(a)
if(s!=null)return s
return"minified:"+a},
jo(a,b){var s
if(b!=null){s=b.x
if(s!=null)return s}return t.w.b(a)},
c(a){var s
if(typeof a=="string")return a
if(typeof a=="number"){if(a!==0)return""+a}else if(!0===a)return"true"
else if(!1===a)return"false"
else if(a==null)return"null"
s=J.T(a)
return s},
bz(a){var s,r=$.fd
if(r==null)r=$.fd=Symbol("identityHashCode")
s=a[r]
if(s==null){s=Math.random()*0x3fffffff|0
a[r]=s}return s},
ct(a){var s,r,q,p
if(a instanceof A.k)return A.R(A.ba(a),null)
s=J.aM(a)
if(s===B.N||s===B.P||t.cr.b(a)){r=B.v(a)
if(r!=="Object"&&r!=="")return r
q=a.constructor
if(typeof q=="function"){p=q.name
if(typeof p=="string"&&p!=="Object"&&p!=="")return p}}return A.R(A.ba(a),null)},
hM(a){var s,r,q
if(typeof a=="number"||A.dU(a))return J.T(a)
if(typeof a=="string")return JSON.stringify(a)
if(a instanceof A.al)return a.k(0)
s=$.hh()
for(r=0;r<1;++r){q=s[r].c6(a)
if(q!=null)return q}return"Instance of '"+A.ct(a)+"'"},
hN(a,b,c){var s,r,q,p
if(c<=500&&b===0&&c===a.length)return String.fromCharCode.apply(null,a)
for(s=b,r="";s<c;s=q){q=s+500
p=q<c?q:c
r+=String.fromCharCode.apply(null,a.subarray(s,p))}return r},
Q(a){if(a.date===void 0)a.date=new Date(a.a)
return a.date},
hL(a){return a.c?A.Q(a).getUTCFullYear()+0:A.Q(a).getFullYear()+0},
hJ(a){return a.c?A.Q(a).getUTCMonth()+1:A.Q(a).getMonth()+1},
hF(a){return a.c?A.Q(a).getUTCDate()+0:A.Q(a).getDate()+0},
hG(a){return a.c?A.Q(a).getUTCHours()+0:A.Q(a).getHours()+0},
hI(a){return a.c?A.Q(a).getUTCMinutes()+0:A.Q(a).getMinutes()+0},
hK(a){return a.c?A.Q(a).getUTCSeconds()+0:A.Q(a).getSeconds()+0},
hH(a){return a.c?A.Q(a).getUTCMilliseconds()+0:A.Q(a).getMilliseconds()+0},
hE(a){var s=a.$thrownJsError
if(s==null)return null
return A.ag(s)},
fe(a,b){var s
if(a.$thrownJsError==null){s=new Error()
A.B(a,s)
a.$thrownJsError=s
s.stack=b.k(0)}},
ji(a){throw A.d(A.j4(a))},
e(a,b){if(a==null)J.aQ(a)
throw A.d(A.cM(a,b))},
cM(a,b){var s,r="index"
if(!A.fJ(b))return new A.a_(!0,b,r,null)
s=A.n(J.aQ(a))
if(b<0||b>=s)return A.f4(b,s,a,r)
return A.hO(b,r)},
jc(a,b,c){if(a<0||a>c)return A.ab(a,0,c,"start",null)
if(b!=null)if(b<a||b>c)return A.ab(b,a,c,"end",null)
return new A.a_(!0,b,"end",null)},
j4(a){return new A.a_(!0,a,null,null)},
d(a){return A.B(a,new Error())},
B(a,b){var s
if(a==null)a=new A.ac()
b.dartException=a
s=A.jw
if("defineProperty" in Object){Object.defineProperty(b,"message",{get:s})
b.name=""}else b.toString=s
return b},
jw(){return J.T(this.dartException)},
X(a,b){throw A.B(a,b==null?new Error():b)},
Y(a,b,c){var s
if(b==null)b=0
if(c==null)c=0
s=Error()
A.X(A.iu(a,b,c),s)},
iu(a,b,c){var s,r,q,p,o,n,m,l,k
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
return new A.bD("'"+s+"': Cannot "+o+" "+l+k+n)},
c0(a){throw A.d(A.bf(a))},
ad(a){var s,r,q,p,o,n
a=A.ju(a.replace(String({}),"$receiver$"))
s=a.match(/\\\$[a-zA-Z]+\\\$/g)
if(s==null)s=A.K([],t.s)
r=s.indexOf("\\$arguments\\$")
q=s.indexOf("\\$argumentsExpr\\$")
p=s.indexOf("\\$expr\\$")
o=s.indexOf("\\$method\\$")
n=s.indexOf("\\$receiver\\$")
return new A.dh(a.replace(new RegExp("\\\\\\$arguments\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$argumentsExpr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$expr\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$method\\\\\\$","g"),"((?:x|[^x])*)").replace(new RegExp("\\\\\\$receiver\\\\\\$","g"),"((?:x|[^x])*)"),r,q,p,o,n)},
di(a){return function($expr$){var $argumentsExpr$="$arguments$"
try{$expr$.$method$($argumentsExpr$)}catch(s){return s.message}}(a)},
fm(a){return function($expr$){try{$expr$.$method$}catch(s){return s.message}}(a)},
eB(a,b){var s=b==null,r=s?null:b.method
return new A.cg(a,r,s?null:b.receiver)},
L(a){var s
if(a==null)return new A.dc(a)
if(a instanceof A.bi){s=a.a
return A.av(a,s==null?A.N(s):s)}if(typeof a!=="object")return a
if("dartException" in a)return A.av(a,a.dartException)
return A.j3(a)},
av(a,b){if(t.C.b(b))if(b.$thrownJsError==null)b.$thrownJsError=a
return b},
j3(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(!("message" in a))return a
s=a.message
if("number" in a&&typeof a.number=="number"){r=a.number
q=r&65535
if((B.h.a9(r,16)&8191)===10)switch(q){case 438:return A.av(a,A.eB(A.c(s)+" (Error "+q+")",null))
case 445:case 5007:A.c(s)
return A.av(a,new A.by())}}if(a instanceof TypeError){p=$.h4()
o=$.h5()
n=$.h6()
m=$.h7()
l=$.ha()
k=$.hb()
j=$.h9()
$.h8()
i=$.hd()
h=$.hc()
g=p.C(s)
if(g!=null)return A.av(a,A.eB(A.i(s),g))
else{g=o.C(s)
if(g!=null){g.method="call"
return A.av(a,A.eB(A.i(s),g))}else if(n.C(s)!=null||m.C(s)!=null||l.C(s)!=null||k.C(s)!=null||j.C(s)!=null||m.C(s)!=null||i.C(s)!=null||h.C(s)!=null){A.i(s)
return A.av(a,new A.by())}}return A.av(a,new A.cB(typeof s=="string"?s:""))}if(a instanceof RangeError){if(typeof s=="string"&&s.indexOf("call stack")!==-1)return new A.bB()
s=function(b){try{return String(b)}catch(f){}return null}(a)
return A.av(a,new A.a_(!1,null,null,typeof s=="string"?s.replace(/^RangeError:\s*/,""):s))}if(typeof InternalError=="function"&&a instanceof InternalError)if(typeof s=="string"&&s==="too much recursion")return new A.bB()
return a},
ag(a){var s
if(a instanceof A.bi)return a.b
if(a==null)return new A.bS(a)
s=a.$cachedTrace
if(s!=null)return s
s=new A.bS(a)
if(typeof a==="object")a.$cachedTrace=s
return s},
el(a){if(a==null)return J.cP(a)
if(typeof a=="object")return A.bz(a)
return J.cP(a)},
jd(a,b){var s,r,q,p=a.length
for(s=0;s<p;s=q){r=s+1
q=r+1
b.v(0,a[s],a[r])}return b},
iE(a,b,c,d,e,f){t.Z.a(a)
switch(A.n(b)){case 0:return a.$0()
case 1:return a.$1(c)
case 2:return a.$2(c,d)
case 3:return a.$3(c,d,e)
case 4:return a.$4(c,d,e,f)}throw A.d(A.U("Unsupported number of arguments for wrapped closure"))},
c_(a,b){var s=a.$identity
if(!!s)return s
s=A.ja(a,b)
a.$identity=s
return s},
ja(a,b){var s
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
return function(c,d,e){return function(f,g,h,i){return e(c,d,f,g,h,i)}}(a,b,A.iE)},
hr(a2){var s,r,q,p,o,n,m,l,k,j,i=a2.co,h=a2.iS,g=a2.iI,f=a2.nDA,e=a2.aI,d=a2.fs,c=a2.cs,b=d[0],a=c[0],a0=i[b],a1=a2.fT
a1.toString
s=h?Object.create(new A.cw().constructor.prototype):Object.create(new A.aR(null,null).constructor.prototype)
s.$initialize=s.constructor
r=h?function static_tear_off(){this.$initialize()}:function tear_off(a3,a4){this.$initialize(a3,a4)}
s.constructor=r
r.prototype=s
s.$_name=b
s.$_target=a0
q=!h
if(q)p=A.f2(b,a0,g,f)
else{s.$static_name=b
p=a0}s.$S=A.hn(a1,h,g)
s[a]=p
for(o=p,n=1;n<d.length;++n){m=d[n]
if(typeof m=="string"){l=i[m]
k=m
m=l}else k=""
j=c[n]
if(j!=null){if(q)m=A.f2(k,m,g,f)
s[j]=m}if(n===e)o=m}s.$C=o
s.$R=a2.rC
s.$D=a2.dV
return r},
hn(a,b,c){if(typeof a=="number")return a
if(typeof a=="string"){if(b)throw A.d("Cannot compute signature for static tearoff.")
return function(d,e){return function(){return e(this,d)}}(a,A.hk)}throw A.d("Error in functionType of tearoff")},
ho(a,b,c,d){var s=A.f1
switch(b?-1:a){case 0:return function(e,f){return function(){return f(this)[e]()}}(c,s)
case 1:return function(e,f){return function(g){return f(this)[e](g)}}(c,s)
case 2:return function(e,f){return function(g,h){return f(this)[e](g,h)}}(c,s)
case 3:return function(e,f){return function(g,h,i){return f(this)[e](g,h,i)}}(c,s)
case 4:return function(e,f){return function(g,h,i,j){return f(this)[e](g,h,i,j)}}(c,s)
case 5:return function(e,f){return function(g,h,i,j,k){return f(this)[e](g,h,i,j,k)}}(c,s)
default:return function(e,f){return function(){return e.apply(f(this),arguments)}}(d,s)}},
f2(a,b,c,d){if(c)return A.hq(a,b,d)
return A.ho(b.length,d,a,b)},
hp(a,b,c,d){var s=A.f1,r=A.hl
switch(b?-1:a){case 0:throw A.d(new A.cu("Intercepted function with no arguments."))
case 1:return function(e,f,g){return function(){return f(this)[e](g(this))}}(c,r,s)
case 2:return function(e,f,g){return function(h){return f(this)[e](g(this),h)}}(c,r,s)
case 3:return function(e,f,g){return function(h,i){return f(this)[e](g(this),h,i)}}(c,r,s)
case 4:return function(e,f,g){return function(h,i,j){return f(this)[e](g(this),h,i,j)}}(c,r,s)
case 5:return function(e,f,g){return function(h,i,j,k){return f(this)[e](g(this),h,i,j,k)}}(c,r,s)
case 6:return function(e,f,g){return function(h,i,j,k,l){return f(this)[e](g(this),h,i,j,k,l)}}(c,r,s)
default:return function(e,f,g){return function(){var q=[g(this)]
Array.prototype.push.apply(q,arguments)
return e.apply(f(this),q)}}(d,r,s)}},
hq(a,b,c){var s,r
if($.f_==null)$.f_=A.eZ("interceptor")
if($.f0==null)$.f0=A.eZ("receiver")
s=b.length
r=A.hp(s,c,a,b)
return r},
eP(a){return A.hr(a)},
hk(a,b){return A.dP(v.typeUniverse,A.ba(a.a),b)},
f1(a){return a.a},
hl(a){return a.b},
eZ(a){var s,r,q,p=new A.aR("receiver","interceptor"),o=Object.getOwnPropertyNames(p)
o.$flags=1
s=o
for(o=s.length,r=0;r<o;++r){q=s[r]
if(p[q]===a)return q}throw A.d(A.a6("Field name "+a+" not found.",null))},
e2(a){return v.getIsolateTag(a)},
jW(a,b,c){Object.defineProperty(a,b,{value:c,enumerable:false,writable:true,configurable:true})},
jq(a){var s,r,q,p,o,n=A.i($.fX.$1(a)),m=$.dY[n]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.e8[n]
if(s!=null)return s
r=v.interceptorsByTag[n]
if(r==null){q=A.dR($.fR.$2(a,n))
if(q!=null){m=$.dY[q]
if(m!=null){Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}s=$.e8[q]
if(s!=null)return s
r=v.interceptorsByTag[q]
n=q}}if(r==null)return null
s=r.prototype
p=n[0]
if(p==="!"){m=A.ek(s)
$.dY[n]=m
Object.defineProperty(a,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
return m.i}if(p==="~"){$.e8[n]=s
return s}if(p==="-"){o=A.ek(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}if(p==="+")return A.fZ(a,s)
if(p==="*")throw A.d(A.fn(n))
if(v.leafTags[n]===true){o=A.ek(s)
Object.defineProperty(Object.getPrototypeOf(a),v.dispatchPropertyName,{value:o,enumerable:false,writable:true,configurable:true})
return o.i}else return A.fZ(a,s)},
fZ(a,b){var s=Object.getPrototypeOf(a)
Object.defineProperty(s,v.dispatchPropertyName,{value:J.eT(b,s,null,null),enumerable:false,writable:true,configurable:true})
return b},
ek(a){return J.eT(a,!1,null,!!a.$iP)},
jr(a,b,c){var s=b.prototype
if(v.leafTags[a]===true)return A.ek(s)
else return J.eT(s,c,null,null)},
jk(){if(!0===$.eQ)return
$.eQ=!0
A.jl()},
jl(){var s,r,q,p,o,n,m,l
$.dY=Object.create(null)
$.e8=Object.create(null)
A.jj()
s=v.interceptorsByTag
r=Object.getOwnPropertyNames(s)
if(typeof window!="undefined"){window
q=function(){}
for(p=0;p<r.length;++p){o=r[p]
n=$.h_.$1(o)
if(n!=null){m=A.jr(o,s[o],n)
if(m!=null){Object.defineProperty(n,v.dispatchPropertyName,{value:m,enumerable:false,writable:true,configurable:true})
q.prototype=n}}}}for(p=0;p<r.length;++p){o=r[p]
if(/^[A-Za-z_]/.test(o)){l=s[o]
s["!"+o]=l
s["~"+o]=l
s["-"+o]=l
s["+"+o]=l
s["*"+o]=l}}},
jj(){var s,r,q,p,o,n,m=B.F()
m=A.b8(B.G,A.b8(B.H,A.b8(B.w,A.b8(B.w,A.b8(B.I,A.b8(B.J,A.b8(B.K(B.v),m)))))))
if(typeof dartNativeDispatchHooksTransformer!="undefined"){s=dartNativeDispatchHooksTransformer
if(typeof s=="function")s=[s]
if(Array.isArray(s))for(r=0;r<s.length;++r){q=s[r]
if(typeof q=="function")m=q(m)||m}}p=m.getTag
o=m.getUnknownTag
n=m.prototypeForTag
$.fX=new A.e5(p)
$.fR=new A.e6(o)
$.h_=new A.e7(n)},
b8(a,b){return a(b)||b},
jb(a,b){var s=b.length,r=v.rttc[""+s+";"+a]
if(r==null)return null
if(s===0)return r
if(s===r.length)return r.apply(null,b)
return r(b)},
ju(a){if(/[[\]{}()*+?.\\^$|]/.test(a))return a.replace(/[[\]{}()*+?.\\^$|]/g,"\\$&")
return a},
bA:function bA(){},
dh:function dh(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
by:function by(){},
cg:function cg(a,b,c){this.a=a
this.b=b
this.c=c},
cB:function cB(a){this.a=a},
dc:function dc(a){this.a=a},
bi:function bi(a,b){this.a=a
this.b=b},
bS:function bS(a){this.a=a
this.b=null},
al:function al(){},
c4:function c4(){},
c5:function c5(){},
cy:function cy(){},
cw:function cw(){},
aR:function aR(a,b){this.a=a
this.b=b},
cu:function cu(a){this.a=a},
aA:function aA(a){var _=this
_.a=0
_.f=_.e=_.d=_.c=_.b=null
_.r=0
_.$ti=a},
d7:function d7(a,b){var _=this
_.a=a
_.b=b
_.d=_.c=null},
bo:function bo(a,b){this.a=a
this.$ti=b},
bn:function bn(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=null
_.$ti=d},
e5:function e5(a){this.a=a},
e6:function e6(a){this.a=a},
e7:function e7(a){this.a=a},
at(a){return a},
hC(a){return new DataView(new ArrayBuffer(a))},
fa(a){return new Uint8Array(a)},
I(a,b,c){return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
aK(a,b,c){if(a>>>0!==a||a>=c)throw A.d(A.cM(b,a))},
it(a,b,c){var s
if(!(a>>>0!==a))if(b==null)s=a>c
else s=b>>>0!==b||a>b||b>c
else s=!0
if(s)throw A.d(A.jc(a,b,c))
if(b==null)return c
return b},
ap:function ap(){},
aY:function aY(){},
bv:function bv(){},
cK:function cK(a){this.a=a},
bs:function bs(){},
H:function H(){},
bt:function bt(){},
bu:function bu(){},
cj:function cj(){},
ck:function ck(){},
cl:function cl(){},
cm:function cm(){},
cn:function cn(){},
co:function co(){},
cp:function cp(){},
bw:function bw(){},
bx:function bx(){},
bO:function bO(){},
bP:function bP(){},
bQ:function bQ(){},
bR:function bR(){},
eC(a,b){var s=b.c
return s==null?b.c=A.bW(a,"a1",[b.x]):s},
fh(a){var s=a.w
if(s===6||s===7)return A.fh(a.x)
return s===11||s===12},
hP(a){return a.as},
b9(a){return A.dO(v.typeUniverse,a,!1)},
aL(a1,a2,a3,a4){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0=a2.w
switch(a0){case 5:case 1:case 2:case 3:case 4:return a2
case 6:s=a2.x
r=A.aL(a1,s,a3,a4)
if(r===s)return a2
return A.fx(a1,r,!0)
case 7:s=a2.x
r=A.aL(a1,s,a3,a4)
if(r===s)return a2
return A.fw(a1,r,!0)
case 8:q=a2.y
p=A.b7(a1,q,a3,a4)
if(p===q)return a2
return A.bW(a1,a2.x,p)
case 9:o=a2.x
n=A.aL(a1,o,a3,a4)
m=a2.y
l=A.b7(a1,m,a3,a4)
if(n===o&&l===m)return a2
return A.eG(a1,n,l)
case 10:k=a2.x
j=a2.y
i=A.b7(a1,j,a3,a4)
if(i===j)return a2
return A.fy(a1,k,i)
case 11:h=a2.x
g=A.aL(a1,h,a3,a4)
f=a2.y
e=A.j0(a1,f,a3,a4)
if(g===h&&e===f)return a2
return A.fv(a1,g,e)
case 12:d=a2.y
a4+=d.length
c=A.b7(a1,d,a3,a4)
o=a2.x
n=A.aL(a1,o,a3,a4)
if(c===d&&n===o)return a2
return A.eH(a1,n,c,!0)
case 13:b=a2.x
if(b<a4)return a2
a=a3[b-a4]
if(a==null)return a2
return a
default:throw A.d(A.c2("Attempted to substitute unexpected RTI kind "+a0))}},
b7(a,b,c,d){var s,r,q,p,o=b.length,n=A.dQ(o)
for(s=!1,r=0;r<o;++r){q=b[r]
p=A.aL(a,q,c,d)
if(p!==q)s=!0
n[r]=p}return s?n:b},
j1(a,b,c,d){var s,r,q,p,o,n,m=b.length,l=A.dQ(m)
for(s=!1,r=0;r<m;r+=3){q=b[r]
p=b[r+1]
o=b[r+2]
n=A.aL(a,o,c,d)
if(n!==o)s=!0
l.splice(r,3,q,p,n)}return s?l:b},
j0(a,b,c,d){var s,r=b.a,q=A.b7(a,r,c,d),p=b.b,o=A.b7(a,p,c,d),n=b.c,m=A.j1(a,n,c,d)
if(q===r&&o===p&&m===n)return b
s=new A.cG()
s.a=q
s.b=o
s.c=m
return s},
K(a,b){a[v.arrayRti]=b
return a},
fT(a){var s=a.$S
if(s!=null){if(typeof s=="number")return A.jh(s)
return a.$S()}return null},
jm(a,b){var s
if(A.fh(b))if(a instanceof A.al){s=A.fT(a)
if(s!=null)return s}return A.ba(a)},
ba(a){if(a instanceof A.k)return A.J(a)
if(Array.isArray(a))return A.af(a)
return A.eK(J.aM(a))},
af(a){var s=a[v.arrayRti],r=t.r
if(s==null)return r
if(s.constructor!==r.constructor)return r
return s},
J(a){var s=a.$ti
return s!=null?s:A.eK(a)},
eK(a){var s=a.constructor,r=s.$ccache
if(r!=null)return r
return A.iB(a,s)},
iB(a,b){var s=a instanceof A.al?Object.getPrototypeOf(Object.getPrototypeOf(a)).constructor:b,r=A.ij(v.typeUniverse,s.name)
b.$ccache=r
return r},
jh(a){var s,r=v.types,q=r[a]
if(typeof q=="string"){s=A.dO(v.typeUniverse,q,!1)
r[a]=s
return s}return q},
jg(a){return A.au(A.J(a))},
j_(a){var s=a instanceof A.al?A.fT(a):null
if(s!=null)return s
if(t.a4.b(a))return J.ew(a).a
if(Array.isArray(a))return A.af(a)
return A.ba(a)},
au(a){var s=a.r
return s==null?a.r=new A.dN(a):s},
Z(a){return A.au(A.dO(v.typeUniverse,a,!1))},
iA(a){var s=this
s.b=A.iY(s)
return s.b(a)},
iY(a){var s,r,q,p,o
if(a===t.K)return A.iK
if(A.aN(a))return A.iO
s=a.w
if(s===6)return A.iy
if(s===1)return A.fL
if(s===7)return A.iF
r=A.iX(a)
if(r!=null)return r
if(s===8){q=a.x
if(a.y.every(A.aN)){a.f="$i"+q
if(q==="r")return A.iI
if(a===t.m)return A.iH
return A.iN}}else if(s===10){p=A.jb(a.x,a.y)
o=p==null?A.fL:p
return o==null?A.N(o):o}return A.iw},
iX(a){if(a.w===8){if(a===t.S)return A.fJ
if(a===t.i||a===t.o)return A.iJ
if(a===t.N)return A.iM
if(a===t.y)return A.dU}return null},
iz(a){var s=this,r=A.iv
if(A.aN(s))r=A.ip
else if(s===t.K)r=A.N
else if(A.bb(s)){r=A.ix
if(s===t.a3)r=A.eJ
else if(s===t.T)r=A.dR
else if(s===t.cG)r=A.il
else if(s===t.ae)r=A.fD
else if(s===t.dd)r=A.im
else if(s===t.b1)r=A.fC}else if(s===t.S)r=A.n
else if(s===t.N)r=A.i
else if(s===t.y)r=A.cL
else if(s===t.o)r=A.io
else if(s===t.i)r=A.eI
else if(s===t.m)r=A.b
s.a=r
return s.a(a)},
iw(a){var s=this
if(a==null)return A.bb(s)
return A.jp(v.typeUniverse,A.jm(a,s),s)},
iy(a){if(a==null)return!0
return this.x.b(a)},
iN(a){var s,r=this
if(a==null)return A.bb(r)
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.aM(a)[s]},
iI(a){var s,r=this
if(a==null)return A.bb(r)
if(typeof a!="object")return!1
if(Array.isArray(a))return!0
s=r.f
if(a instanceof A.k)return!!a[s]
return!!J.aM(a)[s]},
iH(a){var s=this
if(a==null)return!1
if(typeof a=="object"){if(a instanceof A.k)return!!a[s.f]
return!0}if(typeof a=="function")return!0
return!1},
fK(a){if(typeof a=="object"){if(a instanceof A.k)return t.m.b(a)
return!0}if(typeof a=="function")return!0
return!1},
iv(a){var s=this
if(a==null){if(A.bb(s))return a}else if(s.b(a))return a
throw A.B(A.fE(a,s),new Error())},
ix(a){var s=this
if(a==null||s.b(a))return a
throw A.B(A.fE(a,s),new Error())},
fE(a,b){return new A.bU("TypeError: "+A.fp(a,A.R(b,null)))},
fp(a,b){return A.cV(a)+": type '"+A.R(A.j_(a),null)+"' is not a subtype of type '"+b+"'"},
V(a,b){return new A.bU("TypeError: "+A.fp(a,b))},
iF(a){var s=this
return s.x.b(a)||A.eC(v.typeUniverse,s).b(a)},
iK(a){return a!=null},
N(a){if(a!=null)return a
throw A.B(A.V(a,"Object"),new Error())},
iO(a){return!0},
ip(a){return a},
fL(a){return!1},
dU(a){return!0===a||!1===a},
cL(a){if(!0===a)return!0
if(!1===a)return!1
throw A.B(A.V(a,"bool"),new Error())},
il(a){if(!0===a)return!0
if(!1===a)return!1
if(a==null)return a
throw A.B(A.V(a,"bool?"),new Error())},
eI(a){if(typeof a=="number")return a
throw A.B(A.V(a,"double"),new Error())},
im(a){if(typeof a=="number")return a
if(a==null)return a
throw A.B(A.V(a,"double?"),new Error())},
fJ(a){return typeof a=="number"&&Math.floor(a)===a},
n(a){if(typeof a=="number"&&Math.floor(a)===a)return a
throw A.B(A.V(a,"int"),new Error())},
eJ(a){if(typeof a=="number"&&Math.floor(a)===a)return a
if(a==null)return a
throw A.B(A.V(a,"int?"),new Error())},
iJ(a){return typeof a=="number"},
io(a){if(typeof a=="number")return a
throw A.B(A.V(a,"num"),new Error())},
fD(a){if(typeof a=="number")return a
if(a==null)return a
throw A.B(A.V(a,"num?"),new Error())},
iM(a){return typeof a=="string"},
i(a){if(typeof a=="string")return a
throw A.B(A.V(a,"String"),new Error())},
dR(a){if(typeof a=="string")return a
if(a==null)return a
throw A.B(A.V(a,"String?"),new Error())},
b(a){if(A.fK(a))return a
throw A.B(A.V(a,"JSObject"),new Error())},
fC(a){if(a==null)return a
if(A.fK(a))return a
throw A.B(A.V(a,"JSObject?"),new Error())},
fO(a,b){var s,r,q
for(s="",r="",q=0;q<a.length;++q,r=", ")s+=r+A.R(a[q],b)
return s},
iT(a,b){var s,r,q,p,o,n,m=a.x,l=a.y
if(""===m)return"("+A.fO(l,b)+")"
s=l.length
r=m.split(",")
q=r.length-s
for(p="(",o="",n=0;n<s;++n,o=", "){p+=o
if(q===0)p+="{"
p+=A.R(l[n],b)
if(q>=0)p+=" "+r[q];++q}return p+"})"},
fF(a3,a4,a5){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1=", ",a2=null
if(a5!=null){s=a5.length
if(a4==null)a4=A.K([],t.s)
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
if(l===8){p=A.j2(a.x)
o=a.y
return o.length>0?p+("<"+A.fO(o,b)+">"):p}if(l===10)return A.iT(a,b)
if(l===11)return A.fF(a,b,null)
if(l===12)return A.fF(a.x,b,a.y)
if(l===13){n=a.x
m=b.length
n=m-1-n
if(!(n>=0&&n<m))return A.e(b,n)
return b[n]}return"?"},
j2(a){var s=A.h1(a)
if(s!=null)return s
return"minified:"+a},
ik(a,b){var s=a.tR[b]
while(typeof s=="string")s=a.tR[s]
return s},
ij(a,b){var s,r,q,p,o,n=a.eT,m=n[b]
if(m==null)return A.dO(a,b,!1)
else if(typeof m=="number"){s=m
r=A.bX(a,5,"#")
q=A.dQ(s)
for(p=0;p<s;++p)q[p]=r
o=A.bW(a,b,q)
n[b]=o
return o}else return m},
ih(a,b){return A.fA(a.tR,b)},
ig(a,b){return A.fA(a.eT,b)},
dO(a,b,c){var s,r=a.eC,q=r.get(b)
if(q!=null)return q
s=A.fz(a,null,b,!1)
r.set(b,s)
return s},
dP(a,b,c){var s,r,q=b.z
if(q==null)q=b.z=new Map()
s=q.get(c)
if(s!=null)return s
r=A.fz(a,b,c,!0)
q.set(c,r)
return r},
ii(a,b,c){var s,r,q,p=b.Q
if(p==null)p=b.Q=new Map()
s=c.as
r=p.get(s)
if(r!=null)return r
q=A.eG(a,b,c.w===9?c.y:[c])
p.set(s,q)
return q},
fz(a,b,c,d){return A.i7(A.i1(a,b,c,d))},
as(a,b){b.a=A.iz
b.b=A.iA
return b},
bX(a,b,c){var s,r,q=a.eC.get(c)
if(q!=null)return q
s=new A.a2(null,null)
s.w=b
s.as=c
r=A.as(a,s)
a.eC.set(c,r)
return r},
fx(a,b,c){var s,r=b.as+"?",q=a.eC.get(r)
if(q!=null)return q
s=A.id(a,b,r,c)
a.eC.set(r,s)
return s},
id(a,b,c,d){var s,r,q
if(d){s=b.w
r=!0
if(!A.aN(b))if(!(b===t.P||b===t.u))if(s!==6)r=s===7&&A.bb(b.x)
if(r)return b
else if(s===1)return t.P}q=new A.a2(null,null)
q.w=6
q.x=b
q.as=c
return A.as(a,q)},
fw(a,b,c){var s,r=b.as+"/",q=a.eC.get(r)
if(q!=null)return q
s=A.ib(a,b,r,c)
a.eC.set(r,s)
return s},
ib(a,b,c,d){var s,r
if(d){s=b.w
if(A.aN(b)||b===t.K)return b
else if(s===1)return A.bW(a,"a1",[b])
else if(b===t.P||b===t.u)return t.bc}r=new A.a2(null,null)
r.w=7
r.x=b
r.as=c
return A.as(a,r)},
ie(a,b){var s,r,q=""+b+"^",p=a.eC.get(q)
if(p!=null)return p
s=new A.a2(null,null)
s.w=13
s.x=b
s.as=q
r=A.as(a,s)
a.eC.set(q,r)
return r},
bV(a){var s,r,q,p=a.length
for(s="",r="",q=0;q<p;++q,r=",")s+=r+a[q].as
return s},
ia(a){var s,r,q,p,o,n=a.length
for(s="",r="",q=0;q<n;q+=3,r=","){p=a[q]
o=a[q+1]?"!":":"
s+=r+p+o+a[q+2].as}return s},
bW(a,b,c){var s,r,q,p=b
if(c.length>0)p+="<"+A.bV(c)+">"
s=a.eC.get(p)
if(s!=null)return s
r=new A.a2(null,null)
r.w=8
r.x=b
r.y=c
if(c.length>0)r.c=c[0]
r.as=p
q=A.as(a,r)
a.eC.set(p,q)
return q},
eG(a,b,c){var s,r,q,p,o,n
if(b.w===9){s=b.x
r=b.y.concat(c)}else{r=c
s=b}q=s.as+(";<"+A.bV(r)+">")
p=a.eC.get(q)
if(p!=null)return p
o=new A.a2(null,null)
o.w=9
o.x=s
o.y=r
o.as=q
n=A.as(a,o)
a.eC.set(q,n)
return n},
fy(a,b,c){var s,r,q="+"+(b+"("+A.bV(c)+")"),p=a.eC.get(q)
if(p!=null)return p
s=new A.a2(null,null)
s.w=10
s.x=b
s.y=c
s.as=q
r=A.as(a,s)
a.eC.set(q,r)
return r},
fv(a,b,c){var s,r,q,p,o,n=b.as,m=c.a,l=m.length,k=c.b,j=k.length,i=c.c,h=i.length,g="("+A.bV(m)
if(j>0){s=l>0?",":""
g+=s+"["+A.bV(k)+"]"}if(h>0){s=l>0?",":""
g+=s+"{"+A.ia(i)+"}"}r=n+(g+")")
q=a.eC.get(r)
if(q!=null)return q
p=new A.a2(null,null)
p.w=11
p.x=b
p.y=c
p.as=r
o=A.as(a,p)
a.eC.set(r,o)
return o},
eH(a,b,c,d){var s,r=b.as+("<"+A.bV(c)+">"),q=a.eC.get(r)
if(q!=null)return q
s=A.ic(a,b,c,r,d)
a.eC.set(r,s)
return s},
ic(a,b,c,d,e){var s,r,q,p,o,n,m,l
if(e){s=c.length
r=A.dQ(s)
for(q=0,p=0;p<s;++p){o=c[p]
if(o.w===1){r[p]=o;++q}}if(q>0){n=A.aL(a,b,r,0)
m=A.b7(a,c,r,0)
return A.eH(a,n,m,c!==m)}}l=new A.a2(null,null)
l.w=12
l.x=b
l.y=c
l.as=d
return A.as(a,l)},
i1(a,b,c,d){return{u:a,e:b,r:c,s:[],p:0,n:d}},
i7(a){var s,r,q,p,o,n,m,l=a.r,k=a.s
for(s=l.length,r=0;r<s;){q=l.charCodeAt(r)
if(q>=48&&q<=57)r=A.i3(r+1,q,l,k)
else if((((q|32)>>>0)-97&65535)<26||q===95||q===36||q===124)r=A.fs(a,r,l,k,!1)
else if(q===46)r=A.fs(a,r,l,k,!0)
else{++r
switch(q){case 44:break
case 58:k.push(!1)
break
case 33:k.push(!0)
break
case 59:k.push(A.aJ(a.u,a.e,k.pop()))
break
case 94:k.push(A.ie(a.u,k.pop()))
break
case 35:k.push(A.bX(a.u,5,"#"))
break
case 64:k.push(A.bX(a.u,2,"@"))
break
case 126:k.push(A.bX(a.u,3,"~"))
break
case 60:k.push(a.p)
a.p=k.length
break
case 62:A.i5(a,k)
break
case 38:A.i4(a,k)
break
case 63:p=a.u
k.push(A.fx(p,A.aJ(p,a.e,k.pop()),a.n))
break
case 47:p=a.u
k.push(A.fw(p,A.aJ(p,a.e,k.pop()),a.n))
break
case 40:k.push(-3)
k.push(a.p)
a.p=k.length
break
case 41:A.i2(a,k)
break
case 91:k.push(a.p)
a.p=k.length
break
case 93:o=k.splice(a.p)
A.ft(a.u,a.e,o)
a.p=k.pop()
k.push(o)
k.push(-1)
break
case 123:k.push(a.p)
a.p=k.length
break
case 125:o=k.splice(a.p)
A.i8(a.u,a.e,o)
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
i3(a,b,c,d){var s,r,q=b-48
for(s=c.length;a<s;++a){r=c.charCodeAt(a)
if(!(r>=48&&r<=57))break
q=q*10+(r-48)}d.push(q)
return a},
fs(a,b,c,d,e){var s,r,q,p,o,n,m=b+1
for(s=c.length;m<s;++m){r=c.charCodeAt(m)
if(r===46){if(e)break
e=!0}else{if(!((((r|32)>>>0)-97&65535)<26||r===95||r===36||r===124))q=r>=48&&r<=57
else q=!0
if(!q)break}}p=c.substring(b,m)
if(e){s=a.u
o=a.e
if(o.w===9)o=o.x
n=A.ik(s,o.x)[p]
if(n==null)A.X('No "'+p+'" in "'+A.hP(o)+'"')
d.push(A.dP(s,o,n))}else d.push(p)
return m},
i5(a,b){var s,r=a.u,q=A.fr(a,b),p=b.pop()
if(typeof p=="string")b.push(A.bW(r,p,q))
else{s=A.aJ(r,a.e,p)
switch(s.w){case 11:b.push(A.eH(r,s,q,a.n))
break
default:b.push(A.eG(r,s,q))
break}}},
i2(a,b){var s,r,q,p=a.u,o=b.pop(),n=null,m=null
if(typeof o=="number")switch(o){case-1:n=b.pop()
break
case-2:m=b.pop()
break
default:b.push(o)
break}else b.push(o)
s=A.fr(a,b)
o=b.pop()
switch(o){case-3:o=b.pop()
if(n==null)n=p.sEA
if(m==null)m=p.sEA
r=A.aJ(p,a.e,o)
q=new A.cG()
q.a=s
q.b=n
q.c=m
b.push(A.fv(p,r,q))
return
case-4:b.push(A.fy(p,b.pop(),s))
return
default:throw A.d(A.c2("Unexpected state under `()`: "+A.c(o)))}},
i4(a,b){var s=b.pop()
if(0===s){b.push(A.bX(a.u,1,"0&"))
return}if(1===s){b.push(A.bX(a.u,4,"1&"))
return}throw A.d(A.c2("Unexpected extended operation "+A.c(s)))},
fr(a,b){var s=b.splice(a.p)
A.ft(a.u,a.e,s)
a.p=b.pop()
return s},
aJ(a,b,c){if(typeof c=="string")return A.bW(a,c,a.sEA)
else if(typeof c=="number"){b.toString
return A.i6(a,b,c)}else return c},
ft(a,b,c){var s,r=c.length
for(s=0;s<r;++s)c[s]=A.aJ(a,b,c[s])},
i8(a,b,c){var s,r=c.length
for(s=2;s<r;s+=3)c[s]=A.aJ(a,b,c[s])},
i6(a,b,c){var s,r,q=b.w
if(q===9){if(c===0)return b.x
s=b.y
r=s.length
if(c<=r)return s[c-1]
c-=r
b=b.x
q=b.w}else if(c===0)return b
if(q!==8)throw A.d(A.c2("Indexed base must be an interface type"))
s=b.y
if(c<=s.length)return s[c-1]
throw A.d(A.c2("Bad index "+c+" for "+b.k(0)))},
jp(a,b,c){var s,r=b.d
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
return A.A(a,A.eC(a,b),c,d,e)}if(s===6)return A.A(a,p,c,d,e)&&A.A(a,b.x,c,d,e)
if(q===7){if(A.A(a,b,c,d.x,e))return!0
return A.A(a,b,c,A.eC(a,d),e)}if(q===6)return A.A(a,b,c,p,e)||A.A(a,b,c,d.x,e)
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
if(!A.A(a,j,c,i,e)||!A.A(a,i,e,j,c))return!1}return A.fI(a,b.x,c,d.x,e)}if(q===11){if(b===t.g)return!0
if(p)return!1
return A.fI(a,b,c,d,e)}if(s===8){if(q!==8)return!1
return A.iG(a,b,c,d,e)}if(o&&q===10)return A.iL(a,b,c,d,e)
return!1},
fI(a3,a4,a5,a6,a7){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2
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
iG(a,b,c,d,e){var s,r,q,p,o,n=b.x,m=d.x
while(n!==m){s=a.tR[n]
if(s==null)return!1
if(typeof s=="string"){n=s
continue}r=s[m]
if(r==null)return!1
q=r.length
p=q>0?new Array(q):v.typeUniverse.sEA
for(o=0;o<q;++o)p[o]=A.dP(a,b,r[o])
return A.fB(a,p,null,c,d.y,e)}return A.fB(a,b.y,null,c,d.y,e)},
fB(a,b,c,d,e,f){var s,r=b.length
for(s=0;s<r;++s)if(!A.A(a,b[s],d,e[s],f))return!1
return!0},
iL(a,b,c,d,e){var s,r=b.y,q=d.y,p=r.length
if(p!==q.length)return!1
if(b.x!==d.x)return!1
for(s=0;s<p;++s)if(!A.A(a,r[s],c,q[s],e))return!1
return!0},
bb(a){var s=a.w,r=!0
if(!(a===t.P||a===t.u))if(!A.aN(a))if(s!==6)r=s===7&&A.bb(a.x)
return r},
aN(a){var s=a.w
return s===2||s===3||s===4||s===5||a===t.X},
fA(a,b){var s,r,q=Object.keys(b),p=q.length
for(s=0;s<p;++s){r=q[s]
a[r]=b[r]}},
dQ(a){return a>0?new Array(a):v.typeUniverse.sEA},
a2:function a2(a,b){var _=this
_.a=a
_.b=b
_.r=_.f=_.d=_.c=null
_.w=0
_.as=_.Q=_.z=_.y=_.x=null},
cG:function cG(){this.c=this.b=this.a=null},
dN:function dN(a){this.a=a},
cF:function cF(){},
bU:function bU(a){this.a=a},
hT(){var s,r,q
if(self.scheduleImmediate!=null)return A.j5()
if(self.MutationObserver!=null&&self.document!=null){s={}
r=self.document.createElement("div")
q=self.document.createElement("span")
s.a=null
new self.MutationObserver(A.c_(new A.dq(s),1)).observe(r,{childList:true})
return new A.dp(s,r,q)}else if(self.setImmediate!=null)return A.j6()
return A.j7()},
hU(a){self.scheduleImmediate(A.c_(new A.dr(t.M.a(a)),0))},
hV(a){self.setImmediate(A.c_(new A.ds(t.M.a(a)),0))},
hW(a){t.M.a(a)
A.i9(0,a)},
i9(a,b){var s=new A.dL()
s.bl(a,b)
return s},
F(a){return new A.cC(new A.x($.t,a.h("x<0>")),a.h("cC<0>"))},
E(a,b){a.$2(0,null)
b.b=!0
return b.a},
m(a,b){A.iq(a,b)},
D(a,b){b.aA(a)},
C(a,b){b.aB(A.L(a),A.ag(a))},
iq(a,b){var s,r,q=new A.dS(b),p=new A.dT(b)
if(a instanceof A.x)a.b1(q,p,t.z)
else{s=t.z
if(a instanceof A.x)a.bc(q,p,s)
else{r=new A.x($.t,t._)
r.a=8
r.c=a
r.b1(q,p,s)}}},
G(a){var s=function(b,c){return function(d,e){while(true){try{b(d,e)
break}catch(q){e=q
d=c}}}}(a,1),r=$.t
return r.aw(r,t.aS.a(new A.dW(s)),t.H,t.S,t.z)},
cQ(a){var s
if(t.C.b(a)){s=a.gO()
if(s!=null)return s}return B.o},
iC(a,b){var s=$.t
if(s===B.l)return null
s.bt(s,a,b)
return null},
iD(a,b){if($.t!==B.l)A.iC(a,b)
if(b==null)if(t.C.b(a)){b=a.gO()
if(b==null){A.fe(a,B.o)
b=B.o}}else b=B.o
else if(t.C.b(a))A.fe(a,b)
return new A.O(a,b)},
eD(a,b,c){var s,r,q,p,o,n={},m=n.a=a
for(s=t._;r=m.a,(r&4)!==0;m=a){a=s.a(m.c)
n.a=a}if(m===b){s=A.fi()
b.aj(new A.O(new A.a_(!0,m,null,"Cannot complete a future with itself"),s))
return}q=b.a&1
s=m.a=r|q
if((s&24)===0){p=t.F.a(b.c)
b.a=b.a&1|4
b.c=m
m.b_(p)
return}if(!c)if(b.c==null)m=(s&16)===0||q!==0
else m=!1
else m=!0
if(m){p=b.R()
b.a1(n.a)
A.aI(b,p)
return}b.a^=2
o=b.b
o.S(o,new A.dA(n,b))},
aI(a,b){var s,r,q,p,o,n,m,l,k,j,i,h,g,f,e={},d=e.a=a
for(s=t.n,r=t.F;;){q={}
p=d.a
o=(p&16)===0
n=!o
if(b==null){if(n&&(p&1)===0){m=s.a(d.c)
d=d.b
d.P(d,m.a,m.b)}return}q.a=b
l=b.a
for(d=b;l!=null;d=l,l=k){d.a=null
A.aI(e.a,d)
q.a=l
k=l.a}j=e.a.c
q.b=n
q.c=j
if(o){p=d.c
p=(p&1)!==0||(p&15)===8}else p=!0
if(p){i=d.b.b
h=$.t
if(h!==i)$.t=i
else h=null
d=d.c
if((d&15)===8)new A.dE(q,e,n).$0()
else if(o){if((d&1)!==0)new A.dD(q,j).$0()}else if((d&2)!==0)new A.dC(e,q).$0()
if(h!=null)$.t=h
d=q.c
if(d instanceof A.x){p=q.a.$ti
p=p.h("a1<2>").b(d)||!p.y[1].b(d)}else p=!1
if(p){g=q.a.b
if((d.a&24)!==0){f=r.a(g.c)
g.c=null
b=g.a6(f)
g.a=d.a&30|g.a&1
g.c=d.c
e.a=d
continue}else A.eD(d,g,!0)
return}}g=q.a.b
f=r.a(g.c)
g.c=null
b=g.a6(f)
d=q.b
p=q.c
if(!d){g.$ti.c.a(p)
g.a=8
g.c=p}else{s.a(p)
g.a=g.a&1|16
g.c=p}e.a=g
d=g}},
iU(a,b){var s=t.Q
if(s.b(a))return b.aw(b,s.a(a),t.z,t.K,t.l)
s=t.v
if(s.b(a))return b.a5(b,s.a(a),t.z,t.K)
throw A.d(A.ex(a,"onError",u.c))},
iQ(){var s,r
for(s=$.b6;s!=null;s=$.b6){$.bZ=null
r=s.b
$.b6=r
if(r==null)$.bY=null
s.a.$0()}},
iZ(){$.eL=!0
try{A.iQ()}finally{$.bZ=null
$.eL=!1
if($.b6!=null)$.eV().$1(A.fS())}},
fQ(a){var s=new A.cD(a),r=$.bY
if(r==null){$.b6=$.bY=s
if(!$.eL)$.eV().$1(A.fS())}else $.bY=r.b=s},
iW(a){var s,r,q,p=$.b6
if(p==null){A.fQ(a)
$.bZ=$.bY
return}s=new A.cD(a)
r=$.bZ
if(r==null){s.b=p
$.b6=$.bZ=s}else{q=r.b
s.b=q
$.bZ=r.b=s
if(q==null)$.bY=s}},
h0(a){var s=$.t
if(B.l===s){A.eM(B.l,a)
return}A.eM(s,s.a4(s,a,t.H))
return},
jF(a,b){A.eO(a,"stream",t.K)
return new A.cI(b.h("cI<0>"))},
fP(a){return},
i0(a,b){if(b==null)b=A.j9()
if(t.aD.b(b))return a.aw(a,t.Q.a(b),t.z,t.K,t.l)
if(t.bo.b(b))return a.a5(a,t.v.a(b),t.z,t.K)
throw A.d(A.a6("handleError callback must take either an Object (the error), or both an Object (the error) and a StackTrace.",null))},
iS(a,b){var s=$.t
s.P(s,a,b)},
iR(){},
iV(a,b){A.iW(new A.dV(a,b))},
eM(a,b){if(B.l!==a)b=a.bK(b,t.H)
A.fQ(b)},
dq:function dq(a){this.a=a},
dp:function dp(a,b,c){this.a=a
this.b=b
this.c=c},
dr:function dr(a){this.a=a},
ds:function ds(a){this.a=a},
dL:function dL(){},
dM:function dM(a,b){this.a=a
this.b=b},
cC:function cC(a,b){this.a=a
this.b=!1
this.$ti=b},
dS:function dS(a){this.a=a},
dT:function dT(a){this.a=a},
dW:function dW(a){this.a=a},
O:function O(a,b){this.a=a
this.b=b},
b1:function b1(a,b){this.a=a
this.$ti=b},
aq:function aq(a,b,c,d,e){var _=this
_.ay=0
_.CW=_.ch=null
_.w=a
_.a=b
_.d=c
_.e=d
_.r=null
_.$ti=e},
aG:function aG(){},
bT:function bT(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.e=_.d=null
_.$ti=c},
dK:function dK(a,b){this.a=a
this.b=b},
cE:function cE(){},
bG:function bG(a,b){this.a=a
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
dx:function dx(a,b){this.a=a
this.b=b},
dB:function dB(a,b){this.a=a
this.b=b},
dA:function dA(a,b){this.a=a
this.b=b},
dz:function dz(a,b){this.a=a
this.b=b},
dy:function dy(a,b){this.a=a
this.b=b},
dE:function dE(a,b,c){this.a=a
this.b=b
this.c=c},
dF:function dF(a,b){this.a=a
this.b=b},
dG:function dG(a){this.a=a},
dD:function dD(a,b){this.a=a
this.b=b},
dC:function dC(a,b){this.a=a
this.b=b},
cD:function cD(a){this.a=a
this.b=null},
b_:function b_(){},
df:function df(a,b){this.a=a
this.b=b},
dg:function dg(a,b){this.a=a
this.b=b},
bH:function bH(){},
bI:function bI(){},
ae:function ae(){},
b5:function b5(){},
bK:function bK(){},
bJ:function bJ(a,b){this.b=a
this.a=null
this.$ti=b},
cH:function cH(a){var _=this
_.a=0
_.c=_.b=null
_.$ti=a},
dJ:function dJ(a,b){this.a=a
this.b=b},
b3:function b3(a,b){var _=this
_.a=1
_.b=a
_.c=null
_.$ti=b},
cI:function cI(a){this.$ti=a},
dm:function dm(){},
dn:function dn(a,b,c){this.a=a
this.b=b
this.c=c},
dV:function dV(a,b){this.a=a
this.b=b},
fq(a,b){var s=a[b]
return s===a?null:s},
eF(a,b,c){if(c==null)a[b]=a
else a[b]=c},
eE(){var s=Object.create(null)
A.eF(s,"<non-identifier-key>",s)
delete s["<non-identifier-key>"]
return s},
j(a,b,c){return b.h("@<0>").l(c).h("f5<1,2>").a(A.jd(a,new A.aA(b.h("@<0>").l(c).h("aA<1,2>"))))},
bp(a,b){return new A.aA(a.h("@<0>").l(b).h("aA<1,2>"))},
f9(a){var s,r
if(A.eR(a))return"{...}"
s=new A.cx("")
try{r={}
B.d.u($.S,a)
s.a+="{"
r.a=!0
a.aD(0,new A.da(r,s))
s.a+="}"}finally{if(0>=$.S.length)return A.e($.S,-1)
$.S.pop()}r=s.a
return r.charCodeAt(0)==0?r:r},
bL:function bL(){},
b4:function b4(a){var _=this
_.a=0
_.e=_.d=_.c=_.b=null
_.$ti=a},
bM:function bM(a,b){this.a=a
this.$ti=b},
bN:function bN(a,b,c){var _=this
_.a=a
_.b=b
_.c=0
_.d=null
_.$ti=c},
u:function u(){},
aD:function aD(){},
da:function da(a,b){this.a=a
this.b=b},
i_(a,b,c,d,e,f,g,a0){var s,r,q,p,o,n,m,l,k,j,i=a0>>>2,h=3-(a0&3)
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
throw A.d(A.ex(b,"Not a byte value at index "+p+": 0x"+B.h.c5(b[p],16),null))},
hZ(a,b,c,d,a0,a1){var s,r,q,p,o,n,m,l,k,j,i="Invalid encoding before padding",h="Invalid character",g=B.h.a9(a1,2),f=a1&3,e=$.hf()
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
return A.fo(a,p+1,c,-j-1)}throw A.d(A.aS(h,a,p))}if(o>=0&&o<=127)return(g<<2|f)>>>0
for(p=b;p<c;++p){if(!(p<s))return A.e(a,p)
if(a.charCodeAt(p)>127)break}throw A.d(A.aS(h,a,p))},
hX(a,b,c,d){var s=A.hY(a,b,c),r=(d&3)+(s-b),q=B.h.a9(r,2)*3,p=r&3
if(p!==0&&s<c)q+=p-1
if(q>0)return new Uint8Array(q)
return $.he()},
hY(a,b,c){var s,r=a.length,q=c,p=q,o=0
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
fo(a,b,c,d){var s,r,q
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
c3:function c3(){},
cS:function cS(){},
du:function du(a){this.a=0
this.b=a},
cR:function cR(){},
dt:function dt(){this.a=0},
aw:function aw(){},
c7:function c7(){},
ht(a,b){a=A.B(a,new Error())
if(a==null)a=A.N(a)
a.stack=b.k(0)
throw a},
f7(a,b,c,d){var s,r=c?J.hx(a,d):J.hw(a,d)
if(a!==0&&b!=null)for(s=0;s<r.length;++s)r[s]=b
return r},
f6(a,b){var s,r=A.K([],b.h("y<0>"))
for(s=J.ev(a);s.p();)B.d.u(r,s.gn())
return r},
hQ(a){var s
A.ff(0,"start")
s=A.hR(a,0,null)
return s},
hR(a,b,c){var s=a.length
if(b>=s)return""
return A.hN(a,b,s)},
fk(a,b,c){var s=J.ev(b)
if(!s.p())return a
if(c.length===0){do a+=A.c(s.gn())
while(s.p())}else{a+=A.c(s.gn())
while(s.p())a=a+c+A.c(s.gn())}return a},
fi(){return A.ag(new Error())},
hs(a){var s=Math.abs(a),r=a<0?"-":""
if(s>=1000)return""+a
if(s>=100)return r+"0"+s
if(s>=10)return r+"00"+s
return r+"000"+s},
f3(a){if(a>=100)return""+a
if(a>=10)return"0"+a
return"00"+a},
c9(a){if(a>=10)return""+a
return"0"+a},
cV(a){if(typeof a=="number"||A.dU(a)||a==null)return J.T(a)
if(typeof a=="string")return JSON.stringify(a)
return A.hM(a)},
hu(a,b){A.eO(a,"error",t.K)
A.eO(b,"stackTrace",t.l)
A.ht(a,b)},
c2(a){return new A.c1(a)},
a6(a,b){return new A.a_(!1,null,b,a)},
ex(a,b,c){return new A.a_(!0,a,b,c)},
hO(a,b){return new A.aZ(null,null,!0,a,b,"Value not in range")},
ab(a,b,c,d,e){return new A.aZ(b,c,!0,a,d,"Invalid value")},
fg(a,b,c){if(0>a||a>c)throw A.d(A.ab(a,0,c,"start",null))
if(b!=null){if(a>b||b>c)throw A.d(A.ab(b,a,c,"end",null))
return b}return c},
ff(a,b){if(a<0)throw A.d(A.ab(a,0,null,b,null))
return a},
f4(a,b,c,d){return new A.ca(b,!0,a,d,"Index out of range")},
bE(a){return new A.bD(a)},
fn(a){return new A.cA(a)},
cv(a){return new A.aE(a)},
bf(a){return new A.c6(a)},
U(a){return new A.dw(a)},
aS(a,b,c){return new A.cY(a,b,c)},
hv(a,b,c){var s,r
if(A.eR(a)){if(b==="("&&c===")")return"(...)"
return b+"..."+c}s=A.K([],t.s)
B.d.u($.S,a)
try{A.iP(a,s)}finally{if(0>=$.S.length)return A.e($.S,-1)
$.S.pop()}r=A.fk(b,t.R.a(s),", ")+c
return r.charCodeAt(0)==0?r:r},
d4(a,b,c){var s,r
if(A.eR(a))return b+"..."+c
s=new A.cx(b)
B.d.u($.S,a)
try{r=s
r.a=A.fk(r.a,a,", ")}finally{if(0>=$.S.length)return A.e($.S,-1)
$.S.pop()}s.a+=c
r=s.a
return r.charCodeAt(0)==0?r:r},
iP(a,b){var s,r,q,p,o,n,m,l=a.gA(a),k=0,j=0
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
hD(a,b){var s=B.h.gt(a)
b=B.h.gt(b)
b=A.hS(A.fl(A.fl($.hg(),s),b))
return b},
c8:function c8(a,b,c){this.a=a
this.b=b
this.c=c},
dv:function dv(){},
w:function w(){},
c1:function c1(a){this.a=a},
ac:function ac(){},
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
ca:function ca(a,b,c,d,e){var _=this
_.f=a
_.a=b
_.b=c
_.c=d
_.d=e},
bD:function bD(a){this.a=a},
cA:function cA(a){this.a=a},
aE:function aE(a){this.a=a},
c6:function c6(a){this.a=a},
cq:function cq(){},
bB:function bB(){},
dw:function dw(a){this.a=a},
cY:function cY(a,b,c){this.a=a
this.b=b
this.c=c},
f:function f(){},
z:function z(){},
k:function k(){},
cJ:function cJ(){},
cx:function cx(a){this.a=a},
ez(a,b){var s,r,q,p,o
if(b.length===0)return!1
s=b.split(".")
r=v.G
for(q=s.length,p=0;p<q;++p,r=o){o=r[s[p]]
A.fC(o)
if(o==null)return!1}return a instanceof t.g.a(r)},
db:function db(a){this.a=a},
fG(a){var s
if(typeof a=="function")throw A.d(A.a6("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d){return b(c,d,arguments.length)}}(A.ir,a)
s[$.eq()]=a
return s},
fH(a){var s
if(typeof a=="function")throw A.d(A.a6("Attempting to rewrap a JS function.",null))
s=function(b,c){return function(d,e){return b(c,d,e,arguments.length)}}(A.is,a)
s[$.eq()]=a
return s},
ir(a,b,c){t.Z.a(a)
if(A.n(c)>=1)return a.$1(b)
return a.$0()},
is(a,b,c,d){t.Z.a(a)
A.n(d)
if(d>=2)return a.$2(b,c)
if(d===1)return a.$1(b)
return a.$0()},
fN(a){return a==null||A.dU(a)||typeof a=="number"||typeof a=="string"||t.U.b(a)||t.D.b(a)||t.ca.b(a)||t.O.b(a)||t.c0.b(a)||t.k.b(a)||t.bk.b(a)||t.G.b(a)||t.q.b(a)||t.J.b(a)||t.V.b(a)},
h(a){if(A.fN(a))return a
return new A.e9(new A.b4(t.A)).$1(a)},
eN(a,b,c,d){return d.a(a[b].apply(a,c))},
ai(a,b){var s=new A.x($.t,b.h("x<0>")),r=new A.bG(s,b.h("bG<0>"))
a.then(A.c_(new A.em(r,b),1),A.c_(new A.en(r),1))
return s},
fM(a){return a==null||typeof a==="boolean"||typeof a==="number"||typeof a==="string"||a instanceof Int8Array||a instanceof Uint8Array||a instanceof Uint8ClampedArray||a instanceof Int16Array||a instanceof Uint16Array||a instanceof Int32Array||a instanceof Uint32Array||a instanceof Float32Array||a instanceof Float64Array||a instanceof ArrayBuffer||a instanceof DataView},
fU(a){if(A.fM(a))return a
return new A.dX(new A.b4(t.A)).$1(a)},
e9:function e9(a){this.a=a},
em:function em(a,b){this.a=a
this.b=b},
en:function en(a){this.a=a},
dX:function dX(a){this.a=a},
dH:function dH(a){this.a=a},
ao:function ao(a,b){this.a=a
this.b=b},
aC:function aC(a,b,c){this.a=a
this.b=b
this.d=c},
d8(a){return $.hA.c1(a,new A.d9(a))},
aX:function aX(a,b,c){var _=this
_.a=a
_.b=b
_.c=null
_.d=c
_.f=null},
d9:function d9(a){this.a=a},
ak:function ak(a,b){this.a=a
this.b=b},
bh:function bh(a,b,c){this.a=a
this.b=b
this.c=c},
ax:function ax(a,b,c,d){var _=this
_.a=-1
_.b=a
_.c=b
_.d=c
_.e=0
_.f=d},
cT:function cT(a,b,c,d,e,f){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f},
cU:function cU(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
a0:function a0(a,b){this.a=a
this.b=b},
d0:function d0(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
am:function am(a,b,c,d,e,f,g){var _=this
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
cZ:function cZ(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
d_:function d_(a,b,c,d){var _=this
_.a=a
_.b=b
_.c=c
_.d=d},
fb(a,b,c){var s=new A.cr(a,c,b),r=a.f
if(r<=0||r>255)A.X(A.U("Invalid key ring size"))
s.b=t.bG.a(A.f7(r,null,!1,t.aF))
return s},
d6:function d6(a,b,c,d,e,f,g){var _=this
_.a=a
_.b=b
_.c=c
_.d=d
_.e=e
_.f=f
_.r=g},
ch:function ch(a,b,c,d){var _=this
_.a=a
_.c=b
_.d=c
_.e=null
_.f=d},
aW:function aW(a,b){this.a=a
this.b=b},
cr:function cr(a,b,c){var _=this
_.a=0
_.b=$
_.c=!1
_.d=a
_.e=b
_.f=c
_.r=0},
jn(a){return a===0||a===1||a===2||a===3||a===4||a===5||a===6||a===7||a===8||a===9||a===16||a===17||a===18||a===19||a===20||a===21},
jf(a,b,c){var s,r,q,p,o,n
for(s=b.length,r=a.length,q=c==="h265",p=0;p<s;++p){o=b[p]
if(q){if(!(o<r))return A.e(a,o)
if(A.jn(a[o]>>>1&63))return o+2}else{if(!(o<r))return A.e(a,o)
n=a[o]&31
if(n===5||n===1)return o+2}}return null},
je(a){var s,r,q,p,o,n=A.K([],t.t),m=a.length,l=m-3
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
jt(a,b){var s,r=A.je(a)
if(b==="unknown")return new A.ci(0,b)
s=A.jf(a,r,b)
if(s==null)throw A.d(A.U("Could not find NALU"))
return new A.ci(s,b)},
ci:function ci(a,b){this.a=a
this.b=b},
de:function de(){var _=this
_.a=0
_.b=null
_.d=_.c=0},
fY(a,b,c){var s,r,q=null,p=A.az($.aP,new A.e4(b),t.j)
if(p==null){$.v().i(B.f,"creating new cryptor for "+a+", trackId "+b,q,q)
s=A.b(v.G.self)
r=t.S
p=new A.am(A.bp(r,r),a,b,c.G(a),B.m,s,new A.de())
B.d.u($.aP,p)}else if(a!==p.b){s=c.G(a)
if(p.x!==B.j){$.v().i(B.f,"setParticipantId: lastError != CryptorError.kOk, reset state to kNew",q,q)
p.x=B.m}p.b=a
p.e=s
p.Q.bb()}return p},
fW(a,b,c){var s,r=A.az($.eU,new A.dZ(b),t.p)
if(r==null){$.v().i(B.f,"creating new cryptor for "+a+", dataCryptorId "+b,null,null)
s=A.b(v.G.self)
r=new A.ax(a,b,c.G(a),s)
B.d.u($.eU,r)}else if(a!==r.b){s=c.G(a)
r.b=a
r.d=s}return r},
jx(a){var s=A.az($.aP,new A.eo(a),t.j)
if(s!=null)s.b=null},
jy(a){var s=A.az($.eU,new A.ep(a),t.p)
if(s!=null)s.b=null},
eS(){var s=0,r=A.F(t.H),q,p
var $async$eS=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:p=$.cN()
if(p.b!=null)A.X(A.bE('Please set "hierarchicalLoggingEnabled" to true if you want to change the level on a non-root logger.'))
J.es(p.c,B.b)
p.c=B.b
p.aY().c_(new A.eg())
p=$.v()
p.i(B.f,"Worker created",null,null)
q=v.G
if("RTCTransformEvent" in A.b(q.self)){p.i(B.f,"setup RTCTransformEvent event handler",null,null)
A.b(q.self).onrtctransform=A.fG(new A.eh())}A.b(q.self).onmessage=A.fG(new A.ei(new A.ej()))
return A.D(null,r)}})
return A.E($async$eS,r)},
e4:function e4(a){this.a=a},
dZ:function dZ(a){this.a=a},
eo:function eo(a){this.a=a},
ep:function ep(a){this.a=a},
eg:function eg(){},
eh:function eh(){},
ej:function ej(){},
ea:function ea(a){this.a=a},
eb:function eb(a){this.a=a},
ec:function ec(a){this.a=a},
ed:function ed(a){this.a=a},
ee:function ee(a){this.a=a},
ef:function ef(a){this.a=a},
ei:function ei(a){this.a=a},
h1(a){return v.mangledGlobalNames[a]},
js(a){if(typeof dartPrint=="function"){dartPrint(a)
return}if(typeof console=="object"&&typeof console.log!="undefined"){console.log(a)
return}if(typeof print=="function"){print(a)
return}throw"Unable to print message: "+String(a)},
aj(a){throw A.B(A.hz(a),new Error())},
jv(a){throw A.B(new A.bm("Field '"+a+"' has been assigned during initialization."),new Error())},
az(a,b,c){var s,r,q
for(s=a.length,r=0;r<a.length;a.length===s||(0,A.c0)(a),++r){q=a[r]
if(b.$1(q))return q}return null},
fV(a,b){switch(a){case"HKDF":return A.j(["name","HKDF","salt",b,"hash","SHA-256","info",new Uint8Array(128)],t.N,t.z)
case"PBKDF2":return A.j(["name","PBKDF2","salt",b,"hash","SHA-256","iterations",1e5],t.N,t.z)
default:throw A.d(A.U("algorithm "+a+" is currently unsupported"))}}},B={}
var w=[A,J,B]
var $={}
A.eA.prototype={}
J.cb.prototype={
F(a,b){return a===b},
gt(a){return A.bz(a)},
k(a){return"Instance of '"+A.ct(a)+"'"},
gq(a){return A.au(A.eK(this))}}
J.cd.prototype={
k(a){return String(a)},
gt(a){return a?519018:218159},
gq(a){return A.au(t.y)},
$ip:1,
$iW:1}
J.bk.prototype={
F(a,b){return null==b},
k(a){return"null"},
gt(a){return 0},
$ip:1,
$iz:1}
J.bl.prototype={$iq:1}
J.an.prototype={
gt(a){return 0},
gq(a){return B.X},
k(a){return String(a)}}
J.cs.prototype={}
J.bC.prototype={}
J.a7.prototype={
k(a){var s=a[$.h3()]
if(s==null)s=a[$.eq()]
if(s==null)return this.bi(a)
return"JavaScript function for "+J.T(s)},
$iay:1}
J.aU.prototype={
gt(a){return 0},
k(a){return String(a)}}
J.aV.prototype={
gt(a){return 0},
k(a){return String(a)}}
J.y.prototype={
u(a,b){A.af(a).c.a(b)
a.$flags&1&&A.Y(a,29)
a.push(b)},
bJ(a,b){var s
A.af(a).h("f<1>").a(b)
a.$flags&1&&A.Y(a,"addAll",2)
for(s=b.gA(b);s.p();)a.push(s.gn())},
X(a,b,c){var s=A.af(a)
return new A.aa(a,s.l(c).h("1(2)").a(b),s.h("@<1>").l(c).h("aa<1,2>"))},
V(a,b){if(!(b>=0&&b<a.length))return A.e(a,b)
return a[b]},
bL(a,b){var s
for(s=0;s<a.length;++s)if(J.es(a[s],b))return!0
return!1},
k(a){return A.d4(a,"[","]")},
gA(a){return new J.bd(a,a.length,A.af(a).h("bd<1>"))},
gt(a){return A.bz(a)},
gm(a){return a.length},
j(a,b){A.n(b)
if(!(b>=0&&b<a.length))throw A.d(A.cM(a,b))
return a[b]},
v(a,b,c){A.af(a).c.a(c)
a.$flags&2&&A.Y(a)
if(!(b>=0&&b<a.length))throw A.d(A.cM(a,b))
a[b]=c},
gq(a){return A.au(A.af(a))},
$il:1,
$if:1,
$ir:1}
J.cc.prototype={
c6(a){var s,r,q
if(!Array.isArray(a))return null
s=a.$flags|0
if((s&4)!==0)r="const, "
else if((s&2)!==0)r="unmodifiable, "
else r=(s&1)!==0?"fixed, ":""
q="Instance of '"+A.ct(a)+"'"
if(r==="")return q
return q+" ("+r+"length: "+a.length+")"}}
J.d5.prototype={}
J.bd.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s,r=this,q=r.a,p=q.length
if(r.b!==p){q=A.c0(q)
throw A.d(q)}s=r.c
if(s>=p){r.d=null
return!1}r.d=q[s]
r.c=s+1
return!0},
$ia4:1}
J.cf.prototype={
bd(a){var s
if(a>=-2147483648&&a<=2147483647)return a|0
if(isFinite(a)){s=a<0?Math.ceil(a):Math.floor(a)
return s+0}throw A.d(A.bE(""+a+".toInt()"))},
c5(a,b){var s,r,q,p,o
if(b<2||b>36)throw A.d(A.ab(b,2,36,"radix",null))
s=a.toString(b)
r=s.length
q=r-1
if(!(q>=0))return A.e(s,q)
if(s.charCodeAt(q)!==41)return s
p=/^([\da-z]+)(?:\.([\da-z]+))?\(e\+(\d+)\)$/.exec(s)
if(p==null)A.X(A.bE("Unexpected toString result: "+s))
r=p.length
if(1>=r)return A.e(p,1)
s=p[1]
if(3>=r)return A.e(p,3)
o=+p[3]
r=p[2]
if(r!=null){s+=r
o-=r.length}return s+B.k.aJ("0",o)},
k(a){if(a===0&&1/a<0)return"-0.0"
else return""+a},
gt(a){var s,r,q,p,o=a|0
if(a===o)return o&536870911
s=Math.abs(a)
r=Math.log(s)/0.6931471805599453|0
q=Math.pow(2,r)
p=s<1?s/q:q/s
return((p*9007199254740992|0)+(p*3542243181176521|0))*599197+r*1259&536870911},
af(a,b){var s=a%b
if(s===0)return 0
if(s>0)return s
return s+b},
bG(a,b){return(a|0)===a?a/b|0:this.bH(a,b)},
bH(a,b){var s=a/b
if(s>=-2147483648&&s<=2147483647)return s|0
if(s>0){if(s!==1/0)return Math.floor(s)}else if(s>-1/0)return Math.ceil(s)
throw A.d(A.bE("Result of truncating division is "+A.c(s)+": "+A.c(a)+" ~/ "+b))},
a9(a,b){var s
if(a>0)s=this.bE(a,b)
else{s=b>31?31:b
s=a>>s>>>0}return s},
bE(a,b){return b>31?0:a>>>b},
gq(a){return A.au(t.o)},
$io:1,
$iaO:1}
J.bj.prototype={
gq(a){return A.au(t.S)},
$ip:1,
$ia:1}
J.ce.prototype={
gq(a){return A.au(t.i)},
$ip:1}
J.aT.prototype={
bU(a,b){var s=b.length,r=a.length
if(s>r)return!1
return b===this.aN(a,r-s)},
bh(a,b){var s=b.length
if(s>a.length)return!1
return b===a.substring(0,s)},
a0(a,b,c){return a.substring(b,A.fg(b,c,a.length))},
aN(a,b){return this.a0(a,b,null)},
aJ(a,b){var s,r
if(0>=b)return""
if(b===1||a.length===0)return a
if(b!==b>>>0)throw A.d(B.L)
for(s=a,r="";;){if((b&1)===1)r=s+r
b=b>>>1
if(b===0)break
s+=s}return r},
bY(a,b){var s=a.length,r=b.length
if(s+r>s)s-=r
return a.lastIndexOf(b,s)},
k(a){return a},
gt(a){var s,r,q
for(s=a.length,r=0,q=0;q<s;++q){r=r+a.charCodeAt(q)&536870911
r=r+((r&524287)<<10)&536870911
r^=r>>6}r=r+((r&67108863)<<3)&536870911
r^=r>>11
return r+((r&16383)<<15)&536870911},
gq(a){return A.au(t.N)},
gm(a){return a.length},
j(a,b){A.n(b)
if(!(b.c8(0,0)&&b.c9(0,a.length)))throw A.d(A.cM(a,b))
return a[b]},
$ip:1,
$ifc:1,
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
n|=B.h.a9(n,1)
n|=n>>>2
n|=n>>>4
n|=n>>>8
o=((n|n>>>16)>>>0)+1}m=new Uint8Array(o)
B.e.aL(m,0,p,q)
l.b=m
q=m}B.e.aL(q,l.a,r,b)
l.a=r},
aG(){var s=this
if(s.a===0)return $.cO()
return new Uint8Array(A.at(J.eY(B.e.gH(s.b),s.b.byteOffset,s.a)))},
gm(a){return this.a},
$ihm:1}
A.bm.prototype={
k(a){return"LateInitializationError: "+this.a}}
A.dd.prototype={}
A.l.prototype={}
A.a8.prototype={
gA(a){var s=this
return new A.aB(s,s.gm(s),A.J(s).h("aB<a8.E>"))},
X(a,b,c){var s=A.J(this)
return new A.aa(this,s.l(c).h("1(a8.E)").a(b),s.h("@<a8.E>").l(c).h("aa<1,2>"))}}
A.aB.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s,r=this,q=r.a,p=J.e_(q),o=p.gm(q)
if(r.b!==o)throw A.d(A.bf(q))
s=r.c
if(s>=o){r.d=null
return!1}r.d=p.V(q,s);++r.c
return!0},
$ia4:1}
A.a9.prototype={
gA(a){var s=this.a
return new A.br(s.gA(s),this.b,A.J(this).h("br<1,2>"))},
gm(a){var s=this.a
return s.gm(s)}}
A.bg.prototype={$il:1}
A.br.prototype={
p(){var s=this,r=s.b
if(r.p()){s.a=s.c.$1(r.gn())
return!0}s.a=null
return!1},
gn(){var s=this.a
return s==null?this.$ti.y[1].a(s):s},
$ia4:1}
A.aa.prototype={
gm(a){return J.aQ(this.a)},
V(a,b){return this.b.$1(J.hi(this.a,b))}}
A.aF.prototype={
gA(a){return new A.bF(J.ev(this.a),this.b,this.$ti.h("bF<1>"))},
X(a,b,c){var s=this.$ti
return new A.a9(this,s.l(c).h("1(2)").a(b),s.h("@<1>").l(c).h("a9<1,2>"))}}
A.bF.prototype={
p(){var s,r
for(s=this.a,r=this.b;s.p();)if(r.$1(s.gn()))return!0
return!1},
gn(){return this.a.gn()},
$ia4:1}
A.M.prototype={}
A.bA.prototype={}
A.dh.prototype={
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
A.by.prototype={
k(a){return"Null check operator used on a null value"}}
A.cg.prototype={
k(a){var s,r=this,q="NoSuchMethodError: method not found: '",p=r.b
if(p==null)return"NoSuchMethodError: "+r.a
s=r.c
if(s==null)return q+p+"' ("+r.a+")"
return q+p+"' on '"+s+"' ("+r.a+")"}}
A.cB.prototype={
k(a){var s=this.a
return s.length===0?"Error":"Error: "+s}}
A.dc.prototype={
k(a){return"Throw of null ('"+(this.a===null?"null":"undefined")+"' from JavaScript)"}}
A.bi.prototype={}
A.bS.prototype={
k(a){var s,r=this.b
if(r!=null)return r
r=this.a
s=r!==null&&typeof r==="object"?r.stack:null
return this.b=s==null?"":s},
$ia3:1}
A.al.prototype={
k(a){var s=this.constructor,r=s==null?null:s.name
return"Closure '"+A.h2(r==null?"unknown":r)+"'"},
$iay:1,
gc7(){return this},
$C:"$1",
$R:1,
$D:null}
A.c4.prototype={$C:"$0",$R:0}
A.c5.prototype={$C:"$2",$R:2}
A.cy.prototype={}
A.cw.prototype={
k(a){var s=this.$static_name
if(s==null)return"Closure of unknown static method"
return"Closure '"+A.h2(s)+"'"}}
A.aR.prototype={
F(a,b){if(b==null)return!1
if(this===b)return!0
if(!(b instanceof A.aR))return!1
return this.$_target===b.$_target&&this.a===b.a},
gt(a){return(A.el(this.a)^A.bz(this.$_target))>>>0},
k(a){return"Closure '"+this.$_name+"' of "+("Instance of '"+A.ct(this.a)+"'")}}
A.cu.prototype={
k(a){return"RuntimeError: "+this.a}}
A.aA.prototype={
gm(a){return this.a},
gae(){return new A.bo(this,this.$ti.h("bo<1>"))},
ab(a){var s=this.b
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
return q}else return this.bX(b)},
bX(a){var s,r,q=this.d
if(q==null)return null
s=this.bw(q,a)
r=this.b7(s,a)
if(r<0)return null
return s[r].b},
v(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"){s=m.b
m.aO(s==null?m.b=m.ao():s,b,c)}else if(typeof b=="number"&&(b&0x3fffffff)===b){r=m.c
m.aO(r==null?m.c=m.ao():r,b,c)}else{q=m.d
if(q==null)q=m.d=m.ao()
p=J.cP(b)&1073741823
o=q[p]
if(o==null)q[p]=[m.ap(b,c)]
else{n=m.b7(o,b)
if(n>=0)o[n].b=c
else o.push(m.ap(b,c))}}},
c1(a,b){var s,r,q=this,p=q.$ti
p.c.a(a)
p.h("2()").a(b)
if(q.ab(a)){s=q.j(0,a)
return s==null?p.y[1].a(s):s}r=b.$0()
q.v(0,a,r)
return r},
c2(a,b){var s=this.bA(this.b,b)
return s},
aD(a,b){var s,r,q=this
q.$ti.h("~(1,2)").a(b)
s=q.e
r=q.r
while(s!=null){b.$2(s.a,s.b)
if(r!==q.r)throw A.d(A.bf(q))
s=s.c}},
aO(a,b,c){var s,r=this.$ti
r.c.a(b)
r.y[1].a(c)
s=a[b]
if(s==null)a[b]=this.ap(b,c)
else s.b=c},
bA(a,b){var s
if(a==null)return null
s=a[b]
if(s==null)return null
this.bI(s)
delete a[b]
return s.b},
aZ(){this.r=this.r+1&1073741823},
ap(a,b){var s=this,r=s.$ti,q=new A.d7(r.c.a(a),r.y[1].a(b))
if(s.e==null)s.e=s.f=q
else{r=s.f
r.toString
q.d=r
s.f=r.c=q}++s.a
s.aZ()
return q},
bI(a){var s=this,r=a.d,q=a.c
if(r==null)s.e=q
else r.c=q
if(q==null)s.f=r
else q.d=r;--s.a
s.aZ()},
bw(a,b){return a[J.cP(b)&1073741823]},
b7(a,b){var s,r
if(a==null)return-1
s=a.length
for(r=0;r<s;++r)if(J.es(a[r].a,b))return r
return-1},
k(a){return A.f9(this)},
ao(){var s=Object.create(null)
s["<non-identifier-key>"]=s
delete s["<non-identifier-key>"]
return s},
$if5:1}
A.d7.prototype={}
A.bo.prototype={
gm(a){return this.a.a},
gA(a){var s=this.a
return new A.bn(s,s.r,s.e,this.$ti.h("bn<1>"))}}
A.bn.prototype={
gn(){return this.d},
p(){var s,r=this,q=r.a
if(r.b!==q.r)throw A.d(A.bf(q))
s=r.c
if(s==null){r.d=null
return!1}else{r.d=s.a
r.c=s.c
return!0}},
$ia4:1}
A.e5.prototype={
$1(a){return this.a(a)},
$S:13}
A.e6.prototype={
$2(a,b){return this.a(a,b)},
$S:14}
A.e7.prototype={
$1(a){return this.a(A.i(a))},
$S:15}
A.ap.prototype={
gq(a){return B.Q},
aa(a,b,c){return c==null?new Uint8Array(a,b):new Uint8Array(a,b,c)},
b2(a){return this.aa(a,0,null)},
$ip:1,
$iap:1,
$ibe:1}
A.aY.prototype={$iaY:1}
A.bv.prototype={
gH(a){if(((a.$flags|0)&2)!==0)return new A.cK(a.buffer)
else return a.buffer},
bx(a,b,c,d){var s=A.ab(b,0,c,d,null)
throw A.d(s)},
aT(a,b,c,d){if(b>>>0!==b||b>c)this.bx(a,b,c,d)}}
A.cK.prototype={
aa(a,b,c){var s=A.I(this.a,b,c)
s.$flags=3
return s},
b2(a){return this.aa(0,0,null)},
$ibe:1}
A.bs.prototype={
gq(a){return B.R},
bD(a,b,c){return a.setInt8(b,c)},
$ip:1,
$iey:1}
A.H.prototype={
gm(a){return a.length},
$iP:1}
A.bt.prototype={
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$il:1,
$if:1,
$ir:1}
A.bu.prototype={
aL(a,b,c,d){var s,r,q,p
t.e.a(d)
a.$flags&2&&A.Y(a,5)
s=a.length
this.aT(a,b,s,"start")
this.aT(a,c,s,"end")
if(b>c)A.X(A.ab(b,0,c,null,null))
r=c-b
q=d.length
if(q<r)A.X(A.cv("Not enough elements"))
p=q!==r?d.subarray(0,r):d
a.set(p,b)
return},
$il:1,
$if:1,
$ir:1}
A.cj.prototype={
gq(a){return B.S},
$ip:1,
$icW:1}
A.ck.prototype={
gq(a){return B.T},
$ip:1,
$icX:1}
A.cl.prototype={
gq(a){return B.U},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$id1:1}
A.cm.prototype={
gq(a){return B.V},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$id2:1}
A.cn.prototype={
gq(a){return B.W},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$id3:1}
A.co.prototype={
gq(a){return B.Z},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$idj:1}
A.cp.prototype={
gq(a){return B.a_},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$idk:1}
A.bw.prototype={
gq(a){return B.a0},
gm(a){return a.length},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
$ip:1,
$idl:1}
A.bx.prototype={
gq(a){return B.a1},
gm(a){return a.length},
j(a,b){A.n(b)
A.aK(b,a,a.length)
return a[b]},
B(a,b,c){return new Uint8Array(a.subarray(b,A.it(b,c,a.length)))},
aM(a,b){return this.B(a,b,null)},
$ip:1,
$icz:1}
A.bO.prototype={}
A.bP.prototype={}
A.bQ.prototype={}
A.bR.prototype={}
A.a2.prototype={
h(a){return A.dP(v.typeUniverse,this,a)},
l(a){return A.ii(v.typeUniverse,this,a)}}
A.cG.prototype={}
A.dN.prototype={
k(a){return A.R(this.a,null)}}
A.cF.prototype={
k(a){return this.a}}
A.bU.prototype={$iac:1}
A.dq.prototype={
$1(a){var s=this.a,r=s.a
s.a=null
r.$0()},
$S:5}
A.dp.prototype={
$1(a){var s,r
this.a.a=t.M.a(a)
s=this.b
r=this.c
s.firstChild?s.removeChild(r):s.appendChild(r)},
$S:16}
A.dr.prototype={
$0(){this.a.$0()},
$S:6}
A.ds.prototype={
$0(){this.a.$0()},
$S:6}
A.dL.prototype={
bl(a,b){if(self.setTimeout!=null)self.setTimeout(A.c_(new A.dM(this,b),0),a)
else throw A.d(A.bE("`setTimeout()` not found."))}}
A.dM.prototype={
$0(){this.b.$0()},
$S:0}
A.cC.prototype={
aA(a){var s,r=this,q=r.$ti
q.h("1/?").a(a)
if(a==null)a=q.c.a(a)
if(!r.b)r.a.ai(a)
else{s=r.a
if(q.h("a1<1>").b(a))s.aS(a)
else s.aV(a)}},
aB(a,b){var s
if(b==null)b=A.cQ(a)
s=this.a
if(this.b)s.a2(new A.O(a,b))
else s.aj(new A.O(a,b))}}
A.dS.prototype={
$1(a){return this.a.$2(0,a)},
$S:3}
A.dT.prototype={
$2(a,b){this.a.$2(1,new A.bi(a,t.l.a(b)))},
$S:17}
A.dW.prototype={
$2(a,b){this.a(A.n(a),b)},
$S:18}
A.O.prototype={
k(a){return A.c(this.a)},
$iw:1,
gO(){return this.b}}
A.b1.prototype={}
A.aq.prototype={
aq(){},
ar(){},
sa3(a){this.ch=this.$ti.h("aq<1>?").a(a)},
sav(a){this.CW=this.$ti.h("aq<1>?").a(a)}}
A.aG.prototype={
gan(){return this.c<4},
bF(a,b,c,d){var s,r,q,p,o,n,m,l,k=this,j=A.J(k)
j.h("~(1)?").a(a)
t.Y.a(c)
if((k.c&4)!==0){s=$.t
j=new A.b3(s,j.h("b3<1>"))
A.h0(j.gby())
if(c!=null)j.c=s.a4(s,t.M.a(c),t.H)
return j}s=j.c
r=$.t
q=d?1:0
p=b!=null?32:0
o=t.H
s=r.a5(r,t.h.l(s).h("1(2)").a(a),o,s)
A.i0(r,b)
n=c==null?A.j8():c
r.a4(r,t.M.a(n),o)
j=j.h("aq<1>")
m=new A.aq(k,s,r,q|p,j)
m.CW=m
m.ch=m
j.a(m)
m.ay=k.c&1
l=k.e
k.e=m
m.sa3(null)
m.sav(l)
if(l==null)k.d=m
else l.sa3(m)
if(k.d==k.e)A.fP(k.a)
return m},
ag(){if((this.c&4)!==0)return new A.aE("Cannot add new events after calling close")
return new A.aE("Cannot add new events while doing an addStream")},
bu(a){var s,r,q,p,o,n=this,m=A.J(n)
m.h("~(ae<1>)").a(a)
s=n.c
if((s&2)!==0)throw A.d(A.cv(u.o))
r=n.d
if(r==null)return
q=s&1
n.c=s^3
for(m=m.h("aq<1>");r!=null;){s=r.ay
if((s&1)===q){r.ay=s|2
a.$1(r)
s=r.ay^=1
p=r.ch
if((s&4)!==0){m.a(r)
o=r.CW
if(o==null)n.d=p
else o.sa3(p)
if(p==null)n.e=o
else p.sav(o)
r.sav(r)
r.sa3(r)}r.ay&=4294967293
r=p}else r=r.ch}n.c&=4294967293
if(n.d==null)n.aR()},
aR(){if((this.c&4)!==0)if(null.gca())null.ai(null)
A.fP(this.b)},
$ifj:1,
$ifu:1,
$iar:1}
A.bT.prototype={
gan(){return A.aG.prototype.gan.call(this)&&(this.c&2)===0},
ag(){if((this.c&2)!==0)return new A.aE(u.o)
return this.bj()},
a8(a){var s,r=this
r.$ti.c.a(a)
s=r.d
if(s==null)return
if(s===r.e){r.c|=2
s.aP(a)
r.c&=4294967293
if(r.d==null)r.aR()
return}r.bu(new A.dK(r,a))}}
A.dK.prototype={
$1(a){this.a.$ti.h("ae<1>").a(a).aP(this.b)},
$S(){return this.a.$ti.h("~(ae<1>)")}}
A.cE.prototype={
aB(a,b){var s=this.a
if((s.a&30)!==0)throw A.d(A.cv("Future already completed"))
s.aj(A.iD(a,b))},
b3(a){return this.aB(a,null)}}
A.bG.prototype={
aA(a){var s,r=this.$ti
r.h("1/?").a(a)
s=this.a
if((s.a&30)!==0)throw A.d(A.cv("Future already completed"))
s.ai(r.h("1/").a(a))}}
A.aH.prototype={
c0(a){var s
if((this.c&15)!==6)return!0
s=this.b.b
return s.a7(s,t.c1.a(this.d),a.a,t.y,t.K)},
bW(a){var s,r=this,q=r.e,p=null,o=t.z,n=t.K,m=a.a,l=r.b.b
if(t.Q.b(q))p=l.bB(l,q,m,a.b,o,n,t.l)
else p=l.a7(l,t.v.a(q),m,o,n)
try{o=r.$ti.h("2/").a(p)
return o}catch(s){if(t.b7.b(A.L(s))){if((r.c&1)!==0)throw A.d(A.a6("The error handler of Future.then must return a value of the returned future's type","onError"))
throw A.d(A.a6("The error handler of Future.catchError must return a value of the future's type","onError"))}else throw s}}}
A.x.prototype={
bc(a,b,c){var s,r,q,p=this.$ti
p.l(c).h("1/(2)").a(a)
s=$.t
if(s===B.l){if(b!=null&&!t.Q.b(b)&&!t.v.b(b))throw A.d(A.ex(b,"onError",u.c))}else{r=p.c
a=s.a5(s,c.h("@<0/>").l(r).h("1(2)").a(a),c.h("0/"),r)
if(b!=null)b=A.iU(b,s)}q=new A.x(s,c.h("x<0>"))
r=b==null?1:3
this.ah(new A.aH(q,r,a,b,p.h("@<1>").l(c).h("aH<1,2>")))
return q},
b1(a,b,c){var s,r=this.$ti
r.l(c).h("1/(2)").a(a)
s=new A.x($.t,c.h("x<0>"))
this.ah(new A.aH(s,19,a,b,r.h("@<1>").l(c).h("aH<1,2>")))
return s},
bC(a){this.a=this.a&1|16
this.c=a},
a1(a){this.a=a.a&30|this.a&1
this.c=a.c},
ah(a){var s,r=this,q=r.a
if(q<=3){a.a=t.F.a(r.c)
r.c=a}else{if((q&4)!==0){s=t._.a(r.c)
if((s.a&24)===0){s.ah(a)
return}r.a1(s)}q=r.b
q.S(q,new A.dx(r,a))}},
b_(a){var s,r,q,p,o,n,m=this,l={}
l.a=a
if(a==null)return
s=m.a
if(s<=3){r=t.F.a(m.c)
m.c=a
if(r!=null){q=a.a
for(p=a;q!=null;p=q,q=o)o=q.a
p.a=r}}else{if((s&4)!==0){n=t._.a(m.c)
if((n.a&24)===0){n.b_(a)
return}m.a1(n)}l.a=m.a6(a)
s=m.b
s.S(s,new A.dB(l,m))}},
R(){var s=t.F.a(this.c)
this.c=null
return this.a6(s)},
a6(a){var s,r,q
for(s=a,r=null;s!=null;r=s,s=q){q=s.a
s.a=r}return r},
aV(a){var s,r=this
r.$ti.c.a(a)
s=r.R()
r.a=8
r.c=a
A.aI(r,s)},
br(a){var s=this.R()
this.a1(a)
A.aI(this,s)},
a2(a){var s=this.R()
this.bC(a)
A.aI(this,s)},
bq(a,b){A.N(a)
t.l.a(b)
this.a2(new A.O(a,b))},
ai(a){var s=this.$ti
s.h("1/").a(a)
if(s.h("a1<1>").b(a)){this.aS(a)
return}this.bn(a)},
bn(a){var s,r=this
r.$ti.c.a(a)
r.a^=2
s=r.b
s.S(s,new A.dz(r,a))},
aS(a){A.eD(this.$ti.h("a1<1>").a(a),this,!1)
return},
aj(a){var s
this.a^=2
s=this.b
s.S(s,new A.dy(this,a))},
$ia1:1}
A.dx.prototype={
$0(){A.aI(this.a,this.b)},
$S:0}
A.dB.prototype={
$0(){A.aI(this.b,this.a.a)},
$S:0}
A.dA.prototype={
$0(){A.eD(this.a.a,this.b,!0)},
$S:0}
A.dz.prototype={
$0(){this.a.aV(this.b)},
$S:0}
A.dy.prototype={
$0(){this.a.a2(this.b)},
$S:0}
A.dE.prototype={
$0(){var s,r,q,p,o,n,m,l,k=this,j=null
try{q=k.a.a
p=q.b.b
j=p.az(p,t.bd.a(q.d),t.z)}catch(o){s=A.L(o)
r=A.ag(o)
if(k.c&&t.n.a(k.b.a.c).a===s){q=k.a
q.c=t.n.a(k.b.a.c)}else{q=s
p=r
if(p==null)p=A.cQ(q)
n=k.a
n.c=new A.O(q,p)
q=n}q.b=!0
return}if(j instanceof A.x&&(j.a&24)!==0){if((j.a&16)!==0){q=k.a
q.c=t.n.a(j.c)
q.b=!0}return}if(j instanceof A.x){m=k.b.a
l=new A.x(m.b,m.$ti)
j.bc(new A.dF(l,m),new A.dG(l),t.H)
q=k.a
q.c=l
q.b=!1}},
$S:0}
A.dF.prototype={
$1(a){this.a.br(this.b)},
$S:5}
A.dG.prototype={
$2(a,b){A.N(a)
t.l.a(b)
this.a.a2(new A.O(a,b))},
$S:19}
A.dD.prototype={
$0(){var s,r,q,p,o,n,m,l,k
try{q=this.a
p=q.a
o=p.$ti
n=o.c
m=n.a(this.b)
l=p.b.b
q.c=l.a7(l,o.h("2/(1)").a(p.d),m,o.h("2/"),n)}catch(k){s=A.L(k)
r=A.ag(k)
q=s
p=r
if(p==null)p=A.cQ(q)
o=this.a
o.c=new A.O(q,p)
o.b=!0}},
$S:0}
A.dC.prototype={
$0(){var s,r,q,p,o,n,m,l=this
try{s=t.n.a(l.a.a.c)
p=l.b
if(p.a.c0(s)&&p.a.e!=null){p.c=p.a.bW(s)
p.b=!1}}catch(o){r=A.L(o)
q=A.ag(o)
p=t.n.a(l.a.a.c)
if(p.a===r){n=l.b
n.c=p
p=n}else{p=r
n=q
if(n==null)n=A.cQ(p)
m=l.b
m.c=new A.O(p,n)
p=m}p.b=!0}},
$S:0}
A.cD.prototype={}
A.b_.prototype={
gm(a){var s={},r=new A.x($.t,t.aQ)
s.a=0
this.b8(new A.df(s,this),!0,new A.dg(s,r),r.gbp())
return r}}
A.df.prototype={
$1(a){this.b.$ti.c.a(a);++this.a.a},
$S(){return this.b.$ti.h("~(1)")}}
A.dg.prototype={
$0(){var s=this.b,r=s.$ti,q=r.h("1/").a(this.a.a),p=s.R()
r.c.a(q)
s.a=8
s.c=q
A.aI(s,p)},
$S:0}
A.bH.prototype={
gt(a){return(A.bz(this.a)^892482866)>>>0},
F(a,b){if(b==null)return!1
if(this===b)return!0
return b instanceof A.b1&&b.a===this.a}}
A.bI.prototype={
aq(){A.J(this.w).h("b0<1>").a(this)},
ar(){A.J(this.w).h("b0<1>").a(this)}}
A.ae.prototype={
aP(a){var s,r=this,q=A.J(r)
q.c.a(a)
s=r.e
if((s&8)!==0)return
if(s<64)r.a8(a)
else r.bm(new A.bJ(a,q.h("bJ<1>")))},
aq(){},
ar(){},
bm(a){var s,r,q=this,p=q.r
if(p==null)p=q.r=new A.cH(A.J(q).h("cH<1>"))
s=p.c
if(s==null)p.b=p.c=a
else p.c=s.a=a
r=q.e
if((r&128)===0){r|=128
q.e=r
if(r<256)p.aK(q)}},
a8(a){var s,r=this,q=A.J(r).c
q.a(a)
s=r.e
r.e=s|64
r.d.c4(r.a,a,q)
r.e&=4294967231
r.bo((s&4)!==0)},
bo(a){var s,r,q=this,p=q.e
if((p&128)!==0&&q.r.c==null){p=q.e=p&4294967167
s=!1
if((p&4)!==0)if(p<256){s=q.r
s=s==null?null:s.c==null
s=s!==!1}if(s){p&=4294967291
q.e=p}}for(;;a=r){if((p&8)!==0){q.r=null
return}r=(p&4)!==0
if(a===r)break
q.e=p^64
if(r)q.aq()
else q.ar()
p=q.e&=4294967231}if((p&128)!==0&&p<256)q.r.aK(q)},
$ib0:1,
$iar:1}
A.b5.prototype={
b8(a,b,c,d){var s=this.$ti
s.h("~(1)?").a(a)
t.Y.a(c)
return this.a.bF(s.h("~(1)?").a(a),d,c,b===!0)},
c_(a){return this.b8(a,null,null,null)}}
A.bK.prototype={}
A.bJ.prototype={}
A.cH.prototype={
aK(a){var s,r=this
r.$ti.h("ar<1>").a(a)
s=r.a
if(s===1)return
if(s>=1){r.a=1
return}A.h0(new A.dJ(r,a))
r.a=1}}
A.dJ.prototype={
$0(){var s,r,q,p=this.a,o=p.a
p.a=0
if(o===3)return
s=p.$ti.h("ar<1>").a(this.b)
r=p.b
q=r.a
p.b=q
if(q==null)p.c=null
A.J(r).h("ar<1>").a(s).a8(r.b)},
$S:0}
A.b3.prototype={
bz(){var s,r=this,q=r.a-1
if(q===0){r.a=-1
s=r.c
if(s!=null){r.c=null
r.b.c3(s)}}else r.a=q},
$ib0:1}
A.cI.prototype={}
A.dm.prototype={
c3(a){var s,r,q,p,o=this
t.M.a(a)
try{q=o.az(o,a,t.H)
return q}catch(p){s=A.L(p)
r=A.ag(p)
o.P(o,s,r)}},
c4(a,b,c){var s,r,q,p,o=this
c.h("~(0)").a(a)
c.a(b)
try{q=o.a7(o,a,b,t.H,c)
return q}catch(p){s=A.L(p)
r=A.ag(p)
o.P(o,s,r)}},
bK(a,b){return new A.dn(this,this.a4(this,b.h("0()").a(a),b),b)},
j(a,b){var s
while(!1){s=null.gce(null).j(0,b)
return s}return null},
P(a,b,c){var s,r,q,p,o,n,m,l
t.l.a(c)
s=null
if(s==null){A.iV(b,c)
return}r=s.gaH()
q=r.gcb()
p=$.t
try{$.t=q
s.bV(r,r.gau(),a,b,c)
$.t=p}catch(m){o=A.L(m)
n=A.ag(m)
$.t=p
l=b===o?c:n
q.P(r,o,l)}},
az(a,b,c){var s,r,q
c.h("0()").a(b)
r=$.t
if(r===a)return b.$0()
s=r
$.t=a
try{r=b.$0()
return r}finally{$.t=s}q=null.gaH()
return null.cc(q,q.gau(),a,b)},
a7(a,b,c,d,e){var s,r,q
d.h("@<0>").l(e).h("1(2)").a(b)
e.a(c)
r=$.t
if(r===a)return b.$1(c)
s=r
$.t=a
try{r=b.$1(c)
return r}finally{$.t=s}q=null.gaH()
return null.bV(q,q.gau(),a,b,c)},
bB(a,b,c,d,e,f,g){var s,r,q
e.h("@<0>").l(f).l(g).h("1(2,3)").a(b)
f.a(c)
g.a(d)
r=$.t
if(r===a)return b.$2(c,d)
s=r
$.t=a
try{r=b.$2(c,d)
return r}finally{$.t=s}q=null.gaH()
return null.cd(q,q.gau(),a,b,c,d)},
a4(a,b,c){c.h("0()").a(b)
return b},
a5(a,b,c,d){c.h("@<0>").l(d).h("1(2)").a(b)
return b},
aw(a,b,c,d,e){c.h("@<0>").l(d).l(e).h("1(2,3)").a(b)
return b},
bt(a,b,c){return null},
S(a,b){A.eM(a,t.M.a(b))
return}}
A.dn.prototype={
$0(){var s=this.a
return s.az(s,this.b,this.c)},
$S(){return this.c.h("0()")}}
A.dV.prototype={
$0(){A.hu(this.a,this.b)},
$S:0}
A.bL.prototype={
gm(a){return this.a},
gae(){return new A.bM(this,this.$ti.h("bM<1>"))},
ab(a){var s,r
if(typeof a=="string"&&a!=="__proto__"){s=this.b
return s==null?!1:s[a]!=null}else if(typeof a=="number"&&(a&1073741823)===a){r=this.c
return r==null?!1:r[a]!=null}else return this.bs(a)},
bs(a){var s=this.d
if(s==null)return!1
return this.am(this.aU(s,a),a)>=0},
j(a,b){var s,r,q
if(typeof b=="string"&&b!=="__proto__"){s=this.b
r=s==null?null:A.fq(s,b)
return r}else if(typeof b=="number"&&(b&1073741823)===b){q=this.c
r=q==null?null:A.fq(q,b)
return r}else return this.bv(b)},
bv(a){var s,r,q=this.d
if(q==null)return null
s=this.aU(q,a)
r=this.am(s,a)
return r<0?null:s[r+1]},
v(a,b,c){var s,r,q,p,o,n,m=this,l=m.$ti
l.c.a(b)
l.y[1].a(c)
if(typeof b=="string"&&b!=="__proto__"){s=m.b
m.aQ(s==null?m.b=A.eE():s,b,c)}else if(typeof b=="number"&&(b&1073741823)===b){r=m.c
m.aQ(r==null?m.c=A.eE():r,b,c)}else{q=m.d
if(q==null)q=m.d=A.eE()
p=A.el(b)&1073741823
o=q[p]
if(o==null){A.eF(q,p,[b,c]);++m.a
m.e=null}else{n=m.am(o,b)
if(n>=0)o[n+1]=c
else{o.push(b,c);++m.a
m.e=null}}}},
aD(a,b){var s,r,q,p,o,n,m=this,l=m.$ti
l.h("~(1,2)").a(b)
s=m.aW()
for(r=s.length,q=l.c,l=l.y[1],p=0;p<r;++p){o=s[p]
q.a(o)
n=m.j(0,o)
b.$2(o,n==null?l.a(n):n)
if(s!==m.e)throw A.d(A.bf(m))}},
aW(){var s,r,q,p,o,n,m,l,k,j,i=this,h=i.e
if(h!=null)return h
h=A.f7(i.a,null,!1,t.z)
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
aQ(a,b,c){var s=this.$ti
s.c.a(b)
s.y[1].a(c)
if(a[b]==null){++this.a
this.e=null}A.eF(a,b,c)},
aU(a,b){return a[A.el(b)&1073741823]}}
A.b4.prototype={
am(a,b){var s,r,q
if(a==null)return-1
s=a.length
for(r=0;r<s;r+=2){q=a[r]
if(q==null?b==null:q===b)return r}return-1}}
A.bM.prototype={
gm(a){return this.a.a},
gA(a){var s=this.a
return new A.bN(s,s.aW(),this.$ti.h("bN<1>"))}}
A.bN.prototype={
gn(){var s=this.d
return s==null?this.$ti.c.a(s):s},
p(){var s=this,r=s.b,q=s.c,p=s.a
if(r!==p.e)throw A.d(A.bf(p))
else if(q>=r.length){s.d=null
return!1}else{s.d=r[q]
s.c=q+1
return!0}},
$ia4:1}
A.u.prototype={
gA(a){return new A.aB(a,a.length,A.ba(a).h("aB<u.E>"))},
V(a,b){if(!(b>=0&&b<a.length))return A.e(a,b)
return a[b]},
X(a,b,c){var s=A.ba(a)
return new A.aa(a,s.l(c).h("1(u.E)").a(b),s.h("@<u.E>").l(c).h("aa<1,2>"))},
k(a){return A.d4(a,"[","]")}}
A.aD.prototype={
aD(a,b){var s,r,q,p=A.J(this)
p.h("~(1,2)").a(b)
for(s=this.gae(),s=s.gA(s),p=p.y[1];s.p();){r=s.gn()
q=this.j(0,r)
b.$2(r,q==null?p.a(q):q)}},
gm(a){var s=this.gae()
return s.gm(s)},
k(a){return A.f9(this)},
$ibq:1}
A.da.prototype={
$2(a,b){var s,r=this.a
if(!r.a)this.b.a+=", "
r.a=!1
r=this.b
s=A.c(a)
r.a=(r.a+=s)+": "
s=A.c(b)
r.a+=s},
$S:20}
A.c3.prototype={}
A.cS.prototype={
I(a){var s
t.L.a(a)
s=a.length
if(s===0)return""
s=new A.du("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/").bQ(a,0,s,!0)
s.toString
return A.hQ(s)}}
A.du.prototype={
bQ(a,b,c,d){var s,r,q,p,o
t.L.a(a)
s=this.a
r=(s&3)+(c-b)
q=B.h.bG(r,3)
p=q*4
if(r-q*3>0)p+=4
o=new Uint8Array(p)
this.a=A.i_(this.b,a,b,c,!0,o,0,s)
if(p>0)return o
return null}}
A.cR.prototype={
I(a){var s,r,q,p=A.fg(0,null,a.length)
if(0===p)return new Uint8Array(0)
s=new A.dt()
r=s.bM(a,0,p)
r.toString
q=s.a
if(q<-1)A.X(A.aS("Missing padding character",a,p))
if(q>0)A.X(A.aS("Invalid length, must be multiple of four",a,p))
s.a=-1
return r}}
A.dt.prototype={
bM(a,b,c){var s,r=this,q=r.a
if(q<0){r.a=A.fo(a,b,c,q)
return null}if(b===c)return new Uint8Array(0)
s=A.hX(a,b,c,q)
r.a=A.hZ(a,b,c,s,0,r.a)
return s}}
A.aw.prototype={}
A.c7.prototype={}
A.c8.prototype={
F(a,b){if(b==null)return!1
return b instanceof A.c8&&this.a===b.a&&this.b===b.b&&this.c===b.c},
gt(a){return A.hD(this.a,this.b)},
k(a){var s=this,r=A.hs(A.hL(s)),q=A.c9(A.hJ(s)),p=A.c9(A.hF(s)),o=A.c9(A.hG(s)),n=A.c9(A.hI(s)),m=A.c9(A.hK(s)),l=A.f3(A.hH(s)),k=s.b,j=k===0?"":A.f3(k)
k=r+"-"+q
if(s.c)return k+"-"+p+" "+o+":"+n+":"+m+"."+l+j+"Z"
else return k+"-"+p+" "+o+":"+n+":"+m+"."+l+j}}
A.dv.prototype={
k(a){return this.aX()}}
A.w.prototype={
gO(){return A.hE(this)}}
A.c1.prototype={
k(a){var s=this.a
if(s!=null)return"Assertion failed: "+A.cV(s)
return"Assertion failed"}}
A.ac.prototype={}
A.a_.prototype={
gal(){return"Invalid argument"+(!this.a?"(s)":"")},
gak(){return""},
k(a){var s=this,r=s.c,q=r==null?"":" ("+r+")",p=s.d,o=p==null?"":": "+A.c(p),n=s.gal()+q+o
if(!s.a)return n
return n+s.gak()+": "+A.cV(s.gaE())},
gaE(){return this.b}}
A.aZ.prototype={
gaE(){return A.fD(this.b)},
gal(){return"RangeError"},
gak(){var s,r=this.e,q=this.f
if(r==null)s=q!=null?": Not less than or equal to "+A.c(q):""
else if(q==null)s=": Not greater than or equal to "+A.c(r)
else if(q>r)s=": Not in inclusive range "+A.c(r)+".."+A.c(q)
else s=q<r?": Valid value range is empty":": Only valid value is "+A.c(r)
return s}}
A.ca.prototype={
gaE(){return A.n(this.b)},
gal(){return"RangeError"},
gak(){if(A.n(this.b)<0)return": index must not be negative"
var s=this.f
if(s===0)return": no indices are valid"
return": index should be less than "+s},
gm(a){return this.f}}
A.bD.prototype={
k(a){return"Unsupported operation: "+this.a}}
A.cA.prototype={
k(a){return"UnimplementedError: "+this.a}}
A.aE.prototype={
k(a){return"Bad state: "+this.a}}
A.c6.prototype={
k(a){var s=this.a
if(s==null)return"Concurrent modification during iteration."
return"Concurrent modification during iteration: "+A.cV(s)+"."}}
A.cq.prototype={
k(a){return"Out of Memory"},
gO(){return null},
$iw:1}
A.bB.prototype={
k(a){return"Stack Overflow"},
gO(){return null},
$iw:1}
A.dw.prototype={
k(a){return"Exception: "+this.a}}
A.cY.prototype={
k(a){var s,r,q,p,o,n,m,l,k,j,i=this.a,h=""!==i?"FormatException: "+i:"FormatException",g=this.c,f=this.b,e=g<0||g>f.length
if(e)g=null
if(g==null){if(f.length>78)f=B.k.a0(f,0,75)+"..."
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
l=""}return h+m+B.k.a0(f,j,k)+l+"\n"+B.k.aJ(" ",g-j+m.length)+"^\n"}}
A.f.prototype={
X(a,b,c){var s=A.J(this)
return A.hB(this,s.l(c).h("1(f.E)").a(b),s.h("f.E"),c)},
gm(a){var s,r=this.gA(this)
for(s=0;r.p();)++s
return s},
V(a,b){var s,r
A.ff(b,"index")
s=this.gA(this)
for(r=b;s.p();){if(r===0)return s.gn();--r}throw A.d(A.f4(b,b-r,this,"index"))},
k(a){return A.hv(this,"(",")")}}
A.z.prototype={
gt(a){return A.k.prototype.gt.call(this,0)},
k(a){return"null"}}
A.k.prototype={$ik:1,
F(a,b){return this===b},
gt(a){return A.bz(this)},
k(a){return"Instance of '"+A.ct(this)+"'"},
gq(a){return A.jg(this)},
toString(){return this.k(this)}}
A.cJ.prototype={
k(a){return""},
$ia3:1}
A.cx.prototype={
gm(a){return this.a.length},
k(a){var s=this.a
return s.charCodeAt(0)==0?s:s}}
A.db.prototype={
k(a){return"Promise was rejected with a value of `"+(this.a?"undefined":"null")+"`."}}
A.e9.prototype={
$1(a){var s,r,q,p
if(A.fN(a))return a
s=this.a
if(s.ab(a))return s.j(0,a)
if(t.f.b(a)){r={}
s.v(0,a,r)
for(s=a.gae(),s=s.gA(s);s.p();){q=s.gn()
r[q]=this.$1(a.j(0,q))}return r}else if(t.R.b(a)){p=[]
s.v(0,a,p)
B.d.bJ(p,J.hj(a,this,t.z))
return p}else return a},
$S:8}
A.em.prototype={
$1(a){return this.a.aA(this.b.h("0/?").a(a))},
$S:3}
A.en.prototype={
$1(a){if(a==null)return this.a.b3(new A.db(a===undefined))
return this.a.b3(a)},
$S:3}
A.dX.prototype={
$1(a){var s,r,q,p,o,n,m,l,k,j,i,h,g
if(A.fM(a))return a
s=this.a
a.toString
if(s.ab(a))return s.j(0,a)
if(a instanceof Date){r=a.getTime()
if(r<-864e13||r>864e13)A.X(A.ab(r,-864e13,864e13,"millisecondsSinceEpoch",null))
return new A.c8(r,0,!0)}if(a instanceof RegExp)throw A.d(A.a6("structured clone of RegExp",null))
if(a instanceof Promise)return A.ai(a,t.X)
q=Object.getPrototypeOf(a)
if(q===Object.prototype||q===null){p=t.X
o=A.bp(p,p)
s.v(0,a,o)
n=Object.keys(a)
m=[]
for(s=n.length,l=0;l<n.length;n.length===s||(0,A.c0)(n),++l)m.push(A.fU(n[l]))
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
A.dH.prototype={
bk(){var s=self.crypto
if(s!=null)if(s.getRandomValues!=null)return
throw A.d(A.bE("No source of cryptographically secure random numbers available."))},
aF(a){var s,r,q,p,o,n,m,l,k=null
if(a<=0||a>4294967296)throw A.d(new A.aZ(k,k,!1,k,k,"max must be in range 0 < max \u2264 2^32, was "+a))
if(a>255)if(a>65535)s=a>16777215?4:3
else s=2
else s=1
r=this.a
r.$flags&2&&A.Y(r,11)
r.setUint32(0,0,!1)
q=4-s
p=A.n(Math.pow(256,s))
for(o=a-1,n=(a&o)>>>0===0;;){crypto.getRandomValues(J.eY(B.r.gH(r),q,s))
m=r.getUint32(0,!1)
if(n)return(m&o)>>>0
l=m%a
if(m-l+a<p)return l}}}
A.ao.prototype={
F(a,b){if(b==null)return!1
return b instanceof A.ao&&this.b===b.b},
gt(a){return this.b},
k(a){return this.a}}
A.aC.prototype={
k(a){return"["+this.a.a+"] "+this.d+": "+this.b}}
A.aX.prototype={
gb6(){var s=this.b,r=s==null?null:s.a.length!==0,q=this.a
return r===!0?s.gb6()+"."+q:q},
gbZ(){var s,r
if(this.b==null){s=this.c
s.toString
r=s}else{s=$.cN().c
s.toString
r=s}return r},
i(a,b,c,d){var s,r=this,q=a.b
if(q>=r.gbZ().b){if(q>=2000){A.fi()
a.k(0)}q=r.gb6()
Date.now()
$.f8=$.f8+1
s=new A.aC(a,b,q)
if(r.b==null)r.b0(s)
else $.cN().b0(s)}},
aY(){if(this.b==null){var s=this.f
if(s==null)s=this.f=new A.bT(null,null,t.W)
return new A.b1(s,A.J(s).h("b1<1>"))}else return $.cN().aY()},
b0(a){var s=this.f
if(s!=null){A.J(s).c.a(a)
if(!s.gan())A.X(s.ag())
s.a8(a)}return null}}
A.d9.prototype={
$0(){var s,r,q,p=this.a
if(B.k.bh(p,"."))A.X(A.a6("name shouldn't start with a '.'",null))
if(B.k.bU(p,"."))A.X(A.a6("name shouldn't end with a '.'",null))
s=B.k.bY(p,".")
if(s===-1)r=p!==""?A.d8(""):null
else{r=A.d8(B.k.a0(p,0,s))
p=B.k.aN(p,s+1)}q=new A.aX(p,r,A.bp(t.N,t.I))
if(r==null)q.c=B.f
else r.d.v(0,p,q)
return q},
$S:21}
A.ak.prototype={
aX(){return"Algorithm."+this.b}}
A.bh.prototype={}
A.ax.prototype={
ad(a,b){return this.bT(a,b)},
bT(a1,a2){var s=0,r=A.F(t.a5),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0
var $async$ad=A.G(function(a3,a4){if(a3===1){o.push(a4)
s=p}for(;;)switch(s){case 0:c=$.v()
b=""+a2.length
c.i(B.i,"encodeFunction: buffer "+b,null,null)
h=n.d.K(n.e)
m=h==null?null:h.b
l=n.e
if(m==null){c.i(B.b,"encodeFunction: no secretKey for index "+A.c(l)+", cannot encrypt",null,null)
q=null
s=1
break}h=Date.now()
g=new DataView(new ArrayBuffer(12))
f=n.a
if(f===-1)f=n.a=$.er().aF(65535)
g.setUint32(0,$.er().aF(Math.max(0,4294967295))>>>0,!1)
g.setUint32(4,h,!1)
g.setUint32(8,h-B.h.af(f,65535),!1)
n.a=f+1
k=J.et(B.r.gH(g))
e=new DataView(new ArrayBuffer(2))
e.setInt8(0,12)
e.setInt8(1,A.n(l))
p=4
h=A.b(A.b(n.f.crypto).subtle)
f=A.h(A.j(["name","AES-GCM","iv",k],t.N,t.K))
if(f==null)f=A.N(f)
a0=t.a
s=7
return A.m(A.ai(A.b(h.encrypt(f,m,a2)),t.X),$async$ad)
case 7:j=a0.a(a4)
c.i(B.c,"encodeFunction: encrypted buffer: "+b+", cipherText: "+A.I(j,0,null).length,null,null)
b=A.I(j,0,null)
q=new A.bh(b,l,k)
s=1
break
p=2
s=6
break
case 4:p=3
a=o.pop()
i=A.L(a)
$.v().i(B.b,"encodeFunction encrypt: e "+J.T(i),null,null)
throw a
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$ad,r)},
U(a,b){return this.bP(a,b)},
bP(a4,a5){var s=0,r=A.F(t.E),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3
var $async$U=A.G(function(a6,a7){if(a6===1){o.push(a7)
s=p}for(;;)switch(s){case 0:a1={}
a1.a=0
e=$.v()
d=a5.a
e.i(B.i,"decodeFunction: data packet length "+d.length,null,null)
a1.b=a1.c=null
m=n.e
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
h=new A.cT(a1,c,n,j,i,m)
g=new A.cU(a1,c,n,h)
p=8
s=11
return A.m(h.$0(),$async$U)
case 11:p=4
s=10
break
case 8:p=7
a2=o.pop()
f=A.L(a2)
e=$.v()
e.i(B.c,"decodeFunction: kInternalError catch "+A.c(f),null,null)
s=12
return A.m(g.$0(),$async$U)
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
n.d.b4()
throw a3
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$U,r)}}
A.cT.prototype={
$0(){var s=0,r=A.F(t.H),q=this,p,o,n,m,l,k,j
var $async$$0=A.G(function(a,b){if(a===1)return A.C(b,r)
for(;;)switch(s){case 0:m=q.c
l=A.b(A.b(m.f.crypto).subtle)
k=A.h(A.j(["name","AES-GCM","iv",q.d],t.N,t.K))
if(k==null)k=A.N(k)
p=q.b
j=t.a
s=2
return A.m(A.ai(A.b(l.decrypt(k,p.a.b,q.e)),t.X),$async$$0)
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
case 3:l.i(B.i,u.E,null,null)
s=5
return A.m(m.d.L(p.a,q.f),$async$$0)
case 5:case 4:return A.D(null,r)}})
return A.E($async$$0,r)},
$S:2}
A.cU.prototype={
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
return A.m(l.d.N(m.a.a,J.eu(p)),$async$$0)
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
aX(){return"CryptorError."+this.b}}
A.d0.prototype={}
A.am.prototype={
gb5(){if(this.b==null)return!1
return this.r},
a_(a,b,c,d,e,f,g){return this.bg(a,b,c,d,e,f,g)},
bf(a,b,c,d,e,f){return this.a_(null,a,b,c,d,e,f)},
bg(a,b,c,d,e,f,g){var s=0,r=A.F(t.H),q,p=this,o,n,m,l,k,j
var $async$a_=A.G(function(h,a0){if(h===1)return A.C(a0,r)
for(;;)switch(s){case 0:j=$.v()
j.i(B.f,"setupTransform "+d+" kind "+c,null,null)
p.f=c
if(a!=null){j.i(B.f,"setting codec on cryptor to "+a,null,null)
p.d=a}if(b&&p.w){j.i(B.f,"setupTransform: transform already active, skipping setup",null,null)
s=1
break}j=v.G.TransformStream
m=d==="encode"?A.fH(p.gbR()):A.fH(p.gbN())
l=t.N
o=A.b(new j(A.b(A.h(A.j(["transform",m],l,t.g)))))
try{A.b(A.b(e.pipeThrough(o)).pipeTo(g))}catch(i){n=A.L(i)
$.v().i(B.b,"e "+J.T(n),null,null)
if(p.x!==B.q){p.x=B.q
p.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",p.b,"state","internalError","error","Internal error: "+J.T(n)],l,t.T)))}}p.w=!0
p.c=f
case 1:return A.D(q,r)}})
return A.E($async$a_,r)},
aI(a,b){var s,r,q,p,o,n,m=this,l=null,k="Unsupported codec for track ",j=""
if(A.ez(a,"RTCEncodedVideoFrame")){s=A.I(t.a.a(a.data),0,l)
if("type" in a){j=A.i(a.type)
$.v().i(B.c,"frameType: "+j,l,l)}}else s=l
r=A.K(["h264","h265"],t.s)
q=b==null?l:b.toLowerCase()
if(B.d.bL(r,q==null?"":q)){if(s==null)throw A.d(A.cv("Frame data is null for codec "+A.c(b)))
b.toString
p=A.jt(s,b)
r=p.b
if(r==="unknown"){if(m.x!==B.z){m.x=B.z
q=m.b
o=m.c
n=m.f
n===$&&A.aj("kind")
m.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",q,"trackId",o,"kind",n,"state","unsupportedCodec","error",k+o+", detected codec "+r],t.N,t.T)))}throw A.d(A.U(k+m.c))}return p.a}switch(j){case"key":return 10
case"delta":return 3
case"audio":return 1
default:return 0}},
b9(a){var s,r,q,p,o,n=null
new Uint8Array(0)
if(A.ez(a,"RTCEncodedVideoFrame")){s=A.I(t.a.a(a.data),0,n)
if("type" in a){r=A.i(a.type)
$.v().i(B.c,"frameType: "+r,n,n)}else r=""
q=A.b(a.getMetadata())
p=A.n(q.synchronizationSource)
if("rtpTimestamp" in q)o=B.h.bd(A.n(q.rtpTimestamp))
else o="timestamp" in a?A.n(A.eI(a.timestamp)):0}else{if(A.ez(a,"RTCEncodedAudioFrame")){s=A.I(t.a.a(a.data),0,n)
q=A.b(a.getMetadata())
p=A.n(q.synchronizationSource)
if("rtpTimestamp" in q)o=B.h.bd(A.n(q.rtpTimestamp))
else o="timestamp" in a?A.n(A.eI(a.timestamp)):0}else throw A.d(A.U("encodeFunction: frame is not a RTCEncodedVideoFrame or RTCEncodedAudioFrame"))
r="audio"}return new A.d0(r,p,o,s)},
aC(a,b,c){a.data=t.a.a(B.e.gH(c.aG()))
b.enqueue(a)},
ac(a,b){return this.bS(A.b(a),A.b(b))},
bS(a6,a7){var s=0,r=A.F(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5
var $async$ac=A.G(function(a8,a9){if(a8===1){o.push(a9)
s=p}for(;;)switch(s){case 0:p=4
d=!0
if(n.gb5()){c=t.a
b=c.a(a6.data)
if(!(b.byteLength===0)){d=c.a(a6.data)
d=d.byteLength===0}}if(d){if(n.e.d.r){s=1
break}a7.enqueue(a6)
s=1
break}m=n.b9(a6)
d=$.v()
d.i(B.i,"encodeFunction: buffer "+m.d.length+", synchronizationSource "+m.b+" frameType "+m.a,null,null)
c=n.e.K(n.y)
l=c==null?null:c.b
k=n.y
if(l==null){if(n.x!==B.p){n.x=B.p
d=n.b
c=n.c
b=n.f
b===$&&A.aj("kind")
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",d,"trackId",c,"kind",b,"state","missingKey","error","Missing key for track "+c],t.N,t.T)))}s=1
break}c=n.f
c===$&&A.aj("kind")
j=c==="video"?n.aI(a6,n.d):1
b=m.b
a=m.c
a0=new DataView(new ArrayBuffer(12))
c=n.a
if(c.j(0,b)==null)c.v(0,b,$.er().aF(65535))
a1=c.j(0,b)
if(a1==null)a1=0
a0.setUint32(0,b,!1)
a0.setUint32(4,a,!1)
a0.setUint32(8,a-B.h.af(a1,65535),!1)
c.v(0,b,a1+1)
i=J.et(B.r.gH(a0))
h=new DataView(new ArrayBuffer(2))
c=h
c.$flags&2&&A.Y(c,6)
J.eX(c,0,12)
c=h
b=A.n(k)
c.$flags&2&&A.Y(c,6)
J.eX(c,1,b)
b=n.z
c=A.b(A.b(b.crypto).subtle)
a=t.N
a2=A.h(A.j(["name","AES-GCM","iv",i,"additionalData",B.e.B(m.d,0,j)],a,t.K))
if(a2==null)a2=A.N(a2)
a5=t.a
s=7
return A.m(A.ai(A.b(c.encrypt(a2,l,B.e.B(m.d,j,m.d.length))),t.X),$async$ac)
case 7:g=a5.a(a9)
d.i(B.c,"encodeFunction: encrypted buffer: "+m.d.length+", cipherText: "+A.I(g,0,null).length,null,null)
c=$.cO()
f=new A.b2(c)
J.bc(f,new Uint8Array(A.at(B.e.B(m.d,0,j))))
J.bc(f,A.I(g,0,null))
J.bc(f,i)
J.bc(f,J.et(J.eu(h)))
n.aC(a6,a7,f)
if(n.x!==B.j){n.x=B.j
b.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",n.b,"trackId",n.c,"kind",n.f,"state","ok","error","encryption ok"],a,t.T)))}d.i(B.c,"encodeFunction[CryptorError.kOk]: frame enqueued kind "+n.f+",codec "+A.c(n.d)+" headerLength: "+A.c(j)+",  timestamp: "+m.c+", ssrc: "+m.b+", data length: "+m.d.length+", encrypted length: "+f.aG().length+", iv "+A.c(i),null,null)
p=2
s=6
break
case 4:p=3
a4=o.pop()
e=A.L(a4)
$.v().i(B.b,"encodeFunction encrypt: e "+J.T(e),null,null)
if(n.x!==B.y){n.x=B.y
d=n.b
c=n.c
b=n.f
b===$&&A.aj("kind")
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",d,"trackId",c,"kind",b,"state","encryptError","error",J.T(e)],t.N,t.T)))}s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$ac,r)},
T(a,b){return this.bO(A.b(a),A.b(b))},
bO(b1,b2){var s=0,r=A.F(t.H),q,p=2,o=[],n=this,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0
var $async$T=A.G(function(b3,b4){if(b3===1){o.push(b4)
s=p}for(;;)switch(s){case 0:a7={}
a8=n.b9(b1)
a7.a=0
b=$.v()
b.i(B.i,"decodeFunction: frame length "+a8.d.length,null,null)
a7.b=a7.c=null
a7.d=n.y
if(!n.gb5()||a8.d.length===0){n.Q.ba()
if(n.e.d.r){s=1
break}b.i(B.i,"enqueuing empty dtx frame",null,null)
b2.enqueue(b1)
s=1
break}a=n.e.d.e
if(a!=null){a0=a8.d
a1=a.length
a2=a1+1
if(a0.length>a2){a3=B.e.B(a8.d,a8.d.length-a1,a8.d.length)
b.i(B.c,"magicBytesBuffer "+A.c(a3)+", magicBytes "+A.c(a),null,null)
a0=n.Q
if(A.d4(a3,"[","]")===A.d4(a,"[","]")){++a0.a
if(a0.b==null)a0.b=Date.now()
a0.c=Date.now()
if(a0.a<100)if(a0.b!=null){a7=Date.now()
a0=a0.b
a0.toString
a0=a7-a0<2000
a7=a0}else a7=!0
else a7=!1
if(a7){a7=B.e.aM(a8.d,a8.d.length-1)
if(0>=a7.length){q=A.e(a7,0)
s=1
break}b.i(B.c,"decodeFunction: skip unencrypted frame, type "+a7[0],null,null)
e=new A.b2($.cO())
e.u(0,new Uint8Array(A.at(B.e.B(a8.d,0,a8.d.length-a2))))
b.i(B.i,"decodeFunction: enqueuing silent frame src: "+A.c(a8.d),null,null)
n.aC(b1,b2,e)
b.i(B.i,"decodeFunction: enqueuing done",null,null)
s=1
break}else{b.i(B.b,"decodeFunction: SIF limit reached, dropping frame",null,null)
s=1
break}}else a0.ba()}}p=4
a={}
a0=n.f
a0===$&&A.aj("kind")
m=a0==="video"?n.aI(b1,n.d):1
l=B.e.aM(a8.d,a8.d.length-2)
k=J.eW(l,0)
j=J.eW(l,1)
a1=a8.d
a2=a8.d
a4=k
if(typeof a4!=="number"){q=A.ji(a4)
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
h=new A.cZ(a7,a,n,i,a8,m,k)
g=new A.d_(a7,a,n,h)
p=8
s=11
return A.m(h.$0(),$async$T)
case 11:p=4
s=10
break
case 8:p=7
a9=o.pop()
f=A.L(a9)
n.x=B.q
b=$.v()
b.i(B.c,"decodeFunction: kInternalError catch "+A.c(f),null,null)
s=12
return A.m(g.$0(),$async$T)
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
a=$.cO()
e=new A.b2(a)
J.bc(e,new Uint8Array(A.at(B.e.B(a8.d,0,m))))
a7=a7.c
a7.toString
J.bc(e,A.I(a7,0,null))
n.aC(b1,b2,e)
if(n.x!==B.j){n.x=B.j
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",n.b,"trackId",n.c,"kind",n.f,"state","ok","error","decryption ok"],t.N,t.T)))}b.i(B.i,"decodeFunction[CryptorError.kOk]: decryption success kind "+n.f+", headerLength: "+A.c(m)+", timestamp: "+a8.c+", ssrc: "+a8.b+", data length: "+a8.d.length+", decrypted length: "+e.aG().length+", keyindex "+A.c(j)+" iv "+A.c(i),null,null)
p=2
s=6
break
case 4:p=3
b0=o.pop()
d=A.L(b0)
c=A.ag(b0)
$.v().i(B.b,"decodeFunction[CryptorError.kDecryptError]: "+A.c(d)+", "+A.c(c),null,null)
if(n.x!==B.x){n.x=B.x
a7=n.b
b=n.c
a=n.f
a===$&&A.aj("kind")
n.z.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",a7,"trackId",b,"kind",a,"state","decryptError","error",J.T(d)],t.N,t.T)))}n.e.b4()
s=6
break
case 3:s=2
break
case 6:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$T,r)}}
A.cZ.prototype={
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
if(g==null)g=A.N(g)
p=q.b
f=t.a
s=2
return A.m(A.ai(A.b(l.decrypt(g,p.a.b,B.e.B(j,i,j.length-q.r-2))),t.X),$async$$0)
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
case 3:i.i(B.i,u.E,null,null)
s=5
return A.m(n.e.L(p.a,j.d),$async$$0)
case 5:case 4:l=n.x
if(l!==B.j&&l!==B.A&&j.a>0){i.i(B.c,"decodeFunction::decryptFrameInternal: KeyRatcheted: ssrc "+k.b+" timestamp "+k.c+" ratchetCount "+j.a+"  participantId: "+A.c(n.b),null,null)
i.i(B.c,"decodeFunction::decryptFrameInternal: ratchetKey: lastError != CryptorError.kKeyRatcheted, reset state to kKeyRatcheted",null,null)
n.x=B.A
l=n.b
k=n.c
n=n.f
n===$&&A.aj("kind")
m.postMessage(A.h(A.j(["type","cryptorState","msgType","event","participantId",l,"trackId",k,"kind",n,"state","keyRatcheted","error","Key ratcheted ok"],h,t.T)))}return A.D(null,r)}})
return A.E($async$$0,r)},
$S:2}
A.d_.prototype={
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
return A.m(l.e.N(m.a.a,J.eu(p)),$async$$0)
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
A.d6.prototype={
k(a){var s=this
return"KeyOptions{sharedKey: "+s.a+", ratchetWindowSize: "+s.c+", failureTolerance: "+s.d+", uncryptedMagicBytes: "+A.c(s.e)+", ratchetSalt: "+A.c(s.b)+"}"}}
A.ch.prototype={
G(a){var s,r,q=this,p=q.c
if(p.a)return q.Y()
s=q.d
r=s.j(0,a)
if(r==null){r=A.fb(p,a,q.a)
p=q.f
if(p.length!==0)r.be(p)
s.v(0,a,r)}return r},
Y(){var s=this,r=s.e
return r==null?s.e=A.fb(s.c,"shared-key",s.a):r},
Z(a,b){var s=0,r=A.F(t.H),q=this
var $async$Z=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:$.v().i(B.f,"setting shared key",null,null)
q.f=a
s=2
return A.m(q.Y().D(a,b),$async$Z)
case 2:return A.D(null,r)}})
return A.E($async$Z,r)}}
A.aW.prototype={}
A.cr.prototype={
b4(){var s=this,r=s.d.d
if(r<0)return
if(++s.r>r){$.v().i(B.b,"key for "+s.f+" is being marked as invalid",null,null)
s.c=!1}},
W(a){var s=0,r=A.F(t.E),q,p=2,o=[],n=this,m,l,k,j,i,h,g
var $async$W=A.G(function(b,c){if(b===1){o.push(c)
s=p}for(;;)switch(s){case 0:j=n.K(a)
i=j==null?null:j.a
if(i==null){q=null
s=1
break}p=4
g=t.a
s=7
return A.m(A.ai(A.b(A.b(A.b(n.e.crypto).subtle).exportKey("raw",i)),t.X),$async$W)
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
l=A.L(h)
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
return A.E($async$W,r)},
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
return A.m(A.ai(A.eN(A.b(A.b(p.e.crypto).subtle),"importKey",["raw",t.a.a(b),A.N(A.b(a.algorithm).name),!1,t.c.a(A.h(A.K(["deriveBits","deriveKey"],t.s)))],o),o),$async$N)
case 3:q=d
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$N,r)},
K(a){var s,r=this.b
r===$&&A.aj("cryptoKeyRing")
s=a==null?this.a:a
if(!(s>=0&&s<r.length))return A.e(r,s)
return r[s]},
D(a,b){var s=0,r=A.F(t.H),q=this,p,o,n
var $async$D=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:o=A.b(A.b(q.e.crypto).subtle)
n=t.N
n=A.h(A.j(["name","HKDF"],n,n))
if(n==null)n=A.N(n)
p=t.m
s=4
return A.m(A.ai(A.eN(o,"importKey",["raw",a,n,!1,t.c.a(A.h(A.K(["deriveBits","deriveKey"],t.s)))],p),p),$async$D)
case 4:s=3
return A.m(q.J(d,q.d.b),$async$D)
case 3:s=2
return A.m(q.L(d,b),$async$D)
case 2:q.r=0
q.c=!0
return A.D(null,r)}})
return A.E($async$D,r)},
be(a){return this.D(a,0)},
L(a,b){var s=0,r=A.F(t.H),q=this,p
var $async$L=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:$.v().i(B.a,"setKeySetFromMaterial: set new key, index: "+b,null,null)
if(b>=0){p=q.b
p===$&&A.aj("cryptoKeyRing")
q.a=B.h.af(b,p.length)}p=q.b
p===$&&A.aj("cryptoKeyRing")
B.d.v(p,q.a,a)
return A.D(null,r)}})
return A.E($async$L,r)},
J(a,b){var s=0,r=A.F(t.x),q,p=this,o,n,m,l,k,j,i
var $async$J=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:n=A.fV(A.i(A.b(a.algorithm).name),b)
m=A.b(A.b(p.e.crypto).subtle)
l=A.h(n)
if(l==null)l=A.N(l)
o=A.h(A.j(["name","AES-GCM","length",128],t.N,t.K))
if(o==null)o=A.N(o)
k=A
j=a
i=A
s=3
return A.m(A.ai(A.eN(m,"deriveKey",[l,a,o,!1,t.c.a(A.h(A.K(["encrypt","decrypt"],t.s)))],t.m),t.X),$async$J)
case 3:q=new k.aW(j,i.b(d))
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$J,r)},
M(a,b){var s=0,r=A.F(t.D),q,p=this,o,n,m,l
var $async$M=A.G(function(c,d){if(c===1)return A.C(d,r)
for(;;)switch(s){case 0:o=A.fV("HKDF",b)
n=A.b(A.b(p.e.crypto).subtle)
m=A.h(o)
if(m==null)m=A.N(m)
l=A
s=3
return A.m(A.ai(A.b(n.deriveBits(m,a,256)),t.a),$async$M)
case 3:q=l.I(d,0,null)
s=1
break
case 1:return A.D(q,r)}})
return A.E($async$M,r)}}
A.ci.prototype={}
A.de.prototype={
ba(){var s=this
if(s.b==null)return
if(++s.d>s.a||Date.now()-s.c>2000)s.bb()},
bb(){this.a=this.d=0
this.b=null}}
A.e4.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.dZ.prototype={
$1(a){return t.p.a(a).c===this.a},
$S:10}
A.eo.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.ep.prototype={
$1(a){return t.p.a(a).c===this.a},
$S:10}
A.eg.prototype={
$1(a){t.cH.a(a)
A.js("["+a.d+"] "+a.a.a+": "+a.b)},
$S:22}
A.eh.prototype={
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
m=A.dR(q.codec)
l=A.i(q.msgType)
k=A.i(q.keyProviderId)
j=$.ah.j(0,k)
if(j==null){s.i(B.b,"KeyProvider not found for "+k,g,g)
return}i=A.fY(o,n,j)
s=A.b(r.readable)
h=A.b(r.writable)
i.a_(m==null?g:m,!1,p,l,s,n,h)},
$S:11}
A.ej.prototype={
$1(d2){var s=0,r=A.F(t.P),q,p=2,o=[],n,m,l,k,j,i,h,g,f,e,d,c,b,a,a0,a1,a2,a3,a4,a5,a6,a7,a8,a9,b0,b1,b2,b3,b4,b5,b6,b7,b8,b9,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,d0,d1
var $async$$1=A.G(function(d3,d4){if(d3===1){o.push(d4)
s=p}for(;;)switch(s){case 0:c6=t.f.a(A.fU(d2.data))
c7=c6.j(0,"msgType")
c8=A.dR(c6.j(0,"msgId"))
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
a2=J.e_(a0)
a3=A.cL(a2.j(a0,"sharedKey"))
a4=new Uint8Array(A.at(B.n.I(A.i(a2.j(a0,"ratchetSalt")))))
a5=A.n(a2.j(a0,"ratchetWindowSize"))
a6=a2.j(a0,"failureTolerance")
a6=A.n(a6==null?-1:a6)
a7=a2.j(a0,"uncryptedMagicBytes")!=null?new Uint8Array(A.at(B.n.I(A.i(a2.j(a0,"uncryptedMagicBytes"))))):null
a8=a2.j(a0,"keyRingSize")
a8=A.n(a8==null?16:a8)
a2=a2.j(a0,"discardFrameWhenCryptorNotReady")
a9=new A.d6(a3,a4,a5,a6,a7,a8,A.cL(a2==null?!1:a2))
c9.i(B.a,"Init with keyProviderOptions:\n "+a9.k(0),null,null)
c9=v.G
a2=A.b(c9.self)
a3=t.N
a4=new Uint8Array(0)
$.ah.v(0,a1,new A.ch(a2,a9,A.bp(a3,t.bW),a4))
A.b(c9.self).postMessage(A.h(A.j(["type","init","msgId",c8,"msgType","response"],a3,t.T)))
s=4
break
case 6:a1=A.i(c6.j(0,"keyProviderId"))
c9.i(B.a,"Dispose keyProvider "+a1,null,null)
$.ah.c2(0,a1)
A.b(v.G.self).postMessage(A.h(A.j(["type","dispose","msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 7:b0=A.cL(c6.j(0,"enabled"))
b1=A.i(c6.j(0,"trackId"))
a2=$.aP
a3=A.af(a2)
a4=a3.h("aF<1>")
b2=A.f6(new A.aF(a2,a3.h("W(1)").a(new A.ea(b1)),a4),a4.h("f.E"))
for(a2=b2.length,a3=""+b0,a4="Set enable "+a3+" for trackId ",a5="setEnabled["+a3+u.h,b3=0;b3<b2.length;b2.length===a2||(0,A.c0)(b2),++b3){k=b2[b3]
c9.i(B.a,a4+k.c,null,null)
if(k.x!==B.j){c9.i(B.f,a5,null,null)
k.x=B.m}c9.i(B.a,"setEnabled for "+A.c(k.b)+", enabled: "+a3,null,null)
k.r=b0}A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorEnabled","enable",b0,"msgId",c8,"msgType","response"],t.N,t.X)))
s=4
break
case 8:case 9:b4=c6.j(0,"kind")
b5=A.cL(c6.j(0,"exist"))
n=A.i(c6.j(0,"participantId"))
b1=c6.j(0,"trackId")
b6=A.b(c6.j(0,"readableStream"))
b7=A.b(c6.j(0,"writableStream"))
a1=A.i(c6.j(0,"keyProviderId"))
c9.i(B.a,"SetupTransform for kind "+A.c(b4)+", trackId "+A.c(b1)+", participantId "+n+", "+J.ew(b6).k(0)+" "+J.ew(b7).k(0)+"}",null,null)
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorSetup","participantId",n,"trackId",b1,"exist",b5,"operation",c7,"error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.z)))
s=1
break}A.i(b1)
k=A.fY(n,b1,b8)
A.i(c7)
A.i(b4)
s=25
return A.m(k.bf(b5&&c7==="decode",b4,c7,b6,b1,b7),$async$$1)
case 25:A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorSetup","participantId",n,"trackId",b1,"exist",b5,"operation",c7,"msgId",c8,"msgType","response"],t.N,t.z)))
k.x=B.m
s=4
break
case 10:b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Removing trackId "+b1,null,null)
A.jx(b1)
A.b(v.G.self).postMessage(A.h(A.j(["type","cryptorRemoved","trackId",b1,"msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 11:case 12:b9=new Uint8Array(A.at(B.n.I(A.i(c6.j(0,"key")))))
e=A.n(c6.j(0,"keyIndex"))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=b8.c.a
a3=""+e
s=a2?26:28
break
case 26:c9.i(B.a,"Set SharedKey keyIndex "+a3,null,null)
s=29
return A.m(b8.Z(b9,e),$async$$1)
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
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=b8.c.a
s=a2?31:33
break
case 31:c9.i(B.a,"RatchetKey for SharedKey, keyIndex "+A.c(e),null,null)
s=34
return A.m(b8.Y().E(A.eJ(e)),$async$$1)
case 34:c0=d4
s=32
break
case 33:c9.i(B.a,"RatchetKey for participant "+n+", keyIndex "+A.c(e),null,null)
s=35
return A.m(b8.G(n).E(A.eJ(e)),$async$$1)
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
a3=A.af(a2)
a4=a3.h("aF<1>")
b2=A.f6(new A.aF(a2,a3.h("W(1)").a(new A.eb(b1)),a4),a4.h("f.E"))
for(a2=b2.length,b3=0;b3<b2.length;b2.length===a2||(0,A.c0)(b2),++b3){c1=b2[b3]
c9.i(B.a,"Set keyIndex for trackId "+c1.c,null,null)
A.n(e)
if(c1.x!==B.j){c9.i(B.f,"setKeyIndex: lastError != CryptorError.kOk, reset state to kNew",null,null)
c1.x=B.m}c9.i(B.a,"setKeyIndex for "+A.c(c1.b)+", newIndex: "+e,null,null)
c1.y=e}A.b(v.G.self).postMessage(A.h(A.j(["type","setKeyIndex","keyIndex",e,"msgId",c8,"msgType","response"],t.N,t.z)))
s=4
break
case 16:case 17:e=A.n(c6.j(0,"keyIndex"))
n=A.i(c6.j(0,"participantId"))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=""+e
s=b8.c.a?36:38
break
case 36:c9.i(B.a,"Export SharedKey keyIndex "+a2,null,null)
s=39
return A.m(b8.Y().W(e),$async$$1)
case 39:b9=d4
s=37
break
case 38:c9.i(B.a,"Export key for participant "+n+", keyIndex "+a2,null,null)
s=40
return A.m(b8.G(n).W(e),$async$$1)
case 40:b9=d4
case 37:c9=A.b(v.G.self)
a2=b9!=null?B.u.I(t.B.h("aw.S").a(b9)):""
c9.postMessage(A.h(A.j(["type","exportKey","participantId",n,"keyIndex",e,"exportedKey",a2,"msgId",c8,"msgType","response"],t.N,t.X)))
s=4
break
case 18:c2=new Uint8Array(A.at(B.n.I(A.i(c6.j(0,"sifTrailer")))))
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","setKey","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}b8.c.e=c2
c9.i(B.a,"SetSifTrailer = "+A.c(c2),null,null)
for(a2=$.aP,a3=a2.length,b3=0;b3<a2.length;a2.length===a3||(0,A.c0)(a2),++b3){c1=a2[b3]
c9.i(B.a,"setSifTrailer for "+A.c(c1.b)+", magicBytes: "+A.c(c2),null,null)
c1.e.d.e=c2}A.b(v.G.self).postMessage(A.h(A.j(["type","setSifTrailer","msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 19:c3=A.i(c6.j(0,"codec"))
b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Update codec for trackId "+b1+", codec "+c3,null,null)
k=A.az($.aP,new A.ec(b1),t.j)
if(k!=null){if(k.x!==B.j){c9.i(B.f,"updateCodec["+c3+u.h,null,null)
k.x=B.m}c9.i(B.a,"updateCodec for "+A.c(k.b)+", codec: "+c3,null,null)
k.d=c3}A.b(v.G.self).postMessage(A.h(A.j(["type","updateCodec","msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 20:b1=A.i(c6.j(0,"trackId"))
c9.i(B.a,"Dispose for trackId "+b1,null,null)
k=A.az($.aP,new A.ed(b1),t.j)
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
if(A.az(B.B,new A.ee(c4),t.b)==null){A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","error","algorithm not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}a2=""+e
c9.i(B.a,"Encrypt for dataCryptorId "+A.c(l)+", participantId "+A.c(n)+", keyIndex "+a2+", data length "+J.aQ(m)+", algorithm "+c4,null,null)
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}k=A.fW(n,l,b8)
a3=k
c9.i(B.a,"setKeyIndex for "+A.c(a3.b)+", newIndex: "+a2,null,null)
a3.e=e
p=42
s=45
return A.m(k.ad(k.d,m),$async$$1)
case 45:j=d4
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorEncrypt","participantId",n,"dataCryptorId",l,"data",j.a,"keyIndex",j.b,"iv",j.c,"msgId",c8,"msgType","response"],t.N,t.X)))
p=2
s=44
break
case 42:p=41
d0=o.pop()
i=A.L(d0)
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
if(A.az(B.B,new A.ef(c4),t.b)==null){A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","error","algorithm not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}c9.i(B.a,"Decrypt for dataCryptorId "+A.c(d)+", participantId "+A.c(h)+", keyIndex "+A.c(e)+", data length "+J.aQ(g)+", algorithm "+c4,null,null)
a1=A.i(c6.j(0,"keyProviderId"))
b8=$.ah.j(0,a1)
if(b8==null){c9.i(B.b,"KeyProvider not found for "+a1,null,null)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","error","KeyProvider not found","msgId",c8,"msgType","response"],t.N,t.T)))
s=1
break}c=A.fW(h,d,b8)
p=47
s=50
return A.m(c.U(c.d,new A.bh(g,e,f)),$async$$1)
case 50:b=d4
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDecrypt","participantId",h,"dataCryptorId",d,"data",b,"msgId",c8,"msgType","response"],t.N,t.X)))
p=2
s=49
break
case 47:p=46
d1=o.pop()
a=A.L(d1)
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
A.jy(l)
A.b(v.G.self).postMessage(A.h(A.j(["type","dataCryptorDispose","dataCryptorId",l,"msgId",c8,"msgType","response"],t.N,t.T)))
s=4
break
case 24:c9.i(B.b,"Unknown message kind "+c6.k(0),null,null)
case 4:case 1:return A.D(q,r)
case 2:return A.C(o.at(-1),r)}})
return A.E($async$$1,r)},
$S:23}
A.ea.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.eb.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.ec.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.ed.prototype={
$1(a){return t.j.a(a).c===this.a},
$S:1}
A.ee.prototype={
$1(a){return t.b.a(a).b===this.a},
$S:12}
A.ef.prototype={
$1(a){return t.b.a(a).b===this.a},
$S:12}
A.ei.prototype={
$1(a){this.a.$1(A.b(a))},
$S:11};(function aliases(){var s=J.an.prototype
s.bi=s.k
s=A.aG.prototype
s.bj=s.ag})();(function installTearOffs(){var s=hunkHelpers._static_1,r=hunkHelpers._static_0,q=hunkHelpers._static_2,p=hunkHelpers._instance_2u,o=hunkHelpers._instance_0u
s(A,"j5","hU",4)
s(A,"j6","hV",4)
s(A,"j7","hW",4)
r(A,"fS","iZ",0)
q(A,"j9","iS",7)
r(A,"j8","iR",0)
p(A.x.prototype,"gbp","bq",7)
o(A.b3.prototype,"gby","bz",0)
var n
p(n=A.am.prototype,"gbR","ac",9)
p(n,"gbN","T",9)})();(function inheritance(){var s=hunkHelpers.mixin,r=hunkHelpers.inherit,q=hunkHelpers.inheritMany
r(A.k,null)
q(A.k,[A.eA,J.cb,A.bA,J.bd,A.b2,A.w,A.dd,A.f,A.aB,A.br,A.bF,A.M,A.dh,A.dc,A.bi,A.bS,A.al,A.aD,A.d7,A.bn,A.cK,A.a2,A.cG,A.dN,A.dL,A.cC,A.O,A.b_,A.ae,A.aG,A.cE,A.aH,A.x,A.cD,A.bK,A.cH,A.b3,A.cI,A.dm,A.bN,A.u,A.aw,A.c7,A.du,A.dt,A.c8,A.dv,A.cq,A.bB,A.dw,A.cY,A.z,A.cJ,A.cx,A.db,A.dH,A.ao,A.aC,A.aX,A.bh,A.ax,A.d0,A.am,A.d6,A.ch,A.aW,A.cr,A.ci,A.de])
q(J.cb,[J.cd,J.bk,J.bl,J.aU,J.aV,J.cf,J.aT])
q(J.bl,[J.an,J.y,A.ap,A.bv])
q(J.an,[J.cs,J.bC,J.a7])
r(J.cc,A.bA)
r(J.d5,J.y)
q(J.cf,[J.bj,J.ce])
q(A.w,[A.bm,A.ac,A.cg,A.cB,A.cu,A.cF,A.c1,A.a_,A.bD,A.cA,A.aE,A.c6])
q(A.f,[A.l,A.a9,A.aF])
q(A.l,[A.a8,A.bo,A.bM])
r(A.bg,A.a9)
r(A.aa,A.a8)
r(A.by,A.ac)
q(A.al,[A.c4,A.c5,A.cy,A.e5,A.e7,A.dq,A.dp,A.dS,A.dK,A.dF,A.df,A.e9,A.em,A.en,A.dX,A.e4,A.dZ,A.eo,A.ep,A.eg,A.eh,A.ej,A.ea,A.eb,A.ec,A.ed,A.ee,A.ef,A.ei])
q(A.cy,[A.cw,A.aR])
q(A.aD,[A.aA,A.bL])
q(A.c5,[A.e6,A.dT,A.dW,A.dG,A.da])
r(A.aY,A.ap)
q(A.bv,[A.bs,A.H])
q(A.H,[A.bO,A.bQ])
r(A.bP,A.bO)
r(A.bt,A.bP)
r(A.bR,A.bQ)
r(A.bu,A.bR)
q(A.bt,[A.cj,A.ck])
q(A.bu,[A.cl,A.cm,A.cn,A.co,A.cp,A.bw,A.bx])
r(A.bU,A.cF)
q(A.c4,[A.dr,A.ds,A.dM,A.dx,A.dB,A.dA,A.dz,A.dy,A.dE,A.dD,A.dC,A.dg,A.dJ,A.dn,A.dV,A.d9,A.cT,A.cU,A.cZ,A.d_])
r(A.b5,A.b_)
r(A.bH,A.b5)
r(A.b1,A.bH)
r(A.bI,A.ae)
r(A.aq,A.bI)
r(A.bT,A.aG)
r(A.bG,A.cE)
r(A.bJ,A.bK)
r(A.b4,A.bL)
r(A.c3,A.aw)
q(A.c7,[A.cS,A.cR])
q(A.a_,[A.aZ,A.ca])
q(A.dv,[A.ak,A.a0])
s(A.bO,A.u)
s(A.bP,A.M)
s(A.bQ,A.u)
s(A.bR,A.M)})()
var v={G:typeof self!="undefined"?self:globalThis,typeUniverse:{eC:new Map(),tR:{},eT:{},tPV:{},sEA:[]},mangledGlobalNames:{a:"int",o:"double",aO:"num",a5:"String",W:"bool",z:"Null",r:"List",k:"Object",bq:"Map",q:"JSObject"},mangledNames:{},types:["~()","W(am)","a1<~>()","~(@)","~(~())","z(@)","z()","~(k,a3)","k?(k?)","~(q,q)","W(ax)","z(q)","W(ak)","@(@)","@(@,a5)","@(a5)","z(~())","z(@,a3)","~(a,@)","z(k,a3)","~(k?,k?)","aX()","~(aC)","a1<z>(q)"],interceptorsByTag:null,leafTags:null,arrayRti:Symbol("$ti")}
A.ih(v.typeUniverse,JSON.parse('{"a7":"an","cs":"an","bC":"an","jC":"ap","cd":{"W":[],"p":[]},"bk":{"z":[],"p":[]},"bl":{"q":[]},"an":{"q":[]},"y":{"r":["1"],"l":["1"],"q":[],"f":["1"]},"cc":{"bA":[]},"d5":{"y":["1"],"r":["1"],"l":["1"],"q":[],"f":["1"]},"bd":{"a4":["1"]},"cf":{"o":[],"aO":[]},"bj":{"o":[],"a":[],"aO":[],"p":[]},"ce":{"o":[],"aO":[],"p":[]},"aT":{"a5":[],"fc":[],"p":[]},"b2":{"hm":[]},"bm":{"w":[]},"l":{"f":["1"]},"a8":{"l":["1"],"f":["1"]},"aB":{"a4":["1"]},"a9":{"f":["2"],"f.E":"2"},"bg":{"a9":["1","2"],"l":["2"],"f":["2"],"f.E":"2"},"br":{"a4":["2"]},"aa":{"a8":["2"],"l":["2"],"f":["2"],"f.E":"2","a8.E":"2"},"aF":{"f":["1"],"f.E":"1"},"bF":{"a4":["1"]},"by":{"ac":[],"w":[]},"cg":{"w":[]},"cB":{"w":[]},"bS":{"a3":[]},"al":{"ay":[]},"c4":{"ay":[]},"c5":{"ay":[]},"cy":{"ay":[]},"cw":{"ay":[]},"aR":{"ay":[]},"cu":{"w":[]},"aA":{"aD":["1","2"],"f5":["1","2"],"bq":["1","2"]},"bo":{"l":["1"],"f":["1"],"f.E":"1"},"bn":{"a4":["1"]},"aY":{"ap":[],"q":[],"be":[],"p":[]},"ap":{"q":[],"be":[],"p":[]},"bv":{"q":[]},"cK":{"be":[]},"bs":{"ey":[],"q":[],"p":[]},"H":{"P":["1"],"q":[]},"bt":{"u":["o"],"H":["o"],"r":["o"],"P":["o"],"l":["o"],"q":[],"f":["o"],"M":["o"]},"bu":{"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"]},"cj":{"cW":[],"u":["o"],"H":["o"],"r":["o"],"P":["o"],"l":["o"],"q":[],"f":["o"],"M":["o"],"p":[],"u.E":"o"},"ck":{"cX":[],"u":["o"],"H":["o"],"r":["o"],"P":["o"],"l":["o"],"q":[],"f":["o"],"M":["o"],"p":[],"u.E":"o"},"cl":{"d1":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"cm":{"d2":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"cn":{"d3":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"co":{"dj":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"cp":{"dk":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"bw":{"dl":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"bx":{"cz":[],"u":["a"],"H":["a"],"r":["a"],"P":["a"],"l":["a"],"q":[],"f":["a"],"M":["a"],"p":[],"u.E":"a"},"cF":{"w":[]},"bU":{"ac":[],"w":[]},"ae":{"b0":["1"],"ar":["1"]},"O":{"w":[]},"b1":{"bH":["1"],"b5":["1"],"b_":["1"]},"aq":{"bI":["1"],"ae":["1"],"b0":["1"],"ar":["1"]},"aG":{"fj":["1"],"fu":["1"],"ar":["1"]},"bT":{"aG":["1"],"fj":["1"],"fu":["1"],"ar":["1"]},"bG":{"cE":["1"]},"x":{"a1":["1"]},"bH":{"b5":["1"],"b_":["1"]},"bI":{"ae":["1"],"b0":["1"],"ar":["1"]},"b5":{"b_":["1"]},"bJ":{"bK":["1"]},"b3":{"b0":["1"]},"bL":{"aD":["1","2"],"bq":["1","2"]},"b4":{"bL":["1","2"],"aD":["1","2"],"bq":["1","2"]},"bM":{"l":["1"],"f":["1"],"f.E":"1"},"bN":{"a4":["1"]},"aD":{"bq":["1","2"]},"c3":{"aw":["r<a>","a5"],"aw.S":"r<a>"},"o":{"aO":[]},"a":{"aO":[]},"r":{"l":["1"],"f":["1"]},"a5":{"fc":[]},"c1":{"w":[]},"ac":{"w":[]},"a_":{"w":[]},"aZ":{"w":[]},"ca":{"w":[]},"bD":{"w":[]},"cA":{"w":[]},"aE":{"w":[]},"c6":{"w":[]},"cq":{"w":[]},"bB":{"w":[]},"cJ":{"a3":[]},"d3":{"r":["a"],"l":["a"],"f":["a"]},"cz":{"r":["a"],"l":["a"],"f":["a"]},"dl":{"r":["a"],"l":["a"],"f":["a"]},"d1":{"r":["a"],"l":["a"],"f":["a"]},"dj":{"r":["a"],"l":["a"],"f":["a"]},"d2":{"r":["a"],"l":["a"],"f":["a"]},"dk":{"r":["a"],"l":["a"],"f":["a"]},"cW":{"r":["o"],"l":["o"],"f":["o"]},"cX":{"r":["o"],"l":["o"],"f":["o"]}}'))
A.ig(v.typeUniverse,JSON.parse('{"l":1,"H":1,"bK":1,"c7":2}'))
var u={o:"Cannot fire new event. Controller is already firing an event",c:"Error handler must accept one Object or one Object and a StackTrace as arguments, and return a value of the returned future's type",r:"[decodeFunction] decryption failed even after ratcheting",w:"[ratchetKeyInternal] cannot ratchet anymore",h:"]: lastError != CryptorError.kOk, reset state to kNew",f:"decodeFunction: decryption success, buffer length ",D:"decodeFunction::decryptFrameInternal: decrypted: ",E:"decodeFunction::decryptFrameInternal: ratchetKey: decryption ok, newState: kKeyRatcheted"}
var t=(function rtii(){var s=A.b9
return{h:s("@<~>"),b:s("ak"),n:s("O"),B:s("c3"),J:s("be"),V:s("ey"),p:s("ax"),d:s("l<@>"),C:s("w"),G:s("cW"),q:s("cX"),j:s("am"),Z:s("ay"),O:s("d1"),k:s("d2"),U:s("d3"),R:s("f<@>"),e:s("f<a>"),s:s("y<a5>"),r:s("y<@>"),t:s("y<a>"),c:s("y<k?>"),u:s("bk"),m:s("q"),g:s("a7"),w:s("P<@>"),x:s("aW"),cK:s("r<@>"),L:s("r<a>"),bG:s("r<aW?>"),cH:s("aC"),I:s("aX"),f:s("bq<@,@>"),a:s("aY"),P:s("z"),K:s("k"),bW:s("cr"),cY:s("jE"),l:s("a3"),N:s("a5"),a4:s("p"),b7:s("ac"),c0:s("dj"),bk:s("dk"),ca:s("dl"),D:s("cz"),cr:s("bC"),_:s("x<@>"),aQ:s("x<a>"),A:s("b4<k?,k?>"),W:s("bT<aC>"),y:s("W"),c1:s("W(k)"),i:s("o"),z:s("@"),bd:s("@()"),v:s("@(k)"),Q:s("@(k,a3)"),S:s("a"),a5:s("bh?"),bc:s("a1<z>?"),b1:s("q?"),aF:s("aW?"),X:s("k?"),T:s("a5?"),E:s("cz?"),F:s("aH<@,@>?"),cG:s("W?"),dd:s("o?"),a3:s("a?"),ae:s("aO?"),Y:s("~()?"),o:s("aO"),H:s("~"),M:s("~()"),bo:s("~(k)"),aD:s("~(k,a3)"),aS:s("~(a,@)")}})();(function constants(){var s=hunkHelpers.makeConstList
B.N=J.cb.prototype
B.d=J.y.prototype
B.h=J.bj.prototype
B.k=J.aT.prototype
B.O=J.a7.prototype
B.P=J.bl.prototype
B.r=A.bs.prototype
B.e=A.bx.prototype
B.C=J.cs.prototype
B.t=J.bC.prototype
B.n=new A.cR()
B.u=new A.cS()
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

B.L=new A.cq()
B.a2=new A.dd()
B.l=new A.dm()
B.o=new A.cJ()
B.m=new A.a0(0,"kNew")
B.j=new A.a0(1,"kOk")
B.x=new A.a0(2,"kDecryptError")
B.y=new A.a0(3,"kEncryptError")
B.z=new A.a0(4,"kUnsupportedCodec")
B.p=new A.a0(5,"kMissingKey")
B.A=new A.a0(6,"kKeyRatcheted")
B.q=new A.a0(7,"kInternalError")
B.M=new A.a0(8,"kDisposed")
B.a=new A.ao("CONFIG",700)
B.c=new A.ao("FINER",400)
B.i=new A.ao("FINE",500)
B.f=new A.ao("INFO",800)
B.b=new A.ao("WARNING",900)
B.D=new A.ak(0,"kAesGcm")
B.E=new A.ak(1,"kAesCbc")
B.B=s([B.D,B.E],A.b9("y<ak>"))
B.Q=A.Z("be")
B.R=A.Z("ey")
B.S=A.Z("cW")
B.T=A.Z("cX")
B.U=A.Z("d1")
B.V=A.Z("d2")
B.W=A.Z("d3")
B.X=A.Z("q")
B.Y=A.Z("k")
B.Z=A.Z("dj")
B.a_=A.Z("dk")
B.a0=A.Z("dl")
B.a1=A.Z("cz")})();(function staticFields(){$.dI=null
$.S=A.K([],A.b9("y<k>"))
$.fd=null
$.f0=null
$.f_=null
$.fX=null
$.fR=null
$.h_=null
$.dY=null
$.e8=null
$.eQ=null
$.b6=null
$.bY=null
$.bZ=null
$.eL=!1
$.t=B.l
$.f8=0
$.hA=A.bp(t.N,t.I)
$.aP=A.K([],A.b9("y<am>"))
$.eU=A.K([],A.b9("y<ax>"))
$.ah=A.bp(t.N,A.b9("ch"))})();(function lazyInitializers(){var s=hunkHelpers.lazyFinal
s($,"jA","h3",()=>A.e2("_$dart_dartClosure"))
s($,"jz","eq",()=>A.e2("_$dart_dartClosure_dartJSInterop"))
s($,"jT","cO",()=>A.fa(0))
s($,"jV","hh",()=>A.K([new J.cc()],A.b9("y<bA>")))
s($,"jG","h4",()=>A.ad(A.di({
toString:function(){return"$receiver$"}})))
s($,"jH","h5",()=>A.ad(A.di({$method$:null,
toString:function(){return"$receiver$"}})))
s($,"jI","h6",()=>A.ad(A.di(null)))
s($,"jJ","h7",()=>A.ad(function(){var $argumentsExpr$="$arguments$"
try{null.$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"jM","ha",()=>A.ad(A.di(void 0)))
s($,"jN","hb",()=>A.ad(function(){var $argumentsExpr$="$arguments$"
try{(void 0).$method$($argumentsExpr$)}catch(r){return r.message}}()))
s($,"jL","h9",()=>A.ad(A.fm(null)))
s($,"jK","h8",()=>A.ad(function(){try{null.$method$}catch(r){return r.message}}()))
s($,"jP","hd",()=>A.ad(A.fm(void 0)))
s($,"jO","hc",()=>A.ad(function(){try{(void 0).$method$}catch(r){return r.message}}()))
s($,"jQ","eV",()=>A.hT())
s($,"jS","hf",()=>new Int8Array(A.at(A.K([-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-2,-1,-2,-2,-2,-2,-2,62,-2,62,-2,63,52,53,54,55,56,57,58,59,60,61,-2,-2,-2,-1,-2,-2,-2,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,-2,-2,-2,-2,63,-2,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,-2,-2,-2,-2,-2],t.t))))
s($,"jR","he",()=>A.fa(0))
s($,"jU","hg",()=>A.el(B.Y))
s($,"jD","er",()=>{var r=new A.dH(A.hC(8))
r.bk()
return r})
s($,"jB","cN",()=>A.d8(""))
s($,"jX","v",()=>A.d8("E2EE.Worker"))})();(function nativeSupport(){!function(){var s=function(a){var m={}
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
hunkHelpers.setOrUpdateInterceptorsByTag({SharedArrayBuffer:A.ap,ArrayBuffer:A.aY,ArrayBufferView:A.bv,DataView:A.bs,Float32Array:A.cj,Float64Array:A.ck,Int16Array:A.cl,Int32Array:A.cm,Int8Array:A.cn,Uint16Array:A.co,Uint32Array:A.cp,Uint8ClampedArray:A.bw,CanvasPixelArray:A.bw,Uint8Array:A.bx})
hunkHelpers.setOrUpdateLeafTags({SharedArrayBuffer:true,ArrayBuffer:true,ArrayBufferView:false,DataView:true,Float32Array:true,Float64Array:true,Int16Array:true,Int32Array:true,Int8Array:true,Uint16Array:true,Uint32Array:true,Uint8ClampedArray:true,CanvasPixelArray:true,Uint8Array:false})
A.H.$nativeSuperclassTag="ArrayBufferView"
A.bO.$nativeSuperclassTag="ArrayBufferView"
A.bP.$nativeSuperclassTag="ArrayBufferView"
A.bt.$nativeSuperclassTag="ArrayBufferView"
A.bQ.$nativeSuperclassTag="ArrayBufferView"
A.bR.$nativeSuperclassTag="ArrayBufferView"
A.bu.$nativeSuperclassTag="ArrayBufferView"})()
Function.prototype.$1=function(a){return this(a)}
Function.prototype.$0=function(){return this()}
Function.prototype.$2=function(a,b){return this(a,b)}
Function.prototype.$3=function(a,b,c){return this(a,b,c)}
Function.prototype.$4=function(a,b,c,d){return this(a,b,c,d)}
Function.prototype.$5=function(a,b,c,d,e){return this(a,b,c,d,e)}
Function.prototype.$6=function(a,b,c,d,e,f){return this(a,b,c,d,e,f)}
Function.prototype.$1$1=function(a){return this(a)}
convertAllToFastObject(w)
convertToFastObject($);(function(a){if(typeof document==="undefined"){a(null)
return}if(typeof document.currentScript!="undefined"){a(document.currentScript)
return}var s=document.scripts
function onLoad(b){for(var q=0;q<s.length;++q){s[q].removeEventListener("load",onLoad,false)}a(b.target)}for(var r=0;r<s.length;++r){s[r].addEventListener("load",onLoad,false)}})(function(a){v.currentScript=a
var s=A.eS
if(typeof dartMainRunner==="function"){dartMainRunner(s,[])}else{s([])}})})()
//# sourceMappingURL=e2ee.worker.dart.js.map
