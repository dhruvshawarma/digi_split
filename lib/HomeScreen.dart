import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'DataBase.dart';
import 'Personal.dart';
import 'add_money_personal.dart';
import 'FindPeople.dart';
import 'main.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

enum currscreenstate{
  show_personal,
  show_groups,
  find_people,
}
String? my_name,my_pno;

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController searchbar = new TextEditingController();
  int selc_index=0;
  List<String> categories =["Personal", "Groups", "Find People"];
  bool title=true;


  void initState()
  {
    super.initState();
    DataBase().getchatrooms(my_name!).then((val){
      setState(() {
        chatslist=val;
      });
    });
    results=null;
  }

  Widget CategorySelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: HexColor("2f5d62"),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35.0),
            topRight: Radius.circular(35.0),
          ),
        ),
        height: 80.0,

        child: ListView.builder(
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context,int index)
            {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    selc_index=index;
                    if(selc_index!=2)
                      results=null;
                  });
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 18.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: HexColor("2f5d62"),
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    child: Padding(
                      padding: EdgeInsets.all(12.0),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 24.0,
                          fontFamily: "Headliner",
                          letterSpacing: 1.5,
                          color: selc_index==index?Colors.white:Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
        )
    );
  }
  InitiateSearch() async
  {
    val=await DataBase().searchusers(search.text);
    setState((){
      results=val;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("2f5d62"),
      appBar: AppBar(
        elevation: 0.0,
        leading:Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipOval(
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage("https://firebasestorage.googleapis.com/v0/b/digisplit-2c794.appspot.com/o/image_picker6865476430579735540.jpg?alt=media&token=5e8ebabd-20f6-44fd-b2f5-56dadcf81184"),
              ),
            ),
        ),
        title: title==true?Center(
              child: Text("DiGISPLIT",
              style: TextStyle(
                letterSpacing: 1.1,
                fontFamily: "Squada",
                fontWeight: FontWeight.w400,
                fontSize: 34.0,
                 ),
               ),
            ):Container(
          margin: EdgeInsets.symmetric(vertical: 12.0),
              child: TextField(
                controller: searchbar,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white70,
                  prefixIcon: Icon(Icons.search_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(35.0),
                  ),
                  hintText: "Search For...",
                ),
              ),
            ),
        actions: [
          IconButton(onPressed:
          (){
            setState(() {
              if(title==true)
                title=false;
              else
                title=true;
            });
          },
          icon: title==true?Icon(Icons.search_outlined):Icon(Icons.arrow_forward_ios_outlined)),
          IconButton(onPressed: ()async {
            SharedPreferences prefs= await SharedPreferences.getInstance();
            prefs.remove('phone');
            prefs.remove('name');
            _auth.signOut();
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return MyApp();
            }));
          },
          icon: Icon(Icons.logout)),
        ],
      ),
      body: Column(
        children: [
          CategorySelector(context),
          if(selc_index==2)
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: search,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white60,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(35.0),
                                ),
                                hintText: "Enter the name you want to search...",
                              ),
                            ),
                          ),
                          IconButton(icon: Icon(Icons.search, color: CupertinoColors.black,),
                            onPressed: (){
                              if(search.text!="")
                              {
                                InitiateSearch();
                              }
                              else
                              {
                                showToast("Enter a valid name!",
                                    duration: Duration(seconds: 2, milliseconds: 200),
                                    position: StyledToastPosition.center,
                                    animation: StyledToastAnimation.slideFromBottomFade,
                                    context: context);
                              }
                              search.text="";
                            },
                            color: Colors.black54,
                            iconSize: 30.0,
                          ),
                        ],
                      ),
                    ),
                    searchList(),
                  ],
                ),
              ),
            )
            else if(selc_index==0)
            Expanded(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                color: Colors.white,
              ),
          child: ChatList(),
            ),
          )
          else
          Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(35.0),
                    topRight: Radius.circular(35.0),
                  ),
                ),
              ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(Icons.attach_money_sharp),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 6.0,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(width: 8.0,),
                    Icon(Icons.money_rounded, color: Colors.white,),
                    SizedBox(width: 8.0,),
                    Text("Net Balance",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 22.5,
                        letterSpacing: 0.9,
                        fontFamily: "Teko",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                onPressed: () {},
              ),
              TextButton(
                child: Row(
                  children: [
                    Text("Transactions",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 22.0,
                      fontFamily: "Teko",
                      color: Colors.white,
                      letterSpacing: 0.8
                      ),
                    ),
                    SizedBox(width: 5.0,),
                    Icon(Icons.list_alt_sharp, color: Colors.white,),
                  ],
                ),
                onPressed: () {},
              ),
            ],
          ),
        ),
        color: HexColor("2f5d63"),
      ),
    );
  }
}




