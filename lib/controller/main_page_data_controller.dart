import 'package:movie_app/model/search_category.dart';
import 'package:movie_app/services/movie_service.dart';

import '../model/main_page_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../model/movie.dart';

class MainPageDataController extends StateNotifier<MainPageData> {

  MainPageDataController([MainPageData? state])
      :super(state ?? MainPageData.initial()) {
    getMovies();
  }

  final MovieServices _movieServices = GetIt.instance.get<MovieServices>();

  Future<void> getMovies() async {
    try {
      List<Movie> _movies = [];
      if (state.searchCategory.isNotEmpty) {
        if (state.searchCategory == SearchCategory.popular) {
          _movies = await _movieServices.getPopularMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.upcoming) {
          _movies = await _movieServices.getUpComingMovies(page: state.page);
        } else if (state.searchCategory == SearchCategory.none) {
          _movies = [];
        }
      } else {
        _movies=await _movieServices.searchMovies(state.searchText,state.page);

      }

      state = state.copyWith(
          [...state.movies, ..._movies], state.page + 1, state.searchCategory,
          state.searchText);
    } catch (e) {
      print(e);
    }
  }

  void updateSearchCategory(String _category) {
    try {
      state = state.copyWith([], 1, _category, '');
      getMovies();
    } catch (e) {
      print(e);
    }
  }

  void updateTextSearch(String searchText) {
    try {
      state = state.copyWith([], 1, SearchCategory.none, searchText);
      getMovies();
    }catch(e){
      print(e);
    }
  }
}