'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_281.part.js": "ed0628d01eb51b4d893e59e3043c556d",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_295.part.js": "5df2726691a1ce0b6da24cd595401ef5",
"main.dart.js_242.part.js": "2fd171b33589b2f4ee082b961259c4e2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_194.part.js": "5b071c0febc368bf7f572185224ccf0b",
"main.dart.js_278.part.js": "2d9d711d0dd63837f2f3e1af7f79ebfd",
"main.dart.js_217.part.js": "a14d95487c2363feb017f8eb6773e235",
"main.dart.js_298.part.js": "fd74884198f7a1ab89ccd51b1c588fe6",
"main.dart.js_209.part.js": "c9c04c076015a689e9b9c406ea7a2d1b",
"main.dart.js_252.part.js": "e1dc8c79ea337fb1bb9f17288d8fc511",
"main.dart.js_223.part.js": "0f54cf72dbb63c915eefaa5970378229",
"main.dart.js_226.part.js": "bc65b9bb8811ebf24e2106ef6203db76",
"main.dart.js_299.part.js": "b917b390a92c1fceb766d5c974f54262",
"main.dart.js_279.part.js": "8113e11d0d7faa9b1b40bf5cf9903fa3",
"main.dart.js_16.part.js": "46ac02356155b41a9113ddea5b5e38ac",
"main.dart.js_248.part.js": "0de789b3440ddbc428a40428c4d46d1c",
"main.dart.js_286.part.js": "ed57ec40c56d640f779499ff422e2bde",
"main.dart.js_249.part.js": "b93d111551b2d4bd717623c7688123df",
"main.dart.js": "bf337d89da5f6145cac819748bc97995",
"main.dart.js_253.part.js": "fa2b90443afa563a4cab33c9f3d80df2",
"main.dart.js_296.part.js": "0275a7523773fc826e9ca2ab86ceb4db",
"main.dart.js_258.part.js": "088215dfd8d2c705d284f77034c580d8",
"main.dart.js_1.part.js": "e0c5b1d00785d03d7cd84e246da14b9d",
"main.dart.js_196.part.js": "fde51a1ac2cb6276411503b2c056bbad",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_276.part.js": "df99c7a8fa013959264bb65a4692681f",
"main.dart.js_264.part.js": "ad58dfacc0286c0c8ad0469395149b2c",
"main.dart.js_238.part.js": "3c91fa3de1ac07785578d8d07119b183",
"main.dart.js_265.part.js": "31edcd9ca0aba100d39c96aee91304e0",
"main.dart.js_291.part.js": "3bee3102f62ac643291e28c60392416d",
"index.html": "58a60e7fac32178aaa869403f15dfa47",
"/": "58a60e7fac32178aaa869403f15dfa47",
"main.dart.js_297.part.js": "5007e20977aff98aa86151b89ec16e8a",
"main.dart.js_294.part.js": "6c32b642e8872c55207d59870ffc32a2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "7a7872ced50320da590a9ffc7fd1ee63",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "cf7caadbb53304776ac19f9f6a25273e",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"main.dart.js_267.part.js": "17863454c34fd0eca8166c9e9c35f129",
"main.dart.js_280.part.js": "26c8a961def01d1b4eafc28fcaad838a",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_283.part.js": "621c99631e2d508efe89b6ca63a10aa5",
"main.dart.js_234.part.js": "bdcaf89a72ff8b6b3ad179cd1e64c8b1",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_285.part.js": "906eacfb9ce3bbb56033566955d47d83",
"main.dart.js_246.part.js": "a88f4e3ec11891b24a38f47c47431ca6",
"main.dart.js_277.part.js": "c5b66869020891aefb68d5fcb700a041",
"main.dart.js_284.part.js": "43e4131e4bdc71ae185cc9f0687e811d",
"main.dart.js_244.part.js": "42a16c4c3f2655ce091a8e84cdb64396",
"main.dart.js_300.part.js": "79bef22c0e303864171656443d8b6fe6",
"main.dart.js_236.part.js": "06dc689a1f554f7ca9531555bfe8e9e1",
"main.dart.js_274.part.js": "b4f08d3844477dc4798d105489fd3373",
"main.dart.js_208.part.js": "b0f8a6349336a14c200bd1297981e218",
"flutter_bootstrap.js": "29b2e69a35fada483125dfa146eafa94",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_207.part.js": "06f6bc54d90a788bac8ab871967eb8c1",
"main.dart.js_301.part.js": "fcc9ac2bd9bb51acaeaf7e26224f2e96",
"main.dart.js_272.part.js": "d36d2da25c9eeadd3817e5787b73a70b",
"main.dart.js_292.part.js": "3110f4e43a260d0b160fc2390dd804c9",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_247.part.js": "f02ca44d2c7c22f1b19c5ec342a89fb6",
"main.dart.js_256.part.js": "0dd4370c57e67871a99b34f3d61c5286",
"main.dart.js_257.part.js": "ba907bc8b7b953b64c7b0ca197dc3c6e",
"main.dart.js_235.part.js": "21c6bd31b0bd6ad728861706cc39724f",
"main.dart.js_290.part.js": "4f76dd5ccbcc2b76d599c9721a7e8ec8"};
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
