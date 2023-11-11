
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
class updateversion{
  Future<void> downloadFile() async {
    // const url = 'http://10.92.184.24:8011/flutter/app-release.apk';
    // final response = await http.get(Uri.parse(url));
    //
    // if (response.statusCode == 200) {
    //   // final appDocDir = await getApplicationDocumentsDirectory();
    //    const filePath = '/storage/emulated/0/Download/newversion2.apk';
    //    //final filePath = '${appDocDir.path}/newversion1.apk';
    //
    //   // Lưu tệp xuống thiết bị
    //   await File(filePath).writeAsBytes(response.bodyBytes);
    //   await Process.run('adb', ['install', '-r', filePath]);
    //
    // } else {
    //   throw Exception('Download Fail');
    // }
    final Uri url = Uri.parse('http://10.92.184.24:8011/flutter/app-release.apk');
    await launchUrl(url);
  }
  Future<String> getnewversion() async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/CheckVersionGrOverSea'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed API: CheckVersionGrOverSea');
    }
  }
}
