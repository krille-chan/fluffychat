'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_230.part.js": "788aa0058df5bfd9edb7d01f95c0a2ee",
"main.dart.js_276.part.js": "4cd2ebce8308530c1a880129c16bbe44",
"main.dart.js_274.part.js": "db3007ee1eb36a6d601056f086575755",
"main.dart.js_292.part.js": "4dee9aaf6c6cb58163fd7ef3215245f3",
"main.dart.js_286.part.js": "5ddc39aa7a094d6b45e6a5b4cd076c47",
"main.dart.js_239.part.js": "f8cdcf068fa5d86d1c948045062c82c8",
"main.dart.js_263.part.js": "5b459f0cd53f64c6d9ec57579199daa0",
"main.dart.js_203.part.js": "51c1b9c7362f780e983a207ff1f3f830",
"main.dart.js_232.part.js": "bd280ee1facfe1c86fbb38f4782c82f1",
"main.dart.js_243.part.js": "550cda20e86ded710d63d9b171b2eec5",
"main.dart.js_248.part.js": "b84ea7a2677873526876a45cc16b36e4",
"main.dart.js_275.part.js": "2420adf5d3a309262738d43a28eabb60",
"main.dart.js_296.part.js": "f026cba2c9f206d6a60e60043644022a",
"main.dart.js_212.part.js": "727702f0289bfb7757f7ad2699752c9c",
"main.dart.js_189.part.js": "dd6cdebba6e1071a2d0c409dadc6a79a",
"main.dart.js_242.part.js": "e2da8d993c84852e5d32188bd1ff4c84",
"main.dart.js_241.part.js": "f850cbeefdede05c82578539c9b0d7ed",
"main.dart.js_1.part.js": "715bdce548bf16817d26805e8be21f1b",
"main.dart.js_252.part.js": "a74b622b28f210890072e877e3d79859",
"main.dart.js_16.part.js": "a64d9c883e2269cb2437bbbffd076d6c",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "fb5539f35a59ca32db739baead860c9e",
"main.dart.js_220.part.js": "c7fb10924639542ccc031ddd78553359",
"main.dart.js_253.part.js": "e5d3f393d12e68ec58eca24a8015ba30",
"main.dart.js_218.part.js": "45c5fadbb9cf8048ed271fb86154a933",
"main.dart.js_204.part.js": "177f74487fde9c7b39bfbc94570d788d",
"main.dart.js_287.part.js": "c14871355e7cc2d0a85c5e95b44c78e8",
"assets/fonts/MaterialIcons-Regular.otf": "0f73bdbc3eb9e9032a2a319f3942ff0a",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "36c340b7a481c275b1bb7accf3ff8bfe",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e3c4ff4cebe742cd5e83688287a0447a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"main.dart.js": "48545cc6f9ee8c038cf61ee5c38952e6",
"main.dart.js_254.part.js": "3f8ec8b8a11b7850bb9dfcc0285237ce",
"main.dart.js_273.part.js": "2d430ade9d709e9b5500d68f4f1fb236",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_268.part.js": "26d0fb75fe190bd2b73a30415befaa83",
"version.json": "862de28dd61d480a6b68d3d8cf190d73",
"main.dart.js_295.part.js": "f4f09cc76d347bf3cf8a2bbef8e2d724",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"main.dart.js_281.part.js": "34fd74e3f816287f9a190e9887e78e61",
"main.dart.js_282.part.js": "27c7b45aafc10b7877b4b98829cf0c5e",
"main.dart.js_279.part.js": "50c8beae6839ab49671a21cb5ff7d6f9",
"main.dart.js_191.part.js": "6415f1b15dc8ea63601d1203d07599c0",
"main.dart.js_293.part.js": "6d50862aba307501d39c21b17a4d3d12",
"main.dart.js_202.part.js": "122f2056801dd1ea8e94d181288d49c0",
"main.dart.js_297.part.js": "f210495f9d4fd0c06a008b6cd2a27820",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "d1dae1041ddd28b5b2fa3f58153399ff",
"main.dart.js_270.part.js": "946c220a3b00ff9a50f249912f2dcb79",
"main.dart.js_280.part.js": "1838dde4b16731ddaaf3c87dd5ea6d2b",
"main.dart.js_288.part.js": "d037e873ee4f5647b7654294cc020d49",
"main.dart.js_237.part.js": "a983a25898c321535f918e0e4c306ece",
"main.dart.js_228.part.js": "1ae52f67a1023c9fc8c6f469465dbd3a",
"main.dart.js_277.part.js": "9c9715bb826232e4508976da383fb3af",
"flutter_bootstrap.js": "081e3ce33014082b00fa25c0234567e0",
"main.dart.js_247.part.js": "05c63ff756db8039fcd412ba0dd3c731",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_291.part.js": "8e98cc11392edea7359c5be6cad94bbd",
"main.dart.js_260.part.js": "670935535c4de59461d9cd48c8d0db40",
"main.dart.js_244.part.js": "69c5510e1a58aaf86a84ff23daeb0350",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "cee42233abe3e8aa13ac0044a33e5069",
"index.html": "29f41c08dc6f1f135640c0e1c768d849",
"/": "29f41c08dc6f1f135640c0e1c768d849",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_272.part.js": "7e22721bb0a9f5aaadf593d865d8c0ca",
"main.dart.js_261.part.js": "62ae0858be39042baa159682320ebb6a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd"};
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
