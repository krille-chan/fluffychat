'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "e1b97f033399641c42b32fd3773548df",
"main.dart.js_308.part.js": "cbbf816bc2c19b897b42deb3efeb1891",
"main.dart.js_243.part.js": "0288158e9a8d9766fe9299045d9b7ee1",
"main.dart.js_1.part.js": "3c4e217a9cec8cda3a200789cf93fce5",
"main.dart.js_260.part.js": "896bbf2cf766a6c9e353af4658d2225d",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "ceccf813d11bbee9acaae2e3e0e737b5",
"main.dart.js_274.part.js": "9a9d6730a1af805bfbf0aa44f643a8c7",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_211.part.js": "0d375cd45be71e9d2d097f35f4b0b948",
"main.dart.js_234.part.js": "9cfcb954c90a8202059083580010c906",
"main.dart.js_316.part.js": "a4af834c08654257f235a2b98967f1a0",
"index.html": "39976e28a068382a547ec9ab3f57a844",
"/": "39976e28a068382a547ec9ab3f57a844",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "6c2fbacd56d31b9fa326a6827c2c67ee",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_294.part.js": "899907bc11c4081b7bb3c1df98c83c3e",
"main.dart.js_261.part.js": "33b5c1e7cb39acc792326c3ccb2d5994",
"main.dart.js_262.part.js": "711acb09e96c1f9293ed3bdff63aa153",
"main.dart.js_322.part.js": "c39d148bdc5e40491ff2d3b8c53c7af5",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "797d4ef8b1442e25227e99a66379fa57",
"main.dart.js_301.part.js": "72c4b0403bb0164fb5d71be98b45c3aa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "046d7d18473e7f36dd57a6ccb00609a4",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e76bf05cef114ad9cc92982a52ab64d5",
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
"main.dart.js_320.part.js": "c853861303ec52fd62ec6a054f462e2d",
"main.dart.js_16.part.js": "8a5100b73eb6fa01ef4dffda82e3ad70",
"main.dart.js_296.part.js": "29fd905f8ac45b0c91ae87f6bc158ead",
"main.dart.js_286.part.js": "e233eaa5c6974162734b0afaa9700827",
"main.dart.js_303.part.js": "c1cb2b7309692d2f29dae3e5c52c1e13",
"main.dart.js_287.part.js": "33481e04039f82c0df9e4144e9dcf1d8",
"main.dart.js_331.part.js": "d4c68388757a8ac448be8d0ad0a65e50",
"main.dart.js_252.part.js": "183442af303e6faa34385d257ff3d32a",
"main.dart.js_213.part.js": "ae047e882e1acdf573209caa9ddb990d",
"main.dart.js_249.part.js": "b322795b2ec945877a68e7a88c86b6fb",
"main.dart.js_313.part.js": "d63968739b51cb4be34fffff37639627",
"main.dart.js_309.part.js": "62844b3e2133c9b949b1829cb8e0346f",
"main.dart.js_325.part.js": "fac3ed877c0b22255452f7129fd6e008",
"main.dart.js_285.part.js": "d1fc3fa21d2ded78521edde7f78726df",
"main.dart.js_270.part.js": "3b08bb128360e6860b0cf07fa09b75a6",
"main.dart.js_321.part.js": "677bdd821a514a3999041c65c40b7581",
"main.dart.js_268.part.js": "a881ab6c7529b318913bce1b06bf619b",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "06e5068713e9344acba7408197856987",
"main.dart.js_314.part.js": "bfa90c0ce3601a48ad80f0949706a12d",
"main.dart.js_307.part.js": "b7a434dae35c3d76f62f4342c844df1a",
"main.dart.js_324.part.js": "57aca6e694236e5a01817714ea3c1297",
"main.dart.js_328.part.js": "74e7c0b54b002704ccd53b47fb9d7120",
"main.dart.js_231.part.js": "356fc8a74ac2bec2b0a62b0a0ca0d1e2",
"main.dart.js_219.part.js": "5b397597ea4e6a32969f5d038645f3df",
"flutter_bootstrap.js": "2912054f2529e041f75e18cbaf442ae2",
"main.dart.js_315.part.js": "86eeed1c7fd9637451d775a93608ca11",
"main.dart.js_264.part.js": "8a53e6ddd1237dea559d4b0a9767a0ee",
"main.dart.js_306.part.js": "275d063a1a6d1bfb267e9469d39a7fe5",
"main.dart.js_276.part.js": "659826d2df2a67f54053c367b28ce0b4",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_293.part.js": "96c7a5d1fa5d1e6f929fb046b74c14f1",
"main.dart.js_310.part.js": "679026cd9ab910689e2aff9a8a1eaf1b",
"main.dart.js_326.part.js": "80b807ee36ac76da31ab5add28b86f82",
"main.dart.js_329.part.js": "61cea97bbd6b388b02368c7778674a04",
"main.dart.js": "8111732b22ec874e78ba2a1d2176a2ad",
"main.dart.js_272.part.js": "c4c2fb715f07730ea104823b2e28392f",
"main.dart.js_277.part.js": "6e21768fd71fa2b29807db3a7477f4d1"};
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
