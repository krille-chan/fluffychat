/**
 * Flutter Local Notifications - Service Worker
 * 
 * This service worker handles notification clicks for the flutter_local_notifications_web plugin.
 * It enables notifications to work even when the Flutter app is closed or in the background.
 * 
 * HOW IT WORKS:
 * 1. When a notification is clicked, the browser triggers a 'notificationclick' event
 * 2. This service worker intercepts that event and checks if the app is already open
 * 3. If the app is open, it sends the notification data via postMessage()
 * 4. If the app is closed, it opens the app with notification details as URL query parameters
 * 
 * CUSTOMIZATION:
 * - To change the URL opened when clicking notifications, modify the `url` variable in _handleNotif()
 * - To add custom notification handling logic, extend the _handleNotif() function
 * - To handle additional notification actions, check the `event.action` property
 * 
 * IMPORTANT NOTES:
 * - This file is automatically registered by the plugin during initialization
 * - The service worker must be served from the root of your domain for security reasons
 * - Changes to this file require re-registering the service worker (clear browser cache or increment version)
 */

'use strict';

// Handles a clicked notification.
//
// If the site is open, sends the information to the site using postMessage().
// Otherwise, open the site with notification details as query parameters.
async function _handleNotif(event) {
  // We have to use `event.waitUntil()` to tell the browser that we're still
  // processing this event. Without this, the event "expires" after the first
  // `await`, and trying to call `clients.openWindow()` later results in a
  // permission error, because the browser thinks they are unrelated events.
  let allClientsPromise = clients.matchAll({ type: 'window', includeUncontrolled: true });
  event.waitUntil(allClientsPromise);
  let allClients = await allClientsPromise;

  // Extract reply text if available (Chrome-only feature for text input actions)
  // Note: event.reply is only available in Chrome and only for text input actions
  let reply = '';
  if (event.reply !== undefined && event.reply !== null) {
    reply = event.reply;
  }

  let message = {
    id: event.notification.tag,
    payload: event.notification.data?.payload || '',
    action: event.action || '',
    reply: reply,
  };

  if (allClients.length == 0) {
    // No clients are open, so open a new window with notification details
    let url = `/?notification_id=${encodeURIComponent(message.id)}`
      + `&notification_payload=${encodeURIComponent(message.payload)}`
      + `&notification_action=${encodeURIComponent(message.action)}`
      + `&notification_reply=${encodeURIComponent(message.reply)}`;
    await clients.openWindow(url);
  } else {
    // At least one client is open, send the message to the first one
    let client = allClients[0];
    await client.postMessage(message);
  }

  // Close the notification after handling
  event.notification.close();
}

// Listen for notification events.
self.addEventListener("notificationclick", _handleNotif);

// Normally, a service worker only takes effect the _next_ time it is installed.
// These next lines make sure it takes effect the first time.
self.addEventListener("install", event => { self.skipWaiting(); });
self.addEventListener("activate", event => { event.waitUntil(clients.claim()); });

