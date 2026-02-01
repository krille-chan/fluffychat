'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_271.part.js": "957b45b02be2f5e983ee64b88d3dbd85",
"main.dart.js_317.part.js": "1290099bfa3c451494fbe9ab0c360570",
"main.dart.js_297.part.js": "a67be1f88e9031db225912e9c94d069d",
"main.dart.js_1.part.js": "4087a2a84e90c3bd965c14ace5681cde",
"main.dart.js_260.part.js": "8fc53e011db028acdfa6bfc0932de812",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_311.part.js": "9b10a7a7ee2c80bb928fd9d184ef91bb",
"main.dart.js_318.part.js": "ea0e9c3a9e9d50c75cc2eed2b0374e78",
"main.dart.js_316.part.js": "bb5facea94bccc5c35171aaeff588816",
"index.html": "929a165c62d681c4b2e70139d0eb7be4",
"/": "929a165c62d681c4b2e70139d0eb7be4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "b4030bc87c935b948d7d92392c08cac7",
"main.dart.js_2.part.js": "2b138bb039cb1b661fbe9172bdbcf34c",
"main.dart.js_283.part.js": "32b653487ab0a5d263ff7d7b388e0df5",
"main.dart.js_261.part.js": "d5df0cc31f14f828fd9a42187bdba063",
"main.dart.js_262.part.js": "b34db2b967a1367b2c735dbfacb91874",
"main.dart.js_299.part.js": "fd656f61201046374a626fc0e60031ea",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "d1372fa8d5e7df24397e1ce24cdb959c",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "0a5ffb27a4cb6a30f9bfdffcd6a6d1a9",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "bd7dd9733149562a6f9cb54cc5f5f7e3",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"main.dart.js_210.part.js": "e3b9db116ea1904ea4251496de191a52",
"main.dart.js_334.part.js": "37fbf19277e1ae90a35ab21bb2f6d0f5",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "722074fda648c4f5c6695bc7c3a2073a",
"main.dart.js_296.part.js": "db0c3acd6326141504e1037358b69f51",
"main.dart.js_278.part.js": "f9761e6afee13f25feeae1414e374c17",
"main.dart.js_336.part.js": "5d575bf337e0e664c3b0ebd67f5c5dcd",
"main.dart.js_287.part.js": "b49abb0cb2335612258732420c1707c0",
"main.dart.js_331.part.js": "554bb103f01305ceb5e54c7011269709",
"main.dart.js_252.part.js": "19a893514d8d5e2ac9a143e410d787c3",
"main.dart.js_212.part.js": "f653e62ce0557c2f982c2ffe6c9488d9",
"main.dart.js_249.part.js": "1fa6831cbdfe5788b626f493bdb851f2",
"main.dart.js_269.part.js": "690c2d9a258f32a056ff61801dc38711",
"main.dart.js_313.part.js": "e2a6bbbb13432800d9abfbdaca6a0641",
"main.dart.js_309.part.js": "bc47f9f6ec3a60aca5ee867982ac622c",
"main.dart.js_312.part.js": "76d8f6fa5ea5ff86b84127e658298e15",
"main.dart.js_325.part.js": "7bc8a7193f11e9dd1a924391d47207e1",
"main.dart.js_273.part.js": "935062c2a6e424b6103172689f2e0c78",
"native_executor.js.deps": "862bb5041ac6577bdb707c968e1912b9",
"main.dart.js_275.part.js": "0ca629e169ac52d68b9665465a7e4d3b",
"main.dart.js_332.part.js": "1566e7ca9a3ed0d59a72db5e3ae33ed3",
"native_executor.js.map": "f024cc1fa3b0f17d8be25ff637b0ce29",
"main.dart.js_288.part.js": "4a6df857fd0dd7b5797bd92e385d0e43",
"main.dart.js_314.part.js": "2afe2e74ac3e424b328560afd4fdd8c5",
"main.dart.js_279.part.js": "5d7886bc60d504642762fdc3d8eed9c5",
"main.dart.js_319.part.js": "572bfc9db708c37f7b3b5220b47d7256",
"main.dart.js_323.part.js": "72e13d7f9ff1fab1f81360836d1765e6",
"main.dart.js_335.part.js": "d0580494f5d8c55dfa709caae21ad243",
"main.dart.js_218.part.js": "6dcd676315e99649d252b3a6decb88a2",
"main.dart.js_324.part.js": "8260d4f6a35fde2d3281ad85b2a0e0c7",
"main.dart.js_328.part.js": "e3e5e17ad46fb97fc22855aef1d06a40",
"main.dart.js_289.part.js": "810bea9cf1e44803487748d099b6dce7",
"main.dart.js_337.part.js": "cc89dfe47fbe182bb82445596be441ec",
"flutter_bootstrap.js": "06bce16c54c21907912eb436bfc51024",
"main.dart.js_304.part.js": "b71fbabdb7e6a827d65ee73c71513998",
"main.dart.js_264.part.js": "869c5f2b2edfbef4e932dcdc4e79e17b",
"main.dart.js_306.part.js": "378929c9c8b410429ec0a57d2546bdf5",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_225.part.js": "b76e1673e077e9f6dc14d9632de52ee9",
"main.dart.js_310.part.js": "8d1b175b7498df7ce8c3ed20fce3221e",
"main.dart.js_233.part.js": "bb9e80be27e6fd73d6c352099d09a3b3",
"main.dart.js_326.part.js": "186759dd6e071a5e18461c17d850862d",
"main.dart.js_329.part.js": "8111537d58f323f658a3efebca99e9f0",
"main.dart.js": "f644b110985214d667b23b3f03f72411",
"main.dart.js_17.part.js": "71468572638b88b5dfb16d3bfbec6fee",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51"};
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
