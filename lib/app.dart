import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:siptatif_mobile/configs/dio_client.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';
import 'package:siptatif_mobile/screens/mahasiswa/main_mahasiswa_screen.dart';
import 'package:siptatif_mobile/screens/pembimbing/main_pembimbing_screen.dart';
import 'package:siptatif_mobile/screens/penguji/main_penguji_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late int _selectedScaffoldBodyScreenIndex = 0;

  final List<Widget> _scaffoldBodyScreen = [
    const MainMahasiswaScreen(),
    const MainPengujiScreen(),
    const MainPembimbingScreen(),
  ];

  void _setSelectedScaffoldBodyScreenIndex(int index) {
    setState(() {
      _selectedScaffoldBodyScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: _appBar(),
      body: _scaffoldBodyScreen[_selectedScaffoldBodyScreenIndex],
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  @override
  void initState() {
    super.initState();
    DioClient.addInterceptors(context);

  }

  Container _bottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12, width: 1.0))),
      child: BottomNavigationBar(
        elevation: 30,
        currentIndex: _selectedScaffoldBodyScreenIndex,
        onTap: _setSelectedScaffoldBodyScreenIndex,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        items: [
          _botBarItem(
              icon: "assets/svgs/mahasiswa-icon.svg", label: "Mahasiswa"),
          _botBarItem(icon: "assets/svgs/penguji-icon.svg", label: "Penguji"),
          _botBarItem(
              icon: "assets/svgs/pembimbing-icon.svg", label: "Pembimbing"),
        ],
        useLegacyColorScheme: false,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.black26,
        ),
        selectedLabelStyle: const TextStyle(
          color: Colors.black,
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
        unselectedLabelStyle: const TextStyle(
          color: Colors.black38,
          fontFamily: "Montserrat-SemiBold",
          letterSpacing: -0.9,
        ),
      ),
    );
  }

  BottomNavigationBarItem _botBarItem(
      {required String icon, required String label}) {
    return BottomNavigationBarItem(
        icon: SvgPicture.asset(
          icon,
          width: 33,
          color: Colors.black38,
        ),
        activeIcon: Container(
          width: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.purple[50],
          ),
          child: SvgPicture.asset(
            icon,
            width: 33,
            color: Colors.black,
          ),
        ),
        label: label);
  }

  BottomNavigationBarItem _bottomBarItem(
      {required String icon, required String label}) {
    return BottomNavigationBarItem(
      icon: Column(
        children: [
          SvgPicture.asset(
            icon,
            width: 45.0,
            height: 45.0,
          ),
          Text(
            label,
            style: _botNavMenuTextStyle,
          ),
        ],
      ),
      activeIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: Container(
          width: 90,
          height: 75,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.grey[200],
              border: const Border(
                bottom: BorderSide(color: Colors.black, width: 3.0),
              )),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: [
                SvgPicture.asset(
                  icon,
                  width: 45.0,
                  height: 45.0,
                ),
                Text(
                  label,
                  style: _botNavMenuTextStyle,
                ),
              ],
            ),
          ),
        ),
      ),
      label: label,
    );
  }

  final TextStyle _botNavMenuTextStyle = const TextStyle(
    fontSize: 12.0,
    color: Colors.black,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
  );

  /////////////////////////////////////////////////////////////////////////////
  /// Top Navigation Bar Assets
  ////////////////////////////////////////////////////////////////////////////

  AppBar _appBar() {
    return AppBar(
      title: const Text(
        'SIPTATIF',
        style: TextStyle(
          fontFamily: "Montserrat-Bold",
          fontSize: 24.0,
          letterSpacing: -0.9,
        ),
      ),
      actions: [
        _logoutButton(),
      ],
      shape: const Border(
        bottom: BorderSide(color: Colors.black12, width: 1.0),
      ),
    );
  }

  Widget _logoutButton() {
    return IconButton(
      icon: const Icon(
        Icons.logout_outlined,
        size: 30,
      ),
      onPressed: () {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => _logoutDialog(),
        );
      },
    );
  }

  Widget _logoutDialog() {
    return AlertDialog(
      title: const Text('Warning: Log-Out Confirmation!'),
      content: const Text('Apakah anda yakin ingin log-out dari akun anda?'),
      actions: <Widget>[
        _logoutCancelButton(),
        _logoutConfirmButton(),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
            10), // Adjust the border radius value as needed
      ),
    );
  }

  Widget _logoutCancelButton() {
    return TextButton(
      onPressed: () => Navigator.pop(context, 'Cancel'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.red),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              5), // Adjust the border radius value as needed
        )),
      ),
      child: const Text(
        'Batal',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _logoutConfirmButton() {
    final secureStorage = SecureStorage();

    return TextButton(
      onPressed: () async {
        await secureStorage.deleteAllSecureData();
        if (mounted) {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, "/login");
        }
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.green),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              5), // Adjust the border radius value as needed
        )),
      ),
      child: const Text(
        'Iya, Saya Yakin',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
