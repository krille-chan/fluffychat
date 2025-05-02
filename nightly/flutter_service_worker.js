'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_204.part.js": "973f261ddf04bda27868d23ce52aa2f1",
"main.dart.js_230.part.js": "61ada457c28d67497af758b87dba1c8d",
"main.dart.js_287.part.js": "ca7b51d2c7fc87b725124794a4604b4e",
"main.dart.js_244.part.js": "5a1d40996c0e901e3a058926bc1cc3ce",
"main.dart.js_286.part.js": "5e8b713222e418288edec417dff8553d",
"main.dart.js_229.part.js": "aa6e272d2a87af0b1a8cb273cbb445c0",
"main.dart.js_241.part.js": "5dedc7b653fe7c01dd74b200825967cc",
"main.dart.js_237.part.js": "4a284d6e0ad21610e92f349ebb352f0b",
"main.dart.js_220.part.js": "c6b5a7103c7f63074ef7a1d9e386754c",
"main.dart.js_290.part.js": "b2301c095b762d871cd6e65cb26d5b09",
"main.dart.js_260.part.js": "216f14f309b7072b7d98aa1457446036",
"main.dart.js_296.part.js": "58208f5c7016a710cacdac79e4637726",
"main.dart.js_263.part.js": "300e18384d47e5145cbc10e18474929a",
"main.dart.js_294.part.js": "8157c4842685c0c0d88e2ad7a192f453",
"main.dart.js_228.part.js": "baf3c0029ebdc6ddf778ca3385dfdfb4",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"main.dart.js_268.part.js": "e5e9da7ff9f2b01c61037900ce2d9c44",
"main.dart.js_282.part.js": "7d5e9d806f3c6fe5c7cc3171e37833df",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_275.part.js": "ffedacabb96bddb6bc3417115889c34c",
"main.dart.js_1.part.js": "996802da4d8f439b0e4f113c6dcafa12",
"main.dart.js_214.part.js": "9f0233f5b6b01400d2778c4e41f635e7",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"main.dart.js_248.part.js": "6a92ad9fed362c15b4193da300af6d30",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_15.part.js": "480ae1ec8e795a8d0fce84641ef23273",
"version.json": "bab3af646225186c2ee572830da047a7",
"main.dart.js_272.part.js": "8aa32220cd8d76536af0dc5dbd8c8d9a",
"main.dart.js_295.part.js": "2a64af09838eca111b0b6d6e4e61a944",
"main.dart.js_205.part.js": "077089826ab0c630ef1706b2cf63fb9f",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"main.dart.js_247.part.js": "3e5b518955b3afb17088bb9408516a0b",
"main.dart.js_261.part.js": "dd326518f1a29a69e416cfda1877d2e3",
"main.dart.js_274.part.js": "8b9ceabd7abc2c4047886e00d0870812",
"main.dart.js_203.part.js": "99f9640ad67f60a266de74b2da9b177b",
"index.html": "d57267b80a6c3a4df1de65d9a40c6212",
"/": "d57267b80a6c3a4df1de65d9a40c6212",
"main.dart.js_242.part.js": "70e8a2233c095174862864bbc0d10477",
"main.dart.js_253.part.js": "c98552230ea5a225915ce1e358d5b15c",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"flutter_bootstrap.js": "31ca0284c4ed2c90e006e8deecc747df",
"main.dart.js_232.part.js": "2681d0f7fe89bf80a77eedf48595ce80",
"main.dart.js_281.part.js": "24d146debbeb5125265fcea8ee3c0d62",
"main.dart.js_190.part.js": "3fed53a9900db82bffd4e3e0a08fafa4",
"main.dart.js_192.part.js": "f3e98e4521f984d496b41e212a1eda2c",
"main.dart.js_279.part.js": "52a3fd1ac7e9c1bd5f617d2255bffc3e",
"main.dart.js_280.part.js": "4cff8261c308724aa911bcbcc4fa7bc8",
"main.dart.js_291.part.js": "79cd42fd3a47f281aae4cf7f2aa3ba14",
"main.dart.js_273.part.js": "8ab4f39c784814e4812ec5a5580953ef",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_243.part.js": "7a63d0139a8c020e83039aac6541a68b",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_252.part.js": "c6499459f9cbb9633ce1bba7646844ab",
"main.dart.js_292.part.js": "1cf5fa1e12f66eb0d702fc6e3a94860a",
"main.dart.js_288.part.js": "0caa75136148288bb5b89fd27f4f1d4f",
"main.dart.js_276.part.js": "2e39ad95a2390746b4f9f6bdebe31969",
"main.dart.js_254.part.js": "5d9993e58cfb0ffaa8d8ab0e62f4aa2d",
"main.dart.js": "a22bdf522d5355cb13d499c1a16e4311",
"main.dart.js_239.part.js": "83eacba7c31632280d327ef9473e3a83",
"main.dart.js_277.part.js": "413fa9fb9b6bbb7f959281147589f8b9",
"main.dart.js_270.part.js": "dfbc65b8f6f5350835bfb33c1060cd0f",
"main.dart.js_293.part.js": "4923db116fd2d4928cba314fa2e5909a"};
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
