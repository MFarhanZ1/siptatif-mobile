import 'package:flutter/material.dart';

class MainPengujiScreen extends StatefulWidget {
  const MainPengujiScreen({super.key});

  @override
  State<MainPengujiScreen> createState() => _MainPengujiScreenState();
}

class _MainPengujiScreenState extends State<MainPengujiScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Penguji"),
    );
  }
}