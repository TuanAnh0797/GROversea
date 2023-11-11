import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datawedge/models/scan_result.dart';
import 'package:get/get.dart';
 import 'package:flutter_datawedge/flutter_datawedge.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:keyencesatosbpl/View/scanqrcode.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/UpdateVersion.dart';
import '../models/userlogin.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  updateversion UpdateVersion = updateversion();
  late StreamSubscription<ScanResult> onScanResultListener;
  late FlutterDataWedge fdw;
  late PackageInfo packageInfo;

  TextEditingController _datatextfield = new TextEditingController();
  final FocusNode _focusNodeBarcode = FocusNode();
  Future<void>? initScannerResult;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkversion();
    initScannerResult = initScanner();
      _focusNodeBarcode.addListener(() {
      if (_focusNodeBarcode.hasFocus) {
        setState(() {
          _datatextfield.selection = TextSelection(
              baseOffset: 0, extentOffset: _datatextfield.value.text.length);
        });
      }
    });
  }
  Future<void> checkversion() async {
    String newversion = await UpdateVersion.getnewversion();
    packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    if(newversion != version){
      if(await showdialognotify("Có phiên bản mới! \n Bạn có muốn cập nhật không?") == 1){
        await UpdateVersion.downloadFile();
      }
    }
  }
  Future<void> initScanner() async {
  if (Platform.isAndroid) {
     fdw = FlutterDataWedge(profileName: 'FlutterDataWedge');

     onScanResultListener = fdw.onScanResult
         .listen((result) => setState(() {
          if(_focusNodeBarcode.hasFocus){
            _datatextfield.text = result.data;
             methodlogin();

          }
    } ));
     await fdw.initialize();
  }
}
  void methodlogin() async {
     try {
      showdialogload();
      String iduser = _datatextfield.text.substring(4,11);
      UserLogin? dt =
          await Get_User_Login(iduser);
      if (dt != null) {
        final prefs =
            await SharedPreferences.getInstance();
        prefs.setString('FullName', dt.FullName);
        prefs.setString('UserID', dt.UserID);
        closedialog();
        Get.toNamed('/menuformlogin');
      } else {
        closedialog();
        await showdialogng('ID chưa được đăng kí');
        _focusNodeBarcode.requestFocus();
      }
    } catch (e) {
      closedialog();
      await showdialogng('Lỗi: $e');
      _focusNodeBarcode.requestFocus();
    }
  }



  @override
  void dispose() {
    // TODO: implement dispose

     onScanResultListener.cancel();

    _datatextfield.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size sizescreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        title:  const Center(

             child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
               children: [

                 Text('Login Screen', style: TextStyle(fontSize: 30))
               ],
             )
             ),
      ),
      body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
                width: sizescreen.width * 0.90,
                height: sizescreen.height * 0.88,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                     Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                      Icon(MdiIcons.earth,size: 40,color: Colors.indigo),
                      const Text('GR OVER SEA', style: TextStyle(fontSize: 35,color: Colors.indigo,fontWeight: FontWeight.bold)),
                    ]),

                    const SizedBox(height: 70,),
                    Row(
                      children: [
                        // SizedBox(
                        //     width: sizescreen.width * 0.1,
                        //     child: const Text(
                        //       'ID:',
                        //       style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
                        //     )),
                        // const SizedBox(width: 5),
                        SizedBox(
                          width: sizescreen.width * 0.9,
                          child: TextField(

                              showCursor: true,
                              readOnly: true,
                              autofocus: true,
                              focusNode: _focusNodeBarcode,
                              controller: _datatextfield,
                              decoration: const InputDecoration(
                                 labelText: 'ID Scan',
                                  border: OutlineInputBorder(),
                                  contentPadding: EdgeInsets.only(
                                      top: 0, bottom: 0, left: 5, right: 5)),
                              style: const TextStyle(fontSize: 25),
                              onSubmitted: (value) async {
                              },
                              onTap: () {
                                setState(() {
                                  _datatextfield.selection = TextSelection(
                                      baseOffset: 0,
                                      extentOffset:
                                          _datatextfield.value.text.length);
                                });

                                  // Future.delayed(const Duration(seconds: 0), () {
                                  //   SystemChannels.textInput.invokeMethod('TextInput.hide');
                                  // });
                              },

                              ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // ElevatedButton(onPressed: () async {
                    //
                    //   // _datatextfield.text = '';
                    //   // await getdataid();
                    //   //UpdateVersion.downloadFile();
                    //
                    //   },
                    //   style: ElevatedButton.styleFrom(padding: EdgeInsets.all(10)), child: const Text("Scan QR",style: TextStyle(fontSize: 20),),
                    //
                    // ),

                    SizedBox(
                      height: sizescreen.height * 0.35,
                    ),
                    const Text('Published 14-09-2023',
                        style: TextStyle(
                            fontSize: 15, decoration: TextDecoration.underline,fontStyle: FontStyle.italic,color: Colors.teal)),
                    const SizedBox(
                      height: 10,
                    ),


                  ],

                )),
          ),
        ),

    );
  }

  Future<void> getdataid() async {
    //final data = await Get.to(const ScanQRCode());
    // setState(() {
    //   if (data == null) {
    //     _datatextfield.text = '';
    //   } else {
    //     _datatextfield.text = data;
    //   }
    // });
  }

  Future<UserLogin?> Get_User_Login(String title) async {
    final response = await http.post(
      Uri.parse('http://10.92.184.24:8011/Get_User_Login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'UserID': title,
      }),
    );
    if (response.statusCode == 200) {
      try {
        return UserLogin.fromJson(jsonDecode(response.body));
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('Fail API: Get_User_Login');
    }
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

  Future<void> showdialogok() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notify'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Incorrect ID'),
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

  Future<void> showdialogng(String? error) async {
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
                Text(error ?? ''),
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
}

// WidgetsBinding.instance?.addPostFrameCallback((_) {
//   // Gọi requestFocus() sau khi cấu trúc giao diện đã được xây dựng
//   _focusNode.requestFocus();
//   //_focusNode.nextFocus();
//   Future.delayed(const Duration(seconds: 1), () {
//     //_focusNode.unfocus();
//     SystemChannels.textInput.invokeMethod('TextInput.hide');
//   } );
//
// });



