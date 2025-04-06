# Firebase Yapılandırma Kılavuzu

Bu proje, kimlik doğrulama işlemleri için Firebase Authentication kullanmaktadır. Projeyi çalıştırmak için Firebase yapılandırmasını tamamlamanız gerekmektedir.

## Firebase Projenizi Oluşturma

1. [Firebase Console](https://console.firebase.google.com/) adresine gidin ve Google hesabınızla giriş yapın.
2. "Proje Ekle" butonuna tıklayın ve yeni bir proje oluşturun.
3. Proje oluşturulduktan sonra, sol menüden "Authentication" seçeneğine tıklayın.
4. "Sign-in method" sekmesine geçin ve "Email/Password" sağlayıcısını etkinleştirin.

## Firebase Yapılandırma Bilgilerini Alma

1. Firebase Console'da projenizin ana sayfasına gidin.
2. "Proje Ayarları" (⚙️) simgesine tıklayın.
3. "Genel" sekmesinde aşağı kaydırın ve "Web uygulaması ekle" (</>) simgesine tıklayın.
4. Uygulamanıza bir takma ad verin ve "Kaydol" butonuna tıklayın.
5. Firebase, aşağıdaki bilgileri içeren bir yapılandırma nesnesi gösterecektir:
   - apiKey
   - authDomain
   - projectId
   - storageBucket
   - messagingSenderId
   - appId

## Projeyi Yapılandırma

1. Projenin kök dizininde bulunan `.env` dosyasını açın.
2. Firebase yapılandırma bilgilerinizi aşağıdaki formatta girin:

```
FIREBASE_API_KEY=YOUR_API_KEY
FIREBASE_AUTH_DOMAIN=YOUR_AUTH_DOMAIN
FIREBASE_PROJECT_ID=YOUR_PROJECT_ID
FIREBASE_STORAGE_BUCKET=YOUR_STORAGE_BUCKET
FIREBASE_MESSAGING_SENDER_ID=YOUR_MESSAGING_SENDER_ID
FIREBASE_APP_ID=YOUR_APP_ID
```

3. `YOUR_API_KEY`, `YOUR_AUTH_DOMAIN` vb. değerleri Firebase Console'dan aldığınız gerçek değerlerle değiştirin.

## Projeyi Çalıştırma

Yapılandırmayı tamamladıktan sonra, projeyi aşağıdaki komutla başlatabilirsiniz:

```bash
npm start
```

## Sorun Giderme

Eğer "Firebase: Error (auth/api-key-not-valid.-please-pass-a-valid-api-key.)" hatası alıyorsanız:

1. `.env` dosyasındaki API anahtarının doğru olduğundan emin olun.
2. Projeyi yeniden başlatın: `npm start`
3. Hala sorun yaşıyorsanız, Firebase Console'dan yeni bir web uygulaması oluşturun ve yeni yapılandırma bilgilerini kullanın.

## Güvenlik Notları

- `.env` dosyası `.gitignore` dosyasına eklenmiştir, bu nedenle API anahtarlarınız GitHub'a yüklenmeyecektir.
- Üretim ortamında, Firebase Authentication için ek güvenlik önlemleri almanız önerilir.
