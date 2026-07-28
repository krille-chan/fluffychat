// Web Push helper for Schellout Chat (fork addition, not upstream).
// Registers a dedicated push service worker and exposes
// window.schelloutWebPush.subscribe(vapidPublicKey) -> Promise<string(JSON)>
// The returned JSON is the PushSubscription (endpoint + p256dh/auth keys),
// which the Dart side turns into a Matrix pusher pointing at Sygnal.
(function () {
  'use strict';

  function urlBase64ToUint8Array(base64String) {
    const padding = '='.repeat((4 - (base64String.length % 4)) % 4);
    const base64 = (base64String + padding)
      .replace(/-/g, '+')
      .replace(/_/g, '/');
    const raw = atob(base64);
    return Uint8Array.from([...raw].map((c) => c.charCodeAt(0)));
  }

  function waitForActive(reg) {
    return new Promise((resolve, reject) => {
      if (reg.active) return resolve();
      const sw = reg.installing || reg.waiting;
      if (!sw) return reject(new Error('No service worker found'));
      sw.addEventListener('statechange', () => {
        if (sw.state === 'activated') resolve();
        if (sw.state === 'redundant') reject(new Error('Service worker redundant'));
      });
    });
  }

  async function subscribe(vapidPublicKey) {
    if (!('serviceWorker' in navigator) || !('PushManager' in window)) {
      throw new Error('Push is not supported in this browser');
    }
    const permission = await Notification.requestPermission();
    if (permission !== 'granted') {
      throw new Error('Notification permission: ' + permission);
    }
    // Separate scope so we do not clash with flutter_service_worker.js (root).
    const reg = await navigator.serviceWorker.register('push_service_worker.js', {
      scope: './push/',
    });
    await waitForActive(reg);
    let sub = await reg.pushManager.getSubscription();
    if (!sub) {
      sub = await reg.pushManager.subscribe({
        userVisibleOnly: true,
        applicationServerKey: urlBase64ToUint8Array(vapidPublicKey),
      });
    }
    return JSON.stringify(sub.toJSON());
  }

  // Resolves to 'granted' | 'denied' | 'default' without prompting.
  function permissionState() {
    return ('Notification' in window) ? Notification.permission : 'denied';
  }

  window.schelloutWebPush = { subscribe: subscribe, permissionState: permissionState };
})();
