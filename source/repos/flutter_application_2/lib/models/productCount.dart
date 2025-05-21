class Product_Count {
  int ID;
  String title;
  String description;
  String price;
  String imageName;
  int count;
  Product_Count({
    required this.count,
    required this.title,
    required this.description,
    required this.price,
    required this.imageName,
    required this.ID,
  });
  factory Product_Count.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing JSON Object: $json"); // Debugging raw input
      return Product_Count(
        count: int.tryParse(json["count"].toString()) ?? 0,
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? "0",
        imageName:
            json["imagename"] ?? "", // Ensure the key matches API response
      );
    } catch (e) {
      print("Error Creating Product Object: $e");
      return Product_Count(
        ID: 0,
        count: 0,
        title: "Error",
        description: "",
        price: "0",
        imageName: "",
      );
    }
  }
}