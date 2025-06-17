'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "e2b622f1a999dbc72db4d5a5a534bbdd",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "f6528b5e849a4edf0fd74260f48b8939",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "edc8582446ada484ee8c17bce9c6637a",
"main.dart.js_274.part.js": "aad4e2dc46d8650975a4d4857eb0293a",
"main.dart.js_219.part.js": "0414df3579b10c068e9dcdfe0b63789c",
"main.dart.js_205.part.js": "cd02140c2f78d42a6da8c61acfe71d8d",
"main.dart.js_276.part.js": "ec8e16fb837c5332d340e2de117c57b0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "660e6572a2ac509679f4ab1c55bd4d40",
"main.dart.js_262.part.js": "e5a1e3a13010634dc836379d5f8f7fa0",
"main.dart.js_1.part.js": "631143f539bff7e9ec4e103184aa2bd9",
"main.dart.js_243.part.js": "ca462e4b839944ea41558ed760b4ce6a",
"main.dart.js_275.part.js": "493d7cea3b1a4fd56cf70da35e727ced",
"main.dart.js_231.part.js": "9f32c55e782401bb18e39e4a4c2d1d59",
"main.dart.js_269.part.js": "c378216fd42e0e385bffd6ab5e79be57",
"main.dart.js_298.part.js": "c280ce8c063f09864d42fc3d3386c0f7",
"main.dart.js_240.part.js": "ad2cf198801b636b2a275dd2fbcec608",
"main.dart.js_242.part.js": "d1e494c5e0548ac5ea61db0f8ca772bf",
"main.dart.js_283.part.js": "2489ff9bc43b608b240aeb9003499675",
"main.dart.js_293.part.js": "cf016f9c2741ba520d346ad84b276f23",
"main.dart.js_277.part.js": "d0ebccb814ffc5c0c30fc105fb97f1f9",
"main.dart.js_213.part.js": "bf4c616ff2848b56f7460857bf313878",
"main.dart.js_248.part.js": "d5da5e6d178bceb41551e2cb7b1f01ac",
"main.dart.js_289.part.js": "7fd38b27da53798a0ff0a8663f783f92",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "47fcff284f4b42ce3a0a9df8e0a61862",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e3c4ff4cebe742cd5e83688287a0447a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "cfcddd743db706513e20aa098047110c",
"main.dart.js_297.part.js": "d7b3716dca2900c254412268a6135cd1",
"main.dart.js_192.part.js": "134f457b4ee182622938d08c7d9533c7",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_282.part.js": "70434b6449b39b2f1a97bc2ae2a06af3",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "d4364200289f1120b7f6d270239a283e",
"main.dart.js_230.part.js": "246e87d599728e3d7ae32785df6b5d00",
"main.dart.js_238.part.js": "68978e500e63a9d6cebbfc4549b9aa65",
"main.dart.js_253.part.js": "bcef1fbd9cc69a60b58f11b295fb1fad",
"main.dart.js_244.part.js": "8fbd39d6e88f67c6a234ccbeab8760ed",
"main.dart.js_16.part.js": "73be4961bc338845cdffc3b0e02afc20",
"main.dart.js_294.part.js": "5142b94b6988e66533d51f9fa4e20e63",
"index.html": "b8d1ef6169a0a60041e5c8ea91186ee4",
"/": "b8d1ef6169a0a60041e5c8ea91186ee4",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "6022e1eabc32446d851500b861b879c6",
"main.dart.js_245.part.js": "5720f54c3d08ff5e1e22aa45eb81c6bb",
"main.dart.js_291.part.js": "c98a58077963149f36c68be0467eabf6",
"main.dart.js_287.part.js": "7cd2c40ecadd78fa2ac874d6a6f67af9",
"main.dart.js_233.part.js": "cebe6ef43ee0cce206c6f0e98b8bc760",
"main.dart.js_273.part.js": "d8688fb41b15257ed1ca045eb5337622",
"main.dart.js_296.part.js": "f8fd897071f5dea81b9bb3ec00a888f3",
"main.dart.js_278.part.js": "ca921e0a8790ca6b0c7396c5f8159100",
"main.dart.js_292.part.js": "610973ddfca79f34cf40666d9f4e802f",
"main.dart.js_295.part.js": "e26cad239b4d2a237550ae8536b15989",
"main.dart.js_221.part.js": "ff0a762bdcf9a60619e6afca37700a36",
"main.dart.js_288.part.js": "04c74bceb0f4f68d44cfe4fe083e8ba1",
"main.dart.js": "02d5e4f3a91635f7f752f2b73b035fe4",
"main.dart.js_280.part.js": "4ebf57d3a5a8ccd36ea960e49185b628",
"main.dart.js_261.part.js": "75f49e0aa15c0ea1d555d754a0578633",
"main.dart.js_203.part.js": "8a23375c57061fbbf1ef9c73ce42ba46",
"main.dart.js_254.part.js": "d30516c700d42eccc804dbcc238909b6",
"main.dart.js_271.part.js": "84b91b8d5a00993c263e5c5731d7a78f",
"main.dart.js_281.part.js": "5e48886d136c2f63572f80e0dbefa566",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
