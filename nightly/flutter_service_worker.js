'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "065bddf48ed422558385b8518e55a068",
"main.dart.js_291.part.js": "51e4e6676c6a2c27d7943d6b3dac9217",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "6fb9c8dda4bc115ce8db3fa7d670e477",
"main.dart.js_190.part.js": "090ef60f4b87027eb26f2cc2a87e3904",
"main.dart.js_244.part.js": "dd47e26e2bb6fcb14d6a21a2695e033a",
"index.html": "3e9ea2e868db5e935485a50715655e14",
"/": "3e9ea2e868db5e935485a50715655e14",
"main.dart.js_296.part.js": "562073636bba78bd7707ac6e3bd84c74",
"main.dart.js_237.part.js": "7e98959935aa1ef27803e4f5b777be54",
"main.dart.js_279.part.js": "68347c125e29e8164dab32a68bbc6f4d",
"main.dart.js_295.part.js": "c6a61cdd696c071064e3ba3e66cb08f8",
"main.dart.js_263.part.js": "60022d65f67fd8c803a88ff5fc20a8f5",
"main.dart.js_1.part.js": "db1025c4e40a06a365eb7dfbdb8f32b2",
"main.dart.js_276.part.js": "06788024f7fa52ab50cd1f651d0d8b44",
"main.dart.js_2.part.js": "d83ca9fabbe8277da48510c0f6dc18ce",
"main.dart.js_243.part.js": "d2c8610f18b92a668689823749bc72cc",
"main.dart.js_253.part.js": "b18f9f255e2b81343dab5d5ff560fb2e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "bbe4213f4d8e849c9f36ff99e066b4e1",
"main.dart.js_290.part.js": "4b25a1e57d0b680e22b47f8a8c800e26",
"main.dart.js": "c19deda0b7e87f59935360ceedd7d7c2",
"main.dart.js_230.part.js": "e2d06401db9327bc91a49c523d1e9e3a",
"main.dart.js_273.part.js": "22589631b565f6e99b0b614bee0bbccf",
"main.dart.js_268.part.js": "92ebb69d7bdb50d6ddcfa4123afdf7a9",
"main.dart.js_261.part.js": "621a26fda115c9a344978417a5a1b6da",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"main.dart.js_203.part.js": "b3d29b33e09eb247cbb1dae73fd786c6",
"main.dart.js_241.part.js": "0d8239c2762b2c8cdca29b9583c5ccda",
"main.dart.js_248.part.js": "ca348f1a5bc0e49267dcea04debcdf93",
"main.dart.js_281.part.js": "09d5f66ed9862de029dd60e9be31f48c",
"main.dart.js_228.part.js": "a37bee275ab368ba3dd54e9ff938dc8e",
"main.dart.js_220.part.js": "907f5a7ed0fd5c5f898088ccb05d55d4",
"main.dart.js_270.part.js": "950432814158b825c060c1553e22e366",
"flutter_bootstrap.js": "a5a3d4343512d230fb1ff58d0d627fcb",
"main.dart.js_232.part.js": "d181f4a5409b8f1faef546c38ed29606",
"main.dart.js_280.part.js": "86fb61f2f5bad4a9c50a6d4cbf08233e",
"main.dart.js_277.part.js": "5b61fc157d54f02a166d7dcc8bae81d8",
"main.dart.js_286.part.js": "9650436ea26775572323867b77bd5416",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "1c1bde437a80aac7708ee3d68ab7ff21",
"main.dart.js_15.part.js": "4b506a21ea0c09253c167a4521db7da8",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "1347efd89d146a3cb17364c93cf9e46b",
"main.dart.js_205.part.js": "82906e7448b3ad16c38328629f976003",
"main.dart.js_242.part.js": "7b2163a2340677e5b800165d0bff959a",
"main.dart.js_229.part.js": "33a47544907cbae8b7595e9aa836f8ec",
"main.dart.js_192.part.js": "2fbcc880137206e6cfd52a6ffbc211d2",
"main.dart.js_247.part.js": "e1dfe1cba819f2260189c6486d30e349",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "cd271449e8487990c6dc892bc3d20169",
"main.dart.js_292.part.js": "62f065435967fd039acb883348702e5b",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"version.json": "bab3af646225186c2ee572830da047a7",
"main.dart.js_275.part.js": "e7013a70cec7f5add80422556525f107",
"main.dart.js_272.part.js": "ca5db36b05e23274684f5a3d127442b2",
"main.dart.js_252.part.js": "81be825688733f6b618bbdc692b4874b",
"main.dart.js_260.part.js": "790c4707afa1741b8b4a23bdf39cc527",
"main.dart.js_288.part.js": "5df4990e0edc68b37645978e481cbdf7",
"main.dart.js_254.part.js": "b7573bf0ebead5bed7c18a5323f31279",
"main.dart.js_293.part.js": "7c2cd1ed43eb42ab40261a24337627c9",
"main.dart.js_294.part.js": "6c9943596cb224d470ad995f1388e196"};
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
