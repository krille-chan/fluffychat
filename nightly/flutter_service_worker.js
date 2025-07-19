'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "d9a8db603b5fa023a8887962d20fe1cd",
"main.dart.js_312.part.js": "a9514afa4b8bb19cdd35bac0eeb042ec",
"main.dart.js_268.part.js": "09d5bc8ba069d341049987e85644c888",
"main.dart.js_273.part.js": "5c0ebccbf9f3f2f258e8d1ae6f426f6f",
"main.dart.js_293.part.js": "e70a969b9f1ca18eff679b982082e6af",
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
"main.dart.js_295.part.js": "4021ec1585327f0096c608045cb1fa39",
"main.dart.js_245.part.js": "4ad32ed373d6dcdf0516b45bdbce183c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "4b4a75a6fe3b37714327a3ca159964fe",
"main.dart.js_302.part.js": "bdb94d655dc59b6887d70484d9c9bfeb",
"main.dart.js_320.part.js": "aa983fdd5a34c304c90fb988f084b3a6",
"main.dart.js_321.part.js": "9f72dcff1162d83f99f30e4158fb813b",
"main.dart.js_255.part.js": "3a7b190c2f04a122e1ee537af5010239",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "323b21fc7b384dc412a354712ff9c9d4",
"main.dart.js_228.part.js": "7eb11a28d2d1a45660a11addd3920e2d",
"main.dart.js_298.part.js": "2a7118c105f481261aae5f79a00256a1",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "8e2bfff68c2cf2b43d4ff9affd9ad10f",
"main.dart.js_277.part.js": "0f1fb354ae2dd31532055e6efd520f8c",
"main.dart.js_227.part.js": "3a060c1eb64de1442985f4f251b5b215",
"main.dart.js_254.part.js": "b0b998d6ae828aed8bf34973f3be8d7e",
"main.dart.js_279.part.js": "4df6572368aeffe9b5ac8e8589aa4407",
"main.dart.js_305.part.js": "9f125ce6fe57d7aa5390057fe6a4a771",
"flutter_bootstrap.js": "6b19125dbb5a7c4b834ddef11679fc72",
"main.dart.js_267.part.js": "0df98b3d2b03871be2e2f0c50e7f895b",
"main.dart.js_319.part.js": "124ab83c1c90538cd5f1afc7eba65d77",
"main.dart.js_213.part.js": "ac08aa646fdf9b5e2b835b8b2dcb70c1",
"main.dart.js_236.part.js": "6080371ffd6cde2fa0b7deccb59f6bb3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_210.part.js": "44483ac05994c2b7655002cec0f3686b",
"main.dart.js_323.part.js": "fe52e46350e0ce5de77aeb13bab370fb",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "4fa8fda7dcfe5fc5343b948458bb3510",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "83b896f6ebe2f85e828b3715801184b5",
"/": "83b896f6ebe2f85e828b3715801184b5",
"main.dart.js_299.part.js": "ecea7c098ef25db284bcea30159ceb89",
"main.dart.js_242.part.js": "416d2413d93c7714ac035a1669b9d286",
"main.dart.js_301.part.js": "49e7db2b78607737fd18aca238d90f32",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "3cb96615dbfd9dd5b053b47c4a4fc884",
"main.dart.js_317.part.js": "88e779f25781c86d3c21396413ede6b0",
"main.dart.js_286.part.js": "9be1fd9db07ce2173b37e2d733ba7975",
"main.dart.js_307.part.js": "7a6896db1daf0f82b45cdf01468e81d3",
"main.dart.js_269.part.js": "8d029292e20b764cc6eb6abbfdb10fa6",
"main.dart.js_263.part.js": "31989da8cf74a0e060ff55413d7f8fd6",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "d57a3c4360913387aa8c80adf720e00a",
"main.dart.js_226.part.js": "d8c5ce3a47437e77ffb223a9dfcfafb0",
"main.dart.js_261.part.js": "46c3b199a366a821697d1bf03b077e68",
"main.dart.js_303.part.js": "04afd35b79930a6e50884f711845b9d7",
"main.dart.js_1.part.js": "b6e3c48fede72bb763f91cfb92f33590",
"main.dart.js_285.part.js": "338c439b78778adbf3d4153edbb4e89f",
"main.dart.js_313.part.js": "4480e17fa3968fff4f206e50d0f8cf90",
"main.dart.js_318.part.js": "adc813b80c1c1730f58ed65cc9f800d6",
"main.dart.js_265.part.js": "52e5be902a5fead44654e259af931bd9",
"main.dart.js_314.part.js": "6cc04d0acd1966afacb55e2ffc7a0a42",
"main.dart.js_274.part.js": "1f6d7927410ba2594af00a3516723ff0",
"main.dart.js_316.part.js": "4d5b8ba9eef56502d64263ea1140baf2",
"main.dart.js_278.part.js": "2d2ea4366df7219ad92c10e3a958932a",
"main.dart.js": "5b3a1524b7cb8e56618ab72e1e49c6ca",
"main.dart.js_257.part.js": "a177dc7d38f6d908e8fd8c35fb7de073"};
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
