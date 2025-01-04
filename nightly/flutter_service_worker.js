'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_289.part.js": "4a4f6d0d1480054d15999dadeb748d19",
"main.dart.js_254.part.js": "e0598915616ac95b72bc269a80600c40",
"main.dart.js_285.part.js": "2c027ed85b0f5efbdc2f8890d9bc1fc1",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_287.part.js": "26097b547f0bfb8c54bedc430386e1bb",
"main.dart.js_282.part.js": "9fac0f5cc943329aa94a9559924ddd3c",
"main.dart.js_246.part.js": "1ff6ac0ab99b06719ed828558e2fb11d",
"main.dart.js_266.part.js": "7e2eb25e896bc0056f10d1d3b72d0076",
"main.dart.js_274.part.js": "68a7d41ff94030e07d52e5bede1fd6b6",
"main.dart.js_200.part.js": "9d3482862a97e3f6b366d9e659033702",
"main.dart.js_208.part.js": "b9786efb25cdc26bf3dec511440fa45f",
"main.dart.js_273.part.js": "13a80daea21ac4d1a3d08f48c1832bac",
"main.dart.js": "bdeb0974d0f7c861dbb1cdebc8a54632",
"main.dart.js_222.part.js": "fbe14d59bdc26bdf10cb1f5235330e51",
"main.dart.js_270.part.js": "31214dd07f7af2469ecf19625403d3b9",
"main.dart.js_275.part.js": "300fa408b20faabdef2e098a7fc1cb61",
"main.dart.js_269.part.js": "b766720cbac1799e41e9e9c2ea6dd757",
"main.dart.js_247.part.js": "f4047c82f945dbb4c72f0b987fc7d664",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
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
"main.dart.js_288.part.js": "357affc0d20980ceaa37144b1260dfcc",
"main.dart.js_241.part.js": "ec52492dc5e955677001c1f70054eb6d",
"main.dart.js_268.part.js": "4a2a8e55cb529adf8da97ad8117bd4a6",
"main.dart.js_198.part.js": "ff46ff9fbdb1d215b747c7ae091f666c",
"main.dart.js_280.part.js": "8c7f980f2e9d8c213beac5b38bbeab00",
"main.dart.js_242.part.js": "01edeab4a3bff8527175d2cf49c5a4a8",
"index.html": "b8b4e75e588b891ea657f7a64b86f277",
"/": "b8b4e75e588b891ea657f7a64b86f277",
"main.dart.js_235.part.js": "f55794278cb7ccafb35b7e9820426972",
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
"main.dart.js_286.part.js": "cac4a4f28faabbebbf5f5b30e80e8d41",
"main.dart.js_262.part.js": "d7d0fff999b901b8da562cc791892689",
"main.dart.js_214.part.js": "a30ca0767a91ed09858cd5d26ce1b2a0",
"main.dart.js_1.part.js": "9956265785e7039fa54ba824c2b949dd",
"main.dart.js_281.part.js": "a67ec4815d11f33f8b3b442fcf139f07",
"main.dart.js_276.part.js": "7a13f6213b5c63536948253c5736c5d9",
"main.dart.js_237.part.js": "654795cb2e8055376e024d3bccc98a9f",
"main.dart.js_231.part.js": "b060da148c4c84a3d2c8a89a2742bc57",
"main.dart.js_2.part.js": "4a54c534cd77b2bda761fc11ac4e629c",
"main.dart.js_284.part.js": "b17f362487c06eaca0cc6a5dff48f31b",
"main.dart.js_255.part.js": "12d475284a8da5ef6442cb7fabcb00ed",
"main.dart.js_257.part.js": "d0c570444b6c51d838b574d8231ebe78",
"main.dart.js_199.part.js": "04bc7ec1d701bb0a33b8745c91c911f9",
"main.dart.js_238.part.js": "ee00460971fcd5c6eae6947ccd3abd52",
"main.dart.js_248.part.js": "f016b9a22c4dc6283afc013d766d187f",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_185.part.js": "1c7880b4dd6a2be4a3de7ec79394ada2",
"main.dart.js_233.part.js": "ce592d2c5ab79cfb4ed4625ebdd46961",
"main.dart.js_267.part.js": "b4113e203c99a13d4e053afe5cc6871c",
"main.dart.js_271.part.js": "d5426dd04b969fc6c53777832d42e9aa",
"main.dart.js_236.part.js": "8f3e1a3af4feff00c834b9a13f41ff5f",
"main.dart.js_224.part.js": "ce1ca3acccf168df9c70eebb70b68ffc",
"main.dart.js_223.part.js": "db52a71def1eca878f25b025dcba0171",
"main.dart.js_226.part.js": "4c511c90483b2860d8c97244fd939c05",
"main.dart.js_14.part.js": "187f85d5a391c99921417111eea75f16",
"main.dart.js_187.part.js": "f258aad98e4647b2e0f262f151f0dd9e",
"version.json": "8edb4a10da08d1d0f56fa9aa2dba5d2c",
"main.dart.js_264.part.js": "38035ff288df64b6dcd129f784ec7c3a",
"flutter_bootstrap.js": "54e4d24020320c81c559a81801bee8a6"};
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
