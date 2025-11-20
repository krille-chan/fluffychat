'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "5aecde7f68f229420d2e4aa4e457464d",
"main.dart.js_259.part.js": "e7512d5d40166284c38294dc8c1da7f6",
"main.dart.js_317.part.js": "a23458039ee6e545884a9e444e3b573c",
"main.dart.js_243.part.js": "f8d4ee602541a16dc287a368e53a0eca",
"main.dart.js_1.part.js": "87265e6b380e0f0cf9c4feb56ae165a3",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_274.part.js": "2fc785ed8b18cab024d4669faebea6c8",
"main.dart.js_318.part.js": "82fc8ddf873337a50a8806566ddb1223",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "a60bc1e60ca03910759171f339f43fa9",
"main.dart.js_234.part.js": "25fec944dd6825b4e1c3f44288814adb",
"main.dart.js_316.part.js": "27fdc8a14ada6b5c41e6cac1de46397c",
"index.html": "45339c998c476cf3d8d44eebfb3497c3",
"/": "45339c998c476cf3d8d44eebfb3497c3",
"main.dart.js_251.part.js": "d815bcec19a96a0a6cd804cfd33497b4",
"main.dart.js_302.part.js": "eac116168dcb376114d0da2c7818eb67",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "eb8590f188a4001155c4968b17e84759",
"main.dart.js_2.part.js": "31c7400104ebafe7bb4f4aab1ff17ff1",
"main.dart.js_265.part.js": "1d50139d5b208d43a574a7beb9017b81",
"main.dart.js_300.part.js": "4acf1b79e8db77a9041cbca526bc7a88",
"main.dart.js_261.part.js": "85724e5562535a4d3681c52f18ad9576",
"main.dart.js_299.part.js": "81dfae092880310d1908b88597f5788b",
"main.dart.js_322.part.js": "86d5547ddc0490e24ac61b9e469f6a3b",
"main.dart.js_263.part.js": "cf772fe536e2a01639a87965b8ba7468",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "8a4453e52698e2acac28d903dfb4ec3c",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "3aabde3c6fcc6ec03476301e415793ce",
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
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
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
"main.dart.js_210.part.js": "611533f4070995a6b3f26fea1ec58d34",
"main.dart.js_240.part.js": "2bae2d7cf552ebe6c6a6eee43c9f4ca5",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "c3c48e18a90f168e768bdaaece734e10",
"main.dart.js_278.part.js": "a45a63578eadb6db0ed18f7aad4c09bc",
"main.dart.js_202.part.js": "19cc8b6d22ff3e1a8ef22faf2f680e22",
"main.dart.js_286.part.js": "ced03e7dbf3986a5a1b5091989d79430",
"main.dart.js_303.part.js": "32b35f260c8b7ab6acc31b753c6363be",
"main.dart.js_252.part.js": "b1d81ffd38c4e73e70e8aaf18a62c016",
"main.dart.js_269.part.js": "fa2a96f3d7a3c9d3320ab00c6cfaa4e4",
"main.dart.js_313.part.js": "f1c39b02a99f6fdff31b3e405e2a7a88",
"main.dart.js_312.part.js": "6980e6a1ec431918536da567334216c7",
"main.dart.js_325.part.js": "7c27ed8bfef552a60c88f6070569132e",
"main.dart.js_298.part.js": "fe57eea6ae298c2c8a0647b977e8b039",
"main.dart.js_285.part.js": "c923ec722c5259e8bfcb6ad6e8a3606d",
"main.dart.js_273.part.js": "b062fa728be76b60b2c1fba1ce450096",
"main.dart.js_255.part.js": "aea0af1bd1f57cc753357bf8604b8e16",
"main.dart.js_268.part.js": "2e6152552ac532d35c1c3da3ef628ec4",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "4ea48c2b70ac28bfa68a938d966e2b08",
"main.dart.js_314.part.js": "c3530764220c2059414aff6df0218d13",
"main.dart.js_307.part.js": "0795a7edd3d5c335d3f910d043a0cf83",
"main.dart.js_279.part.js": "232b14e3aa6ba8d0792036def7cb41cd",
"main.dart.js_319.part.js": "d46b24e4188045e204d2dd93794c4aca",
"main.dart.js_253.part.js": "3c8a8c7bf8d9a4d20a3b606f58d78bc9",
"main.dart.js_323.part.js": "6fc08d9e89e65c45ea2e1b30f4f65cf9",
"main.dart.js_324.part.js": "4fe556a94911dd2c667a419fa32286dc",
"flutter_bootstrap.js": "15783359f63e11a0fecba524797ad0b0",
"main.dart.js_306.part.js": "769c8ea38ddeb5015f1dc4789782aef2",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "29f69d3339916606fa835b378c20fa34",
"main.dart.js_293.part.js": "40b924b6c6d8fa9540bcdfc8e2597376",
"main.dart.js_222.part.js": "dee1d2be6f37ceadc3056b2289b84fb2",
"main.dart.js": "3010bd7a5eda5605720092d27aeef0ca",
"main.dart.js_204.part.js": "25c4eef70bf980ad5cfb317277cba944",
"main.dart.js_17.part.js": "4ed7cecb81edb61038051b61586b04fb",
"main.dart.js_277.part.js": "58afece09a64648f1229d20f0c39d3cf"};
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
