'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "29790f80844d6dd75152b05c7d1c3b04",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "5b46e623cf9f38d616dcfdfcb9d86b09",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "35fc777d3f19a6239c7c05eb0f0129e5",
"main.dart.js_317.part.js": "c4151954cce7933a87b9af6d60c4df67",
"main.dart.js_1.part.js": "3469b0510e032c146b0a163c127b87da",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_338.part.js": "9380c6dcbba66b2b1566a20a5a31ed29",
"main.dart.js_266.part.js": "932f0fb51c8e942b6008c485d5bf05b1",
"main.dart.js_316.part.js": "8d82bc22d939ddf7f3ce43317a38813b",
"index.html": "eda8f477b4d91cbd304ce20f2b2c189a",
"/": "eda8f477b4d91cbd304ce20f2b2c189a",
"main.dart.js_302.part.js": "db7657e4ce19b48e78f351f80a05f403",
"main.dart.js_217.part.js": "5e8ba6fd56d4c7162d324b9f9928db9f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "2d8933c78c4926f43e36bb89e03d578a",
"main.dart.js_2.part.js": "374aad1723772ba5a823f277c3594dce",
"main.dart.js_283.part.js": "654b80ce355698d95677027822cee2cb",
"main.dart.js_265.part.js": "f237d4d782c7b1173d9799e31db0b060",
"main.dart.js_300.part.js": "2d56a5398a01b4ec6abe24df9a617886",
"main.dart.js_299.part.js": "fc272d6256fad69ec7f5a6a85ab0be19",
"main.dart.js_322.part.js": "c22f98952e6496fd835c033922207ffa",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "b477e6e03d77d74d108fad0ad2a687d0",
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
"main.dart.js_334.part.js": "b0774522a9890339b7bb64a7e28d9276",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "9dff919c0cbb18bf3ac28214afc24390",
"main.dart.js_247.part.js": "ae08099609300badcb0cd5287fd4d041",
"main.dart.js_292.part.js": "cd5af99d8c2799b02b4740dda0d3a567",
"main.dart.js_333.part.js": "8e5ee7bc9d91ca4dd3b4011ea5a39cfa",
"main.dart.js_287.part.js": "a6d91de08b7bdab336e1e139ce550cbb",
"main.dart.js_331.part.js": "2fa5da763ae51c52140b3b8f263ef46a",
"main.dart.js_340.part.js": "cd92b74508491c9472c034a2a873763e",
"main.dart.js_313.part.js": "e3945c5456135670d44518beae078b46",
"main.dart.js_309.part.js": "f1ac1a60c74614df1156b6b62ce59832",
"main.dart.js_312.part.js": "92934ea808b4b14fed2d0c485581fd11",
"main.dart.js_321.part.js": "27ae93a117c782c5a1f506e0381f4c85",
"main.dart.js_273.part.js": "fa267568b88c7e01dd4bcaa6a4abd2f8",
"main.dart.js_268.part.js": "09cf1b2345ddebb877de03b7a0b2b97a",
"native_executor.js.deps": "70b012251976c9b663043cc28dbb42a5",
"main.dart.js_275.part.js": "7eb5dafd7ad82f582c35ce13da9ccd50",
"main.dart.js_332.part.js": "30173df233e2f3637b4e29274aff78f8",
"native_executor.js.map": "f024cc1fa3b0f17d8be25ff637b0ce29",
"main.dart.js_288.part.js": "b81d267c2b434754313cd7c89f561456",
"main.dart.js_314.part.js": "7f2107c545dbd2df683bb5db61b20112",
"main.dart.js_307.part.js": "6176e5f8a076a873ab450488a7632854",
"main.dart.js_279.part.js": "83c41581871c1a2499ab94c0358bb895",
"main.dart.js_319.part.js": "7a5444d87082f502236d36450db42691",
"main.dart.js_215.part.js": "63e90bd89f65cb29143b871578a1ead2",
"main.dart.js_253.part.js": "53e30d8c4de96830e1bc1423c6795a47",
"main.dart.js_335.part.js": "3b2b9803d27bc1e0527c850a3d709993",
"main.dart.js_230.part.js": "0c98b00ddfb033a5162cf10b0f139f80",
"main.dart.js_328.part.js": "48bbf03916c8e8405f0c0890e456eacd",
"main.dart.js_337.part.js": "b227f9b55ad5116f5cda1fd8fe47e1bc",
"flutter_bootstrap.js": "0551b2ba80e0e5131399317a0d280e2f",
"main.dart.js_315.part.js": "97397d834539fb4d080adcfe5d51c1af",
"main.dart.js_264.part.js": "44cb3ffba6ac8f643fb70f5594f32020",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_293.part.js": "6a7501aa6185441ed2eb84dbfe6dcfc1",
"main.dart.js_238.part.js": "2928d51f7e47628a4c4d1268547aed86",
"main.dart.js_256.part.js": "1cbe71084e9c72d2decf776385d663dc",
"main.dart.js_326.part.js": "e1bcf9d182eb5e1a50c1f14c276c07e0",
"main.dart.js_329.part.js": "db826b9490f753b853b6f0f2d8b8348e",
"main.dart.js": "86ee56c128b15d73e7c4fb5892369ab9",
"main.dart.js_223.part.js": "8af26f00d8242534784d272ab5c76741",
"main.dart.js_17.part.js": "ee2749f1adf60b525254b02567102598",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_277.part.js": "0d36901d297ba5ccfffb409761fdf901"};
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
