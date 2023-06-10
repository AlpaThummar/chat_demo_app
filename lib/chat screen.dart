import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class chat_screen extends StatefulWidget {
  String sender, reciver;

  chat_screen(this.sender, this.reciver);

  @override
  State<chat_screen> createState() => _chat_screenState();
}

class _chat_screenState extends State<chat_screen> {
  TextEditingController meesge = TextEditingController();
  DatabaseReference starCountRef = FirebaseDatabase.instance.ref('chat');
  //List order=[];

  @override
  Widget build(BuildContext context) {
    var _second = DateTime.now().toLocal().second;
    var _min = DateTime.now().toLocal().minute;
    var time = "${_min}.${_second}";
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.reciver}"),
      ),
      body: Column(
        children: [
          Text("${widget.sender}"),
          Expanded(
            child: StreamBuilder(
              stream: starCountRef.onValue,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  final data = snapshot.data!.snapshot.value;
                  Map m = data as Map;
                  List value = m.values.toList();
                  List key = m.keys.toList();



                  return ListView.builder(
                    itemCount: value.length,
                    itemBuilder: (context, index) {
                      return (widget.sender == value[index]['sender'])
                          ? ListTile(
                              trailing: Text(
                                  "${value[index]['name']} ${(value[index]["time"])}"),
                            )
                          : ListTile(
                              leading: Text("${value[index]['name']}"),
                            );
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: meesge,
                decoration: InputDecoration(hintText: "Enter Mesage"),
              )),
              IconButton(
                  onPressed: () async {
                    DatabaseReference ref =
                        FirebaseDatabase.instance.ref("chat").push();

                    await ref.set({
                      "name": "${meesge.text}",
                      "sender": "${widget.sender}",
                      "recevier": "${widget.reciver}",
                      "time": "${time.toString()}",
                    });
                    meesge.text="";

                  },
                  icon: Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}
