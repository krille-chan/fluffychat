'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "dc9dc04571b3cdd73d08c5550485d345",
"main.dart.js_312.part.js": "78eb3b12a00e2cbf65d3cb2c2c67f66d",
"main.dart.js_268.part.js": "d171dcdef6054fbe7550c539078bde3a",
"main.dart.js_273.part.js": "5a59eea424770e671a2be6e986902a99",
"main.dart.js_293.part.js": "9c0041579dc08e2eaf35376de1960882",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "1366c4ae9a9800a3f9617df729217a33",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "425bfc076ddd344a6b72d4811c861b5e",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "b9b2ab6a07cc30a7a94b01d30c786b3b",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_295.part.js": "42673b7724c3c6cd8b67651a39ccdbcc",
"main.dart.js_245.part.js": "22b0c845ef1fe6a9e129bd5e67acb7e1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "3e63a76feef62cf5ad94781b18cec635",
"main.dart.js_302.part.js": "8f9227173f12364d5496f46b82f43cd7",
"main.dart.js_320.part.js": "83cee95495918c48941d34333446017c",
"main.dart.js_321.part.js": "28dfe9c552bb9184d628325e88146eec",
"main.dart.js_255.part.js": "da67eea9b915f12111c3083f8bbddfbe",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "93aa94d6f3a33320811a08aec1389eba",
"main.dart.js_228.part.js": "5a9def3fe40e2e9cfb56372970f40660",
"main.dart.js_298.part.js": "a0d324f4b6feafb6cf944e78e3d0868f",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "edc1afb29e8d76ce9c58b141d5b1a132",
"main.dart.js_277.part.js": "02ff259b8f603deaca625014cf40b9c8",
"main.dart.js_227.part.js": "4a98c0ec8a816ff5ecc69a1fc1695a5f",
"main.dart.js_254.part.js": "dfd714d03af8053b45cd3afa0750057b",
"main.dart.js_279.part.js": "ca6672c88ab7e24281627e4245df2615",
"main.dart.js_305.part.js": "c485d21218d965c3168f91f127be496e",
"flutter_bootstrap.js": "c20b7e7ec1551d139133fb443c219547",
"main.dart.js_267.part.js": "aed988a5a3a2ef21964e9235337e2b54",
"main.dart.js_319.part.js": "c77c2b62ec694be55473db2fd1a9e0a9",
"main.dart.js_213.part.js": "731c5bb483d314b72d4d48ba86a025a7",
"main.dart.js_236.part.js": "a5bbbf5ba77a3d4bfa04a5b851ad393e",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_210.part.js": "cd0f2bfde59b3b9643229d7e3732fc5d",
"main.dart.js_323.part.js": "0be8aaeb625af116d5519e9653e3c9cd",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "be1364f3ff891f2121d207e02f80dfe2",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "bebd94f5831a26f2ce9211a938120fb7",
"/": "bebd94f5831a26f2ce9211a938120fb7",
"main.dart.js_299.part.js": "ce39c5496ee4f11245e1d6b25f5b273f",
"main.dart.js_242.part.js": "bafd1f8efcf27bef696bf0042c49827b",
"main.dart.js_301.part.js": "c5251973107da4eafb267ed7433bdaf8",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "1423ab11ddfa707121bfff57903a0755",
"main.dart.js_317.part.js": "4ab848a6fec022c838ee03c231d2fdab",
"main.dart.js_286.part.js": "00a7bdd3be8eee80fba14ab45674f39e",
"main.dart.js_307.part.js": "ba5f13eb86aef682d603d0d398bb3b92",
"main.dart.js_269.part.js": "b062a44b83dc4290b75cb79c813239d7",
"main.dart.js_263.part.js": "5e29f8a4dcaa1a34e7535c463ec7a60c",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "150d13698ec3daf53cf4a5da2bafc67f",
"main.dart.js_226.part.js": "31ea536c02819f482ad315f65a9803aa",
"main.dart.js_261.part.js": "f096adb3ab236bd8a0662882b532493d",
"main.dart.js_303.part.js": "382aac0d99388afacba09471b50479ee",
"main.dart.js_1.part.js": "5b3968b40657d6dcc814f387079ad076",
"main.dart.js_285.part.js": "4decc61828619c67a414e59bb88d286a",
"main.dart.js_313.part.js": "b8e25f1e77620a53b441f8e8c495f37e",
"main.dart.js_318.part.js": "743e658617ae7136f4a9b4aee3bf9b48",
"main.dart.js_265.part.js": "7da42a811ae18029a664b79c8a18da0e",
"main.dart.js_314.part.js": "7c02da9ef049d9c56a8c8837201e866c",
"main.dart.js_274.part.js": "d50aecf5d0b630a92a21583bdcd49dd4",
"main.dart.js_316.part.js": "d272eedfe4a429ccf026f5aaafc115db",
"main.dart.js_278.part.js": "33b6a50237063553c5071c4135a3813b",
"main.dart.js": "77136a4b15f93928f4b7e58560578f8e",
"main.dart.js_257.part.js": "0f67a921ff807fd74e0ec56cf63d4edd"};
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
