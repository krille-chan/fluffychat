'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "33244bc7b64c22958dcb11b987cb640e",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_282.part.js": "02959b7e9c49140b149a97e4ff136b60",
"main.dart.js_308.part.js": "0e6c0eb8dd493cdfc81681137643a3e7",
"main.dart.js_1.part.js": "b7c155d6b22fa1596f8990c5a9210142",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_311.part.js": "5ebc890e3f2ac0657c46dc588b5dc3fe",
"main.dart.js_274.part.js": "baa2b114c5fe464c8b6c7ad364476313",
"main.dart.js_318.part.js": "f2687faffa231464f27eda3dffe5f622",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_338.part.js": "574bf2a29efa7e7baed89e8c36feff7e",
"main.dart.js_266.part.js": "5fc6353f9b4dc4ddd54f3865f9aaaff8",
"main.dart.js_316.part.js": "4ccc35db04fd4e7952fa6ff3d60fc8a5",
"index.html": "c548720807276518442a9cc4d8cada10",
"/": "c548720807276518442a9cc4d8cada10",
"main.dart.js_217.part.js": "121c42f0bf745c537f4669f17643281a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "451a3b65f04d44c4ee9caf0f46474ce7",
"main.dart.js_2.part.js": "31bfa37b95c1962be57d523396dd4e06",
"main.dart.js_265.part.js": "a8b111b9ff2d2e23431eba245757ba05",
"main.dart.js_299.part.js": "a05257bee3a4c25e8d0bdb465b193d00",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_330.part.js": "078246f2619e63bac13cc0c905b027d0",
"main.dart.js_301.part.js": "c4021ef316337cc4e514a64f687246cb",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "50c84084a133eae450fffb8d6444bc3d",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "96b0bb5be20cd33cabf8b7e9d3cea283",
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
"assets/fonts/MaterialIcons-Regular.otf": "cf04b1acec037d1bfe7beae9ec5d43f3",
"assets/NOTICES": "4de3f617c2e220cbcf134b0c31162a7f",
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
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "505d8d8d1e44c473be713999a5067f69",
"main.dart.js_247.part.js": "3c84ddf64b833f5160c2bacbe8599597",
"main.dart.js_292.part.js": "efcc94ace2e9a340bb3cc316ba14e4d6",
"main.dart.js_16.part.js": "462c83ea2038a630576d90b172652586",
"main.dart.js_278.part.js": "49a83bfafd13c89ac09abce262957648",
"main.dart.js_286.part.js": "b65d210b9a08e82df7a20d8a994cc9e2",
"main.dart.js_336.part.js": "8ff1bedfd4e41030549916bdaf871254",
"main.dart.js_333.part.js": "135a6a90575eefe98881ab4cee109f76",
"main.dart.js_287.part.js": "b2f59cbe765f765824e21ed3a73b4eb7",
"main.dart.js_331.part.js": "a77e86d57f95aef19587204cee051605",
"main.dart.js_290.part.js": "496778017f005e1543ddb5dbeeb65350",
"main.dart.js_313.part.js": "97c0a2196637082620fca59d0f4380fd",
"main.dart.js_312.part.js": "b3b1ad9f2016b1b481e6fa50abcd1e62",
"main.dart.js_325.part.js": "9321845ee93a5a574c3cd1f752cefb1e",
"main.dart.js_298.part.js": "128302ddd042cfe596840a5464cbf14c",
"main.dart.js_321.part.js": "17e06ee09ed49e9bba504255b8956868",
"main.dart.js_235.part.js": "876d8674e46e31d1e0753375e879c049",
"main.dart.js_268.part.js": "e1d0ae1b32da6b989edc07daaa9a705b",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_281.part.js": "67efa9006f34b1569202da61fffaf8b2",
"main.dart.js_332.part.js": "8c3ebc4e6101a86b481c8ba3832f215c",
"main.dart.js_314.part.js": "2d8c6d04bf9bd009f0dce60805069f01",
"main.dart.js_319.part.js": "0737e2d47c82565c064b571f7f1e9c0a",
"main.dart.js_215.part.js": "f59a14ccd0560758a6527b4feacb112b",
"main.dart.js_253.part.js": "8452bb794aeab644dec6f0bf032e5fbe",
"main.dart.js_335.part.js": "9dfd5b400c3eea8f16d81b1297b1acab",
"main.dart.js_337.part.js": "d127ec4193cb467ece4ba18629463dde",
"flutter_bootstrap.js": "137e41e18ea7a63e2e39748eeef8d0b3",
"main.dart.js_315.part.js": "4902f5c92d3dfe99fc5f5bd1081ef57a",
"main.dart.js_264.part.js": "d91d599b59153f1fc52067f6d5d31392",
"main.dart.js_306.part.js": "3b5e1bd1dfbfc29c99d920ee818b1aee",
"main.dart.js_276.part.js": "5454f1262893bb1abdb3de27176475f2",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_238.part.js": "cfb2afa80efaa636ac5ee648c77941bc",
"main.dart.js_256.part.js": "0f1050b429c9a41d8d6af015c47c26b9",
"main.dart.js_326.part.js": "40346f32a7e0413629402f9ad91c762f",
"main.dart.js_329.part.js": "c2963519eeab8be5c7d0b3c2adbe1a5b",
"main.dart.js": "01f7996ab199d0f90b078e4519c90999",
"main.dart.js_272.part.js": "b5817e368ce72602f3aa24e5fc75cdf6",
"main.dart.js_223.part.js": "b540c3871fb2bcb836f89a8799dce906"};
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
