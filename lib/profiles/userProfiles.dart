import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfiles extends StatelessWidget {
  final List<Map<String, dynamic>> profiles;

  const UserProfiles({required this.profiles, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("profiles").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          final profilesData =
              snapshot.data!.docs; // Use profilesData instead of users

          return Column(
            children: [
              Text(
                'User Profiles',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Loop through profiles and display them
              for (final profile in profiles)
                ListTile(
                  title: Text(profile['profile_name']),
                  // Handle onTap as needed
                  onTap: () {
                    // Implement navigation or other actions
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
