class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String publishedAt;
  final String articleUrl;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.publishedAt,
    required this.articleUrl,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'No title available',
      description: json['description'] ?? 'No description available',
      imageUrl: json['urlToImage'] ?? '',
      source: json['source']?['name'] ?? 'Unknown source',
      publishedAt: json['publishedAt'] ?? '',
      articleUrl: json['url'] ?? '',
    );
  }

  /// Used when saving the article to Firestore.
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'source': source,
      'publishedAt': publishedAt,
      'articleUrl': articleUrl,
    };
  }

  /// Used when reading a saved article back from Firestore.
  factory Article.fromMap(Map<String, dynamic> map) {
    return Article(
      title: (map['title'] ?? 'No title available').toString(),
      description: (map['description'] ?? '').toString(),
      imageUrl: (map['imageUrl'] ?? '').toString(),
      source: (map['source'] ?? 'Unknown source').toString(),
      publishedAt: (map['publishedAt'] ?? '').toString(),
      articleUrl: (map['articleUrl'] ?? '').toString(),
    );
  }
}