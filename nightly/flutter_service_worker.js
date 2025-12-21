'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "6255a6a837af1eeab2cf46feb026da06",
"main.dart.js_271.part.js": "71d7c7aa7f31029e3a181fa012db55b6",
"main.dart.js_317.part.js": "41db6625d0af888e2a5c193313694870",
"main.dart.js_1.part.js": "6171ae60b1ae0586e7219819a53a204e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "3d94c28ff4c3876dfe72eab1edfb2f63",
"main.dart.js_311.part.js": "70844b6e69797712da49bd2b19398afe",
"main.dart.js_220.part.js": "627dc87c41fbc9979d866baca5950cd2",
"main.dart.js_318.part.js": "036229078d710d8dd63747bc548eff4f",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "0f052e92174c8433ada62f17b69d8208",
"main.dart.js_295.part.js": "f82b670a50cbe8b303e2bc30c021f544",
"main.dart.js_316.part.js": "cefbfae7ca0d5e9f33ca89bffa2b4db7",
"index.html": "962bcf966e32e71500eabb78388ad898",
"/": "962bcf966e32e71500eabb78388ad898",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "0cc5fd8ee74b3c4e4384e17305e9992e",
"main.dart.js_305.part.js": "3556124d58bc04fd59cabb6334c4700c",
"main.dart.js_244.part.js": "6c5ee9ff2ba09ab7671adf346646d3a0",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "c1c16443d3ac917e449f2b8b826f1d8a",
"main.dart.js_265.part.js": "46d9a80da45b682f4ad886bbdd4df953",
"main.dart.js_261.part.js": "fe4daeec8fd44ffa4011579ce056616f",
"main.dart.js_262.part.js": "53500a60d7dc3302be11228791c323d2",
"main.dart.js_322.part.js": "03aa82134daf3a9c4986f7f37141801a",
"main.dart.js_263.part.js": "64d435a0d22a587a364000a009fe4746",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "37b6cf8b4643e0486a170eff3a33279b",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "e93f4b36c72a2ebb218a11d865f9be67",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "8fcb0dd7776be5c6530c8715a08f3f14",
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
"assets/NOTICES": "e3942d4aef2a10490fb32abd34246436",
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
"main.dart.js_334.part.js": "4b9141ca85f599a9b9090ea03a406817",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "edd9cc44511f6d2a65eb37bc8c65aff4",
"main.dart.js_296.part.js": "2716b24cf516868485825509ead9bc88",
"main.dart.js_278.part.js": "4c6ab19b3baa45c03cb08f67bec9fc2d",
"main.dart.js_232.part.js": "6ddb677bb3cd848d5f9e21e480133490",
"main.dart.js_333.part.js": "690f7347ef418f9c6e44054d3ca04ebd",
"main.dart.js_303.part.js": "833fbc7847b6f618d586b6261430829d",
"main.dart.js_287.part.js": "230314374cdeeb510989eb76312b3709",
"main.dart.js_212.part.js": "181f7b09ebba06aa9627e5492860db25",
"main.dart.js_269.part.js": "0dfd100f23f5ef8a9f987825348945fa",
"main.dart.js_313.part.js": "e0611dba2954d0d3e2772c6603afe345",
"main.dart.js_309.part.js": "8142ce24b86e7650b5556a78b7b71396",
"main.dart.js_312.part.js": "5742419e40a29dc4935c45159a4c9c2f",
"main.dart.js_298.part.js": "41bda8c898338ba9b13437222d773da1",
"main.dart.js_273.part.js": "3f7edbdb035a7f82d873c7f1b083be16",
"main.dart.js_235.part.js": "32cec413a5beab73ada846dae405d70a",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "d8dda9240fb0f48a31db2942cea3a241",
"main.dart.js_332.part.js": "e2b3c0d3c4b7389141a20f5030ceb61d",
"main.dart.js_288.part.js": "4a3a97461d907c55ef7c59e71a00d55f",
"main.dart.js_279.part.js": "29411aa4ae212fe765666618dd0e389c",
"main.dart.js_253.part.js": "20abed904811919a6be657d3ea2d6cd2",
"main.dart.js_323.part.js": "7d7f4a38765c3924f724748b1195a53e",
"main.dart.js_335.part.js": "aa8cec5e7aa70a7a0d9560a141865e50",
"main.dart.js_324.part.js": "98eb2e2ed21307716f585440a86b9f01",
"main.dart.js_328.part.js": "ea506d9176052397a05560fcadfae9fc",
"main.dart.js_289.part.js": "ad56b238f39f6543f19a3927598df632",
"flutter_bootstrap.js": "5db125e94b7a38a7c41818c611230fc9",
"main.dart.js_315.part.js": "48ed02520964a0908dbe2e7b3a905fd7",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "514c4925a326ff2ce90ba74f070c66f5",
"main.dart.js_326.part.js": "e2b0e6d3a30d8938a6af25d909e919d6",
"main.dart.js_329.part.js": "2ae6f6f0f8d7c315f1574aa833ce9a1d",
"main.dart.js": "434e092902676ee59f03d5a184c133c3",
"main.dart.js_17.part.js": "549f32a869c6139479b0b11645871282"};
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
