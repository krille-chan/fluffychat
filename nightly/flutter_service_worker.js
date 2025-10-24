'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "ac80424387ce0bbbb4a6d470a8a99f6a",
"main.dart.js_317.part.js": "981103c48973cf1b8f10bc213e2f9dfc",
"main.dart.js_1.part.js": "ba1438b8a913577f897bdb8978080a80",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "92cbca5832175c0be3d9c7c2c6cf570a",
"main.dart.js_274.part.js": "434dee0eade566b19f3eeae7d8698af9",
"main.dart.js_318.part.js": "79ed8fd6165fe2ebed5fbf9111b8e110",
"main.dart.js_295.part.js": "d16fda507f49b0393cdaacb571db7040",
"main.dart.js_316.part.js": "c8a5a288369913c01327dcd572dc35ad",
"index.html": "fbfb28604e707af6c3be91f447123f85",
"/": "fbfb28604e707af6c3be91f447123f85",
"main.dart.js_302.part.js": "04342f1b1781dc586b00f9e1c5f17ae6",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "9d776a709f7a9da0c7acd37afcbe47f2",
"main.dart.js_242.part.js": "f93e438a4e515d56b3dfa5e828f22329",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_265.part.js": "d78f0759e518be789559494d840a095a",
"main.dart.js_300.part.js": "3965b7f1b35e0577bf219a1e9dbdbd71",
"main.dart.js_261.part.js": "d937cc037708ded2955fcfbdb9af0d6f",
"main.dart.js_299.part.js": "97468677ee5b5226c6658d8bb2fe2e44",
"main.dart.js_322.part.js": "e2d1516ca553a27a9498facbd9171ef0",
"main.dart.js_263.part.js": "9b51efdc4e792909144e01a14f8fcba0",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "8c1396d0eb4773a80c4edcc31061900c",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "128bcd72739549260b896e6e7915bde2",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3a20249a2e4012526cec1bfc5d9e92de",
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
"main.dart.js_320.part.js": "d74ece92146e39b2ee979d0d5bdc70f3",
"main.dart.js_254.part.js": "b5218d232949f7b66da4d2c8e3f4cf05",
"main.dart.js_16.part.js": "5f7743978a0edb922942ccc631c08dbe",
"main.dart.js_278.part.js": "7a6c641b66b7df21e100648acfc8db3a",
"main.dart.js_286.part.js": "73b4fa12cffcde9adaa7f66950d7177a",
"main.dart.js_303.part.js": "f52bddf3d204cba23a2107a84cb04af0",
"main.dart.js_257.part.js": "74857f94b3a79803a8a42a8a03d3fde4",
"main.dart.js_212.part.js": "ea5e86649c7486121c130ce8468ce92c",
"main.dart.js_269.part.js": "2a20aad53063e0249592320c609f9d5e",
"main.dart.js_267.part.js": "9c1d70ff38b29edc16a1e842689513a1",
"main.dart.js_313.part.js": "b0c82fe66adf45e91bde136280bd4f09",
"main.dart.js_312.part.js": "30b4911f01de3847e1027390c5b167ef",
"main.dart.js_298.part.js": "87bb9f8c1d743ec24182b468f0937a63",
"main.dart.js_285.part.js": "754b0cd1692172f922087de62a538898",
"main.dart.js_321.part.js": "f98b96c194af28cce9b4b9795b489e0e",
"main.dart.js_273.part.js": "407dfda5ffd8a7541aa18783540f5262",
"main.dart.js_255.part.js": "3eb0f3679ee3e2241f34ddd135bc7693",
"main.dart.js_268.part.js": "db150c5cd41321bd0882d2d29b9e38f8",
"main.dart.js_288.part.js": "e60f955f72b65f31f677a835914f2333",
"main.dart.js_314.part.js": "625cb0d1ef3c27de8f56aab1fab7d716",
"main.dart.js_206.part.js": "fd338833ec6042771d6ab2e2904b1cf5",
"main.dart.js_307.part.js": "d7686bc5fd72c39c36e3cef6919c67cf",
"main.dart.js_279.part.js": "b1a6fce949602015e95fa3da34b92d9f",
"main.dart.js_319.part.js": "332929def74cee7572ef95733c1257c5",
"main.dart.js_253.part.js": "e74ba23b2583d65333898a81ddc4b400",
"main.dart.js_323.part.js": "f7fab5a05a85b9662049cf160a35f4ea",
"main.dart.js_227.part.js": "7c8383609d28b72ab5ec79756b7e2509",
"flutter_bootstrap.js": "a1768c5ac3a0b81de43e860f81299a0b",
"main.dart.js_306.part.js": "54d1ad812a2cf9f90686ba437164d53e",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_293.part.js": "61c77c17a0fd047e214728b73692044c",
"main.dart.js": "632fbbde67b6967489ded817dc0f371b",
"main.dart.js_224.part.js": "13d98bd2c7d3d4bc47c33ba5b5b0a9da",
"main.dart.js_204.part.js": "0b18035bb0014bc578e5aea49b8c6390",
"main.dart.js_236.part.js": "4f2668e03120d3f6599547a187b178d0",
"main.dart.js_277.part.js": "ea2cdd712a0d9631f21eab8a61dfde12"};
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
