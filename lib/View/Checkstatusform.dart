
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:get/get.dart';
import 'package:get/get.dart';
import 'package:keyencesatosbpl/Controller/controllercheckstt.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import '../Controller/controllerforall.dart';
import '../models/checkstt.dart';
import '../models/grstd.dart';
import '../models/modelforall.dart';

class CheckStatus extends StatefulWidget {
  const CheckStatus({super.key});

  @override
  State<CheckStatus> createState() => _CheckStatusState();
}

class _CheckStatusState extends State<CheckStatus> {
  late StreamSubscription<ScanResult> onScanResultListenerstt;
  late FlutterDataWedge fdw;
  BluetoothConnection? connection;
  bool get isConnected => (connection?.isConnected ?? false);
  DataBarcodeStd? databarcodeinput;
  DetialStockCard? dt;
  bool isChecked = false;
  List<String> listinputbarcode = [];
  late controllergrcheckstt mycontrollergrcheckstt;
  late controllerforall mycontrollerforall;
  var _databarcode = TextEditingController();
  List<InforStockCardCheckStt> datacombobox = [];
  String lbl_material = '';
  String lbl_poitem = '';
  String lbl_quantity = '';
  String lbl_quantityact = '';
  String lbl_rosh = '';
  String btn_grprint = '';
  String btn_panacimprint = '';
  Color btncolor_grprint = Colors.grey;
  Color btncolor_panacimprint = Colors.grey;
  bool btn_isenablegrprint = false;
  bool btn_isenablepanacimprint = false;
  final FocusNode _focusNodeBarcode = FocusNode();
  // String ctrlKey = '';
  // String T = '';
  String Mac = '';
  late String FullName;
  late String UserID;
  late String mayin;
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
    loadSettings();
    mycontrollergrcheckstt = controllergrcheckstt();
    mycontrollerforall = controllerforall();
    InforStockCardCheckStt InforStockCardCheckStttemp = const InforStockCardCheckStt(StockCardID: 0, Reference: '');
    datacombobox.add(InforStockCardCheckStttemp);
    _focusNodeBarcode.addListener(() {
      if (_focusNodeBarcode.hasFocus) {
        setState(() {
          _databarcode.selection = TextSelection(baseOffset: 0, extentOffset: _databarcode.value.text.length);
        });
      }
    });
    _focusNodeBarcode.requestFocus();

  }

  Future<void>  initScanner() async {
    if (Platform.isAndroid) {

      fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');
      onScanResultListenerstt = fdw.onScanResult
          .listen((result) => setState(()  {
        if(_focusNodeBarcode.hasFocus){
          String data = result.data;
          methodscanbarcode(data);
        }
      } ));
      await fdw.initialize();
    }
  }

  void methodscanbarcode(String data) async {
     try{
      _databarcode.text = data;
      showdialogload();
      datacombobox.removeRange(1, datacombobox.length);
      listinputbarcode.clear();
      listinputbarcode = data.toUpperCase().split(';');
      if (data.substring(0, 2) != '45' || listinputbarcode.length < 5) {
        await showdialogng('Sai định dạng barcode');
        _focusNodeBarcode.requestFocus();
      }
      else{
        databarcodeinput = DataBarcodeStd(listinputbarcode[0], listinputbarcode[1], listinputbarcode[2], double.parse(listinputbarcode[3]), listinputbarcode[4]);
        List<InforStockCardCheckStt>? dt;
        dt = await mycontrollergrcheckstt.Get_InfoStockCard_OCR_checkstt(databarcodeinput!.po, databarcodeinput!.poitem, databarcodeinput!.material, databarcodeinput!.quantity.toString());
        if(dt ==null){
          await showdialogng("Mã này đã scan rồi!");
          _databarcode.text = '';
          listinputbarcode.clear();
          _focusNodeBarcode.requestFocus();
        }
        else{
          datacombobox.removeRange(1, datacombobox.length);
          dt.forEach((element) {
            datacombobox.add(element);
          });
        }
      }
      closedialog();
    }
    catch(e){
      closedialog();
      showdialogng('Lỗi: $e');
    }
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    onScanResultListenerstt.cancel();


    if (isConnected) {
      connection?.dispose();
      connection = null;
    }

  }
  @override
  Widget build(BuildContext context) {
    final Size sizescreen = MediaQuery.of(context).size;

    //String dropdownValue = datacombobox.first.Reference;
    return Scaffold(
      appBar: AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: 40,
      title:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Check Status', style: TextStyle(fontSize: 25)),
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
              child:  Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                       SizedBox(
                        //height: 40,
                        child: Row(
                          children: [
                            const Expanded(
                                flex: 1 ,
                                child: Text('Barcode:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                            Expanded(
                                flex: 4,
                                child: TextField(
                                  readOnly: true,
                                  showCursor: true,
                                  decoration: const InputDecoration(border: OutlineInputBorder(),contentPadding: EdgeInsets.only(top: 0,left: 2,right: 2,bottom: 0)),style: TextStyle(fontSize: 20),
                                  controller: _databarcode,
                                  focusNode: _focusNodeBarcode,
                                  onSubmitted: (data) {
                                    //methodscanbarcode(data);
                                  },
                                  onTap: (){
                                    setState(() {
                                      _databarcode.selection = TextSelection(baseOffset: 0, extentOffset: _databarcode.value.text.length);
                                      // Future.delayed(const Duration(seconds: 0), ()  {
                                      //    SystemChannels.textInput.invokeMethod('TextInput.hide');
                                      // });
                                    });
                                  },

                                )
                            )
                          ],
                        ),
                      ),
                  const SizedBox(height: 5,),
                  Row(
                    children: [
                      const Expanded(
                          flex: 1 ,
                          child: Text('Invoice:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                      Expanded(
                          flex: 4,
                          child: DropdownMenu<String>(
                            inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(),contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),fillColor: Colors.blue),
                            menuStyle: MenuStyle(padding: MaterialStateProperty.all(EdgeInsets.zero),elevation: MaterialStateProperty.all(4)),
                            width: 275,
                            textStyle: const TextStyle(fontSize: 20),
                            initialSelection: datacombobox.first.Reference,
                            onSelected: (String? value) async {
                              try{
                                resetall();
                                if(value != '0'){
                                  showdialogload();
                                  dt = await mycontrollerforall.Get_Testtool_StockcardID_Checkstt_market(value!);
                                  if(dt != null){
                                    if(dt!.BarcodeID == ''){
                                        btn_grprint = 'Chưa GR xong';
                                        btncolor_grprint = Colors.grey;
                                        btn_isenablegrprint = false;
                                    }
                                    else{
                                        btn_grprint = 'GR Finish';
                                        btncolor_grprint = Colors.green;
                                        btn_isenablegrprint = true;
                                    }
                                    lbl_material = dt!.Material;
                                    lbl_poitem = '${dt!.PO}-${dt!.POItem}';
                                    lbl_quantity = dt!.Quantity.toStringAsFixed(dt!.Quantity.truncateToDouble() == dt!.Quantity ? 0 : 1);
                                    lbl_quantityact = dt!.ActualTotalQty.toStringAsFixed(dt!.ActualTotalQty.truncateToDouble() == dt!.ActualTotalQty ? 0 : 1);
                                    lbl_rosh = '${dt!.CTRLKEY} ${dt!.Plant} ${dt!.T}';
                                    if(dt!.IsPrintPanacim == '1' && dt!.BarcodeID != ''){
                                        btn_panacimprint = 'Đã in Panacim';
                                        btncolor_panacimprint = Colors.grey;
                                    }
                                    else{
                                      btn_panacimprint = 'Chưa in Panacim';
                                      btncolor_panacimprint = Colors.green;
                                    }
                                    if(dt!.BarcodeID != '' && dt!.IsPrintPanacim != '1'){
                                        btn_isenablepanacimprint = true;
                                    }
                                    else{
                                      btn_isenablepanacimprint = false;
                                      btncolor_panacimprint = Colors.grey;
                                    }
                                  }
                                  else{
                                    btn_isenablegrprint = false;
                                    btn_isenablepanacimprint = false;
                                    btncolor_panacimprint = Colors.grey;
                                    btncolor_grprint = Colors.grey;
                                    await showdialogng('Không có dữ liệu StockCardID: $value');
                                  }
                                }
                                else{
                                  btncolor_grprint = Colors.grey;
                                  btncolor_panacimprint = Colors.grey;
                                  btn_isenablegrprint = false;
                                  btn_isenablepanacimprint = false;
                                }

                                closedialog();
                              }
                              catch(e){
                                btncolor_grprint = Colors.grey;
                                btncolor_panacimprint = Colors.grey;
                                btn_isenablegrprint = false;
                                btn_isenablepanacimprint = false;
                                closedialog();
                                showdialogng('Lỗi: $e');
                              }
                              setState(() {

                              });
                            },

                            dropdownMenuEntries: datacombobox.map<DropdownMenuEntry<String>>((InforStockCardCheckStt value) {
                              return DropdownMenuEntry<String>(value: value.StockCardID.toString(), label: value.Reference,);
                            }).toList(),
                          ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10,),
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Material:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('POItem:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Qty:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('Qty Act:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          SizedBox(height: 10,),
                          Text('ROSH',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      const SizedBox(width: 8),

                      Expanded(

                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(lbl_material,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Text(lbl_poitem,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Text(lbl_quantity,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Text(lbl_quantityact,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                              const SizedBox(height: 10,),
                              Text(lbl_rosh,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 0,),
                  Row(
                    children: [
                      Expanded(
                        flex: 9,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Expanded(
                                    flex: 2 ,
                                    child: Text('GR:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                                Expanded(
                                  flex: 5 ,
                                  child: ElevatedButton(
                                    style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(btncolor_grprint)),
                                      onPressed: btn_isenablegrprint ? () async {
                                      if(await showdialognotify('Bạn muốn in lại phiếu kho?') == 1){
                                            showdialogload();
                                            if(dt != null){
                                              try{
                                                  if(dt!.QuantityInvoice == dt!.QuantityInvoiceAct){
                                                    BluetoothConnection.toAddress(Mac).then((_connection) async {
                                                      connection = _connection;
                                                      await Bluetooth_Print_SBPL();
                                                    }).catchError((error) async {
                                                      await showdialogng(error);
                                                    });
                                                    if (isConnected) {
                                                      connection?.dispose();
                                                      connection = null;
                                                    }
                                                  }
                                                  else{
                                                    if(isChecked){
                                                      HangThieuStt? dtht = await mycontrollerforall.Get_Testtool_hangthieu(dt!.Material, dt!.Reference, dt!.PO, dt!.PstgDate, dt!.POItem) ;
                                                      if(dtht != null){
                                                          if(dtht.number1 == 1){

                                                            BluetoothConnection.toAddress(Mac).then((_connection) async {
                                                              connection = _connection;
                                                              await Bluetooth_Print_SBPL();

                                                            }).catchError((error) async {
                                                              await showdialogng(error);
                                                            });
                                                            if (isConnected) {
                                                              connection?.dispose();
                                                              connection = null;
                                                            }
                                                          }
                                                          else{
                                                            await showdialogng('Hàng đã được GR hết rồi! \n Hãy kiểm tra lại!');
                                                          }
                                                      }
                                                    }
                                                    else{
                                                      await showdialogng('Bạn chưa nhập đủ số lượng Invoice! \n Không thể in Stock Card !');
                                                      _databarcode.text = '';
                                                      _focusNodeBarcode.requestFocus();
                                                    }
                                                  }
                                              }
                                              catch(e){
                                                  closedialog();
                                                  await showdialogng('Lỗi: $e');
                                              }
                                            }
                                            else{
                                              await showdialogng('Chưa có dữ liệu để in');
                                            }
                                           closedialog();
                                      }
                                    } : null,
                                      child: Text(btn_grprint),

                                  )
                                ),

                              ],
                            ),
                            Row(
                              children: [
                                const Expanded(
                                    flex: 2 ,
                                    child: Text('Panacim:',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
                                Expanded(
                                  flex: 5 ,
                                  child: ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(btncolor_panacimprint)),
                                    onPressed: btn_isenablepanacimprint ? () async {
                                        try{
                                          showdialogload();
                                          if(dt != null){
                                              if(dt!.QuantityInvoice == dt!.QuantityInvoiceAct){
                                                String plant = dt!.Plant;
                                                String barcodeid = dt!.BarcodeID;
                                                await Report(barcodeid, plant, UserID);
                                              }
                                              else{
                                                await showdialogng('Chưa đủ số lượng Invoice');
                                              }
                                          }
                                          else{
                                              await showdialogng('Không có dữ liệu để in');
                                          }
                                          closedialog();
                                        }
                                        catch(e){
                                            closedialog();
                                           await showdialogng('Lỗi: $e');
                                        }


                                    } : null,
                                      child: Text(btn_panacimprint),
                                      ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isChecked = !isChecked;
                              });
                            },
                            child: Column(
                              children: <Widget>[
                                Checkbox(
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  value: isChecked,
                                  onChanged: (newValue) {
                                    setState(() {
                                      isChecked = newValue!;
                                    });
                                  },
                                ),
                                const Text('Hàng Thiếu',
                                    style: TextStyle(fontSize: 15)),
                              ],
                            ),
                          ),
                      )
                    ],
                  ),

                  // SizedBox(
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         flex: 4 ,
                  //         child: ElevatedButton(
                  //             style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
                  //             child: const Text("GR STD",style: TextStyle(fontSize: 15)),
                  //             onPressed: (){
                  //                   //Get.offNamed('/grstd');
                  //                   Navigator.popAndPushNamed(context, '/grstd');
                  //             }),
                  //       ),
                  //       const SizedBox(width: 15,),
                  //       Expanded(
                  //         flex: 4 ,
                  //         child: ElevatedButton(
                  //             child: const Text("GR Tool",style: TextStyle(fontSize: 15)),
                  //             onPressed: (){
                  //               //Get.offNamed('/grtool');
                  //               Navigator.popAndPushNamed(context, '/grtool');
                  //             }),
                  //       ),
                  //       const SizedBox(width: 15,),
                  //       Expanded(
                  //         flex: 4 ,
                  //         child: ElevatedButton(
                  //           style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                  //             child: const Text("Exit",style: TextStyle(fontSize: 15)),
                  //             onPressed: () async {
                  //               Get.offNamed('/menuform');
                  //             }),
                  //       ),
                  //     ],
                  //   ),
                  //
                  // ),

                ],
              ),
            ),
          ),
    ),
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
  void closedialog(){
    Navigator.of(context).pop();
  }
  Future<int?> showdialogload() async {
    return showDialog<int>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return const AlertDialog(
          content:  Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 10,),
              Text('Loading...')
            ],
          ),
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
  String QC(){
    String strFile = 'StockCard_Sampling_Rohs.prn';
    String ctrlKey = dt!.CTRLKEY.trim().toUpperCase();
    String T = dt!.T.trim().toUpperCase();
    if(T == "----"){
        if(ctrlKey == 'X' || ctrlKey == 'PL' || ctrlKey == 'A1' || ctrlKey == 'A2' || ctrlKey == 'X-M' || ctrlKey == 'X-S'){
          strFile = "StockCard_Rohs.prn";
        }
        else{
          String strFile = 'StockCard_Sampling_Rohs.prn';
        }
    }
    else{
        if(ctrlKey == 'X' || ctrlKey == 'PL' || ctrlKey == 'A1' || ctrlKey == 'A2' || ctrlKey == 'X-M' || ctrlKey == 'X-S'){
          strFile = "StockCard_NotCheck.prn";
        }
        else{
          strFile = "StockCard_Sampling.prn";
        }
    }
    return strFile;
  }
  Future<void> Bluetooth_Print_SBPL() async {
    try{
      final strfile = QC();
      final data = await rootBundle.load('assets/$strfile');
      String dataprint = String.fromCharCodes(data.buffer.asUint8List());
      String ctrlKey = dt!.CTRLKEY.trim().toUpperCase();
      String PL = '';
      if((ctrlKey == 'A1') || (ctrlKey == 'A2')){
        PL = 'PL*' + ' '  + ctrlKey;
      }
      else{
        PL = ctrlKey;
      }
      dataprint = dataprint.replaceAll('txt_Month', dt!.PstgDate);
      dataprint = dataprint.replaceAll('txt_urgent', dt!.Note_status);
      dataprint = dataprint.replaceAll('txt_market', dt!.market);
      dataprint = dataprint.replaceAll('Cate', dt!.Plant);
      dataprint = dataprint.replaceAll('txt_Material', dt!.Material);
      dataprint = dataprint.replaceAll('txt_Invoice', dt!.Reference);
      dataprint = dataprint.replaceAll('T_SL', dt!.Sloc);
      dataprint = dataprint.replaceAll('Qty', dt!.QuantityInvoice.toString());
      dataprint = dataprint.replaceAll('txt_PL', PL);
      dataprint = dataprint.replaceAll('txt_ROHS', dt!.T);
      dataprint = dataprint.replaceAll('Text_Vender', dt!.Vendor);
      dataprint = dataprint.replaceAll('Text_Pos', dt!.Postion);
      dataprint = dataprint.replaceAll('TXT_BARCODE', dt!.Barcode);
      dataprint = dataprint.replaceAll('DN0011','DN${dt!.Barcode.length}');
      if (dataprint.isNotEmpty) {
          connection!.output.add(Uint8List.fromList(utf8.encode(dataprint)));
          await connection!.output.allSent;
      }
      else{
        throw('không có file in');
      }
    }
    catch(e){
        showdialogng('Lỗi: $e');
    }
  }
  Future<void> Report(String BarcodeID, String Plant, String UserID) async {
    try{
      DataPrintpanacim? dt = await mycontrollergrcheckstt.getPanacimLabel_SMT_TestTool_mayin(BarcodeID, Plant, UserID, mayin);
      if(dt != null){
          if(dt.sReelID == '0'){
              if(await showdialognotify('Phiếu kho này đã được in rồi \n Bạn có muốn Revert lại?')==1){
                  if(await mycontrollergrcheckstt.Open_PhieuKho_SMT29(BarcodeID, UserID)){
                      showdialogok('Revert thành công');
                  }
                  else{
                      showdialogng('Revert thất bại');
                  }
              }
          }
          else if(dt.sReelID == '1'){
            await showdialogng('Mã này chưa có trong master \n Không in được!');
          }
          else{
            await showdialogok('In thành công ${dt.QuantityPrint} Barcode');
          }
      }
      else{
        await showdialogng('Không có dữ liệu');
      }

    }
    catch(e){
        await showdialogng('Lỗi: $e');
    }
  }
  void resetall(){
     lbl_material = '';
     lbl_poitem = '';
     lbl_quantity = '';
     lbl_quantityact = '';
     lbl_rosh = '';
     btn_grprint = '';
     btn_panacimprint = '';
     btncolor_grprint = Colors.grey;
     btncolor_panacimprint = Colors.grey;
     btn_isenablegrprint = false;
     btn_isenablepanacimprint = false;
  }
}

