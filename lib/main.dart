import 'package:flutter/material.dart';
import 'pages/home.dart';
import 'pages/aboutPage.dart';
import 'pages/albumPage.dart';
import 'pages/doingPage.dart';
import 'pages/imagePage.dart';
import 'pages/organizePage.dart';
import 'pages/photoPage.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Home(),
      // initialRoute: '/',
      // routes: {
      //   '/':(context)=> Home(),
      //   'organize':(context)=>OrganizePage(),
      //   'album':(context)=>AlbumPage(),
      //   'about':(context)=>AboutPage(),
      // },
    );
  }
}
