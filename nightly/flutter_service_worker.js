'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "3ac74c4d8b40f2c4cb3e249c5f528507",
"main.dart.js_271.part.js": "4a0e6805a1f6f2a46cea5d7312511fc9",
"main.dart.js_297.part.js": "0457b0f316c4f3df1d8aa1d5a78bbd4e",
"main.dart.js_1.part.js": "db62e78bb168efeac93fdfd3a4c5d094",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "1bae19b4ada0fc07a40b6edf9181de3f",
"main.dart.js_280.part.js": "766a578eadc1e6a7a7aaca72c78fe3f5",
"main.dart.js_318.part.js": "c5afd565c59ce768624f8b1b579be03c",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "64c7d8342e10f24033853d4602a961a9",
"main.dart.js_316.part.js": "6cfb7d0a9c67697429665e4de03cb148",
"index.html": "59f4cdd8f274a08902717be3e651474a",
"/": "59f4cdd8f274a08902717be3e651474a",
"main.dart.js_302.part.js": "779c15211d9428598c0a1f92a5a4ba25",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "bae5dd449d9f8593a17ed41f39a8967e",
"main.dart.js_305.part.js": "5b0bb33b9629b9c1e3df510b6f2dafe3",
"main.dart.js_242.part.js": "1d1e340447f52fc6545029ada529fa07",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_265.part.js": "334ce634cf87b907422c391149bd6d89",
"main.dart.js_300.part.js": "a75571848e27b3aaf07965df26e027c7",
"main.dart.js_261.part.js": "306da1229a59342699682e6114fe2e5c",
"main.dart.js_322.part.js": "32ea778f87bf4ccdc81e96d3861927ea",
"main.dart.js_263.part.js": "fe84de8934cdb2778999be8be2eef0aa",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "82fb6b816dbd40fcd9c78e4488281e09",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "60b8745852976ef8241f19090ede5cb1",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "a4caaf10a0e78df841c04a880bc7d417",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "84d5e6bdc058009deb6a10be3a990b96",
"main.dart.js_254.part.js": "ffd77ec788bd043898d5853b47ab9101",
"main.dart.js_303.part.js": "fe87a9fbac726d56582c225e18c347d9",
"main.dart.js_287.part.js": "c132e78214788f491a43c42b96ec2eb2",
"main.dart.js_257.part.js": "d75fba7d386490f6ed3fcfacdfe3af54",
"main.dart.js_290.part.js": "fddbaffa5055dc7a6a42793216a39067",
"main.dart.js_212.part.js": "1f74f20703f4a7ca62cadcbdda701c46",
"main.dart.js_267.part.js": "7190848bb411b85b244f08c2fba27836",
"main.dart.js_309.part.js": "ea08c3f81dc3b69a3ef7c99d03a95d7b",
"main.dart.js_325.part.js": "4d81ba1d9cc2181c27d71044ce49dcea",
"main.dart.js_270.part.js": "69101154764090d55d160855c8850253",
"main.dart.js_321.part.js": "d1e58979efa3e63ecc9f5f651677868f",
"main.dart.js_255.part.js": "680be5ceba4dfbb1e60a4bc57a4a501b",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "bc9c5342e38657872f6e8f238e2e7bef",
"main.dart.js_281.part.js": "653fb658b1af3c0b696a02a8cef16e60",
"main.dart.js_288.part.js": "9d8bc73789fd4ce056b30325b8fa0b3f",
"main.dart.js_314.part.js": "7a2c12f96fc6c8445046e7099f1c981a",
"main.dart.js_206.part.js": "47a79cabdf57ef794964a8fce6564a2b",
"main.dart.js_307.part.js": "a7441de7e10e3aaab7946da3ed9a56f2",
"main.dart.js_279.part.js": "e55d3355de220097a8e8514e4dce14c2",
"main.dart.js_319.part.js": "2cdc80d0bdea00015b8d549d2c6dc2c4",
"main.dart.js_253.part.js": "64d3147243e26b60f1393a9a9acbd142",
"main.dart.js_227.part.js": "ba9d2509be87832b7662a2d5e1de5522",
"main.dart.js_324.part.js": "0e615d2a1ea70dc3f91058961472d972",
"flutter_bootstrap.js": "d2f9e27889b08fd016a9192edd1ff193",
"main.dart.js_315.part.js": "c624723f1982e5970f9c417c5480e55c",
"main.dart.js_304.part.js": "dcd5de3a8465f647a961506fb3fa4c78",
"main.dart.js_276.part.js": "8a8918fb2135827efc8567df078de20f",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "5311374d163e56c1acc3efd2ec83d749",
"main.dart.js_326.part.js": "190be8ae19ae3c0748d1f38e0f983f5f",
"main.dart.js": "e061b5291ad5c7770906095f9fe98511",
"main.dart.js_224.part.js": "95b0e9d9e1392c8c1bb285afdc376f09",
"main.dart.js_204.part.js": "bdee669f9a26da849345078fee77626f",
"main.dart.js_17.part.js": "721260bad5377a9ac4a0c69406d0c5f2",
"main.dart.js_236.part.js": "b4116bac8ff264a3a55e8193cfe43e93"};
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
