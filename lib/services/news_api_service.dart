import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';

  final String _apiKey = dotenv.env['NEWS_API_KEY'] ?? '';

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

    final uri = Uri.parse(
      '$_baseUrl/top-headlines',
    ).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'ok') {
      throw Exception(
        data['message'] ?? 'Failed to load news.',
      );
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    return articlesJson
        .map((json) => Article.fromJson(json))
        .toList();
  }

  // Fetch India-focused news using the Everything endpoint.
  // This is used instead of country=in because it is more reliable
  // across NewsAPI plans/configurations.
  Future<List<Article>> getIndiaNews({
    String? category,
  }) async {
    if (_apiKey.isEmpty) {
      throw Exception('News API key not found.');
    }

    final query = category == null
        ? 'India'
        : 'India AND $category';

    final queryParameters = {
      'apiKey': _apiKey,
      'q': query,
      'language': 'en',
      'sortBy': 'publishedAt',
      'pageSize': '30',
    };

    final uri = Uri.parse(
      '$_baseUrl/everything',
    ).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load India news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'ok') {
      throw Exception(
        data['message'] ?? 'Failed to load India news.',
      );
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    return articlesJson
        .map((json) => Article.fromJson(json))
        .toList();
  }

  // Fetch broad English-language international/world news.
  // Used when the user selects the INTERNATIONAL region.
  Future<List<Article>> getInternationalNews({
    String? category,
  }) async {
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

    final uri = Uri.parse(
      '$_baseUrl/everything',
    ).replace(
      queryParameters: queryParameters,
    );

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception(
        'Failed to load international news. Status code: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['status'] != 'ok') {
      throw Exception(
        data['message'] ?? 'Failed to load international news.',
      );
    }

    final List<dynamic> articlesJson = data['articles'] ?? [];

    return articlesJson
        .map((json) => Article.fromJson(json))
        .toList();
  }
}
