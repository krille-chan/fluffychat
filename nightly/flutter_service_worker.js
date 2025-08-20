'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_318.part.js": "c0a6cd0931b71aee7cc16107283baf25",
"main.dart.js_303.part.js": "4a40bde0a2adfd54101815650d0216cb",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_289.part.js": "b99d846b5e4834cd646326c8edd22c3b",
"main.dart.js_320.part.js": "2754145a6a056575bb56bfb8655a48cd",
"main.dart.js_246.part.js": "dd7f021f562a0592a0ef2d64618c4a13",
"flutter_bootstrap.js": "0ce88a346a0a9a63792f50e1b83c1009",
"main.dart.js_211.part.js": "9ca9db9f3b3aa8f004610ac8051807ae",
"main.dart.js_274.part.js": "911faf148029cb8e97ed42b81ede400a",
"main.dart.js_275.part.js": "8daeb8b656449d4803340a098b26b2ee",
"main.dart.js_254.part.js": "471e33c5624101482694b747e892f9d2",
"main.dart.js_269.part.js": "53137e13fbecd7c0be5ffe8215a4d95d",
"flutter.js": "83d881c1dbb6d6bcd6b42e274605b69c",
"main.dart.js_16.part.js": "b8d5e8adf0578fb702016ecf3a62e73c",
"main.dart.js_315.part.js": "9c392d628f2201af0ab75b5141383c5f",
"main.dart.js_301.part.js": "637d50e0e4ea6725313b58a7069ae240",
"main.dart.js_299.part.js": "4d68b67e7b5f9472a161d605d9bb6063",
"main.dart.js_237.part.js": "d38f7257ac25771a0a959d7a0efd0a15",
"main.dart.js_306.part.js": "1e5489d14c809b0f01207766731fa673",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_229.part.js": "543fb2fb3e90287240a5e991e3b9d4b1",
"main.dart.js_214.part.js": "88c44390de72fcaee9c266148e5903fc",
"main.dart.js_302.part.js": "415992776aea44577a9c8cba510bb9be",
"main.dart.js_321.part.js": "9f3cea503c191d3c90aa9b0a918b7c33",
"main.dart.js_307.part.js": "f1d2742a0ef023c8f00789ed0943f31f",
"main.dart.js_314.part.js": "2fea05393866612ec823a20cdecfb4ad",
"main.dart.js_243.part.js": "6fec787b2afa961e57ea52a34c84cf95",
"main.dart.js_2.part.js": "611010805dcb56081c8408ef9b74dbd0",
"version.json": "c39aee0353c6ad9b93e18f82170c8248",
"main.dart.js_258.part.js": "4e2bc5c1e273e4c11d3de7612898aa28",
"main.dart.js_256.part.js": "5308d523d80c8a35dddedd482497115b",
"main.dart.js_270.part.js": "e7c2c703b63ae20bf57cca17194e915f",
"canvaskit/skwasm.js": "ea559890a088fe28b4ddf70e17e60052",
"canvaskit/chromium/canvaskit.js": "8191e843020c832c9cf8852a4b909d4c",
"canvaskit/chromium/canvaskit.wasm": "f504de372e31c8031018a9ec0a9ef5f0",
"canvaskit/chromium/canvaskit.js.symbols": "b61b5f4673c9698029fa0a746a9ad581",
"canvaskit/canvaskit.js": "728b2d477d9b8c14593d4f9b82b484f3",
"canvaskit/skwasm.wasm": "39dd80367a4e71582d234948adc521c0",
"canvaskit/skwasm.js.symbols": "e72c79950c8a8483d826a7f0560573a1",
"canvaskit/canvaskit.wasm": "7a3f4ae7d65fc1de6a6e7ddd3224bc93",
"canvaskit/canvaskit.js.symbols": "bdcd3835edf8586b6d6edfce8749fb77",
"main.dart.js_313.part.js": "842fa800397a1102d7848b1740ad8f51",
"main.dart.js_268.part.js": "703a9e44c47ad795fd7dc54e38a839d9",
"main.dart.js_308.part.js": "a71ed69af6b025087b7df08ba0af481e",
"main.dart.js_278.part.js": "d1192a34f87c3445f04fc9efea6229bb",
"main.dart.js_266.part.js": "4dfb0c72cc03af95268da26379b1a7ed",
"main.dart.js_1.part.js": "7a8a574f590366b5765a0376762d4efc",
"main.dart.js_296.part.js": "2efc2483e81a58b15e8909ae2f5e246b",
"main.dart.js_323.part.js": "a1f8f4dec042af52b462c1601015d15b",
"main.dart.js_279.part.js": "c98d68b6d2fc1f89094d7151feb330df",
"main.dart.js_226.part.js": "99fb689ac21a98954fcb58dcd31b9797",
"main.dart.js_255.part.js": "bfd9d07a74cfbe763ea0da3f0404783f",
"main.dart.js": "734991e84b4598cef03c5f210f87f6ee",
"main.dart.js_304.part.js": "6bd855e35996ea7470e5729b88f27db0",
"main.dart.js_286.part.js": "b5cbcc7a7344201ee98e04a9f4f34c30",
"main.dart.js_322.part.js": "c1676b33be7f2f4726484442ef5f8ab2",
"main.dart.js_287.part.js": "ad9f49b14aa0e42f9460e14ec11a5051",
"main.dart.js_294.part.js": "c10bf182320d97dc511e1ee3bcbd95e8",
"main.dart.js_262.part.js": "e54e3fba49e6cfc439fedcd04f1bba67",
"main.dart.js_309.part.js": "438a665694438d72ce93131367645638",
"main.dart.js_280.part.js": "38ae38208cb885750bd8704565ae66fc",
"main.dart.js_300.part.js": "7dda455b49df170f6e5a8377810c6ef6",
"main.dart.js_222.part.js": "a80b06db3f6b42cb8469489b14a59ea9",
"main.dart.js_324.part.js": "56d53600c21f74d86e1ef2a6ac10be83",
"index.html": "22ac9530ab4c7f0f540de814cec60780",
"/": "22ac9530ab4c7f0f540de814cec60780",
"main.dart.js_264.part.js": "18ee390fc492c6fbbbbcd928b8fce2cf",
"main.dart.js_319.part.js": "de9447d570ce440e8511b46309aed56e",
"main.dart.js_317.part.js": "33d72826ffff50f6e386a8b0f860da15",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/NOTICES": "9091b0748a4463eef59c8e796100439e",
"assets/AssetManifest.json": "9d3e0b7f3bbe087b376d96f5ac5beb1a",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/fonts/MaterialIcons-Regular.otf": "ec4701eae3a98b81d0e83dedc090f26c",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "9edb705b5fc55fbd49751b664820ce9a",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "a7d3d002634a337e1b38c23d270f8c05",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83"};
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
