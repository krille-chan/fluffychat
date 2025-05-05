'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_204.part.js": "adfe8654d9c49922e7565a4ea06ef560",
"main.dart.js_230.part.js": "e5cca3af9c1aca43fa295bd1f03482f9",
"main.dart.js_287.part.js": "42377733e6cd7e4a2d5220670c7f9f61",
"main.dart.js_244.part.js": "275b73613a3f5ac63cfc0eb5f601627c",
"main.dart.js_286.part.js": "7cf9b7f918825b539445fc19f05ca5a7",
"main.dart.js_229.part.js": "edf1cb62723da48de0b9ff373a292d3f",
"main.dart.js_241.part.js": "d30ce151bc874e22f2a5abd42229e225",
"main.dart.js_237.part.js": "91223061a7688120dab16df3dcf0fdec",
"main.dart.js_220.part.js": "320054785f571503f1cdadbde3814501",
"main.dart.js_290.part.js": "4f5faf8c71e2cb3a2fb0ca9782695665",
"main.dart.js_260.part.js": "2c9f4215e74f3ee4c6e3af3b1eec88f4",
"main.dart.js_296.part.js": "9c7303064bb0f1c58c3a47e982822d61",
"main.dart.js_263.part.js": "cd72977850fd86d148974e8fbdf3c129",
"main.dart.js_294.part.js": "1840287b56070c433f71ecf7be430f7a",
"main.dart.js_228.part.js": "ae151daedc6fc652c6086a80948121e9",
"assets/AssetManifest.json": "a1253d1a66d540724635213afe489056",
"assets/AssetManifest.bin": "002b21ac1c4e3934c8ab6ab9e39ddb52",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "63e13f60bb285d5cd62af8bcf78cdd6d",
"assets/AssetManifest.bin.json": "fb071ee11f921dab7eeaf2599e3351a8",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/NOTICES": "2491914354abed5de92dc774322c614f",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"main.dart.js_268.part.js": "79fec80adb1f44789986b4a2611885af",
"main.dart.js_282.part.js": "9cedd16b5b3200cc944fe951735035d0",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_275.part.js": "ee4b6b6ca00c1dfb9522fff2d5703408",
"main.dart.js_1.part.js": "3120e899f2bd8eb4ad0f705905eba3a6",
"main.dart.js_214.part.js": "3f007843f2de16c048f2995ac5a76847",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"main.dart.js_248.part.js": "fbc9d2fe3a30b67a97c5048307e6bc2d",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_15.part.js": "cb64760cd2c354ec620dc02c00a8a552",
"version.json": "bab3af646225186c2ee572830da047a7",
"main.dart.js_272.part.js": "71d8cb79846bf9fbffbbc235f1d61791",
"main.dart.js_295.part.js": "0f4b2d991dc07a402afe30c5208d1edc",
"main.dart.js_205.part.js": "64cd332e77812ddcd4ff44d7f141a7d1",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"main.dart.js_247.part.js": "10028e28a61b55aef99e4e31ab566c3a",
"main.dart.js_261.part.js": "b54df08b5e6d681521bc3fe2dc77fce4",
"main.dart.js_274.part.js": "87d15813c0d12993b4a96bce967038f0",
"main.dart.js_203.part.js": "07fff7f428e2262cc300b2b546d73bbb",
"index.html": "ed4be64a16588051efa617d7a67e66cc",
"/": "ed4be64a16588051efa617d7a67e66cc",
"main.dart.js_242.part.js": "cf5f7275b822f4db2dd6e4787f69aad2",
"main.dart.js_253.part.js": "902829b986c979d41c2415fedceac12f",
"main.dart.js_2.part.js": "592e2eb79ae9438140c44b3f229f799b",
"flutter_bootstrap.js": "889b971404522249babda1de9b6438d3",
"main.dart.js_232.part.js": "6bc0b0b304829ab92286bd37ccd8405a",
"main.dart.js_281.part.js": "dfd0991dff0cbcef4391f5b20870eb81",
"main.dart.js_190.part.js": "43210e32132cc4f7a0739e03549cafeb",
"main.dart.js_192.part.js": "995f19419d4397a2ebe586da918d6698",
"main.dart.js_279.part.js": "dd1c4ecd4e6aa086d742d2baf0550559",
"main.dart.js_280.part.js": "9e12e6f30a94a59a1b6053d2a88fb203",
"main.dart.js_291.part.js": "71749c61bae20deb8f567c5c9e3dcce3",
"main.dart.js_273.part.js": "cdde578186adbc9679785e7ea9da9008",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_243.part.js": "f2cef2ae4ed35c5118dcb55b0be71e80",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_252.part.js": "dfd5c2d7e0136c6d0706ac98234a8fbc",
"main.dart.js_292.part.js": "a80f19fd5d2fb3134d2b88017254f0f0",
"main.dart.js_288.part.js": "e8e96296e3d46435116b716c54433493",
"main.dart.js_276.part.js": "2b57eb70b2ca657473dee22771188756",
"main.dart.js_254.part.js": "1dbd3003b24044a46f14fbb0dc91542b",
"main.dart.js": "46bc6d74d0f0d051a294df6e1bbce892",
"main.dart.js_239.part.js": "eb809c13bad15b08c7cc622b4119c350",
"main.dart.js_277.part.js": "8c9e0eb87d54026f1c2cc6d3fb1c1eb3",
"main.dart.js_270.part.js": "37fc2981f3da96d2afe913c436601dcd",
"main.dart.js_293.part.js": "75388f505c68897ed7f8fd5b5f678f28"};
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
