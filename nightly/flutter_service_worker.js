'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
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
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_229.part.js": "6fb47818516992b6a43a1b99dafe469a",
"main.dart.js_254.part.js": "7c50d490604b33831e56be25e16e898e",
"main.dart.js_247.part.js": "e154fcbc2c829066eea8d2ff3abe5ec3",
"main.dart.js_291.part.js": "a5390d22d4f89c931241cc3c00da5a9b",
"index.html": "00438c24a3e0aa1ebb73a765c7f09a30",
"/": "00438c24a3e0aa1ebb73a765c7f09a30",
"main.dart.js_190.part.js": "b9816e6e5d9e16fa245ff8bb33203def",
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
"assets/fonts/MaterialIcons-Regular.otf": "961e957a4173f8ff1440af7e52118cc2",
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
"main.dart.js_203.part.js": "6657503660e88e3b667c6bfb60cb437b",
"main.dart.js_214.part.js": "001f99f0d59a9ca9e02ae5fadbf846ac",
"main.dart.js_276.part.js": "f1aa68767210c4a61fb6aedab4be686e",
"main.dart.js_260.part.js": "994dbaef97cb85023902bff4d35cc7ef",
"main.dart.js_204.part.js": "6446ff5ba89d02cca8e18276049a4da2",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "073f83cce73778029fe3a3cec0890f34",
"main.dart.js_263.part.js": "92164c82b60812d79726f285c9130742",
"main.dart.js_232.part.js": "47f0daa0807c35932a514e3dcf435639",
"main.dart.js_277.part.js": "1054435068c21fb9dab0d0d676adedab",
"main.dart.js_273.part.js": "51c7122f4295eae2521e8020661a4ec7",
"main.dart.js_281.part.js": "35106b2dc0dc683aced6758966852efa",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "18dc90a96d9c21aaa85f464b586351a3",
"main.dart.js_243.part.js": "89f90645a00dfa4e45ccb1da3599807a",
"main.dart.js_294.part.js": "85622b1e7f086a089eee237b172878b5",
"main.dart.js": "39f5e81a09d2a56531f5f6df9cb7c3f6",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_292.part.js": "482d8bdd5c5a0b298d05ad9c9e6db950",
"main.dart.js_244.part.js": "8ab53804dcf883548b02597126515b89",
"main.dart.js_205.part.js": "50c50943b30ca1215da27fe162f85fa6",
"main.dart.js_220.part.js": "fb29c56b9e38b1ee4bd4d92d172ee6d4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "982f331f12c8d2907a068fcaa22806d1",
"main.dart.js_228.part.js": "aa2ccc44abeee830c601896f48f8a904",
"main.dart.js_280.part.js": "9c9e2e44ce16aa5104c27e9a49e625e0",
"main.dart.js_296.part.js": "28e78cbb114344c3487c16f8acc2044a",
"main.dart.js_253.part.js": "c38c296f18e28b736799eeb32f06b3c5",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "04f1176168353ebecc9e9ce2e0e95aba",
"main.dart.js_237.part.js": "65b193de52cc7ba3d409e83062833414",
"main.dart.js_288.part.js": "1bf391ca5fad2b71441654c3518e9dde",
"main.dart.js_241.part.js": "811a4cd431bca1629d7d63a91411003b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "fd839632460a447630b94a725fd760e6",
"main.dart.js_286.part.js": "ae020be09bbd930f5b90923098a3cc0b",
"main.dart.js_192.part.js": "fa2fa3ad7189310ba042b02429bad378",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "7511b7729bff41f6b7288e57d8bd625b",
"main.dart.js_274.part.js": "c46ce9d69729172999188b72954767cb",
"main.dart.js_239.part.js": "32b46d08540405afcb35a681730c0012",
"main.dart.js_295.part.js": "36a38099479b39a1ef27434c5c160730",
"main.dart.js_275.part.js": "77a345fe7f5693a0fd7539f4de4629cb",
"main.dart.js_290.part.js": "db073e2e3e292b10a21a25d7362bc903",
"main.dart.js_268.part.js": "f52fcb7a32a0558cf541e97095962506",
"main.dart.js_242.part.js": "8983d94dde1c7ec3532bef72a11a1b6f",
"main.dart.js_230.part.js": "3f7d953d5f65889ba783d9d5ecd75a32",
"main.dart.js_272.part.js": "7cb20afd4b1b16273fd22bd3600865f7",
"main.dart.js_248.part.js": "5356a73dffad1c411c2f911271e53c68",
"main.dart.js_1.part.js": "53db3e83792aee613a2e9ac65a969966",
"main.dart.js_261.part.js": "39228c4bc4e26b0d122879fd2c715d8d",
"flutter_bootstrap.js": "a6c05812d8190032ba8ef95f4c5652ca",
"main.dart.js_15.part.js": "61d882d1667cc41b749417577982e930"};
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
