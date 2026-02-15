'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_297.part.js": "9c663a97b9eac6288344b9e7c9c4510a",
"main.dart.js_330.part.js": "10eb1f52a8e1ff5cd2c9ac445c965569",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_337.part.js": "795420792823f7503fe78c9e24964ef9",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_289.part.js": "1c26cd22de2ec7cde8e34185bed4ee61",
"main.dart.js_323.part.js": "151aab43d3c5e3881d5e6a6c060265ae",
"main.dart.js_271.part.js": "f166a8497915eb8bdabb74d9c9087e67",
"main.dart.js_260.part.js": "6fa466bd98a99c57d8a550f500875a8c",
"main.dart.js_306.part.js": "4d273c77ae9967dea782dacfac6069f9",
"main.dart.js_283.part.js": "b899edc2bea193c438b208e50a55f4fb",
"main.dart.js_331.part.js": "ce818138d682a8de81d0b08ee8be90fd",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_1.part.js": "4a0c3fd00c244a08c66d6705b3935400",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_310.part.js": "4a88c2e9beb8c9a13b17885f15b67682",
"main.dart.js_252.part.js": "a63a15bde042282a3cb61578b6e364f0",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9ecc430f580f9b3719b6b01365a7d134",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "f64b7b1d5a9da872542d5b27e2aac785",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/particles_network/shaders/particles.frag": "1618a243a3c1ee05d0d69d7f0d8ce578",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/AssetManifest.bin.json": "045a6fd0064669d9c6e2d4eb44bc7068",
"assets/fonts/MaterialIcons-Regular.otf": "59e871f2bf0a7a405652ee3737782a10",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "db9a24a16187744848654f7d6b506c01",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"main.dart.js_264.part.js": "5b27e8408b6ea305a56e13ba16a8eee6",
"index.html": "8d08397c63b4ac9ed73fcc3bdf7355a4",
"/": "8d08397c63b4ac9ed73fcc3bdf7355a4",
"main.dart.js_316.part.js": "680d09e836077337b41fc0ac092a7ba0",
"main.dart.js_218.part.js": "c6f44f290e9de19dfbf46268367c3577",
"main.dart.js_233.part.js": "2181af46d003c2e512aff29f3ed6d519",
"main.dart.js_332.part.js": "9ee27b6d2fe6f0e3f96ff57b315d4317",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_336.part.js": "1d473aa40487a50c2ef8e0daf9b32dc6",
"main.dart.js_299.part.js": "98defa00efbabe6899791e3997d4fb51",
"main.dart.js_328.part.js": "2abf9604edf2416d20dc5a5401d150a5",
"main.dart.js_210.part.js": "5c903fc576e5c9016aafa51ed5f24b8f",
"main.dart.js_329.part.js": "c30f039b916ac1f3642af2fb567afed7",
"flutter_bootstrap.js": "170de50b2e152fb5598af76e39bdf373",
"main.dart.js": "9ff76fd7b0c5759841f7e5c87670d8f0",
"main.dart.js_312.part.js": "c2d50c0b1668e02cdf96e929f062e22e",
"main.dart.js_2.part.js": "fd3741be9c6bba0541b519ab3e8890a2",
"main.dart.js_287.part.js": "b550fca211685118b3c80191e031db6a",
"main.dart.js_269.part.js": "acf30e83e088ddf5d09260d8ce33406f",
"main.dart.js_318.part.js": "201d56a9b659704738bf3e4042ce4ee9",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_313.part.js": "cb22efb9b3e27b8fb69fba94983c1c2e",
"main.dart.js_249.part.js": "a5b732baca6fef8772889a688911ede8",
"main.dart.js_212.part.js": "ac2563cae7b5d48cfe2f3f9c5051f089",
"main.dart.js_317.part.js": "eb02d6a9096aa63e5a48d1c8f3690e6c",
"main.dart.js_325.part.js": "38fc8554d302a4d54e2289548a2df67b",
"main.dart.js_311.part.js": "de654c5a15b53207a47b0cad8b656c85",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_288.part.js": "872f2eb66d830166fe46753c0c29d8e9",
"main.dart.js_335.part.js": "82615f2e1a1aa91b7f9de47c63f83097",
"main.dart.js_324.part.js": "04e25cbc0aca477311e7073c2e4a2d89",
"main.dart.js_284.part.js": "9f9c46817c8e74bee75d9673927f34e8",
"main.dart.js_275.part.js": "3f63e67f660fef554e4c2d5dcd0d3afc",
"main.dart.js_273.part.js": "5edea49d7df8aa2c33dd5dce2f726e0e",
"main.dart.js_326.part.js": "cd10a59af12694ffa7116593582f87c3",
"main.dart.js_309.part.js": "92ddfbf74e35fe8add5e3fb86181f070",
"main.dart.js_17.part.js": "2ca4f440a09d253e432d335e6143dac4",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"main.dart.js_278.part.js": "73948cd88b31c7ea634aef4b6b705149",
"main.dart.js_296.part.js": "685d1041ed3bb8fd3310298b17113394",
"main.dart.js_242.part.js": "bd3371b9eb49b902e44b5a3ffddd7727",
"main.dart.js_319.part.js": "751408f845e3b59656224d09451fe3bb",
"main.dart.js_261.part.js": "5f872a56b15eea33152af22e72871627",
"main.dart.js_279.part.js": "59c488559364b08e6c3e0a5e6b4d9906",
"main.dart.js_225.part.js": "18fec0e91f711bca8c75f002987f07f5",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_334.part.js": "194d6c562200b8cf9c0dfa432f165c55",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_304.part.js": "29894ddae20f92bc51a2202133214dc6",
"main.dart.js_262.part.js": "88f3cdb2c7e2ad0c2837f60901748cd7",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_314.part.js": "ae0bbc519399e8a0edfacb636991c202"};
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
