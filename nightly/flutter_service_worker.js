'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "a146fea795a460e6366640b913f23726",
"main.dart.js_234.part.js": "298178aa245976a2f0f7f4620c48e233",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "5eef825044fb46c2fe28a80f22340fe2",
"main.dart.js_1.part.js": "2c1664566494985f8f2ae8dfcd75801d",
"main.dart.js_284.part.js": "8d93de46a5983463b8d66bdf6e4e52c8",
"main.dart.js_216.part.js": "e08a301aa705bd674842ac578cbfdd88",
"main.dart.js_296.part.js": "f8b769b11662585c296d8ab5826862d5",
"main.dart.js_305.part.js": "af8b75043b1c1e2271b15c966e56c8d5",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "4aca48420b52cd50cee04e8ac43c813c",
"main.dart.js_277.part.js": "5d2be70ec0e08e9ddc523d08f28cc908",
"main.dart.js_265.part.js": "267e7ffcb5e11a62f992b33a17ebccf7",
"main.dart.js_315.part.js": "26f2e9993c4fb752f247d0a1faec3c5a",
"main.dart.js_323.part.js": "dbde9a921f96e463672c1ea1dd346162",
"main.dart.js_295.part.js": "d3c7e06e2c90939040f26239ea26b709",
"main.dart.js_278.part.js": "b888fb5d259b6d64e32babe4d174f347",
"main.dart.js_312.part.js": "84feda93ab3dd43112fb79996dc7de16",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_332.part.js": "579bba049614d8c2dfd7b4ad8e3bcf01",
"assets/fonts/MaterialIcons-Regular.otf": "d3d7d597f725542b28e10dc1b81f1bf6",
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
"main.dart.js_298.part.js": "5973f8bac2945d373a2033520bfd5d0a",
"main.dart.js": "d911a54d62188e116f39a8784bc720db",
"main.dart.js_275.part.js": "9fc18ff2b267e5fd59fa47e0fb3c3287",
"main.dart.js_326.part.js": "c2e1cf8cf7ae1082dca45624fd7b0fd2",
"main.dart.js_279.part.js": "59b85ef450d91bcc356add6c7cb6c3b3",
"main.dart.js_324.part.js": "3df4c24afe09c241915212049e736c38",
"index.html": "a175bb511a8d91bffa9830ceef5bb0f5",
"/": "a175bb511a8d91bffa9830ceef5bb0f5",
"main.dart.js_318.part.js": "43adcad33756110a5b82733a47c32c01",
"main.dart.js_222.part.js": "6456674ea08c33957d761f406f1d75e4",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "e1696a50519f707c6bcddd7f06e44829",
"main.dart.js_273.part.js": "982bd360dc679ebb837a961f850aa74c",
"main.dart.js_264.part.js": "c20f77f72dd3729c5bd573eade590302",
"main.dart.js_267.part.js": "75c19137be397d4eeaba384407d330d7",
"main.dart.js_288.part.js": "a1b90635b2c0243f7b518f91854caba0",
"flutter_bootstrap.js": "2a0b34dc2d8d9e13d096b923b7e482ea",
"main.dart.js_322.part.js": "430caf3b7b76a54ff69b2bfe7e282b10",
"main.dart.js_308.part.js": "9ce52a15cb853ee45c9d4d03e7e184a7",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "bd221045fee570bf33719b544f023809",
"main.dart.js_255.part.js": "21977523840cdf784bd153087c7b4193",
"main.dart.js_289.part.js": "f37863f22c6bb01d29b1f64edfd67ca4",
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
"main.dart.js_283.part.js": "1ee0ee937308ce1a11658aa1ab3e8eda",
"main.dart.js_303.part.js": "872cfe0a417837a9bf4d57dbf2a70ac1",
"main.dart.js_263.part.js": "561e23a6e075c6f30ffb71fe9cde55c8",
"main.dart.js_330.part.js": "422fa03de0fec48adcc46221955eb410",
"main.dart.js_317.part.js": "4716253316c9c9eb40513322ae789097",
"main.dart.js_316.part.js": "3271bf14700feb920fd39c0503cc61f3",
"main.dart.js_271.part.js": "5823294a673c9fbb1b1cec4e2618e9d8",
"main.dart.js_327.part.js": "1da92296773996df771b592633145a7e",
"main.dart.js_328.part.js": "0d8dae1b46913ee4d01fe565c0c67223",
"main.dart.js_311.part.js": "6b2ccd72b7aa34377f9ab56878f1ef14",
"main.dart.js_246.part.js": "5bf9669dd6adf22ea92f885b7b9123f2",
"main.dart.js_310.part.js": "d9c6cd1e98173387522811210ad3e0a0",
"main.dart.js_252.part.js": "9d967cd80f170cc9803dde04448424dc",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_333.part.js": "7350e67cc934fd5ed89eed5067074721",
"main.dart.js_237.part.js": "fb31bbed8226560096e911daa257ba35",
"main.dart.js_214.part.js": "a621289e36b07c3603f9a78d1904c1d0",
"main.dart.js_287.part.js": "1031dfe2fdd7197be06454dc327a6a79"};
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
