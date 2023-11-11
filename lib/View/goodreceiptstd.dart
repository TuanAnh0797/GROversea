import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:horizontal_data_table/horizontal_data_table.dart';

// import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:http/http.dart' as http;
import 'package:keyencesatosbpl/Controller/controllergrstd.dart';
import 'package:keyencesatosbpl/Controller/controllergrtool.dart';
import 'package:keyencesatosbpl/View/goodreceipttool.dart';
import 'package:keyencesatosbpl/models/grtool.dart';
import 'package:get/get.dart';
import 'package:keyencesatosbpl/View/settingbluetoothform.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Controller/controllerforall.dart';
import '../models/checkstt.dart';
import '../models/grstd.dart';
import '../models/modelforall.dart';

class goodreceiptstd extends StatefulWidget {
  const goodreceiptstd({super.key});

  @override
  State<goodreceiptstd> createState() => _goodreceipttool();
}

class _goodreceipttool extends State<goodreceiptstd> {
  late StreamSubscription<ScanResult> onScanResultListenerstd;
  late FlutterDataWedge fdw;
  BluetoothConnection? connection;

  bool get isConnected => (connection?.isConnected ?? false);
  String quantityinvoice = '0';
  String quantityinvoicereceive = '0';
  String quantityactual = '0';
  String quantitytotal = '0';
  late controllergrstd mycontrollergrstd;
  late controllerforall mycontrollerforall;
  List<DataDetailStd> dtscandetail = [];
  List<String> listinputbarcode = [];
  DataBarcodeStd? databarcodeinput;
  List<DataDetailStd> dataoftable = [];
  bool isChecked = false;
  bool isBarcodeEnabled = true;
  bool isprintpanacim = false;
  DetialStockCard? dtprint;
  bool btn_isenablegr = true;
  bool btn_isenablepanacim = false;
  String Mac = '';
  late String FullName;
  late String UserID;
  late String mayin;

  //Textfield Barcode
  var _databarcode = TextEditingController();
  final FocusNode _focusNodeBarcode = FocusNode();
  var _dataquantity = TextEditingController();
  final FocusNode _focusNodeQuantity = FocusNode();

