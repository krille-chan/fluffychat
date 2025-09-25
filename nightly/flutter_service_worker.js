'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "d8f14fcaf4439f10c570b5dc542508fb",
"main.dart.js_271.part.js": "e2dce4ef4857cf755f676cdf82326684",
"main.dart.js_259.part.js": "9704badb59324f6e6df0c2f213257f3e",
"main.dart.js_297.part.js": "84ba91e41e2f038d1ab5239d772156b5",
"main.dart.js_1.part.js": "ea34528453b7576b911ddcfad650cc17",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "34e7b701b7e6b1b405ddd7feee623f3c",
"main.dart.js_318.part.js": "7cd5301e40163e28666841c952c4498d",
"main.dart.js_214.part.js": "46ebe8be2c1a46ca0e78f7f3582092a3",
"main.dart.js_295.part.js": "d9daf691c1f04846f85e371437f89abb",
"main.dart.js_316.part.js": "73fcbf80c88092e57b54210946f33047",
"index.html": "0921fad60c6daa71fbdbe2d3b54c6dd5",
"/": "0921fad60c6daa71fbdbe2d3b54c6dd5",
"main.dart.js_302.part.js": "2a0cf0ba8470400e0f3f23027d9e8df7",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "af364f5bf369c543b8340674900668d9",
"main.dart.js_244.part.js": "b8e1b758949be36c7c523ae45f6905df",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_265.part.js": "c79694a9920c4bab9712bb2b6dff8907",
"main.dart.js_300.part.js": "147d1d24f0cb610fbd232f8f1d98c0d0",
"main.dart.js_322.part.js": "36389c572ab5abea1a4864da5c1b1612",
"main.dart.js_263.part.js": "27367e387779ddd9a99b807164cff3c2",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "7e4eb011aa3b2ef4d686fced60070858",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "d2ad81798d30a17607f7caf65c30b790",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "2f8496558e2fc1c9a376747dcc6fc39b",
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
"assets/fonts/MaterialIcons-Regular.otf": "c1952a9d0b23a8a46a56f2d315849195",
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
"main.dart.js_320.part.js": "3cafda0210ce1943f8ddb13c4160d0a3",
"main.dart.js_247.part.js": "516d9c4dd890031f522cc0e7ab0cad2c",
"main.dart.js_16.part.js": "a4458264ba4e4151ccf671969fc85b51",
"main.dart.js_303.part.js": "a2d49077a2715faf991c8e8c8e62cd4d",
"main.dart.js_287.part.js": "9d7c35cf42fdff2b8bc05801cc4d54ca",
"main.dart.js_257.part.js": "341f6e325c6988ce70ac4c1a87c80530",
"main.dart.js_290.part.js": "ae54dd832e5a19175f2d5574e9f72b95",
"main.dart.js_212.part.js": "267fc5d6eef9d557b074e891287fb6d4",
"main.dart.js_269.part.js": "c6d57f4ba69742d21c0081dfc1d8483d",
"main.dart.js_267.part.js": "d2c7b87be2ada1c820b79d2008a9fd0f",
"main.dart.js_309.part.js": "5c0b1f1b330dbefd1608da88845c25b1",
"main.dart.js_325.part.js": "8c44b01336a66ccfbe22ffc2d1adf758",
"main.dart.js_270.part.js": "a0db4978960b192ad2c1065dc0174848",
"main.dart.js_321.part.js": "f547d42678b585319ae277375d6cc7a1",
"main.dart.js_255.part.js": "5b58f0c42dfffb8ab25c64a47d1b5805",
"main.dart.js_275.part.js": "7eb42c97e60e003e57ff6b4f571dc65e",
"main.dart.js_281.part.js": "9d6cb5c8e7ab1b31e97cb8f9cc34d99f",
"main.dart.js_288.part.js": "924d36a868cf4af0d942e2cd5f994844",
"main.dart.js_314.part.js": "ec09265cbf93151a46b1cef2c7caf329",
"main.dart.js_307.part.js": "b1969b9a455a75a6f84b9724d84cb1c9",
"main.dart.js_279.part.js": "3a8703728543b0ec4e6d60b427bec95d",
"main.dart.js_319.part.js": "8b98f5703524925d4c2b4b7558fe1e96",
"main.dart.js_323.part.js": "e10b51bf3530d4694626a29526349847",
"main.dart.js_227.part.js": "a904d0bab99442d1b54c1f81a0f852b1",
"main.dart.js_230.part.js": "df0006375e36715c663d359b68136f10",
"main.dart.js_324.part.js": "e94c2e145bb44d17e34d049e52292140",
"flutter_bootstrap.js": "52388060bfdc04904571492b8c053bbf",
"main.dart.js_315.part.js": "d98cc521c943b5e38867315ad621d0ee",
"main.dart.js_304.part.js": "f1920125170daa18c38551b376a4dcd0",
"main.dart.js_276.part.js": "6cdb2215266f32cde9115f56fe8998f7",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "c241457c509e701b16864f0cfce20c80",
"main.dart.js_222.part.js": "f87b2053ffd65c638bd310b529bcc315",
"main.dart.js_238.part.js": "4789e6b521bba0e0637b129b0944a116",
"main.dart.js_256.part.js": "e56997285dd34645f9fc61ace09e0044",
"main.dart.js": "c8abe5cdf54f1788c5c676adeb982934"};
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
