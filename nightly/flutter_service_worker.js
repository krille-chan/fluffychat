'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "f90c1ac69febbba0f80119eba9a2e646",
"main.dart.js_223.part.js": "8a640de3aafaa82283bdb55c72a8f147",
"main.dart.js_304.part.js": "ca0c90c98aed2af9801bdcd78dac9edb",
"main.dart.js_256.part.js": "84c20976d3d36de2801f7f1d00488931",
"main.dart.js_325.part.js": "dbe2db3702f10739a90e627504b17934",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "3c5cfeed6dec49a32508bd091165cbdc",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d92e51df31903f5057bf42069a909609",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "f19d4c101ca549cea1b8afef6030a4e2",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_295.part.js": "b22ddcf1ab513d7990f9b99b9f7f20e9",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "a925841b749ff514aeac6ccd436a44aa",
"main.dart.js_302.part.js": "9912d5f51a02a873a666a66b55701ef1",
"main.dart.js_215.part.js": "05ec7be44a9c62920fba04c946e51068",
"main.dart.js_244.part.js": "37da98d308e97ba2370908f07b02e5c5",
"main.dart.js_320.part.js": "2a7f0bfae896c62ce074e86233198330",
"main.dart.js_321.part.js": "cdd20c8857f9c8eb9be41217181f628a",
"main.dart.js_255.part.js": "68b26c53d414d6ce2173f589608a1464",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_315.part.js": "20c9470e58c2a49824b5b295f801ba84",
"main.dart.js_300.part.js": "e02c119bad69a74df50aa1673f91a4a3",
"main.dart.js_309.part.js": "4454c93da25c80c73bb12f25de943b9b",
"main.dart.js_270.part.js": "308b2b91feb92d1a53e6ed4746e1561d",
"main.dart.js_259.part.js": "568ab249fb5802d9884d147e04bddc7b",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "d063a22ea372be7981889f7a8e98d3ad",
"main.dart.js_227.part.js": "b6d62f229b7cccdbd2af82cad0eb647a",
"main.dart.js_279.part.js": "bd727250ba5f1ddff9c7fb52d1485959",
"main.dart.js_305.part.js": "def29c0499307702dfbf5f9562ae6848",
"flutter_bootstrap.js": "43d91f6a9f9ab4c43bcbb2f17b2b817e",
"main.dart.js_267.part.js": "4c31e7e157142baaa874ce495380eeab",
"main.dart.js_319.part.js": "711d78507f4e327c196263d8b44eb645",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_290.part.js": "9171074ab2e8c07b66a60a0d949ab7f3",
"main.dart.js_323.part.js": "7e3abb4d78a1b52d05360b590cdc5835",
"main.dart.js_2.part.js": "387a8528bf9294a2da159f2161b05b1f",
"main.dart.js_308.part.js": "70d1d26540628bc3bd238c88f67902a5",
"main.dart.js_324.part.js": "7f9de775afcc489332b50fcd050e4f81",
"main.dart.js_230.part.js": "6114b6cf13faad5918679e9b7e15c0cf",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "119b3baba4839952ea6652cec4746527",
"/": "119b3baba4839952ea6652cec4746527",
"main.dart.js_281.part.js": "dbf337b38dfa4c8ba6b2bd490571cf68",
"main.dart.js_301.part.js": "92c852f0fc9a666d21b403293dbf2733",
"main.dart.js_297.part.js": "67ee66a60f8895e335a3c1592f8c77c6",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_212.part.js": "ecf6a2a7bfa4fc0d252298f3f6e87e2f",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_275.part.js": "2143f3c1c62f6ec146799f36ca6546a2",
"main.dart.js_307.part.js": "fc72e6c53b34eb2e8250710f6e0183bc",
"main.dart.js_269.part.js": "72d90f38b0cc8eb0117cda156dd9c101",
"main.dart.js_263.part.js": "cb88ba8522fc70b93e8a967804dbf81e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_287.part.js": "3b68a0629d438c18e4fd0d445376d0ac",
"main.dart.js_303.part.js": "f2dde6796e4b93969d5a7b9b622d0c27",
"main.dart.js_247.part.js": "53a0e8d294b8f44943cf8181f9f7bd90",
"main.dart.js_1.part.js": "1fbaf53743750bb18cf3b04e48b4d420",
"main.dart.js_271.part.js": "ed7fab92e6294d24a663e41cb1add10b",
"main.dart.js_318.part.js": "a2ecd47fd02237cb10fa56bbbfc64e8e",
"main.dart.js_310.part.js": "90311814ad1c084cbe627f98048677ef",
"main.dart.js_265.part.js": "c6af98bd30f7e1f8a3a160e3aa80acda",
"main.dart.js_314.part.js": "fc62dbd04bea32ef896992d822959c16",
"main.dart.js_238.part.js": "a8fd32a90ac6b6f49b3e5f3665349a01",
"main.dart.js_276.part.js": "60165d692657d24dc22fcb8c66b0f45d",
"main.dart.js_316.part.js": "d9690ba452172678d57932bf44873bd1",
"main.dart.js": "4a24da33c2df6dbc39addfa636cf379b",
"main.dart.js_280.part.js": "020f187e6e4d3946e117d2b29667a371",
"main.dart.js_257.part.js": "d91f47d9327a0c6b4e3bdfbc87dc929a"};
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
