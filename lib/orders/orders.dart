import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  bool showOrder = false;
  Map<String, dynamic> selectedOrder = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Add a back arrow icon
          onPressed: () {
            // Navigate back when the back button is pressed
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("Orders").snapshots(),
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

          final orderDocs = snapshot.data!.docs;

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
                          itemCount: orderDocs.length,
                          itemBuilder: (context, index) {
                            final order = orderDocs[index]['orderType'] ??
                                'No Order Type';
                            final orderReferenceId = orderDocs[index].id;
                            return ListTile(
                              title: Text(order),
                              onTap: () async {
                                DocumentSnapshot orderSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('Orders')
                                        .doc(orderReferenceId)
                                        .get();

                                setState(() {
                                  selectedOrder = orderSnapshot.data()
                                      as Map<String, dynamic>;
                                  showOrder = true;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (showOrder)
                    Expanded(
                      child: Container(
                        color: Colors.yellow,
                        height: MediaQuery.of(context).size.height,
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status: ${selectedOrder['Status']}'),
                            // Change the date format to a more readable format
                            Text(
                                'Delivery Date: ${_formatTimestamp(selectedOrder['deliveryDate'])}'),
                            Text('Location: ${selectedOrder['location']}'),
                            Text(
                                'Number of Items: ${selectedOrder['numberOfItems']}'),
                            Text(
                                'Order Date: ${_formatTimestamp(selectedOrder['orderDate'])}'),
                            Text('Order Type: ${selectedOrder['orderType']}'),
                            Text('PID: ${selectedOrder['pid']}'),
                            Text(
                                'Sub Meal Type: ${selectedOrder['subMealType']}'),
                          ],
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

String _formatTimestamp(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate(); // Convert timestamp to DateTime
  String formattedDate =
      DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime); // Format the DateTime
  return formattedDate;
}
