import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digi_split/add_money_personal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'DataBase.dart';
import 'HomeScreen.dart';

class ConvoScreen extends StatefulWidget {
  final String nme;
  final String chtrid;
  ConvoScreen(this.nme,this.chtrid);

  @override
  _ConvoScreenState createState() => _ConvoScreenState();
}

class _ConvoScreenState extends State<ConvoScreen> with TickerProviderStateMixin {
  bool boo = true;
  late Animation<double> animation;
  late AnimationController controller;
  TextEditingController m_controller=TextEditingController();
  Stream<QuerySnapshot>? chats;
  String? name,chatrid;
  String? mybalance,otherbalance;
  String? temp;
  bool changebyanimate=false;

  void getBalance() async
  {
    String temp=(await DataBase().getbalance(chatrid!,my_name!));
    String temp1=(await DataBase().getbalance(chatrid!,name!));
    setState(() {
      mybalance=temp;
      otherbalance=temp1;
    });
  }

  void initState()
  {
    super.initState();
    chatrid=widget.chtrid;
    mybalance="0";
    name=widget.nme;
    getBalance();
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      });
    DataBase().getchats(chatrid!).then((val){
      setState(() {
        chats=val;
      });
    });
  }
  Widget MessageBody()
  {
    return StreamBuilder<QuerySnapshot>(
      stream: chats,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.builder(
          reverse: true,
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context,index){
            bool yes_no;
            if(snapshot.data!.docs[index]["Type"]=="message")
              {
                if(snapshot.data!.docs[index]["sender"]==my_pno)
                  yes_no=true;
                else
                  yes_no=false;
                return MessageTile(yes_no,snapshot.data!.docs[index]["text"]);
              }
            else
              {
                if(snapshot.data!.docs[index]["user1"]==my_name)
                  yes_no=true;
                else
                  yes_no=false;

                return MoneyTile(yes_no,
                    yes_no==true?snapshot.data!.docs[index]["moneyuser1willget"]:snapshot.data!.docs[index]["moneyuser2willget"],
                    snapshot.data!.docs[index]["Description"],
                    yes_no==true?snapshot.data!.docs[index]["user2"]:snapshot.data!.docs[index]["user1"],
                    snapshot.data!.docs[index]["date"],
                    snapshot.data!.docs[index]["time"],

                );
              }

          },
        ): Container();
      },
    );
  }
  _updatebalance(double mynewval, double othernewval)
  {
    setState(() {
      mybalance=mynewval.toString();
      otherbalance=othernewval.toString();
    });
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Opacity(
            opacity: 0.65,
            child: Container(
              color: HexColor("DDDDDD"),
            ),
          ),
          Column(
          children: [
            Container(
              height: 99.0,
              color:  HexColor("#345678"),
              padding: EdgeInsets.symmetric(vertical: 6.0,horizontal: 18.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 35.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    CircleAvatar(
                      backgroundColor: Colors.blueAccent,
                      child: Text(name![0],
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontFamily: "Kaushan",
                          fontSize: 22.0,
                        ),
                      ),
                    ),
                    SizedBox(width: 14.0,),
                    Text(name!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 17.0,
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: (){},
                      child: Row(
                            children: [
                              IconButton(onPressed:(){}, icon: Image.asset("images/getcashicon2.png",), color: Colors.white, iconSize: 24.0,),
                              Text("₹ $mybalance",
                                style: TextStyle(
                                  color: double.parse(mybalance!)>=0?Colors.lightGreen:Colors.red,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                    ),

                  ],
                ),
              ),
            ),
            Flexible(child: MessageBody()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0,vertical: 10.0),
              child: AnimatedCrossFade(
                firstCurve: Curves.slowMiddle,
                duration: Duration(milliseconds: 400),
                crossFadeState: changebyanimate==true?CrossFadeState.showFirst:CrossFadeState.showSecond,
                firstChild: Row(
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextField(
                        keyboardType: TextInputType.text,
                        minLines: 1,
                        maxLines: 5,
                        controller: m_controller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(35.0),
                          ),
                          hintText: "Enter your message...",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MaterialButton(
                        color: Colors.white,
                        shape: CircleBorder(),
                        onPressed: (){
                          if(m_controller.text.isNotEmpty)
                          {
                            DataBase().addmessage(chatrid!, m_controller.text, my_pno!,"message");
                            setState(() {
                              m_controller.text="";
                            });
                          }
                          else
                            {
                              setState(() {
                                changebyanimate=!changebyanimate;
                              });
                            }
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 12, bottom: 12, left: 4),
                          child: Icon(
                            Icons.send_rounded,
                            color: CupertinoColors.black,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: MaterialButton(
                        color: Colors.green,
                        shape: CircleBorder(),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return AddMoney(my_name!,name!,chatrid!,double.parse(mybalance!),double.parse(otherbalance!),_updatebalance);
                          }));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 9, top: 13, bottom: 13, left: 7),
                          child: Text(
                            "₹",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 20.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              secondChild:Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    MaterialButton(
                      minWidth: 0,
                      padding: EdgeInsets.all(0),
                      color: Colors.white,
                      shape: CircleBorder(),
                      onPressed: (){
                        setState(() {
                          changebyanimate=(!changebyanimate);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, top: 12, bottom: 12, left: 15),
                        child: Icon(
                          Icons.send_rounded,
                          color: CupertinoColors.black,
                        ),
                      ),
                    ),
                    MaterialButton(
                      minWidth: 0,
                      color: Colors.green,
                      shape: CircleBorder(),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return AddMoney(my_name!,name!,chatrid!,double.parse(mybalance!),double.parse(otherbalance!),_updatebalance);
                        }));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 9, top: 13, bottom: 13, left: 10),
                        child: Text(
                          "₹",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ),
          ),
        ],
        ),
       ],
      ),
    );
  }
}


