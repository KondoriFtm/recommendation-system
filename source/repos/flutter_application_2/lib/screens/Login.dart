import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/ProductsList.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MyEshop extends StatefulWidget {
  const MyEshop({super.key});

  @override
  State<MyEshop> createState() => MyEshopState();
}

class MyEshopState extends State<MyEshop> {
  var number = 0;
  var Username = TextEditingController();
  var Password = TextEditingController();
  String? usererrmessage, passerrmeassage;
  var res = "";
  bool isValidString(String input) {
    final RegExp regex = RegExp(r'^[a-zA-Z0-9]+$');
    return regex.hasMatch(input);
  }

  Future islogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool IsLoggedIn = prefs.containsKey("UserName");

    //if user had been logged in
    //send it to listpage
    if (!IsLoggedIn) {
      return (null);
    } else {
      return prefs.getString("UserName");
    }
  }

  Future userlogin() async {
    try {
      print(jsonEncode({"Username": Username.text, "Password": Password.text}));

      var response = await http.post(
        Uri.parse('http://192.168.1.104/myprojects/test.php'),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'Username': Username.text,
          'Password': Password.text,
        }),
      );

      print("Response status: ${response.statusCode}");
      print("Response received: ${response.body}");

      setState(() {
        //
        res = response.body;
      });
      //if user logged in
      if (res.contains("Valid")) {
        print("Valid");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("UserName", Username.text);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BasketPage()),
        );
      } else {
        setState(() {
          res = "Username and password do not match.";
        });
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: Center(child: Text("login page")),
          actions: [
            IconButton(
              onPressed: () {
                print("hello");
              },
              icon: Icon(Icons.login),
            ),
            IconButton(
              onPressed: () {
                print("logout");
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: FutureBuilder(
          future: islogin(),
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(16.0, 14.0, 16.0, 14.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  color: Colors.blueAccent,
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => BasketPage()),
                    );
                  },
                  child: Text("catalog", style: TextStyle(color: Colors.white)),
                ),
              );

              // Return an empty container after navigation to satisfy the return type
             
            } else {
              return Container(
                margin: EdgeInsets.fromLTRB(100, 30, 100, 30),
                padding: EdgeInsets.fromLTRB(50, 15, 50, 15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue),
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(0, 40, 0, 100),
                  children: [
                    Container(
                      child: TextField(
                        controller: Username,
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          errorText: usererrmessage,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "username",
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
                      child: TextField(
                        controller: Password,
                        textAlign: TextAlign.center,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorText: passerrmeassage,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          hintText: "password",
                        ),
                      ),
                    ),
                    Container(
                      child: MaterialButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        onPressed: () {
                          //when the loginbutton is pressed
                          //at first check for input validations
                          setState(() {
                            if (Username.text.length < 4) {
                              usererrmessage =
                                  "the username most be more than 4 characters";
                              print("object");
                            } else if (!isValidString(Username.text)) {
                              usererrmessage =
                                  "the username can only contain english letters or numbers";
                            } else {
                              usererrmessage = null;
                            }

                            if (Password.text.length < 4) {
                              passerrmeassage =
                                  "the Password most be more than 4 characters";
                            } else if (!isValidString(Password.text)) {
                              passerrmeassage =
                                  "the password can only contain english letters or numbers";
                            } else {
                              passerrmeassage = null;
                            }
                          });
                          if (usererrmessage == null &&
                              passerrmeassage == null) {
                            userlogin();
                          }
                        },
                        child: Text("login"),
                      ),
                    ),
                    Container(child: Text(res)),
                  ],
                ),
              );
            }
            // Add a default return to satisfy the non-nullable return type
            return Container();
          },
        ),
      ),
    );
  }
}
