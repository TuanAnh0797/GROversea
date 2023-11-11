import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyencesatosbpl/View/goodreceiptstd.dart';
import 'package:keyencesatosbpl/View/loginform.dart';
import 'package:keyencesatosbpl/View/settingbluetoothform.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goodreceipttool.dart';
class MenuForm extends StatefulWidget {
  int mode;
  MenuForm({super.key, required this.mode});

  @override
  State<MenuForm> createState() => _MenuFormState();
}

class _MenuFormState extends State<MenuForm> {
  late String FullName;
  late String UserID;
  Future<void> loadSettings() async {
    if(widget.mode == 1){
      final prefs = await SharedPreferences.getInstance();
      FullName = prefs.getString('FullName') ?? '';
      UserID = prefs.getString('UserID') ?? '';// Cập nhật giá trị TextField
      Get.snackbar(
        'Thông báo',
        'Xin chào $FullName - $UserID',
        snackPosition: SnackPosition.TOP,
        //backgroundColor: Colors.green
      );
    }

  }
  @override
  initState() {
    // TODO: implement initState
    super.initState();

      loadSettings();


  }
  @override
  Widget build(BuildContext context) {
    final Size sizescreen = MediaQuery
        .of(context)
        .size;
    return  Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 40,
        title:  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Menu Screen',style: TextStyle(fontSize: 25)),
            TextButton(onPressed: (){
              _showMyDialog();
            }, child: const Icon(Icons.logout,color: Colors.white,))
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: WillPopScope(
          onWillPop: () async {
            Get.snackbar(
              'Notify',
              'Please press the logout button!',
              snackPosition: SnackPosition.TOP,
            );
            return false;
          },
          child: Center(
            child: SizedBox(
                width: sizescreen.width * 0.9,
                height: sizescreen.height*0.85,
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: sizescreen.width*0.7,
                      height: 50,
                      child: ElevatedButton(onPressed: (){
                        Get.toNamed('/settingbluetooth/');
                      }, child: const Text('Setting',style: TextStyle(fontSize: 20),)),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: sizescreen.width*0.7,
                      height: 50,
                      child: ElevatedButton(onPressed: (){
                        Get.toNamed('/grtool/');
                      }, child: const Text('Good Receipt Tool',style: TextStyle(fontSize: 20),)),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: sizescreen.width*0.7,
                      height: 50,
                      child: ElevatedButton(onPressed: (){
                        Get.toNamed('/grstd/');
                      }, child: const Text('Good Receipt STD',style: TextStyle(fontSize: 20),)),
                    ),
                    const SizedBox(height: 20,),
                    SizedBox(
                      width: sizescreen.width*0.7,
                      height: 50,
                      child: ElevatedButton(onPressed: (){
                        Get.toNamed('/checkstt/');
                      }, child: const Text('Check Status',style: TextStyle(fontSize: 20),)),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
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
                Text('Confirm Logout'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {

                Get.offNamed('/');

              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}
