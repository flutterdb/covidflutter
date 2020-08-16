
class DistrictModel{
  String stateName;
  String stateCode;
  Map<String, dynamic> districtMap;

  DistrictModel.fromJson(String state, Map<String, dynamic> parsedJson)
      : stateName = state,
        stateCode = parsedJson['statecode'],
        districtMap = parsedJson['districtData'];
}

class DistrictData{
  final String state;
  final String district;
  final int active;
  final int confirmed;
  final int deceased;
  final int recovered;
  final int notes;

  DistrictData({this.state, this.district, this.active, this.confirmed, this.deceased, this.recovered, this.notes});
}