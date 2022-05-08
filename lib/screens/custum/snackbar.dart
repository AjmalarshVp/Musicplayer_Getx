
import 'package:flutter/material.dart';
import 'package:get/get.dart';

snackbarcustom({required String text }){
     Get.snackbar(
   '', '',
   // ignore: prefer_const_constructors
   backgroundColor: Color.fromARGB(255, 4, 64, 58),
    titleText:  const Text('Changed the Update',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    messageText: Text(text,
        style:  const TextStyle(color: Colors.white)),
    forwardAnimationCurve: Curves.bounceInOut,
    duration: const Duration(milliseconds: 2000),
    icon: const Icon(Icons.music_note),
    //overlayBlur: 5,
  );
  }

