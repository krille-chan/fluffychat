'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "d82e5c7c20e4aec3faaee8f896c5178d",
"main.dart.js_259.part.js": "c199087500d23c2975399a330650381e",
"main.dart.js_1.part.js": "d16c173a71f4a6b066e434c4fd93b785",
"main.dart.js_260.part.js": "70b6b539cc4bb96e2ab98bcdfa91a84a",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_250.part.js": "56324962c6e04791dbb3a3f8f9327e30",
"main.dart.js_280.part.js": "7b5e199b8cb4198d737cddca6593fea7",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "53e25fd720cdbb50c577a024a00c456b",
"main.dart.js_211.part.js": "1c2abb1d1b4727d64fbab35cf2abedb0",
"main.dart.js_266.part.js": "a5355b4130ce224f242ef5be52acf3d3",
"index.html": "2d341310172c734d26da2d5a6681692b",
"/": "2d341310172c734d26da2d5a6681692b",
"main.dart.js_302.part.js": "f2560348e36b536c29dfff0ea017acf8",
"main.dart.js_217.part.js": "1ea23fe260932d47cf0a00cf1ac2c25b",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_241.part.js": "d9647b2de724a305b1aeb26a51d14c0c",
"main.dart.js_327.part.js": "ae4fc0eed67d0d7805024425904702e4",
"main.dart.js_305.part.js": "cab8ad7a08380649696cda34cee80a3e",
"main.dart.js_258.part.js": "dd1292711cb33a47e68db73685742584",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_300.part.js": "f356ee97918a8fed04e560fc8d6306eb",
"main.dart.js_262.part.js": "b8da9e201d54248ae6c14b0d087b16c2",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "f92f7741744befccbbc972504ecdb3ef",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "854a71346e238bf01075f906d52562e3",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "f7f502e248ccb4ad036409e81dc3f8d3",
"main.dart.js_247.part.js": "9a23cac8d0196450125842b9cf5c26a4",
"main.dart.js_292.part.js": "4afa8cc99320b683fbe81e8505be4d0c",
"main.dart.js_284.part.js": "438455dabb44513d1734295ad844b8c3",
"main.dart.js_209.part.js": "231c2fbe2266419e8d0965dc906bc032",
"main.dart.js_229.part.js": "085d80b24e375ac02182b751b9589a33",
"main.dart.js_286.part.js": "53df8dc0bb105f9156ea0fb77a8fb98d",
"main.dart.js_232.part.js": "a293ffd8fc7a4562ed28c7f68d32fb36",
"main.dart.js_331.part.js": "3756d8abb21e81513d6cf956f52fc815",
"main.dart.js_313.part.js": "46f91c7499541487d195d270a5bc3240",
"main.dart.js_309.part.js": "3ba3268ffbc56433943713058479008d",
"main.dart.js_312.part.js": "6f9f03561e193654139ca45c1fc15532",
"main.dart.js_325.part.js": "888718474638f54b35a8e6f83970d670",
"main.dart.js_285.part.js": "c831b78f30419c3e6b324cca39a3ba1a",
"main.dart.js_270.part.js": "5d55b34a8efc20e9abe1c0f439d978a7",
"main.dart.js_321.part.js": "bb676ec6209427ba20d26f1687490598",
"main.dart.js_268.part.js": "cab8929aae29fbae83f58d4cce9e954c",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "cbf6ea3591e68cbc091db8ae0eb191d0",
"main.dart.js_281.part.js": "9e5790968ef6315f31413db975a5d5da",
"main.dart.js_332.part.js": "fe7d35f76f9fec25d5e27cee2f4afa43",
"main.dart.js_314.part.js": "3445f74bcb42e3e9871ba7f5afbf0c91",
"main.dart.js_307.part.js": "3d45dddb54f62df3649b1abcf65e5855",
"main.dart.js_319.part.js": "dd2d4e02d37abd333b7d2e788ae5b8a5",
"main.dart.js_323.part.js": "dab3b7d6a2c256a590c74d59fb9fd24e",
"main.dart.js_324.part.js": "dc1ba3e26c9973d58df5e2c86a93597c",
"flutter_bootstrap.js": "99d6243a231f78b073da85b8f907a98c",
"main.dart.js_315.part.js": "1a086b263c614b9607df6fa23912dd32",
"main.dart.js_306.part.js": "df94545a8d2bbfa476570fb59ca90d35",
"main.dart.js_276.part.js": "d1e95ccc7987548ea01a34bbc1d7a2a1",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "3f363d392ae463666ee52b4e73d4b47d",
"main.dart.js_310.part.js": "89779c0741463c9a52974c4d576b5efd",
"main.dart.js_326.part.js": "e0251d306df131676110f592d8dea0c4",
"main.dart.js_329.part.js": "bb424005f9152215a27460bfac57d268",
"main.dart.js": "a27fc074df06ac9e4e1680641cc5c29b",
"main.dart.js_272.part.js": "e70fe539c296659fc71dc13fd75ba7e8",
"main.dart.js_17.part.js": "d76f71a89748ab93a1980c88f74d6d6f"};
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
