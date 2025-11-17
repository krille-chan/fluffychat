'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "1880ce4e2a33958cda3fd0f8690019e6",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_208.part.js": "abf281918c41a3779c805f103c5ff829",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "040b7000dba83a58e5d29acd0eb3609f",
"main.dart.js_271.part.js": "6ca1bda9429af0a31b7acde6a1776583",
"main.dart.js_259.part.js": "09b61474a6c00dbe56f94d959e278028",
"main.dart.js_1.part.js": "7b0bf1e329e6f3802c3234be3e0b7224",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "2fed40cde221c6dfb3867be2c1dcb8a6",
"main.dart.js_280.part.js": "2a421ffe30b036ce3fffda41ce8305bb",
"main.dart.js_274.part.js": "26078d8c88ff9013775f0db09f21415a",
"main.dart.js_318.part.js": "c0d9f6a65e95ea3ff84b5bc7b0b63797",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_246.part.js": "09c91ff100134021cd98cc75b3b9dc95",
"index.html": "23319d81246348f3dd0f7b298356f7e5",
"/": "23319d81246348f3dd0f7b298356f7e5",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "109f9fc73df2ebde6736baba47e1ecdb",
"main.dart.js_258.part.js": "319b401c4921bafdb17dd5b46dcb154d",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_283.part.js": "8de0801542fc930f6eb001569714cdf8",
"main.dart.js_294.part.js": "9b7bb0b5f92d3285a449add1e67f3604",
"main.dart.js_265.part.js": "483bd5d96c263717fb86fcae642160ec",
"main.dart.js_261.part.js": "c5a36d4748f87004df30019350ef6aa0",
"main.dart.js_299.part.js": "25b64015917ba6bc085219cd75fff6f6",
"main.dart.js_322.part.js": "da562727296cf365a29b0c29dd48f23f",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "367ad4626f70c1de04a6488fa880e3b8",
"main.dart.js_301.part.js": "39a2814ee220e3df8bd991417c34d650",
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
"main.dart.js_210.part.js": "abf50084c2671fe9b04b0abb441f1ab4",
"main.dart.js_240.part.js": "905e16e65bee846f5df169cd37305bea",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "3e79bfb20cbfff62bad4606f4db8c074",
"main.dart.js_228.part.js": "5505bd17b51bc809999105f210a6ef44",
"main.dart.js_292.part.js": "c8ba68cb959aa9b29b3820500975c71b",
"main.dart.js_284.part.js": "516fb03a367a0ec90a989b9595747ef9",
"main.dart.js_16.part.js": "5e8856e548807b4f77401aae5abe1884",
"main.dart.js_331.part.js": "58719d886f51520de4691bfefc8da0b6",
"main.dart.js_257.part.js": "e7ad1a355c0e86a8ec12a341b006cb66",
"main.dart.js_249.part.js": "1c054cecc5ea84d0b283d0e3a09a10ae",
"main.dart.js_269.part.js": "50e06e10c61a773c4c8baedd7b91ad73",
"main.dart.js_267.part.js": "138cf38e37a9f64252082c2c4b9aafb5",
"main.dart.js_313.part.js": "0dfeb7c3d95a9d8f33617d16b95b6b00",
"main.dart.js_309.part.js": "d57f87aa73cfb3b5c7dd79950891f1f4",
"main.dart.js_312.part.js": "7b69d4ee950b1072d5cfb5be82c2b713",
"main.dart.js_325.part.js": "7acc3f02a626d986738583628b742f4b",
"main.dart.js_285.part.js": "fff42f5ec510eb63e4dc954d6c3edfd4",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "7dcae459ba9ec9b12df5665bc2f959e1",
"main.dart.js_314.part.js": "e50ba78cc6a254cf42388f068bd86e04",
"main.dart.js_307.part.js": "6ba35f6ffd2aa99a31495a36d90aafb2",
"main.dart.js_279.part.js": "dbf47e918e766a83571bdebc9265e2f8",
"main.dart.js_216.part.js": "950151d612ae69c14613a0e35ddc2bf9",
"main.dart.js_319.part.js": "286f1a6cb8f2637368d8eaf71063bf8e",
"main.dart.js_323.part.js": "c2f09633e3d520c91d684b7ffec66a30",
"main.dart.js_324.part.js": "4f55e91987ea038ae16d71bed3bf3d38",
"main.dart.js_328.part.js": "a529d285605d6bd394c4723c2bfc3a4a",
"main.dart.js_231.part.js": "d5edbbf0208b5a337d1db91b7d05d865",
"flutter_bootstrap.js": "084ebd9bfb846b8d040a18f3d5972803",
"main.dart.js_304.part.js": "02e9803144b02856f3aa18037ed432de",
"main.dart.js_306.part.js": "4ae44f86db466db2f5eba9570a61903f",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_326.part.js": "6997b4aecdf7e2291104e86aa39b6dfc",
"main.dart.js_329.part.js": "b12231233693585cdf0876c23dfb818b",
"main.dart.js": "38c0a6110685c0b5f596b49f631ff773"};
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
