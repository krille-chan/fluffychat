// Push-only service worker for Schellout Chat (fork addition, not upstream).
// Registered at scope ./push/ so it never interferes with Flutter's
// flutter_service_worker.js caching at the root scope.
//
// Sygnal (webpush pushkin) delivers the Matrix notification object as the
// encrypted Web Push payload. With the event_id_only pusher format the
// payload only carries ids + unread counts — E2EE content is never in the
// push, so we show a generic notification and open the app on tap.
'use strict';

self.addEventListener('install', () => self.skipWaiting());
self.addEventListener('activate', (event) => event.waitUntil(self.clients.claim()));

self.addEventListener('push', (event) => {
  let data = {};
  try {
    data = event.data ? event.data.json() : {};
  } catch (_) {
    // Non-JSON payload; fall through to generic notification.
  }
  const n = data.notification || data || {};
  const unread = n.counts && n.counts.unread;
  const body = unread
    ? unread + ' unread message' + (unread === 1 ? '' : 's')
    : 'New message';
  event.waitUntil(
    self.registration.showNotification('Schellout Chat', {
      body: body,
      icon: 'icons/Icon-192.png',
      badge: 'icons/Icon-192.png',
      tag: n.room_id || 'schellout-chat',
      data: { room_id: n.room_id || null },
    }),
  );
});

self.addEventListener('notificationclick', (event) => {
  event.notification.close();
  const roomId = event.notification.data && event.notification.data.room_id;
  // GoRouter uses hash URL strategy on web.
  const url = roomId ? './#/rooms/' + encodeURIComponent(roomId) : './';
  event.waitUntil(
    (async () => {
      const wins = await self.clients.matchAll({
        type: 'window',
        includeUncontrolled: true,
      });
      for (const win of wins) {
        if ('focus' in win) {
          await win.focus();
          if (roomId && 'navigate' in win) {
            try {
              await win.navigate(url);
            } catch (_) {
              // Cross-scope navigation may be disallowed; focus is enough.
            }
          }
          return;
        }
      }
      await self.clients.openWindow(url);
    })(),
  );
});
