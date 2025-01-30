'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_199.part.js": "329e3311935f6e80c42e2350ef8b2086",
"main.dart.js_266.part.js": "d75f23baf7fb996bb58c3aa9b7e2d8ca",
"main.dart.js_270.part.js": "8ba914e11518a7487e99663554b1a6b5",
"main.dart.js_237.part.js": "2e48d84772428175b5af0fa70b4339b2",
"main.dart.js_198.part.js": "253de033f7f2190c3cd81fd062f6d1e5",
"main.dart.js_268.part.js": "9c69304e7ef5ffc2f042f6e5b2105023",
"main.dart.js_257.part.js": "93c6096dac717fd2cfc3485ba4e70657",
"main.dart.js_238.part.js": "09701af877e1af404a0d61a91fbe7175",
"main.dart.js_241.part.js": "d6668fe6feb2ba17e2105a6c4039b140",
"main.dart.js_287.part.js": "13e6f8051243e301aafd55b9072d15fd",
"main.dart.js_254.part.js": "f7dd3a2d63fa34c90cd7262206d386e7",
"main.dart.js_288.part.js": "43c9a6db203c18e66331e6d4973667b9",
"main.dart.js_208.part.js": "06809e2c22e8fcdf207212533d4568b5",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "97aaf49bfc016167b5ab36e69b54600d",
"main.dart.js_284.part.js": "6bdebd9ba8aa1a13435b286b310094b9",
"main.dart.js_187.part.js": "69ad3713fd91088ca858a5f03b20e04b",
"main.dart.js_214.part.js": "67f9423f0f1640fc3b12cbbc8687bd8b",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_233.part.js": "50846052d3bf493c5a4366fb6ddbc032",
"main.dart.js_267.part.js": "933d1af1ee6bc592b8590e415f99fd96",
"main.dart.js_248.part.js": "79ee6f4e33dfe840384f35015415f86d",
"main.dart.js_262.part.js": "14345b32ba7529d1a470ea6c71e693e2",
"main.dart.js_222.part.js": "722260fa7b2f14da00f0343eda8f6ad9",
"main.dart.js_255.part.js": "ece78e91ce193516aa00ce56f6fc5589",
"main.dart.js_247.part.js": "3b30b3b90557d6a8aa6fe0b16e048c55",
"main.dart.js_286.part.js": "5dd99bdc338a9f30481899ea7883aa80",
"main.dart.js_275.part.js": "d83acd9eae543ab1c664806fcca96b1a",
"main.dart.js_282.part.js": "228fd877644e79fdc106f99e3c17d401",
"main.dart.js_276.part.js": "af8f59191ca07b88ffb8fa67e56ea7cc",
"main.dart.js_14.part.js": "0bd066f193048e2907d3549439dc06de",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "077c3ff19e8e1eaf2679b85fc69fea47",
"main.dart.js_236.part.js": "e6f6ca22c97644f2ed0241189172ae3c",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "4c527a454b176dbb0c2022d4c23d276b",
"main.dart.js_235.part.js": "66db26760440b49833b9beacb33c188d",
"main.dart.js_264.part.js": "9e81460ea09f6fdf9c6e1f585d146f2f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "1a15da17c55c7dcc8a21846c6d0386bc",
"main.dart.js_285.part.js": "0abdda450fe0b15781fcd163bdd20163",
"main.dart.js_224.part.js": "dd916e4fffac49518461f3a98cb8ec5f",
"main.dart.js_226.part.js": "13a7cddfcd02975c3b6d47fe1536277e",
"main.dart.js_274.part.js": "9b17ca35a4924e24f331971e452704c5",
"main.dart.js_289.part.js": "7ed2ad4deb68f4559fd0c2490f31dce8",
"main.dart.js_280.part.js": "6d2724e591b992e8b3b3950174327f3a",
"main.dart.js_231.part.js": "917527b9326ab90f67465d8b603fa592",
"main.dart.js": "de8c63d12366247c32322c466fcf6c7e",
"main.dart.js_2.part.js": "4a54c534cd77b2bda761fc11ac4e629c",
"main.dart.js_273.part.js": "8c9863e90b04b1f60e59f8f5b2167906",
"main.dart.js_281.part.js": "24228e4b97fc811c598b927ee2bc1d8a",
"index.html": "4dabcf884b29a4221fc6c412d6d532ef",
"/": "4dabcf884b29a4221fc6c412d6d532ef",
"main.dart.js_271.part.js": "e33e6fb3123923b687ced86654382a7d",
"main.dart.js_200.part.js": "d3a67941ce9792bd184414bd8d243e46",
"main.dart.js_1.part.js": "d3a8afe91dc7f293d9bdeef1376cead6",
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
"main.dart.js_185.part.js": "aa72d669f6e957cb2a4b01f0e1f21eaa",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "f330a1d2a7e5e5530525de4433488390",
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
