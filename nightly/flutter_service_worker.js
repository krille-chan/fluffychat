'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "84efe21b8a39b3a26ad8c44d53d97acd",
"main.dart.js_308.part.js": "066c728dbd9798f31912cc47c89ac33d",
"main.dart.js_271.part.js": "f382e3be6d6511c7d8afb67613ebd085",
"main.dart.js_317.part.js": "c31afab4d6b67f1b999325c2339535d4",
"main.dart.js_297.part.js": "3ad35a82d5a486394b4c4b29b009ae07",
"main.dart.js_1.part.js": "c76d9adbe2975cdacfb034386ebf8ccb",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "00b5d457c3e624264942ac821a5414f8",
"main.dart.js_311.part.js": "31ffa5d78c2c7abd59c809f6c27a88f7",
"main.dart.js_220.part.js": "81d4b7d2b7973b70f3d05c208a51dfc5",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "f9edb6e816f52da9914f98daa815dc56",
"main.dart.js_295.part.js": "dd14808fd0fa9fe525fce942ab3edfb0",
"main.dart.js_316.part.js": "3f08f0b6bf65939ba52d1ff1c6286f7f",
"index.html": "6d5781cc3688a5ef3776f34ef54a6027",
"/": "6d5781cc3688a5ef3776f34ef54a6027",
"main.dart.js_302.part.js": "18389933080096514b462d84384af2f4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "2443c401b8d13015760b81ebf21ec02c",
"main.dart.js_244.part.js": "c76debdd62b6bdcbd187ee235b7bdc06",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "7fde1b05c8f092638171c83700d82bbb",
"main.dart.js_294.part.js": "dac980bc45c9f635bc43637a1b35c493",
"main.dart.js_265.part.js": "21d16cb5be73b0d6d35ef3aa9a8c265a",
"main.dart.js_261.part.js": "d608b5201e3f5d6f2cac37f1e62efab2",
"main.dart.js_262.part.js": "8b439aa5a051128a788b354bcaf64415",
"main.dart.js_322.part.js": "89d2ab985700e4fd05f58a500f6e0071",
"main.dart.js_263.part.js": "bef3985384c8f17f2dbccdd3fb383cc2",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "f321da06dd4f4d0e274de566418ccb23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b4943cc76346f03189b4219234d5841b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "7e1805164bbf491d454f6231250e10b4",
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
"assets/NOTICES": "4d4d997f25d9bd3d4ec2a0c14ffc01fb",
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
"main.dart.js_16.part.js": "9a65f45b091903061eddf7338bb87b01",
"main.dart.js_278.part.js": "b151e3f4d3e7a40e174d2ea90e01dac2",
"main.dart.js_286.part.js": "cff5c4bf8192b2233aeacf1190f854c4",
"main.dart.js_232.part.js": "fe2fc30a5e2837b581f4baf3d3aad14f",
"main.dart.js_333.part.js": "2c2c7d8ad1fae1644c4ecb4acb21ee3e",
"main.dart.js_287.part.js": "3941d08896047ad94038bd2cfb6d6b6b",
"main.dart.js_331.part.js": "52656a773edce4766f33897ec6410a78",
"main.dart.js_212.part.js": "87fdc8469a49110b6028d891c8d0cb37",
"main.dart.js_269.part.js": "6ea27ebac5f986afa135e271ad8e6f5b",
"main.dart.js_309.part.js": "661abc3026e9e027b5b7cd139e240c03",
"main.dart.js_312.part.js": "f09ad4f0f5d7c48245c572bcf5688d3f",
"main.dart.js_325.part.js": "2a06dea209472230adfab133eb6c885c",
"main.dart.js_321.part.js": "b062aa34946025a9ae28f1b78ff36f48",
"main.dart.js_273.part.js": "30075efcf9d4bda3d2980b5e97f6f68e",
"main.dart.js_235.part.js": "f231e147859e4c43fd0cc7e3c410d319",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "8dae86b2c2348517398b6aa433fd5841",
"main.dart.js_332.part.js": "48de331208fa0916c29c8e686bde799b",
"main.dart.js_288.part.js": "906edb1f59ec07fbb556c382b4e65a8d",
"main.dart.js_314.part.js": "b3ac2adfdb83136f5b20ed849558cf41",
"main.dart.js_307.part.js": "ffc7efa2e23f8f1046834144be4541ca",
"main.dart.js_253.part.js": "7d80d0de5cb3ae7f22814a08ba09d5f1",
"main.dart.js_323.part.js": "c78be5431da4a9fb53f06c104b0b1ecf",
"main.dart.js_328.part.js": "61a404770c3b848d636d22d68e2df057",
"flutter_bootstrap.js": "b7752be5b3e1e45e799e35ac04f1bd38",
"main.dart.js_315.part.js": "15c0fdf241707d50b450772239872671",
"main.dart.js_304.part.js": "440f5e7e071682025ff4a05edc73148c",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "f3056b7fb2edcef649a7c6cf32f92766",
"main.dart.js_326.part.js": "1ff6fc8c8c370663e0fd2abcb99b7858",
"main.dart.js_329.part.js": "796cc1d6f5ce5be1165a2795697d3dcb",
"main.dart.js": "6f628eb4cc64fc4c3bc423819a4d6d4a",
"main.dart.js_277.part.js": "6d86aacf02e8e9e6ba45b6f2107ac09b"};
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
