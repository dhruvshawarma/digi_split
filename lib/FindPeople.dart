import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'ConvoScreen.dart';
import 'DataBase.dart';
import 'HomeScreen.dart';
import 'main.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


  TextEditingController search = TextEditingController();
  QuerySnapshot ?results,val;

  /*InitiateSearch() async
  {
    results=await DataBase().searchusers(search.text);
  }*/

  Widget searchList()
  {
    return results!=null ? ListView.builder(
      itemCount: results!.docs.length,
      shrinkWrap: true,
      itemBuilder: (context,index)
      {
        return SearchTile(results!.docs[index]["name"], results!.docs[index]["phonenumber"]);
      },

    ): Container();
  }
class SearchTile extends StatelessWidget {
  final String name,phno;
  SearchTile(this.name,this.phno);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 18.0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(name[0],
              style: TextStyle(
                color: CupertinoColors.black,
                fontFamily: "Kaushan",
                fontSize: 22.0,
              ),
            ),
          ),
          SizedBox(width: 14.0,),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8.0),
              Text(phno,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          Spacer(),
          IconButton(
            splashColor: Colors.grey,
            icon: Icon(Icons.messenger_rounded),
            color: CupertinoColors.black,
            iconSize: 20.0,
            onPressed: () async {

             if(phno==my_pno)
              {
                showToast("You cannot message yourself!",
                  duration: Duration(seconds: 2, milliseconds: 200),
                  backgroundColor: Colors.black,
                  position: StyledToastPosition.center,
                  animation: StyledToastAnimation.slideFromBottomFade,
                  context: context,
                );
              }
              else
              {
                print(my_pno);
                print(phno);
                String chatroomid=DataBase().getuserid(my_pno!,phno);
                if(await DataBase().checkExistingChatRoom(chatroomid)==false)
                DataBase().createChatRoom(chatroomid,my_pno!,my_name!,phno,name,0.0);
                Navigator.push(context, MaterialPageRoute(builder: (context){
                  return ConvoScreen(name,chatroomid);
                }));
              }
            },
          ),
        ],
      ),
    );
  }
}



