'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "feb6291ddc72179d30303344406eec47",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "f257ed66e196acd1c1af2b1d56a1762a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "f3fa4fabd6eae5b82bbec0522d672b1d",
"main.dart.js_274.part.js": "559b88a772bfcf52c7f7fece48f796c6",
"main.dart.js_219.part.js": "1d44cfaa6c570ba85bb8fa3272341194",
"main.dart.js_205.part.js": "532f333a71904d4452239168478c3a94",
"main.dart.js_276.part.js": "1d9ee90c74a508854bcb4aadf03532f6",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "5ddccff12e900036f146963e6ad3caef",
"main.dart.js_262.part.js": "f081df1c397ea829cabd0271f0d4b450",
"main.dart.js_1.part.js": "8082fda831b3ad77dd5f8381c388767d",
"main.dart.js_243.part.js": "4a5e8e9b89999e5f9f8c548e62e52479",
"main.dart.js_275.part.js": "a9bd82402927bcbf1856f673e7e6c228",
"main.dart.js_231.part.js": "351a2a3e526846a882f3cf7ead202745",
"main.dart.js_269.part.js": "4a3b64283e9c405c547624301cc22205",
"main.dart.js_298.part.js": "dcb4e17b649404020c34019542fe90db",
"main.dart.js_240.part.js": "ea5435752fd834eebf8ca47265d3d8db",
"main.dart.js_242.part.js": "4a5b980f7c3605a1d4c936d6a92954fa",
"main.dart.js_283.part.js": "e513059a7e969413100b21a99ef7b94c",
"main.dart.js_293.part.js": "dd76141b9e0c7ab1a8277dabe8d0f28d",
"main.dart.js_277.part.js": "17db0591f69208bbe4a903aa38ea676e",
"main.dart.js_213.part.js": "d5a56944286d4b80a90d0060c7033e9f",
"main.dart.js_248.part.js": "241339bdf8cb5d42d3783b36dc426520",
"main.dart.js_289.part.js": "814642020bf58c52f448d60ac8a8e5b4",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "9f403d9ebbf73d19e2de4d0a513ffd3a",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "32c9cd80c12f18995ca50cd247a0e0db",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e3c4ff4cebe742cd5e83688287a0447a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "d7ea4452b8793b9c8b1496cf0272c48e",
"main.dart.js_297.part.js": "88bfb36ab661a03901bda7deb4aeb9ff",
"main.dart.js_192.part.js": "08bcbc891104edcc0ee5419f7cd1cfc9",
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
"main.dart.js_282.part.js": "2a626e4c8e245b0982ccc6ddcd4e6252",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "756eee37ece38acb65f93f624c924e43",
"main.dart.js_230.part.js": "1266e7bbb7976b61ebdd4f43116942db",
"main.dart.js_238.part.js": "b589441c64a02e5e7a1183e3b43f1f75",
"main.dart.js_253.part.js": "083c400402d9beda5361cde7da26c624",
"main.dart.js_244.part.js": "397b7262ec1774b7cb771bd0809caa6e",
"main.dart.js_16.part.js": "900d7ea4259257bb577312c9c853756f",
"main.dart.js_294.part.js": "c1c395aa2b1abccf154590dc226894d0",
"index.html": "247d34fd6202050e2968d8c61c87c08e",
"/": "247d34fd6202050e2968d8c61c87c08e",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "0d4f819a2fb4bc272de187b83572259f",
"main.dart.js_245.part.js": "403aa8a8f816305548bbba395225ba8d",
"main.dart.js_291.part.js": "b92dc5414d54a87c3b6fe751e2bc0e4b",
"main.dart.js_287.part.js": "6c57ecce4a86dc3b03db0a4f5033cdfc",
"main.dart.js_233.part.js": "9b5a5b39b5ebd7cdcd81a310786f343f",
"main.dart.js_273.part.js": "4fbd85eaa8f4fb3a792f24e57f45519b",
"main.dart.js_296.part.js": "bc6118c11e3b4516c8c176ef99154bd7",
"main.dart.js_278.part.js": "2971db75d89b6f100fd918e29c1f046e",
"main.dart.js_292.part.js": "3852f6a16da10488587d1f091419f515",
"main.dart.js_295.part.js": "95a32c90aed4169faaebde94b269cd98",
"main.dart.js_221.part.js": "cc050dadb97ccfc7549b0432be80f664",
"main.dart.js_288.part.js": "d117ca691cd0f560c708a4a636ad53f7",
"main.dart.js": "47c635075683e46d91f85552d9dd46d6",
"main.dart.js_280.part.js": "2b9d9bd6527d44f1a0f7553be097936e",
"main.dart.js_261.part.js": "01b9f0eeed0975021436d741ef4d0af7",
"main.dart.js_203.part.js": "fd2c96cbf49af55321541e0d509773e1",
"main.dart.js_254.part.js": "ef7efdd6656073ed139b35c0cc712b9e",
"main.dart.js_271.part.js": "1a9c8617277f5bdf097f4fb7106a510a",
"main.dart.js_281.part.js": "c937e9d51f3ed337f6bc42731fd0c6de",
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
