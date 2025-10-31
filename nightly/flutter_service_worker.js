'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "b4652651a01fa2f199654aabc33af412",
"main.dart.js_317.part.js": "d8db467ac5d6bc439e74baf2e898b183",
"main.dart.js_1.part.js": "cdedfbb8ca502f3d75fc4bd4baeaf430",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "39e2599b3bde04454c208d86a8628e46",
"main.dart.js_274.part.js": "7847e9fc2229e083ad870c2832619166",
"main.dart.js_318.part.js": "8f4355636f886a4f4168c3166f0acffe",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "4194d2d987b8d0b6a2da07e15d15dff7",
"main.dart.js_316.part.js": "1bfc38ca6c324ffc673a72c023441991",
"index.html": "08f14703db190433ec9e8b0df0df87c7",
"/": "08f14703db190433ec9e8b0df0df87c7",
"main.dart.js_302.part.js": "a13a9abfacbc07840211444b7eb1fdda",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "cde43816e24f51ee390c6cf9e194b801",
"main.dart.js_242.part.js": "88efbec1b1c557ecf0871d4150870b19",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_265.part.js": "3047a0ac61188054c6e211e528887b3f",
"main.dart.js_300.part.js": "9bea5c07098f159e16eb82f1f4613e59",
"main.dart.js_261.part.js": "06e13a412a78333aeb15e6ef7e571038",
"main.dart.js_299.part.js": "31235fe51d981ac634d810a610d7902d",
"main.dart.js_322.part.js": "01eb665508babfe40e8bf9e141010d5a",
"main.dart.js_263.part.js": "fb14c6008e213f5650d48a21e1639b6d",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "1a286407a7e6bd5a63469cb9335c4b4f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b34c16af902c54fe1fa04c50f00750ea",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "a623743e041a4e2e5432e62234f1618d",
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
"assets/fonts/MaterialIcons-Regular.otf": "ba6850df3f567a02f3e4138adbb19518",
"assets/NOTICES": "495155e4ec600fd53a6a111344ecb69b",
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
"main.dart.js_320.part.js": "790af3dcd746ad2fc254ce8e25334753",
"main.dart.js_254.part.js": "1859aa717553de28e3fc6f8128458109",
"main.dart.js_16.part.js": "f3d393e8fa4bf4b0ffa3ee100f91a0d5",
"main.dart.js_278.part.js": "0e1bbca2533cdc2da8575b5362357fe5",
"main.dart.js_286.part.js": "a2b4cec0aa949469fbcc4697997685c8",
"main.dart.js_303.part.js": "6531a3dc89f929a5168d8dffece0f168",
"main.dart.js_257.part.js": "2ba7d869e39853327604f73cda8b7145",
"main.dart.js_212.part.js": "9c3e8a8308caa19475ce4f4c42d1acb9",
"main.dart.js_269.part.js": "7ca4accb51de026b9ae2e13299286765",
"main.dart.js_267.part.js": "f51fbd973011e01246ceb9c3b5ff26bd",
"main.dart.js_313.part.js": "2924f5db1f0d7fd413c72ec2b28d6acc",
"main.dart.js_312.part.js": "7bf6f35d720a5786d4e64653235d0e1a",
"main.dart.js_298.part.js": "7a7fbb60e8ebf050e45ff8d68437a887",
"main.dart.js_285.part.js": "4f542170e2a7eff598697ecd6ebf32c3",
"main.dart.js_321.part.js": "c49601ae27f51643b7e8a96453b9285c",
"main.dart.js_273.part.js": "fcc1e54b0bc9c0e9ceed1ee2f4d3d377",
"main.dart.js_255.part.js": "64563ec5010020161341617b3d1e48e1",
"main.dart.js_268.part.js": "9cd005b0d78a7215923976be1d3860e1",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "e46aa0d3a9e2f1e2a01d31a906fe5233",
"main.dart.js_314.part.js": "4eb692f3697a7b51dc15c82e8a22d935",
"main.dart.js_206.part.js": "172af0ef5889e815e5f9bf934344169e",
"main.dart.js_307.part.js": "321870d4cd0f6e7577504a0bcce6a93e",
"main.dart.js_279.part.js": "3f286cc276ddf0fdce250d58fdf9c20b",
"main.dart.js_319.part.js": "74a047ca76ac4d21ad76f31ce13383e2",
"main.dart.js_253.part.js": "f3b3cc1dd9acbd716ef15e5f98a61ea1",
"main.dart.js_323.part.js": "bd6257e9662b6b00ad90c06db7c8becb",
"main.dart.js_227.part.js": "4b08ff244c7b70a4fa7e0ab46de46f61",
"flutter_bootstrap.js": "8109051b675a8a22df1c9ff18f9acdae",
"main.dart.js_306.part.js": "f890893c5fd57df937ea51d734fd7eee",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_293.part.js": "c85f911daf42c0c3a0085d902216f378",
"main.dart.js": "7cb01bbfb31127c3bd8dbab68f20fabe",
"main.dart.js_224.part.js": "e732be48503b8c58e62935e6158b7db2",
"main.dart.js_204.part.js": "e257e057bba3687006288ec124ba5ab9",
"main.dart.js_236.part.js": "6cd0b318927f089bd80ae01d87cc49e1",
"main.dart.js_277.part.js": "19a91aaac65c6c722ad7922b1f8a86f3"};
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
