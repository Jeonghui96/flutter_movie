import 'dart:convert';
import 'package:http/http.dart' as http;

// 영화 리스트용 간단 정보
class Movie {
  final int id;
  final String title;
  final String posterUrl;

  Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'] ?? '',
      posterUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}',
    );
  }
}

// 영화 상세 정보
class DetailMovie {
  final int id;
  final String title;
  final String? releaseDate;
  final String? tagline;
  final int? runtime;
  final List<String> genres;
  final String? overview;
  final double? voteAverage;
  final int? voteCount;
  final double? popularity;
  final int? budget;
  final int? revenue;
  final String posterUrl;
  final List<ProductionCompany> productionCompanies;

  DetailMovie({
    required this.id,
    required this.title,
    required this.releaseDate,
    required this.tagline,
    required this.runtime,
    required this.genres,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.popularity,
    required this.budget,
    required this.revenue,
    required this.posterUrl,
    required this.productionCompanies,
  });

  factory DetailMovie.fromJson(Map<String, dynamic> json) {
    return DetailMovie(
      id: json['id'],
      title: json['title'] ?? '',
      releaseDate: json['release_date'],
      tagline: json['tagline'],
      runtime: json['runtime'],
      genres: (json['genres'] as List<dynamic>? ?? []).map((g) => g['name'] as String).toList(),
      overview: json['overview'],
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
      voteCount: json['vote_count'],
      popularity: (json['popularity'] as num?)?.toDouble(),
      budget: json['budget'],
      revenue: json['revenue'],
      posterUrl: 'https://image.tmdb.org/t/p/w500${json['poster_path'] ?? ''}',
      productionCompanies: (json['production_companies'] as List<dynamic>? ?? [])
          .map((c) => ProductionCompany.fromJson(c))
          .toList(),
    );
  }
}

class ProductionCompany {
  final String? name;
  final String? logoUrl;

  ProductionCompany({this.name, this.logoUrl});

  factory ProductionCompany.fromJson(Map<String, dynamic> json) {
    return ProductionCompany(
      name: json['name'],
      logoUrl: json['logo_path'] != null
          ? 'https://image.tmdb.org/t/p/w200${json['logo_path']}'
          : null,
    );
  }
}

const apiKey = 'ee3e1a6778456bdf75633bb47287281f';

Future<List<Movie>> fetchPopularMovies() async {
  final url =
      'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=ko-KR&page=1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final List results = json.decode(response.body)['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    throw Exception("영화 정보를 불러오지 못했습니다.");
  }
}

Future<List<Movie>> fetchNowPlayingMovies() async {
  final url =
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=ko-KR&page=1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final List results = json.decode(response.body)['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    throw Exception("영화 정보를 불러오지 못했습니다.");
  }
}

Future<List<Movie>> fetchTopRatedMovies() async {
  final url =
      'https://api.themoviedb.org/3/movie/top_rated?api_key=$apiKey&language=ko-KR&page=1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final List results = json.decode(response.body)['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    throw Exception("영화 정보를 불러오지 못했습니다.");
  }
}

Future<List<Movie>> fetchUpcomingMovies() async {
  final url =
      'https://api.themoviedb.org/3/movie/upcoming?api_key=$apiKey&language=ko-KR&page=1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final List results = json.decode(response.body)['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    throw Exception("영화 정보를 불러오지 못했습니다.");
  }
}

Future<DetailMovie> fetchMovieDetail(int movieId) async {
  final url =
      'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey&language=ko-KR';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return DetailMovie.fromJson(data);
  } else {
    throw Exception("영화 상세 정보를 불러오지 못했습니다.");
  }
}
