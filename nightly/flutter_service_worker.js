'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "f6954daea48bc908f29c09660aa1483d",
"main.dart.js_266.part.js": "0071edd05959c1567d8b33ee7c883a15",
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
"main.dart.js_271.part.js": "aba0d5f0d9b8724d4d18ff32230e4064",
"main.dart.js_210.part.js": "098da29a260ecdb59d08de660cc73271",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_291.part.js": "250e9d92c4c4f32df68aea81c3f1e43b",
"index.html": "0c1b3747c3daa62d88a104f6e25fc01a",
"/": "0c1b3747c3daa62d88a104f6e25fc01a",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
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
"main.dart.js_249.part.js": "583ee74a9c365a5a6764d18db19e463b",
"main.dart.js_276.part.js": "251657e297176cfabbfbab30849ee829",
"main.dart.js_240.part.js": "ba8958343ef1c552a24891b5bee736ce",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_269.part.js": "f817267a6774fbc357aab9ae9351a605",
"main.dart.js_233.part.js": "087ebd026ace8f6ac4d6504ab9089d28",
"main.dart.js_277.part.js": "d5a44e9dc0fe8493b9bbf8e41225f488",
"main.dart.js_273.part.js": "07002bfcefa0569b0add85df70b60e0e",
"main.dart.js_264.part.js": "56ffcb20e74451bc0a6f1bb9671c12d5",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_243.part.js": "c3dd5e4e0bdfa7f7b10e28e09109ae0c",
"main.dart.js": "379daed41db5748f64fb460bf367e3dd",
"main.dart.js_216.part.js": "1fc1f55d853b7eb47891c2889647dc94",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_278.part.js": "ec10f8d3d587cb5eb510168799349e80",
"main.dart.js_292.part.js": "fcb0bf6621df80d77df98a0d41c2b81b",
"main.dart.js_244.part.js": "a86a24e7bffe26ba7a44f0736f8e411d",
"main.dart.js_238.part.js": "5c0e29814ebeaeebef0ca28faa175ac2",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_228.part.js": "c5d2d5cd799416471d8124ae71436ee4",
"main.dart.js_225.part.js": "65866115a304184f89ea9ae9477b3a74",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "4ccf5ea3c0a03d11a94e9c6cc6b24b4a",
"main.dart.js_237.part.js": "e9e653a5a941705d5887004fd57a4dcb",
"main.dart.js_288.part.js": "33a3acf8da28227711ebe154cd2b779d",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_200.part.js": "d9264e684ea28c79c0171faa4d6bcc63",
"main.dart.js_287.part.js": "8dfd5f642f98f143c37c0f96b25083d3",
"main.dart.js_286.part.js": "f28a76addfd790bb14cde3c4110ab560",
"main.dart.js_224.part.js": "c99bdd4a5d3e02ef000aadb3d03e1e97",
"main.dart.js_257.part.js": "2c09d83bd44a24cbcdb39d0e75facb4b",
"main.dart.js_186.part.js": "304c297ef38a91329844bca13898a777",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "3f73a068d08db7e9d56bd34f7dda5e8e",
"main.dart.js_239.part.js": "2aec5792a9649fd10d23bb2d9b8c4ea0",
"main.dart.js_289.part.js": "bda5b9f76ac792e15049286f8f7495d0",
"main.dart.js_199.part.js": "cd68b684715adebaccb4ac4d47227d03",
"main.dart.js_275.part.js": "fa57e58afca8c0fb2abf57eb47854316",
"main.dart.js_284.part.js": "259ad23560f5318bc7e5f01bd34a3c7f",
"main.dart.js_290.part.js": "ebc50e126d1f98cd764314b6470c52d7",
"main.dart.js_268.part.js": "adeae6533496dc80f89e56d2b15e91a8",
"main.dart.js_250.part.js": "c83771b54643631ccf7bf71b85d9a441",
"main.dart.js_188.part.js": "a48d6679db18adaac4e5e7c75fd1d4ba",
"main.dart.js_235.part.js": "d35957a65e6ee7841ebc2c8e67fe23d5",
"main.dart.js_272.part.js": "76f0085d052f77c5d62fd6ef989f2cae",
"main.dart.js_248.part.js": "864b08f2008c3e192b83f0b95fea1531",
"main.dart.js_259.part.js": "37b8485fe29bb38a6073a48df57df7e0",
"main.dart.js_256.part.js": "84db494944a53af194039675b7e4f466",
"main.dart.js_201.part.js": "7e7844b76413462dc3c000da3c8e5b5e",
"main.dart.js_1.part.js": "a34832fee8e55a48b4c0ed58d686f1ad",
"flutter_bootstrap.js": "d90bd2da3bb1d864d6c0c9eca28b3864",
"main.dart.js_15.part.js": "86ef86cb10fb8921b00c110030c9a801",
"main.dart.js_226.part.js": "9a71cacbe68e0febd6c2f64f8b14788a"};
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
