'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_227.part.js": "504dcd4a2676911adc7cea842356e717",
"main.dart.js_282.part.js": "bdab471ad34898fcbc098c9c7cce6a82",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_225.part.js": "6d7b1548a0c666434003467fecbbb831",
"main.dart.js_288.part.js": "98e4b6964f28c63c349ec9e997ab3d95",
"flutter_bootstrap.js": "380796db6220c4edaab192543397e048",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "ba4a8ae1a65ff3ad81c6818fd47e348b",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.js": "6cfe36b4647fbfa15683e09e7dd366bc",
"main.dart.js_247.part.js": "1b90e6ebb5828bd53fc8835253ee2035",
"main.dart.js_277.part.js": "ed3a9cf889d7eb41dc69d644d9fa7f31",
"main.dart.js_290.part.js": "2b3951ffe5595b6441eb7c9906ae3061",
"main.dart.js": "d4ce4e4f4ba2dfcc1cfdcf84e94161bd",
"main.dart.js_239.part.js": "fef89f8faee3895295bb993f43beba08",
"main.dart.js_224.part.js": "41300bfd44ba529a85c9418796a1eed3",
"main.dart.js_271.part.js": "6df744470b054a53cca8c281cfbba3a8",
"main.dart.js_243.part.js": "b1fea42d139e14db23935c90a5089bba",
"main.dart.js_286.part.js": "8cde339074a5fe35a6fb069d814ac15e",
"main.dart.js_283.part.js": "defc74d1fde7509083f73e9b7143c93f",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_198.part.js": "9b333c5b2b675236d2787c2c3f51f096",
"main.dart.js_187.part.js": "8fca80868d29ddeb9eded44e39eb3147",
"main.dart.js_272.part.js": "b7f41537e5bc28dc7e86e3c35414b721",
"main.dart.js_285.part.js": "7546bc1b5cc8a8988113f138efefa7b6",
"main.dart.js_237.part.js": "2389ec9cbfdd6b98f452f630de6fae96",
"main.dart.js_200.part.js": "cbeb7c62299e129c33641f33b0a3e503",
"main.dart.js_238.part.js": "b4f163d20e0d0e6dd4ce7003c8e966c4",
"main.dart.js_249.part.js": "b51dc5b248fee0a9dbd6e1d770e34cac",
"main.dart.js_276.part.js": "356df7db25ea8c07bc4931eccb2ae83b",
"main.dart.js_2.part.js": "a7c31869b11d6985a6c916e700b8fbfd",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "13a211539d770ffdc5e577672fa26c41",
"main.dart.js_258.part.js": "921a17deee1bf461a434c127dd0c7e8c",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/MaterialIcons-Regular.otf": "3553c97d29ac4ccffddca6374f10e441",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_289.part.js": "4b368aaf9bb291646ff283d78bdd9fdd",
"main.dart.js_185.part.js": "a9c79dbab93c76c776a5e20b9b69ce60",
"main.dart.js_248.part.js": "ef2d57ee29a4150a769ff8a118c14398",
"main.dart.js_15.part.js": "f2ceb0cdf4304606a51c1b74674f0b74",
"main.dart.js_274.part.js": "55a3e4f65a846799c381a66e5f34600a",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "09886b1136a5519de0996d93e40632c9",
"/": "09886b1136a5519de0996d93e40632c9",
"main.dart.js_270.part.js": "26b3144e900247ccab4cf12845a68f11",
"main.dart.js_267.part.js": "ffdef059ce6544b36bb0e10243314377",
"main.dart.js_236.part.js": "705939125a629ef7e63fb49b1b95cebe",
"main.dart.js_265.part.js": "1d4c173a22eee11b6737f064b6f2101c",
"main.dart.js_234.part.js": "a26f517d024185b09169f9dd1f2ef5cf",
"main.dart.js_223.part.js": "b749c31fa48995c10356de8c2292d068",
"main.dart.js_232.part.js": "fc4c9ec5b73fd87619ad221314bdf0a9",
"main.dart.js_209.part.js": "5f5b42df2f5ef7b8d1c4efdadc5b42f7",
"main.dart.js_269.part.js": "d0757a9f96b5bf39da95ac1436bfac74",
"main.dart.js_275.part.js": "b4e09620156f1c88eff38d0b9e305c41",
"main.dart.js_263.part.js": "754095ad6fcd37ef15f61215346bb5e9",
"main.dart.js_287.part.js": "e3b980836e08374f2849dc526bafbbca",
"main.dart.js_199.part.js": "b90c6859db1c76e0d9cc11547c8bd8ad",
"main.dart.js_215.part.js": "2ff856283244c295dd3d07dd1c06f2c1",
"main.dart.js_256.part.js": "fa38c0c4e5e1d13a029881ee0f0c8873",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_281.part.js": "a9d2fad141af1840d9684206bb427b60",
"main.dart.js_1.part.js": "0cbd3ffcba7ada886d4074bacdf8c426",
"main.dart.js_268.part.js": "d5e56295491136951ba6552643c612db",
"main.dart.js_242.part.js": "7f94002cfcaf4d4ffb7f69fbb0534536",
"flutter.js": "76f08d47ff9f5715220992f993002504"};
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
