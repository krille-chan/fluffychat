'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_204.part.js": "4665b434c56b42ab280d65d6b6c7b620",
"main.dart.js_278.part.js": "48aea01929ba0eeb6fc5877c19ee945f",
"main.dart.js_287.part.js": "1d6249d9a6c26be7dc8ecedf8b9000d8",
"main.dart.js_286.part.js": "23cdcc135fe8dfbd448cc144c1206969",
"main.dart.js_229.part.js": "7c1ed957fd345322999984da30315d55",
"main.dart.js_241.part.js": "190a143d13104b35d7a2eab3ec5059c3",
"main.dart.js_269.part.js": "c2e09d6692003348012438dc6be115c8",
"main.dart.js_251.part.js": "f25a0fc52057b7d128ae452dc6e8cc2a",
"main.dart.js_227.part.js": "e71a26dbc585c2fa7b1c8f7d4c6d612c",
"main.dart.js_290.part.js": "02019eac1ea09042e564b0cc11a0cf41",
"main.dart.js_260.part.js": "9f32943b5c2e1203de973b2f09cf58e4",
"main.dart.js_294.part.js": "bb155e98458b11db8bdb69e7ee3d122c",
"main.dart.js_271.part.js": "afaca5da45435cfc9e31eba79f857ccf",
"main.dart.js_228.part.js": "358c5e3f7a1eb1426b42c32f0a59090f",
"main.dart.js_285.part.js": "ff70280efee8ed7515bb3e4895835742",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "9f4c6848f06fe55b64ee4a287246d084",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "c8db5451253889809a6111899405e058",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"main.dart.js_191.part.js": "1c685ae1758597c5d6d727c3e264b4fc",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_240.part.js": "62518f77efd4f2ddf8644efbe133b342",
"main.dart.js_259.part.js": "02e62e09b0b163b80bbbde2739e890c5",
"main.dart.js_275.part.js": "015d3c480882b07c30f8de967c739a90",
"main.dart.js_1.part.js": "d0b249f89261f52ff6c40c6fe94770fb",
"main.dart.js_213.part.js": "2714f561d4058f017a55fe3d77924887",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"main.dart.js_231.part.js": "817566ccb40ddaec843c90ef5b401dbf",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_15.part.js": "95303d84c354942618c9aff304eaa60e",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_272.part.js": "ceba710b12d9d8b7f9832193f7d69872",
"main.dart.js_295.part.js": "224cbbcfba0b359ab9e0ad94c7bd5213",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"main.dart.js_247.part.js": "9cbf5f459b8febe6c53a2b1436a8001a",
"main.dart.js_274.part.js": "a72901468025132f5a070898c04d312c",
"main.dart.js_203.part.js": "eb3d076bf6e87e05e1507c5d0d5ae15d",
"index.html": "0a4fc19dad9518922c21a176315fcab1",
"/": "0a4fc19dad9518922c21a176315fcab1",
"main.dart.js_267.part.js": "0f5eef781ce8fe635165623e3a2965a9",
"main.dart.js_242.part.js": "442b6b7796a63974fa892f3e8a6fa47d",
"main.dart.js_253.part.js": "112d073043cc8d09274e243bfdd384af",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_236.part.js": "6a83e48eba1da8f0a9a306cea35955f1",
"flutter_bootstrap.js": "9dd81b432a2f3940fed5d88520115148",
"main.dart.js_281.part.js": "76da410d75c9c79fc613629197072bcc",
"main.dart.js_219.part.js": "8a4a32f6439ad110de01d41585ca41db",
"main.dart.js_279.part.js": "08865110afda0ef057f106faf08bf344",
"main.dart.js_280.part.js": "fa4589623788a94018983052f389fb47",
"main.dart.js_202.part.js": "1b30c0f07e1ea25292639136fb9d762a",
"main.dart.js_291.part.js": "606b6434ddee5de0ab0300789b2c6236",
"main.dart.js_273.part.js": "05f08243864e6ca1f5997202254172e8",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_238.part.js": "85ed0fb1211264d2348eacbb3f3cb0f4",
"main.dart.js_246.part.js": "711279ae7e492069a3f72fa60a5d0cc5",
"main.dart.js_243.part.js": "754d0a1ce477f6a95e254ef7cbee5ccd",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_252.part.js": "7392cb282bd1a6d7a5fbfe240783e96a",
"main.dart.js_292.part.js": "251f2c4fee67f6ad1e0e9a7539606229",
"main.dart.js_276.part.js": "28791413265f963e045634b26f32aec5",
"main.dart.js_189.part.js": "7e7ac563d8b0813f9f6257ed502ed149",
"main.dart.js": "a30683341dd3d5f2da7c50a53c924c1f",
"main.dart.js_289.part.js": "74d3f7773f68837472cbb9d5aac3f899",
"main.dart.js_262.part.js": "d025d036b02cf43f1057df335b790b58",
"main.dart.js_293.part.js": "b407dde5a369f44c901b0fda291e6cad"};
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
