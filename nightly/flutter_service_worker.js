'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "5056b1edd9105df4f611c80f3d33f3b9",
"main.dart.js_308.part.js": "1f40921cd7854cf57bfe7e3a29abec3c",
"main.dart.js_271.part.js": "e86d6d4372472493902da599824a4dae",
"main.dart.js_317.part.js": "b70ae5a0412f927e083550b8dc51be5a",
"main.dart.js_297.part.js": "55d52d2ee28d68da803506677c0ea413",
"main.dart.js_1.part.js": "8f88eaa10515b79dd79151e78d3c46a9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "18a164e9e1944cfed089b73bd84b5228",
"main.dart.js_311.part.js": "5f9ed1efdd675109dde28a93808663d1",
"main.dart.js_220.part.js": "30530717ba2f897f71e52f2000defb1e",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "c2a6c0629481ccbbc7c8ab833400c008",
"main.dart.js_295.part.js": "146b483c98c59a6b0f5b43d9d4f48715",
"main.dart.js_316.part.js": "f71e6150a1115bbac14cdea1d2831df8",
"index.html": "e7a7ee14824a654aaa740881f2b0da92",
"/": "e7a7ee14824a654aaa740881f2b0da92",
"main.dart.js_302.part.js": "fb30d164b2e962fd67ad201aefd21fd8",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "eeb5a57f228e1a25a32e337c5ed2eb8a",
"main.dart.js_244.part.js": "c0f2a4480456fe4ffbdf88b66081fa6a",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "cef5d0d79c8edfe9c7adb93e93666e2c",
"main.dart.js_294.part.js": "7f9a98a104e6717dff37236c1025bd7c",
"main.dart.js_265.part.js": "13906cadc385ab105f50e985882abecc",
"main.dart.js_261.part.js": "72fc66f609d1044b928f5488e4121ade",
"main.dart.js_262.part.js": "ed1315e679894ed40b885d2ed937d3f6",
"main.dart.js_322.part.js": "84c9e006afa81ac082d9a1376a8a10b7",
"main.dart.js_263.part.js": "d1c88e05a07384e9ea533bed1f966dbb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "667850b4143eb1cc26164176b96fd3c5",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b6967fac60b0433c470be17adee48d11",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "7e5ec9207d0c5f4773172377241f044f",
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
"assets/NOTICES": "946df0b38a26047c6a3ed9fc0b54514e",
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
"main.dart.js_16.part.js": "8d06d07371a0cb30028d5ee8611da37b",
"main.dart.js_278.part.js": "5315ca17cb0891bff958ead96a6e63bf",
"main.dart.js_286.part.js": "bff7c490d129b5ff5bccf0abec6141e9",
"main.dart.js_232.part.js": "d12de932699bdfb2e88bd3ecf037a123",
"main.dart.js_333.part.js": "902f11d7202bd2c43bb7a3517ec01cfe",
"main.dart.js_287.part.js": "4c05518feaf271afe021309281cf12a7",
"main.dart.js_331.part.js": "4aa3b7e7a4d6156e90cacf6f4ae9d344",
"main.dart.js_212.part.js": "ab2e497fef64bf15d641d2ef91c256c2",
"main.dart.js_269.part.js": "faea0d4fb9eb200c8733a3f18170fc53",
"main.dart.js_309.part.js": "cd7486b667e6b8aa4abbdd2d8140c4d0",
"main.dart.js_312.part.js": "76c304260d25c5f824557d024930771f",
"main.dart.js_325.part.js": "f66c6b0df916b0fca06881b28e1b9a55",
"main.dart.js_321.part.js": "733c6b2d16b94ca2227cdca1fa951a30",
"main.dart.js_273.part.js": "90d39386e56e03f84dd72d4448e9c112",
"main.dart.js_235.part.js": "1430ad34f234d169430310daae9cddbb",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "013bff7e0ce024fe24d7e8aaabbda3cb",
"main.dart.js_332.part.js": "5321a18fd173510ba1733b93b3b3f4e7",
"main.dart.js_288.part.js": "ece743171b9f6e3aa1d4f8d068041841",
"main.dart.js_314.part.js": "9f6988559cca29595832880165a1f7cd",
"main.dart.js_307.part.js": "13dc0f7ea747b4fd671ac2df222b7c78",
"main.dart.js_253.part.js": "24745b6a8f44c94fa66a3f35822cb0f5",
"main.dart.js_323.part.js": "b8918f9cdcd6f64cdc81ea00c6f36aa2",
"main.dart.js_328.part.js": "ff6be6fda60feab13446e8190c586b64",
"flutter_bootstrap.js": "662fbe6a6e6fbfe80db02563c298769c",
"main.dart.js_315.part.js": "ba1c06f27157019dfb56eab5114383a6",
"main.dart.js_304.part.js": "897b045de0147e3dc75e5caa8d9fda11",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "b51f7112ff3941c653efbeabe2dd6c96",
"main.dart.js_326.part.js": "a8498dfeb938d838fe8c6efaa50439d4",
"main.dart.js_329.part.js": "2e53a7ce2025387ad94488075ef055f8",
"main.dart.js": "47def976643c260e2c372918da948f21",
"main.dart.js_277.part.js": "95e12a14aa9234286dc8b63c93221a04"};
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
