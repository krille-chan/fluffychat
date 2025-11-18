'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "65043e2fc0863174ee157ac3ed837cc1",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "b6e2d26086b6019733d59c1c10c53658",
"main.dart.js_317.part.js": "3f9340018ad7bb60eb9615e573a35b04",
"main.dart.js_1.part.js": "a1f633c171854ac01063fd4a33270c54",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "914551a4a5f9d93ce9e1e109bce412b7",
"main.dart.js_274.part.js": "bb742b254187d39ed93af71f54479c79",
"main.dart.js_318.part.js": "38c7e9e149318cb10df62bc290ff85ae",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_338.part.js": "a2050c9a4ec5c87b649c9a11f5a40f1f",
"main.dart.js_266.part.js": "7375454c4584cfc33339cb3ec97f64a4",
"main.dart.js_316.part.js": "7fcaa5a28a4b152ce569d37bfa090715",
"index.html": "3f1034613f5e2d18a721387158382ec0",
"/": "3f1034613f5e2d18a721387158382ec0",
"main.dart.js_217.part.js": "40431625f44f072ee9106e3748b9684e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "0fbeb65b4539368fb9203188cbeb7c19",
"main.dart.js_258.part.js": "b93a5a8da03638ea863ea3a3be307f42",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_283.part.js": "5343fc02dca7c764f841c54db1300558",
"main.dart.js_294.part.js": "485c067e0203671c8d38d4bffee7ac37",
"main.dart.js_300.part.js": "c2d65217cca9915010c835eeb3d0ffcd",
"main.dart.js_322.part.js": "fa92ff6c818fe1dd4810cb400b5eda1f",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "63c862803bb4ef9065a8dec6e6245829",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "162a1ba97f7f3e66cc7da78ea4396628",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "899d2adaddc6a159691c7a5cf31f2831",
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
"assets/fonts/MaterialIcons-Regular.otf": "cf04b1acec037d1bfe7beae9ec5d43f3",
"assets/NOTICES": "4de3f617c2e220cbcf134b0c31162a7f",
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
"main.dart.js_240.part.js": "3020c35576c144d70c040bd5afbfce08",
"main.dart.js_334.part.js": "b1a745a249bdf77673132b31634c217c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "e5dc1f856d147365c026b40354263c27",
"main.dart.js_292.part.js": "79a9f2fa033107dcdc644b2949012e9f",
"main.dart.js_284.part.js": "8b99f0d05ed65bfb62de741e5b7edfe9",
"main.dart.js_16.part.js": "529efe7aa997ce305f2193c20c550b29",
"main.dart.js_278.part.js": "810b22b8bd7f73b6957aa835e9a4c0dc",
"main.dart.js_333.part.js": "783e2cede2950e4030fecce67ee9c5b5",
"main.dart.js_303.part.js": "06510535fa08ff9fe496945807e21057",
"main.dart.js_331.part.js": "36a436d3101388b2ad48a97fd37dfe08",
"main.dart.js_237.part.js": "03e9f66d8d31bb201ab4170a61182577",
"main.dart.js_340.part.js": "4145650470964d3673bf026852b06e79",
"main.dart.js_249.part.js": "ea09d0167d36888c2436484b9f482c92",
"main.dart.js_267.part.js": "292e7fc49f74871b545eac579bc688a5",
"main.dart.js_313.part.js": "05b344fd254ad3a1fd33830b5c336db5",
"main.dart.js_270.part.js": "8c26269f5300123950c2c56e6f38f3b5",
"main.dart.js_321.part.js": "b5213cca26db15726e0662260cce381e",
"main.dart.js_255.part.js": "ef0eaaa12c6b6cfefaffe796cc7a0293",
"main.dart.js_268.part.js": "76d010c4b36dd9320fc4cd4fcd97e93a",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "9810f356b8be4e5cc776573383696cf0",
"main.dart.js_288.part.js": "d0958179e4bc23d2c36d82b9c50dce47",
"main.dart.js_314.part.js": "681db9a36d458cb16e837a49fa5c7d7c",
"main.dart.js_323.part.js": "631c13ee188af2a3cb7d77d79653d766",
"main.dart.js_335.part.js": "968bf529fbc5416ad485e20db3332f80",
"main.dart.js_328.part.js": "6f48b0a7f529f19ca8aa9bf82951343d",
"main.dart.js_289.part.js": "1393542b3f2bc8ef9f776d74151e4820",
"main.dart.js_337.part.js": "e4a258d8161de986cd25a7ee80c02e24",
"main.dart.js_219.part.js": "e7e267845e19a9dec8887e71f5a805e5",
"flutter_bootstrap.js": "56ec7b0b39c01d018408a3c07728585a",
"main.dart.js_315.part.js": "9d67f7838d9ac2d2941cf24510cd0d6b",
"main.dart.js_276.part.js": "f75a9e78f3135f21529edd3d77edf9a8",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "00f2b1aff9946d29d919678ae313f384",
"main.dart.js_293.part.js": "c87096c7d21f821cb7c75988fd028be9",
"main.dart.js_310.part.js": "9cdec15bc27b56208aa89bc14e9157af",
"main.dart.js_329.part.js": "fed2bfeb0ad9ee87dac43e1fd375a464",
"main.dart.js": "0f2ad8abad44cfd8edd6d996f9d23748"};
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
