'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_290.part.js": "a6761cdd9c2d8f16afe3c643965b0c31",
"main.dart.js_247.part.js": "d3428ebb5a70eb95e5e20e850cf58b21",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "89b3fac9b83e56fbe42e00717c36427f",
"main.dart.js_276.part.js": "d22f742651ceaeb19ea8dc39887f5668",
"main.dart.js_220.part.js": "8a5bd37070e6a6590544759df4ca9fc1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"main.dart.js_1.part.js": "ea8de60c00793321d8289f6dac4ce711",
"main.dart.js_243.part.js": "c026a9914f6179a6d5798f61ef43d407",
"main.dart.js_191.part.js": "57b3cc55ff67fba445b52923573d578e",
"main.dart.js_275.part.js": "97522ce24526b6202c7a06b02c93cfff",
"main.dart.js_270.part.js": "1becaaa9a627be5315909d716214d0ab",
"main.dart.js_286.part.js": "73ba038d722d475b4f264e326f7405ca",
"main.dart.js_252.part.js": "5f094469c1ecabb041b76d5b691eadef",
"main.dart.js_242.part.js": "42d2779d8d5a2e17ad1f18a77c68caee",
"main.dart.js_293.part.js": "319286a13e740f755b064c0fa7186d3b",
"main.dart.js_277.part.js": "f4a79c900db426d8eaeb6f2fb93fe975",
"main.dart.js_241.part.js": "9b372ad28477d4c6bf990dd7807c10bb",
"main.dart.js_248.part.js": "6832f41ae1a6c58837398a66aa5f3a95",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/fonts/MaterialIcons-Regular.otf": "0f73bdbc3eb9e9032a2a319f3942ff0a",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "4e7e0dab1d4f1ea57ee765a83d3e71c9",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "e3c4ff4cebe742cd5e83688287a0447a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/NOTICES": "696a86bad06cc33ece774bae3d89c096",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_189.part.js": "06d04cab072005359b3fea1110e61b83",
"main.dart.js_204.part.js": "6802d7109f82fc04f16679255cbe35e3",
"main.dart.js_268.part.js": "d1a589cb9dd4d6105bc9957fc5a9e5ce",
"main.dart.js_297.part.js": "014838e811dbc97df80f2edacc52ad4d",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_272.part.js": "5ceef56382f348d79ba6c6035b91cd84",
"main.dart.js_237.part.js": "0ee8f33e1326ddb97ceaada0e7e94f9e",
"main.dart.js_282.part.js": "65c59eadff087e1ea8cff34e7933e33f",
"main.dart.js_2.part.js": "f139f3f23a1caf083af919bf3ae657d7",
"main.dart.js_229.part.js": "a20d79526d2741de4c6f42de0617c7ea",
"main.dart.js_230.part.js": "6582253b05307602bb6bdb6ab6660087",
"main.dart.js_253.part.js": "c4a4b7a9990da53aafac12da03a19b41",
"main.dart.js_244.part.js": "bc27c059e4f20f633d6757c60f7f7019",
"main.dart.js_16.part.js": "9bf923b5d27daca9526a9f8d6f6186ad",
"main.dart.js_294.part.js": "353024d5915b49ee7b4bb802a41550b5",
"main.dart.js_260.part.js": "963de5b96173fbcaa7a3c1f333229e3b",
"index.html": "0076a7c4c156a6fcd2bb3d446f2ec82f",
"/": "0076a7c4c156a6fcd2bb3d446f2ec82f",
"version.json": "82d9ef62d5152ebfe6925ecf47aa688f",
"flutter_bootstrap.js": "fb0f2e3272278b236758f083246491f9",
"main.dart.js_239.part.js": "b7662f5d8ff0e0852c45e78d2501244b",
"main.dart.js_218.part.js": "be75946841a067903840de92991654f4",
"main.dart.js_291.part.js": "3947b35a7e241fec5c826538f8f8bfb4",
"main.dart.js_228.part.js": "f1b4e2256088826a6ac8a8bc47f6a1fd",
"main.dart.js_287.part.js": "db113e7950514ebb118551c31df3268f",
"main.dart.js_212.part.js": "3af4859e00555694264cb809ac962cb1",
"main.dart.js_279.part.js": "936aea85f6d35caf3ef418fcceb1a1a0",
"main.dart.js_232.part.js": "187e7f785d0ee7d9d192c042b569b713",
"main.dart.js_273.part.js": "3a2f9ce2e051baaf54c914b008e90951",
"main.dart.js_296.part.js": "84d2d5f47fca0105c5c53b8e9463412c",
"main.dart.js_292.part.js": "ab483aa266baa852b1840bb046b4bfd6",
"main.dart.js_295.part.js": "69c1435e3f018729dde3bbab373304e1",
"main.dart.js_288.part.js": "d8c33d36a89ca722c35270a6081b48ad",
"main.dart.js": "e0e78cf8e36475d6a6f55fdf258b7e2e",
"main.dart.js_280.part.js": "0f4835c9f77d0e0a30a1c272ec189486",
"main.dart.js_202.part.js": "9cad540f4f6f39c7e920e8f9efbf0f1f",
"main.dart.js_261.part.js": "aead41ba2ac2d71cc9b5185ca1230aed",
"main.dart.js_203.part.js": "751499d2c623bcd21178f8b5256c6a18",
"main.dart.js_254.part.js": "9473c0a7f2cc175fabd9578bb1be4b51",
"main.dart.js_263.part.js": "5309c6048f210a6a4af90fd0b5b84c42",
"main.dart.js_281.part.js": "46a7b8a496d2b7ab28eceef9a488df72",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be"};
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
