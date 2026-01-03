'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "6d4369854437750bbf5c5e827229021c",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "ed77f164682789b4824e7a9f90b4cabc",
"main.dart.js_271.part.js": "e92a48cf88db9109127769346e1f2676",
"main.dart.js_259.part.js": "09cd37ba16d4c66103bfd2d79b11b535",
"main.dart.js_297.part.js": "6269de7213d993e393e6da61b6d412cb",
"main.dart.js_1.part.js": "90ee68db5feaaa979cc7f9c6a0ebaaa7",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_274.part.js": "3f4f5449d510e49c995898f937e475e4",
"main.dart.js_318.part.js": "1c97e6593c52aa817aa4aa16023a9969",
"main.dart.js_338.part.js": "cae9b797f901a10fb81bd79b027cae17",
"index.html": "d75668498316a150c1417c22aa12d612",
"/": "d75668498316a150c1417c22aa12d612",
"main.dart.js_18.part.js": "c0a25b40511d81265c59846d6f5e327c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "18da049d7c914c8f1600f511577f3955",
"main.dart.js_305.part.js": "9779ff5e9773627134d294a28f9e93f7",
"main.dart.js_244.part.js": "3aa1d0fddf70dd8bafeeff33b4e4c992",
"main.dart.js_345.part.js": "5e7def1a953c6457a943b70c0209a06f",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "6157f1b462d9ae81da768c9d86b48288",
"main.dart.js_294.part.js": "93c9535dafc101f52070d5872274ca54",
"main.dart.js_262.part.js": "c95a68902337586b9716644cb4efe0bf",
"main.dart.js_344.part.js": "86cbdc00d680aa77fec9a02f4d8d36c6",
"main.dart.js_299.part.js": "7f7ac47a3039ecfff8debd6ecdbe6fe9",
"main.dart.js_322.part.js": "677c47e10362874d17ffafdb5dfa8881",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "193cc5073e753748c03d7dd7338baf8d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "720a5ffb1824c0f2a02abc0b48f10e7f",
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
"main.dart.js_334.part.js": "92ebdc3e471f6cbc34b6eb9b33e2cfd5",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "f232bd84fa880e358aa0848930cf8483",
"main.dart.js_229.part.js": "2f20b74f95adcaad28f39375ab0dd27d",
"main.dart.js_336.part.js": "76bf2e678e04a1d7172b643e447db3f3",
"main.dart.js_333.part.js": "8c99d0a3ca948434ad5c2fb89290d5f6",
"main.dart.js_340.part.js": "41a1cf5bcbe3e6e240495b5424e99703",
"main.dart.js_313.part.js": "aeea9f053ef58e2b2a8d88da5c1199ba",
"main.dart.js_325.part.js": "ee81e87a17d59c281045c782bd6e4f85",
"main.dart.js_298.part.js": "15dd84733d38a56a03f687b6fb1c0ac1",
"main.dart.js_285.part.js": "f5bb8d50b4e5ae7ed228aab52022e09a",
"main.dart.js_270.part.js": "83e260e9951e4bddf67de1be28bfcc18",
"main.dart.js_321.part.js": "9a808572899279a4b1b653ec68ec3420",
"native_executor.js.deps": "3777817ddb1687147f834811f58eb9d7",
"main.dart.js_281.part.js": "fa1281114c61889740c70f5255b673e7",
"main.dart.js_332.part.js": "2dd3cb92577c683b3e7f0eb96e74a26b",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "fd80911ba895ac4282c7cbd50fe0849e",
"main.dart.js_342.part.js": "34d579d6415d5a886ac54bcb95821619",
"main.dart.js_279.part.js": "7900770af0963095fca9ddef1da09cc7",
"main.dart.js_319.part.js": "15d2914d2c00354b30d5e3a788ac1981",
"main.dart.js_343.part.js": "26735174490f7276382e66e6c05bc91e",
"main.dart.js_253.part.js": "f22563de1cf99dd82549ebad24538f3c",
"main.dart.js_323.part.js": "13c7b647a53d55d64b068de835197dd1",
"main.dart.js_328.part.js": "994474404b7a50c75d7e565f35d210a5",
"main.dart.js_289.part.js": "809f65bf044a5be38f80a24052abdbc2",
"main.dart.js_337.part.js": "42f1ebeb96a154ab65a5feb1bb5eead3",
"flutter_bootstrap.js": "2df07586db16927f17ed4cd0bc53174b",
"main.dart.js_315.part.js": "b2b1dfd617339131ed87bfbe7619788b",
"main.dart.js_306.part.js": "25006d6fe692c6f6e1133857b96df2f0",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_293.part.js": "d9d9b0c2766b7a5e0ecf25c850f3fe4f",
"main.dart.js_221.part.js": "1a4cfb52cec510f9f71466a12da0b048",
"main.dart.js_326.part.js": "e2647ad4fa71e7440b077d74e5915345",
"main.dart.js": "55dd2f4fde65a74d3a5cb7a00721711c",
"main.dart.js_272.part.js": "363d3b347b541f8a532c5f617a07cadf",
"main.dart.js_223.part.js": "680c412867d3c060945690980f610a35",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_236.part.js": "bf0da9c25e75b2834aba3ac401853401"};
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
