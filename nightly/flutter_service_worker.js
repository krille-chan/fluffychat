'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "89140771f58eb02e8c6509a3bde0f12c",
"main.dart.js_268.part.js": "0a5bea75af590feb352bd2b247522b63",
"main.dart.js_304.part.js": "116323b06fbdab552514b49f3ff281e6",
"main.dart.js_229.part.js": "9ad7faf88e3d69a1d17668d999a6818c",
"main.dart.js_256.part.js": "d66d2a45151c2f1c97ba8fe5d153918f",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "4072a8aac321535c480a0e5d77c25c2d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "1a5328e33fe6f50330580826d3c748df",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "b9b2ab6a07cc30a7a94b01d30c786b3b",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_211.part.js": "915da1ab37167fb30899ab4876373566",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_302.part.js": "ee0f78c99ce0febcf1d66d1dfbfe8b93",
"main.dart.js_320.part.js": "9cddde8b76153e8b9839bee4f1febe95",
"main.dart.js_321.part.js": "368f9f4cdf8528a8826518c2392cc182",
"main.dart.js_255.part.js": "2b89a4ad46ec3a580d1b371fb6b05e0b",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_315.part.js": "ffc7a868d7c33ea44da2ec71e4c23955",
"main.dart.js_300.part.js": "d19820f170b27698e45f389898cf79fd",
"main.dart.js_309.part.js": "d0a38a32684648f09d557074c29168ed",
"main.dart.js_228.part.js": "53fe51a137dd3cbd34181bb0e05acc47",
"main.dart.js_296.part.js": "8f94d27c0f392f8249c587e242406b3f",
"main.dart.js_246.part.js": "d19cb6ff5919f4a5247eb7b4c24ee8a1",
"main.dart.js_270.part.js": "aaacb9404eaec64536b06e2c75d0fe2b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "6a5add4c5967f17d2e8a9d13535644c5",
"main.dart.js_227.part.js": "764cce7be0919dfd39c5a0744fe26bfd",
"main.dart.js_254.part.js": "13a8b315e62ddd12ba1e49fb5cc2049a",
"main.dart.js_289.part.js": "e6a0b8377bb4e668c9d02452b86d2c70",
"main.dart.js_279.part.js": "ab87b4b6a0670ed9f4bc962c024644a3",
"flutter_bootstrap.js": "b2857124a147d313e7e9cf97a764d9d1",
"main.dart.js_264.part.js": "51005e483b36ea75ebba06e2fc8dd142",
"main.dart.js_319.part.js": "e8aed0ba0070ed863e779b985bef9012",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_214.part.js": "5c4cb7654e625e529ddbe080b76a0f6f",
"main.dart.js_294.part.js": "c8dc25c93bdb30806dafbe0e64596ff7",
"main.dart.js_323.part.js": "9492c8804275838eea615c50cc54bbd3",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "8f6abfef6cb003d3084eee3e3a42cf5c",
"main.dart.js_324.part.js": "ca3677183ab35addc76b8d3fd683c0f7",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "7607430a381e9025def70355f3646c46",
"/": "7607430a381e9025def70355f3646c46",
"main.dart.js_299.part.js": "73eaf93a19871c4ce7498aa1dcd0fed5",
"main.dart.js_243.part.js": "693774a98c237ef134af6b5664f374ea",
"main.dart.js_301.part.js": "fba9dcd996e66dbb3421163c564888e9",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "868d01fe6e5546f88567283f8af33cac",
"main.dart.js_317.part.js": "ab5d9f9d172a7a1456b7768ad0458816",
"main.dart.js_286.part.js": "0972b55f871ec05a3de5422ee273641b",
"main.dart.js_275.part.js": "23a1ebb05f824fb52ae2766f11c7e0b1",
"main.dart.js_307.part.js": "f0db223b226c4884e6313c1824462d5d",
"main.dart.js_266.part.js": "37d2e7e0fc1d68d755f62923a4362d2e",
"main.dart.js_269.part.js": "42870c6424fdcc947bcd1dea441a1c2b",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_287.part.js": "9ceddc6f2cf84953863a0281b4e41336",
"main.dart.js_237.part.js": "a5879cd4c1738d5d32a0d49ff36209eb",
"main.dart.js_303.part.js": "19e3f568f6ac667912c33cd32ba33841",
"main.dart.js_1.part.js": "1622f9a61eb50e7df58d1659c2851d18",
"main.dart.js_258.part.js": "daf9f56855ffa75d2d03acaa7ed06f4b",
"main.dart.js_313.part.js": "921200d4d30ece2d35c6f6a90e47da5b",
"main.dart.js_318.part.js": "13f00031e646e11eb63eccb22ca63f08",
"main.dart.js_314.part.js": "adaf1bbab2b12d40d6cb7db59cdf2482",
"main.dart.js_274.part.js": "35a8f0b47a6b7daa1f15e806bd21e017",
"main.dart.js_262.part.js": "d457aa8532d58911a896822c2e0c51c7",
"main.dart.js_278.part.js": "11f9ef45154cdb4c260eb00c84bd791f",
"main.dart.js": "fedcbbc013b45a350c59a8cae5111169",
"main.dart.js_280.part.js": "524ee6617f1ccc73e4a7ea7e8a3ef2f1"};
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
