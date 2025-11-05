'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "19a2e0e0b72f1335a507a33f6fe2a3d2",
"main.dart.js_308.part.js": "e0843f460f5593bb07364c2acf8ab707",
"main.dart.js_271.part.js": "82735e38b739d23bb5d116bac71d801f",
"main.dart.js_317.part.js": "d4aa87883ed8152717d63432eec3a7e1",
"main.dart.js_297.part.js": "aa6d24130b8c75c3ffb6a120ea0e3c7d",
"main.dart.js_1.part.js": "3c4e217a9cec8cda3a200789cf93fce5",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "ac737d2b14ff4afbf907edc296f236e5",
"main.dart.js_311.part.js": "43fbf33cb30d18ffd6cd00964646065b",
"main.dart.js_220.part.js": "ca40c4ccde2e2038958c500b71a803be",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "3fa8543812d24b9698db2c9e381b95e4",
"main.dart.js_295.part.js": "7afe41e4b5690f17c5a261b67d898c64",
"main.dart.js_316.part.js": "76cdc84d1b2830469d58cbea6193f0b7",
"index.html": "d890574bea22d90ef2fa75b5d1f373b4",
"/": "d890574bea22d90ef2fa75b5d1f373b4",
"main.dart.js_302.part.js": "214417620053ae1c87dedaccf6acc9e9",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "caf798f37cdbc1fdedc778b4a2b7ec06",
"main.dart.js_244.part.js": "3c000bf33ac7e3a16eef4db728e7b13f",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_283.part.js": "318c15ef10d24992e56f3758d9ec9cc6",
"main.dart.js_294.part.js": "5b046609367175bebb9edb7a51e052cd",
"main.dart.js_265.part.js": "1f84750fbe1dbf3ad50031cf49b5f71e",
"main.dart.js_261.part.js": "766dc1469fca486fe0bf810e37d6c44c",
"main.dart.js_262.part.js": "a13e3c62bba9df3b46f8d928dcf8d1cf",
"main.dart.js_322.part.js": "c617200d1844726fa3c4ad7de2c8641d",
"main.dart.js_263.part.js": "9dc087cc47b8092f16ef9524b989a363",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "6d8a9ed35f75cd824cfeb249ce4b63eb",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "ba4ccd1fdce1edb71b5c8b81cc194a51",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "10f86a9d1c19dc0218853f80740513e2",
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
"assets/fonts/MaterialIcons-Regular.otf": "74d774e5a77a4138a1b82ca633ae813a",
"assets/NOTICES": "6cfe799430e6c840c30290f71ccbac3b",
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
"main.dart.js_16.part.js": "8a5100b73eb6fa01ef4dffda82e3ad70",
"main.dart.js_278.part.js": "ab51d151f540ee065f2457d781fc07a9",
"main.dart.js_286.part.js": "eb596dd01d5e6dee5991bbbb9db72cf6",
"main.dart.js_232.part.js": "2321826810b2369473e19b1ede0af22c",
"main.dart.js_287.part.js": "ffc4a8f21e68c0c50c2f37d252d4b66c",
"main.dart.js_331.part.js": "872016bc9bdb7f567a9e42744158af55",
"main.dart.js_212.part.js": "695aec9b2591dc00c03c2f490ed3edfe",
"main.dart.js_269.part.js": "d634e6b8173a1cf156861e30c4c700a3",
"main.dart.js_309.part.js": "017cffbf812b227331466d665031008c",
"main.dart.js_312.part.js": "4d6d5d002321684a160c4b7b40e644d3",
"main.dart.js_325.part.js": "c50780974d1af8790f0c42038d132be3",
"main.dart.js_321.part.js": "168d620730846c3764f5417582d29b8f",
"main.dart.js_273.part.js": "fe17930f6e003f3f480ea76620b17325",
"main.dart.js_235.part.js": "9e49bb9b0b80d96e69dd57b69f513266",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "2432087e56f709746649cd22418d01a6",
"main.dart.js_332.part.js": "43fd97a2077793556c28b54453ca31af",
"main.dart.js_288.part.js": "e6c45d09933093d0116cd272bf05da30",
"main.dart.js_314.part.js": "dda965b457eb5108e8311fff255fc8c2",
"main.dart.js_307.part.js": "6a8131a1838c04ffaceeb45649e59ee7",
"main.dart.js_253.part.js": "c1e0017988d0aca31ef2e3dda59124b2",
"main.dart.js_323.part.js": "86bfbcf7e2333ae3b7429218db06c3cf",
"main.dart.js_328.part.js": "e5e7d3abf3d1b3947494bc60a59a1dfb",
"flutter_bootstrap.js": "512b5a3626a8348aa96bfe5f7a720a0f",
"main.dart.js_315.part.js": "739d950cb311ab2f7c0551254752a95a",
"main.dart.js_304.part.js": "bd1744401d30d0fe0838360dd8d30da3",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "81b665d20d3bc631eb01c35fd4cfcf3a",
"main.dart.js_326.part.js": "0e53ed99368e7ea19b2a7604e0ff9548",
"main.dart.js_329.part.js": "a670c7626a8af3bd850a559538ead845",
"main.dart.js": "6fc019c499d644b719aaa7dab1ee557f",
"main.dart.js_277.part.js": "029528a4c5f0efe4d8b56c55bb203b34"};
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
