'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "c6caae9fc63a401249dcfea4a8d08b52",
"main.dart.js_291.part.js": "f73aaa3eb6db82e82e859391ff3ce0ac",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "1b076813c3b032fb772367c570ba4bc8",
"main.dart.js_190.part.js": "bb6a1622fa3aaf5ac73015439a955543",
"main.dart.js_244.part.js": "d5ff41ad4fe8e631e982477a39d2df2f",
"index.html": "763d8b3e28fd3e7ce38d1047d8d0bf38",
"/": "763d8b3e28fd3e7ce38d1047d8d0bf38",
"main.dart.js_296.part.js": "d89dc2d35c33424c86d8a4188ca5f54d",
"main.dart.js_237.part.js": "99a7153024ba7875504df4a45db34157",
"main.dart.js_279.part.js": "06c4de64969a4de6299d5a936cd3db91",
"main.dart.js_295.part.js": "cb912a379a83cf96a84722da59787824",
"main.dart.js_263.part.js": "8399239688af8c66d24a4375d33aa4c7",
"main.dart.js_1.part.js": "2e6a31141b267883ee39e09c43cfce58",
"main.dart.js_276.part.js": "9c3dab2f4e8578bdc611301d4a0244e4",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_243.part.js": "9e20174326cebf165acc6d6f2ed676b2",
"main.dart.js_253.part.js": "af681c13644c4790bdac81c9fb82fa99",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "dde4ad900a53f5df17204d7ae331e11c",
"main.dart.js_290.part.js": "b2fac12608f3eefe4e363683a05ae7a1",
"main.dart.js": "0be988590820a4b607866e4ec6e3cd0c",
"main.dart.js_230.part.js": "414af86f347ec7c6763473ee5f059fe5",
"main.dart.js_273.part.js": "fe554a737b8cc3b84491be0a7302aa8c",
"main.dart.js_268.part.js": "49f5df309bc5f3d7bded1fc7b06dd6e8",
"main.dart.js_261.part.js": "ffbade10b99bb392c9962ee2d0a4a47f",
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
"main.dart.js_203.part.js": "3be075f054f3f656c80bada18539f9c8",
"main.dart.js_241.part.js": "226a9e8509ec65a47239f70c40f4d34a",
"main.dart.js_248.part.js": "3ae696b287ee243f499ef9a67601b32e",
"main.dart.js_281.part.js": "24b78d797c2efc897d178b460b5f3823",
"main.dart.js_228.part.js": "9ca107782d216aa8df1e35e988392e89",
"main.dart.js_220.part.js": "772ca667e20dd54f19e864aa5241357d",
"main.dart.js_270.part.js": "f91432a1b7653de552aed79b99f8ea1d",
"flutter_bootstrap.js": "9907ed78fb52e8e8d8ad1ed5c0d85e5e",
"main.dart.js_232.part.js": "3ff05c957db12520bfb0e0a420ce69bb",
"main.dart.js_280.part.js": "806cc96c4702097a9f18de5764ab1afe",
"main.dart.js_277.part.js": "da422474dfbada995ab8a7cee1f99f4d",
"main.dart.js_286.part.js": "cba52c8592401655b5a77392379ce71f",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "23e78f8e17006957be20f8df2e00172e",
"main.dart.js_15.part.js": "bd80fc5f5900a33bcaebe816ac1e2689",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "e46c77d57e3c12c4af748a5b48cb8b79",
"main.dart.js_205.part.js": "d1abe837fc9de9a3a0b9b57323d7f081",
"main.dart.js_242.part.js": "a092728be4dc3a82f73629e8169ceb9e",
"main.dart.js_229.part.js": "7bfa1c0f1c0f2a4319ff19eb40aa3bce",
"main.dart.js_192.part.js": "878d29fd2d8c6e958acc88dd80d243fc",
"main.dart.js_247.part.js": "e753b501cc055f7c522d5d7a6701b0fc",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "268dabb3e7de4ce716ed629e9b5ce7ac",
"main.dart.js_292.part.js": "8ee7bfd968202e86ceaca13ffb43895e",
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
"main.dart.js_275.part.js": "07698a82d30d4cdbf27d0f50744faf12",
"main.dart.js_272.part.js": "bb3a96b458b56cd3fcc03bf4bc0137f1",
"main.dart.js_252.part.js": "16fb0c630aa9e1f387ffc86a7a05bb30",
"main.dart.js_260.part.js": "654fc077bf0757ec5d0b07664987a95d",
"main.dart.js_288.part.js": "df850439b7a62fdbb2417a236e6a81e2",
"main.dart.js_254.part.js": "9548eff41acc4d38f8940a64e03cad6a",
"main.dart.js_293.part.js": "8d7df612dc252b017bb0aaa4b6becc47",
"main.dart.js_294.part.js": "6b280332d8e4bd8f4c65751d6373964e"};
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
