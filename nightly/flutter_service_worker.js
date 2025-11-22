'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "79d128f2bd53e56a2952bc8601397598",
"main.dart.js_317.part.js": "b07f8987e4b020f03e5a83422f3d39a7",
"main.dart.js_1.part.js": "d589f45899e1ea12b11c2ceee24722d0",
"main.dart.js_260.part.js": "cb38ef6d6696b19076ac3611a9131c55",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "34eae0b05f314433324055e9c18bcd94",
"main.dart.js_274.part.js": "fcc536c116ddbc1e0eb24fdbd3e17f2e",
"main.dart.js_318.part.js": "85083fbf6847b34dfdef8979440d5c76",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_211.part.js": "21c7a583b2ebdf552c8f4d16dcab4470",
"main.dart.js_266.part.js": "edbf6eee91eba90b62cbb8f584cc839f",
"index.html": "16b5e849f753ea83467d5888feb114de",
"/": "16b5e849f753ea83467d5888feb114de",
"main.dart.js_302.part.js": "8e100013babd45b4143a2aef1114ae70",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "81ee9a589733761eb3937671e02225cc",
"main.dart.js_244.part.js": "8803017f87a5c6b6c76796eeb136b80c",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_294.part.js": "b2b48fc65bc8a604b16a4a48cb31d173",
"main.dart.js_300.part.js": "d03f25d48d9a01045e0320ceac12a25e",
"main.dart.js_262.part.js": "cc47dec74191f39e20baafef834104d4",
"main.dart.js_299.part.js": "1eda6d9ecce2947ec15016744f062b2e",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "e48501e49b4a0614fab959f579b84d7b",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "d6a7aa7248da1589fed6b909240db088",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "bb946b7e1c553f05dc339e31ccf805fa",
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
"assets/NOTICES": "3ed19900f4b6d3f69a5b0e9689b8e27c",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "04ecd2ac7416c9f51415bcdf6133d576",
"main.dart.js_254.part.js": "a1f2c278cab72d56bd91095ddc11c828",
"main.dart.js_296.part.js": "6c159783911d077a0ea038308b2eb42e",
"main.dart.js_278.part.js": "b7a177386c4c2be698ae1afc1885ec0a",
"main.dart.js_205.part.js": "5088518d56ca3a45c3eb46d4f380768d",
"main.dart.js_286.part.js": "7af1e8ec42222eb89285a84312e6c5bb",
"main.dart.js_303.part.js": "f580ad9bb62ca7cff81377ade668321d",
"main.dart.js_287.part.js": "a5ee61e01e04c4249234d2d469084756",
"main.dart.js_252.part.js": "367c5f87992398a865b9775e856a8c01",
"main.dart.js_269.part.js": "34fc6d2a7a48a3d905468d16141572a5",
"main.dart.js_313.part.js": "207d8de33c6c175dce7301feb7879ce8",
"main.dart.js_309.part.js": "ca31f1a0ae6dc7f5fd599caf315fde9e",
"main.dart.js_325.part.js": "f86d2d04389910502ebcadc382957a28",
"main.dart.js_270.part.js": "0af707e3b6b1999dc64492d006621141",
"main.dart.js_321.part.js": "0d8a0ea83dd0b65d1e1f8ab767cbb072",
"main.dart.js_235.part.js": "94bd84f8762da1ab4487426c7681fe2d",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "3de7b5f222a4e651e00340e747b49a37",
"main.dart.js_314.part.js": "aad544d0217e7259d7e2f09242ee19c9",
"main.dart.js_307.part.js": "3ffc7c488ce03417eb3d44f7a920d232",
"main.dart.js_279.part.js": "cde68ede2df146d77ba778bcf851aee4",
"main.dart.js_319.part.js": "b8ebf0060c8738e3a878ae394fd87724",
"main.dart.js_253.part.js": "9b52bf2e86b6daac9ffd74120802f3a4",
"main.dart.js_323.part.js": "bfeee8bc29f073cb2a3a52f895750d2b",
"main.dart.js_324.part.js": "0570df0b9042b2af293e7f36db0c73b2",
"main.dart.js_203.part.js": "f8668a65b89db6dfd71bdd23d26e02f6",
"main.dart.js_289.part.js": "473e5ce439f5789023bb28c7d9cfb76e",
"flutter_bootstrap.js": "fe7905c7601948929d79d2f29c49968b",
"main.dart.js_315.part.js": "51f4e060642eb5d2e6119f4e06786a95",
"main.dart.js_304.part.js": "275cee79c385123757b591e70db741f1",
"main.dart.js_264.part.js": "01fb5b7a4ba2c5e1ceaecf236397c52a",
"main.dart.js_306.part.js": "2f8c286ae2c7508e31ca553d2fd6a89e",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_256.part.js": "cb49d7a5229ddb22cfba3768a9ff0cb8",
"main.dart.js_326.part.js": "8b3748b3957a3eb50168ba6056da483a",
"main.dart.js": "9a096d4a2b6a46397890ebc2bc85703d",
"main.dart.js_223.part.js": "aa2d31a446e9d9c034bd50ae85812847",
"main.dart.js_17.part.js": "40ff570a87c11ca7c526b9bf95405db2",
"main.dart.js_226.part.js": "04bafbec8d72dd2c32139b8c93323d77"};
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
