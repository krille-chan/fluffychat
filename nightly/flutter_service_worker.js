'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_199.part.js": "28d923992b598d165b2d560798697e53",
"main.dart.js_266.part.js": "7f65ab1f7ebe238e4b8bc7249ceb0942",
"main.dart.js_270.part.js": "53b696a386915d0342da5f670b7114c3",
"main.dart.js_237.part.js": "9cf8b6c1f829fcf8cae85431ffa715c6",
"main.dart.js_198.part.js": "073d78e6206ff294fd3368da7340ba7a",
"main.dart.js_268.part.js": "75036609acc75ce1c393556eb79b8fdf",
"main.dart.js_257.part.js": "8bc33fb6b8acb27cd04d11d8bf12f30f",
"main.dart.js_238.part.js": "a37fb5f7df03a6b22fcafe41678b684b",
"main.dart.js_241.part.js": "84a8f04e64599bd17761c9de86431c3c",
"main.dart.js_287.part.js": "84b137c27c062301e7565864a18ce721",
"main.dart.js_254.part.js": "c6ae58672c48dde0ff0a07848a6df42f",
"main.dart.js_288.part.js": "e569def683bb6168afc77e84fb011aea",
"main.dart.js_208.part.js": "0eb226d6f5fc1bf190cb8adfef1eb5fb",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "7e3b6c5f70c0ebd3d7dda67e535cd76e",
"main.dart.js_284.part.js": "037b497d1990307269a615b8bd0370e3",
"main.dart.js_187.part.js": "6a65519c60cd71e3900b3e90410d0281",
"main.dart.js_214.part.js": "1570a10194e5e9f7b6d46cd064ff3373",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_233.part.js": "8562c39dfdaaddb25386b14ced15e06c",
"main.dart.js_267.part.js": "a1b8dfe08f43e9a3e3f0749facf375ff",
"main.dart.js_248.part.js": "22d8de9b4897d75e87c9ab704940cea7",
"main.dart.js_262.part.js": "0a42a0bcf8c679c4199e2d3b7ea7c0d0",
"main.dart.js_222.part.js": "565c7a7dc2dd78e1cca52acb4d75fcbd",
"main.dart.js_255.part.js": "0b23ae22cdec7d6983f8611c3919bd0b",
"main.dart.js_247.part.js": "0bf269a1e2adc60d0a44176e04415756",
"main.dart.js_286.part.js": "6804f76f68862bbb03930bf03b400dd8",
"main.dart.js_275.part.js": "e958147006529cc3e3b634238849fba1",
"main.dart.js_282.part.js": "27173ce40a0bce116783d5cc84bf827e",
"main.dart.js_276.part.js": "ec443c4f1cf5a13507cfb217f8cdcd56",
"main.dart.js_14.part.js": "c43480492654bc871e251d5d334e5eef",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "5502c72177b75352dcc7baa08faae9c5",
"main.dart.js_236.part.js": "81ef5f3d6a6829f431c90f96b6d3ca07",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "d8019d266a29b8fe79264f1fb89d0e0b",
"main.dart.js_235.part.js": "151536cdd2a14cedaaabc5f2c1889fd8",
"main.dart.js_264.part.js": "3422e0b12bfe320872f08d70f22d970a",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "0a7e640c2398d0ae66424ad380db0f88",
"main.dart.js_285.part.js": "167980ab67e73f8c21aa3b5aafc69fce",
"main.dart.js_224.part.js": "82e5e4689cafe2bc85f00a3f830d5263",
"main.dart.js_226.part.js": "17f96befa5589d6bc59c090ef440a362",
"main.dart.js_274.part.js": "5f1e1f1ee186c93d7eb16de138be7f0c",
"main.dart.js_289.part.js": "9b37d3725613ec0614a6f53084ccafbd",
"main.dart.js_280.part.js": "7b88c3a0918b1d5430c1355cfb763ae7",
"main.dart.js_231.part.js": "0f75cd144a727eb27fd9b1ebef6f9ffc",
"main.dart.js": "78f7a78b92ef4d5d46379dca19823f5a",
"main.dart.js_2.part.js": "af02e2d10ef640a42c01f8f5b752e16a",
"main.dart.js_273.part.js": "0910ba30da499642e3e49f3bcc626275",
"main.dart.js_281.part.js": "8e711053bbc845c6ddb3523c1881a01f",
"index.html": "fc2992ae65670fe5de262f4d730dd47a",
"/": "fc2992ae65670fe5de262f4d730dd47a",
"main.dart.js_271.part.js": "af122e1609f404d2cb0dbbd4adf15fbd",
"main.dart.js_200.part.js": "2ec7cc0d5960513bb0185133b49812e4",
"main.dart.js_1.part.js": "0981a6dbf8c888d20b46c5ed93e7c2bf",
"assets/AssetManifest.json": "341b122113248d15c16dff08b1bd5047",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "9afeb8627ec2db3e8c103ba3fee8e83f",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/AssetManifest.bin.json": "a501696bd1e234d2a7b0f016d4994600",
"assets/NOTICES": "ad0bae227833957d26c4c04efb3df256",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"main.dart.js_185.part.js": "56c0ef12b1f8fc597d7ffda42c139b79",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "f471abf839b5e1743e51f1b9e038fce2",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
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
