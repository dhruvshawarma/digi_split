import 'package:digi_split/HomeScreen.dart';

import 'LoginScreen.dart';
import 'RegisterScreen.dart';
import 'rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';


void main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs=await SharedPreferences.getInstance();
  my_pno=prefs.getString('phone');
  my_name=prefs.getString('name');

  runApp(MaterialApp(debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: HexColor("2f5d62"),
        accentColor: HexColor("5e8b7e"),
      ),
      home: my_pno==null?MyApp():HomeScreen()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
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
              SizedBox(height: 4.0,),
                Container(
                alignment: Alignment.topCenter,
                width: 100.0,
                height: 100.0,
                child:  DefaultTextStyle(
                  style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: "Teko",
                    fontSize: 38.0,
                    color: Colors.white,
                    letterSpacing: 1.0,
                  ),
                  child: AnimatedTextKit(
                    totalRepeatCount: 1,
                    animatedTexts: [
                      TyperAnimatedText("Chill, Pay and Forget!",
                        speed: const Duration(milliseconds: 70),
                      textStyle: TextStyle(
                        fontFamily: "Kaushan",
                        fontSize: 28.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                ),
                    ],
                  ),
                ),
              ),
              RoundedButton(
                title: 'Existing user? Log In',
                colour: HexColor("2b4f60"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return LoginScreen();
                  }));
                },
              ),
              RoundedButton(title: "A new user? Register first!", colour: HexColor("8ab6d6"), onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return RegisterScreen();
                  }));
                },
              ),
          ],
        ),
      ),
    );
  }
}

