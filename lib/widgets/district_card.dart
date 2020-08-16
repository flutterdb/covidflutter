
import 'dart:ui';

import 'package:covid_flutter/models/district_model.dart';
import 'package:covid_flutter/widgets/widgets.dart';
import 'package:flutter/material.dart';

class DistrictCard extends StatefulWidget{
  final DistrictData mainData;
  final int index;

  const DistrictCard({Key key, this.mainData, this.index}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DistrictCardState();
  }
}

class _DistrictCardState extends State<DistrictCard>{
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
                            ReusableWidgets.getCardRowWidget('State : ', widget.mainData.state, widget.index, 'District : ', widget.mainData.district, widget.index),
                            SizedBox(
                              height: 8.0,
                            ),
                            ReusableWidgets.getCardRowWidget('Active : ', widget.mainData.active.toString(), widget.index, 'Confirmed : ', widget.mainData.confirmed.toString(), widget.index),
                            SizedBox(
                              height: 8.0,
                            ),
                            ReusableWidgets.getCardRowWidget('Deceased : ', widget.mainData.deceased.toString(), widget.index, 'Recovered : ', widget.mainData.recovered.toString(), widget.index),
                            SizedBox(
                              height: 14.0,
                            ),
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