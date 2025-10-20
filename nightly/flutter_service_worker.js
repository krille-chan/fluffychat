'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "89a26bb8c1d1bfa1ef7f2b8d0db33cad",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "9658a3b00a977d579df93162b6b885a1",
"main.dart.js_276.part.js": "7c198c870d7d15697d21ef73da3b2645",
"main.dart.js_1.part.js": "2061cc5553267868da9ee06652a8e72c",
"main.dart.js_284.part.js": "69778dc36a2bea4e4fc3642b265917ab",
"main.dart.js_325.part.js": "ded6c9475341582d10e0d24d563bd13d",
"main.dart.js_247.part.js": "79f729061445e4f284462ff3ae592596",
"main.dart.js_296.part.js": "72da342d3a09ad0492415133169718d8",
"main.dart.js_215.part.js": "39ad9f701b940063552e3d09aac3bca9",
"main.dart.js_253.part.js": "81348e9f25df24360fbc21f8564df9b2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "e611486ec0864da84a75700537c6fd79",
"main.dart.js_265.part.js": "f21e4cc358df1e326c53158416abe825",
"main.dart.js_323.part.js": "94f79b850bd1eef585d1b721b346cff3",
"main.dart.js_278.part.js": "64623c3d9323d0931c9d683e591fcaa5",
"main.dart.js_304.part.js": "9d7c47af80c855c00598234ac7044a23",
"main.dart.js_312.part.js": "ec21069727ea2dcd3f516d736adadebb",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_268.part.js": "bc3a3959040d66dbb17041203826622e",
"main.dart.js_332.part.js": "963be560c04e395e9d510a26699443f1",
"assets/fonts/MaterialIcons-Regular.otf": "ba6850df3f567a02f3e4138adbb19518",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "ccdf35ac6bd19b2bb529bd7a40361920",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "12b647a2f24e7587fd288474bf6c3a65",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/NOTICES": "ccc7b438b6733657324389d49423afca",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"main.dart.js": "f8bb7a8d3d96ccb74d65012edd3c4720",
"main.dart.js_279.part.js": "f7a2f3f75a1812c79126137bebc52704",
"main.dart.js_324.part.js": "f0df7f7730d44a25fb6d890b2909a09a",
"index.html": "7678372ca8cd016750b2949381f1bce6",
"/": "7678372ca8cd016750b2949381f1bce6",
"main.dart.js_297.part.js": "fa67701fc9d999488a73f71886e52ee7",
"main.dart.js_318.part.js": "af0320b205a4aabe40fd684d21ed764d",
"main.dart.js_290.part.js": "69b7e76912289c5ab5556d670252910c",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "a189e52ac663f0b857202297ee60933d",
"main.dart.js_274.part.js": "a4d97b65efa12bc98c2bd94cafeb14c6",
"main.dart.js_272.part.js": "96e727295ab81f3816b6be66b806aef7",
"main.dart.js_264.part.js": "33407cb39c3c0e57ed7fdb9ea37e28ed",
"main.dart.js_288.part.js": "58673f37a3a3d5dde84e7cf24550fc10",
"flutter_bootstrap.js": "d79fb662aa6cd2cf30136a43cac13840",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "5e86a3fc6845b0ce335dcfb24faa35aa",
"main.dart.js_235.part.js": "e0d40100600c9b0cc6adebe67ed5cb77",
"main.dart.js_280.part.js": "5a39c2af34ee87d1b35b74a048560330",
"main.dart.js_289.part.js": "63986016cf6f7469cdfb766b77df7f87",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_299.part.js": "883764853c42864bab85d3c822f8d838",
"main.dart.js_217.part.js": "f9f61b957e2ebe9725b7e63bbc71005a",
"main.dart.js_330.part.js": "e4d8b246ba2b33cafb276bf1ab9c9d0c",
"main.dart.js_334.part.js": "5039ae736be7bcef9fa4ca417c6e8e04",
"main.dart.js_317.part.js": "655d19132a8ddf8da49fdbf456cbdf00",
"main.dart.js_316.part.js": "c61f3eecb637fd1188e723976fb61080",
"main.dart.js_327.part.js": "b098d2998ca6c40ee191ffaabd3ad056",
"main.dart.js_328.part.js": "bd83565dc472ec1ab58c58cf50337249",
"main.dart.js_311.part.js": "53c8fbe378f6a321075377e8a653877f",
"main.dart.js_314.part.js": "824afd8ac5f9c5b803bdb2e5a4f0c0e0",
"main.dart.js_223.part.js": "99ec7ac62dbf0c1f49f7ff267671c4d4",
"main.dart.js_310.part.js": "4167bafb2bc5459495b704435a831fda",
"main.dart.js_319.part.js": "ed9950c2748d2ee1e38104235c7120d2",
"main.dart.js_266.part.js": "766d80cf7b25cfe1e11cf640d29e05a9",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_306.part.js": "68e0fb8071d9e039bbdb4b33cc2d06e4",
"main.dart.js_285.part.js": "d7ac157616ab023fb452ab4242ad32c3",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_333.part.js": "82504f47b17d1d7f79c8f0eb5703ad49",
"main.dart.js_238.part.js": "9d89bc003325c6bf201342bbb3728ed8",
"main.dart.js_256.part.js": "d8fec93e0db5742f67faa8a811aaaa1c"};
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
