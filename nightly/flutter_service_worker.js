'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "f2f6c23a5675f436ffe1f072c8e8a872",
"main.dart.js_317.part.js": "36c3998c93e2810c796384cad916b293",
"main.dart.js_1.part.js": "382a72b5c85e131668e6d843fa17ebb5",
"main.dart.js_260.part.js": "aab9cfbcb82abf62f23e45a1318bf4a4",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "d8bc51e12565e6e19c5c89bce8318f86",
"main.dart.js_274.part.js": "2f25e71d364166c5bd868e8f3078a63a",
"main.dart.js_318.part.js": "521ad5ea97b93dbfec3aec350f98439d",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_211.part.js": "cc5870eeb06af1d659656f11faca10c9",
"main.dart.js_266.part.js": "3358a0544987bdc451c8bcc14824fcdd",
"index.html": "983f495f7869b86e18e70c1bf2c792a6",
"/": "983f495f7869b86e18e70c1bf2c792a6",
"main.dart.js_302.part.js": "7abcb60c7bbc611568ac272d27497221",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "bba80e23a9807ae13baa7b8f4ecb8f85",
"main.dart.js_244.part.js": "3fb0d50e8c19e0dec91040f4e7923303",
"main.dart.js_2.part.js": "31c7400104ebafe7bb4f4aab1ff17ff1",
"main.dart.js_294.part.js": "11a4ae94c178569f9a32c3bf049aa468",
"main.dart.js_300.part.js": "eebabba4c8b6f7fc779acfb3e36a90a2",
"main.dart.js_262.part.js": "e5fa60a4e05d298fc080bd47307cd5e7",
"main.dart.js_299.part.js": "652c56840c290a2a34057a5c5d370e02",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "e1e9ee7dd1db2bf9a6402c4e3292045e",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "94e3cc0a42531cf9820165652a824019",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "f1cf8b35918a00fd5fdc9eb0db466ec7",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/fonts/MaterialIcons-Regular.otf": "cf04b1acec037d1bfe7beae9ec5d43f3",
"assets/NOTICES": "18f6b1633458f1980747a31d7e0608c1",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "429d306be3085c462b32102d0c6bf681",
"main.dart.js_254.part.js": "18e135d37ef13c43c29d394cffc5b374",
"main.dart.js_296.part.js": "6fcf748ae65fd88e5eafc71bca2bcdf9",
"main.dart.js_278.part.js": "26faf8f1cc2e05f7553cebe25beaa5f4",
"main.dart.js_205.part.js": "63d41e5603a29c504a6ca7267a5d67b1",
"main.dart.js_286.part.js": "81892de4f5f77a90b2e2289d3cc385e1",
"main.dart.js_303.part.js": "eb76604e4ecc9fe69383ad0d4fa162e4",
"main.dart.js_287.part.js": "6138f7028cc68a9f55cd91fba9dc10d2",
"main.dart.js_252.part.js": "806ade7680a2d97a24001ceb97e18a21",
"main.dart.js_269.part.js": "e0d884a35bbcc70c3efa6a83738beb3f",
"main.dart.js_313.part.js": "bd01cd2717cac1798d0264a4fe714c7e",
"main.dart.js_309.part.js": "d30a30f01c9ca8acfe975af422139c47",
"main.dart.js_325.part.js": "ea2b555278a561a06a04d9954526c5a1",
"main.dart.js_270.part.js": "b374b135b0c75fa2462382ce418baba5",
"main.dart.js_321.part.js": "6dcdbc28fb584f64b3b247697ad04d71",
"main.dart.js_235.part.js": "9483d86823b38573790fbda99152f9a9",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "cc0fe89511cd418aca3ff7b63e6a3f38",
"main.dart.js_314.part.js": "10ab39ae29a171cad861f62cb3aa0b1b",
"main.dart.js_307.part.js": "f61f0aad063b2bc1774c24a19006f025",
"main.dart.js_279.part.js": "a6ada8d79d314c905500f47be977d606",
"main.dart.js_319.part.js": "ffebea500ba58b3df5fdaabc1b460799",
"main.dart.js_253.part.js": "dec0f09f5c5fab2b90f3d838a9e454c8",
"main.dart.js_323.part.js": "d3d544ebe1e56f4bd9033dfb2e005ee0",
"main.dart.js_324.part.js": "f7165f01b29ddfbcbd257dfe84dbc35a",
"main.dart.js_203.part.js": "0748d552fe6569692afac8989b330d5c",
"main.dart.js_289.part.js": "a9aef3dcde6eb7c42953ee4fe14eb52f",
"flutter_bootstrap.js": "e0ed18958c61c70d848f60b4e5df171a",
"main.dart.js_315.part.js": "2596632b4899996ee6860663bbeb9def",
"main.dart.js_304.part.js": "39711e348ad497eaaeea3489e523d4b5",
"main.dart.js_264.part.js": "cd7261ed24e4b384ed98283014d6814d",
"main.dart.js_306.part.js": "3f1444184574f0d8cbe405dddd75ab7c",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_256.part.js": "84f227413c0a09423bf58b199ddf1b74",
"main.dart.js_326.part.js": "72a5dfd62ccc685b93fda9d53104f0a3",
"main.dart.js": "5e97ceae23f5ff61fe7e4a76be132d62",
"main.dart.js_223.part.js": "dff40a916de78dbf9e2649e374e61f99",
"main.dart.js_17.part.js": "a25fb42ed8a45078db17f38a0e4801ba",
"main.dart.js_226.part.js": "b9e2c0d2546fe9857a9f69e8a56e2331"};
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
