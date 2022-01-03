import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


class DataBase
{
  uploadnewuser(String fname,String lname,String phone,String profilepictoken)
  {
    CollectionReference users= FirebaseFirestore.instance.collection('users');
    users.add({'name': (fname+lname), 'phonenumber': phone, 'profpictoken': profilepictoken});
  }
  Future<String> returnnamefromnumber(String number) async
  {
    int index=0;
    var name= await FirebaseFirestore.instance.collection('users').where("phonenumber", isEqualTo: number).get();
    return name.docs[index]["name"].toString();
  }
  Future<bool> check_existingusers(String phone) async
  {
    bool val;
    QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('users').where("phonenumber", isEqualTo: phone).get();
    if(querySnapshot.docs.length==0)
      return false;
    else
      return true;
  }
  searchusers(String name) async
  {
    return await FirebaseFirestore.instance.collection('users').where("name", isEqualTo: name).get();
  }
  String getuserid(String a,String b)
  {
    String result;
    int val=a.compareTo(b);
    if(a.length<b.length)
    {
      result="$a\_$b";
    }
    else if(a.length==b.length)
    {
      int val = a.compareTo(b);
      if(val<0)
        result="$a\_$b";
      else
        result="$b\_$a";
    }
    else
    {
      result="$b\_$a";
    }
    return result;
  }
  createChatRoom(String user1_user2,String phone1,String usern1,String phone2,String usern2,double balance)
  {
    FirebaseFirestore.instance.collection("chats").doc(user1_user2).set({"chatroomid": user1_user2,"phonenumber1": phone1,"phonenumber2": phone2,"participants": [usern1,usern2], "balance$usern1": balance,"balance$usern2": balance});
  }
  Future<bool> checkExistingChatRoom(String chatroomid) async
  {
    bool val;
    QuerySnapshot querySnapshot=await FirebaseFirestore.instance.collection('chats').where("chatroomid", isEqualTo: chatroomid).get();
    if(querySnapshot.docs.length==0)
      return false;
    else
      return true;
  }
  getchats(String chatroomid) async
  {
    return await FirebaseFirestore.instance.collection("chats").doc(chatroomid).collection("messages").orderBy('time',descending: true).snapshots();
  }
  getchatrooms(String name) async
  {
    return FirebaseFirestore.instance.collection("chats").where("participants", arrayContains: name).snapshots();
  }
  addexpense(String type,String sender,double totalamount,String description,double paidbyuser1,double paidbyuser2,String splittype,double aftersplituser1,aftersplituser2,String chatroomid,String receiver)
  {
    DateTime now = new DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat.Hms().format(now);
    double diff1=paidbyuser1-aftersplituser1;
    double diff2=paidbyuser2-aftersplituser2;
    FirebaseFirestore.instance.collection("chats").doc(chatroomid).collection("messages").add({
      "Type": type,
      "user1": sender,
      "user2": receiver,
      "Amount Paid": totalamount,
      "Description": description,
      "Split Type": splittype,
      "Paidbyuser1": paidbyuser1,
      "Paidbyuser2": paidbyuser2,
      "Aftersplit user1": aftersplituser1,
      "Aftersplit user2": aftersplituser2,
      "moneyuser1willget": diff1,
      "moneyuser2willget": diff2,
      "time": formattedTime,
      "date": formattedDate,
    });
  }

  Future<String> getbalance(String chatroomid,String myname) async
  {
     int index=0;
     var balance= await FirebaseFirestore.instance.collection('chats').where("chatroomid", isEqualTo: chatroomid).get();
     return balance.docs[index]["balance$myname"].toString();
  }
  updateBalance(double mynewbal,double othernewbal, String chatroomid,String myname,String othername) async
  {
    FirebaseFirestore.instance.collection("chats").doc(chatroomid).update({"balance$myname": mynewbal, "balance$othername": othernewbal});
  }

  addmessage(String chatroomid,String text,String sender,String type)
  {
    DateTime now = new DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat.Hms().format(now);
    FirebaseFirestore.instance.collection("chats").doc(chatroomid).collection("messages").add({
      "Type": type,
      "sender":sender,
      "text": text,
      "time": formattedTime,
      "date": formattedDate});
  }


}
