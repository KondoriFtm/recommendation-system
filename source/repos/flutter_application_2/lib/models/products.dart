class Products {
  int ID;
  String title;
  String description;
  String price;
  String imageName;
  Products({
    required this.title,
    required this.description,
    required this.price,
    required this.imageName,
    required this.ID,
  });
  factory Products.fromJson(Map<String, dynamic> json) {
    try {
      print("Parsing JSON Object: $json"); // Debugging raw input
      return Products(
        ID: int.tryParse(json["ID"].toString()) ?? 0,
        title: json["title"] ?? "",
        description: json["description"] ?? "",
        price: json["price"] ?? "0",
        imageName:
            json["imagename"] ?? "", // Ensure the key matches API response
      );
    } catch (e) {
      print("Error Creating Product Object: $e");
      return Products(
        ID: 0,
        title: "Error",
        description: "",
        price: "0",
        imageName: "",
      );
    }
  }
}