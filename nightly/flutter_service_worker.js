'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "93d4c7c08261da9aa295562b298dd900",
"main.dart.js_300.part.js": "f16383f2d4d8ca2b2f71973f8a3de21c",
"main.dart.js_280.part.js": "f768ab177aa96d993ff69eef0f7213d2",
"main.dart.js_324.part.js": "4b6cf40a8350b1d66c4722f2ce9786fc",
"main.dart.js_301.part.js": "651899effbc75e965b04fa0336910789",
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
"main.dart.js_308.part.js": "a5c45699d963057c90db13b409c0a882",
"main.dart.js_287.part.js": "e33c37ab0ec3b855719aa0940c839355",
"main.dart.js_275.part.js": "bfabf187b3d6e93be7311810244bc6a8",
"main.dart.js_303.part.js": "2f2530535f8d619815d9043d16e35e72",
"main.dart.js_319.part.js": "0fc76597dbe33a63b991eac6420c66da",
"main.dart.js_221.part.js": "bca3c41bfe797b342f0c4dfcac5fa2bb",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_237.part.js": "c7f807f606855ee91ebbeafcd3169c4b",
"main.dart.js_279.part.js": "4b8d1608d05db11da1f8140e13c5d38a",
"main.dart.js_289.part.js": "222cf1a52ef203374b9ba0e2c38bedbc",
"main.dart.js_302.part.js": "637240a5ea2843666a74f595f889a78f",
"main.dart.js_269.part.js": "f3f5df96e303f687a6a23b6f0a994776",
"main.dart.js_229.part.js": "3e47484ad61f7d8a7fce86b0492373dc",
"main.dart.js_304.part.js": "58d570f35958b93fdc056ea8b41b3c4e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_318.part.js": "10fa38a4c2c10a22dc280a37333806ff",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "86b9786b7cc42302d2e879e85ca86227",
"main.dart.js_296.part.js": "f15a0c56c726eff3a12bcd1d94cbde2f",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_270.part.js": "ef272abf4ed7ba032d48391b647fe423",
"main.dart.js": "3747403e46b3f2a2af272688298ea298",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "e4b252c376013c961a57ae76dd10dc4c",
"main.dart.js_246.part.js": "4c65889e7dffcaa6c7260603ec7de2cd",
"main.dart.js_1.part.js": "78862d74dd321125d04a7a449359a56e",
"main.dart.js_211.part.js": "0515982f047d5f3b50351085c012ff4d",
"main.dart.js_294.part.js": "27ff9b14681808687ee3cf0047ae7d4f",
"main.dart.js_320.part.js": "6cf21a3a97c0c5df83e947abc1fb4361",
"main.dart.js_313.part.js": "9ffb835a5c5803035f88815336f2fff1",
"main.dart.js_213.part.js": "33fcb94f18c3d8fae72ddf088e9f81eb",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "4c4d7f2e62e4ea3dceb17c46d0cc510b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "961efe2b77b80c5365f0f8a9516fcc22",
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
"flutter_bootstrap.js": "171d29703c8c9a84f3a51ff2223c9772",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_264.part.js": "d9fd5ae30cfcaf6c4e3896fcbbc2f1e5",
"main.dart.js_321.part.js": "f9c498ba08f715f015c584df4fc9d130",
"main.dart.js_286.part.js": "33d0832dccb1b4f5dc55caedbc42517f",
"main.dart.js_256.part.js": "b59997fd270a343e05683ce40eaace3a",
"main.dart.js_268.part.js": "bff8b73371a26c8567d4ea61529d0388",
"main.dart.js_255.part.js": "ae24957f0eb100ec4200e38d5889e3c7",
"main.dart.js_226.part.js": "6abfcc714864c06c698d427640f80638",
"main.dart.js_266.part.js": "749f3757f8fde001ed0d0672b80c66a8",
"main.dart.js_278.part.js": "23408b8e1ac89ad54f2ed433a0675dcf",
"main.dart.js_323.part.js": "3961fc7d662b9f1e4d1d1ab747ef3de9",
"main.dart.js_299.part.js": "ae4ca1805c240af27976ab2a5e644adc",
"main.dart.js_16.part.js": "0a29f991517f52881e1c6a3e13f652ae",
"main.dart.js_243.part.js": "d9ae301753be14abfba5ceaef413b8d1",
"main.dart.js_322.part.js": "979a96ee9eb7bcbec46f0a572ba60c08",
"main.dart.js_258.part.js": "87a5b1e318ca713f903568542a80226d",
"main.dart.js_307.part.js": "b693219140f9e4a6cd55a29b8ffaec2b",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "89692d66f217c7419fa13c815beef961",
"/": "89692d66f217c7419fa13c815beef961",
"main.dart.js_315.part.js": "13f593bb613c938ecc96af766ffda908",
"main.dart.js_306.part.js": "c3e8eabcbaa9d382ed7b92e2c283f6a2",
"main.dart.js_317.part.js": "3a6ac97c6a58c568d217038daca068e0",
"main.dart.js_262.part.js": "52c0649d4d786272e9d706a8be4b2b8b",
"main.dart.js_309.part.js": "585da019b1d852b1a5ec0463325c4781"};
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
