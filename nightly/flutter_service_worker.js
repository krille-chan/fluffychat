'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "c947b402bdec190e7191065813423496",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "b1a21f32d6db7a0076cadd6f2aac04c4",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "e3cb29418694b5fb8d17d46f54f09012",
"main.dart.js_317.part.js": "9fa0ec0f4ce250cb7f4abaf52355f8ed",
"main.dart.js_1.part.js": "a1f633c171854ac01063fd4a33270c54",
"main.dart.js_260.part.js": "3657f75dd034daf8befc8c8df6502c3f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "d0d2b6ea557526d909f4238533f27830",
"main.dart.js_318.part.js": "6bf2a1b6c0d491c57dd48cd8feb652a2",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "9b2a424c45dc5b6d218d8e8a88e52d45",
"main.dart.js_316.part.js": "041eda9c2fdcdd52a4bfb0c13408347b",
"index.html": "87922e2d1d1aee9adac93ff7c97c286e",
"/": "87922e2d1d1aee9adac93ff7c97c286e",
"main.dart.js_251.part.js": "984d094b8b1d9b16c995124063938237",
"main.dart.js_302.part.js": "e54bd3b9022556b87d0477522ce8f2f4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "557e764afb15a355a11a726bd4bde0b2",
"main.dart.js_242.part.js": "507601ff7b8e87977682a428cb47a6d9",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_294.part.js": "d0dab91834ac6a753d9bfb5080de3896",
"main.dart.js_322.part.js": "beb7cf3dc4b3dca2d696a4b770da8908",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "5a6a7b1701a4a9f65e95136dc466c422",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "162a1ba97f7f3e66cc7da78ea4396628",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "899d2adaddc6a159691c7a5cf31f2831",
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
"main.dart.js_334.part.js": "dd65a82ff1ff11eb5801d9880c599a9e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_341.part.js": "1e10ef7e75dea8ce9ac3bf110c852a3d",
"main.dart.js_320.part.js": "949951e49379f0e4d10eb61a4c4ee3e2",
"main.dart.js_16.part.js": "529efe7aa997ce305f2193c20c550b29",
"main.dart.js_296.part.js": "4454e51f5ce36101c6b45185c278ca7b",
"main.dart.js_278.part.js": "d05313f3e5980a3d90b55f8a0587645f",
"main.dart.js_239.part.js": "1c3dbac315708fb22fbd749c40f61cdb",
"main.dart.js_286.part.js": "14b6be4d441e912c5e80a21db180a695",
"main.dart.js_336.part.js": "430cdad00f02730c7e35506e5a0af4a7",
"main.dart.js_333.part.js": "d068a28e091d2aa15d2381e2a461e35a",
"main.dart.js_303.part.js": "0f69e8c93ff6e5c3434c56cafda9f05b",
"main.dart.js_331.part.js": "93b355d4bec57b2754d5e5f8260d14fb",
"main.dart.js_257.part.js": "f637b79af80176a40b069d6382ba8075",
"main.dart.js_290.part.js": "47d8f177112e44e90239d65b32f6dea4",
"main.dart.js_340.part.js": "f6b9366131bedcbb3ebeac101e1bd5e3",
"main.dart.js_269.part.js": "5fe7e4df3400ae3c51de95c5c1e7ae4d",
"main.dart.js_312.part.js": "eaf27197a21d604f8c92b29aee7e91f8",
"main.dart.js_325.part.js": "749dde508435566f9c089bd37ad885f4",
"main.dart.js_285.part.js": "894905386373fa989fca4bc2f5bf0d95",
"main.dart.js_270.part.js": "3f320f4b1da6241998759790e40b1a47",
"main.dart.js_268.part.js": "7749c7e65f557878532b31e51909dd58",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_342.part.js": "46c5209477ea24f68969b3a4493cb2a9",
"main.dart.js_319.part.js": "2460918bdccb2b99265afd8867b636ed",
"main.dart.js_323.part.js": "6066b19aacdcf96c2e5b6399c0bc6704",
"main.dart.js_335.part.js": "42b4d29b6ccbaa0e5424ffc3044732ed",
"main.dart.js_227.part.js": "b9980f93dec18b45ac17fe770c219c7a",
"main.dart.js_324.part.js": "a79e2d3d0058ea535200b5796b384633",
"main.dart.js_337.part.js": "ef6e99f9b5fad521671115b336a0ee27",
"main.dart.js_219.part.js": "2a9a1ee4c909a826d2b5d9b6687b8e49",
"flutter_bootstrap.js": "969057be86e3309e1db2e30e3e2dd628",
"main.dart.js_315.part.js": "bf70ece4ee6cc00ff38a95eaf53625a5",
"main.dart.js_276.part.js": "9b26f72a56e6a57683b4b459c192b023",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "5456b73153d5f9144c1a8b5191cf1527",
"main.dart.js_221.part.js": "3c29efda2ac211d11d849dc705694120",
"main.dart.js_329.part.js": "a9ba92c69c17e2175f3e378bc87ace64",
"main.dart.js": "dd0e9ee4c954b90a29fbe85d90b500f3",
"main.dart.js_272.part.js": "e32be181091d23c6282666d7308a6c72"};
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
