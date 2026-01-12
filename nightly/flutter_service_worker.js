'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "a38d4e511f26f3598d1002d2c673b231",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "de392138617143bbefaba8e6da5833ce",
"main.dart.js_271.part.js": "f6c4b2507a347618675df8ec974ff44c",
"main.dart.js_317.part.js": "78e144ce4c6451ff940cf91c7bbd7de4",
"main.dart.js_243.part.js": "2b840bf29057bdb681b574a50a2b3775",
"main.dart.js_297.part.js": "32124556307beda804e4cba44c1203bf",
"main.dart.js_1.part.js": "90ee68db5feaaa979cc7f9c6a0ebaaa7",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_220.part.js": "cd47e2ee8fda34a6abcfa81d1ba72d3d",
"main.dart.js_280.part.js": "6a9cd21270c04f3b53a4c8a8d671240a",
"main.dart.js_318.part.js": "843e8593b1ca778a042833c7074dacfc",
"main.dart.js_338.part.js": "fe6f03ea07bfa73f909dd719bdd0ab25",
"index.html": "c820e4546e2493cde7245f150e73c167",
"/": "c820e4546e2493cde7245f150e73c167",
"main.dart.js_18.part.js": "c0a25b40511d81265c59846d6f5e327c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "cad24456334bbe33cc6ff4fc3f1ff660",
"main.dart.js_305.part.js": "1e787d3a060ee1c686cd0d141f541a7e",
"main.dart.js_258.part.js": "ba80626b549dfe8041aae963b1a2874c",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_261.part.js": "e37586195c7d938378a0bb5a721f2cfe",
"main.dart.js_344.part.js": "48a651870eac5d5063086b2bc813b0be",
"main.dart.js_322.part.js": "5d1a99b089ba4da3bb9ed96e66ff5cd9",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "0ee89d5718ca3530c1babe183ce69004",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "07536c14357c4228a74bac89f6ed75f2",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_341.part.js": "49e1a943567b23ec23f547e679a33359",
"main.dart.js_320.part.js": "6ccfb59dffcadec33eb5baab5974c997",
"main.dart.js_228.part.js": "55ca6503f99e14a9380baa2689632ad2",
"main.dart.js_292.part.js": "9a9db8a6cc94f72a51179801d7407c19",
"main.dart.js_284.part.js": "7a70f378d0a344e9c54a27490a2dbe83",
"main.dart.js_296.part.js": "76c03c4f831025640fad4e54d25da7b1",
"main.dart.js_278.part.js": "5ce3deb495ed1e8eb8b24faad590d558",
"main.dart.js_336.part.js": "aefec206b8469bb893aa4c8c5ac31a33",
"main.dart.js_333.part.js": "19e14a2773c91f6f9cfabb367a3c8641",
"main.dart.js_287.part.js": "dfa3bb5855171e15bc0cc3ef9c0cdcde",
"main.dart.js_331.part.js": "e1ce964cd84381934d5a07b5d4a2ff0b",
"main.dart.js_252.part.js": "764be03f7581454fe6a3f0af9f834d89",
"main.dart.js_269.part.js": "9e928a4d1ae7180cefa0806c4625fc8c",
"main.dart.js_312.part.js": "243aef177fc0f9a537d8ef8b53bde036",
"main.dart.js_325.part.js": "25ebbb5ae2649cb8a6e592ed268621cc",
"main.dart.js_298.part.js": "d4883e72d9597c85b1edbe46158c9a4e",
"main.dart.js_270.part.js": "e864aec64480438ca65ac9d4262341b6",
"main.dart.js_321.part.js": "f636dcf9adef6c0e963efc63f341a1e7",
"main.dart.js_273.part.js": "7067371fc2a0bda406f08f9cc87eedcb",
"main.dart.js_235.part.js": "4f82bc31018f3f5f3647a92e5708133f",
"native_executor.js.deps": "3777817ddb1687147f834811f58eb9d7",
"main.dart.js_332.part.js": "6a42cc84930421d495da765d09fdb298",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "8be07d2448f37e648c9a309001e607dc",
"main.dart.js_314.part.js": "db2e52985589c2c33a1a5d3b6ee812ba",
"main.dart.js_342.part.js": "7f05e511474d5268852287f995d7860b",
"main.dart.js_307.part.js": "e6fdd64397baddec14d31b5fe5c4bc3b",
"main.dart.js_319.part.js": "1c9245cc406b648f03f381ee477b1481",
"main.dart.js_343.part.js": "6d4b52ee6e771ee11d033dc20bbf06d9",
"main.dart.js_335.part.js": "2d0e8807c041a46acf075e8705bd3aa8",
"main.dart.js_324.part.js": "6c17fe6c6b68293e2ce12d2d022e2ce0",
"main.dart.js_337.part.js": "6ef5b56fbb77272a8f4917eb999cfe47",
"flutter_bootstrap.js": "981d09824bcbc5557199113972d5f00e",
"main.dart.js_304.part.js": "2cda7b819e5340017a5c5f70b007d12f",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_293.part.js": "85fbe44a3bdb6fd462c129e358f118ef",
"main.dart.js_222.part.js": "a5f5a78cddc97fdf1dcca211ad0190e2",
"main.dart.js_326.part.js": "795d0d4641ea191f75bdc63fee8c5c33",
"main.dart.js": "e5125994a8f4a2a81e17e8af4c3af3ce",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51"};
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
