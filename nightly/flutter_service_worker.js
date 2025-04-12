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
"main.dart.js_229.part.js": "d2ddc7020f1ca6d291e6d3f0a11f148c",
"main.dart.js_254.part.js": "4d4ddfe99e6cfa1e26f158a07116d463",
"main.dart.js_247.part.js": "5fcd2809d2719c314c5f75461a725087",
"main.dart.js_291.part.js": "ddf6a3d983ed044160b97cc8ceb831ff",
"index.html": "84b92a812b28f28eab252b78e3c02e92",
"/": "84b92a812b28f28eab252b78e3c02e92",
"main.dart.js_190.part.js": "a26ad97fb1ce081b96e23d818262226f",
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
"main.dart.js_203.part.js": "3568498ab27ebf671cb87ec0411a9e08",
"main.dart.js_214.part.js": "1fae6110668eb02761ba683077aeb87b",
"main.dart.js_276.part.js": "374e82a9321bba7bd68400ef05ff0ee3",
"main.dart.js_260.part.js": "97c895e46d0682a41db95b1c3cc8b9f2",
"main.dart.js_204.part.js": "cf6cb5c0cf8f9df41ab76c034eb231e6",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "c508701c800458c0c66646aae678ec99",
"main.dart.js_263.part.js": "2ce64570629337ae76e63aaed8360c17",
"main.dart.js_232.part.js": "706b8c877ed8990aa881722ade48e6b8",
"main.dart.js_277.part.js": "396c526ff88b82d5bb953a7f7d03c33a",
"main.dart.js_273.part.js": "1392bd169643c8f16794d3d70ad30895",
"main.dart.js_281.part.js": "5a19a660cacda6a936070ee96fa3dfe3",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "17ec133c5bacaf613bb7dc2c57cd0963",
"main.dart.js_243.part.js": "e2569fa6d00c11636559cc441784ebde",
"main.dart.js_294.part.js": "7cedaa53f371ea74257a76db23f6f265",
"main.dart.js": "07fc67be987ddec92e5cae4a0e051046",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"main.dart.js_292.part.js": "bf719ccffef2a6ca19467137e612c1a1",
"main.dart.js_244.part.js": "1d864bb1a25ce54da69ffc057214c51a",
"main.dart.js_205.part.js": "ee2dbfe79ede4771883f62c9c0c766f0",
"main.dart.js_220.part.js": "07c10f089007eb8abc7d3fa7dbf601ad",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "5ffc5c9776b75bd9fbc2fa9202b00a07",
"main.dart.js_228.part.js": "111e04e85d540694a73141e9d4e44066",
"main.dart.js_280.part.js": "61c4f80e146e4f44a10d5adb6f45c618",
"main.dart.js_296.part.js": "6837a6e0a5b0ec257725118dc20b2e70",
"main.dart.js_253.part.js": "fefa43e1f578d74357da00928c6e97eb",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "8bc389d30f2192da9c52b3ed8b11a528",
"main.dart.js_237.part.js": "414f0c544460124c94b22b611076272d",
"main.dart.js_288.part.js": "84d6686eadaa8783f53dd22092f0ad9a",
"main.dart.js_241.part.js": "750a0aea8038adcc11bab6b848306039",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "e5fbc0d6ac7dc9eb3fe1bfdf59f1c264",
"main.dart.js_286.part.js": "c6b5be21673ebebd00239b25532fcce2",
"main.dart.js_192.part.js": "307f9f4bbac8772eaf1d3d767b1c6c8a",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "dc48938a4a780a003d42304a20c0f74e",
"main.dart.js_274.part.js": "70180bea6e41b4610af83df3ec19a9f0",
"main.dart.js_239.part.js": "96b6abad4bef48d7a5e6bcc93e0fad30",
"main.dart.js_295.part.js": "a69bc3e475155d51cf45c24a403ab8ce",
"main.dart.js_275.part.js": "4cd6fedcc15ca4aa1a29d46a22faedf2",
"main.dart.js_290.part.js": "e542d9161c56bfa0f616cd7edd369317",
"main.dart.js_268.part.js": "725c1e1fb7872f82050266a1b4f664b6",
"main.dart.js_242.part.js": "c733bc0725d978d4f5bc8466925fde05",
"main.dart.js_230.part.js": "54e8d1295ee628aad0a1bcac71be4060",
"main.dart.js_272.part.js": "fbcdc9b231fc4898c6117be2b98c0f37",
"main.dart.js_248.part.js": "b316be3b9e30c0b6c340dde20d27b265",
"main.dart.js_1.part.js": "3323f323db2262e11274eee16fcd7213",
"main.dart.js_261.part.js": "c7a431f18c588dda636dfbaa7ab2c789",
"flutter_bootstrap.js": "24c7454014cb8ce35ce3feb654fe84ac",
"main.dart.js_15.part.js": "4234137ca656ad973db5e8c343681ba0"};
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
