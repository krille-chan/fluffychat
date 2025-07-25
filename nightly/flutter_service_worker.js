'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "31d18f57cff2ce52fba83316a09f5e1a",
"main.dart.js_268.part.js": "4f77069064c4ccd6c76acf7a49e2b3ab",
"main.dart.js_304.part.js": "50d0af4adf61e0562e33f8985b7cfa7d",
"main.dart.js_229.part.js": "74c7ab658f3b8afd01a06a903fec883e",
"main.dart.js_256.part.js": "88dee2d2541f3eed2acdee679327d8a1",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "4072a8aac321535c480a0e5d77c25c2d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "1a5328e33fe6f50330580826d3c748df",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "b9b2ab6a07cc30a7a94b01d30c786b3b",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_211.part.js": "bb5fb95382d59fe8a58474c92f74b858",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_302.part.js": "63309156da48def2c2b31dc6b8aed73b",
"main.dart.js_320.part.js": "e48c40a35f20915fdb59a96bf292eaa7",
"main.dart.js_321.part.js": "26c9424c7686a5b207541bd05c7423c2",
"main.dart.js_255.part.js": "e512d5a8b0ad77b8be07e7c5683d5080",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_315.part.js": "7bde8b06f335a964e1ba70a17db7c5b5",
"main.dart.js_300.part.js": "e7eee0bcc4dfa6320d2b090e0eddee76",
"main.dart.js_309.part.js": "8da5fd9ebc85f1a2e46e3b7dd68168c9",
"main.dart.js_228.part.js": "90aa68389fb5e89e05a7c0e4968ad3cb",
"main.dart.js_296.part.js": "0da6f5e3e280aa742e2d45c9d0ed038d",
"main.dart.js_246.part.js": "375043252a438a182a5a74a3b6be42eb",
"main.dart.js_270.part.js": "9f2a44dfb2b6f837ae56b972a015ce1b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "aedff29a9f9d87faace5ea0aaeefbc87",
"main.dart.js_227.part.js": "93e33ec116718c15a528f183234bca7f",
"main.dart.js_254.part.js": "14448784071d09c8d25f5aba9baf63e7",
"main.dart.js_289.part.js": "b1b4abc3e77b343e3714f35e4755714d",
"main.dart.js_279.part.js": "e11952695cc1672cbdca824a7e141843",
"flutter_bootstrap.js": "862cf5a6fe33715fa26be50a153e1b95",
"main.dart.js_264.part.js": "9a384a1275b8f7fd2f324a48aaa99505",
"main.dart.js_319.part.js": "9d647b82e74b9b6fdb4f5cda05e1edd9",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_214.part.js": "6f3759950e83fee72620d30e92e382c8",
"main.dart.js_294.part.js": "c2a8a723e15e7b179ad4819af1fa1edc",
"main.dart.js_323.part.js": "9a001c661ed9b34aa7a9e60708beadc6",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "faf161c72464c9e06d948331969acfab",
"main.dart.js_324.part.js": "03f6031fb71736195f8efb201acb9c4b",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "a3b0643ee8a9004fca217118b6add385",
"/": "a3b0643ee8a9004fca217118b6add385",
"main.dart.js_299.part.js": "0df97b9132dc579af43ff5f84ad21932",
"main.dart.js_243.part.js": "2840f477cd1b21c5a0223f0a8ecde16e",
"main.dart.js_301.part.js": "842ed89dd1981f6cfc44c64bad0e1015",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "fc5872b8ca3aac418ff3c79b91f0902d",
"main.dart.js_317.part.js": "def1d4d3c7b1aca884933306b8b532a4",
"main.dart.js_286.part.js": "18aeacd885954bc5c1ad0119173d6b41",
"main.dart.js_275.part.js": "3226cd567f4765a49f900ac40cdfea69",
"main.dart.js_307.part.js": "d5f39fab813019b2806f734f45ecea32",
"main.dart.js_266.part.js": "c6f44b5f94777e1de83292d67646127c",
"main.dart.js_269.part.js": "8d8723dea1ca5ef482e205214523cb75",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_287.part.js": "166e0a21407a57417f52ca21af743dbe",
"main.dart.js_237.part.js": "c3e0ce3e3420a3a2b8a4a52b3737202f",
"main.dart.js_303.part.js": "b4ab519bbe3b52b6e3a4d42ff0ca35a0",
"main.dart.js_1.part.js": "5e5e56715088197b1388946b2d4d6aef",
"main.dart.js_258.part.js": "b96e84102954611dac1d32029bbf1091",
"main.dart.js_313.part.js": "354a69ecc3992185b6dd40ed98e99323",
"main.dart.js_318.part.js": "e40a826da0a877a5ae29c26d25fe5e8e",
"main.dart.js_314.part.js": "783d2ba30f4dd559be5f2ae62eca0aef",
"main.dart.js_274.part.js": "072f84bde8a92baa3bd39c45568de342",
"main.dart.js_262.part.js": "338811c0bd7d2b3ca54a1d578da16f76",
"main.dart.js_278.part.js": "3820d36813ec0c0dd62b03b2bcb97e54",
"main.dart.js": "57e3ae5a2360a97616b36b6290863245",
"main.dart.js_280.part.js": "36bb66213d0f4b7fb2c294f6523956ef"};
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
