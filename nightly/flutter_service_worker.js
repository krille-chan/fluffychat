'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_207.part.js": "a78fd0ee45aeecf63343a5312bf66a0f",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "6817839fe540bc49f86ef9619c8cad06",
"main.dart.js_317.part.js": "592da8cdd8085b9e2ad7e947a9e9dfaf",
"main.dart.js_243.part.js": "18fddca8f9fc8d54402363d84dcdf4e2",
"main.dart.js_1.part.js": "865006df582405a18f5f28a4525d0952",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "fe682ec13bcfedcb39db6cca0f11ba1e",
"main.dart.js_274.part.js": "6a7db43e5aaa65b5073772d231f2a9ec",
"main.dart.js_318.part.js": "f8fd5fccaa49597664dd420a5510dc7e",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_266.part.js": "3c8a2e80c5f59aaa34a4b753ceeeaa91",
"main.dart.js_246.part.js": "d81324b374fd49f8051038820c496843",
"index.html": "d5d426c450dcc8fe9a2dc6857f33b08a",
"/": "d5d426c450dcc8fe9a2dc6857f33b08a",
"main.dart.js_302.part.js": "f44980a5874d4a65cc074cfad228b7bb",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_258.part.js": "472d943bafe1291e4bb913f2b3dc55c8",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_294.part.js": "7c8c92e6e4211c92805183292c17513c",
"main.dart.js_300.part.js": "05a24fd6ed109c056429e3484f7140fa",
"main.dart.js_262.part.js": "3bbaa85eb7ebdb939c8402b74347409c",
"main.dart.js_299.part.js": "98c7f35612f9e3eb7e28a250b958617a",
"main.dart.js_322.part.js": "5a7c15c064edefddca395ad976e1e6c3",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "cf6f25cee91a990b7f01dc71b43cd354",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8bb21a3080f8d4866af34c8ba3567ad8",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "abd5af5a6dde52a998947de795b59f4e",
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
"assets/NOTICES": "6cfe799430e6c840c30290f71ccbac3b",
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
"main.dart.js_320.part.js": "b69c957d806195f21cf066e553296919",
"main.dart.js_254.part.js": "aa15f6963d410be0a9395a76ab7b1e7a",
"main.dart.js_228.part.js": "6ba08258ae15f17e87b0454c23564591",
"main.dart.js_16.part.js": "ee6a3b2cee1cd629dc41ce3bfc084811",
"main.dart.js_296.part.js": "3b02c789f1d034f9e73fb7751db3d8ab",
"main.dart.js_278.part.js": "59fcc3d9a2690b4c0bdc81e0ccb8ecde",
"main.dart.js_205.part.js": "f0f9e6f6b3236904f2a38cd3a1b5c0ea",
"main.dart.js_286.part.js": "8910c12167568b7ebbcb022829fd0f65",
"main.dart.js_303.part.js": "2935adafd0928e1baa787d35cd1e58ef",
"main.dart.js_287.part.js": "bc33797bee6f6e5f3c55ea4a3faaa149",
"main.dart.js_237.part.js": "2647be0eb88e3be79f71a6a3abde50d4",
"main.dart.js_213.part.js": "7be0f1289ab2e57a57325ee5a0b840df",
"main.dart.js_269.part.js": "ffc00e4edfbc827f161edce96bfbbbf5",
"main.dart.js_313.part.js": "e2d7a9bbae81e7e582487541995b3932",
"main.dart.js_309.part.js": "cfdcf39c374d4ed27f92cdbecccc9f68",
"main.dart.js_270.part.js": "c15a1a6d5c4e8d0ba51dce02e70b75be",
"main.dart.js_321.part.js": "00e1678a5ccf98bf88f01331738d5cc2",
"main.dart.js_255.part.js": "4eeb5cd0c7ee477c01c5c5337d0319e0",
"main.dart.js_268.part.js": "47ac758e5ced5756fbfdc634c1416dd9",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "5efb05c98f390698a88a547b55da8598",
"main.dart.js_314.part.js": "5680f7dd4426f06ffbd41f21c7d8c1f1",
"main.dart.js_307.part.js": "ad8d90aedbb9af5f6ebec8df74682f9e",
"main.dart.js_279.part.js": "c1eaf5c5d3eb86c585a338b8ef58e6bc",
"main.dart.js_319.part.js": "584a390f5bfeb6242e64d50f1336cbd4",
"main.dart.js_323.part.js": "05efa0f02fa83e536d725020b79444cf",
"main.dart.js_324.part.js": "1e3a5527b22de0cae482d7ebedb92027",
"main.dart.js_289.part.js": "beadaf08326b8a44089e3e64f283e145",
"flutter_bootstrap.js": "a4123a125e90f1a12573e3b860d106c0",
"main.dart.js_315.part.js": "c6a9832e5893168797da1fedcb3e840f",
"main.dart.js_304.part.js": "e493ae03ff893c1441724745b2c10fcc",
"main.dart.js_264.part.js": "1358d28534ec4581744b9bc04286abef",
"main.dart.js_306.part.js": "f9c999c576c7bf32931fa6769c155680",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_225.part.js": "4984d6566332ef52f4a673546c023ade",
"main.dart.js_256.part.js": "a5561ad0645744b664ec942df462c782",
"main.dart.js": "a395addc6dba5ec64510ade2e0babdac"};
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
