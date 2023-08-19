import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeView extends StatefulWidget {
  final Function logoutCallback;

  HomeView({
    required this.logoutCallback,
    Key? key,
  }) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool showUserDetails = false;
  bool showProfileDetails = false; // Add this line
  Map<String, dynamic> selectedUserData = {};
  Map<String, dynamic> selectedProfileData = {};
  List<Map<String, dynamic>> profilesData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
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
                                      profileDoc.data()
                                          as Map<String, dynamic>;
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
                    // Handle edit button press
                    // You can navigate to an edit screen or show a dialog
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
