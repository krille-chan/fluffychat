'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_313.part.js": "f74def11806e89adc8bbd1200c5575b7",
"main.dart.js_234.part.js": "8274725aab74d858d3ea1df7eb59f089",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_331.part.js": "c262fe04ccd7f61fccbf5adf7e0db4cb",
"main.dart.js_1.part.js": "6fe7e7fb8d4600179d6ba27f28cb1779",
"main.dart.js_284.part.js": "ecfa6529b2299d8ebe7172298380cc14",
"main.dart.js_216.part.js": "db990f6d90117b12bb378b972eaaa284",
"main.dart.js_296.part.js": "dee695847cb11476bf19123262e87b25",
"main.dart.js_305.part.js": "a268ccdd76d02b8eaa4f55d447f1eadd",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "6d6a4c00ac1c86e92751d138552a2c1d",
"main.dart.js_277.part.js": "df4b108a0342e3b5fa4611bdf87df5aa",
"main.dart.js_265.part.js": "cf6c04317f9f6261a2d557d508b9335d",
"main.dart.js_315.part.js": "68ee8b012083e4cca69fa0ce5d91ef75",
"main.dart.js_323.part.js": "bb875546eb2b3e7e7c64acd95a4b1c40",
"main.dart.js_295.part.js": "527e24b5415058faec639e99535234d5",
"main.dart.js_278.part.js": "99434d1bdb10744da8e37720bbbc9ada",
"main.dart.js_312.part.js": "890d7efc74255085a55a8a355df754e6",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_332.part.js": "7c34d392519a546f7ed8e5c6a3f46f03",
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
"main.dart.js_298.part.js": "f5eeb0563f8114b091249fd812376088",
"main.dart.js": "4edbc2ecaa237c96123aa6350fb1d7a7",
"main.dart.js_275.part.js": "82383688d07af42e83821e61f1afe000",
"main.dart.js_326.part.js": "be3a4d27bb0deb71cf8392b40446b9b3",
"main.dart.js_279.part.js": "a1dada9982fafff1ea486baee9b1388e",
"main.dart.js_324.part.js": "69bd0043b902745901ba7270d939a64e",
"index.html": "2c763919f6429e9ce8cd0580205ddecd",
"/": "2c763919f6429e9ce8cd0580205ddecd",
"main.dart.js_318.part.js": "c39519e3cf6b49a8c0049a1b8b054a85",
"main.dart.js_222.part.js": "6bf2999b791dd8ac026ee4b8da784adf",
"main.dart.js_2.part.js": "991abc4d4f8eae52d576ce00a96b3a1e",
"main.dart.js_309.part.js": "75eb2266af2042a14cadc237c171fd2d",
"main.dart.js_273.part.js": "e331936f608ab5f3864a1e37d506df23",
"main.dart.js_264.part.js": "2d12801499c47cbdd1bfade3b2f606c4",
"main.dart.js_267.part.js": "f80808b61ad7eccfa2ce951dc5bf7a68",
"main.dart.js_288.part.js": "a7cd18bd2400f124328940a68a911b36",
"flutter_bootstrap.js": "0d8cc8bab5a126e89aeee493169fc790",
"main.dart.js_322.part.js": "bbb5306d0fc07defcc45e4585b7c3647",
"main.dart.js_308.part.js": "307c8c92639afa588fa7fc84caeb5b5a",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_329.part.js": "7fb7a06dce8c47c43df5f7fc2cf726d1",
"main.dart.js_255.part.js": "38b1d2825827570c611f392e563dd9d2",
"main.dart.js_289.part.js": "524af7919370a0852504b4ee9368ca64",
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
"main.dart.js_283.part.js": "166404bb452b6d6fa962c28fab697855",
"main.dart.js_303.part.js": "d5e0f63e185c9e729b1daf57b7c5d78f",
"main.dart.js_263.part.js": "acae1207e01effa1f05834e34ec8e85e",
"main.dart.js_330.part.js": "506f1b0e81a0f82a6a47be168a9f3ce1",
"main.dart.js_317.part.js": "12423fe45037e92702da9dbc8d2bf894",
"main.dart.js_316.part.js": "f96633ab3cda91473e0d06e722a5f6ed",
"main.dart.js_271.part.js": "6d2eb25167ce6e29350d52a1dc30200c",
"main.dart.js_327.part.js": "fe0c8544da1c081ecf98e90f9c97583a",
"main.dart.js_328.part.js": "75971e063fbfab632b4aa8735f2a7be6",
"main.dart.js_311.part.js": "35748d7cb43d9bbe3204e1a0cdce33dc",
"main.dart.js_246.part.js": "36339ca5b22d6f0f2e31c01edcb56786",
"main.dart.js_310.part.js": "5bc471f5364975961193630a6923019c",
"main.dart.js_252.part.js": "f7388f846c56bb51ac5374df1164a7d3",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_333.part.js": "3dda873c5dd7ce56bd27080987236572",
"main.dart.js_237.part.js": "1a30bd46978affbc189f669d34786500",
"main.dart.js_214.part.js": "53849372ef0d19a4301aa76271f48083",
"main.dart.js_287.part.js": "d7e0d3cc29c0a623bc33c1a648f31c4e"};
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
