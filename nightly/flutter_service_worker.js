'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "584c5c2584e33a47cf6331e7b51d0004",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "b3e2121f91cdea9ca364cd1ce9d5130d",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "fc1b311b2b0c9045b9a05ebb10386320",
"main.dart.js_308.part.js": "a41d4ab9de2d4b56acc322d4799ffbdf",
"main.dart.js_1.part.js": "4087a2a84e90c3bd965c14ace5681cde",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_311.part.js": "1d08e9acc38dc6404cdb53d637d4ee1e",
"main.dart.js_274.part.js": "4cdcfb96178f0b142046258bd34fb690",
"main.dart.js_318.part.js": "d9ad163aa120d93ade1796f0c3894a51",
"main.dart.js_214.part.js": "105708ac6ef0a2f8fceacfde2e97c0ba",
"main.dart.js_338.part.js": "51468748bbb6d0b16f287d94e02cd3be",
"main.dart.js_316.part.js": "2ac4c6b74b6293d245f6a03ea4cf2b1c",
"main.dart.js_246.part.js": "192d877aa53f6a798791f791a89fa064",
"index.html": "21449501189e97434f570a8425c9dabe",
"/": "21449501189e97434f570a8425c9dabe",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "d74aeb8b1d0b6c70aebbbe6cd111e2da",
"main.dart.js_2.part.js": "2b138bb039cb1b661fbe9172bdbcf34c",
"main.dart.js_265.part.js": "16e903d9ed2a008badc5f6691f7d8355",
"main.dart.js_299.part.js": "06fd73a036c94eb84a171f53394748de",
"main.dart.js_263.part.js": "d7ecc03efe3a0c44f5951b8ced4f5754",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "779ff677ee6cb6954f9a8869bd98d9dd",
"main.dart.js_301.part.js": "b2b779682d23790b2346bf4d464ea2bc",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b477e6e03d77d74d108fad0ad2a687d0",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "7f4bdbd9c59d42100e883d30b6d84105",
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
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"main.dart.js_334.part.js": "947b2c91cae9e98b81161bf50e29cff8",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "006dd51c2ce0100294290e4f61b45556",
"main.dart.js_292.part.js": "8790d42faf4eebd3cc06b9c6619e3b32",
"main.dart.js_278.part.js": "dc7959d588a9564fe3f0dc2c1dae26e2",
"main.dart.js_229.part.js": "c3e265103e9a2688a8f741c371408fe4",
"main.dart.js_286.part.js": "a50964f4e58f6e5b1b23771a40fce8b6",
"main.dart.js_336.part.js": "b17cac317e94652f50c7a32ddcbd833f",
"main.dart.js_333.part.js": "55bd254f51d4dbc0ed367669f81c28eb",
"main.dart.js_287.part.js": "6421eba81756ede0513d3ba29f3a146a",
"main.dart.js_331.part.js": "03a4b2c5cc777da62b61ca23c4016074",
"main.dart.js_252.part.js": "46391fb6037bc20db97e311ea7c9fc80",
"main.dart.js_237.part.js": "216c6b801e752c93e2d839c0f8ce51fe",
"main.dart.js_290.part.js": "fc992022569d2cf15b35490fa99ea886",
"main.dart.js_267.part.js": "857837d91937d38a5a8e3127347e4d5a",
"main.dart.js_313.part.js": "d18e547fbb4d19e80e8d3ec9e7bdc416",
"main.dart.js_312.part.js": "e7fa2f33126eb5c5501c4aa042cc926a",
"main.dart.js_325.part.js": "49a5ca9c5d61730659580d4f1303bdb1",
"main.dart.js_298.part.js": "51fc96f04fda002207ccf6e2907262c2",
"main.dart.js_321.part.js": "6623fee770be351f33154af2e6d4321f",
"main.dart.js_255.part.js": "3d71d64136aead6ddd5b7218e2a4b738",
"native_executor.js.deps": "70b012251976c9b663043cc28dbb42a5",
"main.dart.js_281.part.js": "6cab686d8ef4b4877646c6e61e6fc2e2",
"main.dart.js_332.part.js": "78cb1bcb8b584b1185ab6a4c923065b4",
"native_executor.js.map": "f024cc1fa3b0f17d8be25ff637b0ce29",
"main.dart.js_314.part.js": "20d7344bdadb00ea8ea438231666d05f",
"main.dart.js_216.part.js": "640ddb2f49fb6dd87cc9ea7f1aec6616",
"main.dart.js_319.part.js": "1a2560ceaf0eb2607b247a4875d331c9",
"main.dart.js_328.part.js": "c34f91ab60bd34c4757cee36a49f394b",
"main.dart.js_337.part.js": "017be410591daa35e18efdbea284d9e1",
"flutter_bootstrap.js": "5ed1173f00266016c6ad2c4bf3de8155",
"main.dart.js_315.part.js": "19083c6c879b97f5a03525dd83ff04ea",
"main.dart.js_264.part.js": "6f242d76f14e4791f43e230d1d5a154c",
"main.dart.js_306.part.js": "47cc03305f11d14137196a746295c3fe",
"main.dart.js_276.part.js": "ca6630820c25441b240ebb1742be7f8b",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_222.part.js": "5991ed418c429861db535eb86e6073e1",
"main.dart.js_326.part.js": "f009342a9bb65d30bf7f249e2528de7c",
"main.dart.js": "fec82b97bb3eea9b427d789b8ecf661e",
"main.dart.js_272.part.js": "50e4506d93955c9cce1ca7a2992f86ba",
"main.dart.js_17.part.js": "71468572638b88b5dfb16d3bfbec6fee",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51"};
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
