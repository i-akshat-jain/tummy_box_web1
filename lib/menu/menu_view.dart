import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<String> subcollectionNames = ["Breakfast", "Lunch", "Dinner", "Snacks"];
  bool showMealData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Menu Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
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

          final menuDocs = snapshot.data!.docs;
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
                          itemCount: subcollectionNames.length,
                          itemBuilder: (context, index) {
                            final subcollectionName = subcollectionNames[index];
                            return ListTile(
                              title: Text(subcollectionName),
                              onTap: () {
                                setState(() {
                                  showMealData = true;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (showMealData)
                    Expanded(
                      child: Container(
                        color: Colors.yellow,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: subcollectionNames.length,
                          itemBuilder: (context, index) {
                            final menuReferenceId = menuDocs[index].id;
                            final subcollectionName = subcollectionNames[index];
                            return StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('Menu')
                                  .doc(menuReferenceId)
                                  .collection(subcollectionName)
                                  .snapshots(),
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

                                final subcollectionDocs = snapshot.data!.docs;

                                // Create a list of ListTiles for the subcollection data
                                List<Widget> subcollectionListTiles =
                                    subcollectionDocs.map((subcollectionItem) {
                                  if (index < subcollectionDocs.length) {
                                    final subcollectionData = subcollectionItem
                                        .data() as Map<String, dynamic>;
                                    return ListTile(
                                      title: Text(subcollectionData['item1']),
                                      subtitle:
                                          Text(subcollectionData['item2']),
                                      // You can display other subcollection data here
                                    );
                                  } else {
                                    return ListTile(
                                      title: Text("No Data"),
                                      subtitle: Text("No Data"),
                                      // You can display other subcollection data here
                                    );
                                  }
                                }).toList();

                                return ListView(
                                  children: subcollectionListTiles,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
