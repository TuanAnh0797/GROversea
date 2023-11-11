import 'dart:convert';
import '../models/checkstt.dart';
import 'package:http/http.dart' as http;

import '../models/modelforall.dart';
class controllergrcheckstt{
  Future<List<InforStockCardCheckStt>?> Get_InfoStockCard_OCR_checkstt(
      String po, String poItem, String material, String quantity) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_InfoStockCard_OCR_checkstt'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Po': po,
        'PoItem': poItem,
        'Material': material,
        'Quantity': quantity,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> list1 =jsonDecode(response.body);
      try {
        return list1.map((json) => InforStockCardCheckStt.fromJson(json)).toList();
      } catch (e) {

        return null;
      }
    } else {
      throw Exception('Fail API: Get_InfoStockCard_OCR_checkstt');
    }
  }

  Future<DataPrintpanacim?> getPanacimLabel_SMT_TestTool_mayin(
      String BarcodeID,String Plant,String UserID,String mayin) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/getPanacimLabel_SMT_TestTool_mayin'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'BarcodeID': BarcodeID,
        'Plant': Plant,
        'UserID': UserID,
        'mayin': mayin,
      }),
    );
    if (response.statusCode == 200) {
      try {
        return DataPrintpanacim.fromJson(jsonDecode(response.body));
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Failed API: getPanacimLabel_SMT_TestTool_mayin');
    }
  }
  Future<bool> Open_PhieuKho_SMT29(
      String BarcodeID,String UserID) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Open_PhieuKho_SMT29'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'BarcodeID': BarcodeID,
        'UserID': UserID,
      }),
    );
    if (response.statusCode == 200) {
        return jsonDecode(response.body);
    } else {
      throw Exception('Failed API: Open_PhieuKho_SMT29');
    }
  }
  controllergrcheckstt();
}

