'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_318.part.js": "e5781f8428d561a977a235bfc71ee663",
"main.dart.js_303.part.js": "caa5c832db06337827d48d49437e176c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_289.part.js": "b7aea995b1331a478585621a6b385e7f",
"main.dart.js_320.part.js": "564842e5c1206c791b01fd3eac1608b4",
"main.dart.js_246.part.js": "49e7bf1c4be80ac5f2ad4f9dc69459aa",
"flutter_bootstrap.js": "a08d78a4d58e76b92e1e718df146444a",
"main.dart.js_211.part.js": "73b609b61e82f3c352e5a3da721d4af9",
"main.dart.js_274.part.js": "58d0600cde6cd7d9df6bb0ef5d7a3d36",
"main.dart.js_275.part.js": "2fff749dac186405b13459ba46230ac5",
"main.dart.js_254.part.js": "6829e9848bc9a5f6196bea7e9c553e4a",
"main.dart.js_269.part.js": "b926cc2935091e7bdb475f0b3ce82d82",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_16.part.js": "1bc8347b9f43bf8d0818da10f2e4fc79",
"main.dart.js_315.part.js": "b1ee425a40816361cf39b72b2a676d71",
"main.dart.js_301.part.js": "4215645d55fe7cdf7a97fd5187461463",
"main.dart.js_299.part.js": "13ced67eefef2516705cfd139e6f2f62",
"main.dart.js_237.part.js": "e40357e899e7e4ba2e1560c8e97c969e",
"main.dart.js_306.part.js": "9f498107dc7312e95a5e5f17d491bf41",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_229.part.js": "db7b0ad3469b121bb47fd6d1037c582d",
"main.dart.js_214.part.js": "3b488ec4f74bd74ad219a82582e87b02",
"main.dart.js_302.part.js": "3f203cbc5c9157f60cb0df987e40bfca",
"main.dart.js_321.part.js": "88bcdaeb5ce7a608791e395c8f1aa0f5",
"main.dart.js_307.part.js": "88b4705d5731ba5ce2cfdebaaff24cd5",
"main.dart.js_314.part.js": "53a7442edb5afcc0af9c76d568fdb5d5",
"main.dart.js_243.part.js": "0011660a174ad239ecfce2d042b5dbcd",
"main.dart.js_2.part.js": "611010805dcb56081c8408ef9b74dbd0",
"version.json": "c39aee0353c6ad9b93e18f82170c8248",
"main.dart.js_258.part.js": "7c3d6815bf2ff7bfc93e9424184c8f71",
"main.dart.js_256.part.js": "a323f8491c64a436c6f2cfc6ad2576fe",
"main.dart.js_270.part.js": "080333e758a6138f314140ddfe388262",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_313.part.js": "6c9aad8501e182da9ad10cd0484c512d",
"main.dart.js_268.part.js": "ea3738f86992d702d159327c90545ff6",
"main.dart.js_308.part.js": "a5a0239d26a2cc7dc513b8e5e6397321",
"main.dart.js_278.part.js": "874900d4513671c58920e0f05e1ed332",
"main.dart.js_266.part.js": "3c5b66559c9bab3802a06e1068bd1889",
"main.dart.js_1.part.js": "5f181dad06cc4faa9cc5ee4112c7eff8",
"main.dart.js_296.part.js": "37832b5332bd2e33c75faccc31e87593",
"main.dart.js_323.part.js": "93541932059b5afe5b9edd4c0dd0adfa",
"main.dart.js_279.part.js": "23f8abb4f80092dbed47e5ea08aa3701",
"main.dart.js_226.part.js": "57edd293e0427b1f387456065d2ab354",
"main.dart.js_255.part.js": "b83bbeed788ed0801d39e5951b00c625",
"main.dart.js": "1ded55ede79a4c2d8b90ff647be76773",
"main.dart.js_304.part.js": "837d02bc95c807234cae8aed7d789c25",
"main.dart.js_286.part.js": "0a6bd235f9faebb52966dd25a73cb09b",
"main.dart.js_322.part.js": "8207464251894d0e3622c455f3b0c8b9",
"main.dart.js_287.part.js": "2f303275e23b3016f70dec842781371d",
"main.dart.js_294.part.js": "aa843af5c481a7f2972dedc80333bbc4",
"main.dart.js_262.part.js": "b3be8a267b2bac4076d3ab5980d31403",
"main.dart.js_309.part.js": "627791381b2d3b950fbcf22f0d0f881b",
"main.dart.js_280.part.js": "57cf3a3a88b98598287ee104641f68bb",
"main.dart.js_300.part.js": "bbab61b57ba2e6c78193c67b075ab437",
"main.dart.js_222.part.js": "dc9a5adcd338b49a7ce561f9acb668ad",
"main.dart.js_324.part.js": "81f363b474964973b93a6e1a5eb4d0de",
"index.html": "3da9560c286cf1275a428048aa4f3e14",
"/": "3da9560c286cf1275a428048aa4f3e14",
"main.dart.js_264.part.js": "15146a5ec2f4f0f6e14fe406e49ace01",
"main.dart.js_319.part.js": "6bd52ba2f4d3e170acd07d5ba1ec7e1e",
"main.dart.js_317.part.js": "76e7d1f72ed2cb6749509df48d69cc63",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "a3f123b040698ff8aa5ead1d8d3815c0",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "f36e7116b9559e2d9818f2d618f22579",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "df30bd858f70b0a2036ac27eb3e911a2",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83"};
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
