'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "0da7eb3de70ff439162f6967582ce14d",
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
"main.dart.js_202.part.js": "0c6a0755e0d5cf82565b58313245f4c3",
"main.dart.js_271.part.js": "4eb1c81ee64840d900130ee9b743f094",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_236.part.js": "42dd78416d6e87257fee3120784a8a13",
"main.dart.js_229.part.js": "62d01255162a626ea465b0c3bd251f84",
"main.dart.js_258.part.js": "668f96820d6e2a51d1109ca488e96fc1",
"main.dart.js_291.part.js": "bac91492ee26def0b4f90953974ca2c3",
"index.html": "39ad67dfc37953a5616a5b74a531e5f8",
"/": "39ad67dfc37953a5616a5b74a531e5f8",
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
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/fonts/MaterialIcons-Regular.otf": "f71ad44beb99d3b525ae88ca96857d6b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_249.part.js": "f3347be979be458a071a663fda23d8bb",
"main.dart.js_276.part.js": "7e2f8130a5cd45ce68d8f718e0a82c41",
"main.dart.js_260.part.js": "a246da735ccd7612850e92e18e41ab2e",
"main.dart.js_240.part.js": "f9f9517326dc8a91c476d247edfd30a9",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "15ef652e1cb61d74f29d107486a77cb9",
"main.dart.js_269.part.js": "eed55075836e967b5ed27ca348a88c50",
"main.dart.js_277.part.js": "347c1a42d62f921a966a3e95f565e672",
"main.dart.js_273.part.js": "db68fb037b6168e1af18fa37c550f31d",
"main.dart.js_187.part.js": "8dc3971d9e89a8af59b4da287cd072b3",
"main.dart.js_265.part.js": "91dd2bc30f4b3c9a3cc80a2768cb80a2",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_279.part.js": "274596d4a8791a1e78b9375330a680f3",
"main.dart.js": "707cae420be37b121b7815a41d0cf107",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"main.dart.js_278.part.js": "261042f767699f95c0796a274acd10ae",
"main.dart.js_292.part.js": "d27f037b7e67ce824e20a75fe03df2ed",
"main.dart.js_244.part.js": "2b29e2e7e05fb44bf1d37c69bfc669db",
"main.dart.js_238.part.js": "a6a9209ddf66ed75a043646b45c9d863",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_245.part.js": "564d89f0daa19fafc12f30c362e9667d",
"main.dart.js_225.part.js": "8e897a6cbfa32998502f97b952146d4b",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_288.part.js": "8e7437b90d61c57f244793a9a0befcf7",
"main.dart.js_241.part.js": "58e1ca7a85c7e87c3f96ea44725e558b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_234.part.js": "5600849028b0aef179448dab039196c2",
"main.dart.js_200.part.js": "615fbab57f5d24bc7b52a8701158df3c",
"main.dart.js_287.part.js": "52e313adcee5c400a5456f7ba57e9c7d",
"main.dart.js_189.part.js": "276edefcf45267594e233466e99397cb",
"main.dart.js_257.part.js": "a810b17b84edc4ed79cdf085cf400d00",
"main.dart.js_227.part.js": "54af4b0498490587ce93b069eb378857",
"main.dart.js_211.part.js": "4ff2f01d6ed69a2abf5b7af10c574565",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "1cdfedf95c54dbdef0a690859ee8ff32",
"main.dart.js_274.part.js": "924325ef2ea0db5975b4ee1e0c3a77ca",
"main.dart.js_239.part.js": "83818e8ab8b0ed708b9da40cd380dc29",
"main.dart.js_289.part.js": "6e6c3803f8fe6f2d79cfdaceb6c304f1",
"main.dart.js_284.part.js": "2df702a9435183f04db6be854f98da0b",
"main.dart.js_290.part.js": "72dd303560b44a806b4772af390ab95e",
"main.dart.js_217.part.js": "59640c47a86462aac65d70769c5cf275",
"main.dart.js_251.part.js": "1afa23934463ff6085ee04ada388a370",
"main.dart.js_250.part.js": "d53723be4cf52d1503a8c67a7ead7d04",
"main.dart.js_272.part.js": "9357a1a998ab4b7c194ed7efb1656b3a",
"main.dart.js_267.part.js": "f32610ba8e3cafb5256b8bf5aae2b9b4",
"main.dart.js_201.part.js": "867cc4db7d1abc8baecc418dbaed6919",
"main.dart.js_1.part.js": "3b2cf720d894560c7d0415902bacef10",
"flutter_bootstrap.js": "e7ddc6e94201729166ac2964a2ed7b78",
"main.dart.js_15.part.js": "ce551911cfc912be44689b93c89a91fd",
"main.dart.js_226.part.js": "b00e97c802bd846623f9efe82f4c7437"};
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
