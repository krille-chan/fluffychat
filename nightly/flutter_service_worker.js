'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "5d7334f9f3ab40f19169b5c71478e6b0",
"main.dart.js_210.part.js": "18e7896df94deef3df7323bae07d3e72",
"main.dart.js_300.part.js": "d4378a7b615a4ab7c499bdc46f48e594",
"main.dart.js_228.part.js": "583137c3c0256fdab4af12581f98a1ff",
"main.dart.js_257.part.js": "01b449180625ffe131b36465257c0f4a",
"main.dart.js_267.part.js": "0079f300f95fe267fb5ba9e2028f2de5",
"main.dart.js_301.part.js": "131e17bffaa781fddf8c376fde173c30",
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
"main.dart.js_308.part.js": "39c3dc1d9a60733985dfbc1539915015",
"main.dart.js_303.part.js": "36d6fed6ad22beaf44a4746ee8384a08",
"main.dart.js_273.part.js": "f9398c0d17b46aab1737011232b1f623",
"main.dart.js_265.part.js": "616c46c5290d50b81c885fd786fdd7d8",
"main.dart.js_319.part.js": "31d642e265f3078f8dafe29301fe0934",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "b2f142f66cb8ce01838c417f0fad0ebc",
"main.dart.js_279.part.js": "64b06b7aed9fac293a9d13244104e6cb",
"main.dart.js_288.part.js": "6b8ef0882c54310933e35682e9156a36",
"main.dart.js_302.part.js": "b94a7b834668112ec19e09f4cdce4a54",
"main.dart.js_269.part.js": "218b3bee946e69f00563204f4662bc84",
"main.dart.js_212.part.js": "e2462ee4c0b28ff51780bdff9fee4711",
"main.dart.js_305.part.js": "f520300a3d071bf210cd77ee75e374b2",
"main.dart.js_293.part.js": "0fc85f28b9f56465c750036751dfb748",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_220.part.js": "01ac79507bf3beee7a9193e63126786c",
"main.dart.js_316.part.js": "a4e8a7c83ef075614abbc0de2033642b",
"main.dart.js_318.part.js": "b60740245f481dae2b485b05fb9df773",
"main.dart.js_253.part.js": "e0605e8d66101f62e73d3fd9816a3a1b",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "089f43090bb7cc180eafcaae197b07b0",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "082b97450cd6644a481146f7e0d27b2f",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "3151788c8695a8f83263c0c5094f8895",
"main.dart.js_1.part.js": "24da0d3b0a1b7d533cff48b18ed7ed23",
"main.dart.js_298.part.js": "b08d8d9ea6cc4718f129a70476ee5863",
"main.dart.js_261.part.js": "1ed991ca48844d446434344c4711c77f",
"main.dart.js_320.part.js": "0ea4f89289d8bc7997e259d52b9da46d",
"main.dart.js_313.part.js": "c32974c67d5d0d3a71576c38d315ac6c",
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
"flutter_bootstrap.js": "d2cd50990b8fce23eaaf3a68c4eefebb",
"main.dart.js_242.part.js": "72b0c1681d741f80e572bc4f2dce891a",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "f7b86281c25b270b11327531b9586c5e",
"main.dart.js_321.part.js": "fa287d4787739494fea6093b3d1fbb3c",
"main.dart.js_286.part.js": "003e55edb03941cd15d39648f5d16846",
"main.dart.js_268.part.js": "455f5a49ca0055bef1c080874e556f36",
"main.dart.js_255.part.js": "8f99bb0286de3842db1530178d2ca665",
"main.dart.js_278.part.js": "2d1d91f8ec05c80785023a91df008347",
"main.dart.js_323.part.js": "4693dd142e44dda9a9f93cafe5be09b1",
"main.dart.js_299.part.js": "26f45d67d8b3cbf30b85c2583fe04a27",
"main.dart.js_16.part.js": "0a29f991517f52881e1c6a3e13f652ae",
"main.dart.js_236.part.js": "36a0bd46416dab501579ba7da033f7cf",
"main.dart.js_322.part.js": "4e82a7d2ba7e17b4685d1a0406d89804",
"main.dart.js_245.part.js": "feaf599861094c930e0d5c34a9a4b535",
"main.dart.js_285.part.js": "5f0fa9cc252d75bd3531c0348e452baf",
"main.dart.js_295.part.js": "d68886d9d8fb23f4d514eb0664708eaa",
"main.dart.js_312.part.js": "718f8c4908a76eb1d33b9ff6a9651305",
"main.dart.js_307.part.js": "0b382f2a73887755f0cfdc093f0af640",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "52a6b3047557dd242887492760104d96",
"/": "52a6b3047557dd242887492760104d96",
"main.dart.js_225.part.js": "dfb12c2ccc0938cf327bc2deda962e1e",
"main.dart.js_306.part.js": "49713fb0f3a3b350c6d8d87603a7f661",
"main.dart.js_317.part.js": "d9a927ac59d28e030df63815060aa1e2"};
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
