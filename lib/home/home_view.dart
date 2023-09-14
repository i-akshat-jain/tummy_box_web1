import '../users/user_details.dart';
import 'package:flutter/material.dart';
import '../profiles/user_profiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/orders/orders.dart';
import 'package:tummy_box_admin_web/users/user_page.dart';
import 'package:tummy_box_admin_web/constants/box_container.dart';


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
        body: Container(
            // Make 4 buttons with specific height and midquery width
            child: Column(
          children: [
            Row(
              children: [
                Column(
                  children: [
                    BoxContainers(
                      nextPage: UserPage(),
                      pageName: "User Details",
                    ),
                    BoxContainers(
                      nextPage: OrdersPage(),
                      pageName: "Orders Details",
                    ),
                  ],
                ),
                Column(
                  children: [
                    BoxContainers(
                      nextPage: UserPage(),
                      pageName: "Subs Details",
                    ),
                    BoxContainers(
                      nextPage: UserPage(),
                      pageName: "Allergy Details",
                    ),
                  ],
                ),
              ],
            ),
          ],
        )));
  }
}

// class UserDetailsScreen extends StatefulWidget {
//   final Map<String, dynamic> userData;
//   final List<Map<String, dynamic>> profilesData;
//   final bool showProfileDetails;
//   final Function setshowProfileDetails;
//   final String userReferenceId;

//   UserDetailsScreen({
//     required this.userData,
//     required this.profilesData,
//     required this.showProfileDetails,
//     required this.setshowProfileDetails,
//     required this.userReferenceId,
//   });

//   @override
//   _UserDetailsScreenState createState() => _UserDetailsScreenState();
// }

// class _UserDetailsScreenState extends State<UserDetailsScreen> {
//   Map<String, dynamic>? selectedProfile;
//   Map<String, dynamic> selectedUserData = {};

//   Future updateUserDetails(String newName) async {
//     // Update the user's name in Firebase Firestore
//     try {
//       await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(widget.userData['uid']) // Replace with the user's document ID
//           .update({'display_name': newName});

//       // Refresh the user data or perform any other necessary actions
//       // Fetch updated user data from Firebase
//       // setState or update your user data in the widget
//       DocumentSnapshot updatedUserSnapshot = await FirebaseFirestore.instance
//           .collection('Users')
//           .doc(widget.userData['uid']) // Replace with the user's document ID
//           .get();

//       // Update the user data in the widget's state
//       setState(() {
//         selectedUserData = updatedUserSnapshot.data() as Map<String, dynamic>;
//       });
//     } catch (error) {
//       print('Error updating user details: $error');
//     }
//   }

//   Stream<DocumentSnapshot>? userStream; // Declare a stream

//   @override
//   void initState() {
//     super.initState();
//     // Initialize the userStream with the stream that listens to the user's data changes
//     userStream = FirebaseFirestore.instance
//         .collection('Users')
//         .doc(widget.userReferenceId)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<DocumentSnapshot>(
//         stream: userStream, // Listen to the user's data changes
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           if (snapshot.hasError) {
//             return Text('Error: ${snapshot.error}');
//           }

//           // Get the updated user data from the snapshot
//           Map<String, dynamic> updatedUserData =
//               (snapshot.data?.data() ?? {}) as Map<String, dynamic>;
//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Container(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         'User Details',
//                         style: TextStyle(
//                             fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       ElevatedButton(
//                         onPressed: () {
//                           showDialog(
//                             context: context,
//                             builder: (context) => EditUserDialog(
//                               initialName: updatedUserData['display_name'],
//                               onSave: (newName) {
//                                 updateUserDetails(newName);
//                               },
//                             ),
//                           );
//                         },
//                         child: Text('Edit'),
//                       ),
//                     ],
//                   ),
//                   Text('Name: ${updatedUserData['display_name']}'),
//                   Text('Email: ${updatedUserData['email']}'),
//                   Text('Phone Number: ${updatedUserData['phone_number']}'),
//                   // Display other user details as needed

//                   SizedBox(height: 20),

//                   Text(
//                     'Profiles:',
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   Column(
//                     children: widget.profilesData.map((profile) {
//                       return ListTile(
//                         title: Text('Profile Name: ${profile['name']}'),
//                         onTap: () {
//                           setState(() {
//                             selectedProfile = profile;
//                           });
//                           widget.setshowProfileDetails(true, profile);
//                         },
//                       );
//                     }).toList(),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }
// }

// class EditUserDialog extends StatefulWidget {
//   final String initialName;
//   final Function(String) onSave;

//   EditUserDialog({required this.initialName, required this.onSave});

//   @override
//   _EditUserDialogState createState() => _EditUserDialogState();
// }

// class _EditUserDialogState extends State<EditUserDialog> {
//   late TextEditingController _nameController;

//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.initialName);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Edit User Details'),
//       content: TextField(
//         controller: _nameController,
//         decoration: InputDecoration(labelText: 'Name'),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.pop(context); // Close the dialog
//           },
//           child: Text('Cancel'),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             String newName = _nameController.text;
//             widget.onSave(newName); // Call the onSave function
//             Navigator.pop(context); // Close the dialog
//           },
//           child: Text('Save'),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     super.dispose();
//   }
// }

// Add the rest of your code here...

// class ProfileScreen extends StatefulWidget {
//   final Map<String, dynamic> profileData;

//   ProfileScreen({required this.profileData});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Container(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Profile Details',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     // Handle edit button press
//                     // You can navigate to an edit screen or show a dialog
//                   },
//                   child: Text('Edit'),
//                 ),
//               ],
//             ),
//             Text('Name: ${widget.profileData['name']}'),
//             Text('Date of Birth: ${widget.profileData['dob']}'),
//             Text('Gender: ${widget.profileData['gender']}'),
//             // Display other profile details
//           ],
//         ),
//       ),
//     );
//   }
// }
