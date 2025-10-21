'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_317.part.js": "6c3bf973f228dddfae3ce85a711819d5",
"main.dart.js_297.part.js": "7723f9820ded5c457bd77be8267123f7",
"main.dart.js_1.part.js": "5c3a9743a177403cafc4f772149bf3d2",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "3ab68a7e814768992b0e535a5ee564a8",
"main.dart.js_280.part.js": "ba7febc9d6fe37fc0d6cb15a775d4fda",
"main.dart.js_274.part.js": "7650c8f4983767745ecba9fb2f85ef65",
"main.dart.js_318.part.js": "4020334695be415d312d99feb2662b60",
"main.dart.js_266.part.js": "e78e13b6c5f3b7bcd844dfbc7f63f103",
"main.dart.js_316.part.js": "cc32e6fac7c99b655d644a642f0f6653",
"index.html": "5c9fbdf912bc71e4ac00b8cc32cb2e7c",
"/": "5c9fbdf912bc71e4ac00b8cc32cb2e7c",
"main.dart.js_217.part.js": "6f7e1715a05bdd7b53eda737678c1e8b",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "15f05c3b2ad2993a280a4244db7a4877",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "d960c5fb14b1dff07b8ea96d9073ca95",
"main.dart.js_299.part.js": "a6002527ac461b4dd5aad569707519ec",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "aeff3a8cbbe30be0c1c1f4335d60ba12",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9357c76127444b43171bafd2614b3485",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3bf888040a3a4aab43d4c59b8307c58e",
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
"assets/NOTICES": "21facb93fb24950610f982412598160b",
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
"main.dart.js_334.part.js": "251e802baabba3b2860f73040669f3fb",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_247.part.js": "24f5063faae7f1d13cbe6836e8660239",
"main.dart.js_284.part.js": "29283c7a5f6a3ae8bf830e4aea56bffd",
"main.dart.js_16.part.js": "c8a5793b9d40444c9663f9525cb373a4",
"main.dart.js_296.part.js": "602c71f2440810a493a08b3f2cf32a24",
"main.dart.js_278.part.js": "ac6c5efdee4b109355362dc1d042f230",
"main.dart.js_333.part.js": "3b7e6fb0bab881aa8ff457e571350b73",
"main.dart.js_331.part.js": "cce562af7fbbe0159aa369873c4d7cf5",
"main.dart.js_290.part.js": "c49def322bc8456847a93440a4e3df93",
"main.dart.js_313.part.js": "eeaff05a2f8929da3ca255794ec372a6",
"main.dart.js_309.part.js": "8b47bb488830e994ede7402847e26366",
"main.dart.js_312.part.js": "853001e87ca9892aba348771162ea794",
"main.dart.js_325.part.js": "c402da9c5fafbf12a0f54a2fefdc8ea1",
"main.dart.js_285.part.js": "9d93de58a82b5a97ad000b722c18f5a5",
"main.dart.js_235.part.js": "c93b5aec8160327f8d93d90cb2ccddc7",
"main.dart.js_268.part.js": "bcf75f945ab8eb47f06f44280af70a23",
"main.dart.js_332.part.js": "cb7329e26e1fbd9d26001aead405b0e1",
"main.dart.js_288.part.js": "11ce70be32b4409f8964cdf99b8740d2",
"main.dart.js_314.part.js": "676a217088097d18d11248b1f826d512",
"main.dart.js_279.part.js": "1c332ec5b2fd3a8f848379a7b9cd95cd",
"main.dart.js_319.part.js": "d59d77bfc22061d3054832958014fb32",
"main.dart.js_215.part.js": "45aafa873045f617c32c34b979006933",
"main.dart.js_253.part.js": "ad7244aae057ca83d3677d51776ff3d1",
"main.dart.js_323.part.js": "0f3dc0d7a299d337e9ac5d51ecca6b9d",
"main.dart.js_324.part.js": "78115635ed4d8da9cc58c66ad0f024c3",
"main.dart.js_328.part.js": "c64cbce2f41544c417c4a67267b07299",
"main.dart.js_289.part.js": "a2e649ccead19e6213572fd279bfd679",
"flutter_bootstrap.js": "5f9003eba5cfb812c629c8744137f880",
"main.dart.js_304.part.js": "594d560ae9913c6d1bd04e5d700eda9b",
"main.dart.js_264.part.js": "8a674874d849a89003a42f71de0ca1a9",
"main.dart.js_306.part.js": "b60bc22d6c2dbb0c6c0930ed517a13f0",
"main.dart.js_276.part.js": "db804a95a7b7e2e975809630b5e9dfab",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "587c4f227ed759016f322517434b051c",
"main.dart.js_238.part.js": "58a1f3041ca17e6714bb02f4e901db86",
"main.dart.js_256.part.js": "7e566f2368b166ec93bb5ebd35e27e14",
"main.dart.js_329.part.js": "219bd766755f29322c1e9afd23956020",
"main.dart.js": "184736f8bed4ff1fdf0c14d466a89acd",
"main.dart.js_272.part.js": "bda3428934064004abf99e1ff9ebdb52",
"main.dart.js_223.part.js": "dfaf7aa55f0675783eb0e890036b4318"};
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
