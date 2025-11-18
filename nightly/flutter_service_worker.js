'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "de00dbcbed508dd6fbcc440d49eeaf2f",
"main.dart.js_308.part.js": "3ecf26a3b4b80fedd4a265debec641fb",
"main.dart.js_271.part.js": "5a56c77e6c823d24c85ec947bd88e45a",
"main.dart.js_259.part.js": "2c7c37ab548db4c65808b5cb0e8a455f",
"main.dart.js_1.part.js": "7b0bf1e329e6f3802c3234be3e0b7224",
"main.dart.js_260.part.js": "5dc3b4617e756d83552d4bbc77780cad",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "fa3d086cf6f9d4f4805012b1b3d2fc15",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_316.part.js": "e697c04d1551efb2ccb229dc41737b2e",
"index.html": "438a2af6480aaf81e0a13fc5a4d94d0f",
"/": "438a2af6480aaf81e0a13fc5a4d94d0f",
"main.dart.js_251.part.js": "d66555775e41153caf00f783cf89505e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "c92cf63b76094d62bbfcac5ec17280be",
"main.dart.js_242.part.js": "4b79ea14076e68db9987d8366d17db4a",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_294.part.js": "87ce3e9304f3d3c6a7e093a50e3f527d",
"main.dart.js_261.part.js": "9b733025fa821e7476c964b2b5fc55aa",
"main.dart.js_322.part.js": "34157f0e2bf6820b2342e83f5cec4e1f",
"main.dart.js_263.part.js": "339fa1d751033145a4fedd8688a8b3f3",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "d2139ccb3e2bee99005c9755cfc78edd",
"main.dart.js_301.part.js": "c4bb9823d2b88e3cec6dabb70761874e",
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
"main.dart.js_210.part.js": "09d7cf08aada20ea7117c4e25ae0e4fc",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "eca8effb323d8c612f339f95657a257e",
"main.dart.js_16.part.js": "5e8856e548807b4f77401aae5abe1884",
"main.dart.js_296.part.js": "26726974f8c934bd3844f066d53ae5fe",
"main.dart.js_286.part.js": "f69e81ba19291ce152b91fa5263f510c",
"main.dart.js_333.part.js": "0138d8279c2c31f1d03441cb854b24e5",
"main.dart.js_303.part.js": "6b522698b7bf2b27a49f26e2ebce808c",
"main.dart.js_287.part.js": "976e939321ee7d9cde872b55eb127054",
"main.dart.js_331.part.js": "52e8aaa9d109efac5ac1d3619fca96bd",
"main.dart.js_212.part.js": "639b59f102f50a19bc06af60d9a71e7e",
"main.dart.js_269.part.js": "1e797e66d52fbeb734c1aa831514d2b1",
"main.dart.js_267.part.js": "8c0429ef96b3828da44fe151fcb33a36",
"main.dart.js_313.part.js": "7cdaa89c5a7a8ab9afac36aeba76cafc",
"main.dart.js_309.part.js": "8577b0a44915064748ec459311857141",
"main.dart.js_325.part.js": "2f96950f8b49c8c7849bda5639b79565",
"main.dart.js_285.part.js": "5d187ad93e6a6f5b45a281cc76647490",
"main.dart.js_321.part.js": "d126ac0d83239bcb72349ad6fce76e5a",
"main.dart.js_273.part.js": "1857c28c398239b849fd3df8e31cf13d",
"main.dart.js_248.part.js": "9b99abeac5c8548315ffc8b1af460ac4",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "da312c7f9b69742b219db63f0ca2155f",
"main.dart.js_332.part.js": "b80d984ef5ed0a1cef4bfb049d4fb29f",
"main.dart.js_314.part.js": "158da7f9d97cb3fe17184b1ec72e4109",
"main.dart.js_307.part.js": "4972545338076de5ae856ff16a21c2c1",
"main.dart.js_218.part.js": "8f27100f8d9527e4fb525e0af25ad477",
"main.dart.js_230.part.js": "d2c25cfcc45d5ea04b8ada3ed1e4db4e",
"main.dart.js_324.part.js": "12767afd8bd412d83d9fcfa18a865725",
"main.dart.js_328.part.js": "96c9b78c72ae4a00285d87af91866908",
"flutter_bootstrap.js": "aaf280ed0e1374392570514736c86285",
"main.dart.js_315.part.js": "b13fddd61794cc662adc87e8dc1ed33f",
"main.dart.js_306.part.js": "4ae8b1c9534b8e8e821a60f81f3d5edc",
"main.dart.js_276.part.js": "de2899651ea9bb2ff5a1c081a730b0fb",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "639bc9c98002d2a02d0546bcd0517d6b",
"main.dart.js_310.part.js": "43b04d633e84c8f740c09eb6ad9c433f",
"main.dart.js_233.part.js": "ed6aa7217784a9cc69ab1632344db485",
"main.dart.js_326.part.js": "6dfad070037401e917b442675749faa8",
"main.dart.js": "9b01d1f31dabbd14df11e91096814892",
"main.dart.js_277.part.js": "63fb742ebfba2841254fa925664b75af"};
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
