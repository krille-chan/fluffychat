'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_206.part.js": "b3572937d1dbd2fc293da5f77eee62e9",
"main.dart.js_249.part.js": "d62de67c71969d87dbd2c80a636e565a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "30ea2405bb79a14532cf1ec27ecc2358",
"main.dart.js_246.part.js": "f52943b85fc0cc367c44ef998c54f876",
"main.dart.js_274.part.js": "349f8ac6dadb20d4c0b792e5c4d60f8b",
"main.dart.js_205.part.js": "f1dbe7854d221456f5f15b2bb041e1a1",
"main.dart.js_276.part.js": "bdceed9738e3b0a96280160b3452aa1f",
"main.dart.js_220.part.js": "9838b297b48810854993a9ce0ecc4822",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "3b23ec2300395fb553881a78983186e8",
"main.dart.js_262.part.js": "f387f511b1fbc6290367f2ed60096337",
"main.dart.js_1.part.js": "c8e6c0350d6de89c47e748a4bf7ab6da",
"main.dart.js_243.part.js": "23bcf10710ba665a046e651467b8740c",
"main.dart.js_191.part.js": "9dde3936b0875609ba1a91ba04068672",
"main.dart.js_275.part.js": "8b2f88ccb0ba16ed277fe4e50b5b954a",
"main.dart.js_231.part.js": "7a55f524b1a174e8ffd5544bb250ae23",
"main.dart.js_269.part.js": "be76d18dd36e0267b05fa4f9b46f9108",
"main.dart.js_298.part.js": "5bbf28179005e6306c06faddf718b4c7",
"main.dart.js_235.part.js": "8b0503ffdffbeb221e0ae93f13738312",
"main.dart.js_283.part.js": "f227001fb7b5b8791494d0ebd076dd09",
"main.dart.js_293.part.js": "da944168db63447195ffcf5305520968",
"main.dart.js_277.part.js": "3854ce6bd0cad35e11cba77ce5ef01dc",
"main.dart.js_241.part.js": "4f21d3095614ddb07a3d120d798f2197",
"main.dart.js_223.part.js": "2422b9f5c7ce012ab674d8e8c0121fa5",
"main.dart.js_289.part.js": "2bcafd9cd1da9666db69d7b07a5736a7",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "84178c2c335172ee24fd021e08612c55",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e7cb13cc13fef115e5125d3167671fc4",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "6d987bec4311d3f3622ea67d312ded67",
"main.dart.js_297.part.js": "7f0646ec16c08ac6922132bbb21a021a",
"main.dart.js_193.part.js": "289951b84c84c8b7d2eca68a5b37858a",
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
"main.dart.js_282.part.js": "b2325e4478f7522ff92358db833274b2",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_253.part.js": "9ce5ada1cffedeac1c35aa8b2addac00",
"main.dart.js_244.part.js": "c9e9bfd0e52879c39c498860be62abc4",
"main.dart.js_16.part.js": "a2f800237e98c31712a3451bfc10bf05",
"main.dart.js_294.part.js": "96f399804ca6e277f00326a80b4d303c",
"index.html": "ee270650ba36d982f93e689c47fa28ef",
"/": "ee270650ba36d982f93e689c47fa28ef",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "95ca804580285ecb6c09759af4837a7c",
"main.dart.js_245.part.js": "8dd38351ac89412ad9440d91e3724652",
"main.dart.js_239.part.js": "eadb3d60ecdf50cb80fce9a698669519",
"main.dart.js_214.part.js": "9745e4ef687c20b0b96fbc3019458f99",
"main.dart.js_291.part.js": "47777ac94862f7f60f5899c01cb72545",
"main.dart.js_287.part.js": "086c1e27fa7b03aad234b751597e8f8e",
"main.dart.js_233.part.js": "ff35e0e622b4e2649e6bb0708633bbaa",
"main.dart.js_232.part.js": "c66425fb0330acd93c0e9de88513ae5d",
"main.dart.js_273.part.js": "622b712b89c07321c5b0953ed7cc4b5c",
"main.dart.js_296.part.js": "9fcacd3c08439ee6f3b9e9fef43b2be9",
"main.dart.js_278.part.js": "fbeb41549e7ba1a05cc2c59a968b0ca8",
"main.dart.js_292.part.js": "a0eeeaab7f8e66272a9af06811108373",
"main.dart.js_295.part.js": "2f24c2da3db55f0f300349aa8ed8e2bf",
"main.dart.js_288.part.js": "dcdd0a3cf867d1ecb27a5cf697eb9abc",
"main.dart.js": "a51702e427fd75ad3bbdd1223ab1f804",
"main.dart.js_280.part.js": "c419c52096d18cb510732aa0988a26af",
"main.dart.js_261.part.js": "0314360ce60581938b3d67240ab5b30d",
"main.dart.js_254.part.js": "818e1bb054acfbfd1d0c4463edcf1fca",
"main.dart.js_271.part.js": "2c7e7b51adffa16b4a9c3170ae32f1de",
"main.dart.js_281.part.js": "590879d41dc0d9ba5faeea6491301b8d",
"main.dart.js_250.part.js": "929d7b20e62a441db3c7eb0a4f8f9bf9",
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
