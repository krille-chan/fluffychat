'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_322.part.js": "24e81cb825ad4397cd3fa87c753f9565",
"main.dart.js_312.part.js": "6345d4365357d8cb47e233e5133625fe",
"main.dart.js_268.part.js": "2a865b3cb11d0679bebe8b58c954ae0c",
"main.dart.js_273.part.js": "708b1f00c0c999242fbc48b3bdfe2c62",
"main.dart.js_293.part.js": "e00c4c7d2b154d61be006735006376c5",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "29f79ca1c2710f90f4a7f59064f3e111",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d92e51df31903f5057bf42069a909609",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/NOTICES": "8631d50448c60d1db2d63a01709b8106",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"main.dart.js_295.part.js": "ffc287996e2a0c147eaf194b02d39812",
"main.dart.js_245.part.js": "c6cea32332b50cda221355adfcdf0d63",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_288.part.js": "55a242d8ea431f6027b375ef47aec022",
"main.dart.js_302.part.js": "9f0184f362b277712ee652b07a99d81a",
"main.dart.js_320.part.js": "bc399e63d91c1f5fba5a344c0519d18f",
"main.dart.js_321.part.js": "4ad46cf3c45b7e81c63157159e198ce6",
"main.dart.js_255.part.js": "b576ee5a0ab83541131b5a681a269f69",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"main.dart.js_300.part.js": "bc384656e31f5a4d1f1615bb09d8986a",
"main.dart.js_228.part.js": "bde6cc7d3b4669ea4af86951ae1c104b",
"main.dart.js_298.part.js": "01fc33bf5390175eaea9ffbe78241a7d",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_16.part.js": "dfe97a9c503c9204c1282325b5583055",
"main.dart.js_277.part.js": "46f0e5215f649dae2d03c421ee5dc43b",
"main.dart.js_227.part.js": "32541dbae92d487682e2f61e8657f22d",
"main.dart.js_254.part.js": "e30f6b06fe1736f88cb6fc8c0011d017",
"main.dart.js_279.part.js": "83363d23eee38ab616661e8252e424e2",
"main.dart.js_305.part.js": "029565c4ea2a48ae9abd5c0e185f85cf",
"flutter_bootstrap.js": "2a0ef8d69b8b8dcc43da3b1e3e21c5cc",
"main.dart.js_267.part.js": "76a687cdd330571bbdba41e68cf80c61",
"main.dart.js_319.part.js": "5d38c1ee0baef1b5ee083cc6ffed55e1",
"main.dart.js_213.part.js": "bd875b8dbfe5f7c122c6a11af51463cd",
"main.dart.js_236.part.js": "4066a4744b90718788df5b9462793334",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_210.part.js": "5579e15dba88e338143652563e4ecec9",
"main.dart.js_323.part.js": "3dfcb66615eba73318e5d2eeac65eb9f",
"main.dart.js_2.part.js": "24f1b14e014a37ba7110a75212c1563f",
"main.dart.js_308.part.js": "d12a8e880e28011739e818c959cc3a9a",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "81f1f3a8780906f6a0cc25e5551669bb",
"/": "81f1f3a8780906f6a0cc25e5551669bb",
"main.dart.js_299.part.js": "98ad8124308b3cfdf28a0c8364ad71af",
"main.dart.js_242.part.js": "234d1c88b0f467cb915dbe2c7029c7d7",
"main.dart.js_301.part.js": "5bffb373e83c5d937f7587eece5c2f1c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_306.part.js": "e2ec35a86f73a34757761e6b8d5f3e93",
"main.dart.js_317.part.js": "187da98b610245ce71150bc72e3614cc",
"main.dart.js_286.part.js": "785bcfc477c0e843b9fe985ba53d4e7c",
"main.dart.js_307.part.js": "5d92ec89236120b2ce58a25b870278c8",
"main.dart.js_269.part.js": "89cbea2ef0f3f18f5e56b8fe90855ebd",
"main.dart.js_263.part.js": "1620e3def337051c8ae7e10d47f15b1a",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_253.part.js": "7b9beb7a3619c1c656a3055ff60740f3",
"main.dart.js_226.part.js": "bacb9c27e6c3a606595cdd4bfeb4828f",
"main.dart.js_261.part.js": "9080f777b85637a4421fc1bc8c87d505",
"main.dart.js_303.part.js": "75b35703d4d8630f8319cafb16b66c75",
"main.dart.js_1.part.js": "fa02a70601d93f9c15aad963c708c790",
"main.dart.js_285.part.js": "25f9372a842d707fe0c8e2fd5c05f43e",
"main.dart.js_313.part.js": "f8e1f305bfbbc2be21443b98ee1157a8",
"main.dart.js_318.part.js": "bb310c85cba117632b51d70552cf50b0",
"main.dart.js_265.part.js": "cfda7023dae17192ad834f5881ab84f7",
"main.dart.js_314.part.js": "439ffbf3e109101f10b66a31ceb09904",
"main.dart.js_274.part.js": "7788dca1c7996a0ae20f01457c24b068",
"main.dart.js_316.part.js": "cab03fda3a8f119d6042b0b37a7b8b74",
"main.dart.js_278.part.js": "4b42f152c101a3fd74287b2c06e8194a",
"main.dart.js": "804d87b48f74dc92afcc9bdd114b9f90",
"main.dart.js_257.part.js": "0431ea60baca0045dac12c5fb10a9a66"};
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
