import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:siptatif_mobile/app.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';
import 'package:siptatif_mobile/screens/auth/login_screen.dart';
import 'package:siptatif_mobile/screens/auth/reset_password_screen.dart';
import 'package:siptatif_mobile/screens/mahasiswa/form_mahasiswa_screen.dart';
import 'package:siptatif_mobile/screens/mahasiswa/main_mahasiswa_screen.dart';
import 'package:siptatif_mobile/screens/pembimbing/form_pembimbing_screen.dart';
import 'package:siptatif_mobile/screens/pembimbing/main_pembimbing_screen.dart';
import 'package:siptatif_mobile/screens/penguji/form_penguji_screen.dart';
import 'package:siptatif_mobile/screens/penguji/main_penguji_screen.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/login": (context) => const LoginScreen(),
        "/reset-password": (context) => const ResetPasswordScreen(),
        "/dashboard": (context) => const MainScreen(),
        "/mahasiswa": (context) => const MainMahasiswaScreen(),
        "/form-mahasiswa": (context) => const FormMahasiswaScreen(),
        "/penguji": (context) => const MainPengujiScreen(),
        "/form-penguji": (context) => const FormPengujiScreen(),
        "/pembimbing": (context) => const MainPembimbingScreen(),
        "/form-pembimbing": (context) => const FormPembimbingScreen(),
      },
      title: "SIPTATIF Mobile",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.montserratTextTheme(),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _secureStorage = SecureStorage();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _checkLoginStatus() async {
    String? accessToken = await _secureStorage.readSecureData('accessToken');
    String? refreshToken = await _secureStorage.readSecureData('refreshToken');

    if (accessToken != null && refreshToken != null) {
      if (mounted) {
        // Token ada, arahkan ke dashboard
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } else {
      if (mounted) {
        // Token tidak ada, arahkan ke login
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 5)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Delay selesai, arahkan ke halaman berikutnya
          _checkLoginStatus();
          return Container(
            color: Color.fromARGB(255, 181, 181, 181),
          );
        } else {
          // Tampilkan logo sampai delay selesai
          return Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                Image.asset(
                  "assets/img/siptatif-banner-intro-page.jpg",
                  width: 338,
                ),
                const SizedBox(height: 30,),
                const CircularProgressIndicator(
                  color: Colors.black,
                )
                            ],
                          ),
              ));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
