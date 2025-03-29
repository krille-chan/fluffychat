'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "fa320cbc1ffd9edabb38f49870cb0233",
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
"main.dart.js_202.part.js": "3ecc307b3def385aff591a24067f6c1b",
"main.dart.js_271.part.js": "e59c2119b56350eea4195c7218869d4f",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_236.part.js": "0f055b7c16c5e5407f20e66441fe5521",
"main.dart.js_229.part.js": "e34f0ebd0d44bd5e92ed16a4f7c0c296",
"main.dart.js_258.part.js": "fd92cef5acbb8ebff4575d39fa3c8248",
"main.dart.js_291.part.js": "c6068bdab46018f8f5907a8427f43ffc",
"index.html": "149b93480c9618dd3184369160970450",
"/": "149b93480c9618dd3184369160970450",
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
"main.dart.js_249.part.js": "c020aa0737fe692e3f081424ce174407",
"main.dart.js_276.part.js": "7ceee661fd67f689ba73705599ea2d59",
"main.dart.js_260.part.js": "14fdb1368401fd43ce432b5eb7ca2ff3",
"main.dart.js_240.part.js": "d31ef4a1c10da97db2157a6589bb8c7b",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "2d22859849ea666282e3cd3181c65292",
"main.dart.js_269.part.js": "aa76eb4c92e07affdf33b9135bde7273",
"main.dart.js_277.part.js": "8a4fa54d53213ba8ca93fbf9a84689ba",
"main.dart.js_273.part.js": "592bc1503dad5448ecc603fbac5e1acc",
"main.dart.js_187.part.js": "fab38d56dec26a80863686185b9c2743",
"main.dart.js_265.part.js": "de4ba5103afc54a023d19052849b3052",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "ea0ad3f0ffec17c16cdb86148f99765d",
"main.dart.js": "65aac73ed757ea77061a2e0a9872c8ac",
"main.dart.js_2.part.js": "a7c31869b11d6985a6c916e700b8fbfd",
"main.dart.js_278.part.js": "afe2be0f43b244b164fdf2c7a7055747",
"main.dart.js_292.part.js": "0ec1dae08d179853d05fbd9e0c98344b",
"main.dart.js_244.part.js": "b873aa3e065abb38d1a3317622802b74",
"main.dart.js_238.part.js": "d32618e49bc949178e9f9c1ed72cfb65",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_245.part.js": "23f3a9aa9bfae4adc947ac74ca0f9f91",
"main.dart.js_225.part.js": "70e1ba6974e36ba21c7be2a02dba0804",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_288.part.js": "92bcf0b0661f5086c0b30968578abc21",
"main.dart.js_241.part.js": "bcdf1c6b1c31119d12f7563311917b7b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_234.part.js": "ad71998503f544ff25c026f6914e66e8",
"main.dart.js_200.part.js": "6938a5b38ec9297632c0a7791949a84b",
"main.dart.js_287.part.js": "5cc6047780fd535397259ce8c1efe67b",
"main.dart.js_189.part.js": "4a27ceb7b10ecaa80e5588a318ef2c75",
"main.dart.js_257.part.js": "25ff6a0953063502486297f983660389",
"main.dart.js_227.part.js": "68149fd0ce6afb06fdb19e4ddd9d8fc7",
"main.dart.js_211.part.js": "0cf3a0835d2084854ad3ebe9effc9364",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "3b575c4f5e360d5a5e7114f34f05418e",
"main.dart.js_274.part.js": "432cc602e35ff104cc840d0cd7b258fe",
"main.dart.js_239.part.js": "7ab793bb62df98bc3e8a7eb46de75d07",
"main.dart.js_289.part.js": "63daa3d8a4f4759f864b4d2796374978",
"main.dart.js_284.part.js": "eaa879177ba32d46713ba8a81d785713",
"main.dart.js_290.part.js": "8d1dad03abc3adcb256535924e43283d",
"main.dart.js_217.part.js": "95fe7cf3cbfc7b43cf49bde324cf914b",
"main.dart.js_251.part.js": "a73752d69f629b3e3396057aac23ae44",
"main.dart.js_250.part.js": "edfb56acfc544d86f950d570182c0d96",
"main.dart.js_272.part.js": "7fe97804e3d9fad8b3d010ae46a34f4f",
"main.dart.js_267.part.js": "fd31dae1779f045bdcba42b58e74e31e",
"main.dart.js_201.part.js": "a55ee1808f37cb165f0b582eb0980e16",
"main.dart.js_1.part.js": "b98d75542504eee56ff0710b8a5dfe62",
"flutter_bootstrap.js": "7e4c52a9ad21022fee973df64cbad154",
"main.dart.js_15.part.js": "2bd1e49a0534c797173432c467d9c3a8",
"main.dart.js_226.part.js": "6d0e44d81301a14f7d5479042b543f7c"};
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
