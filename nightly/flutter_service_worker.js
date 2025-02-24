'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_227.part.js": "1dfefd17561350c524b8e4005d8ec2b8",
"main.dart.js_282.part.js": "4b7ab282a32ac38322d3498aaa9ab3d9",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"main.dart.js_225.part.js": "d2b40e0c98505e689aa860d1b931a6d3",
"main.dart.js_288.part.js": "525c947d6ba76a11703e2f3a042cfac2",
"flutter_bootstrap.js": "89a5b1f2c576719fcfc4970f276a2c71",
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
"main.dart.js_247.part.js": "88bfe4cb0b018e245983cdb487bfd147",
"main.dart.js_277.part.js": "850ee7936ec5043562a85809ec714b9e",
"main.dart.js_290.part.js": "624a3bc142dede3550439f9296659bb3",
"main.dart.js": "f297207f419bf8d718124df98bdb3661",
"main.dart.js_239.part.js": "21e4b003865eef7fd9d13947ce9ffbee",
"main.dart.js_224.part.js": "f2df0e5e1fdf368fd085e798acaa8c73",
"main.dart.js_271.part.js": "b7837910e07f1efd9eaadaecafdbdbd6",
"main.dart.js_243.part.js": "b87df9d49fcf582df55bf884c9dd897c",
"main.dart.js_286.part.js": "6405c18c1c60deb4fc6973dbe711f0de",
"main.dart.js_283.part.js": "7018969924cd9b8f669bc0c3f6db6f5c",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_198.part.js": "ed1b84c8256babf7837eff5617437243",
"main.dart.js_187.part.js": "888f3f5eec73ea4abc08f6b402ff5158",
"main.dart.js_272.part.js": "ad1d5f556633f400f98bdb5a32cac67b",
"main.dart.js_285.part.js": "7c5884fc9ee06a8b012302f2c62b2ff2",
"main.dart.js_237.part.js": "a83347b321a05fcc57c3523d308f53ca",
"main.dart.js_200.part.js": "a06e23cf276aab266993f5b6b0255b1d",
"main.dart.js_238.part.js": "3afee935768fa930407bbe844367b784",
"main.dart.js_249.part.js": "4c16ea0e489d0b5c103f0fa15cceb87c",
"main.dart.js_276.part.js": "217e3b926a784d54a35ab81ec5d693da",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_255.part.js": "455344bf2496f6a6a22f89052113b071",
"main.dart.js_258.part.js": "a02a0daae38b25f3ea9de3782afa05b6",
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
"assets/fonts/MaterialIcons-Regular.otf": "96d93fa4571003981ccc39dcd4f5d5db",
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
"main.dart.js_289.part.js": "f5ff9a50a1cbfeb2a82994a6984f4d1b",
"main.dart.js_185.part.js": "dd05bc3b0cb7793509cc3c8988351671",
"main.dart.js_248.part.js": "20e6b6cfcfc121d07e5a2b348273a031",
"main.dart.js_15.part.js": "99884232bfa67eede93e1804ed610187",
"main.dart.js_274.part.js": "341e1fc10dc0d908956c2c4034c46d72",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"index.html": "7e609228a02fed1069490d7e1a979a57",
"/": "7e609228a02fed1069490d7e1a979a57",
"main.dart.js_270.part.js": "496ad21f928997c3a92fff5fa6e13584",
"main.dart.js_267.part.js": "34d8e9fac50eab3ef6afd17ecef86698",
"main.dart.js_236.part.js": "c8a80195f6032ce8394ddbf26d842490",
"main.dart.js_265.part.js": "88731bcde51ac9cc8b0a90213a833dba",
"main.dart.js_234.part.js": "1f28d68c9389fcdda9850fc57baba042",
"main.dart.js_223.part.js": "fb20f84cd9185f637d0c66fe2377c1d0",
"main.dart.js_232.part.js": "75e5409263bc6aba8672f85ba88ccae3",
"main.dart.js_209.part.js": "8a778d0f4c1b3cf3e1427cbaec313b74",
"main.dart.js_269.part.js": "76b2efc9bc206589bc6ef7951aca5f0c",
"main.dart.js_275.part.js": "0b1ce27bf83ba5d8bcd4c2665e2d5817",
"main.dart.js_263.part.js": "fcdeaeb598bebe0557881c5ced7ffd0a",
"main.dart.js_287.part.js": "e6694640ed44a6d69b56ead0b89a513a",
"main.dart.js_199.part.js": "76da3291ee5fc5283d1984f6063a7605",
"main.dart.js_215.part.js": "1f71406089e83296204bf4658642573f",
"main.dart.js_256.part.js": "aece6c98910ad4cfe7ba47988527a0b9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_281.part.js": "fd53fcacdbc8b93034037f7c9e3980f3",
"main.dart.js_1.part.js": "e60bc0fa16c13e82ca98f543bcfe63ca",
"main.dart.js_268.part.js": "135f3ca544b69b90824668a3664db6fe",
"main.dart.js_242.part.js": "174fcd3f7a8d92d1029756f38bb44457",
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
