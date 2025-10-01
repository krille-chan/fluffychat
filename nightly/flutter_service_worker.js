'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "40a04f5ab7a861f54ff5c02e0f475f1b",
"main.dart.js_271.part.js": "62e7da63333ae86a16f881911cbb2213",
"main.dart.js_259.part.js": "df7b11026becc95a007fcb5f51dc7604",
"main.dart.js_297.part.js": "9508ad24dc89f0867be4bb384387f5a5",
"main.dart.js_1.part.js": "bf7600e30cae030df94740e911b17c82",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "8f6359ab2031b0ce65d8ae7a831c8a58",
"main.dart.js_318.part.js": "18c3c1d4758fd67f4f2c64009ebab83c",
"main.dart.js_214.part.js": "3ace2819c63dd359737be8d6a529d8d1",
"main.dart.js_295.part.js": "33d4b8695969cd2c1d90693bb4605813",
"main.dart.js_316.part.js": "fd0008d107f866c1d1889ac49bbf070c",
"index.html": "a2a32bbcf1b5f3e16463d78ea7cd3600",
"/": "a2a32bbcf1b5f3e16463d78ea7cd3600",
"main.dart.js_302.part.js": "a674ae4117af686dcffc32367844033f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "168f99e479b5c1550052ff167d1ec0a5",
"main.dart.js_244.part.js": "0f365949ea9d2a34e5a948ca857d578f",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "47a493586694c671e1c4a04aa28fac4d",
"main.dart.js_300.part.js": "2475dfc4f753572e3be8f13c1d4d0981",
"main.dart.js_322.part.js": "5fa61de2f16c512a5ace54454fab6833",
"main.dart.js_263.part.js": "f44fbf26c65e17ae40a5fcc65e9f01e3",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "fed351b7d3293892dea2b852373decac",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "073e9e30394a624eea066fbc74d4597b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "210aef607e945c9269b82bdbafe67bb3",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "3e2515079d299e36d5bde0f85c09207c",
"main.dart.js_247.part.js": "0b08b14320bdf933bf55c8618393f76d",
"main.dart.js_16.part.js": "561cad66ca8a2b5a7a16ce37a1d8edf7",
"main.dart.js_303.part.js": "f048fac163cd73c079a9347712865daa",
"main.dart.js_287.part.js": "45b0b8f939f691de246c60dbcbdba7cf",
"main.dart.js_257.part.js": "9a30487e527318cde9a1bb29249ce54a",
"main.dart.js_290.part.js": "f98b03d6b12a3fcb2bc279b5f75d4d3f",
"main.dart.js_212.part.js": "160e3db47c78beeab18ec2ddc9e4301d",
"main.dart.js_269.part.js": "29de01c179f9c0b0d09298b219bb2e96",
"main.dart.js_267.part.js": "50ba77dba56569d1f0cd4700dcbb03ee",
"main.dart.js_309.part.js": "0d9274d6ed619317769f0543496680b1",
"main.dart.js_325.part.js": "dac8b30b551e03da1d4526775486e96b",
"main.dart.js_270.part.js": "4280edfaf6467e7910466fc8b8862247",
"main.dart.js_321.part.js": "03330dfa37f6028cc17ec45514caf2c0",
"main.dart.js_255.part.js": "aefd4101c0dbd576253910148a6dc553",
"main.dart.js_275.part.js": "d274a9c00cc712a5c8035243561361ad",
"main.dart.js_281.part.js": "91bd075cbdf5bc8603479e6c911ab31f",
"main.dart.js_288.part.js": "8200f567f9fe5db4509788d1e981af55",
"main.dart.js_314.part.js": "a61c12259807790a1c92ee987348ec51",
"main.dart.js_307.part.js": "0d44ea8e3c19528809091c1ac9b3edbb",
"main.dart.js_279.part.js": "98ad60685a6ca664f5460c711d501606",
"main.dart.js_319.part.js": "1663faa49627d7a835e044d20a86aa34",
"main.dart.js_323.part.js": "f84966ea1f0543dad6cecd5f5795f2a8",
"main.dart.js_227.part.js": "6834a193559a3d9e936ded360da618c8",
"main.dart.js_230.part.js": "3df3b468fa1781f3e816721eda100e96",
"main.dart.js_324.part.js": "dd4dd3a5eeb2494f11d7310315c63fa6",
"flutter_bootstrap.js": "c1e83e030c5b84a3bfe28f9ce0553be3",
"main.dart.js_315.part.js": "12ea5b1acfac2dc15aa7c11701b241ce",
"main.dart.js_304.part.js": "777ed2245ed71ed3bcad57e05fd9484f",
"main.dart.js_276.part.js": "a0490d548b8443ac631c58e5724de95e",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "3d5fb9af5069d9924ac16d2712bdb2a7",
"main.dart.js_222.part.js": "d512215d75bcbd144c292d850338a881",
"main.dart.js_238.part.js": "6ba70e1de1bfd0a870b61d4f1cf6870d",
"main.dart.js_256.part.js": "b3f42ffd15a6c19ec10677a8ef30b034",
"main.dart.js": "d991ee4f714a8c24a0de10accf201282"};
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
