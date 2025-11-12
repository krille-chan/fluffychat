'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "7205866507721af5693d99e25c1b55eb",
"main.dart.js_308.part.js": "ed5d65502f1deb6553e1ff957e07b1f1",
"main.dart.js_271.part.js": "21a329068459685c614267012813fc46",
"main.dart.js_317.part.js": "173054b8aaf3b1fcdad2fe9dbb69ffcf",
"main.dart.js_297.part.js": "18987b67190a18e9815b59e6bd469f67",
"main.dart.js_1.part.js": "4e0aa472bbda817eecab110d6f081baa",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "68b1fe8f5b33eeeddc584b0714c7dca8",
"main.dart.js_311.part.js": "3ea031c248bb13e348e77f811bf9e95d",
"main.dart.js_220.part.js": "99b01209ee21705c281585413be9cc07",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "46f7847f14a9766fe71a7e4fcd18f04e",
"main.dart.js_295.part.js": "21c3b16eaa332ae77adf2effbb4c51a0",
"main.dart.js_316.part.js": "0ee8e81ce8dcabb791871d84db0cf5ee",
"index.html": "4b2f1f118ea8f0cf3a85270d9ea16a17",
"/": "4b2f1f118ea8f0cf3a85270d9ea16a17",
"main.dart.js_302.part.js": "8ac1818d99759e506a2653ac8ced6b98",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "f62c64836cb6ec496a2fcd3e65e6656e",
"main.dart.js_244.part.js": "622712bf4e1987ce5538ad99e1233427",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "50dfa862c76f3644d68b539c6faa4059",
"main.dart.js_294.part.js": "c991827d5d062e967d212728f688f2c2",
"main.dart.js_265.part.js": "10769371145ef119ca09a355f41a6876",
"main.dart.js_261.part.js": "07ddf134744c21afe0ea71f5deaa2107",
"main.dart.js_262.part.js": "36a1664ac513555cee95cb7e663b7bc2",
"main.dart.js_322.part.js": "428651fb1c8f31386d51745fd6bcf188",
"main.dart.js_263.part.js": "fed66c6dd15a40ca29bb1129b0d9a5a3",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "0e19e678ae60aa66a0e8dc0bc37c17fc",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "111df6b65dabef946e3ec4adbd609659",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "ef83783771f5d095ef0cf9b04e9a83e7",
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
"assets/NOTICES": "5a1ef998ec4a5aaf47754e00aeda89f9",
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
"main.dart.js_16.part.js": "6cd29dbf3f07daea3dbf31f8918ac8c8",
"main.dart.js_278.part.js": "3ea597a533b9c3f1036c879c55b02a52",
"main.dart.js_286.part.js": "600cfc4c80b2302d029c5d253148f082",
"main.dart.js_232.part.js": "506dd017f9eb66ddee34f5d1c2226c9f",
"main.dart.js_333.part.js": "f8060526338a60c6fa8d7a2a04858b98",
"main.dart.js_287.part.js": "11db282361421dca2f3a3086c79d578e",
"main.dart.js_331.part.js": "18f095dd64655e3ecac4ca19ac769a95",
"main.dart.js_212.part.js": "407d074bfc894d9f9fa6374ef0030d96",
"main.dart.js_269.part.js": "02a648849450407cb7fe1f96b7c66498",
"main.dart.js_309.part.js": "0008e9269e1b2b72e94d37e53381429f",
"main.dart.js_312.part.js": "7abc206b0d270ee069d90255bfd41653",
"main.dart.js_325.part.js": "a1abfdb34a0312bf53f1dc1640d771f0",
"main.dart.js_321.part.js": "b224cba1f7ffdc4364783dda765ec6e3",
"main.dart.js_273.part.js": "947a0af73efd2c8260dd23192655836e",
"main.dart.js_235.part.js": "76168bdf5cb37ef56a911a3e0d0e96f0",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "290231e24c06c967ffa789aa37e6a9b1",
"main.dart.js_332.part.js": "2586ccdfa01d3c14bc337c5caa47b3b8",
"main.dart.js_288.part.js": "17727ba755901a02cc9cf91e161e7a73",
"main.dart.js_314.part.js": "85ddd2d028da7b29080899509856dd90",
"main.dart.js_307.part.js": "34db0d407bb32e1e1ddf6e03a4bf943c",
"main.dart.js_253.part.js": "b58b96e5cca03240ae80f7a93253ce64",
"main.dart.js_323.part.js": "483361a3644900e4491527b098f03051",
"main.dart.js_328.part.js": "5049cbaa0d40ec92cd28d203019db8c5",
"flutter_bootstrap.js": "794c5a522959abc9eaf6c2ec1896e7e9",
"main.dart.js_315.part.js": "6a161bd11876f1c3da9af330ac4d5794",
"main.dart.js_304.part.js": "0cf2ecc1c7b3763dfbce4c725298679e",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "a210a5cdfa56878070468a9af19f7894",
"main.dart.js_326.part.js": "4c124718db98545e3d8d8c61a86d403c",
"main.dart.js_329.part.js": "d41461ce81cab40c7455b1cc83b7c0e7",
"main.dart.js": "b3252a16083e105ea42970374a6b7cc8",
"main.dart.js_277.part.js": "70c62d3f93318ae39f51e7d6acd08fda"};
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
