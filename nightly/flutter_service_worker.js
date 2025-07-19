'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "19710b38cb2bf6759b3a2057658b6be9",
"main.dart.js_312.part.js": "38588a4c8cba3834c71b2ad422b257b6",
"main.dart.js_268.part.js": "a3927c1365b2ee993497c863c1c9574d",
"main.dart.js_273.part.js": "f58a93ebc1acf6fd392f6f21564ece93",
"main.dart.js_293.part.js": "d013255b16723bc58d69409888932f5d",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "20f15e2f6289e057c18b065972238efd",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "fe0c785d312fb45e94c776ee134bd606",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "dc6ab5795c11c20063a70cb9e528ee47",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_295.part.js": "f92d7db991d4f1d9aa9941ae9964ae11",
"main.dart.js_245.part.js": "e53d8b091cf2a2ea5b8ee32ba5aa0124",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "0edbf6f87367535de934e0f66f74280b",
"main.dart.js_302.part.js": "ad499927c6c03d981b6e880562866058",
"main.dart.js_320.part.js": "819732fe970ac4346cb2308733f98bef",
"main.dart.js_321.part.js": "75d58c8f92f92d11310ecc84f25a38b2",
"main.dart.js_255.part.js": "923eb042ef35aa82586e6d62f0a7775e",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "94b709d5676503651731540dc3744268",
"main.dart.js_228.part.js": "cda9db3fe6ac1e0643390bd08fb62f2b",
"main.dart.js_298.part.js": "b8b4bc29e676b2623b76462c2cc28e29",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "d1fa9b3a0833e1177344e9f5b188219e",
"main.dart.js_277.part.js": "a40025bdd5fdaeaaf69d4878e216e4a9",
"main.dart.js_227.part.js": "9b023fb2e845cd10c858dfffbb85b9a2",
"main.dart.js_254.part.js": "230903aded36141d94af69ccfb4c3d8a",
"main.dart.js_279.part.js": "eeaab6e7e08195419adfe541c9aca8cb",
"main.dart.js_305.part.js": "72b56464450dd437245bb265a3e2500f",
"flutter_bootstrap.js": "c249861d8934dc05b52add7c6c88133c",
"main.dart.js_267.part.js": "bbc8b8298517a08f94bf87745c959605",
"main.dart.js_319.part.js": "68c2999f6749e584b5fcbb48153c8a0b",
"main.dart.js_213.part.js": "615e8e65e8c67eaaf67fc413e46bdf81",
"main.dart.js_236.part.js": "4e3ee75048073749ab9cb3d7019632d2",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_210.part.js": "2cb2f6dd7b0baed6518ccba05346c201",
"main.dart.js_323.part.js": "302875f6774060bdc443ba2ef541bb3b",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "03ab1505f07e7d3af7dbd35f16a3238d",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "c0c24843b9ee41207693c61bb4eff457",
"/": "c0c24843b9ee41207693c61bb4eff457",
"main.dart.js_299.part.js": "9aff7cd5e09e6bc33c46787701dbc9b6",
"main.dart.js_242.part.js": "f32bc59657ea19b9c34ea09a07285ce1",
"main.dart.js_301.part.js": "5f894a71e70db7e42b449cc5ba3e4ce6",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "f86a08bc6531f0c09d16743af466228f",
"main.dart.js_317.part.js": "f578a75198c5606f993835c8c1ccc832",
"main.dart.js_286.part.js": "65d4d61c607fc5cbd668664880678afa",
"main.dart.js_307.part.js": "e99308a951e218f642e46117e223c73d",
"main.dart.js_269.part.js": "3449d13bbcbfcb354e66f484dfccc76a",
"main.dart.js_263.part.js": "d60d5930db095d4ba422a5c326caf701",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "e7da7c447b226c4c0d1a9cde2645f673",
"main.dart.js_226.part.js": "761ddbd46825b5061fd478f62d753a94",
"main.dart.js_261.part.js": "f9dcd4d3564d99522049620fef580bef",
"main.dart.js_303.part.js": "e048d0dff3bb065b982af2eadde4df58",
"main.dart.js_1.part.js": "1950300a77712e86c98c66473d50a494",
"main.dart.js_285.part.js": "0618683ed334069808a865022fb015bd",
"main.dart.js_313.part.js": "85708b081b2aac713c8b430a0f2fd99d",
"main.dart.js_318.part.js": "5c9ee11307813c88076436e232acd969",
"main.dart.js_265.part.js": "afbcc11015819f1a75fa7a2e3ba538e9",
"main.dart.js_314.part.js": "37efeffcffa80c60921aefb40a2cdcbe",
"main.dart.js_274.part.js": "3cb285d4ac2d59b63da9ca04ffa77f04",
"main.dart.js_316.part.js": "152c1829ff26a40cd01bcb13391d6b6e",
"main.dart.js_278.part.js": "a1e4233e203b5fada1a29e710bc32f30",
"main.dart.js": "c3c5f39e8de8473e94b50840a1835928",
"main.dart.js_257.part.js": "03e0ce8684104733307ca780f55feda3"};
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
