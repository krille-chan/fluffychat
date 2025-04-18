'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_229.part.js": "291807ca65b35226debe03a2c6ce3cf0",
"main.dart.js_254.part.js": "b26b178ff32871364ae0547ab28448d9",
"main.dart.js_247.part.js": "7ee7d0e87d18293487fb71c38cef01d7",
"main.dart.js_291.part.js": "3a15edd9e16c30cc0b8eba02e7f91743",
"index.html": "1d950abb0a68eaaceff3799adba88e6d",
"/": "1d950abb0a68eaaceff3799adba88e6d",
"main.dart.js_190.part.js": "7463d35186d44d6ce7f43c9dfc88f5d2",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"main.dart.js_203.part.js": "e8b5e6ffc66537e03943cf2d3f7d7e40",
"main.dart.js_214.part.js": "6ed00c652f411603a3334cbe02782a3b",
"main.dart.js_276.part.js": "7a1b58f34f403b24cacf9ed8dfae73e9",
"main.dart.js_260.part.js": "170c90a3c1c3bdc6262979d850953e85",
"main.dart.js_204.part.js": "8a5268dca867c288202e90ea894cbf41",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_252.part.js": "a5f66993a0dcd740114cd210fbcdac3e",
"main.dart.js_263.part.js": "9966d8a976ee25858a6f776b98cf51a0",
"main.dart.js_232.part.js": "d3b007d8d6ca51ea0f7d3d5f31e64021",
"main.dart.js_277.part.js": "5a098f8135d263ad4fb50c6e1e6ab47b",
"main.dart.js_273.part.js": "c4fd4628f97a178805e86511fa76490d",
"main.dart.js_281.part.js": "6c9d4adc7f7d29ad5850f48313c1fc9b",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_279.part.js": "4acfcda7d2bb6c38baa0f50d368312b5",
"main.dart.js_243.part.js": "404865aed5dc69e82184cfb4251df560",
"main.dart.js_294.part.js": "4330c24bafac745c48e810d5f688a1a3",
"main.dart.js": "23aae3f0e01b0302a6ce6a12872410fa",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"main.dart.js_292.part.js": "00b598f7910b8c70c3277bf6188cf14a",
"main.dart.js_244.part.js": "3442f104ff6e9512c72226eab502783a",
"main.dart.js_205.part.js": "fadec8d1431fdebc70ce817e930c034c",
"main.dart.js_220.part.js": "e906aa88328cb07a46b03abaa05d849a",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_293.part.js": "c2a5d7c22a35d8c8749b25d744e65db7",
"main.dart.js_228.part.js": "28d62472806144e40070aa2d131f9f29",
"main.dart.js_280.part.js": "3f1b30150b0942fc3b31f13ac155fa21",
"main.dart.js_296.part.js": "782a0461f44b07711df49c741839d226",
"main.dart.js_253.part.js": "185ad56825e1451f29211421ac6dbc8c",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "2b9e75798142305cbc6c3f725db45240",
"main.dart.js_237.part.js": "eadfab6707d5270fcafa8e11edca2e87",
"main.dart.js_288.part.js": "f95fdc6309c3a4b197c81f8afab5d2a9",
"main.dart.js_241.part.js": "136f20ea373bc1fbf12e1d15bddb8a87",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_287.part.js": "2ebf55a3f4bec763d26200189391dad6",
"main.dart.js_286.part.js": "b9e47c25531a2bbcc25d108cf02b370e",
"main.dart.js_192.part.js": "7ef3ca900af3af332c5d4c594f16859d",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "19169f7d8a9f18d166082f96fbef1281",
"main.dart.js_274.part.js": "904c876baab46de2a2500c39112ecfeb",
"main.dart.js_239.part.js": "80acfce2fb919e3026996f245b455bcc",
"main.dart.js_295.part.js": "aac6bb5774f011067d149a98300d7b91",
"main.dart.js_275.part.js": "e4944f9637eb947eec41537c882172af",
"main.dart.js_290.part.js": "6a0c40f719cbbd026d8fe6de799b1371",
"main.dart.js_268.part.js": "91627a840216b7297443b6c4c0999266",
"main.dart.js_242.part.js": "191a9852736808b03e52995dc1345d3d",
"main.dart.js_230.part.js": "b461ecd434ce434cfb02f1370e3e13e1",
"main.dart.js_272.part.js": "98eb2b72a65e9444095d03c37dab957f",
"main.dart.js_248.part.js": "38ce327b00fbb1d94c20e256730344e1",
"main.dart.js_1.part.js": "a0034b55671f8ee01ff8042382347bdd",
"main.dart.js_261.part.js": "08dbf5b109cb2a3cdb2134d2ec542488",
"flutter_bootstrap.js": "61f82172d71240f7221959439d0dd0e4",
"main.dart.js_15.part.js": "f91b3b04b8e095cf24307c1d44acad74"};
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
