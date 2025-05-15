import 'package:flutter/material.dart';
import '../../data/tmdb_api.dart';

class DetailPage extends StatefulWidget {
  final int movieId;
  const DetailPage({super.key, required this.movieId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late Future<DetailMovie> _detailFuture;

  @override
  void initState() {
    super.initState();
    _detailFuture = fetchMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<DetailMovie>(
        future: _detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final movie = snapshot.data!;
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero 애니메이션
                Hero(
                  tag: 'poster_${movie.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    child: Image.network(
                      movie.posterUrl,
                      width: MediaQuery.of(context).size.width,
                      height: 320,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // 제목, 개봉일
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    '${movie.title} (${movie.releaseDate?.substring(0, 4) ?? ""})',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // 태그라인
                if (movie.tagline != null && movie.tagline!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Text(
                      movie.tagline!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                // 러닝타임, 카테고리
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 8,
                    children: [
                      if (movie.runtime != null)
                        Text(
                          '${movie.runtime}분',
                          style: const TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                      ...movie.genres.map((g) => Container(
                            margin: const EdgeInsets.only(right: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              g,
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                          )),
                    ],
                  ),
                ),
                // 영화 설명
                if (movie.overview != null && movie.overview!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(
                      movie.overview!,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                // 평점, 투표수, 인기, 예산, 수익 (가로 리스트)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _infoCard('평점', movie.voteAverage?.toStringAsFixed(1) ?? '-', Icons.star),
                        _infoCard('투표수', movie.voteCount?.toString() ?? '-', Icons.how_to_vote),
                        _infoCard('인기', movie.popularity?.toStringAsFixed(1) ?? '-', Icons.trending_up),
                        _infoCard('예산', movie.budget != null ? '\$${_numberFormat(movie.budget!)}' : '-', Icons.attach_money),
                        _infoCard('수익', movie.revenue != null ? '\$${_numberFormat(movie.revenue!)}' : '-', Icons.monetization_on),
                      ],
                    ),
                  ),
                ),
                // 제작사
                if (movie.productionCompanies.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 20, bottom: 8),
                    child: const Text(
                      '제작사',
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                if (movie.productionCompanies.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: movie.productionCompanies.map((company) {
                          return Container(
                            margin: const EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                if (company.logoUrl != null && company.logoUrl!.isNotEmpty)
                                  Image.network(
                                    company.logoUrl!,
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.contain,
                                  ),
                                if (company.name != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8),
                                    child: Text(
                                      company.name!,
                                      style: const TextStyle(color: Colors.black87, fontSize: 14),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoCard(String label, String value, IconData icon) {
    return Container(
      width: 100,
      height: 70,
      margin: const EdgeInsets.only(left: 12),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _numberFormat(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }
}
