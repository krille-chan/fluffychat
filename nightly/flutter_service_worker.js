'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_290.part.js": "3dbbbae84017838d5fc4a96e857c53aa",
"main.dart.js_247.part.js": "fba5da5d88eb065af99dbc5444836c8d",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_194.part.js": "4d32e1987d0609328ac5deadeaf6f7e5",
"main.dart.js_299.part.js": "017a692ad5faa644455aa7e917b5ce18",
"main.dart.js_249.part.js": "002b3e0eab1f8af95da9de3ec3e2fb42",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_246.part.js": "d3986011871adbaaf475ef390a363331",
"main.dart.js_256.part.js": "611b748c92618c79dff7a7f769700bef",
"main.dart.js_274.part.js": "6747c5f123ed95c0c23bce7ce2edc333",
"main.dart.js_207.part.js": "2fe4057aeb6d5e1312471acb21d71bd4",
"main.dart.js_276.part.js": "64a8a9e7064034e13531b2dabbc5030f",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_264.part.js": "36de1de10dfd3c61e02cd9cc1bb0bd32",
"main.dart.js_285.part.js": "503839870ceddc679518923583e1ffba",
"main.dart.js_1.part.js": "ed809414606edce8be873528f50ad2d6",
"main.dart.js_300.part.js": "4dfcab5c52873f386c6ca81c5235420d",
"main.dart.js_298.part.js": "73b70174fd244527bfce2e92e35bc0e9",
"main.dart.js_286.part.js": "2a369817a84a2ebe417de2b14129342d",
"main.dart.js_252.part.js": "5f7dcf5d7694c5e35c22ea833b7fc373",
"main.dart.js_235.part.js": "4e4d2ad65ee0b9c6f15616c0cd19c711",
"main.dart.js_242.part.js": "476e4597327d0ffd5af554c076cb7900",
"main.dart.js_283.part.js": "b2afccc583c16fb40c186ba4c30bb869",
"main.dart.js_277.part.js": "a44e913655c285331a2a891284664ac2",
"main.dart.js_234.part.js": "60fc7dbfc28d7c3f53f376ed2a300d26",
"main.dart.js_223.part.js": "8b056bdd9f7da79dca410e29484da604",
"main.dart.js_217.part.js": "ef4fe435b8396df2007631998a22aa1e",
"main.dart.js_248.part.js": "232c6733f559f13d9bf1f5b5631eff7e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "84178c2c335172ee24fd021e08612c55",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e7cb13cc13fef115e5125d3167671fc4",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_301.part.js": "9178f5ad4499addb14eb2fb37647b700",
"main.dart.js_297.part.js": "e22809db7f3e7875fd61b7fa4a1358c3",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_226.part.js": "0616f94064cd35000cb04be39d6a7c73",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_208.part.js": "d23d901361816bf16e7530a8799721af",
"main.dart.js_272.part.js": "0ac719471cc7f3be6f1591229de4e6ad",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_238.part.js": "970f5a15757952eae91689e29d66151e",
"main.dart.js_253.part.js": "22f507089d430284e5dda92d45d65969",
"main.dart.js_244.part.js": "84383529741a3dd6c8e4f0305c6c7c59",
"main.dart.js_267.part.js": "70855f749190d7ac5e74c5f8e54f5ccf",
"main.dart.js_265.part.js": "cbd886dbd2a3b4c63e70391fe27fac31",
"main.dart.js_16.part.js": "ecee20db1371368e00510998be8b9c10",
"main.dart.js_294.part.js": "f53d4e532aceb022ab7357b3aa4b3d0b",
"main.dart.js_236.part.js": "15cb7b35af3acd69e153b46ae108f882",
"index.html": "ab312215e90676fdfbfd7ec0e6b6ec19",
"/": "ab312215e90676fdfbfd7ec0e6b6ec19",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "be629c9380c9c3adc7e10ff8b4f8dc47",
"main.dart.js_209.part.js": "fcf2b4a2e192901d1fdfa602c5bf498a",
"main.dart.js_284.part.js": "4570342d2da91d1ef3f0f1e257d089e0",
"main.dart.js_291.part.js": "7d5a2e5b9693a37a7d3e0bc7281e36fe",
"main.dart.js_258.part.js": "8890b78606fa9314ba79026289668a06",
"main.dart.js_279.part.js": "0929e1589f6bbc6af00b4c6042f6f62c",
"main.dart.js_296.part.js": "dd345f12fd4de5e0648167c76d3fe0c9",
"main.dart.js_278.part.js": "04b79aa6f9e4734ec25049ff113402cc",
"main.dart.js_292.part.js": "43b6e09645cfde951e57d77734bafcd8",
"main.dart.js_295.part.js": "4fdfa369b28387c95a407eafa5c0b81c",
"main.dart.js_257.part.js": "6e58f4feb83e6fba33a30dbd0cb76eeb",
"main.dart.js": "1fb4f04be0c30d4181b67b6fe443ad46",
"main.dart.js_280.part.js": "9367254bf540eed91b751017906ecdd9",
"main.dart.js_281.part.js": "21cce8af90a438e3b1f02578276604c3",
"main.dart.js_196.part.js": "3b3e823d30cadeb7eb375567fbc5ebcb",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
