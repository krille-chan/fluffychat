'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_229.part.js": "60bd3e53c5ff73fddfb0e34c7c7b3201",
"main.dart.js_254.part.js": "bf02f428b6e1532da5da47a9294615b9",
"main.dart.js_247.part.js": "5a0ec00c68a351755ea3503320b78519",
"main.dart.js_291.part.js": "ba4dc7888ed261d16c9164d1c81d5312",
"index.html": "e365d9866cd2585e0237c019168af6c1",
"/": "e365d9866cd2585e0237c019168af6c1",
"main.dart.js_190.part.js": "fabec06b985f42b4a8166b7134281b0b",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_203.part.js": "5586a49308048411e85e3c49823e2380",
"main.dart.js_214.part.js": "fa92cd09bcb50d487001415b54104ec7",
"main.dart.js_276.part.js": "d69e329cf26bd07fdd29623111b71cf6",
"main.dart.js_260.part.js": "1c2ad8c33b075ae7c9c7e38c657dcb32",
"main.dart.js_204.part.js": "319ff33bd3a85d02aab084f43bcc3a89",
"version.json": "bab3af646225186c2ee572830da047a7",
"main.dart.js_252.part.js": "9efdbe4a8288e2d5464753c18c7fb274",
"main.dart.js_263.part.js": "ace093684d344f05076a86d83e281ab7",
"main.dart.js_232.part.js": "169cdd0c8690651ea77d4a6994b4a2d5",
"main.dart.js_277.part.js": "967fd77e50e8a61e9cfa8be11f21b229",
"main.dart.js_273.part.js": "16c1f2e5a7dfb7a9381a41beeb308676",
"main.dart.js_281.part.js": "2654f6585232246f18f725cc280d3e44",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "2953f521a001d01cf6e52604b118fe46",
"main.dart.js_243.part.js": "3c3d3beda6d6729cfec44e5c6949c27e",
"main.dart.js_294.part.js": "4b4f72788fb1f97c205f3b53168a60a6",
"main.dart.js": "8c9e6d0fe288e6ada5d7e05f296100ed",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"main.dart.js_292.part.js": "070de43c9ab1e3106836d80321662160",
"main.dart.js_244.part.js": "5e5db612cb11e6d35a9f895c8cbcd1b9",
"main.dart.js_205.part.js": "b82f8802ffe31ab69f2299399228f978",
"main.dart.js_220.part.js": "d26d2cb47b6a08d26ab660eb83be3d2b",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "3e794b454c6b479eca4476c5f6b0f9c5",
"main.dart.js_228.part.js": "530ecdfb34593d7ae57883d2a9cbd3d2",
"main.dart.js_280.part.js": "c7f9eb3c0b4fbe00419da2174c409de3",
"main.dart.js_296.part.js": "dd36186d943fdd864e13e3628e3a7b55",
"main.dart.js_253.part.js": "54fec3e88ecb93ce74268f6644f324b7",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "1e733c613863aa5a3799d37d2b7a9630",
"main.dart.js_237.part.js": "71633d3507d9e229306a8eb6515308c8",
"main.dart.js_288.part.js": "4b1febfd9bd79fd255d5a021dddc29cc",
"main.dart.js_241.part.js": "6cea9727fe9e1db072b19f2f9479175b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "de5ecaf448d998cb0d5ad39187b4986f",
"main.dart.js_286.part.js": "205a08cd3f2adcb0c11dc288099653bc",
"main.dart.js_192.part.js": "ac4ee7260fe7a5fb78856cb94e1e89f2",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "225303852e46c6d48afd932b9fe24e31",
"main.dart.js_274.part.js": "f28dbe3f785ead464c0d3427bad0359a",
"main.dart.js_239.part.js": "171d1373d64c5c9739673c397848e7b8",
"main.dart.js_295.part.js": "3de09bf0283ce062edd6909f556458ba",
"main.dart.js_275.part.js": "0d36617098ba43764c870eda4fdb143f",
"main.dart.js_290.part.js": "81ec15f5fd6634e5827d3e33e9f8da9c",
"main.dart.js_268.part.js": "271c8d75f09f1518a40a3091f031c3d9",
"main.dart.js_242.part.js": "edfb43ff87ee4b5b519f947630e34769",
"main.dart.js_230.part.js": "1bbdfa35f79de05714f132ef03338e67",
"main.dart.js_272.part.js": "c7267c0d1547b056a09a65dd22c200e2",
"main.dart.js_248.part.js": "65f1f69e03bbdd0981e0f78791f4a70f",
"main.dart.js_1.part.js": "702e656ab846f04077c3d81e457dfb02",
"main.dart.js_261.part.js": "a848609fb0fd860a35a03860c3b73b8b",
"flutter_bootstrap.js": "c9c681d5626950b6352a5e3ff9fb200f",
"main.dart.js_15.part.js": "a1a25816175bf91b7e35c0a45d449625"};
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
