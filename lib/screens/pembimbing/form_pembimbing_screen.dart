import 'package:flutter/material.dart';

class FormPembimbingScreen extends StatefulWidget {
  const FormPembimbingScreen({super.key});

  @override
  State<FormPembimbingScreen> createState() => _FormPembimbingScreenState();
}

class _FormPembimbingScreenState extends State<FormPembimbingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: const FlexibleSpaceBar(
          titlePadding: EdgeInsets.only(left: 52.0, bottom: 17.0),
          title: Text(
            'Dosen Pembimbing',
            style: TextStyle(
              fontSize: 18, // Sesuaikan ukuran font sesuai kebutuhan
            ),
          ),
        ),
        shape: const Border(
          bottom: BorderSide(color: Colors.black12, width: 1.0),
        ),
      ),
      body: const Center(child: Text('Inpunt Dosen Pembimbing')),
    );
  }
}
