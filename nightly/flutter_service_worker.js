'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "0fc0181b7cd6763d912daa2a5f13ab60",
"main.dart.js_271.part.js": "56e6f5212d2b49739f489916ecffa73f",
"main.dart.js_317.part.js": "536f699c35bc60f9e44554c219460a72",
"main.dart.js_1.part.js": "d495a9ef488f8f44f85ad5bab5ac33bd",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "426cc73e10bfec51d6b5156e854533dd",
"main.dart.js_311.part.js": "11d1e30785c4f1fff0694b5b8ed7623a",
"main.dart.js_220.part.js": "0ece745669b2a8ace06dbf1a4e22696e",
"main.dart.js_318.part.js": "093b3230e89a6f9b3d2172feb085a696",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "e3da659e608e6933dc79124e80643a2b",
"main.dart.js_295.part.js": "3a9903ffe6a9e7f2c2e7c89365a6eae7",
"main.dart.js_316.part.js": "60a4ceff69e3352cad3003d0ed5eb363",
"index.html": "7a6a706d3a9596139146db06c00ad865",
"/": "7a6a706d3a9596139146db06c00ad865",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "b6616c61015888c040d620200e38a0e1",
"main.dart.js_305.part.js": "d7d18a912e919ff5cc442c27d8daa165",
"main.dart.js_244.part.js": "9ac4e45b2e060869382d1c612437a328",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "0c9661493f2315badee12e3675289b01",
"main.dart.js_265.part.js": "0a9ab474012072790bb29dcfd23f0d71",
"main.dart.js_261.part.js": "5cf4753ad61dcf27295321fc5820f813",
"main.dart.js_262.part.js": "4bff82d93dfa3b4580d8f1c1dcefed13",
"main.dart.js_322.part.js": "10300ddcbaf99db091bf2c614b92f22c",
"main.dart.js_263.part.js": "24b2123fa08726a7a45954499a3dff33",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "66801b070d5bd3c927bc41bae9d5b75d",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "bc150b9b8d8f0867d8737cb60aaa8db5",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3700a5c275c7c9762ebbba9c87509441",
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
"main.dart.js_334.part.js": "4aec1ebb8f73568e2ac34a891bcbe444",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "47850a4fba566f57e268b0bb6b887ae4",
"main.dart.js_296.part.js": "070f53c85d8945d892900fc5d0f08a62",
"main.dart.js_278.part.js": "522d4b097578d525b54610c924055f8c",
"main.dart.js_232.part.js": "40f93ab6179141819a663fd7c311aa3a",
"main.dart.js_333.part.js": "70e29fbd5f57b01332c7e44f57f4ebc9",
"main.dart.js_303.part.js": "405c7d5f8324d9dc41ab49ffd0d0782d",
"main.dart.js_287.part.js": "7732ae99cb11966b9bfa8d60a5334ea1",
"main.dart.js_212.part.js": "7afcb79b942ebe0582ab5d05e6835a3b",
"main.dart.js_269.part.js": "e8af22bd63c4889cf1b662f0d8f2687a",
"main.dart.js_313.part.js": "0373cf584e2060342e627d2f8d951450",
"main.dart.js_309.part.js": "60515d5bc0c6cdd8152c8b98f404efd1",
"main.dart.js_312.part.js": "d7a19384762a541d3afd6c4c34f3555a",
"main.dart.js_298.part.js": "816372c5a2191fbb09cb2327af97cee7",
"main.dart.js_273.part.js": "1d4149959e867b54e891b8af3e738211",
"main.dart.js_235.part.js": "3b79c6fc4e864b7f7348df8a3a501656",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "284f16fd0a4048277d2eaa6f68e82089",
"main.dart.js_332.part.js": "e227398b815ee3f528b3733e0db89ff2",
"main.dart.js_288.part.js": "64db1803b25080bf5e4d780b71fbf5b5",
"main.dart.js_279.part.js": "016db738763f76d73c4df43e0d656ee2",
"main.dart.js_253.part.js": "205afde28395cd33c33a62f7c1dab47c",
"main.dart.js_323.part.js": "3039be56f64a6fa7c185b041d2ba72c5",
"main.dart.js_335.part.js": "0080030f4a64fc2c4875f53c0832b0b8",
"main.dart.js_324.part.js": "11a6be0f2af84b6b7e62cfc08d9d5cb3",
"main.dart.js_328.part.js": "592fd5beb46618cac0aec90814d98af2",
"main.dart.js_289.part.js": "e0473cbd526d2d343d15d874e9041156",
"flutter_bootstrap.js": "a045f2a4e5c81f693a091903fb19cecf",
"main.dart.js_315.part.js": "79641bea8dd8f2649d3d82aad3c42675",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "63746ec92cad1391ad21682da1b8fa46",
"main.dart.js_326.part.js": "eb5d778e8c6cb5ba74b4048b0af5ca0a",
"main.dart.js_329.part.js": "f84a1ada0bb6284286bad8411756434a",
"main.dart.js": "cb937e2f3f18b338dc85c79ba8339b44",
"main.dart.js_17.part.js": "4eb8b7f8543a5aae65671e2a6023a9e0"};
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
