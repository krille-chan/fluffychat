'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "c1a89cb82168eb795ad81a8c0f17654e",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_220.part.js": "7d726df65471b6b1cfca7fee7b6230f8",
"main.dart.js_1.part.js": "8c0f1b95427b3987b5d8ca91d643aaf9",
"main.dart.js_293.part.js": "6987a1aa94baa4e0208903651779ac92",
"main.dart.js_302.part.js": "e21f48a759b16ac4d83ccf556ce4857b",
"main.dart.js_321.part.js": "7d393546d287c580bd1240f6c81cebf8",
"main.dart.js_253.part.js": "7387f523b125d4f4fe8b51c8fb683d76",
"main.dart.js_305.part.js": "ac67d65adb4aa45778531014814157fc",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "a414a970fb024fd2c00c5d86084b7071",
"main.dart.js_277.part.js": "d58dece5974be22b0982dfdfb4f1b6b4",
"main.dart.js_265.part.js": "ff677b744f172809aec9d2ef10ac45be",
"main.dart.js_323.part.js": "4a7b7e65603b70b3fb3d652fda6ee5cb",
"main.dart.js_225.part.js": "83bf8a76d41985fcd80ce68688b2883f",
"main.dart.js_301.part.js": "c9b0849764a659f338b30bc64aee49f9",
"main.dart.js_295.part.js": "a2fa002dc82e4173f69822d089447e36",
"main.dart.js_278.part.js": "01e313e5cd1de9baba87f0e0abaa86a0",
"main.dart.js_312.part.js": "e5f52f92f0c86d07edd3b87c900263ff",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_268.part.js": "488acb3716251e532fe748b7c4775810",
"assets/fonts/MaterialIcons-Regular.otf": "dd361349492111cd1aeb4ac406910792",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "32264d576c001f8ea24a9a8a8caa4ec2",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "48ced315403b507753c6974c8fb41595",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/NOTICES": "1895c67917f245177505cc36a357731e",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"main.dart.js_298.part.js": "c67fec5c33e350d4548a7d2cd870937c",
"main.dart.js": "0ffed5902a71a408c7420efbf2e474f2",
"main.dart.js_279.part.js": "959ab7c03cdb8ff0d6009f40b1844d88",
"index.html": "a907877cb25d055497125d9028d59737",
"/": "a907877cb25d055497125d9028d59737",
"main.dart.js_307.part.js": "b326629a98023d4a90829cbe67641082",
"main.dart.js_318.part.js": "3c7bc0201dd8ffda995a3f416f2859ee",
"main.dart.js_254.part.js": "1030b250b7c3b6e7074a96a8b215555f",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_257.part.js": "46d23f0a256bb46b740912a7a9a72eda",
"main.dart.js_228.part.js": "443c33c553d519a7ce5c27ec82859d0a",
"main.dart.js_274.part.js": "0499a3ff891ff681162e8789c42798ec",
"main.dart.js_236.part.js": "eb08e25d25163f62d51b399e27b10ff1",
"main.dart.js_273.part.js": "3ea90603f428239dd0061a519a9cdbe7",
"main.dart.js_267.part.js": "05cdc347f8cd25b8abb03ccaa4dd5967",
"main.dart.js_288.part.js": "a259bff25b34eb19c6925b5f2c55192a",
"flutter_bootstrap.js": "b396c3b115647f65e6ab75ae01fd3106",
"main.dart.js_261.part.js": "6423d5c57c5f9cdcb3b37d243a517c40",
"main.dart.js_322.part.js": "69c11c227964a53a66c951d068e19ede",
"main.dart.js_308.part.js": "b3724f9fb81bce196236837f453622de",
"main.dart.js_300.part.js": "93c9570fbb9d4ef9a72f5c291838bf5e",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_255.part.js": "165207d973690e840d894a24f4beca46",
"main.dart.js_286.part.js": "9b1002284faf2a6adb1623905a304d31",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_299.part.js": "d46eb255c3fb22949af4f1eeaa11f82f",
"main.dart.js_303.part.js": "3f199556dabd833523187511b20663a7",
"main.dart.js_263.part.js": "90ac5b28e5f4fbca62d843cf271f437b",
"main.dart.js_242.part.js": "9fcfe42e84aabdfb0cb3781e1055eba2",
"main.dart.js_317.part.js": "56bf292f54924c59afb6bad02e996023",
"main.dart.js_320.part.js": "e288a1e02b5f33da42e7a98e52fc6ea3",
"main.dart.js_316.part.js": "70676042112405e7b908091da7837bd3",
"main.dart.js_212.part.js": "2f648ac928b19acdaaad8d5b17da9537",
"main.dart.js_314.part.js": "db4c30c22c553b8872da6e5f1f3e6979",
"main.dart.js_269.part.js": "87d5c3d1ec28afe950b4d88e50558d11",
"main.dart.js_319.part.js": "e1588d644ba58318ff4c0c8d68305f2a",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_306.part.js": "fa49f7c95e93571cd66138ef7fea441b",
"main.dart.js_210.part.js": "e75ab0f867e455eec4b656e95fb220a3",
"main.dart.js_285.part.js": "c98e77577f8a7dd45df9420bd31bb1e2",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_245.part.js": "6d44d2050d2f3ab785ba819d1ddf9700"};
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
