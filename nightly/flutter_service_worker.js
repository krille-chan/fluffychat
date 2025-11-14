'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "54c2eb864f410c424fa682d114a530b8",
"main.dart.js_271.part.js": "e8181ae3f1c52b7ac9eb87febc52fe1c",
"main.dart.js_317.part.js": "d4b20c9b0951a04ab7f6c07eb99f5c39",
"main.dart.js_1.part.js": "80ca1d800e38a716127c54547a646f84",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "63b05c8332c6594db23a788c87d09549",
"main.dart.js_311.part.js": "748732ba8dcd1c2b06767c067abc8d64",
"main.dart.js_220.part.js": "77c82e20eb5aa372fe668a2dd39eff47",
"main.dart.js_318.part.js": "bbede140c3d2e7ee265f80c686ac6d34",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "e26c4f3188e2cc26babfb3dfbf425e5c",
"main.dart.js_295.part.js": "9f24af767a2aed482205b4f834540dc1",
"main.dart.js_316.part.js": "95ade0db1794418cefdf5a20545db31f",
"index.html": "9c39dc416269ee9dc43da6d44a24a325",
"/": "9c39dc416269ee9dc43da6d44a24a325",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "7ae16225e9e3599cb6ff5b16c3067269",
"main.dart.js_305.part.js": "4ff16d87642ba2479902869d397b6b3a",
"main.dart.js_244.part.js": "8b2cb6b777e7f2b83beb3d3baf4b67f2",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "645248b076c58297aee73e7f1e3a67fd",
"main.dart.js_265.part.js": "09541a92e19d10275abbf5e6962f177a",
"main.dart.js_261.part.js": "03fdbb9afd0052b6b39d96cd92863cf5",
"main.dart.js_262.part.js": "5e11708e9df1c905c46798b1b9c81482",
"main.dart.js_322.part.js": "ed4d7ecd441f92b17669de340b355772",
"main.dart.js_263.part.js": "3fdc2c0bcffd9ada2eb117fab62b0169",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "2d04fdf1a11d65e5767493fb75f275ba",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "757517afd24ca5b0f6f525ad6f64cdb0",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "a051da37b23b9c029e825bda5313169b",
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
"assets/fonts/MaterialIcons-Regular.otf": "74d774e5a77a4138a1b82ca633ae813a",
"assets/NOTICES": "946df0b38a26047c6a3ed9fc0b54514e",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"main.dart.js_334.part.js": "a588e0f8aa162f939d2ff2841b245c6f",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "2a30c92602a0404319e70c2784f823bb",
"main.dart.js_16.part.js": "6e42979888b24d966c878987f8a444fe",
"main.dart.js_296.part.js": "4f5c3bdb423c92a1d41eb997dbceb71b",
"main.dart.js_278.part.js": "faebe5a9cdd33f01775737a483e50300",
"main.dart.js_232.part.js": "51fa08f94bbb5fe96510b79ef796aefa",
"main.dart.js_333.part.js": "f8aa8f4d2cb847ec863205f50e9d5f02",
"main.dart.js_303.part.js": "3ee84c888bb6182e6ab044489b5318da",
"main.dart.js_287.part.js": "0852ebdbf4890f6ab985887779e5a37e",
"main.dart.js_331.part.js": "52a8462c72446017ac36d7521f06ef83",
"main.dart.js_212.part.js": "381d44700da4a424ed6274b6ffd4ecd8",
"main.dart.js_269.part.js": "80f9cde616d75fd0aad06dc7dcef7ba6",
"main.dart.js_313.part.js": "fa5e27effe0df65ef20556cdcc592307",
"main.dart.js_309.part.js": "ae345530d690aab1e277a7d0d889b81b",
"main.dart.js_312.part.js": "fa95bdb35df1177c8705f403eb4fcc82",
"main.dart.js_298.part.js": "d18c9e9105fb22fad33fb694a2aa023e",
"main.dart.js_273.part.js": "18ac6d4552f98af9d5cd4df2a9190e30",
"main.dart.js_235.part.js": "534869029e876eb1ecdafbbee207325e",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "3f01d31b07f971bb258070993f5ac8fc",
"main.dart.js_332.part.js": "b0b7cb7f86e9b167bf60cb215be0bfd4",
"main.dart.js_288.part.js": "f649f23bedae638173f22e904055b1a5",
"main.dart.js_279.part.js": "7617c9429f512cc3163656149f509d05",
"main.dart.js_253.part.js": "aec7443005f36e163dc1ae01ff187ded",
"main.dart.js_323.part.js": "2c20ed91c95dbed95bbdef9206c04120",
"main.dart.js_324.part.js": "87892ea056a3477b7b86da59be08d0a4",
"main.dart.js_328.part.js": "8d14104a9033b5eea32a7f3621a63899",
"main.dart.js_289.part.js": "12f0d1b128156edbc47146150563faf0",
"flutter_bootstrap.js": "651a2cdad149d98aa4107960097547a7",
"main.dart.js_315.part.js": "1600858e4ab19a1e833ec7e196ce82e5",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "e8ab6a9df97eb18c68d4b548502c0362",
"main.dart.js_326.part.js": "0859d7a2d263c980d8969456b5c9d8df",
"main.dart.js_329.part.js": "778c24111f5be938d9557b2317febdd8",
"main.dart.js": "0a8c1a2f5d5ffc2a5cbab5b01ae6c427"};
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
