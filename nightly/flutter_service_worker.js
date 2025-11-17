'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "4277be0614b228b2000e1d887d3e30ec",
"main.dart.js_308.part.js": "967aee81f675f9e219dfbc62860c78f6",
"main.dart.js_271.part.js": "69b5ecfd2a7e7640059477e196f19ca1",
"main.dart.js_259.part.js": "ca5784a3d0c2bfbba4ca528c01e41247",
"main.dart.js_1.part.js": "b7c155d6b22fa1596f8990c5a9210142",
"main.dart.js_260.part.js": "3bd19d5e8a0451f2a3ad0200b57e2487",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "92226ff42d446f8f567b9d1524f1b062",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_316.part.js": "9c37b1db1c861a0d79196a83dd944f9b",
"index.html": "a949fc25fa3ccd3311b9af6f6fbfb201",
"/": "a949fc25fa3ccd3311b9af6f6fbfb201",
"main.dart.js_251.part.js": "0fc044cfadc6577760ff7a0894046b01",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "f80b8998898e170ca81d83ef2bd3865c",
"main.dart.js_242.part.js": "b84d83898aa41d0c5dc5df37288c3e39",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_294.part.js": "b08fe394a7f2e4468ff67aa9ff1e1f5e",
"main.dart.js_261.part.js": "845d533add89cb3ec69a7a65273240c3",
"main.dart.js_322.part.js": "a702e655650c1fa9ad7157a1078e1c1d",
"main.dart.js_263.part.js": "c0aeae17d3c511aa7c4ae4fa102d1b2c",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "fda6eda466e15653f61196242de9b4f3",
"main.dart.js_301.part.js": "6f9a9a92c5433ac6e517a01e17356d99",
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
"main.dart.js_210.part.js": "fe9f3245dee5be94fe9f5242862eb90b",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "7df9dd0da338e7f3ee32ef160f33c04d",
"main.dart.js_16.part.js": "462c83ea2038a630576d90b172652586",
"main.dart.js_296.part.js": "8e4581dfe6ef4312d9c78e77a6f062e1",
"main.dart.js_286.part.js": "22070746655199e3b42e90239fd399c0",
"main.dart.js_333.part.js": "f0840adb969a0a12a0a78e4ab406215a",
"main.dart.js_303.part.js": "1f93f24884a45c9255960ed057a8fb27",
"main.dart.js_287.part.js": "b10fcc52fcadd08dd6012b0c90cb47b2",
"main.dart.js_331.part.js": "48824592395cc741acc131502725760d",
"main.dart.js_212.part.js": "2b4fa30d4a7e3c6363edcb1d69f2f27a",
"main.dart.js_269.part.js": "42d42427cbb6b57021b037fee51da915",
"main.dart.js_267.part.js": "38611853cd27ffd72671804a0693267f",
"main.dart.js_313.part.js": "691c3199be4dd98cdfffcb3b0afb9a21",
"main.dart.js_309.part.js": "80ffee3e41ef7c3dda146ae302f88ea6",
"main.dart.js_325.part.js": "5d613473132b8496b018b20f7dad4f5c",
"main.dart.js_285.part.js": "63a248c918035cb62d9ce0cc99082cfe",
"main.dart.js_321.part.js": "89c8e7a218dd421e63049a2b6317bece",
"main.dart.js_273.part.js": "a723d4cf696e047cb66eae934879362c",
"main.dart.js_248.part.js": "55357f4707ed0f36e66d85c6d1c675f8",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "a6b48a4bbc8286ea1d29047a96af4ede",
"main.dart.js_332.part.js": "7b9571d2e68b23f77641f33fa6a661d2",
"main.dart.js_314.part.js": "92ec728438e57b8e8db543a129ec84df",
"main.dart.js_307.part.js": "20865d271dd57ff4bf0f22eeb84be39e",
"main.dart.js_218.part.js": "500f71c319ea4e866301d0ad6d7afe20",
"main.dart.js_230.part.js": "a0f708959a1001c62d45f6a566a26570",
"main.dart.js_324.part.js": "0e8eebde7d8eb416bfb617d2047824ce",
"main.dart.js_328.part.js": "98a325696ab954b55280fe1baedbae99",
"flutter_bootstrap.js": "53dc8b8916284b2439ce31837d18c944",
"main.dart.js_315.part.js": "f8b805f593c554ead02fd61f4c597bd9",
"main.dart.js_306.part.js": "122d064e920c3065ff6651296e2823d4",
"main.dart.js_276.part.js": "e461ca91f2cd5ba9b82e591e46c42a1d",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "18e95bc052e08ab5470a34835d1c084a",
"main.dart.js_310.part.js": "41add9e0f7c8b4dfe4684da0fb27e0bb",
"main.dart.js_233.part.js": "8485e3d9643fd29da8efd0bd0d4cb653",
"main.dart.js_326.part.js": "2e592b2c2d3f643422df751b91ff8d14",
"main.dart.js": "90282d8428b30d60c53d98c5e8dc9bc9",
"main.dart.js_277.part.js": "406db061fd5ae8e4dc34e5c507def6b7"};
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
