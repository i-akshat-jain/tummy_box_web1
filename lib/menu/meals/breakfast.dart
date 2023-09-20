import 'package:flutter/material.dart';


class MenuItemsList extends StatelessWidget {
  final List<Map<String, dynamic>> itemsData;

  MenuItemsList({required this.itemsData});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemsData.length,
      itemBuilder: (context, index) {
        final item = itemsData[index];
        return ListTile(
          title: Text(item['name']),
          subtitle: Text('Price: ${item['price']}'),
          // You can add more details if needed
        );
      },
    );
  }
}
