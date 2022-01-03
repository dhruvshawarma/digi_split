import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataBase.dart';
import 'HomeScreen.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

enum screenstate{
  show_mobile_number,
  show_otp_form,
}

class LoginScreen extends StatefulWidget {

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController phone=new TextEditingController();
  TextEditingController otp=new TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool loading=false;
  var current=screenstate.show_mobile_number;
  late String verificationId;

  showAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Return to Main Menu"),
      onPressed: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> MyApp()),(route) => false);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Not an existing user",
      style: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w400,
      ),),
      content: Text("No userdata found for this number. Register first.",
      style: TextStyle(
        fontFamily: "Teko",
        fontWeight: FontWeight.w300,
      ),),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      loading = true;
    });

    try {
      final authCredential =
      await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        loading = false;
      });

      if(authCredential.user != null){
        if(await DataBase().check_existingusers(phone.text)==true)
        {
          print("yahan atak raha hai bc");
          SharedPreferences prefs= await SharedPreferences.getInstance();
          String name=await DataBase().returnnamefromnumber(phone.text);
          print(name);
          prefs.setString('phone', phone.text);
          prefs.setString('name', name);
          setState(() {
            my_pno=prefs.getString('phone');
            my_name=prefs.getString('name');
          });
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomeScreen()),(route) => false);
        }
        else
          {
            showAlertDialog(context);
          }
      }

    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString())
      )
      );
    }
  }
  Widget OTPformwidget(context, String verificationId)
  {
    return Scaffold(
        backgroundColor: HexColor("5e8b7e"),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: 'icon',
                    child: Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage('images/cashlogo.png'),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  Hero(
                    tag: "title",
                    child: Material(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          'DiGISPLIT',
                          style: TextStyle(
                            decoration: TextDecoration.none,
                            letterSpacing: 0.5,
                            color: Colors.white,
                            fontSize: 75.0,
                            fontFamily: "Squada",
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Hero(
                    tag: 'secondtitle',
                    child: Container(
                      alignment: Alignment.topCenter,
                      width: 100.0,
                      height: 100.0,
                      child: Text(
                        "Chill, Pay and Forget!",
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          fontFamily: "Kaushan",
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Hero(
                    tag: 'textfield',
                    child: Material(
                      color: Colors.transparent,
                      child: TextField(
                        textAlign: TextAlign.center,
                        controller: otp,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white70,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          hintText: "Enter the OTP received",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  ElevatedButton(
                    onPressed: (){
                      PhoneAuthCredential phoneAuthCredential= PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otp.text);
                      signInWithPhoneAuthCredential(phoneAuthCredential);
                    },
                    child: Text("Authenticate"),
                    style: ElevatedButton.styleFrom(primary: HexColor(("03256c"))),
                  ),
                ]
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: HexColor("5e8b7e"),
      body: current==screenstate.show_mobile_number?Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Hero(
              tag: 'icon',
              child: Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('images/cashlogo.png'),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0,),
            Hero(
              tag: "title",
              child: Material(
                color: Colors.transparent,
                child: Center(
                  child: Text(
                    'DiGISPLIT',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      letterSpacing: 0.5,
                      color: Colors.white,
                      fontSize: 75.0,
                      fontFamily: "Squada",
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4.0),
            Hero(
              tag: 'secondtitle',
              child: Container(
                alignment: Alignment.topCenter,
                width: 100.0,
                height: 100.0,
                child: Text(
                  "Chill, Pay and Forget!",
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: "Kaushan",
                    fontSize: 28.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Hero(
              tag: 'textfield',
              child: Material(
                color: Colors.transparent,
                child: TextField(
                  textAlign: TextAlign.left,
                  controller: phone,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone, color: Colors.black,),
                    prefix: Text("+1 ",style: TextStyle(color: Colors.black),),
                    filled: true,
                    fillColor: Colors.white70,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(35.0),
                    ),
                    hintText: "Enter your phone number",
                  ),
                ),
              ),
            ),
            SizedBox(height: 15.0,),
            ElevatedButton(
              onPressed: (){
                String no="+1" + phone.text;
                print(no);
                setState(() {
                  loading=true;
                });

                _auth.verifyPhoneNumber(
                  phoneNumber: no,
                  verificationCompleted: (phoneAuthCredential) async {
                    setState(() {
                      loading=false;
                    });
                    signInWithPhoneAuthCredential(phoneAuthCredential);
                  },
                  verificationFailed: (verificationfailed) async {
                    setState(() {
                      loading=false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(verificationfailed.toString())
                    )
                    );
                  },
                  codeSent: (verificationId,resendingToken) async {
                    this.verificationId=verificationId;
                    setState(() {
                      loading=false;
                      current=screenstate.show_otp_form;
                    });
                  },
                  codeAutoRetrievalTimeout: (verificationId) async {

                  },
                );
              },
              child: Text("Get OTP"),
              style: ElevatedButton.styleFrom(primary: HexColor(("03256c"))),
            ),
            SizedBox(height: 25.0,),
            loading?Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                backgroundColor: Colors.grey,
                strokeWidth: 3,
              ),
            ):SizedBox(height: 10.0,),
          ],
        ),
      ):OTPformwidget(context,verificationId),
    );
  }
}
