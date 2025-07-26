import 'dart:convert';
import 'package:http/http.dart' as http;
import 'app_url_manager.dart';

class AppApiManager {
  static Future<void> getMovieDetail({
    required String searchQuery,
    required Function(Map<String, dynamic>) successBlock,
    required Function(Exception) failureBlock,
  }) async {
    final url = Uri.parse('${AppURLManager.omdbBaseUrl}?s=$searchQuery&apikey=${AppURLManager.omdbApiKey}');

    try {
      print("Requesting: $url");
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['Response'] == 'True') {
        successBlock(data);
      } else {
        failureBlock(Exception(data['Error'] ?? 'Unknown error'));
      }
    } catch (e) {
      failureBlock(Exception('Failed to fetch movie details.'));
    }
  }

  static Future<void> viewMovieDetail({
    required String imDbID,
    required Function(Map<String, dynamic>) successBlock,
    required Function(Exception) failureBlock,
  }) async {
    final url = Uri.parse('${AppURLManager.omdbBaseUrl}?i=$imDbID&apikey=${AppURLManager.omdbApiKey}');

    try {
      print("Requesting: $url");
      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['Response'] == 'True') {
        successBlock(data);
      } else {
        failureBlock(Exception(data['Error'] ?? 'Unknown error'));
      }
    } catch (e) {
      failureBlock(Exception('Failed to fetch movie details.'));
    }
  }

}
