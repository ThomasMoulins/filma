import 'dart:convert';
import 'package:http/http.dart' as http;
import '../api_keys.dart';
import '../models/movie.dart';

class ApiService {
  final String _baseUrl = 'https://api.themoviedb.org/3';

  Future<List<Movie>> fetchPopularMovies() async {
    final response = await http.get(Uri.parse('$_baseUrl/movie/popular?api_key=$TMDB_API_KEY&language=fr-FR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List).map((movieJson) => Movie.fromJson(movieJson)).toList();
      return movies;
    } else {
      throw Exception('Erreur lors du chargement des films populaires');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search/movie?api_key=$TMDB_API_KEY&language=fr-FR&query=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List).map((movieJson) => Movie.fromJson(movieJson)).toList();
      return movies;
    } else {
      throw Exception('Erreur lors de la recherche de films');
    }
  }

  Future<List<Movie>> fetchMoviesByCategory(String category) async {
    int genreId = await _getGenreId(category);
    final response = await http.get(Uri.parse('$_baseUrl/discover/movie?api_key=$TMDB_API_KEY&language=fr-FR&with_genres=$genreId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Movie> movies = (data['results'] as List).map((movieJson) => Movie.fromJson(movieJson)).toList();
      return movies;
    } else {
      throw Exception('Erreur lors du chargement des films par catégorie');
    }
  }

  Future<List<dynamic>> getGenreList() async {
    final response = await http.get(Uri.parse('$_baseUrl/genre/movie/list?api_key=$TMDB_API_KEY&language=fr-FR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['genres'];
    } else {
      throw Exception('Erreur lors de la récupération des genres');
    }
  }

  Future<int> _getGenreId(String category) async {
    final response = await http.get(Uri.parse('$_baseUrl/genre/movie/list?api_key=$TMDB_API_KEY&language=fr-FR'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final genres = data['genres'] as List;
      final genre = genres.firstWhere((g) => g['name'].toString().toLowerCase() == category.toLowerCase(), orElse: () => null);
      if (genre != null) {
        return genre['id'];
      } else {
        throw Exception('Genre non trouvé');
      }
    } else {
      throw Exception('Erreur lors de la récupération des genres');
    }
  }
}
