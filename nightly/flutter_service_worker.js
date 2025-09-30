'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "2f2c52652f09a5f44c16ce47976db321",
"main.dart.js_271.part.js": "22e13a4c6907c99114bd4db0bd46bb8a",
"main.dart.js_259.part.js": "5cd14387aeea8f64938f0fa0e515a925",
"main.dart.js_297.part.js": "085cf309e0123ea268caa4f6b06fd4f1",
"main.dart.js_1.part.js": "99531a4c99e2588acf6bab73bace1ad9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "f4a1387af3bfaedbe4221def2571048c",
"main.dart.js_318.part.js": "6b3c10a8e9120ec83387f42356952418",
"main.dart.js_214.part.js": "017fb809806d35e7309b0d514e3a3756",
"main.dart.js_295.part.js": "9051af04b3cd93278c936a4b7f4eb2b8",
"main.dart.js_316.part.js": "7747c0ddbca0fb6f51315f9b86646dd5",
"index.html": "e2b9e0585b88d40da960a2e945afe487",
"/": "e2b9e0585b88d40da960a2e945afe487",
"main.dart.js_302.part.js": "4204d803e7e33bd45cdbca16e86f63c3",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "97b733b31154d174a1d772508c1102c8",
"main.dart.js_244.part.js": "8596db99909d42fd8e95bc05bfa9db6a",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_265.part.js": "3ec94219f61370b2d091cc28c7b6abff",
"main.dart.js_300.part.js": "546852f08b9ae3faf2d6fbc2c601f0de",
"main.dart.js_322.part.js": "b227d0caaf02c8f4e1d4d34910cec0af",
"main.dart.js_263.part.js": "7dbff99f4ce071479178a763c217e869",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "e806e986eee5c070e11bea9e372c0d97",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "c5642cee57cdfc0d5de8a8177d9b25ea",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "b079362e6002ca84d244747e7ba715fa",
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
"assets/fonts/MaterialIcons-Regular.otf": "e43537443dee303909d6ef653cf99252",
"assets/NOTICES": "aa2370633cecf22a3a49e1911f8cff6d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "43131dff8beb66e182c6a01f8e0468c5",
"main.dart.js_247.part.js": "22fb94c45151e7551745e3adb33edeed",
"main.dart.js_16.part.js": "fe540ade3171c482a71777f325c496cf",
"main.dart.js_303.part.js": "bd15b72b9c381c133cf8f9b1a9f62128",
"main.dart.js_287.part.js": "ddf96a8d5652ec2134969987a033e4ff",
"main.dart.js_257.part.js": "cd3843da0230bfb8aa907ca3702c589c",
"main.dart.js_290.part.js": "23efc147bcb4a7b63616429ffee1f931",
"main.dart.js_212.part.js": "413056fec5bcbe27aba28ca324ae8531",
"main.dart.js_269.part.js": "d06146c38333ccf7ef0a298e7a7d2ac5",
"main.dart.js_267.part.js": "e2fc8e88cf6866919efc9ee68b9ce539",
"main.dart.js_309.part.js": "3a52d42cda6c00c2942075489fc4d4a0",
"main.dart.js_325.part.js": "9a30bc09270680a695c5c2ca088cd18b",
"main.dart.js_270.part.js": "55ba17cf378381f60f06da0a25b778b6",
"main.dart.js_321.part.js": "ec079118a00c6601ac1a0d688c5b396b",
"main.dart.js_255.part.js": "79db1b5c4679df32ce36b0450f75c6c9",
"main.dart.js_275.part.js": "7fb1e2aef78cdce8a9d67d1bae285d20",
"main.dart.js_281.part.js": "b74e09fefd1c28cefcd3a2a8df214c08",
"main.dart.js_288.part.js": "c9363db201cec3212b74b1b646c72964",
"main.dart.js_314.part.js": "15e3c3adf41b6eac84964f128d514175",
"main.dart.js_307.part.js": "8eb5f6a37cb57dd1ed73c52e72cf0a0c",
"main.dart.js_279.part.js": "e473948cfe933a7bcb981a0753d1ccbb",
"main.dart.js_319.part.js": "c79690dd54fa06364fe3d42ecfe16333",
"main.dart.js_323.part.js": "f20aca5634cdc6fb6ceeeadef9845488",
"main.dart.js_227.part.js": "3fc6537edde2ab786f7c411671854dae",
"main.dart.js_230.part.js": "0dc8c973083d6897c7693b06fb138528",
"main.dart.js_324.part.js": "b0a3414eb9c32f71f06ae6acab2c9203",
"flutter_bootstrap.js": "47a040bbb0e44ca064d9ff3839711df1",
"main.dart.js_315.part.js": "6577da4e5691e322193a02dd1925a6ad",
"main.dart.js_304.part.js": "5efe8412c4e33c6755a0b4fed1415da6",
"main.dart.js_276.part.js": "ff78f4a82cafd5e01a798b0fd62e3417",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "2d8196d31c4c3727cbd3364b58630166",
"main.dart.js_222.part.js": "54b24e4a67ffb51ca6cbc88fb6041306",
"main.dart.js_238.part.js": "cce8bd7b6fd0b43b19c5d55def880cbe",
"main.dart.js_256.part.js": "e3edf762b88e770070d481f5a29c90f3",
"main.dart.js": "a999402bb73216d614ac53861e6c2dd6"};
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
