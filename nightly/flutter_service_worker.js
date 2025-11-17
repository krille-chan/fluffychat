'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "6bd1c0d852c4546cff500902c20efc6d",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "e50239ff81ae00aed7af1c345c7aa88e",
"main.dart.js_308.part.js": "2b1c1edac3d171011f49b543c6eb4418",
"main.dart.js_1.part.js": "7b0bf1e329e6f3802c3234be3e0b7224",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "40e4457579e95a8680ae1fec78071368",
"main.dart.js_274.part.js": "7d86682a9a86028e32cbac5af8245d01",
"main.dart.js_318.part.js": "8e06f58b7098bcb1beae043d13c24260",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_338.part.js": "c7cd5933d2c0bd5d9ee5842004c8ba71",
"main.dart.js_266.part.js": "846670c961202563d8e40da12e225c08",
"main.dart.js_316.part.js": "f9cbf42d858a83f4dd94bdeb64d2d59e",
"index.html": "b003c9b4764693d913e1ea7c5b1538df",
"/": "b003c9b4764693d913e1ea7c5b1538df",
"main.dart.js_217.part.js": "ce9d15b965a4c308d00c3bb234a0e81c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "028cc1909b4fdcc928450f563e32279c",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_265.part.js": "71c3299190d24d9ffc150f0d54607c9a",
"main.dart.js_299.part.js": "79eeb2da4279f008b6f1caf0f9bdb63e",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "e98b80c0a9b73ca5d8d5e17e71fb4c36",
"main.dart.js_301.part.js": "453b8cb058328f477e9c57a42141eb27",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "50c84084a133eae450fffb8d6444bc3d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "96b0bb5be20cd33cabf8b7e9d3cea283",
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
"assets/NOTICES": "4de3f617c2e220cbcf134b0c31162a7f",
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
"main.dart.js_320.part.js": "8eea6113cec1a100d55c318317d5195c",
"main.dart.js_247.part.js": "3025bbfc16cc182e2ca3e985c6fc5daf",
"main.dart.js_292.part.js": "160d60fdebab7984b5eafc14b6aff5e5",
"main.dart.js_16.part.js": "5e8856e548807b4f77401aae5abe1884",
"main.dart.js_278.part.js": "837165ded0ae7eb604851e1580a50ee9",
"main.dart.js_286.part.js": "bf5d106f737b67fbea3d35df99cd1a67",
"main.dart.js_336.part.js": "09f1ea7d8d71bf1fb9aa7b17710111da",
"main.dart.js_333.part.js": "d0f248122876d23a15d8afa8a6b219c1",
"main.dart.js_287.part.js": "200cd138746462b44379dc655d394abd",
"main.dart.js_331.part.js": "a5d0765e7c96f54589463bcc9e6ac375",
"main.dart.js_290.part.js": "454b91e38e4337c691d84d8d05d40734",
"main.dart.js_313.part.js": "105dd6e6c9bf8d6c01401910697fc48a",
"main.dart.js_312.part.js": "3714d7456f033d413a71dc969c753778",
"main.dart.js_325.part.js": "dafdf7940dfd97b5eda47b929b3e4d24",
"main.dart.js_298.part.js": "8bc0b163485786fb724e32032f6f22cc",
"main.dart.js_321.part.js": "59249dba4a6db7d60526a3927777a8d8",
"main.dart.js_235.part.js": "a630876bc8403088df6ca95ea3e2d390",
"main.dart.js_268.part.js": "74f909c742e3e1a066a235164ebfbda6",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "4713347a4cd0a75b6921712a57f23f1c",
"main.dart.js_332.part.js": "01e1605eab13f014b6ce409d244e2158",
"main.dart.js_314.part.js": "2e73072a310d3d8419afa061bc8b21a7",
"main.dart.js_319.part.js": "70f6725c849ed5d455fd0b40d3556857",
"main.dart.js_215.part.js": "a79a89cc4da806527a274c6b3a0459a2",
"main.dart.js_253.part.js": "460e33adc4c331f2fdc9bc25be445459",
"main.dart.js_335.part.js": "7f9a9b4a71359ed6576c407f8c246d00",
"main.dart.js_337.part.js": "91e5f443e2b0262193a30137b4ed37e4",
"flutter_bootstrap.js": "98affc35bbd5244da5c05e74abdb4492",
"main.dart.js_315.part.js": "68bde7138f57522fb7eb686dd9de7cbb",
"main.dart.js_264.part.js": "090ece49b163bfa7779b5dead9c8afa3",
"main.dart.js_306.part.js": "2d1efe235335c6d400514353d0db4c48",
"main.dart.js_276.part.js": "265e549f4f4433816547e679b334d07d",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_238.part.js": "63b85985a88a7c6016d93161b8914e39",
"main.dart.js_256.part.js": "ced1e9cf20c6f11a8d9cffde41298856",
"main.dart.js_326.part.js": "ab38a4ae83a68db3124f2e29d000ee11",
"main.dart.js_329.part.js": "743f734fa3afb7376bf46688a469ef4d",
"main.dart.js": "97ed25e0e1a38106a010fd73d1e6fe3b",
"main.dart.js_272.part.js": "6e3d380e1d31abbc287c5d1bce26e3a2",
"main.dart.js_223.part.js": "57961ea944c64b1d5cb179c6be21af55"};
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
