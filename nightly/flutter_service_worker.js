'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "0a270b2ceda3040ba4ec95b3141e7493",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_207.part.js": "f79f0082f9fda8028b551ef65c5d1701",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "db2a7c42fe931598ff39207933eb11ff",
"main.dart.js_308.part.js": "0b52d9942de70afb5affbc20b515cdd8",
"main.dart.js_271.part.js": "3f48b3740bfb9fb6598ec4d972aaab11",
"main.dart.js_317.part.js": "bc9ebc76ba970fa18f2d631b9b6f367b",
"main.dart.js_243.part.js": "289377359e46489d2cfd09373e011ecd",
"main.dart.js_1.part.js": "9eceafd272b203ebf03088308e36bc92",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "23977ac19369795d0dad26ecf2888daf",
"main.dart.js_280.part.js": "bf3eba56c6295e56a348ffe63644e1b6",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_266.part.js": "5c062e3d5f9f9c4addb7f285298efc49",
"main.dart.js_316.part.js": "e653befef0a21bf6483b9a33c8537257",
"main.dart.js_246.part.js": "7c3c1154794aed33e4e71d93a4783d50",
"index.html": "2c0eb2f7fe31debd1a9eae28ef177c86",
"/": "2c0eb2f7fe31debd1a9eae28ef177c86",
"main.dart.js_302.part.js": "e844772fb8668817dca67e07561adf7a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "7212f8d35526d4420bdab7e22e857290",
"main.dart.js_305.part.js": "dace66159b7dd2b6414b773d71678532",
"main.dart.js_258.part.js": "47e2816280644c259a781e7efe27fa11",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_262.part.js": "3a00a735c5fba18374dc1fadb05d3a90",
"main.dart.js_322.part.js": "8a49fb8abded4134bc1749605b77a6a8",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "047638ec70636fa022dce82679b851ac",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9347f6bc15b416299447c41f09d07dc7",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "84122286712f363413510742832b877c",
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
"assets/fonts/MaterialIcons-Regular.otf": "74d774e5a77a4138a1b82ca633ae813a",
"assets/NOTICES": "946df0b38a26047c6a3ed9fc0b54514e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "56e0bc28a01629beac7ef5bc0e4260eb",
"main.dart.js_254.part.js": "1484a841a1bbab1bc0dd52e09b33cb95",
"main.dart.js_228.part.js": "90df0d6c00ee72de16ec0c6d4d4fcd02",
"main.dart.js_16.part.js": "ff06f02cda3af5edc7b1b2825093d1fc",
"main.dart.js_296.part.js": "2a1147b69ad8cb2917e8934a85fc7695",
"main.dart.js_205.part.js": "e8020959975437e68242172591e20abe",
"main.dart.js_303.part.js": "e0c7be88bf63e36dd3e0df10fb39fc95",
"main.dart.js_237.part.js": "7d6e45e48a22e70ce57d6872e4441e6d",
"main.dart.js_213.part.js": "1d0f825b1bc1d02b5c20b4cd8c4c14b3",
"main.dart.js_309.part.js": "1f324dad96d676c83e994e856da75a94",
"main.dart.js_325.part.js": "73f1a3dbd6a171698aebe9a3cef1f13e",
"main.dart.js_298.part.js": "71772b2743e4a8a15d140f9b86faf3ca",
"main.dart.js_321.part.js": "42149f063533a8b84c0f010bb133c091",
"main.dart.js_255.part.js": "0a3375699539fdf0735892414a0cf4cd",
"main.dart.js_268.part.js": "e3a566be436920d0f7b56c52a9e844b9",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "9c1dcb58760df514d8c519c027492170",
"main.dart.js_288.part.js": "5b9bc3939c01d085a07f927a4944ddff",
"main.dart.js_319.part.js": "93bc8c7c487467d352b7a9efb1be9f8c",
"main.dart.js_323.part.js": "c5cdbda9ef1a98e3fff1a0559dd66238",
"main.dart.js_328.part.js": "07b112165e289f3938888343e1fa6eb3",
"main.dart.js_289.part.js": "c2e4c0f4ede0a541769b0e16c9b347ee",
"flutter_bootstrap.js": "ffe06c155dd556929f340fac3011a739",
"main.dart.js_315.part.js": "c49618392809343390e64d9eb1d13ff9",
"main.dart.js_304.part.js": "bf5d0c996b96f93496eac172c6c5c7f6",
"main.dart.js_264.part.js": "092a84aecc22f87bfe38c63976d429d3",
"main.dart.js_306.part.js": "66136324dd551fe5b0acca4f5fe2d622",
"main.dart.js_276.part.js": "d90a211a70dc9e022a25aa636824d40c",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "af829f55dab656b080c423637aa153f0",
"main.dart.js_310.part.js": "e3172ff404f18efc3c671617329cff83",
"main.dart.js_256.part.js": "6ae20085edb4c2d1c30c816d6efebe88",
"main.dart.js_326.part.js": "812d2c443bc193cdfa5d9edbd7bb0e44",
"main.dart.js": "899b880cb5c31ecd338d89f18225ca77",
"main.dart.js_272.part.js": "38caf683936cf1a95746147a05cd1705",
"main.dart.js_277.part.js": "0bed144a744623f4976991a9d379d96e"};
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
