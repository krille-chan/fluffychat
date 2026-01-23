'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "e2e415a635d1307d58efdc52b4de8ee7",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "472b9866ece45d62618e1fc0ad1d04d5",
"main.dart.js_271.part.js": "d98eddc5febbb329906ddf66306b07dd",
"main.dart.js_259.part.js": "0936c7265a19f121463a7ac655b89d22",
"main.dart.js_297.part.js": "57ea46c4be37b66baf6076bcc74d26fc",
"main.dart.js_1.part.js": "48cdc8b8b8a541e6e4e8ccc92f7b2062",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_19.part.js": "62655af22a44917f572edae5a21abbbc",
"main.dart.js_274.part.js": "77709b3dff2da4f7b6743ae00a602005",
"main.dart.js_318.part.js": "d50b942d2c0bc46ac529690c1d216447",
"main.dart.js_338.part.js": "7f17d9183bbf5b98d6160a581e01e752",
"index.html": "692cfa022658b8fee7b0360b099a236f",
"/": "692cfa022658b8fee7b0360b099a236f",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "3235f028ba76c69932869d4a9836b386",
"main.dart.js_305.part.js": "cf794c6e01de95d62afe99c92d06008d",
"main.dart.js_244.part.js": "89e366f10cc0a61bf236ae8087cce70b",
"main.dart.js_345.part.js": "6e43afaa67503a101b7598f8a9f92766",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "6e0924cf026a8dd43ee79cfbd34eab5b",
"main.dart.js_294.part.js": "bccdb8c2810420c18e656454878d14d6",
"main.dart.js_262.part.js": "18eb3c83cc908a0988d4ea92a4b89aed",
"main.dart.js_344.part.js": "b7fa57ed453703099faa5f5811afc664",
"main.dart.js_299.part.js": "93c1aca9e90587c167f6b1a898791c5c",
"main.dart.js_322.part.js": "42e844e09f8e46a873feef5911f03ddc",
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
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "9ed7979a1fd643a9672f474c31062f65",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "d8a180a7a69f7559dc198660737f1132",
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
"assets/NOTICES": "b9ca79add72fc8f59e167e5d7f9d87d0",
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
"main.dart.js_334.part.js": "ec18550b75aed6b040db9ee4f119937f",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "fcbb5057120a75d71fa9d08448cbbc12",
"main.dart.js_229.part.js": "3697aa6a4557678b074c90c296fc7a02",
"main.dart.js_336.part.js": "78ff197026004acd5b5b0c6cd7a5c5b7",
"main.dart.js_333.part.js": "47a80a8797e1d1f4f6507917b2155b04",
"main.dart.js_340.part.js": "e60305519b082f13d372825dfda6a4fb",
"main.dart.js_313.part.js": "61c73ca1423ec25738f255446c5eff2c",
"main.dart.js_325.part.js": "8e0b6afeb4011ad1d1c6ad636e6ca8c2",
"main.dart.js_298.part.js": "3c6bfe8139f596af4959d283e8991ab9",
"main.dart.js_285.part.js": "fac8da4063a702b082fe1cb95e12c651",
"main.dart.js_270.part.js": "7ce399e0dc1338ee74723271f2b6b47e",
"main.dart.js_321.part.js": "33a0ac980cdedc8fc102bf3a9f51f2f4",
"native_executor.js.deps": "c22e93f70c87183fc7f332834dccad22",
"main.dart.js_281.part.js": "9efef6a14b0346234e2738daee428917",
"main.dart.js_332.part.js": "bf90df398c363c14674047afcf39f5d0",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "23e8b70181e0ca03aace8e9c113a0b21",
"main.dart.js_342.part.js": "85e71606d2fad5cf80c7f8ee077afbf0",
"main.dart.js_279.part.js": "309da32602fe5c7dddf770d751a2c10f",
"main.dart.js_319.part.js": "3cb1c1963ac8c29e1c80f016d614ee68",
"main.dart.js_343.part.js": "a2ce1ee82a6a0c464504bcb6d6582105",
"main.dart.js_253.part.js": "1a3c6b830f04942b42d48b9de3f435ae",
"main.dart.js_323.part.js": "ec5a99c65f4425fca04c82c6f351bf61",
"main.dart.js_328.part.js": "b445f7a5efac7a13d7a1f7e73bb7213b",
"main.dart.js_289.part.js": "09571ae02604b643b49a62ece0982beb",
"main.dart.js_337.part.js": "4a9dd9f5c7a0c6301ef0446e64e95c37",
"flutter_bootstrap.js": "035a5a0ac5638ade5ced93e0130f3e23",
"main.dart.js_315.part.js": "acccf71d49c71c9500791e3d9e6546d0",
"main.dart.js_306.part.js": "b7b522b0cfa028c0b1f0c9335086d187",
"version.json": "5771dd777ce1bbb76f0db8df8a12f754",
"main.dart.js_293.part.js": "7a1dafb3a102e2e63033e5665ab29efc",
"main.dart.js_221.part.js": "cdd48145b650f3427a922e010980db65",
"main.dart.js_326.part.js": "df616a9e2c04d463029d5995eeb85a6f",
"main.dart.js": "2f545ed7a91b54f030358347a658a78f",
"main.dart.js_272.part.js": "8f1b4d132815d9113c42af4d441ab5d7",
"main.dart.js_223.part.js": "4648b35f09afba39bd25a9305dd93b75",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_236.part.js": "5da189ef86f4c68f80f8b0191e989718"};
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
