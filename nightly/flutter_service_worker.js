'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "9bfa3b250799d138ea4da401bf4e4fb1",
"main.dart.js_308.part.js": "5110d283c710d1af72ce568d98a5978b",
"main.dart.js_317.part.js": "ae75a7ce24b9b01f50de4637e617558b",
"main.dart.js_243.part.js": "95bca8b192c43c0b6d2281d40a14330b",
"main.dart.js_297.part.js": "5d22263ba5ca5cccc350f363b4061a2e",
"main.dart.js_1.part.js": "3f5c6fd06e7f1373a91d7e60ea4fc466",
"main.dart.js_260.part.js": "b651e8eb61e60b6309e96cb4a7ff350a",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "b0244e053901b75d6457372dfc5a508e",
"main.dart.js_274.part.js": "6394fe6ab9011d8b7529d81314ac58c0",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "939f0191e9a085a2f5a2c399280152b5",
"main.dart.js_211.part.js": "9aa01d5766935eb1df6d21331c48e743",
"main.dart.js_234.part.js": "eb88eb8a9d2d3088e4b7ea8ba900bb27",
"main.dart.js_316.part.js": "c35e7903a630020fb5633b34ba0d7276",
"index.html": "7abc6aad439d266d0e8eeb730e3babdf",
"/": "7abc6aad439d266d0e8eeb730e3babdf",
"main.dart.js_302.part.js": "c0a15183ab44fb8102ddb677844c0b36",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "6fa52989872b0fd0a1876a80b4d8df91",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_283.part.js": "6fdf5dfba5e8ea71dc5bcc3d98a820ca",
"main.dart.js_294.part.js": "683c6a03e8ceed9e4aabea9f3cfbc7e0",
"main.dart.js_261.part.js": "34de2dd198107d152b929806074744a9",
"main.dart.js_262.part.js": "f3e1008ee4c8d1d5343c6f6db9b7304d",
"main.dart.js_322.part.js": "7904b837f79bc48aa0356bc09ae9ada7",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9fd620a5096ec4c68c6281cb0c27d5c2",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "b86c7cc3bc7f0ccca405b34673a7bbe0",
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
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/NOTICES": "e3942d4aef2a10490fb32abd34246436",
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
"main.dart.js_334.part.js": "0f622bd4791d68800b1a20081ebc15ed",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "beedb2691b9c116bb11ceeb4d51fb61d",
"main.dart.js_286.part.js": "5622372d889cede78118584140bafcef",
"main.dart.js_333.part.js": "1b7c62a7c60c1c1fb765a47f399f7614",
"main.dart.js_287.part.js": "7ebc315cbaf15933308b4e56cb1bfb7a",
"main.dart.js_331.part.js": "b7900c0ddbb649a27203838b58e68a2f",
"main.dart.js_252.part.js": "fe4fdd6553842a9e4abeb971e995a062",
"main.dart.js_213.part.js": "244dc2b4139d8e810b21edab95b4b899",
"main.dart.js_249.part.js": "cd0c5bc4c5a7ee987d17b1f2a32f57eb",
"main.dart.js_309.part.js": "55eb05784b93117e3f27082d47dbc626",
"main.dart.js_312.part.js": "f6b7bfe3299242b1b8e4d66003da6e7a",
"main.dart.js_325.part.js": "f18030090d6a63200edc9ff81a4923e1",
"main.dart.js_270.part.js": "36dd051d979e860a07cdea1023728bc1",
"main.dart.js_321.part.js": "ca6ff4a56e48c2fed66e33d0f5338b2f",
"main.dart.js_268.part.js": "43936b0b7c653bf7a1827194be3e43c4",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "6a34ac37871fc2b3f627e08f2a960a74",
"main.dart.js_288.part.js": "549cf29b2ef77b1bffd6d1fcff106714",
"main.dart.js_314.part.js": "f19912710fb0d1c0dfc4886b671ebbc2",
"main.dart.js_307.part.js": "cd865ff5c2aa47be3452cf89d62440a6",
"main.dart.js_323.part.js": "10a7a5bef7493701c3d286463c100c0d",
"main.dart.js_328.part.js": "cb8a279e8896320e5be4473fdb8747fe",
"main.dart.js_231.part.js": "8d1ccfaff0140bbc6ee9280112316945",
"main.dart.js_219.part.js": "1d3a7709d31b09b95a13e03a3eadd0e5",
"flutter_bootstrap.js": "3121d47f5fa14e3768327cd7703e27d2",
"main.dart.js_315.part.js": "a44d3df7878c37fb5aa37a08107ab8c4",
"main.dart.js_304.part.js": "ebc38fe9de4153a9e0ecd4b41e4b7035",
"main.dart.js_264.part.js": "97442e8627b1e74afd54b6ef2f3a7454",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "06b601379b472ae027cb2078605bc5c1",
"main.dart.js_326.part.js": "c981fba37b221b5fe7083d94a4cb055c",
"main.dart.js_329.part.js": "c21a92ef90ae253132f7b06c3a5f0f23",
"main.dart.js": "52de9aa0363f287fbc1b7328938265c3",
"main.dart.js_272.part.js": "222f78b50bb6fc1bab2b4c5aba482bf4",
"main.dart.js_17.part.js": "5c6e2d292c77d4396eecc2c30370ffbd",
"main.dart.js_277.part.js": "8ab6fdd5990ad12ca891364116fe9bd5"};
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
