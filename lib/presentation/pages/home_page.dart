import 'package:flutter/material.dart';
import '../../data/tmdb_api.dart';
import 'detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('영화 홈', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<Movie>>(
              future: fetchPopularMovies(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final movies = snapshot.data!;
                if (movies.isEmpty) return const SizedBox();
                final movie = movies[0];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '가장 인기있는',
                        style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Hero(
                        tag: 'poster_${movie.id}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            movie.posterUrl,
                            width: MediaQuery.of(context).size.width - 40,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _sectionLabel('현재 상영중'),
            _movieHorizontalList(fetchNowPlayingMovies),
            _sectionLabel('인기순'),
            _movieHorizontalList(fetchPopularMovies, showRank: true),
            _sectionLabel('평점 높은순'),
            _movieHorizontalList(fetchTopRatedMovies),
            _sectionLabel('개봉예정'),
            _movieHorizontalList(fetchUpcomingMovies),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, top: 24, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _movieHorizontalList(
    Future<List<Movie>> Function() fetchFunction, {
    bool showRank = false,
  }) {
    return SizedBox(
      height: 180,
      child: FutureBuilder<List<Movie>>(
        future: fetchFunction(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final movies = snapshot.data!;
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movies.length > 20 ? 20 : movies.length,
            itemBuilder: (context, index) {
              return _movieCard(
                movies[index],
                index: index,
                showRank: showRank,
                context: context,
              );
            },
          );
        },
      ),
    );
  }

  Widget _movieCard(
    Movie movie, {
    required int index,
    bool showRank = false,
    required BuildContext context,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 8, bottom: 8, top: 4),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetailPage(movieId: movie.id),
            ),
          );
        },
        child: Stack(
          children: [
            Hero(
              tag: 'poster_${movie.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.posterUrl,
                  width: 120,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            if (showRank)
              Positioned(
                left: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
