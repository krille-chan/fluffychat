'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "e1d03da6d2e5fb3f9afac7e5572146f4",
"main.dart.js_291.part.js": "f0f8f1812aea9515f63e9bbc05b1032b",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "7ae8f24dafcb4b51e97b04015ae54689",
"main.dart.js_190.part.js": "855739347a5b54e42c5809035f878c5b",
"main.dart.js_244.part.js": "05d5b364f6534b0dffd48a77ee3dd7da",
"index.html": "586b6d9041b4bc99bde6c78ae1e1be3c",
"/": "586b6d9041b4bc99bde6c78ae1e1be3c",
"main.dart.js_296.part.js": "05e0caab5844dd1b62999a31effeedc1",
"main.dart.js_237.part.js": "bd82935ffa580bb50b210253f2f7cb3b",
"main.dart.js_279.part.js": "7284ed5ecd029c2c11d600235fa30574",
"main.dart.js_295.part.js": "0c04644b765a87e6643781ed1c7eaa9c",
"main.dart.js_263.part.js": "b12572d3bbf21ab7aa09649733611d53",
"main.dart.js_1.part.js": "487d02af756deb8c63f3e11ebc768784",
"main.dart.js_276.part.js": "5baf4ca4b94d539b30904485a662209d",
"main.dart.js_2.part.js": "d83ca9fabbe8277da48510c0f6dc18ce",
"main.dart.js_243.part.js": "22ed6e09c5daed2b75f4a78a9caf812d",
"main.dart.js_253.part.js": "0e2e99b27bacdd04dc5a2c7c0362a9fa",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "2eba1195c9b0458c06290dcb4dddd42e",
"main.dart.js_290.part.js": "4b7aa9ae16215b36de4c5097fcc73df7",
"main.dart.js": "64d91f00b4d1b5c77e9b58b53c57c2a3",
"main.dart.js_230.part.js": "75360d2275567e1b800d07ad2c13af56",
"main.dart.js_273.part.js": "6fca133f8169c48429a794d2bd306e07",
"main.dart.js_268.part.js": "d865d4627a162e916a2200e4883e5f85",
"main.dart.js_261.part.js": "3cafff65fd5233d227884b57aca09ea0",
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
"main.dart.js_203.part.js": "5f59e87e5b2ffb8f4f1d62011c2282c2",
"main.dart.js_241.part.js": "5f4835753cf5afe7ea8d17e720a0b9cc",
"main.dart.js_248.part.js": "31bb1cb50250300f92b233290496e1bf",
"main.dart.js_281.part.js": "86430012d729627e57c244c44097d639",
"main.dart.js_228.part.js": "52060389beff0845e368b8a41a32cee8",
"main.dart.js_220.part.js": "22c84d9f29628741bbab491dbff046e2",
"main.dart.js_270.part.js": "2601ae856f4f8c9aa69fa765de76e14f",
"flutter_bootstrap.js": "8a528360c4c7a7f9043116f0bd735868",
"main.dart.js_232.part.js": "78148847759d19b0f629bad79ddfd3eb",
"main.dart.js_280.part.js": "c95d6eef1129c9f65b990564cc20071b",
"main.dart.js_277.part.js": "4aea090771f6064850c32876002628c8",
"main.dart.js_286.part.js": "761a9617153e78823d7a54c0ef2d77db",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "8153917134b390b7547bbc9d062360c0",
"main.dart.js_15.part.js": "775ef6c949a98ba5424afc9383ae7cf6",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "8f70b9020f94ac88efe4d3088e78fbed",
"main.dart.js_205.part.js": "e6954aa2ff5ca5382ed237fbcfb0d589",
"main.dart.js_242.part.js": "3eaf26d5ff1d912682d27db55274e814",
"main.dart.js_229.part.js": "a21587c8e20f18a5fc740692c4c63ad3",
"main.dart.js_192.part.js": "a96a3dd0d4c4d820324173fceb5cfaa3",
"main.dart.js_247.part.js": "63f5837dcd9cfe718eff2f97788bb0a4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "89aef1e8d3669d797581a2f74a3d20f6",
"main.dart.js_292.part.js": "9044b8c6ac63096c11ba7bfbde41053f",
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
"main.dart.js_275.part.js": "44e64d93c2b896ab07b2545aeaa7c535",
"main.dart.js_272.part.js": "71910dccbdc8196e5ec87ffc13cbd127",
"main.dart.js_252.part.js": "02465bbd8982ad87e33ba6f18699944d",
"main.dart.js_260.part.js": "72a275dab382999695d5d62269413384",
"main.dart.js_288.part.js": "5bad9c2853083a9de86b313465e41648",
"main.dart.js_254.part.js": "02eb9c8ac4917355b6e4be16f5e06f77",
"main.dart.js_293.part.js": "580ffb150997718589e5cc691b549e93",
"main.dart.js_294.part.js": "f5c7ac0963df6f969c88d12fcfd3c9f9"};
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
