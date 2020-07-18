import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
Future<List<SubCategory>> FetchSubCategory(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String catId = prefs.getString('categoryCatId');
  String url = 'https://sajilo.net/hatbazaar/index.php/rest/subcategories/get/api_key/hatbazarthamelktm1/?cat_id=$catId';
  String stringData;
    print(url);
    final response = await http.get(Uri.encodeFull(url),headers: {"Content-Type": "application/json"});
    print('responses ${response.body}');
    print('responses ${response.statusCode}');
    if(response.statusCode == 200) {
      stringData = json.decode(response.body).toString();
      return compute(parseData1, response.body);
    }
}
List<SubCategory> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<SubCategory>((json) => SubCategory.fromJson(json)).toList();
}
class SubCategory {
  String name;
  SubCategory({this.name
  });
  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      name: json['name'] as String

    );}
}