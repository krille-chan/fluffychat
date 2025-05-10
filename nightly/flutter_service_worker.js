'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "443e81e6acbd26914699d067cf3e714d",
"main.dart.js_291.part.js": "213c3ea315c8ceb0a81b5ef8bac5ad3c",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "587c1fd44928e3185736b611565b71f5",
"main.dart.js_190.part.js": "0b3ab8a37aa2ae566f089a9d847fb809",
"main.dart.js_244.part.js": "780d0e7e1d3d8222af9f0f84a0c582bd",
"index.html": "3b5c9bba96acee5164e0a921470ae3ab",
"/": "3b5c9bba96acee5164e0a921470ae3ab",
"main.dart.js_296.part.js": "0854f011a467b6fe73bb60a45ec561bd",
"main.dart.js_237.part.js": "4beaffc513c83f6e418ef96febcb0f74",
"main.dart.js_279.part.js": "dc4f198217507b6a6267940161618a76",
"main.dart.js_295.part.js": "d38bc5223c93d33ae803feb96bbc0416",
"main.dart.js_263.part.js": "e7ea8aafeb9abe84578c8d23c623b0ac",
"main.dart.js_1.part.js": "dd077089da20b5aad11de70595c4b9f6",
"main.dart.js_276.part.js": "bfb740cc708356f2961b3332bbfde090",
"main.dart.js_2.part.js": "d83ca9fabbe8277da48510c0f6dc18ce",
"main.dart.js_243.part.js": "f067ed3ec5eef646b3b7f24e32ca79d6",
"main.dart.js_253.part.js": "9a272e3945e91da4e2cb06e9a7a6198a",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "20ccab53f42d8a51a13c41314dd7ec87",
"main.dart.js_290.part.js": "cc8f8c78bc04f0c694cd2a02c1d103a6",
"main.dart.js": "58471c78e74f48de07254541b6a6058f",
"main.dart.js_230.part.js": "6f91a0cc027029faf63ac54d63f58953",
"main.dart.js_273.part.js": "820a59c52ed3a28b75775839530e28c6",
"main.dart.js_268.part.js": "f92f85fdaa3d7fb06c037fb5f6286338",
"main.dart.js_261.part.js": "01d54be83b4bec93b76200cd9ac5ca65",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"main.dart.js_203.part.js": "fae02ecb7c07d7739a50816cb4911e31",
"main.dart.js_241.part.js": "9c2878e65e55f1e60253de968fe9888f",
"main.dart.js_248.part.js": "d192c8a1a364cdd24edd881ab9390541",
"main.dart.js_281.part.js": "c6c0dd8da5dd0a14b0d1a3c6042686b3",
"main.dart.js_228.part.js": "b99158448dfce5561d048d6f64f0ecdd",
"main.dart.js_220.part.js": "288a797a91eede0f7bc1dc9d878d14fb",
"main.dart.js_270.part.js": "40c2f7b7baa1984dfc952ec176d5ae3e",
"flutter_bootstrap.js": "cb5815f8bbdf88f90ebf8a6f88f8340c",
"main.dart.js_232.part.js": "8be7d4e26e141ef54748abe0fe00f1e2",
"main.dart.js_280.part.js": "9c195a3e75ebdfb79870fb679d838a87",
"main.dart.js_277.part.js": "c77c858208a8d47fb23ca50fa77be927",
"main.dart.js_286.part.js": "06767fbef2302c426c73f835c7712cd8",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "198b9c50cb78699333e8043dd6bbc2e7",
"main.dart.js_15.part.js": "b9efc4f18970ae2496218aa17be9cae7",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "49109b2a9c33886218e54ffbbeb567f7",
"main.dart.js_205.part.js": "023de47dcc55a3a8f14b0e75db751943",
"main.dart.js_242.part.js": "172e382350cc7d4896467c2e1844e05c",
"main.dart.js_229.part.js": "9027625b9d823cd1b8f990063e976bbb",
"main.dart.js_192.part.js": "d5631017052de2316e30e01690104720",
"main.dart.js_247.part.js": "1055b0337b7da4ab76e5e7d3f24001fa",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "24e0842ee44e9a6bbed4813d8601e122",
"main.dart.js_292.part.js": "36781a72c37077cc0d4517995ec78d16",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_275.part.js": "204fc0c4ef50a36a471a40d6958b907e",
"main.dart.js_272.part.js": "2764c2f3d8fe4c6bcd58e63dde3f1917",
"main.dart.js_252.part.js": "caad0f9ac23cffc65b1b995795984a09",
"main.dart.js_260.part.js": "9ac93fec32a832a20e116fb4a32b8340",
"main.dart.js_288.part.js": "ab5cdfc34e32df4838df3f722ee37d5d",
"main.dart.js_254.part.js": "a02c39887a58b58c03befd09c063db16",
"main.dart.js_293.part.js": "99dda9bf0738d04e29ce4a7dc63ddd6a",
"main.dart.js_294.part.js": "6f9c7dc6a8ae5e8644b79fe70ffdaaed"};
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
