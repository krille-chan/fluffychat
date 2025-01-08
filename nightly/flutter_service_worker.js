'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_280.part.js": "91a460642f065ffef20f6b6f8c8f188e",
"main.dart.js_275.part.js": "4baac235a802456b57d92eb453ca8b4e",
"main.dart.js_257.part.js": "15ac07b980606ccf15f1f9b0e55f494f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/NOTICES": "ad0bae227833957d26c4c04efb3df256",
"assets/AssetManifest.json": "341b122113248d15c16dff08b1bd5047",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/MaterialIcons-Regular.otf": "9afeb8627ec2db3e8c103ba3fee8e83f",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "a501696bd1e234d2a7b0f016d4994600",
"main.dart.js_185.part.js": "62da1e22a1aab2cea05749c15e37d8dd",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_248.part.js": "2e829780ccd72f799bb4167cf46b98be",
"main.dart.js_255.part.js": "0232559891eb88647361dbda78cab1d0",
"main.dart.js_222.part.js": "7e0d6d3c46608ec7d76fc18af46ccfd6",
"main.dart.js_208.part.js": "c7d37a1c841124d29227d00d602af075",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"main.dart.js_287.part.js": "f314aea41420dc947387f396197c9227",
"main.dart.js_273.part.js": "ab96a2ea09ba2244cadba7c35be846ff",
"main.dart.js_262.part.js": "2ce9debfbd13c71b8da86e81a8b317aa",
"main.dart.js_247.part.js": "d0d62d9561ffdabd0f733fcf2d0326e8",
"main.dart.js_285.part.js": "f9d73c169b1085706702ab03a2919f7f",
"main.dart.js_269.part.js": "e598b5a6261852ccb84aed1242a0b471",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_235.part.js": "8e50e37c3707fcc0243183df60cb8004",
"main.dart.js_286.part.js": "dd4df7a400fb1a084f3fcf5d991e8777",
"main.dart.js_223.part.js": "3e14eaef66df336c06f915fea47543aa",
"main.dart.js_238.part.js": "126c021002612c80228f3cbcef80a3b5",
"main.dart.js_2.part.js": "592b7682355010a6166e3d8e675136d4",
"main.dart.js_242.part.js": "44d8791b2b8a471ed30aab5bacded997",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_198.part.js": "2d67622e4d2e794400564ba5e972407b",
"main.dart.js_276.part.js": "102ab85c2399aa235f87101433fdb60d",
"main.dart.js_267.part.js": "e7d06f4a5963142e6e3da144e4c84514",
"main.dart.js_214.part.js": "5b073765f008f2a2f8a2d3e071b6dbd8",
"main.dart.js_266.part.js": "19908633fba88723da64ec14282e0198",
"main.dart.js_199.part.js": "19a6c5225fca6d6bcacad60d4a673ba1",
"index.html": "98b10711f0953a817f4d7078e9d81bed",
"/": "98b10711f0953a817f4d7078e9d81bed",
"main.dart.js_284.part.js": "98d7c206d39ef40e7963a90f7c9cdbb1",
"main.dart.js_187.part.js": "4ca2c2aed917b4c99278cb87689009c7",
"main.dart.js_1.part.js": "5f8b45ef2960f7b5672106ebc6ba5d40",
"main.dart.js_14.part.js": "c74b6fa261fe45f64db01014e272e8d2",
"main.dart.js_237.part.js": "d5b7c372e68e04e1dc19b6107362a2bc",
"main.dart.js_268.part.js": "751293c41501aec8458a6b1f19acd649",
"main.dart.js_282.part.js": "1ba76d8a48a4ed7a528170c867630406",
"main.dart.js_254.part.js": "122e31d66137256757aa52239a65cbcd",
"main.dart.js_231.part.js": "9f0cd7e794a8c2692ea4d716f034c043",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_270.part.js": "cd2925876f472a3d9e6805af73f21dee",
"main.dart.js_246.part.js": "3ab0318a3e0e698369cb69300842900a",
"main.dart.js_264.part.js": "f48e13cb0a55b6bfe90f0b4ed061aa1a",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_241.part.js": "8f4c2df10ef99d3469365bec53cc0762",
"main.dart.js_236.part.js": "fc699ad6beff513d199470d787a5279e",
"main.dart.js_233.part.js": "f9c460dd3b3a3f57f2911c1bbaf405e4",
"main.dart.js_271.part.js": "e83fc53dcf69e36220ba26e1e894e222",
"main.dart.js_200.part.js": "bca2b427ffe1c45ce53c67693844f699",
"main.dart.js_288.part.js": "1830261d9636dfd7adf47455ebaba2c2",
"flutter_bootstrap.js": "b32d2f5350f702cbec28e93bbac98298",
"main.dart.js_224.part.js": "7bdf3718f11467fd338357e86ab53f87",
"main.dart.js": "31a7064f376e7a44a78e12c411963b6b",
"main.dart.js_226.part.js": "0643fce150e2de30922c667676f8cdf5",
"main.dart.js_274.part.js": "a9c3e9dac7912cfd50bdfc5b891eade4",
"main.dart.js_289.part.js": "7839e5d1a4cb8b467b0656a0a0c8cd10",
"main.dart.js_281.part.js": "ac79a7642b6795ec33e8a5bded5db3cf"};
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
