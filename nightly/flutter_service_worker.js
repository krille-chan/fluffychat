'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "f4802b6d7d7377c5598a4f7ffc4e452b",
"main.dart.js_271.part.js": "fe31e575fdb7cd8b08a0df0f71518fd4",
"main.dart.js_259.part.js": "b7811cc3131150df20f310911fe3837d",
"main.dart.js_297.part.js": "a3f7beae230afa4c3b55db8affbbd7fb",
"main.dart.js_1.part.js": "e345ab9242cdce3485ad7b83712a57a6",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "168216a81738d7108e7223211e042bee",
"main.dart.js_318.part.js": "d22013bfb7711a23b0c6d18e999ddb4e",
"main.dart.js_214.part.js": "60bda24d859f7a5b63fd0af695d12783",
"main.dart.js_295.part.js": "0a401caddba237254d8be26fa0d0febf",
"main.dart.js_316.part.js": "3cfca2d0dd2a556483931b29c3247e1d",
"index.html": "c3eae09502219a0979245d423887572a",
"/": "c3eae09502219a0979245d423887572a",
"main.dart.js_302.part.js": "4a799892e100d30217f121039b55a27e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "b956df60437ec269fa9e6fc81c1b73f3",
"main.dart.js_244.part.js": "5b396793844caf1ef609d1fbc6502d19",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_265.part.js": "970818581d48d4b08117ed6f42368a37",
"main.dart.js_300.part.js": "7385da90eb02d911125e82d1e9276408",
"main.dart.js_322.part.js": "abae489853915618284f18132e24db07",
"main.dart.js_263.part.js": "b9bffb072ecb37ff7495805a3b8b1081",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "74293a6a274bce988e7301f14a657d5f",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9a61bdd9d0c986376466510cf300965a",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e0e70a942102b7da40c9287d0d8a8993",
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
"assets/NOTICES": "8daf832ee99199178bddb87d82f0c857",
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
"main.dart.js_320.part.js": "41fdb1f01169e7a1f90ddf54df997b46",
"main.dart.js_247.part.js": "246f5064c3cdfce67382bbba615f5a4b",
"main.dart.js_16.part.js": "f7a35e3709cf8a548b6a02cae39a43f5",
"main.dart.js_303.part.js": "3bb8b066211df17127531e913dfa4e77",
"main.dart.js_287.part.js": "5ecc30ea793a931ac24072b7daf91b6c",
"main.dart.js_257.part.js": "98f413d0f71d652fc89ddd27cbdc393d",
"main.dart.js_290.part.js": "a5a868b17e685bf3c37882f84b4c6575",
"main.dart.js_212.part.js": "04f7efbd7d20d046b9d6d0315a1aae8a",
"main.dart.js_269.part.js": "8f66594aba9c173abfc8cdf5962bb83c",
"main.dart.js_267.part.js": "2784d8d9ffa26e7ce96a4095cd047319",
"main.dart.js_309.part.js": "a42e685440b0f649fb494ade4abfcedf",
"main.dart.js_325.part.js": "b8437c96b55d90ecf87a186167cefe0e",
"main.dart.js_270.part.js": "0b4c525f0c1648fc1520d8959310adc6",
"main.dart.js_321.part.js": "1ae078387e6b126889be653643cee6b7",
"main.dart.js_255.part.js": "b0a807c299348238fa6be71165d2c769",
"main.dart.js_275.part.js": "c5baa8f8eeb097adc81cf1fcba89f299",
"main.dart.js_281.part.js": "270ee1dfd4ad32c3f7b6c46cd757982b",
"main.dart.js_288.part.js": "8d6e22c82ae23810d4c89f848bbeafd8",
"main.dart.js_314.part.js": "3a11b5052c3f738c37faeda172287521",
"main.dart.js_307.part.js": "bb19a4ff0d25bc9486bd567a4ecb85eb",
"main.dart.js_279.part.js": "ab61c72c149ad206a4b771600a844acd",
"main.dart.js_319.part.js": "01fc245d2ccc1cc83a895e409d6b0663",
"main.dart.js_323.part.js": "9926d81301faa6115435d013873c35b7",
"main.dart.js_227.part.js": "1769753e19589ce7ff339a541d14f84b",
"main.dart.js_230.part.js": "4dbc7addd117afe1db703b73968913ee",
"main.dart.js_324.part.js": "2590320ccf25e4b06e91642f1635c7cb",
"flutter_bootstrap.js": "388d07a5055f9fa383ecd01868508b1b",
"main.dart.js_315.part.js": "01839ccdc6d435ac9656067bbbd7851c",
"main.dart.js_304.part.js": "ad929c9e969bdc1f032777a7438ced4d",
"main.dart.js_276.part.js": "1926834ffe88cf86bb0629df80c43b00",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "7e7927c85b0bfec337edabe79fec1739",
"main.dart.js_222.part.js": "9cfa39dc51fd3c93373f1a64e0f046fa",
"main.dart.js_238.part.js": "a4f22354b7c9140824f6e74969998bae",
"main.dart.js_256.part.js": "53f7b78f192344a5808cd9d2fbf870aa",
"main.dart.js": "9e984e4cfa820f2b2830ad2dc94f2827"};
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
