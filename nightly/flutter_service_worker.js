'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "15deb2ff8f302b927cb1b5dd716e426e",
"main.dart.js_271.part.js": "81ca5306d8e31be32b05fb9e89c2d67f",
"main.dart.js_317.part.js": "3de454aace4bc4f2b5ff9be06fa05eae",
"main.dart.js_1.part.js": "43ada2b06a897536927aa4ab4b3d32fc",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "2267bba01d5e73affe6acc9eb9b6018e",
"main.dart.js_311.part.js": "cb069076ece321201718e15508f6a84f",
"main.dart.js_220.part.js": "8690897a61e2ed9304fcaa64774cab61",
"main.dart.js_318.part.js": "c96a5e241a9adb17439a5d136bdbda38",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "c16f9c0033b871098bbf34bdb58a2af5",
"main.dart.js_295.part.js": "9ca1e2b91d1727fd998be15ccaed5b9a",
"main.dart.js_316.part.js": "3a6d4896852a5f9f3e95dfdb1b3158d0",
"index.html": "e38b8ba431c09c5e07890fe1867a5ba2",
"/": "e38b8ba431c09c5e07890fe1867a5ba2",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "6e72f4276f637cda9075c63296137f8d",
"main.dart.js_305.part.js": "5ee027d2caae05bbef1fe826c3c594af",
"main.dart.js_244.part.js": "bf97d2583139169b1ecf435c40ef17fe",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_283.part.js": "4638b573345dcc0a520d5d31504bfbd7",
"main.dart.js_265.part.js": "be3e10f6e27ceba51dd55443781c01a6",
"main.dart.js_261.part.js": "eec532c6a6308b649fde95746a74fac1",
"main.dart.js_262.part.js": "dc002d0f8d0cb44bb51a73ec45f9713c",
"main.dart.js_322.part.js": "5f92f8c9d036d5e1a7ec6789d0c21b65",
"main.dart.js_263.part.js": "8fb7d30be5b95eed457b195c1038f7e9",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "97878f9a01c3e018dc96e96631e66dda",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "f647b54eef4fd6556687c359c76bbeb8",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "b86c7cc3bc7f0ccca405b34673a7bbe0",
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
"assets/NOTICES": "e3942d4aef2a10490fb32abd34246436",
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
"main.dart.js_334.part.js": "00f8af8cde0fbec97bd6cbd75544b64f",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "11fa6b8b79ba30fde437cf0c72f43012",
"main.dart.js_296.part.js": "39bbfa3a80a6c33a9057d7d0fd873e3e",
"main.dart.js_278.part.js": "314420867305ce9a0ad2e9dfbe4655d9",
"main.dart.js_232.part.js": "19cf47cce213036a68e9cee645a1452b",
"main.dart.js_333.part.js": "c4e44b10ed83dad9c02263bc70210583",
"main.dart.js_303.part.js": "a59848ea8efff396ccf5774ead6b2322",
"main.dart.js_287.part.js": "8f88d5f7b611be93303e46b989d6df0c",
"main.dart.js_212.part.js": "2819f45a94b44a671eb046f86023a513",
"main.dart.js_269.part.js": "908245fc07c72b4a748a23072a888766",
"main.dart.js_313.part.js": "64dbbc0d53beb765f0addae522e151f4",
"main.dart.js_309.part.js": "dbaaa672880a58269c9bbd6389277559",
"main.dart.js_312.part.js": "6237372a7c34cfa8d8f67584cb6cf841",
"main.dart.js_298.part.js": "6caadc4e35acaf8afa5e5223d3f7728f",
"main.dart.js_273.part.js": "8bdd6d85fdbe7f07706143bdb71a7cbf",
"main.dart.js_235.part.js": "b6a71fb604a2c780391daa65b4164c40",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "26b1694b6b912b372daf9c6490f7e9bc",
"main.dart.js_332.part.js": "748cc446d27ff2085067e80a78cf014a",
"main.dart.js_288.part.js": "7d6c37391c373724ed8592f3bd8d7743",
"main.dart.js_279.part.js": "30997610a43fdb7b085e1f51544ee9ed",
"main.dart.js_253.part.js": "aa72fc6fe24b4523464a2bb731f19cdc",
"main.dart.js_323.part.js": "508454feaf65c0cf93c708972abe7054",
"main.dart.js_335.part.js": "f9f3e926fb08937e74d4b4f385dfec80",
"main.dart.js_324.part.js": "5b745584bce4bcb9c82f9dc899943785",
"main.dart.js_328.part.js": "edfb76631eb513a4b96500e18120ff7b",
"main.dart.js_289.part.js": "2378e7779af674e6ad5c99169ee12a75",
"flutter_bootstrap.js": "6ba7e64beb944e8b1d7810e343547bb4",
"main.dart.js_315.part.js": "0343e9a45740fb75456fd01a5f34b757",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "698e76b187d4e1a88027e76b44c2deeb",
"main.dart.js_326.part.js": "2768c806c93944373a201bc890104023",
"main.dart.js_329.part.js": "21b44035362856e5e17f5fcc2716585e",
"main.dart.js": "b6c473f7c6c100805a5cc64143c66ffc",
"main.dart.js_17.part.js": "eef8bcef0ec5b437cf1b753638db3bdc"};
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
