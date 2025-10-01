'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "0151613b2dae809bd3763e5d2610ee7b",
"main.dart.js_271.part.js": "00c47c5ba20c9241450a5964e40b42c2",
"main.dart.js_259.part.js": "ca8e5cc79313bfe0ff895c3bbfee388a",
"main.dart.js_297.part.js": "4a9312750d28ee1e1f7db5cc58ee07fe",
"main.dart.js_1.part.js": "3fb41e26ea6ac17d0b79183f18f0692c",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "3668c29c36aa880d5116521769ee3c7a",
"main.dart.js_318.part.js": "7cd2ee0b751b3b9a458d2442c0cd4fd6",
"main.dart.js_214.part.js": "8eba1998bc4fab39fa943c7e2ec05a95",
"main.dart.js_295.part.js": "ee79c137c242b3992136e7df469656f5",
"main.dart.js_316.part.js": "65100d099be67f8c6d491acf263e697d",
"index.html": "afaebd62080210c18c392d3571ce5dcd",
"/": "afaebd62080210c18c392d3571ce5dcd",
"main.dart.js_302.part.js": "4c8fd47fa6a039e908cf603404ca7387",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "cf75aa6d54be0bbb56bfe4da359682dc",
"main.dart.js_244.part.js": "8bab0aae4355dc2e6de7d5649f43a84c",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "3c957f0140a670ccdd940b88a610ce7c",
"main.dart.js_300.part.js": "32c596f702f3d4e38d65eb7825f41883",
"main.dart.js_322.part.js": "3a61d95ff174502e7531a5b9c54f5d28",
"main.dart.js_263.part.js": "b89dc30cd574b050bf2101ab93f14e53",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "f2734bce309fb3ca2ea1e0780af57571",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "073e9e30394a624eea066fbc74d4597b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "210aef607e945c9269b82bdbafe67bb3",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/fonts/MaterialIcons-Regular.otf": "e43537443dee303909d6ef653cf99252",
"assets/NOTICES": "8daf832ee99199178bddb87d82f0c857",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "2b0b86b81f06b26fb0ce725c81c388f3",
"main.dart.js_247.part.js": "87fb937b83e4a636416570bb9c5c83b8",
"main.dart.js_16.part.js": "196b9e04ea75a5c7c95596f146a38d1a",
"main.dart.js_303.part.js": "ad77b9aa52861101c3120b7c7eb44368",
"main.dart.js_287.part.js": "8226b496b7b0e27c772e4a996b83247c",
"main.dart.js_257.part.js": "ed4580c11f7cafaf013d4f9ada572f9b",
"main.dart.js_290.part.js": "273f0b0fefa4d245a3e39c207173b593",
"main.dart.js_212.part.js": "5288a2723cd83dc452c9bfcf9a124b6e",
"main.dart.js_269.part.js": "a99c19f20fc5a83a6db0de63495dd5ba",
"main.dart.js_267.part.js": "a381fea02b78c6f603478c565e342c29",
"main.dart.js_309.part.js": "12cfb65a32af97b5ad00b03b5aa38797",
"main.dart.js_325.part.js": "442745c96a1e097d971d82ee18b51f6f",
"main.dart.js_270.part.js": "873ad5206ae3f73f4734161dede09757",
"main.dart.js_321.part.js": "67fc6120235aa0dcef0e8107d71f3672",
"main.dart.js_255.part.js": "ddc9a724e189b52b5eb9cf8a26dfc2c3",
"main.dart.js_275.part.js": "f688a888aec3e26050200bcb9485ed1b",
"main.dart.js_281.part.js": "d12f9314be9951c7cde3e67149275141",
"main.dart.js_288.part.js": "8b0ca99181cdd9d0fdf92637d2ac5d84",
"main.dart.js_314.part.js": "a39bba81cbe7fddd7ae40cb72e99dc27",
"main.dart.js_307.part.js": "41d14e919400b2e7e2351171fde31d96",
"main.dart.js_279.part.js": "0ed0d0220412e1b721026775d1a46d90",
"main.dart.js_319.part.js": "12d747027162cdd426b12dc916c534dc",
"main.dart.js_323.part.js": "2249f0b3f259672b01deb5738dae1ef3",
"main.dart.js_227.part.js": "7d3152ad6059e3090f1f4a9390c76d8b",
"main.dart.js_230.part.js": "a5fea96157505e4db82713efa55a04d6",
"main.dart.js_324.part.js": "9833f49ed083354712ed072d95a13834",
"flutter_bootstrap.js": "1b8958400d37caad675db506adc68769",
"main.dart.js_315.part.js": "15080bf2acb7552d43fa093238883de1",
"main.dart.js_304.part.js": "a5c79852d8feca44eb295c3b0be0924d",
"main.dart.js_276.part.js": "7ccbdcd51b7ec4110d048703eae1e6ff",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "a1b606caff1dd6c0ec942a6a02b1541e",
"main.dart.js_222.part.js": "a3591a3605cf25a8cde462f584ff97d5",
"main.dart.js_238.part.js": "7cc636d4554449282db285bcc02ace9b",
"main.dart.js_256.part.js": "a497cff4d874ef933d6d32c57c913fd6",
"main.dart.js": "9f9091e7156d669150d825cfed7f44ec"};
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
