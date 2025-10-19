'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "ccb8b0da99cf9e2a94e36add9ecf09b7",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_220.part.js": "716ee33c974212041c47ec27d0bb41c6",
"main.dart.js_1.part.js": "8e3eda5183fd9c904209a9eafd237a8b",
"main.dart.js_293.part.js": "5df4c43147ebc0c88a2abb8a4d43cff6",
"main.dart.js_302.part.js": "e8f1ccfa2bd45270d99030bfbd9cd4e4",
"main.dart.js_321.part.js": "a5dada4a7de11ccd2fae822dbef664d0",
"main.dart.js_253.part.js": "9216b7d2d1a0b9eda5e6a932bce4023f",
"main.dart.js_305.part.js": "4aac4b5d99d0b30da17087973f3a40f7",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "2ee239885e322b9ab43d14ebd989de64",
"main.dart.js_277.part.js": "1ec22dacde6d27dd776e5949a863a477",
"main.dart.js_265.part.js": "06c9bf8dce9ce77bd76d8b5743bf6b49",
"main.dart.js_323.part.js": "c6fe7a726becc25cab2fffd59c268e31",
"main.dart.js_225.part.js": "139c8548637a70f87be4de1fea8fca01",
"main.dart.js_301.part.js": "1346a2677165c88f9fa42bbcda7d39d6",
"main.dart.js_295.part.js": "58b4423cce391a5270ee0b207dfebdb8",
"main.dart.js_278.part.js": "923a0374f9fe32d3348416cff185b269",
"main.dart.js_312.part.js": "fbfb13174359fed3d49f656707d2a5a7",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_268.part.js": "5d6ac22743991b8422e3d7a0796e713b",
"assets/fonts/MaterialIcons-Regular.otf": "dd361349492111cd1aeb4ac406910792",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "32264d576c001f8ea24a9a8a8caa4ec2",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "48ced315403b507753c6974c8fb41595",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/NOTICES": "ccc7b438b6733657324389d49423afca",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"main.dart.js_298.part.js": "adb049a8fafc24780f11cd1f9bea0035",
"main.dart.js": "6affe5421be937150e46cd2635ddda43",
"main.dart.js_279.part.js": "21198d20f071fbec096df13870de7485",
"index.html": "e1c4fe153cac0fcd106472e416a0f314",
"/": "e1c4fe153cac0fcd106472e416a0f314",
"main.dart.js_307.part.js": "4cbcca3ea3f51a4c63cf9a953df58703",
"main.dart.js_318.part.js": "d6f96330c0b446b3c6fe7953b90c3237",
"main.dart.js_254.part.js": "b2b16be5aa7801d6375694ea253a6965",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_257.part.js": "bc3c89130bca88ab5ac224cf64cd24e2",
"main.dart.js_228.part.js": "9a58004fd68dd26d20c91bb41d631e4e",
"main.dart.js_274.part.js": "6fdc9500d600512dee18e59f68226315",
"main.dart.js_236.part.js": "4a864a78481635900f809e9c10717b77",
"main.dart.js_273.part.js": "815ca5db837027aacb9ef7976ad6ee70",
"main.dart.js_267.part.js": "5369093f14b687c989aaaf7eff42a161",
"main.dart.js_288.part.js": "3192a0a3e51a78e3c4c83daa74a2b542",
"flutter_bootstrap.js": "07f09ba2ef9ee6f5883fa8756c2e00bf",
"main.dart.js_261.part.js": "364765222cf714270c6dc2f5a8db37b2",
"main.dart.js_322.part.js": "fa2a36b75838f4be42f2682b2c4a825a",
"main.dart.js_308.part.js": "5031cf52f3c948b8b4562f24bdbea7af",
"main.dart.js_300.part.js": "308c38ea70e3190bd461770ee1a06f62",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_255.part.js": "bef48167ccbd6405560d7de29f9bbf7a",
"main.dart.js_286.part.js": "887bee10f56884b481657298e8f4ee24",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_299.part.js": "f499d66eae2d8e729796988ad8799b0c",
"main.dart.js_303.part.js": "0baccbee9219b16351bf90fc400ba04c",
"main.dart.js_263.part.js": "ac468be402dac71311a2154495dd167f",
"main.dart.js_242.part.js": "509fed6b9345e4ccd01d676fb5a077d1",
"main.dart.js_317.part.js": "a4f9982dc8355f448cc0f494a99798d6",
"main.dart.js_320.part.js": "1d910a13df3ec3fdec0cb4c29eba12e2",
"main.dart.js_316.part.js": "605a7bf8325a47b7a09291b763e4a45c",
"main.dart.js_212.part.js": "e757cd2b43d0e361fb2a99665a4c780b",
"main.dart.js_314.part.js": "634878c0acc6134a443f6f5519843c7c",
"main.dart.js_269.part.js": "9f776b625faa8994d0a11ce48bb08cac",
"main.dart.js_319.part.js": "e3f65064f600b3c2c34ae82b7cc98871",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_306.part.js": "4b5296eb411802211f19786900a66f45",
"main.dart.js_210.part.js": "6323b2b9fc52a21e0afd924a0b551788",
"main.dart.js_285.part.js": "678227bed30c323e126dd430d286e110",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_245.part.js": "9f017238085e743c745db28ab547f43e"};
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
