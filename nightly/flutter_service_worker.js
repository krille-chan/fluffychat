'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_227.part.js": "49ac3cbd10639ddb7bc7300da03872eb",
"main.dart.js_262.part.js": "458c4f467405d6e6f4909fcab1321e6d",
"main.dart.js_219.part.js": "406f046df1c1077b846d30aca1ea1979",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_280.part.js": "1f36b687bd72c25aa060b6dbf1d265cc",
"main.dart.js_204.part.js": "21d037d4961b327bac42c8aa27bb8640",
"main.dart.js_273.part.js": "4a06ffcbc983e509790644462ed41bdb",
"main.dart.js_246.part.js": "8b86e271212205d3c8775c7b6470d799",
"main.dart.js_191.part.js": "6f1591b8a39665b36eed1020eff76c2d",
"flutter_bootstrap.js": "a576b31037b3bc24782bc105aadaa988",
"main.dart.js_294.part.js": "9fe091dc0e85c421b58d74ee8b84713a",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"main.dart.js_247.part.js": "896cd03e8cfaf4cdd9621838e706b0e4",
"main.dart.js_290.part.js": "500927cbcef9b9ac1e84d16cc0974afa",
"main.dart.js": "82501e7b73b5d8613b16f5614ca4b347",
"main.dart.js_252.part.js": "e520a11f0f60d24b24e28ba9a8639870",
"main.dart.js_271.part.js": "c24bb2b0d0630ab0bf6ecde0ddccf74b",
"main.dart.js_203.part.js": "fcee0425621b7707bf5ea024676b47ff",
"main.dart.js_251.part.js": "60193b27e27d1849cddd626f1b95d742",
"main.dart.js_243.part.js": "a97cd02d1175f99f94c258b7b4a0ab2d",
"main.dart.js_286.part.js": "01867134ea46e1beb7ebdc61c0a82766",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"main.dart.js_291.part.js": "909b99fd4d5ff8ac18bb4c4e0a404498",
"main.dart.js_228.part.js": "57b531c7444132c3c7993cd8e311e357",
"main.dart.js_272.part.js": "8bd991f6654dbc115e60ea7ce28b6fd8",
"main.dart.js_285.part.js": "c86a35cc191e500a3c7665faa8730031",
"main.dart.js_238.part.js": "eb804699287a284e97428e32b5d76b87",
"main.dart.js_229.part.js": "337a2788f883af69726f16d86fcd7180",
"main.dart.js_276.part.js": "392b10545d1a1ae8d5ec0618dc09c7fb",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/NOTICES": "224ebdd6c0f86e1033d76c5e74cd4ff5",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/MaterialIcons-Regular.otf": "56c8c0b2224c70b4ae11109ad3dc15b6",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"main.dart.js_260.part.js": "f01f29a7a73fcaef918685f820b38a7b",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_289.part.js": "9423676ebdeffb0390dae018c0482b0d",
"main.dart.js_15.part.js": "eb0d6c7e575787d61fc3ef0aa42c075b",
"main.dart.js_274.part.js": "1240f72c3a5ec5410d6bff50992a2832",
"main.dart.js_259.part.js": "1446e9a8d6407136cc1207a6ef718c7c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "0a2638c6f614eb60f7cbc8e24891258b",
"index.html": "3df64b366761ad59fbe387cbda56b08d",
"/": "3df64b366761ad59fbe387cbda56b08d",
"main.dart.js_267.part.js": "4b10f1ef2bf01ea5a6a355a952943f01",
"main.dart.js_293.part.js": "2fade7f88023d5722e0d0509c12bd207",
"main.dart.js_236.part.js": "3827a7de14c1afcc11442d77bf783c74",
"main.dart.js_279.part.js": "a0940b5d533a20579e2e58863556cb62",
"main.dart.js_253.part.js": "0d2f060c1434902e27a1c0070f35838d",
"main.dart.js_269.part.js": "3d40d2f5fda07d88bdccaf776104244f",
"main.dart.js_275.part.js": "bae39f73d203f06ad4f884cea5df4e60",
"main.dart.js_240.part.js": "9f08a728e127b14d3399ea3803f2cc47",
"main.dart.js_213.part.js": "32171f36a761aec046f0c461cfcaab05",
"main.dart.js_287.part.js": "d0209330214897507568443d290f002b",
"main.dart.js_241.part.js": "cc711ecc8bf4b90508a7c417a1ae71c9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_189.part.js": "45b9dd4a58045c6d186f65159d50b450",
"main.dart.js_202.part.js": "fbec0f2c9be77d132c845aadb3486d52",
"main.dart.js_281.part.js": "ae057988424303193be25a74e62b2da9",
"main.dart.js_1.part.js": "4ae078806ef1742ccd4f02cb43bf02e7",
"main.dart.js_242.part.js": "f5ae443429ac56771b2a705ba2b9c541",
"main.dart.js_292.part.js": "0bd9c31b52e3dca9576235db56ef7fdb",
"main.dart.js_231.part.js": "79e53d7df5f87cf064fc3f81cecf69e7",
"flutter.js": "4b2350e14c6650ba82871f60906437ea"};
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
