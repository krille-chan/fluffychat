'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "189c3ad4cbad08d5c5424968957c284e",
"main.dart.js_271.part.js": "431aab852cf6c22462c7d027caf48245",
"main.dart.js_317.part.js": "07f873f6cf653874b3024a293b92d96e",
"main.dart.js_1.part.js": "6aba78771278b4b4fd079945e19e820b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "3505840dd688c4143d6a7ca5ef055d1f",
"main.dart.js_311.part.js": "d0171f0c08106b032f71b099e3d905f5",
"main.dart.js_220.part.js": "3ffbf2abf22ef515f0cd5b8ad6dc8e56",
"main.dart.js_318.part.js": "dc1c3d32910c146bbf923f59b53738d8",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "ab21a8d5c0c63ab552bbb3b4b07e35fb",
"main.dart.js_295.part.js": "eb233add715d99935e46f50002759dbe",
"main.dart.js_316.part.js": "3c9fee084613b400d55e672a1f1b57db",
"index.html": "d360132d8c8ed0b60ae588a37ef5eee3",
"/": "d360132d8c8ed0b60ae588a37ef5eee3",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "d730be67f1c65794973447d058a8f34f",
"main.dart.js_305.part.js": "865948c519bf01052a29807559bb2de0",
"main.dart.js_244.part.js": "89086e92d7178d0f4a39b15af727c5ce",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_283.part.js": "89342643c3b3342bcdfe355bca970a1a",
"main.dart.js_265.part.js": "e75db02dc86b24a56de6fd89243cf6bc",
"main.dart.js_261.part.js": "7004f9d0245c3f3ab8bdcc2336f9f32a",
"main.dart.js_262.part.js": "48405662c50b679f92f35d26c9d97669",
"main.dart.js_322.part.js": "cc6e5894d142c226e863a336d6f4a1d5",
"main.dart.js_263.part.js": "2d885f223fef1148830a73df8fcee753",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "9dcad7e150eb6c5e5bb79ebe152e13c2",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "d211d691da00b218d7ac1c3f049e7974",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "8fcb0dd7776be5c6530c8715a08f3f14",
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
"assets/NOTICES": "e3942d4aef2a10490fb32abd34246436",
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
"main.dart.js_334.part.js": "2dacd397afa8bcd29012eb60490a8274",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "3b7eb36f88a8581a751a99ebe2041978",
"main.dart.js_296.part.js": "e65870c3d11eeec9de290af2a88756b5",
"main.dart.js_278.part.js": "3602735b65b7b21031abae42b8050237",
"main.dart.js_232.part.js": "da09c170f520d53b7497aba8188df948",
"main.dart.js_333.part.js": "3278370c6687173a18319f311495b18c",
"main.dart.js_303.part.js": "f8d726e2b3c1e09ede63007a243bb453",
"main.dart.js_287.part.js": "d4140361e4195a369800ac6234369f5e",
"main.dart.js_212.part.js": "e81036e7defa8662c9270ad87e38e470",
"main.dart.js_269.part.js": "098c9dfde3b988dfbe2c1577f98d4a11",
"main.dart.js_313.part.js": "63eea1c45e5237b1fc93c0a7ce9dafbf",
"main.dart.js_309.part.js": "c90ddf0c7a56cf687af2653b3f51a735",
"main.dart.js_312.part.js": "acda2eb0b8ecf15cd54dc3a0faa864c1",
"main.dart.js_298.part.js": "6ee1901ffcfad52a37201e585fab9fba",
"main.dart.js_273.part.js": "1d3751d0bad06b9e65480a089f751883",
"main.dart.js_235.part.js": "97f5caeb0021d6fe268a3a13cf882cd1",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "b901b94f5bbba9e5d86642ea79616bdc",
"main.dart.js_332.part.js": "f6df217cb3ed53934f58d6035546d188",
"main.dart.js_288.part.js": "67af3e1f32df481c7fb1dd587e0ef888",
"main.dart.js_279.part.js": "967a087773a909e261ae3d0a18385a52",
"main.dart.js_253.part.js": "ca4d10a17d1736d9b03d2bfa5e605b5c",
"main.dart.js_323.part.js": "43b45d9961af4159967b85d7f6eb7472",
"main.dart.js_335.part.js": "b499ddba3328b1649bf1b49a7c95d844",
"main.dart.js_324.part.js": "9cc87639dc35e5886abfb00daeabd1e3",
"main.dart.js_328.part.js": "633188abadc648767c5e2dd92b9023b2",
"main.dart.js_289.part.js": "4f6be8c479fa8ee1fbbd2d46a37167d8",
"flutter_bootstrap.js": "12e1bda79953721e54dbf23f1e08c03a",
"main.dart.js_315.part.js": "27b8b9591be2253478dcc2a58a6be9bc",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "17a2ea36b424d1c2dae92f5d04fdea5c",
"main.dart.js_326.part.js": "cfcf8844a47a007c2e7d89a69931308c",
"main.dart.js_329.part.js": "0b13c27a93c49b7b4b45a0eaa1289e87",
"main.dart.js": "6ea4344ce5eefe600c2d55e9a0d287f2",
"main.dart.js_17.part.js": "45d1c1bb690ef3c684367a28d6b0af34"};
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
