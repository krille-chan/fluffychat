'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "423d95cff8c8b37df5589c87ce19be80",
"main.dart.js_308.part.js": "8920df1e1b660e9c1a0bed97f62b4d6f",
"main.dart.js_271.part.js": "95dd68883252da991c46e3dd42916ae5",
"main.dart.js_259.part.js": "a9f0e7a558e910abe15db06dad683197",
"main.dart.js_1.part.js": "d5142f2bacac625268f43915907d09fb",
"main.dart.js_260.part.js": "d8b3d4a4c51ecd28844397e19f6a9284",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "3e87b1246af60b23b24f8999668cea4a",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_316.part.js": "fa3c5fe4b4899033aae9288b1f116f39",
"index.html": "636aa1bf892b05b0923b05d784256f87",
"/": "636aa1bf892b05b0923b05d784256f87",
"main.dart.js_251.part.js": "d161a9f3d2f4c405626ac7a366163939",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "f0c3f7cf198dfe325cba868f67bdf8a6",
"main.dart.js_242.part.js": "c3bd2333ebf979f0af7a5ac4e7db8223",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_294.part.js": "6070e6218e6c0526337141c2c8f4c4b6",
"main.dart.js_261.part.js": "9c181512c4bfd97786b81bba7932f8f1",
"main.dart.js_322.part.js": "77b9249ede79f9c2975b9498bd301e34",
"main.dart.js_263.part.js": "740c62b68f37b899883e60c51adf4d57",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "29def204c73ba4d51b49c1f5aadfbc90",
"main.dart.js_301.part.js": "0696b847e54b7e3afae924a5f3d0943a",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c6f1ec92f19e95e46ba5cebc1001bc22",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "8e8be03fbfe8ef5eecf9d2dfcc14c2c1",
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
"assets/NOTICES": "c331fabcfaf52ff613895258d86576f1",
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
"main.dart.js_210.part.js": "9e69d79f4a58d581a1b7dbe0abcd3314",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "c3e9ff409a36fba487032e43139b35ed",
"main.dart.js_296.part.js": "38322edd4b7e83c618d345dc9e96670a",
"main.dart.js_286.part.js": "1100a8bb56594056b4f0891e727b0af2",
"main.dart.js_333.part.js": "28c6d18443851021f94992ed0cb5fb5d",
"main.dart.js_303.part.js": "4e876945cb62338c3948865ac3f48f5d",
"main.dart.js_287.part.js": "0af3b7f562760f96d012abf5112de411",
"main.dart.js_331.part.js": "42fbd2a77f0f79b65275587fb19adf12",
"main.dart.js_212.part.js": "c54465a277c845b071e6fec6ada63e4d",
"main.dart.js_269.part.js": "0b51cbfd68fae71560f23b6f8dda4138",
"main.dart.js_267.part.js": "1aa571f8d6b1ed793e66168d36e1604a",
"main.dart.js_313.part.js": "a0623833961788457a07c82476c59b07",
"main.dart.js_309.part.js": "f7b7b39587206dcbea72fcfad4e38a3e",
"main.dart.js_325.part.js": "9a0202e529e18b61ec60d74826471c82",
"main.dart.js_285.part.js": "d29412b7db328498409cf20bec93fdf4",
"main.dart.js_321.part.js": "17b5df42d3be305d5167909d2196c0ab",
"main.dart.js_273.part.js": "1d8e6a5a6955cdeffb5430cc0c1e8b18",
"main.dart.js_248.part.js": "173360e8ce1004379352e2890cdd7434",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "7ca758e3e0d7f8dfa889e1c9c3fa694f",
"main.dart.js_332.part.js": "84cc2d6c04ddac2c00915021a7e9b58b",
"main.dart.js_314.part.js": "0b1c3caa91eb8f897d00a276c9cbb25a",
"main.dart.js_307.part.js": "73c3074f4598be99887d66add2eb833e",
"main.dart.js_218.part.js": "c93b6f6f3e492e835337a29d69218381",
"main.dart.js_230.part.js": "b4d2a8efcef2d19b6c88613e292af672",
"main.dart.js_324.part.js": "75b245ed1dd048d8e7be63ace56423f5",
"main.dart.js_328.part.js": "a852d5b9d4670fe9b960aef34b366493",
"flutter_bootstrap.js": "7627d79769ad8ed7264c08b7a28ef638",
"main.dart.js_315.part.js": "dc2df47faab8bb0a278d9e03dd8dbea1",
"main.dart.js_306.part.js": "127cc49a0b0cedbacc47dd3ba6ccefe2",
"main.dart.js_276.part.js": "1fa75cd5d78d2330199119e2a3fb4a0c",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "dc2aa7900c80792396ecbb4473bab425",
"main.dart.js_310.part.js": "231878048da8636609f7915d9e7c62b9",
"main.dart.js_233.part.js": "cec87bcebf36d636b37c4de0c2ec68b7",
"main.dart.js_326.part.js": "54d920b0bf17c0fe9d3de9260c8f20a3",
"main.dart.js": "e5b927c957b0d479ca5d2a1ead76395b",
"main.dart.js_17.part.js": "31320b65abbd716629a6901f31498bf6",
"main.dart.js_277.part.js": "ca0d751a7f5ff168796567f74cc071af"};
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
