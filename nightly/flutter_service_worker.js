'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "a4f016e20eb3a62aa6f602cfaba4efdb",
"main.dart.js_317.part.js": "4f55a5c129a079739c080a7e682cf18e",
"main.dart.js_1.part.js": "f7ad5095aa8d051e5c6306378fcef816",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "e5009d9741b92143d56b80239016e39f",
"main.dart.js_220.part.js": "a942fde2b6444bfb64e9a92a273d8eec",
"main.dart.js_274.part.js": "fdc4ed38579c0a259ad135ad2ef83da5",
"main.dart.js_318.part.js": "962a8f47a9b57cb8df6b47cf257944e3",
"main.dart.js_295.part.js": "2ede42afe3e05710a9a775d920a1e448",
"main.dart.js_316.part.js": "b40b452e611aaf9a5d6860a835352d75",
"index.html": "d5283dea0c599574218d4153077859e1",
"/": "d5283dea0c599574218d4153077859e1",
"main.dart.js_302.part.js": "4e026b2d80d0d9c48a93381f11e6ec02",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "8c8afe41ba72e3e8b8f93068abdda9f6",
"main.dart.js_242.part.js": "64c6a6d4b6efec424d3a74383da6e91e",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "864d12ac06e385056a1fee430176d65b",
"main.dart.js_300.part.js": "6045104871f89c5f2cb8ef2d2d924427",
"main.dart.js_261.part.js": "b5acf397f358d339570543b35cf159f9",
"main.dart.js_299.part.js": "9b594e5bf7ed137a0b69e90ea98df654",
"main.dart.js_322.part.js": "0b694e356258066d67068fe21e8cea2f",
"main.dart.js_263.part.js": "ac499657b84264b0516b44414469b790",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "28aa6d832975b8e00d8429e2a29dc1b1",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "03b914c4a1939a46bc0639cd4257e802",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "6295ba9c904551fc17a506d5bed814b0",
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
"assets/fonts/MaterialIcons-Regular.otf": "e43537443dee303909d6ef653cf99252",
"assets/NOTICES": "1895c67917f245177505cc36a357731e",
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
"main.dart.js_210.part.js": "19103cb970a61f0871e3578ba651bdc2",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "ea4dcc4e8ac0033f7ce3b6f965986226",
"main.dart.js_254.part.js": "172615617403c295dfd847fc6277488f",
"main.dart.js_228.part.js": "697163b4a1b936c00503a5cb6d4900a7",
"main.dart.js_16.part.js": "817f1fd19503c3aa115967462f813192",
"main.dart.js_278.part.js": "41b5f7a960776cd351803c97d2e56f67",
"main.dart.js_286.part.js": "8488de339c79dda4b0640eb4f66e1f23",
"main.dart.js_303.part.js": "724c524d3ced65ccfd2cffd746d2066d",
"main.dart.js_257.part.js": "b78a895c499d48e87edddf0e110ce8f0",
"main.dart.js_212.part.js": "bda2014e6e883d194fe8b60bb2a0c828",
"main.dart.js_269.part.js": "2adcf7995ec3df30882cb7bece4dd4a0",
"main.dart.js_267.part.js": "9be76e5084b7ec93f6df8eb1207f1250",
"main.dart.js_313.part.js": "b03366781d2e141fdbb07347bd156c80",
"main.dart.js_312.part.js": "e8c68aec45dbc91a82fbb39cbba49090",
"main.dart.js_298.part.js": "77ab43786a83cba972cfb7838bb10e6a",
"main.dart.js_285.part.js": "fd26952580f3391d394209c8bd1ad13e",
"main.dart.js_321.part.js": "17d4ba3981ff6a3d986b3985247ff6d5",
"main.dart.js_273.part.js": "da136f4c625a4cdddd758ea7912261d5",
"main.dart.js_255.part.js": "8a5fb11b4a34912c4685ac7e94aeb7cf",
"main.dart.js_268.part.js": "d60234ee08552507f32266d71d36740e",
"main.dart.js_288.part.js": "3141d595e9b2d398aa232cada4614a78",
"main.dart.js_314.part.js": "e523e770026b6e2c4da252a0f0b8056d",
"main.dart.js_307.part.js": "7ec18a2dbcd557da9d4549b8ce897dce",
"main.dart.js_279.part.js": "a2a8b07f06126b8c89a8f80674250e7f",
"main.dart.js_319.part.js": "f846ef4cc70ca30a01133b49bf7fe714",
"main.dart.js_253.part.js": "142288ea07657d3a6cee4af7d3ecf7ac",
"main.dart.js_323.part.js": "02c889fda26b584280c47bbc9b4708a0",
"flutter_bootstrap.js": "0300eb55ce63444e0d80c89cc62e1893",
"main.dart.js_306.part.js": "5780704b8150660e55c573d241944fa7",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_225.part.js": "bda00276f2d032c9808c0fcd6cf4dd9d",
"main.dart.js_293.part.js": "976a7ccc2fde26278d392023565965b9",
"main.dart.js": "22735459ce69df6574280910276e8166",
"main.dart.js_236.part.js": "18874d11dd70efe54872146e3f63f9bf",
"main.dart.js_277.part.js": "374d917677dd269d806659caa7f5a8b4"};
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
