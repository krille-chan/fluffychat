'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_199.part.js": "9c5b5722272efa8cbaf1fb7d43731ee2",
"main.dart.js_266.part.js": "b4a34fecd3a82e59c83bbfae196eef12",
"main.dart.js_270.part.js": "f62f16ea20332b4aeb66b9b65aa46a51",
"main.dart.js_237.part.js": "d26bf1d3c7bd0711402b3524ec2bfd63",
"main.dart.js_198.part.js": "fd4f2de642658c3a69c1e135f460b336",
"main.dart.js_268.part.js": "a46415188536886b462371302406cb7e",
"main.dart.js_257.part.js": "3ae7c634f4de3a1eeaa94a5dab84a286",
"main.dart.js_238.part.js": "13eb11aba7d3a94aa9ab2bf90ebf7e18",
"main.dart.js_241.part.js": "681e329bf1a9c1277a38a9cd7cbbde6f",
"main.dart.js_287.part.js": "fa34d56c62f52e08410edceb001227db",
"main.dart.js_254.part.js": "300dc4f501b3810ba35cbdc1570d975f",
"main.dart.js_288.part.js": "0342091c890187120e8101b59bff6f48",
"main.dart.js_208.part.js": "efa73be18f0e419535d92b9e8cb9a1a9",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_246.part.js": "de16556dae667a499ac7285e85b4c2d5",
"main.dart.js_284.part.js": "ee09ec62485423cb0ea4264a3d50ca6e",
"main.dart.js_187.part.js": "eb66c6f9da4cae7db470c53b5a30aff4",
"main.dart.js_214.part.js": "63939acb01cd642fe8b3a279cb685077",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_233.part.js": "729ff55a81306f9d89094a3c4e307a65",
"main.dart.js_267.part.js": "cf0149c4644a67f8d5d3ff1286b7e8ca",
"main.dart.js_248.part.js": "003a13328a8f050b3f2189f51ab01ab1",
"main.dart.js_262.part.js": "80e2c3edbaf3e989fdd0f4eacbb66e0d",
"main.dart.js_222.part.js": "baa8dc526096d2afaa25b44eef98ae49",
"main.dart.js_255.part.js": "b6f3281c1d9ba67a0fb1f607b69a1e3a",
"main.dart.js_247.part.js": "2aa42d86aa7c908a91d40e6da61138bb",
"main.dart.js_286.part.js": "8eec8c0e3c9e59672b5104a655e6adf7",
"main.dart.js_275.part.js": "910791de6e842bcbdd3b5b2c07ccdcc9",
"main.dart.js_282.part.js": "1d1a9def4b59fa2260193367555f50f4",
"main.dart.js_276.part.js": "5216600dbc84cde16a13b6fdfcc7875b",
"main.dart.js_14.part.js": "394951348062bbeed773e26b7f1ded58",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_269.part.js": "0813cbf0824a78c47c9f28af1da9f1f1",
"main.dart.js_236.part.js": "0ef0bb99d71e9ed1981a63d219691f93",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"flutter_bootstrap.js": "cf1523a1ef05d21ea6721e702ced745f",
"main.dart.js_235.part.js": "a85c004ba50bcd2b8518441dcca9ab9e",
"main.dart.js_264.part.js": "46eed811a541fc4f2f3ad8787119ce27",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_223.part.js": "3ecccdf875155a914bb5599908ae40d8",
"main.dart.js_285.part.js": "de955cb51dc9185f581f212b8ee37d0a",
"main.dart.js_224.part.js": "79077a76fa57e2debf5960a386dff620",
"main.dart.js_226.part.js": "622281d87ba02d962ab693d0dd70f694",
"main.dart.js_274.part.js": "a397e609e9294d581bb24565bd713d8f",
"main.dart.js_289.part.js": "70b57b589f7e12a3784364a0e06b7906",
"main.dart.js_280.part.js": "98df2bbd6b8e0fa9b511ce7cc96a0cc3",
"main.dart.js_231.part.js": "623ea83cde9aa276eb22052e56bdcd97",
"main.dart.js": "633f70a61f416355bfbd4a9b46f6d372",
"main.dart.js_2.part.js": "81a750809dd1fb2b074db9c419829e66",
"main.dart.js_273.part.js": "6e6f80cc0ad21701492c69cf94c5b169",
"main.dart.js_281.part.js": "94fa0de0ad93e69cacf96ef74e61ce2b",
"index.html": "3fc7d1b2225e36b33bdeee4671d90e0e",
"/": "3fc7d1b2225e36b33bdeee4671d90e0e",
"main.dart.js_271.part.js": "3be8b8d2104281f7926f66fd745465d1",
"main.dart.js_200.part.js": "b38e878b955193b388dee8b8b2fd93ab",
"main.dart.js_1.part.js": "2735a345866838ad601a62127f9720d8",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/MaterialIcons-Regular.otf": "56c8c0b2224c70b4ae11109ad3dc15b6",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
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
"main.dart.js_185.part.js": "4579f36060deed351ff7e0976cbaa518",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_242.part.js": "1a0f1b7d574ccd8900ab478e92ddb5a5",
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
