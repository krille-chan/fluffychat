'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"main.dart.js_244.part.js": "a0d2056ec96679bbd3d210c338832f08",
"main.dart.js_251.part.js": "c9bfba018ad7a82fe536f5003e7f4611",
"flutter.js": "f393d3c16b631f36852323de8e583132",
"main.dart.js_209.part.js": "d81c5dc0e9b48db182b9160fe0deedf6",
"main.dart.js_230.part.js": "2fd0d3e0153b38defcbe588757aa515f",
"main.dart.js_287.part.js": "2093ecaf969b8f2a57523507f6bac732",
"main.dart.js_282.part.js": "8bfca4e695cacee49a50735e47c7249a",
"main.dart.js_239.part.js": "0a86eec5b9692e23bed6e02a4d8bcbc6",
"main.dart.js_216.part.js": "eec110f0bee9a6a2940dc868d6a08399",
"main.dart.js_274.part.js": "257b70f34f8844ab8576354e2dce670d",
"main.dart.js_294.part.js": "6e51bd0389880974a557dc25a73790b2",
"main.dart.js_208.part.js": "8acc0c214c30485212d81cf71c4cfe30",
"main.dart.js_291.part.js": "1bd5604fea1f1878e16fe6f116b6e653",
"main.dart.js_273.part.js": "5e081b8a4f6de036f61ed40734a2fe72",
"main.dart.js_207.part.js": "0fe18b418980de1d9fdcde4ef792fe88",
"main.dart.js": "f78a73a24ad874b3b7fd6617a0f1c61e",
"main.dart.js_232.part.js": "4200276b9eea57121175cf977ec4c511",
"main.dart.js_293.part.js": "c4d88b58258d0d02eb927398be272045",
"main.dart.js_229.part.js": "6daea11130c681ae045c8bdc07fe1eaf",
"main.dart.js_196.part.js": "ab53bf7d3a019fd7b580cf75bbde2f5d",
"main.dart.js_270.part.js": "a71fce0de545dc1a28b83fb3d4491bc0",
"main.dart.js_275.part.js": "eaa34a576368f3e751a1d1b20fb48da9",
"main.dart.js_247.part.js": "c954ec89145f4da0606d301594019fef",
"splash/img/light-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/light-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/light-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/img/dark-3x.png": "da261be18bbda768fa1462fd8a8cef46",
"splash/img/dark-1x.png": "db5b72b7f4b38640c974f20d9c90f464",
"splash/img/dark-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/light-4x.png": "e0346148103c17a87682a35525499afe",
"splash/img/dark-2x.png": "9371a9e18df59f2bbe9b32e04c3fc5d4",
"splash/style.css": "52986a9e1d69ad779d02334a06b33a81",
"main.dart.js_228.part.js": "2f3c435a0b6685ff92f8974ddae23a10",
"assets/FontManifest.json": "6a590c591cb18c7ac3b63b1fcaa45b57",
"assets/AssetManifest.bin": "e0a43362a0330fba25a72cc86cfdccab",
"assets/fonts/Roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/fonts/Roboto/RobotoMono-Regular.ttf": "7e173cf37bb8221ac504ceab2acfb195",
"assets/fonts/Roboto/Roboto-Italic.ttf": "cebd892d1acfcc455f5e52d4104f2719",
"assets/fonts/Roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/fonts/MaterialIcons-Regular.otf": "43916d53bcb4e7a549ee7d84a1d11bc2",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Regular.ttf": "7ec92adfa4fe03eb8e9bfb60813df1fa",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Italic.ttf": "ac3b1882325add4f148f05db8cafd401",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Caligraphic-Bold.ttf": "a9c8e437146ef63fcd6fae7cf65ca859",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Script-Regular.ttf": "55d2dcd4778875a53ff09320a85a5296",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size4-Regular.ttf": "85554307b465da7eb785fd3ce52ad282",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Bold.ttf": "ad0a28f28f736cf4c121bcb0e719b88a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Regular.ttf": "dede6f2c7dad4402fa205644391b3a94",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Regular.ttf": "5a5766c715ee765aa1398997643f1589",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Regular.ttf": "b5f967ed9e4933f1c3165a12fe3436df",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-Italic.ttf": "a7732ecb5840a15be39e1eda377bc21d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_SansSerif-Italic.ttf": "d89b80e7bdd57d238eeaa80ed9a1013a",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size2-Regular.ttf": "959972785387fe35f7d47dbfb0385bc4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size3-Regular.ttf": "e87212c26bb86c21eb028aba2ac53ec3",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_AMS-Regular.ttf": "657a5353a553777e270827bd1630e467",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-BoldItalic.ttf": "e3c361ea8d1c215805439ce0941a1c8d",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Main-Bold.ttf": "9eef86c1f9efa78ab93d41a0551948f7",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Math-BoldItalic.ttf": "946a26954ab7fbd7ea78df07795a6cbc",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Size1-Regular.ttf": "1e6a3368d660edc3a2fbbe72edfeaa85",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Fraktur-Bold.ttf": "46b41c4de7a936d099575185a94855c4",
"assets/packages/flutter_math_fork/lib/katex_fonts/fonts/KaTeX_Typewriter-Regular.ttf": "87f56927f1ba726ce0591955c8b3b42d",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "bf619178a1771fb6a056dd98bc108d5d",
"assets/packages/record_web/assets/js/record.fixwebmduration.js": "1f0108ea80c8951ba702ced40cf8cdce",
"assets/packages/record_web/assets/js/record.worklet.js": "356bcfeddb8a625e3e2ba43ddf1cc13e",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/packages/wakelock_plus/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/handy_window/assets/handy-window-dark.css": "45fb3160206a5f74c0a9f1763c00c372",
"assets/packages/handy_window/assets/handy-window.css": "0434ee701235cf1c72458fd4ce022a64",
"assets/assets/info-logo.png": "9d1d72596564e6639fd984fea2dfd048",
"assets/assets/login_wallpaper.png": "05f9f8c2f3a51c757f0a7914096b3bdb",
"assets/assets/banner_transparent.png": "364e2030f739bf0c7ed1c061c4cb5901",
"assets/assets/banner.png": "4a005db27a8787aea061537223dabb7d",
"assets/assets/logo.svg": "d042b70cf11a41f2764028e85b07a00a",
"assets/assets/favicon.png": "3ea6cdc2aeab08defd0659bad734a69b",
"assets/assets/sas-emoji.json": "b9d99fc6dda6a3250af57af969b4a02d",
"assets/assets/sounds/phone.ogg": "5c8fb947eb92ca55229cb6bbf533c40f",
"assets/assets/sounds/notification.ogg": "d928d619828e6dbccf6e9e40f1c99d83",
"assets/assets/sounds/call.ogg": "7e8c646f83fba83bfb9084dc1bfec31e",
"assets/assets/js/package/olm.js": "1c13112cb119a2592b9444be60fdad1f",
"assets/assets/js/package/olm_legacy.js": "89449cce143a94c311e5d2a8717012fc",
"assets/assets/js/package/olm.wasm": "1bee19214b0a80e2f498922ec044f470",
"assets/assets/logo.png": "d329be9cd7af685717f68e03561f96c0",
"assets/NOTICES": "5dc924451b310046ef5aa8160374ae3b",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.json": "00db64060cc2f780d2f934bb7c3fe01c",
"assets/AssetManifest.bin.json": "1a44f3e93dd94fe3688f09990e12dd90",
"auth.html": "88530dca48290678d3ce28a34fc66cbd",
"main.dart.js_263.part.js": "b58c7e45a1005535ee6d2fad66cc2f04",
"main.dart.js_288.part.js": "ca91b66c97db1bca8dca50f73f5f1ec4",
"main.dart.js_241.part.js": "1619af45cbd206aeab937761f01ac0df",
"main.dart.js_268.part.js": "94e76bc447fef5bfa5a060a6b1d648fe",
"main.dart.js_280.part.js": "53a8b2428249893fa26957803c30d00c",
"main.dart.js_272.part.js": "13e607c19697e659cf8a29189afe4b0b",
"main.dart.js_242.part.js": "0bc2aa7604dd45135a96c8e67b48627f",
"index.html": "cb587370d3d10fc77a49df653b7a6fe9",
"/": "cb587370d3d10fc77a49df653b7a6fe9",
"manifest.json": "cc4b6aa791018840b65fd0b0e325b201",
"canvaskit/canvaskit.js": "66177750aff65a66cb07bb44b8c6422b",
"canvaskit/canvaskit.js.symbols": "48c83a2ce573d9692e8d970e288d75f7",
"canvaskit/chromium/canvaskit.js": "671c6b4f8fcc199dcc551c7bb125f239",
"canvaskit/chromium/canvaskit.js.symbols": "a012ed99ccba193cf96bb2643003f6fc",
"canvaskit/chromium/canvaskit.wasm": "b1ac05b29c127d86df4bcfbf50dd902a",
"canvaskit/skwasm.js": "694fda5704053957c2594de355805228",
"canvaskit/skwasm.js.symbols": "262f4827a1317abb59d71d6c587a93e2",
"canvaskit/canvaskit.wasm": "1f237a213d7370cf95f443d896176460",
"canvaskit/skwasm.wasm": "9f0c0c02b82a910d12ce0543ec130e60",
"canvaskit/skwasm.worker.js": "89990e8c92bcb123999aa81f7e203b1c",
"main.dart.js_286.part.js": "6e7b71aa13c014038f9a16d4ee285185",
"main.dart.js_290.part.js": "de3cd60a95986f80f1220fda1513a0cc",
"main.dart.js_1.part.js": "0293554cac43f74951379b849a42b302",
"main.dart.js_261.part.js": "08d76079f5828ff95ad063e7874f7082",
"main.dart.js_295.part.js": "5e09ed8446b2b939cf27177cde149f8f",
"main.dart.js_281.part.js": "1b656a673106dc613e627413196ac428",
"main.dart.js_221.part.js": "a3dbabe38237d794f5ed9cc902092066",
"main.dart.js_276.part.js": "c3d884a6daeb83f1dca4a54caee79ca3",
"main.dart.js_237.part.js": "f8999aa4e9053f82bb3c412cb0726301",
"main.dart.js_2.part.js": "08a0b964da2e23ac83d2e842ef97f559",
"main.dart.js_292.part.js": "4d17cd9212db1a5b57b6170445ffad15",
"main.dart.js_253.part.js": "fcb476b05b74b2ccf92c540cb1aada57",
"main.dart.js_248.part.js": "43cf8c5d54a1a438382f29ee2c50bd85",
"icons/Icon-192.png": "839e87c4f6800df757bb28180f8e2949",
"icons/Icon-512.png": "f57dad4f6efa0339b50d5c65f36dc03c",
"favicon.png": "a409751f0ecf6dee76fb350d7402f9be",
"main.dart.js_243.part.js": "635cd819b577ff516544c5c1bdf19617",
"main.dart.js_260.part.js": "99d34b718ca98f6eb8cd69d8f48518fc",
"main.dart.js_252.part.js": "3c898151225d0cfb0331883376bce8d8",
"main.dart.js_279.part.js": "b1bc53fc29ccc7b73125a0dbcd0705f3",
"main.dart.js_277.part.js": "c48ccd83a39cbff707d57147ea6725e1",
"main.dart.js_194.part.js": "647674e73f4721e8636962e4d4fa20ed",
"main.dart.js_14.part.js": "3cce8fbecdeb5984d1560c7506536a87",
"version.json": "8de5909270a83075fc8cc02271e7a17f",
"flutter_bootstrap.js": "e4e03468922fa3b4d3177a0329b2b7de"};
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
