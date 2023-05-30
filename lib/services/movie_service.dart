import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:movie_app/services/http_service.dart';
import 'package:dio/dio.dart';
import '../model/movie.dart';
class MovieServices{
  final GetIt getIt=GetIt.instance;
  late HTTPService _http;
  MovieServices(){
    _http=getIt.get<HTTPService>();
  }
  Future<List<Movie>>getPopularMovies({required int page}) async{
    Response _response=await _http.get('/movie/upcoming', query:{
      'page': page,
    });

    if(_response.statusCode==200){

      print('user info:${_response.data}');

      List<dynamic> _data = _response.data['results'];
      List<Movie> _movies = _data.map((movieData) => Movie.fromJson(movieData)).toList();
      return _movies;

    }
    else{
      throw Exception('could not load latest movies');
    }
  }

Future<List<Movie>>getUpComingMovies({required int page}) async{
  Response _response=await _http.get('/movie/upcoming', query:{
    'page': page,
  });

  if(_response.statusCode==200){

    print('user info:${_response.data}');

    List<dynamic> _data = _response.data['results'];
    List<Movie> _movies = _data.map((movieData) => Movie.fromJson(movieData)).toList();
    return _movies;

  }
  else{
    throw Exception('could not load upcoming  movies');
  }
}
  Future<List<Movie>>searchMovies(String searchTerm,int page) async{
    Response _response=await _http.get('/search/movie', query:{
      'query':searchTerm,
      'page': page,
    });

    if(_response.statusCode==200){

      print('search info:${_response.data}');

      List<dynamic> _data = _response.data['results'];
      List<Movie> _movies = _data.map((movieData) => Movie.fromJson(movieData)).toList();
      return _movies;

    }
    else{
      throw Exception('could not search queries');
    }
  }

}
