'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "100883a7baaae46b81a94a496e5684e6",
"main.dart.js_317.part.js": "de97e264f9db8885cf910ce3ce8eaf24",
"main.dart.js_1.part.js": "24ce42f39daf3bfc89f81d0f90468815",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "aa824cb3f78a96f0dbed749660365826",
"main.dart.js_274.part.js": "fc75e8eb621368e8d5e3130266c6e353",
"main.dart.js_318.part.js": "dd78d10696298bc51cc2f3a21550bb8a",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "d4d814224f9d7b2b83d6eca4947cbe7c",
"main.dart.js_316.part.js": "a4e3e6982f90441fa4eeebd0146b99b4",
"index.html": "bc5fb38bb2f60127ce20e74cf238ec33",
"/": "bc5fb38bb2f60127ce20e74cf238ec33",
"main.dart.js_302.part.js": "cc8c1caab1047c1acb9b4d3d9035e76c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "9887b8bb942c5ea30133762c222d4f05",
"main.dart.js_242.part.js": "03aab119a844fe4be640978d6b0b60d7",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_265.part.js": "055dccdc62a65e2c070476eb0672d06a",
"main.dart.js_300.part.js": "46f0b7666dca741f018aeda337cf9dd7",
"main.dart.js_261.part.js": "885911b967fcf4f54f3aa40dba165851",
"main.dart.js_299.part.js": "b0ef698c798fcddddf9da131a0e2dce7",
"main.dart.js_322.part.js": "94cd56b787441a00e5528f43afe35dd5",
"main.dart.js_263.part.js": "6b548c748830b0d93ca5dff6fd52e58e",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "418b83c73787fe1bb1fb4113fb7760e6",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8aea3a3dd281c9228de7e41363c0d264",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3aa9fb82660524ee15b6482980e916e0",
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
"assets/fonts/MaterialIcons-Regular.otf": "ba6850df3f567a02f3e4138adbb19518",
"assets/NOTICES": "6cfe799430e6c840c30290f71ccbac3b",
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
"main.dart.js_320.part.js": "507cf13f07557e6a9fe29fa7f07611a9",
"main.dart.js_254.part.js": "a38c6eca4c0cf88d6e593019c102612b",
"main.dart.js_16.part.js": "57803e45469bf56c8c183076c863bec3",
"main.dart.js_278.part.js": "9a249257f2b820506cbb9dc684c88179",
"main.dart.js_286.part.js": "ee5e7a7ea97442bc3bbbf00b0343ce89",
"main.dart.js_303.part.js": "89530cf0f22b42fff9b20ac0a4e5ae9e",
"main.dart.js_257.part.js": "aaceeef799f9d784d291097f1c3526b9",
"main.dart.js_212.part.js": "9b2361dab30fb0b03014482a44d41ea6",
"main.dart.js_269.part.js": "4aac2e0f99ae79d6dd866c5c532b61ab",
"main.dart.js_267.part.js": "306757632e6d70e001eee9dad598a554",
"main.dart.js_313.part.js": "61b22e36540445447df0e7a62db2aad8",
"main.dart.js_312.part.js": "25d28e0925a8eca2b5b0caaf647e7bb2",
"main.dart.js_298.part.js": "ebb84a22a9b68e3507ff58c9b44aa060",
"main.dart.js_285.part.js": "6d3e087244134e999a2c5baf196b9f5c",
"main.dart.js_321.part.js": "7f333f1134cae05a73529453e9407193",
"main.dart.js_273.part.js": "59ea027bc1de072f005854fae7b0a5ef",
"main.dart.js_255.part.js": "4615b627ee35eab1ed00b2ca178c6ab3",
"main.dart.js_268.part.js": "e53f72284974d2f23d357e5f55da0248",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "3d98317624d37057bbf1bd2c98f9371c",
"main.dart.js_314.part.js": "7b739b13a26bea083dbf9ab0cac149cf",
"main.dart.js_206.part.js": "79a0cdac680effb7a2fb8e58084d4d64",
"main.dart.js_307.part.js": "7b3300863f4c653a7d8af9f604df40b9",
"main.dart.js_279.part.js": "8ff84ffce18b2ad269e927c34c1e0ed1",
"main.dart.js_319.part.js": "6d5b3d7305b77346fc7a652d8fdf311e",
"main.dart.js_253.part.js": "94f454f3af1109aa92561e8598e87c1f",
"main.dart.js_323.part.js": "973e660356b6522b06c53a34e8e138a0",
"main.dart.js_227.part.js": "e5db0c268da8ae92a3be8e79af8113d3",
"flutter_bootstrap.js": "115a79ae001b9aee3e1641f69ff4dac2",
"main.dart.js_306.part.js": "29fefa9995b8f9a05f56009de8adbc23",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_293.part.js": "c230410c04ca0c502ba635a439fdfc73",
"main.dart.js": "881dc470f826640b2af7e19218c02284",
"main.dart.js_224.part.js": "68e53e575d8a52ffb74c3e3cfb6f2e30",
"main.dart.js_204.part.js": "3f6f44c47dbaac50e4cb616ca797216d",
"main.dart.js_236.part.js": "723fce923888886cde0256939ca58519",
"main.dart.js_277.part.js": "61151d1e9c927ad77710c1e1fcbd79f6"};
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
