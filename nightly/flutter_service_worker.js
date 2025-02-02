'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_199.part.js": "bdb2b3fe763448ed642e592102f097aa",
"main.dart.js_266.part.js": "18cdfde4acd45c8d848c34724294839d",
"main.dart.js_270.part.js": "c391e1abcce33da8fa1964ffb7e90bc0",
"main.dart.js_237.part.js": "05d62a6b60d57b05662dcff4e61b3db3",
"main.dart.js_198.part.js": "1ea6305efeb818f856cd5473d74b3795",
"main.dart.js_268.part.js": "145a6343dd9055ea3168ec071c2f0817",
"main.dart.js_257.part.js": "6862f432215ce3a5489070185939b547",
"main.dart.js_238.part.js": "566857da44a843f498ea83386f8a1df8",
"main.dart.js_241.part.js": "14508943ba2f3cfce89edd23cbc56f20",
"main.dart.js_287.part.js": "6b8e136e658e11f887060355f24b390c",
"main.dart.js_254.part.js": "8bf36459aaa77fedd86f822c98f6123a",
"main.dart.js_288.part.js": "28206b3997ea9e97a51c58656d9a7a6a",
"main.dart.js_208.part.js": "0b3d04d3d7a132bf67ab82934f465e14",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "c4bf56cafc90a6dc066676bca8a35851",
"main.dart.js_284.part.js": "40b70206641e6c388be52d57db9c7361",
"main.dart.js_187.part.js": "11ba8b00c704d782e53462c0bfd44950",
"main.dart.js_214.part.js": "3a0704543fb396a27b01b8c4f385b03c",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_233.part.js": "894c0f078225bc326916a7d5bf17b8ed",
"main.dart.js_267.part.js": "6c5b49a010934e3fff35b6d7a3fa7354",
"main.dart.js_248.part.js": "f228dcebb3cfaa574231fd2a53099e19",
"main.dart.js_262.part.js": "b1f9d9ed01d23dc9cf303817895a8e4e",
"main.dart.js_222.part.js": "bff2b2e1ccad5235b2ea4990c3a52abf",
"main.dart.js_255.part.js": "7991eee69d55bfe89d74846cc4d1c8b0",
"main.dart.js_247.part.js": "b3b0c53294de8d2d7b6896af0842f359",
"main.dart.js_286.part.js": "c2de1b39f2e5508ba9e86b4fe8196cd3",
"main.dart.js_275.part.js": "839e533f6c54a047847fd37205dd87f1",
"main.dart.js_282.part.js": "4d50b96ec2f9a559b826c7785c18a94f",
"main.dart.js_276.part.js": "dd4974145d89cfcd134b1688089b5a4d",
"main.dart.js_14.part.js": "fd5da041dfaffde8b0513811fd01bd36",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "4893419d435672fe502ae46cc3a97c3c",
"main.dart.js_236.part.js": "3016b5b77ab84d7eedf8961654e14cc6",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "1a7f21b1abc4da8d00dcae899291ee8b",
"main.dart.js_235.part.js": "81d73c8291e1843cad4d0a71dbad7623",
"main.dart.js_264.part.js": "c2ab3b2a5b7e06f19a49c780f754443f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "c6c434440eb8f0c44ef8203695ee63fc",
"main.dart.js_285.part.js": "147ede622c05fc05bfdefca325fecf3e",
"main.dart.js_224.part.js": "bebdd50dd8ae6d5e96e293a8c81f0818",
"main.dart.js_226.part.js": "b6f523bfc0c8048ea37f4640ebf0e733",
"main.dart.js_274.part.js": "bc7b9cc212cfd29a35fc67e64faa5f34",
"main.dart.js_289.part.js": "c63efcd8d9938b94604cca5fd44da942",
"main.dart.js_280.part.js": "f40735806827259cfd76bdec5f13867d",
"main.dart.js_231.part.js": "b00bfe58745856fe93c1fb1edfe19460",
"main.dart.js": "40a949f750b5c89c18030e921e17ccd6",
"main.dart.js_2.part.js": "4a54c534cd77b2bda761fc11ac4e629c",
"main.dart.js_273.part.js": "506dea3deeeee6a901bb11b4ab9fb2e1",
"main.dart.js_281.part.js": "3fd8638d1a96fc41bb6208bde6e3a884",
"index.html": "1e5b426ec5b1df82b9010c86f45190ed",
"/": "1e5b426ec5b1df82b9010c86f45190ed",
"main.dart.js_271.part.js": "0c9c95c576fb24fa4d3a348b38d79897",
"main.dart.js_200.part.js": "33e11ed34607a1f3b845fbdf61f9d75b",
"main.dart.js_1.part.js": "35fc30b9a1b3975331a067384ad891c0",
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
"main.dart.js_185.part.js": "654b886cb66ffc194f0c8f99e22e2e36",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "a1ea91fa171a58a4873f63fba06da502",
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
