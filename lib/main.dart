import 'package:chat_demo_app/user%20details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    );
  runApp( MaterialApp(home: registration(),));
}
class registration extends StatefulWidget {
  const registration({Key? key}) : super(key: key);

  @override
  State<registration> createState() => _registrationState();
}

class _registrationState extends State<registration> {
  TextEditingController t1=TextEditingController();
  TextEditingController t2=TextEditingController();
  SharedPreferences? prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get();

  }
  get() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? items = prefs.getStringList('main_user');
    print("${items}");

  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Demo App"),),
      body: Column(children: [
        Text("New User"),
        TextField(controller: t1,decoration: InputDecoration(hintText: "Add Name"),),
        //Spacer(),
        TextField(controller: t2,decoration: InputDecoration(hintText: "Enter Mobile number"),),
        //Spacer(),
        ElevatedButton(onPressed: () async {

          DatabaseReference ref = FirebaseDatabase.instance.ref("users").push();

          await ref.set({
            "name": "${t1.text}",
            "age": "${t2.text}",

         });

          prefs!.setString("main_user", t2.toString());

          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return User_details("${t2.text}");
          },));
          
        }, child: Text("Submit")),

        ElevatedButton(onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return User_details("main_user");//pass key share prefrance
          },));
        }, child: Text("View")),

        // ElevatedButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return User_details("7567789190");//pass key share prefrance
        //   },));
        // }, child: Text("Alpa")),
        // ElevatedButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return User_details("9574644493");//pass key share prefrance
        //   },));
        // }, child: Text("Hardik")),
        // ElevatedButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return User_details("9999999999");//pass key share prefrance
        //   },));
        // }, child: Text("HK")),
        // ElevatedButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return User_details("1234");//pass key share prefrance
        //   },));
        // }, child: Text("navy")),
        // ElevatedButton(onPressed: () {
        //   Navigator.push(context, MaterialPageRoute(builder: (context) {
        //     return User_details("456789");//pass key share prefrance
        //   },));
        // }, child: Text("Red")),


      ]),
    );
  }
}


