import 'dart:async';
import 'package:flutter/material.dart';
import '../models/person.dart';
import '../widgets/custom_app_bar.dart';
import '../services/api_service.dart';
import '../models/movie.dart';
import '../widgets/movie_list.dart';
import '../widgets/person_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Movie> movies = [];
  List<Person> people = [];
  bool _isFilmMode = true;
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

  void _onModeChanged(bool isFilmMode) {
    setState(() {
      _isFilmMode = isFilmMode;
      _searchController.clear();
      if (_isFilmMode) {
        _loadMovies();
      } else {
        movies = [];
        people = [];
      }
    });
  }


  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isEmpty) {
        if (_isFilmMode) {
          _loadMovies();
        } else {
          setState(() {
            people = [];
          });
        }
      } else {
        if (_isFilmMode) {
          List<Movie> searchedMovies = await ApiService().searchMovies(query);
          setState(() {
            movies = searchedMovies;
          });
        } else {
          List<Person> searchedPeople = await ApiService().searchPeople(query);
          setState(() {
            people = searchedPeople;
          });
        }
      }
    });
  }

  void _onCategorySelect(String category) async {
    List<Movie> categoryMovies = await ApiService().fetchMoviesByCategory(category);
    setState(() {
      movies = categoryMovies;
    });
  }

  void _onCompanySelected(String companyId) async {
    // Récupérer les films de la compagnie
    List<Movie> companyMovies = await ApiService().fetchMoviesByCompany(companyId);
    setState(() {
      movies = companyMovies;
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
        onSearchChanged: _onSearchChanged,
        onModeChanged: _onModeChanged,
        onCategorySelected: _onCategorySelect,
        onCompanySelected: _onCompanySelected,
        searchController: _searchController,
      ),
      body: _isFilmMode
          ? MovieList(movies: movies)
          : PersonList(people: people)
    );
  }
}
