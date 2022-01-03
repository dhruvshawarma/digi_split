import 'package:digi_split/DataBase.dart';
import 'package:digi_split/HomeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SetProfile extends StatefulWidget {
  final String phone;
  SetProfile({required this.phone});
  @override
  _SetProfileState createState() => _SetProfileState();
}

class _SetProfileState extends State<SetProfile> {
  TextEditingController fname=new TextEditingController();
  TextEditingController lname=new TextEditingController();
  TextEditingController pno=new TextEditingController();
  String imageUrl="empty";

  void initState()
  {
    super.initState();
    pno.text=widget.phone;
  }

  File? _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile!=null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }
  Future uploadPic(BuildContext context) async{
    String fileName = basename(_image!.path);
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!);
    imageUrl = await (await uploadTask).ref.getDownloadURL();
    imageUrl = imageUrl.toString();
  }
  Widget getCircularImage() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(150 / 2)),
        border: Border.all(
          color: Colors.black,
          width: 4.0,
        ),
      ),
      child: ClipOval(
        child: new SizedBox(
          width: 150.0,
          height: 150.0,
          child: _image==null?Image.asset('images/no-image.png')
              :Image.file(_image!, fit: BoxFit.cover,),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("5e8b7e"),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 35.0,),
            Center(
              child: Text(
                'Welcome To',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 35.0,
                  fontFamily: "Kaushan",
                ),
              ),
            ),
            Center(
              child: Text(
                'DiGISPLIT',
                style: TextStyle(
                  decoration: TextDecoration.none,
                  letterSpacing: 1.0,
                  color: Colors.white,
                  fontSize: 50.0,
                  fontFamily: "Squada",
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              alignment: Alignment.center,
              child: Text("Set up your Profile",
              style: TextStyle(
                fontSize: 28.0,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                fontFamily: "Kaushan",
              ),
              ),
            ),
            SizedBox(height: 25.0,),
            Expanded(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 25.0,),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: ()
                          {
                          getImage();
                          },
                            child: getCircularImage()
                            ),
                            ),
                            SizedBox(height: 25.0,),
                            Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: TextField(
                            textAlign: TextAlign.left,
                          controller: fname,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("dfeeea"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: "Enter your first name",
                          ),
                        ),
                      ),
                      SizedBox(height: 18.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: lname,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("dfeeea"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: "Enter your last name",
                          ),
                        ),
                      ),
                      SizedBox(height: 18.0,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          textAlign: TextAlign.left,
                          controller: pno,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: HexColor("dfeeea"),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            hintText: "Enter your number",
                          ),
                        ),
                      ),
                      SizedBox(height: 18.0,),
                      ElevatedButton(onPressed: () async{
                        SharedPreferences prefs= await SharedPreferences.getInstance();
                        uploadPic(context);
                        DataBase().uploadnewuser(fname.text, lname.text, pno.text, imageUrl);
                        prefs.setString('name', fname.text+lname.text);
                        prefs.setString('phone', pno.text);
                        setState(() {
                          my_pno=prefs.getString('phone');
                          my_name=prefs.getString('name');
                        });
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                          return HomeScreen();
                        }), (route) => false);
                      },
                      style: ElevatedButton.styleFrom(primary: HexColor(("03256c"))),
                      child: Text(
                        "Get Started"
                      ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
