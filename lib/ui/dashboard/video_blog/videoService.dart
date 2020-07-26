import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutterbuyandsell/api/ps_url.dart';
import 'package:flutterbuyandsell/config/ps_config.dart';
Future<List<VideoServices>> FetchVideoServices(http.Client client) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
//  String url = 'https://sajilo.net/hatbazaar/index.php/rest/videos/get/api_key/hatbazarthamelktm1';
  String url = "${PsConfig.ps_app_url}${PsUrl.ps_videolist_url}/api_key/hatbazarthamelktm1";
  String stringData;
    print(url);
  bool loadStatus = prefs.getBool('getLoadVideo');
  if(loadStatus == true) {
    prefs.setBool('getLoadVideo',false);
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      final response = await http.get(Uri.encodeFull(url),headers: {"Content-Type": "application/json"});
      if(response.statusCode == 200) {
        stringData = json.decode(response.body).toString();
        prefs.setString('homeVideo', response.body.toString());
        return compute(parseData1, response.body);
      }else {
        stringData = prefs.getString('homeVideo');
        if(stringData == null || stringData == '') {
          prefs.setBool('getLoadVideo',true);
        }
        return compute(parseData1, stringData);
      }
    }
    else {
      stringData = prefs.getString('homeVideo');
      return compute(parseData1, stringData);
    }
  }else {
    stringData = prefs.getString('homeVideo');
    if(stringData == null || stringData == '') {
      prefs.setBool('getLoadVideo',true);
    }
    return compute(parseData1, stringData);
  }
}
List<VideoServices> parseData1(String responseBody) {
  final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
  return parsed.map<VideoServices>((json) => VideoServices.fromJson(json)).toList();
}
class VideoServices {
  String title;
  String videoUrl;
  String description;
  String addedDate;
  String addedDateStr;
  String imgPath;

  VideoServices({this.title,this.videoUrl,this.description,this.addedDate,this.addedDateStr,this.imgPath
  });
  factory VideoServices.fromJson(Map<String, dynamic> json) {
    return VideoServices(
      title: json['title'] as String,
        videoUrl: json['vid_url'] as String,
        description: json['description'] as String,
      addedDate: json['added_date'] as String,
      addedDateStr: json['added_date_str'] as String,
      imgPath: json['img_path'] as String
    );}
}