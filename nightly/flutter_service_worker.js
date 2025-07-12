'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_223.part.js": "5203a95471aab8741974dcc31d2b57d7",
"main.dart.js_256.part.js": "f094d67975c3fd784532bd20aafb8dc8",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "d2129ca900fd72b29a2b92f4cfc399fc",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "931b28f30f021d26ce6a102feb9ca4ce",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "ffdca38215708d4e57fe39ae12d3be4d",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_196.part.js": "a21a3819cdfd7c837e575157cb3a0729",
"main.dart.js_295.part.js": "8b7c51f0d07699d91e6419630a4ba4dd",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_244.part.js": "c65b3971b832e07bdfbf2cc3d34e615a",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "70efe32e9dc21a198eed658a2a43395e",
"main.dart.js_234.part.js": "89496b178afdf47d36ccdfe9d9b6fdb5",
"main.dart.js_296.part.js": "f65f791daa0c64ff321dc0325f6cd6ab",
"main.dart.js_298.part.js": "fdbd5b99a26915de1b9589402d4a7e33",
"main.dart.js_246.part.js": "c76592dd23f01d0f646d60d15f700aa7",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "219185ac1f64acf5796f1baa5ee67bc8",
"main.dart.js_277.part.js": "8261a1c1d8ba2c86f770716ce20dfe8c",
"main.dart.js_279.part.js": "57d27d6237ad3a52ed9b2a5aa7132aa0",
"main.dart.js_217.part.js": "9aa2d5ac545fd6410a60d271c7c1fda6",
"main.dart.js_235.part.js": "fe49ee0e5ea62fab878d4f1a371bbd8e",
"flutter_bootstrap.js": "352a44619f9306237cc39cfe14cd8cd8",
"main.dart.js_264.part.js": "043f3bbab0f80bb6b59b83d64de52329",
"main.dart.js_194.part.js": "96c1ec3d796b10e4b044ba70fc5ecbad",
"main.dart.js_267.part.js": "a1ac7eb3d6e93caaf2768c52a0e46f0d",
"main.dart.js_291.part.js": "a2a95e6b5b0a9339df02fd67e85d65b2",
"main.dart.js_236.part.js": "93c69089f02a3c935c9834dbd30d5401",
"main.dart.js_208.part.js": "fd33d5bc3d2eb9e238806b94703f05a6",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_290.part.js": "19ceeaff1432c03efd7e9079ffd4cd8a",
"main.dart.js_294.part.js": "bac200271aa8fa99b35bc321b1250eaf",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_209.part.js": "4e968a6892aaab76a79051e3dd9f79d5",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "6b9c2680eda07ed6b79581e3ed315957",
"/": "6b9c2680eda07ed6b79581e3ed315957",
"main.dart.js_299.part.js": "96b289295308c54c1842c68813f00490",
"main.dart.js_281.part.js": "a1e2789d856d035224d8e99b1e2734df",
"main.dart.js_242.part.js": "78dc4683277cb099b934b56b64eb5c11",
"main.dart.js_301.part.js": "6f15fe08573b3929cc2e109cb17bf364",
"main.dart.js_297.part.js": "7347a87d1871ed79c18e1caa2e4abaa6",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_286.part.js": "a1985dd0f80f9f2340c49b3ce5d1806a",
"main.dart.js_292.part.js": "42a43aaf8ce7d88595da49a040c42db0",
"main.dart.js_248.part.js": "ca742f242e86f2a9ca4c67f6badfa0e2",
"main.dart.js_249.part.js": "bd6b111d53bdd76478a40751e7e566dc",
"main.dart.js_252.part.js": "425ed1b68721bca687cf622fbc226889",
"main.dart.js_272.part.js": "64bc56df8a03ef34d02f331d2c4606e5",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "3c0db48cad2db1583b55da9d01f87429",
"main.dart.js_226.part.js": "2f9197019ef50f5e1793f9bd550cd4e6",
"main.dart.js_284.part.js": "84ea1adb2bf12e047fd3df5838840883",
"main.dart.js_247.part.js": "00b62eeee8de3895caa0cf05b5f7c90f",
"main.dart.js_1.part.js": "cd31db787aeeab2f4e9181ffc2c77cbc",
"main.dart.js_258.part.js": "23f5b9ea8478e28a2790a4a256cfbbe1",
"main.dart.js_285.part.js": "62d46451a188c5a79f80dd6a14a25da5",
"main.dart.js_265.part.js": "44b6c1abf3b4100a40eb25528f3793bc",
"main.dart.js_274.part.js": "b0397806196e12d3d62b0e5e83fa3837",
"main.dart.js_283.part.js": "3b499d0c476d423d94569379782b0b51",
"main.dart.js_238.part.js": "62ea49f333952708392e9e5a4c3ab36d",
"main.dart.js_276.part.js": "9a0ffca089d6ac3c46b0d76014ed47e9",
"main.dart.js_278.part.js": "9624e9753a3e54beb87b83e23bdf51b4",
"main.dart.js": "7fcb79767f8d26777e232e0da274213c",
"main.dart.js_280.part.js": "117d7e20a80855fd357c2b7c25f38acc",
"main.dart.js_207.part.js": "e65a0ff52cbb9fa6a846bcedb502687c",
"main.dart.js_257.part.js": "d21bb613b0543d3647b9fc6e8c27a156"};
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
