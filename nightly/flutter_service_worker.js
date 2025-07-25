'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "8b7ada94d2b128e219fe80ea3338215b",
"main.dart.js_268.part.js": "7eb847d90488dc50d88e899915d88644",
"main.dart.js_304.part.js": "425ba5c30218d56e35cacadf677edb9d",
"main.dart.js_229.part.js": "dfd364af2dfff82973b88edd546391f4",
"main.dart.js_256.part.js": "39e3cded23df06ea0e04909d22bee246",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "4072a8aac321535c480a0e5d77c25c2d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "1a5328e33fe6f50330580826d3c748df",
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
"main.dart.js_211.part.js": "da6258f70302bcf8838de315fdbd4d1c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_302.part.js": "a9be2ee46baa9a3d08b43dd6ea9b5ae1",
"main.dart.js_320.part.js": "c09c320b60528279dee48d22b60d42ee",
"main.dart.js_321.part.js": "4f376c23fc0a850dbec297b236260e58",
"main.dart.js_255.part.js": "578d46c77515f5cd91b273a559a89523",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_315.part.js": "3712aeca602f2d728826d16c234bdb73",
"main.dart.js_300.part.js": "d6948f2a35d61aaa22e23e27d97fcb83",
"main.dart.js_309.part.js": "ee77bb57c88a94385e048b1632bf763a",
"main.dart.js_228.part.js": "fd90e71c12be1f6afeb7f5a26485596b",
"main.dart.js_296.part.js": "4a830e8fa85c81a2af9502867d50ed30",
"main.dart.js_246.part.js": "48de15c514095c635f34a8dc4eb69099",
"main.dart.js_270.part.js": "e1c56da7c42fdea190a47eba533cdfb2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "18631f55363812f83a12acc59c31c07c",
"main.dart.js_227.part.js": "0f865c839d1c2aa30a95a5c0936184ad",
"main.dart.js_254.part.js": "fbdb1f719a9197cec567f95d16811ac1",
"main.dart.js_289.part.js": "d244d474ba3d4462d9922eca27d3e22c",
"main.dart.js_279.part.js": "f498c975a6d56b27c045d327cb42b4f7",
"flutter_bootstrap.js": "10825b1a5b08e93a4142dae17c808776",
"main.dart.js_264.part.js": "f9c3c145d11922945938fdffc33c2c90",
"main.dart.js_319.part.js": "d24a364bfa2f8d03abc6f55927460189",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_214.part.js": "9e1a75c90078a6d616b3c1ca31c7e808",
"main.dart.js_294.part.js": "ac8d5c250a25a73bfc8fe074ea5df4b6",
"main.dart.js_323.part.js": "65c537cce40e304d2dc164fb18566473",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "50cb0b3c437c3cf25361e074d6788cb1",
"main.dart.js_324.part.js": "3ec3b941b95944df7a544d24fa706e94",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "65ebcdcbb4dc3748d1fb9a021d39122a",
"/": "65ebcdcbb4dc3748d1fb9a021d39122a",
"main.dart.js_299.part.js": "0575285278a2c3127ac8ca5531314f3c",
"main.dart.js_243.part.js": "a5ff69b66f8bc7d06543c8bd8d5aad82",
"main.dart.js_301.part.js": "9f11d842a6e1bba9e1a82e7e00acfb57",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "78bea0b723e352737ab18c2eac54cfaa",
"main.dart.js_317.part.js": "ea19cb74b5a60d3e276316d8d455c3b9",
"main.dart.js_286.part.js": "cd8d783ab7004894388980de162eb63b",
"main.dart.js_275.part.js": "341a7b52733fc5eb8f87e35ab3488604",
"main.dart.js_307.part.js": "45f83d9cf15a2875682b4d8765a86c21",
"main.dart.js_266.part.js": "4e2a8fe5f816074d987a7c44127c9fc9",
"main.dart.js_269.part.js": "89df30d496dc170d2b9303acdf3c06f8",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_287.part.js": "bc9f0c7785fc2f83f0a06232184c0050",
"main.dart.js_237.part.js": "1d4f817937a02400cab6c3b7795b9343",
"main.dart.js_303.part.js": "cbf5cb61843f37f62f65177c7cad17e0",
"main.dart.js_1.part.js": "717ee3284330f7c2cc77a9a98822b4c4",
"main.dart.js_258.part.js": "94f904dcc8f041c34d802f8bf508183f",
"main.dart.js_313.part.js": "37068f8c09b048d6ff21b62e4331f64b",
"main.dart.js_318.part.js": "7d75bf6b6389e666c4de42830c6c09fd",
"main.dart.js_314.part.js": "2c2f39e375bec75374b8afddfb9d2887",
"main.dart.js_274.part.js": "37d84e4de1b89677c535492e70a5e373",
"main.dart.js_262.part.js": "6cd413d535103bb0ebbd41cda0570f83",
"main.dart.js_278.part.js": "1cd75351ba47ea549fbb6eab21aa3b91",
"main.dart.js": "3cf3bda052affce74679595fa8b86047",
"main.dart.js_280.part.js": "cc3b76b3e42c1f7074d5432e684a4267"};
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
