import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:movie_app/services/http_service.dart';
import '../model/config.dart';
import '../services/movie_service.dart';
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key, required this.onInitializationComplete})
      : super(key: key);
  final VoidCallback onInitializationComplete;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds:3 )).then(
          (_) => _setup(context).then(
                (_) => widget.onInitializationComplete(),
          ),
    );

  }

  Future<void> _setup(BuildContext _context) async {
    final getIt = GetIt.instance;
    final configFile = await rootBundle.loadString('assets/config/main.json');
    final configData = jsonDecode(configFile);
    getIt.registerSingleton<AppConfig>(
      AppConfig(API_KEY: configData['API_KEY'],
        BASE_API_URL: configData['BASE_API_URL'],
        BASE_IMAGE_API_URL: configData['BASE_IMAGE_API_URL'],
      ),
    );
    getIt.registerSingleton<HTTPService>(
      HTTPService(),
    );
    getIt.registerSingleton<MovieServices>(
      MovieServices(),
    );
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flicked',
      theme: ThemeData(primaryColor: Colors.blue),
      home: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.contain,
                image: AssetImage('assets/images/2614.jpg'),
              )
          ),
        ),
      ),

    );
  }

}

