'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "0d1e6e8408c82b8eef4a78fda1a3333b",
"main.dart.js_271.part.js": "7ec58c735b05df8e896d6973e6c7fb43",
"main.dart.js_297.part.js": "4b717637183a596a621f025778dfdd29",
"main.dart.js_1.part.js": "d5b52e17d5766837df3c9a53b4ae318a",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "f7fe84331225bd8602aa660c3a77e93b",
"main.dart.js_280.part.js": "cad925b1d7b8113b191d2ec7b540ecdd",
"main.dart.js_318.part.js": "545675550adfcb4334303e0c29f1ffd7",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "9222af5249b36b648a4455f8ac1451b7",
"main.dart.js_316.part.js": "ac72db7a994ad91ebf8bb3a38ab86f52",
"index.html": "2b21d815ea01157194ca1a92cf92aac6",
"/": "2b21d815ea01157194ca1a92cf92aac6",
"main.dart.js_302.part.js": "e5355636edf5a763de1d709c4baac734",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "75f96265eaa20d6eaf03516a0f208737",
"main.dart.js_305.part.js": "49c93e888ce5147737f45ae865ea2585",
"main.dart.js_242.part.js": "6f696232c3404652ef7b02031c1201b8",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_265.part.js": "e4ba995e610553c523d4006aa7f3c9f1",
"main.dart.js_300.part.js": "b25cd58b773ca1fc3e25b6dac97bb104",
"main.dart.js_261.part.js": "0a6cf78e4a3d00abaf54a661b6b0c2fc",
"main.dart.js_322.part.js": "6fecadf5b7c5ad23865454fce39f6706",
"main.dart.js_263.part.js": "7a2cea4d79a2b74fb5e742f4aa476d90",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "d3a37ebfe86b932ae3815d9728911021",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "60b8745852976ef8241f19090ede5cb1",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "a4caaf10a0e78df841c04a880bc7d417",
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
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/NOTICES": "a6560be9dd1dda51cb475d869d4827c4",
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
"main.dart.js_320.part.js": "b7dd8cb970ac184d94f0a344c65e4832",
"main.dart.js_254.part.js": "2a9166f8fd48a94696a2910361f85f94",
"main.dart.js_303.part.js": "aec06eb76dd3930897802c112093874d",
"main.dart.js_287.part.js": "1204252470855b912f9e13a96ae3db58",
"main.dart.js_257.part.js": "f58d294e864e8d572cf37a80ea5673d0",
"main.dart.js_290.part.js": "9c2a694f3f3782f010a1ac26d5c3374b",
"main.dart.js_212.part.js": "b943d07c96f2778bb7f1a2bc51b846aa",
"main.dart.js_267.part.js": "d495b5ac2c404b144e0968f72390bc5d",
"main.dart.js_309.part.js": "f2695395eb25cca6b91edea2fb1088f3",
"main.dart.js_325.part.js": "0751cc5633ae0be57e618631a95ec7f8",
"main.dart.js_270.part.js": "eb6a41be332f8202b691a6ac534710eb",
"main.dart.js_321.part.js": "b3909ec54276a3f1db5acf3d00e5d087",
"main.dart.js_255.part.js": "730748305a7d8b1fb0d24ecc2a0b4851",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "556d7eddbbcb65d1777f4d1fcf747879",
"main.dart.js_281.part.js": "b399aa7e9bfa99e691175618b2f96a2d",
"main.dart.js_288.part.js": "07356c241a48561970aa6cc235891c00",
"main.dart.js_314.part.js": "8d9814b2927e4b9ebb32deed315f3d97",
"main.dart.js_206.part.js": "397a899db4cd8235dbb4179162492312",
"main.dart.js_307.part.js": "92859c3824d9a12cf9ee035ad8354464",
"main.dart.js_279.part.js": "fcece8b75d9e39ba01edc6943f0507ea",
"main.dart.js_319.part.js": "36e92542963367ddd2725f2b40e82f29",
"main.dart.js_253.part.js": "9dcd96bfbc8263ecb538a7b1985fe10d",
"main.dart.js_227.part.js": "ecdac3f0d2a3c578425d766760aeba26",
"main.dart.js_324.part.js": "9143e973ac8b5bd619aed8cd89bb9cbb",
"flutter_bootstrap.js": "7fd4a05a72740eb43f3a79963ce95d87",
"main.dart.js_315.part.js": "8c49d7b0b27d3409af339393a1ecc3ef",
"main.dart.js_304.part.js": "01fbb1ddc551bd35fb33e369754fdc29",
"main.dart.js_276.part.js": "9b13b6428afa5163c2963441b0d2270b",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "e106411a65a92718c5fc3cb1be5c2686",
"main.dart.js_326.part.js": "b8e6fb1f1237729dabfbca3bddecc46f",
"main.dart.js": "2eada2bcc1be0bad31338ab211497454",
"main.dart.js_224.part.js": "f2024f8c8c44b0712f2ed614e501092e",
"main.dart.js_204.part.js": "617a8194abaa21210853904a41652611",
"main.dart.js_17.part.js": "f847021c3a878f88c7c590609080c9a8",
"main.dart.js_236.part.js": "75219a338ea998e7aa63ea4f07126e37"};
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
