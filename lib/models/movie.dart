class Movie {
  final int id;
  final String title;
  final String overview;
  final String posterPath;
  final List<dynamic> genreIds;
  final String releaseDate;
  final double rating;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.genreIds,
    required this.releaseDate,
    required this.rating,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'] ?? '',
      genreIds: json['genre_ids'] ?? [],
      releaseDate: json['release_date'] ?? '',
      rating: (json['vote_average'] as num).toDouble(),
    );
  }
}
