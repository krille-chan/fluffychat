'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "61d95cc401a6da2bd1716383d8e27dbc",
"main.dart.js_210.part.js": "df617480951573ca83edabd8f0976a6c",
"main.dart.js_300.part.js": "abb6f5b6fd71676e9855f063a788cfa9",
"main.dart.js_228.part.js": "0d22936e3fce96e03c41ea1944529bb8",
"main.dart.js_257.part.js": "70011e5597b734d91e3a807821272aa2",
"main.dart.js_267.part.js": "6853143318cbe60d6b80bc5bb97969a6",
"main.dart.js_301.part.js": "2f53caaf5c40caecec582f1a0b6e4ea6",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_308.part.js": "1ff07eaea2965fd20899f7b4e9d80fc7",
"main.dart.js_303.part.js": "05de24d0da9c589386e05a71c7562e26",
"main.dart.js_273.part.js": "aa909dcd1cf89355ba39a5512e756daa",
"main.dart.js_265.part.js": "df688cb27e55acf9c4d0cffbdfcea7a0",
"main.dart.js_319.part.js": "19d819427df8db5c7d300db1a179ccdd",
"main.dart.js_221.part.js": "e61e972b5c320adc7d768eae5731c144",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "8b46f9d75cad8d1db94afa6f63db8db8",
"main.dart.js_279.part.js": "634da3f11b31c740025acd1ea270569e",
"main.dart.js_288.part.js": "5bb5990089bf1d1386f9d5765695c6c9",
"main.dart.js_302.part.js": "ff7b697ac6462cecfefdf08c34dc99cd",
"main.dart.js_269.part.js": "3493d57ae739ccd4b409b6a74945505a",
"main.dart.js_305.part.js": "da505d3938dfb31d7017840047624558",
"main.dart.js_293.part.js": "71a24ceb17664bc731c559756597d799",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_316.part.js": "b4ca7e0316c5a048b186ac1a2c1c89cb",
"main.dart.js_318.part.js": "7881192ef9f156500e85428a4dc250b8",
"main.dart.js_253.part.js": "434035e59d1fcde574b640ad071cbd85",
"main.dart.js_2.part.js": "5a7a87c48be3cbb45436f5efaaac9a85",
"main.dart.js_254.part.js": "066f9069ebcfca8842abceb2a38037d2",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "18e4410b65a7131e08b2d6520acb5125",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "d4632f5e953418589fbe4a467c423fd5",
"main.dart.js_1.part.js": "d0f3eb6750b6a90b5907856e2b31e3ea",
"main.dart.js_298.part.js": "3b605e7bc2f4382384dfb83075921b9c",
"main.dart.js_261.part.js": "cba1505d11f8d6df00cbf4a4867f8468",
"main.dart.js_320.part.js": "4efd64faca90b14bd12dd84ccf8bfeda",
"main.dart.js_313.part.js": "990025f05b902e3205f75baf83a9246e",
"main.dart.js_213.part.js": "4ac86981cbdf2f6435b39415a91df661",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "85d6315ebca6d83c8fcbf77fe5c9682a",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "b0714ea6b380eb71daca8e0ca51c1b06",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "1de5db495db8ba6cb3d947ba65cc733d",
"main.dart.js_242.part.js": "18d545753891fc131aa3e869343baf34",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "4f13aef6eac20b2353001c7f65865184",
"main.dart.js_321.part.js": "259e8524e90d89382606e7f1dd686ac3",
"main.dart.js_286.part.js": "1cad8e4588c3e5f8af1493c707df06b8",
"main.dart.js_268.part.js": "2872225ef4ffbe7079ff95796629ff48",
"main.dart.js_255.part.js": "a4235a180d1ffd5575ca6ba79d8cdaf5",
"main.dart.js_278.part.js": "0d5ae22c97880fc22b274faa2266d630",
"main.dart.js_323.part.js": "1ec14aa139774aac97d225125f1806f6",
"main.dart.js_299.part.js": "5fd96200834b45c01ec0d9828d83107b",
"main.dart.js_16.part.js": "fe0db74f345129df8787b75d69c2c25a",
"main.dart.js_236.part.js": "9e60726139bdb222dc8052fd257becfa",
"main.dart.js_322.part.js": "99208660a34c21699f2abf1f43e844b5",
"main.dart.js_245.part.js": "048cb962a2d26f2f5d90c343709f9766",
"main.dart.js_285.part.js": "f6d3c36fb49360487c01cda1abd0323c",
"main.dart.js_295.part.js": "49525cc5fa7d95334999081d336a3055",
"main.dart.js_312.part.js": "55ebc715cdea5c4e731599163b83eebd",
"main.dart.js_307.part.js": "0e87b24b06a2400a459cfb6aef46f9ee",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "4a69568d32ea05804ca224ce77144b72",
"/": "4a69568d32ea05804ca224ce77144b72",
"main.dart.js_225.part.js": "a20e63d5a04dd7847e34b0723f263669",
"main.dart.js_306.part.js": "14a652c855a6b3123f7a9fdde3bb7109",
"main.dart.js_317.part.js": "b912e42096dfe52c9f180dd20aae9f9e"};
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
