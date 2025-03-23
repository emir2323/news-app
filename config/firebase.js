import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";

// Firebase yapılandırma bilgileri
// Doğrudan tanımlanmış değerler
const firebaseConfig = {
  apiKey: "AIzaSyDA_2EFNVkJ5O3QyWcQA0XV6yV7dck4ATg",
  authDomain: "news-app-ff088.firebaseapp.com",
  projectId: "news-app-ff088",
  storageBucket: "news-app-ff088.appspot.com",
  messagingSenderId: "725390798052",
  appId: "1:725390798052:web:4d5ab9738597d12e33d0f1",
};

// Firebase uygulamasını başlat
const app = initializeApp(firebaseConfig);

// Auth servisini dışa aktar
const auth = getAuth(app);

export { auth };
