import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';

  final String _apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

  // ------------------------------------------------------------
  // TOP HEADLINES
  // ------------------------------------------------------------

  Future<List<Article>> getTopHeadlines({
    String country = 'us',
    String? category,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('News API key not found.');
    }

    final queryParameters = {
      'apiKey': _apiKey,
      'country': country,
      if (category != null) 'category': category,
    };

    final uri = Uri.parse('$_baseUrl/top-headlines')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    print('TOP HEADLINES RESPONSE: $data');

    if (data['status'] != 'ok') {
      throw Exception(data['message'] ?? 'Failed to load news.');
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    return articlesJson.map((json) => Article.fromJson(json)).toList();
  }

  // ------------------------------------------------------------
  // INDIA NEWS
  // ------------------------------------------------------------

  Future<List<Article>> getIndiaNews({String? category}) async {
    if (_apiKey.isEmpty) {
      throw Exception('News API key not found.');
    }

    final query = category == null ? 'India' : 'India AND $category';

    final queryParameters = {
      'apiKey': _apiKey,
      'q': query,
      'language': 'en',
      'sortBy': 'publishedAt',
      'pageSize': '50',
    };

    final uri = Uri.parse('$_baseUrl/everything')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load India news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    print('INDIA NEWS RESPONSE: $data');

    if (data['status'] != 'ok') {
      throw Exception(data['message'] ?? 'Failed to load India news.');
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    const indianSources = {
      'The Hindu',
      'The Indian Express',
      'Hindustan Times',
      'NDTV',
      'Times of India',
      'India Today',
      'Deccan Herald',
      'News18',
      'Moneycontrol',
      'Business Standard',
      'Financial Express',
      'Firstpost',
      'ThePrint',
      'The Telegraph',
      'Livemint',
      'Scroll.in',
      'The Quint',
      'Outlook India',
      'Tribune India',
    };

    final List<Article> articles = [];

    for (final json in articlesJson) {
      final sourceName = json['source']?['name']?.toString() ?? '';

      if (indianSources.contains(sourceName)) {
        articles.add(Article.fromJson(json));
      }
    }

    print('INDIAN ARTICLES AFTER FILTER: ${articles.length}');

    return articles;
  }

  // ------------------------------------------------------------
  // INTERNATIONAL NEWS
  // ------------------------------------------------------------

  Future<List<Article>> getInternationalNews({String? category}) async {
    if (_apiKey.isEmpty) {
      throw Exception('News API key not found.');
    }

    final query = category == null
        ? 'world OR international'
        : 'world AND $category';

    final queryParameters = {
      'apiKey': _apiKey,
      'q': query,
      'language': 'en',
      'sortBy': 'publishedAt',
      'pageSize': '30',
    };

    final uri = Uri.parse('$_baseUrl/everything')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load international news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    print('INTERNATIONAL NEWS RESPONSE: $data');

    if (data['status'] != 'ok') {
      throw Exception(data['message'] ?? 'Failed to load international news.');
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    return articlesJson.map((json) => Article.fromJson(json)).toList();
  }

  // ------------------------------------------------------------
  // SEARCH NEWS
  // ------------------------------------------------------------

  Future<List<Article>> searchNews(String query) async {
    if (_apiKey.isEmpty) {
      throw Exception('News API key not found.');
    }

    if (query.trim().isEmpty) {
      return [];
    }

    final queryParameters = {
      'apiKey': _apiKey,
      'q': query.trim(),
      'language': 'en',
      'sortBy': 'publishedAt',
      'pageSize': '30',
    };

    final uri = Uri.parse('$_baseUrl/everything')
        .replace(queryParameters: queryParameters);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to search news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    print('SEARCH NEWS RESPONSE: $data');

    if (data['status'] != 'ok') {
      throw Exception(data['message'] ?? 'Failed to search news.');
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    return articlesJson.map((json) => Article.fromJson(json)).toList();
  }
}
