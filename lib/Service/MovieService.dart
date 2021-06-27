import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_app/Model/Movie.dart';
import 'package:movie_app/Service/HttpService.dart';

class MovieService {
  HttpService _httpService = new HttpService();
  final url = "https://api.themoviedb.org/3/movie";
  final searchUrl="https://api.themoviedb.org/3/search/movie";

  List<Movie> parseMovies(String responseBody) {
    final parsed = json.decode(responseBody)['results'].cast<Map<String, dynamic>>();
    return parsed.map<Movie>((json) => Movie.fromMap(json)).toList();
  }

  List<Movie> parseSearchedMovies(String responseBody) {
    final parsed = json.decode(responseBody)['results'].cast<Map<String, dynamic>>();
    return parsed.map<Movie>((json) => Movie.searchMap(json)).toList();
  }
  List<Movie> parseFavoriteMovies(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Movie>((json) => Movie.favoriteMovieMap(json)).toList();
  }

  Future<List<Movie>> findAll() async {
    final response = await _httpService.makeHttpCall("GET", url+"/top_rated", null);
    if (response != null && response.statusCode == 200) {
      return parseMovies(response.body);
    } else {
      throw Exception('Unable to fetch Movies from the REST API');
    }
  }

  Future<Movie> getMovieDetails(int id) async {
    final response = await _httpService.makeHttpCall("GET", url+"/$id", null);
    if (response != null && response.statusCode == 200) {
      final parsed = json.decode(response.body);
      return Movie.movieDetailMap(parsed);
    } else {
      throw Exception('Unable to fetch Movies from the REST API');
    }
  }

  Future<List<Movie>> findPopular() async {
    final response = await _httpService.makeHttpCall("GET", url+"/popular", null);
    if (response != null && response.statusCode == 200) {
      return parseMovies(response.body);
    } else {
      throw Exception('Unable to fetch Popular Movies from the REST API');
    }
  }

  Future<List<Movie>> findUpcoming() async {
    final response = await _httpService.makeHttpCall("GET", url+"/upcoming", null);
    if (response != null && response.statusCode == 200) {
      return parseMovies(response.body);
    } else {
      throw Exception('Unable to fetch Upcoming Movies from the REST API');
    }
  }

  Future<List<Movie>> findNowPlaying() async {
    final response = await _httpService.makeHttpCall("GET", url+"/now_playing", null);
    if (response != null && response.statusCode == 200) {
      return parseMovies(response.body);
    } else {
      throw Exception('Unable to fetch Now Playing Movies from the REST API');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    Map<String, String> queryParams = {
      'query': query
    };
    String queryString = Uri(queryParameters: queryParams).query;
    final response = await _httpService.makeHttpCall("GET", searchUrl+'?'+queryString, null);
    if (response != null && response.statusCode == 200) {
      return parseSearchedMovies(response.body);
    } else {
      throw Exception('Unable to Search Movies from the REST API');
    }
  }
}
