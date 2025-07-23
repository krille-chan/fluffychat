'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "042db691b9eb272e246cca7592894a1f",
"main.dart.js_268.part.js": "8bbe5c767c9a95e8cdd7b67e40ee1e6f",
"main.dart.js_304.part.js": "c7ae9930f697c197ae66d46e24ed21b3",
"main.dart.js_229.part.js": "a68c0b106b684cf6f45d73932b8b4521",
"main.dart.js_256.part.js": "0dd8dc410781e332993ec3c814fa3dd5",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "48aaeb707ec50acc64248c04983846e5",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "247fe09e96a77f161802173eebe598a1",
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
"main.dart.js_211.part.js": "709e83725434bad29cea1e35a1343a8c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_302.part.js": "0acf0d0614f3eb73ee5c87628e4afa0e",
"main.dart.js_320.part.js": "e3a9c6affd4b2aa3919928f61289bda2",
"main.dart.js_321.part.js": "d84dbe53643083b39ba713adf2e4bc49",
"main.dart.js_255.part.js": "a9e457a96fbd04fc2d8be1c8100769a5",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_315.part.js": "a2bcce7f09d940f51133b7196b75cb02",
"main.dart.js_300.part.js": "af73de16980894fa52cac05ad180dc17",
"main.dart.js_309.part.js": "cd9097d77ecb68da9e86eaab78e6d75b",
"main.dart.js_228.part.js": "3f2f8473e52c6eeaf9cfb3df83bc6aae",
"main.dart.js_296.part.js": "52846fb440ac078663339cf293afe452",
"main.dart.js_246.part.js": "bc242d79070df8b2072a6c54785b1ab9",
"main.dart.js_270.part.js": "27130b2d97201fc174065cf995c52ff9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "38d1bfe30bdff19e5a8dfc02d84b2e44",
"main.dart.js_227.part.js": "8c0a374f6f62ecb0d7cabf72edca0c3a",
"main.dart.js_254.part.js": "7d0cfeab948b64237cc7464e68dfea3c",
"main.dart.js_289.part.js": "ffe74d17128512f63defb88fc5981d9c",
"main.dart.js_279.part.js": "cf12248433fcbd62c0050f9bcbf9e7c8",
"flutter_bootstrap.js": "d34507f96349afd7347b24b563ded9f6",
"main.dart.js_264.part.js": "8cd5f1fa10d7e954a5a289b54484cf75",
"main.dart.js_319.part.js": "e14f1a94468af927ff224bdcbde33145",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_214.part.js": "6638f893721f3e13595eefea80e9ca1b",
"main.dart.js_294.part.js": "84ec89e180de1663831902b6996d65d2",
"main.dart.js_323.part.js": "135efd98b8d65fab4f05830870c261e3",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "c02e18f81081037441df8af7c2a19355",
"main.dart.js_324.part.js": "9e9fda372f852ffe78150f93d99c9c59",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "77bc0321410570dc2f88d27ef86189b3",
"/": "77bc0321410570dc2f88d27ef86189b3",
"main.dart.js_299.part.js": "cb09fdc99e48c09cbdc7e048b5865e85",
"main.dart.js_243.part.js": "d0269bbf1ddf4efb2c033178a2ce4633",
"main.dart.js_301.part.js": "08a5ae70feef4e22c769c35137c5c2ff",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "68b467e88c973ff52bc1f982c1c862fc",
"main.dart.js_317.part.js": "6c407704780018a4ba453b1c378d494e",
"main.dart.js_286.part.js": "4df6456cca02895ca5187ceeea83dd29",
"main.dart.js_275.part.js": "4a3c3d15f7f62f8a4d3f93ebbb104204",
"main.dart.js_307.part.js": "21303325648143d330545cb2edb08c4f",
"main.dart.js_266.part.js": "c0ca0cb4a11b3cf44059d26c8944123c",
"main.dart.js_269.part.js": "7ab3133af65ebbe6ff1dafad05005568",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_287.part.js": "a3d2b8e35ea9afc1db2a0695d57e476f",
"main.dart.js_237.part.js": "8c775023d2d633963672b9232196f34a",
"main.dart.js_303.part.js": "295aafdbb8351959b2f29f2eaeed26af",
"main.dart.js_1.part.js": "b59ff721e70d787c3e7e0574651d097b",
"main.dart.js_258.part.js": "90b919d9b93171b664788f2797e90ad3",
"main.dart.js_313.part.js": "3bef471ea34f46037be177f593e208e2",
"main.dart.js_318.part.js": "1c699c64b980bcdec86970e1ad75d3d4",
"main.dart.js_314.part.js": "2f263f67feb240f48d8c5321faeb8fd4",
"main.dart.js_274.part.js": "90cbb6caab0886fcfe7a1d81b9606a6e",
"main.dart.js_262.part.js": "5e2722e17a9f757e18b72f4976570221",
"main.dart.js_278.part.js": "2afddca455cfd021815abc8dcbbf3b3a",
"main.dart.js": "19e459c81ed56f2db7aa7fe41ba1ffda",
"main.dart.js_280.part.js": "ab69076edb47f21c3c24c99c2302a91b"};
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
