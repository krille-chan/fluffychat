'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "ce192089f92499a6c78c331b2d7a4499",
"main.dart.js_259.part.js": "b99f672419cd65e46c7e2c8a7fe1eea9",
"main.dart.js_1.part.js": "57aa8eb4320b82569d19a01a59d248e7",
"main.dart.js_260.part.js": "c01e90420389f5f8321359b7153ebc44",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "474ae65d9f3e82e2a443a808301053c4",
"main.dart.js_280.part.js": "ff174533d26a4a282d18cae9b321d307",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "1710b645e627fb1a4365e7f47b75caf7",
"main.dart.js_211.part.js": "c02bc50fdeb404af7804367c9050b7b1",
"main.dart.js_266.part.js": "adfc3e8adc6d3b2a08fdc18a18ef2b22",
"index.html": "a7a175d5d2c55205cebaa9ea217ff38e",
"/": "a7a175d5d2c55205cebaa9ea217ff38e",
"main.dart.js_302.part.js": "afeee9eae8cc39be7a60b27213dff953",
"main.dart.js_217.part.js": "ee2d31241fb702b50791468482f7c664",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "18ada7decbf68d6fa2b92e7e0ae6510f",
"main.dart.js_327.part.js": "87fb4f63ddc4da0a9e1d223eec781a3a",
"main.dart.js_305.part.js": "0a6fe5a9b83cabf1144958a9685146af",
"main.dart.js_258.part.js": "9f1273c905f523cb5aede1ad4289e6a6",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_300.part.js": "a3e0142034c9289eed9d8967d784dbda",
"main.dart.js_262.part.js": "a7b4b2d6f18a38a0c932781b0a5bc83e",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "fc0403dba8def72e5df3248c215c7b3f",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8df227c4c5e6a53717b601d883b4ae24",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "ce92dacbb1038ba5fd5b4e3dd24daff7",
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
"assets/NOTICES": "c331fabcfaf52ff613895258d86576f1",
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
"main.dart.js_320.part.js": "4f393b63856fc85a7d14e2ea1f5854c3",
"main.dart.js_247.part.js": "3a50d1ec48bf1af4fdb195097e2c5f1f",
"main.dart.js_292.part.js": "4d2be96911549741e924a9098ce749a2",
"main.dart.js_284.part.js": "cb1ed53b74a5bf23f1df2d9c8e41f66f",
"main.dart.js_209.part.js": "d34b546c1a2cbdcf348da0d763d3520a",
"main.dart.js_229.part.js": "9b5e001045109022ba7ceb2c6bdd3baf",
"main.dart.js_286.part.js": "1092ea0f8590c35923abbd5f9bce83a7",
"main.dart.js_232.part.js": "07bd91180bc15e49684183b82d979f1f",
"main.dart.js_331.part.js": "2abb8f7244316acafcdacda43cbfee34",
"main.dart.js_313.part.js": "f764ff79ebef0c152ca38e253b02a939",
"main.dart.js_309.part.js": "eff627efc6237fff3d3a94487744c049",
"main.dart.js_312.part.js": "b0b5a3100bc6aad88ac17c571e4a8e30",
"main.dart.js_325.part.js": "4d3392e51084e680ba819abb9702620b",
"main.dart.js_285.part.js": "e1a77e40564d17a0005236547c998048",
"main.dart.js_270.part.js": "56bae4759550d34c33db93a9c1e07fec",
"main.dart.js_321.part.js": "4f18dc6bf3d949aa679868ced694af94",
"main.dart.js_268.part.js": "25b746cc0b519cc8e6592aa9d14793f5",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "2f873a81513640048f0f7148adc76799",
"main.dart.js_281.part.js": "b274db7361a9566b6f87e08bc0ea20d8",
"main.dart.js_332.part.js": "2dd892c9b086f6d9df833a1de88da4cf",
"main.dart.js_314.part.js": "d7064934af5dbf2e193d0effe9fe9650",
"main.dart.js_307.part.js": "3d94ba6c4940d9b83845672ddad0b2ff",
"main.dart.js_319.part.js": "ae4a067b52e1e72fb9f6d7b077eea573",
"main.dart.js_323.part.js": "cba11711aa88a9860011486c4d290f9f",
"main.dart.js_324.part.js": "91f7f2f7534229e46fd4896a7a3986a6",
"flutter_bootstrap.js": "e2302b671efb959d660b30293eda9332",
"main.dart.js_315.part.js": "2b624e6fab709177f26d44476bd86cb1",
"main.dart.js_306.part.js": "d987072b40a18a681bf5176077c3f703",
"main.dart.js_276.part.js": "f866ec66b42952531ab7500bc5e159c8",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "90d55308466fa2ad2483bfd08cf5e790",
"main.dart.js_310.part.js": "ebeb8a36f559c08f11ccd1ac59b1444d",
"main.dart.js_326.part.js": "09ddf4d06a2ba68b3ed8dc024c3539ca",
"main.dart.js_329.part.js": "a43f7dae27493ddceba1c805a127f22b",
"main.dart.js": "20a134e6ed6d93131b52af2e9a28235b",
"main.dart.js_272.part.js": "2d5ffc63212b94befe815d706ec3a0cf",
"main.dart.js_17.part.js": "74acd3c4330f1535cf246de0ba277a32"};
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
