var Imaging = (function() {
var Module = (() => {
  var _scriptName = typeof document != 'undefined' ? document.currentScript?.src : undefined;
  if (typeof __filename != 'undefined') _scriptName = _scriptName || __filename;
  return (
async function(moduleArg = {}) {
  var moduleRtn;

var b=moduleArg,e,h,l=new Promise((a,c)=>{e=a;h=c}),n="object"==typeof window,p="undefined"!=typeof WorkerGlobalScope,r="object"==typeof process&&"object"==typeof process.versions&&"string"==typeof process.versions.node&&"renderer"!=process.type,t=Object.assign({},b),u="",v,w;
if(r){var fs=require("fs");require("path");u=__dirname+"/";w=a=>{a=x(a)?new URL(a):a;return fs.readFileSync(a)};v=async a=>{a=x(a)?new URL(a):a;return fs.readFileSync(a,void 0)};process.argv.slice(2)}else if(n||p)p?u=self.location.href:"undefined"!=typeof document&&document.currentScript&&(u=document.currentScript.src),_scriptName&&(u=_scriptName),u.startsWith("blob:")?u="":u=u.slice(0,u.replace(/[?#].*/,"").lastIndexOf("/")+1),p&&(w=a=>{var c=new XMLHttpRequest;c.open("GET",a,!1);c.responseType=
"arraybuffer";c.send(null);return new Uint8Array(c.response)}),v=async a=>{if(x(a))return new Promise((d,f)=>{var g=new XMLHttpRequest;g.open("GET",a,!0);g.responseType="arraybuffer";g.onload=()=>{200==g.status||0==g.status&&g.response?d(g.response):f(g.status)};g.onerror=f;g.send(null)});var c=await fetch(a,{credentials:"same-origin"});if(c.ok)return c.arrayBuffer();throw Error(c.status+" : "+c.url);};var A=b.print||console.log.bind(console),B=b.printErr||console.error.bind(console);
Object.assign(b,t);t=null;var C=b.wasmBinary,D,G=!1,H,I,x=a=>a.startsWith("file://");function J(){var a=D.buffer;b.HEAP8=new Int8Array(a);b.HEAP16=new Int16Array(a);b.HEAPU8=H=new Uint8Array(a);b.HEAPU16=new Uint16Array(a);b.HEAP32=new Int32Array(a);b.HEAPU32=I=new Uint32Array(a);b.HEAPF32=new Float32Array(a);b.HEAPF64=new Float64Array(a);b.HEAP64=new BigInt64Array(a);b.HEAPU64=new BigUint64Array(a)}var K=0,L=null,M;
async function N(a){if(!C)try{var c=await v(a);return new Uint8Array(c)}catch{}if(a==M&&C)a=new Uint8Array(C);else if(w)a=w(a);else throw"both async and sync fetching of the wasm failed";return a}async function O(a,c){try{var d=await N(a);return await WebAssembly.instantiate(d,c)}catch(f){throw B(`failed to asynchronously prepare wasm: ${f}`),a=f,b.onAbort?.(a),a="Aborted("+a+")",B(a),G=!0,a=new WebAssembly.RuntimeError(a+". Build with -sASSERTIONS for more info."),h(a),a;}}
async function P(a){var c=M;if(!C&&"function"==typeof WebAssembly.instantiateStreaming&&!x(c)&&!r)try{var d=fetch(c,{credentials:"same-origin"});return await WebAssembly.instantiateStreaming(d,a)}catch(f){B(`wasm streaming compile failed: ${f}`),B("falling back to ArrayBuffer instantiation")}return O(c,a)}
var Q=a=>{for(;0<a.length;)a.shift()(b)},R=[],S=[],aa=()=>{var a=b.preRun.shift();S.unshift(a)},ba=[null,[],[]],T="undefined"!=typeof TextDecoder?new TextDecoder:void 0,U=(a,c=0,d=NaN)=>{var f=c+d;for(d=c;a[d]&&!(d>=f);)++d;if(16<d-c&&a.buffer&&T)return T.decode(a.subarray(c,d));for(f="";c<d;){var g=a[c++];if(g&128){var k=a[c++]&63;if(192==(g&224))f+=String.fromCharCode((g&31)<<6|k);else{var m=a[c++]&63;g=224==(g&240)?(g&15)<<12|k<<6|m:(g&7)<<18|k<<12|m<<6|a[c++]&63;65536>g?f+=String.fromCharCode(g):
(g-=65536,f+=String.fromCharCode(55296|g>>10,56320|g&1023))}}else f+=String.fromCharCode(g)}return f},ca={b:a=>{var c=H.length;a>>>=0;if(2147483648<a)return!1;for(var d=1;4>=d;d*=2){var f=c*(1+.2/d);f=Math.min(f,a+100663296);a:{f=(Math.min(2147483648,65536*Math.ceil(Math.max(a,f)/65536))-D.buffer.byteLength+65535)/65536|0;try{D.grow(f);J();var g=1;break a}catch(k){}g=void 0}if(g)return!0}return!1},d:()=>52,c:function(){return 70},a:(a,c,d,f)=>{for(var g=0,k=0;k<d;k++){var m=I[c>>2],y=I[c+4>>2];c+=
8;for(var q=0;q<y;q++){var z=a,E=H[m+q],F=ba[z];0===E||10===E?((1===z?A:B)(U(F)),F.length=0):F.push(E)}g+=y}I[f>>2]=g;return 0}},V;
(async function(){function a(f){V=f.exports;D=V.e;J();K--;b.monitorRunDependencies?.(K);0==K&&L&&(f=L,L=null,f());return V}K++;b.monitorRunDependencies?.(K);var c={a:ca};if(b.instantiateWasm)return new Promise(f=>{b.instantiateWasm(c,(g,k)=>{a(g,k);f(g.exports)})});M??=b.locateFile?b.locateFile("Imaging.wasm",u):u+"Imaging.wasm";try{var d=await P(c);return a(d.instance)}catch(f){return h(f),Promise.reject(f)}})();b._ImagingBlend=(a,c,d)=>(b._ImagingBlend=V.g)(a,c,d);
b._ImagingBoxBlur=(a,c,d,f)=>(b._ImagingBoxBlur=V.h)(a,c,d,f);b._ImagingGaussianBlur=(a,c,d,f)=>(b._ImagingGaussianBlur=V.i)(a,c,d,f);b._ImagingCopy=a=>(b._ImagingCopy=V.j)(a);b._ImagingCopy2=(a,c)=>(b._ImagingCopy2=V.k)(a,c);b._ImagingSectionEnter=a=>(b._ImagingSectionEnter=V.l)(a);b._ImagingSectionLeave=a=>(b._ImagingSectionLeave=V.m)(a);b._imageFromRGBA=(a,c,d)=>(b._imageFromRGBA=V.n)(a,c,d);b._imageMode=a=>(b._imageMode=V.o)(a);b._imageWidth=a=>(b._imageWidth=V.p)(a);
b._imageHeight=a=>(b._imageHeight=V.q)(a);b._imageLinesize=a=>(b._imageLinesize=V.r)(a);b._imageBlock=a=>(b._imageBlock=V.s)(a);b._blurHashForImage=(a,c,d)=>(b._blurHashForImage=V.t)(a,c,d);b._ImagingFlipLeftRight=(a,c)=>(b._ImagingFlipLeftRight=V.u)(a,c);b._ImagingFlipTopBottom=(a,c)=>(b._ImagingFlipTopBottom=V.v)(a,c);b._ImagingRotate90=(a,c)=>(b._ImagingRotate90=V.w)(a,c);b._ImagingTranspose=(a,c)=>(b._ImagingTranspose=V.x)(a,c);b._ImagingTransverse=(a,c)=>(b._ImagingTransverse=V.y)(a,c);
b._ImagingRotate180=(a,c)=>(b._ImagingRotate180=V.z)(a,c);b._ImagingRotate270=(a,c)=>(b._ImagingRotate270=V.A)(a,c);b._ImagingTransform=(a,c,d,f,g,k,m,y,q,z)=>(b._ImagingTransform=V.B)(a,c,d,f,g,k,m,y,q,z);b._ImagingPaletteNew=a=>(b._ImagingPaletteNew=V.C)(a);b._ImagingPaletteNewBrowser=()=>(b._ImagingPaletteNewBrowser=V.D)();b._ImagingPaletteDuplicate=a=>(b._ImagingPaletteDuplicate=V.E)(a);b._ImagingPaletteDelete=a=>(b._ImagingPaletteDelete=V.F)(a);
b._ImagingPaletteCacheUpdate=(a,c,d,f)=>(b._ImagingPaletteCacheUpdate=V.G)(a,c,d,f);b._ImagingPaletteCachePrepare=a=>(b._ImagingPaletteCachePrepare=V.H)(a);b._ImagingPaletteCacheDelete=a=>(b._ImagingPaletteCacheDelete=V.I)(a);b._ImagingResample=(a,c,d,f,g)=>(b._ImagingResample=V.J)(a,c,d,f,g);b._ImagingNewPrologueSubtype=(a,c,d,f)=>(b._ImagingNewPrologueSubtype=V.K)(a,c,d,f);b._ImagingNewPrologue=(a,c,d)=>(b._ImagingNewPrologue=V.L)(a,c,d);b._ImagingDelete=a=>(b._ImagingDelete=V.M)(a);
b._ImagingMemorySetBlocksMax=(a,c)=>(b._ImagingMemorySetBlocksMax=V.N)(a,c);b._ImagingMemoryClearCache=(a,c)=>(b._ImagingMemoryClearCache=V.O)(a,c);b._ImagingNew=(a,c,d)=>(b._ImagingNew=V.P)(a,c,d);b._ImagingNewDirty=(a,c,d)=>(b._ImagingNewDirty=V.Q)(a,c,d);b._ImagingNewBlock=(a,c,d)=>(b._ImagingNewBlock=V.R)(a,c,d);b._ImagingNew2Dirty=(a,c,d)=>(b._ImagingNew2Dirty=V.S)(a,c,d);b._ImagingCopyPalette=(a,c)=>(b._ImagingCopyPalette=V.T)(a,c);b._malloc=a=>(b._malloc=V.U)(a);
var W=a=>(W=V.V)(a),X=a=>(X=V.W)(a),Y=()=>(Y=V.X)();b.stackSave=()=>Y();b.stackRestore=a=>W(a);b.stackAlloc=a=>X(a);b.UTF8ToString=(a,c)=>a?U(H,a,c):"";
function Z(){function a(){b.calledRun=!0;if(!G){V.f();e(b);b.onRuntimeInitialized?.();if(b.postRun)for("function"==typeof b.postRun&&(b.postRun=[b.postRun]);b.postRun.length;){var c=b.postRun.shift();R.unshift(c)}Q(R)}}if(0<K)L=Z;else{if(b.preRun)for("function"==typeof b.preRun&&(b.preRun=[b.preRun]);b.preRun.length;)aa();Q(S);0<K?L=Z:b.setStatus?(b.setStatus("Running..."),setTimeout(()=>{setTimeout(()=>b.setStatus(""),1);a()},1)):a()}}
if(b.preInit)for("function"==typeof b.preInit&&(b.preInit=[b.preInit]);0<b.preInit.length;)b.preInit.pop()();Z();moduleRtn=l;


  return moduleRtn;
}
);
})();
if (typeof exports === 'object' && typeof module === 'object') {
  module.exports = Module;
  // This default export looks redundant, but it allows TS to import this
  // commonjs style module.
  module.exports.default = Module;
} else if (typeof define === 'function' && define['amd'])
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
