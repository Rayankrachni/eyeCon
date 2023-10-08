import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eyedetector/model/model.dart';
import 'package:flutter/material.dart';

class ContentHtmlProvider extends ChangeNotifier {
  List<Model> items = [];
  int _index = 0; // The private variable for index

  // Getter for index
  int get index => _index;

  // Setter for index
  set index(int newIndex) {
    _index = newIndex;
  }

  static const String apiUrl = 'http://eyes.live.net.mk/api/MobileUser/prescription/0';

  Future<void> fetchData() async {
    final dio = Dio();

    try {
      final response = await dio.get(apiUrl);

      if (response.statusCode == 200) {
        final data = response.data; // The response is already a Map

        items = (data['items'] as List<dynamic>).map((item) => Model.fromJson(item)).toList();
        notifyListeners();

        print("items ${items.length}");
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load data: $e');
    }
  }
}
