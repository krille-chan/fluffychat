'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "4750f206c0bbd031cfabb1f0299aae43",
"main.dart.js_210.part.js": "1d1f0614fcc04d0c91fcc959616640f9",
"main.dart.js_300.part.js": "88cd7088f8805748b007a4524af5187b",
"main.dart.js_228.part.js": "4c6202cf0c908eab0f1cfd5938e0466e",
"main.dart.js_257.part.js": "f2c87c8af3922d7b66ed15ae89595ce2",
"main.dart.js_267.part.js": "bef1ea34e9bc7fad3d5ebb0a8498ca08",
"main.dart.js_301.part.js": "32fbd0ef9559c431cf1354befe482013",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"main.dart.js_308.part.js": "3697bc362cfe425e4e265007f49820bb",
"main.dart.js_303.part.js": "cfa957b159dd3a5c65ac6c01966af78a",
"main.dart.js_273.part.js": "11abef990f933a8a95750fc6d946232c",
"main.dart.js_265.part.js": "f4a5ca31eca769ec3de7944891eb93db",
"main.dart.js_319.part.js": "74420a3ee58f6b72325d9901426e3571",
"main.dart.js_221.part.js": "b2fa6b28aed15fde18687e3749289350",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_263.part.js": "e16398fe2ccebc110e4e1bb2e49ccebc",
"main.dart.js_279.part.js": "ace45ea4e7913ec1827fe8d0b13bea25",
"main.dart.js_288.part.js": "95864daf3440cb0723ac1756a5afd4dd",
"main.dart.js_302.part.js": "f8e02eb3a6fe7dfa3bc8407ef8f879a4",
"main.dart.js_269.part.js": "661e666b997bf5744949c456a4900f0b",
"main.dart.js_305.part.js": "1ec922fed18875a87f69ee0266c4eb91",
"main.dart.js_293.part.js": "1867b3449689033c230705c964bb90c3",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_316.part.js": "bda39bb2a39b84846953d954a71ae77a",
"main.dart.js_318.part.js": "89462665087f0bd4096df13510bbff05",
"main.dart.js_253.part.js": "483163f530b871d7ec2d8b0757b52f23",
"main.dart.js_2.part.js": "03c5d270d9d4b62908af9ba7d5cf173f",
"main.dart.js_254.part.js": "854e5ea472584d7ef5fc908d53fef8b7",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "fa2838566a45e7c0d1d802be8343f640",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "85b0fc74189f9025949990fc3fe36402",
"main.dart.js_1.part.js": "f629fc9aa31a05a8a3b32badf76715e1",
"main.dart.js_298.part.js": "81b62387fa1dba6c4ce76c18021d52e9",
"main.dart.js_261.part.js": "8aa9d16b4d97015faddf4a0eb520e320",
"main.dart.js_320.part.js": "f28000ae81075c016122312e30e9080d",
"main.dart.js_313.part.js": "ed7409d84a9509e09d947e89ab4a31f9",
"main.dart.js_213.part.js": "858950e75292acf3ca8bc3567f525be0",
"assets/NOTICES": "d6602568d747efa2852298f32b50d642",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "dccb1bf84d6a80a792499ba3f642aa42",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "185b66f5edd56836b0dc48788a3fb950",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "9cc068dd676b34bb02e49937494e1d3a",
"main.dart.js_242.part.js": "b7a8f4851e0c2bb1e0375f1603b20e87",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "58cdbfc73a550118e5183ced5a517d1e",
"main.dart.js_321.part.js": "6728a3c1b9df3776712ec4fc696e2d07",
"main.dart.js_286.part.js": "ba7b3b0dfa28f465839d62f6dbc9d946",
"main.dart.js_268.part.js": "5e3d7f74181da3b6f87f70b777f8d0f1",
"main.dart.js_255.part.js": "1cb37556d858589e0514e18319305d3e",
"main.dart.js_278.part.js": "e7e8323e4b25402bac4feaade60063a9",
"main.dart.js_323.part.js": "e6001748acf9d956b10570cbda763dd1",
"main.dart.js_299.part.js": "4a7cdef9d5a0d163e68a15d3b8ec60c5",
"main.dart.js_16.part.js": "dd04fc87fc719b427f0ebbd4bd597706",
"main.dart.js_236.part.js": "6205b77e0c11c8be30ef159e20d0af50",
"main.dart.js_322.part.js": "71c4e9ce1b65afabfbc9dcb619fdd70b",
"main.dart.js_245.part.js": "c70f469404feebfd76eb572533a28024",
"main.dart.js_285.part.js": "a0ca488cdf8b6764d5d5d251e6e1bfbe",
"main.dart.js_295.part.js": "4be8f922e1f0a839f39a0b06e19f7743",
"main.dart.js_312.part.js": "99623dd7303c8ef5dec48fb2d9eb2743",
"main.dart.js_307.part.js": "607b0d8dd8daae275a95cac58b0c72c6",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "30e3e42bed07f4e5f8b4b3b89eed3ecc",
"/": "30e3e42bed07f4e5f8b4b3b89eed3ecc",
"main.dart.js_225.part.js": "96a62d93928cae70d61ef2c3abe92fb5",
"main.dart.js_306.part.js": "dc55b1b8e9c89e27c2045138f0a48044",
"main.dart.js_317.part.js": "ec364dfd70bb98d0b04f97bc192996a7"};
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
