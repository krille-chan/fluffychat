'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_271.part.js": "2cf530ca6ee2964a62adcbe8bb8aebb3",
"main.dart.js_317.part.js": "a03810edf7dea48ccbc667a845a4838a",
"main.dart.js_297.part.js": "f0205bde85505b77b664d1aac2decaff",
"main.dart.js_1.part.js": "52d89ecfc6472f0637b63c0f85f74716",
"main.dart.js_260.part.js": "9cd92085cd3fd36d975266806b3b5154",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_311.part.js": "fa8a87ca5478a485de256ce06f729ff6",
"main.dart.js_318.part.js": "a1f85053b9f8d2273962c25b3cb431c0",
"main.dart.js_316.part.js": "99c77d450b154b169763068f016ae673",
"index.html": "7f5a8f1b6a1b1332b83b170a433cfa9e",
"/": "7f5a8f1b6a1b1332b83b170a433cfa9e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "f8aa2c8de85c1fc32c4e53b9f4b19815",
"main.dart.js_2.part.js": "2b138bb039cb1b661fbe9172bdbcf34c",
"main.dart.js_283.part.js": "5faf6da9feadc86ab79337db2a78068b",
"main.dart.js_261.part.js": "2af0c0a5cf12305ca7fceebb7923a6c3",
"main.dart.js_262.part.js": "7da0cf936c78ebb1306fccbc9e36f551",
"main.dart.js_299.part.js": "990dba97fef63b6da55ae75940b133b9",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "cbdc692e3bf664942e4237f4d63f9f7b",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "045a6fd0064669d9c6e2d4eb44bc7068",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "92c6a9eacd8930bf161238b323a4ab00",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "bef4a349b966011b213acd5500927e45",
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
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/particles_network/shaders/particles.frag": "1618a243a3c1ee05d0d69d7f0d8ce578",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "db9a24a16187744848654f7d6b506c01",
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
"main.dart.js_210.part.js": "bc3ed6ba3d954bf5ff6a2023c36fd378",
"main.dart.js_334.part.js": "3c4af749f133858b179aeb6afffeceaa",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "195a7b4e4699b72f916896114851556d",
"main.dart.js_296.part.js": "fcd8786b123f8b6f9bf47e9a144a442a",
"main.dart.js_278.part.js": "8512f2d39668e150d94dd09c280b8ac4",
"main.dart.js_336.part.js": "52f2010996b3935b549fe602203451ed",
"main.dart.js_287.part.js": "c95e171fbe3e78b6a62a63af80a8c0d9",
"main.dart.js_331.part.js": "980b411af708327e26792c9fdad996be",
"main.dart.js_252.part.js": "ac565951781a9299f7514a65bda36404",
"main.dart.js_212.part.js": "026084cb5f1d87f2cdddc487f3e96d5e",
"main.dart.js_249.part.js": "6be137d8f2868a50f4fc06672dcf08f6",
"main.dart.js_269.part.js": "50399bd461025d250cac04e6ad3248d8",
"main.dart.js_313.part.js": "c2300d24491ed5284a72a956fdd02127",
"main.dart.js_309.part.js": "12681260d95f83b7ab3a9926dee55409",
"main.dart.js_312.part.js": "dced8d9946673b20be17b64a889732f8",
"main.dart.js_325.part.js": "6a2549625cc07c960dcb9ab4c0627bc5",
"main.dart.js_273.part.js": "c63dc64ad8de76e442e11ee534318479",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_275.part.js": "61aed534dfc09ea402f678b8b3a4f721",
"main.dart.js_332.part.js": "0b85b90aff8f02de6f3ff4c64a16ea3f",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_288.part.js": "09a8f67bca5b91f41f628dfafe18971f",
"main.dart.js_314.part.js": "44e1a58d968539497c222d387f9c10db",
"main.dart.js_279.part.js": "1ec27c4fe427d248b02aa8b263323cb5",
"main.dart.js_319.part.js": "8961df4b96a2166e0f920c232582398b",
"main.dart.js_323.part.js": "28333fc955cb569f371314cdc427ea70",
"main.dart.js_335.part.js": "3fe6cfacbd18f43b6c8af659b9cd0b8b",
"main.dart.js_218.part.js": "49f8f634c82e84de91f1414eabd0104d",
"main.dart.js_324.part.js": "1da1e765c61d2f920395fd1248561414",
"main.dart.js_328.part.js": "cb27d3683b0bd28659687d29174b29d4",
"main.dart.js_289.part.js": "f3570652c408b534a0496283be8ec080",
"main.dart.js_337.part.js": "daf09a2466032bc4eab7cc7df43deb4b",
"flutter_bootstrap.js": "a0e90fff3ed9e2afd8a3a18b457fa1fe",
"main.dart.js_304.part.js": "497a289bc29290785e9d35f776cca65d",
"main.dart.js_264.part.js": "8d917e65e42d2261012606b14462159c",
"main.dart.js_306.part.js": "e5bb911745a49c824c1342e90f8caebe",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_225.part.js": "51134d5282e3a360f2ac650e10a6ceec",
"main.dart.js_310.part.js": "b4fb4daacfbb603655661ccb36b2e70f",
"main.dart.js_233.part.js": "d9e7cd15c6452619d837383800fb0cc6",
"main.dart.js_326.part.js": "e9d535ccac4e5eee685060779e440301",
"main.dart.js_329.part.js": "91e0355d81bdc6ca20b67859d42b6249",
"main.dart.js": "157d04407389b1f299ed75ec164d6b02",
"main.dart.js_17.part.js": "231b108841fe273ae2b3db8bf8ca3430",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51"};
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
