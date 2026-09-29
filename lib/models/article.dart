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
}