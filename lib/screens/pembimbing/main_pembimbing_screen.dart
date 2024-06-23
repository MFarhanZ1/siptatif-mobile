import 'package:flutter/material.dart';

class MainPembimbingScreen extends StatefulWidget {
  const MainPembimbingScreen({super.key});

  @override
  State<MainPembimbingScreen> createState() => _MainPembimbingScreenState();
}

class _MainPembimbingScreenState extends State<MainPembimbingScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Pembimbing"),
    );
  }
}