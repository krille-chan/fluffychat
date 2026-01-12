'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "a9953c6df941da3fde31d123fcd3f4d1",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "19736869cea02a7a3faf5fff42fdfca3",
"main.dart.js_271.part.js": "1b41476f5cdbe3573fca4ec5f3f3384c",
"main.dart.js_259.part.js": "fe6fc971b1c678b1c555c91d3bfb8dbe",
"main.dart.js_297.part.js": "5fa16b508f95ab96da5e3f6553144f3e",
"main.dart.js_1.part.js": "f45010ccd63de73ab6dcc60870f44ea0",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_274.part.js": "9f90d22d6a0063b71ba7463171f93724",
"main.dart.js_318.part.js": "8e7dcc8ac5d4d5092a7ebf462284ad22",
"main.dart.js_338.part.js": "092bcb77340ff4de535c5cb85a451fe2",
"index.html": "f857f561b776291c607054afedefa5a6",
"/": "f857f561b776291c607054afedefa5a6",
"main.dart.js_18.part.js": "5b92f80593ac905de077869aa425ea72",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "54566d8581fe7fd3f2865c7cf3d3c8d0",
"main.dart.js_305.part.js": "c95f43a025628f38cf1a98d2cb0840bb",
"main.dart.js_244.part.js": "3a94fafe80780a23e0740fc8914cac49",
"main.dart.js_345.part.js": "72ebb4506e69cd31dcd56aa927d71ff6",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "ccd7cc572fc2751fed1476a0945a1874",
"main.dart.js_294.part.js": "60b5512a7b11a87508c6dce06b6203b9",
"main.dart.js_262.part.js": "e2eae8229a8ec503a62d02fba8188139",
"main.dart.js_344.part.js": "d0e87a16a36825952450e223c7f4af31",
"main.dart.js_299.part.js": "dd111f92ce121d928676971b5c3893a7",
"main.dart.js_322.part.js": "0363edb1cdbbccc4d658d65bd0f75115",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "0ee89d5718ca3530c1babe183ce69004",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "07536c14357c4228a74bac89f6ed75f2",
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
"main.dart.js_334.part.js": "7d0b0b6a8c51b47bac8c31eb7515e8c0",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "65a861b8f1c9f87fec925180de1bfd27",
"main.dart.js_229.part.js": "c4169d610487b4e54f937776836c0a38",
"main.dart.js_336.part.js": "6b187073bf27818986293eacb3d1d830",
"main.dart.js_333.part.js": "0a895ef0f40779ff3b139e9e71b6387a",
"main.dart.js_340.part.js": "7ae808b5332186114ba5b9487a8d4749",
"main.dart.js_313.part.js": "1335e1a5b43c26a69249ee8787c264d5",
"main.dart.js_325.part.js": "2871319832a4f4e840d55901c74266f1",
"main.dart.js_298.part.js": "042254f1ec9b43ee028e81fe611df8af",
"main.dart.js_285.part.js": "219bbc0c3de0e505d4ec9a12faf9fff4",
"main.dart.js_270.part.js": "22e78e194e9759355b117a3377fbe43a",
"main.dart.js_321.part.js": "96a17c94bc7de957875bd979701ab5d9",
"native_executor.js.deps": "3777817ddb1687147f834811f58eb9d7",
"main.dart.js_281.part.js": "99c941abba83f89774605a76e61bcf75",
"main.dart.js_332.part.js": "f01666348d835d64b815a0792fc49959",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "f5e67931420a246b280ae09be208242b",
"main.dart.js_342.part.js": "0569175aa42107d7f12ff53c6693415f",
"main.dart.js_279.part.js": "77903581e4ba5ae77bd92c04e0bfad0b",
"main.dart.js_319.part.js": "0947a5ac92c8b6df599c418372ff6c3a",
"main.dart.js_343.part.js": "d5b1f9db9ec62f239a6fbe0654268ef7",
"main.dart.js_253.part.js": "be22b52444516709295c3b6baba6708b",
"main.dart.js_323.part.js": "09bbba3e8ba59f088465289c63a248d7",
"main.dart.js_328.part.js": "325962285185536630ebf02bddc39198",
"main.dart.js_289.part.js": "d6ea55811006ba68378e276acbb2b8de",
"main.dart.js_337.part.js": "a506d5f31b20a7a18048a472c08ff19f",
"flutter_bootstrap.js": "f2e9ae2005a3a5c903020bb9524758c6",
"main.dart.js_315.part.js": "b5bf0e2c7e24844a946d5b65266b9f6d",
"main.dart.js_306.part.js": "564b6372fa8709942fb9dc1ceaab346c",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_293.part.js": "ad2b4a2e39f2c250b84860d3eec8ef46",
"main.dart.js_221.part.js": "8c03716bf7e2fa969aaaff83f0fe914f",
"main.dart.js_326.part.js": "367e07b29e7840d3c4bcf622a661834c",
"main.dart.js": "7f38500f9134b628ecc1d005d9eda42c",
"main.dart.js_272.part.js": "d5c884616785f46078fb0f104ee9bd3f",
"main.dart.js_223.part.js": "b46efd70abfe4ca414572bc4e86710e5",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_236.part.js": "533fd5fc299700c17eb3739465760246"};
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
