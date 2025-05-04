import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/article.dart';
import 'package:news_app/services/config.dart';

class NewsService {
  // News API anahtarı ve temel URL'i config dosyasından al
  final String _apiKey = Config.newsApiKey;
  final String _baseUrl = Config.newsApiBaseUrl;
  final String _country = Config.defaultCountry;

  // API düzgün çalışmadığı durumda örnek veriler
  final List<Map<String, dynamic>> _sampleNewsData = [
    {
      "source": {"id": "cnn-turk", "name": "CNN Türk"},
      "author": "CNN Türk",
      "title": "Ekonomi: Türkiye'de enflasyon rakamları açıklandı",
      "description":
          "Türkiye İstatistik Kurumu (TÜİK), Haziran ayı enflasyon rakamlarını açıkladı. Buna göre, TÜFE'de yıllık bazda artış yüzde 38.2 oldu.",
      "url":
          "https://www.cnnturk.com/ekonomi/son-dakika-haziran-ayi-enflasyon-rakamlari-aciklandi",
      "urlToImage": "https://picsum.photos/id/1/800/400",
      "publishedAt": "2023-07-03T08:00:00Z",
      "content":
          "Türkiye İstatistik Kurumu (TÜİK), Haziran ayı enflasyon rakamlarını açıkladı. Buna göre, TÜFE'de yıllık bazda artış yüzde 38.2 oldu. Aylık bazda ise TÜFE artışı yüzde 1.75 olarak gerçekleşti. Yurt içi üretici fiyat endeksi (Yi-ÜFE) ise yıllık bazda yüzde 40.42 artış gösterdi.",
    },
    {
      "source": {"id": "haberturk", "name": "Habertürk"},
      "author": "Spor Servisi",
      "title": "Spor: Galatasaray yeni transferini açıkladı",
      "description":
          "Sarı-kırmızılı ekip, Fransız yıldız futbolcuyu kadrosuna kattığını resmen duyurdu. Oyuncu ile 3 yıllık sözleşme imzalandı.",
      "url":
          "https://www.haberturk.com/spor/futbol/galatasaray-yeni-transferini-acikladi",
      "urlToImage": "https://picsum.photos/id/2/800/400",
      "publishedAt": "2023-07-02T15:30:00Z",
      "content":
          "Galatasaray Spor Kulübü, Fransız orta saha oyuncusu ile 3 yıllık sözleşme imzaladığını resmen duyurdu. Transferin bonservis bedeli 12 milyon Euro olarak açıklandı. Oyuncuya yıllık net 3.5 milyon Euro ücret ödenecek.",
    },
    {
      "source": {"id": "ntv", "name": "NTV"},
      "author": "Teknoloji Editörü",
      "title": "Teknoloji: Apple, iOS 17'nin çıkış tarihini açıkladı",
      "description":
          "Apple, iPhone telefonlar için iOS 17 güncellemesinin ne zaman kullanıma sunulacağını açıkladı. Güncelleme birçok yeni özellik getiriyor.",
      "url":
          "https://www.ntv.com.tr/teknoloji/apple-ios-17nin-cikis-tarihini-acikladi",
      "urlToImage": "https://picsum.photos/id/3/800/400",
      "publishedAt": "2023-07-01T10:15:00Z",
      "content":
          "Apple, iPhone telefonlar için iOS 17 güncellemesinin Eylül ayında kullanıma sunulacağını açıkladı. Güncelleme ile kontrol merkezi yeniden tasarlandı, mesajlaşma uygulamasına yeni özellikler eklendi ve StandBy modu tanıtıldı. Güncelleme, iPhone 11 ve üzeri modellerde çalışacak.",
    },
    {
      "source": {"id": "milliyet", "name": "Milliyet"},
      "author": "Sağlık Servisi",
      "title": "Sağlık: Yeni COVID-19 aşısı onaylandı",
      "description":
          "Sağlık Bakanlığı, yeni geliştirilen COVID-19 aşısının kullanımını onayladı. Aşı, virüsün yeni varyantlarına karşı da etkili.",
      "url": "https://www.milliyet.com.tr/saglik/yeni-covid-19-asisi-onaylandi",
      "urlToImage": "https://picsum.photos/id/4/800/400",
      "publishedAt": "2023-06-30T14:45:00Z",
      "content":
          "Sağlık Bakanlığı, yeni geliştirilen COVID-19 aşısının kullanımını onayladı. Aşının klinik deneylerde virüsün mevcut varyantlarına karşı yüksek etkinlik gösterdiği belirtildi. Aşı, öncelikli gruplara Temmuz ayında uygulanmaya başlanacak.",
    },
    {
      "source": {"id": "hurriyet", "name": "Hürriyet"},
      "author": "Bilim Servisi",
      "title": "Bilim: Türk bilim insanları yeni bir element keşfetti",
      "description":
          "Türk bilim insanlarından oluşan bir ekip, periyodik tabloda yer alacak yeni bir element keşfetti. Element, uluslararası komisyon tarafından onaylandı.",
      "url":
          "https://www.hurriyet.com.tr/bilim/turk-bilim-insanlari-yeni-bir-element-kesfetti",
      "urlToImage": "https://picsum.photos/id/5/800/400",
      "publishedAt": "2023-06-29T09:20:00Z",
      "content":
          "Türk bilim insanlarından oluşan bir ekip, periyodik tabloda yer alacak yeni bir element keşfetti. 'Anadolum' adı verilen element, uluslararası kimya komisyonu tarafından onaylandı ve periyodik tabloya eklenecek. Bu keşif, Türk bilim tarihinde bir ilk olarak kayıtlara geçti.",
    },
    {
      "source": {"id": "sozcu", "name": "Sözcü"},
      "author": "Eğitim Servisi",
      "title": "Eğitim: YKS sonuçları açıklandı",
      "description":
          "ÖSYM, Yükseköğretim Kurumları Sınavı (YKS) sonuçlarını açıkladı. 3 milyona yakın adayın girdiği sınavda baraj puanını geçen aday sayısı belli oldu.",
      "url": "https://www.sozcu.com.tr/egitim/yks-sonuclari-aciklandi",
      "urlToImage": "https://picsum.photos/id/6/800/400",
      "publishedAt": "2023-06-28T12:00:00Z",
      "content":
          "ÖSYM, Yükseköğretim Kurumları Sınavı (YKS) sonuçlarını açıkladı. 3 milyona yakın adayın girdiği sınavda baraj puanını geçen aday sayısı 1.8 milyon oldu. Adaylar, tercihlerini 15-25 Temmuz tarihleri arasında yapabilecek.",
    },
    {
      "source": {"id": "sabah", "name": "Sabah"},
      "author": "Ekonomi Servisi",
      "title": "Ekonomi: Merkez Bankası faiz kararını açıkladı",
      "description":
          "Türkiye Cumhuriyet Merkez Bankası (TCMB), Temmuz ayı faiz kararını açıkladı. Politika faizi yüzde 8.5'ten yüzde 15'e yükseltildi.",
      "url":
          "https://www.sabah.com.tr/ekonomi/merkez-bankasi-faiz-kararini-acikladi",
      "urlToImage": "https://picsum.photos/id/7/800/400",
      "publishedAt": "2023-06-27T14:00:00Z",
      "content":
          "Türkiye Cumhuriyet Merkez Bankası (TCMB), Temmuz ayı faiz kararını açıkladı. Politika faizi yüzde 8.5'ten yüzde 15'e yükseltildi. TCMB açıklamasında, enflasyonla mücadele kapsamında parasal sıkılaştırma sürecinin başlatıldığı belirtildi.",
    },
    {
      "source": {"id": "trt-haber", "name": "TRT Haber"},
      "author": "Dış Haberler Servisi",
      "title": "Dünya: BM'den iklim değişikliği uyarısı",
      "description":
          "Birleşmiş Milletler (BM), iklim değişikliğiyle ilgili yeni bir rapor yayınladı. Raporda, küresel sıcaklık artışının kritik eşiği aşabileceği uyarısı yapıldı.",
      "url": "https://www.trthaber.com/dunya/bmden-iklim-degisikligi-uyarisi",
      "urlToImage": "https://picsum.photos/id/8/800/400",
      "publishedAt": "2023-06-26T11:30:00Z",
      "content":
          "Birleşmiş Milletler (BM), iklim değişikliğiyle ilgili yeni bir rapor yayınladı. Raporda, küresel sıcaklık artışının önlem alınmazsa 2030'a kadar 1.5 santigrat derecelik kritik eşiği aşabileceği uyarısı yapıldı. BM Genel Sekreteri, tüm ülkeleri acil önlem almaya çağırdı.",
    },
    {
      "source": {"id": "anadolu-ajansi", "name": "Anadolu Ajansı"},
      "author": "Kültür Sanat Servisi",
      "title": "Kültür-Sanat: İstanbul Film Festivali başladı",
      "description":
          "42. İstanbul Film Festivali, dünya sinemasının önemli yapımlarının gösterimiyle başladı. Festival kapsamında 60 ülkeden 150 film izleyiciyle buluşacak.",
      "url":
          "https://www.aa.com.tr/kultur-sanat/istanbul-film-festivali-basladi",
      "urlToImage": "https://picsum.photos/id/9/800/400",
      "publishedAt": "2023-06-25T20:00:00Z",
      "content":
          "42. İstanbul Film Festivali, dünya sinemasının önemli yapımlarının gösterimiyle başladı. Festival kapsamında 60 ülkeden 150 film izleyiciyle buluşacak. Festival, 9 Temmuz'a kadar devam edecek ve birçok ünlü yönetmen ve oyuncu festival için İstanbul'a gelecek.",
    },
    {
      "source": {"id": "bbc-turkce", "name": "BBC Türkçe"},
      "author": "Ekonomi Servisi",
      "title": "Ekonomi: Asgari ücrete yıl ortası zammı geliyor",
      "description":
          "Çalışma ve Sosyal Güvenlik Bakanı, asgari ücrete yıl ortasında zam yapılacağını açıkladı. Zam oranının enflasyon rakamları dikkate alınarak belirleneceği belirtildi.",
      "url":
          "https://www.bbc.com/turkce/ekonomi/asgari-ucrete-yil-ortasi-zammi-geliyor",
      "urlToImage": "https://picsum.photos/id/10/800/400",
      "publishedAt": "2023-06-24T16:45:00Z",
      "content":
          "Çalışma ve Sosyal Güvenlik Bakanı, asgari ücrete yıl ortasında zam yapılacağını açıkladı. Zam oranının enflasyon rakamları dikkate alınarak belirleneceği belirtildi. Asgari Ücret Tespit Komisyonu, Temmuz ayında toplanarak yeni ücreti belirleyecek.",
    },
  ];

