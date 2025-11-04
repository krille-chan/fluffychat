'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_207.part.js": "bd3f055f4a29650593459eca782854b4",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "021e7908a4649ed87854a4854e23c585",
"main.dart.js_317.part.js": "b81d53b3e6ccb725345458ceb501f659",
"main.dart.js_243.part.js": "e459fdf463e2e14e164820cdd2dc44f6",
"main.dart.js_1.part.js": "402fc65079c3a2557889e38a7ea5dd18",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "83208b2094b01be8c996e87b90ab0ada",
"main.dart.js_274.part.js": "4d2725c9eb0caa5af1f6459d1ee638a4",
"main.dart.js_318.part.js": "b0160f263a14d40a01275aec70b8f085",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_266.part.js": "60e4bf57ab4a84646157fd929bc21f9e",
"main.dart.js_246.part.js": "e936b68a960b00b7045c4ec343a40859",
"index.html": "0237739c46eb930e82777ee15dd42ea0",
"/": "0237739c46eb930e82777ee15dd42ea0",
"main.dart.js_302.part.js": "9c198d18cc110ad8d497aad7fecb4a8a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_258.part.js": "0bf157fccccb4dd93cff4c7dfd37c18d",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_294.part.js": "760f33a5e201f9ce7ba091c48afc6eee",
"main.dart.js_300.part.js": "c63f0fb43ba7bde68eacbd7adfc803aa",
"main.dart.js_262.part.js": "d7b5398710e14ee7953963aeda634661",
"main.dart.js_299.part.js": "d9327eb07f0df9dad02e699557f57d99",
"main.dart.js_322.part.js": "4637985669be340d89ad1e56ccd86a8c",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "26f5fe9e97f3db4a03f3c91369e042c9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8bb21a3080f8d4866af34c8ba3567ad8",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "abd5af5a6dde52a998947de795b59f4e",
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
"assets/fonts/MaterialIcons-Regular.otf": "dcbfcd0ad87719587d4c30aa823f5795",
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
"main.dart.js_320.part.js": "fb72a44ae2e87a85360d265362ab8e25",
"main.dart.js_254.part.js": "409874addad9c8768b796a62db6e9043",
"main.dart.js_228.part.js": "4964f4694f1b3409b6d121d79c70b380",
"main.dart.js_16.part.js": "e1f73c7e273cefcafc96f1a21015aa80",
"main.dart.js_296.part.js": "c155b07cbaad02096df4eeaed38aa734",
"main.dart.js_278.part.js": "047f578b5685c9b318375fff28f02259",
"main.dart.js_205.part.js": "d6237d4645855a830d2f32061d4eb3ae",
"main.dart.js_286.part.js": "6ea6b73705734142c546413b5d5a8279",
"main.dart.js_303.part.js": "bcba7ac2fbc7ec9a65a19707b48f164e",
"main.dart.js_287.part.js": "078fbbbc651ce4ea30c90ba4851ebef8",
"main.dart.js_237.part.js": "7746fd1d15df3a0bd889fc3a20155b1b",
"main.dart.js_213.part.js": "6543b28affcfa4786b67b1994d5c6c1f",
"main.dart.js_269.part.js": "50adf4a4bef9cacd47a46351d8f4fb54",
"main.dart.js_313.part.js": "9217d7a0fe2a181572630f8ed34a0046",
"main.dart.js_309.part.js": "e8ca1bbf0b166518a8f9f5a5ae83a670",
"main.dart.js_270.part.js": "3260e53c013386243bbad5aab77d49ba",
"main.dart.js_321.part.js": "7c94ec44cd4850a158b257b55de09d69",
"main.dart.js_255.part.js": "9530edf19a6a8fdbc0e058367bbcda3c",
"main.dart.js_268.part.js": "0a5b5e5890e58085326502c357a2d46a",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "eea0f9653ea426ecb0cf3a615fe158b8",
"main.dart.js_314.part.js": "ed7ad602e3d37a1976bc6a9570b9f99b",
"main.dart.js_307.part.js": "cd883a8e7eeaf12e276cc13a8cf3f7f8",
"main.dart.js_279.part.js": "89d97e654c9d34ed7f4721043c503ec9",
"main.dart.js_319.part.js": "ee31d7c3b1802a2eb30197c491e1bdb8",
"main.dart.js_323.part.js": "fc729a0133a63aca9e9df45bff4cc632",
"main.dart.js_324.part.js": "50ea0ac1356fe75a0a92ba5e5bc5473d",
"main.dart.js_289.part.js": "03179d918b783470a31a6f7a544e135b",
"flutter_bootstrap.js": "bfa9f2abbb1d897035e9db7b79784219",
"main.dart.js_315.part.js": "b4f98df59fe0771da8a996eb1d074492",
"main.dart.js_304.part.js": "14837f3172a623965490d809f5ff3d4c",
"main.dart.js_264.part.js": "ff59d89d02e5aaee96935f7a1c0c6147",
"main.dart.js_306.part.js": "c88c7b3a2caaee8f9fcae356999f6781",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_225.part.js": "5cab2231c6b3bdf1f5187fb7fd6c03bd",
"main.dart.js_256.part.js": "bb427e78d4dfffb7efde237b40073215",
"main.dart.js": "880425b998d708629a6d2edc72b33d1d"};
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
