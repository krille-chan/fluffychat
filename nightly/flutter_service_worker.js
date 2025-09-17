'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "eba9fd7499981ff9208b60364c184f88",
"main.dart.js_210.part.js": "8ee4dc6c9fa178eab92f6224cd07fedc",
"main.dart.js_300.part.js": "ee15387a4b94837de35bac5dda730aef",
"main.dart.js_228.part.js": "a65c59eba158dfdbab85241197dd126c",
"main.dart.js_257.part.js": "c035a822a356d528df9850405c8d36ff",
"main.dart.js_267.part.js": "3a7e5a6e0c54308f4402376aee6ee6f3",
"main.dart.js_301.part.js": "30aed13b310771ab2ef8d0569bb989bb",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_308.part.js": "5e8da1796b2a828311a57d019e9b1c49",
"main.dart.js_303.part.js": "941e176ec7ab9d60377bd7f56b9a3529",
"main.dart.js_273.part.js": "92a9461c245fce3aed699dcd5b53c287",
"main.dart.js_265.part.js": "d863420597897e4899aed82a0b7a038e",
"main.dart.js_319.part.js": "f65fe82aa213257f3a0e3e52fc5b4f52",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "1cb598f0a3fe26d71c6395af9937f45d",
"main.dart.js_279.part.js": "b210cfde9defb54bca78db210da89a9f",
"main.dart.js_288.part.js": "38ea5c2a8f62eab83c70a8847860e11d",
"main.dart.js_302.part.js": "00e595dcac5d770363475017474e5815",
"main.dart.js_269.part.js": "88c174421958263bc3f45c7ac2f9a462",
"main.dart.js_212.part.js": "f4b7fc7eb92965bd3730af2539152a09",
"main.dart.js_305.part.js": "366e83ffa516409188037993dae950ac",
"main.dart.js_293.part.js": "f6b45e4eaeb75b41e590d1a2e3929ffa",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_220.part.js": "ddd6cc76a996cdb589b7b38128951248",
"main.dart.js_316.part.js": "41b77537c8c6c32e96aee15f09b7946a",
"main.dart.js_318.part.js": "4ab8db5017a1f8593e7a866ad4008cc6",
"main.dart.js_253.part.js": "f4394968b7a1b0e7a7a7dff721763fc8",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "7d56baac9fe7936e4c19459b754d9300",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "1e2922079371232bd875cecd5b82790c",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "9f367ffdf36e2795d259daafbb083e1c",
"main.dart.js_1.part.js": "679e315590a5ac84e81c56c7576f83e9",
"main.dart.js_298.part.js": "afd25c254c4d228739b45c37f0eb3e8c",
"main.dart.js_261.part.js": "c1594769ba536076599cd934f8f9d5e3",
"main.dart.js_320.part.js": "13f5aa70aa90aae57d3820243904474f",
"main.dart.js_313.part.js": "68eca26909ab101bb2b4f314b4be32b7",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "80f3e3a980935593c1681ef1c267b1ff",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d2ce27d4605671a0afb279b40c88f5ee",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "70c102b838e407aeb27afbe1019861d0",
"main.dart.js_242.part.js": "424c6d3e09b9bd6a1e0796a277c4ec51",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "ba42b8b3fc2c59b44d3cbfbf7385d39c",
"main.dart.js_321.part.js": "891590ef412a1db97c7646b27d6eb9ac",
"main.dart.js_286.part.js": "4d5d5c8b33d4262369e7dcb4779c1dbc",
"main.dart.js_268.part.js": "865b19b7981993f666cbdf480a750572",
"main.dart.js_255.part.js": "6bfd35324562900dfeb28a5c83f2ed3b",
"main.dart.js_278.part.js": "437969dd7fbc8252a897e6f1a2857485",
"main.dart.js_323.part.js": "50e52220684a912a361512a42eee23e6",
"main.dart.js_299.part.js": "76cc304a9f4057f5ed7033abcf051013",
"main.dart.js_16.part.js": "8190b58962168f2ac3070cd49d36cff5",
"main.dart.js_236.part.js": "8a6e3152f181231831e662c7096e42ed",
"main.dart.js_322.part.js": "fb110a16a109217f7c163d484d315143",
"main.dart.js_245.part.js": "0e939e9e5d7e1cd07a4b10d65364c2cd",
"main.dart.js_285.part.js": "c81305f6d0186b42630571b665afc457",
"main.dart.js_295.part.js": "218628a19254717e3404f8d131c80307",
"main.dart.js_312.part.js": "4ceaf28c5be576caa934d84de150b14b",
"main.dart.js_307.part.js": "5f1f9fdb0e7d43499660249c8ad61e06",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "6b1a21328e0aa52aeabf436b4f4095a5",
"/": "6b1a21328e0aa52aeabf436b4f4095a5",
"main.dart.js_225.part.js": "0de0cc8ecef76ec3cbefe39efbb7e54b",
"main.dart.js_306.part.js": "1a35ed4a994cb2322be61576f26cdeef",
"main.dart.js_317.part.js": "e32fc984950307575c0bf3dc5c78af18"};
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
