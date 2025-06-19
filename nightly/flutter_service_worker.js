'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "80f83f9bb0fd5730485f72878d320194",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "4d55054b194d80a5a77794c32b1c45ce",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "53fa7d67c5638a6c7f43ff801693b97f",
"main.dart.js_274.part.js": "326fa18df96fa24f0cad54d3a6cdecc1",
"main.dart.js_219.part.js": "02adc3dbb71ce771c9609af360ff37ec",
"main.dart.js_205.part.js": "de7f2601d045600c44eea54a635e3f83",
"main.dart.js_276.part.js": "3033d28081054ab2ab98cde34d08a1bd",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "fc61a45d6254929e132a0a795c63c29e",
"main.dart.js_262.part.js": "e6d02ea8e0bb6c752cae4ecfe1c0c729",
"main.dart.js_1.part.js": "56b2d5a8c43d93b161496276983f989d",
"main.dart.js_243.part.js": "5197857b14b09305af55f7fefe5c9454",
"main.dart.js_275.part.js": "653cec68e4bb2a64201c962d09a3216b",
"main.dart.js_231.part.js": "57405800fd20e226af960909197ceddf",
"main.dart.js_269.part.js": "38b504ec4684a63b1a150f49f85a0f6e",
"main.dart.js_298.part.js": "1f78bc0e3c7b66980d20edd9e80c1dd3",
"main.dart.js_240.part.js": "b104a71ad4712acd73313bc7511f0892",
"main.dart.js_242.part.js": "5bc1dd43109293135da23026757d3ff1",
"main.dart.js_283.part.js": "4e219726218cf852201fe6a873da77c5",
"main.dart.js_293.part.js": "387c158eab4e78903ceeb2eccc64f58b",
"main.dart.js_277.part.js": "2c1bb53b28ff8870fb03b82500b03f0b",
"main.dart.js_213.part.js": "3387295e9d6d1e4669168ccc74264197",
"main.dart.js_248.part.js": "0c374579da77f87e5f416628702ccf01",
"main.dart.js_289.part.js": "405b0286042a14e57b11393eb477f6fd",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "6d32cdea4dece76fcddd05a671f43497",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3ab0960b0726e1420948c446b4d8ca7c",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "bbc2c6665ad0c3fbea28d81549b0b93d",
"main.dart.js_297.part.js": "a91bba309019fb3b2559f95d7f313ccb",
"main.dart.js_192.part.js": "72a23720911427ba5329b62f04b61c29",
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
"main.dart.js_282.part.js": "0465c6c5a3dc6fe8b2dd35ccefb22686",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "4ad39c0ec7fd546b10cec62e58a94ab8",
"main.dart.js_230.part.js": "b4d6e593106564c86cbf214e438011ef",
"main.dart.js_238.part.js": "5391c3dc33de5fe0c568c4812fe74a75",
"main.dart.js_253.part.js": "b5101abda5cf2a3b925de1ddc3be2567",
"main.dart.js_244.part.js": "d51b095b83a53a8f1ab04fa2383e60b6",
"main.dart.js_16.part.js": "a5f59b6967599535395d6d68ae92deb7",
"main.dart.js_294.part.js": "7ab60ee1ebbe811c38d86e80c2ff5d27",
"index.html": "e8ed2a9e92f5e5cb12636ba9f6d62d6c",
"/": "e8ed2a9e92f5e5cb12636ba9f6d62d6c",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "cba3ad8a250e73f45d950173ba74316a",
"main.dart.js_245.part.js": "47dddbc0aa8501fc62ddc03a24e7a6f0",
"main.dart.js_291.part.js": "45ae03bdc97c44a2cead3a35bcae47ac",
"main.dart.js_287.part.js": "71a6c04e2bcd3095182d91e64eb83f09",
"main.dart.js_233.part.js": "e8864b48beded9d8fd76ceb0c5ed979e",
"main.dart.js_273.part.js": "c5cfc07fcd8046e9b8fbd2fefbec49e0",
"main.dart.js_296.part.js": "0b9ec7dbc637a952b915ad506a36b0fc",
"main.dart.js_278.part.js": "562d2c1e5008afa9d07f47ad3e6ddcdf",
"main.dart.js_292.part.js": "5a2f51ff413217b940a58b8c46273e11",
"main.dart.js_295.part.js": "b24b5ddffddffc1549e165a00a47c341",
"main.dart.js_221.part.js": "71614e3d6513f1d6dd6a3fa5b5634e02",
"main.dart.js_288.part.js": "16ce7c76918bc1ee9badc13010f398cf",
"main.dart.js": "a2a2ad5155b8df6f5a90e41056928828",
"main.dart.js_280.part.js": "803fe7b67bf4aa40500c8fcc6de98ca8",
"main.dart.js_261.part.js": "6938a845866f4f72092f3b700b3f0587",
"main.dart.js_203.part.js": "11b24038038ad835e38f85a84b70e754",
"main.dart.js_254.part.js": "8edf8a95fd786b64942994790b08160b",
"main.dart.js_271.part.js": "f2ac3dedc16f26ec91263427b4053a04",
"main.dart.js_281.part.js": "b874ce180c6ce324f971d7859c083ca2",
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
