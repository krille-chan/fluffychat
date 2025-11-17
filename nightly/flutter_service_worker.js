'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "568b715a74c7059828625578b8b38b4d",
"main.dart.js_259.part.js": "44b308f03671ce51f91ad700fb3b93b9",
"main.dart.js_1.part.js": "7b0bf1e329e6f3802c3234be3e0b7224",
"main.dart.js_260.part.js": "3d0724eb0829b65b41d6c12d7961ecac",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "d75415684031777c828576c74f9b10e5",
"main.dart.js_280.part.js": "f58ea9f6d34d575de5ab164fa77ca0c7",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "53e98f4bec7f2fa608f1755d5cad3ad0",
"main.dart.js_211.part.js": "5675713a37b53a559b5033005d016728",
"main.dart.js_266.part.js": "82e3e2d801c3c44be409d82e19c1ad8e",
"index.html": "829fc190cef928c0560e1a5fe65757d8",
"/": "829fc190cef928c0560e1a5fe65757d8",
"main.dart.js_302.part.js": "4aa0a6f774c28b3a465de0baa7199f70",
"main.dart.js_217.part.js": "ffdbbda823a8dd07a666b3a2b1a3b6f8",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "c840b9460fce722a8e6a9025fc508ea1",
"main.dart.js_327.part.js": "a122268d6f4593a0d65054bf3158f493",
"main.dart.js_305.part.js": "fe124d74c0881775c4dd641c097079a2",
"main.dart.js_258.part.js": "1f4fa34fa224bae4f624bbf954d9d1fc",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_300.part.js": "df33e0979c57f09ffa2bfc180fe9deea",
"main.dart.js_262.part.js": "08c5625f97aee1b6f4ea508177dd5155",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "c9aff0a644308bf57f3d62bab99734c7",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "50c84084a133eae450fffb8d6444bc3d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "96b0bb5be20cd33cabf8b7e9d3cea283",
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
"assets/fonts/MaterialIcons-Regular.otf": "cf04b1acec037d1bfe7beae9ec5d43f3",
"assets/NOTICES": "4de3f617c2e220cbcf134b0c31162a7f",
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
"main.dart.js_320.part.js": "871a970f941019d2e4eb68b1082c23d7",
"main.dart.js_247.part.js": "c77dffeab49f357e6783e000dcb0b4b6",
"main.dart.js_292.part.js": "be0429ba153747c79a2ac4386b5d703d",
"main.dart.js_284.part.js": "4a750d89cc2387b8da2d64dde8df1d7d",
"main.dart.js_16.part.js": "5e8856e548807b4f77401aae5abe1884",
"main.dart.js_209.part.js": "31286684901f76279702e1d23d28c383",
"main.dart.js_229.part.js": "3481b84e7fb276c64d1768fba44b8855",
"main.dart.js_286.part.js": "8c1bf72667f6c7518678583529347a29",
"main.dart.js_232.part.js": "190c765151022833bb3cbd2de42dbb6e",
"main.dart.js_331.part.js": "d585ab4beecaa5a12e4d100bb4a40f5b",
"main.dart.js_313.part.js": "49ff9e9414b0a5cb9b1dde7f3f9b2404",
"main.dart.js_309.part.js": "481d5a44e2a19ac01bcb5f8df6e950f3",
"main.dart.js_312.part.js": "0e397c01513539e646eba800ed77a9de",
"main.dart.js_325.part.js": "3bdb3394d7be5ece9c78591fd46452ff",
"main.dart.js_285.part.js": "6c66c4214d56075a26a0ffb2ef2f38cb",
"main.dart.js_270.part.js": "bc5954df95b5f06b8d82d3b7a581e850",
"main.dart.js_321.part.js": "9e589ff66f18c4405f8e9a45ed22d5a1",
"main.dart.js_268.part.js": "2ec7bb342dfccd0e737e3ed9457dd317",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "61127171a1cee3aec3272a66adb0e763",
"main.dart.js_281.part.js": "07077262f8de4089c6ab397a07fcdff9",
"main.dart.js_332.part.js": "6594ad3e9e1b8c60b3b8e139fae426f7",
"main.dart.js_314.part.js": "6e5291988efb43b13b8cb050010f5647",
"main.dart.js_307.part.js": "685fa715f4f785316f29fa68e1d225d0",
"main.dart.js_319.part.js": "965011fd46b60c6acf64e670b514f5f7",
"main.dart.js_323.part.js": "088a4503ab7e2de96c2f5a186291ea73",
"main.dart.js_324.part.js": "da06de239b7829836de5e2531905f3e7",
"flutter_bootstrap.js": "7da4a31077415c3cf50966f5541e76a0",
"main.dart.js_315.part.js": "7ac4a17622aef6e11f873abc78687884",
"main.dart.js_306.part.js": "620f3a66cf679e2d328545d4a24c2362",
"main.dart.js_276.part.js": "302c9420efd5d6069f3b93fb70d13796",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "f634cb07a052b3c0a798a2b3172c834f",
"main.dart.js_310.part.js": "3c9e98c4adc6255650d99edb9c69c62b",
"main.dart.js_326.part.js": "25263c55330330996c8dbda3946988ab",
"main.dart.js_329.part.js": "b44e8024d62f77a057ad5749bf7f6259",
"main.dart.js": "506dbd104413f45dc4f71f0b95676f31",
"main.dart.js_272.part.js": "1d604fe820599fef8c44c7bf05f07300"};
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
