import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:time/time.dart';

class HttpService {
  final String raspberryURL = "http://192.168.0.18:5000/";
  static DateTime lastRequest;
  static HttpService service;

  HttpService() {
    lastRequest = DateTime.now();
  }

  Future<Color> connect() async {
    try {
      lastRequest = DateTime.now();
      Response res = await get(raspberryURL + 'connect');
      if (res.statusCode == 200) {
        print(res);
        return colorFromHex(res.body);
      } else {
        throw "${res.statusCode}";
      }
    } on Exception catch (e) {
      print('error');
    }
  }

  Future<Color> changeColor({Color color}) async {
    try {
      if (DateTime.now().compareTo(lastRequest.add(200.milliseconds)) >= 0) {
        lastRequest = DateTime.now();
        Color c = color ?? Colors.black;
        Response res = await get(raspberryURL + 'changeColor?color=$c');
        if (res.statusCode == 200) {
          print(res);
          return colorFromHex(res.body);
        } else {
          throw "${res.statusCode}";
        }
      }
    } on Exception catch (e) {
      print('error');
    }
  }

  static Color colorFromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
