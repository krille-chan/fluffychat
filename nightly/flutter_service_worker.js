'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "ebcf396a73ffa5be75608ad5f37c7766",
"main.dart.js_308.part.js": "eba0be4680500ecccde0afc795e5f460",
"main.dart.js_271.part.js": "52b3e135106abca5ab808e3375d3ccfa",
"main.dart.js_317.part.js": "ea00365adce4d9c52da495c258448e9d",
"main.dart.js_297.part.js": "58cea859a45ca86da03d6ee0472a2b43",
"main.dart.js_1.part.js": "f5294b558ceee3fba2f8fba55f996e45",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "ec6e3fca2e482d51e9d819a3142579eb",
"main.dart.js_311.part.js": "7178395c76e57a0a7228191c09947611",
"main.dart.js_220.part.js": "c9bd03a5f9314f59cd2ba2358b27abf5",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_214.part.js": "c199fabf2923700d133bc5f86728ab03",
"main.dart.js_295.part.js": "2dc9e7ca04d1d0811408fe856bc016f0",
"main.dart.js_316.part.js": "245cf384084529b798b24121f252428b",
"index.html": "5596a223ef68afae26861e29d1a6dc66",
"/": "5596a223ef68afae26861e29d1a6dc66",
"main.dart.js_302.part.js": "956432fd2e12d0e7cac34b9737ecf7f3",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "d0875fbb29040d4addc35da7f2c32a68",
"main.dart.js_244.part.js": "9ffec51953925c3ed16281eb6017f7e5",
"main.dart.js_2.part.js": "bab9e2c10a7922b260520c90fa85df9f",
"main.dart.js_283.part.js": "21af54ca78d5fcec06817c4eb339f097",
"main.dart.js_294.part.js": "8899caee76dcdf2ed88f63eb966e0598",
"main.dart.js_265.part.js": "fda0deae2576861905e4667953cfe402",
"main.dart.js_261.part.js": "aa12f7954409efa589746925677e93be",
"main.dart.js_262.part.js": "40753482ec6e3aa094a25213ca9f9b90",
"main.dart.js_322.part.js": "49eaece0c87422a89eb9a9ceee9779d8",
"main.dart.js_263.part.js": "2d20518aeda030a6108adce1cfb7ad2a",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "2e5808bdd60e9554299897117557f742",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c8961c4e0435186f6a7064c35b698795",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "c137c821c6a2ab637f83bfaaf8b23433",
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
"assets/NOTICES": "4d4d997f25d9bd3d4ec2a0c14ffc01fb",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_16.part.js": "f42039862e50700d7ebfaa66b4ccd3e7",
"main.dart.js_278.part.js": "fe7030cf64939e45e36ebe8dfd108383",
"main.dart.js_286.part.js": "965b326ae1fa13bfae9d343e55d87572",
"main.dart.js_232.part.js": "bc6f445ae1974d22be7ca9ea07ad9357",
"main.dart.js_333.part.js": "aa842fb2d49938948e59f7010d0abdf0",
"main.dart.js_287.part.js": "73b165e01c34c162c6e087de792f00c6",
"main.dart.js_331.part.js": "e2ee7c42834f932d2b5b231d2effcfd5",
"main.dart.js_212.part.js": "7e34b90dccd720fe1d556e53e915c057",
"main.dart.js_269.part.js": "f1fa30a02dcb3b57b9acdfc4816170b4",
"main.dart.js_309.part.js": "75c3095c2001dce1997eba28a0fb79a3",
"main.dart.js_312.part.js": "b32e3ef13b7b915792b6cd1008ef2fe6",
"main.dart.js_325.part.js": "359f16d010a1ec1967902826d0babf79",
"main.dart.js_321.part.js": "19f146262635d956691339d77c1f4702",
"main.dart.js_273.part.js": "110a8a2ec7c584d49ddee9be2700cee8",
"main.dart.js_235.part.js": "674872059b4419870eed8793c7030d24",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "7404229b6905d817cbe1d580afbcf26a",
"main.dart.js_332.part.js": "b58ad9965a4cecd693d112ca9fac5277",
"main.dart.js_288.part.js": "7c5de63d7de6c0ed28dc43151294d461",
"main.dart.js_314.part.js": "5609f426bb153d28fd75d91fdc6b80d1",
"main.dart.js_307.part.js": "14341cd18be48ad86ec631ad99d2fef0",
"main.dart.js_253.part.js": "39bb20d6657998c981a81981fda0dba1",
"main.dart.js_323.part.js": "78e4a8d1daf31d8a51f957bfd4f3cdcf",
"main.dart.js_328.part.js": "886c9500c4fb6660836351d6f5896275",
"flutter_bootstrap.js": "7b4e0f575cb37ce7d1270c46b74fe33a",
"main.dart.js_315.part.js": "d5ed41dca2e06565fb808c61c21a1e7b",
"main.dart.js_304.part.js": "35d63dea71923655856b9aa4adbdc3c2",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_310.part.js": "d4c9a85931e730a3b2bd6379b9c30146",
"main.dart.js_326.part.js": "89076ce90ad23d0503b564932f9e3adc",
"main.dart.js_329.part.js": "bd0ab9d91ef07e5c0a91028512ce365e",
"main.dart.js": "bf8dedb2c9afbf500516c24994d53b7f",
"main.dart.js_277.part.js": "b3b7968f8249b889b5b0b22a36fa275f"};
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
