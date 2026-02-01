'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_271.part.js": "1d0ee540dd9a1a2196727a5fd24e1f55",
"main.dart.js_317.part.js": "44cf011e4e2db1c2eeb463d9b31312fe",
"main.dart.js_297.part.js": "1af9f9c2cc9c983708e07d2c8b4e5d25",
"main.dart.js_1.part.js": "a4a97b2b9eb0d71cad2376da18532b34",
"main.dart.js_260.part.js": "76511157b7213511e453ca5c0210f92c",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_311.part.js": "3b4955ab153af921ae4410b73aaed3ed",
"main.dart.js_318.part.js": "ba347379dd571ef627eede8b2fb8c09a",
"main.dart.js_316.part.js": "3d1ee840f04720bea6a84c8748096495",
"index.html": "1aa4b270bc389930f6c0a1e5d28dbaa5",
"/": "1aa4b270bc389930f6c0a1e5d28dbaa5",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "4908ccc65d435d2481ca0e8596393083",
"main.dart.js_2.part.js": "2b138bb039cb1b661fbe9172bdbcf34c",
"main.dart.js_283.part.js": "9af6ea5f4a46f982eeb343ba25a3c4a8",
"main.dart.js_261.part.js": "38ba6c8732dc5b1921e2c1b40ac714d7",
"main.dart.js_262.part.js": "920a0e7b13d7f01b95f576efd8dc9769",
"main.dart.js_299.part.js": "ecf60443c754d931d3f2d785487dc8ee",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "051c53125ca3a0332c520e34c3f05eea",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "0a5ffb27a4cb6a30f9bfdffcd6a6d1a9",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "bd7dd9733149562a6f9cb54cc5f5f7e3",
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
"main.dart.js_210.part.js": "82a0cec221adf63624cdcec03427a5d8",
"main.dart.js_334.part.js": "61938ec3f36b7d92fd9339b515baaccb",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "4a3d687a30746819f7249171e607911b",
"main.dart.js_296.part.js": "12b8eba2f0b5ea8d37476e9dfd7e347f",
"main.dart.js_278.part.js": "7decac9b6c1db538e3e334206aa7184e",
"main.dart.js_336.part.js": "b9e096ea81206577eed9daa3e8b8adcb",
"main.dart.js_287.part.js": "47f38796c2a49c0c1c96a8c33d8935c0",
"main.dart.js_331.part.js": "4ac94d23557155b8068f5a1f1ab60af9",
"main.dart.js_252.part.js": "1a5624ff2bdba0587462036c52783f89",
"main.dart.js_212.part.js": "8adfc0aae878c83eaaae0dac0db0ce17",
"main.dart.js_249.part.js": "cb3ce9670607639076b45f4d94f8ca9c",
"main.dart.js_269.part.js": "ae466ea6d8953bfc490f4e46eb4b126e",
"main.dart.js_313.part.js": "ddc7fc13e53a0cd7581856808838a522",
"main.dart.js_309.part.js": "1d368938eaa2eca26ec1534cdc32ae8f",
"main.dart.js_312.part.js": "f0a6e846e7022cec82d445f1a63a84c6",
"main.dart.js_325.part.js": "93188a362609e8d33b1e50a348b1088c",
"main.dart.js_273.part.js": "d43d0c75a35a2943f11d40c5ad788c7f",
"native_executor.js.deps": "862bb5041ac6577bdb707c968e1912b9",
"main.dart.js_275.part.js": "1f8130a832f56b441df1e4b126ddc71f",
"main.dart.js_332.part.js": "190a33298ff80a0c70d296e670c1bf7b",
"native_executor.js.map": "f024cc1fa3b0f17d8be25ff637b0ce29",
"main.dart.js_288.part.js": "16d48b8c221d3186152c98e7ea47420e",
"main.dart.js_314.part.js": "4394789d771c1e59575c8139ef464e4b",
"main.dart.js_279.part.js": "e1d634c13cc118e38d375fa9053eb24c",
"main.dart.js_319.part.js": "2669eaee968dfd5d5016b4e91dc20280",
"main.dart.js_323.part.js": "5b9463e352a8610b9ef880933896bee0",
"main.dart.js_335.part.js": "9003bc9e1c8dae7a6e37c0a77f7b8df7",
"main.dart.js_218.part.js": "933e24bd1ef56584485f17c58e74682b",
"main.dart.js_324.part.js": "eb5806d19ba89404c7ff11a59a12628b",
"main.dart.js_328.part.js": "44f47f7fac0e0b64a6cb46d8f5f688d2",
"main.dart.js_289.part.js": "01075f83d7c4f7c62d3edccc16feb01b",
"main.dart.js_337.part.js": "0a9188e6a9f37dea2369fb2a65af953a",
"flutter_bootstrap.js": "f0adf096476b89ea2539834fc0d2f8cb",
"main.dart.js_304.part.js": "f7728c31296ab8c1a18931c9bd6fa433",
"main.dart.js_264.part.js": "4fac24f0a7b46452e80cf9405dc0a950",
"main.dart.js_306.part.js": "d29a464f3efe89eb7611fd7e0739abbb",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_225.part.js": "a3b8e31a359739034b852f7ca048d00e",
"main.dart.js_310.part.js": "0c4bc638ee82c1e92d297d9dcea9a9dc",
"main.dart.js_233.part.js": "877366f9cb627b91cb7ddf18843f81ab",
"main.dart.js_326.part.js": "db1325cda167897a9ed6ba31bc8eeecd",
"main.dart.js_329.part.js": "4e654fce1e3c65a8f52915936b84fdb1",
"main.dart.js": "1d9511e1a49b61bfa8221ac1b7de4dad",
"main.dart.js_17.part.js": "b5cbd3c790f32a307c9526a7f0693c26",
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
