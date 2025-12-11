'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "0d1d37088e855fbc24c23a883af5da03",
"main.dart.js_308.part.js": "383004023293b53d81a6e54af5aef162",
"main.dart.js_317.part.js": "feefad0e8e03422352296f4fa83c0963",
"main.dart.js_243.part.js": "c929829fba743ea81cb8534413457dcb",
"main.dart.js_297.part.js": "82649745eb207205a8b85e53276c1639",
"main.dart.js_1.part.js": "ef604f72d98e9538caf6e9efc46023de",
"main.dart.js_260.part.js": "bbba227e62e2b4b7acf6d19cb6079057",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "d25b8e3642c98a6f22fed7df5fdd48fe",
"main.dart.js_274.part.js": "f99334370bb0f0ed0794c43f54c4475a",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "1da23e8b18e200f02f5e232e5c5cb31c",
"main.dart.js_211.part.js": "8d613f0c1bd85e59627d873cee7b25ea",
"main.dart.js_234.part.js": "138a7ae9c17345055bb3b61aad1850ba",
"main.dart.js_316.part.js": "f32b497410739b793a08fa07e4b6a975",
"index.html": "08ea0b00ebe281a06cdfa4d241b9ac6a",
"/": "08ea0b00ebe281a06cdfa4d241b9ac6a",
"main.dart.js_302.part.js": "90824f9bda27e394f6a9866ee1831a6f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "629f3769f1efeb6ac13cb8e4bacc17ab",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_283.part.js": "9134abe9a4a77746e2366e117c911b82",
"main.dart.js_294.part.js": "682b092ec4b5e6f330e99601585ddb3c",
"main.dart.js_261.part.js": "bdc9b6c9a3d4737511483f18baa5b6ff",
"main.dart.js_262.part.js": "631ca109b17142f0718285b0ac53a29d",
"main.dart.js_322.part.js": "4b680ad3bebf2bfa25dde06399523b8a",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9fd620a5096ec4c68c6281cb0c27d5c2",
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
"main.dart.js_334.part.js": "ab29ce34229fc61817c4bcbe520d9e2d",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "654bb23383939bd7a278e31492a827b7",
"main.dart.js_286.part.js": "bafe9ef14e90ce8c35270979abeb3016",
"main.dart.js_333.part.js": "78716999d11005a96fa95ec19e064eed",
"main.dart.js_287.part.js": "0273dc7c9ce17f6a1152f150c3b076eb",
"main.dart.js_331.part.js": "48a1f99275e0741483641a7e23864418",
"main.dart.js_252.part.js": "0ebd3ec6263c3812df52cafcde27e355",
"main.dart.js_213.part.js": "270a1d79794606087dd487e190ed0d40",
"main.dart.js_249.part.js": "8a840567bbabdbc54ef62631a3423790",
"main.dart.js_309.part.js": "a8cbbefa28b1e3310ff77163b91a7472",
"main.dart.js_312.part.js": "6227f44ed328ef1f29f4a2a293601e8e",
"main.dart.js_325.part.js": "be8bf201b0ac5c4ee6d13ea8519fc977",
"main.dart.js_270.part.js": "3d5de56f4c126b78f51890d804ef98b9",
"main.dart.js_321.part.js": "1edbe8d45a51fe967793b8a76faea2ad",
"main.dart.js_268.part.js": "780f0d715aa0f9d834d920634dea612e",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "58701f7b2f02a642ef6f0b1531662ccd",
"main.dart.js_288.part.js": "546951252ab123f20510ac180a171f13",
"main.dart.js_314.part.js": "2674ce2a19fb5002a5defe25d89de093",
"main.dart.js_307.part.js": "916e02b171d95d6d9464d9edd7476940",
"main.dart.js_323.part.js": "ba62050ceca8d9bca734432b745c8fea",
"main.dart.js_328.part.js": "7f9499bd9d4dbd467784aea2c469b66b",
"main.dart.js_231.part.js": "a865242c1e6be02ecacdd53680606600",
"main.dart.js_219.part.js": "fb1a74502f9baf0641775073e391d403",
"flutter_bootstrap.js": "e27c075d133fa6b53319889a18372bce",
"main.dart.js_315.part.js": "26af1acff1da484e2568264c711f571d",
"main.dart.js_304.part.js": "b926578ce4171e7fb2eb3363c5c3e82c",
"main.dart.js_264.part.js": "edf0ea9271dfbf1c9398814c900c836b",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "616adfe86b4bff7472ae9aece459e3b7",
"main.dart.js_326.part.js": "bcee6e10cec77d019aecb0ed209be768",
"main.dart.js_329.part.js": "48d8c34e85a4a4532e095f989d55b299",
"main.dart.js": "fcb074bf1590d392605a898f584cba25",
"main.dart.js_272.part.js": "319932d691db83387778abdb19a16c8c",
"main.dart.js_17.part.js": "31320b65abbd716629a6901f31498bf6",
"main.dart.js_277.part.js": "18332d059830fca12266e0bfafcb2a15"};
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
