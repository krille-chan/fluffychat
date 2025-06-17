'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_190.part.js": "801f4a902e881ab3c4192294e3e512f7",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_249.part.js": "81a75f3c2521596ccb23936860528b78",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "e65220e9dd77655660ee2cdb594435d7",
"main.dart.js_274.part.js": "7b8a8f5ed96bbfeb974af2aadc14ac14",
"main.dart.js_219.part.js": "96cf372dac4ea40c6435e7915c838dbe",
"main.dart.js_205.part.js": "0965c91cb2c084afd573efe6e8414b7d",
"main.dart.js_276.part.js": "515bfcd63470ead44779e71fdc9ff8e6",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "75eb97fca127f5992ccddce49107ff79",
"main.dart.js_262.part.js": "102c5356835ace4c452b8e7de94041ea",
"main.dart.js_1.part.js": "d7d271abcab9187cc0a598462dff1d1f",
"main.dart.js_243.part.js": "171285cd78fdc204fc4b8e4ba7847a6c",
"main.dart.js_275.part.js": "97fbb7923573fb8bb9e93bf6c836250e",
"main.dart.js_231.part.js": "1262415817862843d86e05d445a1e2d2",
"main.dart.js_269.part.js": "ea9561b369fe13e03862c0810405fb57",
"main.dart.js_298.part.js": "67ec0a78dd25d688805ee7996c4bf725",
"main.dart.js_240.part.js": "8b8b20965c64545489ddc57f3cc81e6c",
"main.dart.js_242.part.js": "49ad3447b1303472719702b22dc973f2",
"main.dart.js_283.part.js": "9a2b5447f9327cd909cf665097ecb8e3",
"main.dart.js_293.part.js": "adc300e864b103bfbb89bedac94a5212",
"main.dart.js_277.part.js": "b0b0aaa59e58575d06eff53384558dc6",
"main.dart.js_213.part.js": "648463718ec687d696aef4eeeb93367b",
"main.dart.js_248.part.js": "19b0d750637b1d0143f56160f572921c",
"main.dart.js_289.part.js": "908a767e9e94a3da615be8c4f91e6e7e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "47fcff284f4b42ce3a0a9df8e0a61862",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e3c4ff4cebe742cd5e83688287a0447a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_204.part.js": "b502fa4d9f1da1fe2dac775f4801de2a",
"main.dart.js_297.part.js": "27e8ae84068ed3d321c15b4dabdac63d",
"main.dart.js_192.part.js": "d135723c8947e73dab4e2aed7cb0bfc4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_282.part.js": "4382e6ba74ea20e62e1a635d99b78a9a",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "dc12d942f9323451dad73e42fdc71855",
"main.dart.js_230.part.js": "d40bc6828579e5814b2d71e295d46905",
"main.dart.js_238.part.js": "0471ab4dbc282312d69e29aa12d5e4bc",
"main.dart.js_253.part.js": "c6e36f26a70fcd786fd8bce7069210a3",
"main.dart.js_244.part.js": "973d07147f85148be690ace10a349479",
"main.dart.js_16.part.js": "658a9080f3ab089f154c88a3797e6da0",
"main.dart.js_294.part.js": "6d61ed96a82bce04c4c995ead3bd72d8",
"index.html": "0910288e87319e2403f37c62246e48b0",
"/": "0910288e87319e2403f37c62246e48b0",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "6d97f3db7fc73bde523e7aeac189e7bc",
"main.dart.js_245.part.js": "61f41acb023882742d828346d95a8caf",
"main.dart.js_291.part.js": "61d397a624d01afddc8ce2b571aa3d0f",
"main.dart.js_287.part.js": "d7ca9e3e1614f5dc88931e3836a223b4",
"main.dart.js_233.part.js": "48024acb9d43d39375933a116db42bfa",
"main.dart.js_273.part.js": "b69ad8e99b05ef53c56ce6bbd9c3c15c",
"main.dart.js_296.part.js": "8fb21f2e16ae417598ecbfa9d4c3cc17",
"main.dart.js_278.part.js": "f4b0a2daa9edab1591278272f217442c",
"main.dart.js_292.part.js": "2756d86b73331e8cf01ecc9092d34a7a",
"main.dart.js_295.part.js": "15f4bad5b082e0d3d7ca23cc6ecc7950",
"main.dart.js_221.part.js": "46541f6382ca9a0caec5623fdd7e25f5",
"main.dart.js_288.part.js": "5fdc4352af010762e5a45e4fa59e5a06",
"main.dart.js": "05fbffa1b98c4691df65179746091182",
"main.dart.js_280.part.js": "87bb7a36aa255ab66be644161d670522",
"main.dart.js_261.part.js": "1387e654017a1336a45d23b7abb2c342",
"main.dart.js_203.part.js": "5103c446381e37a2aa99399defa15510",
"main.dart.js_254.part.js": "cec0fddcf6543cf74a249971cb16833f",
"main.dart.js_271.part.js": "a01c4eb3cf1db3ec103c112744b24f63",
"main.dart.js_281.part.js": "f458805324182dde0bc5853d1a0aa0b4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
