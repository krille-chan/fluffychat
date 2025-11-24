'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "db03b80d833c10292c9c2c5da05653b4",
"main.dart.js_271.part.js": "38ba878d139cfcf0640fbbe797424344",
"main.dart.js_297.part.js": "b66fa19fccbfb9a1a679f07d1843abd8",
"main.dart.js_1.part.js": "112735cc13f3bcc5ce2779860c982ab3",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "025a5280032a4b2cca03c0e1dc028171",
"main.dart.js_280.part.js": "fa5eccbe39fe0f4d67306dcf656d2a6b",
"main.dart.js_318.part.js": "5a06b2040280bb3f73664c09709b68ca",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "cc4b022652d04580b9830ecd53b3829d",
"main.dart.js_316.part.js": "6cf5fbc7f200cc3a6bcbc4aca0a6e71b",
"index.html": "ad71c7ffbc7f03103fa5a9e86ecf08d2",
"/": "ad71c7ffbc7f03103fa5a9e86ecf08d2",
"main.dart.js_302.part.js": "09bb601719e99421375a8e3cd010d499",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "9fbb7bda88d51a0dc4e6b29743d2d922",
"main.dart.js_305.part.js": "8340e2e1ba76597d303529f1fdb5ae54",
"main.dart.js_242.part.js": "8ca39b7932b0cf7439911edaef6e6637",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_265.part.js": "451845b6a0be5db73c76cde111f2b3c1",
"main.dart.js_300.part.js": "798f8a96cb64d1e5dbc5cf32862271bc",
"main.dart.js_261.part.js": "76a11094afd8ab4142d3994a16572207",
"main.dart.js_322.part.js": "e6c1abba5a63803fc9f4acff06cf8062",
"main.dart.js_263.part.js": "6fe5cbe94b7c128ce952f7163f35b2e5",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "01c7e4d558b36780a4500a55cbb65142",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "42d462a04c930b681d36c916cd64a898",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "5e33ba9ea69cf224e791052c2cfff281",
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
"assets/NOTICES": "3ed19900f4b6d3f69a5b0e9689b8e27c",
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
"main.dart.js_320.part.js": "203c4b78b2e6ef58402d32d146c72a05",
"main.dart.js_254.part.js": "2a1b0dbee277e6d4c5ba7348e0c9fd8d",
"main.dart.js_303.part.js": "866853ac9854c93f806afa80ff840f1f",
"main.dart.js_287.part.js": "2e4ab652d7b29e38d4c261fa2df826da",
"main.dart.js_257.part.js": "8daf1ac817ae890ed790a19335a3b187",
"main.dart.js_290.part.js": "7dd010f83d2a89833ca9787a929db936",
"main.dart.js_212.part.js": "f8b60406f341411ff28bcc522522013c",
"main.dart.js_267.part.js": "157bfe1f93bda0a82ab1eb5946869b4c",
"main.dart.js_309.part.js": "827008e828c9a385070dec7e12467c4f",
"main.dart.js_325.part.js": "ad20a5923db5987f110795f1142348ac",
"main.dart.js_270.part.js": "8950b011559cb05c9fa7aaf17db4fa79",
"main.dart.js_321.part.js": "2c7bb339eb8134aaaada0787e45e0dd3",
"main.dart.js_255.part.js": "698b9381bf9e0abc38cbb1faf6a88255",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_275.part.js": "42ec0f1ea5f8f4775dded8ed0baba397",
"main.dart.js_281.part.js": "dfd41023518255f0f434219116231c20",
"main.dart.js_288.part.js": "d4eb85dbc77336b61e15754faf5e6b83",
"main.dart.js_314.part.js": "59f29bb65d2399fc44b127bab762bc1b",
"main.dart.js_206.part.js": "f14efb05bc887fcafb1a4697f5ebf4df",
"main.dart.js_307.part.js": "5d9509e618b38c8865647132f20c85ae",
"main.dart.js_279.part.js": "0d9f2e68c866c88365e9eabaee24ad74",
"main.dart.js_319.part.js": "14583a81a71bd2b7bfbc9f8e623cf7c2",
"main.dart.js_253.part.js": "27dd40242d22b5bed1d0eb309879dad4",
"main.dart.js_227.part.js": "fa7516f0875f3f65ed824644a2f61442",
"main.dart.js_324.part.js": "2a5a71eff463b6301b15157600c88c67",
"flutter_bootstrap.js": "a8fdb07f11b1e4a86cec211036bec990",
"main.dart.js_315.part.js": "e0ee0df9d7573f72f19319d776b83a27",
"main.dart.js_304.part.js": "dc078de8a27d6ae086afb5bfdcefe558",
"main.dart.js_276.part.js": "4ff9364a1b91899be1e74000b3aadbb1",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_310.part.js": "3f5f9a0ac0964a252dac1108c88680ac",
"main.dart.js_326.part.js": "29a54a73872a96c2282a20c1e414d012",
"main.dart.js": "a7a4c1b0da83ebb509bc3c3ffc0bdc09",
"main.dart.js_224.part.js": "43139653ee1a447bcc7bacb690d6dfaf",
"main.dart.js_204.part.js": "1b0acde1b50de6955096ca282f74e84f",
"main.dart.js_17.part.js": "1d0ad5e54a49628b2fec40965f260086",
"main.dart.js_236.part.js": "0d36bc51dfdd570b1cd4cc32ddae7cf2"};
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
