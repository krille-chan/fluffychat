'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_244.part.js": "af403bfd22cd6b437adccc85e2968244",
"main.dart.js_254.part.js": "4d0c88c2d1c198e5503f7a179fc02761",
"main.dart.js_245.part.js": "3f9f045ea60400af97a3f724a2e174bd",
"main.dart.js_285.part.js": "3bc81d67f66837549dc3fba655919ba3",
"main.dart.js_251.part.js": "815bd63ed5345272a6f6d54a0e0307f9",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_230.part.js": "6e9b3a1d8f18062635825e89507430c7",
"main.dart.js_283.part.js": "b2ebbe19c5598339e108841c2af220b8",
"main.dart.js_282.part.js": "e9f2383809406debb1f680e80a38f8b3",
"main.dart.js_239.part.js": "0c5cf1904f2b8e62cf2c7a140a873873",
"main.dart.js_266.part.js": "d43ecf24b39c56533f77d1c649383982",
"main.dart.js_265.part.js": "27678c570d983186709cfa4e74ee147e",
"main.dart.js_273.part.js": "c4720976cd9817a014238134fb693f68",
"main.dart.js_259.part.js": "37667a4d3dc300bd3d399deaead248ae",
"main.dart.js_278.part.js": "d0b6133f487a3768523e73f5847ed2e7",
"main.dart.js": "837795a7760a50062d377970d820776a",
"main.dart.js_232.part.js": "08d62e58694950d54e40886b925c86ba",
"main.dart.js_196.part.js": "169b6ce54e9924a17c2f82a9fcc4d211",
"main.dart.js_270.part.js": "ab3408f558198d95f72ea663697fcb84",
"main.dart.js_183.part.js": "8e21b05b42daac4ad5d936db4dd23df3",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "52986a9e1d69ad779d02334a06b33a81",
"main.dart.js_228.part.js": "4d796a5cf90b2fd1c7c034bb87304aaa",
"main.dart.js_219.part.js": "8d4f2fa1e1e6f63a40cef10924d07fb4",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "658dc0657afef16e02dc425eabef1b65",
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
"main.dart.js_263.part.js": "26e3acc2f2a779f598cfff82d2fc77ce",
"main.dart.js_220.part.js": "0455123482ef824ab29792a7bdd37e03",
"main.dart.js_268.part.js": "d436c7b9b1eda49197757c370e89e7d5",
"main.dart.js_198.part.js": "c88f320b787ca1ae4a29ac4c7dabe2ea",
"main.dart.js_272.part.js": "3498888bd1769d33501e6235303117cf",
"index.html": "85b65284002b599269fcbe32eea7629f",
"/": "85b65284002b599269fcbe32eea7629f",
"main.dart.js_235.part.js": "5a3b0346ab718960c7c75b3c3bdf10c9",
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
"main.dart.js_286.part.js": "d131d77d069c9cfebca017a46396da04",
"main.dart.js_1.part.js": "63215af4c121acd3323c465f8b8b45c3",
"main.dart.js_211.part.js": "897da6a58cc757f2c5504c12b38032a5",
"main.dart.js_261.part.js": "1fe02728f681c30884d51d2096f5cc73",
"main.dart.js_281.part.js": "6b5cd9788679c50c5f620cd054f58999",
"main.dart.js_221.part.js": "36c01fa4bd7f706c985ef383d02f5c17",
"main.dart.js_206.part.js": "d52eff3aa8f854743d55d31e368f094c",
"main.dart.js_234.part.js": "aeef97d4224bd2802d6be448b9924da3",
"main.dart.js_2.part.js": "70e16fd226db202aa247620f982bbc15",
"main.dart.js_284.part.js": "071c661ea78f188dd4b86dace852f7a0",
"main.dart.js_238.part.js": "de31750c164163cc862cbb5ce09b2aa4",
"main.dart.js_197.part.js": "3c6129c08f975a1cc3c6daab610bc515",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_243.part.js": "b14bebf81b636e176c3738cae8f716d8",
"main.dart.js_185.part.js": "aca3319f58d8d9ac2c1479f65b6ad090",
"main.dart.js_252.part.js": "5054f4d63b2f53ae2fd48c27f2d38283",
"main.dart.js_233.part.js": "4a71da89b0f5888de48eab33a38355ed",
"main.dart.js_279.part.js": "2e1a3eb2daa5d710584bc55063816170",
"main.dart.js_267.part.js": "4e5a1ae26b0f0567e6e72bb501f5efb2",
"main.dart.js_277.part.js": "0b7e1b9addbb924ec837dfb12452fed7",
"main.dart.js_271.part.js": "46e15de4d149961e47ad0ffdcd33a62e",
"main.dart.js_223.part.js": "26a4b35793bc715774348d62231a3d2c",
"main.dart.js_14.part.js": "ad2cc68f403f70053a8c0241aea3fa09",
"version.json": "e9d913db2fdc769aa5e6581dd7fb3c9d",
"main.dart.js_264.part.js": "24c3944315c8675f0d81fb76dc810b87",
"flutter_bootstrap.js": "127935735196f4f7bbf7542f5c34a57d"};
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
