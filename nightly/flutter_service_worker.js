'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "8aeca87baaec8946d029bc6c5566f3f1",
"main.dart.js_234.part.js": "4f058e38fc2521cfe722e47c0c087fc3",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "828012138a600dd82f44438d0ee72a54",
"main.dart.js_1.part.js": "0f5bd83cc250a54af569b86b308c2ceb",
"main.dart.js_284.part.js": "eebfc1f1a5ddac3c806c136b6b6dcb06",
"main.dart.js_216.part.js": "4f0945721f3a2474708f121ddb86d33e",
"main.dart.js_296.part.js": "ef45088945c1508790af51b220ab19c3",
"main.dart.js_305.part.js": "ceec9ee819446cb48c2acb05c6940132",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "d936b085e44c8904e5eeaf3d014686d9",
"main.dart.js_277.part.js": "2e16f4da71537528c9daaf6ca714fb30",
"main.dart.js_265.part.js": "0c1beda0e509e007ac9f119a2eac9d6f",
"main.dart.js_315.part.js": "c9bfe5f159db1a70d128eb11c061908d",
"main.dart.js_323.part.js": "4964a2cc19c612e264a144bc03a0b2ac",
"main.dart.js_295.part.js": "b93fb47d990ed09e59f6e4d152a06dbf",
"main.dart.js_278.part.js": "5363cfc3c6da1ab7911cd69ee163ad0e",
"main.dart.js_312.part.js": "746d9a1ab53166d2b8b07ced9bf7c31e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_332.part.js": "0ca91e0c56a326ff810a7cd48712f4ee",
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
"main.dart.js_298.part.js": "1abef6acdf1badbcebb7d0eb03de53c7",
"main.dart.js": "b11f926a69f442697847da60d745eb20",
"main.dart.js_275.part.js": "5f7f0deb0187b97e8c074c2490d96fdb",
"main.dart.js_326.part.js": "218fc41cc019aaa2543d0bb75b6fb295",
"main.dart.js_279.part.js": "47c76883dbc4886afa769dc27052287d",
"main.dart.js_324.part.js": "4bdb504b60c031516132074b5252c0a0",
"index.html": "58192e018f47eef091d27308e461aee0",
"/": "58192e018f47eef091d27308e461aee0",
"main.dart.js_318.part.js": "24d77c15fcf3c64592cbcdca021fab32",
"main.dart.js_222.part.js": "a40911b24b9aa1e0475f408ae2639996",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "59567113aabc66b709eb83dfde84ebdc",
"main.dart.js_273.part.js": "af899f3ca40af884d946c5c99ec69d88",
"main.dart.js_264.part.js": "095f4b15c463640435da49652f4c4333",
"main.dart.js_267.part.js": "1c47df068bbc0fd5eabdfebaf799f697",
"main.dart.js_288.part.js": "f820faa0578993e853f5e715927fbcdc",
"flutter_bootstrap.js": "8834547f51f95676059fa44d28471790",
"main.dart.js_322.part.js": "3e3c4da1144b9cb259bd624e587a9607",
"main.dart.js_308.part.js": "e7aaa512920f897e94082f1f44733f77",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "d9aa5c36d9d7d591344f5703e2304c0e",
"main.dart.js_255.part.js": "47aa381c244cb19de211042bf4ca84ae",
"main.dart.js_289.part.js": "3feda2915ea31b5114cd23a3c9cba2a9",
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
"main.dart.js_283.part.js": "2b76030f1974d91974430e83f185e25c",
"main.dart.js_303.part.js": "39539fbaa34519165c0fa8a5a7de68eb",
"main.dart.js_263.part.js": "5b3f72bc506bd79dc8d2ef12c801fcc0",
"main.dart.js_330.part.js": "f8c3506b97cd912e29c83604f8019080",
"main.dart.js_317.part.js": "d1f2c01f4dc6ed2f3899f2bd584df458",
"main.dart.js_316.part.js": "f42f351d81d8a1a415855cdbc952ece3",
"main.dart.js_271.part.js": "9d5380e5c764a31275ba9c28d975e655",
"main.dart.js_327.part.js": "8c13adbebcaf4f20411c5721ab939c0c",
"main.dart.js_328.part.js": "57944f91b40ec4e839bc9440c05bfeb5",
"main.dart.js_311.part.js": "eba3249410538797e6e75452a68dcd73",
"main.dart.js_246.part.js": "2979768d08da0f06ae6e1b7acb096191",
"main.dart.js_310.part.js": "f6ed379da491b1f5094579a1e4b1076b",
"main.dart.js_252.part.js": "215c519ff015999e81aeec30e10b1ae7",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_333.part.js": "c3f3e4c1e63f1db1636b85c05ac88d39",
"main.dart.js_237.part.js": "4366ce7664331bc999ba7f8564132f62",
"main.dart.js_214.part.js": "a37f525fa051582d15b45849e367190e",
"main.dart.js_287.part.js": "5943d3ace98fc83d90eb5602e673da76"};
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
