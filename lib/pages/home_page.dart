import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../widgets/movie_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  void _loadMovies() async {
    List<Movie> fetchedMovies = await ApiService().fetchPopularMovies();
    setState(() {
      movies = fetchedMovies;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        // Si la recherche est vide, charger les films populaires
        _loadMovies();
      } else {
        // Sinon, effectuer la recherche
        List<Movie> searchedMovies = await ApiService().searchMovies(query);
        setState(() {
          movies = searchedMovies;
        });
      }
    });
  }

  void _selectCategory(String category) async {
    List<Movie> categoryMovies = await ApiService().fetchMoviesByCategory(category);
    setState(() {
      movies = categoryMovies;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        searchController: _searchController,
        onSearchChanged: _onSearchChanged,
        onCategorySelected: _selectCategory,
      ),
      body: MovieList(movies: movies),
    );
  }
}
