import 'package:digi_split/DataBase.dart';
import 'package:digi_split/HomeScreen.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class AddMoney extends StatefulWidget {
  final String uname1,uname2,chatroomid;
  final double myoldbal,otheroldbal;
  final void Function(double mynewbal,double othernewbal) update;
  AddMoney(this.uname1,this.uname2,this.chatroomid,this.myoldbal,this.otheroldbal,this.update);

  @override
  _AddMoneyState createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  TextEditingController amt_controller=new TextEditingController();
  TextEditingController desc_controller=new TextEditingController();
  late String name1,name2,chatroom_id;
  late double myoldbal,otheroldbal;
  bool checkedValue=true;
  bool checkedValue2=false;
  bool amtflag=false;
  bool splitequallyflag=true;
  bool splitmanuallyflag=false;
  bool emptyflag=true;
  bool allright=true;
  bool manualemptyfield=false;
  double totalamount=0;
  double finalamount1=0,finalamount2=0;
  double manualfinalamount1=0,manualfinalamount2=0;

  TextEditingController manualsplit1 = new TextEditingController();
  TextEditingController manualsplit2 = new TextEditingController();
  TextEditingController paidby1 = new TextEditingController();
  TextEditingController paidby2 = new TextEditingController();

  void initState()
  {
    super.initState();
    name1=widget.uname1;
    name2=widget.uname2;
    chatroom_id=widget.chatroomid;
    myoldbal=widget.myoldbal;
    otheroldbal=widget.otheroldbal;
    manualsplit1.text="0";
    manualsplit2.text="0";
    amt_controller.text="0";
    paidby1.text="0";
    paidby2.text="0";
  }
  Widget returntexterror()
  {
    if(allright==true)
    {
      return Text("");
    }
    else
    {
      if(splitmanuallyflag==false)
      {
        return Center(
            child: Text(
              "Please fill the Manual Split Distribution and try again",
              style: TextStyle(
                  color: Colors.red, fontSize: 14.0, fontFamily: "Teko"),
            )
          );
       }
      else
        {
          return Center(
          child: Text(
          "Paid amount distribution is not right. Kindly Verify and try again.",
          style: TextStyle(color: Colors.red, fontSize: 14.0, fontFamily: "Teko"),
            ),
          );
        }
      }
  }
  popupmenu(BuildContext context)
  {
    return showModalBottomSheet(
        context: context,
        builder: (context){
      return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState)
          {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      Text("Split Manually",
                        style: TextStyle(
                          fontSize: 26.0,
                          fontFamily: "Teko",
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 15.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(name1!,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Squada",
                                fontSize: 18.0,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 100.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  onTap: (){
                                    manualsplit1.text="";
                                  },
                                  controller: manualsplit1,
                                  keyboardType: TextInputType.numberWithOptions(),
                                  decoration: InputDecoration(
                                    prefixText: "₹ ",
                                    hintText: 'Amount',
                                  ),
                                  autofocus: false,
                                ),
                              ),
                            ),
                          ]
                      ),
                      SizedBox(height: 15.0,),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(name2!,
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: "Squada",
                                fontSize: 18.0,
                              ),
                            ),
                            Spacer(),
                            Container(
                              width: 100.0,
                              height: 40.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(3.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: TextField(
                                  onTap: (){
                                    manualsplit2.text="";
                                  },
                                  controller: manualsplit2,
                                  keyboardType: TextInputType.numberWithOptions(),
                                  decoration: InputDecoration(
                                    prefixText: "₹ ",
                                    hintText: 'Amount',
                                  ),
                                  autofocus: false,
                                ),
                              ),
                            ),
                          ]
                      ),
                      SizedBox(height: 15.0,),
                      SizedBox(
                        height: 40.0,
                        width: 70.0,
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(HexColor("5e8b7e")),
                          ),
                          onPressed: (){
                            if(manualsplit1.text=="" || manualsplit2.text=="")
                              {
                                setModalState(() {
                                  manualemptyfield=true;
                                });
                              }
                            else
                              {
                                if(double.parse(manualsplit1.text)+double.parse(manualsplit2.text)==totalamount)
                                {
                                  setModalState((){
                                    manualemptyfield=false;
                                    emptyflag=true;
                                    splitmanuallyflag=true;
                                    manualfinalamount1 = double.parse(manualsplit1.text);
                                    manualfinalamount2 = double.parse(manualsplit2.text);
                                  });
                                  setState(() {
                                    emptyflag=true;
                                    splitmanuallyflag=true;
                                    manualfinalamount1 = double.parse(manualsplit1.text);
                                    manualfinalamount2 = double.parse(manualsplit2.text);
                                  });
                                  Navigator.pop(context);
                                }
                                else
                                {
                                  setModalState(() {
                                    manualemptyfield=false;
                                    emptyflag=false;
                                    manualsplit1.text="";
                                    manualsplit2.text="";
                                  });
                                }
                              }
                          },
                          child: Text("Done"),
                        ),
                      ),
                      SizedBox(height: 15.0,),
                      Text(emptyflag==true?" ":(manualemptyfield==false)?"Sum of amounts do not match the total amount. Kindly verify.":"Please fill in both the values.",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16.0,
                          fontFamily: "Teko",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
            }
          );
        }
    );
  }
  Widget splitmanually()
  {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name1!,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Squada",
                  fontSize: 18.0,
                ),
              ),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(child: Text(splitmanuallyflag==false?"-":"₹ "+ manualfinalamount1.toString())),
              ),
            ]
        ),
        SizedBox(height: 15.0,),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name2!,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Squada",
                  fontSize: 18.0,
                ),
              ),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(child: Text(splitmanuallyflag==false?"-":"₹ "+ manualfinalamount2.toString())),
              ),
            ]
        ),
      ],
    );
  }

  Widget splitequally()
  {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name1!,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Squada",
                  fontSize: 18.0,
                ),
              ),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(child: Text(splitequallyflag==false?"-":"₹ "+ finalamount1.toString())),
              ),
            ]
        ),
        SizedBox(height: 15.0,),
        Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(name2!,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Squada",
                  fontSize: 18.0,
                ),
              ),
              Spacer(),
              Container(
                width: 100.0,
                height: 40.0,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(3.0),
                ),
                child: Center(child: Text(splitequallyflag==false?"-":"₹ "+ finalamount2.toString())),
              ),
            ]
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Expense Overview",
        style: TextStyle(
          fontSize: 21.0,
          fontFamily: "Squada",
          color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 35.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(" ➤ Amount paid",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15.0,
              ),),
            SizedBox(height: 10.0,),
            Container(
                child: TextField(
                  onTap: (){
                    amt_controller.text="";
                  },
                  onChanged: (newvalue){
                    setState(() {
                      if(checkedValue==true)
                      {
                        totalamount=double.parse(newvalue);
                        finalamount1=totalamount/2;
                        finalamount2=finalamount1;
                      }
                    });
                  },
                  controller: amt_controller,
                  keyboardType: TextInputType.numberWithOptions(),
                  decoration: InputDecoration(
                    prefixText: "₹ ",
                    border: OutlineInputBorder(),
                    hintText: 'Enter the Amount',
                  ),
                  autofocus: false,
                )
            ),
            SizedBox(height: 10.0,),
            Text(" ➤ Description of the expense",
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600
              ),),
            SizedBox(height: 10.0,),
            Container(
                child: TextField(
                  maxLength: 30,
                  controller: desc_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Add a description',
                  ),
                  autofocus: false,
                )
            ),
            SizedBox(height: 15.0,),
            Text(" ➤ Paid By: ",
              style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600
              ),),
            SizedBox(height: 15.0,),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(name1[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Kaushan",
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.0,),
                  Text(name1!,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Squada",
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 100.0,
                    height: 40.0,
                    child: TextField(
                      onTap: (){
                        paidby1.text="";
                      },
                      controller: paidby1,
                      textAlign: TextAlign.left,
                      textAlignVertical: TextAlignVertical.center,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        prefixText: "₹ ",
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                      ),
                      autofocus: false,
                    ),
                  ),
                ]
            ),
            SizedBox(height: 15.0,),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Text(name2[0],
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "Kaushan",
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  SizedBox(width: 14.0,),
                  Text(name2!,
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Squada",
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Container(
                    width: 100.0,
                    height: 40.0,
                    child: TextField(
                      onTap: (){
                        paidby2.text="";
                      },
                      controller: paidby2,
                      keyboardType: TextInputType.numberWithOptions(),
                      decoration: InputDecoration(
                        prefixText: "₹ ",
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                      ),
                      autofocus: false,
                    ),
                  ),
                ]
            ),
            SizedBox(height: 15.0,),
            Row(
              children: [
                Text("Split Equally",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),),
                Checkbox(value: checkedValue,
                    onChanged: (value){
                      setState(() {
                        totalamount=double.parse(amt_controller.text);
                        if(checkedValue2==true && checkedValue==false && value==true)
                          {
                            checkedValue2=false;
                            checkedValue=value!;
                          }
                        else if(checkedValue2==false && checkedValue==true && value==false)
                          {
                            checkedValue=value!;
                            splitequallyflag=false;
                            checkedValue2=true;
                            popupmenu(context);

                          }
                        if(checkedValue==true)
                          {
                            splitequallyflag=true;
                            splitmanuallyflag=false;
                            finalamount1=totalamount/2;
                            finalamount2=finalamount1;
                          }
                      });
                    }),
                Spacer(),
                Text("Split Manually",
                  style: TextStyle(
                    fontSize: 14.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Checkbox(value: checkedValue2,
                    onChanged: (value){
                      setState(() {
                        if(checkedValue==true && checkedValue2==false && value==true)
                        {
                          checkedValue=false;
                          checkedValue2=value!;
                        }
                        else if(checkedValue==false && checkedValue2==true && value==false)
                        {
                          checkedValue=true;
                          checkedValue2=value!;
                          splitequallyflag=true;
                        }
                        if(checkedValue2==true)
                          {
                            splitequallyflag=false;
                            popupmenu(context);
                          }
                      });
                    }),
              ],
            ),
            SizedBox(height: 10.0,),
            Text("➤ Amount after splitting:",
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 15.0,),
            checkedValue==true?splitequally():splitmanually(),
            SizedBox(height: 20.0,),
            returntexterror(),
              SizedBox(height: 15.0,),
              ElevatedButton(
              style: ButtonStyle(
              backgroundColor: MaterialStateProperty.
              all(HexColor("2f5d62"))
              ),
              onPressed: (){
                if(double.parse(paidby1.text)+double.parse(paidby2.text)!=totalamount)
                  {
                    setState(() {
                      allright=false;
                    });
                  }
                else if(checkedValue2==true && splitmanuallyflag==false)
                  {
                    setState(() {
                      allright=false;
                    });
                  }
                else
                  {
                    setState(() {
                      allright=true;
                    });
                    double aftersplit1=0;
                    double aftersplit2=0;
                    if(checkedValue==true)
                      {
                        aftersplit1=finalamount1;
                        aftersplit2=finalamount2;
                      }
                    else
                      {
                        aftersplit1=manualfinalamount1;
                        aftersplit2=manualfinalamount2;
                      }
                    DataBase().addexpense("expense", my_name!,totalamount, desc_controller.text==""?"No description":desc_controller.text, double.parse(paidby1.text), double.parse(paidby2.text), checkedValue==true?"Split Equally":"Split Manually", aftersplit1, aftersplit2, chatroom_id,name2);
                    double mynewbal;
                    double othernewbal;
                    mynewbal=double.parse(paidby1.text)-aftersplit1;
                    mynewbal=myoldbal+mynewbal;
                    othernewbal=double.parse(paidby2.text)-aftersplit2;
                    othernewbal=otheroldbal+othernewbal;
                    DataBase().updateBalance(mynewbal,othernewbal,chatroom_id,my_name!,name2);
                    this.widget.update(mynewbal,othernewbal);

                    Navigator.pop(context);
                  }
              },
              child: Text("Add Expense",
              style: TextStyle(
                fontFamily: "Squada",
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
                letterSpacing: 1.0,
              ),),
            )
            ],
          ),
      ),
      ),
    );
  }
}
