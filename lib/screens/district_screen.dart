
import 'dart:ui';

import 'package:covid_flutter/data/api_client.dart';
import 'package:covid_flutter/data/server_error.dart';
import 'package:covid_flutter/models/district_model.dart';
import 'package:covid_flutter/utils/hex_color.dart';
import 'package:covid_flutter/widgets/district_card.dart';
import 'package:covid_flutter/widgets/widgets.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DistrictScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DistrictScreenState();
  }
}

class _DistrictScreenState extends State<DistrictScreen> {

  bool isApiCall = false;
  /*List<States> states = [];*/
  List<String> districts = [];
  Map<String, List<String>> stateMap = Map();
  /*States _selectedState;*/
  String _selectedDistrict;
  int active = 0;
  int confirmed = 0;
  int deceased = 0;
  int recovered = 0;
  List<DistrictModel> dataList = [];
  List<DistrictData> mainDataList = [];
  Map<String, Map<String, dynamic>> _complexMap = Map();
  TextEditingController searchEditController = TextEditingController();
  String filter = "";
  final textStyle = TextStyle(color: Colors.blue.shade900 , fontWeight: FontWeight.bold, fontSize: 18.0);

  @override
  void initState() {
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
    //fetchData();
  }

  @override
  void dispose() {
    searchEditController.dispose();
    super.dispose();
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
                                child: ReusableWidgets.getFlareCoronaWidget()
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
                    labelText: "Search by State or District",
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
                          future: fetchAllDistrictsData(),
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
                              processData(snapshot.data);
                            }
                            return ListView.builder(
                              physics: ScrollPhysics(),
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index){
                                return filter == null || filter == "" ? DistrictCard(mainData: mainDataList[index], index: index,) :
                                mainDataList[index].state.toLowerCase().contains(filter.toLowerCase()) ? DistrictCard(mainData: mainDataList[index], index: index,) :
                                mainDataList[index].district.toLowerCase().contains(filter.toLowerCase()) ? DistrictCard(mainData: mainDataList[index], index: index,) :
                                new Container();
                              },
                              itemCount: mainDataList.length,
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

  Future<Map<String, dynamic>> fetchAllDistrictsData() async {
    mainDataList.clear();
    setState(() {
      isApiCall = false;
    });
    var res;
    try{
      Dio dio = new Dio();
      dio.options = BaseOptions(receiveTimeout: 10000, connectTimeout: 10000);
      res = await ApiClient(dio).getData('state_district_wise.json');
    }
    on ServerError catch(err){
      Fluttertoast.showToast(msg: err.getErrorMessage());
    }
    return res;
  }

  void processData(data) {
    if(data!=null){
      final parsedJson = data;
      parsedJson.forEach((state, stateDetails) => dataList.add(DistrictModel.fromJson(state, stateDetails)));

      if(dataList.isNotEmpty){
        for(DistrictModel model in dataList){
          _complexMap.putIfAbsent(model.stateName, () => model.districtMap);
        }
        for(var entry1 in _complexMap.entries){
          for(var entry2 in entry1.value.entries){
            //print(entry1.key);  // state
            //print(entry2.key); // district
            // adding District Level Data
            mainDataList.add(DistrictData(state: entry1.key,
              district: entry2.key,
              active: entry2.value['active'],
              deceased: entry2.value['deceased'],
              recovered: entry2.value['recovered'],
              confirmed: entry2.value['confirmed'],));
          }
        }
      }

      print(mainDataList.length);
      }
    }
}