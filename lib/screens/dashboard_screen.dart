// Created by Sarj
// 03-AUG-2020

import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covid_flutter/data/api_client.dart';
import 'package:covid_flutter/data/server_error.dart';
import 'package:covid_flutter/models/statewise_data_resp_model.dart';
import 'package:covid_flutter/utils/hex_color.dart';
import 'package:covid_flutter/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';

class DashboardScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DashboardScreenState();
  }
}

class _DashboardScreenState extends State<DashboardScreen>{
  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;
  Position _currentPosition;
  String _currentAddress = "";
  List<Statewise> mainList = [];
  String lastUpdated = "";

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCovidData();
  }

  Widget dashboardTilesWidget(){
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 6.0,),
          ReusableWidgets.getTitleTextWidget(context),
          Center(
            child: FutureBuilder<Map<String, dynamic>>(
                future: _getCovidData(),
                builder:(context, AsyncSnapshot snapshot){
                  if(snapshot.connectionState == ConnectionState.none){
                    return Text('No Internet!');
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return CircularProgressIndicator();
                  }
                  else if(snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }
                  else if(snapshot.data != null){
                    processSnapshotData(snapshot.data);
                  }
                  return ReusableWidgets.getDashboardGridView(context, mainList);
                }
            ),
          ),
          SizedBox(height: 8.0,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        height: 50.0,
        //color: Colors.transparent,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              "assets/images/corona-background.jpg",),
            fit: BoxFit.fill,),),
     ),
      resizeToAvoidBottomInset: false,
      body: Column(
        //mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/recovered.jpeg",),
                  fit: BoxFit.fill,
                ),),
              child: ClipRRect(
                child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 35.0,
                            child: Container(
                              color: Colors.transparent,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: ReusableWidgets.getAddressWidget(_currentAddress),
                                ),
                                Spacer(),
                                Flexible(
                                    fit: FlexFit.loose,
                                    child: ReusableWidgets.getFlareCoronaWidget(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ),
              ),
            ),
            flex: 0,
          ),
          Expanded(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/images/corona-background.jpg",),
                  fit: BoxFit.fill,
                ),),
              child: dashboardTilesWidget(),
            ),
            flex: 8,
          )
        ],
      ),
    );
  }

  _getCurrentLocation() async {
    Fluttertoast.showToast(msg: "Fetching Location...", backgroundColor: Colors.black,
        textColor: Colors.white);
   await geoLocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString(),
      backgroundColor: Colors.black,
      textColor: Colors.white);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress = "${place.administrativeArea} \n${place.locality}\n${place.postalCode}\n${place.country}";
      });
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: e.toString(),
          backgroundColor: Colors.black,
          textColor: Colors.white);
    }
  }

  Future<Map<String, dynamic>> _getCovidData() async {
    var res;
    try{
      Dio dio = new Dio();
      dio.options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
      res = await ApiClient(dio).getData('data.json');
    }
    on ServerError catch (err){
      Fluttertoast.showToast(msg: err.getErrorMessage());
    }
    return res;
  }

  void processSnapshotData(data) {
    if(data != null){
      if(StatewiseData.fromJson(data) != null){
        if(StatewiseData.fromJson(data).statewise.isNotEmpty){
          mainList.clear();
          mainList.addAll(StatewiseData.fromJson(data).statewise.toList());
        }
      }
    }
  }
}

class DashboardCardWidget extends StatefulWidget{

  final String title;
  final String data;
  final HexColor color;

  const DashboardCardWidget({Key key, this.title, this.data, this.color}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DashboardCardWidgetState();
  }
}

class _DashboardCardWidgetState extends State<DashboardCardWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          /*image: DecorationImage(
            image: AssetImage(widget.image,), fit: BoxFit.cover,
          ),*/
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: widget.color.withOpacity(0.2),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(widget.title, style: TextStyle(color: widget.color , fontWeight: FontWeight.bold, fontSize: 18.0),),
                    SizedBox(height: 10.0,),
                    //Text(widget.data, style: TextStyle(color: widget.color , fontWeight: FontWeight.bold, fontSize: 22.0),),
                    ColorizeAnimatedTextKit(
                      onTap: () {},
                      repeatForever: true,
                      text: [widget.data],
                      textStyle: TextStyle(fontSize: 22.0, fontFamily: "Horizon", fontWeight: FontWeight.bold),
                      colors: [widget.color, Colors.blue, Colors.yellow, Colors.red,],
                      textAlign: TextAlign.center, alignment: AlignmentDirectional.topCenter, isRepeatingAnimation: true, )
                  ],
                ),
              )
            ),
          ),
        ),
      )
    );
  }
}
