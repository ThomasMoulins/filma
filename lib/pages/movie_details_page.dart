import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/movie.dart';
import '../services/api_service.dart';

class MovieDetailsPage extends StatefulWidget {
  final Movie movie;

  const MovieDetailsPage({super.key, required this.movie});

  @override
  MovieDetailsPageState createState() => MovieDetailsPageState();
}

class MovieDetailsPageState extends State<MovieDetailsPage> {
  String _genres = 'Chargement...';
  YoutubePlayerController? _youtubeController;
  bool _isPlayerReady = false;
  bool _hasTrailer = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _getGenres();
    await _getTrailerId();
    setState(() {});
  }

  Future<void> _getGenres() async {
    final response = await ApiService().getGenreList();
    List<dynamic> genresList = response;
    List<String> genreNames = [];
    for (var genreId in widget.movie.genreIds) {
      var genre = genresList.firstWhere(
            (g) => g['id'] == genreId,
        orElse: () => null,
      );
      if (genre != null) {
        genreNames.add(genre['name']);
      }
    }
    _genres = genreNames.join(', ');
  }

  Future<void> _getTrailerId() async {
    try {
      List<dynamic> videos = await ApiService().fetchMovieVideos(widget.movie.id);
      if (videos.isNotEmpty) {
        for (var video in videos) {
          if (video['site'] == 'YouTube' && video['type'] == 'Trailer') {
            String? videoId = video['key'];
            if (videoId != null && videoId.isNotEmpty) {
              _initializeYoutubePlayer(videoId);
              _hasTrailer = true;
              break;
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la récupération du trailer: $e');
      }
    }
  }

  void _initializeYoutubePlayer(String videoId) {
    _youtubeController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    )..addListener(_youtubeListener);
  }

  void _youtubeListener() {
    if (_isPlayerReady && !(_youtubeController?.value.isFullScreen ?? false)) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _youtubeController?.removeListener(_youtubeListener);
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Utilisation d'un CustomScrollView avec des Slivers
      body: CustomScrollView(
        slivers: [
          // SliverAppBar avec effet de défilement
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.movie.title),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    'https://image.tmdb.org/t/p/w500${widget.movie.posterPath}',
                    fit: BoxFit.cover,
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.4, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Contenu principal
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Genres
                  Text(
                    _genres,
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  // Date de sortie et note
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.black45, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        widget.movie.releaseDate,
                        style: const TextStyle(color: Colors.black45),
                      ),
                      const SizedBox(width: 20),
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 5),
                      Text(
                        '${widget.movie.rating}',
                        style: const TextStyle(color: Colors.black45),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Synopsis
                  const Text(
                    'Synopsis',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Bande-annonce
                  if (_hasTrailer && _youtubeController != null) ...[
                    const Text(
                      'Bande-annonce',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    YoutubePlayer(
                      controller: _youtubeController!,
                      showVideoProgressIndicator: true,
                      onReady: () {
                        _isPlayerReady = true;
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
