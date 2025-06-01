'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_262.part.js": "59006743598438e0c2f4e5808438701d",
"main.dart.js_276.part.js": "aef1c114f71346dbccf2a8295029e952",
"main.dart.js_274.part.js": "e58c745ae38fa91431118761ab352692",
"main.dart.js_292.part.js": "1488aabc471767bdf98d14bacaf92cb4",
"main.dart.js_286.part.js": "546d245ff236a75f1b251464aab9faa3",
"main.dart.js_227.part.js": "4e49800c918df6f4d0618da0e14c08fd",
"main.dart.js_203.part.js": "00fcda0c969158deacfb9a5e1719b836",
"main.dart.js_243.part.js": "1ff171e769cd49af480adf6da22aa24c",
"main.dart.js_275.part.js": "d0df5a2fc2afc94dfa37eacbd9ff0673",
"main.dart.js_296.part.js": "7866049ff28713edd960fe6cb19ce872",
"main.dart.js_190.part.js": "b1c1169f9397fdd3c90f430bc995b4a6",
"main.dart.js_271.part.js": "3d27d6005358e634bcc4bf74dc1f7ef3",
"main.dart.js_240.part.js": "1b6b64e49ba41243cff37c20fcf339dc",
"main.dart.js_267.part.js": "3dec4198a1016f0751459cf80b953e69",
"main.dart.js_242.part.js": "3287317a2dbe9d9fd63240066cb2803b",
"main.dart.js_241.part.js": "130ea5700c49ac9cdce87dd874f06d9c",
"main.dart.js_1.part.js": "49dca89a06c30b2cbc681f6b6a99e98b",
"main.dart.js_251.part.js": "5b97bfde6e173b69d3b22392a7c2e022",
"main.dart.js_252.part.js": "8c61d7d5acd336c7cb24067b03aaeffa",
"main.dart.js_16.part.js": "7e64f6195d3ae8cdfc10eac316f27cf8",
"main.dart.js_269.part.js": "3c0cef5282cb196ab13502424e94f03f",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "194c24d144ea4f152653334ada1fa5eb",
"main.dart.js_253.part.js": "6ced5e7ab0820189341dfcde0b88f300",
"main.dart.js_287.part.js": "f5cf78f7056e814d742dfe31ec3cb4f9",
"assets/fonts/MaterialIcons-Regular.otf": "f5f22db300aa7bdf86de1c57d4aa8d3f",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "c4c151b1b0760395c474aef86e34c28c",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "983fbbb360750a0476b9a04a2c1cf05c",
"main.dart.js": "2616538a92bc54d5adbd55278543a16c",
"main.dart.js_273.part.js": "3a8ce2704c5100e6e9d649c0f57567b1",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "6ed5af3bc6ed8fea5c9021824d52b85e",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"main.dart.js_281.part.js": "92475265ccb43639947c36bc29fe00f4",
"main.dart.js_236.part.js": "3a3693fe41651171e0ab06dbd54170b4",
"main.dart.js_279.part.js": "b61651be49017c41ee4a147388ea2a5e",
"main.dart.js_293.part.js": "880aebd10634213dd82bc01582f840e5",
"main.dart.js_202.part.js": "f787ce4a5ee7f582b9ac5c8edd1b0a4e",
"main.dart.js_285.part.js": "f9f77ac5a08a9c590e11b051ed62bded",
"main.dart.js_278.part.js": "b88f56df617f823f80376dbf47400c00",
"main.dart.js_2.part.js": "d6c338eddec0d3623b489032ee604cec",
"main.dart.js_229.part.js": "ba292d5341866e5e4783d937345bcc51",
"main.dart.js_280.part.js": "a410bfecc8284cb9ca18fb6ce3b2541c",
"main.dart.js_289.part.js": "9e505c48796676c0e0181f65eafd8d38",
"main.dart.js_231.part.js": "b57aab24b98381a3dc4db62f132d4aac",
"main.dart.js_211.part.js": "d0cd5e6909a9b19c7955fb60a551b647",
"main.dart.js_228.part.js": "caea80c57b2545bc753de48a3fb15e1a",
"flutter_bootstrap.js": "17eb8ac8c675ada3f2ffb4d9d7122549",
"main.dart.js_247.part.js": "cae5810172353b13cfa8a12575275f48",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_246.part.js": "a9aa44b6ef95ea7cec8793d0b7258f88",
"main.dart.js_291.part.js": "461db34d7a37569d9f4a02b3aa6e869c",
"main.dart.js_201.part.js": "e58bf5f498b82e32f384ddab3a5ecee2",
"main.dart.js_260.part.js": "2646a6527be91a12c708f6843b19ddb9",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "8b6264f20f915caf996683c96e036cd8",
"main.dart.js_217.part.js": "4382a9cd46f01899f45f8b3bf4a5a9bd",
"index.html": "3f81916d3cd3723f31fec75fe2605c5c",
"/": "3f81916d3cd3723f31fec75fe2605c5c",
"main.dart.js_219.part.js": "99a846fc9bfc804e08ad27775ffbf878",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_259.part.js": "d69e9a9c763b737ae6a86722a2a5f3d2",
"main.dart.js_272.part.js": "83ef6f39ffc19c8c825b3570fc6a7c96",
"main.dart.js_238.part.js": "0bf5407005e95cd3642ba7216f25fe92",
"main.dart.js_188.part.js": "e9f9bd8b3994dfd35d18ae9c1db0d1b1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd"};
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
