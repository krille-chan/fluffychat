'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_283.part.js": "ec82be7a43d033da1eb28b0957448767",
"canvaskit/skwasm.js": "ac0f73826b925320a1e9b0d3fd7da61c",
"canvaskit/skwasm.wasm": "828c26a0b1cc8eb1adacbdd0c5e8bcfa",
"canvaskit/skwasm.js.symbols": "96263e00e3c9bd9cd878ead867c04f3c",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.wasm": "e7602c687313cfac5f495c5eac2fb324",
"canvaskit/canvaskit.js": "26eef3024dbc64886b7f48e1b6fb05cf",
"canvaskit/canvaskit.js.symbols": "efc2cd87d1ff6c586b7d4c7083063a40",
"canvaskit/chromium/canvaskit.wasm": "ea5ab288728f7200f398f60089048b48",
"canvaskit/chromium/canvaskit.js": "b7ba6d908089f706772b2007c37e6da4",
"canvaskit/chromium/canvaskit.js.symbols": "e115ddcfad5f5b98a90e389433606502",
"main.dart.js_271.part.js": "7b79a1aa17cea3d2edcc06f19c98d4a1",
"splash/style.css": "740c493f9c5dfc859ca07663691b24fb",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"main.dart.js_236.part.js": "ed9a2c52baa8728bfc7fa3a6f0f5b4ea",
"main.dart.js_258.part.js": "12bacf3e76735190a9076a76f627f200",
"main.dart.js_247.part.js": "bc747b91fa3e6ecaf47ff1181ef81035",
"index.html": "786cedb25a614fa14bbb2db3a497f9f5",
"/": "786cedb25a614fa14bbb2db3a497f9f5",
"assets/NOTICES": "d61ff676fcd42447f136b64287d177e8",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/js/package/olm.wasm": "239a014f3b39dc9cbf051c42d72353d4",
"assets/assets/js/package/olm.js": "e9f296441f78d7f67c416ba8519fe7ed",
"assets/assets/js/package/olm_legacy.js": "54770eb325f042f9cfca7d7a81f79141",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/logo_transparent.png": "f00cda39300c9885a7c9ae52a65babbf",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "d259b9a0fc450fbd5e01a9695fb80161",
"assets/fonts/Ubuntu/UbuntuMono-Regular.ttf": "c8ca9c5cab2861cf95fc328900e6f1a3",
"assets/fonts/Ubuntu/Ubuntu-Italic.ttf": "9f353a170ad1caeba1782d03dd8656b5",
"assets/fonts/Ubuntu/Ubuntu-Regular.ttf": "84ea7c5c9d2fa40c070ccb901046117d",
"assets/fonts/Ubuntu/Ubuntu-Medium.ttf": "d3c3b35e6d478ed149f02fad880dd359",
"assets/fonts/Ubuntu/Ubuntu-Bold.ttf": "896a60219f6157eab096825a0c9348a8",
"assets/fonts/Ubuntu/Ubuntu-BoldItalic.ttf": "c16e64c04752a33fc51b2b17df0fb495",
"assets/fonts/MaterialIcons-Regular.otf": "8166643540d3cdfc8cdd5b4c505cfc40",
"assets/FontManifest.json": "47ac216e0fb8da302b2867e98c9e3ca3",
"assets/AssetManifest.bin.json": "e9f7fa3c09f12a61d725d5e666f6e737",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "04bc91744b625a64b095c6aec2f83ed9",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/AssetManifest.json": "630cf4891ec2cead2166510c46fa4dcf",
"main.dart.js_249.part.js": "858604e392c83d5ec6d7a00517690e57",
"main.dart.js_276.part.js": "99560d0815d6a5893b0127e874ec57c2",
"version.json": "121f9d560543e44f99cec4290f22618b",
"main.dart.js_285.part.js": "5448c439bab1e775576a3f251aa9450f",
"main.dart.js_269.part.js": "859f09cdeb76f4f4f14358048c531451",
"main.dart.js_263.part.js": "e8235c914baf45e60b428902ce19c7c1",
"main.dart.js_232.part.js": "84c85d70d19b05d90c170e98a7c474fc",
"main.dart.js_277.part.js": "2827eb67de752f1e78e7a555452bec90",
"main.dart.js_187.part.js": "b0daaa9cccfd04f4061663bb699b24b0",
"main.dart.js_281.part.js": "82081bbd1814a85450b4be51af727143",
"main.dart.js_265.part.js": "c0ae71d0df0eec47ef17a6883224ba76",
"main.dart.js_223.part.js": "a7f1076e00d764f491f1210abf2ab884",
"main.dart.js_215.part.js": "c970ed28477a6da53a0b0a39cc03e4a3",
"flutter.js": "4b2350e14c6650ba82871f60906437ea",
"main.dart.js_243.part.js": "b503fcf91cdc3770ef5744161c91094b",
"main.dart.js_209.part.js": "98028f33f9243af52a2b6b6e7f3d6cc4",
"main.dart.js": "5da820e0863b73c736e76d68a3385a3b",
"main.dart.js_2.part.js": "288f6b21921ea2b87dc6b2085fec7ac1",
"main.dart.js_185.part.js": "b147dbd555310d0aea7ddf7c7ead27a4",
"main.dart.js_238.part.js": "7dac577a2b16e88b4573ce7eafd415f7",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_225.part.js": "0003c9077081132889c9885101e3f05c",
"main.dart.js_255.part.js": "ff284e7c0abdbc6608ae98e9ecae2113",
"icons/Icon-192.png": "97f7226b0a52c22cfe1557cecce6763e",
"icons/Icon-512.png": "391892c6f6720429a9d4f93ec1ce5f4e",
"main.dart.js_282.part.js": "08e0a527f46d2014279bab8fbda443af",
"main.dart.js_237.part.js": "6045aa4aed805720db6137056193369e",
"main.dart.js_288.part.js": "92563dba04a76e87b16411e6c7d3bc29",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_234.part.js": "d15b02a7c162ad862d47a47737a65748",
"main.dart.js_200.part.js": "bc141abb90d275aff0720e04b60134db",
"main.dart.js_287.part.js": "fb67d5e98c3e724c8f284bd4c9583808",
"main.dart.js_198.part.js": "c4e17e05160e57f30d02a645b78a1f4c",
"main.dart.js_286.part.js": "585c4b539291ee6785992560614b8a4d",
"main.dart.js_224.part.js": "96695cfb97371145eeb82f1ce4ba47cb",
"main.dart.js_227.part.js": "0f3713b7e817504fc7e558f3c1497ffb",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_270.part.js": "e55f6daa7b061570972ef10754999d49",
"main.dart.js_274.part.js": "e8488aa1210063520eddaca5efb0e8f4",
"main.dart.js_239.part.js": "eb181aca3a299e3c1643a145010ee0c2",
"main.dart.js_289.part.js": "8e93d20e83eb1a0a50bb5de38053b3f2",
"main.dart.js_199.part.js": "69a3ccc314cfd67c9a73738083d01c93",
"main.dart.js_275.part.js": "e833bd0cf00cd9881012417ad448db9c",
"main.dart.js_290.part.js": "2a7375634be02012329ca90b5aa3f7c0",
"main.dart.js_268.part.js": "88d4c7f06560dcb3712489d5dc704443",
"main.dart.js_242.part.js": "5b4dd19df616727fbcb8aa4a990908fd",
"main.dart.js_272.part.js": "66014a94ad2a4aa878dbd383a236d4d2",
"main.dart.js_248.part.js": "cfef6e5e9ef2de374788fcf82b7c8ded",
"main.dart.js_267.part.js": "970af6b4fcfbdf46d096f168b6e9e605",
"main.dart.js_256.part.js": "316c19afb2b171650a899e1ea5c74d5b",
"main.dart.js_1.part.js": "0160f2f11116ddc3cde567c026478809",
"flutter_bootstrap.js": "059f560c1fd5e75cbc4fe6e16806c728",
"main.dart.js_15.part.js": "ce8143e25aa6718fbcdd5416f55756d8"};
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
