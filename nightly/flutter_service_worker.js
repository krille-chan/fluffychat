'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "51f77dc653d7dae1aa3b9be7fbf407c2",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_271.part.js": "ce248549e49bdcd811c028ee6c0b5a5e",
"main.dart.js_259.part.js": "9c1b1f7895a3164947ebc40bfabc22d8",
"main.dart.js_317.part.js": "87a05e32681ad5997563448ac8420e53",
"main.dart.js_1.part.js": "382a72b5c85e131668e6d843fa17ebb5",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "58f1e112cddb9b3d909d17ff7fec88f5",
"main.dart.js_311.part.js": "aa67937b72e3d59a3d3b087bde5f36ef",
"main.dart.js_220.part.js": "29ba54d4e39f3fd0f059e119463d184a",
"main.dart.js_318.part.js": "c44b2f4e299642e88b5be1ca7bad97a9",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "71a5531cf18a199e91a204cce5208ee1",
"main.dart.js_338.part.js": "802fc0bb80232f9a0ae0f83cc3126256",
"main.dart.js_316.part.js": "21ee7911344a28ffb13476d51dc0700e",
"index.html": "ee06fe7d14d264b44733af5158662b0b",
"/": "ee06fe7d14d264b44733af5158662b0b",
"main.dart.js_302.part.js": "ff21415bcac74be0e512f1db16d67417",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "6f10d448763bfd635dbd20caaffb3a5a",
"main.dart.js_2.part.js": "31c7400104ebafe7bb4f4aab1ff17ff1",
"main.dart.js_294.part.js": "6e91b4ac14307f7c865af829da302d24",
"main.dart.js_322.part.js": "06d8cc38a57bdf92df4e0d554d8a67c8",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "df6f8d667ce1afa581425a5beebfddb3",
"main.dart.js_301.part.js": "08cbfe3714b0097645b8a17ada491b91",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b0ddf79a1259aab871a077e01fd02554",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "863fa68e0ef1554fc13f37ac504bafe5",
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
"main.dart.js_334.part.js": "58d8274d09bd06983e486b43a38aaba4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_341.part.js": "4147ebb9711f042ce8b117e0e536ff78",
"main.dart.js_284.part.js": "9f250adcd34a8b8fe2663fc51030f39b",
"main.dart.js_336.part.js": "ba4f09ab92795bdc52554ff3fbba969a",
"main.dart.js_333.part.js": "fc0c4ea2a05557092ee2493c96f74f0b",
"main.dart.js_290.part.js": "ab6fb6b68aee34677c666f0e0d1310ff",
"main.dart.js_340.part.js": "e162b8675bed57983f8ad2951979ef9b",
"main.dart.js_269.part.js": "29972d9ffc987cf5e861641c6189b035",
"main.dart.js_267.part.js": "ff44ee2f11c550b5d233d60c899e6401",
"main.dart.js_309.part.js": "a5619848793a87d8c19867663347989d",
"main.dart.js_285.part.js": "0e108f5268b8a3f4ef6a0be70d5470a1",
"main.dart.js_321.part.js": "72cfe9486e27f6bae4248bdfb401f318",
"main.dart.js_268.part.js": "6cba5e3632085af37e9b6b15576c1143",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "2aeb2185cccd1516ea2adcc037369897",
"main.dart.js_281.part.js": "f6c08a935706ec8b566cd00404176bf4",
"main.dart.js_332.part.js": "5abf987125828fd640ce77891c8f2a05",
"main.dart.js_314.part.js": "e57443505f291e514c15f00ce55776a6",
"main.dart.js_279.part.js": "b41a16d95bceb794594cafa8f725bf78",
"main.dart.js_319.part.js": "06d31844a30d580fff846bb8ea5f91f6",
"main.dart.js_323.part.js": "a67d1c8369c528856a7fae18235debce",
"main.dart.js_335.part.js": "28c26dee072f724af0ad1325a824f92a",
"main.dart.js_218.part.js": "b634a5221e6817a40cf14539097a2b5f",
"main.dart.js_324.part.js": "1640414ded67f7d21dbc597ab59975ad",
"main.dart.js_328.part.js": "66b1db121e6b90f7257e51bd790b78b0",
"main.dart.js_289.part.js": "3a1c34f20b8b84031ef482c287139aae",
"flutter_bootstrap.js": "76a9a9b8afd75099003124ffc1fe50bb",
"main.dart.js_315.part.js": "e94e7e33f128e146f33a15836830f1cd",
"main.dart.js_304.part.js": "485f2681d40d5bc95d905264e881fa40",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "5ea686a417f7d24e5bf55b68b8bf8a41",
"main.dart.js_238.part.js": "e274b7be77b46279d5c7625d73b284e1",
"main.dart.js_256.part.js": "5c44d0210ef3d13ea4fafb13c0f5f1a8",
"main.dart.js_329.part.js": "19d146b78fc2d4487387d2549e79f935",
"main.dart.js": "d8c06e069f0acf0849cce3f3760f1cc9",
"main.dart.js_17.part.js": "a25fb42ed8a45078db17f38a0e4801ba",
"main.dart.js_226.part.js": "4a368986be203783233a6cd9c1a4f3da",
"main.dart.js_277.part.js": "960e2338f116de03091344ea4845ccbd"};
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
