'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_207.part.js": "0ea4b25a66cc73671b62f382b1b11b59",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "5572da1cffcd3e54a84f052403d860e8",
"main.dart.js_317.part.js": "382121312fa0ec7c9da2aeced3c678d5",
"main.dart.js_243.part.js": "d2730aa6aeabb8097fa55131bf5ec76c",
"main.dart.js_1.part.js": "2b210d9c0a6209668eb15b90d3cc6839",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "50f8973eab9b80649284da32550c7053",
"main.dart.js_274.part.js": "d03779c5d649bbb3c32ad03348d426ca",
"main.dart.js_318.part.js": "24ae8e0ff3c14c84217bd59a0c0280fd",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_266.part.js": "60555dc7cf67851bbf5623490ece7c8a",
"main.dart.js_246.part.js": "873dd442d559fa1ceb4eb9115563ac86",
"index.html": "ec8736bd5b98c2a8d552029ae178f490",
"/": "ec8736bd5b98c2a8d552029ae178f490",
"main.dart.js_302.part.js": "479f5b929e6b27a622606ded76a407fd",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_258.part.js": "f032c5b6ffabed4d10fc515cdc5edd71",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_294.part.js": "2c54178788fcd53d202727e6a91873da",
"main.dart.js_300.part.js": "f23ef83cfcaf2356fcbac24efcfb323f",
"main.dart.js_262.part.js": "d6c042b1c00d7a20229e8b1d95a51e64",
"main.dart.js_299.part.js": "cfcffa2030dc7e0d60ad03fad8ad8234",
"main.dart.js_322.part.js": "e1a13e512209f50ad19a0ecf7e587006",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "8550f2a232ab8ef0656d5a8c8a013df8",
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
"main.dart.js_320.part.js": "3f9440377a24dda3a238b1ef73f469df",
"main.dart.js_254.part.js": "2a26910f50ea1faa74ca733b4a1532c2",
"main.dart.js_228.part.js": "e22d5ce037a355db1146542b575b20a7",
"main.dart.js_16.part.js": "8a5100b73eb6fa01ef4dffda82e3ad70",
"main.dart.js_296.part.js": "04addf541fb7ca2afbebffa3f8543f5d",
"main.dart.js_278.part.js": "e8b53c8f184190f6fa5566ebe0cdddf5",
"main.dart.js_205.part.js": "a6c9ef8bda2d1e95065ea87608089f5b",
"main.dart.js_286.part.js": "913d6de32ccf034b87a4ec9de55ee0b9",
"main.dart.js_303.part.js": "c0a2f1d0bd6abfefea249a9eef658f5d",
"main.dart.js_287.part.js": "54ad915ee4e0c1c1f4fca900352a02cc",
"main.dart.js_237.part.js": "2e13cb50e95a585f19b621f554376673",
"main.dart.js_213.part.js": "4dd47d8abb9e35bfca46b447c6e4e6a6",
"main.dart.js_269.part.js": "84fab4c5413f45cf08e76be3f5dac124",
"main.dart.js_313.part.js": "a528fd42385bee5b7ebff6df3848fead",
"main.dart.js_309.part.js": "66381132a8b4707bed9f36f86751da36",
"main.dart.js_270.part.js": "aa82217f03b8a150b7465e4d01aa8e9d",
"main.dart.js_321.part.js": "eb5fcfda717dcbe7d9b5958e34fd9230",
"main.dart.js_255.part.js": "c608492320c2cb4e60a1dec34dbb18b8",
"main.dart.js_268.part.js": "844df3bb802a8f63f7489c495db5756c",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "49c5a6d3cd5a8f0f7452c7010f2c77ac",
"main.dart.js_314.part.js": "ea9e1fd7f55aacf2694c988f1ce70a49",
"main.dart.js_307.part.js": "fb71795e449a5db16c576a6696adc8af",
"main.dart.js_279.part.js": "5b3b219bb6fb14e763dc4775dc25d79f",
"main.dart.js_319.part.js": "9f1807016a5837f4bb2eefe855fefd1c",
"main.dart.js_323.part.js": "bdd4ce2c2b3d658a8698ccad1c9e8955",
"main.dart.js_324.part.js": "310f08d0d749f0af0b8c96dee99b4531",
"main.dart.js_289.part.js": "132ac59d6a05dff4298b257f347d41db",
"flutter_bootstrap.js": "4841b28ed78dc91e994f5a4742e6915c",
"main.dart.js_315.part.js": "fcfefb035c66acb064e2d91f9b8c78d6",
"main.dart.js_304.part.js": "2834cbf3e8fdc344750e9cc70622aa3b",
"main.dart.js_264.part.js": "edaefdf462812abeb93eb6520614d111",
"main.dart.js_306.part.js": "a4fd11bba01ab6b941efd8ad4b66ef1e",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_225.part.js": "3f0afd28d2c1af359aceb0619d59491c",
"main.dart.js_256.part.js": "7d0b02a65d6aa2cc43598de50768bb7e",
"main.dart.js": "ec16883265e1811f13e81790bf80d68a"};
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
