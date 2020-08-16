
import 'package:covid_flutter/screens/dashboard_screen.dart';
import 'package:covid_flutter/screens/district_screen.dart';
import 'package:covid_flutter/screens/dost_screen.dart';
import 'package:covid_flutter/screens/province_screen.dart';
import 'package:covid_flutter/utils/constants.dart';
import 'package:flutter/material.dart';

class Router{
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case ROUTE_DASHBOARD:
        return MaterialPageRoute(builder: (_) => DashboardScreen());
      case ROUTE_PROVINCE:
        return MaterialPageRoute(builder: (_) => ProvinceScreen());
      case ROUTE_DISTRICT:
        return MaterialPageRoute(builder: (_) => DistrictScreen());
      case ROUTE_DOST:
        return MaterialPageRoute(builder: (_) => DostScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
              body: Center(
                  child: Text('No route defined for ${settings.name}')),
            ));
    }
  }
}