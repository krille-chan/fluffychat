'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "e9f74c8a7995a085bd40f53366c01138",
"main.dart.js_291.part.js": "a6d3b1b9e0afc268d596b35cbd404058",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "3b71c55a339caa3dadd0490a47b2022a",
"main.dart.js_190.part.js": "4a15598b6cb3494f94405c065f078cf5",
"main.dart.js_244.part.js": "d8d96188b3235b23be71196fcb40ce1d",
"index.html": "7b40da6e704421a56cf0d8934e0da814",
"/": "7b40da6e704421a56cf0d8934e0da814",
"main.dart.js_296.part.js": "51c564ebd9647a8d3a9a41152880a20c",
"main.dart.js_237.part.js": "334e6e087c9481d94b4df35bd18ed058",
"main.dart.js_279.part.js": "9dd7b884095d674ce67299ced4b69413",
"main.dart.js_295.part.js": "667a35e919275bff6537c2dbb3c6e5b3",
"main.dart.js_263.part.js": "fec39902d3c4a73de128457dda7332b1",
"main.dart.js_1.part.js": "89d3c7afc118157c67f0190f444893c0",
"main.dart.js_276.part.js": "86f0b686876daf1046f88140b0857f44",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_243.part.js": "0814fc1fa219076f63845057d1d3936c",
"main.dart.js_253.part.js": "91ddb2a7914084207eb68dfa4a2c8742",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "ed4b2bead56fa149c260258da0b377ae",
"main.dart.js_290.part.js": "54f805b9e36568d49d456e0c6e0dc759",
"main.dart.js": "6ef16c1cd5408a9d0ce8542ea5e9ffd0",
"main.dart.js_230.part.js": "c528bc5624ae71a48b9da50c2dbbb271",
"main.dart.js_273.part.js": "30f3173e610fcf217d2e2e6ad955d458",
"main.dart.js_268.part.js": "a302b8bf6d48dc57ac19594b361015f0",
"main.dart.js_261.part.js": "665784f8f705fde8c6596b4080b9f577",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"main.dart.js_203.part.js": "ea13c9764ca5b6884e60ba7b2d4c2533",
"main.dart.js_241.part.js": "df4bb50b0efeecfeadf9df01de6e1357",
"main.dart.js_248.part.js": "8643610df5bb2a24e6c07604506f16db",
"main.dart.js_281.part.js": "3676d17b8f85a619d85a0e11357bf55e",
"main.dart.js_228.part.js": "d1f1ac78ca0954d7435fd7a5a632429d",
"main.dart.js_220.part.js": "36a188c4e979eb40f1e6b9dd8f1369db",
"main.dart.js_270.part.js": "da790b96fade164889c6fe30d59f6ad6",
"flutter_bootstrap.js": "99f96780aac31d45c512ed90d47b637d",
"main.dart.js_232.part.js": "37849b2759c36250993abbde59c59365",
"main.dart.js_280.part.js": "31ea497cf7cedf8dae55f47de69960c2",
"main.dart.js_277.part.js": "fa639c1eaade4c7a8556c14bb43e0410",
"main.dart.js_286.part.js": "3c67750f60b47320a4093d007c894376",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "f4755b866f329222a4fa0dd37df3b268",
"main.dart.js_15.part.js": "5c4fe42314a30a96739ccfe1e1ef0905",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "4cbd7ea5f544bb1617b64e64f1069657",
"main.dart.js_205.part.js": "d47d802dec1a38874a4777037cca7f72",
"main.dart.js_242.part.js": "c02452453082c362d26f0f123ba54ae3",
"main.dart.js_229.part.js": "036714d63d3bb175a84fbcb2483172d7",
"main.dart.js_192.part.js": "b64fbe11ed105e605a389dbafd8b9266",
"main.dart.js_247.part.js": "61bebafccdc25da08b1c0cdf6331378b",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "4c24b3593c6ee36b9050ee81abbd9780",
"main.dart.js_292.part.js": "0c3b21a85efe97b4b5d20762c626afd7",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "1b8e530efd5a2cdd40644cb82e9326d7",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/NOTICES": "c8db5451253889809a6111899405e058",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_275.part.js": "b1fcc2db5086163f896594fc40899af6",
"main.dart.js_272.part.js": "50eb466ef9e27e177ab9c85c8d2f214c",
"main.dart.js_252.part.js": "549e307431b3321f7d4086b7617f37bf",
"main.dart.js_260.part.js": "4b051ae11bbac46cbec282c1beb9834e",
"main.dart.js_288.part.js": "8a941f2a4e12e6d9c95772755e9ed5e5",
"main.dart.js_254.part.js": "f45e1ce36c6d6d2e4d32735d9f142261",
"main.dart.js_293.part.js": "d38947d70201455420f47194fdc8486b",
"main.dart.js_294.part.js": "c1e07fabd16aa58d02228c12117cf3b8"};
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
