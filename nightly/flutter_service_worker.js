'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_230.part.js": "e53c1822a600ea5db80f550f936d1bb6",
"main.dart.js_276.part.js": "3f61ab23acc191ed949a2b07f4aa709c",
"main.dart.js_274.part.js": "023f4d8eba06a1407798217665e89920",
"main.dart.js_292.part.js": "492d92bd7143f1ed11dc8a19f045aed9",
"main.dart.js_286.part.js": "536885504598fe91bb09018a5ded9936",
"main.dart.js_239.part.js": "0623f1877cb4551c5b4cc5ab0413dd9f",
"main.dart.js_263.part.js": "8856e93736cf4ea6ac920f66079da6b0",
"main.dart.js_203.part.js": "bfcb992d03665d557cc9e4494bd0fc6e",
"main.dart.js_232.part.js": "f659b6cf6d48e64399b1c2800a50b909",
"main.dart.js_243.part.js": "a0e5254720646bf8639ba0c6512513c1",
"main.dart.js_248.part.js": "29ecf93eadf14667475809d97e53ff0d",
"main.dart.js_275.part.js": "f88fb398dbc55924d83cc5b9c3199084",
"main.dart.js_296.part.js": "e46673d4c9f03db048571c7b487b9233",
"main.dart.js_212.part.js": "d6be783bea8f9a0c11bab56cae916e5b",
"main.dart.js_189.part.js": "e61d43e58091f7330beb0936134b5d9f",
"main.dart.js_242.part.js": "8479ec810cc372b4480fa38f1ebbb739",
"main.dart.js_241.part.js": "73224b11aae559df59a1e252adfd0f32",
"main.dart.js_1.part.js": "3cacdb7117f26abebe4c070587512718",
"main.dart.js_252.part.js": "ac71b6b16e6d27c109665d771cc104dd",
"main.dart.js_16.part.js": "ab277acdcf48e8071780d80f0555a2ee",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "f0575675aafa932b040e2155d7028931",
"main.dart.js_220.part.js": "cbf2319fc52fdd46fe4c3ec6d2533c4b",
"main.dart.js_253.part.js": "78171ff24ee2afa8240f71255e503d26",
"main.dart.js_218.part.js": "4d6e425936ee05e4ef7674ec05c456d1",
"main.dart.js_204.part.js": "f05dd15806a788061a65a10c0511be4b",
"main.dart.js_287.part.js": "cdcc56c1bea65b3958db12c41b88ac3d",
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
"main.dart.js": "5c07a432531cd2b5d0b5e7ed145a15bd",
"main.dart.js_254.part.js": "e80889c46cf7b4cd1df9e53e22c2396a",
"main.dart.js_273.part.js": "385f2127169eafc33706e4de10ef4bed",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_268.part.js": "e82ecd4d478fa6b8673d1632c61eaa09",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "1500b7ed02ad6d8998a807ff1f5cc2ad",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"main.dart.js_281.part.js": "81aff64049c34795ad1d2fa284d6470c",
"main.dart.js_282.part.js": "beb9cc9ea6dbae3cf1fbcff7dcbf4ff9",
"main.dart.js_279.part.js": "befbcd22578381236f7729d5010a612e",
"main.dart.js_191.part.js": "5648045ee938b62ed3bb407aa797a349",
"main.dart.js_293.part.js": "df5b41fc32d859feb43ed4d9631cdadd",
"main.dart.js_202.part.js": "8729b7824e0d448df4889dd7353556ff",
"main.dart.js_297.part.js": "bf00b07510ce1ef87a9bbbcce645eb87",
"main.dart.js_2.part.js": "d6c338eddec0d3623b489032ee604cec",
"main.dart.js_229.part.js": "de6526968b41b7c0a489b1bb41e47392",
"main.dart.js_270.part.js": "26d22a5615c7e2b51b1bfb69c03668c1",
"main.dart.js_280.part.js": "928c21f612a06bda051aec5868143100",
"main.dart.js_288.part.js": "17a29e0631973ea31e89bf2d335d9f48",
"main.dart.js_237.part.js": "f5844d2732e550e9dd31561d323ab883",
"main.dart.js_228.part.js": "2d0a7ffd44ceecdd4638515af9d1c34b",
"main.dart.js_277.part.js": "eb658c0b1ef732ad7e6f360044335da5",
"flutter_bootstrap.js": "c8fe54a922c0552447619987f2ec2fc2",
"main.dart.js_247.part.js": "c88a3f85b960c2f126c7fc0829c0cfc0",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_291.part.js": "0e8fff6622ae8e34485911bbedec3614",
"main.dart.js_260.part.js": "4c5a89ae96cc3c31f6d6d9f1b6df0d57",
"main.dart.js_244.part.js": "8d17d9bc9674de0fdea284cfc08f73ed",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "d7d6d4d03b2dd51f0a842987e95f13e4",
"index.html": "fc7ae6b201921c0154b427505a64955f",
"/": "fc7ae6b201921c0154b427505a64955f",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_272.part.js": "b4f264728eb3a6000db7979c2cbeb354",
"main.dart.js_261.part.js": "19fd32daf0194936f21a643de5c8f3a1",
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
