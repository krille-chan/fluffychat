'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "0b2185b4e768921cca2a9fa38c84930e",
"main.dart.js_234.part.js": "9db5886e90d02ef569eefe220a31a754",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "602876b1ffb0d7895136d8461ee0d5c6",
"main.dart.js_1.part.js": "f790f53b23e7938abf5ac586ef162b98",
"main.dart.js_284.part.js": "6c6bda3f1b61be0410d44e9ae3d9a2fb",
"main.dart.js_216.part.js": "23a4c241a9dd23b129759d80495dd6c9",
"main.dart.js_296.part.js": "f543c93e7e9961d20302162c42865107",
"main.dart.js_305.part.js": "8ac19bc317876d42c48b18d68205d142",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "15f9912d626b68baf17269c0f3ebc852",
"main.dart.js_277.part.js": "a790fcbe445b4254c244a4ca0b4c373a",
"main.dart.js_265.part.js": "0d24ffd77c64936ebaf0844ee27d4b3a",
"main.dart.js_315.part.js": "283d06204bcb847be297151cf341cd82",
"main.dart.js_323.part.js": "2e6fdced3d8efac3934f1e47e79d813d",
"main.dart.js_295.part.js": "6d67a1eaeeaf567f37e7af3f9e60621a",
"main.dart.js_278.part.js": "1b7c3496468b5d3ecb4b23dfa700a7d4",
"main.dart.js_312.part.js": "cac5332257f103deffaddbd157657427",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_332.part.js": "c44f2a3bf9aa4492c8326c474afa8eec",
"assets/fonts/MaterialIcons-Regular.otf": "d3d7d597f725542b28e10dc1b81f1bf6",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "32264d576c001f8ea24a9a8a8caa4ec2",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "48ced315403b507753c6974c8fb41595",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/NOTICES": "ccc7b438b6733657324389d49423afca",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"main.dart.js_298.part.js": "d02a278ff4352aabbd461f62d2a617bd",
"main.dart.js": "36e0f96df08868909371efada9eedac2",
"main.dart.js_275.part.js": "e6a4cb39f4de483ec7cda0b5e8188641",
"main.dart.js_326.part.js": "a87d81afe41a161532637ab39ce24412",
"main.dart.js_279.part.js": "a2ce028aad7db6e66ef885486c594a01",
"main.dart.js_324.part.js": "55924499b6f38339310f9aa7f4a316f2",
"index.html": "0c29c877890382ba2fcda8440ef2d277",
"/": "0c29c877890382ba2fcda8440ef2d277",
"main.dart.js_318.part.js": "eb795efbd6492480e999000f1cd31f3d",
"main.dart.js_222.part.js": "1a6c1111a4d1fd440af17d7005e20bbb",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "089ce0a4157b11b439eb7e0edce1c6a3",
"main.dart.js_273.part.js": "e4ba4be30ee49d27493369df9ce39af3",
"main.dart.js_264.part.js": "6965d4e2581c7b84b2f1d3a40f2c70ee",
"main.dart.js_267.part.js": "ce0d1d3022b4d2f4c32945483b00c41c",
"main.dart.js_288.part.js": "742bf154df2b54c9dc5c5e465559fa90",
"flutter_bootstrap.js": "712e6d8c941399967a3b2433d2da9391",
"main.dart.js_322.part.js": "ae9bd7a81693d76811b42d40cf50681f",
"main.dart.js_308.part.js": "a63d74611a485377104ca802038d064f",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "daa7e7d9ffefad6a85c68c77ec381d8e",
"main.dart.js_255.part.js": "3c42142e11e3c9f27dde54b6025bec15",
"main.dart.js_289.part.js": "8b2a38ff9566ad6426aec2daa4f94841",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_283.part.js": "483b71d8a5246de7ee58ffc449a36552",
"main.dart.js_303.part.js": "0bd97868103b89bfb8147fdf1a7d6a09",
"main.dart.js_263.part.js": "401c1acc86fc0255a8b6c6fe83ca7662",
"main.dart.js_330.part.js": "fb5fcb1490b16b5f0ec6e2758bf3ac99",
"main.dart.js_317.part.js": "6d62ca1e95df03513eb2c684a2e2e533",
"main.dart.js_316.part.js": "8e191d73862eea2a926ac73bd1a33058",
"main.dart.js_271.part.js": "885de2ed81547835473522f5e0df200a",
"main.dart.js_327.part.js": "b372ce44f3899620aa86503564501750",
"main.dart.js_328.part.js": "a5d8f17e4f7f4fe90127fcc125ab9d3e",
"main.dart.js_311.part.js": "7195d335cc646c6932bdeb7221b23c90",
"main.dart.js_246.part.js": "0d33c042a7453fadb0941b6e486c1872",
"main.dart.js_310.part.js": "aab3b178942ea53b6de7b260fc135df8",
"main.dart.js_252.part.js": "63c94280c247003aa637d677d808a21b",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_333.part.js": "e23d71e630e2fe94977ab52a7ab06844",
"main.dart.js_237.part.js": "d0801a319a826b54f57d0de1a704a1e9",
"main.dart.js_214.part.js": "b11407adb2c5c771a3b736732bf5e4c7",
"main.dart.js_287.part.js": "15a13622e8f8a9ca28f64571f972d1a9"};
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
