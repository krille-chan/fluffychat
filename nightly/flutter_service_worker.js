'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_223.part.js": "dae1ef1a98f097daa4f575acd3f9c396",
"main.dart.js_256.part.js": "25cea392b40839d54da4230d7f6eeb4f",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9cd756b777b020fff4a7bef998c9c390",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "931b28f30f021d26ce6a102feb9ca4ce",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "ffdca38215708d4e57fe39ae12d3be4d",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_196.part.js": "feffe723ce30b195990af43c90817513",
"main.dart.js_295.part.js": "3a4926c0e6c69fb93e68e7eb592f864a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_244.part.js": "fe009d0470bcef5ff83464c63938df1a",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "f018d46dcccc301ea699e8461055fd80",
"main.dart.js_234.part.js": "4acf2a7e28eff5da5b51f4674c00cb81",
"main.dart.js_296.part.js": "b3d3b6460fa68713fe7b38d0db45f196",
"main.dart.js_298.part.js": "395f4fd2f37a28f37604541fd79f82a1",
"main.dart.js_246.part.js": "d9541a8987319dee069f900b0808edc0",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "7cf698caf9451237ecdc8a86a964a3e4",
"main.dart.js_277.part.js": "c0ea47198d4e18bac0db95aaf105286a",
"main.dart.js_279.part.js": "d482bb1a7863c4a844bc5f9ce41f43aa",
"main.dart.js_217.part.js": "2beeeb20348bb0369ab74c6503ff5d60",
"main.dart.js_235.part.js": "731f92359223f5106b3cdf934d4a179e",
"flutter_bootstrap.js": "d379cc29934c17c144be186c449b0764",
"main.dart.js_264.part.js": "dee6b87cde7f4734e139a2ea2a8a66a4",
"main.dart.js_194.part.js": "b63fa785df79ada9b59b8d71bc02d72c",
"main.dart.js_267.part.js": "7c20ecc2a21fcee79b8cc3583d739922",
"main.dart.js_291.part.js": "17d1b33bbbfae850674caf89c0e76220",
"main.dart.js_236.part.js": "58b4ef1af1217b413f052216ad16b421",
"main.dart.js_208.part.js": "988bc8971769894456537bf9c32301c7",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_290.part.js": "7df748a7bace1dbd6f6ca394f1375398",
"main.dart.js_294.part.js": "5c19970654e1f739e2c7a325c7547e0f",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_209.part.js": "96350359865f0ad141fe80d89a9b6719",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "9447999aef261274b9b68654a49836d3",
"/": "9447999aef261274b9b68654a49836d3",
"main.dart.js_299.part.js": "ccb83b59ffd253d9a1bd759cd3bfbd01",
"main.dart.js_281.part.js": "e14acb86d19dc3bc9a3fa8f57b1e0bad",
"main.dart.js_242.part.js": "db9fd1bd1f85c46f9662eafd304ee9c2",
"main.dart.js_301.part.js": "49b8210041a1f7393c2a354f27ff3afa",
"main.dart.js_297.part.js": "a0c8a37c8e9d03a79f9ade5284381420",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_286.part.js": "422077e07257364acd20f468528fa96a",
"main.dart.js_292.part.js": "f601e98c71a3e2f6568df51221f59511",
"main.dart.js_248.part.js": "ff5f7db9f807bbcb20c00aa120728224",
"main.dart.js_249.part.js": "ef7de63c168cc40e323ed948a3e5ece0",
"main.dart.js_252.part.js": "68d1c3620f2253fb68f9b8493e9082a0",
"main.dart.js_272.part.js": "9baf641e1fab56fea741f2f4a91e9404",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "3142b316d17fc8f5848427cea33d96bc",
"main.dart.js_226.part.js": "d74f63dc022c0f591fd39d4056c5cfb2",
"main.dart.js_284.part.js": "ab0aaa814f06c6024781e679b7bd1095",
"main.dart.js_247.part.js": "bb42a33bf3a89e90442d260dce7b6c1e",
"main.dart.js_1.part.js": "42c66ded8015f4cd9204f210b1f3d639",
"main.dart.js_258.part.js": "d0076a4bc7962a1602d3701de1562a49",
"main.dart.js_285.part.js": "96bb5e54a4cc332681e9ce9e22da1885",
"main.dart.js_265.part.js": "5cd58d20236f9973ffa815add18748e4",
"main.dart.js_274.part.js": "41dfaa359e75dbe8597bb4ffd9b43058",
"main.dart.js_283.part.js": "fbb026be282c78bafe5c4253548481e1",
"main.dart.js_238.part.js": "7f7de538a428a9328118320f91fca270",
"main.dart.js_276.part.js": "41576f902e98c1bfd0c60400a663cdec",
"main.dart.js_278.part.js": "1077eb3742a9d8bbe085049cd010c53a",
"main.dart.js": "499e90a87337150a33b7b829e88daa27",
"main.dart.js_280.part.js": "1af011a677fdfaf9ba041988e8ce996b",
"main.dart.js_207.part.js": "64a9e1b50b4cee785e9002a355b8df5d",
"main.dart.js_257.part.js": "61fa377cd07de6a49036beb6a613ac1d"};
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
