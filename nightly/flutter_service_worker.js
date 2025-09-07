'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "b7b2214d97d3d3ee09e9439143926670",
"main.dart.js_210.part.js": "24dfaf610c1cb1939c0fef39b21f8f64",
"main.dart.js_300.part.js": "0490114f60f5504202a76df047dc6c95",
"main.dart.js_228.part.js": "e504ae43e0ee3c522963c4bfdc7cf5d4",
"main.dart.js_257.part.js": "7290dafb2d68dcffcb1891b90fc518f0",
"main.dart.js_267.part.js": "631a996ae81f3b632b7ac050ac8be486",
"main.dart.js_301.part.js": "05f774a2a0587de3564961103f3c1232",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_308.part.js": "03197f4957e37e8deeed1a5a82bf86e7",
"main.dart.js_303.part.js": "9536875aadd4fbf25ca0403539aa8518",
"main.dart.js_273.part.js": "a1b63132ca43668d6da435223bf42e4e",
"main.dart.js_265.part.js": "7d27e9d9dd0ad73c62182392437d0493",
"main.dart.js_319.part.js": "a9810abc5310f4cdb8a4d95315e87489",
"main.dart.js_221.part.js": "9de90e9673ec0a40e68883fb41742647",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "df2cfa992322f761361ed65cdcd9fce2",
"main.dart.js_279.part.js": "ae57af5d092ebbf7bef38194d854982c",
"main.dart.js_288.part.js": "b006fe41fe44bd82ea2f1a31d4585919",
"main.dart.js_302.part.js": "46acc8275ba5c0740a4e02a13c3dd86f",
"main.dart.js_269.part.js": "87a9b15d68241d5454e53d90daf4f39a",
"main.dart.js_305.part.js": "cf23146e481a92844a17ba3830d16b94",
"main.dart.js_293.part.js": "6210f36d457c0e6822121f192b04b7c4",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_316.part.js": "63df9972f81e1f95f12e0b6eac821609",
"main.dart.js_318.part.js": "c2ee8eb7a5d0186a5c1195bb993799a6",
"main.dart.js_253.part.js": "3627dd8cec810d08051ba92075b54f8c",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "a689833a623de869f0a4aefbe15e0729",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "bd9d2f3a27ecfb18da2eb48f6539bba0",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "2df648ca4026fe51c0aa1fea5b48cee6",
"main.dart.js_1.part.js": "0f2ecdfbcb1835f43e6c8a5cb9c4fd0b",
"main.dart.js_298.part.js": "96a233c15cbd8a6296c7510c38b51fe0",
"main.dart.js_261.part.js": "0766ccbbf43a454227ef7a5be3dc1d0b",
"main.dart.js_320.part.js": "38d8575a3e8bc57a49b408cc31bc228f",
"main.dart.js_313.part.js": "dc492678aa13253d619ca1f84fffa372",
"main.dart.js_213.part.js": "350541bea29643b3d9470a9049e43ec0",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b7cbc11e18ff730093f2521bfa995d00",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "731f5ebd3d2227c4a494befd121d78b2",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "94b4efad18adee12a0846919c79d3766",
"main.dart.js_242.part.js": "cf631653bc03e35e12e3d2eda6640c0d",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "96bee19882be24822480094cc620451e",
"main.dart.js_321.part.js": "f351e6efe4a9213abbc7c17f2d963962",
"main.dart.js_286.part.js": "b0d32097a5fba572b3b688c218d851dd",
"main.dart.js_268.part.js": "5189520b8f7a2b1f045ddb6f0a6bb155",
"main.dart.js_255.part.js": "4ad9708ae33ebdf069e39a2e13e981cb",
"main.dart.js_278.part.js": "6ee4921b414871e9c9fc98c4e98f71de",
"main.dart.js_323.part.js": "4363170c608b0a5a59b3dbf7beb73631",
"main.dart.js_299.part.js": "5301d8023b16c6a15af47f9502d21132",
"main.dart.js_16.part.js": "fb13b3026c2a65beeade9e8110b8fb71",
"main.dart.js_236.part.js": "116b33b4db0cac5d9cd7524431b13250",
"main.dart.js_322.part.js": "9b0b60affea7837a4e589d62937f7c3a",
"main.dart.js_245.part.js": "ca45ffbd4a6d8fb3e3205917968f001a",
"main.dart.js_285.part.js": "793c9b48eeed4c5ae76c8e5bbad10a67",
"main.dart.js_295.part.js": "c27dff5cd506376ff73baf42b5d3ea16",
"main.dart.js_312.part.js": "fe251914728114687146fbdd605a5ba8",
"main.dart.js_307.part.js": "92801a3ea7f4f13e9f9fe7163e2d8b92",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "764295f3194240fe3e274d88546a854f",
"/": "764295f3194240fe3e274d88546a854f",
"main.dart.js_225.part.js": "6c67fee781f17993cca8cd2a9d35e5a8",
"main.dart.js_306.part.js": "55974c61f57d253cebea6f869ec4ff47",
"main.dart.js_317.part.js": "162b44a19f870a970422bc5732d11431"};
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
