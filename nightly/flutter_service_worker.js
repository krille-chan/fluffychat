'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_317.part.js": "96c8b88bfeda4903e384b6757ebda7b0",
"main.dart.js_243.part.js": "0a1bc33ea6d74641bb4a99309d5a24ef",
"main.dart.js_297.part.js": "7109c24282ca3fa6bc489a935c8d497b",
"main.dart.js_1.part.js": "4087a2a84e90c3bd965c14ace5681cde",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_250.part.js": "4f0c5cfcdb72adba88eeceb1e2437d95",
"main.dart.js_311.part.js": "9b3ec2de3bc34409c18497fc9f35942f",
"main.dart.js_280.part.js": "f03127dfeead90241dc2c7b4ff01ae4d",
"main.dart.js_274.part.js": "9daed35cf416edaad265bc6b8d961ef6",
"main.dart.js_318.part.js": "6bd228c526d241014dc7e687a773ae34",
"main.dart.js_338.part.js": "41053fa9ebdaf8771f77c1cf432547e3",
"main.dart.js_211.part.js": "25eca22762a065291e2c271feb0d2100",
"main.dart.js_234.part.js": "cee33372e89a5e5d5a3bf0ef4e8f8bda",
"index.html": "5aff5f2143b19d3835486c2745f6ac92",
"/": "5aff5f2143b19d3835486c2745f6ac92",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "0b679583ad430e76abe644f8acd8aeba",
"main.dart.js_305.part.js": "1edede04d6a8f06cac05122367932b2d",
"main.dart.js_2.part.js": "2b138bb039cb1b661fbe9172bdbcf34c",
"main.dart.js_265.part.js": "c57742ef7890c5d3aa8618209834ad2d",
"main.dart.js_300.part.js": "e5be8710abfafeec8293389115078167",
"main.dart.js_261.part.js": "3e3f8c245ea9bdecb1801ce189e3a7b4",
"main.dart.js_262.part.js": "23905b0d8ffc6757e96d4796b1293121",
"main.dart.js_263.part.js": "556614fb73452a2025eb449fd8643b51",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "90a7384f6cbbaba6efc1f7e82198f723",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "3ea431477e7534c1c9decc8872239c77",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "7f4bdbd9c59d42100e883d30b6d84105",
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
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
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
"main.dart.js_320.part.js": "bc5bbae7796f1ae82232320ed5915b00",
"main.dart.js_284.part.js": "54ac1c11ada8efa77d7ffb29273400cb",
"main.dart.js_336.part.js": "8278fface8fd9ba664efe551178696f9",
"main.dart.js_333.part.js": "830beff6e3420a9b267047d9c3fac825",
"main.dart.js_331.part.js": "b44d75075dba382681e8bd3270dec438",
"main.dart.js_290.part.js": "45648febdb67bb6d9f3bbcc997ab9b92",
"main.dart.js_213.part.js": "9ce3447dbd8d6634fbf0df9b489196f2",
"main.dart.js_313.part.js": "9e99940b176adf80ace5e568e8682d04",
"main.dart.js_312.part.js": "283fae53a5a994bdd1c9399f864053b1",
"main.dart.js_325.part.js": "d7d8f369c6ec6ef1a2d815a7d313b218",
"main.dart.js_298.part.js": "a40556e45b156046e9d2326e801baf94",
"main.dart.js_285.part.js": "47fc7aeb0bbb30fb1c0c6452492bbe29",
"main.dart.js_270.part.js": "d97bfa8dac6fc6665b5ed18cf1aa9a70",
"native_executor.js.deps": "70b012251976c9b663043cc28dbb42a5",
"main.dart.js_332.part.js": "fe740f7d8fb257323ed066182fb5934f",
"native_executor.js.map": "f024cc1fa3b0f17d8be25ff637b0ce29",
"main.dart.js_288.part.js": "46b1ce5fc714e96c38a5e435e2808534",
"main.dart.js_314.part.js": "8e6ed60ef68a0cf558800e1b6caf6442",
"main.dart.js_307.part.js": "3d328e5d998c9b3f61830460b9595c37",
"main.dart.js_279.part.js": "5212ec0e8663baa3fb122651bd6bd4ff",
"main.dart.js_319.part.js": "b5a507ff148e705607e71f5dd6382627",
"main.dart.js_253.part.js": "e70b55f9786540a7303e5b9f991336cc",
"main.dart.js_335.part.js": "2335a9f7694894b11f8e5f9f572bdd37",
"main.dart.js_324.part.js": "ff421c58c01eb69372aa4f91aa3cdc29",
"main.dart.js_289.part.js": "44c22f4670bf95d658d79ee93fefff2c",
"main.dart.js_337.part.js": "f41b673fd818a6a8dad4480a78c5029e",
"main.dart.js_219.part.js": "ac11070ecbeda4fd454a5840eb5ae902",
"flutter_bootstrap.js": "6ca78074c2e38badec8679a0300ba526",
"main.dart.js_315.part.js": "f904f137fd83c23b7615d1aec8c856c7",
"main.dart.js_276.part.js": "da0a6cb4a8ab150a9c517dbe7b451622",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_310.part.js": "cbfa6a6130e8aaf8cea0b499f2d44471",
"main.dart.js_326.part.js": "3b5eabbeded3754df2cc10b7867ae8b5",
"main.dart.js_329.part.js": "2718ad7b08c720357bf77a83683fa33a",
"main.dart.js": "722c4c53c0533700a55659902918848c",
"main.dart.js_272.part.js": "c9c2202fe4798c757ad148fe985446c4",
"main.dart.js_17.part.js": "71468572638b88b5dfb16d3bfbec6fee",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_226.part.js": "466de8d7a3076f36d06d4b7ebd493c63"};
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
