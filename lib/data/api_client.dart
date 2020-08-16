import 'package:covid_flutter/data/server_error.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://api.covid19india.org/")
abstract class ApiClient{
  factory ApiClient(Dio dio){
    return _ApiClient(dio);
  }

  @GET("/{path}")
  Future<Map<String, dynamic>> getData(@Path("path") String path);

  @GET("/{path}")
  Future<Map<String, dynamic>> getDistrictData(@Path("path") String path);
}