'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "888483df48293866f9f41d3d9274a779",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "6ef2064d3422fea86afd5284fc47a83a",
"main.dart.js_271.part.js": "fefeca51617b5b0d3e2c4cad1970163e",
"main.dart.js_259.part.js": "cddf5f30a029a983909589bb445af508",
"main.dart.js_297.part.js": "543cc8f25d08ea35c0cc7e1ca15364a3",
"main.dart.js_1.part.js": "1155aad5fb376713df9d768600c57d52",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_280.part.js": "91c246137195c763aa3c390414d7f1bb",
"main.dart.js_318.part.js": "8510d27f95bc55d4b19f9f906639bc8b",
"main.dart.js_214.part.js": "4e79ad50dd55026bb7b2f72d900ff17c",
"main.dart.js_295.part.js": "19e6c2f2782ab1b44b205fffd74236fe",
"main.dart.js_316.part.js": "d08790d570f3e5b94efaf59af191fe55",
"index.html": "35f7682680431e930cbbd80fc341a75d",
"/": "35f7682680431e930cbbd80fc341a75d",
"main.dart.js_302.part.js": "306e7f4726e7b2d7f404f483111f71ee",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_305.part.js": "cc0e1b99a04d596c690a6cb417e13863",
"main.dart.js_244.part.js": "32f3a1954daefb749364c35925822a5c",
"main.dart.js_2.part.js": "8562c1397a0f7f335584f0dcc1479208",
"main.dart.js_265.part.js": "bdf1c276070d0d1b076a6ee7b8cc8b7a",
"main.dart.js_300.part.js": "2a272ec8904e16d87ffccd44861ea9e7",
"main.dart.js_322.part.js": "e205f77af34f49792d79d854469e70a6",
"main.dart.js_263.part.js": "db108c1b5c01f9c24603816d48e31d81",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "cd08db7cd7d0d00da990ec60596b802b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "f15d777bc389b3c0d20aadcb9f84f5aa",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "20657a5119bc1722dc7d721a203a12c4",
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
"main.dart.js_320.part.js": "b59b5c9d3aab8ef3a6fe11671a502cfb",
"main.dart.js_247.part.js": "b758343b10da8e200a5f94f85f993277",
"main.dart.js_16.part.js": "53ad48fb0b5fc3daf35702af618f9a30",
"main.dart.js_303.part.js": "9c3a8bee6f5a7b8f97b40a5db44add38",
"main.dart.js_287.part.js": "6bd855293a07871d0ca062fe58f2bd47",
"main.dart.js_257.part.js": "3dfc0e9f3a0961ef3f6d9cb3883bff9f",
"main.dart.js_290.part.js": "e0b65e359680ec4b51a5423ed303781f",
"main.dart.js_212.part.js": "0c3bdccc71bb58eca82900d7223c4968",
"main.dart.js_269.part.js": "7a2ee0253be489e73323423bc5dc85a7",
"main.dart.js_267.part.js": "91d2776e26b04706634effbd237449b0",
"main.dart.js_309.part.js": "e27e122ffaad0a15f547d26584cdec7e",
"main.dart.js_325.part.js": "3170cb90465c87e275029de8624ecf8d",
"main.dart.js_270.part.js": "a3e9d562af4bea7da7ed076e2bb71596",
"main.dart.js_321.part.js": "8e0aa8719240ad573787df979129fbb6",
"main.dart.js_255.part.js": "ca5aee9d69f508d884f1cc4f3d551bcf",
"main.dart.js_275.part.js": "0cfa852102001acacd601de9e1f4e8af",
"main.dart.js_281.part.js": "6e360565469f9d5cfa21fd39738bca9a",
"main.dart.js_288.part.js": "84995a88270fa5de35dabf3c4f9280c8",
"main.dart.js_314.part.js": "002a13251899f4e9038b313712022fd3",
"main.dart.js_307.part.js": "7c87b4f9bcc8ed80d8b6162dfc027885",
"main.dart.js_279.part.js": "20e0a77c73369ce49b2f8c40d409be62",
"main.dart.js_319.part.js": "3927e4160cd1e64c567e3d7425482d3d",
"main.dart.js_323.part.js": "0fcb3a971f71186b84df77c45ae954f3",
"main.dart.js_227.part.js": "4b1ea814f99548a4000413156ce110f4",
"main.dart.js_230.part.js": "1322206c7209670587c94a109e73b9a0",
"main.dart.js_324.part.js": "078ebe8d510bd2a12f2d577c66a4efde",
"flutter_bootstrap.js": "80fe08f4c802227948e67f7825f0a684",
"main.dart.js_315.part.js": "49ef1b0b8e9dfbd0e895b6fcccb7c817",
"main.dart.js_304.part.js": "bd83feda3fc3ca324851dddff7ef018e",
"main.dart.js_276.part.js": "347fb0f7887a4a4c9fe2fa6cdf40e107",
"version.json": "2c33e7ae127d5e7481b698dce51910ca",
"main.dart.js_310.part.js": "e8f046195151907c507720fb44d7ad8d",
"main.dart.js_222.part.js": "cf0e396478ed927fc17526b647a2d761",
"main.dart.js_238.part.js": "642018888cc9fcfae7afd9f95f446e52",
"main.dart.js_256.part.js": "5d3d526a00f5748195efd57f07fb6b1b",
"main.dart.js": "ef890cdc473a07bd12b9fed1a8655320"};
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
