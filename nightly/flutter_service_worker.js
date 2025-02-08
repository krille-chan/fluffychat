'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_278.part.js": "be9242e0662b639a940e4921211a39de",
"main.dart.js_189.part.js": "e34360387b95d0b6574a0418fe950185",
"main.dart.js_272.part.js": "96d2dee7e4d4ceb24c17283cf973f88b",
"main.dart.js_213.part.js": "45fc00a61bc10b93b69cc45b25905cad",
"main.dart.js_238.part.js": "d1a85b6071f9529a78071623405dffd1",
"main.dart.js_241.part.js": "382fdbb243b293964cd377cf1d0e751f",
"main.dart.js_243.part.js": "17d7ac5485eb2fcca59197b096450492",
"main.dart.js_287.part.js": "90d9998337bb21b082d65c380489ba72",
"main.dart.js_253.part.js": "4c1587e6d0abb76dfacd893c344d0933",
"main.dart.js_202.part.js": "5d14d1b3a3ec263d82188fe7fb6e9c2d",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "ca4466a19f5c06c7764125173f6797d5",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_203.part.js": "9e7f0fe9526fab90e4050f63134e4593",
"main.dart.js_267.part.js": "7a117ff95d75a882cd55afb297e9f899",
"main.dart.js_262.part.js": "a43e198ddd5fe6432dc5cff83fd34340",
"main.dart.js_15.part.js": "417bfc58c811e2e382193f750f43a4b5",
"main.dart.js_247.part.js": "3a81033c819fe48b57581f59171ddafd",
"main.dart.js_292.part.js": "32864c629b3af5e67570e4a9c82c844b",
"main.dart.js_286.part.js": "9da203697ea496c3b99499592b7a1c9a",
"main.dart.js_275.part.js": "809cc1512f5f248954bf5ea283faa54e",
"main.dart.js_276.part.js": "3297209ae415ce91e7bdd4bcea91197a",
"main.dart.js_294.part.js": "23634a6f6201f007e341a4633d2f591e",
"main.dart.js_227.part.js": "31dccfb080c757f8351a662e40338a62",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_291.part.js": "8e3f324b75d6880c06776283846011c9",
"main.dart.js_269.part.js": "52c7ddbf29fc89facb3c4c19a5f0314d",
"main.dart.js_251.part.js": "a1bee5f7f17c9a5d9e81e64158c1f9f6",
"main.dart.js_236.part.js": "0f4353ab6fa655c70a5d147836158ed4",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "8551004d242cdb872b4a8b60c42de761",
"main.dart.js_260.part.js": "4fdc7499684e34f615cbb81abf8e8af2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_259.part.js": "691164628df740b8d33c91b9c3cab1fa",
"main.dart.js_285.part.js": "4e69c17b0512e749eedf12eaefe2bbd5",
"main.dart.js_229.part.js": "1e8ec327ffaebbba254e576d867bd03c",
"main.dart.js_279.part.js": "9d2a8a6bd41b67dccc45fbb867d67255",
"main.dart.js_290.part.js": "3729c0a0b2a42086080d62554c2f3441",
"main.dart.js_228.part.js": "d95a9d02d32f5e233f0b4fc42cdeee4a",
"main.dart.js_274.part.js": "fd47ad194e2cafbc524f7b089f0fc707",
"main.dart.js_289.part.js": "f2a3b47746870528673ca5252086ef03",
"main.dart.js_280.part.js": "644a117bb84f29d992f906d954331434",
"main.dart.js_231.part.js": "8369381b997614527f24c32ed4042508",
"main.dart.js_219.part.js": "57962497bcf7bc04c91b0c6481a78a07",
"main.dart.js": "36e87808f570bb87e5f1593f7019511f",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"main.dart.js_273.part.js": "d06c088c9270a270af5dac8f7b82cc78",
"main.dart.js_252.part.js": "0a26bf14a79e4b42a4448d1e5c9eb19e",
"main.dart.js_191.part.js": "9ffba4cdfa64d1f55a0517f90173810c",
"main.dart.js_281.part.js": "860698362de84a8fafe115968856f033",
"main.dart.js_204.part.js": "3298592a67b2cf5cf893e330c77ae7b6",
"index.html": "84c76b8f4ac3808dce124ba2d6e8c8e4",
"/": "84c76b8f4ac3808dce124ba2d6e8c8e4",
"main.dart.js_271.part.js": "08bb8b8f00cf4c16568c94f2ce8cfac1",
"main.dart.js_1.part.js": "6cc0a79cb202c97060210a17f567e17b",
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
"main.dart.js_293.part.js": "9ad138c4e65aa06226da1ea0c88cef74",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "447969786766b751584f02415726a8de",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_240.part.js": "808ba077b51594699f1a03f1805b040e"};
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
