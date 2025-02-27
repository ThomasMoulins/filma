import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie.dart';
import '../pages/movie_details_page.dart';

class MovieList extends StatefulWidget {
  final List<Movie> movies;

  const MovieList({super.key, required this.movies});

  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  double maxCrossAxisExtent = 200;
  double crossAxisSpacing = 40;
  bool isLoadingConfig = true;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      maxCrossAxisExtent = prefs.getDouble('maxCrossAxisExtent') ?? 200;
      crossAxisSpacing = prefs.getDouble('crossAxisSpacing') ?? 40;
      isLoadingConfig = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingConfig) {
      return const Center(child: CircularProgressIndicator());
    }
    return widget.movies.isEmpty
        ? const Center(
      child: Text(
        'Aucun film trouvé',
        style: TextStyle(fontSize: 18, color: Colors.grey),
      ),
    )
        : GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: maxCrossAxisExtent,
        crossAxisSpacing: crossAxisSpacing,
        mainAxisSpacing: crossAxisSpacing,
        childAspectRatio: 0.5,
      ),
      itemCount: widget.movies.length,
      itemBuilder: (context, index) {
        Movie movie = widget.movies[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsPage(movie: movie),
              ),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Affichage de l'image du film
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported, size: 50),
                        );
                      },
                    ),
                  ),
                ),
                // Détails du film
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        movie.releaseDate != null
                            ? '${movie.releaseDate!.toLocal().day.toString().padLeft(2, "0")}/${movie.releaseDate!.toLocal().month.toString().padLeft(2, "0")}/${movie.releaseDate!.toLocal().year}'
                            : 'Date inconnue',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 5),
                          Text(
                            '${movie.rating}',
                            style: const TextStyle(color: Colors.black, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
