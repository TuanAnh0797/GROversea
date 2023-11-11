import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grstd.dart';
import '../models/modelforall.dart';

class controllergrstd {
  Future<List<DataInvoiceStd>> Get_Testtool_invoice_flutter(
      String po, String poItem, String material, String quantity) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_Testtool_invoice_flutter'),
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
      List<dynamic> list1 = jsonDecode(response.body);
      List<DataInvoiceStd> listerror = [];
      try {
        return list1.map((json) => DataInvoiceStd.fromJson(json)).toList();
      } catch (e) {
        return listerror;
      }
    } else {
      throw Exception('Failed API: Get_Testtool_invoice_flutter');
    }
  }

  Future<InforStockCardStd?> Get_InfoStockCard_OCR_new_testtool(
      String po, String poItem, String material, String quantity) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_InfoStockCard_OCR_new_testtool'),
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
      try {
        return InforStockCardStd.fromJson(jsonDecode(response.body));
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Failed API: Get_InfoStockCard_OCR_new_testtool');
    }
  }

  Future<List<DataDetailStd>?> Get_TestTool_Detail_STD(
      String stockcardid) async {

    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_TestTool_Detail_STD'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'StockCardID': stockcardid,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> list1 = jsonDecode(response.body);
      try {
        return list1.map((json) => DataDetailStd.fromJson(json)).toList();
      } catch (e) {
        return null;
      }
    }
    else {
      throw Exception('Failed API: Get_TestTool_Detail_STD');
    }
  }
  Future<List<DataDetailStd>?> tblTestTool_GR_STD(
      String po, String poitem, String qtyact, String barcode, String Status) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/tblTestTool_GR_STD'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'po': po,
        'poitem': poitem,
        'qty': qtyact,
        'barcode': barcode,
        'Status': Status

      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> list1 = jsonDecode(response.body);
      try {
        return list1.map((json) => DataDetailStd.fromJson(json)).toList();
      } catch (e) {
        return null;
      }
    }
    else {
      throw Exception('Failed API: tblTestTool_GR_STD');
    }
  }
  Future<List<DataDetailStd>?> tblTestTool_GR(
      String po, String poitem, String qtyact, String barcode, String Status) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/tblTestTool_GR'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'po': po,
        'poitem': poitem,
        'qty': qtyact,
        'barcode': barcode,
        'Status': Status

      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> list1 = jsonDecode(response.body);
      try {
        return list1.map((json) => DataDetailStd.fromJson(json)).toList();
      } catch (e) {
        return null;
      }
    }
    else {
      throw Exception('Failed API: tblTestTool_GR_STD');
    }
  }
  // Future<DataConfirmQuantity?> grgetdataquantity(
  //     String stockcardid) async {
  //   final response = await http.post(
  //     Uri.parse('http://10.92.184.24:8011/grgetdataquantity'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'StockCardID': stockcardid,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     try {
  //       return DataConfirmQuantity.fromJson(jsonDecode(response.body));
  //     } catch (e) {
  //       return null;
  //     }
  //   }
  //   else {
  //     throw Exception('Failed load.');
  //   }
  // }
  Future<BarcodeID?> Get_Testtool_getbacodeID(
      String material, String invoice, String po, String PstgDate, String poitem) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_InfoStockCard_OCR_new_testtool'),
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
        return BarcodeID.fromJson(jsonDecode(response.body));
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Failed API: Get_Testtool_getbacodeID');
    }
  }
  Future<DataPrintpanacim?> getPanacimLabel_SMT_mayin_hangthieu(
      String BarcodeID,String Plant,String UserID,String mayin) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/getPanacimLabel_SMT_mayin_hangthieu'),
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

  controllergrstd();
}
