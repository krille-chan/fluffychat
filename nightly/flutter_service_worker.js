'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "805b1e8c7340772092de25ef03d0a3e1",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_207.part.js": "dcec61363fb37500dc819c9da5a3896b",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "35416e36caf9161cb6adf0ce9b1bf7ac",
"main.dart.js_308.part.js": "91430e708e0d5462f30a8591b689f63e",
"main.dart.js_271.part.js": "49869ed510e73974264c1b30bbeff389",
"main.dart.js_317.part.js": "a9cdb332943c46b0275a5fc56c1eba79",
"main.dart.js_243.part.js": "eccaf70497b77adf14f1d54b41df7633",
"main.dart.js_1.part.js": "b7c155d6b22fa1596f8990c5a9210142",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "5785e195d388231ec91f49926e0eb1ac",
"main.dart.js_280.part.js": "dda9e011ad6de4426e9ab386093bd724",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_266.part.js": "82069f95e9f18823f06397e7d99b00a2",
"main.dart.js_316.part.js": "daf5bca853e33544ac9ea16369803785",
"main.dart.js_246.part.js": "cb8f677eaf611fb2c79f5937fdaf74c6",
"index.html": "ce349cf6b3bf79ab6379c6597da7243a",
"/": "ce349cf6b3bf79ab6379c6597da7243a",
"main.dart.js_302.part.js": "a20ff053fc4e0e3a813141708b427622",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "ae1fce617e8c6eb125f77d836a209bb7",
"main.dart.js_305.part.js": "01827612037d22444dabae0092c7bc13",
"main.dart.js_258.part.js": "f6303fec2250873babfca5248d516278",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_262.part.js": "5ceb92cf160898a56e6933a2c57e68a0",
"main.dart.js_322.part.js": "a546b76c79130c4c13d403ef7971e01f",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "e83704e92859597a9c44d29f9b8999be",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9347f6bc15b416299447c41f09d07dc7",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "84122286712f363413510742832b877c",
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
"assets/fonts/MaterialIcons-Regular.otf": "cf04b1acec037d1bfe7beae9ec5d43f3",
"assets/NOTICES": "e625a7ec045eff06982950dd09005016",
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
"main.dart.js_320.part.js": "313a86dfeee1ed411a4738ac8f7c35bc",
"main.dart.js_254.part.js": "0f8137382a6d757c8790cf2a898bfab7",
"main.dart.js_228.part.js": "49dc490578cf173515f694e11f2ada2a",
"main.dart.js_16.part.js": "462c83ea2038a630576d90b172652586",
"main.dart.js_296.part.js": "5a7ed509d4f68319b9e1470227772e13",
"main.dart.js_205.part.js": "a5b268f6c0032d411939532068226b23",
"main.dart.js_303.part.js": "d9ec7846757a5bb14794e4ea842960bc",
"main.dart.js_237.part.js": "e610885ecc40701bf34409be7653d09d",
"main.dart.js_213.part.js": "2f44cc5a44cb32fcdedb5df9f06a0b3f",
"main.dart.js_309.part.js": "191c92e3f563dbcc72b8e2fc44b48b55",
"main.dart.js_325.part.js": "f5c11657af29c8c4fb250c3093b68c97",
"main.dart.js_298.part.js": "d41ba54f41b1316adf9f3ff0dfac8787",
"main.dart.js_321.part.js": "fe27ae8d60baf63063058762cda5df83",
"main.dart.js_255.part.js": "033cc1a6238c2fff997d4bd6ecca379c",
"main.dart.js_268.part.js": "590a1e7c6e452b84f061d5bf84d78f84",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "fd8350afb22f040d24115f2cd223b630",
"main.dart.js_288.part.js": "42051e14ed2b1db127eb50228cdb4dd2",
"main.dart.js_319.part.js": "4afb09057ee9f21cb0ada40537df71f5",
"main.dart.js_323.part.js": "d99b094cb58c54ed525e180bbb3611fc",
"main.dart.js_328.part.js": "d1b4abb8a0c165fd6f990013dc133fbb",
"main.dart.js_289.part.js": "6c2fc37460d42feaf90d7fb023858b29",
"flutter_bootstrap.js": "fb10e607bbf11e45b579bd54c8d04071",
"main.dart.js_315.part.js": "ae56a69a09b26e09031c72a56dc0c57d",
"main.dart.js_304.part.js": "305996f52ac519a8d8e0feaae1a75214",
"main.dart.js_264.part.js": "cd66a4ece1cb392dc6929c6d18a064bc",
"main.dart.js_306.part.js": "2d325722eb1bae92c8bf3318333e0f23",
"main.dart.js_276.part.js": "24b202d0a3b6eea1fe769b2945f35c5e",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "92f580b5d3db9c67049376d42e78ef53",
"main.dart.js_310.part.js": "c00dd4309917ca20f3800452fcb7f34c",
"main.dart.js_256.part.js": "f015fc3ed32c59630919044e03cb4347",
"main.dart.js_326.part.js": "f09e5c8e98bc4eb3fcbca29bb7eb342c",
"main.dart.js": "34f7bc3aa76515f8c57c40ea99519b99",
"main.dart.js_272.part.js": "517f3df07078d6df11546b54885165e8",
"main.dart.js_277.part.js": "27d143e4df1ca8882a866f3babfd2db9"};
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
