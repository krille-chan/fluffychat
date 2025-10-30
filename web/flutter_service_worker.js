'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "0007bb96737f61200ad0951853db04c9",
"main.dart.js_317.part.js": "2b333156c5b1b9964ef01cb2f71d5200",
"main.dart.js_1.part.js": "cb45070d23689ff450b6cea2e3d6636a",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "5cbd4d2c0bc9032ec0d0157464700e92",
"main.dart.js_274.part.js": "3f04a1dff1f4825222e41bce1a45f7be",
"main.dart.js_318.part.js": "bd45fcb2dcf378c2a9cfc43673d3ce47",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "fd6d82019ddeb52cf58d9d0e4210a15c",
"main.dart.js_316.part.js": "fc9e476eb8ee1990f43f18260f766818",
"index.html": "ade60d56fe8ae8287e6d7847e67a46b8",
"/": "ade60d56fe8ae8287e6d7847e67a46b8",
"main.dart.js_302.part.js": "db275d6b05d980fef2e176d167f16f82",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "7967781a2b4974da4d04e1a20e2f2df2",
"main.dart.js_242.part.js": "6c863e66185d2e0b169ba90eb1fdaeec",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_265.part.js": "2206da7211960dc447bf5549b4684de6",
"main.dart.js_300.part.js": "1afdfe130f01c3a97ce2f693d329ca09",
"main.dart.js_261.part.js": "f29f6a01db1d463a81f41b3611aaf85a",
"main.dart.js_299.part.js": "9d247fc7af00be345479630e2f382d1a",
"main.dart.js_322.part.js": "70254f5cc06b8c16c959aab20d55dc49",
"main.dart.js_263.part.js": "67f2b1bf293ecad024a5a4126c06be70",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "8291c1b68252d3e9efbc5cdb3cd8019b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9e01fb88a4ec95af5f893da3aacfc66a",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e0dbb1a1bd89729e725c0f89b945d942",
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
"assets/fonts/MaterialIcons-Regular.otf": "ba6850df3f567a02f3e4138adbb19518",
"assets/NOTICES": "495155e4ec600fd53a6a111344ecb69b",
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
"main.dart.js_320.part.js": "edda0f714b88ec0e39ca14388f26657a",
"main.dart.js_254.part.js": "0d1854771baa0b5ca9f7bde61a6dd6b9",
"main.dart.js_16.part.js": "46ec26a3b5ac14a738a0036c8650869c",
"main.dart.js_278.part.js": "0e3b5573b8c4d601b15a97d727aa24e3",
"main.dart.js_286.part.js": "a7fd4a0025c62540954b97e8e528b882",
"main.dart.js_303.part.js": "b76dd8213d14773545364c5f8630f5bf",
"main.dart.js_257.part.js": "f1339f1b213281a8a42f50a0457bcc6e",
"main.dart.js_212.part.js": "5a6ab2dadc08c0fe1e92ee2642d10e52",
"main.dart.js_269.part.js": "12ed65e7d244a9794e3275607a279519",
"main.dart.js_267.part.js": "5e97e3c550a90ef3a99c2f1793fb3fc2",
"main.dart.js_313.part.js": "c2de7443a2176d6105f9956affeecb55",
"main.dart.js_312.part.js": "7a0419f39c53287e2b6a020d686f75b2",
"main.dart.js_298.part.js": "d9e446f80607f6183185b8a38601b3a9",
"main.dart.js_285.part.js": "5a73331d9e6973899452bd4fc0fec317",
"main.dart.js_321.part.js": "5519b9cb2e6c2e69d5bdbe741382ee48",
"main.dart.js_273.part.js": "6f25f0a03aad2b7fd049d348da9125e0",
"main.dart.js_255.part.js": "7600c7515a2bdd7f1d213d1002c08238",
"main.dart.js_268.part.js": "f34c16f4bd5e9882aaea5aab8975b4ab",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "c2aadd7d790a258ac872d7ecd98a0443",
"main.dart.js_314.part.js": "9066cb77b28a0a5ea1652f7c27e4aafe",
"main.dart.js_206.part.js": "d4fb3d335b6cc7815875701c6300d3ce",
"main.dart.js_307.part.js": "9087ef3c3fab27baa9146b30aeca1512",
"main.dart.js_279.part.js": "c1a219e58e7470cc95d6dc1eeceb47c8",
"main.dart.js_319.part.js": "3142eed92d8c96ad8d9edbbb6d3ab83d",
"main.dart.js_253.part.js": "125d258514274a5352da71555cc9aa07",
"main.dart.js_323.part.js": "8b2f115bd5c462eaac9a9f8d6e665a34",
"main.dart.js_227.part.js": "fcffc61983652ac03742cf221b0883d9",
"flutter_bootstrap.js": "8cf0986ef903a91bcc25676929a71c5e",
"main.dart.js_306.part.js": "0b0bc865cd463bbe01cb5fdc6401c8b6",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_293.part.js": "d568d3b867c3a57d0db837b39d4ace9b",
"main.dart.js": "b236dc6cdbf768defaf5564f39d4d0da",
"main.dart.js_224.part.js": "5933b70fbb13784333de68fa5e866f8c",
"main.dart.js_204.part.js": "6c0d348152c2f39e0020813d538c0b69",
"main.dart.js_236.part.js": "6f4b4de2da73befe21b305cf28dae114",
"main.dart.js_277.part.js": "8969560958af7aa02a6c5791becec90a"};
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
