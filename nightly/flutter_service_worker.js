'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_223.part.js": "0c3a7fb693fc867c1d3504b6cf88e2a9",
"main.dart.js_256.part.js": "e08ab1a37af49739fa144eab115fe4fa",
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
"main.dart.js_196.part.js": "2d6d5998a984a60a58ce6b2cd39a560d",
"main.dart.js_295.part.js": "8cc374736140481a6df1e2b46d74e080",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_244.part.js": "5ee51f5c0d8f4b0de3243e47f740432f",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "003a1a7ae11cf99acf95dca094e2d675",
"main.dart.js_234.part.js": "074c92ace3ae1ba027bf455bf02c00e2",
"main.dart.js_296.part.js": "b623489d7f392b2df71e0c8ade4590b4",
"main.dart.js_298.part.js": "d9d86c5a1f7500ee875d19b0966bd599",
"main.dart.js_246.part.js": "1d8eb1f5c15791c8c5d2ed062eff43fe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "935019e6660dd17ffcebc7184b68a058",
"main.dart.js_277.part.js": "98d8d65f9a1fb5ac64c20114416d742c",
"main.dart.js_279.part.js": "ef76640c1049665584ce6403b77bec79",
"main.dart.js_217.part.js": "63571c4c14453211b65036b5381853db",
"main.dart.js_235.part.js": "d25f635b23952116345b3d60c8f12323",
"flutter_bootstrap.js": "e478df477ff3b4f6331c8b369fae22af",
"main.dart.js_264.part.js": "b61990efa48a66cce6b53e951d83aef9",
"main.dart.js_194.part.js": "d828e7b99835bd79382f4366521357ca",
"main.dart.js_267.part.js": "5140be03ff78a54aa004750a8656ae68",
"main.dart.js_291.part.js": "0067f4f5d77c5fa40a8fb72ec809e9b4",
"main.dart.js_236.part.js": "d43b7d4ca4ebb1c94f5dd44a85c60895",
"main.dart.js_208.part.js": "5f04dee55e18428580b66c24b3066664",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_290.part.js": "2b74d72f6e007af0e92d20d18eb700e1",
"main.dart.js_294.part.js": "be11eae2908e55d96c7354cd922682e5",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_209.part.js": "bf2b81ba020b0fe2cb802488535cd5f1",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "a05e7b7296e7b4d67d9e8e2e6a190e7c",
"/": "a05e7b7296e7b4d67d9e8e2e6a190e7c",
"main.dart.js_299.part.js": "b7ed637afb770e1680f7a98b81b043fa",
"main.dart.js_281.part.js": "7f4f083219898a17b34480077f00cf05",
"main.dart.js_242.part.js": "6d6736eafd84f977cfb15f5b642b827a",
"main.dart.js_301.part.js": "d6c32a03d8c0c488da9d597e180f756a",
"main.dart.js_297.part.js": "cf32b6adaa2d14dbf3e5a527c9b8d309",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_286.part.js": "aaaebb57ce105474a0610c8b3180f4ba",
"main.dart.js_292.part.js": "e55506e92f8921e0231745a4a5436f16",
"main.dart.js_248.part.js": "5ef5cdf5de2a2190dde312abe176bdb5",
"main.dart.js_249.part.js": "c836664127b377f4903e7841607a8b51",
"main.dart.js_252.part.js": "05ecf1c5daa888cbe27ff26b207b9832",
"main.dart.js_272.part.js": "478bcae8b006e0e92dbc64d6f6d1fb30",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "20a5c11cee0ccf1d3ae84f741d2c7b82",
"main.dart.js_226.part.js": "c16de1a864480c0e2beab01cfce35bcb",
"main.dart.js_284.part.js": "33e29e8ce914f6d28c6356b76abf35aa",
"main.dart.js_247.part.js": "f55f3e93e9bd23e383700bcb23556ab2",
"main.dart.js_1.part.js": "1950300a77712e86c98c66473d50a494",
"main.dart.js_258.part.js": "ff235e125ee70903e93f5ff87846920e",
"main.dart.js_285.part.js": "d8fe604cab71e70d08c03538e53923fe",
"main.dart.js_265.part.js": "93896427ef98c4e5cb69668af4f1001f",
"main.dart.js_274.part.js": "8e4332e3e56504782acf04ba71822592",
"main.dart.js_283.part.js": "b3c6adbdf3b361b066d668f5b703a229",
"main.dart.js_238.part.js": "14cf4644c8c05333a2c8cd9da6900983",
"main.dart.js_276.part.js": "cc0a7ad7dd98200a08f968f3af395070",
"main.dart.js_278.part.js": "9bf9a102a60d1579b431ab801929163f",
"main.dart.js": "64e848fbf116774e44dd5c1f684d9a93",
"main.dart.js_280.part.js": "afb943ff6813a65487c806331848475d",
"main.dart.js_207.part.js": "f466cd6f192dc1bcd90b16b2aa333aea",
"main.dart.js_257.part.js": "9b0431081a4495a3d0862d4db5c97467"};
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
