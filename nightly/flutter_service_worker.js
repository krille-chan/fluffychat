'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_227.part.js": "e5d90aed6508831cdfea89b235da4926",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_273.part.js": "04066e6d626d134742c0ae73f967f8dc",
"main.dart.js_250.part.js": "3a027c063e3a5711a48eaa7c972745dd",
"main.dart.js_225.part.js": "438821061622a3a9b1b024ab4bb28d3d",
"main.dart.js_288.part.js": "083984067bed65c7d2ef4aa4b5ef5e8e",
"main.dart.js_211.part.js": "9312b5ecdcb162d748d231e2d87141eb",
"main.dart.js_201.part.js": "abb9ce430f74cc81018b5629de57aed9",
"main.dart.js_226.part.js": "1ad485c43070236ce8e60a0bc7f60228",
"flutter_bootstrap.js": "b6fc2285ac57ae1170f72c940d3f328a",
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
"main.dart.js_257.part.js": "8e139adc99ec5e774f8cef867b7cde26",
"main.dart.js_277.part.js": "48d4f732d3daaabcc348d42a216148fa",
"main.dart.js_290.part.js": "cef019c86c28cf2f2119a91713470720",
"main.dart.js": "8ea8ca46e2de4b79dd196fd40ccb7df8",
"main.dart.js_239.part.js": "2355223b8d24e8bb0e89a8aaef932bd2",
"main.dart.js_271.part.js": "e8f233d5621dcedf8624525b9556ebea",
"main.dart.js_251.part.js": "ddf6fb6a553df4ec80758ac90988a491",
"main.dart.js_283.part.js": "77637472116ae03876bcd2721cef9e86",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_291.part.js": "1052fd324a524551ee973659bfb7920a",
"main.dart.js_187.part.js": "106b0d0fa79ae9241c85da1beaf9cf5b",
"main.dart.js_272.part.js": "cecdbe975a365660df013a47c777beda",
"main.dart.js_285.part.js": "dfe61e6120ee9f98d756b3f83c3b9985",
"main.dart.js_200.part.js": "627f111b3dd3ee831335fe7a498f9046",
"main.dart.js_238.part.js": "c2ccd47e2dd2fbaffe5c8eda53ac680b",
"main.dart.js_249.part.js": "69269d0f264e75c0f497e14c782a1754",
"main.dart.js_229.part.js": "958d2402c4317bd7717f62ea8d964e1e",
"main.dart.js_276.part.js": "c043a88e44feb1937824ba42e25233ab",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_258.part.js": "371d035f3f2e595f328e4ce542cdde5b",
"main.dart.js_244.part.js": "b9e87b14cc0ff8e016fe67c77a75c3fb",
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
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/MaterialIcons-Regular.otf": "8166643540d3cdfc8cdd5b4c505cfc40",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"main.dart.js_260.part.js": "f3fbe35ad6a5c1b292cb1fa2ffa17f56",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_289.part.js": "674e60ed00c588183e4e4e3227a96121",
"main.dart.js_15.part.js": "ce8143e25aa6718fbcdd5416f55756d8",
"main.dart.js_274.part.js": "4db5eccd7e9ac57f793356a1d95eef30",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "3a2c0f11f911b6e0f10fe7bb7c03bb3f",
"index.html": "cce929e0b024aabefbb34a397f555c04",
"/": "cce929e0b024aabefbb34a397f555c04",
"main.dart.js_270.part.js": "3bd12242c11f376b875178c14235b271",
"main.dart.js_245.part.js": "051a05a7ed3ad2f7c2680b4cdd08875f",
"main.dart.js_267.part.js": "695232687baeb4714e198d1c7a14af7a",
"main.dart.js_284.part.js": "9a3fdd996280cfe0974b3de13c204ada",
"main.dart.js_236.part.js": "d6d2f7882a29a03a963242ed543cf464",
"main.dart.js_265.part.js": "4b256e674121bcc716e58d8946e55429",
"main.dart.js_234.part.js": "e92abe733d1416441eb76eee6c95ed83",
"main.dart.js_279.part.js": "8b690ed235acf7e559e8f09de209bd79",
"main.dart.js_269.part.js": "7dc1566862f6d95e57728b37e49e6bc3",
"main.dart.js_240.part.js": "13f45739dd1dd2b46844f53d68f8e817",
"main.dart.js_287.part.js": "5e977e3212de48e2a91192950f56ecf2",
"main.dart.js_241.part.js": "1953fdab70ad73630a77db5878864972",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_189.part.js": "4e8e7161fe65c5c4b6b60ab6714867ab",
"main.dart.js_202.part.js": "de1e1344ab2424228bab700fbd2538e0",
"main.dart.js_1.part.js": "de9e32322d3a8db62b96438e581751e0",
"main.dart.js_217.part.js": "e2a35f14151da09ec1648a5e0ea4ff05",
"main.dart.js_292.part.js": "765cccf752df2835028280f1fce8a66d",
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
