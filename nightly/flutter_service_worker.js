'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"main.dart.js_339.part.js": "e82eeb8530b1ab7e11e6e100208a866f",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_308.part.js": "56f5d4fa5caa72c3edfcc2b759d71ae7",
"main.dart.js_317.part.js": "dafe2c4786059622274717839777b4bf",
"main.dart.js_1.part.js": "90ee68db5feaaa979cc7f9c6a0ebaaa7",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"native_executor.js": "2dc230e99daa88c6662d29d13f92e645",
"main.dart.js_280.part.js": "5ad760cc0ec6667f065cf8c5a1efb8e9",
"main.dart.js_274.part.js": "722084bd46577ed017384501ba2b53a0",
"main.dart.js_318.part.js": "88514a971c6910a449ccfee0ae99a795",
"main.dart.js_338.part.js": "6d322bd12c0b9cef210434d44d6d246d",
"main.dart.js_266.part.js": "e39df05406a84a66071908f8425ae206",
"main.dart.js_316.part.js": "be1f194333dec514784cf222841c4711",
"index.html": "1393ac850da50eca200a09c74505242c",
"/": "1393ac850da50eca200a09c74505242c",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_327.part.js": "d76651ca76b4a1d2b190f9245d2f7ef8",
"main.dart.js_2.part.js": "93244c7c8fedafc9ff314cd6998a6803",
"main.dart.js_283.part.js": "2111711d0471bac09e12a2d7e55232c9",
"main.dart.js_294.part.js": "433f75fbccdfbb7bf5baeaef6ee66961",
"main.dart.js_265.part.js": "7b0c3adc74d6bdbd5baae9bbc699f5c2",
"main.dart.js_300.part.js": "96d96b2da20223fb4ac610de29ef569b",
"main.dart.js_322.part.js": "12ba8e161164af2cacb13a6fe5e01e99",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"main.dart.js_301.part.js": "b7fa0506713f5dc7391a62547249ec19",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin.json": "6903af015855cc6fe860ba6a9b1603fa",
"assets/assets/vodozemac/vodozemac_bindings_dart_bg.wasm": "0df43b74b6422bd473c5d40edbb16d60",
"assets/assets/vodozemac/vodozemac_bindings_dart.js": "3700a5c275c7c9762ebbba9c87509441",
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
"assets/fonts/MaterialIcons-Regular.otf": "4dbf854c4246d88144048b190b24bbc9",
"assets/NOTICES": "e3942d4aef2a10490fb32abd34246436",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "5c124396503231de315ac975bb8653d8",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "6d247986689d283b7e45ccdf7214c2ff",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/AssetManifest.bin": "55ff796597c26a7b5d746d2ec3d67f23",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"main.dart.js_334.part.js": "222cfc3b7fedc2576aee67f971936d77",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_320.part.js": "47a4655c75e04398f44d9f116a31f474",
"main.dart.js_254.part.js": "e3a7f5a4690260b0bc0ae06977f3b68a",
"main.dart.js_292.part.js": "9e97e1e73d6ba0a023d0c86ebd71aea0",
"main.dart.js_284.part.js": "78a146f18f1a7adcaff13f71b8d1006d",
"main.dart.js_278.part.js": "1d543ac9ebae502ab22f5e7897d49f26",
"main.dart.js_239.part.js": "5f0a986aa6adf46d617347fc35319c38",
"main.dart.js_333.part.js": "26d4e26dcf8d5df9abd3f5dcb281a0e5",
"main.dart.js_303.part.js": "05444faecb2baacceaf8e9cf938d251b",
"main.dart.js_331.part.js": "44ecc6d8653896cf9af62eef980a8909",
"main.dart.js_257.part.js": "bf3243180df3163dd21bb3dc3e56cd5e",
"main.dart.js_340.part.js": "2b82038725f4047cfec25646833781b5",
"main.dart.js_269.part.js": "c9e40d9805a8fffccb1f9a8d15506438",
"main.dart.js_267.part.js": "6e07766860e39ade72abe1f662170b37",
"main.dart.js_313.part.js": "ef933d304a120c53e4681afcf58574e0",
"main.dart.js_321.part.js": "fbf0459796320006332d020921a28885",
"native_executor.js.deps": "3777817ddb1687147f834811f58eb9d7",
"main.dart.js_248.part.js": "cad60c5f2b9c760af062f34edb0ba129",
"main.dart.js_332.part.js": "5ad2636292207cde4e3423b7500a065c",
"native_executor.js.map": "a34db57347ba49552a8b3920d6d3d89b",
"main.dart.js_288.part.js": "65f660d88417c6cc123d5714bb7ad82b",
"main.dart.js_314.part.js": "c2ee322423366fc84ac5a19b30e6ab38",
"main.dart.js_216.part.js": "4453a3d1c64c21e6420958ee4b053c27",
"main.dart.js_323.part.js": "519daf46e89558778214fd3e98a32a1d",
"main.dart.js_335.part.js": "14a4af7ea73ada2e9aaded5d22c549d3",
"main.dart.js_218.part.js": "2c2386a7a22376f9053f13e91ea335e3",
"main.dart.js_328.part.js": "a3418a2620ea44cb82bff0a0a2bac428",
"main.dart.js_289.part.js": "55e8e85875c6055fc02efe35b4735adc",
"main.dart.js_337.part.js": "112e81c61aea3765629c1928d3ea61e7",
"flutter_bootstrap.js": "3c67a2bb21a6020cf5fada4908e35d00",
"main.dart.js_315.part.js": "89d7a92df257fa22a950127965d4c2b1",
"main.dart.js_276.part.js": "ce03545e093714fb8fa40235df5639a4",
"version.json": "51f7adc832ada0b042160876603ccc9c",
"main.dart.js_293.part.js": "45083f5624c3290970839946e0b44d47",
"main.dart.js_310.part.js": "4ba612c0436261af3fa9b597b41b334c",
"main.dart.js_329.part.js": "935bae813d6eb1205d12c4204b4e5155",
"main.dart.js": "909809213e475913665d536e613ead5e",
"main.dart.js_224.part.js": "53e69dd37fc5443d8ea9f1a610581360",
"main.dart.js_17.part.js": "3ff5377978fffba9d0f0e518f16a1ac5",
"native_executor.dart": "97ceec391e59b2649e3b3cfe6ae4da51",
"main.dart.js_236.part.js": "bf0da9c25e75b2834aba3ac401853401"};
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
