'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "5a1fdec17bc8d60f89899aacac6ed5bc",
"main.dart.js_317.part.js": "7f6b4a5aa12aff2a71a75010b6930eab",
"main.dart.js_243.part.js": "44d2ee44aa3db67df9d188ce424cdae1",
"main.dart.js_1.part.js": "4b79bf502cff61d799ed04f1d8854b0d",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "8f6ff16aaa51b9e933c3c8204aa9ee7c",
"main.dart.js_274.part.js": "6575b4e58ba817aa1f687dace8334974",
"main.dart.js_318.part.js": "1acef6ec4f79f7d86a11fae7e763cb94",
"main.dart.js_211.part.js": "32d3339eb71ce2f9f1fd1306ff59f88b",
"main.dart.js_266.part.js": "ed0875a6568c29fa632107100ae5b62e",
"main.dart.js_246.part.js": "dbad1845de143454e6d7a5c076729b20",
"index.html": "066232fe0922678c0807d427a6260ff1",
"/": "066232fe0922678c0807d427a6260ff1",
"main.dart.js_302.part.js": "7334ef2486795d4ffc4862368c797061",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_258.part.js": "811f7d7f48b1e4a5e53fa4e6fa26a42a",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_294.part.js": "eb353a17654d2bdbcf347509474b0813",
"main.dart.js_300.part.js": "6d79e58d111a110fb64a129337c91bcc",
"main.dart.js_262.part.js": "43b071c40725208b87f9ee325093ec6d",
"main.dart.js_299.part.js": "a0938fe3d707c64f0b86f69cd4078989",
"main.dart.js_322.part.js": "71130b2ada3bd97f9299d98f5ecc3af7",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "451855c2b09df733ba01ccdc89ae5f03",
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
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
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
"main.dart.js_320.part.js": "5c765b9d9e72155973389cc593d6b869",
"main.dart.js_254.part.js": "f1b2a7b16d168f203e25dca7e1553917",
"main.dart.js_16.part.js": "25c61cbd7386c408300249a0f8c8ba39",
"main.dart.js_296.part.js": "0d2a58ff709730b64aa2a57dd6ed5dee",
"main.dart.js_278.part.js": "7f0ca49f43f288e56ef5bf548ba157ca",
"main.dart.js_229.part.js": "03c3bbe11293e5f61cc90fcbbef98c1d",
"main.dart.js_286.part.js": "6dc4dd509444b67127b5f322885e0cee",
"main.dart.js_303.part.js": "9f842160d0bf49b98f621d1d0cffb512",
"main.dart.js_287.part.js": "5882a2e0ec07fea5e9e8ea239f214f21",
"main.dart.js_237.part.js": "a229f09aadb5436f3a9229360c2e4c9a",
"main.dart.js_213.part.js": "5bed5d70463f153b60ec93a589a22535",
"main.dart.js_269.part.js": "a6c56589f56c799903218a3902221d26",
"main.dart.js_313.part.js": "a27752f51608819eb8a33f0367916380",
"main.dart.js_309.part.js": "3da9eb3ef7acb7b902525e03e4d093df",
"main.dart.js_270.part.js": "162a5ba5d6a6dfb0e184cf169ddae0ac",
"main.dart.js_321.part.js": "cf9249e9830ae2437a98f741fd324863",
"main.dart.js_255.part.js": "1263cbbc03ce7b77c116f9af0ed698db",
"main.dart.js_268.part.js": "2f3a8ef7c2683b4932597f218374e6db",
"main.dart.js_275.part.js": "9b865324d61ec2633be45a229b65567f",
"main.dart.js_314.part.js": "7dcadfcfd3c61ca9fd38eff4335efb19",
"main.dart.js_307.part.js": "b380d02e2b33ae67a671b36d2f0b262b",
"main.dart.js_279.part.js": "f1a7f46058c82f3b40d4c50de82003cf",
"main.dart.js_319.part.js": "a1d400547d1b2eb5ae99164291166382",
"main.dart.js_323.part.js": "22a5b429ff7d834e64f196b76d39a0d6",
"main.dart.js_324.part.js": "a0698eea04d3340fafeeaedb71a5fe4e",
"main.dart.js_289.part.js": "50dc96c729469b1216110c20b550b4b4",
"flutter_bootstrap.js": "6deb1af1aaf9b6dbc19c239e4a25b930",
"main.dart.js_315.part.js": "1a79ae366ec95515b7ae3ee0a871a1e2",
"main.dart.js_304.part.js": "bc7ed2ccf60d5dd5b50efe13dc96fa82",
"main.dart.js_264.part.js": "0a0b192d8052cc3f5cb55c9787501fca",
"main.dart.js_306.part.js": "c7cd3b4b74e94e0f25f7bde87a57483e",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_256.part.js": "d29e265129edc3d31af5934c84054098",
"main.dart.js_221.part.js": "d94591edde281d1b98ef7f3aa38f2554",
"main.dart.js": "86dfcc66cc63567861de9568f6e9804a",
"main.dart.js_226.part.js": "e1a5ee3c2eed5e88ac7db2bdd0d6362a"};
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
