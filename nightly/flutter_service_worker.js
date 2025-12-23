'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "3c5750b8c5c5fe7c71ff45e4fd85bdc3",
"main.dart.js_271.part.js": "707899ae7e5488fa56ad9e26ae0770d3",
"main.dart.js_317.part.js": "afcb36aa5d6a31eccaa650f22801398e",
"main.dart.js_1.part.js": "9ee52a8b1c6927937e35b799d186c50f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "2f1078bc013e0bc157efb7e6122dccae",
"main.dart.js_311.part.js": "7c25ddb3c082ad74a8f7548cfe400bdd",
"main.dart.js_220.part.js": "1b8a151a7c45353a9892003e1f0b89dc",
"main.dart.js_318.part.js": "8e2f72d6eb3f3b7058ce649eac607c02",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "e7d41b8b359229c7e4e81a43a661f3de",
"main.dart.js_295.part.js": "f71ee12f2210e7547a96926e3e1c5254",
"main.dart.js_316.part.js": "4e89b029bafd687826dd044a872c3484",
"index.html": "ec98f28e92530af3c354162175d4bd58",
"/": "ec98f28e92530af3c354162175d4bd58",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "3ef6abd154bc6b4d33c7d404d950ba6e",
"main.dart.js_305.part.js": "b4d266d62a8b1b63d2971b3d3c0b1f4c",
"main.dart.js_244.part.js": "b838c006821c91427072c182b0bd9149",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "2ab2250c7b3db85672584870184a79f1",
"main.dart.js_265.part.js": "81e6eb0331c41d1be0b2901e1f4e16be",
"main.dart.js_261.part.js": "270d62c82d4cb9457101f47442f70ff5",
"main.dart.js_262.part.js": "edf4e41c2ea640ee6639e7f82e92a9fb",
"main.dart.js_322.part.js": "e8f46df5442323d9d71f54c7b328f715",
"main.dart.js_263.part.js": "fd427da3d6cbbd0fc269932763cbb584",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "667307d37d617145225a13378841d31b",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c29b31e7fde2b5f9d04435b476feac8a",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "05ed5e61ab4c762668b323df490c0d9e",
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
"main.dart.js_334.part.js": "43f30800d31d3add8408e603ee5a529d",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "cb5b1e961f47e7b3db1ad9211c85a28d",
"main.dart.js_296.part.js": "e9258887e25cd5b1c46b1278b2920961",
"main.dart.js_278.part.js": "ef4140e681259bb949ebd4c538f93868",
"main.dart.js_232.part.js": "0d12a66c5070f350f25851f1d6a2214a",
"main.dart.js_333.part.js": "8ded1553e183843cc915d607ebf86268",
"main.dart.js_303.part.js": "41c3ce53cc1b4245810430a16e828e3e",
"main.dart.js_287.part.js": "1ff60c80bbd86c38d8480047e6ab9752",
"main.dart.js_212.part.js": "17e8997af601c8f9642f205e66fa5bc9",
"main.dart.js_269.part.js": "640f235077883b3cb66e21ae4306de1f",
"main.dart.js_313.part.js": "56789960149b66b2a4afe2319d89b20a",
"main.dart.js_309.part.js": "c077ab99c4129620098cbe09247bb822",
"main.dart.js_312.part.js": "169396e3980bdd5d0229e93373b7b2dc",
"main.dart.js_298.part.js": "4974da200ccf9d44d13c9741a98a02d5",
"main.dart.js_273.part.js": "94dae7d3e766fa7eccab15899f8d52e2",
"main.dart.js_235.part.js": "4b5f9f4dea54d4ce3d74ad6e0ba72f2c",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "817675141a42e11c3f7405d447789de2",
"main.dart.js_332.part.js": "7cb31925a3c9298184e59fcb79c915c5",
"main.dart.js_288.part.js": "12e826447fe45345e9fb65ad387d35e8",
"main.dart.js_279.part.js": "b9d92a00905705a54c43c009b65a6252",
"main.dart.js_253.part.js": "7a1cdd0b1449628a66626435677672c5",
"main.dart.js_323.part.js": "693768ae6dc812635f2dd5007c83c3a3",
"main.dart.js_335.part.js": "5b8c506263fefd852dfe66722fdb1abd",
"main.dart.js_324.part.js": "b60e24d61bff87ee8f87222224a02a05",
"main.dart.js_328.part.js": "7066504eb9b9eae87dd96f3466687c82",
"main.dart.js_289.part.js": "a7ef542d3db3b2e0f8c80723f6ba0fb0",
"flutter_bootstrap.js": "9a45db21b81351a6c1f7411915984b3c",
"main.dart.js_315.part.js": "8f9fa2914d585b6b34fed5fe88c049bc",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "f24f642af530296d65966955eab32f64",
"main.dart.js_326.part.js": "84bb5c55c71d6a579154fe4024701cb1",
"main.dart.js_329.part.js": "6d7a8d3f52eed642d20508b480c089ac",
"main.dart.js": "95ef79544afd622ab5b88688627bf046",
"main.dart.js_17.part.js": "005d2d687c95ebf5bd7c9e796de2d112"};
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
