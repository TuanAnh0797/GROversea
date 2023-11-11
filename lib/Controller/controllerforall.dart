import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/checkstt.dart';
import '../models/modelforall.dart';
class controllerforall{
  Future<DetialStockCard?> Get_Testtool_StockcardID_Checkstt_market(
      String StockCardID) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_Testtool_StockcardID_Checkstt_market'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'StockCardID': StockCardID,
      }),
    );
    if (response.statusCode == 200) {
      try {
        return DetialStockCard.fromJson(jsonDecode(response.body));
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Failed API: Get_Testtool_StockcardID_Checkstt_market');
    }
}
  Future<HangThieuStt?> Get_Testtool_hangthieu(
      String material,String invoice,String po,String PstgDate,String poitem,) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_Testtool_hangthieu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'material': material,
        'invoice': invoice,
        'po': po,
        'PstgDate': PstgDate,
        'poitem': poitem,
      }),
    );
    if (response.statusCode == 200) {

      try {

        return HangThieuStt.fromJson(jsonDecode(response.body));
      } catch (e) {

        return null;
      }
    } else {
      throw Exception('Fail API: Get_Testtool_hangthieu');
    }
  }

  controllerforall();
}