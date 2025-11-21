'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "6474bf990438e5e50399ccebae048585",
"main.dart.js_259.part.js": "9ae93ecbae4776d598dc0513ae2f071b",
"main.dart.js_317.part.js": "4f8d2c3ad96afa3c12971143e57c1b71",
"main.dart.js_243.part.js": "c6c9c61e6ac2c87ccea0f3f52f96ce72",
"main.dart.js_1.part.js": "4988a421dc22e8ae08bf55104c98014b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_274.part.js": "b5f6a737b2f810c9f10c285bd07a3742",
"main.dart.js_318.part.js": "3760c65dc0740d73ac49d3548ee0fd0b",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "8f0dadb8f4f344a84bc818256a43f8ed",
"main.dart.js_234.part.js": "093e7daa85f440b2da615f3c7f9f235e",
"main.dart.js_316.part.js": "110ddef42be156ab6463c7c7af0d8c41",
"index.html": "a66735d804000b930957c0adfee69fb5",
"/": "a66735d804000b930957c0adfee69fb5",
"main.dart.js_251.part.js": "a8982397f937a99cb9bf5e3172f338a9",
"main.dart.js_302.part.js": "e4f7d65e632def5d3249160d9d6a89f1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "dc0d3e8e89167d0f190b787f81b59af7",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_265.part.js": "e8f3ae4759506b5ee00243e4ca92c96f",
"main.dart.js_300.part.js": "8f474ab8de51409ef8902d01f9d49b7f",
"main.dart.js_261.part.js": "c1b16a733b91280b0a0b6a297bf48fc2",
"main.dart.js_299.part.js": "33bf59713108406996addf389f3f8f41",
"main.dart.js_322.part.js": "ed851fa0781b9aee1fcc5eb1084c69f2",
"main.dart.js_263.part.js": "76ec0affaeedfd45f8b3712e797e6f78",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "214b2272396f002d7d6a0530cada2aba",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "ae9e9f0de1cf6ad095e1a78edada33ef",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "db85dcc804d18e38b6ad7deb59367e5b",
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
"assets/NOTICES": "18f6b1633458f1980747a31d7e0608c1",
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
"main.dart.js_210.part.js": "a8500e25656c697ff8e4dbe7ab8e905d",
"main.dart.js_240.part.js": "05b52e52371a6eb93ffaecec412e7ed9",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "2cbde6aae4d80f719c5c16b1c2af1f36",
"main.dart.js_278.part.js": "274fcc45e84fa99d3e8e2ea706ba96f6",
"main.dart.js_202.part.js": "983ce73e2774f686a7f4cff889f7b0f9",
"main.dart.js_286.part.js": "38442c51eb4b7f748e9acd22081d669c",
"main.dart.js_303.part.js": "30ca1bbd3dcef638b8c540b135e89268",
"main.dart.js_252.part.js": "77eab7e56241468b12716247bb6d1206",
"main.dart.js_269.part.js": "c211cfc347749ebab3195689919aa636",
"main.dart.js_313.part.js": "c885029e83c602e34c0d55f20f0adb51",
"main.dart.js_312.part.js": "384b6d2255aa79a22c559369f759e965",
"main.dart.js_325.part.js": "05b83f7a2a39ef9d6b81c91010746b54",
"main.dart.js_298.part.js": "45ec666299ed5ef87226b7ac8d13990a",
"main.dart.js_285.part.js": "768b84543660d71e9621247e87aa7583",
"main.dart.js_273.part.js": "159a2dcf2f03059e2667ba28a62f16db",
"main.dart.js_255.part.js": "9adc9e7248e70f76f30eb375d232d788",
"main.dart.js_268.part.js": "4557fcc5d4e3b1d3d7e5152d1b97f310",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "0c00f114958162a0e7e6a2124d989960",
"main.dart.js_314.part.js": "8afc797f49770cb2ead6b11c3984b308",
"main.dart.js_307.part.js": "2176215e7f1a66ad9cb01bd5bd146d68",
"main.dart.js_279.part.js": "43cf83cc03eaa2c692e6e582868a1c8b",
"main.dart.js_319.part.js": "105a0785788c590cb2930e2f2c6a1065",
"main.dart.js_253.part.js": "d88efa733210890edd2e95bb236c7abb",
"main.dart.js_323.part.js": "e9b78fb9bf673a76419f2c550c63e212",
"main.dart.js_324.part.js": "53c21780be524e564d14b941b4d09d55",
"flutter_bootstrap.js": "1d66f19e593994c0f2819964ede84bd5",
"main.dart.js_306.part.js": "949951981644dc54fc4883ea256e3ac1",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "81764621bd2c6cec03440dc3074d267e",
"main.dart.js_293.part.js": "ad5c31d0c66ba29d6defaca68a9588e2",
"main.dart.js_222.part.js": "3bdb16755134b4de9a73bbca3f24fe60",
"main.dart.js": "3c1f68136261ae0af527a633840c1b04",
"main.dart.js_204.part.js": "fc51702721c5d27cce2265b9e0e4e398",
"main.dart.js_17.part.js": "40ff570a87c11ca7c526b9bf95405db2",
"main.dart.js_277.part.js": "bc3fa5451cc3e1d91e72d421cf4812f5"};
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
