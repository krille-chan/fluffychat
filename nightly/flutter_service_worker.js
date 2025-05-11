'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "1e862e0af367f631a298adc286d75808",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "07c999a1f8c98d8061cd69d0658c00d9",
"/": "07c999a1f8c98d8061cd69d0658c00d9",
"main.dart.js_236.part.js": "17816f24d3f74ae6fe1eaf0b6139b430",
"main.dart.js_279.part.js": "d05dc2066a1f31a8065395145bd26740",
"main.dart.js_295.part.js": "2f2c42e42b773a1b33d0a1a65d4847f0",
"main.dart.js_1.part.js": "8b1ee2a60764239b9c1410288f3ad352",
"main.dart.js_276.part.js": "01dd876797c5782010177def130fde73",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_219.part.js": "470d0e3335960ed2b1ed4cc20bb4e3fa",
"main.dart.js_271.part.js": "4980acfff0177ba0b139aac78aca634c",
"main.dart.js_243.part.js": "97bd7dd1704041965de06b8a536a7929",
"main.dart.js_191.part.js": "0b56c78ac162a97c39e0fb4c10418822",
"main.dart.js_253.part.js": "ba458df4916ae8355d09f4cbf5bca68b",
"main.dart.js_246.part.js": "b99c1bd6013d0910740ac9f55f179480",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_290.part.js": "1beb1cd608dad769b831b510c3a582e5",
"main.dart.js_289.part.js": "26d436c14e2fa56b442a6104789dd924",
"main.dart.js": "c32f82898c9dd8d4263be68bf07cf15b",
"main.dart.js_273.part.js": "936de07a129003ae9865ed02fa93ce60",
"main.dart.js_278.part.js": "7cdbf054181ae60f827c6e3b5f4fa298",
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
"main.dart.js_203.part.js": "c6c3fa3a735b678583e881f06697677e",
"main.dart.js_241.part.js": "b0d5502f82fd17eb57f79c7aa34e539d",
"main.dart.js_202.part.js": "4ad1add4f24869ba74243741886ff5ed",
"main.dart.js_281.part.js": "4d4bf95ae6033fc942c3d7950dc0ca3d",
"main.dart.js_240.part.js": "a20828a48e0f85d27ff99c50356d3658",
"main.dart.js_228.part.js": "cefadf6a134800c4e7b5fd8a21401b3a",
"main.dart.js_231.part.js": "2bfe0489705773cbc60fc3302095a966",
"flutter_bootstrap.js": "ac0e122c5dcfacf4b35b665c8a17d688",
"main.dart.js_280.part.js": "0c88e9f6fbffe2234555cd381fe90321",
"main.dart.js_238.part.js": "ff5311176b5b5db0dc528fda5d1cec08",
"main.dart.js_286.part.js": "db7c48a931425772d9422a972c9621bd",
"main.dart.js_262.part.js": "7c6e38a30d073ca7ccad6b90539957e6",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "7eb0873204b09e07532e60983d72e34c",
"main.dart.js_189.part.js": "6c34932b4bc053bb3bc59acccf9f9d49",
"main.dart.js_15.part.js": "a1f33b8a5dd396c2d6a056fc052b1640",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_251.part.js": "1343e1e70f6ad0584cd30668c2f55747",
"main.dart.js_227.part.js": "a29500d489f0cfb7a4ac034919d0d8b2",
"main.dart.js_204.part.js": "e09695f95ba8c3ca0c7c263e99936f8e",
"main.dart.js_267.part.js": "3ed0a15e064d3167718cf51f707301d0",
"main.dart.js_242.part.js": "e4920a9b4bfe48e5cd4a0cec66aa2ab6",
"main.dart.js_229.part.js": "c0d4a8653c766988187589930cc38d50",
"main.dart.js_259.part.js": "eab1813dea11c599c0f6c048ae0818b1",
"main.dart.js_247.part.js": "ab0b8a730b9fddd9fa4e5c25c6e316d4",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "67f60fecf1df8f0fb07039b3580323d2",
"main.dart.js_292.part.js": "7d29368775adcca2cc2421331740eb74",
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
"main.dart.js_275.part.js": "9a4dd7e3decfd6c136633078c0bbb1ad",
"main.dart.js_272.part.js": "235543e5dd396d75d0dceb8072b0018e",
"main.dart.js_252.part.js": "b6c51a6e6f501422ef0dee186e7e84ad",
"main.dart.js_260.part.js": "49247ba1aeca2884a0bd9aabffb6b36d",
"main.dart.js_285.part.js": "dcaf990b04dd140d79e3937bb425df68",
"main.dart.js_213.part.js": "7dd83f45ad9e322d88202724f71935ac",
"main.dart.js_269.part.js": "85000dda103fe119d534ff36f2cf2038",
"main.dart.js_293.part.js": "b0b436a40e0fa40ba353afb5ce6dbfa8",
"main.dart.js_294.part.js": "8a8e2c64dd2117e8c31b1ca681caf988"};
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
