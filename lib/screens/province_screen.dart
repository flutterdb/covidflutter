import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covid_flutter/data/api_client.dart';
import 'package:covid_flutter/data/server_error.dart';
import 'package:covid_flutter/models/statewise_data_resp_model.dart';
import 'package:covid_flutter/utils/hex_color.dart';
import 'package:covid_flutter/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ProvinceScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _ProvinceScreenState();
  }
}

class _ProvinceScreenState extends State<ProvinceScreen> {
  List<Statewise> stateWiseList = [];
  TextEditingController searchEditController = TextEditingController();
  String filter = "";
  final textStyle = TextStyle(color: Colors.blue.shade900 , fontWeight: FontWeight.bold, fontSize: 18.0);

  @override
  void initState(){
    searchEditController.addListener(() {
      if(searchEditController.text.isEmpty) {
        setState(() {
          filter = "";
        });
      } else {
        setState(() {
          filter = searchEditController.text;
        });
      }
    });
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitUp,
    ]);
    super.initState();
  }

  @override
  void dispose() {
    searchEditController.dispose();
    super.dispose();
  }

  Widget getCardWidget(String title, String data){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                  color: HexColor("#007bff").withOpacity(0.4),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.0),),
                          SizedBox(height: 6.0,),
                          //Text(widget.data, style: TextStyle(color: widget.color , fontWeight: FontWeight.bold, fontSize: 22.0),),
                          ColorizeAnimatedTextKit(
                            onTap: () {},
                            repeatForever: true,
                            text: [data],
                            textStyle: TextStyle(fontSize: 18.0, fontFamily: "Horizon", fontWeight: FontWeight.bold),
                            colors: [Colors.blue, Colors.yellow, Colors.red,],
                            textAlign: TextAlign.center, alignment: AlignmentDirectional.topCenter, isRepeatingAnimation: true, )
                        ],
                      ),
                    ),
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/covid-hack.jpg",),
                    fit: BoxFit.fill,
                  ),),
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                                child: Container(
                                    child: ReusableWidgets.getTitleTextWidget(context)
                                ),
                              ),
                              Flexible(
                                  fit: FlexFit.loose,
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                        maxHeight: 100,
                                        maxWidth: 80,
                                        minHeight: 50,
                                        minWidth: 60
                                    ),
                                    child: FlareActor(
                                      'assets/images/corona.flr',
                                      animation: 'move',
                                      fit: BoxFit.fitHeight,
                                    ),
                                  )
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
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                child: Theme(
                  data: ThemeData(
                    primaryColor: HexColor("#164F6E"),
                    primaryColorDark: HexColor("#164F6E"),
                  ),
                  child: TextFormField(
                    style: TextStyle(color: HexColor("#164F6E"),),
                    controller: searchEditController,
                    maxLines: 1,
                    cursorColor: HexColor("#164F6E"),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.all(0.0),
                      labelText: "Search State",
                      labelStyle: TextStyle(color: HexColor("#164F6E"),),
                      hintText: "Search State by name",
                      hintStyle: TextStyle(color: HexColor("#164F6E"), fontSize: 14.0),
                      prefixIcon: Icon(Icons.search, color: HexColor("#164F6E"),),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: HexColor("#f5b044"), width: 2.0),),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: HexColor("#f5b044"), width: 2.0),),
                      disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0)), borderSide: BorderSide(color: HexColor("#f5b044"), width: 2.0),),
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(height: 6.0,),
                      Center(
                        child: FutureBuilder<Map<String, dynamic>>(
                            future: _getCovidStateData(),
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
                              return ListView.builder(
                                physics: ScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemBuilder: (BuildContext context, int index){
                                  return filter == null || filter == "" ? StateCard(stateWise: stateWiseList[index], index: index,) :
                                      stateWiseList[index].state.toLowerCase().contains(filter.toLowerCase()) ? StateCard(stateWise: stateWiseList[index], index: index,) :
                                      new Container();
                                },
                                itemCount: stateWiseList.length,
                              );
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              flex: 8,
            )
          ],
      ),
    );
  }

  void processSnapshotData(data) {
    if(data != null){
      if(StatewiseData.fromJson(data) != null){
        if(StatewiseData.fromJson(data).statewise.isNotEmpty){
          stateWiseList.clear();
          stateWiseList.addAll(StatewiseData.fromJson(data).statewise.toList());
        }
      }
      print(stateWiseList.length);
    }
  }

  Future<Map<String, dynamic>> _getCovidStateData() async {
    print("calling api");
    var res;
    try{
      Dio dio = new Dio();
      dio.options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
      res = await ApiClient(dio).getData('data.json');
    }
    on ServerError catch(err){
      Fluttertoast.showToast(msg: err.getErrorMessage());
    }
    return res;
  }
}

class StateCard extends StatefulWidget{

  final Statewise stateWise;
  final int index;

  const StateCard({Key key, this.stateWise, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _StateCardState();
  }
}

class _StateCardState extends State<StateCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    color: (widget.index % 2 == 0) ? Colors.red.withOpacity(0.5) : Colors.green.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ReusableWidgets.getCardRowWidget('State : ', widget.stateWise.state, widget.index, 'State Code : ', widget.stateWise.statecode, widget.index),
                            SizedBox(
                              height: 8.0,
                            ),
                            ReusableWidgets.getCardRowWidget('Active : ', widget.stateWise.active, widget.index, 'Confirmed : ', widget.stateWise.confirmed, widget.index),
                            SizedBox(
                              height: 8.0,
                            ),
                            ReusableWidgets.getCardRowWidget('Deaths : ', widget.stateWise.deaths, widget.index, 'Recovered : ', widget.stateWise.recovered, widget.index),
                            SizedBox(
                              height: 14.0,
                            ),
                            Text('Last Updated : ' + widget.stateWise.lastupdatedtime, style: TextStyle(color: (widget.index % 2 == 0) ? Colors.white : Colors.blue.shade600 , fontWeight: FontWeight.bold, fontSize: 12.0, fontStyle: FontStyle.italic)),
                          ],
                        ),
                      ),
                    )
                ),
              ),
            ),
          )
      ),
    );
  }
}