  //EndTextField Barcode
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    Mac = prefs.getString('mac') ?? '';
    FullName = prefs.getString('FullName') ?? '';
    UserID = prefs.getString('UserID') ?? '';
    mayin = prefs.getString('nameprinter') ?? '1';
  }
  Future<void>? initScannerResult;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScannerResult = initScanner();
    mycontrollergrstd = controllergrstd();
    mycontrollerforall = controllerforall();
    loadSettings();
    _focusNodeBarcode.requestFocus();
    _focusNodeBarcode.addListener(() {
      if (_focusNodeBarcode.hasFocus) {
        setState(() {
          _databarcode.selection = TextSelection(
              baseOffset: 0, extentOffset: _databarcode.value.text.length);
        });
        // Future.delayed(const Duration(seconds: 0), () {
        //   SystemChannels.textInput.invokeMethod('TextInput.hide');
        // }
        // );
      }
    });
    _focusNodeQuantity.addListener(() {
      if (_focusNodeQuantity.hasFocus) {
        setState(() {
          _dataquantity.selection = TextSelection(
              baseOffset: 0, extentOffset: _dataquantity.value.text.length);
        });
      }
    });

  }

  Future<void> initScanner() async {
    if (Platform.isAndroid) {
      fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');

      onScanResultListenerstd =
          fdw.onScanResult.listen((result) => setState(() {
                if (_focusNodeBarcode.hasFocus) {
                  String data = result.data;
                  methodscanbarcode(data);
                }
              }));
      await fdw.initialize();
    }
  }

  void methodscanbarcode(String data) async {
    try {
      _databarcode.text = data;
      showdialogload();
      isprintpanacim = false;
      listinputbarcode.clear();
      listinputbarcode = data.toUpperCase().split(';');
      if (data.substring(0, 2) != '45' ||
          listinputbarcode.length < 5) {
        await showdialogng('Sai định dạng barcode');
        _focusNodeBarcode.requestFocus();
      } else {
        databarcodeinput = DataBarcodeStd(
            listinputbarcode[0],
            listinputbarcode[1],
            listinputbarcode[2],
            double.parse(listinputbarcode[3]),
            listinputbarcode[4]);
        List<DataInvoiceStd> dtinvoice = [];
        dtinvoice = await mycontrollergrstd
            .Get_Testtool_invoice_flutter(
            databarcodeinput!.po,
            databarcodeinput!.poitem,
            databarcodeinput!.material,
            databarcodeinput!.quantity.toString());
        if (dtinvoice.isNotEmpty) {
          if (dataoftable.isNotEmpty) {
            if (double.parse(quantityinvoice) ==
                dtinvoice[0]
                    .sumquantityinvoice
                    ) {
              InforStockCardStd? dt;
              dt = await mycontrollergrstd
                  .Get_InfoStockCard_OCR_new_testtool(
                  databarcodeinput!.po,
                  databarcodeinput!.poitem,
                  databarcodeinput!.material,
                  databarcodeinput!.quantity
                      .toString());
              if (dt == null) {
                await showdialogng(
                    'Barcode đã được scan');
                listinputbarcode.clear();
                _databarcode.text = '';
                _dataquantity.text = '';
                _focusNodeBarcode.requestFocus();
              } else {
                dataoftable = (await mycontrollergrstd
                    .Get_TestTool_Detail_STD(
                    dt.StockCardID))!;
                if (dt.ActualTotalQty.toString() ==
                    '') {
                  quantityactual = '0';
                } else {
                  quantityactual = dt.ActualTotalQty;
                  quantitytotal = dt.Quantity;
                  _dataquantity.text = databarcodeinput!.quantity.toStringAsFixed(databarcodeinput!.quantity.truncateToDouble() == databarcodeinput!.quantity ? 0 : 1);
                  _focusNodeQuantity.requestFocus();
                }
              }
            } else {
              if (await showdialognotify(
                  'Bạn đang Scan mã khác \n Bạn có muốn tiếp tục không?') ==
                  1) {
                quantityinvoice = dtinvoice[0].sumquantityinvoice.toStringAsFixed(dtinvoice[0].sumquantityinvoice.truncateToDouble() == dtinvoice[0].sumquantityinvoice ? 0 : 1);
                quantityinvoicereceive = '0';
                InforStockCardStd? dt;
                dt = await mycontrollergrstd
                    .Get_InfoStockCard_OCR_new_testtool(
                    databarcodeinput!.po,
                    databarcodeinput!.poitem,
                    databarcodeinput!.material,
                    databarcodeinput!.quantity
                        .toString());
                if (dt == null) {
                  listinputbarcode.clear();
                  await showdialogng(
                      'Barcode đã được scan');
                  _databarcode.text = '';
                  _dataquantity.text = '';
                  _focusNodeBarcode.requestFocus();
                } else {
                  dataoftable = (await mycontrollergrstd
                      .Get_TestTool_Detail_STD(
                      dt.StockCardID))!;
                  if (dt.ActualTotalQty.toString() ==
                      '') {
                    quantityactual = '0';
                  } else {
                    quantityactual = dt.ActualTotalQty;
                    quantitytotal = dt.Quantity;
                    _dataquantity.text = databarcodeinput!.quantity.toStringAsFixed(databarcodeinput!.quantity.truncateToDouble() == databarcodeinput!.quantity ? 0 : 1);
                    _focusNodeQuantity.requestFocus();
                  }
                }
              } else {
                _databarcode.text = '';
                //_dataquantity.text = '';
                _focusNodeBarcode.requestFocus();
              }
            }
          } else {
            quantityinvoice = dtinvoice[0].sumquantityinvoice.toStringAsFixed(dtinvoice[0].sumquantityinvoice.truncateToDouble() == dtinvoice[0].sumquantityinvoice ? 0 : 1);
            quantityinvoicereceive = dtinvoice[0].sumquantiyactual.toStringAsFixed(dtinvoice[0].sumquantiyactual.truncateToDouble() == dtinvoice[0].sumquantiyactual ? 0 : 1);
            InforStockCardStd? dt;
            dt = await mycontrollergrstd
                .Get_InfoStockCard_OCR_new_testtool(
                databarcodeinput!.po,
                databarcodeinput!.poitem,
                databarcodeinput!.material,
                databarcodeinput!.quantity
                    .toString());
            if (dt == null) {
              listinputbarcode.clear();
              await showdialogng(
                  'Barcode đã được scan');
              _databarcode.text = '';
              _dataquantity.text = '';
              _focusNodeBarcode.requestFocus();
            } else {
              dataoftable = (await mycontrollergrstd
                  .Get_TestTool_Detail_STD(
                  dt.StockCardID))!;
              if (dt.ActualTotalQty.toString() == '') {
                quantityactual = '0';
              } else {
                quantityactual = dt.ActualTotalQty;
                quantitytotal = dt.Quantity;
                _dataquantity.text = databarcodeinput!.quantity.toStringAsFixed(databarcodeinput!.quantity.truncateToDouble() == databarcodeinput!.quantity ? 0 : 1);
                _focusNodeQuantity.requestFocus();
              }
            }
          }
        } else {
          listinputbarcode.clear();
          await showdialogng('Không có Invoice');
          quantityinvoice = '0';
          _focusNodeBarcode.requestFocus();
        }
      }
      closedialog();
      setState(() {});
    } catch (e) {
      closedialog();
      await showdialogng('Lỗi: $e');
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    onScanResultListenerstd.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final Size sizescreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('GR SMT Standard', style: TextStyle(fontSize: 25)),
            TextButton(
              child: Icon(MdiIcons.menu,size: 30,color: Colors.white),
              onPressed: (){
                Get.offNamed('/menuform');
              },
            )
          ],
        )
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 10),
            width: sizescreen.width * 0.95,
            //height: sizescreen.height * 0.85,
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text(
                        'Barcode:',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      //width: sizescreen.width * 0.7,
                      child: SizedBox(
                        height: 40,
                        child: TextField(

                          readOnly: true,
                          showCursor: true,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(
                                top: 10, bottom: 10, left: 5, right: 5),
                          ),

                          style: const TextStyle(fontSize: 20),
                          focusNode: _focusNodeBarcode,
                          controller: _databarcode,
                          enabled: isBarcodeEnabled,
                          onSubmitted: (data) {
                            //methodscanbarcode(data);
                          },

                          onTap: () {
                            setState(() {
                              _databarcode.selection = TextSelection(
                                  baseOffset: 0,
                                  extentOffset: _databarcode.value.text.length);
                              // Future.delayed(const Duration(seconds: 0), () {
                              //   SystemChannels.textInput
                              //       .invokeMethod('TextInput.hide');
                              // });
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Expanded(
                      flex: 3,
                      child: Text('QtyActual:',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                    //SizedBox(width: 2,),
                    Expanded(
                      flex: 6,
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(
                                top: 0, bottom: 0, left: 5, right: 5),
                          ),
                          style: const TextStyle(
                            fontSize: 20,
                          ),
                          keyboardType: TextInputType.number,
                          focusNode: _focusNodeQuantity,
                          controller: _dataquantity,
                          onSubmitted: (data) async {
                            try {
                              isprintpanacim = false;
                              showdialogload();
                              double quantitytemp;
                              quantitytemp = double.parse(quantityactual) +
                                  double.parse(_dataquantity.text);
                              if (quantitytemp > double.parse(quantitytotal)) {
                                await showdialogng('Số lượng vượt   PO');
                                _focusNodeQuantity.requestFocus();
                              }
                              else if (quantitytemp ==
                                  double.parse(quantitytotal)) {
                                List<DataDetailStd> dttemp =
                                    (await mycontrollergrstd.tblTestTool_GR_STD(
                                        databarcodeinput!.po,
                                        databarcodeinput!.poitem,
                                        _dataquantity.text,
                                        _databarcode.text.toUpperCase(),
                                        '1'))!;
                                if (dttemp == null) {
                                  await showdialogng(
                                      'Không tồn tại Invoice của POItem này');
                                  _dataquantity.text = '';
                                  setState(() {
                                    _focusNodeBarcode.requestFocus();
                                  });
                                }
                                else {
                                  dtprint = await mycontrollerforall
                                      .Get_Testtool_StockcardID_Checkstt_market(
                                          dttemp[0].StockCardID.toString());
                                  //quantityactual = (double.parse(quantityactual)+ double.parse(_dataquantity.text)).toString();
                                  quantityactual = dtprint!.ActualTotalQty.toStringAsFixed(dtprint!.ActualTotalQty.truncateToDouble() == dtprint!.ActualTotalQty ? 0 : 1);
                                  dataoftable = dttemp;
                                  _databarcode.text = '';
                                  _dataquantity.text = '';
                                  quantityinvoicereceive = dtprint!.QuantityInvoiceAct.toStringAsFixed(dtprint!.QuantityInvoiceAct.truncateToDouble() == dtprint!.QuantityInvoiceAct ? 0 : 1);
                                  if (dtprint!.QuantityInvoiceAct ==
                                      dtprint!.QuantityInvoice && dtprint!.QuantityInvoice > 0) {
                                    await showdialogok(
                                        'Đã scan đủ số lượng invoice');
                                    isprintpanacim = true;
                                  } else {
                                    isprintpanacim = false;
                                  }
                                }
                              }
                              else {
                                List<DataDetailStd> dttemp =
                                    (await mycontrollergrstd.tblTestTool_GR_STD(
                                        databarcodeinput!.po,
                                        databarcodeinput!.poitem,
                                        _dataquantity.text,
                                        _databarcode.text.toUpperCase(),
                                        '0'))!;
                                if (dttemp == null)
                                {
                                  await showdialogng(
                                      'Không tồn tại Invoice của POItem này');
                                  _dataquantity.text = '';
                                  setState(() {
                                    _focusNodeBarcode.requestFocus();
                                  });
                                }
                                else
                                {
                                  dtprint = await mycontrollerforall
                                      .Get_Testtool_StockcardID_Checkstt_market(
                                          dttemp[0].StockCardID.toString());
                                  //quantityactual = (double.parse(quantityactual)+ double.parse(_dataquantity.text)).toString();
                                  quantityactual = dtprint!.ActualTotalQty.toStringAsFixed(dtprint!.ActualTotalQty.truncateToDouble() == dtprint!.ActualTotalQty ? 0 : 1);
                                  quantityinvoicereceive = (dtprint!.QuantityInvoiceAct + double.parse(_dataquantity.text)).toStringAsFixed(dtprint!.QuantityInvoiceAct.truncateToDouble() == dtprint!.QuantityInvoiceAct ? 0 : 1);
                                  dataoftable = dttemp;
                                  _databarcode.text = '';
                                  _dataquantity.text = '';
                                  setState(() {
                                    _focusNodeBarcode.requestFocus();
                                  });

                                }
                              }
                              closedialog();
                            } catch (e) {
                              closedialog();
                              await showdialogng('Error: $e');
                            }

                            setState(() {

                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                showdialogload();
                                if (_databarcode.text == '' ||
                                    _dataquantity == '') {
                                  await showdialogng(
                                      'Hãy Scan 1 thùng hàng để finish');
                                  _focusNodeBarcode.requestFocus();
                                } else {
                                  if (await showdialognotify(
                                          'Chưa đủ số lợng theo PO \n Bạn muốn kết thúc') ==
                                      1) {
                                    List<DataDetailStd> dttemp =
                                        (await mycontrollergrstd.tblTestTool_GR(
                                            databarcodeinput!.po,
                                            databarcodeinput!.poitem,
                                            _dataquantity.text,
                                            _databarcode.text.toUpperCase(),
                                            '1'))!;
                                    if (dttemp == null) {
                                      await showdialogng(
                                          'Không tồn tại Invoice của POItem này');
                                      _dataquantity.text = '';
                                      _focusNodeBarcode.requestFocus();
                                    } else {
                                      dtprint = await mycontrollerforall
                                          .Get_Testtool_StockcardID_Checkstt_market(
                                              dttemp[0].StockCardID.toString());
                                      //quantityactual = (double.parse(quantityactual)+ double.parse(_dataquantity.text)).toString();
                                      quantityactual = dtprint!.ActualTotalQty.toStringAsFixed(dtprint!.ActualTotalQty.truncateToDouble() == dtprint!.ActualTotalQty ? 0 : 1);
                                      dataoftable = dttemp;
                                      _databarcode.text = '';
                                      _dataquantity.text = '';
                                      await showdialogok('Đã quét xong');
                                      _focusNodeBarcode.requestFocus();
                                    }
                                  }
                                }
                                closedialog();
                              } catch (e) {
                                closedialog();
                                await showdialogng('Error: $e');
                              }
                            },
                            child: const Text('Finish',
                                style: TextStyle(fontSize: 15)),
                          ),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Expanded(
                        flex: 7,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text('Qty PO:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Center(
                                      child: Text(
                                          '$quantityactual/$quantitytotal',
                                          style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold))),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                  flex: 1,
                                  child: Text('Qty IV:',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold)),
                                ),
                                //SizedBox(width: 2,),
                                const SizedBox(
                                  width: 2,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Center(
                                    child: Text(
                                        '$quantityinvoicereceive/$quantityinvoice',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                  ),
                                )
                              ],
                            )
                          ],
                        )),
                    const SizedBox(
                      width: 2,
                    ),
                    Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () async {
                            setState(() {
                              isChecked = !isChecked;
                            });
                            try {
                              showdialogload();
                              if (isChecked) {
                                if (await showdialognotify(
                                'Hàng này thiếu số lượng \n Bạn có chắc chắn in Stock Card không?') ==
                            1) {
                            if (dataoftable.isNotEmpty) {
                            dtprint = await mycontrollerforall
                                .Get_Testtool_StockcardID_Checkstt_market(
                            dataoftable[0]
                                .StockCardID
                                .toString());
                            HangThieuStt? dtht =
                            await mycontrollerforall
                                .Get_Testtool_hangthieu(
                            dtprint!.Material,
                            dtprint!.Reference,
                            dtprint!.PO,
                            dtprint!.PstgDate,
                            dtprint!.POItem);
                            if (dtht!.number1 == 1) {
                            dtprint = await mycontrollerforall
                                .Get_Testtool_StockcardID_Checkstt_market(
                            dtht!.StockCardID);
                            btn_isenablepanacim = true;
                            } else {
                            btn_isenablepanacim = false;
                            isChecked = false;
                            await showdialogng(
                            'Hàng chỉ có 1.1 PO Item');
                            }
                            } else {
                            btn_isenablepanacim = false;
                            isChecked = false;
                            await showdialogng(
                            'Không có dữ liệu Stock Card ID');
                            }
                            } else {
                            isChecked = false;
                            btn_isenablepanacim = false;
                            }
                            } else {
                            btn_isenablepanacim = false;
                            }
                              closedialog();
                            } catch (e) {
                              closedialog();
                            showdialogng('Lỗi: $e');
                            }
                            setState(() {

                            });
                          },
                          child: Column(
                            children: <Widget>[
                              Checkbox(
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: isChecked,
                                onChanged: (newValue) async {
                                  //try {
                                  //   isChecked = newValue!;
                                  //   if (newValue) {
                                  //     if (await showdialognotify(
                                  //             'Hàng này thiếu số lượng \n Bạn có chắc chắn in Stock Card không?') ==
                                  //         1) {
                                  //       if (dataoftable.isNotEmpty) {
                                  //         dtprint = await mycontrollerforall
                                  //             .Get_Testtool_StockcardID_Checkstt_market(
                                  //                 dataoftable[0]
                                  //                     .StockCardID
                                  //                     .toString());
                                  //         HangThieuStt? dtht =
                                  //             await mycontrollerforall
                                  //                 .Get_Testtool_hangthieu(
                                  //                     dtprint!.Material,
                                  //                     dtprint!.Reference,
                                  //                     dtprint!.PO,
                                  //                     dtprint!.PstgDate,
                                  //                     dtprint!.POItem);
                                  //         if (dtht!.number1 == 1) {
                                  //           dtprint = await mycontrollerforall
                                  //               .Get_Testtool_StockcardID_Checkstt_market(
                                  //                   dtht!.StockCardID);
                                  //           btn_isenablepanacim = true;
                                  //         } else {
                                  //           btn_isenablepanacim = false;
                                  //           isChecked = false;
                                  //           await showdialogng(
                                  //               'Hàng chỉ có 1.1 PO Item');
                                  //         }
                                  //       } else {
                                  //         btn_isenablepanacim = false;
                                  //         isChecked = false;
                                  //         await showdialogng(
                                  //             'Không có dữ liệu Stock Card ID');
                                  //       }
                                  //     } else {
                                  //       isChecked = false;
                                  //       btn_isenablepanacim = false;
                                  //     }
                                  //   } else {
                                  //     btn_isenablepanacim = false;
                                  //   }
                                  // } catch (e) {
                                  //   showdialogng('Lỗi: $e');
                                  // }
                                  // setState(() {});
                                },
                              ),
                              const Text('Hàng Thiếu',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ))
                  ],
                ),
                // Row(
                //   children: [
                //
                //     //SizedBox(width: 2,),
                //
                //
                //   ],
                // ),
                // Row(
                //   children: [
                //
                //   ],
                // ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  height: 320,
                  width: sizescreen.width * 0.95,
                  color: Colors.grey[200],
                  // child: ListView(
                  //     scrollDirection: Axis.horizontal,
                  //     children: <Widget>[
                  //       SingleChildScrollView(
                  //         scrollDirection: Axis.vertical,
                  //         child: DataTable(
                  //           border: TableBorder.all(),
                  //           headingRowHeight: 30,
                  //           headingRowColor: MaterialStateColor.resolveWith(
                  //               (states) => Colors.blue),
                  //           headingTextStyle: TextStyle(fontSize: 30),
                  //           columns: const [
                  //             DataColumn(
                  //                 label: Text('Material',
                  //                     style: TextStyle(fontSize: 15))),
                  //             DataColumn(
                  //                 label: Text('QtyBox_Act',
                  //                     style: TextStyle(fontSize: 15))),
                  //             DataColumn(
                  //                 label: Text('PO',
                  //                     style: TextStyle(fontSize: 15))),
                  //             DataColumn(
                  //                 label: Text('POItem',
                  //                     style: TextStyle(fontSize: 15))),
                  //             DataColumn(
                  //                 label: Text('StockCardID',
                  //                     style: TextStyle(fontSize: 15))),
                  //           ],
                  //           rows: dataoftable.map((data) {
                  //             return DataRow(
                  //               cells: <DataCell>[
                  //                 DataCell(Text(data.Material)),
                  //                 DataCell(Text(data.QtyBox_Act.toString())),
                  //                 DataCell(Text(data.PO)),
                  //                 DataCell(Text(data.POItem)),
                  //                 DataCell(Text(data.StockCardID.toString())),
                  //               ],
                  //             );
                  //           }).toList(),
                  //         ),
                  //       ),
                  //     ]
                  // ),
                  child: HorizontalDataTable(
                    leftHandSideColumnWidth: 40,
                    rightHandSideColumnWidth: 420,
                    isFixedHeader: true,
                    headerWidgets: _getTitleWidget(),
                    leftSideItemBuilder: _generateFirstColumnRow,
                    rightSideItemBuilder: _generateRightHandSideColumnRow,
                    itemCount: dataoftable.length,
                    rowSeparatorWidget: const Divider(
                      color: Colors.black38,
                      height: 1.0,
                      thickness: 0.0,
                    ),

                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          onPressed: btn_isenablegr
                              ? () async {
                                  try {
                                    showdialogload();
                                    if (dtprint != null) {
                                      if (dtprint!.QuantityInvoiceAct ==
                                              dtprint!.QuantityInvoice &&
                                          dtprint!.QuantityInvoice > 0) {
                                        BluetoothConnection.toAddress(Mac)
                                            .then((_connection) async {
                                          connection = _connection;
                                          await Bluetooth_Print_SBPL();
                                        }).catchError((error) {
                                          showdialogng('Lỗi: $error');
                                        });
                                        if (isConnected) {
                                          connection?.dispose();
                                          connection = null;
                                        }
                                      } else {
                                        if (isChecked) {
                                          BluetoothConnection.toAddress(Mac)
                                              .then((_connection) async {
                                            connection = _connection;
                                            await Bluetooth_Print_SBPL();
                                          }).catchError((error) {
                                            showdialogng('Lỗi: $error');
                                          });
                                          if (isConnected) {
                                            connection?.dispose();
                                            connection = null;
                                          }
                                        } else {
                                          await showdialogng(
                                              'Bạn chưa nhập đủ số lượng Invoice \n Không thể in');
                                          _databarcode.text = '';
                                          _focusNodeBarcode.requestFocus();
                                        }
                                      }
                                    } else {
                                      await showdialogng(
                                          'Không có dữ liệu để in');
                                    }
                                    closedialog();
                                    _focusNodeBarcode.requestFocus();
                                  } catch (e) {
                                    closedialog();
                                    await showdialogng('Lỗi: $e');
                                    _focusNodeBarcode.requestFocus();
                                  }
                                }
                              : null,
                          child: const Text('Print StockCard',
                              style: TextStyle(fontSize: 15))),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                          onPressed: btn_isenablepanacim
                              ? () async {
                                  try {
                                    showdialogload();
                                    if (isChecked) {
                                      BarcodeID? dtBarcodeID =
                                          await mycontrollergrstd
                                              .Get_Testtool_getbacodeID(
                                                  dtprint!.Material,
                                                  dtprint!.Reference,
                                                  dtprint!.PO,
                                                  dtprint!.PstgDate,
                                                  dtprint!.POItem);
                                      if (dtBarcodeID != null) {
                                        await Report(dtprint!.BarcodeID,
                                            dtprint!.Plant, UserID);
                                      } else {
                                        await showdialogng(
                                            'Bạn chưa in Stock Card');
                                      }
                                    } else {
                                      await Report(dtprint!.BarcodeID,
                                          dtprint!.Plant, UserID);
                                    }
                                    closedialog();
                                    _focusNodeBarcode.requestFocus();
                                  } catch (e) {
                                    closedialog();
                                    await showdialogng('Lỗi: $e');
                                    _focusNodeBarcode.requestFocus();
                                  }
                                }
                              : null,
                          child: const Text('Print Panacim',
                              style: TextStyle(fontSize: 15))),
                    ),
                  ],
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: [
                //     Expanded(
                //       child: ElevatedButton(
                //           style: ButtonStyle(
                //               backgroundColor:
                //                   MaterialStateProperty.all(Colors.green)),
                //           onPressed: () {
                //             //Get.offNamed('/checkstt');
                //             Navigator.popAndPushNamed(context, '/checkstt');
                //           },
                //           child: const Text(
                //             'Check STT',
                //             style: TextStyle(fontSize: 15),
                //           )),
                //     ),
                //     const SizedBox(
                //       width: 10,
                //     ),
                //     Expanded(
                //       child: ElevatedButton(
                //           onPressed: () {
                //             //Get.offNamed('/grtool/');
                //             Navigator.popAndPushNamed(context, '/grtool/');
                //           },
                //           child: const Text('GR Tool',
                //               style: TextStyle(fontSize: 15))),
                //     ),
                //     const SizedBox(
                //       width: 15,
                //     ),
                //     Expanded(
                //       child: ElevatedButton(
                //           style: ButtonStyle(
                //               backgroundColor:
                //                   MaterialStateProperty.all(Colors.red)),
                //           onPressed: () {
                //             Get.offNamed('/menuform');
                //           },
                //           child: const Text('Exit',
                //               style: TextStyle(fontSize: 15))),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget('STT',40),
      _getTitleItemWidget('Material',150),
      _getTitleItemWidget('Quantity',100),
      _getTitleItemWidget('PO',100),
      _getTitleItemWidget('POItem',70),
    ];
  }
  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      color: Colors.orange[100],
      width: width,
      height: 40,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Center(child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 15))),
    );
  }
  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      width: 40,
      height: 30,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Center(child: Text((index+1).toString())),
    );
  }
  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    return Row(
      children: <Widget>[
      Container(
      width: 150,
      height: 30,
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      alignment: Alignment.centerLeft,
      child: Center(child: Text(dataoftable[index].Material)),
    ),
        Container(
          width: 100,
          height: 30,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Center(child: Text(dataoftable[index].QtyBox_Act.toStringAsFixed(dataoftable[index].QtyBox_Act.truncateToDouble() == dataoftable[index].QtyBox_Act ? 0 : 1))),
        ),
        Container(
          width: 100,
          height: 30,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Center(child:  Text(dataoftable[index].PO)),

        ),
        Container(
          width: 70,
          height: 30,
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          alignment: Alignment.centerLeft,
          child: Center(child: Text(dataoftable[index].POItem)),
        ),
      ],
    );
  }

  Future<int?> showdialognotify(String notify) async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notify'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(notify),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(1);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop(0);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showdialogok(String mes) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notify'),
          backgroundColor: Colors.green,
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(mes),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showdialogng(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.red,
          title: const Text('Notify'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<int?> showdialogload() async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text('Loading...')
            ],
          ),
        );
      },
    );
  }

  void closedialog() {
    Navigator.of(context).pop();
  }

  String QC() {
    String strFile = 'StockCard_Sampling_Rohs.prn';
    String ctrlKey = dtprint!.CTRLKEY.trim().toUpperCase();
    String T = dtprint!.T.trim().toUpperCase();
    if (T == "----") {
      if (ctrlKey == 'X' ||
          ctrlKey == 'PL' ||
          ctrlKey == 'A1' ||
          ctrlKey == 'A2' ||
          ctrlKey == 'X-M' ||
          ctrlKey == 'X-S') {
        strFile = "StockCard_Rohs.prn";
      } else {
        String strFile = 'StockCard_Sampling_Rohs.prn';
      }
    } else {
      if (ctrlKey == 'X' ||
          ctrlKey == 'PL' ||
          ctrlKey == 'A1' ||
          ctrlKey == 'A2' ||
          ctrlKey == 'X-M' ||
          ctrlKey == 'X-S') {
        strFile = "StockCard_NotCheck.prn";
      } else {
        strFile = "StockCard_Sampling.prn";
      }
    }
    return strFile;
  }

  Future<void> Bluetooth_Print_SBPL() async {
    try {
      final strfile = QC();
      final data = await rootBundle.load('assets/$strfile');
      String dataprint = String.fromCharCodes(data.buffer.asUint8List());
      String PL = '';
      String ctrlKey = dtprint!.CTRLKEY.trim().toUpperCase();
      if ((ctrlKey == 'A1') || (ctrlKey == 'A2')) {
        PL = 'PL*' + ' ' + ctrlKey;
      } else {
        PL = ctrlKey;
      }
      dataprint = dataprint.replaceAll('txt_Month', dtprint!.PstgDate);
      dataprint = dataprint.replaceAll('txt_urgent', dtprint!.Note_status);
      dataprint = dataprint.replaceAll('txt_market', dtprint!.market);
      dataprint = dataprint.replaceAll('Cate', dtprint!.Plant);
      dataprint = dataprint.replaceAll('txt_Material', dtprint!.Material);
      dataprint = dataprint.replaceAll('txt_Invoice', dtprint!.Reference);
      dataprint = dataprint.replaceAll('T_SL', dtprint!.Sloc);
      dataprint = dataprint.replaceAll('Qty', dtprint!.QuantityInvoice.toStringAsFixed(dtprint!.QuantityInvoice.truncateToDouble() == dtprint!.QuantityInvoice ? 0 : 1));
      dataprint = dataprint.replaceAll('txt_PL', PL);
      dataprint = dataprint.replaceAll('txt_ROHS', dtprint!.T);
      dataprint = dataprint.replaceAll('Text_Vender', dtprint!.Vendor);
      dataprint = dataprint.replaceAll('Text_Pos', dtprint!.Postion);
      dataprint = dataprint.replaceAll('TXT_BARCODE', dtprint!.Barcode);
      dataprint =
          dataprint.replaceAll('DN0011', 'DN${dtprint!.Barcode.length}');
      if (dataprint.isNotEmpty) {
        connection!.output.add(Uint8List.fromList(utf8.encode(dataprint)));
        await connection!.output.allSent;
      } else {
        throw ('không có file in');
      }
    } catch (e) {
      showdialogng('Lỗi: $e');
    }
  }

  Future<void> Report(String BarcodeID, String Plant, String UserID) async {
    try {
      DataPrintpanacim? dt;
      if (isChecked) {
        dt = await mycontrollergrstd.getPanacimLabel_SMT_mayin_hangthieu(
            BarcodeID, Plant, UserID, mayin);
      } else {
        dt = await mycontrollergrstd.getPanacimLabel_SMT_TestTool_mayin(
            BarcodeID, Plant, UserID, mayin);
      }
      if (dt == null) {
        await showdialogng('Không có dữ liệu');
      } else {
        if (dt.sReelID == '0') {
          await showdialogng(
              'Đây là hàng thiếu \n Bạn chọn chức năng in trên Desktop');
        } else if (dt.sReelID == '1') {
          await showdialogng(
              'Mã này chưa có trong master \n Không in được');
        } else {
          await showdialogok('In thành công: ${dt.QuantityPrint} Barcode');
          isChecked = false;
          dataoftable.clear();
        }
      }
    } catch (e) {
      await showdialogng('Lỗi: $e');
    }
  }

  void resetall() {
    _dataquantity.text = '';
    quantityinvoice = '0';
    quantityinvoicereceive = '0';
    quantityactual = '0';
    quantitytotal = '0';
    dtscandetail = [];
    listinputbarcode = [];
    databarcodeinput = null;
    dataoftable = [];
    isChecked = false;
    isBarcodeEnabled = true;
    isprintpanacim = false;
    dtprint = null;
    btn_isenablegr = true;
    btn_isenablepanacim = false;
  }
}
