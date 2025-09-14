'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "b728adb494b09431457a31962ec70ff4",
"main.dart.js_210.part.js": "00a810dd4e0afb7cb6f48c3423fb40e9",
"main.dart.js_300.part.js": "5a724b3de9c559156facbeb8add8c5d7",
"main.dart.js_228.part.js": "5cc803ee51bec9f1a5836e50a0c76ede",
"main.dart.js_257.part.js": "6df61a64bbaa58334a636e2811e99ffd",
"main.dart.js_267.part.js": "eac738d7887618e1e083bad20a756b91",
"main.dart.js_301.part.js": "fe3c4db3429c5e8cce2cf45e608cbef0",
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
"main.dart.js_308.part.js": "abed7e82e5f9b66fbc8538a65e4b34bc",
"main.dart.js_303.part.js": "2d5e2047da41eec8a9146ccd417e063e",
"main.dart.js_273.part.js": "b9d806234bbd07feec39f37e34896ccb",
"main.dart.js_265.part.js": "ccfe75249614e8f53fefe18025b09f4a",
"main.dart.js_319.part.js": "0a94181ba46168ee24a26ccf096622bc",
"main.dart.js_221.part.js": "91ff7883c0cb881ee9d7feb04a6968e3",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_263.part.js": "35fa616cefdb0b5b1182ce471b18443c",
"main.dart.js_279.part.js": "b7ae607003aca90069fd9d8c45611c3a",
"main.dart.js_288.part.js": "3f1d670350f2124ac71a7020211bf253",
"main.dart.js_302.part.js": "35f0670f8d45de36d0869f1750a3e084",
"main.dart.js_269.part.js": "8808d5f0d4ad41ec8886da52f14147e2",
"main.dart.js_305.part.js": "d791c91238b6ff4b98679bf7fd47641b",
"main.dart.js_293.part.js": "72c75954073b03c90094af313c17ca0c",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_316.part.js": "87132f278c9dcaf89e31ae0d2934f4a2",
"main.dart.js_318.part.js": "844efbfef074a736c49a7c3df2fb3fa5",
"main.dart.js_253.part.js": "3bf287b72f596d375c506a4ffd61e209",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "19f9bcfbbd3dfccdfe9f4473f0e6c928",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js": "41a48730616f9c0efb09b72274adf528",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "27e272d081e6132608bbb4aacbc52833",
"main.dart.js_1.part.js": "1f76c3fc3d16359296436f1aad2db25b",
"main.dart.js_298.part.js": "daa5b24ae037fefbf491354e070d9fe0",
"main.dart.js_261.part.js": "1d9d6c68024879fe0b54f69e6dffe4d2",
"main.dart.js_320.part.js": "8762dac828973bc09c9647e3dd7ac8c4",
"main.dart.js_313.part.js": "176eb03cc0da04f447d1226d5ee7accc",
"main.dart.js_213.part.js": "14b29c016f8ed67ac962f531131df885",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "6697f94a932a2946859c4127d2d380cc",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "85490f73dc81e596e659ad6c9eb649b6",
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
"flutter_bootstrap.js": "282a12e699a4e874b0c10d30d5603b4a",
"main.dart.js_242.part.js": "796e470c06cb70eebf734061d6c64fcb",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_277.part.js": "dd3172887ef5ad7fff68f2c0ffe480b0",
"main.dart.js_321.part.js": "7bb6f0228ae8e414a954dbf0283b9491",
"main.dart.js_286.part.js": "3fd47bef13a086c6c47710de0ac08867",
"main.dart.js_268.part.js": "b64c34bcd9776f2d1057caffeb83df22",
"main.dart.js_255.part.js": "f241693de06aeedeb3d0ff0215a8ac84",
"main.dart.js_278.part.js": "3ab991bf855caed00f1a5b44a1df7d74",
"main.dart.js_323.part.js": "365e3d714cdd2c37c04fd8849c30d54c",
"main.dart.js_299.part.js": "17b82da384dfc027345f4e67d802b43e",
"main.dart.js_16.part.js": "06f46c61f0ee9fb975ae7fcd79127172",
"main.dart.js_236.part.js": "a0a7416d9ca3d3f89494a1edd2888417",
"main.dart.js_322.part.js": "c0c0707410cc113a6038b5c83d7d0bc9",
"main.dart.js_245.part.js": "83571eafbcbd513154d1ad6c59acc7cc",
"main.dart.js_285.part.js": "8282e36966b146ff1533bbf4b2b0b382",
"main.dart.js_295.part.js": "3378d31cded2169688f329dfbcc5e856",
"main.dart.js_312.part.js": "7804f13de8be4f1267fe6ff35e2ad501",
"main.dart.js_307.part.js": "60a50da1cb25f66d5a941764f13345f4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "f419c3857448790b7777a39a7cb4f0df",
"/": "f419c3857448790b7777a39a7cb4f0df",
"main.dart.js_225.part.js": "6a994b981a737bd829aa98af9b92e5ac",
"main.dart.js_306.part.js": "a9dc6e28a6430f525ffb75f080b742ae",
"main.dart.js_317.part.js": "ec7a946e10f1e66a50d1a3369595139d"};
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
