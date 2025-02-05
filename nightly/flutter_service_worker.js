'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_199.part.js": "b7483b34e63243c57f996f182567798e",
"main.dart.js_266.part.js": "92ae3960f7077f261f5ee7d3e8296a05",
"main.dart.js_270.part.js": "4eafe2c162a3f757fbb5438b2bb9e071",
"main.dart.js_237.part.js": "662f07d57b7e8fb5d4c16e396599846c",
"main.dart.js_198.part.js": "db0f869da0741830e3a3b4cbf11712a6",
"main.dart.js_268.part.js": "4b8f39e56b4a93ff92982e9ebdad49d2",
"main.dart.js_257.part.js": "d59b551bea5fbe3391206e4d38efdae1",
"main.dart.js_238.part.js": "bcddc69b3dfadf6f803b72a943f8d7be",
"main.dart.js_241.part.js": "15e2d81bb592b87f740cff0308578b08",
"main.dart.js_287.part.js": "c8ad12a1d4d3b3d5d0563211cff08eff",
"main.dart.js_254.part.js": "181671c2cda4d209a39976b38cca0732",
"main.dart.js_288.part.js": "0e9718c27e2ff30ddd6f23c319545740",
"main.dart.js_208.part.js": "a1cdf229abb7f3c7b0a5a49335fbd2a3",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "bea8334a52366685e341e39c1c3999da",
"main.dart.js_284.part.js": "2f946a9aecb62b2d588b85f1ff237686",
"main.dart.js_187.part.js": "517431a2086bb346e29e77b66f674cea",
"main.dart.js_214.part.js": "fb4e90410ee1362c8a7dfcb318b517a3",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_233.part.js": "23ffc15b15e56d374e583a1ff4842400",
"main.dart.js_267.part.js": "ded7cb22a9a6f5f74b1df0c9b093efd8",
"main.dart.js_248.part.js": "60c7fe67d2bf0468233c2ff0d0857ca6",
"main.dart.js_262.part.js": "32b5031bfe81a753d615c480cec98b87",
"main.dart.js_222.part.js": "d3d8e221be9830380ee94e4585061bbb",
"main.dart.js_255.part.js": "336e3cfe94aac9199367971544cfea38",
"main.dart.js_247.part.js": "9347a1606801c10890574b128c93b5c7",
"main.dart.js_286.part.js": "517883abe66dea373a1915837e603b3d",
"main.dart.js_275.part.js": "cac579d6979e0a883c2e76bbac11d9c0",
"main.dart.js_282.part.js": "808b0307963c6afc24f2b37d5170642b",
"main.dart.js_276.part.js": "990665791aa9769aca87848b882d7325",
"main.dart.js_14.part.js": "694b7f4b4088066778ed47e5e274e013",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "4273c51e3fd05c0e37c1d17a34560e21",
"main.dart.js_236.part.js": "3d92add118196b36cc9808f1adae1ff8",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "cb8a143517d531f4de85e5e011784898",
"main.dart.js_235.part.js": "3eb0540be6769792ecd5e6b0a96b3d16",
"main.dart.js_264.part.js": "cd900b71a24ae4c155a38f4c9fa8932b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "d53d25de0cea31378d7736eb1f4892af",
"main.dart.js_285.part.js": "094ccb79b7d743e7518dce8732d645d3",
"main.dart.js_224.part.js": "4de91118dd1dd6481982dc85fbc3dcf9",
"main.dart.js_226.part.js": "dbad8da087c7020e6422fbffb44e69a2",
"main.dart.js_274.part.js": "1ff9fd82f38939be74a18357e9bd69ff",
"main.dart.js_289.part.js": "2953187393ca451dbe29b57f1fcefcd7",
"main.dart.js_280.part.js": "ebae619b37bf765f8b7fe875cf6590fb",
"main.dart.js_231.part.js": "8dfd071b01f385e64b129ad919b8f748",
"main.dart.js": "308637b2b50d40aec0eae3e890298888",
"main.dart.js_2.part.js": "81a750809dd1fb2b074db9c419829e66",
"main.dart.js_273.part.js": "cc8628bc93e79e1642d0ec40c10b93bb",
"main.dart.js_281.part.js": "d1b75505da81058977c3dfa877d4038f",
"index.html": "eac99c7e2f91f7478b517be7d271fab4",
"/": "eac99c7e2f91f7478b517be7d271fab4",
"main.dart.js_271.part.js": "4d7825841281ced525f783f1cc482412",
"main.dart.js_200.part.js": "5a3a84ea14b08948bae2e4af4bb0dacf",
"main.dart.js_1.part.js": "235b49975f41602fc9d5254721783584",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/MaterialIcons-Regular.otf": "56c8c0b2224c70b4ae11109ad3dc15b6",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"assets/NOTICES": "224ebdd6c0f86e1033d76c5e74cd4ff5",
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
"main.dart.js_185.part.js": "96952b707d5f1dfd66ffdfa94575cf3f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "ad3dc9d52e65ddeacbdc9d7de724bb46",
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
