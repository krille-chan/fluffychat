'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "c5062ed308795885f5e1b4fed181dd94",
"main.dart.js_308.part.js": "9f3c6ca08f57f82fbf7a668192bba1ce",
"main.dart.js_271.part.js": "68bb30ea212609b50a2ed6e36220dc79",
"main.dart.js_259.part.js": "93a9293d6882fb647f5de0322d04d3f1",
"main.dart.js_1.part.js": "d5b52e17d5766837df3c9a53b4ae318a",
"main.dart.js_260.part.js": "0570520b70bcdf2e81e61742b56b6f31",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "feed92c8bfee9360c7d148563e9402b5",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_316.part.js": "0ae4633f79c6d9184c93981ec8b71dfe",
"index.html": "502d980f9528a741d602069067b2cf57",
"/": "502d980f9528a741d602069067b2cf57",
"main.dart.js_251.part.js": "074a844399b544a6b3e5621c0f88822b",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "101f4839460ac9339970e2894b43a25f",
"main.dart.js_242.part.js": "349a40e9fcaf63be7e4869c1bff6661e",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_294.part.js": "1028385c3c041761141474f645c3fb91",
"main.dart.js_261.part.js": "f0c3cc602467d77dbfde0d1f343b446f",
"main.dart.js_322.part.js": "2e746a190af958dd01e26559f3c60a12",
"main.dart.js_263.part.js": "0178cdae7be7db5fa527c144de376a76",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "7712c0d792bf8a36f892e0213bdc97dd",
"main.dart.js_301.part.js": "379597704696323f3bb85001e4321d4a",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "aea077e8d5a0dbc008ada4559a445ebb",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "14357ae99456ecada2dd5357e5ec4b9d",
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
"assets/NOTICES": "a6560be9dd1dda51cb475d869d4827c4",
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
"main.dart.js_210.part.js": "8ae3592ed051748d6e3b6c576b5341de",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "d76ede1418469657fca4002fb0102920",
"main.dart.js_296.part.js": "93792395cb1d2c6806d6764daf73693b",
"main.dart.js_286.part.js": "d5ec0054db6dbda6180b1b053bafc872",
"main.dart.js_333.part.js": "70175896077c0262e0d8d1c9f2d6dace",
"main.dart.js_303.part.js": "f32e7bc0dc8dfea7edbb8c3ec72f355f",
"main.dart.js_287.part.js": "f8fe43acf1e0ccd07912ed61f6aa2ee3",
"main.dart.js_331.part.js": "97a4ed1024604e94c1df563899bfc4b8",
"main.dart.js_212.part.js": "edb5102e0beb9a27f65ab7e5ac58b95a",
"main.dart.js_269.part.js": "40fcc91d7e2088323d5a0967b6079797",
"main.dart.js_267.part.js": "072573ca70e5ea13ecf8bd5047375f61",
"main.dart.js_313.part.js": "dec96f2f9280d47593bbc3e11bc0224a",
"main.dart.js_309.part.js": "03718330600fc965f29b8142c604ae9b",
"main.dart.js_325.part.js": "f5871e2ba600cd98c8cc51e8e3bc9ed7",
"main.dart.js_285.part.js": "8095867eb563df85ed8c157a5f46782c",
"main.dart.js_321.part.js": "8d483c44e008c75f3056c8ad324895eb",
"main.dart.js_273.part.js": "660645aa9021ebb6a42829972365e33c",
"main.dart.js_248.part.js": "fa55bfde385d6fd43477ddd87d9ad391",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "1832a3da643203093fd31e2dd980777c",
"main.dart.js_332.part.js": "c0837e28a6a5eb45c026029667d6bb00",
"main.dart.js_314.part.js": "fb864101b13822004870b3e8b3c26ec6",
"main.dart.js_307.part.js": "284118e91698b7b6b5a514479bb9b38b",
"main.dart.js_218.part.js": "9807ddadc356c9e5baad3b80f866b869",
"main.dart.js_230.part.js": "b2e1c4c9b615965e026ff50d7a879267",
"main.dart.js_324.part.js": "de620d0bd31ac3494ed0711ec2faade0",
"main.dart.js_328.part.js": "5847295cb415d8d68c226d4d95d0a785",
"flutter_bootstrap.js": "cb6dd0bad04bdaf703d1503ca34a9231",
"main.dart.js_315.part.js": "0c56fb494201222bfb8f5e642e86560b",
"main.dart.js_306.part.js": "983812e72070c2ce45cacc07e0396368",
"main.dart.js_276.part.js": "30d7e05251f59ca5a52aaed751a82392",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "d1bfc85e1cf17667f3089f8b526069ca",
"main.dart.js_310.part.js": "9f231741a5bc5444eaef8f7cfa63e0f9",
"main.dart.js_233.part.js": "0d0908972732148dd6b09d111c6ac40e",
"main.dart.js_326.part.js": "10265bb5e93b06ccbe79a47345369421",
"main.dart.js": "b114308f89685d3554aa144d56d92ba3",
"main.dart.js_17.part.js": "f847021c3a878f88c7c590609080c9a8",
"main.dart.js_277.part.js": "891bb36dec9ee4ce607f2141c11e763f"};
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
