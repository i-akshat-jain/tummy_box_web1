import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/menu/meals/menu_item_list.dart';

class MenuItems extends StatefulWidget {
  const MenuItems({super.key});

  @override
  State<MenuItems> createState() => _MenuItemsState();
}

class _MenuItemsState extends State<MenuItems> {
  List<String> collectionNames = ["Breakfast", "Snacks", "Lunch", "Dinner"];
  bool showMenuItems = false;
  bool showItemDetails = false; // Add this line
  Map<String, dynamic> selectedMenuTypeData = {};
  Map<String, dynamic> selectedItemData = {};
  List<Map<String, dynamic>> itemsData = [];
  String allItemsRefID = "2x459ubWpiFcLQtRyp6W";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Add a back arrow icon
          onPressed: () {
            // Navigate back when the back button is pressed
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Menu').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          // final menuDocs = snapshot.data!.docs;

          return Container(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      color: Colors.blue,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                          itemCount: collectionNames.length,
                          itemBuilder: (context, index) {
                            final displayName = collectionNames[index];
                            // final allItemsRefID = menuDocs[index].id;
                            return ListTile(
                              title: Text(displayName),
                              onTap: () async {
                                DocumentSnapshot menuSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('Menu')
                                        .doc(allItemsRefID)
                                        .get();

                                String selectedMenuType = displayName;

                                DocumentReference menuTypeRef =
                                    menuSnapshot.reference;
                                CollectionReference menuTypeCollection =
                                    menuTypeRef.collection(selectedMenuType);

                                QuerySnapshot menuTypeSnapshot =
                                    await menuTypeCollection.get();

                                List<Map<String, dynamic>> menu = [];

                                menuTypeSnapshot.docs.forEach((itemDoc) {
                                  Map<String, dynamic> profileData =
                                      itemDoc.data() as Map<String, dynamic>;
                                  menu.add(profileData);
                                });

                                setState(() {
                                  selectedMenuTypeData = menuSnapshot.data()
                                      as Map<String, dynamic>;
                                  itemsData = menu;
                                  showMenuItems = true;
                                  showItemDetails = false;
                                  print(menu);
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (showMenuItems)
                    Expanded(
                      child: Container(
                        color: Colors.yellow,
                        height: MediaQuery.of(context).size.height * 0.92,
                        width: double.infinity,
                        child: MenuItemsList(
                          itemsData: itemsData,
                          menuUserId: allItemsRefID
                        ),
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
