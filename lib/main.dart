import 'dart:async';

import 'package:covid_flutter/screens/splash_screen.dart';
import 'package:covid_flutter/utils/router.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:covid_flutter/utils/constants.dart' as Constants;

void main() {
  runApp(CovidApp());
}

class CovidApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(title: 'Covid Flutter Splash'),
      onGenerateRoute: Router.generateRoute,
    );
  }
}