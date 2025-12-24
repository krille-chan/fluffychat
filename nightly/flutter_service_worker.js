'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "ae4a6c1f331786ad67acbe1a893a08bf",
"main.dart.js_271.part.js": "4ecfb0d7e084666a3f3fa2b772e6271b",
"main.dart.js_317.part.js": "147596e1d8b35c1824a68393d3148c2a",
"main.dart.js_1.part.js": "1cb2ca273059020c441a0e856ee68923",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_250.part.js": "fd37caaa512a3bef5c132e001e294075",
"main.dart.js_311.part.js": "0d1e15c9f5c4fa2a880aa405376aca36",
"main.dart.js_220.part.js": "98dfa830200a66742784292f4aea0b39",
"main.dart.js_318.part.js": "0c8dc6ae040ca27058d809a747bcb915",
"main.dart.js_214.part.js": "ed0c4b4f01c412813e48695b176e63be",
"main.dart.js_295.part.js": "1c93d232e8cad4b5839b32a03f7732ff",
"main.dart.js_316.part.js": "2b19ebfb78f1fdd1869392f24eb2c86a",
"index.html": "d1ac732995822ac14af152a617d1e300",
"/": "d1ac732995822ac14af152a617d1e300",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "0dec50556f116ebbcc0810ebb6c65fc7",
"main.dart.js_305.part.js": "edd62b5d7e70130d2de6902213e76f07",
"main.dart.js_244.part.js": "26e058d504616b659d72b1c4519337bf",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "bd1ff1db3cf76e398c431e5cd35b3dff",
"main.dart.js_265.part.js": "ed9d9a708ca29f00dbcb50b67501ccef",
"main.dart.js_261.part.js": "8fd8845f1087826095c14813590bede1",
"main.dart.js_262.part.js": "e1cb7e6a15dd5f0f2e51a581f52bd93a",
"main.dart.js_322.part.js": "bc744601e826b0cdd70afdc2a5454d3f",
"main.dart.js_263.part.js": "06d6dc8e3cc8b85eb2aea94b69a99275",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "c875b1a614fa14537d333675e526c7e7",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "bc150b9b8d8f0867d8737cb60aaa8db5",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3700a5c275c7c9762ebbba9c87509441",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/NOTICES": "e3942d4aef2a10490fb32abd34246436",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"main.dart.js_334.part.js": "94569936fc2dba21e8bea6c8071f15da",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_284.part.js": "79476c1bd3355953569c4c4721ad019f",
"main.dart.js_296.part.js": "cf0da59a8f6d770b219a7b263b5e4053",
"main.dart.js_278.part.js": "ebdd3ff6aecf0dfe7d32313550694078",
"main.dart.js_232.part.js": "a322e6dcb3d2db501db3b849e9ff6876",
"main.dart.js_333.part.js": "36397a83985cbec69e4969bc1e3b27db",
"main.dart.js_303.part.js": "82f2e9d843af0f273e23133450c412c1",
"main.dart.js_287.part.js": "428ad4511bfaf971e8bf3f9499bc7fa1",
"main.dart.js_212.part.js": "b6c5b96d57e23c30b44804915f15a661",
"main.dart.js_269.part.js": "d91165f41ec00e84d178459e426fe3f6",
"main.dart.js_313.part.js": "5150a95793779e539573556cf9b42201",
"main.dart.js_309.part.js": "5668d819ccc679de3aac1fb4694c284d",
"main.dart.js_312.part.js": "8728182f1622a5553fd7bd7e799d6dd4",
"main.dart.js_298.part.js": "081219f1fef2221da0632312897d21bd",
"main.dart.js_273.part.js": "61844a4e223c2dd5d1da8c566dc60160",
"main.dart.js_235.part.js": "62c6cf95a7b8cc14814adc1c4c9f5059",
"native_executor.js.deps": "3777817ddb1687147f834811f58eb9d7",
"main.dart.js_275.part.js": "ce1268ce039db5f0a6d64071faa2b9e2",
"main.dart.js_332.part.js": "0f234a19f7f8d10ac538206f52e986cd",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "ceac60a92011fdbe02fd55ede8d359e0",
"main.dart.js_279.part.js": "28d72fc4c2c7002784efdce3be2b0bcc",
"main.dart.js_253.part.js": "55d6c9361cd6745712f45ad5c517e770",
"main.dart.js_323.part.js": "4a5f565949079fe1cfe02da52f867e07",
"main.dart.js_335.part.js": "adce5e0f7a64f5dd20e0883da3f147d0",
"main.dart.js_324.part.js": "4b9f104958fa0d7dbf8bc95aa3b5eed0",
"main.dart.js_328.part.js": "64963b41eef3605c4b5f5ed6f5d03004",
"main.dart.js_289.part.js": "248b5b9ce96afc94a42d83f1ada4f7a8",
"flutter_bootstrap.js": "5912f195f1a444e6be4079766bfc5bbd",
"main.dart.js_315.part.js": "224f0a8dd307a90ffa0711597b342f2b",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "63c7313ea6636218eff1764870de6566",
"main.dart.js_326.part.js": "346aa33ee57b131dc145f631ad9d2bdf",
"main.dart.js_329.part.js": "b1eb46a81c7e1d133bcce8daeee60449",
"main.dart.js": "9b61a4de8aabf9fdd4cfb4f4fcf8bd06",
"main.dart.js_17.part.js": "9fe6fedf93e1fb7fc5d374274a2051f4",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51"};
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
