'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "37050134410def714dc66c45dbecd7d2",
"main.dart.js_266.part.js": "78f202a6a1f06976fac5db949287bb60",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"main.dart.js_271.part.js": "a0bfaccfcabcdf8b20724db3d5a042c7",
"main.dart.js_210.part.js": "cf13d9e75828f9b1a7ffe93ca3614280",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_291.part.js": "4325fc63c7288859764754c1e3ed4df4",
"index.html": "42407304198125c98b5e5f8f5f8bded3",
"/": "42407304198125c98b5e5f8f5f8bded3",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
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
"assets/fonts/MaterialIcons-Regular.otf": "8a519bfdc78399fb84620c2198e937e7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_249.part.js": "402b50f362310290f2ddde284ebe47e4",
"main.dart.js_276.part.js": "ca55980d4953681b2aec4d88b7f1abea",
"main.dart.js_240.part.js": "98fe72ad125c07ea06e7c51efe8a484d",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_269.part.js": "2ba63894216235e33e1a3ffeea199bc6",
"main.dart.js_233.part.js": "733d81e02ca9e10f997bc4bb8bbb83f3",
"main.dart.js_277.part.js": "2e5761bcaef3ba6ac0835c906b33173f",
"main.dart.js_273.part.js": "7744ddc7c2c51f61ad098ab2056c5461",
"main.dart.js_264.part.js": "8e0f082af77da7074c41990f75ad1c5f",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_243.part.js": "925b7af9ca441de3f93d86ea3cebd457",
"main.dart.js": "373cc6ccef8e09eda28c7ab0e921d30a",
"main.dart.js_216.part.js": "988b5585a2d66146988214600f8845be",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_278.part.js": "e29eddc829a2e38a651aedb8f67d9ea3",
"main.dart.js_292.part.js": "e799897facfa37aa02fef2dc336efdd7",
"main.dart.js_244.part.js": "934679abc7dee2f21e039c0f7ee633d2",
"main.dart.js_238.part.js": "1725be00bba5f9f7ec82821281bf984a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_228.part.js": "48bc24e79a4c9e4db2823c4f895cec06",
"main.dart.js_225.part.js": "b6a63ecd464a1ef65c4318241e0b89ca",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "bcd56f0471b43ae05a16e79e11836c99",
"main.dart.js_237.part.js": "76278f1691253c9897713dfde24d2eae",
"main.dart.js_288.part.js": "73c9ebc9734eead09409764378ed2764",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_200.part.js": "71f2b642c44d40bb66560976882299c1",
"main.dart.js_287.part.js": "2a1a40c07438182227416a9adae6713d",
"main.dart.js_286.part.js": "78c5dc5677617c3952452a3d026f1bd3",
"main.dart.js_224.part.js": "3b122bc8c1a9455ce0109c08eebb07e4",
"main.dart.js_257.part.js": "20b028c285f54dcea2b76b9963353433",
"main.dart.js_186.part.js": "45e0405a56d76eb502c7fc2fa5dee43e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "d0e865c18f55fdb9406f4183e0a72089",
"main.dart.js_239.part.js": "ad065f6b904bd9f7745405e444b0a488",
"main.dart.js_289.part.js": "8c200a452126cb3da0c685c42ce192c2",
"main.dart.js_199.part.js": "4153303e5f52c91f3c2a855897bb8325",
"main.dart.js_275.part.js": "73bbe3f0403d3ddb7a88917c46133c2a",
"main.dart.js_284.part.js": "d9a5f4ec642bce3b19f1ff214761e46a",
"main.dart.js_290.part.js": "fd4b6adf4e4d697b9625078a235581d7",
"main.dart.js_268.part.js": "9cf84cd8481b5a6d8df5a23b1ebe1c9e",
"main.dart.js_250.part.js": "2121582c72a45f5ab718b7d9e54f7af5",
"main.dart.js_188.part.js": "f3359704bb707101bf302417f3f3c532",
"main.dart.js_235.part.js": "c7fb9acbcc583879d1e91157b217bcfb",
"main.dart.js_272.part.js": "8ea37d74a9dc4ee56aec071bf91867d8",
"main.dart.js_248.part.js": "de8baa659c71b35cbf0dcc203ba9a9d4",
"main.dart.js_259.part.js": "4f51327816d6c1a91cc91e4140c29cc2",
"main.dart.js_256.part.js": "b7eb9e32c2533a3055d0bdabc71af339",
"main.dart.js_201.part.js": "dab39da1fcedd45a88ea299e922bc423",
"main.dart.js_1.part.js": "c305226ceb5787a6e27f8a8cd0f1711e",
"flutter_bootstrap.js": "fd897edb85a3f2247d8ab794ab5a79c5",
"main.dart.js_15.part.js": "6f7946b1ad537764f547a3782e414fbc",
"main.dart.js_226.part.js": "9ebfc0b16012035bfd53c430b01ea7ba"};
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
