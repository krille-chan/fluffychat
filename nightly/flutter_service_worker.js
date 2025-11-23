'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "ff3bc9faad491f6e526d72828ac42126",
"main.dart.js_317.part.js": "52af1bc2d190163828997b9424ae787e",
"main.dart.js_1.part.js": "637ec2c2f7f0ffe4738c01d13e8cfc48",
"main.dart.js_260.part.js": "8e999bfdc0c4e03a8316bdbb7f708f72",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "125c2e583e491ba2e0b770b1e48a5483",
"main.dart.js_274.part.js": "b6ddb02d6c1d6b12e5bb153014380506",
"main.dart.js_318.part.js": "284fd448d503f24602aff58c3c9f2978",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_211.part.js": "9e4525e9931e367456425d7cf5c56f17",
"main.dart.js_266.part.js": "659a972ca4749ad008f1ca2b829273b8",
"index.html": "36f90a4c063acf679fdc80c1b071c98c",
"/": "36f90a4c063acf679fdc80c1b071c98c",
"main.dart.js_302.part.js": "c474b998dbcda3b62080691453284455",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "653f503bc745e0f3ac2b27935262ade2",
"main.dart.js_244.part.js": "5122722973cc9a7e80dce7061465d3b2",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_294.part.js": "aca22e1425204e3d315145ad7100af3b",
"main.dart.js_300.part.js": "d1668029e241585a9eb8581fbbca937c",
"main.dart.js_262.part.js": "f396703630a38cf7ae26f571300bfd43",
"main.dart.js_299.part.js": "a816cab7cffd0c6ef5e3be6e9eff30c1",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "9d751f20f149e5ef8c605325aa7fe791",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "05d4021e11c976ab0ab037f821e44c64",
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
"main.dart.js_320.part.js": "615ca7086bb2808337dc7eb6fb1d3ce2",
"main.dart.js_254.part.js": "6628348f1a0776ed7fc56a105a1a3d30",
"main.dart.js_296.part.js": "9260c1f45ed6ef5f180eab0b1f78a689",
"main.dart.js_278.part.js": "7b81fa1635bcec3812a974336bc4408f",
"main.dart.js_205.part.js": "88537e3724859250e1672323bb732667",
"main.dart.js_286.part.js": "ac94ab73debe8f33c1b4a43aa2dd061d",
"main.dart.js_303.part.js": "9b36f5ceea6468fa5c881784c3442082",
"main.dart.js_287.part.js": "72b6795f14b7b7094e6d88c53c82c1e8",
"main.dart.js_252.part.js": "c9e4d31b2320190fc88658580fa1a8ee",
"main.dart.js_269.part.js": "9d30c5997863b1494e3349e73fcfd7c8",
"main.dart.js_313.part.js": "57c303482ac45ae636319d9cb3a8a97c",
"main.dart.js_309.part.js": "21e12439882227b9fe397c0059317fbf",
"main.dart.js_325.part.js": "604275c40330c8df35e6597c98d64204",
"main.dart.js_270.part.js": "cdbc28bd191f34fd05cf457c82f0bafe",
"main.dart.js_321.part.js": "65ccaa22c7bc853f852c45534ad4e72b",
"main.dart.js_235.part.js": "b817fcf8cf96e53863fecaad8a262490",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "8f8d906b232e13c03d4d0358a120223c",
"main.dart.js_314.part.js": "aa12ba69d0c414e471d756177f9604a4",
"main.dart.js_307.part.js": "518f43840930f996be112be5ba2b1210",
"main.dart.js_279.part.js": "771eb0e7589d95ce7fc185da86320a19",
"main.dart.js_319.part.js": "80628222ca0a6185841dffb16d85f289",
"main.dart.js_253.part.js": "cbbc1880a0dd79231a3a15065bfbf538",
"main.dart.js_323.part.js": "9f3aa5c2f2d2641ddb6edc35d4466372",
"main.dart.js_324.part.js": "c321241e919271894bdbb8b1c7e0206b",
"main.dart.js_203.part.js": "1800d41a57a8e2062d70c85d01193347",
"main.dart.js_289.part.js": "25cbedec59601471e3fd871a8589598d",
"flutter_bootstrap.js": "e9b9b1fafd407965139a983dc095e398",
"main.dart.js_315.part.js": "f38513770ebc8099a3f889251891f37a",
"main.dart.js_304.part.js": "9678f8ec81fae60abca3c8fad39e48e1",
"main.dart.js_264.part.js": "72312d98a82b8032d22190e5bf9ce54a",
"main.dart.js_306.part.js": "19cdc6b53be53200e61598263255a286",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_256.part.js": "e42bc618ad8c98244bd0381a325056a9",
"main.dart.js_326.part.js": "f697d0623eadb6c370ee97352fa3462c",
"main.dart.js": "2b998a90f1183fc4098f00dfa481c359",
"main.dart.js_223.part.js": "f3e15c361f71f19c00cb34d482349ca8",
"main.dart.js_17.part.js": "1d0ad5e54a49628b2fec40965f260086",
"main.dart.js_226.part.js": "b9216e16babc1ef6e938198dd6fa0d92"};
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
