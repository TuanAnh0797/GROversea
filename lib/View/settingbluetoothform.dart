import 'dart:convert';
//import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
//import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


//import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

class settingbluetooth extends StatefulWidget {
  const settingbluetooth({super.key});

  @override
  State<settingbluetooth> createState() => _settingbluetoothState();
}

class _settingbluetoothState extends State<settingbluetooth> {

  List<String> datacombobox = ['StockCard_Rohs.prn','StockCard_Sampling_Rohs.prn','StockCard_NotCheck.prn'];
  List<String> datacombobox2 = ['1','2'];
  final FocusNode _focusNodeMac = FocusNode();
  String selectedvalue = '';
  String selectedvalue2 = '';
  var _datatextfield = TextEditingController();
  BluetoothConnection? connection;
  bool get isConnected => (connection?.isConnected ?? false);
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
    selectedvalue = 'StockCard_Rohs.prn';
    loadSettings();



  }
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      // Cập nhật giá trị TextField
      _datatextfield.text = prefs.getString('mac') ?? '';
      selectedvalue2 = prefs.getString('nameprinter') ?? '1';
      _datatextfield.selection = TextSelection(
          baseOffset: 0, extentOffset: _datatextfield.value.text.length);

    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    if (isConnected) {
      connection?.dispose();
      connection = null;
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final Size sizescreen = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        title:  const Text('Setting',style: TextStyle(fontSize: 30)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(top: 20),
            width: sizescreen.width * 0.95,
            height: sizescreen.height * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: sizescreen.width * 0.15,
                      child: const Text('MAC:',style: TextStyle(fontSize: 18)),
                    ),
                    //SizedBox(width: 2,),
                    SizedBox(
                      width: sizescreen.width * 0.8,
                      child: TextField(
                        autofocus: true,
                        controller: _datatextfield,
                        focusNode: _focusNodeMac,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(
                          ),
                          contentPadding: EdgeInsets.only(top: 0,bottom: 0,left: 5,right: 5),
                        ),
                        style: const TextStyle(fontSize: 20),
                        onSubmitted: (data){
                          try{
                            String admac = '';
                            for (var i = 0; i < data.length/2; i++) {
                              if(i < data.length/2 -1){

                                admac = '$admac${data.substring(i*2,i*2+2)}:';
                              }
                              else{
                                admac = admac + data.substring(i*2,i*2+2);
                              }
                            }
                            saveSettings("mac",admac);
                            setState(() {
                              _datatextfield.text = admac;
                            });
                          }
                          catch(e){
                              showdialogng('Lỗi: $e');
                          }

                        },
                        onTap: (){
                          _datatextfield.selection = TextSelection(
                              baseOffset: 0, extentOffset: _datatextfield.value.text.length);
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  children: [
                    const Text('Print Panacim:',style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 20,),
                    DropdownMenu<String>(
                      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(),contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),fillColor: Colors.blue),
                      menuStyle: MenuStyle(padding: MaterialStateProperty.all(EdgeInsets.zero),elevation: MaterialStateProperty.all(4)),
                      width: 190,
                      textStyle: const TextStyle(fontSize: 20),
                      initialSelection: selectedvalue2,
                      onSelected: (String? value) async {
                        selectedvalue2 = value!;
                        saveSettings("nameprinter",selectedvalue2);
                      },
                      dropdownMenuEntries: datacombobox2.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     const SizedBox(width: 10,),
                //     SizedBox(
                //       width: 100,
                //       height: 40,
                //       child: ElevatedButton(onPressed: () {
                //
                //         _showMyDialog();
                //
                //       }, child: const Text('Save',style: TextStyle(fontSize: 20),)),
                //     ),
                //
                //
                //   ],
                // ),
                //const SizedBox(height: 15,),
                Row(
                  children: [
                    const Text('File:',style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 20,),
                    DropdownMenu<String>(
                      inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(),contentPadding: EdgeInsets.symmetric(vertical: 0.0,horizontal: 10),fillColor: Colors.blue),
                      menuStyle: MenuStyle(padding: MaterialStateProperty.all(EdgeInsets.zero),elevation: MaterialStateProperty.all(4)),

                      width: 285,
                      textStyle: const TextStyle(fontSize: 15),
                      initialSelection: datacombobox.first,
                      onSelected: (String? value) async {
                        selectedvalue = value!;
                      },
                      dropdownMenuEntries: datacombobox.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(value: value, label: value);
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  color: Colors.green,
                  width: 150,
                  height: 40,
                  child: ElevatedButton(onPressed: () {
                    showdialogload();
                    BluetoothConnection.toAddress(_datatextfield.text).then((_connection) {
                      connection = _connection;
                      _sendMessage();
                      closedialog();
                    }).catchError((error){
                      closedialog();
                      Get.snackbar(
                          'Notify',
                          'Cannot Connect Printer',
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: Colors.red
                      );
                    });

                    if (isConnected) {
                      connection?.dispose();
                      connection = null;
                    }
                  },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.green), child: const Text('Print Test',style: TextStyle(fontSize: 20))
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

    );
  }
  void saveSettings(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notify'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Confirm change'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                saveSettings("mac",_datatextfield.text);
                saveSettings("nameprinter",selectedvalue2);
                Navigator.of(context).pop();

              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                loadSettings();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  void _sendMessage() async {
    final data = await rootBundle.load('assets/$selectedvalue');
    final content = String.fromCharCodes(data.buffer.asUint8List());
     // final data = await rootBundle.load('assets/test_sato.prn');
     // final content = String.fromCharCodes(data.buffer.asUint8List());

    // const content = 'A'
    //     'V050H000L0303XUStock Card'
    //     'V100H1502D30,L,06,1,0DN13,NGUYENTUANANH'
    //     'V00H000FW0101V100H300'
    //     'V400H000L0505XU  '
    //     'Q1'
    //     'Z';

    // const content = 'A'
    //
    //
    //     'V000H000FW0202V400H400'
    //     'V030H080L0102XMStock Card'
    //     'V090H010L0203XUMaterial: VL-V523ALU-N-V4'
    //     'V120H010L0203XUPlant: VR01'
    //     'V150H010L0203XUPIC: 2015133'
    //     'V180H010L0203XUDate: 17/10/2023'
    //     'V250H1502D30,L,06,1,0DN13,NGUYENTUANANH'
    //
    //     'Q1'
    //     'Z';


    // final abc = content.codeUnits;
    //print(abc);
    if (content.isNotEmpty) {
      try {
       connection!.output.add(Uint8List.fromList(utf8.encode(content)));
        //List<int> abc = [2, 27, 65, 27, 80, 83, 27, 37, 48, 27, 72, 48, 49, 48, 51, 27, 86, 48, 48, 49, 54, 49, 27, 80, 48, 50, 27, 82, 71, 48, 44, 54, 44, 48, 44, 48, 52, 55, 44, 48, 52, 56, 44, 67, 111, 110, 32, 84, 114, 225, 186, 117, 32, 196, 144, 195, 180, 110, 103, 32, 116, 114, 195, 185, 27, 81, 49, 27, 90, 3];
        //connection!.output.add(Uint8List.fromList(content.codeUnits));
        //connection!.output.add(Uint8List.fromList(abc));

        await connection!.output.allSent;
      } catch (e) {

        Get.snackbar(
          'Notify',
          e.toString(),
          snackPosition: SnackPosition.TOP,
        );
      }
    }
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
  void printViaWifi() async {
    final printer = PrinterNetworkManager('192.168.42.1');
    final data = await rootBundle.load('assets/test_sato.prn');
    final content = String.fromCharCodes(data.buffer.asUint8List());

    List<int> abc = utf8.encode(content);
    PosPrintResult connect = await printer.connect();
    if (connect == PosPrintResult.success) {
      PosPrintResult printing = await printer.printTicket(abc);
      print(printing.msg);
      print('abc');
      printer.disconnect();
    }
  }


}