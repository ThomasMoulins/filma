class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final String releaseDate;
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
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      releaseDate: json['release_date'] ?? 'Date inconnue',
      rating: (json['vote_average'] as num).toDouble(),
      genreIds: List<dynamic>.from(json['genre_ids'] ?? []),
    );
  }
}
