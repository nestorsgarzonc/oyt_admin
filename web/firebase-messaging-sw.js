importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
    apiKey: "AIzaSyBsMUdIG1CwD_jRGS95rZGghYBp4le4roo",
    authDomain: "on-your-table.firebaseapp.com",
    projectId: "on-your-table",
    storageBucket: "on-your-table.appspot.com",
    messagingSenderId: "111373113185",
    appId: "1:111373113185:web:557c0f86c897c0c6945720",
});

const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((message) => {
    console.log("onBackgroundMessage", message);
});