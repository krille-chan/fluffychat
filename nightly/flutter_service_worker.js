'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_266.part.js": "a13ecdc6c3c9a185d72ced48b012db5d",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"main.dart.js_202.part.js": "d9b946c926e037eeb062c665f217d589",
"main.dart.js_271.part.js": "38535134367c12ba8f6ff43297758353",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_258.part.js": "8ac6f044c1bf8aa345260b83bca49d76",
"main.dart.js_212.part.js": "7e9da9beb1e688cb268127b4f1b7abb2",
"main.dart.js_291.part.js": "4c19dbe1c65459fc96ed9d26bc3c0efd",
"index.html": "0e87f91b24f54e0663049367be2c3e19",
"/": "0e87f91b24f54e0663049367be2c3e19",
"main.dart.js_246.part.js": "d2d7069c9706a6ee85f3e06eb30fe05f",
"main.dart.js_190.part.js": "69dffa384636614a2d28d45396b1acc7",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/fonts/MaterialIcons-Regular.otf": "f71ad44beb99d3b525ae88ca96857d6b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_203.part.js": "6b28f4ba0d2ec66dfb67bb5c3232c0f4",
"main.dart.js_240.part.js": "4e0e10e9d06c456f56ea3b8906009309",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "7854d2bdd2eb77f8558ef9f9a557817e",
"main.dart.js_252.part.js": "33891cab448ad68718a39d29fd7e5aa3",
"main.dart.js_277.part.js": "76d65b4aa44287807c9a5cffd268d238",
"main.dart.js_273.part.js": "9c1cef0252d42c19852448728309ee45",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_279.part.js": "d71a0b2cc873de6fa1de0051f914cfe0",
"main.dart.js": "1baa48a2800730068ab620ff42b56754",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"main.dart.js_278.part.js": "76701ad4b83d1ce7642cf151a0c41e4d",
"main.dart.js_292.part.js": "8a13dd5f2d1cbbed53c9671d7b792fdb",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "031171b016b70e32ca607db69026e689",
"main.dart.js_228.part.js": "f479406b35f396ae2a58c7453e446b45",
"main.dart.js_280.part.js": "271bf54db0bc83aafc32625dec2e4dfc",
"main.dart.js_245.part.js": "dc91de0860535e31818aba563b6efc0d",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_237.part.js": "fea2cb29c547ba0907646d87ab9b4480",
"main.dart.js_288.part.js": "71bf9240851e1b4a68e9d2a2b25f7059",
"main.dart.js_241.part.js": "7b92d9d3170384ed1b2d4720bcfd668e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_286.part.js": "9033ede4d936837f279503bffb425987",
"main.dart.js_227.part.js": "347fea47d391ff413271aa7da8f1f7af",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "253ade778a44e2a5f441488a68fbf8ca",
"main.dart.js_274.part.js": "2670f65e1a6c2b257c360a0881bf1981",
"main.dart.js_239.part.js": "bed6ed76cb0478c2f018ef7c8c0c97b4",
"main.dart.js_289.part.js": "ecf47d7ac75fcc1b6ae1da5dcc421c31",
"main.dart.js_275.part.js": "44e328bf7a14a971cec754e464f7afd4",
"main.dart.js_284.part.js": "735bfc7257a7c5872bf8af0703cd3e06",
"main.dart.js_290.part.js": "b4287761eca343f48317ae78301bb5bf",
"main.dart.js_218.part.js": "9d19f3662ba822f58bea0e6cac805a7b",
"main.dart.js_268.part.js": "9bc42f21080b0e48a6ab4e9441c409a5",
"main.dart.js_242.part.js": "8735eec926cade48334f2ca2160ab303",
"main.dart.js_251.part.js": "ad46ee75dbab37f368ac767d32620919",
"main.dart.js_250.part.js": "25a6cffb31ce917e88e4ef35621aba7d",
"main.dart.js_188.part.js": "78be7e5271c7d9312f2e84ac9dd82192",
"main.dart.js_230.part.js": "fa2c44515deaf0f5f1c82847920838a4",
"main.dart.js_235.part.js": "69353bbb08099e5606855277a9e039bd",
"main.dart.js_272.part.js": "b162906b12a54ed584acaac9e681576a",
"main.dart.js_259.part.js": "ee77b14d02e3556f0507df0f34470ab5",
"main.dart.js_201.part.js": "b9598adadbf53f2de7fae6f1fff619cf",
"main.dart.js_1.part.js": "0a2ca0f49604b82585d6f83716186c42",
"main.dart.js_261.part.js": "455ff74a64a380f73817da121dcf516f",
"flutter_bootstrap.js": "c1816a4047e72ea31bb3e9e309012571",
"main.dart.js_15.part.js": "459ea0929d1ff89909df51b8f29cbde0",
"main.dart.js_226.part.js": "ec88ba54f0a7d04588dc7af2980436f1"};
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
