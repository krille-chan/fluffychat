'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_297.part.js": "f8f64ad65ef677082f12629345f12991",
"main.dart.js_330.part.js": "ea83948c8c9596422922a56555344ca1",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_337.part.js": "1a4128ca59421ffef016ef21c6ece1e1",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_289.part.js": "c005f983540f2137457ca2cc5a59e5db",
"main.dart.js_323.part.js": "612810d39d248ce949cf6fd466a14ee5",
"main.dart.js_271.part.js": "1f540434e9af3ac809c52b7f25117d17",
"main.dart.js_260.part.js": "2c879cccaf547716fb75af9014e87114",
"main.dart.js_306.part.js": "b68c86284ec5bfc875df00cd61135e5d",
"main.dart.js_283.part.js": "73e4c775d50d618b6aa8e76584feb236",
"main.dart.js_331.part.js": "3164ab92b798efd9252eb6eb3cf8e894",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_1.part.js": "5513788676086eb7fab188a2e9a5e277",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_310.part.js": "75eab3a7263e7248a8e728a7ef7982db",
"main.dart.js_252.part.js": "3d4022b238e844323e00b6abbd7957b6",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "5afbff06be63fd0d3cf3fb2b7d6fe49c",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e7654fc08c8aa19c26563b64b016e131",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/particles_network/shaders/particles.frag": "1618a243a3c1ee05d0d69d7f0d8ce578",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/AssetManifest.bin.json": "045a6fd0064669d9c6e2d4eb44bc7068",
"assets/fonts/MaterialIcons-Regular.otf": "59e871f2bf0a7a405652ee3737782a10",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "db9a24a16187744848654f7d6b506c01",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"main.dart.js_264.part.js": "1128c6b3e0a43c18015dd033ce303fd9",
"index.html": "42a34b8965fe74d9e9505ccf602c7ca5",
"/": "42a34b8965fe74d9e9505ccf602c7ca5",
"main.dart.js_316.part.js": "4d643a85efb1ea06a844d7c1d5ec1f54",
"main.dart.js_218.part.js": "30c6dbb00ba2b9fd722e570b364640c7",
"main.dart.js_233.part.js": "9f348e0a97a63702caed38ffee1cb5bc",
"main.dart.js_332.part.js": "338a7c8dd871eb660a3e4be693e4b127",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_336.part.js": "f9c1e8f2088851b60f0c2a0f765d0075",
"main.dart.js_299.part.js": "22e8a5759f092595ed7eacfae4243ed1",
"main.dart.js_328.part.js": "702289c789aa10fe12397d3fc8002963",
"main.dart.js_210.part.js": "b55acebb0bb3399bbae678df34c33e90",
"main.dart.js_329.part.js": "2998b5c7fd5d79f7768b89c6e049ab65",
"flutter_bootstrap.js": "8c43c41b5392ca4a9c4261bd32f83648",
"main.dart.js": "30c4757a44fa995416901a84aad26510",
"main.dart.js_312.part.js": "46a6fb01445d2cff0bb0c626573f1406",
"main.dart.js_2.part.js": "fd3741be9c6bba0541b519ab3e8890a2",
"main.dart.js_287.part.js": "c18576007a33fdf7f1e63be9d06b997d",
"main.dart.js_269.part.js": "95314028f5c9cbef5bee1e00e7a48f96",
"main.dart.js_318.part.js": "931f0fa671ae1eac9be4d17297447162",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_313.part.js": "d7a8f329b1486a158dd9608c96b15fe9",
"main.dart.js_249.part.js": "798382632d4a1e7e9621fd658fcc144f",
"main.dart.js_212.part.js": "5285deecf9426eb0c43249d714a7623f",
"main.dart.js_317.part.js": "9109c8d3d2f99eeff5f5a6a60f6d33fc",
"main.dart.js_325.part.js": "77fec7177dde46bd624194a5bc0dab59",
"main.dart.js_311.part.js": "2c57c2679da80bea207fcea1a6d6123f",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_288.part.js": "ac096b2f1460e6b20ed6559996e4558c",
"main.dart.js_335.part.js": "a44f5d303a2e55f4bce3e4a005eb7afe",
"main.dart.js_324.part.js": "fa5045e752f7dfc9a56b142c7d2a6593",
"main.dart.js_284.part.js": "5b24d4a99348f5ace6a3fb44589c4481",
"main.dart.js_275.part.js": "53f0d8a68365e8be6a8d8ec42f75b99e",
"main.dart.js_273.part.js": "9b86273d638c380c0dcd3b504fff83f4",
"main.dart.js_326.part.js": "885f40d70e48fdfdeed03008a773baf7",
"main.dart.js_309.part.js": "8fb2ef346a8308abda46c206ee9ff6d4",
"main.dart.js_17.part.js": "879eeff1c31278ccd2ac048e47842a6b",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"main.dart.js_278.part.js": "bbd1f07407c066ee3b46d06aaf1e97dd",
"main.dart.js_296.part.js": "8d2e23859f4160dc734332d04ce0dfdc",
"main.dart.js_242.part.js": "c451e4d9b3334a89599d5859eb64cd0c",
"main.dart.js_319.part.js": "c7369fd8571b488653425490f31ddec8",
"main.dart.js_261.part.js": "ef4387b4ccefef36412990b703325928",
"main.dart.js_279.part.js": "5fa7b0dfc03fe01e3fd17f3c07870bd6",
"main.dart.js_225.part.js": "19a434d8efede2b204abfb7bea8dfc37",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_334.part.js": "81e7c9f22a94872b09fb2c8656f9eaa4",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_304.part.js": "d345cc82d252a71ffd506268fa4b93eb",
"main.dart.js_262.part.js": "706b72101e5cbb81a2706e6b4a835ff5",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_314.part.js": "beebe0faa3bee1d980639f52b9cbfeda"};
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
