import 'package:flutter/material.dart';

class AvailableCountText extends StatelessWidget {
  int? count;
  final VoidCallback onButtonPressed;

  AvailableCountText({this.count, required this.onButtonPressed, super.key});

  @override
  Widget build(BuildContext context) {
    print("Count: $count");
    if (count == 0) {
      return Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 173, 28, 9).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: const Color.fromARGB(255, 155, 48, 6),
              width: 2,
            ),
          ),
          child: Text(
            "ناموجود",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 116, 16, 16),
            ),
          ),
        ),
      );
    } else {
      return ElevatedButton.icon(
        onPressed: () {
          onButtonPressed();
        },
        icon: Icon(Icons.shopping_cart, size: 10, color: Colors.white),
        label: Text(
          "افزودن به سبد خرید",
          style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
     
    }
  }
}

class BasketItem extends StatelessWidget {
  final String title;
  final String description;
  final String price;
  final String imageName;
  final int count;
  final VoidCallback onButtonPressed;

  BasketItem({
    required this.onButtonPressed,
    required this.title,
    required this.description,
    required this.price,
    required this.imageName,
    required this.count,
    super.key,
  }) {
    print({imageName + title});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                "assets/$imageName",
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              textDirection: TextDirection.rtl,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "تومان$price",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                ),
                AvailableCountText(
                  count: count,
                  onButtonPressed: onButtonPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
