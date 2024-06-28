import 'dart:async';

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:siptatif_mobile/components/loading_dialog_component.dart';
import 'package:siptatif_mobile/services/auth_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final emailController = TextEditingController();
  final _authService = AuthService();

  Timer? _timer;
  int _remainingTime = 0;
  final int _cooldownDuration = 10 * 60; // 10 menit dalam detik

  void _startCooldown() {
    setState(() {
      _remainingTime = _cooldownDuration;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _getTimeString() {
    int minutes = _remainingTime ~/ 60;
    int seconds = _remainingTime % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

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
                "Reset Password",
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
              TextButton(
                onPressed: () {

                  // init snackbar variable
                  late final SnackBar snackBar;

                  if (_remainingTime != 0) {
                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Yah, Sent Link Gagal!',
                        message:
                            "Maaf, link udah dikirim sebelumnya, cek dulu yah di email kmuh!",

                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                        contentType: ContentType.failure,
                      ),
                    );

                    // showing snackbar to bottom of screen
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);                                                            
                    return;
                  }

                  // hide keyboard
                  FocusManager.instance.primaryFocus?.unfocus();

                  if (emailController.text.isEmpty) {
                    snackBar = SnackBar(
                      /// need to set following properties for best effect of awesome_snackbar_content
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Yah, Sent Link Gagal!',
                        message:
                            "Lengkapi dulu data anda sebelum melanjutkan proses reset password!",

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

                  // show loading screen
                  showLoaderDialog(context);

                  // hit epi to sent verif reset password
                  _authService
                      .resetPassword({"email": emailController.text}).then(
                          (value) => {
                                // close loading screen and append snackbar based on result
                                Navigator.pop(context),
                                if (value.data['response'])
                                  {
                                    if (_remainingTime == 0)
                                      {
                                        _startCooldown(),                                      
                                      },
                                    snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Sent Link Sukses!',
                                        message: "${value.data['message']}",

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.success,
                                      ),
                                    ),
                                  }
                                else
                                  {
                                    snackBar = SnackBar(
                                      /// need to set following properties for best effect of awesome_snackbar_content
                                      elevation: 0,
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor: Colors.transparent,
                                      content: AwesomeSnackbarContent(
                                        title: 'Yah, Sent Link Gagal!',
                                        message:
                                            "${value.data['message']}",

                                        /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
                                        contentType: ContentType.failure,
                                      ),
                                    ),
                                  },

                                // showing snackbar to bottom of screen
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(snackBar),
                              });
                },
                style: TextButton.styleFrom(
                    backgroundColor: _remainingTime == 0 ? Colors.black : Color.fromARGB(221, 231, 231, 231),
                    fixedSize: const Size(329, 50),
                    shape: RoundedRectangleBorder( 
                      // side: BorderSide(color: Colors.black, width: 1), // Add this line for black border                     
                      borderRadius: BorderRadius.circular(12),                    
                    )),
                child: Text(
                  _remainingTime == 0
                      ? 'Sent Reset Password Link'
                      : 'Try Again in: ${_getTimeString()}',
                  style: TextStyle(
                    fontFamily: "Montserrat-Bold",
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: _remainingTime == 0 ? Colors.white : Color.fromARGB(255, 111, 111, 111),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back To the Login Page",
                      style: TextStyle(
                          fontFamily: "Montserrat-SemiBold",
                          fontSize: 15,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.7,
                          color: Colors.black)))
            ],
          ),
        ),
      ),
    );
  }
}
