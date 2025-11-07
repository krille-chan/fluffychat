'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "41c1deae39400f74fdc6bc1601d7cfe6",
"main.dart.js_308.part.js": "66b56d6f94c7edfaba9e195974980369",
"main.dart.js_271.part.js": "7190afc76f918346a4c807ea8f526c1d",
"main.dart.js_317.part.js": "9dbb79529f88e4e37cbc5943cba0860e",
"main.dart.js_297.part.js": "88266d8f576c1c85e995451032d97145",
"main.dart.js_1.part.js": "b76caaa81fd2006dc5dd6cd1c005409e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "dc9d0fc15cfda0b076148fe2fc4f2764",
"main.dart.js_311.part.js": "02bfe83ac4e0faae06abc7e51df0b36d",
"main.dart.js_220.part.js": "df8ce68a6580ff8fbabc999047313880",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "00a967f41cc9a73d28e5cbe68b854f49",
"main.dart.js_295.part.js": "df63c769baa0910e01f52c5f77d11219",
"main.dart.js_316.part.js": "4591b9e4deda2fa9265c071ce94c4cb2",
"index.html": "63744f288d0f71c0404d27b29b9d4a88",
"/": "63744f288d0f71c0404d27b29b9d4a88",
"main.dart.js_302.part.js": "97a6e1ee9a543292d7c8dd1f0189e935",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "e1a8a81c044add3ee98f2472f6d92886",
"main.dart.js_244.part.js": "976a96de8e378557b87b0843885cec44",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "49b2ace5e143590b1e75fc9ff8c7cc63",
"main.dart.js_294.part.js": "9bd2f6ebcbf8773e7c091c06691559ce",
"main.dart.js_265.part.js": "da9a19710e71555928bbdf60001b7820",
"main.dart.js_261.part.js": "c976a67da62be9db9a90802e6fd8b174",
"main.dart.js_262.part.js": "585d8b3cd39aa86c6df31c732fb8fd7e",
"main.dart.js_322.part.js": "b055e36449582026d6a8282d790266d0",
"main.dart.js_263.part.js": "12f78739ce62042ad27eab00dc27edd4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "096a42a678faf7af65c23b39984ac9f3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c8961c4e0435186f6a7064c35b698795",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "c137c821c6a2ab637f83bfaaf8b23433",
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
"main.dart.js_16.part.js": "90694ba57224464c046cf6940eb19e3f",
"main.dart.js_278.part.js": "e23e4ab0df087d97fcadcbff634f0f0e",
"main.dart.js_286.part.js": "29c68c42f4dcf0d337052d10d47c05ae",
"main.dart.js_232.part.js": "6b8c3c946bb6bfe12ce10cab263bb72c",
"main.dart.js_333.part.js": "d7088811322f0cdba9705e5660200e6d",
"main.dart.js_287.part.js": "fadb747800a38169e06cccf394d675a0",
"main.dart.js_331.part.js": "567ce61426294bde9039ef1647080770",
"main.dart.js_212.part.js": "9722be5d0d7391629eb9f70a2fa2bfb5",
"main.dart.js_269.part.js": "5f54958d43d7fb565c27b319eee7793e",
"main.dart.js_309.part.js": "7f4ce43208667c9c266197b164e6b576",
"main.dart.js_312.part.js": "655c640296429aaf2e9c0df903a3196e",
"main.dart.js_325.part.js": "21290abbe196f1851831095e50cfe2cc",
"main.dart.js_321.part.js": "b5713226c7dd4ae809ac3bd432d3db08",
"main.dart.js_273.part.js": "3e888af3fcaebf5bc465e7a1a3521c52",
"main.dart.js_235.part.js": "5e982817f91e8fe4b738fca7bb94c81e",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "3c9a7c87be008060cc9d784caee27d37",
"main.dart.js_332.part.js": "45cb4dad93da3d038dcf876e1a16b04c",
"main.dart.js_288.part.js": "987d0300ca4ca9f75410337ddea9fd71",
"main.dart.js_314.part.js": "464940e8c6b6390533a025f8d4ff6fba",
"main.dart.js_307.part.js": "d8e534fb66bca217f3cd9913cc15fabb",
"main.dart.js_253.part.js": "1f5918d29882277e26ef28fe1443907c",
"main.dart.js_323.part.js": "4f9e65ec04bc7e107709e940240b510f",
"main.dart.js_328.part.js": "2e6bd88086d78ef68f47230721a49f51",
"flutter_bootstrap.js": "8450d5f98d86aa5c93a6defa5cd27891",
"main.dart.js_315.part.js": "4f8fca497af4ddd04454a05e82b784ed",
"main.dart.js_304.part.js": "94b3c316f5ddc938ec045fe90b7fe950",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "0313a7738427db05aac3d04cecd63da0",
"main.dart.js_326.part.js": "a1f75cfb8dc506603b9c9fcdccb936e0",
"main.dart.js_329.part.js": "b74bbbe0e1248108c8025b9f1b5c648b",
"main.dart.js": "ea65fc0d28603ef45a46108fd4cc81f1",
"main.dart.js_277.part.js": "6940f57d5b5004453587bdb8d520201f"};
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
