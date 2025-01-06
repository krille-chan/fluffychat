'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_289.part.js": "d033dd59e637557f0dc2e49767233c24",
"main.dart.js_254.part.js": "a3e003c96a3e056d6be0e69b7f055f76",
"main.dart.js_285.part.js": "2101a9b25372e2955e615bdab0a0ac15",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_287.part.js": "2c649c1e05836bc49d349dcd5839c9c9",
"main.dart.js_282.part.js": "5d2fcf9428ee3c84d2e5a832cb7aef9c",
"main.dart.js_246.part.js": "14ac58c4255fa6a00e0bba616d60c263",
"main.dart.js_266.part.js": "eb8985af023af1cdacd15a9f9146e13a",
"main.dart.js_274.part.js": "631f2a187d41ae52dbd5c2a95004f010",
"main.dart.js_200.part.js": "dccb9a91193a4a666f283c6fbab1c302",
"main.dart.js_208.part.js": "dd9cc7a68090395aed2149d49d3930be",
"main.dart.js_273.part.js": "7fe8c8e169d46ac593902bc35b99bf9d",
"main.dart.js": "74ae177d02cde255cdfeb195288ebacc",
"main.dart.js_222.part.js": "d24c0ec02d8e307e50e9cbe058978ec6",
"main.dart.js_270.part.js": "1ff2c85ea77702e61e3f64cf47d75145",
"main.dart.js_275.part.js": "00a7fd98f9f762d283027fbc5ce93ff4",
"main.dart.js_269.part.js": "410336d9aabf6397debcf2cb66e45c96",
"main.dart.js_247.part.js": "17e92435f9c16f8f9ce40793aa01ddf4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "9afeb8627ec2db3e8c103ba3fee8e83f",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/NOTICES": "ad0bae227833957d26c4c04efb3df256",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "341b122113248d15c16dff08b1bd5047",
"assets/AssetManifest.bin.json": "a501696bd1e234d2a7b0f016d4994600",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "bda637401e75cb4cdbbd16d98cc9ca8d",
"main.dart.js_241.part.js": "f550db609330641190b628d43561e6b1",
"main.dart.js_268.part.js": "ff36acb00182489bbc65e735f01d2060",
"main.dart.js_198.part.js": "1873c692a87d5d58b440098e917060b1",
"main.dart.js_280.part.js": "9a1fc55ee5beaded3d0becdeadb29e7d",
"main.dart.js_242.part.js": "65d6d8539de8355c63d442e4730b5cd9",
"index.html": "20d83de9d2f26c687541c6ed4b608940",
"/": "20d83de9d2f26c687541c6ed4b608940",
"main.dart.js_235.part.js": "3947d00a846524ffa4861a25119ec0c6",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"main.dart.js_286.part.js": "a8a55867d45a2bc33102432d06a4078f",
"main.dart.js_262.part.js": "1f989a61db54ee74123247c76bb364e4",
"main.dart.js_214.part.js": "6befbee96e0e96a6c614e52d0315fe48",
"main.dart.js_1.part.js": "bb0ec6c210d590482ed3ec8da6d30c7a",
"main.dart.js_281.part.js": "2c3a4ed52146ba512ed492cedf2a9911",
"main.dart.js_276.part.js": "0f91acbd6d717f6b81a7c59d9970b5a8",
"main.dart.js_237.part.js": "3f684a24e063a3abbd2e381f2da8137a",
"main.dart.js_231.part.js": "5b0e7a60b70efa3667acfe5468306cf8",
"main.dart.js_2.part.js": "4a54c534cd77b2bda761fc11ac4e629c",
"main.dart.js_284.part.js": "56b7d339775723e3e9900da4cd7ee433",
"main.dart.js_255.part.js": "495256afbd96acfe9db3ca4df4eb28da",
"main.dart.js_257.part.js": "2d6401152770e92afe00962d271077bd",
"main.dart.js_199.part.js": "b8eaf5b8081e9f874576180332877658",
"main.dart.js_238.part.js": "20361e1d3d4918f0fdba3224486e9e36",
"main.dart.js_248.part.js": "2dd2bcef8055f9c66717d4755b27caa3",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_185.part.js": "89dc7e2e054863b5622f93e93e8884e2",
"main.dart.js_233.part.js": "8ae65a700dcec9e87b749732b0c4e8a6",
"main.dart.js_267.part.js": "28d6addc095fbf4bfba0b618e01b73b2",
"main.dart.js_271.part.js": "b097a2290a7f5ecd9f7c81f26ba2692a",
"main.dart.js_236.part.js": "abe20d096efd1e717b687f3c361fecbe",
"main.dart.js_224.part.js": "6a0f77bbaa9b419f4e889cc29d027d4d",
"main.dart.js_223.part.js": "58aabed49a1c5daeee44ffff7122fba5",
"main.dart.js_226.part.js": "040d2d9f82588c6601a4eeabdf978687",
"main.dart.js_14.part.js": "d2352aecff44c60cd06185f73a43c050",
"main.dart.js_187.part.js": "c9d9df8fbe952583c2e30a9802348dcf",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"main.dart.js_264.part.js": "5be4bcaea6306feae5f5b090c2cd719c",
"flutter_bootstrap.js": "9853b4dbce385927d57c1a8526e2a31b"};
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
