'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "2494f7e7a1393e90a8eba79ebd46520d",
"main.dart.js_317.part.js": "1071f65570f2c8b8565e7c5696e2e363",
"main.dart.js_1.part.js": "bf7600e30cae030df94740e911b17c82",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "81f9363078eaa16bd0a50257d7477194",
"main.dart.js_220.part.js": "32701fdfb284f9a3d831da4703ea5480",
"main.dart.js_274.part.js": "6b30085bb17a2a7efa8b5387ad9af191",
"main.dart.js_318.part.js": "26df0ff409633d30957ab89e4e658719",
"main.dart.js_295.part.js": "89d699f94c1ba1940cae818fe2ab6657",
"main.dart.js_316.part.js": "73ee82fd56381cef4aa8cbed0e74eebd",
"index.html": "1b36aebb175973b50c856a4396051f22",
"/": "1b36aebb175973b50c856a4396051f22",
"main.dart.js_302.part.js": "2375cf22348038f217b088a7456cd206",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "b4e9b58ffe40d9c6cb5f93ea8a88acb6",
"main.dart.js_242.part.js": "e96dc9811fbf3182240c1514393a1c07",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "2869bef9c345c692d9b13c6e0ee7fead",
"main.dart.js_300.part.js": "07e762bc785f322d0d2b65ddcbdcea28",
"main.dart.js_261.part.js": "f04a8986f528587b0f3b13e9570126a7",
"main.dart.js_299.part.js": "063da21ad8de009fa7c07e998a01f035",
"main.dart.js_322.part.js": "383c3222d7245c0fb0c9dd9d7527dfda",
"main.dart.js_263.part.js": "cb85a02cac5de947fa5661f5fb9d4c5e",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "14421337adec3acf0e11d9328c5ca0d5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8d78d5e526d3b4e71a9dcaa9564045b2",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "dd3c55163c414f47bcec2dff9a51c7b7",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/fonts/MaterialIcons-Regular.otf": "e43537443dee303909d6ef653cf99252",
"assets/NOTICES": "1895c67917f245177505cc36a357731e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"main.dart.js_210.part.js": "38f4bcd376f51c7528f2293d6e9490a5",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "9d533b386335e5a62fb9e99ef87d44f4",
"main.dart.js_254.part.js": "3aa7b0e0c29e0f391e8f6844fa95224b",
"main.dart.js_228.part.js": "dca2e9c771d51af55d59213cdfd47a36",
"main.dart.js_16.part.js": "561cad66ca8a2b5a7a16ce37a1d8edf7",
"main.dart.js_278.part.js": "312b2423c0140d7087b3754eca3d0368",
"main.dart.js_286.part.js": "7aec29955882eb497f3e4b841b233d85",
"main.dart.js_303.part.js": "8d3778fafaa1fc6242037d00c0c49761",
"main.dart.js_257.part.js": "f67e18af14ee56288a54118918aab10e",
"main.dart.js_212.part.js": "011461cfa38180cc1114a070bcebad4a",
"main.dart.js_269.part.js": "be99c41f61bcbba91b1fb446992f6b79",
"main.dart.js_267.part.js": "2f3d42da9b9e9c2955cebdcb6bfbf5cf",
"main.dart.js_313.part.js": "ff34d5186463021d1ec4425174caa05c",
"main.dart.js_312.part.js": "f3dcd40a331193ec89ae1c41b46bc75c",
"main.dart.js_298.part.js": "9a9e1183d094dc12d1beafcbcc4ccbdc",
"main.dart.js_285.part.js": "1f9bc8a23e584fd6f0e631c8070da157",
"main.dart.js_321.part.js": "93be889ad02d3cd11b7167580ed6d1b6",
"main.dart.js_273.part.js": "dac6da4fb23fa104f1fb3747a244919f",
"main.dart.js_255.part.js": "470e618b69402d31590c5e3f43e4d6ee",
"main.dart.js_268.part.js": "ae0c59a8ceae5ee918ac2bccf9b7f7fc",
"main.dart.js_288.part.js": "27cd06d5805dd146c156bf9187955f4a",
"main.dart.js_314.part.js": "6b2d64cdb2ce68c9f5ff2d02be661f21",
"main.dart.js_307.part.js": "7ea0abc3924e602a89416739f9813c20",
"main.dart.js_279.part.js": "7ad497e557dd9453603c15e5a63bf4ba",
"main.dart.js_319.part.js": "eff6d963a794b0505e5c49999b1519c5",
"main.dart.js_253.part.js": "e5b21f22053c2b0bc11da5cf2c2c1028",
"main.dart.js_323.part.js": "78ddb5ed2e4377924fffaa2f919c3360",
"flutter_bootstrap.js": "2245522876f71c971969acf6c6997675",
"main.dart.js_306.part.js": "20a1f61b20ac6ed04684ef9c70c1f5d9",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_225.part.js": "89750092957995253d7434b88332debe",
"main.dart.js_293.part.js": "f014f1929da15e797c61abee916aeaae",
"main.dart.js": "934d2616abab47ca4b85aa282eeaf8c7",
"main.dart.js_236.part.js": "e8f6629a22ebb30ab79f756ac85a052e",
"main.dart.js_277.part.js": "ac13ad8cc23ced3bec0a4927c351600a"};
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
