'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "40f8f5ced35651c5f50ed1b2a27bfa36",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "202f99ca7b465cc73343b3d76e8caf6b",
"main.dart.js_276.part.js": "a36d7f161f50269d70b78f7948a8dab0",
"main.dart.js_1.part.js": "aaff255dcc7d3e99c47744d926d49a80",
"main.dart.js_284.part.js": "dc771a9a93a73a9c8e2eb7314091a56f",
"main.dart.js_325.part.js": "09c515feed37115199036cd102a21ccd",
"main.dart.js_247.part.js": "e0f5a9e39a775df85b8542aae0bc982b",
"main.dart.js_296.part.js": "9f6cbb0116a595bec70adb039678d5b7",
"main.dart.js_215.part.js": "74f9a28ded10b95a2bdb2410ac642097",
"main.dart.js_253.part.js": "2cf2d76256fc2f6adbe0ad9632d3c462",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "d936b085e44c8904e5eeaf3d014686d9",
"main.dart.js_265.part.js": "3d38ca85f2a74a23a843282eed160025",
"main.dart.js_323.part.js": "8ed8e56debe7bf1136fcd441fdda4b83",
"main.dart.js_278.part.js": "fbe8126083107c192eb83bf70a8d2f81",
"main.dart.js_304.part.js": "1ee4600a12e80441a374bbb3dc3bc291",
"main.dart.js_312.part.js": "13edc9b16968fd219a8c398f784ed844",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_268.part.js": "7348275c7510ae0d019e383e5cfd92b4",
"main.dart.js_332.part.js": "c8a3b81e3fb42065bebcc8bee54068b8",
"assets/fonts/MaterialIcons-Regular.otf": "ba6850df3f567a02f3e4138adbb19518",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "ccdf35ac6bd19b2bb529bd7a40361920",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "12b647a2f24e7587fd288474bf6c3a65",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/NOTICES": "ccc7b438b6733657324389d49423afca",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"main.dart.js": "244bc41068a0cfb5df35d1037806edf1",
"main.dart.js_279.part.js": "2a037f7544ca8cc798fd32e26d77cb65",
"main.dart.js_324.part.js": "477ce9d021b2e1cb07720fbd52d5a0dc",
"index.html": "00d32d87d8c7365d0eebc17093c2f46e",
"/": "00d32d87d8c7365d0eebc17093c2f46e",
"main.dart.js_297.part.js": "461718de15a91db77f9810a790e7bafa",
"main.dart.js_318.part.js": "730f5a6652e1c046156aea03b47d1db7",
"main.dart.js_290.part.js": "16b53b6d1c8fe0988f3c5cfb912af92a",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "59aa22907e90a4d8413d3b1c9a40b783",
"main.dart.js_274.part.js": "7afd729890fa29b3dd8c8e881ded8334",
"main.dart.js_272.part.js": "22c9331186ed481b3c5fc5e8745c566d",
"main.dart.js_264.part.js": "ca12d7033d39e943e29d1341d237674a",
"main.dart.js_288.part.js": "90622acc4c0fdc3cb32e02675d387b31",
"flutter_bootstrap.js": "6ff66043bdac3d62371b2785e19a6ec8",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "e67229a27e87ca885f4b2d70eee6c079",
"main.dart.js_235.part.js": "2179bc81eb001b7581cff983143db08b",
"main.dart.js_280.part.js": "7d2ca7e4b18bbe77d4ac10f7a4a8f0bb",
"main.dart.js_289.part.js": "fad0493aa126ad4e5412d9e21da8c8c6",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_299.part.js": "c51256e2405b7ab6b4d7e7025e7e2d7e",
"main.dart.js_217.part.js": "16e752134c5fba716bf65bc68dc66204",
"main.dart.js_330.part.js": "0e2529602095d19d71628dc866b24af6",
"main.dart.js_334.part.js": "4894bf4e4b264537b46cf54dd6d90416",
"main.dart.js_317.part.js": "a8d93da7df5cd38326e03d9c573c7cee",
"main.dart.js_316.part.js": "685b9bb564b39068bb44dc4a61b0b2f3",
"main.dart.js_327.part.js": "3c5620dbd3249722331cbb2aaf320acb",
"main.dart.js_328.part.js": "5e9375352962e82fbef3e723933315d6",
"main.dart.js_311.part.js": "504b7e81f8010efbf9ab786a2786a461",
"main.dart.js_314.part.js": "4023843300f24cf846e555dfabc7bb3d",
"main.dart.js_223.part.js": "cab306fd43b3d78faf83ad375db7ff9f",
"main.dart.js_310.part.js": "9802fc36df1609cc460618ae2ecdc88f",
"main.dart.js_319.part.js": "08657b4616a08117ec1f17a1022537d2",
"main.dart.js_266.part.js": "de91fd9bc5b5c2348f0e59dbc35db2f6",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_306.part.js": "5283f8d35fc230e3b34d07631e7f67fe",
"main.dart.js_285.part.js": "0b9dd1bb2b6567aa2f8ff279abb2deeb",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_333.part.js": "f6afe51dc2e6b1dcf518291350297519",
"main.dart.js_238.part.js": "48ee4739df931b734d0703e24e4d1641",
"main.dart.js_256.part.js": "1ccadb1f392386bc4b84b9cf3c9a7a4f"};
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
