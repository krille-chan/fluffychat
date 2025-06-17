'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "93e72d5fd69ed578757e6db453c245d2",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "916c738c3d053fce450b53af92b6f546",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "1a539bb85504577bcc21df5442d3dcae",
"main.dart.js_274.part.js": "e5b204ef3557c663a70f4cf17e6bfe22",
"main.dart.js_219.part.js": "a1581789a007747cda9fe604f9f5ec8f",
"main.dart.js_205.part.js": "27f2268bccc7d08ef94277b459cbb195",
"main.dart.js_276.part.js": "4a8d91bac564fdbcfca51aa70106f61e",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "daf59e261cc904080e836a7fe753e08d",
"main.dart.js_262.part.js": "d45bed8f5c1e1b8e12c30aca51e2504d",
"main.dart.js_1.part.js": "3c57fd7dae8f3b8a94466573d88ca954",
"main.dart.js_243.part.js": "4ac5e452ec81e97e57d892f3639f3878",
"main.dart.js_275.part.js": "69bdfb94fdb5f4e60dd8897c2c8cf129",
"main.dart.js_231.part.js": "7ff848c276db7d35a61834b564b37299",
"main.dart.js_269.part.js": "951d7f5f78382615169a4fbc49177fc7",
"main.dart.js_298.part.js": "a317c4996f3b7170dd0000f002200616",
"main.dart.js_240.part.js": "3742ef6bcd57d5c32278b8c51af6e76f",
"main.dart.js_242.part.js": "b0b96aae547560c66a5d09afbe983b74",
"main.dart.js_283.part.js": "16eebf7a7848f91a41e4002fc5531183",
"main.dart.js_293.part.js": "64652087a8fe5d71c4e65b3ea872d050",
"main.dart.js_277.part.js": "b4587a139ec3dc9d8e66adbacce3fdec",
"main.dart.js_213.part.js": "84a80a40f57ad3ad1b4cc2cc4c4283e9",
"main.dart.js_248.part.js": "6689e76c9d6d71602e7d2a0ea15304bf",
"main.dart.js_289.part.js": "317f0bd8410f8e7995ec989c7dcbde8a",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "47fcff284f4b42ce3a0a9df8e0a61862",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e3c4ff4cebe742cd5e83688287a0447a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "2357c2d679d910aa1ce582600deeab4b",
"main.dart.js_297.part.js": "a930ff7aa0f70a9d944bbc0753827b8f",
"main.dart.js_192.part.js": "aa91e3a8e2a268b0dd1afa6b31c2dc97",
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
"main.dart.js_282.part.js": "530c6a8f53232c35fae54ea86924e589",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "b5170ff01cccc76e1b09dd1fd7a9f04a",
"main.dart.js_230.part.js": "eff2d8b53d85370ec3198be7fb796aad",
"main.dart.js_238.part.js": "35a01bb4f98dc1ecd7198f87f4b10132",
"main.dart.js_253.part.js": "f55bcbdf1f66e84a61eb36ad59492427",
"main.dart.js_244.part.js": "a3a9c22d2170424e2832f43c1aa45cb3",
"main.dart.js_16.part.js": "50657d2dfa0e4620093f8f467d32a169",
"main.dart.js_294.part.js": "f8fe4397d8d5e0deee5cf576bf3ed7c6",
"index.html": "14fbd18eeb7115b6c08dad9b3d0110b1",
"/": "14fbd18eeb7115b6c08dad9b3d0110b1",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "fa582bb8e1451d53fc3ce705f77c84f9",
"main.dart.js_245.part.js": "4a9a0ad51178b316a4508b1881e223fe",
"main.dart.js_291.part.js": "b45c12de7ce7d881c996cfaadd1c8b26",
"main.dart.js_287.part.js": "f73223022db2fe3a8bd22c00cc6f2727",
"main.dart.js_233.part.js": "cc7b8cca5965a47fc5ee0be2bc3e952d",
"main.dart.js_273.part.js": "e872dafed73fa4eb046e9f58d27c9339",
"main.dart.js_296.part.js": "5a62063c9418c9ca74ae4e56107f33e6",
"main.dart.js_278.part.js": "bfe1421a299d8f997ad4661a9ee78cf9",
"main.dart.js_292.part.js": "e83cee9ba31f840068af97e9aed9be72",
"main.dart.js_295.part.js": "37f601681cb092781854160c08de1a4d",
"main.dart.js_221.part.js": "5be446b391da858d199743454e560d07",
"main.dart.js_288.part.js": "609a4acb8f563c5bddb166b4cd34c558",
"main.dart.js": "b4ed326b1609437f389cf5714c14fec4",
"main.dart.js_280.part.js": "dc588ed07be5807bdda8aa3104e1726f",
"main.dart.js_261.part.js": "782960897000bf53f31eb16fede11fce",
"main.dart.js_203.part.js": "20efbccaf35c787402e3abdbb7c3380c",
"main.dart.js_254.part.js": "472f03472b072fe61b800930dae19da5",
"main.dart.js_271.part.js": "cb3e02feba9270beb60c2b6492ba8439",
"main.dart.js_281.part.js": "ee5ed7981a663993f99b7006bb84fad5",
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
