var Imaging = (function() {
var Module=(()=>{var _scriptName=globalThis.document?.currentScript?.src;return async function(moduleArg={}){var Module=moduleArg;var g=!!globalThis.window,h=!!globalThis.WorkerGlobalScope,k=globalThis.process?.versions?.node&&globalThis.process?.type!="renderer";typeof __filename!="undefined"?_scriptName=__filename:h&&(_scriptName=self.location.href);var l="",m,n;
if(k){var fs=require("node:fs");l=__dirname+"/";n=a=>{a=p(a)?new URL(a):a;return fs.readFileSync(a)};m=async a=>{a=p(a)?new URL(a):a;return fs.readFileSync(a,void 0)};process.argv.slice(2)}else if(g||h){try{l=(new URL(".",_scriptName)).href}catch{}h&&(n=a=>{var c=new XMLHttpRequest;c.open("GET",a,!1);c.responseType="arraybuffer";c.send(null);return new Uint8Array(c.response)});m=async a=>{if(p(a))return new Promise((d,b)=>{var e=new XMLHttpRequest;e.open("GET",a,!0);e.responseType="arraybuffer";e.onload=
()=>{e.status==200||e.status==0&&e.response?d(e.response):b(e.status)};e.onerror=b;e.send(null)});var c=await fetch(a,{credentials:"same-origin"});if(c.ok)return c.arrayBuffer();throw Error(c.status+" : "+c.url);}}var q=console.log.bind(console),t=console.error.bind(console),u=!1,p=a=>a.startsWith("file://");function v(){if(!z?.buffer?.resizable){var a=A.buffer;z=new Int8Array(a);Module.HEAPU8=B=new Uint8Array(a);C=new Uint32Array(a);Module.HEAPF32=new Float32Array(a)}}
function D(){var a=Module.preRun;a&&(typeof a=="function"&&(a=[a]),E.push(...a));for(a=E;a.length>0;)a.shift()(Module)}function F(){var a=Module.postRun;a&&(typeof a=="function"&&(a=[a]),G.push(...a));for(a=G;a.length>0;)a.shift()(Module)}var H;async function I(a){try{var c=await m(a);return new Uint8Array(c)}catch{}if(n)a=n(a);else throw"both async and sync fetching of the wasm failed";return a}
async function J(a,c){try{var d=await I(a);return await WebAssembly.instantiate(d,c)}catch(b){throw t(`failed to asynchronously prepare wasm: ${b}`),a=b,Module.onAbort?.(a),a=`Aborted(${a})`,t(a),u=!0,new WebAssembly.RuntimeError(a+". Build with -sASSERTIONS for more info.");}}
async function K(a){var c=H;if(!p(c)&&!k)try{var d=fetch(c,{credentials:"same-origin"});return await WebAssembly.instantiateStreaming(d,a)}catch(b){t(`wasm streaming compile failed: ${b}`),t("falling back to ArrayBuffer instantiation")}return J(c,a)}
var z,G=[],E=[],B,L=[null,[],[]],O=globalThis.TextDecoder&&new TextDecoder,P=(a,c=0,d,b)=>{var e=c;d=e+d;if(b)b=d;else{for(;a[e]&&!(e>=d);)++e;b=e}if(b-c>16&&a.buffer&&O)return O.decode(a.subarray(c,b));for(e="";c<b;)if(d=a[c++],d&128){var f=a[c++]&63;if((d&224)==192)e+=String.fromCharCode((d&31)<<6|f);else{var r=a[c++]&63;d=(d&240)==224?(d&15)<<12|f<<6|r:(d&7)<<18|f<<12|r<<6|a[c++]&63;d<65536?e+=String.fromCharCode(d):(d-=65536,e+=String.fromCharCode(55296|d>>10,56320|d&1023))}}else e+=String.fromCharCode(d);
return e},C;Module.print&&(q=Module.print);Module.printErr&&(t=Module.printErr);var Q=Module.preInit;if(Q)for(typeof Q=="function"&&(Module.preInit=Q=[Q]);Q.length>0;)Q.shift()();Module.stackSave=()=>R();Module.stackRestore=a=>S(a);Module.stackAlloc=a=>T(a);Module.UTF8ToString=(a,c,d)=>a?P(B,a,c,d):"";
var S,T,R,A,U={b:a=>{var c=B.length;a>>>=0;if(a>2147483648)return!1;for(var d=1;d<=4;d*=2){var b=c*(1+.2/d);b=Math.min(b,a+100663296);a:{b=(Math.min(2147483648,Math.ceil(Math.max(a,b)/65536)*65536)-A.buffer.byteLength+65535)/65536|0;try{A.grow(b);v();var e=1;break a}catch(f){}e=void 0}if(e)return!0}return!1},a:(a,c,d,b)=>{for(var e=0,f=0;f<d;f++){var r=C[c>>2],M=C[c+4>>2];c+=8;for(var w=0;w<M;w++){var N=a,x=B[r+w],y=L[N];x===0||x===10?((N===1?q:t)(P(y)),y.length=0):y.push(x)}e+=M}C[b>>2]=e;return 0}},
V;
V=await (async function(){function a(b){b=V=b.exports;Module._ImagingBlend=b.e;Module._ImagingBoxBlur=b.f;Module._ImagingGaussianBlur=b.g;Module._ImagingCopy=b.h;Module._ImagingCopy2=b.i;Module._ImagingSectionEnter=b.j;Module._ImagingSectionLeave=b.k;Module._imageFromRGBA=b.l;Module._imageMode=b.m;Module._imageWidth=b.n;Module._imageHeight=b.o;Module._imageLinesize=b.p;Module._imageBlock=b.q;Module._blurHashForImage=b.r;Module._ImagingFlipLeftRight=b.s;Module._ImagingFlipTopBottom=b.t;Module._ImagingRotate90=
b.u;Module._ImagingTranspose=b.v;Module._ImagingTransverse=b.w;Module._ImagingRotate180=b.x;Module._ImagingRotate270=b.y;Module._ImagingTransform=b.z;Module._ImagingPaletteNew=b.A;Module._ImagingPaletteNewBrowser=b.B;Module._ImagingPaletteDuplicate=b.C;Module._ImagingPaletteDelete=b.D;Module._ImagingPaletteCacheUpdate=b.E;Module._ImagingPaletteCachePrepare=b.F;Module._ImagingPaletteCacheDelete=b.G;Module._ImagingResample=b.H;Module._ImagingNewPrologueSubtype=b.I;Module._ImagingNewPrologue=b.J;Module._ImagingDelete=
b.K;Module._ImagingMemorySetBlocksMax=b.L;Module._ImagingMemoryClearCache=b.M;Module._ImagingNew=b.N;Module._ImagingNewDirty=b.O;Module._ImagingNewBlock=b.P;Module._ImagingNew2Dirty=b.Q;Module._ImagingCopyPalette=b.R;Module._malloc=b.S;S=b.T;T=b.U;R=b.V;A=b.c;v();return V}var c={a:U},d=Module.instantiateWasm;if(d)return new Promise(b=>{d(c,e=>b(a(e)))});H??=Module.locateFile?Module.locateFile("Imaging.wasm",l):l+"Imaging.wasm";return function(b){return a(b.instance)}(await K(c))}());
await (async function(){D();var a=Module.setStatus;a&&(a("Running..."),await new Promise(c=>setTimeout(c,1)),setTimeout(a,1,""));u||(V.d(),Module.onRuntimeInitialized?.(),F())}());
;return Module}})();if(typeof exports==="object"&&typeof module==="object"){module.exports=Module;module.exports.default=Module}else if(typeof define==="function"&&define["amd"])define([],()=>Module);
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
