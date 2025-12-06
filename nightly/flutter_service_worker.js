'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "d836c7624fcb4a9be9f975846d2afc93",
"main.dart.js_308.part.js": "0f46deea4e03f50dd508abcf7a4fff3b",
"main.dart.js_317.part.js": "5ff86baf81dd02b599964cfdf537bd8b",
"main.dart.js_243.part.js": "5f9e055e5bbffaa38f50a1f96b3b924b",
"main.dart.js_297.part.js": "b23185c3e4147d0fc3dcaf02ef49b9eb",
"main.dart.js_1.part.js": "768551d01b2953ad42f39bee107c2d74",
"main.dart.js_260.part.js": "2c9306ea75e9061a5870dc008a27f289",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "555b742395b9d757a4d3b630764b7765",
"main.dart.js_274.part.js": "96757ae72ce7433d973df76540856343",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "ca779161bcfa5caade5cb12e711d0263",
"main.dart.js_211.part.js": "aa3a0ac3d76d277e2f78f32dd2cbbbd0",
"main.dart.js_234.part.js": "aaf946ba72c8257622a522c5b2a2e4e4",
"main.dart.js_316.part.js": "f244610eab8955f6d6d5f0a93694dfb8",
"index.html": "7b66edbd3f43fb7157633e57b00f8ea2",
"/": "7b66edbd3f43fb7157633e57b00f8ea2",
"main.dart.js_302.part.js": "2c8ede24b9a3a64ef7bb4ab3a0fdf9af",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "df066bcc70111f4101fc596a2a4f66fd",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_283.part.js": "0f27567fd0d2d7f7a048c0837cd9eca9",
"main.dart.js_294.part.js": "4859607e9ac46609e1fc278c5e0cfb46",
"main.dart.js_261.part.js": "55ae82c4f34971918cc230b715ad162b",
"main.dart.js_262.part.js": "34a7d6a0df5c4f24628bdcd3e51da220",
"main.dart.js_322.part.js": "4022d671f59e8ce6f36a83b5561f0637",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c2ab8a9ee2c053a2f115d52e2aedd81c",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d33d34c6913b6d7594765f9dbae171ef",
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
"main.dart.js_334.part.js": "f3288e2f19041ff6babc45d15a5de012",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "ab73e8f04c767f70f3d83ce17d414664",
"main.dart.js_286.part.js": "929fed955396e56a9110fb8c59f9c970",
"main.dart.js_333.part.js": "6f5bbdf9cdaac82ee108cf9c62d65631",
"main.dart.js_287.part.js": "81f949472415b3902b1ec87c91f24b51",
"main.dart.js_331.part.js": "b40537de4d8a507c59d244a5e99b3316",
"main.dart.js_252.part.js": "78e0793de8fb3b0409ff70b543c8d9f3",
"main.dart.js_213.part.js": "423c300c2ee5db5e41931bcd6b978cec",
"main.dart.js_249.part.js": "4012b93273627e59ada9aaa7da0c7b0f",
"main.dart.js_309.part.js": "538fb48c194e5a6aac0681216e19148b",
"main.dart.js_312.part.js": "bf21a5725bf9f15a781ee2457a379f9e",
"main.dart.js_325.part.js": "68b0ecbcbe9788c2dc2d5e23ac7bd168",
"main.dart.js_270.part.js": "70253f5508bf8ddb733e54f16789de83",
"main.dart.js_321.part.js": "78d34e060bcab6dcfcbf9928011519bb",
"main.dart.js_268.part.js": "f8a4b28f559a336acd9b724c56a7aa8d",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "77b2b22cea7be57ac4865a3ef6f7549d",
"main.dart.js_288.part.js": "74971a71fd27c56144b0d90207160d05",
"main.dart.js_314.part.js": "4dc7715911de44412c0d3f295833b302",
"main.dart.js_307.part.js": "7d0da17c548ac07395d10d70793683a3",
"main.dart.js_323.part.js": "62881bc319678b722a0314700d8a5c3c",
"main.dart.js_328.part.js": "1cd2d6d43863c355325bc8eea9153798",
"main.dart.js_231.part.js": "989af6de1323cae3159f05b66b95105c",
"main.dart.js_219.part.js": "f29b59265614f860f5e753773c9db72b",
"flutter_bootstrap.js": "8315ebf61c0ab22adce85d29646d6311",
"main.dart.js_315.part.js": "b9ce69d801fdbb8640d9fba1d4ed019e",
"main.dart.js_304.part.js": "2e9bd696b0895eb7c5d592e0d4c59475",
"main.dart.js_264.part.js": "7bdfcebc92d49f5ed0fa457f98380c0f",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "50505234463941b4499f1e14cf55c2f7",
"main.dart.js_326.part.js": "c491359d58c18d0479e096399b74379d",
"main.dart.js_329.part.js": "df4316b77e8ae9524e5b56e0119c3153",
"main.dart.js": "fceb567c86c9d6d6ed2a55f9bdce0030",
"main.dart.js_272.part.js": "7cc9528c09a44ea1983e8d806f1666ea",
"main.dart.js_17.part.js": "860a5402507e79e2dec248b3069098d4",
"main.dart.js_277.part.js": "476d46ff908478645e1127547dba75ef"};
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
