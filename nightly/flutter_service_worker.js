'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_230.part.js": "277267af031262ec8b4c6c6c14d0ff06",
"main.dart.js_276.part.js": "a3369beea6d7ad8466256bf268ca4f4f",
"main.dart.js_274.part.js": "1b76555fcc785abee4232f2e348c4033",
"main.dart.js_292.part.js": "eae03fba32c023d5238b0f591578df2a",
"main.dart.js_286.part.js": "4789dd238e530713414793413118448a",
"main.dart.js_239.part.js": "d2b6069b0d0f2e891ab70c3d1f1bc90a",
"main.dart.js_263.part.js": "ea9f0e1c0b8edb0b2361ff06be6cf4fc",
"main.dart.js_203.part.js": "0191ca722b02bbeed9f46acf31b0ce04",
"main.dart.js_232.part.js": "81b284d4044eaa8b8705457918203a48",
"main.dart.js_243.part.js": "6379ed5fc32e2683800438a08ba5b2b4",
"main.dart.js_248.part.js": "a0838557c961f343a5209407e21d5844",
"main.dart.js_275.part.js": "ca3bb819c0ee31306241bebaed8950bf",
"main.dart.js_296.part.js": "0a78248451b1dcb76e1acf9589a320f0",
"main.dart.js_212.part.js": "709c1c870f88383d448b7050116a396c",
"main.dart.js_189.part.js": "c7fa2599a6ca22fa4f4aec3a55e40c2c",
"main.dart.js_242.part.js": "d33ff2313aa836d2526f764650248a0e",
"main.dart.js_241.part.js": "af3822a4b4bcbb0329ec7a61a2bef008",
"main.dart.js_1.part.js": "cc0cbcf58fd3609a81786df2b4a88f2f",
"main.dart.js_252.part.js": "dc44cfb11f58e22aea9b0f2594d420ab",
"main.dart.js_16.part.js": "09b06b12dd0390d8c1a31f4d205d92c6",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "a4d020745af3e1f2fa5b7bbf57b8da5a",
"main.dart.js_220.part.js": "cd562d4733df8f80e360fd1000ebdd89",
"main.dart.js_253.part.js": "da148d66c70522cb5a8cd8c7f6d648e6",
"main.dart.js_218.part.js": "e2c046153c3c1e00c7fdfae69795c717",
"main.dart.js_204.part.js": "cea14dba91f8698c2f37d20dab5903a0",
"main.dart.js_287.part.js": "9ad05a13eba50eda19880c2dff760cb2",
"assets/fonts/MaterialIcons-Regular.otf": "f5f22db300aa7bdf86de1c57d4aa8d3f",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "c4c151b1b0760395c474aef86e34c28c",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "983fbbb360750a0476b9a04a2c1cf05c",
"main.dart.js": "da7c217a9c6f1e93312c528d84afa6f0",
"main.dart.js_254.part.js": "a88d746f7d0985c83a3f1f1cb4178d14",
"main.dart.js_273.part.js": "7b33b5e19ff1d34fc5df69dab5cdf750",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_268.part.js": "12b3d07a86f1e85d1f209d319df25851",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "da80b49968e9ac78dd105f63fdf2815f",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"main.dart.js_281.part.js": "932d1ed887f42daa68fc10a4700ba9c7",
"main.dart.js_282.part.js": "56d94cda14af4fb63bfcdfb527fb4fb9",
"main.dart.js_279.part.js": "151c7b029fa9a0e78802422e0242e8ff",
"main.dart.js_191.part.js": "90aaa3579b8ae1bcce1d974819e99afb",
"main.dart.js_293.part.js": "e9cc91702d63c14e93fae2ddf44f5573",
"main.dart.js_202.part.js": "03eb750d5f373be632395db1ada4645a",
"main.dart.js_297.part.js": "7752f20fa5835fa529d9072f51a890d6",
"main.dart.js_2.part.js": "d6c338eddec0d3623b489032ee604cec",
"main.dart.js_229.part.js": "7517ac7ffab5d6e6384ea39e1de48d77",
"main.dart.js_270.part.js": "7c1b5a5d12742a7189f23e76cc6a225f",
"main.dart.js_280.part.js": "804dd90a3cb986cb86ca4a55cc2b87c3",
"main.dart.js_288.part.js": "c0c14824abe418441c5beac1037a9e54",
"main.dart.js_237.part.js": "c40d6238960936e731fca2bf1ec153dd",
"main.dart.js_228.part.js": "ec2e5e5682421942a7ae63954722b90f",
"main.dart.js_277.part.js": "f574dead2f94027de5a5249ca5108892",
"flutter_bootstrap.js": "4a5b3d7ab5278c7277083e0860fd14f1",
"main.dart.js_247.part.js": "4b0ecf3b9fa1379fb92e872013329063",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_291.part.js": "edee88b14bafaafab233923734bc5464",
"main.dart.js_260.part.js": "ae6e8be6efe8c9ee5bb4c6c7fd93d5a7",
"main.dart.js_244.part.js": "bb11d4a9e0a7e7bb0d1773d522143c61",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "1699b4e1846048acdab56e5dfa664419",
"index.html": "0c095f4f5529605f66a787938d34b02b",
"/": "0c095f4f5529605f66a787938d34b02b",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_272.part.js": "0398a4e9fd83be20b04b13d28550d444",
"main.dart.js_261.part.js": "00ba673bbabd118d6f9f9841696151b4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd"};
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
