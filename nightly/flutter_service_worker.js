'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_204.part.js": "f0618ae83831a35bbd242282e3df963b",
"main.dart.js_230.part.js": "0d0030691bbe3330c72f317af6b5aa4f",
"main.dart.js_287.part.js": "317521f75b006d718179b810981e366e",
"main.dart.js_244.part.js": "d177f1f2dc664d0f5bc9b83aa036334c",
"main.dart.js_286.part.js": "0dd6096daf76d64e4dd13ceb68139714",
"main.dart.js_229.part.js": "24fe8cea3b5207fea0a49a32d50b4e02",
"main.dart.js_241.part.js": "f916ec16b890a7b404b3ea3714c044db",
"main.dart.js_237.part.js": "df12d279b316b446899bb252d42da12e",
"main.dart.js_220.part.js": "399efd65b1655c4e86713a36a4f0f4bf",
"main.dart.js_290.part.js": "932da43b6b2e890e0b5a2223b5fd92e7",
"main.dart.js_260.part.js": "5907b8657797f191925d857eb6f5fdd4",
"main.dart.js_296.part.js": "b8eb68da324e78459182600c3c223337",
"main.dart.js_263.part.js": "09f50ac06af063d46d488031ce33be17",
"main.dart.js_294.part.js": "f693b087448794d7b9c9e6cf3b64302d",
"main.dart.js_228.part.js": "d43f4e60526d7d86aac986b7e0cffb5c",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"main.dart.js_268.part.js": "2da9ccb5b24ab7d547b6c489cc65493a",
"main.dart.js_282.part.js": "61c3e0026e2d7008234406df953df232",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_275.part.js": "bd0832c7e2f0a097d3d4ee6ce0a0701f",
"main.dart.js_1.part.js": "87a9f5be705be401593e433d7326526d",
"main.dart.js_214.part.js": "15c512c060d2788185c7fa714969a860",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"main.dart.js_248.part.js": "5930819044a094351d5800308f2e5f1e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_15.part.js": "888bdff43dcebb9d466650029da74b56",
"version.json": "bab3af646225186c2ee572830da047a7",
"main.dart.js_272.part.js": "31a622bea1dfcd089c5e38c7a0e79a43",
"main.dart.js_295.part.js": "59518e9442817e436310e56a0f514e10",
"main.dart.js_205.part.js": "b140193084e04d4f1c1bf69022bb7f4a",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"main.dart.js_247.part.js": "005cce90e390dfef00687e8bc8053e61",
"main.dart.js_261.part.js": "013e281b97a9922c303038482dae0a49",
"main.dart.js_274.part.js": "25be022d3a78c1c21d7d4c2d0cd0fcb4",
"main.dart.js_203.part.js": "6fae52334c84b34c963bd427c3577a59",
"index.html": "31240e9e74183bed6830a0284c889829",
"/": "31240e9e74183bed6830a0284c889829",
"main.dart.js_242.part.js": "e2deaa386e7e2dd60df111c4396ea08c",
"main.dart.js_253.part.js": "92e13625d1f2ba5438acb5f1f71a5e19",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"flutter_bootstrap.js": "216e68b4df9b2065f801bf0f22538790",
"main.dart.js_232.part.js": "fda236f4f6a406d33dc8ae962c46814e",
"main.dart.js_281.part.js": "e2b5a407c5d57e09d37d49c092e032d7",
"main.dart.js_190.part.js": "33970728f0fe9409e5de8b60abd02a31",
"main.dart.js_192.part.js": "a274083771385ec38face3cf4e1955f6",
"main.dart.js_279.part.js": "b8031ae0a6453ac639b673ac1cb8729d",
"main.dart.js_280.part.js": "c0aa63e0de3c7ee49bb54ef4f1dbc522",
"main.dart.js_291.part.js": "cda131f745d606c19f5a73dd3b577b3a",
"main.dart.js_273.part.js": "a0044c82f060b85e934d79484ad940dc",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_243.part.js": "c1e2c6e0faa4784a764ed20e76822274",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_252.part.js": "d0e4aea1cebf9f0c634f2c82e06c7016",
"main.dart.js_292.part.js": "0864236a0daeba936a703cdb00b6e17c",
"main.dart.js_288.part.js": "fe6f5b72d11eebefdf320e3cba2456e0",
"main.dart.js_276.part.js": "52eac021313cbe2c244195c2ea7cd704",
"main.dart.js_254.part.js": "b9801ab5420481539556ba4dc6feabae",
"main.dart.js": "469491e261067a0b29911412f06dcc61",
"main.dart.js_239.part.js": "34f254d95a34387425c5dce1ad8518d5",
"main.dart.js_277.part.js": "fb1f2ace1265ff5866da0b9710fda68b",
"main.dart.js_270.part.js": "58d11ada5483e06e46654570b59faba5",
"main.dart.js_293.part.js": "fb3b458aed44e3d4cb1e9f3a3da6b390"};
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
