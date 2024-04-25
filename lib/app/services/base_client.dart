import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../config/translations/strings_enum.dart';
import '../components/custom_snackbar.dart';
import 'api_exceptions.dart';

enum RequestType {
  get,
  post,
  put,
  delete,
}

class BaseClient {
  static final Dio _dio = Dio(
    BaseOptions(
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      },
    ),
  )
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 90,
    ));

  static const int _timeoutInSeconds = 10;

  static get dio => _dio;

static Future<void> safeApiCall({
  required String url,
  required RequestType requestType,
  Map<String, dynamic>? headers,
  Map<String, dynamic>? queryParameters,
  required Function(Response response) onSuccess,
  Function(ApiException)? onError,
  Function(int value, int progress)? onReceiveProgress,
  Function(int total, int progress)? onSendProgress,
  Function? onLoading,
  dynamic data,
}) async {
    try {
      await onLoading?.call();

      late Response response;
      switch (requestType) {
        case RequestType.get:
          response = await _dio.get(
            url,
            onReceiveProgress: onReceiveProgress,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case RequestType.post:
          response = await _dio.post(
            url,
            data: data,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case RequestType.put:
          response = await _dio.put(
            url,
            data: data,
            onReceiveProgress: onReceiveProgress,
            onSendProgress: onSendProgress,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
        case RequestType.delete:
          response = await _dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
            options: Options(headers: headers),
          );
          break;
      }

      await onSuccess(response);
    } on DioError catch (error) {
      _handleDioError(error: error, url: url, onError: onError);
    } on SocketException {
      _handleSocketException(url: url, onError: onError);
    } on TimeoutException {
      _handleTimeoutException(url: url, onError: onError);
    } catch (error, stackTrace) {
      Logger().e(stackTrace);
      _handleUnexpectedException(url: url, onError: onError, error: error);
    }
  }

  static Future<void> download({
    required String url,
    required String savePath,
    Function(ApiException)? onError,
    Function(int value, int progress)? onReceiveProgress,
    required Function onSuccess,
  }) async {
    try {
      await _dio.download(
        url,
        savePath,
        options: Options(
          receiveTimeout: const Duration(seconds: _timeoutInSeconds),
          sendTimeout: const Duration(seconds: _timeoutInSeconds),
        ),
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      final exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  static void _handleDioError({
    required DioError error,
    Function(ApiException)? onError,
    required String url,
  }) {
    if (error.response?.statusCode == 404) {
      onError?.call(ApiException(
        message: Strings.urlNotFound,
        url: url,
        statusCode: 404,
      )) ?? _handleError(Strings.urlNotFound);
    } else if (error.message != null && error.message!.toLowerCase().contains('socket')) {
      onError?.call(ApiException(
        message: Strings.noInternetConnection,
        url: url,
      )) ?? _handleError(Strings.noInternetConnection);
    } else if (error.response?.statusCode == 500) {
      final exception = ApiException(
        message: Strings.serverError,
        url: url,
        statusCode: 500,
      );
      onError?.call(exception) ?? handleApiError(exception);
    } else {
      final exception = ApiException(
        url: url,
        message: error.message ?? 'Unexpected API Error!',
        response: error.response,
        statusCode: error.response?.statusCode,
      );
      onError?.call(exception) ?? handleApiError(exception);
    }
  }

  static void _handleTimeoutException({
    Function(ApiException)? onError,
    required String url,
  }) {
    onError?.call(ApiException(
      message: Strings.serverNotResponding,
      url: url,
    )) ?? _handleError(Strings.serverNotResponding);
  }

  static void _handleSocketException({
    Function(ApiException)? onError,
    required String url,
  }) {
    onError?.call(ApiException(
      message: Strings.noInternetConnection,
      url: url,
    )) ?? _handleError(Strings.noInternetConnection);
  }

  static void _handleUnexpectedException({
    Function(ApiException)? onError,
    required String url,
    required Object error,
  }) {
    onError?.call(ApiException(
      message: error.toString(),
      url: url,
    )) ?? _handleError(error.toString());
  }

  static void handleApiError(ApiException apiException) {
    final msg = apiException.toString();
    CustomSnackBar.showCustomErrorToast(message: msg);
  }

  static void _handleError(String msg) {
    CustomSnackBar.showCustomErrorToast(message: msg);
  }
}
