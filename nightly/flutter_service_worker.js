'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "2b71e865c27ac982332955e8f1f9cd77",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_317.part.js": "660479272019d636042b9c8345ec197d",
"main.dart.js_297.part.js": "b79719c3a908cfb16f735a0564c39e72",
"main.dart.js_1.part.js": "5c3a9743a177403cafc4f772149bf3d2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "4c52adf331e4fb08d0723931963c0919",
"main.dart.js_280.part.js": "b3bbf42bc929c7360aba8133288574fc",
"main.dart.js_318.part.js": "0aee16c44c59bcb306ea9ebd6d625db2",
"main.dart.js_266.part.js": "212cf6489ff37a7bc1df41a287f95371",
"index.html": "0c073cf0971d6f51c2f87c49ef36e26e",
"/": "0c073cf0971d6f51c2f87c49ef36e26e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "ab2b8fe9fd4f75b88abab666d9a20c31",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "c548dbaaf073a81cc3bfda52bb7eaf66",
"main.dart.js_300.part.js": "b4a72545b4dd0355ec5ed6fd901bda61",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "9de81db70560bd9342079b3826a8d6d9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9357c76127444b43171bafd2614b3485",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3bf888040a3a4aab43d4c59b8307c58e",
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
"assets/fonts/MaterialIcons-Regular.otf": "ba6850df3f567a02f3e4138adbb19518",
"assets/NOTICES": "21facb93fb24950610f982412598160b",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"main.dart.js_334.part.js": "2db445702f0488aa0e1517703d1134e3",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "5927293d6ea8e662dc5906ccc27b30cf",
"main.dart.js_254.part.js": "86701b14d2fa526c1c79eeb78a501f62",
"main.dart.js_16.part.js": "c8a5793b9d40444c9663f9525cb373a4",
"main.dart.js_239.part.js": "eb21c885609e5247a593ef12982ac9b1",
"main.dart.js_286.part.js": "9caf0da23ebe17e928f12e44040e839d",
"main.dart.js_333.part.js": "439b1eb0c41ed264c3268213daca3b46",
"main.dart.js_331.part.js": "b0fcba823151da01cf4d5cb52a7191f4",
"main.dart.js_257.part.js": "30d36f6b21b9f48848f9c6be0a5b03f5",
"main.dart.js_290.part.js": "7c1ce9b8326391dcc7e3a6e8e92d71f3",
"main.dart.js_269.part.js": "f1e34a46ccfaea7e08c0def81c340099",
"main.dart.js_267.part.js": "cf97ebeebe504db9c0e7969e36677209",
"main.dart.js_313.part.js": "3813f2058653580d7cabef76baef6b2d",
"main.dart.js_312.part.js": "6b4c5b2943141609cfd1588e22fd88ac",
"main.dart.js_325.part.js": "b98a15ef8d20411a905b67c758324821",
"main.dart.js_298.part.js": "631b76e6157b4d64139883dc175bd63f",
"main.dart.js_285.part.js": "7aeb51a47a83121aa4f5fb9037921d2f",
"main.dart.js_273.part.js": "3ae98b8f634b56c019f604135a7f2d46",
"main.dart.js_248.part.js": "b59753e4b7e300476d5fe0faf4cd2d55",
"main.dart.js_275.part.js": "3db27c47e74e4b396b7b1c79e5917576",
"main.dart.js_281.part.js": "7f86bba1f1b806051e648f153c1cbfd8",
"main.dart.js_332.part.js": "053094d3912243075152297fd24db014",
"main.dart.js_314.part.js": "6ce16a9900b25d05acb4729d81ca8e28",
"main.dart.js_307.part.js": "caf4be24daf2f7be0974b3bf8b4bb004",
"main.dart.js_279.part.js": "e73d471a020b50ac7fed1fefd72a7b72",
"main.dart.js_216.part.js": "6e78527bf1e903d084989bbde4012a59",
"main.dart.js_319.part.js": "5d7649d162bb700cda04721822500c69",
"main.dart.js_335.part.js": "a3c8c036745ba2f27b8eb0b63d7f0d1d",
"main.dart.js_218.part.js": "211745ec192bffe0a216bf96eead778f",
"main.dart.js_324.part.js": "ac3da7e2a91b7e5d802a47d825d0b8de",
"main.dart.js_328.part.js": "5c4ced0a76bfe8b885c22de872e578b8",
"main.dart.js_289.part.js": "107f2975deb75b280b91cb1acee1fdb0",
"flutter_bootstrap.js": "fd1301cf35f060a6515351c3bf7de662",
"main.dart.js_315.part.js": "908c1afa20236c3391937943a9b7fe14",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "5ac183b52c4711904e0d6e1a25ff8f31",
"main.dart.js_326.part.js": "078a8e6996270fb6a6839d6fb04e423d",
"main.dart.js_329.part.js": "2623cd417719a1fb5eb5ae36855752aa",
"main.dart.js": "395662cda02d02acf234cccd57daa33f",
"main.dart.js_224.part.js": "750b55739edc6008f7c10ca8f4440ce0",
"main.dart.js_236.part.js": "bbdda71e1fe037fe9533c109948fd98f",
"main.dart.js_277.part.js": "fe6582917b3c336ae5baedf7fa8559f9"};
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
