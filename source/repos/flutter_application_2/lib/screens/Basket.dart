import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/productCount.dart';
import 'package:flutter_application_2/Widgets/FinalBasketItem.dart';
import 'package:flutter_application_2/screens/PurchaseHistory.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class finalBasketPage extends StatefulWidget {
  const finalBasketPage({super.key});

  @override
  State<finalBasketPage> createState() => _finalBasketPageState();
}

class _finalBasketPageState extends State<finalBasketPage> {
  List<Product_Count> products = [];
  String? username;
  @override
  void initState() {
    super.initState();
    get_user_prods();
  }

  Future<bool> hasActiveBasket() async {
       
    print(username);
    var response = await http.post(
      Uri.parse('http://192.168.1.104/myprojects/checkBasket.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    print(response.statusCode);
    var data = jsonDecode(response.body);
    print(data);
    return data["hasBasket"] == true; // Returns true if an active basket exists
  }

  Future FinilizePurchase() async {
    var response = await http.post(
      Uri.parse('http://192.168.1.104/myprojects/FinilizeBasket.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username}),
    );
    setState(() {});
  }

  Future get_user_prods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserName') ?? "Guest"; // Retrieve username
    print("Username: $username");
    final response = await http.post(
      Uri.parse('http://192.168.1.104/myprojects/get_user_prods.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"username": username}),
    );
     if (response.statusCode == 200) {
      print(response.body);
      final data = jsonDecode(response.body);
      print(data);
      if (data["status"] == "success") {
        setState(() {
          // Ensures UI updates!
          products =
              data["products"]
                  .map<Product_Count>((json) => Product_Count.fromJson(json))
                  .toList();
        });

        print("products");
       } else {
        throw Exception("Error: ${data["message"]}");
      }
    } else {
      throw Exception("HTTP Error: ${response.statusCode}");
    }
  }

  int totalprice() {
    int tp = 0;
    for (int i = 0; i < products.length; i++) {
      tp += products[i].count * int.parse(products[i].price);
    }
    return tp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Basket",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<bool>(
        future: hasActiveBasket(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // ✅ Show loading spinner
          }
          if (snapshot.hasError) {
            return Text("Error loading basket status"); // ✅ Handle errors
          }

          if (snapshot.data == false) { 
            // Handle the case where there is no active basket or data is not loaded yet
            return const Center(child: Text('سبد خرید شما نهایی شد '));
          }  
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        // Dynamically set number of items per row based on screen size
                        int crossAxisCount =
                            constraints.maxWidth > 1000 ? 4 : 2;

                        return GridView.count(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                          children: [
                            for (int i = 0; i < products.length; i++)
                              SizedBox(
                                height: 0,
                                child: FinalBasketItem(
                                  ProductId: products[i].ID,
                                  title: products[i].title,
                                  count: products[i].count.toString(),
                                  imageName: products[i].imageName,
                                  onDelete: (deletedProductId) {
                                    setState(() {
                                      products.removeWhere(
                                        (item) => item.ID == deletedProductId,
                                      );
                                    });
                                  },
                                  ReCalPrice: () {
                                    setState(() {
                                      get_user_prods();
                                      totalprice();
                                    });
                                  },
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total price: تومان${totalprice()}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            FinilizePurchase();
                           },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "Finilize Purchase",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BasketHistoryPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            "basket history",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          
        },
      ),
    );
  }
}
