import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieDetailsPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  Future<String> _getGenres() async {
    // Obtenir la liste complète des genres
    final response = await ApiService().getGenreList();
      List<dynamic> genres = response;
      List<String> genreNames = [];
      for (var genreId in movie.genreIds) {
        var genre = genres.firstWhere((g) => g['id'] == genreId, orElse: () => null);
        if (genre != null) {
          genreNames.add(genre['name']);
        }
      }
      return genreNames.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    // Obtenir la hauteur totale de l'écran
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      // Suppression de l'AppBar pour un affichage plein écran
      body: FutureBuilder<String>(
        future: _getGenres(),
        builder: (context, snapshot) {
          String genres = snapshot.data ?? 'Chargement...';

          return Stack(
            children: [
              // Image de fond occupant toute la hauteur de l'écran
              Positioned.fill(
                child: Image.network(
                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                  fit: BoxFit.cover,
                ),
              ),
              // Superposition d'un dégradé pour assombrir l'image
              Positioned.fill(
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black87],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.01, 1.0],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight,
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: screenHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Titre du film
                              Text(
                                movie.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Genres
                              Text(
                                'Genres: $genres',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Date de sortie et note
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                  const SizedBox(width: 5),
                                  Text(
                                    movie.releaseDate,
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                  const SizedBox(width: 20),
                                  const Icon(Icons.star, color: Colors.amber, size: 16),
                                  const SizedBox(width: 5),
                                  Text(
                                    '${movie.rating}',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Synopsis
                              const Text(
                                'Synopsis',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                movie.overview,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Bouton de retour en haut de la page
              Positioned(
                top: MediaQuery.of(context).padding.top + 10,
                left: 10,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
