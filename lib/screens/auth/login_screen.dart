import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:siptatif_mobile/components/loading_dialog_component.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';
import 'package:siptatif_mobile/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool passwordVisible = true;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.symmetric(vertical: 93),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                "assets/img/siptatif-banner-intro-page.jpg",
                width: 338,
              )),
              Container(
                height: 25,
              ),
              const Text(
                "Login SIPTATIF",
                style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 36,
                    letterSpacing: -2,
                    decoration: TextDecoration.underline),
              ),
              Container(
                height: 25,
              ),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: emailController,
                  style: const TextStyle(height: 1),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                height: 22,
              ),
              SizedBox(
                width: 320,
                child: TextField(
                  controller: passwordController,
                  style: const TextStyle(height: 1),
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(passwordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(
                          () {
                            passwordVisible = !passwordVisible;
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 13,
              ),
              Container(
                alignment: Alignment.topRight,
                width: 318,
                child: InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, "/reset-password");
                  },
                  child: const Text("Lupa Password?",
                      style: TextStyle(
                          fontFamily: "Montserrat-SemiBold",
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.7)),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              const SizedBox(
                height: 24,
              ),
              TextButton(
                onPressed: () {
                  // hide keyboard
                  FocusManager.instance.primaryFocus?.unfocus();

                  // init snackbar variable
                  late final SnackBar snackBar;
                  final SecureStorage _secureStorage = SecureStorage();

                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Yah, Login Gagal!',
                        message:
                            "Lengkapi dulu data anda sebelum melanjutkan proses login!",

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.help,
                      ),
                    );

                    // showing snackbar to bottom of screen
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    return;
                  }

                  // init loading dialog and show loading screen
                  showLoaderDialog(context);

                  // hit epi to validating login
                  _authService.login({
                    "email": emailController.text,
                    "password": passwordController.text
                  }).then((value) {
                    // close loading screen and append snackbar based on result
                    Navigator.pop(context);
                    if (value.data['response'] &&
                        value.data['role'] == "Koordinator TA") {
                      // store acces-token and refresh-token at flutter secure storage
                      _secureStorage.writeSecureData(
                          "accessToken", "${value.data['access_token']}");
                      _secureStorage.writeSecureData(
                          "refreshToken", "${value.data['refresh_token']}");

                      snackBar = SnackBar(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Yeay, Login Sukses!',
                          message: "${value.data['message']}",

                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                          contentType: ContentType.success,
                        ),
                      );
                    } else {
                      snackBar = SnackBar(
                        /// need to set following properties for best effect of awesome_snackbar_content
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Yah, Login Gagal!',
                          message:
                              "Maaf, Email/Password yang anda masukkan salah!",

                          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                          contentType: ContentType.failure,
                        ),
                      );
                    }

                    // showing snackbar to bottom of screen
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    if (value.data['response'] &&
                        value.data['role'] == "Koordinator TA") {
                      Navigator.pushReplacementNamed(context, "/dashboard");
                    }
                  });
                },
                style: TextButton.styleFrom(
                    backgroundColor: Colors.black,
                    fixedSize: const Size(329, 50)),
                child: const Text(
                  'LOGIN',
                  style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
