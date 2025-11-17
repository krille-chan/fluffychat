'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "05e49ab326c07ddcc5a4282528200c69",
"main.dart.js_308.part.js": "c8df53ede1bc5e050bacaa09edbefc59",
"main.dart.js_317.part.js": "7e6a6b6d91b733c03ea2c3e533df69a3",
"main.dart.js_243.part.js": "300a7977457b22757fda21147bb6a6c7",
"main.dart.js_297.part.js": "f6f3f46c4e29f00f11afcca72c821689",
"main.dart.js_1.part.js": "b7c155d6b22fa1596f8990c5a9210142",
"main.dart.js_260.part.js": "0fc156d9bb011ae795866f30a05b00fa",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "1b0f547093c2e81fd87ec227c3922cdd",
"main.dart.js_274.part.js": "56ebbc30677cb37d5b1385a3e4ffa4c4",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "7ff0ddcc46012e31f7030da19dd9f953",
"main.dart.js_211.part.js": "eaccfabfec0cac2f58432bc9df96ad53",
"main.dart.js_234.part.js": "cfc7e47a5a3c2dcc09c201862586edf5",
"main.dart.js_316.part.js": "eb61cc86aba55a86fdb2b9334c5b9511",
"index.html": "7c9bdc91d9e9e55539b61314709b87d8",
"/": "7c9bdc91d9e9e55539b61314709b87d8",
"main.dart.js_302.part.js": "f20274501a2a23f96b3c6262080835d9",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "b76b8e9c2790a2bd6b169eb68993a050",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_283.part.js": "36c130f7762387526375bcf888802cae",
"main.dart.js_294.part.js": "d1e1bcf19b4bccc85fd307db112abb23",
"main.dart.js_261.part.js": "b49903b89b546499ea860fed5a9779d6",
"main.dart.js_262.part.js": "1ea35ba58f3f6b35ab3afb889281c3aa",
"main.dart.js_322.part.js": "d1671b28f788801bfa240351775fae61",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "50c84084a133eae450fffb8d6444bc3d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "96b0bb5be20cd33cabf8b7e9d3cea283",
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
"assets/NOTICES": "4de3f617c2e220cbcf134b0c31162a7f",
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
"main.dart.js_334.part.js": "090cc091c4584719eee55324a0cb36e4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_16.part.js": "462c83ea2038a630576d90b172652586",
"main.dart.js_278.part.js": "af51178628bebc61d0a067def6a00d87",
"main.dart.js_286.part.js": "afc8fb37e92f0d94a96778eaa74c8ab7",
"main.dart.js_333.part.js": "4a549ad7a3d08d0e2957fb4346544c27",
"main.dart.js_287.part.js": "4e2dcef7acd6649d25e31a48f7ae17c2",
"main.dart.js_331.part.js": "d68791f04b02e9bd4c75bb13286a8112",
"main.dart.js_252.part.js": "310543dd7981ec8844c743298e56f04b",
"main.dart.js_213.part.js": "0a6bf8a564015d997dda5262da0ccb57",
"main.dart.js_249.part.js": "71595f2177f5cae9e11842f36272b438",
"main.dart.js_309.part.js": "00302993efbf177b81d7e1ccc24fda13",
"main.dart.js_312.part.js": "4bb053ca45df6dca47cdb95f5438f5b8",
"main.dart.js_325.part.js": "87b4ebe2bff5b910bbd118cbac3c5399",
"main.dart.js_270.part.js": "299103794db491524103585ec33dcbec",
"main.dart.js_321.part.js": "f8ed944fde2098a2700e37c2887a91cf",
"main.dart.js_268.part.js": "dbdc8aede1f19fa33e2f0b22170e50e0",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "2ea6e9054b76250bcd2dcc21a5ef2156",
"main.dart.js_288.part.js": "5ad1be8df7dad12c7402c071bfc1c2c9",
"main.dart.js_314.part.js": "1ec5bcf3e394b2f92774177b4764efc0",
"main.dart.js_307.part.js": "9a31b32b485046b9705d17f45423870e",
"main.dart.js_323.part.js": "0c7199c95afc704aa5bff1a12f5b1b4e",
"main.dart.js_328.part.js": "5dce89641527a68b4459ca4e920f1a56",
"main.dart.js_231.part.js": "5e9330278fecd7abc9880e58a39d7a04",
"main.dart.js_219.part.js": "66faec4974c074772acfb71450fc8341",
"flutter_bootstrap.js": "be444b428561f32eeb2d0975ab798db9",
"main.dart.js_315.part.js": "873113a28a8154ff28e89c5fbedaf858",
"main.dart.js_304.part.js": "d2c1d0ce1fb76b833cbc176767a4236b",
"main.dart.js_264.part.js": "7fc27cc6d29f761be368714b64fd8b0d",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "e4b69ec1860b8f1f453179c62ff1d301",
"main.dart.js_326.part.js": "44b6e26235c238d5b1492ae535583f16",
"main.dart.js_329.part.js": "36ef65556041b777a38cf1445a5fd9ff",
"main.dart.js": "2afe7a3b33ebab7ea277386740153f20",
"main.dart.js_272.part.js": "654e2a788447315235430b3eff8ffdfd",
"main.dart.js_277.part.js": "5b5af9bb2e263ae9225841941c27ca9f"};
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
