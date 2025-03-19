'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_266.part.js": "eddd5f1f7d97ba9b74e691b63d0f643d",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"main.dart.js_202.part.js": "2888c5e083334d20c3c2e5a5003a5f48",
"main.dart.js_271.part.js": "25b884d4e036bc5ebc42b7ad3216effb",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_258.part.js": "2251ae6e9bddbe3a6a83c13fb28def3a",
"main.dart.js_212.part.js": "401e2b4f95997fe43764e5034594baaa",
"main.dart.js_291.part.js": "0d542892798449ce77b668b50d1d0b39",
"index.html": "9da11bfeab2d852260835c9d060d8d25",
"/": "9da11bfeab2d852260835c9d060d8d25",
"main.dart.js_246.part.js": "4dba2033470af75b8cd90b8705187234",
"main.dart.js_190.part.js": "6db5df9507f8a2efa233865385389300",
"assets/NOTICES": "471b2a0851fcdc133becffa45d320aef",
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
"assets/fonts/MaterialIcons-Regular.otf": "8a519bfdc78399fb84620c2198e937e7",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_203.part.js": "671af54f01173282387369bef86852ee",
"main.dart.js_240.part.js": "970c74e35b8bb7ab380afb8938ef31bc",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "ec05e423aff9009ed477252bbdb54bfa",
"main.dart.js_252.part.js": "1e74020d37c73d4e47e733c32aa5708b",
"main.dart.js_277.part.js": "f4397ef26f128a2b62885677460dfde6",
"main.dart.js_273.part.js": "03622b312f2f20d09625632f1c0d73b3",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "fe5ceb2ab0dd41d334d89132c9eb2eec",
"main.dart.js": "2604d1eb1e0b5a1891f2b0e6058452d4",
"main.dart.js_2.part.js": "2988f7440ef78bbac865e28d4b52c637",
"main.dart.js_278.part.js": "fe199e3e5a2778869044d21c09bd6d04",
"main.dart.js_292.part.js": "39618ce06b922754a613b101a208e7a3",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "944d37d887944106a4687b03cd26b3b3",
"main.dart.js_228.part.js": "285704eb3d8e69a8f5e7b6c3f93c22e9",
"main.dart.js_280.part.js": "b82035bfa0bf0069772a4463a641a000",
"main.dart.js_245.part.js": "c58772b1705bd144401645bd1fac9b6f",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_237.part.js": "fc66a7d0d61ca0f73182bed6f473ca26",
"main.dart.js_288.part.js": "0d49d1cedcc259ea23cb1efb63535c97",
"main.dart.js_241.part.js": "55c59946b0f8202e7ff7722be1dd5dcc",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_286.part.js": "78fad37480fbd2f33fc143e95f46ff6d",
"main.dart.js_227.part.js": "15e25388d5160bfbd06ac6b3ef8cc834",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "d88d7110cebc3b598eac2f0e3595dc86",
"main.dart.js_274.part.js": "fd07b9de59f864d29fa85a7a984d177f",
"main.dart.js_239.part.js": "775df86bb064e9e676a90112bf7dfa1d",
"main.dart.js_289.part.js": "f7136fef3721fc3c7eaee9d073ceb4bb",
"main.dart.js_275.part.js": "209ebdfa24fb10a9d6541ce54dc967a7",
"main.dart.js_284.part.js": "253d6f637fc81c2bc757b33152aeb076",
"main.dart.js_290.part.js": "a9aab0658453e5ed373c5cef7a2970a7",
"main.dart.js_218.part.js": "6b11fbbf182c0c5fbff6b8ea440af7b4",
"main.dart.js_268.part.js": "843c92b38292ae89cccdd0711d564ede",
"main.dart.js_242.part.js": "b335e61c278d0a403bc594ceac56f817",
"main.dart.js_251.part.js": "311ee4e2ef384d6a0b8cd05b16cd2f15",
"main.dart.js_250.part.js": "1ee51dc7492251e0028dec1bcb14117a",
"main.dart.js_188.part.js": "a1e8f4066e17d4f57f515a3943c2a39b",
"main.dart.js_230.part.js": "dab5a875ab842b9dfd65628c1de3595a",
"main.dart.js_235.part.js": "7272938ffc967c22e3ed92d1ba6b99a6",
"main.dart.js_272.part.js": "c595197019e948854262ae63db956fca",
"main.dart.js_259.part.js": "ffd25b278e41c827d03bcbd3db232fa3",
"main.dart.js_201.part.js": "0195d842c1058901098274f4a3397044",
"main.dart.js_1.part.js": "fcc419a1c091f6c4c732936ab4ac92fb",
"main.dart.js_261.part.js": "cd42cfc867b283dd6127dbb5fadcfc15",
"flutter_bootstrap.js": "503d26e92db416b952cc05e1dc26e3ac",
"main.dart.js_15.part.js": "bb014b7d552517eec6810e54e54d06c4",
"main.dart.js_226.part.js": "0675f9230e2219b5fd2f0353fd9114ba"};
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
