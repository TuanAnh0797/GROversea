import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grtool.dart';
import '../models/modelforall.dart';

class controllergrtool {
  // Future<DetialStockCardTool?> Get_Testtool_StockcardID_Checkstt_market(
  //     String StockCardID) async {
  //   final response = await http.post(
  //     Uri.parse('http://10.92.184.24:8011/Get_Testtool_StockcardID_Checkstt_market'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'StockCardID': StockCardID,
  //     }),
  //   );
  //   if (response.statusCode == 200) {
  //     try {
  //       return DetialStockCardTool.fromJson(jsonDecode(response.body));
  //     } catch (e) {
  //       return null;
  //     }
  //   } else {
  //     throw Exception('Failed API: Get_Testtool_StockcardID_Checkstt_market');
  //   }
  // }
  Future<double> TestTool_Check_DetailBox(
      String Barcode) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/TestTool_Check_DetailBox'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'Barcode': Barcode,
      }),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed API: TestTool_Check_DetailBox');
    }
  }

  Future<List<DataInvoicetool>> Get_Testtool_invoice2(
      String po, String poItem, String material, String quantity) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_Testtool_invoice2'),
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
      List<DataInvoicetool> listerror = [];
      try {
        return list1.map((json) => DataInvoicetool.fromJson(json)).toList();
      } catch (e) {
        return listerror;
      }
    } else {
      throw Exception('Failed API: Get_Testtool_invoice2');
    }
  }
  Future<List<DataInvoicetool>> Get_Testtool_invoice_flutter(
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
      List<DataInvoicetool> listerror = [];
      try {
        return list1.map((json) => DataInvoicetool.fromJson(json)).toList();
      } catch (e) {
        return listerror;
      }
    } else {
      throw Exception('Failed API: Get_Testtool_invoice_flutter');
    }
  }
// Không cần thêm API
  Future<InforStockCardtool?> Get_InfoStockCard_OCR_new_testtool(
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
        return InforStockCardtool.fromJson(jsonDecode(response.body));
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Failed API: Get_InfoStockCard_OCR_new_testtool');
    }
  }
// Không cần thêm API
  Future<List<DataDetailtool>?> Get_TestTool_Detail(
      String stockcardid) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_TestTool_Detail'),
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
        return list1.map((json) => DataDetailtool.fromJson(json)).toList();
      } catch (e) {
        return null;
      }
    }
    else {
      throw Exception('Failed API: Get_TestTool_Detail');
    }
  }
  // Không cần thêm API
  Future<List<DataDetailtool>?> tblTestTool_GR_STD(
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
        return list1.map((json) => DataDetailtool.fromJson(json)).toList();
      } catch (e) {
        return null;
      }
    }
    else {
      throw Exception('Failed API: tblTestTool_GR_STD');
    }
  }
  // Không cần thêm API
  Future<List<DataDetailtool>?> tblTestTool_GR(
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
        return list1.map((json) => DataDetailtool.fromJson(json)).toList();
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
  // không cần thêm API
  Future<BarcodeIDtool?> Get_Testtool_getbacodeID(
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
        return BarcodeIDtool.fromJson(jsonDecode(response.body));
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

  controllergrtool();
}
