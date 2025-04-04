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
"main.dart.js_229.part.js": "9024796867674cee059670cf1ba487ef",
"main.dart.js_254.part.js": "b2d0ceb3e907455e0d13f0d201543037",
"main.dart.js_247.part.js": "51594d31c16b32aef922b7124d89c23e",
"main.dart.js_291.part.js": "1207750ced68a07ce7b4e9c12a18a1be",
"index.html": "6f9e60d57c522f2767dbc6ba6aa91ed0",
"/": "6f9e60d57c522f2767dbc6ba6aa91ed0",
"main.dart.js_190.part.js": "03fe1ed9c61394449170bff0f3f7520b",
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
"main.dart.js_203.part.js": "454491b199c6c45d71573d64c2358bf2",
"main.dart.js_214.part.js": "f86979cc3a8defe3a53e570730acea80",
"main.dart.js_276.part.js": "e4ec695c2b7a266e4fa191c9b05b1e2c",
"main.dart.js_260.part.js": "015edb61a8ab115ff30b6b2516a94754",
"main.dart.js_204.part.js": "264d3e3d78ac755ce68518c153fa60c5",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "e35b3290cdc5f76af95b27db7672b27d",
"main.dart.js_263.part.js": "fcce796bb22bd51fced44536388ca866",
"main.dart.js_232.part.js": "e632dfa60e24d70a55a715d9b49a2d3f",
"main.dart.js_277.part.js": "116621b420f261bf76e8edc434d01f7b",
"main.dart.js_273.part.js": "d3947bd6d59481a4b9bca9002ab68d0b",
"main.dart.js_281.part.js": "1714a3a7d4bcfb5a13d18b4c1946ecc4",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "8b07f67ac73e45ca9dc592725a0cce42",
"main.dart.js_243.part.js": "461d8890055cf4c56cd65539b9163cac",
"main.dart.js_294.part.js": "0959b9dd55a032e2f3231fb9b2a9f452",
"main.dart.js": "d0e38549cbb8b780cf7bb231a3f048df",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_292.part.js": "e27ebcb9b5f9ecb6afe9737da2f38eff",
"main.dart.js_244.part.js": "055674584ad8c074ccebe214be734ed8",
"main.dart.js_205.part.js": "890c54bfff05872b3d1edeb15ccbe1c6",
"main.dart.js_220.part.js": "06e453b84713ec0d9b8d4b5899f93ad0",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "df2dd6d1d65081ca58fb49ef5a867bde",
"main.dart.js_228.part.js": "63ecf4b271537fd7614782c650a1552f",
"main.dart.js_280.part.js": "a4beb739e7bd70166b9507c3be22fe0d",
"main.dart.js_296.part.js": "091dc330a43b88ba7cbdc6636a6d2bff",
"main.dart.js_253.part.js": "716029567939deac1c81450534a6e73e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "a090201f15cdc77c315f83b531df117d",
"main.dart.js_237.part.js": "2228379fedfba0ca5397116c06545b42",
"main.dart.js_288.part.js": "70cadf9715eca090d829fee07aa11d34",
"main.dart.js_241.part.js": "2f1072d3c8abd3a37f66181715b6e70d",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "cce90855f09496e71d8c8a592b40a598",
"main.dart.js_286.part.js": "089ba288ef99906ceedeb409bc22e85b",
"main.dart.js_192.part.js": "e09b99ea6f5038f37d9ea1ff50c8d863",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "477ec9b1c205489682a8ca6be08b0bf2",
"main.dart.js_274.part.js": "bf25c7aeffe62de1ca06a00beadaf06b",
"main.dart.js_239.part.js": "e42770b022902a532c5fe33c8386be59",
"main.dart.js_295.part.js": "7d9c1d4137e95e7da782dd1e2b61f646",
"main.dart.js_275.part.js": "421ab60d5fef921e6cce26b75e1cf72a",
"main.dart.js_290.part.js": "5bd819b49dd6cc56ec3e153e3f7d6c08",
"main.dart.js_268.part.js": "0a088ba669a5d5c8d1a43bf69a79b0c5",
"main.dart.js_242.part.js": "1444d81916e47b29ef2e5c6e2665332f",
"main.dart.js_230.part.js": "5fc302010c4895a0982ce3ee635a8043",
"main.dart.js_272.part.js": "b75e3480d82eec58857b220571c5e998",
"main.dart.js_248.part.js": "59b6f60801ace36cff1943f4ecc592c4",
"main.dart.js_1.part.js": "b700b2794cfb31b29617ac73c396cf69",
"main.dart.js_261.part.js": "bdf0e36011655dd98fbfa01e29c62b9e",
"flutter_bootstrap.js": "ecd5516796181c814065e35dca7709c0",
"main.dart.js_15.part.js": "27a6472c7ea67e86957741b6e7b85128"};
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
