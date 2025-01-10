'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_280.part.js": "619179853cf29b64717501dfbf12d845",
"main.dart.js_275.part.js": "d53615ea021b8a2844eb130aa8506fd2",
"main.dart.js_257.part.js": "c4e033463531dbe0de27053fad6c47af",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/NOTICES": "ad0bae227833957d26c4c04efb3df256",
"assets/AssetManifest.json": "341b122113248d15c16dff08b1bd5047",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/MaterialIcons-Regular.otf": "9afeb8627ec2db3e8c103ba3fee8e83f",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "a501696bd1e234d2a7b0f016d4994600",
"main.dart.js_185.part.js": "21e5f4c1a7304e8bd40fa1a16ccabb9e",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_248.part.js": "9d76bc5b6fe092e722967affffd636a0",
"main.dart.js_255.part.js": "2b90c2a51a5696878402c77286f1cacc",
"main.dart.js_222.part.js": "2f2f2a642952f224153024b1ac34b25d",
"main.dart.js_208.part.js": "c5bdd8e58ed9aa77505660633eae490e",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"main.dart.js_287.part.js": "b8500ee23c511a70989854c806be11db",
"main.dart.js_273.part.js": "b00f3669b3047c10cf0b10a93e0e0025",
"main.dart.js_262.part.js": "770ac89125b1961db925e58aa2c1c229",
"main.dart.js_247.part.js": "62a079f6c0c03321f8c83e8f0971602b",
"main.dart.js_285.part.js": "5d44c509366d8f2fa3e35836a738cf30",
"main.dart.js_269.part.js": "aedc1e46993f7217acbaf8ae40ddb4d6",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_235.part.js": "e0cf5a4b157686daec8b112e26992bd9",
"main.dart.js_286.part.js": "7629200b6b73642eb9be4867583a9a9d",
"main.dart.js_223.part.js": "643d03beefe331894ad0d9ae3ff0d3b9",
"main.dart.js_238.part.js": "e8a72d19e41dca43ba08edd3815514e3",
"main.dart.js_2.part.js": "592b7682355010a6166e3d8e675136d4",
"main.dart.js_242.part.js": "1efe086a5df501e52c6257bf8225b419",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_198.part.js": "fded74aa4113cd071bef0cf292f8b61a",
"main.dart.js_276.part.js": "4b3dc33a388b35e0e5667bbb0197ae5f",
"main.dart.js_267.part.js": "760eb6e4524c65250b8794171478ea67",
"main.dart.js_214.part.js": "fd384b1d72f793444cb3f6dbda29a501",
"main.dart.js_266.part.js": "dbb1f78e3b1204fa9f4306b1fac51608",
"main.dart.js_199.part.js": "455a61c84f982f45d1f631f90b3bc64a",
"index.html": "bb5e48fc0c31e87f81748d25d5267a4f",
"/": "bb5e48fc0c31e87f81748d25d5267a4f",
"main.dart.js_284.part.js": "f4229b8aa02ec54ca688c6c0104c40a4",
"main.dart.js_187.part.js": "ca086dc44af5af79ae5b2237de1dc8a2",
"main.dart.js_1.part.js": "da1157b4c211a4988b70fdf605555ce3",
"main.dart.js_14.part.js": "88fbbe753ae16621d6d3a8342fff9dc3",
"main.dart.js_237.part.js": "9b4da7889a5802cca11fe7f8f0868c67",
"main.dart.js_268.part.js": "e43161b8d554ba807f4f57579b7719a7",
"main.dart.js_282.part.js": "b0b023194ec3c9f62d01a55591fcc1d6",
"main.dart.js_254.part.js": "74f3ff2acf453fa873ecaeb4f544ee97",
"main.dart.js_231.part.js": "9a4e39f68e6b284e894f69545ab5cf88",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_270.part.js": "cfe2f4d0f40995d2f97d0bdd715a8a7f",
"main.dart.js_246.part.js": "716e25374928db40dfe7cafcf6f55dac",
"main.dart.js_264.part.js": "4d92a73279aa64adbd6a98ccfe76b661",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_241.part.js": "69de1b3a5d4f9eb631a4972542604b0c",
"main.dart.js_236.part.js": "b4ee028da94dd696d3e2b63dfa685667",
"main.dart.js_233.part.js": "58aae2122e43430df188526a4af80be8",
"main.dart.js_271.part.js": "3eef7e10ef5d79602fb95705eff12bc8",
"main.dart.js_200.part.js": "390cc42c98b45c1ff94f5cce7f3c05a1",
"main.dart.js_288.part.js": "a366ee25179236dbe4b17d6b7c70dd98",
"flutter_bootstrap.js": "4174d944dd6b7353f169aa2bcb31e95c",
"main.dart.js_224.part.js": "8039e9fb073d9373d0bc9af6bcb82d56",
"main.dart.js": "9047d59f9e90916c1306dea9dd21449f",
"main.dart.js_226.part.js": "40dd11d107a692bcc729cb187d986bfe",
"main.dart.js_274.part.js": "6bba647b48ecf67f8951a31b80a6cb8d",
"main.dart.js_289.part.js": "8b36c5f62877fcb9a8ab23221de6e392",
"main.dart.js_281.part.js": "34b0522e8dcfc0d75ea204ef3f43ee95"};
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
