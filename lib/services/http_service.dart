import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/model/config.dart';
class HTTPService{
  final Dio dio=Dio();
  final GetIt getIT=GetIt.instance;
  late String _base_url;
  late String _api_key;
  HTTPService(){
    AppConfig _config=getIT.get<AppConfig>();
    _base_url=_config.BASE_API_URL;
    _api_key=_config.API_KEY;
  }
Future<Response>get(String _path,{required Map<String,dynamic> query})async{
    try{
      String _url='$_base_url$_path';
      Map<String,dynamic> _query={
        'api_key':_api_key,
        'language':'en-us'
      };
      if(query!=null){
        _query.addAll(query);
      }
      print(_query);
      return await dio.get(_url,queryParameters: _query);
    }on DioError catch (e){
      print("unable to perform get request");
      print("DioError:$e");
      rethrow;
    }
}

}