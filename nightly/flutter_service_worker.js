'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "5ca7cbc397ac72e8ab94e13f69e26566",
"main.dart.js_317.part.js": "a91680b222eb23c701e15d942d0cc458",
"main.dart.js_1.part.js": "1a7d215f8238165c7d647169aa7eaaf0",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_245.part.js": "4fa26942c66bab51b24d50bc19e62522",
"main.dart.js_274.part.js": "5c41aea6a3efefa121697eba3275a0a3",
"main.dart.js_318.part.js": "8ce9fe10f24a55d8a9a1620a2dedce47",
"Imaging.wasm": "92192c7e5e416a2d637b988fa300b308",
"main.dart.js_295.part.js": "67c4b90b97ca952192d49599048fcd19",
"main.dart.js_316.part.js": "8a641826919e9c3f719bf7f1fea87b90",
"index.html": "f98d1ed5a159cf4c234590c13ab4de0f",
"/": "f98d1ed5a159cf4c234590c13ab4de0f",
"main.dart.js_302.part.js": "e6204be63d6549815fa11adfef8cc100",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "ea49fb6c42d21438db0f1f8c08322941",
"main.dart.js_242.part.js": "ccaa9b5cc97fbaaf7ef2096cc6e693f9",
"main.dart.js_2.part.js": "98fb93192cc009678bbdcf4e329f05b8",
"main.dart.js_265.part.js": "64572462dcfaa1f3442085bcb01daa2f",
"main.dart.js_300.part.js": "dec2406b426adcdb3299f949e0e90d00",
"main.dart.js_261.part.js": "9fd1228ae958d753f43bbda135ee37c6",
"main.dart.js_299.part.js": "b253d02a12fa70e103c18f224273778e",
"main.dart.js_322.part.js": "6a8d07c17aafad694b8839fdc8e7daaf",
"main.dart.js_263.part.js": "e2a1781afe9bf46b927d7fae6151cb88",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "baf5e08a6b6f17099385daf2333dd8e2",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "8bb21a3080f8d4866af34c8ba3567ad8",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "abd5af5a6dde52a998947de795b59f4e",
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
"assets/fonts/MaterialIcons-Regular.otf": "dcbfcd0ad87719587d4c30aa823f5795",
"assets/NOTICES": "6cfe799430e6c840c30290f71ccbac3b",
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
"main.dart.js_320.part.js": "c0b142634a0da95913d9e28b1c74ed4f",
"main.dart.js_254.part.js": "0c883f7985dccd6d2b152557876b8a35",
"main.dart.js_16.part.js": "e1f73c7e273cefcafc96f1a21015aa80",
"main.dart.js_278.part.js": "acdbad7ed2a16d86f8ae25b5c7829816",
"main.dart.js_286.part.js": "340d23a4afcd4e8e1d1ef8f8565c62fe",
"main.dart.js_303.part.js": "66d8ed254c1b6b57c0a12129eb3114b2",
"main.dart.js_257.part.js": "31a5089345de87cb5b011af462a95e8e",
"main.dart.js_212.part.js": "8e86a4bab79b00c9ba5c662271186afb",
"main.dart.js_269.part.js": "f060ad600fd2ecdd55e1eb33fd049519",
"main.dart.js_267.part.js": "8af995b474eadc68a404d51c248b3a68",
"main.dart.js_313.part.js": "2f3c73156c2baa37b94d15fc0a8c2b15",
"main.dart.js_312.part.js": "e60c5bce0922d77ea832136947c68845",
"main.dart.js_298.part.js": "4d3fa13a4e5e31df43bbbad1581c26dd",
"main.dart.js_285.part.js": "130a4fd67946182a3f03d20ad0419d77",
"main.dart.js_321.part.js": "f553a624e44915c3ed29867824cd48e9",
"main.dart.js_273.part.js": "3f0b523b578eb0af68fd56be8d786b5a",
"main.dart.js_255.part.js": "9531d1e419b5e6a6976c08d3bc1b5e30",
"main.dart.js_268.part.js": "c16b6f7bcaac71a63df39c46cb7d3726",
"Imaging.js": "512e18635d810cc5fecec00776060a22",
"main.dart.js_288.part.js": "ea280423ba0af22a168455c8911efa6a",
"main.dart.js_314.part.js": "d3e677b99d4fb08618ad3c3751f0d5ae",
"main.dart.js_206.part.js": "eda0c32220efe5894c7b5a2963ef4243",
"main.dart.js_307.part.js": "6105447ff0c7daaf1aa2de2f2fe5da1e",
"main.dart.js_279.part.js": "de5a516a3fa0330655376bdb565605e8",
"main.dart.js_319.part.js": "ca443f7d52bc11bd10a20b506c40ed8d",
"main.dart.js_253.part.js": "0ccd855328965feb224fa92e49abfd7a",
"main.dart.js_323.part.js": "b650a41fc9266763f334bcd2fdd52ebb",
"main.dart.js_227.part.js": "31cb535935bd716e466920672067abfe",
"flutter_bootstrap.js": "31965d7a68eb1728743f457b8636371a",
"main.dart.js_306.part.js": "89126daa724d7f16fb448ac7288fb08f",
"version.json": "4ef943cc4d3cfbc38c21a42920866639",
"main.dart.js_293.part.js": "4e1337fa22581b3d510d55578ee3f786",
"main.dart.js": "c4e2f49d213983a3c9d98e2eda4250e3",
"main.dart.js_224.part.js": "124f4213562c2a6fdd34272992d9aea3",
"main.dart.js_204.part.js": "a41fec884e8edfbf9589a90130c78f25",
"main.dart.js_236.part.js": "3556cde5e35ce689d8c70f0deec083e4",
"main.dart.js_277.part.js": "66c0fc50c19a50ad6a9c82ffa4149c99"};
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
