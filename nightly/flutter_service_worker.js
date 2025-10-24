'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "f11136cca22d459875dc72c3d2f3b9c8",
"main.dart.js_317.part.js": "a30618055c9482de5814331c9d22ba4c",
"main.dart.js_1.part.js": "0d39712ea9a7f28ab8fdde0fb7862374",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "b48f9f0de0ec3cea409885170acaadea",
"main.dart.js_274.part.js": "76f73749c4367e55a2457232ee3656f2",
"main.dart.js_318.part.js": "55d57993adb0a12df9e94a0c229e60d6",
"main.dart.js_295.part.js": "f1c84d16a2abbdcbfeaecf62f5b43f5f",
"main.dart.js_316.part.js": "4b557274a64795ee0b92393eabeb5203",
"index.html": "7d26e532675a4c5797f8ac8950eada42",
"/": "7d26e532675a4c5797f8ac8950eada42",
"main.dart.js_302.part.js": "a8cd37897a786b8e9a81e500996ad026",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "5bf1efae1faf5c4d160c87e15caf91cc",
"main.dart.js_242.part.js": "e56cd1874a732132c1d2a35351c7c194",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "9dee06677f08e2797da2e9356429c2bc",
"main.dart.js_300.part.js": "9868c78c78be7cf8d772c38fb71940d1",
"main.dart.js_261.part.js": "553524ff538c57982edbcf904035c754",
"main.dart.js_299.part.js": "62156ed49929bed846b4a7b50ed45d1e",
"main.dart.js_322.part.js": "4e8a3659a4fe9ddfa2af684ed044372a",
"main.dart.js_263.part.js": "3901193e27fde4b98a063a87254a300a",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "288e0a9409c43d10fdbf9c74ab2348ba",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "128bcd72739549260b896e6e7915bde2",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3a20249a2e4012526cec1bfc5d9e92de",
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
"assets/NOTICES": "495155e4ec600fd53a6a111344ecb69b",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "822fab533ef0a6256e51793c93c2ae17",
"main.dart.js_254.part.js": "473fe42b6aa0ebcde0f15ace924f4f02",
"main.dart.js_16.part.js": "358b60bde1c15a8d699ecf8694345aca",
"main.dart.js_278.part.js": "2c60869d0550d1d3f098970f5ff1ff98",
"main.dart.js_286.part.js": "08ac12bd1b570b1b866754a0b84b4a8e",
"main.dart.js_303.part.js": "f0396e23358a4f5a187dbec5b684a7c7",
"main.dart.js_257.part.js": "98c6869c92df9a7c80d41f4b9fc7725f",
"main.dart.js_212.part.js": "a183a729e8032d6c268c4dee00e79267",
"main.dart.js_269.part.js": "a537cad134fbda4fff76594827d3e102",
"main.dart.js_267.part.js": "8a1e5416b2257a9e95bed4db87145a5b",
"main.dart.js_313.part.js": "ba78eb5bafe263c213bdd96319ce5176",
"main.dart.js_312.part.js": "3284c8939bc30d3c7b4fefb290fb1642",
"main.dart.js_298.part.js": "d28dd553836675fbac7a510f28199a43",
"main.dart.js_285.part.js": "784dce1ef770954c504c9521e57b0f47",
"main.dart.js_321.part.js": "d358f4991afffc7082b3846566cff752",
"main.dart.js_273.part.js": "22da244b7c259234be11fa7d563aa41d",
"main.dart.js_255.part.js": "1a31853350470934e57fbe8fa1e48a04",
"main.dart.js_268.part.js": "d685935ccf2339ef2b2d03b4e890c7b7",
"main.dart.js_288.part.js": "12b08b8d849282c7f19f4631e25f3e10",
"main.dart.js_314.part.js": "397377c06b6c4aa450022e1f01f27ad1",
"main.dart.js_206.part.js": "55f35154ee39ab444544afe937bce4ae",
"main.dart.js_307.part.js": "650fa0925ee82b0e4c0f6f1d207b6934",
"main.dart.js_279.part.js": "48d4f3f16345ebd552884be97cef6923",
"main.dart.js_319.part.js": "e9e7a66d0e6c3481c8942dc60d9f844e",
"main.dart.js_253.part.js": "13bf76e94db3198964066d465592ab6e",
"main.dart.js_323.part.js": "ce78f15344a2e085ce3f75680b61d120",
"main.dart.js_227.part.js": "4cd408ffcee91e430e5fc846cd81700f",
"flutter_bootstrap.js": "d6dbd5e611900fde9686ea37ca58d8f8",
"main.dart.js_306.part.js": "941b04b7614f6b2466ec465f3b796729",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_293.part.js": "d5cf5fbdcddd28997b43eedf34f46051",
"main.dart.js": "329b51b072b86faa19eef595c4afb966",
"main.dart.js_224.part.js": "8937703d394c21a86cab8a7976b869ff",
"main.dart.js_204.part.js": "3ede15ec1da141c159b7911b270d2c97",
"main.dart.js_236.part.js": "ad92d024f2ba18f2583dd50a183e8212",
"main.dart.js_277.part.js": "99edc5a1cadefffab9a004d57a572210"};
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
