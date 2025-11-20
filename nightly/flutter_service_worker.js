'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "0e76c7c818a6ebd484513eda6dea04fc",
"main.dart.js_259.part.js": "8e87266aef9fe152022fb9b80c4ac534",
"main.dart.js_317.part.js": "d009cfd8beece137b4632e087026c9dd",
"main.dart.js_243.part.js": "d5043a744b34bfe108d8283684596fb2",
"main.dart.js_1.part.js": "fae75bc18aae4dee58ddc3254b1388ec",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_274.part.js": "d297f8ed0701e9e70899674e6e8ee729",
"main.dart.js_318.part.js": "b964217dc82f96215bd9026712754adf",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "71f8721be26f01cfb91509d0fb1676cd",
"main.dart.js_234.part.js": "841de44cac3c0c19f6347a47e9b73c4d",
"main.dart.js_316.part.js": "46a83141d1a4a30a6b14e08b2b337477",
"index.html": "8b51dac74c7a9fed3c66f181903ea2d2",
"/": "8b51dac74c7a9fed3c66f181903ea2d2",
"main.dart.js_251.part.js": "4c2bf529fbf6fb7033903cd7b645d8cf",
"main.dart.js_302.part.js": "92aba2a0a3b9ba12abb3a11ebe33de23",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "04210aaf92f139adfd2d55bde427915a",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_265.part.js": "750152ac81e56d70c6e96b75e3d6d88f",
"main.dart.js_300.part.js": "d8ad1a5a94e6dcb4f134ee306d817a10",
"main.dart.js_261.part.js": "4af5c43a569e1adcbc40cbdc4ea8c1f7",
"main.dart.js_299.part.js": "bfb6f5d415c27a2f5b6f5f1b7a34e6bf",
"main.dart.js_322.part.js": "0782b3d95e94fa5d2a4b3f601312ddc7",
"main.dart.js_263.part.js": "25e9a3247fb567fba0cc8b446a9f2f3f",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "9d50e1597a22e7d9d0f10ebdcbff4ba1",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "94e3cc0a42531cf9820165652a824019",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "f1cf8b35918a00fd5fdc9eb0db466ec7",
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
"assets/NOTICES": "18f6b1633458f1980747a31d7e0608c1",
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
"main.dart.js_210.part.js": "52220b6a5ca6eafb52076791f9a452ce",
"main.dart.js_240.part.js": "6a9929f26ddbe8fe6dec2c5945cb4958",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "cce5ae1122c83ec15a5a1c6f1874f251",
"main.dart.js_278.part.js": "bb376aa7f859d748c5ea5a86aa7bc680",
"main.dart.js_202.part.js": "417b91a8aa9035b674d5331dd37a16df",
"main.dart.js_286.part.js": "4dc65a60b149a5b045cef6beb2586555",
"main.dart.js_303.part.js": "d00b892d7a7f3d8d2356818b72598947",
"main.dart.js_252.part.js": "26e69a7d258284a56d0c910bbdbc1daa",
"main.dart.js_269.part.js": "a611bb90ea9968e69e55067f9bb2169a",
"main.dart.js_313.part.js": "31064c0ba5be631b596dbb39f39adb66",
"main.dart.js_312.part.js": "71aeda324e497aa9013fe88c28c844cd",
"main.dart.js_325.part.js": "86ecc7cd3f0b1773d289f790be6aa318",
"main.dart.js_298.part.js": "60700bda057c94283f7b2fca27b6777d",
"main.dart.js_285.part.js": "000405c57680cb0b7cbf9bb9c6b238ef",
"main.dart.js_273.part.js": "33bfef34899b009752fe070a421b168b",
"main.dart.js_255.part.js": "8bfe3faa35d5177f2fd75123f8aa2c8c",
"main.dart.js_268.part.js": "010d071e22ba83ff78b9c995e1def36a",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "fa191de6289d941316b9a1c38d193416",
"main.dart.js_314.part.js": "d0abafddb1cd437d3f6a58e14f53c701",
"main.dart.js_307.part.js": "da0440ae990174b6c8eb0f3eed0f3eba",
"main.dart.js_279.part.js": "82c278c3d4b0cff073530cce5c45709c",
"main.dart.js_319.part.js": "8ea4fd8c99b0cff0e1659b7460a3417a",
"main.dart.js_253.part.js": "8ca458f2e829922fbbfc75cebec87cfb",
"main.dart.js_323.part.js": "8c977c07ce43c3ccae4e1bfe53172183",
"main.dart.js_324.part.js": "f6e98e060e8f9640b8584f4302676a9a",
"flutter_bootstrap.js": "cceaf07636805217df3705244f730276",
"main.dart.js_306.part.js": "0b3e9369c3f625d0e43d6bcfbc64369b",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "ab45ec6a1e0d19c0a7c2d58af741c84b",
"main.dart.js_293.part.js": "fee73b906a3f885247da7cd67a0a4eef",
"main.dart.js_222.part.js": "5bf0ec023798fe10b5354cacf282263f",
"main.dart.js": "f06ad9993e63b4e7ca7d6545721d538c",
"main.dart.js_204.part.js": "526876a2c9c223c22602b1d50c9f6bd8",
"main.dart.js_17.part.js": "e982c82426e5fc0b491068dd2e5b9816",
"main.dart.js_277.part.js": "7d6ba2d6e7e4d88cd4132499375bdc8f"};
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
