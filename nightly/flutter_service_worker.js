'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_234.part.js": "74b26f3b6abc3707a6242c1a858250ba",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "501ca5651a96186a3364d87543321b49",
"main.dart.js_276.part.js": "a78639f790c1be3cf60abf1ea3b02fd7",
"main.dart.js_1.part.js": "400a5f2363e954e7c751af7a04045f0e",
"main.dart.js_302.part.js": "14ba8f2c6de834ebda401354926b2326",
"main.dart.js_321.part.js": "d9e55e157758eea311efd1fb71c64ea1",
"main.dart.js_216.part.js": "b10bcace9e26d20167a5acee33fc5d99",
"main.dart.js_325.part.js": "5163e07c32519c6ed3b31cd7cfa28af8",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "b65078fb9cedbc27b91ac2421058d55e",
"main.dart.js_277.part.js": "1d44e047663f24d8976c614633d85251",
"main.dart.js_315.part.js": "f4e1119ad7bcbbee193afc87d3a5320b",
"main.dart.js_323.part.js": "9f5c7e41a853c82f85df0faab4c3da77",
"main.dart.js_295.part.js": "7e04b4e4b4f34c72f06d7933ac18fe2b",
"main.dart.js_278.part.js": "b0795b7cf3fe8ac519896a3f7eacdee1",
"main.dart.js_304.part.js": "7c2db51a4d98fd9fe8cfa6a492dc5d78",
"main.dart.js_312.part.js": "3c4e0372416d176c9b7ebf690ac237d7",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_332.part.js": "e851b94637975cf73af2c242ec79f14c",
"assets/fonts/MaterialIcons-Regular.otf": "dd361349492111cd1aeb4ac406910792",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "32264d576c001f8ea24a9a8a8caa4ec2",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "48ced315403b507753c6974c8fb41595",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/NOTICES": "ccc7b438b6733657324389d49423afca",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"main.dart.js": "8d63298212e92fad11dbc54f657a70f2",
"main.dart.js_326.part.js": "f34fcf9c358ae0c7817ee5c9c277e6bf",
"index.html": "934275906c364ee4d42ccce83f213d94",
"/": "934275906c364ee4d42ccce83f213d94",
"main.dart.js_307.part.js": "9cdab5242ad3b618a289d9247d70c12f",
"main.dart.js_297.part.js": "df99f1ec0095d5371f8f91f954d56450",
"main.dart.js_222.part.js": "415ec09f533f530df77e2bada909f5b7",
"main.dart.js_254.part.js": "ba33264dad0231d0b0f22191736d4b85",
"main.dart.js_282.part.js": "d3976a5a9db9ae166f089626307e5bca",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "1067ab4d360fee935236fd68995a9861",
"main.dart.js_274.part.js": "13df87f395d9d7ce6a5d2960671cae2d",
"main.dart.js_270.part.js": "031e1dc7e337dbf60e1f63aba8b9e7e6",
"main.dart.js_272.part.js": "178cad8f53424dfe65b74e40f73cb1e2",
"main.dart.js_264.part.js": "83bbe786211d8947e50a6d7b26d24337",
"main.dart.js_288.part.js": "61a2d7518e4f89a96b98f62cb6b2a86b",
"flutter_bootstrap.js": "c52d784bca008888db999c75f719a80a",
"main.dart.js_322.part.js": "8153d1910f69a9441e088ffcdd70c8be",
"main.dart.js_308.part.js": "42b93070764179ff37a9baf8da304f02",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "3efc0f28f7ccb9504c58f3e00d5961d0",
"main.dart.js_286.part.js": "7fbdda64ccea8559e21eb3968ee09e7f",
"main.dart.js_262.part.js": "c2f957987aa1806e3f47d472f11d96cb",
"main.dart.js_251.part.js": "044d2a1b03019e68ddc626b9e962bb25",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_283.part.js": "b9a8e64ca793e276bf5b42d73458ccdf",
"main.dart.js_294.part.js": "68b6d52d0c5583c00f0344ec8235992c",
"main.dart.js_263.part.js": "c9feead72dfee9a689ef470f590f8c02",
"main.dart.js_330.part.js": "5b1f8b3811d566e133c7cdd1c90fb4e1",
"main.dart.js_317.part.js": "432cfc55eb42a512071489c4e2200491",
"main.dart.js_316.part.js": "d5128f1c33794cb98f982413d4939223",
"main.dart.js_327.part.js": "fe35bed79bcec1aa54e7cb16877f7688",
"main.dart.js_328.part.js": "f025d9528b728bb46b815a0fa4a670ae",
"main.dart.js_311.part.js": "458f63f347a31bdeaece4ca9b0b8b751",
"main.dart.js_314.part.js": "be1bdd11b29824138813edd0d16eef77",
"main.dart.js_310.part.js": "488b6961bad2ee491c6b71d46537934e",
"main.dart.js_266.part.js": "762feb5067db9070cb73c1bb3f3b30f5",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_245.part.js": "0d75f5f89497724fed3f21a6715b69a4",
"main.dart.js_237.part.js": "93f09f0c021abe454929aae5b945287a",
"main.dart.js_214.part.js": "9465521b7105fa7ba4aedf7b9c91a2ca",
"main.dart.js_287.part.js": "ac195f1157af498051067db981465bce"};
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
