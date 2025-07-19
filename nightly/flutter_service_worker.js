'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_223.part.js": "b5e07a94f4356fce19bbc8477563f4c0",
"main.dart.js_256.part.js": "df1095ea7b1e3d3e29d7c31b048bae37",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "20f15e2f6289e057c18b065972238efd",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "fe0c785d312fb45e94c776ee134bd606",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "ffdca38215708d4e57fe39ae12d3be4d",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_196.part.js": "5f3ac3a52100cf7919dbb78ea64dd4b2",
"main.dart.js_295.part.js": "2b2f01e29c271a1403acc65ae77e9d87",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_244.part.js": "801e5e01a4c406255b926c393723e7ce",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "4b61796e2c9a581e041c5ee3eda2ba46",
"main.dart.js_234.part.js": "95ebf5e66bdd7cf208ac5c421932ec73",
"main.dart.js_296.part.js": "f88ee8852f15939bc506e14cdaefc501",
"main.dart.js_298.part.js": "79886907a4f8af6d77c4d5e7f9ed5e9e",
"main.dart.js_246.part.js": "c8f0090de36661b89d20d7f2c7d74e2f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "7098a2e24db5d09b66e63da0a0d97d66",
"main.dart.js_277.part.js": "6de77e6bbd72b2e59914b11467be40e4",
"main.dart.js_279.part.js": "4a21dc04210973f9d827321ecb40907f",
"main.dart.js_217.part.js": "642f28c1c74e744ce426e08c0dd1985d",
"main.dart.js_235.part.js": "a07efa633a8c18b4e87a3f556841c959",
"flutter_bootstrap.js": "77f9c5762aecf4cb3b2bbea2f567b3df",
"main.dart.js_264.part.js": "7184a2ff42c21b179e2c0b944f4d28d8",
"main.dart.js_194.part.js": "bac74061978c2aed854d28a5eaff4553",
"main.dart.js_267.part.js": "47af93f4076f69d0fc05004bc066098e",
"main.dart.js_291.part.js": "933a5f6576d899149f580515f466ef74",
"main.dart.js_236.part.js": "7f865137746b45740b40cc745772f56c",
"main.dart.js_208.part.js": "9b48bb9b6afe0e3ca1b014ff751bd88a",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_290.part.js": "b116884d7e5777e17e03ca1b10c4e119",
"main.dart.js_294.part.js": "f78c1d7663b2db0ef31d7ec99c6e2c10",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_209.part.js": "b74aca32b80d36e00548f4580dec4d9f",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "98e8742624c3ef0a961ab964ddce765c",
"/": "98e8742624c3ef0a961ab964ddce765c",
"main.dart.js_299.part.js": "59e2e46e088e8bc55b3b3e141bad34eb",
"main.dart.js_281.part.js": "7d40fe21858b2237ecdfebda33c2de8c",
"main.dart.js_242.part.js": "4f0bf5744318602f4581c52bddee9f90",
"main.dart.js_301.part.js": "0970fb5a5547454fd447e26fe193e592",
"main.dart.js_297.part.js": "61c026b573861df45efd9237e2ed983f",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_286.part.js": "ba1633ae95f076eefd4228d1c9a60202",
"main.dart.js_292.part.js": "d0e57021b43e75b305e48c7fca35376d",
"main.dart.js_248.part.js": "2912c57cc7f0a9106eeadf1b4026707f",
"main.dart.js_249.part.js": "1cca5439718cef0974dfc87b6de64a3b",
"main.dart.js_252.part.js": "e91662ff9503b03d21e35ef42ad33001",
"main.dart.js_272.part.js": "a533661f23ca149cd2caf626d3ab7c38",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "39dd816e4a3c97e916f7359f9820e12a",
"main.dart.js_226.part.js": "55b769c999fd5ca58c08ec00b636413a",
"main.dart.js_284.part.js": "f9c1dbcad0b7f57d16da6bbd6b4d7066",
"main.dart.js_247.part.js": "9c2cfbd6eb9818ba6f99e35344b1579b",
"main.dart.js_1.part.js": "5939a4f02e58117bab5500ee1b806729",
"main.dart.js_258.part.js": "dc48bf0bd4f3c3487b12dcd5a9dd6df4",
"main.dart.js_285.part.js": "47dcc00d6bce69d9991bde3064bc0035",
"main.dart.js_265.part.js": "1fe51f17a6c7d901510a940245bdfb61",
"main.dart.js_274.part.js": "d4ee5b8218d803f03f7b6903497cf2f0",
"main.dart.js_283.part.js": "92c08772f6b3b6c18c41217f8a8a3d23",
"main.dart.js_238.part.js": "8d312e8ebc30736763a7bcc011d77273",
"main.dart.js_276.part.js": "e18a53d906d0c233837f30b13278b805",
"main.dart.js_278.part.js": "d5dbe6a78a524690ef25932e8aba2ffd",
"main.dart.js": "ceb37d38af4100b69dfe1e9da9f92375",
"main.dart.js_280.part.js": "1d8b8761193ec9a7357f1e9c5acd821f",
"main.dart.js_207.part.js": "45585d489179981882b3e666c3b28777",
"main.dart.js_257.part.js": "bb7a648e7c74025c9f031c82eda9ad9e"};
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
