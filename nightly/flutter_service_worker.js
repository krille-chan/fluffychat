'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_272.part.js": "b7af731dda6d3b0d2bc4827bc77fac93",
"main.dart.js_199.part.js": "c8e9a98006a7cda16e6b7e00fc702160",
"main.dart.js_225.part.js": "93a6bf88c15b930cd40bb276d1d6a9c6",
"main.dart.js_239.part.js": "0069424499d05e45bc5388e8a457a04b",
"main.dart.js_270.part.js": "fafd264c87b863e6556ed7d074f5f32e",
"main.dart.js_237.part.js": "2f767ebcf065f0e98e5a00276c398081",
"main.dart.js_268.part.js": "738a3f6cb55cc82af77f950600e74a1a",
"main.dart.js_258.part.js": "a005522347c74659ab8dbab17ee1199c",
"main.dart.js_188.part.js": "330d300f960475e0c0fc63fe183877fa",
"main.dart.js_263.part.js": "8dd9b0dcfd9f6c38cfabfac0744e7239",
"main.dart.js_238.part.js": "b29edfe8b9a5f89e40c6c42df541658b",
"main.dart.js_249.part.js": "8b5ac716e0d7be133f4227b4747eb77a",
"main.dart.js_243.part.js": "3af8db9fa559a8e155fc9c87a21c126a",
"main.dart.js_287.part.js": "718aa5b88f0ceef12afed6d8542ad750",
"main.dart.js_209.part.js": "490db69456bed7584bcf899267ec89f5",
"main.dart.js_288.part.js": "3c85be5625341bc9b534f9d9852a03a1",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_265.part.js": "ccab55c4a9c6170a8d4432bceaec05e4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_267.part.js": "bf5d59fcd6c4ebbd96780016602730f3",
"main.dart.js_248.part.js": "6b83ced7ae520c2f2061eed058f68749",
"main.dart.js_255.part.js": "05d6f0eaabfa45017574439cdf67b78c",
"main.dart.js_15.part.js": "7ec932d64096f0ef535c7c294725de75",
"main.dart.js_247.part.js": "b781654c4a5baecb2f8d0a9271c8247b",
"main.dart.js_286.part.js": "754f6371aeba8e7fd3afc72cef3d0e95",
"main.dart.js_275.part.js": "39d3e9a0509cb02e9ff543010dc2739c",
"main.dart.js_282.part.js": "dac9c569c3fe998a1375aadfa85c104b",
"main.dart.js_276.part.js": "416ef3f619759a4480adb4fcd930d60e",
"main.dart.js_227.part.js": "a8b6552b4b041e5738fe26f54c8ac7c1",
"main.dart.js_186.part.js": "2094ed259583d6e303bc5e3dd38725b5",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "7bdd13578dcdb5be4e750ecee895612e",
"main.dart.js_236.part.js": "6c952338dca7d4c3f9f9cfba33029f1e",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "9b933ef68754b1788db6b18a925884b5",
"main.dart.js_256.part.js": "9649a41110811c3770a37171100d1d21",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "73a587729a54bc2e0da87f75594da1d1",
"main.dart.js_285.part.js": "a30233c1f51c1099f314ce068532deff",
"main.dart.js_201.part.js": "5c062d11f527f61a6dab8263e3c1f9a1",
"main.dart.js_290.part.js": "00c84e32ee3e48f921769d7a7e387d07",
"main.dart.js_224.part.js": "e851cd306cb5e958fc9d461eafa24122",
"main.dart.js_274.part.js": "139fcef9be91b76158368c50c823bd47",
"main.dart.js_289.part.js": "6cccb090f3ccfe81751b66c675ef89d0",
"main.dart.js": "18668ea8f47a59bd7977807c8671d555",
"main.dart.js_277.part.js": "97f6cee76c9a231838d4f374433d1f91",
"main.dart.js_2.part.js": "81a750809dd1fb2b074db9c419829e66",
"main.dart.js_234.part.js": "7e169b0b74461a068371b182e5c324ea",
"main.dart.js_232.part.js": "e05ce984db64ad28edbdce3381f1fc59",
"main.dart.js_215.part.js": "68fdd983248462e60513c9c7dd297f57",
"main.dart.js_281.part.js": "302b57eb3ba96a468b42d32f5fce4569",
"index.html": "8b1498b833b4a6238c3a3fe273993e23",
"/": "8b1498b833b4a6238c3a3fe273993e23",
"main.dart.js_271.part.js": "ea6ec100ace01fb4ff87f5960677d364",
"main.dart.js_200.part.js": "5b4520f739bf9f06e6125909eb442e3a",
"main.dart.js_1.part.js": "2e7be62bc363df87616f2ab324663cd4",
"main.dart.js_283.part.js": "12ffe834665ea66cc7035dc04c974cc6",
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
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "1be7dc13b4e05c6c07c37287e4a05f01",
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