class MessageTile extends StatelessWidget {
  bool sendByMe;
  String message;
  MessageTile(this.sendByMe,this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
          margin: sendByMe
              ? EdgeInsets.only(left: 30)
              : EdgeInsets.only(right: 30),
          padding: EdgeInsets.only(
              top: 12, bottom: 12, left: 20, right: 20),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: HexColor("#AEAEB2"),
                spreadRadius: 1,
                blurRadius: 1,
                offset: Offset(0,1),
              ),
            ],
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
                colors: sendByMe ? [
                  HexColor("#345678"),
                  HexColor("#345678"),
                ]
                : [
                HexColor("EEEEEE"),
            HexColor("EEEEEE"),
                ],
          )
      ),
      child: Text(message,
          textAlign: TextAlign.start,
          style: TextStyle(
              color: sendByMe?Colors.white:Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w400)),
    ),
    );
  }
}

class MoneyTile extends StatelessWidget {
  final bool sendByMe;
  final double moneyiwillget;
  final String description;
  final String receiver;
  double positiveofnegative=0;
  final String date,time;

  MoneyTile(this.sendByMe,this.moneyiwillget,this.description,this.receiver,this.date,this.time)
  {
    positiveofnegative=-1*moneyiwillget;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: HexColor("#AEAEB2"),
              spreadRadius: 3,
              blurRadius: 3,
              offset: Offset(0,2),
            )
          ],
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
              HexColor("#345678"),
              HexColor("#345678"),
              ]
                  : [
              HexColor("EEEEEE"),
              HexColor("EEEEEE"),
              ],
            )
        ),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                ),
              ),
              height: 25.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Row(
                  children: [
                    Text(sendByMe==true?my_name!:receiver,style: TextStyle(
                      fontSize: 12.0,
                    ),),
                    Text(", $date, $time",style: TextStyle(
                      fontSize: 12.0,
                    ),),
                  ],
                ),
              ),
            ),
            Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 12.0, top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("You will",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: sendByMe?Colors.white:Colors.black,
                          ),
                        ),
                        Text(moneyiwillget>=0?" get":" give",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: sendByMe?Colors.white:Colors.black,
                          ),
                        ),
                        Text(moneyiwillget>=0?" ₹ $moneyiwillget":" ₹ $positiveofnegative",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                            color: moneyiwillget>=0?Colors.lightGreen:Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text("For ",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: sendByMe?Colors.white:Colors.black,
                          ),
                        ),
                        Text(description,
                        style: TextStyle(
                          color: sendByMe?Colors.white:Colors.black,
                          fontSize: 18.0,
                        ),),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


