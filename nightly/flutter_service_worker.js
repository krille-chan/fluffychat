'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "13c53be139bc86a63fd5cf9f460b7d50",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "a7aa3e1b12f314099f89711f8405764f",
"/": "a7aa3e1b12f314099f89711f8405764f",
"main.dart.js_236.part.js": "5a8dbddbc7c51ec90df71fb468c49091",
"main.dart.js_279.part.js": "b89b91b6e8b9021f24d89d560388ea5f",
"main.dart.js_295.part.js": "ca06e1219d6613d9f5a338c2dfe72655",
"main.dart.js_1.part.js": "a08a79d918736921f44c08ed1d24cb73",
"main.dart.js_276.part.js": "5f52c694d0c956cee1e98cfe67dbcb50",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_219.part.js": "bd426d404e67d2d6f69c6d9f74248140",
"main.dart.js_271.part.js": "c9673fd57367259cdca9ea9535996758",
"main.dart.js_243.part.js": "e0d816b9c8f8247398f9f8c13a8c05f8",
"main.dart.js_191.part.js": "0a691143b7e99f7963a81e66c53c3dcd",
"main.dart.js_253.part.js": "19b357ce42643a2736be6235eec7b720",
"main.dart.js_246.part.js": "f6b3b5407d238ed52de52315a623a068",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_290.part.js": "56d963f50b6dd48b30286d7a8e76845c",
"main.dart.js_289.part.js": "aafd675c4154329559b9f45626b7b9d5",
"main.dart.js": "5729e41f93af34297101edfaac2f32f1",
"main.dart.js_273.part.js": "9de7226f5198dedc028cd9d2fd6ae62f",
"main.dart.js_278.part.js": "f185fd036dfa43c62caed726ff8cec3b",
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
"main.dart.js_203.part.js": "93adc1e0888530d133ab6add5140dcaa",
"main.dart.js_241.part.js": "308966e6d6a2b6a61664f0e66986dd28",
"main.dart.js_202.part.js": "a3d21cfaa7bee7b200e6f087d315f54f",
"main.dart.js_281.part.js": "8863f54b94ab179bc73f21ddab023885",
"main.dart.js_240.part.js": "012f1bc4523dda0f6d80b185be87d7aa",
"main.dart.js_228.part.js": "48c882c47c8f150673022fb040d40ec1",
"main.dart.js_231.part.js": "3d00578bd909fcee1c2dfe9ca13b86f9",
"flutter_bootstrap.js": "930bef44059fad42d41ad4f52b99394a",
"main.dart.js_280.part.js": "49d2a06ca24dfdbcb556b01f56ff5349",
"main.dart.js_238.part.js": "40d86a9d6f048ece5d368e6b75049259",
"main.dart.js_286.part.js": "555b3a87696a5fd44d06b7fb7056f57b",
"main.dart.js_262.part.js": "4fa7c9d6b97ae8f55fe09d2a7ca14e62",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "f5d694c4972a13887a7065bacf19b6cd",
"main.dart.js_189.part.js": "47bb1d6066912821b1e41a07bdcf2c82",
"main.dart.js_15.part.js": "52c707f114b562aadefbfcc111e08837",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_251.part.js": "320bc326cd4bf1d9c5381c2bf24c5f64",
"main.dart.js_227.part.js": "bbce3db1d0d6639843f1b7220813b070",
"main.dart.js_204.part.js": "63f306f7dbf87b766e98ba940b60dfda",
"main.dart.js_267.part.js": "e3ed05c4e92746b0831916a1d242c8e3",
"main.dart.js_242.part.js": "67e0a6bb5ceee0ce64fa1c9a206b31ba",
"main.dart.js_229.part.js": "8034cdbff476fbe8b3e7b7a30cf5f6d6",
"main.dart.js_259.part.js": "c8a64a394bb312ab1b5635cd9924117c",
"main.dart.js_247.part.js": "e9809cd694925e7ced8b6f618a4f0ffd",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "feb9b8cd291e73c8c4fe30b740ed5bcf",
"main.dart.js_292.part.js": "cf643440119911ffb46ad9a75588e85d",
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
"assets/fonts/MaterialIcons-Regular.otf": "9f4c6848f06fe55b64ee4a287246d084",
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
"main.dart.js_275.part.js": "1002f92236ae92babbe2aa4f33a2f35e",
"main.dart.js_272.part.js": "2a708422bdc7b55e2ccda57aef182c39",
"main.dart.js_252.part.js": "a1f43434b9af46a896f97a80c72a6ef6",
"main.dart.js_260.part.js": "13a265e9911775307709e0acb6efe5a5",
"main.dart.js_285.part.js": "379a6f7216ead4198dc95fff8dedbb6a",
"main.dart.js_213.part.js": "5d48eccf9225c178ff1b8639339a1a8f",
"main.dart.js_269.part.js": "04f574222369be24f79bb1ba0e009a9c",
"main.dart.js_293.part.js": "7b2284ce07e1b52ea3546c6e6fd0d87e",
"main.dart.js_294.part.js": "656ee342c85890b570621ccc5d789a0e"};
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
