'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_262.part.js": "945318f7f5df1b4460a1a2cbcb95bd5f",
"main.dart.js_230.part.js": "bdaad8cdc89012025af6df05a0aca010",
"main.dart.js_276.part.js": "d45a5084beb8392b0f0cc4fc441173c4",
"main.dart.js_274.part.js": "40332ac7bf43354094610409ec9d84bb",
"main.dart.js_292.part.js": "6bc466d8798bad060a318ef2728442d4",
"main.dart.js_203.part.js": "dc1fad0d9e5e820d63a6f71bdd3a5a63",
"main.dart.js_243.part.js": "2c6353fcf2389ed413d20886c8f0f37f",
"main.dart.js_248.part.js": "cdecf88fcb5e406a9ba474fc9b81d975",
"main.dart.js_275.part.js": "3962610e695f2fb857d3c1a17ffa92b9",
"main.dart.js_296.part.js": "f50e0cfe6f6e0fb7c51e5962ad14b871",
"main.dart.js_255.part.js": "69bece1c637175f4582effa91d9d465e",
"main.dart.js_271.part.js": "89d7fab015ab50cd8037ffa50d5e25a1",
"main.dart.js_240.part.js": "182a5f06bf2c75027d27ce5351a4f2df",
"main.dart.js_189.part.js": "a3d8a8a6951a840be1400d2cbe9f2ce1",
"main.dart.js_242.part.js": "8e197cbeec99564ad79ea64584ca2bc1",
"main.dart.js_1.part.js": "71c7a071da8e5733eef6569c2483fae5",
"main.dart.js_213.part.js": "7974e6bd408b5ea68899ee33d130a4ea",
"main.dart.js_16.part.js": "e0d91d3418ee67bbc338777cb4000182",
"main.dart.js_269.part.js": "242924b5098312620e3d53ba3c58e61a",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_294.part.js": "e5af487d6c55ab3504334958df97d92e",
"main.dart.js_253.part.js": "37fcdb75b51730dede026a23a834a784",
"main.dart.js_204.part.js": "94b4a0cc830fb101188a03f283702356",
"main.dart.js_287.part.js": "43abbccfef40362da7aaf16f3225ad92",
"assets/fonts/MaterialIcons-Regular.otf": "f5f22db300aa7bdf86de1c57d4aa8d3f",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "c8db5451253889809a6111899405e058",
"main.dart.js": "4fced88608e6b00f0b90070baacd9842",
"main.dart.js_254.part.js": "56183db2f29ef062a4bfb9482859aead",
"main.dart.js_273.part.js": "a25315d356125a37538575ef7c0f3838",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_295.part.js": "440afb12ce533ee8ed5364e22a130887",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"main.dart.js_281.part.js": "e9f6a0a40c80286400789dbaadc85a80",
"main.dart.js_282.part.js": "fe6b1357499a41e3cf4879df0dc6e8fe",
"main.dart.js_283.part.js": "1961f5df46a23097035830172a68a236",
"main.dart.js_298.part.js": "cf5a604ae6f4d3147a250e98b44eb624",
"main.dart.js_191.part.js": "2f411b8598b2b3153dc618584b1f3ac6",
"main.dart.js_249.part.js": "706f2e1616bacd38b9bcec917d28c681",
"main.dart.js_293.part.js": "49d81c18cb63f3943de1742e716d1e3f",
"main.dart.js_233.part.js": "d454384ed15d5d5adbfcb4b61bee8261",
"main.dart.js_202.part.js": "42f936eb7383f7b7e95f8da4122a8086",
"main.dart.js_297.part.js": "9d36efd0c531b10aff279358a276b43a",
"main.dart.js_278.part.js": "450a11b4ae31c2c748b165b9b55696f3",
"main.dart.js_2.part.js": "8eeca23dc8f0452bd06adb9c9fb94add",
"main.dart.js_229.part.js": "0ee30cf663d8202a2a96dd3bb568b58d",
"main.dart.js_280.part.js": "9f157c5008b35cca4534e3a9292a884d",
"main.dart.js_288.part.js": "59c2af055f64b40d41b8145307a10d57",
"main.dart.js_289.part.js": "9de5839623c909e89ded70c2f3fa02d1",
"main.dart.js_231.part.js": "c16ef3411bc1261165e370767439a7de",
"main.dart.js_277.part.js": "f0dff7b5ed962e55c7f1a99364f8ddbb",
"flutter_bootstrap.js": "f4983451d07f369a5f1e25d2ae713359",
"main.dart.js_221.part.js": "d75a25a1c481435f5280bf3e6a43dba5",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_291.part.js": "ba47c985c5b3eae0678df8f9a2f7b2f8",
"main.dart.js_244.part.js": "d6980e31a9ad1d0626e813d8e6496586",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_264.part.js": "594ed1320748ca80b45c18099279fafe",
"index.html": "94cc472b33a870c4a74fc2a7cf340584",
"/": "94cc472b33a870c4a74fc2a7cf340584",
"main.dart.js_219.part.js": "8cd12095efd4bffbb3781b22e2f06d9c",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_238.part.js": "42bb1e84bb454b8ce6e276fa07719857",
"main.dart.js_245.part.js": "3a03e766e87d77746a615038abbf56aa",
"main.dart.js_261.part.js": "2001a49fc8fb27aa47164e1008329491",
"auth.html": "88530dca48290678d3ce28a34fc66cbd"};
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
