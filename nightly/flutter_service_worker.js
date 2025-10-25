'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "119fd5a5574291b5de9b50e63ec88f2b",
"main.dart.js_317.part.js": "e404788d8435a28b99b0235973313669",
"main.dart.js_1.part.js": "0f76a7405a66a309aad4115201563cdd",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "b2c0334a3efaa2093e465dcba6ecdefc",
"main.dart.js_274.part.js": "1c02ffaf87d4abd6fe6f8fcec528ccbf",
"main.dart.js_318.part.js": "3820ea922015871c4d80049a8377d47e",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "bbb532f185318a58f60f23b760fcef30",
"main.dart.js_316.part.js": "c6f18d7ea3b93bb67e212f51c5bf0bc4",
"index.html": "85a6b72b02f63c390ffedd307eb30e57",
"/": "85a6b72b02f63c390ffedd307eb30e57",
"main.dart.js_302.part.js": "7372fb06d4b1722e4cc962b3299950d0",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "3c79e88257bacdede5a7c3d57ef91f1f",
"main.dart.js_242.part.js": "fbf917457d134a3a9888ba2e203aeb9a",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_265.part.js": "b9d82d46a0a184078d7967088748e5d7",
"main.dart.js_300.part.js": "3d9603f7edf4bc0945a5ab6a62327c12",
"main.dart.js_261.part.js": "8b17a01aab89eed53ed4c5ddf4554ebf",
"main.dart.js_299.part.js": "0e93df268d2b948c0c49ed0971541ea3",
"main.dart.js_322.part.js": "e69d7b3b168c1f921bb7a92f68ccaa05",
"main.dart.js_263.part.js": "d37275fe745789a5c3278b5ddbe1de23",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "bc2714e878f11aedaa219b81e1d3a146",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "0179fdcaba1b2ddbf03730c157a211e3",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "09c8dad51f58ca92603b75130c7fabcc",
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
"main.dart.js_320.part.js": "1ad138253de31d468baccefd6dc833b0",
"main.dart.js_254.part.js": "30280b54ea631406d34802f8a11f8ca1",
"main.dart.js_16.part.js": "d2dde02b8e80c8598e5b866a285d9389",
"main.dart.js_278.part.js": "42f414a71a59e0d9bf59db13a589781a",
"main.dart.js_286.part.js": "5fd7399d03b6d0c2e53249fbc27dca09",
"main.dart.js_303.part.js": "40203731b15132e601b1510045ee07ec",
"main.dart.js_257.part.js": "d2a4869aa35cf094e95f68f0ab7d7092",
"main.dart.js_212.part.js": "1e58d71bafcb31b2d842d6bfeb724056",
"main.dart.js_269.part.js": "0a56ffe7de1da2f2b434751129464496",
"main.dart.js_267.part.js": "eb681cf9fd0b538fca984184ed335e98",
"main.dart.js_313.part.js": "539f5ae14d7de60d02c2e3210f889f89",
"main.dart.js_312.part.js": "0f393664b37e862974604d8ac1be3544",
"main.dart.js_298.part.js": "366c68d3afc1c1b89e7e5c19d5748bf6",
"main.dart.js_285.part.js": "f5e5b4698b64f23eeb38968e9d7ab6f1",
"main.dart.js_321.part.js": "0bed69ed9ad1828540fd116062146c9e",
"main.dart.js_273.part.js": "3d6411848e006a76b3055e9c811af74d",
"main.dart.js_255.part.js": "7193374924f997ba1edf8f4357475c17",
"main.dart.js_268.part.js": "039c8f8c55fe525fcb3b7b6fc01142e4",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "ebae16a697615c31a451abb6afad9a61",
"main.dart.js_314.part.js": "0c2b9cf094406d30ef355fb56725db2a",
"main.dart.js_206.part.js": "45886620a5025d6bf7aa2ba911ac0655",
"main.dart.js_307.part.js": "de15602f911414780cd2588299180eed",
"main.dart.js_279.part.js": "d2766e1997f13a3a873abd581b0a7d99",
"main.dart.js_319.part.js": "f1ee209d55548b5746df17b6430543b9",
"main.dart.js_253.part.js": "2169da635cdd8bbbb376a9f824bf18a9",
"main.dart.js_323.part.js": "818bd232f5a09691b10b7b783462faf8",
"main.dart.js_227.part.js": "d94e5bdac43b959f009ca8d104fd9da1",
"flutter_bootstrap.js": "3fb0c880f363dd7e5235184444954809",
"main.dart.js_306.part.js": "9c231f539a9dcc5061f22e3e9ad8a4aa",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_293.part.js": "17dea18a8161b4c8cebeecfb62d9ed27",
"main.dart.js": "2b4660bfe0ea1dd8fdd792065c659dc8",
"main.dart.js_224.part.js": "1c5d9e18d54aa727b8ca26434c1a5f92",
"main.dart.js_204.part.js": "bff3401c43ec7165ecbd6975f4f1e672",
"main.dart.js_236.part.js": "6c7997a7b1cd6228ad2b9a0035a2643b",
"main.dart.js_277.part.js": "2cd194ee8ed1b1e430c6f0d679071408"};
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
