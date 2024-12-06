import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../models/person.dart';
import '../services/api_service.dart';
import '../widgets/movie_list.dart';

class PersonMoviesPage extends StatefulWidget {
  final Person person;
  const PersonMoviesPage({super.key, required this.person});

  @override
  State<PersonMoviesPage> createState() => _PersonMoviesPageState();
}

class _PersonMoviesPageState extends State<PersonMoviesPage> {
  List<Movie> movies = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPersonMovies();
  }

  Future<void> _fetchPersonMovies() async {
    try {
      List<Movie> fetchedMovies = await ApiService().fetchPersonMovies(widget.person.id);

      // Trier les films par date de sortie décroissante
      fetchedMovies.sort((a, b) {
        DateTime dateA = a.releaseDate ?? DateTime(1900);
        DateTime dateB = b.releaseDate ?? DateTime(1900);
        return dateB.compareTo(dateA);
      });

      setState(() {
        movies = fetchedMovies;
        isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération des films : $e');
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : movies.isEmpty
          ? const Center(
        child: Text('Aucun film trouvé pour cette personne.'),
      )
          : MovieList(movies: movies),
    );
  }
}
