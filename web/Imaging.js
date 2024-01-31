var Imaging = (function() {

var Module = (() => {
  var _scriptDir = typeof document !== 'undefined' && document.currentScript ? document.currentScript.src : undefined;
  if (typeof __filename !== 'undefined') _scriptDir = _scriptDir || __filename;
  return (
function(moduleArg = {}) {

var b=moduleArg,f,k;b.ready=new Promise((a,c)=>{f=a;k=c});var l=Object.assign({},b),n="object"==typeof window,p="function"==typeof importScripts,q="object"==typeof process&&"object"==typeof process.versions&&"string"==typeof process.versions.node,r="",t,u,x;
if(q){var fs=require("fs"),y=require("path");r=p?y.dirname(r)+"/":__dirname+"/";t=(a,c)=>{a=a.startsWith("file://")?new URL(a):y.normalize(a);return fs.readFileSync(a,c?void 0:"utf8")};x=a=>{a=t(a,!0);a.buffer||(a=new Uint8Array(a));return a};u=(a,c,d,e=!0)=>{a=a.startsWith("file://")?new URL(a):y.normalize(a);fs.readFile(a,e?void 0:"utf8",(g,h)=>{g?d(g):c(e?h.buffer:h)})};process.argv.slice(2);b.inspect=()=>"[Emscripten Module object]"}else if(n||p)p?r=self.location.href:"undefined"!=typeof document&&
document.currentScript&&(r=document.currentScript.src),_scriptDir&&(r=_scriptDir),0!==r.indexOf("blob:")?r=r.substr(0,r.replace(/[?#].*/,"").lastIndexOf("/")+1):r="",t=a=>{var c=new XMLHttpRequest;c.open("GET",a,!1);c.send(null);return c.responseText},p&&(x=a=>{var c=new XMLHttpRequest;c.open("GET",a,!1);c.responseType="arraybuffer";c.send(null);return new Uint8Array(c.response)}),u=(a,c,d)=>{var e=new XMLHttpRequest;e.open("GET",a,!0);e.responseType="arraybuffer";e.onload=()=>{200==e.status||0==
e.status&&e.response?c(e.response):d()};e.onerror=d;e.send(null)};var aa=b.print||console.log.bind(console),z=b.printErr||console.error.bind(console);Object.assign(b,l);l=null;var A;b.wasmBinary&&(A=b.wasmBinary);var noExitRuntime=b.noExitRuntime||!0;"object"!=typeof WebAssembly&&B("no native wasm support detected");var D,E=!1,F,G;
function H(){var a=D.buffer;b.HEAP8=new Int8Array(a);b.HEAP16=new Int16Array(a);b.HEAPU8=F=new Uint8Array(a);b.HEAPU16=new Uint16Array(a);b.HEAP32=new Int32Array(a);b.HEAPU32=G=new Uint32Array(a);b.HEAPF32=new Float32Array(a);b.HEAPF64=new Float64Array(a)}var J=[],K=[],L=[];function ba(){var a=b.preRun.shift();J.unshift(a)}var M=0,N=null,O=null;
function B(a){if(b.onAbort)b.onAbort(a);a="Aborted("+a+")";z(a);E=!0;a=new WebAssembly.RuntimeError(a+". Build with -sASSERTIONS for more info.");k(a);throw a;}function P(a){return a.startsWith("data:application/octet-stream;base64,")}var Q;Q="Imaging.wasm";if(!P(Q)){var R=Q;Q=b.locateFile?b.locateFile(R,r):r+R}function S(a){if(a==Q&&A)return new Uint8Array(A);if(x)return x(a);throw"both async and sync fetching of the wasm failed";}
function ca(a){if(!A&&(n||p)){if("function"==typeof fetch&&!a.startsWith("file://"))return fetch(a,{credentials:"same-origin"}).then(c=>{if(!c.ok)throw"failed to load wasm binary file at '"+a+"'";return c.arrayBuffer()}).catch(()=>S(a));if(u)return new Promise((c,d)=>{u(a,e=>c(new Uint8Array(e)),d)})}return Promise.resolve().then(()=>S(a))}function T(a,c,d){return ca(a).then(e=>WebAssembly.instantiate(e,c)).then(e=>e).then(d,e=>{z(`failed to asynchronously prepare wasm: ${e}`);B(e)})}
function da(a,c){var d=Q;return A||"function"!=typeof WebAssembly.instantiateStreaming||P(d)||d.startsWith("file://")||q||"function"!=typeof fetch?T(d,a,c):fetch(d,{credentials:"same-origin"}).then(e=>WebAssembly.instantiateStreaming(e,a).then(c,function(g){z(`wasm streaming compile failed: ${g}`);z("falling back to ArrayBuffer instantiation");return T(d,a,c)}))}
var U=a=>{for(;0<a.length;)a.shift()(b)},V="undefined"!=typeof TextDecoder?new TextDecoder("utf8"):void 0,W=(a,c,d)=>{var e=c+d;for(d=c;a[d]&&!(d>=e);)++d;if(16<d-c&&a.buffer&&V)return V.decode(a.subarray(c,d));for(e="";c<d;){var g=a[c++];if(g&128){var h=a[c++]&63;if(192==(g&224))e+=String.fromCharCode((g&31)<<6|h);else{var m=a[c++]&63;g=224==(g&240)?(g&15)<<12|h<<6|m:(g&7)<<18|h<<12|m<<6|a[c++]&63;65536>g?e+=String.fromCharCode(g):(g-=65536,e+=String.fromCharCode(55296|g>>10,56320|g&1023))}}else e+=
String.fromCharCode(g)}return e},ea=[null,[],[]],fa={e:(a,c,d)=>F.copyWithin(a,c,c+d),c:a=>{var c=F.length;a>>>=0;if(2147483648<a)return!1;for(var d=1;4>=d;d*=2){var e=c*(1+.2/d);e=Math.min(e,a+100663296);var g=Math;e=Math.max(a,e);a:{g=(g.min.call(g,2147483648,e+(65536-e%65536)%65536)-D.buffer.byteLength+65535)/65536;try{D.grow(g);H();var h=1;break a}catch(m){}h=void 0}if(h)return!0}return!1},d:()=>52,b:function(){return 70},a:(a,c,d,e)=>{for(var g=0,h=0;h<d;h++){var m=G[c>>2],C=G[c+4>>2];c+=8;for(var v=
0;v<C;v++){var w=F[m+v],I=ea[a];0===w||10===w?((1===a?aa:z)(W(I,0)),I.length=0):I.push(w)}g+=C}G[e>>2]=g;return 0}},X=function(){function a(d){X=d.exports;D=X.f;H();K.unshift(X.g);M--;b.monitorRunDependencies&&b.monitorRunDependencies(M);0==M&&(null!==N&&(clearInterval(N),N=null),O&&(d=O,O=null,d()));return X}var c={a:fa};M++;b.monitorRunDependencies&&b.monitorRunDependencies(M);if(b.instantiateWasm)try{return b.instantiateWasm(c,a)}catch(d){z(`Module.instantiateWasm callback failed with error: ${d}`),
k(d)}da(c,function(d){a(d.instance)}).catch(k);return{}}();b._ImagingBlend=(a,c,d)=>(b._ImagingBlend=X.h)(a,c,d);b._ImagingBoxBlur=(a,c,d,e)=>(b._ImagingBoxBlur=X.i)(a,c,d,e);b._ImagingGaussianBlur=(a,c,d,e)=>(b._ImagingGaussianBlur=X.j)(a,c,d,e);b._ImagingCopy=a=>(b._ImagingCopy=X.k)(a);b._ImagingCopy2=(a,c)=>(b._ImagingCopy2=X.l)(a,c);b._ImagingSectionEnter=a=>(b._ImagingSectionEnter=X.m)(a);b._ImagingSectionLeave=a=>(b._ImagingSectionLeave=X.n)(a);
b._imageFromRGBA=(a,c,d)=>(b._imageFromRGBA=X.o)(a,c,d);b._imageMode=a=>(b._imageMode=X.p)(a);b._imageWidth=a=>(b._imageWidth=X.q)(a);b._imageHeight=a=>(b._imageHeight=X.r)(a);b._imageLinesize=a=>(b._imageLinesize=X.s)(a);b._imageBlock=a=>(b._imageBlock=X.t)(a);b._blurHashForImage=(a,c,d)=>(b._blurHashForImage=X.u)(a,c,d);b._ImagingFlipLeftRight=(a,c)=>(b._ImagingFlipLeftRight=X.v)(a,c);b._ImagingFlipTopBottom=(a,c)=>(b._ImagingFlipTopBottom=X.w)(a,c);
b._ImagingRotate90=(a,c)=>(b._ImagingRotate90=X.x)(a,c);b._ImagingTranspose=(a,c)=>(b._ImagingTranspose=X.y)(a,c);b._ImagingTransverse=(a,c)=>(b._ImagingTransverse=X.z)(a,c);b._ImagingRotate180=(a,c)=>(b._ImagingRotate180=X.A)(a,c);b._ImagingRotate270=(a,c)=>(b._ImagingRotate270=X.B)(a,c);b._ImagingTransform=(a,c,d,e,g,h,m,C,v,w)=>(b._ImagingTransform=X.C)(a,c,d,e,g,h,m,C,v,w);b._ImagingPaletteNew=a=>(b._ImagingPaletteNew=X.D)(a);b._ImagingPaletteNewBrowser=()=>(b._ImagingPaletteNewBrowser=X.E)();
b._ImagingPaletteDuplicate=a=>(b._ImagingPaletteDuplicate=X.F)(a);b._ImagingPaletteDelete=a=>(b._ImagingPaletteDelete=X.G)(a);b._ImagingPaletteCacheUpdate=(a,c,d,e)=>(b._ImagingPaletteCacheUpdate=X.H)(a,c,d,e);b._ImagingPaletteCachePrepare=a=>(b._ImagingPaletteCachePrepare=X.I)(a);b._ImagingPaletteCacheDelete=a=>(b._ImagingPaletteCacheDelete=X.J)(a);b._ImagingResample=(a,c,d,e,g)=>(b._ImagingResample=X.K)(a,c,d,e,g);
b._ImagingNewPrologueSubtype=(a,c,d,e)=>(b._ImagingNewPrologueSubtype=X.L)(a,c,d,e);b._ImagingNewPrologue=(a,c,d)=>(b._ImagingNewPrologue=X.M)(a,c,d);b._ImagingDelete=a=>(b._ImagingDelete=X.N)(a);b._ImagingMemorySetBlocksMax=(a,c)=>(b._ImagingMemorySetBlocksMax=X.O)(a,c);b._ImagingMemoryClearCache=(a,c)=>(b._ImagingMemoryClearCache=X.P)(a,c);b._ImagingNew=(a,c,d)=>(b._ImagingNew=X.Q)(a,c,d);b._ImagingNewDirty=(a,c,d)=>(b._ImagingNewDirty=X.R)(a,c,d);
b._ImagingNewBlock=(a,c,d)=>(b._ImagingNewBlock=X.S)(a,c,d);b._ImagingNew2Dirty=(a,c,d)=>(b._ImagingNew2Dirty=X.T)(a,c,d);b._ImagingCopyPalette=(a,c)=>(b._ImagingCopyPalette=X.U)(a,c);b._malloc=a=>(b._malloc=X.V)(a);var Y=()=>(Y=X.W)(),ha=a=>(ha=X.X)(a),ia=a=>(ia=X.Y)(a);b.stackAlloc=ia;b.stackSave=Y;b.stackRestore=ha;b.UTF8ToString=(a,c)=>a?W(F,a,c):"";var Z;O=function ja(){Z||ka();Z||(O=ja)};
function ka(){function a(){if(!Z&&(Z=!0,b.calledRun=!0,!E)){U(K);f(b);if(b.onRuntimeInitialized)b.onRuntimeInitialized();if(b.postRun)for("function"==typeof b.postRun&&(b.postRun=[b.postRun]);b.postRun.length;){var c=b.postRun.shift();L.unshift(c)}U(L)}}if(!(0<M)){if(b.preRun)for("function"==typeof b.preRun&&(b.preRun=[b.preRun]);b.preRun.length;)ba();U(J);0<M||(b.setStatus?(b.setStatus("Running..."),setTimeout(function(){setTimeout(function(){b.setStatus("")},1);a()},1)):a())}}
if(b.preInit)for("function"==typeof b.preInit&&(b.preInit=[b.preInit]);0<b.preInit.length;)b.preInit.pop()();ka();


  return moduleArg.ready
}

);
})();
if (typeof exports === 'object' && typeof module === 'object')
  module.exports = Module;
else if (typeof define === 'function' && define['amd'])
  define([], () => Module);
async function single_init() {
var m = await Module();

// Copyright (c) 2020 Famedly GmbH
// SPDX-License-Identifier: AGPL-3.0-or-later

this.Image = class Image {
  constructor(inst) {
    this._inst = inst;
  }

  static fromRGBA(width, height, data) {
    const mem = m._malloc(width * height * 4);
    new Uint8ClampedArray(m.HEAPU8.buffer, mem, width * height * 4).set(data);
    return new Image(m._imageFromRGBA(width, height, mem));
  }

  free() {
    m._ImagingDelete(this._inst);
    this._inst = null;
  }

  get _mode() {
    return m._imageMode(this._inst);
  }

  get mode() {
    return m.UTF8ToString(this._mode);
  }

  get width() {
    return m._imageWidth(this._inst);
  }

  get height() {
    return m._imageHeight(this._inst);
  }

  get linesize() {
    return m._imageLinesize(this._inst);
  }

  get block() {
    return new Uint8ClampedArray(m.HEAPU8.buffer, m._imageBlock(this._inst), this.height * this.linesize);
  }

  copy() {
    return new Image(m._ImagingCopy(this._inst));
  }

  blend(other, alpha) {
    return new Image(m._ImagingBlend(this._inst, other._inst, alpha));
  }

  gaussianBlur(radius, passes) {
    const out = m._ImagingNewDirty(this._mode, this.width, this.height);
    m._ImagingGaussianBlur(out, this._inst, radius, passes);
    return new Image(out);
  }

  rotate90() {
    const out = m._ImagingNewDirty(this._mode, this.height, this.width);
    m._ImagingRotate90(out, this._inst);
    return new Image(out);
  }

  rotate180() {
    const out = m._ImagingNewDirty(this._mode, this.width, this.height);
    m._ImagingRotate180(out, this._inst);
    return new Image(out);
  }

  rotate270() {
    const out = m._ImagingNewDirty(this._mode, this.height, this.width);
    m._ImagingRotate270(out, this._inst);
    return new Image(out);
  }

  flipLeftRight() {
    const out = m._ImagingNewDirty(this._mode, this.width, this.height);
    m._ImagingFlipLeftRight(out, this._inst);
    return new Image(out);
  }

  flipTopBottom() {
    const out = m._ImagingNewDirty(this._mode, this.width, this.height);
    m._ImagingFlipTopBottom(out, this._inst);
    return new Image(out);
  }

  transpose() {
    const out = m._ImagingNewDirty(this._mode, this.height, this.width);
    m._ImagingTranspose(out, this._inst);
    return new Image(out);
  }

  transverse() {
    const out = m._ImagingNewDirty(this._mode, this.height, this.width);
    m._ImagingTransverse(out, this._inst);
    return new Image(out);
  }

  resample(width, height, mode) {
    const modeidx = ["nearest", "lanczos", "bilinear", "bicubic", "box", "hamming"].indexOf(mode.toString().split(".").slice(-1)[0]);
    const sp = m.stackSave();
    try {
      const box = m.stackAlloc(4 * 4);
      m.HEAPF32.set([0, 0, this.width, this.height], box / 4);
      return new Image(m._ImagingResample(this._inst, width, height, modeidx, box));
    } finally {
      m.stackRestore(sp);
    }
  }

  toBlurhash(xComponents, yComponents) {
    return m.UTF8ToString(m._blurHashForImage(this._inst, xComponents, yComponents));
  }

  static async loadEncodedPromise(bytes) {
    var url = URL.createObjectURL(new Blob([bytes]));
    try {
      var img = new window.Image();
      await new Promise(function(resolve, reject) {
        img.onload = resolve;
        img.onerror = reject;
        img.src = url;
      });
      var canvas = document.createElement("canvas");
      canvas.width = img.naturalWidth;
      canvas.height = img.naturalHeight;
      var ctx = canvas.getContext("2d");
      ctx.drawImage(img, 0, 0);
      var data = ctx.getImageData(0, 0, canvas.width, canvas.height);
      return Image(data.width, data.height, data.data);
    } finally {
      URL.revokeObjectURL(url);
    }
  }

  async toJpegPromise(quality) {
    const c = document.createElement("canvas");
    c.width = this.width;
    c.height = this.height;
    const im = new ImageData(this.block, c.width, c.height);
    const ctx = c.getContext("2d");
    ctx.putImageData(im, 0, 0);
    const blob = await new Promise(function(resolve, reject) {
      c.toBlob(resolve, "image/jpeg", {quality: quality / 100});
    });
    const arraybuf = await blob.arrayBuffer();
    return new Uint8Array(arraybuf);
  }
}

}

var prom;

return {init() {
  if (!prom) prom = single_init.call(this);
  return prom;
}};

})();
