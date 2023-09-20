import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/editForm/edit_menu_form.dart';

class MenuItemsList extends StatefulWidget {
  MenuItemsList({
    required this.itemsData,
    required this.menuUserId,
  });

  @override
  State<MenuItemsList> createState() => _MenuItemsListState();
  final List<Map<String, dynamic>> itemsData;
  final String menuUserId;
}

class _MenuItemsListState extends State<MenuItemsList> {
  Future<void> onUpdateItem(String newName, double newPrice) async {
    // Update the item in the database
    print('Update item: $newName, $newPrice');
    try {
      await FirebaseFirestore.instance
          .collection('Menu')
          .doc(widget.menuUserId)
          .collection()
          .doc(widget.itemsData['refID']) // Replace with the user's document ID
          .get();
      update({
        'name': newName,
        'price': newPrice,
      });

      DocumentSnapshot updatedItemSnapshot =
          await FirebaseFirestore.instance.collection('Menu').doc('menu').get();
    } catch (error) {
      print('Error updating item: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemsData.length,
      itemBuilder: (context, index) {
        final item = itemsData[index];
        return ListTile(
          title: Text(item['name']),
          subtitle: Text('Price: ${item['price']}'),
          trailing: ElevatedButton(
            onPressed: () {
              // Show the edit item dialog
              showDialog(
                context: context,
                builder: (context) => EditItemDialog(
                  initialName: item['name'],
                  initialPrice: item['price'],
                  onSave: (newName, newPrice) {
                    onUpdateItem(newName, newPrice);
                  },
                ),
              );
            },
            child: Text('Edit'),
          ),
        );
      },
    );
  }
}
