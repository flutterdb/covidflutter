// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://api.covid19india.org/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  getData(path) async {
    ArgumentError.checkNotNull(path, 'path');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = path;
    try{
      final Response<Map<String, dynamic>> _result = await _dio.request('$path',
          queryParameters: queryParameters,
          options: RequestOptions(method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      final value = _result.data;
      return Future.value(value);
    }
    on DioError catch(dioError){
      throw ServerError.withError(error: dioError);
    }
  }

  @override
  getDistrictData(path) async {
    ArgumentError.checkNotNull(path, 'path');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _data = path;
    try{
      final Response<Map<String, dynamic>> _result = await _dio.request('$path',
          queryParameters: queryParameters,
          options: RequestOptions(method: 'GET',
              headers: <String, dynamic>{},
              extra: _extra,
              baseUrl: baseUrl),
          data: _data);
      final value = _result.data;
      return Future.value(value);
    } on DioError catch(dioError){
      throw ServerError.withError(error: dioError);
    }
  }
}
