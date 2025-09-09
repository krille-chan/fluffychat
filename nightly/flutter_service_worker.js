'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "4e03cdddf6581689359fbc3b0227f5d2",
"main.dart.js_300.part.js": "85f3c4a2fcb48fbcf8554f3840e118d1",
"main.dart.js_280.part.js": "4dba77668d8d3016f8ad0c7e31d947c0",
"main.dart.js_324.part.js": "cb0a2affc421a5c457599ca83089e0cd",
"main.dart.js_301.part.js": "15f29e7cec2fa239dcbb8e704ae2b16b",
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
"main.dart.js_308.part.js": "52906963e680abfc7fcbc8c08af946f0",
"main.dart.js_287.part.js": "dec518a5b8f1dad7100b111c37aa852b",
"main.dart.js_275.part.js": "ba73cca55115ba9a07d45429b5ec5342",
"main.dart.js_303.part.js": "4296ee9ff454376f84845f3290598aa1",
"main.dart.js_319.part.js": "719385aa7d115b3d949e5bfe8bd51aee",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_237.part.js": "ea0119cecbdc59676c6007bda452ca5c",
"main.dart.js_279.part.js": "fbffce0f66ddf1b5f5c6c6848810a637",
"main.dart.js_289.part.js": "a5faf65e649307888e1328475992365f",
"main.dart.js_302.part.js": "565dd82cd9f43ab596c8c0f893ff8652",
"main.dart.js_269.part.js": "a7a3f169939bc8fbdd262cea1514e93b",
"main.dart.js_229.part.js": "c4ffe550fa19ec2db2d0e1c2422aab8a",
"main.dart.js_304.part.js": "661d6bba8a05fc188a34b9a2c11f1a5e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_318.part.js": "ffd01aca7287ede22f9a4ea122b4d7d8",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "5060497094f064c5c75c5b892acd8abd",
"main.dart.js_296.part.js": "a031d979f22a892ad096ffd6cb1abaa3",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_270.part.js": "4705298f40bbbf316ba715610e88c2d6",
"main.dart.js": "29568827a318da2d7372acb8f5e9cec0",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "eac2d40446f4c9e3c1ae22e61f930d96",
"main.dart.js_246.part.js": "cadf9879bbcb10ddfd72365d5f7eaaa3",
"main.dart.js_1.part.js": "0f2ecdfbcb1835f43e6c8a5cb9c4fd0b",
"main.dart.js_211.part.js": "e76a619b58e0c6b53cac9346482d43e0",
"main.dart.js_294.part.js": "bda5ee23268b4b54147e098b4e25b66d",
"main.dart.js_320.part.js": "a3f6a27b707a74f6b486dbed3f4031a0",
"main.dart.js_313.part.js": "6bd242c660eda46cbcec9ca2eb7cfd05",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "cbc5ceebf42e396e60a932730ce481b1",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "93b217386f2c4feb538d47876b3b8055",
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
"flutter_bootstrap.js": "9436c201205e6197feacc564868e1662",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_214.part.js": "8d650fabea1a931e10af5453a3ad9f7c",
"main.dart.js_264.part.js": "bcc7d4acc03e5f9d7240627c5f9d60d9",
"main.dart.js_321.part.js": "cb684c46010a071c4227cee026d0a8d0",
"main.dart.js_286.part.js": "65a7436f4346b32b12007b3caf017a99",
"main.dart.js_256.part.js": "9141a4b42723b41ad0b867c2d02d00cc",
"main.dart.js_268.part.js": "c761edf3cb112afc25d203ac14ea44d6",
"main.dart.js_255.part.js": "291eea6f6e97a14c4396f0780f654e62",
"main.dart.js_226.part.js": "03518835c0e455ec0820aea5339a1a13",
"main.dart.js_266.part.js": "f2c7402d1bf32041a5ca06f33ba53aa4",
"main.dart.js_278.part.js": "3c6ae992813f145d76011c4bd94f243a",
"main.dart.js_323.part.js": "73428c597b7c17edbc82917e5081e994",
"main.dart.js_299.part.js": "80242767515842cc775c4a93f4dc5a63",
"main.dart.js_16.part.js": "fb13b3026c2a65beeade9e8110b8fb71",
"main.dart.js_222.part.js": "ee089ed29bd3f477736105150d588c22",
"main.dart.js_243.part.js": "ae69947718a7cf88951f8962268c399f",
"main.dart.js_322.part.js": "3ae5ecd6f553f2056f473c590af6fffa",
"main.dart.js_258.part.js": "55547b0fde26d0b6a1fb58953f2e7914",
"main.dart.js_307.part.js": "5c9c9d0720fd7e7b5b32be87c00a62d4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "39da079bd8cd8e9949c3912e763bdf1b",
"/": "39da079bd8cd8e9949c3912e763bdf1b",
"main.dart.js_315.part.js": "c1d9c1f90bb68721e7cdb7bdea85776e",
"main.dart.js_306.part.js": "e2a1512c588a1912223da65b51b05bf5",
"main.dart.js_317.part.js": "118585999a099be581922d6f15ec9d67",
"main.dart.js_262.part.js": "90783827404df37fcb5222fc3b41377c",
"main.dart.js_309.part.js": "5ff85d274e479f52a0aff5591fdcfc23"};
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
