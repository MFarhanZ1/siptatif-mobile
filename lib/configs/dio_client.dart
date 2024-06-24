import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';
import 'package:siptatif_mobile/screens/auth/login_screen.dart';
import 'package:siptatif_mobile/services/auth_service.dart';

class DioClient {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: dotenv.env['BASE_URL'] ?? '',
      headers: {
        'Content-Type': 'application/json',
      },
      followRedirects: false,
      validateStatus: (status) {
        return status != null && status != 401;
      },
    ),
  );

  static Dio get instance => _dio;

  static void addInterceptors(BuildContext context) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        String? accessToken =
            await SecureStorage().readSecureData('accessToken');
        if (accessToken != null) {
          options.headers["Authorization"] = "Bearer $accessToken";
        }
        return handler.next(options);
      },
      onError: (DioException e, ErrorInterceptorHandler handler) async {
        String? refreshToken =
            await SecureStorage().readSecureData('refreshToken');
        if (refreshToken == null) {
          return handler.reject(e);
        }

        // Make a request to refresh the access token
        final newAccessToken = await AuthService().refreshToken({
          'refreshToken': refreshToken,
        });

        if (newAccessToken.data['response']) {
          await SecureStorage().writeSecureData(
              'accessToken', newAccessToken.data['access_token']);

          e.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          return handler.resolve(await _dio.fetch(e.requestOptions));
        } else {
          await SecureStorage().deleteAllSecureData();
          if (context.mounted) {
            var snackBar = SnackBar(
              /// need to set following properties for best effect of awesome_snackbar_content
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.transparent,
              content: AwesomeSnackbarContent(
                title: 'Waduh, sesi habis!',
                message: "${newAccessToken.data['message']}",
                /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                contentType: ContentType.failure,
              ),
            );

            // showing snackbar to bottom of screen
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(snackBar);

            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false,
            );
          }
          return;
          // Navigate to login page
        }
      },
    ));
  }
}
