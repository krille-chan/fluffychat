'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_297.part.js": "ffeda2cb983fff01770d4e5ddfdc26ae",
"main.dart.js_330.part.js": "b40efea3000edae9ec9efe5764ba8664",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_337.part.js": "6d445a6d9695a70c9a647af53906dead",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_289.part.js": "731dc03d0a0c4bfce3bd986c040e7cee",
"main.dart.js_323.part.js": "9923d1911f25a7a4810c8e1ec5a59c9f",
"main.dart.js_271.part.js": "7db620a0a0aebce3dd6bce8708caf554",
"main.dart.js_260.part.js": "227ac857e251d5d8fe66847a6d769235",
"main.dart.js_306.part.js": "31ef32afcc52500a598f49baa0cd8e64",
"main.dart.js_283.part.js": "cabf7b33c04f054ed2208e2d5d3e7d7e",
"main.dart.js_331.part.js": "fbc942b33734d5d84b399697bf99e5ba",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_1.part.js": "2d516f2db7b48a16a4ecd56e7cce5907",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_310.part.js": "1945ca0dff6fcd7b88e3d7f21bb2b3ed",
"main.dart.js_252.part.js": "2839dcc72c9ee56069a62964a494308b",
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
"main.dart.js_264.part.js": "1e1a1d759d62eabf6ec8c16d87a995f7",
"index.html": "48aebdc911ba0db0c8214af6a420178b",
"/": "48aebdc911ba0db0c8214af6a420178b",
"main.dart.js_316.part.js": "fa0868cc025ae78a6f3e283fe1472342",
"main.dart.js_218.part.js": "d2c74c0b330544d10c0004e6231849ad",
"main.dart.js_233.part.js": "17395b18c4f398eee1c9d3db2b19aac0",
"main.dart.js_332.part.js": "9d9560c4c2f1edcc1b7251d028549bcf",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_336.part.js": "aae1721d7d0af1825de416b1c606705c",
"main.dart.js_299.part.js": "e7d476354de32e905f1dc255515a33e7",
"main.dart.js_328.part.js": "6c8025802f66b076a92f0a2853fdce0d",
"main.dart.js_210.part.js": "2c6304a280e86383fbb4358b507969d2",
"main.dart.js_329.part.js": "10c0a49e9a3da6e14ccf91358d6abc9d",
"flutter_bootstrap.js": "fb205e4ea78a725938e05fae51a139bf",
"main.dart.js": "209210198106a1a24c78c5b32520c94b",
"main.dart.js_312.part.js": "41a601b4642ed2ff2536b4f3483169e8",
"main.dart.js_2.part.js": "fd3741be9c6bba0541b519ab3e8890a2",
"main.dart.js_287.part.js": "74a73ead7c80fb99ddf5e12e4cbf1372",
"main.dart.js_269.part.js": "3cec7fb5d2183023e0733b8fcddf3dac",
"main.dart.js_318.part.js": "db74a2b2edc3f8bde7ce7f0b5f45f664",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_313.part.js": "f48c28d395b217bf5cbf3a4dcebc1c73",
"main.dart.js_249.part.js": "638b81d3b642288fdddfa9eee0dce777",
"main.dart.js_212.part.js": "cabe7d551f9bdac1d88bc2533de3676d",
"main.dart.js_317.part.js": "58ae7feb9602dfc43eac87f33c1e60d5",
"main.dart.js_325.part.js": "075d6cca790369ccc9aa72d830105f0a",
"main.dart.js_311.part.js": "84172007dd2180953445e36f83f24f51",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_288.part.js": "910db92b1170b074ae112f46bd978dd2",
"main.dart.js_335.part.js": "690376622c73d6bc4cdd8f2adefcc055",
"main.dart.js_324.part.js": "c7e11c749d92f77c8d34002b565839fe",
"main.dart.js_284.part.js": "ef0365ace17f314e0c38529679c0905a",
"main.dart.js_275.part.js": "d18dc9ede7192fce33da9819f2c4b652",
"main.dart.js_273.part.js": "90c09648a3209ecd84986207ba274c25",
"main.dart.js_326.part.js": "a44079d5cdfad456f20af15cd423b34f",
"main.dart.js_309.part.js": "20fa1284cb936fcfeba74032263c5380",
"main.dart.js_17.part.js": "fc24d9304601a417dd9c7d57f72ce91c",
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
"main.dart.js_278.part.js": "813e2f2a85f7798634ee03e0b5d5111b",
"main.dart.js_296.part.js": "b5050901cd7a7f05905a42c2b64e27c7",
"main.dart.js_242.part.js": "7c46914b4260db7b38c19cbe5bb7919c",
"main.dart.js_319.part.js": "819d421ea49f0db589247d062e101a9a",
"main.dart.js_261.part.js": "60cd0926bf6e3e219546b31871819c21",
"main.dart.js_279.part.js": "4b7e2f74a1b4dab25ee952692e4dc5b7",
"main.dart.js_225.part.js": "948b2f9e6360e1af4842c984a0c8d07b",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_334.part.js": "5cf5187701baf8e83dd1a571c1211115",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_304.part.js": "7eaa063d196eaa85ba9830f154c29fd7",
"main.dart.js_262.part.js": "df9ed13a2d477df1ee2adeed911a1f09",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_314.part.js": "c4d6d8baf4cd96e47a02017de1126340"};
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
