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
"main.dart.js_229.part.js": "6dcaa84ced0b2495c088b463aa649cfd",
"main.dart.js_254.part.js": "71b81641bff73538822207fabe29fc2a",
"main.dart.js_247.part.js": "e14418d07c4daa66fb8276efb58bd82c",
"main.dart.js_291.part.js": "1f455d0f0c745815dbc8f85d67d318f1",
"index.html": "49df02064340dde66d39b711cdc1f29b",
"/": "49df02064340dde66d39b711cdc1f29b",
"main.dart.js_190.part.js": "5a413bc3838a585d8b7e16ff7f816e23",
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
"main.dart.js_203.part.js": "4c173a5b6bf35ea0a277738b19ce0cec",
"main.dart.js_214.part.js": "22cd140a8c59b4bf71a82451b2ee6276",
"main.dart.js_276.part.js": "9836956493cbea2a2ca4b6a873c022ac",
"main.dart.js_260.part.js": "16be7c62396b7b39f22e15fd7951426d",
"main.dart.js_204.part.js": "40c37738207c05d645adbf3afa07e714",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "08f3757d9c085a00393d3babe795bac7",
"main.dart.js_263.part.js": "5c39c86dc6a8f154953077fc4595ffe4",
"main.dart.js_232.part.js": "843d76c01cd3662b6ff85eb493baeb79",
"main.dart.js_277.part.js": "3a43799ccbee5c5ae6774ae59c68bd3e",
"main.dart.js_273.part.js": "5298c83b0d94bb8d79bc0a27e808d036",
"main.dart.js_281.part.js": "e8eb3a465495e89af5df38713864bf1f",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "c4616aad1ec72bfb5961b1abf714e0e7",
"main.dart.js_243.part.js": "b801756d2723a4127f367d786115c6b3",
"main.dart.js_294.part.js": "47199db8c44d46554e955765efee610c",
"main.dart.js": "76182f4dbc3c5f9dbf417e290180d489",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_292.part.js": "162196946f361e4c1d0194db9cd6c481",
"main.dart.js_244.part.js": "44378d657018d1a79dbac2a20596eb7e",
"main.dart.js_205.part.js": "1b81873724b432b13054389d93d5710a",
"main.dart.js_220.part.js": "4eba7a9fb375b440fceab56faa7b2478",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "8a6d7ce39faeb8f3ea635492b04ae754",
"main.dart.js_228.part.js": "9269a7aa9a8aa8c50c5ecee923c2afe1",
"main.dart.js_280.part.js": "16f40d23b3cc8d465402c9b5949b3ef9",
"main.dart.js_296.part.js": "7a4cf88a2834ce502b0ef243ced3a23c",
"main.dart.js_253.part.js": "c55f7332cfd973ea09da913336e96690",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "6a1dcfa2ccac4b7d8736df1bc8f9a433",
"main.dart.js_237.part.js": "64d5aaf6f21879fc56e93d8828b4349f",
"main.dart.js_288.part.js": "db28818ca49c863e88c01a047581d6a0",
"main.dart.js_241.part.js": "3f0efab1279e6a0812da40ed2c500229",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "b5c94edc30e6b46e288a4a965e148e39",
"main.dart.js_286.part.js": "76a83af17e055d6e1399b60414838292",
"main.dart.js_192.part.js": "8131a7207bff61e92c64260bbbd52c97",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "2c5a1461160982ab7a1173828c10bc83",
"main.dart.js_274.part.js": "f074698540fdd0b937a0b36775725b76",
"main.dart.js_239.part.js": "ffb0ca32d57f92edf3d2736a7e7b5f76",
"main.dart.js_295.part.js": "65529ff40f307df9e13db653cb07695a",
"main.dart.js_275.part.js": "b71876c84eba61eb63cfb9c211a16ea2",
"main.dart.js_290.part.js": "3f4d333bdd4b87c9dff7182bae53eb73",
"main.dart.js_268.part.js": "00bad6c9915bf68a25e71dae4cdf409c",
"main.dart.js_242.part.js": "cadfb3c473554545640e42a506ebc762",
"main.dart.js_230.part.js": "4911abfe125773916ce8a889601878ea",
"main.dart.js_272.part.js": "7abf90ed33c3306a2cc64a3f5e20d2c8",
"main.dart.js_248.part.js": "237c7a7aafc8a2b8e395ce423acd0c96",
"main.dart.js_1.part.js": "af7ffb1110589bb6a175ecb75b02a8b9",
"main.dart.js_261.part.js": "7d71ab55c04ff8878cf1221f9eabb688",
"flutter_bootstrap.js": "6253a82b5610bd4e6e1490e59ebfc881",
"main.dart.js_15.part.js": "9242bc8fae1a931125ffde975aca0ff5"};
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
