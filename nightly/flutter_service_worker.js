'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_214.part.js": "341b209795970c1afa419c82c86d7a57",
"main.dart.js_291.part.js": "0c2c41099f166643b844c05fddce271e",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_282.part.js": "ac7091e7c661a064ac6914241df6a399",
"main.dart.js_190.part.js": "2bb0b9218dc9127d55a69b3fe65770e3",
"main.dart.js_244.part.js": "baf6f6041c28e3ea3813c0ff566f9685",
"index.html": "6fd7848c41359a8444c95c2b0848525c",
"/": "6fd7848c41359a8444c95c2b0848525c",
"main.dart.js_296.part.js": "e5b3dcea3e06d26b816de4008c89f414",
"main.dart.js_237.part.js": "0e17f35380af98bea3a3ab0db01259ac",
"main.dart.js_279.part.js": "a2a483e105ca8933f5254ef2a1f6fb7d",
"main.dart.js_295.part.js": "3622f3a0d8ad4dc9a8077bb0e44192b8",
"main.dart.js_263.part.js": "28123a7fc8336207469fd3ebfbe70e85",
"main.dart.js_1.part.js": "cddb94daaba07a269a25dab871b71d69",
"main.dart.js_276.part.js": "07cef96404e46034d19948fa2e08c460",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"main.dart.js_243.part.js": "8af6be87f9ed58e7bf04c9a675b6f953",
"main.dart.js_253.part.js": "3052c569229ff0fb028695c0e84d1ad6",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_239.part.js": "cd2109891e0fc0fc30cc95f0582eacc6",
"main.dart.js_290.part.js": "ea7f61a566518fa10988c24c3e86aacb",
"main.dart.js": "7d828e57b66ffafd3e8387e9ef5453b7",
"main.dart.js_230.part.js": "5866fb136480dd4e273283438324c3aa",
"main.dart.js_273.part.js": "20ae2ce6de1c55aaf68963d22d4b6743",
"main.dart.js_268.part.js": "66b630a9799949c7ea9173bf626fed9a",
"main.dart.js_261.part.js": "765fb48e48bc309ab7453039569de4c7",
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
"main.dart.js_203.part.js": "918c9dddd7521426b96900a33409a5cd",
"main.dart.js_241.part.js": "c01c761564f3933596796ed65fbf9461",
"main.dart.js_248.part.js": "fc6a21151b5f1200e3703f8be7930ecb",
"main.dart.js_281.part.js": "0e93ae2b6610d0de506cfae81ab390e8",
"main.dart.js_228.part.js": "9dea2e86645ca7dee5a4e8b69422c855",
"main.dart.js_220.part.js": "62028df25be19dc2da4e3ffa6a4a2772",
"main.dart.js_270.part.js": "dff29d351bef9a28a56914fafef0349c",
"flutter_bootstrap.js": "b807e54666a6dc5fe63f5ca386a000f3",
"main.dart.js_232.part.js": "3783bb284a2a876c7afaa3b316361d6e",
"main.dart.js_280.part.js": "b34364c0032388bf4227c98b43139029",
"main.dart.js_277.part.js": "cfb7b16df2b5f65c144112e539c58c57",
"main.dart.js_286.part.js": "86b5539aa0026e859929187e60d5604a",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "0a0641ece95852cd68bc5f613d8a1e6e",
"main.dart.js_15.part.js": "b6aaa9022a4df05ae7df735ffd58218f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_204.part.js": "00740f71b62c788515af60ac30a40625",
"main.dart.js_205.part.js": "beff0cda9282af5309edaf1e58b1981b",
"main.dart.js_242.part.js": "0a877b6980666d4435bc8c3bffb66004",
"main.dart.js_229.part.js": "b81be5ad4f7abb231182370c5def5abb",
"main.dart.js_192.part.js": "4f260c4f46c5c02eb2513652db73965d",
"main.dart.js_247.part.js": "f66b289027881f1b7c28825180fec2a8",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "fa23a20800858a221613ee291b7e909f",
"main.dart.js_292.part.js": "259143f0e459ee6346b7e3b89e621334",
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
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
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
"version.json": "bab3af646225186c2ee572830da047a7",
"main.dart.js_275.part.js": "01303807433be177badb97eb48e6489a",
"main.dart.js_272.part.js": "b50388eba6757a13561ac2cdc3f22cb0",
"main.dart.js_252.part.js": "9ecef8afcfe48305f5939f83b8e40d6c",
"main.dart.js_260.part.js": "32994c9c279f434d7021302ad10a53f1",
"main.dart.js_288.part.js": "0dadb0ebcd567128dc164cd0a937cabf",
"main.dart.js_254.part.js": "ab01b0eed024d2d61227453cc50e1123",
"main.dart.js_293.part.js": "405399b6d96fe04e7973beb8efe0d932",
"main.dart.js_294.part.js": "d4ede2948b7d61947218e35884f5f8a5"};
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
