import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:eyedetector/const/appConsts.dart';
import 'package:eyedetector/model/model.dart';
import 'package:eyedetector/provider/dio.dart';
import 'package:flutter/material.dart';

import '../helpers/sharedPre.dart';

class ContentHtmlProvider extends ChangeNotifier {
  List<Model> items = [];
  ApiProvider _apiProvider =ApiProvider();
  int _index = 0; // The private variable for index

  // Getter for index
  int get index => _index;

  // Setter for index
  set index(int newIndex) {
    _index = newIndex;
  }

  static const String apiUrl = 'http://eyes.live.net.mk/api/MobileUser/prescription/0';

  Future<void> fetchData() async {


    try {
      String? mtoken = await SharedPreferencesHelper.getString(token);
      Response response = await _apiProvider.getData(mtoken!);
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
