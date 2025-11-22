'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "ac41fdfb85db99f176dcb83f0addbd4f",
"main.dart.js_317.part.js": "d2da23c7762a8cf245a1c4bdb25e0f45",
"main.dart.js_1.part.js": "67086b459f0680c10c38fd3d1172bb28",
"main.dart.js_260.part.js": "45d3d1df01ae5566ce5440cc59d26014",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "d92be8ed6cdce3a17bdc5c75b3857d52",
"main.dart.js_274.part.js": "befd2a7bcd7c78c849766bfa6054e38d",
"main.dart.js_318.part.js": "86c94c045e382fef3f397c6d9bba3198",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_211.part.js": "f686527cb065400a946568a0625aa52d",
"main.dart.js_266.part.js": "0c1311f54b4b6330867a63f1222fd92e",
"index.html": "10613aa385795d7e30331c73e480bfbd",
"/": "10613aa385795d7e30331c73e480bfbd",
"main.dart.js_302.part.js": "0a60d4766a83b0f12d3df8a1739790be",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "9d6ebdc697f6387953218362ed2852e7",
"main.dart.js_244.part.js": "d4edc96dd18bbcf84bdfae474c84a8bd",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_294.part.js": "bc69ef1efb473f3604045a68acf08c4f",
"main.dart.js_300.part.js": "ee2d5c9a9bf1e2f01a175bd03e61b82f",
"main.dart.js_262.part.js": "fe54b96be2fed9f70811eae0218eaac7",
"main.dart.js_299.part.js": "ff8ca42a65d54c993991c1cabb1d6f02",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "ecd3154878b60483a64fa271cc7528cb",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "d6a7aa7248da1589fed6b909240db088",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "bb946b7e1c553f05dc339e31ccf805fa",
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
"assets/NOTICES": "3ed19900f4b6d3f69a5b0e9689b8e27c",
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
"main.dart.js_320.part.js": "d3e2c5a0bb79d1059cf305b45cf7c5b2",
"main.dart.js_254.part.js": "fd9bda23b1518458a02d351dc97c3ca6",
"main.dart.js_296.part.js": "a3bd5cef407b0c0fba32ac0c759ba197",
"main.dart.js_278.part.js": "13387e5fb41c81f4c2162e9452b80086",
"main.dart.js_205.part.js": "ae1577eb072ac9024dd307fdf8963324",
"main.dart.js_286.part.js": "7e3a5b0d0628608cddecdad24e4ec26e",
"main.dart.js_303.part.js": "0387f6c6bd3f70b1325254ffc834e13a",
"main.dart.js_287.part.js": "0eebec6402c8345a069ec2aba1accb6b",
"main.dart.js_252.part.js": "6aad68831a63b110f9c1b28d606a2192",
"main.dart.js_269.part.js": "028526e597d9285f9473bfb63f1d7aab",
"main.dart.js_313.part.js": "9073e9940b14f39ab9cd5dfa3406ab55",
"main.dart.js_309.part.js": "e96158d2d2066047c071ed80660e5818",
"main.dart.js_325.part.js": "23b17ef7d27ef3ab1cd29fb385195583",
"main.dart.js_270.part.js": "f0f353d955190564a5fec16ce4e37e54",
"main.dart.js_321.part.js": "90192b0533b0722680225edaeda0a919",
"main.dart.js_235.part.js": "2fa790be83afaec8c895033fe8ee352b",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "5e7c7db487d59113230a93ca289484bc",
"main.dart.js_314.part.js": "b16f739b81379353994921ca0c39f580",
"main.dart.js_307.part.js": "03c987892ddc877fc854204a73b95e49",
"main.dart.js_279.part.js": "6288358daa28d46d73693ebf442bbe3a",
"main.dart.js_319.part.js": "43d05cd2115107c40021ea6794bb64f8",
"main.dart.js_253.part.js": "238398c902993f03d73d390297fe60c3",
"main.dart.js_323.part.js": "0f5ed5c92b4d00e9c28a09df79457dc7",
"main.dart.js_324.part.js": "f854d46a53f73d7b2a62e8f98cef3afd",
"main.dart.js_203.part.js": "2f6303bb3bac442d3eb41d17788ff605",
"main.dart.js_289.part.js": "e55ac0e06f3a5b41de2b487f0f2b6c7c",
"flutter_bootstrap.js": "dc141b673009da5ca19ba9b62e568dfe",
"main.dart.js_315.part.js": "ab5afa3e20967903f9563058fce2beba",
"main.dart.js_304.part.js": "3fd60641c4b1791943ad646639096db7",
"main.dart.js_264.part.js": "880051dd4851cb2098db73a8261086cc",
"main.dart.js_306.part.js": "485ec64c1b2a43c594abd4767ff1aa7f",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_256.part.js": "ce9c6792126a686d5221aafe86cc2acc",
"main.dart.js_326.part.js": "5742cad073542dafb15fb20dd6de2196",
"main.dart.js": "f55af5941e63a994b40f2b26f6ad700a",
"main.dart.js_223.part.js": "c38c10af60da013c4375e29be2d36c39",
"main.dart.js_17.part.js": "034cb803c8e1748d0e90ce9e4cc2e7e4",
"main.dart.js_226.part.js": "92ee311a984f0af84368eefc834a8e47"};
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
