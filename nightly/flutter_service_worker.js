'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "0d51739edeaea4944e3decab831d1e59",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "2794c7390c808fe6c91338ed4f3792a1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "70c3c5816079d240752c8f549d92750d",
"main.dart.js_274.part.js": "e25beb4cc997ea3a2981b04ee6e69d75",
"main.dart.js_219.part.js": "040d32296f487071a2cbaa8be5c9fbf6",
"main.dart.js_205.part.js": "df4ee2bf0df474572d530d2750ddf7bc",
"main.dart.js_276.part.js": "0172196191e2a878dba7822ae52dc9d3",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "8f43eede6b79270e18b1c53ea4191517",
"main.dart.js_262.part.js": "ca2e0ddcd7c8ed9b0750240ff3fa15b0",
"main.dart.js_1.part.js": "8b12ce2f30332301ea1986e8743703aa",
"main.dart.js_243.part.js": "5ec6cd78730d2a541eb629492ac75cee",
"main.dart.js_275.part.js": "600755592463fe2518f6d3edc2b4a391",
"main.dart.js_231.part.js": "57ccfdabfb96ae8d41915c17dafd0a7d",
"main.dart.js_269.part.js": "e040213476c0153e1cf5b2c24e583467",
"main.dart.js_298.part.js": "e35094ae76ca09c919c868facbcd0bb2",
"main.dart.js_240.part.js": "f6d5c947f700199fa249141a75175f2e",
"main.dart.js_242.part.js": "9f19ed39806a44d55491bd08b16da253",
"main.dart.js_283.part.js": "3a81562b1acbc643bca1c7f0a53db845",
"main.dart.js_293.part.js": "fa179a18f5d948e6711c26872323012d",
"main.dart.js_277.part.js": "e061828ddb6c05e3ca0fa475a9a674c5",
"main.dart.js_213.part.js": "881e043b70dd938d80d82de8911335c0",
"main.dart.js_248.part.js": "c5fa40670a57c95cf6d3f811a33b6ec8",
"main.dart.js_289.part.js": "149d83c6ceb0e503239ff9393799d3bb",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "0f73bdbc3eb9e9032a2a319f3942ff0a",
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
"main.dart.js_204.part.js": "27a23cde6614f994c2ce91be1372f688",
"main.dart.js_297.part.js": "2eac0e156e33e885bb6cc1fea464324a",
"main.dart.js_192.part.js": "ba3ae35647ac53771dc1f24967411ba4",
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
"main.dart.js_282.part.js": "05fd32b80ebd0632f2afe93ed84215a7",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "a8817508c07261503d2f4bb6f611f6bd",
"main.dart.js_230.part.js": "16917f70cd0b627f5a0053dd5b1d627c",
"main.dart.js_238.part.js": "ba15f4f416d7fe2d953ad318886b5a09",
"main.dart.js_253.part.js": "24e6099126960158479d0a94cd639c31",
"main.dart.js_244.part.js": "25aa0ea25d51a36697d55cfa8d24f2fe",
"main.dart.js_16.part.js": "9bf923b5d27daca9526a9f8d6f6186ad",
"main.dart.js_294.part.js": "9dd1b7d3a06ee08cfc8c6ced602241af",
"index.html": "8e7df14f3d17bba6fcccc99a1f8b4455",
"/": "8e7df14f3d17bba6fcccc99a1f8b4455",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "c815e7edfa17ceaa1742a1c150d52035",
"main.dart.js_245.part.js": "82ff6c8655d16c76af5184e613e02967",
"main.dart.js_291.part.js": "99a705a04ac5dbfd926abf515f6333f1",
"main.dart.js_287.part.js": "de4293337dcad76254889b2d024f3a4a",
"main.dart.js_233.part.js": "dbed28d345418edc6af6ce5a6c3cba2b",
"main.dart.js_273.part.js": "04c45d70b511a88ab4e62200facf778e",
"main.dart.js_296.part.js": "562e8f0440af0ec7ea8f8b6d007c5ac1",
"main.dart.js_278.part.js": "62abcd84bd9972a3192ed2dd6196e0b0",
"main.dart.js_292.part.js": "b9810e05be662d0e15fd273411032066",
"main.dart.js_295.part.js": "d5a72a30092381433f99830d51af029b",
"main.dart.js_221.part.js": "e465376de599098305fc46d3bb6eafa1",
"main.dart.js_288.part.js": "1ecdeb3818e359d6ff0cebecae9dd4f0",
"main.dart.js": "3d72b1e6af1335e2adda4848a851a5bc",
"main.dart.js_280.part.js": "9fa7412bbf7fd7322c22df297d1a8cd4",
"main.dart.js_261.part.js": "15676ae6ff99195acd430406e40a8ac6",
"main.dart.js_203.part.js": "58bef05e2b0a14276a1f76e76e21933b",
"main.dart.js_254.part.js": "741100f658365397947e9834ae928819",
"main.dart.js_271.part.js": "d8ea08416535209c844271e58be28a74",
"main.dart.js_281.part.js": "d8a2b76817299e2f4906ff0cd572d5cd",
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
