'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "3d54cff5213fab443958ca104ac18902",
"main.dart.js_300.part.js": "15cc62d9e0eff023aa5ec12311967427",
"main.dart.js_280.part.js": "d1dc7ca4f93875fe12f7338e979eeb6d",
"main.dart.js_324.part.js": "240ec5daf22bddaf2c7ec775f8a95d8e",
"main.dart.js_301.part.js": "3c2074b80aa7daca60c3db614b0b93b8",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"main.dart.js_308.part.js": "fc1dbc7f5e59b32dddcdb89a841ccc78",
"main.dart.js_287.part.js": "beb511942f4abbee87bf02df023d4e94",
"main.dart.js_275.part.js": "2f4e26ccb441e7317729ce430cebff54",
"main.dart.js_303.part.js": "b0b4f7886121550f75939f7401bf7117",
"main.dart.js_319.part.js": "be6fb3411673584efb0a6b323a90b4e2",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_237.part.js": "ad71c14c54c12064ace020199964f5b2",
"main.dart.js_279.part.js": "25bf106ae6c06808754c1ef9d72e005b",
"main.dart.js_289.part.js": "d1884066917ccc0fd78812f3be964cf1",
"main.dart.js_302.part.js": "0fb43b7e14581abd21674608ec70262f",
"main.dart.js_269.part.js": "a5e12a966673bb8a1a6ac50f72995fab",
"main.dart.js_229.part.js": "31c84facecbf9f5dea19be92483ae9ce",
"main.dart.js_304.part.js": "fd1a8af6681b65b4319ee2b05dafb581",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_318.part.js": "cac896290957b2224b35a91a6e2a6d4c",
"main.dart.js_2.part.js": "03c5d270d9d4b62908af9ba7d5cf173f",
"main.dart.js_254.part.js": "bf488a3b45e923b2fac6f1b9d876108f",
"main.dart.js_296.part.js": "ae5690a5422375386cc5cc56ae0f5b94",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_270.part.js": "5058d4e3e0b125943c404cc120faa4fd",
"main.dart.js": "16f806f35830abcfd9da23684a396665",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "3859fb2e690574776f552db2851f2740",
"main.dart.js_246.part.js": "635fa75477022adf397df0c49156b0cb",
"main.dart.js_1.part.js": "f629fc9aa31a05a8a3b32badf76715e1",
"main.dart.js_211.part.js": "2af9fd3d810c92fb3b187931a05863fb",
"main.dart.js_294.part.js": "414beb67e9a73c53f42d3439d3a86680",
"main.dart.js_320.part.js": "8c34dd280473ac38c9e8ffbc4f48ed6a",
"main.dart.js_313.part.js": "761d567e2f22e6dfeef22cdde76d16f8",
"assets/NOTICES": "9091b0748a4463eef59c8e796100439e",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "1863079dcac82d0ac0952299381dcde6",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "a2ac1616dab66652fb718650d2b38681",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "1daae37c47b0f0e45e6c1da7f0962518",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_214.part.js": "42c48ac31f13d63c6c30e7ac65e1b024",
"main.dart.js_264.part.js": "a3081be6cf9d89b0f79cbdfc833ac1f2",
"main.dart.js_321.part.js": "3949d300c1dc0758a6e83bc275994486",
"main.dart.js_286.part.js": "d7f95bd0b3987b03926349a019088b36",
"main.dart.js_256.part.js": "79a01cc2d09d98cc8d80efdcc61395b4",
"main.dart.js_268.part.js": "979845dff9e68426e7b29e5123f33625",
"main.dart.js_255.part.js": "d981d020c05c9a3abb70dab40ec4970a",
"main.dart.js_226.part.js": "70d67441a3e39a81771f7fd989c2377e",
"main.dart.js_266.part.js": "75a6cf5a0cf4bb6740c9f5d9a85bf2d4",
"main.dart.js_278.part.js": "132b38e96b3765c5568306c4e0e3a230",
"main.dart.js_323.part.js": "d56a5de91d7648d5deffbe21286b5b50",
"main.dart.js_299.part.js": "c9e972cd88fc78633b4e994734774acd",
"main.dart.js_16.part.js": "4dbe029fdef6a6ad87b97c6cc8b01c85",
"main.dart.js_222.part.js": "579e0945c0e87fad45fa43a276574285",
"main.dart.js_243.part.js": "17d4f8f6859b5af390f70df7a4e89ee0",
"main.dart.js_322.part.js": "a55235f2e7af76cc140399c74f83c626",
"main.dart.js_258.part.js": "7d0c53ba5684ed10acf9b3da72fd36f8",
"main.dart.js_307.part.js": "4e55d487a95967837450310f5f86cc35",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "4e6828508664eb07659cd584e3b39f30",
"/": "4e6828508664eb07659cd584e3b39f30",
"main.dart.js_315.part.js": "efb2dd08c0abc84833ea5a4676c9d1d7",
"main.dart.js_306.part.js": "4ded728f2710464f02287074a2b64fa9",
"main.dart.js_317.part.js": "d59752d0233033a155e4c2ce59bc01a9",
"main.dart.js_262.part.js": "f467ba17bc34d9e35817d3e1f931b111",
"main.dart.js_309.part.js": "75bc8e744b9eb050561590bbd8e68572"};
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
