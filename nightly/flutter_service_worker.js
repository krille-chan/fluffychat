'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "02f15856142f3502b60444f62761ab4d",
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
"main.dart.js_202.part.js": "ee738bc7fa8a786e26b2203c9af472c3",
"main.dart.js_271.part.js": "5f1777eba13effb9015609fc023ee0b1",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_236.part.js": "68c30aaccb818e55fd9a9450d5d651aa",
"main.dart.js_229.part.js": "05c13126c422515d496dcee3aff14a45",
"main.dart.js_258.part.js": "ad71531fa20cb2f483b3e1c9745830bc",
"main.dart.js_291.part.js": "3b18302fdec831ded4319e105004f957",
"index.html": "1b8dda7fbb3a4a50cbcdf88fb5482b29",
"/": "1b8dda7fbb3a4a50cbcdf88fb5482b29",
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
"main.dart.js_249.part.js": "6bde698be6d3017975026d28dad6ea8c",
"main.dart.js_276.part.js": "38652f466a136396b86eb61e94e53143",
"main.dart.js_260.part.js": "8eeb1f86fd101289232679f30d44168b",
"main.dart.js_240.part.js": "9d41aec9602916d5c62fe2c8d3faab25",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "dc593d0f3a82cf0af4211b3c607c92b9",
"main.dart.js_269.part.js": "fa2b1478cf33e643b3fdfe3549881057",
"main.dart.js_277.part.js": "9371f1dfa9b60f6b808b45d05d1403fd",
"main.dart.js_273.part.js": "cbf30720caad2f3154594c71489a608d",
"main.dart.js_187.part.js": "bd9dd296cf95e4557b5ec915d9252a98",
"main.dart.js_265.part.js": "ea8a95cc360f19bbeb00c93226d38b76",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_279.part.js": "aaa47a4b2d82308665544844c1b77fca",
"main.dart.js": "2e569d4c66209b793b2a075ab2392904",
"main.dart.js_2.part.js": "7a175b27dbcee6df77e7eb63eea20eb6",
"main.dart.js_278.part.js": "58e55d7eecaa4723d1f36ce385ecd07f",
"main.dart.js_292.part.js": "62d269dedfd36798bc5fcfb646edbd55",
"main.dart.js_244.part.js": "98fd3fd60b8b004232266a83408062f4",
"main.dart.js_238.part.js": "84bc84bc58f3300e3985801e82ee08a2",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_245.part.js": "f9103ab055041adfb7464ea9e63e8619",
"main.dart.js_225.part.js": "e48ff749ba0e42b38ffe1b0b0b550f77",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_288.part.js": "de510578abb569d2229b00b73f455109",
"main.dart.js_241.part.js": "40a82a942db4da86e5c456650fd798d9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_234.part.js": "481bd8512520215e9f164374cccfda79",
"main.dart.js_200.part.js": "c4da722273afb5dcfe79070285bf3a84",
"main.dart.js_287.part.js": "fa1b2b3a5d1d56b28511cd8b7a7f7208",
"main.dart.js_189.part.js": "de43890deb93f7bf35f1dfe5ecb1823c",
"main.dart.js_257.part.js": "81df9fea8f38437629af70c9973afe68",
"main.dart.js_227.part.js": "47ab2138274440b21c9001f23abdae49",
"main.dart.js_211.part.js": "aa5758a7a64df07b40da6d8be241ec85",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "f150d39db8986bab4b1795bb73fc3299",
"main.dart.js_274.part.js": "966326cd7c69b0d33adcd2765b47936f",
"main.dart.js_239.part.js": "acc09fa7dd33bdb825bfbf874953be6b",
"main.dart.js_289.part.js": "34fd57e25c27da38d32cc45125727b80",
"main.dart.js_284.part.js": "f006c09bba40ad8d70293c8a4a56663e",
"main.dart.js_290.part.js": "c0adb7416995a29b49897bd570fde1bb",
"main.dart.js_217.part.js": "d26dbbf757aef900e2dc818b870fd60d",
"main.dart.js_251.part.js": "40f2c740063f8f6446d5b261bbefab77",
"main.dart.js_250.part.js": "df560bae6ce6d87a78bd4c0d76590896",
"main.dart.js_272.part.js": "dd3294444b0835f06f56d8531c1a725b",
"main.dart.js_267.part.js": "a3782415f1727e5da99b6efd2e6d9441",
"main.dart.js_201.part.js": "4cd71c194290ce28cd54e0903f654d7f",
"main.dart.js_1.part.js": "7e3bf5a3c1ef1573e793ae72b8fa823c",
"flutter_bootstrap.js": "633e622fb6780b6735b4df641029ea9e",
"main.dart.js_15.part.js": "239c4bdf7495817449a7bf52750cd39c",
"main.dart.js_226.part.js": "7dbddc0191d77fab40cb13f0571af8ea"};
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
