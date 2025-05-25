import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BasketHistoryPage extends StatefulWidget {
  const BasketHistoryPage({super.key});

  @override
  _BasketHistoryPageState createState() => _BasketHistoryPageState();
}

class _BasketHistoryPageState extends State<BasketHistoryPage> {
  List<Map<String, dynamic>> baskets = [];
  bool isLoading = true;
  String? username;

  @override
  void initState() {
    super.initState();
    fetchBasketData();
  }

  Future<void> fetchBasketData() async {
    print("Fetching basket data...");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserName');

    final response = await http.post(
      Uri.parse("http://192.168.1.104/myprojects/get_final_baskets.php"),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"username": username}),
    );

    if (response.statusCode == 200) {
      try {
        var jsonData = jsonDecode(response.body);

        if (!mounted) return;

        setState(() {
          if (jsonData is List) {
            baskets =
                jsonData
                    .map((item) => Map<String, dynamic>.from(item))
                    .toList();
          } else {
            print("Unexpected JSON format: $jsonData");
          }

          isLoading = false;
        });
        print("Decoded Data: $baskets");
      } catch (e) {
        print("JSON Parsing Error: $e");
        setState(() => isLoading = false);
      }
    } else {
      print("Error fetching data: ${response.statusCode}");
      setState(() => isLoading = false);
    }
    print("Basket data fetch completed.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Basket History")),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : baskets.isEmpty
              ? Center(child: Text("No basket history found"))
              : ListView.builder(
                itemCount: baskets.length, // ✅ Corrected
                itemBuilder: (context, index) {
                  var basket = baskets[index]; // ✅ Use list indexing
                  String date = basket['date_created'] ?? "Unknown Date";
                  List<dynamic> rawItems = basket["items"] ?? [];
                  List<Map<String, dynamic>> items =
                      rawItems
                          .map((e) => Map<String, dynamic>.from(e))
                          .toList();

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Basket Header
                          Text(
                            "Purchased on: $date",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),

                          // Horizontal Scrollable List of Books
                          SizedBox(
                            height: 120, // ✅ Smaller item size
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: items.length,
                              itemBuilder: (context, i) {
                                return Card(
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Book Image
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          child: Image.asset(
                                            "assets/${items[i]['imagename']}",
                                            height: 60,
                                            width: 60,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(height: 5),
                                        // Book Title & Count
                                        Text(
                                          items[i]['title'] ?? "Unknown Title",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          "x${items[i]['count'] ?? 1}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.blueAccent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
