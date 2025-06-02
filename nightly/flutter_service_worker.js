'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_230.part.js": "e37eea408a7ce541ea82f815ef13bcbb",
"main.dart.js_276.part.js": "80ce13d5195d2ddf665e81a7e24ab948",
"main.dart.js_274.part.js": "1c160fb985ea02d9b665f4ff16aa000a",
"main.dart.js_292.part.js": "7e42865be0d27688e20f63aeb9a4f857",
"main.dart.js_286.part.js": "5f36c54d00bdbd21175cafddb06bd9c4",
"main.dart.js_239.part.js": "99ba34c640447fac50b074ddc335a5fb",
"main.dart.js_263.part.js": "47233e1513a4c13612938974531d3c6b",
"main.dart.js_203.part.js": "e3d9efbf648ed64462b5680aeeb297cf",
"main.dart.js_232.part.js": "5d4aab7265619440600aaf341e7b46b1",
"main.dart.js_243.part.js": "d524d3e384612746eff9a0d280853258",
"main.dart.js_248.part.js": "2fa6b578648f2247d3dd3a9e3c2a1d1b",
"main.dart.js_275.part.js": "bbc8ec699da3de33e518f8b41b8b73d0",
"main.dart.js_296.part.js": "998455db4db4f81033306dba65afdd96",
"main.dart.js_212.part.js": "5131e66b8a2021888ded1c908e79ec21",
"main.dart.js_189.part.js": "8110bb077751274da9701e11dcd21e86",
"main.dart.js_242.part.js": "f669960cca90b1fa1143904d1a87e7c4",
"main.dart.js_241.part.js": "80aafe388fbbf72e626256b1e4cbb05f",
"main.dart.js_1.part.js": "96f39652ab31803b78052db37cbf7890",
"main.dart.js_252.part.js": "02488278731f8d292584ac29446a4b8d",
"main.dart.js_16.part.js": "8dad235dd9f852eeeab93b2da240387c",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "cc7e463c60039fecf7bb7c5576d2b44a",
"main.dart.js_220.part.js": "0008d2da8ce969d8578c482f19b16252",
"main.dart.js_253.part.js": "07317ca8b247a40210195858e77061bf",
"main.dart.js_218.part.js": "ae7314f8246316926ada1d365aef9a0a",
"main.dart.js_204.part.js": "b0fc0a73f3ddab218adbd49397e82dc4",
"main.dart.js_287.part.js": "167e29c631aa1454260931eefc5d30da",
"assets/fonts/MaterialIcons-Regular.otf": "0f73bdbc3eb9e9032a2a319f3942ff0a",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "983fbbb360750a0476b9a04a2c1cf05c",
"main.dart.js": "fc9cb539e68cc1dbbe45ecd08850b3c0",
"main.dart.js_254.part.js": "fc98eb628e9bf25a50720f5263c23971",
"main.dart.js_273.part.js": "49c647a4a0a799b2f42224aa26cda53f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_268.part.js": "67bb336f08708708cdabbc7bbdd1919a",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "6e38d7eb588e34b8fcc7e740022334a2",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"main.dart.js_281.part.js": "91a6e500419d5137ab88bc7b20048454",
"main.dart.js_282.part.js": "3de440b4e2a15dc468c3909b03d90e26",
"main.dart.js_279.part.js": "f492bcb2384fd14c05f8a89475c2a40c",
"main.dart.js_191.part.js": "39dadc3909616000988a7c32f712b9c8",
"main.dart.js_293.part.js": "f179a3bdaadc777186673d75980cda99",
"main.dart.js_202.part.js": "d5736cab2fb42708874d46a0cc5288cf",
"main.dart.js_297.part.js": "31ed88fcd1549477320cfd8d9e402f8b",
"main.dart.js_2.part.js": "d6c338eddec0d3623b489032ee604cec",
"main.dart.js_229.part.js": "d02f2a612fb6b37049df59da04a02466",
"main.dart.js_270.part.js": "b2187d4a0dfba390c3897a584db3f568",
"main.dart.js_280.part.js": "712dcbe07eeb0459ddde2cc889c62c4f",
"main.dart.js_288.part.js": "5cd840b5211a6843875dedbec5d1ca52",
"main.dart.js_237.part.js": "0ec0f155c20d79bbd34a62a76031e2f6",
"main.dart.js_228.part.js": "aaff5149d75ec8af8432258f97879647",
"main.dart.js_277.part.js": "b22f8bce90be3f676d00a7637f20a4e5",
"flutter_bootstrap.js": "0fc0f30e7da94e881082b05455ea45b0",
"main.dart.js_247.part.js": "416d563356c82f13bd7e62381116e3bc",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_291.part.js": "b91d008e35712b0c8e9b221e5f5d681a",
"main.dart.js_260.part.js": "2c5059c9f276863827f033f29a42800c",
"main.dart.js_244.part.js": "2d0102b9dcb1c46eb15e8aeab6e45a6d",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "ebb89dc07f8d9b6831a5175595ac0500",
"index.html": "477e2d7965de1bd4ab0ec9c95dd3beb4",
"/": "477e2d7965de1bd4ab0ec9c95dd3beb4",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_272.part.js": "a1ddf125503f073d4f34987bb4ef0dee",
"main.dart.js_261.part.js": "4825a47551b019c2fdbd5f0f7bb40696",
"auth.html": "88530dca48290678d3ce28a34fc66cbd"};
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
