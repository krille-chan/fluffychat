'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "0ea866511988df03a8b004550cfac48c",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "4d2d3ed20d5a6124ab6285431b48c432",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "d0c4552d4c56d16f0410a8914b56ab10",
"main.dart.js_274.part.js": "cecdd185a43ac0bce442ede051286a2a",
"main.dart.js_219.part.js": "92655d5cd08c8038df48921d9f0c38ae",
"main.dart.js_205.part.js": "17e42c28deef4e7900737719b72cbebc",
"main.dart.js_276.part.js": "995bab6eb27de3e4c05c1c2ce61659ab",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "de254e8310cd528166352c23dbbcdc35",
"main.dart.js_262.part.js": "11ee16a316e51b372495cb07006a09ce",
"main.dart.js_1.part.js": "74453acbbdc53d79ffc2170ceb86ed57",
"main.dart.js_243.part.js": "8bed9fc8e3f28e30652a9522dffa52b7",
"main.dart.js_275.part.js": "d0051041e4d623dca7f835f9bee8791b",
"main.dart.js_231.part.js": "b80c74cf09f7c5bc69de4557fb583630",
"main.dart.js_269.part.js": "83dfbb5fb12d38ef87a70d54f285929e",
"main.dart.js_298.part.js": "2b94a3cb96728b67326f1a47c4ca76fb",
"main.dart.js_240.part.js": "b540b4cb0222918aecf24e07434dd236",
"main.dart.js_242.part.js": "d823606d322e6fec81c5c7ff0a497498",
"main.dart.js_283.part.js": "4dd1442cb2780b25bfb8ed95de0089da",
"main.dart.js_293.part.js": "a9f1a388ea12f6757c9839f9957a3b57",
"main.dart.js_277.part.js": "25acd923f9b43be55a7e549c20f1abb1",
"main.dart.js_213.part.js": "ee747b1cb1b27aa5fb852f0cd38e1ba9",
"main.dart.js_248.part.js": "c2d4447f71d09b26a3e3dfac9077864d",
"main.dart.js_289.part.js": "d43e43a5327513d3db60e8a2db2b7af4",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "2daaebd54a0e806176d3528f3fcef638",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "a2b8b206ff557fcd7dfd7024655550d7",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "0a20ff924c57b9c2c7cbfcbb558e7a33",
"main.dart.js_297.part.js": "ccc72bfa3001dd4ed7f424bf66052bc7",
"main.dart.js_192.part.js": "1e071107d631507f6eeb5fb984cf33b0",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_282.part.js": "8ffeb8e8f4b7a6a75ac767fde5c7968a",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "e51a672067dbdad8ef16cdb7401027a3",
"main.dart.js_230.part.js": "e010ebcbf4d6b9bfd4bde70ca598e23a",
"main.dart.js_238.part.js": "4cd95c6b63aa8fefe237f9b3b7bea9d3",
"main.dart.js_253.part.js": "8dac2979f416899b5a0920f2a7e44f68",
"main.dart.js_244.part.js": "a5d5814d6f714a4b2a8f6a1137d0beff",
"main.dart.js_16.part.js": "d209c84783b10f906750eaa2f8817434",
"main.dart.js_294.part.js": "d52cdffec67eadead93f900f996580c2",
"index.html": "6d129ed2d529cdb14309e14971065d71",
"/": "6d129ed2d529cdb14309e14971065d71",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "73e42db59b8efd6dac43c68842151aaf",
"main.dart.js_245.part.js": "9d9ffdd8cbfc0b5ca62ebb7203267c25",
"main.dart.js_291.part.js": "c95ac35deb643febacc6d75765038757",
"main.dart.js_287.part.js": "69d121f2a566c2579d54317d7ff1af28",
"main.dart.js_233.part.js": "2503ae135adfce9281d90f880d141b91",
"main.dart.js_273.part.js": "cdb571781bdcccc2b52446e481ebe65c",
"main.dart.js_296.part.js": "0b513dcad3091a46cb3cb435c51cd3fd",
"main.dart.js_278.part.js": "ba475b77d15663fc5027dc0cf729b1f1",
"main.dart.js_292.part.js": "0f614194a5083bd17178241bc8cb4df8",
"main.dart.js_295.part.js": "2266d15bf9086f6c1985ded9ab3aad35",
"main.dart.js_221.part.js": "b581edcd0768c752643af9680703e93f",
"main.dart.js_288.part.js": "57d75a884a64fbc23bddc04f0ab6fd9f",
"main.dart.js": "06c164bd0a3b0a644735a90f52077b23",
"main.dart.js_280.part.js": "bc15d4e3cb66ef6af197ea51bb6381d6",
"main.dart.js_261.part.js": "dbf5835da8884d967d75e4ea2d97f31a",
"main.dart.js_203.part.js": "6e9699a724ed7246a681db01e2b153b6",
"main.dart.js_254.part.js": "f77c1f27386bcde3f370ac19ab8b5a59",
"main.dart.js_271.part.js": "5155a83d6ccab842aec0070ed6e2f9db",
"main.dart.js_281.part.js": "c2d87aa3a9df163472449d8cacde5eae",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
