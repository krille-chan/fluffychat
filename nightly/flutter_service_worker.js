'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_199.part.js": "45db878999403f36fb271663b37f4203",
"main.dart.js_266.part.js": "6b76adae06ec63849604e306d030d64e",
"main.dart.js_270.part.js": "ebce6c39487de9b6eea152461ca1a131",
"main.dart.js_237.part.js": "7497f2181ae47d37e95d6f1d7925479f",
"main.dart.js_198.part.js": "3c56defd0f91c5a05144faa08c0c57c1",
"main.dart.js_268.part.js": "318085058230b4e12a4b23a0c3fb35f9",
"main.dart.js_257.part.js": "dddcf8e7a71b7886703c169caa96d046",
"main.dart.js_238.part.js": "88026508aec949799913f2c17440b9c9",
"main.dart.js_241.part.js": "aa076f54ba93d00161dbf5a2e48a9c47",
"main.dart.js_287.part.js": "ae9caadf007d85e2001ecf2dbc56bdfe",
"main.dart.js_254.part.js": "efc2097f774e6c64d560033e264b8516",
"main.dart.js_288.part.js": "7b0f137dabc55bae54f15b4b2734d20b",
"main.dart.js_208.part.js": "e928b50f0ac2fe26e4ef42f5a01ad394",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "843a4c977f504e76a16e3ec1efb32bce",
"main.dart.js_284.part.js": "c40cd98e576442e27cefffc58a7895e9",
"main.dart.js_187.part.js": "6ba74d672a4c1c3d8083cfc2db9890cb",
"main.dart.js_214.part.js": "4bedbdce9ec0b6a5cdc02930c5000437",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_233.part.js": "dcc2f54d373aa4b963f5ea4dd830b08d",
"main.dart.js_267.part.js": "0f0c65b2162fa753b4d52a0f37d280aa",
"main.dart.js_248.part.js": "b19add5371493cce910838d64d74b6a7",
"main.dart.js_262.part.js": "0bd39eaf7b951ee00a97395941964951",
"main.dart.js_222.part.js": "55d8b637cdfc7336173d3e515292e88b",
"main.dart.js_255.part.js": "b30546e17cf150059537e9040ddf72ba",
"main.dart.js_247.part.js": "587c5c10f68710b2762e9fa0db13b185",
"main.dart.js_286.part.js": "0debcd303f4b175fe30cd4e07b64994d",
"main.dart.js_275.part.js": "8f419fce79afe4b52a346e3e97db2263",
"main.dart.js_282.part.js": "99b8316499bf3fbdf3479c9152c122de",
"main.dart.js_276.part.js": "aa59dc018b13aa26ac76c37f3a73fbb6",
"main.dart.js_14.part.js": "7dcc9e0280b02e977ef7f32b36da689e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "958b61b01f68b01dda00624fd23f845e",
"main.dart.js_236.part.js": "f4ef296d8c7aa6e238b218c62dd96ac0",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "6fec8037d55bb54e5228c6e113332f59",
"main.dart.js_235.part.js": "8a31cc4590aff86a3d2f37058af5c451",
"main.dart.js_264.part.js": "a2764f084218945844369f545ac7f7cb",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "f5c46518affe782776dd62a3867e8279",
"main.dart.js_285.part.js": "1dd87cadd0a78d76aec3721fa75bd0fc",
"main.dart.js_224.part.js": "64590817c4019aa894e7fbb081368ea9",
"main.dart.js_226.part.js": "141455fc38dc51ddb5a7b6e404706473",
"main.dart.js_274.part.js": "efd5dd9980a2847b84e7d5847224a8ef",
"main.dart.js_289.part.js": "a71863e1dab70efbbc6b3ae10fd22352",
"main.dart.js_280.part.js": "2638d0b0ceee9f2fe2fafb4ac75a9890",
"main.dart.js_231.part.js": "5a5ae51606050467a1e1e32e1dac5ba2",
"main.dart.js": "66551bb107e002ea674f09176b4d3363",
"main.dart.js_2.part.js": "592b7682355010a6166e3d8e675136d4",
"main.dart.js_273.part.js": "49995df0080b3dbd81b118318e517c3d",
"main.dart.js_281.part.js": "73f9ae027b29728f169da9dd45f3f8ce",
"index.html": "7d8e108b5cec1e0915aade2dcf2433c9",
"/": "7d8e108b5cec1e0915aade2dcf2433c9",
"main.dart.js_271.part.js": "866c2d965cb57748a6beadcda0d76e03",
"main.dart.js_200.part.js": "95c0caef413028c7b286920896836897",
"main.dart.js_1.part.js": "c34ad17867f89dc3a88a853e940542bd",
"assets/AssetManifest.json": "341b122113248d15c16dff08b1bd5047",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "9afeb8627ec2db3e8c103ba3fee8e83f",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/AssetManifest.bin.json": "a501696bd1e234d2a7b0f016d4994600",
"assets/NOTICES": "ad0bae227833957d26c4c04efb3df256",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"main.dart.js_185.part.js": "e17957591525157f8f3d2f618a8d5704",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "e5238ba415a2bc68fab19496353168c7",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
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
