// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tummy_box_admin_web/editForm/edit_order_form.dart';

// class OrderDetails extends StatefulWidget {
//   final String orderReferenceId;
//   const OrderDetails({super.key, required this.orderReferenceId});

//   @override
//   State<OrderDetails> createState() => _OrderDetailsState();
// }

// class _OrderDetailsState extends State<OrderDetails> {
//   Map<String, dynamic>? selectedOrderData = {};

//   Stream<DocumentSnapshot>? orderStream; // Declare a stream

//    @override
//   void initState() {
//     super.initState();
//     orderStream = FirebaseFirestore.instance
//         .collection('Orders')
//         .doc(widget.orderReferenceId)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//         stream: orderStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           // Get the updated user data from the snapshot
//           selectedOrderData = snapshot.data?.data() as Map<String, dynamic>;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'Order Details',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => EditOrderDialog(
//                               initialNumberOfItems:
//                                   selectedOrderData?['numberOfItems'],
//                               onSave: (newNumberOfItems) {
//                                 // Update order details here
//                               },
//                             ),
//                           );
//                         },
//                         child: Text('Edit'),
//                       ),
//                     ],
//                   ),
//                   Text('Status: ${selectedOrderData?['Status']}'),
//                   Text('Delivery Date: ${selectedOrderData?['deliveryDate']}'),
//                   Text('Location: ${selectedOrderData?['location']}'),
//                   Text(
//                       'Number of Items: ${selectedOrderData?['numberOfItems']}'),
//                   Text('Order Date: ${selectedOrderData?['orderDate']}'),
//                   Text('Order Type: ${selectedOrderData?['orderType']}'),
//                   Text('PID: ${selectedOrderData?['pid']}'),
//                   Text('Sub Meal Type: ${selectedOrderData?['subMealType']}'),

//                   // Display other order details as needed
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }