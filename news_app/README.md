# News App

Bu Flutter uygulaması, News API kullanarak gerçek zamanlı haber verileri sunar.

## News API Kurulumu

Uygulamanın düzgün çalışması için News API anahtarı almanız gerekmektedir:

1. [News API](https://newsapi.org/) web sitesine gidin ve ücretsiz bir hesap oluşturun
2. Kayıt olduktan sonra API anahtarınızı alın
3. `lib/services/config.dart` dosyasını açın
4. `newsApiKey` değişkenini API anahtarınızla güncelleyin:

```dart
static const String newsApiKey = "YOUR_NEWS_API_KEY"; // Buraya kendi API anahtarınızı yazın
```

## Uygulamanın Özellikleri

- Farklı kategorilerde haberler (Genel, Spor, Teknoloji, vb.)
- Haber arama özelliği
- Son dakika haberleri
- Haber detay sayfası

## API Sınırlamaları

News API'nin ücretsiz sürümünde aşağıdaki sınırlamalar bulunmaktadır:

- Günlük 100 istek sınırı
- Yalnızca geliştirme ortamında kullanım (yayınlanan uygulamalarda kullanılamaz)
- 1 ay öncesine kadar olan haberler

Eğer uygulamanızı yayınlamayı planlıyorsanız, ücretli bir API planına geçmeniz veya alternatif bir haber API'si kullanmanız gerekecektir.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
