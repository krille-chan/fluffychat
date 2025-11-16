'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "83bade72fb7b011ffdd955f19565ab95",
"main.dart.js_308.part.js": "da5c1ae11164453a6696a122f2305916",
"main.dart.js_317.part.js": "dcdcb5a0f6dfac3d17fd3bbef4a30824",
"main.dart.js_243.part.js": "ddf8a68d0696270cbb37766770a4a2d6",
"main.dart.js_297.part.js": "904288b584ee54008dfea3886c91e8ee",
"main.dart.js_1.part.js": "9eceafd272b203ebf03088308e36bc92",
"main.dart.js_260.part.js": "f13721b6c6ddec5ea1a53267057ab656",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "8053fecab5c4bdcce32e65ee7f334d73",
"main.dart.js_274.part.js": "acc3ce8350e831f622f19688bdcbc5f9",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "8733589beefd9f3ba10c42e35907758c",
"main.dart.js_211.part.js": "5027c182e2fa44f975cab1779643acc0",
"main.dart.js_234.part.js": "e9da9ac5c292b9c7f0a3e09386923c7a",
"main.dart.js_316.part.js": "ec5f63cc1d2317d24a2ba8f955680b6f",
"index.html": "a642b70015f8e1052b2e9cd1d61e65ef",
"/": "a642b70015f8e1052b2e9cd1d61e65ef",
"main.dart.js_302.part.js": "41275f6972df2b6e6692535499cd33f9",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "ff8e3e2a5aed15182e6bd291961295c8",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "85a2730444635b08ef9b6bcba208f819",
"main.dart.js_294.part.js": "10f5c9d259077202288be2fa833d9220",
"main.dart.js_261.part.js": "0d96db2c0d8a0fc714e647b2bd50e407",
"main.dart.js_262.part.js": "0aa3aea895c02f943429d26b0e2af2b2",
"main.dart.js_322.part.js": "42f50ba92db5b9e6ad5921dacfa7efb8",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9347f6bc15b416299447c41f09d07dc7",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "84122286712f363413510742832b877c",
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
"main.dart.js_334.part.js": "ab0ef3f5275170c18d0b7618b7d15096",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_16.part.js": "ff06f02cda3af5edc7b1b2825093d1fc",
"main.dart.js_278.part.js": "7f241ec4e93097d85f75e29755492cca",
"main.dart.js_286.part.js": "84e61214271f0167b354f51fc958281a",
"main.dart.js_333.part.js": "b8189354230028150a36296357231264",
"main.dart.js_287.part.js": "56d844931fd3467584a97f34dbaf29b1",
"main.dart.js_331.part.js": "fe6ce3519ba57551bf7de08b4b6454c8",
"main.dart.js_252.part.js": "665e1e900656a3c6b7f9259b7b25e3d2",
"main.dart.js_213.part.js": "6c1b0e5c060afd7ba93f7dafb6f9f3f2",
"main.dart.js_249.part.js": "b4161dd4283d95769ea96a8a21dea909",
"main.dart.js_309.part.js": "6874a18a5dd1015740aff78aa586b345",
"main.dart.js_312.part.js": "1dbb5a37534f70dfba0961807155fbe2",
"main.dart.js_325.part.js": "55e10a3906190d30b3222bfeb8d833d0",
"main.dart.js_270.part.js": "d6471974a598e7bab8bd43c0aaa079d4",
"main.dart.js_321.part.js": "0ba3d30c8f94705436711afeb8862302",
"main.dart.js_268.part.js": "84100eb195c9e33b73c2463dcab6e709",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "5d5856e708e168bcb41d709e71c4bcdf",
"main.dart.js_288.part.js": "d1b2d7b50d403bcb0b6d489356d41550",
"main.dart.js_314.part.js": "a2ec966195fe9abbcae7feb9f4a2fe41",
"main.dart.js_307.part.js": "7ea976645490fdc8d68573d639f44922",
"main.dart.js_323.part.js": "5ac3ff12016820557e6677c8bfac9115",
"main.dart.js_328.part.js": "aa9907db612a41f6ca598ce81797527b",
"main.dart.js_231.part.js": "bc4a272ff4a074d90b8505d77d69c90b",
"main.dart.js_219.part.js": "760c6e70f8ebff870e054578a7f80b71",
"flutter_bootstrap.js": "dbefaba6a91c8eb92318adcab5a2f42e",
"main.dart.js_315.part.js": "d24ff8c1b0bdbd6f26253fa2ecda02fd",
"main.dart.js_304.part.js": "26358d581e1db38c52e771e870928531",
"main.dart.js_264.part.js": "5394e578db6be4f70a2cfe8e4c604caf",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "3c8e4edc1fcfb71caf60566268bf499c",
"main.dart.js_326.part.js": "b8ab0768032ded95aad216c54f8446d9",
"main.dart.js_329.part.js": "b08accedcaefb618091f01e7520b48cd",
"main.dart.js": "b86f9f513153c62e9d40d78800a6fad1",
"main.dart.js_272.part.js": "4d0e692abd6ec7d1619667b72bd04176",
"main.dart.js_277.part.js": "f9b7a4fef1fdf5994a6550d6932087d9"};
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
