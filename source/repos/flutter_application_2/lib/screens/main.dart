import 'package:flutter/material.dart';
import 'package:flutter_application_2/screens/Login.dart';
 
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Using MultiProvider is convenient when providing multiple objects.
    return  MaterialApp(
      title: 'Provider Demo',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyEshop(),
     
      },
    );
  }
}


/*class UserInformations extends StatelessWidget {
  final String username;
  final String password;

  UserInformations({super.key, required this.username, required this.password});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Information")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Username: $username",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Password: $password",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
              SizedBox(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      print("basket page");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BasketPage(Username: username),
                        ),
                      );
                    },
                    child: Text("list page"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      print("Navigating to Page 2...");
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => finalBasketPage(Username: username),
                        ),
                      );
                    },
                    child: Text("basket page"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
 









