'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_290.part.js": "d1d21d5274d4cfbe5858a6348d9b0745",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_206.part.js": "7ef71475fe2b17ab26a32d32364b2738",
"main.dart.js_249.part.js": "d9446c7fa813354f541f3340a28b2c9e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "98b22036387c26594df6be5ec2ee01f6",
"main.dart.js_205.part.js": "d2ebdeec5d4bb4f798dcfe0da95d22fa",
"main.dart.js_276.part.js": "017025efd1183918aed2b36b02b77523",
"main.dart.js_220.part.js": "2a2f380f7253678abe723a2e4338f0fe",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_1.part.js": "bef000683508f67e45f4c45c287fcd54",
"main.dart.js_243.part.js": "036c9a8f50c28102aa89c8288b620277",
"main.dart.js_191.part.js": "555551ea12acb4f3aa3ba7c75df4982b",
"main.dart.js_275.part.js": "b1b08919b1ca67f847166a4692e618ce",
"main.dart.js_231.part.js": "e45859478d9c21dfd8a0b4174fd1dd97",
"main.dart.js_270.part.js": "ccc617ac7320421e979470e8f923641b",
"main.dart.js_286.part.js": "5f3f265c927a6e5b976073143b77a213",
"main.dart.js_252.part.js": "3b49c7bc170e1956d6c12d584c62e76b",
"main.dart.js_240.part.js": "666a2e4c3824469e0a1e57911d84c10b",
"main.dart.js_242.part.js": "d0fc307601ca06f686c92f4cf1c9f1ee",
"main.dart.js_293.part.js": "0114a84c09078da8c61c354b76331f2d",
"main.dart.js_277.part.js": "2763d7f88331ac76659bf4360d4ec592",
"main.dart.js_234.part.js": "a35b26a11ab3fc35182ab675fb9aead8",
"main.dart.js_248.part.js": "aa8fe6485c627ac94d6adbf7cd028311",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "bae319e8316fa32d53a234f5fa16f41e",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "21e0477223d4076eca23fe0ab07b9158",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "e81dcf6196b0e4e33e5deb910436f9ab",
"main.dart.js_268.part.js": "d73ca6cf3fcac57e967c1228ea3852f6",
"main.dart.js_297.part.js": "2af0dc4957ffd257f5e60940aa565f8b",
"main.dart.js_193.part.js": "ab37c751fb5f96cd74f915f395baa305",
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
"main.dart.js_272.part.js": "438ee416f7fbae3daf0b612dd6815f19",
"main.dart.js_282.part.js": "f026a006420937922ede2142b20f16ca",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_230.part.js": "a1d8d0233d436d834976d42a0375081f",
"main.dart.js_238.part.js": "22be79cd3657cde4ba3857c12206d858",
"main.dart.js_253.part.js": "305228613fef1c76fc4e2ba660d80f25",
"main.dart.js_244.part.js": "9395200438aa35b75d90b8275abb3cea",
"main.dart.js_16.part.js": "cbb280a9c3d31e884a3c2c00b47c0c47",
"main.dart.js_294.part.js": "14a311a29b20c65cd7114bf8274c686f",
"main.dart.js_260.part.js": "f6425d63a9eef666b0b30dc7fc69afa7",
"index.html": "0d6cebb72956b651d89eb0c9e7e11df1",
"/": "0d6cebb72956b651d89eb0c9e7e11df1",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "6b37b60b89475b79d5818c21c8358452",
"main.dart.js_245.part.js": "163c14b27b6d63f294c5bb6f0f032528",
"main.dart.js_214.part.js": "29d8dfbbbf082d99002d13205d6e898e",
"main.dart.js_291.part.js": "cdc4c6ae1c3b01aea69aff5454555528",
"main.dart.js_287.part.js": "dda8d700219752ca3bf970ee89c0d19e",
"main.dart.js_279.part.js": "3bc1ba9bb84dec374c725bcab1c32179",
"main.dart.js_232.part.js": "df05c7990b243f72cb0060f952696352",
"main.dart.js_273.part.js": "348d5d7208e03fa2ba8de88ea7523372",
"main.dart.js_296.part.js": "018c203c9e9e3f3a7fe1b5b16b7adbea",
"main.dart.js_222.part.js": "6a03b7faf056c9d246eaafe3c642877c",
"main.dart.js_292.part.js": "8501d47170b12aeb10ad7e70ae06b5b9",
"main.dart.js_295.part.js": "d8569b8af6449f3de7301dfac0a8c943",
"main.dart.js_288.part.js": "04f9c0876d2bb087c68aa8087d76e4a6",
"main.dart.js": "3a2b23f5875f9c5e1cef0b9470a08b99",
"main.dart.js_280.part.js": "b322a7992a3b95c4ddd08634a84656b5",
"main.dart.js_261.part.js": "83a44c243d9510a04b20539134e5abcb",
"main.dart.js_254.part.js": "5a43d82ac02d240cb931970c0dd1d565",
"main.dart.js_263.part.js": "27a0efa98fec2844165bf8c428356aa0",
"main.dart.js_281.part.js": "5a4d31ccf43031e06e055b52d3e6cb23",
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
