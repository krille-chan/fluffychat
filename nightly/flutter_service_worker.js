'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "99db3eb157337482aa99ef9e33191796",
"main.dart.js_259.part.js": "fad3bf5afc7cfb7e5a2650691cb2bcb4",
"main.dart.js_317.part.js": "2fd63a13c65485be16485714890de501",
"main.dart.js_243.part.js": "7512e32ed55d1c51e5df5b291b587410",
"main.dart.js_1.part.js": "54ad29538ee8eeb1642cf0907b6607c6",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_274.part.js": "c461522164fa321aa7287dce9ebf2784",
"main.dart.js_318.part.js": "0b35663ac8e5758915143f72df2a72da",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "26951c54da8eacb0ceef7041ae453399",
"main.dart.js_234.part.js": "e23b205a1ea98a7e92df6c875b124ec3",
"main.dart.js_316.part.js": "90f2370a8b7a7716dbf70740bb664207",
"index.html": "b77abb1e671d635d13521ccdfc4d4480",
"/": "b77abb1e671d635d13521ccdfc4d4480",
"main.dart.js_251.part.js": "24bc5a8000fb7feeed0690f1a24587c8",
"main.dart.js_302.part.js": "eb96a7b3da6276caf99d5c9783e6a0e1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "a3ac45074ea0076ee3b59d5b37cfd3ce",
"main.dart.js_2.part.js": "31c7400104ebafe7bb4f4aab1ff17ff1",
"main.dart.js_265.part.js": "a8013b8a4557df86d43320f177091fdb",
"main.dart.js_300.part.js": "8bf85f04e6a5ea08c621b99702223e8c",
"main.dart.js_261.part.js": "22982c5f37a2880bc5fb36675bf12d90",
"main.dart.js_299.part.js": "152cdc80b8ab4976570af9fa5aa2bdd3",
"main.dart.js_322.part.js": "38df867433e681b51276e88ed30eb30b",
"main.dart.js_263.part.js": "68da8ee8ab15d420d55c97010e13f7a7",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "b583ad7f875d1a8a83c65b7dcf64ed4f",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "94e3cc0a42531cf9820165652a824019",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "f1cf8b35918a00fd5fdc9eb0db466ec7",
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
"assets/NOTICES": "18f6b1633458f1980747a31d7e0608c1",
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
"main.dart.js_210.part.js": "18e8ca8db162abbe89992bf9a51e1596",
"main.dart.js_240.part.js": "74bf1e3ab08069d72b500894c10b7b13",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "07cd84a32cbcfcf952cfe164867f56fa",
"main.dart.js_278.part.js": "1ba3d382f1472860710fd471b88b7111",
"main.dart.js_202.part.js": "21d6683de5ff0971fd9e2f5e7e7a4ea4",
"main.dart.js_286.part.js": "d90d9a6cea6d33dac9546f33f7b521d3",
"main.dart.js_303.part.js": "7b680afbb6c9ab20a729fcb8a3096982",
"main.dart.js_252.part.js": "230fc46e8673c73963d5bdda49360741",
"main.dart.js_269.part.js": "37aed26dcf6b202e8ec16937095a0880",
"main.dart.js_313.part.js": "98c61762971d85633ec8c25df0f9720f",
"main.dart.js_312.part.js": "dbd00dd0e19e543c22e85897a6678c7c",
"main.dart.js_325.part.js": "afa7f05dcc6a7a21417fc1106da3601e",
"main.dart.js_298.part.js": "913ea6699c6dd21fa7de3fe52fb41c5f",
"main.dart.js_285.part.js": "2ced941ddc3ad6cf900101326d28257b",
"main.dart.js_273.part.js": "72e000aa489d3549037cec19b9142a3f",
"main.dart.js_255.part.js": "e5166d1fd7cbadee15c59822f4b3f837",
"main.dart.js_268.part.js": "6044588fbf6abf1d1d3f7cc327ecd694",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "b3496ad5cc76e760ebb6864f42d6769e",
"main.dart.js_314.part.js": "e3e8ffe531e203674d13bb960d10f0a0",
"main.dart.js_307.part.js": "32f48c28c396da8245d6020196d3e8a3",
"main.dart.js_279.part.js": "49c85f1b783ccb6ea52aa385621e1c2e",
"main.dart.js_319.part.js": "291758197cf904df9692866267d3c61a",
"main.dart.js_253.part.js": "cc618ad0d991531f34e6041942d632bf",
"main.dart.js_323.part.js": "c9f16b76fbfaaecbcf604f22b3c6916b",
"main.dart.js_324.part.js": "aab55650c37d00742ad3e163dcecccda",
"flutter_bootstrap.js": "1158cc38a4da806c3e1562e48aa64a4f",
"main.dart.js_306.part.js": "0ce494f45a83ee5c6ada30db7b50090f",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_225.part.js": "538cc5a3df1d9fe69e0945236a8782df",
"main.dart.js_293.part.js": "8280de6c859d3454cc1bbce3359cfbaa",
"main.dart.js_222.part.js": "2d443d93ebf85ab78ca7e1a875a1168a",
"main.dart.js": "c3e4fd982f7f965dd7018c17dd3d6dbf",
"main.dart.js_204.part.js": "62a689cf8a2538bdcc76eb575601a4dd",
"main.dart.js_17.part.js": "58c0e13871dcc2c842c084b38f299ad6",
"main.dart.js_277.part.js": "9458fd0159db64a027e2e6f5e608aca4"};
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
