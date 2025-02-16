'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_282.part.js": "1f36306911e3341d188080eed94abc1d",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_273.part.js": "515adc7853b589fe5fa7d9af6b432b28",
"main.dart.js_250.part.js": "d8637081439c6c5169df99342e99c657",
"main.dart.js_225.part.js": "58e0bb0a93f1bd21943a8f0bcee43f3b",
"main.dart.js_233.part.js": "44bd36e6d6301b868caff91e96725225",
"main.dart.js_288.part.js": "d205aea8a5e450a607a005f8a88b6a64",
"main.dart.js_201.part.js": "37ccd4a10867cad36634c59b951cb7b6",
"main.dart.js_226.part.js": "529c3791b63d01c5923dc21dc97dfcd3",
"main.dart.js_264.part.js": "5e2834961a34bb44ee33059e79352b77",
"flutter_bootstrap.js": "6eb40e8380bd192a47e748d302e92e65",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"main.dart.js_257.part.js": "e7b3a8e504a669d33d45828d5cbfa4a4",
"main.dart.js_277.part.js": "880106af87f07dd6c71bda4305147eeb",
"main.dart.js_290.part.js": "a935871a64409d26e352b3ae1444af95",
"main.dart.js": "67ca16da1c172a7e0d290fed6f04574f",
"main.dart.js_239.part.js": "9012020943f85bac8f2d307c84ba14ec",
"main.dart.js_224.part.js": "fc4c4b7f629fe3c6d6265a5c55d59ef4",
"main.dart.js_271.part.js": "6c80218758a624533983cd939a199e1f",
"main.dart.js_243.part.js": "7804b8b4afa6bdde085cf1d59d8bc86a",
"main.dart.js_286.part.js": "0c2b01038595c316173caa7a377c41c3",
"main.dart.js_283.part.js": "7445057b64570b7fce5038b1b564800a",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"main.dart.js_291.part.js": "b15f6e5f051f43bdde8d41cff25802dc",
"main.dart.js_228.part.js": "dda8d90b5dcdee1ceb645a8ecc0171a2",
"main.dart.js_272.part.js": "a3245ed85108aefa5ed5b4d733c93652",
"main.dart.js_210.part.js": "f0134d150956a4a6a2bcae043dbbadf5",
"main.dart.js_237.part.js": "372fde17fe74c170e69a9488517b66bd",
"main.dart.js_200.part.js": "03c3fa635d9a18b63b99f13044fd4451",
"main.dart.js_238.part.js": "14ca7e53e2422cf7750203b76117d912",
"main.dart.js_249.part.js": "4a7cd24f223f822366f99f1cdf8f6afc",
"main.dart.js_276.part.js": "f06c247e4fb08310917bb1210b428be3",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_244.part.js": "5b6263ba59d262c4067cd25d589dcd55",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/NOTICES": "e99242c567cd70f20586d572ac4af717",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/MaterialIcons-Regular.otf": "877e7842dc8b752a2ac28257967f8951",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"main.dart.js_235.part.js": "f741ea281984d8c0222a4176a47812b2",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_289.part.js": "c56dd55e3e5b42a5c1e55c2386c340b8",
"main.dart.js_248.part.js": "0dadc91a56b2de8d909dc725745219d7",
"main.dart.js_15.part.js": "3df253160f2441933b61cce9ec3dd7e1",
"main.dart.js_259.part.js": "2fe10a94ed2e72b2eecaf53989186e0c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "08dea8777add6b13b5e491be41c7b9ed",
"index.html": "c7281ca89ebadc93723b471e1a3229f8",
"/": "c7281ca89ebadc93723b471e1a3229f8",
"main.dart.js_270.part.js": "43d03530d4fc658a9748cb741f29add8",
"main.dart.js_188.part.js": "73cbdaef7d062a4c22fa86e2280f9846",
"main.dart.js_284.part.js": "bf5f4d6d3213082e5c305a88d15ffb77",
"main.dart.js_269.part.js": "3fc46358c9e3d1cb67c2a467af1c274a",
"main.dart.js_275.part.js": "d6782d803d65ae81f96ac1e46ba3c44c",
"main.dart.js_240.part.js": "e60c2977fd0842a4866d84bb2d054bd0",
"main.dart.js_287.part.js": "6ad73b78d33d0874b85efe6ebe672b6e",
"main.dart.js_199.part.js": "21c8d1de7835cdd6565f94cfd56f9d3f",
"main.dart.js_256.part.js": "f7b10538716433ef4fb6961acd2d5dd5",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_216.part.js": "aab59503610d2ee13c4d21664b8dca5d",
"main.dart.js_1.part.js": "8d2facbe902b8ce1a08a29c26cc121ea",
"main.dart.js_186.part.js": "23b0e981c41c927a9ee0b8cae050eb92",
"main.dart.js_268.part.js": "abef48ed3bc0b2bfa2bd7704fad58f16",
"main.dart.js_266.part.js": "212e7054d5f18d5473b15cdb3ae13e5d",
"flutter.js": "4b2350e14c6650ba82871f60906437ea"};
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
