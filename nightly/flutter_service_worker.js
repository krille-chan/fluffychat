'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_266.part.js": "f0fb91bf5a50fb3aff46e2e6ee3eec56",
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
"main.dart.js_202.part.js": "aecbeb00332ec4d6c734893d7121675b",
"main.dart.js_271.part.js": "8f500cfffd804518eaf9abb2809264b4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_258.part.js": "1a01866bbe12f735136382fc1dbafce7",
"main.dart.js_212.part.js": "76447cbdf8224806cc541c65f3f841c1",
"main.dart.js_291.part.js": "28869fc2d82e8205cc0821e2f5eae690",
"index.html": "26f0cbf93baeeb43816a2f6731c41725",
"/": "26f0cbf93baeeb43816a2f6731c41725",
"main.dart.js_246.part.js": "e720c6359e1d90e2a9f713b1c47838af",
"main.dart.js_190.part.js": "94705480cd3bcb6254a353c32f8ac8a5",
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
"main.dart.js_203.part.js": "a046286d8f663e431e2a468eacfc9f4f",
"main.dart.js_240.part.js": "cca28b857946853a6c9290940d5baa50",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "fbd16baa40bb8bf1b45dbf7b2a286083",
"main.dart.js_252.part.js": "668b8e22c0371e524e7e047e227986c5",
"main.dart.js_277.part.js": "33bef215ad74293f86d7c5de65f9c0ad",
"main.dart.js_273.part.js": "b4709ebbbf22b8a9d4dfb8d3f7fa4fe7",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_279.part.js": "cd5f2c604cb1d61be1607470f6761f5a",
"main.dart.js": "686f177e95cf7bfe1a1026616eeac305",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"main.dart.js_278.part.js": "09bfaa8f84d658d6e4e7ad3547ccff3e",
"main.dart.js_292.part.js": "df516dd309be56328c8d866adbeb7357",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "03c00c6599b778620e76b8d87c68f882",
"main.dart.js_228.part.js": "88d8f9e07877b0b4393af96ae3b82e48",
"main.dart.js_280.part.js": "753a0771fca2446a557be15c63b6655b",
"main.dart.js_245.part.js": "c9a2dae2bcfe9d8736c07da985b5485b",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_237.part.js": "088ce66f7708d35ff0e964937ed70ad8",
"main.dart.js_288.part.js": "cdc0d78ea63f51c8451ae489376fafa9",
"main.dart.js_241.part.js": "88bbc10d36a90ae0619f6fafb078adf6",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_286.part.js": "f60e42ffaacb4223497dd598e917e4d8",
"main.dart.js_227.part.js": "904036347ebed7023ebce6c2a243e50a",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "a1614fae4354d7ef379c1d25ba53689d",
"main.dart.js_274.part.js": "70288b9bdd3c7ac2083051122237170a",
"main.dart.js_239.part.js": "5ade7f71a02ff578eb39a6ac063e80c3",
"main.dart.js_289.part.js": "8de17e00eb02fd5cd1ae3494da922018",
"main.dart.js_275.part.js": "55d82d9e638507196b74a29423fb42ce",
"main.dart.js_284.part.js": "9c5fd7c4237173869abea79807be446f",
"main.dart.js_290.part.js": "2cb79432563c2bbb0e22f1d65d65687a",
"main.dart.js_218.part.js": "c199b888e26ca39a8e5d2d3226009372",
"main.dart.js_268.part.js": "06cc7e6c41c78fd95b30e5d40c459cc0",
"main.dart.js_242.part.js": "5c615fbb928ee5ce12af19743c0765f2",
"main.dart.js_251.part.js": "4bc0975ef8280ca45806297e26534913",
"main.dart.js_250.part.js": "f549e68d3aa86d6ffc5e9b2500e1b356",
"main.dart.js_188.part.js": "377256120c2c45a054be61e4fb29d123",
"main.dart.js_230.part.js": "be8085db3063015b2241399e08895ee4",
"main.dart.js_235.part.js": "621896e1f35a0b682003b360a1d137e3",
"main.dart.js_272.part.js": "9d36373f71e5411798baab8af09189dc",
"main.dart.js_259.part.js": "90a2c6f7a54cb40d7cdc1a0ec951674c",
"main.dart.js_201.part.js": "ffcdfaff7e9b634d0d08431f46facbc6",
"main.dart.js_1.part.js": "48491ffc3d6e9d4422b4dd06e6da6571",
"main.dart.js_261.part.js": "1832ed62dbd17b95227b0af264e82b70",
"flutter_bootstrap.js": "9572e8610f766cceb5d7ab463ee15052",
"main.dart.js_15.part.js": "151838db9ff5b71e3e5c471c38404322",
"main.dart.js_226.part.js": "d672f876dd65e9bcc6da6f4a605c2090"};
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
