import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/editForm/edit_user_form.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> profilesData;
  final bool showProfileDetails;
  final Function setshowProfileDetails;
  final String userReferenceId;

  UserDetailsScreen({
    required this.userData,
    required this.profilesData,
    required this.showProfileDetails,
    required this.setshowProfileDetails,
    required this.userReferenceId,
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Map<String, dynamic>? selectedProfile;
  Map<String, dynamic> selectedUserData = {};

  Future updateUserDetails(
      String newName, String newEmail, String newPhoneNumber) async {
    // Update the user's name in Firebase Firestore
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userData['uid']) // Replace with the user's document ID
          .update({
        'display_name': newName,
        'email': newEmail,
        'phone_number': newPhoneNumber
      });

      // Refresh the user data or perform any other necessary actions
      // Fetch updated user data from Firebase
      // setState or update your user data in the widget
      DocumentSnapshot updatedUserSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userData['uid']) // Replace with the user's document ID
          .get();

      // Update the user data in the widget's state
      setState(() {
        selectedUserData = updatedUserSnapshot.data() as Map<String, dynamic>;
      });
    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  Stream<DocumentSnapshot>? userStream; // Declare a stream

  @override
  void initState() {
    super.initState();
    // Initialize the userStream with the stream that listens to the user's data changes
    userStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userReferenceId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: userStream, // Listen to the user's data changes
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          // Get the updated user data from the snapshot
          Map<String, dynamic> updatedUserData =
              (snapshot.data?.data() ?? {}) as Map<String, dynamic>;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'User Details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EditUserDialog(
                              initialName: updatedUserData['display_name'],
                              initialEmail: updatedUserData['email'],
                              initialPhoneNumber: updatedUserData['phone_number'],
                              onSave: (newName, newEmail, newPhoneNumber) {
                                updateUserDetails(newName, newEmail, newPhoneNumber);
                              },
                            ),
                          );
                        },
                        child: Text('Edit'),
                      ),
                    ],
                  ),
                  Text('Name: ${updatedUserData['display_name']}'),
                  Text('Email: ${updatedUserData['email']}'),
                  Text('Phone Number: ${updatedUserData['phone_number']}'),

                  SizedBox(height: 20),

                  Text(
                    'Profiles:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Column(
                    children: widget.profilesData.map((profile) {
                      return ListTile(
                        title: Text('Profile Name: ${profile['name']}'),
                        onTap: () {
                          setState(() {
                            selectedProfile = profile;
                          });
                          widget.setshowProfileDetails(true, profile);
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
