// Firebase Cloud Messaging service worker

importScripts(
  'https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js'
);

importScripts(
  'https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js'
);

firebase.initializeApp({
  apiKey: 'AIzaSyDzJ2C0dsjq3L8novHjxAzqsdX3fWmcp08',
  authDomain: 'clean-news-global-2f8e1.firebaseapp.com',
  projectId: 'clean-news-global-2f8e1',
  storageBucket: 'clean-news-global-2f8e1.firebasestorage.app',
  messagingSenderId: '725968110216',
  appId: '1:725968110216:web:1fbdf3d5d1ddd629d7153d',
  measurementId: 'G-DJG80BXH8R',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  console.log(
    '[firebase-messaging-sw.js] Received background message:',
    payload
  );
});