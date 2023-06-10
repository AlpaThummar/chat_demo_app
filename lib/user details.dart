import 'package:chat_demo_app/chat%20screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User_details extends StatefulWidget {
  String mobile;
   User_details(this.mobile);

  @override
  State<User_details> createState() => _User_detailsState();
}

class _User_detailsState extends State<User_details> {

  DatabaseReference starCountRef =
  FirebaseDatabase.instance.ref('users');
  List main_user=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_str_user();
  }
  get_str_user() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    for(int i=0;i< 60;i++){
    main_user[i]=prefs!.getString("main_user$i") ?? "No";
    print("Main user:${main_user}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Details"),),
      body: StreamBuilder(stream: starCountRef.onValue,builder: (context, snapshot) {
        if(snapshot.connectionState==ConnectionState.active){
          final data = snapshot.data!.snapshot.value;
          Map m= data as Map;
          List value=m.values.toList();
          List key=m.keys.toList();
          
          return ListView.builder(itemCount: value.length,
            itemBuilder: (context, index) {
            return (widget.mobile!=value[index]['age'])?

              Card(child: ListTile(onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return chat_screen("${widget.mobile}","${value[index]['age']}");
                },));
              },trailing: IconButton(onPressed: () {
              DatabaseReference ref = FirebaseDatabase.instance.ref("users").child(key[index]);
              ref.remove();

            }, icon: Icon(Icons.delete)),title: Text("${value[index]['name']}"),subtitle: Text("${value[index]['age']}"),)):null;
          },);
        }else{
          return Center(child: CircularProgressIndicator());
        }
        
      },),
    );
  }
}
