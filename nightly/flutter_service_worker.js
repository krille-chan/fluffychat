'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_314.part.js": "9e5f402ab4b2111b4e39ad2beef4050c",
"main.dart.js_300.part.js": "163e682779884a42e0f4af62bd71d233",
"main.dart.js_280.part.js": "d5f1f31de8a312553a786a68b3761b8a",
"main.dart.js_324.part.js": "f18671768969f2fab6763b11677467b1",
"main.dart.js_301.part.js": "2bbac4312258d672ac0edf8704c95301",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"main.dart.js_308.part.js": "d059650cd5862a66bcc1e14d6c9327ba",
"main.dart.js_287.part.js": "66a138a667d5d57b6b1f7659821138e5",
"main.dart.js_275.part.js": "9997a291f82cd6578e944db95fa1dc63",
"main.dart.js_303.part.js": "db31194b9cd023f02139a68b0e19f010",
"main.dart.js_319.part.js": "680b6338566ac3c5c0ef99f3636cfb36",
"main.dart.js_221.part.js": "42055596c4ef5b35ac108d21f2571c74",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"main.dart.js_237.part.js": "ba7c142251c511270e727fe476e28083",
"main.dart.js_279.part.js": "ff41745165702537cc7aeca5f23bf273",
"main.dart.js_289.part.js": "d681213232415505d5bc277b2e5acbea",
"main.dart.js_302.part.js": "3d11deb33c176dc65abc5bb831c0d5af",
"main.dart.js_269.part.js": "7e9ecae7527c44f3f6a17e5c0f87b6c6",
"main.dart.js_229.part.js": "ba66b467f120edc57096de2eb69c2435",
"main.dart.js_304.part.js": "5989d3787c5013bc8a3eb355de39b4ba",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_318.part.js": "befcc46fd4080561197d2fb64095c643",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_254.part.js": "285e3e9b63c00540d16a9b9c43a019bf",
"main.dart.js_296.part.js": "85dd52a5b3245011b467c8fe0da3828c",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_270.part.js": "3914b4dc67c9474e8d0631ce53faf06e",
"main.dart.js": "3f32376be92914a7ecf73cf4ca1d2ce0",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_274.part.js": "2be86e80bb135a79f68a894bdf2a06e0",
"main.dart.js_246.part.js": "8223ed8d98308fb9597e1e141d8ce8b7",
"main.dart.js_1.part.js": "c2ee58c907952fae353b7f65f1dae519",
"main.dart.js_211.part.js": "95cd5096d741a3fb234190fd5566fc30",
"main.dart.js_294.part.js": "dfbcec97dd00a427012cbc86ae801483",
"main.dart.js_320.part.js": "c5d6db5d2f86309dc80ceca4b67ca943",
"main.dart.js_313.part.js": "b39904613486a45844fca78737b94ba1",
"main.dart.js_213.part.js": "f34cce8ea157ff5c6ef166cbbfcca7af",
"assets/NOTICES": "8f95d94aa1cd8d8aa709c91812aac7ba",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "7b8a1d6337082fa0b8eb4b9f8d23fb97",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "2bc4a85cceb498d973ff8028feab2ad7",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"flutter_bootstrap.js": "c9e756d2e06ba510d6adc52baea4cec0",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_264.part.js": "916c741f7e39d353973e311b19efc305",
"main.dart.js_321.part.js": "60a0c00be27bbec854f440b9ae16a883",
"main.dart.js_286.part.js": "b7e970c8de0ea9dfa5324f85bfbb2c36",
"main.dart.js_256.part.js": "b37c08a941cb0e98180c8b598f22fb21",
"main.dart.js_268.part.js": "cdb451ecaf408178dc9d91902137a440",
"main.dart.js_255.part.js": "b271b2bb39dfb0afc3ff24f910bef076",
"main.dart.js_226.part.js": "e68fa47898d64fb06ba90d41834a8140",
"main.dart.js_266.part.js": "13a70e3634a61873b60b90866b0a38db",
"main.dart.js_278.part.js": "cda3f130d68c723191c1b8d926b06fb0",
"main.dart.js_323.part.js": "600e50b770f1c4e77d3f498a11c25f55",
"main.dart.js_299.part.js": "8d2cb49229708708d4858ba10b6019ba",
"main.dart.js_16.part.js": "5e41abc3ac24eb47bd19064fead9e5a9",
"main.dart.js_243.part.js": "30488809eeb1370cae9f123539b7d283",
"main.dart.js_322.part.js": "2902af25f0393ad1844f72efdd6961ad",
"main.dart.js_258.part.js": "bec85eef1c75eee1fd58e3709a1d8c3d",
"main.dart.js_307.part.js": "1c62c0afced64bdab3c59a01540ace46",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "7fc6b84ffbb69a195a3f711068026d8c",
"/": "7fc6b84ffbb69a195a3f711068026d8c",
"main.dart.js_315.part.js": "cd0e330dcb6d939a0b3cfaf5404cc0b6",
"main.dart.js_306.part.js": "d5281684d7a1f73b81a0cd24b395c4f8",
"main.dart.js_317.part.js": "949b3e53f2b1fd0f8db41ef459fb6d27",
"main.dart.js_262.part.js": "818f6ee2608a0d3fbef2ea2fe219251c",
"main.dart.js_309.part.js": "3e0f2f4b00f0b3271acf42220f19ac5c"};
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
