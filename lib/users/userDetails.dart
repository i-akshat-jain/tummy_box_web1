import 'dart:html';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> userData;
  final List<Map<String, dynamic>> profilesData;
  final bool showProfileDetails;
  final Function setshowProfileDetails;

  UserDetailsScreen({
    required this.userData,
    required this.profilesData,
    required this.showProfileDetails,
    required this.setshowProfileDetails,
  });

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Map<String, dynamic>? selectedProfile;
  Map<String, dynamic> selectedUserData = {};
  Future updateUserDetails(String newName) async {
    // Update the user's name in Firebase Firestore
    try {
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userData['userId']) // Replace with the user's document ID
          .update({'display_name': newName});

      // Refresh the user data or perform any other necessary actions
      // Fetch updated user data from Firebase
      // setState or update your user data in the widget
      DocumentSnapshot updatedUserSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userData['userId']) // Replace with the user's document ID
          .get();

      // Update the user data in the widget's state
      setState(() {
        selectedUserData = updatedUserSnapshot.data() as Map<String, dynamic>;
      });

    } catch (error) {
      print('Error updating user details: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => EditUserDialog(
                        initialName: widget.userData['display_name'],
                        onSave: (newName) {
                          updateUserDetails(newName);
                        },
                      ),
                    );
                  },
                  child: Text('Edit'),
                ),
              ],
            ),
            Text('Name: ${widget.userData['display_name']}'),
            Text('Email: ${widget.userData['email']}'),
            Text('Phone Number: ${widget.userData['phone_number']}'),
            // Display other user details as needed

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
  }
}

class EditUserDialog extends StatefulWidget {
  final String initialName;
  final Function(String) onSave;

  EditUserDialog({required this.initialName, required this.onSave});

  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit User Details'),
      content: TextField(
        controller: _nameController,
        decoration: InputDecoration(labelText: 'Name'),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            String newName = _nameController.text;
            widget.onSave(newName); // Call the onSave function
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }
}

// Add the rest of your code here...
