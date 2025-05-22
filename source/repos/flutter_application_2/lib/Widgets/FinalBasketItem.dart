import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FinalBasketItem extends StatefulWidget {
  final int ProductId;
  final String title;
  final String count;
  final String imageName;

  const FinalBasketItem({
    required this.ProductId,
    required this.title,
    required this.count,
    required this.imageName,
    super.key,
  });

  @override
  _FinalBasketItemState createState() => _FinalBasketItemState();
}

class _FinalBasketItemState extends State<FinalBasketItem> {
  String? username;
  late String count; // Kept as String to match original code

  @override
  void initState() {
    super.initState();
    count = widget.count;
  }

  Future<void> ChangeCount(int productId, String mode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserName') ?? "Guest"; // Retrieve username
    print("Username: $username");
    print(productId);
    final jsonBody = jsonEncode({
      'mode': mode,
      "username": username,
      "product_id": productId,
    });

    print("Sending JSON: $jsonBody");

    final response = await http.post(
      Uri.parse('http://192.168.1.104/myprojects/ChangeCount.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonBody,
    );

    print("Server Response: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data["status"] == "success") {
        setState(() {
          count = data["total_count"].toString();
          print("Updated Count: $count");
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/${widget.imageName}",
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  onPressed: () => ChangeCount(widget.ProductId, "add"),
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                ),
                Text(
                  "تعداد$count",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                IconButton(
                  onPressed: () => ChangeCount(widget.ProductId, "sub"),
                  icon: Container(
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(Icons.remove, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}