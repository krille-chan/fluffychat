'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "d69e19a10a92a1da0f23558d72081965",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_271.part.js": "ac2c374d3fe7912bc00d57e4bebbd594",
"main.dart.js_259.part.js": "9e3547d85e614e88d66de865787b3983",
"main.dart.js_317.part.js": "b0748b9cb495b5c19863bb66d67d120f",
"main.dart.js_1.part.js": "ea67b3d0c79a925054dd363f70369879",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "cbcc8d1a8278630e02be0532f1e47b8d",
"main.dart.js_311.part.js": "d64f012ca6d6c03ea250feef0cf9fad3",
"main.dart.js_220.part.js": "284bf5bac23b641e0a35080a7a454ed4",
"main.dart.js_318.part.js": "4f9a2020bd011d0838e376b1a513c6fc",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "4eeca6d4fee881b6a2ce56ea93fa2015",
"main.dart.js_338.part.js": "6b9d6a6d3e06c9accbc603b2d614f998",
"main.dart.js_316.part.js": "6d8036c6011c919f552f849ff37cc574",
"index.html": "81284f86cea4ec0f47f907792a15c137",
"/": "81284f86cea4ec0f47f907792a15c137",
"main.dart.js_302.part.js": "dabfe6dfdf22ee76b549621f0a90a841",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "a4d9b98f9080c12408745767fa0eaf95",
"main.dart.js_2.part.js": "31c7400104ebafe7bb4f4aab1ff17ff1",
"main.dart.js_294.part.js": "e0392f4ad63a54f068917bf0d100ec21",
"main.dart.js_322.part.js": "b5927b5390fdce2f6d2d0bfb5be6afa9",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "e41fa3ae633d13fd191343ba12284b7f",
"main.dart.js_301.part.js": "b14db8dd55254985d72cbf8fb7ebd7eb",
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
"assets/NOTICES": "5d79138da5544c4cb0ec217cc90ce405",
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
"main.dart.js_334.part.js": "209503cd84bf75b9cf11993964a7d02d",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_341.part.js": "9d2261932a1724cbaa08a2c453cf9f35",
"main.dart.js_284.part.js": "890de2649c4f21ac654c33582fdc8226",
"main.dart.js_336.part.js": "4d7f16af7dde479d6309bf447068917c",
"main.dart.js_333.part.js": "69ace0f35f6ffaf5b149d891859f596d",
"main.dart.js_290.part.js": "0c6ef48b7a86006cb5dd92be3282b000",
"main.dart.js_340.part.js": "fd417726137f46555c19a693f4283038",
"main.dart.js_269.part.js": "b92952dbb00a4dcb60e05897df829fd5",
"main.dart.js_267.part.js": "1b33e7b744b53408eeb163895dd2c44d",
"main.dart.js_309.part.js": "f532bac6b2bfda0d8e367a0efd7b84ba",
"main.dart.js_285.part.js": "8b584a10e9a85bb63f384ca1d6da207b",
"main.dart.js_321.part.js": "f98ee2876777ccb6e5dbb1fe15c7624c",
"main.dart.js_268.part.js": "af6951103b98110039862b2c24b09061",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "68b59f2cf8ee37ef89b1e1323f6afac7",
"main.dart.js_281.part.js": "3855bd8c756446336ab01a3d67e48a37",
"main.dart.js_332.part.js": "ace850e6eaaab1d9dd8321cf0e46cca0",
"main.dart.js_314.part.js": "2167c63fa60726727f821d74f6d7db7e",
"main.dart.js_279.part.js": "ac3a57948eb08736ed1ed2240bb09e39",
"main.dart.js_319.part.js": "12394328dabee89f89c137247e24a998",
"main.dart.js_323.part.js": "d80e29e21fe583b4d630ee38a568b61f",
"main.dart.js_335.part.js": "20139956411d955cfa72b4a4ac2781d9",
"main.dart.js_218.part.js": "858fd663d17d90b6a9496243ea21fb84",
"main.dart.js_324.part.js": "bb1ace9c541e0e9dff079d6cb213dc7f",
"main.dart.js_328.part.js": "809ae9f1a1e7fb71007d33f6e9e09ccc",
"main.dart.js_289.part.js": "fa46c3431f7ca5d9baeea01c7941d663",
"flutter_bootstrap.js": "9890f55b242cfd780c2b97af21d59d39",
"main.dart.js_315.part.js": "221e1624b2963a674d322ff235dc679e",
"main.dart.js_304.part.js": "1cefa849699e30c4bdd3ce953db7dbf2",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "448c8b32a7c10f5451463f68e4a79ad3",
"main.dart.js_238.part.js": "de8c62c505f789131406d95f2d0eee6a",
"main.dart.js_256.part.js": "e6d41a1d0231c0191c8ebb3b056da426",
"main.dart.js_329.part.js": "c4c4ef7946d7ef0429b70c9eac387585",
"main.dart.js": "3396548098576a1076c247f81732209c",
"main.dart.js_17.part.js": "74e8848a48382ca53a837cc73a5493c6",
"main.dart.js_226.part.js": "0a37b141a5036db48fe1a13de4ef244a",
"main.dart.js_277.part.js": "829e39b3fabb95ac2eabf7862981690f"};
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
