'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "067664b144c2b459f37633cf4f20cfaf",
"main.dart.js_210.part.js": "c6f48a786eb4d7c470079d2a880bb363",
"main.dart.js_300.part.js": "e7add0faa71454aeaff5ba1ce0172ed3",
"main.dart.js_228.part.js": "086670c0f01f1e29e6438f9397a49df7",
"main.dart.js_257.part.js": "61ebbec95a7e78dd380174734decde55",
"main.dart.js_267.part.js": "23f0cb00cdf872b1fc2091efe85e1186",
"main.dart.js_301.part.js": "5d90d9325c74c14d7b41efcc63da09f2",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_308.part.js": "4a876093b552457eea7a3c7544150594",
"main.dart.js_303.part.js": "2c1ebf69f545d1fbf2760833935ed5c6",
"main.dart.js_273.part.js": "2a499c31047098e1e54c5fa018a13e81",
"main.dart.js_265.part.js": "76cd4f9963e4fa5fcc06bb86da9f4128",
"main.dart.js_319.part.js": "db44aab5565a1b35c2bec62899fab9ab",
"main.dart.js_221.part.js": "c7fc867a6c1731ab333e158cb7be7bae",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "14e5204e14b342719c8ff6c96fab53ed",
"main.dart.js_279.part.js": "f6075c25a0e83daa7fa1e4db1376e0b6",
"main.dart.js_288.part.js": "e5339d0cd19bbd4c3427e7687f48765a",
"main.dart.js_302.part.js": "66906613bed4bebc28d349008fa4191f",
"main.dart.js_269.part.js": "743875dba26d0dbb3e922e2723febdb4",
"main.dart.js_305.part.js": "3202d0a50034582707cb79095e134e3a",
"main.dart.js_293.part.js": "35c92cb5dedeb95f2b971796e51fb7d2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_316.part.js": "d554eb1fa70aa20e4d2786417f7f2c58",
"main.dart.js_318.part.js": "97d149df00d9b73d653dbbc4e4e36910",
"main.dart.js_253.part.js": "df09f26659275c44373611355ae07001",
"main.dart.js_2.part.js": "129e53aeaded23a57b4509eb0d1a370f",
"main.dart.js_254.part.js": "92c54323fc115108198b9cc069618a8c",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "82f68f418073c00d3c3aec5fb4f1f198",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "175b7d6eff4f7da6083c265e8ffbc48d",
"main.dart.js_1.part.js": "5f2952b6a824573d7e200f330ae0e0a5",
"main.dart.js_298.part.js": "2bca0d3bab51844422f9b7f29dea4238",
"main.dart.js_261.part.js": "6d263b6fad7a468fb497e227d79aaa6c",
"main.dart.js_320.part.js": "92d1cce3fc9b40665edb4bd43e671578",
"main.dart.js_313.part.js": "f2136adf8ac295660e6afe92574ac6a9",
"main.dart.js_213.part.js": "b5de589ba8a2b77455cd16bfac5062fc",
"assets/NOTICES": "e4de47dc388aff0d8444f8dc5820ee23",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "85d6315ebca6d83c8fcbf77fe5c9682a",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "b0714ea6b380eb71daca8e0ca51c1b06",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "11847788b7946ff12fb992d3646c5dec",
"main.dart.js_242.part.js": "16a815da0434236782e09a07e39ffdae",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "c2db3d2209360c00640b64e1a1ff7ff0",
"main.dart.js_321.part.js": "ca61ab18e2a99d5f55f3bf2492e1da95",
"main.dart.js_286.part.js": "da9eb36e6fe96d80e219d3f5b897f17e",
"main.dart.js_268.part.js": "1beda80a7c7a636eddebe7c28b036c44",
"main.dart.js_255.part.js": "3792959475f979cb67ebc5594a109532",
"main.dart.js_278.part.js": "3460c319b536f749cb0c9716fe2d719f",
"main.dart.js_323.part.js": "ef73fbb4eb5d628c43c49277bfdf4c82",
"main.dart.js_299.part.js": "a93354566512c5589dcc7f07767cd1d8",
"main.dart.js_16.part.js": "c4c8394bb6461378ecb8a0a63c95ecf8",
"main.dart.js_236.part.js": "01404f3006fe8c8aba192b15d9cf4e5b",
"main.dart.js_322.part.js": "369a0f7a8ec3e296513324e15fa3fb2f",
"main.dart.js_245.part.js": "8d78b57bcef7cef7444ad2f4250b0955",
"main.dart.js_285.part.js": "009f493da9b902ecc7d62f1d61601888",
"main.dart.js_295.part.js": "d98bbb7781b7a81d592ea84ab10b74cf",
"main.dart.js_312.part.js": "eb123f5a2950c86a02c681baa1a87f6b",
"main.dart.js_307.part.js": "84f1c822dcfa10dcac575fba319ad788",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "201192e61a20a4a7417a810207087bdd",
"/": "201192e61a20a4a7417a810207087bdd",
"main.dart.js_225.part.js": "290d430e1a82198bc8a2e43accf0c014",
"main.dart.js_306.part.js": "a4cbed6569c1718e18120bd85c3ca9ef",
"main.dart.js_317.part.js": "56440f4ae89ae9735b97bdfa6b55fbc9"};
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
