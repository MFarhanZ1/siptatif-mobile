
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

showLoaderDialog(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.black.withOpacity(0),
    contentPadding: EdgeInsets.zero,
    content: SizedBox(
      width: 50,
      child: LoadingAnimationWidget.inkDrop(
        color: const Color.fromARGB(255, 187, 93, 241),
        size: 60,
      ),
    ),
  );
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}