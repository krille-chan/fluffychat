'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_318.part.js": "fbf2b0ccd4dec7ffd0c63e4b558f532d",
"main.dart.js_303.part.js": "73e3854d5467666e351b9d081587efa1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_289.part.js": "39a18fb097bada8462180d4431cc1771",
"main.dart.js_320.part.js": "095a8acc429ff51215c01ff556c2232a",
"main.dart.js_246.part.js": "87632ba6992db4f09c4234a5a86af91d",
"flutter_bootstrap.js": "e2b4be6036005678570d1fc72e5a8569",
"main.dart.js_211.part.js": "c4e937597487c421143d96d02ac130f6",
"main.dart.js_274.part.js": "dc05bf8304e5331951465875f8579045",
"main.dart.js_275.part.js": "9802ad3599101cbe8467e527c9cb4fb9",
"main.dart.js_254.part.js": "c3b0ae608b6fd7ac7a50a65120208c83",
"main.dart.js_269.part.js": "1e651c57a61c8aa62fcaf8276580a9c9",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_16.part.js": "8482f4f4d2d17104f909c881534d13d8",
"main.dart.js_315.part.js": "18693ebc3c7e3ef0203f59bf6a295aa1",
"main.dart.js_301.part.js": "568c1eea7762d67dbe35db0b73345963",
"main.dart.js_299.part.js": "bc5c06659134768c1892427362159e75",
"main.dart.js_237.part.js": "576a23a6e3625cd2d2791566b5394dba",
"main.dart.js_306.part.js": "1f08a34d99127fa4445a3bfb3cf22297",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_229.part.js": "b4684c28007d46122b6624f17aa98237",
"main.dart.js_214.part.js": "ad84dcff2c561e343318296fe871d5e6",
"main.dart.js_302.part.js": "4378b3fcda33acb9fa3d15c53701e830",
"main.dart.js_321.part.js": "0755d95372069e308aef0052a1ca2279",
"main.dart.js_307.part.js": "06ea96c0573e51752e6d5fda3636a1f4",
"main.dart.js_314.part.js": "eff5d3aeb388d9ba0371408cbeafc62e",
"main.dart.js_243.part.js": "bb0d203da2ba302fccaf6faa10c2061d",
"main.dart.js_2.part.js": "611010805dcb56081c8408ef9b74dbd0",
"version.json": "c39aee0353c6ad9b93e18f82170c8248",
"main.dart.js_258.part.js": "50d494dd7184be56a1cca6e988ec88b3",
"main.dart.js_256.part.js": "cdacc4d3cc94d0f2325e8dbff1771912",
"main.dart.js_270.part.js": "80ff68af54a84557cb8413047790c44e",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_313.part.js": "162428f5e75d1f6378a3217c268d6cd3",
"main.dart.js_268.part.js": "cb03edaf3376a709ad4b6aec911bcf52",
"main.dart.js_308.part.js": "5e7900d33b03bb1b30c881933a05d96f",
"main.dart.js_278.part.js": "01d8c612786f236ca0267cb908ddf74a",
"main.dart.js_266.part.js": "5011542e3d642200a66ea2c7bf2047da",
"main.dart.js_1.part.js": "f20cd86f73caa9493e40563727746eb6",
"main.dart.js_296.part.js": "ba33d15443210f3bf927716fce4a3f27",
"main.dart.js_323.part.js": "49fb61a34cd331b47875fae0978c6653",
"main.dart.js_279.part.js": "24a291462eb6fd9c633a86941b664862",
"main.dart.js_226.part.js": "70691e54b13434977e5356dddb3c22a7",
"main.dart.js_255.part.js": "f5d43244e7caf036d2cd8208ecb8839b",
"main.dart.js": "2383caec5c72b24a3af275882f3ac0ae",
"main.dart.js_304.part.js": "ff73b25fc3a86bca2f7612521e6161ef",
"main.dart.js_286.part.js": "8c95fe88fb6786f3cce16e06a651c343",
"main.dart.js_322.part.js": "1213f4be5b9c59c8c507c7fe4acc03e7",
"main.dart.js_287.part.js": "8cb142fc00dc6befb7641650942af8be",
"main.dart.js_294.part.js": "90110926a670a2246aa450633c37a511",
"main.dart.js_262.part.js": "0ba7d5d13bc1df68882d0aacb1be5a4f",
"main.dart.js_309.part.js": "34af74c047fdb19680c962b603788aa3",
"main.dart.js_280.part.js": "df28e79d4b16ec74fb44fb5c929e7d6a",
"main.dart.js_300.part.js": "2fb10cee1b5f30065ea57f783f9d38c7",
"main.dart.js_222.part.js": "f270a13bd11372cf096b0cda0be58fd5",
"main.dart.js_324.part.js": "157317bd3704cfa7a98761cf435f2d28",
"index.html": "de971bf881e67174de7779a88ef9a64f",
"/": "de971bf881e67174de7779a88ef9a64f",
"main.dart.js_264.part.js": "195a3dbde5627e97241afd522168237d",
"main.dart.js_319.part.js": "7959bc5a06bc70d731d29716d6494c95",
"main.dart.js_317.part.js": "b766f96fcec6047370cb91aa386542b6",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "a3f123b040698ff8aa5ead1d8d3815c0",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "12f5bb4260049ea123aded62c5ea182e",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "f470c45d72d17379d492122b1d72b44e",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83"};
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
