'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_297.part.js": "5e5df983219d734f2bf0aa0f6af8dcf3",
"main.dart.js_330.part.js": "7ea7f06aad0edf29a9c26f2132c1b5bd",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_337.part.js": "d4278fbb16ae6e37b9fc42ca5dac9a91",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_289.part.js": "d1127b451d8377e3dac3d39d6b306102",
"main.dart.js_323.part.js": "adabbe179ed7416bf5dc1a3470e15515",
"main.dart.js_271.part.js": "0936772844eacc6570d1d30c2d8bea0b",
"main.dart.js_260.part.js": "218b6d51aeae37695d67b138f1ac8be5",
"main.dart.js_306.part.js": "661bbd856236dd2205e673f94f898037",
"main.dart.js_283.part.js": "c8e314dd6bbeddf55ff14ed500ccb32d",
"main.dart.js_331.part.js": "f5b11a27eb8e92d9a3e1a3677ffdd6a3",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_1.part.js": "43b2aafd95fd8ca412211c5451420f8d",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_310.part.js": "61ada4edf3d6b186ff9206a85865b918",
"main.dart.js_252.part.js": "992cdbcb81ac8eaca64a921bfc673d95",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "278dac08947576753a6f65ea869da6c7",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "89aeec0ff876b98160839ce715438ef3",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/NOTICES": "bb996c07d204075548650834d02e02fb",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/particles_network/shaders/particles.frag": "1618a243a3c1ee05d0d69d7f0d8ce578",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/AssetManifest.bin.json": "045a6fd0064669d9c6e2d4eb44bc7068",
"assets/fonts/MaterialIcons-Regular.otf": "59e871f2bf0a7a405652ee3737782a10",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "db9a24a16187744848654f7d6b506c01",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"main.dart.js_264.part.js": "4f37d65f9d549a07da2ecc4d5f190bfd",
"index.html": "2395d09d09aaa3258f30ed1d94ff2019",
"/": "2395d09d09aaa3258f30ed1d94ff2019",
"main.dart.js_316.part.js": "6acaa8192e72c41c37dff7b8c4e1e19a",
"main.dart.js_218.part.js": "a3ab0672f291b3e07e7d7255ea9c2b60",
"main.dart.js_233.part.js": "1fbcbc7884aa143833023be99ea43118",
"main.dart.js_332.part.js": "02f444759276263b6185c870332da894",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_336.part.js": "ec4cb7b01a19f1c49ded93065b207422",
"main.dart.js_299.part.js": "ad4ede080c99c392c6fc91fbe0ade995",
"main.dart.js_328.part.js": "7a0ffabc25ba35d6f2507dd54cafe4ed",
"main.dart.js_210.part.js": "3080dd7c310bbfff63162722bd710e88",
"main.dart.js_329.part.js": "65cc908efb24d00808efed022de1df0d",
"flutter_bootstrap.js": "62e623c74764475b83f3ba78a3a27b72",
"main.dart.js": "a9dd78ddc0393a4d6b67bb1e3699619b",
"main.dart.js_312.part.js": "9f6ffd289e98f5d471c188f605643488",
"main.dart.js_2.part.js": "fd3741be9c6bba0541b519ab3e8890a2",
"main.dart.js_287.part.js": "1a93d2e20d8ff1e1a382bff28d1724f4",
"main.dart.js_269.part.js": "8f0bc3f4d36cf9a743c25fa0d01a5af8",
"main.dart.js_318.part.js": "0031dbbf7cd70b3e0e580d111d5298f0",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_313.part.js": "02f73056440eb5e1df0e54d4fca04e86",
"main.dart.js_249.part.js": "4ce77350291a194cac9cc0e4b0d83cc2",
"main.dart.js_212.part.js": "e96a94b07141050344a347837dbff531",
"main.dart.js_317.part.js": "1914eef8e19a234338a97ccf2b3376c6",
"main.dart.js_325.part.js": "038f716b5ec72959fcb2a9bff4681ad5",
"main.dart.js_311.part.js": "8559b8964c7a93dad2c1822229918da3",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_288.part.js": "f08e5e923edf6b76ac5da84936540bd0",
"main.dart.js_335.part.js": "f612b063ff3de5f72fd1c8594e3f4c70",
"main.dart.js_324.part.js": "59fb974e812d1f989cb5b7222da26115",
"main.dart.js_284.part.js": "df23244e70d55a276ba8239a1ba9f5f0",
"main.dart.js_275.part.js": "ef731b5bb086b0492ce4093780e1b632",
"main.dart.js_273.part.js": "7b0083c87c900d8d27fb78198fcf5ab8",
"main.dart.js_326.part.js": "bf908ea2178e5001d05394219187bdc6",
"main.dart.js_309.part.js": "87196ab30b4c2faf9ef992e8389f5ecc",
"main.dart.js_17.part.js": "db36e6db3ab017e34c6debbfb625243c",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"main.dart.js_278.part.js": "e721d6497d4d8a9f0273b966e853bd13",
"main.dart.js_296.part.js": "f0dfc9a71d5e3cae8364581f8b48dd52",
"main.dart.js_242.part.js": "340b5eb748ef8f884b6a45fcc17f3f34",
"main.dart.js_319.part.js": "771f916c7e40b412b73341a52bfe72ce",
"main.dart.js_261.part.js": "50954673e2585a77b049f6432b1f6895",
"main.dart.js_279.part.js": "4f82f6f8bfd5ba1284886dc0f6b3d1c8",
"main.dart.js_225.part.js": "2980603b0b74a71475f2326256cabc38",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_334.part.js": "ff076314354d9b164199f8524f504e9f",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_304.part.js": "abbf5a229fd0e052f2fe64b475532da6",
"main.dart.js_262.part.js": "be01dabde5621431438124a7e987a095",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_314.part.js": "adbecb0fb74dd4c2366a252db380cf40"};
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