  // Kategorilere göre örnek veriler
  final Map<String, List<int>> _categoryIndices = {
    'general': [0, 2, 4, 6, 8],
    'business': [0, 6, 9],
    'entertainment': [8],
    'health': [3],
    'science': [4],
    'sports': [1],
    'technology': [2],
  };

  // News API'den gelen verileri işleyerek şeritli görselleri filtreleyelim
  List<Article> _processArticles(List<dynamic> apiArticles) {
    return apiArticles.map((article) {
      // Şeritli görsel varsa, alternatif bir görsel kullan
      if (article['urlToImage'] != null &&
          (article['urlToImage'].toString().contains('caution') ||
              article['urlToImage'].toString().contains('warning'))) {
        // Şeritli görsel tespit edilirse temiz bir görsel atayalım
        article['urlToImage'] =
            "https://picsum.photos/800/400?random=${article['publishedAt']}";
      }
      return Article.fromJson(article);
    }).toList();
  }

  // Türkiye'deki en güncel haberleri getir
  Future<List<Article>> getTopHeadlines() async {
    try {
      // News API bazen Türkiye için boş sonuç dönebiliyor, "us" kaynak parametresini deneyelim
      print(
        'API çağrısı yapılıyor: $_baseUrl/top-headlines?country=us&apiKey=$_apiKey',
      );
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
      );

      print('API yanıt kodu: ${response.statusCode}');
      // Çok fazla veri yazdırmaması için kısıtlıyoruz
      if (response.body.length > 500) {
        print(
          'API yanıtı (ilk 500 karakter): ${response.body.substring(0, 500)}...',
        );
      } else {
        print('API yanıtı: ${response.body}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('API durumu: ${data['status']}');
        if (data['status'] == 'ok') {
          final List<dynamic> articles = data['articles'];
          print('Alınan haber sayısı: ${articles.length}');

          if (articles.isEmpty) {
            print('API hiç haber döndürmedi, örnek verileri kullanıyoruz');
            return _sampleNewsData
                .map((article) => Article.fromJson(article))
                .toList();
          }

          return _processArticles(articles);
        } else {
          // API hata döndü, örnek verileri kullan
          print('API hata döndü: ${data['message'] ?? 'Bilinmeyen hata'}');
          return _sampleNewsData
              .map((article) => Article.fromJson(article))
              .toList();
        }
      } else {
        // API çağrısı başarısız oldu, örnek verileri kullan
        print('API çağrısı başarısız: ${response.statusCode}');
        print('Hata içeriği: ${response.body}');
        return _sampleNewsData
            .map((article) => Article.fromJson(article))
            .toList();
      }
    } catch (e) {
      print('Haber getirme hatası: $e');
      // Hata durumunda örnek verileri kullan
      return _sampleNewsData
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  // Belirli bir kategorideki haberleri getir
  Future<List<Article>> getNewsByCategory(String category) async {
    try {
      // News API bazen Türkiye için boş sonuç dönebiliyor, "us" kaynak parametresini deneyelim
      print(
        'API çağrısı yapılıyor (kategori $category): $_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey',
      );
      final response = await http.get(
        Uri.parse(
          '$_baseUrl/top-headlines?country=us&category=$category&apiKey=$_apiKey',
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articles = data['articles'];
          print('Alınan kategori haberi sayısı: ${articles.length}');

          if (articles.isEmpty) {
            print(
              'API hiç kategori haberi döndürmedi, örnek verileri kullanıyoruz',
            );
            if (!_categoryIndices.containsKey(category)) {
              return getTopHeadlines(); // Kategori bulunamazsa tüm haberleri getir
            }

            final indices = _categoryIndices[category]!;
            return indices
                .map((index) => _sampleNewsData[index])
                .map((article) => Article.fromJson(article))
                .toList();
          }

          return _processArticles(articles);
        } else {
          // API hata döndü, örnek verileri kullan
          print('API hata döndü: ${data['message']}');
          if (!_categoryIndices.containsKey(category)) {
            return getTopHeadlines(); // Kategori bulunamazsa tüm haberleri getir
          }

          final indices = _categoryIndices[category]!;
          return indices
              .map((index) => _sampleNewsData[index])
              .map((article) => Article.fromJson(article))
              .toList();
        }
      } else {
        // API çağrısı başarısız oldu, örnek verileri kullan
        print('API çağrısı başarısız: ${response.statusCode}');
        if (!_categoryIndices.containsKey(category)) {
          return getTopHeadlines(); // Kategori bulunamazsa tüm haberleri getir
        }

        final indices = _categoryIndices[category]!;
        return indices
            .map((index) => _sampleNewsData[index])
            .map((article) => Article.fromJson(article))
            .toList();
      }
    } catch (e) {
      print('Haber getirme hatası: $e');
      // Hata durumunda örnek verileri kullan
      if (!_categoryIndices.containsKey(category)) {
        return getTopHeadlines(); // Kategori bulunamazsa tüm haberleri getir
      }

      final indices = _categoryIndices[category]!;
      return indices
          .map((index) => _sampleNewsData[index])
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  // Haber arama fonksiyonu
  Future<List<Article>> searchNews(String query) async {
    try {
      print('Arama yapılıyor: $_baseUrl/everything?q=$query&apiKey=$_apiKey');
      final response = await http.get(
        Uri.parse('$_baseUrl/everything?q=$query&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articles = data['articles'];
          print('Arama sonucu bulunan haber sayısı: ${articles.length}');

          if (articles.isEmpty) {
            print('Arama sonucu bulunamadı, örnek verileri kullanıyoruz');
            return _sampleNewsData
                .where(
                  (article) =>
                      article['title'].toString().toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      article['description'].toString().toLowerCase().contains(
                        query.toLowerCase(),
                      ),
                )
                .map((article) => Article.fromJson(article))
                .toList();
          }

          return _processArticles(articles);
        } else {
          print('API hata döndü: ${data['message'] ?? 'Bilinmeyen hata'}');
          return _sampleNewsData
              .where(
                (article) =>
                    article['title'].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ) ||
                    article['description'].toString().toLowerCase().contains(
                      query.toLowerCase(),
                    ),
              )
              .map((article) => Article.fromJson(article))
              .toList();
        }
      } else {
        print('API çağrısı başarısız: ${response.statusCode}');
        return _sampleNewsData
            .where(
              (article) =>
                  article['title'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
                  article['description'].toString().toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .map((article) => Article.fromJson(article))
            .toList();
      }
    } catch (e) {
      print('Haber arama hatası: $e');
      return _sampleNewsData
          .where(
            (article) =>
                article['title'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ) ||
                article['description'].toString().toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }

  // Son dakika haberlerini getir
  Future<List<Article>> getBreakingNews() async {
    try {
      // Son dakika haberleri için API çağrısı
      print(
        'API çağrısı yapılıyor (son dakika): $_baseUrl/top-headlines?country=us&apiKey=$_apiKey',
      );
      final response = await http.get(
        Uri.parse('$_baseUrl/top-headlines?country=us&apiKey=$_apiKey'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['status'] == 'ok') {
          final List<dynamic> articles = data['articles'];
          print('Alınan son dakika haberi sayısı: ${articles.length}');

          if (articles.isEmpty) {
            print(
              'API hiç son dakika haberi döndürmedi, örnek verileri kullanıyoruz',
            );
            return _sampleNewsData
                .take(5)
                .map((article) => Article.fromJson(article))
                .toList();
          }

          // Son 5 haberi al
          final breakingNews = articles.take(5).toList();
          return _processArticles(breakingNews);
        } else {
          // API hata döndü, örnek verilerin ilk 5 tanesini kullan
          print('API hata döndü: ${data['message']}');
          return _sampleNewsData
              .take(5)
              .map((article) => Article.fromJson(article))
              .toList();
        }
      } else {
        // API çağrısı başarısız oldu, örnek verilerin ilk 5 tanesini kullan
        print('API çağrısı başarısız: ${response.statusCode}');
        return _sampleNewsData
            .take(5)
            .map((article) => Article.fromJson(article))
            .toList();
      }
    } catch (e) {
      print('Son dakika haberleri getirme hatası: $e');
      // Hata durumunda örnek verilerin ilk 5 tanesini kullan
      return _sampleNewsData
          .take(5)
          .map((article) => Article.fromJson(article))
          .toList();
    }
  }
}
