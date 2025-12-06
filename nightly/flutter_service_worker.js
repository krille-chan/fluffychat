'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "559787f5fbec15d72fb920d994b3a7e5",
"main.dart.js_308.part.js": "22e3393d57fe53f2bf1f7070c232cd8c",
"main.dart.js_317.part.js": "771d1b828aa3b2ab6b6f042cb5ffa63c",
"main.dart.js_243.part.js": "b1f58eba2ae0eec198ef9055c07141c3",
"main.dart.js_297.part.js": "afe7c8f573e9f511042e00a7e742234c",
"main.dart.js_1.part.js": "cb05ad9b9891b5537bff177adaa79cad",
"main.dart.js_260.part.js": "b1d253b80a0371637c5e19d696407e34",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "fa7d74c927b623083ce23b5551b57e27",
"main.dart.js_274.part.js": "25738892d405e762b191d8bf1bfbe374",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "e110c499b2a8316df56b7e23b3665264",
"main.dart.js_211.part.js": "515fc5e113cac27983eaef4913f0b494",
"main.dart.js_234.part.js": "2e7a1165348021694ea5178efb770f72",
"main.dart.js_316.part.js": "1a99c0961bcf13496e8c180fa06595b9",
"index.html": "6f822e75d7015375e4a88c91abe5bf6f",
"/": "6f822e75d7015375e4a88c91abe5bf6f",
"main.dart.js_302.part.js": "0dc30bcda067ac285f035a57a020bda7",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "4b5135b4b9659bd30ef38cf77e8dd744",
"main.dart.js_2.part.js": "5f36aeb88202899e8818311fd344518d",
"main.dart.js_283.part.js": "85c2170bb779cdd4e49874973ef2c808",
"main.dart.js_294.part.js": "14b611bbea804682170fb1e324f2a18e",
"main.dart.js_261.part.js": "a591c3f8eb727d48ffb87c75bbd433dd",
"main.dart.js_262.part.js": "e06f99d1bd95b735c0c388e28c4cd5ee",
"main.dart.js_322.part.js": "b59f415feb38dac7a85037ec6b7d2df2",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c2ab8a9ee2c053a2f115d52e2aedd81c",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d33d34c6913b6d7594765f9dbae171ef",
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
"main.dart.js_334.part.js": "daacab97395f9aa7ac0f690b982d013b",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_278.part.js": "8fff3b26102d5900d36f98f5fc509ecf",
"main.dart.js_286.part.js": "00a27c331f8ff4e55c448c73c5c2f425",
"main.dart.js_333.part.js": "19e7cc3a8edc21644b2dc57eca811ed4",
"main.dart.js_287.part.js": "61db0b6305bfbec6a4765659be5777fe",
"main.dart.js_331.part.js": "1c0ae5cf0d488a8d709b8610f6a44e1c",
"main.dart.js_252.part.js": "8254630bea3f8c192dd75e1d3daeda5b",
"main.dart.js_213.part.js": "54f5f74785f12cc02f767edd705393ad",
"main.dart.js_249.part.js": "0930b49dce412309da2fd65c365dea9e",
"main.dart.js_309.part.js": "e633eb53d517d9c47761d8a205d4892d",
"main.dart.js_312.part.js": "53b1540ac8e4314d62409736e8a59db7",
"main.dart.js_325.part.js": "7807b4815662b3c67ede6ba23a8d254a",
"main.dart.js_270.part.js": "16382059a7ea5525409bdd9146ae487d",
"main.dart.js_321.part.js": "c00f3f114dca14d813560ca41b57dd25",
"main.dart.js_268.part.js": "684784cf5e37d7cd44d30ff46bc36eba",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_332.part.js": "9792a757d9c49c9ea19b817b037a1b97",
"main.dart.js_288.part.js": "210da7ac992b0ddfdd16f2998cf30786",
"main.dart.js_314.part.js": "8ce440db9736f730ac6263b579a40c6b",
"main.dart.js_307.part.js": "c2ff2a4f6a0e60dcf0b96bb87534b8c9",
"main.dart.js_323.part.js": "7d6b411828c00cad418f803e618461a2",
"main.dart.js_328.part.js": "c27436af4635df2cb94afaa2306afc94",
"main.dart.js_231.part.js": "d7ac65b93f40ea31862b66815db8eb87",
"main.dart.js_219.part.js": "cd81e1825768bcf96bf9ed52d729d23d",
"flutter_bootstrap.js": "fc97dbc324a83401ff4d5ff97f54d91c",
"main.dart.js_315.part.js": "6d5bd46d5f46e89bff5c8efe22e0af52",
"main.dart.js_304.part.js": "865bb8e54f7bddda8dc71d047b04bfa4",
"main.dart.js_264.part.js": "3d1d7b588e2abc64908fccf0cefbe83b",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "f7bef636dd6ae5a0bd54686aa96f492d",
"main.dart.js_326.part.js": "36d66b07b64650049ad23ba214672cda",
"main.dart.js_329.part.js": "1e3244428f085055836c1a1fbb16c38b",
"main.dart.js": "a71f54bfe288f99985ccda4585882f5a",
"main.dart.js_272.part.js": "f2f9b676d1c88c5548e6b612456fdd3c",
"main.dart.js_17.part.js": "b5e10004311e94c3e8471cdd86b89756",
"main.dart.js_277.part.js": "420f090d149b5a5f79b28b06538814ae"};
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
