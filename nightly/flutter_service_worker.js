'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_244.part.js": "3cda6cff3fa3e4702a3f3308e1ff8a37",
"main.dart.js_254.part.js": "e67549da6ce119009294abcadf615ada",
"main.dart.js_245.part.js": "9c932b7cb97afec1b18d1a4bcb40b4ec",
"main.dart.js_285.part.js": "54bcbb26702e9faedf18deeb4f83943a",
"main.dart.js_251.part.js": "4d8dabdcd81e4b63939aa01f828d7f83",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_230.part.js": "56fda5f41e53d2192188f9f678d482b1",
"main.dart.js_283.part.js": "18544d03b4ca65e57b24b91c2814952c",
"main.dart.js_282.part.js": "59b6f9f905d68120743e9a7c999404f8",
"main.dart.js_239.part.js": "6a3d5bcc3dd2fb3b261f3c6d74acdbb5",
"main.dart.js_266.part.js": "2772476fe5e97987c69faa340528252b",
"main.dart.js_265.part.js": "71465a401e7d17e55ce8bf1cacd1055f",
"main.dart.js_273.part.js": "e2b0e4f75775236cbc52b4762ef34139",
"main.dart.js_259.part.js": "7881e5c672c3999bef55399552a8e8cf",
"main.dart.js_278.part.js": "e22a234967a3e07ace344e06dde919e2",
"main.dart.js": "9a351000cba7ec164b9e4cfcb4cda8cf",
"main.dart.js_232.part.js": "0972fc6290de1b1367d3a2f9cea06e9f",
"main.dart.js_196.part.js": "dc61b54c868c254d0e71c4ed26a625cf",
"main.dart.js_270.part.js": "d9793875cd22a4e6a96154f2c84448e2",
"main.dart.js_183.part.js": "c7e82b349e891b89c2c6e71936f658d7",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_228.part.js": "919083c23eee8184c69bd34a17745a5c",
"main.dart.js_219.part.js": "a33646022fc9d78f6b6cc80cecd1da55",
"assets/FontManifest.json": "f7fada60693e36e425e760c51ceb59a3",
"assets/AssetManifest.bin": "de0be742194cbe9b25a9890efbcb2467",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "658dc0657afef16e02dc425eabef1b65",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/NOTICES": "ad0bae227833957d26c4c04efb3df256",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "341b122113248d15c16dff08b1bd5047",
"assets/AssetManifest.bin.json": "a501696bd1e234d2a7b0f016d4994600",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_263.part.js": "486824d4812a788dd910ed7c2e4539b4",
"main.dart.js_220.part.js": "fbd1e76370dce4c16581c23237337672",
"main.dart.js_268.part.js": "b6f28844e2193b2220d3fc8ffa998c88",
"main.dart.js_198.part.js": "f5844db463b66cb425e80ff2ea968a83",
"main.dart.js_272.part.js": "e24bd8cb5f09c35b2ccb5ad2bd9b9b7b",
"index.html": "495ed9ecd502386b9a53002efed99428",
"/": "495ed9ecd502386b9a53002efed99428",
"main.dart.js_235.part.js": "41a5887f1807645f227886407a4b091e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"main.dart.js_286.part.js": "c08401e9d4f2326beed2c8752d2a09e1",
"main.dart.js_1.part.js": "1aa74129fe941b5af59336f795eec816",
"main.dart.js_211.part.js": "00504b5e3717348251d3fe406bc07933",
"main.dart.js_261.part.js": "d3edad86fda0205a2cec5960dff33d82",
"main.dart.js_281.part.js": "aff18e340eb34eb12dbcab05f84360a4",
"main.dart.js_221.part.js": "de349f9602e337fb192c871ad01901da",
"main.dart.js_206.part.js": "cd7d969b68d307e8d332734dd036ecdd",
"main.dart.js_234.part.js": "8873fcb929325f62532910c2c3aeb985",
"main.dart.js_2.part.js": "4a54c534cd77b2bda761fc11ac4e629c",
"main.dart.js_284.part.js": "68349db92352f8ee07a23f0739d302da",
"main.dart.js_238.part.js": "671d75907268a41be490ac56f3478a5d",
"main.dart.js_197.part.js": "4cbaeae15692a6f4b8fedaa4e327c4e5",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_243.part.js": "edd1e61c0a29c60a828c7b180cd2b6db",
"main.dart.js_185.part.js": "a42b4a4581875c959550d54d526e2560",
"main.dart.js_252.part.js": "111922f9eb1207d9dd98cbfb65c48e27",
"main.dart.js_233.part.js": "f56365b5428226968936a7c04f0d2b33",
"main.dart.js_279.part.js": "d24c401f3a4e9c031f924f612715f0f6",
"main.dart.js_267.part.js": "5ea16f1d7c18c0abe18e093695e08853",
"main.dart.js_277.part.js": "2dd33ad6f2f77539c24b54207ed8c884",
"main.dart.js_271.part.js": "3805a791818618a69935772cc485fec4",
"main.dart.js_223.part.js": "b5d0df74c0215bce9a92bb4dcd776107",
"main.dart.js_14.part.js": "bd702e05ed846000eb32ec49cbf716a6",
"version.json": "e9d913db2fdc769aa5e6581dd7fb3c9d",
"main.dart.js_264.part.js": "1aefe7f385ed449260e20e29f6869a06",
"flutter_bootstrap.js": "5b5e423babd68f1078b83074c0f953d0"};
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
