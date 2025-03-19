'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "51d5fcb34b57059b774196a9460528bf",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"main.dart.js_202.part.js": "81391c45b64cc8ac9cb292dee964ea7f",
"main.dart.js_271.part.js": "7401b90618ec4fe6a8899638b9e3134e",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_236.part.js": "c7b3ea593c33ab65509ff2f84ef73982",
"main.dart.js_229.part.js": "32b19241a32a5c30369177387c288d22",
"main.dart.js_258.part.js": "f43a8225f3448b5f24c4fbe1b489baa3",
"main.dart.js_291.part.js": "7a22a56315450b8e0b3e3130d7849b26",
"index.html": "6322356c55c06de0fa6ccb6831652e2e",
"/": "6322356c55c06de0fa6ccb6831652e2e",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/fonts/MaterialIcons-Regular.otf": "f71ad44beb99d3b525ae88ca96857d6b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_249.part.js": "e45aa09a808a46dbc8793cc18cd42040",
"main.dart.js_276.part.js": "5861f333be724828272761c31c5c314e",
"main.dart.js_260.part.js": "2ba63bbf919bd92f032f8d80923211d4",
"main.dart.js_240.part.js": "6f30f9a033c6ab6eac720d2b4c5dbc95",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "211d1d5a30207cd76de0e10a62ffb190",
"main.dart.js_269.part.js": "8034933103b5d17f9dcf493f07ed5fa7",
"main.dart.js_277.part.js": "b259df79719b99ac013200520680c0ef",
"main.dart.js_273.part.js": "6732e8133b1cd8dc515c0b07a097391f",
"main.dart.js_187.part.js": "9ed57b0a3db9c40177c138943eb4d180",
"main.dart.js_265.part.js": "524090a59dc56cd4f68c73d2c6354fed",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_279.part.js": "5afbfec2e1ea53033ae7034e3ac5f1d2",
"main.dart.js": "a2449d58a117539df1b398ca84503242",
"main.dart.js_2.part.js": "7a175b27dbcee6df77e7eb63eea20eb6",
"main.dart.js_278.part.js": "5d39d1b49d9cfeeb63abc597e5afa204",
"main.dart.js_292.part.js": "4bd1c715178d460afa34bfa9e2d7717b",
"main.dart.js_244.part.js": "3b2c6d433fe4b4b154e50a3c5aaa4392",
"main.dart.js_238.part.js": "516ab79430a9d66602040b7d81816af9",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_245.part.js": "da6e1e4438e4d0bcad422042f1b338b5",
"main.dart.js_225.part.js": "536e462194fba8adf6dc9a71fe12abc9",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_288.part.js": "b525f87b7dccac56b0daf7f3d815cba4",
"main.dart.js_241.part.js": "ba2737955c8dfb3a236541a52fb873a2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_234.part.js": "dc4eb6ce9ab5bb0a18d31868e6864ef2",
"main.dart.js_200.part.js": "9cdeeb0f6861e0ea1fc4f2c7b17e92d5",
"main.dart.js_287.part.js": "65bab0bf3811a55bd94f472032603c6e",
"main.dart.js_189.part.js": "9cdc5115ee9a76f39c869c1fcd920258",
"main.dart.js_257.part.js": "2fb6602801323659472f7a716f2b1583",
"main.dart.js_227.part.js": "e9bae72f819fc487090c6d25d6d17900",
"main.dart.js_211.part.js": "193705babcd12aae78c340bbb997bb65",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "cc0f033078f9b1a39254d3fa95a0e8eb",
"main.dart.js_274.part.js": "e1c44a0118a51da8a2109f4e21af3bd9",
"main.dart.js_239.part.js": "24b5e50b7e97d1d900e4323b7eb35612",
"main.dart.js_289.part.js": "a8b145cf328e6e67e7e18f572ecbd045",
"main.dart.js_284.part.js": "bdec3b972bcc80e13d1b6f33835d4233",
"main.dart.js_290.part.js": "c3b39e847d0755c8184ee2733d144c73",
"main.dart.js_217.part.js": "d91e9ff4695bbac6bd77805da671e6da",
"main.dart.js_251.part.js": "64a545e173cb3684bb20eb298829b040",
"main.dart.js_250.part.js": "ac7e907d798a3d1c27fc23a80f87223b",
"main.dart.js_272.part.js": "5b4a2ce9fbd564fce9d9e4a6b10996c1",
"main.dart.js_267.part.js": "33bf09eec393b7a7800d1009597b9cd6",
"main.dart.js_201.part.js": "d5fe03c7fe8b4a0cd492340b398575bc",
"main.dart.js_1.part.js": "df2e9e346425881dfdd963aa245bda84",
"flutter_bootstrap.js": "a2c53ebc9758173868840ee3e37c4e8e",
"main.dart.js_15.part.js": "7e7d228757dcc211efec6720e3021680",
"main.dart.js_226.part.js": "ed94f0fb700932c18717e6168d136e48"};
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
