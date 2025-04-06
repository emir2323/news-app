# Firebase Kurulum Kılavuzu

Bu kılavuz, uygulamanızda karşılaştığınız "Firebase: Error (auth/api-key-not-valid.-please-pass-a-valid-api-key.)" hatasını çözmek için adım adım talimatlar içermektedir.

## Hata Nedeni

Bu hata, Firebase yapılandırma bilgilerinizin (özellikle API anahtarınızın) geçersiz olduğunu göstermektedir. `.env` dosyasındaki Firebase yapılandırma bilgilerinin doğru değerlerle güncellenmesi gerekmektedir.

## Çözüm Adımları

### 1. Firebase Konsoluna Giriş Yapın

1. [Firebase Console](https://console.firebase.google.com/) adresine gidin
2. Google hesabınızla giriş yapın

### 2. Firebase Projenizi Seçin veya Yeni Bir Proje Oluşturun

- Eğer zaten bir Firebase projeniz varsa, listeden seçin
- Yoksa "Proje Ekle" butonuna tıklayarak yeni bir proje oluşturun

### 3. Firebase Yapılandırma Bilgilerini Alın

1. Firebase Console'da projenizin ana sayfasına gidin
2. Sayfanın sol üst köşesindeki "Proje Ayarları" (⚙️) simgesine tıklayın
3. "Genel" sekmesinde aşağı kaydırın ve "Web uygulaması ekle" (</>) simgesine tıklayın
   - Eğer zaten bir web uygulaması eklediyseniz, mevcut uygulamanızı seçebilirsiniz
4. Uygulamanıza bir takma ad verin (örneğin "fonk-project") ve "Kaydol" butonuna tıklayın
5. Firebase size bir yapılandırma nesnesi gösterecektir. Bu nesne şuna benzer olacaktır:

```javascript
const firebaseConfig = {
  apiKey: "AIzaSyC1_example_key_here",
  authDomain: "your-project-id.firebaseapp.com",
  projectId: "your-project-id",
  storageBucket: "your-project-id.appspot.com",
  messagingSenderId: "123456789012",
  appId: "1:123456789012:web:abc123def456",
};
```

### 4. .env Dosyasını Güncelleyin

1. Projenizin kök dizininde bulunan `.env` dosyasını bir metin editörü ile açın
2. Aşağıdaki değerleri Firebase konsolundan aldığınız gerçek değerlerle değiştirin:

```
FIREBASE_API_KEY=AIzaSyC1_example_key_here
FIREBASE_AUTH_DOMAIN=your-project-id.firebaseapp.com
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_STORAGE_BUCKET=your-project-id.appspot.com
FIREBASE_MESSAGING_SENDER_ID=123456789012
FIREBASE_APP_ID=1:123456789012:web:abc123def456
```

### 5. Firebase Authentication'ı Etkinleştirin

1. Firebase Console'da sol menüden "Authentication" seçeneğine tıklayın
2. "Sign-in method" sekmesine geçin
3. "Email/Password" sağlayıcısını etkinleştirin ve "Kaydet" butonuna tıklayın

### 6. Uygulamayı Yeniden Başlatın

1. Terminalde aşağıdaki komutu çalıştırarak uygulamayı yeniden başlatın:

```bash
npm start
```

## Sorun Devam Ederse

Eğer yukarıdaki adımları tamamladıktan sonra hala sorun yaşıyorsanız:

1. Firebase konsolunda yeni bir web uygulaması oluşturun ve yeni yapılandırma bilgilerini kullanın
2. `.env` dosyasındaki tüm değerlerin doğru formatta olduğundan emin olun (tırnak işareti veya boşluk olmamalı)
3. Uygulamayı tamamen durdurun ve yeniden başlatın
4. Expo önbelleğini temizleyin: `npx expo start -c`

## Önemli Güvenlik Notu

- `.env` dosyası `.gitignore` dosyasına eklenmiştir, bu nedenle API anahtarlarınız GitHub'a yüklenmeyecektir
- Firebase API anahtarlarınızı hiçbir zaman halka açık bir yerde paylaşmayın
