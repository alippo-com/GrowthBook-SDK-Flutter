import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    Dio()
        .get('https://cdn.growthbook.io/api/features/key_dev_48ecac96a7facd6c')
        .then((response) {
      Map<String, dynamic> map = response.data['features'];

      map.forEach((key, value) {
        log("Feature Name $key ${value.toString()}");
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
