'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "c458000e8ce88d9d094a7f7c52cb6179",
"main.dart.js_223.part.js": "3cefb22f3cf42929c97eee552fa4b1ca",
"main.dart.js_304.part.js": "65bc50f6ee463ad56507d340f7f2938f",
"main.dart.js_256.part.js": "3847b6159baf0ea7f8bb1850c21c496a",
"main.dart.js_325.part.js": "2e7e5962ce427cef8c1f91448833af89",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "dfa36d1972d14379e667d2d976a6fcd6",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d92e51df31903f5057bf42069a909609",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "a3f123b040698ff8aa5ead1d8d3815c0",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_295.part.js": "83ec4089ee32eeda5a403ea7e8c8a54c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "e4bc3063ee3e62f0f09cfe118088b518",
"main.dart.js_302.part.js": "65c221576c15cd1bcd61031cbc5fca00",
"main.dart.js_215.part.js": "c76df642180958b601d83ed10e12cf7e",
"main.dart.js_244.part.js": "54bba02c028cd04a46a67e6801e4111f",
"main.dart.js_320.part.js": "07771e773ae64737f80a49e19779e121",
"main.dart.js_321.part.js": "45f4a1b84733be1824119e2c10f1cdac",
"main.dart.js_255.part.js": "5eec078e6cb59ad3c2cbae5a570458cb",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_315.part.js": "1a8b19da7aa2d1e0cd7b4c159f894dea",
"main.dart.js_300.part.js": "ea32f387033698f9ac9fa8b39dd998e7",
"main.dart.js_309.part.js": "356d23ff40f3b8ca15be3b4b229af8ed",
"main.dart.js_270.part.js": "e215fddbc6f8b4df5bdb5e4196c1bfb3",
"main.dart.js_259.part.js": "32689623e938c815aadcab4470d9458f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "8482f4f4d2d17104f909c881534d13d8",
"main.dart.js_227.part.js": "46a44ccf1422e92d9673544ebe145e7c",
"main.dart.js_279.part.js": "818c17488c08892bffd4bf752bee07a4",
"main.dart.js_305.part.js": "1d628d8f186aa31e5f3182e369e598fb",
"flutter_bootstrap.js": "1c0f929d447a755db30a9a2e0b71f671",
"main.dart.js_267.part.js": "b439c194de8a7677dcb6cab181df1ea4",
"main.dart.js_319.part.js": "d239e510ac00ad9a37ed4059b56b4e6e",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_290.part.js": "0d4d1161e31443e297d3a21ec6b3008a",
"main.dart.js_323.part.js": "9fe28ed2617c4c3c3b5242220737969a",
"main.dart.js_2.part.js": "611010805dcb56081c8408ef9b74dbd0",
"main.dart.js_308.part.js": "b2103c53cbca9655833962c462b7bb6b",
"main.dart.js_324.part.js": "8a330d8a5bed6d181283709473cf632a",
"main.dart.js_230.part.js": "82b9275911609fcc0113f187ba3b5bf4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "4883fc07d9fa6d2295f272312853e7b7",
"/": "4883fc07d9fa6d2295f272312853e7b7",
"main.dart.js_281.part.js": "79c3e67039b7c11ad39d740dd7cbc7ad",
"main.dart.js_301.part.js": "2b12217b3cca039445c2a86c8fdac710",
"main.dart.js_297.part.js": "2310c0b3f1dbba842e34007e04e65e98",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_212.part.js": "ee1b7b97839c5b0f539dae00e3380cdf",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_275.part.js": "86e5ae25d701fed9cd18c27fc897774a",
"main.dart.js_307.part.js": "d06ba98336e003deacd38a742105363f",
"main.dart.js_269.part.js": "af779c4d7dfcbad01f3adfc129b64ae8",
"main.dart.js_263.part.js": "8a1e4ac98b020a1c8e34d4537bb7aec3",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_287.part.js": "ea003736ce8d1d9c351b152cac9549b5",
"main.dart.js_303.part.js": "260d3e81b139fa6174fb929be1ec4baa",
"main.dart.js_247.part.js": "b7595f189f52a050fde9acc365729836",
"main.dart.js_1.part.js": "f20cd86f73caa9493e40563727746eb6",
"main.dart.js_271.part.js": "31620fd4a561a625dbf2706877b01686",
"main.dart.js_318.part.js": "bbbe9cc7ebc99eb961a32135d45ae660",
"main.dart.js_310.part.js": "9e9fad8b1d1bd807f7bbba52fa7b5d04",
"main.dart.js_265.part.js": "437bbe004aebff6a4e8c782f36b5aae8",
"main.dart.js_314.part.js": "f9e43885d4f8e487524fc9b7985184a0",
"main.dart.js_238.part.js": "7e7ba8b1d40ba52a697ee98334ba3ab7",
"main.dart.js_276.part.js": "88ad60cb8d7c7f9bcb004479d2c8c8ff",
"main.dart.js_316.part.js": "e0b7787b438b23f1659355208efb06d9",
"main.dart.js": "85abeaef00d381f98c120b11a6a5bd2c",
"main.dart.js_280.part.js": "93ff7ce472acc70fd6d00ee2e72ab952",
"main.dart.js_257.part.js": "99ddfaeeb42a787b197ebc0843f5b571"};
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
