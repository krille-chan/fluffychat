'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_291.part.js": "917d589944fa214e917e0f322250660f",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"index.html": "f4af24864279a7ba90a82703996d7af9",
"/": "f4af24864279a7ba90a82703996d7af9",
"main.dart.js_236.part.js": "8993c980740afd3c2174b337a575e5dc",
"main.dart.js_279.part.js": "63b50ab9841d143a3b914a1adbd446a9",
"main.dart.js_295.part.js": "b1f5ca9fd794742db55f49d66478b4dc",
"main.dart.js_1.part.js": "76090971d921f84a84c9d36099bf36bc",
"main.dart.js_276.part.js": "8b26d20fff8688514c47c0e8270919c5",
"main.dart.js_2.part.js": "e6dca35ffbfa1a79742b13f097b90e6c",
"main.dart.js_219.part.js": "32e1c5e2d18880e54f16a42cbea32c68",
"main.dart.js_271.part.js": "e9fae6908dab1ddb1e77e39d423ecfb8",
"main.dart.js_243.part.js": "d8ef074836c5aea55f7026a4496c64de",
"main.dart.js_191.part.js": "75193355123edb66690e7e6f6364bf08",
"main.dart.js_253.part.js": "6fadb866f9536fdac3f6816b181dd7bc",
"main.dart.js_246.part.js": "331945b89aad5734e18a9d5b8a983244",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_290.part.js": "149666a8ca8e82bfbdaec79d78b47fd6",
"main.dart.js_289.part.js": "74911919c60d14736d60ca3067cf96fe",
"main.dart.js": "3d163e720cb437c05a82ce88a11fe3b7",
"main.dart.js_273.part.js": "10051c95dad633150c99b760085b821f",
"main.dart.js_278.part.js": "0ec4a1a55ef6b09c8dce331ba02bd389",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"main.dart.js_203.part.js": "c802dcced13f6c9ed81fb18bf5566df6",
"main.dart.js_241.part.js": "c16c3e0b517873969fe37f96643c6d11",
"main.dart.js_202.part.js": "5f4187328ab9af2a86b4c5cc71f15a40",
"main.dart.js_281.part.js": "d2cd39b189bb53632807a0fcb24f0979",
"main.dart.js_240.part.js": "46e48d1752a20c6bbcfec2aca48a1864",
"main.dart.js_228.part.js": "738d88844ee8fc6d85f8719912ed5cb3",
"main.dart.js_231.part.js": "afdd0b3e3cdad7400592e6f7c4f87d0e",
"flutter_bootstrap.js": "1a25cf9417e0ab18e8955626307ac7b2",
"main.dart.js_280.part.js": "2e72fc81b44ba2ce62cff613c02d4a05",
"main.dart.js_238.part.js": "26aa8948af19a76220444450eedbedd7",
"main.dart.js_286.part.js": "48d489d073eb035ddead3a31e705c07e",
"main.dart.js_262.part.js": "29bad3a66b40524c2ec5ee2982b10e60",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"main.dart.js_274.part.js": "b8b631dcdd4383b84a2112dc7a54802b",
"main.dart.js_189.part.js": "fa6971c5e757425c00b909e7dbd4b684",
"main.dart.js_15.part.js": "9a9178f3b697193523138beaeb6cc861",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_251.part.js": "8e5c75d38abdd1dc2cb3cd6d4511165f",
"main.dart.js_227.part.js": "bb72baa5e44513841845a97c3036dafa",
"main.dart.js_204.part.js": "ef248361a982ed5738355385c7fc8abe",
"main.dart.js_267.part.js": "4692a095c6bcdd41f9a3f5b3c14ecb90",
"main.dart.js_242.part.js": "b1352d1ce4332bd3dd64c277446230ea",
"main.dart.js_229.part.js": "e6b6d9befaca8978b6d5a7a4e5342838",
"main.dart.js_259.part.js": "4cfc83f6996dbbe8e8964328a5c9d763",
"main.dart.js_247.part.js": "94604400d0a0fdf1d2126a8f50f376f1",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_287.part.js": "67a715b051a636f87d0e03f8d7d65e30",
"main.dart.js_292.part.js": "053493124ecf07a1f28dc654122ef1e0",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "9f4c6848f06fe55b64ee4a287246d084",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/NOTICES": "c8db5451253889809a6111899405e058",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"version.json": "9e35f3ded4f3cc3cfb8043a1a528ab26",
"main.dart.js_275.part.js": "5ef69eb4d9b95a809fda9be08c1655d2",
"main.dart.js_272.part.js": "b03a0ca48305c725d5489a5f91070266",
"main.dart.js_252.part.js": "02bf9880668022df416243ec72ef399c",
"main.dart.js_260.part.js": "d5d86d123d8220001890d3a701b1a398",
"main.dart.js_285.part.js": "3fe639a775b122ebd1eca828205a4990",
"main.dart.js_213.part.js": "4bd4091fc309caa6fadf52f3997b0885",
"main.dart.js_269.part.js": "2eb88b64645b71777d64381c707c9778",
"main.dart.js_293.part.js": "44e0102dae759cd50fcff9c48ed204b9",
"main.dart.js_294.part.js": "eb8d3e4a805a69a0a8704374727b6939"};
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
