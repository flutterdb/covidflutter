// ALl Reusable Widgets defined here
// Corona Harega, India Jitega!

import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:covid_flutter/models/statewise_data_resp_model.dart';
import 'package:covid_flutter/screens/dashboard_screen.dart';
import 'package:covid_flutter/utils/hex_color.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_flutter/utils/constants.dart' as Constants;

class ReusableWidgets{

  static Widget getTitleTextWidget(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(4.0),
      child: Card(
        color: Colors.white.withOpacity(0.0),
        elevation: 12,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ColorizeAnimatedTextKit(
              repeatForever: true,
              onTap: () {},
              text: ["https://covid19india.org".toLowerCase(), "Stay Home, Stay Safe!".toUpperCase(), "Corona Harega, India Jitega!".toUpperCase()],
              textStyle: TextStyle(fontSize: 20.0, fontFamily: "Horizon", fontWeight: FontWeight.bold),
              colors: [Colors.deepOrangeAccent, Colors.blue, Colors.yellow, Colors.red,],
              textAlign: TextAlign.center, alignment: AlignmentDirectional.topCenter, isRepeatingAnimation: true, speed: Duration(seconds: 1),),),
        ),
      ),
    );
  }

  static Widget getAddressWidget(String currentAddress){
    return currentAddress.isNotEmpty?
    Text('Your Location :\n\n$currentAddress',
      style: TextStyle(color: HexColor("#020764"), fontSize: 18.0, fontWeight: FontWeight.bold),
    ) :
    CircularProgressIndicator();
  }

  static Widget getFlareCoronaWidget(){
    return ConstrainedBox(
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
    );
  }

  static Widget getCardRowWidget(String label1, String data1, int index1, String label2, String data2, int index2, ){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Text(label1 + data1, style: TextStyle(color: (index1 % 2 == 0) ? Colors.white : Colors.blue.shade600 , fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.center,),
          flex: 1,
        ),
        Expanded(
          child: Text(label2 + data2, style: TextStyle(color: (index2 % 2 == 0) ? Colors.white : Colors.blue.shade600 , fontWeight: FontWeight.bold, fontSize: 14.0), textAlign: TextAlign.center,),
          flex: 1,
        ),
      ],
    );
  }

  static Widget getDashboardSingleCardTile(BuildContext context, String label, String route){
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        onTap: (){
          Navigator.pushNamed(context, route);
        },
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
                      color: Colors.amber.withOpacity(0.2),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(label, style: TextStyle(color: Colors.blueGrey , fontWeight: FontWeight.bold, fontSize: 18.0), textAlign: TextAlign.center,),
                          ],
                        ),
                      )
                  ),
                ),
              ),
            )
        ),
      ),
    );
  }

  static Widget getDashboardGridView(BuildContext context, List<Statewise> mainList,){
    return mainList.isNotEmpty?
    GridView.builder(
      physics: ScrollPhysics(),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 1.5),
      itemBuilder: (BuildContext context, int index){
        if(index == 0){
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: DashboardCardWidget(data: mainList[0].active, title: "Active", color: HexColor("#007bff"),),
          );
        }
        else if(index == 1){
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: DashboardCardWidget(data: mainList[0].confirmed, title: "Confirmed", color: HexColor("#ff073a"),
            ),
          );
        }
        else if(index == 2){
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: DashboardCardWidget(data: mainList[0].deaths, title: "Deceased", color: HexColor("#6c757d"),
            ),
          );
        }
        else if(index == 3){
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: DashboardCardWidget(data: mainList[0].recovered, title: "Recovered", color: HexColor("#28a745"),
            ),
          );
        }
        else if(index == 4){
          return Padding(
            padding: EdgeInsets.all(4.0),
            child: DashboardCardWidget(data: mainList[0].lastupdatedtime, title: "Last Updated", color: HexColor("#88b999"),
            ),
          );
        }
        else if(index == 5){
          return ReusableWidgets.getDashboardSingleCardTile(context, "State Wise\nData", Constants.ROUTE_PROVINCE);
        }
        else if(index == 6){
          return ReusableWidgets.getDashboardSingleCardTile(context, "All Districts\nData", Constants.ROUTE_DISTRICT);
        }
        return ReusableWidgets.getDashboardSingleCardTile(context, "Meet DOST Boy", Constants.ROUTE_DOST);
        //color: HexColor("#99a354"),
      },
      itemCount: 8,
    ) :
    Center(child: Text("No Data Found!", style: TextStyle(color: Colors.white, fontSize: 18.0, fontWeight: FontWeight.bold),),);
  }

  static Widget getDostBoyFlare(String anim, FlareControls controls){
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: 500,
          maxWidth: 300,
          minHeight: 50,
          minWidth: 60
      ),
      child: FlareActor(
        'assets/images/dost-boy.flr',
        controller: controls,
        animation: anim,
        fit: BoxFit.fitHeight,
      ),
    );
  }
}