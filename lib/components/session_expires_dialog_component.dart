import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:siptatif_mobile/configs/secure_storage.dart';

Widget expireDialog(BuildContext context) {
  return AlertDialog(
    title: const Text('Warning: Sesi anda sudah habis!'),
    content: const Text('Anda harus login kembali untuk melanjutkan aksi!'),
    actions: <Widget>[
      expireConfirmButton(context),
    ],
    shape: RoundedRectangleBorder(
      borderRadius:
          BorderRadius.circular(10), // Adjust the border radius value as needed
    ),
  );
}

Widget expireCancelButton(BuildContext context) {
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
      'Gak ah',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

Widget expireConfirmButton(BuildContext context) {
  final secureStorage = SecureStorage();

  return TextButton(
    onPressed: () async {
      await secureStorage.deleteAllSecureData();
      if (context.mounted) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, "/login");

        var snackBar = SnackBar(
          /// need to set following properties for best effect of awesome_snackbar_content
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Login lagi ya mas!',
            message: "Silahkan login kembali untuk melanjutkan aksi ya bro!",
            /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
            contentType: ContentType.failure,
          ),
        );

        // showing snackbar to bottom of screen
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(snackBar);
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
      'Baiklah, Saya akan login lagi!',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}
