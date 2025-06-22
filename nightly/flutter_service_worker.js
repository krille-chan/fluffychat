'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "758e3163c3cb5d41d0e73db875169fd8",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "51382c42a887aa66d272d91e029995ab",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "205c76a9a05e3c4e64d4acace9b57b46",
"main.dart.js_274.part.js": "eea45c34d969cae62775fb9405d75ad5",
"main.dart.js_219.part.js": "2964d5b99c5ad75490a0d08fd2e3ba82",
"main.dart.js_205.part.js": "2953c26af4c9defbf212c66229e4575b",
"main.dart.js_276.part.js": "401cd748197a61dbabe111affb0dab81",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "d0f72a396cbfc9b3781cd83a481c775e",
"main.dart.js_262.part.js": "f015999daaddca2a8308e9e5207da994",
"main.dart.js_1.part.js": "d044b965079aaa7a184d317f222ec805",
"main.dart.js_243.part.js": "e9de8a13fedffdf2faf176f12eb5a30d",
"main.dart.js_275.part.js": "4870ab9cc8e8aa4486f20c927beee1bb",
"main.dart.js_231.part.js": "3021e0c2dbf23aae51f816efc8f8fc1d",
"main.dart.js_269.part.js": "aed44f24b41015683041e624856d58b8",
"main.dart.js_298.part.js": "80166bb5b60101be12763f4550fbcab0",
"main.dart.js_240.part.js": "1205f276b183e5163b6cb6abc58b9514",
"main.dart.js_242.part.js": "c736fd3e12c762dc9e60f73b7234f042",
"main.dart.js_283.part.js": "8c0bc284c263fe0d82afbd368ac98cbb",
"main.dart.js_293.part.js": "769e3fd6fca2983d56fe88411ebb580b",
"main.dart.js_277.part.js": "509ebdf2e82314fbffdd4fc1c9367e99",
"main.dart.js_213.part.js": "3bfe35dfdcb1499e775880ed52c10f0a",
"main.dart.js_248.part.js": "a9166e4efa1fb1f8ed945ad4f9ebfa0e",
"main.dart.js_289.part.js": "89cb05196e85bc94885494a659b8582c",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "791cfc3cd5763bb9fa80f37448c76946",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3e0f61bf2c7dec7406a813f1b44390fd",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "e593198111eafe5b1f3ab10947514091",
"main.dart.js_297.part.js": "36b065f1051101e1da5c411c4bbdb66a",
"main.dart.js_192.part.js": "7c8487520a787b36285a18fce1ea5ba2",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_282.part.js": "43a057f1526c6c9d55459f40df79121f",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "e00a3856eadc0a88c4504802e9d63c8c",
"main.dart.js_230.part.js": "58e2b7016dd56cafa134e3dcc76bce32",
"main.dart.js_238.part.js": "1e2cc369d3ebccde99fed24d424bc9d4",
"main.dart.js_253.part.js": "c61839ea2fb51428417c41d59a860a03",
"main.dart.js_244.part.js": "00707d75003edb746983099b3b082af5",
"main.dart.js_16.part.js": "371da4b4685a06cc894c09ff0f586f5d",
"main.dart.js_294.part.js": "6612aafc16daeaa2631e4f2dde621e65",
"index.html": "4d2162b083970aeb708c79dba34798fb",
"/": "4d2162b083970aeb708c79dba34798fb",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "309bd317e87d2381fed3b7d3dccde236",
"main.dart.js_245.part.js": "7bce128cd58e6ae6ec1fe045b1640743",
"main.dart.js_291.part.js": "7807c08cd1a000466581c3c16bf2b6d7",
"main.dart.js_287.part.js": "081afd09c180cc8b744f2869f7edf691",
"main.dart.js_233.part.js": "6e9b2cff8db3f701377b82eda22be650",
"main.dart.js_273.part.js": "a85c44850b668244ee14ab3f9694a67b",
"main.dart.js_296.part.js": "0c1c5ef770a550b1e335e9ed00193dd3",
"main.dart.js_278.part.js": "eb46f67e56be7bf4de739601aabf9974",
"main.dart.js_292.part.js": "48900e9c79010f67318ce60ad4af24d5",
"main.dart.js_295.part.js": "4dfd8fb50e37e1ffb563c218716ea674",
"main.dart.js_221.part.js": "a25f33534893109369d017ca9beda939",
"main.dart.js_288.part.js": "5dcd5343d26a4bf1ab379fdb97ee07ab",
"main.dart.js": "f772f25db860b14e5fcc7fec1924612c",
"main.dart.js_280.part.js": "6045b456634c98dd9dcaedc271c1f152",
"main.dart.js_261.part.js": "694cec62c4f8e1c465127c6a1aa6554f",
"main.dart.js_203.part.js": "5f45b9994993763e39bf138d582d329d",
"main.dart.js_254.part.js": "fd93e24ae0a887a90d54bfdfd19e54e8",
"main.dart.js_271.part.js": "b3499b8502495ddd771debbcf23debfb",
"main.dart.js_281.part.js": "075e5d8f238f2422080ee7872d5b4f65",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
