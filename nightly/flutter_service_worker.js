'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "4b07dcbd200f2006933e155084ff2e1d",
"main.dart.js_312.part.js": "6545c2f1b10768c1f1cf4dc80ae100e4",
"main.dart.js_268.part.js": "b14007f3690255189a3e8563bcdf95a9",
"main.dart.js_273.part.js": "486fdb9b8732d8fbc842345e59c3b6e8",
"main.dart.js_293.part.js": "b39608fe327f2fa1431dce0f123f7bb7",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "5dcadfc3b7c72bb33676e5eea9ce732c",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d92e51df31903f5057bf42069a909609",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "66eb34213f4c7ff0fc007d76c982b311",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_295.part.js": "9e15b70bc88ef9a93f3f07e222d6a962",
"main.dart.js_245.part.js": "5844724b7052f9cb849f86cd76264963",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "534e2be5ea6bd6c68b882f9835eefbe2",
"main.dart.js_302.part.js": "ebd02eedaa2f078ba405575e23321fbc",
"main.dart.js_320.part.js": "118e64d8a04ecac2a984c7505deba454",
"main.dart.js_321.part.js": "6233663ae701924ba009a70de9785477",
"main.dart.js_255.part.js": "3e70243a10b2f4d805232856c87d33eb",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "ac55e8c935cff59ae4dd9026653bf1a0",
"main.dart.js_228.part.js": "9abfcf1ca44a6407f3dc0c3d26fe31cf",
"main.dart.js_298.part.js": "2b742ce27631a6487bd497f05f556120",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "37f9547413b28139c73720d35a0f5d0a",
"main.dart.js_277.part.js": "88ee89fcb62d1c0445f40867662f2e0b",
"main.dart.js_227.part.js": "d76476f6db017d562b4bbc4e6208a34b",
"main.dart.js_254.part.js": "cf86a2b0efdb9b862093d822be6cbed9",
"main.dart.js_279.part.js": "bba648b29f9f38fbc5aa26f3feda37a1",
"main.dart.js_305.part.js": "3f8d2f5e0701903a27956ce08079f924",
"flutter_bootstrap.js": "8bedb0cfc1bcbf2855fbb1f175446557",
"main.dart.js_267.part.js": "2fa274f60c52c7e858afdca73aa6ffc5",
"main.dart.js_319.part.js": "b7f04beeb12c8e7498d54e0a195b82af",
"main.dart.js_213.part.js": "e7216fe8f876c08b43bc89acb0eb00a0",
"main.dart.js_236.part.js": "74143a0cc6e6845def36b6b3375a2bb4",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_210.part.js": "8fa7e30b0971c6932d7cabc9e04e3d0e",
"main.dart.js_323.part.js": "44419c230a9faaae5e513a42b73029b5",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "67c7d4a9ff41181ee9b49b77b6ac3a13",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "32f7f8305581b7c62d7b3f362ee3dd24",
"/": "32f7f8305581b7c62d7b3f362ee3dd24",
"main.dart.js_299.part.js": "5f87201b1931066b611bd6082bc597d7",
"main.dart.js_242.part.js": "aef63a77c61cf5191113746555ca56cd",
"main.dart.js_301.part.js": "7588a0ba18b6b4632f782b5595a2b84a",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "4d0af74c5f614813a2bb18afdaf31e89",
"main.dart.js_317.part.js": "bda33fb42c403ca69b853c438450ac1d",
"main.dart.js_286.part.js": "8cb009e4e4737f2836551a091a80f11c",
"main.dart.js_307.part.js": "ff4d1243a4bcd646e8d3cb448fac4a58",
"main.dart.js_269.part.js": "3eca6c77a9b70b9b8f98b48a209fb7f2",
"main.dart.js_263.part.js": "ae24d632fbe3858640c4a5eae5cc8994",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "7c81c9b4923435eb9ffafd24df49680a",
"main.dart.js_226.part.js": "1aecb5a1d9611f120a0bec37f692a945",
"main.dart.js_261.part.js": "83a9aa504f3bb05519b27063ed1d59a6",
"main.dart.js_303.part.js": "d1eacec86a66300d707b745c9f6a52db",
"main.dart.js_1.part.js": "d799904645f310800174c93db034b3cf",
"main.dart.js_285.part.js": "e98c9dab039036456abca6efb1a89944",
"main.dart.js_313.part.js": "1a3e1276fc15337189a2a54783b78a43",
"main.dart.js_318.part.js": "9d054a338aa410d457b0a721f62463e1",
"main.dart.js_265.part.js": "4bcf7aef6f9b76575317996fc1e0477f",
"main.dart.js_314.part.js": "87d2e68a6608c5d9799a343afc2daf78",
"main.dart.js_274.part.js": "096552d268224445f8cd5c8b0bac2e82",
"main.dart.js_316.part.js": "d998865bd3eb02e7f079b38acae40652",
"main.dart.js_278.part.js": "6da00ffc833ffdcb183ada6be5ac4b22",
"main.dart.js": "97dbf6c189c1aa90078c7b8fdd3c6534",
"main.dart.js_257.part.js": "b5de95dc054c6f68e42218137fee7f5b"};
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
