import 'package:flutter/material.dart';

import '../model/movie.dart';

class MovieTile extends StatelessWidget{
  late final double height;
  late final double width;
  late final Movie movie;

  MovieTile(
  {
    required this.movie,
    required this.height,
    required this.width,
}
      );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _moviePosterWidget(movie.posterURL()),
          _movieInfoWidget(),
        ],
      ),

    );
  }
  Widget _moviePosterWidget(String _imageUrl){
    return Container(
      height:height,
      width: width*0.35,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(_imageUrl ),
        )
      ),
    );
  }
  Widget _movieInfoWidget(){
    return Container(
      height: height,
      width: width*0.66,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment:CrossAxisAlignment.center ,
            children: [
              Container(
                width: width*0.56,
                child: Text(
                  movie.name,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                movie.rating.toString(),
                style: TextStyle(
                  color:Colors.black,
                  fontSize: 22,
                ),
              )
            ],
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0,height*0.07,0,0),
            child:Text(
                '${movie.language.toUpperCase()} | R:${movie.isAdult}| ${movie.releaseDate}',
              style: TextStyle(color:Colors.white,fontSize: 12),
            ) ,
          ),
          Container(
            padding: EdgeInsets.fromLTRB(0,height*0.07,0,0),
            child: Text(movie.description,maxLines: 7,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color:Colors.white, fontSize: 10),),

          ),

        ],
      ),
    );
  }
}