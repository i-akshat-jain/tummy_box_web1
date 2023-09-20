import '../users/user_details.dart';
import 'package:flutter/material.dart';
import '../profiles/user_profiles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tummy_box_admin_web/orders/orders.dart';
import 'package:tummy_box_admin_web/menu/menu_view.dart';
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
                      nextPage: MenuItems(),
                      pageName: "Menu Details",
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

