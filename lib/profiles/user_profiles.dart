import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/editForm/edit_profile_form.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;
  final String userId; // User ID to identify the user

  ProfileScreen({
    required this.profileData,
    required this.userId,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Map<String, dynamic> selectedProfileData = {};

  // Function to update profile details
  Future<void> updateProfileDetails(
      String newName, String newPhotoUrl, String newGender) async {
    try {
      // Update the profile details in Firestore
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Profiles')
          .doc(widget.profileData['pid'])
          .update({
        'name': newName,
        'photo_url': newPhotoUrl,
        'gender': newGender,
      });

      DocumentSnapshot updatedProfileSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userId)
          .collection('Profiles')
          .doc(widget.profileData['pid']) // Replace with the user's document ID
          .get();

      setState(() {
        selectedProfileData =
            updatedProfileSnapshot.data() as Map<String, dynamic>;
      });
    } catch (error) {
      print('Error updating profile details: $error');
      // Handle errors and show error messages if needed
    }
  }

  Stream<DocumentSnapshot>? profileStream;
  @override
  void initState() {
    super.initState();
    // Initialize the userStream with the stream that listens to the user's data changes
    profileStream = FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .collection('Profiles')
        .doc(widget.profileData['pid'])
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: profileStream, // Listen to the user's data changes
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
          Map<String, dynamic> updatedProfileData =
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
                          'Profile Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Show the edit profile dialog
                            showDialog(
                              context: context,
                              builder: (context) => EditProfileDialog(
                                initialName: updatedProfileData['name'],
                                initialphoto_url: updatedProfileData['photo_url'],
                                initialGender: updatedProfileData['gender'],
                                onSave: (newName, newPhotoUrl, newGender) {
                                  updateProfileDetails(newName, newPhotoUrl, newGender);
                                },
                              ),
                            );
                          },
                          child: Text('Edit'),
                        )
                      ]),
                  Text('Name: ${updatedProfileData['name']}'),
                  Text('Email: ${updatedProfileData['photo_url']}'),
                  Text('Phone Number: ${updatedProfileData['gender']}'),
                ], // Display other profile details
              ),
            ),
          );

         
        }
      
    );
         
  }
}
