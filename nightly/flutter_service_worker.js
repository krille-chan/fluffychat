'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "98884caec9e3c29522e66ae50ec154d2",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "db8498dba9222dd89bd527dcdc768750",
"main.dart.js_271.part.js": "80d270e6615956d92d98f841ab34ba71",
"main.dart.js_259.part.js": "8352f2d488b98d1e693095c13dbd8d30",
"main.dart.js_297.part.js": "4426e04f320f44a58ad8ecb8e98d010a",
"main.dart.js_1.part.js": "009c830eafee52f4e40d28a20c74ebe0",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_274.part.js": "e71a1fe47592f9ac1ac88c9831f69585",
"main.dart.js_318.part.js": "d540f31e3d4677756d7a3b013a02b69e",
"main.dart.js_338.part.js": "97ce8e1910c197d1b8e7713433528b91",
"index.html": "3eb461201d3bf8627cc1479eaaaaf165",
"/": "3eb461201d3bf8627cc1479eaaaaf165",
"main.dart.js_18.part.js": "2fb363258d707c8f859db86abaf90504",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "b8d906d8ef732de1ddb91246fe4aa009",
"main.dart.js_305.part.js": "58c0535d0e0986ecd62c4fef75b21f79",
"main.dart.js_244.part.js": "6abda44df9e1320cc6f2da10034c43e8",
"main.dart.js_345.part.js": "77910ed9f08c2ea3a1cc79ba832b52f0",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "3f253657c72f07c0fac79b3fc6af546f",
"main.dart.js_294.part.js": "6e2e378690bf3d999485d831ca2e4d14",
"main.dart.js_262.part.js": "405ec54103f0a0b5521bf4f47e7aa223",
"main.dart.js_344.part.js": "746f2293e73a41b4a0a3ab84f875b380",
"main.dart.js_299.part.js": "ef78bc75a94062d4cb3c548584500e4c",
"main.dart.js_322.part.js": "e5086c244d8a9dc46b551b411a479a0a",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c17af0850a1b9e3fa29e6dc285cbbe31",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d8a180a7a69f7559dc198660737f1132",
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
"main.dart.js_334.part.js": "38bfcaec25a0266147905b206e37822c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "cd5de091ab5ff024fc29c56e9c4f29cb",
"main.dart.js_229.part.js": "49ca5a50771ee0a08e8ccd80f78f7c7f",
"main.dart.js_336.part.js": "c7a6ccd0f8f84e9f8537dbdf472cc965",
"main.dart.js_333.part.js": "2f34b3d23eea9835905269c959ef576f",
"main.dart.js_340.part.js": "c2cb9acccad3e0fee25f9307fac96f85",
"main.dart.js_313.part.js": "b80381d54f89c6fc36e25dad31cf06f0",
"main.dart.js_325.part.js": "506c6b3dc39b2cfa3899771f281730ce",
"main.dart.js_298.part.js": "f80fce574d24fd1bf98434c53f70771d",
"main.dart.js_285.part.js": "c46941a3aef495b078163c3c23414756",
"main.dart.js_270.part.js": "3d03db3f4557ea38b4c51d6c991bab34",
"main.dart.js_321.part.js": "5255321fec50e045497c7ff2e497d38f",
"native_executor.js.deps": "3777817ddb1687147f834811f58eb9d7",
"main.dart.js_281.part.js": "9f000037e3ef6cd6ba96daf9c6ee35f0",
"main.dart.js_332.part.js": "38b9b83e5492257f552fb4f6763f365e",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "323592b3d3b8c0acafa387c828c79d26",
"main.dart.js_342.part.js": "0f56a4fc8faafb2cbc55d807c3fea2b0",
"main.dart.js_279.part.js": "54977945ccf73a554f87c8914f912ffb",
"main.dart.js_319.part.js": "2bc46d99c0bddaef85a3a738604cf0d3",
"main.dart.js_343.part.js": "e29a301db021be7dd6db9f388991e6dd",
"main.dart.js_253.part.js": "bbdf999564645ef9502f83d9b9c8f524",
"main.dart.js_323.part.js": "012ae5cf8c15f3c3164c38152d9e5d51",
"main.dart.js_328.part.js": "3f5c45307f3110f48760a1b4c990e22f",
"main.dart.js_289.part.js": "df3179f6b2177c4160def5b94bcf03dd",
"main.dart.js_337.part.js": "aa04a8d4c76e59219de0a152083501c7",
"flutter_bootstrap.js": "27f40338b9e30830d70475a61ce9973d",
"main.dart.js_315.part.js": "f0e44064e7a6577d6797d5874fb1f104",
"main.dart.js_306.part.js": "3f9d7adebc55507e94583033e5b8be61",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_293.part.js": "6fb85c2d5bee21d67452d20b6f3f7192",
"main.dart.js_221.part.js": "f3a98c6961369416fca65c60021ebbbb",
"main.dart.js_326.part.js": "8c01eb60d493d873592783c84572440a",
"main.dart.js": "545bf01517edcb298cf29985723ed483",
"main.dart.js_272.part.js": "28456b29d7dad407168565d01ff9e9cb",
"main.dart.js_223.part.js": "c122de5d588d9aaccf9f9075817bd770",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_236.part.js": "2ddc0190fda18a1ab0e79424843e0dc8"};
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
