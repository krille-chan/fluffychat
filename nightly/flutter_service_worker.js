'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "7b0b5a1a16982661b346c2176f5593ab",
"main.dart.js_300.part.js": "0348a1c95e58f51a5d27191ac832ee16",
"main.dart.js_280.part.js": "ebbcab6e0ca277f69a4ed7327b7c3646",
"main.dart.js_324.part.js": "7dde391d574d2c249e5644febf58a3c8",
"main.dart.js_301.part.js": "2ca5c76af7c4834a6747df1e1331949e",
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
"main.dart.js_308.part.js": "5cf8bbcbfc2b2aa6b3fe446f45eddd90",
"main.dart.js_287.part.js": "a22957af6208f8f6105f69bec166416a",
"main.dart.js_275.part.js": "7ac885f21e2570907e01580724fdc8fe",
"main.dart.js_303.part.js": "fb719d0890901a8f1c4622adf9f92bb9",
"main.dart.js_319.part.js": "d88b62eba0c8eaeb8446fa23d90851da",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_237.part.js": "02e5e66a64fd9279e4cba5aaceb5663d",
"main.dart.js_279.part.js": "70f0b69d0e7d8622b619a708d2ad98a5",
"main.dart.js_289.part.js": "0f8f6d99a3578e738c7192f7436f9170",
"main.dart.js_302.part.js": "9b6186bd27c3e2dfc2227ce26d3a30c7",
"main.dart.js_269.part.js": "5a9ecb20e41850ae561d0fa42eb77243",
"main.dart.js_229.part.js": "b8fde105af919043f83ab625d03e185d",
"main.dart.js_304.part.js": "05fd15a72f7ae4867366397ce87db475",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_318.part.js": "540a5d71bff1c3c70982f2029c06d8c9",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "5619f3b969edf3e758f04c9ec816c74c",
"main.dart.js_296.part.js": "ff6604a774b07290de24b007c9e58e36",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_270.part.js": "1c688e6a4ecc96d6f184fb72765c405e",
"main.dart.js": "f2bf32e13d132d07f392d9e92abbd029",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "c39c1eafc6ec4777c92d64109488989e",
"main.dart.js_246.part.js": "df2a9bee7a9279c0d3ff48cf54523b6f",
"main.dart.js_1.part.js": "1f76c3fc3d16359296436f1aad2db25b",
"main.dart.js_211.part.js": "5fc7a47786c774acf58846a684d311c4",
"main.dart.js_294.part.js": "b25208733437b3586b71714cdf215394",
"main.dart.js_320.part.js": "e5e8f08fc28407e9317be169761fa39b",
"main.dart.js_313.part.js": "0303da369914909f88d3cc911aab6ef7",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8cdb09ecd8d7d1c9d2c51db5fcd9aec2",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "363888039a0d0a51fcde0cddcedc5cb5",
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
"flutter_bootstrap.js": "811bb7779a9dae73aacbda2b45c787cc",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_214.part.js": "ec868549fd7acd093c5ff6a109f24bf2",
"main.dart.js_264.part.js": "71b363c188874297348936b0b2c454fa",
"main.dart.js_321.part.js": "cf524b2a19e2f8557eb1219f01dd0979",
"main.dart.js_286.part.js": "b8fd4441e0433b4708c0dbf173fed968",
"main.dart.js_256.part.js": "135d8d6997c828632d5f9030a2bd1af7",
"main.dart.js_268.part.js": "efe9f3bb32b05825f37fbad74f4c63b4",
"main.dart.js_255.part.js": "4f621e54f7a4881358edfe79607c02f8",
"main.dart.js_226.part.js": "1e019bc08e43a7cde2de5d3aef852b60",
"main.dart.js_266.part.js": "fbcddb95acb0062a8e84ea8c87014ea6",
"main.dart.js_278.part.js": "2ee6ebdd1b08d2eb48c3aacebf903458",
"main.dart.js_323.part.js": "48956301dfb2752ca270eb6cf75823f0",
"main.dart.js_299.part.js": "fad9512134d103230770f42760e8a290",
"main.dart.js_16.part.js": "06f46c61f0ee9fb975ae7fcd79127172",
"main.dart.js_222.part.js": "71e89262d601efa0e98237523a5a510f",
"main.dart.js_243.part.js": "831d1c82b711cf3ba438b469e4b5ea32",
"main.dart.js_322.part.js": "fbb6fba0acae4adf36a2461766d8a636",
"main.dart.js_258.part.js": "c3629ddd0a48a58a6aed8566b5eb940d",
"main.dart.js_307.part.js": "443e9f21a41ecb5605dff8dd78d331c2",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "e273e4c0e330cff690948a331914ad84",
"/": "e273e4c0e330cff690948a331914ad84",
"main.dart.js_315.part.js": "c69bc783f1d3f858cfc621e0e66e5d78",
"main.dart.js_306.part.js": "0893f0be69b451cae5951e3257f17e2b",
"main.dart.js_317.part.js": "b338dfe8e8beaf2176904c034e2cd708",
"main.dart.js_262.part.js": "b815fab4a0ad17b39f2da4ceb934d645",
"main.dart.js_309.part.js": "97f5ba6fdd6a71faa8d649dca364fcf0"};
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
