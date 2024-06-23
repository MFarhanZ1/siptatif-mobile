import 'package:flutter/material.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';

class MainMahasiswaScreen extends StatefulWidget {
  const MainMahasiswaScreen({super.key});

  @override
  State<MainMahasiswaScreen> createState() => _MainMahasiswaScreenState();
}

class _MainMahasiswaScreenState extends State<MainMahasiswaScreen> {
  final _secureStorage = SecureStorage();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        child: Text("Mahasiswa"),
        onTap: () async {
          var res = await _secureStorage.readSecureData('accessToken');
          print(res);
        
        },
      ),
    );
  }
}
