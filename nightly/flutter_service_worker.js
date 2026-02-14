'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_297.part.js": "70741ce4e46a672b87aed94a0bb755ef",
"main.dart.js_330.part.js": "66ad3a169a5f7d98db6a5b06e3c6d7f4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"native_executor.js.map": "6b9b2b5aa0627d36f049c05e107931e5",
"main.dart.js_337.part.js": "ae876d0e99e42e51df3b17651feec4ac",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_289.part.js": "66d914d31f56d2964e87f84505e817b7",
"main.dart.js_323.part.js": "39786e3937bf393cac9dbeac07564fe1",
"main.dart.js_271.part.js": "2189c94deb2307aaade509106411e69f",
"main.dart.js_260.part.js": "3b2c8f4c16ef7ca5edb31bc9cb81af34",
"main.dart.js_306.part.js": "66150afa310021b358e0470ac92f5fc5",
"main.dart.js_283.part.js": "0e1900f56a07c75b3da9386288c97a47",
"main.dart.js_331.part.js": "c6bcdc9683067e8858ad44c67a65cd8c",
"native_executor.js.deps": "e74a0d6d9ee9a5db708165299cbf9059",
"main.dart.js_1.part.js": "f03759b2c41590782c5f347c6489fcc4",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_310.part.js": "13eb99670bc8c18872a5ed865d2a7b2e",
"main.dart.js_252.part.js": "df914d8aecfd49d4adcbb3be5f591ff3",
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
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "db9a24a16187744848654f7d6b506c01",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"main.dart.js_264.part.js": "7856744feb4c62a988578be99914f5fd",
"index.html": "3155241a9884918b535a94dcc954419b",
"/": "3155241a9884918b535a94dcc954419b",
"main.dart.js_316.part.js": "dd53b2d8cb0ca60f7d2c8b65f6fddf70",
"main.dart.js_218.part.js": "036ec9446673ff84d7fdb6a740a59581",
"main.dart.js_233.part.js": "90c4ef8bfb6874d02142821914a878e0",
"main.dart.js_332.part.js": "fb4fc44001daf01c837004c1c9461a70",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_336.part.js": "7cd5a3165905e17bd253eb1d28efece0",
"main.dart.js_299.part.js": "01dfafed477de9a12aa7ee38eb8e0883",
"main.dart.js_328.part.js": "0b189fbb48559336408dee1dc6116e5f",
"main.dart.js_210.part.js": "1d606fe1bacea9ad2298a4ba5db4d05a",
"main.dart.js_329.part.js": "639817a300ecf2dc7956031fafea81b4",
"flutter_bootstrap.js": "d04d7e9907d5c14ae83ca3becf79108b",
"main.dart.js": "a86b99b58b086edecd9c8f7f931ef023",
"main.dart.js_312.part.js": "89e82ced1f7fb687d3c7cc0cc115c7c3",
"main.dart.js_2.part.js": "374aad1723772ba5a823f277c3594dce",
"main.dart.js_287.part.js": "256af2b84d0bd65911d483d2f2e62b9c",
"main.dart.js_269.part.js": "047cfbb15dff59f71fdf0a7502faf675",
"main.dart.js_318.part.js": "15be5277a6ef247acab6a7a2395cfe11",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_313.part.js": "b65511feba3dbaa2c7e23747cb60e300",
"main.dart.js_249.part.js": "0c952f07f00f10ebe38854a384459613",
"main.dart.js_212.part.js": "6f4af8b29d33ca20de5852fcdb950bae",
"main.dart.js_317.part.js": "1606ddc61426f55b10c1f4c1a2d2fd89",
"main.dart.js_325.part.js": "fafbfa35ddca54b24fc8725c250b6e4b",
"main.dart.js_311.part.js": "aa80bb309290ec1bd33773398a1cd663",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_288.part.js": "4d081f8a8d1d8139318697c80fbf789a",
"main.dart.js_335.part.js": "f763169c073d83b6b83be8a532d21d21",
"main.dart.js_324.part.js": "2ac3b0d8d3e8e67fb43f524494b01b44",
"main.dart.js_284.part.js": "4e164e866acf8d622eb238215ff6059a",
"main.dart.js_275.part.js": "51a36d63282983657997e98276f9cc1b",
"main.dart.js_273.part.js": "a593e5cb1d5acd59c39cbcf5a448c6e6",
"main.dart.js_326.part.js": "7c016835d92836948290cf3dd172a2f7",
"main.dart.js_309.part.js": "dfc23ea9fdd29f0d54b1c49f311daaf8",
"main.dart.js_17.part.js": "c02a6a13a4a2a341cc2f01fa1e51cd86",
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
"main.dart.js_278.part.js": "ba30a38ee01cdf384bbf865332645de0",
"main.dart.js_296.part.js": "f43f73443e763f5b459c211012c06bcb",
"main.dart.js_242.part.js": "e8167c2a21b423d0a59574b2006f8de7",
"main.dart.js_319.part.js": "97e6444cbea44f106ff41c3dae41cbb6",
"main.dart.js_261.part.js": "8ca66436c6c24c1d7e768bb3b9a18fdb",
"main.dart.js_279.part.js": "fb7cadf7e78c26b549c4db32e5d47b97",
"main.dart.js_225.part.js": "bfa071f6a41bb8105d329e08bd61a2f0",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_334.part.js": "28f355296dc07a4f125895a7cc79b5f1",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_304.part.js": "8f7a816b1fcc4a149ad5795f2c28b8e0",
"main.dart.js_262.part.js": "3bee98ad0ef71a01e557a3d8ffc436c2",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_314.part.js": "5fdce89251626c27fcfb59bb6df0259c"};
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
