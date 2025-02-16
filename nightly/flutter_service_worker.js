'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_282.part.js": "1082d65d4859a7f349e057542b80ab80",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_273.part.js": "1ce9818140c779d1901ace4eb523f452",
"main.dart.js_250.part.js": "36fdaaa66d5944cb5f51287b44d84a7e",
"main.dart.js_225.part.js": "bf1fbc0fc010b5767f0fcd9cff7bcedd",
"main.dart.js_233.part.js": "96a3332bf1a6d8915aeecb2a8ce5f74e",
"main.dart.js_288.part.js": "1bfeeb569e71c440a0e27674ebec1576",
"main.dart.js_201.part.js": "5c42728d9e73694c95b83b5cf6354a5b",
"main.dart.js_226.part.js": "aee96ef106906f047bceb9ad4f79d6f2",
"main.dart.js_264.part.js": "b5d477be15d7e2338bdacd0e66f56e5b",
"flutter_bootstrap.js": "3ab9bf121ddc9acabc485e97f85f44cd",
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
"main.dart.js_257.part.js": "bc41ae329ae9b2fbcf623c2a6aa0bb41",
"main.dart.js_277.part.js": "fca5e0d70ede32c89431c059248cabcc",
"main.dart.js_290.part.js": "cd4d1d215f70f796442d22b5ad14c1ae",
"main.dart.js": "b963d2f6bfc6a27982a086b7451391df",
"main.dart.js_239.part.js": "48da3b55afb62cf859b7d409992dc53b",
"main.dart.js_224.part.js": "4e3f5b0e9c9e22fadf2c584f95615f5a",
"main.dart.js_271.part.js": "b9eaab899535de32ba35c51155f1ce33",
"main.dart.js_243.part.js": "58758dc97e0a4a80d577b21ae80a268d",
"main.dart.js_286.part.js": "78e362f29424e6e72797b106680e27f4",
"main.dart.js_283.part.js": "aef7fe8dc0ac5a4c52ab708aa801d476",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"main.dart.js_291.part.js": "647d2543879c2209896c64bf44dd81db",
"main.dart.js_228.part.js": "9fd863a9429c83b2caccd790bc123e6a",
"main.dart.js_272.part.js": "4a1e6b867f15fe0b39a06aa09ac42178",
"main.dart.js_210.part.js": "7699ce74a57ab3f38f4fb49fa4283dd8",
"main.dart.js_237.part.js": "330a635e7e75cfe5c48cb7d904b81f9b",
"main.dart.js_200.part.js": "17fcf50a51603b3d095ea39454d6dcc0",
"main.dart.js_238.part.js": "4640a8bdfe863e00e4eab6ec3aed30fd",
"main.dart.js_249.part.js": "25577c36ddda94f74c73ef316c2ab7f1",
"main.dart.js_276.part.js": "3cb7fdc27e00316e2f0ed94b97b5633e",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_244.part.js": "0b0edf46224d65a8cea22192eb1b87e4",
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
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/MaterialIcons-Regular.otf": "877e7842dc8b752a2ac28257967f8951",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"main.dart.js_235.part.js": "59055c6618b0d1df4bf45de60191c216",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_289.part.js": "821816a4ab9c43b8e3b283c340d2c097",
"main.dart.js_248.part.js": "a8788bef7682e407f94f82c3934e0b9e",
"main.dart.js_15.part.js": "a2cf9710eabd877c31b95e813f1b34f4",
"main.dart.js_259.part.js": "69cb44aba1c15d7dd6ee721ac575678e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "a89b85d5c82e3252a3b153b0ea354008",
"index.html": "ede567ce1327f2bd18972d194006cf85",
"/": "ede567ce1327f2bd18972d194006cf85",
"main.dart.js_270.part.js": "72df02fa5f13ad709e8ce772789fa1f0",
"main.dart.js_188.part.js": "28398f1554010b9e537a7d22f8cf5e5c",
"main.dart.js_284.part.js": "1702fe29a7e5165172c59fb35567e002",
"main.dart.js_269.part.js": "89d921d322c3d2c4ccfe07dec3abb377",
"main.dart.js_275.part.js": "79bf27086448159ec1c0ef2f39071fad",
"main.dart.js_240.part.js": "c4e766cbb7214f09a6bbbd7dae7e1de1",
"main.dart.js_287.part.js": "70a2e2f271c50a768a3f5623afd33f92",
"main.dart.js_199.part.js": "14514a8ec5074bc512ae506dd5f712ad",
"main.dart.js_256.part.js": "5cb84392ff75b0df83d90e1cfce47db8",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_216.part.js": "6658bd82d88d32e7ee623f8da721e3df",
"main.dart.js_1.part.js": "7fa89fa257521e159ae189669a24406f",
"main.dart.js_186.part.js": "5fb132ff36892e4b1f17b61d1c51e3d3",
"main.dart.js_268.part.js": "1fb96a977f3c0d222f6e01d26e8f70e3",
"main.dart.js_266.part.js": "83d19204f831f61f15852440525a150f",
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
