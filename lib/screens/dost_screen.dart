import 'package:covid_flutter/widgets/widgets.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DostScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _DostScreenState();
  }
}

class _DostScreenState extends State<DostScreen>{
  String anim = 'Idle';
  final FlareControls controls = FlareControls();

  Widget getBtnWidget(String _anim, FlareControls _controls){
    return RaisedButton(
      onPressed: (){
        setState(() {
          anim = _anim;
          _controls.play(anim);
        });
      },
      child: Text('Wow'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ReusableWidgets.getDostBoyFlare(anim, controls),
                getBtnWidget('2 - Hi', controls),
                getBtnWidget('5 - wow', controls),
                getBtnWidget('7 - clap', controls),
              ],
            ),),
          ),
        );
  }
}