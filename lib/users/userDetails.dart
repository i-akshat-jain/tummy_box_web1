import 'package:flutter/material.dart';
import '../profiles/userProfiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetailsScreen extends StatefulWidget {
  final String userReferenceId;

  UserDetailsScreen({required this.userReferenceId});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  Map<String, dynamic> userData = {};
  List<Map<String, dynamic>> profilesData = [];

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    try {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .doc(widget.userReferenceId)
          .get();

      DocumentReference userDocRef = userSnapshot.reference;
      CollectionReference profilesCollection =
          userDocRef.collection("profiles");

      QuerySnapshot profilesSnapshot = await profilesCollection.get();

      List<Map<String, dynamic>> profiles = [];

      profilesSnapshot.docs.forEach((profileDoc) {
        Map<String, dynamic> profileData =
            profileDoc.data() as Map<String, dynamic>;
        profiles.add(profileData);
      });

      setState(() {
        userData = userSnapshot.data() as Map<String, dynamic>;
        profilesData = profiles;
      });
    } catch (e) {
      print("Error fetching user details: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${userData['display_name']}'),
            Text('Email: ${userData['email']}'),
            Text('Phone Number: ${userData['phone_number']}'),
            // Display other user details as needed

            SizedBox(height: 20),

            Text(
              'Profiles:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              children: profilesData.map((profile) {
                return ListTile(
                  title: Text('Profile Name: ${profile['name']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(profileData: profile),
                      ),
                    );
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
