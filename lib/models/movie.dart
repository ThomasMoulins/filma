class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final DateTime? releaseDate;
  final double rating;
  final List<dynamic> genreIds;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.releaseDate,
    required this.rating,
    required this.genreIds,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    DateTime? parsedReleaseDate;
    if (json['release_date'] != null && json['release_date'].toString().isNotEmpty) {
      parsedReleaseDate = DateTime.tryParse(json['release_date']);
    }

    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: parsedReleaseDate,
      rating: (json['vote_average'] as num).toDouble(),
      genreIds: List<dynamic>.from(json['genre_ids'] ?? []),
    );
  }
}
