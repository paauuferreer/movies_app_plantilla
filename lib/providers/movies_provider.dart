import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  final String _baseUrl = 'api.themoviedb.org';
  final String _apiKey = '75b099443d532c163b7920c7b733b9d5';
  final String _idioma = 'es-ES';

  List<Movie> pelisCartellera = [];
  List<Movie> pelisPopulars = [];
  Map<int, List<Cast>> castingActors = {};
  int _popularsPagina = 0;

  MoviesProvider() {
    getPelisCartellera();
    getPelisPopulars();
  }

  void getPelisCartellera() async {
    final url = Uri.https(_baseUrl, '3/movie/now_playing', {
      'api_key': _apiKey,
      'language': _idioma,
      'page': '1',
    });

    final resposta = await http.get(url);
    final nowPlayingResponse = NowPlayingResponse.fromJson(resposta.body);
    pelisCartellera = nowPlayingResponse.results;
    notifyListeners();
  }

  void getPelisPopulars() async {
    _popularsPagina++;
    final url = Uri.https(_baseUrl, '3/movie/popular', {
      'api_key': _apiKey,
      'language': _idioma,
      'page': '$_popularsPagina',
    });

    final resposta = await http.get(url);
    final popularResponse = PopularResponse.fromJson(resposta.body);
    pelisPopulars = [...pelisPopulars, ...popularResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getActors(int idMovie) async {
    if (castingActors.containsKey(idMovie)) {
      return castingActors[idMovie]!;
    }

    final url = Uri.https(_baseUrl, '3/movie/$idMovie/credits', {
      'api_key': _apiKey,
      'language': _idioma,
    });

    final resposta = await http.get(url);
    final creditsResponse = CreditsResponse.fromJson(resposta.body);
    castingActors[idMovie] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> cercarPelis(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _idioma,
      'query': query,
    });

    final resposta = await http.get(url);
    final searchResponse = SearchResponse.fromJson(resposta.body);
    return searchResponse.results;
  }
}
