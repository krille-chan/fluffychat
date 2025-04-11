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
"main.dart.js_229.part.js": "0b735a62757e6541ad375c8c8c9ff228",
"main.dart.js_254.part.js": "078c7b506734e0350a37aff6cc7c9489",
"main.dart.js_247.part.js": "84d57bc6adf92b02756b042a075b9585",
"main.dart.js_291.part.js": "6d8cf209f207b4539ad74de721a635c8",
"index.html": "43c1c0c753858d5d69e9154edbfa9a43",
"/": "43c1c0c753858d5d69e9154edbfa9a43",
"main.dart.js_190.part.js": "2242a101f01e2d4b47c937d95c84b7d6",
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
"main.dart.js_203.part.js": "d8665e0e34909dcd6412e2fac304ea18",
"main.dart.js_214.part.js": "fba68fb50fa423bdb65bfb42d81194c8",
"main.dart.js_276.part.js": "e9c8664270a976d5ba12379fb2677f25",
"main.dart.js_260.part.js": "be02a8f65cf4e87586353614918ff0d8",
"main.dart.js_204.part.js": "e13cecceba4211c38c0512e294f10c63",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "0d725bc1eda3ff2a53ac91ac562b7f78",
"main.dart.js_263.part.js": "d6cffb1a598a11b0cb1a52446a384032",
"main.dart.js_232.part.js": "d5a6a83dee4bf35b725fab0b10167354",
"main.dart.js_277.part.js": "731c2fc72bbbdea9eaf7d1870be184e8",
"main.dart.js_273.part.js": "17d9b6b39ef239b559138f40bb633360",
"main.dart.js_281.part.js": "b387b2b9daa6536bebb10b7beace08e1",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "a5f0e1adcc8f80bca7fd4f8c7ee37748",
"main.dart.js_243.part.js": "30b261b98aaf2337b30515874405b00b",
"main.dart.js_294.part.js": "d72c96e0f63d9eb26f22b0759d6f728d",
"main.dart.js": "26618ba27f86e2daf9870887e6201639",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"main.dart.js_292.part.js": "d92fdfa703b06d48e37fb2f59b737104",
"main.dart.js_244.part.js": "0a9f4c6a6e752dba4487004364d7be7e",
"main.dart.js_205.part.js": "a9d764b00f8f85bbfd225d0856d89a8e",
"main.dart.js_220.part.js": "d91dba021c0adf00e0db353d057a935b",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "ec877e98f9e896e63ca252a1a27f1237",
"main.dart.js_228.part.js": "6a14ee16216de3ee95d472a75a408eb4",
"main.dart.js_280.part.js": "21c1b355cd3cefd899e0af9f1cb5c256",
"main.dart.js_296.part.js": "ed62e0822f54f8dee911152ecfe3b2c3",
"main.dart.js_253.part.js": "8d6b1def7114de4f5463997405c87cb9",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "ab7d71585de6ced6a220270c8dfd1854",
"main.dart.js_237.part.js": "cd71a9ed228db9d6057eeb4ec0aa7dd0",
"main.dart.js_288.part.js": "8df27d1c8855fbc2ef314655920ae8fb",
"main.dart.js_241.part.js": "524a5466f8d4ffb20a2a273fcee2cee6",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "e295277891caf2cd2373237f62b856d5",
"main.dart.js_286.part.js": "55fd11ffd1fbfafe92e3ec2fa3f9da92",
"main.dart.js_192.part.js": "620ba665dfca444c14062d932bf9ad04",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "bd82838949e0d033c8a5b6f370317e3c",
"main.dart.js_274.part.js": "8d8db273a33a686b760a65d654790153",
"main.dart.js_239.part.js": "5a75a05c1be6c03d47a20a9a9ba72d1a",
"main.dart.js_295.part.js": "96c2ea5b918ff47074b972c345e7fdb9",
"main.dart.js_275.part.js": "9fbd51807676bba0ddd5e50398d8948d",
"main.dart.js_290.part.js": "c38eb7b1057b8ffa2b697eb8eff29d75",
"main.dart.js_268.part.js": "6b22a9bd384eefd93e13e163e01e4acb",
"main.dart.js_242.part.js": "25912b7d4db163cfd1b130a5027f562e",
"main.dart.js_230.part.js": "cedeb7d94618b37cecac6a31db5116b4",
"main.dart.js_272.part.js": "5120cda0f20a2569f3b861ed0afd80bb",
"main.dart.js_248.part.js": "028883cb4fcf429ba22c2c67443c9bd4",
"main.dart.js_1.part.js": "a14bcf5a0e166e9b554c11dc59b26cf8",
"main.dart.js_261.part.js": "59dc9eb96d8d3aa857d3e2c35ed732e7",
"flutter_bootstrap.js": "cadf2adf204ba2c721527324eabf6585",
"main.dart.js_15.part.js": "7720b7afd4b1e0046fa63e145d8d3a5b"};
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
