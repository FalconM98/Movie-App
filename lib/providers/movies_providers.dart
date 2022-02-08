import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_movie_app/helpers/debouncer.dart';
import 'package:flutter_movie_app/models/models.dart';
import 'package:http/http.dart' as http;

class MoviesProvider extends ChangeNotifier {
  final String _apiKey = '5003077594dbb4f079fe5dd59549966d';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  List<Movie> onDisplayMovie = [];
  List<Movie> popularMovie = [];
  int _popularPage = 0;
  //Se crea un objeto que va a contener los cast de las películas
  Map<int, List<Cast>> movieCast = {};

  final StreamController<List<Movie>> _suggestionController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => this._suggestionController.stream;
  final debouncer = Debouncer(duration: Duration(milliseconds: 500));

  MoviesProvider() {
    print('Movies Providers inicializado');
    this.getOnDisplayMovies();
    this.getOnPopularMovies();
  }

  //Función para cargar los json de las distintas instancias
  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    final url = Uri.https(_baseUrl, endpoint,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    // Await the http get response, then decode the json-formatted response.
    var response = await http.get(url);
    return response.body;
  }

  getOnDisplayMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = NowPlayingResponse.fromJson(jsonData);

    onDisplayMovie = nowPlayingResponse.results;
    notifyListeners();
  }

  getOnPopularMovies() async {
    _popularPage++;
    final jsonData = await _getJsonData('3/movie/popular', _popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);
    popularMovie = [...popularMovie, ...popularResponse.results];
    print(popularMovie[0]);
    notifyListeners();
  }

  //Método para que las películas se busquen con su respectivo id
  Future<List<Cast>> getMovieCast(int movieid) async {
    //Se revisa primero el mapa

    if (movieCast.containsKey(movieid)) {
      return movieCast[movieid]!;
    }

    print('Pidiendo info de actores');

    final jsonData = await _getJsonData('3/movie/$movieid/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);

    movieCast[movieid] = creditsResponse.cast;

    return creditsResponse.cast;
  }

  //Para buscar las películas
  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  //Se crea un metodo debouncer
  void getSuggestionQuery(String search) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      print('Tenemos un valor a buscar : $value');
      final result = await searchMovies(value);
      this._suggestionController.add(result);
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = search;
    });
    //Se cancela el timer
    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
