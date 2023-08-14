import '../users/userDetails.dart';
import 'package:flutter/material.dart';


class HomeView extends StatefulWidget {
  final Function logoutCallback;

  HomeView({
    required this.logoutCallback,
    Key? key,
  }) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  UserDetailsScreen userDetail = UserDetailsScreen(userData: {});
  bool showUserDetails = false;
  Map<String, dynamic> selectedUserData = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.92,
            color: Colors.blue,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildRowWithWindows(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowWithWindows(context) {
    return Row(
      children: [
        _buildWindow(0, context),
        _buildWindow(1, context),
      ],
    );
  }

  Widget _buildWindow(int windowIndex, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(8.0),
        color: Colors.grey[200],
        child: Column(
          children: [
            Text(
              'Row , Window $windowIndex',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Column(
              children: [
                // Assuming snapshot.data!.docs is available here
                for (var userDoc in snapshot.data!.docs)
                  ListTile(
                    title: Text(userDoc['display_name']),
                    onTap: () async {
                      setState(() {
                        showUserDetails = true;
                      });

                      // Fetch user details by pid
                      final userPid = userDoc['pid'];
                      final userDetails = await UserDetailsScreen(userData: {})
                          .fetchUserReferencesByPid(userPid);

                      setState(() {
                        selectedUserData = userDetails as Map<String, dynamic>;
                      });
                    },
                  ),
              ],
            ),
            if (showUserDetails && windowIndex == 1)
              UserDetailsScreen(userData: selectedUserData),
          ],
        ),
      ),
    );
  }
}
