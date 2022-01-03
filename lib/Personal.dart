import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'ConvoScreen.dart';
import 'HomeScreen.dart';


Stream<QuerySnapshot>? chatslist;

Widget ChatList()
{
  return StreamBuilder<QuerySnapshot>(
      stream: chatslist,
      builder: (context,snapshot){
        return snapshot.hasData? ListView.separated(
          separatorBuilder: (BuildContext context, int index) => const Divider(thickness: 1.5,),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context,index){
              return ChatTile(snapshot.data!.docs[index]["participants"][0],snapshot.data!.docs[index]["participants"][1],snapshot.data!.docs[index]["chatroomid"],snapshot.data!.docs[index]["balance$my_name"]);
            }
        ): Container();
      }
  );
}

class ChatTile extends StatelessWidget {
  final String name1;
  final String name2;
  String namelol="random";
  final String chatRoomId;
  final double mybal;
  ChatTile(this.name1,this.name2,this.chatRoomId,this.mybal)
  {
    if(my_name==name1)
      namelol=name2;
    else
      namelol=name1;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>ConvoScreen(namelol, chatRoomId)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(namelol[0],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: "Kaushan",
                  fontSize: 22.0,
                ),
              ),
            ),
            SizedBox(width: 14.0,),
            Text(namelol,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
              ),
            ),
            Spacer(),
            Text("₹ $mybal",
              style: TextStyle(
                color: mybal>=0?Colors.lightGreen:Colors.red,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}