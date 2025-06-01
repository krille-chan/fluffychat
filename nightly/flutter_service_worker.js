'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_262.part.js": "52d700a7fe4b8ee293dd8e72410671c7",
"main.dart.js_276.part.js": "bae6f1922008c841c4499c103f8bf69c",
"main.dart.js_274.part.js": "ea26a83f498f5022bad78824323e4539",
"main.dart.js_292.part.js": "224a3419d66fa7f79a681d5b9aa9c992",
"main.dart.js_286.part.js": "918667d657cd1e0423e31de2afadcdb3",
"main.dart.js_227.part.js": "a2fc6e3ebc78b6c934f80b529709ab16",
"main.dart.js_203.part.js": "a20634fc52ba3495a0ed70f83dd0b4bf",
"main.dart.js_243.part.js": "e229209937dac55c12e83d84fae48ad5",
"main.dart.js_275.part.js": "923a028d82ac166d5fee28a4d7c286e3",
"main.dart.js_296.part.js": "11610f3056ac74f1f43c16af59740ab9",
"main.dart.js_190.part.js": "796bd1075f46752fa549cde9ffefd9fa",
"main.dart.js_271.part.js": "fc71fabba975a88a5b0ab1a25ed9ace2",
"main.dart.js_240.part.js": "3d5bd5dc5ca4fd105ec3e1674c9495c2",
"main.dart.js_267.part.js": "e3f3b18f69813c3d6f6d9b7849e41e19",
"main.dart.js_242.part.js": "50c0b08ab8c5a8b43bc15471e0ec7534",
"main.dart.js_241.part.js": "b5ba364c140b9abc889e3e05e5f39f3f",
"main.dart.js_1.part.js": "68b9cd3a91241c5cd2e760e9767f4d17",
"main.dart.js_251.part.js": "26a101427b97c6da13af0f5b594fdd70",
"main.dart.js_252.part.js": "c71aceaf2cbb0a48876a8cc1d8a7e79c",
"main.dart.js_16.part.js": "bd10baf34170117f4cd624b877089806",
"main.dart.js_269.part.js": "a9de7fa84131c04badb916e2037c6445",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "e415b73491b725b38646fb76fabfc1b3",
"main.dart.js_253.part.js": "1637214ddf15b743228bc735b7ea557c",
"main.dart.js_287.part.js": "7e3925c8514d9f2bfafeb1ab489f5d34",
"assets/fonts/MaterialIcons-Regular.otf": "0f73bdbc3eb9e9032a2a319f3942ff0a",
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
"main.dart.js": "d4f1f6dde344cb799564a1c9ba76f2b9",
"main.dart.js_273.part.js": "8a3ec24a34940dec7da065ede42d9b85",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "b69dd01b4c3c00369556c5963a3c483d",
"canvaskit/skwasm.js.symbols": "9fe690d47b904d72c7d020bd303adf16",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "1c93738510f202d9ff44d36a4760126b",
"canvaskit/canvaskit.wasm": "a37f2b0af4995714de856e21e882325c",
"canvaskit/canvaskit.js.symbols": "27361387bc24144b46a745f1afe92b50",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "c054c2c892172308ca5a0bd1d7a7754b",
"canvaskit/chromium/canvaskit.js.symbols": "f7c5e5502d577306fb6d530b1864ff86",
"main.dart.js_281.part.js": "9a57fb11c0a2cfbe24789d2083619291",
"main.dart.js_236.part.js": "796f483edc582ad6b38a703bfb21dcf1",
"main.dart.js_279.part.js": "3b5dcd48f0baf9aead87f1976cfea95f",
"main.dart.js_293.part.js": "e17f5a7abd4b2efc5853f684201c6b63",
"main.dart.js_202.part.js": "f0f58a9a750d067c1e2b5ab4bc6dcf07",
"main.dart.js_285.part.js": "3273e6d610727ce8628edbbef7171d39",
"main.dart.js_278.part.js": "7b5f606f94944a4a873cdfcef1cba880",
"main.dart.js_2.part.js": "d6c338eddec0d3623b489032ee604cec",
"main.dart.js_229.part.js": "d6b7f8bc0f0f258938c33fc496dd601d",
"main.dart.js_280.part.js": "b064b434fc11799b07e2ad5e112ce22d",
"main.dart.js_289.part.js": "3cbd3cd8fe4b3435e578907b8ee3d6cf",
"main.dart.js_231.part.js": "0d5a0bd299f9d703c270f51b686d9f7a",
"main.dart.js_211.part.js": "2ea05d0c8c4a2346b1f3513faa34fdd0",
"main.dart.js_228.part.js": "af174078b495cbbb813fb22682817007",
"flutter_bootstrap.js": "1dfedacf933351bc07555da9960f39eb",
"main.dart.js_247.part.js": "46383072659b9bdaaee6b7ac18090ec5",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_246.part.js": "3750b83ba33f44cca17b9231df1f6a1d",
"main.dart.js_291.part.js": "78fb8500b4ca4b1f7f9aae7125fe9095",
"main.dart.js_201.part.js": "4975241f4b5f9db59dabf23920b0bafd",
"main.dart.js_260.part.js": "ac82cd9ba0b35341fa5a86b02f1f618d",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_290.part.js": "9da8e4da409a7f2543600cb095cfd41b",
"main.dart.js_217.part.js": "73131826c4c73caf5eafedbb7d57b3f0",
"index.html": "a9a2e9fd5b00412c516c27fcc82846c2",
"/": "a9a2e9fd5b00412c516c27fcc82846c2",
"main.dart.js_219.part.js": "a32bea43d90edd9b26f27bc22d767b8a",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_259.part.js": "1b0f3b55f1d078036a5d4b8d06a9daf5",
"main.dart.js_272.part.js": "0b43ecc5169f38a332c3efdbe59e717f",
"main.dart.js_238.part.js": "e5fc052235e45d3d5ba7199c060757c9",
"main.dart.js_188.part.js": "5809a252d564f60a16a49593ed12296a",
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
