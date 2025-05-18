'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_235.part.js": "716bd67a18b8e3cd2dd8335a0f48bee9",
"main.dart.js_302.part.js": "3aa915f633d858d6526fdfc529e0a513",
"main.dart.js_292.part.js": "e693f092984ac8527814c227db8b81bc",
"main.dart.js_286.part.js": "9e331007ec11e2537983d3804e05a993",
"main.dart.js_195.part.js": "ac349757af71903d6b84af759cdab6f2",
"main.dart.js_265.part.js": "131eb514a5e04c3a4b3f2ee523be8df6",
"main.dart.js_257.part.js": "7bff8254f1c25cd88964cb9af742a942",
"main.dart.js_248.part.js": "03a4d71a1013a81968cc0edd3d9d024c",
"main.dart.js_275.part.js": "e2eadd35a0d3fd8b0da9fd77161da693",
"main.dart.js_296.part.js": "041f4446939085dd127d9551d8314fd2",
"main.dart.js_223.part.js": "c32560465811b7e685346367200becd9",
"main.dart.js_242.part.js": "d751ba26859e2bcf3e99b15759b1b810",
"main.dart.js_1.part.js": "71c7a071da8e5733eef6569c2483fae5",
"main.dart.js_252.part.js": "90ffbcee9095419566872b2809db538e",
"main.dart.js_16.part.js": "e0d91d3418ee67bbc338777cb4000182",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_253.part.js": "6ec2f4d7dfe0e580d5cb58665461360e",
"main.dart.js_287.part.js": "3ac9425f12f30f990d49409b10430057",
"assets/fonts/MaterialIcons-Regular.otf": "9f4c6848f06fe55b64ee4a287246d084",
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
"main.dart.js_284.part.js": "26a82a7fd97fa0b2682f0f483c409201",
"main.dart.js": "9f3d9d756fb27f3662bc02796b60a21b",
"main.dart.js_225.part.js": "ff379279472ce4163089ca4d0fbd8cbb",
"main.dart.js_273.part.js": "cdeb842c4f121e4b3f14227903f71cbe",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_258.part.js": "363ebd9a7114eb76867b8510c401393c",
"main.dart.js_268.part.js": "c2ad6007ed6ca151c8d99f134d91d36f",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_300.part.js": "20fe6c750bc719b2b3d8005dc032dd20",
"main.dart.js_295.part.js": "b5824d5699b75e69a2f63335f77b4a2e",
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
"main.dart.js_281.part.js": "04ca7f7194d87d1122ad0583f68902ad",
"main.dart.js_282.part.js": "f862db7574e9bccaf19aac6d84deeb18",
"main.dart.js_299.part.js": "cc8d38b2d057074fae6814ff89d7acc6",
"main.dart.js_208.part.js": "6d181d32484cf70f3899bbb491291d4e",
"main.dart.js_279.part.js": "e1d9bf1ce9e5d089bd5955c74ef47b38",
"main.dart.js_298.part.js": "76cf22ea9107699573329d326bddb182",
"main.dart.js_249.part.js": "fe3f8a586db016ab4bca2591fa98bde0",
"main.dart.js_293.part.js": "2f2ffa2d69653db955b5b23d1a11105e",
"main.dart.js_266.part.js": "32b9c0733c68464fc7292f8ff86a1337",
"main.dart.js_233.part.js": "44f070e7a14956852999d9cb726b26ab",
"main.dart.js_285.part.js": "8b126d565b742d9511dc864dc506e053",
"main.dart.js_297.part.js": "8bfa0e9ebe0b3ef507a5f87315d69e10",
"main.dart.js_278.part.js": "d572ca4c6b2f3583a139920458b7cedb",
"main.dart.js_2.part.js": "8eeca23dc8f0452bd06adb9c9fb94add",
"main.dart.js_193.part.js": "aca8944218d39fe09ba94f756421d338",
"main.dart.js_280.part.js": "2c6699a2360b7697d1413cf8fecf049a",
"main.dart.js_206.part.js": "1522d49b48fcdb045560d052a5ae87d4",
"main.dart.js_237.part.js": "06c2f4dabf378b846e00b421de9e3384",
"main.dart.js_277.part.js": "f432c522e39b8e6599397d2f41c8ef7a",
"flutter_bootstrap.js": "98bb8779bf378e62b95f16b7bef0c4a9",
"main.dart.js_247.part.js": "80a0a49de1f7f972f47f3876e3fff63a",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_234.part.js": "a23843ef008138315673edb9d270dfaa",
"main.dart.js_246.part.js": "c2e894b354cc5b69fed51e8571e3dfd2",
"main.dart.js_291.part.js": "93ff616c3d17aa7346ded5aeeeb47a96",
"main.dart.js_301.part.js": "c8808e1e67a28e25ecec867554ef0f1c",
"main.dart.js_244.part.js": "61891acd27e0f82e204ded59bb6e0a4e",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_217.part.js": "fea312a2a3425dc38e3915ab95fa6f4c",
"index.html": "3f2e39eb6b2972f0d60f2cb04517fe9c",
"/": "3f2e39eb6b2972f0d60f2cb04517fe9c",
"main.dart.js_207.part.js": "1df30c30c9c331ed4f75234182d2653b",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_259.part.js": "cf5bc7f1d0148058d6e12fe48e73c33c",
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
