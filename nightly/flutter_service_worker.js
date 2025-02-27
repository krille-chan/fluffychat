'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "524ddfa68f729247927b2c0b1cbe2a8e",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"main.dart.js_202.part.js": "7f20d3572333e4f36015becb363c517f",
"main.dart.js_271.part.js": "e5aaca5b1e7eac5d0227f48727acc764",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_236.part.js": "60e7b41a5729c8dad48d352e1d40bdf6",
"main.dart.js_229.part.js": "6c756876bc22d6c13964a37053106e47",
"main.dart.js_258.part.js": "f7016d59187e24e666163d99af45aa4b",
"main.dart.js_291.part.js": "9ff93b8f03279260e8f0d232a98615d8",
"index.html": "3e99db9b34ecbe76ed2d7b9c8aa56ac9",
"/": "3e99db9b34ecbe76ed2d7b9c8aa56ac9",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
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
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/MaterialIcons-Regular.otf": "8166643540d3cdfc8cdd5b4c505cfc40",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"main.dart.js_249.part.js": "ec52f0242290a0a35a06da4e39cb6bf3",
"main.dart.js_276.part.js": "8a935a44ced77fca5a63368001abbc76",
"main.dart.js_260.part.js": "d996d1d845ea2b521eb6610a823b4f05",
"main.dart.js_240.part.js": "afc0eb72a5b654ddb5c81e71c6b5b65c",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "e0aba61173b2dc2b5874fdad786d6e78",
"main.dart.js_269.part.js": "c13b5ea627ae8136d29d153cb483e84a",
"main.dart.js_277.part.js": "f50de214a783df4b3900f0fb60ad9c32",
"main.dart.js_273.part.js": "edbcfdf76faea218d81bf1edaff09fcd",
"main.dart.js_187.part.js": "3dcf30001b744ae570c752aa3a047e2d",
"main.dart.js_265.part.js": "90516a40692befabdf3f77466cf98db8",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_279.part.js": "464d585cd7cef2a7bbe2555ccc721d4a",
"main.dart.js": "c477cc6f329f5a3ec8938133e02aebd4",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"main.dart.js_278.part.js": "16e95a6bba7cbc3f8e54bc9ceaac34f9",
"main.dart.js_292.part.js": "278c192b7e35aa5fd447ed4e42105267",
"main.dart.js_244.part.js": "2151c8f762c9cd33cb84556744177a54",
"main.dart.js_238.part.js": "0f5530e9638a2dcc66a1dbbb14ba88e3",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_245.part.js": "fe9d07fa526a9683307cfe8d905495b7",
"main.dart.js_225.part.js": "e22cfd12f272fa21c4945a38a107aab1",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_288.part.js": "2db2b7c779f4de361a0bed8f13694277",
"main.dart.js_241.part.js": "147fb2b9ef0757486e62d3037cc0b952",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_234.part.js": "3f87482220b8fa3ffeb40ff94e9cf06a",
"main.dart.js_200.part.js": "d04d80452fe75cd782efebd86df17571",
"main.dart.js_287.part.js": "2101dd98b12b711d293761dfdf6d8332",
"main.dart.js_189.part.js": "42a76f4823da00be6d5391e45cf7fc51",
"main.dart.js_257.part.js": "0fc8e88609eb7e35533143e70023e804",
"main.dart.js_227.part.js": "c2bfa08eceb5a377fcbe018546b8365c",
"main.dart.js_211.part.js": "b30fcd44f8bbc824444bdbe8ca1225fa",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "c20fc3da2654e044fd6950a0f8a8cde8",
"main.dart.js_274.part.js": "cb3c637ae991417b4f49d2ddfa4b99aa",
"main.dart.js_239.part.js": "1904e0580b3afb701e760b724dcd867f",
"main.dart.js_289.part.js": "5a277d0267eace179c248327c2771eb5",
"main.dart.js_284.part.js": "aea2363022c2a4a607f148d5620ff851",
"main.dart.js_290.part.js": "da30b32054ee2fc83ec732a6a61a507a",
"main.dart.js_217.part.js": "00ba77af72de08616a90b24dd531ead3",
"main.dart.js_251.part.js": "63198cbd39ca4ac4ea1b19dc19151b71",
"main.dart.js_250.part.js": "74c3c0cb3324c73af5147f435eac00f0",
"main.dart.js_272.part.js": "971bb9aed277f95a54216a8b01eef455",
"main.dart.js_267.part.js": "2396546c5a7b510ccd4752d1184ed471",
"main.dart.js_201.part.js": "4bc0440a4e74b55f7c5c31c389477564",
"main.dart.js_1.part.js": "0041653d66958023b41507666744a8b7",
"flutter_bootstrap.js": "ff8a4eb7ae7b8c29dced90a7585910ac",
"main.dart.js_15.part.js": "cc7b44a932aced575a0917ef8fa86336",
"main.dart.js_226.part.js": "ae71cfdb7559b8cc2ae00187dd678907"};
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
