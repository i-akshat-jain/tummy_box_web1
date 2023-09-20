// import 'package:intl/intl.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirebaseService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> addOrUpdateMenuForDate(
//       DateTime date, List<MenuItem> menuItems) async {
//     final formattedDate = DateFormat('yyyy-MM-dd').format(date);

//     await _firestore.collection('menus').doc(formattedDate).set({
//       'date': formattedDate,
//       'menuItems': menuItems
//           .map((item) => {
//                 'name': item.name,
//                 'description': item.Breakfast,
//               })
//           .toList(),
//     });
//   }
// }
