'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_297.part.js": "eedef82e9dc38e8db62dd1f2f5285869",
"main.dart.js_330.part.js": "2406967f2ee889aea9a50580621312aa",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_337.part.js": "4b3286624be840cfa1a160288c9a255f",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_289.part.js": "e38e725e1fe283f0f409b2d651b45ca4",
"main.dart.js_323.part.js": "437e1705e3c14e50424de8772cb314c5",
"main.dart.js_271.part.js": "d771693ea5e6f8d62968f932d781b866",
"main.dart.js_260.part.js": "c7bfb075a01e25b7ac9c93f4fbbf3c23",
"main.dart.js_306.part.js": "1c8d7c7deaaec4cb5d0050046721ee93",
"main.dart.js_283.part.js": "451a11f6f4d7c78a916333e8320cf855",
"main.dart.js_331.part.js": "942c9492b99dcf99ce055c9536826bc6",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_1.part.js": "7db1cdedbe7be86f57dc49f470c786b4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_310.part.js": "15757f1c99fc71418179467fcf2cc49c",
"main.dart.js_252.part.js": "f2596c9a651a116223037b08814ca987",
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
"main.dart.js_264.part.js": "330c9d89221073a20ad3630b7c7df2b6",
"index.html": "956abe12c9d0e8c052bd931bd6674e90",
"/": "956abe12c9d0e8c052bd931bd6674e90",
"main.dart.js_316.part.js": "78f39dc54d39dc6abfe146718d74b1ae",
"main.dart.js_218.part.js": "d70e5e61fca14167fe937c129d8ac010",
"main.dart.js_233.part.js": "9f04b1165746b90365e92ab71ed339e2",
"main.dart.js_332.part.js": "fe78b3b80e36d26e6456762edcf1be77",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_336.part.js": "7d3360cf0b90e5a6e2f28695744aa48a",
"main.dart.js_299.part.js": "1fe77e2f82a18a3dfaaaaf44ea4c0fd1",
"main.dart.js_328.part.js": "bd6615a8e8c7197fbd9eaf8ad27f50f4",
"main.dart.js_210.part.js": "496813c2e203209c358b464dff097707",
"main.dart.js_329.part.js": "bdd4110c18b80a17dc753d659e5082e7",
"flutter_bootstrap.js": "ce0256943e5b3d0233f1c022a81acdd2",
"main.dart.js": "d9e4e9dd60dbab2598a58db1c9d7e5a3",
"main.dart.js_312.part.js": "36a1ad208ccdb4a0e26770807c59f6a5",
"main.dart.js_2.part.js": "fd3741be9c6bba0541b519ab3e8890a2",
"main.dart.js_287.part.js": "94adc89a9df8458f66f8f118679ef612",
"main.dart.js_269.part.js": "b8855fa5ec20eca356fe83fe32ab7748",
"main.dart.js_318.part.js": "b60c6430e51a0ff08308ccebfe37ac82",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_313.part.js": "00d14060950804bdc807f3415554caa6",
"main.dart.js_249.part.js": "3cae1cb9da9aa31598eb7fa40bb46593",
"main.dart.js_212.part.js": "263d8bef5196563b3af4f4a294c35d0d",
"main.dart.js_317.part.js": "b8d735bea1f329d8d2f6b65332b2c9ac",
"main.dart.js_325.part.js": "3c59b7be3860b84dd73f89c38bc51579",
"main.dart.js_311.part.js": "b77c19e48719d6b7ffaa9477da6e70e6",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_288.part.js": "44d2b641c20aa71ba227231593cc870c",
"main.dart.js_335.part.js": "fc40d6c4eae6ca217785e97b5b26608c",
"main.dart.js_324.part.js": "b43cbc5f08287b1ce872ebe57dcb2fcf",
"main.dart.js_284.part.js": "4c6e6039efa22bd1bf9c5eac5bc5bfc6",
"main.dart.js_275.part.js": "ac3c1d905ad7a242b4cb1931357324d9",
"main.dart.js_273.part.js": "9366a824b7156810d5349c1dfa5a744c",
"main.dart.js_326.part.js": "aee340375ee6e43ec0f00d4cc03fd0f9",
"main.dart.js_309.part.js": "56f9f52576d31dc4ec53ed734604b7b7",
"main.dart.js_17.part.js": "880b8d93a24bbd1864406238ab54ac6a",
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
"main.dart.js_278.part.js": "829a33cfeb6c71202296cd2264b6590b",
"main.dart.js_296.part.js": "b1ce2057fc191fca884b94c0fbdd7660",
"main.dart.js_242.part.js": "db000fa0ca72d2b1f68ac6eedf3a08e8",
"main.dart.js_319.part.js": "b2a154bf64306c82140f823dd7af5b44",
"main.dart.js_261.part.js": "3c06ceec0b043bac81e67589bec9602e",
"main.dart.js_279.part.js": "4ee4782693614aff7faddede73444cd8",
"main.dart.js_225.part.js": "4a04ea3b27d6202f8587a92c2fba2eb9",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_334.part.js": "f6c3f0456a8841bfe3e6150b94acbd4f",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_304.part.js": "db5126d7875136c28acab72f60e29df7",
"main.dart.js_262.part.js": "f7cc71d6b5a7f809819c2789f596475b",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_314.part.js": "aff5f6de804558ec14905aac03e22411"};
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
