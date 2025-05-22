import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/productcount.dart';
import 'package:flutter_application_2/Widgets/BasketItem.dart';
import 'package:flutter_application_2/screens/Basket.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class BasketPage extends StatefulWidget {
  BasketPage({super.key});

  @override
  State<BasketPage> createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  String? username;
  List<Product_Count> products = [];

  _BasketPageState() {
    fetchProducts();
  }

  Future<void> updateBasket(int productId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserName') ?? "Guest"; // Retrieve username
    print("Username: $username");
    final jsonBody = jsonEncode({
      "username": username,
      "product_id": productId,
    });

    print("Sending JSON: $jsonBody"); // Debugging JSON format

    final response = await http.post(
      Uri.parse('http://192.168.1.104/myprojects/UpdateProduct.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonBody, // Ensure proper formatting
    );
     Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => finalBasketPage(),
                        ),
                      );
    print("Server Response: ${response.body}"); // Debug response from PHP
  }

  Future<void> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserName');

    final response = await http.get(
      Uri.parse(
        'http://192.168.1.104/myprojects/products.php',
      ), // Adjust IP if needed
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Decoded JSON Data: $data");

      if (data["status"] == "success") {
        List<dynamic> jsonList = data["products"];
        print(jsonList);
        print("ok");
        setState(() {
          products =
              jsonList.map<Product_Count>((json) {
                return Product_Count.fromJson(json);
              }).toList();
        });

        print("object");
        print(
          "Final Decoded Products List: ${products.map((p) => p.title).toList()}",
        );
      } else {
        print("Error: ${data["message"]}");
      }
    } else {
      print("HTTP Error: ${response.statusCode}");
    }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                 builder: (context, constraints) {
                  // Dynamically set number of items per row based on screen size
                  int crossAxisCount = constraints.maxWidth > 1000 ? 4 : 2;

                  return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.6,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, i) {
                    return SizedBox(
                      height: 450,
                      child: BasketItem(
                        onButtonPressed: () => updateBasket(products[i].ID),
                        title: products[i].title,
                        description: products[i].description,
                        price: products[i].price,
                        imageName: products[i].imageName,
                        count: products[i].count,
                      ),
                    );
                  },
                );
                 }
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => finalBasketPage(),
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
                      "Checkout",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
