'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_289.part.js": "b6deff19a9868b2f3c16583bd1f21aee",
"main.dart.js_285.part.js": "0dc8f7d4c7186213911f014f208621db",
"main.dart.js_251.part.js": "2c84010c15ce70bd5ec87d9cce0ae708",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js_246.part.js": "6228b414e16d126e9e1e144b0294e855",
"main.dart.js_266.part.js": "da88986272fe2e36af6d4e64c0c4edff",
"main.dart.js_274.part.js": "9a977d387037b296f7f83e881c2449b2",
"main.dart.js_208.part.js": "d93e1624a101d09b7ffc35dc3d45dba1",
"main.dart.js_291.part.js": "05b228845edee117dfda5b24183fdef5",
"main.dart.js_273.part.js": "bc856bf18dc184c667b23c4a94f3127e",
"main.dart.js_259.part.js": "f0cf3a3a31a8baf83f5ba85036668757",
"main.dart.js_207.part.js": "71e8dfe0d509aaed411f13574a8f207d",
"main.dart.js_278.part.js": "b99c7d47d54910c8a0a08d42abefff1b",
"main.dart.js": "af7f7cdccb626b9ecd873153eba069c5",
"main.dart.js_293.part.js": "f36fe245faaf3af342826d1abf7b6cff",
"main.dart.js_229.part.js": "b72d1bf96c79cfb8e4f8e38d5563a5c4",
"main.dart.js_270.part.js": "c668f9f7fa72b70aa00ccef9adaf4261",
"main.dart.js_275.part.js": "009af820381f093def640972d1c79bdf",
"main.dart.js_247.part.js": "d5bcef98206d8b819f46626dc91cdbf1",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "52986a9e1d69ad779d02334a06b33a81",
"main.dart.js_228.part.js": "bf11261ec2d314b73d8efee70664f998",
"assets/FontManifest.json": "6a590c591cb18c7ac3b63b1fcaa45b57",
"assets/AssetManifest.bin": "01653b98c549dbb223f2b1b889e53d8b",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "5cafa6adc7350622f3824bd18e8ef71f",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "bf619178a1771fb6a056dd98bc108d5d",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/NOTICES": "c132f8e2421deb94ec767be5a623d3cc",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "5df852daed9fdd59f8c357fa9487c0d9",
"assets/AssetManifest.bin.json": "e4d0f46629f73f786858df62d316df9f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_220.part.js": "e0274fdb4b83bb2cd3c74f818d85fbe2",
"main.dart.js_288.part.js": "8f4717e5ed124329df58080ab988f1e7",
"main.dart.js_241.part.js": "6e7d2f26b606a41bad7f7ec89dd0bada",
"main.dart.js_268.part.js": "d5665a15115b69eb6d8a1df3e4ebe259",
"main.dart.js_280.part.js": "5a7ae29b49ac08afaababae39fb8a7f5",
"main.dart.js_272.part.js": "fdac679860bf4b6c5ee00139764b0f30",
"main.dart.js_242.part.js": "fff2cb447775457c1f24b529e0dffc6f",
"index.html": "1866421eabb7c147047e4ad536f54c99",
"/": "1866421eabb7c147047e4ad536f54c99",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"main.dart.js_286.part.js": "1a8a10b62633829aab5e3b6272bd9586",
"main.dart.js_240.part.js": "b5fa7f4501660ccb77f3f95b5436a75b",
"main.dart.js_290.part.js": "cd328be73e78256292f8ecd1d51d698f",
"main.dart.js_1.part.js": "b08a250e4bca62bf3d395c0226e60ef3",
"main.dart.js_261.part.js": "3ec1dd562e32a3308926703f65ce274b",
"main.dart.js_193.part.js": "c7fbcce4eec68e4e7bbcd41a12d2208e",
"main.dart.js_206.part.js": "5d3a3120168b0bb9762ab671329aabc2",
"main.dart.js_231.part.js": "65de3dffab20a4b1dc242951d85c1049",
"main.dart.js_2.part.js": "bd15ba8e1278921ad761885df26a4a9b",
"main.dart.js_292.part.js": "82915a2ea39486613ae39a4905964e4a",
"main.dart.js_284.part.js": "cf778f0dbc30b61a5a3737aba3855b05",
"main.dart.js_250.part.js": "aa5cded87de455134ff9c52e50a2bd27",
"main.dart.js_238.part.js": "9cb6be9186b4829fe8d0c3d005cbfb1b",
"main.dart.js_227.part.js": "7b5400cc6b584b2b1aaa77bb440eda65",
"icons/Icon-192.png": "839e87c4f6800df757bb28180f8e2949",
"icons/Icon-512.png": "f57dad4f6efa0339b50d5c65f36dc03c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_243.part.js": "e966d4d62184d74e6e1da85ea8817527",
"main.dart.js_195.part.js": "6fa2d74cf54649489540789d5e2365e2",
"main.dart.js_215.part.js": "90cc4a2b17f1c7f278bc9e0b1628a243",
"main.dart.js_252.part.js": "1b4d0d4ea075f2424a462ba58558a8f0",
"main.dart.js_279.part.js": "826a8bbdc2b9f08f8b5a61701aa5d455",
"main.dart.js_277.part.js": "acb67d67ecab122aaf35b86c9f592a9c",
"main.dart.js_271.part.js": "00a7977c0c3380d7a3c489e35d90f8f7",
"main.dart.js_236.part.js": "7ccb5a476199dcde33cc5ca248edc2ef",
"main.dart.js_14.part.js": "713244c573a5e7e7578ef812da9f533f",
"main.dart.js_258.part.js": "7d49549db88aa5613bce7c6aca2c16f3",
"version.json": "8de5909270a83075fc8cc02271e7a17f",
"flutter_bootstrap.js": "caea5b896a8aec016d1e9568735c6e5a"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
