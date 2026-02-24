var Imaging = (function() {
var Module=(()=>{var _scriptName=globalThis.document?.currentScript?.src;return async function(moduleArg={}){var moduleRtn;var b=moduleArg,h=!!globalThis.window,k=!!globalThis.WorkerGlobalScope,l=globalThis.process?.versions?.node&&"renderer"!=globalThis.process?.type;"undefined"!=typeof __filename?_scriptName=__filename:k&&(_scriptName=self.location.href);var m="",n,p;
if(l){var fs=require("node:fs");m=__dirname+"/";p=a=>{a=q(a)?new URL(a):a;return fs.readFileSync(a)};n=async a=>{a=q(a)?new URL(a):a;return fs.readFileSync(a,void 0)};process.argv.slice(2)}else if(h||k){try{m=(new URL(".",_scriptName)).href}catch{}k&&(p=a=>{var d=new XMLHttpRequest;d.open("GET",a,!1);d.responseType="arraybuffer";d.send(null);return new Uint8Array(d.response)});n=async a=>{if(q(a))return new Promise((c,f)=>{var e=new XMLHttpRequest;e.open("GET",a,!0);e.responseType="arraybuffer";e.onload=
()=>{200==e.status||0==e.status&&e.response?c(e.response):f(e.status)};e.onerror=f;e.send(null)});var d=await fetch(a,{credentials:"same-origin"});if(d.ok)return d.arrayBuffer();throw Error(d.status+" : "+d.url);}}var r=console.log.bind(console),u=console.error.bind(console),v,w=!1,q=a=>a.startsWith("file://"),x,B,C,D,E=!1;
function F(){var a=G.buffer;new Int8Array(a);new Int16Array(a);b.HEAPU8=C=new Uint8Array(a);new Uint16Array(a);new Int32Array(a);D=new Uint32Array(a);b.HEAPF32=new Float32Array(a);new Float64Array(a);new BigInt64Array(a);new BigUint64Array(a)}var H;async function I(a){if(!v)try{var d=await n(a);return new Uint8Array(d)}catch{}if(a==H&&v)a=new Uint8Array(v);else if(p)a=p(a);else throw"both async and sync fetching of the wasm failed";return a}
async function J(a,d){try{var c=await I(a);return await WebAssembly.instantiate(c,d)}catch(f){throw u(`failed to asynchronously prepare wasm: ${f}`),a=f,b.onAbort?.(a),a="Aborted("+a+")",u(a),w=!0,a=new WebAssembly.RuntimeError(a+". Build with -sASSERTIONS for more info."),B?.(a),a;}}
async function K(a){var d=H;if(!v&&!q(d)&&!l)try{var c=fetch(d,{credentials:"same-origin"});return await WebAssembly.instantiateStreaming(c,a)}catch(f){u(`wasm streaming compile failed: ${f}`),u("falling back to ArrayBuffer instantiation")}return J(d,a)}
var L=a=>{for(;0<a.length;)a.shift()(b)},M=[],N=[],O=()=>{var a=b.preRun.shift();N.push(a)},P=[null,[],[]],S=globalThis.TextDecoder&&new TextDecoder,T=(a,d=0,c,f)=>{var e=d;c=e+c;if(f)f=c;else{for(;a[e]&&!(e>=c);)++e;f=e}if(16<f-d&&a.buffer&&S)return S.decode(a.subarray(d,f));for(e="";d<f;)if(c=a[d++],c&128){var g=a[d++]&63;if(192==(c&224))e+=String.fromCharCode((c&31)<<6|g);else{var t=a[d++]&63;c=224==(c&240)?(c&15)<<12|g<<6|t:(c&7)<<18|g<<12|t<<6|a[d++]&63;65536>c?e+=String.fromCharCode(c):(c-=
65536,e+=String.fromCharCode(55296|c>>10,56320|c&1023))}}else e+=String.fromCharCode(c);return e};b.print&&(r=b.print);b.printErr&&(u=b.printErr);b.wasmBinary&&(v=b.wasmBinary);if(b.preInit)for("function"==typeof b.preInit&&(b.preInit=[b.preInit]);0<b.preInit.length;)b.preInit.shift()();b.stackSave=()=>U();b.stackRestore=a=>V(a);b.stackAlloc=a=>W(a);b.UTF8ToString=(a,d,c)=>a?T(C,a,d,c):"";
var V,W,U,G,X={b:a=>{var d=C.length;a>>>=0;if(2147483648<a)return!1;for(var c=1;4>=c;c*=2){var f=d*(1+.2/c);f=Math.min(f,a+100663296);a:{f=(Math.min(2147483648,65536*Math.ceil(Math.max(a,f)/65536))-G.buffer.byteLength+65535)/65536|0;try{G.grow(f);F();var e=1;break a}catch(g){}e=void 0}if(e)return!0}return!1},a:(a,d,c,f)=>{for(var e=0,g=0;g<c;g++){var t=D[d>>2],Q=D[d+4>>2];d+=8;for(var y=0;y<Q;y++){var R=a,z=C[t+y],A=P[R];0===z||10===z?((1===R?r:u)(T(A)),A.length=0):A.push(z)}e+=Q}D[f>>2]=e;return 0}},
Y;
Y=await (async function(){function a(c){c=Y=c.exports;b._ImagingBlend=c.e;b._ImagingBoxBlur=c.f;b._ImagingGaussianBlur=c.g;b._ImagingCopy=c.h;b._ImagingCopy2=c.i;b._ImagingSectionEnter=c.j;b._ImagingSectionLeave=c.k;b._imageFromRGBA=c.l;b._imageMode=c.m;b._imageWidth=c.n;b._imageHeight=c.o;b._imageLinesize=c.p;b._imageBlock=c.q;b._blurHashForImage=c.r;b._ImagingFlipLeftRight=c.s;b._ImagingFlipTopBottom=c.t;b._ImagingRotate90=c.u;b._ImagingTranspose=c.v;b._ImagingTransverse=c.w;b._ImagingRotate180=c.x;
b._ImagingRotate270=c.y;b._ImagingTransform=c.z;b._ImagingPaletteNew=c.A;b._ImagingPaletteNewBrowser=c.B;b._ImagingPaletteDuplicate=c.C;b._ImagingPaletteDelete=c.D;b._ImagingPaletteCacheUpdate=c.E;b._ImagingPaletteCachePrepare=c.F;b._ImagingPaletteCacheDelete=c.G;b._ImagingResample=c.H;b._ImagingNewPrologueSubtype=c.I;b._ImagingNewPrologue=c.J;b._ImagingDelete=c.K;b._ImagingMemorySetBlocksMax=c.L;b._ImagingMemoryClearCache=c.M;b._ImagingNew=c.N;b._ImagingNewDirty=c.O;b._ImagingNewBlock=c.P;b._ImagingNew2Dirty=
c.Q;b._ImagingCopyPalette=c.R;b._malloc=c.S;V=c.T;W=c.U;U=c.V;G=c.c;F();return Y}var d={a:X};if(b.instantiateWasm)return new Promise(c=>{b.instantiateWasm(d,(f,e)=>{c(a(f,e))})});H??=b.locateFile?b.locateFile("Imaging.wasm",m):m+"Imaging.wasm";return a((await K(d)).instance)}());
(function(){function a(){b.calledRun=!0;if(!w){E=!0;Y.d();x?.(b);b.onRuntimeInitialized?.();if(b.postRun)for("function"==typeof b.postRun&&(b.postRun=[b.postRun]);b.postRun.length;){var d=b.postRun.shift();M.push(d)}L(M)}}if(b.preRun)for("function"==typeof b.preRun&&(b.preRun=[b.preRun]);b.preRun.length;)O();L(N);b.setStatus?(b.setStatus("Running..."),setTimeout(()=>{setTimeout(()=>b.setStatus(""),1);a()},1)):a()})();E?moduleRtn=b:moduleRtn=new Promise((a,d)=>{x=a;B=d});
;return moduleRtn}})();if(typeof exports==="object"&&typeof module==="object"){module.exports=Module;module.exports.default=Module}else if(typeof define==="function"&&define["amd"])define([],()=>Module);
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
