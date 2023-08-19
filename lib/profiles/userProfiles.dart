import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profileData;

  ProfileScreen({required this.profileData});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                  'Profile Details',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle edit button press
                    // You can navigate to an edit screen or show a dialog
                  },
                  child: Text('Edit'),
                ),
              ],
            ),
            Text('Name: ${widget.profileData['name']}'),
            Text('Date of Birth: ${widget.profileData['dob']}'),
            Text('Gender: ${widget.profileData['gender']}'),
            // Display other profile details
          ],
        ),
      ),
    );
  }
}
