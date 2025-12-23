'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "fc1ff89559399e29c7388f5a10d89ab0",
"main.dart.js_271.part.js": "ac3de1784c3de809f6762b2c193ff170",
"main.dart.js_317.part.js": "12dd637fb734c7f82eaf055b64a2206e",
"main.dart.js_1.part.js": "9e441d14e6aaf9df4396b73b245b06d1",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "63625ed94cde8fd2e25ff81a3f98f03c",
"main.dart.js_311.part.js": "5d51ca6e47cfa21d022e3b84077323b3",
"main.dart.js_220.part.js": "4da3f51cca8e096717b798ab66bd626b",
"main.dart.js_318.part.js": "8cf3ec74abbb71e3a2277b56ba468f9a",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "8443e4d13f612669ce12f87a3c4cd4d8",
"main.dart.js_295.part.js": "57379454a1c925360dd736840996325e",
"main.dart.js_316.part.js": "75f254c98e2392ceab07bfb0e5e5a0ae",
"index.html": "53b3871ff4a33c82a67a3658ff560ca4",
"/": "53b3871ff4a33c82a67a3658ff560ca4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "31e657219679ea9cc7cf41fec12be537",
"main.dart.js_305.part.js": "b1e3c202715723d63820b653121ae6d5",
"main.dart.js_244.part.js": "571cf6a9256266db9bac07bab5ecd970",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "6135ba51fa72b2af903250c8ef3a26cf",
"main.dart.js_265.part.js": "35ccde6dc7bc6322fc64ff5ef8ead382",
"main.dart.js_261.part.js": "cd0b68f9ad0de100622e8a95588aa13d",
"main.dart.js_262.part.js": "fdeef31be37268aded12a7b30e3415d1",
"main.dart.js_322.part.js": "8d1537a171e0f5977705aeea45f4d5a8",
"main.dart.js_263.part.js": "2ca2c8575571a7822c4763e6e2b80ca4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "0781a02ce1c8176e3dcec288b2092836",
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
"main.dart.js_334.part.js": "56a42d436fd0f4e598eecc2a6c72c6d1",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "80a5468defdd350acac1867558ad92b0",
"main.dart.js_296.part.js": "ee1c09bad5e624a872afd176da94c01f",
"main.dart.js_278.part.js": "c3b451755ee0cb505d12c1121c95e527",
"main.dart.js_232.part.js": "514e5c28b58635664db6edbf731efc29",
"main.dart.js_333.part.js": "e7ed1fbfd1a69955e5e5dd626b4174e9",
"main.dart.js_303.part.js": "7fd9f6db64d0b67de3084eb821001b70",
"main.dart.js_287.part.js": "4437d835396cef7c43afab90af911a96",
"main.dart.js_212.part.js": "6a6e5684d4db80b8482de60b2543ee2b",
"main.dart.js_269.part.js": "63e9776fa57012cb4eb5caada898ab57",
"main.dart.js_313.part.js": "0b07807887a64c685d3035430f8c013c",
"main.dart.js_309.part.js": "1c4c4f89c575fe808b99e9c54ca62a8f",
"main.dart.js_312.part.js": "b0649da026b4419571aef691186fcfce",
"main.dart.js_298.part.js": "411f2d7c267af50e962ffbbf9b30f062",
"main.dart.js_273.part.js": "96a11bb1811470578014c904be644a7b",
"main.dart.js_235.part.js": "315064473c3c6a22da7851649625a66e",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "6ba7c891a7a03772bc6b766c7ad891dd",
"main.dart.js_332.part.js": "632347c15fafe141d4263623e9f1ec45",
"main.dart.js_288.part.js": "800c5aa510cd6fbc5dcd8d9efdf9a145",
"main.dart.js_279.part.js": "78ac961d706c3b7b03a25471354a25e7",
"main.dart.js_253.part.js": "ad258f898e3b1e3aaa742dfc4f77ce5b",
"main.dart.js_323.part.js": "0ed91e7b03c935f0b86f7bfe165be08c",
"main.dart.js_335.part.js": "07e64a5d5635c28a3aa6ce9aae06034f",
"main.dart.js_324.part.js": "ba64a7ba82b38032db787e4d7d5b40f2",
"main.dart.js_328.part.js": "9632f61930aaaedfa3b2f29ad434ee6a",
"main.dart.js_289.part.js": "e219d19c9ddf12fad425d4e4daa488b1",
"flutter_bootstrap.js": "d8485eb1d0aa5b2d120264a9c9ee37eb",
"main.dart.js_315.part.js": "514489be38a524ec23855bf7ac6cebb5",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "14d4391c909f09e357506e71c4fee93e",
"main.dart.js_326.part.js": "b7330278cdfac8602cb99790d78e68b5",
"main.dart.js_329.part.js": "82813562fa9814040d3454695da7c681",
"main.dart.js": "687f87fc45283088cb226640fc33245a",
"main.dart.js_17.part.js": "42b55335907fb590c50cdea74d1240e6"};
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
