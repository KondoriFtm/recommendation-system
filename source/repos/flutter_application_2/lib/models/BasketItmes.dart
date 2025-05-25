
class BasketItems {
  int ID;
  String date;
  String title;
  String price;
  String imageName;
  int count;
  BasketItems({
    required this.count,
    required this.title,
    required this.date,
    required this.price,
    required this.imageName,
    required this.ID,
  });
  factory BasketItems.fromJson(Map<String, dynamic> json) {

    try {
      print("Parsing JSON Object: $json"); // Debugging raw input
      return BasketItems(
        count: int.tryParse(json["count"].toString()) ?? 0,
        ID: int.tryParse(json["id"].toString()) ?? 0,
        title: json["title"] ?? "",
        date: json["date"] ?? "",
        price: json["price"] ?? "0",
        imageName:
            json["imagename"] ?? "", // Ensure the key matches API response
      );

    } catch (e) {
      print("Error Creating Product Object: $e");
      return BasketItems(
        ID: 0,
        count: 0,
        title: "Error",
        date: "",
        price: "0",
        imageName: "",
      );
    }
    
  }
}