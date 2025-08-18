'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_318.part.js": "1d250c9fffc8b4c53bd5df3a178daf17",
"main.dart.js_303.part.js": "fba505d2a3c7c078a8ac11e0b68778f0",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_289.part.js": "e52d08d096ae7c6181b2bf8434e8ff42",
"main.dart.js_320.part.js": "5cea9d281077685c837e0b5c9f19e342",
"main.dart.js_246.part.js": "79710043b7a50b74d8552899c0799096",
"flutter_bootstrap.js": "9869366217634127154ff696a6023b3d",
"main.dart.js_211.part.js": "0b4f7a270fcb020943b1acf765783aad",
"main.dart.js_274.part.js": "936a4c9ce3864a2459c97b6ac310791c",
"main.dart.js_275.part.js": "f6ae2baef136a72df3b8457bd4144677",
"main.dart.js_254.part.js": "4dd051ba7a139121643ab5093040d7c8",
"main.dart.js_269.part.js": "12773e20590c3a2b91d5064ac6d3a4b7",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_16.part.js": "645339b2a9d1adf5edb7093c885978c7",
"main.dart.js_315.part.js": "cd62f70c46eb9c9033797ba06d488544",
"main.dart.js_301.part.js": "45ef9827214010bc817acbe0ec2ed5bc",
"main.dart.js_299.part.js": "d90f38579497fbbec56f28937c5fbc55",
"main.dart.js_237.part.js": "304f658d9e9c98b9d0ccc5d561b13dfc",
"main.dart.js_306.part.js": "924a9159c6eabc52c95da6ad8a709413",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_229.part.js": "65360a73394c41159a7234bbbd9f421f",
"main.dart.js_214.part.js": "6cc8bd83691a739da3347c282f1bb89a",
"main.dart.js_302.part.js": "946e796fd82fcf4df6b5407fb0bf2e7d",
"main.dart.js_321.part.js": "7659efc2a0a8c7193b0741d27359cae9",
"main.dart.js_307.part.js": "e8950a0c7ab4631c131e95e75fbdc142",
"main.dart.js_314.part.js": "58e94f1f1ba0baaae1fcd6a760cc6fbf",
"main.dart.js_243.part.js": "cdff30279f074bdef43f470da1db6d4c",
"main.dart.js_2.part.js": "611010805dcb56081c8408ef9b74dbd0",
"version.json": "c39aee0353c6ad9b93e18f82170c8248",
"main.dart.js_258.part.js": "c2cebfaba8d369b3d4e0aa00e528b053",
"main.dart.js_256.part.js": "ac9eeedbe8105b5c63f6e3ce9c19677c",
"main.dart.js_270.part.js": "86f91dc7e2e1867fc44d7bb9c1911f7a",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_313.part.js": "d1ac4cc296b69fdccf6f2a4776cbfdcf",
"main.dart.js_268.part.js": "563f0d86ec27d2e2012d398be8e4b870",
"main.dart.js_308.part.js": "34a9cca1b9762e30c97c6ed40bf2fda0",
"main.dart.js_278.part.js": "de792063504c3cf2b1d917af7efdde6c",
"main.dart.js_266.part.js": "52a5646f31e7bc3bf841c873424a07f6",
"main.dart.js_1.part.js": "1aee8dc9da044c313921851eede3a27e",
"main.dart.js_296.part.js": "a8fa927e5a3dbaa5236132bfe764d25f",
"main.dart.js_323.part.js": "703b1b4fd492ab26ceb31753417508a3",
"main.dart.js_279.part.js": "9a6bc2048cfd1491aeb2fdcb1b268951",
"main.dart.js_226.part.js": "f11066c3dbd9213ed1d8c8d041512a10",
"main.dart.js_255.part.js": "fa819c7f2fc73135cbe22469edc528c8",
"main.dart.js": "adb4e3bdc766ce38fdb053dba8a6d413",
"main.dart.js_304.part.js": "234d93073ccfc6b30ad9f79c18ad407c",
"main.dart.js_286.part.js": "215aa3b0588b4953ce6220c04eabb5eb",
"main.dart.js_322.part.js": "d1cd97bf00776989322813f4c9f89956",
"main.dart.js_287.part.js": "4275d0ee5a7fd160fe3f7a574b6998a8",
"main.dart.js_294.part.js": "ea23b61e1eca34e858a8b92e6e082348",
"main.dart.js_262.part.js": "7bfb6a32d9bd4b40176c0ef52aad658b",
"main.dart.js_309.part.js": "d28d9a363f9c90bfe3e3480414a82132",
"main.dart.js_280.part.js": "6088811c8e6f7d35b48d0feabca1310a",
"main.dart.js_300.part.js": "a62a8e0b0b554cf7b6a75ae06e60028f",
"main.dart.js_222.part.js": "846ff8b43872d6858a1ff70d785731ad",
"main.dart.js_324.part.js": "84b6ffe295cb32f01a650247542c733b",
"index.html": "fb655f386febd543b26d8299db0ea22c",
"/": "fb655f386febd543b26d8299db0ea22c",
"main.dart.js_264.part.js": "0c0ce822d5b7f5818b0d9148cd91a79b",
"main.dart.js_319.part.js": "850f5125049e789f9e3558b252914d6b",
"main.dart.js_317.part.js": "716eb81fa741020f34e24d1ac093f405",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "9091b0748a4463eef59c8e796100439e",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "27bc78686e8001cd1c74aa5ddb3aefe3",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "1f1f9457405b0a2be70540f6a1a4596c",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83"};
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
