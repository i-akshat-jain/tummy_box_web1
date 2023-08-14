import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> userData;

  const UserDetailsScreen({required this.userData, Key? key}) : super(key: key);

    Future<List<Map<String, dynamic>>> fetchUserReferencesByPid(
        String pid) async {
      try {
        CollectionReference usersCollection =
            FirebaseFirestore.instance.collection('Users');

        QuerySnapshot querySnapshot =
            await usersCollection.where('pid', isEqualTo: pid).get();

        List<Map<String, dynamic>> userList = [];
        querySnapshot.docs.forEach((documentSnapshot) {
          Map<String, dynamic> data =
              documentSnapshot.data() as Map<String, dynamic>;
          final String name = data['display_name'];
          final String email = data['email'];
          final String phoneNumber = data['phone_number'];
          final double walletBalance = data['walletBalance'];
          final String uid = data['uid'];
          Map<String, dynamic> userMap = {
            'name': name,
            'email': email,
            'phoneNumber': phoneNumber,
            'walletBalance': walletBalance,
            'uid': uid,
          };
          userList.add(userMap);
        });

        return userList;
      } catch (e) {
        print("Error fetching User references: $e");
        return [];
      }
    }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(8.0),
      color: Colors.grey[200],
      child: Column(
        children: [
          Text(
            'User Details',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Name: ${userData['name']}'),
          Text('Email: ${userData['email']}'),
          Text('Phone Number: ${userData['phoneNumber']}'),
          Text('Wallet Balance: ${userData['walletBalance']}'),
          // Display other user details as needed
        ],
      ),
    );
  }
}

