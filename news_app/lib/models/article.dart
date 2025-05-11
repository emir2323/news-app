class Article {
  final String? source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final String publishedAt;
  final String? content;

  Article({
    this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    required this.publishedAt,
    this.content,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    // API'den gelen source formatı farklı olabilir
    String? sourceValue;
    if (json['source'] != null) {
      if (json['source'] is String) {
        sourceValue = json['source'];
      } else if (json['source'] is Map) {
        sourceValue = json['source']['name'];
      }
    }

    return Article(
      source: sourceValue,
      author: json['author'],
      title: json['title'] ?? 'Başlık bulunamadı',
      description: json['description'],
      url: json['url'] ?? '',
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'] ?? DateTime.now().toIso8601String(),
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
    };
  }
}
