'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_230.part.js": "d3c3dac7e7ce6a9b20741448e5c48125",
"main.dart.js_276.part.js": "bb6208ca1b1adf6d788127d532cb5c37",
"main.dart.js_274.part.js": "c846e862440ca12ea6e89550e6531488",
"main.dart.js_292.part.js": "4ec634bffce301937973f839f33e7deb",
"main.dart.js_286.part.js": "e8d9b3b7ad722b2419a00aa8938bfc99",
"main.dart.js_239.part.js": "93c0bfb5262246b895f5f0b4be835ac4",
"main.dart.js_263.part.js": "1d6df4914c49ccbbb5a9549256bd3fa7",
"main.dart.js_203.part.js": "d975fcb06c4778a473a6b93909df2790",
"main.dart.js_232.part.js": "91c323058b116d1ae563fdbfdcde7c74",
"main.dart.js_243.part.js": "9a9d5023a0f5da2534921f58a6e737ca",
"main.dart.js_248.part.js": "8d19fc7c18bdfc1fb246afc8f447eb72",
"main.dart.js_275.part.js": "fe722cd54ff2ff278462232c794dbc80",
"main.dart.js_296.part.js": "20bea5d33a72926b3ade99495e1087b0",
"main.dart.js_212.part.js": "44de761609adff2bd80fac0c532a6c33",
"main.dart.js_189.part.js": "a6a69cca2ccadea042d0757e5851a16e",
"main.dart.js_242.part.js": "ad004b23dac4dbe27a4eb0695e419d8f",
"main.dart.js_241.part.js": "0940fef9546e999b616714035c96e83d",
"main.dart.js_1.part.js": "2f62d951bb1ee969f6a2f238cfddd35d",
"main.dart.js_252.part.js": "af55e8ce9da89576dbe3dbf65cc56d02",
"main.dart.js_16.part.js": "883cd7876bc8137517b8b22a352fc4fb",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "acb301df24b09ca94c58eb075037da37",
"main.dart.js_220.part.js": "f98c3acfab00cf88c79b927c15853dd2",
"main.dart.js_253.part.js": "ded4dae409a3e20bcc6a7f913b527098",
"main.dart.js_218.part.js": "f0dd07a3b6380388540a586684aa15c8",
"main.dart.js_204.part.js": "320fec94cbfd6cb003eb85e832420f61",
"main.dart.js_287.part.js": "78eb2917cf5956c7a0b8e17612e13333",
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
"main.dart.js": "1f6cadd95686e9399f6fbad76821074c",
"main.dart.js_254.part.js": "a853927cc298f9b0680db1eb5b62de68",
"main.dart.js_273.part.js": "b3dc680903ee4e7ae477d07722985ffb",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_268.part.js": "a02f33da1e34888a2d84f64d9b1e1d4c",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "6198a80766e151248ce260acd38a96ef",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"main.dart.js_281.part.js": "271e690c0f8a436d649c41a9b7cb010b",
"main.dart.js_282.part.js": "4f0c018752f097daec033250dec4cee6",
"main.dart.js_279.part.js": "0476daf6337e6afad8225843ba1ef00c",
"main.dart.js_191.part.js": "6e68a2524d6022f37cd04863bcd7f978",
"main.dart.js_293.part.js": "b9ec6d54074b49f4ba8cfcf4ac6093b4",
"main.dart.js_202.part.js": "1be7d44e29f9aa6dbb63f3cd82020f66",
"main.dart.js_297.part.js": "57e4ec1d8ed88e37e11ab8dfb8204365",
"main.dart.js_2.part.js": "d6c338eddec0d3623b489032ee604cec",
"main.dart.js_229.part.js": "9ce2da40beb16338b153f7783d8870ec",
"main.dart.js_270.part.js": "d5381751c321af2e5698354f61957771",
"main.dart.js_280.part.js": "75f3b45919693ec0116440511f41968a",
"main.dart.js_288.part.js": "6dc198d760f1b1c1081af45345c20d6d",
"main.dart.js_237.part.js": "d879337334210f882dbf0bd923c75fe6",
"main.dart.js_228.part.js": "352ea14c36b5104aacda5c7db2c9c934",
"main.dart.js_277.part.js": "cb03dc3f167d8117de2014da5f455404",
"flutter_bootstrap.js": "abe8c38bf4eaffec7c18abf7499909da",
"main.dart.js_247.part.js": "bc2a506b78bc395360a3f3fc079a7f13",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_291.part.js": "68173d62fd6bf6916c7c20ab1bd1aa29",
"main.dart.js_260.part.js": "c5a3a841417f86f872e4aae81e94c240",
"main.dart.js_244.part.js": "87d6658f28aaf00b0f337518641c08de",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "84a59e77210226a7eea3367fcab89079",
"index.html": "816322f99a2fde6f79749848e0d86e90",
"/": "816322f99a2fde6f79749848e0d86e90",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_272.part.js": "144586dd64634123105f3d5cf43ce445",
"main.dart.js_261.part.js": "82fb7ccf1e5c40b9f9f61020e99c14e9",
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
