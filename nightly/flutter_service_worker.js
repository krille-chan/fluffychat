'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "2f0f8f3f643d0d727a727b3e72479856",
"main.dart.js_210.part.js": "4b3af83e8aa2ebe3951fc3edd2c121c8",
"main.dart.js_300.part.js": "defadff31f2c2ad8698c1b73b10749b5",
"main.dart.js_228.part.js": "5bc94879d31387bfc0f4f8fdfd16d548",
"main.dart.js_257.part.js": "eb77f7247431b23f58d465367f64bffe",
"main.dart.js_267.part.js": "7fcc2441478706bab35345ddb66e9406",
"main.dart.js_301.part.js": "bab5be983fb52e4730aaf7aac7ba5d29",
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
"main.dart.js_308.part.js": "6a6500c80f8ceb72f9601c58767b6fa9",
"main.dart.js_303.part.js": "94bd47e355d3d6235b8eb146e8685447",
"main.dart.js_273.part.js": "0c085cf9ca98f28dedee608926e8bfac",
"main.dart.js_265.part.js": "1d7a5222414612362dba1e276375e7a9",
"main.dart.js_319.part.js": "240941a82bffec258fdf62b9f7afdffd",
"main.dart.js_221.part.js": "2dc773983fa40a7915cd7252c8b0723c",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "a1cf83e15f721fedc695034cf09024b3",
"main.dart.js_279.part.js": "be821df39fdd6ba7be2827ba29836c67",
"main.dart.js_288.part.js": "3df8b9e144aa8f15526c24a8f9eee24c",
"main.dart.js_302.part.js": "bac648546288dcda3e7e64f89c231be0",
"main.dart.js_269.part.js": "537b07c0220f745de6837d86db611a8c",
"main.dart.js_305.part.js": "e1c2895d3298b84a44fc0067a7ecf8e2",
"main.dart.js_293.part.js": "9683f490fee6b22a8dbefb378278653e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_316.part.js": "d74d25bcc17f57bfca6c662fd31690d7",
"main.dart.js_318.part.js": "b0bfec39622e1193efb857593690932b",
"main.dart.js_253.part.js": "75106b12e905a4f96a03d7da6d92e1c0",
"main.dart.js_2.part.js": "5a7a87c48be3cbb45436f5efaaac9a85",
"main.dart.js_254.part.js": "1707110469a19af9c7a4912882d0395b",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "e7261212c6a8e92798ad2df028cbb95c",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "46c1bf1d3258158f90e5042f5396c6f4",
"main.dart.js_1.part.js": "3dd12738ea231fcf79298cf406cde076",
"main.dart.js_298.part.js": "05d690bddf6fd774e0f5cc558deb546f",
"main.dart.js_261.part.js": "cc4fa4ce1a460e7021a850a4dbf69ce0",
"main.dart.js_320.part.js": "b11cd06e6424062b8ff608896dad2e3d",
"main.dart.js_313.part.js": "6012098c9f123407813f220ef8345e61",
"main.dart.js_213.part.js": "b204e77bff35f27d62b9ca33d842a02f",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c391a4121e3f8d4608325d32403196de",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "594a2f77d19af7055f69a6d6daad1013",
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
"flutter_bootstrap.js": "9d1e7dac1cbe6a4c83455f16e6b6fe10",
"main.dart.js_242.part.js": "5caa29303a1f959ff1400b8bd7a031e0",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "071a6c44f47b1fdf0f6a23938b728e4d",
"main.dart.js_321.part.js": "2083012129f44c96b5444b0ec250b486",
"main.dart.js_286.part.js": "d124d08ae99750c88d6636d233b52a07",
"main.dart.js_268.part.js": "981b3a35ad220a66559db01a6b701c8a",
"main.dart.js_255.part.js": "4cab4bfe7171160da28887062597e8f9",
"main.dart.js_278.part.js": "a22522e7d3f98970f6d3f6ada4702973",
"main.dart.js_323.part.js": "1260cabcdf75cc54088e65acb0a76f0c",
"main.dart.js_299.part.js": "2e3993af24962e605d7a7fa4ae35953d",
"main.dart.js_16.part.js": "c868d26a439216c1c9cbb9f6a3590d4a",
"main.dart.js_236.part.js": "27af840e6068531d40e7ebd6a1bc6655",
"main.dart.js_322.part.js": "711a9f9e65f8f9c752f2fa1cd1d060db",
"main.dart.js_245.part.js": "2f1086c49f3342f7fdafc1ae7b49ef5b",
"main.dart.js_285.part.js": "5af661bd7d51ed87554543aeffd9576b",
"main.dart.js_295.part.js": "323d6b5c78a791c8676c78e58329fe16",
"main.dart.js_312.part.js": "66d75c2ab830c0d1b1ad23e4455e8edf",
"main.dart.js_307.part.js": "ebbe8208068a9dba93c99723f7e660c7",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "3b8baff959ec1f96034a429befb7bf0a",
"/": "3b8baff959ec1f96034a429befb7bf0a",
"main.dart.js_225.part.js": "4f76723416c3727b997d6ee3fe30a221",
"main.dart.js_306.part.js": "f0eb8f312467315035dc78faabdbcfdc",
"main.dart.js_317.part.js": "e3e6a1d4e95597c353e6279b4664e915"};
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
