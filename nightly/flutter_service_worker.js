'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "4873120fa02cf31d296e979ce984d5bc",
"main.dart.js_291.part.js": "c7a545577c3bf227692f57a92c8efa3b",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "23eb4ff51181d67d9dc8043da8b746a3",
"main.dart.js_190.part.js": "87367f2310158b2b4a41d17e77dd5dc3",
"main.dart.js_244.part.js": "3e30680a82f514bf5ba205be45629c90",
"index.html": "323d87a8505e1d00502f3ee5d1beb616",
"/": "323d87a8505e1d00502f3ee5d1beb616",
"main.dart.js_296.part.js": "fe7736865757e11ef285fc75ae603e57",
"main.dart.js_237.part.js": "8e9c33a1a116747d9fe7ecc4fc74289f",
"main.dart.js_279.part.js": "5f02aafa152cb1f7aa0cafccd0beac41",
"main.dart.js_295.part.js": "9b5adec6b657a6c66d6948edbf06d72a",
"main.dart.js_263.part.js": "9e824073343d51d807dbffc3a3526edb",
"main.dart.js_1.part.js": "22b844bfded939107facf65b95f7380f",
"main.dart.js_276.part.js": "14b8a7ce669652d36bd688e7dc705e41",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_243.part.js": "ff01b7f8cbeb0187928265c62f6d1338",
"main.dart.js_253.part.js": "2d737835f2f35dc01ff8ef17842aee81",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "97afbb918a0e0897f8ac51d47935794d",
"main.dart.js_290.part.js": "a62e2b10e4466868cd4f3668e94cc2a0",
"main.dart.js": "80404f038ed966d598e96321b5f39252",
"main.dart.js_230.part.js": "9063748ed11f046471dab5ba66cdcffb",
"main.dart.js_273.part.js": "3debf6b986d06b9b835936fda4b4a463",
"main.dart.js_268.part.js": "781a4ba7db344e5adc5e1c0fe8cb8cf7",
"main.dart.js_261.part.js": "ac3211bcf132b616674036e504dc109a",
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
"main.dart.js_203.part.js": "a17d407301bf41d13ba1ecfd677e1535",
"main.dart.js_241.part.js": "9d5b965f5c566a80527d044932fe87e1",
"main.dart.js_248.part.js": "a4aa302029af4a3f45601461017abb7d",
"main.dart.js_281.part.js": "557bbf014db143564624dd5e83a9ddc6",
"main.dart.js_228.part.js": "27d382405a3f704a31fd22ab342bf30b",
"main.dart.js_220.part.js": "79ba9c035db1dee59a9f885b07f20255",
"main.dart.js_270.part.js": "a94aeb4252820b24ea5390468257cb97",
"flutter_bootstrap.js": "9fbe18a068d241453ba07b8679e0f474",
"main.dart.js_232.part.js": "2365de7be3e00db5c737ea27f54c0c0c",
"main.dart.js_280.part.js": "898fd22488118f23046b7e6c4fd0030b",
"main.dart.js_277.part.js": "0070964c6d735786510eecf19c181a76",
"main.dart.js_286.part.js": "accebba653dd4c7f65a1d871bf9d4501",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "1f521df4ebf7cc209cc604ab4688f91d",
"main.dart.js_15.part.js": "4cd0b7db7b682f9173aeec574254081a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "1a9e7d5192fc4a116eb960fb0916dad2",
"main.dart.js_205.part.js": "63e57f7ef8f118752bf7c9892864a547",
"main.dart.js_242.part.js": "c475ebc272a9a86a2e0c10df440b21ea",
"main.dart.js_229.part.js": "bb26fd5ef55ab9241c43fb8e169faf30",
"main.dart.js_192.part.js": "f2ab24998a43d49994fcb8ff614259a5",
"main.dart.js_247.part.js": "809d61f66b69023ae7153725203b1041",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "bd2873e6b6e9a8fb018198e0ccb6a626",
"main.dart.js_292.part.js": "74136529eb67f0b1fddad53ab0b73a1a",
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
"assets/NOTICES": "c8db5451253889809a6111899405e058",
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
"main.dart.js_275.part.js": "47bd1839b1a94a15659e1d25e38cb4f0",
"main.dart.js_272.part.js": "fbbe7d727e02affa53067ba84a1310ba",
"main.dart.js_252.part.js": "b5331f7444c10d5f9243131001448a06",
"main.dart.js_260.part.js": "7ceb83ac70a2d416f99b659c44edb85c",
"main.dart.js_288.part.js": "b9d4b49fc676bc9bc299f7da1f1654c9",
"main.dart.js_254.part.js": "ed167daded8c58ed282012962b425f3f",
"main.dart.js_293.part.js": "3c40eb5cbc77386fce58a814b405c3ec",
"main.dart.js_294.part.js": "d900d00fffa354a89b199a383d7798ec"};
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
