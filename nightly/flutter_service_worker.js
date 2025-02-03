'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_272.part.js": "72a3afa69e5cbd845b0afda09f8ed771",
"main.dart.js_199.part.js": "07baea72e61a373b93eb32cc8dd7faf3",
"main.dart.js_225.part.js": "9a7e0704105d53c6208b0cc6ce408cee",
"main.dart.js_239.part.js": "c2bfc4714ffc64d5cd050689523be402",
"main.dart.js_270.part.js": "e955eba3610871d29b3a7285facedcfc",
"main.dart.js_237.part.js": "bdc17a9211e1eab30a77a351c79f557f",
"main.dart.js_268.part.js": "9155b4c230b52a7316f75d4433423f36",
"main.dart.js_258.part.js": "bb7dce7d4fbe447e522a53f2f049a048",
"main.dart.js_188.part.js": "bad9fa7e2bca0f1941f43e5be413210e",
"main.dart.js_263.part.js": "6efdd154104fe3c24239c9f42f804e9d",
"main.dart.js_238.part.js": "9d15c2d2028d62fd04e2c0dfaccf4904",
"main.dart.js_249.part.js": "5f55ab794d2697cd0b8598751557278c",
"main.dart.js_243.part.js": "2ef116bc7e37d656320bde3b56cfb40e",
"main.dart.js_287.part.js": "f295537fabb1cf01b87d98bc5ef89b2e",
"main.dart.js_209.part.js": "e8b510d6989cdf18c20553ad56712fb6",
"main.dart.js_288.part.js": "b264adb1353c2d54e8b838accd642820",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_265.part.js": "3781e6e0e5a14a3bd8be39ef0be8f3ed",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_267.part.js": "dcee263c5aba79c13511a4205d6edb6a",
"main.dart.js_248.part.js": "a5ac251aa88d070329117eefc26a6441",
"main.dart.js_255.part.js": "de26daae8b624728bfe4676fbb5e91e2",
"main.dart.js_15.part.js": "871e4ed70439615bd7c8b24246d7b78a",
"main.dart.js_247.part.js": "8bb70aa534ab18e44ad6d6841142bdee",
"main.dart.js_286.part.js": "5c2cf4a03e68ec4982da155a4b96d2f3",
"main.dart.js_275.part.js": "247b2b054a0f55ffa8e21b0062484ba0",
"main.dart.js_282.part.js": "8fe837243d90334fc926ec68a0dcdfb5",
"main.dart.js_276.part.js": "d59afeeeee6a44f6367975452f01b186",
"main.dart.js_227.part.js": "4fd8311695238f10d69c793d4bc66854",
"main.dart.js_186.part.js": "3e14bb1ef83f9203f17c72c0b8dd0f2c",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "c2c2d06c6075d8306cc49694ae9e69da",
"main.dart.js_236.part.js": "15fc24c144f29ee217af90e837696125",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "0b71e3ac986d324a703ce94826b70ec6",
"main.dart.js_256.part.js": "dbd030ee902752982b35dfee35661248",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "241b7b7a9b9ff745c0116a5670dd6e77",
"main.dart.js_285.part.js": "7550a43792b67d6f0a51d4b42b4ae0a3",
"main.dart.js_201.part.js": "8db6a158200d94ee0898d26a24dd154c",
"main.dart.js_290.part.js": "15cc015f75fcd7d8292b3d0d782ec738",
"main.dart.js_224.part.js": "6c3a6e29dfa3a709211ba32cf1071c75",
"main.dart.js_274.part.js": "13b5ad6c43394448c05af1160ddc54f4",
"main.dart.js_289.part.js": "460c3c8efa6256e4c814c9690879a364",
"main.dart.js": "71dd27d115d92d33e1735ada55a2ba2a",
"main.dart.js_277.part.js": "ddc7a3c1a94408831c0ad24336045210",
"main.dart.js_2.part.js": "81a750809dd1fb2b074db9c419829e66",
"main.dart.js_234.part.js": "0d55e30ed6920b6adeb5944f8be76321",
"main.dart.js_232.part.js": "914c75d69b6bd4f01cf69b759f577595",
"main.dart.js_215.part.js": "01f256f0a6f91cace1ecfc43e46413e6",
"main.dart.js_281.part.js": "cefa43fd610b8c3ae1e1b94876a67bf9",
"index.html": "1338ffc17c3ea3495ad25fc8f3d6cc11",
"/": "1338ffc17c3ea3495ad25fc8f3d6cc11",
"main.dart.js_271.part.js": "645e673a65dc76cce48f2346d24b1ccf",
"main.dart.js_200.part.js": "b0fa8e40ce2f13aef920d60d88d6b0b2",
"main.dart.js_1.part.js": "7fbd8971813e9d1605a936563805c96a",
"main.dart.js_283.part.js": "9edaa2d9c7a78c34a79cae9e37123bea",
"assets/AssetManifest.json": "5606bcb8d476e740a799889f97124dd9",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/MaterialIcons-Regular.otf": "3125aa4d9b23105836cc8f538283c78a",
"assets/AssetManifest.bin": "ca7d99dadef7fa74c8ff737fc3160bb7",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/FontManifest.json": "3535e1991eb6c27bc5931452ad32e0c6",
"assets/AssetManifest.bin.json": "f405440ac7652d7fc9dd0d5020ee38bb",
"assets/NOTICES": "224ebdd6c0f86e1033d76c5e74cd4ff5",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "a0c3008c31ebef0533e9913013e21c56",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
