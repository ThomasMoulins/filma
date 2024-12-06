class Person {
  final int id;
  final String name;
  final String profilePath;
  final String knownForDepartment;
  final double popularity;

  Person({
    required this.id,
    required this.name,
    required this.profilePath,
    required this.knownForDepartment,
    required this.popularity,
  });

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'] ?? '',
      knownForDepartment: json['known_for_department'] ?? '',
      popularity: (json['popularity'] as num).toDouble(),
    );
  }
}