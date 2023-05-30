import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_app/controller/main_page_data_controller.dart';
import 'package:movie_app/model/main_page_data.dart';
import 'package:movie_app/model/movie.dart';
import '../model/search_category.dart ';
import '../widgets/movie_tile.dart';
import '../controller/main_page_data_controller.dart';
final mainPageDataControllerProvider=
StateNotifierProvider<MainPageDataController>((ref){
  return MainPageDataController();
});
final selectMoviePosterUrlProvider=StateProvider<String?>((ref){
  final _movies=ref.watch(mainPageDataControllerProvider.state).movies;
  return _movies.isNotEmpty ? _movies[0].posterURL():null;

});
final provider = selectMoviePosterUrlProvider as ProviderBase<Object?, String?>;
class MainPage extends ConsumerWidget{
  @override
  late double _deviceHeight;
  late double _deviceWidth;
  late TextEditingController _searchTextFieldController;
  late MainPageDataController _mainPageDataController;
  late MainPageData _mainPageData;
  var _selectMoviePosterURL;
  Widget build(BuildContext context,ScopedReader watch) {
    // TODO: implement build
    _deviceHeight=MediaQuery.of(context).size.height;
    _deviceWidth=MediaQuery.of(context).size.width;
    _searchTextFieldController =TextEditingController();
    _mainPageDataController=watch( mainPageDataControllerProvider);
    _mainPageData=watch(mainPageDataControllerProvider.state);
    _searchTextFieldController.text=_mainPageData.searchText;
    _selectMoviePosterURL=watch(selectMoviePosterUrlProvider);
    return _buildUI();
  }
 Widget _buildUI(){
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: _deviceHeight,
        width: _deviceWidth,
        child: Stack(
          children: [
            _backgroundWidget(),
            _foregroundWidget(),
          ],
        ),
      ),
    );
 }
 Widget _backgroundWidget(){
    if(_selectMoviePosterURL.state!=null){
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image:DecorationImage(
              image: NetworkImage(
                _selectMoviePosterURL.state,
              ),
              fit: BoxFit.cover,
            )
        ),
        child: BackdropFilter(
          filter:ImageFilter.blur(sigmaX: 15.0,sigmaY: 15.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.005),
            ),
          ),
        ),
      );
    }else{
      return Container(
        height: _deviceHeight,
        width: _deviceWidth,
        color: Colors.black,
      );
    }
 }
 Widget _foregroundWidget(){
    return Container(
      padding: EdgeInsets.fromLTRB(18, _deviceHeight*0.05, 0, 0),
      width: _deviceWidth*0.95,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _topBarWidget(),
          Container(
            height: _deviceHeight*0.83,
            padding: EdgeInsets.symmetric(vertical: _deviceHeight*0.01),
            child: _movieListViewWidget(),
          ),
        ],
      ),
    );
 }
  Widget _topBarWidget(){
    return Container(
      height: _deviceHeight*0.08,

      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20.0)
      ),
      child:Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        _searchFieldWidget(),
          _categorySelectionWidget(),
        ],
      )
    );
  }
  Widget _searchFieldWidget() {
    final _border=InputBorder.none;
    return Container(
      width: _deviceWidth*0.50,
      height: _deviceHeight*0.05,
      child: TextField(
        controller: _searchTextFieldController,
        onSubmitted: (input)=>_mainPageDataController.updateTextSearch(input),
        onChanged: (input) => _mainPageDataController.updateTextSearch(input),
        style: TextStyle(color:Colors.white),
        decoration:InputDecoration(focusedBorder: _border,border: _border,
        prefixIcon: Icon(Icons.search,color: Colors.white70,),
          hintStyle: TextStyle(
            color: Colors.white70
          ),
          filled: false,
          fillColor: Colors.white70,
          hintText: 'search...'
        ),

      ),
    );
  }
  Widget _categorySelectionWidget() {
    return DropdownButton(
      dropdownColor: Colors.black12,
      value:_mainPageData.searchCategory,
      icon: Icon(
        Icons.menu,
        color: Colors.white70,
      ),
      underline: Container(
        height: 1,
        color: Colors.white70,
      ),
      onChanged: (_value)=>_value.toString().isNotEmpty?
      _mainPageDataController.updateSearchCategory(_value!):null,
      items: [
        DropdownMenuItem(
            child: Text(
                SearchCategory.popular,
                style: TextStyle(color: Colors.white70),
            ),
          value:SearchCategory.popular,

        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.upcoming,
            style: TextStyle(color: Colors.white70),
          ),
          value: SearchCategory.upcoming,

        ),
        DropdownMenuItem(
          child: Text(
            SearchCategory.none,
            style: TextStyle(color: Colors.white70),
          ),
          value: SearchCategory.none,

        )
      ],
    );
  }
  Widget _movieListViewWidget(){
    final List<Movie>_movies=_mainPageData.movies;

    if(_movies.isNotEmpty){
     return NotificationListener(
       onNotification: (_onScrollNotification){
         if(_onScrollNotification is ScrollEndNotification){
           final before=_onScrollNotification.metrics.extentBefore;
           final max=_onScrollNotification.metrics.maxScrollExtent;
           if(before==max){
             print('heye');
             _mainPageDataController.getMovies();
             return true;
           }
           return false;
         }
         return false;

       },
         child: ListView.builder(
             itemCount: _movies.length,
             itemBuilder:(BuildContext _context, int _count){
               return Padding(
                 padding: EdgeInsets.symmetric(
                     vertical: _deviceHeight*0.01,
                     horizontal: 0
                 ),
                 child: GestureDetector(
                   onTap: (){
                     _selectMoviePosterURL.state=_movies[_count].posterURL();
                   },
                   child: MovieTile(
                     movie: _movies[_count],
                     height: _deviceHeight*0.20,
                     width: _deviceWidth*0.85,
                   ),
                 ),
               );
             }
         )
     );

    }else{
      return Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
      );
    }

  }

}

