'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
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
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_229.part.js": "eeae442a1c7144f277aa3eb6549f7fca",
"main.dart.js_254.part.js": "8e2ea73776b496e066bb6dacc62e28c0",
"main.dart.js_247.part.js": "ada01416474807f96b3051848b3a610c",
"main.dart.js_291.part.js": "2599b32fb5b9a7c83f0253f499817c82",
"index.html": "e6fe71931c1d047705167695702c87cf",
"/": "e6fe71931c1d047705167695702c87cf",
"main.dart.js_190.part.js": "b1981e84ba4f8f05c4d9a873fc572971",
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
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
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
"main.dart.js_203.part.js": "84167a746f76d76d3e242c9581413896",
"main.dart.js_214.part.js": "efeac0be718805510e2eba999ab5242d",
"main.dart.js_276.part.js": "f50e49de8ade55a2ce47b413bea03f12",
"main.dart.js_260.part.js": "5b3095a8523d0c8f059e6228403a40b9",
"main.dart.js_204.part.js": "c5ca6bced3a87f1d0395c3c088ec7e55",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "e3ec6d1aa07981ba88d76b0a024ae3c6",
"main.dart.js_263.part.js": "49c7c99d49fe1c67a2326e56e33f9fee",
"main.dart.js_232.part.js": "c68e30d2989056bfee4eb254d3e32736",
"main.dart.js_277.part.js": "2dce6692c69b516362b47d123f31e684",
"main.dart.js_273.part.js": "e6934ed448c5118db0199aee2a2f1ef5",
"main.dart.js_281.part.js": "71e8c5642e01ff2885b2a6e5932123eb",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "e58d73c23688c9ecc3b5fbdc776e1193",
"main.dart.js_243.part.js": "2c4ced5491930202c5fd020ac735463b",
"main.dart.js_294.part.js": "a935b367817c860a2e493fd38ef13a9a",
"main.dart.js": "93113c56195a6a9811e2d35e4ecc4d5f",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"main.dart.js_292.part.js": "ae6f29db80f89886afe53488f7bbe617",
"main.dart.js_244.part.js": "36b8bb6b64bee8c20c5dd45a8ddde02a",
"main.dart.js_205.part.js": "b2c37b5e10a4df27eed3efac958c2038",
"main.dart.js_220.part.js": "a86d1b00237a77242a0b4e849f180c2f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "f05c1e464d8f82c0eccd63ffd488c6f0",
"main.dart.js_228.part.js": "f3c78d55ab5a4884f2e73cbf1cbbfa9e",
"main.dart.js_280.part.js": "d1d0b958b22f750ddbd922461ee66de6",
"main.dart.js_296.part.js": "4ba20f383d095ac72939d60bcb99347e",
"main.dart.js_253.part.js": "e7859b8b1eb5b35f88907caac7c2eb8d",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "2f3a22408bbcd7f32361750099fa22f7",
"main.dart.js_237.part.js": "368fc96feca7bc368b8bb312af27e886",
"main.dart.js_288.part.js": "b45c79ef9154015aa1b2a9951fba1cd2",
"main.dart.js_241.part.js": "9b452e8cef8d47defe62ab254a7b8e6c",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "66a9a1b966029ad24198c76e1f42b30e",
"main.dart.js_286.part.js": "d930f13a207fec2a93f0a6861aec116e",
"main.dart.js_192.part.js": "0052456afb8188e315697a0c9a635af6",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "b2806bfeedac0a3356d74353047194f2",
"main.dart.js_274.part.js": "c4d14b2852fbb61e085e6b5234e233c2",
"main.dart.js_239.part.js": "5e1cab1725090de80d94c6f25a6456d2",
"main.dart.js_295.part.js": "2bd4f65211471cb8dddaa3fc060e4bfa",
"main.dart.js_275.part.js": "0e2680b88328662cb34687d07565e65b",
"main.dart.js_290.part.js": "b3a299c627683f9a1e1ff108b0b14767",
"main.dart.js_268.part.js": "2c43c586fb44dea13dca0c56e857055c",
"main.dart.js_242.part.js": "36b7d44a15ce6e4dfbed22d06558e00b",
"main.dart.js_230.part.js": "97d223c31421f4c0a27ed2392256178c",
"main.dart.js_272.part.js": "c0e378e231c444ea2a0705411bbba48c",
"main.dart.js_248.part.js": "571c309b37d20a93d0f92a6307583550",
"main.dart.js_1.part.js": "e498494354387b801735eba39778f417",
"main.dart.js_261.part.js": "596d4099ee945294f73f62fe1f4b7267",
"flutter_bootstrap.js": "2afba724962367eda9cea0f19743c6a6",
"main.dart.js_15.part.js": "ad663866187c4489186e88f65c104b62"};
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
