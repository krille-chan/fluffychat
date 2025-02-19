'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_227.part.js": "cceb125951a200b4615649ea2411d8d7",
"main.dart.js_282.part.js": "70c5d86c009c8d45fb4198b0029fcc21",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_225.part.js": "8c29ec152590be1ffe7a75b19e45be37",
"main.dart.js_288.part.js": "e50afa61582736876f9027721199da1b",
"flutter_bootstrap.js": "77b6f67b69ef8297d82e6505d8f482a0",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"main.dart.js_247.part.js": "7a4662b4c7eaeb8a9ce9d6ba2f05d51d",
"main.dart.js_277.part.js": "9543195fb68db00515fa3c8fc6779f95",
"main.dart.js_290.part.js": "0b1fcd74888f481ff82390dc29084c51",
"main.dart.js": "a000bf5ba2e6ca150c27c1a613591237",
"main.dart.js_239.part.js": "62b10a6e8433a680c7e31435529c967b",
"main.dart.js_224.part.js": "90a9ab88ecbd8dd99a89528e7ff5c470",
"main.dart.js_271.part.js": "b3a1ca1971f74004012ed862fb393c6b",
"main.dart.js_243.part.js": "783a1a52257535f363f56015864815bb",
"main.dart.js_286.part.js": "f297f7b0afb7cde143adb8f6c46559ea",
"main.dart.js_283.part.js": "0309e4291f89befd91c623d17352dea1",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_198.part.js": "5113c5d5421290d35fc6b9110d23b0a0",
"main.dart.js_187.part.js": "827aae39e838da875c943661c20f2241",
"main.dart.js_272.part.js": "035ce9f30f891d690c6834429ab489cc",
"main.dart.js_285.part.js": "aa79d65bfd577e36275ceeb0913b84d1",
"main.dart.js_237.part.js": "7f9f9ea91aae2c7f28e378392ea25416",
"main.dart.js_200.part.js": "de18c53fdecf4e47f051d892a73aa207",
"main.dart.js_238.part.js": "10c404a121e1562eeba7818105a00876",
"main.dart.js_249.part.js": "f436d05d436aa9937eef3d98a524db1e",
"main.dart.js_276.part.js": "af36fc56e4aea20c6dc174b0349f7f19",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "cec2d20c2807378e3b735b8c87690886",
"main.dart.js_258.part.js": "d36c6cd9dd75f5df79a5698e6ce2caeb",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/MaterialIcons-Regular.otf": "23d21d4ddab1421a1431b49cb82958b7",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"main.dart.js_289.part.js": "c30798f93ca6112daac7f0ddc541d52a",
"main.dart.js_185.part.js": "75e7d11933fbf99bf161b26eb87f3bf9",
"main.dart.js_248.part.js": "e818df5b7bfde7329e4e90f3eb6031b1",
"main.dart.js_15.part.js": "26168a44eb83856113369abcaf21244c",
"main.dart.js_274.part.js": "323692823bf956a13aabb8844742ab69",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "c9d8c56e96e81d3c543f4ad5c6d01fcf",
"/": "c9d8c56e96e81d3c543f4ad5c6d01fcf",
"main.dart.js_270.part.js": "902254af6f5d157bb5c44a28a6d1c4f3",
"main.dart.js_267.part.js": "36748bcc16d6e6dba922c148b30ecbb0",
"main.dart.js_236.part.js": "5469ddc58b940093f2673d8b8041b52f",
"main.dart.js_265.part.js": "71139ae237b31a0b3acf5dd596d355a4",
"main.dart.js_234.part.js": "1c7a33af24a4017194833105f94fac98",
"main.dart.js_223.part.js": "a130823c95a384cabf819c82dd97cc36",
"main.dart.js_232.part.js": "3a6ad8131b1e5ebfa258443ca3e97bd6",
"main.dart.js_209.part.js": "8e3fa950ed48c2e0b9c1baa4edf2fc26",
"main.dart.js_269.part.js": "202f182499301af2db1deb1ee080de51",
"main.dart.js_275.part.js": "d4b4fab9fec42ccdbe8ba538d2565b92",
"main.dart.js_263.part.js": "2e24442b09ae9d260ab71dbc56a2837d",
"main.dart.js_287.part.js": "c03d7e817e44dc7ead6d65da9c917913",
"main.dart.js_199.part.js": "198a2e8a6b685cceb795bddda92dd3c2",
"main.dart.js_215.part.js": "20bd326daccce8171b7fec1f1d79c159",
"main.dart.js_256.part.js": "9d0a1eb06c3681e90e09781e1a7fce06",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_281.part.js": "026c6f60385504a9533f16b7c30ac2df",
"main.dart.js_1.part.js": "7cf6ad8963c352b6a1b52815c23e4cd2",
"main.dart.js_268.part.js": "f980ee1e695e022913ad73d9c902af57",
"main.dart.js_242.part.js": "0962dc63ed63216aa303b9995ffd602c",
"flutter.js": "4b2350e14c6650ba82871f60906437ea"};
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
