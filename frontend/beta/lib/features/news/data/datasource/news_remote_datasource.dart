import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsArticle {
  final String title;
  final String url;
  final String source;
  final String publishedAt;
  final String? imageUrl;

  NewsArticle({
    required this.title,
    required this.url,
    required this.source,
    required this.publishedAt,
    this.imageUrl,
  });
}

class NewsDataSource {
  final String apiKey;

  NewsDataSource({required this.apiKey});

  Future<List<NewsArticle>> fetchType1DiabetesNews() async {
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=type%201%20diabetes&sortBy=publishedAt&language=en&apiKey=$apiKey',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final articles = (data['articles'] as List)
          .map((a) => NewsArticle(
                title: a['title'] ?? '',
                url: a['url'] ?? '',
                source: a['source']?['name'] ?? '',
                publishedAt: a['publishedAt'] ?? '',
                imageUrl: a['urlToImage'],
              ))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to fetch news: ${response.body}');
    }
  }
}
