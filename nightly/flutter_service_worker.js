'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_195.part.js": "a322699776dadd9791009c34507a88c2",
"main.dart.js_197.part.js": "989fc084bb773b3659a508a4c7b0d09f",
"main.dart.js_294.part.js": "09637f2d66340712bc8f054a57b8745f",
"assets/AssetManifest.json": "00db64060cc2f780d2f934bb7c3fe01c",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/login_wallpaper.png": "05f9f8c2f3a51c757f0a7914096b3bdb",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/AssetManifest.bin.json": "1a44f3e93dd94fe3688f09990e12dd90",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "e0a43362a0330fba25a72cc86cfdccab",
"assets/FontManifest.json": "6a590c591cb18c7ac3b63b1fcaa45b57",
"assets/NOTICES": "bac3c1f1d354e1fe49eeb7294e13259d",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/MaterialIcons-Regular.otf": "43916d53bcb4e7a549ee7d84a1d11bc2",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "bf619178a1771fb6a056dd98bc108d5d",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"main.dart.js": "2fdd3cb36f4b75716eb5304e1e0c23fe",
"main.dart.js_238.part.js": "6ca4eb2fcbeade497b81db1ea21948f7",
"main.dart.js_248.part.js": "db9e34f89f6f783ea61b1c36524c1648",
"main.dart.js_283.part.js": "52ba9cd53e93cb98c0e7345894762677",
"main.dart.js_14.part.js": "b7ae4722c652d9ddddd21821eb0f32f5",
"main.dart.js_244.part.js": "89b8543568f7e54d0212f706fbfdf64b",
"main.dart.js_210.part.js": "c86a34ddea634f7acebdfe4419cf0059",
"main.dart.js_252.part.js": "2297200c8de40116c7e089e27fd237d6",
"main.dart.js_280.part.js": "430b37da14aefb75715c3a1c7a945784",
"main.dart.js_264.part.js": "94b43df087d9c10ab1e39b69a54ce6df",
"main.dart.js_269.part.js": "890e161cea61534f3826a32011b310ef",
"main.dart.js_273.part.js": "7abb54d9eccf1ce6b02e1aeafbeade45",
"main.dart.js_261.part.js": "5429b763094c1b441b58031f9e5f0bad",
"main.dart.js_230.part.js": "f01ee684817f8adc729bb51ad6101389",
"main.dart.js_293.part.js": "9d6d54e346b1cdeb9f125fec9dfa238b",
"main.dart.js_229.part.js": "1eb96cd9a844e3013fbc3211f2b6749b",
"icons/Icon-512.png": "f57dad4f6efa0339b50d5c65f36dc03c",
"icons/Icon-192.png": "839e87c4f6800df757bb28180f8e2949",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_292.part.js": "559bc70d08da7fc8bf166cbb6671484c",
"main.dart.js_275.part.js": "cb2d9d44b63f996b28c8b8b462d7ce36",
"main.dart.js_274.part.js": "4a83aed510dca2bff5e96f1c41c04f41",
"flutter_bootstrap.js": "6f970148959f55e162a8e249a51ff640",
"main.dart.js_1.part.js": "18fde6efdfe5708acc0f12c233845ad0",
"main.dart.js_295.part.js": "d553921aad37302ce15f65d86ec1ff1e",
"main.dart.js_288.part.js": "ba9a37c74f807df7e4d8dec089878efb",
"main.dart.js_291.part.js": "c61110f29ab832b2ddb0cdbde2f34254",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_296.part.js": "f92d651258f9d53d8e529430f7c71fa4",
"main.dart.js_233.part.js": "43a7a826f36a74aae0ff3c88d959694e",
"main.dart.js_277.part.js": "67678ab9b859dce7a0cbeab4f22e525c",
"main.dart.js_222.part.js": "7fd41dbad34cd8e2891de295878dcbad",
"main.dart.js_245.part.js": "6e550d04d49279c6ac1a9d0714d92282",
"main.dart.js_254.part.js": "4eb81e489177eb5983e3d1456e5e61de",
"main.dart.js_281.part.js": "396ac747754ddc0a3ae4185e29434ded",
"main.dart.js_217.part.js": "ac3280a02c4c928e0a70e1c139dfc57a",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js_208.part.js": "c150333fbc788fdc0f9d7dde00693140",
"main.dart.js_209.part.js": "dd67355e1e10728852fef9ade7d854eb",
"main.dart.js_271.part.js": "f8a5843985eaf6e956055835266c6c11",
"main.dart.js_278.part.js": "1b6d300226978c5bcc180a2172426ef8",
"main.dart.js_242.part.js": "4d80319920223c9d0d7123ccba256245",
"main.dart.js_249.part.js": "aac535cfce92ec7225f04a7142df678e",
"index.html": "72515b0d33bdb55bdfbb055f89f3b8ae",
"/": "72515b0d33bdb55bdfbb055f89f3b8ae",
"version.json": "8de5909270a83075fc8cc02271e7a17f",
"main.dart.js_282.part.js": "bdbb765ef4d74629a58acfb193073a83",
"main.dart.js_240.part.js": "94ae64e7bd562a62765d16659b612bcc",
"main.dart.js_2.part.js": "08a0b964da2e23ac83d2e842ef97f559",
"main.dart.js_276.part.js": "dd928d10d6553aa9331bc06db4a8e86a",
"main.dart.js_231.part.js": "c8d5b1e8a9b2e6c3d31f470241cb6a3d",
"main.dart.js_253.part.js": "4f507f8a7c2297505c4ecadcba486c48",
"main.dart.js_243.part.js": "dc710419fb48797bc792b80205c91e7a",
"main.dart.js_289.part.js": "93458f3971bd22d0cebc9a4a82c4a929",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"main.dart.js_262.part.js": "2411537fe7056ffd7e9630b0d28ef214",
"splash/style.css": "52986a9e1d69ad779d02334a06b33a81",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"main.dart.js_287.part.js": "e852eb4c7079bcf8eb41a929b8153dda"};
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
