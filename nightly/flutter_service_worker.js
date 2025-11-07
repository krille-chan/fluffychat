'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "3417e4a02ec7f93cb61eb7c116667588",
"main.dart.js_308.part.js": "37e470e3e03908cd3c0271b5b7052106",
"main.dart.js_271.part.js": "a82e03c7033ba07e3e451b51e7785670",
"main.dart.js_317.part.js": "8a800109825e47b2ce88244ac51b2262",
"main.dart.js_297.part.js": "cbef0387908a2d3f5f39b78f2df2ffbb",
"main.dart.js_1.part.js": "c50bbc8ca7549809e8d40c386a5d0fa1",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "d8306f945f688a09f636e470d234efa9",
"main.dart.js_311.part.js": "a8566fc4014ef2832d6ae9e9f8e7eec2",
"main.dart.js_220.part.js": "8b1e51280c3e443956f54dd9ef25cbbd",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "f80df56e212817a02311cae11e057a8a",
"main.dart.js_295.part.js": "575264b2e17e9d3e6adab51b7827390c",
"main.dart.js_316.part.js": "6c32b7f7043f4ddf9637ab7fe8232683",
"index.html": "de687c6b4f936e595248f39e9d893ffa",
"/": "de687c6b4f936e595248f39e9d893ffa",
"main.dart.js_302.part.js": "b3c41a26f85556d1e96d9b10ef8e307d",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "1102ebc4b3e8496510da94913d3c40fd",
"main.dart.js_244.part.js": "d8269931a40d11679d92206200012bda",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "c2d32c281f05753f8dbc74041f84b994",
"main.dart.js_294.part.js": "5ce6a0f6605c1511c76593deedc65b32",
"main.dart.js_265.part.js": "b995ac9ae541f29c46e5b9dabff0b2e0",
"main.dart.js_261.part.js": "654c66d16447023d6f38c9e128958050",
"main.dart.js_262.part.js": "e216a2d2bbc656dd089ab09ae80926f2",
"main.dart.js_322.part.js": "f6b4819ed2d84727472a68ed69e672cd",
"main.dart.js_263.part.js": "8f2284252767d7177c11cf137b3f7dac",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "f6f01d34474d5356c3d61fce456a5db5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c8961c4e0435186f6a7064c35b698795",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "c137c821c6a2ab637f83bfaaf8b23433",
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
"assets/fonts/MaterialIcons-Regular.otf": "74d774e5a77a4138a1b82ca633ae813a",
"assets/NOTICES": "4d4d997f25d9bd3d4ec2a0c14ffc01fb",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_16.part.js": "44264c0686719dceb1cda146bd622b21",
"main.dart.js_278.part.js": "55d7aeff4a7c7289bf698f9269b60f78",
"main.dart.js_286.part.js": "1fe67111113d2850e69a2824b1abbf3e",
"main.dart.js_232.part.js": "a55f25cf981fa450c6908c141a8f6e35",
"main.dart.js_333.part.js": "b02ec28254715f50d7a8a2b6cb7a106a",
"main.dart.js_287.part.js": "6fbfad464c99f98e11b6f8036a2692d4",
"main.dart.js_331.part.js": "48126a6f904966cdaa0fd880e3365b71",
"main.dart.js_212.part.js": "de6fd6e81faea9bdd89055ffaa9bdc03",
"main.dart.js_269.part.js": "ea69703f60ef4a1625504b98804e3049",
"main.dart.js_309.part.js": "f0713bfcf4fbd248f52bdf33685e6384",
"main.dart.js_312.part.js": "e94a60a907ca65054255111922ac0df2",
"main.dart.js_325.part.js": "1e40a04cd21d89b8853389172ab05f60",
"main.dart.js_321.part.js": "e5dd34c697137847279ebc3fb9c2add4",
"main.dart.js_273.part.js": "306b5c478bf558a3b0ada473555fbd43",
"main.dart.js_235.part.js": "3525496c463273b2044e2391a35c399c",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "fbbe4bb2b416441f58dc882e670c2404",
"main.dart.js_332.part.js": "1539cc47f6a5db84d9763b1e7ed2228a",
"main.dart.js_288.part.js": "0b5572ebcafc238592771d96d54ecc72",
"main.dart.js_314.part.js": "50975d07ee0fff3a5d1dfbab0f23729b",
"main.dart.js_307.part.js": "08b434f6d8ed35e94d988031c0b4cdc8",
"main.dart.js_253.part.js": "d969b4bc9d690bb7609106a8f714da7c",
"main.dart.js_323.part.js": "0597a5da3fe335ad31c9c21f3dbe81c2",
"main.dart.js_328.part.js": "e342b8f7a4b75550db65e5c95e755006",
"flutter_bootstrap.js": "47cdc62aad94d1f276fd95649eb9a54c",
"main.dart.js_315.part.js": "9e364157a3279949e6d851cde6904dd7",
"main.dart.js_304.part.js": "f7a883c824b09f18f435faba7163b05c",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "7fa8023855f83490b0306d20fe937bf4",
"main.dart.js_326.part.js": "1e77486a82d3013a68a2c0fad7a4330c",
"main.dart.js_329.part.js": "9efaad556b998d01f14ca3b95d035347",
"main.dart.js": "8bd6507598fb08d67640549ab1badfd1",
"main.dart.js_277.part.js": "4b74f59487ecd8c3052852bcb1d7d200"};
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
