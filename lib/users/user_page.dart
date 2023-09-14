import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/users/user_details.dart';
import 'package:tummy_box_admin_web/profiles/user_profiles.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool showUserDetails = false;
  bool showProfileDetails = false; // Add this line
  Map<String, dynamic> selectedUserData = {};
  Map<String, dynamic> selectedProfileData = {};
  List<Map<String, dynamic>> profilesData = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
appBar: AppBar(
        title: Text('User Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Add a back arrow icon
          onPressed: () {
            // Navigate back when the back button is pressed
            Navigator.of(context).pop();
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Users').snapshots(),
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

          final userDocs = snapshot.data!.docs;

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
                          itemCount: userDocs.length,
                          itemBuilder: (context, index) {
                            final displayName =
                                userDocs[index]['display_name'] ?? 'No Name';
                            final userReferenceId = userDocs[index].id;
                            return ListTile(
                              title: Text(displayName),
                              onTap: () async {
                                DocumentSnapshot userSnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('Users')
                                        .doc(userReferenceId)
                                        .get();

                                DocumentReference userDocRef =
                                    userSnapshot.reference;
                                CollectionReference profilesCollection =
                                    userDocRef.collection("profiles");

                                QuerySnapshot profilesSnapshot =
                                    await profilesCollection.get();

                                List<Map<String, dynamic>> profiles = [];

                                profilesSnapshot.docs.forEach((profileDoc) {
                                  Map<String, dynamic> profileData =
                                      profileDoc.data() as Map<String, dynamic>;
                                  profiles.add(profileData);
                                });

                                setState(() {
                                  selectedUserData = userSnapshot.data()
                                      as Map<String, dynamic>;
                                  profilesData = profiles;
                                  showUserDetails = true;
                                  showProfileDetails = false;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  if (showUserDetails)
                    Expanded(
                      child: Container(
                        color: Colors.yellow,
                        height: MediaQuery.of(context).size.height * 0.92,
                        width: double.infinity,
                        child: UserDetailsScreen(
                          //get the userReferenceId from the selected user
                          userReferenceId: selectedUserData["uid"],
                          userData: selectedUserData,
                          profilesData: profilesData,
                          showProfileDetails: showProfileDetails,
                          setshowProfileDetails: (bool value,
                              Map<String, dynamic> selectprofileData) {
                            setState(() {
                              selectedProfileData = selectprofileData;
                              showProfileDetails = value;
                            });
                          },
                        ),
                      ),
                    ),
                  if (showProfileDetails)
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.92,
                        width: double.infinity,
                        color: Colors.green,
                        child: ProfileScreen(
                          profileData: selectedProfileData,
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