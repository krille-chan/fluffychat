'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "1ce657ad9490be6f6f8d201f126f8bd4",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_207.part.js": "3bb4c51a1656e88fdd54e85b0af4a08a",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "0ac76911a52fa9d7119989aab51e0ae3",
"main.dart.js_308.part.js": "c3d12b834275c1f9d32ffe8429614347",
"main.dart.js_317.part.js": "a803de1986faa176b2a0aaf27c9fa0c4",
"main.dart.js_1.part.js": "7b0bf1e329e6f3802c3234be3e0b7224",
"main.dart.js_260.part.js": "5f8bff373806cd0b7bd4fbc98752d7ca",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "29e7bf617a0960a04ed9da150a270fab",
"main.dart.js_311.part.js": "4d85fec08f1a4b5012499da7113888bd",
"main.dart.js_274.part.js": "97ef6c333dc5ec664f012f0a66052e13",
"main.dart.js_318.part.js": "db020ba1d128c1c56a044802646b7229",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_266.part.js": "27e60fa83c49d9de6ee3490d830cecda",
"index.html": "c23df268fe651cb43317e0025d3c6ffb",
"/": "c23df268fe651cb43317e0025d3c6ffb",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "189288dde0fe3841abd5311bf1324665",
"main.dart.js_305.part.js": "08e9d6c2ad4f064bc5ff3f4d6a9f45f4",
"main.dart.js_258.part.js": "c659634f29424fa02fbf47e548fdfb9b",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_283.part.js": "b22e785bf91c7ae17ab2e4f08a8176d2",
"main.dart.js_300.part.js": "2eacd0bf04f43b1cca24744985e0627b",
"main.dart.js_322.part.js": "9b31d023c3295321ce6535b6fda7c97d",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "1ca98189bb91a9beb057b40102666070",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "50c84084a133eae450fffb8d6444bc3d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "96b0bb5be20cd33cabf8b7e9d3cea283",
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
"assets/fonts/MaterialIcons-Regular.otf": "cf04b1acec037d1bfe7beae9ec5d43f3",
"assets/NOTICES": "4de3f617c2e220cbcf134b0c31162a7f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "5f1ec60c207297b0d91d82e03864d3d7",
"main.dart.js_16.part.js": "5e8856e548807b4f77401aae5abe1884",
"main.dart.js_209.part.js": "e3030bd6ee0ee2ec992775fb86e9a065",
"main.dart.js_278.part.js": "698fa1d00e0c32b8708572eeb4c05af5",
"main.dart.js_239.part.js": "4c5ec37a4c6f2971ba92b6da4452e450",
"main.dart.js_303.part.js": "c58c00cc857d017b0f31f73b15e75154",
"main.dart.js_257.part.js": "9c417aa0e329398a7cf5bbb8e9c0826d",
"main.dart.js_290.part.js": "ef1996c0ff4e1a3b083520841eed450a",
"main.dart.js_313.part.js": "6afafb8d42d49730664711d664df17f6",
"main.dart.js_312.part.js": "6df85401b937f089a21250ca7bd62043",
"main.dart.js_325.part.js": "20474f58c6ee7816811a29b21cd67e05",
"main.dart.js_298.part.js": "4c5a36c652ee63807598b080e685310e",
"main.dart.js_270.part.js": "8ff35bc67cff47bc518ae16f6f17529b",
"main.dart.js_321.part.js": "0e574591cd655f7ca504e3792fd6a0f6",
"main.dart.js_273.part.js": "62ff9a4e01e5b3992aab3545999cd11f",
"main.dart.js_268.part.js": "82552b4d3f3ad1cb7bb775ffbddb1cb1",
"main.dart.js_248.part.js": "83626cd26460be87873535d8283ff680",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_307.part.js": "a0061e075cdf4aed514aa70e027409ba",
"main.dart.js_279.part.js": "ff1805d7c8f98ecc009c08557f0b20c9",
"main.dart.js_319.part.js": "b04e1f5f33487e4ebfb4e70099a542fb",
"main.dart.js_215.part.js": "5b95289821661491ba0b1e3fae2bea31",
"main.dart.js_323.part.js": "9771b6431d22cbf31f36839941d2f1da",
"main.dart.js_227.part.js": "10e2b509d6546f182c44c9334bdaa563",
"main.dart.js_230.part.js": "d54f187caa5546f6007e7a8f6ae35224",
"main.dart.js_324.part.js": "d1affdc1d0cbbc93f7b28a7dbe4bda60",
"main.dart.js_328.part.js": "927624f41fe2acbb487fec3b82e2d7a9",
"flutter_bootstrap.js": "dbec70088f48788c8f3deef9ebb98266",
"main.dart.js_304.part.js": "d21ce49c253c80ec178fa46fa8cf97bf",
"main.dart.js_264.part.js": "f2bc4a6cabc00d171337b796176bba3c",
"main.dart.js_306.part.js": "6cc37bcee7ebc26b06d2ea18761890d5",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "73efd2895d0757555f855b254b78d40e",
"main.dart.js_310.part.js": "26159e10a943db5d9c11c6dad116524c",
"main.dart.js_256.part.js": "a21904fb462cb6fa43e0bdd940ba1c5c",
"main.dart.js_329.part.js": "35c7f3e353cbe54b67e5f2ebd413f4af",
"main.dart.js": "1beeb3618fdb8c0c17981da42c7979fb"};
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
